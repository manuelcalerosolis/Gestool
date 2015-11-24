#include "hbclass.ch"

#define CRLF                        chr( 13 ) + chr( 10 )

#define __path__                    "C:\Users\Usuario 001\Dropbox\Buzones\0000005"

static nView

//---------------------------------------------------------------------------//

Function StartRecepcion()

   nView             := D():CreateView()

   D():Clientes( nView )
   D():ClientesDirecciones( nView )

   D():Articulos( nView )

   D():ArticulosCodigosBarras( nView )

   D():FacturasClientes( nView )
   D():FacturasClientesLineas( nView )

   D():FacturasProveedores( nView )
   D():FacturasProveedoresLineas( nView )
   D():FacturasProveedoresPagos( nView )

   D():Proveedores( nView )

   D():TiposIva( nView )

   D():FormasPago( nView )

   D():Divisas( nView )

   D():Contadores( nView )

   RecepcionArticulos()

   RecepcionClientes()

   // RecepcionFacturas()

   D():DeleteView( nView )

Return nil

//---------------------------------------------------------------------------//

Function RecepcionArticulos()

   local aFile
   local aFiles
   local hCodebar
   local hArticulo
   local aArticulos

   aFiles               := directory( __path__ + "Articulos*.txt" )

   if empty( aFiles )
      msgWait( "No hay artículos para recibir", "Información", 1 )
   end if

   for each aFile in aFiles

      aArticulos        := hb_deserialize( hb_memoread( __path__ + aFile[1] ) )

      if isArray( aArticulos )

         for each hArticulo in aArticulos
            
            deleteArticulo( hArticulo )  

            appendHashRecord( hArticulo, D():Articulos( nView ), { "PCOSTO", "PVPREC", "LBNF1", "LBNF2", "LBNF3", "LBNF4", "LBNF5", "LBNF6", "BENEF1", "BENEF2", "BENEF3", "BENEF4", "BENEF5", "BENEF6", "NBNFSBR1", "NBNFSBR2", "NBNFSBR3", "NBNFSBR4", "NBNFSBR5", "NBNFSBR6", "PVENTA1", "PVENTA2", "PVENTA3", "PVENTA4", "PVENTA5", "PVENTA6", "PVTAIVA1", "PVTAIVA2", "PVTAIVA3", "PVTAIVA4", "PVTAIVA5", "PVTAIVA6", "PALQ1", "PALQ2", "PALQ3", "PALQ4", "PALQ5", "PALQ6", "PALQIVA1", "PALQIVA2", "PALQIVA3", "PALQIVA4", "PALQIVA5", "PALQIVA6" } )

            if hHasKey( hArticulo, "Codebar" )
               
               for each hCodebar in hGet( hArticulo, "Codebar" )

                  appendHashRecord( hCodebar, D():ArticulosCodigosBarras( nView ) )

               next 

            end if 

            msgWait( "Artículo creado" + D():ArticulosIdText( nView ), "Información", 0.1 )

         next
      
      end if

      ferase( __path__ + aFile[1] ) 

   next 

Return ( nil )

//---------------------------------------------------------------------------//

Function RecepcionClientes()

   local aFile
   local aFiles
   local hDireccion
   local hCliente
   local aClientes

   aFiles               := directory( __path__ + "Clientes*.txt" )

   if empty( aFiles )
      msgWait( "No hay clientes para recibir", "Información", 1 )
   end if

   for each aFile in aFiles

      aClientes        := hb_deserialize( hb_memoread( __path__ + aFile[1] ) )

      if isArray( aClientes )

         for each hCliente in aClientes
            
            deleteCliente( hCliente )  

            appendHashRecord( hCliente, D():Clientes( nView ) )

            if hHasKey( hCliente, "Direcciones" )
               
               for each hDireccion in hGet( hCliente, "Direcciones" )

                  appendHashRecord( hDireccion, D():ClientesDirecciones( nView ) )

               next 

            end if 

            msgWait( "Cliente creado " + D():ClientesId( nView ), "Información", 0.1 )

         next
      
      end if

      ferase( __path__ + aFile[1] ) 

   next 

Return ( nil )

//---------------------------------------------------------------------------//

