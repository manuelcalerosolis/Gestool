#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TEmiRec FROM TInfGen

   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacCliP    AS OBJECT
   DATA  oAntCliT    AS OBJECT
   DATA  oDbfIva     AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

   METHOD GetMedia()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "CCODCLI", "C", 12, 0, {|| "@!" },         "Código",                    .f., "Código cliente"            ,  8, .f.)
   ::AddField( "CNOMCLI", "C", 50, 0, {|| "@!" },         "Cliente",                   .f., "Nombre cliente"            , 25, .f.)
   ::AddField( "CNIFCLI", "C", 15, 0, {|| "@!" },         "Nif",                       .f., "Nif"                       ,  8, .f.)
   ::AddField( "CDOMCLI", "C", 35, 0, {|| "@!" },         "Domicilio",                 .f., "Domicilio"                 , 25, .f.)
   ::AddField( "CPOBCLI", "C", 25, 0, {|| "@!" },         "Población",                 .f., "Población"                 , 20, .f.)
   ::AddField( "CPROCLI", "C", 20, 0, {|| "@!" },         "Provincia",                 .f., "Provincia"                 , 20, .f.)
   ::AddField( "CCDPCLI", "C",  7, 0, {|| "@!" },         "CP",                        .f., "Cod. postal"               , 20, .f.)
   ::AddField( "CTLFCLI", "C", 12, 0, {|| "@!" },         "Tlf.",                      .f., "Teléfono"                  ,  7, .f.)
   ::AddField( "CCODAGE", "C",  3, 0, {|| "@!" },         "Cod. age.",                 .f., "Código agente"             , 14, .f.)
   ::AddField( "CNOMAGE", "C", 40, 0, {|| "@!" },         "Agente",                    .f., "Nombre agente"             , 14, .f.)
   ::AddField( "CDOCMOV", "C", 18, 0, {|| "@!" },         "Recibo",                    .t., "Recibo"                    , 14, .f.)
   ::AddField( "NTOTDOC", "N", 16, 6, {|| ::cPicOut },    "Tot. Rec",                  .t., "Total recibo"              , 10, .t.)
   ::AddField( "DFECMOV", "D",  8, 0, {|| "@!" },         "Exped.",                    .t., "Fecha de expedición"       , 14, .f.)
   ::AddField( "DFECCOB", "D",  8, 0, {|| "@!" },         "Cobro",                     .t., "Fecha de cobro"            , 14, .f.)
   ::AddField( "NTOTDIA", "N", 16, 0, {|| "999" },        "Dias",                      .t., "Dias transcurridos"        ,  4, .t.)
   ::AddField( "NTOTFAC", "N", 16, 6, {|| ::cPicOut },    "Tot. Fac",                  .f., "Total factura"             , 10, .t.)
   ::AddField( "NTOTCOB", "N", 16, 6, {|| ::cPicOut },    "Tot. Cob",                  .f., "Total cobrado"             , 10, .t.)
   ::AddField( "NTOTPEN", "N", 16, 6, {|| ::cPicOut },    "Tot. Pen",                  .f., "Total pendiente"           , 10, .t.)
   ::AddField( "CBANCO",  "C", 50, 0, {|| "@!" },         "Banco",                     .f., "Nombre del banco"          , 20, .f. )
   ::AddField( "CCUENTA", "C", 30, 0, {|| "@!" },         "Cuenta",                    .f., "Cuenta bancaria"           , 35, .f. )

   ::AddTmpIndex( "cCodCli", "cCodCli" )

   ::AddGroup( {|| ::oDbf:cCodCli }, {|| "Cliente : " + Rtrim( ::oDbf:cCodCli ) + "-" + Rtrim( ::oDbf:cNomCli ) }, {||"Media pago " + ::GetMedia() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oFacCliT     := TDataCenter():oFacCliT()  

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE  "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   ::oFacCliP := TDataCenter():oFacCliP()

   DATABASE NEW ::oAntCliT PATH ( cPatEmp() ) FILE  "ANTCLIT.DBF" VIA ( cDriver() ) SHARED INDEX "ANTCLIT.CDX"

   DATABASE NEW ::oDbfIva  PATH ( cPatDat() ) FILE  "TIVA.DBF" VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

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

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INF_GEN28B" )
      return .f.
   end if

   /*
   Montamos agentes
   */

   if !::oDefCliInf( 70, 71, 80, 81, , 600)
      return .f.
   end if

   /*
   Montamos agentes
   */

   if !::oDefAgeInf( 90, 91, 100, 101, 110 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oFacCliP:Lastrec() )

   ::CreateFilter( aItmRecCli(), ::oFacCliP:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead := ""
   local cCodAge  := ""
   local nTotDia  := 0

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader   := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Clientes: " + ::cCliOrg         + " > " + ::cCliDes         },;
                     {|| "Agentes : " + if ( !Empty( ::cAgeOrg ),( ::cAgeOrg + " > " + ::cAgeDes ), "Todos" ) } }

   /*
   Nos movemos por las cabeceras de los facturas de clientes
	*/

   ::oFacCliP:OrdSetFocus( "NNUMFAC" )

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       := ::oFilter:cExpresionFilter
   else
      cExpHead       := '.t.'
   end if

   ::oFacCliP:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacCliP:cFile ), ::oFacCliP:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oFacCliP:GoTop()
   while !::lBreak .and. !::oFacCliP:Eof()

      /*
      Condiciones de liquidación, fechas, clientes, agentes y rutas
      */

      cCodAge  := cAgeFacCli( ::oFacCliP:cSerie + Str( ::oFacCliP:nNumFac ) + ::oFacCliP:cSufFac, ::oFacCliT )

      if ::oFacCliP:lCobrado                                                                             .AND.;
         ( ::lAllCli .or. ( ::oFacCliP:cCodCli >= ::cCliOrg .AND. ::oFacCliP:cCodCli <= ::cCliDes ) )    .AND.;
         ::oFacCliP:dPreCob >= ::dIniInf                                                                 .AND.;
         ::oFacCliP:dPreCob <= ::dFinInf                                                                 .AND.;
         ( ::lAgeAll .or. ( cCodAge >= ::cAgeOrg .AND. cCodAge <= ::cAgeDes ) )                          .AND.;
         lChkSer( ::oFacCliP:cSerie, ::aSer )

         /*
         Si cumple todas, empezamos a añadir
         */

         ::oDbf:Append()

         ::oDbf:cDocMov := lTrim ( ::oFacCliP:cSerie ) + "/" + lTrim ( Str( ::oFacCliP:nNumFac ) ) + "/" + lTrim ( ::oFacCliP:cSufFac ) + "/" + lTrim ( Str( ::oFacCliP:nNumRec ) )
         ::oDbf:cCodCli := ::oFacCliP:cCodCli
         ::oDbf:cNomCli := ::oFacCliT:cNomCli

         ::AddCliente( ::oFacCliT:cCodCli, ::oFacCliT, .f. )

         ::oDbf:dFecMov := ::oFacCliP:dPreCob
         ::oDbf:dFecCob := ::oFacCliP:dEntrada
         ::oDbf:nTotDoc := nTotRecCli( ::oFacCliP:cAlias, ::oDbfDiv:cAlias, ::cDivInf )
         ::oDbf:nTotFac := nTotFacCli( ::oFacCliP:cSerie + Str( ::oFacCliP:nNumFac ) + ::oFacCliP:cSufFac, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacCliP:cAlias, ::oAntCliT:cAlias )
         ::oDbf:nTotCob := nPagFacCli( ::oFacCliP:cSerie + Str( ::oFacCliP:nNumFac ) + ::oFacCliP:cSufFac, ::oFacCliT:cAlias, ::oFacCliP:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::cDivInf,.t. )
         ::oDbf:nTotDia := ::oFacCliP:dEntrada - ::oFacCliP:dPreCob
         ::oDbf:nTotPen := ::oDbf:nTotCob - ::oDbf:nTotFac
         ::oDbf:cBanco  := ::oFacCliP:cBncCli
         ::oDbf:cCuenta := ::oFacCliP:cEntCli + "-" + ::oFacCliP:cSucCli + "-" + ::oFacCliP:cDigCli + "-" + ::oFacCliP:cCtaCli

         ::oDbf:cCodAge := cCodAge
         ::oDbf:cNomAge := RetNbrAge( cCodAge, ::oDbfAge:cAlias )

         ::oDbf:Save()

      end if

      ::oFacCliP:Skip()

      ::oMtrInf:AutoInc( ::oFacCliP:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oFacCliP:LastRec() )

   ::oFacCliP:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacCliP:cFile ) )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD GetMedia()

   local nTot  := 0
   local nCon  := 0
   local cPic  := "999"
   local nCol  := aScan( ::oReport:aColumns, {|o| o:Cargo == "Dias" } )

   if nCol != 0
      nTot     := ::oReport:aColumns[ nCol ]:nTotal
      cPic     := ::oReport:aColumns[ nCol ]:cTotalPict
   end if

   nCon        := ::oReport:aGroups[ 1 ]:nCounter


   if nCon != 0 .and. nTot != 0
      nTot     := nTot / nCon
   end if

RETURN ( Alltrim( Trans( nTot, cPic ) ) )

//---------------------------------------------------------------------------//