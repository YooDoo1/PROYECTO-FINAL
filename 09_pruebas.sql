--===============================================
-- INVOCACIONES DE PRUEBA PROYECTO PSIREG
--===============================================

SET SERVEROUTPUT ON;

--===============================================
-- 1. PRUEBA CARGA DE TABLAS PARAMETRICAS
--===============================================

BEGIN
    sp_cargar_parametricas(
        'PSICOLOGO CLINICO',
        'FACULTAD DE SISTEMAS',
        'ING SOFTWARE',
        'ORIENTACION',
        'PERSONAL',
        'PERSONAL',
        'PERSONAL'
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
-- 2. PRUEBA INSERTAR PSICOLOGO
--===============================================

DECLARE
    v_id_cargo cargo.id_cargo%TYPE;
BEGIN
    SELECT id_cargo
    INTO v_id_cargo
    FROM cargo
    WHERE UPPER(nombre_cargo) = 'PSICOLOGO CLINICO';

    sp_insertar_psicologo(
        'ANA',
        'MARIA',
        'GOMEZ',
        'PEREZ',
        'P-TEST-001',
        'FEMENINO',
        'ana@utp.ac.pa',
        'CASA 1',
        'CALLE 1',
        'BELLA VISTA',
        v_id_cargo
    );
END;
/

SELECT * FROM Psicologo
WHERE cedula = 'P-TEST-001';


--===============================================
-- 3. PRUEBA INSERTAR ESTUDIANTE ATENDIDO
--===============================================

DECLARE
    v_id_carrera Carrera.id_carrera%TYPE;
    v_id_tipo TipoTlf_Est.id_tipo%TYPE;
BEGIN
    SELECT id_carrera
    INTO v_id_carrera
    FROM Carrera
    WHERE UPPER(nombre_carrera) = 'ING SOFTWARE';

    SELECT id_tipo
    INTO v_id_tipo
    FROM TipoTlf_Est
    WHERE UPPER(nombre_tipo) = 'PERSONAL';

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


--===============================================
-- 4. PRUEBA INSERTAR DOCENTE ATENDIDO
--===============================================

DECLARE
    v_id_facultad Facultad.id_facultad%TYPE;
    v_id_tipo TipoTlf_Docente.id_tipo%TYPE;
BEGIN
    SELECT id_facultad
    INTO v_id_facultad
    FROM Facultad
    WHERE UPPER(nombre_facultad) = 'FACULTAD DE SISTEMAS';

    SELECT id_tipo
    INTO v_id_tipo
    FROM TipoTlf_Docente
    WHERE UPPER(nombre_tipo) = 'PERSONAL';

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


--===============================================
-- 5. PRUEBA INSERTAR ADMINISTRATIVO ATENDIDO
--===============================================

DECLARE
    v_id_tipo TipoTlf_Admin.id_tipo%TYPE;
BEGIN
    SELECT id_tipo
    INTO v_id_tipo
    FROM TipoTlf_Admin
    WHERE UPPER(nombre_tipo) = 'PERSONAL';

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


--===============================================
-- 6. PRUEBA FUNCION TIPO DE PACIENTE
--===============================================

SELECT 
    fn_tipo_paciente_cita(
        (SELECT id_paciente FROM Estudiante WHERE cedula = 'E-TEST-001'),
        NULL,
        NULL
    ) AS tipo_paciente_estudiante
FROM dual;

SELECT 
    fn_tipo_paciente_cita(
        NULL,
        (SELECT id_paciente FROM Docente WHERE cedula = 'D-TEST-001'),
        NULL
    ) AS tipo_paciente_docente
FROM dual;

SELECT 
    fn_tipo_paciente_cita(
        NULL,
        NULL,
        (SELECT id_paciente FROM Administrativo WHERE cedula = 'A-TEST-001')
    ) AS tipo_paciente_admin
FROM dual;


--===============================================
-- 7. PRUEBA FUNCION NOMBRE PACIENTE DE CITA
--===============================================

SELECT 
    fn_nombre_paciente_cita(
        (SELECT id_paciente FROM Estudiante WHERE cedula = 'E-TEST-001'),
        NULL,
        NULL
    ) AS nombre_estudiante
FROM dual;

SELECT 
    fn_nombre_paciente_cita(
        NULL,
        (SELECT id_paciente FROM Docente WHERE cedula = 'D-TEST-001'),
        NULL
    ) AS nombre_docente
FROM dual;

SELECT 
    fn_nombre_paciente_cita(
        NULL,
        NULL,
        (SELECT id_paciente FROM Administrativo WHERE cedula = 'A-TEST-001')
    ) AS nombre_administrativo
FROM dual;


--===============================================
-- 8. PRUEBA INSERTAR CITA PARA ESTUDIANTE
--===============================================

DECLARE
    v_id_servicio Servicio.id_servicio%TYPE;
    v_id_psicologo Psicologo.id_psico%TYPE;
    v_id_estudiante Estudiante.id_paciente%TYPE;
BEGIN
    SELECT id_servicio
    INTO v_id_servicio
    FROM Servicio
    WHERE UPPER(nombre_servicio) = 'ORIENTACION';

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
        '09:00',
        v_id_servicio,
        v_id_estudiante,
        NULL,
        NULL,
        v_id_psicologo
    );