Function RecepcionFacturas()

   local aFile
   local aFiles
   local hLinea
   local hFactura
   local aFacturas
   local hFacturaProveedor

   aFiles               := directory( __path__ + "FacturasClientes*.txt" )

   if empty( aFiles )
      msgWait( "No hay facturas para recibir", "Información", 1 )
   end if

   for each aFile in aFiles

      aFacturas         := hb_deserialize( hb_memoread( __path__ + aFile[1] ) )

      if isArray( aFacturas )

         for each hFactura in aFacturas

            hFacturaProveedor    := appendFacturaProveedor( hFactura )

            if hHasKey( hFactura, "Lineas" )
               
               for each hLinea in hGet( hFactura, "Lineas" )

                  appendFacturaProveedorLineas( hFacturaProveedor, hLinea )

               next 

            end if 

         next
      
      end if

      GenPgoFacPrv( D():FacturasProveedoresId( nView ), D():FacturasProveedores( nView ), D():FacturasProveedoresLineas( nView ), D():FacturasProveedoresPagos( nView ), D():Proveedores( nView ), D():TiposIva( nView ), D():FormasPago( nView ), D():Divisas( nView ) )

      ChkLqdFacPrv( nil, nView )

      msgWait( "Factura de proveedor creada " + D():FacturasProveedoresIdText( nView ), "Información", 1 )

      // ferase( __path__ + aFile[1] ) 

   next 

Return ( nil )

//---------------------------------------------------------------------------//

Static Function deleteArticulo( hArticulo )

   local cCodigo  := hArticulo[ "CODIGO" ]

   if ( D():Articulos( nView ) )->( dbseek( cCodigo ) )
      if ( D():Articulos( nView ) )->( dbrlock() ) 
         ( D():Articulos( nView ) )->( dbdelete() )
         ( D():Articulos( nView ) )->( dbunLock() )
      end if
   end if

   while ( D():ArticulosCodigosBarras( nView ) )->( dbseek( cCodigo ) ) .and. !( D():ArticulosCodigosBarras( nView ) )->( eof() )
      if ( D():ArticulosCodigosBarras( nView ) )->( dbrlock() ) 
         ( D():ArticulosCodigosBarras( nView ) )->( dbdelete() )
         ( D():ArticulosCodigosBarras( nView ) )->( dbunLock() )
      end if 
   end if

Return ( nil )

//---------------------------------------------------------------------------//

Static Function deleteCliente( hCliente )

   local cCodigo     := hCliente[ "COD" ]

   if ( D():Clientes( nView ) )->( dbseek( cCodigo ) )
      if ( D():Clientes( nView ) )->( dbrlock() ) 
         ( D():Clientes( nView ) )->( dbdelete() )
         ( D():Clientes( nView ) )->( dbunLock() )
      end if
   end if

   while ( D():ClientesDirecciones( nView ) )->( dbseek( cCodigo ) ) .and. !( D():ClientesDirecciones( nView ) )->( eof() )
      if ( D():ClientesDirecciones( nView ) )->( dbrlock() ) 
         ( D():ClientesDirecciones( nView ) )->( dbdelete() )
         ( D():ClientesDirecciones( nView ) )->( dbunLock() )
      end if 
   end if

Return ( nil )

//---------------------------------------------------------------------------//

