#include "FiveWin.Ch"
#include "report.ch"
#include "MesDbf.ch"
#include "Factu.ch" 
#include "Folder.ch"

STATIC oReport                   //para imprimir los ficheros de texto

CLASS TMovilges

   DATA dbfAgente
   DATA dbfClient
   DATA dbfFam
   DATA dbfOferta
   DATA dbfTIva
   DATA dbfFacCliP
   DATA dbfRuta
   DATA dbfDiv
   DATA dbfArticulo
   DATA dbfAlbCliT
   DATA dbfAlbCliL
   DATA dbfPedCliT
   DATA dbfPedCliL
   DATA dbfFacCliT
   DATA dbfFacCliL
   DATA dbfCliAtp
   DATA dbfAntCliT
   DATA dbfFPago

   DATA nRead
   DATA nDecimales
   DATA cCodEmp

   DATA nLevel
   DATA oDlg
   DATA oFld
   DATA oBrwAgente
   DATA bmpSelect
   DATA bmpUnSelect
   DATA cDirectorio
   DATA oDirectorio
   DATA lImportarAlbaran
   DATA lImportarPedido
   DATA lImportarFactura
   DATA lImportarPago
   DATA lExportarCliente
   DATA lExportarOferta
   DATA lExportarFamilia
   DATA lExportarArticulo
   DATA lExportarRuta
   DATA lExportarCobro
   DATA lExportarComentario
   DATA lExportarAtipica
   DATA oImageList
   DATA oTree
   DATA oSubItem
   DATA oSubItem2
   DATA oSubItem3
   DATA oSubItemError
   DATA oSubItemResultado
   DATA fLog
   DATA lLog
   DATA oBotonAceptar
   DATA oBotonImprimir
   DATA nMedidor
   DATA oMedidor
   DATA cLog              //guarda el nombre del fichero de log

   Method New()

   Method Destroy()

   Method Activate()

   Method SelAllAgente( lRefrescar, lSel )

   Method SelAgente( lSel )

   Method OpenFiles()

   Method CloseFiles()

   Method MovilgesProcesar()

   Method MovilgesSalir()

   Method MuestraDialogo()

   Method MovilGesExportarClientes( cCodAgente )

   Method MovilgesExportarArticulo( cCodAgente )

   Method MovilGesExportarFamilia( cCodAgente )

   Method MovilGesExportarOferta( cCodAgente )

   Method MovilGesExportarPendientesCobro( cCodAgente )

   Method MovilGesExportarRuta( cCodAgente )

   Method MovilGesExportarMsgCli( cCodAgente )

   Method MovilgesImportarPedido( cCodAgente )

   Method MovilgesExportarAtipicas( cCodAgente )

   Method movilgesImportarAlbaran( cCodAgente )

   Method movilgesImportarFactura( cCodAgente )

   Method MovilgesImportarPago( cCodAgente )

   Method LogEscribir( cText )

   Method SetTexto( cTexto, nLevel )

   Method ExportarFPagos()

   Method CargarPreferencias()

   Method GuardarPreferencias()

ENDCLASS

//---------------------------------------------------------------------------//
//
//  Metodo constructor
//

Method New( oMenuItem, oWnd )

   ::bmpSelect          := LoadBitmap( GetResources(), "BMPPAGADO1" )
   ::bmpUnSelect        := LoadBitmap( GetResources(), "BMPPAGADO3" )
   ::lImportarAlbaran   := .f.
   ::lImportarPedido    := .f.
   ::lImportarFactura   := .f.
   ::lImportarPago      := .f.
   ::lExportarCliente   := .f.
   ::lExportarOferta    := .f.
   ::lExportarFamilia   := .f.
   ::lExportarArticulo  := .f.
   ::lExportarRuta      := .f.
   ::lExportarCobro     := .f.
   ::lExportarComentario:= .f.
   ::lExportarAtipica   := .f.
   ::oImageList         := TImageList():New()
   ::oImageList:AddMasked( TBitmap():Define( "gc_folder_open_16" ), Rgb( 255, 0, 255 ) )
   ::oImageList:AddMasked( TBitmap():Define( "gc_folder_open_16" ), Rgb( 255, 0, 255 ) )
   ::cCodEmp            := cCodEmp()
   ::nMedidor           := 0

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   ::lLog                  := .t.

   Begin Sequence

      ::cLog               := cGetNewFileName( cPatLog() + "MGES" + Dtos( Date() ) + StrTran( Time(), ":", "" ) ) + ".Txt"
      ::fLog               := fCreate( ::cLog )

      if Empty( ::fLog )

         ::fLog            := fOpen( ::cLog, 1 )

      end if

   Recover

      ::lLog               := .f.

   End Sequence

   //::nLevel          := nLevelUsr( oMenuItem )

Return ( Self )

//---------------------------------------------------------------------------//
//
//  Metodo para activar el cuadro de dialogo
//

Method Activate()

   if nAnd( ::nLevel, 1 ) != 0

      msgStop( "Acceso no permitido." )

   elseif nUsrInUse() > 1

      msgStop( "Hay más de un usuario conectado a la aplicación", "Atención" )

   elseif !lEsNumerico( ::cCodEmp )

      msgStop( "El código de su empresa no es válido. Debe ser un numérico.", "Atención" )

   elseif ::OpenFiles()

      ::MuestraDialogo()

   else

      // ha fallado la apertura
      ::CloseFiles()
      ::Destroy()

   end if

Return ( Self )

//-----------------------------------------------------------------------------//
//
//  Metodo destructor
//

Method Destroy()

   DeleteObject( ::bmpSelect   )
   DeleteObject( ::bmpUnSelect )
   ::oImageList:End()
   ::oTree:Destroy()
   fClose( ::fLog )

Return ( Self )

//-----------------------------------------------------------------------------//
//
//  Metodo para abrir todas las bases de datos
//


Method OpenFiles()

   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   local lOpen    := .T.

   BEGIN SEQUENCE

      DATABASE NEW ::dbfAgente   PATH ( cPatEmp() ) FILE "Agentes.Dbf"  VIA ( cDriver() ) SHARED INDEX "Agentes.Cdx"

      DATABASE NEW ::dbfAntCliT  PATH ( cPatEmp() ) FILE "AntCliT.DBF"  VIA ( cDriver() ) SHARED INDEX "AntCliT.CDX"

      DATABASE NEW ::dbfAlbCliL  PATH ( cPatEmp() ) FILE "ALBCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "ALBCLIL.Cdx"

      DATABASE NEW ::dbfAlbCliT  PATH ( cPatEmp() ) FILE "ALBCLIT.DBF"  VIA ( cDriver() ) SHARED INDEX "ALBCLIT.Cdx"

      DATABASE NEW ::dbfArticulo PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.Cdx"

      DATABASE NEW ::dbfCliAtp   PATH ( cPatCli() ) FILE "CLIATP.DBF"   VIA ( cDriver() ) SHARED INDEX "CLIATP.Cdx"

      DATABASE NEW ::dbfClient   PATH ( cPatCli() ) FILE "CLIENT.Dbf"   VIA ( cDriver() ) SHARED INDEX "CLIENT.Cdx"

      DATABASE NEW ::dbfDiv      PATH ( cPatDat() ) FILE "DIVISAS.Dbf"  VIA ( cDriver() ) SHARED INDEX "DIVISAS.Cdx"

      DATABASE NEW ::dbfFacCliL  PATH ( cPatEmp() ) FILE "FACCLIL.Dbf"  VIA ( cDriver() ) SHARED INDEX "FACCLIL.Cdx"

      DATABASE NEW ::dbfFacCliP  PATH ( cPatEmp() ) FILE "FACCLIP.Dbf"  VIA ( cDriver() ) SHARED INDEX "FACCLIP.Cdx"

      DATABASE NEW ::dbfFacCliT  PATH ( cPatEmp() ) FILE "FACCLIT.Dbf"  VIA ( cDriver() ) SHARED INDEX "FACCLIT.Cdx"

      DATABASE NEW ::dbfFam      PATH ( cPatArt() ) FILE "FAMILIAS.Dbf" VIA ( cDriver() ) SHARED INDEX "FAMILIAS.Cdx"

      DATABASE NEW ::dbfOferta   PATH ( cPatArt() ) FILE "OFERTA.Dbf"   VIA ( cDriver() ) SHARED INDEX "OFERTA.Cdx"

      DATABASE NEW ::dbfPedCliL  PATH ( cPatEmp() ) FILE "PEDCLIL.Dbf"  VIA ( cDriver() ) SHARED INDEX "PEDCLIL.Cdx"

      DATABASE NEW ::dbfPedCliT  PATH ( cPatEmp() ) FILE "PEDCLIT.Dbf"  VIA ( cDriver() ) SHARED INDEX "PEDCLIT.Cdx"

      DATABASE NEW ::dbfRuta     PATH ( cPatCli() ) FILE "RUTA.Dbf"     VIA ( cDriver() ) SHARED INDEX "RUTA.Cdx"

      DATABASE NEW ::dbfTIva     PATH ( cPatDat() ) FILE "TIVA.Dbf"     VIA ( cDriver() ) SHARED INDEX "TIVA.Cdx"

      DATABASE NEW ::dbfFPago    PATH ( cPatEmp() ) FILE "FPAGO.Dbf"    VIA ( cDriver() ) SHARED INDEX "FPAGO.Cdx"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos.","Atención" )
      lOpen       := .F.

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lOpen )

//---------------------------------------------------------------------------//
//
// Seleccionar/Deseleccionar todos los agentes
//

Method SelAllAgente( lRefrescar, lSel )

   ::dbfAgente:GetStatus()

   ::dbfAgente:GoTop()

   while !::dbfAgente:eof()

      // impedir la seleccion de agentes con codigos no numericos

      if ( lEsNumerico( ::dbfAgente:cCodAge ) .and. lSel ) .or. !lSel

         ::dbfAgente:Load()
         ::dbfAgente:lSelAge := lSel
         ::dbfAgente:Save()

      end if

      ::dbfAgente:Skip()

   end while

   ::dbfAgente:SetStatus()

   if lRefrescar
      ::oBrwAgente:Refresh()
   end if

return ( Self )

//--------------------------------------------------------------------------//
//
// Cerrar ficheros
//

Method CloseFiles()

   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   local lOpen    := .T.

   BEGIN SEQUENCE

      ::dbfAgente:End()

      ::dbfAlbCliT:End()

      ::dbfAlbCliL:End()

      ::dbfAntCliT:End()

      ::dbfArticulo:End()

      ::dbfCliAtp:End()

      ::dbfClient:End()

      ::dbfDiv:End()

      ::dbfFacCliT:End()

      ::dbfFacCliL:End()

      ::dbfFacCliP:End()

      ::dbfFam:End()

      ::dbfOferta:End()

      ::dbfPedCliT:End()

      ::dbfPedCliL:End()

      ::dbfRuta:End()

      ::dbfTIva:End()

      ::dbfFPago:End()

   RECOVER

      msgStop( "Imposible cerrar todas las bases de datos.","Atención" )
      lOpen       := .F.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//
//
// Seleccionar/Deseleccionar un agente
//

Method SelAgente( lSel )

   DEFAULT lSel         := !::dbfAgente:lSelAge

   if ( lEsNumerico( ::dbfAgente:cCodAge ) .and. lSel ) .or. !lSel

      ::dbfAgente:Load()
      ::dbfAgente:lSelAge  := lSel
      ::dbfAgente:Save()
      ::oBrwAgente:Refresh()

   else

      msgStop( "El código del agente no es válido. Debe ser numérico.","Atención" )

   end if

return nil

//---------------------------------------------------------------------------//
//
// Funcion que monta el cuadro de dialogo
//

