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

   ::cTitle                            := "Características"

   ::cName                             := "articulos_caracteristicas"

   ::hImage                            := {  "16" => "gc_tags_16",;
                                             "32" => "gc_tags_32",;
                                             "48" => "gc_tags_48" }

   ::nLevel                            := Auth():Level( ::cName )

   //::oFilterController:setTableToFilter( ::oModel:cTableName )

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

   //::Super:End()

RETURN ( Self )

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
      :cHeader             := 'Código'
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

   DATA oSayCamposExtra

   DATA oGetTipo
  
   METHOD Activate()

   METHOD startActivate()

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD Activate() CLASS CaracteristicasView

   local oSayCamposExtra
   local oBtnEdit
   local oBtnAppend
   local oBtnDelete

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "CARACTERISTICAS_MEDIUM" ;
      TITLE       ::LblTitle() + "característica"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_tags_48" ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      PROMPT      "Característica" ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNNN" ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oDialog

   // Lineas de propiedades -------------------------------------------------------

   REDEFINE BUTTON oBtnAppend ;
      ID          130 ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;

   oBtnAppend:bAction   := {|| ::oController:getCaracteristicasLineasController():Append() }

   REDEFINE BUTTON oBtnEdit ;
      ID          140 ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;

   oBtnEdit:bAction   := {|| ::oController:getCaracteristicasLineasController():Edit() }

   REDEFINE BUTTON oBtnDelete ;
      ID          150 ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;

   oBtnDelete:bAction   := {|| ::oController:getCaracteristicasLineasController():Delete() }

   ::oController:getCaracteristicasLineasController():Activate( 160, ::oDialog )

   // Botones------------------------------------------------------------------

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )
   
   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
   else
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::oDialog:end( IDOK ), ) }
   end if

   //if ::oController:isNotZoomMode() 
      //::oDialog:AddFastKey( VK_F2, {|| ::oController:oCaracteristicasLineasController:Append() } )
      //::oDialog:AddFastKey( VK_F3, {|| ::oController:oCaracteristicasLineasController:Edit() } )
      //::oDialog:AddFastKey( VK_F4, {|| ::oController:oCaracteristicasLineasController:Delete() } )
      //::oDialog:AddFastKey( VK_F5, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) } )
   //end if

   ::oDialog:bStart  := {|| ::startActivate() }

   ACTIVATE DIALOG ::oDialog CENTER
  
   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD startActivate()

RETURN ( self )

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
                        "codigo" =>    {  "required"           => "El código es un dato requerido" ,;
                                          "unique"             => "El código introducido ya existe" } }
RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLCaracteristicasModel FROM SQLCompanyModel

   DATA cTableName                        INIT "articulos_caracteristicas"

   METHOD getColumns()

   METHOD getNombreWhereUuid( uuid )      INLINE ( ::getField( 'nombre', 'uuid', uuid ) )

   METHOD getNamesFromIdLanguagesPS( uuidCaracteristica, aIdsLanguages )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLCaracteristicasModel
   
   hset( ::hColumns, "id",       {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                    "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",     {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                    "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "codigo",   {  "create"    => "VARCHAR( 20 )"                           ,;
                                    "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "nombre",   {  "create"    => "VARCHAR( 200 )"                          ,;
                                    "default"   => {|| space( 200 ) } }                      )

   ::getTimeStampColumns()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getNamesFromIdLanguagesPS( uuidCaracteristica, aIdsLanguages ) CLASS SQLCaracteristicasModel

   local cName
   local hNames   := {=>}

   if Len( aIdsLanguages ) == 0
      Return ( hNames )
   end if

   cName    := ::getNombreWhereUuid( uuidCaracteristica )

   if Empty( cName )
      Return ( hNames )
   end if

   aEval( aIdsLanguages, {|id| hSet( hNames, AllTrim( Str( id ) ), AllTrim( cName ) ) } )

RETURN ( hNames )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//