#include "FiveWin.Ch"
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TMySql

   DATA  oConexion
   DATA  cHost
   DATA  cUser
   DATA  cPasswd
   DATA  cDbName
   DATA  nPort

   Method New()

   Method Connect()  INLINE   ( ::oConexion:Connect( ::cHost, ::cUser, ::cPasswd, ::cDbName, ::nPort ) )
   Method Destroy()  INLINE   ( ::oConexion:Destroy() )

   Method TestConexion()

END CLASS

//----------------------------------------------------------------------------//

Method New()

   ::oConexion       := TMSConnect():New()  // Inicia el objeto Conexion
   ::cHost           := cSitSql()
   ::cUser           := cUsrSql()
   ::cPasswd         := cPswSql()
   ::cDbName         := cDtbSql()
   ::nPort           := nPrtSql()

Return ( Self )

//----------------------------------------------------------------------------//

Method TestConexion()

   if Empty( ::oConexion )
      ::New()
   end if

   if ::Connect()
       MsgInfo( "Conectado" )
   endif

   ::Destroy()

Return ( Self )

//----------------------------------------------------------------------------//