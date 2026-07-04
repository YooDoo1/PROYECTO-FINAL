--===============================================
-- INVOCACIONES DE PRUEBA PROYECTO PSIREG
--===============================================

SET SERVEROUTPUT ON;

--===============================================
-- 1. CARGA PARAMETRICA BASE
-- Se cargan catalogos mediante procedimiento para evitar IDs manuales.
--===============================================

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

    sp_cargar_parametricas(
        'Director',
        'Ingeniería Civil',
        'Ing. Civil',
        'Terapia Individual',
        'Residencial',
        'Residencial',
        'Residencial'
    );

    sp_cargar_parametricas(
        'Psicólogo Clínico',
        'Ingeniería Eléctrica',
        'Ing. Eléctrica',
        'Seguimiento Académico',
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


--===============================================
-- 2. CARGA BASE DE PSICOLOGOS
--===============================================

DECLARE
    v_id_cargo_clinico cargo.id_cargo%TYPE;
    v_id_cargo_director cargo.id_cargo%TYPE;
BEGIN
    SELECT id_cargo
    INTO v_id_cargo_clinico
    FROM cargo
    WHERE UPPER(nombre_cargo) = UPPER('Psicólogo Clínico');

    SELECT id_cargo
    INTO v_id_cargo_director
    FROM cargo
    WHERE UPPER(nombre_cargo) = UPPER('Director');

    sp_insertar_psicologo(
        'ANA',
        'MARIA',
        'GOMEZ',
        'PEREZ',
        'P-TEST-001',
        'FEMENINO',
        'ana.gomez@utp.ac.pa',
        66778899,
        'CASA 15',
        'CALLE PRIMERA',
        'BETHANIA',
        v_id_cargo_clinico
    );

    sp_insertar_psicologo(
        'CARLOS',
        NULL,
        'NUÑEZ',
        'SANCHEZ',
        'P-TEST-002',
        'MASCULINO',
        'carlos.nunez@utp.ac.pa',
        61234567,
        'CASA 20',
        'CALLE SEGUNDA',
        'JUAN DIAZ',
        v_id_cargo_director
    );
END;
/

SELECT * FROM Psicologo;


--===============================================
-- 3. CARGA BASE DE ESTUDIANTES
--===============================================

DECLARE
    v_id_carrera_sw Carrera.id_carrera%TYPE;
    v_id_carrera_civil Carrera.id_carrera%TYPE;
    v_id_tipo_personal TipoTlf_Est.id_tipo%TYPE;
    v_id_tipo_residencial TipoTlf_Est.id_tipo%TYPE;
    v_id_paciente Estudiante.id_paciente%TYPE;
BEGIN
    SELECT id_carrera
    INTO v_id_carrera_sw
    FROM Carrera
    WHERE UPPER(nombre_carrera) = UPPER('Lic. Desarrollo Software');

    SELECT id_carrera
    INTO v_id_carrera_civil
    FROM Carrera
    WHERE UPPER(nombre_carrera) = UPPER('Ing. Civil');

    SELECT id_tipo
    INTO v_id_tipo_personal
    FROM TipoTlf_Est
    WHERE UPPER(nombre_tipo) = UPPER('Personal');

    SELECT id_tipo
    INTO v_id_tipo_residencial
    FROM TipoTlf_Est
    WHERE UPPER(nombre_tipo) = UPPER('Residencial');

    sp_insertar_estudiante(
        'LUIS',
        'ENRIQUE',
        'MARTINEZ',
        'GARCIA',
        'E-TEST-001',
        'MASCULINO',
        'luis.martinez@utp.ac.pa',
        'CASA 8',
        'CALLE CENTRAL',
        'SAN FRANCISCO',
        v_id_carrera_sw,
        v_id_tipo_personal,
        64567890
    );

    SELECT id_paciente
    INTO v_id_paciente
    FROM Estudiante
    WHERE cedula = 'E-TEST-001';

    INSERT INTO Tlf_Estudiante(idPaciente, idTipo, telefono)
    VALUES (v_id_paciente, v_id_tipo_residencial, 2345678);

    sp_insertar_estudiante(
        'MARIA',
        'ELENA',
        'HERNANDEZ',
        'LOPEZ',
        'E-TEST-002',
        'FEMENINO',
        'maria.hernandez@utp.ac.pa',
        'CASA 22',
        'CALLE NORTE',
        'BETHANIA',
        v_id_carrera_civil,
        v_id_tipo_personal,
        69874563
    );

    SELECT id_paciente
    INTO v_id_paciente
    FROM Estudiante
    WHERE cedula = 'E-TEST-002';

    INSERT INTO Tlf_Estudiante(idPaciente, idTipo, telefono)
    VALUES (v_id_paciente, v_id_tipo_residencial, 2233445);
END;
/

SELECT * FROM Estudiante;
SELECT * FROM Tlf_Estudiante;


--===============================================
-- 4. CARGA BASE DE DOCENTES
--===============================================

DECLARE
    v_id_facultad_sistemas Facultad.id_facultad%TYPE;
    v_id_facultad_civil Facultad.id_facultad%TYPE;
    v_id_tipo_personal TipoTlf_Docente.id_tipo%TYPE;
    v_id_tipo_residencial TipoTlf_Docente.id_tipo%TYPE;
    v_id_paciente Docente.id_paciente%TYPE;
BEGIN
    SELECT id_facultad
    INTO v_id_facultad_sistemas
    FROM Facultad
    WHERE UPPER(nombre_facultad) = UPPER('Ingeniería de Sistemas Computacionales');

    SELECT id_facultad
    INTO v_id_facultad_civil
    FROM Facultad
    WHERE UPPER(nombre_facultad) = UPPER('Ingeniería Civil');

    SELECT id_tipo
    INTO v_id_tipo_personal
    FROM TipoTlf_Docente
    WHERE UPPER(nombre_tipo) = UPPER('Personal');

    SELECT id_tipo
    INTO v_id_tipo_residencial
    FROM TipoTlf_Docente
    WHERE UPPER(nombre_tipo) = UPPER('Residencial');

    sp_insertar_docente(
        'PEDRO',
        'JOSE',
        'CASTILLO',
        'MORALES',
        'D-TEST-001',
        'MASCULINO',
        'pedro.castillo@utp.ac.pa',
        67894512,
        'CASA 30',
        'CALLE SUR',
        'PARQUE LEFEVRE',
        v_id_facultad_sistemas,
        v_id_tipo_personal,
        68974521
    );

    SELECT id_paciente
    INTO v_id_paciente
    FROM Docente
    WHERE cedula = 'D-TEST-001';

    INSERT INTO Tlf_Docente(idPaciente, idTipo, telefono)
    VALUES (v_id_paciente, v_id_tipo_residencial, 2456789);

    sp_insertar_docente(
        'LAURA',
        NULL,
        'FERNANDEZ',
        'RUIZ',
        'D-TEST-002',
        'FEMENINO',
        'laura.fernandez@utp.ac.pa',
        62345678,
        'CASA 12',
        'CALLE ESTE',
        'BETHANIA',
        v_id_facultad_civil,
        v_id_tipo_personal,
        67894563
    );

    SELECT id_paciente
    INTO v_id_paciente
    FROM Docente
    WHERE cedula = 'D-TEST-002';

    INSERT INTO Tlf_Docente(idPaciente, idTipo, telefono)
    VALUES (v_id_paciente, v_id_tipo_residencial, 2567890);
END;
/

SELECT * FROM Docente;
SELECT * FROM Tlf_Docente;


--===============================================
-- 5. CARGA BASE DE ADMINISTRATIVOS
--===============================================

DECLARE
    v_id_tipo_personal TipoTlf_Admin.id_tipo%TYPE;
    v_id_tipo_residencial TipoTlf_Admin.id_tipo%TYPE;
    v_id_paciente Administrativo.id_paciente%TYPE;
BEGIN
    SELECT id_tipo
    INTO v_id_tipo_personal
    FROM TipoTlf_Admin
    WHERE UPPER(nombre_tipo) = UPPER('Personal');

    SELECT id_tipo
    INTO v_id_tipo_residencial
    FROM TipoTlf_Admin
    WHERE UPPER(nombre_tipo) = UPPER('Residencial');

    sp_insertar_administrativo(
        'JOSE',
        'ANTONIO',
        'RIVERA',
        'GONZALEZ',
        'A-TEST-001',
        'MASCULINO',
        'jose.rivera@utp.ac.pa',
        69988776,
        'CASA 40',
        'CALLE OESTE',
        'JUAN DIAZ',
        'RECURSOS HUMANOS',
        v_id_tipo_personal,
        61112233
    );

    SELECT id_paciente
    INTO v_id_paciente
    FROM Administrativo
    WHERE cedula = 'A-TEST-001';

    INSERT INTO Tlf_Admin(idPaciente, idTipo, telefono)
    VALUES (v_id_paciente, v_id_tipo_residencial, 2678901);

    sp_insertar_administrativo(
        'CARMEN',
        NULL,
        'DIAZ',
        'PEREZ',
        'A-TEST-002',
        'FEMENINO',
        'carmen.diaz@utp.ac.pa',
        67778855,
        'CASA 18',
        'CALLE QUINTA',
        'BETHANIA',
        'FINANZAS',
        v_id_tipo_personal,
        62223344
    );

    SELECT id_paciente
    INTO v_id_paciente
    FROM Administrativo
    WHERE cedula = 'A-TEST-002';

    INSERT INTO Tlf_Admin(idPaciente, idTipo, telefono)
    VALUES (v_id_paciente, v_id_tipo_residencial, 2789012);
END;
/

SELECT * FROM Administrativo;
SELECT * FROM Tlf_Admin;


--===============================================
-- 6. PRUEBA FUNCIONES DE PACIENTE
--===============================================

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


--===============================================
-- 7. CARGA BASE DE CITAS MEDIANTE PROCEDIMIENTO
--===============================================

DECLARE
    v_id_servicio_orientacion Servicio.id_servicio%TYPE;
    v_id_servicio_terapia Servicio.id_servicio%TYPE;
    v_id_servicio_seguimiento Servicio.id_servicio%TYPE;
    v_id_psicologo_ana Psicologo.id_psico%TYPE;
    v_id_psicologo_carlos Psicologo.id_psico%TYPE;
    v_id_estudiante Estudiante.id_paciente%TYPE;
    v_id_docente Docente.id_paciente%TYPE;
    v_id_admin Administrativo.id_paciente%TYPE;
BEGIN
    SELECT id_servicio
    INTO v_id_servicio_orientacion
    FROM Servicio
    WHERE UPPER(nombre_servicio) = UPPER('Orientación Psicológica');

    SELECT id_servicio
    INTO v_id_servicio_terapia
    FROM Servicio
    WHERE UPPER(nombre_servicio) = UPPER('Terapia Individual');

    SELECT id_servicio
    INTO v_id_servicio_seguimiento
    FROM Servicio
    WHERE UPPER(nombre_servicio) = UPPER('Seguimiento Académico');

    SELECT id_psico
    INTO v_id_psicologo_ana
    FROM Psicologo
    WHERE cedula = 'P-TEST-001';

    SELECT id_psico
    INTO v_id_psicologo_carlos
    FROM Psicologo
    WHERE cedula = 'P-TEST-002';

    SELECT id_paciente
    INTO v_id_estudiante
    FROM Estudiante
    WHERE cedula = 'E-TEST-001';

    SELECT id_paciente
    INTO v_id_docente
    FROM Docente
    WHERE cedula = 'D-TEST-001';

    SELECT id_paciente
    INTO v_id_admin
    FROM Administrativo
    WHERE cedula = 'A-TEST-001';

    sp_insertar_cita(
        TO_DATE('2026-07-15', 'YYYY-MM-DD'),
        TO_DATE('08:00', 'HH24:MI'),
        v_id_servicio_orientacion,
        v_id_estudiante,
        NULL,
        NULL,
        v_id_psicologo_ana
    );

    sp_insertar_cita(
        TO_DATE('2026-07-16', 'YYYY-MM-DD'),
        TO_DATE('10:30', 'HH24:MI'),
        v_id_servicio_terapia,
        NULL,
        v_id_docente,
        NULL,
        v_id_psicologo_carlos
    );

    sp_insertar_cita(
        TO_DATE('2026-07-17', 'YYYY-MM-DD'),
        TO_DATE('14:00', 'HH24:MI'),
        v_id_servicio_seguimiento,
        NULL,
        NULL,
        v_id_admin,
        v_id_psicologo_ana
    );
END;
/

SELECT * FROM Cita ORDER BY id_cita;
SELECT * FROM auditoria_cita ORDER BY aud_id_auditoria;
SELECT * FROM estadistica_atenciones ORDER BY id_psicologo, id_servicio, tipo_paciente;


--===============================================
-- 8. PRUEBA DE VISTAS CON DATOS BASE
--===============================================

SELECT * FROM vw_lista_pacientes;
SELECT * FROM vw_lista_psicologos;
SELECT * FROM vw_expediente_paciente;
SELECT * FROM vw_rep_atenciones_psico;


--===============================================
-- 9. PRUEBA REPROGRAMAR CITA
--===============================================

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

SELECT * FROM Cita ORDER BY id_cita;
SELECT * FROM auditoria_cita ORDER BY aud_id_auditoria;
SELECT * FROM estadistica_atenciones ORDER BY id_psicologo, id_servicio, tipo_paciente;


--===============================================
-- 10. PRUEBA ELIMINACION LOGICA DE UNA CITA
--===============================================

DECLARE
    v_id_cita Cita.id_cita%TYPE;
BEGIN
    SELECT id_cita
    INTO v_id_cita
    FROM Cita
    WHERE id_docente = (
        SELECT id_paciente
        FROM Docente
        WHERE cedula = 'D-TEST-001'
    )
    AND ROWNUM = 1;

    sp_eliminar_cita(v_id_cita);
END;
/

SELECT * FROM Cita WHERE estado = 'ELIMINADA';
SELECT * FROM vw_expediente_paciente;
SELECT * FROM vw_rep_atenciones_psico;


--===============================================
-- 11. REPORTE BASICO DE ATENCIONES ACTIVAS
--===============================================

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

COMMIT;
