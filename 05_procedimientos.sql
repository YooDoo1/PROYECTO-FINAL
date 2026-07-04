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
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('ERROR INDICE DUPLICADO' || SQLERRM);
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


--===============================================
-- PROCEDIMIENTO INSERTAR ESTUDIANTE ATENDIDO
--===============================================
CREATE OR REPLACE PROCEDURE sp_insertar_estudiante(
    p_primer_nombre IN estudiante.primer_nombre%TYPE,
    p_segundo_nombre IN estudiante.segundo_nombre%TYPE,
    p_apellido_pat IN estudiante.apellido_paterno%TYPE,
    p_apellido_mat IN estudiante.apellido_materno%TYPE,
    p_cedula IN estudiante.cedula%TYPE,
    p_genero IN estudiante.genero%TYPE,
    p_correo_institucional IN estudiante.correo_institucional%TYPE,
    p_casa IN estudiante.casa%TYPE,
    p_calle IN estudiante.calle%TYPE,
    p_corregimiento IN estudiante.corregimiento%TYPE,
    p_id_carrera IN estudiante.id_carrera%TYPE,
    p_id_tipo_telefono IN Tlf_Estudiante.idTipo%TYPE,
    p_telefono IN Tlf_Estudiante.telefono%TYPE
)
AS
    v_id_paciente estudiante.id_paciente%TYPE;
    v_id_carrera NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_id_carrera
    FROM carrera
    WHERE id_carrera = p_id_carrera;

    IF v_id_carrera = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'NO EXISTE ESTA CARRERA. NO SE PUEDE REGISTRAR AL ESTUDIANTE');
    END IF;
    
    INSERT INTO estudiante (
        id_paciente,
        primer_nombre,
        segundo_nombre,
        apellido_paterno,
        apellido_materno,
        cedula,
        genero,
        correo_institucional,
        casa,
        calle,
        corregimiento,
        id_carrera
    ) VALUES (
        v_id_paciente,
        p_primer_nombre,
        p_segundo_nombre,
        p_apellido_pat,
        p_apellido_mat,
        p_cedula,
        p_genero,
        p_correo_institucional,
        p_casa,
        p_calle,
        p_corregimiento,
        p_id_carrera
    );

    INSERT INTO Tlf_Estudiante (
        idPaciente,
        idTipo,
        telefono
    ) VALUES (
        v_id_paciente,
        p_id_tipo_telefono,
        p_telefono
    );

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('ERROR INDICE DUPLICADO' || SQLERRM);
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('ERROR NO DATOS ENCONTRADOS' || SQLERRM);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR DE EJECUCION' || SQLERRM);
END;
/

--===============================================
-- PROCEDIMIENTO INSERTAR DOCENTE ATENDIDO
--===============================================
CREATE OR REPLACE PROCEDURE sp_insertar_docente(
    p_primer_nombre IN docente.primer_nombre%TYPE,
    p_segundo_nombre IN docente.segundo_nombre%TYPE,
    p_apellido_paterno IN docente.apellido_paterno%TYPE,
    p_apellido_materno IN docente.apellido_materno%TYPE,
    p_cedula IN docente.cedula%TYPE,
    p_genero IN docente.genero%TYPE,
    p_correo_institucional IN docente.correo_institucional%TYPE,
    p_telefono_personal IN docente.telefono_personal%TYPE,
    p_casa IN docente.casa%TYPE,
    p_calle IN docente.calle%TYPE,
    p_corregimiento IN docente.corregimiento%TYPE,
    p_id_facultad IN docente.id_facultad%TYPE,
    p_id_tipo_telefono IN Tlf_Docente.idTipo%TYPE,
    p_telefono IN Tlf_Docente.telefono%TYPE
)
AS
    v_id_paciente   docente.id_paciente%TYPE;
    v_id_facultad   NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_id_facultad
    FROM facultad
    WHERE id_facultad = p_id_facultad;

    IF v_id_facultad = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'NO EXISTE ESTA FACULTAD. NO SE PUEDE REGISTRAR AL DOCENTE');
    END IF;

    INSERT INTO docente (
        primer_nombre,
        segundo_nombre,
        apellido_paterno,
        apellido_materno,
        cedula,
        genero,
        correo_institucional,
        telefono_personal,
        casa,
        calle,
        corregimiento,
        id_facultad
    ) VALUES (
        p_primer_nombre,
        p_segundo_nombre,
        p_apellido_paterno,
        p_apellido_materno,
        p_cedula,
        p_genero,
        p_correo_institucional,
        p_telefono_personal,
        p_casa,
        p_calle,
        p_corregimiento,
        p_id_facultad
    )
    RETURNING id_paciente INTO v_id_paciente;

    INSERT INTO Tlf_Docente (
        idPaciente,
        idTipo,
        telefono
    ) VALUES (
        v_id_paciente,
        p_id_tipo_telefono,
        p_telefono
    );

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('ERROR INDICE DUPLICADO' || SQLERRM);
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('ERROR NO DATOS ENCONTRADOS' || SQLERRM);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR DE EJECUCION' || SQLERRM);
END;
/

