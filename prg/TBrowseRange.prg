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

   METHOD addController( oController ) INLINE ( aAdd( ::aControllers, oController ) )

   METHOD validColumnTo( oGet ) 

   METHOD ResizeColumns()

END CLASS 

//---------------------------------------------------------------------------//

METHOD New( idBrowse, oContainer ) CLASS BrowseRange

   ::idBrowse                          := idBrowse
   
   ::oContainer                        := oContainer
   
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS BrowseRange
   
RETURN ( aeval( ::aControllers, {| oController | oController:End() } ) )

//---------------------------------------------------------------------------//

METHOD Resource() CLASS BrowseRange

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
      :bEditValid    := {| oGet | ::validColumnTo( oGet ) }
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

   if ::oBrwRango:MouseColPos( nCol ) == 6
      msgalert( "filtrar" )         
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD validColumnTo( oGet ) CLASS BrowseRange

   if empty( ::oBrwRango:aRow:getRange():uFrom )
      errorAlert( "Debe seleccionar un valor 'Desde'" )
      RETURN ( .f. )
   end if

RETURN ( ::oBrwRango:aRow:getRange():validCode( oGet ) )

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

   ::lAll                              := .f.

   ::uFrom                             := space( 20 )

   ::uTo                               := space( 20 )

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
//---------------------------------------------------------------------------//

CLASS ContadoresItemRange FROM ItemRange
   
   METHOD showNombre( cCode )          INLINE ( '' )
      
   METHOD extractCode( uValue )        INLINE ( if( hb_ishash( uValue ), hget( uValue, "serie" ), uValue ) )
         
   METHOD ValidCode( uValue ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD ValidCode( uValue ) CLASS ContadoresItemRange

   if hb_isobject( uValue )
      RETURN ( ::oController:getModel():isWhereSerie( uValue:varGet(), ::oController:cScope ) )
   end if 

RETURN ( ::oController:getModel():isWhereSerie( uValue, ::oController:cScope ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
