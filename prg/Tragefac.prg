#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TrlAgeFac FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  lTvta       AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  cTipVen     AS CHARACTER
   DATA  cTipVen2    AS CHARACTER
   DATA  aEstado     AS ARRAY    INIT  { "Pendientes", "Cobradas", "Todas" }
   DATA  oIndice     AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

   METHOD AddTipVta()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField ( "cCodAge", "C",  3, 0,  {|| "@!" },         "Cod. age.",          .f., "Código agente",               3 )
   ::AddField ( "cNomAge", "C", 50, 0,  {|| "@!" },         "Agente",             .f., "Nombre agente",              25 )
   ::AddField ( "cRefArt", "C", 18, 0,  {|| "@!" },         "Código artículo",          .t., "Código artículo",            14 )
   ::AddField ( "cDesArt", "C", 50, 0,  {|| "@!" },         "Artículo",           .t., "Artículo",                   35 )
   ::AddField ( "nUndCaj", "N", 16, 6,  {|| MasUnd () },    "Caj.",               .f., "Cajas",                      12 )
   ::AddField ( "nUndArt", "N", 16, 6,  {|| MasUnd () },    "Und.",               .f., "Unidades",                   12 )
   ::AddField ( "nCajUnd", "N", 16, 6,  {|| MasUnd () },    "Tot. und.",          .t., "Total unidades",             12 )
   ::AddField ( "nBasCom", "N", 16, 6,  {|| ::cPicOut },    "Base",               .t., "Base comisión",              12 )
   ::AddField ( "nTotCom", "N", 16, 6,  {|| ::cPicOut },    "Comisión",           .t., "Importe comisión",           12 )
   ::AddField ( "nPreMed", "N", 16, 6,  {|| ::cPicImp },    "Pre. Med.",          .f., "Precio medio",               12, .f. )
   ::AddField ( "cDocMov", "C", 14, 0,  {|| "" },           "Factura",            .f., "Factura",                    14 )
   ::AddField ( "dFecMov", "D",  8, 0,  {|| "" },           "Fecha",              .f., "Fecha",                       8 )
   ::AddField ( "cTipVen", "C", 20, 0,  {|| "@!" },         "Venta",              .f., "Tipo de venta",              20 )

   ::AddTmpIndex( "CCODAGE", "CCODAGE + CREFART" )

   ::AddGroup( {|| ::oDbf:cCodAge }, {|| "Agente  : " + Rtrim( ::oDbf:cCodAge ) + "-" + oRetFld( ::oDbf:cCodAge, ::oDbfAge ) }, {||"Total agente..."} )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TdlAgeFac

   /*
   Ficheros necesarios
   */

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL  PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oDbfCli   PATH ( cPatCli() ) FILE "CLIENT.DBF"  VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TrlAgeFac

   ::oFacCliT:End()
   ::oFacCliL:End()
   ::oDbfCli:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TrlAgeFac

   local oTipVen
   local oTipVen2
   local cEstado     := "Todas"
   local This        := Self

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

   /*
   Damos valor al meter
   */

   ::oDefExcImp()

   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )

   ::oDefResInf()

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

