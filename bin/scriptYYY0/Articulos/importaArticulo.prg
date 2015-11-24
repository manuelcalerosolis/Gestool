#include "c:\fw195\gestool\bin\include\Factu.ch"

static dbfArticulo
static lOpenFiles       := .f.
static nLineaComienzo   := 2

//---------------------------------------------------------------------------//

function InicioHRB()

   local cDirOrigen
   local aDirectorio
   local cFichero

   msgInfo( "empieza" )

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

      USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
      SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

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

   if dbfArticulo != nil
      ( dbfArticulo )->( dbCloseArea() )
   end if

   dbfArticulo    := nil

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

      while !( dbfArticulo )->( eof() )
         if ( dbfArticulo )->( dbrlock() )
            ( dbfArticulo )->( dbdelete() )
            ( dbfArticulo )->( dbUnLock() )
         end if 
         ( dbfArticulo )->( dbskip(1))
      end while

      /*
      Recorremos la hoja de calculo--------------------------------------------
      */

      SysRefresh()

      oExcel            := TTxtFile():New( cFichero )

      while ! oExcel:lEoF()

         cCodigo                       := getLinePosition( oExcel:cLine, 1 )
         cNombre                       := getLinePosition( oExcel:cLine, 2 )

         nPorcentajeIva                := nGetNumeric( getLinePosition( oExcel:cLine, 7 ) )

         nImporteBase1                 := getLinePosition( oExcel:cLine, 3 )
         nImporteBase1                 := nGetNumeric( nImporteBase1 )
         nImporteIva1                  := Round( nImporteBase1 + ( nImporteBase1 * nPorcentajeIva / 100 ), 2 )

         nImporteBase2                 := getLinePosition( oExcel:cLine, 4 )
         nImporteBase2                 := nGetNumeric( nImporteBase2 )
         nImporteIva2                  := Round( nImporteBase2 + ( nImporteBase2 * nPorcentajeIva / 100 ), 2 )

         nImporteBase3                 := getLinePosition( oExcel:cLine, 5 )
         nImporteBase3                 := nGetNumeric( nImporteBase3 )
         nImporteIva3                  := Round( nImporteBase3 + ( nImporteBase3 * nPorcentajeIva / 100 ), 2 )

         ( dbfArticulo )->( dbAppend() )

         ( dbfArticulo )->Codigo       := cCodigo
         ( dbfArticulo )->Nombre       := cNombre

         ( dbfArticulo )->pVenta1      := nImporteBase1
         ( dbfArticulo )->pVtaIva1     := nImporteIva1

         ( dbfArticulo )->pVenta2      := nImporteBase2
         ( dbfArticulo )->pVtaIva2     := nImporteIva2

         ( dbfArticulo )->pVenta3      := nImporteBase3
         ( dbfArticulo )->pVtaIva3     := nImporteIva3

         ( dbfArticulo )->lIvaInc      := .t.

         if nPorcentajeIva == 21
            ( dbfArticulo )->TipoIva   := "G"
         else
            ( dbfArticulo )->TipoIva   := "N"
         end if

         ( dbfArticulo )->( dbUnLock() )
   
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
