#ifdef __PDA__
#include "FWCE.ch"
REQUEST DBFCDX
#include "Factu.ch" 

static dFechaLiquidacion

static dbfAgentes
static dbfConfig
static dbfAlbCliT
static dbfAlbCliL
static dbfFacCliT
static dbfFacCliL
static dbfIva
static dbfDiv
static dbfFacCliP
static dbfAntCliT
static dbfTranspor
static dbfHisMov
static dbfArticulo

//---------------------------------------------------------------------------//

CLASS SInformeLiquidacion

   DATA cCodigo         AS CHARACTER   INIT ""
   DATA cDescripcion    AS CHARACTER   INIT ""
   DATA cLote           AS CHARACTER   INIT ""
   DATA nEntrada        AS NUMERIC     INIT 0
   DATA nSalida         AS NUMERIC     INIT 0

   METHOD SumaEntrada( n ) INLINE         ( ::nEntrada   += n )
   METHOD SumaSalida( n )  INLINE         ( ::nSalida    += n )
   METHOD Saldo()          INLINE         ( ::nEntrada - ::nSalida )

END CLASS

//---------------------------------------------------------------------------//
//Funciones para realizar liquidaciones
//---------------------------------------------------------------------------//

FUNCTION pdaLiquidaciones()

   local oFOnt
   local oDlg
   local oBtn
   local oGetFecha

   dFechaLiquidacion := GetSysDate()

   DEFINE FONT oFont NAME "Verdana" SIZE 0, -14

   DEFINE DIALOG oDlg RESOURCE "liqui_pda"

      REDEFINE SAY oSayTit ;
         VAR      "Imprimiendo liquidaciones" ;
         ID       110 ;
         COLOR    "N/W*" ;
         FONT     oFont ;
         OF       oDlg

      REDEFINE BTNBMP oBtn ;
         ID       100 ;
         OF       oDlg ;
         FILE     ( cPatBmp() + "moneybag_euro_16.bmp" ) ;
         NOBORDER ;
         ACTION      ( nil )

         oBtn:SetColor( 0, nRGB( 255, 255, 255 )  )

      REDEFINE GET oGetFecha VAR dFechaLiquidacion ;
         ID       120 ;
         OF       oDlg

      ACTIVATE DIALOG oDlg ;
         ON INIT ( pdaMenuLiq( oDlg ) )

   // Restauramos la ventana---------------------------------------------------

   oWnd():Show()

return .t.

//---------------------------------------------------------------------------//

function pdaMenuLiq( oDlg )

   local oMenu

   DEFINE MENU oMenu ;
      RESOURCE 190 ;
      BITMAPS  70 ; // bitmaps resoruces ID
      IMAGES   3     // number of images in the bitmap

      REDEFINE MENUITEM ID 191 OF oMenu ACTION ( pdaImprimirLiq( oDlg ) , oDlg:End( IDOK ) )

      REDEFINE MENUITEM ID 192 OF oMenu ACTION ( oDlg:End( IDCANCEL ) )

   oDlg:SetMenu( oMenu )

Return oMenu

//---------------------------------------------------------------------------//

function pdaImprimirLiq( oDlg )

   local nScan
   local oError
   local oBlock
   local cTextToPrint         := ""
   local nTotalDocumentos     := 0
   local nTotalCobros         := 0
   local nTotalPendiente      := 0
   local nTotalAlbaranes      := 0
   local nTotalAtrasados      := 0
   local cInformeLiquidacion
   local aInformeLiquidacion  := {}
   local cAlmacen             := cDefAlm()

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   pdaOpenFiles()

   /*
   Proceso de imprimir liquidaciones-------------------------------------------
   */

                    //         1         2         3         4         5         6
                    //123456789012345678901234567890123456789012345678901234567890

   cTextToPrint   += CRLF + CRLF

   cTextToPrint   += REPLICATE( "-", 60 ) + CRLF
   cTextToPrint   += "                         LIQUIDACION                        " + CRLF
   cTextToPrint   += REPLICATE( "-", 60 ) + CRLF

   if ( dbfAgentes )->( dbSeek( cCodAge() ) )

                       //         1         2         3         4         5         6
                       //123456789012345678901234567890123456789012345678901234567890

      cTextToPrint   += "Agente: " + Alltrim( ( dbfAgentes )->cNbrAge ) + Space( 1 ) + Alltrim( ( dbfAgentes )->cApeAge ) + Space( 1 ) + DToc( GetSysDate() ) + Space( 1 ) + Time() + CRLF

   end if

   cTextToPrint      += REPLICATE( "-", 60 ) + CRLF