Static Function appendFacturaProveedor( hFacturaCliente )

   local hFacturaProveedor    := {=>}

   hFacturaProveedor[ "CSERFAC"    ]   := hFacturaCliente[ "CSERIE" ] 
   hFacturaProveedor[ "NNUMFAC"    ]   := nNewDoc( hFacturaCliente[ "CSERIE" ], D():FacturasProveedores( nView ), "NFACPRV", , D():Contadores( nView ) )
   hFacturaProveedor[ "CSUFFAC"    ]   := hFacturaCliente[ "CSUFFAC" ]
   hFacturaProveedor[ "CTURFAC"    ]   := cCurSesion()
   hFacturaProveedor[ "DFECFAC"    ]   := hFacturaCliente[ "DFECFAC" ]
   hFacturaProveedor[ "CCODPRV"    ]   := "0000001"   // C, 12, 0, Código del proveedor en este caso GENESIS
   hFacturaProveedor[ "CCODALM"    ]   := "001"       // C, 16, 0, Código de almacen donde recepciono
   hFacturaProveedor[ "CCODCAJ"    ]   := "001"       // C,  3, 0, Código de mi caja
   hFacturaProveedor[ "CNOMPRV"    ]   := "GENESIS"   // C, 35, 0, Nombre del proveedor
   hFacturaProveedor[ "CDIRPRV"    ]   := "Explanada" // C, 35, 0, Domicilio del proveedor
   hFacturaProveedor[ "CPOBPRV"    ]   := "Población" // C, 25, 0, Población del proveedor
   hFacturaProveedor[ "CPROVPROV"  ]   := "Sevilla"   // C, 20, 0, Provincia del proveedor
   hFacturaProveedor[ "CPOSPRV"    ]   := "41000"     // C,  5, 0, Código postal del proveedor
   hFacturaProveedor[ "CDNIPRV"    ]   := "75541180A" // C, 30, 0, DNI/CIF del proveedor
   hFacturaProveedor[ "LLIQUIDADA" ]   := .f.         // L,  1, 0, Lógico de la liquidación
   hFacturaProveedor[ "LCONTAB"    ]   := .f.         // L,  1, 0, Lógico de la contabilización
   hFacturaProveedor[ "DFECENT"    ]   := hFacturaCliente[ "DFECFAC" ] // D,  8, 0, Fecha de entrada
   hFacturaProveedor[ "CSUPED"     ]   := hFacturaCliente[ "CSERIE" ] + Str( hFacturaCliente[ "NNUMFAC" ] ) + hFacturaCliente[ "CSUFFAC"] //C, 50, 0, Su factura                               ,,                   , ( cDbf ), nil } )
   hFacturaProveedor[ "CCONDENT"   ]   := ""          // C, 20, 0, Condición de entrada
   hFacturaProveedor[ "MCOMENT"    ]   := ""          // M, 10, 0, Comentarios
   hFacturaProveedor[ "CEXPED"     ]   := ""          // C, 20, 0, Expedición                               
   hFacturaProveedor[ "COBSERV"    ]   := ""          // C, 20, 0, Observaciones                            
   hFacturaProveedor[ "CCODPAGO"   ]   := "00"        // C,  2, 0, Código del tipo de pago
   hFacturaProveedor[ "NBULTOS"    ]   := hFacturaCliente[ "NBULTOS" ] // N,  3, 0, Número de bultos
   hFacturaProveedor[ "NPORTES"    ]   := hFacturaCliente[ "NPORTES" ] // N,  6, 0, Valor de los portes
   hFacturaProveedor[ "CNUMALB"    ]   := ""          // C, 12, 0, Número de albaran
   hFacturaProveedor[ "CSUFALB"    ]   := ""          // C,  2, 0, Sufijo de albaran
   hFacturaProveedor[ "LIMPALB"    ]   := .f.         // L,  1, 0, Factura importada desde albaranes        
   hFacturaProveedor[ "CDTOESP"    ]   := hFacturaCliente[ "CDTOESP" ] // C, 50, 0, Descripción de descuento especial
   hFacturaProveedor[ "NDTOESP"    ]   := hFacturaCliente[ "NDTOESP" ] // N,  5, 2, Porcentaje de descuento especial 
   hFacturaProveedor[ "CDPP"       ]   := hFacturaCliente[ "CDPP"    ] // C, 50, 0, Descripción descuento por pronto pago   
   hFacturaProveedor[ "NDPP"       ]   := hFacturaCliente[ "NDPP"    ] // N,  5, 2, Porcentaje de descuento por pronto pago 
   hFacturaProveedor[ "LRECARGO"   ]   := .f.         // L,  1, 0, Lógico para recargo
   hFacturaProveedor[ "NIRPF"      ]   := 0           // N,  4, 1,                                          
   hFacturaProveedor[ "CCODAGE"    ]   := ""          // C,  3, 0, Código del agente                        
   hFacturaProveedor[ "CDIVFAC"    ]   := hFacturaCliente[ "CDIVFAC" ] //C,  3, 0, Código de divisa                         
   hFacturaProveedor[ "NVDVFAC"    ]   := hFacturaCliente[ "NVDVFAC" ]//N, 13, 6, Valor del cambio de la divisa            
   hFacturaProveedor[ "LSNDDOC"    ]   := .f.         // L,  1, 0, Enviar documento por internet            
   hFacturaProveedor[ "CDTOUNO"    ]   := hFacturaCliente[ "CDTOUNO" ] // C, 25, 0, Descripción de primer descuento personalizado
   hFacturaProveedor[ "NDTOUNO"    ]   := hFacturaCliente[ "NDTOUNO" ] // N,  5, 2, Porcentaje de primer descuento personalizado 
   hFacturaProveedor[ "CDTODOS"    ]   := hFacturaCliente[ "CDTODOS" ] // C, 25, 0, Descripción de segundo descuento personalizado
   hFacturaProveedor[ "NDTODOS"    ]   := hFacturaCliente[ "NDTODOS" ] // N,  5, 2, Porcentaje de segundo descuento personalizado
   hFacturaProveedor[ "CCODPRO"    ]   := ""          // C,  9, 0, Código de proyecto en contabilidad
   hFacturaProveedor[ "LRECDOC"    ]   := .f.         // L,  1, 0, Documento recibido por internet   
   hFacturaProveedor[ "LCLOFAC"    ]   := .f.         // L,  1, 0,                                   
   hFacturaProveedor[ "CNUMDOC"    ]   := ""          // C, 50, 0, Número de documento               
   hFacturaProveedor[ "CCODUSR"    ]   := cCurUsr()   // C,  3, 0, Código de usuario,                
   hFacturaProveedor[ "LIMPRIMIDO" ]   := .f.         // L,  1, 0, Lógico de imprimido del documento
   hFacturaProveedor[ "DFECIMP"    ]   := ctod("")    // D,  8, 0, Última fecha de impresión del documento
   hFacturaProveedor[ "CHORIMP"    ]   := ""          // C,  5, 0, Hora de la última impresión del documento
   hFacturaProveedor[ "NTIPRET"    ]   := hFacturaCliente[ "NTIPRET" ]  //N,  1, 0, Tipo de retención ( 1. Base / 2. Base+IVA )
   hFacturaProveedor[ "NPCTRET"    ]   := hFacturaCliente[ "NPCTRET" ]  //N,  6, 2, Porcentaje de retención IRPF
   hFacturaProveedor[ "DFECCHG"    ]   := ctod("")    // D,  8, 0, Fecha de modificación del documento
   hFacturaProveedor[ "CTIMCHG"    ]   := ""          // C,  5, 0, Hora de modificación del documento
   hFacturaProveedor[ "CCODDLG"    ]   := ""          // C,  2, 0, Código delegación
   hFacturaProveedor[ "NREGIVA"    ]   := hFacturaCliente[ "NREGIVA" ] //N,  1, 0, Régimen de  + cImp()
   hFacturaProveedor[ "LFACGAS"    ]   := .f.         // L,  1, 0, Lógico factura de gastos
   hFacturaProveedor[ "MCOMGAS"    ]   := ""          // M, 10, 0, Comentario de gastos
   hFacturaProveedor[ "NNETGAS1"   ]   := 0           // N, 16, 6, Primer importe neto de gastos
   hFacturaProveedor[ "NNETGAS2"   ]   := 0           // N, 16, 6, Segundo importe neto de gastos
   hFacturaProveedor[ "NNETGAS3"   ]   := 0           // N, 16, 6, Tercer importe neto de gastos
   hFacturaProveedor[ "NIVAGAS1"   ]   := 0           // N,  6, 2, Porcentaje primer tipo  + cImp() +  de gastos
   hFacturaProveedor[ "NIVAGAS2"   ]   := 0           // N,  6, 2, Porcentaje segundo tipo  + cImp() +  de gastos
   hFacturaProveedor[ "NIVAGAS3"   ]   := 0           // N,  6, 2, Porcentaje tercer tipo  + cImp() +  de gastos
   hFacturaProveedor[ "NREGAS1"    ]   := 0           // N,  6, 2, Porcentaje primer R.E. de gastos
   hFacturaProveedor[ "NREGAS2"    ]   := 0           // N,  6, 2, Porcentaje segundo R.E. de gastos
   hFacturaProveedor[ "NREGAS3"    ]   := 0           // N,  6, 2, Porcentaje tercer R.E. de gastos
   hFacturaProveedor[ "NTOTNET"    ]   := hFacturaCliente[ "NTOTNET" ] //N, 16, 6, Total neto
   hFacturaProveedor[ "NTOTIVA"    ]   := hFacturaCliente[ "NTOTIVA" ] //N, 16, 6, Total  + cImp()
   hFacturaProveedor[ "NTOTREQ"    ]   := hFacturaCliente[ "NTOTREQ" ] //N, 16, 6, Total req
   hFacturaProveedor[ "NTOTFAC"    ]   := hFacturaCliente[ "NTOTFAC" ] //N, 16, 6, Total factura
   hFacturaProveedor[ "CNFC"       ]   := ""          // C, 20, 0, Código NFC 
   hFacturaProveedor[ "SUBCTA"     ]   := ""          // C, 12, 0, Código subcuenta para gastos enlace contaplus
   hFacturaProveedor[ "NTOTSUP"    ]   := hFacturaCliente[ "NTOTSUP" ] // N, 16, 6, Total gastos suplidos
   hFacturaProveedor[ "CBANCO"     ]   := ""          // C, 50, 0, Nombre del banco del proveedor 
   hFacturaProveedor[ "CPAISIBAN"  ]   := ""          // C,  2, 0, País IBAN de la cuenta bancaria del proveedor 
   hFacturaProveedor[ "CCTRLIBAN"  ]   := ""          // C,  2, 0, Dígito de control IBAN de la cuenta bancaria del proveedor 
   hFacturaProveedor[ "CENTBNC"    ]   := ""          // C,  4, 0, Entidad de la cuenta bancaria del proveedor 
   hFacturaProveedor[ "CSUCBNC"    ]   := ""          // C,  4, 0, Sucursal de la cuenta bancaria del proveedor
   hFacturaProveedor[ "CDIGBNC"    ]   := ""          // C,  2, 0, Dígito de control de la cuenta bancaria del proveedor
   hFacturaProveedor[ "CCTABNC"    ]   := ""          // C, 10, 0, Cuenta bancaria del proveedor
   hFacturaProveedor[ "LRECC"      ]   := hFacturaCliente[ "LRECC" ] //L,  1, 0, Acogida al régimen especial del criterio de caja

   appendHashRecord( hFacturaProveedor, D():FacturasProveedores( nView ) )

