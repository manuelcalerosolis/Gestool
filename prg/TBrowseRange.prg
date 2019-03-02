#include "FiveWin.Ch"

//---------------------------------------------------------------------------//

CLASS BrowseRange

   DATA idBrowse

   DATA oContainer

   DATA oController

   DATA oBrwRango

   DATA oColNombre
   DATA oColDesde
   DATA oColHasta
   DATA oColFilter

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD Resource()

   METHOD Clicked( nRow, nCol ) 

   METHOD postEditDesde( oGet ) 

   METHOD postEditHasta( oGet ) 

   METHOD resizeColumns()

END CLASS 

//---------------------------------------------------------------------------//

METHOD New( idBrowse, oContainer, oController ) CLASS BrowseRange

   ::idBrowse                          := idBrowse
   
   ::oContainer                        := oContainer

   ::oController                       := oController
   
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS BrowseRange

   if !empty( ::oBrwRango )
      ::oBrwRango:End()
   end if 
   
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Resource() CLASS BrowseRange

   ::oBrwRango                      := IXBrowse():New( ::oContainer )

   ::oBrwRango:bClrSel              := {|| { CLR_BLACK, rgb( 229, 229, 229 ) } }
   ::oBrwRango:bClrSelFocus         := {|| { CLR_BLACK, rgb( 144, 202, 249 ) } }

   ::oBrwRango:SetArray( ::oController:aControllers, , , .f. )

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
      aeval( ::oController:aControllers, {| oController | :addResource( hget( oController:hImage, "16" ) ) } )
   end with

   with object ( ::oColDesde := ::oBrwRango:AddCol() )
      :cHeader       := "Desde"
      :nEditType     := EDIT_GET_BUTTON
      :bEditValue    := {|| ::oBrwRango:aRow:getRange():uFrom }
      :bEditBlock    := {|| ::oBrwRango:aRow:ActivateSelectorView() }
      :bEditValid    := {| oGet | ::oBrwRango:aRow:getRange():validCode( oGet ) }
      :bOnPostEdit   := {| oCol, uNewValue | ::postEditDesde( uNewValue ) }
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
      :nEditType     := EDIT_GET_BUTTON
      :bEditValue    := {|| ::oBrwRango:aRow:getRange():uTo }
      :bEditBlock    := {|| ::oBrwRango:aRow:ActivateSelectorView() }
      :bOnPostEdit   := {| oCol, uNewValue | ::postEditHasta( uNewValue ) }
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

   with object ( ::oColFilter := ::oBrwRango:AddCol() )
      :cHeader       := "Fitrar"         
      :nEditType     := EDIT_BUTTON
      :bStrData      := {|| if( ::oBrwRango:aRow:getFilterController():isEmptyFilter(), "", "Activo" ) }
      :bEditValue    := {|| if( ::oBrwRango:aRow:getFilterController():isEmptyFilter(), "", "Activo" ) }
      :bEditBlock    := {|| ::oBrwRango:aRow:getFilterController():Edit() }
      :bClrStd       := {|| { CLR_HRED, CLR_WHITE } }
      :nWidth        := 100
      :Cargo         := 0.10
      :nBtnBmp       := 1
      :AddResource( "gc_funnel_add_16" )
   end with

RETURN .t.

//---------------------------------------------------------------------------//

METHOD ResizeColumns() CLASS BrowseRange

   ::oBrwRango:CheckSize()

   aeval( ::oBrwRango:aCols, {|o, n, oCol| o:nWidth := ::oBrwRango:nWidth * o:Cargo } )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD Clicked( nRow, nCol ) CLASS BrowseRange

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD postEditDesde( uNewValue )

   ::oBrwRango:aRow:getRange():setFrom( uNewValue ) 

   if empty( uNewValue )
      ::oBrwRango:aRow:getRange():setTo( uNewValue )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD postEditHasta( uNewValue ) CLASS BrowseRange

   if empty( ::oBrwRango:aRow:getRange():getFrom() )
      ::oController:getConversorView():showMessage( "Debe seleccionar un valor 'Desde'" )
      RETURN ( nil )
   end if

   if ::oBrwRango:aRow:getRange():validCode( uNewValue )
      ::oBrwRango:aRow:getRange():setTo( uNewValue )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ItemRange

   DATA oController

   DATA cKey                           INIT 'codigo'

   DATA cCode                          INIT 'codigo'

   DATA uFrom
   DATA uTo

   DATA cTable 

   METHOD New( oController )           CONSTRUCTOR
      
   METHOD End()                        VIRTUAL

   METHOD getKey()                     INLINE ( ::cKey )
         
   METHOD ValidCode( uVal )

   METHOD extractValue( uValue )        

   METHOD showNombre( cCode )          

   METHOD getFrom()                    INLINE ( if( empty( ::uFrom ), "", alltrim( ::uFrom ) ) )
   METHOD setFrom( uFrom )             INLINE ( ::uFrom := ::extractValue( uFrom ) )
   METHOD showFromNombre()             INLINE ( ::showNombre( ::uFrom ) )
      
   METHOD getTo()                      INLINE ( if( empty( ::uTo ), "", alltrim( ::uTo ) ) )
   METHOD setTo( uTo )                 INLINE ( ::uTo := ::extractValue( uTo ) )
   METHOD showToNombre()               INLINE ( ::showNombre( ::uTo ) )

   METHOD getTable()                   INLINE ( if( empty( ::cTable ), ::oController:getModel():getTable(), ::cTable ) )
   METHOD setTable( cTable )           INLINE ( ::cTable := cTable )

   METHOD getKey()                     INLINE ( ::getTable() + "." + ::cKey )

   METHOD getWhere()
   
   METHOD getWhereAnd()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS ItemRange

   ::oController                       := oController

   ::uFrom                             := space( 20 )

   ::uTo                               := space( 20 )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD extractValue( uValue ) CLASS ItemRange
   
   if hb_isobject( uValue )
      RETURN ( uValue:varGet() )
   end if 

   if hb_ishash( uValue )
      RETURN ( hget( uValue, ::cCode ) )
   end if 

RETURN ( uValue )

//---------------------------------------------------------------------------//

METHOD ValidCode( uValue ) CLASS ItemRange

   uValue   := ::extractValue( uValue )

   if empty( uValue ) 
      RETURN ( .t. )
   end if 

RETURN ( ::oController:getModel():isWhereCodigo( uValue ) )

//---------------------------------------------------------------------------//

METHOD showNombre( cCode ) CLASS ItemRange

   if !empty( cCode )
      RETURN ( ::oController:getModel():getNombreWhereCodigo( cCode ) )
   end if

RETURN ( '' )

//---------------------------------------------------------------------------//

METHOD getWhere() CLASS ItemRange

   local cWhere   := ""
      
   if empty( ::getFrom() )
      RETURN ( cWhere )
   end if 

   if empty( ::getTo() )
      cWhere      := ::getKey() + " = " + quoted( ::getFrom() ) + " "
      RETURN ( cWhere )
   end if 

   cWhere         := "( " + ::getKey() + " >= " + quoted( ::getFrom() ) + " "
   cWhere         += " AND " + ::getKey() + " <= " + quoted( ::getTo() ) + " ) "

RETURN ( cWhere )

//---------------------------------------------------------------------------//

METHOD getWhereAnd() CLASS ItemRange

   local cWhere   := ::getWhere()

   if empty( cWhere )
      RETURN ( cWhere )
   end if 

RETURN ( " AND " + cWhere )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