END;
/

SELECT * FROM Cita;


--===============================================
-- 9. PRUEBA INSERTAR CITA PARA DOCENTE
--===============================================

DECLARE
    v_id_servicio Servicio.id_servicio%TYPE;
    v_id_psicologo Psicologo.id_psico%TYPE;
    v_id_docente Docente.id_paciente%TYPE;
BEGIN
    SELECT id_servicio
    INTO v_id_servicio
    FROM Servicio
    WHERE UPPER(nombre_servicio) = 'ORIENTACION';

    SELECT id_psico
    INTO v_id_psicologo
    FROM Psicologo
    WHERE cedula = 'P-TEST-001';

    SELECT id_paciente
    INTO v_id_docente
    FROM Docente
    WHERE cedula = 'D-TEST-001';

    sp_insertar_cita(
        TO_DATE('2026-07-16', 'YYYY-MM-DD'),
        '10:00',
        v_id_servicio,
        NULL,
        v_id_docente,
        NULL,
        v_id_psicologo
    );
END;
/

SELECT * FROM Cita;


--===============================================
-- 10. PRUEBA INSERTAR CITA PARA ADMINISTRATIVO
--===============================================

DECLARE
    v_id_servicio Servicio.id_servicio%TYPE;
    v_id_psicologo Psicologo.id_psico%TYPE;
    v_id_admin Administrativo.id_paciente%TYPE;
BEGIN
    SELECT id_servicio
    INTO v_id_servicio
    FROM Servicio
    WHERE UPPER(nombre_servicio) = 'ORIENTACION';

    SELECT id_psico
    INTO v_id_psicologo
    FROM Psicologo
    WHERE cedula = 'P-TEST-001';

    SELECT id_paciente
    INTO v_id_admin
    FROM Administrativo
    WHERE cedula = 'A-TEST-001';

    sp_insertar_cita(
        TO_DATE('2026-07-17', 'YYYY-MM-DD'),
        '11:00',
        v_id_servicio,
        NULL,
        NULL,
        v_id_admin,
        v_id_psicologo
    );
END;
/

SELECT * FROM Cita;


--===============================================
-- 11. VERIFICAR TRIGGER DE AUDITORIA DE CITAS
--===============================================

SELECT * 
FROM auditoria_cita
ORDER BY aud_id_auditoria;


--===============================================
-- 12. VERIFICAR TRIGGER DE ESTADISTICA DE ATENCIONES
--===============================================

SELECT *
FROM estadistica_atenciones
ORDER BY id_psicologo, id_servicio, tipo_paciente;


