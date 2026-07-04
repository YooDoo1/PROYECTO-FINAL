/* ============================================================================
   1. TABLAS MAESTRAS
   ============================================================================ */


/* ---------------------------------------------------------------------------
   TABLA: CARGO
   Propósito:
   Almacena los cargos que puede tener un psicólogo dentro de la DNOP.
   Ejemplo: Psicólogo Clínico, Director.
--------------------------------------------------------------------------- */
CREATE TABLE cargo (
    id_cargo      NUMBER(10) PRIMARY KEY,
    nombre_cargo  VARCHAR2(50) NOT NULL
);


/* ---------------------------------------------------------------------------
   TABLA: FACULTAD
   Propósito:
   Almacena las facultades de la Universidad Tecnológica de Panamá.
--------------------------------------------------------------------------- */
CREATE TABLE facultad (
    id_facultad      NUMBER(10) PRIMARY KEY,
    nombre_facultad  VARCHAR2(50)
);


/* ---------------------------------------------------------------------------
   TABLA: SERVICIO
   Propósito:
   Almacena los servicios psicológicos brindados por la DNOP.
--------------------------------------------------------------------------- */
CREATE TABLE servicio (
    id_servicio      NUMBER(10) PRIMARY KEY,
    nombre_servicio  VARCHAR2(25) NOT NULL
);


/* ---------------------------------------------------------------------------
   TABLA: TIPOTLF_EST
   Propósito:
   Catálogo de tipos de teléfono para estudiantes.
--------------------------------------------------------------------------- */
CREATE TABLE TipoTlf_Est (
    id_tipo      NUMBER(2) PRIMARY KEY,
    nombre_tipo  VARCHAR2(25) NOT NULL
);


/* ---------------------------------------------------------------------------
   TABLA: TIPOTLF_DOCENTE
   Propósito:
   Catálogo de tipos de teléfono para docentes.
--------------------------------------------------------------------------- */
CREATE TABLE TipoTlf_Docente (
    id_tipo      NUMBER(2) PRIMARY KEY,
    nombre_tipo  VARCHAR2(25) NOT NULL
);


/* ---------------------------------------------------------------------------
   TABLA: TIPOTLF_ADMIN
   Propósito:
   Catálogo de tipos de teléfono para administrativos.
--------------------------------------------------------------------------- */
CREATE TABLE TipoTlf_Admin (
    id_tipo      NUMBER(2) PRIMARY KEY,
    nombre_tipo  VARCHAR2(25) NOT NULL
);


/* ============================================================================
   2. TABLAS DEPENDIENTES
   ============================================================================ */


/* ---------------------------------------------------------------------------
   TABLA: PSICOLOGO
   Propósito:
   Almacena los datos generales de los psicólogos de la DNOP.

   Relación:
   - id_cargo referencia a cargo(id_cargo).
--------------------------------------------------------------------------- */
CREATE TABLE Psicologo (
    id_psico              NUMBER(10) PRIMARY KEY,
    primer_nombre         VARCHAR2(25) NOT NULL,
    segundo_nombre        VARCHAR2(25),
    apellido_paterno      VARCHAR2(25) NOT NULL,
    apellido_materno      VARCHAR2(25) NOT NULL,
    cedula                VARCHAR2(20) NOT NULL,
    genero                VARCHAR2(10) NOT NULL,
    correo_institucional  VARCHAR2(25) NOT NULL,
    telefono              NUMBER(8) NOT NULL,
    casa                  VARCHAR2(25),
    calle                 VARCHAR2(25) NOT NULL,
    corregimiento         VARCHAR2(25) NOT NULL,
    id_cargo              NUMBER(3) NOT NULL,

    CONSTRAINT fk_psicologo_cargo
        FOREIGN KEY (id_cargo)
        REFERENCES cargo(id_cargo)
);


/* ---------------------------------------------------------------------------
   TABLA: CARRERA
   Propósito:
   Almacena las carreras de la UTP.

   Relación:
   - id_facu referencia a facultad(id_facultad).
--------------------------------------------------------------------------- */
CREATE TABLE Carrera (
    id_carrera     NUMBER(10) PRIMARY KEY,
    nombre_carrera VARCHAR2(25),
    id_facu        NUMBER(10) NOT NULL,

    CONSTRAINT fk_carrera_facultad
        FOREIGN KEY (id_facu)
        REFERENCES facultad(id_facultad)
);


/* ---------------------------------------------------------------------------
   TABLA: ESTUDIANTE
   Propósito:
   Almacena los datos de pacientes que pertenecen al estamento estudiante.

   Relación:
   - id_carrera referencia a carrera(id_carrera).
--------------------------------------------------------------------------- */
CREATE TABLE Estudiante (
    id_paciente           NUMBER(10) PRIMARY KEY,
    primer_nombre         VARCHAR2(25) NOT NULL,
    segundo_nombre        VARCHAR2(25),
    apellido_paterno      VARCHAR2(25) NOT NULL,
    apellido_materno      VARCHAR2(25) NOT NULL,
    cedula                VARCHAR2(20) NOT NULL,
    genero                VARCHAR2(10) NOT NULL,
    correo_institucional  VARCHAR2(25) NOT NULL,
    casa                  VARCHAR2(25),
    calle                 VARCHAR2(25) NOT NULL,
    corregimiento         VARCHAR2(25) NOT NULL,
    id_carrera            NUMBER(10) NOT NULL,

    CONSTRAINT fk_estudiante_carrera
        FOREIGN KEY (id_carrera)
        REFERENCES carrera(id_carrera)
);


