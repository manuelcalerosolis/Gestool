#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TAnuPreFam FROM TInfFam

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oPreCliT    AS OBJECT
   DATA  oPreCliL    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Aceptado", "Todos" }

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

   ::oPreCliT  := TDataCenter():oPreCliT()

   DATABASE NEW ::oPreCliL PATH ( cPatEmp() ) FILE "PRECLIL.DBF" VIA ( cDriver() ) SHARED INDEX "PRECLIL.CDX"
   ::oPreCliL:SetOrder( "CREF" )

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

   ::oPreCliT:End()
   ::oPreCliL:End()
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
         bValid   := {|| !::oPreCliT:lEstado }
      case ::oEstado:nAt == 2
         bValid   := {|| ::oPreCliT:lEstado }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

   /*
   Nos movemos por las cabeceras de los presupuestos a proveedores
	*/

   ::oDbf:Zap()

   ::oDbfArt:GoTop()
   WHILE !::oDbfArt:Eof()

      IF ::oDbfArt:Familia >= ::cFamOrg .AND.;
         ::oDbfArt:Familia <= ::cFamDes

         IF ::oPreCliL:Seek( ::oDbfArt:Codigo )

            WHILE ::oPreCliL:cRef = ::oDbfArt:Codigo .AND. !::oPreCliL:Eof()

               if ::oPreCliT:Seek( ::oPreCliL:cSerPre + Str( ::oPreCliL:nNumPre ) + ::oPreCliL:cSufPre )

                  if Eval ( bValid )                                           .AND.;
                     Year( ::oPreCliT:DFECPRE ) == ::nYeaInf                   .AND.;
                     ::oPreCliL:CREF   >= ::cArtOrg                            .AND.;
                     ::oPreCliL:CREF   <= ::cArtDes                            .AND.;
                     lChkSer( ::oPreCliT:CSERPRE, ::aSer )                     .AND.;
                     !( ::lExcCero .AND. nTotNPreCli( ::oPreCliL ) == 0 )

                     if !::oDbf:Seek( ::oDbfArt:Familia )
                        ::oDbf:Blank()
                        ::oDbf:cCodFam := ::oDbfArt:Familia
                        ::oDbf:cCodArt := ::oPreCliL:cRef
                        ::oDbf:cNomArt := oRetFld( ::oPreCliL:cRef, ::oDbfArt )
                        ::AddCliente( ::oPreCliT:cCodCli, ::oPreCliT, .f. )
                        ::oDbf:Insert()
                     end if

                     ::AddImporte( ::oPreCliT:dFecPre, nImpLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )

                  end if

               end if

               ::oPreCliL:Skip()

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