//-----------------------------------------------------------------------------
// DOCUMENTOS REALIZADOS
//-----------------------------------------------------------------------------

   cTextToPrint      += Padr( "DOCUMENTOS REALIZADOS", 60, "-" ) + CRLF + CRLF

   /*
   Albaranes-------------------------------------------------------------------
   */

   if ( dbfAlbCliT )->( dbSeek( dFechaLiquidacion ) )

      cTextToPrint   +=  "Albaran         Hora  Codigo  Nombre cliente         Importe" + CRLF
      cTextToPrint   +=  "--------------- ----- ------- ------------------- ----------" + CRLF
                         //         1         2         3         4         5         6
                         //123456789012345678901234567890123456789012345678901234567890

      while ( dbfAlbCliT )->dFecAlb == dFechaLiquidacion .and. ( dbfAlbCliT )->cCodAge == cCodAge() .and. !( dbfAlbCliT )->( eof() )

         cTextToPrint      += PadR( AllTrim( ( dbfAlbCliT )->cSerAlb + "/" + AllTrim( Str( ( dbfAlbCliT )->nNumAlb ) ) + "/" + ( dbfAlbCliT )->cSufAlb ), 15, Space( 1 ) ) + Space( 1 )
         cTextToPrint      += ( dbfAlbCliT )->cTimCre + Space( 1 )
         cTextToPrint      += PadR( AllTrim( ( dbfAlbCliT )->cCodCli ), 7, Space( 1 ) ) + Space( 1 )
         cTextToPrint      += PadR( AllTrim( ( dbfAlbCliT )->cNomCli ), 19, Space( 1 ) ) + Space( 1 )
         cTextToPrint      += Right( nTotAlbCli( ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb, dbfAlbCliT, dbfAlbCliL, dbfIva, dbfDiv, nil, cDivEmp(), .t. ), 10 ) + CRLF

         nTotalAlbaranes   += nTotAlbCli( ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb, dbfAlbCliT, dbfAlbCliL, dbfIva, dbfDiv, nil, cDivEmp(), .f. )
         nTotalDocumentos  += nTotAlbCli( ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb, dbfAlbCliT, dbfAlbCliL, dbfIva, dbfDiv, nil, cDivEmp(), .f. )

         ( dbfAlbCliT )->( dbSkip() )

      end while

   end if

   /*
   Facturas liquidadas---------------------------------------------------------
   */

   if ( dbfFacCliT )->( dbSeek( dFechaLiquidacion ) )

      cTextToPrint   += CRLF
      cTextToPrint   += "Factura [LIQ]   Hora  Codigo  Nombre cliente         Importe" + CRLF
      cTextToPrint   += "--------------- ----- ------- ------------------- ----------" + CRLF
                        //         1         2         3         4         5         6
                        //123456789012345678901234567890123456789012345678901234567890

      while ( dbfFacCliT )->dFecFac == dFechaLiquidacion    .and.;
            ( dbfFacCliT )->cCodAge == cCodAge()            .and.;
            !( dbfFacCliT )->( eof() )

         if ( dbfFacCliT )->lLiquidada

            cTextToPrint   += PadR( AllTrim( ( dbfFacCliT )->cSerie + "/" + AllTrim( Str( ( dbfFacCliT )->nNumFac ) ) + "/" + ( dbfFacCliT )->cSufFac ), 15, Space( 1 ) ) + Space( 1 )
            cTextToPrint   += ( dbfFacCliT )->cTimCre + Space( 1 )
            cTextToPrint   += PadR( AllTrim( ( dbfFacCliT )->cCodCli ), 7, Space( 1 ) ) + Space( 1 )
            cTextToPrint   += PadR( AllTrim( ( dbfFacCliT )->cNomCli ), 19, Space( 1 ) ) + Space( 1 )
            cTextToPrint   += Right( nTotFacCli( ( dbfFacCliT )->cSerie + Str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac, dbfFacCliT, dbfFacCliL, dbfIva, dbfDiv, dbfFacCliP, dbfAntCliT, nil, cDivEmp(), .t. ), 10 ) + CRLF

            nTotalDocumentos  += nTotFacCli( ( dbfFacCliT )->cSerie + Str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac, dbfFacCliT, dbfFacCliL, dbfIva, dbfDiv, dbfFacCliP, dbfAntCliT, nil, cDivEmp(), .f. )

         end if

         ( dbfFacCliT )->( dbSkip() )

      end while

   end if

   /*
   Facturas no liquidadas------------------------------------------------------
   */

   ( dbfFacCliT )->( dbGoTop() )

   if ( dbfFacCliT )->( dbSeek( dFechaLiquidacion ) )

      cTextToPrint   += CRLF
      cTextToPrint   += "Factura [PDT]   Hora  Codigo  Nombre cliente         Importe" + CRLF
      cTextToPrint   += "--------------- ----- ------- ------------------- ----------" + CRLF
                        //         1         2         3         4         5         6
                        //123456789012345678901234567890123456789012345678901234567890

      while ( dbfFacCliT )->dFecFac == dFechaLiquidacion    .and.;
            ( dbfFacCliT )->cCodAge == cCodAge()            .and.;
            !( dbfFacCliT )->( eof() )

         if !( dbfFacCliT )->lLiquidada

            cTextToPrint   += PadR( AllTrim( ( dbfFacCliT )->cSerie + "/" + AllTrim( Str( ( dbfFacCliT )->nNumFac ) ) + "/" + ( dbfFacCliT )->cSufFac ), 15, Space( 1 ) ) + Space( 1 )
            cTextToPrint   += ( dbfFacCliT )->cTimCre + Space( 1 )
            cTextToPrint   += PadR( AllTrim( ( dbfFacCliT )->cCodCli ), 7, Space( 1 ) ) + Space( 1 )
            cTextToPrint   += PadR( AllTrim( ( dbfFacCliT )->cNomCli ), 19, Space( 1 ) ) + Space( 1 )
            cTextToPrint   += Right( nTotFacCli( ( dbfFacCliT )->cSerie + Str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac, dbfFacCliT, dbfFacCliL, dbfIva, dbfDiv, dbfFacCliP, dbfAntCliT, nil, cDivEmp(), .t. ), 10 ) + CRLF

            nTotalDocumentos  += nTotFacCli( ( dbfFacCliT )->cSerie + Str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac, dbfFacCliT, dbfFacCliL, dbfIva, dbfDiv, dbfFacCliP, dbfAntCliT, nil, cDivEmp(), .f. )
            nTotalPendiente   += nTotFacCli( ( dbfFacCliT )->cSerie + Str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac, dbfFacCliT, dbfFacCliL, dbfIva, dbfDiv, dbfFacCliP, dbfAntCliT, nil, cDivEmp(), .f. )

         end if

         ( dbfFacCliT )->( dbSkip() )

      end while

   end if

