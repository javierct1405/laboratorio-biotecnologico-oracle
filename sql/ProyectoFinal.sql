--Creacion de Tablas

-- 1) AREA_LAB
CREATE TABLE AREA_LAB (
  idArea      NUMBER(6)      CONSTRAINT PK_AREA_LAB PRIMARY KEY,
  nombreArea  VARCHAR2(50)   NOT NULL,
  descripcion VARCHAR2(200),
  CONSTRAINT UQ_AREA_LAB_NOMBRE UNIQUE (nombreArea));

-- 2) PLANTA
CREATE TABLE PLANTA (
  idPlanta         NUMBER(6)     CONSTRAINT PK_PLANTA PRIMARY KEY,
  nombreComun      VARCHAR2(50)  NOT NULL,
  nombreCientifico VARCHAR2(80)  NOT NULL,
  familia          VARCHAR2(50),
  tipo             VARCHAR2(20)  NOT NULL,
  descripcion      VARCHAR2(200),
  CONSTRAINT UQ_PLANTA_NC UNIQUE (nombreCientifico),
  CONSTRAINT CK_PLANTA_TIPO CHECK (tipo IN ('MEDICINAL','ORNAMENTAL')));

-- 3) INVESTIGADOR
CREATE TABLE INVESTIGADOR (
  idInvestigador NUMBER(6)     CONSTRAINT PK_INVESTIGADOR PRIMARY KEY,
  nombre         VARCHAR2(50)  NOT NULL,
  apellidos      VARCHAR2(70)  NOT NULL,
  correo         VARCHAR2(80)  NOT NULL,
  especialidad   VARCHAR2(60),
  fechaIngreso   DATE          NOT NULL,
  CONSTRAINT UQ_INV_CORREO UNIQUE (correo));

-- 4) CULTIVO
CREATE TABLE CULTIVO (
  idCultivo   NUMBER(6)     CONSTRAINT PK_CULTIVO PRIMARY KEY,
  idPlanta    NUMBER(6)     NOT NULL,
  idArea      NUMBER(6)     NOT NULL,
  fechaInicio DATE          NOT NULL,
  fechaFin    DATE,
  sustrato    VARCHAR2(40),
  estado      VARCHAR2(15)  NOT NULL,
  CONSTRAINT FK_CULTIVO_PLANTA FOREIGN KEY (idPlanta) REFERENCES PLANTA(idPlanta),
  CONSTRAINT FK_CULTIVO_AREA   FOREIGN KEY (idArea)   REFERENCES AREA_LAB(idArea),
  CONSTRAINT CK_CULTIVO_ESTADO CHECK (estado IN ('ACTIVO','FINALIZADO')),
  CONSTRAINT CK_CULTIVO_FECHAS CHECK (fechaFin IS NULL OR fechaFin >= fechaInicio));

-- 5) EXPERIMENTO
CREATE TABLE EXPERIMENTO (
  idExperimento     NUMBER(6)      CONSTRAINT PK_EXPERIMENTO PRIMARY KEY,
  idInvestigador    NUMBER(6)      NOT NULL,
  nombreExperimento VARCHAR2(80)   NOT NULL,
  objetivo          VARCHAR2(200),
  fechaInicio       DATE           NOT NULL,
  fechaFin          DATE,
  presupuesto       NUMBER(10,2)   NOT NULL,
  estado            VARCHAR2(15)   NOT NULL,
  CONSTRAINT FK_EXP_INV FOREIGN KEY (idInvestigador) REFERENCES INVESTIGADOR(idInvestigador),
  CONSTRAINT CK_EXP_PRES CHECK (presupuesto >= 0),
  CONSTRAINT CK_EXP_EST  CHECK (estado IN ('PLANEADO','EN_CURSO','CERRADO')),
  CONSTRAINT CK_EXP_FECHAS CHECK (fechaFin IS NULL OR fechaFin >= fechaInicio));

-- 6) EXPERIMENTO_CULTIVO
CREATE TABLE EXPERIMENTO_CULTIVO (
  idExpCultivo    NUMBER(6)     CONSTRAINT PK_EXP_CULTIVO PRIMARY KEY,
  idExperimento   NUMBER(6)     NOT NULL,
  idCultivo       NUMBER(6)     NOT NULL,
  fechaAplicacion DATE          NOT NULL,
  tratamiento     VARCHAR2(100),
  observaciones   VARCHAR2(200),
  CONSTRAINT FK_EC_EXP FOREIGN KEY (idExperimento) REFERENCES EXPERIMENTO(idExperimento),
  CONSTRAINT FK_EC_CUL FOREIGN KEY (idCultivo)     REFERENCES CULTIVO(idCultivo),
  CONSTRAINT UQ_EC_UNICA UNIQUE (idExperimento, idCultivo));

-- 7) RESULTADO
CREATE TABLE RESULTADO (
  idResultado   NUMBER(10)    CONSTRAINT PK_RESULTADO PRIMARY KEY,
  idExpCultivo  NUMBER(6)     NOT NULL,
  fechaMedicion DATE          NOT NULL,
  tipoMedicion  VARCHAR2(30)  NOT NULL,
  valor         NUMBER(10,2)  NOT NULL,
  unidad        VARCHAR2(15)  NOT NULL,
  observaciones VARCHAR2(200),
  CONSTRAINT FK_RES_EC FOREIGN KEY (idExpCultivo) REFERENCES EXPERIMENTO_CULTIVO(idExpCultivo),
  CONSTRAINT CK_RES_VALOR CHECK (valor >= 0));

-- 8) SENSOR
CREATE TABLE SENSOR (
  idSensor         NUMBER(6)     CONSTRAINT PK_SENSOR PRIMARY KEY,
  idArea           NUMBER(6)     NOT NULL,
  tipoSensor       VARCHAR2(30)  NOT NULL,
  marca            VARCHAR2(40),
  modelo           VARCHAR2(40),
  fechaInstalacion DATE          NOT NULL,
  estado           VARCHAR2(15)  NOT NULL,
  CONSTRAINT FK_SENSOR_AREA FOREIGN KEY (idArea) REFERENCES AREA_LAB(idArea),
  CONSTRAINT CK_SENSOR_TIPO CHECK (tipoSensor IN ('TEMP','HUMEDAD','PH','LUZ')),
  CONSTRAINT CK_SENSOR_EST  CHECK (estado IN ('ACTIVO','INACTIVO')));

-- 9) LECTURA_SENSOR
CREATE TABLE LECTURA_SENSOR (
  idLectura  NUMBER(10)   CONSTRAINT PK_LECTURA PRIMARY KEY,
  idSensor   NUMBER(6)    NOT NULL,
  fechaHora  DATE         NOT NULL,
  valor      NUMBER(10,2) NOT NULL,
  unidad     VARCHAR2(15) NOT NULL,
  CONSTRAINT FK_LEC_SENSOR FOREIGN KEY (idSensor) REFERENCES SENSOR(idSensor));

-- 10) REPORTE
CREATE TABLE REPORTE (
  idReporte     NUMBER(6)      CONSTRAINT PK_REPORTE PRIMARY KEY,
  idExperimento NUMBER(6)      NOT NULL,
  fechaReporte  DATE           NOT NULL,
  resumen       VARCHAR2(250),
  conclusiones  VARCHAR2(400)  NOT NULL,
  CONSTRAINT FK_REP_EXP FOREIGN KEY (idExperimento) REFERENCES EXPERIMENTO(idExperimento));
