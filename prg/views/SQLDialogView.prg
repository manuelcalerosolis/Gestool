#include "FiveWin.Ch"
#include "Factu.Ch"

//------------------------------------------------------------------------//

CLASS SQLDialogView FROM SQLBrowseableView 

   DATA oDialog

   DATA cTitle

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

   METHOD setTitle( cTitle )              INLINE ( ::cTitle := cTitle )
   METHOD getTitle()                      INLINE ( iif( empty( ::cTitle ), ::defaultTitle(), ::cTitle ) )

   METHOD defaultTitle()                  

   METHOD Select()                        INLINE ( nil )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD Activate()

   DEFINE DIALOG           ::oDialog ;
      RESOURCE             "SELECTOR_DIALOG" ;
      TITLE                ::getTitle()

      REDEFINE GET         ::oGetSearch ;
         VAR               ::cGetSearch ; 
         ID                100 ;
         PICTURE           "@!" ;
         BITMAP            "Find" ;
         OF                ::oDialog

      REDEFINE COMBOBOX    ::oComboBoxOrder ;
         VAR               ::cComboBoxOrder ;
         ID                110 ;
         OF                ::oDialog

      ::oComboBoxOrder:bChange      := {|| ::onChangeCombo() } 

      // Browse-----------------------------------------------------------------

      ::getBrowseView():ActivateDialog( ::oDialog, 130 )

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

   ::oOfficeBar            := TDotNetBar():New( 0, 0, 2020, 118, ::oDialog, 1 )
   ::oOfficeBar:lPaintAll  := .f.
   ::oOfficeBar:lDisenio   := .f.
   ::oOfficeBar:SetStyle( 1 )

   ::oDialog:oTop          := ::oOfficeBar

   oCarpeta                := TCarpeta():New( ::oOfficeBar, ::oController:cTitle )

   oGrupo                  := TDotNetGroup():New( oCarpeta, 68, "", .f. )
      oBoton               := TDotNetButton():New( 60, oGrupo, ::oController:getImage( "48" ), "", 1, {|| ::RefreshRowSet() }, , , .f., .f., .f. )

   oGrupo                  := TDotNetGroup():New( oCarpeta, 368, "Opciones", .f. ) 
      oBoton               := TDotNetButton():New( 60, oGrupo, "lupa_32",                    "Buscar",         1, {|| ::getGetSearch():setFocus() }, , , .f., .f., .f. )
      oBoton               := TDotNetButton():New( 60, oGrupo, "new32",                      "Añadir",         2, {|| ::oController:Append(), ::Refresh() }, , , .f., .f., .f. )
      oBoton               := TDotNetButton():New( 60, oGrupo, "gc_document_text_plus2_32",  "Duplicar",       3, {|| ::oController:Duplicate(), ::Refresh() }, , , .f., .f., .f. )
      oBoton               := TDotNetButton():New( 60, oGrupo, "gc_pencil__32",              "Modificar",      4, {|| ::oController:Edit(), ::Refresh() }, , , .f., .f., .f. )
      oBoton               := TDotNetButton():New( 60, oGrupo, "gc_lock2_32",                "Zoom",           5, {|| ::oController:Zoom(), ::Refresh() }, , , .f., .f., .f. )
      oBoton               := TDotNetButton():New( 60, oGrupo, "del32",                      "Eliminar",       6, {|| ::oController:Delete( ::getBrowse():aSelected ), ::Refresh() }, , , .f., .f., .f. )

   oGrupo                  := TDotNetGroup():New( oCarpeta, 68, "", .f. )
      oBoton               := TDotNetButton():New( 60, oGrupo, "gc_door_open2_32",           "Salir",          1, {|| ::oDialog:end() }, , , .f., .f., .f. )

   ::oComboBoxOrder:SetItems( ::getBrowseView():getColumnsHeaders() )

   ::oComboBoxOrder:Set( ::getBrowseView():getColumnOrderHeader() )

   ::oController:restoreState() 

   ::oGetSearch:setFocus()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD defaultTitle()

   local cTitle   := ::oController:getTitle() + " : "  

   if hhaskey( ::oController:oSenderController:oModel:hBuffer, "codigo" ) 
      cTitle      += alltrim( ::oController:oSenderController:oModel:hBuffer[ "codigo" ] ) + " - "
   end if 
   
   if hhaskey( ::oController:oSenderController:oModel:hBuffer, "nombre" ) 
      cTitle      += alltrim( ::oController:oSenderController:oModel:hBuffer[ "nombre" ] ) 
   end if 

RETURN ( cTitle )

//----------------------------------------------------------------------------//
