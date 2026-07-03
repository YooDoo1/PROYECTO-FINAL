/* ============================================================================
   3. TRIGGER
   ============================================================================ */


/* ---------------------------------------------------------------------------
   TRIGGER: TRG_CITA_PACIENTE_UNICO
   Propósito:
   Valida que cada cita tenga exactamente un paciente asociado.

   Regla de negocio:
   Una cita no puede pertenecer simultáneamente a estudiante, docente
   y administrativo. Debe pertenecer a uno solo.
--------------------------------------------------------------------------- */
CREATE OR REPLACE TRIGGER trg_cita_paciente_unico
BEFORE INSERT OR UPDATE ON Cita
FOR EACH ROW
DECLARE
    v_count NUMBER := 0;
BEGIN
    IF :NEW.id_estudiante IS NOT NULL THEN
        v_count := v_count + 1;
    END IF;

    IF :NEW.id_docente IS NOT NULL THEN
        v_count := v_count + 1;
    END IF;

    IF :NEW.id_admin IS NOT NULL THEN
        v_count := v_count + 1;
    END IF;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'Debe especificar exactamente un tipo de paciente: estudiante, docente o admin.'
        );
    ELSIF v_count > 1 THEN
        RAISE_APPLICATION_ERROR(
            -20002,
            'Solo puede haber un tipo de paciente asociado a la cita.'
        );
    END IF;
END;
/

--===============================================
-- TRIGGER PACIENTE UNICO POR CITA
--===============================================

CREATE OR REPLACE TRIGGER trg_cita_paciente_unico
BEFORE
INSERT OR UPDATE ON cita
FOR EACH ROW
DECLARE
    v_contador NUMBER := 0;
BEGIN
    IF :NEW.id_estudiante IS NOT NULL THEN
        v_contador := v_contador +1;
    END IF;

    IF :NEW.id_docente IS NOT NULL THEN
        v_contador := v_contador +1;
    END IF;

    IF :NEW.id_admin IS NOT NULL THEN
        v_contador := v_contador +1;
    END IF;

    IF v_contador = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'NO SE PERMITE NO ASIGNAR TIPO PACIENTE');
    END IF;
    IF v_contador > 1 THEN
        RAISE_APPLICATION_ERROR(-20002, 'NO SE PERMITE ASIGNAR MAS DE UN TIPO PACIENTE');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR DE EJECUCION ' || SQLERRM);
END;
/

--===============================================
-- TRIGGER ACTUALIZAR AUDITORIA DE CITAS
--===============================================

CREATE OR REPLACE TRIGGER tr_auditoria_cita
AFTER INSERT OR UPDATE OR DELETE ON Cita
FOR EACH ROW
DECLARE
    v_id_cita auditoria_cita.aud_id_cita%TYPE;
    v_tipo auditoria_cita.aud_tipo_operacion%TYPE;
    v_fecha_anterior auditoria_cita.aud_fecha_anterior%TYPE;
    v_fecha_nueva auditoria_cita.aud_fecha_nueva%TYPE;
    v_hora_anterior auditoria_cita.aud_hora_anterior%TYPE;
    v_hora_nueva auditoria_cita.aud_hora_nueva%TYPE;
    v_id_serv_anterior auditoria_cita.aud_id_servicio_anterior%TYPE;
    v_id_serv_nuevo auditoria_cita.aud_id_servicio_nuevo%TYPE;
    v_id_psico_anterior auditoria_cita.aud_id_psicologo_anterior%TYPE;
    v_id_psico_nuevo auditoria_cita.aud_id_psicologo_nuevo%TYPE;
BEGIN
    IF INSERTING THEN
        v_id_cita := :NEW.id_cita;
        v_tipo := 'INSERT';
        v_fecha_anterior := NULL;
        v_fecha_nueva := :NEW.fecha;
        v_hora_anterior := NULL;
        v_hora_nueva := :NEW.hora;
        v_id_serv_anterior := NULL;
        v_id_serv_nuevo := :NEW.id_servicio;
        v_id_psico_anterior := NULL;
        v_id_psico_nuevo := :NEW.id_psicologo;

    ELSIF UPDATING THEN
        v_id_cita := :NEW.id_cita;
        v_tipo := 'UPDATE';
        v_fecha_anterior := :OLD.fecha;
        v_fecha_nueva := :NEW.fecha;
        v_hora_anterior := :OLD.hora;
        v_hora_nueva := :NEW.hora;
        v_id_serv_anterior := :OLD.id_servicio;
        v_id_serv_nuevo := :NEW.id_servicio;
        v_id_psico_anterior := :OLD.id_psicologo;
        v_id_psico_nuevo := :NEW.id_psicologo;

    ELSIF DELETING THEN
        v_id_cita := :OLD.id_cita;
        v_tipo := 'DELETE';
        v_fecha_anterior := :OLD.fecha;
        v_fecha_nueva := NULL;
        v_hora_anterior := :OLD.hora;
        v_hora_nueva := NULL;
        v_id_serv_anterior := :OLD.id_servicio;
        v_id_serv_nuevo := NULL;
        v_id_psico_anterior := :OLD.id_psicologo;
        v_id_psico_nuevo := NULL;
    END IF;

    INSERT INTO auditoria_cita(
        aud_id_auditoria,
        aud_tabla_editada, 
        aud_id_cita, 
        aud_tipo_operacion, 
        aud_fecha_anterior, 
        aud_fecha_nueva, 
        aud_hora_anterior, 
        aud_hora_nueva, 
        aud_id_servicio_anterior, 
        aud_id_servicio_nuevo, 
        aud_id_psicologo_anterior, 
        aud_id_psicologo_nuevo, 
        aud_cita_usuario, 
        aud_cita_fecha
    ) VALUES (
        seq_auditoria.NEXTVAL,
        'CITA',
        v_id_cita,
        v_tipo,
        v_fecha_anterior,
        v_fecha_nueva,
        v_hora_anterior,
        v_hora_nueva,
        v_id_serv_anterior,
        v_id_serv_nuevo,
        v_id_psico_anterior,
        v_id_psico_nuevo,
        USER,
        SYSDATE
    );

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('ERROR INDICE DUPLICADO' || SQLERRM);
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('ERROR NO DATOS ENCONTRADOS' || SQLERRM);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR DE EJECUCION ' || SQLERRM);
END;
/