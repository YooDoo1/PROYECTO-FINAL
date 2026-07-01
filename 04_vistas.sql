/* ============================================================================
   5. VISTAS DE USUARIOS
   ============================================================================ */


/* ---------------------------------------------------------------------------
   VISTA: VW_LISTA_PACIENTES
   Propósito:
   Muestra en una sola consulta los pacientes registrados como estudiantes,
   docentes y administrativos.

   Técnica usada:
   UNION ALL para unir filas provenientes de tres tablas con estructura similar.
--------------------------------------------------------------------------- */
CREATE OR REPLACE VIEW vw_lista_pacientes AS
SELECT
    id_paciente,
    primer_nombre,
    segundo_nombre,
    apellido_paterno,
    apellido_materno,
    cedula,
    genero,
    correo_institucional,
    'Estudiante' AS tipo_paciente
FROM Estudiante

UNION ALL

SELECT
    id_paciente,
    primer_nombre,
    segundo_nombre,
    apellido_paterno,
    apellido_materno,
    cedula,
    genero,
    correo_institucional,
    'Docente' AS tipo_paciente
FROM Docente

UNION ALL

SELECT
    id_paciente,
    primer_nombre,
    segundo_nombre,
    apellido_paterno,
    apellido_materno,
    cedula,
    genero,
    correo_institucional,
    'Administrativo' AS tipo_paciente
FROM Administrativo;


/* Consulta de prueba */
SELECT * FROM vw_lista_pacientes;


/* ---------------------------------------------------------------------------
   VISTA: VW_LISTA_PSICOLOGOS
   Propósito:
   Lista los psicólogos junto con el cargo asociado.

   Tablas usadas:
   - Psicologo
   - Cargo

   Relación:
   Psicologo.id_cargo = Cargo.id_cargo
--------------------------------------------------------------------------- */
CREATE OR REPLACE VIEW vw_lista_psicologos AS
SELECT
    p.id_psico,
    p.primer_nombre,
    p.segundo_nombre,
    p.apellido_paterno,
    p.apellido_materno,
    p.cedula,
    p.genero,
    p.correo_institucional,
    p.telefono,
    c.nombre_cargo
FROM Psicologo p
JOIN Cargo c
    ON p.id_cargo = c.id_cargo;


/* Consulta de prueba */
SELECT * FROM vw_lista_psicologos;


/* ---------------------------------------------------------------------------
   VISTA: VW_EXPEDIENTE_PACIENTE
   Propósito:
   Consulta el expediente de un paciente con su cita, servicio y psicólogo.

   Técnica usada:
   UNION ALL porque los pacientes están separados en tres tablas:
   - Estudiante
   - Docente
   - Administrativo

   Tablas relacionadas:
   - Cita
   - Servicio
   - Psicologo
--------------------------------------------------------------------------- */
CREATE OR REPLACE VIEW vw_expediente_paciente AS
SELECT
    e.id_paciente,
    e.primer_nombre,
    e.apellido_paterno,
    e.apellido_materno,
    ci.id_cita,
    ci.fecha,
    ci.hora,
    s.nombre_servicio,
    p.primer_nombre || ' ' || p.apellido_paterno AS psicologo
FROM Estudiante e
JOIN Cita ci
    ON e.id_paciente = ci.id_estudiante
JOIN Servicio s
    ON ci.id_servicio = s.id_servicio
JOIN Psicologo p
    ON ci.id_psicologo = p.id_psico

UNION ALL

SELECT
    d.id_paciente,
    d.primer_nombre,
    d.apellido_paterno,
    d.apellido_materno,
    ci.id_cita,
    ci.fecha,
    ci.hora,
    s.nombre_servicio,
    p.primer_nombre || ' ' || p.apellido_paterno AS psicologo
FROM Docente d
JOIN Cita ci
    ON d.id_paciente = ci.id_docente
JOIN Servicio s
    ON ci.id_servicio = s.id_servicio
JOIN Psicologo p
    ON ci.id_psicologo = p.id_psico

UNION ALL

SELECT
    a.id_paciente,
    a.primer_nombre,
    a.apellido_paterno,
    a.apellido_materno,
    ci.id_cita,
    ci.fecha,
    ci.hora,
    s.nombre_servicio,
    p.primer_nombre || ' ' || p.apellido_paterno AS psicologo
FROM Administrativo a
JOIN Cita ci
    ON a.id_paciente = ci.id_admin
JOIN Servicio s
    ON ci.id_servicio = s.id_servicio
JOIN Psicologo p
    ON ci.id_psicologo = p.id_psico;


/* Consulta de prueba */
SELECT *
FROM vw_expediente_paciente
WHERE id_paciente = 1001;


/* ---------------------------------------------------------------------------
   VISTA: VW_REP_ATENCIONES_PSICO
   Propósito:
   Reporta las atenciones psicológicas realizadas por cada psicólogo.

   Técnica usada:
   LEFT JOIN sobre las tres posibles tablas de paciente porque una cita puede
   pertenecer a estudiante, docente o administrativo.

   CASE:
   Determina el nombre del paciente según el tipo de paciente asociado a la cita.
--------------------------------------------------------------------------- */
CREATE OR REPLACE VIEW vw_rep_atenciones_psico AS
SELECT
    c.id_cita,
    c.fecha,
    c.hora,
    s.nombre_servicio,
    p.primer_nombre || ' ' || p.apellido_paterno AS psicologo,
    CASE
        WHEN c.id_estudiante IS NOT NULL THEN
            e.primer_nombre || ' ' || e.apellido_paterno
        WHEN c.id_docente IS NOT NULL THEN
            d.primer_nombre || ' ' || d.apellido_paterno
        WHEN c.id_admin IS NOT NULL THEN
            a.primer_nombre || ' ' || a.apellido_paterno
    END AS paciente
FROM Cita c
LEFT JOIN Estudiante e
    ON c.id_estudiante = e.id_paciente
LEFT JOIN Docente d
    ON c.id_docente = d.id_paciente
LEFT JOIN Administrativo a
    ON c.id_admin = a.id_paciente
JOIN Servicio s
    ON c.id_servicio = s.id_servicio
JOIN Psicologo p
    ON c.id_psicologo = p.id_psico;


/* Consulta de prueba */
SELECT * FROM vw_rep_atenciones_psico;
