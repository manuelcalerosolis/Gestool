#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TGrpInfVta FROM TInfGrp

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

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::DetalleCreateFields()

   ::AddTmpIndex( "cGrpFam", "cGrpFam + CCODART" )
   ::AddGroup( {|| ::oDbf:cGrpFam },                     {|| "Grupo de familia  : " + Rtrim( ::oDbf:cGrpFam ) + "-" + oRetFld( ::oDbf:cGrpFam, ::oGruFam:oDbf ) },  {||"Total grupos de familias ..."} )
   ::AddGroup( {|| ::oDbf:cGrpFam + ::oDbf:cCodArt },    {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + oRetFld( ::oDbf:cCodArt, ::oDbfArt ) },  {||"Total articulo..."} )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

  local oBlock
  local oError
  local lOpen := .t.

   /*
   Ficheros necesarios
   */

   oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oTikeT PATH ( cPatEmp() ) FILE "TIKET.DBF" VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikeL PATH ( cPatEmp() ) FILE "TIKEL.DBF" VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oDbfCli PATH ( cPatEmp() ) FILE "CLIENT.DBF" VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   DATABASE NEW ::oDbfArt PATH ( cPatEmp() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   DATABASE NEW ::oDbfFam PATH ( cPatEmp() ) FILE "FAMILIAS.DBF" VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

   RECOVER USING oError

      lOpen := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

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

   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   if !Empty( ::oDbfFam ) .and. ::oDbfFam:Used()
      ::oDbfFam:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld )

   if !::StdResource( "INFGRPVEN" )
      return .f.
   end if

   /*
   Monta los grupos de familias de manera automatica
   */

   ::oDefGrFInf( 70, 80, 90, 100 )

   /*
   Monta los articulos de manera automatica
   */

   ::lDefArtInf( 110, 120, 130, 140 )

   ::oDefExcInf()

   ::oDefResInf()

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   ::oDlg:Disable()

   ::oDbf:Zap()
   ::oTikeT:GoTop()

   /*
   Damos valor al meter
   */

   ::oMtrInf:cText   := "Albaranes"
   ::oMtrInf:SetTotal( ::oAlbCliL:Lastrec() )

   /*
   Nos movemos por las lineas de los albaranes a proveedores
	*/

   ::oAlbCliL:GoTop()
   while ! ::oAlbCliL:Eof()

      if cCodGruFam( ::oAlbCliL:cRef, ::oDbfArt, ::oDbfFam ) >= ::cGruFamOrg            .AND.;
         cCodGruFam( ::oAlbCliL:cRef, ::oDbfArt, ::oDbfFam ) <= ::cGruFamDes

         if ::oAlbCliT:Seek( ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb )

             if ::oAlbCliT:DFECALB >= ::dIniInf                                         .AND.;
                ::oAlbCliT:DFECALB <= ::dFinInf                                         .AND.;
                ::oAlbCliL:cRef    >= ::cArtOrg                                         .AND.;
                ::oAlbCliL:cRef    <= ::cArtDes                                         .AND.;
                lChkSer( ::oAlbCliT:CSERALB, ::aSer )                                   .AND.;
                !( ::lExcCero .AND. ::oAlbCliL:NPREDIV == 0 )

                /*
                Viene de la clase padre
                */
                ::AddAlb()

             end if

         end if

      end if

      ::oAlbCliL:Skip()

      ::oMtrInf:AutoInc( ::oAlbCliL:OrdKeyNo() )

   end while

   /*
   Nos movemos por las lineas de los facturas a proveedores
	*/

   ::oMtrInf:cText   := "Facturas"
   ::oMtrInf:SetTotal( ::oFacCliL:Lastrec() )

   ::oFacCliL:GoTop()
   while !::OFacCliL:Eof()

      if cCodGruFam( ::oFacCliL:cRef, ::oDbfArt, ::oDbfFam ) >= ::cGruFamOrg .AND.;
         cCodGruFam( ::oFacCliL:cRef, ::oDbfArt, ::oDbfFam ) <= ::cGruFamDes

         if ::oFacCliT:Seek( ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac )

            if ::oFacCliT:DFECFAC >= ::dIniInf                                           .AND.;
               ::oFacCliT:DFECFAC <= ::dFinInf                                           .AND.;
               ::oFacCliL:cRef    >= ::cArtOrg                                           .AND.;
               ::oFacCliL:cRef    <= ::cArtDes                                           .AND.;
               lChkSer( ::oFacCliT:CSERIE, ::aSer )                                      .AND.;
               !( ::lExcCero .AND. ::oFacCliL:NPREDIV == 0 )

               /*
               Viene de la clase padre
               */
               ::AddFac()

            end if

         end if

      end if

      ::oFacCliL:Skip()

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
   WHILE !::oTikeT:Eof()

      if ( ::oTikeT:cTipTik == "1" .OR. ::oTikeT:cTipTik == "4" ) .AND.;
         ::oTikeT:dFecTik  >= ::dIniInf                           .AND.;
         ::oTikeT:dFecTik  <= ::dFinInf

         if ::oTikeL:Seek( ::oTikeT:CSERTIK +  ::oTikeT:CNUMTIK + ::oTikeT:CSUFTIK )

            while ::oTikeT:CSERTIK + ::oTikeT:CNUMTIK + ::oTikeT:CSUFTIK == ::oTikeL:CSERTIL + ::oTikeL:CNUMTIL + ::oTikeL:CSUFTIL .AND. !::oTikeL:eof()

               if !Empty( ::oTikeL:cCbaTil )                                                                  .AND.;
                  ::oTikeL:cCbaTil >= ::cArtOrg                                                               .AND.;
                  ::oTikeL:cCbaTil <= ::cArtDes                                                               .AND.;
                  cCodGruFam( ::oTikeL:cCbaTil, ::oDbfArt, ::oDbfFam )  >= ::cGruFamOrg                       .AND.;
                  cCodGruFam( ::oTikeL:cCbaTil, ::oDbfArt, ::oDbfFam )  <= ::cGruFamDes                       .AND.;
                  !( ::lExcCero .AND. ::oTikeL:nPvpTil == 0 )

                  /*
                  Viene de la clase padre
                  */
                  ::AddTik()

               end if

               if !Empty( ::oTikeL:cComTil )                                                                  .AND.;
                  ::oTikeL:cComTil >= ::cArtOrg                                                               .AND.;
                  ::oTikeL:cComTil <= ::cArtDes                                                               .AND.;
                  cCodGruFam( ::oTikeL:cComTil, ::oDbfArt, ::oDbfFam )  >= ::cGruFamOrg                       .AND.;
                  cCodGruFam( ::oTikeL:cComTil, ::oDbfArt, ::oDbfFam )  <= ::cGruFamDes                       .AND.;
                  !( ::lExcCero .AND. ::oTikeL:nPvpTil == 0 )

                  /*
                  Viene de la clase padre
                  */
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