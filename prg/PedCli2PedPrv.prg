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
   DATA oBrwFin

   DATA oBtnPrev
   DATA oBtnNext
   DATA oBtnCancel

   DATA nStockDisponible
   DATA nStockFin

   DATA oPeriodo
   DATA cPeriodo           INIT "Todos"
   
   DATA oFecIni
   DATA oFecFin

   DATA dFecIni
   DATA dFecFin

   DATA nView

   DATA oTipoArticulo
   DATA oFabricante
   DATA oStock

   DATA oMtr
   DATA nMtr

   DATA dbfTemporal

   DATA oBrwRangos

   DATA aPedidos

   DATA oItemGroupArticulo
   DATA oItemGroupFamilia
   DATA oItemGroupCategoria
   DATA oItemGroupTemporada
   DATA oItemGroupFabricante
   DATA oItemGroupTipoArticulo

   DATA lOnlyOrder

   DATA cSerieOrder
   DATA nNumeroOrder
   DATA cSufijoOrder

   Method New( nView, lOnlyOrder )   CONSTRUCTOR

   Method Resource()
      Method Prev()
      Method Next()

   Method CreateLines()
   Method DestroyLines()

   Method aCreaArrayPeriodos()
   Method lRecargaFecha()

   Method StartDialog()

   Method LoadLineasPedidos()

   Method LoadLinesaOnlyOrder()

   Method AddLineasPedidos( nStock, nReserva )

   Method SelectAllArticulo( lSel )

   Method SelectArticulo()

   Method ChangeUnidades( oCol, uNewValue, nKey )

   Method ChangeCajas( oCol, uNewValue, nKey )

   METHOD getCodigoProveerdor()
   Method ChangeProveedor( x )

   Method GeneraPedidoProveedor()
   Method TotalPedidoProveedor()

   METHOD Calculaunidades( nCantidad, nStockDis, nStockMinMax )

   METHOD lEstadoGenerado()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( nView, oTipoArticulo, oFabricante, oStock, lOnlyOrder ) CLASS PedCliente2PedProveedor

   DEFAULT lOnlyOrder   := .f.

   if !lAIS()
      MsgStop( "Opción disponible sólo para versión ADS." )
      Return .t.
   end if

   ::nView              := nView

   ::oTipoArticulo      := oTipoArticulo
   ::oFabricante        := oFabricante
   ::oStock             := oStock

   ::nStockDisponible   := 2
   ::nStockFin          := 3

   ::aPedidos           := {}

   ::lOnlyOrder         := lOnlyOrder

   ::cSerieOrder        := ( D():PedidosClientes( ::nView ) )->cSerPed
   ::nNumeroOrder       := ( D():PedidosClientes( ::nView ) )->nNumPed
   ::cSufijoOrder       := ( D():PedidosClientes( ::nView ) )->cSufPed

   if ::lOnlyOrder .and. ( D():PedidosClientes( ::nView ) )->nGenerado > 1
      MsgStop( "El pedido ya ha sido pasado a proveedor." )
      Return ( self )
   end if

   if ::CreateLines()
      ::Resource()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

