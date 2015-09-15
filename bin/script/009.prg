#include "c:\fw195\gestool\bin\include\Factu.ch"

static dbfProvee
static dbfArticulo
static dbfCodebar
static dbfFamilia
static dbfFacPrvT
static dbfFacPrvL
static dbfFacPrvP
static dbfFPago
static dbfCount
static dbfDiv
static dbfIva
static dbfPrvBnc
static dbfFabricantes
static dbfTipArt
static dbfArtPrv
static dbfCategorias
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

   Msginfo( "Importaci�n realizada con �xito" )

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
      MsgStop( 'Imposible abrir ficheros de art�culos' )
      Return ( .f. )
   end if

   CursorWait()

   oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      lOpenFiles  := .t.

      USE ( cPatCli() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfClient ) )
      SET ADSINDEX TO ( cPatCli() + "CLIENT.CDX" ) ADDITIVE

      USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
      SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

      USE ( cPatArt() + "ArtCodebar.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CODEBAR", @dbfCodebar ) )
      SET ADSINDEX TO ( cPatArt() + "ArtCodebar.Cdx" ) ADDITIVE

      USE ( cPatArt() + "Familias.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FAMILIAS", @dbfFamilia ) )
      SET ADSINDEX TO ( cPatArt() + "Familias.Cdx" ) ADDITIVE

      USE ( cPatArt() + "TipArt.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TipArt", @dbfTipArt ) )
      SET ADSINDEX TO ( cPatArt() + "TipArt.Cdx" ) ADDITIVE

      USE ( cPatPrv() + "PROVEE.DBF" ) NEW VIA ( cDriver() )   SHARED ALIAS ( cCheckArea( "PROVEE", @dbfProvee ) )
      SET ADSINDEX TO ( cPatPrv() + "PROVEE.CDX" )   ADDITIVE

      USE ( cPatEmp() + "FACPRVT.DBF" )  NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVT", @dbfFacPrvT ) )
      SET ADSINDEX TO ( cPatEmp() + "FACPRVT.CDX" )  ADDITIVE

      USE ( cPatEmp() + "FACPRVL.DBF" )  NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVL", @dbfFacPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "FACPRVL.CDX" )  ADDITIVE

      USE ( cPatPrv() + "PRVBNC.DBF" ) NEW VIA ( cDriver() )   SHARED ALIAS ( cCheckArea( "PRVBNC", @dbfPrvBnc ) )
      SET ADSINDEX TO ( cPatPrv() + "PRVBNC.CDX" )   ADDITIVE

      USE ( cPatEmp() + "NCOUNT.DBF" ) NEW VIA ( cDriver() )    SHARED ALIAS ( cCheckArea( "NCOUNT", @dbfCount ) )
      SET ADSINDEX TO ( cPatEmp() + "NCOUNT.CDX" )   ADDITIVE

      USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
      SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

      USE ( cPatGrp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFPago ) )
      SET ADSINDEX TO ( cPatGrp() + "FPAGO.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FACPRVP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVP", @dbfFacPrvP ) )
      SET ADSINDEX TO ( cPatEmp() + "FACPRVP.CDX" ) ADDITIVE

      USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
      SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

      USE ( cPatArt() + "Fabricantes.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Fabricantes", @dbfFabricantes ) )
      SET ADSINDEX TO ( cPatArt() + "Fabricantes.CDX" ) ADDITIVE

      USE ( cPatArt() + "PROVART.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PROVART", @dbfArtPrv ) )
      SET ADSINDEX TO ( cPatArt() + "PROVART.CDX" ) ADDITIVE

      USE ( cPatArt() + "Categorias.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Categorias", @dbfCategorias ) )
      SET ADSINDEX TO ( cPatArt() + "Categorias.CDX" ) ADDITIVE

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

   if dbfArticulo != nil
      ( dbfArticulo )->( dbCloseArea() )
   end if

   if dbfCodebar != nil
      ( dbfCodebar )->( dbCloseArea() )
   end if 

   if dbfTipArt != nil
      ( dbfTipArt )->( dbCloseArea() )
   end if 

   if dbfFamilia != nil
      ( dbfFamilia )->( dbCloseArea() )
   end if 

   if dbfProvee != nil
      ( dbfProvee )->( dbCloseArea() )
   end if

   if dbfFacPrvT != nil
      ( dbfFacPrvT )->( dbCloseArea() )
   end if

   if dbfFacPrvL != nil
      ( dbfFacPrvL )->( dbCloseArea() )
   end if

   if dbfFacPrvP != nil
      ( dbfFacPrvP )->( dbCloseArea() )
   end if

   if dbfPrvBnc != nil
      ( dbfPrvBnc )->( dbCloseArea() )
   end if

   if dbfCount != nil
      ( dbfCount )->( dbCloseArea() )
   end if

   if dbfDiv != nil
      ( dbfDiv )->( dbCloseArea() )
   end if

   if dbfFPago != nil
      ( dbfFPago )->( dbCloseArea() )
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

   if dbfCategorias != nil
      ( dbfCategorias )->( dbCloseArea() )
   end if

   dbfArticulo    := nil
   dbfCodebar     := nil
   dbfProvee      := nil
   dbfFacPrvT     := nil
   dbfFacPrvL     := nil
   dbfFacPrvP     := nil
   dbfPrvBnc      := nil
   dbfDiv         := nil
   dbfCount       := nil
   dbfFPago       := nil
   dbfIva         := nil
   dbfFabricantes := nil 

   lOpenFiles     := .f.

