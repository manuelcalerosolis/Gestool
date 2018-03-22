#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TRnkRVta FROM TInfGen

   DATA  oDbfIva     AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT
   DATA  oLimit      AS OBJECT
   DATA  nLimit      AS NUMERIC   INIT 0
   DATA  lAllPrc     AS LOGIC    INIT .t.

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodArt", "C", 18, 0, {|| "@!"          },"Código",                    .t., "Código artículo",            9, .f. )
   ::AddField( "cNomArt", "C",100, 0, {|| "@!"          },"Artículo",                  .t., "Nombre artículo",           35, .f. )
   ::AddField( "nTotUni", "N", 16, 3, {|| MasUnd()      },"Tot. " + cNombreUnidades(), .t., "Total " + cNombreunidades(),10, .t. )
   ::AddField( "nTotNet", "N", 16, 6, {|| ::cPicOut     },"Neto",                      .t., "Neto",                      10, .t. )
   ::AddField( "nTotIva", "N", 16, 6, {|| ::cPicOut     },cImp(),                       .t., cImp(),                       10, .t. )
   ::AddField( "nTotDoc", "N", 16, 6, {|| ::cPicOut     },"Total",                     .t., "Total",                     10, .t. )
   ::AddField( "nTotCos", "N", 16, 6, {|| ::cPicOut     },"Tot. costo",                .f., "Total costo",               12, .f. )
   ::AddField( "nMarGen", "N", 16, 6, {|| ::cPicOut     },"Margen",                    .f., "Margen",                    12, .f. )
   ::AddField( "nDtoAtp", "N", 16, 6, {|| ::cPicOut     },"Dto. Atipico",              .f., "Importe dto. atipico",      12, .t. )
   ::AddField( "nRenTab", "N", 16, 6, {|| ::cPicOut     },"%Rent.",                    .f., "Rentabilidad",              12, .f. )
   ::AddField( "nPreMed", "N", 16, 6, {|| ::cPicImp     },"Precio medio",              .f., "Precio medio",              12, .f. )
   ::AddField( "nCosMed", "N", 16, 6, {|| ::cPicOut     },"Costo medio",               .f., "Costo medio",               12, .f. )

   ::AddTmpIndex( "CCODART", "CCODART", , , , .t. )
   ::AddTmpIndex( "NTOTDOC", "NTOTDOC", , , , .t. )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TRnkRVta

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL  PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL  PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oFacRecT  PATH ( cPatEmp() ) FILE "FACRECT.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL  PATH ( cPatEmp() ) FILE "FACRECL.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   DATABASE NEW ::oTikCliT  PATH ( cPatEmp() ) FILE "TIKET.DBF"   VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL  PATH ( cPatEmp() ) FILE "TIKEL.DBF"   VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oDbfIva   PATH ( cPatDat() ) FILE "TIVA.DBF"    VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   ::bForReport      := {|| ::lAllPrc .or. ::oDbf:nTotNet >= ::nLimit }

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TRnkRVta

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
   if !Empty( ::oTikCliT ) .and. ::oTikCliT:Used()
      ::oTikCliT:End()
   end if
   if !Empty( ::oTikCliL ) .and. ::oTikCliL:Used()
      ::oTikCliL:End()
   end if
   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if

   ::oAlbCliT := nil
   ::oAlbCliL := nil
   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oFacRecT := nil
   ::oFacRecL := nil
   ::oTikCliT := nil
   ::oTikCliL := nil
   ::oDbfIva  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TRnkRVta

   if !::StdResource( "RNKVTAART" )
      return .f.
   end if

   ::CreateFilter( , ::oDbf, .t. )

   if !::lDefArtInf( 110, 120, 130, 140, 800 )
      return .f.
   end if

   ::oDefExcInf( 210 )

   ::oDefExcImp( 211 )

   REDEFINE CHECKBOX ::lAllPrc ;
      ID       160 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET ::oLimit VAR ::nLimit ;
		COLOR 	CLR_GET ;
      PICTURE  PicOut() ;
      WHEN     !::lAllPrc ;
      ID       150 ;
      OF       ::oFld:aDialogs[1]

   ::oMtrInf:SetTotal( ::oAlbCliT:Lastrec() )

