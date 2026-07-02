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