--===============================================
-- 13. PRUEBA REPROGRAMAR CITA
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
    WHERE UPPER(nombre_servicio) = 'ORIENTACION';

    SELECT id_psico
    INTO v_id_psicologo
    FROM Psicologo
    WHERE cedula = 'P-TEST-001';

    sp_reprogramar_cita(
        v_id_cita,
        TO_DATE('2026-07-20', 'YYYY-MM-DD'),
        '13:30',
        v_id_servicio,
        v_id_psicologo
    );
END;
/

SELECT * FROM Cita;

SELECT * 
FROM auditoria_cita
ORDER BY aud_id_auditoria;

SELECT *
FROM estadistica_atenciones
ORDER BY id_psicologo, id_servicio, tipo_paciente;


--===============================================
-- 14. PRUEBA ELIMINACION LOGICA DE CITA
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

SELECT * FROM Cita;

SELECT * 
FROM Cita
WHERE estado = 'ELIMINADA';

SELECT * 
FROM auditoria_cita
ORDER BY aud_id_auditoria;

SELECT *
FROM estadistica_atenciones
ORDER BY id_psicologo, id_servicio, tipo_paciente;


--===============================================
-- 15. PRUEBA DIRECTA DEL TRIGGER PACIENTE UNICO
-- DEBE GENERAR ERROR CONTROLADO
--===============================================

DECLARE
    v_id_servicio Servicio.id_servicio%TYPE;
    v_id_psicologo Psicologo.id_psico%TYPE;
    v_id_estudiante Estudiante.id_paciente%TYPE;
    v_id_docente Docente.id_paciente%TYPE;
BEGIN
    SELECT id_servicio
    INTO v_id_servicio
    FROM Servicio
    WHERE UPPER(nombre_servicio) = 'ORIENTACION';

    SELECT id_psico
    INTO v_id_psicologo
    FROM Psicologo
    WHERE cedula = 'P-TEST-001';

    SELECT id_paciente
    INTO v_id_estudiante
    FROM Estudiante
    WHERE cedula = 'E-TEST-001';

    SELECT id_paciente
    INTO v_id_docente
    FROM Docente
    WHERE cedula = 'D-TEST-001';

    INSERT INTO Cita(
        id_cita,
        fecha,
        hora,
        id_servicio,
        id_estudiante,
        id_docente,
        id_admin,
        id_psicologo,
        estado
    ) VALUES (
        seq_id_cita.NEXTVAL,
        TO_DATE('2026-07-21', 'YYYY-MM-DD'),
        '14:00',
        v_id_servicio,
        v_id_estudiante,
        v_id_docente,
        NULL,
        v_id_psicologo,
        'ACTIVA'
    );

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('PRUEBA CORRECTA: EL TRIGGER IMPIDIO ASIGNAR MAS DE UN TIPO DE PACIENTE ' || SQLERRM);
END;
/


--===============================================
-- 16. PRUEBA FUNCION TIPO PACIENTE SIN PACIENTE
-- DEBE GENERAR ERROR CONTROLADO
--===============================================

DECLARE
    v_tipo VARCHAR2(50);
BEGIN
    v_tipo := fn_tipo_paciente_cita(NULL, NULL, NULL);
    DBMS_OUTPUT.PUT_LINE('TIPO: ' || v_tipo);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('PRUEBA CORRECTA: LA FUNCION IMPIDIO CITA SIN PACIENTE ' || SQLERRM);
END;
/


--===============================================
-- 17. PRUEBA DELETE FISICO PARA TRIGGERS
--===============================================

DECLARE
    v_id_cita Cita.id_cita%TYPE;
    v_id_servicio Servicio.id_servicio%TYPE;
    v_id_psicologo Psicologo.id_psico%TYPE;
    v_id_admin Administrativo.id_paciente%TYPE;
