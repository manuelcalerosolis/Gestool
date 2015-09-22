#include "c:\fw195\gestool\bin\include\Factu.ch"

static dbfClient
static lOpenFiles       := .f.
static nLineaComienzo   := 2
static oOleExcel

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
   
   ImportaCliente()

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

   if lOpenFiles
      MsgStop( 'Imposible abrir ficheros' )
      Return ( .f. )
   end if

   CursorWait()

   oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      lOpenFiles  := .t.

      USE ( cPatCli() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfClient ) )
      SET ADSINDEX TO ( cPatCli() + "CLIENT.CDX" ) ADDITIVE

   RECOVER USING oError

      lOpenFiles           := .f.

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

   if dbfClient != nil
      ( dbfClient )->( dbCloseArea() )
   end if

   dbfClient      := nil

   lOpenFiles     := .f.

RETURN ( .t. )

//----------------------------------------------------------------------------//

static function ImportaCliente( cFichero )

   local n

   local oBlock
   local oError
   local cCodigoCliente := ""

   CursorWait()

      /*
      Control de errores-------------------------------------------------------
      */

      oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

      /*
      Creamos el objeto oOleExcel----------------------------------------------
      */

      oOleExcel                        := TOleExcel():New( "Importando hoja de excel", "Conectando...", .f. )

      oOleExcel:oExcel:Visible         := .f.
      oOleExcel:oExcel:DisplayAlerts   := .f.
      oOleExcel:oExcel:WorkBooks:Open( "C:\IMPORTACION\clientescont.xls" )

      oOleExcel:oExcel:WorkSheets( 1 ):Activate()   //Hojas de la hoja de calculo

      /*
      Limpiamos la base de datos de clientes-----------------------------------
      */

      while !( dbfClient )->( eof() )
         if ( dbfClient )->( dbrlock() )
            ( dbfClient )->( dbdelete() )
            ( dbfClient )->( dbUnLock() )
         end if 
         ( dbfClient )->( dbskip(1))
      end while

      /*
      Recorremos la hoja de calculo--------------------------------------------
      */

      SysRefresh()

      for n := nLineaComienzo to 65536

         /*
         Si no encontramos mas líneas nos salimos------------------------------
         */

         if Empty( cGetChar( "A", n ) )
            Exit
         end if

         ( dbfClient )->( dbAppend() )

         ( dbfClient )->Cod         := cGetChar( "A", n )
         ( dbfClient )->Titulo      := cGetChar( "B", n )         
         ( dbfClient )->NbrEst      := cGetChar( "C", n )
         ( dbfClient )->Domicilio   := cGetChar( "D", n )
         ( dbfClient )->Poblacion   := cGetChar( "E", n )
         ( dbfClient )->CodPostal   := cGetChar( "F", n )         
         ( dbfClient )->Nif         := cGetChar( "G", n )
         ( dbfClient )->Telefono    := cGetChar( "H", n )
         ( dbfClient )->Telefono2   := cGetChar( "I", n )
         ( dbfClient )->Fax         := cGetChar( "J", n )
         ( dbfClient )->cMeiInt     := cGetChar( "L", n )
         ( dbfClient )->cWebInt     := cGetChar( "M", n )

         ( dbfClient )->( dbUnLock() )
   
      next

      /*
      Cerramos la conexion con el objeto oOleExcel-----------------------------
      */

      oOleExcel:oExcel:WorkBooks:Close()

      oOleExcel:oExcel:Quit()

      oOleExcel:oExcel:DisplayAlerts   := .t.

      oOleExcel:End()

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

static function cGetChar( cColumna, nFila )

   local uVal  := oOleExcel:oExcel:ActiveSheet:Range( cColumna + lTrim( Str( nFila ) ) ):Value

   if Valtype( uVal ) == "N"
      uVal := Int( uVal )
   end if

Return ( cValToChar( uVal ) )

//---------------------------------------------------------------------------//