Method CreateLines() CLASS PedCliente2PedProveedor

   local oError
   local oBlock
   local cTmpLin
   local lErrors  := .f.

   CursorWait()

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
   
   cTmpLin        := cGetNewFileName( cPatTmp() + "PTmpCliL" )

   dbCreate( cTmpLin, aSqlStruct( aColTmpLin() ), cLocalDriver() )

   dbUseArea( .t., cLocalDriver(), cTmpLin, cCheckArea( "PTmpCliL", @::dbfTemporal ), .f. )

   if !NetErr()

      ( ::dbfTemporal )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( ::dbfTemporal )->( ordCreate( cTmpLin, "cRefPrp", "cRef + cCodPr1 + cCodPr2 + cValPr1 + cValPr2 + cLote", {|| Field->cRef + Field->cCodPr1 + Field->cCodPr2 + Field->cValPr1 + Field->cValPr2 + Field->cLote } ) )

      ( ::dbfTemporal )->( ordCondSet( "!Deleted()", {|| !Deleted() }  ) )
      ( ::dbfTemporal )->( ordCreate( cTmpLin, "cCodPrv", "cCodPrv", {|| Field->cCodPrv } ) )

      ( ::dbfTemporal )->( OrdSetFocus( "cRefPrp" ) )

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
         RESOURCE "gc_clipboard_empty_businessman_48" ;
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
         WHEN        !::lOnlyOrder ;
         OF          ::oPag:aDialogs[1]

         ::oPeriodo:bCHange   := {|| ::lRecargaFecha() }

      REDEFINE GET ::oFecIni VAR ::dFecIni;
         ID          110 ;
         SPINNER ;
         WHEN        !::lOnlyOrder ;
         OF          ::oPag:aDialogs[1]

      REDEFINE GET ::oFecFin VAR ::dFecFin;
         ID          120 ;
         SPINNER ;
         WHEN        !::lOnlyOrder ;
         OF          ::oPag:aDialogs[1]

      ::oBrwRangos               := BrowseRangos():New( 130, ::oPag:aDialogs[1] )

      ::oItemGroupArticulo       := TItemGroupArticulo():New( ::nView )
      ::oBrwRangos:AddGroup( ::oItemGroupArticulo )

      ::oItemGroupFamilia        := TItemGroupFamilia():New( ::nView )
      ::oBrwRangos:AddGroup( ::oItemGroupFamilia )

      ::oItemGroupTemporada      := TItemGroupTemporada():New( ::nView )
      ::oBrwRangos:AddGroup( ::oItemGroupTemporada )

      ::oItemGroupFabricante     := TItemGroupFabricante():New( ::nView, ::oFabricante )
      ::oBrwRangos:AddGroup( ::oItemGroupFabricante )

      ::oItemGroupTipoArticulo   := TItemGroupTipoArticulo():New( ::nView, ::oTipoArticulo )
      ::oBrwRangos:AddGroup( ::oItemGroupTipoArticulo )

      ::oBrwRangos:Resource()
      
      REDEFINE RADIO ::nStockDisponible ;
         ID       201, 202, 203, 204 ;
         OF       ::oPag:aDialogs[1]

      REDEFINE RADIO ::nStockFin ;
         ID       212, 213, 214 ;
         OF       ::oPag:aDialogs[1]  

      ::oMtr               := TApoloMeter():ReDefine( 220, { | u | if( pCount() == 0, ::nMtr, ::nMtr := u ) }, 10, ::oPag:aDialogs[1], .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )

      /*
      Segunda Caja de diálogo--------------------------------------------------
      */

      ::oBrw               := IXBrowse():New( ::oPag:aDialogs[2] )

      ::oBrw:bClrSel       := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrw:bClrSelFocus  := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrw:cAlias        := ::dbfTemporal

      ::oBrw:nMarqueeStyle := 6
      ::oBrw:cName         := "Generarpedprv"
      ::oBrw:lFooter       := .t.
      ::oBrw:MakeTotals()

      ::oBrw:bLDblClick    := {|| ::SelectArticulo() }

      ::oBrw:CreateFromResource( 100 )

      with object ( ::oBrw:AddCol() )
         :cHeader          := "Se. Seleccionado"
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( ::dbfTemporal )->lSelArt }
         :nWidth           := 20
         :SetCheck( { "gc_check_16", "Nil16" } )
      end with

      with object ( ::oBrw:AddCol() )
         :cHeader          := "Código"
         :bEditValue       := {|| ( ::dbfTemporal )->cCodPrv }
         :bOnPostEdit      := {|o,x| ::ChangeProveedor( x ) }
         :bEditValid       := {|oGet| cProvee( oGet, D():Proveedores( ::nView ) ) }
         :bEditBlock       := {|oGet| BrwProvee( oGet ) }
         :nWidth           := 80
         :nEditType        := 5
         :nBtnBmp          := 1
         :AddResource( "Lupa" )
      end with

      with object ( ::oBrw:AddCol() )
         :cHeader          := "Proveedor"
         :bEditValue       := {|| RetProvee( ( ::dbfTemporal )->cCodPrv ) }
         :nWidth           := 200
      end with

      with object ( ::oBrw:AddCol() )
         :cHeader          := "Artículo"
         :bEditValue       := {|| ( ::dbfTemporal )->cRef }
         :nWidth           := 70
      end with

      with object ( ::oBrw:AddCol() )
         :cHeader          := "Referencia"
         :bEditValue       := {|| ( ::dbfTemporal )->cRefPrv }
         :nWidth           := 70
         :lHide            := .t.
      end with

      with object ( ::oBrw:AddCol() )
         :cHeader          := "Nombre"
         :bEditValue       := {|| if( !Empty( ( ::dbfTemporal )->cRef ), ( ::dbfTemporal )->cDetalle, ( ::dbfTemporal )->mLngDes ) }
         :nWidth           := 155
      end with

      with object ( ::oBrw:AddCol() )
         :cHeader          := "Propiedad 1"
         :bEditValue       := {|| AllTrim( ( ::dbfTemporal )->cValPr1 ) + if( !Empty( ( ::dbfTemporal )->cValPr1 ), " - " + retValProp( ( ::dbfTemporal )->cCodPr1 + ( ::dbfTemporal )->cValPr1, D():PropiedadesLineas( ::nView ) ) , "" ) }
         :nWidth           := 80
      end with

      with object ( ::oBrw:AddCol() )
         :cHeader          := "Propiedad 2"
         :bEditValue       := {|| AllTrim( ( ::dbfTemporal )->cValPr2 ) + if( !Empty( ( ::dbfTemporal )->cValPr2 ), " - " + retValProp( ( ::dbfTemporal )->cCodPr2 + ( ::dbfTemporal )->cValPr2, D():PropiedadesLineas( ::nView ) ) , "" ) }
         :nWidth           := 80
      end with

      with object ( ::oBrw:AddCol() )
         :cHeader          := cNombreCajas()
         :bEditValue       := {|| ( ::dbfTemporal )->nNumCaj }
         :cEditPicture     := MasUnd()
         :nWidth           := 50
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :nEditType        := 1
         :nFooterType      := AGGR_SUM
         :bOnPostEdit      := {|o,x,n| ::ChangeCajas( o, x, n ) }
      end with

      with object ( ::oBrw:AddCol() )
         :cHeader          := cNombreUnidades()
         :bEditValue       := {|| ( ::dbfTemporal )->nNumUni }
         :cEditPicture     := MasUnd()
         :nWidth           := 60
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :nEditType        := 1
         :nFooterType      := AGGR_SUM
         :bOnPostEdit      := {|o,x,n| ::ChangeUnidades( o, x, n ) }
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
         ID       120;
         OF       ::oPag:aDialogs[2] ;
         ACTION   ( ::SelectArticulo() )

      REDEFINE BUTTON ;
         ID       130;
         OF       ::oPag:aDialogs[2] ;
         ACTION   ( ::SelectAllArticulo( .t. ) )

      REDEFINE BUTTON ;
         ID       140;
         OF       ::oPag:aDialogs[2] ;
         ACTION   ( ::SelectAllArticulo( .f. ) )

      /*
      Tercera caja de diálogo--------------------------------------------------
      */

      ::oBrwFin                  := IXBrowse():New( ::oPag:aDialogs[3] )

      ::oBrwFin:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwFin:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrwFin:SetArray( ::aPedidos, , , .f. )

      ::oBrwFin:nMarqueeStyle    := 6
      ::oBrwFin:lFooter          := .t.
      ::oBrwFin:MakeTotals()

      ::oBrwFin:cName            := "Generarpedprvfin"

      ::oBrwFin:CreateFromResource( 100 )

      with object ( ::oBrwFin:AddCol() )
         :cHeader                := "Documento"
         :bEditValue             := {|| AllTrim( hGet( ::aPedidos[ ::oBrwFin:nArrayAt ], "Serie" ) ) + "/" + AllTrim( Str( hGet( ::aPedidos[ ::oBrwFin:nArrayAt ], "Numero" ) ) ) + "/" + AllTrim( hGet( ::aPedidos[ ::oBrwFin:nArrayAt ], "Sufijo" ) ) }
         :nWidth                 := 120
      end with

      with object ( ::oBrwFin:AddCol() )
         :cHeader                := "Fecha"
         :bEditValue             := {|| dtoc( hGet( ::aPedidos[ ::oBrwFin:nArrayAt ], "Fecha" ) ) }
         :nWidth                 := 120
      end with

      with object ( ::oBrwFin:AddCol() )
         :cHeader                := "Proveedor"
         :bEditValue             := {|| AllTrim( hGet( ::aPedidos[ ::oBrwFin:nArrayAt ], "Proveedor" ) ) + " - " + AllTrim( Rtrim( RetProvee( hGet( ::aPedidos[ ::oBrwFin:nArrayAt ], "Proveedor" ) ) ) ) }
         :nWidth                 := 280
      end with

      with object ( ::oBrwFin:AddCol() )
         :cHeader                := "Total"
         :bEditValue             := {|| nTotPedPrv( hGet( ::aPedidos[ ::oBrwFin:nArrayAt ], "Id" ), D():PedidosProveedores( ::nView ), D():PedidosProveedoresLineas( ::nView ), D():TiposIva( ::nView ), D():Divisas( ::nView ) ) }
         :cEditPicture           := cPirDiv()
         :nWidth                 := 80
         :nDataStrAlign          := 1
         :nHeadStrAlign          := 1
         :nFooterType            := AGGR_SUM
      end with

      REDEFINE BUTTON ;
         ID       110;
         OF       ::oPag:aDialogs[3] ;
         ACTION   ( EdtPedPrv( hGet( ::aPedidos[ ::oBrwFin:nArrayAt ], "Id" ) ) )

      REDEFINE BUTTON ;
         ID       120;
         OF       ::oPag:aDialogs[3] ;
         ACTION   ( ZooPedPrv( hGet( ::aPedidos[ ::oBrwFin:nArrayAt ], "Id" ) ) )

      REDEFINE BUTTON ;
         ID       140;
         OF       ::oPag:aDialogs[3] ;
         ACTION   ( VisPedPrv( hGet( ::aPedidos[ ::oBrwFin:nArrayAt ], "Id" ) ) )

      REDEFINE BUTTON ;
         ID       150;
         OF       ::oPag:aDialogs[3] ;
         ACTION   ( PrnPedPrv( hGet( ::aPedidos[ ::oBrwFin:nArrayAt ], "Id" ) ) )

      REDEFINE BUTTON ::oBtnPrev ;
         ID       500 ;
         OF       ::oDlg;
         ACTION   ( ::Prev() )

      REDEFINE BUTTON ::oBtnNext ;
         ID       501 ;
         OF       ::oDlg;
         ACTION   ( ::Next() )

      REDEFINE BUTTON ::oBtnCancel ;
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

         if !::lOnlyOrder
            ::LoadLineasPedidos()
         else
            ::LoadLinesaOnlyOrder()
         end if

         ::oPag:GoNext()

         ::oBrw:MakeTotals()

         ::oBtnPrev:Show()

         SetWindowText( ::oBtnNext:hWnd, "&Procesar" )

      case ::oPag:nOption == 2

         ::GeneraPedidoProveedor()

         ::TotalPedidoProveedor()

         ::lEstadoGenerado()

         ::oPag:GoNext()

         ::oBtnPrev:Hide()
         ::oBtnNext:Hide()

         SetWindowText( ::oBtnCancel:hWnd, "&Terminar" )

         ::oBrwFin:Refresh()
         ::oBrwFin:MakeTotals()
         ::oBrwFin:RefreshFooters()

      case ::oPag:nOption == 3

         ::DestroyLines()

   end case

