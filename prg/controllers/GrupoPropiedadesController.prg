#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS GrupoPropiedadesController FROM SQLNavigatorController

   METHOD   New()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS GrupoPropiedadesController

   ::Super:New()

   ::cTitle                := "Grupo propiedades"

   ::cName                 := "grupo propiedades"

   ::hImage                := { "16" => "gc_box_open_16" }

   ::nLevel                := nLevelUsr( "01128" )

   ::oModel                := SQLGrupoPropiedadesModel():New( self )

   ::oBrowseView           := GrupoPropiedadesBrowseView():New( self )

   ::oDialogView           := GrupoPropiedadesView():New( self )

   ::oValidator            := GrupoPropiedadesValidator():New( self )

   ::oFilterController:setTableToFilter( ::oModel:cTableName )

RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS GrupoPropiedadesBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS GrupoPropiedadesBrowseView

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
      :cSortOrder          := 'nombre'
      :cHeader             := 'Nombre'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Propiedad 1'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo_primera_propiedad' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Valor propiedad 1'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'valor_primera_propiedad' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Propiedad 2'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo_segunda_propiedad' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Valor propiedad 2'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'valor_segunda_propiedad' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Comentarios'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'comentarios' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS GrupoPropiedadesView FROM SQLBaseView
  
   DATA oCodigoPropiedad1
   DATA oValorPropiedad1
   DATA oCodigoPropiedad2
   DATA oValorPropiedad2
   DATA oGetNombre
   DATA oGetComentario

   METHOD Activate()
   METHOD StartActivate()

   METHOD lValidPrimeraPropiedad()
   METHOD lValidSegundaPropiedad()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS GrupoPropiedadesView

   local oBmpGeneral

   DEFINE DIALOG ::oDialog RESOURCE "GRUPOSPROPIEDADES" TITLE ::LblTitle() + "grupo"

   REDEFINE BITMAP oBmpGeneral ;
      ID          900 ;
      RESOURCE    "gc_box_open_48" ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE GET   ::getModel():hBuffer[ "id" ] ;
      ID          100 ;
      WHEN        ( .f. ) ;
      OF          ::oDialog

   REDEFINE GET   ::oGetNombre ;
      VAR         ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      MEMO ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oCodigoPropiedad1 VAR ::oController:oModel:hBuffer[ "codigo_primera_propiedad" ] ;
      ID          120 ;
      IDTEXT      121 ;
      PICTURE     "@!" ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      BITMAP      "LUPA" ;
      OF          ::oDialog

      ::oCodigoPropiedad1:bChange   := {|| ::lValidPrimeraPropiedad() }
      ::oCodigoPropiedad1:bValid    := {|| ::lValidPrimeraPropiedad() }
      ::oCodigoPropiedad1:bHelp     := {|| brwProp( ::oCodigoPropiedad1, ::oCodigoPropiedad1:oHelpText ) }

   REDEFINE GET   ::oValorPropiedad1 VAR ::oController:oModel:hBuffer[ "valor_primera_propiedad" ] ;
      ID          130 ;
      IDTEXT      131 ;
      PICTURE     "@!" ;
      WHEN        ( !Empty( ::oController:oModel:hBuffer[ "codigo_primera_propiedad" ] ) .and. ::oController:isNotZoomMode() ) ;
      BITMAP      "LUPA" ;
      OF          ::oDialog

      ::oValorPropiedad1:bValid    := {|| lPrpAct( ::oValorPropiedad1, ::oValorPropiedad1:oHelpText, ::oController:oModel:hBuffer[ "codigo_primera_propiedad" ] ) }
      ::oValorPropiedad1:bhelp     := {|| brwPropiedadActual( ::oValorPropiedad1, ::oValorPropiedad1:oHelpText, ::oController:oModel:hBuffer[ "codigo_primera_propiedad" ] ) }

   REDEFINE GET   ::oCodigoPropiedad2 VAR ::oController:oModel:hBuffer[ "codigo_segunda_propiedad" ] ;
      ID          140 ;
      IDTEXT      141 ;
      PICTURE     "@!" ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      BITMAP      "LUPA" ;
      OF          ::oDialog

      ::oCodigoPropiedad2:bChange   := {|| ::lValidSegundaPropiedad() }
      ::oCodigoPropiedad2:bValid    := {|| ::lValidSegundaPropiedad() }
      ::oCodigoPropiedad2:bhelp     := {|| brwProp( ::oCodigoPropiedad2, ::oCodigoPropiedad2:oHelpText ) }

   REDEFINE GET   ::oValorPropiedad2 VAR ::oController:oModel:hBuffer[ "valor_segunda_propiedad" ] ;
      ID          150 ;
      IDTEXT      151 ;
      PICTURE     "@!" ;
      WHEN        ( !Empty( ::oController:oModel:hBuffer[ "codigo_segunda_propiedad" ] ) .and. ::oController:isNotZoomMode() ) ;
      BITMAP      "LUPA" ;
      OF          ::oDialog

      ::oValorPropiedad2:bValid    := {|| lPrpAct( ::oValorPropiedad2, ::oValorPropiedad2:oHelpText, ::oController:oModel:hBuffer[ "codigo_segunda_propiedad" ] ) }
      ::oValorPropiedad2:bhelp     := {|| brwPropiedadActual( ::oValorPropiedad2, ::oValorPropiedad2:oHelpText, ::oController:oModel:hBuffer[ "codigo_segunda_propiedad" ] ) }

   REDEFINE GET   ::oController:oModel:hBuffer[ "comentarios" ] ;
         ID       160 ;
         MEMO ;
         WHEN     ( ::oController:isNotZoomMode() ) ;
         OF       ::oDialog

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

   // Teclas rpidas-----------------------------------------------------------

   if ::oController:isNotZoomMode() 
      ::oDialog:AddFastKey( VK_F5, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) } )
   end if

   // evento bstart-----------------------------------------------------------

   ::oDialog:bStart    := {|| ::StartActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

   oBmpGeneral:End()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD StartActivate() CLASS GrupoPropiedadesView

   /*
   seteamos valores originales-------------------------------------------------
   */

   ::oCodigoPropiedad1:SetOriginal( ::oController:oModel:hBuffer[ "codigo_primera_propiedad" ] )
   ::oCodigoPropiedad2:SetOriginal( ::oController:oModel:hBuffer[ "codigo_segunda_propiedad" ] )

   /*
   Esto lo hacemos para que cargue los nombres al modificar--------------------
   */

   ::oCodigoPropiedad1:lValid()
   ::oValorPropiedad1:lValid()
   ::oCodigoPropiedad2:lValid()
   ::oValorPropiedad2:lValid()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD lValidPrimeraPropiedad() CLASS GrupoPropiedadesView

   if ::oCodigoPropiedad1:IsOriginalChanged( ::oController:oModel:hBuffer[ "codigo_primera_propiedad" ] )
      ::oValorPropiedad1:cText( "" )
      ::oValorPropiedad1:oHelpText:cText( "" )
      ::oCodigoPropiedad1:SetOriginal( ::oController:oModel:hBuffer[ "codigo_primera_propiedad" ] )
   end if

RETURN ( cProp( ::oCodigoPropiedad1, ::oCodigoPropiedad1:oHelpText ) )

//---------------------------------------------------------------------------//

METHOD lValidSegundaPropiedad() CLASS GrupoPropiedadesView

   if ::oCodigoPropiedad2:IsOriginalChanged( ::oController:oModel:hBuffer[ "codigo_segunda_propiedad" ] )
      ::oValorPropiedad2:cText( "" )
      ::oValorPropiedad2:oHelpText:cText( "" )
      ::oCodigoPropiedad2:SetOriginal( ::oController:oModel:hBuffer[ "codigo_segunda_propiedad" ] )
   end if

RETURN ( cProp( ::oCodigoPropiedad2, ::oCodigoPropiedad2:oHelpText ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS GrupoPropiedadesValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS GrupoPropiedadesValidator

   ::hValidators  := {  "nombre" => {  "required"     => "El nombre de la situación es un dato requerido",;
                                       "unique"       => "El nombre de la situación ya existe" } } 

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLGrupoPropiedadesModel FROM SQLBaseModel

   DATA cColumnCode              INIT "nombre"

   DATA cTableName               INIT "grupos_propiedades"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLGrupoPropiedadesModel 

   hset( ::hColumns, "id",                         {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"  ,;
                                                      "text"      => "Identificador"                  ,;
                                                      "default"   => {|| 0 } }                        )

   hset( ::hColumns, "uuid",                       {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"    ,;
                                                      "text"      => "Uuid"                           ,;
                                                      "default"   => {|| win_uuidcreatestring() } }   )

   hset( ::hColumns, "nombre",                     {  "create"    => "VARCHAR( 140 )"                 ,;
                                                      "default"   => {|| space( 140 ) } }             )

   hset( ::hColumns, "codigo_primera_propiedad",   {  "create"    => "VARCHAR(20)"                    ,;
                                                      "default"   => {|| space(20) } }                )

   hset( ::hColumns, "valor_primera_propiedad",    {  "create"    => "VARCHAR(200)"                   ,;
                                                      "default"   => {|| space(200) } }               )

   hset( ::hColumns, "codigo_segunda_propiedad",   {  "create"    => "VARCHAR(20)"                    ,;
                                                      "default"   => {|| space(20) } }                )

   hset( ::hColumns, "valor_segunda_propiedad",    {  "create"    => "VARCHAR(200)"                   ,;
                                                      "default"   => {|| space(200) } }               )

   hset( ::hColumns, "comentarios",                {  "create"    => "TEXT"                           ,;
                                                      "default"   => {|| "" } }                       )

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

CLASS GrupoPropiedadesRepository FROM SQLBaseRepository

   METHOD getTableName()         INLINE ( if( !empty( ::getController() ), ::getModelTableName(), SQLSituacionesModel():getTableName() ) )

   METHOD getNombres() 

END CLASS

//---------------------------------------------------------------------------//

METHOD getNombres() CLASS GrupoPropiedadesRepository

   local cSentence               := "SELECT nombre FROM " + ::getTableName()
   local aNombres                := ::getDatabase():selectFetchArrayOneColumn( cSentence )

RETURN ( aNombres )

//---------------------------------------------------------------------------//