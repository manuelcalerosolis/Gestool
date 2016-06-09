/******************************************************************************
Script2 creado a Pepsi Inma, para crear y mandar el informe que necesita
******************************************************************************/

#include ".\Include\Factu.ch"
//#include "Factu.ch"
#define CRLF chr( 13 ) + chr( 10 )

static dbfArticulo 
static dbfClient
static dbfFacCliT
static dbfFacCliL
static dbfDiv
static dbfKit
static dbfIva
static lOpenFiles       := .f.

static dFecOrg
static dFecDes
static cCliOrg
static cCliDes          
static cConcesionario
static cGetDir
static cFamilia
static cPicture
static oStock

//---------------------------------------------------------------------------//

function InicioHRB()

   /*
   Abrimos los ficheros necesarios---------------------------------------------
   */

   if !OpenFiles( .f. )
      return .f.
   end if

   /*
   Damos valores por defacto a las variables-----------------------------------
   */

   dFecOrg        := Space( 25 )
   dFecDes        := Space( 25 )

   MsgGet( "Seleccione fecha inicio", "Fecha inicio : ", @dFecOrg )
   MsgGet( "Seleccione fecha fin", "Fecha fin : ", @dFecDes )

   dFecOrg        := cTod( AllTrim( dFecOrg ) )
   dFecDes        := cTod( AllTrim( dFecDes ) )
   cCliOrg        := dbFirst( dbfClient )
   cCliDes        := dbLast( dbfClient )
   cConcesionario := "00607333"
   cGetDir        := "c:\ficheros\"
   cFamilia       := Padr( "1", 16 )
   cPicture       := "@E 999999.999"

   /*
   Importamos los datos necesarios---------------------------------------------
   */
   
   Exportacion()

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

      USE ( cPatCli() + "CLIENT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfClient ) )
      SET ADSINDEX TO ( cPatCli() + "CLIENT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FACCLIT.DBF" )  NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIT", @dbfFacCliT ) )
      SET ADSINDEX TO ( cPatEmp() + "FACCLIT.CDX" )  ADDITIVE

      USE ( cPatEmp() + "FACCLIL.DBF" )  NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIL", @dbfFacCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "FACCLIL.CDX" )  ADDITIVE

      USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
      SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

      USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
      SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

      USE ( cPatArt() + "ARTKIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ARTTIK", @dbfKit ) )
      SET ADSINDEX TO ( cPatArt() + "ARTKIT.CDX" ) ADDITIVE

      oStock            := TStock():Create( cPatGrp() )
      if !oStock:lOpenFiles()
         lOpenFiles     := .f.
      end if

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

   if dbfClient != nil
      ( dbfClient )->( dbCloseArea() )
   end if

   if dbfFacCliT != nil
      ( dbfFacCliT )->( dbCloseArea() )
   end if

   if dbfFacCliL != nil
      ( dbfFacCliL )->( dbCloseArea() )
   end if

   if dbfDiv != nil
      ( dbfDiv )->( dbCloseArea() )
   end if

   if dbfKit != nil
      ( dbfKit )->( dbCloseArea() )
   end if

   if dbfIva != nil
      ( dbfIva )->( dbCloseArea() )
   end if

   if !Empty( oStock )
      oStock:end()
   end if

   dbfArticulo    := nil
   dbfClient      := nil
   dbfFacCliT     := nil
   dbfFacCliL     := nil
   dbfDiv         := nil
   dbfKit         := nil
   dbfIva         := nil
   oStock         := nil

   lOpenFiles     := .f.

RETURN ( .t. )

//----------------------------------------------------------------------------//

