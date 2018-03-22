#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TAnuUndVta FROM TInfPArt

   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Aceptado", "Todos" }
   DATA  oEstado     AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create ()

   ::AddField ( "cCodFam", "C", 16, 0, {|| "@!" },         "Familia",          .f., "Familia",                    5, .f. )
   ::AddField ( "cNomFam", "C", 50, 0, {|| "@!" },         "Nom. fam.",        .f., "Nombre familia",            35, .f. )
   ::AddField ( "cCodArt", "C", 18, 0, {|| "@!" },         "Cod. articulo",    .t., "Cod. Artículo",             14, .f. )
   ::AddField ( "cNomArt", "C",100, 0, {|| "@!" },         "Artículo",         .t., "Nom. Artículo",             20, .f. )
   ::AddField ( "nImpEne", "N", 16, 6, {|| MasUnd() },     "Ene",              .t., "Enero",                     12, .t. )
   ::AddField ( "nImpFeb", "N", 16, 6, {|| MasUnd() },     "Feb",              .t., "Febrero",                   12, .t. )
   ::AddField ( "nImpMar", "N", 16, 6, {|| MasUnd() },     "Mar",              .t., "Marzo",                     12, .t. )
   ::AddField ( "nImpAbr", "N", 16, 6, {|| MasUnd() },     "Abr",              .t., "Abril",                     12, .t. )
   ::AddField ( "nImpMay", "N", 16, 6, {|| MasUnd() },     "May",              .t., "Mayo",                      12, .t. )
   ::AddField ( "nImpJun", "N", 16, 6, {|| MasUnd() },     "Jun",              .t., "Junio",                     12, .t. )
   ::AddField ( "nImpJul", "N", 16, 6, {|| MasUnd() },     "Jul",              .t., "Julio",                     12, .t. )
   ::AddField ( "nImpAgo", "N", 16, 6, {|| MasUnd() },     "Ago",              .t., "Agosto",                    12, .t. )
   ::AddField ( "nImpSep", "N", 16, 6, {|| MasUnd() },     "Sep",              .t., "Septiembre",                12, .t. )
   ::AddField ( "nImpOct", "N", 16, 6, {|| MasUnd() },     "Oct",              .t., "Octubre",                   12, .t. )
   ::AddField ( "nImpNov", "N", 16, 6, {|| MasUnd() },     "Nov",              .t., "Noviembre",                 12, .t. )
   ::AddField ( "nImpDic", "N", 16, 6, {|| MasUnd() },     "Dic",              .t., "Diciembre",                 12, .t. )
   ::AddField ( "nImpTot", "N", 16, 6, {|| MasUnd() },     "Tot",              .t., "Total",                     12, .t. )
   ::AddField ( "nImpVta", "N", 16, 6, {|| ::cPicOut },    "Tot. Vta.",        .f., "Importe venta",             12, .f. )
   ::AddField ( "nDtoAtp", "N", 16, 6, {|| ::cPicOut },    "Dto. Atp.",        .f., "Descuento atipico",         12, .f. )
   ::AddField ( "nTotCos", "N", 16, 6, {|| ::cPicOut },    "Tot. Cos.",        .f., "Total costo",               12, .f. )
   ::AddField ( "nRenTab", "N", 16, 6, {|| ::cPicOut },    "%Rent.",           .f., "Rentabilidad",              12, .f. )

   ::AddTmpIndex( "cCodFam", "cCodFam + cCodArt" )
   ::AddGroup( {|| ::oDbf:cCodFam }, {|| "Familia  : " + Rtrim( ::oDbf:cCodFam ) + "-" + Rtrim( ::oDbf:cNomFam ) }, {|| "Total familia..." } )

   ::lDefGraph    := .t.

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "ALBCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oFacRecT PATH ( cPatEmp() ) FILE "FACRECT.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL PATH ( cPatEmp() ) FILE "FACRECL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) FILE "TIKET.DBF"    VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) FILE "TIKEL.DBF"    VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oDbfCli  PATH ( cPatCli() ) FILE "CLIENT.DBF"   VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

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
   if !Empty( ::oDbfCli ) .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if

   ::oAlbCliT := nil
   ::oAlbCliL := nil
   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oFacRecT := nil
   ::oFacRecL := nil
   ::oTikCliT := nil
   ::oTikCliL := nil
   ::oDbfCli  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INFGENARTC" )
      return .f.
   end if

   ::CreateFilter( , ::oDbf, .t. )

   ::lExcCero  := .f.

   /*
   Monta los articulos de manera automatica
   */

   if !::lDefArtInf( 110, 120, 130, 140, 800 )
      return .f.
   end if

   if !::lDefFamInf( 310, 311, 320, 321, 300 )
      return .f.
   end if

   ::oDefExcInf( 210 )
   ::oDefExcImp( 211 )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead := ""
   local cExpLine := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader   := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                     {|| "Periodo  : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Familia  : " + if( ::lAllFam, "Todas", AllTrim( ::cFamOrg ) + " > " + AllTrim( ::cFamDes ) ) },;
                     {|| "Artículo : " + if( ::lAllArt, "Todas", AllTrim( ::cArtOrg ) + " > " + AllTrim( ::cArtDes ) ) } }

   ::oAlbCliT:OrdSetFocus( "dFecAlb" )
   ::oAlbCliL:OrdSetFocus( "nNumAlb" )

   cExpHead          := 'nFacturado < 3 .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !Empty( ::oFilter:cExpresionFilter ) 
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oAlbCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oAlbCliT:cFile ), ::oAlbCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Albaranes"
   ::oMtrInf:SetTotal( ::oAlbCliT:OrdKeyCount() )

   /*
   Lineas de albaranes
   */

   cExpLine          := '!lTotLin .and. !lControl'

   if !::lAllFam
      cExpLine       += ' .and. cCodFam >= "' + ::cFamOrg + '" .and. cCodFam <= "' + ::cFamDes + '"'
   end if

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oAlbCliL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oAlbCliL:cFile ), ::oAlbCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oAlbCliT:GoTop()
   while !::lBreak .and. !::oAlbCliT:Eof()

      if lChkSer( ::oAlbCliT:cSerAlb, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oAlbCliL:Seek( ::oAlbCliT:CSERALB + Str( ::oAlbCliT:NNUMALB ) + ::oAlbCliT:CSUFALB )

            while ::oAlbCliT:CSERALB + Str( ::oAlbCliT:NNUMALB ) + ::oAlbCliT:CSUFALB == ::oAlbCliL:CSERALB + Str( ::oAlbCliL:NNUMALB ) + ::oAlbCliL:CSUFALB .AND. ! ::oAlbCliL:eof()

               if !( ::lExcCero .AND. nTotNAlbCli( ::oAlbCliL ) == 0 )        .AND.;
                  !( ::lExcImp .AND. nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                  if !::oDbf:Seek( ::oAlbCliL:cCodFam + ::oAlbCliL:cRef )
                     ::oDbf:Blank()
                     ::oDbf:cCodFam := ::oAlbCliL:cCodFam
                     ::oDbf:cNomFam := cNomFam( ::oAlbCliL:cCodFam, ::oDbfFam )
                     ::oDbf:cCodArt := ::oAlbCliL:cRef
                     ::oDbf:cNomArt := oRetFld( ::oAlbCliL:cRef, ::oDbfArt )
                     ::oDbf:nImpVta := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nDtoAtp := nDtoAtpAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )
                     if ::oAlbCliL:nCosDiv == 0
                        ::oDbf:nTotCos := nRetPreCosto( ::oDbfArt:cAlias, ::oAlbCliL:cRef ) * nTotNAlbCli( ::oAlbCliL )
                     else
                        ::oDbf:nTotCos := ::oAlbCliL:nCosDiv * nTotNAlbCli( ::oAlbCliL )
                     end if
                     ::oDbf:Insert()
                  else
                     ::oDbf:Load()
                     ::oDbf:nImpVta += nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nDtoAtp += nDtoAtpAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )
                     if ::oAlbCliL:nCosDiv == 0
                        ::oDbf:nTotCos += nRetPreCosto( ::oDbfArt:cAlias, ::oAlbCliL:cRef ) * nTotNAlbCli( ::oAlbCliL )
                     else
                        ::oDbf:nTotCos += ::oAlbCliL:nCosDiv * nTotNAlbCli( ::oAlbCliL )
                     end if
                     ::oDbf:Save()
                  end if

                  ::AddImporte( ::oAlbCliT:dFecAlb, nTotNAlbCli( ::oAlbCliL ) )

                  ::oDbf:Load()
                  ::oDbf:nRentab    := nRentabilidad( ::oDbf:nImpVta, ::oDbf:nDtoAtp, ::oDbf:nTotCos )
                  ::oDbf:Save()

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

   /*
   Nos movemos por las cabeceras de los facturas a proveedores
	*/

   ::oFacCliT:OrdSetFocus( "dFecFac" )
   ::oFacCliL:OrdSetFocus( "nNumFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ::oFilter:aExpFilter[ 2 ]
   end if

   ::oFacCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Facturas"
   ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )

   /*
   Lineas de albaranes
   */

   cExpLine          := '!lTotLin .and. !lControl'

   if !::lAllFam
      cExpLine       += ' .and. cCodFam >= "' + ::cFamOrg + '" .and. cCodFam <= "' + ::cFamDes + '"'
   end if

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oFacCliL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacCliL:cFile ), ::oFacCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacCliT:GoTop()

   while !::lBreak .and. !::oFacCliT:Eof()

      if lChkSer( ::oFacCliT:CSERIE, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oFacCliL:Seek( ::oFacCliT:CSERIE + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC )

            while ::oFacCliT:CSERIE + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC == ::oFacCliL:CSERIE + Str( ::oFacCliL:NNUMFAC ) + ::oFacCliL:CSUFFAC .AND. ! ::oFacCliL:eof()

               if !( ::lExcCero .AND. nTotNFacCli( ::oFacCliL ) == 0 )  .AND.;
                  !( ::lExcImp .AND. nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                  if !::oDbf:Seek( ::oFacCliL:cCodFam + ::oFacCliL:cRef )
                     ::oDbf:Blank()
                     ::oDbf:cCodFam := ::oFacCliL:cCodFam
                     ::oDbf:cNomFam := cNomFam( ::oFacCliL:cCodFam, ::oDbfFam )
                     ::oDbf:cCodArt := ::oFacCliL:cRef
                     ::oDbf:cNomArt := oRetFld( ::oFacCliL:cRef, ::oDbfArt )
                     ::oDbf:nImpVta := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nDtoAtp := nDtoAtpFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )
                     if ::oFacCliL:nCosDiv == 0
                        ::oDbf:nTotCos := nRetPreCosto( ::oDbfArt:cAlias, ::oFacCliL:cRef ) * nTotNFacCli( ::oFacCliL )
                     else
                        ::oDbf:nTotCos := ::oFacCliL:nCosDiv * nTotNFacCli( ::oFacCliL )
                     end if
                     ::oDbf:Insert()
                  else
                     ::oDbf:Load()
                     ::oDbf:nImpVta += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nDtoAtp += nDtoAtpFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )
                     if ::oFacCliL:nCosDiv == 0
                        ::oDbf:nTotCos += nRetPreCosto( ::oDbfArt:cAlias, ::oFacCliL:cRef ) * nTotNFacCli( ::oFacCliL )
                     else
                        ::oDbf:nTotCos += ::oFacCliL:nCosDiv * nTotNFacCli( ::oFacCliL )
                     end if
                     ::oDbf:Save()
                  end if

                  ::AddImporte( ::oFacCliT:dFecFac, nTotNFacCli( ::oFacCliL ) )

                  ::oDbf:Load()
                  ::oDbf:nRentab    := nRentabilidad( ::oDbf:nImpVta, ::oDbf:nDtoAtp, ::oDbf:nTotCos )
                  ::oDbf:Save()

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

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ::oFilter:aExpFilter[ 3 ]
   end if

   ::oFacRecT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Fac. rec."
   ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )

   /*
   Lineas de albaranes
   */

   cExpLine          := '!lTotLin .and. !lControl'

    if !::lAllFam
      cExpLine       += ' .and. cCodFam >= "' + ::cFamOrg + '" .and. cCodFam <= "' + ::cFamDes + '"'
   end if

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oFacRecL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacRecL:cFile ), ::oFacRecL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacRecT:GoTop()

   while !::lBreak .and. !::oFacRecT:Eof()

      if lChkSer( ::oFacRecT:CSERIE, ::aSer )

         if ::oFacRecL:Seek( ::oFacRecT:CSERIE + Str( ::oFacRecT:NNUMFAC ) + ::oFacRecT:CSUFFAC )

            while ::oFacRecT:CSERIE + Str( ::oFacRecT:NNUMFAC ) + ::oFacRecT:CSUFFAC == ::oFacRecL:CSERIE + Str( ::oFacRecL:NNUMFAC ) + ::oFacRecL:CSUFFAC .AND. ! ::oFacRecL:eof()

               if !( ::lExcCero .AND. nTotNFacRec( ::oFacRecL ) == 0 )        .AND.;
                  !( ::lExcImp .AND. nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                  if !::oDbf:Seek( ::oFacRecL:cCodFam + ::oFacRecL:cRef )

                     ::oDbf:Blank()
                     ::oDbf:cCodFam := ::oFacRecL:cCodFam
                     ::oDbf:cNomFam := cNomFam( ::oFacRecL:cCodFam, ::oDbfFam )
                     ::oDbf:cCodArt := ::oFacRecL:cRef
                     ::oDbf:cNomArt := oRetFld( ::oFacRecL:cRef, ::oDbfArt )
                     ::oDbf:nImpVta := nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nDtoAtp := 0
                     if ::oFacRecL:nCosDiv == 0
                        ::oDbf:nTotCos := nRetPreCosto( ::oDbfArt:cAlias, ::oFacRecL:cRef ) * nTotNFacRec( ::oFacRecL )
                     else
                        ::oDbf:nTotCos := ::oFacRecL:nCosDiv * nTotNFacRec( ::oFacRecL )
                     end if
                     ::oDbf:Insert()
                  else
                     ::oDbf:Load()
                     ::oDbf:nImpVta += nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nDtoAtp += 0
                     if ::oFacRecL:nCosDiv == 0
                        ::oDbf:nTotCos += nRetPreCosto( ::oDbfArt:cAlias, ::oFacRecL:cRef ) * nTotNFacRec( ::oFacRecL )
                     else
                        ::oDbf:nTotCos += ::oFacRecL:nCosDiv * nTotNFacRec( ::oFacRecL )
                     end if
                     ::oDbf:Save()
                  end if

                  ::AddImporte( ::oFacRecT:dFecFac, nTotNFacRec( ::oFacRecL ) )

                  ::oDbf:Load()
                  ::oDbf:nRentab    := nRentabilidad( ::oDbf:nImpVta, ::oDbf:nDtoAtp, ::oDbf:nTotCos )
                  ::oDbf:Save()

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

   /*
   Damos valor al meter--------------------------------------------------------
   */

   ::oTikCliT:OrdSetFocus( "dFecTik" )
   ::oTikCliL:OrdSetFocus( "cNumTil" )

   /*
   Cabeceras de tikets creamos el indice sobre la cabecera
   */

   cExpHead          := 'dFecTik >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecTik <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   cExpHead          += ' .and. ( cTipTik == "1" .or. cTipTik == "4" )'

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter 
   end if

   ::oTikCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oTikCliT:cFile ), ::oTikCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Tickets"
   ::oMtrInf:SetTotal( ::oTikCliT:OrdKeyCount() )

   /*
   Lineas de tikets
   */

   cExpLine          := '!lControl'

   if !::lAllFam
      cExpLine       += ' .and. cCodFam >= "' + ::cFamOrg + '" .and. cCodFam <= "' + ::cFamDes + '"'
   end if

   if ::lAllArt
      cExpLine       += ' .and. ( !Empty( cCbaTil ) .or. !Empty( cComTil ) )'
   else
      cExpLine       += ' .and. ( ( ( !Empty( cCbaTil ) .and. cCbaTil >= "' + ::cArtOrg + '" .and. cCbaTil <= "' + ::cArtDes + '" )'
      cExpLine       += ' .or. '
      cExpLine       += '( !Empty( cComTil ) .and. cComTil >= "' + ::cArtOrg + '" .and. cComTil <= "' + ::cArtDes + '" ) ) )'
   end if

   ::oTikCliL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oTikCliL:cFile ), ::oTikCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oTikCliT:GoTop()

   while !::lBreak .and. !::oTikCliT:Eof()

      if lChkSer( ::oTikCliT:cSerTik, ::aSer )

         if ::oTikCliL:Seek( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik )

            while ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik == ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil .AND. !::oTikCliL:eof()

               if !Empty( ::oTikCliL:cCbaTil )                       .AND.;
                  !( ::lExcCero .AND. ::oTikCliL:nUntTil == 0 )      .AND.;
                  !( ::lExcImp .AND. ::oTikCliL:nPvpTil == 0 )

                  if !::oDbf:Seek( ::oTikCliL:cCodFam + ::oTikCliL:cCbaTil )

                     ::oDbf:Blank()
                     ::oDbf:cCodFam := ::oTikCliL:cCodFam
                     ::oDbf:cNomFam := cNomFam( ::oTikCliL:cCodFam, ::oDbfFam )
                     ::oDbf:cCodArt := ::oTikCliL:cCbaTil
                     ::oDbf:cNomArt := oRetFld( ::oTikCliL:cCbaTil, ::oDbfArt )
                     ::oDbf:nImpVta := nImpLTpv( ::oTikCliT, ::oTikCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, nil, 1 )
                     ::oDbf:nDtoAtp := 0
                     if ::oTikCliL:nCosDiv == 0
                        ::oDbf:nTotCos := nRetPreCosto( ::oDbfArt:cAlias, ::oTikCliL:cCbaTil ) * if( ::oTikCliT:cTipTik == "4", -( ::oTikCliL:nUntTil ), ::oTikCliL:nUntTil )
                     else
                        ::oDbf:nTotCos := ::oTikCliL:nCosDiv * if( ::oTikCliT:cTipTik == "4", -( ::oTikCliL:nUntTil ), ::oTikCliL:nUntTil )
                     end if
                     ::oDbf:Insert()
                  else
                     ::oDbf:Load()
                     ::oDbf:nImpVta += nImpLTpv( ::oTikCliT, ::oTikCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, nil, 1 )
                     ::oDbf:nDtoAtp += 0
                     if ::oTikCliL:nCosDiv == 0
                        ::oDbf:nTotCos += nRetPreCosto( ::oDbfArt:cAlias, ::oTikCliL:cCbaTil ) * if( ::oTikCliT:cTipTik == "4", -( ::oTikCliL:nUntTil ), ::oTikCliL:nUntTil )
                     else
                        ::oDbf:nTotCos += ::oTikCliL:nCosDiv * if( ::oTikCliT:cTipTik == "4", -( ::oTikCliL:nUntTil ), ::oTikCliL:nUntTil )
                     end if
                     ::oDbf:Save()
                  end if

                  ::AddImporte( ::oTikCliT:dFecTik, if( ::oTikCliT:cTipTik == "4", -( ::oTikCliL:nUntTil ), ::oTikCliL:nUntTil ) )

                  ::oDbf:Load()
                  ::oDbf:nRentab    := nRentabilidad( ::oDbf:nImpVta, ::oDbf:nDtoAtp, ::oDbf:nTotCos )
                  ::oDbf:Save()

               end if

               /*
               Productos combinados--------------------------------------------
               */

               if !Empty( ::oTikCliL:cComTil )                       .AND.;
                  !( ::lExcCero .AND. ::oTikCliL:nUntTil == 0 )      .AND.;
                  !( ::lExcImp .AND. ::oTikCliL:nPcmTil == 0 )

                  if !::oDbf:Seek( ::oTikCliL:cCodFam + ::oTikCliL:cComTil )
                     ::oDbf:Blank()
                     ::oDbf:cCodFam := ::oTikCliL:cCodFam
                     ::oDbf:cNomFam := cNomFam( ::oTikCliL:cCodFam, ::oDbfFam )
                     ::oDbf:cCodArt := ::oTikCliL:cComTil
                     ::oDbf:cNomArt := oRetFld( ::oTikCliL:cComTil, ::oDbfArt )
                     ::oDbf:nImpVta := nImpLTpv( ::oTikCliT, ::oTikCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, nil, 2 )
                     ::oDbf:nDtoAtp := 0
                     if ::oTikCliL:nCosDiv == 0
                        ::oDbf:nTotCos := nRetPreCosto( ::oDbfArt:cAlias, ::oTikCliL:cCbaTil ) * if( ::oTikCliT:cTipTik == "4", -( ::oTikCliL:nUntTil ), ::oTikCliL:nUntTil )
                     else
                        ::oDbf:nTotCos := ::oTikCliL:nCosDiv * if( ::oTikCliT:cTipTik == "4", -( ::oTikCliL:nUntTil ), ::oTikCliL:nUntTil )
                     end if
                     ::oDbf:Insert()
                  else
                     ::oDbf:Load()
                     ::oDbf:nImpVta += nImpLTpv( ::oTikCliT, ::oTikCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, nil, 2 )
                     ::oDbf:nDtoAtp += 0
                     if ::oTikCliL:nCosDiv == 0
                        ::oDbf:nTotCos += nRetPreCosto( ::oDbfArt:cAlias, ::oTikCliL:cCbaTil ) * if( ::oTikCliT:cTipTik == "4", -( ::oTikCliL:nUntTil ), ::oTikCliL:nUntTil )
                     else
                        ::oDbf:nTotCos += ::oTikCliL:nCosDiv * if( ::oTikCliT:cTipTik == "4", -( ::oTikCliL:nUntTil ), ::oTikCliL:nUntTil )
                     end if
                     ::oDbf:Save()
                  end if

                  ::AddImporte( ::oTikCliT:dFecTik, if( ::oTikCliT:cTipTik == "4", -( ::oTikCliL:nUntTil ), ::oTikCliL:nUntTil ) )

                  ::oDbf:Load()
                  ::oDbf:nRentab    := nRentabilidad( ::oDbf:nImpVta, ::oDbf:nDtoAtp, ::oDbf:nTotCos )
                  ::oDbf:Save()

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

   ::oMtrInf:AutoInc( ::oTikCliT:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//