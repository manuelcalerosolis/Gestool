#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TIPdtCli FROM TInfGen

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

   ::AddField ( "CCODCLI", "C", 12, 0, {|| "@!" },         "Cod. cli",                .f., "Cod. cliente"            ,  8 )
   ::AddField ( "CNOMCLI", "C", 50, 0, {|| "@!" },         "Nombre",                  .f., "Nombre cliente"          , 25 )
   ::AddField ( "CDOCMOV", "C", 14, 0, {|| "@!" },         "Factura",                 .t., "Factura"                 , 14 )
   ::AddField ( "DFECMOV", "D",  8, 0, {|| "@!" },         "Fecha",                   .t., "Fecha"                   , 14 )
   ::AddField ( "CNIFCLI", "C", 15, 0, {|| "@!" },         "Nif",                     .f., "Nif"                     ,  8 )
   ::AddField ( "CDOMCLI", "C", 35, 0, {|| "@!" },         "Domicilio",               .f., "Domicilio"               , 25 )
   ::AddField ( "CPOBCLI", "C", 25, 0, {|| "@!" },         "Población",               .f., "Población"               , 20 )
   ::AddField ( "CPROCLI", "C", 20, 0, {|| "@!" },         "Provincia",               .f., "Provincia"               , 20 )
   ::AddField ( "CCDPCLI", "C",  7, 0, {|| "@!" },         "CP",                      .f., "Cod. postal"             , 20 )
   ::AddField ( "CTLFCLI", "C", 12, 0, {|| "@!" },         "Tlf",                     .f., "Teléfono"                ,  7 )
   ::AddField ( "COBRCLI", "C", 10, 0, {|| "@!" },         "Dirección",                    .f., "Código dirección"             , 12 )
   ::AddField ( "CNBREST", "C", 50, 0, {|| "@!" },         "Establecimiento",         .f., "Establecimiento"         , 25 )
   ::AddField ( "NTOTDOC", "N", 16, 3, {|| ::cPicOut },    "Facturado",               .t., "Total factura"           , 10 )
   ::AddField ( "NTOTCOB", "N", 16, 3, {|| ::cPicOut },    "Cobrado",                 .t., "Total fobrado"           , 10 )
   ::AddField ( "NTOTPEN", "N", 16, 3, {|| ::cPicOut },    "Pendiente",               .t., "Total pendiente"         , 10 )
   ::AddField ( "CTIPVEN", "C", 20, 0, {|| "@!" },         "Venta",                   .f., "Tipo de venta"           , 15 )
   ::AddField ( "CABNFAC", "C", 12, 0, {|| "@!" },         "Abono",                   .f., "Abono de factura"        , 12 )

   ::AddTmpIndex ( "CCODCLI", "CCODCLI" )

   ::AddGroup( {|| ::oDbf:cCodCli }, {|| "Cliente   : " + Rtrim( ::oDbf:cCodCli ) + "-" + Rtrim( oRetFld( ::oDbf:cCodCli, ::oDbfCli ) ) }, {||"Total cliente..."} )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oError
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oFacCliT     := TDataCenter():oFacCliT() 

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE  "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oFacRecT PATH ( cPatEmp() ) FILE  "FACRECT.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL PATH ( cPatEmp() ) FILE  "FACRECL.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   ::oFacCliP := TDataCenter():oFacCliP()

   DATABASE NEW ::oAntCliT PATH ( cPatEmp() ) FILE  "ANTCLIT.DBF" VIA ( cDriver() ) SHARED INDEX "ANTCLIT.CDX"

   DATABASE NEW ::oDbfIva  PATH ( cPatDat() ) FILE  "TIVA.DBF"    VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   RECOVER USING oError


      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

      ::CloseFiles()

      lOpen          := .f.

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
   ::oFacRecT := nil
   ::OfACRecL :=nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cOrden := "Cliente"

   if !::StdResource( "INF_GEN16A" )
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

   local nTotFacCli     := 0
   local nPagFacCli     := 0
   local bValid         := {|| .t. }
   local lExcCero       := .f.
   local cExpHead       := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader   := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Cliente : " + if( ::lAllCli, "Todos", AllTrim( ::cCliOrg ) + " > " + AllTrim( ::cCliDes ) ) },;
                     {|| "Agente  : " + if ( !Empty( ::cAgeOrg ),( ::cAgeOrg + " > " + ::cAgeDes ), "Ninguno" ) } }

   ::oFacCliT:OrdSetFocus( "dFecFac" )

   cExpHead          := '!lLiquidada .and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !::lAgeAll
      cExpHead       += ' .and. cCodAge >= "' + Rtrim( ::cAgeOrg ) + '" .and. cCodAge <= "' + Rtrim( ::cAgeDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )

   ::oFacCliT:GoTop()

   WHILE !::lBreak .and. !::oFacCliT:Eof()

      // Condiciones de liquidación, fechas, clientes, agentes y rutas */

      if lChkSer( ::oFacCliT:CSERIE, ::aSer )

         nTotFacCli  := nTotFacCli( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacCliP:cAlias, ::oAntCliT:cAlias )
         nPagFacCli  := nPagFacCli( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac, ::oFacCliT:cAlias, ::oFacCliP:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias )

         if abs( nTotFacCli ) > abs( nPagFacCli )

            // Si cumple todas, empezamos a añadir

            ::oDbf:Append()

            ::oDbf:CCODCLI := ::oFacCliT:CCODCLI
            ::oDbf:CNOMCLI := ::oFacCliT:CNOMCLI
            ::oDbf:DFECMOV := ::oFacCliT:DFECFAC
            ::oDbf:CDOCMOV := lTrim ( ::oFacCliT:CSERIE ) + "/" + lTrim ( Str( ::oFacCliT:NNUMFAC ) ) + "/" + lTrim ( ::oFacCliT:CSUFFAC )

            // Datos del cliente en cuestion

            ::AddCliente( ::oFacCliT:cCodCli, ::oFacCliT, .f. )

            ::oDbf:nTotDoc := nTotFacCli
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

   /*
   comenzamos con las rectificativas

   ::oFacRecT:OrdSetFocus( "dFecFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !::lAgeAll
      cExpHead       += ' .and. cCodAge >= "' + Rtrim( ::cAgeOrg ) + '" .and. cCodAge <= "' + Rtrim( ::cAgeDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacRecT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )

   ::oFacRecT:GoTop()

   WHILE !::lBreak .and. !::oFacRecT:Eof()

      // Condiciones de liquidación, fechas, clientes, agentes y rutas

      if lChkSer( ::oFacRecT:CSERIE, ::aSer )

         nTotFacCli  := nTotFacRec( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac, ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacRecP:cAlias, ::oAntCliT:cAlias )
         nPagFacCli  := nPagFacCli( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oFacCliP:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias )

         if abs( nTotFacCli ) > abs( nPagFacCli )

            // Si cumple todas, empezamos a añadir

            ::oDbf:Append()

            ::oDbf:CCODCLI := ::oFacRecT:CCODCLI
            ::oDbf:CNOMCLI := ::oFacRecT:CNOMCLI
            ::oDbf:DFECMOV := ::oFacRecT:DFECFAC
            ::oDbf:CDOCMOV := lTrim ( ::oFacRecT:CSERIE ) + "/" + lTrim ( Str( ::oFacRecT:NNUMFAC ) ) + "/" + lTrim ( ::oFacRecT:CSUFFAC )

            // Datos del cliente en cuestion

            ::AddCliente( ::oFacRecT:cCodCli, ::oFacRecT, .f. )

            ::oDbf:nTotDoc := nTotFacCli
            ::oDbf:nTotCob := nPagFacCli
            ::oDbf:nTotPen := nTotFacCli - nPagFacCli

            ::oDbf:Save()

         end if

      end if

      ::oFacRecT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oFacRecT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ) )
   ::oMtrInf:AutoInc( ::oFacRecT:LastRec() )
   */


    ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//