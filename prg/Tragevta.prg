#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"
//---------------------------------------------------------------------------//

CLASS TrlAgeVta FROM TInfGen

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
   DATA  aEstado     AS ARRAY    INIT  { "No Facturado", "Facturado", "Todos" }
   DATA  oIndice     AS OBJECT
   DATA  aIndice     AS ARRAY    INIT  { "Albarán", "Su Albarán", "Artículos" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

   METHOD AddTipAlb( cTipMov )

   METHOD AddTipFac( cTipMov )

   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField ( "cCodAge", "C",  3, 0,  {|| "@!" },         "Cod. age.",     .f., "Código agente",            3 )
   ::AddField ( "cNomAge", "C", 50, 0,  {|| "@!" },         "Agente",        .f., "Nombre agente",           25 )
   ::AddField ( "cRefArt", "C", 18, 0,  {|| "@!" },         "Código artículo",     .t., "Código artículo",         10 )
   ::AddField ( "cDesArt", "C", 50, 0,  {|| "@!" },         "Artículo",      .t., "Artículo",                35 )
   ::AddField ( "nUndCaj", "N", 16, 6,  {|| MasUnd () },    "Cajas",         .f., "Cajas",                    8 )
   ::AddField ( "nUndArt", "N", 16, 6,  {|| MasUnd () },    "Und.",          .t., "Unidades",                 8 )
   ::AddField ( "nCajUnd", "N", 16, 6,  {|| MasUnd () },    "Tot. und.",     .f., "Total unidades",          10 )
   ::AddField ( "nBasCom", "N", 16, 6,  {|| ::cPicOut },    "Base",          .t., "Base comisión",           10 )
   ::AddField ( "nComAge", "N",  5, 2,  {|| "@E 99,99" },   "%Com",          .t., "Porcentaje de comisión",  10 )
   ::AddField ( "nTotCom", "N", 16, 6,  {|| ::cPicOut },    "Importe",       .t., "Importe comisión",        10 )
   ::AddField ( "cDocMov", "C", 14, 0,  {|| "@!" },         "Doc.",          .t., "Documento",               14 )
   ::AddField ( "cTipDoc", "C", 12, 0,  {|| "@!" },         "Tipo",          .t., "Tipo",                    12 )
   ::AddField ( "dFecMov", "D",  8, 0,  {|| "@!" },         "Fecha",         .f., "Fecha",                    8 )
   ::AddField ( "cTipVen", "C", 20, 0,  {|| "@!" },         "Venta",         .f., "Tipo de venta",           20 )

   ::AddTmpIndex( "cCodAge", "cCodAge + cRefArt" )

   ::AddGroup( {|| ::oDbf:cCodAge }, {|| "Agente  : " + Rtrim( ::oDbf:cCodAge ) + "-" + oRetFld( ::oDbf:cCodAge, ::oDbfAge ) }, {||"Total agente..."} )


RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TDAgeVta

   /*
   Ficheros necesarios
   */

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL  PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL  PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   ::oFacCliP := TDataCenter():oFacCliP()

   DATABASE NEW ::oTpvCliT  PATH ( cPatEmp() ) FILE "TIKET.DBF"   VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTpvCliL  PATH ( cPatEmp() ) FILE "TIKEL.DBF"   VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oDbfCli   PATH ( cPatEmp() ) FILE "CLIENT.DBF"  VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   DATABASE NEW ::oIva      PATH ( cPatDat() ) FILE "TIVA.DBF"    VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TDAgeVta

   ::oAlbCliT:End()
   ::oAlbCliL:End()
   ::oFacCliT:End()
   ::oFacCliL:End()
   ::oFacCliP:End()
   ::oTpvCliT:End()
   ::oTpvCliL:End()
   ::oDbfCli:End()
   ::oIva:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TrlAgeAlb

   local oTipVen
   local oTipVen2
   local cEstado     := "Todos"
   local This        := Self

   if !::StdResource( "INF_GEN17" )
      return .f.
   end if

   /*
   Monta los agentes de manera automatica
   */

   ::oDefAgeInf( 70, 80, 90, 100 )

   /*
   Monta los articulos de manera automatica
   */

   ::lDefArtInf( 150, 160, 170, 180 )

   /*
   Damos valor al meter
   */

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

METHOD lGenerate() CLASS TrlAgeAlb

   local lExcCero := .f.

   ::oDlg:Disable()

   ::oDbf:Zap()
   ::oAlbCliT:GoTop()

   ::aHeader      := {{||"Fecha   : "   + Dtoc( Date() ) },;
                     {|| "Periodo : "   + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Agentes : "   + ::cAgeOrg         + " > " + ::cAgeDes },;
                     {|| if ( ::lTvta,( if (!Empty( ::cTipVen ), "Tipo de Venta: " + ::cTipVen2, "Tipo de Venta: Todos" ) ), "Tipo de Venta: Ninguno" ) },;
                     {|| if( ::lTvta, "Aplicando comportamiento de los tipos de venta", "" ) } }

   /*
   Nos movemos por las cabeceras de los albaranes
   */

   ::oMtrInf:SetTotal( ::oAlbCliT:Lastrec() )

   while !::oAlbCliT:Eof()

      if ::oAlbCliT:DFECALB >= ::dIniInf                                                    .AND.;
         ::oAlbCliT:DFECALB <= ::dFinInf                                                    .AND.;
         ::oAlbCliT:CCODAGE >= ::cAgeOrg                                                    .AND.;
         ::oAlbCliT:CCODAGE <= ::cAgeDes                                                    .AND.;
         lChkSer( ::oAlbCliT:CSERALB, ::aSer )                                              .AND.;
         ::oAlbCliL:Seek( ::oAlbCliT:CSERALB + Str( ::oAlbCliT:NNUMALB ) + ::oAlbCliT:CSUFALB )

         while ::oAlbCliT:CSERALB + Str( ::oAlbCliT:NNUMALB ) + ::oAlbCliT:CSUFALB == ::oAlbCliL:CSERALB + Str( ::oAlbCliL:NNUMALB ) + ::oAlbCliL:CSUFALB .AND. ! ::oAlbCliL:eof()

            if !::oAlbCliL:lControl

              if ::oDbf:Seek( ::oAlbCliT:cCodAge + ::oAlbCliL:cRef )

                 ::oDbf:Load()

                 ::oDbf:NUNDCAJ += ::oAlbCliL:NCANENT
                 ::oDbf:NCAJUND += nTotNAlbCli( ::oAlbCliL )
                 ::oDbf:NUNDART += ::oAlbCliL:NUNICAJA
                 ::oDbf:nComAge := ::oAlbCliL:nComAge
                 ::oDbf:nBasCom += nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f. )
                 ::oDbf:nTotCom += nComLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                 ::oDbf:Save()

              else

                 ::oDbf:Append()

                 ::oDbf:cCodAge := ::oAlbCliT:cCodAge
                 ::oDbf:CDOCMOV := ::oAlbCliT:cSerAlb + "/" + Str( ::oAlbCliT:nNumAlb ) + "/" + ::oAlbCliT:cSufAlb
                 ::oDbf:CTIPDOC := "Albaran"
                 ::oDbf:CREFART := ::oAlbCliL:CREF
                 ::oDbf:CDESART := ::oAlbCliL:cDetalle

                 if ::oDbfAge:Seek( ::oAlbCliT:cCodAge )
                    ::oDbf:cNomAge := ::oDbfAge:cApeAge + ", " + ::oDbfAge:cNbrAge
                 end if

                 ::oDbf:NUNDCAJ := ::oAlbCliL:NCANENT
                 ::oDbf:NCAJUND := nTotNAlbCli( ::oAlbCliL )
                 ::oDbf:NUNDART := ::oAlbCliL:NUNICAJA
                 ::oDbf:nComAge := ::oAlbCliL:nComAge
                 ::oDbf:nBasCom := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f. )
                 ::oDbf:nTotCom := nComLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                 ::oDbf:Save()

              end if

            end if

            ::oAlbCliL:Skip()

         end while

      end if

      ::oAlbCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )

   WHILE !::oFacCliT:Eof()

      IF ::oFacCliT:DFECFAC >= ::dIniInf                                                     .AND.;
         ::oFacCliT:DFECFAC <= ::dFinInf                                                     .AND.;
         ::oFacCliT:CCODAGE >= ::cAgeOrg                                                     .AND.;
         ::oFacCliT:CCODAGE <= ::cAgeDes                                                     .AND.;
         lChkSer( ::oFacCliT:cSerie, ::aSer )                                                .AND.;
         ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC )

         while ::oFacCliT:cSerie + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC == ::oFacCliL:cSerie + Str( ::oFacCliL:NNUMFAC ) + ::oFacCliL:CSUFFAC .AND.;
               ! ::oFacCliL:eof()

            if !::oFacCliL:lControl                                              .AND.;
               ::oFacCliL:cRef >= ::cArtOrg                                      .AND.;
               ::oFacCliL:cRef <= ::cArtDes                                      .AND.;
               !( ::lExcImp .and. ( nTotLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 ) )

               /*
               Preguntamos y tratamos el tipo de venta
               */

              if ::oDbf:Seek( ::oFacCliT:cCodAge + ::oFacCliL:cRef )

                 ::oDbf:Load()

                 ::oDbf:NUNDCAJ += ::oFacCliL:NCANENT
                 ::oDbf:NUNDART += ::oFacCliL:NUNICAJA
                 ::oDbf:NCAJUND += nTotNFacCli( ::oFacCliL )
                 ::oDbf:nBasCom += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )
                 ::oDbf:nTotCom += nComLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                 ::oDbf:Save()

              else

                 ::oDbf:Append()

                 ::oDbf:cCodAge := ::oFacCliT:cCodAge
                 ::oDbf:CDOCMOV := ::oFacCliT:cSerie + "/" + Str( ::oFacCliT:nNumFac ) + "/" + ::oFacCliT:cSufFac
                 ::oDbf:CTIPDOC := "Factura"
                 ::oDbf:CREFART := ::oFacCliL:cRef
                 ::oDbf:CDESART := ::oFacCliL:cDetalle

                 if ::oDbfAge:Seek( ::oFacCliT:cCodAge )
                 ::oDbf:cNomAge := ::oDbfAge:cApeAge + ", " + ::oDbfAge:cNbrAge
                 end if

                 ::oDbf:NUNDCAJ := ::oFacCliL:NCANENT
                 ::oDbf:NUNDART := ::oFacCliL:NUNICAJA
                 ::oDbf:NCAJUND := nTotNFacCli( ::oFacCliL )
                 ::oDbf:nBasCom := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )
                 ::oDbf:nTotCom := nComLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                 ::oDbf:Save()

              end if

            end if

            ::oFacCliL:Skip()

         end while

      end if

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:SetTotal( ::oTpvCliT:Lastrec() )

   while ! ::oTpvCliT:Eof()

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
                  ::oDbf:DFECMOV := ::oTpvCliT:dFecTik
                  ::oDbf:CDOCMOV := ::oTpvCliT:cSerTik + "/" + ::oTpvCliT:cNumTik + "/" + ::oTpvCliT:cSufTik
                  ::oDbf:CTIPDOC := "Tiket"
                  ::oDbf:CREFART := ::oTpvCliL:cCbaTil
                  ::oDbf:CDESART := ::oTpvCliL:cNomTil

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

METHOD AddTipAlb( cTipMov )
  

RETURN NIL

//---------------------------------------------------------------------------//

METHOD AddTipFac( cTipMov ) CLASS TrlAgeVta
  

RETURN nil

//---------------------------------------------------------------------------//

METHOD Activate() CLASS TrlAgeVta

   local oThis := Self

   ACTIVATE DIALOG ::oDlg CENTER ON INIT ( oThis:oEstado:Hide(), oThis:oSay:Hide(), oThis:oBtnData:Hide() )

RETURN ( ::oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//