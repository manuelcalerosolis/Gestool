#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TRlAgePre FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  lTvta       AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oPreCliT    AS OBJECT
   DATA  oPreCliL    AS OBJECT
   DATA  cTipVen     AS CHARACTER
   DATA  cTipVen2    AS CHARACTER
   DATA  aEstado     AS ARRAY    INIT  { "Pendientes", "Pedidos" , "Todos" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

   METHOD AddTipVta()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField ( "CCODAGE", "C",  3, 0,  {|| "@!" },         "Cod. age",     .f., "Código agente",               3 )
   ::AddField ( "CNOMAGE", "C", 50, 0,  {|| "@!" },         "Agente",       .f., "Nombre agente",              25 )
   ::AddField ( "CREFART", "C", 18, 0,  {|| "@!" },         "Cod. art",     .t., "Código artículo",            10 )
   ::AddField ( "CDESART", "C", 50, 0,  {|| "@!" },         "Artículo",     .t., "Artículo",                   35 )
   ::AddField ( "NUNDCAJ", "N", 16, 6,  {|| MasUnd () },    "Cajas",        .f., "Cajas",                       8 )
   ::AddField ( "NUNDART", "N", 16, 6,  {|| MasUnd () },    "Unid",         .t., "Unidades",                    8 )
   ::AddField ( "NCAJUND", "N", 16, 6,  {|| MasUnd () },    "Caj x Und",    .f., "Cajas x unidades",           10 )
   ::AddField ( "NBASCOM", "N", 16, 6,  {|| ::cPicOut },    "Base",         .t., "Base comisión",              10 )
   ::AddField ( "NCOMAGE", "N",  4, 1,  {|| ::cPicOut },    "%Com",         .t., "Porcentaje de comisión",     10 )
   ::AddField ( "NTOTCOM", "N", 16, 6,  {|| ::cPicOut },    "Importe",      .t., "Importe Comisión",           10 )
   ::AddField ( "CDOCMOV", "C", 14, 0,  {|| "@!" },         "Preido",       .f., "Preido",                     14 )
   ::AddField ( "DFECMOV", "D",  8, 0,  {|| "@!" },         "Fecha",        .f., "Fecha",                       8 )
   ::AddField ( "CTIPVEN", "C", 20, 0,  {|| "@!" },         "Venta",        .f., "Tipo de Venta",              20 )

   ::AddTmpIndex ( "CCODAGE", "CCODAGE + CREFART" )

   ::AddGroup( {|| ::oDbf:cCodAge }, {|| "Agente  : " + Rtrim( ::oDbf:cCodAge ) + "-" + oRetFld( ::oDbf:cCodAge, ::oDbfAge ) }, {||"Total agente..."} )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TdlAgePre

   /*
   Ficheros necesarios
   */

   ::oPreCliT  := TDataCenter():oPreCliT()

   DATABASE NEW ::oPreCliL  PATH ( cPatEmp() ) FILE "PRECLIL.DBF" VIA ( cDriver() ) SHARED INDEX "PRECLIL.CDX"

   DATABASE NEW ::oDbfCli   PATH ( cPatEmp() ) FILE "CLIENT.DBF"  VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TrlAgePre

   ::oPreCliT:End()
   ::oPreCliL:End()
   ::oDbfCli:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TrlAgePre

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
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oPreCliT:Lastrec() )

   ::oDefResInf ()

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

