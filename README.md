## Estado final del proyecto

El proyecto PSIREG/DNOP fue organizado en scripts separados para la construcción, validación y prueba de la base de datos Oracle.

El flujo recomendado de ejecución es:

1. `01_drop_db.sql`
2. `02_secuencias.sql`
3. `03_tablas.sql`
4. `08_funciones.sql`
5. `05_procedimientos.sql`
6. `06_triggers.sql`
7. `04_vistas.sql`
8. `09_pruebas.sql`

La carga de datos base y las pruebas funcionales se consolidaron en `09_pruebas.sql`, utilizando procedimientos y secuencias para evitar inconsistencias con identificadores manuales.

`07_inserts.sql` se conserva únicamente como referencia documental y no ejecuta DML, ya que la carga de prueba se realiza desde `09_pruebas.sql`.

El sistema incluye validaciones mediante procedimientos, funciones, triggers, auditoría de citas, estadísticas de atenciones, vistas operativas y manejo de eliminación lógica mediante el estado de la cita.
