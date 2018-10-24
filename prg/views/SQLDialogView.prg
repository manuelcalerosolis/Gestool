#include "FiveWin.Ch"
#include "Factu.Ch"

//------------------------------------------------------------------------//

CLASS SQLDialogView FROM SQLBrowseableView 

   DATA oEvents

   DATA oDialog

   DATA cTitle

   DATA oMessage

   DATA oOfficeBar

   DATA oGetSearch
   DATA cGetSearch                              INIT space( 200 )

   DATA bInitActivate

   METHOD New( oController )
   METHOD End()

   METHOD Activate( bInitActivate )
      METHOD ActivateMoved()                    INLINE ( ::Activate( .f. ) )
      METHOD initActivate()                     INLINE ( .t. )

   METHOD isActive()                            INLINE ( ::oDialog != nil )

   METHOD Start()

   METHOD getGetSearch()                        INLINE ( ::oGetSearch )
   METHOD getWindow()                           INLINE ( ::oDialog )

   METHOD getSelectedBuffer()                   INLINE ( ::hSelectedBuffer )

   METHOD setTitle( cTitle )                    INLINE ( ::cTitle := cTitle )
   METHOD getTitle()                            INLINE ( iif( empty( ::cTitle ), ::defaultTitle(), ::cTitle ) )

   METHOD defaultTitle()                  

   METHOD Select()                              INLINE ( nil )

   METHOD Append()  

   METHOD setEvents( aEvents, bEvent )                
   METHOD setEvent( cEvent, bEvent )            INLINE ( if( !empty( ::oEvents ), ::oEvents:set( cEvent, bEvent ), ) )
   METHOD fireEvent( cEvent )                   INLINE ( if( !empty( ::oEvents ), ::oEvents:fire( cEvent ), ) )                            

//Construcciones tardias--------------------------------------------------------

   METHOD getMenutreeView()                     INLINE ( if( empty( ::oMenuTreeView ), ::oMenuTreeView := MenuTreeView():New( Self ), ), ::oMenuTreeView )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oController )

   ::oController           := oController

   //::oMenuTreeView         := MenuTreeView():New( Self )

   ::oEvents               := Events():New()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oDialog )
      ::oDialog:End()
   end if 

   if !empty( ::oMenuTreeView )
      ::oMenuTreeView:End()
   end if 

   if !empty( ::oEvents )
      ::oEvents:End()
   end if 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD Activate()

   if isFalse( ::fireEvent( 'activating' ) )
      RETURN ( .f. )
   end if

   DEFINE DIALOG           ::oDialog ;
      RESOURCE             "SELECTOR_DIALOG" ;
      TITLE                ::getTitle()

      REDEFINE GET         ::oGetSearch ;
         VAR               ::cGetSearch ; 
         ID                100 ;
         PICTURE           "@!" ;
         BITMAP            "Find" ;
         OF                ::oDialog

      // Browse-----------------------------------------------------------------

      ::getBrowseView():ActivateDialog( ::oDialog, 130 )

      // Eventos---------------------------------------------------------------

      ::oDialog:bStart              := {|| ::Start() }

      ::getGetSearch():bChange      := {|| ::onChangeSearch() }

   ACTIVATE DIALOG ::oDialog CENTER

   ::fireEvent( 'activated' ) 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD Append()

   if isFalse( ::fireEvent( 'appending' ) )
      RETURN ( .f. )
   end if

   ::oController:Append()

   ::fireEvent( 'appended' )

   ::Refresh()

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD setEvents( aEvents, bEvent )

RETURN ( aeval( aEvents, {|cEvent| ::setEvent( cEvent, bEvent ) } ) )

//----------------------------------------------------------------------------//

METHOD Start()

   local oBoton
   local oGrupo
   local oCarpeta
   local nCount            := 0

   ::oOfficeBar            := TDotNetBar():New( 0, 0, 2020, 118, ::oDialog, 1 )
   ::oOfficeBar:lPaintAll  := .f.
   ::oOfficeBar:lDisenio   := .f.
   ::oOfficeBar:SetStyle( 1 )

   ::oDialog:oTop          := ::oOfficeBar

   oCarpeta                := TCarpeta():New( ::oOfficeBar, ::oController:cTitle )

   oGrupo                  := TDotNetGroup():New( oCarpeta, 68, "", .f. )
      oBoton               := TDotNetButton():New( 60, oGrupo, ::oController:getImage( "48" ), "", 1, {|| ::RefreshRowSet() }, , , .f., .f., .f. )

   nCount                  := 0

   oGrupo                  := TDotNetGroup():New( oCarpeta, 428, "Opciones", .f. ) 
      oBoton               := TDotNetButton():New( 60, oGrupo, "lupa_32",                    "Buscar",         ++nCount, {|| ::getGetSearch():setFocus() }, , , .f., .f., .f. )
      oBoton               := TDotNetButton():New( 60, oGrupo, "new32",                      "Añadir",         ++nCount, {|| ::Append() }, , , .f., .f., .f. )
      
      if isTrue( ::fireEvent( 'addingduplicatebutton' ) )
         oBoton            := TDotNetButton():New( 60, oGrupo, "gc_document_text_plus2_32",  "Duplicar",       ++nCount, {|| ::oController:Duplicate(), ::Refresh() }, , , .f., .f., .f. )
      end if
      
      if isTrue( ::fireEvent( 'addingeditbutton' ) )
         oBoton            := TDotNetButton():New( 60, oGrupo, "gc_pencil__32",              "Modificar",      ++nCount, {|| ::oController:Edit(), ::Refresh() }, , , .f., .f., .f. )
      end if
      
      if isTrue( ::fireEvent( 'addingzoombutton' ) )
         oBoton            := TDotNetButton():New( 60, oGrupo, "gc_lock2_32",                "Zoom",           ++nCount, {|| ::oController:Zoom(), ::Refresh() }, , , .f., .f., .f. )
      end if

      oBoton               := TDotNetButton():New( 60, oGrupo, "del32",                      "Eliminar",       ++nCount, {|| ::oController:Delete( ::getBrowse():aSelected ), ::Refresh() }, , , .f., .f., .f. )
      oBoton               := TDotNetButton():New( 60, oGrupo, "gc_door_open2_32",           "Salir",          ++nCount, {|| ::oDialog:end() }, , , .f., .f., .f. )

   ::oController:restoreState() 

   ::oGetSearch:setFocus()
   
RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD defaultTitle()

   local cTitle   

   cTitle         := ::oController:getTitle() + " : "  

   if empty( ::oController:oController:oModel )
      RETURN ( cTitle )
   end if 

   if empty( ::oController:oController:oModel:hBuffer )
      RETURN ( cTitle )
   end if 

   if hhaskey( ::oController:oController:oModel:hBuffer, "codigo" ) 
      cTitle      += alltrim( ::oController:oController:oModel:hBuffer[ "codigo" ] ) + " - "
   end if 

   if hhaskey( ::oController:oController:oModel:hBuffer, "nombre" ) 
      cTitle      += alltrim( ::oController:oController:oModel:hBuffer[ "nombre" ] ) 
   end if 

RETURN ( cTitle )

//----------------------------------------------------------------------------//
