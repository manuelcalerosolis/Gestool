#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION TVenTik()

   local oInf
   local aCol  := {}
   local aIdx  := {}

   aAdd( aCol, { "CCODART", "C", 18, 0, {|| "@!" },             "Cod. Artículo",  .t., "Codigo Artículo",  14,} )
   aAdd( aCol, { "CNOMART", "C",100, 0, {|| "@!" },             "Descripción",    .t., "Descripción",      45,} )
   aAdd( aCol, { "cCodFam", "C", 16, 0, {|| "@!" },             "Fam.",           .t., "Familia",           5,} )
   aAdd( aCol, { "NUNTENT", "N", 19, 6, {|| MasUnd() },         "Tot. Und.",      .t., "Unidades",         12,} )
   aAdd( aCol, { "NPREDIV", "N", 19, 6, {|| oInf:cPicOut },     "Importe",        .t., "Importe",          12,} )
   aAdd( aCol, { "NIVAART", "N", 19, 6, {|| oInf:cPicOut },     cImp(),         .t., cImp(),           12,} )
   aAdd( aCol, { "NPREMED", "N", 19, 6, {|| oInf:cPicImp },     "Precio medio",   .f., "Precio medio",     12, .f.} )

   aAdd( aIdx, { "CCODART", "CCODART" } )

   oInf  := TInfVenTik():New( "Informe resumido de tikets de clientes agrupado por artículos", aCol, aIdx, "01051" )

   oInf:Resource()
   oInf:Activate()

   oInf:End()

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TInfVenTik FROM TInfGen

   DATA  oEstado     AS OBJECT
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT
   DATA  oFamilia    AS OBJECT
    
   DATA  aEstado     AS ARRAY    INIT { "Todos" }

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TInfVenTik

   /*
   Ficheros necesarios
   */

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) FILE "TIKET.DBF" VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) FILE "TIKEL.DBF" VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"
   ::oTikCliL:OrdSetFocus( "cCbaTil" )

   DATABASE NEW ::oFamilia PATH ( cPatArt() ) FILE "FAMILIAS.DBF" VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TInfVenTik

   ::oTikCliT:End()
   ::oTikCliL:End()
   ::oFamilia:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TInfVenTik

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

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TInfVenTik

   local nImpDiv  := 0
   local nCajEnt  := 0
   local nUniEnt  := 0
   local nUntEnt  := 0
   local nIvaArt  := 0
   local nPreDiv  := 0

   ::oDlg:Disable()

   ::oDbf:Zap()
   ::oDbfArt:GoTop()

   ::aHeader   := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Artículo: " + ::cArtOrg         + " > " + ::cArtDes },;
                     {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ] } }

   /*
   Nos movemos por las cabeceras de los Tikaranes a proveedores
	*/

   WHILE !::oDbfArt:Eof()

      IF ::oDbfArt:CODIGO >= ::cArtOrg .AND.;
         ::oDbfArt:CODIGO <= ::cArtDes

         IF ::oTikCliL:Seek( ::oDbfArt:Codigo )

            nUniEnt        := 0
            nImpDiv        := 0
            nIvaArt        := 0

            WHILE ::oTikCliL:cCbaTil = ::oDbfArt:Codigo .AND. !::oTikCliL:Eof()

               IF ( cTipTik( ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil, ::oTikCliT ) == "1"             .OR.;
                    cTipTik( ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil, ::oTikCliT ) == "4" )           .AND.;
                  dFecTik( ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil, ::oTikCliT:cAlias ) >= ::dIniInf  .AND.;
                  dFecTik( ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil, ::oTikCliT:cAlias ) <= ::dFinInf  .AND.;
                  lChkSer( ::oTikCliT:CSERTik, ::aSer )                                                                    .AND.;
                  !( ::lExcImp .AND. ::oTikCliL:nPvpTil == 0 )                                                             .AND.;
                  !( ::lExcCero .AND. ::oTikCliL:nUntTil == 0 )

                  nPreDiv     := nImpLTpv( ::oTikCliT:cAlias, ::oTikCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  if cTipTik( ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil, ::oTikCliT ) == "1"
                     nImpDiv  += nPreDiv
                     nUniEnt  += ::oTikCliL:nUntTil
                     nIvaArt  += Round( nPreDiv * ::oTikCliL:nIvaTil / 100, ::nDerOut )
                  else
                     nImpDiv  -= nPreDiv
                     nUniEnt  -= ::oTikCliL:nUntTil
                     nIvaArt  -= Round( nPreDiv * ::oTikCliL:nIvaTil / 100, ::nDerOut )
                  end if

               END IF

               ::oTikCliL:Skip()

            END WHILE

            ::oDbf:Append()
            ::oDbf:cCodArt := ::oDbfArt:CODIGO
            ::oDbf:cNomArt := ::oDbfArt:NOMBRE
            ::oDbf:cCodFam := ::oDbfArt:FAMILIA
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