//-----------------------------------------------------------------------------
// COBROS DEL DIA
//-----------------------------------------------------------------------------

   if dbSeekInOrd( cCodAge(), "cCodAge", dbfFacCliP )

      cTextToPrint   += REPLICATE( "-", 60 ) + CRLF

      cTextToPrint   += Padr( "COBROS REALIZADOS", 60, "-" ) + CRLF + CRLF

      cTextToPrint   +=  "Recibo          Codigo  Nombre cliente               Importe" + CRLF
      cTextToPrint   +=  "--------------- ------- ------------------------- ----------" + CRLF
                         //         1         2         3         4         5         6
                         //123456789012345678901234567890123456789012345678901234567890

      while !( dbfFacCliP )->( eof() )

         if ( dbfFacCliP )->cSufFac == cSufPda()            .and.;
            ( dbfFacCliP )->lCobrado                        .and.;
            ( dbfFacCliP )->dPreCob == dFechaLiquidacion    .and.;
            ( dbfFacCliP )->dEntrada == dFechaLiquidacion

            cTextToPrint   += PadR( AllTrim( ( dbfFacCliP )->cSerie + "/" + AllTrim( Str( ( dbfFacCliP )->nNumFac ) ) + "/" + ( dbfFacCliP )->cSufFac ), 15, Space( 1 ) ) + Space( 1 )
            cTextToPrint   += PadR( ( dbfFacCliP )->cCodCli, 7, Space( 1 ) ) + Space( 1 )
            cTextToPrint   += PadR( ( dbfFacCliP )->cNomCli, 25, Space( 1 ) ) + Space( 1 )
            cTextToPrint   += Right( Trans( ( dbfFacCliP )->nImporte, "@E 9999999.99" ), 10 ) + CRLF

            nTotalCobros   += ( dbfFacCliP )->nImporte

         end if

         ( dbfFacCliP )->( dbSkip() )

      end while

   end if

