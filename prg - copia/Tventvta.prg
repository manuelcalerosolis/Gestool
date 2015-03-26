#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION TVenVta()

   local oInf
   local aCol  := {}
   local aIdx  := {}

   aAdd( aCol, { "CCODART", "C", 18, 0, {|| "@!" },             "Cod. artículo",  .t., "Codigo artículo",  14,} )
   aAdd( aCol, { "CNOMART", "C",100, 0, {|| "@!" },             "Descripción",    .t., "Descripción",      45,} )
   aAdd( aCol, { "cCodFam", "C", 16, 0, {|| "@!" },             "Fam.",           .t., "Familia",           5,} )
   aAdd( aCol, { "NCAJENT", "N", 19, 6, {|| MasUnd() },         "Caj.",           .f., "Cajas",            12,} )
   aAdd( aCol, { "NUNIDAD", "N", 19, 6, {|| MasUnd() },         "Und.",           .f., "Unidades",         12,} )
   aAdd( aCol, { "NUNTENT", "N", 19, 6, {|| MasUnd() },         "Tot. Und.",      .t., "Unidades x caja",  12,} )
   aAdd( aCol, { "NPREDIV", "N", 19, 6, {|| oInf:cPicOut },     "Importe",        .t., "Importe",          12,} )
   aAdd( aCol, { "NIVAART", "N", 19, 6, {|| oInf:cPicOut },     cImp(),         .t., cImp(),           12,} )
   aAdd( aCol, { "NPREMED", "N", 19, 6, {|| oInf:cPicImp },     "Precio medio",   .f., "Precio medio",     12, .f.} )

   aAdd( aIdx, { "CCODART", "CCODART" } )

   oInf  := TInfVenVta():New( "Informe resumido de ventas de clientes agrupado por artículos", aCol, aIdx, "01051" )

   oInf:Resource()
   oInf:Activate()

   oInf:End()

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TInfVenVta FROM TInfGen

   DATA  oEstado     AS OBJECT
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT { "Todos" }

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   /*
   Ficheros necesarios
   */

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"
   ::oAlbCliL:OrdSetFocus( "CREF" )

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"
   ::oFacCliL:OrdSetFocus( "CREF" )

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) FILE "TIKET.DBF" VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) FILE "TIKEL.DBF" VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"
   ::oTikCliL:OrdSetFocus( "cCbaTil" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   ::oAlbCliT:End()
   ::oAlbCliL:End()
   ::oFacCliT:End()
   ::oFacCliL:End()
   ::oTikCliT:End()
   ::oTikCliL:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld )

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

METHOD lGenerate()

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

         nCajEnt        := 0
         nUniEnt        := 0
         nUntEnt        := 0
         nImpDiv        := 0
         nIvaArt        := 0

         /*
         Albaranes
         */

         IF ::oAlbCliL:Seek( ::oDbfArt:Codigo )

            WHILE ::oAlbCliL:cRef = ::oDbfArt:Codigo .AND. !::oAlbCliL:Eof()

               IF dFecAlbCli( ::oAlbCliL:CSERALB + Str( ::oAlbCliL:NNUMALB ) + ::oAlbCliL:CSUFALB, ::oAlbCliT:cAlias ) >= ::dIniInf  .AND.;
                  dFecAlbCli( ::oAlbCliL:CSERALB + Str( ::oAlbCliL:NNUMALB ) + ::oAlbCliL:CSUFALB, ::oAlbCliT:cAlias ) <= ::dFinInf  .AND.;
                  lChkSer( ::oAlbCliT:CSERALB, ::aSer )                                                                              .AND.;
                  !lFacAlbCli( ::oAlbCliL:CSERALB + Str( ::oAlbCliL:NNUMALB ) + ::oAlbCliL:CSUFALB, ::oAlbCliT:cAlias, ::oAlbCliT )  .AND.;
                  !( ::lExcImp .AND. ::oAlbCliL:nPreUnit == 0 )                                                                      .AND.;
                  !( ::lExcCero .AND. nTotNAlbCli( ::oAlbCliL ) == 0 )

                  nCajEnt  += ::oAlbCliL:nCanEnt
                  nUniEnt  += ::oAlbCliL:nUniCaja
                  nUntEnt  += nTotNAlbCli( ::oAlbCliL )
                  nPreDiv  := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  nImpDiv  += nPreDiv
                  nIvaArt  += Round( nPreDiv * ::oAlbCliL:NIVA / 100, ::nDerOut )

               END IF

               ::oAlbCliL:Skip()

            END WHILE

         END IF

         /*
         Facturas
         */

         IF ::oFacCliL:Seek( ::oDbfArt:Codigo )

            WHILE ::oFacCliL:cRef = ::oDbfArt:Codigo .AND. !::oFacCliL:Eof()

               IF dFecFacCli( ::oFacCliL:cSerie + Str( ::oFacCliL:NNUMFac ) + ::oFacCliL:CSUFFac, ::oFacCliT:cAlias ) >= ::dIniInf   .AND.;
                  dFecFacCli( ::oFacCliL:cSerie + Str( ::oFacCliL:NNUMFac ) + ::oFacCliL:CSUFFac, ::oFacCliT:cAlias ) <= ::dFinInf   .AND.;
                  lChkSer( ::oFacCliT:cSerie, ::aSer )                                                                               .AND.;
                  !( ::lExcImp .AND. ::oFacCliL:nPreUnit == 0 )                                                                      .AND.;
                  !( ::lExcCero .AND. nTotNFacCli( ::oFacCliL ) == 0 )

                  nCajEnt  += ::oFacCliL:nCanEnt
                  nUniEnt  += ::oFacCliL:nUniCaja
                  nUntEnt  += nTotNFacCli( ::oFacCliL )
                  nPreDiv  := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  nImpDiv  += nPreDiv
                  nIvaArt  += Round( nPreDiv * ::oFacCliL:NIVA / 100, ::nDerOut )

               END IF

               ::oFacCliL:Skip()

            END WHILE

         END IF

         /*
         Tikets
         */

         IF ::oTikCliL:Seek( ::oDbfArt:Codigo )

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

         END IF

         if nImpDiv != 0

            ::oDbf:Append()
            ::oDbf:cCodArt := ::oDbfArt:CODIGO
            ::oDbf:cNomArt := ::oDbfArt:NOMBRE
            ::oDbf:cCodFam := ::oDbfArt:FAMILIA
            ::oDbf:nCajEnt := nCajEnt
            ::oDbf:nUnidad := nUniEnt
            ::oDbf:nUntEnt := nUntEnt
            ::oDbf:nPreDiv := nImpDiv
            ::oDbf:nIvaArt := nIvaArt
            ::oDbf:nPreMed := nImpDiv / nUntEnt
            ::oDbf:Save()

         end if

      END IF

      ::oMtrInf:AutoInc( ::oDbfArt:OrdKeyNo() )
      ::oDbfArt:Skip()

   END WHILE

   ::oMtrInf:AutoInc( ::oDbfArt:OrdKeyNo() )
   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//