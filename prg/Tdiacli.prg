#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION TDiaCli()

   local oInf
   local aCol  := {}
   local aIdx  := {}

   aAdd( aCol, { "CCODCLI", "C", 12, 0, {|| "@!" },          "Cli",                        .f., "Código cliente"            ,  8, .f.} )
   aAdd( aCol, { "CNOMCLI", "C", 50, 0, {|| "@!" },          "Nombre",                     .f., "Cliente"                   , 25, .f.} )
   aAdd( aCol, { "CNIFCLI", "C", 15, 0, {|| "@!" },          "Nif",                        .f., "Nif"                       , 10, .f.} )
   aAdd( aCol, { "CDOCMOV", "C", 14, 0, {|| "@!" },          "Documento",                  .t., "Documento"                 , 14, .f.} )
   aAdd( aCol, { "CTIPDOC", "C", 14, 0, {|| "@!" },          "Tipo",                       .t., "Tipo"                      , 14, .f.} )
   aAdd( aCol, { "DFECMOV", "D",  8, 0, {|| "@!" },          "Fecha",                      .t., "Fecha"                     ,  8, .f.} )
   aAdd( aCol, { "CDOMCLI", "C", 35, 0, {|| "@!" },          "Domicilio",                  .f., "Domicilio"                 , 25, .f.} )
   aAdd( aCol, { "CPOBCLI", "C", 35, 0, {|| "@!" },          "Poblacion",                  .f., "Población"                 , 20, .f.} )
   aAdd( aCol, { "CPROCLI", "C", 20, 0, {|| "@!" },          "Prov",                       .f., "Provincia"                 , 20, .f.} )
   aAdd( aCol, { "CCDPCLI", "C",  7, 0, {|| "@!" },          "CP",                         .f., "Cod. Postal"               ,  7, .f.} )
   aAdd( aCol, { "CTLFCLI", "C", 12, 0, {|| "@!" },          "Tlf",                        .f., "Teléfono"                  , 12, .f.} )
   aAdd( aCol, { "NBASIMP", "N", 16, 6, {|| oInf:cPicOut },  "Base Imponible",             .t., "Base Imponible"            , 10, .t.} )
   aAdd( aCol, { "NTOTIVA", "N", 16, 6, {|| oInf:cPicOut },  "IVA.",                       .t., "Total " + cImp()           , 10, .t.} )
   aAdd( aCol, { "NRECEQU", "N", 16, 6, {|| oInf:cPicOut },  "Rec.",                       .t., "Recargo Equivalencia"      , 10, .t.} )
   aAdd( aCol, { "NPREDIV", "N", 16, 6, {|| oInf:cPicOut },  "Importe",                    .t., "Importe"                   , 10, .t.} )

   aAdd( aIdx, { "CCODCLI", "CCODCLI" } )

   oInf  := TInfDiaCli():New( "Informe detallado de todas las operaciones de venta realizadas por un cliente", aCol, aIdx, "01045" )

   oInf:AddGroup( {|| oInf:oDbf:cCodCli }, {|| "Cliente  : " + Rtrim( oInf:oDbf:cCodCli ) + "-" + oRetFld( oInf:oDbf:cCodCli, oInf:oDbfCli ) }, {||"Total cliente..."} )

   oInf:Resource()
   oInf:Activate()

   oInf:End()

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TInfDiaCli FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  lPresu      AS LOGIC    INIT .t.
   DATA  lPedid      AS LOGIC    INIT .t.
   DATA  lAlbar      AS LOGIC    INIT .t.
   DATA  lFactu      AS LOGIC    INIT .t.
   DATA  lTiket      AS LOGIC    INIT .t.
   DATA  nEstado     AS NUMERIC  INIT 1
   DATA  oPreCliT    AS OBJECT
   DATA  oPreCliL    AS OBJECT
   DATA  oPedCliT    AS OBJECT
   DATA  oPedCliL    AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oTikeT      AS OBJECT
   DATA  oTikeL      AS OBJECT
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

