/* ============================================================================
   4. INSERCIONES DE DATOS
   ============================================================================ */

/* ---------------------------------------------------------------------------
   INSERCIÓN: CARGO
--------------------------------------------------------------------------- */
INSERT INTO Cargo VALUES (1, 'Psicólogo Clínico');
INSERT INTO Cargo VALUES (2, 'Director');


/* ---------------------------------------------------------------------------
   INSERCIÓN: FACULTAD
--------------------------------------------------------------------------- */
INSERT INTO Facultad VALUES (1, 'Ingeniería de Sistemas Computacionales');
INSERT INTO Facultad VALUES (2, 'Ingeniería Civil');
INSERT INTO Facultad VALUES (3, 'Ingeniería Eléctrica');


/* ---------------------------------------------------------------------------
   INSERCIÓN: CARRERA
--------------------------------------------------------------------------- */
INSERT INTO Carrera VALUES (1, 'Lic. Desarrollo Software', 1);
INSERT INTO Carrera VALUES (2, 'Ing. Civil', 2);
INSERT INTO Carrera VALUES (3, 'Ing. Eléctrica', 3);


/* ---------------------------------------------------------------------------
   INSERCIÓN: PSICOLOGO
--------------------------------------------------------------------------- */
INSERT INTO Psicologo VALUES (
    1,
    'Ana',
    'María',
    'Gómez',
    'Pérez',
    '8-123-456',
    'F',
    'ana.gomez@utp.ac.pa',
    66778899,
    'Casa 15',
    'Calle Primera',
    'Bethania',
    1
);

INSERT INTO Psicologo VALUES (
    2,
    'Carlos',
    NULL,
    'Nuñez',
    'Sánchez',
    '8-456-789',
    'M',
    'carlos.nunez@utp.ac.pa',
    61234567,
    'Casa 20',
    'Calle Segunda',
    'Juan Díaz',
    2
);


/* ---------------------------------------------------------------------------
   INSERCIÓN: TIPO DE TELÉFONO DE ESTUDIANTE
--------------------------------------------------------------------------- */
INSERT INTO TipoTlf_Est VALUES (1, 'Personal');
INSERT INTO TipoTlf_Est VALUES (2, 'Residencial');


/* ---------------------------------------------------------------------------
   INSERCIÓN: TIPO DE TELÉFONO DE DOCENTE
--------------------------------------------------------------------------- */
INSERT INTO TipoTlf_Docente VALUES (1, 'Personal');
INSERT INTO TipoTlf_Docente VALUES (2, 'Residencial');


/* ---------------------------------------------------------------------------
   INSERCIÓN: TIPO DE TELÉFONO DE ADMINISTRATIVO
--------------------------------------------------------------------------- */
INSERT INTO TipoTlf_Admin VALUES (1, 'Personal');
INSERT INTO TipoTlf_Admin VALUES (2, 'Residencial');


/* ---------------------------------------------------------------------------
   INSERCIÓN: ESTUDIANTE
--------------------------------------------------------------------------- */
INSERT INTO Estudiante VALUES (
    1001,
    'Luis',
    'Enrique',
    'Martínez',
    'García',
    '8-987-654',
    'M',
    'luis.martinez@utp.ac.pa',
    'Casa 8',
    'Calle Central',
    'San Francisco',
    1
);

INSERT INTO Estudiante VALUES (
    1002,
    'María',
    'Elena',
    'Hernández',
    'López',
    '8-741-852',
    'F',
    'maria.hernandez@utp.ac.pa',
    'Casa 22',
    'Calle Norte',
    'Bethania',
    2
);


/* ---------------------------------------------------------------------------
   INSERCIÓN: DOCENTE
--------------------------------------------------------------------------- */
INSERT INTO Docente VALUES (
    2001,
    'Pedro',
    'José',
    'Castillo',
    'Morales',
    '8-852-963',
    'M',
    'pedro.castillo@utp.ac.pa',
    67894512,
    'Casa 30',
    'Calle Sur',
    'Parque Lefevre',
    1
);

INSERT INTO Docente VALUES (
    2002,
    'Laura',
    NULL,
    'Fernández',
    'Ruiz',
    '8-951-357',
    'F',
    'laura.fernandez@utp.ac.pa',
    62345678,
    'Casa 12',
    'Calle Este',
    'Bethania',
    2
);


/* ---------------------------------------------------------------------------
   INSERCIÓN: ADMINISTRATIVO
--------------------------------------------------------------------------- */
INSERT INTO Administrativo VALUES (
    3001,
    'José',
    'Antonio',
    'Rivera',
    'González',
    '8-321-654',
    'M',
    'jose.rivera@utp.ac.pa',
    69988776,
    'Casa 40',
    'Calle Oeste',
    'Juan Díaz',
    'Recursos Humanos'
);

INSERT INTO Administrativo VALUES (
    3002,
    'Carmen',
    NULL,
    'Díaz',
    'Pérez',
    '8-741-963',
    'F',
    'carmen.diaz@utp.ac.pa',
    67778855,
    'Casa 18',
    'Calle Quinta',
    'Bethania',
    'Finanzas'
);


/* ---------------------------------------------------------------------------
   INSERCIÓN: TELÉFONOS DE ESTUDIANTE
--------------------------------------------------------------------------- */
INSERT INTO Tlf_Estudiante VALUES (1001, 1, 64567890);
INSERT INTO Tlf_Estudiante VALUES (1001, 2, 2345678);
INSERT INTO Tlf_Estudiante VALUES (1002, 1, 69874563);
INSERT INTO Tlf_Estudiante VALUES (1002, 2, 2233445);


/* ---------------------------------------------------------------------------
   INSERCIÓN: TELÉFONOS DE DOCENTE
--------------------------------------------------------------------------- */
INSERT INTO Tlf_Docente VALUES (2001, 1, 68974521);
INSERT INTO Tlf_Docente VALUES (2001, 2, 2456789);
INSERT INTO Tlf_Docente VALUES (2002, 1, 67894563);
INSERT INTO Tlf_Docente VALUES (2002, 2, 2567890);


/* ---------------------------------------------------------------------------
   INSERCIÓN: TELÉFONOS DE ADMINISTRATIVO
--------------------------------------------------------------------------- */
INSERT INTO Tlf_Admin VALUES (3001, 1, 61112233);
INSERT INTO Tlf_Admin VALUES (3001, 2, 2678901);
INSERT INTO Tlf_Admin VALUES (3002, 1, 62223344);
INSERT INTO Tlf_Admin VALUES (3002, 2, 2789012);


/* ---------------------------------------------------------------------------
   INSERCIÓN: SERVICIO
--------------------------------------------------------------------------- */
INSERT INTO Servicio VALUES (1, 'Orientación Psicológica');
INSERT INTO Servicio VALUES (2, 'Terapia Individual');
INSERT INTO Servicio VALUES (3, 'Seguimiento Académico');


/* ---------------------------------------------------------------------------
   INSERCIÓN: CITAS
   Nota:
   El trigger trg_cita_paciente_unico valida que solo uno de estos campos
   tenga valor por cada cita:
     - id_estudiante
     - id_docente
     - id_admin
--------------------------------------------------------------------------- */
INSERT INTO Cita VALUES (
    1,
    TO_DATE('15/06/2026', 'DD/MM/YYYY'),
    '08:00 AM',
    1,
    1001,
    NULL,
    NULL,
    1
);

INSERT INTO Cita VALUES (
    2,
    TO_DATE('16/06/2026', 'DD/MM/YYYY'),
    '10:30 AM',
    2,
    NULL,
    2001,
    NULL,
    2
);

INSERT INTO Cita VALUES (
    3,
    TO_DATE('17/06/2026', 'DD/MM/YYYY'),
    '02:00 PM',
    3,
    NULL,
    NULL,
    3001,
    1
);

COMMIT;
