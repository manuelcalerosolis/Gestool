#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TAnuFacFam FROM TInfFam

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendientes", "Cobradas", "Todas" }

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

METHOD OpenFiles()

  local oBlock
  local oError
  local lOpen := .t.

   /*
   Ficheros necesarios
   */

   oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FacCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FacCLIL.CDX"
   ::oFacCliL:SetOrder( "CREF" )

   DATABASE NEW ::oDbfCli  PATH ( cPatCli() ) FILE "CLIENT.DBF" VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   DATABASE NEW ::oDbfArt  PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   RECOVER USING oError

      lOpen := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   ::oFacCliT:End()
   ::oFacCliL:End()
   ::oDbfCli:End()
   ::oDbfArt:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld )

   local cEstado := "Todas"

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
         bValid   := {|| !::oFacCliT:lLiquidada }
      case ::oEstado:nAt == 2
         bValid   := {|| ::oFacCliT:lLiquidada }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

   /*
   Nos movemos por las cabeceras de los Facsupuestos a proveedores
	*/

   ::oDbf:Zap()

   ::oDbfArt:GoTop()
   WHILE !::oDbfArt:Eof()

      IF ::oDbfArt:Familia >= ::cFamOrg .AND.;
         ::oDbfArt:Familia <= ::cFamDes

         IF ::oFacCliL:Seek( ::oDbfArt:Codigo )

            WHILE ::oFacCliL:cRef = ::oDbfArt:Codigo .AND. !::oFacCliL:Eof()

               if ::oFacCliT:Seek( ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac )

                  if Eval ( bValid )                                                                     .AND.;
                     Year( ::oFacCliT:dFecFac ) == ::nYeaInf                                             .AND.;
                     ::oFacCliL:CREF   >= ::cArtOrg                                                      .AND.;
                     ::oFacCliL:CREF   <= ::cArtDes                                                      .AND.;
                     lChkSer( ::oFacCliT:cSerie, ::aSer )                                                .AND.;
                     !( ::lExcCero .AND. nTotNFacCli( ::oFacCliL ) == 0 )

                     if !::oDbf:Seek( ::oDbfArt:Familia )
                        ::oDbf:Blank()
                        ::oDbf:cCodFam := ::oDbfArt:Familia
                        ::oDbf:cCodArt := ::oFacCliL:cRef
                        ::oDbf:cNomArt := oRetFld( ::oFacCliL:cRef, ::oDbfArt )
                        ::AddCliente( ::oFacCliT:cCodCli, ::oFacCliT, .f. )
                        ::oDbf:Insert()
                     end if

                     ::AddImporte( ::oFacCliT:dFecFac, nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )

                  end if

               end if

               ::oFacCliL:Skip()

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