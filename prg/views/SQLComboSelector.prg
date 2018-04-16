#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS ComboSelector

   DATA oController

   DATA idLink

   DATA idCombobox

   DATA oDialog

   DATA oUrlLink
   
   DATA oComboBox
   DATA cComboBox                               
   DATA aComboBox

   DATA nColorUrlLink

   DATA bValue

   METHOD New( oSender )

   METHOD Activate( idLink, idCombobox, oDlg )
   METHOD Bind( bValue )                        INLINE ( ::bValue := bValue )

   METHOD cargaDatos()

   METHOD ResourceLink()
   METHOD ActionLink()

   METHOD ResourceComboBox()
   METHOD ChangeComboBox()

   METHOD moveSelectorView()

   METHOD Refresh()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS ComboSelector

   ::oController     := oSender

   ::nColorUrlLink   := nRGB( 51, 102, 187 )
   
   ::cComboBox       := ""

   ::oController:setEvent( 'appended', {|| ::Refresh() } )
   ::oController:setEvent( 'edited',   {|| ::Refresh() } )
   ::oController:setEvent( 'deleted',  {|| ::Refresh() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Activate( idLink, idCombobox, oDlg ) CLASS ComboSelector

   ::idLink          := idLink

   ::idCombobox      := idCombobox

   ::oDialog         := oDlg

   ::cargaDatos()

   ::ResourceLink()

   ::ResourceComboBox()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD cargaDatos() CLASS ComboSelector

   ::aComboBox       := ::oController:oRepository:getNombres()

   ::cComboBox       := ::oController:oRepository:getNombreWhereUuid( eval( ::bValue ) ) 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ResourceLink() CLASS ComboSelector

   ::oUrlLink              := TUrlLink():Redefine( ::idLink, ::oDialog, , , , , ::nColorUrlLink, ::nColorUrlLink, ::nColorUrlLink, .t. )
   ::oUrlLink:bAction      := {|| ::ActionLink() }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ResourceComboBox() CLASS ComboSelector
   
   ::oComboBox             := TComboBox():ReDefine( ::idCombobox, bSETGET( ::cComboBox ), ::aComboBox, ::oDialog,,, {|| ::ChangeComboBox() } , , , , .f., {|| .t. } )
   ::oComboBox:lIncSearch  := .t.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ActionLink() CLASS ComboSelector

   local hResult     

   ::oController:oSelectorView:bInitActivate := {|| ::moveSelectorView() }

   hResult                                   := ::oController:ActivateSelectorViewNoCenter()

   if hb_isnil( hResult )
      RETURN ( Self )
   end if 

   if hHaskey( hResult, "uuid" )
      eval( ::bValue, hGet( hResult, "uuid" ) )
   end if

   if hHaskey( hResult, "nombre" )
      ::oComboBox:set( hGet( hResult, "nombre" ) )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD moveSelectorView() CLASS ComboSelector

   local nRow
   local nCol
   local aRect
   local nScreenWidth   := GetSysMetrics( 0 )

   aRect                := ClientToScreen( ::oComboBox:hWnd )

   nRow                 := aRect[ 1 ] + ::oComboBox:nHeight + 1

   nCol                 := aRect[ 2 ]

   if ( nCol + ::oController:oSelectorView:oDialog:nWidth() ) > nScreenWidth
      nCol              -= ( ::oController:oSelectorView:oDialog:nWidth() - ::oComboBox:nWidth() )
   end if 

   ::oController:oSelectorView:oDialog:Move( nRow, nCol )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ChangeComboBox() CLASS ComboSelector

   eval( ::bValue, ::oController:oRepository:getUuidWhereNombre( ::cComboBox ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Refresh()

   if empty( ::oComboBox )
      RETURN ( Self )
   end if 
   
   ::oComboBox:setItems( ::oController:oRepository:getNombres() )

RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//