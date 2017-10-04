#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfTikoStkA FROM TInfGen

   DATA  oAlmacen    AS OBJECT
   DATA  oDbfFam     AS OBJECT
   DATA  oStock      AS OBJECT
   DATA  oEstado     AS OBJECT
   DATA  oAlbPrvT
   DATA  oAlbPrvL
   DATA  oFacPrvT
   DATA  oFacPrvL
   DATA  oAlbCliT
   DATA  oAlbCliL
   DATA  oFacCliT
   DATA  oFacCliL
   DATA  oTikCliT
   DATA  oTikCliL
   DATA  oPedCliR
   DATA  oHisMov
   DATA  oDbfArt     AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( lImpTik )

   METHOD lGenerate()

   METHOD oDefIniInf() VIRTUAL

   METHOD oDefFinInf() VIRTUAL

   METHOD oDefDivInf() VIRTUAL

   METHOD nTotAlbPrv( cCodArt, cCodAlm )

   METHOD nTotFacPrv( cCodArt, cCodAlm )

   METHOD nTotAlbCli( cCodArt, cCodAlm )

   METHOD nTotFacCli( cCodArt, cCodAlm )

   METHOD nTotTikCli( cCodArt, cCodAlm )

   METHOD nTotMovEnt( cCodArt, cCodAlm )

   METHOD nTotMovSal( cCodArt, cCodAlm )

   METHOD nTotReserva( cCodArt )

   METHOD PrnTiket( lPrev )

   END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodAlm", "C", 16, 0, {|| "@!" },            "Cod. alm.",     .f., "Código almacén",      3 )
   ::AddField( "cCodArt", "C", 18, 0, {|| "@!" },            "Código",        .t., "Código artículo",     8 )
   ::AddField( "cDesArt", "C", 20, 0, {|| "@!" },            "Des. breve",    .t., "Descripción breve",   40)
   ::AddField( "cNomArt", "C",100, 0, {|| "@!" },            "Descripción",   .f., "Descripción",         40)
   ::AddField( "nNumUnd", "N", 19, 6, {|| MasUnd() },        "Stock",         .t., "Stock",               13)
   ::AddField( "nStkCmp", "N", 19, 6, {|| MasUnd() },        "Stock comp.",   .f., "Stock comprometido",  13)
   ::AddField( "nStkLib", "N", 19, 6, {|| MasUnd() },        "Stock libre",   .f., "Stock libre",         13)

   if ::xOthers
   ::AddTmpIndex( "cDesArt", "cCodAlm + cDesArt" )
   else
   ::AddTmpIndex( "cNomArt", "cCodAlm + cNomArt" )
   end if
   ::AddTmpIndex( "cCodArt", "cCodAlm + cCodArt" )

   ::AddGroup( {|| ::oDbf:cCodAlm }, {|| "Almacén : " + Rtrim( ::oDbf:cCodAlm ) + "-" + oRetFld( ::oDbf:cCodAlm, ::oDbfAlm ) }, {||"Total almacén..."} )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

    /*
   Ficheros necesarios
   */

   BEGIN SEQUENCE

   DATABASE NEW ::oAlbPrvT  PATH ( cPatEmp() ) FILE "ALBPROVT.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVT.CDX"

   DATABASE NEW ::oAlbPrvL  PATH ( cPatEmp() ) FILE "ALBPROVL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"
   ::oAlbPrvL:OrdSetFocus( "cRef" )

   DATABASE NEW ::oFacPrvT  PATH ( cPatEmp() ) FILE "FACPRVT.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"

   DATABASE NEW ::oFacPrvL  PATH ( cPatEmp() ) FILE "FACPRVL.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"
   ::oFacPrvL:OrdSetFocus( "cRef" )

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL  PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"
   ::oAlbCliL:OrdSetFocus( "cRef" )

   DATABASE NEW ::oPedCliR  PATH ( cPatEmp() ) FILE "PEDCLIR.DBF" VIA ( cDriver() ) SHARED INDEX "PEDCLIR.CDX"
   ::oPedCliR:OrdSetFocus( "cRef" )

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL  PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"
   ::oFacCliL:OrdSetFocus( "cRef" )

   DATABASE NEW ::oTikCliT  PATH ( cPatEmp() ) FILE "TikeT.DBF" VIA ( cDriver() ) SHARED INDEX "TikeT.CDX"

   DATABASE NEW ::oTikCliL  PATH ( cPatEmp() ) FILE "TikeL.DBF" VIA ( cDriver() ) SHARED INDEX "TikeL.CDX"
   ::oTikCliL:OrdSetFocus( "cCbaTil" )

   DATABASE NEW ::oHisMov  PATH ( cPatEmp() ) FILE "HisMov.DBF" VIA ( cDriver() ) SHARED INDEX "HisMov.CDX"
   ::oHisMov:OrdSetFocus( "cRefMov" )

   DATABASE NEW ::oDbfArt PATH ( cPatArt() )  FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   DATABASE NEW ::oDbfFam PATH ( cPatArt() ) FILE "FAMILIAS.DBF" VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

   ::oStock          := TStock():Create()
   if !::oStock:lOpenFiles()
      lOpen          := .t.
   end if

   RECOVER

      lOpen          := .f.
      msgStop( "Imposible abrir todas las bases de datos" )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpen
      ::CloseFiles()
   end if

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbfFam ) .and. ::oDbfFam:Used()
      ::oDbfFam:End()
   end if

   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   if !Empty( ::oAlbPrvT) .and. ::oAlbPrvT:Used()
      ::oAlbPrvT:End()
   end if

   if !Empty( ::oAlbPrvL) .and. ::oAlbPrvL:Used()
      ::oAlbPrvL:End()
   end if

   if !Empty( ::oFacPrvT) .and. ::oFacPrvT:Used()
      ::oFacPrvT:End()
   end if

   if !Empty( ::oFacPrvL) .and. ::oFacPrvL:Used()
      ::oFacPrvL:End()
   end if

   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if

   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if

   if !Empty( ::oPedCliR ) .and. ::oPedCliR:Used()
      ::oPedCliR:End()
   end if

   if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if

   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if

   if !Empty( ::oTikCliL ) .and. ::oTikCliL:Used()
      ::oTikCliL:End()
   end if

   if !Empty( ::oHisMov ) .and. ::oHisMov:Used()
      ::oHisMov:End()
   end if

   if !Empty( ::oStock ) .and. ::oStock:Used()
      ::oStock:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource()

   local cEstado  := "Nombre"

   ::lDefSerInf   := .f.

   if !::StdResource( "INF_GEN03C" )
      return .f.
   end if

   /*
   Monta los almacenes de manera automatica
   */

   ::oDefAlmInf( 70, 80, 90, 100 )

   /*
   Monta los proveedores de manera automatica
   */

   ::lDefArtInf( 110, 120, 130, 140 )

   /*
   Ordenado por
   */

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    { "Nombre", "Código" } ;
      OF       ::oFld:aDialogs[1]

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oDbfAlm:Lastrec() )

   if ::xOthers

      /*
      Los botones no hacen lo mismo
      */

      ::oBtnPreview:bAction   := {|| if( ::lGenerate(), ::PrnTiket( .t. ), msgStop( "No hay registros en las condiciones solictadas" ) ) }
      ::oBtnPrint:bAction     := {|| if( ::lGenerate(), ::PrnTiket( .f. ), msgStop( "No hay registros en las condiciones solictadas" ) ) }

   end if

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local bValid   := {|| .t. }
   local lExcCero := .f.
   local nCompras := 0
   local nVentas  := 0
   local nAlmacen := 0

   ::oDlg:Disable()

   ::oDbf:Zap()

   ::oMtrInf:SetTotal( ::oDbfArt:Lastrec() )

   ::oDbfAlm:Seek( ::cAlmOrg )

   ::aHeader      := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                        {|| "Almacén   : " + AllTrim( ::cAlmOrg ) + " > " + AllTrim( ::cAlmDes ) },;
                        {|| "Artículos : " + AllTrim( ::cArtOrg ) + " > " + AllTrim( ::cArtDes ) } }

   ::oDbf:OrdSetFocus( ::oEstado:nAt )
   ::oDbf:GoTop()

   while ::oDbfAlm:cCodAlm >= ::cAlmOrg .AND. ::oDbfAlm:cCodAlm <= ::cAlmDes .AND. !::oDbfAlm:Eof()

      if ::oDbfArt:Seek( ::cArtOrg, .t. )

         while ::oDbfArt:Codigo <= ::cArtDes .AND. !::oDbfArt:Eof()

         if ::oDbfArt:NCTLSTOCK == 1

            //Recogida de totales

            nCompras += ::nTotAlbPrv( ::oDbfArt:Codigo, ::oDbfAlm:cCodAlm )
            nCompras += ::nTotFacPrv( ::oDbfArt:Codigo, ::oDbfAlm:cCodAlm )

            nVentas  += ::nTotAlbCli( ::oDbfArt:Codigo, ::oDbfAlm:cCodAlm )
            nVentas  += ::nTotFacCli( ::oDbfArt:Codigo, ::oDbfAlm:cCodAlm )
            nVentas  += ::nTotTikCli( ::oDbfArt:Codigo, ::oDbfAlm:cCodAlm )

            nAlmacen += ::nTotMovEnt( ::oDbfArt:Codigo, ::oDbfAlm:cCodAlm )
            nAlmacen -= ::nTotMovSal( ::oDbfArt:Codigo, ::oDbfAlm:cCodAlm )

            //Añadimos registros

            msginfo( trans( nCompras, "9999999999.9999" ), "compras" )
            msginfo( trans( nVentas,  "9999999999.9999" ), "ventas"   )
            msginfo( trans( nAlmacen, "9999999999.9999" ), "almacen" )

            ::oDbf:Append()

            ::oDbf:cCodAlm := ::oDbfAlm:cCodAlm
            ::oDbf:cCodArt := ::oDbfArt:Codigo
            ::oDbf:cNomArt := ::oDbfArt:Nombre
            ::oDbf:cDesArt := if( Empty( ::oDbfArt:cDesTik ), ::oDbfArt:Nombre, ::oDbfArt:cDesTik )
            ::oDbf:nNumUnd := nCompras - nVentas + nAlmacen
            ::oDbf:nStkCmp := ::nTotReserva( ::oDbfArt:Codigo )
            ::oDbf:nStkLib := ::oDbf:nNumUnd - ::oDbf:nStkCmp

            ::oDbf:Save()

         end if

         ::oDbfArt:Skip()
         ::oMtrInf:AutoInc( ::oDbfArt:OrdKeyNo() )

      end while

      ::oDbfAlm:Skip()

      end if

   end while

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD PrnTiket( lPrev )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD nTotAlbPrv( cCodArt, cCodAlm )

   local nTotal  := 0

   if ::oAlbPrvL:Seek( cCodArt )

      while ::oAlbPrvL:cRef == cCodArt .and. !::oAlbPrvL:Eof()

         if ::oAlbPrvT:Seek( ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb ) .AND.;
            !::oAlbPrvT:lFacturado                                                                 .AND.;
            ::oAlbPrvT:dFecAlb >= ::dIniInf                                                        .AND.;
            ::oAlbPrvT:dFecAlb <= ::dFinInf                                                        .AND.;
            ::oAlbPrvL:cAlmLin == cCodAlm

            nTotal += nTotNAlbPrv( ::oAlbPrvL )

         end if

         ::oAlbPrvL:Skip()

      end while

   end if

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nTotFacPrv( cCodArt, cCodAlm )

   local nTotal  := 0

   if ::oFacPrvL:Seek( cCodArt )

      while ::oFacPrvL:cRef == cCodArt .and. !::oFacPrvL:Eof()

         if ::oFacPrvT:Seek( ::oFacPrvL:cSerFac + Str( ::oFacPrvL:nNumFac ) + ::oFacPrvL:cSufFac ) .AND.;
            ::oFacPrvT:dFecFac >= ::dIniInf                                                        .AND.;
            ::oFacPrvT:dFecFac <= ::dFinInf                                                        .AND.;
            ::oFacPrvL:cAlmLin == cCodAlm

            nTotal += nTotNFacPrv( ::oFacPrvL )

         end if

         ::oFacPrvL:Skip()

      end while

   end if

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nTotAlbCli( cCodArt, cCodAlm )

   local nTotal  := 0

   if ::oAlbCliL:Seek( cCodArt )

      while ::oAlbCliL:cRef == cCodArt .and. !::oAlbCliL:Eof()

         if ::oAlbCliT:Seek( ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb ) .AND.;
            !lFacturado( ::oAlbCliT )                                                              .AND.;
            ::oAlbCliT:dFecAlb >= ::dIniInf                                                        .AND.;
            ::oAlbCliT:dFecAlb <= ::dFinInf                                                        .AND.;
            ::oAlbCliL:cAlmLin == cCodAlm

            nTotal += nTotNAlbCli( ::oAlbCliL )

         end if

         ::oAlbCliL:Skip()

      end while

   end if

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nTotFacCli( cCodArt, cCodAlm )

   local nTotal  := 0

   if ::oFacCliL:Seek( cCodArt )

      while ::oFacCliL:cRef == cCodArt .and. !::oFacCliL:Eof()

         if ::oFacCliT:Seek( ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac ) .AND.;
            ::oFacCliT:dFecFac >= ::dIniInf                                                       .AND.;
            ::oFacCliT:dFecFac <= ::dFinInf                                                       .AND.;
            ::oFacCliL:cAlmLin == cCodAlm

            nTotal += nTotNFacCli( ::oFacCliL )

         end if

         ::oFacCliL:Skip()

      end while

   end if

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nTotTikCli( cCodArt, cCodAlm )

   local nTotal  := 0

   if ::oTikCliL:Seek( cCodArt )
      while ::oTikCliL:cCbaTil == cCodArt .and. !::oTikCliL:Eof()

         if ::oTikCliT:Seek( ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil ) .AND.;
            ::oTikCliT:dFecTik >= ::dIniInf                                                 .AND.;
            ::oTikCliT:dFecTik <= ::dFinInf                                                 .AND.;
            ::oTikCliL:cAlmLin == cCodAlm

            nTotal += ::oTikCliL:nUntTil

         end if

         ::oTikCliL:Skip()

      end while

   end if

   ::oTikCliL:OrdSetFocus( "cComTil" )

   if ::oTikCliL:Seek( cCodArt )

      while ::oTikCliL:cComTil == cCodArt .and. !::oTikCliL:Eof()

         if ::oTikCliT:Seek( ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil ) .AND.;
            ::oTikCliT:dFecTik >= ::dIniInf                                                 .AND.;
            ::oTikCliT:dFecTik <= ::dFinInf                                                 .AND.;
            ::oTikCliL:cAlmLin == cCodAlm

            nTotal += ::oTikCliL:nUntTil

         end if

         ::oTikCliL:Skip()

      end while

   end if

   ::oTikCliL:OrdSetFocus( "cCbaTil" )

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nTotMovSal( cCodArt, cCodAlm )

   local nTotal  := 0

   if ::oHisMov:Seek( cCodArt )

      while ::oHisMov:cRefMov == cCodArt .and. !::oHisMov:Eof()

         if ::oHisMov:dFecMov >= ::dIniInf              .AND.;
            ::oHisMov:dFecMov <= ::dFinInf              .AND.;
            ::oHisMov:cAliMov == cCodAlm                .AND.;
            !::oHisMov:lNoStk

            nTotal += nTotNMovAlm( ::oHisMov )

         end if

         ::oHisMov:Skip()

      end while

   end if

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nTotMovEnt( cCodArt, cCodAlm )

   local nTotal  := 0

   if ::oHisMov:Seek( cCodArt )

      while ::oHisMov:cRefMov == cCodArt .and. !::oHisMov:Eof()

         if ::oHisMov:dFecMov >= ::dIniInf              .AND.;
            ::oHisMov:dFecMov <= ::dFinInf              .AND.;
            ::oHisMov:cAloMov == cCodAlm                .AND.;
            !::oHisMov:lNoStk

            nTotal += nTotNMovAlm( ::oHisMov )

         end if

         ::oHisMov:Skip()

      end while

   end if

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nTotReserva( cCodArt )

   local nTotal  := 0

   if ::oPedCliR:Seek( cCodArt )

      while ::oPedCliR:cRef == cCodArt .and. !::oPedCliR:Eof()

         nTotal += nUnidadesReservadasEnPedidosCliente( ::oPedCliR:cSerPed + Str( ::oPedCliR:nNumPed ) + ::oPedCliR:cSufPed, ::oPedCliR:cRef, ::oPedCliR:cValPr1, ::oPedCliR:cValPr2, ::oPedCliR:cAlias )

      ::oPedCliR:Skip()

      end while

   end if

RETURN ( nTotal )

//---------------------------------------------------------------------------//