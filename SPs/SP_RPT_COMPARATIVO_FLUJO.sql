IF EXISTS (SELECT * FROM sys.objects 
                WHERE object_id = OBJECT_ID(N'[dbo].[SP_RPT_COMPARATIVO_FLUJO]') 
                  AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE SP_RPT_COMPARATIVO_FLUJO
END
GO
-- SP_RPT_COMPARATIVO_FLUJO 1, 'B', 1, 2018, 1, 1
CREATE PROCEDURE SP_RPT_COMPARATIVO_FLUJO (
	@ID_COMUNIDAD SMALLINT,	
	@CVE_TIPO_MOVIMIENTO NVARCHAR(1),
	@ID_MONEDA SMALLINT,
	@ANIO SMALLINT,
	@ID_IDIOMA TINYINT,
	@ID_USUARIO SMALLINT
)
--SELECT * FROM DMOVIMIENTO	 
AS
-- OBTIENE EL REPORTE DE FLUJO MENSUAL
BEGIN

	SET NOCOUNT ON;
	DECLARE @REGs INT, @REGS_ANTERIOR INT
	DECLARE @CVE_CULTURE NVARCHAR(5)

	-- PRIMERAMENTE OBTENEMOS LA CULTURA PARA EL FORMATEO DE FECHAS Y MONEDAS
	SELECT @CVE_CULTURE = DBO.FNC_OBTEN_CULTURA(@ID_USUARIO)		

	-- DATOS PRINCIPALES EN UNA TABLA TEMPORAL
	SELECT MES, DESC_MES, SUM(IMPT_ENTRADAS) AS IMPT_ENTRADAS, SUM(IMPT_SALIDAS) AS IMPT_SALIDAS, SUM(IMPORTE) IMPT_TOTAL
		INTO #FLUJO_MENSUAL
	FROM (
		SELECT MES,  DESC_MES, CASE WHEN CVE_TIPO_RUBRO = 'I' THEN IMPORTE ELSE 0 END IMPT_ENTRADAS, CASE WHEN CVE_TIPO_RUBRO = 'E' THEN IMPORTE ELSE 0 END IMPT_SALIDAS, 
		
		CASE WHEN CVE_TIPO_RUBRO = 'I' THEN IMPORTE ELSE -(IMPORTE) END AS IMPORTE

		FROM VW_MOVIMIENTOS M 
		WHERE ID_COMUNIDAD = @ID_COMUNIDAD 
			AND CVE_TIPO_MOVIMIENTO = @CVE_TIPO_MOVIMIENTO 
			AND ID_MONEDA = @ID_MONEDA 
			AND ANIO = @ANIO 		
			AND ID_IDIOMA = @ID_IDIOMA
			AND ACTIVO = 1 
		) D
	GROUP BY MES, DESC_MES
	ORDER BY MES

	SET @REGs = @@ROWCOUNT
	PRINT '@REGs : ' + CAST (@REGs AS NVARCHAR)


	--AHORA EJECUTAMOS LA CONSULTA PARA EL AÑO ANTERIOR
	SELECT MES, DESC_MES, SUM(IMPT_ENTRADAS) AS IMPT_ENTRADAS, SUM(IMPT_SALIDAS) AS IMPT_SALIDAS, SUM(IMPORTE) IMPT_TOTAL
		INTO #FLUJO_MENSUAL_ANTERIOR
	FROM (
		SELECT MES,  DESC_MES, CASE WHEN CVE_TIPO_RUBRO = 'I' THEN IMPORTE ELSE 0 END IMPT_ENTRADAS, CASE WHEN CVE_TIPO_RUBRO = 'E' THEN IMPORTE ELSE 0 END IMPT_SALIDAS, 
		
		CASE WHEN CVE_TIPO_RUBRO = 'I' THEN IMPORTE ELSE -(IMPORTE) END AS IMPORTE

		FROM VW_MOVIMIENTOS M 
		WHERE ID_COMUNIDAD = @ID_COMUNIDAD 
			AND CVE_TIPO_MOVIMIENTO = @CVE_TIPO_MOVIMIENTO 
			AND ID_MONEDA = @ID_MONEDA 
			AND ANIO = @ANIO - 1
			AND ID_IDIOMA = @ID_IDIOMA
			AND ACTIVO = 1 
		) D
	GROUP BY MES, DESC_MES
	ORDER BY MES
	SET @REGS_ANTERIOR = @@ROWCOUNT
	PRINT '@REGS_ANTERIOR : ' + CAST (@REGS_ANTERIOR AS NVARCHAR)

	-- HAY INFORMACIÓN PAEA EL AÑO ACTUAL O ANTERIOR ?
	IF @REGs > 0 OR @REGS_ANTERIOR > 0
	BEGIN
		-- DATOS CABECERA
		SELECT (SELECT DESC_COMUNIDAD FROM CCOMUNIDAD WHERE ID_COMUNIDAD = @ID_COMUNIDAD) AS DESC_COMUNIDAD,
			(SELECT SIGLAS FROM VW_MONEDA WHERE ID_MONEDA = @ID_MONEDA AND ID_IDIOMA = @ID_IDIOMA) AS DESC_MONEDA,			
			DBO.FNC_OBTEN_FECHA_ACTUAL_TEXTO(@ID_IDIOMA, 1) AS FECHA_ACTUAL,
			@ANIO as ANIO,
			dbo.FNC_OBTEN_DESC_ETIQUETA_POR_CVE(@ID_IDIOMA, 140200, 'titReporte') AS TITULO_REPORTE

		SELECT CVE_ETIQUETA, DESCRIPCION 
		FROM VW_ETIQUETA
		WHERE ID_IDIOMA =  @ID_IDIOMA 
			AND ID_MODULO = 140200 
			AND CVE_ETIQUETA LIKE 'lblRpt%'

		-- DATOS PREVIOS DEL AÑO ACUTAL
		SELECT M.ID_MES AS MES, M.DESC_MES, ISNULL( D.IMPT_ENTRADAS, 0.00) AS IMPT_ENTRADAS, ISNULL(IMPT_SALIDAS, 0.00) AS IMPT_SALIDAS, ISNULL(IMPT_TOTAL, 0.00) AS IMPT_TOTAL
			INTO #FLUJO_MENSUAL_FINAL
		FROM 
			(
				SELECT ID_MES , DESC_MES FROM VW_MES WHERE ID_IDIOMA = @ID_IDIOMA
			) M 
			LEFT JOIN #FLUJO_MENSUAL D ON D.MES = M.ID_MES
		
		-- DATOS PREVIOS DEL AÑO ANTERIOR
		SELECT M.ID_MES AS MES_ANTERIOR, M.DESC_MES AS DESC_MES_ANTERIOR, ISNULL( D.IMPT_ENTRADAS, 0.00) AS IMPT_ENTRADAS_ANTERIOR, ISNULL(IMPT_SALIDAS, 0.00) AS IMPT_SALIDAS_ANTERIOR, ISNULL(IMPT_TOTAL, 0.00) AS IMPT_TOTAL_ANTERIOR
		into #FLUJO_MENSUAL_ANTERIOR_FINAL
		FROM 
			(
				SELECT ID_MES , DESC_MES FROM VW_MES WHERE ID_IDIOMA = @ID_IDIOMA
			) M 
			LEFT JOIN #FLUJO_MENSUAL_ANTERIOR D ON D.MES = M.ID_MES
		
		-- DATOS PRINCIPALES (TODOS LOS MESES AUNQUE TENGAN CERO)
		SELECT MES, DESC_MES, FORMAT(ACT.IMPT_ENTRADAS, 'C', @CVE_CULTURE) AS IMPT_ENTRADAS , FORMAT(ACT.IMPT_SALIDAS, 'C', @CVE_CULTURE) IMPT_SALIDAS, 
			FORMAT(ACT.IMPT_TOTAL, 'C', @CVE_CULTURE) AS IMPT_TOTAL, FORMAT(ANT.IMPT_ENTRADAS_ANTERIOR, 'C', @CVE_CULTURE) AS IMPT_ENTRADAS_ANTERIOR, 
			FORMAT(ANT.IMPT_SALIDAS_ANTERIOR, 'C', @CVE_CULTURE) AS IMPT_SALIDAS_ANTERIOR, FORMAT(ANT.IMPT_TOTAL_ANTERIOR, 'C', @CVE_CULTURE) AS IMPT_TOTAL_ANTERIOR
		FROM #FLUJO_MENSUAL_FINAL ACT
			INNER JOIN #FLUJO_MENSUAL_ANTERIOR_FINAL ANT ON ACT.MES = ANT.MES_ANTERIOR

		--DATOS TOTALES
		SELECT FORMAT(SUM(IMPT_ENTRADAS), 'C', @CVE_CULTURE) AS IMPT_ENTRADAS, FORMAT(SUM(IMPT_SALIDAS), 'C', @CVE_CULTURE) AS IMPT_SALIDAS , 
			FORMAT(SUM(IMPT_TOTAL), 'C', @CVE_CULTURE) AS IMPT_TOTAL, FORMAT(SUM(IMPT_ENTRADAS_ANTERIOR), 'C', @CVE_CULTURE) AS IMPT_ENTRADAS_ANTERIOR, 
			FORMAT(SUM(IMPT_SALIDAS_ANTERIOR), 'C', @CVE_CULTURE) AS IMPT_SALIDAS_ANTERIOR, FORMAT(SUM(IMPT_TOTAL_ANTERIOR), 'C', @CVE_CULTURE) AS IMPT_TOTAL_ANTERIOR
		FROM #FLUJO_MENSUAL_FINAL ACT 
			INNER JOIN #FLUJO_MENSUAL_ANTERIOR_FINAL ANT ON ACT.MES = ANT.MES_ANTERIOR

	END
	ELSE
	BEGIN
		PRINT 'NO HAY DATOS'
		SELECT DESC_MENSAJE , CVE_TIPO_MSG 
		FROM VW_MENSAJES 
		WHERE ID_IDIOMA = @ID_IDIOMA AND ID_MENSAJE = -3
	END



END

