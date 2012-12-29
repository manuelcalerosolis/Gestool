#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch"
#include "MesDbf.ch"
//---------------------------------------------------------------------------//

CLASS TDiaCTpv FROM TInfGen

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  oTikCliP    AS OBJECT
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT
   DATA  oDbfTvta    AS OBJECT

   METHOD Create ()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "CCODCLI", "C", 12, 0, {|| "@!" },         "Cod. Cli.",                 .t., "Cod. cliente",               8 )
   ::AddField( "CNOMCLI", "C", 50, 0, {|| "@!" },         "Nom. Cli.",                 .t., "Nombre cliente",            25 )
   ::AddField( "CDOCMOV", "C", 14, 0, {|| "@!" },         "Fac",                       .t., "Factura",                   14 )
   ::AddField( "DFECMOV", "D",  8, 0, {|| "@!" },         "Fecha",                     .t., "Fecha",                     14 )
   ::AddField( "CNIFCLI", "C", 15, 0, {|| "@!" },         "Nif",                       .f., "Nif",                        8 )
   ::AddField( "CDOMCLI", "C", 35, 0, {|| "@!" },         "Dom",                       .f., "Domicilio",                 10 )
   ::AddField( "CPOBCLI", "C", 25, 0, {|| "@!" },         "Pob",                       .f., "Población",                 25 )
   ::AddField( "CPROCLI", "C", 20, 0, {|| "@!" },         "Prov",                      .f., "Provincia",                 20 )
   ::AddField( "CCDPCLI", "C",  7, 0, {|| "@!" },         "CP",                        .f., "Cod. Postal",               20 )
   ::AddField( "CTLFCLI", "C", 12, 0, {|| "@!" },         "Tlf",                       .f., "Teléfono",                   7 )
   ::AddField( "CDEFI01", "C",100, 0, {|| "@!" },         {|| ::cNameIniCli(1) }, .f., {|| ::cNameIniCli(1) },           50 )
   ::AddField( "CDEFI02", "C",100, 0, {|| "@!" },         {|| ::cNameIniCli(2) }, .f., {|| ::cNameIniCli(2) },           50 )
   ::AddField( "CDEFI03", "C",100, 0, {|| "@!" },         {|| ::cNameIniCli(3) }, .f., {|| ::cNameIniCli(3) },           50 )
   ::AddField( "CDEFI04", "C",100, 0, {|| "@!" },         {|| ::cNameIniCli(4) }, .f., {|| ::cNameIniCli(4) },           50 )
   ::AddField( "CDEFI05", "C",100, 0, {|| "@!" },         {|| ::cNameIniCli(5) }, .f., {|| ::cNameIniCli(5) },           50 )
   ::AddField( "CDEFI06", "C",100, 0, {|| "@!" },         {|| ::cNameIniCli(6) }, .f., {|| ::cNameIniCli(6) },           50 )
   ::AddField( "CDEFI07", "C",100, 0, {|| "@!" },         {|| ::cNameIniCli(7) }, .f., {|| ::cNameIniCli(7) },           50 )
   ::AddField( "CDEFI08", "C",100, 0, {|| "@!" },         {|| ::cNameIniCli(8) }, .f., {|| ::cNameIniCli(8) },           50 )
   ::AddField( "CDEFI09", "C",100, 0, {|| "@!" },         {|| ::cNameIniCli(9) }, .f., {|| ::cNameIniCli(9) },           50 )
   ::AddField( "CDEFI10", "C",100, 0, {|| "@!" },         {|| ::cNameIniCli(10)}, .f., {|| ::cNameIniCli(10)},           50 )
   ::AddField( "NTOTNET", "N", 16, 6, {|| ::cPicOut  },   "Neto",                      .t., "Neto",                      10 )
   ::AddField( "NTOTIVA", "N", 16, 6, {|| ::cPicOut  },   cImp(),                       .t., cImp(),                       10 )
   ::AddField( "NTOTDOC", "N", 16, 6, {|| ::cPicOut },    "Total",                     .t., "Total",                     10 )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TDiaCTpv

  local oBlock
  local oError
  local lOpen := .t.

    /*
   Ficheros necesarios
   */
   oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   DATABASE NEW ::oTikCliT  PATH ( cPatEmp() ) FILE "TIKET.DBF" VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"
   ::oTikCliT:SetOrder( "DFECTIK" )

   DATABASE NEW ::oTikCliL  PATH ( cPatEmp() ) FILE "TIKEL.DBF" VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oDbfIva   PATH ( cPatDat() ) FILE "TIVA.DBF"  VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   DATABASE NEW ::oTikCliP  PATH ( cPatEmp() ) FILE "TIKEP.DBF"  VIA ( cDriver() ) SHARED INDEX "TIKEP.CDX"

   DATABASE NEW ::oDbfTvta  PATH ( cPatDat() ) FILE "TVTA.DBF"    VIA ( cDriver() ) SHARED INDEX "TVTA.CDX"

   RECOVER USING oError

      lOpen := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TDiaCTpv

   if !Empty( ::oTikCliT ) .and. ::oTikCliT:Used()
      ::oTikCliT:End()
   end if

  if !Empty( ::oTikCliL ) .and. ::oTikCliL:Used()
      ::oTikCliL:End()
   end if

  if !Empty( ::oTikCliP ) .and. ::oTikCliP:Used()
      ::oTikCliP:End()
   end if

   if !Empty( ::oDbfTvta ) .and. ::oDbfTvta:Used()
      ::oDbfTvta:End()
   end if

  if !Empty( ::oDbfCli ) .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if

  if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TDiaCTpv

   local cEstado := "Todas"

   if !::StdResource( "INF_GEN26" )
      return .f.
   end if

   /*
   Monta los obras de manera automatica
   */

   ::oDefCliInf( 70, 80, 90, 100 )

   /*
   Monta los clientes de manera automatica
   */

   ::lDefArtInf( 110, 120, 130, 140 )

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oTikCliT:Lastrec() )

   ::oDefExcInf()

   ::oDefResInf()

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TDiaCTpv

   local bValid   := {|| .t. }
   local lExcCero := .f.
   local aTotTmp  := {}

   ::oDlg:Disable()

   ::oDbf:Zap()
   ::oTikCliT:GoTop()

   ::aHeader      := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                        {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Cliente : " + ::cCliOrg         + " > " + ::cCliDes         } }

   /*
   Nos movemos por las cabeceras de los albaranes a clientes
	*/

   WHILE ::oTikCliT:dFecTik <= ::dFinInf .AND. !::oTikCliT:Eof()

      IF Eval( bValid )                                                                     .AND.;
         ( ::oTikCliT:cTipTik == "1" .OR. ::oTikCliT:cTipTik == "4" )                       .AND.;
         ::oTikCliT:dFecTik >= ::dIniInf                                                    .AND.;
         ::oTikCliT:cCliTik >= ::cCliOrg                                                    .AND.;
         ::oTikCliT:cCliTik <= ::cCliDes                                                    .AND.;
         lChkSer( ::oTikCliT:cSerTik, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         ::oDbf:Append()

         ::oDbf:CCODCLI := ::oTikCliT:cCliTik
         ::oDbf:DFECMOV := ::oTikCliT:dFecTik

         aTotTmp        := aTotTik( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik, ::oTikCliT:cAlias, ::oTikCliL:cAlias, ::oDbfDiv:cAlias, nil, ::cDivInf )

         ::oDbf:NTOTNET := if( ::oTikCliT:cTipTik == "4", - aTotTmp[1], aTotTmp[1] )
         ::oDbf:NTOTIVA := if( ::oTikCliT:cTipTik == "4", - aTotTmp[2], aTotTmp[2] )
         ::oDbf:NTOTDOC := if( ::oTikCliT:cTipTik == "4", - aTotTmp[3], aTotTmp[3] )
         ::oDbf:CDOCMOV := lTrim ( ::oTikCliT:cSerTik ) + "/" + lTrim ( ::oTikCliT:cNumTik ) + "/" + lTrim ( ::oTikCliT:cSufTik )

         if ::oDbfCli:Seek ( ::oTikCliT:cCliTik )

            ::oDbf:CNOMCLI := ::oDbfCli:Titulo
            ::oDbf:CNIFCLI := ::oDbfCli:Nif
            ::oDbf:CDOMCLI := ::oDbfCli:Domicilio
            ::oDbf:CPOBCLI := ::oDbfCli:Poblacion
            ::oDbf:CPROCLI := ::oDbfCli:Provincia
            ::oDbf:CCDPCLI := ::oDbfCli:CodPostal
            ::oDbf:CTLFCLI := ::oDbfCli:Telefono
            ::oDbf:CDEFI01 := ::oDbfCli:CusRDef01
            ::oDbf:CDEFI02 := ::oDbfCli:CusRDef02
            ::oDbf:CDEFI03 := ::oDbfCli:CusRDef03
            ::oDbf:CDEFI04 := ::oDbfCli:CusRDef04
            ::oDbf:CDEFI05 := ::oDbfCli:CusRDef05
            ::oDbf:CDEFI06 := ::oDbfCli:CusRDef06
            ::oDbf:CDEFI07 := ::oDbfCli:CusRDef07
            ::oDbf:CDEFI08 := ::oDbfCli:CusRDef08
            ::oDbf:CDEFI09 := ::oDbfCli:CusRDef09
            ::oDbf:CDEFI10 := ::oDbfCli:CusRDef10

          end if

         ::oDbf:Save()

      end if

      ::oMtrInf:AutoInc()

      ::oTikCliT:Skip()

   end while

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//