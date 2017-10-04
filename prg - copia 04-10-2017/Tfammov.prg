#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION TFamMov()

   local oInf
   local aCol  := {}
   local aIdx  := {}

   aAdd( aCol, { "CCODALM", "C", 16, 0, {|| "@!" },          "Cod. Almacen",  .f., "Código almacen"      ,  3 } )
   aAdd( aCol, { "CCODFAM", "C", 16, 0, {|| "@!" },          "Cod. familia",  .f., "Código familia"      ,  5 } )
   aAdd( aCol, { "CNOMFAM", "C", 50, 0, {|| "@!" },          "Familia",       .f., "Familia"             , 20 } )
   aAdd( aCol, { "CCODART", "C", 18, 0, {|| "@!" },          "Cod. Artículo", .f., "Código artículo"     , 10 } )
   aAdd( aCol, { "CNOMART", "C",100, 0, {|| "@!" },          "Descripción",   .f., "Descripción"         , 25 } )
   aAdd( aCol, { "CCODCLI", "C", 12, 0, {|| "@!" },          "Cod. Cliente",  .f., "Código cliente"      ,  8 } )
   aAdd( aCol, { "CNOMCLI", "C", 50, 0, {|| "@!" },          "Cliente",       .f., "Cliente"             , 25 } )
   aAdd( aCol, { "NCAJENT", "N", 16, 6, {|| MasUnd() },      "Caj. Ent.",     .f., "Cajas entrada."      ,  8 } )
   aAdd( aCol, { "NCAJSAL", "N", 16, 6, {|| MasUnd() },      "Caj. Sal.",     .f., "Cajas salida"        ,  8 } )
   aAdd( aCol, { "NSALCAJ", "N", 16, 6, {|| MasUnd() },      "Sal. Caj.",     .f., "Saldo cajas"         ,  8 } )
   aAdd( aCol, { "NUNTENT", "N", 16, 6, {|| MasUnd() },      "Und. Ent.",     .f., "Unidades entrada"    ,  8 } )
   aAdd( aCol, { "NUNTSAL", "N", 16, 6, {|| MasUnd() },      "Unds",          .t., "Unidades salientes"  ,  8 } )
   aAdd( aCol, { "NSALUNI", "N", 16, 6, {|| MasUnd() },      "Sal. Und.",     .f., "Saldo unidades"      , 10 } )
   aAdd( aCol, { "NVALORA", "N", 16, 6, {|| oInf:cPicOut },  "PVP",           .t., "Precio venta"        , 10 } )
   aAdd( aCol, { "NTOTDOC", "N", 16, 6, {|| oInf:cPicOut },  "Importe",       .t., "Total documento"     , 10 } )
   aAdd( aCol, { "CDOCMOV", "C", 14, 0, {|| "@!" },          "Documento",     .f., "Documento"           , 14 } )
   aAdd( aCol, { "CTIPDOC", "C", 14, 0, {|| "@!" },          "Tipo",          .f., "Tipo"                , 10 } )
   aAdd( aCol, { "DFECMOV", "D",  8, 0, {|| "@!" },          "Fecha",         .f., "Fecha"               ,  8 } )

   aAdd( aIdx, { "CCODALM", "CCODALM + CCODFAM" } )

   oInf  := TInfFamMov():New( "Informe detallado de tpv agrupado por familias", aCol, aIdx, "01045" )

   oInf:AddGroup( {|| oInf:oDbf:cCodAlm },                     {|| "Almacen : " + Rtrim( oInf:oDbf:cCodAlm ) + "-" + oRetFld( oInf:oDbf:cCodAlm, oInf:oDbfAlm ) }, {||"Total almacén..."} )
   oInf:AddGroup( {|| oInf:oDbf:cCodAlm + oInf:oDbf:cCodFam }, {|| "Familia : " + Rtrim( oInf:oDbf:cCodFam ) + "-" + oRetFld( oInf:oDbf:cCodFam, oInf:oDbfFam ) }, {||"Total familia..."} )

   oInf:Resource()
   oInf:Activate()

   oInf:End()

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TInfFamMov FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  nEstado     AS NUMERIC  INIT 1
   DATA  oAlbProvT   AS OBJECT
   DATA  oAlbProvL   AS OBJECT
   DATA  oFacProvT   AS OBJECT
   DATA  oFacProvL   AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oTikeT      AS OBJECT
   DATA  oTikeL      AS OBJECT
   DATA  oArt        AS OBJECT
   DATA  oHisMov     AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  oDbfFPago   AS OBJECT
   DATA  oFacCliP    AS OBJECT

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles()

  local oBlock
  local oError
  local lOpen := .t.

    /*
   Ficheros necesarios
   */

   oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   DATABASE NEW ::oAlbProvT PATH ( cPatEmp() ) FILE "ALBPROVT.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVT.CDX"

   DATABASE NEW ::oAlbProvL PATH ( cPatEmp() ) FILE "ALBPROVL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"

   DATABASE NEW ::oFacProvT PATH ( cPatEmp() ) FILE "FACPRVT.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"

   DATABASE NEW ::oFacProvL PATH ( cPatEmp() ) FILE "FACPRVL.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH  ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   ::oFacCliT := TDataCenter():oFacCliT()  

   DATABASE NEW ::oFacCliL PATH  ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oTiket PATH    ( cPatEmp() ) FILE "TIKET.DBF" VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikel PATH    ( cPatEmp() ) FILE "TIKEL.DBF" VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oArt PATH      ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   DATABASE NEW ::oHisMov PATH   ( cPatEmp() ) FILE "HISMOV.DBF" VIA ( cDriver() ) SHARED INDEX "HISMOV.CDX"

   DATABASE NEW ::oDbfIva PATH   ( cPatDat() ) FILE "TIVA.DBF" VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   DATABASE NEW ::oDbfFPago PATH ( cPatEmp() ) FILE "FPAGO.DBF" VIA ( cDriver() ) SHARED INDEX "FPAGO.CDX"

   ::oFacCliP := TDataCenter():oFacCliP()

   RECOVER USING oError

      lOpen := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

  if !Empty( ::oAlbProvT ) .and. ::oAlbProvT:Used()
      ::oAlbProvT:End()
   end if

  if !Empty( ::oAlbProvL ) .and. ::oAlbProvL:Used()
      ::oAlbProvL:End()
   end if

  if !Empty( ::oFacProvT ) .and. ::oFacProvT:Used()
      ::oFacProvT:End()
   end if

  if !Empty( ::oFacProvL ) .and. ::oFacProvL:Used()
      ::oFacProvL:End()
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

   if !Empty( ::oTikeT ) .and. ::oTikeT:Used()
      ::oTikeT:End()
   end if

  if !Empty( ::oTikeL ) .and. ::oTikeL:Used()
      ::oTikeL:End()
   end if

   if !Empty( ::oArt ) .and. ::oArt:Used()
      ::oArt:End()
   end if

   if !Empty( ::oHisMov ) .and. ::oHisMov:Used()
      ::oHisMov:End()
   end if

  if !Empty( ::oDbfPago ) .and. ::oDbfPago:Used()
      ::oDbfPago:End()
   end if

  if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld )

   if !::StdResource( "INF_GEN06" )
      return .f.
   end if

   /*
   Monta los almacenes de manera automatica
   */

   ::oDefAlmInf( 70, 80, 90, 100 )

   /*
   Monta las familias de manera automatica
   */

   ::lDefFamInf( 110, 120, 130, 140 )

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oAlbProvT:Lastrec() )

   ::oDefExcInf()

   ::oDefResInf()

