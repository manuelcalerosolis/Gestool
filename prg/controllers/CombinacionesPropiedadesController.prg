#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS CombinacionesPropiedadesController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD insertProperties( aCombination )

   METHOD insertProperty( uuidCombination, uuidParent )

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()                 INLINE( if( empty( ::oBrowseView ), ::oBrowseView := CombinacionesPropiedadesBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()                 INLINE( if( empty( ::oDialogView ), ::oDialogView := CombinacionesPropiedadesView():New( self ), ), ::oDialogView )

   METHOD getRepository()                 INLINE ( if( empty( ::oRepository ), ::oRepository := CombinacionesPropiedadesRepository():New( self ), ), ::oRepository )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS CombinacionesPropiedadesController

   ::Super:New( oSenderController )

   ::cTitle                         := "Combinaciones de Propiedades"

   ::cName                          := "combinaciones_propiedades"

   ::hImage                         := {  "16" => "gc_cash_register_refresh_16",;
                                          "32" => "gc_cash_register_refresh_32",;
                                          "48" => "gc_cash_register_refresh_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::oModel                         := SQLCombinacionesPropiedadesModel():New( self )  

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS CombinacionesPropiedadesController

   ::oModel:End()

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
   end if

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if

   if !empty( ::oRepository )
      ::oRepository:End()
   end if

   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD insertProperties( aCombination, uuidParent ) CLASS CombinacionesPropiedadesController

   local hCombination

   for each hCombination in aCombination

      ::insertProperty( hget( hCombination, "propiedad_uuid" ), uuidParent )

   next

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD insertProperty( uuidCombination, uuidParent ) CLASS CombinacionesPropiedadesController

   local hBuffer     := ::oModel:loadBlankBuffer()
   
   hset( hBuffer, "propiedad_uuid", uuidCombination )  
   hset( hBuffer, "parent_uuid", uuidParent )  

RETURN ( ::oModel:insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CombinacionesPropiedadesBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS CombinacionesPropiedadesBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Uuid'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'parent_uuid'
      :cHeader             := 'Artículo'
      :nWidth              := 120
      :bEditValue          := {|| ::getRowSet():fieldGet( 'parent_uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'propiedad_uuid'
      :cHeader             := 'Valor propiedad'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'propiedad_uuid' ) }
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

CLASS CombinacionesPropiedadesView FROM SQLBaseView
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS CombinacionesPropiedadesView

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CombinacionesPropiedadesValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS CombinacionesPropiedadesValidator

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLCombinacionesPropiedadesModel FROM SQLCompanyModel

   DATA cTableName               INIT "combinaciones_propiedades"

   DATA cConstraints             INIT "FOREIGN KEY (parent_uuid) REFERENCES " + SQLCombinacionesModel():getTableName() + " (uuid) ON DELETE CASCADE"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLCombinacionesPropiedadesModel

   hset( ::hColumns, "id",                   {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"              ,;                          
                                                "default"   => {|| 0 } }                                    )

   hset( ::hColumns, "uuid",                 {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"                ,;                                  
                                                "default"   => {|| win_uuidcreatestring() } }               )

   hset( ::hColumns, "parent_uuid",          {  "create"    => "VARCHAR( 40 )"                              ,;
                                                "default"   => {|| space( 40 ) } }                          )

   hset( ::hColumns, "propiedad_uuid",       {  "create"    => "VARCHAR( 40 )"                              ,;
                                                "default"   => { || space ( 40 )  } }                       ) 

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CombinacionesPropiedadesRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLCombinacionesPropiedadesModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
