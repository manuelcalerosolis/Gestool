#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ads.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseView
  
   DATA oController

   DATA oDialog

   DATA oBtnOk

   DATA oBtnOkAndNew

   DATA oOfficeBar

   DATA oOfficeBarFolder

   DATA hTextMode                                     INIT {   __append_mode__      => "Añadiendo ",;
                                                               __edit_mode__        => "Modificando ",;
                                                               __zoom_mode__        => "Visualizando ",;
                                                               __duplicate_mode__   => "Duplicando " }

   DATA cImageName

   METHOD New()

   METHOD lblTitle()                                  INLINE ( iif(  hhaskey( ::hTextMode, ::oController:getMode() ),;
                                                                     hget( ::hTextMode, ::oController:getMode() ),;
                                                                     "" ) )

   // Facades------------------------------------------------------------------

   METHOD getModel()                                  INLINE ( ::oController:oModel )
   METHOD getModelBuffer()                            INLINE ( ::oController:oModel:hBuffer ) 
   METHOD setGetModelBuffer( uValue, cName )          INLINE ( iif(  hb_isnil( uValue ),;
                                                                     hGet( ::oController:oModel:hBuffer, cName ),;
                                                                     hSet( ::oController:oModel:hBuffer, cName, uValue ) ) )

   METHOD getController()                             INLINE ( ::oController )    
   METHOD getSenderController()                       INLINE ( ::oController:oSenderController )    

   METHOD createOfficeBar()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController  := oController

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD createOfficeBar()

   local oGrupo

   if empty( ::oDialog )
      RETURN ( Self )
   end if 

   ::oOfficeBar               := TDotNetBar():New( 0, 0, 2020, 115, ::oDialog, 1 )

   ::oOfficeBar:lPaintAll     := .f.
   ::oOfficeBar:lDisenio      := .f.

   ::oOfficeBar:SetStyle( 1 )

   ::oDialog:oTop             := ::oOfficeBar

   ::oOfficeBarFolder         := TCarpeta():New( ::oOfficeBar, ::oController:getTitle() )

   msgalert(::oController:getImage( "48" ), "48")

   if !empty( ::oController:getImage( "48" ) )
      oGrupo                  := TDotNetGroup():New( ::oOfficeBarFolder, 66, "", .f. )
         TDotNetButton():New( 60, oGrupo, ::oController:getImage( "48" ), "", 1, {|| "" }, , , .f., .f., .f. )
   end if

   if !empty( ::oController:oLineasController )
      oGrupo                  := TDotNetGroup():New( ::oOfficeBarFolder, 246, "Líneas", .f. )
         ::oBtnAppend         := TDotNetButton():New( 60, oGrupo, "new32", "Añadir [F2]", 1, {|| ::oController:oLineasController:Append() }, , {|| ::oController:isNotZoomMode() }, .f., .f., .f. )
         ::oBtnEdit           := TDotNetButton():New( 60, oGrupo, "gc_pencil__32", "Modificar [F3]", 2, {|| ::oController:oLineasController:Edit() }, , {|| ::oController:isNotZoomMode() }, .f., .f., .f. )
         ::oBtnDelete         := TDotNetButton():New( 60, oGrupo, "del32", "Eliminar [F4]", 3, {|| ::oController:oLineasController:Delete( ::oSQLBrowseView:getBrowseSelected() ) }, , {|| ::oController:isNotZoomMode() }, .f., .f., .f. )
                                 TDotNetButton():New( 60, oGrupo, "gc_binocular_32", "Buscar", 4, {|| ::oController:oLineasController:Search() }, , , .f., .f., .f. )
   end if 

   if ::oController:isAppendMode()
      oGrupo                  := TDotNetGroup():New( ::oOfficeBarFolder, 126, "Acciones", .f. )
         ::oBtnOk             := TDotNetButton():New( 60, oGrupo, "gc_floppy_disk_32", "Aceptar y cerrar [F5]", 1, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, , , .f., .f., .f. )
         ::oBtnOkAndNew       := TDotNetButton():New( 60, oGrupo, "gc_floppy_disk_32", "Aceptar y nuevo [F6]", 2, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOKANDNEW ), ) }, , , .f., .f., .f. )
   else
      oGrupo                  := TDotNetGroup():New( ::oOfficeBarFolder, 66, "Acciones", .f. )
         ::oBtnOk             := TDotNetButton():New( 60, oGrupo, "gc_floppy_disk_32", "Aceptar y cerrar [F5]", 1, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, , , .f., .f., .f. )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

