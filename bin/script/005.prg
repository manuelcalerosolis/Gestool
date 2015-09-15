#include "c:\gestool\include\Factu.ch"

static dbfArticulo
static facArticulo
static lOpenFiles       := .f.

//---------------------------------------------------------------------------//

function InicioHRB()

   local cDirOrigen
   local aDirectorio
   local cFichero

   /*
   Abrimos los ficheros necesarios---------------------------------------------
   */

   if !OpenFiles( .f. )
      return .f.
   end if

   CursorWait()
   
   ImportaArticulo()

   Msginfo( "Importación realizada con éxito" )

   CursorWe()

   /*
   Cerramos los ficheros abiertos anteriormente--------------------------------
   */

   CloseFiles()

return .t.

//---------------------------------------------------------------------------//

static function OpenFiles()

   local oError
   local oBlock

   CursorWait()

   oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      lOpenFiles  := .t.

      USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
      SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

      USE ( "C:\Users\Articulo.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CODEBAR", @facArticulo ) )
      SET ADSINDEX TO ( "C:\Users\Articulo.Cdx" ) ADDITIVE

   RECOVER USING oError

      lOpenFiles  := .f.

      msgStop( ErrorMessage( oError ), 'Imposible abrir las bases de datos' )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpenFiles
      CloseFiles()
   end if

   CursorWE()

return ( lOpenFiles )

//--------------------------------------------------------------------------//

static function CloseFiles()

   if dbfArticulo != nil
      ( dbfArticulo )->( dbCloseArea() )
   end if

   if facArticulo != nil
      ( facArticulo )->( dbCloseArea() )
   end if 

   lOpenFiles        := .f.

RETURN ( .t. )

//----------------------------------------------------------------------------//

static function ImportaArticulo()

   local n
   local cFile

   /*
   Control de errores-------------------------------------------------------
   */

   CursorWait()

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      /*
      Cerramos la conexion con el objeto oOleExcel-----------------------------
      */

      ( dbfArticulo )->( dbgotop() )
      while !( dbfArticulo )->( eof() )

         if ( facArticulo )->( dbseek( ( dbfArticulo )->Codigo ) )
            if ( dbfArticulo )->( dbrlock() )
               ( dbfArticulo )->pCosto    := ( facArticulo )->nCosteDiv
               ( dbfArticulo )->( dbrunlock() )
            end if 
         end if

         msgWait( "Articulo " + ( dbfArticulo )->Codigo, , .1 )

         ( dbfArticulo )->( dbskip() )
             
      end while


      Msginfo( "Porceso finalizado con exito" )

      /*
      Cerrando el control de errores-------------------------------------------
      */

   RECOVER USING oError

      msgStop( "Error en el proceso de importación : " + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CursorWE()

Return .t.

//------------------------------------------------------------------------

