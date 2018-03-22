#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfPgoPob FROM TInfGen

   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacCliP    AS OBJECT
   DATA  oIva        AS OBJECT
   DATA  oEstado
   DATA  aEstado     AS ARRAY    INIT  { "Pendientes", "Cobrados", "Descontados", "Todos" }
   DATA  cEstado     AS CHARACTER     INIT  "Pendientes"

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

   METHOD lIsValid()


END CLASS

//---------------------------------------------------------------------------//

METHOD Create() CLASS TInfPgoPob

   ::AddField( "cNumDoc", "C", 15, 0,  {|| "" },           "Doc.",                      .t., "Documento",                  12 )
   ::AddField( "cCodCli", "C", 12, 0,  {|| "@!" },         "Cód. cli.",                 .t., "Cod. Cliente",                8 )
   ::AddField( "cNomCli", "C", 50, 0,  {|| "@!" },         "Cliente",                   .t., "Nom. Cliente",               40 )
   ::AddField( "cNifCli", "C", 15, 0,  {|| "@!" },         "Nif",                       .f., "Nif",                        12 )
   ::AddField( "cDomCli", "C", 35, 0,  {|| "@!" },         "Domicilio",                 .f., "Domicilio",                  20 )
   ::AddField( "cPobCli", "C", 25, 0,  {|| "@!" },         "Población",                 .f., "Población",                  25 )
   ::AddField( "cProCli", "C", 20, 0,  {|| "@!" },         "Provincia",                 .f., "Provincia",                  20 )
   ::AddField( "cCdpCli", "C",  7, 0,  {|| "@!" },         "Cod. Postal",               .f., "Cod. Postal",                 7 )
   ::AddField( "cTlfCli", "C", 12, 0,  {|| "@!" },         "Teléfono",                  .f., "Teléfono",                   12 )
   ::AddField( "dFecDoc", "D",  8, 0,  {|| "" },           "Emisión",                   .t., "Fecha",                      10 )
   ::AddField( "cForPag", "C",  2, 0,  {|| "" },           "Pgo.",                      .f., "Forma pago",                  3 )
   ::AddField( "cNomPgo", "C", 40, 0,  {|| "@!" },         "Forma de pago",             .f., "Nombre de formas de pago"  , 40, .f.)
   ::AddField( "dFecVen", "D",  8, 0,  {|| "" },           "Vcto.",                     .t., "Fecha vencimiento",          10 )
   ::AddField( "dEstFac", "C",  2, 0,  {|| "" },           "Estado",                    .f., "Estado factura",              2 )
   ::AddField( "nTotRec", "N", 16, 6,  {|| ::cPicOut },    "Total",                     .t., "Total",                      10 )
   ::AddField( "cBanco",  "C", 50, 0,  {|| "@!" },         "Banco",                     .f., "Nombre del banco",           20 )
   ::AddField( "cCuenta", "C", 30, 0,  {|| "@!" },         "Cuenta",                    .f., "Cuenta bancaria",            35 )

   ::AddTmpIndex( "cForPag", "cForPag" )
   ::AddTmpIndex( "cPobCli", "cForPag + cPobCli" )

   ::AddGroup( {|| ::oDbf:cPobCli }, {|| "Población : " + Rtrim( ::oDbf:cPobCli )}, {||"Total población..."} )
   ::AddGroup( {|| ::oDbf:cPobCli + ::oDbf:cForPag }, {|| "Forma de pago : " + Rtrim( ::oDbf:cForPag ) + "-" + Rtrim( ::oDbf:cNomPgo ) }, {||"Total formas de pago..."} )
   ::AddGroup( {|| ::oDbf:cPobCli + ::oDbf:cForPag + ::oDbf:cCodCli }, {|| "Cliente  : " + Rtrim( ::oDbf:cCodCli ) + "-" + oRetFld( ::oDbf:cCodCli, ::oDbfCli ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TInfPgoPob

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL  PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   ::oFacCliP := TDataCenter():oFacCliP()

   DATABASE NEW ::oIva      PATH ( cPatDat() ) FILE "TIVA.DBF" VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TInfPgoPob

   if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if
   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if
   if !Empty( ::oFacCliP ) .and. ::oFacCliP:Used()
      ::oFacCliP:End()
   end if
   if !Empty( ::oIva ) .and. ::oIva:Used()
      ::oIva:End()
   end if

   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oFacCliP := nil
   ::oIva     := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TInfPgoPob

   if !::StdResource( "INF_GEN25B" )
      return .f.
   end if

   if !::oDefFpgInf( 1450, 1451, 1460, 1461, 920 )
      return .f.
   end if

   if !::oDefCliInf( 1470, 1471, 1480, 1481, , 600 )
      return .f.
   end if

   REDEFINE COMBOBOX ::oEstado VAR ::cEstado ;
      ID       1490 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   ::oMtrInf:SetTotal( ::oFacCliP:Lastrec() )

   ::CreateFilter( aItmRecCli(), ::oFacCliP:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TInfPgoPob

   local cCodFpg
   local cExpHead := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                        {|| "Periodo  : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "F. pago  : " + Rtrim ( ::cFpgDes ) + " > " + Rtrim ( ::cFpgHas ) },;
                        {|| "Clientes : " + Rtrim ( ::cCliOrg ) + " > " + Rtrim ( ::cCliDes ) },;
                        {|| "Estado   : " + ::cEstado } }

   ::oFacCliP:OrdSetFocus( "dPreCob" )

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       := ::oFilter:cExpresionFilter
   else
      cExpHead       := '.t.'
   end if

   ::oFacCliP:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacCliP:cFile ), ::oFacCliP:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oFacCliP:GoTop()

   while !::lBreak .and. !::oFacCliP:Eof()

   /*
   Guarda en una variable la forma de pago
   */
      cCodFpg  := cPgoFacCli( ::oFacCliP:cSerie + Str( ::oFacCliP:nNumFac ) + ::oFacCliP:cSufFac, ::oFacCliT )

      if ::lIsValid()                                                                                 .AND.;
         ::oFacCliP:dPreCob >= ::dIniInf                                                              .AND.;
         ::oFacCliP:dPreCob <= ::dFinInf                                                              .AND.;
         ( ::lAllFpg .or. ( cCodFpg >= ::cFpgDes .AND. cCodFpg <= ::cFpgHas ) )                       .AND.;
         ( ::lAllCli .or. ( ::oFacClip:cCodCli >= ::cCliOrg .AND. ::oFacClip:cCodCli <= ::cCliDes ) ) .AND.;
         lChkSer( ::oFacCliP:cSerie, ::aSer )

         ::oDbf:Append()

         ::oDbf:cCodCli := ::oFacCliP:cCodCli
         if ::oDbfCli:Seek( ::oFacCliP:cCodCli )
            ::oDbf:cNomCli := ::oDbfCli:Titulo
            ::oDbf:cNifCli := ::oDbfCli:Nif
            ::oDbf:cDomCli := ::oDbfCli:Domicilio
            ::oDbf:cPobCli := ::oDbfCli:Poblacion
            ::oDbf:cProCli := ::oDbfCli:Provincia
            ::oDbf:cCdpCli := ::oDbfCli:CodPostal
            ::oDbf:cTlfCli := ::oDbfCli:Telefono
         end if

         ::oDbf:dFecDoc    := ::oFacCliP:dPreCob
         ::oDbf:cForPag    := cCodFpg
         ::oDbf:cNomPgo    := cNbrFPago( cCodFpg, ::oDbfFpg )
         ::oDbf:cNumDoc    := lTrim ( ::oFacCliP:cSerie ) + "/" + lTrim ( Str( ::oFacCliP:nNumFac ) ) + "/" + lTrim ( ::oFacCliP:cSufFac ) + "/" + lTrim ( Str( ::oFacCliP:nNumRec ) )
         ::oDbf:nTotRec    := nTotRecCli( ::oFacCliP, ::oDbfDiv )
         ::oDbf:dFecVen    := ::oFacClip:dFecVto
         ::oDbf:cBanco     := ::oFacCliP:cBncCli
         ::oDbf:cCuenta    := ::oFacCliP:cEntCli + "-" + ::oFacCliP:cSucCli + "-" + ::oFacCliP:cDigCli + "-" + ::oFacCliP:cCtaCli

         ::oDbf:Save()

      end if

      ::oFacCliP:Skip()

      ::oMtrInf:AutoInc( ::oFacCliP:OrdKeyNo() )

   end while

   ::oFacCliP:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacCliP:cFile ) )

   ::oMtrInf:AutoInc( ::oFacCliP:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )
//---------------------------------------------------------------------------//

METHOD lIsValid() CLASS TInfPgoPob

   local lRet  := .t.

   do case
      case ::oEstado:nAt == 1 // "Pendientes"
         lRet  := !::oFacCliP:lCobrado
      case ::oEstado:nAt == 2 // "Cobrados"
         lRet  := ::oFacCliP:lCobrado
      case ::oEstado:nAt == 3 // "Descontados"
         lRet  := ::oFacCliP:lRecDto
      case ::oEstado:nAt == 4 // "Todos"
         lRet  := .t.
   end case

RETURN ( lRet )

//---------------------------------------------------------------------------//