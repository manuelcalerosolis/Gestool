#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION TmCliAlb()

   local oInf
   local aCol  := {}
   local aIdx  := {}


   aAdd( aCol, { "CCODCLI", "C", 12, 0, {|| "@!" },         "Cli",                       .f., "Cod. Cliente",             8 } )
   aAdd( aCol, { "CNOMCLI", "C", 50, 0, {|| "@!" },         "Nom",                       .f., "Nombre Cliente",          25 } )
   aAdd( aCol, { "CCODART", "C", 18, 0, {|| "@!" },         "Art",                       .t., "Cod. Artículo",           14 } )
   aAdd( aCol, { "CNOMART", "C", 50, 0, {|| "@!" },         "Descripción",               .t., "Descripción",             25 } )
   aAdd( aCol, { "CNIFCLI", "C", 15, 0, {|| "@!" },         "Nif",                       .f., "Nif",                      8 } )
   aAdd( aCol, { "CDOMCLI", "C", 35, 0, {|| "@!" },         "Dom",                       .f., "Domicilio",               25 } )
   aAdd( aCol, { "CPOBCLI", "C", 35, 0, {|| "@!" },         "Pob",                       .f., "Población",               25 } )
   aAdd( aCol, { "CPROCLI", "C", 20, 0, {|| "@!" },         "Prov",                      .f., "Provincia",               20 } )
   aAdd( aCol, { "CCDPCLI", "C",  7, 0, {|| "@!" },         "CP",                        .f., "Cod. Postal",             20 } )
   aAdd( aCol, { "CTLFCLI", "C", 12, 0, {|| "@!" },         "Tlf",                       .f., "Teléfono",                12 } )
   aAdd( aCol, { "NCAJENT", "N", 16, 6, {|| MasUnd() },     "Caj.",                    .f., "Cajas",                     10 } )
   aAdd( aCol, { "NUNIDAD", "N", 16, 6, {|| MasUnd() },     "Und.",                    .t., "Unidades",                  10 } )
   aAdd( aCol, { "NUNTENT", "N", 13, 6, {|| MasUnd() },     "Tot. und.",               .f., "Total unidades",            10 } )
   aAdd( aCol, { "NPREDIV", "N", 16, 6, {|| oInf:cPicOut }, "Importe",                 .t., "Importe",                   10 } )
   aAdd( aCol, { "NCOMAGE", "N", 13, 6, {|| oInf:cPicOut }, "Com. Age",                .t., "Comisión agente",           10 } )
   aAdd( aCol, { "NTOTAGE", "N", 13, 6, {|| oInf:cPicOut }, "Imp. age",                .t., "Importe agente",             12 } )
   aAdd( aCol, { "CDOCMOV", "C", 14, 0, {|| "@!" },         "Alb",                     .t., "Albarán",                   14 } )
   aAdd( aCol, { "DFECMOV", "D",  8, 0, {|| "@!" },         "Fecha",                   .t., "Fecha",                      8 } )
   aAdd( aCol, { "CTIPVEN", "C", 20, 0, {|| "@!" },         "Venta",                   .f., "Tipo de venta",             20 } )

   aAdd( aIdx, { "CCODCLI", "CCODCLI" } )

   oInf  := TMovCAlb():New( "Informe detallado de albaranes agrupados por clientes", aCol, aIdx, "01045" )

   oInf:AddGroup( {|| oInf:oDbf:cCodCli }, {|| "Cliente  : " + Rtrim( oInf:oDbf:cCodCli ) + "-" + oRetFld( oInf:oDbf:cCodCli, oInf:oDbfCli ) } )

   oInf:Resource()
   oInf:Activate()

   oInf:End()
   oInf  := nil

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TMovCAlb FROM TInfGen

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  lTvta       AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oDbfCli     AS OBJECT
   DATA  cTipVen     AS CHARACTER     INIT  "00"
   DATA  cTipVen2    AS CHARACTER     INIT  "Venta"
   DATA  aEstado     AS ARRAY    INIT  { "No Facturado", "Facturado", "Todos" }

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TMovCAlb

   /*
   Ficheros necesarios
   */

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL  PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   DATABASE NEW ::oDbfCli   PATH ( cPatCli() ) FILE "CLIENT.DBF"  VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TMovCAlb

   ::oAlbCliT:End()
   ::oAlbCliL:End()
   ::oDbfCli:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TMovCAlb

   local oTipVen
   local oTipVen2
   local cEstado     := "Todos"
   local This        := Self

   if !::StdResource( "INF_GEN04" )
      return .f.
   end if

   /*
   Monta los obras de manera automatica
   */

   ::oDefCliInf( 70, 80, 90, 100 )

   /*
   Monta los clientes de manera automatica
   */

   ::oDefObrInf( 110, 120, 130, 140 )

   /*
   Monta los articulos de manera automatica
   */

   ::lDefArtInf( 150, 160, 170, 180 )

   ::oMtrInf:SetTotal( ::oAlbCliT:Lastrec() )

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

