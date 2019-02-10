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
   DATA oColAll

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

   ::oBrwRango:bClrSel              := {|| { CLR_BLACK, rgb( 229, 229, 229 ) } }
   ::oBrwRango:bClrSelFocus         := {|| { CLR_BLACK, rgb( 144, 202, 249 ) } }

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

   with object ( ::oColAll := ::oBrwRango:AddCol() )
      :cHeader       := "Todo"         
      :bStrData      := {|| "" }
      :bEditValue    := {|| ::oBrwRango:aRow:getRange():lAll }
      :bOnPostEdit   := {|o,x| ::oBrwRango:aRow:getRange():lAll := x }
      :nWidth        := 40
      :Cargo         := 0.10
      :SetCheck( { "Sel16", "Cnt16" } )
   end with

   with object ( ::oColDesde := ::oBrwRango:AddCol() )
      :cHeader       := "Desde"
      :bEditValue    := {|| ::oBrwRango:aRow:getRange():uFrom }
      // :bEditValid    := {|oGet| ::ValidValueTextDesde( oGet ) }
      // :bEditBlock    := {|| ::EditValueTextDesde() }
      :cEditPicture  := "@!"
      :nEditType     := 5
      :nWidth        := 120
      :Cargo         := 0.10
      :nBtnBmp       := 1
      :AddResource( "Lupa" )
   end with

   with object ( ::oBrwRango:AddCol() )
      :cHeader       := ""
      :bEditValue    := {|| ::EditTextDesde() } 
      :nEditType     := 0
      :nWidth        := 200
      :Cargo         := 0.25
   end with

   with object ( ::oColHasta := ::oBrwRango:AddCol() )
      :cHeader       := "Hasta"
      :bEditValue    := {|| ::oBrwRango:aRow:getRange():uTo }
      // :bOnPostEdit   := {|o,x| ::aControllers[ ::oBrwRango:nArrayAt ]:Hasta := x }
      // :bEditValid    := {|oGet| ::ValidValueTextHasta( oGet ) }
      // :bEditBlock    := {|| ::EditValueTextHasta() }
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

   DATA oController

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

   METHOD New( oController )

   METHOD End()                        VIRTUAL

   METHOD ValidMayorIgual( uVal, uMayor )
   METHOD ValidMenorIgual( uVal, uMenor )

   METHOD GetDesde()                   INLINE ( if( Empty( ::Desde ), "", alltrim( ::Desde ) ) )
   METHOD GetHasta()                   INLINE ( if( Empty( ::Hasta ), "", alltrim( ::Hasta ) ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS ItemRange

   ::oController                       := oController

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ValidMayorIgual( uVal, uMayor ) CLASS ItemRange

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

   METHOD New( oController ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS ArticulosItemRange

   ::lAll                              := .t.

   ::uFrom                             := space( 20 )

   ::uTo                               := replicate( 'Z', 20 )

RETURN ( ::Super:New( oController ) )

//---------------------------------------------------------------------------//

