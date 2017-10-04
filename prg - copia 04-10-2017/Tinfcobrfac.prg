#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfCObrFac FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendientes", "Cobradas", "Todas" }
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField ( "cCodObr", "C", 18, 0, {|| "@!" },         "Dirección",                      .f., "Código dirección",            14 )
   ::AddField ( "cNomObr", "C", 50, 0, {|| "@!" },         "Nom.obra",                  .f., "Nombre dirección",            20 )
   ::AddField ( "cCodArt", "C", 18, 0, {|| "@!" },         "Cod. artículo",             .t., "Código artículo",        14 )
   ::AddField ( "cNomArt", "C",100, 0, {|| "@!" },         "Descripción",               .t., "Nombre artículo",        32 )
   ::FldPropiedades()
   ::AddField ( "cCodCli", "C", 12, 0, {|| "@!" },         "Cód. cli.",                 .f., "Cod. Cliente",            8 )
   ::AddField ( "cNomCli", "C", 50, 0, {|| "@!" },         "Cliente",                   .f., "Nom. Cliente",           30 )
   ::AddField ( "cNifCli", "C", 15, 0, {|| "@!" },         "Nif",                       .f., "Nif",                    12 )
   ::AddField ( "cDomCli", "C", 35, 0, {|| "@!" },         "Domicilio",                 .f., "Domicilio",              20 )
   ::AddField ( "cPobCli", "C", 25, 0, {|| "@!" },         "Población",                 .f., "Población",              25 )
   ::AddField ( "cProCli", "C", 20, 0, {|| "@!" },         "Provincia",                 .f., "Provincia",              20 )
   ::AddField ( "cCdpCli", "C",  7, 0, {|| "@!" },         "Cod. Postal",               .f., "Cod. Postal",             7 )
   ::AddField ( "cTlfCli", "C", 12, 0, {|| "@!" },         "Teléfono",                  .f., "Teléfono",               12 )
   ::AddField ( "cCodAlm", "C", 18, 0, {|| "@!" },         "Cod. Almacen",              .f., "Código almacén",         18 )
   ::AddField ( "cCodAge", "C", 18, 0, {|| "@!" },         "Cod. Agente",               .f., "Código agente",          18 )
   ::AddField ( "nNumCaj", "N", 16, 6, {|| MasUnd() },     cNombreCajas(),              .f., cNombreCajas(),           12 )
   ::AddField ( "nNumUnd", "N", 16, 6, {|| MasUnd() },     cNombreunidades(),           .f., cNombreunidades(),        12 )
   ::AddField ( "nTotUnd", "N", 16, 6, {|| MasUnd() },     "Tot. " + cNombreunidades(), .t., "Total " + cNombreunidades(), 12 )
   ::AddField ( "nImpArt", "N", 16, 6, {|| ::cPicOut },    "Importe",                   .t., "Importe",                12 )
   ::AddField ( "cDocMov", "C", 14, 0, {|| "@!" },         "Documento",                 .t., "Documento",              14 )
   ::AddField ( "dFecMov", "D",  8, 0, {|| "@!" },         "Fecha",                     .t., "Fecha",                  10 )

   ::AddTmpIndex( "cCodCli", "cCodCli + cCodObr" )

   ::AddGroup( {|| ::oDbf:cCodCli }, {|| "Cliente  : " + Rtrim( ::oDbf:cCodCli ) + "-" + oRetFld( ::oDbf:cCodCli, ::oDbfCli ) }, {||"Total Cliente..."} )
   ::AddGroup( {|| ::oDbf:cCodCli + ::oDbf:cCodObr }, {|| "Obras  : " + Rtrim( ::oDbf:cCodObr ) + "-" + RTrim ( ::oDbf:CNOMOBR ) }, {||"Total Obras..."} )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FacCliL.DBF" VIA ( cDriver() ) SHARED INDEX "FacCliL.CDX"

   DATABASE NEW ::oFacRecT PATH ( cPatEmp() ) FILE "FacRecT.DBF" VIA ( cDriver() ) SHARED INDEX "FacRecT.CDX"

   DATABASE NEW ::oFacrecL PATH ( cPatEmp() ) FILE "FacRecL.DBF" VIA ( cDriver() ) SHARED INDEX "FacRecL.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

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

   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oFacRecT := nil
   ::oFacRecL := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld )

   local cEstado := "Todas"

   if !::StdResource( "INF_GEN04" )
      return .f.
   end if

   /*
   Monta los clientes de manera automatica
   */

   if !::oDefCliInf( 70, 80, 90, 100, , 600 )
      return .f.
   end if

   /* Monta obras */

   if !::oDefObrInf( 110, 120, 130, 140, 220 )
      return .f.
   end if

   /*
   Monta los articulos de manera automatica
   */

   if !::lDefArtInf( 150, 160, 170, 180, 800 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )

   ::oDefExcInf( 200 )

   ::oDefExcImp( 210 )

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmFacCli(), ::oFacCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead := ""
   local cExpLine := ""
   local lExcCero := .f.

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader   := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                     {|| "Periodo   : " + Dtoc( ::dIniInf )   + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Clientes  : " + if( ::lAllCli, "Todos", AllTrim( ::cCliOrg ) + " > " + AllTrim (::cCliDes ) ) },;
                     {|| "Obras     : " + if( ::lAllObr, "Todos", AllTrim( ::cObrOrg ) + " > " + AllTrim (::cObrDes ) ) },;
                     {|| "Artículos : " + if( ::lAllArt, "Todos", AllTrim( ::cArtOrg ) + " > " + AllTrim (::cArtDes ) ) },;
                     {|| "Estado    : " + ::aEstado[ ::oEstado:nAt ] } }

   /*
   comenzamos con las facturas de clientes
   */

   ::oFacCliT:OrdSetFocus( "dFecFac" )
   ::oFacCliL:OrdSetFocus( "nNumFac" )

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

   if !::lAllObr
      cExpHead       += ' .and. cCodObr >= "' + Rtrim( ::cObrOrg ) + '" .and. cCodObr <= "' + Rtrim( ::cObrDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )

   /*
   Lineas de albaranes
   */

   cExpLine          := '!lTotLin .and. !lControl'

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oFacCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliL:cFile ), ::oFacCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacCliT:GoTop()
   while !::lBreak .and. !::oFacCliT:Eof()

      if lChkSer( ::oFacCliT:cSerie, ::aSer ) .and. ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         while ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac == ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac .AND. ! ::oFacCliL:eof()

            if !( ::lExcCero .AND. nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

               ::oDbf:Append()

               ::AddCliente( ::oFacCliT:cCodCli, ::oFacCliT, .f. )

               ::oDbf:cCodObr := ::oFacCliT:cCodObr
               ::oDbf:cNomObr := RetObras( ::oFacCliT:cCodCli, ::oFacCliT:cCodObr, ::oDbfObr:cAlias )
               ::oDbf:cCodAlm := ::oFacCliT:cCodAlm
               ::oDbf:cCodAge := ::oFacCliT:cCodAge
               ::oDbf:dFecMov := ::oFacCliT:dFecFac
               ::oDbf:nNumCaj := ::oFacCliL:nCanEnt
               ::oDbf:nNumUnd := ::oFacCliL:nUniCaja
               ::oDbf:cCodArt := ::oFacCliL:cRef
               ::oDbf:cNomArt := ::oFacCliL:cDetalle
               ::oDbf:cCodPr1 := ::oFacCliL:cCodPr1
               ::oDbf:cNomPr1 := retProp( ::oFacCliL:cCodPr1 )
               ::oDbf:cCodPr2 := ::oFacCliL:cCodPr2
               ::oDbf:cNomPr2 := retProp( ::oFacCliL:cCodPr2 )
               ::oDbf:cValPr1 := ::oFacCliL:cValPr1
               ::oDbf:cNomVl1 := retValProp( ::oFacCliL:cCodPr1 + ::oFacCliL:cValPr1 )
               ::oDbf:cValPr2 := ::oFacCliL:cValPr2
               ::oDbf:cNomVl2 := retValProp( ::oFacCliL:cCodPr2 + ::oFacCliL:cValPr2 )
               ::oDbf:nTotUnd := nTotNFacCli( ::oFacCliL )
               ::oDbf:nImpArt := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:cDocMov := Ltrim( ::oFacCliL:cSerie ) + "/" + Ltrim( Str( ::oFacCliL:nNumFac ) ) + "/" + Ltrim( ::oFacCliL:cSufFac )

               ::oDbf:Save()

            end if

            ::oFacCliL:Skip()

         end while

      end if

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oFacCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ) )
   ::oFacCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliL:cFile ) )

   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )

   /*
   comenzamos con las rectificativas
   */

   ::oFacRecT:OrdSetFocus( "dFecFac" )
   ::oFacRecL:OrdSetFocus( "nNumFac" )

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

   if !::lAllObr
      cExpHead       += ' .and. cCodObr >= "' + Rtrim( ::cObrOrg ) + '" .and. cCodObr <= "' + Rtrim( ::cObrDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacRecT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )

   /*
   Lineas de albaranes
   */

   cExpLine          := '!lTotLin .and. !lControl'

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oFacRecL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecL:cFile ), ::oFacRecL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacRecT:GoTop()

   while !::lBreak .and. !::oFacRecT:Eof()

      if lChkSer( ::oFacRecT:cSerie, ::aSer ) .and. ::oFacRecL:Seek( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         while ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac == ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac .AND. ! ::oFacRecL:eof()

            if !( ::lExcCero .AND. nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

               ::oDbf:Append()

               ::AddCliente( ::oFacRecT:cCodCli, ::oFacRecT, .f. )

               ::oDbf:cCodObr := ::oFacRecT:cCodObr
               ::oDbf:cNomObr := RetObras( ::oFacRecT:cCodCli, ::oFacRecT:cCodObr, ::oDbfObr:cAlias )
               ::oDbf:cCodAlm := ::oFacRecT:CCODALM
               ::oDbf:cCodAge := ::oFacRecT:CCODAGE
               ::oDbf:dFecMov := ::oFacRecT:DFECFac
               ::oDbf:nNumCaj := ::oFacRecL:nCanEnt
               ::oDbf:nNumUnd := ::oFacRecL:nUniCaja
               ::oDbf:cCodArt := ::oFacRecL:cRef
               ::oDbf:cNomArt := ::oFacRecL:cDetalle
               ::oDbf:cCodPr1 := ::oFacRecL:cCodPr1
               ::oDbf:cNomPr1 := retProp( ::oFacRecL:cCodPr1 )
               ::oDbf:cCodPr2 := ::oFacRecL:cCodPr2
               ::oDbf:cNomPr2 := retProp( ::oFacRecL:cCodPr2 )
               ::oDbf:cValPr1 := ::oFacRecL:cValPr1
               ::oDbf:cNomVl1 := retValProp( ::oFacRecL:cCodPr1 + ::oFacRecL:cValPr1 )
               ::oDbf:cValPr2 := ::oFacRecL:cValPr2
               ::oDbf:cNomVl2 := retValProp( ::oFacRecL:cCodPr2 + ::oFacRecL:cValPr2 )
               ::oDbf:nTotUnd := nTotNFacRec( ::oFacRecL )
               ::oDbf:nImpArt := nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:cDocMov := lTrim ( ::oFacRecL:cSerie ) + "/" + lTrim ( Str( ::oFacRecL:nNumFac ) ) + "/" + lTrim ( ::oFacRecL:cSufFac )

               ::oDbf:Save()

            end if

            ::oFacRecL:Skip()

         end while

      end if

      ::oFacRecT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oFacRecT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ) )
   ::oFacRecL:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecL:cFile ) )

   ::oMtrInf:SetTotal( ::oFacRecT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//