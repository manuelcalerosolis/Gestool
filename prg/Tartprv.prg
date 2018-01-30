#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TArtPrv FROM TInfGen

   DATA oStock    AS OBJECT
   DATA oPedPrvL  AS OBJECT
   DATA oAlbPrvL  AS OBJECT
   DATA oFacPrvL  AS OBJECT
   DATA oRctPrvL  AS OBJECT
   DATA oPedCliL  AS OBJECT
   DATA oAlbCliL  AS OBJECT
   DATA oFacCliL  AS OBJECT
   DATA oFacRecL  AS OBJECT
   DATA oTikCliL  AS OBJECT
   DATA oProLin   AS OBJECT
   DATA oProMat   AS OBJECT

   METHOD create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodPrv", "C", 12, 0, {|| "@!" },             "Prv.",           .f., "Cod. Proveedor",             9, .f. )
   ::AddField( "cNomPrv", "C", 50, 0, {|| "@!" },             "Proveedor",      .f., "Nombre Proveedor",          35, .f. )
   ::AddField( "cCodArt", "C", 18, 0, {|| "@!" },             "Cod. artículo",  .t., "Código artículo",           14, .f. )
   ::AddField( "cNomArt", "C",100, 0, {|| "@!" },             "Descripción",    .t., "Descripción",               40, .f. )
   ::AddField( "Stock",   "N", 19, 6, {|| MasUnd() },         "Stock",          .t., "Stock",                     13, .f. )
   ::AddField( "nCosArt", "N", 16, 6, {|| ::cPicOut },        "Costo",          .t., "Costo",                     14, .f. )
   ::AddField( "nImp1",   "N", 16, 6, {|| ::cPicImp },        "Pre. 1",         .t., "Precio 1",                  14, .f. )
   ::AddField( "nIva1",   "N", 16, 6, {|| ::cPicImp },        "Pre. 1 " + cImp(),     .t., "Precio 1 " + cImp() + " incluido",  14, .f. )
   ::AddField( "nImp2",   "N", 16, 6, {|| ::cPicImp },        "Pre. 2",         .f., "Precio 2",                  14, .f. )
   ::AddField( "nIva2",   "N", 16, 6, {|| ::cPicImp },        "Pre. 2 " + cImp(),     .f., "Precio 2 " + cImp() + " incluido",  14, .f. )
   ::AddField( "nImp3",   "N", 16, 6, {|| ::cPicImp },        "Pre. 3",         .f., "Precio 3",                  14, .f. )
   ::AddField( "nIva3",   "N", 16, 6, {|| ::cPicImp },        "Pre. 3 " + cImp(),     .f., "Precio 3 " + cImp() + " incluido",  14, .f. )
   ::AddField( "nImp4",   "N", 16, 6, {|| ::cPicImp },        "Pre. 4",         .f., "Precio 4",                  14, .f. )
   ::AddField( "nIva4",   "N", 16, 6, {|| ::cPicImp },        "Pre. 4 " + cImp(),     .f., "Precio 4 " + cImp() + " incluido",  14, .f. )
   ::AddField( "nImp5",   "N", 16, 6, {|| ::cPicImp },        "Pre. 5",         .f., "Precio 5",                  14, .f. )
   ::AddField( "nIva5",   "N", 16, 6, {|| ::cPicImp },        "Pre. 5 " + cImp(),     .f., "Precio 5 " + cImp() + " incluido",  14, .f. )
   ::AddField( "nImp6",   "N", 16, 6, {|| ::cPicImp },        "Pre. 6",         .f., "Precio 6",                  14, .f. )
   ::AddField( "nIva6",   "N", 16, 6, {|| ::cPicImp },        "Pre. 6 " + cImp(),     .f., "Precio 6 " + cImp() + " incluido",  14, .f. )

   ::AddTmpIndex( "CCODPRV", "CCODPRV" )

   ::AddGroup( {|| ::oDbf:cCodPrv }, {|| "Proveedor  : " + Rtrim( ::oDbf:cCodPrv ) + "-" + Rtrim( ::oDbf:cNomPrv ) }, {||"Total proveedor..."} )

   ::lDefFecInf   := .f.
   ::lDefSerInf   := .f.

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   DATABASE NEW ::oPedPrvL PATH ( cPatEmp() )   FILE "PEDPROVL.DBF"   VIA ( cDriver() ) SHARED INDEX "PEDPROVL.CDX"

   DATABASE NEW ::oAlbPrvL PATH ( cPatEmp() )   FILE "ALBPROVL.DBF"   VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"

   DATABASE NEW ::oFacPrvL PATH ( cPatEmp() )   FILE "FACPRVL.DBF"    VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"

   DATABASE NEW ::oRctPrvL PATH ( cPatEmp() )   FILE "RctPrvL.DBF"    VIA ( cDriver() ) SHARED INDEX "RctPrvL.CDX"

   DATABASE NEW ::oPedCliL PATH ( cPatEmp() )   FILE "PEDCLIL.DBF"    VIA ( cDriver() ) SHARED INDEX "PEDCLIL.CDX"

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() )   FILE "ALBCLIL.DBF"    VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() )   FILE "FACCLIL.DBF"    VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oFacRecL PATH ( cPatEmp() )   FILE "FACRECL.DBF"    VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() )   FILE "TIKEL.DBF"      VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oProLin  PATH ( cPatEmp() )   FILE "PROLIN.DBF"     VIA ( cDriver() ) SHARED INDEX "PROLIN.CDX"

   DATABASE NEW ::oProMat  PATH ( cPatEmp() )   FILE "PROMAT.DBF"     VIA ( cDriver() ) SHARED INDEX "PROMAT.CDX"

   ::oStock   := TStock():Create( cPatEmp() )

   if !::oStock:lOpenFiles()
      return .f.
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oPedPrvL ) .and. ::oPedPrvL:Used()
      ::oPedPrvL:End()
   end if

   if !Empty( ::oAlbPrvL ) .and. ::oAlbPrvL:Used()
      ::oAlbPrvL:End()
   end if

   if !Empty( ::oFacPrvL ) .and. ::oFacPrvL:Used()
      ::oFacPrvL:End()
   end if

   if !Empty( ::oRctPrvL ) .and. ::oRctPrvL:Used()
      ::oRctPrvL:End()
   end if

   if !Empty( ::oPedCliL ) .and. ::oPedCliL:Used()
      ::oPedCliL:End()
   end if

   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if

   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if

   if !Empty( ::oFacRecL ) .and. ::oFacRecL:Used()
      ::oFacRecL:End()
   end if

   if !Empty( ::oTikCliL ) .and. ::oTikCliL:Used()
      ::oTikCliL:End()
   end if

   if !Empty( ::oProLin ) .and. ::oProLin:Used()
      ::oProLin:End()
   end if

   if !Empty( ::oProMat ) .and. ::oProMat:Used()
      ::oProMat:End()
   end if

   if !Empty( ::oStock )
      ::oStock:End()
   end if

   ::oPedPrvL := nil
   ::oPedCliL := nil
   ::oStock   := nil
   ::oAlbPrvL := nil
   ::oFacPrvL := nil
   ::oAlbCliL := nil
   ::oFacCliL := nil
   ::oFacRecL := nil
   ::oTikCliL := nil
   ::oProLin  := nil
   ::oProMat  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource ( cFld )

   if !::StdResource( "TARTPRV" )
      return .f.
   end if

   /*
   Monta los almacenes de manera automatica
   */

   if !::oDefPrvInf( 70, 80, 90, 100, 600 )
      return .f.
   end if

   if !::lDefArtInf( 110, 120, 130, 140, 700 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oDbfArt:Lastrec() )

   ::CreateFilter( aItmArt(), ::oDbfArt:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                        {|| "Periodo   : " + Dtoc( ::dIniInf )    + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Artículo  : " + if ( ::lAllArt, "Todos", AllTrim( ::cArtOrg ) + " > " + AllTrim( ::cArtDes ) ) },;
                        {|| "Proveedor : " + if ( ::lAllPrv, "Todos", AllTrim( ::cPrvOrg ) + " > " + AllTrim( ::cPrvDes ) ) } }

   ::oDbfArt:OrdSetFocus( "Codigo" )

   if !::lAllArt
      cExpHead       := 'Codigo >= "' + Rtrim( ::cArtOrg ) + '" .and. Codigo <= "' + Rtrim( ::cArtDes ) + '"'
   else
      cExpHead       := '.t.'
   end if

   if !::lAllPrv
      cExpHead       += ' .and. cPrvHab >= "' + Rtrim( ::cPrvOrg ) + '" .and. cPrvHab <= "' + Rtrim( ::cPrvDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oDbfArt:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oDbfArt:cFile ), ::oDbfArt:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oDbfArt:OrdKeyCount() )

   ::oDbfArt:GoTop()

   while !::lBreak .and. !::oDbfArt:Eof()

      ::oDbf:Append()

      ::oDbf:cCodPrv  := ::oDbfArt:cPrvHab
      ::oDbf:cNomPrv  := oRetFld( ::oDbfArt:cPrvHab, ::oDbfPrv )
      ::oDbf:cCodArt  := ::oDbfArt:Codigo
      ::oDbf:cNomArt  := ::oDbfArt:Nombre
      ::oDbf:nCosArt  := ::oDbfArt:pCosto
      ::oDbf:nImp1    := ::oDbfArt:pVenta1
      ::oDbf:nIva1    := ::oDbfArt:pVtaIva1
      ::oDbf:nImp2    := ::oDbfArt:pVenta2
      ::oDbf:nIva2    := ::oDbfArt:pVtaIva2
      ::oDbf:nImp3    := ::oDbfArt:pVenta3
      ::oDbf:nIva3    := ::oDbfArt:pVtaIva3
      ::oDbf:nImp4    := ::oDbfArt:pVenta4
      ::oDbf:nIva4    := ::oDbfArt:pVtaIva4
      ::oDbf:nImp5    := ::oDbfArt:pVenta5
      ::oDbf:nIva5    := ::oDbfArt:pVtaIva5
      ::oDbf:nImp6    := ::oDbfArt:pVenta6
      ::oDbf:nIva6    := ::oDbfArt:pVtaIva6
      ::oDbf:Stock    := ::oStock:nStockAlmacen( ::oDbfArt:Codigo )

      ::oDbf:Save()

      ::oDbfArt:Skip()

      ::oMtrInf:AutoInc( ::oDbfArt:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oDbfArt:Lastrec() )

   ::oDbfArt:IdxDelete( cCurUsr(), GetFileNoExt( ::oDbfArt:cFile ) )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//