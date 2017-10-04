#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS XValRStk FROM XInfMov

   DATA  oAlbPrvT    AS OBJECT
   DATA  oAlbPrvL    AS OBJECT
   DATA  oFacPrvT    AS OBJECT
   DATA  oFacPrvL    AS OBJECT
   DATA  oRctPrvL    AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT
   DATA  oHisMov     AS OBJECT
   DATA  oStock      AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodAlm", "C",  16, 0, {|| "@!" },          "Cod.",          .f., "Código almacén",           10, .f. )
   ::AddField( "cNomAlm", "C",  20, 0, {|| "@!" },          "Almacén",       .f., "Nombre almacén",           30, .f. )
   ::AddField( "cCodArt", "C",  18, 0, {|| "@!" },          "Código artículo",     .t., "Código artículo",          14, .f. )
   ::AddField( "cNomArt", "C", 100, 0, {|| "@!" },          "Artículo",      .t., "Nombre artículo",          35, .f. )
   ::AddField( "nTotStk", "N",  16, 6, {|| MasUnd() },      "Und.Stk.",      .t., "Total stock",              10, .f. )
   ::AddField( "nPreStk", "N",  16, 6, {|| ::cPicImp },     "Pre.Med.",      .t., "Precio stock",             10, .f. )
   ::AddField( "nImpStk", "N",  16, 6, {|| ::cPicOut },     "Imp.Stk.",      .t., "Total stock",              10, .f. )

   ::AddTmpIndex( "cCodAlm", "cCodAlm + cCodArt" )

   ::AddGroup( {|| ::oDbf:cCodAlm }, {|| "Almacén : " + Rtrim( ::oDbf:cCodAlm ) + "-" + Rtrim( ::oDbf:cNomAlm ) }, {|| "Total almacén... " } )

   ::lExcCero     := .f.
   ::lExcImp      := .f.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oAlbPrvT PATH ( cPatEmp() )   FILE "ALBPROVT.DBF"  VIA ( cDriver() ) SHARED INDEX "ALBPROVT.CDX"

   DATABASE NEW ::oAlbPrvL PATH ( cPatEmp() )   FILE "ALBPROVL.DBF"  VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"

   DATABASE NEW ::oFacPrvT PATH ( cPatEmp() )   FILE "FACPRVT.DBF"   VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"

   DATABASE NEW ::oFacPrvL PATH ( cPatEmp() )   FILE "FACPRVL.DBF"   VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"

   DATABASE NEW ::oRctPrvL PATH ( cPatEmp() )   FILE "RctPrvL.DBF"   VIA ( cDriver() ) SHARED INDEX "RctPrvL.CDX"

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() )   FILE "ALBCLIL.DBF"   VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() )   FILE "FACCLIL.DBF"   VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oFacRecT PATH ( cPatEmp() )   FILE "FACRECT.DBF"   VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL PATH ( cPatEmp() )   FILE "FACRECL.DBF"   VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() )   FILE "TIKET.DBF"     VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() )   FILE "TIKEL.DBF"     VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oHisMov  PATH ( cPatEmp() )   FILE "HISMOV.DBF"    VIA ( cDriver() ) SHARED INDEX "HISMOV.CDX"

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

   if !Empty( ::oTikCliT ) .and. ::oTikCliT:Used()
      ::oTikCliT:End()
   end if

   if !Empty( ::oTikCliL ) .and. ::oTikCliL:Used()
      ::oTikCliL:End()
   end if

   if !Empty( ::oHisMov ) .and. ::oHisMov:Used()
      ::oHisMov:End()
   end if

   if !Empty( ::oStock )
      ::oStock:end()
   end if

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
   ::oStock   := nil

RETURN ( Self )

//-----------------------------------------------------------------------------