--===============================================
-- PROCEDIMIENTO INSERTAR ADMINISTRATIVO ATENDIDO
--===============================================
CREATE OR REPLACE PROCEDURE sp_insertar_administrativo(
    p_primer_nombre IN administrativo.primer_nombre%TYPE,
    p_segundo_nombre IN administrativo.segundo_nombre%TYPE,
    p_apellido_paterno IN administrativo.apellido_paterno%TYPE,
    p_apellido_materno IN administrativo.apellido_materno%TYPE,
    p_cedula IN administrativo.cedula%TYPE,
    p_genero IN administrativo.genero%TYPE,
    p_correo_institucional IN administrativo.correo_institucional%TYPE,
    p_telefono_personal IN administrativo.telefono_personal%TYPE,
    p_casa IN administrativo.casa%TYPE,
    p_calle IN administrativo.calle%TYPE,
    p_corregimiento IN administrativo.corregimiento%TYPE,
    p_departamento IN administrativo.departamento%TYPE,
    p_id_tipo_telefono IN Tlf_Admin.idTipo%TYPE,
    p_telefono IN Tlf_Admin.telefono%TYPE
)
AS
    v_id_paciente administrativo.id_paciente%TYPE;
BEGIN
    INSERT INTO administrativo (
        primer_nombre,
        segundo_nombre,
        apellido_paterno,
        apellido_materno,
        cedula,
        genero,
        correo_institucional,
        telefono_personal,
        casa,
        calle,
        corregimiento,
        departamento
    ) VALUES (
        p_primer_nombre,
        p_segundo_nombre,
        p_apellido_paterno,
        p_apellido_materno,
        p_cedula,
        p_genero,
        p_correo_institucional,
        p_telefono_personal,
        p_casa,
        p_calle,
        p_corregimiento,
        p_departamento
    )
    RETURNING id_paciente INTO v_id_paciente;

    INSERT INTO Tlf_Admin (
        idPaciente,
        idTipo,
        telefono
    ) VALUES (
        v_id_paciente,
        p_id_tipo_telefono,
        p_telefono
    );

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('ERROR INDICE DUPLICADO' || SQLERRM);
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('ERROR NO DATOS ENCONTRADOS' || SQLERRM);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR DE EJECUCION' || SQLERRM);
END;
/

--===============================================
-- PROCEDIMIENTO INSERTAR CITA
--===============================================

CREATE OR REPLACE PROCEDURE sp_insertar_cita(
    p_fecha IN cita.fecha%TYPE,
    p_hora IN cita.hora%TYPE,
    p_id_servicio IN cita.id_servicio%TYPE,
    p_id_estudiante IN cita.id_estudiante%TYPE,
    p_id_docente IN cita.id_docente%TYPE,
    p_id_admin IN cita.id_admin%TYPE,
    p_id_psicologo IN cita.id_psicologo%TYPE
)
AS
    v_tipo VARCHAR2(20);
