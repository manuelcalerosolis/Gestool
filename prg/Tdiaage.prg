#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch"
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfDiaAge FROM TInfGen

   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacCliP    AS OBJECT
   DATA  oIva        AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cNumDoc", "C", 15, 0,  {|| "" },           "Doc.",                      .t., "Documento",                  12 )
   ::AddField( "cCodAge", "C",  3, 0,  {|| "@!" },         "Cód. age.",                 .f., "Cod. Agente",                 3 )
   ::AddField( "CNOMAGE", "C", 50, 0,  {|| "@!" },         "Agente",                    .f., "Nom. Agente",                25 )
   ::AddField( "CCTAAGE", "C", 12, 0,  {|| "@!" },         "Cuenta",                    .f., "Cuenta",                     12 )
   ::AddField( "CCODCLI", "C", 12, 0,  {|| "@!" },         "Cód. cli.",                 .t., "Cod. Cliente",                8 )
   ::AddField( "CNOMCLI", "C", 50, 0,  {|| "@!" },         "Cliente",                   .t., "Nom. Cliente",               40 )
   ::AddField( "CNIFCLI", "C", 15, 0,  {|| "@!" },         "Nif",                       .f., "Nif",                        12 )
   ::AddField( "CDOMCLI", "C", 35, 0,  {|| "@!" },         "Domicilio",                 .f., "Domicilio",                  20 )
   ::AddField( "CPOBCLI", "C", 25, 0,  {|| "@!" },         "Población",                 .f., "Población",                  25 )
   ::AddField( "CPROCLI", "C", 20, 0,  {|| "@!" },         "Provincia",                 .f., "Provincia",                  20 )
   ::AddField( "CCDPCLI", "C",  7, 0,  {|| "@!" },         "Cod. Postal",               .f., "Cod. Postal",                 7 )
   ::AddField( "CTLFCLI", "C", 12, 0,  {|| "@!" },         "Teléfono",                  .f., "Teléfono",                   12 )
   ::AddField( "CDEFI01", "C",100, 0,  {|| "@!" },         {|| ::cNameIniCli(1) },      .f., {|| ::cNameIniCli(1) },       50 )
   ::AddField( "CDEFI02", "C",100, 0,  {|| "@!" },         {|| ::cNameIniCli(2) },      .f., {|| ::cNameIniCli(2) },       50 )
   ::AddField( "CDEFI03", "C",100, 0,  {|| "@!" },         {|| ::cNameIniCli(3) },      .f., {|| ::cNameIniCli(3) },       50 )
   ::AddField( "CDEFI04", "C",100, 0,  {|| "@!" },         {|| ::cNameIniCli(4) },      .f., {|| ::cNameIniCli(4) },       50 )
   ::AddField( "CDEFI05", "C",100, 0,  {|| "@!" },         {|| ::cNameIniCli(5) },      .f., {|| ::cNameIniCli(5) },       50 )
   ::AddField( "CDEFI06", "C",100, 0,  {|| "@!" },         {|| ::cNameIniCli(6) },      .f., {|| ::cNameIniCli(6) },       50 )
   ::AddField( "CDEFI07", "C",100, 0,  {|| "@!" },         {|| ::cNameIniCli(7) },      .f., {|| ::cNameIniCli(7) },       50 )
   ::AddField( "CDEFI08", "C",100, 0,  {|| "@!" },         {|| ::cNameIniCli(8) },      .f., {|| ::cNameIniCli(8) },       50 )
   ::AddField( "CDEFI09", "C",100, 0,  {|| "@!" },         {|| ::cNameIniCli(9) },      .f., {|| ::cNameIniCli(9) },       50 )
   ::AddField( "CDEFI10", "C",100, 0,  {|| "@!" },         {|| ::cNameIniCli(10)},      .f., {|| ::cNameIniCli(10)},       50 )
   ::AddField( "dFecDoc", "D",  8, 0, {|| "" },            "Fecha",                     .t., "Fecha",                      10 )
   ::AddField( "dFecCob", "D",  8, 0, {|| "" },            "Cobro",                     .t., "Fecha Cobro",                10 )
   ::AddField( "nDiaTra", "N",  8, 0, {|| "" },            "Dias",                      .t., "Dias transcurridos",         10 )
   ::AddField( "nTotRec", "N", 16, 6, {|| ::cPicOut },     "Total",                     .t., "Total",                      10 )

   ::AddTmpIndex( "cCodAge", "cCodAge" )
   ::AddTmpIndex( "cCtaAge", "cCodAge + cCtaAge" )

   ::AddGroup( {|| ::oDbf:cCodAge }, {|| "Agente : " + Rtrim( ::oDbf:cCodAge ) + "-" + Rtrim( ::oDbf:cNomAge ) }, {||"Total agente..."} )
   ::AddGroup( {|| ::oDbf:cCodAge + ::oDbf:cCtaAge }, {|| "Cta. contable : " + Rtrim( ::oDbf:cCtaAge ) }, {||"Total cuenta contable..."} )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

  local oBlock
  local oError
  local lOpen := .t.

   /*
   Ficheros necesarios
   */

   oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   DATABASE NEW ::oFacCliT  PATH ( cPatEmp() ) FILE "FACCLIT.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIT.CDX"

   DATABASE NEW ::oFacCliL  PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oFacCliP  PATH ( cPatEmp() ) FILE "FACCLIP.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIP.CDX"

   DATABASE NEW ::oDbfCli   PATH ( cPatCli() ) FILE "CLIENT.DBF"  VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   DATABASE NEW ::oIva      PATH ( cPatDat() ) FILE "TIVA.DBF" VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   RECOVER USING oError

      lOpen := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

 if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if

 if    !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if

  if !Empty( ::oFacCliP ) .and. ::oFacCliP:Used()
      ::oFacCliP:End()
   end if

  if !Empty( ::oDbfCli ) .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if

  if !Empty( ::oIva ) .and. ::oIva:Used()
      ::oIva:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INF_GEN25A" )
      return .f.
   end if

   /*
   Monta los agentes de manera automatica--------------------------------------
   */

   ::oDefAgeInf( 70, 80, 90, 100 )

   ::oDefResInf()

   /*
   Damos valor al meter--------------------------------------------------------
   */

   ::oMtrInf:SetTotal( ::oFacCliP:Lastrec() )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   ::oDlg:Disable()

   ::oDbf:Zap()

   ::oFacCliP:GoTop()

   ::aHeader      := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                        {|| "Periodo  : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Agentes  : " + ::cAgeOrg         + " > " + ::cAgeDes } }

   /*
   Damos valor al meter--------------------------------------------------------
   */

   WHILE !::oFacCliP:Eof()

      if ::oFacCliP:lCobrado                                                                 .AND.;
         ::oFacCliP:dEntrada >= ::dIniInf                                                    .AND.;
         ::oFacCliP:dEntrada <= ::dFinInf                                                    .AND.;
         ::oFacCliP:cCodAge >= ::cAgeOrg                                                     .AND.;
         ::oFacCliP:cCodAge <= ::cAgeDes                                                     .AND.;
         lChkSer( ::oFacCliP:cSerie, ::aSer )

         ::oDbf:Append()

         ::oDbf:cCodAge    := ::oFacCliP:cCodAge

         if ::oDbfAge:Seek( ::oFacCliP:cCodAge )
            ::oDbf:cNomAge := Rtrim( ::oDbfAge:cApeAge ) + ", " + ::oDbfAge:cNbrAge
         end if

         ::oDbf:cCodCli    := ::oFacCliP:cCodCli
         ::odbf:cCtaAge    := ::oFacCliP:cCtaRec

         ::AddCliente( ::oFacCliP:cCodCli, ::oFacCliP, .f. )

         ::oDbf:dFecDoc    := ::oFacCliP:dPreCob
         ::oDbf:dFecCob    := ::oFacCliP:dEntrada
         ::oDbf:nDiaTra    := ::oFacCliP:dEntrada - ::oFacClip:dPreCob

         ::oDbf:cNumDoc    := ::oFacCliP:cSerie + Str( ::oFacCliP:nNumFac ) + ::oFacCliP:cSufFac + Str( ::oFacCliP:nNumRec )
         ::oDbf:nTotRec    := nTotRecCli( ::oFacCliP, ::oDbfDiv )

         ::oDbf:Save()

      end if

      ::oFacCliP:Skip()

      ::oMtrInf:AutoInc( ::oFacCliP:OrdKeyNo() )

   end while

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//