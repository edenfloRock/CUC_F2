-- SCRIPTs DE TABLAS NUEVAS FASE 2
--prueba segundo commit en hithub
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CFAMILIA]') AND type in (N'U'))
    DROP TABLE [dbo].[CFAMILIA]
GO
CREATE TABLE [dbo].[CFAMILIA] (
[ID_FAMILIA] int identity  NOT NULL  
, [NOMBRE_FAMILIA] nvarchar(20)  NOT NULL  
, [NOMBRE_ARCHIVO_IMG] nvarchar(100)  NULL  
, [ACTIVO] bit  NOT NULL  
)
GO

ALTER TABLE [dbo].[CFAMILIA] ADD CONSTRAINT [CFAMILIA_PK] PRIMARY KEY CLUSTERED (
[ID_FAMILIA]
)
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RIDIOMA_FAMILIA]') AND type in (N'U'))
    DROP TABLE [dbo].[RIDIOMA_FAMILIA]
GO
CREATE TABLE [dbo].[RIDIOMA_FAMILIA] (
[ID_IDIOMA] tinyint  NOT NULL  
, [ID_FAMILIA] int  NOT NULL  
, [NOMBRE_FAMILIA] nvarchar(20)  NOT NULL  
)
GO

ALTER TABLE [dbo].[RIDIOMA_FAMILIA] ADD CONSTRAINT [RIDIOMA_FAMILIA_PK] PRIMARY KEY CLUSTERED (
[ID_IDIOMA]
, [ID_FAMILIA]
)
GO

ALTER TABLE [dbo].[RIDIOMA_FAMILIA] WITH CHECK ADD CONSTRAINT [FK_CFAMILIA_RIDIOMA_FAMILIA] FOREIGN KEY (
[ID_FAMILIA]
)
REFERENCES [dbo].[CFAMILIA] (
[ID_FAMILIA]
)
ALTER TABLE [dbo].[RIDIOMA_FAMILIA] WITH CHECK ADD CONSTRAINT [FK_CIDIOMA_RIDIOMA_FAMILIA] FOREIGN KEY (
[ID_IDIOMA]
)
REFERENCES [dbo].[CIDIOMA] (
[ID_IDIOMA]
)
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CARTICULO]') AND type in (N'U'))
    DROP TABLE [dbo].[CARTICULO]
GO
CREATE TABLE [dbo].[CARTICULO] (
[ID_ARTICULO] int identity  NOT NULL  
, [CVE_FABRICANTE] nvarchar(30)  NOT NULL  
, [PRECIO] money  NOT NULL  
, [ID_FAMILIA] int  NULL  
, [NOMBRE_ARCHIVO_IMG] nvarchar(100)  NULL  
, [DESCRIPCION] nvarchar(30)  NULL  
, [DESCRIPCION_DETALLADA] nvarchar(100)  NULL  
, [MOSTRARSE_COMBO] bit  NOT NULL  
, [ACTIVO] bit  NOT NULL  
)
GO

ALTER TABLE [dbo].[CARTICULO] ADD CONSTRAINT [CARTICULO_PK] PRIMARY KEY CLUSTERED (
[ID_ARTICULO]
)
GO


ALTER TABLE [dbo].[CARTICULO] WITH CHECK ADD CONSTRAINT [FK_CFAMILIA_CARTICULO] FOREIGN KEY (
[ID_FAMILIA]
)
REFERENCES [dbo].[CFAMILIA] (
[ID_FAMILIA]
)
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RIDIOMA_ARTICULO]') AND type in (N'U'))
    DROP TABLE [dbo].[RIDIOMA_ARTICULO]
GO
CREATE TABLE [dbo].[RIDIOMA_ARTICULO] (
[ID_IDIOMA] tinyint  NOT NULL  
, [ID_ARTICULO] int  NOT NULL  
, [DESCRIPCION] nvarchar(30)  NOT NULL  
, [DESCRIPCION_DETALLADA] nvarchar(100)  NOT NULL  
)
GO

ALTER TABLE [dbo].[RIDIOMA_ARTICULO] ADD CONSTRAINT [RIDIOMA_ARTICULO_PK] PRIMARY KEY CLUSTERED (
[ID_IDIOMA]
, [ID_ARTICULO]
)
GO
GO


