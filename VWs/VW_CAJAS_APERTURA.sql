IF EXISTS (SELECT * FROM sys.views  
                WHERE object_id = OBJECT_ID(N'[dbo].[VW_CAJAS_APERTURA]') 
                  )
BEGIN
	DROP VIEW VW_CAJAS_APERTURA
END

GO

CREATE VIEW VW_CAJAS_APERTURA
AS

	SELECT ID_CAJA, NUM_CAJA, FECHA_HORA_INICIO, FECHA_HORA_FIN, EFECTIVO_INICIAL, E.DESC_ESTATUS_CAJA, COM.ID_COMUNIDAD, COM.DESC_COMUNIDAD, ID_USUARIO, E.ID_IDIOMA
	FROM DCAJA_APERTURA CAJA 
		INNER JOIN CCOMUNIDAD COM ON CAJA.ID_COMUNIDAD = COM.ID_COMUNIDAD
		INNER JOIN VW_ESTATUS_CAJA E ON CAJA.ID_ESTATUS_CAJA = E.ID_ESTATUS_CAJA
		
		
		

	