#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Empresa.ch"
#include "hbxml.ch"
#include "Xbrowse.ch"

static cCodigoEmpresaEnUso
static cCodigoDelegacionEnUso

static aEmpresa
static aDelegacion

static cCodEmp          := ""

static aMnuNext         := {}
static aMnuPrev         := {}
static aDlgEmp          := {}

static nError           := 0

static nHndCaj

static aEmpresasGrupo   := {}

static cDefPicIn
static cDefPicOut

static lAds             := .f.
static lAIS             := .f.
static lCdx             := .f.

static cIp              := ""
static cData            := ""
static nAdsServer       := 7
static cAdsLocal        := ""
static cAdsFile         := "Gestool.Add"

static cCodigoAgente    := ""

static dSysDate

static cEmpUsr
static cPatGrp
static cPatCli
static cPatArt
static cPatPrv
static cPatAlm
static cPatEmp
static cPatTmp
static cPathPC
static cNombrePc        := ""

static cUsrTik

static oFastReport

static hMapaAjuste   := {  "#,#0"   => { "Round" => 1,  "Incrementa" => 0.00,    "Decrementa" => 0.00,  "Ceros" => .t. } ,;
                           "#,#5"   => { "Round" => 1,  "Incrementa" => 0.05,    "Decrementa" => -0.05,  "Ceros" => .f. } ,;
                           "#,#9"   => { "Round" => 1,  "Incrementa" => 0.09,    "Decrementa" => -0.01,  "Ceros" => .f. } ,;
                           "#,10"   => { "Round" => 0,  "Incrementa" => 0.10,    "Decrementa" => -0.90,  "Ceros" => .f. } ,;
                           "#,20"   => { "Round" => 0,  "Incrementa" => 0.20,    "Decrementa" => -0.80,  "Ceros" => .f. } ,;
                           "#,50"   => { "Round" => 0,  "Incrementa" => 0.50,    "Decrementa" => -0.50,  "Ceros" => .f. } ,;
                           "#,90"   => { "Round" => 0,  "Incrementa" => 0.90,    "Decrementa" => -0.10,  "Ceros" => .f. } ,;
                           "#,95"   => { "Round" => 0,  "Incrementa" => 0.95,    "Decrementa" => -0.05,  "Ceros" => .f. } ,;
                           "#,99"   => { "Round" => 0,  "Incrementa" => 0.99,    "Decrementa" => -0.01,  "Ceros" => .f. } ,;
                           "#,00"   => { "Round" => 0,  "Incrementa" => 1.00,    "Decrementa" => -9.00,  "Ceros" => .t. } ,;
                           "1,00"   => { "Round" => -1, "Incrementa" => 11.00,   "Decrementa" => -19.00, "Ceros" => .f. } ,;
                           "5,00"   => { "Round" => -1, "Incrementa" => 15.00,   "Decrementa" => -15.00, "Ceros" => .f. } ,;
                           "9,00"   => { "Round" => -1, "Incrementa" => 19.00,   "Decrementa" => -19.00, "Ceros" => .f. } ,;
                           "10,00"  => { "Round" => -2, "Incrementa" => 110.00,  "Decrementa" => 110.00,"Ceros" => .f. } ,;
                           "20,00"  => { "Round" => -2, "Incrementa" => 120.00,  "Decrementa" => 120.00,"Ceros" => .f. } ,;
                           "50,00"  => { "Round" => -2, "Incrementa" => 150.00,  "Decrementa" => 150.00,"Ceros" => .f. } ,;
                           "100,00" => { "Round" => -3, "Incrementa" => 200.00,  "Decrementa" => 200.00,"Ceros" => .f. } }

//----------------------------------------------------------------------------//

FUNCTION nAjuste( nNumber, cAdjust )

   local n
   local nAjusteDecimales
   local nAjusteIncrementa
   local nAjusteDecrementa
   local cNumber
   local nResult
   local cResult
   local aAdjust
   local aNumber        := {}

   if Empty( nNumber )
      Return ( 0 )
   end if 

   /*
   Posible ajuste doble--------------------------------------------------------
   */

   nResult              := 0
   aAdjust              := hb_aTokens( cAdjust, "|" )

   for each cAdjust in aAdjust

      nAjusteDecimales  := nAjusteDecimales( cAdjust )
      nAjusteIncrementa := nAjusteIncrementa( cAdjust )
      nAjusteDecrementa := nAjusteDecrementa( cAdjust )

      if !empty(nAjusteDecimales)

        nResult         := Round( nNumber, nAjusteDecimales )

        if nResult - nNumber > 0
           nResult      += nAjusteDecrementa
        else 
           nResult      += nAjusteIncrementa 
        end if 

        aAdd( aNumber, nResult )

      end if 

   next 

   for each n in aNumber
      if ( ( n - nNumber ) >= -0.000001 )
         nResult        := n
         exit 
      end if 
   next

RETURN ( nResult )

//---------------------------------------------------------------------------//

Static Function nAjusteDecimales( cAjuste )

  local hAjuste
  local nAjusteDecimales

  if hHasKey( hMapaAjuste, cAjuste )
    hAjuste             := hGet( hMapaAjuste, cAjuste )
    if !Empty( hAjuste )
      nAjusteDecimales  := hGet( hAjuste, "Round" )
    end if
  end if

Return ( nAjusteDecimales )

//---------------------------------------------------------------------------//

Static Function nAjusteIncrementa( cAjuste )

  local hAjuste
  local nAjusteIncrementa

  if hHasKey( hMapaAjuste, cAjuste )
    hAjuste             := hGet( hMapaAjuste, cAjuste )
    if !Empty( hAjuste )
      nAjusteIncrementa := hGet( hAjuste, "Incrementa" )
    end if
  end if

Return ( nAjusteIncrementa )

//---------------------------------------------------------------------------//

Static Function nAjusteDecrementa( cAjuste )

  local hAjuste
  local nAjusteDecrementa

  if hHasKey( hMapaAjuste, cAjuste )
    hAjuste             := hGet( hMapaAjuste, cAjuste )
    if !Empty( hAjuste )
      nAjusteDecrementa := hGet( hAjuste, "Decrementa" )
    end if
  end if

Return ( nAjusteDecrementa )

//---------------------------------------------------------------------------//

Static Function nAjusteCeros( cAjuste )

  local hAjuste
  local nAjusteCeros

  if hHasKey( hMapaAjuste, cAjuste )
    hAjuste             := hGet( hMapaAjuste, cAjuste )
    if !Empty( hAjuste )
      nAjusteCeros      := hGet( hAjuste, "Ceros" )
    end if
  end if

Return ( nAjusteCeros )

//---------------------------------------------------------------------------//

Function lAds( lSetAds )

   if IsLogic( lSetAds )
      lAds     := lSetAds
   end if

Return ( lAds )

//----------------------------------------------------------------------------//

Function lAIS( lSetAIS )

   if IsLogic( lSetAIS )
      lAIS     := lSetAIS
   end if

Return ( lAIS )

//----------------------------------------------------------------------------//

Function lAdsRdd()

Return ( lAds() .or. lAIS() )

//----------------------------------------------------------------------------//

Function cFieldTimeStamp()

Return ( if( lAdsRdd(), "Timestamp", "T" ) )

//----------------------------------------------------------------------------//

Function cIp( cSetIp )

   if IsChar( cSetIp )
      cIp      := cSetIp
   end if

Return ( cPath( cIp ) )

//----------------------------------------------------------------------------//

Function cData( cSetData )

   if IsChar( cSetData )
      cData    := cSetData
   end if

Return ( if( !Empty( cData ), cPath( cData ), "" ) )

//----------------------------------------------------------------------------//

Function nAdsServer( nServer )

   if IsNum( nServer )
      nAdsServer  := nServer
   end if

Return ( nAdsServer )

//----------------------------------------------------------------------------//

Function cAdsLocal( cLocal )

   if IsChar( cLocal )
      cAdsLocal    := cLocal
   end if

Return ( cAdsLocal )

//----------------------------------------------------------------------------//

Function cAdsUNC()

   if ( "localhost" $ cIp() )
      Return( cData() )
   end if

Return ( cIp() + cData() )

//----------------------------------------------------------------------------//

Function cAdsFile( cFile )

   if ( isChar( cFile ) .and. !empty( cFile ) )
      cAdsFile := cFile
   end if 

Return ( cAdsFile )

//----------------------------------------------------------------------------//

Function lCdx( lSetCdx )

   if IsLogic( lSetCdx )
      lCdx     := lSetCdx
   end if

Return ( lCdx )

//---------------------------------------------------------------------------//

Function cCodigoAgente( cAgente )

   if IsChar( cAgente )
      cCodigoAgente    := cAgente
   end if

Return ( cCodigoAgente )

//----------------------------------------------------------------------------//

Function lPda()

Return ( "PDA" $ cParamsMain() )

//---------------------------------------------------------------------------//

Function SetIndexToAIS()

   lCdx( .f. )
   lAIS( .t. )

   RddSetDefault( "ADSCDX" )

Return nil 

//---------------------------------------------------------------------------//

Function SetIndexToCDX()

   lCdx( .t. )
   lAIS( .f. )
   
   RddSetDefault( "DBFCDX" )

Return nil 

#ifndef __PDA__

Function cDriver()

   if lAds()
      Return ( 'ADS' )
   end if

   if lAIS()
      Return ( 'ADS' )
   end if

Return ( 'DBFCDX' )

//---------------------------------------------------------------------------//

Function cADSDriver()

Return ( 'ADS' )

//---------------------------------------------------------------------------//

Function cLocalDriver()

Return ( 'DBFCDX' )

//---------------------------------------------------------------------------//

Function cNombrePc( xValue )

   if !Empty( xValue )
      cNombrePc   := xValue
   end if

Return ( cNombrePc )

//--------------------------------------------------------------------------//

Function CacheRecords( cAlias )

   if lAdsRdd()
      ( cAlias )->( AdsCacheRecords( 50 ) )
   end if

Return nil

//---------------------------------------------------------------------------//

/*
Funciones para gst rotor
*/
//---------------------------------------------------------------------------//

