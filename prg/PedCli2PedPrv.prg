#include "FiveWin.Ch"
#include "Report.ch"
#include "Xbrowse.ch"
#include "MesDbf.ch"
#include "Factu.ch" 
#include "FastRepH.ch"

//---------------------------------------------------------------------------//
    
CLASS PedCliente2PedProveedor

   DATA oDlg
   DATA oPag
   DATA oBmp 
   DATA oBrw

   DATA oBtnPrev
   DATA oBtnNext

   DATA nStockDisponible   INIT 4
   DATA nStockFin          INIT 3

   DATA oPeriodo
   DATA cPeriodo           INIT "Todos"
   
   DATA oFecIni
   DATA oFecFin

   DATA dFecIni
   DATA dFecFin

   DATA nView

   DATA oMtr
   DATA nMtr

   DATA dbfTemporal

   Method New( nView )   CONSTRUCTOR

   Method Resource()

   Method Prev()

   Method Next()

   Method CreateLines()

   Method DestroyLines()

   Method aCreaArrayPeriodos()

   Method lRecargaFecha()

   Method StartDialog()

   Method LoadLineasPedidos()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS PedCliente2PedProveedor

   ::nView              := nView

   ::nStockDisponible   := 4
   ::nStockFin          := 3

   if ::CreateLines()
      ::Resource()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

