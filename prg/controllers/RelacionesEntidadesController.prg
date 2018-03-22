#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS RelacionesEntidadesController FROM SQLNavigatorController

   DATA aRelacionables

   METHOD New()

   METHOD Edit()

   METHOD AppendLine()

   METHOD UpdateLine( uNewValue )

   METHOD DeleteLine()

   METHOD SearchEntidad()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS RelacionesEntidadesController

   ::Super:New( oSenderController )

   ::cTitle                := "Relaciones entidades"

   ::cName                 := "relaciones entidades"

   ::hImage                := { "16" => "gc_document_attachment_16" }

   ::nLevel                := nLevelUsr( "01201" )

   ::aRelacionables        := { "Centro de coste" }

   ::oModel                := SQLRelacionesEntidadesModel():New( self )

   ::oDialogView           := RelacionesEntidadesView():New( self )

   ::oValidator            := RelacionesEntidadesValidator():New( self )

   ::oRepository           := RelacionesEntidadesRepository():New( self )

   ::oBrowseView           := RelacionesEntidadesLineasBrowseView():New( self )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Edit() CLASS RelacionesEntidadesController

   local lEdit    := .t. 

   if isFalse( ::fireEvent( 'editing' ) )
      RETURN ( .f. )
   end if

   ::setEditMode()

   ::beginTransactionalMode()

   ::oRowSet      := ::oRepository:getRowRelacionesEntidades( ::oSenderController:oModel:cTableName, hget( ::oSenderController:oModel:hBuffer, "uuid" ) )

   ::fireEvent( 'openingDialog' )

   if ::DialogViewActivate()
      
      ::fireEvent( 'closedDialog' )  

      ::commitTransactionalMode()

      ::refreshRowSet()

      ::fireEvent( 'edited' ) 

   else

      lEdit       := .f.

      ::fireEvent( 'cancelEdited' ) 

      ::rollbackTransactionalMode()

   end if 

   ::fireEvent( 'exitEdited' ) 

   //::postEdit()

RETURN ( lEdit )

//---------------------------------------------------------------------------//

METHOD AppendLine() CLASS RelacionesEntidadesController

   local id    := ::oModel:insertBlankRelacionEntidad( ::oSenderController:oModel:cTableName, hget( ::oSenderController:oModel:hBuffer, "uuid" ) )

   ::oRowSet:refreshAndFindId( id )
   ::oBrowseView:oBrowse:Refresh()

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD DeleteLine() CLASS RelacionesEntidadesController

   ::oModel:deleteById( ::oRowSet:fieldGet( 'id' ) )

   ::oRowSet:Refresh()
   ::oBrowseView:oBrowse:Refresh()

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD UpdateLine( uNewValue, cCampo ) CLASS RelacionesEntidadesController

   ::oModel:updateFieldWhereId( ::oRowSet:fieldGet( 'id' ), cCampo, uNewValue )
   
   ::oRowSet:Refresh()
   ::oBrowseView:oBrowse:Refresh()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD SearchEntidad() CLASS RelacionesEntidadesController

   local Uuid  := TCentroCoste():Create( cPatDat() ):SearchToUuid()

   ::UpdateLine( Uuid, 'uuid_destino' )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLRelacionesEntidadesModel FROM SQLBaseModel

   DATA cTableName               INIT "relaciones_entidades"

   METHOD getColumns()

   METHOD insertBlankRelacionEntidad( entidad, uuid )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLRelacionesEntidadesModel

   hset( ::hColumns, "id",             {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE PRIMARY KEY"  ,;
                                          "text"      => "Identificador"                              ,;
                                          "default"   => {|| 0 } }                                    )

   hset( ::hColumns, "uuid",           {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"                ,;
                                          "text"      => "Uuid"                                       ,;
                                          "default"   => {|| win_uuidcreatestring() } }               )
   
   hset( ::hColumns, "entidad_origen", {  "create"    => "VARCHAR( 100 )"                             ,;
                                          "default"   => {|| space( 100 ) } }                         )

   hset( ::hColumns, "uuid_origen",    {  "create"    => "VARCHAR(40) NOT NULL"                       ,;
                                          "text"      => "Uuid"                                       ,;
                                          "default"   => {|| space( 40 ) } }                          )

   hset( ::hColumns, "entidad_destino", { "create"    => "VARCHAR( 100 )"                             ,;
                                          "default"   => {|| space( 100 ) } }                         )
   

   hset( ::hColumns, "uuid_destino",    { "create"    => "VARCHAR(40) NOT NULL"                       ,;
                                          "text"      => "Uuid"                                       ,;
                                          "default"   => {|| space( 40 ) } }                          )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

 METHOD insertBlankRelacionEntidad( entidad, uuid ) CLASS SQLRelacionesEntidadesModel

   local hBuffer  := {=>}

   hBuffer        := ::loadBlankBuffer()

   hSet( hBuffer, "entidad_origen", entidad )
   hSet( hBuffer, "uuid_origen", uuid )

