#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TdAgeTik FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  oOrdenado   AS OBJECT
   DATA  cOrdenado   AS CHARACTER     INIT  "Fechas"
   DATA  aOrdenado   AS ARRAY    INIT  { "Clientes", "Fechas", "Documento" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodAge", "C",  3, 0, {|| "@!" },        "Cód. age.",        .f., "Cod. agente",         3 )
   ::AddField( "cNomAge", "C", 50, 0, {|| "@!" },        "Agente",           .f., "Nom. agente",        25 )
   ::FldCliente()
   ::AddField( "cNumDoc", "C", 12, 0, {|| "" },          "Doc.",             .t., "Documento",          12 )
   ::AddField( "dFecDoc", "D",  8, 0, {|| "" },          "Fecha",            .t., "Fecha",              12 )
   ::AddField( "nTotNet", "N", 16, 6, {|| ::cPicOut },   "Neto",             .t., "Neto",               12 )
   ::AddField( "nTotIva", "N", 16, 6, {|| ::cPicOut },   cImp(),              .t., cImp(),                12 )
   ::AddField( "nTotDoc", "N", 16, 6, {|| ::cPicOut },   "Total",            .t., "Total",              12 )
   ::AddField( "nTotCos", "N", 16, 6, {|| ::cPicOut },   "Costo",            .t., "Costo",              12 )
   ::AddField( "nMarGen", "N", 16, 6, {|| ::cPicOut },   "Margen",           .t., "Margen",             12 )
   ::AddField( "nRenTab", "N", 16, 6, {|| ::cPicOut },   "% Ren.",           .t., "% rentabilidad",     12 )
   ::AddField( "nComAge", "N", 13, 6, {|| ::cPicOut },   "Com.Age.",         .t., "Comisión agente",    12 )

   ::AddTmpIndex( "cCodCli", "cCodAge + cCodCli" )
   ::AddTmpIndex( "cCodFec", "cCodAge + DtoS( dFecDoc )" )
   ::AddTmpIndex( "cCodNum", "cCodAge + cNumDoc" )

   ::AddGroup( {|| ::oDbf:cNomAge }, {|| "Agente  : " + Rtrim( ::oDbf:cNomAge ) + "-" + oRetFld( ::oDbf:cNomAge, ::oDbfAge ) }, {||"Total agente..."} )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TdAgeTik

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oTikCliT  PATH ( cPatEmp() ) FILE "TIKET.DBF"   VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL  PATH ( cPatEmp() ) FILE "TIKEL.DBF"   VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oDbfCli   PATH ( cPatCli() ) FILE "CLIENT.DBF"  VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   DATABASE NEW ::oDbfIva   PATH ( cPatDat() ) FILE "TIVA.DBF"    VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TdAgeTik

   if !Empty( ::oTikCliT ) .and. ::oTikCliT:Used()
      ::oTikCliT:End()
   end if
   if !Empty( ::oTikCliL ) .and. ::oTikCliL:Used()
      ::oTikCliL:End()
   end if
   if !Empty( ::oDbfCli ) .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if
   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if

   ::oTikCliT := nil
   ::oTikCliL := nil
   ::oDbfCli  := nil
   ::oDbfIva  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TdAgeTik

   if !::StdResource( "INF_GEN25G" )
      return .f.
   end if

   /*
   Monta los agentes de manera automatica
   */

   if !::oDefAgeInf( 70, 80, 90, 100, 930 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oTikCliT:Lastrec() )

   REDEFINE COMBOBOX ::oOrdenado ;
      VAR      ::cOrdenado ;
      ID       219 ;
      ITEMS    ::aOrdenado ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmTik(), ::oTikCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TdAgeTik

   local lExcCero := .f.
   local aTotTmp  := {}
   local cExpHead := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()
   ::oTikCliT:GoTop()

   ::aHeader      := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                        {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Agentes : " + ::cAgeOrg         + " > " + ::cAgeDes },;
                        {|| "Ordenado: " + ::cOrdenado } }

   ::oTikCliT:OrdSetFocus( "dFecTik" )

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       := ::oFilter:cExpresionFilter
   else
      cExpHead       := '.t.'
   end if

   ::oTikCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ), ::oTikCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oTikCliT:GoTop()

	/*
   Nos movemos por las cabeceras de los albaranes
   */

   while !::lBreak .and. !::oTikCliT:Eof()

      if ::oTikCliT:dFecTik >= ::dIniInf                                                             .AND.;
         ::oTikCliT:dFecTik <= ::dFinInf                                                             .AND.;
         ( ::lAgeAll .or. (::oTikCliT:cCodAge >= ::cAgeOrg .AND. ::oTikCliT:cCodAge <= ::cAgeDes ) ) .AND.;
         lChkSer( ::oTikCliT:cSerTik, ::aSer )

         ::oDbf:Append()

         ::oDbf:cCodAge    := ::oTikCliT:cCodAge

         if ::oDbfAge:Seek( ::oTikCliT:cCodAge )
            ::oDbf:cNomAge := Rtrim( ::oDbfAge:cApeAge ) + ", " + ::oDbfAge:cNbrAge
         end if

         ::oDbf:cNomAge    := ::oTikCliT:cCodAge

         ::AddCliente( ::oTikCliT:cCliTik, ::oTikCliT, .t. )

         aTotTmp        := aTotTik( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik, ::oTikCliT:cAlias, ::oTikCliL:cAlias, ::oDbfDiv:cAlias, nil, ::cDivInf )

         ::oDbf:dFecDoc    := ::oTikCliT:dFecTik
         ::oDbf:cNumDoc    := lTrim ( ::oTikCliT:cSerTik ) + "/" + lTrim ( ::oTikCliT:cNumTik ) + "/" + lTrim ( ::oTikCliT:cSufTik )
         ::oDbf:nTotNet    := if( ::oTikCliT:cTipTik == "4", - aTotTmp[1], aTotTmp[1] )
         ::oDbf:nTotIva    := if( ::oTikCliT:cTipTik == "4", - aTotTmp[2], aTotTmp[2] )
         ::oDbf:nTotDoc    := if( ::oTikCliT:cTipTik == "4", - aTotTmp[3], aTotTmp[3] )
         ::oDbf:nComAge    := ::oDbf:nTotDoc * ::oTikCliT:nComAge / 100

         ::oDbf:Save()

      end if

      ::oTikCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oTikCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ) )

   ::oMtrInf:AutoInc( ::oTikCliT:LastRec() )

   do case
      case ::oOrdenado:nAt == 1
         ::oDbf:OrdSetFocus( "CCODCLI" )
      case ::oOrdenado:nAt == 2
         ::oDbf:OrdSetFocus( "CCODFEC" )
      case ::oOrdenado:nAt == 3
         ::oDbf:OrdSetFocus( "CCODNUM" )
   end case

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//