#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Xbrowse.ch"
#include "Folder.ch"
#include "Report.ch"
#include "Label.ch"
#include "Menu.ch"
#include "FastRepH.ch" 
#include "dbInfo.ch"

#define albNoFacturado              1
#define albParcialmenteFacturado    2
#define albTotalmenteFacturado      3

//---------------------------------------------------------------------------//

CLASS TFacturarLineasAlbaranesProveedor FROM DialogBuilder

   DATA cPath

   DATA lImported

   DATA oProveedor
   DATA oArticulo
   DATA oPeriodo

   DATA oPropiedad1
   DATA oPropiedad2

   DATA oBrwEntrada
   DATA oBrwSalida

   DATA oBase
   DATA oIva
   DATA oTotal

   DATA tmpEntrada
   DATA tmpSalida

   DATA cSerieFactura
   DATA nNumeroFactura 
   DATA cSufijoFactura

   DATA aAlbaranesProcesados              INIT {}

   METHOD New( nView )

   METHOD Resource()
   METHOD validArticulo()
   METHOD startResource()

   METHOD CreaTemporales()
   METHOD CierraTemporales()

   METHOD loadAlbaranes()     
      METHOD loadAlbaran( id )    

   METHOD setIdFacturaProveedor()
   METHOD getIdFacturaProveedor()         INLINE   ( ::cSerieFactura + str( ::nNumeroFactura ) + ::cSufijoFactura )
   
   METHOD saveAlbaran()    
      METHOD setLineasFacturadas()
      METHOD setLineaFacturada()
      METHOD setAlbaranesFacturados()
      METHOD addAlbaranFacturado( id )    INLINE   (  iif(  aScan( ::aAlbaranesProcesados, id ) == 0,;
                                                            aAdd( ::aAlbaranesProcesados, id ), ) )

   METHOD passLineas()     
      METHOD passLinea()     

   METHOD lPassedLinea()      

   METHOD deleteLineas()                  INLINE   ( ::oBrwSalida:SelectAll(), ::deleteLinea() )
      METHOD deleteLinea()                INLINE   ( dbdel( D():Tmp( "TmpPrvO", ::nView ) ), ::oBrwSalida:refresh(), ::oBrwEntrada:refresh() )

   METHOD recalculaTotal()    

   METHOD genNuevaFacturaProveedor()
      METHOD genCabeceraFacturaProveedor()
         METHOD cargaProveedor()
      METHOD genLineasFacturaProveedor()
         METHOD insertLineaFacturaProveedor()
      METHOD guardaTotalesFacturaProveedor()
      METHOD genPagosFacturaProveedor()

   METHOD getSuAlb()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS TFacturarLineasAlbaranesProveedor

   ::nView           := nView

   // Comprobaciones antes de entrar----------------------------------------------

   if ::nView < 1
      msgStop( "La vista creada no es válida" )
      Return .f.
   end if

   // Valores iniciales ----------------------------------------------------------

   ::oProveedor      := GetProveedor():Build( { "idGet" => 130, "idSay" => 140, "oContainer" => Self } )

   ::oArticulo       := GetArticulo():Build( { "idGet" => 160, "idSay" => 161, "oContainer" => Self } )
   ::oArticulo:bValid:= {|| ::ValidArticulo() }

   ::oPropiedad1     := GetPropiedadActual():Build( { "idGet" => 170, "idSay" => 171, "oContainer" => Self } )

   ::oPropiedad2     := GetPropiedadActual():Build( { "idGet" => 180, "idSay" => 181, "oContainer" => Self } )

   ::oPeriodo        := GetPeriodo():Build( { "idCombo" => 100, "idFechaInicio" => 110, "idFechaFin" => 120, "oContainer" => Self } )

   ::oBase           := SayCompras():New( 400, Self )

   ::oIva            := SayCompras():New( 410, Self )

   ::oTotal          := SayCompras():New( 420, Self )

   // Creamos los temporales necesarios-------------------------------------------

   ::CreaTemporales()

   // Montamos el recurso---------------------------------------------------------

   ::Resource()

   // Destruimos las temporales---------------------------------------------------

   ::CierraTemporales()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD CreaTemporales()

   D():BuildTmp(  "AlbProvL",;
                  "TmpPrvI",;
                  {  {  "tagName" => "nNumAlb" ,;
                        "tagExpresion" => "cSerAlb + str( nNumAlb ) + cSufAlb + str( nNumLin )",;
                        "tagBlock" => {|| Field->cSerAlb + str( Field->nNumAlb ) + Field->cSufAlb + str( Field->nNumLin ) } },;
					      {  "tagName" => "cSuAlb" ,;
                        "tagExpresion" => "cSuAlb",;
                        "tagBlock" => {|| Field->cSuAlb } },;
                     {  "tagName" => "cDetalle" ,;
                        "tagExpresion" => "cDetalle",;
                        "tagBlock" => {|| Field->cDetalle } } },;
                  ::nView ) 

 
   D():BuildTmp(  "AlbProvL",;
                  "TmpPrvO",;
                  {  {  "tagName" => "nNumAlb" ,;
                        "tagExpresion" => "cSerAlb + str( nNumAlb ) + cSufAlb + str( nNumLin )",;
                        "tagBlock" => {|| Field->cSerAlb + str( Field->nNumAlb ) + Field->cSufAlb + str( Field->nNumLin ) } },;
                     {  "tagName" => "cSuAlb" ,;
                        "tagExpresion" => "cSuAlb",;
                        "tagBlock" => {|| Field->cSuAlb } },;
                     {  "tagName" => "cDetalle" ,;
                        "tagExpresion" => "cDetalle",;
                        "tagBlock" => {|| Field->cDetalle } } },;
                  ::nView ) 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD CierraTemporales()

   D():CloseTmp( "TmpPrvI", ::nView ) 

   D():CloseTmp( "TmpPrvO", ::nView ) 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Resource() CLASS TFacturarLineasAlbaranesProveedor

   DEFINE DIALOG ::oDlg RESOURCE "FacturaLineasCompletasAlbaranes"

      aEval( ::aComponents, {| o | o:Resource(::oDlg) } )

      TBtnBmp():ReDefine( 150, "gc_recycle_16",,,,, {|| ::loadAlbaranes() }, ::oDlg, .f., , .f. )

      // Browse de lineas de entradas------------------------------------------

      ::oBrwEntrada        := IXBrowse():New( ::oDlg )
      ::oBrwEntrada:cAlias := D():Tmp( "TmpPrvI", ::nView )
      ::oBrwEntrada:cName  := "Lineas de albaranes a proveedor entradas"

      with object ( ::oBrwEntrada:AddCol() )
         :cHeader          := "Pasado"
         :nHeadBmpNo       := 1
         :bStrData         := {|| "" }
         :bEditValue       := {|| ::lPassedLinea() }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( ::oBrwEntrada:AddCol() )
         :cHeader          := "Albarán"
         :bEditValue       := {|| ( D():Tmp( "TmpPrvI", ::nView ) )->cSerAlb + "/" + Alltrim( Str( ( D():Tmp( "TmpPrvI", ::nView ) )->nNumAlb ) ) }
         :nWidth           := 80
      end with

      with object ( ::oBrwEntrada:AddCol() )
         :cHeader          := "Núm"
         :bEditValue       := {|| if( ( D():Tmp( "TmpPrvI", ::nView ) )->lKitChl, "", Trans( ( D():Tmp( "TmpPrvI", ::nView ) )->nNumLin, "9999" ) ) }
         :nWidth           := 40
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( ::oBrwEntrada:AddCol() )
         :cHeader          := "Código"
         :bEditValue       := {|| ( D():Tmp( "TmpPrvI", ::nView ) )->cRef }
         :nWidth           := 80
      end with

      with object ( ::oBrwEntrada:AddCol() )
         :cHeader          := "C. Barras"
         :bEditValue       := {|| cCodigoBarrasDefecto( ( D():Tmp( "TmpPrvI", ::nView ) )->cRef, D():ArticulosCodigosBarras( ::nView ) ) }
         :nWidth           := 100
         :lHide            := .t.
      end with

      with object ( ::oBrwEntrada:AddCol() )
         :cHeader          := "Código proveedor"
         :bEditValue       := {|| ( D():Tmp( "TmpPrvI", ::nView ) )->cRefPrv }
         :nWidth           := 80
         :lHide            := .t.
      end with

      with object ( ::oBrwEntrada:AddCol() )
         :cHeader          := "Descripción"
         :cSortOrder       := "cDetalle"
         :bEditValue       := {|| if( Empty( ( D():Tmp( "TmpPrvI", ::nView ) )->cRef ) .and. !Empty( ( D():Tmp( "TmpPrvI", ::nView ) )->mLngDes ), ( D():Tmp( "TmpPrvI", ::nView ) )->mLngDes, ( D():Tmp( "TmpPrvI", ::nView ) )->cDetalle ) }
         :nWidth           := 305
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | if( !empty( oCol ), oCol:SetOrder(), ) }         
      end with

      with object ( ::oBrwEntrada:AddCol() )
         :cHeader          := "Prop. 1"
         :bEditValue       := {|| ( D():Tmp( "TmpPrvI", ::nView ) )->cValPr1 }
         :nWidth           := 60
         :lHide            := .t.
      end with

      with object ( ::oBrwEntrada:AddCol() )
         :cHeader          := "Prop. 2"
         :bEditValue       := {|| ( D():Tmp( "TmpPrvI", ::nView ) )->cValPr2 }
         :nWidth           := 60
         :lHide            := .t.
      end with

      with object ( ::oBrwEntrada:AddCol() )
         :cHeader          := "Lote"
         :bEditValue       := {|| ( D():Tmp( "TmpPrvI", ::nView ) )->cLote }
         :nWidth           := 80
         :lHide            := .t.
      end with

      with object ( ::oBrwEntrada:AddCol() )
         :cHeader          := "Caducidad"
         :bEditValue       := {|| ( D():Tmp( "TmpPrvI", ::nView ) )->dFecCad }
         :nWidth           := 80
         :lHide            := .t.
      end with

      with object ( ::oBrwEntrada:AddCol() )
         :cHeader          := "Pedido cliente"
         :bEditValue       := {|| if( !Empty( ( D():Tmp( "TmpPrvI", ::nView ) )->cNumPed ), Trans( ( D():Tmp( "TmpPrvI", ::nView ) )->cNumPed, "@R #/#########/##" ), "" ) }
         :nWidth           := 80
         :lHide            := .t.
      end with

      with object ( ::oBrwEntrada:AddCol() )
         :cHeader          := "Cliente"
         :bEditValue       := {|| if( !Empty( (D():Tmp( "TmpPrvI", ::nView ))->cNumPed ), GetCliente( (D():Tmp( "TmpPrvI", ::nView ))->cNumPed ), "" ) }
         :nWidth           := 180
         :lHide            := .t.
      end with

      with object ( ::oBrwEntrada:AddCol() )
         :cHeader          := "Su albarán"
         :cSortOrder       := "cSuAlb"
         :bEditValue       := {|| if( !Empty( (D():Tmp( "TmpPrvI", ::nView ))->cSuAlb ), (D():Tmp( "TmpPrvI", ::nView ))->cSuAlb , "" ) }
         :nWidth           := 60
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | if( !empty( oCol ), oCol:SetOrder(), ) }
      end with

      with object ( ::oBrwEntrada:AddCol() )
         :cHeader          := cNombreUnidades()
         :bEditValue       := {|| nTotNAlbPrv( D():Tmp( "TmpPrvI", ::nView ) ) }
         :cEditPicture     := MasUnd()
         :nWidth           := 60
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :nFooterType      := AGGR_SUM
      end with

      with object ( ::oBrwEntrada:AddCol() )
         :cHeader          := "UM. Unidad de medición"
         :bEditValue       := {|| ( D():Tmp( "TmpPrvI", ::nView ) )->cUnidad }
         :nWidth           := 25
      end with

      with object ( ::oBrwEntrada:AddCol() )
         :cHeader          := "Almacen"
         :bEditValue       := {|| ( D():Tmp( "TmpPrvI", ::nView ) )->cAlmLin }
         :nWidth           := 60
      end with

      with object ( ::oBrwEntrada:AddCol() )
         :cHeader          := "Importe"
         :bEditValue       := {|| nTotUAlbPrv( D():Tmp( "TmpPrvI", ::nView ), nDinDiv() ) }
         :cEditPicture     := cPinDiv()
         :nWidth           := 90
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( ::oBrwEntrada:AddCol() )
         :cHeader          := "% Dto."
         :bEditValue       := {|| ( D():Tmp( "TmpPrvI", ::nView ) )->nDtoLin }
         :cEditPicture     := "@E 999.99"
         :nWidth           := 50
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( ::oBrwEntrada:AddCol() )
         :cHeader          := "% Prm."
         :bEditValue       := {|| ( D():Tmp( "TmpPrvI", ::nView ) )->nDtoPrm }
         :cEditPicture     := "@E 999.99"
         :nWidth           := 40
         :lHide            := .t.
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( ::oBrwEntrada:AddCol() )
         :cHeader          := "% " + cImp()
         :bEditValue       := {|| ( D():Tmp( "TmpPrvI", ::nView ) )->nIva }
         :cEditPicture     := "@E 999.99"
         :nWidth           := 50
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( ::oBrwEntrada:AddCol() )
         :cHeader          := "Total"
         :bEditValue       := {|| nTotLAlbPrv( D():Tmp( "TmpPrvI", ::nView ), nDinDiv(), nRouDiv() ) }
         :cEditPicture     := cPirDiv()
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :nFooterType      := AGGR_SUM
      end with

      ::oBrwEntrada:bClrSel            := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwEntrada:bClrSelFocus       := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
      ::oBrwEntrada:bLDblClick         := {|| ::passLineas(), ::recalculaTotal() }

      ::oBrwEntrada:nMarqueeStyle      := 6
      ::oBrwEntrada:lFooter            := .t.

      ::oBrwEntrada:CreateFromResource( 200 )

      // Browse de lineas de entradas------------------------------------------

      ::oBrwSalida         := IXBrowse():New( ::oDlg )
      ::oBrwSalida:cAlias  := D():Tmp( "TmpPrvO", ::nView )
      ::oBrwSalida:cName   := "Lineas de albaranes a proveedor salidas"

      with object ( ::oBrwSalida:AddCol() )
         :cHeader          := "Albarán"
         :bEditValue       := {|| ( D():Tmp( "TmpPrvO", ::nView ) )->cSerAlb + "/" + Alltrim( Str( ( D():Tmp( "TmpPrvO", ::nView ) )->nNumAlb ) ) }
         :nWidth           := 80
      end with

      with object ( ::oBrwSalida:AddCol() )
         :cHeader          := "Núm"
         :bEditValue       := {|| if( ( D():Tmp( "TmpPrvO", ::nView ) )->lKitChl, "", Trans( ( D():Tmp( "TmpPrvO", ::nView ) )->nNumLin, "9999" ) ) }
         :nWidth           := 40
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( ::oBrwSalida:AddCol() )
         :cHeader          := "Código"
         :bEditValue       := {|| ( D():Tmp( "TmpPrvO", ::nView ) )->cRef }
         :nWidth           := 80
      end with

      with object ( ::oBrwSalida:AddCol() )
         :cHeader          := "C. Barras"
         :bEditValue       := {|| cCodigoBarrasDefecto( ( D():Tmp( "TmpPrvO", ::nView ) )->cRef, D():ArticulosCodigosBarras( ::nView ) ) }
         :nWidth           := 100
         :lHide            := .t.
      end with

      with object ( ::oBrwSalida:AddCol() )
         :cHeader          := "Código proveedor"
         :bEditValue       := {|| ( D():Tmp( "TmpPrvO", ::nView ) )->cRefPrv }
         :nWidth           := 80
         :lHide            := .t.
      end with

      with object ( ::oBrwSalida:AddCol() )
         :cHeader          := "Descripción"
         :cSortOrder       := "cDetalle"
         :bEditValue       := {|| if( Empty( ( D():Tmp( "TmpPrvO", ::nView ) )->cRef ) .and. !Empty( ( D():Tmp( "TmpPrvO", ::nView ) )->mLngDes ), ( D():Tmp( "TmpPrvO", ::nView ) )->mLngDes, ( D():Tmp( "TmpPrvO", ::nView ) )->cDetalle ) }
         :nWidth           := 305
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | if( !empty( oCol ), oCol:SetOrder(), ) } 
      end with

      with object ( ::oBrwSalida:AddCol() )
         :cHeader          := "Su albarán"
         :cSortOrder       := "cSuAlb"
         :bEditValue       := {|| if( !Empty( (D():Tmp( "TmpPrvO", ::nView ))->cSuAlb ),  (D():Tmp( "TmpPrvO", ::nView ))->cSuAlb , "" ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | if( !empty( oCol ), oCol:SetOrder(), ) }
      end with

      with object ( ::oBrwSalida:AddCol() )
         :cHeader          := "Prop. 1"
         :bEditValue       := {|| ( D():Tmp( "TmpPrvO", ::nView ) )->cValPr1 }
         :nWidth           := 60
         :lHide            := .t.
      end with

      with object ( ::oBrwSalida:AddCol() )
         :cHeader          := "Prop. 2"
         :bEditValue       := {|| ( D():Tmp( "TmpPrvO", ::nView ) )->cValPr2 }
         :nWidth           := 60
         :lHide            := .t.
      end with

      with object ( ::oBrwSalida:AddCol() )
         :cHeader          := "Lote"
         :bEditValue       := {|| ( D():Tmp( "TmpPrvO", ::nView ) )->cLote }
         :nWidth           := 80
         :lHide            := .t.
      end with

      with object ( ::oBrwSalida:AddCol() )
         :cHeader          := "Caducidad"
         :bEditValue       := {|| ( D():Tmp( "TmpPrvO", ::nView ) )->dFecCad }
         :nWidth           := 80
         :lHide            := .t.
      end with

      with object ( ::oBrwSalida:AddCol() )
         :cHeader          := cNombreUnidades()
         :bEditValue       := {|| nTotNAlbPrv( D():Tmp( "TmpPrvO", ::nView ) ) }
         :cEditPicture     := MasUnd()
         :nWidth           := 60
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :nFooterType      := AGGR_SUM
      end with



      with object ( ::oBrwSalida:AddCol() )
         :cHeader          := "UM. Unidad de medición"
         :bEditValue       := {|| ( D():Tmp( "TmpPrvO", ::nView ) )->cUnidad }
         :nWidth           := 25
      end with

      with object ( ::oBrwSalida:AddCol() )
         :cHeader          := "Almacen"
         :bEditValue       := {|| ( D():Tmp( "TmpPrvO", ::nView ) )->cAlmLin }
         :nWidth           := 60
      end with

      with object ( ::oBrwSalida:AddCol() )
         :cHeader          := "Importe"
         :bEditValue       := {|| nTotUAlbPrv( D():Tmp( "TmpPrvO", ::nView ), nDinDiv() ) }
         :cEditPicture     := cPinDiv()
         :nWidth           := 90
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( ::oBrwSalida:AddCol() )
         :cHeader          := "% Dto."
         :bEditValue       := {|| ( D():Tmp( "TmpPrvO", ::nView ) )->nDtoLin }
         :cEditPicture     := "@E 999.99"
         :nWidth           := 50
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( ::oBrwSalida:AddCol() )
         :cHeader          := "% Prm."
         :bEditValue       := {|| ( D():Tmp( "TmpPrvO", ::nView ) )->nDtoPrm }
         :cEditPicture     := "@E 999.99"
         :nWidth           := 40
         :lHide            := .t.
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( ::oBrwSalida:AddCol() )
         :cHeader          := "% " + cImp()
         :bEditValue       := {|| ( D():Tmp( "TmpPrvO", ::nView ) )->nIva }
         :cEditPicture     := "@E 999.99"
         :nWidth           := 50
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( ::oBrwSalida:AddCol() )
         :cHeader          := "Total"
         :bEditValue       := {|| nTotLAlbPrv( D():Tmp( "TmpPrvO", ::nView ), nDinDiv(), nRouDiv() ) }
         :cEditPicture     := cPirDiv()
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :nFooterType      := AGGR_SUM
      end with

      ::oBrwSalida:bClrSel             := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwSalida:bClrSelFocus        := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrwSalida:nMarqueeStyle       := 6
      ::oBrwSalida:lFooter             := .t.

      ::oBrwSalida:CreateFromResource( 300 )

      // Botones de para lineas------------------------------------------------

      REDEFINE BUTTON ;
         ID       210 ;
         OF       ::oDlg ;
         ACTION   ( ::passLineas( .t. ), ::recalculaTotal() )

      REDEFINE BUTTON ;
         ID       220 ;
         OF       ::oDlg ;
         ACTION   ( ::passLineas(), ::recalculaTotal() )

      REDEFINE BUTTON ;
         ID       310 ;
         OF       ::oDlg ;
         ACTION   ( ::deleteLinea(), ::recalculaTotal() )

      REDEFINE BUTTON ;
         ID       320 ;
         OF       ::oDlg ;
         ACTION   ( ::deleteLineas( .t. ), ::recalculaTotal() )

      // Botones------------------------------------------------------------------

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       ::oDlg ;
         ACTION   ( ::saveAlbaran() )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       ::oDlg ;
         CANCEL ;
         ACTION   ( ::oDlg:End() )

   ::oDlg:Activate( , , , .t., , , {|| ::StartResource() } ) 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD getSuAlb()
	
	local cSuAlb 	:= ""
	local nOrd
	local nNumAlb 	:= (D():Tmp( "TmpPrvI", ::nView ))->cSerAlb + str( (D():Tmp( "TmpPrvI", ::nView ))->nNumAlb ) + (D():Tmp( "TmpPrvI", ::nView ))->cSufAlb


	nOrd                    := ( D():AlbaranesProveedores( ::nView ) )->( OrdSetFocus( "nNumAlb" ) )


	if ( D():AlbaranesProveedores( ::nView ) )-> ( dbSeek( nNumAlb ) )
		cSuAlb 	:= ( D():AlbaranesProveedores( ::nView ) )->cSufAlb
   	end if

   (  D():AlbaranesProveedores( ::nView ) )->( OrdSetFocus( nOrd ) )

Return ( cSuAlb )

//---------------------------------------------------------------------------//

METHOD ValidArticulo()

   if cArticulo( ::oArticulo:oGetControl, D():Get( "Articulo", ::nView ), ::oArticulo:oSayControl )
      ::oPropiedad1:PropiedadActual( ( D():Articulos( ::nView ) )->cCodPrp1 )
      ::oPropiedad2:PropiedadActual( ( D():Articulos( ::nView ) )->cCodPrp2 )
   end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD StartResource()

   //::oBrwEntrada:Load()
   ::oBrwEntrada():load()

   ::oBrwSalida:Load()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD loadAlbaranes()     

   local cCodigoProveedor     := ::oProveedor:Value()

   if empty( cCodigoProveedor )
      msgStop( "Debe cumplimentar un proveedor.")
      Return .f.
   end if 

   if ( D():Tmp( "TmpPrvI", ::nView ) )->( ordkeycount() ) > 0
      if !msgYesNo(  "Ya hay registros importados," + CRLF + ;
                     "¿desea volver a importar las líneas de albaranes?" )
         Return .f.
      end if 
   end if 

   // Cursor paramos el dialogo------------------------------------------------

   Cursorwait()

   ::lImported                := .f.

   ( D():Tmp( "TmpPrvI", ::nView ) )->( __dbzap() )

   D():GetStatus( "AlbProvT", ::nView )
   
   ( D():AlbaranesProveedores( ::nView ) )->( ordsetfocus( "cCodPrv" ) )
   
   if ( D():AlbaranesProveedores( ::nView ) )->( dbSeek( cCodigoProveedor ) ) 
      while ( D():AlbaranesProveedores( ::nView ) )->cCodPrv == cCodigoProveedor // .and. !( D():Get( "AlbProvL", ::nView ) )->( eof() ) 

         if ::oPeriodo:InRange( D():AlbaranesProveedoresFecha( ::nView ) )
            ::loadAlbaran( D():AlbaranesProveedoresId( ::nView ) )
         end if

         ( D():AlbaranesProveedores( ::nView ) )->( dbskip() )

      end while
   end if 

   D():SetStatus( "AlbProvT", ::nView )

   ( D():Tmp( "TmpPrvI", ::nView ) )->( dbgotop() )

   ::oBrwEntrada:refresh()

   Cursorwe()

   if !::lImported
      msgStop( "No hay líneas de albaranes en las condiciones solicitadas.")
   end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD loadAlbaran( id )     

   if ( D():AlbaranesProveedoresLineas( ::nView ) )->( dbSeek( id ) )

      while D():AlbaranesProveedoresLineasId( ::nView ) == id .and. !( D():AlbaranesProveedoresLineas( ::nView ) )->( eof() )

         if !( D():AlbaranesProveedoresLineas( ::nView ) )->lFacturado                                                              .and. ;
            ( empty( ::oArticulo:Value() ) .or. ( D():AlbaranesProveedoresLineas( ::nView ) )->cRef == ::oArticulo:Value() )        .and. ;
            ( empty( ::oPropiedad1:Value() ) .or. ( D():AlbaranesProveedoresLineas( ::nView ) )->cValPr1 == ::oPropiedad1:Value() ) .and. ;
            ( empty( ::oPropiedad2:Value() ) .or. ( D():AlbaranesProveedoresLineas( ::nView ) )->cValPr2 == ::oPropiedad2:Value() )
            
            dbPass( D():AlbaranesProveedoresLineas( ::nView ), D():Tmp( "TmpPrvI", ::nView ), .t. )  
            
            ::lImported       := .t.

         end if 

         ( D():AlbaranesProveedoresLineas( ::nView ) )->( dbskip() )

      end while

   end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD passLineas( lSelectAll )     
   
   local nRecno

   DEFAULT lSelectAll   := .f.

   if lSelectAll
      ::oBrwEntrada:SelectAll()
   end if 

   Cursorwait()

   for each nRecno in ( ::oBrwEntrada:aSelected )

      ( ::oBrwEntrada:cAlias )->( dbgoto( nRecno ) )

      ::passLinea()

   next 

   Cursorwe()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD passLinea()     

   if ::lPassedLinea()

      msgStop( "Esta línea ya ha sido agregada a la factura.")
      Return ( Self )

   else  
      
      dbpass( ::oBrwEntrada:cAlias, ::oBrwSalida:cAlias, .t. )

   end if 

   ::oBrwEntrada:refresh()
   ::oBrwSalida:refresh()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD lPassedLinea()

   local nRecno
   local lPassedLinea   := .f.

   nRecno         := ( D():Tmp( "TmpPrvO", ::nView ) )->( recno() )

   lPassedLinea   := ( D():Tmp( "TmpPrvO", ::nView ) )->( dbSeek( ( D():Tmp( "TmpPrvI", ::nView ) )->cSerAlb + str( (  D():Tmp( "TmpPrvI", ::nView ) )->nNumAlb ) + (  D():Tmp( "TmpPrvI", ::nView ) )->cSufAlb + str( (  D():Tmp( "TmpPrvI", ::nView ) )->nNumLin ) ) )

   ( D():Tmp( "TmpPrvO", ::nView ) )->( dbgoto( nRecno ) )

Return ( lPassedLinea )

//---------------------------------------------------------------------------//

METHOD recalculaTotal()    

   local nBase    := 0
   local nIva     := 0
   local nTotal   := 0

   D():GetStatusTmp( "TmpPrvO", ::nView )

   ( D():Tmp( "TmpPrvO", ::nView ) )->( dbgotop() )

   while ( !( D():Tmp( "TmpPrvO", ::nView ) )->( eof() ) )

      nBase       += nTotLAlbPrv( D():Tmp( "TmpPrvO", ::nView ), nDinDiv(), nRouDiv() )
      nIva        += nIvaLAlbPrv( D():Tmp( "TmpPrvO", ::nView ), nDinDiv(), nRouDiv() )

      ( D():Tmp( "TmpPrvO", ::nView ) )->( dbskip() )

   end while

   nTotal         := nBase + nIva 

   ::oBase:cText( nBase )
   ::oIva:cText( nIva )
   ::oTotal:cText( nTotal )

   D():SetStatusTmp( "TmpPrvO", ::nView )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD saveAlbaran()

   ::aAlbaranesProcesados  := {}

   // Creamos la nueva factura-------------------------------------------------

   ::genNuevaFacturaProveedor()

   // Ponemos las lineas traspasadas como facturadas---------------------------

   ::setLineasFacturadas()

   // Albaranes para actualizar el estado--------------------------------------

   ::setAlbaranesFacturados()

   // Creamos nueva factura----------------------------------------------------

   ::oDlg:End()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD setLineasFacturadas()

   ( D():Tmp( "TmpPrvO", ::nView ) )->( dbgotop() )
   while ( !( D():Tmp( "TmpPrvO", ::nView ) )->( eof() ) )

      ::setLineaFacturada( ( D():Tmp( "TmpPrvO", ::nView ) )->cSerAlb + str( (  D():Tmp( "TmpPrvO", ::nView ) )->nNumAlb ) + (  D():Tmp( "TmpPrvO", ::nView ) )->cSufAlb + str( (  D():Tmp( "TmpPrvO", ::nView ) )->nNumLin ) )

      ::addAlbaranFacturado( ( D():Tmp( "TmpPrvO", ::nView ) )->cSerAlb + str( (  D():Tmp( "TmpPrvO", ::nView ) )->nNumAlb ) + (  D():Tmp( "TmpPrvO", ::nView ) )->cSufAlb )

      ( D():Tmp( "TmpPrvO", ::nView ) )->( dbskip() )

   end while

Return ( nil )

//---------------------------------------------------------------------------//

METHOD setLineaFacturada( id )

   local ordSetFocus

   ordSetFocus    := ( D():AlbaranesProveedoresLineas( ::nView ) )->( ordsetfocus( "nNumLin" ) )
   
   if ( D():AlbaranesProveedoresLineas( ::nView ) )->( dbSeek( id ) )
   
      if D():Lock( "AlbProvL", ::nView ) 
         ( D():AlbaranesProveedoresLineas( ::nView ) )->cNumFac      := ::getIdFacturaProveedor()
         ( D():AlbaranesProveedoresLineas( ::nView ) )->lFacturado   := .t.
         D():UnLock( "AlbProvL", ::nView ) 
      end if 

   end if 

   ( D():AlbaranesProveedoresLineas( ::nView ) )->( ordsetfocus( ordSetFocus ) )

Return ( nil )

//---------------------------------------------------------------------------//

METHOD setAlbaranesFacturados()

   local id

   for each id in ::aAlbaranesProcesados
      setEstadoAlbaranProveedor( id, ::nView )
   next 

Return ( nil )

//---------------------------------------------------------------------------//

METHOD genNuevaFacturaProveedor()

   ::setIdFacturaProveedor()

   ::genCabeceraFacturaProveedor()

   ::genLineasFacturaProveedor()

   ::guardaTotalesFacturaProveedor()

   ::genPagosFacturaProveedor()

Return ( nil )

//---------------------------------------------------------------------------//

METHOD setIdFacturaProveedor()

   ::cSerieFactura         := "A"
   ::nNumeroFactura        := nNewDoc( ::cSerieFactura, D():FacturasProveedores( ::nView ), "nFacPrv", , D():Contadores( ::nView ) )
   ::cSufijoFactura        := retSufEmp()

Return ( nil )

//---------------------------------------------------------------------------//

METHOD genCabeceraFacturaProveedor()

   if ( D():FacturasProveedores( ::nView ) )->( dbappend( .t. ) ) 

      ( D():FacturasProveedores( ::nView ) )->cSerFac    := ::cSerieFactura
      ( D():FacturasProveedores( ::nView ) )->nNumFac    := ::nNumeroFactura
      ( D():FacturasProveedores( ::nView ) )->cSufFac    := ::cSufijoFactura
      ( D():FacturasProveedores( ::nView ) )->dFecFac    := getSysDate()
      ( D():FacturasProveedores( ::nView ) )->cTurFac    := cCurSesion()
      ( D():FacturasProveedores( ::nView ) )->cDivFac    := cDivEmp()
      ( D():FacturasProveedores( ::nView ) )->nVdvFac    := nChgDiv( cDivEmp(), D():Divisas( ::nView ) )
      ( D():FacturasProveedores( ::nView ) )->cCodAlm    := Application():codigoAlmacen()
      ( D():FacturasProveedores( ::nView ) )->cCodCaj    := Application():CodigoCaja()
      ( D():FacturasProveedores( ::nView ) )->cCodPro    := cProCnt()
      ( D():FacturasProveedores( ::nView ) )->cCodUsr    := Auth():Codigo()
      ( D():FacturasProveedores( ::nView ) )->cCodDlg    := Application():CodigoDelegacion()
      ( D():FacturasProveedores( ::nView ) )->cCodPrv    := ::oProveedor:Value()

      ::cargaProveedor()

      ( D():FacturasProveedores( ::nView ) )->( dbUnLock() )

   end if

Return ( nil )

//---------------------------------------------------------------------------//

METHOD cargaProveedor()

   if ( D():Proveedores( ::nView ) )->( dbSeek( ( D():FacturasProveedores( ::nView ) )->cCodPrv ) )
      ( D():FacturasProveedores( ::nView ) )->cNomPrv    := ( D():Proveedores( ::nView ) )->Titulo 
      ( D():FacturasProveedores( ::nView ) )->cDirPrv    := ( D():Proveedores( ::nView ) )->Domicilio 
      ( D():FacturasProveedores( ::nView ) )->cPobPrv    := ( D():Proveedores( ::nView ) )->Poblacion 
      ( D():FacturasProveedores( ::nView ) )->cProvProv  := ( D():Proveedores( ::nView ) )->Provincia
      ( D():FacturasProveedores( ::nView ) )->cPosPrv    := ( D():Proveedores( ::nView ) )->CodPostal
      ( D():FacturasProveedores( ::nView ) )->cDniPrv    := ( D():Proveedores( ::nView ) )->Nif
   end if 

Return ( nil )

//---------------------------------------------------------------------------//

METHOD genLineasFacturaProveedor()

   ( D():Tmp( "TmpPrvO", ::nView ) )->( dbgotop() )
   while ( !( D():Tmp( "TmpPrvO", ::nView ) )->( eof() ) )

      ::insertLineaFacturaProveedor()

      ( D():Tmp( "TmpPrvO", ::nView ) )->( dbskip() )

   end while

Return ( nil )

//---------------------------------------------------------------------------//

METHOD insertLineaFacturaProveedor()

   local nNumeroLinea                                          := ( D():Tmp( "TmpPrvO", ::nView ) )->( Recno() )

   if ( D():FacturasProveedoresLineas( ::nView ) )->( dbappend( .t. ) ) 

      ( D():FacturasProveedoresLineas( ::nView ) )->cSerFac    := ::cSerieFactura
      ( D():FacturasProveedoresLineas( ::nView ) )->nNumFac    := ::nNumeroFactura
      ( D():FacturasProveedoresLineas( ::nView ) )->cSufFac    := ::cSufijoFactura
      ( D():FacturasProveedoresLineas( ::nView ) )->nNumLin    := nNumeroLinea
      ( D():FacturasProveedoresLineas( ::nView ) )->nPosPrint  := nNumeroLinea
      ( D():FacturasProveedoresLineas( ::nView ) )->cRef       := ( D():Tmp( "TmpPrvO", ::nView ) )->cRef
      ( D():FacturasProveedoresLineas( ::nView ) )->cDetalle   := ( D():Tmp( "TmpPrvO", ::nView ) )->cDetalle
      ( D():FacturasProveedoresLineas( ::nView ) )->mLngDes    := ( D():Tmp( "TmpPrvO", ::nView ) )->mLngDes
      ( D():FacturasProveedoresLineas( ::nView ) )->mNumSer    := ( D():Tmp( "TmpPrvO", ::nView ) )->mNumSer
      ( D():FacturasProveedoresLineas( ::nView ) )->nIva       := ( D():Tmp( "TmpPrvO", ::nView ) )->nIva
      ( D():FacturasProveedoresLineas( ::nView ) )->nReq       := ( D():Tmp( "TmpPrvO", ::nView ) )->nReq
      ( D():FacturasProveedoresLineas( ::nView ) )->nPreUnit   := ( D():Tmp( "TmpPrvO", ::nView ) )->nPreDiv
      ( D():FacturasProveedoresLineas( ::nView ) )->nPreCom    := ( D():Tmp( "TmpPrvO", ::nView ) )->nPreCom
      ( D():FacturasProveedoresLineas( ::nView ) )->nUniCaja   := ( D():Tmp( "TmpPrvO", ::nView ) )->nUniCaja
      ( D():FacturasProveedoresLineas( ::nView ) )->nCanEnt    := ( D():Tmp( "TmpPrvO", ::nView ) )->nCanEnt
      ( D():FacturasProveedoresLineas( ::nView ) )->nDtoLin    := ( D():Tmp( "TmpPrvO", ::nView ) )->nDtoLin
      ( D():FacturasProveedoresLineas( ::nView ) )->nDtoPrm    := ( D():Tmp( "TmpPrvO", ::nView ) )->nDtoPrm
      ( D():FacturasProveedoresLineas( ::nView ) )->nDtoRap    := ( D():Tmp( "TmpPrvO", ::nView ) )->nDtoRap
      ( D():FacturasProveedoresLineas( ::nView ) )->cAlmLin    := ( D():Tmp( "TmpPrvO", ::nView ) )->cAlmLin
      ( D():FacturasProveedoresLineas( ::nView ) )->nUndKit    := ( D():Tmp( "TmpPrvO", ::nView ) )->nUndKit
      ( D():FacturasProveedoresLineas( ::nView ) )->lKitChl    := ( D():Tmp( "TmpPrvO", ::nView ) )->lKitChl
      ( D():FacturasProveedoresLineas( ::nView ) )->lKitArt    := ( D():Tmp( "TmpPrvO", ::nView ) )->lKitArt
      ( D():FacturasProveedoresLineas( ::nView ) )->lKitPrc    := ( D():Tmp( "TmpPrvO", ::nView ) )->lKitPrc
      ( D():FacturasProveedoresLineas( ::nView ) )->lIvaLin    := ( D():Tmp( "TmpPrvO", ::nView ) )->lIvaLin
      ( D():FacturasProveedoresLineas( ::nView ) )->cCodPr1    := ( D():Tmp( "TmpPrvO", ::nView ) )->cCodPr1                           
      ( D():FacturasProveedoresLineas( ::nView ) )->cCodPr2    := ( D():Tmp( "TmpPrvO", ::nView ) )->cCodPr2                           
      ( D():FacturasProveedoresLineas( ::nView ) )->cValPr1    := ( D():Tmp( "TmpPrvO", ::nView ) )->cValPr1                           
      ( D():FacturasProveedoresLineas( ::nView ) )->cValPr2    := ( D():Tmp( "TmpPrvO", ::nView ) )->cValPr2                           
      ( D():FacturasProveedoresLineas( ::nView ) )->nBnfLin1   := ( D():Tmp( "TmpPrvO", ::nView ) )->nBnfLin1
      ( D():FacturasProveedoresLineas( ::nView ) )->nBnfLin2   := ( D():Tmp( "TmpPrvO", ::nView ) )->nBnfLin2
      ( D():FacturasProveedoresLineas( ::nView ) )->nBnfLin3   := ( D():Tmp( "TmpPrvO", ::nView ) )->nBnfLin3
      ( D():FacturasProveedoresLineas( ::nView ) )->nBnfLin4   := ( D():Tmp( "TmpPrvO", ::nView ) )->nBnfLin4
      ( D():FacturasProveedoresLineas( ::nView ) )->nBnfLin5   := ( D():Tmp( "TmpPrvO", ::nView ) )->nBnfLin5
      ( D():FacturasProveedoresLineas( ::nView ) )->nBnfLin6   := ( D():Tmp( "TmpPrvO", ::nView ) )->nBnfLin6
      ( D():FacturasProveedoresLineas( ::nView ) )->lBnfLin1   := ( D():Tmp( "TmpPrvO", ::nView ) )->lBnfLin1
      ( D():FacturasProveedoresLineas( ::nView ) )->lBnfLin2   := ( D():Tmp( "TmpPrvO", ::nView ) )->lBnfLin2
      ( D():FacturasProveedoresLineas( ::nView ) )->lBnfLin3   := ( D():Tmp( "TmpPrvO", ::nView ) )->lBnfLin3
      ( D():FacturasProveedoresLineas( ::nView ) )->lBnfLin4   := ( D():Tmp( "TmpPrvO", ::nView ) )->lBnfLin4
      ( D():FacturasProveedoresLineas( ::nView ) )->lBnfLin5   := ( D():Tmp( "TmpPrvO", ::nView ) )->lBnfLin5
      ( D():FacturasProveedoresLineas( ::nView ) )->lBnfLin6   := ( D():Tmp( "TmpPrvO", ::nView ) )->lBnfLin6
      ( D():FacturasProveedoresLineas( ::nView ) )->nPvpLin1   := ( D():Tmp( "TmpPrvO", ::nView ) )->nPvpLin1
      ( D():FacturasProveedoresLineas( ::nView ) )->nPvpLin2   := ( D():Tmp( "TmpPrvO", ::nView ) )->nPvpLin2
      ( D():FacturasProveedoresLineas( ::nView ) )->nPvpLin3   := ( D():Tmp( "TmpPrvO", ::nView ) )->nPvpLin3
      ( D():FacturasProveedoresLineas( ::nView ) )->nPvpLin4   := ( D():Tmp( "TmpPrvO", ::nView ) )->nPvpLin4
      ( D():FacturasProveedoresLineas( ::nView ) )->nPvpLin5   := ( D():Tmp( "TmpPrvO", ::nView ) )->nPvpLin5
      ( D():FacturasProveedoresLineas( ::nView ) )->nPvpLin6   := ( D():Tmp( "TmpPrvO", ::nView ) )->nPvpLin6
      ( D():FacturasProveedoresLineas( ::nView ) )->nIvaLin1   := ( D():Tmp( "TmpPrvO", ::nView ) )->nIvaLin1
      ( D():FacturasProveedoresLineas( ::nView ) )->nIvaLin2   := ( D():Tmp( "TmpPrvO", ::nView ) )->nIvaLin2
      ( D():FacturasProveedoresLineas( ::nView ) )->nIvaLin3   := ( D():Tmp( "TmpPrvO", ::nView ) )->nIvaLin3
      ( D():FacturasProveedoresLineas( ::nView ) )->nIvaLin4   := ( D():Tmp( "TmpPrvO", ::nView ) )->nIvaLin4
      ( D():FacturasProveedoresLineas( ::nView ) )->nIvaLin5   := ( D():Tmp( "TmpPrvO", ::nView ) )->nIvaLin5
      ( D():FacturasProveedoresLineas( ::nView ) )->nIvaLin6   := ( D():Tmp( "TmpPrvO", ::nView ) )->nIvaLin6
      ( D():FacturasProveedoresLineas( ::nView ) )->lLote      := ( D():Tmp( "TmpPrvO", ::nView ) )->lLote
      ( D():FacturasProveedoresLineas( ::nView ) )->nLote      := ( D():Tmp( "TmpPrvO", ::nView ) )->nLote
      ( D():FacturasProveedoresLineas( ::nView ) )->cLote      := ( D():Tmp( "TmpPrvO", ::nView ) )->cLote
      ( D():FacturasProveedoresLineas( ::nView ) )->mObsLin    := ( D():Tmp( "TmpPrvO", ::nView ) )->mObsLin
      ( D():FacturasProveedoresLineas( ::nView ) )->cRefPrv    := ( D():Tmp( "TmpPrvO", ::nView ) )->cRefPrv
      ( D():FacturasProveedoresLineas( ::nView ) )->cUnidad    := ( D():Tmp( "TmpPrvO", ::nView ) )->cUnidad
      ( D():FacturasProveedoresLineas( ::nView ) )->nNumMed    := ( D():Tmp( "TmpPrvO", ::nView ) )->nNumMed
      ( D():FacturasProveedoresLineas( ::nView ) )->nMedUno    := ( D():Tmp( "TmpPrvO", ::nView ) )->nMedUno
      ( D():FacturasProveedoresLineas( ::nView ) )->nMedDos    := ( D():Tmp( "TmpPrvO", ::nView ) )->nMedDos
      ( D():FacturasProveedoresLineas( ::nView ) )->nMedTre    := ( D():Tmp( "TmpPrvO", ::nView ) )->nMedTre
      ( D():FacturasProveedoresLineas( ::nView ) )->dFecCad    := ( D():Tmp( "TmpPrvO", ::nView ) )->dFecCad
      ( D():FacturasProveedoresLineas( ::nView ) )->nBultos    := ( D():Tmp( "TmpPrvO", ::nView ) )->nBultos
      ( D():FacturasProveedoresLineas( ::nView ) )->cFormato   := ( D():Tmp( "TmpPrvO", ::nView ) )->cFormato
      ( D():FacturasProveedoresLineas( ::nView ) )->iNumAlb    := ( D():Tmp( "TmpPrvO", ::nView ) )->cSerAlb + str( ( D():Tmp( "TmpPrvO", ::nView ) )->nNumAlb, 9 ) + ( D():Tmp( "TmpPrvO", ::nView ) )->cSufAlb + str( ( D():Tmp( "TmpPrvO", ::nView ) )->nNumLin, 4 )
      ( D():FacturasProveedoresLineas( ::nView ) )->cAlmOrigen := ( D():Tmp( "TmpPrvO", ::nView ) )->cAlmOrigen

      ( D():FacturasProveedoresLineas( ::nView ) )->( dbUnLock() )

   end if

Return ( nil )

//---------------------------------------------------------------------------//

METHOD guardaTotalesFacturaProveedor()

   local structTotal    := structTotalFacturaProveedoresVista( ::getIdFacturaProveedor(), ::nView )

   if ( D():FacturasProveedores( ::nView ) )->( dbseek( ::getIdFacturaProveedor() ) ) .and. ( D():FacturasProveedores( ::nView ) )->( dbrlock() ) 

      ( D():FacturasProveedores( ::nView ) )->nTotNet  := structTotal:nTotalNeto
      ( D():FacturasProveedores( ::nView ) )->nTotSup  := structTotal:nTotalSuplidos
      ( D():FacturasProveedores( ::nView ) )->nTotIva  := structTotal:nTotalIva
      ( D():FacturasProveedores( ::nView ) )->nTotReq  := structTotal:nTotalRecargoEquivalencia
      ( D():FacturasProveedores( ::nView ) )->nTotFac  := structTotal:nTotalDocumento
      
      ( D():FacturasProveedores( ::nView ) )->( dbunlock() ) 

   end if       

Return ( nil )

//---------------------------------------------------------------------------//

METHOD genPagosFacturaProveedor()

   genPgoFacPrv( ::getIdFacturaProveedor(), D():FacturasProveedores( ::nView ), D():FacturasProveedoresLineas( ::nView ), D():FacturasProveedoresPagos( ::nView ), D():Proveedores( ::nView ), D():TiposIva( ::nView ), D():FormasPago( ::nView ), D():Divisas( ::nView ) )

Return ( nil )

//---------------------------------------------------------------------------//




