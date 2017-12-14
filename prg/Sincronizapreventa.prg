#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS SincronizaPreventa FROM TInfGen

   DATA oMetMsg      AS OBJECT
   DATA oRuta        AS OBJECT
   DATA cRuta        AS CHARACTER INIT Space( 250 )
   DATA oCodEmpresa  AS OBJECT
   DATA cCodEmpresa  AS CHARACTER INIT Space( 250 )
   DATA oMessage     AS OBJECT
   DATA cMessage     AS CHARACTER INIT ""

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Activate( oMenuItem, oWnd )

   METHOD Search()

END CLASS

//----------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      DATABASE NEW ::oDbfArt PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos.", "Atención" )

      ::CloseFiles()

      lOpen := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN( lOpen )

//----------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbfArt )
      ::oDbfArt:End()
   end if

   ::oDbfArt   := nil

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Activate( oMenuItem, oWnd )

   local oDlg
   local nLevel
   local nMetMsg        := 0
   local oCodArt
   local cCodArt        := ""
   local oSayArt
   local cSayArt        := ""
   local oBmp

   DEFAULT  oMenuItem   := "04016"
   DEFAULT  oWnd        := oWnd()

   //Nivel de usuario---------------------------------------------------------

   nLevel               := nLevelUsr( oMenuItem )
   if nAnd( nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      return nil
   end if

   // Cerramos todas las ventanas----------------------------------------------

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   if !::OpenFiles()
      Return ( Self )
   end if

   /*
   Cogemos los datos por defecto-----------------------------------------------
   */

   ::cRuta              :=  Padr( GetPvProfString( "Preventa", "Ruta",     Space( 250 ), cIniEmpresa() ), 250 )
   ::cCodEmpresa        :=  Padr( GetPvProfString( "Preventa", "Empresa",  Space( 250 ), cIniEmpresa() ), 250 )

   DEFINE DIALOG oDlg RESOURCE "SINCRONIZAPC" OF oWnd()

   REDEFINE BITMAP oBmp ;
      ID       600 ;
      RESOURCE "gc_pda_write_48" ;
      TRANSPARENT ;
      OF       oDlg

   REDEFINE GET ::oRuta ;
      VAR      ::cRuta ;
      ID       100 ;
      OF       oDlg

   REDEFINE GET ::oCodEmpresa ;
      VAR      ::cCodEmpresa ;
      ID       120 ;
      OF       oDlg

   REDEFINE SAY ::oMessage;
      PROMPT   ::cMessage ;
      ID       110 ;
      OF       oDlg

   REDEFINE BUTTON ;
      ID       500 ;
      OF       oDlg ;
      ACTION   ( ::Search( oDlg ) )

   REDEFINE BUTTON ;
      ID       550 ;
      OF       oDlg ;
      ACTION   ( oDlg:End() )

   ACTIVATE DIALOG oDlg CENTER

   ::CloseFiles()

   oBmp:End()

   /*
   Guardamos los datos en el fichero ini---------------------------------------
   */

   WritePProString( "Preventa", "Ruta",      ::cRuta,       cIniEmpresa() )
   WritePProString( "Preventa", "Empresa",   ::cCodEmpresa, cIniEmpresa() )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Search( oDlg )

   local oBlock
   local oError
   local cPatServidor   := AllTrim( ::cRuta ) + "EMP" + AllTrim( ::cCodEmpresa ) + "\"

   if Empty( ::cRuta ) .and. Empty( ::cCodEmpresa )
      msgStop( "La ruta del servidor no puede estar vacia." )
      return .f.
   end if

   oDlg:Disable()

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   /*
   Sinconizacion de tablas de agentes------------------------------------------
   */

   /*
   Sinconizacion de tablas de rutas--------------------------------------------
   */

   pdaRutaSenderReciver():CreateData( , ::oMessage, cPatServidor )

   /*
   Sinconizacion de tablas de almacen------------------------------------------
   */

   pdaAlmacenSenderReciver():CreateData( , ::oMessage, cPatServidor )

   /*
   Sinconizacion de tablas de tiva---------------------------------------------
   */

   pdaTIvaSenderReciver():CreateData( , ::oMessage, AllTrim( ::cRuta ) )

   /*
   Sinconizacion de tablas de pedcli-------------------------------------------
   */

   //pdaPedCliSenderReciver():CreateData( , ::oMessage, cPatServidor )

   /*
   Sinconizacion de tablas de albcli-------------------------------------------
   */

   //pdaAlbCliSenderReciver():CreateData( , ::oMessage, cPatServidor )

   /*
   Sinconizacion de tablas de RecCli-------------------------------------------
   */

   /*pdaRecCliSenderReciver():CreateDataPdaToPc( , ::oMessage, cPatServidor )

   pdaRecCliSenderReciver():CreateDataPcToPda( , ::oMessage, cPatServidor )*/

   /*
   Sinconizacion de tablas de transportistas-----------------------------------
   */

   pdaTransSenderReciver():CreateData( , ::oMessage, cPatServidor )

   /*
   Sinconizacion de tablas de movimientos de almacen---------------------------
   */

   //--------------------------------------------------------------------------

   RECOVER USING oError

      msgStop( "Ocurrió un error al sincronizar los ficheros" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   oDlg:Enable()

   msginfo( "Proceso finalizado correctamente" )

RETURN ( oDlg:End() )

//----------------------------------------------------------------------------//