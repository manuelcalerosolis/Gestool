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

   METHOD New() CONSTRUCTOR
   METHOD End()

   METHOD Resource()

   METHOD Clicked( nRow, nCol ) 

   METHOD getEditButton()              INLINE ( if( ::oBrwRango:aRow:getRange():lAll, 0, EDIT_GET_BUTTON ) )

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

METHOD End() CLASS BrowseRange

   aeval( ::aControllers, {| oController | oController:End() } )
   
RETURN ( nil )

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

   ::oBrwRango:nColSel              := 3

   ::oBrwRango:bLClicked            := {| nRow, nCol| ::Clicked( nRow, nCol ) }

   ::oBrwRango:CreateFromResource( ::idBrowse )

   with object ( ::oColNombre := ::oBrwRango:AddCol() )
      :cHeader       := ""
      :bStrData      := {|| ::oBrwRango:aRow:cTitle }
      :bBmpData      := {|| ::oBrwRango:nArrayAt }
      :nWidth        := 200
      :Cargo         := 0.20
      aeval( ::aControllers, {| oController | :addResource( hget( oController:hImage, "16" ) ) } )
   end with

   with object ( ::oColAll := ::oBrwRango:AddCol() )
      :cHeader       := "Todo"         
      :bStrData      := {|| "" }
      :bEditValue    := {|| ::oBrwRango:aRow:getRange():lAll }
      :nWidth        := 40
      :Cargo         := 0.10
      :SetCheck( { "Sel16", "Cnt16" } )
   end with

   with object ( ::oColDesde := ::oBrwRango:AddCol() )
      :cHeader       := "Desde"
      :nEditType     := ::getEditButton()
      :bEditValue    := {|| ::oBrwRango:aRow:getRange():uFrom }
      :bEditBlock    := {|| ::oBrwRango:aRow:ActivateSelectorView() }
      :bEditValid    := {| oGet | ::oBrwRango:aRow:getRange():validCode( oGet ) }
      :bOnPostEdit   := {| oCol, uNewValue | ::oBrwRango:aRow:getRange():setFrom( uNewValue ) }
      :cEditPicture  := "@!"
      :nWidth        := 120
      :Cargo         := 0.10
      :nBtnBmp       := 1
      :AddResource( "Lupa" )
   end with
   
   with object ( ::oBrwRango:AddCol() )
      :cHeader       := ""
      :bEditValue    := {|| ::oBrwRango:aRow:getRange():showFromNombre() } 
      :nEditType     := 0
      :nWidth        := 200
      :Cargo         := 0.25
   end with

   with object ( ::oColHasta := ::oBrwRango:AddCol() )
      :cHeader       := "Hasta"
      :nEditType     := ::getEditButton()
      :bEditValue    := {|| ::oBrwRango:aRow:getRange():uTo }
      :bEditBlock    := {|| ::oBrwRango:aRow:ActivateSelectorView() }
      :bEditValid    := {| oGet | ::oBrwRango:aRow:getRange():validCode( oGet ) }
      :bOnPostEdit   := {| oCol, uNewValue | ::oBrwRango:aRow:getRange():setTo( uNewValue ) }
      :cEditPicture  := "@!"
      :nWidth        := 120
      :Cargo         := 0.15
      :nBtnBmp       := 1
      :AddResource( "Lupa" )
   end with

   with object ( ::oBrwRango:AddCol() )
      :cHeader       := ""
      :bEditValue    := {|| ::oBrwRango:aRow:getRange():showToNombre() } 
      :nEditType     := 0
      :nWidth        := 200
      :Cargo         := 0.25
   end with

   with object ( ::oColAll := ::oBrwRango:AddCol() )
      :cHeader       := "Fitrar"         
      :bStrData      := {|| "" }
      :bEditValue    := {|| ::oBrwRango:aRow:getRange():lAll }
      :bOnPostEdit   := {|o,x| ::oBrwRango:aRow:getRange():lAll := x }
      :nWidth        := 40
      :Cargo         := 0.10
      :SetCheck( { "gc_funnel_add_16", "gc_funnel_broom_16" } )
   end with

RETURN .t.

//---------------------------------------------------------------------------//

METHOD ResizeColumns() CLASS BrowseRange

   ::oBrwRango:CheckSize()

   aeval( ::oBrwRango:aCols, {|o, n, oCol| o:nWidth := ::oBrwRango:nWidth * o:Cargo } )

RETURN .t.

//---------------------------------------------------------------------------//

METHOD Clicked( nRow, nCol ) CLASS BrowseRange

   local nSelectedColumn   := ::oBrwRango:MouseColPos( nCol ) 

   do case
      case nSelectedColumn == 2

         ::oBrwRango:aRow:getRange():toogleAll() 

         ::oColDesde:nEditType( ::getEditButton() )

         ::oColHasta:nEditType( ::getEditButton() ) 

         ::oBrwRango:Refresh()

      case nSelectedColumn == 7

         msgalert( "filtrar" )         

   endcase

RETURN ( nil )

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
   
   METHOD New( oController )           CONSTRUCTOR
      
   METHOD End()                        VIRTUAL
         
   METHOD ValidCode( uVal )

   METHOD extractCode( uValue )        INLINE ( if( hb_ishash( uValue ), hget( uValue, "codigo" ), uValue ) )

   METHOD showNombre( cCode )          

   METHOD getFrom()                    INLINE ( if( empty( ::uFrom ), "", alltrim( ::uFrom ) ) )
   METHOD setFrom( uFrom )             INLINE ( ::uFrom := ::extractCode( uFrom ) )
   METHOD showFromNombre()             INLINE ( ::showNombre( ::uFrom ) )
      
   METHOD getTo()                      INLINE ( if( empty( ::uTo ), "", alltrim( ::uTo ) ) )
   METHOD setTo( uTo )                 INLINE ( ::uTo := ::extractCode( uTo ) )
   METHOD showToNombre()               INLINE ( ::showNombre( ::uTo ) )

   METHOD toogleAll()               

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS ItemRange

   ::oController                       := oController

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ValidCode( uValue ) CLASS ItemRange

   if hb_isobject( uValue )
      RETURN ( ::oController:getModel():isWhereCodigo( uValue:varGet() ) )
   end if 

RETURN ( ::oController:getModel():isWhereCodigo( uValue ) )

//---------------------------------------------------------------------------//

METHOD showNombre( cCode ) CLASS ItemRange

   if !empty( cCode )
      RETURN ( ::oController:getModel():getNombreWhereCodigo( cCode ) )
   end if

RETURN ( '' )

//---------------------------------------------------------------------------//

METHOD toogleAll() CLASS ItemRange

   ::lAll   := !::lAll

   if ::lAll
      ::setFrom( space( 20 ) )
      ::setTo( space( 20 ) )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosItemRange FROM ItemRange

   METHOD New( oController ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS ArticulosItemRange

   ::lAll                              := .f.

   ::uFrom                             := space( 20 )

   ::uTo                               := replicate( 'Z', 20 )

RETURN ( ::Super:New( oController ) )

//---------------------------------------------------------------------------//

