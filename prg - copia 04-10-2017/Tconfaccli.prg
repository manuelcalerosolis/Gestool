#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TConFacCli FROM TInfGen

   DATA  lTvta       AS LOGIC    INIT .f.
   DATA  cTipVen     AS CHARACTER
   DATA  cTipVen2    AS CHARACTER
   DATA  oEstado     AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Liquidada", "Todas" }
   DATA  oArtKit     AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT
   DATA  oDbfCliAtp  AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

   METHOD nCosteCli( cCodCli )

   METHOD nDtoAtpCli( cCodCli )

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodCli", "C", 12, 0, {|| "@!" },      "Cód. cli.",            .f., "Cod. Cliente",           8, .f. )
   ::AddField( "cNomCli", "C", 50, 0, {|| "@!" },      "Cliente",              .f., "Nom. Cliente",          30, .f. )
   ::AddField( "cCodArt", "C", 18, 0, {|| "@!" },      "Código artículo",            .f., "Cod. Artículo",         14, .f. )
   ::AddField( "cNomArt", "C",100, 0, {|| "@!" },      "Artículo",             .t., "Artículo",              25, .f. )
   ::AddField( "nCajEnt", "N", 16, 6, {|| MasUnd() },  cNombreCajas(),         .f., cNombreCajas(),          12, .t. )
   ::AddField( "nUniDad", "N", 16, 6, {|| MasUnd() },  cNombreunidades(),      .f., cNombreUnidades(),       12, .t. )
   ::AddField( "nUntEnt", "N", 16, 6, {|| MasUnd() },  "Tot. " + cNombreunidades(), .t., "Total " + cNombreUnidades(), 12, .t. )
   ::AddField( "nPreDiv", "N", 16, 6, {|| ::cPicImp }, "Importe",              .t., "Importe",               12, .t. )
   ::AddField( "nTotAge", "N", 16, 6, {|| ::cPicImp }, "Com. Age.",            .t., "Comisión agente",       12, .t. )
   ::AddField( "nPreMed", "N", 16, 6, {|| ::cPicImp }, "Pre. Med.",            .t., "Precio medio",          12, .f. )
   ::AddField( "nDtoAtp", "N", 16, 6, {|| "@E 99.99" },"% Dto.",               .t., "Descuento atípico",     12, .f. )
   ::AddField( "nNetUnd", "N", 16, 6, {|| ::cPicImp }, "Neto/Ud",              .t., "Neto unidad",           12, .f. )
   ::AddField( "nCoste",  "N", 16, 6, {|| ::cPicCom }, "Coste",                .t., "Coste",                 12, .f. )
   ::AddField( "nMargen", "N", 16, 6, {|| ::cPicImp }, "Margen %",             .t., "Margen %",              12, .f. )
   ::AddField( "nBenef",  "N", 16, 6, {|| ::cPicImp }, "Beneficio",            .t., "Beneficio",             12, .f. )

   ::AddTmpIndex( "CCODCLI", "CCODCLI + CCODART" )

   ::AddGroup( {|| ::oDbf:cCodCli }, {|| "Cliente : " + Rtrim( ::oDbf:cCodCli ) + "-" + Rtrim( ::oDbf:cNomCli ) }, {||"Total cliente..." } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TConFacCli

   local lOpen    := .t.
   local oError
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oArtKit     PATH ( cPatArt() ) FILE "ARTKIT.DBF"   VIA ( cDriver() ) SHARED INDEX "ARTKIT.CDX"

   ::oFacCliT     := TDataCenter():oFacCliT()     

   DATABASE NEW ::oFacCliL    PATH ( cPatEmp() ) FILE "FACCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oFacRecT    PATH ( cPatEmp() ) FILE "FACRECT.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL    PATH ( cPatEmp() ) FILE "FACRECL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   DATABASE NEW ::oDbfCliAtp  PATH ( cPatCli() ) FILE "CLIATP.DBF"   VIA ( cDriver() ) SHARED INDEX "CLIATP.CDX"

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TConFacCli

   if !Empty( ::oArtKit ) .and. ::oArtKit:Used()
      ::oArtKit:End()
   end if

   if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if

   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if

   if !Empty( ::oFacRecT ) .and. ::oFacRecT:Used()
      ::oFacRecT:End()
   end if

   if !Empty( ::oFacRecL ) .and. ::oFacRecL:Used()
      ::oFacRecL:End()
   end if

   if !Empty( ::oDbfCliAtp ) .and. ::oDbfCliAtp:Used()
      ::oDbfCliAtp:End()
   end if

   ::oArtKit      := nil
   ::oFacCliT     := nil
   ::oFacCliL     := nil
   ::oFacRecT     := nil
   ::oFacRecL     := nil
   ::oDbfCliAtp   := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TConFacCli

   local cEstado     := "Todas"
   local oTipVen
   local oTipVen2
   local This        := Self

   /*
   Monta el Recurso
   */

   if !::StdResource( "INF_GEN04C" )
      return .f.
   end if

   /*
   Monta los clientes
   */

   if !::oDefCliInf( 70, 80, 90, 100, , 600 )
      return .f.
   end if

   /*
   Monta los artículos
   */

   if !::lDefArtInf( 150, 160, 170, 180, 800 )
      return .f.
   end if

   /*
   Condiciones para excluir cuando sea 0
   */

   ::oDefExcInf()
   ::oDefExcImp()

   /*
   Montamos el combo para estado de las facturas
   */

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmFacCli(), ::oFacCliT:cAlias )

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TConFacCli

   local cExpHead  := ""
   local cExpLine  := ""

   /*Desabilitamos el diálogo mientrascargamos la base se datos*/
   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   /*Creamos la cabezera del informe*/
   ::aHeader   := {{|| "Fecha        : " + Dtoc( Date() ) },;
                   {|| "Periodo      : " + Dtoc( ::dIniInf )  + " > " + Dtoc( ::dFinInf ) },;
                   {|| "Clientes     : " + if( ::lAllCli, "Todos", Rtrim( ::cCliOrg ) + " > " + Rtrim( ::cCliDes ) ) },;
                   {|| "Artículos    : " + if( ::lAllArt, "Todos", Rtrim( ::cArtOrg ) + " > " + Rtrim( ::cArtDes ) ) },;
                   {|| "Estado       : " + ::aEstado[ ::oEstado:nAt ] },;
                   {|| if( !Empty( ::cTipVen ), "Tipo de Venta: " + ::cTipVen2, "Tipo de Venta: Todos" ) },;
                   {|| if( ::lTvta, "Aplicando comportamiento de los tipos de venta", "" ) } }

   /*Ordenamos las bases de datos por el campo necesario*/

   ::oFacCliT:OrdSetFocus( "dFecFac" )
   ::oFacCliL:OrdSetFocus( "nNumFac" )

   /*Creamos el filtro para las cabeceras*/
   do case
      case ::oEstado:nAt == 1
         cExpHead    := '!lLiquidada .and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 2
         cExpHead    := 'lLiquidada .and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 3
         cExpHead    := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   end case

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )

   /*Creamos el filtro para las líneas*/

   cExpLine          := '!lTotLin .and. !lControl'

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oFacCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliL:cFile ), ::oFacCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacCliT:GoTop()

   /*Recorremos las cabeceras de facturas*/

   while !::lBreak .and. !::oFacCliT:Eof()

      if lChkSer( ::oFacCliT:cSerie, ::aSer )

         /*Nos posicionamos en las lineas de detalle*/

         if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

            while ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac == ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac .AND. ! ::oFacCliL:eof()

               /* Pasamos de los tipos de comportamiento*/

               if !( ::lExcCero .and. ( nTotNFacCli( ::oFacCliL ) == 0 ) )                               .AND.;
                  !( ::lExcImp .and. ( nTotLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 ) )

                  /*Aqui entramos para acumular*/
                  
                  if ::oDbf:Seek( ::oFacCliT:cCodCli + ::oFacCliL:cRef )

                     ::oDbf:Load()

                     ::oDbf:nCajEnt += ::oFacCliL:nCanEnt
                     ::oDbf:nUnidad += ::oFacCliL:nUniCaja
                     ::oDbf:nUntEnt += nTotNFacCli( ::oFacCliL )
                     ::oDbf:nTotAge += nComLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nPreDiv += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nPreMed := ( ::oDbf:nPreDiv - ::oDbf:nTotAge ) / ::oDbf:nUntEnt
                     ::oDbf:nNetUnd := ::oDbf:nPreMed - ( ( ::oDbf:nPreMed * ::oDbf:nDtoAtp ) / 100 )
                     ::oDbf:nMargen := ( ( ::oDbf:nNetUnd - ::oDbf:nCoste ) / ::oDbf:nCoste ) * 100
                     ::oDbf:nBenef  := ( ::oDbf:nNetUnd - ::oDbf:nCoste ) * ::oDbf:nUntEnt

                     ::oDbf:Save()

                  else

                     ::oDbf:Append()

                     ::oDbf:cCodCli := ::oFacCliT:cCodCli
                     ::oDbf:cNomCli := ::oFacCliT:cNomCli
                     ::oDbf:cCodArt := ::oFacCliL:cRef
                     ::oDbf:cNomArt := ::oFacCliL:cDetalle
                     ::oDbf:nCajEnt := ::oFacCliL:nCanEnt
                     ::oDbf:nUnidad := ::oFacCliL:nUniCaja
                     ::oDbf:nUntEnt := nTotNFacCli( ::oFacCliL )
                     ::oDbf:nTotAge := nComLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nPreDiv := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nPreMed := ( ::oDbf:nPreDiv - ::oDbf:nTotAge ) / ::oDbf:nUntEnt
                     ::oDbf:nDtoAtp := ::nDtoAtpCli( ::oFacCliT:cCodCli )
                     ::oDbf:nNetUnd := ::oDbf:nPreMed - ( ( ::oDbf:nPreMed * ::oDbf:nDtoAtp ) / 100 )
                     ::oDbf:nCoste  := ::nCosteCli( ::oFacCliT:cCodCli, ::oFacCliL:cRef )
                     ::oDbf:nMargen := ( ( ::oDbf:nNetUnd - ::oDbf:nCoste ) / ::oDbf:nCoste ) * 100
                     ::oDbf:nBenef  := ( ::oDbf:nNetUnd - ::oDbf:nCoste ) * ::oDbf:nUntEnt

                     ::oDbf:Save()

                  end if

               end if

               ::oFacCliL:Skip()

            end while

         end if

      end if

      ::oFacCliT:Skip()

      /*damos valores al meter para ir actualizandolo*/
      ::oMtrInf:AutoInc()

   end while

   /*Destruimos los filtros*/

   ::oFacCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ) )
   ::oFacCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliL:cFile ) )

   /*
   Facturas rectificativas-----------------------------------------------------
   */

   /*Ordenamos las bases de datos por el campo necesario*/

   ::oFacRecT:OrdSetFocus( "dFecFac" )
   ::oFacRecL:OrdSetFocus( "nNumFac" )

   /*Creamos el filtro para las cabeceras*/
   do case
      case ::oEstado:nAt == 1
         cExpHead    := '!lLiquidada .and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 2
         cExpHead    := 'lLiquidada .and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 3
         cExpHead    := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   end case

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacRecT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )

   /*Creamos el filtro para las líneas*/

   cExpLine          := '!lTotLin .and. !lControl'

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oFacRecL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecL:cFile ), ::oFacRecL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacRecT:GoTop()

   /*Recorremos las cabeceras de facturas*/

   while !::lBreak .and. !::oFacRecT:Eof()

      if lChkSer( ::oFacRecT:cSerie, ::aSer )

         /*Nos posicionamos en las lineas de detalle*/

         if ::oFacRecL:Seek( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac )

            while ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac == ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac .AND. ! ::oFacRecL:eof()

               /* Pasamos de los tipos de comportamiento*/

               if !( ::lExcCero .and. ( nTotNFacRec( ::oFacRecL ) == 0 ) )                               .AND.;
                  !( ::lExcImp .and. ( nTotLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 ) )

                  /*Aqui entramos para acumular*/
                  if ::oDbf:Seek( ::oFacRecT:cCodCli + ::oFacRecL:cRef )

                     ::oDbf:Load()

                     ::oDbf:nCajEnt += ::oFacRecL:nCanEnt
                     ::oDbf:nUnidad += ::oFacRecL:nUniCaja
                     ::oDbf:nUntEnt += nTotNFacRec( ::oFacRecL )
                     ::oDbf:nTotAge += nComLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nPreDiv += nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nPreMed := ( ::oDbf:nPreDiv - ::oDbf:nTotAge ) / ::oDbf:nUntEnt
                     ::oDbf:nNetUnd := ::oDbf:nPreMed - ( ( ::oDbf:nPreMed * ::oDbf:nDtoAtp ) / 100 )
                     ::oDbf:nMargen := ( ( ::oDbf:nNetUnd - ::oDbf:nCoste ) / ::oDbf:nCoste ) * 100
                     ::oDbf:nBenef  := ( ::oDbf:nNetUnd - ::oDbf:nCoste ) * ::oDbf:nUntEnt

                     ::oDbf:Save()

                  else

                     ::oDbf:Append()

                     ::oDbf:cCodCli := ::oFacRecT:cCodCli
                     ::oDbf:cNomCli := ::oFacRecT:cNomCli
                     ::oDbf:cCodArt := ::oFacRecL:cRef
                     ::oDbf:cNomArt := ::oFacRecL:cDetalle
                     ::oDbf:nCajEnt := ::oFacRecL:nCanEnt
                     ::oDbf:nUnidad := ::oFacRecL:nUniCaja
                     ::oDbf:nUntEnt := nTotNFacRec( ::oFacRecL )
                     ::oDbf:nTotAge := nComLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nPreDiv := nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nPreMed := ( ::oDbf:nPreDiv - ::oDbf:nTotAge ) / ::oDbf:nUntEnt
                     ::oDbf:nDtoAtp := ::nDtoAtpCli( ::oFacRecT:cCodCli )
                     ::oDbf:nNetUnd := ::oDbf:nPreMed - ( ( ::oDbf:nPreMed * ::oDbf:nDtoAtp ) / 100 )
                     ::oDbf:nCoste  := ::nCosteCli( ::oFacRecT:cCodCli, ::oFacRecL:cRef )
                     ::oDbf:nMargen := ( ( ::oDbf:nNetUnd - ::oDbf:nCoste ) / ::oDbf:nCoste ) * 100
                     ::oDbf:nBenef  := ( ::oDbf:nNetUnd - ::oDbf:nCoste ) * ::oDbf:nUntEnt

                     ::oDbf:Save()

                  end if

               end if

               ::oFacRecL:Skip()

            end while

         end if

      end if

      ::oFacRecT:Skip()

      /*damos valores al meter para ir actualizandolo*/
      ::oMtrInf:AutoInc()

   end while

   /*Destruimos los filtros*/

   ::oFacRecT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ) )
   ::oFacRecL:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecL:cFile ) )

   ::oMtrInf:AutoInc( ::oFacCliT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD nCosteCli( cCodCli, cCodArt )

   local nCoste
   local nOrdAnt  := ::oDbfCliAtp:OrdSetFocus( "cCliArt" )

   if ::oDbfCliAtp:Seek( cCodCli + cCodArt )
      if ::oDbfCliAtp:lPrcCom
         nCoste   := ::oDbfCliAtp:nPrcCom
      else
         nCoste   := nCosto( cCodArt, ::oDbfArt:cAlias, ::oArtKit:cAlias )
      end if
   else
      nCoste      := nCosto( cCodArt, ::oDbfArt:cAlias, ::oArtKit:cAlias )
   end if

   ::oDbfCliAtp:OrdSetFocus( nOrdAnt )

RETURN( nCoste )

//---------------------------------------------------------------------------//

METHOD nDtoAtpCli( cCodCli )

   local nDtoAtp  := 0
   local nOrdAnt  := ::oDbfCli:OrdSetFocus( "COD" )

   if ::oDbfCli:Seek( cCodCli )
      nDtoAtp     := ::oDbfCli:nDtoAtp
   end if

   ::oDbfCli:OrdSetFocus( nOrdAnt )

RETURN( nDtoAtp )

//---------------------------------------------------------------------------//