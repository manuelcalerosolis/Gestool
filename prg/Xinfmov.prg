#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS XInfMov FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lDesPrp     AS LOGIC    INIT .f.
   DATA  nEstado     AS NUMERIC  INIT 1
   DATA  oAlbPrvT    AS OBJECT
   DATA  oAlbPrvL    AS OBJECT
   DATA  oFacPrvT    AS OBJECT
   DATA  oFacPrvL    AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT
   DATA  oProCab     AS OBJECT
   DATA  oProLin     AS OBJECT
   DATA  oProMat     AS OBJECT
   DATA  oDbfArt     AS OBJECT
   DATA  oDbfFam     AS OBJECT
   DATA  oEstado     AS OBJECT
   DATA  aEstado     AS ARRAY    INIT { "Precios de costo medio", "Ultimo precio costo", "Precio 1", "Precio 2", "Precio 3", "Precio 4", "Precio 5", "Precio 6" }
   DATA  cEstado                 INIT "Ultimo precio costo"

   DATA  lAlbPrv                 INIT .t.
   DATA  lFacPrv                 INIT .t.
   DATA  lAlbCli                 INIT .t.
   DATA  lFacCli                 INIT .t.
   DATA  lFacRec                 INIT .t.
   DATA  lTikCli                 INIT .t.
   DATA  lMovAlm                 INIT .t.

   DATA  lUniAlm                 INIT .f.

   METHOD FldCreate()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD CreaSaldo()

   METHOD NewGroup()

   METHOD QuiGroup()

   METHOD nRetPrecio()

   METHOD AddAlbPrv()

   METHOD AddFacPrv()

   METHOD AddAlbCli()

   METHOD AddFacCli()

   METHOD AddFacRec()

   METHOD AddTikCli( cRet )

   METHOD AddSal()

   METHOD AddEnt()

   METHOD AddProLin()

   METHOD AddProMat()

END CLASS

//---------------------------------------------------------------------------//

