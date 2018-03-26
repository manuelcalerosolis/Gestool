#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION TlAgeVta()

   local oInf
   local aCol  := {}
   local aIdx  := {}

   aAdd( aCol, { "CCODAGE", "C",  3, 0,  {|| "@!" },         "Cod. age.",                 .f., "Código agente",             3 } )
   aAdd( aCol, { "CNOMAGE", "C", 50, 0,  {|| "@!" },         "Agente",                    .f., "Agente",                   25 } )
   aAdd( aCol, { "CCODCLI", "C", 12, 0,  {|| "@!" },         "Cod. cli.",                 .t., "Código cliente",            8 } )
   aAdd( aCol, { "CNOMCLI", "C", 50, 0,  {|| "@!" },         "Cliente",                   .t., "Nombre cliente",           25 } )
   aAdd( aCol, { "CNIFCLI", "C", 15, 0,  {|| "@!" },         "Nif",                       .f., "Nif",                        12 } )
   aAdd( aCol, { "CDOMCLI", "C", 35, 0,  {|| "@!" },         "Domicilio",                 .f., "Domicilio",                  20 } )
   aAdd( aCol, { "CPOBCLI", "C", 35, 0,  {|| "@!" },         "Población",                 .f., "Población",                  25 } )
   aAdd( aCol, { "CPROCLI", "C", 20, 0,  {|| "@!" },         "Provincia",                 .f., "Provincia",                  20 } )
   aAdd( aCol, { "CCDPCLI", "C",  7, 0,  {|| "@!" },         "Cod. pos.",                 .f., "Cod. postal",                 7 } )
   aAdd( aCol, { "CTLFCLI", "C", 12, 0,  {|| "@!" },         "Teléfono",                  .f., "Teléfono",                   12 } )
   aAdd( aCol, { "CREFART", "C", 18, 0,  {|| "@!" },         "Código artículo",                 .f., "Código artículo",            10 } )
   aAdd( aCol, { "CDESART", "C", 50, 0,  {|| "@!" },         "Artículo",                  .f., "Artículo",                   25 } )
   aAdd( aCol, { "NUNDCAJ", "N", 13, 6,  {|| MasUnd() },     "Cajas",                     .f., "Cajas",                       8 } )
   aAdd( aCol, { "NUNDART", "N", 13, 6,  {|| MasUnd() },     "Und.",                      .t., "Unidades",                    8 } )
   aAdd( aCol, { "NCAJUND", "N", 13, 6,  {|| MasUnd() },     "Tot. und.",                 .f., "Total unidades",             10 } )
   aAdd( aCol, { "NBASCOM", "N", 13, 6,  {|| oInf:cPicOut }, "Base",                      .t., "Base comisión",              10 } )
   aAdd( aCol, { "NCOMAGE", "N",  4, 1,  {|| oInf:cPicOut }, "%Com",                      .f., "Porcentaje de comisión",     10 } )
   aAdd( aCol, { "NTOTCOM", "N", 13, 6,  {|| oInf:cPicOut }, "Importe",                   .t., "Importe comisión",           10 } )
   aAdd( aCol, { "CDOCMOV", "C", 14, 0,  {|| "@!" },         "Documento",                 .t., "Documento",                  14 } )
   aAdd( aCol, { "CTIPDOC", "C", 12, 0,  {|| "@!" },         "Tipo",                      .t., "Tipo",                       12 } )
   aAdd( aCol, { "DFECMOV", "D",  8, 0,  {|| "@!" },         "Fecha",                     .t., "Fecha",                       8 } )
   aAdd( aCol, { "CTIPVEN", "C", 20, 0,  {|| "@!" },         "Venta",                     .f., "Tipo de venta",              20 } )

   aAdd( aIdx, { "CNOMAGE", "CNOMAGE + CREFART" } )

   oInf  := TDlAgeVta():New( "Informe detallado de la liquidación de agentes en albaranes de clientes", aCol, aIdx, "01047" )

   oInf:AddGroup( {|| oInf:oDbf:cNomAge },                     {|| "Agente  : " + Rtrim( oInf:oDbf:cNomAge ) + "-" + oRetFld( oInf:oDbf:cNomAge, oInf:oDbfAge ) },  {||"Total agente..."} )
   oInf:AddGroup( {|| oInf:oDbf:cNomAge + oInf:oDbf:cDesArt }, {|| "Artículo: " + Rtrim( oInf:oDbf:cRefArt ) + "-" + Rtrim( oInf:oDbf:cDesArt ) }, {||""} )

   oInf:Resource()
   oInf:Activate()

   oInf:End()
   oInf  := nil

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TDlAgeVta FROM TInfGen

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
   DATA  oIva        AS OBJECT
   DATA  oSay        AS OBJECT
   DATA  cTipVen     AS CHARACTER
   DATA  cTipVen2    AS CHARACTER
   DATA  aEstado     AS ARRAY    INIT  { "No facturado", "Facturado", "Todos" }
   DATA  oIndice     AS OBJECT
   DATA  aIndice     AS ARRAY    INIT  { "Albarán", "Su albarán", "Artículos" }

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TDlAgeVta

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

    /*
   Ficheros necesarios
   */

   BEGIN SEQUENCE

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL  PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL  PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   ::oFacCliP := TDataCenter():oFacCliP()

   DATABASE NEW ::oTpvCliT  PATH ( cPatEmp() ) FILE "TIKET.DBF"   VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTpvCliL  PATH ( cPatEmp() ) FILE "TIKEL.DBF"   VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oDbfCli   PATH ( cPatEmp() ) FILE "CLIENT.DBF"  VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   DATABASE NEW ::oIva      PATH ( cPatDat() ) FILE "TIVA.DBF"    VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TDlAgeVta

   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if
   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if

   if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if

   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if

   if !Empty( ::oFacCliP ) .and. ::oFacCliP:Used()
      ::oFacCliP:End()
   end if

   if !Empty( ::oTpvCliT ) .and. ::oTpvCliT:Used()
      ::oTpvCliT:End()
   end if

   if !Empty( ::oTpvCliL ) .and. ::oTpvCliL:Used()
      ::oTpvCliL:End()
   end if

   if !Empty( ::oDbfCli ) .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if

   if !Empty( ::oIva ) .and. ::oIva:Used()
      ::oIva:End()
   end if

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

      if !lFacturado( ::oAlbCliT )                                                          .AND.;
         ::oAlbCliT:DFECALB >= ::dIniInf                                                    .AND.;
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
                        ::oDbf:cTipDoc := "Albaran"
                        ::oDbf:CREFART := ::oAlbCliL:CREF
                        ::oDbf:CDESART := ::oAlbCliL:cDetalle

                        ::AddCliente( ::oAlbCliT:CCODCLI, ::oAlbCliT, .f. )

                        if ( ::oDbfAge:Seek (::oAlbCliT:cCodAge) )
                           ::oDbf:cNomAge := ::oDbfAge:cApeAge + ", " + ::oDbfAge:cNbrAge
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
                     ::oDbf:cTipDoc := "Albaran"
                     ::oDbf:CREFART := ::oAlbCliL:CREF
                     ::oDbf:CDESART := ::oAlbCliL:cDetalle

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

   /*
   Nos movemos por las cabeceras de los albaranes
   */

   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )

   while ! ::oFacCliT:Eof()

      if ::oFacCliT:DFECFAC >= ::dIniInf                                                    .AND.;
         ::oFacCliT:DFECFAC <= ::dFinInf                                                    .AND.;
         ::oFacCliT:CCODAGE >= ::cAgeOrg                                                    .AND.;
         ::oFacCliT:CCODAGE <= ::cAgeDes                                                    .AND.;
         lChkSer( ::oFacCliT:cSerie, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC )

            while ::oFacCliT:cSerie + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC == ::oFacCliL:cSerie + Str( ::oFacCliL:NNUMFAC ) + ::oFacCliL:CSUFFAC .AND. ! ::oFacCliL:eof()

               if !::oFacCliL:lControl                                              .AND.;
                  ::oFacCliL:CREF >= ::cArtOrg                                      .AND.;
                  ::oFacCliL:CREF <= ::cArtDes                                      .AND.;
                  !( ::lExcImp .and. ( nTotLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 ) )

                  /* Preguntamos y tratamos el tipo de venta */

                  if ::lTvta

                     if  ( if (!Empty( ::cTipVen ), ::oFacCliL:cTipMov == ::cTipVen, .t. ) )

                        ::oDbf:Append()

                        ::oDbf:cCodAge := ::oFacCliT:cCodAge
                        ::oDbf:CCODCLI := ::oFacCliT:CCODCLI
                        ::oDbf:CNOMCLI := ::oFacCliT:CNOMCLI
                        ::oDbf:DFECMOV := ::oFacCliT:DFECFAC
                        ::oDbf:CDOCMOV := ::oFacCliT:cSerie + "/" + Str( ::oFacCliT:NNUMFAC ) + "/" + ::oFacCliT:CSUFFAC
                        ::oDbf:cTipDoc := "Factura"
                        ::oDbf:CREFART := ::oFacCliL:CREF
                        ::oDbf:CDESART := ::oFacCliL:cDetalle

                        ::AddCliente( ::oFacCliT:CCODCLI, ::oFacCliT, .f. )

                        ::oDbf:Save()

                    end if

                /* Pasamos de los tipos de ventas */

                else

                  ::oDbf:Append()

                  ::oDbf:cCodAge := ::oFacCliT:cCodAge
                  ::oDbf:CCODCLI := ::oFacCliT:CCODCLI
                  ::oDbf:CNOMCLI := ::oFacCliT:CNOMCLI
                  ::oDbf:DFECMOV := ::oFacCliT:DFECFAC
                  ::oDbf:CDOCMOV := ::oFacCliT:cSerie + "/" + Str( ::oFacCliT:NNUMFAC ) + "/" + ::oFacCliT:CSUFFAC
                  ::oDbf:cTipDoc := "Factura"
                  ::oDbf:CREFART := ::oFacCliL:CREF
                  ::oDbf:CDESART := ::oFacCliL:cDetalle

                  ::AddCliente( ::oFacCliT:CCODCLI, ::oFacCliT, .f. )

                  if ( ::oDbfAge:Seek ( ::oFacCliT:cCodAge ) )
                     ::oDbf:cNomAge := Rtrim( ::oDbfAge:cApeAge ) + ", " + Rtrim( ::oDbfAge:cNbrAge )
                  end if

                  ::oDbf:NUNDCAJ := ::oFacCliL:nCanEnt
                  ::oDbf:NCAJUND := nTotNFacCli( ::oFacCliL )
                  ::oDbf:NUNDART := ::oFacCliL:nUniCaja
                  ::oDbf:nComAge := ::oFacCliL:nComAge
                  ::oDbf:nBasCom := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )
                  ::oDbf:nTotCom := nComLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                  ::oDbf:Save()

               end if

            end if

            ::oFacCliL:Skip()

            end while

         end if

      end if

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   /*
   Nos movemos por las cabeceras de los albaranes
   */

   ::oMtrInf:SetTotal( ::oTpvCliT:Lastrec() )

   while !::oTpvCliT:Eof()

      if ::oTpvCliT:dFecTik >= ::dIniInf                                                    .AND.;
         ::oTpvCliT:dFecTik <= ::dFinInf                                                    .AND.;
         ::oTpvCliT:cCodAge >= ::cAgeOrg                                                    .AND.;
         ::oTpvCliT:cCodAge <= ::cAgeDes                                                    .AND.;
         ::oTpvCliT:cTipTik == "1"                                                          .AND.;
         lChkSer( ::oTpvCliT:cSerTik, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oTpvCliL:Seek( ::oTpvCliT:cSerTik + ::oTpvCliT:cNumTik + ::oTpvCliT:cSufTik )

            while ::oTpvCliT:cSerTik + ::oTpvCliT:cNumTik + ::oTpvCliT:cSufTik == ::oTpvCliL:cSerTil + ::oTpvCliL:cNumTil + ::oTpvCliL:cSufTil .AND. ! ::oTpvCliL:eof()

               if ::oTpvCliL:cCbaTil >= ::cArtOrg                                      .AND.;
                  ::oTpvCliL:cCbaTil <= ::cArtDes                                      .AND.;
                  !( ::lExcImp .and. nTotLTpv( ::oTpvCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                  ::oDbf:Append()

                  ::oDbf:cCodAge := ::oTpvCliT:cCodAge
                  ::oDbf:CCODCLI := ::oTpvCliT:cCliTik
                  ::oDbf:CNOMCLI := ::oTpvCliT:cNomTik
                  ::oDbf:DFECMOV := ::oTpvCliT:dFecTik
                  ::oDbf:CDOCMOV := ::oTpvCliT:cSerTik + "/" + ::oTpvCliT:cNumTik + "/" + ::oTpvCliT:cSufTik
                  ::oDbf:cTipDoc := "Tiket"
                  ::oDbf:CREFART := ::oTpvCliL:cCbaTil
                  ::oDbf:CDESART := ::oTpvCliL:cNomTil

                  ::AddCliente( ::oTpvCliT:cCliTik, ::oTpvCliT, .t. )

                  if ( ::oDbfAge:Seek ( ::oTpvCliT:cCodAge ) )
                     ::oDbf:cNomAge := Rtrim( ::oDbfAge:cApeAge ) + ", " + Rtrim( ::oDbfAge:cNbrAge )
                  end if

                  ::oDbf:NUNDART := ::oTpvCliL:nUntTil
                  ::oDbf:nComAge := ::oTpvCliT:nComAge
                  ::oDbf:nBasCom := nTotLTpv( ::oTpvCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotCom := nTotComTik( ::oTpvCliT:cSerTik + ::oTpvCliT:cNumTik + ::oTpvCliT:cSufTik, ::oTpvCliT:cAlias, ::oTpvCliL:cAlias, ::nDecOut, ::nDerOut )

                  ::oDbf:Save()

               end if

            ::oTpvCliL:Skip()

            end while

         end if

      end if

      ::oTpvCliT:Skip()

      ::oMtrInf:AutoInc( ::oTpvCliT:OrdKeyNo() )

   end while

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS TDlAgeVta

   local oThis := Self

   ACTIVATE DIALOG ::oDlg CENTER ON INIT ( oThis:oEstado:Hide(), oThis:oSay:Hide(), oThis:oBtnData:Hide() )

RETURN ( ::oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//