RETURN .t.

//---------------------------------------------------------------------------//

METHOD lGenerate() CLASS TRnkRVta

   local cExpHead    := ""
   local cExpLine    := ""
   local nTotUni     := 0
   local nTotImp     := 0
   local nDtoAtp     := 0

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::oDbf:OrdSetFocus( "CCODART" )

   ::aHeader   :={ {|| "Fecha     : "  + Dtoc( Date() ) },;
                   {|| "Artículos : "  + if( ::lAllArt, "Todos", AllTrim( ::cArtOrg )+ " > " + AllTrim( ::cArtDes ) ) },;
                   {|| "Importe   : "  + if( ::lAllPrc, "Todos los importes", "Mayor de : " + AllTrim( Str( ::nLimit ) ) ) } }

   /*Procesamos los albaranes no facturados*/

   ::oAlbCliT:OrdSetFocus( "dFecAlb" )
   ::oAlbCliL:OrdSetFocus( "nNumAlb" )

   cExpHead          := 'nFacturado < 3 .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !Empty( ::oFilter:cExpresionFilter ) 
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oAlbCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oAlbCliT:cFile ), ::oAlbCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Procesando albaranes"
   ::oMtrInf:SetTotal( ::oAlbCliT:OrdKeyCount() )

   cExpLine          := '!lTotLin .and. !lControl'

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oAlbCliL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oAlbCliL:cFile ), ::oAlbCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oAlbCliT:GoTop()

   while !::lBreak .and. !::oAlbCliT:Eof()

      if lChkSer( ::oAlbCliT:cSerAlb, ::aSer )     .and.;
         ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

         while ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb == ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb .and.;
               !::oAlbCliL:Eof()

               if !( ::lExcCero .AND. nTotNAlbCli( ::oAlbCliL ) == 0 )        .AND.;
                  !( ::lExcImp .AND. nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                  nTotUni              := nTotNAlbCli( ::oAlbCliL )
                  nTotImp              := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  nDtoAtp              := nDtoAtpAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )

                  if !::oDbf:Seek( ::oAlbCliL:cRef )

                     ::oDbf:Append()

                     ::oDbf:cCodArt    := ::oAlbCliL:cRef
                     ::oDbf:cNomArt    := ::oAlbCliL:cDetalle
                     ::oDbf:nTotUni    := nTotUni
                     ::oDbf:nTotNet    := nTotImp
                     ::oDbf:nTotIva    := nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nTotDoc    := ::oDbf:nTotNet + ::oDbf:nTotIva

                     if ::oAlbCliL:nCosDiv == 0
                        ::oDbf:nTotCos := nRetPreCosto( ::oDbfArt:cAlias, ::oAlbCliL:cRef ) * nTotUni
                     else
                        ::oDbf:nTotCos := ::oAlbCliL:nCosDiv * nTotUni
                     end if

                     ::oDbf:nDtoAtp    := nDtoAtp
                     ::oDbf:nMargen    := nTotImp - ::oDbf:nTotCos - ::oDbf:nDtoAtp
                     if nTotUni != 0
                        ::oDbf:nRentab := nRentabilidad( nTotImp, ::oDbf:nDtoAtp, ::oDbf:nTotCos )
                        ::oDbf:nPreMed := nTotImp / nTotUni
                        ::oDbf:nCosMed := ::oDbf:nTotCos / nTotUni
                     else
                        ::oDbf:nRentab := 0
                        ::oDbf:nPreMed := 0
                        ::oDbf:nCosMed := 0
                     end if

                     ::oDbf:Save()

                  else

                     ::oDbf:Load()

                     ::oDbf:nTotUni    += nTotUni
                     ::oDbf:nTotNet    += nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nTotIva    += nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nTotDoc    += nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nTotDoc    += nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     if ::oAlbCliL:nCosDiv == 0
                        ::oDbf:nTotCos += nRetPreCosto( ::oDbfArt:cAlias, ::oAlbCliL:cRef ) * nTotUni
                     else
                        ::oDbf:nTotCos += ::oAlbCliL:nCosDiv * nTotUni
                     end if
                     ::oDbf:nDtoAtp    += nDtoAtp
                     ::oDbf:nMargen    := ::oDbf:nTotNet - ::oDbf:nTotCos - ::oDbf:nDtoAtp
                     if nTotUni != 0
                        ::oDbf:nRentab := nRentabilidad( ::oDbf:nTotNet, ::oDbf:nDtoAtp, ::oDbf:nTotCos )
                        ::oDbf:nPreMed := ::oDbf:nTotNet / ::oDbf:nTotUni
                        ::oDbf:nCosMed := ::oDbf:nTotCos / ::oDbf:nTotUni
                     else
                        ::oDbf:nRentab := 0
                        ::oDbf:nPreMed := 0
                        ::oDbf:nCosMed := 0
                     end if

                     ::oDbf:Save()

                  end if

               end if

         ::oAlbCliL:Skip()

         end while

      end if

   ::oAlbCliT:Skip()

   ::oMtrInf:AutoInc()

   end while

   ::oAlbCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oAlbCliT:cFile ) )

   ::oAlbCliL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oAlbCliL:cFile ) )

   /*Procesamos las facturas*/

   ::oFacCliT:OrdSetFocus( "dFecFac" )
   ::oFacCliL:OrdSetFocus( "nNumFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )
   ::oMtrInf:cText   := "Procesando factura"

   cExpLine          := '!lTotLin .and. !lControl'

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oFacCliL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacCliL:cFile ), ::oFacCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacCliT:GoTop()

   while !::lBreak .and. !::oFacCliT:Eof()

      if lChkSer( ::oFacCliT:cSerie, ::aSer )     .and.;
         ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

         while ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac == ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac .and.;
               !::oFacCliL:Eof()

               if !( ::lExcCero .AND. nTotNFacCli( ::oFacCliL ) == 0 )  .AND.;
                  !( ::lExcImp .AND. nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                  nTotUni              := nTotNFacCli( ::oFacCliL )
                  nTotImp              := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  nDtoAtp              := nDtoAtpFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )

                  if !::oDbf:Seek( ::oFacCliL:cRef )

                     ::oDbf:Append()

                     ::oDbf:cCodArt    := ::oFacCliL:cRef
                     ::oDbf:cNomArt    := ::oFacCliL:cDetalle
                     ::oDbf:nTotUni    := nTotNFacCli( ::oFacCliL )
                     ::oDbf:nTotNet    := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nTotIva    := nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nTotDoc    := ::oDbf:nTotNet + ::oDbf:nTotIva

                     if ::oFacCliL:nCosDiv == 0
                        ::oDbf:nTotCos := nRetPreCosto( ::oDbfArt:cAlias, ::oFacCliL:cRef ) * nTotUni
                     else
                        ::oDbf:nTotCos := ::oFacCliL:nCosDiv * nTotUni
                     end if

                     ::oDbf:nDtoAtp    := nDtoAtp
                     ::oDbf:nMargen    := nTotImp - ::oDbf:nTotCos - ::oDbf:nDtoAtp

                     if nTotUni != 0
                        ::oDbf:nRentab := nRentabilidad( nTotImp, ::oDbf:nDtoAtp, ::oDbf:nTotCos )
                        ::oDbf:nPreMed := nTotImp / nTotUni
                        ::oDbf:nCosMed := ::oDbf:nTotCos / nTotUni
                     else
                        ::oDbf:nRentab := 0
                        ::oDbf:nPreMed := 0
                        ::oDbf:nCosMed := 0
                     end if

                     ::oDbf:Save()

                  else

                     ::oDbf:Load()

                     ::oDbf:nTotUni    += nTotNFacCli( ::oFacCliL )
                     ::oDbf:nTotNet    += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nTotIva    += nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nTotDoc    += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nTotDoc    += nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                     if ::oFacCliL:nCosDiv == 0
                        ::oDbf:nTotCos += nRetPreCosto( ::oDbfArt:cAlias, ::oFacCliL:cRef ) * nTotUni
                     else
                        ::oDbf:nTotCos += ::oFacCliL:nCosDiv * nTotUni
                     end if

                     ::oDbf:nDtoAtp    += nDtoAtp
                     ::oDbf:nMargen    := ::oDbf:nTotNet - ::oDbf:nTotCos - ::oDbf:nDtoAtp

                     if nTotUni != 0
                        ::oDbf:nRentab := nRentabilidad( ::oDbf:nTotNet, ::oDbf:nDtoAtp, ::oDbf:nTotCos )
                        ::oDbf:nPreMed := ::oDbf:nTotNet / ::oDbf:nTotUni
                        ::oDbf:nCosMed := ::oDbf:nTotCos / ::oDbf:nTotUni
                     else
                        ::oDbf:nRentab := 0
                        ::oDbf:nPreMed := 0
                        ::oDbf:nCosMed := 0
                     end if

                     ::oDbf:Save()

                  end if

               end if

         ::oFacCliL:Skip()

         end while

      end if

   ::oFacCliT:Skip()

   ::oMtrInf:AutoInc()

   end while

   ::oFacCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacCliT:cFile ) )

   ::oFacCliL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacCliL:cFile ) )

   /*Procesamos las facturas rectificativas*/

   ::oFacRecT:OrdSetFocus( "dFecFac" )
   ::oFacRecL:OrdSetFocus( "nNumFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter 
   end if

   ::oFacRecT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )
   ::oMtrInf:cText   := "Procesando rectificativas"

   cExpLine          := '!lTotLin .and. !lControl'

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oFacRecL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacRecL:cFile ), ::oFacRecL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacRecT:GoTop()

   while !::lBreak .and. !::oFacRecT:Eof()

      if lChkSer( ::oFacRecT:cSerie, ::aSer )     .and.;
         ::oFacRecL:Seek( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac )

         while ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac == ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac .and.;
               !::oFacRecL:Eof()

               if !( ::lExcCero .AND. nTotNFacRec( ::oFacRecL ) == 0 )        .AND.;
                  !( ::lExcImp .AND. nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                  nTotUni              := nTotNFacRec( ::oFacRecL )
                  nTotImp              := nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  nDtoAtp              := 0

                  if !::oDbf:Seek( ::oFacRecL:cRef )

                     ::oDbf:Append()

                     ::oDbf:cCodArt    := ::oFacRecL:cRef
                     ::oDbf:cNomArt    := ::oFacRecL:cDetalle
                     ::oDbf:nTotUni    := -( nTotNFacRec( ::oFacRecL ) )
                     ::oDbf:nTotNet    := -( nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )
                     ::oDbf:nTotIva    := -( nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )
                     ::oDbf:nTotDoc    := ::oDbf:nTotNet + ::oDbf:nTotIva

                     if ::oFacRecL:nCosDiv == 0
                        ::oDbf:nTotCos := nRetPreCosto( ::oDbfArt:cAlias, ::oFacRecL:cRef ) * nTotUni
                     else
                        ::oDbf:nTotCos := ::oFacRecL:nCosDiv * nTotUni
                     end if

                     ::oDbf:nDtoAtp    := nDtoAtp
                     ::oDbf:nMargen    := nTotImp - ::oDbf:nTotCos - ::oDbf:nDtoAtp
                     if nTotUni != 0
                        ::oDbf:nRentab := nRentabilidad( nTotImp, ::oDbf:nDtoAtp, ::oDbf:nTotCos )
                        ::oDbf:nPreMed := nTotImp / nTotUni
                        ::oDbf:nCosMed := ::oDbf:nTotCos / nTotUni
                     else
                        ::oDbf:nRentab := 0
                        ::oDbf:nPreMed := 0
                        ::oDbf:nCosMed := 0
                     end if

                     ::oDbf:Save()

                  else

                     ::oDbf:Load()

                     ::oDbf:nTotUni    += nTotNFacRec( ::oFacRecL )
                     ::oDbf:nTotNet    += nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nTotIva    += nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nTotDoc    += nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nTotDoc    += nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                     if ::oFacRecL:nCosDiv == 0
                        ::oDbf:nTotCos += nRetPreCosto( ::oDbfArt:cAlias, ::oFacRecL:cRef ) * nTotUni
                     else
                        ::oDbf:nTotCos += ::oFacRecL:nCosDiv * nTotUni
                     end if

                     ::oDbf:nDtoAtp    += nDtoAtp
                     ::oDbf:nMargen    := ::oDbf:nTotNet - ::oDbf:nTotCos - ::oDbf:nDtoAtp

                     if nTotUni != 0
                        ::oDbf:nRentab := nRentabilidad( ::oDbf:nTotNet, ::oDbf:nDtoAtp, ::oDbf:nTotCos )
                        ::oDbf:nPreMed := ::oDbf:nTotNet / ::oDbf:nTotUni
                        ::oDbf:nCosMed := ::oDbf:nTotCos / ::oDbf:nTotUni
                     else
                        ::oDbf:nRentab := 0
                        ::oDbf:nPreMed := 0
                        ::oDbf:nCosMed := 0
                     end if

                     ::oDbf:Save()

                  end if

               end if

         ::oFacRecL:Skip()

         end while

      end if

   ::oFacRecT:Skip()

   ::oMtrInf:AutoInc()

   end while

   ::oFacRecT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacRecT:cFile ) )

   ::oFacRecL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacRecL:cFile ) )

   /*Procesamos los tickets*/

   ::oTikCliT:OrdSetFocus( "dFecTik" )
   ::oTikCliL:OrdSetFocus( "cNumTil" )

   cExpHead          := 'dFecTik >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecTik <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   cExpHead          += ' .and. ( cTipTik == "1" .or. cTipTik == "4" )'

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter 
   end if

   ::oTikCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oTikCliT:cFile ), ::oTikCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oTikCliT:OrdKeyCount() )
   ::oMtrInf:cText   := "Procesando tickets"

   cExpLine          := '!lControl'

   if ::lAllArt
      cExpLine       += ' .and. ( !Empty( cCbaTil ) .or. !Empty( cComTil ) )'
   else
      cExpLine       += ' .and. ( ( !Empty( cCbaTil ) .and. cCbaTil >= "' + ::cArtOrg + '" .and. cCbaTil <= "' + ::cArtDes + '" )'
      cExpLine       += ' .or. '
      cExpLine       += '( !Empty( cComTil ) .and. cComTil >= "' + ::cArtOrg + '" .and. cComTil <= "' + ::cArtDes + '" ) )'
   end if

   ::oTikCliL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oTikCliL:cFile ), ::oTikCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oTikCliT:GoTop()

   while !::lBreak .and. !::oTikCliT:Eof()

      if lChkSer( ::oTikCliT:cSerTik, ::aSer )     .and.;
         ::oTikCliL:Seek( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik )

         while ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil == ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik .and.;
               !::oTikCliL:Eof()

               if !Empty( ::oTikCliL:cCbaTil )                       .AND.;
                  !( ::lExcCero .AND. ::oTikCliL:nUntTil == 0 )      .AND.;
                  !( ::lExcImp .AND. ::oTikCliL:nPvpTil == 0 )

                  nTotUni                 := ::oTikCliL:nUntTil
                  nTotImp                 := nImpLTpv( ::oTikCliT, ::oTikCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, nil, 1 )
                  nDtoAtp                 := 0

                  if !::oDbf:Seek( ::oTikCliL:cCbaTil )

                     ::oDbf:Append()

                     ::oDbf:cCodArt       := ::oTikCliL:cCbaTil
                     ::oDbf:cNomArt       := ::oTikCliL:cNomTil
                     if ::oTikCliT:cTipTik == "4"
                        ::oDbf:nTotUni    := - ::oTikCliL:nUntTil
                     else
                        ::oDbf:nTotUni    := ::oTikCliL:nUntTil
                     end if
                     ::oDbf:nTotNet       := nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 1 )
                     ::oDbf:nTotIva       := nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 1 )
                     ::oDbf:nTotDoc       := ::oDbf:nTotNet + ::oDbf:nTotIva

                     if ::oTikCliL:nCosDiv == 0
                        ::oDbf:nTotCos := nRetPreCosto( ::oDbfArt:cAlias, ::oTikCliL:cCbaTil ) * if( ::oTikCliT:cTipTik == "4", -( ::oTikCliL:nUntTil ), ::oTikCliL:nUntTil )
                     else
                        ::oDbf:nTotCos := ::oTikCliL:nCosDiv * if( ::oTikCliT:cTipTik == "4", -( ::oTikCliL:nUntTil ), ::oTikCliL:nUntTil )
                     end if

                     ::oDbf:nDtoAtp       := nDtoAtp
                     ::oDbf:nMargen       := nTotImp - ::oDbf:nTotCos - ::oDbf:nDtoAtp

                     if nTotUni != 0
                        ::oDbf:nRentab    := nRentabilidad( nTotImp, ::oDbf:nDtoAtp, ::oDbf:nTotCos )
                        ::oDbf:nPreMed    := nTotImp / nTotUni
                        ::oDbf:nCosMed    := ::oDbf:nTotCos / nTotUni
                     else
                        ::oDbf:nRentab    := 0
                        ::oDbf:nPreMed    := 0
                        ::oDbf:nCosMed    := 0
                     end if

                     ::oDbf:Save()

                  else

                     ::oDbf:Load()

                     if ::oTikCliT:cTipTik == "4"
                        ::oDbf:nTotUni    += - ::oTikCliL:nUntTil
                     else
                        ::oDbf:nTotUni    += ::oTikCliL:nUntTil
                     end if
                     ::oDbf:nTotNet       += nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 1 )
                     ::oDbf:nTotIva       += nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 1)
                     ::oDbf:nTotDoc       += nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 1 )
                     ::oDbf:nTotDoc       += nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 1 )

                     if ::oTikCliL:nCosDiv == 0
                        ::oDbf:nTotCos    += nRetPreCosto( ::oDbfArt:cAlias, ::oTikCliL:cCbaTil ) * if( ::oTikCliT:cTipTik == "4", -( ::oTikCliL:nUntTil ), ::oTikCliL:nUntTil )
                     else
                        ::oDbf:nTotCos    += ::oTikCliL:nCosDiv * if( ::oTikCliT:cTipTik == "4", -( ::oTikCliL:nUntTil ), ::oTikCliL:nUntTil )
                     end if

                     ::oDbf:nDtoAtp       += nDtoAtp
                     ::oDbf:nMargen       := ::oDbf:nTotNet - ::oDbf:nTotCos - ::oDbf:nDtoAtp
                     if nTotUni != 0
                        ::oDbf:nRentab    := nRentabilidad( ::oDbf:nTotNet, ::oDbf:nDtoAtp, ::oDbf:nTotCos )
                        ::oDbf:nPreMed    := ::oDbf:nTotNet / ::oDbf:nTotUni
                        ::oDbf:nCosMed    := ::oDbf:nTotCos / ::oDbf:nTotUni
                     else
                        ::oDbf:nRentab    := 0
                        ::oDbf:nPreMed    := 0
                        ::oDbf:nCosMed    := 0
                     end if

                     ::oDbf:Save()

                  end if

               end if

               if !Empty( ::oTikCliL:cComTil )                       .AND.;
                  !( ::lExcCero .AND. ::oTikCliL:nUntTil == 0 )      .AND.;
                  !( ::lExcImp .AND. ::oTikCliL:nPcmTil == 0 )

                  nTotUni                 := ::oTikCliL:nUntTil
                  nTotImp                 := nImpLTpv( ::oTikCliT, ::oTikCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, nil, 2 )
                  nDtoAtp                 := 0

                  if !::oDbf:Seek( ::oTikCliL:cComTil )

                     ::oDbf:Append()

                     ::oDbf:cCodArt       := ::oTikCliL:cComTil
                     ::oDbf:cNomArt       := ::oTikCliL:cNcmTil
                     if ::oTikCliT:cTipTik == "4"
                        ::oDbf:nTotUni    := - ::oTikCliL:nUntTil
                     else
                        ::oDbf:nTotUni    := ::oTikCliL:nUntTil
                     end if
                     ::oDbf:nTotNet       := nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 2 )
                     ::oDbf:nTotIva       := nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 2 )
                     ::oDbf:nTotDoc       := ::oDbf:nTotNet + ::oDbf:nTotIva

                     if ::oTikCliL:nCosDiv == 0
                        ::oDbf:nTotCos    := nRetPreCosto( ::oDbfArt:cAlias, ::oTikCliL:cComTil ) * if( ::oTikCliT:cTipTik == "4", -( ::oTikCliL:nUntTil ), ::oTikCliL:nUntTil )
                     else
                        ::oDbf:nTotCos    := ::oTikCliL:nCosDiv * if( ::oTikCliT:cTipTik == "4", -( ::oTikCliL:nUntTil ), ::oTikCliL:nUntTil )
                     end if

                     ::oDbf:nDtoAtp       := nDtoAtp
                     ::oDbf:nMargen       := nTotImp - ::oDbf:nTotCos - ::oDbf:nDtpAtp

                    if nTotUni != 0
                        ::oDbf:nRentab    := nRentabilidad( nTotImp, ::oDbf:nDtoAtp, ::oDbf:nTotCos )
                        ::oDbf:nPreMed    := nTotImp / nTotUni
                        ::oDbf:nCosMed    := ::oDbf:nTotCos / nTotUni
                     else
                        ::oDbf:nRentab    := 0
                        ::oDbf:nPreMed    := 0
                        ::oDbf:nCosMed    := 0
                     end if

                     ::oDbf:Save()

                  else

                     ::oDbf:Load()

                     if ::oTikCliT:cTipTik == "4"
                        ::oDbf:nTotUni    += - ::oTikCliL:nUntTil
                     else
                        ::oDbf:nTotUni    += ::oTikCliL:nUntTil
                     end if
                     ::oDbf:nTotNet       += nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 2 )
                     ::oDbf:nTotIva       += nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 2 )
                     ::oDbf:nTotDoc       += nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 2 )
                     ::oDbf:nTotDoc       += nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 2 )

                     if ::oTikCliL:nCosDiv == 0
                        ::oDbf:nTotCos    += nRetPreCosto( ::oDbfArt:cAlias, ::oTikCliL:cComTil ) * if( ::oTikCliT:cTipTik == "4", -( ::oTikCliL:nUntTil ), ::oTikCliL:nUntTil )
                     else
                        ::oDbf:nTotCos    += ::oTikCliL:nCosDiv * if( ::oTikCliT:cTipTik == "4", -( ::oTikCliL:nUntTil ), ::oTikCliL:nUntTil )
                     end if

                     ::oDbf:nDtoAtp       += nDtoAtp
                     ::oDbf:nMargen       := ::oDbf:nTotNet - ::oDbf:nTotCos - ::oDbf:nDtoAtp
                     if nTotUni != 0
                        ::oDbf:nRentab    := nRentabilidad( ::oDbf:nTotNet, ::oDbf:nDtoAtp, ::oDbf:nTotCos )
                        ::oDbf:nPreMed    := ::oDbf:nTotNet / ::oDbf:nTotUni
                        ::oDbf:nCosMed    := ::oDbf:nTotCos / ::oDbf:nTotUni
                     else
                        ::oDbf:nRentab    := 0
                        ::oDbf:nPreMed    := 0
                        ::oDbf:nCosMed    := 0
                     end if

                     ::oDbf:Save()

                  end if

               end if

         ::oTikCliL:Skip()

         end while

      end if

   ::oTikCliT:Skip()

   ::oMtrInf:AutoInc()

   end while

   ::oTikCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oTikCliT:cFile ) )

   ::oTikCliL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oTikCliL:cFile ) )

   ::oMtrInf:AutoInc( ::oTikCliT:LastRec() )

   ::oDlg:Enable()

   ::oDbf:OrdSetFocus( "NTOTDOC" )

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//