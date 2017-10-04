#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TRlAgePed FROM TInfGen

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  lTvta       AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oPedCliT    AS OBJECT
   DATA  oPedCliL    AS OBJECT
    
   DATA  cTipVen     AS CHARACTER
   DATA  cTipVen2    AS CHARACTER
   DATA  aEstado     AS ARRAY    INIT  { "Pendientes", "Parcial", "Recibidos", "Todos" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

   METHOD AddTipVta()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField ( "CCODAGE", "C",  3, 0,  {|| "@!" },         "Cod. age",                  .f., "Código agente",               3 )
   ::AddField ( "CNOMAGE", "C", 50, 0,  {|| "@!" },         "Agente",                    .f., "Nombre agente",              25 )
   ::AddField ( "CREFART", "C", 18, 0,  {|| "@!" },         "Cod. art",                  .t., "Código artículo",            10 )
   ::AddField ( "CDESART", "C", 50, 0,  {|| "@!" },         "Artículo",                  .t., "Artículo",                   35 )
   ::AddField ( "NUNDCAJ", "N", 16, 6,  {|| MasUnd () },    "Cajas",                     .f., "Cajas",                       8 )
   ::AddField ( "NUNDART", "N", 16, 6,  {|| MasUnd () },    "Unid",                      .t., "Unidades",                    8 )
   ::AddField ( "NCAJUND", "N", 16, 6,  {|| MasUnd () },    "Caj x Und",                 .f., "Cajas x unidades",           10 )
   ::AddField ( "NBASCOM", "N", 16, 6,  {|| ::cPicOut },    "Base",                      .t., "Base comisión",              10 )
   ::AddField ( "NCOMAGE", "N",  4, 1,  {|| ::cPicOut },    "%Com",                      .t., "Porcentaje de comisión",     10 )
   ::AddField ( "NTOTCOM", "N", 16, 6,  {|| ::cPicOut },    "Importe",                   .t., "Importe Comisión",           10 )
   ::AddField ( "CDOCMOV", "C", 14, 0,  {|| "@!" },         "Pedido",                    .f., "Pedido",                     14 )
   ::AddField ( "DFECMOV", "D",  8, 0,  {|| "@!" },         "Fecha",                     .f., "Fecha",                       8 )
   ::AddField ( "CTIPVEN", "C", 20, 0,  {|| "@!" },         "Venta",                     .f., "Tipo de Venta",              20 )

   ::AddTmpIndex( "CCODAGE", "CCODAGE + CREFART" )
   ::AddGroup( {|| ::oDbf:cCodAge }, {|| "Agente  : " + Rtrim( ::oDbf:cCodAge ) + "-" + oRetFld( ::oDbf:cCodAge, ::oDbfAge ) }, {||"Total agente..."} )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TdlAgePed

   /*
   Ficheros necesarios
   */

   ::oPedCliT := TDataCenter():oPedCliT()

   DATABASE NEW ::oPedCliL  PATH ( cPatEmp() ) FILE "PEDCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "PEDCLIL.CDX"

   DATABASE NEW ::oDbfCli   PATH ( cPatCli() ) FILE "CLIENT.DBF"  VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TrlAgePed

   ::oPedCliT:End()
   ::oPedCliL:End()
   ::oDbfCli:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TrlAgePed

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

   ::oMtrInf:SetTotal( ::oPedCliT:Lastrec() )

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

METHOD lGenerate() CLASS TrlAgePed

   local bValid   := {|| .t. }
   local lExcCero := .f.

   ::oDlg:Disable()

   ::oDbf:Zap()
   ::oPedCliT:GoTop()

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| ::oPedCliT:nEstado == 1 }
      case ::oEstado:nAt == 2
         bValid   := {|| ::oPedCliT:nEstado == 2 }
      case ::oEstado:nAt == 3
         bValid   := {|| ::oPedCliT:nEstado == 2 }
      case ::oEstado:nAt == 4
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

   WHILE ! ::oPedCliT:Eof()

      IF Eval( bValid )                                                                     .AND.;
         ::oPedCliT:DFECPED >= ::dIniInf                                                    .AND.;
         ::oPedCliT:DFECPED <= ::dFinInf                                                    .AND.;
         ::oPedCliT:CCODAGE >= ::cAgeOrg                                                    .AND.;
         ::oPedCliT:CCODAGE <= ::cAgeDes                                                    .AND.;
         lChkSer( ::oPedCliT:CSERPED, ::aSer )                                              .AND.;
         ::oPedCliL:Seek( ::oPedCliT:CSERPED + Str( ::oPedCliT:NNUMPED ) + ::oPedCliT:CSUFPED )

         while ::oPedCliT:CSERPED + Str( ::oPedCliT:NNUMPED ) + ::oPedCliT:CSUFPED == ::oPedCliL:CSERPED + Str( ::oPedCliL:NNUMPED ) + ::oPedCliL:CSUFPED .AND. ! ::oPedCliL:eof()

               if ::lTvta

                  if ( !Empty( ::cTipVen ) .and. ::oPedCliL:cTipMov == ::cTipVen )            .OR.;
                     Empty( ::cTipVen )

                     if ::oDbf:Seek( ::oPedCliT:cCodAge + ::oPedCliL:cRef )

                         ::oDbf:Load()
                         ::AddTipVta( ::oPedCli:cTipMov )
                         ::oDbf:Save()

                     else

                         ::oDbf:Append()

                         ::oDbf:cCodAge := ::oPedCliT:cCodAge
                         ::oDbf:DFECMOV := ::oPedCliT:dFecPed
                         ::oDbf:CDOCMOV := ::oPedCliT:cSerPed + "/" + Str( ::oPedCliT:nNumPed ) + "/" + ::oPedCliT:cSufPed
                         ::oDbf:CREFART := ::oPedCliL:CREF
                         ::oDbf:CDESART := ::oPedCliL:cDetalle

                         if ::oDbfAge:Seek( ::oPedCliT:cCodAge )
                            ::oDbf:cNomAge := ::oDbfAge:cApeAge + ", " + ::oDbfAge:cNbrAge
                         end if

                         ::AddTipVta( ::oPedCliL:cTipMov )

                         ::oDbf:Save()

                     end if

                  end if

               else

                  if ::oDbf:Seek( ::oPedCliT:cCodAge + ::oPedCliL:cRef )

                     ::oDbf:Load()

                     ::oDbf:NUNDCAJ += ::oPedCliL:NCANENT
                     ::oDbf:NCAJUND += NotCaja( ::oPedCliL:NCANENT )* ::oPedCliL:NUNICAJA
                     ::oDbf:NUNDART += ::oPedCliL:NUNICAJA
                     ::oDbf:nComAge := ::oPedCliL:nComAge
                     ::oDbf:nBasCom += nImpLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut )
                     ::oDbf:nTotCom += nComLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut )

                     ::oDbf:Save()

                  else

                     ::oDbf:Append()

                     ::oDbf:cCodAge := ::oPedCliT:cCodAge
                     ::oDbf:CDOCMOV := ::oPedCliT:cSerPed + "/" + Str( ::oPedCliT:nNumPed ) + "/" + ::oPedCliT:cSufPed
                     ::oDbf:CREFART := ::oPedCliL:CREF
                     ::oDbf:CDESART := ::oPedCliL:cDetalle

                     if ::oDbfAge:Seek( ::oPedCliT:cCodAge )
                        ::oDbf:cNomAge := ::oDbfAge:cApeAge + ", " + ::oDbfAge:cNbrAge
                     end if

                     ::oDbf:NUNDCAJ := ::oPedCliL:NCANENT
                     ::oDbf:NCAJUND := NotCaja( ::oPedCliL:NCANENT )* ::oPedCliL:NUNICAJA
                     ::oDbf:NUNDART := ::oPedCliL:NUNICAJA
                     ::oDbf:nComAge := ::oPedCliL:nComAge
                     ::oDbf:nBasCom := nImpLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut )
                     ::oDbf:nTotCom := nComLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut )

                     ::oDbf:Save()

                  end if

               end if

            ::oPedCliL:Skip()

         end while

      end if

      ::oPedCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD AddTipVta( cTipMov )

RETURN ( nil )

//---------------------------------------------------------------------------//