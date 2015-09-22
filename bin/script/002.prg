#include "c:\gestool\include\Factu.ch"

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
static dbfCliAtp
static dbfCliContactos
static lOpenFiles       := .f.
static nLineaComienzo   := 7
static cCodCli          := ""
static cCodArt          := ""
static cDireccion       := ""
static cPoblacion       := ""
static cProvincia       := ""
static cCodPostal       := ""
static cMaiCon          := ""
static cNomCnt1         := ""
static cTelCnt1         := ""
static cNomCnt2         := ""
static cTelCnt2         := ""
static cNomCnt3         := ""
static cTelCnt3         := ""
static cNomCnt4         := ""
static cTelCnt4         := ""
static cNomCnt5         := ""
static cTelCnt5         := ""
static cNomCnt6         := ""
static cTelCnt6         := ""
static cObsCon          := ""

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

   if lOpenFiles
      MsgStop( 'Imposible abrir ficheros de artículos' )
      Return ( .f. )
   end if

   CursorWait()

   oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      lOpenFiles  := .t.

      USE ( cPatCli() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfClient ) )
      SET ADSINDEX TO ( cPatCli() + "CLIENT.CDX" ) ADDITIVE

      USE ( cPatCli() + "CliAtp.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CliAtp", @dbfCliAtp ) )
      SET ADSINDEX TO ( cPatCli() + "CliAtp.Cdx" ) ADDITIVE

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

      USE ( cPatCli() + "CliContactos.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLICONTACTOS", @dbfCliContactos ) )
      SET ADSINDEX TO ( cPatCli() + "CliContactos.CDX" ) ADDITIVE

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

   if dbfCliAtp != nil
      ( dbfCliAtp )->( dbCloseArea() )
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

   if dbfCliContactos != nil
      ( dbfCliContactos )->( dbCloseArea() )
   end if

   dbfArticulo       := nil
   dbfCodebar        := nil
   dbfProvee         := nil
   dbfFacPrvT        := nil
   dbfFacPrvL        := nil
   dbfFacPrvP        := nil
   dbfPrvBnc         := nil
   dbfDiv            := nil
   dbfCount          := nil
   dbfFPago          := nil
   dbfIva            := nil
   dbfFabricantes    := nil
   dbfCliContactos   := nil

   lOpenFiles        := .f.

RETURN ( .t. )

//----------------------------------------------------------------------------//

