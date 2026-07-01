--===============================================
-- PROCEDIMIENTO IMPLEMENTAR TABLAS PARAMETRICAS
--===============================================
CREATE OR REPLACE PROCEDURE sp_cargar_parametricas(
    p_nombre_cargo IN cargo.nombre_cargo%TYPE,
    p_nombre_facultad IN facultad.nombre_facultad%TYPE,
    p_nombre_carrera IN carrera.nombre_carrera%TYPE,
    p_nombre_servicio IN servicio.nombre_servicio%TYPE,
    p_tipo_tlf_est IN TipoTlf_Est.nombre_tipo%TYPE,
    p_tipo_tlf_doc IN TipoTlf_Docente.nombre_tipo%TYPE,
    p_tipo_tlf_admin IN TipoTlf_Admin.nombre_tipo%TYPE
) AS
    v_id_facultad facultad.id_facultad%TYPE;
BEGIN
    --insertar cargo nuevo
    INSERT INTO cargo (
                id_cargo,
                nombre_cargo
    ) 
    SELECT
        seq_id_cargo.NEXTVAL,
        p_nombre_cargo
    FROM dual
    WHERE NOT EXISTS (
        SELECT 1
        FROM cargo
        WHERE UPPER(TRIM(nombre_cargo)) = UPPER(TRIM(p_nombre_cargo))
    );
    -- insertar facultad nueva
    INSERT INTO facultad (
                id_facu,
                nombre_facultad
    ) 
    SELECT
        seq_id_facultad.NEXTVAL,
        p_nombre_facultad
    FROM dual
    WHERE NOT EXISTS (
        SELECT 1
        FROM facultad
        WHERE UPPER(TRIM(nombre_facultad)) = UPPER(TRIM(p_nombre_facultad))
    );
    -- carrera
    SELECT id_facu
        INTO v_id_facultad
    FROM facultad
    WHERE UPPER(TRIM(nombre_facultad)) = UPPER(TRIM(p_nombre_facultad));


    INSERT INTO carrera (
                id_carrera,
                nombre_carrera,
                id_facu
    ) 
    SELECT
        seq_id_carrera.NEXTVAL,
        p_nombre_carrera,
        v_id_facultad
    FROM dual
    WHERE NOT EXISTS (
        SELECT 1
        FROM carrera
        WHERE UPPER(TRIM(nombre_carrera)) = UPPER(TRIM(p_nombre_carrera))
        AND v_id_facultad = id_facu
    );

    -- servicio

    INSERT INTO servicio (
        id_servicio,
        nombre_servicio
    )
    SELECT
        seq_id_servicio.NEXTVAL,
        p_nombre_servicio
    FROM dual
    WHERE NOT EXISTS (
        SELECT 1
        FROM servicio
        WHERE UPPER(TRIM(nombre_servicio)) = UPPER(TRIM(p_nombre_servicio))
    );

    -- tipo telefono estudiante
    INSERT INTO TipoTlf_Est (
    id_tipo,
    nombre_tipo
    )
    SELECT
        seq_id_tipo_tlf_est.NEXTVAL,
        p_tipo_tlf_est
    FROM dual
    WHERE NOT EXISTS (
        SELECT 1
        FROM TipoTlf_Est
        WHERE UPPER(TRIM(nombre_tipo)) = UPPER(TRIM(p_tipo_tlf_est))
    );

    -- tipo telefono docente
    INSERT INTO TipoTlf_Docente (
    id_tipo,
    nombre_tipo
    )
    SELECT
        seq_id_tipo_tlf_doc.NEXTVAL,
        p_tipo_tlf_doc
    FROM dual
    WHERE NOT EXISTS (
        SELECT 1
        FROM TipoTlf_Docente
        WHERE UPPER(TRIM(nombre_tipo)) = UPPER(TRIM(p_tipo_tlf_doc))
    );

    -- tipo telefono admin
    INSERT INTO TipoTlf_Admin (
    id_tipo,
    nombre_tipo
    )

    SELECT
        seq_id_tipo_tlf_admin.NEXTVAL,
       p_tipo_tlf_admin
    FROM dual
    WHERE NOT EXISTS (
        SELECT 1
        FROM TipoTlf_Admin
        WHERE UPPER(TRIM(nombre_tipo)) = UPPER(TRIM(p_tipo_tlf_admin))
    );

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: No existe facultad requerida para insetar la carrera' || SQLERRM);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR de ejecucion' || SQLERRM);
END;
/


--===============================================
-- PROCEDIMIENTO INSERTAR PSICONIGGA
--===============================================

CREATE OR REPLACE PROCEDURE sp_insertar_psicologo(
    p_psico_primer_nombre IN psicologo.primer_nombre%TYPE,
    p_psico_segundo_nombre IN psicologo.segundo_nombre%TYPE,
    p_psico_apellido_pat IN psicologo.apellido_paterno%TYPE,
    p_psico_apellido_mat IN psicologo.apellido_materno%TYPE,
    p_psico_cedula IN psicologo.cedula%TYPE,
    p_psico_genero IN psicologo.genero%TYPE,
    p_psico_correo_institucional IN psicologo.correo_institucional%TYPE,
    p_psico_casa IN psicologo.casa%TYPE,
    p_psico_calle IN psicologo.calle%TYPE,
    p_psico_corregimiento IN psicologo.corregimiento%TYPE,
    p_psico_id_cargo IN psicologo.id_cargo%TYPE
) AS
    v_id_cargo psicologo.id_cargo%TYPE;
BEGIN

    SELECT id_cargo
        INTO v_id_cargo
    FROM cargo
    WHERE id_cargo = p_psico_id_cargo;

    INSERT INTO psicologo (
        id_psico, 
        primer_nombre, 
        segundo_nombre,
        apellido_paterno,
        apellido_materno,
        cedula, 
        genero,
        correo_institucional,
        telefono,
        casa, 
        calle,
        corregimiento, 
        id_cargo
    ) VALUES (
        seq_id_psicologo.NEXTVAL,
        p_psico_primer_nombre,
        p_psico_segundo_nombre,
        p_psico_apellido_pat,
        p_psico_apellido_mat,
        p_psico_cedula,
        p_psico_genero,
        p_psico_correo_institucional,
        p_psico_casa,
        p_psico_calle,
        p_psico_corregimiento,
        p_psico_id_cargo
    );

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('ERROR NO DATOS SOBRE EL CUAL EJECUTAR EL PROCEDIMIENTO' || SQLERRM);
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('ERROR MAS DE UN DATO EN INDICE' || SQLERRM);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR DE EJECUCION ' || SQLERRM);
END;
/