Return .t.

//---------------------------------------------------------------------------//

METHOD StartDialog() CLASS PedCliente2PedProveedor

   ::oBtnPrev:Hide()

   ::oBrw:Load()

   ::oBrwFin:Load()

   ::oBrwRangos:ResizeColumns()

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

   local cSentencia  := ""
   local cBusqueda   := ""
   local nStock      := 0
   local nReserva    := 0

   ( ::dbfTemporal )->( __dbZap() )

   cSentencia        := "SELECT lineaspedidos.cSerPed, "
   cSentencia        +=        "lineaspedidos.nNumPed, "
   cSentencia        +=        "lineaspedidos.cSufPed, "
   cSentencia        +=        "lineaspedidos.cRef, "
   cSentencia        +=        "lineaspedidos.cDetalle, "
   cSentencia        +=        "lineaspedidos.cCodPr1, "
   cSentencia        +=        "lineaspedidos.cCodPr2, "
   cSentencia        +=        "lineaspedidos.cValPr1, "
   cSentencia        +=        "lineaspedidos.cValPr2, "
   cSentencia        +=        "lineaspedidos.cLote, "
   cSentencia        +=        "lineaspedidos.nIva, "
   cSentencia        +=        "lineaspedidos.nCanPed, "
   cSentencia        +=        "lineaspedidos.nUniCaja, "
   cSentencia        +=        "lineaspedidos.nCosDiv, "
   cSentencia        +=        "lineaspedidos.cAlmLin, "
   cSentencia        +=        "lineaspedidos.cCodPrv, "
   cSentencia        +=        "lineaspedidos.nIva, "
   cSentencia        +=        "lineaspedidos.nReq, "
   cSentencia        +=        "lineaspedidos.cRefPrv, "
   cSentencia        +=        "lineaspedidos.lControl, "
   cSentencia        +=        "cabecerapedidos.cCodCli, "
   cSentencia        +=        "cabecerapedidos.cNomCli, "
   cSentencia        +=        "cabecerapedidos.dFecPed, "
   cSentencia        +=        "articulos.Familia, "
   cSentencia        +=        "articulos.cCodTip, "
   cSentencia        +=        "articulos.cCodCate, "
   cSentencia        +=        "articulos.cCodTemp, "
   cSentencia        +=        "articulos.cCodFab "
   cSentencia        += "FROM " + cPatEmp() + "PedCliL lineaspedidos "
   cSentencia        += "LEFT JOIN " + cPatEmp() + "PedCliT cabecerapedidos on lineaspedidos.cSerPed = cabecerapedidos.cSerPed AND lineaspedidos.nNumPed = cabecerapedidos.nNumPed AND lineaspedidos.cSufped = cabecerapedidos.cSufped "
   cSentencia        += "LEFT JOIN " + cPatEmp() + "Articulo articulos on lineaspedidos.cRef = articulos.codigo "
   cSentencia        += "WHERE lineaspedidos.cRef>='" + Padr( ::oItemGroupArticulo:GetDesde(), 18 ) + "' AND "
   cSentencia        +=       "lineaspedidos.cRef<='" + Padr( ::oItemGroupArticulo:GetHasta(), 18 ) + "' AND "
   cSentencia        +=       "lineaspedidos.cRef<>'' AND "
   cSentencia        +=       "lineaspedidos.nUniCaja<>0 AND "
   cSentencia        +=       "NOT( lineaspedidos.lControl ) AND "
   cSentencia        +=       "cabecerapedidos.dFecPed >='" + dToc( ::dFecIni ) + "' AND "
   cSentencia        +=       "cabecerapedidos.dFecPed <='" + dToc( ::dFecFin ) + "' AND "   
   cSentencia        +=       "NOT(cabecerapedidos.lCancel) AND "   
   cSentencia        +=       "articulos.Familia >='" + Padr( ::oItemGroupFamilia:GetDesde(), 16 ) + "' AND "
   cSentencia        +=       "articulos.Familia <='" + Padr( ::oItemGroupFamilia:GetHasta(), 16 ) + "' AND "
   cSentencia        +=       "articulos.cCodTip >='" + ::oItemGroupTipoArticulo:GetDesde() + "' AND "
   cSentencia        +=       "articulos.cCodTip <='" + ::oItemGroupTipoArticulo:GetHasta() + "' AND "
   cSentencia        +=       "articulos.cCodCate >='" + Padr( ::oItemGroupCategoria:GetDesde(), 3 ) + "' AND "
   cSentencia        +=       "articulos.cCodCate <='" + Padr( ::oItemGroupCategoria:GetHasta(), 3 ) + "' AND "
   cSentencia        +=       "articulos.cCodTemp >='" + Padr( ::oItemGroupTemporada:GetDesde(), 5 ) + "' AND "
   cSentencia        +=       "articulos.cCodTemp <='" + Padr( ::oItemGroupTemporada:GetHasta(), 5 ) + "' AND "
   cSentencia        +=       "articulos.cCodFab >='" + Padr( ::oItemGroupFabricante:GetDesde(), 3 ) + "' AND "
   cSentencia        +=       "articulos.cCodFab <='" + Padr( ::oItemGroupFabricante:GetHasta(), 3 ) + "' "
   cSentencia        += "ORDER BY lineaspedidos.cRef"

   if TDataCenter():ExecuteSqlStatement( cSentencia, "SelectLineasPedidos" )
      
      ::oMtr:SetTotal( ( "SelectLineasPedidos" )->( OrdKeyCount() ) )

      ( "SelectLineasPedidos" )->( dbGoTop() )
      while !( "SelectLineasPedidos" )->( Eof() )

         nStock                        := ::oStock:nTotStockAct( ( "SelectLineasPedidos" )->cRef )
         nReserva                      := nTotReserva( ( "SelectLineasPedidos" )->cRef )

         ::AddLineasPedidos( nStock, nReserva )

         ( "SelectLineasPedidos" )->( dbSkip() )

          ::oMtr:AutoInc()

      end while

      ::oMtr:AutoInc( ( "SelectLineasPedidos" )->( LastRec() ) )

   end if

   ( ::dbfTemporal )->( dbGoTop() )

   if !Empty( ::oBrw )
      ::oBrw:Refresh()
   end if