/* ---------------------------------------------------------------------------
   TABLA: TLF_ESTUDIANTE
   Propósito:
   Almacena los teléfonos asociados a estudiantes.

   Clave primaria compuesta:
   - idPaciente
   - idTipo

   Relaciones:
   - idPaciente referencia a Estudiante(id_paciente).
   - idTipo referencia a TipoTlf_Est(id_tipo).
--------------------------------------------------------------------------- */
CREATE TABLE Tlf_Estudiante (
    idPaciente  NUMBER(10),
    idTipo      NUMBER(2),
    telefono    NUMBER(8),

    CONSTRAINT pk_tlf_estudiante
        PRIMARY KEY (idPaciente, idTipo),

    CONSTRAINT fk_tlf_estudiante_paciente
        FOREIGN KEY (idPaciente)
        REFERENCES Estudiante(id_paciente),

    CONSTRAINT fk_tlf_estudiante_tipo
        FOREIGN KEY (idTipo)
        REFERENCES TipoTlf_Est(id_tipo)
);


/* ---------------------------------------------------------------------------
   TABLA: DOCENTE
   Propósito:
   Almacena los datos de pacientes que pertenecen al estamento docente.

   Relación:
   - id_facultad referencia a facultad(id_facultad).
--------------------------------------------------------------------------- */
CREATE TABLE Docente (
    id_paciente           NUMBER(10) PRIMARY KEY,
    primer_nombre         VARCHAR2(25) NOT NULL,
    segundo_nombre        VARCHAR2(25),
    apellido_paterno      VARCHAR2(25) NOT NULL,
    apellido_materno      VARCHAR2(25) NOT NULL,
    cedula                VARCHAR2(20) NOT NULL,
    genero                VARCHAR2(10) NOT NULL,
    correo_institucional  VARCHAR2(25) NOT NULL,
    telefono_personal     NUMBER(8) NOT NULL,
    casa                  VARCHAR2(25),
    calle                 VARCHAR2(25) NOT NULL,
    corregimiento         VARCHAR2(25) NOT NULL,
    id_facultad           NUMBER(10),

    CONSTRAINT fk_docente_facultad
        FOREIGN KEY (id_facultad)
        REFERENCES facultad(id_facultad)
);


/* ---------------------------------------------------------------------------
   TABLA: TLF_DOCENTE
   Propósito:
   Almacena los teléfonos asociados a docentes.

   Clave primaria compuesta:
   - idPaciente
   - idTipo

   Relaciones:
   - idPaciente referencia a Docente(id_paciente).
   - idTipo referencia a TipoTlf_Docente(id_tipo).
--------------------------------------------------------------------------- */
CREATE TABLE Tlf_Docente (
    idPaciente  NUMBER(10),
    idTipo      NUMBER(2),
    telefono    NUMBER(8),

    CONSTRAINT pk_tlf_docente
        PRIMARY KEY (idPaciente, idTipo),

    CONSTRAINT fk_tlf_docente_paciente
        FOREIGN KEY (idPaciente)
        REFERENCES Docente(id_paciente),

    CONSTRAINT fk_tlf_docente_tipo
        FOREIGN KEY (idTipo)
        REFERENCES TipoTlf_Docente(id_tipo)
);


/* ---------------------------------------------------------------------------
   TABLA: ADMINISTRATIVO
   Propósito:
   Almacena los datos de pacientes que pertenecen al estamento administrativo.
--------------------------------------------------------------------------- */
CREATE TABLE Administrativo (
    id_paciente           NUMBER(10) PRIMARY KEY,
    primer_nombre         VARCHAR2(25) NOT NULL,
    segundo_nombre        VARCHAR2(25),
    apellido_paterno      VARCHAR2(25) NOT NULL,
    apellido_materno      VARCHAR2(25) NOT NULL,
    cedula                VARCHAR2(20) NOT NULL,
    genero                VARCHAR2(10) NOT NULL,
    correo_institucional  VARCHAR2(25) NOT NULL,
    telefono_personal     NUMBER(8) NOT NULL,
    casa                  VARCHAR2(25) NOT NULL,
    calle                 VARCHAR2(25) NOT NULL,
    corregimiento         VARCHAR2(25) NOT NULL,
    departamento          VARCHAR2(25) NOT NULL
);