METHOD lGenerate() CLASS TrlAgePre

   local bValid   := {|| .t. }
   local lExcCero := .f.

   ::oDlg:Disable()

   ::oDbf:Zap()
   ::oPreCliT:GoTop()

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| ::oPreCliT:lEstado  }
      case ::oEstado:nAt == 2
         bValid   := {|| !::oPreCliT:lEstado }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

   ::aHeader      :={{|| "Fecha   : "   + Dtoc( Date() ) },;
                     {|| "Periodo : "   + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Agentes : "   + ::cAgeOrg         + " > " + ::cAgeDes },;
                     {|| if ( ::lTvta,( if (!Empty( ::cTipVen ), "Tipo de Venta: " + ::cTipVen2, "Tipo de Venta: Todos" ) ), "Tipo de Venta: Ninguno" ) },;
                     {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ] },;
                     {|| if( ::lTvta, "Aplicando comportamiento de los tipos de venta", "" ) } }

   /*
   Nos movemos por las cabeceras de los albaranes
   */

   WHILE ! ::oPreCliT:Eof()

      IF Eval( bValid )                                                                     .AND.;
         ::oPreCliT:DFECPRE >= ::dIniInf                                                    .AND.;
         ::oPreCliT:DFECPRE <= ::dFinInf                                                    .AND.;
         ::oPreCliT:CCODAGE >= ::cAgeOrg                                                    .AND.;
         ::oPreCliT:CCODAGE <= ::cAgeDes                                                    .AND.;
         lChkSer( ::oPreCliT:CSERPRE, ::aSer )                                              .AND.;
         ::oPreCliL:Seek( ::oPreCliT:CSERPRE + Str( ::oPreCliT:NNUMPRE ) + ::oPreCliT:CSUFPRE )

         while ::oPreCliT:CSERPRE + Str( ::oPreCliT:NNUMPRE ) + ::oPreCliT:CSUFPRE == ::oPreCliL:CSERPRE + Str( ::oPreCliL:NNUMPRE ) + ::oPreCliL:CSUFPRE .AND. ! ::oPreCliL:eof()

               if ::lTvta

                  if ( !Empty( ::cTipVen ) .and. ::oPreCliL:cTipMov == ::cTipVen )            .OR.;
                     Empty( ::cTipVen )

                     if ::oDbf:Seek( ::oPreCliT:cCodAge + ::oPreCliL:cRef )

                         ::oDbf:Load()
                         ::AddTipVta( ::oPreCli:cTipMov )
                         ::oDbf:Save()

                     else

                         ::oDbf:Append()

                         ::oDbf:cCodAge := ::oPreCliT:cCodAge
                         ::oDbf:DFECMOV := ::oPreCliT:dFecPre
                         ::oDbf:CDOCMOV := ::oPreCliT:cSerPre + "/" + Str( ::oPreCliT:nNumPre ) + "/" + ::oPreCliT:cSufPre
                         ::oDbf:CREFART := ::oPreCliL:CREF
                         ::oDbf:CDESART := ::oPreCliL:cDetalle

                         if ::oDbfAge:Seek( ::oPreCliT:cCodAge )
                            ::oDbf:cNomAge := ::oDbfAge:cApeAge + ", " + ::oDbfAge:cNbrAge
                         end if

                         ::AddTipVta( ::oPreCliL:cTipMov )

                         ::oDbf:Save()

                     end if

                  end if

               else

                  if ::oDbf:Seek( ::oPreCliT:cCodAge + ::oPreCliL:cRef )

                     ::oDbf:Load()

                     ::oDbf:NUNDCAJ += ::oPreCliL:NCANENT
                     ::oDbf:NCAJUND += NotCaja( ::oPreCliL:NCANENT )* ::oPreCliL:NUNICAJA
                     ::oDbf:NUNDART += ::oPreCliL:NUNICAJA
                     ::oDbf:nComAge := ::oPreCliL:nComAge
                     ::oDbf:nBasCom += nImpLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut )
                     ::oDbf:nTotCom += nComLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut )

                     ::oDbf:Save()

                  else

                     ::oDbf:Append()

                     ::oDbf:cCodAge := ::oPreCliT:cCodAge
                     ::oDbf:CDOCMOV := ::oPreCliT:cSerPre + "/" + Str( ::oPreCliT:nNumPre ) + "/" + ::oPreCliT:cSufPre
                     ::oDbf:CREFART := ::oPreCliL:CREF
                     ::oDbf:CDESART := ::oPreCliL:cDetalle

                     if ::oDbfAge:Seek( ::oPreCliT:cCodAge )
                        ::oDbf:cNomAge := ::oDbfAge:cApeAge + ", " + ::oDbfAge:cNbrAge
                     end if

                     ::oDbf:NUNDCAJ := ::oPreCliL:NCANENT
                     ::oDbf:NCAJUND := NotCaja( ::oPreCliL:NCANENT )* ::oPreCliL:NUNICAJA
                     ::oDbf:NUNDART := ::oPreCliL:NUNICAJA
                     ::oDbf:nComAge := ::oPreCliL:nComAge
                     ::oDbf:nBasCom := nImpLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut )
                     ::oDbf:nTotCom := nComLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut )

                     ::oDbf:Save()

                  end if

               end if

            ::oPreCliL:Skip()

         end while

      end if

      ::oPreCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD AddTipVta( cTipMov )

RETURN ( nil )

//---------------------------------------------------------------------------//