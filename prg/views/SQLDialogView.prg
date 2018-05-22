#include "FiveWin.Ch"
#include "Factu.Ch"

//------------------------------------------------------------------------//

CLASS SQLDialogView FROM SQLBrowseableView 

   DATA oDialog
   DATA oMessage

   DATA oOfficeBar

   DATA oGetSearch
   DATA cGetSearch                        INIT space( 200 )

   DATA oComboBoxOrder
   DATA cComboBoxOrder

   DATA bInitActivate

   METHOD End()

   METHOD Activate( bInitActivate )
      METHOD ActivateMoved()              INLINE ( ::Activate( .f. ) )
      METHOD initActivate()               INLINE ( .t. )

   METHOD isActive()                      INLINE ( ::oDialog != nil )

   METHOD Start()

   METHOD getGetSearch()                  INLINE ( ::oGetSearch )
   METHOD getComboBoxOrder()              INLINE ( ::oComboBoxOrder )
   METHOD getWindow()                     INLINE ( ::oDialog )

   METHOD getSelectedBuffer()             INLINE ( ::hSelectedBuffer )

   METHOD Tittle()                        INLINE ( ::oController:getTitle() + space( 1 ) + ;
                                                   lower( ::oController:oSenderController:cTitle ) + ": " + ;
                                                   AllTrim( ::oController:oSenderController:oModel:hBuffer[ "codigo" ] ) + " - " + ;
                                                   ::oController:oSenderController:oModel:hBuffer[ "nombre" ] )

   METHOD Select()                        INLINE ( nil )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD Activate()

   DEFINE DIALOG           ::oDialog ;
      RESOURCE             "SELECTOR_DIALOG" ;
      TITLE                ::Tittle()

      REDEFINE GET         ::oGetSearch ;
         VAR               ::cGetSearch ; 
         ID                100 ;
         PICTURE           "@!" ;
         BITMAP            "FIND" ;
         OF                ::oDialog

      REDEFINE COMBOBOX    ::oComboBoxOrder ;
         VAR               ::cComboBoxOrder ;
         ID                110 ;
         OF                ::oDialog

      ::oComboBoxOrder:bChange      := {|| ::onChangeCombo() } 

      // Browse-----------------------------------------------------------------

      ::getBrowseView():ActivateDialog( ::oDialog, 130 )

      ::getBrowseView():restoreStateFromModel() 

      ::getBrowseView():gotoIdFromModel()

      ::getBrowseView():setColumnOrder( ::getModel():getOrderBy(), ::getModel():getOrientation() ) 

      // Eventos---------------------------------------------------------------

      ::oDialog:bStart              := {|| ::Start() }

      ::getGetSearch():bChange      := {|| ::onChangeSearch() }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oDialog )
      ::oDialog:End()
   end if 

   ::oDialog            := nil

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD Start()

   local oBoton
   local oGrupo
   local oCarpeta

   ::oOfficeBar            := TDotNetBar():New( 0, 0, 2020, 128, ::oDialog, 1 )
   ::oOfficeBar:lPaintAll  := .f.
   ::oOfficeBar:lDisenio   := .f.
   ::oOfficeBar:SetStyle( 1 )

   ::oDialog:oTop          := ::oOfficeBar

   oCarpeta                := TCarpeta():New( ::oOfficeBar, ::oController:cTitle )

   oGrupo                  := TDotNetGroup():New( oCarpeta, 86, ::oController:cTitle, .f. )
      oBoton               := TDotNetButton():New( 80, oGrupo, ::oController:getImage( "64" ), "", 1, , , , .f., .f., .f. )

   oGrupo                  := TDotNetGroup():New( oCarpeta, 428, "Opciones", .f. ) 
      oBoton               := TDotNetButton():New( 60, oGrupo, "LUPA_32",                    "Buscar",         1, {|| ::getGetSearch():setFocus() }, , , .f., .f., .f. )
      oBoton               := TDotNetButton():New( 60, oGrupo, "gc_recycle_32",              "Refrescar",      2, {|| ::RefreshRowSet() }, , , .f., .f., .f. )
      oBoton               := TDotNetButton():New( 60, oGrupo, "New32",                      "Añadir",         3, {|| ::oController:Append(), ::Refresh() }, , , .f., .f., .f. )
      oBoton               := TDotNetButton():New( 60, oGrupo, "gc_document_text_plus2_32",  "Duplicar",       4, {|| ::oController:Duplicate(), ::Refresh() }, , , .f., .f., .f. )
      oBoton               := TDotNetButton():New( 60, oGrupo, "gc_pencil__32",              "Modificar",      5, {|| ::oController:Edit(), ::Refresh() }, , , .f., .f., .f. )
      oBoton               := TDotNetButton():New( 60, oGrupo, "gc_lock2_32",                "Zoom",           6, {|| ::oController:Zoom(), ::Refresh() }, , , .f., .f., .f. )
      oBoton               := TDotNetButton():New( 60, oGrupo, "Del32",                      "Eliminar",       7, {|| ::oController:Delete( ::getBrowse():aSelected ), ::Refresh() }, , , .f., .f., .f. )

   oGrupo                  := TDotNetGroup():New( oCarpeta, 68, "", .f. ) 
      oBoton               := TDotNetButton():New( 60, oGrupo, "gc_door_open2_32",           "Salir",          1, {|| ::oDialog:end() }, , , .f., .f., .f. )


   ::oComboBoxOrder:SetItems( ::getBrowseView():getColumnsHeaders() )

   ::oComboBoxOrder:Set( ::getBrowseView():getColumnOrderHeader() )

   ::oGetSearch:setFocus()

RETURN ( Self )

//----------------------------------------------------------------------------//