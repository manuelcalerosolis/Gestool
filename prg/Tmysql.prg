#include "FiveWin.Ch"
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch"

// Function TMsConnect() ; Return nil

// Function TMsDatabase() ; Return nil

// Function TMsTable() ; Return nil

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

Method New( cHost, cUser, cPasswd, cDbName, nPort )

   DEFAULT cHost     := cSitSql()
   DEFAULT cUser     := cUsrSql()
   DEFAULT cPasswd   := cPswSql()
   DEFAULT cDbName   := cDtbSql()
   DEFAULT nPort     := nPrtSql()

   ::oConexion       := TMSConnect():New()  // Inicia el objeto Conexion

   ::cHost           := RTrim( cHost )
   ::cUser           := RTrim( cUser )
   ::cPasswd         := RTrim( cPasswd )
   ::cDbName         := RTrim( cDbName )
   ::nPort           := nPort

Return ( Self )

//----------------------------------------------------------------------------//

Method TestConexion()

   if Empty( ::oConexion )
      ::New()
   end if

   if ::Connect()
       MsgInfo( "Conectado" )
   else
       MsgInfo( "No hay conexión" )
   endif

   ::Destroy()

Return ( Self )

//----------------------------------------------------------------------------//