Method CreateLines() CLASS PedCliente2PedProveedor

   local oError
   local oBlock
   local cTmpLin
   local cTmpFin
   local lErrors  := .f.

   CursorWait()

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
   
   cTmpLin        := cGetNewFileName( cPatTmp() + "PTmpCliL" )
   cTmpFin        := cGetNewFileName( cPatTmp() + "PTmpFinL" )

   dbCreate( cTmpLin, aSqlStruct( aColTmpLin() ), cLocalDriver() )

   dbUseArea( .t., cLocalDriver(), cTmpLin, cCheckArea( "PTmpCliL", @::dbfTemporal ), .f. )

   if !NetErr()
      ( ::dbfTemporal )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( ::dbfTemporal )->( ordCreate( cTmpLin, "nNumLin", "Str( nNumLin, 4 )", {|| Str( Field->nNumLin, 4 ) } ) )

      ( ::dbfTemporal )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( ::dbfTemporal )->( ordCreate( cTmpLin, "cRef", "cRef", {|| Field->cRef } ) )

      ( ::dbfTemporal )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( ::dbfTemporal )->( ordCreate( cTmpLin, "lShow", "lShow", {|| Field->lShow } ) )

      ( ::dbfTemporal )->( ordCondSet( "lShow .and. lSelArt .and. !Deleted()", {|| Field->lShow .and. Field->lSelArt .and. !Deleted() }  ) )
      ( ::dbfTemporal )->( ordCreate( cTmpLin, "cCodPrv", "cCodPrv", {|| Field->cCodPrv } ) )
   else
      lErrors     := .t.
   end if

   RECOVER USING oError

      lErrors                             := .t.

      msgStop( "Imposible crear las bases de datos temporales" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CursorWE()

Return ( !lErrors )

//---------------------------------------------------------------------------//

Method DestroyLines() CLASS PedCliente2PedProveedor

   /*
   Cerramos los ficheros-------------------------------------------------------
   */

   if !Empty( ::dbfTemporal ) .and. ( ::dbfTemporal )->( Used() )
      ( ::dbfTemporal )->( dbCloseArea() )
   end if

   /*
   Eliminamos los temporales---------------------------------------------------
   */

   dbfErase( ::dbfTemporal )

   ::oDlg:end()

Return .t.

//---------------------------------------------------------------------------//

METHOD Resource() CLASS PedCliente2PedProveedor

   DEFINE DIALOG ::oDlg RESOURCE "PEDCLI2PEDPROV"

      REDEFINE BITMAP ::oBmp ;
         RESOURCE "shopping_bag_48" ;
         ID       600 ;
         TRANSPARENT ;
         OF       ::oDlg

      REDEFINE PAGES ::oPag ;
         ID       100 ;
         OF       ::oDlg ;
         DIALOGS  "PEDCLI2PEDPROV_1",; 
                  "PEDCLI2PEDPROV_2",;
                  "PEDCLI2PEDPROV_3"

      /*
      Primera Caja de diálogo--------------------------------------------------
      */

      REDEFINE COMBOBOX ::oPeriodo ;
         VAR         ::cPeriodo ;
         ID          100 ;
         ITEMS       ::aCreaArrayPeriodos() ;
         OF          ::oPag:aDialogs[1]

         ::oPeriodo:bCHange   := {|| ::lRecargaFecha() }

      REDEFINE GET ::oFecIni VAR ::dFecIni;
         ID          110 ;
         SPINNER ;
         OF          ::oPag:aDialogs[1]

      REDEFINE GET ::oFecFin VAR ::dFecFin;
         ID          120 ;
         SPINNER ;
         OF          ::oPag:aDialogs[1]












      REDEFINE RADIO ::nStockDisponible ;
         ID       201, 202, 203, 204 ;
         OF       ::oPag:aDialogs[1]

      REDEFINE RADIO ::nStockFin ;
         ID       212, 213, 214 ;
         OF       ::oPag:aDialogs[1]

      REDEFINE APOLOMETER ::oMtr VAR ::nMtr ;
         PROMPT   "Procesando" ;
         ID       220 ;
         TOTAL    ( ::dbfTemporal )->( LastRec() ) ;
         OF       ::oPag:aDialogs[1]

      /*
      Segunda Caja de diálogo--------------------------------------------------
      */

      ::oBrw               := IXBrowse():New( ::oPag:aDialogs[2] )

      ::oBrw:bClrSel       := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrw:bClrSelFocus  := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrw:cAlias        := ::dbfTemporal

      ::oBrw:nMarqueeStyle := 5
      ::oBrw:cName         := "Pedido de cliente.Generar"

      ::oBrw:CreateFromResource( 100 )

      with object ( ::oBrw:AddCol() )
         :cHeader          := "Se. Seleccionado"
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( ::dbfTemporal )->lSelArt }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Cnt16" } )
      end with

      with object ( ::oBrw:AddCol() )
         :cHeader          := "Proveedor"
         :bEditValue       := {|| AllTrim( ( ::dbfTemporal )->cCodPrv ) + " - " + AllTrim( RetProvee( ( ::dbfTemporal )->cCodPrv ) ) }
         :nWidth           := 200
      end with

      with object ( ::oBrw:AddCol() )
         :cHeader          := "Código"
         :bEditValue       := {|| ( ::dbfTemporal )->cRef }
         :nWidth           := 70
      end with

      with object ( ::oBrw:AddCol() )
         :cHeader          := "Nombre"
         :bEditValue       := {|| if( !Empty( ( ::dbfTemporal )->cRef ), ( ::dbfTemporal )->cDetalle, ( ::dbfTemporal )->mLngDes ) }
         :nWidth           := 155
      end with

      with object ( ::oBrw:AddCol() )
         :cHeader          := "Propiedad 1"
         :bEditValue       := {|| ( ::dbfTemporal )->cValPr1 }
         :nWidth           := 80
         :lHide            := .t.
      end with

      with object ( ::oBrw:AddCol() )
         :cHeader          := "Propiedad 2"
         :bEditValue       := {|| ( ::dbfTemporal )->cValPr2 }
         :nWidth           := 80
         :lHide            := .t.
      end with

      with object ( ::oBrw:AddCol() )
         :cHeader          := cNombreCajas()
         :bEditValue       := {|| ( ::dbfTemporal )->nNumCaj }
         :cEditPicture     := MasUnd()
         :nWidth           := 50
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( ::oBrw:AddCol() )
         :cHeader          := cNombreUnidades()
         :bEditValue       := {|| ( ::dbfTemporal )->nNumUni }
         :cEditPicture     := MasUnd()
         :nWidth           := 60
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( ::oBrw:AddCol() )
         :cHeader          := "Stk. físico"
         :bEditValue       := {|| ( ::dbfTemporal )->nStkFis }
         :cEditPicture     := MasUnd()
         :nWidth           := 60
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( ::oBrw:AddCol() )
         :cHeader          := "Stk. disponible"
         :bEditValue       := {|| ( ::dbfTemporal )->nStkDis }
         :cEditPicture     := MasUnd()
         :nWidth           := 90
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      REDEFINE BUTTON ;
         ID       110;
         OF       ::oPag:aDialogs[2] ;
         ACTION   ( MsgInfo( "Edita linea" ) )

      REDEFINE BUTTON ;
         ID       120;
         OF       ::oPag:aDialogs[2] ;
         ACTION   ( MsgInfo( "Selecciona" ) )

      REDEFINE BUTTON ;
         ID       130;
         OF       ::oPag:aDialogs[2] ;
         ACTION   ( MsgInfo( "Selecciona todo" ) )

      REDEFINE BUTTON ;
         ID       140;
         OF       ::oPag:aDialogs[2] ;
         ACTION   ( MsgInfo( "deselecciona todo" ) )

      /*
      Tercera caja de diálogo--------------------------------------------------
      */

      /*::oBrwFin                  := IXBrowse():New( ::oPag:aDialogs[3] )

      ::oBrwFin:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwFin:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrwFin:cAlias           := dbfTmpFin

      ::oBrwFin:nMarqueeStyle    := 5

      ::oBrwFin:bLDblClick       := {|| ZooPedPrv( ( dbfTmpFin )->cSerie + Str( ( dbfTmpFin )->nNumero ) + ( dbfTmpFin )->cSufijo ) }

      ::oBrwFin:CreateFromResource( 100 )

      with object ( ::oBrwFin:AddCol() )
         :cHeader                := "Documento"
         :bEditValue             := {|| AllTrim( ( dbfTmpFin )->cSerie ) + "/" + AllTrim( Str( ( dbfTmpFin )->nNumero ) ) + "/" + AllTrim( ( dbfTmpFin )->cSufijo ) }
         :nWidth                 := 80
      end with

      with object ( ::oBrwFin:AddCol() )
         :cHeader                := "Fecha"
         :bEditValue             := {|| dtoc( ( dbfTmpFin )->dFecDoc ) }
         :nWidth                 := 80
      end with

      with object ( ::oBrwFin:AddCol() )
         :cHeader                := "Proveedor"
         :bEditValue             := {|| AllTrim( ( dbfTmpFin )->cCodPrv ) + " - " + AllTrim( ( dbfTmpFin )->cNomPrv ) }
         :nWidth                 := 250
      end with

      with object ( ::oBrwFin:AddCol() )
         :cHeader                := "Total"
         :bEditValue             := {|| nTotPedPrv( ( dbfTmpFin )->cSerie + Str( ( dbfTmpFin )->nNumero ) + ( dbfTmpFin )->cSufijo, D():PedidosProveedores( nView ), D():PedidosProveedoresLineas( nView ), D():TiposIva( nView ), dbfDiv, nil, cDivEmp(), .t. ) }
         :nWidth                 := 80
         :nDataStrAlign          := 1
         :nHeadStrAlign          := 1
      end with*/

      REDEFINE BUTTON ;
         ID       110;
         OF       ::oPag:aDialogs[3] ;
         ACTION   ( MsgInfo( "Mod" ) )

      REDEFINE BUTTON ;
         ID       120;
         OF       ::oPag:aDialogs[3] ;
         ACTION   ( MsgInfo( "Zoo" ) )

      REDEFINE BUTTON ;
         ID       140;
         OF       ::oPag:aDialogs[3] ;
         ACTION   ( MsgInfo( "Vis" ) )

      REDEFINE BUTTON ;
         ID       150;
         OF       ::oPag:aDialogs[3] ;
         ACTION   ( MsgInfo( "Imp" ) )

      REDEFINE BUTTON ::oBtnPrev ;
         ID       500 ;
         OF       ::oDlg;
         ACTION   ( ::Prev() )

      REDEFINE BUTTON ::oBtnNext ;
         ID       501 ;
         OF       ::oDlg;
         ACTION   ( ::Next() )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       ::oDlg ;
         ACTION   ( ::DestroyLines() )

      ::oDlg:bStart  := {|| ::StartDialog() }

   ACTIVATE DIALOG ::oDlg CENTER

   if !Empty( ::oBmp )
      ::oBmp:End()
   end if

