IF EXISTS (SELECT * FROM sys.objects 
                WHERE object_id = OBJECT_ID(N'[dbo].[SP_ADD_CAJA_APERTURA]') 
                  AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE SP_ADD_CAJA_APERTURA
END

GO
CREATE PROCEDURE SP_ADD_CAJA_APERTURA  
	@NUM_CAJA TINYINT,
	@EFECTIVO_INICIAL MONEY,
	@ID_COMUNIDAD INT,
	@ID_USUARIO INT,
	@ID_IDIOMA SMALLINT
	
AS  
/*  
SP_ADD_CAJA_APERTURA  
AGREGA UN REGISTRO EN DCAJA_APERTURA
*/  
BEGIN  
	SET NOCOUNT OFF  
	
	DECLARE @ID_CAJA SMALLINT
	DECLARE @DESC_MENSAJE NVARCHAR(100)	
	DECLARE @CVE_TIPO_MSG  NVARCHAR(1)

	-- VALOR POR DAFULT
	SET @ID_CAJA = 0

	-- HAY QUE VALIDAR PRIMERO SI ESTE USUARIO YA TIENE UNA CAJA ABIERTA
	IF NOT EXISTS(SELECT ID_CAJA FROM DCAJA_APERTURA WHERE ID_USUARIO = @ID_USUARIO AND ID_ESTATUS_CAJA = 1)
	BEGIN
		-- SE INSERTA
		INSERT INTO DCAJA_APERTURA (NUM_CAJA, FECHA_HORA_INICIO, EFECTIVO_INICIAL, ID_COMUNIDAD, ID_USUARIO, ID_ESTATUS_CAJA)
		VALUES (@NUM_CAJA, DBO.FNC_FECHA_HORA_ACTUAL(GETDATE()), @EFECTIVO_INICIAL, @ID_COMUNIDAD, @ID_USUARIO, 1) --ABIERTA

		SET @ID_CAJA = @@IDENTITY

		IF @ID_CAJA > 0		
			SELECT @DESC_MENSAJE = DESC_MENSAJE, @CVE_TIPO_MSG = CVE_TIPO_MSG 
			FROM VW_MENSAJES
			WHERE ID_IDIOMA = @ID_IDIOMA AND  ID_MENSAJE = 1 
		ELSE
			SELECT @DESC_MENSAJE = DESC_MENSAJE, @CVE_TIPO_MSG = CVE_TIPO_MSG 
			FROM VW_MENSAJES
			WHERE ID_IDIOMA = @ID_IDIOMA AND  ID_MENSAJE = -1
   END
   ELSE
   BEGIN
		PRINT 'YA EST� ABIERTA UNA CAJA DE ESTE USUARIO'
		SELECT @DESC_MENSAJE = DESC_MENSAJE, @CVE_TIPO_MSG = CVE_TIPO_MSG 
		FROM VW_MENSAJES
		WHERE ID_IDIOMA = @ID_IDIOMA AND  ID_MENSAJE = 35
   END
	

	-- REGRESAMOS EL MENSAJE QUE APLIQUE	
	SELECT @ID_CAJA AS ID,  @DESC_MENSAJE AS  DESC_MENSAJE, @CVE_TIPO_MSG AS CVE_TIPO_MSG

END  

GO
