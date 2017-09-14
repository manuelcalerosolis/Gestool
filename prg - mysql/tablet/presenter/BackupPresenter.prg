#include "FiveWin.Ch"
#include "Factu.ch"

CLASS BackupPresenter FROM DocumentsSales

   DATA oBackupView

   METHOD New()

   METHOD runNavigator()

   METHOD onPreRunNavigator()    INLINE ( .t. )

   METHOD play()

   METHOD runBackup()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS BackupPresenter

   ::oBackupView    := backupView():New( self )
   ::oBackupView:setTitleDocumento( "Copia de seguridad" )

Return( self )

//---------------------------------------------------------------------------//

METHOD runNavigator() CLASS BackupPresenter

   if !empty( ::oBackupView )
      ::oBackupView:Resource()
   end if

Return( self )

//---------------------------------------------------------------------------//

METHOD play() CLASS BackupPresenter

   if ::onPreRunNavigator()
      ::runNavigator()
   end if 

return ( self )

//---------------------------------------------------------------------------//

METHOD runBackup() CLASS BackupPresenter
 
   local oClassBackup

   oClassBackup            := TBackup():Create()

   if !Empty( oClassBackup )

      if oClassBackup:OpenFiles()

         oClassBackup:aEmp                := { { .t., uFieldEmpresa( "CodEmp" ), uFieldEmpresa( "cNombre" ) } }
         oClassBackup:lDir                := .t.
         oClassBackup:lInternet           := .f.
         oClassBackup:cDir                := ::oBackupView:cGetFolder
         oClassBackup:cFile               := "C:\InfomeCopia.Txt"
         oClassBackup:oProgreso           := ::oBackupView:oMeter
         oClassBackup:oProgresoTarget     := ::oBackupView:oMeterTarget
         
         if oClassBackup:ZipFiles()
            ApoloMsgStop( "Proceso finalizado con éxito." ) 
         end if

      end if

      oClassBackup:CloseFiles()

   end if

Return ( self )

//---------------------------------------------------------------------------//