/*   REDEFINE RADIO ::nEstado ;
      ID       201, 202, 203 ;
      OF       ::oFld:aDialogs[1] */

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cRetCode
   local cCodFam
   local bValid   := {|| .t. }
   local lExcCero := .f.
   local cRet
   local nEvery
   local cont

   ::oDlg:Disable()

   ::oDbf:Zap()
   ::oAlbProvT:GoTop()

   ::oMtrInf:SetTotal( ::oAlbProvT:Lastrec() )
   nEvery      := Int( ::oMtrInf:nTotal / 10 )


   ::aHeader   := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Almacén : " + ::cAlmOrg         + " > " + ::cAlmDes         },;
                     {|| "Familia : " + ::cFamOrg       + " > " + ::cFamDes       } }

   /*
   Albaranes de Proveedores
	*/


    WHILE ! ::oAlbProvT:Eof ()

      IF ! ::oAlbProvT:LFACTURADO                                .AND.;
         ::oAlbProvT:DFECALB >= ::dIniInf                        .AND.;
         ::oAlbProvT:DFECALB <= ::dFinInf                        .AND.;
         ::oAlbProvT:CCODALM >= ::cAlmOrg                        .AND.;
         ::oAlbProvT:CCODALM <= ::cAlmDes                        .AND.;
         lChkSer( ::oAlbProvT:CSERALB, ::aSer )

         /*
         Lineas de detalle
         */

         IF ::oAlbProvL:Seek( ::oAlbProvT:CSERALB + Str( ::oAlbProvT:NNUMALB ) + ::oAlbProvT:CSUFALB )

            WHILE ( ::oAlbProvT:CSERALB + Str( ::oAlbProvT:NNUMALB ) + ::oAlbProvT:CSUFALB) == ( ::oAlbProvL:CSERALB + Str( ::oAlbProvL:NNUMALB ) + ::oAlbProvL:CSUFALB) .AND. ! ::oAlbProvL:eof()

               cCodFam  := cCodFam( ::oAlbProvL:CREF, ::oArt )

               IF cCodFam >= ::cFamOrg                          .AND.;
                  cCodFam <= ::cFamDes                          .AND.;
                  !( ::lExcCero .AND. ::oAlbProvL:nPreUnit == 0 )

                  ::oDbf:Append()

                  ::oDbf:CCODALM := ::oAlbProvT:CCODALM
                  ::oDbf:CCODCLI := ::oAlbProvT:CCODPRV
                  ::oDbf:CNOMCLI := ::oAlbProvT:CNOMPRV
                  ::oDbf:DFECMOV := ::oAlbProvT:DFECALB

                  ::oDbf:cCodFam := cCodFam
                  ::oDbf:cNomFam := cNomFam( cCodFam, ::oDbfFam )
                  ::oDbf:CCODART := ::oAlbProvL:CREF
                  ::oDbf:CNOMART := ::oAlbProvL:CDETALLE
                  ::oDbf:NCAJENT := ::oAlbProvL:NCANENT
                  ::oDbf:NUNTENT := NotCaja( ::oAlbProvL:NCANENT ) * ::oAlbProvL:NUNICAJA
                  ::oDbf:NCAJSAL := 0
                  ::oDbf:NUNTSAL := 0
                  ::oDbf:CTIPDOC := "Alb. Prov."
                  ::oDbf:CDOCMOV := ::oAlbProvL:CSERALB + "/" + Str( ::oAlbProvL:NNUMALB ) + "/" + ::oAlbProvL:CSUFALB

                  ::oDbf:NSALCAJ := ::oDbf:NCAJENT - ::oDbf:NCAJSAL
                  ::oDbf:NSALUNI := ::oDbf:NUNTENT - ::oDbf:NUNTSAL
                  ::oDbf:NVALORA := ::oArt:pCosto * ::oDbf:nSalUni
                  //::oDbf:NTOTDOC := nTotAlbPrv(::oAlbProvT:CSERALB + Str( ::oAlbProvT:NNUMALB ) + ::oAlbProvT:CSUFALB, ::oAlbProvT:cAlias, ::oAlbProvL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oDbfFPago:cAlias, ,::cDivInf )

                  ::oDbf:Save()

               END IF

            ::oAlbProvL:Skip()

            END WHILE

         END IF

      END IF

      ::oAlbProvT:Skip()

      ::oMtrInf:AutoInc( ::oAlbProvT:OrdKeyNo() )

   END WHILE

   /*
   Factura de Proveedores------------------------------------------------------
   */

   lExcCero := .f.

   ::oFacProvT:GoTop()

   ::oMtrInf:SetTotal( ::oFacProvT:Lastrec() )
   nEvery         := Int( ::oMtrInf:nTotal / 10 )

   WHILE ! ::oFacProvT:Eof()

         IF ::oFacProvT:DFECFAC >= ::dIniInf                                                 .AND.;
            ::oFacProvT:DFECFAC <= ::dFinInf                                                 .AND.;
            ::oFacProvT:CCODALM >= ::cAlmOrg                                                 .AND.;
            ::oFacProvT:CCODALM <= ::cAlmDes                                                 .AND.;
            lChkSer( ::oFacProvT:CSERFAC, ::aSer )

         /*
         Lineas de detalle
         */

         IF ::oFacProvL:Seek( ::oFacProvT:CSERFAC + Str( ::oFacProvT:NNUMFAC ) + ::oFacProvT:CSUFFAC )

         WHILE ::oFacProvT:CSERFAC + Str( ::oFacProvT:NNUMFAC ) + ::oFacProvT:CSUFFAC == ::oFacProvL:CSERFAC + Str( ::oFacProvL:NNUMFAC ) + ::oFacProvL:CSUFFAC .AND. ! ::oFacProvL:Eof()

               cCodFam := cCodFam( ::oFacProvL:CREF, ::oArt )

               IF cCodFam >= ::cFamOrg    .AND.;
                  cCodFam <= ::cFamDes    .AND.;
                  !( ::lExcCero .AND. ::oFacProvL:nPreUnit == 0 )

                  ::oDbf:Append()

                  ::oDbf:CCODALM := ::oFacProvT:CCODALM
                  ::oDbf:CCODCLI := ::oFacProvT:CCODPRV
                  ::oDbf:CNOMCLI := ::oFacProvT:CNOMPRV
                  ::oDbf:DFECMOV := ::oFacProvT:DFECFAC

                  ::oDbf:cCodFam := cCodFam
                  ::oDbf:cNomFam := cNomFam( cCodFam, ::oDbfFam )
                  ::oDbf:CCODART := ::oFacProvL:CREF
                  ::oDbf:CNOMART := ::oFacProvL:CDETALLE
                  ::oDbf:NCAJENT := ::oFacProvL:NCANENT
                  ::oDbf:NUNTENT := NotCaja( ::oFacProvL:NCANENT ) * ::oFacProvL:NUNICAJA
                  ::oDbf:NCAJSAL := 0
                  ::oDbf:NUNTSAL := 0
                  ::oDbf:CTIPDOC := "Fac. Prov."
                  ::oDbf:CDOCMOV := ::oFacProvL:CSERFAC + "/" + Str( ::oFacProvL:NNUMFAC ) + "/" + ::oFacProvL:CSUFFAC

                  ::oDbf:NSALCAJ := ::oDbf:NCAJENT - ::oDbf:NCAJSAL
                  ::oDbf:NSALUNI := ::oDbf:NUNTENT - ::oDbf:NUNTSAL
                  ::oDbf:NVALORA := ::oArt:PCOSTO * ::oDbf:NSALUNI

                  ::oDbf:Save()

            END IF

            ::oFacProvL:Skip()

         END WHILE

      END IF

      END IF

   ::oFacProvT:Skip()

   ::oMtrInf:AutoInc( ::oFacProvT:OrdKeyNo() )

   END WHILE

   /*
   Albaranes de Clientes ----------------------------------------------------
   */

   lExcCero := .f.

   ::oAlbCliT:GoTop()

   ::oMtrInf:SetTotal( ::oAlbCliT:Lastrec() )
   nEvery         := Int( ::oMtrInf:nTotal / 10 )

   WHILE ! ::oAlbCliT:Eof()

      IF ! ::oAlbCliT:LFACTURADO                                              .AND.;
         ::oAlbCliT:DFECALB >= ::dIniInf                                      .AND.;
         ::oAlbCliT:DFECALB <= ::dFinInf                                      .AND.;
         ::oAlbCliT:CCODALM >= ::cAlmOrg                                      .AND.;
         ::oAlbCliT:CCODALM <= ::cAlmDes                                      .AND.;
         lChkSer( ::oAlbCliT:CSERALB, ::aSer )

         /*
         Lineas de detalle
         */

         IF ::oAlbCliL:Seek( ::oAlbCliT:CSERALB + Str( ::oAlbCliT:NNUMALB ) + ::oAlbCliT:CSUFALB )

         WHILE ( ::oAlbCliT:CSERALB + Str( ::oAlbCliT:NNUMALB ) + ::oAlbCliT:CSUFALB) == ( ::oAlbCliL:CSERALB + Str( ::oAlbCliL:NNUMALB ) + ::oAlbCliL:CSUFALB) .AND. !::oAlbCliL:eof()

               cCodFam := cCodFam( ::oAlbCliL:CREF, ::oArt )

               IF cCodFam >= ::cFamOrg    .AND.;
                  cCodFam <= ::cFamDes    .AND.;
                  !( ::lExcCero .AND. ::oAlbCliL:nPreUnit == 0 )

                  ::oDbf:Append()

                  ::oDbf:CCODALM := ::oAlbCliT:CCODALM
                  ::oDbf:CCODCLI := ::oAlbCliT:CCODCLI
                  ::oDbf:CNOMCLI := ::oAlbCliT:CNOMCLI
                  ::oDbf:DFECMOV := ::oAlbCliT:DFECALB

                  ::oDbf:cCodFam := cCodFam( ::oAlbCliL:CREF, ::oArt )
                  ::oDbf:cNomFam := cNomFam( cCodFam, ::oDbfFam )
                  ::oDbf:CCODART := ::oAlbCliL:CREF
                  ::oDbf:CNOMART := ::oAlbCliL:CDETALLE
                  ::oDbf:NCAJENT := 0
                  ::oDbf:NUNTENT := 0
                  ::oDbf:NCAJSAL := ::oAlbCliL:NCANENT
                  ::oDbf:NUNTSAL := NotCaja( ::oAlbCliL:NCANENT ) * ::oAlbCliL:NUNICAJA
                  ::oDbf:CTIPDOC := "Alb. Cli."
                  ::oDbf:CDOCMOV := ::oAlbCliL:CSERALB + "/" + Str( ::oAlbCliL:NNUMALB ) + "/" + ::oAlbCliL:CSUFALB

                  ::oDbf:NSALCAJ := ::oDbf:NCAJENT - ::oDbf:NCAJSAL
                  ::oDbf:NSALUNI := ::oDbf:NUNTENT - ::oDbf:NUNTSAL
                  ::oDbf:NVALORA := ( ::oArt:nArea )->PCOSTO * ::oDbf:NSALUNI


                  ::oDbf:Save()

            END IF

            ::oAlbCliL:Skip()

         END WHILE

         END IF

      END IF

      ::oAlbCliT:Skip()

      ::oMtrInf:AutoInc()

   END WHILE

   /*
   Factura de Clientes---------------------------------------------------------
   */

   lExcCero := .f.

   ::oFacCliT:GoTop()

   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )
   nEvery         := Int( ::oMtrInf:nTotal / 10 )

   WHILE ! ::oFacCliT:Eof()

      IF ::oFacCliT:DFECFAC >= ::dIniInf                                                 .AND.;
         ::oFacCliT:DFECFAC <= ::dFinInf                                                 .AND.;
         ::oFacCliT:CCODALM >= ::cAlmOrg                                                 .AND.;
         ::oFacCliT:CCODALM <= ::cAlmDes                                                 .AND.;
         lChkSer( ::oFacCliT:CSERIE, ::aSer )

         /*
         Lineas de detalle
         */

         IF ::oFacCliL:Seek( ::oFacCliT:CSERIE + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC )

         WHILE ( ::oFacCliT:CSERIE + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC) == ( ::oFacCliL:CSERIE + Str( ::oFacCliL:NNUMFAC ) + ::oFacCliL:CSUFFAC) .AND. !::oFacCliL:eof()

               cCodFam := cCodFam( ::oFacCliL:CREF, ::oArt )

               IF cCodFam >= ::cFamOrg    .AND.;
                  cCodFam <= ::cFamDes    .AND.;
                  !( ::lExcCero .AND. ::oFacCliL:nPreUnit == 0 )

                  ::oDbf:Append()

                  ::oDbf:CCODALM := ::oFacCliT:CCODALM
                  ::oDbf:CCODCLI := ::oFacCliT:CCODCLI
                  ::oDbf:CNOMCLI := ::oFacCliT:CNOMCLI
                  ::oDbf:DFECMOV := ::oFacCliT:DFECFAC

                  ::oDbf:cCodFam := cCodFam
                  ::oDbf:cNomFam := cNomFam( cCodFam, ::oDbfFam )
                  ::oDbf:CCODART := ::oFacCliL:CREF
                  ::oDbf:CNOMART := ::oFacCliL:CDETALLE
                  ::oDbf:NCAJENT := 0
                  ::oDbf:NUNTENT := 0
                  ::oDbf:NCAJSAL := ::oFacCliL:NCANENT
                  ::oDbf:NUNTSAL := NotCaja( ::oFacCliL:NCANENT ) * ::oFacCliL:NUNICAJA
                  ::oDbf:CTIPDOC := "Fac. Cli."
                  ::oDbf:CDOCMOV := ::oFacCliL:CSERIE + "/" + Str( ::oFacCliL:NNUMFAC ) + "/" + ::oFacCliL:CSUFFAC

                  ::oDbf:NSALCAJ := ::oDbf:NCAJENT - ::oDbf:NCAJSAL
                  ::oDbf:NSALUNI := ::oDbf:NUNTENT - ::oDbf:NUNTSAL
                  ::oDbf:NVALORA := ::oArt:PCOSTO * ::oDbf:NSALUNI
                  //::oDbf:NTOTDOC := nTotFacCli( ::oFacCliT:CSERIE + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacCliP:cAlias )
