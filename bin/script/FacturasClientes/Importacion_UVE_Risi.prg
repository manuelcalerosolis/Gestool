#include "hbclass.ch"

#define __separtor__    "|#|"

#define CRLF chr( 13 ) + chr( 10 )

//---------------------------------------------------------------------------//

Function Inicio()

   ImportacionUVERisi():New()

Return ( nil )

//---------------------------------------------------------------------------//

CREATE CLASS ImportacionUVERisi

   DATA nView

   DATA oUve

   DATA cFileUVE
   DATA nFileHandle

   DATA aUVELines                               INIT {}

   METHOD New()                                 CONSTRUCTOR

   METHOD getFileUVE()
   METHOD isFileUVE() 
   METHOD openFileUVE()
   METHOD closeFileUVE()                        INLINE ( fclose( ::nFileHandle ) )
   METHOD processFileUVE()
      METHOD processLineUVE( cLine)             
         METHOD insertLineUVE( aLine )

   METHOD writeUVEtoGestool()                   VIRTUAL

   METHOD OpenFiles()
   METHOD CloseFiles()                          INLINE ( D():DeleteView( ::nView ) )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS ImportacionUVERisi

   ::getFileUVE()

   if !::isFileUVE()
      Return ( Self )
   end if

   if ::openFileUVE()
      ::processFileUVE()
      ::closeFileUVE()
   end if 

   if !::OpenFiles()
      Return ( Self )
   end if 

   ::writeUVEtoGestool()

   ::CloseFiles()

   msgInfo( "Porceso finalizado" )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD getFileUVE()

   ::cFileUVE  := cGetFile( "Csv ( *.* ) | " + "*.*", "Seleccione el fichero a importar" )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD isFileUVE()

   if !empty( ::cFileUVE )
      Return ( file( ::cFileUVE ) )
   end if 

Return ( .f. )

//---------------------------------------------------------------------------//

METHOD openFileUVE()

   ::nFileHandle := fOpen( ::cFileUVE )

   if ferror() != 0
      Return ( .f. )
   end if  

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD processFileUVE()

   local cLine 

   while ( hb_freadline( ::nFileHandle, @cLine ) == 0 )
      ::processLineUVE( cLine )
   end while  
   
Return ( Self )

//---------------------------------------------------------------------------//

METHOD processLineUVE( cLine )

   local aLine          := hb_atokens( cLine, __separtor__ )

   if !empty( aLine )
      msgWait( hb_valtoexp( aLine ), "aLine", 0.1 )
      ::insertLineUVE( aLine )
   end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD insertLineUVE( aLine )

   local hUve   := {=>}
   local oUve   := oUve:New()

   hset( hUve, "NumeroFactura",   aLine[ 1 ] )
   hset( hUve, "NumeroLinea",     aLine[ 2 ] )

   aadd( ::aUVELines, hUve )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() 

   local oError
   local oBlock
   local lOpenFiles     := .t.

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::nView           := D():CreateView()

      D():FacturasClientes( ::nView )
      ( D():FacturasClientes( ::nView ) )->( ordsetfocus( "dFecFac" ) )

      D():FacturasClientesLineas( ::nView )    
      ( D():FacturasClientesLineas( ::nView ) )->( ordsetfocus( "nNumLin" ) )

      D():Clientes( ::nView )

      D():Articulos( ::nView )

      D():GruposClientes( ::nView )

      D():Get( "ArtCodebar", ::nView )  

      D():Get( "Ruta", ::nView )

      D():Get( "Agentes", ::nView )

   RECOVER USING oError

      lOpenFiles        := .f.

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lOpenFiles )

//---------------------------------------------------------------------------//

#include "UVE.prg"