Function cPatDat( lFull )

   DEFAULT lFull  := .f.

   if lAds()
      Return ( cAdsUNC() + "Datos\" )
   end if

   if lAIS() .and. lFull
      Return ( cAdsUNC() + "Datos\" )
   end if

   if lAIS() .and. !lFull
      Return ( "Datos" )
   end if

   if lCdx()
      Return ( FullCurDir() + "Datos\" )
   end if

Return ( FullCurDir() + "Datos\" )

//----------------------------------------------------------------------------//

Function cPatDatLocal( lFull )

   DEFAULT lFull  := .f.

   if lAds()
      Return ( cAdsLocal() + "Datos\" )
   end if

   if lAIS() .and. lFull
      Return ( cAdsLocal() + "Datos\" )
   end if

   if lAIS() .and. !lFull
      Return ( "Datos" )
   end if

   if lCdx()
      Return ( FullCurDir() + "Datos\" )
   end if

Return ( FullCurDir() + "Datos\" )

//----------------------------------------------------------------------------//

Function cPatADS( lFull )

   DEFAULT lFull  := .f.

   if lAds()
      Return ( cAdsUNC() + "ADS\" )
   end if

   if lAIS() .and. lFull
      Return ( cAdsUNC() + "ADS\" )
   end if

   if lAIS() .and. !lFull
      Return ( "ADS" )
   end if

   if lCdx()
      Return ( FullCurDir() + "ADS\" )
   end if

Return ( FullCurDir() + "ADS\" )

//----------------------------------------------------------------------------//

Function cPatEmpTmp( lShort )

   DEFAULT lShort  := .f.

   if lAds()
      Return ( cAdsUNC() + "EmpTmp\" )
   end if

Return ( if( !lShort, FullCurDir(), "" ) + "EmpTmp\" )

//----------------------------------------------------------------------------//

Function cPatEmpOld( cCodEmp )

   if lAds()
      Return ( cAdsUNC() + "Emp" + cCodEmp + "\" )
   end if

Return ( FullCurDir() + "Emp" + cCodEmp + "\" )

//----------------------------------------------------------------------------//

Function cPatGrpOld( cCodGrp )

   if lAds()
      Return ( cAdsUNC() + "Emp" + cCodGrp + "\" )
   end if

Return ( FullCurDir() + "Emp" + cCodGrp + "\" )

//----------------------------------------------------------------------------//

Function cPatTmp()

   if Empty( cPatTmp )

      cPatTmp     := GetEnv( 'TEMP' )

      if Empty( cPatTmp )
         cPatTmp  := GetEnv( 'TMP' )
      endif

      if Empty( cPatTmp ) .or. ! lIsDir( cPatTmp )
         cPatTmp  := GetWinDir()
      endif

      cPatTmp     += If( Right( cPatTmp, 1 ) == '\', '', '\' ) + 'Apolo'

      if !lIsDir( cPatTmp )
         MakeDir( cPatTmp )
      endif

      if Right( cPatTmp, 1 ) != '\'
         cPatTmp  += '\'
      end if

   end if

Return ( cPatTmp )

//----------------------------------------------------------------------------//

Function cPatIn( lShort )

   DEFAULT lShort  := .f.

Return ( if( !lShort, FullCurDir(), "" ) + "In\" )

//---------------------------------------------------------------------------//

Function cPatInFrq( lShort )

   DEFAULT lShort  := .f.

Return ( if( !lShort, FullCurDir(), "" ) + "InFrq\" )

//---------------------------------------------------------------------------//

Function cPatScript( lShort )

   DEFAULT lShort  := .f.

Return ( if( !lShort, FullCurDir(), "" ) + "Script\" )

//----------------------------------------------------------------------------//

Function cPatOut( lShort )

   DEFAULT lShort  := .f.

Return ( if( !lShort, FullCurDir(), "" ) + "Out\" )

//----------------------------------------------------------------------------//

Function cPatSafe( lShort )

   DEFAULT lShort  := .f.

Return ( if( !lShort, FullCurDir(), "" ) + "Safe\" )

//----------------------------------------------------------------------------//

Function cPatBmp( lShort )

   DEFAULT lShort  := .f.

Return ( if( !lShort, FullCurDir(), "" ) + "Bmp\" )

//----------------------------------------------------------------------------//

Function cPatPsion( lShort )

   DEFAULT lShort  := .f.

Return ( if( !lShort, FullCurDir(), "" ) + "Psion\" )

//----------------------------------------------------------------------------//

Function cPatHtml( lShort )

   DEFAULT lShort  := .f.

Return ( if( !lShort, FullCurDir(), "" ) + "Html\" )

//----------------------------------------------------------------------------//

Function cPatXml( lShort )

   DEFAULT lShort  := .f.

Return ( if( !lShort, FullCurDir(), "" ) + "Xml\" )

//----------------------------------------------------------------------------//

FUNCTION PicIn()

   if Empty( cDefPicIn )
      cDefPicIn   := cPirDiv( cDivEmp() )
   end if

RETURN ( cDefPicIn )

//---------------------------------------------------------------------------//

Function cPatReport( lShort )

   DEFAULT lShort  := .f.

Return ( if( !lShort, FullCurDir(), "" ) + "Reports\" )

//----------------------------------------------------------------------------//

function by( uVal )

   local uRet     := uVal

return ( uRet )

//---------------------------------------------------------------------------//

Function nHndCaj( nHnd )

   if nHnd != nil
      nHndCaj  := nHnd
   end if

Return nHndCaj

//---------------------------------------------------------------------------//

Function SelSysDate( oMenuItem )

   DEFAULT oMenuItem := "01084"

   if dSysDate == nil
      dSysDate       := Date()
   end if

   /*
   Obtenemos el nivel de acceso
   */

   if nAnd( nLevelUsr( oMenuItem ), 1 ) != 0
      msgStop( "Acceso no permitido." )
   else
      dSysDate       := Calendario( dSysDate, "Fecha de trabajo" )
   end if

Return ( dSysDate )

//----------------------------------------------------------------------------//

function ExcMnuNext( cName )

   local nPos

   if cName == nil
      nPos  := len( aMnuNext )
   else
      nPos  := aScan( aMnuNext, {|c| c[1] == cName } )
   end if

   if nPos != 0

      Eval( aMnuNext[ nPos, 2 ] )

      // Pasamos la accion a menu atras

      addMnuPrev( aMnuNext[ nPos, 1 ], aMnuNext[ nPos, 2 ] )

      // Eliminamos la accion

      aDel( aMnuNext, nPos )
      aSize( aMnuNext, len( aMnuNext ) - 1 )

   end if

return .t.

//---------------------------------------------------------------------------//

function MnuNext( oBtn, oWnd )

   local n
   local cText
   local oMenu
   local bAction

   DEFAULT oWnd   := oWnd()

   oMenu := MenuBegin( .T. )

   for n := 1 to len( aMnuNext )

      cText    := by( aMnuNext[ n, 1 ] )
      bAction  := bMnuNext( cText )

      MenuAddItem( cText,, .F.,, bAction,,,,,,, .F.,,, .F. )

   next

   MenuEnd()

   oMenu:Activate( 0, oBtn:nRight, oBtn )

RETURN NIL

//---------------------------------------------------------------------------//

function addMnuPrev( cName, uAction )

   if aScan( aMnuPrev, {|c| c[1] == cName } ) == 0
      if valtype( uAction ) == "C"
         aAdd( aMnuPrev, { cName, &( "{||" + uAction + "() }" ) } )
      else
         aAdd( aMnuPrev, { cName, uAction } )
      end if
   end if

return nil

//---------------------------------------------------------------------------//

function ExcMnuPrev( cName )

   local nPos

   if cName == nil
      nPos  := len( aMnuPrev )
   else
      nPos  := aScan( aMnuPrev, {|c| c[1] == cName } )
   end if

   if nPos != 0

      Eval( aMnuPrev[ nPos, 2 ] )

      // Pasamos la accion a menu atras

      addMnuNext( aMnuPrev[ nPos, 1 ], aMnuPrev[ nPos, 2 ] )

      // Eliminamos la accion

      aDel( aMnuPrev, nPos )
      aSize( aMnuPrev, len( aMnuPrev ) - 1 )

   end if

return .t.

//---------------------------------------------------------------------------//

Function MnuPrev( oBtn, oWnd )

   local n
   local cText
   local oMenu
   local bAction

   DEFAULT oWnd   := oWnd()

   oMenu := MenuBegin( .T. )

   for n := 1 to len( aMnuPrev )

      cText    := by( aMnuPrev[ n, 1 ] )
      bAction  := bMnuPrev( cText )

      MenuAddItem( cText,, .F.,, bAction,,,,,,, .F.,,, .F. )

   next

   MenuEnd()

   oMenu:Activate( oBtn:nBottom - 1, 0, oBtn )

Return nil

//---------------------------------------------------------------------------//

static function bMnuPrev( uValue )
return {|| ExcMnuPrev( uValue ) }

//---------------------------------------------------------------------------//

static function bMnuNext( uValue )
return {|| ExcMnuNext( uValue ) }

//---------------------------------------------------------------------------//

function Visor( aMsg )

   local oDlg
   local oBrwCon
   //local hBmp     := LoadBitmap( GetResources(), "BSTOP" )

   if len( aMsg ) == 0
      return .f.
   end if


   DEFINE DIALOG oDlg RESOURCE "VISOR"

   oBrwCon                        := IXBrowse():New( oDlg )

   oBrwCon:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrwCon:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   oBrwCon:SetArray( aMsg, , , .f. )

   oBrwCon:nMarqueeStyle          := 5
   oBrwCon:lRecordSelector        := .f.
   oBrwCon:lHScroll               := .f.
   oBrwCon:lHeader                := .f.

   oBrwCon:CreateFromResource( 100 )

   with object ( oBrwCon:AddCol() )
      :cHeader          := Space(1)
      :bStrData         := {|| Space(1) }
      :bEditValue       := {|| aMsg[ oBrwCon:nArrayAt, 1 ] }
      :nWidth           := 20
      :SetCheck( { "Cnt16", "Nil16" } )
   end with

   with object ( oBrwCon:AddCol() )
      :cHeader          := Space(1)
      :bStrData         := {|| aMsg[ oBrwCon:nArrayAt, 2 ] }
      :nWidth           := 300
   end with

   REDEFINE BUTTON ;
      ID       IDOK ;
		OF 		oDlg ;
      ACTION   ( oDlg:end() )

	ACTIVATE DIALOG oDlg CENTER

RETURN NIL

//------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

FUNCTION aItmVentas()

   local aItmVta := {}

   aAdd( aItmVta, { { "CSERALB",    "CSERIE",      "CSERIE",      "CSERTIK" }, { "C", "C", "C", "C" },   1, 0, "Serie del documento" } )
   aAdd( aItmVta, { { "NNUMALB",    "NNUMFAC",     "NNUMFAC",     "CNUMTIK" }, { "N", "N", "N", "C" },   9, 0, "Número del documento" } )
   aAdd( aItmVta, { { "CSUFALB",    "CSUFFAC",     "CSUFFAC",     "CSUFTIK" }, { "C", "C", "C", "C" },   2, 0, "Sufijo del documento" } )
   aAdd( aItmVta, { { "CTURALB",    "CTURFAC",     "CTURFAC",     "CTURTIK" }, { "C", "C", "C", "C" },   6, 0, "Sesión del documento" } )
   aAdd( aItmVta, { { "DFECALB",    "DFECFAC",     "DFECFAC",     "DFECTIK" }, { "D", "D", "D", "D" },   8, 0, "Fecha del documento" } )
   aAdd( aItmVta, { { "CCODCLI",    "CCODCLI",     "CCODCLI",     "CCLITIK" }, { "C", "C", "C", "C" },  12, 0, "Código del cliente" } )
   aAdd( aItmVta, { { "CNOMCLI",    "CNOMCLI",     "CNOMCLI",     "CNOMTIK" }, { "C", "C", "C", "C" },  80, 0, "Nombre del cliente" } )
   aAdd( aItmVta, { { "CDIRCLI",    "CDIRCLI",     "CDIRCLI",     "CDIRCLI" }, { "C", "C", "C", "C" }, 100, 0, "Domicilio del cliente" } )
   aAdd( aItmVta, { { "CPOBCLI",    "CPOBCLI",     "CPOBCLI",     "CPOBCLI" }, { "C", "C", "C", "C" },  35, 0, "Población del cliente" } )
   aAdd( aItmVta, { { "CPRVCLI",    "CPRVCLI",     "CPRVCLI",     "CPRVCLI" }, { "C", "C", "C", "C" },  20, 0, "Provincia del cliente" } )
   aAdd( aItmVta, { { "CPOSCLI",    "CPOSCLI",     "CPOSCLI",     "CPOSCLI" }, { "C", "C", "C", "C" },  15, 0, "Código postal del cliente" } )
   aAdd( aItmVta, { { "CDNICLI",    "CDNICLI",     "CDNICLI",     "CDNICLI" }, { "C", "C", "C", "C" },  15, 0, "DNI/CIF del cliente" } )
   aAdd( aItmVta, { { "CCODALM",    "CCODALM",     "CCODALM",     "CALMTIK" }, { "C", "C", "C", "C" },   3, 0, "Código del almacén" } )
   aAdd( aItmVta, { { "CCODCAJ",    "CCODCAJ",     "CCODCAJ",     "CNCJTIK" }, { "C", "C", "C", "C" },   3, 0, "Código de la caja" } )
   aAdd( aItmVta, { { "CCODPAGO",   "CCODPAGO",    "CCODPAGO",    "CFPGTIK" }, { "C", "C", "C", "C" },   2, 0, "Forma de pago del documento" } )
   aAdd( aItmVta, { { "CCODOBR",    "CCODOBR",     "CCODOBR",     "CCODOBR" }, { "C", "C", "C", "C" },  10, 0, "Obra del documento" } )
   aAdd( aItmVta, { { "CCODTAR",    "CCODTAR",     "CCODTAR",     "CCODTAR" }, { "C", "C", "C", "C" },   5, 0, "Código de la tarifa" } )
   aAdd( aItmVta, { { "CCODRUT",    "CCODRUT",     "CCODRUT",     "CCODRUT" }, { "C", "C", "C", "C" },   4, 0, "Código de la ruta" } )
   aAdd( aItmVta, { { "CCODAGE",    "CCODAGE",     "CCODAGE",     "CCODAGE" }, { "C", "C", "C", "C" },   3, 0, "Código del agente" } )
   aAdd( aItmVta, { { "NPCTCOMAGE", "NPCTCOMAGE",  "NPCTCOMAGE",  "NCOMAGE" }, { "N", "N", "N", "" },    6, 2, "Comisión agente" } )
   aAdd( aItmVta, { { "NTARIFA",    "NTARIFA",     "NTARIFA",     "NTARIFA" }, { "N", "N", "N", "N" },   1, 0, "Tarifa del documento" } )
   aAdd( aItmVta, { { "NDTOESP",    "NDTOESP",     "NDTOESP",     "" },        { "N", "N", "N", "" },    6, 2, "Descuento general" } )
   aAdd( aItmVta, { { "NDPP",       "NDPP",        "NDPP",        "" },        { "N", "N", "N", "" },    6, 2, "Descuento por pronto pago" } )
   aAdd( aItmVta, { { "NDTOUNO",    "NDTOUNO",     "NDTOUNO",     "" },        { "N", "N", "N", "" },    6, 2, "Descuento definido 1" } )
   aAdd( aItmVta, { { "NDTODOS",    "NDTODOS",     "NDTODOS",     "" },        { "N", "N", "N", "" },    4, 1, "Descuento definido 2" } )
   aAdd( aItmVta, { { "LRECARGO",   "LRECARGO",    "LRECARGO",    "" },        { "L", "L", "L", "" },    1, 0, "Lógico de recargo" } )
   aAdd( aItmVta, { { "CDIVALB",    "CDIVFAC",     "CDIVFAC",     "CDIVTIK" }, { "C", "C", "C", "C" },   3, 0, "Código divisa" } )
   aAdd( aItmVta, { { "NVDVALB",    "NVDVFAC",     "NVDVFAC",     "NVDVTIK" }, { "N", "N", "N", "N" },  10, 4, "Valor divisa" } )
   aAdd( aItmVta, { { "CRETPOR",    "CRETPOR",     "CRETPOR",     "CRETPOR" }, { "C", "C", "C", "C" }, 100, 0, "Retirado por" } )
   aAdd( aItmVta, { { "CRETMAT",    "CRETMAT",     "CRETMAT",     "CRETMAT" }, { "C", "C", "C", "C" },  20, 0, "Matricula" } )
   aAdd( aItmVta, { { "LIVAINC",    "LIVAINC",     "LIVAINC",     "" },        { "L", "L", "L", "" },    1, 0, "Lógico impuestos incluido" } )
   aAdd( aItmVta, { { "NREGIVA",    "NREGIVA",     "NREGIVA",     "" },        { "N", "N", "N", "" },   20, 0, "Régimen de " + cImp() } )
   aAdd( aItmVta, { { "CCODTRN",    "CCODTRN",     "CCODTRN",     "" },        { "C", "C", "C", "" },    9, 0, "Código del transportista" } )
   aAdd( aItmVta, { { "CCODUSR",    "CCODUSR",     "CCODUSR",     "CCCJTIK" }, { "C", "C", "C", "C" },   3, 0, "Código de usuario" } )
   aAdd( aItmVta, { { "DFECCRE",    "DFECCRE",     "DFECCRE",     "DFECCRE" }, { "D", "D", "D", "D" },   8, 0, "Fecha de creación/modificación" } )
   aAdd( aItmVta, { { "CTIMCRE",    "CTIMCRE",     "CTIMCRE",     "CTIMCRE" }, { "C", "C", "C", "C" },  20, 0, "Hora de creación/modificación" } )
   aAdd( aItmVta, { { "CCODGRP",    "CCODGRP",     "CCODGRP",     ""        }, { "C", "C", "C", "" },    4, 0, "Grupo de cliente" } )
   aAdd( aItmVta, { { "lImprimido", "lImprimido",  "lImprimido",  ""        }, { "L", "L", "L", "" },    1, 0, "Lógico de imprimido" } )
   aAdd( aItmVta, { { "dFecImp",    "dFecImp",     "dFecImp",     ""        }, { "D", "D", "D", "" },    8, 0, "Fecha última impresión" } )
   aAdd( aItmVta, { { "cHorImp",    "cHorImp",     "cHorImp",     ""        }, { "C", "C", "C", "" },    5, 0, "Hora última impresión" } )
   aAdd( aItmVta, { { "cCodDlg",    "cCodDlg",     "cCodDlg",     "cCodDlg" }, { "C", "C", "C", "C" },   2, 0, "Código delegación" } )

RETURN ( aItmVta )

//----------------------------------------------------------------------------//

FUNCTION aItmCompras()

   local aItmCom := {}

   aAdd( aItmCom, { { "CSERALB",    "CSERFAC"   }, { "C", "C" },  1, 0, "Serie del documento" } )
   aAdd( aItmCom, { { "NNUMALB",    "NNUMFAC"   }, { "N", "N" },  9, 0, "Número del documento" } )
   aAdd( aItmCom, { { "CSUFALB",    "CSUFFAC"   }, { "C", "C" },  2, 0, "Sufijo del documento" } )
   aAdd( aItmCom, { { "CTURALB",    "CTURFAC"   }, { "C", "C" },  6, 0, "Sesión del documento" } )
   aAdd( aItmCom, { { "DFECALB",    "DFECFAC"   }, { "D", "D" },  8, 0, "Fecha del documento" } )
   aAdd( aItmCom, { { "CCODALM",    "CCODALM"   }, { "C", "C" },  3, 0, "Código del almacén" } )
   aAdd( aItmCom, { { "CCODCAJ",    "CCODCAJ"   }, { "C", "C" },  3, 0, "Código de la caja" } )
   aAdd( aItmCom, { { "CCODPRV",    "CCODPRV"   }, { "C", "C" }, 12, 0, "Código del proveedor" } )
   aAdd( aItmCom, { { "CNOMPRV",    "CNOMPRV"   }, { "C", "C" }, 35, 0, "Nombre del proveedor" } )
   aAdd( aItmCom, { { "CDIRPRV",    "CDIRPRV"   }, { "C", "C" }, 35, 0, "Domicilio del proveedor" } )
   aAdd( aItmCom, { { "CPOBPRV",    "CPOBPRV"   }, { "C", "C" }, 25, 0, "Población del proveedor" } )
   aAdd( aItmCom, { { "CPROPRV",    "CPROVPROV" }, { "C", "C" }, 20, 0, "Provincia del proveedor" } )
   aAdd( aItmCom, { { "CPOSPRV",    "CPOSPRV"   }, { "C", "C" },  5, 0, "Código postal del provedor" } )
   aAdd( aItmCom, { { "CDNIPRV",    "CDNIPRV"   }, { "C", "C" }, 30, 0, "DNI/CIF del proveedor" } )
   aAdd( aItmCom, { { "DFECENT",    "DFECENT"   }, { "D", "D" },  8, 0, "Fecha de entrada" } )
   aAdd( aItmCom, { { "CCODPGO",    "CCODPAGO"  }, { "C", "C" },  2, 0, "Forma de pago" } )
   aAdd( aItmCom, { { "NBULTOS",    "NBULTOS"   }, { "N", "N" },  3, 0, "Número de bultos" } )
   aAdd( aItmCom, { { "NPORTES",    "NPORTES"   }, { "N", "N" },  6, 0, "Valor de los portes" } )
   aAdd( aItmCom, { { "NDTOESP",    "NDTOESP"   }, { "N", "N" },  6, 2, "Descuento general" } )
   aAdd( aItmCom, { { "NDPP",       "NDPP"      }, { "N", "N" },  6, 2, "Descuento por pronto pago" } )
   aAdd( aItmCom, { { "LRECARGO",   "LRECARGO"  }, { "L", "L" },  1, 0, "Lógico de recargo" } )
   aAdd( aItmCom, { { "CCONDENT",   "CCONDENT"  }, { "C", "C" }, 20, 0, "Condición de entrada" } )
   aAdd( aItmCom, { { "CEXPED",     "CEXPED"    }, { "C", "C" }, 20, 0, "Expedición" } )
   aAdd( aItmCom, { { "COBSERV",    "COBSERV"   }, { "M", "M" }, 10, 0, "Observaciones" } )
   aAdd( aItmCom, { { "CDIVALB",    "CDIVFAC"   }, { "C", "C" },  3, 0, "Código de la divisa" } )
   aAdd( aItmCom, { { "NVDVALB",    "NVDVFAC"   }, { "N", "N" }, 10, 4, "Valor de la divisa" } )
   aAdd( aItmCom, { { "NDTOUNO",    "NDTOUNO"   }, { "N", "N" },  5, 2, "Descuento definido 1" } )
   aAdd( aItmCom, { { "NDTODOS",    "NDTODOS"   }, { "N", "N" },  5, 2, "Descuento definido 2" } )
   aAdd( aItmCom, { { "CCODUSR",    "CCODUSR"   }, { "C", "C" },  3, 0, "Código de usuario" } )
   aAdd( aItmCom, { { "LIMPRIMIDO", "LIMPRIMIDO"}, { "L", "L" },  1, 0, "Lógico de imprimido" } )
   aAdd( aItmCom, { { "DFECIMP",    "DFECIMP"   }, { "D", "D" },  8, 0, "Fecha de última impresión" } )
   aAdd( aItmCom, { { "CHORIMP",    "CHORIMP"   }, { "C", "C" },  5, 0, "Hora última impresión" } )
   aAdd( aItmCom, { { "DFECCHG",    "DFECCHG"   }, { "D", "D" },  8, 0, "Fecha creación/modificación" } )
   aAdd( aItmCom, { { "CTIMCHG",    "CTIMCHG"   }, { "C", "C" },  5, 0, "Hora creación/modificación" } )
   aAdd( aItmCom, { { "CCODDLG",    "CCODDLG"   }, { "C", "C" },  2, 0, "Código de la delegación" } )

RETURN ( aItmCom )

//----------------------------------------------------------------------------//

Function aEmpresa( cEmp, dbfEmp, dbfDlg, dbfUser, lRptGal )

   local cDlg
   local oBlock
   local oError
   local lEmpFnd     := .t.
   local lCloDlg     := .f.
   local lCloEmp     := .f.
   local lCloUsr     := .f.

   DEFAULT lRptGal   := .f.

   cDlg              := oUser():cDelegacion()
   aDlgEmp           := {}

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if dbfEmp == nil
      USE ( cPatDat() + "EMPRESA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "EMPRESA", @dbfEmp ) )
      SET ADSINDEX TO ( cPatDat() + "EMPRESA.CDX" ) ADDITIVE
      lCloEmp        := .t.
   end if

   if dbfUser == nil
      USE ( cPatDat() + "USERS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "USERS", @dbfUser ) )
      SET ADSINDEX TO ( cPatDat() + "USERS.CDX" ) ADDITIVE
      lCloUsr        := .t.
   end if

   if dbfDlg == nil
      USE ( cPatDat() + "DELEGA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DELEGA", @dbfDlg ) )
      SET ADSINDEX TO ( cPatDat() + "DELEGA.CDX" ) ADDITIVE
      lCloDlg        := .t.
   end if

   if dbSeekInOrd( cEmp, "CodEmp", dbfEmp )

      aEmpresa       := dbScatter( dbfEmp )

      /*
      Configuraciones desde el usuario-----------------------------------------
      */

      if !lRptGal

         if Empty( oUser():cCaja() )
            oUser():cCaja( cCajUsr( ( dbfEmp )->cDefCaj ) )
         end if

         if Empty( oUser():cAlmacen() )
            oUser():cAlmacen( cAlmUsr( ( dbfEmp )->cDefAlm ) )
         end if

      end if

      /*
      Verificamos la existencia de la delegacion-------------------------------
      */

      if !( dbfDlg )->( dbSeek( cEmp + cDlg ) )
         oUser():cDelegacion()
      end if 

      /*
      Cargamos las delegaciones------------------------------------------------
      */

      if ( dbfDlg )->( dbSeek( cEmp ) )
         while ( dbfDlg )->cCodEmp == cEmp .and. ( dbfDlg )->( !eof() )
            aAdd( aDlgEmp, ( dbfDlg )->cCodDlg )
            ( dbfDlg )->( dbSkip() )
         end while
      else
         aDlgEmp     := { "" }
      end if

      // Cargamos el programa contable-----------------------------------------

      SetAplicacionContable( ( dbfEmp )->nExpContbl )

   else

      lEmpFnd        := .f.

   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lCloDlg
      CLOSE ( dbfDlg )
   end if

   if lCloUsr
      CLOSE ( dbfUser )
   end if

   if lCloEmp
      CLOSE ( dbfEmp )
   end if

RETURN ( lEmpFnd )

//---------------------------------------------------------------------------//

Function SetEmp( uVal, nPos )

   if nPos >= 0 .and. nPos <= len( aEmpresa )
      aEmpresa[ nPos ]  := uVal
   end if

 Return ( aEmpresa )

//---------------------------------------------------------------------------//

Function aRetDlgEmp() ; Return ( aDlgEmp )

//---------------------------------------------------------------------------//

Function cCodigoEmpresaEnUso( cCodEmp )

   if cCodEmp != nil
      cCodigoEmpresaEnUso     := cCodEmp
   end if

Return ( cCodigoEmpresaEnUso )

//---------------------------------------------------------------------------//

Function cCodigoDelegacionEnUso( cCodDlg )

   if cCodDlg != nil
      cCodigoDelegacionEnUso  := cCodDlg
   end if

Return ( cCodigoDelegacionEnUso )

//---------------------------------------------------------------------------//

FUNCTION GetCodEmp( dbfEmp )

   local oBlock
   local oError
   local nRec
   local cCodEmp
   local lClose   := .f.

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   IF dbfEmp == NIL
      USE ( cPatDat() + "EMPRESA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "EMPRESA", @dbfEmp ) )
      SET ADSINDEX TO ( cPatDat() + "EMPRESA.CDX" ) ADDITIVE
      lClose      := .t.
	END IF

   nRec           := ( dbfEmp )->( RecNo() )
   cCodEmp        := ""

   ( dbfEmp )->( dbGoTop() )
   while !( dbfEmp )->( eof() )
      if ( dbfEmp )->lActiva
         cCodEmp  := ( dbfEmp )->CodEmp
      end if
      ( dbfEmp )->( dbSkip() )
   end while

   /*
   Quitamos la empresa actual--------------------------------------------------
   */

   if Empty( cCodEmp )
      ( dbfEmp )->( dbGoTop() )
      cCodEmp     := ( dbfEmp )->CodEmp
   end if

   ( dbfEmp )->( dbGoTo( nRec ) )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClose
      CLOSE ( dbfEmp )
   end if

Return ( cCodEmp )

//---------------------------------------------------------------------------//
/*
Funciones para crear las bases de datos de los favoritos de la galeria de
informenes; lo metemos aqui para que pueda actualizar ficheros
*/

Function mkReport( cPath, lAppend, cPathOld, oMeter )

   DEFAULT lAppend      := .f.

   IF oMeter != NIL
		oMeter:cText		:= "Generando Bases"
      sysRefresh()
	END IF

   CreateDbfReport( cPath )
   
   rxReport( cPath, oMeter )

   if lAppend .and. lIsDir( cPathOld )
      AppDbf( cPathOld, cPath, "CfgCar" )
   end if

   if lAppend .and. lIsDir( cPathOld )
      AppDbf( cPathOld, cPath, "CfgFav" )
   end if

Return .t.

//---------------------------------------------------------------------------//

Function rxReport( cPath, oMeter )

   local dbfFolder
   local dbfFavorito

   DEFAULT cPath  := cPatEmp()

   if !lExistTable( cPath + "CfgCar.Dbf" ) .or.;
      !lExistTable( cPath + "CfgFav.Dbf" )

      CreateDbfReport( cPath )

   end if

   fEraseIndex( cPath + "CFGCAR.CDX" )

   dbUseArea( .t., cDriver(), cPath + "CFGCAR.DBF", cCheckArea( "CFGCAR", @dbfFolder ), .f. )
   if !( dbfFolder )->( neterr() )
      ( dbfFolder )->( __dbPack() )

      ( dbfFolder )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfFolder )->( ordCreate( cPath + "CFGCAR.CDX", "CUSRNOM", "CCODUSR + CNOMBRE", {|| Field->CCODUSR + Field->CNOMBRE } ) )

      ( dbfFolder )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de configuraciones" )

   end if

   fEraseIndex( cPath + "CFGFAV.CDX" )

   dbUseArea( .t., cDriver(), cPath + "CFGFAV.DBF", cCheckArea( "CFGFAV", @dbfFavorito ), .f. )
   if !( dbfFavorito )->( neterr() )
      ( dbfFavorito )->( __dbPack() )

      ( dbfFavorito )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfFavorito )->( ordCreate( cPath + "CFGFAV.CDX", "CUSRFAV", "CCODUSR + CNOMFAV", {|| Field->CCODUSR + Field->CNOMFAV } ) )

      ( dbfFavorito )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfFavorito )->( ordCreate( cPath + "CFGFAV.CDX", "CUSRCAR", "CCODUSR + CCARPETA", {|| Field->CCODUSR + Field->CCARPETA } ) )

      ( dbfFavorito )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfFavorito )->( ordCreate( cPath + "CFGFAV.CDX", "CUSRRPT", "CCODUSR + CCARPETA + CNOMRPT", {|| Field->CCODUSR + Field->CCARPETA + Field->CNOMRPT } ) )

      ( dbfFavorito )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfFavorito )->( ordCreate( cPath + "CFGFAV.CDX", "CUSRCARFAV", "CCODUSR + CCARPETA + CNOMFAV", {|| Field->CCODUSR + Field->CCARPETA + Field->CNOMFAV } ) )

      ( dbfFavorito )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de configuraciones" )

   end if

Return nil

//---------------------------------------------------------------------------//

Function CreateDbfReport( cPath )

   DEFAULT cPath  := cPatEmp()

   if !lExistTable( cPath + "CFGCAR.DBF" )
      dbCreate( cPath + "CFGCAR.DBF", aSqlStruct( aItmDbfReport() ), cDriver() )
   end if

   if !lExistTable( cPath + "CFGFAV.DBF" )
      dbCreate( cPath + "CFGFAV.DBF", aSqlStruct( aItmDbfFavoritos() ), cDriver() )
   end if

Return nil

//---------------------------------------------------------------------------//

Function aItmDbfReport()

   local aBase := {}

   aAdd( aBase, { "cCodUsr",  "C",   3, 0, "Código de usuario" } )
   aAdd( aBase, { "cNombre",  "C", 100, 0, "Nombre de la carpeta" } )

Return ( aBase )

//---------------------------------------------------------------------------//

Function aItmDbfFavoritos()

   local aBase := {}

   aAdd( aBase, { "cCodUsr",  "C",   3, 0, "Código de usuario" } )
   aAdd( aBase, { "cCarpeta", "C", 100, 0, "Nombre de la carpeta" } )
   aAdd( aBase, { "cNomFav",  "C", 100, 0, "Descripción para favoritos" } )
   aAdd( aBase, { "cNomRpt",  "C", 100, 0, "Descripción original" } )

Return ( aBase )

//---------------------------------------------------------------------------//

Function lTactilMode()

Return ( "TACTIL" $ cParamsMain() )

//---------------------------------------------------------------------------//

Function lTpvMode()

Return ( "TPV" $ cParamsMain() )

//---------------------------------------------------------------------------//

Function GoogleMaps( cStreetTo, cCityTo, cCountryTo )

   local oDlg
   local oWebMap
   local oActiveX

   local oStreetFrom
   local cStreetFrom
   local oCityFrom
   local cCityFrom
   local oCountryFrom
   local cCountryFrom

   cStreetTo         := Padr( cStreetTo, 200 )
   cCityTo           := Padr( cCityTo, 200 )

   if Empty( cCountryTo )
      cCountryTo     := Padr( "Spain", 100 )
   end if

   cStreetFrom       := Space( 200 )
   cCityFrom         := Space( 200 )
   cCountryFrom      := Space( 100 )

   oWebMap           := WebMap():new()

   DEFINE DIALOG oDlg RESOURCE "GoogleMap"

   REDEFINE ACTIVEX oActiveX  ID 100   OF oDlg  PROGID "Shell.Explorer"

   REDEFINE GET oStreetFrom   VAR cStreetFrom   ON HELP  load( oStreetFrom, oCityFrom, oCountryFrom ) BITMAP "Office_16" ID 200 OF oDlg

   REDEFINE GET oCityFrom     VAR cCityFrom     ID 210   OF oDlg

   REDEFINE GET oCountryFrom  VAR cCountryFrom  ID 220   OF oDlg

   REDEFINE GET cStreetTo     ID 300   OF oDlg

   REDEFINE GET cCityTo       ID 310   OF oDlg

   REDEFINE GET cCountryTo    ID 320   OF oDlg

   REDEFINE BUTTON            ID 1     OF oDlg  ACTION ShowInWin( cStreetFrom, cCityFrom, cCountryFrom, cStreetTo, cCityTo, cCountryTo, oWebMap, oActiveX )

   REDEFINE BUTTON            ID 3     OF oDlg  ACTION ShowInExplorer( cStreetFrom, cCityFrom, cCountryFrom, cStreetTo, cCityTo, cCountryTo, oWebMap, oActiveX )

   ACTIVATE DIALOG oDlg CENTERED       ON INIT  ShowInWin( cStreetFrom, cCityFrom, cCountryFrom, cStreetTo, cCityTo, cCountryTo, oWebMap, oActiveX )

return nil

//---------------------------------------------------------------------------//

static function Load( oStreetFrom, oCityFrom, oCountryFrom )

   oStreetFrom:cText(   Padr( cDomEmp(), 200 ) )
   oCityFrom:cText(     Padr( Rtrim( cPobEmp() ) + Space( 1 ) + Rtrim( cPrvEmp() ), 200 ) )
   oCountryFrom:cText(  Padr( "Spain", 100 ) )

return nil

//---------------------------------------------------------------------------//

static function ShowInWin( cStreetFrom, cCityFrom, cCountryFrom, cStreetTo, cCityTo, cCountryTo, oWebMap, oActiveX )

   oWebMap:aAddress  := {}

   if !Empty( cStreetFrom )
      oWebMap:AddStopSep( cStreetFrom, cCityFrom, , , cCountryFrom )
   end if

   oWebMap:AddStopSep( cStreetTo, cCityTo, , , cCountryTo )

   oWebMap:GenLink()

   if !Empty( oWebMap:cLink )
      oActiveX:Do( "Navigate", oWebMap:cLink )
      sysrefresh()
   end if

return nil

//---------------------------------------------------------------------------//

static function ShowInExplorer( cStreetFrom, cCityFrom, cCountryFrom, cStreetTo, cCityTo, cCountryTo, oWebMap, oActiveX )

   oWebMap:aAddress  := {}

   if !Empty( cStreetFrom )
      oWebMap:AddStopSep( cStreetFrom, cCityFrom, , , cCountryFrom )
   end if

   oWebMap:AddStopSep( cStreetTo, cCityTo, , , cCountryTo )

   oWebMap:ShowMap()

return nil

//---------------------------------------------------------------------------//

Function cUnidadMedicion( cDbf, lParentesis )

   local cUnidad        := ""

   DEFAULT lParentesis  := .f.

   if !Empty( ( cDbf )->nMedUno )
      cUnidad           += AllTrim( Trans( ( cDbf )->nMedUno, MasUnd() ) )
   end if

   if !Empty( ( cDbf )->nMedDos )
      cUnidad           += " x "
      cUnidad           += AllTrim( Trans( ( cDbf )->nMedDos, MasUnd() ) )
   end if

   if !Empty( ( cDbf )->nMedTre )
      cUnidad           += " x "
      cUnidad           += AllTrim( Trans( ( cDbf )->nMedTre, MasUnd() ) )
   end if

   if lParentesis .and. !Empty( cUnidad )
      cUnidad           := "(" + cUnidad + ")"
   end if

Return ( cUnidad )

//---------------------------------------------------------------------------//

Function sErrorBlock( bBlock )

   nError++

   titulo( str( nError ) )
   logwrite( "suma control del errores 1:" + procname(1) + "2:" + procname(2) + str( nError ) )

Return ( ErrorBlock( {| oError | ApoloBreak( oError ) } ) )

Function rErrorBlock( oBlock )

   nError--

   titulo( str( nError ) )
   logwrite( "resta control del errores 1:" + procname(1) + "2:" + procname(2) + str( nError ) )

Return ( ErrorBlock( oBlock ) )

//---------------------------------------------------------------------------//

//---------------------------------------------------------------------------//

FUNCTION AppSql( cEmpDbf, cEmpSql, cFile )

   local oBlock
   local oError
   local dbfOld
	local dbfTmp
   local dbfDbf      := FullCurDir() + cEmpDbf + "\" + cFile + ".Dbf"
   local cdxDbf      := FullCurDir() + cEmpDbf + "\" + cFile + ".Cdx"
   local dbfSql      := cEmpSql + "\" + cFile + ".Dbf"
   local cdxSql      := cEmpSql + "\" + cFile + ".Cdx"

   if !File( dbfDbf )
      Return nil
   end if

   if !lExistTable( dbfSql )
      Return nil
   end if

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      // DBFCDX ------------------------------------------------------------------

      USE ( dbfDbf ) NEW VIA ( cLocalDriver() ) ALIAS ( cCheckArea( "OLD", @dbfOld ) )
      if File( cdxDbf )
         SET ADSINDEX TO ( cdxDbf ) ADDITIVE
      end if

      // SQLRDD ------------------------------------------------------------------

      USE ( dbfSql ) NEW VIA "SQLRDD" ALIAS ( cCheckArea( "TMP", @dbfTmp ) )
      if lExistIndex( cdxSql )
         SET ADSINDEX TO ( cdxSql ) ADDITIVE
      end if

      // Pasamos los datos---------------------------------------------------------

      // APPEND FROM ( dbfDbf ) VIA ( cLocalDriver() )

      while !( dbfOld )->( eof() )
         dbPass( dbfOld, dbfTmp, .t. )
         ( dbfOld )->( dbSkip() )
         sysRefresh()
      end while

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	CLOSE ( dbfOld )
	CLOSE ( dbfTmp )

RETURN NIL

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

Function cSqlTableName( cTableName )

   if cTableName[2] == ":"
      cTableName  := SubStr( cTableName, 3 )
   endif

   cTableName     := StrTran( AllTrim( Lower( cTableName ) ), ".dbf", "_dbf" )
   cTableName     := StrTran( cTableName, ".ntx", "" )
   cTableName     := StrTran( cTableName, ".cdx", "" )
   cTableName     := StrTran( cTableName, "\", "_" )

   if cTableName[1] == "/"
      cTableName  := SubStr( cTableName, 2 )
   endif

   cTableName     := StrTran( cTableName, "/", "_" )
   cTableName     := StrTran( cTableName, ".", "_" )
   cTableName     := AllTrim( cTableName )

   if len( cTableName ) > 30
      cTableName  := SubStr( cTableName, len( cTableName ) - 30 + 1 )
   endif

Return ( cTableName )

//--------------------------------------------------------------------------//

Function PrinterPreferences( oGet )

   PrinterSetup()

   if !Empty( oGet )
      oGet:cText( PrnGetName() )
   end if

Return ( Nil )

//---------------------------------------------------------------------------//

function DateTimeRich( oRTF )

   local aLbx := REGetDateTime()
   local nLbx := 1
   local oDlg, oLbx

   DEFINE DIALOG oDlg RESOURCE "DateRich"

   REDEFINE LISTBOX oLbx VAR nLbx ITEMS aLbx ID 101 OF oDlg

   REDEFINE BUTTON ID 201 ACTION ( oDlg:End( IDOK ) )

   REDEFINE BUTTON ID 202 ACTION ( oDlg:End() )

   oDlg:AddFastKey( VK_F5, {|| oDlg:End( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK
      oRTF:InsertRTF( aLbx[ nLbx ] )
   endif

return nil

//---------------------------------------------------------------------------//

function FindRich( oRTF )

   local oDlg
   local oFind
   local cFind    := Space( 100 )
   local nDir     := 1
   local lCase    := .f.
   local lWord    := .t.

   DEFINE DIALOG oDlg RESOURCE "FindRich"

   REDEFINE GET oFind VAR cFind ID 101 OF oDlg UPDATE

   REDEFINE RADIO nDir ID 102, 103 OF oDlg

   REDEFINE CHECKBOX lCase ID 104 OF oDlg

   REDEFINE CHECKBOX lWord ID 105 OF oDlg

   REDEFINE BUTTON ID 201 ACTION ( oRTF:SetFocus(), oRTF:Find( AllTrim( cFind ), ( nDir == 1 ), lCase, lWord ) )

   REDEFINE BUTTON ID 202 ACTION ( oDlg:End() )

   oDlg:bStart := { || oDlg:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER NOWAIT

return nil

//---------------------------------------------------------------------------//

Function ReportBackLine( oInf, nLines )

   DEFAULT nLines := 1

   if !Empty( oInf )
      oInf:BackLine( nLines )
   end if

Return ( "" )

//---------------------------------------------------------------------------//

Function SetBrwOpt( cName, cOption )

Return ( WritePProString( "browse", cName, cValToChar( cOption ), cPatEmp() + "Empresa.Ini" ) )

//---------------------------------------------------------------------------//

Function GetBrwOpt( cName )

Return ( GetPvProfInt( "browse", cName, 2, cPatEmp() + "Empresa.Ini" ) )

//---------------------------------------------------------------------------//

Function cPatPc( cPath )

   if !Empty( cPath )
      cPathPC     := cPath
   end if

Return ( cPathPc )

//---------------------------------------------------------------------------//

Function cEmpUsr( cEmp )

   if cEmp != nil
      cEmpUsr  := cEmp
   end if

Return cEmpUsr

//---------------------------------------------------------------------------//

function lGrupoEmpresa( cCodEmp, dbfEmpresa )

   local oBlock
   local oError
   local lClose   := .f.
   local lGrupo   := .f.

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( dbfEmpresa )
      USE ( cPatDat() + "EMPRESA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "EMPRESA", @dbfEmpresa ) )
      SET ADSINDEX TO ( cPatDat() + "EMPRESA.CDX" ) ADDITIVE
      lClose      := .t.
   end if

   if dbSeekInOrd( cCodEmp, "CodEmp", dbfEmpresa )
      lGrupo      := ( dbfEmpresa )->lGrupo
   end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClose
      CLOSE ( dbfEmpresa )
   end if

return ( lGrupo )

//---------------------------------------------------------------------------//

function cCodigoGrupo( cCodEmp, dbfEmpresa )

   local nRec
   local oBlock
   local oError
   local lClose   := .f.
   local cGrupo   := ""

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( dbfEmpresa )
      dbUseArea( .t., ( cDriver() ), ( cPatDat() + "Empresa.Dbf" ), ( cCheckArea( "Empresa", @dbfEmpresa ) ), .t. )
      if !lAIS() ; ( dbfEmpresa )->( ordListAdd( ( cPatDat() + "Empresa.Cdx" ) ) ) ; else ; ordSetFocus( 1 ) ; end

      lClose      := .t.
   else
      nRec        := ( dbfEmpresa )->( Recno() )
   end if

   if dbSeekInOrd( cCodEmp, "CodEmp", dbfEmpresa )
      cGrupo      := ( dbfEmpresa )->cCodGrp
   end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

   END SEQUENCE

   ErrorBlock( oBlock )

   if lClose
      CLOSE ( dbfEmpresa )
   else
      ( dbfEmpresa )->( dbGoTo( nRec ) )
   end if

return ( cGrupo )

//---------------------------------------------------------------------------//

Function cItemsToReport( aItems )

   local aItem
   local cString  := ""

   for each aItem in aItems
      if !Empty( aItem[ 5 ] )
         cString  += aItem[ 1 ] + "=" + aItem[ 5 ] + ";"
      end if
   next

Return ( cString )

//---------------------------------------------------------------------------//

FUNCTION cObjectsToReport( oDbf )

   local oItem
   local cString  := ""

   for each oItem in oDbf:aTField

      if !Empty( oItem:cComment ) .and. !( oItem:lCalculate )
         cString  += oItem:cName + "=" + oItem:cComment + ";"
      end if

   next

Return ( cString )

//---------------------------------------------------------------------------//

FUNCTION aEmpGrp( cCodGrp, dbfEmp, lEmpresa )

   local nRec
   local nOrd
   local lClose            := .f.

   DEFAULT lEmpresa        := .f.

   if !Empty( cCodGrp )

      if Empty( dbfEmp )

         USE ( cPatDat() + "EMPRESA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "EMPRESA", @dbfEmp ) )
         SET ADSINDEX TO ( cPatDat() + "EMPRESA.CDX" ) ADDITIVE

         ( dbfEmp )->( OrdSetFocus( "cCodGrp" ) )

         lClose            := .t.

      else

         nOrd              := ( dbfEmp )->( OrdSetFocus( "cCodGrp" ) )
         nRec              := ( dbfEmp )->( Recno() )

      end if

      aEmpresasGrupo       := {}

      if lEmpresa

         aAdd( aEmpresasGrupo, cCodGrp )

      else

         if ( dbfEmp )->( dbSeek( cCodGrp ) )

            while ( dbfEmp )->cCodGrp == cCodGrp .and. !( dbfEmp )->( Eof() )

               aAdd( aEmpresasGrupo, ( dbfEmp )->CodEmp )

               ( dbfEmp )->( dbSkip() )

            end while

         end if

      end if

      if lClose

         CLOSE( dbfEmp )

      else

         ( dbfEmp )->( OrdSetFocus( nOrd ) )
         ( dbfEmp )->( dbGoTo( nRec ) )

      end if

   end if

Return ( aEmpresasGrupo )

//----------------------------------------------------------------------------//

FUNCTION cPatStk( cPath, lPath, lShort, lGrp )

   DEFAULT lPath  := .t.
   DEFAULT lShort := .f.
   DEFAULT lGrp   := .f.

   if lAds()
      Return ( cAdsUNC() + if( lGrp, "Emp", "Emp" ) + cPath + if( lPath, "\", "" ) )
   end if

Return ( if( !lShort, FullCurDir(), "" ) + if( lGrp, "Emp", "Emp" ) + cPath + if( lPath, "\", "" ) )

//---------------------------------------------------------------------------//
/*
Devuelve la descripción de una line de factura
*/

FUNCTION Descrip( cFacCliL, cFacCliS )

   local nOrd
   local cKey
   local cReturn     := ""

   if !Empty( ( cFacCliL )->cDetalle )
      cReturn        := Rtrim( ( cFacCliL )->cDetalle )
   else
      cReturn        := Rtrim( ( cFacCliL )->mLngDes )
   end if

   if !Empty( cFacCliS )

      nOrd           := ( cFacCliL )->( OrdSetFocus( 1 ) )
      cKey           := ( cFacCliL )->( OrdKeyVal() ) + Str( ( cFacCliL )->nNumLin, 4 )

      cReturn        += SerialDescrip( cKey, cFacCliS )

      ( cFacCliL )->( OrdSetFocus( nOrd ) )

   end if

RETURN ( cReturn )

//---------------------------------------------------------------------------//

Function SerialDescrip( cKey, cFacCliS )

   local nOrd
   local nInc
   local nLast
   local cLast
   local nPrior
   local cPrior
   local cReturn           := ""

   nInc                    := 0
   nOrd                    := ( cFacCliS )->( OrdSetFocus( 1 ) )

   if ( cFacCliS )->( dbSeek( cKey ) )

      while ( ( cFacCliS )->( ordKeyVal() ) == cKey .and. !( cFacCliS )->( eof() ) )

         if Empty( nPrior )
            nInc           := 0
            cPrior         := ( cFacCliS )->cNumSer
            nPrior         := SpecialVal( ( cFacCliS )->cNumSer )
         else
            nInc++
         end if

         if !Empty( nPrior ) .and. ( nInc != 0 )

            if ( SpecialVal( ( cFacCliS )->cNumSer ) == nPrior + nInc )

               cLast       := ( cFacCliS )->cNumSer
               nLast       := SpecialVal( ( cFacCliS )->cNumSer )

            else

               cReturn     += Alltrim( cPrior )    // cReturn     += Alltrim( Str( nPrior ) )

               if !Empty( nLast )
                  cReturn  += "-"
                  cReturn  += Alltrim( cLast )     // Alltrim( Str( nLast ) )
               end if

               cReturn     += ","

               nInc        := 0
               nLast       := nil
               cPrior      := ( cFacCliS )->cNumSer
               nPrior      := SpecialVal( ( cFacCliS )->cNumSer )

            end if

         end if

         ( cFacCliS )->( dbSkip() )

      end while

      if !Empty( nPrior )
         cReturn           += Alltrim( cPrior )    // Alltrim( Str( nPrior ) )
      end if

      if !Empty( nLast )
         cReturn           += "-"
         cReturn           += Alltrim( cLast )     // Alltrim( Str( nLast ) )
      end if

      cReturn              := Space( 1 ) + "[" + cReturn + "]"

   end if

   ( cFacCliS )->( OrdSetFocus( nOrd ) )

Return ( cReturn )

//---------------------------------------------------------------------------//

FUNCTION AppDbf( cEmpOld, cEmpTmp, cFile, aStruct )

   local oBlock
   local oError
   local dbfOld
	local dbfTmp
   local dbfNamOld   := cEmpOld + cFile + ".Dbf"
   local dbfNamTmp   := cEmpTmp + cFile + ".Dbf"
   local cdxNamOld   := cEmpOld + cFile + ".Cdx"
   local cdxNamTmp   := cEmpTmp + cFile + ".Cdx"

   IF !File( dbfNamOld )
      MsgStop( "No existe : " + dbfNamOld )
      RETURN NIL
	END IF

   IF !File( dbfNamTmp )
      MsgStop( "No existe : " + dbfNamTmp )
      RETURN NIL
	END IF

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( dbfNamOld ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "OLD", @dbfOld ) ) EXCLUSIVE
   if File( cdxNamOld )
      SET ADSINDEX TO ( cdxNamOld ) ADDITIVE
   end if

   USE ( dbfNamTmp ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "TMP", @dbfTmp ) ) EXCLUSIVE
   if File( cdxNamTmp )
      SET ADSINDEX TO ( cdxNamTmp ) ADDITIVE
   end if

   if !Empty( aStruct )

      while !( dbfOld )->( eof() )
         dbAppendDefault( dbfOld, dbfTmp, aStruct )
         ( dbfOld )->( dbSkip() )
      end while

   else

      while !( dbfOld )->( eof() )
         dbPass( dbfOld, dbfTmp, .t. )
         ( dbfOld )->( dbSkip() )
      end while

   end if

   RECOVER USING oError

      msgStop( "Error en el trasbase de registros " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	CLOSE ( dbfOld )
	CLOSE ( dbfTmp )

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION cPatGrp( cPath, lFull, lEmpresa )

   DEFAULT lFull     := .f.
   DEFAULT lEmpresa  := .t.

   if !Empty( cPath )
      cPatGrp        := "Emp" + cPath
   end if

   if lAds()
      Return ( cAdsUNC() + cPatGrp + "\" )
   end if

   if lAIS() .and. lFull
      Return ( cAdsUNC() + cPatGrp + "\" )
   end if

   if lAIS() .and. !lFull
      Return ( cPatGrp )
   end if

   if lCdx()
      Return ( FullCurDir() + cPatGrp + "\" )
   end if

Return ( if( lFull, FullCurDir(), "" ) + cPatGrp + "\" )

//---------------------------------------------------------------------------//

FUNCTION cPatCli( cPath, lFull, lEmpresa )

   DEFAULT lFull     := .f.
   DEFAULT lEmpresa  := .t.

   if !Empty( cPath )
      if lEmpresa
         cPatCli     := "Emp" + cPath
      else
         cPatCli     := "Emp" + cPath
      end if
   end if

   if lAds()
      Return ( cAdsUNC() + cPatCli + "\" )
   end if

   if lAIS() .and. lFull
      Return ( cAdsUNC() + cPatCli + "\" )
   end if

   if lAIS() .and. !lFull
      Return ( cPatCli )
   end if

   if lCdx()
      Return ( FullCurDir() + cPatCli + "\" )
   end if

Return ( if( lFull, FullCurDir(), "" ) + cPatCli + "\" )

//---------------------------------------------------------------------------//

FUNCTION cPatArt( cPath, lFull, lEmpresa )

   DEFAULT lFull     := .f.
   DEFAULT lEmpresa  := .t.

   if !Empty( cPath )

      if lEmpresa
         cPatArt     := "Emp" + cPath
      else
         cPatArt     := "Emp" + cPath
      end if

   end if

   if lAds()
      Return ( cAdsUNC() + cPatArt + "\" )
   end if

   if lAIS() .and. lFull
      Return ( cAdsUNC() + cPatArt + "\" )
   end if

   if lAIS() .and. !lFull
      Return ( cPatArt )
   end if

   if lCdx()
      Return ( FullCurDir() + cPatArt + "\" )
   end if

Return ( if( lFull, FullCurDir(), "" ) + cPatArt + "\" )

//---------------------------------------------------------------------------//

#ifndef __PDA__

FUNCTION cPatPrv( cPath, lFull, lEmpresa )

   DEFAULT lFull     := .f.
   DEFAULT lEmpresa  := .t.

   if !Empty( cPath )

      if lEmpresa
         cPatPrv     := "Emp" + cPath
      else
         cPatPrv     := "Emp" + cPath
      end if

   end if

   if lAds()
      Return ( cAdsUNC() + cPatPrv + "\" )
   end if

   if lAIS() .and. lFull
      Return ( cAdsUNC() + cPatPrv + "\" )
   end if

   if lAIS() .and. !lFull
      Return ( cPatPrv )
   end if

   if lCdx()
      Return ( FullCurDir() + cPatPrv + "\" )
   end if

   Return ( if( !lFull, FullCurDir(), "" ) + cPatPrv + "\" )

//---------------------------------------------------------------------------//

FUNCTION cPatAlm( cPath, lFull, lEmpresa )

   DEFAULT lFull     := .f.
   DEFAULT lEmpresa  := .t.

   if !Empty( cPath )

      if lEmpresa
         cPatAlm     := "Emp" + cPath
      else
         cPatAlm     := "Emp" + cPath
      end if

   end if

   if lAds()
      Return ( cAdsUNC() + cPatAlm + "\" )
   end if

   if lAIS() .and. lFull
      Return ( cAdsUNC() + cPatAlm + "\" )
   end if

   if lAIS() .and. !lFull
      Return ( cPatAlm )
   end if

   if lCdx()
      Return ( FullCurDir() + cPatAlm + "\" )
   end if

Return ( if( lFull, FullCurDir(), "" ) + cPatAlm + "\" )

//---------------------------------------------------------------------------//

Function GetSysDate()

Return ( if( dSysDate != nil, dSysDate, Date() ) )

//---------------------------------------------------------------------------//

Function aEmp() ; Return ( aEmpresa )

//---------------------------------------------------------------------------//

FUNCTION cPatEmp( cPath, lFull )

   DEFAULT cPath  := ""
   DEFAULT lFull  := .f.

   if !Empty( cPath )
      cPatEmp     := "Emp" + cPath
   end if

   if lAds()
      Return ( cAdsUNC() + cPatEmp + "\" )
   end if

   if lAIS() .and. lFull
      Return ( cAdsUNC() + cPatEmp + "\" )
   end if

   if lAIS() .and. !lFull
      Return ( cPatEmp )
   end if

   if lCdx()
      Return ( FullCurDir() + cPatEmp + "\" )
   end if

Return ( if( lFull, FullCurDir(), "" ) + cPatEmp + "\" )

//---------------------------------------------------------------------------//

Function IsMuebles()

Return ( "MUEBLES" $ cParamsMain() )

//---------------------------------------------------------------------------//

FUNCTION ChmHelp( cTema )

RETURN WinExec( ( "HH " + cPatHelp() + "HELP.CHM::/" + AllTrim( cTema ) + ".HTM" ) )

//----------------------------------------------------------------------------//

Function cPatHelp()

Return ( FullCurDir() + "Help\" )

//----------------------------------------------------------------------------//

Function cPatReporting()

Return ( FullCurDir() + "Reporting\" )

//----------------------------------------------------------------------------//

Function cPatUserReporting()

Return ( FullCurDir() + "UserReporting\" )

//----------------------------------------------------------------------------//

Function HtmlHelp()

Return ( "" )

//---------------------------------------------------------------------------//

function lUsrMaster()

return ( cCurUsr() == "000" )

//---------------------------------------------------------------------------//

Function IsPda()

Return ( "PDA" $ cParamsMain() )

//---------------------------------------------------------------------------//

Function cPatSnd( lShort )

   DEFAULT lShort := .f.

Return ( if( !lShort, FullCurDir(), "" ) + "Snd\" )

//----------------------------------------------------------------------------//

Function cEmpTmp( lPath, lShort )

   DEFAULT lPath  := .t.
   DEFAULT lShort := .f.

Return ( if( !lShort, FullCurDir(), "" ) + "EmpTmp" + if( lPath, "\", "" ) )

//----------------------------------------------------------------------------//

Function cPatUsr()

Return ( FullCurDir() + "Usr\" )

//----------------------------------------------------------------------------//

Function cImp()

   local cImp  := uFieldEmpresa( "cNomImp" )

   if !IsChar( cImp )
      cImp     := ""
   end if

Return ( cImp )

//----------------------------------------------------------------------------//

Function addMnuNext( cName, uAction )

   if aScan( aMnuNext, {|c| c[1] == cName } ) == 0
      if valtype( uAction ) == "C"
         aAdd( aMnuNext, { cName, &( "{||" + uAction + "() }" ) } )
      else
         aAdd( aMnuNext, { cName, uAction } )
      end if
   end if

Return .t.

//---------------------------------------------------------------------------//

function cValToChar( uVal )

   local cType := ValType( uVal )

   do case
      case cType == "C" .or. cType == "M"
           return uVal

      case cType == "D"
           return DToC( uVal )

      case cType == "L"
           return If( uVal, ".T.", ".F." )

      case cType == "N"
           return AllTrim( Str( uVal ) )

      case cType == "B"
           return "{|| ... }"

      case cType == "A"
           return "{ ... }"

      case cType == "O"
           return "Object"

      otherwise
           return ""
   endcase

return nil

//---------------------------------------------------------------------------//

FUNCTION cCharToVal( xVal, cType )

   local cTemp      := ""

   DEFAULT cType    := ValType( xVal )

   do case
      case cType == "C" .or. cType == "M"

         if !Empty( xVal )
            cTemp   := Padr( Rtrim( xVal ), 100 )
         end if
         
         /*
         if ( '"' $ xVal ) .or. ( "'" $ xVal )
            cTemp := Rtrim( cValToChar( xVal ) )
         else
            cTemp := '"' + Rtrim( cValToChar( xVal ) ) + '"'
         end if
        */

      case cType == "N"
         cTemp    := Val( cValToChar( xVal ) )

      case cType == "D"

         cTemp    := Ctod( Rtrim( cValToChar( xVal ) ) )

      case cType == "L"
         if "S" $ Rtrim( Upper( xVal ) )
            cTemp := .t.
         else
            cTemp := .f.
         end if

   end case

RETURN ( cTemp )

//---------------------------------------------------------------------------//

Function cValToText( uVal, lBarraFecha )

   local cType             := ValType( uVal )

   DEFAULT lBarraFecha     := .f.

   do case
      case cType == "C" .or. cType == "M"
           return uVal

      case cType == "D"
           if lBarraFecha
               return DToC( uVal )
           else
               return StrTran( DToC( uVal ), "/", "" )
           end if

      case cType == "L"
           return If( uVal, "S", "N" )

      case cType == "N"
           return AllTrim( Str( uVal ) )

      case cType == "B"
           return "{|| ... }"

      case cType == "A"
           return "{ ... }"

      case cType == "O"
           return "Object"

      otherwise
           return ""
   endcase

return nil

//---------------------------------------------------------------------------//

function dToIso( dDate )

   local cDate := ""

   if Valtype( dDate ) != "D"
      dDate    := Date()
   endif

   cDate       := Alltrim( Str( Year( dDate ) ) + "-" + StrZero( Month( dDate ), 2 ) + "-" + StrZero( Day( dDate ), 2 ) )

return ( cDate )

//---------------------------------------------------------------------------//

Function LogWrite( cText, cFileName )

   local nHand

   DEFAULT cFileName := "Trace.Log"

   if !Empty( cText )

      if !File( cFileName )
         nHand       := fCreate( cFileName )
      else
        nHand        := fOpen( cFileName, 1 )
      endif

      fSeek( nHand, 0 , 2 )

      fWrite( nHand, Time() + '-' + Trans( Seconds(), "999999.9999" ) + Space( 1 ) )
      fWrite( nHand, cValToChar( cText ) + CRLF )
      
      fClose( nHand )

   end if

RETURN NIL

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ApoloBtnBmp FROM TBtnBmp

   METHOD aGrad INLINE Eval( If( ::bClrGrad == nil, ::oWnd:bClrGrad, ::bClrGrad ), ( ::lMOver .or. ::lBtnDown ) )

ENDCLASS

//----------------------------------------------------------------------------//

FUNCTION PicOut()

   if Empty( cDefPicOut )
      cDefPicOut  := cPorDiv( cDivEmp() )
   end if

RETURN ( cDefPicOut )

//---------------------------------------------------------------------------//

FUNCTION cUsrTik( cCodUsr )

   if !Empty( cCodUsr )
      cUsrTik     := cCodUsr
   end if

Return cUsrTik

//---------------------------------------------------------------------------//

FUNCTION cDelUsrTik( cCodUsr )

   cUsrTik     := Space(3)

Return .t.

//---------------------------------------------------------------------------//

Function cPatLog( lShort )

   DEFAULT lShort  := .f.

Return ( if( !lShort, FullCurDir(), "" ) + "Log\" )

//----------------------------------------------------------------------------//

Function cCodigoEmpresa( xValue )

   if !Empty( xValue )
      cCodEmp     := xValue
   end if

Return ( cCodEmp )

//--------------------------------------------------------------------------//


PROCEDURE xmlIterator( cFileName, cNode, cAttrib, cValue, cData )

   LOCAL hFile, cXml
   LOCAL oDoc, oNode, oIter, lFind
   LOCAL cText    := ""

   SET EXACT OFF

   CLS

   cText          += "X H A R B O U R - XML ITERATOR test "

   IF cFileName == NIL
      cFileName := "xmltest.xml"
   ENDIF

   // this can happen if I call xmltest filename "" cdata
   IF ValType( cNode ) == "C" .and. Len( cNode ) == 0
      cNode := NIL
   ENDIF

   // this can happen if I call xmltest filename "" cdata
   IF ValType( cAttrib ) == "C" .and. Len( cAttrib ) == 0
      cAttrib := NIL
   ENDIF

   // this can happen if I call xmltest filename "" cdata
   IF ValType( cValue ) == "C" .and. Len( cValue ) == 0
      cValue := NIL
   ENDIF

   cText          +=  "Processing file " + cFileName + "..." + CRLF

   oDoc := TXmlDocument():New( cFileName )

   IF oDoc:nStatus != HBXML_STATUS_OK
      cText       +=  "Error While Processing File: "+cFileName
      cText       +=  "On Line: " + AllTrim( Str( oDoc:nLine ) )
      cText       +=  "Error: " + oDoc:ErrorMsg
      cText       +=  "Program Terminating, press any key"
      RETURN
   ENDIF

   lFind := ( cNode != NIL .or. cAttrib != NIL .or. cValue != NIL .or. cData != NIL )

   cText          += "Navigating all nodes with a base iterator" + CRLF

   oNode := oDoc:CurNode

if ! lFind 

   DO WHILE oNode != NIL
      cXml := oNode:Path()
      IF cXml == NIL
         cXml :=  "(Node without path)"
      ENDIF

      cText       += Alltrim( Str( oNode:nType ) ) + ", " + cValToChar( oNode:cName ) + ", " + ValToPrg( oNode:aAttributes ) + ", " + cValToChar( oNode:cData ) + ": " + cValToChar( cXml ) + CRLF

      oNode       := oDoc:Next()
   ENDDO

else
      cText       += "Iterator - Navigating all nodes" +  cValToChar( cNode ) +  "," + cValToChar( cAttrib ) + "=" + cValToChar( cValue ) + " with data having " + cValToChar( cData ) + CRLF

      oIter := TXmlIterator():New( oDoc:oRoot )
      oIter:lRegex := .t.

      IF cNode != NIL
         cNode := HB_RegexComp( cNode )
      ENDIF

      IF cAttrib != NIL
         cAttrib := HB_RegexComp( cAttrib )
      ENDIF

      IF cValue != NIL
         cValue := HB_RegexComp( cValue )
      ENDIF

      IF cData != NIL
         cData := HB_RegexComp( cData )
      ENDIF

      oNode := oIter:Find( cNode, cAttrib, cValue, cData )

      WHILE oNode != NIL
         cText    += "Found node " + oNode:Path() + ValToPrg( oNode:ToArray() ) + CRLF
         oNode    := oIter:FindNext()
      ENDDO

endif

   cText          += "Terminated. Press any key to continue"


RETURN

//---------------------------------------------------------------------------//

Function lBancas()

Return ( "BANCAS" $ cParamsMain() )

//---------------------------------------------------------------------------//

function GetOleObject( cApp )

   local oObj

   TRY
      oObj  := GetActiveObject( cApp )
   CATCH
      TRY
         oObj  := CreateObject( cApp )
      CATCH
      END
   END

return oObj

//----------------------------------------------------------------------------//

function WinWordObj()

   local lInstalled
   local oWord

   if !( lInstalled == .f. )
      lInstalled  := ( ( oWord := GetOleObject( "Word.Application" ) ) != nil )
   endif

return oWord

//----------------------------------------------------------------------------//

function ExcelObj()

   local lInstalled
   local oExcel

   if !( lInstalled == .f. )
      lInstalled  := ( ( oExcel := GetOleObject( "Excel.Application" ) ) != nil )
   endif

return oExcel

//----------------------------------------------------------------------------//

function SunCalcObj()

   local lInstalled
   local oCalc

   if !( lInstalled == .f. )
      lInstalled  := ( ( oCalc := GetOleObject( "com.sun.star.ServiceManager" ) ) != nil )
   endif

return oCalc

//----------------------------------------------------------------------------//

function GetExcelRange( cBook, cSheet, acRange )

   local oExcel, oBook, oSheet, oRange

   if ( oExcel := ExcelObj() ) != nil
      if ( oBook := GetExcelBook( cBook ) ) != nil
         TRY
            oSheet   := oBook:WorkSheets( cSheet )
            if ValType( acRange ) == 'A'
               oRange   := oSheet:Range( oSheet:Cells( acRange[ 1 ], acRange[ 2 ] ), ;
                                         oSheet:Cells( acRange[ 3 ], acRange[ 4 ] ) )
            else
               oRange   := oSheet:Range( acRange )
            endif
         CATCH
         END
      endif
   endif

return oRange

//----------------------------------------------------------------------------//

function GetExcelBook( cBook )

   local oExcel, oBook
   local c, n, nBooks

   cBook := Upper( cFilePath( cBook ) + cFileNoExt( cBook ) )
   if ( oExcel := ExcelObj() ) != nil
      nBooks   := oExcel:WorkBooks:Count()
      for n := 1 to nBooks
         c  := oExcel:WorkBooks( n ):FullName
         if cBook == Upper( cFilePath( c ) + cFileNoExt( c ) )
            return oExcel:WorkBooks( n )
         endif
      next n
      TRY
         oBook := oExcel:WorkBooks:Open( cBook )
      CATCH
      END
   endif

return oBook

//----------------------------------------------------------------------------//

Function SpecialVal( cNumber )

   local cChar
   local cResult  := ""

   cNumber        := Alltrim( cNumber )

   for each cChar in cNumber
      if Str( Val( cChar ) ) == cChar
         cResult  += cChar
      end if
   next

Return ( Val( cResult ) )

//----------------------------------------------------------------------------//

Function ApoloMsgNoYes( cText, cTitle, lTactil ) 

   local oDlg
   local oBmp
   local oBtnOk
   local oBtnCancel

   DEFAULT cText              := "¿Desea eliminar el registro en curso?"
   DEFAULT cTitle             := "Confirme"
   DEFAULT lTactil            := .f.

   if lTactil
      DEFINE DIALOG oDlg RESOURCE "DeleteRecnoTct" TITLE ( cTitle )
   else
      DEFINE DIALOG oDlg RESOURCE "DeleteRecno" TITLE ( cTitle )
   end if

   REDEFINE BITMAP oBmp       ID 500         OF oDlg RESOURCE "Symbol_questionmark_48_Alpha" TRANSPARENT

   REDEFINE SAY PROMPT cText  ID 100         OF oDlg

   REDEFINE BUTTON oBtnOk     ID IDOK        OF oDlg ACTION ( oDlg:end( IDOK ) )

   REDEFINE BUTTON oBtnCancel ID IDCANCEL    OF oDlg ACTION ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   if !Empty( oBmp )
      oBmp:End()
   end if

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

Function ApoloMsgStop( cText, cTitle ) 

   local oDlg
   local oBtnOk

   DEFAULT cText              := "¿Desea eliminar el registro en curso?"
   DEFAULT cTitle             := "¡Atención!"

   DEFINE DIALOG oDlg RESOURCE "MsgStopTCT" TITLE ( cTitle )

   REDEFINE SAY PROMPT cText  ID 100         OF oDlg

   REDEFINE BUTTON oBtnOk     ID IDOK        OF oDlg ACTION ( oDlg:end( IDOK ) )

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

Function ApoloWaitSeconds( nSecs )

   local n

   for n := 1 to nSecs
      WaitSeconds( 1 )
      SysRefresh()
   next

return nil

//----------------------------------------------------------------------------//

Function ApoloDescend( uParam )

Return ( Descend( uParam ) )

//----------------------------------------------------------------------------//

Function CreateFastReport()

   if Empty( oFastReport )

      oFastReport    := frReportManager():new()

      oFastReport:LoadLangRes( "Spanish.Xml" )
      oFastReport:SetIcon( 1 )

   end if

Return ( oFastReport )

//----------------------------------------------------------------------------//

Function DestroyFastReport()

   if Empty( oFastReport )
      oFastReport:DestroyFR()
   end if

Return ( nil )

//----------------------------------------------------------------------------//

function cDirectorioImagenes()

  local cDirectorio := AllTrim( uFieldEmpresa( "CDIRIMG" ) )

  if Right( cDirectorio, 1 ) != "\"
    cDirectorio     := cDirectorio + "\"
  end if

Return ( cDirectorio )

//----------------------------------------------------------------------------//

/*------------------------------------------------------------------------------
Pasa del formato RGB al format RGB Hexadecimal  #000000-------------------------
------------------------------------------------------------------------------*/

function RgbToRgbHex( nColorRgb )

   local cRgbHex  := ""

   cRgbHex        += "#"
   cRgbHex        += NumToHex( nRgbRed( nColorRgb ), 2 )
   cRgbHex        += NumToHex( nRgbGreen( nColorRgb ), 2 )
   cRgbHex        += NumToHex( nRgbBlue( nColorRgb ), 2 )

return cRgbHex

//----------------------------------------------------------------------------//

function InfoStack()

   local i
   local cStack

   i              := 2
   cStack         := ""

   while !Empty( ProcName( i ) )
      cStack      += "Llamado desde " + Trim( ProcName( i ) ) + "(" + LTrim( Str( ProcLine( i ) ) ) + ")" + CRLF
      i++
   enddo

   MsgInfo( cStack )

return nil

//----------------------------------------------------------------------------//

Function lValidMail( cMail )

Return ( HB_RegExMatch( "[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}", cMail, .f. ) )

//----------------------------------------------------------------------------//

Function hashRecord( dbf )

  local n
  local hHash   := {=>}

  for n := 1 to ( dbf )->( fcount() )
    hSet( hHash, ( dbf )->( fieldname( n ) ), ( dbf )->( fieldget( n ) ) )
  next 

Return ( hHash )

//----------------------------------------------------------------------------//

Function appendHashRecord( hHash, dbf, aExclude )

  ( dbf )->( dbappend() )
  if !( dbf )->( neterr() )  
    writeHashRecord( hHash, dbf, aExclude )
  end if

Return ( hHash )

//----------------------------------------------------------------------------//

Function writeHashRecord( hHash, dbf, aExclude )

  local n

  DEFAULT aExclude  := {}

  for n := 1 to ( dbf )->( fcount() )
    if hHasKey( hHash, ( dbf )->( fieldname( n ) ) ) .and. aScan( aExclude, ( dbf )->( fieldname( n ) ) ) == 0
      ( dbf )->( fieldput( n, hGet( hHash, ( dbf )->( fieldname( n ) ) ) ) )
    end if
  next 

Return ( hHash )

//----------------------------------------------------------------------------//

Function readHashDictionary( hashTable, dbf )

  local hash      := {=>}

  hEval( hashTable, {|key,value| hSet( hash, key, ( dbf )->( fieldget( ( dbf )->( fieldPos( value ) ) ) ) ) } )

Return ( hash )

//----------------------------------------------------------------------------//

Function writeHashDictionary( hashValue, hashTable, dbf )

   local h
   local value

   for each h in hashValue
      value     := getValueHashDictionary( h:__enumKey(), hashTable )
      if value != nil
         ( dbf )->( fieldput( ( dbf )->( fieldname( value ) ),  h:__enumValue() ) )
      end if
   next

Return ( nil )

//----------------------------------------------------------------------------//

Function getValueHashDictionary( key, hashTable )

   local n
   local value

   n  := hScan( hashTable, {|k,v,i| k == key } ) 
   if n != 0
      value   := haaGetValueAt( hashTable, n )
   end if 

Return ( value )

//----------------------------------------------------------------------------//

function hashDictionary( aItems )

   local aItem
   local hash        := {=>}

   for each aItem in aItems
      if !empty( aItem[6] )
         hSet( hash, aItem[6], aItem[1] )      
      end if
   next

return ( hash )

//---------------------------------------------------------------------------//

function hashDefaultValue( aItems )

  local aItem
  local hash        := {=>}

  for each aItem in aItems
    if !Empty( aItem[6] ) .and. isBlock( aItem[9] )
      hSet( hash, aItem[6], aItem[9] )
    end if
  next

return ( hash )

//---------------------------------------------------------------------------//

FUNCTION HtmlConvertChars( cString, cQuote_style, aTranslations )

   DEFAULT cQuote_style := "ENT_COMPAT"

   do case
      case cQuote_style == "ENT_COMPAT"
         aAdd( aTranslations, { '"', '&quot;'  } )
      case cQuote_style == "ENT_QUOTES"
         aAdd( aTranslations, { '"', '&quot;'  } )
         aAdd( aTranslations, { "'", '&#039;'  } )
      case cQuote_style == "ENT_NOQUOTES"
   end case

RETURN TranslateStrings( cString, aTranslations )

FUNCTION TranslateStrings( cString, aTranslate )

   local aTran

   for each aTran in aTranslate
      if aTran[ 2 ] $ cString
         cString  := StrTran( cString, aTran[ 2 ], aTran[ 1 ] )
      endif
   next

RETURN cString

FUNCTION HtmlEntities( cString, cQuote_style )

   local i
   local aTranslations := {}

   for i := 160 TO 255
      aAdd( aTranslations, { Chr( i ), "&#" + Str( i, 3 ) + ";" } )
   next

RETURN HtmlConvertChars( cString, cQuote_style, aTranslations )

//---------------------------------------------------------------------------//

Function dateTimeToString( dDate, cTime )

Return ( dtoc( dDate ) + space( 1 ) + trans( cTime, "@R 99:99:99" ) )

//---------------------------------------------------------------------------//

Function validTime( uTime )

   local cTime
   local nHour    
   local nMinutes 
   local nSeconds 

   if isObject( uTime )
      cTime       := uTime:varGet()
   else 
      cTime       := uTime
   end if 

   nHour          := val( substr( cTime, 1, 2 ) )
   nMinutes       := val( substr( cTime, 3, 2 ) )
   nSeconds       := val( substr( cTime, 5, 2 ) )

   if !validHour( nHour )
      Return .f.
   end if 

   if !validMinutesSeconds( nMinutes )
      Return .f.
   end if 

   if !validMinutesSeconds( nSeconds )
      Return .f.
   end if 

Return ( .t. )

Function validHour( nHour )

Return ( nHour >= 0 .and. nHour <= 23 )

Function validMinutesSeconds( nMinutes )

Return ( nMinutes >= 0 .and. nMinutes <= 59 )

//---------------------------------------------------------------------------//

Function validHourMinutes( uTime )

   local cTime
   local nHour
   local nMinutes

   if isObject( uTime )
      cTime       := uTime:varGet()
   else 
      cTime       := uTime
   end if 

   nHour          := val( substr( cTime, 1, 2 ) )
   nMinutes       := val( substr( cTime, 3, 2 ) )

   if !validHour( nHour )
      Return .f.
   end if 

   if !validMinutesSeconds( nMinutes )
      Return .f.
   end if 

Return ( .t. )

//--------------------------------------------------------------------------//

Function getSysTime()

Return ( strtran( time(), ":", "" ) )

/*
Function ADSRunSQL( cAlias, cSql, aParameters, hConnection, lShow )

   LOCAL cOldAlias  := Alias()
   LOCAL lCreate    := FALSE
   LOCAL nItem      := 0
   LOCAL xParameter

   DEFAULT hConnection := hConn
   DEFAULT lShow       := FALSE

   IF !Empty( cAlias ) .and. !Empty( cSql )

      cSql := StrTran( cSql, ";", "" )

      DBSelectArea( 0 )

      IF !AdsCreateSqlStatement( cAlias, ADS_CDX, hConnection )
         msgStop( "Error AdsCreateSqlStatement()" + FINL + "Error: " + cValtoChar( AdsGetLastError() ) )
      ELSE
         IF !HB_IsNil( aParameters ) .and. HB_IsArray( aParameters )
            FOR EACH xParameter IN aParameters
               nItem := HB_EnumIndex()
               cSql  := StrTran( cSql, "%" + AllTrim( Str( nItem ) ) , Var2Str( xParameter ) )
            NEXT
         ENDIF
         IF lShow
            MsgInfo( cSql, "SQLDebug")
         ENDIF
         IF !AdsExecuteSqlDirect( cSql )
            ( cAlias )->( DBCloseArea() )
            msgStop( "Error AdsExecuteSqlDirect( cSql )" + FINL + "Error:" + cValtoChar( AdsGetLastError() ) + FINL + cSql )
         ELSE
            lCreate := TRUE
         ENDIF
      ENDIF

      IF !Empty( cOldAlias )
         DBSelectArea( cOldAlias )
      ENDIF

   ENDIF

RETURN lCreate
*/