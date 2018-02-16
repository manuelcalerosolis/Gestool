//#include "\\Servidor1\wdges32\Include\Factu.ch"
#include "Factu.ch"

#define __len__   173

static dbfArticulo
static dbfFPago
static dbfCount
static dbfDiv
static dbfIva
static dbfClient
static dbfAlbCliT
static dbfAlbCliL
static dbfAlbCliP
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
   
   ImportaAlbaran()

   Msginfo( "Importación realizada con éxito" )

   CursorWe()

   /*
   Cerramos los ficheros abiertos anteriormente--------------------------------
   */

   CloseFiles()

   SysRefresh()

return .t.

//---------------------------------------------------------------------------//

static function OpenFiles()

   local oError
   local oBlock

   /*if lOpenFiles
      MsgStop( 'Imposible abrir ficheros' )
      Return ( .f. )
   end if*/

   CursorWait()

   oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      lOpenFiles  := .t.

      USE ( cPatEmp() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfClient ) )
      SET ADSINDEX TO ( cPatEmp() + "CLIENT.CDX" ) ADDITIVE

      USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
      SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

      USE ( cPatEmp() + "NCOUNT.DBF" ) NEW VIA ( cDriver() )    SHARED ALIAS ( cCheckArea( "NCOUNT", @dbfCount ) )
      SET ADSINDEX TO ( cPatEmp() + "NCOUNT.CDX" )   ADDITIVE

      USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
      SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FPAGO", @dbfFPago ) )
      SET ADSINDEX TO ( cPatEmp() + "FPAGO.CDX" ) ADDITIVE

      USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
      SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIL", @dbfAlbCliT ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBCLIT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIL", @dbfAlbCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBCLIL.CDX" ) ADDITIVE

      USE ( cPatEmp() + "ALBCLIP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIP", @dbfAlbCliP ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBCLIP.CDX" ) ADDITIVE

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

   if dbfAlbCliT != nil
      ( dbfAlbCliT )->( dbCloseArea() )
   end if 

   if dbfAlbCliL != nil
      ( dbfAlbCliL )->( dbCloseArea() )
   end if 

   if dbfAlbCliP != nil
      ( dbfAlbCliP )->( dbCloseArea() )
   end if    

   dbfArticulo    := nil
   dbfDiv         := nil
   dbfCount       := nil
   dbfFPago       := nil
   dbfIva         := nil
   dbfAlbCliT     := nil
   dbfAlbCliL     := nil
   dbfAlbCliP     := nil

   lOpenFiles     := .f.

RETURN ( .t. )

//----------------------------------------------------------------------------//

static function ImportaAlbaran()

   local oBlock
   local oError
   local cFile
   local hFile
   local cBufer
   local nBytes
   local cFilEdm
   local oFilEdm
   local hAlbaran := {=>}
                                 
   CursorWait()

   cFilEdm                               := cGetFile( "All | *.*", "Seleccione los ficheros a importar", "*.*" , , .f.)

   if !Empty( cFilEdm )

      oFilEdm                            := TTxtFile():New( cFilEdm )

      while ! oFilEdm:lEoF()

         hAlbaran                        := {=>}
         hAlbaran[ "Fecha" ]             := ctod( substr( oFilEdm:cLine, 7, 10 ) )
         hAlbaran[ "Hora" ]              := subStr( oFilEdm:cLine, 18, 8)
         hAlbaran[ "CodArt" ]            := Alltrim( subStr( oFilEdm:cLine, 26, 10) )
         if hAlbaran[ "CodArt" ]    == "1"
            hAlbaran[ "CodArt" ]    = "G.A."
            halbaran[ "Almacen"]    = "GSA"
         else
            hAlbaran[ "CodArt" ]    = "G.B." 
            hAlbaran[ "Almacen" ]   = "GSB"
         end if
         hAlbaran[ "Litros" ]            := Val( subStr( oFilEdm:cLine, 42, 13) )/1000
         hAlbaran[ "Precio" ]            := Val( subStr( oFilEdm:cLine, 55, 8) )/1000 
         hAlbaran[ "Descuento" ]         := Val( subStr( oFilEdm:cLine, 63, 6) )/100
         hAlbaran[ "TotalImpIvaIncl" ]   := Val( subStr( oFilEdm:cLine, 70, 9) )/100
         hAlbaran[ "Cobrado" ]           := Val( subStr( oFilEdm:cLine, 79, 9) )/100
         hAlbaran[ "FPago" ]             := subStr( oFilEdm:cLine, 88, 18)
         hAlbaran[ "NumeroVale" ]        := subStr( oFilEdm:cLine, 116, 10)
         hAlbaran[ "CodCliente" ]        := Alltrim( subStr( oFilEdm:cLine, 126, 6) )

         EditarAlbaran( hAlbaran)

         oFilEdm:Skip()

      end while

   oFilEdm:Close()

   end if

   CursorWe()

Return .t.

//-----------------------------------------------------------------------------

static function EditarAlbaran( hAlbaran )

local nRecNoCli
local nRecNoPago
local nRecNoArt
local nOrdAntCli
local nOrdantPago
local nOrdAntArt
local nRecNoIva
local nOrdAntIva
local nTarifa
local cCodCliente
local nNumAlb

nRecNoCli      := ( dbfClient )->( RecNo( ) )
nOrdAnt        := ( dbfClient )->( OrdSetFocus( "cUsrDef01" ) )
nRecNoPago     := ( dbfFPago )->( RecNo( ) )
nOrdAntPago    := ( dbfFPago )->( OrdSetFocus( "cDesPago" ) )
nRecNoArt      := ( dbfArticulo )->( RecNo() )
nOrdAntArt     := ( dbfArticulo )->( OrdSetFocus( "Codigo" ) )
nRecNoIva      := ( dbfIva )->( RecNo() )
nOrdantIva     := ( dbfIva )->( OrdSetFocus( "Tipo" ) )

   if !Empty( hAlbaran )

//Importamos primero la cabecera del albaran-----------------------------------

      ( dbfAlbCliT )->( dbAppend( ) )

      ( dbfAlbCliT )->cSerAlb       := 'T'
      nNumAlb                       := nNewDoc( 'T', dbfAlbCliT, "NALBCLI", , dbfCount )
      ( dbfAlbCliT )->nNumAlb       := nNumAlb
      ( dbfAlbCliT )->cSufAlb       := '00'
      ( dbfAlbCliT )->cTurAlb       := cCurSesion()
      ( dbfAlbCliT )->dFecAlb       := hAlbaran[ "Fecha" ]
      ( dbfAlbCliT )->cSuPed        := hAlbaran[ "NumeroVale" ]
      ( dbfAlbCliT )->lFacturado    := .f.
      ( dbfAlbCliT )->lEntregado    := .f. 

      if ( dbfClient )->( dbSeek( hAlbaran[ "CodCliente" ] ) )

         cCodCliente                := ( dbfClient )->Cod
         ( dbfAlbCliT )->cCodCli    := cCodCliente
         ( dbfAlbCliT )->cNomCli    := ( dbfClient )->Titulo
         ( dbfAlbCliT )->cDirCli    := ( dbfClient )->Domicilio
         ( dbfAlbCliT )->cPobCli    := ( dbfClient )->Poblacion
         ( dbfAlbCliT )->cPrvCli    := ( dbfClient )->Provincia
         ( dbfAlbCliT )->cPosCli    := ( dbfClient )->CodPostal
         ( dbfAlbCliT )->cDniCli    := ( dbfClient )->Nif
         ( dbfAlbCliT )->nRegIva    := ( dbfClient )->nRegIva
         ( dbfAlbCliT )->cCodPago   := ( dbfClient )->CodPago
         ( dbfAlbCliT )->cCodGrp    := ( dbfClient )->cCodGrp
         ( dbfAlbCliT )->cTlfCli    := ( dbfClient )->Telefono

      end if 

      ( dbfAlbCliT )->cCodAlm       := hAlbaran[ "Almacen" ]
      ( dbfAlbCliT )->cCodCaj       := cDefCaj()
      ( dbfAlbCliT )->lIvaInc       := .t.
      ( dbfAlbCliT )->cDivAlb       := cDivEmp()
      ( dbfAlbCliT )->cCodUsr       := cCurUsr()
      ( dbfAlbCliT )->cCodDlg       := "00"

      ( dbfAlbCliT )->( dbUnlock( ) )

//Importamos las líneas del albaran--------------------------------------------

      ( dbfAlbCliL )->( dbAppend( ) )

         ( dbfAlbCliL )->cSerAlb       := 'T' 
         ( dbfAlbCliL )->nNumAlb       := nNumAlb
         ( dbfAlbCliL )->cSufAlb       := '00' 

         if ( dbfArticulo )->( dbSeek( hAlbaran[ "CodArt" ] ) )
            ( dbfAlbCliL )->cRef       := ( dbfArticulo )->Codigo
            ( dbfAlbCliL )->cDetalle   := ( dbfArticulo )->Nombre
            ( dbfAlbCliL )->nCtlStk    := ( dbfArticulo )->nCtlStock

            if ( dbfIva )->( dbSeek( (dbfArticulo )->TipoIva ) ) 
               ( dbfAlbCliL )->nIva    := ( dbfIva )->TpIva
            end if 

            ( dbfAlbCliL )->nCosDiv    := ( dbfArticulo )->pCosto
            ( dbfAlbCliL )->cCodTip    := ( dbfArticulo )->cCodTip
            ( dbfAlbCliL )->cCodFam    := ( dbfArticulo )->Familia

         end if 

         ( dbfAlbCliL )->nPreUnit      := hAlbaran[ "Precio" ]
         ( dbfAlbCliL )->nDto          := hAlbaran[ "Descuento" ]
         ( dbfAlbCliL )->nCanEnt       := 1
         ( dbfAlbCliL )->nUniCaja      := hAlbaran[ "Litros" ]
         ( dbfAlbCliL )->dFecha        := hAlbaran[ "Fecha" ]
         ( dbfAlbCliL )->nNumLin       := 1
         ( dbfAlbCliL )->cAlmLin       := hAlbaran[ "Almacen" ]
         ( dbfAlbCliL )->lIvaLin       := .t.         
         ( dbfAlbCliL )->dFecAlb       := hAlbaran[ "Fecha" ]
         
         MsgInfo( cCodCliente, "cCodCliente" )

         ( dbfAlbCliL )->cCodCli       := cCodCliente

      ( dbfAlbCliL )->( dbUnlock( ) )

      ( dbfClient )->( ordSetFocus( nOrdAntCli ) )
      ( dbfClient )->( dbGoTo( nRecNoCli ) )
      ( dbfFPago )->( ordSetFocus( nOrdAntPago ) )
      ( dbfFPago )->( dbGoTo( nRecNoPago ) )
      ( dbfArticulo )->( ordSetFocus( nOrdAntArt ) )
      ( dbfArticulo )->( dbGoTo( nRecNoArt ) )
      ( dbfIva )->( ordSetFocus( nOrdantIva ) )
      ( dbfIva )->( dbGoTo( nRecNoIva ) )   

   end if

Return .t.

//-----------------------------------------------------------------------------

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

static function cGetChar( uVal )

   if Valtype( uVal ) == "N"
      uVal := Int( uVal )
   end if

Return ( cValToChar( uVal ) )