Return .t.

//---------------------------------------------------------------------------//

METHOD AddLineasPedidos( nStock, nReserva ) CLASS PedCliente2PedProveedor

   local cBusqueda   := ""

   cBusqueda         := ( "SelectLineasPedidos" )->cRef
   cBusqueda         += ( "SelectLineasPedidos" )->cCodPr1
   cBusqueda         += ( "SelectLineasPedidos" )->cCodPr2
   cBusqueda         += ( "SelectLineasPedidos" )->cValPr1
   cBusqueda         += ( "SelectLineasPedidos" )->cValPr2
   cBusqueda         += ( "SelectLineasPedidos" )->cLote

   if ( ::dbfTemporal )->( dbSeek( cBusqueda ) )

      if dbLock( ::dbfTemporal )
         ( ::dbfTemporal )->nNumCaj    += ( "SelectLineasPedidos" )->nCanPed
         ( ::dbfTemporal )->nNumUni    += ( "SelectLineasPedidos" )->nUniCaja
         ( ::dbfTemporal )->( dbUnlock() )
      end if

   else

      if dbAppe( ::dbfTemporal )
         ( ::dbfTemporal )->cRef       := ( "SelectLineasPedidos" )->cRef
         ( ::dbfTemporal )->cDetalle   := ( "SelectLineasPedidos" )->cDetalle
         ( ::dbfTemporal )->lSelArt    := .t.
         ( ::dbfTemporal )->cCodPrv    := ::getCodigoProveerdor( ) 
         ( ::dbfTemporal )->cCodPr1    := ( "SelectLineasPedidos" )->cCodPr1
         ( ::dbfTemporal )->cCodPr2    := ( "SelectLineasPedidos" )->cCodPr2
         ( ::dbfTemporal )->cValPr1    := ( "SelectLineasPedidos" )->cValPr1
         ( ::dbfTemporal )->cValPr2    := ( "SelectLineasPedidos" )->cValPr2
         ( ::dbfTemporal )->nNumUni    := ( "SelectLineasPedidos" )->nUniCaja
         ( ::dbfTemporal )->nNumCaj    := ( "SelectLineasPedidos" )->nCanPed
         ( ::dbfTemporal )->nStkFis    := nStock
         ( ::dbfTemporal )->nStkDis    := nStock - nReserva
         ( ::dbfTemporal )->nIva       := ( "SelectLineasPedidos" )->nIva
         ( ::dbfTemporal )->nReq       := ( "SelectLineasPedidos" )->nReq
         ( ::dbfTemporal )->nPreDiv    := ( "SelectLineasPedidos" )->nCosDiv
         ( ::dbfTemporal )->cLote      := ( "SelectLineasPedidos" )->cLote
         ( ::dbfTemporal )->cRefPrv    := ( "SelectLineasPedidos" )->cRefPrv
         ( ::dbfTemporal )->( dbUnlock() )
      end if 

   end if

