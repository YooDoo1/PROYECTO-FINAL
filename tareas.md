
1. **Crear secuencias para los identificadores principales del modelo PSIREG.** HECHO
   **Tipo de proceso SQL:** `CREATE SEQUENCE`.
   **Enunciado:** Se deben implementar secuencias para eliminar la inserción manual de identificadores y garantizar consistencia en las llaves primarias del modelo físico. Esto mantiene el control de generación de IDs en Oracle y evita duplicidad durante la carga mediante procedimientos.
   **Objetos a crear:** `seq_cargo`, `seq_psicologo`, `seq_facultad`, `seq_carrera`, `seq_estudiante`, `seq_docente`, `seq_administrativo`, `seq_servicio`, `seq_cita`.
   **Tablas/columnas afectadas:** `cargo.id_cargo`, `psicologo.id_psico`, `facultad.id_facultad`, `carrera.id_carrera`, `estudiante.id_paciente`, `docente.id_paciente`, `administrativo.id_paciente`, `servicio.id_servicio`, `cita.id_cita`.

2. **Crear procedimiento para cargar tablas paramétricas iniciales.** HECHO
   **Tipo de proceso SQL:** `CREATE OR REPLACE PROCEDURE sp_cargar_parametricas`.
   **Enunciado:** Se debe implementar un procedimiento que cargue los registros base requeridos antes de operar el sistema, garantizando que existan cargos, facultades, carreras, servicios y tipos de teléfono antes de registrar psicólogos, pacientes o citas. Este proceso respeta las dependencias del modelo Entidad-Relación.
   **Qué hace:** inserta datos iniciales y evita duplicados mediante validación `NOT EXISTS` o manejo de excepción `DUP_VAL_ON_INDEX`.
   **Tablas/columnas afectadas:** `cargo(id_cargo, nombre_cargo)`, `facultad(id_facultad, nombre_facultad)`, `carrera(id_carrera, nombre_carrera, id_facu)`, `servicio(id_servicio, nombre_servicio)`, `TipoTlf_Est(id_tipo, nombre_tipo)`, `TipoTlf_Docente(id_tipo, nombre_tipo)`, `TipoTlf_Admin(id_tipo, nombre_tipo)`.

3. **Crear procedimiento para registrar psicólogos.** HECHO
   **Tipo de proceso SQL:** `CREATE OR REPLACE PROCEDURE sp_insertar_psicologo`.
   **Enunciado:** Se debe implementar un procedimiento para registrar psicólogos, ya que esta entidad atiende las citas psicológicas dentro del modelo de negocio. El procedimiento debe validar que el cargo exista antes de insertar, manteniendo la integridad referencial con `cargo`.
   **Qué hace:** inserta un psicólogo con datos personales, contacto, dirección y cargo.
   **Parámetros requeridos:** `p_primer_nombre`, `p_segundo_nombre`, `p_apellido_paterno`, `p_apellido_materno`, `p_cedula`, `p_genero`, `p_correo_institucional`, `p_telefono`, `p_casa`, `p_calle`, `p_corregimiento`, `p_id_cargo`.
   **Tablas/columnas afectadas:** `psicologo(id_psico, primer_nombre, segundo_nombre, apellido_paterno, apellido_materno, cedula, genero, correo_institucional, telefono, casa, calle, corregimiento, id_cargo)`.

4. **Crear procedimiento para registrar estudiantes atendidos.** HECHO
   **Tipo de proceso SQL:** `CREATE OR REPLACE PROCEDURE sp_insertar_estudiante`.
   **Enunciado:** Se debe implementar un procedimiento para registrar estudiantes como tipo de paciente. La inserción debe validar la carrera asociada, porque el estudiante pertenece a una carrera dentro del modelo lógico. También debe registrar su teléfono en la tabla correspondiente.
   **Qué hace:** inserta el estudiante y su teléfono asociado.
   **Parámetros requeridos:** `p_primer_nombre`, `p_segundo_nombre`, `p_apellido_paterno`, `p_apellido_materno`, `p_cedula`, `p_genero`, `p_correo_institucional`, `p_casa`, `p_calle`, `p_corregimiento`, `p_id_carrera`, `p_id_tipo_telefono`, `p_telefono`.
   **Tablas/columnas afectadas:** `estudiante(id_paciente, primer_nombre, segundo_nombre, apellido_paterno, apellido_materno, cedula, genero, correo_institucional, casa, calle, corregimiento, id_carrera)`, `Tlf_Estudiante(idPaciente, idTipo, telefono)`.

