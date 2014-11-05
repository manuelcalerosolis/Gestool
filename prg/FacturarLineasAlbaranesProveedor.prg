#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Xbrowse.ch"

//---------------------------------------------------------------------------//

CLASS TFacturarLineasAlbaranesProveedor FROM DialogBuilder

   DATA cPath

   DATA lPrint

   DATA oProveedor
   DATA oPeriodo

   DATA oBrwEntrada

   DATA tmpEntrada
   DATA tmpSalida

   METHOD New( nView )

   METHOD Resource()

   METHOD CreaTemporales()
   METHOD CierraTemporales()

   METHOD loadAlbaranes()     INLINE ( msgAlert("loadAlbaranes"))

END CLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS TFacturarLineasAlbaranesProveedor

   ::nView           := nView

   // Comprobaciones antes de entrar----------------------------------------------

   if ::nView < 1
      msgStop( "La vista creada no es válida" )
      Return .f.
   end if

   // Tomamos los valores iniciales-----------------------------------------------

   ::lPrint          := .f.

   // Valores iniciales ----------------------------------------------------------

   ::oProveedor      := GetProveedor():Build( { "idGet" => 130, "idSay" => 140, "oContainer" => Self } )

   ::oPeriodo        := GetPeriodo():Build( { "idCombo" => 100, "idFechaInicio" => 110, "idFechaFin" => 120, "oContainer" => Self } )

   // Creamos los temporales necesarios-------------------------------------------

   ::CreaTemporales()

   // Montamos el recurso---------------------------------------------------------

   ::Resource()

   // Destruimos las temporales---------------------------------------------------

   ::CierraTemporales()

Return ( ::lPrint )

//---------------------------------------------------------------------------//

