#include "c:\fw195\gestool\bin\include\Factu.ch"

static dbfClient
static lOpenFiles       := .f.
static nLineaComienzo   := 2

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
   
   ImportaFactura()

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

      USE ( cPatEmp() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfClient ) )
      SET ADSINDEX TO ( cPatEmp() + "CLIENT.CDX" ) ADDITIVE

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

   dbfClient    := nil

   lOpenFiles     := .f.

RETURN ( .t. )

//----------------------------------------------------------------------------//

static function ImportaFactura()

   local n

   local oBlock
   local oError
   local oOleExcel
   local cFichero                      := cGetFileName()

   if !file(cFichero)
      msgStop( "El fichero " + cFichero + " no existe." )
      return( .f. )
   end if 

   CursorWait()

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

      oExcel            := TTxtFile():New( cFichero )

      while ! oExcel:lEoF()

         cCodigo                       := getLinePosition( oExcel:cLine, 1 )
         cEstablecimiento              := getLinePosition( oExcel:cLine, 2 )
         cNombre                       := getLinePosition( oExcel:cLine, 3 )
         cDireccion                    := getLinePosition( oExcel:cLine, 4 )
         cCodigoPostal                 := getLinePosition( oExcel:cLine, 5 )
         cPoblacion                    := getLinePosition( oExcel:cLine, 6 )
         cNif                          := getLinePosition( oExcel:cLine, 7 )
         cTelefono                     := getLinePosition( oExcel:cLine, 14 )

         ( dbfClient )->( dbAppend() )

         ( dbfClient )->Cod            := alltrim( cCodigo )
         ( dbfClient )->Titulo         := alltrim( cNombre )
         ( dbfClient )->NbrEst         := alltrim( cEstablecimiento )
         ( dbfClient )->Domicilio      := alltrim( cDireccion )
         ( dbfClient )->CodPostal      := alltrim( cCodigoPostal )
         ( dbfClient )->Poblacion      := alltrim( cPoblacion )
         ( dbfClient )->Nif            := alltrim( cNif )
         ( dbfClient )->Telefono       := alltrim( cTelefono )

         ( dbfClient )->( dbUnLock() )
   
         oExcel:Skip()

      end while

      oExcel:Close()

   CursorWE()

Return .t.

//------------------------------------------------------------------------

static function nGetNumeric( uVal )

   local nVal     := 0

   do case
      case Valtype( uVal ) == "C"
         nVal     := Val( StrTran( uVal, ",", "." ) )
      case Valtype( uVal ) == "N"
         nVal     := uVal
   end case 

Return ( nVal )
 
//------------------------------------------------------------------------

static function getLinePosition( cLine, nPosition )

   local a

   a  := hb_aTokens( cLine, ";" )

return ( a[ nPosition ] )