RETURN ( ::insertBuffer( hBuffer ) )   

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS RelacionesEntidadesView FROM SQLBaseView
  
   DATA addButton
   DATA editButton
   DATA delButton

   METHOD Activate()

   METHOD getBrowse()      INLINE ( ::oController:oBrowseView:oBrowse )
   METHOD getModel()       INLINE ( ::oController:oModel )
   METHOD getSenderModel() INLINE ( ::oController:oSenderController:oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS RelacionesEntidadesView
   
   DEFINE DIALOG ::oDialog RESOURCE "Relaciones" TITLE "Relaciones"

      REDEFINE BITMAP ::oBmpDialog ;
         ID          900 ;
         RESOURCE    "gc_graph_claw_48" ;
         TRANSPARENT ;
         OF          ::oDialog

      REDEFINE BUTTON ::addButton ;
         ID          500 ;
         OF          ::oDialog ;
         ACTION      ( ::oController:AppendLine() )

      REDEFINE BUTTON ::delButton ;
         ID          501 ;
         OF          ::oDialog ;
         ACTION      ( ::oController:DeleteLine() )


      // Buttons lineas--------------------------------------------------------

      ::oController:oBrowseView:ActivateDialog( ::oDialog, 100 )

      REDEFINE BUTTON ;
         ID          IDOK ;
         OF          ::oDialog ;
         ACTION      ( ::oDialog:end( IDOK ) )

      REDEFINE BUTTON ;
         ID          IDCANCEL ;
         OF          ::oDialog ;
         CANCEL ;
         ACTION      ( ::oDialog:end() )

   // Teclas r�pidas-----------------------------------------------------------

   ::oDialog:AddFastKey( VK_F2, {|| ::oController:AppendLine() } )
   ::oDialog:AddFastKey( VK_F4, {|| ::oController:DeleteLine() } )
   ::oDialog:AddFastKey( VK_F5, {|| ::oDialog:end( IDOK ) } )

   // evento bstart-----------------------------------------------------------

   ::oDialog:bStart  := {|| ::getBrowse():SetFocus() }

   ACTIVATE DIALOG ::oDialog CENTER

   if !empty( ::oBmpDialog )
      ::oBmpDialog:End()
   end if

RETURN ( ::oDialog:nResult )

//--------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS RelacionesEntidadesValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS RelacionesEntidadesValidator

   ::hValidators  := {  "nombre" => {  "required"     => "El nombre de la situaci�n es un dato requerido",;
                                       "unique"       => "El nombre de la situaci�n ya existe" } } 

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS RelacionesEntidadesRepository FROM SQLBaseRepository

   METHOD getTableName()         INLINE ( SQLRelacionesEntidadesModel():getTableName() ) 

   METHOD getSQLSentenceRelacionesEntidades()

   METHOD getRowRelacionesEntidades()
   
END CLASS

//---------------------------------------------------------------------------//

METHOD getSQLSentenceRelacionesEntidades( entidad, uuid ) CLASS RelacionesEntidadesRepository

   local cSql  := "SELECT * "                                       
      cSql     += "FROM " + ::getTableName() + " "
      cSql     += "WHERE entidad_origen = " + quoted( entidad ) + " "                    
      cSql     +=    "AND uuid_origen = " + quoted( uuid )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getRowRelacionesEntidades( entidad, uuid ) CLASS RelacionesEntidadesRepository

   local cSentence   := ::getSQLSentenceRelacionesEntidades( entidad, uuid )

RETURN ( SQLRowSet():New():Build( cSentence ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS RelacionesEntidadesLineasBrowseView FROM SQLBrowseView

   METHOD addColumns()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS RelacionesEntidadesLineasBrowseView

   local cRelacion         := ""

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Id'
      :cOrder              := 'D'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Uuid'
      :nWidth              := 240
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid' ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Entidad origen'
      :nWidth              := 155
      :bEditValue          := {|| ::getRowSet():fieldGet( 'entidad_origen' ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Uuid origen'
      :nWidth              := 155
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid_origen' ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Entidad'
      :nWidth              := 250
      :bEditValue          := {|| ::getRowSet():fieldGet( 'entidad_destino' ) }
      :nEditType           := EDIT_LISTBOX
      :cEditPicture        := ""
      :aEditListTxt        := ::oController:aRelacionables
      :bOnPostEdit         := {| oCol, uNewValue, nKey | ::oController:UpdateLine( uNewValue, 'entidad_destino' ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Uuid destino'
      :nWidth              := 155
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid_destino' ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Relaci�n'
      :nWidth              := 250
      :bEditValue          := {|| CentroCosteModel():getNombre( ::getRowSet():fieldGet( 'uuid_destino' ) ) }
      :nEditType           := 5
      :cEditPicture        := ""
      :bEditBlock          := {|| ::oController:SearchEntidad() }
      :nBtnBmp             := 1
      :AddResource( "Lupa" )
   end with

RETURN ( self )

//---------------------------------------------------------------------------//