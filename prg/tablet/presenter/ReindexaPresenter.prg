#include "FiveWin.Ch"
#include "Factu.ch"

CLASS ReindexaPresenter FROM DocumentsSales

   DATA oReindexaView

   DATA lSyncronize                    AS LOGIC INIT .t.

   METHOD New()

   METHOD runNavigator()

   METHOD onPreRunNavigator()          INLINE ( .t. )

   METHOD play()

   METHOD runReindexa()

   METHOD setSyncronize( lSyncronize ) INLINE ( ::lSyncronize := lSyncronize )
   METHOD getSyncronize()              INLINE ( ::lSyncronize )

   METHOD setLastReindex()             INLINE ( writePProString( "Tablet", "LastReindex", dtos( date() ), cIniAplication() ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS ReindexaPresenter

   ::oReindexaView    := ReindexaView():New( self )

   ::oReindexaView:setTitleDocumento( "Regeneración de indices" )

Return( self )

//---------------------------------------------------------------------------//

METHOD runNavigator() CLASS ReindexaPresenter

   if !empty( ::oReindexaView )
      ::oReindexaView:Resource()
   end if

Return( self )

//---------------------------------------------------------------------------//

METHOD play() CLASS ReindexaPresenter

   if ::onPreRunNavigator()
      ::runNavigator()
   end if 

return ( self )

//---------------------------------------------------------------------------//

METHOD runReindexa() CLASS ReindexaPresenter
 
   local oClassReindexa

   if nUsrInUse() > 1
      ApoloMsgStop( "Hay más de un usuario conectado a la aplicación", "Atención" )
      return nil
   end if

   if !TReindex():lCreateHandle()
      ApoloMsgStop( "Esta opción ya ha sido inicada por otro usuario", "Atención" )
      return nil
   end if

   oClassReindexa                      := TDataCenter()

   if !Empty( oClassReindexa )

      oClassReindexa:aLgcIndices[ 1 ]  := .t.
      oClassReindexa:aLgcIndices[ 2 ]  := .t.
      oClassReindexa:aLgcIndices[ 3 ]  := .t.

      oClassReindexa:aProgress[ 1 ]    := ::oReindexaView:oMeterSistema
      oClassReindexa:aProgress[ 2 ]    := ::oReindexaView:oMeterEmpresa
      oClassReindexa:aProgress[ 3 ]    := ::oReindexaView:oMeterSincronizacion
      oClassReindexa:nProgress[ 1 ]    := ::oReindexaView:nMeterSistema
      oClassReindexa:nProgress[ 2 ]    := ::oReindexaView:nMeterEmpresa
      oClassReindexa:nProgress[ 3 ]    := ::oReindexaView:nMeterSincronizacion

      oClassReindexa:oMsg              := ::oReindexaView:oSayInformacion

      oClassReindexa:BuildData()
      oClassReindexa:BuildEmpresa()
      oClassReindexa:Reindex()
      
      if ::lSyncronize
         oClassReindexa:Syncronize()
      end if 

      ::setLastReindex()

   end if

Return ( self )

//---------------------------------------------------------------------------//