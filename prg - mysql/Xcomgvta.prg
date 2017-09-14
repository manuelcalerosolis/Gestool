#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS XComGVta FROM TInfGen

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
   DATA  oDbfFam     AS OBJECT
   DATA  oEstado     AS OBJECT

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

   METHOD nTotMovSal( cCodArt, cCodAlm )

   METHOD NewGroup()

   METHOD QuiGroup()

   END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField ( "cCodGrp", "C",  5, 0, {|| "@!" },         "Familia",          .f., "Familia",              8 )
   ::AddField ( "cNomGrp", "C", 50, 0, {|| "@!" },         "Nom. fam.",        .f., "Nombre familia",      40 )
   ::AddField ( "cCodArt", "C", 18, 0, {|| "@!" },         "Cód.",             .f., "Código artículo",      8 )
   ::AddField ( "cNomArt", "C",100, 0, {|| "@!" },         "Art.",             .f., "Descripción",         40 )
   ::AddField ( "cValPr1", "C", 20, 0, {|| "@!" },         "Prp. 1",           .f., "Propiedad 1",          6, .f. )
   ::AddField ( "cValPr2", "C", 20, 0, {|| "@!" },         "Prp. 2",           .f., "Propiedad 2",          6, .f. )
   ::AddField ( "cCodAlm", "C", 16, 0, {|| "@!" },         "Cod.",             .t., "Código almacén",       8 )
   ::AddField ( "cNomAlm", "C", 50, 0, {|| "@!" },         "Almacén.",         .t., "Nombre almacén",      40 )
   ::AddField ( "nUndCom", "N", 19, 6, {|| MasUnd() },     "Compras",          .t., "Compras",             13 )
   ::AddField ( "nUndVta", "N", 19, 6, {|| MasUnd() },     "Ventas",           .t., "Ventas",              13 )
   ::AddField ( "nUndMov", "N", 19, 6, {|| MasUnd() },     "Mov. alm.",        .t., "Moviemntos almacen",  13 )
   ::AddField ( "nNumUnd", "N", 19, 6, {|| MasUnd() },     "Stock",            .t., "Stock",               13 )

   ::AddTmpIndex ( "cCodArt", "cCodArt" )
   ::AddTmpIndex ( "cNomArt", "cNomArt" )

   ::AddGroup( {|| ::oDbf:cCodGrp },{|| "Grupo de familia : " + Rtrim( ::oDbf:cCodGrp ) + "-" + Rtrim( ::oDbf:cNomGrp ) }, {||"Total grupo de familia..."} )
   ::AddGroup( {|| ::oDbf:cCodGrp + ::oDbf:cCodArt },{|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oDbfArt ) ) }, {|| Space(1) } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

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

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL  PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"
   ::oFacCliL:OrdSetFocus( "cRef" )

   DATABASE NEW ::oFacRecT  PATH ( cPatEmp() ) FILE "FACRECT.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL  PATH ( cPatEmp() ) FILE "FACRECL.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"
   ::oFacRecL:OrdSetFocus( "cRef" )

   DATABASE NEW ::oTikCliT  PATH ( cPatEmp() ) FILE "TIKET.DBF" VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL  PATH ( cPatEmp() ) FILE "TIKEL.DBF" VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"
   ::oTikCliL:OrdSetFocus( "cCbaTil" )

   DATABASE NEW ::oHisMov  PATH ( cPatEmp() ) FILE "HisMov.DBF" VIA ( cDriver() ) SHARED INDEX "HisMov.CDX"
   ::oHisMov:OrdSetFocus( "cRefMov" )

   DATABASE NEW ::oDbfFam PATH ( cPatArt() ) FILE "FAMILIAS.DBF" VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbfFam ) .and. ::oDbfFam:Used()
      ::oDbfFam:End()
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

   ::oDbfFam  := nil
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

   ::lDefSerInf   := .f.
   ::lDefDivInf   := .f.

   if !::StdResource( "INFSTOCKC" )
      return .f.
   end if

   ::oBtnFilter:Disable()

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
      ID       200;
      OF       ::oFld:aDialogs[1]

   /*
   Monta grupos de familias
   */

   if !::oDefGrFInf( 150, 160, 170, 180, 700 )
      return .f.
   end if

   /*
   Monta resumen
   */

   ::oDefResInf()

   ::oDefExcInf( 210 )

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

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local nCompras  := 0
   local nVentas   := 0
   local nAlmacen  := 0
   local nFacRec   := 0
   local nEvery

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader   := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                     {|| "Periodo  : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Almacén  : " + AllTrim( ::cAlmOrg ) + " > " + AllTrim( ::cAlmDes ) },;
                     {|| "Artículo : " + AllTrim( ::cArtOrg ) + " > " + AllTrim( ::cArtDes ) },;
                     {|| "Grp.Fam. : " + AllTrim( ::cGruFamOrg ) + " > " + AllTrim( ::cGruFamDes ) } }

   ::oDbfAlm:GoTop()

   while !::lBreak .and. !::oDbfAlm:Eof()

      if !Empty( ::oDbfAlm:cCodAlm )         .and.;
         ( ::lAllAlm .or. ( ::oDbfAlm:cCodAlm >= ::cAlmOrg .AND. ::oDbfAlm:cCodAlm <= ::cAlmDes ) )

         ::oDbfArt:GoTop()

         ::oMtrInf:SetTotal( ::oDbfArt:Lastrec() )
         nEvery            := Int( ::oMtrInf:nTotal / 10 )
         ::oMtrInf:cText   := "Procesando"

            while !::lBreak .and. !::oDbfArt:Eof()

               if ( ::lAllArt .or. ( ::oDbfArt:Codigo >= ::cArtOrg .AND. ::oDbfArt:Codigo <= ::cArtDes ) ) .and.;
                  ( ::oDbfArt:nCtlStock != 3 )                                                             .and.;
                  ( ::lAllGrp .or. ( cCodGruFam( ::oDbfArt:Codigo, ::oDbfArt, ::oDbfFam )>= ::cGruFamOrg .AND. cCodGruFam( ::oDbfArt:Codigo, ::oDbfArt, ::oDbfFam )<= ::cGruFamDes ) )

                  //Recogida de totales

                  nCompras += ::nTotAlbPrv( ::oDbfArt:Codigo, ::oDbfAlm:cCodAlm )
                  nCompras += ::nTotFacPrv( ::oDbfArt:Codigo, ::oDbfAlm:cCodAlm )

                  nVentas  += ::nTotAlbCli( ::oDbfArt:Codigo, ::oDbfAlm:cCodAlm )
                  nVentas  += ::nTotFacCli( ::oDbfArt:Codigo, ::oDbfAlm:cCodAlm )
                  nVentas  += ::nTotTikCli( ::oDbfArt:Codigo, ::oDbfAlm:cCodAlm )

                  nAlmacen += ::nTotMovEnt( ::oDbfArt:Codigo, ::oDbfAlm:cCodAlm )
                  nAlmacen -= ::nTotMovSal( ::oDbfArt:Codigo, ::oDbfAlm:cCodAlm )

                  nFacRec  += ::nTotFacRec( ::oDbfArt:Codigo, ::oDbfAlm:cCodAlm )

                  //Añadimos registros

                  if !( ::lExcCero .AND. ( nCompras - nVentas + nAlmacen + nFacRec ) == 0 )

                     ::oDbf:Append()

                     ::oDbf:cCodGrp := cCodGruFam( ::oDbfArt:Codigo, ::oDbfArt, ::oDbfFam )
                     ::oDbf:cNomGrp := oRetFld( ::oDbf:cCodGrp, ::oGruFam:oDbf )
                     ::oDbf:cCodArt := ::oDbfArt:Codigo
                     ::oDbf:cNomArt := ::oDbfArt:Nombre
                     ::oDbf:cCodAlm := ::oDbfAlm:cCodAlm
                     ::oDbf:cNomAlm := Rtrim( oRetFld( ::oDbf:cCodAlm, ::oDbfAlm ) )
                     ::oDbf:nUndCom := nCompras
                     ::oDbf:nUndVta := nVentas - nFacRec
                     ::oDbf:nUndMov := nAlmacen
                     ::oDbf:nNumUnd := nCompras - nVentas + nAlmacen + nFacRec

                     ::oDbf:Save()

                  end if

                  nCompras  := 0
                  nVentas   := 0
                  nAlmacen  := 0
                  nFacRec   := 0

               end if

               ::oDbfArt:Skip()

               ::oMtrInf:AutoInc()

            end while

         ::oMtrInf:Set( ::oDbfArt:LastRec() )

      end if

      ::oDbfAlm:Skip()

   end while

   ::oDlg:Enable()

   ::oBtnFilter:Disable()

   ::oDbf:OrdSetFocus( ::oEstado:nAt )

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD nTotAlbPrv( cCodArt, cCodAlm )

   local nTotal  := 0

   if ::oAlbPrvL:Seek( cCodArt )

      while ::oAlbPrvL:cRef == cCodArt .and. !::oAlbPrvL:Eof()

         if ::oAlbPrvT:Seek( ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb ) .AND.;
            !::oAlbPrvT:lFacturado                                                                 .AND.;
            ::oAlbPrvT:dFecAlb >= ::dIniInf                                                        .AND.;
            ::oAlbPrvT:dFecAlb <= ::dFinInf                                                        .AND.;
            !Empty( ::oAlbPrvL:cAlmLin ) .and. ::oAlbPrvL:cAlmLin == cCodAlm

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
            !Empty( ::oFacPrvL:cAlmLin ) .and. ::oFacPrvL:cAlmLin == cCodAlm

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
            !Empty( ::oAlbCliL:cAlmLin ) .and. ::oAlbCliL:cAlmLin == cCodAlm

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
            !Empty( ::oFacCliL:cAlmLin ) .and. ::oFacCliL:cAlmLin == cCodAlm

            nTotal += nTotNFacCli( ::oFacCliL )

         end if

         ::oFacCliL:Skip()

      end while

   end if

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nTotFacRec( cCodArt, cCodAlm )

   local nTotal  := 0

   if ::oFacRecL:Seek( cCodArt )

      while ::oFacRecL:cRef == cCodArt .and. !::oFacRecL:Eof()

         if ::oFacRecT:Seek( ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac ) .AND.;
            ::oFacRecT:dFecFac >= ::dIniInf                                                       .AND.;
            ::oFacRecT:dFecFac <= ::dFinInf                                                       .AND.;
            !Empty( ::oFacRecL:cAlmLin ) .and. ::oFacRecL:cAlmLin == cCodAlm

            nTotal += nTotNFacRec( ::oFacRecL )

         end if

         ::oFacRecL:Skip()

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
            !Empty( ::oTikCliL:cAlmLin ) .and. ::oTikCliL:cAlmLin == cCodAlm

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
            !Empty( ::oTikCliL:cAlmLin ) .and. ::oTikCliL:cAlmLin == cCodAlm

            nTotal += ::oTikCliL:nUntTil

         end if

         ::oTikCliL:Skip()

      end while

   end if

   ::oTikCliL:OrdSetFocus( "cCbaTil" )

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nTotMovEnt( cCodArt, cCodAlm )

   local nTotal  := 0

   if ::oHisMov:Seek( cCodArt )

      while ::oHisMov:cRefMov == cCodArt .and. !::oHisMov:Eof()

         if ::oHisMov:dFecMov >= ::dIniInf              .AND.;
            ::oHisMov:dFecMov <= ::dFinInf              .AND.;
            !Empty( ::oHisMov:cAliMov ) .and. ::oHisMov:cAliMov == cCodAlm .and.;
            !::oHisMov:lNoStk

            nTotal += nTotNMovAlm( ::oHisMov )

         end if

         ::oHisMov:Skip()

      end while

   end if

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nTotMovSal( cCodArt, cCodAlm )

   local nTotal  := 0

   if ::oHisMov:Seek( cCodArt )

      while ::oHisMov:cRefMov == cCodArt .and. !::oHisMov:Eof()

         if ::oHisMov:dFecMov >= ::dIniInf              .AND.;
            ::oHisMov:dFecMov <= ::dFinInf              .AND.;
            !Empty( ::oHisMov:cAloMov ) .and. ::oHisMov:cAloMov == cCodAlm .and.;
            !::oHisMov:lNoStk

            nTotal += nTotNMovAlm( ::oHisMov )

         end if

         ::oHisMov:Skip()

      end while

   end if

RETURN ( nTotal )

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