Return ( hFacturaProveedor )

//---------------------------------------------------------------------------//

Static Function appendFacturaProveedorLineas( hFacturaProveedor, hLinea )

   local hLineaProveedor   := {=>}

   hLineaProveedor[ "CSERFAC"    ] :=  hFacturaProveedor[ "CSERFAC"    ]   // C,  1, 0, "Serie de factura
   hLineaProveedor[ "NNUMFAC"    ] :=  hFacturaProveedor[ "NNUMFAC"    ]   // N,  9, 0, "Número de factura
   hLineaProveedor[ "CSUFFAC"    ] :=  hFacturaProveedor[ "CSUFFAC"    ]   // C,  2, 0, "Sufijo de factura
   hLineaProveedor[ "CCODPRV"    ] :=  hFacturaProveedor[ "CCODPRV"    ] // C", 12, 0, "Código de proveedor",          "",                   "", "( cDbfCol )", nil } )
   hLineaProveedor[ "CREF"       ] :=  hLinea[ "CREF"     ] // C, 18, 0, "Referencia artículo"         ,"",                    "", "( cDbfCol )", nil } )
   hLineaProveedor[ "CDETALLE"   ] :=  hLinea[ "CDETALLE" ] // C",240, 0, "Detalle de articulo"         ,"",                    "", "( cDbfCol )", nil } )
   hLineaProveedor[ "NPREUNIT"   ] :=  hLinea[ "NPREUNIT" ] // N", 16, 6, "Precio unitario"             ,"cPinDivFac",          "", "( cDbfCol )", nil } )
   hLineaProveedor[ "NDTO"       ] :=  hLinea[ "NDTO"     ] // N",  6, 2, ""                            ,"'@E 99,99'",          "", "( cDbfCol )", nil } )
   hLineaProveedor[ "NIVA"       ] :=  hLinea[ "NIVA"     ] // N",  6, 2, "Porcentaje de " + cImp()     ,"'@E 99,99'",          "", "( cDbfCol )", nil } )
   hLineaProveedor[ "NCANENT"    ] :=  hLinea[ "NCANENT"  ] // N", 16, 6, "Cajas recibidas"             ,"MasUnd()",            "", "( cDbfCol )", nil } )
   hLineaProveedor[ "LCONTROL"   ] :=  hLinea[ "LCONTROL" ] // L",  1, 0, "Control reservado"           ,"",                    "", "( cDbfCol )", nil } )
   hLineaProveedor[ "CUNIDAD"    ] :=  hLinea[ "CUNIDAD"  ] // C",  2, 0, "Unidad de venta"             ,"",                    "", "( cDbfCol )", nil } )
   hLineaProveedor[ "NUNICAJA"   ] :=  hLinea[ "NUNICAJA" ] // N", 16, 6, "Unidades recibidas"          ,"MasUnd()",            "", "( cDbfCol )", nil } )
   hLineaProveedor[ "MLNGDES"    ] :=  hLinea[ "MLNGDES"  ] // M", 10, 0, "Descripción larga de artículo","",                   "", "( cDbfCol )", nil } )
   hLineaProveedor[ "NDTOLIN"    ] :=  hLinea[ "NDTO"     ] // N",  6, 2, "Descuento lineal"            ,"'@E 999,99'",         "", "( cDbfCol )", nil } )
   hLineaProveedor[ "NDTOPRM"    ] :=  hLinea[ "NDTOPRM"  ] // N",  6, 2, "Descuento por promoción"     ,"'@E 999,99'",         "", "( cDbfCol )", nil } )
   hLineaProveedor[ "NIVALIN"    ] :=  hLinea[ "NIVA"     ] // N",  6, 2, ""                            ,"",                    "", "( cDbfCol )", nil } )
   hLineaProveedor[ "LIVALIN"    ] :=  hLinea[ "LIVALIN"  ] // L",  1, 0, ""                            ,"",                    "", "( cDbfCol )", nil } )
   hLineaProveedor[ "CCODPR1"    ] :=  hLinea[ "CCODPR1"  ] // C", 20, 0, "Código de la propiedad 1",     "",                   "", "( cDbfCol )", nil } )
   hLineaProveedor[ "CCODPR2"    ] :=  hLinea[ "CCODPR2"  ] // C", 20, 0, "Código de la propiedad 2",     "",                   "", "( cDbfCol )", nil } )
   hLineaProveedor[ "CVALPR1"    ] :=  hLinea[ "CVALPR1"  ] // C", 40, 0, "Valor de la propiedad 1" ,     "",                   "", "( cDbfCol )", nil } )
   hLineaProveedor[ "CVALPR2"    ] :=  hLinea[ "CVALPR2"  ] // C", 40, 0, "Valor de la propiedad 2" ,     "",                   "", "( cDbfCol )", nil } )
   hLineaProveedor[ "NFACCNV"    ] :=  hLinea[ "NFACCNV"  ] // N", 16, 6, "Factor de conversión de la compra", "",              "", "( cDbfCol )", nil } )
   hLineaProveedor[ "CALMLIN"    ] :=  hLinea[ "CALMLIN"  ] // C", 16, 0, "Código del almacen" ,          "",                   "", "( cDbfCol )", nil } )
   hLineaProveedor[ "NCTLSTK"    ] :=  hLinea[ "NCTLSTK"  ] // N",  1, 0, "Tipo de stock de la línea",    "'9'",                "", "( cDbfCol )", nil } )
   hLineaProveedor[ "LLOTE"      ] :=  hLinea[ "LLOTE"    ] // L",  1, 0, "",                             "",                   "", "( cDbfCol )", nil } )
   hLineaProveedor[ "NLOTE"      ] :=  hLinea[ "NLOTE"    ] // N",  9, 0, "",                             "'999999999'",        "", "( cDbfCol )", nil } )
   hLineaProveedor[ "CLOTE"      ] :=  hLinea[ "CLOTE"    ] // C", 12, 0, "Número de lote",               "",                   "", "( cDbfCol )", nil } )
   hLineaProveedor[ "NNUMLIN"    ] :=  hLinea[ "NNUMLIN"  ] // N",  4, 0, "Número de la línea",           "9999",               "", "( cDbfCol )", nil } )
   hLineaProveedor[ "NUNDKIT"    ] :=  hLinea[ "NUNDKIT"  ] // N", 16, 6, "Unidades del producto kit",    "MasUnd()",           "", "( cDbfCol )", nil } )
   hLineaProveedor[ "LKITART"    ] :=  hLinea[ "LKITART"  ] // L",  1, 0, "Línea con escandallo",         "",                   "", "( cDbfCol )", nil } )
   hLineaProveedor[ "LKITCHL"    ] :=  hLinea[ "LKITCHL"  ] // L",  1, 0, "Línea pertenciente a escandallo", "",                "", "( cDbfCol )", nil } )
   hLineaProveedor[ "LKITPRC"    ] :=  hLinea[ "LKITPRC"  ] // L",  1, 0, "",                             "",                   "", "( cDbfCol )", nil } )
   hLineaProveedor[ "LIMPLIN"    ] :=  hLinea[ "LIMPLIN"  ] // L",  1, 0, "Imprimir linea",               "",                   "", "( cDbfCol )", nil } )
   hLineaProveedor[ "MNUMSER"    ] :=  hLinea[ "MNUMSER"  ] // M", 10, 0, "" ,                            "",                   "", "( cDbfCol )", nil } )
   hLineaProveedor[ "CCODFAM"    ] :=  hLinea[ "CCODFAM"  ] // C", 16, 0, "Código de familia",            "",                   "", "( cDbfCol )", nil } )
   hLineaProveedor[ "CGRPFAM"    ] :=  hLinea[ "CGRPFAM"  ] // C",  3, 0, "Código del grupo de familia",  "",                   "", "( cDbfCol )", nil } )
   hLineaProveedor[ "NREQ"       ] :=  hLinea[ "NREQ"     ] // N", 16, 6, "Recargo de equivalencia",      "",                   "", "( cDbfCol )", nil } )
   hLineaProveedor[ "MOBSLIN"    ] :=  hLinea[ "MOBSLIN"  ] // M", 10, 0, "Observacion de línea",         "",                   "", "( cDbfCol )", nil } )
   hLineaProveedor[ "NPVPREC"    ] :=  hLinea[ "NPVPREC"  ] // N", 16, 6, "Precio de venta recomendado",  "cPinDivFac",         "", "( cDbfCol )", nil } )
   hLineaProveedor[ "NNUMMED"    ] :=  hLinea[ "NNUMMED"  ] // N",  1, 0, "Número de mediciones",         "MasUnd()",           "", "( cDbfCol )", nil } )
   hLineaProveedor[ "NMEDUNO"    ] :=  hLinea[ "NMEDUNO"  ] // N", 16, 6, "Primera unidad de medición",   "MasUnd()",           "", "( cDbfCol )", nil } )
   hLineaProveedor[ "NMEDDOS"    ] :=  hLinea[ "NMEDDOS"  ] // N", 16, 6, "Segunda unidad de medición",   "MasUnd()",           "", "( cDbfCol )", nil } )
   hLineaProveedor[ "NMEDTRE"    ] :=  hLinea[ "NMEDTRE"  ] // N", 16, 6, "Tercera unidad de medición",   "MasUnd()",           "", "( cDbfCol )", nil } )
   hLineaProveedor[ "DFECCAD"    ] :=  hLinea[ "DFECCAD"  ] // D",  8, 0, "Fecha de caducidad",           "",                   "", "( cDbfCol )", nil } )
   hLineaProveedor[ "LGASSUP"    ] :=  hLinea[ "LGASSUP"  ] // L",  1, 0, "Linea de gastos suplidos",     "",                   "", "( cDbfCol )", nil } )
   hLineaProveedor[ "DFECFAC"    ] :=  hLinea[ "DFECHA"   ] // D",  8, 0, "Fecha de la factura",          "",                   "", "( cDbfCol )", nil } )
   hLineaProveedor[ "NBULTOS"    ] :=  hLinea[ "NBULTOS"  ] // N", 16, 6, "Numero de bultos en líneas",   "",                   "", "( cDbfCol )", nil } )
   hLineaProveedor[ "CFORMATO"   ] :=  hLinea[ "CFORMATO" ] // C",100, 0, "Formato de compra",            "",                   "", "( cDbfCol )", nil } )

   appendHashRecord( hLineaProveedor, D():FacturasProveedoresLineas( nView ) )

Return ( nil )

//---------------------------------------------------------------------------//