ALTER TABLE [dbo].[RIDIOMA_ARTICULO] WITH CHECK ADD CONSTRAINT [FK_CIDIOMA_RIDIOMA_ARTICULO] FOREIGN KEY (
[ID_IDIOMA]
)
REFERENCES [dbo].[CIDIOMA] (
[ID_IDIOMA]
)
ALTER TABLE [dbo].[RIDIOMA_ARTICULO] WITH CHECK ADD CONSTRAINT [FK_CARTICULO_RIDIOMA_ARTICULO] FOREIGN KEY (
[ID_ARTICULO]
)
REFERENCES [dbo].[CARTICULO] (
[ID_ARTICULO]
)
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DCAJA_APERTURA]') AND type in (N'U'))
    DROP TABLE [dbo].[DCAJA_APERTURA]
GO
CREATE TABLE [dbo].[DCAJA_APERTURA] (
[ID_CAJA] int IDENTITY(1,1) NOT NULL  
, [NUM_CAJA] tinyint  NOT NULL  
, [FECHA_HORA_INICIO] smalldatetime  NOT NULL  
, [EFECTIVO_INICIAL] money  NOT NULL  
, [ID_COMUNIDAD] smallint  NOT NULL  
, [ID_USUARIO] smallint  NOT NULL  
, [FECHA_HORA_FIN] smalldatetime  NULL  
, [ID_ESTATUS_CAJA] tinyint  NOT NULL  
)
GO

ALTER TABLE [dbo].[DCAJA_APERTURA] ADD CONSTRAINT [DCAJA_APERTURA_PK] PRIMARY KEY CLUSTERED (
[ID_CAJA]
)
GO
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CESTATUS_CAJA]') AND type in (N'U'))
    DROP TABLE [dbo].[CESTATUS_CAJA]
GO
CREATE TABLE [dbo].[CESTATUS_CAJA] (
[ID_ESTATUS_CAJA] tinyint  IDENTITY(1,1) NOT NULL  
, [DESC_ESTATUS_CAJA] nvarchar(10)  NOT NULL  
)
GO

ALTER TABLE [dbo].[CESTATUS_CAJA] ADD CONSTRAINT [CESTATUS_CAJA_PK] PRIMARY KEY CLUSTERED (
[ID_ESTATUS_CAJA]
)
GO
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RIDIOMA_ESTATUS_CAJA]') AND type in (N'U'))
    DROP TABLE [dbo].[RIDIOMA_ESTATUS_CAJA]
GO
CREATE TABLE [dbo].[RIDIOMA_ESTATUS_CAJA] (
[ID_IDIOMA] tinyint  NOT NULL  
, [ID_ESTATUS_CAJA] tinyint  NOT NULL  
, DESC_ESTATUS_CAJA NVARCHAR(10) NOT NULL
)
GO

ALTER TABLE [dbo].[RIDIOMA_ESTATUS_CAJA] ADD CONSTRAINT [RIDIOMA_ESTATUS_CAJA_PK] PRIMARY KEY CLUSTERED (
[ID_IDIOMA]
, [ID_ESTATUS_CAJA]
)
GO
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CESTATUS_CONSIGNACION]') AND type in (N'U'))
    DROP TABLE [dbo].[CESTATUS_CONSIGNACION]
GO
CREATE TABLE [dbo].[CESTATUS_CONSIGNACION] (
[ID_ESTATUS_CONSIGNACION] tinyint  IDENTITY(1,1) NOT NULL  
, [DESC_ESTATUS_CONSIGNACION] nvarchar(15)  NOT NULL  
)
GO

ALTER TABLE [dbo].[CESTATUS_CONSIGNACION] ADD CONSTRAINT [CESTATUS_CONSIGNACION_PK] PRIMARY KEY CLUSTERED (
[ID_ESTATUS_CONSIGNACION]
)
GO
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RIDIOMA_ESTATUS_CONSIGNACION]') AND type in (N'U'))
    DROP TABLE [dbo].[RIDIOMA_ESTATUS_CONSIGNACION]
GO
CREATE TABLE [dbo].[RIDIOMA_ESTATUS_CONSIGNACION] (
[ID_IDIOMA] tinyint  NOT NULL  
, [ID_ESTATUS_CONSIGNACION] tinyint  NOT NULL  
)
GO

