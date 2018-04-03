#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS ListRem FROM TInfGen

   DATA  oRemCliT  AS OBJECT
   DATA  oFacCliP  AS OBJECT
   DATA  cRemOrg   AS OBJECT
   DATA  cRemDes   AS OBJECT
   DATA  oDbfCli   AS OBJECT
   DATA  oDbfDiv   AS OBJECT
   DATA  oDbfCta   AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "nNumRem",   "N",  9, 0, {|| "" },     "Num. rem.",   .f., "Número de remesa",      10, .f. )
   ::AddField( "cSufRem",   "C",  2, 0, {|| "" },     "Suf. rem.",   .f., "Sufijo de remesa",       8, .f. )
   ::AddField( "cCodRem",   "C",  3, 0, {|| "" },     "Código rem.", .f., "Código cuenta remesa",  10, .f. )
   ::AddField( "cNomRem",   "C", 40, 0, {|| "" },     "Nombre rem.", .f., "Nombre cuenta remesa",   8, .f. )
   ::AddField( "cNumFac",   "C", 16, 0, {|| "" },     "Recibo",      .t., "Número recibo",         18, .f. )
   ::AddField( "dFecRem",   "D",  8, 0, {|| "" },     "Fecha",       .t., "Fecha recibo",          12, .f. )
   ::AddField( "dFecVto",   "D",  8, 0, {|| "" },     "Vencimiento", .t., "Fecha de vencimiento",  13, .f. )
   ::AddField( "cCodCli",   "C", 12, 0, {|| "" },     "Cod. cli.",   .t., "Código del cliente",    15, .f. )
   ::AddField( "cNomCli",   "C", 50, 0, {|| "" },     "Cliente",     .t., "Nombre del cliente",    35, .f. )
   ::AddField( "cCodAge",   "C", 12, 0, {|| "" },     "Cod. Age.",   .f., "Código del agente",     15, .f. )
   ::AddField( "cNomAge",   "C", 50, 0, {|| "" },     "Agente",      .f., "Nombre del agente",     35, .f. )
   ::AddField( "cCodPgo",   "C", 12, 0, {|| "" },     "Cod. Pgo.",   .f., "Código del pago",       15, .f. )
   ::AddField( "cNomPgo",   "C", 50, 0, {|| "" },     "Forma pago",  .f., "Forma de pago",         35, .f. )
   ::AddField( "cCtaRem",   "C", 24, 0, {|| "" },     "Cuenta",      .t., "Cuenta bancaria",       30, .f. )
   ::AddField( "nTotRec",   "N", 16, 2, {|| "" },     "Total",       .t., "Total del recibo",      20, .t. )

   ::AddTmpIndex( "nNumRem", "nNumRem" )

   ::AddGroup( {|| ::oDbf:nNumRem }, {|| "Remesa : " + AllTrim( Str( ::oDbf:nNumRem ) ) + " - " + AllTrim( ::oDbf:cSufRem ) + "  Cuenta : " + AllTrim( ::oDbf:cCodRem ) + " - " + AllTrim( ::oDbf:cNomRem ) }, {||"Total remesa..."} )

   ::lDefFecInf   := .f.
   ::lDefSerInf   := .f.
   ::lDefDivInf   := .f.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oRemCliT PATH ( cPatEmp() )   FILE "REMCLIT.DBF"   VIA ( cDriver() ) SHARED INDEX "REMCLIT.CDX"

   ::oFacCliP := TDataCenter():oFacCliP()
   ::oFacCliP:OrdSetFocus( "nNumRem" )

   DATABASE NEW ::oDbfCli PATH ( cPatEmp() )    FILE "CLIENT.DBF"    VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   DATABASE NEW ::oDbfDiv PATH ( cPatDat() )    FILE "DIVISAS.DBF"   VIA ( cDriver() ) SHARED INDEX "DIVISAS.CDX"

   DATABASE NEW ::oDbfCta PATH ( cPatEmp() )    FILE "CTAREM.DBF"    VIA ( cDriver() ) SHARED INDEX "CTAREM.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oRemCliT ) .and. ::oRemCliT:Used()
      ::oRemCliT:End()
   end if
   if !Empty( ::oFacCliP ) .and. ::oFacCliP:Used()
      ::oFacCliP:End()
   end if
   if !Empty( ::oDbfCli ) .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if
   if !Empty( ::oDbfDiv ) .and. ::oDbfDiv:Used()
      ::oDbfDiv:End()
   end if
   if !Empty( ::oDbfCta ) .and. ::oDbfCta:Used()
      ::oDbfCta:End()
   end if

   ::oRemCliT  := nil
   ::oFacCliP  := nil
   ::oDbfCli   := nil
   ::oDbfDiv   := nil
   ::oDbfCta   := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cSayRemOrg
   local cSayRemDes
   local oSayRemOrg
   local oSayRemDes
   local oRemOrg
   local oRemDes

   if !::StdResource( "INF_REM01" )
      return .f.
   end if

   ::oBtnFilter:Disable()

   ::cRemOrg   := dbFirst( ::oRemCliT, 3 )
   ::cRemDes   := dbLast(  ::oRemCliT, 3 )
   cSayRemOrg  := dbFirst( ::oRemCliT, 4 )
   cSayRemDes  := dbLast(  ::oRemCliT, 4 )

   REDEFINE GET oRemOrg VAR ::cRemOrg;
      ID       ( 100 );
      SPINNER ;
      MIN      0 ;
      MAX      999999999 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oSayRemOrg VAR cSayRemOrg ;
      ID       ( 110 );
      WHEN     ( .f. );
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oRemDes VAR ::cRemDes;
      ID       ( 120 );
      SPINNER ;
      MIN      0 ;
      MAX      999999999 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oSayRemDes VAR cSayRemDes ;
      ID       ( 130 );
      WHEN     ( .f. );
      OF       ::oFld:aDialogs[1]

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oRemCliT:Lastrec() )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cBncCli  := ""

   ::oDlg:Disable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha  : " + Dtoc( Date() ) },;
                        {|| "Remesa : " + AllTrim( Str( ::cRemOrg ) ) + " > " + AllTrim( Str( ::cRemDes ) ) } }

   ::oRemCliT:GoTop()
   ::oFacCliP:GoTop()
   while !::oRemCliT:Eof()

      if ::oRemCliT:nNumRem >= ::cRemOrg .AND. ::oRemCliT:nNumRem <= ::cRemDes  .and.;
         ::oFacCliP:Seek( Str( ::oRemCliT:nNumRem ) + ::oRemCliT:cSufRem )

         while Str( ::oFacCliP:nNumRem ) + ::oFacCliP:cSufRem == Str( ::oRemCliT:nNumRem ) + ::oRemCliT:cSufRem .and. !::oFacCliP:Eof

            ::oDbf:Append()

            ::oDbf:nNumRem  := ::oRemCliT:nNumRem
            ::oDbf:cSufRem  := ::oRemCliT:cSufRem
            ::oDbf:cCodRem  := ::oRemCliT:cCodRem
            ::oDbf:cNomRem  := oRetFld( ::oRemCliT:cCodRem, ::oDbfCta )
            ::oDbf:cNumFac  := AllTrim( ::oFacCliP:cSerie ) + "/" + AllTrim( Str( ::oFacCliP:nNumFac ) ) + "/" + AllTrim( ::oFacCliP:cSufFac ) + "/" + AllTrim( Str( ::oFacCliP:nNumRec ) )
            ::oDbf:dFecRem  := ::oFacCliP:dPreCob
            ::oDbf:dFecVto  := ::oFacCliP:dFecVto
            ::oDbf:cCodCli  := ::oFacCliP:cCodCli
            ::oDbf:cNomCli  := RetClient( ::oFacCliP:cCodCli, ::oDbfCli:cAlias )
            ::oDbf:nTotRec  := nTotRecCli( ::oFacCliP:cAlias, ::oDbfDiv:cAlias, ::oFacCliP:cDivPgo )
            ::oDbf:cCodAge  := ::oFacCliP:cCodAge
            ::oDbf:cNomAge  := RetNbrAge( ::oFacCliP:cCodAge )
            ::oDbf:cCodPgo  := ::oFacCliP:cCodPgo
            ::oDbf:cNomPgo  := cNbrFPago( ::oFacCliP:cCodPgo )

            cBncCli         := ::oFacCliP:cPaisIBAN + ::oFacCliP:cCtrlIBAN + ::oFacCliP:cEntCli + ::oFacCliP:cSucCli + ::oFacCliP:cDigCli + ::oFacCliP:cCtaCli

            if Empty( cBncCli ) .or. Len( AllTrim( cBncCli ) ) != 24
               cBncCli      := cClientCuenta( ::oFacCliP:cCodCli )
            end if

            ::oDbf:cCtaRem  := cBncCli

            ::oDbf:Save()

            ::oFacCliP:Skip()

         end while

      end if

      ::oRemCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oRemCliT:LastRec() )

   ::oDlg:Enable()

   ::oBtnFilter:Disable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//