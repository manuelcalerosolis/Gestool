USE `gestool`;

--  Datos de la tabla agentes
INSERT INTO `agentes` VALUES 
(1,'1f331a0b-cdc5-4f27-bf0d-1a445bfae0a5','b0c1c623-8b0f-433c-82f7-e1113ee40906','fe39f874-4ddb-11e8-88e4-70106fc111a4','000','Agente de pruebas','75848541S',5.00),
(2,'7c2531d3-64c9-4189-a94a-b18761a01a7b','b0c1c623-8b0f-433c-82f7-e1113ee40906','fe39f874-4ddb-11e8-88e4-70106fc111a4','001','Agente 2','75845485H',0.00);

--  Fin de datos de la tabla agentes

--  Datos de la tabla ajustables
INSERT INTO `ajustables` VALUES 
(3,'86ca6383-cacc-4f2a-a0d2-12e5f4dc9849','fe3a18d1-4ddb-11e8-88e4-70106fc111a4','SERVIDOR','usuarios','97fa7540-2078-11e8-90fc-70106fc111a4'),
(4,'5ed373be-8799-43b9-bb17-6540b72ab4d7','97fabb17-2078-11e8-90fc-70106fc111a4','0017','usuarios','97fa7540-2078-11e8-90fc-70106fc111a4'),
(51,'a9dffdc8-cb1d-4e24-9ed9-0348ec93b1ab','fe3a18d1-4ddb-11e8-88e4-70106fc111a4','SERVIDOR','usuarios','e198e82b-67c9-4381-9a19-56ce5565c088'),
(52,'4f6714ce-d341-49be-b675-88c0df4872c0','97fabb17-2078-11e8-90fc-70106fc111a4','0017','usuarios','e198e82b-67c9-4381-9a19-56ce5565c088'),
(118,'9532f72f-64a4-4db4-9977-98c3911888bd','fe3a18d1-4ddb-11e8-88e4-70106fc111a4','SERVIDOR','usuarios','b8e0f572-c9ff-4c4a-aa1e-c110309daecf'),
(128,'4eef14ee-3fd8-4b2f-be3c-f8cfd1131614','97fabb17-2078-11e8-90fc-70106fc111a4','0017','usuarios','b8e0f572-c9ff-4c4a-aa1e-c110309daecf'),
(129,'8f68eac2-b4ce-45ae-b8f9-46aa0c1e7972','fe3a18d1-4ddb-11e8-88e4-70106fc111a4','DARIO','usuarios','fe39f874-4ddb-11e8-88e4-70106fc111a4'),
(130,'d9df7ef9-2bd5-4372-a327-a8540a41b99d','97fabb17-2078-11e8-90fc-70106fc111a4','0017','usuarios','fe39f874-4ddb-11e8-88e4-70106fc111a4'),
(955,'ee057602-e4f4-4778-b171-a2c323a6efb6','97fabb17-2078-11e8-90fc-70106fc111a4','0017','usuarios','ca63e439-303c-477c-9846-914c756240f3'),
(1002,'370a64ea-f664-4725-9946-09aeb20b022b','97fabdd1-2078-11e8-90fc-70106fc111a4','1','roles','fe39c593-4ddb-11e8-88e4-70106fc111a4'),
(1003,'3a543f9d-5c2e-478d-a7b1-8b257041f1ce','97fabe51-2078-11e8-90fc-70106fc111a4','1','roles','fe39c593-4ddb-11e8-88e4-70106fc111a4'),
(1004,'1648bd4f-4fa7-490c-9ae0-4c6b1009d572','97fabef7-2078-11e8-90fc-70106fc111a4','1','roles','fe39c593-4ddb-11e8-88e4-70106fc111a4'),
(1005,'fa08b903-ab36-490d-ba68-82bb15bbe017','97fabf76-2078-11e8-90fc-70106fc111a4','1','roles','fe39c593-4ddb-11e8-88e4-70106fc111a4'),
(1006,'5a3fed28-e7c6-478a-80e5-48aabf9cceb1','97fabffa-2078-11e8-90fc-70106fc111a4','1','roles','fe39c593-4ddb-11e8-88e4-70106fc111a4'),
(1007,'ee828cdb-e476-4410-8b58-34ef8f509d20','fe3a3dee-4ddb-11e8-88e4-70106fc111a4','0','roles','fe39c593-4ddb-11e8-88e4-70106fc111a4'),
(1008,'eebe73f2-1f6f-492f-8f8d-9de4d4c624a0','fe3a3eff-4ddb-11e8-88e4-70106fc111a4','1','roles','fe39c593-4ddb-11e8-88e4-70106fc111a4'),
(1009,'fecd716e-a4ae-4336-88e3-daeabd117e5c','fe3a3f7a-4ddb-11e8-88e4-70106fc111a4','1','roles','fe39c593-4ddb-11e8-88e4-70106fc111a4'),
(1010,'ca4d4240-272b-486b-8a62-397550bfdd86','fe3a3ff4-4ddb-11e8-88e4-70106fc111a4','1','roles','fe39c593-4ddb-11e8-88e4-70106fc111a4'),
(1011,'326742a8-548a-4b56-ac4d-0e2a16913b73','fe3a406e-4ddb-11e8-88e4-70106fc111a4','1','roles','fe39c593-4ddb-11e8-88e4-70106fc111a4'),
(1144,'c6bb5c79-abc5-40f4-810d-c403765c3206','fe3a18d1-4ddb-11e8-88e4-70106fc111a4','DARIO','usuarios','76090317-3692-4335-8118-96b2df6ebb30'),
(1145,'07c95266-bc22-4dfa-9edb-becc495530e5','97fabb17-2078-11e8-90fc-70106fc111a4','0017','usuarios','76090317-3692-4335-8118-96b2df6ebb30'),
(1290,'d350c370-2fb6-4e1a-90ef-8d9484f302b5','fe3a3e6d-4ddb-11e8-88e4-70106fc111a4','0','empresas','b0c1c623-8b0f-433c-82f7-e1113ee40906'),
(1319,'2511e334-ed98-476a-ab82-040b69547865','3cb80d90-6005-11e8-adfb-50465d95c8cc','2a6f4357-fec1-43bf-8746-d68dc22092af','empresas','b0c1c623-8b0f-433c-82f7-e1113ee40906'),
(1429,'7aa8094d-b580-43d8-bda5-0a2646adaf8b','ba024af7-2200-11e8-90fc-70106fc111a4','0017','usuarios','97fa7540-2078-11e8-90fc-70106fc111a4'),
(1430,'a76ca14e-61e6-468d-bbc7-fbcff446c2ae','ba024ca5-2200-11e8-90fc-70106fc111a4','','usuarios','97fa7540-2078-11e8-90fc-70106fc111a4'),
(1431,'24fd093f-b65c-4bda-a524-5ddeb7894ee2','fe3a17a1-4ddb-11e8-88e4-70106fc111a4','','usuarios','97fa7540-2078-11e8-90fc-70106fc111a4'),
(1432,'c8b01e3e-8e23-4022-859d-50ed9af24147','fe3a182f-4ddb-11e8-88e4-70106fc111a4','e3f41897-b80c-4960-9a81-c6f107301de3','usuarios','97fa7540-2078-11e8-90fc-70106fc111a4');

