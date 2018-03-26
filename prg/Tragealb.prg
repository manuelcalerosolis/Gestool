#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TrlAgeAlb FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  lTvta       AS LOGIC    INIT .f.
   DATA  lRes        AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
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

   METHOD AddTipVta( cTipMov )

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField ( "CCODAGE", "C",  3, 0,  {|| "@!" },         "Cod. age.",                 .f., "Código agente",               3 )
   ::AddField ( "CNOMAGE", "C", 50, 0,  {|| "@!" },         "Agente",                    .f., "Nombre agente",              25 )
   ::AddField ( "CREFART", "C", 18, 0,  {|| "@!" },         "Código artículo",                 .t., "Código artículo",            10 )
   ::AddField ( "CDESART", "C", 50, 0,  {|| "@!" },         "Artículo",                  .t., "Artículo",                   35 )
   ::AddField ( "NUNDCAJ", "N", 16, 6,  {|| MasUnd () },    "Cajas",                     .f., "Cajas",                       8 )
   ::AddField ( "NUNDART", "N", 16, 6,  {|| MasUnd () },    "Und.",                      .t., "Unidades",                    8 )
   ::AddField ( "NCAJUND", "N", 16, 6,  {|| MasUnd () },    "Caj x Und",                 .f., "Cajas x unidades",           10 )
   ::AddField ( "NBASCOM", "N", 16, 6,  {|| ::cPicOut },    "Base",                      .t., "Base comisión",              10 )
   ::AddField ( "NCOMAGE", "N",  5, 2,  {|| "@E 99,99" },   "%Com",                      .t., "Porcentaje de comisión",     10 )
   ::AddField ( "NTOTCOM", "N", 16, 6,  {|| ::cPicOut },    "Importe",                   .t., "Importe Comisión",           10 )
   ::AddField ( "CDOCMOV", "C", 14, 0,  {|| "@!" },         "N/Albaran",                 .f., "Nuestro albarán",            14 )
   ::AddField ( "CCSUALB", "C", 12, 0,  {|| "@!" },         "S/Albaran",                 .f., "Su Albaran Nº",              12 )
   ::AddField ( "DFECMOV", "D",  8, 0,  {|| "@!" },         "Fecha",                     .f., "Fecha",                       8 )
   ::AddField ( "CTIPVEN", "C", 20, 0,  {|| "@!" },         "Venta",                     .f., "Tipo de venta",              20 )

   ::AddTmpIndex ( "CCODAGE", "CCODAGE + CREFART" )

   ::AddGroup( {|| ::oDbf:cCodAge }, {|| "Agente  : " + Rtrim( ::oDbf:cCodAge ) + "-" + oRetFld( ::oDbf:cCodAge, ::oDbfAge ) }, {||"Total agente..."} )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TdlAgeAlb

   /*
   Ficheros necesarios
   */

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL  PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   DATABASE NEW ::oDbfCli   PATH ( cPatEmp() ) FILE "CLIENT.DBF"  VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TrlAgeAlb

   ::oAlbCliT:End()
   ::oAlbCliL:End()
   ::oDbfCli:End()

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

   REDEFINE CHECKBOX ::oResumen VAR ::lRes ;
      ID       190;
      OF       ::oFld:aDialogs[1]

   /*
   Monta los articulos de manera automatica
   */

   ::lDefArtInf( 150, 160, 170, 180 )

   ::oMtrInf:SetTotal( ::oAlbCliT:Lastrec() )

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

   local bValid   := {|| .t. }
   local lExcCero := .f.
   local nImpLin  := 0
   local nComLin  := 0

   ::oDlg:Disable()

   ::oDbf:Zap()
   ::oAlbCliT:GoTop()

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| !lFacturado( ::oAlbCliT ) }
      case ::oEstado:nAt == 2
         bValid   := {|| lFacturado( ::oAlbCliT ) }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

   ::aHeader      := {{||"Fecha   : "   + Dtoc( Date() ) },;
                     {|| "Periodo : "   + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Agentes : "   + ::cAgeOrg         + " > " + ::cAgeDes },;
                     {|| if ( ::lTvta,( if (!Empty( ::cTipVen ), "Tipo de Venta: " + ::cTipVen2, "Tipo de Venta: Todos" ) ), "Tipo de Venta: Ninguno" ) },;
                     {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ] },;
                     {|| if( ::lTvta, "Aplicando comportamiento de los tipos de venta", "" ) } }

   /*
   Nos movemos por las cabeceras de los albaranes
   */

   WHILE ! ::oAlbCliT:Eof()

      IF Eval( bValid )                                                                     .AND.;
         ::oAlbCliT:DFECALB >= ::dIniInf                                                    .AND.;
         ::oAlbCliT:DFECALB <= ::dFinInf                                                    .AND.;
         ::oAlbCliT:CCODAGE >= ::cAgeOrg                                                    .AND.;
         ::oAlbCliT:CCODAGE <= ::cAgeDes                                                    .AND.;
         lChkSer( ::oAlbCliT:CSERALB, ::aSer )                                              .AND.;
         ::oAlbCliL:Seek( ::oAlbCliT:CSERALB + Str( ::oAlbCliT:NNUMALB ) + ::oAlbCliT:CSUFALB )

         while ::oAlbCliT:CSERALB + Str( ::oAlbCliT:NNUMALB ) + ::oAlbCliT:CSUFALB == ::oAlbCliL:CSERALB + Str( ::oAlbCliL:NNUMALB ) + ::oAlbCliL:CSUFALB .AND. ! ::oAlbCliL:eof()

            if ::oAlbCliL:cRef >= ::cArtOrg                                                  .AND.;
               ::oAlbCliL:cRef <= ::cArtDes                                                  .AND.;
               !::oAlbCliL:lControl

               nImpLin     := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )

               if ::lExcCero .and. nImpLin != 0

                  nComLin  := nComLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )

                  if ::lTvta

                     if ( !Empty( ::cTipVen ) .and. ::oAlbCliL:cTipMov == ::cTipVen )            .OR.;
                        Empty( ::cTipVen )

                        if ::oDbf:Seek( ::oAlbCliT:cCodAge + ::oAlbCliL:cRef ) .and. ::lRes

                            ::oDbf:Load()
                            ::AddTipVta( ::oAlbCliL:cTipMov )
                            ::oDbf:Save()

                        else

                            ::oDbf:Append()
                            ::oDbf:Blank()

                            ::oDbf:cCodAge := ::oAlbCliT:cCodAge
                            ::oDbf:DFECMOV := ::oAlbCliT:dFecAlb
                            ::oDbf:CDOCMOV := ::oAlbCliT:cSerAlb + "/" + Str( ::oAlbCliT:nNumAlb ) + "/" + ::oAlbCliT:cSufAlb
                            ::oDbf:CREFART := ::oAlbCliL:CREF
                            ::oDbf:CDESART := ::oAlbCliL:cDetalle

                            if ::oDbfAge:Seek( ::oAlbCliT:cCodAge )
                               ::oDbf:cNomAge := ::oDbfAge:cApeAge + ", " + ::oDbfAge:cNbrAge
                            end if

                            ::AddTipVta( ::oAlbCliL:cTipMov )

                            ::oDbf:Save()

                        end if

                     end if

                  else

                     if ::oDbf:Seek( ::oAlbCliT:cCodAge + ::oAlbCliL:cRef ) .and. ::lRes

                        ::oDbf:Load()

                        ::oDbf:NUNDCAJ += ::oAlbCliL:NCANENT
                        ::oDbf:NCAJUND += nTotNAlbCli( ::oAlbCliL )
                        ::oDbf:NUNDART += ::oAlbCliL:NUNICAJA
                        ::oDbf:nComAge := ::oAlbCliL:nComAge
                        ::oDbf:nBasCom += nImpLin
                        ::oDbf:nTotCom += nComLin


                        ::oDbf:Save()

                     else

                        ::oDbf:Append()
                        ::oDbf:Blank()

                        ::oDbf:cCodAge := ::oAlbCliT:cCodAge
                        ::oDbf:CDOCMOV := ::oAlbCliT:cSerAlb + "/" + Str( ::oAlbCliT:nNumAlb ) + "/" + ::oAlbCliT:cSufAlb
                        ::oDbf:CREFART := ::oAlbCliL:CREF
                        ::oDbf:CDESART := ::oAlbCliL:cDetalle

                        if ::oDbfAge:Seek( ::oAlbCliT:cCodAge )
                           ::oDbf:cNomAge := ::oDbfAge:cApeAge + ", " + ::oDbfAge:cNbrAge
                        end if

                        ::oDbf:NUNDCAJ := ::oAlbCliL:NCANENT
                        ::oDbf:NCAJUND := nTotNAlbCli( ::oAlbCliL )
                        ::oDbf:NUNDART := ::oAlbCliL:NUNICAJA
                        ::oDbf:nComAge := ::oAlbCliL:nComAge
                        ::oDbf:nBasCom := nImpLin
                        ::oDbf:nTotCom := nComLin

                        ::oDbf:Save()

                     end if

                  end if

               end if

            end if

            ::oAlbCliL:Skip()

         end while

      end if

      ::oAlbCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD AddTipVta( cTipMov )

RETURN NIL

//---------------------------------------------------------------------------//