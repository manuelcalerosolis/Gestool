#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Xbrowse.ch"

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

   DATA aAlbaranesProcesados  INIT {}

   METHOD New( nView )

   METHOD Resource()
   METHOD validArticulo()
   METHOD startResource()

   METHOD CreaTemporales()
   METHOD CierraTemporales()

   METHOD loadAlbaranes()     
   METHOD loadAlbaran( id )    
   
   METHOD saveAlbaran()    
      METHOD setLineasFacturadas()
      METHOD setLineaFacturada()
      METHOD addAlbaranFacturado( id )      
      METHOD setAlbaranesFacturados()

   METHOD passLineas()     
   METHOD passLinea()     

   METHOD lPassedLinea()      

   METHOD deleteLineas()      INLINE ( ::oBrwSalida:SelectAll(), ::deleteLinea() )
   METHOD deleteLinea()       INLINE ( dbdel( D():Tmp( "TmpPrvO", ::nView ) ), ::oBrwSalida:refresh(), ::oBrwEntrada:refresh() )

   METHOD recalculaTotal()    

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
                        "tagBlock" => {|| Field->cSerAlb + str( Field->nNumAlb ) + Field->cSufAlb + str( Field->nNumLin ) } } },;
                  ::nView ) 


   D():BuildTmp(  "AlbProvL",;
                  "TmpPrvO",;
                  {  {  "tagName" => "nNumAlb" ,;
                        "tagExpresion" => "cSerAlb + str( nNumAlb ) + cSufAlb + str( nNumLin )",;
                        "tagBlock" => {|| Field->cSerAlb + str( Field->nNumAlb ) + Field->cSufAlb + str( Field->nNumLin ) } } },;
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

      aEval( ::aComponents, {| o | o:Resource() } )

      TBtnBmp():ReDefine( 150, "Recycle_16",,,,, {|| ::loadAlbaranes() }, ::oDlg, .f., , .f. )

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
         :bEditValue       := {|| if( Empty( ( D():Tmp( "TmpPrvI", ::nView ) )->cRef ) .and. !Empty( ( D():Tmp( "TmpPrvI", ::nView ) )->mLngDes ), ( D():Tmp( "TmpPrvI", ::nView ) )->mLngDes, ( D():Tmp( "TmpPrvI", ::nView ) )->cDetalle ) }
         :nWidth           := 305
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
         :bEditValue       := {|| if( Empty( ( D():Tmp( "TmpPrvO", ::nView ) )->cRef ) .and. !Empty( ( D():Tmp( "TmpPrvO", ::nView ) )->mLngDes ), ( D():Tmp( "TmpPrvO", ::nView ) )->mLngDes, ( D():Tmp( "TmpPrvO", ::nView ) )->cDetalle ) }
         :nWidth           := 305
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

METHOD ValidArticulo()

   if cArticulo( ::oArticulo:oGetControl, D():Get( "Articulo", ::nView ), ::oArticulo:oSayControl )
      ::oPropiedad1:PropiedadActual( ( D():Articulos( ::nView ) )->cCodPrp1 )
      ::oPropiedad2:PropiedadActual( ( D():Articulos( ::nView ) )->cCodPrp2 )
   end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD StartResource()

   ::oBrwEntrada:Load()

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

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD setLineaFacturada( id )

   local ordSetFocus

   ordSetFocus    := ( D():AlbaranesProveedoresLineas( ::nView ) )->( ordsetfocus( "nNumLin" ) )
   
   if ( D():AlbaranesProveedoresLineas( ::nView ) )->( dbSeek( id ) )
   
      if D():Lock( "AlbProvL", ::nView ) 
         ( D():AlbaranesProveedoresLineas( ::nView ) )->lFacturado   := .t.
         D():UnLock( "AlbProvL", ::nView ) 
      end if 

   end if 

   ( D():AlbaranesProveedoresLineas( ::nView ) )->( ordsetfocus( ordSetFocus ) )

Return ( nil )

//---------------------------------------------------------------------------//

METHOD addAlbaranFacturado( id )

   if aScan( ::aAlbaranesProcesados, id ) == 0
      aAdd( ::aAlbaranesProcesados, id )
   end if 

Return ( nil )

//---------------------------------------------------------------------------//

METHOD setAlbaranesFacturados()

   local id

   for each id in ::aAlbaranesProcesados
      msgAlert( getFacturadoAlbaranProveedor(id), id )
   next 

Return ( nil )

//---------------------------------------------------------------------------//
