#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS CajasController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController) CLASS CajasController

   ::Super:New( oController )

   ::cTitle                         := "Cajas"

   ::cName                          := "cajas"

   ::hImage                         := {  "16" => "gc_cash_register_16",;
                                          "32" => "gc_cash_register_32",;
                                          "48" => "gc_cash_register_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::oModel                         := SQLCajasModel():New( self )

   ::oBrowseView                    := CajasBrowseView():New( self )

   ::oDialogView                    := CajasView():New( self )

   ::oValidator                     := CajasValidator():New( self, ::oDialogView )

   ::oRepository                    := CajasRepository():New( self )

   ::setEvents( { 'editing', 'deleting' }, {|| if( ::isRowSetSystemRegister(), ( msgStop( "Este registro pertenece al sistema, no se puede alterar." ), .f. ), .t. ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS CajasController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oRepository:End()


   ::oModel                         := nil

   ::oBrowseView                    := nil

   ::oDialogView                    := nil

   ::oValidator                     := nil

   ::oRepository                    := nil

   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CajasBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS CajasBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 60
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
      :cHeader             := 'C�digo'
      :nWidth              := 50
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'nombre_caja'
      :cHeader             := 'Nombre'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'numero_sesion'
      :cHeader             := 'C�digo de sesi�n'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'numero_sesion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CajasView FROM SQLBaseView

   METHOD Activate()

   METHOD StartActivate()

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD Activate() CLASS CajasView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "CAJAS" ;
      TITLE       ::LblTitle() + "cajas"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getimage("48")  ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNNNNNNNNNNNNNNNNNNN" ;
      WHEN        ( ::oController:isAppendOrDuplicateMode() ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "numero_sesion" ] ;
      ID          120 ;
      SPINNER  ;
      MIN 0;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   // Explorer bar -------------------------------------------------------

   ::redefineExplorerBar( 200 )

   // Botones caja -------------------------------------------------------

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

   ::oDialog:bStart  := {|| ::StartActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD StartActivate() CLASS CajasView

   local oPanel      := ::oExplorerBar:AddPanel( "Datos relacionados", nil, 1 ) 

    oPanel:AddLink(  "Impresoras...",;
                     {|| ::oController:getImpresorasController():activateDialogView() },;
                         ::oController:getImpresorasController():getImage( "16" ) )

    oPanel           := ::oExplorerBar:AddPanel( "Otros", nil, 1 )

    oPanel:AddLink(  "Campos extra...",;
                     {|| ::oController:getCamposExtraValoresController():Edit( ::oController:getUuid() ) },;
                         ::oController:getCamposExtraValoresController():getImage( "16" ) )

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CajasValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS CajasValidator

   ::hValidators  := {  "nombre_caja" =>  {  "required"  => "El nombre es un dato requerido",;
                                             "unique"    => "El nombre introducido ya existe" },;
                        "codigo" =>       {  "required"  => "El c�digo es un dato requerido" ,;
                                             "unique"    => "EL c�digo introducido ya existe" } }
RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLCajasModel FROM SQLCompanyModel

   DATA cTableName               INIT "cajas"

   METHOD getColumns()

   METHOD getInsertCajasSentence() 

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLCajasModel
   
   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "codigo",            {  "create"    => "VARCHAR( 20 ) NOT NULL UNIQUE"           ,;
                                             "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "nombre",            {  "create"    => "VARCHAR( 200 ) NOT NULL UNIQUE"          ,;
                                             "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "numero_sesion",     {  "create"    => "INTEGER UNSIGNED"                        ,;
                                             "default"   => {|| 1 } }                                 )

   hset( ::hColumns, "sistema",           {  "create"    => "TINYINT( 1 )"                            ,;
                                             "default"   => {|| 0 } }                                 )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getInsertCajasSentence() CLASS SQLCajasModel

   local cSentence   := "INSERT IGNORE INTO " + ::getTableName()                                      + " " + ;
                           "( uuid, codigo, nombre, numero_sesion, sistema )"                         + " " + ;
                        "VALUES"                                                                      + " " + ;
                           "( " + quoted( win_uuidcreatestring() ) + ", '1', 'Principal', 1, 1 )"

RETURN ( cSentence )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CajasRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLCajasModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
