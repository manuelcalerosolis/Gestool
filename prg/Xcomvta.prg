#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS XComVta FROM TInfGen

   DATA  lDesPrp     AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oAlbPrvT
   DATA  oAlbPrvL
   DATA  oFacPrvT
   DATA  oFacPrvL
   DATA  oAlbCliT
   DATA  oAlbCliL
   DATA  oFacCliT
   DATA  oFacCliL
   DATA  oFacRecT
   DATA  oFacRecL
   DATA  oTikCliT
   DATA  oTikCliL
   DATA  oHisMov
   DATA  oEstado     AS OBJECT

   DATA  nCajCompras
   DATA  nUndCompras
   DATA  nTotCompras

   DATA  nCajVentas
   DATA  nUndVentas
   DATA  nTotVentas

   DATA  nCajAlmacen
   DATA  nUndAlmacen
   DATA  nTotAlmacen

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource()

   METHOD lGenerate()

   METHOD nTotAlbPrv( cCodArt, cCodAlm )

   METHOD nTotFacPrv( cCodArt, cCodAlm )

   METHOD nTotAlbCli( cCodArt, cCodAlm )

   METHOD nTotFacCli( cCodArt, cCodAlm )

   METHOD nTotFacRec( cCodArt, cCodAlm )

   METHOD nTotTikCli( cCodArt, cCodAlm )

   METHOD nTotMovEnt( cCodArt, cCodAlm )

   METHOD NewGroup()

   METHOD QuiGroup()

   END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField ( "cCodArt", "C", 18, 0, {|| "@!" },         "Cód.",             .f., "Código artículo",      8 )
   ::AddField ( "cNomArt", "C",100, 0, {|| "@!" },         "Art.",             .f., "Descripción",         40 )
   ::AddField ( "cValPr1", "C", 20, 0, {|| "@!" },         "Prp. 1",           .f., "Propiedad 1",          6, .f. )
   ::AddField ( "cValPr2", "C", 20, 0, {|| "@!" },         "Prp. 2",           .f., "Propiedad 2",          6, .f. )
   ::AddField ( "cCodAlm", "C", 16, 0, {|| "@!" },         "Cod.",             .t., "Código almacén",       8 )
   ::AddField ( "cNomAlm", "C", 50, 0, {|| "@!" },         "Almacén.",         .t., "Nombre almacén",      40 )
   ::AddField ( "nCajCom", "N", 19, 6, {|| MasUnd() },     "Compras " + cNombreCajas(),         .f., "Compras " + cNombreCajas(),         13, .t. )
   ::AddField ( "nUndCom", "N", 19, 6, {|| MasUnd() },     "Compras " + cNombreUnidades(),      .f., "Compras " + cNombreUnidades(),      13, .t. )
   ::AddField ( "nTotCom", "N", 19, 6, {|| MasUnd() },     "Tot. compras " + cNombreUnidades(), .t., "Tot. compras " + cNombreUnidades(), 13 )
   ::AddField ( "nCajVta", "N", 19, 6, {|| MasUnd() },     "Ventas " + cNombreCajas(),          .f., "Ventas " + cNombreCajas(),          13, .t. )
   ::AddField ( "nUndVta", "N", 19, 6, {|| MasUnd() },     "Ventas " + cNombreUnidades(),       .f., "Ventas " + cNombreUnidades(),       13, .t. )
   ::AddField ( "nTotVta", "N", 19, 6, {|| MasUnd() },     "Tot. ventas " + cNombreUnidades(),  .t., "Tot. ventas " + cNombreUnidades(),  13 )
   ::AddField ( "nCajAlm", "N", 19, 6, {|| MasUnd() },     "Almacen " + cNombreCajas(),         .f., "Almacen " + cNombreCajas(),         13, .t. )
   ::AddField ( "nUndAlm", "N", 19, 6, {|| MasUnd() },     "Almacen " + cNombreUnidades(),      .f., "Ventas " + cNombreUnidades(),       13, .t. )
   ::AddField ( "nTotAlm", "N", 19, 6, {|| MasUnd() },     "Tot. almacen " + cNombreUnidades(), .t., "Tot. ventas " + cNombreUnidades(),  13 )
   ::AddField ( "nCajStk", "N", 19, 6, {|| MasUnd() },     "Stock " + cNombreCajas(),           .f., "Stock " + cNombreCajas(),           13 )
   ::AddField ( "nTotStk", "N", 19, 6, {|| MasUnd() },     "Stock " + cNombreUnidades(),        .t., "Stock " + cNombreUnidades(),        13 )

   ::AddTmpIndex ( "cCodArt", "cCodArt" )
   ::AddTmpIndex ( "cNomArt", "cNomArt" )

   ::AddGroup( {|| ::oDbf:cCodArt },{|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oDbfArt ) ) }, {|| Space(1) } )

   ::lDefSerInf   := .f.
   ::lDefDivInf   := .f.

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oAlbPrvT  PATH ( cPatEmp() ) FILE "ALBPROVT.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVT.CDX"

   DATABASE NEW ::oAlbPrvL  PATH ( cPatEmp() ) FILE "ALBPROVL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"
   ::oAlbPrvL:OrdSetFocus( "cRef" )

   DATABASE NEW ::oFacPrvT  PATH ( cPatEmp() ) FILE "FACPRVT.DBF"  VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"

   DATABASE NEW ::oFacPrvL  PATH ( cPatEmp() ) FILE "FACPRVL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"
   ::oFacPrvL:OrdSetFocus( "cRef" )

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL  PATH ( cPatEmp() ) FILE "ALBCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"
   ::oAlbCliL:OrdSetFocus( "cRef" )

   ::oFacCliT     := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL  PATH ( cPatEmp() ) FILE "FACCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"
   ::oFacCliL:OrdSetFocus( "cRef" )

   DATABASE NEW ::oFacRecT  PATH ( cPatEmp() ) FILE "FACRECT.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL  PATH ( cPatEmp() ) FILE "FACRECL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"
   ::oFacRecL:OrdSetFocus( "cRef" )

   DATABASE NEW ::oTikCliT  PATH ( cPatEmp() ) FILE "TIKET.DBF"    VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL  PATH ( cPatEmp() ) FILE "TIKEL.DBF"    VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"
   ::oTikCliL:OrdSetFocus( "cCbaTil" )

   DATABASE NEW ::oHisMov  PATH ( cPatEmp() ) FILE "HisMov.DBF" VIA ( cDriver() ) SHARED INDEX "HisMov.CDX"
   ::oHisMov:OrdSetFocus( "cRefMov" )

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
   if !Empty( ::oHisMov ) .and. ::oHisMov:Used()
      ::oHisMov:End()
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
   ::oHisMov  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource()

   local cEstado  := "Código"

   if !::StdResource( "INFSTOCK" )
      return .f.
   end if

   /*
   Monta los almacenes de manera automatica
   */

   if !::oDefAlmInf( 70, 80, 90, 100, 600 )
      return .f.
   end if

   /*
   Monta los proveedores de manera automatica
   */

   if !::lDefArtInf( 110, 120, 130, 140, 800 )
      return .f.
   end if

   REDEFINE CHECKBOX ::lDesPrp ;
      ID       180;
      OF       ::oFld:aDialogs[1]

   ::oDefResInf()

   ::oDefExcInf( 200 )

   /*
   Ordenado por
   */

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    { "Código", "Nombre" } ;
      OF       ::oFld:aDialogs[1]

   ::bPreGenerate    := {|| ::NewGroup() }
   ::bPostGenerate   := {|| ::QuiGroup() }

   ::CreateFilter( aItmArt(), ::oDbfArt:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local nEvery
   local cExpArt        := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                        {|| "Periodo  : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Almacén  : " + if( ::lAllAlm, "Todos", AllTrim( ::cAlmOrg ) + " > " + AllTrim( ::cAlmDes ) ) },;
                        {|| "Artículo : " + if( ::lAllArt, "Todos", AllTrim( ::cArtOrg ) + " > " + AllTrim( ::cArtDes ) ) } }

   ::oDbfArt:OrdSetFocus( "CODIGO" )

   if !Empty( ::oFilter:cExpresionFilter )
      cExpArt     := ::oFilter:cExpresionFilter
   else
      cExpArt     := ' .t. '
   end if

   ::oDbfArt:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oDbfArt:cFile ), ::oDbfArt:OrdKey(), ( cExpArt ), , , , , , , , .t. )

   ::oDbfAlm:GoTop()

   while !::lBreak .and. !::oDbfAlm:Eof()

      if !Empty( ::oDbfAlm:cCodAlm )                  .AND.;
         ( ::lAllAlm .or. ( ::oDbfAlm:cCodAlm >= ::cAlmOrg .AND. ::oDbfAlm:cCodAlm <= ::cAlmDes ) )

         ::oDbfArt:GoTop()

         ::oMtrInf:SetTotal( ::oDbfArt:Lastrec() )
         nEvery            := Int( ::oMtrInf:nTotal / 10 )
         ::oMtrInf:cText   := "Procesando"

         while !::lBreak .and. !::oDbfArt:Eof()

            ::nUndCompras  := 0
            ::nUndVentas   := 0
            ::nCajCompras  := 0
            ::nCajVentas   := 0
            ::nTotCompras  := 0
            ::nTotVentas   := 0
            ::nCajAlmacen  := 0
            ::nUndAlmacen  := 0
            ::nTotAlmacen  := 0

            if ( ::lAllArt .or. ( ::oDbfArt:Codigo >= ::cArtOrg .AND. ::oDbfArt:Codigo <= ::cArtDes ) ) .and.;
               ( ::oDbfArt:nCtlStock != 3 )

               //Recogida de totales

               ::nTotAlbPrv( ::oDbfArt:Codigo, ::oDbfAlm:cCodAlm )
               ::nTotFacPrv( ::oDbfArt:Codigo, ::oDbfAlm:cCodAlm )
               ::nTotFacRec( ::oDbfArt:Codigo, ::oDbfAlm:cCodAlm )

               ::nTotAlbCli( ::oDbfArt:Codigo, ::oDbfAlm:cCodAlm )
               ::nTotFacCli( ::oDbfArt:Codigo, ::oDbfAlm:cCodAlm )
               ::nTotTikCli( ::oDbfArt:Codigo, ::oDbfAlm:cCodAlm )

               ::nTotMovEnt( ::oDbfArt:Codigo, ::oDbfAlm:cCodAlm )

               //Añadimos registros

               if !( ::lExcCero .AND. ( ::nTotCompras - ::nTotVentas + ::nTotAlmacen ) == 0 )

                  ::oDbf:Append()

                  ::oDbf:cCodArt := ::oDbfArt:Codigo
                  ::oDbf:cNomArt := ::oDbfArt:Nombre
                  ::oDbf:cCodAlm := ::oDbfAlm:cCodAlm
                  ::oDbf:cNomAlm := Rtrim( oRetFld( ::oDbf:cCodAlm, ::oDbfAlm ) )

                  ::oDbf:nCajCom := ::nCajCompras
                  ::oDbf:nUndCom := ::nUndCompras
                  ::oDbf:nTotCom := ::nTotCompras

                  ::oDbf:nCajVta := ::nCajVentas
                  ::oDbf:nUndVta := ::nUndVentas
                  ::oDbf:nTotVta := ::nTotVentas

                  ::oDbf:nCajAlm := ::nCajAlmacen
                  ::oDbf:nUndAlm := ::nUndAlmacen
                  ::oDbf:nTotAlm := ::nTotAlmacen

                  ::oDbf:nCajStk := ::nCajCompras - ::nCajVentas + ::nCajAlmacen
                  ::oDbf:nTotStk := ::nTotCompras - ::nTotVentas + ::nTotAlmacen

                  ::oDbf:Save()

               end if

            end if

            ::oDbfArt:Skip()

            ::oMtrInf:AutoInc()

         end while

         ::oMtrInf:AutoInc( ::oDbfArt:LastRec() )

      end if

      ::oDbfAlm:Skip()

   end while

   ::oDbfArt:IdxDelete( cCurUsr(), GetFileNoExt( ::oDbfArt:cFile ) )

   ::oDlg:Enable()

   ::oDbf:OrdSetFocus( ::oEstado:nAt )

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD nTotAlbPrv( cCodArt, cCodAlm )

   if ::oAlbPrvL:Seek( cCodArt )

      while ::oAlbPrvL:cRef == cCodArt .and. !::oAlbPrvL:Eof()

         if ::oAlbPrvT:Seek( ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb ) .AND.;
            !::oAlbPrvT:lFacturado                                                                 .AND.;
            ::oAlbPrvT:dFecAlb >= ::dIniInf                                                        .AND.;
            ::oAlbPrvT:dFecAlb <= ::dFinInf                                                        .AND.;
            !Empty( ::oAlbPrvL:cAlmLin ) .and. ::oAlbPrvL:cAlmLin == cCodAlm

            ::nCajCompras  += ::oAlbPrvL:nCanEnt
            ::nUndCompras  += ::oAlbPrvL:nUniCaja
            ::nTotCompras  += nTotNAlbPrv( ::oAlbPrvL )

         end if

         ::oAlbPrvL:Skip()

      end while

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD nTotFacPrv( cCodArt, cCodAlm )

   if ::oFacPrvL:Seek( cCodArt )

      while ::oFacPrvL:cRef == cCodArt .and. !::oFacPrvL:Eof()

         if ::oFacPrvT:Seek( ::oFacPrvL:cSerFac + Str( ::oFacPrvL:nNumFac ) + ::oFacPrvL:cSufFac ) .AND.;
            ::oFacPrvT:dFecFac >= ::dIniInf                                                        .AND.;
            ::oFacPrvT:dFecFac <= ::dFinInf                                                        .AND.;
            !Empty( ::oFacPrvL:cAlmLin ) .and. ::oFacPrvL:cAlmLin == cCodAlm

            ::nCajCompras  += ::oFacPrvL:nCanEnt
            ::nUndCompras  += ::oFacPrvL:nUniCaja
            ::nTotCompras  += nTotNFacPrv( ::oFacPrvL )

         end if

         ::oFacPrvL:Skip()

      end while

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD nTotAlbCli( cCodArt, cCodAlm )

   if ::oAlbCliL:Seek( cCodArt )

      while ::oAlbCliL:cRef == cCodArt .and. !::oAlbCliL:Eof()

         if ::oAlbCliT:Seek( ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb ) .And.;
            !lFacturado( ::oAlbCliT )                                                              .And.;
            ::oAlbCliT:dFecAlb >= ::dIniInf                                                        .And.;
            ::oAlbCliT:dFecAlb <= ::dFinInf                                                        .And.;
            !Empty( ::oAlbCliL:cAlmLin )                                                           .And.;
            ::oAlbCliL:cAlmLin == cCodAlm

            ::nCajVentas   += ::oAlbCliL:nCanEnt
            ::nUndVentas   += ::oAlbCliL:nUniCaja
            ::nTotVentas   += nTotNAlbCli( ::oAlbCliL )

         end if

         ::oAlbCliL:Skip()

      end while

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD nTotFacCli( cCodArt, cCodAlm )

   if ::oFacCliL:Seek( cCodArt )

      while ::oFacCliL:cRef == cCodArt .and. !::oFacCliL:Eof()

         if ::oFacCliT:Seek( ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac )  .And.;
            ::oFacCliT:dFecFac >= ::dIniInf                                                        .And.;
            ::oFacCliT:dFecFac <= ::dFinInf                                                        .And.;
            !Empty( ::oFacCliL:cAlmLin )                                                           .And.;
            ::oFacCliL:cAlmLin == cCodAlm

            ::nCajVentas   += ::oFacCliL:nCanEnt
            ::nUndVentas   += ::oFacCliL:nUniCaja
            ::nTotVentas   += nTotNFacCli( ::oFacCliL )

         end if

         ::oFacCliL:Skip()

      end while

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD nTotFacRec( cCodArt, cCodAlm )

   if ::oFacRecL:Seek( cCodArt )

      while ::oFacRecL:cRef == cCodArt .and. !::oFacRecL:Eof()

         if ::oFacRecT:Seek( ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac )  .And.;
            ::oFacRecT:dFecFac >= ::dIniInf                                                        .And.;
            ::oFacRecT:dFecFac <= ::dFinInf                                                        .And.;
            !Empty( ::oFacRecL:cAlmLin )                                                           .And.;
            ::oFacRecL:cAlmLin == cCodAlm

            ::nCajCompras   += ::oFacRecL:nCanEnt
            ::nUndCompras   += ::oFacRecL:nUniCaja
            ::nTotCompras   += nTotNFacRec( ::oFacRecL )

         end if

         ::oFacRecL:Skip()

      end while

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD nTotTikCli( cCodArt, cCodAlm )

   if ::oTikCliL:Seek( cCodArt )
      while ::oTikCliL:cCbaTil == cCodArt .and. !::oTikCliL:Eof()

         if ::oTikCliT:Seek( ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil ) .AND.;
            ::oTikCliT:dFecTik >= ::dIniInf                                                 .AND.;
            ::oTikCliT:dFecTik <= ::dFinInf                                                 .AND.;
            !Empty( ::oTikCliL:cAlmLin ) .and. ::oTikCliL:cAlmLin == cCodAlm

            ::nUndVentas   += ::oTikCliL:nUntTil
            ::nTotVentas   += ::oTikCliL:nUntTil

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
            !Empty( ::oTikCliL:cAlmLin ) .and. ::oTikCliL:cAlmLin == cCodAlm

            ::nUndVentas   += ::oTikCliL:nUntTil
            ::nTotVentas   += ::oTikCliL:nUntTil

         end if

         ::oTikCliL:Skip()

      end while

   end if

   ::oTikCliL:OrdSetFocus( "cCbaTil" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD nTotMovEnt( cCodArt, cCodAlm )

   if ::oHisMov:Seek( cCodArt )

      while ::oHisMov:cRefMov == cCodArt .and. !::oHisMov:Eof()

         if ::oHisMov:dFecMov >= ::dIniInf                                    .and.;
            ::oHisMov:dFecMov <= ::dFinInf

            if !Empty( ::oHisMov:cAliMov ) .and. ::oHisMov:cAliMov == cCodAlm .and.;
               !::oHisMov:lNoStk

               ::nCajAlmacen  += ::oHisMov:nCajMov
               ::nUndAlmacen  += ::oHisMov:nUndMov
               ::nTotAlmacen  += nTotNMovAlm( ::oHisMov )

            end if

            if !Empty( ::oHisMov:cAloMov ) .and. ::oHisMov:cAloMov == cCodAlm .and.;
               !::oHisMov:lNoStk

               ::nCajAlmacen  -= ::oHisMov:nCajMov
               ::nUndAlmacen  -= ::oHisMov:nUndMov
               ::nTotAlmacen  -= nTotNMovAlm( ::oHisMov )

            end if

         end if

         ::oHisMov:Skip()

      end while

   end if

RETURN ( Self )

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