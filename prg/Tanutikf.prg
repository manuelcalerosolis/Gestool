#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TAnuFTik FROM TInfFam

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::FamAnuCreateFld()

   ::AddTmpIndex( "CCODFAM", "CCODFAM + CCODART" )
   ::AddGroup( {|| ::oDbf:cCodFam }, {|| "Família : " + Rtrim( ::oDbf:cCodFam ) + "-" + oRetFld( ::oDbf:cCodFam, ::oDbfFam ) }, {||"Total família..."} )
   ::AddGroup( {|| ::oDbf:cCodFam + ::oDbf:cCodArt },    {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oDbfArt ) ) }, {||""} )

   ::lDefFecInf   := .f.
   ::lDefGraph    := .t.


RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TAnuFTik

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

   DATABASE NEW ::oDbfArt PATH ( cPatEmp() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   RECOVER USING oError

      lOpen := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TAnuFTik

   if !Empty( ::oTikCliT ) .and. ::oTikCliT:Used()
      ::oTikCliT:End()
   end if

  if !Empty( ::oTikCliL ) .and. ::oTikCliL:Used()
      ::oTikCliL:End()
   end if

  if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld )

   local oEstado
   local cEstado := "Todos"

   if !::StdResource( "INFGENFAM" )
      return .f.
   end if

   /*
   Monta los años
   */

   ::oDefYea()

   /*
   Monta familias
   */

   ::lDefFamInf( 70, 80, 90, 100 )

   /*
   Monta los articulos de manera automatica
   */

   ::lDefArtInf( 110, 120, 130, 140 )

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oDbfArt:Lastrec() )

   ::oDefExcInf()

   ::oDefResInf()

   REDEFINE COMBOBOX oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    { "Todos" } ;
      OF       ::oFld:aDialogs[1]

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cCodFam

   ::oDlg:Disable()

   /*
   Nos movemos por las cabeceras de los Tiksupuestos a proveedores
	*/

   ::oDbf:Zap()

   ::oTikCliT:GoTop()

   while !::oTikCliT:Eof()

      if ( ::oTikCliT:cTipTik == "1" .OR. ::oTikCliT:cTipTik == "4" )   .AND.;
         Year( ::oTikCliT:dFecTik ) == ::nYeaInf                        .AND.;
         lChkSer( ::oTikCliT:cSerTik, ::aSer )

         if ::oTikCliL:Seek( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik )

            while ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik == ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil .AND. !::oTikCliL:eof()

               cCodFam := cCodFam( ::oTikCliL:cCbaTil, ::oDbfArt )

               if !Empty( ::oTikCliL:cCbaTil )                                                   .AND.;
                  cCodFam >= ::cFamOrg                                                           .AND.;
                  cCodFam <= ::cFamDes                                                           .AND.;
                  ::oTikCliL:cCbaTil >= ::cArtOrg                                                .AND.;
                  ::oTikCliL:cCbaTil <= ::cArtDes                                                .AND.;
                  !( ::lExcCero .AND. ::oTikCliL:nPvpTil == 0 )

                     if !::oDbf:Seek( cCodFam + ::oTikCliL:cCbaTil )
                        ::oDbf:Blank()
                        ::oDbf:cCodFam := cCodFam
                        ::oDbf:cNomArt := cNomFam( cCodFam , ::oDbfFam )
                        ::oDbf:cCodArt := ::oTikCliL:cCbaTil
                        ::AddCliente( ::oTikCliT:CCLITIK, ::oTikCliT, .t. )
                        ::oDbf:Insert()
                     end if

                     ::AddImporte( ::oTikCliT:dFecTik, nImpLTpv( ::oTikCliT, ::oTikCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )

               end if

               cCodFam := cCodFam( ::oTikCliL:cComTil, ::oDbfArt )

               if !Empty( ::oTikCliL:cComTil )                                                   .AND.;
                  cCodFam >= ::cFamOrg                                                           .AND.;
                  cCodFam <= ::cFamDes                                                           .AND.;
                  ::oTikCliL:cComTil >= ::cArtOrg                                                .AND.;
                  ::oTikCliL:cComTil <= ::cArtDes                                                .AND.;
                  !( ::lExcCero .AND. ::oTikCliL:nPvpTil == 0 )

                     if !::oDbf:Seek( cCodFam + ::oTikCliL:cCbaTil )
                        ::oDbf:Blank()
                        ::oDbf:cCodFam := cCodFam
                        ::oDbf:cNomArt := cNomFam( cCodFam, ::oDbfFam )
                        ::oDbf:cCodArt := ::oTikCliL:cComTil
                        ::AddCliente( ::oTikCliT:CCLITIK, ::oTikCliT, .t. )
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