--  Fin de datos de la tabla ajustables

--  Datos de la tabla ajustes
INSERT INTO `ajustes` VALUES 
(1,'97fabb17-2078-11e8-90fc-70106fc111a4','empresa_en_uso',1,'alphanumeric',,),
(2,'97fabca2-2078-11e8-90fc-70106fc111a4','caja_en_uso',1,'alphanumeric',,),
(3,'97fabd5c-2078-11e8-90fc-70106fc111a4','almacen_en_uso',1,'alphanumeric',,),
(4,'97fabdd1-2078-11e8-90fc-70106fc111a4','mostrar_rentabilidad',1,'boolean',,),
(5,'97fabe51-2078-11e8-90fc-70106fc111a4','cambiar_precios',1,'boolean',,),
(6,'97fabef7-2078-11e8-90fc-70106fc111a4','ver_precios_costo',1,'boolean',,),
(7,'97fabf76-2078-11e8-90fc-70106fc111a4','confirmacion_eliminacion',1,'boolean',,),
(8,'97fabffa-2078-11e8-90fc-70106fc111a4','fitrar_ventas_por_usuario',1,'boolean',,),
(17,'ba024af7-2200-11e8-90fc-70106fc111a4','empresa_exclusiva',1,'alphanumeric',,),
(18,'ba024ca5-2200-11e8-90fc-70106fc111a4','caja_exclusiva',1,'alphanumeric',,),
(42,'fe3a17a1-4ddb-11e8-88e4-70106fc111a4','almacen_exclusivo',1,'alphanumeric',,),
(43,'fe3a182f-4ddb-11e8-88e4-70106fc111a4','delegacion_exclusiva',1,'alphanumeric',,),
(44,'fe3a18d1-4ddb-11e8-88e4-70106fc111a4','pc_en_uso',1,'alphanumeric',,),
(45,'fe3a3dee-4ddb-11e8-88e4-70106fc111a4','abrir_cajon_portamonedas',1,'boolean',,),
(46,'fe3a3e6d-4ddb-11e8-88e4-70106fc111a4','seleccionar_usuarios',1,'boolean',,),
(47,'fe3a3eff-4ddb-11e8-88e4-70106fc111a4','albaran_entregado',1,'boolean',,),
(48,'fe3a3f7a-4ddb-11e8-88e4-70106fc111a4','asistente_generar_facturas',1,'boolean',,),
(49,'fe3a3ff4-4ddb-11e8-88e4-70106fc111a4','cambiar_estado',1,'boolean',,),
(50,'fe3a406e-4ddb-11e8-88e4-70106fc111a4','cambiar_campos',1,'boolean',,),
(119,'3cb80d90-6005-11e8-adfb-50465d95c8cc','delegacion_defecto',1,'alphanumeric',,);

