#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TGrpAnuVta FROM TInfGrp

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT { "" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create ()

   ::GrupoAnuCreateFld()

   ::AddTmpIndex( "CGRPFAM", "CGRPFAM + CCODART " )
   ::AddGroup( {|| ::oDbf:cGrpFam }, {|| "Grupo de familia : " + Rtrim( ::oDbf:cGrpFam ) + "-" + oRetFld( ::oDbf:cGrpFam, ::oGruFam:oDbf) }, {||"Total grupo de familias..."} )
   ::AddGroup( {|| ::oDbf:cGrpFam + ::oDbf:cCodArt },    {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + oRetFld( ::oDbf:cCodArt, ::oDbfArt ) },  {||"Total articulo..."} )

   ::lDefFecInf   := .f.
   ::lDefGraph    := .t.

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

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) FILE "TIKET.DBF" VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) FILE "TIKEL.DBF" VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oDbfCli  PATH ( cPatEmp() ) FILE "CLIENT.DBF" VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

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

   if !Empty( ::oTikCliT ) .and. ::oTikCliT:Used()
      ::oTikCliT:End()
   end if

  if !Empty( ::oTikCliL ) .and. ::oTikCliL:Used()
      ::oTikCliL:End()
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

   if !::StdResource( "REGRPTIK" )
      return .f.
   end if

   /*
   Monta los años
   */

   ::oDefYea()

   /*
   Monta los grupos de familias de manera automatica
   */

   ::oDefGrFInf( 70, 80, 90, 100 )

   /*
   Monta los articulos de manera automatica
   */

   ::lDefArtInf( 110, 120, 130, 140 )

   ::oDefExcInf()


RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local nPreDiv

   ::oDlg:Disable()

   /*
   Nos movemos por las cabeceras de los pedidos
	*/

   ::oDbf:Zap()

   ::oTikCliT:GoTop()

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

      if Year( ::oAlbCliT:dFecAlb ) == ::nYeaInf                                            .AND.;
         lChkSer( ::oAlbCliT:CSERALB, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oAlbCliL:Seek( ::oAlbCliT:CSERALB + Str( ::oAlbCliT:NNUMALB ) + ::oAlbCliT:CSUFALB )

            while ::oAlbCliT:CSERALB + Str( ::oAlbCliT:NNUMALB ) + ::oAlbCliT:CSUFALB == ::oAlbCliL:CSERALB + Str( ::oAlbCliL:NNUMALB ) + ::oAlbCliL:CSUFALB .AND. ! ::oAlbCliL:eof()

               if ::oAlbCliL:CREF >= ::cArtOrg                                                   .AND.;
                  ::oAlbCliL:CREF <= ::cArtDes                                                   .AND.;
                  cCodGruFam( ::oAlbCliL:CREF, ::oDbfArt, ::oDbfFam ) >= ::cGruFamOrg            .AND.;
                  cCodGruFam( ::oAlbCliL:CREF, ::oDbfArt, ::oDbfFam ) <= ::cGruFamDes            .AND.;
                  !( ::lExcCero .AND. nTotNAlbCli( ::oAlbCliL ) == 0 )

                  if !::oDbf:Seek( ::oAlbCliT:cCodAlm + ::oAlbCliL:cRef )
                     ::oDbf:Blank()
                     ::oDbf:cGrpFam := cCodGruFam( ::oAlbCliL:CREF, ::oDbfArt, ::oDbfFam )
                     ::oDbf:cCodArt := ::oAlbCliL:cRef
                     ::oDbf:cNomArt := oRetFld( ::oAlbCliL:cRef, ::oDbfArt )
                     ::AddCliente( ::oAlbCliT:cCodCli, ::oAlbCliT, .f. )
                     ::oDbf:Insert()
                  end if

                  ::AddImporte( ::oAlbCliT:dFecAlb, nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )
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

      if Year( ::oFacCliT:dFecFac ) == ::nYeaInf                             .AND.;
         lChkSer( ::oFacCliT:CSERIE, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oFacCliL:Seek( ::oFacCliT:CSERIE + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC )

            while ::oFacCliT:CSERIE + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC == ::oFacCliL:CSERIE + Str( ::oFacCliL:NNUMFAC ) + ::oFacCliL:CSUFFAC .AND. ! ::oFacCliL:eof()

               if ::oFacCliL:CREF >= ::cArtOrg                                                .AND.;
                  ::oFacCliL:CREF <= ::cArtDes                                                .AND.;
                  cCodGruFam( ::oFacCliL:CREF, ::oDbfArt, ::oDbfFam ) >= ::cGruFamOrg         .AND.;
                  cCodGruFam( ::oFacCliL:CREF, ::oDbfArt, ::oDbfFam ) <= ::cGruFamDes         .AND.;
                  !( ::lExcCero .AND. ( NotCaja( ::oFacCliL:nCanFac ) * ::oFacCliL:nUniCaje ) == 0 )

                  if !::oDbf:Seek( ::oFacCliT:cCodAlm + ::oFacCliL:cRef )
                     ::oDbf:Blank()
                     ::oDbf:cGrpFam := cCodGruFam( ::oFacCliL:CREF, ::oDbfArt, ::oDbfFam )
                     ::oDbf:cCodArt := ::oFacCliL:cRef
                     ::oDbf:cNomArt := oRetFld( ::oFacCliL:cRef, ::oDbfArt )
                     ::AddCliente( ::oFacCliT:cCodCli, ::oFacCliT, .f. )
                     ::oDbf:Insert()
                  end if

                  ::AddImporte( ::oFacCliT:dFecFac, nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )

               end if

               ::oFacCliL:Skip()

            end while

         end if

      end if

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   /*
   Damos valor al meter--------------------------------------------------------
   */

   ::oMtrInf:cText   := "Tickets"
   ::oMtrInf:SetTotal( ::oTikCliT:Lastrec() )

   ::oTikCliT:GoTop()
   while ! ::oTikCliT:Eof()

      if ( ::oTikCliT:cTipTik == "1" .OR. ::oTikCliT:cTipTik == "4" )   .AND.;
         Year( ::oTikCliT:dFecTik ) == ::nYeaInf                        .AND.;
         lChkSer( ::oTikCliT:cSerTik, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oTikCliL:Seek( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik )

            while ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik == ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil .AND. !::oTikCliL:eof()

               if !Empty( ::oTikCliL:cCbaTil )                                                     .AND.;
                  ::oTikCliL:cCbaTil >= ::cArtOrg                                                .AND.;
                  ::oTikCliL:cCbaTil <= ::cArtDes                                                .AND.;
                  cCodGruFam( ::oTikCliL:cCbaTil, ::oDbfArt, ::oDbfFam ) >= ::cGruFamOrg         .AND.;
                  cCodGruFam( ::oTikCliL:cCbaTil, ::oDbfArt, ::oDbfFam ) <= ::cGruFamDes         .AND.;
                  !( ::lExcCero .AND. ::oTikCliL:nPvpTil == 0 )

                  if !::oDbf:Seek( ::oTikCliL:cAlmLin + ::oTikCliL:cCbaTil )
                     ::oDbf:Blank()
                     ::oDbf:cGrpFam := cCodGruFam( ::oTikCliL:cCbaTil, ::oDbfArt, ::oDbfFam )
                     ::oDbf:cCodArt := ::oTikCliL:cCbaTil
                     ::oDbf:cNomArt := oRetFld( ::oTikCliL:cCbaTil, ::oDbfArt )
                     ::AddCliente( ::oTikCliT:cCliTik, ::oTikCliT, .t. )
                     ::oDbf:Insert()
                  end if

                  ::AddImporte( ::oTikCliT:dFecTik, nImpLTpv( ::oTikCliT, ::oTikCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )

               end if

               /*
               Productos combinados--------------------------------------------
               */

               if !Empty( ::oTikCliL:cComTil )                                                     .AND.;
                  ::oTikCliL:cComTil >= ::cArtOrg                                                .AND.;
                  ::oTikCliL:cComTil <= ::cArtDes                                                .AND.;
                  cCodGruFam( ::oTikCliL:cComTil, ::oDbfArt, ::oDbfFam ) >= ::cGruFamOrg         .AND.;
                  cCodGruFam( ::oTikCliL:cComTil, ::oDbfArt, ::oDbfFam ) <= ::cGruFamDes         .AND.;
                  !( ::lExcCero .AND. ::oTikeL:nPcmTil == 0 )

                  if !::oDbf:Seek( cCodGruFam( ::oTikCliL:cComTil, ::oDbfArt, ::oDbfFam ) + ::oTikCliL:cComTil )
                     ::oDbf:Blank()
                     ::oDbf:cGrpFam := cCodGruFam( ::oTikCliL:cComTil, ::oDbfArt, ::oDbfFam )
                     ::oDbf:cCodArt := ::oTikCliL:cComTil
                     ::oDbf:cNomArt := oRetFld( ::oTikCliL:cComTil, ::oDbfArt )
                     ::AddCliente( ::oTikCliT:cCliTik, ::oTikCliT, .t. )
                     ::oDbf:Insert()
                  end if

                  ::AddImporte( ::oTikCliT:dFecTik, nImpLTpv( ::oTikCliT, ::oTikCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )

               end if

               ::oTikCliL:Skip()

            end while

         end if

      end if

      ::oTikCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oTikCliT:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//