Method MuestraDialogo()

   // Obtener los decimales de la empresa (tiene que coincidir con los de MovilGes)

   ::nDecimales     := nDouDiv( cDivEmp(), ::dbfDiv:cAlias )

   ::SelAllAgente( .f., .f. )

   // pintar la ventana

   DEFINE DIALOG ::oDlg RESOURCE "MOVILGES"

   REDEFINE FOLDER ::oFld ;
         ID       500;
         OF       ::oDlg ;
         PROMPT   "&Configuración", "&Resultado" ;
         DIALOGS  "MOVILGES_1",     "MOVILGES_2"

   //listado de agente

   REDEFINE LISTBOX ::oBrwAgente ;
		FIELDS ;
               If( ::dbfAgente:lSelAge, ::bmpSelect, ::bmpUnselect ), ;
               ::dbfAgente:cCodaGE, ;
               RTrim( ::dbfAgente:cApeAge ) + ", " + ::dbfAgente:cNbrAge;
		TITLE;
					"S",;
               "Código",;
               "Apellidos, Nombre";
		SIZES ;
					15,;
					90,;
               260;
      OF       ::oFld:aDialogs[ 1 ] ;
      ID       330

   ::dbfAgente:SetBrowse( ::oBrwAgente )

   ::oBrwAgente:bLDblClick := {|| ::SelAgente() }
   ::oBrwAgente:aJustify   := { .F., .F., .F. }

   REDEFINE BUTTON ;
      ID       300;
      OF       ::oFld:aDialogs[ 1 ] ;
      ACTION   ( ::SelAgente() )

   REDEFINE BUTTON ;
      ID       310;
      OF       ::oFld:aDialogs[ 1 ] ;
      ACTION   ( ::SelAllAgente( .t., .t. ) )

   REDEFINE BUTTON ;
      ID       320;
      OF       ::oFld:aDialogs[ 1 ] ;
      ACTION   ( ::SelAllAgente( .t., .f. ) )

   //cuadro de seleccion de ruta

   REDEFINE GET ::oDirectorio VAR ::cDirectorio ;
      ID       400 ;
      COLOR    CLR_GET ;
      BITMAP   "FOLDER" ;
      OF       ::oFld:aDialogs[1]

   ::oDirectorio:bHelp  := {|| ::oDirectorio:cText( cGetDir32( "Seleccione destino" ) ) }

   //botones de la ventana base

   REDEFINE BUTTON ::oBotonAceptar;
      ID       510;
      OF       ::oDlg ;
      ACTION   ( ::MovilgesProcesar() )

   REDEFINE BUTTON ;
      ID       520;
      OF       ::oDlg ;
      ACTION   ( ::MovilgesSalir() )

   REDEFINE BUTTON ::oBotonImprimir;
      ID       540;
      OF       ::oDlg ;
      ACTION   ( ImprimirFichero( ::cLog ) )

   // los checkbox de seleccion de procesos

   REDEFINE CHECKBOX ::lExportarCliente;
         ID       100 ;
         WHEN     .T. ;
         OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lExportarRuta;
         ID       110 ;
         WHEN     .T. ;
         OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lExportarArticulo;
         ID       120 ;
         WHEN     .T. ;
         OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lExportarCobro;
         ID       130 ;
         WHEN     .T. ;
         OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lExportarFamilia;
         ID       140 ;
         WHEN     .T. ;
         OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lExportarComentario;
         ID       150 ;
         WHEN     .T. ;
         OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lExportarOferta;
         ID       160 ;
         WHEN     .T. ;
         OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lExportarAtipica;
         ID       170 ;
         WHEN     .T. ;
         OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lImportarAlbaran;
         ID       200 ;
         WHEN     .T. ;
         OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lImportarPedido;
         ID       210 ;
         WHEN     .T. ;
         OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lImportarFactura;
         ID       220 ;
         WHEN     .T. ;
         OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lImportarPago;
         ID       230 ;
         WHEN     .T. ;
         OF       ::oFld:aDialogs[1]

   // ventana de resultados

 REDEFINE APOLOMETER ::oMedidor;
      VAR      ::nMedidor ;
      PROMPT   "Proceso Actual";
      ID       600 ;
      OF       ::oFld:aDialogs[2]

   ::oTree              := TTreeView():Redefine( 610, ::oFld:aDialogs[ 2 ] )
   ::oTree:SetImageList( ::oImageList )
   ::oDlg:bStart        := {|| ::oBotonImprimir:hide(), ::CargarPreferencias() }

   ACTIVATE DIALOG ::oDlg CENTER

