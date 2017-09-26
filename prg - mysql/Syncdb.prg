#include "Factu.ch" 

static dbfConfig
static cPortPrint
static cSufPda
static cCodTra
static nTotLineas       := 0
static nSaltoLineas     := 0
static cCodAge
static cCodAlm
static cAlmCtr
static lInitTpv
static cSayProgress
static lChkSistema
static lChkMaestro
static lChkTrabajo
static cCodCaja
static cCodCajero

//--------------------------------------------------------------------------//

Function IsConfig()

   local oError
   local oBlock

   if !lExistTable( cPatEmp() + "Config.Dbf" )
      mkConfig( cPatEmp() )
   end if

   if !lExistIndex( cPatEmp() + "Config.Cdx" )
      rxConfig( cPatEmp() )
   end if

   oBlock                     := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      USE ( cPatEmp() + "Config.Dbf" ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "CNOMBREPC", @dbfConfig ) )
      SET ADSINDEX TO ( cPatEmp() + "Config.Cdx" ) ADDITIVE

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( dbfConfig )

Return ( .t. )

//----------------------------------------------------------------------------//

FUNCTION mkConfig( cPath, lAppend, cPathOld, oMeter )

   local dbfConfig

   DEFAULT lAppend   := .f.

	IF oMeter != NIL
		oMeter:cText	:= "Generando Bases"
      SysRefresh()
	END IF

   dbCreate( cPath + "Config.Dbf", aSqlStruct( aItmCfg() ), cDriver() )

   if lAppend .and. lIsDir( cPathOld ) .and. lExistTable( cPathOld + "Config.Dbf" )

      dbUseArea( .t., cDriver(), cPath + "Config.Dbf", cCheckArea( "CONFIG", @dbfConfig ), .f. )
      ( dbfConfig )->( __dbApp( cPathOld + "Config.Dbf" ) )
      ( dbfConfig )->( dbCloseArea() )

   end if

   rxConfig( cPath, oMeter )

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION rxConfig( cPath, oMeter )

   local dbfConfig

   DEFAULT cPath := cPatEmp()

   if !lExistTable( cPath + "CONFIG.DBF" )
      dbCreate( cPath + "CONFIG.DBF", aSqlStrucT( aItmCfg() ), cDriver() )
   end if

   fEraseIndex( cPath + "CONFIG.CDX" )

   dbUseArea( .t., cDriver(), cPath + "CONFIG.DBF", cCheckArea( "CONFIG", @dbfConfig ), .f. )
   if !( dbfConfig )->( neterr() )
      ( dbfConfig )->( __dbPack() )

      ( dbfConfig )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfConfig )->( ordCreate( cPath + "CONFIG.CDX", "CNOMBREPC", "CNOMBREPC", {|| Field->CNOMBREPC }, ) )

      ( dbfConfig )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfConfig )->( ordCreate( cPath + "CONFIG.CDX", "CCODEMP", "CCODEMP", {|| Field->CCODEMP }, ) )

      ( dbfConfig )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfConfig )->( ordCreate( cPath + "CONFIG.CDX", "CPORTPRINT", "CPORTPRINT", {|| Field->CPORTPRINT }, ) )

      ( dbfConfig )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfConfig )->( ordCreate( cPath + "CONFIG.CDX", "CSUFPDA", "CSUFPDA", {|| Field->CSUFPDA }, ) )

      ( dbfConfig )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfConfig )->( ordCreate( cPath + "CONFIG.CDX", "CCODTRA", "CCODTRA", {|| Field->CCODTRA }, ) )

      ( dbfConfig )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfConfig )->( ordCreate( cPath + "CONFIG.CDX", "CCODAGE", "CCODAGE", {|| Field->CCODAGE }, ) )

      ( dbfConfig )->( ordCondSet("!Deleted()", {||!Deleted()}  ) )
      ( dbfConfig )->( ordCreate( cPath + "CONFIG.CDX", "CCODALM", "CCODALM", {|| Field->CCODALM }, ) )

      ( dbfConfig )->( dbCloseArea() )

   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de configuración" )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

function aItmCfg()

