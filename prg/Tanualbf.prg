#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TAnuAlbFam FROM TInfFam

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "No facturado", "Facturado", "Todos" }

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
   ::AddGroup( {|| ::oDbf:cCodFam }, {|| "Fam�lia : " + Rtrim( ::oDbf:cCodFam ) + "-" + oRetFld( ::oDbf:cCodFam, ::oDbfFam ) }, {||"Total fam�lia..."} )
   ::AddGroup( {|| ::oDbf:cCodFam + ::oDbf:cCodArt },    {|| "Art�culo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oDbfArt ) ) }, {||""} )

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

  oBlock       := ErrorBlock( {| oError | ApoloBreak( oError ) } )

  BEGIN SEQUENCE

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "AlbCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "AlbCLIL.CDX"
   ::oAlbCliL:SetOrder( "CREF" )

   DATABASE NEW ::oDbfCli  PATH ( cPatEmp() ) FILE "CLIENT.DBF" VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   DATABASE NEW ::oDbfArt  PATH ( cPatEmp() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   RECOVER USING oError

      lOpen := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   ::oAlbCliT:End()
   ::oAlbCliL:End()
   ::oDbfCli:End()
   ::oDbfArt:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld )

   local cEstado := "Todos"

   if !::StdResource( "INFGENFAM" )
      return .f.
   end if

   /*
   Monta los a�os
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

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local bValid   := {|| .t. }

   ::oDlg:Disable()
                                                  
   do case
      case ::oEstado:nAt == 1
         bValid   := {|| !lFacturado( ::oAlbCliT ) }
      case ::oEstado:nAt == 2
         bValid   := {|| Facturado( ::oAlbCliT ) }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

   /*
   Nos movemos por las cabeceras de los Albsupuestos a proveedores
	*/

   ::oDbf:Zap()

   ::oDbfArt:GoTop()
   WHILE !::oDbfArt:Eof()

      IF ::oDbfArt:Familia >= ::cFamOrg .AND.;
         ::oDbfArt:Familia <= ::cFamDes

         IF ::oAlbCliL:Seek( ::oDbfArt:Codigo )

            WHILE ::oAlbCliL:cRef = ::oDbfArt:Codigo .AND. !::oAlbCliL:Eof()

               if ::oAlbCliT:Seek( ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb )

                  if Eval ( bValid )                                                                     .AND.;
                     Year( ::oAlbCliT:dFecAlb ) == ::nYeaInf                                             .AND.;
                     ::oAlbCliL:CREF   >= ::cArtOrg                                                      .AND.;
                     ::oAlbCliL:CREF   <= ::cArtDes                                                      .AND.;
                     lChkSer( ::oAlbCliT:cSerAlb, ::aSer )                                               .AND.;
                     !( ::lExcCero .AND. nTotNAlbCli( ::oAlbCliL ) == 0 )

                     if !::oDbf:Seek( ::oDbfArt:Familia )
                        ::oDbf:Blank()
                        ::oDbf:cCodFam := ::oDbfArt:Familia
                        ::oDbf:cCodArt := ::oAlbCliL:cRef
                        ::oDbf:cNomArt := oRetFld( ::oAlbCliL:cRef, ::oDbfArt )
                        ::AddCliente( ::oAlbCliT:cCodCli, ::oAlbCliT, .f. )
                        ::oDbf:Insert()
                     end if

                     ::AddImporte( ::oAlbCliT:dFecAlb, nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )

                  end if

               end if

               ::oAlbCliL:Skip()

            end while

         end if

      end if

      ::oDbfArt:Skip()

      ::oMtrInf:AutoInc( ::oDbfArt:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oDbfArt:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//