METHOD FldCreate()

   ::AddField( "dFecMov", "D",  8, 0, {|| "@!" },          "Fecha",         .t., "Fecha",                    10, .f. )
   ::AddField( "cTimMov", "C",  5, 0, {|| "@!" },          "Hora",          .f., "Hora",                      5, .f. )
   ::AddField( "cCodArt", "C", 18, 0, {|| "@!" },          "Código artículo",     .f., "Código artículo",          14, .f. )
   ::AddField( "cNomArt", "C",100, 0, {|| "@!" },          "Artículo",      .f., "Nombre artículo",          35, .f. )

   ::FldPropiedades()

   ::AddField( "cCodAlm", "C", 16, 0, {|| "@!" },          "Alm.",          .t., "Código almacen",            3, .f. )
   ::AddField( "cCodCli", "C", 12, 0, {|| "@!" },          "Cod.",          .t., "Código cliente",            9, .f. )
   ::AddField( "cNomCli", "C", 50, 0, {|| "@!" },          "Cli. - Prv.",   .t., "Cliente-Proveedor",        35, .f. )

   ::AddField( "nCajEnt", "N", 16, 6, {|| MasUnd() },      "Caj.Com.",      .f., "Cajas compra",             10, .t. )
   ::AddField( "nUndEnt", "N", 16, 6, {|| MasUnd() },      "Und.Com.",      .f., "Unidades compra",          10, .t. )
   ::AddField( "nTotEnt", "N", 16, 6, {|| MasUnd() },      "Tot.Com.",      .t., "Total compra",             10, .t. )
   ::AddField( "nPreEnt", "N", 16, 6, {|| ::cPicCom },     "Pre.Com.",      .t., "Precio compra",            10, .t. )
   ::AddField( "nImpEnt", "N", 16, 6, {|| ::cPicIn },      "Imp.Com.",      .t., "Importe compra",           10, .t. )

   ::AddField( "nCajSal", "N", 16, 6, {|| MasUnd() },      "Caj.Vta.",      .f., "Cajas venta",              10, .t. )
   ::AddField( "nUndSal", "N", 16, 6, {|| MasUnd() },      "Und.Vta.",      .f., "Unidades venta",           10, .t. )
   ::AddField( "nTotSal", "N", 16, 6, {|| MasUnd() },      "Tot.Vta.",      .t., "Total venta",              10, .t. )
   ::AddField( "nPreSal", "N", 16, 6, {|| ::cPicImp },     "Pre.Vta.",      .t., "Precio venta",             10, .t. )
   ::AddField( "nImpSal", "N", 16, 6, {|| ::cPicOut },     "Imp.Vta.",      .t., "Importe venta",            10, .t. )

   ::AddField( "nTotStk", "N", 16, 6, {|| MasUnd() },      "Tot.Stk.",      .t., "Total stock",              10, .f. )
   ::AddField( "nPreStk", "N", 16, 6, {|| ::cPicImp },     "Pre.Stk.",      .t., "Precio stock",             10, .t. )
   ::AddField( "nImpStk", "N", 16, 6, {|| ::cPicOut },     "Imp.Stk.",      .t., "Total stock",              10, .t. )

   ::AddField( "cDocMov", "C", 14, 0, {|| "@!" },          "Documento",     .t., "Documento",                10, .f. )
   ::AddField( "cTipDoc", "C", 14, 0, {|| "@!" },          "Tipo",          .t., "Tipo",                     14, .f. )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oAlbPrvT PATH ( cPatEmp() ) FILE "ALBPROVT.DBF"    VIA ( cDriver() ) SHARED INDEX "ALBPROVT.CDX"
   ::oAlbPrvT:OrdSetFocus( "dFecAlb" )

   DATABASE NEW ::oAlbPrvL PATH ( cPatEmp() ) FILE "ALBPROVL.DBF"    VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"

   DATABASE NEW ::oFacPrvT PATH ( cPatEmp() ) FILE "FACPRVT.DBF"     VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"
   ::oFacPrvT:OrdSetFocus( "dFecFac" )

   DATABASE NEW ::oFacPrvL PATH ( cPatEmp() ) FILE "FACPRVL.DBF"     VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"

   ::oAlbCliT := TDataCenter():oAlbCliT()
   ::oAlbCliT:OrdSetFocus( "dFecAlb" )

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "ALBCLIL.DBF"     VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   ::oFacCliT     := TDataCenter():oFacCliT()
   ::oFacCliT:OrdSetFocus( "dFecFac" )

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF"     VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oFacRecT PATH ( cPatEmp() ) FILE "FACRECT.DBF"     VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"
   ::oFacRecT:OrdSetFocus( "dFecFac" )

   DATABASE NEW ::oFacRecL PATH ( cPatEmp() ) FILE "FACRECL.DBF"     VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) FILE "TIKET.DBF"       VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"
   ::oTikCliT:OrdSetFocus( "dFecTik" )

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) FILE "TIKEL.DBF"       VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oDbfFam  PATH ( cPatArt() ) FILE "FAMILIAS.DBF"    VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

   DATABASE NEW ::oProCab  PATH ( cPatEmp() ) FILE "PROCAB.DBF"      VIA ( cDriver() ) SHARED INDEX "PROCAB.CDX"
   ::oProCab:OrdSetFocus( "dFecOrd" )

   DATABASE NEW ::oProLin  PATH ( cPatEmp() ) FILE "PROLIN.DBF"      VIA ( cDriver() ) SHARED INDEX "PROLIN.CDX"

   DATABASE NEW ::oProMat  PATH ( cPatEmp() ) FILE "PROMAT.DBF"      VIA ( cDriver() ) SHARED INDEX "PROMAT.CDX"

   DATABASE NEW ::oDbfArt  PATH ( cPatArt() ) FILE "ARTICULO.DBF"    VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   DATABASE NEW ::oDbfFam  PATH ( cPatArt() ) FILE "FAMILIAS.DBF"    VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

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
   if !Empty( ::oDbfFam ) .and. ::oDbfFam:Used()
      ::oDbfFam:End()
   end if
   if !Empty( ::oProCab ) .and. ::oProCab:Used()
      ::oProCab:End()
   end if
   if !Empty( ::oProLin ) .and. ::oProLin:Used()
      ::oProLin:End()
   end if
   if !Empty( ::oProMat ) .and. ::oProMat:Used()
      ::oProMat:End()
   end if
   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if
   if !Empty( ::oDbfFam ) .and. ::oDbfFam:Used()
      ::oDbfFam:End()
   end if

   ::oAlbPrvT := nil
   ::oAlbPrvL := nil
   ::oFacPrvT := nil
   ::oFacPrvL := nil
   ::oAlbCliT := nil
   ::oAlbCliL := nil
   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oFacRecT := nil
   ::oFacRecL := nil
   ::oTikCliT := nil
   ::oTikCliL := nil
   ::oDbfFam  := nil
   ::oProCab  := nil
   ::oProLin  := nil
   ::oProMat  := nil
   ::oDbfArt  := nil
   ::oDbfFam  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CreaSaldo()