ALTER TABLE [dbo].[RIDIOMA_ESTATUS_CONSIGNACION] ADD CONSTRAINT [RIDIOMA_ESTATUS_CONSIGNACION_PK] PRIMARY KEY CLUSTERED (
[ID_IDIOMA]
, [ID_ESTATUS_CONSIGNACION]
)
GO
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CFORMA_PAGO]') AND type in (N'U'))
    DROP TABLE [dbo].[CFORMA_PAGO]
GO
CREATE TABLE [dbo].[CFORMA_PAGO] (
[ID_FORMA_PAGO] tinyint  IDENTITY(1,1) NOT NULL  
, [DESC_FORMA_PAGO] nvarchar(30)  NULL  
)
GO

ALTER TABLE [dbo].[CFORMA_PAGO] ADD CONSTRAINT [CFORMA_PAGO_PK] PRIMARY KEY CLUSTERED (
[ID_FORMA_PAGO]
)
GO
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RIDIOMA_FORMA_PAGO]') AND type in (N'U'))
    DROP TABLE [dbo].[RIDIOMA_FORMA_PAGO]
GO
CREATE TABLE [dbo].[RIDIOMA_FORMA_PAGO] (
[ID_IDIOMA] tinyint  NOT NULL  
, [ID_FORMA_PAGO] tinyint  NOT NULL  
)
GO

ALTER TABLE [dbo].[RIDIOMA_FORMA_PAGO] ADD CONSTRAINT [RIDIOMA_FORMA_PAGO_PK] PRIMARY KEY CLUSTERED (
[ID_IDIOMA]
, [ID_FORMA_PAGO]
)
GO
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DVENTA]') AND type in (N'U'))
    DROP TABLE [dbo].[DVENTA]
GO
CREATE TABLE [dbo].[DVENTA] (
[ID_VENTA] int  IDENTITY(1,1) NOT NULL  
, [FOLIO] nvarchar(10)  NULL  
, [FECHA_HORA] smalldatetime  NOT NULL  
, [ID_CAJA] int  NOT NULL  
, [IMPORTE] money  NOT NULL  
, [CON_FACTURA] bit  NOT NULL  
, [ID_ESTATUS_CONSIGNACION] tinyint  NULL  
, [ID_VENTA_PADRE] int  NULL  
, [ESTA_CERRADA] bit  NOT NULL  
, [ID_CONSIGNATARIO] int  NULL  
)
GO

ALTER TABLE [dbo].[DVENTA] ADD CONSTRAINT [DVENTA_PK] PRIMARY KEY CLUSTERED (
[ID_VENTA]
)
GO
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RVENTA_FORMA_PAGO]') AND type in (N'U'))
    DROP TABLE [dbo].[RVENTA_FORMA_PAGO]
GO
CREATE TABLE [dbo].[RVENTA_FORMA_PAGO] (
[ID_VENTA] int  NOT NULL  
, [ID_FORMA_PAGO] tinyint  NOT NULL  
)
GO

ALTER TABLE [dbo].[RVENTA_FORMA_PAGO] ADD CONSTRAINT [RVENTA_FORMA_PAGO_PK] PRIMARY KEY CLUSTERED (
[ID_VENTA]
, [ID_FORMA_PAGO]
)
GO
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DVENTA_DETALLE]') AND type in (N'U'))
    DROP TABLE [dbo].[DVENTA_DETALLE]
GO
CREATE TABLE [dbo].[DVENTA_DETALLE] (
[ID_DETALLE] int  IDENTITY(1,1) NOT NULL  
, [ID_VENTA] int  NOT NULL  
, [ID_ARTICULO] int  NOT NULL  
, [CANTIDAD] smallint  NOT NULL  
, [PRECIO_UNITARIO] money  NOT NULL  
, [IMPORTE_TOTAL] money  NOT NULL  
, [DESCUENTO] float  NOT NULL  
)
GO

ALTER TABLE [dbo].[DVENTA_DETALLE] ADD CONSTRAINT [DVENTA_DETALLE_PK] PRIMARY KEY CLUSTERED (
[ID_DETALLE]
)
GO
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DMOVIMIENTO_ARTICULO]') AND type in (N'U'))
    DROP TABLE [dbo].[DMOVIMIENTO_ARTICULO]