METHOD Resource() CLASS TFacturarLineasAlbaranesProveedor

   DEFINE DIALOG ::oDlg RESOURCE "FacturaLineasCompletasAlbaranes"

      aEval( ::aComponents, {| o | o:Resource() } )

      TBtnBmp():ReDefine( 150, "Recycle_16",,,,, {|| ::loadAlbaranes() }, ::oDlg, .f., , .f. )

      // Browse de lineas de entradas------------------------------------------

      with object ( ::oBrwEntrada := IXBrowse():New( ::oDlg ) )

         :bClrSel             := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
         :bClrSelFocus        := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

         :cAlias              := D():GetAreaTmp( "TmpPrvI", ::nView )

         :nMarqueeStyle       := 6
         :lFooter             := .t.
         :cName               := "Lineas de albaranes a proveedor entradas"

         with object ( :AddCol() )
            :cHeader          := "Albaran"
            :bEditValue       := {|| ( D():AlbaranesProveedores( nView ) )->cSerAlb + "/" + Alltrim( Str( ( ( ::oBrwEntrada:cAlias ) )->nNumAlb ) ) }
            :nWidth           := 80
         end with

         with object ( :AddCol() )
            :cHeader          := "Número"
            :bEditValue       := {|| if( ( ::oBrwEntrada:cAlias )->lKitChl, "", Trans( ( ::oBrwEntrada:cAlias )->nNumLin, "9999" ) ) }
            :nWidth           := 65
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         with object ( :AddCol() )
            :cHeader          := "Código"
            :bEditValue       := {|| ( ::oBrwEntrada:cAlias )->cRef }
            :nWidth           := 80
         end with

         with object ( :AddCol() )
            :cHeader          := "C. Barras"
            :bEditValue       := {|| cCodigoBarrasDefecto( ( ::oBrwEntrada:cAlias )->cRef, D():ArticulosCodigosBarras( ::nView ) ) }
            :nWidth           := 100
            :lHide            := .t.
         end with

         with object ( :AddCol() )
            :cHeader          := "Código proveedor"
            :bEditValue       := {|| ( ::oBrwEntrada:cAlias )->cRefPrv }
            :nWidth           := 80
            :lHide            := .t.
         end with

         with object ( :AddCol() )
            :cHeader          := "Descripción"
            :bEditValue       := {|| if( Empty( ( ::oBrwEntrada:cAlias )->cRef ) .and. !Empty( ( ::oBrwEntrada:cAlias )->mLngDes ), ( ::oBrwEntrada:cAlias )->mLngDes, ( ::oBrwEntrada:cAlias )->cDetalle ) }
            :nWidth           := 305
         end with

         with object ( :AddCol() )
            :cHeader          := "Prop. 1"
            :bEditValue       := {|| ( ::oBrwEntrada:cAlias )->cValPr1 }
            :nWidth           := 60
            :lHide            := .t.
         end with

         with object ( :AddCol() )
            :cHeader          := "Prop. 2"
            :bEditValue       := {|| ( ::oBrwEntrada:cAlias )->cValPr2 }
            :nWidth           := 60
            :lHide            := .t.
         end with

         with object ( :AddCol() )
            :cHeader          := "Lote"
            :bEditValue       := {|| ( ::oBrwEntrada:cAlias )->cLote }
            :nWidth           := 80
            :lHide            := .t.
         end with

         with object ( :AddCol() )
            :cHeader          := "Caducidad"
            :bEditValue       := {|| ( ::oBrwEntrada:cAlias )->dFecCad }
            :nWidth           := 80
            :lHide            := .t.
         end with

         with object ( :AddCol() )
            :cHeader          := "Pedido cliente"
            :bEditValue       := {|| if( !Empty( ( ::oBrwEntrada:cAlias )->cNumPed ), Trans( ( ::oBrwEntrada:cAlias )->cNumPed, "@R #/#########/##" ), "" ) }
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
            :bEditValue       := {|| nTotNAlbPrv( ::oBrwEntrada:cAlias ) }
            :cEditPicture     := MasUnd()
            :nWidth           := 60
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
            :nFooterType      := AGGR_SUM
         end with

         with object ( :AddCol() )
            :cHeader          := "UM. Unidad de medición"
            :bEditValue       := {|| ( ::oBrwEntrada:cAlias )->cUnidad }
            :nWidth           := 25
         end with

         with object ( :AddCol() )
            :cHeader          := "Almacen"
            :bEditValue       := {|| ( ::oBrwEntrada:cAlias )->cAlmLin }
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
            :bEditValue       := {|| ( ::oBrwEntrada:cAlias )->nDtoLin }
            :cEditPicture     := "@E 999.99"
            :nWidth           := 50
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         with object ( :AddCol() )
            :cHeader          := "% Prm."
            :bEditValue       := {|| ( ::oBrwEntrada:cAlias )->nDtoPrm }
            :cEditPicture     := "@E 999.99"
            :nWidth           := 40
            :lHide            := .t.
            :nDataStrAlign    := 1
            :nHeadStrAlign    := 1
         end with

         with object ( :AddCol() )
            :cHeader          := "% " + cImp()
            :bEditValue       := {|| ( ::oBrwEntrada:cAlias )->nIva }
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

         :CreateFromResource( 200 )

      end with

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

   ::oDlg:Activate( , , , .t., , , {|| msginfo( "abriendo el recurso" ) } ) //::InitResource() } )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD CreaTemporales()

   D():BuildTmp( "AlbProvL", "TmpPrvI", ::nView ) 

   ::tmpEntrada   := D():GetAreaTmp( "TmpPrvI", ::nView )

   D():BuildTmp( "AlbProvL", "TmpPrvO", ::nView ) 

   ::tmpSalida    := D():GetAreaTmp( "TmpPrvI", ::nView )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD CierraTemporales()

   D():CloseTmp( "TmpPrvI", ::nView ) 

   D():CloseTmp( "TmpPrvO", ::nView ) 

Return ( Self )

//---------------------------------------------------------------------------//