//                                  nTotFacCli( cFactura,                                                           dbfMaster,         dbfLine,           dbfIva,           dbfDiv,           dbfFacCliP, aTmp, cDivRet, lPic, lExcCnt )

                  ::oDbf:Save()

            END IF

            ::oFacCliL:Skip()

         END WHILE

         END IF

      END IF

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   END WHILE


   /*
   Tickets --------------------------------------------------------------------
   */


   lExcCero := .f.

   ::oTiket:GoTop()

   ::oMtrInf:SetTotal( ::oTiket:Lastrec() )
   nEvery         := Int( ::oMtrInf:nTotal / 10 )

   WHILE ! ::oTiket:Eof()

      IF ::oTiket:DFECTIK >= ::dIniInf                                                    .AND.;
         ::oTiket:DFECTIK <= ::dFinInf                                                    .AND.;
         ::oTiket:CALMTIK >= ::cAlmOrg                                                    .AND.;
         ::oTiket:CALMTIK <= ::cAlmDes                                                    .AND.;
         ::oTikeL:Seek( ::oTiket:CSERTIK +  ::oTiket:CNUMTIK + ::oTiket:CSUFTIK )

         WHILE ::oTiket:CSERTIK + ::oTiket:CNUMTIK + ::oTiket:CSUFTIK == ::oTikeL:CSERTIL + ::oTikeL:CNUMTIL + ::oTikeL:CSUFTIL .AND. ! ::oTikeL:Eof();

            cRetCode := retCode( ::oTikeL:CCBATIL, ::oArt:cAlias )
            cCodFam  := ::oTikeL:cFamTil

            IF !Empty( cRetCode )                                                .AND.;
               cCodFam >= ::cFamOrg .AND. cCodFam <= ::cFamDes                   .AND.;
               ::oTikeT:cTipTik == "1"                                           .AND.;
               ! (lExcCero .AND. ::oTikeL:NPVPTIL == 0)

               ::oDbf:Append()
               ::oDbf:CCODCLI := ::oTiket:CCLITIK
               ::oDbf:CCODALM := ::oTiket:CALMTIK
               ::oDbf:CNOMCLI := ::oTiket:CNOMTIK
               ::oDbf:DFECMOV := ::oTiket:DFECTIK

               ::oDbf:NUNTENT := 0
               ::oDbf:NUNTSAL := ::oTikeL:NUNTTIL
               ::oDbf:cCodFam := cCodFam
               ::oDbf:cNomFam := cNomFam( cCodFam, ::oDbfFam )

               ::oDbf:CCODART := cRetCode
               ::oDbf:cNomArt := ::oTikeL:cNomTil
               ::oDbf:CDOCMOV := ::oTiket:CSERTIK + "/" + ltrim( ::oTiket:CNUMTIK ) + "/" + ::oTiket:CSUFTIK
               ::oDbf:CTIPDOC := "Tiket"

               ::oDbf:NSALCAJ := 0
               ::oDbf:NSALUNI := ::oTikeL:NUNTTIL
               ::oDbf:NVALORA := ::oTikeL:nPvpTil
               ::oDbf:NTOTDOC := ::oTikeL:nPvpTil * ::oTikeL:nUntTil

               ::oDbf:Save()

            END IF

            /*
            Ahora comprobamos q no haya producto combinado
            */

            IF !Empty( ::oTikeL:CCOMTIL )

               cRetCode := retCode( ::oTikeL:CCOMTIL, ::oArt:cAlias )

               IF !Empty( cRetCode )                                                   .AND.;
                   cRetCode >= ::dInfIni .AND. cRetCode <= ::dFinInf                   .AND.;
                   ::oTikeT:cTipTik == "1"                                             .AND.;
                   !(lExcCero .AND. ::oTikeL:NPVPTIL == 0)

                  ::oDbf:Append()
                  ::oDbf:CCODCLI := ::oTiket:CCLITIK
                  ::oDbf:CCODALM := ::oTiket:CALMTIK
                  ::oDbf:CNOMCLI := ::oTiket:CNOMTIK
                  ::oDbf:DFECMOV := ::oTiket:DFECTIK

                  ::oDbf:NUNTENT := 0
                  ::oDbf:NUNTSAL := ::oTikeL:NUNTTIL
                  ::oDbf:cCodFam := cCodFam
                  ::oDbf:cNomFam := cNomFam( cCodFam, ::oDbfFam )
                  ::oDbf:CCODART := cRetCode
                  ::oDbf:CDOCMOV := ::oTiket:CSERTIK + "/" + ltrim( ::oTiket:CNUMTIK ) + "/" + ::oTiket:CSUFTIK
                  ::oDbf:CTIPDOC := "Tiket"

                  ::oDbf:NSALCAJ := 0
                  ::oDbf:NSALUNI := ::oTikeL:NUNTTIL
                  ::oDbf:NVALORA := ::oArt:PCOSTO * ::oDbf:NSALUNI
                  ::oDbf:NTOTDOC := ::oTikeL:nPvpTil * ::oTikeL:nUntTil
                  ::oDbf:Save()

               END IF

            END IF

            ::oTikeL:Skip()

         END WHILE

      END IF

      ::oTiket:Skip()

      ::oMtrInf:AutoInc()

      END WHILE

      /*
      Histórico de movimientos-------------------------------------------------
      */

      ::oMtrInf:SetTotal( ::oHisMov:Lastrec() )
      nEvery         := Int( ::oMtrInf:nTotal / 10 )

      WHILE !::oHisMov:Eof()

      cCodFam := cCodFam( ::oHisMov:CREFMOV, ::oArt )

      IF ::oHisMov:DFECMOV >= ::dIniInf                                 .AND.;
         ::oHisMov:DFECMOV <= ::dFinInf                                 .AND.;
         cCodFam >= ::cFamOrg                                         .AND.;
         cCodFam <= ::cFamDes

          IF ::oHisMov:nTipMov == 1

         /*
         Salidas____________________________________________________________
         */

            IF ::oHisMov:CALOMOV >= ::cAlmOrg  .AND. ::oHisMov:CALOMOV <= ::cAlmDes

               ::oDbf:Append()

               ::oDbf:CCODCLI := ""
               ::oDbf:CCODALM := ::oHisMov:CALOMOV
               ::oDbf:CNOMCLI := "MOVIMIENTOS ENTRE ALMACENES"
               ::oDbf:DFECMOV := ::oHisMov:DFECMOV

               ::oDbf:NUNTENT := 0
               ::oDbf:NUNTSAL := ::oHisMov:NUNDMOV
               ::oDbf:cCodFam := cCodFam
               ::oDbf:cNomFam := cNomFam( cCodFam, ::oDbfFam )
               ::oDbf:CCODART := ::oHisMov:CREFMOV
               ::oDbf:CDOCMOV := ""
               ::oDbf:CTIPDOC := "Mov. Almacen"

               ::oDbf:NSALCAJ := 0
               ::oDbf:NSALUNI := ::oDbf:NUNTENT - ::oDbf:NUNTSAL
               ::oDbf:NVALORA := ::oArt:PCOSTO * ::oDbf:NSALUNI

               ::oDbf:Save()
            END IF

            /*
            Entradas___________________________________________________________
            */

            IF ::oHisMov:nTipMov == 1 .and. ::oHisMov:CALIMOV >= ::cAlmOrg .and. ::oHisMov:CALIMOV <= ::cAlmDes

               ::oDbf:Append()
               ::oDbf:CCODCLI := ""
               ::oDbf:CCODALM := ::oHisMov:CALIMOV
               ::oDbf:CNOMCLI := "MOVIMIENTOS ENTRE ALMACENES"
               ::oDbf:DFECMOV := ::oHisMov:DFECMOV

               ::oDbf:NUNTENT := ::oHisMov:NUNDMOV
               ::oDbf:NUNTSAL := 0
               ::oDbf:cCodFam := cCodFam
               ::oDbf:cFamNom := cNomFam( cCodFam, ::oDbfFam )
               ::oDbf:CCODART := ::oHisMov:CREFMOV
               ::oDbf:CDOCMOV := ""
               ::oDbf:CTIPDOC := "Mov. Almacen"

               ::oDbf:NSALCAJ := 0
               ::oDbf:NSALUNI := ::oDbf:NUNTENT - ::oDbf:NUNTSAL
               ::oDbf:NVALORA := ::oArt:PCOSTO * ::oDbf:NSALUNI

               ::oDbf:Save()
            END IF

         ELSE

            /*
            Movimientos simples
            */

            IF ::oHisMov:CALOMOV >= ::cAlmOrg  .AND. ::oHisMov:CALOMOV <= ::cAlmDes

               ::oDbf:Append()
               ::oDbf:CCODCLI := ""
               ::oDbf:CCODALM := ::oHisMov:CALOMOV
               ::oDbf:CNOMCLI := "ENTRADA EN ALMACEN"

               ::oDbf:DFECMOV := ::oHisMov:DFECMOV
               ::oDbf:NUNTENT := ::oHisMov:NUNDMOV
               ::oDbf:cCodFam := cCodFam
               ::oDbf:cNomFam := cNomFam( cCodFam, ::oDbfFam )
               ::oDbf:CCODART := ::oHisMov:CREFMOV
               ::oDbf:CDOCMOV := ""
               ::oDbf:CTIPDOC := "Ent. Almacen"

               ::oDbf:NSALCAJ := 0
               ::oDbf:NSALUNI := ::oDbf:NUNTENT - ::oDbf:NUNTSAL
               ::oDbf:NVALORA := ::oArt:PCOSTO * ::oDbf:NSALUNI

               ::oDbf:Save()

            END IF

         END IF

      END IF

      ::oHisMov:Skip()

      ::oMtrInf:AutoInc()

    END WHILE

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )