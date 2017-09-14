#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfVta FROM TInfAlm

   DATA  nEstado     AS NUMERIC  INIT 1
   DATA  oTikeT      AS OBJECT
   DATA  oTikeL      AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::CreateFields()

   ::AddTmpIndex( "CCODALM", "CCODALM + CCODART" )
   ::AddGroup( {|| ::oDbf:cCodAlm },                     {|| "Almacén  : " + Rtrim( ::oDbf:cCodAlm ) + "-" + oRetFld( ::oDbf:cCodAlm, ::oDbfAlm ) },  {||"Total almacén ..."} )
   ::AddGroup( {|| ::oDbf:cCodAlm + ::oDbf:cCodArt },    {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + oRetFld( ::oDbf:cCodArt, ::oDbfArt ) },  {||"Total articulo..."} )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

    /*
   Ficheros necesarios
   */

   BEGIN SEQUENCE

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oTikeT PATH ( cPatEmp() ) FILE "TIKET.DBF" VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikeL PATH ( cPatEmp() ) FILE "TIKEL.DBF" VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oDbfCli PATH ( cPatCli() ) FILE "CLIENT.DBF" VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oTikeT ) .and. ::oTikeT:Used()
      ::oTikeT:End()
   end if

   if !Empty( ::oTikeL ) .and. ::oTikeL:Used()
      ::oTikeL:End()
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

   if !Empty( ::oDbfCli ) .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld )

   if !::StdResource( "INF_GEN01A" )
      return .f.
   end if

   /*
   Monta los almacenes de manera automatica
   */

   ::oDefAlmInf( 70, 80, 90, 100 )

   /*
   Monta los articulos de manera automatica
   */

   ::lDefArtInf( 110, 120, 130, 140 )

   ::oDefExcInf()

   ::oDefResInf()

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   ::oDlg:Disable()

   ::oDbf:Zap()

   /*
   Damos valor al meter
   */

   ::oMtrInf:cText   := "Albaranes"
   ::oMtrInf:SetTotal( ::oAlbCliT:Lastrec() )

   /*
   Nos movemos por las cabeceras de los albaranes a proveedores
	*/

   ::oAlbCliT:GoTop()

   while ! ::oAlbCliT:Eof()

      if !lFacturado( ::oAlbCliT )                                                          .AND.;
         ::oAlbCliT:DFECALB >= ::dIniInf                                                    .AND.;
         ::oAlbCliT:DFECALB <= ::dFinInf                                                    .AND.;
         lChkSer( ::oAlbCliT:CSERALB, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oAlbCliL:Seek( ::oAlbCliT:CSERALB + Str( ::oAlbCliT:NNUMALB ) + ::oAlbCliT:CSUFALB )

            while ::oAlbCliT:CSERALB + Str( ::oAlbCliT:NNUMALB ) + ::oAlbCliT:CSUFALB == ::oAlbCliL:CSERALB + Str( ::oAlbCliL:NNUMALB ) + ::oAlbCliL:CSUFALB .AND. ! ::oAlbCliL:eof()

               if ::oAlbCliL:cRef >= ::cArtOrg                 .AND.;
                  ::oAlbCliL:cRef <= ::cArtDes                 .AND.;
                  ::oAlbCliL:cAlmLin >= ::cAlmOrg              .AND.;
                  ::oAlbCliL:cAlmLin <= ::cAlmDes              .AND.;
                  !( ::lExcCero .AND. nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0  )

                  /*
                  Viene de la clase padre
                  */

                  ::AddAlb()

               end if

               ::oAlbCliL:Skip()

            end while

         end if

      end if

      ::oAlbCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   /*
   Nos movemos por las cabeceras de los facturas a proveedores
	*/

   ::oMtrInf:cText   := "Facturas"
   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )

   ::oFacCliT:GoTop()

   while !::oFacCliT:Eof()

      if ::oFacCliT:DFECFAC >= ::dIniInf                                                    .AND.;
         ::oFacCliT:DFECFAC <= ::dFinInf                                                    .AND.;
         lChkSer( ::oFacCliT:CSERIE, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oFacCliL:Seek( ::oFacCliT:CSERIE + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC )

            while ::oFacCliT:CSERIE + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC == ::oFacCliL:CSERIE + Str( ::oFacCliL:NNUMFAC ) + ::oFacCliL:CSUFFAC .AND. ! ::oFacCliL:eof()

               if ::oFacCliL:CREF >= ::cArtOrg                 .AND.;
                  ::oFacCliL:CREF <= ::cArtDes                 .AND.;
                  ::oFacCliL:cAlmLin >= ::cAlmOrg              .AND.;
                  ::oFacCliL:cAlmLin <= ::cAlmDes              .AND.;
                  !( ::lExcCero .AND. ::oFacCliL:NUNICAJA == 0 )

                  /*
                  Viene de la clase padre
                  */

                  ::AddFac()

               end if

               ::oFacCliL:Skip()

            end while

         end if

      end if

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   /*
   Damos valor al meter
   */

   ::oMtrInf:cText   := "Tickets"
   ::oMtrInf:SetTotal( ::oTikeT:Lastrec() )

   /*
   Nos movemos por las cabeceras de los pedidos a proveedores
	*/
   ::oTikeT:GoTop()

   WHILE ! ::oTikeT:Eof()

      if ( ::oTikeT:cTipTik == "1" .OR. ::OTikeT:cTipTik == "4" ) .AND.;
         ::oTikeT:DFECTIK >= ::dIniInf                            .AND.;
         ::oTikeT:DFECTIK <= ::dFinInf

         if ::oTikeL:Seek( ::oTikeT:CSERTIK +  ::oTikeT:CNUMTIK + ::oTikeT:CSUFTIK )

            /*
            Posicionamos en las lineas de detalle --------------------------------
            */

            while ::oTikeT:CSERTIK + ::oTikeT:CNUMTIK + ::oTikeT:CSUFTIK == ::oTikeL:CSERTIL + ::oTikeL:CNUMTIL + ::oTikeL:CSUFTIL .AND. !::oTikeL:eof()

               if !Empty( ::oTikeL:cCbaTil )                      .AND.;
                  ::oTikeL:cCbaTil >= ::cArtOrg                   .AND.;
                  ::oTikeL:cCbaTil <= ::cArtDes                   .AND.;
                  ::oTikeL:cAlmLin >= ::cAlmOrg                   .AND.;
                  ::oTikeL:cAlmLin <= ::cAlmDes                   .AND.;
                  !( ::lExcCero .AND. ::oTikeL:nPvpTil == 0 )

                  ::AddTik()

               end if

               /*
               Para los productos combinados-----------------------------------
               */

               if !Empty( ::oTikeL:cComTil )                    .AND.;
                  ::oTikeL:cComTil >= ::cArtOrg                 .AND.;
                  ::oTikeL:cComTil <= ::cArtDes                 .AND.;
                  ::oTikeL:cAlmLin >= ::cAlmOrg                 .AND.;
                  ::oTikeL:cAlmLin <= ::cAlmDes                 .AND.;
                  !( ::lExcCero .AND. ::oTikeL:nPvpTil == 0 )

                  ::AddTik()

               end if

               ::oTikeL:Skip()

            end while

         end if

      end if

      ::oTikeT:Skip()

      ::oMtrInf:AutoInc( ::oTikeT:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oTikeT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//