Return .t.

//---------------------------------------------------------------------------//

METHOD LoadLinesaOnlyOrder CLASS PedCliente2PedProveedor

   local cSentencia  := ""
   local cBusqueda   := ""
   local nStock      := 0
   local nReserva    := 0

   ( ::dbfTemporal )->( __dbZap() )

   cSentencia        := "SELECT lineaspedidos.cSerPed, "
   cSentencia        +=        "lineaspedidos.nNumPed, "
   cSentencia        +=        "lineaspedidos.cSufPed, "
   cSentencia        +=        "lineaspedidos.cRef, "
   cSentencia        +=        "lineaspedidos.cDetalle, "
   cSentencia        +=        "lineaspedidos.cCodPr1, "
   cSentencia        +=        "lineaspedidos.cCodPr2, "
   cSentencia        +=        "lineaspedidos.cValPr1, "
   cSentencia        +=        "lineaspedidos.cValPr2, "
   cSentencia        +=        "lineaspedidos.cLote, "
   cSentencia        +=        "lineaspedidos.nIva, "
   cSentencia        +=        "lineaspedidos.nCanPed, "
   cSentencia        +=        "lineaspedidos.nUniCaja, "
   cSentencia        +=        "lineaspedidos.nCosDiv, "
   cSentencia        +=        "lineaspedidos.cAlmLin, "
   cSentencia        +=        "lineaspedidos.cCodPrv, "
   cSentencia        +=        "lineaspedidos.nIva, "
   cSentencia        +=        "lineaspedidos.nReq, "
   cSentencia        +=        "lineaspedidos.cRefPrv, "
   cSentencia        +=        "lineaspedidos.lControl, "
   cSentencia        +=        "cabecerapedidos.cCodCli, "
   cSentencia        +=        "cabecerapedidos.cNomCli, "
   cSentencia        +=        "cabecerapedidos.dFecPed, "
   cSentencia        +=        "articulos.Familia, "
   cSentencia        +=        "articulos.cCodTip, "
   cSentencia        +=        "articulos.cCodCate, "
   cSentencia        +=        "articulos.cCodTemp, "
   cSentencia        +=        "articulos.cCodFab "
   cSentencia        += "FROM " + cPatEmp() + "PedCliL lineaspedidos "
   cSentencia        += "LEFT JOIN " + cPatEmp() + "PedCliT cabecerapedidos on lineaspedidos.cSerPed = cabecerapedidos.cSerPed AND lineaspedidos.nNumPed = cabecerapedidos.nNumPed AND lineaspedidos.cSufped = cabecerapedidos.cSufped "
   cSentencia        += "LEFT JOIN " + cPatEmp() + "Articulo articulos on lineaspedidos.cRef = articulos.codigo "
   cSentencia        += "WHERE lineaspedidos.cSerPed='" + ::cSerieOrder + "' AND "
   cSentencia        +=       "lineaspedidos.nNumPed=" + AllTrim( Str( ::nNumeroOrder ) ) + " AND "
   cSentencia        +=       "lineaspedidos.cSufPed='" + ::cSufijoOrder + "' AND "
   cSentencia        +=       "lineaspedidos.cRef>='" + Padr( ::oItemGroupArticulo:GetDesde(), 18 ) + "' AND "
   cSentencia        +=       "lineaspedidos.cRef<='" + Padr( ::oItemGroupArticulo:GetHasta(), 18 ) + "' AND "
   cSentencia        +=       "lineaspedidos.cRef<>'' AND "
   cSentencia        +=       "lineaspedidos.nUniCaja<>0 AND "
   cSentencia        +=       "NOT( lineaspedidos.lControl ) AND "
   cSentencia        +=       "cabecerapedidos.dFecPed >='" + dToc( ::dFecIni ) + "' AND "
   cSentencia        +=       "cabecerapedidos.dFecPed <='" + dToc( ::dFecFin ) + "' AND "   
   cSentencia        +=       "NOT(cabecerapedidos.lCancel) AND "   
   cSentencia        +=       "articulos.Familia >='" + Padr( ::oItemGroupFamilia:GetDesde(), 16 ) + "' AND "
   cSentencia        +=       "articulos.Familia <='" + Padr( ::oItemGroupFamilia:GetHasta(), 16 ) + "' AND "
   cSentencia        +=       "articulos.cCodTip >='" + ::oItemGroupTipoArticulo:GetDesde() + "' AND "
   cSentencia        +=       "articulos.cCodTip <='" + ::oItemGroupTipoArticulo:GetHasta() + "' AND "
   cSentencia        +=       "articulos.cCodCate >='" + Padr( ::oItemGroupCategoria:GetDesde(), 3 ) + "' AND "
   cSentencia        +=       "articulos.cCodCate <='" + Padr( ::oItemGroupCategoria:GetHasta(), 3 ) + "' AND "
   cSentencia        +=       "articulos.cCodTemp >='" + Padr( ::oItemGroupTemporada:GetDesde(), 5 ) + "' AND "
   cSentencia        +=       "articulos.cCodTemp <='" + Padr( ::oItemGroupTemporada:GetHasta(), 5 ) + "' AND "
   cSentencia        +=       "articulos.cCodFab >='" + Padr( ::oItemGroupFabricante:GetDesde(), 3 ) + "' AND "
   cSentencia        +=       "articulos.cCodFab <='" + Padr( ::oItemGroupFabricante:GetHasta(), 3 ) + "' "
   cSentencia        += "ORDER BY lineaspedidos.cRef"

   if TDataCenter():ExecuteSqlStatement( cSentencia, "SelectLineasPedidos" )
      
      ::oMtr:SetTotal( ( "SelectLineasPedidos" )->( OrdKeyCount() ) )

      ( "SelectLineasPedidos" )->( dbGoTop() )
      while !( "SelectLineasPedidos" )->( Eof() )

         nStock                        := ::oStock:nTotStockAct( ( "SelectLineasPedidos" )->cRef )
         nReserva                      := nTotReserva( ( "SelectLineasPedidos" )->cRef )

         if dbAppe( ::dbfTemporal )
            ( ::dbfTemporal )->cRef       := ( "SelectLineasPedidos" )->cRef
            ( ::dbfTemporal )->cDetalle   := ( "SelectLineasPedidos" )->cDetalle
            ( ::dbfTemporal )->lSelArt    := .t.
            ( ::dbfTemporal )->cCodPrv    := ::getCodigoProveerdor( ) 
            ( ::dbfTemporal )->cCodPr1    := ( "SelectLineasPedidos" )->cCodPr1
            ( ::dbfTemporal )->cCodPr2    := ( "SelectLineasPedidos" )->cCodPr2
            ( ::dbfTemporal )->cValPr1    := ( "SelectLineasPedidos" )->cValPr1
            ( ::dbfTemporal )->cValPr2    := ( "SelectLineasPedidos" )->cValPr2
            ( ::dbfTemporal )->nNumUni    := ( "SelectLineasPedidos" )->nUniCaja
            ( ::dbfTemporal )->nNumCaj    := ( "SelectLineasPedidos" )->nCanPed
            ( ::dbfTemporal )->nStkFis    := nStock
            ( ::dbfTemporal )->nStkDis    := nStock - nReserva
            ( ::dbfTemporal )->nIva       := ( "SelectLineasPedidos" )->nIva
            ( ::dbfTemporal )->nReq       := ( "SelectLineasPedidos" )->nReq
            ( ::dbfTemporal )->nPreDiv    := ( "SelectLineasPedidos" )->nCosDiv
            ( ::dbfTemporal )->cLote      := ( "SelectLineasPedidos" )->cLote
            ( ::dbfTemporal )->cRefPrv    := ( "SelectLineasPedidos" )->cRefPrv
            ( ::dbfTemporal )->( dbUnlock() )
         end if

         ( "SelectLineasPedidos" )->( dbSkip() )

          ::oMtr:AutoInc()

      end while

      ::oMtr:AutoInc( ( "SelectLineasPedidos" )->( LastRec() ) )

   end if

   ( ::dbfTemporal )->( dbGoTop() )

   if !Empty( ::oBrw )
      ::oBrw:Refresh()
   end if