METHOD lResource( cFld )

   if !::StdResource( "XVALRSTK" )
      return .f.
   end if

   ::oBtnFilter:Disable()

   if !::oDefAlmInf( 70, 80, 90, 100, 600 )
      return .f.
   end if

   if !::lDefArtInf( 110, 120, 130, 140, 800 )
      return .f.
   end if

   ::oDefExcInf( 210 )

   ::oDefExcImp( 211 )

   ::oMtrInf:SetTotal( ::oDbfAlm:Lastrec() )

RETURN .t.

//---------------------------------------------------------------------------//

METHOD lGenerate()

   local cExpAlm     := ""
   local cExpArt     := ""
   local nPreMed     := 0
   local nStkAlm     := 0

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader         := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                           {|| "Periodo   : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                           {|| "Artículos : " + if( ::lAllArt, "Todos", AllTrim( ::cArtOrg ) + " > " + AllTrim( ::cArtDes ) ) },;
                           {|| "Almacén   : " + if( ::lAllAlm, "Todos", AllTrim( ::cAlmOrg ) + " > " + AllTrim( ::cAlmDes ) ) } }

   ::oDbfAlm:OrdSetFocus( "CCODALM" )
   ::oDbfArt:OrdSetFocus( "CODIGO" )

   if !::lAllAlm
      cExpAlm        := 'cCodAlm >= "' + Rtrim( ::cAlmOrg ) + '" .and. cCodAlm <= "' + Rtrim( ::cAlmDes ) + '"'
   else
      cExpAlm        := '.t.'
   end if

   ::oDbfAlm:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oDbfAlm:cFile ), ::oDbfAlm:OrdKey(), ( cExpAlm ), , , , , , , , .t. )

   if !::lAllArt
      cExpArt        := 'Codigo >= "' + ::cArtOrg + '" .and. Codigo <= "' + ::cArtDes + '"'
   else
      cExpArt        := '.t.'
   end if

   ::oDbfArt:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oDbfArt:cFile ), ::oDbfArt:OrdKey(), cAllTrimer( cExpArt ), , , , , , , , .t. )

   ::oDbfAlm:GoTop()
   ::oDbfArt:GoTop()

   while !::lBreak .and. !::oDbfAlm:Eof()

      ::oMtrInf:SetTotal( ::oDbfArt:OrdKeyCount() )
      ::oMtrInf:cText   := "Procesando almacén: " + ::oDbfAlm:cCodAlm

      while !::lBreak .and. !::oDbfArt:Eof()

         if ( ::oDbfArt:nCtlStock != 3 )

            nPreMed           := ::oStock:nPrecioMedioCompra( ::oDbfArt:Codigo, ::oDbfAlm:cCodAlm, ::dIniInf, ::dFinInf, .t., ::lExcCero, ::lExcImp, ::aSer )
            nStkAlm           := ::oStock:nStockAlmacen( ::oDbfArt:Codigo, ::oDbfAlm:cCodAlm )

            ::oDbf:Append()

            ::oDbf:cCodAlm    := ::oDbfAlm:cCodAlm
            ::oDbf:cNomAlm    := ::oDbfAlm:cNomAlm
            ::oDbf:cCodArt    := ::oDbfArt:Codigo
            ::oDbf:cNomArt    := ::oDbfArt:Nombre
            ::oDbf:nTotStk    := nStkAlm
            ::oDbf:nPreStk    := nPreMed
            ::oDbf:nImpStk    := nStkAlm * nPreMed

            ::oDbf:Save()

         end if

         ::oDbfArt:Skip()

         ::oMtrInf:AutoInc( ::oDbfArt:OrdKeyNo() )
         ::oMtrInf:cText   := "Procesando almacén: " + ::oDbfAlm:cCodAlm

      end while

      ::oDbfAlm:Skip()

   end while

   ::oDbfAlm:IdxDelete( cCurUsr(), GetFileNoExt( ::oDbfAlm:cFile ) )
   ::oDbfArt:IdxDelete( cCurUsr(), GetFileNoExt( ::oDbfArt:cFile ) )

   ::oMtrInf:AutoInc( ::oDbfArt:LastRec() )

   ::oDlg:Enable()

   ::oBtnFilter:Disable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//