METHOD lGenerate() CLASS TrlAgeFac

   local bTipVen  := {|| if( !Empty( ::cTipVen ), ::oFacCliL:cTipMov == ::cTipVen, .t. ) }
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

   ::aHeader      := {{||"Fecha   : "   + Dtoc( Date() ) },;
                     {|| "Periodo : "   + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Agentes : "   + ::cAgeOrg         + " > " + ::cAgeDes },;
                     {|| if ( ::lTvta,( if (!Empty( ::cTipVen ), "Tipo de venta: " + ::cTipVen2, "Tipo de venta: Todos" ) ), "Tipo de Venta: Ninguno" ) },;
                     {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ] },;
                     {|| if( ::lTvta, "Aplicando comportamiento de los tipos de venta", "" ) } }

   /*
   Nos movemos por las cabeceras de los albaranes
   */

   WHILE !::oFacCliT:Eof()

      IF Eval( bValid )                                                                      .AND.;
         ::oFacCliT:DFECFAC >= ::dIniInf                                                     .AND.;
         ::oFacCliT:DFECFAC <= ::dFinInf                                                     .AND.;
         ::oFacCliT:CCODAGE >= ::cAgeOrg                                                     .AND.;
         ::oFacCliT:CCODAGE <= ::cAgeDes                                                     .AND.;
         lChkSer( ::oFacCliT:cSerie, ::aSer )                                                .AND.;
         ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC )

         while ::oFacCliT:cSerie + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC == ::oFacCliL:cSerie + Str( ::oFacCliL:NNUMFAC ) + ::oFacCliL:CSUFFAC .AND.;
               ! ::oFacCliL:eof()

            if !::oFacCliL:lControl                                              .AND.;
               ::oFacCliL:CREF >= ::cArtOrg                                      .AND.;
               ::oFacCliL:CREF <= ::cArtDes                                      .AND.;
               !( ::lExcImp .and. ( nTotLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 ) )

               /*
               Preguntamos y tratamos el tipo de venta
               */

               if ::lTvta

                  if ( !Empty( ::cTipVen ) .and. ::oFacCliL:cTipMov == ::cTipVen )            .OR.;
                     Empty( ::cTipVen )

                     if ::oDbf:Seek( ::oFacCliT:cCodAge + ::oFacCliL:cRef )

                         ::oDbf:Load()
                         ::AddTipVta( ::oFacCli:cTipMov )
                         ::oDbf:Save()

                     else

                         ::oDbf:Append()

                         ::oDbf:cCodAge := ::oFacCliT:cCodAge
                         ::oDbf:DFECMOV := ::oFacCliT:DFECFAC
                         ::oDbf:CDOCMOV := ::oFacCliT:cSerie + "/" + Str( ::oFacCliT:nNumFac ) + "/" + ::oFacCliT:cSufFac
                         ::oDbf:CREFART := ::oFacCliL:CREF
                         ::oDbf:CDESART := ::oFacCliL:cDetalle

                         if ::oDbfAge:Seek( ::oFacCliT:cCodAge )
                            ::oDbf:cNomAge := ::oDbfAge:cApeAge + ", " + ::oDbfAge:cNbrAge
                         end if

                         ::AddTipVta( ::oFacCliL:cTipMov )

                         ::oDbf:Save()

                     end if

                  end if

               /*
               Pasamos de los tipos de ventas
               */

               else

                  if ::oDbf:Seek( ::oFacCliT:cCodAge + ::oFacCliL:cRef )

                     ::oDbf:Load()

                     ::oDbf:NUNDCAJ += ::oFacCliL:NCANENT
                     ::oDbf:NUNDART += ::oFacCliL:NUNICAJA
                     ::oDbf:NCAJUND += nTotNFacCli( ::oFacCliL )
                     ::oDbf:nBasCom += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )
                     ::oDbf:nPreMed := ::oDbf:nBasCom / ::oDbf:nCajUnd
                     ::oDbf:nTotCom += nComLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                     ::oDbf:Save()

                  else

                     ::oDbf:Append()

                     ::oDbf:cCodAge := ::oFacCliT:cCodAge
                     ::oDbf:CDOCMOV := ::oFacCliT:cSerie + "/" + Str( ::oFacCliT:nNumFac ) + "/" + ::oFacCliT:cSufFac
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
                     ::oDbf:nPreMed := ::oDbf:nBasCom / ::oDbf:nCajUnd

                     ::oDbf:Save()

                  end if

               end if

            end if

            ::oFacCliL:Skip()

         end while

      end if

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD AddTipVta( cTipMov )

RETURN nil

//---------------------------------------------------------------------------//