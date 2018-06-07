#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS LenguajesController FROM SQLNavigatorController

   METHOD New()

   METHOD End()

   METHOD SetSelectorToGet( oGet, oSay )

   METHOD validLenguajeFromGet( oGet, oSay )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS LenguajesController

   ::Super:New( oSenderController )

   ::cTitle                   := "Lenguajes"

   ::cName                    := "lenguajes"

   ::hImage                   := {  "16" => "gc_user_message_16",;
                                    "32" => "gc_user_message_32",;
                                    "48" => "gc_user_message_48" }

   ::nLevel                   := Auth():Level( ::cName )

   ::oModel                   := SQLLenguajesModel():New( self )

   ::oBrowseView              := LenguajesBrowseView():New( self )

   ::oDialogView              := LenguajesView():New( self )

   ::oValidator               := LenguajesValidator():New( self, ::oDialogView )

   ::oRepository              := LenguajesRepository():New( self )

   ::oGetSelector             := GetSelector():New( self )

   ::oFilterController:setTableToFilter( ::oModel:cTableName )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS LenguajesController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oRepository:End()

   ::oGetSelector:End()

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD SetSelectorToGet( oGet, oSay ) CLASS LenguajesController

   local hLenguaje    := ::ActivateSelectorView() 

   if !empty( hLenguaje ) .and. hhaskey( hLenguaje, "codigo" )
      oGet:cText( hget( hLenguaje, "codigo" ) )
   else
      oGet:cText( "" )
   end if

   if !empty( hLenguaje ) .and. hhaskey( hLenguaje, "codigo" )
      oSay:cText( hget( hLenguaje, "nombre" ) )
   else
      oSay:cText( "" )
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD validLenguajeFromGet( oGet, oSay ) CLASS LenguajesController

   local uValue
   local cNombre

   if Empty( oGet )
      Return .t.
   end if

   uValue            := oGet:VarGet()

   if Empty( uValue )
      Return .t.
   end if

   cNombre           := ::oModel:getNombre( uValue )

   if Empty( cNombre )
      oSay:cText( "" )
      MsgStop( "Lenguaje no encontrado" )
      Return .f.
   end if

   oSay:cText( cNombre )

return .t.

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS LenguajesBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS LenguajesBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Uuid'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo'
      :cHeader             := 'C�digo'
      :nWidth              := 80
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

CLASS LenguajesView FROM SQLBaseView
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS LenguajesView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "LENGUAJE" ;
      TITLE       ::LblTitle() + "lenguajes"

   REDEFINE BITMAP ::oBmpGeneral ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNNNNNNNNNNNNNNNNNNN" ;
      WHEN        ( ::oController:isNotZoomMode()  ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
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

   if ::oController:isNotZoomMode() 
      ::oDialog:AddFastKey( VK_F5, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) } )
   end if

   ACTIVATE DIALOG ::oDialog CENTER

   ::oBmpGeneral:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS LenguajesValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS LenguajesValidator

   ::hValidators  := {     "codigo" =>    {  "required"     => "El c�digo es un dato requerido",;
                                             "unique"       => "El c�digo introducido ya existe" } ,;
                           "nombre" =>    {  "required"     => "El nombre es un datos requerido",;
                                             "unique"       => "El nombre introducido ya existe" } }                      

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLLenguajesModel FROM SQLBaseModel

   DATA cTableName                  INIT "lenguajes"

   MESSAGE getNombre( codigo )      INLINE ( ::getField( "nombre", "codigo", codigo ) )

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLLenguajesModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "codigo",            {  "create"    => "VARCHAR( 20 ) UNIQUE"                    ,;
                                             "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "nombre",            {  "create"    => "VARCHAR( 20 ) UNIQUE"                    ,;
                                             "default"   => {|| space( 20 ) } }                       )

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

CLASS LenguajesRepository FROM SQLBaseRepository

   METHOD getTableName()         INLINE ( SQLLenguajesModel():getTableName() )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//