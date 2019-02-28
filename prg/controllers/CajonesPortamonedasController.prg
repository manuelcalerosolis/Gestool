#include "FiveWin.Ch"
#include "Factu.ch" 

#define __codigo_escape__  "27 112 0 60 240"

//---------------------------------------------------------------------------//

CLASS CajonesPortamonedasController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()        INLINE( if( empty( ::oBrowseView ), ::oBrowseView := CajonesPortamonedasBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()        INLINE( if( empty( ::oDialogView ), ::oDialogView := CajonPortamonedaView():New( self ), ), ::oDialogView )

   METHOD getValidator()         INLINE( if( empty( ::oValidator ), ::oValidator := CajonPortamonedaValidator():New( self  ), ), ::oValidator ) 
   
   METHOD getModel()             INLINE( if( empty( ::oModel ), ::oModel := SQLCajonesPortamonedasModel():New( self ), ), ::oModel ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS CajonesPortamonedasController

   ::Super:New()

   ::cTitle                := "Caj�n portamonedas"

   ::cName                 := "cajon_portamonedas"

   ::hImage                := {  "16" => "gc_modem_16",;
                                 "32" => "gc_modem_32",;
                                 "48" => "gc_modem_48" }

   ::nLevel                := Auth():Level( ::cName )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS CajonesPortamonedasController

   if !empty( ::oModel )
      ::oModel:End()
   end if

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
   end if

   if !empty( ::oValidator )
      ::oValidator:End()
   end if

   ::Super:End()

RETURN( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CajonesPortamonedasBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS CajonesPortamonedasBrowseView

   ::getColumnIdAndUuid()

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'nombre'
      :cHeader             := 'Nombre'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'impresora'
      :cHeader             := 'Impresora'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'impresora' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo_apertura'
      :cHeader             := 'C�digo apertura'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo_apertura' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   ::getColumnsCreatedUpdatedAt()

   ::getColumnDeletedAt()

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CajonPortamonedaView FROM SQLBaseView
  
   METHOD Activate()

   METHOD testCajonPortamoneda()       INLINE ( TCajon():New( ::oController:getModel():hBuffer[ "codigo_apertura" ], ::oController:getModel():hBuffer[ "impresora" ] ):openTest() )

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS CajonPortamonedaView

   local oDlg
   local oGetImpresora
   local oGetCodigoApertura

   DEFINE DIALOG  oDlg ;
      RESOURCE    "CAJON_PORTAMONEDA" ;
      TITLE       ::LblTitle() + "caj�n portamoneda"

   REDEFINE GET   ::oController:getModel():hBuffer[ "nombre" ] ;
      ID          100 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          oDlg

   REDEFINE GET   oGetImpresora ;
      VAR         ::oController:getModel():hBuffer[ "impresora" ] ;
      ID          110 ;
      BITMAP      "gc_printer2_check_16" ;
      ON HELP     ( PrinterPreferences( oGetImpresora ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "impresora" ) ) ;
      OF          oDlg

   REDEFINE GET   oGetCodigoApertura ;
      VAR         ::oController:getModel():hBuffer[ "codigo_apertura" ] ;
      ID          120 ;
      BITMAP      "gc_modem_16" ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "codigo_apertura" ) ) ;
      OF          oDlg

      oGetCodigoApertura:bHelp   := {|| ::testCajonPortamoneda() }

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( oDlg ), oDlg:end( IDOK ), ) }, oDlg, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| oDlg:end() }, oDlg, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   oDlg:bKeyDown   := {| nKey | if( nKey == VK_F5, oDlg:end( IDOK ), ) }

   if ::oController:isNotZoomMode() 
      oDlg:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( oDlg ), oDlg:end( IDOK ), ) }
   end if

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CajonPortamonedaValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS CajonPortamonedaValidator

   ::hValidators  := {  "nombre" =>          {  "required"     => "El nombre de caj�n portamoneda es un dato requerido",;
                                                "unique"       => "El nombre de caj�n portamoneda ya existe" },;
                        "impresora" =>       {  "required"     => "La impresora es un dato requerido" },; 
                        "codigo_apertura" => {  "required"     => "El c�digo de apertura es un dato requerido" } } 

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLCajonesPortamonedasModel FROM SQLCompanyModel

   DATA cTableName               INIT "cajones_portamonedas"

   DATA cConstraints             INIT "PRIMARY KEY ( nombre, deleted_at )"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLCajonesPortamonedasModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                             "text"      => "Identificador"                           ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR ( 40 ) NOT NULL UNIQUE"             ,;
                                             "text"      => "Uuid"                                    ,;
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "nombre",            {  "create"    => "VARCHAR( 140 )"                          ,;
                                             "default"   => {|| space( 140 ) } }                       )

   hset( ::hColumns, "impresora",         {  "create"    => "VARCHAR ( 200 )"                          ,;
                                             "default"   => {|| space( 200 ) } }                       )

   hset( ::hColumns, "codigo_apertura",   {  "create"    => "VARCHAR( 100 )"                          ,;
                                             "default"   => {|| __codigo_escape__ } }                  )

   ::getTimeStampColumns()

   ::getDeletedStampColumn()

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

CLASS CajonesPortamonedasRepository FROM SQLBaseRepository

   METHOD getTableName()         INLINE ( SQLCajonesPortamonedasModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TCajon

   CLASSDATA lCreated                  AS LOGIC INIT .f.

   DATA  cPrinter
   DATA  cApertura                     INIT ""

   METHOD New( cApertura, cPrinter )   CONSTRUCTOR

   METHOD Open()
   METHOD OpenTest()                   INLINE ( ::Open() )

   METHOD End()                        VIRTUAL

END CLASS

//---------------------------------------------------------------------------//

METHOD New( cApertura, cPrinter ) CLASS TCajon

   DEFAULT cApertura    := "27 112 0 60 240"
   DEFAULT cPrinter     := ""

   ::cApertura          := cApertura
   ::cPrinter           := cPrinter

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Open()

   local nResult
   local cFile    := "EscFile.txt"

   if memowrit( cFile, alltrim( retChr( ::cApertura ) ) )
      nResult     := win_printFileRaw( alltrim( ::cPrinter ), cFile )
      fErase( cFile )
   end if 

RETURN ( nResult )

//---------------------------------------------------------------------------//