Return .t.

//---------------------------------------------------------------------------//

METHOD SelectArticulo() CLASS PedCliente2PedProveedor

   if dbDialogLock( ::dbfTemporal )
      ( ::dbfTemporal )->lSelArt := !( ::dbfTemporal )->lSelArt
      ( ::dbfTemporal )->( dbUnlock() )
   end if

   if !Empty( ::oBrw )
      ::oBrw:Refresh()
   end if

return .t.

//---------------------------------------------------------------------------//

METHOD SelectAllArticulo( lSel ) CLASS PedCliente2PedProveedor

   local nRec  := ( ::dbfTemporal )->( Recno() )

   ( ::dbfTemporal )->( dbGoTop() )
   while !( ::dbfTemporal )->( eof() )

      if dbDialogLock( ::dbfTemporal )
         ( ::dbfTemporal )->lSelArt := lSel
         ( ::dbfTemporal )->( dbUnlock() )
      end if

      ( ::dbfTemporal )->( dbSkip() )
   
   end while

   ( ::dbfTemporal )->( dbGoTo( nRec ) )

   if !Empty( ::oBrw )
      ::oBrw:Refresh()
   end if

return .t.

//---------------------------------------------------------------------------//

METHOD ChangeUnidades( oCol, uNewValue, nKey ) CLASS PedCliente2PedProveedor

   if IsNum( nKey ) .and. ( nKey != VK_ESCAPE ) .and. !IsNil( uNewValue )

      if dbDialogLock( ::dbfTemporal )
         ( ::dbfTemporal )->nNumUni := uNewValue
         ( ::dbfTemporal )->( dbUnlock() )
      end if

   end if

Return .t.

//---------------------------------------------------------------------------//

METHOD ChangeCajas( oCol, uNewValue, nKey ) CLASS PedCliente2PedProveedor

   if IsNum( nKey ) .and. ( nKey != VK_ESCAPE ) .and. !IsNil( uNewValue )

      if dbDialogLock( ::dbfTemporal )
         ( ::dbfTemporal )->nNumCaj := uNewValue
         ( ::dbfTemporal )->( dbUnlock() )
      end if

   end if

Return .t.

//---------------------------------------------------------------------------//

METHOD ChangeProveedor( x ) CLASS PedCliente2PedProveedor

   if dbDialogLock( ::dbfTemporal )
      ( ::dbfTemporal )->cCodPrv := x
      ( ::dbfTemporal )->( dbUnlock() )
   end if

