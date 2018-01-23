#include "FiveWin.Ch"
#include "Factu.Ch"

//------------------------------------------------------------------------//

CLASS OfficeBarView

   DATA oSender

   DATA oOfficeBar

   DATA oOfficeBarFolder

   DATA oBtnOk
   DATA oBtnOkAndNew
   DATA oBtnCancel

   DATA oBtnEdit
   DATA oBtnAppend
   DATA oBtnDelete

   METHOD New( oSender )
   METHOD End()

   METHOD createButtonImage()
   METHOD createButtonsLine( oLineasController )
   METHOD createButtonsDialog()

   METHOD getDialog()         INLINE ( ::oSender:oDialog )
   METHOD getController()     INLINE ( ::oSender:oController )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oSender )

   ::oSender                  := oSender

   if empty( ::getDialog() )
      RETURN ( Self )
   end if 

   ::oOfficeBar               := TDotNetBar():New( 0, 0, 2020, 115, ::getDialog(), 1 )

   ::oOfficeBar:lPaintAll     := .f.
   ::oOfficeBar:lDisenio      := .f.

   ::oOfficeBar:SetStyle( 1 )

   ::getDialog():oTop         := ::oOfficeBar

   ::oOfficeBarFolder         := TCarpeta():New( ::oOfficeBar, ::getController():getTitle() )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD createButtonImage()

   local oGrupo

   if !empty( ::getController():getImage( "64" ) )
      oGrupo                  := TDotNetGroup():New( ::oOfficeBarFolder, 66, "", .f. )
         TDotNetButton():New( 60, oGrupo, ::getController():getImage( "64" ), "", 1, {|| "" }, , , .f., .f., .f. )
   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD createButtonsLine( oLineasController, oSQLBrowseView )

   local oGrupo

   if empty( ::getController():oLineasController )
      RETURN ( Self )
   end if 

   if ::getController():isNotZoomMode()

      oGrupo               := TDotNetGroup():New( ::oOfficeBarFolder, 246, "Líneas", .f. )

      ::oBtnAppend         := TDotNetButton():New( 60, oGrupo, "new32",             "Añadir [F2]",    1, {|| oLineasController:Append() }, ,    {|| ::getController():isNotZoomMode() }, .f., .f., .f. )
      ::oBtnEdit           := TDotNetButton():New( 60, oGrupo, "gc_pencil__32",     "Modificar [F3]", 2, {|| oLineasController:Edit() }, ,      {|| ::getController():isNotZoomMode() }, .f., .f., .f. )
      ::oBtnDelete         := TDotNetButton():New( 60, oGrupo, "del32",             "Eliminar [F4]",  3, {|| oLineasController:Delete() }, ,    {|| ::getController():isNotZoomMode() }, .f., .f., .f. )
                              TDotNetButton():New( 60, oGrupo, "gc_binocular_32",   "Buscar",         4, {|| oLineasController:Search() }, , , .f., .f., .f. )

      ::getDialog():addFastKey( VK_F2, {|| ::oBtnAppend:Action() } )
      ::getDialog():addFastKey( VK_F3, {|| ::oBtnEdit:Action() } )
      ::getDialog():addFastKey( VK_F4, {|| ::oBtnDelete:Action() } )

   else 

      oGrupo               := TDotNetGroup():New( ::oOfficeBarFolder, 66, "Líneas", .f. )

                              TDotNetButton():New( 60, oGrupo, "gc_binocular_32",   "Buscar",         1, {|| oLineasController:Search() }, , , .f., .f., .f. )

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD createButtonsDialog()

   local oGrupo

   if ::getController():isAppendMode()
      oGrupo                  := TDotNetGroup():New( ::oOfficeBarFolder, 186, "Acciones", .f. )
         ::oBtnOk             := TDotNetButton():New( 60, oGrupo, "gc_floppy_disk_32", "Aceptar y cerrar [F5]", 1, {|| if( validateDialog( ::getDialog() ), ::getDialog():end( IDOK ), ) }, , , .f., .f., .f. )
         ::oBtnOkAndNew       := TDotNetButton():New( 60, oGrupo, "gc_floppy_disk_plus_32", "Aceptar y nuevo [F6]", 2, {|| if( validateDialog( ::getDialog() ), ::getDialog():end( IDOKANDNEW ), ) }, , , .f., .f., .f. )
         ::oBtnCancel         := TDotNetButton():New( 60, oGrupo, "gc_door_open2_32", "Salir", 3, {|| ::getDialog():end() }, , , .f., .f., .f. )

         ::getDialog():addFastKey( VK_F5, {|| ::oBtnOk:Action() } )
         ::getDialog():addFastKey( VK_F6, {|| ::oBtnOkAndNew:Action() } )
   else
      oGrupo                  := TDotNetGroup():New( ::oOfficeBarFolder, 126, "Acciones", .f. )
         ::oBtnOk             := TDotNetButton():New( 60, oGrupo, "gc_floppy_disk_32", "Aceptar y cerrar [F5]", 1, {|| if( validateDialog( ::getDialog() ), ::getDialog():end( IDOK ), ) }, , , .f., .f., .f. )
         ::oBtnCancel         := TDotNetButton():New( 60, oGrupo, "gc_door_open2_32",  "Salir", 2, {|| ::getDialog():end() }, , , .f., .f., .f. )

         ::getDialog():addFastKey( VK_F5, {|| ::oBtnOk:Action() } )
   end if 


RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD End()

   ::oOfficeBar:End()

RETURN ( nil )

//----------------------------------------------------------------------------//


