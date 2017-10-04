#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS XInfValAlm FROM TInfGen

   DATA  lExcCero    AS LOGIC       INIT .f.
   DATA  lResumen    AS LOGIC       INIT .f.
   DATA  nEstado     AS NUMERIC     INIT 1
   DATA  oEstado     AS OBJECT
   DATA  aEstado     AS ARRAY       INIT { "Precios de costo medio", "Último precio costo", "Precio 1", "Precio 2", "Precio 3", "Precio 4", "Precio 5", "Precio 6" }
   DATA  cEstado     AS CHARACTER   INIT "Último precio costo"
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

   METHOD nRetPrecioPropiedades( cCodArt, cCodPrv1, cCodPrp2, cValPrp1, cValPrp2 )

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField ( "cCodFam", "C", 16, 0, {|| "@!" },          "Familia",           .f., "Familia",                   8, .f. )
   ::AddField ( "cNomFam", "C", 50, 0, {|| "@!" },          "Nom. fam.",         .f., "Nombre familia",           40, .f. )
   ::AddField ( "cCodAlm", "C", 16, 0, {|| "@!" },          "Alm.",              .f., "Código almacen",            3, .f. )
   ::AddField ( "cNomAlm", "C", 50, 0, {|| "@!" },          "Almacén",           .t., "Almacén",                  35, .f. )
   ::AddField ( "cCodArt", "C", 18, 0, {|| "@!" },          "Código artículo",         .t., "Código artículo",          14, .f. )
   ::AddField ( "cNomArt", "C",100, 0, {|| "@!" },          "Artículo",          .t., "Artículo",                 35, .f. )
   ::AddField ( "cValPr1", "C", 20, 0, {|| "@!" },          "Prp. 1",            .t., "Propiedad 1",              10, .f. )
   ::AddField ( "cValPr2", "C", 20, 0, {|| "@!" },          "Prp. 2",            .t., "Propiedad 2",              10, .f. )
   ::AddField ( "cLote",   "C", 14, 0, {|| "@!" },          "Lote",              .f., "Lote",                      6, .f. )
   ::AddField ( "nTotEnt", "N", 16, 6, {|| MasUnd() },      cNombreUnidades(),   .t., cNombreUnidades(),          10, .t. )
   ::AddField ( "nImpArt", "N", 16, 6, {|| ::cPicOut },     "Importe",           .t., "Importe",                  10, .f. )
   ::AddField ( "nTotImp", "N", 16, 6, {|| ::cPicOut },     "Tot. imp.",         .t., "Total importe",            10, .t. )

   ::AddTmpIndex( "cCodFam", "cCodFam + cCodAlm + cNomArt" )

   ::AddGroup( {|| ::oDbf:cCodFam },{|| "Familia : " + Rtrim( ::oDbf:cCodFam ) + "-" + Rtrim( ::oDbf:cNomFam ) }, {||"Total familia..."} )

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

   ::oStock          := TStock():Create( cPatEmp() )
   if !::oStock:lOpenFiles()
      lOpen          := .f.
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

   if !::StdResource( "INF_GEN08E" )
      return .f.
   end if

   /*
   Monta los almacenes de manera automatica
   */

   if !::oDefAlmInf( 70, 80, 90, 100, 700 )
      return .f.
   end if

   /*
   Monta las familias de manera automatica
   */

   if !::lDefFamInf( 110, 120, 130, 140, 800 )
      return .f.
   end if

   /*
   Monta los articulos de manera automatica
   */

   if !::lDefArtInf( 150, 151, 160, 161, 170 )
      return .f.
   end if

   ::oDefExcInf()

   ::oDefResInf()

   REDEFINE COMBOBOX ::oEstado ;
      VAR      ::cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   /*
   Lo informamos aquí, porque en openfiles no está abierta todavia la tabla----
   */

   ::oStock:cArticulo  := ::oDbfArt:cAlias

   ::CreateFilter( aItmArt(), ::oDbfArt:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead    := ""
   local aStkActual
   local aStock

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader         := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                           {|| "Periodo  : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                           {|| "Almacén  : " + if( ::lAllAlm, "Todos", AllTrim( ::cAlmOrg ) + " > " + AllTrim( ::cAlmDes ) ) },;
                           {|| "Familia  : " + if( ::lAllFam, "Todas", AllTrim( ::cFamOrg ) + " > " + AllTrim( ::cFamDes ) ) },;
                           {|| "Artículo : " + if( ::lAllArt, "Todos", AllTrim( ::cArtOrg ) + " > " + AllTrim( ::cArtDes ) ) } }

   if !::lAllArt
      cExpHead       := 'Codigo >= "' + Rtrim( ::cArtOrg ) + '" .and. Codigo <= "' + Rtrim( ::cArtDes ) + '"'
   else
      cExpHead       := '.t.'
   end if

   if !::lAllFam
      cExpHead       += ' .and. Familia >= "' + Rtrim( ::cFamOrg ) + '" .and. Familia <= "' + Rtrim( ::cFamDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oDbfArt:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oDbfArt:cFile ), ::oDbfArt:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oDbfArt:OrdKeyCount() )

   ::oDbfArt:GoTop()
   while !::lBreak .and. !::oDbfArt:Eof()

      if ( ::oDbfArt:nCtlStock != 3 )

         aStkActual  := ::oStock:aStockArticulo( ::oDbfArt:Codigo, , , , , ::dIniInf, ::dFinInf )

         if len( aStkActual ) != 0

            for each aStock in aStkActual

               if ( ::lAllAlm .or. ( aStock:cCodigoAlmacen >= ::cAlmOrg .and. aStock:cCodigoAlmacen <= ::cAlmDes ) ) .and.;
                  !( ::lExcCero .and. aStock:nUnidades == 0 )

                  ::oDbf:Append()

                  ::oDbf:cCodAlm := aStock:cCodigoAlmacen
                  ::oDbf:cNomAlm := oRetFld( aStock:cCodigoAlmacen, ::oDbfAlm )
                  ::oDbf:cCodFam := ::oDbfArt:Familia
                  ::oDbf:cNomFam := oRetFld( ::oDbfArt:Familia, ::oDbfFam )
                  ::oDbf:cCodArt := ::oDbfArt:Codigo
                  ::oDbf:cNomArt := ::oDbfArt:Nombre
                  ::oDbf:cValPr1 := aStock:cValorPropiedad1
                  ::oDbf:cValPr2 := aStock:cValorPropiedad2
                  ::oDbf:cLote   := aStock:cLote
                  ::oDbf:nTotEnt := aStock:nUnidades
                  ::oDbf:nImpArt := ::nRetPrecioPropiedades( ::oDbfArt:Codigo, aStock:cCodigoPropiedad1, aStock:cCodigoPropiedad2, aStock:cValorPropiedad1, aStock:cValorPropiedad2 )
                  ::oDbf:nTotImp := ::oDbf:nTotEnt * ::oDbf:nImpArt

                  ::oDbf:Save()

               end if

            next

         end if

      end if

      ::oDbfArt:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:Set( ::oDbfArt:LastRec() )

   ::oDbfArt:IdxDelete( cCurUsr(), GetFileNoExt( ::oDbfArt:cFile ) )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD nRetPrecio( cCodArt )

	local nPreMed 	:= 0

   do case
   case ::cEstado == "Precios de costo medio"
         nPreMed := ::oStock:nCostoMedio( cCodArt, , , , Space( 10 ), Space( 10 ) )

   case ::cEstado == "Último precio costo"
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

   local nPreMed     := 0

   DEFAULT cCodPrp1  := Space( 20 )
   DEFAULT cCodPrp2  := Space( 20 )
   DEFAULT cValPrp1  := Space( 40 )
   DEFAULT cValPrp2  := Space( 40 )

   do case
   case ::cEstado == "Precios de costo medio"
         nPreMed := ::oStock:nCostoMedio( cCodArt, , cCodPrp1, cCodPrp2, cValPrp1, cValPrp2 )
   case ::cEstado == "Último precio costo"
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