// Esto es para crear los saldos-----------------------------------------------

   local nEvery
   local cCodArt
   local cCodAlm
   local nSalAnt        := 0
   local nImpAnt        := 0

   ::oDbf:GoTop()

   ::oMtrInf:SetTotal( ::oDbf:Lastrec() )
   nEvery               := Int( ::oMtrInf:nTotal / 10 )

   while !::oDbf:eof()

      if ::oDbf:nTotSal != 0
         ::oDbf:Load()
         ::oDbf:nPreSal := nImpAnt / nSalAnt
         ::oDbf:nImpSal := ::oDbf:nTotSal * ::oDbf:nPreSal
         ::oDbf:Save()
      end if

      cCodArt           := ::oDbf:cCodArt
      cCodAlm           := ::oDbf:cCodAlm
      nSalAnt           := ::oDbf:nTotEnt - ::oDbf:nTotSal + nSalAnt
      nImpAnt           := ::oDbf:nImpEnt - ::oDbf:nImpSal + nImpAnt

      ::oDbf:Load()
      ::oDbf:nTotStk    := nSalAnt
      ::oDbf:nImpStk    := nImpAnt
      ::oDbf:nPreStk    := nImpAnt * nSalAnt
      ::oDbf:Save()

      ::oDbf:Skip()

      if ::oDbf:cCodAlm != cCodAlm .or. ::oDbf:cCodArt != cCodArt
         nSalAnt        := 0
         nImpAnt        := 0
      end if

      ::oMtrInf:AutoInc()

   end while

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD NewGroup()

   if ::lDesPrp
      ::AddGroup( {|| ::oDbf:cValPr1 + ::oDbf:cValPr2 }, {|| "Propiedades : " + Rtrim( ::oDbf:cValPr1 ) + "-" + Rtrim( ::oDbf:cValPr2 ) } )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD QuiGroup()

   if ::lDesPrp
      ::DelGroup()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD nRetPrecio( cCodArt, cCodAlm )

	local nPreMed 	:= 0

   do case
   case ::cEstado == "Precios de costo medio"
      if ::lUniAlm
         nPreMed := nPreMedCom( cCodArt, nil, ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nValDiv, ::nDecOut, ::nDerOut )
      else
         nPreMed := nPreMedCom( cCodArt, cCodAlm, ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nValDiv, ::nDecOut, ::nDerOut )
      end if
   case ::cEstado == "Ultimo precio costo"
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

