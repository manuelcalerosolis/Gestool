#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfGrfpre FROM TInfGrp

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oPreCliT    AS OBJECT
   DATA  oPreCliL    AS OBJECT
   DATA  aMes        AS ARRAY    INIT {.f., .f., .f., .f., .f., .f., .f., .f., .f., .f., .f., .f. }
   DATA  lAno        AS LOGIC    INIT .f.
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Aceptado", "Todos" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()


END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::GrupoAnuCreateFld()

   ::AddTmpIndex ( "CGRPFAM", "CGRPFAM + CCODART" )
   ::AddGroup( {|| ::oDbf:cGrpFam }, {|| "Grupo de familia : " + Rtrim( ::oDbf:cGrpFam ) + "-" + oRetFld( ::oDbf:cGrpFam, ::oGruFam:oDbf) }, {||"Total grupo de familias..."} )
   ::AddGroup( {|| ::oDbf:cGrpFam + ::oDbf:cCodArt },    {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + oRetFld( ::oDbf:cCodArt, ::oDbfArt ) },  {||"Total articulo..."} )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TInfGrfpre

   /*
   Ficheros necesarios
   */

   ::oPreCliT  := TDataCenter():oPreCliT()

   DATABASE NEW ::oPreCliL PATH ( cPatEmp() ) FILE "PRECLIL.DBF" VIA ( cDriver() ) SHARED INDEX "PRECLIL.CDX"
   ::oPreCliL:SetOrder( "CREF" )

   DATABASE NEW ::oDbfFam PATH ( cPatEmp() ) FILE "FAMILIAS.DBF" VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

   DATABASE NEW ::oDbfArt PATH ( cPatEmp() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TInfGrfpre

   ::oPreCliT:End()
   ::oPreCliL:End()
   ::oDbfArt:End()
   ::oDbfFam:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TInfGrfpre

   local cEstado := "Todos"

   ::lDefFecInf   := .f.

   if !::StdResource( "InfAnuGrp" )
      return .f.
   end if

   /* Montar Grupos de familias */

   ::oDefGrFInf( 70, 80, 90, 100 )

   /*
   Monta los articulos de manera automatica
   */

   ::lDefArtInf( 110, 120, 130, 140 )

   /* Meter */

   ::oMtrInf:SetTotal( ::oDbfArt:Lastrec() )

   /*
   Monta los años
   */

   ::oDefYea( )


   ::oDefExcInf(200)

   ::oDefResInf(190)

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]


RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TInfGrfpre

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

      ::oDbf:Zap()
      ::oDbfArt:GoTop()

   WHILE !::oDbfArt:Eof()

      IF cCodGruFam( ::oDbfArt:Codigo, ::oDbfArt, ::oDbfFam ) >= ::cGruFamOrg .AND.;
         cCodGruFam( ::oDbfArt:Codigo, ::oDbfArt, ::oDbfFam ) <= ::cGruFamDes

         IF ::oPreCliL:Seek( ::oDbfArt:Codigo )

                  WHILE ::oPreCliL:CREF = ::oDbfArt:Codigo .AND. !::oPreCliL:Eof()

                     IF ::oPreCliT:Seek( ::oPreCliL:cSerPre + Str( ::oPreCliL:nNumPre ) + ::oPreCliL:cSufPre )

                        IF ::oPreCliL:CREF   >= ::cArtOrg              .AND.;
                           ::oPreCliL:CREF   <= ::cArtDes              .AND.;
                           ::oDbfFam:cCodGrp >= ::cGruFamOrg           .AND.;
                           ::oDbfFam:cCodGrp <= ::cGruFamDes           .AND.;
                           !( ::lExcCero .AND. nTotNPreCli( ::oPreCliL ) == 0 )

                           IF !::oDbf:Seek( ::oPreCliL:cAlmLin + ::oPreCliL:cRef )
                           ::oDbf:Blank()
                           ::oDbf:cGrpFam := cCodGruFam( ::oDbfArt:Codigo, ::oDbfArt, ::oDbfFam )
                           ::oDbf:cCodArt := ::oPreCliL:cRef
                           ::oDbf:cNomArt := oRetFld( ::oPreCliL:cRef, ::oDbfArt )
                           ::AddCliente( ::oPreCliT:cCodCli, ::oPreCliT, .f. )
                           ::oDbf:Insert()
                           END IF
                           ::AddImporte( ::oPreCliT:dFecPre, nImpLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )

                       END IF

                     END IF

                     ::oPreCliL:Skip()
                     ::oMtrInf:AutoInc( ::oDbfArt:OrdKeyNo() )

               END WHILE

           END IF

         END IF

      ::oDbfArt:Skip()
      ::oMtrInf:AutoInc( ::oDbfArt:OrdKeyNo() )

   END WHILE

   ::oMtrInf:AutoInc( ::oDbfArt:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//