5. **Crear procedimiento para registrar docentes atendidos.** HECHA
   **Tipo de proceso SQL:** `CREATE OR REPLACE PROCEDURE sp_insertar_docente`.
   **Enunciado:** Se debe implementar un procedimiento para registrar docentes como pacientes atendidos por la DNOP. El procedimiento debe validar la facultad asociada, ya que el docente pertenece a una facultad en el modelo relacional.
   **Qué hace:** inserta el docente y su teléfono asociado.
   **Parámetros requeridos:** `p_primer_nombre`, `p_segundo_nombre`, `p_apellido_paterno`, `p_apellido_materno`, `p_cedula`, `p_genero`, `p_correo_institucional`, `p_telefono_personal`, `p_casa`, `p_calle`, `p_corregimiento`, `p_id_facultad`, `p_id_tipo_telefono`, `p_telefono`.
   **Tablas/columnas afectadas:** `docente(id_paciente, primer_nombre, segundo_nombre, apellido_paterno, apellido_materno, cedula, genero, correo_institucional, telefono_personal, casa, calle, corregimiento, id_facultad)`, `Tlf_Docente(idPaciente, idTipo, telefono)`.

6. **Crear procedimiento para registrar administrativos atendidos.** HECHA
   **Tipo de proceso SQL:** `CREATE OR REPLACE PROCEDURE sp_insertar_administrativo`.
   **Enunciado:** Se debe implementar un procedimiento para registrar administrativos como el tercer tipo de paciente del modelo. Este proceso mantiene separada la información de administrativos, estudiantes y docentes, respetando la especialización definida en el modelo Entidad-Relación.
   **Qué hace:** inserta el administrativo y su teléfono asociado.
   **Parámetros requeridos:** `p_primer_nombre`, `p_segundo_nombre`, `p_apellido_paterno`, `p_apellido_materno`, `p_cedula`, `p_genero`, `p_correo_institucional`, `p_telefono_personal`, `p_casa`, `p_calle`, `p_corregimiento`, `p_departamento`, `p_id_tipo_telefono`, `p_telefono`.
   **Tablas/columnas afectadas:** `administrativo(id_paciente, primer_nombre, segundo_nombre, apellido_paterno, apellido_materno, cedula, genero, correo_institucional, telefono_personal, casa, calle, corregimiento, departamento)`, `Tlf_Admin(idPaciente, idTipo, telefono)`.

7. **Crear función para validar e identificar el tipo de paciente asociado a una cita.** HECHO
   **Tipo de proceso SQL:** `CREATE OR REPLACE FUNCTION fn_tipo_paciente_cita`.
   **Enunciado:** Se debe implementar una función que centralice la regla de negocio de la tabla `cita`: una cita solo puede estar asociada a un estudiante, un docente o un administrativo, nunca a varios al mismo tiempo. Esto evita repetir la misma validación en procedimientos y reportes.
   **Qué hace:** recibes `p_id_estudiante`, `p_id_docente`, `p_id_admin`; retorna `ESTUDIANTE`, `DOCENTE` o `ADMINISTRATIVO`; si no hay paciente o hay más de uno, debe generar error.
   **Tablas/columnas evaluadas:** `cita.id_estudiante`, `cita.id_docente`, `cita.id_admin`.
   **Tablas modificadas:** ninguna; es función de validación. 

8. **Crear procedimiento para registrar citas psicológicas.** HECHO
   **Tipo de proceso SQL:** `CREATE OR REPLACE PROCEDURE sp_insertar_cita`.
   **Enunciado:** Se debe implementar un procedimiento para registrar citas, porque la cita representa la atención psicológica principal del sistema PSIREG. El proceso debe validar servicio, psicólogo y tipo único de paciente antes de insertar.
   **Qué hace:** inserta una cita psicológica y debe invocar `fn_tipo_paciente_cita` para validar que solo se indique un paciente.
   **Parámetros requeridos:** `p_fecha`, `p_hora`, `p_id_servicio`, `p_id_estudiante`, `p_id_docente`, `p_id_admin`, `p_id_psicologo`.
   **Tablas/columnas afectadas:** `cita(id_cita, fecha, hora, id_servicio, id_estudiante, id_docente, id_admin, id_psicologo)`.

