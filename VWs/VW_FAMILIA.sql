IF EXISTS (SELECT * FROM sys.views  
                WHERE object_id = OBJECT_ID(N'[dbo].[VW_FAMILIA]') 
                  )
BEGIN
	DROP VIEW VW_FAMILIA
END

GO

CREATE VIEW VW_FAMILIA
AS

	SELECT F.ID_FAMILIA, IFA.NOMBRE_FAMILIA, F.NOMBRE_ARCHIVO_IMG, F.ACTIVO, IFA.ID_IDIOMA 
	FROM CFAMILIA F 
		INNER JOIN RIDIOMA_FAMILIA IFA ON F.ID_FAMILIA = IFA.ID_FAMILIA

	