--  Fin de datos de la tabla ajustes

--  Datos de la tabla almacenes
INSERT INTO `almacenes` VALUES 
(1,'66e71516-2883-4a21-b7ae-ff11258a5592','b0c1c623-8b0f-433c-82f7-e1113ee40906','fe39f874-4ddb-11e8-88e4-70106fc111a4','1d0ce993-5f9a-4e6f-801f-df22647cf42c','651','165'),
(2,'45f12a5d-3d98-48e7-a5cd-aabdddeafb16','b0c1c623-8b0f-433c-82f7-e1113ee40906','fe39f874-4ddb-11e8-88e4-70106fc111a4','1d0ce993-5f9a-4e6f-801f-df22647cf42c','213','32132321132'),
(3,'1d0ce993-5f9a-4e6f-801f-df22647cf42c','b0c1c623-8b0f-433c-82f7-e1113ee40906','fe39f874-4ddb-11e8-88e4-70106fc111a4','50202a46-bdb2-4bbd-b7aa-acc7076f3f13','565','1651651'),
(4,'50202a46-bdb2-4bbd-b7aa-acc7076f3f13','b0c1c623-8b0f-433c-82f7-e1113ee40906','fe39f874-4ddb-11e8-88e4-70106fc111a4','','115','11111');

--  Fin de datos de la tabla almacenes

--  Datos de la tabla articulos
INSERT INTO `articulos` VALUES 

--  Fin de datos de la tabla articulos

--  Datos de la tabla articulos_categoria
INSERT INTO `articulos_categoria` VALUES 

--  Fin de datos de la tabla articulos_categoria

--  Datos de la tabla articulos_categorias
INSERT INTO `articulos_categorias` VALUES 

--  Fin de datos de la tabla articulos_categorias

--  Datos de la tabla articulos_envasado
INSERT INTO `articulos_envasado` VALUES 

--  Fin de datos de la tabla articulos_envasado

--  Datos de la tabla articulos_fabricantes
INSERT INTO `articulos_fabricantes` VALUES 
(1,'87ea6c94-fa93-43fe-be05-471b13f744cd','b0c1c623-8b0f-433c-82f7-e1113ee40906','fe39f874-4ddb-11e8-88e4-70106fc111a4','222','32232','','2018-05-11 08:53:12','2018-05-11 08:57:50');

--  Fin de datos de la tabla articulos_fabricantes

--  Datos de la tabla articulos_familia
INSERT INTO `articulos_familia` VALUES 

--  Fin de datos de la tabla articulos_familia

--  Datos de la tabla articulos_familias
INSERT INTO `articulos_familias` VALUES 

--  Fin de datos de la tabla articulos_familias

--  Datos de la tabla articulos_familias_comentarios
INSERT INTO `articulos_familias_comentarios` VALUES 

--  Fin de datos de la tabla articulos_familias_comentarios

--  Datos de la tabla articulos_familias_comentarios_lineas
INSERT INTO `articulos_familias_comentarios_lineas` VALUES 

--  Fin de datos de la tabla articulos_familias_comentarios_lineas

--  Datos de la tabla articulos_precios
INSERT INTO `articulos_precios` VALUES 

--  Fin de datos de la tabla articulos_precios

--  Datos de la tabla articulos_propiedades
INSERT INTO `articulos_propiedades` VALUES 

--  Fin de datos de la tabla articulos_propiedades

--  Datos de la tabla articulos_propiedades_lineas
INSERT INTO `articulos_propiedades_lineas` VALUES 

--  Fin de datos de la tabla articulos_propiedades_lineas

--  Datos de la tabla articulos_tarifas
INSERT INTO `articulos_tarifas` VALUES 