//-----------------------------------------------------------------------------
// COBROS ATRASADOS
//-----------------------------------------------------------------------------

   cTextToPrint   += REPLICATE( "-", 60 ) + CRLF

   cTextToPrint   += Padr( "COBROS ATRASADOS", 60, "-" ) + CRLF + CRLF

   cTextToPrint   +=  "Recibo          Codigo  Nombre cliente               Importe" + CRLF
   cTextToPrint   +=  "--------------- ------- ------------------------- ----------" + CRLF
                   //         1         2         3         4         5         6
                   //123456789012345678901234567890123456789012345678901234567890

   ( dbfFacCliP )->( dbGoTop() )

   while !( dbfFacCliP )->( eof() )

      if ( dbfFacCliP )->lCobrado                        .and.;
         ( dbfFacCliP )->dPreCob != dFechaLiquidacion    .and.;
         ( dbfFacCliP )->dEntrada == dFechaLiquidacion

         cTextToPrint      += PadR( AllTrim( ( dbfFacCliP )->cSerie + "/" + AllTrim( Str( ( dbfFacCliP )->nNumFac ) ) + "/" + ( dbfFacCliP )->cSufFac ), 15, Space( 1 ) ) + Space( 1 )
         cTextToPrint      += PadR( ( dbfFacCliP )->cCodCli, 7, Space( 1 ) ) + Space( 1 )
         cTextToPrint      += PadR( ( dbfFacCliP )->cNomCli, 25, Space( 1 ) ) + Space( 1 )
         cTextToPrint      += Right( Trans( ( dbfFacCliP )->nImporte, "@E 9999999.99" ), 10 ) + CRLF

         nTotalAtrasados   += ( dbfFacCliP )->nImporte

      end if

      ( dbfFacCliP )->( dbSkip() )

   end while

   cTextToPrint  += REPLICATE( "-", 60 ) + CRLF

   cTextToPrint  += Padr( "TOTAL VENTAS", 60, "-" ) + CRLF

   cTextToPrint  += Space( 20 )
   cTextToPrint  += "Total albaranes: " + Padl( Right( Str( nTotalalbaranes ), 20 ), 20 ) + CRLF
   cTextToPrint  += Space( 20 )
   cTextToPrint  += "Total cobrado:   " + Padl( Right( Trans( nTotalCobros, "@E 9999999.99" ), 20 ), 20 ) + CRLF
   cTextToPrint  += Space( 20 )
   cTextToPrint  += "Total pendiente: " + Padl( Right( Trans( nTotalPendiente, "@E 9999999.99" ), 20 ), 20 ) + CRLF
   cTextToPrint  += Space( 20 )
   cTextToPrint  += "Total ventas:    " + Padl( Right( Str( nTotalDocumentos ), 20 ), 20 ) + CRLF

   cTextToPrint  += Padr( "TOTAL A ENTREGAR", 60, "-" ) + CRLF

   cTextToPrint  += Space( 20 )
   cTextToPrint  += "Total cobrado:   " + Padl( Right( Trans( nTotalCobros, "@E 9999999.99" ), 20 ), 20 ) + CRLF
   cTextToPrint  += Space( 20 )
   cTextToPrint  += "Total atrasados: " + Padl( Right( Trans( nTotalAtrasados, "@E 9999999.99" ), 20 ), 20 ) + CRLF
   cTextToPrint  += Space( 20 )
   cTextToPrint  += "Total a entregar:" + Padl( Right( Trans( nTotalCobros + nTotalAtrasados, "@E 9999999.99" ), 20 ), 20 ) + CRLF