RETURN ( ::oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//
//
//  funcion que realiza los procesos de exportacion/importacion
//

Method MovilgesProcesar()

   if !Empty( ::oBotonAceptar )
      ::oBotonAceptar:bAction  := {|| ::MovilgesSalir() }
      SetWindowText( ::oBotonAceptar:hWnd, "&Terminar" )
   end if

   //comprobar que termina en \

   if substr( ::cDirectorio, -1 ) != "\"
      ::cDirectorio += "\"
   end if

   ::oFld:SetOption( 2 )

   ::SetTexto( 'Iniciando proceso.', 1 )

   ::dbfAgente:GoTop()

   while !::dbfAgente:eof()

      ::dbfAgente:GetStatus()

      if ::dbfAgente:lSelAge

         ::SetTexto( 'Procesando agente '+ ::dbfAgente:cCodAge, 1 )

         if ::lImportarAlbaran
            ::SetTexto( 'Importando Albaranes', 2 )
            ::MovilgesImportarAlbaran( ::dbfAgente:cCodAge )
         end if

         if ::lImportarPedido
            ::SetTexto( 'Importando Pedidos', 2 )
            ::MovilgesImportarPedido( ::dbfAgente:cCodAge )
         end if

         if ::lImportarFactura
            ::SetTexto( 'Importando Facturas', 2 )
            ::MovilgesImportarFactura( ::dbfAgente:cCodAge )
         end if

         if ::lImportarPago
            ::SetTexto( 'Importando Pagos de clientes', 2 )
            ::MovilgesImportarPago( ::dbfAgente:cCodAge )
         end if

         if ::lExportarCliente
            ::SetTexto( 'Exportando Clientes', 2 )
            ::MovilgesExportarClientes( ::dbfAgente:cCodAge )
         end if

         if ::lExportarRuta
            ::SetTexto( 'Exportando Rutas', 2 )
            ::MovilgesExportarRuta( ::dbfAgente:cCodAge )
         end if

         if ::lExportarArticulo
            ::SetTexto( 'Exportando Artículos', 2 )
            ::MovilgesExportarArticulo( ::dbfAgente:cCodAge )
         end if

         if ::lExportarCobro
            ::SetTexto( 'Exportando Pagos pendientes', 2 )
            ::MovilgesExportarPendientesCobro( ::dbfAgente:cCodAge )
         end if

         if ::lExportarFamilia
            ::SetTexto( 'Exportando Familias de productos', 2 )
            ::MovilgesExportarFamilia( ::dbfAgente:cCodAge )
         end if

         if ::lExportarComentario
            ::SetTexto( 'Exportando Comentarios de clientes', 2 )
            ::MovilgesExportarMsgCli( ::dbfAgente:cCodAge )
         end if

         if ::lExportarOferta
            ::SetTexto( 'Exportando Ofertas', 2 )
            ::MovilgesExportarOferta( ::dbfAgente:cCodAge )
         end if

         if ::lExportarAtipica
            ::SetTexto( 'Exportando Atípicas', 2 )
            ::MovilgesExportarAtipicas( ::dbfAgente:cCodAge )
         end if

         ::SetTexto( 'Exportando Formas de Pago', 2 )
         ::ExportarFPagos()

      end if

      ::dbfAgente:SetStatus()
      ::dbfAgente:Skip()

   end while

   ::SetTexto( 'Proceso finalizado.', 1 )

   ::GuardarPreferencias()

   ::dbfAgente:GoTop()

   ::oBotonImprimir:Show()

return ( Self )

//---------------------------------------------------------------------------//
//
//  finalizar el dialogo
//

Method MovilgesSalir()

   ::CloseFiles()
   ::oDlg:end()
   ::Destroy()

RETURN ( Self )

//---------------------------------------------------------------------------//
//
//  Exportar fichero de clientes para Movilgest (PDA)
//

Method MovilGesExportarClientes( cCodAgente )

   local cChr        //Una linea completa del fichero
   local fPda        //descriptor del fichero
   local cFilePda    //almacena el nombre del fichero para el pda

   cFilePda          := ::cDirectorio + "CLI" + ::cCodEmp + cCodAgente + ".DAT"

   //Creamos el fichero destino y si existe lo borramos

   BEGIN SEQUENCE

      IF file( cFilePda )
         fErase( cFilePda )
      END IF

   RECOVER

      ::SetTexto( "No se ha podido borrar el fichero " + cFilePda, 3 )
      RETURN NIL

   END SEQUENCE

   BEGIN SEQUENCE

      fPda     := fCreate( cFilePda )

   RECOVER

      ::SetTexto( "No se ha podido crear el fichero "+cFilePda, 3 )
      RETURN NIL

   END SEQUENCE

   ::SetTexto( , 40 )
   ::oMedidor:Set( 0 )
   ::oMedidor:cText     := "Exportando Clientes"
   ::oMedidor:SetTotal( ::dbfClient:LastRec() )
   ::dbfClient:GoTop()

   WHILE !::dbfClient:eof()

      if ::dbfClient:CAGENTE == cCodAgente

         ::oMedidor:Set( ::dbfClient:OrdKeyNo() )
         cChr  := ""

         cChr  += truncarCadenaDer( ::dbfClient:COD, 1, 10 )            //Codigo cliente

         if !empty( ::dbfClient:NBREST )                                // Nombre comercial

            cChr  += truncarCadenaIzq( ::dbfClient:NBREST, 1, 30 )      // Nombre del estblecimiento

         else

            cChr  += truncarCadenaIzq( ::dbfClient:TITULO, 1, 30 )      // Nombre de cliente

         end if

         cChr  += truncarCadena( ::dbfClient:TITULO, 1, 30 )            // Razon Social
         cChr  += truncarCadenaIzq( ::dbfClient:DOMICILIO, 1, 30 )      // Direccion
         cChr  += truncarCadena( ::dbfClient:POBLACION, 1, 30 )         // Población
         cChr  += truncarCadena( ::dbfClient:NIF, 1, 14 )               // CIF
         cChr  += truncarCadena( ::dbfClient:Telefono, 1, 20 )          // Telefono
         cChr  += truncarCadena( ::dbfClient:CPERCTO, 1, 20 )           // Persona de contacto

         do case                                                        // impuesto
            case ( ::dbfClient:nRegIva > 1 )
               cChr += "0"
            case ( ::dbfClient:nRegIva = 1 .and. !::dbfClient:lReq )
               cChr += "1"
            case ( ::dbfClient:nRegIva = 1 .and. ::dbfClient:lReq )
               cChr += "2"
            case ( ::dbfClient:nRegIva = 0 )
               cChr += "0"
         end case
         cChr  += "D"                                                   // ImpuestoEspecial
         cChr  += truncarNumero( ::dbfClient:nTarifa, 2, 0 )            //tarifa que se aplica
         cChr  += "D"                                                   // valoracion nota
         cChr  += truncarNumero( ::dbfClient:nDtoCnt, 5, 2 )            // Descuento 1
         cChr  += truncarNumero( ::dbfClient:nDtoRap, 5, 2 )            // Descuento 2
         cChr  += "00.00"                                               // Descuento 3
         cChr  += truncarCadenaDer( ::dbfClient:CCODGRP, 1, 10 )        // Grupo
         cChr  += truncarNumero( ::dbfClient:RIESGO, 8, ::nDecimales)   // Riesgo
         cChr  += "0"                                                   // Tipo Riesgo
         cChr  += "0"                                                   // Codigo Tipo de nota
         cChr  += "0"                                                   // C Tipo de nota

         if( truncarCadena( ::dbfClient:CodPago, 1, 1 ) = " " )         // codigo Forma de pago
            cChr += "0"                                                 //si vacio de ignora
         else
            cChr += truncarCadena( ::dbfClient:CodPago, 1, 1 )
         end if

         cChr  += "0"                                                    // CFormaPago
         cChr  += "D"                                                    // Exclusividad
         cChr  += "D"                                                    // Modificar descuento 1
         cChr  += "D"                                                    // Modificar descuento 2
         cChr  += "D"                                                    // Modificar descuento 3
         cChr  += "D"                                                    // Codigo alternativo de producto
         cChr  += "          "                                           // Codigo proveedor

         cChr  += CRLF                                                   //fin de linea

         ::nRead   := Len( cChr )

         if fwrite( fPda, cChr, ::nRead ) < ::nRead

            ::SetTexto( "El fichero de Clientes no se ha creado correctamente. ( error " + str( fError() ) + " )", 42 )
            RETURN NIL

         END IF

         ::SetTexto( "Añadido el cliente " + RTrim( ::dbfClient:Titulo ), 41 )

      end if

      //clientes sin agentes

      if empty( ::dbfClient:CAGENTE )

         ::SetTexto( "El cliente " + RTrim( ::dbfClient:Titulo ) + " no tiene asignado a ningún agente", 42 )

      end if

      ::dbfClient:Skip()

   END DO

   ::oMedidor:Set( ::dbfClient:LastRec() )
   ::SetTexto( "Fin de Exportación de clientes", 3 )

   fClose( fPda )

Return ( Self )

//---------------------------------------------------------------------------//
//
// Toma un numero y la hace del tamaño exacto que se le indica
//

function truncarNumero( nNum, nEnd, nDec )

   local cChar2

   cChar2            := str( nNum, nEnd, nDec )

   //Rellenamos con espacios hasta completar el tamaño

   cChar2            := rtrim( cChar2 )

   DO WHILE( len( cChar2 ) < nEnd )
      cChar2         := " " + cChar2
   ENDDO

RETURN ( cChar2 )

//--------------------------------------------------------------------------//
//
//  Toma una cadena y la hace del tamaño exacto que se le indica
//

function truncarCadena( cChar, nStart, nEnd )

   DEFAULT nStart := 1
   DEFAULT nEnd   := len( cChar )

   cChar          := cValToChar( cChar )
   cChar          := SubStr( cChar, nStart, nEnd )

   //Rellenamos con ceros hasta completar el tamaño

   DO WHILE( len( cChar ) < nEnd )
      cChar += " "
   ENDDO

RETURN ( cChar )

//---------------------------------------------------------------------------//
//
// Exportar fichero de articulos para Movilgest (PDA)
//
//   Condiciones:
//    Los articulos estan obligados a tener un codigo.
//    Siempre hay que indicar el codigo de " + cImp() + " que debe ser del 1 al 5
//

Method MovilgesExportarArticulo( cCodAgente )

   local cChr        //Una linea completa del fichero
   local fPda        //descriptor del fichero
   local cFilePda    //almacena el nombre del fichero para el pda

   cFilePda          := ::cDirectorio + "ART" + ::cCodEmp + cCodAgente + ".DAT"

   //Creamos el fichero destino

   Begin Sequence

      IF file( cFilePda )
         fErase( cFilePda )
      END IF

   RECOVER

      ::SetTexto( "No se ha podido borrar el fichero " + cFilePda, 3 )
      RETURN NIL

   END SEQUENCE

   Begin Sequence

      fPda     := fCreate( cFilePda )

   RECOVER

      ::SetTexto( "No se ha podido crear el fichero "+cFilePda, 3 )
      RETURN NIL

   END SEQUENCE

   ::SetTexto( , 40 )
   ::oMedidor:Set( 0 )
   ::oMedidor:cText     := "Exportando artículos"
   ::oMedidor:SetTotal( ::dbfArticulo:LastRec() )
   ::dbfArticulo:OrdsetFocus("MOVART")
   ::dbfArticulo:GoTop()

   while !::dbfArticulo:eof()

      if !( cCodTerIva( ::dbfArticulo:TipoIva, ::dbfTIva:nArea ) = " " )

         ::oMedidor:Set( ::dbfArticulo:OrdKeyNo() )

         cChr  := ""
         cChr  += truncarCadenaDer( ::dbfArticulo:CODIGO, 1, 18 )                // Codigo de articulo
         cChr  += truncarCadenaDer( ::dbfArticulo:FAMILIA, 1, 7 )                // Codigo de familia (nuestra familia es de 8)
         cChr  += truncarCadenaIzq( ::dbfArticulo:NOMBRE, 1, 30 )                // Nombre del articulo
         cChr  += truncarNumero( ::dbfArticulo:PVENTA1, 7, ::nDecimales )        // Tarifa 1

         if( ::dbfArticulo:PVENTA2 > 0 )                                         // Tarifa 2
            cChr  += truncarNumero( ::dbfArticulo:PVENTA2, 7, ::nDecimales )
         else                                                                    // si tarifa 2 es cero, se le pasa tarifa 1
            cChr  += truncarNumero( ::dbfArticulo:PVENTA1, 7, ::nDecimales )     //para que la tarifa de un cliente con tarifa 2
         end if                                                                  // no sea cero en la venta

         cChr  += truncarNumero( ::dbfArticulo:PVENTA3, 7, ::nDecimales )        // Tarifa 3
         cChr  += truncarNumero( ::dbfArticulo:PVENTA4, 7, ::nDecimales )        // Tarifa 4
         cChr  += truncarNumero( ::dbfArticulo:PVENTA5, 7, ::nDecimales )        // Tarifa 5
         cChr  += truncarNumero( ::dbfArticulo:PVENTA6, 7, ::nDecimales )        // Tarifa 6
         cChr  += "      0"                                                      // Tarifa 7
         cChr  += "      0"                                                      // Tarifa 8
         cChr  += "      0"                                                      // Tarifa 9
         cChr  += "      0"                                                      // Tarifa 10
         cChr  += truncarNumero( ::dbfArticulo:PCOSTO, 7, ::nDecimales )         // Precio de costo
         cChr  += truncarCadena( cCodTerIva( ::dbfArticulo:TipoIva, ::dbfTIva:nArea ) ) // Codigo del tipo de impuestos
         cChr  += truncarNumero( ::dbfArticulo:NCAJPLT, 6, 0 )                   // Numero de cajas por palet
         cChr  += truncarNumero( ::dbfArticulo:NPESOKG, 6, 3 )                   // Peso de la caja
         cChr  += "D"                                                            // Modificar precio
         cChr  += "D"                                                            // Modificar descuento 1
         cChr  += "D"                                                            // Modificar descuento 2
         cChr  += "D"                                                            // Modificar descuento 3
         cChr  += "D"                                                            // unidades de venta en pantalla
         cChr  += "                  "                                           // Envase asociado al articulo
         cChr  += "1"                                                            // Se imprime el articulo en la nota

         cChr  += CRLF

         ::nRead   := Len( cChr )

         if fwrite( fPda, cChr, ::nRead ) < ::nRead

            ::SetTexto( "El fichero de artículos no se ha creado correctamente. ( error " + str( fError() ) + " )", 3 )
            RETURN NIL

         END IF

         ::SetTexto( "Añadido el artículo " + RTrim( ::dbfArticulo:Nombre ), 41 )

      else

         //el articulo no tiene impuestos
         ::SetTexto( "El artículo " + RTrim( ::dbfArticulo:Nombre ) + " no tiene asignado ningún código de impuestos.", 42 )

      end if

      ::dbfArticulo:Skip()

   END DO

   ::oMedidor:Set( ::dbfArticulo:LastRec() )
   ::SetTexto( "Fin de Exportación de artículos.", 3 )
   fClose( fPda )

RETURN ( Self )

//-------------------------------------------------------------------------------//
//
//  Toma una cadena y la hace del tamaño exacto que se le indica por la derecha
//

function truncarCadenaDer( cChar, nStart, nEnd )

   DEFAULT nStart := 1
   DEFAULT nEnd   := len( cChar )

   cChar          := cValToChar( cChar )
   cChar          := SubStr( cChar, nStart, nEnd )

   //Rellenamos con ceros hasta completar el tamaño por la izquierda y eliminados los blancos a la derecha

   cChar := rtrim(cChar)

   DO WHILE( len( cChar ) < nEnd )
      cChar = " " + cChar
   ENDDO

RETURN ( cChar )

//---------------------------------------------------------------------------//
//
//  Exportar fichero de familias de articulos para Movilgest (PDA)
//

Method MovilGesExportarFamilia( cCodAgente )

   local cChr      //Una linea completa del fichero
   local fPda        //descriptor del fichero
   local cFilePda    //almacena el nombre del fichero para el pda

   cFilePda          := ::cDirectorio + "FAM" + ::cCodEmp + cCodAgente + ".DAT"

   //Creamos el fichero destino

   Begin Sequence

      IF file( cFilePda )
         fErase( cFilePda )
      END IF

   RECOVER

      ::SetTexto( "No se ha podido borrar el fichero " + cFilePda, 3 )
      RETURN NIL

   END SEQUENCE

   Begin Sequence

      fPda     := fCreate( cFilePda )

   RECOVER

      ::SetTexto( "No se ha podido crear el fichero "+cFilePda, 3 )
      RETURN NIL

   END SEQUENCE

   ::SetTexto( , 40 )
   ::oMedidor:Set( 0 )
   ::oMedidor:cText     := "Exportando familias"
   ::oMedidor:SetTotal( ::dbfFam:LastRec() )
   ::dbfFam:ordSetFocus( "TRMCOD" )
   ::dbfFam:GoTop()

   WHILE !::dbfFam:eof()

         ::oMedidor:Set( ::dbfFam:OrdKeyNo() )

         cChr  := ""

         cChr += truncarCadenaDer( ::dbfFam:cCodFam, 1, 7 )       // Codigo de familia (nuestra familia es de 8)
         cChr += truncarCadena( ::dbfFam:cNomFam, 1, 30 )         // nombre de familia

         cChr += CRLF                                             //fin de linea

         ::nRead   := Len( cChr )

         if fwrite( fPda, cChr, ::nRead ) < ::nRead

            ::SetTexto( "El fichero de familias no se ha creado correctamente. ( error " + str( fError() ) + " )", 42 )
            RETURN NIL

         END IF

         ::SetTexto( "Añadida la familia " + RTrim( ::dbfFam:cNomFam ), 41 )
         ::dbfFam:Skip()

   END DO

   ::oMedidor:Set( ::dbfFam:LastRec() )
   ::SetTexto( "Fin de Exportación de familias", 3 )
   fClose( fPda )

Return ( Self )

//---------------------------------------------------------------------------------//
//
// Toma una cadena y la hace del tamaño exacto que se le indica por la izquierda
//

function truncarCadenaIzq( cChar, nStart, nEnd )

   DEFAULT nStart := 1
   DEFAULT nEnd   := len( cChar )

   cChar          := cValToChar( cChar )
   cChar          := SubStr( cChar, nStart, nEnd )

   //Rellenamos con ceros hasta completar el tamaño por la izquierda y eliminados los blancos a la derecha

   cChar := ltrim(cChar)

   DO WHILE( len( cChar ) < nEnd )
      cChar += " "
   ENDDO

RETURN ( cChar )

//---------------------------------------------------------------------------//
//
//  Exportar fichero de ofertas de articulos para Movilgest (PDA)
//

Method MovilGesExportarOferta( cCodAgente )

   local cChr        //Una linea completa del fichero
   local fPda        //descriptor del fichero
   local cFilePda    //almacena el nombre del fichero para el pda

   cFilePda          := ::cDirectorio + "OFE" + ::cCodEmp + cCodAgente + ".DAT"

   //Creamos el fichero destino

   Begin Sequence

      IF file( cFilePda )
         fErase( cFilePda )
      END IF

   RECOVER

      ::SetTexto( "No se ha podido borrar el fichero " + cFilePda, 3 )
      RETURN NIL

   END SEQUENCE

   Begin Sequence

      fPda     := fCreate( cFilePda )

   RECOVER

      ::SetTexto( "No se ha podido crear el fichero "+cFilePda, 3 )
      RETURN NIL

   END SEQUENCE

   ::SetTexto( , 40 )
   ::oMedidor:Set( 0 )
   ::oMedidor:cText     := "Exportando ofertas"
   ::oMedidor:SetTotal( ::dbfOferta:LastRec() )
   ::dbfOferta:GoTop()

   WHILE !::dbfOferta:eof()

     if !empty( ::dbfOferta:cArtOfe )

         ::oMedidor:Set( ::dbfOferta:OrdKeyNo() )

         cChr  := ""

         do case
            case ::dbfOferta:NCLIOFE <= 1
               cChr += "3"                                                      // A quien afecta la oferta
               cChr += "0000000000"                                             // A que cliente afecta
               cChr += truncarCadenaDer( ::dbfOferta:CARTOFE, 1, 18 )           // A que articulo afecta
            case ::dbfOferta:NCLIOFE == 2
               cChr += "3"
               cChr += truncarCadena( ::dbfOferta:CGRPOFE, 1, 10 )
               cChr += truncarCadenaDer( ::dbfOferta:CARTOFE, 1, 18 )
            case ::dbfOferta:NCLIOFE == 3
               cChr += "1"
               cChr += truncarCadena( ::dbfOferta:CCLIOFE, 1, 10 )
               cChr += truncarCadenaDer( ::dbfOferta:CARTOFE, 1, 18 )
         end do
         cChr += truncarNumero( ::dbfOferta:NPREOFE1, 7, ::nDecimales )         // Precio
         cChr += truncarNumero( ::dbfOferta:NDTOLIN, 7, ::nDecimales )          // Descuento en cantidad
         cChr += truncarNumero( ::dbfOferta:NDTOPCT, 5, 2 )                     // descuento 1 en %
         cChr += "00.00"                                                        // descuento 2 en %
         cChr += truncarNumero( ::dbfOferta:NUNCOFE, 7, 0 )                     // En ofertas N x M (aqui el M)
         cChr += truncarNumero( ( ::dbfOferta:NUNVOFE - ::dbfOferta:NUNVOFE ), 7, 0 ) // En ofertas N x M (aqui N - M)
         cChr += truncarCadenaDer( ::dbfOferta:CARTOFE, 1, 18 )                 // Codigo articulo
         cChr += cTruncarFecha( ::dbfOferta:DINIOFE )                           // fecha de inicio (AAAA/MM/DD)
         cChr += cTruncarFecha( ::dbfOferta:DFINOFE )                           // Fecha de fin
         cChr += "0000000"                                                      // acumulado
         cChr += "0000000"                                                      // cantidad minima
         cChr += "0000000"                                                      // cantidad maxima

         cChr += CRLF                                                           //fin de linea

         ::nRead   := Len( cChr )

         if fwrite( fPda, cChr, ::nRead ) < ::nRead

            ::SetTexto( "El fichero de ofertas no se ha creado correctamente. ( error " + str( fError() ) + " )", 3 )
            RETURN NIL

         END IF

         ::SetTexto( "Añadida la oferta " + RTrim( ::dbfOferta:CARTOFE ), 41 )

      else

         //la oferta no es relativa a un artículo
         ::SetTexto( "La oferta " + RTrim( ::dbfOferta:CARTOFE ) + " no es relativa a un artículo", 42 )

      end if

      ::dbfOferta:Skip()

   END DO

   ::SetTexto( "Fin de Exportación de ofertas", 3 )
   ::oMedidor:SetTotal( ::dbfOferta:LastRec() )
   fClose( fPda )

Return ( Self )

//---------------------------------------------------------------------------------//
//
//  convierte un dato fecha en una cadena del tipo aaaa/mm/dd
//

function cTruncarFecha( dFecha )

   local char

   char := substr( dtos( dFecha ), 1, 4 ) + "/"
   char += substr( dtos( dFecha ), 5, 2 ) + "/"
   char += substr( dtos( dFecha ), 7, 2 )

return char

//---------------------------------------------------------------------------//
//
// Exportar fichero de notas pendientes de cobro para Movilgest (PDA)
//

Method MovilGesExportarPendientesCobro( cCodAgente )

   local cChr        //Una linea completa del fichero
   local fPda        //descriptor del fichero
   local cFilePda    //almacena el nombre del fichero para el pda

   cFilePda          := ::cDirectorio + "PEN" + ::cCodEmp + cCodAgente + ".DAT"

   //Creamos el fichero destino

   Begin Sequence

      IF file( cFilePda )
         fErase( cFilePda )
      END IF

   RECOVER

      ::SetTexto( "No se ha podido borrar el fichero " + cFilePda, 3 )
      RETURN NIL

   END SEQUENCE

   Begin Sequence

      fPda     := fCreate( cFilePda )

   RECOVER

      ::SetTexto( "No se ha podido crear el fichero "+cFilePda, 3 )
      RETURN NIL

   END SEQUENCE

   ::SetTexto( , 40 )
   ::oMedidor:Set( 0 )
   ::oMedidor:cText     := "Exportando Recibos no cobrados"
   ::oMedidor:SetTotal( ::dbfFacCliP:LastRec() )
   ::dbfFacCliP:OrdsetFocus( "cCodCli" )
   ::dbfFacCliP:GoTop()

   WHILE !::dbfFacCliP:eof()

         if ( ::dbfFacCliP:lCobrado == .F. )

            ::oMedidor:Set( ::dbfFacCliP:OrdKeyNo() )

            cChr  := ""

            cChr += truncarCadenaDer( ::dbfFacCliP:cCodCli, 1, 10 )                                     // Codigo de cliente
            cChr += cTruncarFecha( ::dbfFacCliP:dPreCob, 1, 10 )                                        // fecha
            cChr += truncarCadena( ( ::dbfFacCliP:cSerie + cValToChar( ::dbfFacCliP:nNumFac ) ), 1, 10 )//numero de nota
            cChr += "1"                                                                                 //codigo de tipo de nota
            cChr += truncarCadenaIzq( truncarNumero( ::dbfFacCliP:nNumRem, 10, ::nDecimales ), 1, 10 )  //remesa
            cChr += truncarNumero( ::dbfFacCliP:nImporte, 8, ::nDecimales )                             //importe
            cChr += truncarNumero( ::dbfFacCliP:nImporte, 8, ::nDecimales )                             //Pendiente

            cChr += CRLF                                                                                //fin de linea

            ::nRead   := Len( cChr )

            if fwrite( fPda, cChr, ::nRead ) < ::nRead

               ::SetTexto( "El fichero de Recibos no se ha creado correctamente. ( error " + str( fError() ) + " )", 3 )
               RETURN NIL

            END IF

            ::SetTexto( "Añadido el Recibo " + ::dbfFacCliP:cSerie + "/" + cValToChar( ::dbfFacCliP:nNumFac ) + "-" + cValToChar( ::dbfFacCliP:nNumRec ), 41 )

         end if

         ::dbfFacCliP:Skip()

   END DO

   ::oMedidor:SetTotal( ::dbfFacCliP:LastRec() )
   ::SetTexto( "Fin de Exportación de Recibos", 3 )
   fClose( fPda )

Return ( Self )

//---------------------------------------------------------------------------//
//
//  Exportar fichero de rutas para Movilgest (PDA)
//   Debe estar ordenado por ruta y dia
//

Method MovilGesExportarRuta( cCodAgente )

   local cChr        //Una linea completa del fichero
   local fPda        //descriptor del fichero
   local cFilePda    //almacena el nombre del fichero para el pda
   local nDia        //numero del dia de la semana
   local lVisita     //indica si se visita en un dia de la semana

   cFilePda          := ::cDirectorio + "RUT" + ::cCodEmp + cCodAgente + ".DAT"

   //Creamos el fichero destino

   Begin Sequence

      IF file( cFilePda )
         fErase( cFilePda )
      END IF

   RECOVER

      ::SetTexto( "No se ha podido borrar el fichero " + cFilePda, 3 )
      RETURN NIL

   END SEQUENCE

   Begin Sequence

      fPda     := fCreate( cFilePda )

   RECOVER

      ::SetTexto( "No se ha podido crear el fichero "+cFilePda, 3 )
      RETURN NIL

   END SEQUENCE

   ::SetTexto( , 40 )
   ::oMedidor:Set( 0 )
   ::oMedidor:cText     := "Exportando Rutas"
   ::oMedidor:SetTotal( ::dbfRuta:LastRec() )
   ::dbfClient:OrdsetFocus( "CCODRUT" )
   ::dbfRuta:GoTop()

   WHILE !::dbfRuta:eof()                                      // Recorremos las rutas ya que recorremos clientes por dias

      ::oMedidor:Set( ::dbfRuta:OrdKeyNo() )

      for nDia := 1 to 7

      ::dbfClient:Seek( ::dbfRuta:CCODRUT )                    //posicion al comiento de la ruta en cliente

      WHILE( !::dbfClient:eof() .and. ::dbfClient:cCodRut == ::dbfRuta:cCodRut )

         lVisita := .f.

         do case                                               //si no seleccionado dia no se introduce
            case nDia = 1 .and. ::dbfClient :lVisLun
               lVisita := .t.

            case nDia = 2 .and. ::dbfClient :lVisMar
               lVisita := .t.

            case nDia = 3 .and. ::dbfClient :lVisMie
               lVisita := .t.

            case ndia = 4 .and. ::dbfClient :lVisJue
               lVisita := .t.

            case ndia = 5 .and. ::dbfClient :lVisVie
               lVisita := .t.

            case ndia = 6 .and. ::dbfClient :lVisSab
               lVisita := .t.

            case ndia = 7 .and. ::dbfClient :lVisDom
               lVisita := .t.

         end case

         if( lVisita == .t. )                                                 // si tiene ruta y se visita en ese dia
            cChr  := ""

            cChr += substr( rtrim( ::dbfClient:cCodRut ), -3 )                // Codigo de ruta
            cChr += Str( nDia, 1 )                                            // dia de la semana
            cChr += truncarCadenaDer( ::dbfClient:Cod, 1, 10 )                // codigo del cliente

            cChr += CRLF                                                      //fin de linea

            ::nRead   := Len( cChr )

            if fwrite( fPda, cChr, ::nRead ) < ::nRead

               ::SetTexto( "El fichero de Rutas no se ha creado correctamente. ( error " + str( fError() ) + " )", 3 )
               RETURN NIL

            END IF

         end if

         ::SetTexto( "Añadida la ruta " + ::dbfClient:cCodRut + " para " + ::dbfClient:Titulo, 41 )
         ::dbfClient:Skip()

      end do                                                                   // se ha recorrido todos los clientes

      next                                                                     // se ha recorrido un dia

      ::dbfRuta:Skip()

   end do                                                                      // se ha recorrido una ruta

   ::oMedidor:SetTotal( ::dbfRuta:LastRec() )
   ::SetTexto( "Fin de Exportación de rutas", 3 )
   fClose( fPda )

Return ( Self )

//---------------------------------------------------------------------------//
//
//  Exportar fichero de mensajes de clientes para Movilgest (PDA)
//

Method MovilGesExportarMsgCli( cCodAgente )

   local cChr        //Una linea completa del fichero
   local fPda        //descriptor del fichero
   local cFilePda    //almacena el nombre del fichero para el pda

   cFilePda          := ::cDirectorio + "MEN" + ::cCodEmp + cCodAgente + ".DAT"

   //Creamos el fichero destino

   Begin Sequence

      IF file( cFilePda )
         fErase( cFilePda )
      END IF

   RECOVER

      ::SetTexto( "No se ha podido borrar el fichero " + cFilePda, 3 )
      RETURN NIL

   END SEQUENCE

   Begin Sequence

      fPda     := fCreate( cFilePda )

   RECOVER

      ::SetTexto( "No se ha podido crear el fichero "+cFilePda, 3 )
      RETURN NIL

   END SEQUENCE

   ::SetTexto( , 40 )
   ::oMedidor:Set( 0 )
   ::oMedidor:cText     := "Exportando Comentarios de clientes"
   ::oMedidor:SetTotal( ::dbfClient:LastRec() )
   ::dbfClient:GoTop()

   WHILE !::dbfClient:eof()

      if( ( ::dbfClient:lMosCom == .T. ) .and. ( len( ltrim( ::dbfClient:mComent ) ) > 0 ) )

         ::oMedidor:Set( ::dbfClient:OrdKeyNo() )

         cChr  := ""

         cChr += truncarCadenaDer( ::dbfClient:Cod, 1, 10 )                    // codigo del cliente
         cChr += "1"                                                            // visualizar o no (1)
         cChr += truncarCadenaizq( ::dbfClient:mComent, 1, 60 )                // texto (1)
         cChr += "1"                                                            // visualizar o no (2)
         cChr += truncarCadenaizq( ::dbfClient:mComent, 61, 60 )               // texto (2)
         cChr += "1"                                                            // visualizar o no (3)
         cChr += truncarCadenaizq( ::dbfClient:mComent, 121, 60 )              // texto (3)
         cChr += "1"                                                            // visualizar o no (4)
         cChr += truncarCadenaizq( ::dbfClient:mComent, 181, 60 )              // texto (4)
         cChr += "1"                                                            // visualizar o no (5)
         cChr += truncarCadenaizq( ::dbfClient:mComent, 241, 60 )              // texto (5)
         cChr += "1"                                                            // visualizar o no (6)
         cChr += truncarCadenaizq( ::dbfClient:mComent, 301, 60 )              // texto (6)

         cChr += CRLF                                                            //fin de linea

         ::nRead   := Len( cChr )

         if fwrite( fPda, cChr, ::nRead ) < ::nRead

            ::SetTexto( "El fichero de Comentarios no se ha creado correctamente. ( error " + str( fError() ) + " )", 3 )
            RETURN NIL

         END IF

         ::SetTexto( "Añadido el comentario para " + ::dbfClient:Titulo, 41 )

      else

         // caso en que no tenga comentario

      end if

      ::dbfClient:Skip()

   END DO

   ::oMedidor:SetTotal( ::dbfClient:LastRec() )
   ::SetTexto( "Fin de exportación de comentarios.", 3 )
   fClose( fPda )

Return ( Self )

//---------------------------------------------------------------------------//
//--Funcion para importar pedidos desde movilgest (PDA)----------------------//
//---------------------------------------------------------------------------//

Method movilgesImportarPedido( cCodAgente )

   local nNumPed
   local cLinea
   local cFileCabecera
   local CFileLinea
   local oFileCabecera
   local oFileLote
   local cFileLote
   local cLote
   local lLote
   local dFecha
   local oFilelinea
   local cCabecera
   local cCodCli
   local lExentoIva

   cFileCabecera     := ::cDirectorio + "NOC" + ::cCodEmp + cCodAgente + ".DES"
   cFilelinea        := ::cDirectorio + "NOL" + ::cCodEmp + cCodAgente + ".DES"
   cFileLote         := ::cDirectorio + "NLO" + ::cCodEmp + cCodAgente + ".DES"

   //Creamos el fichero destino

   if !file( cFileCabecera )

      ::SetTexto( "No existe el fichero " + cFileCabecera, 3 )
      return nil

   end if

   if !file( cFileLinea )

      ::SetTexto( "No existe el fichero " + cFileLinea, 3 )
      return nil

   end if

   oFileCabecera     := TTxtFile():New( cFileCabecera )
   oFileLinea        := TTxtFile():New( cFileLinea )

   if !file( cFileLote )
      ::SetTexto( "No hay ficheros de lotes.", 3 )
      lLote          := .F.
   else
      oFileLote      := TTxtFile():New( cFileLote )
      lLote          := .T.
   end if

   //Cabecera del pedido

   cCabecera         := oFileCabecera:cLine

   ::SetTexto( , 40 )
   ::oMedidor:Set( 0 )
   ::oMedidor:cText     := "Importando pedidos"
   ::oMedidor:SetTotal( oFileCabecera:LastRec() )

   while( ! oFileCabecera:lEoF() )

      cCodCli        := truncarCadenaIzq( substr( cCabecera, 1, 10 ), 1, 12 )    //primero se extrae y despues se rellena

      if ::dbfClient:Seek( cCodCli ) .and. ( substr( cCabecera, 21, 1 ) == "9" ) // 9 es el codigo de pedido general

         dFecha                  := dTruncarFecha( substr( cCabecera, 261, 10 ) )
         lExentoIva              := truncarCadena( cCabecera, 242, 1 ) = "N"     //Si esta exento de impuestos

         ::oMedidor:Set( oFileCabecera:nRecNo() )

         nNumPed     := nNewDoc( ::dbfClient:Serie, ::dbfPedCliT:nArea, "NPEDCLI" )

         ::dbfPedCliT:Append()                                                   // insertamos nueva linea de pedido
         ::dbfPedCliT:cSerPed    := ::dbfClient:Serie                            // serie del pedido
         ::dbfPedCliT:nNumPed    := nNumPed                                      //Obtenemos el nuevo numero de factura
         ::dbfPedCliT:cSufPed    := RetSufEmp()                                  //sufijo del pedido
         ::dbfPedCliT:cTurPed    := cCurSesion()                                 // sesion del pedido
         ::dbfPedCliT:dFecPed    := dFecha                                       // fecha del pedido
         ::dbfPedCliT:cCodCli    := ::dbfClient:Cod
         ::dbfPedCliT:cNomCli    := ::dbfClient:Titulo                           // nombre
         ::dbfPedCliT:cDirCli    := ::dbfClient:Domicilio                        // direccion
         ::dbfPedCliT:cPobCli    := ::dbfClient:Poblacion                        // poblacion
         ::dbfPedCliT:cPrvCli    := ::dbfClient:Provincia                        // provincia
         ::dbfPedCliT:cPosCli    := ::dbfClient:CodPostal                        // codigo postal
         ::dbfPedCliT:cDniCli    := ::dbfClient:Nif                              // dni
         ::dbfPedCliT:cCodAge    := cCodAgente                                   // codigo de agente
         ::dbfPedCliT:cCodTar    := ::dbfClient :cCodTar                         // codigo de tarifa
         ::dbfPedCliT:cCodAlm    := oUser():cAlmacen()                                    // codigo de almacen
         ::dbfPedCliT:cCodCaj    := "000"                                        // codigo de caja
         ::dbfPedCliT:cCodPgo    := "0" + substr( cCabecera, 259, 1 )
         ::dbfPedCliT:cCodRut    := ::dbfClient :cCodRut                         // codigo de ruta
         ::dbfPedCliT:nEstado    := 1                                            // estado del pedido
         ::dbfPedCliT:MobServ    := truncarCadenaDer( cCabecera, 293, 60 )       // observaciones
         ::dbfPedCliT:nTarifa    := ::dbfClient:nTarifa                          // tarifa aplicada
         ::dbfPedCliT:nDtoEsp    := Val( substr( cCabecera, 59, 5 ) )
         ::dbfPedCliT:nDpp       := Val( substr( cCabecera, 64, 5 ) )
         ::dbfPedCliT:nDtoUno    := Val( substr( cCabecera, 69, 5 ) )
         ::dbfPedCliT:cDtoUno    := "Especial 2"
         ::dbfPedCliT:nDtoDos    := ::dbfClient:nDtoRap                          // % del segundo descuento
         ::dbfPedCliT:nDtoCnt    := ::dbfClient:nDtoCnt                          // % descuento por pago contado
         ::dbfPedCliT:nDtoRap    := ::dbfClient:nDtoRap                          // % de descuento en rappel
         ::dbfPedCliT:lRecargo   := Val( substr( cCabecera, 194, 8 ) ) != 0
         ::dbfPedCliT:cDivPed    := cDivEmp()                                    // Codigo de divisa
         ::dbfPedCliT:nVdvPed    := nChgDiv( ::dbfPedCliT:cDivPed, ::dbfDiv:nArea )// valor de cambio de la divisa
         ::dbfPedCliT:nRegIva    := ::dbfClient:nRegIva
         ::dbfPedCliT:Save()                                                     // insertamos nueva linea de pedido

         //cargamos las lineas del pedido

         oFileLinea:GoTop()
         cLinea            := oFileLinea:cLine

         while ! oFileLinea:lEoF()

            //Capturamos las lineas de detalle
            if( substr( cLinea, 11, 1 ) == "9" .and. substr( cCabecera, 11, 10 ) == substr( cLinea, 1, 10 ) )
               ::dbfPedCliL:Append()
               ::dbfPedCliL:cSerPed := ::dbfPedCliT:cSerPed                      // serie del pedido
               ::dbfPedCliL:nNumPed := ::dbfPedCliT:nNumPed                      // numero del pedido
               ::dbfPedCliL:cSufPed := ::dbfPedCliT:cSufPed                      // sufijo del pedido
               ::dbfPedCliL:cRef    := truncarCadenaIzq( cLinea, 12, 18 )        // referencia del articulo
               ::dbfPedCliL:cDetalle:= RetFld( ::dbfPedCliL:cRef, ::dbfArticulo:nArea ) // nombre del articulo
               if !lExentoIva
                  ::dbfPedCliL:nIva := nCodigoAsociadoIva( SubStr( cLinea, 76, 1 ) )
               else
                  ::dbfPedCliL:nIva := 0
               end if
               ::dbfPedCliL:nCanPed := Val( SubStr( cLinea, 54, 7 ) )
               ::dbfPedCliL:nUniCaja:= Val( SubStr( cLinea, 61, 7 ) )
               ::dbfPedCliL:nPreDiv := Val( SubStr( cLinea, 30, 7 ) )
               ::dbfPedCliL:nDtoDiv := Val( SubStr( cLinea, 37, 7 ) )
               ::dbfPedCliL:nDto    := Val( SubStr( cLinea, 44, 5 ) )
               ::dbfPedCliL:nDtoPrm := Val( SubStr( cLinea, 49, 5 ) )
               ::dbfPedCliL:lLote   := lLote

               if lLote

                  oFileLote:GoTop()
                  cLote                := oFileLote:cLine

                  while !oFileLote:lEof()

                     if substr(cLinea, 1, 10 ) = substr( cLote, 1, 10 ) .and. substr(cLinea, 12, 18 ) = substr( cLote, 12, 18 )

                        ::dbfPedCliL:cLote   := Substr( cLote, 30, 20 )

                     end if

                     oFileLote:Skip()
                     cLote             := oFileLote:ReadLine()

                  end do

               end if
               ::dbfPedCliL:Save()

            end if                                                                        //cierra el if de la linea

            //Prelectura de la siguiente linea

            oFileLinea:Skip()
            cLinea    := oFileLinea:ReadLine()

         end do                                                                           // fin de la busqueda de linea

      ::SetTexto( "Añadido pedido " + ::dbfPedCliT:cSerPed + "/" + str( ::dbfPedCliT:nNumPed ) + " para " + ::dbfClient:Titulo, 41 )

      end if                                                                              //fin del if de la cabecera

      oFileCabecera:Skip()
      cCabecera    := oFileCabecera:ReadLine()

   end do

   ::oMedidor:SetTotal( oFileCabecera:LastRec() )
   ::SetTexto( "Fin de importación de pedidos.", 3 )

   oFileCabecera:Close()
   oFileLinea:Close()

   if file( cFileLote )

      oFileLote:Close()

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//
//
//  Devuelva el " + cImp() + " pasando el Codigo asociado
//

FUNCTION nCodigoAsociadoIva( cCodIva, dbfTIva )

   local nOrdFocus
	local cTemp 		:= 0

   do case
   case ValType( dbfTIva ) == "C"                                       //no es un objeto

      nOrdFocus      := ( dbfTIva )->( OrdSetFocus( "CodTer" ) )

      if ( dbfTIva )->( dbSeek( cCodIva ) )
         cTemp       := ( dbfTIva )->TPIva
      end if

      ( dbfTIva )->( OrdSetFocus( nOrdFocus ) )

   case ValType( dbfTIva ) == "O"                                       // es un objeto

      nOrdFocus      := dbfTIva:OrdSetFocus( "CodTer" )

      if dbfTIva:Seek( cCodIva )
         cTemp       := dbfTIva:TPIva
      end if

      dbfTIva:OrdSetFocus( nOrdFocus )

   end case

RETURN cTemp

//---------------------------------------------------------------------------//
//
//  Devuelve una fecha desde una cadena en formato aaaa-mm-dd
//

FUNCTION dTruncarFecha( cFecha )

   local dFecha

   dFecha   := ctod( substr( cFecha, -2 ) + substr( cFecha, 5, 4 ) + substr( cFecha, 1, 4 ) )

RETURN dFecha

//---------------------------------------------------------------------------//
//
//  Exportar tabla de atipicas a movilges (PDA)
//

Method MovilgesExportarAtipicas( cCodAgente )

   local cChr        //Una linea completa del fichero
   local fPda        //descriptor del fichero
   local cFilePda    //almacena el nombre del fichero para el pda

   cFilePda          := ::cDirectorio + "PRE" + ::cCodEmp + cCodAgente + ".DAT"

   //Creamos el fichero destino

   Begin Sequence

      IF file( cFilePda )
         fErase( cFilePda )
      END IF

   RECOVER

      ::SetTexto( "No se ha podido borrar el fichero " + cFilePda, 3 )
      RETURN NIL

   END SEQUENCE

   Begin Sequence

      fPda     := fCreate( cFilePda )

   RECOVER

      ::SetTexto( "No se ha podido crear el fichero "+cFilePda, 3 )
      RETURN NIL

   END SEQUENCE

   ::SetTexto( , 40 )
   ::oMedidor:Set( 0 )
   ::oMedidor:cText     := "Exportando atípicas"
   ::oMedidor:SetTotal( ::dbfCliAtp:LastRec() )
   ::dbfCliAtp:OrdSetFocus( "MOVCLI" )
   ::dbfCliAtp:GoTop()

   WHILE !::dbfCliAtp:eof()

      ::oMedidor:Set( ::dbfCliAtp:OrdKeyNo() )

      cChr  := ""

      if ::dbfCliAtp:nTipAtp <= 1
         cChr += "1"                                              // tipo de atipica
         cChr += truncarCadenaDer( ::dbfCliAtp:cCodCli, 1, 10 )   // codigo de cliente
         cChr += truncarCadenaDer( ::dbfCliAtp:cCodArt, 1, 18 )   // Codigo de articulo
         cChr += truncarNumero( ::dbfCliAtp:nPrcArt, 7, ::nDecimales )// Precio
      else
         cChr += "2"
         cChr += truncarCadenaDer( ::dbfCliAtp:cCodCli, 1, 10 )
         cChr += truncarCadenaDer( SubStr( ::dbfCliAtp:cCodFam, 1, 7 ), 1, 18 )// codigo de familia
         cChr += truncarNumero( 0, 7, ::nDecimales )              // Precio
      end if

      cChr += truncarNumero( ::dbfCliAtp:nDtoDiv, 7, ::nDecimales )// Descuento monetario
      cChr += truncarNumero( ::dbfCliAtp:nDtoArt, 5, 2 )          // Descuento en % 1
      cChr += truncarNumero( ::dbfCliAtp:nDprArt, 5, 2 )          // Descuento en % 2

      cChr += CRLF                                                   //fin de linea

      ::nRead   := Len( cChr )

      if fwrite( fPda, cChr, ::nRead ) < ::nRead

         ::SetTexto( "El fichero de atípicas no se ha creado correctamente. ( error " + str( fError() ) + " )", 3 )
         RETURN NIL

      END IF

      ::setTexto( "Añadida atípica para el cliente " + ::dbfCliAtp:cCodCli, 41 )
      ::dbfCliAtp:Skip()

   END DO

   ::oMedidor:SetTotal( ::dbfCliAtp:LastRec() )
   ::SetTexto( "Fin de exportación de atípicas.", 3 )
   fClose( fPda )

RETURN nil

//---------------------------------------------------------------------------//
//
//  Funcion para importar albaranes desde movilgest (PDA)
//

Method movilgesImportarAlbaran( cCodAgente )

   local nNumAlb
   local cLinea
   local cFileCabecera
   local CFileLinea
   local oFileCabecera
   local oFileLote
   local cFileLote
   local cLote
   local lLote
   local dFecha
   local oFilelinea
   local cCabecera
   local cCodCli
   local lExentoIva

   cFileCabecera     := ::cDirectorio + "NOC" + ::cCodEmp + cCodAgente + ".DES"
   cFilelinea        := ::cDirectorio + "NOL" + ::cCodEmp + cCodAgente + ".DES"
   cFileLote         := ::cDirectorio + "NLO" + ::cCodEmp + cCodAgente + ".DES"

   //Creamos el fichero destino

   if !file( cFileCabecera )

      ::SetTexto( "No existe el fichero " + cFileCabecera, 3 )
      return nil

   end if

   if !file( cFileLinea )

      ::SetTexto( "No existe el fichero " + cFileLinea, 3 )
      return nil

   end if

   oFileCabecera     := TTxtFile():New( cFileCabecera )
   oFileLinea        := TTxtFile():New( cFileLinea )

   if !file( cFileLote )

      ::SetTexto( "No hay ficheros de lotes.", 3 )
      lLote          := .F.

   else
      oFileLote      := TTxtFile():New( cFileLote )
      lLote          := .T.
   end if

   //Cabecera del pedido

   cCabecera            := oFileCabecera:cLine

   ::SetTexto( , 40 )
   ::oMedidor:Set( 0 )
   ::oMedidor:cText     := "Importando albaranes"
   ::oMedidor:SetTotal( oFileCabecera:LastRec() )

   while( ! oFileCabecera:lEoF() )

      cCodCli        := truncarCadenaIzq( substr( cCabecera, 1, 10 ), 1, 12 )      //primero se extrae y despues se rellena

      if ::dbfClient:Seek( cCodCli ) .and. ( substr( cCabecera, 21, 1 ) == "2" )   // 2 es el codigo de Albaranes

         ::oMedidor:Set( oFileCabecera:nRecNo() )

         dFecha         := dTruncarFecha( substr( cCabecera, 261, 10 ) )
         lExentoIva     := truncarCadena( cCabecera, 242, 1 ) = "N"                   //Si esta exento de impuestos

         nNumAlb        := nNewDoc( ::dbfClient :Serie, ::dbfAlbCliT:nArea, "NALBCLI" )

         ::dbfAlbCliT:Append()
         ::dbfAlbCliT:cSerAlb    := ::dbfClient:Serie
         ::dbfAlbCliT:nNumAlb    := nNumAlb
         ::dbfAlbCliT:cSufAlb    := RetSufEmp()
         ::dbfAlbCliT:dFecAlb    := dFecha
         ::dbfAlbCliT:cCodAlm    := oUser():cAlmacen()
         ::dbfAlbCliT:cDivAlb    := cDivEmp()
         ::dbfAlbCliT:nVdvAlb    := nChgDiv( ::dbfAlbCliT:cDivAlb, ::dbfDiv:nArea )
         ::dbfAlbCliT:lFacturado := .f.
         ::dbfAlbCliT:lEntregado := .f.                                            // entregado
         ::dbfAlbCliT:cCodCli    := ::dbfClient:COD
         ::dbfAlbCliT:cNomCli    := ::dbfClient:TITULO
         ::dbfAlbCliT:cDirCli    := ::dbfClient:DOMICILIO
         ::dbfAlbCliT:cPobCli    := ::dbfClient:POBLACION
         ::dbfAlbCliT:cPrvCli    := ::dbfClient:PROVINCIA
         ::dbfAlbCliT:cPosCli    := ::dbfClient:CODPOSTAL
         ::dbfAlbCliT:cDniCli    := ::dbfClient:NIF
         ::dbfAlbCliT:cCodTar    := ::dbfClient:CCODTAR
         ::dbfAlbCliT:cCodPago   := "0" + substr( cCabecera, 259, 1 )
         ::dbfAlbCliT:cCodAge    := ::dbfClient:CAGENTE
         ::dbfAlbCliT:cCodRut    := ::dbfClient:CCODRUT
         ::dbfAlbCliT:nTarifa    := ::dbfClient:NTARIFA
         ::dbfAlbCliT:lRecargo   := Val( substr( cCabecera, 194, 8 ) ) != 0
         ::dbfAlbCliT:nDtoEsp    := Val( substr( cCabecera, 59, 5 ) )
         ::dbfAlbCliT:nDpp       := Val( substr( cCabecera, 64, 5 ) )
         ::dbfAlbCliT:nDtoUno    := Val( substr( cCabecera, 69, 5 ) )
         ::dbfAlbCliT:cDtoUno    := "Especial 2"
         ::dbfAlbCliT:cCodCaj    := cDefCaj()                                    // codigo de caja
         ::dbfAlbCliT:MobServ    := truncarCadenaDer( cCabecera, 293, 60 )       // observaciones
         ::dbfAlbCliT:cTurAlb    := cCurSesion()                                 // sesion del pedido
         ::dbfAlbCliT:Save()

         //cargamos las lineas del pedido

         oFileLinea:GoTop()
         cLinea            := oFileLinea:cLine

         while ! oFileLinea:lEoF()

            //Capturamos las lineas de detalle
            if( substr( cLinea, 11, 1 ) == "2" .and. substr( cCabecera, 11, 10 ) == substr( cLinea, 1, 10 ) )

               ::dbfAlbCliL:Append()
               ::dbfAlbCliL:cSerAlb       := ::dbfAlbCliT:cSerAlb
               ::dbfAlbCliL:nNumAlb       := ::dbfAlbCliT:nNumAlb
               ::dbfAlbCliL:cSufAlb       := ::dbfAlbCliT:cSufAlb
               ::dbfAlbCliL:cRef          := Upper( TruncarCadenaIzq( cLinea, 12, 18 ) )  // referencia del articulo
               ::dbfAlbCliL:cDetalle      := RetFld( ::dbfAlbCliL:cRef, ::dbfArticulo:nArea, "Nombre" )
               if !lExentoIva
                  ::dbfAlbCliL:nIva := nCodigoAsociadoIva( SubStr( cLinea, 76, 1 ) )
               else
                  ::dbfAlbCliL:nIva := 0
               end if
               ::dbfAlbCliL:nPreUnit      := Val( SubStr( cLinea, 30, 7 ) )
               ::dbfAlbCliL:nDtoDiv       := Val( SubStr( cLinea, 37, 7 ) )
               ::dbfAlbCliL:nDto          := Val( SubStr( cLinea, 44, 5 ) )
               ::dbfAlbCliL:cUnidad       := SubStr( LTrim( substr( cLinea, 54, 7 ) ), 1, 2 )
               ::dbfAlbCliL:nUniCaja      := Val( SubStr( cLinea, 61, 7 ) )
               ::dbfAlbCliL:nDtoPrm       := Val( SubStr( cLinea, 49, 5 ) )
               ::dbfAlbCliL:lLote         := lLote

               if lLote

                  oFileLote:GoTop()
                  cLote                := oFileLote:cLine

                  while !oFileLote:lEof()

                     if substr(cLinea, 1, 10 ) = substr( cLote, 1, 10 ) .and. substr(cLinea, 12, 18 ) = substr( cLote, 12, 18 )

                        ::dbfAlbCliL:cLote   := Substr( cLote, 30, 20 )

                     end if

                     oFileLote:Skip()
                     cLote             := oFileLote:ReadLine()

                  end do

               end if

               ::dbfAlbCliL:Save()

            end if

            //Prelectura de la siguiente linea

            oFileLinea:Skip()
            cLinea    := oFileLinea:ReadLine()

         end do                                                                           // fin del procesado de las lineas

      end if                                                                              // fin del if de la cabecera

      oFileCabecera:Skip()
      cCabecera    := oFileCabecera:ReadLine()

      ::SetTexto( "Añadido albarán " + ::dbfAlbCliT:cSerAlb + "/" + str( ::dbfAlbCliT:nNumAlb ) + " para " + ::dbfClient:Titulo, 41 )

   end do

   ::oMedidor:SetTotal( oFileCabecera:LastRec() )
   ::SetTexto( "Fin de importación de albaranes.", 3 )
   oFileCabecera:Close()
   oFileLinea:Close()

   if file( cFileLote )

      oFileLote:Close()

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//
//
//  Funcion para importar facturas desde movilgest (PDA)
//

Method movilgesImportarFactura( cCodAgente )

   local nNumFac
   local cLinea
   local cFileCabecera
   local CFileLinea
   local oFileLote
   local cFileLote
   local cLote
   local lLote
   local oFileCabecera
   local dFecha
   local oFilelinea
   local cCabecera
   local cCodCli
   local lExentoIva

   cFileCabecera     := ::cDirectorio + "NOC" + ::cCodEmp + cCodAgente + ".DES"
   cFilelinea        := ::cDirectorio + "NOL" + ::cCodEmp + cCodAgente + ".DES"
   cFileLote         := ::cDirectorio + "NLO" + ::cCodEmp + cCodAgente + ".DES"

   //Creamos el fichero destino

   if !file( cFileCabecera )
      ::SetTexto( "No existe el fichero " + cFileCabecera, 3 )
      return nil
   end if

   if !file( cFileLinea )
      ::SetTexto( "No existe el fichero " + cFileLinea, 3 )
      return nil
   end if

   if !file( cFileLote )
      ::SetTexto( "No hay ficheros de lotes.", 3 )
      lLote          := .F.
   else
      oFileLote      := TTxtFile():New( cFileLote )
      lLote          := .T.
   end if

   oFileCabecera     := TTxtFile():New( cFileCabecera )
   oFileLinea        := TTxtFile():New( cFileLinea )

   //Cabecera del pedido

   cCabecera         := oFileCabecera:cLine

   ::SetTexto( , 40 )
   ::oMedidor:Set( 0 )
   ::oMedidor:cText     := "Importando Facturas"
   ::oMedidor:SetTotal( oFileCabecera:LastRec() )

   while( ! oFileCabecera:lEoF() )

      cCodCli        := truncarCadenaIzq( substr( cCabecera, 1, 10 ), 1, 12 ) //primero se extrae y despues se rellena

      if ::dbfClient:Seek( cCodCli ) .and. ( substr( cCabecera, 21, 1 ) == "1" ) // 1 es el codigo de las facturas

         ::oMedidor:Set( oFileCabecera:nRecNo() )

         dFecha         := dTruncarFecha( substr( cCabecera, 261, 10 ) )
         lExentoIva     := truncarCadena( cCabecera, 242, 1 ) = "N"           //Si esta exento de impuestos

         nNumFac     := nNewDoc( ::dbfClient:Serie, ::dbfFacCliT:nArea, "NFACCLI" )

         ::dbfFacCliT:Append()                                                // insertamos nueva linea de pedido
         ::dbfFacCliT:cSerie     := ::dbfClient:Serie
         ::dbfFacCliT:nNumFac    := nNumFac                                   //Obtenemos el nuevo numero de factura
         ::dbfFacCliT:cSufFac    := RetSufEmp()                               //sufijo del pedido
         ::dbfFacCliT:cTurFac    := cCurSesion()                              // sesion del pedido
         ::dbfFacCliT:dFecFac    := dFecha                                    // fecha del pedido
         ::dbfFacCliT:cCodCli    := ::dbfClient:Cod
         ::dbfFacCliT:cNomCli    := ::dbfClient:Titulo                        // nombre
         ::dbfFacCliT:cDirCli    := ::dbfClient:Domicilio                     // direccion
         ::dbfFacCliT:cPobCli    := ::dbfClient:Poblacion                     // poblacion
         ::dbfFacCliT:cPrvCli    := ::dbfClient:Provincia                     // provincia
         ::dbfFacCliT:cPosCli    := ::dbfClient:CodPostal                     // codigo postal
         ::dbfFacCliT:cDniCli    := ::dbfClient:Nif                           // dni
         ::dbfFacCliT:cCodAge    := cCodAgente                                // codigo de agente
         ::dbfFacCliT:cCodTar    := ::dbfClient:cCodTar                       // codigo de tarifa
         ::dbfFacCliT:cCodAlm    := oUser():cAlmacen()                                 // codigo de almacen
         ::dbfFacCliT:cCodCaj    := cDefCaj()
         ::dbfFacCliT:cCodPago   := "0" + substr( cCabecera, 259, 1 )
         ::dbfFacCliT:cCodRut    := ::dbfClient:cCodRut                       // codigo de ruta
         ::dbfFacCliT:MobServ    := truncarCadenaDer( cCabecera, 293, 60 )    // observaciones
         ::dbfFacCliT:nTarifa    := ::dbfClient:nTarifa                       // tarifa aplicada
         ::dbfFacCliT:nDtoEsp    := Val( substr( cCabecera, 59, 5 ) )
         ::dbfFacCliT:nDpp       := Val( substr( cCabecera, 64, 5 ) )
         ::dbfFacCliT:nDtoUno    := Val( substr( cCabecera, 69, 5 ) )
         ::dbfFacCliT:cDtoUno    := "Especial 2"
         ::dbfFacCliT:nDtoDos    := ::dbfClient:nDtoRap                        // % del segundo descuento
         ::dbfFacCliT:nDtoCnt    := ::dbfClient:nDtoCnt                        // % descuento por pago contado
         ::dbfFacCliT:nDtoRap    := ::dbfClient:nDtoRap                        // % de descuento en rappel
         ::dbfFacCliT:lRecargo   := Val( substr( cCabecera, 194, 8 ) ) != 0
         ::dbfFacCliT:cDivFac    := cDivEmp()                                  // Codigo de divisa
         ::dbfFacCliT:nVdvFac    := nChgDiv( ::dbfFacCliT :cDivFac, ::dbfDiv:nArea )   // valor de cambio de la divisa
         ::dbfFacCliT:nRegIva    := ::dbfClient:nRegIva
         ::dbfFacCliT:Save()

          // importamos los pagos

          if substr( cCabecera, 259, 1 ) != "4" .and. val( substr( cCabecera, 251, 8 ) ) != 0
             //primera forma de pago
             ::dbfFacCliP:Append()
             ::dbfFacCliP:cSerie     := ::dbfClient:Serie
             ::dbfFacCliP:nNumFac    := nNumFac
             ::dbfFacCliP:cSufFac    := RetSufEmp()
             ::dbfFacCliP:nNumRec    := 1
             ::dbfFacCliP:cCodCli    := ::dbfClient:Cod
             ::dbfFacCliP:cCodCaj    := oUser():cCaja()
             ::dbfFacCliP:nImporte   := val( substr( cCabecera, 251, 8 ) )
             ::dbfFacCliP:cDescrip   := "Recibo Nº1 de factura " + ::dbfFacCliP:cSerie  + '/' + allTrim( Str( ::dbfFacCliP:nNumFac ) ) + '/' + ::dbfFacCliP:cSufFac
             ::dbfFacCliP:cDivPgo    := cDivEmp()
             ::dbfFacCliP:nVdvPgo    := nChgDiv( ::dbfFacCliT:cDivFac, ::dbfDiv:nArea )
             ::dbfFacCliP:lCobrado   := .t.
             ::dbfFacCliP:cTurRec    := cCurSesion()
             ::dbfFacCliP:dPreCob    := dFecha
             ::dbfFacCliP:dEntrada   := dFecha
             ::dbfFacCliP:Save()

             //segunda forma de pago

             if substr( cCabecera, 60, 1 ) != "4" .and. val( substr( cCabecera, 251, 8 ) ) != val( substr( cCabecera, 243, 8 ) )

               ::dbfFacCliP:Append()
               ::dbfFacCliP:cSerie     := ::dbfClient:Serie
               ::dbfFacCliP:nNumFac    := nNumFac
               ::dbfFacCliP:cSufFac    := RetSufEmp()
               ::dbfFacCliP:nNumRec    := 2
               ::dbfFacCliP:cCodCli    := ::dbfClient :Cod
               ::dbfFacCliP:cCodCaj    := oUser():cCaja()
               ::dbfFacCliP:nImporte   := val( substr( cCabecera, 243, 8 ) ) - val( substr( cCabecera, 251, 8 ) )
               ::dbfFacCliP:cDescrip   := "Recibo Nº2 de factura " + ::dbfFacCliP:cSerie  + '/' + allTrim( Str( ::dbfFacCliP:nNumFac ) ) + '/' + ::dbfFacCliP:cSufFac
               ::dbfFacCliP:cDivPgo    := cDivEmp()
               ::dbfFacCliP:nVdvPgo    := nChgDiv( ::dbfFacCliT:cDivFac, ::dbfDiv:nArea )
               ::dbfFacCliP:lCobrado   := .t.
               ::dbfFacCliP:cTurRec    := cCurSesion()
               ::dbfFacCliP:dPreCob    := dFecha
               ::dbfFacCliP:dEntrada   := dFecha
               ::dbfFacCliP:Save()

            end if

          // el primero es pendiente y este es un pago
          elseif substr( cCabecera, 260, 1 ) != "4" .and. val( substr( cCabecera, 251, 8 ) ) != val( substr( cCabecera, 243, 8 ) )

               ::dbfFacCliP:Append()
               ::dbfFacCliP:cSerie     := ::dbfClient:Serie
               ::dbfFacCliP:nNumFac    := nNumFac
               ::dbfFacCliP:cSufFac    := RetSufEmp()
               ::dbfFacCliP:nNumRec    := 1
               ::dbfFacCliP:cCodCli    := ::dbfClient:Cod
               ::dbfFacCliP:cCodCaj    := oUser():cCaja()
               ::dbfFacCliP:nImporte   := val( substr( cCabecera, 243, 8 ) ) - val( substr( cCabecera, 251, 8 ) )
               ::dbfFacCliP:cDescrip   := "Recibo Nº1 de factura " + ::dbfFacCliP:cSerie  + '/' + allTrim( Str( ::dbfFacCliP:nNumFac ) ) + '/' + ::dbfFacCliP:cSufFac
               ::dbfFacCliP:cDivPgo    := cDivEmp()
               ::dbfFacCliP:nVdvPgo    := nChgDiv( ::dbfFacCliT:cDivFac, ::dbfDiv:nArea )
               ::dbfFacCliP:lCobrado   := .t.
               ::dbfFacCliP:cTurRec    := cCurSesion()
               ::dbfFacCliP:dPreCob    := dFecha
               ::dbfFacCliP:dEntrada   := dFecha
               ::dbfFacCliP:Save()

          end if  //cierra el if de los pagos

          //cargamos las lineas del pedido

         oFileLinea:GoTop()
         cLinea            := oFileLinea:cLine

         while ! oFileLinea:lEoF()

            //Capturamos las lineas de detalle
            if( substr( cLinea, 11, 1 ) == "1" .and. substr( cCabecera, 11, 10 ) == substr( cLinea, 1, 10 ) )

               ::dbfFacCliL:Append()
               ::dbfFacCliL:cSerie := ::dbfFacCliT:cSerie                           // serie del pedido
               ::dbfFacCliL:nNumFac := ::dbfFacCliT:nNumFac                         // numero del pedido
               ::dbfFacCliL:cSufFac := ::dbfFacCliT:cSufFac                         // sufijo del pedido
               ::dbfFacCliL:cRef    := UPPER( truncarCadenaIzq( cLinea, 12, 18 ) )     // referencia del articulo
               ::dbfFacCliL:cDetalle:= RetFld( ::dbfFacCliL:cRef, ::dbfArticulo:nArea )// nombre del articulo
               if !lExentoIva
                  ::dbfFacCliL:nIva := nCodigoAsociadoIva( SubStr( cLinea, 76, 1 ) )
               else
                  ::dbfFacCliL:nIva := 0
               end if
               ::dbfFacCliL:nCanEnt := Val( SubStr( cLinea, 54, 7 ) )
               ::dbfFacCliL:nUniCaja:= Val( SubStr( cLinea, 61, 7 ) )
               ::dbfFacCliL:nPreUnit:= Val( SubStr( cLinea, 30, 7 ) )
               ::dbfFacCliL:nDtoDiv := Val( SubStr( cLinea, 37, 7 ) )
               ::dbfFacCliL:nDto    := Val( SubStr( cLinea, 44, 5 ) )
               ::dbfFacCliL:nDtoPrm := Val( SubStr( cLinea, 49, 5 ) )
               ::dbfFacCliL:lLote   := lLote

               if lLote

                  oFileLote:GoTop()
                  cLote                := oFileLote:cLine

                  while !oFileLote:lEof()

                     if substr(cLinea, 1, 10 ) = substr( cLote, 1, 10 ) .and. substr(cLinea, 12, 18 ) = substr( cLote, 12, 18 )

                        ::dbfFacCliL:cLote   := Substr( cLote, 30, 20 )

                     end if

                     oFileLote:Skip()
                     cLote             := oFileLote:ReadLine()

                  end do

               end if

               ::dbfFacCliL:Save()

            end if

            //Prelectura de la siguiente linea

            oFileLinea:Skip()
            cLinea    := oFileLinea:ReadLine()

         end do

      end if    // cierra el if que entra en la cabecera

      // Comprobamos que la factura esta liquidada

      ChkLqdFacCli( nil, ::dbfFacCliT:cAlias, ::dbfFacCliL:cAlias, ::dbfFacCliP:cAlias, ::dbfAntCliT:cAlias, ::dbftiva:cAlias, ::dbfDiv:cAlias )

      //preparamos la siguiente linea de cabecera
      oFileCabecera:Skip()
      cCabecera    := oFileCabecera:ReadLine()

      ::SetTexto( "Añadid factura " + ::dbfFacCliT:cSerie + "/" + str( ::dbfFacCliT:nNumFac ) + " para " + ::dbfClient:Titulo, 41 )

   end do

   ::oMedidor:SetTotal( oFileCabecera:LastRec() )
   ::SetTexto( "Fin de importación de facturas.", 3 )

   oFileCabecera:Close()
   oFileLinea:Close()

   if file( cFileLote )

      oFileLote:Close()

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//
//
// Funcion para importar los pagos pendientes realizados
//
//  Opciones pendientes:
//   Permitir el cobro de notas creadas en movilges
//

Method MovilgesImportarPago( cCodAgente )

   local nLinea
   local nImporte
   local lCobrado
   local cLinea
   local CFileLinea
   local dFecha
   local oFilelinea

   cFileLinea        := ::cDirectorio + "COB" + ::cCodEmp + cCodAgente + ".DES"

   //Creamos el fichero destino

   if !file( cFileLinea )
      ::SetTexto( "No existe el fichero " + cFileLinea, 3 )
      return nil
   end if

   oFileLinea        := TTxtFile():New( cFileLinea )

   ::dbfFacCliP:GoTop()

   cLinea            := oFileLinea:cLine

   ::SetTexto( , 40 )
   ::oMedidor:Set( 0 )
   ::oMedidor:cText     := "Importando recibos cobrados"
   ::oMedidor:SetTotal( oFileLinea:LastRec() )

   WHILE ! oFileLinea:lEoF()

      ::oMedidor:Set( oFileLinea:nRecNo() )
      ::dbfClient:Seek( substr( cLinea, 1, 10 ) )
      dFecha         := dTruncarFecha( substr( cLinea, 60, 10 ) )
      nLinea         := 1
      lCobrado       := .F.
      nImporte       := val( substr( cLinea, 52, 8 ) )

      // actualizar los recibos existentes

      while ::dbfFacCliP:seek( substr( cLinea, 11, 10 ) + RetSufEmp() + str( nLinea, 2, 0 ) ) .and. !lCobrado

         if !::dbfFacCliP:lCobrado

            if nImporte == ::dbfFacCliP:nImporte

               ::dbfFacCliP:Load()
               ::dbfFacCliP:lCobrado   := .t.
               ::dbfFacCliP:dEntrada   := dTruncarFecha( substr( cLinea, 32, 10 ) )
               ::dbfFacCliP:Save()

               lCobrado                := .T.
               ::dbfFacCliT:Seek( substr( cLinea, 11, 10 ) )
               ChkLqdFacCli( nil, ::dbfFacCliT:cAlias, ::dbfFacCliL:cAlias, ::dbfFacCliP:cAlias, ::dbfAntCliT:cAlias, ::dbfTiva:cAlias, ::dbfDiv:cAlias )

               ::SetTexto( "Añadido recibo " + substr( cLinea, 11, 10 ) + RetSufEmp() + str( nLinea, 2, 0 ), 41 )
            /*
            elseif nImporte < ::dbfFacCliP :nImporte

               ::dbfFacCliP :nImporte   := ::dbfFacCliP :nImporte - nImporte
               lCobrado                   := .T.

            else

               nImporte                   := nImporte - ::dbfFacCliP :nImporte
               ::dbfFacCliP :lCobrado   := .t.  */

            end if

         end if

         nLinea++

      end do
      // anotar dinero pendiente

      if ! lCobrado

         ::SetTexto( "Recibo no encontrado: " + substr( cLinea, 11, 10 ) + RetSufEmp() + str( nLinea, 2, 0 ), 42 )
         /*
         ::dbfFacCliP :( dbAppend() )
         ::dbfFacCliP :cSerie     := substr( cLinea, 11, 1 )
         ::dbfFacCliP :nNumFac    := val( substr( cLinea, 12, 9 ) )
         ::dbfFacCliP :cSufFac    := RetSufEmp()
         ::dbfFacCliP :cCodCli    := ::dbfClient :Cod
         ::dbfFacCliP :cCodCaj    := oUser():cCaja()
         ::dbfFacCliP :nImporte   := val( substr( cLinea, 52, 8 ) )
         ::dbfFacCliP :cDescrip   := "Factura pagada por el PDA " + ::dbfFacCliP :cSerie  + '/' + allTrim( Str( ::dbfFacCliP :nNumFac ) ) + '/' + ::dbfFacCliP :cSufFac
         ::dbfFacCliP :cDivPgo    := cDivEmp()
         ::dbfFacCliP :nVdvPgo    := nChgDiv( ::dbfFacCliT :cDivFac, dbfDiv )
         ::dbfFacCliP :lCobrado   := .t.
         ::dbfFacCliP :cTurRec    := cCurSesion()
         ::dbfFacCliP :dPreCob    := dTruncarFecha( substr( cLinea, 60, 10 ) )
         ::dbfFacCliP :dEntrada   := dFecha
         ::dbfFacCliP :( dbUnLock() )   */

      end if

      oFileLinea:Skip()
      cLinea                        := oFileLinea:ReadLine()

   END DO

   ::oMedidor:SetTotal( oFileLinea:LastRec() )
   ::SetTexto( "Fin de importación de facturas.", 3 )
   oFileLinea:Close()

RETURN ( Self )

//---------------------------------------------------------------------------//
//
// Indica si todos los caracteres de una cadena son numeros
//

function lEsNumerico( cNumero )

   local lNumero := .t.
   local nInicio := 1
   local nFin    := len( cNumero )
   local cChar

   while lNumero .and. nInicio <= nFin

      cChar := substr( cNumero, nInicio, 1 )

      if asc( cChar ) > 57 .or. asc( cChar ) < 48

         lNumero := .f.

      end if

      nInicio++

   end do

return lNumero

//---------------------------------------------------------------------------//
//
//  Para guardar una linea en el log
//

Method LogEscribir( cTexto )

   local nLenTexto   := Len( cTexto + CRLF )

   if ::lLog

      if fWrite( ::fLog, cTexto + CRLF, nLenTexto ) < nLenTexto

         fClose( ::fLog )
         msgStop( "Imposible escribir en el fichero de log, error " + Str( fError() ) )
         ::lLog   := .f.

      end if

   end if

Return ( Self )

//---------------------------------------------------------------------------//
//
// inserta un mensaje en el arbol y lo guarda en el log
//

Method SetTexto( cTexto, nLevel )

   do case

      case nLevel == 1           //ejemplo: iniciando proceso
         ::oSubItem := ::oTree:Add( cTexto, 1 )
         ::LogEscribir( cTexto )

      case nLevel == 2           //ejemplo: importando albaranes
         ::oSubItem2 := ::oSubItem:Add( cTexto, 1 )
         ::oSubItem:Expand()
         ::LogEscribir( space(3) + cTexto )

      case nLevel == 3           //ejemplo: archivo no encontrado
         ::oSubItem3 := ::oSubItem2:Add( cTexto, 1 )
         ::LogEscribir( space( 6 ) + cTexto )

      case nLevel == 40          //montar sistema error/resultado
         ::oSubItemError      := ::oSubItem2:Add( "Errores", 1 )
         ::oSubItemResultado  := ::oSubItem2:Add( "Resultados", 1 )
         ::oSubItem2:Expand()
         ::oTree:Select( ::oSubItemResultado )

      case nLevel == 41          //resultados
         ::LogEscribir( Space( 9 ) + cTexto )
         ::oSubItem3 := ::oSubItemResultado:Add( cTexto, 1 )

      case nLevel == 42          //errores
         ::LogEscribir( Space( 9 ) + cTexto )
         ::oSubItem3 := ::oSubItemError:Add( cTexto, 1 )

   end case

return nil

//---------------------------------------------------------------------------//
//
// funcion para imprimir un fichero de texto
//

Function ImprimirFichero( cFile )

   LOCAL oFont

   if !file( cFile )
      msgStop( "El fichero " + cFile + " no existe." )
      return .f.
   end if

   DEFINE FONT oFont NAME "Courier New" SIZE 0, -12

   REPORT oReport ;
      FONT     oFont ;
      CAPTION  "Imprimir fichero" ;
      PREVIEW

      COLUMN DATA " " SIZE 76  // * Trick "Data" - we're fooling Mother

   END REPORT

   oReport:nTitleUpLine := RPT_NOLINE //cabecera
   oReport:nTitleDnLine := RPT_NOLINE //pie de pagina

   ACTIVATE REPORT oReport ON INIT SayMemo( cFile )

   oFont:End()

RETURN NIL

//---------------------------------------------------------------------------//

STATIC Function SayMemo( cFile)

   LOCAL cText, cLine
   LOCAL nFor, nLines, nPageln

   cText    := Memoread( cFile )

   nLines   := MlCount( cText, 76 ) //caracteres por linea
   nPageln  := 0

   FOR nFor := 1 TO nLines

        cLine := MemoLine( cText, 76, nFor )

        oReport:StartLine()
        oReport:Say(1,cLine)
        oReport:EndLine()

        nPageln := nPageln + 1
        IF nPageln = 60
           nFor := GetTop(cText,nFor,nLines)
           nPageln := 0
        ENDIF

   NEXT

RETURN NIL

//---------------------------------------------------------------------------//

STATIC FUNCTION GetTop(cText,nFor,nLines)

   local lTest := .t., cLine

   while lTest .and. nFor <= nLines
      nFor++
      cLine := MemoLine( cText, 76, nFor )
      lTest := Empty( cLine )
   enddo

   nFor--
   SysRefresh()

RETURN nFor

//---------------------------------------------------------------------------//
//
//  Exportar fichero de tipos de pago para Movilgest (PDA)
//

Method ExportarFPagos()

   local cChr        //Una linea completa del fichero
   local fPda        //descriptor del fichero
   local cFilePda    //almacena el nombre del fichero para el pda

   cFilePda          := ::cDirectorio + "FPG" + ::cCodEmp + ".CFG"

   //Creamos el fichero destino y si existe lo borramos

   BEGIN SEQUENCE

      IF file( cFilePda )
         fErase( cFilePda )
      END IF

   RECOVER

      ::SetTexto( "No se ha podido borrar el fichero " + cFilePda, 3 )
      RETURN NIL

   END SEQUENCE

   BEGIN SEQUENCE

      fPda     := fCreate( cFilePda )

   RECOVER

      ::SetTexto( "No se ha podido crear el fichero "+cFilePda, 3 )
      RETURN NIL

   END SEQUENCE

   ::SetTexto( , 40 )
   ::oMedidor:Set( 0 )
   ::oMedidor:cText     := "Exportando Formas de Pago"
   ::oMedidor:SetTotal( ::dbfFPago:LastRec() )
   ::dbfFPago:GoTop()

   WHILE !::dbfFPago:eof()

      ::oMedidor:Set( ::dbfFPago:OrdKeyNo() )

      if len( AllTrim( ::dbfFPago:cCodPago ) ) != 1

         ::SetTexto( "La forma de pago " + AllTrim( ::dbfFPago:cDesPago ) + " (" + AllTrim( ::dbfFPago:cCodPago ) + ") tiene un código superior a un carácter.", 42 )

      else

         cChr  := ""

         cChr  += AllTrim( ::dbfFPago:cCodPago )                        // codigo (solo 1 caracter)
         cChr  += truncarCadenaIzq( ::dbfFPago:CDesPago, 1, 15 )        // descripcion

         if ::dbfFPago:nCobRec == 1                                     // cobrado o sin cobrar

            cChr  += "N1"

         else

            cChr  += "S4"

         end if

         cChr  += CRLF                                                   //fin de linea

         ::nRead   := Len( cChr )

         if fwrite( fPda, cChr, ::nRead ) < ::nRead

            ::SetTexto( "El fichero de formas de pago no se ha creado correctamente. ( error " + str( fError() ) + " )", 42 )
            RETURN NIL

         END IF

         ::SetTexto( "Añadida la forma de pago " + rTrim( ::dbfFPago:cDesPago ), 41 )

      end if

      ::dbfFPago:Skip()

   END DO

   ::oMedidor:Set( ::dbfClient:LastRec() )
   ::SetTexto( "Fin de Exportación de Formas de pago", 3 )

   fClose( fPda )

Return ( Self )

//---------------------------------------------------------------------------//

Method CargarPreferencias()

   local oIniApp
   local cIniApp  := cIniEmpresa()

   INI oIniApp FILE cIniApp

      GET ::oDirectorio:cText       SECTION  "Movilges" ENTRY "Destino" OF oIniApp DEFAULT PadR( cPatSnd(), 100 )

   ENDINI

return ( Self )

//---------------------------------------------------------------------------//

Method GuardarPreferencias()

   local oIniApp
   local cIniApp  := cIniEmpresa()

   INI oIniApp FILE cIniApp
      SET SECTION  "Movilges" ENTRY "Destino" TO ::oDirectorio:cText       OF oIniApp
   ENDINI

return ( Self )

//---------------------------------------------------------------------------//