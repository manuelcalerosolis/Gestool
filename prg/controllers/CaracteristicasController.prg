#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS CaracteristicasController FROM SQLNavigatorController

   METHOD New()

   METHOD End()

   //Contrucciones tardias---------------------------------------------------//

   METHOD getBrowseView()              INLINE( if( empty( ::oBrowseView ), ::oBrowseView := CaracteristicasBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()              INLINE( if( empty( ::oDialogView ), ::oDialogView := CaracteristicasView():New( self ), ), ::oDialogView )

   METHOD getValidator()               INLINE( if( empty( ::oValidator ), ::oValidator := CaracteristicasValidator():New( self  ), ), ::oValidator ) 
   
   METHOD getModel()                   INLINE( if( empty( ::oModel ), ::oModel := SQLCaracteristicasModel():New( self ), ), ::oModel ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS CaracteristicasController

   ::Super:New( oSenderController )

   ::cTitle                            := "Caracter�sticas"

   ::cName                             := "articulos_caracteristicas"

   ::hImage                            := {  "16" => "gc_tags_16",;
                                             "32" => "gc_tags_32",;
                                             "48" => "gc_tags_48" }

   ::nLevel                            := Auth():Level( ::cName )

   ::lTransactional                    := .t.

   ::setEvents( { 'appended', 'edited' }, {|| ::getCaracteristicasLineasController():getModel():deleteBlank( ::getModelBuffer( "uuid" ) ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS CaracteristicasController

   if !empty( ::oModel )
      ::oModel:End()
   end if

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
   end if 

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if

   if !empty(::oValidator )
      ::oValidator:End()
   end if

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CaracteristicasBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS CaracteristicasBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 60
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
      :cHeader             := 'C�digo'
      :nWidth              := 50
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

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CaracteristicasView FROM SQLBaseView

   DATA oBtnDeleted

   METHOD Activate()

   METHOD lineAppend()

   METHOD setShowDeleted()             INLINE ( ::getController():getCaracteristicasLineasController():setShowDeleted(),;
                                                ::oBtnDeleted:Toggle(),;
                                                ::oBtnDeleted:cTooltip := if( ::oBtnDeleted:lPressed, "Ocultar borrados", "Mostrar borrados" ) ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD Activate() CLASS CaracteristicasView

   local oBtnEdit
   local oBtnAppend
   local oBtnDelete

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "CARACTERISTICAS_MEDIUM" ;
      TITLE       ::LblTitle() + "caracter�stica"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_tags_48" ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      PROMPT      "Caracter�stica" ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNNN" ;
      WHEN        ( ::oController:isAppendOrDuplicateMode() ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oDialog

   // Lineas de propiedades -------------------------------------------------------

   TBtnBmp():ReDefine( 130, "new16", , , , , {|| ::lineAppend() }, ::oDialog, .f., {|| ::getController():isNotZoomMode() }, .f., "A�adir l�nea" )

   TBtnBmp():ReDefine( 140, "del16",,,,, {|| ::getController():getCaracteristicasLineasController():Delete() }, ::oDialog, .f., {|| ::getController():isNotZoomMode() }, .f., "Eliminar l�neas" )

   TBtnBmp():ReDefine( 150, "refresh16",,,,, {|| ::getController():getCaracteristicasLineasController():refreshRowSet() }, ::oDialog, .f., , .f., "Recargar l�neas" )

   ::oBtnDeleted := TBtnBmp():ReDefine( 160, "gc_deleted_16",,,,, {|| ::setShowDeleted() }, ::oDialog, .f., , .f., "Mostrar/Ocultar borrados" )

   ::oController:getCaracteristicasLineasController():Activate( 170, ::oDialog )

   // Botones------------------------------------------------------------------

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::oDialog:end( IDOK ), ) }

   if ::oController:isNotZoomMode() 
   
      ::oDialog:bKeyDown   := <| nKey |  
         do case         
            case nKey == VK_F5
               if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), )
            case nKey == VK_F2
               ::lineAppend()
            case nKey == VK_F4
               ::oController:getCaracteristicasLineasController():Delete()
         end 
         RETURN ( 0 )
         >

   end if

   ::oDialog:bStart  := {|| ::paintedActivate() }

   ACTIVATE DIALOG ::oDialog CENTER
  
RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD lineAppend() CLASS CaracteristicasView

   if !::oController():getCaracteristicasLineasController():validLine()
      RETURN ( nil )
   end if

RETURN ( ::oController():getCaracteristicasLineasController():AppendLineal() ) 

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CaracteristicasValidator FROM SQLCompanyValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS CaracteristicasValidator

   ::hValidators  := {  "nombre" =>    {  "required"           => "El nombre es un dato requerido",;
                                          "unique"             => "El nombre introducido ya existe" },;
                        "codigo" =>    {  "required"           => "El c�digo es un dato requerido" ,;
                                          "unique"             => "El c�digo introducido ya existe" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLCaracteristicasModel FROM SQLCompanyModel

   DATA cTableName                     INIT "articulos_caracteristicas"

   DATA cConstraints                   INIT "PRIMARY KEY ( codigo, deleted_at )"

   METHOD getColumns()

   METHOD getNombreWhereUuid( uuid )   INLINE ( ::getField( 'nombre', 'uuid', uuid ) )

   METHOD getNamesFromIdLanguagesPS( uuidCaracteristica, aIdsLanguages )

#ifdef __TEST__

   METHOD testCreateCaracteristica( uuid )

#endif

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLCaracteristicasModel
   
   hset( ::hColumns, "id",       {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                    "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",     {  "create"    => "VARCHAR ( 40 ) NOT NULL UNIQUE"           ,;
                                    "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "codigo",   {  "create"    => "VARCHAR ( 20 )"                           ,;
                                    "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "nombre",   {  "create"    => "VARCHAR ( 200 )"                          ,;
                                    "default"   => {|| space( 200 ) } }                      )

   ::getTimeStampColumns()

   ::getDeletedStampColumn()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getNamesFromIdLanguagesPS( uuidCaracteristica, aIdsLanguages ) CLASS SQLCaracteristicasModel

   local cName
   local hNames   := {=>}

   if Len( aIdsLanguages ) == 0
      RETURN ( hNames )
   end if

   cName          := ::getNombreWhereUuid( uuidCaracteristica )

   if empty( cName )
      RETURN ( hNames )
   end if

   aEval( aIdsLanguages, {|id| hSet( hNames, AllTrim( Str( id ) ), AllTrim( cName ) ) } )

RETURN ( hNames )

//---------------------------------------------------------------------------//

#ifdef __TEST__

METHOD testCreateCaracteristica( uuid ) CLASS SQLCaracteristicasModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "uuid", uuid )
   hset( hBuffer, "codigo", "001" )
   hset( hBuffer, "nombre", "Caracteristica" )

RETURN ( ::insertBuffer( hBuffer ) )

#endif

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

#ifdef __TEST__

CLASS TestCaracteristicasController FROM TestCase

   METHOD testCreateCaracteristicaSincodigo()

   METHOD testCreateCaracteristicaSinNombre()

   METHOD testCreateCaracteristicaSinLinea()

   /*METHOD testCreateCaracteristicaConLineaSinNombre()*/

   METHOD testCreateCaracteristicaConLineaBlanco()

   METHOD testCreateCaracteristicaCambiaLinea()

   METHOD testCreateCaracteristicaLineasIguales()

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD testCreateCaracteristicaSincodigo() CLASS TestCaracteristicasController

   local oController

   SQLCaracteristicasModel():truncateTable()  

   oController                := CaracteristicasController():New()

   oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds(),;
         self:getControl( 100, self:oDialog ):cText( "" ),;
         testWaitSeconds(),;
         self:getControl( IDOK ):Click(),;
         testWaitSeconds(),;
         self:getControl( IDCANCEL ):Click() } )

   ::Assert():false( oController:Append(), "test ::Assert():true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testCreateCaracteristicaSinNombre() CLASS TestCaracteristicasController

   local oController

   SQLCaracteristicasModel():truncateTable() 

   oController             := CaracteristicasController():New()
   oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds(),;
         self:getControl( 100, self:oDialog ):cText( "001" ),;
         testWaitSeconds(),;
         self:getControl( 110, self:oDialog ):cText( "" ),;
         testWaitSeconds(),;
         self:getControl( IDOK ):Click(),;
         testWaitSeconds(),;
         self:getControl( IDCANCEL ):Click() } )

   ::Assert():false( oController:Append(), "test ::Assert():true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testCreateCaracteristicaSinLinea() CLASS TestCaracteristicasController

   local oController

   SQLCaracteristicasModel():truncateTable()  

   oController             := CaracteristicasController():New()
   oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds(),;
         self:getControl( 100, self:oDialog ):cText( "001" ),;
         testWaitSeconds(),;
         self:getControl( 110, self:oDialog ):cText( "Caracteristica 1" ),;
         testWaitSeconds(),;
         self:getControl( IDOK ):Click() } )

   ::Assert():true( oController:Append(), "test ::Assert():true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

/*METHOD testCreateCaracteristicaConLineaSinNombre() CLASS TestCaracteristicasController

   local oController

   SQLCaracteristicasModel():truncateTable() 

   SQLCaracteristicasLineasModel():truncateTable()  

   oController             := CaracteristicasController():New()

   oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds(),;
         self:getControl( 100, self:oDialog ):cText( "001" ),;
         testWaitSeconds(),;
         self:getControl( 110, self:oDialog ):cText( "Caracteristica 1" ),;
         testWaitSeconds(),;
         oController:getCaracteristicasLineasController():Append(),;
         testWaitSeconds(),;
         self:getControl( IDOK ):Click() } )

   oController:getCaracteristicasLineasController():getDialogView():setEvent( 'painted',;
      {| self | ;
         self:getControl( 110 ):cText( "Caracteristica l�nea" ),;
         testWaitSeconds(),;
         self:getControl( IDOK ):Click() } )

   ::Assert():true( oController:Append(), "test ::Assert():true with .t." )

RETURN ( nil )*/

//---------------------------------------------------------------------------//

METHOD testCreateCaracteristicaConLineaBlanco() CLASS TestCaracteristicasController

local oController

   SQLCaracteristicasModel():truncateTable()  
   SQLCaracteristicasLineasModel():truncateTable()  

   oController             := CaracteristicasController():New()
   oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds(),;
         self:getControl( 100, self:oDialog ):cText( "001" ),;
         testWaitSeconds(),;
         self:getControl( 110, self:oDialog ):cText( "Caracteristica 1" ),;
         testWaitSeconds(),;
         self:lineAppend(),;
         testWaitSeconds(),;
         eval( oController:getCaracteristicasLineasController():getBrowseView():oColumnNombre:bOnPostEdit, , "Caracteristica linea 1" ),;
         testWaitSeconds(),;
         self:lineAppend(),;
         testWaitSeconds(),;
         self:getControl( IDOK ):Click() } ) 

   ::Assert():true( oController:Append(), "test ::Assert():true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testCreateCaracteristicaCambiaLinea() CLASS TestCaracteristicasController

local oController

   SQLCaracteristicasModel():truncateTable()  
   SQLCaracteristicasLineasModel():truncateTable()  

   oController             := CaracteristicasController():New()
   oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds(),;
         self:getControl( 100, self:oDialog ):cText( "001" ),;
         testWaitSeconds(),;
         self:getControl( 110, self:oDialog ):cText( "Caracteristica 1" ),;
         testWaitSeconds(),;
         self:lineAppend(),;
         testWaitSeconds(),;
         eval( oController:getCaracteristicasLineasController():getBrowseView():oColumnNombre:bOnPostEdit, , "Caracteristica linea 1" ),;
         testWaitSeconds(),;
         self:lineAppend(),;
         testWaitSeconds(),;
         eval( oController:getCaracteristicasLineasController():getBrowseView():oColumnNombre:bOnPostEdit, , "Caracteristica linea 2" ),;
         oController:getCaracteristicasLineasController():getRowSet():goTop(),;
         eval( oController:getCaracteristicasLineasController():getBrowseView():oColumnNombre:bOnPostEdit, , "" ),;
         testWaitSeconds(),;
         self:getControl( IDOK ):Click() } ) 

   ::Assert():true( oController:Append(), "test ::Assert():true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testCreateCaracteristicaLineasIguales() CLASS TestCaracteristicasController

local oController

   SQLCaracteristicasModel():truncateTable()  
   SQLCaracteristicasLineasModel():truncateTable()  

   oController             := CaracteristicasController():New()
   oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds(),;
         self:getControl( 100, self:oDialog ):cText( "001" ),;
         testWaitSeconds(),;
         self:getControl( 110, self:oDialog ):cText( "Caracteristica 1" ),;
         testWaitSeconds(),;
         self:lineAppend(),;
         testWaitSeconds(),;
         eval( oController:getCaracteristicasLineasController():getBrowseView():oColumnNombre:bOnPostEdit, , "Caracteristica linea 1" ),;
         testWaitSeconds(),;
         self:lineAppend(),;
         testWaitSeconds(),;
         eval( oController:getCaracteristicasLineasController():getBrowseView():oColumnNombre:bOnPostEdit, , "Caracteristica linea 1" ),;
         testWaitSeconds(),;
         self:lineAppend(),;
         testWaitSeconds(),;
         self:getControl( IDOK ):Click() } ) 
          
   ::Assert():true( oController:Append(), "test ::Assert():true with .t." )

RETURN ( nil )

#endif

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//