METHOD OpenFiles() CLASS  TInfDiaCli

  local oBlock
  local oError
  local lOpen := .t.

   /*
   Ficheros necesarios
   */

   oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::oPreCliT  := TDataCenter():oPreCliT()

   DATABASE NEW ::oPreCliL PATH ( cPatEmp() ) FILE "PRECLIL.DBF" VIA ( cDriver() ) SHARED INDEX "PRECLIL.CDX"

   ::oPedCliT := TDataCenter():oPedCliT()

   DATABASE NEW ::oPedCliL PATH ( cPatEmp() ) FILE "PEDCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "PEDCLIL.CDX"

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oTiket PATH ( cPatEmp() ) FILE "TIKET.DBF" VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikel PATH ( cPatEmp() ) FILE "TIKEL.DBF" VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oDbfArt PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   DATABASE NEW ::oHisMov PATH ( cPatEmp() ) FILE "HISMOV.DBF" VIA ( cDriver() ) SHARED INDEX "HISMOV.CDX"

   DATABASE NEW ::oDbfIva PATH ( cPatDat() ) FILE "TIVA.DBF" VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

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

METHOD CloseFiles() CLASS  TInfDiaCli

   if !Empty( ::oPreCliT ) .and. ::oPreCliT:Used()
      ::oPreCliT:End()
   end if

   if !Empty( ::oPreCliL ) .and. ::oPreCliL:Used()
      ::oPreCliL:End()
   end if

   if !Empty( ::oPedCliT ) .and. ::oPedCliT:Used()
      ::oPedCliT:End()
   end if

   if !Empty( ::oPedCliL ) .and. ::oPedCliL:Used()
      ::oPedCliL:End()
   end if

   if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if

   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if

   if !Empty( ::oTiket ) .and. ::oTiket:Used()
      ::oTiket:End()
   end if

   if !Empty( ::oTikel ) .and. ::oTikel:Used()
      ::oTikel:End()
   end if

   if !Empty( ::oDbfPago ) .and. ::oDbfPago:Used()
      ::oDbfPago:End()
   end if

   if !Empty( ::oFacCliP ) .and. ::oFacCliP:Used()
      ::oFacCliP:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS  TInfDiaCli

   if !::StdResource( "INF_GEN13" )
      return .f.
   end if

   ::oDefCliInf( 110, 120, 130, 140 )

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oAlbCliT:Lastrec() )

   ::oDefExcInf( 204 )

   ::oDefResInf( 202 )

   REDEFINE CHECKBOX ::lPresu ;
      ID       ( 205 );
      OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lPedid ;
      ID       ( 206 );
      OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lAlbar ;
      ID       ( 207 );
      OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lFactu ;
      ID       ( 208 );
      OF       ::oFld:aDialogs[1]

   RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS  TInfDiaCli

   local lExcCero := .f.
   local aTot

   ::oDlg:Disable()

   ::oDbf:Zap()

   ::aHeader   := {  {|| "Fecha       : " + Dtoc( Date() ) },;
                     {|| "Periodo     : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Cliente     : " + ::cCliOrg         + " > " + ::cCliDes         },;
                     {|| "Documentos  : " + if( ::lPresu, "Presupuestos, ", "" ) +  if( ::lPedid, "Pedidos, ", "" ) +  if( ::lAlbar, "Albaranes, ", "" ) + if( ::lFactu, "Facturas, ", "" ) } }

   /*
   Presupuesto de Clientes
   */

   lExcCero := .f.

   ::oPreCliT:GoTop()

   ::oMtrInf:SetTotal( ::oPreCliT:Lastrec() )

   WHILE ! ::oPreCliT:Eof() .AND. ::lPresu

      IF ::oPreCliT:DFECPRE >= ::dIniInf                                                 .AND.;
         ::oPreCliT:DFECPRE <= ::dFinInf                                                 .AND.;
         ::oPreCliT:CCODCLI >= ::cCliOrg                                                 .AND.;
         ::oPreCliT:CCODCLI <= ::cCliDes                                                 .AND.;
         !( ::lExcCero .AND. ::oPreCliL:nPreUnit == 0 )                                  .AND.;
         lChkSer( ::oPreCliT:CSERPRE, ::aSer )

         ::oDbf:Append()

         ::oDbf:CCODCLI := ::oPreCliT:CCODCLI
         ::oDbf:CNOMCLI := ::oPreCliT:CNOMCLI
         ::oDbf:DFECMOV := ::oPreCliT:DFECPRE

         IF ::oDbfCli:Seek ( ::oPreCliT:CCODCLI )

            ::oDbf:CNIFCLI := ::oDbfCli:Nif
            ::oDbf:CDOMCLI := ::oDbfCli:Domicilio
            ::oDbf:CPOBCLI := ::oDbfCli:Poblacion
            ::oDbf:CPROCLI := ::oDbfCli:Provincia
            ::oDbf:CCDPCLI := ::oDbfCli:CodPostal
            ::oDbf:CTLFCLI := ::oDbfCli:Telefono

         END IF

         aTot           := aTotPreCli( (::oPreCliT:CSERPRE + Str( ::oPreCliT:NNUMPRE ) + ::oPreCliT:CSUFPRE ), ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oDbfFPago:cAlias, cDivEmp() )
         ::oDbf:NBASIMP := aTot[ 1 ]
         ::oDbf:NTOTIVA := aTot[ 2 ]
         ::oDbf:NRECEQU := aTot[ 3 ]
         ::oDbf:NPREDIV := aTot[ 4 ]
         ::oDbf:CTIPDOC := "Presupuesto"
         ::oDbf:CDOCMOV := ::oPreCliT:CSERPRE + "/" + Str( ::oPreCliT:NNUMPRE ) + "/" + ::oPreCliT:CSUFPRE

         ::oDbf:Save()

         END IF

      ::oPreCliT:Skip()

      ::oMtrInf:AutoInc()

      END WHILE

   /*
   Pedidos de Clientes
   */

   lExcCero := .f.

   ::oPedCliT:GoTop()

   ::oMtrInf:SetTotal( ::oPedCliT:Lastrec() )

   WHILE ! ::oPedCliT:Eof() .AND. ::lPedid

      IF ::oPedCliT:DFECPED >= ::dIniInf                                                 .AND.;
         ::oPedCliT:DFECPED <= ::dFinInf                                                 .AND.;
         ::oPedCliT:CCODCLI >= ::cCliOrg                                                 .AND.;
         ::oPedCliT:CCODCLI <= ::cCliDes                                                 .AND.;
         !( ::lExcCero .AND. ::oPedCliL:nPreUnit == 0 )                                  .AND.;
         lChkSer( ::oPedCliT:CSERPED, ::aSer )

         ::oDbf:Append()

         ::oDbf:CCODCLI := ::oPedCliT:CCODCLI
         ::oDbf:CNOMCLI := ::oPedCliT:CNOMCLI
         ::oDbf:DFECMOV := ::oPedCliT:DFECPED

         IF ::oDbfCli:Seek ( ::oPedCliT:CCODCLI )

            ::oDbf:CNIFCLI := ::oDbfCli:Nif
            ::oDbf:CDOMCLI := ::oDbfCli:Domicilio
            ::oDbf:CPOBCLI := ::oDbfCli:Poblacion
            ::oDbf:CPROCLI := ::oDbfCli:Provincia
            ::oDbf:CCDPCLI := ::oDbfCli:CodPostal
            ::oDbf:CTLFCLI := ::oDbfCli:Telefono

          END IF

         aTot           := aTotPedCli( (::oPedCliT:CSERPED + Str( ::oPedCliT:NNUMPED ) + ::oPedCliT:CSUFPED ), ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oDbfFPago:cAlias, nil, ::cDivInf  )
         ::oDbf:NBASIMP := aTot [ 1 ] - aTot [ 5 ] - aTot [ 6 ]
         ::oDbf:NTOTIVA := aTot [ 2 ]
         ::oDbf:NRECEQU := aTot [ 3 ]
         ::oDbf:NPREDIV := aTot [ 4 ]
         ::oDbf:CTIPDOC := "Pedidos"
         ::oDbf:CDOCMOV := ::oPedCliT:CSERPED + "/" + Str( ::oPedCliT:NNUMPED ) + "/" + ::oPedCliT:CSUFPED

         ::oDbf:Save()

      END IF

      ::oPedCliT:Skip()

      ::oMtrInf:AutoInc()

      END WHILE

   /*
   Albaranes de Clientes
   */

   lExcCero := .f.

   ::oAlbCliT:GoTop()

   ::oMtrInf:SetTotal( ::oAlbCliT:Lastrec() )

   WHILE ! ::oAlbCliT:Eof() .AND. ::lAlbar

      IF ::oAlbCliT:DFECALB >= ::dIniInf                                                 .AND.;
         ::oAlbCliT:DFECALB <= ::dFinInf                                                 .AND.;
         ::oAlbCliT:CCODCLI >= ::cCliOrg                                                 .AND.;
         ::oAlbCliT:CCODCLI <= ::cCliDes                                                 .AND.;
         !( ::lExcCero .AND. ::oAlbCliL:nPreUnit == 0 )                                  .AND.;
         lChkSer( ::oAlbCliT:CSERALB, ::aSer )

         ::oDbf:Append()

         ::oDbf:CCODCLI := ::oAlbCliT:CCODCLI
         ::oDbf:CNOMCLI := ::oAlbCliT:CNOMCLI
         ::oDbf:DFECMOV := ::oAlbCliT:DFECALB

         IF ::oDbfCli:Seek ( ::oAlbCliT:CCODCLI )

            ::oDbf:CNIFCLI := ::oDbfCli:Nif
            ::oDbf:CDOMCLI := ::oDbfCli:Domicilio
            ::oDbf:CPOBCLI := ::oDbfCli:Poblacion
            ::oDbf:CPROCLI := ::oDbfCli:Provincia
            ::oDbf:CCDPCLI := ::oDbfCli:CodPostal
            ::oDbf:CTLFCLI := ::oDbfCli:Telefono
            
         END IF

         aTot           := aTotAlbCli( ::oAlbCliT:CSERALB + Str( ::oAlbCliT:NNUMALB ) + ::oAlbCliT:CSUFALB, ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::cDivInf  )

         ::oDbf:NBASIMP := aTot[ 1 ] - aTot[ 5 ] - aTot[ 6 ]
         ::oDbf:NTOTIVA := aTot[ 2 ]
         ::oDbf:NRECEQU := aTot[ 3 ]
         ::oDbf:NPREDIV := aTot[ 4 ]
         ::oDbf:CTIPDOC := "Albaran"
         ::oDbf:CDOCMOV := ::oAlbCliT:CSERALB + "/" + Str( ::oAlbCliT:NNUMALB ) + "/" + ::oAlbCliT:CSUFALB

         ::oDbf:Save()

      END IF

      ::oAlbCliT:Skip()

      ::oMtrInf:AutoInc()

   END WHILE

   /*
   Facturas de Clientes
   */

   lExcCero := .f.

   ::oFacCliT:GoTop()

   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )

   WHILE ! ::oFacCliT:Eof() .AND. ::lFactu

      IF ::oFacCliT:DFECFAC >= ::dIniInf                                                 .AND.;
         ::oFacCliT:DFECFAC <= ::dFinInf                                                 .AND.;
         ::oFacCliT:CCODCLI >= ::cCliOrg                                                 .AND.;
         ::oFacCliT:CCODCLI <= ::cCliDes                                                 .AND.;
         !( ::lExcCero .AND. ::oFacCliL:nPreUnit == 0 )                                  .AND.;
         lChkSer( ::oFacCliT:CSERIE, ::aSer )

         ::oDbf:Append()

         ::oDbf:CCODCLI := ::oFacCliT:CCODCLI
         ::oDbf:CNOMCLI := ::oFacCliT:CNOMCLI
         ::oDbf:DFECMOV := ::oFacCliT:DFECFAC

         IF ::oDbfCli:Seek ( ::oFacCliT:CCODCLI )

            ::oDbf:CNIFCLI := ::oDbfCli:Nif
            ::oDbf:CDOMCLI := ::oDbfCli:Domicilio
            ::oDbf:CPOBCLI := ::oDbfCli:Poblacion
            ::oDbf:CPROCLI := ::oDbfCli:Provincia
            ::oDbf:CCDPCLI := ::oDbfCli:CodPostal
            ::oDbf:CTLFCLI := ::oDbfCli:Telefono

          END IF

         aTot           := aTotFacCli( (::oFacCliT:CSERIE + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC ), ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacCliP:cAlias, cDivEmp() )
         ::oDbf:NBASIMP := aTot [ 1 ] - aTot[5] - aTot[6]
         ::oDbf:NTOTIVA := aTot [ 2 ]
         ::oDbf:NRECEQU := aTot [ 3 ]
         ::oDbf:NPREDIV := aTot [ 4 ]
         ::oDbf:CTIPDOC := "Factura"
         ::oDbf:CDOCMOV := ::oFacCliT:CSERIE + "/" + Str( ::oFacCliT:NNUMFAC ) + "/" + ::oFacCliT:CSUFFAC

         ::oDbf:Save()

      END IF

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   END WHILE

   /* Tickets */

   /* lExcCero := .f.

   ::oTiket:GoTop():Load()

   ::oMtrInf:SetTotal( ::oTiket:Lastrec() )

   WHILE ! ::oTiket:Eof() .AND. ::lTiket

      IF ::oTiket:DFECTIK >= ::dIniInf                                                    .AND.;
         ::oTiket:DFECTIK <= ::dFinInf                                                    .AND.;
         ::oTiket:CALMTIK >= ::cAlmOrg                                                    .AND.;
         ::oTiket:CALMTIK <= ::cAlmDes                                                    .AND.;
         ::oTiket:cTipTik == "1"                                                          .AND.;
         ::oTikeL:Seek( ::oTiket:CSERTIK +  ::oTiket:CNUMTIK + ::oTiket:CSUFTIK )

         WHILE ::oTiket:CSERTIK +  ::oTiket:CNUMTIK +  ::oTiket:CSUFTIK == ::oTikeL:CSERTIL + ::oTikeL:CNUMTIL + ::oTikeL:CSUFTIL .AND. ! ::oTikeL:Eof();

            cRetCode := retCode( ::oTikeL:CCBATIL, ::oDbfArt:cAlias )

            IF !Empty( cRetCode )                                 .AND.;
               cRetCode >= ::cArtOrg .AND. cRetCode <= ::cArtDes  .AND.;
               ! (lExcCero .AND. ::oTikeL:NPVPTIL == 0)

               ::oDbf:Append()
               ::oDbf:CCODCLI := ::oTiket:CCLITIK
               ::oDbf:CCODALM := ::oTiket:CALMTIK
               ::oDbf:CNOMCLI := ::oTiket:CNOMTIK
               ::oDbf:DFECMOV := ::oTiket:DFECTIK

               IF ::oDbfCli:Seek ( ::oTikeT:CCODCLI )
                   ::oDbfCli:Load()

                   ::oDbf:CNIFCLI := ::oDbfCli:Nif
                   ::oDbf:CDOMCLI := ::oDbfCli:Domicilio
                   ::oDbf:CPOBCLI := ::oDbfCli:Poblacion
                   ::oDbf:CPROCLI := ::oDbfCli:Provincia
                   ::oDbf:CCDPCLI := ::oDbfCli:CodPostal
                   ::oDbf:CTLFCLI := ::oDbfCli:Telefono

                 END IF

                aTot           := aTotFacCli( (::oFacCliT:CSERIE + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC ), ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, cDivEmp() )
                ::oDbf:NBASIMP := aTot [ 1 ]
                ::oDbf:NTOTIVA := aTot [ 2 ]
                ::oDbf:NRECEQU := aTot [ 3 ]
                ::oDbf:NPREDIV := aTot [ 4 ]
                ::oDbf:CTIPDOC := "Factura"
                ::oDbf:CDOCMOV := ::oFacCliT:CSERIE + "/" + Str( ::oFacCliT:NNUMFAC ) + "/" + ::oFacCliT:CSUFFAC


               ::oDbf:CDOCMOV := ::oTiket:CSERTIK + "/" + ltrim( ::oTiket:CNUMTIK ) + "/" + ::oTiket:CSUFTIK
               ::oDbf:CTIPMOV := "Tiket"

            END IF

            /*
            Ahora comprobamos q no haya producto combinado
            */

      /*      IF !Empty( ::oTikeL:CCOMTIL )

               cRetCode := retCode( ::oTikeL:CCOMTIL, ::oDbfArt:cAlias )

               IF !Empty( cRetCode )                                                   .AND.;
                   cRetCode >= ::dInfIni .AND. cRetCode <= ::dFinInf                   .AND.;
                  !(lExcCero .AND. ::oTikeL:NPVPTIL == 0)

                  ::oDbf:Append()
                  ::oDbf:CCODCLI := ::oTiket:CCLITIK
                  ::oDbf:CCODALM := ::oTiket:CALMTIK
                  ::oDbf:CNOMCLI := ::oTiket:CNOMTIK
                  ::oDbf:DFECMOV := ::oTiket:DFECTIK

                  ::oDbf:NUNTENT := 0
                  ::oDbf:NUNTSAL := ::oTikeL:NUNTTIL
                  ::oDbf:CCODART := cRetCode
                  ::oDbf:CDOCMOV := ::oTiket:CSERTIK + "/" + ltrim( ::oTiket:CNUMTIK ) + "/" + ::oTiket:CSUFTIK
                  ::oDbf:CTIPMOV := "Tiket"

               END IF

            END IF

            ::oTikeL:Skip():Load()

         END WHILE

      END IF

      ::oTiket:Skip():Load()

      ::oMtrInf:AutoInc( ::oTiket:OrdKeyNo() )

      END WHILE */


   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//