Return ( ::oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Method Prev() CLASS PedCliente2PedProveedor

   do case
   case ::oPag:nOption == 2

      ::oPag:GoPrev()

      SetWindowText( ::oBtnNext:hWnd, "Siguien&te >" )

      ::oBtnPrev:Hide()

   case ::oPag:nOption == 3

      ::DestroyLines()

   end case

Return ( .t. )

//---------------------------------------------------------------------------//

Method Next() CLASS PedCliente2PedProveedor

   do case
      case ::oPag:nOption == 1

         ::LoadLineasPedidos()

         ::oPag:GoNext()

         ::oBtnPrev:Show()

         SetWindowText( ::oBtnNext:hWnd, "&Procesar" )

      case ::oPag:nOption == 2

         ::oPag:GoNext()

         SetWindowText( ::oBtnPrev:hWnd, "Terminar e &imprimir" )

         SetWindowText( ::oBtnNext:hWnd, "&Terminar" )

      case ::oPag:nOption == 3

         ::DestroyLines()

   end case

Return .t.

//---------------------------------------------------------------------------//

METHOD StartDialog() CLASS PedCliente2PedProveedor

   ::oBtnPrev:Hide()

   ::oBrw:LoadData()

   ::lRecargaFecha()

Return .t.

//---------------------------------------------------------------------------//

METHOD aCreaArrayPeriodos() CLASS PedCliente2PedProveedor

   local aPeriodo := {}

   aAdd( aPeriodo, "Hoy" )

   aAdd( aPeriodo, "Ayer" )

   aAdd( aPeriodo, "Mes en curso" )

   aAdd( aPeriodo, "Mes anterior" )

   do case
      case Month( GetSysDate() ) <= 3
         aAdd( aPeriodo, "Primer trimestre" )

      case Month( GetSysDate() ) > 3 .and. Month( GetSysDate() ) <= 6
         aAdd( aPeriodo, "Primer trimestre" )
         aAdd( aPeriodo, "Segundo trimestre" )

      case Month( GetSysDate() ) > 6 .and. Month( GetSysDate() ) <= 9
         aAdd( aPeriodo, "Primer trimestre" )
         aAdd( aPeriodo, "Segundo trimestre" )
         aAdd( aPeriodo, "Tercer trimestre" )

      case Month( GetSysDate() ) > 9 .and. Month( GetSysDate() ) <= 12
         aAdd( aPeriodo, "Primer trimestre" )
         aAdd( aPeriodo, "Segundo trimestre" )
         aAdd( aPeriodo, "Tercer trimestre" )
         aAdd( aPeriodo, "Cuatro trimestre" )

   end case

   aAdd( aPeriodo, "Doce últimos meses" )

   aAdd( aPeriodo, "Año en curso" )

   aAdd( aPeriodo, "Año anterior" )

   aAdd( aPeriodo, "Todos" )

Return ( aPeriodo )

//---------------------------------------------------------------------------//

METHOD lRecargaFecha() CLASS PedCliente2PedProveedor

   do case
      case ::cPeriodo == "Hoy"

         ::oFecIni:cText( GetSysDate() )
         ::oFecFin:cText( GetSysDate() )

      case ::cPeriodo == "Ayer"

         ::oFecIni:cText( GetSysDate() -1 )
         ::oFecFin:cText( GetSysDate() -1 )

      case ::cPeriodo == "Mes en curso"

         ::oFecIni:cText( CtoD( "01/" + Str( Month( GetSysDate() ) ) + "/" + Str( Year( GetSysDate() ) ) ) )
         ::oFecFin:cText( GetSysDate() )

      case ::cPeriodo == "Mes anterior"

         ::oFecIni:cText( BoM( AddMonth( GetSysDate(), -1 ) ) )
         ::oFecFin:cText( EoM( AddMonth( GetSysDate(), -1 ) ) )

      case ::cPeriodo == "Primer trimestre"
         
         ::oFecIni:cText( CtoD( "01/01/" + Str( Year( GetSysDate() ) ) ) )
         ::oFecFin:cText( CtoD( "31/03/" + Str( Year( GetSysDate() ) ) ) )

      case ::cPeriodo == "Segundo trimestre"

         ::oFecIni:cText( CtoD( "01/04/" + Str( Year( GetSysDate() ) ) ) )
         ::oFecFin:cText( CtoD( "30/06/" + Str( Year( GetSysDate() ) ) ) )

      case ::cPeriodo == "Tercer trimestre"

         ::oFecIni:cText( CtoD( "01/07/" + Str( Year( GetSysDate() ) ) ) )
         ::oFecFin:cText( CtoD( "30/09/" + Str( Year( GetSysDate() ) ) ) )

      case ::cPeriodo == "Cuatro trimestre"

         ::oFecIni:cText( CtoD( "01/10/" + Str( Year( GetSysDate() ) ) ) )
         ::oFecFin:cText( CtoD( "31/12/" + Str( Year( GetSysDate() ) ) ) )

      case ::cPeriodo == "Doce últimos meses"

         ::oFecIni:cText( CtoD( Str( Day( GetSysDate() ) ) + "/" + Str( Month( GetSysDate() ) ) + "/" + Str( Year( GetSysDate() ) -1 ) ) )
         ::oFecFin:cText( GetSysDate() )

      case ::cPeriodo == "Año en curso"

         ::oFecIni:cText( CtoD( "01/01/" + Str( Year( GetSysDate() ) ) ) )
         ::oFecFin:cText( CtoD( "31/12/" + Str( Year( GetSysDate() ) ) ) )

      case ::cPeriodo == "Año anterior"

         ::oFecIni:cText( CtoD( "01/01/" + Str( Year( GetSysDate() ) - 1 ) ) )
         ::oFecFin:cText( CtoD( "31/12/" + Str( Year( GetSysDate() ) - 1 ) ) )
      
      case ::cPeriodo == "Todos"

         ::oFecIni:cText( CtoD( "01/01/2000" ) ) 
         ::oFecFin:cText( CtoD( "31/12/3000" ) )

   end case

   ::oFecIni:Refresh()
   ::oFecFin:Refresh()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD LoadLineasPedidos() CLASS PedCliente2PedProveedor

   MsgInfo( "Cargamos las lineas de pedidos" )

   MsgInfo( ::dFecIni, "Fecha inicio" )
   MsgInfo( ::dFecFin, "Fecha fin" )

Return .t.

//---------------------------------------------------------------------------//

/*function aColTmpLin()

   local aColTmpLin  := {}

   aAdd( aColTmpLin, { "cRef",    "C",   18,  0, "Referencia del artículo",         "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "cDetalle","C",  250,  0, "Nombre del artículo",             "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "mLngDes", "M",   10,  0, "Descripciones largas",            "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "lSelArt", "L",    1,  0, "Lógico de selección de artículo", "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "cCodPrv", "C",   12,  0, "Código de proveedor",             "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "cCodPr1", "C",   20,  0, "Código propiedad 1",              "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "cCodPr2", "C",   20,  0, "Código propiedad 2",              "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "cValPr1", "C",   40,  0, "Valor propiedad 1",               "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "cValPr2", "C",   40,  0, "Valor propiedad 2",               "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nNumUni", "N",   16,  6, "Unidades pedidas",                "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nNumCaj", "N",   16,  6, "Cajas pedidas",                   "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nStkFis", "N",   16,  6, "Stock fisico",                    "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nStkDis", "N",   16,  6, "Stock disponible",                "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "lShow",   "L",    1,  0, "Lógico de mostrar",               "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nIva",    "N",    6,  2, "Porcentaje de " + cImp(),         "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nReq",    "N",    6,  2, "Porcentaje de recargo",           "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nPreDiv", "N",   16,  6, "Precio del artículo",             "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nDto",    "N",    6,  2, "Descuento del producto",          "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nDtoPrm", "N",    6,  2, "Descuento de promoción",          "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "cUnidad", "C",    2,  0, "Unidad de medición",              "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "lLote",   "L",    1,  0, "",                                "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nLote",   "N",    9,  0, "",                                "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "cLote",   "C",   12,  0, "Número de lote",                  "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "mObsLin", "M",   10,  0, "Observaciones de lineas",         "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "cRefPrv", "C",   18,  0, "Referencia proveedor",            "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "cUnidad", "C",    2,  0, "Unidad de medición",              "",         "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nMedUno", "N",   16,  6, "Primera unidad de medición",      "MasUnd()", "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nMedDos", "N",   16,  6, "Segunda unidad de medición",      "MasUnd()", "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nMedTre", "N",   16,  6, "Tercera unidad de medición",      "MasUnd()", "", "( cDbfCol )" } )
   aAdd( aColTmpLin, { "nNumLin", "N",    4,  0, "Número de línea",                 "",         "", "( cDbfCol )" } )*/