static function ImportaFactura( cFichero )

   local n
   local oBlock
   local oError
   local cFile
   local oOleExcel

   /*
   Control de errores-------------------------------------------------------

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
   */

   /*
   Creamos el objeto oOleExcel----------------------------------------------
   */

   cFile                            := cGetFile( "Excel ( *.Xls ) | " + "*.Xls", "Seleccione la hoja de calculo" )

   if !file( cFile )
      msgStop( "No existe fichero")
      return .f.
   end if
         
   CursorWait()

      oOleExcel                        := TOleExcel():New( "Importando hoja de excel", "Conectando...", .f. )

      oOleExcel:oExcel:Visible         := .f.
      oOleExcel:oExcel:DisplayAlerts   := .f.
      oOleExcel:oExcel:WorkBooks:Open( cFile )

      oOleExcel:oExcel:WorkSheets( 1 ):Activate()   //Hojas de la hoja de calculo

      /*
      Recorremos la hoja de calculo--------------------------------------------
      */

      SysRefresh()

      for n := nLineaComienzo to 65536

         /*
         Si no encontramos mas líneas nos salimos------------------------------
         */

         if Empty( oOleExcel:oExcel:ActiveSheet:Range( "I" + lTrim( Str( n ) ) ):Value )
            Exit
         end if

         cCodCli                    := oOleExcel:oExcel:ActiveSheet:Range( "I" + lTrim( Str( n ) ) ):Value  
         cCodCli                    := padr( cCodCli, 12 )

         cDireccion                 := padr( oOleExcel:oExcel:ActiveSheet:Range( "Q" + lTrim( Str( n ) ) ):Value, 100 )
         cPoblacion                 := padr( oOleExcel:oExcel:ActiveSheet:Range( "R" + lTrim( Str( n ) ) ):Value, 100 )
         cProvincia                 := padr( oOleExcel:oExcel:ActiveSheet:Range( "C" + lTrim( Str( n ) ) ):Value, 20 )
         cCodPostal                 := padr( oOleExcel:oExcel:ActiveSheet:Range( "S" + lTrim( Str( n ) ) ):Value, 10 )
         cMaiCon                    := padr( oOleExcel:oExcel:ActiveSheet:Range( "AG" + lTrim( Str( n ) ) ):Value, 200 )
         cObsCon                    := oOleExcel:oExcel:ActiveSheet:Range( "U" + lTrim( Str( n ) ) ):Value

         cNomCnt1                   := padr( oOleExcel:oExcel:ActiveSheet:Range( "F" + lTrim( Str( n ) ) ):Value, 150 )
         cTelCnt1                   := padr( oOleExcel:oExcel:ActiveSheet:Range( "J" + lTrim( Str( n ) ) ):Value, 17 )
         cNomCnt2                   := padr( oOleExcel:oExcel:ActiveSheet:Range( "K" + lTrim( Str( n ) ) ):Value, 150 )
         cTelCnt2                   := padr( oOleExcel:oExcel:ActiveSheet:Range( "L" + lTrim( Str( n ) ) ):Value, 17 )
         cNomCnt3                   := padr( oOleExcel:oExcel:ActiveSheet:Range( "M" + lTrim( Str( n ) ) ):Value, 150 )
         cTelCnt3                   := padr( oOleExcel:oExcel:ActiveSheet:Range( "L" + lTrim( Str( n ) ) ):Value, 17 )
         cNomCnt4                   := padr( oOleExcel:oExcel:ActiveSheet:Range( "V" + lTrim( Str( n ) ) ):Value, 150 )
         cTelCnt4                   := padr( oOleExcel:oExcel:ActiveSheet:Range( "W" + lTrim( Str( n ) ) ):Value, 17 )
         cNomCnt5                   := padr( oOleExcel:oExcel:ActiveSheet:Range( "X" + lTrim( Str( n ) ) ):Value, 150 )
         cTelCnt5                   := padr( oOleExcel:oExcel:ActiveSheet:Range( "Y" + lTrim( Str( n ) ) ):Value, 17 )
         cNomCnt6                   := padr( oOleExcel:oExcel:ActiveSheet:Range( "Z" + lTrim( Str( n ) ) ):Value, 150 )
         cTelCnt6                   := padr( oOleExcel:oExcel:ActiveSheet:Range( "AA" + lTrim( Str( n ) ) ):Value, 17 )

         if !Empty( cNomCnt1 ) .or. !Empty( cTelCnt1 )
            AppendReg( cNomCnt1, cTelCnt1 )
         end if

         if !Empty( cNomCnt2 ) .or. !Empty( cTelCnt2 )
            AppendReg( cNomCnt2, cTelCnt2 )
         end if

         if !Empty( cNomCnt3 ) .or. !Empty( cTelCnt3 )
            AppendReg( cNomCnt3, cTelCnt3 )
         end if

         if !Empty( cNomCnt4 ) .or. !Empty( cTelCnt4 )
            AppendReg( cNomCnt4, cTelCnt4 )
         end if

         if !Empty( cNomCnt5 ) .or. !Empty( cTelCnt5 )
            AppendReg( cNomCnt5, cTelCnt5 )
         end if

         if !Empty( cNomCnt6 ) .or. !Empty( cTelCnt6 )
            AppendReg( cNomCnt6, cTelCnt6 )
         end if

         n++

         msgwait( "procesando" + str( n ), , .1 )

      next

      /*
      Cerramos la conexion con el objeto oOleExcel-----------------------------
      */

      oOleExcel:oExcel:WorkBooks:Close()

      oOleExcel:oExcel:Quit()

      oOleExcel:oExcel:DisplayAlerts   := .t.

      oOleExcel:End()

      Msginfo( "Porceso finalizado con exito" )

      /*
      Cerrando el control de errores-------------------------------------------

      RECOVER USING oError

         msgStop( "Error en el proceso de importación : " + ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )
      */

   CursorWE()

Return .t.

//------------------------------------------------------------------------

static function AppendReg( cNomReg, cTelReg )

   ( dbfCliContactos )->( dbAppend() )

   ( dbfCliContactos )->cCodCli  := cCodCli
   ( dbfCliContactos )->cNomCon  := cNomReg
   ( dbfCliContactos )->cDirCon  := cDireccion
   ( dbfCliContactos )->cPobCon  := cPoblacion
   ( dbfCliContactos )->cPrvCon  := cProvincia
   ( dbfCliContactos )->cPosCon  := cCodPostal
   ( dbfCliContactos )->cTelCon  := cTelReg
   ( dbfCliContactos )->cMaiCon  := cMaiCon
   ( dbfCliContactos )->cObsCon  := cObsCon
   
   ( dbfCliContactos )->( dbUnLock() )
   
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
 
//------------------------------------------------------------------------