//-----------------------------------------------------------------------------
// EXISTENCIAS EN EL VEHÍCULO
//-----------------------------------------------------------------------------

   ( dbfAlbCliT )->( dbGoTop() )
   ( dbfAlbCliL )->( dbGoTop() )
   ( dbfFacCliT )->( dbGoTop() )
   ( dbfFacCliL )->( dbGoTop() )
   ( dbfHisMov )->( dbGoTop() )

   //MOVIMIENTOS DE ALMACEN

   if ( dbfHisMov )->( dbSeek( DtoS( dFechaLiquidacion ) + Space( 5 ) ) )

      while !( dbfHisMov )->( eof() )

         if ( dbfHisMov )->dFecMov == dFechaLiquidacion

            if !Empty( ( dbfHisMov )->cAliMov ) .and. ( dbfHisMov )->cAliMov == cAlmacen

               nScan := aScan( aInformeLiquidacion, {|s| s:cCodigo == ( dbfHisMov )->cRefMov } )

               if nScan == 0

                  sInforme                := sInformeLiquidacion()
                  sInforme:cCodigo        := ( dbfHisMov )->cRefMov
                  sInforme:cDescripcion   := RetFld( ( dbfHisMov )->cRefMov, dbfArticulo )

                  sInforme:nEntrada       += sInforme:SumaEntrada( nTotNMovAlm( dbfHisMov ) )

                  aAdd( aInformeLiquidacion, sInforme )

               else

                  aInformeLiquidacion[ nScan ]:SumaEntrada( nTotNMovAlm( dbfHisMov ) )

               end if

            end if

            if !Empty( ( dbfHisMov )->cAloMov ) .and. ( dbfHisMov )->cAloMov == cAlmacen

               nScan := aScan( aInformeLiquidacion, {|s| s:cCodigo == ( dbfHisMov )->cRefMov } )

               if nScan == 0

                  sInforme                := sInformeLiquidacion()
                  sInforme:cCodigo        := ( dbfHisMov )->cRefMov
                  sInforme:cDescripcion   := RetFld( ( dbfHisMov )->cRefMov, dbfArticulo )

                  sInforme:nSalida         += sInforme:SumaSalida( nTotNMovAlm( dbfHisMov ) )

                  aAdd( aInformeLiquidacion, sInforme )

               else

                  aInformeLiquidacion[ nScan ]:SumaSalida( nTotNMovAlm( dbfHisMov ) )

               end if

            end if

         end if

         ( dbfHisMov )->( dbSkip() )

      end while

   end if