GO
CREATE TABLE [dbo].[DMOVIMIENTO_ARTICULO] (
[ID_MOVIMIENTO_ARTICULO] int  IDENTITY(1,1) NOT NULL  
, [ID_ARTICULO] int  NOT NULL  
, [FECHA_MOVIMIENTO] smalldatetime  NOT NULL  
, [CVE_TIPO_MOV_ART] char(1)  NOT NULL  
, [CANTIDAD] smallint  NOT NULL  
, [COMENTARIOS] nvarchar(300)  NULL  
)
GO

ALTER TABLE [dbo].[DMOVIMIENTO_ARTICULO] ADD CONSTRAINT [DMOVIMIENTO_ARTICULO_PK] PRIMARY KEY CLUSTERED (
[ID_MOVIMIENTO_ARTICULO]
)
GO
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CTIPO_MOVIMIENTO_ART]') AND type in (N'U'))
    DROP TABLE [dbo].[CTIPO_MOVIMIENTO_ART]
GO
CREATE TABLE [dbo].[CTIPO_MOVIMIENTO_ART] (
[CVE_TIPO_MOV_ART] char(1)  NOT NULL  
, [DESC_TIPO_MOV_ART] nvarchar(20)  NULL  
)
GO

ALTER TABLE [dbo].[CTIPO_MOVIMIENTO_ART] ADD CONSTRAINT [CTIPO_MOVIMIENTO_ART_PK] PRIMARY KEY CLUSTERED (
[CVE_TIPO_MOV_ART]
)
GO
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RIDIOMA_TIPO_MOV_ART]') AND type in (N'U'))
    DROP TABLE [dbo].[RIDIOMA_TIPO_MOV_ART]
GO
CREATE TABLE [dbo].[RIDIOMA_TIPO_MOV_ART] (
[ID_IDIOMA] tinyint  NOT NULL  
, [CVE_TIPO_MOV_ART] char(1)  NOT NULL  
, [DESC_TIPO_MOV_ART] nvarchar(20)  NOT NULL  
)
GO

ALTER TABLE [dbo].[RIDIOMA_TIPO_MOV_ART] ADD CONSTRAINT [RIDIOMA_TIPO_MOV_ART_PK] PRIMARY KEY CLUSTERED (
[CVE_TIPO_MOV_ART]
, [ID_IDIOMA]
)
GO
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CCONSIGNATARIO]') AND type in (N'U'))
    DROP TABLE [dbo].[CCONSIGNATARIO]
GO
CREATE TABLE [dbo].[CCONSIGNATARIO] (
[ID_CONSIGNATARIO] int  IDENTITY(1,1) NOT NULL  
, [NOMBRE_COMPLETO] nvarchar(100)  NOT NULL  
, [ID_COMUNIDAD] smallint  NULL ,
[ACTIVO] bit  NULL  
)
GO

ALTER TABLE [dbo].[CCONSIGNATARIO] ADD CONSTRAINT [CCONSIGNATARIO_PK] PRIMARY KEY CLUSTERED (
[ID_CONSIGNATARIO]
)
GO
GO

ALTER TABLE [dbo].[CCONSIGNATARIO] WITH CHECK ADD CONSTRAINT [FK_SESTATUS_ACTIVO_CCONSIGNATARIO] FOREIGN KEY (
[ACTIVO]
)
REFERENCES [dbo].[SESTATUS_ACTIVO] (
[ACTIVO]
)
GO




IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RCOMUNIDAD_ARTICULO]') AND type in (N'U'))
    DROP TABLE [dbo].[RCOMUNIDAD_ARTICULO]
GO
CREATE TABLE [dbo].[RCOMUNIDAD_ARTICULO] (
[ID_COMUNIDAD] smallint  NOT NULL  
, [ID_ARTICULO] int  NOT NULL  
, [EXISTENCIA] smallint  NOT NULL  
)
GO

ALTER TABLE [dbo].[RCOMUNIDAD_ARTICULO] ADD CONSTRAINT [RCOMUNIDAD_ARTICULO_PK] PRIMARY KEY CLUSTERED (
[ID_COMUNIDAD]
, [ID_ARTICULO]
)
GO


