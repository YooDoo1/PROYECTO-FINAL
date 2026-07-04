/* ============================================================================
   07_INSERTS.SQL
   ============================================================================

   Este archivo queda sin DML intencionalmente.

   La carga de datos base y las pruebas funcionales fueron consolidadas en
   09_pruebas.sql para mantener un flujo unico de construccion y validacion.

   Motivo:
   - Evitar IDs manuales que choquen con las secuencias.
   - Evitar duplicidad entre carga base y pruebas.
   - Mantener los datos de vistas, reportes y triggers dentro del mismo script
     de verificacion.

   Orden recomendado:
   01_drop_db.sql
   02_secuencias.sql
   03_tablas.sql
   08_funciones.sql
   05_procedimientos.sql
   06_triggers.sql
   04_vistas.sql
   09_pruebas.sql
   ============================================================================ */
