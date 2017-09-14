#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TIPdtCob FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oOrden      AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  oFacCliP    AS OBJECT
   DATA  oAntCliT    AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::FldCliente()

   ::AddField( "CDOCMOV", "C", 18, 0, {|| "@!" },         "Factura",                   .t., "Factura"                   , 14, .f. )
   ::AddField( "DFECMOV", "D",  8, 0, {|| "@!" },         "Fecha",                     .t., "Fecha"                     , 14, .f. )
   ::AddField( "NTOTDOC", "N", 16, 3, {|| ::cPicOut },    "Tot. Fac",                  .t., "Total factura"             , 10, .t. )
   ::AddField( "NTOTCOB", "N", 16, 3, {|| ::cPicOut },    "Tot. Cob",                  .t., "Total cobrado"             , 10, .t. )
   ::AddField( "NTOTPEN", "N", 16, 3, {|| ::cPicOut },    "Tot. Pen",                  .t., "Total pendiente"           , 10, .t. )
   ::AddField( "CTIPVEN", "C", 20, 0, {|| "@!" },         "Venta",                     .f., "Tipo de venta"             , 15, .f. )

   ::AddTmpIndex ( "CCODCLI", "CPOBCLI + CCODCLI + Dtos( DFECMOV )" )

   ::AddGroup( {|| ::oDbf:cPobCli }, {|| "Población  : " + AllTrim( ::oDbf:cPobCli ) }, {||"Total Población..."} )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oError
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      ::oFacCliT  := TDataCenter():oFacCliT()  

      DATABASE NEW ::oFacCliL  PATH ( cPatEmp() ) FILE  "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

      DATABASE NEW ::oFacRecT  PATH ( cPatEmp() ) FILE  "FACRECT.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

      DATABASE NEW ::oFacRecL  PATH ( cPatEmp() ) FILE  "FACRECL.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

      ::oFacCliP := TDataCenter():oFacCliP()

      DATABASE NEW ::oDbfIva   PATH ( cPatDat() ) FILE  "TIVA.DBF"    VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

      DATABASE NEW ::oAntCliT  PATH ( cPatEmp() ) FILE  "ANTCLIT.DBF" VIA ( cDriver() ) SHARED INDEX "ANTCLIT.CDX"

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

      ::CloseFiles()

      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if
   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if
   if !Empty( ::oFacRecT ) .and. ::oFacRecT:Used()
      ::oFacRecT:End()
   end if
   if !Empty( ::oFacRecL ) .and. ::oFacRecL:Used()
      ::oFacRecL:End()
   end if
   if !Empty( ::oFacCliP ) .and. ::oFacCliP:Used()
      ::oFacCliP:End()
   end if
   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if
   if !Empty( ::oAntCliT ) .and. ::oAntCliT:Used()
      ::oAntCliT:End()
   end if

   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oFacCliP := nil
   ::oAntCliT := nil
   ::oDbfIva  := nil
   ::oFacRect := nil
   ::oFacRect := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )


   if !::StdResource( "INF_GEN16" )
      return .f.
   end if

   /*
   Montamos clientes
   */

   if !::oDefCliInf( 70, 80, 90, 100, , 600 )
      return .f.
   end if

   /*
   Montamos agentes
   */

   if !::oDefAgeInf( 110, 120, 130, 140, 940 )
      return .f.
   end if

   /*
   Montamos rutas
   */

   if !::oDefRutInf( 150, 160, 170, 180, 950 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )

   ::CreateFilter( aItmFacCli(), ::oFacCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local nTotFacRec     := 0
   local nPagFacRec     := 0
   local nTotFacCli     := 0
   local nPagFacCli     := 0
   local cExpHead       := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()
   ::oDbf:OrdSetFocus( "CCODCLI" )

   ::aHeader   := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Cliente : " + if( ::lAllCli, "Todos", AllTrim( ::cCliOrg ) + " > " + AllTrim( ::cCliDes ) ) },;
                     {|| "Agente  : " + if( !Empty( ::cAgeOrg ),( AllTRim( ::cAgeOrg ) + " > " + AllTrim( ::cAgeDes ) ), "Ninguno" ) },;
                     {|| "Ruta    : " + if( ::lAllRut, "Todas", AllTrim( ::cRutOrg ) + " > " + AllTrim( ::cRutDes ) ) } }

   ::oFacCliT:OrdSetFocus( "dFecFac" )

   cExpHead          := '!lLiquidada .and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !::lAgeAll
      cExpHead       += ' .and. cCodAge >= "' + Rtrim( ::cAgeOrg ) + '" .and. cCodAge <= "' + Rtrim( ::cAgeDes ) + '"'
   end if

   if !::lAllRut
      cExpHead       += ' .and. cCodRut >= "' + Rtrim( ::cRutOrg ) + '" .and. cCodRut <= "' + Rtrim( ::cRutDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )

   ::oFacCliT:GoTop()

   while !::lBreak .and. !::oFacCliT:Eof()

      if lChkSer( ::oFacCliT:CSERIE, ::aSer )

         nTotFacCli  := nTotFacCli( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacCliP:cAlias, ::oAntCliT:cAlias )
         nPagFacCli  := nPagFacCli( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac, ::oFacCliT:cAlias, ::oFacCliP:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias )

         if abs( nTotFacCli ) > abs( nPagFacCli )

         // Si cumple todas, empezamos a añadir

            ::oDbf:Append()

            ::oDbf:cCodCli := ::oFacCliT:cCodCli
            ::oDbf:cNomCli := ::oFacCliT:cNomCli
            ::oDbf:dFecMov := ::oFacCliT:dFecFac
            ::oDbf:nTotDoc := nTotFacCli
            ::oDbf:cDocMov := lTrim ( ::oFacCliT:cSerie ) + "/" + lTrim ( Str( ::oFacCliT:nNumFac ) ) + "/" + lTrim ( ::oFacCliT:cSufFac )

            // Datos del cliente en cuestion

            ::AddCliente( ::oFacCliT:cCodCli, ::oFacCliT, .f. )

            ::oDbf:nTotCob := nPagFacCli
            ::oDbf:nTotPen := nTotFacCli - nPagFacCli
            ::oDbf:Save()

         end if

      end if

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oFacCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ) )

   ::oMtrInf:AutoInc( ::oFacCliT:LastRec() )

   ::oDbf:OrdSetFocus( "CCODCLI" )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//