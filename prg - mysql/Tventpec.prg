#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfVenPed FROM TInfGen

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT

   DATA  oPedCliT    AS OBJECT
   DATA  oPedCliL    AS OBJECT
   DATA  oFamilia    AS OBJECT
    
   DATA  aEstado     AS ARRAY    INIT { "Pendiente", "Parcialmente", "Entregado", "Todos" }

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

   METHOD Create()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "CCODART", "C", 18, 0, {|| "@!" },          "Código",         .t., "Código artículo",  14, .f. )
   ::AddField( "CNOMART", "C",100, 0, {|| "@!" },          "Artículo",       .t., "Artículo",         45, .f. )
   ::AddField( "cCodFam", "C", 16, 0, {|| "@!" },          "Fam.",           .t., "Familia",           5, .f. )
   ::AddField( "NCAJENT", "N", 19, 6, {|| MasUnd() },      "Caj.",           .t., "Cajas",            12, .f. )
   ::AddField( "NUNIDAD", "N", 19, 6, {|| MasUnd() },      "Und.",           .t., "Unidades",         12, .f. )
   ::AddField( "NUNTENT", "N", 19, 6, {|| MasUnd() },      "Tot. Und.",      .t., "Total unidades",   12, .t. )
   ::AddField( "NPREDIV", "N", 19, 6, {|| ::cPicOut },     "Importe",        .t., "Importe",          12, .f. )
   ::AddField( "NIVAART", "N", 19, 6, {|| ::cPicOut },     cImp(),         .t., cImp(),           12, .f. )
   ::AddField( "NPREMED", "N", 19, 6, {|| ::cPicImp },     "Precio medio",   .f., "Precio medio",     12, .f. )

   ::AddTmpIndex( "CCODART", "CCODART" )

RETURN ( Self )

//---------------------------------------------------------------------------

METHOD OpenFiles() CLASS TInfVenPed

   /*
   Ficheros necesarios
   */

   ::oPedCliT := TDataCenter():oPedCliT()

   DATABASE NEW ::oPedCliL PATH ( cPatEmp() ) FILE "PEDCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "PEDCLIL.CDX"
   ::oPedCliL:OrdSetFocus( "CREF" )

   DATABASE NEW ::oFamilia PATH ( cPatArt() ) FILE "FAMILIAS.DBF" VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TInfVenPed

   ::oPedCliT:End()
   ::oPedCliL:End()
   ::oFamilia:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TInfVenPed

   local cEstado := "Todos"

   if !::StdResource( "INF_GEN10A" )
      return .f.
   end if

   /*
   Monta los articulos de manera automatica
   */

   ::lDefArtInf( 110, 120, 130, 140 )

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oDbfArt:Lastrec() )

   ::oDefExcInf( 204 )

   ::oDefExcImp( 205 )

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmPedCli(), ::oPedCliT )

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TInfVenPed

   local bValid
   local nImpDiv  := 0
   local nCajEnt  := 0
   local nUniEnt  := 0
   local nUntEnt  := 0
   local nIvaArt  := 0
   local nPreDiv  := 0

   ::oDlg:Disable()

   ::oDbf:Zap()
   ::oDbfArt:GoTop()

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

   ::aHeader   := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Artículo: " + ::cArtOrg         + " > " + ::cArtDes },;
                     {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ] } }

   /*
   Nos movemos por las cabeceras de los albaranes a proveedores
	*/

   WHILE !::oDbfArt:Eof()

      IF Eval( bValid )                .AND.;
         ::oDbfArt:CODIGO >= ::cArtOrg .AND.;
         ::oDbfArt:CODIGO <= ::cArtDes

         IF ::oPedCliL:Seek( ::oDbfArt:Codigo )

            nCajEnt        := 0
            nUniEnt        := 0
            nUntEnt        := 0
            nImpDiv        := 0
            nIvaArt        := 0

            WHILE ::oPedCliL:cRef == ::oDbfArt:Codigo .AND. !::oPedCliL:Eof()

               IF dFecPedCli( ::oPedCliL:CSERPed + Str( ::oPedCliL:NNUMPed ) + ::oPedCliL:CSUFPed, ::oPedCliT:cAlias ) >= ::dIniInf  .AND.;
                  dFecPedCli( ::oPedCliL:CSERPed + Str( ::oPedCliL:NNUMPed ) + ::oPedCliL:CSUFPed, ::oPedCliT:cAlias ) <= ::dFinInf  .AND.;
                  lChkSer( ::oPedCliT:CSERPed, ::aSer )                                                                              .AND.;
                  !( ::lExcImp .AND. ::oPedCliL:nPreUnit == 0 )                                                                      .AND.;
                  !( ::lExcCero .AND. nTotNPedCli( ::oPedCliL ) == 0 )

                  nPreDiv  := nImpLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                  nCajEnt  += ::oPedCliL:nCanEnt
                  nUniEnt  += ::oPedCliL:nUniCaja
                  nUntEnt  += nTotNPedCli( ::oPedCliL )
                  nImpDiv  += nPreDiv
                  nIvaArt  += Round( nPreDiv * ::oPedCliL:nIva / 100, ::nDerOut )

               END IF

               ::oPedCliL:Skip()

            END WHILE

            ::oDbf:Append()
            ::oDbf:cCodArt := ::oDbfArt:CODIGO
            ::oDbf:cNomArt := ::oDbfArt:NOMBRE
            ::oDbf:cCodFam := ::oDbfArt:FAMILIA
            ::oDbf:nCajEnt := nCajEnt
            ::oDbf:nUntEnt := nUntEnt
            ::oDbf:nUnidad := nUniEnt
            ::oDbf:nPreDiv := nImpDiv
            ::oDbf:nIvaArt := nIvaArt
            ::oDbf:nPreMed := nImpDiv / nUntEnt
            ::oDbf:Save()

         END IF

      END IF

      ::oMtrInf:AutoInc( ::oDbfArt:OrdKeyNo() )
      ::oDbfArt:Skip()

   END WHILE

   ::oMtrInf:AutoInc( ::oDbfArt:OrdKeyNo() )
   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//