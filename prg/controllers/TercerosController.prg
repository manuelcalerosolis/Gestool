#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TercerosController FROM SQLNavigatorController

   DATA oDireccionesController
   DATA oPaisesController
   DATA oProvinciasController

   METHOD New()

   /*METHOD DireccionesControllerLoadCurrentBuffer()

   METHOD DireccionesControllerUpdateBuffer()

   METHOD DireccionesControllerDeleteBuffer()

   METHOD DireccionesControllerLoadedDuplicateCurrentBuffer()

   METHOD DireccionesControllerLoadedDuplicateBuffer()*/

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS TercerosController

   ::Super:New()

   ::cTitle                      := ""

   ::cName                       := ""

   ::hImage                      := {=>}

   ::nLevel                      := Auth():Level( ::cName )

   ::oBrowseView                 := TercerosBrowseView():New( self )

   ::oDialogView                 := TercerosView():New( self )

   ::oValidator                  := TercerosValidator():New( self, ::oDialogView )

   //::oDireccionesController      := DireccionesController():New( self )

   ::oRepository                 := TercerosRepository():New( self )

   //::oPaisesController           := PaisesController():New( self )
   //::oProvinciasController       := ProvinciasController():New( self )

   ::oComboSelector              := ComboSelector():New( self )

   //::oFilterController:setTableToFilter( ::oModel:cTableName )

   /*::oModel:setEvent( 'loadedBlankBuffer',            {|| ::oDireccionesController:oModel:loadBlankBuffer() } )
   ::oModel:setEvent( 'insertedBuffer',               {|| ::oDireccionesController:oModel:insertBuffer() } )
   
   ::oModel:setEvent( 'loadedCurrentBuffer',          {|| ::DireccionesControllerLoadCurrentBuffer() } )
   ::oModel:setEvent( 'updatedBuffer',                {|| ::DireccionesControllerUpdateBuffer() } )

   ::oModel:setEvent( 'loadedDuplicateCurrentBuffer', {|| ::DireccionesControllerLoadedDuplicateCurrentBuffer() } )
   ::oModel:setEvent( 'loadedDuplicateBuffer',        {|| ::DireccionesControllerLoadedDuplicateBuffer() } )
   
   ::oModel:setEvent( 'deletedSelection',             {|| ::DireccionesControllerDeleteBuffer() } )*/

RETURN ( Self )

//---------------------------------------------------------------------------//

