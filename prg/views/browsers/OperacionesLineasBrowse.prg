#include "FiveWin.Ch"
#include "Factu.Ch"
#include "Xbrowse.Ch"

//------------------------------------------------------------------------//

CLASS OperacionesLineasBrowseView FROM SQLBrowseView

   DATA lFastEdit                      INIT .t.

   DATA lFooter                        INIT .t.

   DATA nMarqueeStyle                  INIT 3

   DATA nColSel                        INIT 2

   DATA oColumnCodigoArticulo

   DATA oColumnUnidadMedicion

   DATA oColumnCodigoAlmacen

   DATA oColumnArticuloPrecio

   DATA oColumnCodigoUbicacion

   DATA oColumnPropiedades

   METHOD Create( oWindow )

   METHOD addColumns()                 VIRTUAL

   METHOD setOnCancelEdit()

   METHOD keyChar( nKey )

   METHOD getEditButton()              INLINE ( if( ::getSuperController():isNotZoomMode(), EDIT_GET_BUTTON, 0 ) )
   
   METHOD getEditGet()                 INLINE ( if( ::getSuperController():isNotZoomMode(), EDIT_GET, 0 ) )

   METHOD getEditListBox()             INLINE ( if( ::getSuperController():isNotZoomMode(), EDIT_GET_LISTBOX, 0 ) )

   METHOD setFocusColumnCodigoArticulo() ;
                                       INLINE ( ::oBrowse:setFocus(), ::oBrowse:goToCol( ::oColumnCodigoArticulo ) )

   METHOD setFocusColumnCodigoAlmacen() ;
                                       INLINE ( ::oBrowse:setFocus(), ::oBrowse:goToCol( ::oColumnCodigoAlmacen ) )

   METHOD setFocusColumnCodigoUbicacion() ;
                                       INLINE ( ::oBrowse:setFocus(), ::oBrowse:goToCol( ::oColumnCodigoUbicacion ) )

   METHOD setFocusColumnPropiedades()  INLINE ( ::oBrowse:setFocus(), ::oBrowse:goToCol( ::oColumnPropiedades ) )

   METHOD activateUbicacionesSelectorView()  VIRTUAL  

ENDCLASS

//----------------------------------------------------------------------------//

METHOD Create( oWindow ) CLASS OperacionesLineasBrowseView 

   ::Super:Create( oWindow )

   ::oBrowse:bOnSkip       := {|| ::getController():validLine() }

   ::oBrowse:bKeyChar      := {| nKey | ::keyChar( nKey ) }

   ::oBrowse:setChange( {|| ::getController():getHistoryManager():Set( ::getRowSet():getValuesAsHash() ) } )

   ::oBrowse:setGotFocus( {|| ::getController():getHistoryManager():Set( ::getRowSet():getValuesAsHash() ) } )

RETURN ( ::oBrowse )

//---------------------------------------------------------------------------//

METHOD setOnCancelEdit() CLASS OperacionesLineasBrowseView

RETURN ( ::getController():validLine() )   

//---------------------------------------------------------------------------//

METHOD keyChar( nKey ) CLASS OperacionesLineasBrowseView

   if nKey != VK_EXECUTE
      RETURN ( nil )
   end if 

   if !empty( ::oBrowse:SelectedCol() ) .and. !empty( ::oBrowse:SelectedCol():bEditBlock )
      ::oBrowse:SelectedCol():runBtnAction( nKey )
   end if 

RETURN ( nil )   

//---------------------------------------------------------------------------//

