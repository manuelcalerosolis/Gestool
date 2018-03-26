#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TAnuPedFam FROM TInfFam

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oPedCliT    AS OBJECT
   DATA  oPedCliL    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Parcialmente", "Entregado", "Todos" }

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

   ::oPedCliT := TDataCenter():oPedCliT()

   DATABASE NEW ::oPedCliL PATH ( cPatEmp() ) FILE "PedCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "PedCLIL.CDX"
   ::oPedCliL:SetOrder( "CREF" )

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

   ::oPedCliT:End()
   ::oPedCliL:End()
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
         bValid   := {|| ::oPedCliT:nEstado == 1 }
      case ::oEstado:nAt == 2
         bValid   := {|| ::oPedCliT:nEstado == 2 }
      case ::oEstado:nAt == 3
         bValid   := {|| ::oPedCliT:nEstado == 3 }
      case ::oEstado:nAt == 4
         bValid   := {|| .t. }
   end case

   /*
   Nos movemos por las cabeceras de los Pedsupuestos a proveedores
	*/

   ::oDbf:Zap()

   ::oDbfArt:GoTop()
   WHILE !::oDbfArt:Eof()

      IF ::oDbfArt:Familia >= ::cFamOrg .AND.;
         ::oDbfArt:Familia <= ::cFamDes

         IF ::oPedCliL:Seek( ::oDbfArt:Codigo )

            WHILE ::oPedCliL:cRef = ::oDbfArt:Codigo .AND. !::oPedCliL:Eof()

               if ::oPedCliT:Seek( ::oPedCliL:cSerPed + Str( ::oPedCliL:nNumPed ) + ::oPedCliL:cSufPed )

                  if Eval ( bValid )                                                                     .AND.;
                     Year( ::oPedCliT:dFecPed ) == ::nYeaInf                                             .AND.;
                     ::oPedCliL:CREF   >= ::cArtOrg                                                      .AND.;
                     ::oPedCliL:CREF   <= ::cArtDes                                                      .AND.;
                     lChkSer( ::oPedCliT:cSerPed, ::aSer )                                               .AND.;
                     !( ::lExcCero .AND. nTotNPedCli( ::oPedCliL ) == 0 )

                     if !::oDbf:Seek( ::oDbfArt:Familia )
                        ::oDbf:Blank()
                        ::oDbf:cCodFam := ::oDbfArt:Familia
                        ::oDbf:cCodArt := ::oPedCliL:cRef
                        ::oDbf:cNomArt := oRetFld( ::oPedCliL:cRef, ::oDbfArt )
                        ::AddCliente( ::oPedCliT:cCodCli, ::oPedCliT, .f. )
                        ::oDbf:Insert()
                     end if

                     ::AddImporte( ::oPedCliT:dFecPed, nImpLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )

                  end if

               end if

               ::oPedCliL:Skip()

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