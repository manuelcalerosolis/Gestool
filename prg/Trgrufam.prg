#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION TRGruCli()

   local oInf
   local aCol  := {}
   local aIdx  := {}


   aAdd( aCol, { "CCODGRF", "C",  5, 0, {|| "@!" },         "Gru. Fam.",                 .f., "Codigo grupo familia",    5 } )
   aAdd( aCol, { "CNOMART", "C",100, 0, {|| "@!" },         "Grupo",                     .f., "Nombre grupo familia",   50 } )
   aAdd( aCol, { "CCODART", "C", 18, 0, {|| "@!" },         "Art",                       .f., "Cod. Artículo",           9 } )
   aAdd( aCol, { "CNOMART", "C", 50, 0, {|| "@!" },         "Descripción",               .t., "Descripción",            50 } )
   aAdd( aCol, { "NCAJENT", "N", 16, 6, {|| MasUnd() },     "Caj.",                      .f., "Cajas",                   8 } )
   aAdd( aCol, { "NUNIDAD", "N", 16, 6, {|| MasUnd() },     "Und.",                      .t., "Unidades",                8 } )
   aAdd( aCol, { "NUNTENT", "N", 13, 6, {|| MasUnd() },     "Und. x Caj.",               .f., "Unidades x Caja",         8 } )
   aAdd( aCol, { "NPREDIV", "N", 16, 6, {|| oInf:cPicOut }, "Importe",                   .t., "Importe",                 8 } )
   aAdd( aCol, { "NCOMAGE", "N", 13, 6, {|| oInf:cPicOut }, "Com. Age",                  .t., "Comisión Agente",         8 } )
   aAdd( aCol, { "NTOTAGE", "N", 13, 6, {|| oInf:cPicOut }, "Imp. Age",                  .t., "Importe Agente",          8 } )

   aAdd( aIdx, { "CCODGRF", "CCODGRF + CCODART" } )

   oInf  := TRGruCli():New( "Resumen de consumo de grupos de clientes", aCol, aIdx, "01045" )

   oInf:AddGroup( {|| oInf:oDbf:cCodGrf},                     {|| "Artículo  : " + Rtrim( oInf:oDbf:cCodGrf ) + "-" + oRetFld( oInf:oDbf:cCodGrF, oInf:oGruFam ) } )
   //oInf:AddGroup( {|| oInf:oDbf:cCodCli + oInf:oDbf:cNomArt }, {|| "Artículo : " + Rtrim( oInf:oDbf:cNomArt ) + "-" + oRetFld( oInf:oDbf:cNomArt, oInf:oDbfArt ) }, {||""} )

   oInf:Resource()
   oInf:Activate()

   oInf:End()
   oInf  := nil

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TRGruCli FROM TInfGen

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  lTvta       AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
    
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Liquidada", "Todas" }
   DATA  cTipVen     AS CHARACTER
   DATA  cTipVen2    AS CHARACTER

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TRGruCli

   /*
   Ficheros necesarios
   */

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL  PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oDbfCli   PATH ( cPatEmp() ) FILE "CLIENT.DBF"  VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TResCFac

   ::oFacCliT:End()
   ::oFacCliL:End()
   ::oDbfCli:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TResCFac

   local cEstado     := "Todas"
   local oTipVen
   local oTipVen2
   local This        := Self

   if !::StdResource( "INF_GEN04" )
      return .f.
   end if

   /*
   Monta los obras de manera automatica
   */

   ::oDefGrfInf( 70, 80, 90, 100 )

   /*
   Monta los clientes de manera automatica
   */

   ::oDefObrInf( 110, 120, 130, 140 )

   /*
   Monta los articulos de manera automatica
   */

   ::lDefArtInf( 150, 160, 170, 180 )

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )

   ::oDefExcInf()

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

METHOD lGenerate() CLASS TResCFac

   local bValid   := {|| .t. }
   local lExcCero := .f.

   ::oDlg:Disable()

   ::oDbf:Zap()
   ::oFacCliT:GoTop()

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| !::oFacCliT:lLiquidada }
      case ::oEstado:nAt == 2
         bValid   := {|| ::oFacCliT:lLiquidada }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

     ::aHeader   := {{|| "Fecha    : " + Dtoc( Date() ) },;
                     {|| "Periodo  : " + Dtoc( ::dIniInf )  + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Clientes : " + Rtrim( ::cCliOrg ) + " > " + Rtrim( ::cCliDes ) },;
                     {|| "Obras    : " + Rtrim( ::cObrOrg ) + " > " + Rtrim( ::cObrDes ) },;
                     {|| "Artículos: " + Rtrim( ::cArtOrg ) + " > " + Rtrim( ::cArtDes ) },;
                     {|| if ( ::lTvta,( if( !Empty( ::cTipVen ), "Tipo de Venta: " + ::cTipVen2, "Tipo de Venta: Todos" ) ), "Tipo de Venta: Ninguno" ) },;
                     {|| "Estado   : " + ::aEstado[ ::oEstado:nAt ] } }

   /*
   Nos movemos por las cabeceras de facturas de clientes
	*/

   WHILE ! ::oFacCliT:Eof()

      if Eval( bValid )                                                                     .AND.;
         ::oFacCliT:DFECFAC >= ::dIniInf                                                    .AND.;
         ::oFacCliT:DFECFAC <= ::dFinInf                                                    .AND.;
         ::oFacCliT:CCODCLI >= ::cCliOrg                                                    .AND.;
         ::oFacCliT:cCodCli <= ::cCliDes                                                    .AND.;
         if ( !Empty( ::cObrOrg ),;
            ( ::oFacCliT:CCODOBR >= ::cObrOrg .AND. ::oFacCliT:CCODOBR <= ::cObrDes ),;
            .t. )                                                                           .AND.;
         lChkSer( ::oFacCliT:CSERIE, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oFacCliL:Seek( ::oFacCliT:CSERIE + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC )

            while ::oFacCliT:CSERIE + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC == ::oFacCliL:CSERIE + Str( ::oFacCliL:NNUMFAC ) + ::oFacCliL:CSUFFAC .AND. ! ::oFacCliL:eof()

               if ::oFacCliL:CREF >= ::cArtOrg                                      .AND.;
                  ::oFacCliL:CREF <= ::cArtDes                                      .AND.;
                  !( ::lExcCero .AND. ( NotCaja( ::oFacCliL:NCANENT ) * ::oFacCliL:NUNICAJA == 0 ) )

                  if ::oDbf:Seek( ::oFacCliL:CREF )

                     ::oDbf:Load()

                     ::oDbf:NCAJENT += ::oFacCliL:NCANENT
                     ::oDbf:NUNTENT += NotCaja( ::oFacCliL:NCANENT ) * ::oFacCliL:NUNICAJA
                     ::oDbf:nUnidad += ::oFacCliL:NUNICAJA
                     ::oDbf:nComAge += ( ::oFacCliL:nComAge )
                     ::oDbf:nTotAge += nComLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nPreDiv += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )

                     ::oDbf:Save()

                  else

                     ::oDbf:Append()

                     ::oDbf:CCODART := ::oFacCliL:CREF
                     ::oDbf:CNOMART := ::oFacCliL:cDetalle
                     ::oDbf:NCAJENT := ::oFacCliL:NCANENT
                     ::oDbf:NUNTENT := NotCaja( ::oFacCliL:NCANENT ) * ::oFacCliL:NUNICAJA
                     ::oDbf:nUnidad := ::oFacCliL:NUNICAJA
                     ::oDbf:nComAge := ( ::oFacCliL:nComAge )
                     ::oDbf:nTotAge := nComLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nPreDiv := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )

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

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//