Return .t.

//---------------------------------------------------------------------------//

METHOD GeneraPedidoProveedor() CLASS PedCliente2PedProveedor

   local cSeriePedido
   local nNumeroPedido
   local cSufijoPedido
   local nNumeroLinea
   local cLastProveedor := ""

   ( ::dbfTemporal )->( OrdSetFocus( "cCodPrv" ) )
   ( ::dbfTemporal )->( dbGoTop() )

   while !( ::dbfTemporal )->( eof() )

      if !Empty( ( ::dbfTemporal )->cCodPrv )

         // Creo la cabecera del pedido a proveedor----------------------------

         if cLastProveedor != ( ::dbfTemporal )->cCodPrv

            cSeriePedido               := cNewSer( "nPedPrv", D():Contadores( ::nView ) )
            nNumeroPedido              := nNewDoc( cSeriePedido, D():PedidosProveedores( ::nView ), "nPedPrv", , D():Contadores( ::nView ) )
            cSufijoPedido              := RetSufEmp()
            cLastProveedor             := ( ::dbfTemporal )->cCodPrv
            nNumeroLinea               := 0

            ( D():PedidosProveedores( ::nView ) )->( dbAppend() )
            ( D():PedidosProveedores( ::nView ) )->cSerPed    := cSeriePedido
            ( D():PedidosProveedores( ::nView ) )->nNumPed    := nNumeroPedido
            ( D():PedidosProveedores( ::nView ) )->cSufPed    := cSufijoPedido
            ( D():PedidosProveedores( ::nView ) )->cTurPed    := cCurSesion()
            ( D():PedidosProveedores( ::nView ) )->dFecPed    := GetSysDate()
            ( D():PedidosProveedores( ::nView ) )->cCodPrv    := ( ::dbfTemporal )->cCodPrv
            ( D():PedidosProveedores( ::nView ) )->cCodAlm    := oUser():cAlmacen()
            ( D():PedidosProveedores( ::nView ) )->cCodCaj    := oUser():cCaja()
            ( D():PedidosProveedores( ::nView ) )->nEstado    := 1
            ( D():PedidosProveedores( ::nView ) )->cDivPed    := cDivEmp()
            ( D():PedidosProveedores( ::nView ) )->lSndDoc    := .t.
            ( D():PedidosProveedores( ::nView ) )->cCodUsr    := Auth():Codigo()
            ( D():PedidosProveedores( ::nView ) )->cNumPedCli := ::cSerieOrder + Str( ::nNumeroOrder ) + ::cSufijoOrder
            
            if ( D():Proveedores( ::nView ) )->( dbSeek( ( ::dbfTemporal )->cCodPrv ) )
               ( D():PedidosProveedores( ::nView ) )->cNomPrv    := ( D():Proveedores( ::nView ) )->Titulo
               ( D():PedidosProveedores( ::nView ) )->cDirPrv    := ( D():Proveedores( ::nView ) )->Domicilio
               ( D():PedidosProveedores( ::nView ) )->cPobPrv    := ( D():Proveedores( ::nView ) )->Poblacion
               ( D():PedidosProveedores( ::nView ) )->cProPrv    := ( D():Proveedores( ::nView ) )->Provincia
               ( D():PedidosProveedores( ::nView ) )->cPosPrv    := ( D():Proveedores( ::nView ) )->cCodPai
               ( D():PedidosProveedores( ::nView ) )->cDniPrv    := ( D():Proveedores( ::nView ) )->Nif
               ( D():PedidosProveedores( ::nView ) )->dFecEnt    := GetSysDate() + ( D():Proveedores( ::nView ) )->nPlzEnt
               ( D():PedidosProveedores( ::nView ) )->lRecargo   := ( D():Proveedores( ::nView ) )->lReq
            end if

            ( D():PedidosProveedores( ::nView ) )->( dbUnLock() )

            aAdd( ::aPedidos, {  "Serie" => cSeriePedido,;
                                 "Numero" => nNumeroPedido,;
                                 "Sufijo" => cSufijoPedido,;
                                 "Id" => cSeriePedido + str( nNumeroPedido ) + cSufijoPedido,;
                                 "Fecha" => GetSysDate(),;
                                 "Proveedor" => cLastProveedor } )

         end if

         /*
         Creo las lineas del pedido a proveedor--------------------------------
         */

         ( D():PedidosProveedoresLineas( ::nView ) )->( dbAppend() )

         ( D():PedidosProveedoresLineas( ::nView ) )->cSerPed          := cSeriePedido
         ( D():PedidosProveedoresLineas( ::nView ) )->nNumPed          := nNumeroPedido
         ( D():PedidosProveedoresLineas( ::nView ) )->cSufPed          := cSufijoPedido
         ( D():PedidosProveedoresLineas( ::nView ) )->nNumLin          := ++nNumeroLinea
         ( D():PedidosProveedoresLineas( ::nView ) )->cAlmLin          := oUser():cAlmacen()
         ( D():PedidosProveedoresLineas( ::nView ) )->cRef             := ( ::dbfTemporal )->cRef
         ( D():PedidosProveedoresLineas( ::nView ) )->cDetalle         := ( ::dbfTemporal )->cDetalle
         ( D():PedidosProveedoresLineas( ::nView ) )->mLngDes          := ( ::dbfTemporal )->mLngDes
         ( D():PedidosProveedoresLineas( ::nView ) )->nIva             := ( ::dbfTemporal )->nIva
         ( D():PedidosProveedoresLineas( ::nView ) )->nReq             := ( ::dbfTemporal )->nReq
         ( D():PedidosProveedoresLineas( ::nView ) )->nCanPed          := ( ::dbfTemporal )->nNumCaj
         ( D():PedidosProveedoresLineas( ::nView ) )->nPreDiv          := ( ::dbfTemporal )->nPreDiv
         ( D():PedidosProveedoresLineas( ::nView ) )->cUniDad          := ( ::dbfTemporal )->cUniDad
         ( D():PedidosProveedoresLineas( ::nView ) )->nDtoLin          := ( ::dbfTemporal )->nDto
         ( D():PedidosProveedoresLineas( ::nView ) )->nDtoPrm          := ( ::dbfTemporal )->nDtoPrm
         ( D():PedidosProveedoresLineas( ::nView ) )->cCodPr1          := ( ::dbfTemporal )->cCodPr1
         ( D():PedidosProveedoresLineas( ::nView ) )->cCodPr2          := ( ::dbfTemporal )->cCodPr2
         ( D():PedidosProveedoresLineas( ::nView ) )->cValPr1          := ( ::dbfTemporal )->cValPr1
         ( D():PedidosProveedoresLineas( ::nView ) )->cValPr2          := ( ::dbfTemporal )->cValPr2
         ( D():PedidosProveedoresLineas( ::nView ) )->lLote            := ( ::dbfTemporal )->lLote
         ( D():PedidosProveedoresLineas( ::nView ) )->nLote            := ( ::dbfTemporal )->nLote
         ( D():PedidosProveedoresLineas( ::nView ) )->cLote            := ( ::dbfTemporal )->cLote
         ( D():PedidosProveedoresLineas( ::nView ) )->mObsLin          := ( ::dbfTemporal )->mObsLin
         ( D():PedidosProveedoresLineas( ::nView ) )->cRefPrv          := ( ::dbfTemporal )->cRefPrv
         ( D():PedidosProveedoresLineas( ::nView ) )->nMedUno          := ( ::dbfTemporal )->nMedUno
         ( D():PedidosProveedoresLineas( ::nView ) )->nMedDos          := ( ::dbfTemporal )->nMedDos
         ( D():PedidosProveedoresLineas( ::nView ) )->nMedTre          := ( ::dbfTemporal )->nMedTre
         ( D():PedidosProveedoresLineas( ::nView ) )->cUnidad          := ( ::dbfTemporal )->cUnidad

         if ::lOnlyOrder
            ( D():PedidosProveedoresLineas( ::nView ) )->cPedCli       := ::cSerieOrder + Str( ::nNumeroOrder ) + ::cSufijoOrder
         end if

         do case
            case ::nStockFin == 1

               ( D():PedidosProveedoresLineas( ::nView ) )->nUniCaja   := ::Calculaunidades( ( ::dbfTemporal  )->nNumUni, ( ::dbfTemporal  )->nStkDis, RetFld( ( ::dbfTemporal  )->cRef, D():Articulos( ::nView ), "nMinimo" ) )

            case ::nStockFin == 2

               ( D():PedidosProveedoresLineas( ::nView ) )->nUniCaja   := ::Calculaunidades( ( ::dbfTemporal  )->nNumUni, ( ::dbfTemporal  )->nStkDis, RetFld( ( ::dbfTemporal  )->cRef, D():Articulos( ::nView ), "nMaximo" ) )

            case ::nStockFin == 3

               ( D():PedidosProveedoresLineas( ::nView ) )->nUniCaja   := ( ::dbfTemporal  )->nNumUni

         end case

         ( D():PedidosProveedoresLineas( ::nView ) )->( dbRUnLock() )

      end if   

      ( ::dbfTemporal )->( dbSkip() )

   end while

