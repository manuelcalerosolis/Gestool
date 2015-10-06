#include "c:\fw195\gestool\bin\include\Factu.ch"

static dbfProvee
static dbfArticulo
static dbfCodebar
static dbfIva
static dbfFabricantes
static dbfTipArt
static dbfArtPrv
static lOpenFiles       := .f.
static nLineaComienzo   := 2

//---------------------------------------------------------------------------//

function InicioHRB()

   local cDirOrigen
   local aDirectorio

   /*
   Abrimos los ficheros necesarios---------------------------------------------
   */

   if !OpenFiles( .f. )
      return .f.
   end if

   CursorWait()
   
   if ImportaArticulos()
      Msginfo( "Importación realizada con éxito" )
   else
      Msginfo( "No se han importado datos")
   end if

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

      USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
      SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

      USE ( cPatArt() + "ArtCodebar.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CODEBAR", @dbfCodebar ) )
      SET ADSINDEX TO ( cPatArt() + "ArtCodebar.Cdx" ) ADDITIVE

      USE ( cPatArt() + "TipArt.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TipArt", @dbfTipArt ) )
      SET ADSINDEX TO ( cPatArt() + "TipArt.Cdx" ) ADDITIVE

      USE ( cPatPrv() + "PROVEE.DBF" ) NEW VIA ( cDriver() )   SHARED ALIAS ( cCheckArea( "PROVEE", @dbfProvee ) )
      SET ADSINDEX TO ( cPatPrv() + "PROVEE.CDX" )   ADDITIVE

      USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
      SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

      USE ( cPatArt() + "Fabricantes.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Fabricantes", @dbfFabricantes ) )
      SET ADSINDEX TO ( cPatArt() + "Fabricantes.CDX" ) ADDITIVE

      USE ( cPatArt() + "PROVART.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVART", @dbfArtPrv ) )
      SET ADSINDEX TO ( cPatArt() + "PROVART.CDX" ) ADDITIVE
   
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

   if dbfCodebar != nil
      ( dbfCodebar )->( dbCloseArea() )
   end if 

   if dbfTipArt != nil
      ( dbfTipArt )->( dbCloseArea() )
   end if 

   if dbfProvee != nil
      ( dbfProvee )->( dbCloseArea() )
   end if

   if dbfIva != nil
      ( dbfIva )->( dbCloseArea() )
   end if

   if dbfFabricantes != nil
      ( dbfFabricantes )->( dbCloseArea() )
   end if

   if dbfArtPrv != nil
      ( dbfArtPrv )->( dbCloseArea() )
   end if
   
   dbfArticulo    := nil
   dbfCodebar     := nil
   dbfProvee      := nil
   dbfIva         := nil
   dbfFabricantes := nil 
   dbfArtPrv      := nil

   lOpenFiles     := .f.

RETURN ( .t. )

//----------------------------------------------------------------------------//

static function ImportaArticulos()

   local n

   local oBlock
   local oError
   local oOleExcel
   local cFabricante := ""
   local cCodigoArticulo
   local cCodBarFab := ""
   local cFichero
   local nOrdAntCode
   local nOrdAntArtPrv 

   CursorWait()

   cFichero  := cGetFile( "All | *.*", "Seleccione el fichero a importar", "*.*" , , .f.)

   if empty(cFichero)
      Return .f.
   else 

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
      oOleExcel:oExcel:WorkBooks:Open( cFichero )

      oOleExcel:oExcel:WorkSheets( 1 ):Activate()   //Hojas de la hoja de calculo

      /*
      Recorremos la hoja de cálculo--------------------------------------------
      */

      SysRefresh()  

   RECOVER USING oError      

      msgStop( ErrorMessage( oError ), 'Imposible importar los datos' )

   END SEQUENCE

   ErrorBlock( oBlock )

   /*
   Cerramos la conexion con el objeto oOleExcel-----------------------------
   */

   oOleExcel:oExcel:WorkBooks:Close()

   oOleExcel:oExcel:Quit()

   oOleExcel:oExcel:DisplayAlerts   := .t.

   oOleExcel:End()

   end if

   CursorWE()

Return .t.

//------------------------------------------------------------------------
