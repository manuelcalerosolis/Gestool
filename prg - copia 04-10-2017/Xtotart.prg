#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS XTotArt FROM TInfGen

   DATA  lExcCero    AS LOGIC       INIT .f.
   DATA  lResumen    AS LOGIC       INIT .f.
   DATA  nEstado     AS NUMERIC     INIT 1
   DATA  oPedPrvL    AS OBJECT
   DATA  oPedCliL    AS OBJECT
   DATA  oAlbPrvT    AS OBJECT
   DATA  oAlbPrvL    AS OBJECT
   DATA  oFacPrvT    AS OBJECT
   DATA  oFacPrvL    AS OBJECT
   DATA  oRctPrvT    AS OBJECT
   DATA  oRctPrvL    AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT
   DATA  oDbfArt     AS OBJECT
   DATA  oHisMov     AS OBJECT
   DATA  oTMov       AS OBJECT
   DATA  oEstado     AS OBJECT
   DATA  aEstado     AS ARRAY       INIT { "Precios de costo medio", "�ltimo precio costo", "Precio 1", "Precio 2", "Precio 3", "Precio 4", "Precio 5", "Precio 6" }
   DATA  cEstado     AS CHARACTER   INIT "�ltimo precio costo"
   DATA  oStock      AS OBJECT
   DATA  oProLin     AS OBJECT
   DATA  oProMat     AS OBJECT
   DATA  oProCab     AS OBJECT
   DATA  oArtDiv     AS OBJECT
   DATA  oDbfKit     AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

   METHOD nRetPrecio()

   METHOD nRetPrecioPropiedades( cCodArt, cValPrp1, cValPrp2 )

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField ( "cCodAlm", "C", 16, 0, {|| "@!" },          "Alm.",          .t., "C�digo almacen",    3, .f. )
   ::AddField ( "cNomAlm", "C", 50, 0, {|| "@!" },          "Almac�n",       .t., "Almac�n",          35, .f. )
   ::AddField ( "cCodArt", "C", 18, 0, {|| "@!" },          "C�digo art�culo",     .f., "C�digo art�culo",  14, .f. )
   ::AddField ( "cNomArt", "C",100, 0, {|| "@!" },          "Art�culo",      .f., "Art�culo",         35, .f. )
   ::AddField ( "cValPr1", "C", 20, 0, {|| "@!" },          "Prp. 1",        .t., "Propiedad 1",      10, .f. )
   ::AddField ( "cValPr2", "C", 20, 0, {|| "@!" },          "Prp. 2",        .t., "Propiedad 2",      10, .f. )
   ::AddField ( "cLote",   "C", 14, 0, {|| "@!" },          "Lote",          .f., "Lote",              6, .f. )
   ::AddField ( "nTotEnt", "N", 16, 6, {|| MasUnd() },      "Tot. und.",     .t., "Total unidades",   10, .t. )
   ::AddField ( "nImpArt", "N", 16, 6, {|| ::cPicOut },     "Importe",       .t., "Importe",          10, .f. )
   ::AddField ( "nTotImp", "N", 16, 6, {|| ::cPicOut },     "Tot. imp.",     .t., "Total importe",    10, .t. )

   ::AddTmpIndex( "cCodArt", "cCodArt + cCodAlm + cValPr1 + cValPr2 + cLote" )

   ::AddGroup( {|| ::oDbf:cCodArt },{|| "Art�culo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oDbfArt ) ) }, {|| Space(1) } )

   ::dIniInf   := CtoD( "01/01/2000" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oPedPrvL PATH ( cPatEmp() ) FILE "PEDPROVL.DBF" VIA ( cDriver() ) SHARED INDEX "PEDPROVL.CDX"

   DATABASE NEW ::oPedCliL PATH ( cPatEmp() ) FILE "PEDCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "PEDCLIL.CDX"

   DATABASE NEW ::oAlbPrvT PATH ( cPatEmp() ) FILE "ALBPROVT.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVT.CDX"

   DATABASE NEW ::oAlbPrvL PATH ( cPatEmp() ) FILE "ALBPROVL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"

   DATABASE NEW ::oFacPrvT PATH ( cPatEmp() ) FILE "FACPRVT.DBF"  VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"

   DATABASE NEW ::oFacPrvL PATH ( cPatEmp() ) FILE "FACPRVL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"

   DATABASE NEW ::oRctPrvT PATH ( cPatEmp() ) FILE "RCTPRVT.DBF"  VIA ( cDriver() ) SHARED INDEX "RCTPRVT.CDX"

   DATABASE NEW ::oRctPrvL PATH ( cPatEmp() ) FILE "RCTPRVL.DBF"  VIA ( cDriver() ) SHARED INDEX "RCTPRVL.CDX"

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "ALBCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oFacRecT PATH ( cPatEmp() ) FILE "FACRECT.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL PATH ( cPatEmp() ) FILE "FACRECL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) FILE "TIKET.DBF"    VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) FILE "TIKEL.DBF"    VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oHisMov  PATH ( cPatEmp() ) FILE "HISMOV.DBF"   VIA ( cDriver() ) SHARED INDEX "HISMOV.CDX"

   DATABASE NEW ::oTMov    PATH ( cPatDat() ) FILE "TMOV.DBF"     VIA ( cDriver() ) SHARED INDEX "TMOV.CDX"

   DATABASE NEW ::oProLin  PATH ( cPatEmp() ) FILE "PROLIN.DBF"   VIA ( cDriver() ) SHARED INDEX "PROLIN.CDX"

   DATABASE NEW ::oProMat  PATH ( cPatEmp() ) FILE "PROMAT.DBF"   VIA ( cDriver() ) SHARED INDEX "PROMAT.CDX"

   DATABASE NEW ::oProCab  PATH ( cPatEmp() ) FILE "PROCAB.DBF"   VIA ( cDriver() ) SHARED INDEX "PROCAB.CDX"

   DATABASE NEW ::oDbfKit  PATH ( cPatArt() ) FILE "ARTKIT.DBF"   VIA ( cDriver() ) SHARED INDEX "ARTKIT.CDX"

   DATABASE NEW ::oArtDiv  PATH ( cPatArt() ) FILE "ARTDIV.DBF"   VIA ( cDriver() ) SHARED INDEX "ARTDIV.CDX"
   ::oArtDiv:OrdSetFocus( "cValPrp" )

   ::oStock             := TStock():Create( cPatEmp() )

   if ::oStock:lOpenFiles()
      ::oStock:cAlbPrvT := ::oAlbPrvT:cAlias
      ::oStock:cAlbPrvL := ::oAlbPrvL:cAlias
      ::oStock:cFacPrvT := ::oFacPrvT:cAlias
      ::oStock:cFacPrvL := ::oFacPrvL:cAlias
      ::oStock:cRctPrvT := ::oRctPrvT:cAlias
      ::oStock:cRctPrvL := ::oRctPrvL:cAlias
      ::oStock:cAlbCliT := ::oAlbCliT:cAlias
      ::oStock:cAlbCliL := ::oAlbCliL:cAlias
      ::oStock:cFacCliT := ::oFacCliT:cAlias
      ::oStock:cFacCliL := ::oFacCliL:cAlias
      ::oStock:cFacRecT := ::oFacRecT:cAlias
      ::oStock:cFacRecL := ::oFacRecL:cAlias
      ::oStock:cTikT    := ::oTikCliT:cAlias
      ::oStock:cTikL    := ::oTikCliL:cAlias
      ::oStock:cProducL := ::oProLin:cAlias
      ::oStock:cProducM := ::oProMat:cAlias
      ::oStock:cProducT := ::oProCab:cAlias
      ::oStock:cHisMovT  := ::oHisMov:cAlias
      ::oStock:cPedPrvL := ::oPedPrvL:cAlias
      ::oStock:cPedCliL := ::oPedCliL:cAlias
      ::oStock:cKit     := ::oDbfKit:cAlias
   end if

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oPedPrvL ) .and. ::oPedPrvL:Used()
      ::oPedPrvL:End()
   end if
   if !Empty( ::oPedCliL ) .and. ::oPedCliL:Used()
      ::oPedCliL:End()
   end if
   if !Empty( ::oAlbPrvT ) .and. ::oAlbPrvT:Used()
      ::oAlbPrvT:End()
   end if
   if !Empty( ::oAlbPrvL ) .and. ::oAlbPrvL:Used()
      ::oAlbPrvL:End()
   end if
   if !Empty( ::oFacPrvT ) .and. ::oFacPrvT:Used()
      ::oFacPrvT:End()
   end if
   if !Empty( ::oFacPrvL ) .and. ::oFacPrvL:Used()
      ::oFacPrvL:End()
   end if
   if !Empty( ::oRctPrvT ) .and. ::oRctPrvT:Used()
      ::oRctPrvT:End()
   end if
   if !Empty( ::oRctPrvL ) .and. ::oRctPrvL:Used()
      ::oRctPrvL:End()
   end if
   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if
   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
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
   if !Empty( ::oTikClit ) .and. ::oTikClit:Used()
      ::oTikClit:End()
   end if
   if !Empty( ::oTikClil ) .and. ::oTikClil:Used()
      ::oTikClil:End()
   end if
   if !Empty( ::oHisMov ) .and. ::oHisMov:Used()
      ::oHisMov:End()
   end if
   if !Empty( ::oTMov ) .and. ::oTMov:Used()
      ::oTMov:End()
   end if
   if !Empty( ::oProLin ) .and. ::oProLin:Used()
      ::oProLin:End()
   end if
   if !Empty( ::oProMat ) .and. ::oProMat:Used()
      ::oProMat:End()
   end if
   if !Empty( ::oProCab ) .and. ::oProCab:Used()
      ::oProCab:End()
   end if
   if !Empty( ::oArtDiv ) .and. ::oArtDiv:Used()
      ::oArtDiv:End()
   end if

   if !Empty( ::oDbfKit ) .and. ::oDbfKit:Used()
      ::oDbfKit:End()
   end if

   if !Empty( ::oStock )
      ::oStock:end()
   end if

   ::oPedPrvL := nil
   ::oPedCliL := nil
   ::oAlbPrvT := nil
   ::oAlbPrvL := nil
   ::oFacPrvT := nil
   ::oFacPrvL := nil
   ::oRctPrvT := nil
   ::oRctPrvL := nil
   ::oAlbCliT := nil
   ::oAlbCliL := nil
   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oFacRecT := nil
   ::oFacRecL := nil
   ::oTikCliT := nil
   ::oTikCliL := nil
   ::oHisMov  := nil
   ::oTMov    := nil
   ::oProLin  := nil
   ::oProMat  := nil
   ::oProCab  := nil
   ::oStock   := nil
   ::oArtDiv  := nil
   ::oDbfKit  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INF_TOTART" )
      return .f.
   end if

   /*
   Monta los articulos de manera automatica
   */

   if !::lDefArtInf( 70, 80, 90, 100, 800 )
      return .f.
   end if

   /*
   Monta los Almac�n
   */

   if !::oDefAlmInf( 110, 120, 130, 140, 600 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oDbfArt:Lastrec() )

   ::oDefExcInf()

   ::oDefResInf()

   REDEFINE COMBOBOX ::oEstado ;
      VAR      ::cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   /*
   Lo informamos aqu�, porque en openfiles no est� abierta todavia la tabla----
   */

   ::oStock:cArticulo       := ::oDbfArt:cAlias

   ::CreateFilter( aItmArt(), ::oDbfArt:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local nEvery
   local cExpArt   := ""
   local aStkActual
   local aStock

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                        {|| "Desde    : " + Dtoc( ::dIniInf ) },;
                        {|| "Hasta    : " + Dtoc( ::dFinInf ) },;
                        {|| "Art�culo : " + if( ::lAllArt, "Todos", Rtrim( ::cArtOrg )+ " > " + Rtrim( ::cArtDes ) ) } }

   ::oDbfArt:OrdSetFocus( "Codigo" )

   if !Empty( ::oFilter:cExpresionFilter )
      cExpArt        := ::oFilter:cExpresionFilter
   else
      cExpArt        := '.t.'
   end if

   ::oDbfArt:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oDbfArt:cFile ), ::oDbfArt:OrdKey(), ( cExpArt ), , , , , , , , .t. )

   ::oDbfArt:GoTop()

   ::oMtrInf:SetTotal( ::oDbfArt:Lastrec() )
   nEvery            := Int( ::oMtrInf:nTotal / 10 )
   ::oMtrInf:cText   := "Procesando"

   while !::lBreak .and. !::oDbfArt:Eof()

      if ( ::lAllArt .or. ( ::oDbfArt:Codigo >= ::cArtOrg .AND. ::oDbfArt:Codigo <= ::cArtDes ) ) .and.;
         ( ::oDbfArt:nCtlStock != 3 )

         aStkActual  := ::oStock:aStockArticulo( ::oDbfArt:Codigo, , , , , ::dIniInf, ::dFinInf )

         if len( aStkActual ) != 0

            for each aStock in aStkActual

               if ( ::lAllAlm .or. ( aStock:cCodigoAlmacen >= ::cAlmOrg .and. aStock:cCodigoAlmacen <= ::cAlmDes ) ) .and.;
                  !( ::lExcCero .and. aStock:nUnidades == 0 )

                  ::oDbf:Append()

                  ::oDbf:cCodAlm := aStock:cCodigoAlmacen
                  ::oDbf:cNomAlm := oRetFld( aStock:cCodigoAlmacen, ::oDbfAlm )
                  ::oDbf:cCodArt := ::oDbfArt:Codigo
                  ::oDbf:cNomArt := ::oDbfArt:Nombre
                  ::oDbf:cValPr1 := aStock:cValorPropiedad1
                  ::oDbf:cValPr2 := aStock:cValorPropiedad2
                  ::oDbf:cLote   := aStock:cLote
                  ::oDbf:nTotEnt := aStock:nUnidades
                  ::oDbf:nImpArt := ::nRetPrecioPropiedades( ::oDbfArt:Codigo, aStock:cCodigoPropiedad1, aStock:cCodigoPropiedad2, aStock:cValorPropiedad1, aStock:cValorPropiedad1 )
                  ::oDbf:nTotImp := ::oDbf:nTotEnt * ::oDbf:nImpArt

                  ::oDbf:Save()

               end if

            next

         end if

      end if

      ::oDbfArt:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oDbfArt:IdxDelete( cCurUsr(), GetFileNoExt( ::oDbfArt:cFile ) )

   ::oMtrInf:Set( ::oDbfArt:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD nRetPrecio( cCodArt )

	local nPreMed 	:= 0

   do case
   case ::cEstado == "Precios de costo medio"
         nPreMed := ::oStock:nCostoMedio( cCodArt )
         //nPreMedCom( cCodArt, nil, ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nValDiv, ::nDecOut, ::nDerOut, ::oHisMov:cAlias )
   case ::cEstado == "�ltimo precio costo"
      if ::oDbfArt:Seek( cCodArt )
         nPreMed := Round( ::oDbfArt:pCosto  / ::nValDiv, ::nDerOut )
      end if
   case ::cEstado == "Precio 1"
      if ::oDbfArt:Seek( cCodArt )
         nPreMed := Round( ::oDbfArt:pVenta1 / ::nValDiv, ::nDerOut )
      end if
   case ::cEstado == "Precio 2"
      if ::oDbfArt:Seek( cCodArt )
         nPreMed := Round( ::oDbfArt:pVenta2 / ::nValDiv, ::nDerOut )
      end if
   case ::cEstado == "Precio 3"
      if ::oDbfArt:Seek( cCodArt )
         nPreMed := Round( ::oDbfArt:pVenta3 / ::nValDiv, ::nDerOut )
      end if
   case ::cEstado == "Precio 4"
      if ::oDbfArt:Seek( cCodArt )
         nPreMed := Round( ::oDbfArt:pVenta4 / ::nValDiv, ::nDerOut )
      end if
   case ::cEstado == "Precio 5"
      if ::oDbfArt:Seek( cCodArt )
         nPreMed := Round( ::oDbfArt:pVenta5 / ::nValDiv, ::nDerOut )
      end if
   case ::cEstado == "Precio 6"
      if ::oDbfArt:Seek( cCodArt )
         nPreMed := Round( ::oDbfArt:pVenta6 / ::nValDiv, ::nDerOut )
      end if
   end case

RETURN ( nPreMed )

//---------------------------------------------------------------------------//

METHOD nRetPrecioPropiedades( cCodArt, cCodPrp1, cCodPrp2, cValPrp1, cValPrp2 )

   local nPreMed  := 0

   do case
   case ::cEstado == "Precios de costo medio"
         nPreMed := ::oStock:nCostoMedio( cCodArt, , cCodPrp1, cCodPrp2, cValPrp1, cValPrp2 )
         //nPreMedCom( cCodArt, nil, ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nValDiv, ::nDecOut, ::nDerOut, ::oHisMov:cAlias )
   case ::cEstado == "�ltimo precio costo"
      if ::oArtDiv:Seek( cCodArt + cValPrp1 + cValPrp2 )
         nPreMed := Round( ::oArtDiv:nPreCom / ::nValDiv, ::nDerOut )
      end if
   case ::cEstado == "Precio 1"
      if ::oArtDiv:Seek( cCodArt + cValPrp1 + cValPrp2 )
         nPreMed := Round( ::oArtDiv:nPreVta1 / ::nValDiv, ::nDerOut )
      end if
   case ::cEstado == "Precio 2"
      if ::oArtDiv:Seek( cCodArt + cValPrp1 + cValPrp2 )
         nPreMed := Round( ::oArtDiv:nPreVta2 / ::nValDiv, ::nDerOut )
      end if
   case ::cEstado == "Precio 3"
      if ::oArtDiv:Seek( cCodArt + cValPrp1 + cValPrp2 )
         nPreMed := Round( ::oArtDiv:nPreVta3 / ::nValDiv, ::nDerOut )
      end if
   case ::cEstado == "Precio 4"
      if ::oArtDiv:Seek( cCodArt + cValPrp1 + cValPrp2 )
         nPreMed := Round( ::oArtDiv:nPreVta4 / ::nValDiv, ::nDerOut )
      end if
   case ::cEstado == "Precio 5"
      if ::oArtDiv:Seek( cCodArt + cValPrp1 + cValPrp2 )
         nPreMed := Round( ::oArtDiv:nPreVta5 / ::nValDiv, ::nDerOut )
      end if
   case ::cEstado == "Precio 6"
      if ::oArtDiv:Seek( cCodArt + cValPrp1 + cValPrp2 )
         nPreMed := Round( ::oArtDiv:nPreVta6 / ::nValDiv, ::nDerOut )
      end if
   end case

   if nPreMed == 0
      nPreMed    := ::nRetPrecio( cCodArt )
   end if

RETURN ( nPreMed )

//---------------------------------------------------------------------------//