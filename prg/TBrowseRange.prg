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

   METHOD postEditHasta( oGet ) 

   METHOD resizeColumns()

END CLASS 

//---------------------------------------------------------------------------//

METHOD New( idBrowse, oContainer, oController ) CLASS BrowseRange

   ::idBrowse                          := idBrowse
   
   ::oContainer                        := oContainer

   ::oController                        := oController
   
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

   DATA uFrom
   DATA uTo

   DATA cAlias 

   METHOD New( oController )           CONSTRUCTOR
      
   METHOD End()                        VIRTUAL

   METHOD getKey()                     INLINE ( ::cKey )
         
   METHOD ValidCode( uVal )

   METHOD extractCode( uValue )        INLINE ( if( hb_ishash( uValue ), hget( uValue, "codigo" ), uValue ) )

   METHOD showNombre( cCode )          

   METHOD getFrom()                    INLINE ( if( empty( ::uFrom ), "", alltrim( ::uFrom ) ) )
   METHOD setFrom( uFrom )             INLINE ( ::uFrom := ::extractCode( uFrom ) )
   METHOD showFromNombre()             INLINE ( ::showNombre( ::uFrom ) )
      
   METHOD getTo()                      INLINE ( if( empty( ::uTo ), "", alltrim( ::uTo ) ) )
   METHOD setTo( uTo )                 INLINE ( ::uTo := ::extractCode( uTo ) )
   METHOD showToNombre()               INLINE ( ::showNombre( ::uTo ) )

   METHOD getAlias()                   INLINE ( if( empty( ::cAlias ), ::oController:getModel():getAlias(), ::cAlias ) )
   METHOD setAlias( cAlias )           INLINE ( ::cAlias := cAlias )

   METHOD getKey()                     INLINE ( ::getAlias() + "." + ::cKey )

   METHOD getWhere()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS ItemRange

   ::oController                       := oController

   ::uFrom                             := space( 20 )

   ::uTo                               := space( 20 )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ValidCode( uValue ) CLASS ItemRange

   if hb_isobject( uValue )
      uValue   := uValue:varGet()
   end if 

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
      cWhere      := " AND " + ::getKey() + " = " + quoted( ::getFrom() ) + " "
      RETURN ( cWhere )
   end if 

   cWhere         := " AND ( " + ::getKey() + " >= " + quoted( ::getFrom() ) + " "
   cWhere         += " AND " + ::getKey() + " <= " + quoted( ::getTo() ) + " ) "

RETURN ( cWhere )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

