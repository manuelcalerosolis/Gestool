#include "FiveWin.Ch"

//---------------------------------------------------------------------------//

CLASS BrowseRange

   DATA idBrowse

   DATA oContainer

   DATA aControllers                   INIT {}

   DATA oBrwRango
   DATA oColNombre
   DATA oColDesde
   DATA oColHasta

   METHOD New()
   METHOD Resource()

   METHOD AddController( oController ) INLINE ( aAdd( ::aControllers, oController ) )

   METHOD EditValueTextDesde()         INLINE ( Eval( ::aControllers[ ::oBrwRango:nArrayAt ]:HelpDesde ) )
   METHOD EditValueTextHasta()         INLINE ( Eval( ::aControllers[ ::oBrwRango:nArrayAt ]:HelpHasta ) )
   METHOD EditTextDesde()              INLINE ( Eval( ::aControllers[ ::oBrwRango:nArrayAt ]:TextDesde ) )
   METHOD EditTextHasta()              INLINE ( Eval( ::aControllers[ ::oBrwRango:nArrayAt ]:TextHasta ) )

   METHOD ValidValueTextDesde( oGet )  INLINE ( Eval( ::aControllers[ ::oBrwRango:nArrayAt ]:ValidDesde, oGet ) )
   METHOD ValidValueTextHasta( oGet )  INLINE ( Eval( ::aControllers[ ::oBrwRango:nArrayAt ]:ValidHasta, oGet ) )

   METHOD ResizeColumns()

END CLASS 

//---------------------------------------------------------------------------//

METHOD New( idBrowse, oContainer ) CLASS BrowseRange

   ::idBrowse     := idBrowse
   
   ::oContainer   := oContainer
   
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource() CLASS BrowseRange

   local o

   ::oBrwRango                      := IXBrowse():New( ::oContainer )

   ::oBrwRango:bClrSel              := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwRango:bClrSelFocus         := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrwRango:SetArray( ::aControllers, , , .f. )

   ::oBrwRango:lHScroll             := .f.
   ::oBrwRango:lVScroll             := .f.
   ::oBrwRango:lRecordSelector      := .t.
   ::oBrwRango:lFastEdit            := .t.

   ::oBrwRango:nFreeze              := 1
   ::oBrwRango:nMarqueeStyle        := 3

   ::oBrwRango:nColSel              := 2

   ::oBrwRango:CreateFromResource( ::idBrowse )

   ::oColNombre                     := ::oBrwRango:AddCol()
   ::oColNombre:cHeader             := ""
   ::oColNombre:bStrData            := {|| ::oBrwRango:aRow:cTitle }
   ::oColNombre:bBmpData            := {|| ::oBrwRango:nArrayAt }
   ::oColNombre:nWidth              := 200
   ::oColNombre:Cargo               := 0.20

   for each o in ::aControllers
      ::oColNombre:AddResource( hget( o:hImage, "16" ) )
   next

   with object ( ::oColDesde := ::oBrwRango:AddCol() )
      :cHeader       := "Desde"
      :bEditValue    := {|| ::aControllers[ ::oBrwRango:nArrayAt ]:Desde }
      :bOnPostEdit   := {|o,x| ::aControllers[ ::oBrwRango:nArrayAt ]:Desde := x }
      :bEditValid    := {|oGet| ::ValidValueTextDesde( oGet ) }
      :bEditBlock    := {|| ::EditValueTextDesde() }
      :cEditPicture  := "@!"
      :nEditType     := 5
      :nWidth        := 120
      :Cargo         := 0.15
      :nBtnBmp       := 1
      :AddResource( "Lupa" )
   end with
/*
   with object ( ::oBrwRango:AddCol() )
      :cHeader       := ""
      :bEditValue    := {|| ::EditTextDesde() } 
      :nEditType     := 0
      :nWidth        := 200
      :Cargo         := 0.25
   end with

   with object ( ::oColHasta := ::oBrwRango:AddCol() )
      :cHeader       := "Hasta"
      :bEditValue    := {|| ::aControllers[ ::oBrwRango:nArrayAt ]:Hasta }
      :bOnPostEdit   := {|o,x| ::aControllers[ ::oBrwRango:nArrayAt ]:Hasta := x }
      :bEditValid    := {|oGet| ::ValidValueTextHasta( oGet ) }
      :bEditBlock    := {|| ::EditValueTextHasta() }
      :cEditPicture  := "@!"
      :nEditType     := 5
      :nWidth        := 120
      :Cargo         := 0.15
      :nBtnBmp       := 1
      :AddResource( "Lupa" )
   end with

   with object ( ::oBrwRango:AddCol() )
      :cHeader       := ""
      :bEditValue    := {|| ::EditTextHasta() }
      :nEditType     := 0
      :nWidth        := 200
      :Cargo         := 0.25
   end with
*/
RETURN .t.

//---------------------------------------------------------------------------//

METHOD ResizeColumns() CLASS BrowseRange

   ::oBrwRango:CheckSize()

   aeval( ::oBrwRango:aCols, {|o, n, oCol| o:nWidth := ::oBrwRango:nWidth * o:Cargo } )

RETURN .t.

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ItemRange

   DATA Expresion

   DATA Valor

   DATA lAll
   DATA uFrom
   DATA uTo

   DATA HelpDesde
   DATA HelpHasta

   DATA ValidDesde
   DATA ValidHasta

   DATA TextDesde
   DATA TextHasta

   DATA Imagen
   DATA bCondition
   DATA lImprimir

   DATA cPicDesde
   DATA cPicHasta

   DATA cBitmap

   DATA bValidMayorIgual
   DATA bValidMenorIgual

   METHOD ValidMayorIgual( uVal, uMayor )
   METHOD ValidMenorIgual( uVal, uMenor )

   METHOD GetDesde()                   INLINE ( if( Empty( ::Desde ), "", alltrim( ::Desde ) ) )
   METHOD GetHasta()                   INLINE ( if( Empty( ::Hasta ), "", alltrim( ::Hasta ) ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS TItemGroup

   ::oController                       := oController

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ValidMayorIgual( uVal, uMayor ) CLASS TItemGroup

   if IsBlock( ::bValidMayorIgual )
      Return ( Eval( ::bValidMayorIgual, uVal, uMayor ) )
   end if

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD ValidMenorIgual( uVal, uMenor ) CLASS ItemRange

   if IsBlock( ::bValidMenorIgual )
      Return ( Eval( ::bValidMenorIgual, uVal, uMenor ) )
   end if

Return ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosItemRange FROM ItemRange



