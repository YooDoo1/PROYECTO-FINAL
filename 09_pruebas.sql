--===============================================
-- INVOCACIONES DE PRUEBA PROYECTO PSIREG
--===============================================

SET SERVEROUTPUT ON;

-- 1. CARGA PARAMETRICA
BEGIN
    sp_cargar_parametricas(
        'Psicólogo Clínico',
        'Ingeniería de Sistemas Computacionales',
        'Lic. Desarrollo Software',
        'Orientación Psicológica',
        'Personal',
        'Personal',
        'Personal'
    );
END;
/

SELECT * FROM cargo;
SELECT * FROM facultad;
SELECT * FROM carrera;
SELECT * FROM servicio;
SELECT * FROM TipoTlf_Est;
SELECT * FROM TipoTlf_Docente;
SELECT * FROM TipoTlf_Admin;

-- 2. INSERTAR PSICOLOGO CON TELEFONO
DECLARE
    v_id_cargo cargo.id_cargo%TYPE;
BEGIN
    SELECT id_cargo
    INTO v_id_cargo
    FROM cargo
    WHERE UPPER(nombre_cargo) = UPPER('Psicólogo Clínico');

    sp_insertar_psicologo(
        'ANA',
        'MARIA',
        'GOMEZ',
        'PEREZ',
        'P-TEST-001',
        'FEMENINO',
        'ana@utp.ac.pa',
        60000000,
        'CASA 1',
        'CALLE 1',
        'BELLA VISTA',
        v_id_cargo
    );
END;
/

SELECT * FROM Psicologo
WHERE cedula = 'P-TEST-001';

-- 3. INSERTAR ESTUDIANTE
DECLARE
    v_id_carrera Carrera.id_carrera%TYPE;
    v_id_tipo TipoTlf_Est.id_tipo%TYPE;
BEGIN
    SELECT id_carrera
    INTO v_id_carrera
    FROM Carrera
    WHERE UPPER(nombre_carrera) = UPPER('Lic. Desarrollo Software');

    SELECT id_tipo
    INTO v_id_tipo
    FROM TipoTlf_Est
    WHERE UPPER(nombre_tipo) = UPPER('Personal');

    sp_insertar_estudiante(
        'CARLOS',
        'ANDRES',
        'RODRIGUEZ',
        'LOPEZ',
        'E-TEST-001',
        'MASCULINO',
        'carlos@utp.ac.pa',
        'CASA 2',
        'CALLE 2',
        'SAN FRANCISCO',
        v_id_carrera,
        v_id_tipo,
        60000001
    );
END;
/

SELECT * FROM Estudiante
WHERE cedula = 'E-TEST-001';
SELECT * FROM Tlf_Estudiante;

-- 4. INSERTAR DOCENTE
DECLARE
    v_id_facultad Facultad.id_facultad%TYPE;
    v_id_tipo TipoTlf_Docente.id_tipo%TYPE;
BEGIN
    SELECT id_facultad
    INTO v_id_facultad
    FROM Facultad
    WHERE UPPER(nombre_facultad) = UPPER('Ingeniería de Sistemas Computacionales');

    SELECT id_tipo
    INTO v_id_tipo
    FROM TipoTlf_Docente
    WHERE UPPER(nombre_tipo) = UPPER('Personal');

    sp_insertar_docente(
        'LUIS',
        'ALBERTO',
        'MARTINEZ',
        'SANTOS',
        'D-TEST-001',
        'MASCULINO',
        'luis@utp.ac.pa',
        60000002,
        'CASA 3',
        'CALLE 3',
        'BETANIA',
        v_id_facultad,
        v_id_tipo,
        60000003
    );
END;
/

SELECT * FROM Docente
WHERE cedula = 'D-TEST-001';
SELECT * FROM Tlf_Docente;

-- 5. INSERTAR ADMINISTRATIVO
DECLARE
    v_id_tipo TipoTlf_Admin.id_tipo%TYPE;
BEGIN
    SELECT id_tipo
    INTO v_id_tipo
    FROM TipoTlf_Admin
    WHERE UPPER(nombre_tipo) = UPPER('Personal');

    sp_insertar_administrativo(
        'MARTA',
        'ELENA',
        'CASTILLO',
        'DIAZ',
        'A-TEST-001',
        'FEMENINO',
        'marta@utp.ac.pa',
        60000004,
        'CASA 4',
        'CALLE 4',
        'JUAN DIAZ',
        'SECRETARIA',
        v_id_tipo,
        60000005
    );
END;
/

SELECT * FROM Administrativo
WHERE cedula = 'A-TEST-001';
SELECT * FROM Tlf_Admin;

-- 6. FUNCIONES DE PACIENTE
SELECT fn_tipo_paciente_cita(
    (SELECT id_paciente FROM Estudiante WHERE cedula = 'E-TEST-001'),
    NULL,
    NULL
) AS tipo_paciente_estudiante
FROM dual;

