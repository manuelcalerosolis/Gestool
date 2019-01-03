#include "FiveWin.ch"
#include "Factu.ch" 
#include "Xbrowse.ch" 

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS IvaDetalleView FROM SQLBaseView

   DATA oBrowseIva
  
   METHOD Activate( aIvaDetalle )

END CLASS

//---------------------------------------------------------------------------//
 
METHOD Activate( aIvaDetalle ) CLASS IvaDetalleView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "DETALLE_IVA" ;
      TITLE       "Detalle de IVA"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getTipoIvaController():getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog 

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog 

   ::oBrowseIva   := TXBrowse():New( ::oDialog )

   ::oBrowseIva:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrowseIva:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrowseIva:setArray( aIvaDetalle, , , .f. )

   ::oBrowseIva:nMarqueeStyle          := 5
   ::oBrowseIva:lRecordSelector        := .f.
   ::oBrowseIva:lHScroll               := .f.

   ::oBrowseIva:CreateFromResource( 100 )

   with object ( ::oBrowseIva:AddCol() )
      :cHeader          := "Base"
      :bEditValue       := {|| hget( aIvaDetalle[ ::oBrowseIva:nArrayAt ], "total_neto" ) }
      :cEditPicture     := "@E 99999999.999999"
      :nWidth           := 76
      :nDataStrAlign    := 1
      :nHeadStrAlign    := 1
      :nFootStrAlign    := 1
   end with
   
   with object ( ::oBrowseIva:AddCol() )
      :cHeader          := "IVA %"
      :bEditValue       := {|| hget( aIvaDetalle[ ::oBrowseIva:nArrayAt ], "porcentaje_iva" ) }
      :cEditPicture     := "@E 999.99"
      :nWidth           := 44
      :nDataStrAlign    := 1
      :nHeadStrAlign    := 1
   end with

   with object ( ::oBrowseIva:AddCol() )
      :cHeader          := "IVA "
      :bEditValue       := {|| hget( aIvaDetalle[ ::oBrowseIva:nArrayAt ], "total_iva" ) }
      :cEditPicture     := "@E 99999999.999999"
      :nWidth           := 76
      :nDataStrAlign    := 1
      :nHeadStrAlign    := 1
   end with

   with object ( ::oBrowseIva:AddCol() )
      :cHeader          := "R.E. %"
      :bEditValue       := {|| hget( aIvaDetalle[ ::oBrowseIva:nArrayAt ], "recargo_equivalencia" ) }
      :cEditPicture     := "@E 999.99"
      :nWidth           := 44
      :nDataStrAlign    := 1
      :nHeadStrAlign    := 1
   end with

   with object ( ::oBrowseIva:AddCol() )
      :cHeader          := "R.E."
      :bEditValue       := {|| hget( aIvaDetalle[ ::oBrowseIva:nArrayAt ], "total_recargo" ) }
      :cEditPicture     := "@E 99999999.999999"
      :nWidth           := 76
      :nDataStrAlign    := 1
      :nHeadStrAlign    := 1
   end with

   ApoloBtnFlat():Redefine( IDOK, {|| ::oDialog:end( IDOK ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//