#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION TVenFac()

   local oInf
   local aCol  := {}
   local aIdx  := {}

   aAdd( aCol, { "cCodArt", "C", 18, 0, {|| "@!" },             "Cod. artículo",  .t., "Código artículo",  14,} )
   aAdd( aCol, { "cNomArt", "C",100, 0, {|| "@!" },             "Descripción",    .t., "Descripción",      45,} )
   aAdd( aCol, { "cCodFam", "C", 16, 0, {|| "@!" },             "Fam.",           .t., "Familia",           5,} )
   aAdd( aCol, { "nCajEnt", "N", 19, 6, {|| MasUnd() },         "Caj.",           .t., "Cajas",            12,} )
   aAdd( aCol, { "nUniEnt", "N", 19, 6, {|| MasUnd() },         "Und.",           .t., "Unidades",         12,} )
   aAdd( aCol, { "nTotEnt", "N", 19, 6, {|| MasUnd() },         "Tot. Und.",      .t., "Total unidades",   12,} )
   aAdd( aCol, { "nTotPes", "N", 19, 6, {|| MasUnd() },         "Tot. pes.",      .f., "Total peso",       12 } )
   aAdd( aCol, { "nPreDiv", "N", 19, 6, {|| oInf:cPicOut },     "Importe",        .t., "Importe",          12,} )
   aAdd( aCol, { "nIvaArt", "N", 19, 6, {|| oInf:cPicOut },     cImp(),         .t., cImp(),           12,} )
   aAdd( aCol, { "nPntVer", "N", 19, 6, {|| oInf:cPicOut },     "P.V.",           .f., "Punto verde",      12,} )
   aAdd( aCol, { "nPreMed", "N", 19, 6, {|| oInf:cPicImp },     "Precio medio",   .f., "Precio medio",     12, .f.} )

   aAdd( aIdx, { "cCodArt", "cCodArt" } )

   oInf  := TInfVenFac():New( "Informe resumido de facturas de clientes agrupados por artículos", aCol, aIdx, "01042" )

   oInf:Resource()
   oInf:Activate()

   oInf:End()

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TInfVenFac FROM TInfGen

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFamilia    AS OBJECT
    
   DATA  aEstado     AS ARRAY    INIT { "Pendiente", "Liquidada", "Todas" }

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TInfVenFac

   /*
   Ficheros necesarios
   */

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"
   ::oFacCliL:OrdSetFocus( "CREF" )

   DATABASE NEW ::oFamilia PATH ( cPatEmp() ) FILE "FAMILIAS.DBF" VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TInfVenFac

   ::oFacCliT:End()
   ::oFacCliL:End()
   ::oFamilia:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TInfVenFac

   local cEstado := "Todas"

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

METHOD lGenerate() CLASS TInfVenFac

   local bValid
   local nTotPes  := 0
   local nImpDiv  := 0
   local nCajEnt  := 0
   local nUniEnt  := 0
   local nTotEnt  := 0
   local nIvaArt  := 0
   local nPreDiv  := 0
   local nPntVer  := 0

   ::oDlg:Disable()

   ::oDbf:Zap()
   ::oDbfArt:GoTop()

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| !::oFacCliT:lLiquidada }
      case ::oEstado:nAt == 2
         bValid   := {|| ::oFacCliT:lLiquidada }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

   ::aHeader      := {  {|| "Fecha   : " + Dtoc( Date() ) },;
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

         IF ::oFacCliL:Seek( ::oDbfArt:Codigo )

            nCajEnt        := 0
            nUniEnt        := 0
            nTotEnt        := 0
            nTotPes        := 0
            nImpDiv        := 0
            nIvaArt        := 0
            nPntVer        := 0

            WHILE ::oFacCliL:cRef == ::oDbfArt:Codigo .AND. !::oFacCliL:Eof()

               IF dFecFacCli( ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac, ::oFacCliT:cAlias ) >= ::dIniInf   .AND.;
                  dFecFacCli( ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac, ::oFacCliT:cAlias ) <= ::dFinInf   .AND.;
                  lChkSer( ::oFacCliL:cSerie, ::aSer )                                                                               .AND.;
                  !( ::lExcImp .AND. ::oFacCliL:nPreUnit == 0 )                                                                      .AND.;
                  !( ::lExcCero .AND. nTotNFacCli( ::oFacCliL ) == 0 )

                  nCajEnt  += ::oFacCliL:nCanEnt
                  nUniEnt  += ::oFacCliL:nUniCaja
                  nTotEnt  += nTotNFacCli( ::oFacCliL )
                  nTotPes  += nTotNFacCli( ::oFacCliL ) * oRetFld( ::oFacCliL:cRef, ::oDbfArt, "nPesoKg" )
                  nPreDiv  := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  nImpDiv  += nPreDiv
                  nIvaArt  += Round( nPreDiv * ::oFacCliL:NIVA / 100, ::nDerOut )
                  nPntVer  += nPntLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )

               END IF

               ::oFacCliL:Skip()

            END WHILE

            ::oDbf:Append()
            ::oDbf:cCodArt := ::oDbfArt:Codigo
            ::oDbf:cNomArt := ::oDbfArt:Nombre
            ::oDbf:cCodFam := ::oDbfArt:Familia
            ::oDbf:nCajEnt := nCajEnt
            ::oDbf:nUniEnt := nUniEnt
            ::oDbf:nTotEnt := nTotEnt
            ::oDbf:nTotPes := nTotPes
            ::oDbf:nPreDiv := nImpDiv
            ::oDbf:nIvaArt := nIvaArt
            ::oDbf:nPreMed := nImpDiv / nTotEnt
            ::oDbf:nPntVer := nPntVer
            ::oDbf:Save()

         END IF

      END IF

      ::oDbfArt:Skip()
      ::oMtrInf:AutoInc( ::oDbfArt:OrdKeyNo() )

   END WHILE

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//