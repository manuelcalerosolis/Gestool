#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TAnuTikGrp FROM TInfGrp

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT { "" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

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

   oBlock   := ErrorBlock( { | oError | ApoloBreak( oError ) }
   BEGIN SEQUENCE

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

METHod lResource( cFld )

   local cEstado := ""

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

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oTikCliT:Lastrec() )

RETURN .t.

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
   while !::oTikCliT:Eof()

      if ( ::oTikCliT:cTipTik == "1" .OR. ::oTikCliT:cTipTik == "4" )   .AND.;
         Year( ::oTikCliT:dFecTik ) == ::nYeaInf                        .AND.;
         lChkSer( ::oTikCliT:cSerTik, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oTikCliL:Seek( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik )

            while ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik == ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil .AND. !::oTikCliL:eof()

               if !Empty( ::oTikCliL:cCbaTil )                                                   .AND.;
                  cCodGruFam( ::oTikCliL:cCbaTil, ::oDbfArt, ::oDbfFam ) >= ::cGruFamOrg         .AND.;
                  cCodGruFam( ::oTikCliL:cCbaTil, ::oDbfArt, ::oDbfFam ) <= ::cGruFamDes         .AND.;
                  ::oTikCliL:cCbaTil >= ::cArtOrg                                                .AND.;
                  ::oTikCliL:cCbaTil <= ::cArtDes                                                .AND.;
                  !( ::lExcCero .AND. ::oTikCliL:nPvpTil == 0 )

                  if !::oDbf:Seek( cCodGruFam( ::oTikCliL:cCbaTil, ::oDbfArt, ::oDbfFam ) + ::oTikCliL:cCbaTil )
                     ::oDbf:Blank()
                     ::oDbf:cGrpFam := cCodGruFam( ::oTikCliL:cCbaTil, ::oDbfArt, ::oDbfFam )
                     ::oDbf:cCodArt := ::oTikCliL:cCbaTil
                     ::oDbf:cNomArt := oRetFld( ::oTikCliL:cCbaTil, ::oDbfArt )
                     ::AddCliente( ::oTikCLiT:cCliTik, ::oTikCLiT, .t. )
                     ::oDbf:Insert()
                  end if

                  ::AddImporte( ::oTikCliT:dFecTik, nImpLTpv( ::oTikCliT, ::oTikCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )

               end if

               /*
               Productos combinados--------------------------------------------
               */

               if !Empty( ::oTikCliL:cComTil )                                                  .AND.;
                  cCodGruFam( ::oTikCliL:cComTil, ::oDbfArt, ::oDbfFam ) >= ::cGruFamOrg        .AND.;
                  cCodGruFam( ::oTikCliL:cComTil, ::oDbfArt, ::oDbfFam ) <= ::cGruFamDes        .AND.;
                  ::oTikCliL:cComTil >= ::cArtOrg                                               .AND.;
                  ::oTikCliL:cComTil <= ::cArtDes                                               .AND.;
                  !( ::lExcCero .AND. ::oTikeL:nPcmTil == 0 )

                  if !::oDbf:Seek( cCodGruFam( ::oTikCliL:cComTil, ::oDbfArt, ::oDbfFam ) + ::oTikCliL:cComTil )
                     ::oDbf:Blank()
                     ::oDbf:cGrpFam := cCodGruFam( ::oTikCliL:cComTil, ::oDbfArt, ::oDbfFam )
                     ::oDbf:cCodArt := ::oTikCliL:cComTil
                     ::oDbf:cNomArt := oRetFld( ::oTikCliL:cComTil, ::oDbfArt )
                     ::AddCliente( ::oTikCliT:cCliTik, ::oTikCLiT, .t. )
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

   ::oMtrInf:AutoInc( ::oTikCliT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//