local aBase := {  {"CNOMBREPC",  "C", 250, 0, "Directorio del programa"    ,  "",  "", "( cDbfConfig )" },;
                  {"CCODEMP",    "C",   2, 0, "Código de la empresa"       ,  "",  "", "( cDbfConfig )" },;
                  {"CPORTPRINT", "C",   5, 0, "Puerto de la impresora"     ,  "",  "", "( cDbfConfig )" },;
                  {"CSUFPDA",    "C",   2, 0, "Sufijo de la PDA"           ,  "",  "", "( cDbfConfig )" },;
                  {"CCODTRA",    "C",   9, 0, "Código de transportista"    ,  "",  "", "( cDbfConfig )" },;
                  {"CCODAGE",    "C",   3, 0, "Código de agente"           ,  "",  "", "( cDbfConfig )" },;
                  {"CCODALM",    "C",  16, 0, "Código de almacén"          ,  "",  "", "( cDbfConfig )" },;
                  {"CALMCTR",    "C",  16, 0, "Código de almacén central"  ,  "",  "", "( cDbfConfig )" },;
                  {"LINITTPV",   "L",   1, 0, "lInitTpv"                   ,  "",  "", "( cDbfConfig )" },;
                  {"NTOTLIN",    "N",   2, 0, "Total lineas documento"     ,  "",  "", "( cDbfConfig )" },;
                  {"CCODCAJA",   "C",   3, 0, "Código para la caja"        ,  "",  "", "( cDbfConfig )" },;
                  {"CCODCAJERO", "C",   3, 0, "Código del cajero"          ,  "",  "", "( cDbfConfig )" },;
                  {"NSALLIN",    "N",   3, 0, "Numero para salto de linea" ,  "",  "", "( cDbfConfig )" } }
return ( aBase )

//--------------------------------------------------------------------------//

Function LoadConfig()

   USE ( cPatEmp() + "Config.Dbf" ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "CNOMBREPC", @dbfConfig ) )
   SET ADSINDEX TO ( cPatEmp() + "Config.Cdx" ) ADDITIVE

   if ( dbfConfig )->( LastRec() ) == 0
      ( dbfConfig )->( dbAppend() )
   end if

   cNombrePc(        ( dbfConfig )->cNombrePc )
   cCodigoEmpresa(   ( dbfConfig )->cCodEmp )
   cPortPrint(       ( dbfConfig )->cPortPrint )
   cSufPda(          ( dbfConfig )->cSufPda )
   cCodTra(          ( dbfConfig )->cCodTra )
   nTotLin(          ( dbfConfig )->nTotLin )
   nSalLin(          ( dbfConfig )->nSalLin )
   cCodAge(          ( dbfConfig )->cCodAge )
   cCodAlm(          ( dbfConfig )->cCodAlm )
   cAlmCtr(          ( dbfConfig )->cAlmCtr )
   lInitTpv(         ( dbfConfig )->lInitTpv )
   cCodCaja(         ( dbfConfig )->cCodCaja )
   cCodCajero(       ( dbfConfig )->cCodCajero )

   CLOSE ( dbfConfig )

RETURN NIL

//--------------------------------------------------------------------------//

Static Function SaveConfig( dbfConfig )

Return nil

//--------------------------------------------------------------------------//

Function cPortPrint( xValue )

   if !Empty( xValue )
      cPortPrint     := xValue
   end if

Return ( cPortPrint )

//--------------------------------------------------------------------------//

Function cSufPda( xValue )

   if Empty( cSufPda )
      cSufPda     := Space( 2 )
   end if

   if !Empty( xValue )
      cSufPda     := xValue
   end if

Return ( cSufPda )

//--------------------------------------------------------------------------//

Function cCodTra( xValue )

   if !Empty( xValue )
      cCodTra     := xValue
   end if

Return ( cCodTra )

//--------------------------------------------------------------------------//

Function nTotLin( xValue )

   if !Empty( xValue )
      nTotLineas     := xValue
   end if

Return ( nTotLineas )

//--------------------------------------------------------------------------//

Function nSalLin( xValue )

   if !Empty( xValue )
      nSaltoLineas     := xValue
   end if

Return ( nSaltoLineas )

//--------------------------------------------------------------------------//

Function cCodAge( xValue )

   if !Empty( xValue )
      cCodAge     := xValue
   end if

Return ( cCodAge )

//--------------------------------------------------------------------------//

/*
Function cCodAlm( xValue )

   if Empty( cCodAlm )
      cCodAlm     := "000"
   end if

   if !Empty( xValue )
      cCodAlm     := xValue
   end if

Return ( cCodAlm )
*/

//--------------------------------------------------------------------------//

Function cAlmCtr( xValue )

   if Empty( cAlmCtr )
      cAlmCtr     := "000"
   end if

   if !Empty( xValue )
      cAlmCtr     := xValue
   end if

Return ( cAlmCtr )

//--------------------------------------------------------------------------//

Function lInitTpv( xValue )

   if Empty( lInitTpv )
      lInitTpv    := .f.
   end if

   if !Empty( xValue )
      lInitTpv    := xValue
   end if

Return ( lInitTpv )

//--------------------------------------------------------------------------//

Function cCodCaja( xValue )

   if Empty( cCodCaja )
      cCodCaja    := "000"
   end if

   if !Empty( xValue )
      cCodCaja    := xValue
   end if

Return ( cCodCaja )

//--------------------------------------------------------------------------//

Function cCodCajero( xValue )

   if Empty( cCodCajero )
      cCodCajero    := "000"
   end if

   if !Empty( xValue )
      cCodCajero    := xValue
   end if

Return ( cCodCajero )

//--------------------------------------------------------------------------//
