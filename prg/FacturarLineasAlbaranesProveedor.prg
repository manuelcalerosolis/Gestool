#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Xbrowse.ch"

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

   DATA tmpEntrada
   DATA tmpSalida

   METHOD New( nView )

   METHOD Resource()
   METHOD startResource()

   METHOD buildBrowse( oBrw, id )

   METHOD CreaTemporales()
   METHOD CierraTemporales()

   METHOD loadAlbaranes()     
   METHOD loadAlbaran( id )    

   METHOD passLineas()     
   METHOD passLinea()     

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
   ::oArticulo:oGetControl:bValid   := {||   ::oPropiedad1:PriedadActual( ( D():Articulos( ::oContainer:nView ) )->cCodPr1 ),;
                                             ::oPropiedad2:PriedadActual( ( D():Articulos( ::oContainer:nView ) )->cCodPr2 ) }

   ::oPropiedad1     := GetPropiedadActual():Build( { "idGet" => 170, "idSay" => 171, "oContainer" => Self } )

   ::oPropiedad2     := GetPropiedadActual():Build( { "idGet" => 180, "idSay" => 181, "oContainer" => Self } )

   ::oPeriodo        := GetPeriodo():Build( { "idCombo" => 100, "idFechaInicio" => 110, "idFechaFin" => 120, "oContainer" => Self } )

   // Creamos los temporales necesarios-------------------------------------------

   ::CreaTemporales()

   // Montamos el recurso---------------------------------------------------------

   ::Resource()

   // Destruimos las temporales---------------------------------------------------

   ::CierraTemporales()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Resource() CLASS TFacturarLineasAlbaranesProveedor

   DEFINE DIALOG ::oDlg RESOURCE "FacturaLineasCompletasAlbaranes"

      aEval( ::aComponents, {| o | o:Resource() } )

      TBtnBmp():ReDefine( 150, "Recycle_16",,,,, {|| ::loadAlbaranes() }, ::oDlg, .f., , .f. )

      // Browse de lineas de entradas------------------------------------------

      ::oBrwEntrada           := IXBrowse():New( ::oDlg )
      ::oBrwEntrada:cAlias    := D():GetAreaTmp( "TmpPrvI", ::nView )
      ::oBrwEntrada:cName     := "Lineas de albaranes a proveedor entradas"

      ::buildBrowse( ::oBrwEntrada, 200 )

      // Browse de lineas de entradas------------------------------------------

      ::oBrwSalida            := IXBrowse():New( ::oDlg )
      ::oBrwSalida:cAlias     := D():GetAreaTmp( "TmpPrvO", ::nView )
      ::oBrwSalida:cName      := "Lineas de albaranes a proveedor salidas"

      ::buildBrowse( ::oBrwSalida, 300 )

      // Botones------------------------------------------------------------------

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       ::oDlg ;
         ACTION   ( ::oDlg:End() )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       ::oDlg ;
         CANCEL ;
         ACTION   ( ::oDlg:End() )

   ::oDlg:Activate( , , , .t., , , {|| ::StartResource() } ) //::InitResource() } )

   ::oBrwEntrada:Save()
   ::oBrwSalida:Save()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD StartResource()

   ::oBrwEntrada:Load()

   ::oBrwSalida:Load()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD CreaTemporales()

   D():BuildTmp( "AlbProvL", "TmpPrvI", ::nView ) 

   D():BuildTmp( "AlbProvL", "TmpPrvO", ::nView ) 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD CierraTemporales()

   D():CloseTmp( "TmpPrvI", ::nView ) 

   D():CloseTmp( "TmpPrvO", ::nView ) 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD loadAlbaranes()     

   local cCodigoProveedor     := ::oProveedor:Value()

   if empty( cCodigoProveedor )
      msgStop( "Debe cumplimentar un proveedor.")
      Return .f.
   end if 

   if ( D():GetAreaTmp( "TmpPrvI", ::nView ) )->( ordkeycount() ) > 0
      if !msgYesNo(  "Ya hay registros importados," + hb_eol() + ;
                     "¿desea volver a importar las líneas de albaranes?" )
         Return .f.
      end if 
   end if 

   // Cursor paramos el dialogo------------------------------------------------

   Cursorwait()

   ::lImported                := .f.

   ( D():GetAreaTmp( "TmpPrvI", ::nView ) )->( __dbzap() )

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

   ( D():GetAreaTmp( "TmpPrvI", ::nView ) )->( dbgotop() )

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
            ( empty( ::oPropiedad1:Value() ) .or. ( D():AlbaranesProveedoresLineas( ::nView ) )->cCodPr1 == ::oPropiedad1:Value() ) .and. ;
            ( empty( ::oPropiedad2:Value() ) .or. ( D():AlbaranesProveedoresLineas( ::nView ) )->cCodPr2 == ::oPropiedad2:Value() )
            
            dbPass( D():AlbaranesProveedoresLineas( ::nView ), D():GetAreaTmp( "TmpPrvI", ::nView ), .t. )  
            
            ::lImported       := .t.

         end if 

         ( D():AlbaranesProveedoresLineas( ::nView ) )->( dbskip() )

      end while

   end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD buildBrowse( oBrw, id )

   with object ( oBrw )

      :bClrSel             := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      :bClrSelFocus        := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      :nMarqueeStyle       := 6
      :lFooter             := .t.

      with object ( :AddCol() )
         :cHeader          := "Albarán"
         :bEditValue       := {|| ( oBrw:cAlias )->cSerAlb + "/" + Alltrim( Str( ( oBrw:cAlias )->nNumAlb ) ) }
         :nWidth           := 80
      end with

      with object ( :AddCol() )
         :cHeader          := "Núm"
         :bEditValue       := {|| if( ( oBrw:cAlias )->lKitChl, "", Trans( ( oBrw:cAlias )->nNumLin, "9999" ) ) }
         :nWidth           := 40
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( :AddCol() )
         :cHeader          := "Código"
         :bEditValue       := {|| ( oBrw:cAlias )->cRef }
         :nWidth           := 80
      end with

      with object ( :AddCol() )
         :cHeader          := "C. Barras"
         :bEditValue       := {|| cCodigoBarrasDefecto( ( oBrw:cAlias )->cRef, D():ArticulosCodigosBarras( ::nView ) ) }
         :nWidth           := 100
         :lHide            := .t.
      end with

      with object ( :AddCol() )
         :cHeader          := "Código proveedor"
         :bEditValue       := {|| ( oBrw:cAlias )->cRefPrv }
         :nWidth           := 80
         :lHide            := .t.
      end with

      with object ( :AddCol() )
         :cHeader          := "Descripción"
         :bEditValue       := {|| if( Empty( ( oBrw:cAlias )->cRef ) .and. !Empty( ( oBrw:cAlias )->mLngDes ), ( oBrw:cAlias )->mLngDes, ( oBrw:cAlias )->cDetalle ) }
         :nWidth           := 305
      end with

      with object ( :AddCol() )
         :cHeader          := "Prop. 1"
         :bEditValue       := {|| ( oBrw:cAlias )->cValPr1 }
         :nWidth           := 60
         :lHide            := .t.
      end with

      with object ( :AddCol() )
         :cHeader          := "Prop. 2"
         :bEditValue       := {|| ( oBrw:cAlias )->cValPr2 }
         :nWidth           := 60
         :lHide            := .t.
      end with

      with object ( :AddCol() )
         :cHeader          := "Lote"
         :bEditValue       := {|| ( oBrw:cAlias )->cLote }
         :nWidth           := 80
         :lHide            := .t.
      end with

      with object ( :AddCol() )
         :cHeader          := "Caducidad"
         :bEditValue       := {|| ( oBrw:cAlias )->dFecCad }
         :nWidth           := 80
         :lHide            := .t.
      end with

      with object ( :AddCol() )
         :cHeader          := "Pedido cliente"
         :bEditValue       := {|| if( !Empty( ( oBrw:cAlias )->cNumPed ), Trans( ( oBrw:cAlias )->cNumPed, "@R #/#########/##" ), "" ) }
         :nWidth           := 80
         :lHide            := .t.
      end with

      with object ( :AddCol() )
         :cHeader          := "Cliente"
         :bEditValue       := {|| if( !Empty( (:cAlias)->cNumPed ), GetCliente( (:cAlias)->cNumPed ), "" ) }
         :nWidth           := 180
         :lHide            := .t.
      end with

      with object ( :AddCol() )
         :cHeader          := cNombreUnidades()
         :bEditValue       := {|| nTotNAlbPrv( oBrw:cAlias ) }
         :cEditPicture     := MasUnd()
         :nWidth           := 60
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :nFooterType      := AGGR_SUM
      end with

      with object ( :AddCol() )
         :cHeader          := "UM. Unidad de medición"
         :bEditValue       := {|| ( oBrw:cAlias )->cUnidad }
         :nWidth           := 25
      end with

      with object ( :AddCol() )
         :cHeader          := "Almacen"
         :bEditValue       := {|| ( oBrw:cAlias )->cAlmLin }
         :nWidth           := 60
      end with

      with object ( :AddCol() )
         :cHeader          := "Importe"
         :bEditValue       := {|| nTotUAlbPrv( :cAlias, nDinDiv() ) }
         :cEditPicture     := cPinDiv()
         :nWidth           := 90
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( :AddCol() )
         :cHeader          := "% Dto."
         :bEditValue       := {|| ( oBrw:cAlias )->nDtoLin }
         :cEditPicture     := "@E 999.99"
         :nWidth           := 50
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( :AddCol() )
         :cHeader          := "% Prm."
         :bEditValue       := {|| ( oBrw:cAlias )->nDtoPrm }
         :cEditPicture     := "@E 999.99"
         :nWidth           := 40
         :lHide            := .t.
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( :AddCol() )
         :cHeader          := "% " + cImp()
         :bEditValue       := {|| ( oBrw:cAlias )->nIva }
         :cEditPicture     := "@E 999.99"
         :nWidth           := 50
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( :AddCol() )
         :cHeader          := "Total"
         :bEditValue       := {|| nTotLAlbPrv( :cAlias, nDinDiv(), nRouDiv() ) }
         :cEditPicture     := cPirDiv()
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :nFooterType      := AGGR_SUM
      end with

      :CreateFromResource( id )

   end with

Return ( Self )

//---------------------------------------------------------------------------//

METHOD passLineas()     

   Cursorwait()

   ( D():GetAreaTmp( "TmpPrvI", ::nView ) )->( dbgotop() )
   while ( !( D():GetAreaTmp( "TmpPrvI", ::nView ) )->( eof() ) )

      ::passLinea()

      ( D():GetAreaTmp( "TmpPrvI", ::nView ) )->( dbskip() )

   end while

   Cursorwe()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD passLinea()     

   Cursorwait()

   dbpass( D():GetAreaTmp( "TmpPrvI", ::nView ), D():GetAreaTmp( "TmpPrvO", ::nView ), .t. )
   dbDel(  D():GetAreaTmp( "TmpPrvI", ::nView ) )

   ::oBrwEntrada:refresh()
   ::oBrwSalida:refresh()

   Cursorwe()

Return ( Self )

//---------------------------------------------------------------------------//
