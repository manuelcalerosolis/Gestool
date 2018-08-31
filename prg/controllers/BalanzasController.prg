#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS BalanzasController FROM SQLNavigatorController

   METHOD New()

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS BalanzasController

   ::Super:New()

   ::cTitle                      := "Balanzas"

   ::cName                       := "balanzas"

   ::hImage                      := {  "16" => "gc_balance_16",;
                                       "32" => "gc_balance_32",;
                                       "48" => "gc_balance_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::oModel                         := SQLBalanzasModel():New( self )

   ::oBrowseView                    := BalanzasBrowseView():New( self )

   ::oDialogView                    := BalanzasView():New( self )

   ::oValidator                     := BalanzasValidator():New( self, ::oDialogView )

   ::oRepository                    := BalanzasRepository():New( self )

   ::oGetSelector                   := GetSelector():New( self )   

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS BalanzasController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oRepository:End()

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS BalanzasBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS BalanzasBrowseView

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
      :cSortOrder          := 'codigo'
      :cHeader             := 'Código'
      :nWidth              := 120
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'nombre'
      :cHeader             := 'Nombre'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre' ) }
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

CLASS BalanzasView FROM SQLBaseView

   DATA oPuerto

   DATA aPuerto INIT { "COM1", "COM2", "COM3", "COM4", "COM5", "COM6", "COM7", "COM8", "COM9",;
                      "COM10", "COM11", "COM12", "COM13", "COM14", "COM15", "COM16", "COM17", "COM18" }

   DATA oBPS

   DATA aBPS INIT { "2400", "4800", "9600", "19200", "38400", "57600", "115200", "203400", "460800", "921600" }

   DATA oParada

   DATA aParada INIT { "0", "1", "2" }

   DATA oDatos

   DATA aDatos INIT { "7", "8" }

   DATA oParidad

   DATA aParidad INIT { "Sin paridad", "Paridad par", "Paridad impar" }

   DATA oInicializacion

   METHOD SetDefault()
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS BalanzasView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "BALANZA_SQL" ;
      TITLE       ::LblTitle() + "balanzas"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog ;

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      PICTURE     "@! NNNNNNNNNNNNNNNNNN" ;
      ID          100 ;
      WHEN        ( ::oController:isAppendOrDuplicateMode() ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

    REDEFINE COMBOBOX ::oPuerto ;
      VAR         ::oController:oModel:hBuffer[ "puerto" ] ;
      ID          120 ;
      ITEMS       ::aPuerto;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE COMBOBOX ::oBPS ;
      VAR         ::oController:oModel:hBuffer[ "bits_segundo" ] ;
      ID          130 ;
      ITEMS       ::aBPS;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE COMBOBOX ::oParada ;
      VAR         ::oController:oModel:hBuffer[ "bits_parada" ] ;
      ID          140 ;
      ITEMS       ::aParada;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE COMBOBOX ::oDatos ;
      VAR         ::oController:oModel:hBuffer[ "bits_datos" ] ;
      ID          150 ;
      ITEMS       ::aDatos;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE COMBOBOX ::oParidad ;
      VAR         ::oController:oModel:hBuffer[ "paridad" ] ;
      ID          160 ;
      ITEMS       ::aParidad;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oInicializacion ; 
      VAR         ::oController:oModel:hBuffer[ "inicializacion" ] ;
      ID          170 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "retardo" ] ;
      ID          180 ;
      SPINNER ;
      MIN  0;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "entubamiento" ] ;
      ID          190 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE SAYCHECKBOX ::oController:oModel:hBuffer[ "abrir_puerto" ] ;
      ID          200 ;
      IDSAY       202 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

//Botones text y defecto------------------------------------------------------//

   REDEFINE BUTTON ;
      ID          210 ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ACTION      ( msginfo("test") )

   REDEFINE BUTTON ;
      ID          220 ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ACTION      ( ::SetDefault() )


   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ACTION      ( if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          ::oDialog ;
      CANCEL ;
      ACTION     ( ::oDialog:end() )


   ACTIVATE DIALOG ::oDialog CENTER
   

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD SetDefault() CLASS BalanzasView

   ::oController:oModel:hBuffer[ "inicializacion" ] := 98000001
   ::oInicializacion:refresh()

RETURN( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS BalanzasValidator FROM SQLBaseValidator

   METHOD getValidators()

 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS BalanzasValidator

   ::hValidators  := {  "codigo" =>                {  "required"           => "El código es un dato requerido" ,;
                                                      "unique"             => "EL código introducido ya existe" },;
                        "nombre" =>                {  "required"           => "El nombre es un dato requerido"    ,;
                                                      "unique"             => "El nombre introducido ya existe"   }  }
RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLBalanzasModel FROM SQLCompanyModel

   DATA cTableName               INIT "balanzas"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLBalanzasModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;                                  
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "codigo",            {  "create"    => "VARCHAR( 20 )"                           ,;
                                             "default"   => {|| space( 20 ) } }                        )

   hset( ::hColumns, "nombre",            {  "create"    => "VARCHAR( 200 )"                          ,;
                                             "default"   => {|| space( 200 ) } }                       )

   hset( ::hColumns, "puerto",            {  "create"   => "VARCHAR( 200 )"                           ,;
                                             "default"   => {|| space( 200 ) } }                       )

   hset( ::hColumns, "bits_segundo",      {  "create"    => "VARCHAR( 200 )"                          ,;
                                             "default"   => {||  space( 200 ) } }                      )

   hset( ::hColumns, "bits_parada",       {  "create"    => "VARCHAR( 200 )"                           ,;
                                             "default"   => {||  space( 200 )  } }                     )

   hset( ::hColumns, "bits_datos",        {  "create"    => "VARCHAR( 200 )"                           ,;
                                             "default"   => {|| space( 200 )  } }                      )

   hset( ::hColumns, "paridad",           {  "create"    => "VARCHAR( 200 )"                          ,;
                                             "default"   => {|| space( 200 ) } }                       )

   hset( ::hColumns, "inicializacion",    {  "create"    => "VARCHAR( 200 )"                          ,;
                                             "default"   => {|| space( 200 ) } }                       )

   hset( ::hColumns, "retardo",           {  "create"    => "INTEGER"                                 ,;
                                             "default"   => {||  0  } }                                )

   hset( ::hColumns, "entubamiento",      {  "create"    => "VARCHAR( 1 )"                          ,;
                                             "default"   => {|| space( 1 ) } }                       )

   hset( ::hColumns, "abrir_puerto",      {  "create"    => "TINYINT( 1 )"                            ,;
                                             "default"   => {|| 0 } }                               )



RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS BalanzasRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLBalanzasModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//