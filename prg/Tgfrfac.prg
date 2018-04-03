#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfGrfFac FROM TInfGrp

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  aMes        AS ARRAY    INIT {.f., .f., .f., .f., .f., .f., .f., .f., .f., .f., .f., .f. }
   DATA  lAno        AS LOGIC    INIT .f.
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Liquidada", "Todas" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()


END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::GrupoAnuCreateFld()

   ::AddTmpIndex( "CGRPFAM", "CGRPFAM" )

   ::AddGroup( {|| ::oDbf:cGrpFam }, {|| "Grupo de familia : " + Rtrim( ::oDbf:cGrpFam ) + "-" + oRetFld( ::oDbf:cGrpFam, ::oGruFam:oDbf) }, {||"Total grupo de familias..."} )
   ::AddGroup( {|| ::oDbf:cGrpFam + ::oDbf:cCodArt },    {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + oRetFld( ::oDbf:cCodArt, ::oDbfArt ) },  {||"Total articulo..."} )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TInfGrfFac

  local oBlock
  local oError
  local lOpen := .t.

    /*
   Ficheros necesarios
   */

   oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"
   ::oFacCliL:SetOrder( "CREF" )

   DATABASE NEW ::oDbfFam PATH ( cPatEmp() ) FILE "FAMILIAS.DBF" VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

   DATABASE NEW ::oDbfArt PATH ( cPatEmp() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   RECOVER USING oError

      lOpen := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TInfGrfFac

   if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if

   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if

   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   if !Empty( ::oDbfFam ) .and. ::oDbfFam:Used()
      ::oDbfFam:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TInfGrfFac

   local cEstado := "Todas"

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

METHOD lGenerate() CLASS TInfGrfFac

   local bValid   := {|| .t. }

   ::oDlg:Disable()

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| !::oFacCliT:lEstado }
      case ::oEstado:nAt == 2
         bValid   := {|| ::oFacCliT:lEstado }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

      ::oDbf:Zap()
      ::oDbfArt:GoTop()

   WHILE !::oDbfArt:Eof()

      IF cCodGruFam( ::oDbfArt:Codigo, ::oDbfArt, ::oDbfFam ) >= ::cGruFamOrg .AND.;
         cCodGruFam( ::oDbfArt:Codigo, ::oDbfArt, ::oDbfFam ) <= ::cGruFamDes

         IF ::oFacCliL:Seek( ::oDbfArt:Codigo )

                  WHILE ::oFacCliL:CREF = ::oDbfArt:Codigo .AND. !::oFacCliL:Eof()

                     IF ::oFacCliT:Seek( ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac )

                        IF ::oFacCliL:CREF   >= ::cArtOrg              .AND.;
                           ::oFacCliL:CREF   <= ::cArtDes              .AND.;
                           ::oDbfFam:cCodGrp >= ::cGruFamOrg           .AND.;
                           ::oDbfFam:cCodGrp <= ::cGruFamDes           .AND.;
                           !( ::lExcCero .AND. nTotNFacCli( ::oFacCliL ) == 0 )

                           IF !::oDbf:Seek( ::oFacCliL:cAlmLin + ::oFacCliL:cRef )
                           ::oDbf:Blank()
                           ::oDbf:cGrpFam := cCodGruFam( ::oDbfArt:Codigo, ::oDbfArt, ::oDbfFam )
                           ::oDbf:cCodArt := ::oFacCliL:cRef
                           ::oDbf:cNomArt := oRetFld( ::oFacCliL:cRef, ::oDbfArt )
                           ::AddCliente( ::oFacCliT:cCodCli, ::oFacCliT, .f. )
                           ::oDbf:Insert()
                           END IF
                           ::AddImporte( ::oFacCliT:dFecFac, nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )

                       END IF

                     END IF

                     ::oFacCliL:Skip()
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