ALTER TABLE [dbo].[RCOMUNIDAD_ARTICULO] WITH CHECK ADD CONSTRAINT [FK_CARTICULO_RCOMUNIDAD_ARTICULO] FOREIGN KEY (
[ID_ARTICULO]
)
REFERENCES [dbo].[CARTICULO] (
[ID_ARTICULO]
)
ALTER TABLE [dbo].[RCOMUNIDAD_ARTICULO] WITH CHECK ADD CONSTRAINT [FK_CCOMUNIDAD_RCOMUNIDAD_ARTICULO] FOREIGN KEY (
[ID_COMUNIDAD]
)
REFERENCES [dbo].[CCOMUNIDAD] (
[ID_COMUNIDAD]
)
GO







ALTER TABLE [dbo].[RIDIOMA_TIPO_MOV_ART] WITH CHECK ADD CONSTRAINT [FK_CTIPO_MOVIMIENTO_ART_RIDIOMA_TIPO_MOV_ART] FOREIGN KEY (
[CVE_TIPO_MOV_ART]
)
REFERENCES [dbo].[CTIPO_MOVIMIENTO_ART] (
[CVE_TIPO_MOV_ART]
)
ALTER TABLE [dbo].[RIDIOMA_TIPO_MOV_ART] WITH CHECK ADD CONSTRAINT [FK_CIDIOMA_RIDIOMA_TIPO_MOV_ART] FOREIGN KEY (
[ID_IDIOMA]
)
REFERENCES [dbo].[CIDIOMA] (
[ID_IDIOMA]
)
GO

ALTER TABLE [dbo].[DCAJA_APERTURA] WITH CHECK ADD CONSTRAINT [FK_CCOMUNIDAD_DCAJA_APERTURA] FOREIGN KEY (
[ID_COMUNIDAD]
)
REFERENCES [dbo].[CCOMUNIDAD] (
[ID_COMUNIDAD]
)
ALTER TABLE [dbo].[DCAJA_APERTURA] WITH CHECK ADD CONSTRAINT [FK_SUSUARIO_DCAJA_APERTURA] FOREIGN KEY (
[ID_USUARIO]
)
REFERENCES [dbo].[SUSUARIO] (
[ID_USUARIO]
)
ALTER TABLE [dbo].[DCAJA_APERTURA] WITH CHECK ADD CONSTRAINT [FK_CESTATUS_CAJA_DCAJA_APERTURA] FOREIGN KEY (
[ID_ESTATUS_CAJA]
)
REFERENCES [dbo].[CESTATUS_CAJA] (
[ID_ESTATUS_CAJA]
)
GO


ALTER TABLE [dbo].[RIDIOMA_ESTATUS_CONSIGNACION] WITH CHECK ADD CONSTRAINT [FK_CIDIOMA_RIDIOMA_ESTATUS_CONSIGNACION] FOREIGN KEY (
[ID_IDIOMA]
)
REFERENCES [dbo].[CIDIOMA] (
[ID_IDIOMA]
)
ALTER TABLE [dbo].[RIDIOMA_ESTATUS_CONSIGNACION] WITH CHECK ADD CONSTRAINT [FK_CESTATUS_CONSIGNACION_RIDIOMA_ESTATUS_CONSIGNACION] FOREIGN KEY (
[ID_ESTATUS_CONSIGNACION]
)
REFERENCES [dbo].[CESTATUS_CONSIGNACION] (
[ID_ESTATUS_CONSIGNACION]
)
GO

ALTER TABLE [dbo].[RIDIOMA_ESTATUS_CAJA] WITH CHECK ADD CONSTRAINT [FK_CESTATUS_CAJA_RIDIOMA_ESTATUS_CAJA] FOREIGN KEY (
[ID_ESTATUS_CAJA]
)
REFERENCES [dbo].[CESTATUS_CAJA] (
[ID_ESTATUS_CAJA]
)
ALTER TABLE [dbo].[RIDIOMA_ESTATUS_CAJA] WITH CHECK ADD CONSTRAINT [FK_CIDIOMA_RIDIOMA_ESTATUS_CAJA] FOREIGN KEY (
[ID_IDIOMA]
)
REFERENCES [dbo].[CIDIOMA] (
[ID_IDIOMA]
)
GO