9. **Documentar y conservar el trigger de paciente único por cita.** HECHO
   **Tipo de proceso SQL:** `CREATE OR REPLACE TRIGGER trg_cita_paciente_unico`.
   **Enunciado:** El trigger existente debe mantenerse y documentarse porque protege directamente la tabla `cita` ante inserciones o actualizaciones realizadas fuera del procedimiento. Esto refuerza la integridad semántica del modelo, donde cada cita pertenece a un solo tipo de paciente.
   **Qué hace:** antes de `INSERT` o `UPDATE`, cuenta si se llenó `id_estudiante`, `id_docente` o `id_admin`. Si no hay ninguno o hay más de uno, genera error.
   **Tablas/columnas afectadas:** valida `cita.id_estudiante`, `cita.id_docente`, `cita.id_admin`.
   **Tablas modificadas:** ninguna.

10. **Crear tabla de auditoría para citas.**  HECHO
    **Tipo de proceso SQL:** `CREATE TABLE auditoria_cita`.
    **Enunciado:** Se debe crear una tabla de auditoría para registrar la trazabilidad de las operaciones sobre citas, ya que el sistema administra atenciones psicológicas y debe conservar evidencia de cambios sobre datos sensibles.
    **Qué hace:** almacena historial de inserciones, actualizaciones y eliminaciones sobre `cita`.
    **Columnas sugeridas:** `id_auditoria`, `tabla_afectada`, `id_cita`, `tipo_operacion`, `fecha_anterior`, `fecha_nueva`, `hora_anterior`, `hora_nueva`, `id_servicio_anterior`, `id_servicio_nuevo`, `id_psicologo_anterior`, `id_psicologo_nuevo`, `usuario_aplica`, `fecha_auditoria`.
    **Tablas/columnas afectadas:** nueva tabla `auditoria_cita`; registra cambios originados desde `cita`.

11. **Crear trigger de auditoría sobre la tabla `cita`.** HECHO
    **Tipo de proceso SQL:** `CREATE OR REPLACE TRIGGER trg_auditoria_cita`.
    **Enunciado:** Se debe implementar un trigger de auditoría para cumplir con la trazabilidad del proceso de atención psicológica. Cada cambio sobre una cita debe dejar constancia del usuario, fecha y tipo de operación.
    **Qué hace:** después de `INSERT`, `UPDATE` o `DELETE` en `cita`, inserta un registro en `auditoria_cita`.
    **Tablas/columnas leídas:** `cita(id_cita, fecha, hora, id_servicio, id_estudiante, id_docente, id_admin, id_psicologo)`.
    **Tablas/columnas afectadas:** `auditoria_cita(id_auditoria, tabla_afectada, id_cita, tipo_operacion, fecha_anterior, fecha_nueva, hora_anterior, hora_nueva, id_servicio_anterior, id_servicio_nuevo, id_psicologo_anterior, id_psicologo_nuevo, usuario_aplica, fecha_auditoria)`.

12. **Crear tabla estadística de atenciones psicológicas.**
    **Tipo de proceso SQL:** `CREATE TABLE estadistica_atenciones`.
    **Enunciado:** Se debe crear una tabla estadística para mantener acumulados de citas por psicólogo, servicio y tipo de paciente. Esta tabla es consistente con el proceso de negocio porque permite medir las atenciones psicológicas realizadas por la DNOP.
    **Qué hace:** almacena totales consolidados para evitar recalcular siempre desde `cita`.
    **Columnas sugeridas:** `id_psicologo`, `id_servicio`, `tipo_paciente`, `cantidad_citas`, `ultima_fecha_atencion`, `usuario_actualiza`, `fecha_actualizacion`.
    **Tablas/columnas afectadas:** nueva tabla `estadistica_atenciones`; consolida datos desde `cita.id_psicologo`, `cita.id_servicio`, `cita.id_estudiante`, `cita.id_docente`, `cita.id_admin`.