/* ---------------------------------------------------------------------------
   TABLA: TLF_ADMIN
   Propósito:
   Almacena los teléfonos asociados a administrativos.

   Clave primaria compuesta:
   - idPaciente
   - idTipo

   Relaciones:
   - idPaciente referencia a Administrativo(id_paciente).
   - idTipo referencia a TipoTlf_Admin(id_tipo).
--------------------------------------------------------------------------- */
CREATE TABLE Tlf_Admin (
    idPaciente  NUMBER(10),
    idTipo      NUMBER(2),
    telefono    NUMBER(8),

    CONSTRAINT pk_tlf_admin
        PRIMARY KEY (idPaciente, idTipo),

    CONSTRAINT fk_tlf_admin_paciente
        FOREIGN KEY (idPaciente)
        REFERENCES Administrativo(id_paciente),

    CONSTRAINT fk_tlf_admin_tipo
        FOREIGN KEY (idTipo)
        REFERENCES TipoTlf_Admin(id_tipo)
);


/* ---------------------------------------------------------------------------
   TABLA: CITA
   Propósito:
   Registra las citas psicológicas.

   Reglas principales:
   - Toda cita debe estar asociada a un servicio.
   - Toda cita debe estar asociada a un psicólogo.
   - Toda cita debe estar asociada exactamente a un tipo de paciente:
     estudiante, docente o administrativo.

   Relaciones:
   - id_servicio referencia a servicio(id_servicio).
   - id_estudiante referencia a Estudiante(id_paciente).
   - id_docente referencia a Docente(id_paciente).
   - id_admin referencia a Administrativo(id_paciente).
   - id_psicologo referencia a Psicologo(id_psico).
--------------------------------------------------------------------------- */
CREATE TABLE Cita (
    id_cita        NUMBER(10) PRIMARY KEY,
    fecha          DATE NOT NULL,
    hora           VARCHAR2(10) NOT NULL,
    id_servicio    NUMBER(10) NOT NULL,
    id_estudiante  NUMBER(10),
    id_docente     NUMBER(10),
    id_admin       NUMBER(10),
    id_psicologo   NUMBER(10) NOT NULL,

    CONSTRAINT fk_cita_servicio
        FOREIGN KEY (id_servicio)
        REFERENCES servicio(id_servicio),

    CONSTRAINT fk_cita_estudiante
        FOREIGN KEY (id_estudiante)
        REFERENCES Estudiante(id_paciente),

    CONSTRAINT fk_cita_docente
        FOREIGN KEY (id_docente)
        REFERENCES Docente(id_paciente),

    CONSTRAINT fk_cita_admin
        FOREIGN KEY (id_admin)
        REFERENCES Administrativo(id_paciente),

    CONSTRAINT fk_cita_psicologo
        FOREIGN KEY (id_psicologo)
        REFERENCES Psicologo(id_psico)
);


--===============================================
-- TABLA AUDITORIA CITA
--===============================================

CREATE TABLE auditoria_cita(
    aud_id_auditoria NUMBER(10) PRIMARY KEY,
    aud_tabla_editada VARCHAR2(50) NOT NULL, 
    aud_id_cita NUMBER(10), 
    aud_tipo_operacion VARCHAR2(50) NOT NULL, 
    aud_fecha_anterior DATE, 
    aud_fecha_nueva DATE, 
    aud_hora_anterior DATE, 
    aud_hora_nueva DATE, 
    aud_id_servicio_anterior NUMBER(10), 
    aud_id_servicio_nuevo NUMBER(10), 
    aud_id_psicologo_anterior NUMBER(10), 
    aud_id_psicologo_nuevo NUMBER(10), 
    aud_cita_usuario VARCHAR2(50), 
    aud_cita_fecha DATE NOT NULL
);


--===============================================
-- TABLA ESTADISTICA DE ATENCIONES PSICOLOGICAS
--===============================================

CREATE TABLE estadistica_atenciones(
    id_psicologo NUMBER(10) NOT NULL,
    id_servicio NUMBER(10) NOT NULL,
    tipo_paciente VARCHAR2(50) NOT NULL,
    cantidad_citas NUMBER(10) DEFAULT 0 NOT NULL,
    ultima_fecha_atencion DATE,
    usuario_actualiza VARCHAR2(50),
    fecha_actualizacion DATE DEFAULT SYSDATE NOT NULL,

    PRIMARY KEY(id_psicologo, id_servicio, tipo_paciente),

    CHECK(tipo_paciente IN ('ESTUDIANTE', 'DOCENTE', 'ADMINISTRATIVO'))
);

--===============================================
-- TABLA REPORTE DE ATENCIONES PSICOLOGICAS
--===============================================

CREATE TABLE reporte_atenciones(
    id_reporte NUMBER(10) PRIMARY KEY,
    fecha_generacion DATE NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    id_cita NUMBER(10) NOT NULL,
    fecha_cita DATE NOT NULL,
    hora DATE NOT NULL,
    id_psicologo NUMBER(10) NOT NULL,
    nombre_psicologo VARCHAR2(150) NOT NULL,
    id_paciente NUMBER(10) NOT NULL,
    nombre_paciente VARCHAR2(150) NOT NULL,
    tipo_paciente VARCHAR2(50) NOT NULL,
    nombre_servicio VARCHAR2(100) NOT NULL,
    usuario_genera VARCHAR2(50) NOT NULL
);