ALTER TABLE [dbo].[RIDIOMA_FORMA_PAGO] WITH CHECK ADD CONSTRAINT [FK_CIDIOMA_RIDIOMA_FORMA_PAGO] FOREIGN KEY (
[ID_IDIOMA]
)
REFERENCES [dbo].[CIDIOMA] (
[ID_IDIOMA]
)


ALTER TABLE [dbo].[RIDIOMA_FORMA_PAGO] WITH CHECK ADD CONSTRAINT [FK_CFORMA_PAGO_RIDIOMA_FORMA_PAGO] FOREIGN KEY (
[ID_FORMA_PAGO]
)
REFERENCES [dbo].[CFORMA_PAGO] (
[ID_FORMA_PAGO]
)
GO


ALTER TABLE [dbo].[DVENTA] WITH CHECK ADD CONSTRAINT [FK_CCONSIGNATARIO_DVENTA] FOREIGN KEY (
[ID_CONSIGNATARIO]
)
REFERENCES [dbo].[CCONSIGNATARIO] (
[ID_CONSIGNATARIO]
)
ALTER TABLE [dbo].[DVENTA] WITH CHECK ADD CONSTRAINT [FK_DCAJA_APERTURA_DVENTA] FOREIGN KEY (
[ID_CAJA]
)
REFERENCES [dbo].[DCAJA_APERTURA] (
[ID_CAJA]
)
ALTER TABLE [dbo].[DVENTA] WITH CHECK ADD CONSTRAINT [FK_CESTATUS_CONSIGNACION_DVENTA] FOREIGN KEY (
[ID_ESTATUS_CONSIGNACION]
)
REFERENCES [dbo].[CESTATUS_CONSIGNACION] (
[ID_ESTATUS_CONSIGNACION]
)
GO

ALTER TABLE [dbo].[RVENTA_FORMA_PAGO] WITH CHECK ADD CONSTRAINT [FK_CFORMA_PAGO_RVENTA_FORMA_PAGO] FOREIGN KEY (
[ID_FORMA_PAGO]
)
REFERENCES [dbo].[CFORMA_PAGO] (
[ID_FORMA_PAGO]
)
ALTER TABLE [dbo].[RVENTA_FORMA_PAGO] WITH CHECK ADD CONSTRAINT [FK_DVENTA_RVENTA_FORMA_PAGO] FOREIGN KEY (
[ID_VENTA]
)
REFERENCES [dbo].[DVENTA] (
[ID_VENTA]
)
GO



ALTER TABLE [dbo].[DMOVIMIENTO_ARTICULO] WITH CHECK ADD CONSTRAINT [FK_CARTICULO_DMOVIMIENTO_ARTICULO] FOREIGN KEY (
[ID_ARTICULO]
)
REFERENCES [dbo].[CARTICULO] (
[ID_ARTICULO]
)
ALTER TABLE [dbo].[DMOVIMIENTO_ARTICULO] WITH CHECK ADD CONSTRAINT [FK_CTIPO_MOVIMIENTO_ART_DMOVIMIENTO_ARTICULO] FOREIGN KEY (
[CVE_TIPO_MOV_ART]
)
REFERENCES [dbo].[CTIPO_MOVIMIENTO_ART] (
[CVE_TIPO_MOV_ART]
)
GO


ALTER TABLE [dbo].[CCONSIGNATARIO] WITH CHECK ADD CONSTRAINT [FK_CCOMUNIDAD_CASIGNATARIO] FOREIGN KEY (
[ID_COMUNIDAD]
)
REFERENCES [dbo].[CCOMUNIDAD] (
[ID_COMUNIDAD]
)
GO

ALTER TABLE [dbo].[DVENTA_DETALLE] WITH CHECK ADD CONSTRAINT [FK_CARTICULO_DVENTA_DETALLE] FOREIGN KEY (
[ID_ARTICULO]
)
REFERENCES [dbo].[CARTICULO] (
[ID_ARTICULO]
)
ALTER TABLE [dbo].[DVENTA_DETALLE] WITH CHECK ADD CONSTRAINT [FK_DVENTA_DVENTA_DETALLE] FOREIGN KEY (
[ID_VENTA]
)
REFERENCES [dbo].[DVENTA] (
[ID_VENTA]
)
GO