13. **Crear trigger para actualizar estadísticas de atenciones.**
    **Tipo de proceso SQL:** `CREATE OR REPLACE TRIGGER trg_estadistica_atenciones`.
    **Enunciado:** Se debe implementar un trigger que mantenga actualizada la estadística de citas cuando se inserte, actualice o elimine una atención. Este proceso garantiza consistencia entre la tabla transaccional `cita` y la tabla derivada `estadistica_atenciones`.
    **Qué hace:** en `INSERT`, incrementa la cantidad de citas según psicólogo, servicio y tipo de paciente; en `UPDATE`, ajusta la combinación anterior y la nueva si cambia psicólogo, servicio o paciente; en `DELETE`, descuenta la cita eliminada.
    **Tablas/columnas leídas:** `cita(id_psicologo, id_servicio, id_estudiante, id_docente, id_admin, fecha)`.
    **Tablas/columnas afectadas:** `estadistica_atenciones(id_psicologo, id_servicio, tipo_paciente, cantidad_citas, ultima_fecha_atencion, usuario_actualiza, fecha_actualizacion)`.

14. **Crear procedimiento para reprogramar citas.**
    **Tipo de proceso SQL:** `CREATE OR REPLACE PROCEDURE sp_reprogramar_cita`.
    **Enunciado:** Se debe implementar un procedimiento para modificar fecha, hora, servicio o psicólogo de una cita existente. Esto representa una operación normal del proceso de atención y debe controlarse por programación almacenada para validar datos antes del `UPDATE`.
    **Qué hace:** actualiza una cita existente después de validar que `id_cita`, `id_servicio` e `id_psicologo` existan.
    **Parámetros requeridos:** `p_id_cita`, `p_nueva_fecha`, `p_nueva_hora`, `p_id_servicio`, `p_id_psicologo`.
    **Tablas/columnas afectadas:** `cita(fecha, hora, id_servicio, id_psicologo)`. También activa indirectamente `auditoria_cita` y `estadistica_atenciones`.

15. **Crear procedimiento para eliminar o anular citas.**
    **Tipo de proceso SQL:** `CREATE OR REPLACE PROCEDURE sp_eliminar_cita` o `sp_anular_cita`.
    **Enunciado:** Se debe implementar un procedimiento para retirar una cita registrada por error o no realizada. Si se mantiene el modelo actual, el proceso será eliminación física; si se agrega un campo de estado, será anulación lógica.
    **Qué hace:** valida que la cita exista y luego elimina o anula el registro.
    **Parámetros requeridos:** `p_id_cita`.
    **Tablas/columnas afectadas:** si es eliminación física: `cita(id_cita)`. Si es anulación lógica: se debe agregar `cita.estado_cita`. También activa indirectamente `auditoria_cita` y `estadistica_atenciones`.

16. **Crear tabla para reportes generados de atenciones psicológicas.**
    **Tipo de proceso SQL:** `CREATE TABLE reporte_atenciones`.
    **Enunciado:** Se debe crear una tabla de reporte si se requiere almacenar formalmente los reportes generados por rango de fecha y psicólogo. Esto es consistente con el objetivo del proyecto de generar y almacenar reportes psicológicos formales.
    **Qué hace:** almacena el resultado de los reportes generados por procedimiento.
    **Columnas sugeridas:** `id_reporte`, `fecha_generacion`, `fecha_inicio`, `fecha_fin`, `id_cita`, `fecha_cita`, `hora`, `id_psicologo`, `nombre_psicologo`, `id_paciente`, `nombre_paciente`, `tipo_paciente`, `nombre_servicio`, `usuario_genera`.
    **Tablas/columnas afectadas:** nueva tabla `reporte_atenciones`; se llena con datos derivados de `cita`, `psicologo`, `servicio`, `estudiante`, `docente`, `administrativo`.

17. **Crear procedimiento con cursor para generar reporte de atenciones por psicólogo.**
    **Tipo de proceso SQL:** `CREATE OR REPLACE PROCEDURE sp_generar_reporte_atenciones`.
    **Enunciado:** Se debe implementar un procedimiento con cursor para cumplir el requisito de cursores, estructuras de control y controles de salida. El cursor debe recorrer las citas de un rango de fechas y consolidar la información de paciente, servicio y psicólogo.
    **Qué hace:** recorre las citas mediante cursor, determina el tipo de paciente, obtiene el nombre del paciente, obtiene el psicólogo y el servicio, e inserta el resultado en `reporte_atenciones` o lo muestra mediante `DBMS_OUTPUT`.
    **Parámetros requeridos:** `p_fecha_inicio`, `p_fecha_fin`, `p_id_psicologo`, `p_total_registros OUT`.
    **Tablas/columnas consultadas:** `cita(id_cita, fecha, hora, id_servicio, id_estudiante, id_docente, id_admin, id_psicologo)`, `psicologo(id_psico, primer_nombre, apellido_paterno)`, `servicio(id_servicio, nombre_servicio)`, `estudiante(id_paciente, primer_nombre, apellido_paterno)`, `docente(id_paciente, primer_nombre, apellido_paterno)`, `administrativo(id_paciente, primer_nombre, apellido_paterno)`.
    **Tablas/columnas afectadas si se almacena:** `reporte_atenciones`.

