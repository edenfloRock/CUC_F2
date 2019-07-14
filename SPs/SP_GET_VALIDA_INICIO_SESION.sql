IF EXISTS (SELECT * FROM sys.objects 
                WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_VALIDA_INICIO_SESION]') 
                  AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE SP_GET_VALIDA_INICIO_SESION
END

GO
CREATE PROCEDURE SP_GET_VALIDA_INICIO_SESION  
 @CVE_USUARIO NVARCHAR(30),  
 @CONTRASENIA NVARCHAR(255)
AS  
/*  
SP_GET_VALIDA_INICIO_SESION  'TESO', '09a7676480b2da892164cb1ad50414dc'
SELECT * FROM SUSUARIO
*/  
BEGIN  
	SET NOCOUNT OFF  
	
	DECLARE @ID_USUARIO SMALLINT
	DECLARE @ID_PERFIL SMALLINT
	DECLARE @DESC_COMUNIDAD NVARCHAR(30)
	DECLARE @DESC_USUARIO NVARCHAR(50)
	DECLARE @ID_IDIOMA TINYINT
	DECLARE @ID_COMUNIDAD SMALLINT
	DECLARE @ID_PAIS SMALLINT
	DECLARE @ADMIN_COMUNI BIT
	DECLARE @CODIGO_RESETEO SMALLINT -- 1.- INDICA SI SE DEBE PEDIR LA NUEVA CONTRASE�A
	DECLARE @TOTAL_COMU SMALLINT
	DECLARE @FECHA_HOY NVARCHAR(10)
	DECLARE @HAY_AVISO TINYINT
	DECLARE @DESC_AVISO NVARCHAR(200)
	DECLARE @CVE_TIPO_MSG NVARCHAR(1)

	SELECT @ID_PERFIL = ID_PERFIL, @DESC_USUARIO = DESC_USUARIO , @ID_IDIOMA = ID_IDIOMA, 
		@ID_COMUNIDAD = U.ID_COMUNIDAD, 		
		@DESC_COMUNIDAD = DESC_COMUNIDAD, 
		--@ADMIN_COMUNI = ADMIN_COMUNI, 
		@CODIGO_RESETEO = CODIGO_RESETEO, @ID_USUARIO = ID_USUARIO
	FROM SUSUARIO U 
		LEFT JOIN CCOMUNIDAD C ON U.ID_COMUNIDAD = C.ID_COMUNIDAD
	WHERE CVE_USUARIO = @CVE_USUARIO AND CONTRASENIA = @CONTRASENIA AND U.ACTIVO = 1

	IF @ID_PERFIL IS NOT NULL
	BEGIN
		-- SE OBTIENE EL PAIS DE LA COMUIDAD DEL USUARIO
		SELECT @ID_PAIS = ID_PAIS FROM CCOMUNIDAD WHERE ID_COMUNIDAD = @ID_COMUNIDAD

		-- AHORA CONTAMOS CU�NTAS COMNIDADES TIENE ASIGNADA EL USUARIO
		SELECT @TOTAL_COMU = COUNT(*) FROM RUSUARIO_COMUNIDAD WHERE ID_USUARIO = @ID_USUARIO
		
		IF @TOTAL_COMU = 1
		BEGIN
			SET @ADMIN_COMUNI = 0
			-- SETEAMOS LOS VALORES DE ESA COMUNIDAD
			SELECT TOP 1 @ID_COMUNIDAD = UC.ID_COMUNIDAD , @DESC_COMUNIDAD = CO.DESC_COMUNIDAD 
			FROM RUSUARIO_COMUNIDAD UC 
				INNER JOIN CCOMUNIDAD CO ON UC.ID_COMUNIDAD = CO.ID_COMUNIDAD AND UC.ID_USUARIO = @ID_USUARIO
			
		END
		ELSE
			SET @ADMIN_COMUNI = 1

		-- VAMOS A VALIDAR SI SE TIENE UN AVISO		

		--SELECT DATEADD(HOUR, -6,GETDATE())

		SELECT @FECHA_HOY = CONVERT(NVARCHAR,DATEADD(HOUR, -6,GETDATE()), 103)
		PRINT '@FECHA_HOY: ' + @FECHA_HOY
		SET @FECHA_HOY = DBO.FNC_FECHA_FORMATO(@FECHA_HOY)
		PRINT 'CONVERTIDA: @FECHA_HOY: ' + @FECHA_HOY
		
		SELECT @DESC_AVISO = I.DESC_MENSAJE, @HAY_AVISO = CASE WHEN I.DESC_MENSAJE IS NOT NULL THEN 1 ELSE 0 END, @CVE_TIPO_MSG = A.CVE_TIPO_MSG 
		FROM DAVISOS A 
			INNER JOIN RIDIOMA_AVISOS I ON A.ID_AVISO = I.ID_AVISO AND I.ID_IDIOMA = @ID_IDIOMA
		WHERE @FECHA_HOY BETWEEN A.FECHA_INI AND A.FECHA_FIN AND ACTIVO = 1

		--  RESULSET(0) REGRESMO LOS DATOS DEL USUARIO
		SELECT @ID_PERFIL AS ID_PERFIL, @DESC_USUARIO AS NOMBRE_USUARIO, @ID_IDIOMA AS ID_IDIOMA,  ISNULL(@ID_PAIS,0) AS ID_PAIS,
			 @ID_COMUNIDAD AS ID_COMUNIDAD, @ADMIN_COMUNI AS ADMIN_COMUNI, @DESC_COMUNIDAD AS DESC_COMUNIDAD, @CODIGO_RESETEO AS CODIGO_RESETEO, @CVE_USUARIO AS CVE_USUARIO,
				(SELECT DESCRIPCION FROM DETIQUETAS WHERE ID_MODULO = 110000 AND CVE_ETIQUETA = 'lblSesion' and ID_IDIOMA = @ID_IDIOMA) AS LBL_SESION, @ID_USUARIO AS ID_USUARIO,
				ISNULL(@HAY_AVISO, 0) AS HAY_AVISO, ISNULL(@DESC_AVISO, '') AS DESC_AVISO, ISNULL(@CVE_TIPO_MSG, '') AS CVE_TIPO_MSG
		
		-- RESULSET(1) SOLO LOS M�DULOS PRINCIPALES
		SELECT M.ID_MODULO, IM.NOMBRE_MODULO 
		FROM SMODULO M 
			INNER JOIN RIDIOMA_MODULO IM ON M.ID_MODULO = IM.ID_MODULO 
		WHERE ID_MODULO_P = 0 AND IM.ID_IDIOMA = @ID_IDIOMA	AND M.ID_MODULO IN (
				SELECT DISTINCT M.ID_MODULO_P 
			FROM SMODULO_PERFIL  MP 
				INNER JOIN SMODULO M ON MP.ID_MODULO = M.ID_MODULO
				INNER JOIN  RIDIOMA_MODULO IM ON M.ID_MODULO = IM.ID_MODULO
			WHERE ID_PERFIL = @ID_PERFIL AND ID_MODULO_P > 0 AND IM.ID_IDIOMA = @ID_IDIOMA
			)
		

		/*
		-- RESULSET(2)
		SELECT MP.ID_MODULO, IM.NOMBRE_MODULO, M.ID_MODULO_P 
		FROM SMODULO_PERFIL  MP 
			INNER JOIN SMODULO M ON MP.ID_MODULO = M.ID_MODULO
			INNER JOIN  RIDIOMA_MODULO IM ON M.ID_MODULO = IM.ID_MODULO
		WHERE ID_PERFIL = @ID_PERFIL AND ID_MODULO_P > 0 AND IM.ID_IDIOMA = @ID_IDIOMA
		*/

		--RESULSET(3)
		-- MENSAJE DE CONTRASE�AS NO COINCIDEN
		SELECT DESC_MENSAJE, CVE_TIPO_MSG 
		FROM VW_MENSAJES
		WHERE ID_IDIOMA = @ID_IDIOMA AND  ID_MENSAJE = 25

		--SELECT * FROM SMODULO
		--SELECT * FROM RIDIOMA_MODULO WHERE ID_IDIOMA = 1

	END
	ELSE
		SELECT 0 AS ID_PERFIL, 'EL USUARIO Y/O CONTRASE�A SON INCORRECTOS' MENSAJE


END  

GO
