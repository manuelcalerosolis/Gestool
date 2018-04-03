#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION TVenAlb()

   local oInf
   local aCol  := {}
   local aIdx  := {}

   aAdd( aCol, { "CCODART", "C", 18, 0, {|| "@!" },             "Código artículo",      .t., "Código artículo",  14,} )
   aAdd( aCol, { "CNOMART", "C",100, 0, {|| "@!" },             "Descripción",    .t., "Descripción",      45,} )
   aAdd( aCol, { "cCodFam", "C", 16, 0, {|| "@!" },             "Fam.",           .t., "Familia",           5,} )
   aAdd( aCol, { "NCAJENT", "N", 19, 6, {|| MasUnd() },         "Caj.",           .t., "Cajas",            12,} )
   aAdd( aCol, { "NUNIDAD", "N", 19, 6, {|| MasUnd() },         "Und.",           .t., "Unidades",         12,} )
   aAdd( aCol, { "NUNTENT", "N", 19, 6, {|| MasUnd() },         "Tot. und.",      .t., "Total unidades",   12,} )
   aAdd( aCol, { "NPREDIV", "N", 19, 6, {|| oInf:cPicOut },     "Importe",        .t., "Importe",          12,} )
   aAdd( aCol, { "NIVAART", "N", 19, 6, {|| oInf:cPicOut },     cImp(),         .t., cImp(),           12,} )
   aAdd( aCol, { "NPREMED", "N", 19, 6, {|| oInf:cPicImp },     "Precio medio",   .f., "Precio medio",     12, .f.} )

   aAdd( aIdx, { "CCODART", "CCODART" } )

   oInf  := TInfVenAlb():New( "Informe resumido de albaranes de clientes agrupado por artículos", aCol, aIdx, "01051" )

   oInf:Resource()
   oInf:Activate()

   oInf:End()

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TInfVenAlb FROM TInfGen

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oFamilia    AS OBJECT
    
   DATA  aEstado     AS ARRAY    INIT { "No facturado", "Facturado", "Todos" }

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TInfVenAlb

   /*
   Ficheros necesarios
   */

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"
   ::oAlbCliL:OrdSetFocus( "CREF" )

   DATABASE NEW ::oFamilia PATH ( cPatEmp() ) FILE "FAMILIAS.DBF" VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TInfVenAlb

   ::oAlbCliT:End()
   ::oAlbCliL:End()
   ::oFamilia:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TInfVenAlb

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

METHOD lGenerate() CLASS TInfVenAlb

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
         bValid   := {|| lFacturado( ::oAlbCliT ) }
      case ::oEstado:nAt == 2
         bValid   := {|| !lFacturado( ::oAlbCliT ) }
      case ::oEstado:nAt == 3
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

         IF ::oAlbCliL:Seek( ::oDbfArt:Codigo )

            nCajEnt        := 0
            nUniEnt        := 0
            nUntEnt        := 0
            nImpDiv        := 0
            nIvaArt        := 0

            WHILE ::oAlbCliL:cRef = ::oDbfArt:Codigo .AND. !::oAlbCliL:Eof()

               IF dFecAlbCli( ::oAlbCliL:CSERALB + Str( ::oAlbCliL:NNUMALB ) + ::oAlbCliL:CSUFALB, ::oAlbCliT:cAlias ) >= ::dIniInf  .AND.;
                  dFecAlbCli( ::oAlbCliL:CSERALB + Str( ::oAlbCliL:NNUMALB ) + ::oAlbCliL:CSUFALB, ::oAlbCliT:cAlias ) <= ::dFinInf  .AND.;
                  lChkSer( ::oAlbCliT:CSERALB, ::aSer )                                                                              .AND.;
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

            ::oDbf:Append()
            ::oDbf:cCODART := ::oDbfArt:CODIGO
            ::oDbf:cNOMART := ::oDbfArt:NOMBRE
            ::oDbf:cCodFam := ::oDbfArt:FAMILIA
            ::oDbf:nCAJENT := nCajEnt
            ::oDbf:nUNTENT := nUntEnt
            ::oDbf:nUnidad := nUniEnt
            ::oDbf:nPREDIV := nImpDiv
            ::oDbf:nIVAART := nIvaArt
            ::oDbf:NPREMED := nImpDiv / nUntEnt
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