SELECT fn_nombre_paciente_cita(
    (SELECT id_paciente FROM Estudiante WHERE cedula = 'E-TEST-001'),
    NULL,
    NULL
) AS nombre_estudiante
FROM dual;

-- 7. INSERTAR CITA CON HORA DATE
DECLARE
    v_id_servicio Servicio.id_servicio%TYPE;
    v_id_psicologo Psicologo.id_psico%TYPE;
    v_id_estudiante Estudiante.id_paciente%TYPE;
BEGIN
    SELECT id_servicio
    INTO v_id_servicio
    FROM Servicio
    WHERE UPPER(nombre_servicio) = UPPER('Orientación Psicológica');

    SELECT id_psico
    INTO v_id_psicologo
    FROM Psicologo
    WHERE cedula = 'P-TEST-001';

    SELECT id_paciente
    INTO v_id_estudiante
    FROM Estudiante
    WHERE cedula = 'E-TEST-001';

    sp_insertar_cita(
        TO_DATE('2026-07-15', 'YYYY-MM-DD'),
        TO_DATE('09:00', 'HH24:MI'),
        v_id_servicio,
        v_id_estudiante,
        NULL,
        NULL,
        v_id_psicologo
    );
END;
/

SELECT * FROM Cita;
SELECT * FROM auditoria_cita ORDER BY aud_id_auditoria;
SELECT * FROM estadistica_atenciones ORDER BY id_psicologo, id_servicio, tipo_paciente;

-- 8. REPROGRAMAR CITA CON HORA DATE
DECLARE
    v_id_cita Cita.id_cita%TYPE;
    v_id_servicio Servicio.id_servicio%TYPE;
    v_id_psicologo Psicologo.id_psico%TYPE;
BEGIN
    SELECT id_cita
    INTO v_id_cita
    FROM Cita
    WHERE id_estudiante = (
        SELECT id_paciente
        FROM Estudiante
        WHERE cedula = 'E-TEST-001'
    )
    AND ROWNUM = 1;

    SELECT id_servicio
    INTO v_id_servicio
    FROM Servicio
    WHERE UPPER(nombre_servicio) = UPPER('Orientación Psicológica');

    SELECT id_psico
    INTO v_id_psicologo
    FROM Psicologo
    WHERE cedula = 'P-TEST-001';

    sp_reprogramar_cita(
        v_id_cita,
        TO_DATE('2026-07-20', 'YYYY-MM-DD'),
        TO_DATE('13:30', 'HH24:MI'),
        v_id_servicio,
        v_id_psicologo
    );
END;
/

SELECT * FROM Cita;

-- 9. MARCAR CITA COMO ELIMINADA LOGICAMENTE
DECLARE
    v_id_cita Cita.id_cita%TYPE;
BEGIN
    SELECT id_cita
    INTO v_id_cita
    FROM Cita
    WHERE id_estudiante = (
        SELECT id_paciente
        FROM Estudiante
        WHERE cedula = 'E-TEST-001'
    )
    AND ROWNUM = 1;

    sp_eliminar_cita(v_id_cita);
END;
/

SELECT * FROM Cita WHERE estado = 'ELIMINADA';
SELECT * FROM vw_expediente_paciente;
SELECT * FROM vw_rep_atenciones_psico;

-- 10. REPORTE BASICO CON HORA DATE
INSERT INTO reporte_atenciones(
    id_reporte,
    fecha_generacion,
    fecha_inicio,
    fecha_fin,
    id_cita,
    fecha_cita,
    hora,
    id_psicologo,
    nombre_psicologo,
    id_paciente,
    nombre_paciente,
    tipo_paciente,
    nombre_servicio,
    usuario_genera
)
SELECT
    seq_reporte_atenciones.NEXTVAL,
    SYSDATE,
    TO_DATE('2026-07-01', 'YYYY-MM-DD'),
    TO_DATE('2026-07-31', 'YYYY-MM-DD'),
    c.id_cita,
    c.fecha,
    c.hora,
    p.id_psico,
    p.primer_nombre || ' ' || p.apellido_paterno,
    CASE
        WHEN c.id_estudiante IS NOT NULL THEN c.id_estudiante
        WHEN c.id_docente IS NOT NULL THEN c.id_docente
        WHEN c.id_admin IS NOT NULL THEN c.id_admin
    END,
    fn_nombre_paciente_cita(c.id_estudiante, c.id_docente, c.id_admin),
    fn_tipo_paciente_cita(c.id_estudiante, c.id_docente, c.id_admin),
    s.nombre_servicio,
    USER
FROM Cita c
JOIN Psicologo p
    ON c.id_psicologo = p.id_psico
JOIN Servicio s
    ON c.id_servicio = s.id_servicio
WHERE c.fecha BETWEEN TO_DATE('2026-07-01', 'YYYY-MM-DD')
AND TO_DATE('2026-07-31', 'YYYY-MM-DD')
AND c.estado = 'ACTIVA';

SELECT * FROM reporte_atenciones ORDER BY id_reporte;
