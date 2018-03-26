#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION TmCliPed()

   local oInf
   local aCol  := {}
   local aIdx  := {}

   aAdd( aCol, { "CCODCLI", "C", 12, 0, {|| "@!" },         "Cli",                       .f., "Cod. Cliente",                8 } )
   aAdd( aCol, { "CNOMCLI", "C", 50, 0, {|| "@!" },         "Nom",                       .f., "Nombre Cliente",             25 } )
   aAdd( aCol, { "CCODART", "C", 18, 0, {|| "@!" },         "Art",                       .t., "Cod. Artículo",              14 } )
   aAdd( aCol, { "CNOMART", "C", 50, 0, {|| "@!" },         "Descripción",               .t., "Descripción",                25 } )
   aAdd( aCol, { "CNIFCLI", "C", 15, 0, {|| "@!" },         "Nif",                       .f., "Nif",                         8 } )
   aAdd( aCol, { "CDOMCLI", "C", 35, 0, {|| "@!" },         "Dom",                       .f., "Domicilio",                  25 } )
   aAdd( aCol, { "CPOBCLI", "C", 35, 0, {|| "@!" },         "Pob",                       .f., "Población",                  25 } )
   aAdd( aCol, { "CPROCLI", "C", 20, 0, {|| "@!" },         "Prov",                      .f., "Provincia",                  20 } )
   aAdd( aCol, { "CCDPCLI", "C",  7, 0, {|| "@!" },         "CP",                        .f., "Cod. Postal",                20 } )
   aAdd( aCol, { "CTLFCLI", "C", 12, 0, {|| "@!" },         "Tlf",                       .f., "Teléfono",                   12 } )
   aAdd( aCol, { "NCAJENT", "N", 16, 6, {|| MasUnd() },     "Caj.",                      .f., "Cajas",                      12 } )
   aAdd( aCol, { "NUNIDAD", "N", 16, 6, {|| MasUnd() },     "Und.",                      .t., "Unidades",                   12 } )
   aAdd( aCol, { "NUNTENT", "N", 13, 6, {|| MasUnd() },     "Tot. und.",                 .f., "Total unidades",             12 } )
   aAdd( aCol, { "NPREDIV", "N", 16, 6, {|| oInf:cPicOut }, "Importe",                   .t., "Importe",                    12 } )
   aAdd( aCol, { "NCOMAGE", "N", 13, 6, {|| oInf:cPicOut }, "Com. age",                  .t., "Comisión agente",            12 } )
   aAdd( aCol, { "NTOTAGE", "N", 13, 6, {|| oInf:cPicOut }, "Imp. age",                  .t., "Importe agente",             12 } )
   aAdd( aCol, { "CDOCMOV", "C", 14, 0, {|| "@!" },         "Ped",                       .t., "Pedido",                     14 } )
   aAdd( aCol, { "DFECMOV", "D",  8, 0, {|| "@!" },         "Fecha",                     .t., "Fecha",                       8 } )
   aAdd( aCol, { "CTIPVEN", "C", 20, 0, {|| "@!" },         "Venta",                     .f., "Tipo de Venta",              20} )

   aAdd( aIdx, { "CCODCLI", "CCODCLI" } )

   oInf  := TMovCPed():New( "Informe detallado de pedidos de clientes agrupados por clientes", aCol, aIdx, "01045" )

   oInf:AddGroup( {|| oInf:oDbf:cCodCli }, {|| "Cliente  : " + Rtrim( oInf:oDbf:cCodCli ) + "-" + oRetFld( oInf:oDbf:cCodCli, oInf:oDbfCli ) } )

   oInf:Resource()
   oInf:Activate()

   oInf:End()
   oInf  := nil

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TMovCPed FROM TInfGen

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  lTvta       AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oPedCliT    AS OBJECT
   DATA  oPedCliL    AS OBJECT
    
   DATA  oDbfCli     AS OBJECT
   DATA  aEstado     AS ARRAY    INIT { "Pendiente", "Parcialmente", "Entregados", "Todos" }
   DATA  cTipVen     AS CHARACTER     INIT  "00"
   DATA  cTipVen2    AS CHARACTER     INIT  "Venta"

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TMovCPed

   /*
   Ficheros necesarios
   */

   ::oPedCliT := TDataCenter():oPedCliT()

   DATABASE NEW ::oPedCliL  PATH ( cPatEmp() ) FILE "PEDCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "PEDCLIL.CDX"

   DATABASE NEW ::oDbfCli   PATH ( cPatEmp() ) FILE "CLIENT.DBF"  VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TMovCPed

   ::oPedCliT:End()
   ::oPedCliL:End()
   ::oDbfCli:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TMovCPed

   local cEstado := "Todos"
   local oTipVen
   local oTipVen2
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

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oPedCliT:Lastrec() )

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

