#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"
//---------------------------------------------------------------------------//

CLASS TDlArtVta FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  lTvta       AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacCliP    AS OBJECT
   DATA  oTpvCliT    AS OBJECT
   DATA  oTpvCliL    AS OBJECT
   DATA  oDbfTvta    AS OBJECT
   DATA  oIva        AS OBJECT
   DATA  oSay        AS OBJECT
   DATA  cTipVen     AS CHARACTER
   DATA  cTipVen2    AS CHARACTER
   DATA  aEstado     AS ARRAY    INIT  { "No facturado", "Facturado", "Todos" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodAge", "C",  3, 0,  {|| "@!" },         "Cod. age.",                 .f., "Código agente",               3 )
   ::AddField( "cNomAge", "C", 50, 0,  {|| "@!" },         "Agente",                    .f., "Agente",                     25 )
   ::AddField( "cCodCli", "C", 12, 0,  {|| "@!" },         "Cod. cli.",                 .t., "Código cliente",              8 )
   ::AddField( "cNomCli", "C", 50, 0,  {|| "@!" },         "Cliente",                   .t., "Nombre cliente",             25 )
   ::AddField( "cNifCli", "C", 15, 0,  {|| "@!" },         "Nif",                       .f., "Nif",                        12 )
   ::AddField( "cDomCli", "C", 35, 0,  {|| "@!" },         "Domicilio",                 .f., "Domicilio",                  20 )
   ::AddField( "cPobCli", "C", 25, 0,  {|| "@!" },         "Población",                 .f., "Población",                  25 )
   ::AddField( "cProCli", "C", 20, 0,  {|| "@!" },         "Provincia",                 .f., "Provincia",                  20 )
   ::AddField( "cCdpCli", "C",  7, 0,  {|| "@!" },         "Cod. pos.",                 .f., "Cod. postal",                 7 )
   ::AddField( "cTlfCli", "C", 12, 0,  {|| "@!" },         "Teléfono",                  .f., "Teléfono",                   12 )
   ::AddField( "cDefI01", "C",100, 0,  {|| "@!" },         {|| ::cNameIniCli(1) },      .f., {|| ::cNameIniCli(1) },       50 )
   ::AddField( "cDefI02", "C",100, 0,  {|| "@!" },         {|| ::cNameIniCli(2) },      .f., {|| ::cNameIniCli(2) },       50 )
   ::AddField( "cDefI03", "C",100, 0,  {|| "@!" },         {|| ::cNameIniCli(3) },      .f., {|| ::cNameIniCli(3) },       50 )
   ::AddField( "cDefI04", "C",100, 0,  {|| "@!" },         {|| ::cNameIniCli(4) },      .f., {|| ::cNameIniCli(4) },       50 )
   ::AddField( "cDefI05", "C",100, 0,  {|| "@!" },         {|| ::cNameIniCli(5) },      .f., {|| ::cNameIniCli(5) },       50 )
   ::AddField( "cDefI06", "C",100, 0,  {|| "@!" },         {|| ::cNameIniCli(6) },      .f., {|| ::cNameIniCli(6) },       50 )
   ::AddField( "cDefI07", "C",100, 0,  {|| "@!" },         {|| ::cNameIniCli(7) },      .f., {|| ::cNameIniCli(7) },       50 )
   ::AddField( "cDefI08", "C",100, 0,  {|| "@!" },         {|| ::cNameIniCli(8) },      .f., {|| ::cNameIniCli(8) },       50 )
   ::AddField( "cDefI09", "C",100, 0,  {|| "@!" },         {|| ::cNameIniCli(9) },      .f., {|| ::cNameIniCli(9) },       50 )
   ::AddField( "cDefI10", "C",100, 0,  {|| "@!" },         {|| ::cNameIniCli(10)},      .f., {|| ::cNameIniCli(10)},       50 )
   ::AddField( "cDocMov", "C", 14, 0,  {|| "@!" },         "Albaran",                   .t., "Albaran",                    14 )
   ::AddField( "cCsuAlb", "C", 14, 0,  {|| "@!" },         "Su alb",                    .t., "Su albaran",                 14 )
   ::AddField( "dFecMov", "D",  8, 0,  {|| "@!" },         "Fecha",                     .f., "Fecha",                       8 )
   ::AddField( "cRefArt", "C", 18, 0,  {|| "@!" },         "Cod. art.",                 .t., "Código artículo",            10 )
   ::AddField( "cDesArt", "C", 50, 0,  {|| "@!" },         "Artículo",                  .t., "Artículo",                   25 )
   ::AddField( "nUndCaj", "N", 16, 6,  {|| MasUnd() },     "Caj.",                      .f., "Cajas",                       8 )
   ::AddField( "nUndArt", "N", 16, 6,  {|| MasUnd() },     "Und.",                      .f., "Unidades",                    8 )
   ::AddField( "nCajUnd", "N", 16, 6,  {|| MasUnd() },     "Tot. und.",                 .t., "Total unidades",             10 )
   ::AddField( "cTipVen", "C", 20, 0,  {|| "@!" },         "Venta",                     .f., "Tipo de venta",              20 )
   ::AddField( "nBasCom", "N", 16, 6,  {|| ::cPicOut },    "Base",                      .t., "Base comisión",              10 )
   ::AddField( "nComAge", "N",  4, 1,  {|| ::cPicOut },    "%Com",                      .t., "Porcentaje de comisión",     10 )
   ::AddField( "nTotCom", "N", 16, 6,  {|| ::cPicOut },    "Comisión",                  .t., "Importe comisión",           10 )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TDlAgeVta

   /*
   Ficheros necesarios
   */

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL  PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   DATABASE NEW ::oDbfCli   PATH ( cPatCli() ) FILE "CLIENT.DBF"  VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   DATABASE NEW ::oDbfTvta  PATH ( cPatDat() ) FILE "TVTA.DBF"    VIA ( cDriver() ) SHARED INDEX "TVTA.CDX"

   DATABASE NEW ::oIva      PATH ( cPatDat() ) FILE "TIVA.DBF"    VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TDlAgeVta

   ::oAlbCliT:End()
   ::oAlbCliL:End()
   ::oDbfTvta:End()
   ::oDbfCli:End()
   ::oIva:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TDlAgeVta

   local oTipVen
   local oTipVen2
   local cEstado     := "Todos"
   local This        := Self
   local cIndice     := "Albarán"

   if !::StdResource( "INF_GEN17A" )
      return .f.
   end if

   /*
   Monta los agentes de manera automatica
   */

   ::oDefAgeInf( 70, 80, 90, 100 )

   /*
   Monta los articulos de manera automatica
   */

   ::lDefArtInf( 110, 120, 130, 140 )

   REDEFINE CHECKBOX ::lTvta ;
      ID       260 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oTipVen VAR ::cTipVen ;
      VALID    ( cTVta( oTipVen, This:oDbfTvta:cAlias, oTipVen2 ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwTVta( oTipVen, This:oDbfTVta:cAlias, oTipVen2 ) ) ;
      ID       270 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oTipVen2 VAR ::cTipVen2 ;
      ID       280 ;
      WHEN     ( .F. ) ;
      COLOR    CLR_GET ;
      OF       ::oFld:aDialogs[1]

   ::oMtrInf:SetTotal( ::oAlbCliT:Lastrec() )

   ::oDefResInf()

   REDEFINE SAY ::oSay ;
      ID       217 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TDlAgeVta

   local lExcCero := .f.

   ::oDlg:Disable()

   ::oDbf:Zap()
   ::oAlbCliT:GoTop()

   ::aHeader      :={{|| "Fecha   : "   + Dtoc( Date() ) },;
                     {|| "Periodo : "   + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Agentes : "   + ::cAgeOrg         + " > " + ::cAgeDes },;
                     {|| if ( ::lTvta, (if (!Empty( ::cTipVen ), "Tipo de Venta: " + ::cTipVen2, "Tipo de Venta: Todos" ) ), "Tipo de Venta: Ninguno" ) },;
                     {|| if( ::lTvta, "Aplicando comportamiento de los tipos de venta", "" ) } }

	/*
   Nos movemos por las cabeceras de los albaranes
   */

   ::oMtrInf:SetTotal( ::oAlbCliT:Lastrec() )

   while ! ::oAlbCliT:Eof()

      if ::oAlbCliT:DFECALB >= ::dIniInf                                                    .AND.;
         ::oAlbCliT:DFECALB <= ::dFinInf                                                    .AND.;
         ::oAlbCliT:CCODAGE >= ::cAgeOrg                                                    .AND.;
         ::oAlbCliT:CCODAGE <= ::cAgeDes                                                    .AND.;
         lChkSer( ::oAlbCliT:CSERALB, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oAlbCliL:Seek( ::oAlbCliT:CSERALB + Str( ::oAlbCliT:NNUMALB ) + ::oAlbCliT:CSUFALB )

            while ::oAlbCliT:CSERALB + Str( ::oAlbCliT:NNUMALB ) + ::oAlbCliT:CSUFALB == ::oAlbCliL:CSERALB + Str( ::oAlbCliL:NNUMALB ) + ::oAlbCliL:CSUFALB .AND. ! ::oAlbCliL:eof()

               if ::oAlbCliL:CREF >= ::cArtOrg                                      .AND.;
                  ::oAlbCliL:CREF <= ::cArtDes                                      .AND.;
                  !( ::lExcImp .and. ( nTotLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 ) )

                  /*
                  Preguntamos y tratamos el tipo de venta
                  */

                  if ::lTvta

                     if  ( if (!Empty( ::cTipVen ), ::oAlbCliL:cTipMov == ::cTipVen, .t. ) )

                        ::oDbf:Append()

                        ::oDbf:cCodAge := ::oAlbCliT:cCodAge
                        ::oDbf:CCODCLI := ::oAlbCliT:CCODCLI
                        ::oDbf:CNOMCLI := ::oAlbCliT:CNOMCLI
                        ::oDbf:DFECMOV := ::oAlbCliT:DFECALB
                        ::oDbf:CDOCMOV := ::oAlbCliT:CSERALB + "/" + Str( ::oAlbCliT:NNUMALB ) + "/" + ::oAlbCliT:CSUFALB
                        ::oDbf:cCsuAlb := ::oAlbCliT:cCodSuAlb
                        ::oDbf:CREFART := ::oAlbCliL:CREF
                        ::oDbf:CDESART := ::oAlbCliL:cDetalle

                        ::AddCliente( ::oAlbCliT:CCODCLI, ::oAlbCliT, .f. )

                        if ( ::oDbfAge:Seek (::oAlbCliT:cCodAge) )
                           ::oDbf:cNomAge := ::oDbfAge:cApeAge + ", " + ::oDbfAge:cNbrAge
                        end if

                        if ::oDbfTvta:Seek( ::oAlbCliL:cTipMov )
                           ::oDbf:cTipVen    := ::oDbfTvta:cDesMov

                           if ::oDbfTvta:nUndMov == 1
                              ::oDbf:NUNDCAJ := ::oAlbCliL:NCANENT
                              ::oDbf:NCAJUND := nTotNAlbCli( ::oAlbCliL )
                              ::oDbf:NUNDART := ::oAlbCliL:NUNICAJA
                           elseif ::oDbfTvta:nUndMov == 2
                              ::oDbf:NUNDCAJ := - ::oAlbCliL:NCANENT
                              ::oDbf:NCAJUND := - nTotNAlbCli( ::oAlbCliL )
                              ::oDbf:NUNDART := - ::oAlbCliL:NUNICAJA
                           elseif ::oDbfTvta:nUndMov == 3
                              ::oDbf:NUNDCAJ := 0
                              ::oDbf:NCAJUND := 0
                              ::oDbf:NUNDART := 0
                           end if

                           if ::oDbfTvta:nImpMov == 3
                              ::oDbf:nComAge := 0
                              ::oDbf:nBasCom := 0
                              ::oDbf:nTotCom := 0
                           else
                              ::oDbf:nComAge := ::oAlbCliL:nComAge
                              ::oDbf:nBasCom := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )
                              ::oDbf:nTotCom := nComLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )
                           end if

                        end if

                        ::oDbf:Save()

                    end if

                  /*
                  Pasamos de los tipos de ventas
                  */

                  else

                     ::oDbf:Append()

                     ::oDbf:cCodAge := ::oAlbCliT:cCodAge
                     ::oDbf:CCODCLI := ::oAlbCliT:CCODCLI
                     ::oDbf:CNOMCLI := ::oAlbCliT:CNOMCLI
                     ::oDbf:DFECMOV := ::oAlbCliT:DFECALB
                     ::oDbf:CDOCMOV := ::oAlbCliT:CSERALB + "/" + Str( ::oAlbCliT:NNUMALB ) + "/" + ::oAlbCliT:CSUFALB
                     ::oDbf:CREFART := ::oAlbCliL:CREF
                     ::oDbf:CDESART := ::oAlbCliL:cDetalle
                     ::oDbf:cCsuAlb := ::oAlbCliT:cCodSuAlb

                     ::AddCliente( ::oAlbCliT:CCODCLI, ::oAlbCliT, .f. )

                     if ( ::oDbfAge:Seek (::oAlbCliT:cCodAge) )
                        ::oDbf:cNomAge := ::oDbfAge:cApeAge + ", " + ::oDbfAge:cNbrAge
                     end if

                     ::oDbf:NUNDCAJ := ::oAlbCliL:NCANENT
                     ::oDbf:NCAJUND := NotCaja( ::oAlbCliL:NCANENT )* ::oAlbCliL:NUNICAJA
                     ::oDbf:NUNDART := ::oAlbCliL:NUNICAJA
                     ::oDbf:nComAge := ( ::oAlbCliL:nComAge )
                     ::oDbf:nBasCom := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )
                     ::oDbf:nTotCom := nComLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )

                     ::oDbf:Save()

                  end if

               end if

               ::oAlbCliL:Skip()

            end while

         end if

      end if

      ::oAlbCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS TDlAgeVta

   local oThis := Self

   ACTIVATE DIALOG ::oDlg CENTER ON INIT ( oThis:oEstado:Hide(), oThis:oSay:Hide(), oThis:oBtnData:Hide() )

RETURN ( ::oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//