Return .t.

//---------------------------------------------------------------------------//

METHOD TotalPedidoProveedor() CLASS PedCliente2PedProveedor

   local hPedido
   local aPedido

   for each hPedido in ::aPedidos

      if D():gotoIdPedidosProveedores( hPedido[ "Id" ], ::nView )

         aPedido  := aTotPedPrv( hPedido[ "Id" ], D():PedidosProveedores( ::nView ), D():PedidosProveedoresLineas( ::nView ), D():TiposIva( ::nView ), D():Divisas( ::nView ), D():FormasPago( ::nView ), ( D():PedidosProveedores( ::nView ) )->cDivPed )

         if dbLock( D():PedidosProveedores( ::nView ) )
            ( D():PedidosProveedores( ::nView ) )->nTotNet := aPedido[ 1 ]
            ( D():PedidosProveedores( ::nView ) )->nTotIva := aPedido[ 2 ]
            ( D():PedidosProveedores( ::nView ) )->nTotReq := aPedido[ 3 ]
            ( D():PedidosProveedores( ::nView ) )->nTotPed := aPedido[ 4 ]
            ( D():PedidosProveedores( ::nView ) )->( dbUnLock() )
         end if

      end if 

   next 

Return .t.

//---------------------------------------------------------------------------//
   
METHOD Calculaunidades( nCantidad, nStockDis, nStockMinMax ) CLASS PedCliente2PedProveedor

   local nUnidades

   do case
      case nStockDis < 0
         nUnidades   := ( 0 - nStockDis ) + nCantidad + nStockMinMax
      case nStockDis == 0
         nUnidades   := nCantidad + nStockMinMax
      case nStockDis > 0
         nUnidades   := ( nCantidad - nStockDis ) + nStockMinMax
   end case

   if nUnidades < 0
      nUnidades      := 0
   end if

return nUnidades

//---------------------------------------------------------------------------//

METHOD getCodigoProveerdor()

   local cCodigoProveedor  := ( "SelectLineasPedidos" )->cCodPrv

   if empty( cCodigoProveedor )
      cCodigoProveedor     := cProveedorDefecto( ( "SelectLineasPedidos" )->cRef, D():ProveedorArticulo( ::nView ) )
   end if 

Return ( cCodigoProveedor )   

//---------------------------------------------------------------------------//

METHOD lEstadoGenerado()

   local hPedido

   if !::lOnlyOrder
      Return .f.
   end if

   ::oStock:SetGeneradoPedCli( ::cSerieOrder + Str( ::nNumeroOrder ) + ::cSufijoOrder )

Return ( .t. )

//---------------------------------------------------------------------------//