#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TRenFVta FROM TInfFam

   DATA  lCosAct        AS LOGIC    INIT .f.
   DATA  oTikCliT       AS OBJECT
   DATA  oTikCliL       AS OBJECT
   DATA  oAlbCliT       AS OBJECT
   DATA  oAlbCliL       AS OBJECT
   DATA  oFacCliT       AS OBJECT
   DATA  oFacCliL       AS OBJECT
   DATA  oFacRecT       AS OBJECT
   DATA  oFacRecL       AS OBJECT
   DATA  oDbfArt        AS OBJECT

   DATA  nTotVentas     AS NUMERIC   INIT 0
   DATA  nTotCosto      AS NUMERIC   INIT 0
   DATA  nTotAtipica    AS NUMERIC   INIT 0

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodFam", "C", 16, 0, {|| "@!" },           "Cod.",              .t., "Códogo familia",         5, .f. )
   ::AddField( "cNomFam", "C", 50, 0, {|| "@!" },           "Família",           .t., "Família",               35, .f. )
   ::AddField( "cCodArt", "C", 18, 0, {|| "@!" },           "Código artículo",         .f., "Codigo artículo",       14, .f. )
   ::AddField( "cNomArt", "C",100, 0, {|| "@!" },           "Descripción",       .f., "Descripción",           35, .f. )
   ::FldPropiedades()
   ::AddField( "nTotCaj", "N", 16, 6, {|| MasUnd() },       "Cajas",             .f., "Cajas",                 12, .t. )
   ::AddField( "nTotUni", "N", 16, 6, {|| MasUnd() },       "Unds.",             .t., "Unidades",              12, .t. )
   ::AddField( "nTotImp", "N", 16, 6, {|| ::cPicOut },      "Tot. importe",      .t., "Tot. importe",          12, .t. )
   ::AddField( "nTotPes", "N", 16, 6, {|| MasUnd() },       "Tot. peso",         .f., "Total peso",            12, .t. )
   ::AddField( "nPreKgr", "N", 16, 6, {|| ::cPicImp },      "Pre. Kg.",          .f., "Precio kilo",           12, .f. )
   ::AddField( "nTotVol", "N", 16, 6, {|| MasUnd() },       "Tot. volumen",      .f., "Total volumen",         12, .t. )
   ::AddField( "nPreVol", "N", 16, 6, {|| ::cPicImp },      "Pre. vol.",         .f., "Precio volumen",        12, .f. )
   ::AddField( "nTotCos", "N", 16, 6, {|| ::cPicOut },      "Tot. costo",        .t., "Total costo",           12, .t. )
   ::AddField( "nDtoAtp", "N", 16, 6, {|| ::cPicOut },      "Dto. Atipico",      .f., "Importe dto. atipico",  12, .t. )
   ::AddField( "nMarGen", "N", 16, 6, {|| ::cPicOut },      "Margen",            .t., "Margen",                12, .t. )
   ::AddField( "nRenTab", "N", 16, 6, {|| ::cPicOut },      "%Rent.",            .t., "Rentabilidad",          12, .f. )
   ::AddField( "nPreMed", "N", 16, 6, {|| ::cPicImp },      "Precio medio",      .f., "Precio medio",          12, .f. )
   ::AddField( "nCosMed", "N", 16, 6, {|| ::cPicOut },      "Costo medio",       .t., "Costo medio",           12, .f. )

   ::AddTmpIndex( "CCODFAM", "CCODFAM" )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TRenFVta

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "ALBCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   ::oFacCliT     := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oFacRecT PATH ( cPatEmp() ) FILE "FACRECT.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL PATH ( cPatEmp() ) FILE "FACRECL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) FILE "TIKET.DBF"    VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) FILE "TIKEL.DBF"    VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oDbfArt  PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TRenFVta

   if !Empty( ::oTikCliT ) .and. ::oTikCliT:Used()
      ::oTikCliT:End()
   end if
   if !Empty( ::oTikCliL ) .and. ::oTikCliL:Used()
      ::oTikCliL:End()
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
   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if
   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if
   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   ::oTikCliT := nil
   ::oTikCliL := nil
   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oFacRecT := nil
   ::oFacRecL := nil
   ::oAlbCliT := nil
   ::oAlbCliL := nil
   ::oDbfArt  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TRenFVta

   if !::StdResource( "INFGEN10D" )
      return .f.
   end if

   ::CreateFilter( , ::oDbf, .t. )

   /* Monta familias */

   if !::lDefFamInf( 70, 80, 90, 100, 600 )
      return .f.
   end if

   if !::oDefCliInf( 150, 151, 160, 161, , 170 )
      return .f.
   end if

   ::oDefExcInf( 210 )
   ::oDefExcImp( 211 )
   ::oDefResInf()

   REDEFINE CHECKBOX ::lCosAct ;
      ID       ( 205 );
      OF       ::oFld:aDialogs[1]

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local nTotUni
   local nTotImpUni
   local cExpHead := ""
   local cExpLine := ""
   local nImpDtoAtp

   ::nTotVentas   := 0
   ::nTotCosto    := 0
   ::nTotAtipica  := 0

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader   := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                     {|| "Periodo  : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Familia  : " + if( ::lAllFam, "Todas", AllTrim( ::cFamOrg ) + " > " + AllTrim( ::cFamDes ) ) },;
                     {|| "Clientes : " + if( ::lAllCli, "Todas", AllTrim( ::cCliOrg ) + " > " + AllTrim( ::cCliDes ) ) },;
                     {|| "Rnt med  : " + Alltrim( Trans( ( ( ( ( ::nTotVentas - ::nTotAtipica )  / ::nTotCosto ) - 1 ) * 100 ), ::cPicOut ) ) + "%" } }

   ::oAlbCliT:OrdSetFocus( "dFecAlb" )
   ::oAlbCliL:OrdSetFocus( "nNumAlb" )

   cExpHead          := 'nFacturado < 3 .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter ) 
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oAlbCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oAlbCliT:cFile ), ::oAlbCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText := "Procesando albaranes"
   ::oMtrInf:SetTotal( ::oAlbCliT:OrdKeyCount() )

   /*
   Lineas de albaranes
   */

   cExpLine          := '!lTotLin .and. !lControl .and. !lKitChl'

   if !::lAllFam
      cExpLine       += ' .and. cCodFam >= "' + Rtrim( ::cFamOrg ) + '" .and. cCodFam <= "' + Rtrim( ::cFamDes ) + '"'
   end if

   ::oAlbCliL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oAlbCliL:cFile ), ::oAlbCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oAlbCliT:GoTop()

    while !::lBreak .and. !::oAlbCliT:Eof()

      if lChkSer( ::oAlbCliT:cSerAlb, ::aSer )

         if ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

            while ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb == ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb

               if !( ::lExcCero .AND. nTotNAlbCli( ::oAlbCliL ) == 0 ) .AND.;
                  !( ::lExcImp .AND. nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut ) == 0 )

                  nTotUni              := nTotNAlbCli( ::oAlbCliL:cAlias )
                  nTotImpUni           := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )
                  nImpDtoAtp           := nDtoAtpAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )

                  if ::oDbf:Seek( ::oAlbCliL:cCodFam )

                     ::oDbf:Load()

                     ::oDbf:nTotCaj += ::oAlbCliL:nCanEnt
                     ::oDbf:nTotUni += nTotUni
                     ::oDbf:nTotPes += nTotUni * oRetFld( ::oAlbCliL:cRef, ::oDbfArt, "nPesoKg" )
                     ::oDbf:nTotImp += nTotImpUni
                     ::oDbf:nPreKgr := if( ::oDbf:nTotPes != 0, nTotImpUni / ::oDbf:nTotPes, 0 )
                     ::oDbf:nTotVol += nTotUni * oRetFld( ::oAlbCliL:cRef, ::oDbfArt, "nVolumen" )
                     ::oDbf:nPreVol := if( ::oDbf:nTotVol != 0, nTotImpUni / ::oDbf:nTotVol, 0 )

                     if ::lCosAct .or. ::oAlbCliL:nCosDiv == 0
                        ::oDbf:nTotCos += nRetPreCosto( ::oDbfArt:cAlias, ::oAlbCliL:cRef ) * nTotUni
                        ::nTotCosto    += nRetPreCosto( ::oDbfArt:cAlias, ::oAlbCliL:cRef ) * nTotUni
                     else
                        ::oDbf:nTotCos += ::oAlbCliL:nCosDiv * nTotUni
                        ::nTotCosto    += ::oAlbCliL:nCosDiv * nTotUni
                     end if

                     ::oDbf:nDtoAtp += nImpDtoAtp
                     ::oDbf:nMargen := ::oDbf:nTotImp - ::oDbf:nTotCos - ::oDbf:nDtoAtp


                     if ::oDbf:nTotUni != 0 .and. ::oDbf:nTotCos != 0
                        ::oDbf:nRentab := nRentabilidad( ::oDbf:nTotImp, ::oDbf:nDtoAtp, ::oDbf:nTotCos )
                        ::oDbf:nPreMed := ::oDbf:nTotImp / ::oDbf:nTotUni
                        ::oDbf:nCosMed := ::oDbf:nTotCos / ::oDbf:nTotUni
                     else
                        ::oDbf:nRentab := 0
                        ::oDbf:nPreMed := 0
                        ::oDbf:nCosMed := 0
                     end if

                     ::nTotVentas      += nTotImpUni
                     ::nTotAtipica     += nImpDtoAtp

                     ::oDbf:Save()

                  else

                     ::oDbf:Append()

                     ::oDbf:cCodArt := ::oAlbCliL:cRef
                     ::oDbf:cNomArt := ::oAlbCliL:cDetalle
                     ::oDbf:cCodPr1 := ::oAlbCliL:cCodPr1
                     ::oDbf:cNomPr1 := retProp( ::oAlbCliL:cCodPr1 )
                     ::oDbf:cCodPr2 := ::oAlbCliL:cCodPr2
                     ::oDbf:cNomPr2 := retProp( ::oAlbCliL:cCodPr2 )
                     ::oDbf:cValPr1 := ::oAlbCliL:cValPr1
                     ::oDbf:cNomVl1 := retValProp( ::oAlbCliL:cCodPr1 + ::oAlbCliL:cValPr1 )
                     ::oDbf:cValPr2 := ::oAlbCliL:cValPr2
                     ::oDbf:cNomVl2 := retValProp( ::oAlbCliL:cCodPr2 + ::oAlbCliL:cValPr2 )
                     ::oDbf:cCodFam := ::oAlbCliL:cCodFam
                     ::oDbf:cNomFam := oRetFld( ::oAlbCliL:cCodFam, ::oDbfFam )
                     ::oDbf:nTotCaj := ::oAlbCliL:nCanEnt
                     ::oDbf:nTotUni := nTotUni
                     ::oDbf:nTotPes := ::oDbf:nTotUni * oRetFld( ::oAlbCliL:cRef, ::oDbfArt, "nPesoKg" )
                     ::oDbf:nTotImp := nTotImpUni
                     ::oDbf:nPreKgr := if( ::oDbf:nTotPes != 0, ::oDbf:nTotImp / ::oDbf:nTotPes, 0 )
                     ::oDbf:nTotVol := ::oDbf:nTotUni * oRetFld( ::oAlbCliL:cRef, ::oDbfArt, "nVolumen" )
                     ::oDbf:nPreVol := if( ::oDbf:nTotVol != 0, ::oDbf:nTotImp / ::oDbf:nTotVol, 0 )

                     if ::lCosAct .or. ::oAlbCliL:nCosDiv == 0
                        ::oDbf:nTotCos := nRetPreCosto( ::oDbfArt:cAlias, ::oAlbCliL:cRef ) * nTotUni
                     else
                        ::oDbf:nTotCos := ::oAlbCliL:nCosDiv * nTotUni
                     end if

                     ::oDbf:nDtoAtp := nImpDtoAtp
                     ::oDbf:nMargen := ::oDbf:nTotImp - ::oDbf:nTotCos - ::oDbf:nDtoAtp

                     if ::oDbf:nTotUni != 0 .and. ::oDbf:nTotCos != 0
                        ::oDbf:nRentab := nRentabilidad( ::oDbf:nTotImp, ::oDbf:nDtoAtp, ::oDbf:nTotCos )
                        ::oDbf:nPreMed := ::oDbf:nTotImp / ::oDbf:nTotUni
                        ::oDbf:nCosMed := ::oDbf:nTotCos / ::oDbf:nTotUni
                     else
                        ::oDbf:nRentab := 0
                        ::oDbf:nPreMed := 0
                        ::oDbf:nCosMed := 0
                     end if

                     ::nTotVentas            += ::oDbf:nTotImp
                     ::nTotCosto             += ::oDbf:nTotCos
                     ::nTotAtipica           += nImpDtoAtp

                     ::oDbf:Save()

                  end if

               end if

               ::oAlbCliL:Skip()

            end while

         end if

      end if

      ::oAlbCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oAlbCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oAlbCliT:cFile ) )

   ::oAlbCliL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oAlbCliL:cFile ) )

   ::oFacCliT:OrdSetFocus( "dFecFac" )
   ::oFacCliL:OrdSetFocus( "nNumFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText := "Procesando facturas"
   ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )

   /*
   Lineas de albaranes
   */

   cExpLine          := '!lTotLin .and. !lControl .and. !lKitChl'

   if !::lAllFam
      cExpLine       += ' .and. cCodFam >= "' + Rtrim( ::cFamOrg ) + '" .and. cCodFam <= "' + Rtrim( ::cFamDes ) + '"'
   end if

   ::oFacCliL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacCliL:cFile ), ::oFacCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacCliT:GoTop()

   while !::lBreak .and. !::lBreak .and. !::oFacCliT:Eof()

      if lChkSer( ::oFacCliT:cSerie, ::aSer )

         if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

            while ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac == ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac

               if !( ::lExcCero .AND. nTotNFacCli( ::oFacCliL ) == 0 ) .AND.;
                  !( ::lExcImp .AND. nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut ) == 0 )

                  nTotUni     := nTotNFacCli( ::oFacCliL:cAlias )
                  nTotImpUni  := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )
                  nImpDtoAtp  := nDtoAtpFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )

                  if ::oDbf:Seek( ::oFacCliL:cCodFam )

                     ::oDbf:Load()

                     ::oDbf:nTotCaj += ::oFacCliL:nCanEnt
                     ::oDbf:nTotUni += nTotUni
                     ::oDbf:nTotPes += nTotUni * oRetFld( ::oFacCliL:cRef, ::oDbfArt, "nPesoKg" )
                     ::oDbf:nTotImp += nTotImpUni
                     ::oDbf:nPreKgr := if( ::oDbf:nTotPes != 0, nTotImpUni / ::oDbf:nTotPes, 0 )
                     ::oDbf:nTotVol += nTotUni * oRetFld( ::oFacCliL:cRef, ::oDbfArt, "nVolumen" )
                     ::oDbf:nPreVol := if( ::oDbf:nTotVol != 0, nTotImpUni / ::oDbf:nTotVol, 0 )

                     if ::lCosAct .or. ::oFacCliL:nCosDiv == 0
                        ::oDbf:nTotCos += nRetPreCosto( ::oDbfArt:cAlias, ::oFacCliL:cRef ) * nTotUni
                        ::nTotCosto    += nRetPreCosto( ::oDbfArt:cAlias, ::oFacCliL:cRef ) * nTotUni
                     else
                        ::oDbf:nTotCos += ::oFacCliL:nCosDiv * nTotUni
                        ::nTotCosto    += ::oFacCliL:nCosDiv * nTotUni
                     end if

                     ::oDbf:nDtoAtp += nImpDtoAtp
                     ::oDbf:nMargen := ::oDbf:nTotImp - ::oDbf:nTotCos - ::oDbf:nDtoAtp

                     if ::oDbf:nTotUni != 0 .and. ::oDbf:nTotCos != 0
                        ::oDbf:nRentab := nRentabilidad( ::oDbf:nTotImp, ::oDbf:nDtoAtp, ::oDbf:nTotCos )
                        ::oDbf:nPreMed := ::oDbf:nTotImp / ::oDbf:nTotUni
                        ::oDbf:nCosMed := ::oDbf:nTotCos / ::oDbf:nTotUni
                     else
                        ::oDbf:nRentab := 0
                        ::oDbf:nPreMed := 0
                        ::oDbf:nCosMed := 0
                     end if

                     ::nTotVentas            += nTotImpUni
                     ::nTotAtipica           += nImpDtoAtp

                     ::oDbf:Save()

                  else

                     ::oDbf:Append()

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
                     ::oDbf:cCodFam := ::oFacCliL:cCodFam
                     ::oDbf:cNomFam := oRetFld( ::oFacCliL:cCodFam, ::oDbfFam )
                     ::oDbf:nTotCaj := ::oFacCliL:nCanEnt
                     ::oDbf:nTotUni := nTotUni
                     ::oDbf:nTotPes := ::oDbf:nTotUni * oRetFld( ::oFacCliL:cRef, ::oDbfArt, "nPesoKg" )
                     ::oDbf:nTotImp := nTotImpUni
                     ::oDbf:nPreKgr := if( ::oDbf:nTotPes != 0, ::oDbf:nTotImp / ::oDbf:nTotPes, 0 )
                     ::oDbf:nTotVol := ::oDbf:nTotUni * oRetFld( ::oFacCliL:cRef, ::oDbfArt, "nVolumen" )
                     ::oDbf:nPreVol := if( ::oDbf:nTotVol != 0, ::oDbf:nTotImp / ::oDbf:nTotVol, 0 )

                     if ::lCosAct .or. ::oFacCliL:nCosDiv == 0
                        ::oDbf:nTotCos := nRetPreCosto( ::oDbfArt:cAlias, ::oFacCliL:cRef ) * nTotUni
                     else
                        ::oDbf:nTotCos := ::oFacCliL:nCosDiv * nTotUni
                     end if

                     ::oDbf:nDtoAtp := nImpDtoAtp
                     ::oDbf:nMargen := ::oDbf:nTotImp - ::oDbf:nTotCos - ::oDbf:nDtoAtp

                     if ::oDbf:nTotUni != 0 .and. ::oDbf:nTotCos != 0
                        ::oDbf:nRentab := nRentabilidad( ::oDbf:nTotImp, ::oDbf:nDtoAtp, ::oDbf:nTotCos )
                        ::oDbf:nPreMed := ::oDbf:nTotImp / ::oDbf:nTotUni
                        ::oDbf:nCosMed := ::oDbf:nTotCos / ::oDbf:nTotUni
                     else
                        ::oDbf:nRentab := 0
                        ::oDbf:nPreMed := 0
                        ::oDbf:nCosMed := 0
                     end if

                     ::nTotVentas            += ::oDbf:nTotImp
                     ::nTotCosto             += ::oDbf:nTotCos
                     ::nTotAtipica           += nImpDtoAtp

                     ::oDbf:Save()

                  end if

               end if

               ::oFacCliL:Skip()

            end while

         end if

      end if

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oFacCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacCliT:cFile ) )
   ::oFacCliL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacCliL:cFile ) )

   ::oFacRecT:OrdSetFocus( "dFecFac" )
   ::oFacRecL:OrdSetFocus( "nNumFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter 
   end if

   ::oFacRecT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText := "Procesando fac. rec."
   ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )

   /*
   Lineas de albaranes
   */

   cExpLine          := '!lTotLin .and. !lControl .and. !lKitChl'

   if !::lAllFam
      cExpLine       += ' .and. cCodFam >= "' + Rtrim( ::cFamOrg ) + '" .and. cCodFam <= "' + Rtrim( ::cFamDes ) + '"'
   end if

   ::oFacRecL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacRecL:cFile ), ::oFacRecL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacRecT:GoTop()

   while !::lBreak .and. !::oFacRecT:Eof()

      if lChkSer( ::oFacRecT:cSerie, ::aSer )

         if ::oFacRecL:Seek( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac )

            while ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac == ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac

               if !( ::lExcCero .AND. nTotNFacRec( ::oFacRecL ) == 0 ) .AND.;
                  !( ::lExcImp .AND. nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut ) == 0 )

                  nTotUni     := nTotNFacRec( ::oFacRecL:cAlias )
                  nTotImpUni  := nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut )

                  if ::oDbf:Seek( ::oFacRecL:cCodFam )

                     ::oDbf:Load()

                     ::oDbf:nTotCaj += ::oFacRecL:nCanEnt
                     ::oDbf:nTotUni += nTotUni
                     ::oDbf:nTotPes += nTotUni * oRetFld( ::oFacRecL:cRef, ::oDbfArt, "nPesoKg" )
                     ::oDbf:nTotImp += nTotImpUni
                     ::oDbf:nPreKgr := if( ::oDbf:nTotPes != 0, nTotImpUni / ::oDbf:nTotPes, 0 )
                     ::oDbf:nTotVol += nTotUni * oRetFld( ::oFacRecL:cRef, ::oDbfArt, "nVolumen" )
                     ::oDbf:nPreVol := if( ::oDbf:nTotVol != 0, nTotImpUni / ::oDbf:nTotVol, 0 )

                     if ::lCosAct .or. ::oFacRecL:nCosDiv == 0
                        ::oDbf:nTotCos += nRetPreCosto( ::oDbfArt:cAlias, ::oFacRecL:cRef ) * nTotUni
                        ::nTotCosto    += nRetPreCosto( ::oDbfArt:cAlias, ::oFacRecL:cRef ) * nTotUni
                     else
                        ::oDbf:nTotCos += ::oFacRecL:nCosDiv * nTotUni
                        ::nTotCosto    += ::oFacRecL:nCosDiv * nTotUni
                     end if

                     ::oDbf:nDtoAtp += 0
                     ::oDbf:nMargen := ::oDbf:nTotImp - ::oDbf:nTotCos - ::oDbf:nDtoAtp

                     if ::oDbf:nTotUni != 0 .and. ::oDbf:nTotCos != 0
                        ::oDbf:nRentab := nRentabilidad( ::oDbf:nTotImp, 0, ::oDbf:nTotCos )
                        ::oDbf:nPreMed := ::oDbf:nTotImp / ::oDbf:nTotUni
                        ::oDbf:nCosMed := ::oDbf:nTotCos / ::oDbf:nTotUni
                     else
                        ::oDbf:nRentab := 0
                        ::oDbf:nPreMed := 0
                        ::oDbf:nCosMed := 0
                     end if

                     ::nTotVentas      += nTotImpUni
                     ::nTotAtipica     += 0


                     ::oDbf:Save()

                  else

                     ::oDbf:Append()

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
                     ::oDbf:cCodFam := ::oFacRecL:cCodFam
                     ::oDbf:cNomFam := oRetFld( ::oFacRecL:cCodFam, ::oDbfFam )
                     ::oDbf:nTotCaj := ::oFacRecL:nCanEnt
                     ::oDbf:nTotUni := nTotUni
                     ::oDbf:nTotPes := ::oDbf:nTotUni * oRetFld( ::oFacRecL:cRef, ::oDbfArt, "nPesoKg" )
                     ::oDbf:nTotImp := nTotImpUni
                     ::oDbf:nPreKgr := if( ::oDbf:nTotPes != 0, ::oDbf:nTotImp / ::oDbf:nTotPes, 0 )
                     ::oDbf:nTotVol := ::oDbf:nTotUni * oRetFld( ::oFacRecL:cRef, ::oDbfArt, "nVolumen" )
                     ::oDbf:nPreVol := if( ::oDbf:nTotVol != 0, ::oDbf:nTotImp / ::oDbf:nTotVol, 0 )

                     if ::lCosAct .or. ::oFacRecL:nCosDiv == 0
                        ::oDbf:nTotCos := nRetPreCosto( ::oDbfArt:cAlias, ::oFacRecL:cRef ) * nTotUni
                     else
                        ::oDbf:nTotCos := ::oFacRecL:nCosDiv * nTotUni
                     end if

                     ::oDbf:nDtoAtp := 0
                     ::oDbf:nMargen := ::oDbf:nTotImp - ::oDbf:nTotCos - ::oDbf:nDtoAtp

                     if ::oDbf:nTotUni != 0 .and. ::oDbf:nTotCos != 0
                        ::oDbf:nRentab := nRentabilidad( ::oDbf:nTotImp, 0, ::oDbf:nTotCos )
                        ::oDbf:nPreMed := ::oDbf:nTotImp / ::oDbf:nTotUni
                        ::oDbf:nCosMed := ::oDbf:nTotCos / ::oDbf:nTotUni
                     else
                        ::oDbf:nRentab := 0
                        ::oDbf:nPreMed := 0
                        ::oDbf:nCosMed := 0
                     end if

                     ::nTotVentas            += ::oDbf:nTotImp
                     ::nTotCosto             += ::oDbf:nTotCos
                     ::nTotAtipica           += 0

                     ::oDbf:Save()

                  end if

               end if

               ::oFacRecL:Skip()

            end while

         end if

      end if

      ::oFacRecT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oFacRecT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacRecT:cFile ) )
   ::oFacRecL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacRecL:cFile ) )

   ::oTikCliT:OrdSetFocus( "dFecTik" )
   ::oTikCliL:OrdSetFocus( "cNumTil" )

   cExpHead          := 'dFecTik >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecTik <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   cExpHead          += ' .and. ( cTipTik == "1" .or. cTipTik == "4" )'

   if !::lAllCli
      cExpHead       += ' .and. cCliTik >= "' + Rtrim( ::cCliOrg ) + '" .and. cCliTik <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter 
   end if

   ::oTikCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oTikCliT:cFile ), ::oTikCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText := "Procesando tikets"
   ::oMtrInf:SetTotal( ::oTikCliT:OrdKeyCount() )

   /*
   Lineas de tikets
   */

   cExpLine          := '!lControl .and. !lKitChl'

   if !::lAllFam
      cExpLine       += ' .and. cCodFam >= "' + Rtrim( ::cFamOrg ) + '" .and. cCodFam <= "' + Rtrim( ::cFamDes ) + '"'
   end if

   ::oTikCliL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oTikCliL:cFile ), ::oTikCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oTikCliT:GoTop()

   while !::lBreak .and. !::oTikCliT:Eof()

      if lChkSer( ::oTikCliT:cSerTik, ::aSer )

         if ::oTikCliL:Seek( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik )

            while ::oTikCliL:cSerTiL + ::oTikCliL:cNumTiL + ::oTikCliL:cSufTiL == ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik

                if !Empty( ::oTikCliL:cCbaTil )                         .AND.;
                  !( ::lExcCero .AND. ::oTikCliL:nUntTil == 0 )         .AND.;
                  !( ::lExcImp .AND. ::oTikCliL:nPvpTil == 0 )

                  nTotUni           := ::oTikCliL:nUntTil
                  nTotImpUni        := nImpLTpv( ::oTikCliT, ::oTikCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, nil, 1 )

                  if ::oDbf:Seek( ::oTikCliL:cCodFam )

                     ::oDbf:Load()

                     ::oDbf:nTotUni    += nTotUni
                     ::oDbf:nTotPes    += nTotUni * oRetFld( ::oTikCliL:cCbaTil, ::oDbfArt, "nPesoKg" )
                     ::oDbf:nTotImp    += nTotImpUni
                     ::oDbf:nPreKgr    := if( ::oDbf:nTotPes != 0, nTotImpUni / ::oDbf:nTotPes, 0 )
                     ::oDbf:nTotVol    += nTotUni / oRetFld( ::oTikCliL:cCbaTil, ::oDbfArt, "nVolumen" )
                     ::oDbf:nPreVol    := if( ::oDbf:nTotVol != 0, nTotImpUni / ::oDbf:nTotVol, 0 )

                     if ::oTikCliL:nCosDiv != 0
                        ::oDbf:nTotCos += ::oTikCliL:nCosDiv * nTotUni
                        ::nTotCosto    += ::oTikCliL:nCosDiv * nTotUni
                     else
                        ::oDbf:nTotCos += nRetPreCosto( ::oDbfArt:cAlias, ::oTikCliL:cCbaTil ) * nTotUni
                        ::nTotCosto    += nRetPreCosto( ::oDbfArt:cAlias, ::oTikCliL:cCbaTil ) * nTotUni
                     end if

                     ::oDbf:nDtoAtp    += 0
                     ::oDbf:nMargen    := ::oDbf:nTotImp - ::oDbf:nTotCos - ::oDbf:nDtoAtp

                     if ::oDbf:nTotUni != 0 .and. ::oDbf:nTotCos != 0
                        ::oDbf:nRentab := nRentabilidad( ::oDbf:nTotImp, 0, ::oDbf:nTotCos )
                        ::oDbf:nPreMed := ::oDbf:nTotImp / ::oDbf:nTotUni
                        ::oDbf:nCosMed := ::oDbf:nTotCos / ::oDbf:nTotUni
                     else
                        ::oDbf:nRentab := 0
                        ::oDbf:nPreMed := 0
                        ::oDbf:nCosMed := 0
                     end if

                     ::nTotVentas            += nTotImpUni
                     ::nTotAtipica           += 0

                     ::oDbf:Save()

                  else

                     ::oDbf:Append()

                     ::oDbf:cCodArt    := ::oTikCliL:cCbaTil
                     ::oDbf:cCodFam    := ::oTikCliL:cCodFam
                     ::oDbf:cNomFam    := oRetFld( ::oTikCliL:cCodFam, ::oDbfFam )
                     ::oDbf:cNomArt    := RetArticulo( ::oTikCliL:cCbaTil, ::oDbfArt )
                     ::oDbf:cCodPr1    := ::oTikCliL:cCodPr1
                     ::oDbf:cNomPr1    := retProp( ::oTikCliL:cCodPr1 )
                     ::oDbf:cCodPr2    := ::oTikCliL:cCodPr2
                     ::oDbf:cNomPr2    := retProp( ::oTikCliL:cCodPr2 )
                     ::oDbf:cValPr1    := ::oTikCliL:cValPr1
                     ::oDbf:cNomVl1    := retValProp( ::oTikCliL:cCodPr1 + ::oTikCliL:cValPr1 )
                     ::oDbf:cValPr2    := ::oTikCliL:cValPr2
                     ::oDbf:cNomVl2    := retValProp( ::oTikCliL:cCodPr2 + ::oTikCliL:cValPr2 )
                     ::oDbf:nTotUni    := nTotUni
                     ::oDbf:nTotPes    := ::oDbf:nTotUni * oRetFld( ::oTikCliL:cCbaTil, ::oDbfArt, "nPesoKg" )
                     ::oDbf:nTotImp    := nTotImpUni
                     ::oDbf:nPreKgr    := if( ::oDbf:nTotPes != 0, ::oDbf:nTotImp / ::oDbf:nTotPes, 0 )
                     ::oDbf:nTotVol    := ::oDbf:nTotUni / oRetFld( ::oTikCliL:cCbaTil, ::oDbfArt, "nVolumen" )
                     ::oDbf:nPreVol    := if( ::oDbf:nTotVol != 0, ::oDbf:nTotImp / ::oDbf:nTotVol, 0 )

                     if ::oTikCliL:nCosDiv != 0
                        ::oDbf:nTotCos := ::oTikCliL:nCosDiv * nTotUni
                     else
                        ::oDbf:nTotCos := nRetPreCosto( ::oDbfArt:cAlias, ::oTikCliL:cCbaTil ) * nTotUni
                     end if

                     ::oDbf:nDtoAtp    := 0
                     ::oDbf:nMargen    := ::oDbf:nTotImp - ::oDbf:nTotCos - ::oDbf:nDtoAtp

                     if ::oDbf:nTotUni != 0 .and. ::oDbf:nTotCos != 0
                        ::oDbf:nRentab :=  nRentabilidad( ::oDbf:nTotImp, 0, ::oDbf:nTotCos )
                        ::oDbf:nPreMed := ::oDbf:nTotImp / ::oDbf:nTotUni
                        ::oDbf:nCosMed := ::oDbf:nTotCos / ::oDbf:nTotUni
                     else
                        ::oDbf:nRentab := 0
                        ::oDbf:nPreMed := 0
                        ::oDbf:nCosMed := 0
                     end if

                     ::nTotVentas            += ::oDbf:nTotImp
                     ::nTotCosto             += ::oDbf:nTotCos
                     ::nTotAtipica           += 0

                     ::oDbf:Save()

                  end if

               end if

               if !Empty( ::oTikCliL:cComTil )                          .AND.;
                  !( ::lExcCero .AND. ::oTikCliL:nUntTil == 0 )         .AND.;
                  !( ::lExcImp .AND. ::oTikCliL:nPcmTil == 0 )

                  nTotUni           := ::oTikCliL:nUntTil
                  nTotImpUni        := nImpLTpv( ::oTikCliT, ::oTikCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, nil, 2 )

                  if ::oDbf:Seek( ::oTikCliL:cCodFam )

                     ::oDbf:Load()

                     ::oDbf:nTotUni    += nTotUni
                     ::oDbf:nTotPes    += nTotUni * oRetFld( ::oTikCliL:cComTil, ::oDbfArt, "nPesoKg" )
                     ::oDbf:nTotImp    += nTotImpUni
                     ::oDbf:nPreKgr    := if( ::oDbf:nTotPes != 0, nTotImpUni / ::oDbf:nTotPes, 0 )
                     ::oDbf:nTotVol    += nTotUni / oRetFld( ::oTikCliL:cComTil, ::oDbfArt, "nVolumen" )
                     ::oDbf:nPreVol    := if( ::oDbf:nTotVol != 0, nTotImpUni / ::oDbf:nTotVol, 0 )

                     if ::oTikCliL:nCosDiv != 0
                        ::oDbf:nTotCos += ::oTikCliL:nCosDiv * nTotUni
                        ::nTotCosto    += ::oTikCliL:nCosDiv * nTotUni
                     else
                        ::oDbf:nTotCos += nRetPreCosto( ::oDbfArt:cAlias, ::oTikCliL:cComTil ) * nTotUni
                        ::nTotCosto    += nRetPreCosto( ::oDbfArt:cAlias, ::oTikCliL:cComTil ) * nTotUni
                     end if

                     ::oDbf:nDtoAtp    += 0
                     ::oDbf:nMargen    := ::oDbf:nTotImp - ::oDbf:nTotCos - ::oDbf:nDtoAtp

                     if ::oDbf:nTotUni != 0 .and. ::oDbf:nTotCos != 0
                        ::oDbf:nRentab := nRentabilidad( ::oDbf:nTotImp, 0, ::oDbf:nTotCos )
                        ::oDbf:nPreMed := ::oDbf:nTotImp / ::oDbf:nTotUni
                        ::oDbf:nCosMed := ::oDbf:nTotCos / ::oDbf:nTotUni
                     else
                        ::oDbf:nRentab := 0
                        ::oDbf:nPreMed := 0
                        ::oDbf:nCosMed := 0
                     end if

                     ::nTotVentas      += nTotImpUni
                     ::nTotAtipica     += 0

                     ::oDbf:Save()

                  else

                     ::oDbf:Append()

                     ::oDbf:cCodArt    := ::oTikCliL:cComTil
                     ::oDbf:cCodFam    := ::oTikCliL:cCodFam
                     ::oDbf:cNomFam    := oRetFld( ::oTikCliL:cCodFam, ::oDbfFam )
                     ::oDbf:cNomArt    := RetArticulo( ::oTikCliL:cComTil, ::oDbfArt )
                     ::oDbf:cCodPr1    := ::oTikCliL:cCodPr1
                     ::oDbf:cNomPr1    := retProp( ::oTikCliL:cCodPr1 )
                     ::oDbf:cCodPr2    := ::oTikCliL:cCodPr2
                     ::oDbf:cNomPr2    := retProp( ::oTikCliL:cCodPr2 )
                     ::oDbf:cValPr1    := ::oTikCliL:cValPr1
                     ::oDbf:cNomVl1    := retValProp( ::oTikCliL:cCodPr1 + ::oTikCliL:cValPr1 )
                     ::oDbf:cValPr2    := ::oTikCliL:cValPr2
                     ::oDbf:cNomVl2    := retValProp( ::oTikCliL:cCodPr2 + ::oTikCliL:cValPr2 )
                     ::oDbf:nTotUni    := nTotUni
                     ::oDbf:nTotPes    := ::oDbf:nTotUni * oRetFld( ::oTikCliL:cComTil, ::oDbfArt, "nPesoKg" )
                     ::oDbf:nTotImp    := nTotImpUni
                     ::oDbf:nPreKgr    := if( ::oDbf:nTotPes != 0, ::oDbf:nTotImp / ::oDbf:nTotPes, 0 )
                     ::oDbf:nTotVol    := ::oDbf:nTotUni / oRetFld( ::oTikCliL:cComTil, ::oDbfArt, "nVolumen" )
                     ::oDbf:nPreVol    := if( ::oDbf:nTotVol != 0, ::oDbf:nTotImp / ::oDbf:nTotVol, 0 )

                     if ::oTikCliL:nCosDiv != 0
                        ::oDbf:nTotCos := ::oTikCliL:nCosDiv * nTotUni
                     else
                        ::oDbf:nTotCos := nRetPreCosto( ::oDbfArt:cAlias, ::oTikCliL:cComTil ) * nTotUni
                     end if

                     ::oDbf:nDtoAtp    := 0
                     ::oDbf:nMargen    := ::oDbf:nTotImp - ::oDbf:nTotCos - ::oDbf:nDtoAtp

                     if ::oDbf:nTotUni != 0 .and. ::oDbf:nTotCos != 0
                        ::oDbf:nRentab := nRentabilidad( ::oDbf:nTotImp, 0, ::oDbf:nTotCos )
                        ::oDbf:nPreMed := ::oDbf:nTotImp / ::oDbf:nTotUni
                        ::oDbf:nCosMed := ::oDbf:nTotCos / ::oDbf:nTotUni
                     else
                        ::oDbf:nRentab := 0
                        ::oDbf:nPreMed := 0
                        ::oDbf:nCosMed := 0
                     end if

                     ::nTotVentas             += ::oDbf:nTotImp
                     ::nTotCosto              += ::oDbf:nTotCos
                     ::nTotAtipica            += 0

                     ::oDbf:Save()

                  end if

               end if

               ::oTikCliL:Skip()

            end while

         end if

      end if

      ::oTikCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oTikCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oTikCliT:cFile ) )
   ::oTikCliL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oTikCliL:cFile ) )

   ::oMtrInf:AutoInc( ::oTikCliT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//