//---------------------------------------------------------------------------//

   //ALBARANES

   if ( dbfAlbCliT )->( dbSeek( dFechaLiquidacion ) )

      while ( dbfAlbCliT )->( dFecAlb ) == dFechaLiquidacion .and. !( dbfAlbCliT )->( eof() )

         if ( dbfAlbCliL )->( dbSeek( ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb ) )

            while ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb == ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb .and. !( dbfAlbCliL )->( eof() )

               nScan := aScan( aInformeLiquidacion, {|s| s:cCodigo == ( dbfAlbCliL )->cRef } )

               if nScan == 0
                  sInforme                := sInformeLiquidacion()
                  sInforme:cCodigo        := ( dbfAlbCliL )->cRef
                  sInforme:cDescripcion   := ( dbfAlbCliL )->cDetalle
                  sInforme:nSalida        += sInforme:SumaSalida( nTotNAlbCli( dbfAlbCliL ) )

                  aAdd( aInformeLiquidacion, sInforme )

               else

                  aInformeLiquidacion[ nScan ]:SumaSalida( nTotNAlbCli( dbfAlbCliL ) )

               end if

               ( dbfAlbCliL )->( dbSkip() )

            end while

         end if

         ( dbfAlbCliT )->( dbSkip() )

      end while

   end if

   //FACTURAS

   if ( dbfFacCliT )->( dbSeek( dFechaLiquidacion ) )

      while ( dbfFacCliT )->( dFecFac ) == dFechaLiquidacion .and. !( dbfFacCliT )->( eof() )

         if ( dbfFacCliL )->( dbSeek( ( dbfFacCliT )->cSerie + Str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac ) )

            while ( dbfFacCliT )->cSerie + Str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac == ( dbfFacCliL )->cSerie + Str( ( dbfFacCliL )->nNumFac ) + ( dbfFacCliL )->cSufFac .and. !( dbfFacCliL )->( eof() )

               nScan := aScan( aInformeLiquidacion, {|s| s:cCodigo == ( dbfFacCliL )->cRef } )

               if nScan == 0
                  sInforme                := sInformeLiquidacion()
                  sInforme:cCodigo        := ( dbfFacCliL )->cRef
                  sInforme:cDescripcion   := ( dbfFacCliL )->cDetalle
                  sInforme:nSalida        += sInforme:SumaSalida( nTotNFacCli( dbfFacCliL ) )

                  aAdd( aInformeLiquidacion, sInforme )

               else

                  aInformeLiquidacion[ nScan ]:SumaSalida( nTotNFacCli( dbfFacCliL ) )

               end if

               ( dbfFacCliL )->( dbSkip() )

            end while

         end if

         ( dbfFacCliT )->( dbSkip() )

      end while

   end if

//---------------------------------------------------------------------------//

   cTextToPrint   += REPLICATE( "-", 60 ) + CRLF

   cTextToPrint   += Padr( "LIQUIDACIONES", 60, "-" ) + CRLF + CRLF

   cTextToPrint   += "Articulo                           Entrada   Salida    Stock" + CRLF

   cTextToPrint   += "--------------------------------- -------- -------- --------" + CRLF

                    //         1         2         3         4         5         6
                    //123456789012345678901234567890123456789012345678901234567890

   for each cInformeLiquidacion in aInformeLiquidacion

      cTextToPrint  += PadR( cInformeLiquidacion:cCodigo, 33, Space(1) ) + Space( 1 )
      cTextToPrint  += PadL( Trans( cInformeLiquidacion:nEntrada, "@E 9999.9" ), 8, Space( 1 ) ) + Space( 1 )
      cTextToPrint  += PadL( Trans( cInformeLiquidacion:nSalida, "@E 9999.9" ), 8, Space( 1 ) ) + Space( 1 )
      cTextToPrint  += PadL( Trans( cInformeLiquidacion:Saldo(), "@E 9999.9" ), 8, Space( 1 ) ) + CRLF
      cTextToPrint  += PadR( cInformeLiquidacion:cDescripcion, 60, Space( 1 ) ) + CRLF

   next

   cTextToPrint   += REPLICATE( "-", 60 ) + CRLF

