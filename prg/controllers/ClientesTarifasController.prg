#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ClientesTarifasController FROM SQLNavigatorController

   METHOD New()

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS ClientesTarifasController

   ::Super:New( oController )

   ::cTitle                         := "Tarifas Clientes"

   ::cName                          := "clientes_tarifas"

   ::hImage                         := {  "16" => "gc_money_interest_16",;
                                          "32" => "gc_money_interest_32",;
                                          "48" => "gc_money_interest_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::oModel                         := SQLClientesTarifasModel():New( self )

   ::oBrowseView                    := ClientesTarifasBrowseView():New( self )

   ::oDialogView                    := ClientesTarifasView():New( self )

   ::oGetSelector                   := GetSelector():New( self )
   
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ClientesTarifasController

   ::oModel:End()

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLClientesTarifasModel FROM SQLCompanyModel

   DATA cTableName                     INIT "clientes_tarifas"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLClientesTarifasModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;                                  
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",       {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                             "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "tarifa_uuid",       {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                             "default"   => {|| space( 40 ) } }                       )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ClientesTarifasBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS ClientesTarifasBrowseView

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
   end with

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ClientesTarifasView FROM SQLBaseView
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS ClientesTarifasView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "CONTACTO" ;
      TITLE       ::LblTitle() + "Contacto"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog ;

    REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog
   








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

   ACTIVATE DIALOG ::oDialog CENTER

  ::oBitmap:end()

RETURN ( ::oDialog:nResult )


//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//