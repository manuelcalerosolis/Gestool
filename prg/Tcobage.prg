#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfCobAge FROM TInfGen

   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacCliP    AS OBJECT
   DATA  oIva        AS OBJECT
   DATA  lTvta       AS LOGIC    INIT .f.
   DATA  oDbfCli     AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Cobrados", "Pendientes", "Todos" }
   DATA  oEstado     AS OBJECT
   DATA  oOrdenado   AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cNumDoc", "C", 15, 0,  {|| "" },           "Doc.",                      .t., "Documento",                  12 )
   ::AddField( "cCodAge", "C",  3, 0,  {|| "@!" },         "Cód. age.",                 .f., "Código agente",               3 )
   ::AddField( "cNomAge", "C", 50, 0,  {|| "@!" },         "Agente",                    .f., "Nombre agente",              25 )
   ::AddField( "cCtaAge", "C", 12, 0,  {|| "@!" },         "Cuenta",                    .f., "Cuenta",                     12 )
   ::AddField( "cCodCli", "C", 12, 0,  {|| "@!" },         "Cód. cli.",                 .t., "Cod. Cliente",                8 )
   ::AddField( "cNomCli", "C", 50, 0,  {|| "@!" },         "Cliente",                   .t., "Nom. Cliente",               30 )
   ::AddField( "dFecDoc", "D",  8, 0,  {|| "" },           "Fecha",                     .t., "Fecha",                      10 )
   ::AddField( "dFecCob", "D",  8, 0,  {|| "" },           "Cobro",                     .t., "Fecha Cobro",                10 )
   ::AddField( "nDiaTra", "N",  8, 0,  {|| "" },           "Dias",                      .t., "Dias transcurridos",         10 )
   ::AddField( "nTotRec", "N", 16, 6,  {|| ::cPicOut },    "Total",                     .t., "Total",                      10 )

   ::AddTmpIndex( "dFecCob", "cCodAge + cCtaAge + Dtoc( dFecCob )" )
   ::AddTmpIndex( "dFecDoc", "cCodAge + cCtaAge + Dtoc( dFecDoc )" )
   ::AddTmpIndex( "cCodCli", "cCodAge + cCtaAge + cCodCli" )
   ::AddTmpIndex( "nTotRec", "cCodAge + cCtaAge + Str( nTotRec )" )

   ::AddGroup( {|| ::oDbf:cCodAge }, {|| "Agente : " + Rtrim( ::oDbf:cCodAge ) + "-" + Rtrim( ::oDbf:cNomAge ) }, {||"Total agente..."} )
   ::AddGroup( {|| ::oDbf:cCodAge + ::oDbf:cCtaAge }, {|| "Cta. contable : " + Rtrim( ::oDbf:cCtaAge ) }, {||"Total cuenta contable..."} )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL  PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   ::oFacCliP := TDataCenter():oFacCliP()

   DATABASE NEW ::oDbfCli   PATH ( cPatEmp() ) FILE "CLIENT.DBF"  VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   DATABASE NEW ::oIva      PATH ( cPatDat() ) FILE "TIVA.DBF" VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
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
   if !Empty( ::oFacCliP ) .and. ::oFacCliP:Used()
      ::oFacCliP:End()
   end if
   if !Empty( ::oDbfCli ) .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if
   if !Empty( ::oIva ) .and. ::oIva:Used()
      ::oIva:End()
   end if

   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oFacCliP := nil
   ::oDbfCli  := nil
   ::oIva     := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cEstado    := "Cobrados"
   local cOrdenado  := "Fecha cob."

   if !::StdResource( "INF_GEN25" )
      return .f.
   end if

   /*
   Monta los agentes de manera automatica
   */

   if !::oDefAgeInf( 70, 80, 90, 100, 220 )
      return .f.
   end if

   /*
   Damos valor al meter--------------------------------------------------------
   */

   ::oMtrInf:SetTotal( ::oFacCliP:Lastrec() )

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   REDEFINE COMBOBOX ::oOrdenado ;
      VAR      cOrdenado ;
      ID       219 ;
      ITEMS    { "Fecha cob.", "Fecha emi.", "Cliente", "Importe" } ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmRecCli(), ::oFacCliP:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                        {|| "Periodo  : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Agentes  : " + if( ::lAgeAll, "Todos", AllTrim( ::cAgeOrg ) + " > " + AllTrim( ::cAgeDes ) ) } }

   ::oFacCliP:OrdSetFocus( "dPreCob" )

   do case
      case ::oEstado:nAt == 1
         cExpHead    := 'lCobrado .and. dPreCob >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dPreCob <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 2
         cExpHead    := '!lCobrado .and. dPreCob >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dPreCob <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 3
         cExpHead    := 'dPreCob >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dPreCob <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   end case

   if !::lAgeAll
      cExpHead       += ' .and. cCodAge >= "' + Rtrim( ::cAgeOrg ) + '" .and. cCodAge <= "' + Rtrim( ::cAgeDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacCliP:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacCliP:cFile ), ::oFacCliP:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacCliP:Lastrec() )

   ::oFacCliP:GoTop()

   WHILE !::lBreak .and. !::oFacCliP:Eof()

      if lChkSer( ::oFacCliP:cSerie, ::aSer )

         ::oDbf:Append()

         ::oDbf:cCodAge    := ::oFacCliP:cCodAge

         if ::oDbfAge:Seek( ::oFacCliP:cCodAge )
            ::oDbf:cNomAge := Rtrim( ::oDbfAge:cApeAge ) + ", " + ::oDbfAge:cNbrAge
         end if

         ::oDbf:cCodCli    := ::oFacCliP:cCodCli
         if ::oDbfCli:Seek( ::oDbf:cCodCli )
            ::oDbf:cNomCli    := ::oDbfCli:titulo
         end if
         ::oDbf:cCtaAge    := ::oFacCliP:cCtaRec

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

   ::oFacCliP:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacCliP:cFile ) )

   ::oMtrInf:AutoInc( ::oFacCliP:LastRec() )

   ::oDlg:Enable()

   ::oDbf:OrdSetFocus( ::oOrdenado:nAt )

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//