static function Exportacion()

   local n
   local nRec           := ( dbfFacCliT )->( Recno() )
   local nOrdAnt        := ( dbfFacCliT )->( OrdSetFocus( "dFecFac" ) )
   local nRecL          := ( dbfFacCliL )->( Recno() )
   local nOrdAntL       := ( dbfFacCliL )->( OrdSetFocus( "nNumFac" ) )
   local cTextoFinal    := ""
   local cTextoCliente  := ""
   local cTextoStock    := ""
   local nHand
   local cNameFile
   local aClientes      := {}
   local nImporte       := 0
   local nPromo         := 0
   local aArticulo      := {}
   local nTotUniVen     := 0
   local nTotUniReg     := 0
   local nImpReg        := 0
   local nImpDto        := 0
   local aLinea         := {}
   local aArticuloTotal := {}
   local nStockArticulo := 0
   local lFileFinal     := .f.
   local lFileCliente   := .f.
   local lFileStock     := .f.
   local cTextoFin      := ""

   CursorWait()

   /*
   Vamos la primera vuelta para los clientes-----------------------------------
   */

   while !( dbfFacCliT )->( Eof() )

      if ( ( dbfFacCliT )->dFecFac >= dFecOrg .and.;
         ( dbfFacCliT )->dFecFac <= dFecDes ) .and.;
         ( ( dbfFacCliT )->cCodCli >= cCliOrg .and.;
         ( dbfFacCliT )->cCodCli <= cCliDes )

         if ( dbfFacCliL )->( dbSeek( ( dbfFacCliT )->cSerie + Str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac ) )

            while ( dbfFacCliT )->cSerie + Str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac == ( dbfFacCliL )->cSerie + Str( ( dbfFacCliL )->nNumFac ) + ( dbfFacCliL )->cSufFac .and.;
                  !( dbfFacCliL )->( Eof() )

                  if ( dbfFacCliL )->cCodFam == cFamilia

                     if aScan( aClientes, ( dbfFacCliT )->cCodCli ) == 0

                        cTextoCliente  += cConcesionario
                        cTextoCliente  += ";"
                        cTextoCliente  += AllTrim( ( dbfFacCliT )->cCodCli )
                        cTextoCliente  += ";"
                        
                        if ( dbfClient )->( dbSeek( ( dbfFacCliT )->cCodCli ) )

                           if !Empty( ( dbfClient )->NbrEst )

                              cTextoCliente  += AllTrim( ( dbfClient )->NbrEst )

                           else

                              cTextoCliente  += AllTrim( ( dbfFacCliT )->cNomCli )

                           end if

                        else

                           cTextoCliente  += AllTrim( ( dbfFacCliT )->cNomCli )

                        end if

                        cTextoCliente  += ";"
                        cTextoCliente  += AllTrim( ( dbfFacCliT )->cDirCli )
                        cTextoCliente  += ";"
                        cTextoCliente  += AllTrim( ( dbfFacCliT )->cPobCli )
                        cTextoCliente  += ";"
                        cTextoCliente  += Padr( AllTrim( ( dbfFacCliT )->cPosCli ), 5 )
                        cTextoCliente  += ";"
                        cTextoCliente  += AllTrim( ( dbfFacCliT )->cNomCli )
                        cTextoCliente  += ";"
                        cTextoCliente  += AllTrim( ( dbfFacCliT )->cDniCli )
                        cTextoCliente  += ";"
                        cTextoCliente  += AllTrim( ( dbfFacCliT )->cDirCli )
                        cTextoCliente  += ";"
                        cTextoCliente  += AllTrim( ( dbfFacCliT )->cPobCli )
                        cTextoCliente  += ";"
                        cTextoCliente  += Padr( AllTrim( ( dbfFacCliT )->cPosCli ), 5 )
                        cTextoCliente  += CRLF

                        aAdd( aClientes, ( dbfFacCliT )->cCodCli )

                     end if
                         
                  end if   

               ( dbfFacCliL )->( dbSkip() )

            end while

         end if

      end if

      ( dbfFacCliT )->( dbSkip() )
      
   end while

   /*
   Damos una segunda vuelta para los artículos---------------------------------
   */

   aArticuloTotal := {}

   ( dbfFacCliT )->( dbGoTop() )

   while !( dbfFacCliT )->( Eof() )

      if ( ( dbfFacCliT )->dFecFac >= dFecOrg .and.;
         ( dbfFacCliT )->dFecFac <= dFecDes ) .and.;
         ( ( dbfFacCliT )->cCodCli >= cCliOrg .and.;
         ( dbfFacCliT )->cCodCli <= cCliDes )

         if ( dbfFacCliL )->( dbSeek( ( dbfFacCliT )->cSerie + Str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac ) )

            while ( dbfFacCliT )->cSerie + Str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac == ( dbfFacCliL )->cSerie + Str( ( dbfFacCliL )->nNumFac ) + ( dbfFacCliL )->cSufFac .and.;
                  !( dbfFacCliL )->( Eof() )

                  if ( dbfFacCliL )->cCodFam == cFamilia

                     if ( dbfFacCliL )->nPreUnit != 0

                        nTotUniVen        := ( dbfFacCliL )->nUniCaja
                        nTotUniReg        := 0
                        nImpReg           := 0
                        if ( dbfFacCliL )->nDto != 0
                           nImpDto        := ( dbfFacCliL )->nUniCaja * ( ( dbfFacCliL )->nPreUnit * ( dbfFacCliL )->nDto ) / 100
                        else 
                           nImpDto        := 0 
                        end if

                     else

                        nTotUniVen        := ( dbfFacCliL )->nUniCaja
                        nTotUniReg        := ( dbfFacCliL )->nUniCaja
                        if ( dbfArticulo )->( dbSeek( ( dbfFacCliL )->cRef ) )
                           nImpReg        := ( dbfFacCliL )->nUniCaja * nRetPreArt( ( dbfFacCliL )->nTarLin, ( dbfFacCliT )->cDivFac, ( dbfFacCliT )->lIvaInc, dbfArticulo, dbfDiv, dbfKit, dbfIva )
                        end if
                        nImpDto           := 0

                     end if

                     /*
                     Array para el total de ventas de los artículos------------
                     */

                     if Len( aArticuloTotal ) == 0

                        aAdd( aArticuloTotal, { ( dbfFacCliL )->cRef, nTotUniVen } )

                     else

                        n     := aScan( aArticuloTotal, {|x| x[1] == ( dbfFacCliL )->cRef } )   

                        if n == 0

                           aAdd( aArticuloTotal, { ( dbfFacCliL )->cRef, nTotUniVen } )

                        else

                           aArticuloTotal[n, 2]   += nTotUniVen

                        end if

                     end if

                     /*
                     Array Para cada una de las lineas-------------------------
                     */

                     if Len( aArticulo ) == 0

                        aAdd( aArticulo, { ( dbfFacCliL )->cRef, nTotUniVen, nTotUniReg, nImpReg, nImpDto } )

                     else
                     
                        n     := aScan( aArticulo, {|x| x[1] == ( dbfFacCliL )->cRef } )

                        if n == 0

                           aAdd( aArticulo, { ( dbfFacCliL )->cRef, nTotUniVen, nTotUniReg, nImpReg, nImpDto } )

                        else

                           aArticulo[n, 2]   += nTotUniVen
                           aArticulo[n, 3]   += nTotUniReg
                           aArticulo[n, 4]   += nImpReg
                           aArticulo[n, 5]   += nImpDto

                        end if

                     end if   
                         
                  end if

               ( dbfFacCliL )->( dbSkip() )

            end while

         end if

      end if

      /*
      Lo pasamos al fichero----------------------------------------------------
      */

      if Len( aArticulo ) != 0

         for each aLinea in aArticulo
       
            cTextoFinal       += AllTrim( Str( Year( ( dbfFacCliT )->dFecFac ) ) ) + PadL( month( ( dbfFacCliT )->dFecFac ), 2, "0" )
            cTextoFinal       += ";"
            cTextoFinal       += AllTrim( Str( Year( ( dbfFacCliT )->dFecFac ) ) ) + PadL( month( ( dbfFacCliT )->dFecFac ), 2, "0" ) + PadL( Day( ( dbfFacCliT )->dFecFac ), 2, "0" )
            cTextoFinal       += ";"
            cTextoFinal       += ( dbfFacCliT )->cSerie + AllTrim( Str( ( dbfFacCliT )->nNumFac ) ) 
            cTextoFinal       += ";"
            cTextoFinal       += cConcesionario
            cTextoFinal       += ";"
            cTextoFinal       += AllTrim( ( dbfFacCliT )->cCodCli )
            cTextoFinal       += ";"
            cTextoFinal       += AllTrim( retfld( aLinea[1], dbfArticulo, "cRefAux" ) )
            cTextoFinal       += ";"
            cTextoFinal       += AllTrim( Str( int( aLinea[2] ) ) ) //Unidades entregadas
            cTextoFinal       += ";"
            cTextoFinal       += AllTrim( Str( int( aLinea[3] ) ) ) //Unidades sin cargo
            cTextoFinal       += ";"
            cTextoFinal       += AllTrim( Trans( aLinea[4], cPicture ) ) //Importe unidades sin cargo
            cTextoFinal       += ";"
            cTextoFinal       += AllTrim( Trans( aLinea[5], cPicture ) ) //Importe descuento
            cTextoFinal       += ";"
            cTextoFinal       += AllTrim( Trans( ( aLinea[4] + aLinea[5] ) , cPicture ) ) //Total Importe Promoción
            cTextoFinal       += CRLF

         next

      end if   

      ( dbfFacCliT )->( dbSkip() )

      nTotUniVen     := 0
      nTotUniReg     := 0
      nImpReg        := 0
      nImpDto        := 0
      aArticulo      := {}

   end while

   ( dbfFacCliT )->( OrdSetFocus( nOrdAnt ) )
   ( dbfFacCliL )->( OrdSetFocus( nOrdAntL ) )
   ( dbfFacCliL )->( dbGoTo( nRecL ) )
   ( dbfFacCliT )->( dbGoTo( nRec ) )

   /*
   Creo el fichero para los stocks---------------------------------------------
   */

   /*
   Lo pasamos al fichero----------------------------------------------------
   */

   if Len( aArticuloTotal ) != 0

      for each aLinea in aArticuloTotal

         nStockArticulo    := oStock:nStockArticulo( aLinea[1] )
    
         cTextoStock       += AllTrim( Str( Year( dFecDes ) ) ) + PadL( month( dFecDes ), 2, "0" ) + PadL( Day( dFecDes ), 2, "0" )
         cTextoStock       += ";"
         cTextoStock       += cConcesionario
         cTextoStock       += ";"
         cTextoStock       += AllTrim( retfld( aLinea[1], dbfArticulo, "cRefAux" ) )
         cTextoStock       += ";"
         cTextoStock       += if( nStockArticulo >= 0, AllTrim( Str( Int( nStockArticulo ) ) ), "0"  )//Stock actual
         cTextoStock       += ";"
         cTextoStock       += AllTrim( Str( int( aLinea[2] ) ) ) //Unidades entregadas
         cTextoStock       += CRLF

      next

   end if

   if !Empty( cTextoFinal )

      cNameFile            :=  cGetDir + Right( cConcesionario, 5 ) + PadL( month( Date() ), 2, "0" ) + "A.csv"

      fErase( cNameFile )
      nHand       := fCreate( cNameFile )
      fWrite( nHand, cTextoFinal )
      fClose( nHand )

      lFileFinal           := .t.

   end if   

   if !Empty( cTextoCliente )

      cNameFile            :=  cGetDir + Right( cConcesionario, 5 ) + PadL( month( Date() ), 2, "0" ) + "C.csv"

      fErase( cNameFile )
      nHand       := fCreate( cNameFile )
      fWrite( nHand, cTextoCliente )
      fClose( nHand )

      lFileCliente         := .t.

   end if

   if !Empty( cTextoStock )

      cNameFile            :=  cGetDir + Right( cConcesionario, 5 ) + PadL( month( Date() ), 2, "0" ) + "B.csv"

      fErase( cNameFile )
      nHand       := fCreate( cNameFile )
      fWrite( nHand, cTextoStock )
      fClose( nHand )

      lFileStock           := .t.

   end if

   if !lFileCliente .and. !lFileFinal .and. !lFileStock
      MsgInfo( "Errores en la creación de ficheros" )
   else
      
      cTextoFin      := "Ficheros exportado correctamente en " + cGetDir
      if lFileFinal  
         cTextoFin   += CRLF + Space( 3 ) + "- Fichero de consumo."
      end if
      if lFileCliente  
         cTextoFin   += CRLF + Space( 3 ) + "- Fichero de clientes."
      end if
      if lFileStock 
         cTextoFin   += CRLF + Space( 3 ) + "- Fichero de stocks."
      end if

      MsgInfo( cTextoFin )

   end if

   CursorWE()

Return .t.

//---------------------------------------------------------------------------//