/*METHOD DireccionesControllerLoadCurrentBuffer()

   local idDireccion     
   local uuidAgente     := hget( ::oModel:hBuffer, "uuid" )

   if empty( uuidAgente )
      ::oDireccionesController:oModel:insertBuffer()
   end if 

   idDireccion          := ::oDireccionesController:oModel:getIdWhereParentUuid( uuidAgente )
   if empty( idDireccion )
      ::oDireccionesController:oModel:insertBuffer()
   end if 

   ::oDireccionesController:oModel:loadCurrentBuffer( idDireccion )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD DireccionesControllerUpdateBuffer()

   local idDireccion     
   local uuidAgente     := hget( ::oModel:hBuffer, "uuid" )

   idDireccion          := ::oDireccionesController:oModel:getIdWhereParentUuid( uuidAgente )
   if empty( idDireccion )
      ::oDireccionesController:oModel:insertBuffer()
      RETURN ( self )
   end if 

   ::oDireccionesController:oModel:updateBuffer()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD DireccionesControllerDeleteBuffer()

   local aUuidAgente    := ::getUuidFromRecno( ::oBrowseView:getBrowse():aSelected )

   if empty( aUuidAgente )
      RETURN ( self )
   end if

   ::oDireccionesController:oModel:deleteWhereParentUuid( aUuidAgente )

   RETURN ( self )
//---------------------------------------------------------------------------//

METHOD DireccionesControllerLoadedDuplicateCurrentBuffer()

   local uuidAgente
   local idDireccion     

   uuidAgente           := hget( ::oModel:hBuffer, "uuid" )

   idDireccion          := ::oDireccionesController:oModel:getIdWhereParentUuid( uuidAgente )
   if empty( idDireccion )
      ::oDireccionesController:oModel:insertBuffer()
      RETURN ( self )
   end if 

   ::oDireccionesController:oModel:loadDuplicateBuffer( idDireccion )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD DireccionesControllerLoadedDuplicateBuffer()

   local uuidAgente     := hget( ::oModel:hBuffer, "uuid" )

   hset( ::oDireccionesController:oModel:hBuffer, "parent_uuid", uuidAgente )

RETURN ( self )*/

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TercerosBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS TercerosBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Uuid'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo'
      :cHeader             := 'Código'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'nombre'
      :cHeader             := 'Nombre'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'dni'
      :cHeader             := 'DNI/CIF'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'dni' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TercerosView FROM SQLBaseView
  
   DATA oGetProvincia
   DATA oGetPoblacion
   DATA oGetPais

   METHOD Activate()

   METHOD Activating()

   METHOD getDireccionesController()   INLINE ( ::oController:oDireccionesController )

   METHOD validateFields()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activating() CLASS TercerosView

   if ::oController:isAppendOrDuplicateMode()
      ::oController:oModel:hBuffer()
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS TercerosView

   local oGetDni

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "AGENTE" ;
      TITLE       ::LblTitle() + "agente"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_user2_48" ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog

   /*REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          100 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oDialog

   REDEFINE GET   oGetDni VAR ::oController:oModel:hBuffer[ "dni" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( CheckCif( oGetDni ) );
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "comision" ] ;
      ID          120 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      PICTURE     "@E 999.99" ;
      OF          ::oDialog

   REDEFINE GET   ::getDireccionesController():oModel:hBuffer[ "direccion" ] ;
      ID          130 ;
      WHEN        ( ::getDireccionesController():isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::getDireccionesController():oModel:hBuffer[ "codigo_postal" ] ;
      ID          140 ;
      WHEN        ( ::getDireccionesController():isNotZoomMode() ) ;
      VALID       ( ::validateFields ) ;
      OF          ::oDialog 

   REDEFINE GET   ::oGetPoblacion VAR ::getDireccionesController():oModel:hBuffer[ "poblacion" ] ;
      ID          150 ;
      WHEN        ( ::getDireccionesController():isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::oGetProvincia VAR ::getDireccionesController():oModel:hBuffer[ "provincia" ] ;
      ID          160 ;
      IDTEXT      161 ;
      WHEN        ( ::getDireccionesController():isNotZoomMode() ) ;
      BITMAP      "LUPA" ;
      VALID       ( ::validateFields() ) ;
      OF          ::oDialog

   ::oGetProvincia:bHelp  := {|| ::oController:oProvinciasController:getSelectorProvincia( ::oGetProvincia ), ::validateFields() }

   REDEFINE GET   ::oGetPais VAR ::getDireccionesController():oModel:hBuffer[ "codigo_pais" ] ;
      ID          200 ;
      IDTEXT      201 ;
      WHEN        ( ::getDireccionesController():isNotZoomMode() ) ;
      VALID       ( ::validateFields() ) ;
      BITMAP      "LUPA" ;
      OF          ::oDialog

   ::oGetPais:bHelp  := {|| ::oController:oPaisesController:getSelectorPais( ::oGetPais ), ::validateFields() }

   REDEFINE GET   ::getDireccionesController():oModel:hBuffer[ "telefono" ] ;
      ID          170 ;
      WHEN        ( ::getDireccionesController():isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::getDireccionesController():oModel:hBuffer[ "movil" ] ;
      ID          180 ;
      WHEN        ( ::getDireccionesController():isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::getDireccionesController():oModel:hBuffer[ "email" ] ;
      ID          190 ;
      WHEN        ( ::getDireccionesController():isNotZoomMode() ) ;
      VALID       ( ::getDireccionesController():validate( "email" ) ) ;
      OF          ::oDialog*/

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ACTION      ( if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          ::oDialog ;
      CANCEL ;
      ACTION      ( ::oDialog:end() )

   if ::oController:isNotZoomMode() 
      ::oDialog:AddFastKey( VK_F5, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) } )
   end if

   ::oDialog:bStart := {|| ::validateFields() }

   ACTIVATE DIALOG ::oDialog CENTER

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD validateFields() CLASS TercerosView

   /*local cPoblacion
   local cCodigoProvincia

   cPoblacion           := SQLCodigosPostalesModel():getField( "poblacion", "codigo", ::getDireccionesController():oModel:hBuffer[ "codigo_postal" ] )

   if !Empty( cPoblacion ) .and. Empty( ::getDireccionesController():oModel:hBuffer[ "poblacion" ] )
      ::oGetPoblacion:cText( cPoblacion )
      ::oGetPoblacion:Refresh()
   end if

   cCodigoProvincia     := SQLCodigosPostalesModel():getField( "provincia", "codigo", ::getDireccionesController():oModel:hBuffer[ "codigo_postal" ] )

   if !Empty( cCodigoProvincia ) .and. Empty( ::getDireccionesController():oModel:hBuffer[ "provincia" ] )
      ::oGetProvincia:cText( cCodigoProvincia )
      ::oGetProvincia:Refresh()
   end if
   
   if !Empty( ::getDireccionesController():oModel:hBuffer[ "provincia" ] )
      ::oGetProvincia:oHelpText:cText( SQLProvinciasModel():getField( "provincia", "codigo", ::getDireccionesController():oModel:hBuffer[ "provincia" ] ) )
      ::oGetProvincia:oHelpText:Refresh()
   end if

   if !Empty( ::getDireccionesController():oModel:hBuffer[ "codigo_pais" ] )
      ::oGetPais:oHelpText:cText( SQLPaisesModel():getField( "nombre", "codigo", ::getDireccionesController():oModel:hBuffer[ "codigo_pais" ] ) )
      ::oGetPais:oHelpText:Refresh()
   end if*/

RETURN ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TercerosValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS TercerosValidator

   ::hValidators  := {  "nombre" =>          {  "required"     => "El nombre del agente es un dato requerido" }  }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TercerosRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLTercerosModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//