BEGIN
    v_tipo := fn_tipo_paciente_cita(
        p_id_estudiante,
        p_id_docente,
        p_id_admin
    );
    
    IF v_tipo = 'ESTUDIANTE' THEN
        INSERT INTO cita(
            fecha,
            hora,
            id_servicio,
            id_estudiante,
            id_docente,
            id_admin,
            id_psicologo
        ) VALUES (
            p_fecha,
            p_hora,
            p_id_servicio,
            p_id_estudiante,
            NULL,
            NULL,
            p_id_psicologo
        );

    ELSIF v_tipo = 'DOCENTE' THEN
        INSERT INTO cita(
            fecha,
            hora,
            id_servicio,
            id_estudiante,
            id_docente,
            id_admin,
            id_psicologo
        ) VALUES (
            p_fecha,
            p_hora,
            p_id_servicio,
            NULL,
            p_id_docente,
            NULL,
            p_id_psicologo
        );

    ELSIF v_tipo = 'ADMINISTRATIVO' THEN
        INSERT INTO cita(
            fecha,
            hora,
            id_servicio,
            id_estudiante,
            id_docente,
            id_admin,
            id_psicologo
        ) VALUES (
            p_fecha,
            p_hora,
            p_id_servicio,
            NULL,
            NULL,
            p_id_admin,
            p_id_psicologo
        );
    END IF;
    
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('ERROR INDICE DUPLICADO' || SQLERRM);
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('ERROR NO DATOS ENCONTRADOS' || SQLERRM);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR DE EJECUCION' || SQLERRM);
END;
/

--===============================================
-- PROCEDIMIENTO REPROGRAMAR CITA
--===============================================

CREATE OR REPLACE PROCEDURE sp_reprogramar_cita(
    p_id_cita IN Cita.id_cita%TYPE,
    p_nueva_fecha IN Cita.fecha%TYPE,
    p_nueva_hora IN Cita.hora%TYPE,
    p_id_servicio IN Cita.id_servicio%TYPE,
    p_id_psicologo IN Cita.id_psicologo%TYPE
)
AS
    v_id_cita NUMBER;
    v_id_servicio NUMBER;
    v_id_psicologo NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_id_cita
    FROM Cita
    WHERE id_cita = p_id_cita;

    IF v_id_cita = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'NO EXISTE ESTA CITA. NO SE PUEDE REPROGRAMAR');
    END IF;

    SELECT COUNT(*)
    INTO v_id_servicio
    FROM servicio
    WHERE id_servicio = p_id_servicio;

    IF v_id_servicio = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'NO EXISTE ESTE SERVICIO. NO SE PUEDE REPROGRAMAR LA CITA');
    END IF;

    SELECT COUNT(*)
    INTO v_id_psicologo
    FROM psicologo
    WHERE id_psico = p_id_psicologo;

    IF v_id_psicologo = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'NO EXISTE ESTE PSICOLOGO. NO SE PUEDE REPROGRAMAR LA CITA');
    END IF;

    UPDATE cita
    SET
        fecha = p_nueva_fecha,
        hora = p_nueva_hora,
        id_servicio = p_id_servicio,
        id_psicologo = p_id_psicologo
    WHERE id_cita = p_id_cita;

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('ERROR INDICES DUPLICADOS' || SQLERRM);
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('ERROR NO DATOS ENCONTRADOS' || SQLERRM);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR DE EJECUCION' || SQLERRM);
END;
/

--===============================================
-- PROCEDIMIENTO ELIMINAR CITA
--===============================================

CREATE OR REPLACE PROCEDURE sp_eliminar_cita(
    p_id_cita IN Cita.id_cita%TYPE
)
AS
    v_id_cita NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_id_cita
    FROM Cita
    WHERE id_cita = p_id_cita;

    IF v_id_cita = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'ERROR LA CITA NO EXISTE');

    ELSE
        UPDATE Cita
        SET
            estado = 'ELIMINADA'
        WHERE id_cita = p_id_cita;
    END IF;
    
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('ERROR INDICES DUPLICADOS' || SQLERRM);
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('ERROR NO DATOS ENCONTRADOS' || SQLERRM);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR DE EJECUCION' || SQLERRM);
END;
/