18. **Crear función para obtener el nombre del paciente de una cita.**
    **Tipo de proceso SQL:** `CREATE OR REPLACE FUNCTION fn_nombre_paciente_cita`.
    **Enunciado:** Se debe implementar una función auxiliar para obtener el nombre del paciente sin duplicar lógica en vistas, reportes y procedimientos. Esta función es necesaria porque el paciente puede estar en `estudiante`, `docente` o `administrativo`.
    **Qué hace:** recibe `p_id_estudiante`, `p_id_docente`, `p_id_admin`; devuelve el nombre completo del paciente correspondiente.
    **Tablas/columnas consultadas:** `estudiante(id_paciente, primer_nombre, apellido_paterno)`, `docente(id_paciente, primer_nombre, apellido_paterno)`, `administrativo(id_paciente, primer_nombre, apellido_paterno)`.
    **Tablas modificadas:** ninguna.

19. **Agregar manejo de excepciones en todos los procedimientos, funciones y triggers.**
    **Tipo de proceso SQL:** bloque `EXCEPTION`.
    **Enunciado:** Cada proceso almacenado debe controlar errores previsibles para cumplir con el lineamiento formal de programación almacenada. No basta con que el proceso ejecute; debe manejar duplicados, claves foráneas inválidas, registros inexistentes y errores generales.
    **Qué hace:** usa excepciones como `DUP_VAL_ON_INDEX`, `NO_DATA_FOUND`, errores de integridad referencial y `WHEN OTHERS`.
    **Tablas/procesos afectados:** todos los procedimientos y triggers sobre `cargo`, `facultad`, `carrera`, `servicio`, `psicologo`, `estudiante`, `docente`, `administrativo`, `Tlf_Estudiante`, `Tlf_Docente`, `Tlf_Admin`, `cita`, `auditoria_cita`, `estadistica_atenciones`, `reporte_atenciones`.

20. **Crear invocaciones de prueba para cada proceso almacenado.**
    **Tipo de proceso SQL:** bloques anónimos `BEGIN ... END; /` y consultas `SELECT`.
    **Enunciado:** Se deben documentar invocaciones para demostrar en sustentación que cada procedimiento, función y trigger funciona. Esto responde directamente al lineamiento de establecer procesos de invocación para la programación almacenada.
    **Qué hace:** ejecuta cargas paramétricas, inserciones de psicólogos, inserciones de estudiantes/docentes/administrativos, creación de citas, reprogramación, eliminación/anulación, generación de reportes y verificación de auditoría/estadística.
    **Tablas/columnas afectadas:** todas las tablas transaccionales y de control del proyecto PSIREG.

21. **Actualizar la documentación del informe por cada proceso implementado.**
    **Tipo de proceso:** documentación técnica del informe.
    **Enunciado:** Cada proceso debe quedar sustentado formalmente en el informe, indicando su objetivo, tipo SQL, relación con el modelo de negocio, parámetros, tablas afectadas, columnas afectadas, reglas de negocio, excepciones e invocación de prueba.
    **Procesos a documentar:** `sp_cargar_parametricas`, `sp_insertar_psicologo`, `sp_insertar_estudiante`, `sp_insertar_docente`, `sp_insertar_administrativo`, `fn_tipo_paciente_cita`, `sp_insertar_cita`, `trg_cita_paciente_unico`, `auditoria_cita`, `trg_auditoria_cita`, `estadistica_atenciones`, `trg_estadistica_atenciones`, `sp_reprogramar_cita`, `sp_eliminar_cita` o `sp_anular_cita`, `reporte_atenciones`, `sp_generar_reporte_atenciones`, `fn_nombre_paciente_cita`.
