#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ContadoresController FROM SQLNavigatorController

   DATA cScope                         INIT ''

   METHOD New() CONSTRUCTOR

   METHOD End()

   // Construcciones tardias---------------------------------------------------

   METHOD getBrowseView()              INLINE ( iif( empty( ::oBrowseView ), ::oBrowseView := ContadoresBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getModel()                   INLINE ( iif( empty( ::oModel ), ::oModel := SQLContadoresModel():New( self ), ), ::oModel )

   METHOD getRange()                   INLINE ( iif( empty( ::oRange ), ::oRange := ContadoresItemRange():New( self ), ), ::oRange )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController) CLASS ContadoresController

   ::Super:New( oController )

   ::lTransactional                    := .f.

   ::cTitle                            := "Series"

   ::cName                             := "contadores"

   ::hImage                            := {  "16" => "gc_sort_az_descending_16",;
                                             "32" => "gc_sort_az_descending_32",;
                                             "48" => "gc_sort_az_descending_48" }

   ::getSelectorView():getMenuTreeView():setEvents( { 'addingDuplicateButton',;
                                                      'addingAppendButton',;
                                                      'addingEditButton',;
                                                      'addingZoomButton',;
                                                      'addingShowDeleteButton',;
                                                      'addingDeleteButton' }, {|| .f. } )

   ::getModel():setGeneralWhere( "documento = '" + ::cScope + "'" )                                                      

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ContadoresController

    if !empty( ::oModel )
      ::oModel:End()
   end if 

    if !empty( ::oRange )
      ::oRange:End()
   end if 

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
   end if 

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

CLASS ContadoresAlbaranesVentasController FROM ContadoresController 

   DATA cScope                         INIT 'albaranes_venta'

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ContadoresBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS ContadoresBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "serie"
      :cHeader             := "Serie"
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( "serie" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

#ifdef __TEST__

CLASS TestContadoresController FROM TestCase

   DATA oController

   METHOD beforeClass()

   METHOD afterClass()

   METHOD Before() 
   
END CLASS

//---------------------------------------------------------------------------//

METHOD beforeClass() CLASS TestContadoresController

   ::oController                       := ContadoresController():New()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD afterClass() CLASS TestContadoresController

RETURN ( ::oController:end() )

//---------------------------------------------------------------------------//

METHOD Before() CLASS TestContadoresController

   SQLContadoresModel():truncateTable()

RETURN ( nil )

//---------------------------------------------------------------------------//

#endif