METHOD AddAlbPrv()

   ::oDbf:Append()
   ::oDbf:Blank()

   ::oDbf:cCodCli := ::oAlbPrvT:cCodPrv
   ::oDbf:cNomCli := ::oAlbPrvT:cNomPrv
   ::oDbf:dFecMov := ::oAlbPrvT:dFecAlb
   ::oDbf:cTimMov := ::oAlbPrvT:cTimChg

   ::oDbf:cCodAlm := ::oAlbPrvL:cAlmLin

   ::oDbf:cCodArt := ::oAlbPrvL:cRef
   ::oDbf:cNomArt := ::oAlbPrvL:cDetalle
   ::oDbf:cCodPr1 := ::oAlbPrvL:cCodPr1
   ::oDbf:cNomPr1 := retProp( ::oAlbPrvL:cCodPr1 )
   ::oDbf:cCodPr2 := ::oAlbPrvL:cCodPr2
   ::oDbf:cNomPr2 := retProp( ::oAlbPrvL:cCodPr2 )
   ::oDbf:cValPr1 := ::oAlbPrvL:cValPr1
   ::oDbf:cNomVl1 := RetValProp( ::oAlbPrvL:cCodPr1 + ::oAlbPrvL:cValPr1 )
   ::oDbf:cValPr2 := ::oAlbPrvL:cValPr2
   ::oDbf:cNomVl2 := RetValProp( ::oAlbPrvL:cCodPr2 + ::oAlbPrvL:cValPr2 )

   ::oDbf:nCajEnt := ::oAlbPrvL:nCanEnt
   ::oDbf:nUndEnt := ::oAlbPrvL:nUniCaja
   ::oDbf:nTotEnt := nTotNAlbPrv( ::oAlbPrvL )
   ::oDbf:nPreEnt := nTotUAlbPrv( ::oAlbPrvL, ::nDecIn )
   ::oDbf:nImpEnt := nTotLAlbPrv( ::oAlbPrvL, ::nDecIn, ::nDerIn )

   ::oDbf:cTipDoc := "Alb. Prv."
   ::oDbf:cDocMov := ::oAlbPrvL:cSerAlb + "/" + AllTrim( Str( ::oAlbPrvL:nNumAlb ) ) + "/" + ::oAlbPrvL:cSufAlb

   ::oDbf:Save()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddFacPrv()

   ::oDbf:Append()
   ::oDbf:Blank()

   ::oDbf:cCodCli := ::oFacPrvT:cCodPrv
   ::oDbf:cNomCli := ::oFacPrvT:cNomPrv
   ::oDbf:dFecMov := ::oFacPrvT:dFecFac
   ::oDbf:cTimMov := ::oFacPrvT:cTimChg

   ::oDbf:cCodAlm := ::oFacPrvL:cAlmLin

   ::oDbf:cCodArt := ::oFacPrvL:cRef
   ::oDbf:cNomArt := ::oFacPrvL:cDetalle
   ::oDbf:cCodPr1 := ::oFacPrvL:cCodPr1
   ::oDbf:cNomPr1 := RetProp( ::oFacPrvL:cCodPr1 )
   ::oDbf:cCodPr2 := ::oFacPrvL:cCodPr2
   ::oDbf:cNomPr2 := RetProp( ::oFacPrvL:cCodPr2 )
   ::oDbf:cValPr1 := ::oFacPrvL:cValPr1
   ::oDbf:cNomVl1 := RetValProp( ::oFacPrvL:cCodPr1 + ::oFacPrvL:cValPr1 )
   ::oDbf:cValPr2 := ::oFacPrvL:cValPr2
   ::oDbf:cNomVl2 := RetValProp( ::oFacPrvL:cCodPr2 + ::oFacPrvL:cValPr2 )

   ::oDbf:nCajEnt := ::oFacPrvL:nCanEnt
   ::oDbf:nUndEnt := ::oFacPrvL:nUniCaja
   ::oDbf:nTotEnt := nTotNFacPrv( ::oFacPrvL )
   ::oDbf:nPreEnt := nTotUFacPrv( ::oFacPrvL, ::nDecIn )
   ::oDbf:nImpEnt := nTotLFacPrv( ::oFacPrvL, ::nDecIn, ::nDerIn )

   ::oDbf:cTipDoc := "Fac. Prv."
   ::oDbf:cDocMov := ::oFacPrvL:cSerFac + "/" + AllTrim( Str( ::oFacPrvL:nNumFac ) ) + "/" + ::oFacPrvL:cSufFac

   ::oDbf:Save()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddAlbCli()

   ::oDbf:Append()
   ::oDbf:Blank()

   ::oDbf:cCodCli := ::oAlbCliT:cCodCli
   ::oDbf:cNomCli := ::oAlbCliT:cNomCli
   ::oDbf:dFecMov := ::oAlbCliT:dFecAlb
   ::oDbf:cTimMov := ::oAlbCliT:cTimCre

   ::oDbf:cCodAlm := ::oAlbCliL:cAlmLin

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

   ::oDbf:nCajSal := ::oAlbCliL:nCanEnt
   ::oDbf:nUndSal := ::oAlbCliL:nUniCaja
   ::oDbf:nTotSal := nTotNAlbCli( ::oAlbCliL )
   ::oDbf:nPreSal := nTotUAlbCli( ::oAlbCliL, ::nDecOut )
   ::oDbf:nImpSal := nTotLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )

   ::oDbf:cTipDoc := "Alb. Cli."
   ::oDbf:cDocMov := ::oAlbCliL:cSerAlb + "/" + AllTrim( Str( ::oAlbCliL:nNumAlb ) ) + "/" + ::oAlbCliL:cSufAlb

   ::oDbf:Save()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddFacCli()

   ::oDbf:Append()
   ::oDbf:Blank()

   ::oDbf:cCodCli := ::oFacCliT:cCodCli
   ::oDbf:cNomCli := ::oFacCliT:cNomCli
   ::oDbf:dFecMov := ::oFacCliT:dFecFac
   ::oDbf:cTimMov := ::oFacCliT:cTimCre

   ::oDbf:cCodAlm := ::oFacCliL:cAlmLin
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

   ::oDbf:nCajSal := ::oFacCliL:nCanEnt
   ::oDbf:nUndSal := ::oFacCliL:nUniCaja
   ::oDbf:nTotSal := nTotNFacCli( ::oFacCliL:cAlias )
   ::oDbf:nPreSal := nTotUFacCli( ::oFacCliL:cAlias, ::nDecOut )
   ::oDbf:nImpSal := nTotLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )

   ::oDbf:cTipDoc := "Fac. Cli."
   ::oDbf:cDocMov := ::oFacCliL:cSerie + "/" + AllTrim( Str( ::oFacCliL:nNumFac ) ) + "/" + ::oFacCliL:cSufFac

   ::oDbf:Save()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddFacRec()

   ::oDbf:Append()
   ::oDbf:Blank()

   ::oDbf:cCodCli := ::oFacRecT:cCodCli
   ::oDbf:cNomCli := ::oFacRecT:cNomCli

   ::oDbf:dFecMov := ::oFacRecT:dFecFac
   ::oDbf:cTimMov := ::oFacRecT:cTimCre

   ::oDbf:cCodAlm := ::oFacRecL:cAlmLin
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

   ::oDbf:nCajSal := -( ::oFacRecL:nCanEnt )
   ::oDbf:nUndSal := -( ::oFacRecL:nUniCaja )
   ::oDbf:nTotSal := -( nTotNFacRec( ::oFacRecL:cAlias ) )
   ::oDbf:nPreSal := -( nTotUFacRec( ::oFacRecL:cAlias, ::nDecOut ) )
   ::oDbf:nImpSal := -( nTotLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut ) )

   ::oDbf:cTipDoc := "Fac. Rec."
   ::oDbf:cDocMov := ::oFacRecL:cSerie + "/" + AllTrim( Str( ::oFacRecL:nNumFac ) ) + "/" + ::oFacRecL:cSufFac

   ::oDbf:Save()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddTikCli( cRet )

   ::oDbf:Append()
   ::oDbf:Blank()

   ::oDbf:cCodCli := ::oTikClit:cCliTik
   ::oDbf:cCodAlm := ::oTikClit:cAlmTik
   ::oDbf:cNomCli := ::oTikClit:cNomTik

   ::oDbf:dFecMov := ::oTikClit:dFecTik
   ::oDbf:cTimMov := ::oTikCliT:cHorTik

   ::oDbf:cCodArt := cRet
   ::oDbf:cDocMov := ::oTikClit:cSerTik + "/" + AllTrim( ::oTikClit:cNumTik ) + "/" + ::oTikClit:cSufTik
   ::oDbf:cTipDoc := "Tiket"

   ::oDbf:cCodPr1 := ::oTikCliL:cCodPr1
   ::oDbf:cNomPr1 := retProp( ::oTikCliL:cCodPr1 )
   ::oDbf:cCodPr2 := ::oTikCliL:cCodPr2
   ::oDbf:cNomPr2 := retProp( ::oTikCliL:cCodPr2 )
   ::oDbf:cValPr1 := ::oTikCliL:cValPr1
   ::oDbf:cNomVl1 := retValProp( ::oTikCliL:cCodPr1 + ::oTikCliL:cValPr1 )
   ::oDbf:cValPr2 := ::oTikCliL:cValPr2
   ::oDbf:cNomVl2 := retValProp( ::oTikCliL:cCodPr2 + ::oTikCliL:cValPr2 )

   if ::oTikCliT:cTipTik == "4"
   ::oDbf:nUndEnt := ::oTikCliL:nUntTil
   ::oDbf:nTotEnt := ::oTikCliL:nUntTil
   ::oDbf:nPreEnt := nTotLTpv( ::oTikCliL, ::nDecOut, ::nDerOut )
   else
   ::oDbf:nUndSal := ::oTikCliL:nUntTil
   ::oDbf:nTotSal := ::oTikCliL:nUntTil
   ::oDbf:nPreSal := nTotLTpv( ::oTikCliL, ::nDecOut, ::nDerOut )
   end if

   ::oDbf:Save()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddSal()

   ::oDbf:Append()
   ::oDbf:Blank()

   ::oDbf:cCodCli := ""
   ::oDbf:cCodAlm := ::oHisMov:cAloMov
   ::oDbf:cNomCli := "Movimientos entre almacenes"

   ::oDbf:dFecMov := ::oHisMov:dFecMov
   ::oDbf:cTimMov := ::oHisMov:cTimMov

   ::oDbf:cCodArt := ::oHisMov:cRefMov
   ::oDbf:cCodPr1 := ::oHisMov:cCodPr1
   ::oDbf:cNomPr1 := retProp( ::oHisMov:cCodPr1 )
   ::oDbf:cCodPr2 := ::oHisMov:cCodPr2
   ::oDbf:cNomPr2 := retProp( ::oHisMov:cCodPr2 )
   ::oDbf:cValPr1 := ::oHisMov:cValPr1
   ::oDbf:cNomVl1 := retValProp( ::oHisMov:cCodPr1 + ::oHisMov:cValPr1 )
   ::oDbf:cValPr2 := ::oHisMov:cValPr2
   ::oDbf:cNomVl2 := retValProp( ::oHisMov:cCodPr2 + ::oHisMov:cValPr2 )

   if nTotNMovAlm( ::oHisMov ) > 0
      ::oDbf:nCajSal := ::oHisMov:nCajMov
      ::oDbf:nUndSal := ::oHisMov:nUndMov
      ::oDbf:nTotSal := nTotNMovAlm( ::oHisMov )
      ::oDbf:nPreSal := ::oHisMov:nPreDiv
      ::oDbf:nImpSal := nTotLMovAlm( ::oHisMov )
   else
      ::oDbf:nCajEnt := Abs( ::oHisMov:nCajMov )
      ::oDbf:nUndEnt := Abs( ::oHisMov:nUndMov )
      ::oDbf:nTotEnt := Abs( nTotNMovAlm( ::oHisMov ) )
      ::oDbf:nPreEnt := Abs( ::oHisMov:nPreDiv )
      ::oDbf:nImpEnt := Abs( nTotLMovAlm( ::oHisMov ) )
   end if

   ::oDbf:cDocMov := Str( ::oHisMov:nNumRem ) + "/" + ::oHisMov:cSufRem
   ::oDbf:cTipDoc := "Sal. Almacen"

   ::oDbf:Save()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddEnt()

   ::oDbf:Append()
   ::oDbf:Blank()

   ::oDbf:cCodCli := ""
   ::oDbf:cCodAlm := ::oHisMov:cAliMov
   ::oDbf:cNomCli := "Movimientos entre almacenes"

   ::oDbf:dFecMov := ::oHisMov:dFecMov
   ::oDbf:cTimMov := ::oHisMov:cTimMov

   ::oDbf:cCodArt := ::oHisMov:cRefMov
   ::oDbf:cCodPr1 := ::oHisMov:cCodPr1
   ::oDbf:cNomPr1 := retProp( ::oHisMov:cCodPr1 )
   ::oDbf:cCodPr2 := ::oHisMov:cCodPr2
   ::oDbf:cNomPr2 := retProp( ::oHisMov:cCodPr2 )
   ::oDbf:cValPr1 := ::oHisMov:cValPr1
   ::oDbf:cNomVl1 := retValProp( ::oHisMov:cCodPr1 + ::oHisMov:cValPr1 )
   ::oDbf:cValPr2 := ::oHisMov:cValPr2
   ::oDbf:cNomVl2 := retValProp( ::oHisMov:cCodPr2 + ::oHisMov:cValPr2 )

   if nTotNMovAlm( ::oHisMov ) > 0
      ::oDbf:nCajEnt := ::oHisMov:nCajMov
      ::oDbf:nUndEnt := ::oHisMov:nUndMov
      ::oDbf:nTotEnt := nTotNMovAlm( ::oHisMov )
      ::oDbf:nPreEnt := ::oHisMov:nPreDiv
      ::oDbf:nImpEnt := nTotLMovAlm( ::oHisMov )
   else
      ::oDbf:nCajSal := Abs( ::oHisMov:nCajMov )
      ::oDbf:nUndSal := Abs( ::oHisMov:nUndMov )
      ::oDbf:nTotSal := Abs( nTotNMovAlm( ::oHisMov ) )
      ::oDbf:nPreSal := Abs( ::oHisMov:nPreDiv )
      ::oDbf:nImpSal := Abs( nTotLMovAlm( ::oHisMov ) )
   end if

   ::oDbf:cDocMov := Str( ::oHisMov:nNumRem ) + "/" + ::oHisMov:cSufRem
   ::oDbf:cTipDoc := "Ent. Almacen"

   ::oDbf:Save()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddProLin()

   ::oDbf:Append()
   ::oDbf:Blank()

   ::oDbf:cNomCli := "Producido"

   ::oDbf:dFecMov := ::oProCab:dFecOrd
   ::oDbf:cTimMov := ::oProCab:cHorIni

   ::oDbf:cCodAlm := ::oProLin:cAlmOrd

   ::oDbf:cCodArt := ::oProLin:cCodArt
   ::oDbf:cNomArt := ::oProLin:cNomArt
   ::oDbf:cCodPr1 := ::oProLin:cCodPr1
   ::oDbf:cNomPr1 := retProp( ::oProLin:cCodPr1 )
   ::oDbf:cCodPr2 := ::oProLin:cCodPr2
   ::oDbf:cNomPr2 := retProp( ::oProLin:cCodPr2 )
   ::oDbf:cValPr1 := ::oProLin:cValPr1
   ::oDbf:cNomVl1 := retValProp( ::oProLin:cCodPr1 + ::oProLin:cValPr1 )
   ::oDbf:cValPr2 := ::oProLin:cValPr2
   ::oDbf:cNomVl2 := retValProp( ::oProLin:cCodPr2 + ::oProLin:cValPr2 )

   ::oDbf:nCajEnt := ::oProLin:nCajOrd
   ::oDbf:nUndEnt := ::oProLin:nUndOrd
   ::oDbf:nTotEnt := nTotNProduccion( ::oProLin )
   ::oDbf:nPreEnt := ::oProLin:nImpOrd
   ::oDbf:nImpEnt := nTotNProduccion( ::oProLin ) * ::oProLin:nImpOrd

   ::oDbf:cTipDoc := "Producido"
   ::oDbf:cDocMov := ::oProCab:cSerOrd + "/" + AllTrim( Str( ::oProCab:nNumOrd ) ) + "/" + ::oProCab:cSufOrd

   ::oDbf:Save()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddProMat()

   ::oDbf:Append()
   ::oDbf:Blank()

   ::oDbf:cNomCli := "Consumido"

   ::oDbf:dFecMov := ::oProCab:dFecOrd
   ::oDbf:cTimMov := ::oProCab:cHorIni

   ::oDbf:cCodAlm := ::oProMat:cAlmOrd

   ::oDbf:cCodArt := ::oProMat:cCodArt
   ::oDbf:cNomArt := ::oProMat:cNomArt
   ::oDbf:cCodPr1 := ::oProMat:cCodPr1
   ::oDbf:cNomPr1 := retProp( ::oProMat:cCodPr1 )
   ::oDbf:cCodPr2 := ::oProMat:cCodPr2
   ::oDbf:cNomPr2 := retProp( ::oProMat:cCodPr2 )
   ::oDbf:cValPr1 := ::oProMat:cValPr1
   ::oDbf:cNomVl1 := retValProp( ::oProMat:cCodPr1 + ::oProMat:cValPr1 )
   ::oDbf:cValPr2 := ::oProMat:cValPr2
   ::oDbf:cNomVl2 := retValProp( ::oProMat:cCodPr2 + ::oProMat:cValPr2 )

   ::oDbf:nCajSal := ::oProMat:nCajOrd
   ::oDbf:nUndSal := ::oProMat:nUndOrd
   ::oDbf:nTotSal := nTotNMaterial( ::oProMat )
   ::oDbf:nPreSal := ::oProMat:nImpOrd
   ::oDbf:nImpSal := nTotNMaterial( ::oProMat ) * ::oProMat:nImpOrd

   ::oDbf:cTipDoc := "Consumido"
   ::oDbf:cDocMov := ::oProCab:cSerOrd + "/" + AllTrim( Str( ::oProCab:nNumOrd ) ) + "/" + ::oProCab:cSufOrd

   ::oDbf:Save()

RETURN ( Self )

//---------------------------------------------------------------------------//