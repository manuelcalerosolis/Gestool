#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION TCliArt()

   local oInf
   local aCol  := {}
   local aIdx  := {}

   aAdd( aCol, { "CCODCLI", "C", 12, 0, {|| "@!" },             "Cod. cli.",                 .f., "Código cliente",             14 } )
   aAdd( aCol, { "CNOMCLI", "C", 50, 0, {|| "@!" },             "Cliente",                   .f., "Nombre cliente",             25 } )
   aAdd( aCol, { "CNIFCLI", "C", 15, 0, {|| "@!" },             "Nif",                       .f., "Nif",                        12 } )
   aAdd( aCol, { "CDOMCLI", "C", 35, 0, {|| "@!" },             "Domicilio",                 .f., "Domicilio",                  20 } )
   aAdd( aCol, { "CPOBCLI", "C", 35, 0, {|| "@!" },             "Población",                 .f., "Población",                  25 } )
   aAdd( aCol, { "CPROCLI", "C", 20, 0, {|| "@!" },             "Provincia",                 .f., "Provincia",                  20 } )
   aAdd( aCol, { "CCDPCLI", "C",  7, 0, {|| "@!" },             "Cod. pos.",                 .f., "Cod. postal",                 7 } )
   aAdd( aCol, { "CTLFCLI", "C", 12, 0, {|| "@!" },             "Teléfono",                  .f., "Teléfono",                   12 } )
   aAdd( aCol, { "CCODFAM", "C", 16, 0, {|| "@!" },             "Cod. fam.",                 .f., "Código familia",              5 } )
   aAdd( aCol, { "CNOMFAM", "C", 30, 0, {|| "@!" },             "Familia",                   .f., "Familia",                    15 } )
   aAdd( aCol, { "CCODART", "C", 18, 0, {|| "@!" },             "Código artículo",                 .t., "Código artículo",            14 } )
   aAdd( aCol, { "CNOMART", "C",100, 0, {|| "@!" },             "Artículo"   ,               .t., "Artículo",                   45 } )
   aAdd( aCol, { "NCAJENT", "N", 19, 6, {|| MasUnd() },         "Caj.",                      .t., "Cajas",                      12 } )
   aAdd( aCol, { "NUNIDAD", "N", 19, 6, {|| MasUnd() },         "Und.",                      .t., "Unidades",                   12 } )
   aAdd( aCol, { "NUNTENT", "N", 19, 6, {|| MasUnd() },         "Tot. und.",                 .t., "Total unidades",             12 } )
   aAdd( aCol, { "NPREDIV", "N", 19, 6, {|| oInf:cPicOut },     "Importe",                   .t., "Importe",                    12 } )
   aAdd( aCol, { "NIVAART", "N", 19, 6, {|| oInf:cPicOut },     cImp(),                    .t., cImp(),                     12 } )
   aAdd( aCol, { "NPREMED", "N", 19, 6, {|| oInf:cPicImp },     "Pre. med.",                 .f., "Precio medio",               12, .f. } )
   aAdd( aCol, { "NACUCAJ", "N", 19, 6, {|| MasUnd() },         "Acu. caj.",                 .f., "Acumulado cajas",            12 } )
   aAdd( aCol, { "NACUUNI", "N", 19, 6, {|| MasUnd() },         "Acu. und.",                 .f., "Acumulado unidades",         12 } )
   aAdd( aCol, { "NACUUNT", "N", 19, 6, {|| MasUnd() },         "Acu. tot.",                 .f., "Acumulado unidades x caja",  12 } )
   aAdd( aCol, { "NACUPRE", "N", 19, 6, {|| oInf:cPicOut },     "Acu. imp.",                 .f., "Acumulado importe",          12 } )
   aAdd( aCol, { "NACUIVA", "N", 19, 6, {|| oInf:cPicOut },     "Acu. " + cImp(),            .f., "Acumulado " + cImp(),        12 } )
   aAdd( aCol, { "NACUMED", "N", 19, 6, {|| oInf:cPicOut },     "Acu. med.",                 .f., "Acumulado precio medio",     12 } )

   aAdd( aIdx, { "CCODART", "CCODCLI + CCODFAM + CCODART" } )

   oInf  := TInfCliArt():New( "Informe de ventas facturas de clientes agrupado por artículos", aCol, aIdx )

   oInf:AddGroup( {|| oInf:oDbf:cCodCli },                     {|| "Cliente : " + Rtrim( oInf:oDbf:cCodCli ) + "-" + Rtrim( oInf:oDbf:cNomCli ) }, {||"Total cliente..."} )
   oInf:AddGroup( {|| oInf:oDbf:cCodCli + oInf:oDbf:cCodFam }, {|| "Familia : " + Rtrim( oInf:oDbf:cCodFam ) + "-" + Rtrim( oInf:oDbf:cNomFam ) }, {||"Total familia..."} )

   oInf:Resource()
   oInf:Activate()

   oInf:End()

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TInfCliArt FROM TInfGen

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFamilia    AS OBJECT
   DATA  oDbfArt
   DATA  cCodFam
   DATA  aEstado     AS ARRAY    INIT { "Pendiente", "Liquidada", "Todas" }

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

   METHOD Suma()

   METHOD Acumula()

   METHOD lBuildIfNot()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TInfVenFac

  local oBlock
  local oError
  local lOpen := .t.

    /*
   Ficheros necesarios
   */

   oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::oFacCliT := TDataCenter():oFacCliT()
   ::oFacCliT:OrdSetFocus( "cCodCli" )

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oDbfArt PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   RECOVER USING oError

      lOpen := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TInfVenFac

   if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if

   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()

   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TInfVenFac

   local cEstado := "Todas"

   if !::StdResource( "INF_GEN12" )
      return .f.
   end if

   /*
   Monta familias
   */

   ::oDefCliInf( 70, 80, 90, 100 )

   /*
   Monta familias
   */

   ::lDefFamInf( 110, 120, 130, 140 )

   /*
   Meter
   */

   ::oMtrInf:SetTotal( ::oDbfCli:Lastrec() )

   ::oDefExcInf( 202 )

   ::oDefExcImp( 201 )

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

   local nImpDiv  := 0
   local nCajEnt  := 0
   local nUntEnt  := 0
   local nUniEnt  := 0
   local nIvaArt  := 0
   local nPreDiv  := 0
   local dFecFac

   ::oDlg:Disable()

   ::oDbf:Zap()

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
                        {|| "Familia : " + ::cFamOrg         + " > " + ::cFamDes },;
                        {|| "Clientes: " + ::cCliOrg         + " > " + ::cCliDes },;
                        {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ] } }

   /*
   Nos movemos por las cabeceras de los albaranes a proveedores
	*/

   ::oDbfCli:GoTop()
   while !::oDbfCli:Eof()

      if ::oDbfCli:Cod >= ::cCliOrg             .and.;
         ::oDbfCli:Cod <= ::cCliDes

         /*
         Vamos a buscar las facturas de este cliente
         */

         if ::oFacCliT:Seek( ::oDbfCli:Cod )    .and.;
            lChkSer( ::oFacCliT:cSerie, ::aSer )

            while ::oFacCliT:cCodCli == ::oDbfCli:Cod .and. !::oFacCliT:Eof()

               /*
               Nos posicionamos en las lineas de detalle
               */

               if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

                  while ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac == ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac .and. !::oFacCliL:Eof()

                     ::cCodFam  := oRetFld( ::oFacCliL:cRef, ::oDbfArt, "Familia" )

                     if ::cCodFam >= ::cFamOrg                                      .and.;
                        ::cCodFam <= ::cFamDes                                      .and.;
                        !( ::lExcImp .and. ::oFacCliL:nPreUnit == 0 )               .and.;
                        !( ::lExcCero .and. nTotNFacCli( ::oFacCliL ) == 0 )

                        ::lBuildIfNot()

                        if ::oFacCliT:dFecFac >= ::dIniInf .and. ::oFacCliT:dFecFac <= ::dFinInf
                           ::Suma()
                           ::Acumula()
                        else
                           ::Acumula()
                        end if

                     end if

                     ::oFacCliL:Skip()

                  end while

               end if

               ::oFacCliT:Skip()

            end while

         end if

      end if

      ::oDbfCli:Skip()
      ::oMtrInf:AutoInc( ::oDbfCli:OrdKeyNo() )

   end while

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD Suma()

   local nPreDiv  := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

   ::oDbf:Load()
   ::oDbf:nCajEnt += ::oFacCliL:nCanEnt
   ::oDbf:nUniDad += ::oFacCliL:nUniCaja
   ::oDbf:nUntEnt += nTotNFacCli( ::oFacCliL )
   ::oDbf:nPreDiv += nPreDiv
   ::oDbf:nIvaArt += Round( nPreDiv * ::oFacCliL:NIVA / 100, ::nDerOut )
   ::oDbf:nPreMed := ::oDbf:nPreDiv / ::oDbf:nUntEnt
   ::oDbf:Save()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Acumula()

   local nPreDiv  := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

   ::oDbf:Load()
   ::oDbf:nAcuCaj += ::oFacCliL:nCanEnt
   ::oDbf:nAcuUni += ::oFacCliL:nUniCaja
   ::oDbf:nAcuUnt += nTotNFacCli( ::oFacCliL )
   ::oDbf:nAcuPre += nPreDiv
   ::oDbf:nAcuIva += Round( nPreDiv * ::oFacCliL:NIVA / 100, ::nDerOut )
   ::oDbf:nAcuMed := ::oDbf:nAcuPre / ::oDbf:nAcuUnt
   ::oDbf:Save()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lBuildIfNot()

   if !::oDbf:Seek( ::oFacCliT:cCodCli + ::cCodFam + ::oFacCliL:cRef )

      ::oDbf:Append()
      ::oDbf:Blank()

      ::oDbf:cCodCli := ::oFacCliT:cCodCli
      ::oDbf:cNomCli := ::oFacCliT:cNomCli

      ::AddCliente( ::oFacCliT:cCodCli, ::oFacCliT, .f. )

      ::oDbf:cCodFam := ::cCodFam
      ::oDbf:cNomFam := retFamilia( ::cCodFam, ::oFamilia )

      ::oDbf:cCodArt := ::oFacCliL:cRef
      ::oDbf:cNomArt := ::oFacCliL:cDetalle

      ::oDbf:Save()

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//