METHOD lGenerate() CLASS TMovCAlb

   local bValid   := {|| .t. }
   local lExcCero := .f.

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

     ::aHeader   := {{|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Clientes: " + Rtrim( ::cCliOrg )+ " > " + Rtrim( ::cCliDes ) },;
                     {|| "Obras   : " + Rtrim( ::cObrOrg )+ " > " + Rtrim( ::cObrDes ) },;
                     {|| "Artículo: " + Rtrim( ::cArtOrg )+ " > " + Rtrim( ::cArtDes ) },;
                     {|| if ( ::lTvta, "Tipo de Venta: " + ::cTipVen2 , "Tipo de Venta: Todos" ) },;
                     {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ] } }
	/*
   Nos movemos por las cabeceras de los albaranes a proveedores
	*/

   WHILE ! ::oAlbCliT:Eof()

      IF Eval( bValid )                                                                     .AND.;
         ::oAlbCliT:DFECALB >= ::dIniInf                                                    .AND.;
         ::oAlbCliT:DFECALB <= ::dFinInf                                                    .AND.;
         ::oAlbCliT:CCODCLI >= ::cCliOrg                                                    .AND.;
         ::oAlbCliT:CCODCLI <= ::cCliDes                                                    .AND.;
         if ( !Empty( ::cObrOrg ),;
            ( ::oAlbCliT:CCODOBR >= ::cObrOrg .AND. ::oAlbCliT:CCODOBR <= ::cObrDes ),;
            .t. )                                                                           .AND.;
         lChkSer( ::oAlbCliT:CSERALB, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oAlbCliL:Seek( ::oAlbCliT:CSERALB + Str( ::oAlbCliT:NNUMALB ) + ::oAlbCliT:CSUFALB )

            while ::oAlbCliT:CSERALB + Str( ::oAlbCliT:NNUMALB ) + ::oAlbCliT:CSUFALB == ::oAlbCliL:CSERALB + Str( ::oAlbCliL:NNUMALB ) + ::oAlbCliL:CSUFALB .AND. ! ::oAlbCliL:eof()

               if ::oAlbCliL:CREF >= ::cArtOrg                                      .AND.;
                  ::oAlbCliL:CREF <= ::cArtDes                                      .AND.;
                  if ( ::lTvta, ::oAlbCliL:cTipMov == ::cTipVen, .t. )              .AND.;
                  !( ::lExcCero .AND. ::oAlbCliL:NPREUNIT == 0 )

                  ::oDbf:Append()

                  ::oDbf:CCODCLI := ::oAlbCliT:CCODCLI
                  ::oDbf:CNOMCLI := ::oAlbCliT:CNOMCLI
                  ::oDbf:DFECMOV := ::oAlbCliT:DFECALB

                  ::oDbf:CCODART := ::oAlbCliL:CREF
                  ::oDbf:CNOMART := ::oAlbCliL:cDetalle

                  ::oDbf:NCAJENT := ::oAlbCliL:NCANENT
                  ::oDbf:NUNTENT := nTotNAlbCli( ::oAlbCliL )
                  ::oDbf:nUnidad := ::oAlbCliL:NUNICAJA
                  ::oDbf:nComAge := ( ::oAlbCliL:nComAge )
                  ::oDbf:nPreDiv := nTotLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                  ::oDbf:CDOCMOV    := ::oAlbCliL:CSERALB + "/" + Str( ::oAlbCliL:NNUMALB ) + "/" + ::oAlbCliL:CSUFALB

                  ::AddCliente( ::oAlbCliT:CCODCLI, ::oAlbCliT, .f. )

                  ::oDbf:Save()

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