BEGIN
    SELECT id_servicio
    INTO v_id_servicio
    FROM Servicio
    WHERE UPPER(nombre_servicio) = 'ORIENTACION';

    SELECT id_psico
    INTO v_id_psicologo
    FROM Psicologo
    WHERE cedula = 'P-TEST-001';

    SELECT id_paciente
    INTO v_id_admin
    FROM Administrativo
    WHERE cedula = 'A-TEST-001';

    INSERT INTO Cita(
        id_cita,
        fecha,
        hora,
        id_servicio,
        id_estudiante,
        id_docente,
        id_admin,
        id_psicologo,
        estado
    ) VALUES (
        seq_id_cita.NEXTVAL,
        TO_DATE('2026-07-22', 'YYYY-MM-DD'),
        '15:00',
        v_id_servicio,
        NULL,
        NULL,
        v_id_admin,
        v_id_psicologo,
        'ACTIVA'
    )
    RETURNING id_cita INTO v_id_cita;

    DELETE FROM Cita
    WHERE id_cita = v_id_cita;
END;
/

SELECT * 
FROM auditoria_cita
ORDER BY aud_id_auditoria;

SELECT *
FROM estadistica_atenciones
ORDER BY id_psicologo, id_servicio, tipo_paciente;


--===============================================
-- 18. PRUEBA TABLA REPORTE_ATENCIONES
-- NOTA: EN EL REPO ACTUAL NO SE ENCONTRO
-- PROCEDIMIENTO sp_generar_reporte_atenciones
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
    TO_DATE(c.hora, 'HH24:MI'),
    p.id_psico,
    p.primer_nombre || ' ' || p.apellido_paterno,
    CASE
        WHEN c.id_estudiante IS NOT NULL THEN c.id_estudiante
        WHEN c.id_docente IS NOT NULL THEN c.id_docente
        WHEN c.id_admin IS NOT NULL THEN c.id_admin
    END,
    fn_nombre_paciente_cita(
        c.id_estudiante,
        c.id_docente,
        c.id_admin
    ),
    fn_tipo_paciente_cita(
        c.id_estudiante,
        c.id_docente,
        c.id_admin
    ),
    s.nombre_servicio,
    USER
FROM Cita c
INNER JOIN Psicologo p
    ON c.id_psicologo = p.id_psico
INNER JOIN Servicio s
    ON c.id_servicio = s.id_servicio
WHERE c.fecha BETWEEN TO_DATE('2026-07-01', 'YYYY-MM-DD')
AND TO_DATE('2026-07-31', 'YYYY-MM-DD')
AND c.estado = 'ACTIVA';

SELECT *
FROM reporte_atenciones
ORDER BY id_reporte;


--===============================================
-- 19. PRUEBA NEGATIVA REPROGRAMAR CITA INEXISTENTE
--===============================================

BEGIN
    sp_reprogramar_cita(
        999999,
        TO_DATE('2026-08-01', 'YYYY-MM-DD'),
        '08:00',
        999999,
        999999
    );

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('PRUEBA CORRECTA: NO SE REPROGRAMO CITA INEXISTENTE ' || SQLERRM);
END;
/


--===============================================
-- 20. PRUEBA NEGATIVA ELIMINAR CITA INEXISTENTE
--===============================================

BEGIN
    sp_eliminar_cita(999999);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('PRUEBA CORRECTA: NO SE ELIMINO CITA INEXISTENTE ' || SQLERRM);
END;
/


--===============================================
-- 21. CONSULTAS FINALES DE VERIFICACION GENERAL
--===============================================

SELECT * FROM cargo;
SELECT * FROM facultad;
SELECT * FROM carrera;
SELECT * FROM servicio;

SELECT * FROM Psicologo;
SELECT * FROM Estudiante;
SELECT * FROM Docente;
SELECT * FROM Administrativo;

SELECT * FROM Tlf_Estudiante;
SELECT * FROM Tlf_Docente;
SELECT * FROM Tlf_Admin;

SELECT * FROM Cita
ORDER BY id_cita;

SELECT * FROM auditoria_cita
ORDER BY aud_id_auditoria;

SELECT * FROM estadistica_atenciones
ORDER BY id_psicologo, id_servicio, tipo_paciente;

SELECT * FROM reporte_atenciones
ORDER BY id_reporte;