METHOD lGenerate() CLASS TMovCPed

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
         bValid   := {|| ::oPedCliT:nEstado == 3 }
      case ::oEstado:nAt == 4
         bValid   := {|| .t. }
   end case

	/*
   Nos movemos por las cabeceras de los albaranes a proveedores
	*/

     ::aHeader   := {{|| "Fecha    : "  + Dtoc( Date() ) },;
                     {|| "Periodo  : "  + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Clientes : "  + ::cCliOrg         + " > " + ::cCliDes },;
                     {|| "Obras    : "  + ::cObrOrg         + " > " + ::cObrDes },;
                     {|| "Artículos: "  + ::cArtOrg         + " > " + ::cArtDes },;
                     {|| if ( ::lTvta, "Tipo de Venta: " + ::cTipVen2 , "Tipo de Venta: Todos" ) },;
                     {|| "Estado   : "  + ::aEstado[ ::oEstado:nAt ] } }


   WHILE ! ::oPedCliT:Eof()

      IF Eval( bValid )                                                                     .AND.;
         ::oPedCliT:DFECPED >= ::dIniInf                                                    .AND.;
         ::oPedCliT:DFECPED <= ::dFinInf                                                    .AND.;
         ::oPedCliT:CCODCLI >= ::cCliOrg                                                    .AND.;
         ::oPedCliT:CCODCLI <= ::cCliDes                                                    .AND.;
         if ( !Empty( ::cObrOrg ),;
            ( ::oPedCliT:CCODOBR >= ::cObrOrg .AND. ::oPedCliT:CCODOBR <= ::cObrDes ),;
            .t. )                                                                           .AND.;
         lChkSer( ::oPedCliT:CSERPED, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oPedCliL:Seek( ::oPedCliT:CSERPED + Str( ::oPedCliT:NNUMPED ) + ::oPedCliT:CSUFPED )

            while ::oPedCliT:CSERPED + Str( ::oPedCliT:NNUMPED ) + ::oPedCliT:CSUFPED == ::oPedCliL:CSERPED + Str( ::oPedCliL:NNUMPED ) + ::oPedCliL:CSUFPED .AND. ! ::oPedCliL:eof()

               if ::oPedCliL:CREF >= ::cArtOrg                                      .AND.;
                  ::oPedCliL:CREF <= ::cArtDes                                      .AND.;
                  if ( ::lTvta, ::oPedCliL:cTipMov == ::cTipVen, .t. )              .AND.;
                  !( ::lExcCero .AND. ::oPedCliL:NPREUNIT == 0 )

                  ::oDbf:Append()

                  ::oDbf:CCODCLI := ::oPedCliT:CCODCLI
                  ::oDbf:CNOMCLI := ::oPedCliT:CNOMCLI
                  ::oDbf:DFECMOV := ::oPedCliT:DFECPED

                  ::oDbf:CCODART := ::oPedCliL:CREF
                  ::oDbf:CNOMART := ::oPedCliL:cDetalle

                  ::oDbf:CDOCMOV := ::oPedCliL:CSERPED + "/" + Str( ::oPedCliL:NNUMPED ) + "/" + ::oPedCliL:CSUFPED

                  ::AddCliente( ::oPedCliT:CCODCLI, ::oPedCliT, .f. )

                  ::oDbf:Save()

               end if

               ::oPedCliL:Skip()

            end while

         end if

      end if

      ::oPedCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//














































































































































































































































































































































































































