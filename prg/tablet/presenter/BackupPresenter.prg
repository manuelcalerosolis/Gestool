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

   MsgInfo( "Ejecuto la copia de seguridad" )

   oClassBackup            := TBackup():Create()

   MsgInfo( oClassBackup )
   MsgInfo( oClassBackup:ClassName() )
   MsgInfo( uFieldEmpresa( "CodEmp" ) )

   if !Empty( oClassBackup )
      oClassBackup:aEmp    := { { .t., uFieldEmpresa( "CodEmp" ), uFieldEmpresa( "cNombre" ) } }
      oClassBackup:cDir    := ::oBackupView:cGetFolder
      oClassBackup:ZipFiles()
   end if

Return ( self )

//---------------------------------------------------------------------------//