RETURN ( .t. )

//----------------------------------------------------------------------------//

static function ImportaFactura( cFichero )

   local n

   local oBlock
   local oError
   local oOleExcel
   local cCodigoCliente := ""

   CursorWait()

      /*
      Control de errores-------------------------------------------------------

      oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE
      */

      /*
      Creamos el objeto oOleExcel----------------------------------------------
      */

      oOleExcel                        := TOleExcel():New( "Importando hoja de excel", "Conectando...", .f. )

      oOleExcel:oExcel:Visible         := .f.
      oOleExcel:oExcel:DisplayAlerts   := .f.
      oOleExcel:oExcel:WorkBooks:Open( "C:\Calero\Clientes.xlsx" )

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
         Si no encontramos mas l�neas nos salimos------------------------------
         */

         if Empty( oOleExcel:oExcel:ActiveSheet:Range( "A" + lTrim( Str( n ) ) ):Value )
            Exit
         end if

         ( dbfClient )->( dbAppend() )

         ( dbfClient )->Cod         := "00" + oOleExcel:oExcel:ActiveSheet:Range( "A" + lTrim( Str( n ) ) ):Value  
         ( dbfClient )->Titulo      := oOleExcel:oExcel:ActiveSheet:Range( "D" + lTrim( Str( n ) ) ):Value  
         ( dbfClient )->Nif         := oOleExcel:oExcel:ActiveSheet:Range( "C" + lTrim( Str( n ) ) ):Value  
         ( dbfClient )->NbrEst      := oOleExcel:oExcel:ActiveSheet:Range( "E" + lTrim( Str( n ) ) ):Value 
         ( dbfClient )->cPerCto     := oOleExcel:oExcel:ActiveSheet:Range( "F" + lTrim( Str( n ) ) ):Value 
         ( dbfClient )->cMeiInt     := oOleExcel:oExcel:ActiveSheet:Range( "G" + lTrim( Str( n ) ) ):Value 
         ( dbfClient )->cWebInt     := oOleExcel:oExcel:ActiveSheet:Range( "H" + lTrim( Str( n ) ) ):Value 
         ( dbfClient )->mComent     := oOleExcel:oExcel:ActiveSheet:Range( "I" + lTrim( Str( n ) ) ):Value 
         ( dbfClient )->Subcta      := oOleExcel:oExcel:ActiveSheet:Range( "Q" + lTrim( Str( n ) ) ):Value 
         ( dbfClient )->Telefono    := oOleExcel:oExcel:ActiveSheet:Range( "AN" + lTrim( Str( n ) ) ):Value 
         ( dbfClient )->Fax         := oOleExcel:oExcel:ActiveSheet:Range( "AO" + lTrim( Str( n ) ) ):Value 

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
      Creamos el objeto oOleExcel----------------------------------------------
      */

      oOleExcel                        := TOleExcel():New( "Importando hoja de excel", "Conectando...", .f. )

      oOleExcel:oExcel:Visible         := .f.
      oOleExcel:oExcel:DisplayAlerts   := .f.
      oOleExcel:oExcel:WorkBooks:Open( "C:\Calero\Direcciones.xlsx" )

      oOleExcel:oExcel:WorkSheets( 1 ):Activate()   //Hojas de la hoja de calculo

      /*
      Recorremos la hoja de calculo--------------------------------------------
      */

      SysRefresh()

      for n := nLineaComienzo to 65536

         cCodigoCliente                := oOleExcel:oExcel:ActiveSheet:Range( "B" + lTrim( Str( n ) ) ):Value

         /*
         Si no encontramos mas l�neas nos salimos------------------------------
         */

         if Empty( cCodigoCliente )
            Exit
         end if

         if ( dbfClient )->( dbSeek( "00" + cCodigoCliente ) )

            msgWait( "00" + cCodigoCliente, "clientes", .1 )

            if ( dbfClient )->( dbrlock() )

               ( dbfClient )->Domicilio   := oOleExcel:oExcel:ActiveSheet:Range( "D" + lTrim( Str( n ) ) ):Value  
               ( dbfClient )->CodPostal   := oOleExcel:oExcel:ActiveSheet:Range( "E" + lTrim( Str( n ) ) ):Value  
               ( dbfClient )->Poblacion   := oOleExcel:oExcel:ActiveSheet:Range( "F" + lTrim( Str( n ) ) ):Value 
               ( dbfClient )->Provincia   := oOleExcel:oExcel:ActiveSheet:Range( "G" + lTrim( Str( n ) ) ):Value 

               ( dbfClient )->( dbUnLock() )

            end if 

         end if 
   
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

      RECOVER USING oError

         msgStop( "Error en el proceso de importaci�n : " + ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )
      */

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


