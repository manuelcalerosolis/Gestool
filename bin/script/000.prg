/******************************************************************************
Script creado a Joaquin Infante, para crear y mandar el informe que necesita
******************************************************************************/
#include ".\Include\Factu.ch"
#define CRLF chr( 13 ) + chr( 10 )

static dbfArticulo
static dbfProvee
static dbfFacPrvT
static dbfFacPrvL
static lOpenFiles       := .f.
static cTextoFinal      := ""

//---------------------------------------------------------------------------//

function InicioHRB()

   local oInt
   local oFtp
   local oFile
   local oScript
   local cTxtFile       := "c:\B21230560.txt"
   local cFileFtp       := "B21230560.txt"
   local cHostFtp       := "80.34.189.190"
   local cUserFtp       := "jinfante"
   local cPasswdFtp     := "B21230560"
   local lPassiveFtp    := .t.

   msginfo( "entro en el Script" )

   CursorWait()

   /*
   Si existe el fichero lo eliminamos para crear el nuevo----------------------
   */

   if File( cTxtFile )
      fErase( cTxtFile )
   end if

   /*
   Abrimos las bases de datos necesarias---------------------------------------
   */

   if !OpenFiles( .f. )
      return .f.
   end if

   /*
   Creamos el fichero para enviarlo--------------------------------------------
   */

   CreaFichero()

   /*
   Mandamos el fichero por FTP-------------------------------------------------
   */

   //EnvioFtp( cTxtFile )

   /*
   Cerramos los ficheros abiertos----------------------------------------------
   */

   CloseFiles()

   CursorWe()

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

      USE ( cPatPrv() + "PROVEE.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfProvee ) )
      SET ADSINDEX TO ( cPatPrv() + "PROVEE.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FACPRVT.DBF" )  NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVT", @dbfFacPrvT ) )
      SET ADSINDEX TO ( cPatEmp() + "FACPRVT.CDX" )  ADDITIVE

      USE ( cPatEmp() + "FACPRVL.DBF" )  NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACPRVL", @dbfFacPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "FACPRVL.CDX" )  ADDITIVE

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

   if dbfProvee != nil
      ( dbfProvee )->( dbCloseArea() )
   end if

   if dbfFacPrvT != nil
      ( dbfFacPrvT )->( dbCloseArea() )
   end if

   if dbfFacPrvL != nil
      ( dbfFacPrvL )->( dbCloseArea() )
   end if

   dbfArticulo    := nil
   dbfProvee      := nil
   dbfFacPrvT     := nil
   dbfFacPrvL     := nil

   lOpenFiles     := .f.

RETURN ( .t. )

//----------------------------------------------------------------------------//

function CreaFichero()

   local desdeFecha     := GetSysDate() - 15
   local hastaFecha     := GetSysDate()
   local nOrdAnt        := ( dbfFacPrvL )->( OrdSetFocus( "dFecFac" ) )

   cTextoFinal          := ""

   MsgInfo( desdeFecha, "desdefecha" )
   MsgInfo( hastaFecha, "hastaFecha" )

   while !( dbfFacPrvL )->( Eof() )

      if ( ( dbfFacPrvL )->dFecFac >= DesdeFecha .and. ( dbfFacPrvL )->dFecFac <= hastaFecha )  .and.;
         ( dbfFacPrvT )->( dbSeek( ( dbfFacPrvL )->cSerFac + str( ( dbfFacPrvL )->nNumFac ) + ( dbfFacPrvL )->cSufFac ) )

         msgWait( Str( ( dbfFacPrvL )->nNumFac ), "Atención", 0.01 )

         cTextoFinal       += dtos( ( dbfFacPrvT )->dFecFac )                                         // Fecha del documento   Ancho 10
         cTextoFinal       += "|"
         cTextoFinal       += AllTrim( Str( ( dbfFacPrvT )->nNumFac ) )                               // Número del documento Ancho de 10
         cTextoFinal       += "|"
         cTextoFinal       += ""                                                                      // Ean 13
         cTextoFinal       += "|"
         cTextoFinal       += AllTrim( ( dbfFacPrvL )->cRef )                                         // Referencia de proveedor Ancho Variable
         cTextoFinal       += "|"
         cTextoFinal       += Trans( nTotNFacPrv( dbfFacPrvL ), MasUnd() )                            // Cantidad Ancho Variable
         cTextoFinal       += "|"
         cTextoFinal       += Trans( ( dbfFacPrvL )->nPreUnit, cPorDiv() )                            // Precio Ancho Variable
         cTextoFinal       += "|"
         cTextoFinal       += AllTrim( ( dbfFacPrvT )->cDniPrv )                                      // Cif Proveedor Ancho Variable
         cTextoFinal       += "|"
         cTextoFinal       += AllTrim( ( dbfFacPrvL )->cDetalle )                                     // Descripción Articulo Ancho Variable
         cTextoFinal       += "|"
         cTextoFinal       += AllTrim( ( dbfFacPrvT )->cCodPrv )                                      // Código Proveedor Ancho Variable
         cTextoFinal       += "|"
         cTextoFinal       += AllTrim( ( dbfFacPrvT )->cNomPrv )                                      // Nombre Proveedor Ancho Variable
         cTextoFinal       += CRLF

      end if

      ( dbfFacPrvL )->( dbSkip() )

   end while

   MsgInfo( cTextoFinal, "cTextoFinal" )

Return .t.

//---------------------------------------------------------------------------//

function EnvioFtp( cTxtFile )

   if File( cTxtFile )

      oInt         := TInternet():New()
      oFtp         := TFtp():New( cHostFtp, oInt, cUserFtp, cPasswdFtp, lPassiveFtp )

      if Empty( oFtp ) .or. Empty( oFtp:hFtp )

         MsgStop( "Imposible conectar al sitio ftp " + cHostFtp )

      else

         oFile                   := TFtpFile():New( cTxtFile, oFtp )

         if !oFile:PutFile()
            Msginfo( "Error copiando fichero " + cTxtFile )
         else
            Msginfo( "Fichero enviado correctamente" )
         end if

         oFile:End()

      end if

   end if

Return .t.

//---------------------------------------------------------------------------//