//-----------------------------------------------------------------------------

   msginfo( "Compruebe si la impresora está en línea y si tiene papel suficiente", "¡Atención!" )

   SendText( cTextToPrint )

   pdaCloseFiles()

   RECOVER

      msgStop( "Ocurrió un error a la hora de imprimir liquidaciones" )

   END SEQUENCE

   ErrorBlock( oBlock )

return .t.

//---------------------------------------------------------------------------//

static function pdaOpenFiles()

   local lOpen       := .t.
   local oError
   local oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   /*
   Bases de datos necesarias para imprimir liquidaciones-----------------------
   */

      USE ( cPatEmp() + "AGENTES.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AGENTES", @dbfAgentes ) )
      SET ADSINDEX TO ( cPatEmp() + "AGENTES.CDX" ) ADDITIVE

      if !TDataCenter():OpenAlbCliT( @dbfAlbCliT )
         lOpen     := .f.
      else 
         ( dbfAlbCliT )->( OrdSetFocus( "dFecAlb" ) )
      end if

      USE ( cPatEmp() + "ALBCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "ALBCLIL", @dbfAlbCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "ALBCLIL.CDX" ) ADDITIVE
      ( dbfAlbCliL )->( OrdSetFocus( "nNumAlb" ) )

      if !TDataCenter():OpenFacCliT( @dbfFacCliT )
         lOpen     := .f.
      else
         ( dbfFacCliT )->( OrdSetFocus( "dFecFac" ) )
      end if

      USE ( cPatEmp() + "FACCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIL", @dbfFacCliL ) )
      SET ADSINDEX TO ( cPatEmp() + "FACCLIL.CDX" ) ADDITIVE
      ( dbfFacCliL )->( OrdSetFocus( "nNumFac" ) )

      USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
      SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

      USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
      SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

      if !TDataCenter():OpenFacCliP( @dbfFacCliP )
         lOpen     := .f.
      else 
         ( dbfFacCliP )->( OrdSetFocus( "cCodAge" ) )      
      end if

      USE ( cPatEmp() + "AntCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AntCliT", @dbfAntCliT ) )
      SET ADSINDEX TO ( cPatEmp() + "AntCliT.CDX" ) ADDITIVE

      USE ( cPatEmp() + "Transpor.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Transpor", @dbfTranspor ) )
      SET ADSINDEX TO ( cPatEmp() + "Transpor.CDX" ) ADDITIVE
      ( dbfTranspor )->( OrdSetFocus( "cCodTrn" ) )

      USE ( cPatEmp() + "HisMov.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "HisMov", @dbfHisMov ) )
      SET ADSINDEX TO ( cPatEmp() + "HisMov.CDX" ) ADDITIVE
      ( dbfHisMov )->( OrdSetFocus( "dFecMov" ) )

      USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Articulo", @dbfArticulo ) )
      SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )
      pdaCloseFiles()

      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

return ( lOpen )

//---------------------------------------------------------------------------//

static function pdaCloseFiles()

   CLOSE( dbfAgentes  )
   CLOSE( dbfAlbCliT  )
   CLOSE( dbfAlbCliL  )
   CLOSE( dbfFacCliT  )
   CLOSE( dbfFacCliL  )
   CLOSE( dbfIva      )
   CLOSE( dbfDiv      )
   CLOSE( dbfFacCliP  )
   CLOSE( dbfAntCliT  )
   CLOSE( dbfTranspor )
   CLOSE( dbfHisMov   )
   CLOSE( dbfArticulo )

   dbfAgentes  := nil
   dbfAlbCliT  := nil
   dbfAlbCliL  := nil
   dbfFacCliT  := nil
   dbfFacCliL  := nil
   dbfIva      := nil
   dbfDiv      := nil
   dbfFacCliP  := nil
   dbfAntCliT  := nil
   dbfTranspor := nil
   dbfHisMov   := nil
   dbfArticulo := nil

return .t.

//---------------------------------------------------------------------------//