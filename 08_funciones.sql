--===============================================
-- FUNCION IDENTIFICAR TIPO DE PACIENTE
--===============================================

CREATE OR REPLACE FUNCTION fn_tipo_paciente_cita(
    p_id_estudiante IN cita.id_estudiante%TYPE,
    p_id_docente IN cita.id_docente%TYPE,
    p_id_admin IN cita.id_admin%TYPE
) RETURN VARCHAR2
AS
    contar_id NUMBER := 0;
BEGIN
    IF p_id_estudiante IS NOT NULL THEN
        contar_id := contar_id + 1;
    END IF;
    IF p_id_docente IS NOT NULL THEN
        contar_id := contar_id + 1;
    END IF;
    IF p_id_admin IS NOT NULL THEN
        contar_id := contar_id + 1;
    END IF;

    IF contar_id = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'LA CITA DEBE ESTAR ASIGNADA A UN PACIENTE');
    END IF;
    IF contar_id > 1 THEN
        RAISE_APPLICATION_ERROR(-20002, 'LA ID PAR ACITA NI SE PUEDE APLICAR A MAS DE UN ROL');
    END IF; 

    IF p_id_estudiante IS NOT NULL THEN
        RETURN 'ESTUDIANTE';
    ELSIF p_id_docente IS NOT NULL THEN
        RETURN 'DOCENTE';
    ELSE
        RETURN 'ADMINISTRATIVO';
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('ERROR NO EXISTE DATOS SOBRE LOS CUALES OPERAR LA FUNCION ' || SQLERRM);
        RETURN NULL;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR DE EJECUCION' || SQLERRM);
        RETURN NULL;
END;
/

--===============================================
-- FUNCION OBTENER NOMBRE PACIENTE DE CITA
--===============================================

CREATE OR REPLACE FUNCTION fn_nombre_paciente_cita(
    p_id_estudiante IN Cita.id_estudiante%TYPE,
    p_id_docente IN Cita.id_docente%TYPE,
    p_id_admin IN Cita.id_admin%TYPE
) RETURN VARCHAR2
AS
    v_nombre estudiante.primer_nombre%TYPE;
    v_apellido estudiante.apellido_paterno%TYPE;
BEGIN

    IF p_id_estudiante IS NOT NULL THEN
        SELECT 
            primer_nombre,
            apellido_paterno
        INTO 
            v_nombre,
            v_apellido
        FROM estudiante
        WHERE id_paciente = p_id_estudiante;

    ELSIF p_id_docente IS NOT NULL THEN
        SELECT
            primer_nombre,
            apellido_paterno
        INTO 
            v_nombre,
            v_apellido
        FROM docente
        WHERE id_paciente = p_id_docente;

    ELSIF p_id_admin IS NOT NULL THEN
        SELECT
            primer_nombre,
            apellido_paterno
        INTO 
            v_nombre,
            v_apellido
        FROM administrativo
        WHERE id_paciente = p_id_admin;
    END IF;

    RETURN v_nombre || ' ' || v_apellido;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('ERROR NO EXISTE DATOS SOBRE LOS CUALES OPERAR LA FUNCION ' || SQLERRM);
        RETURN NULL;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR DE EJECUCION' || SQLERRM);
        RETURN NULL;
END;
/