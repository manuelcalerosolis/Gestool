#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfGrfAlb FROM TInfGrp

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  aMes        AS ARRAY    INIT {.f., .f., .f., .f., .f., .f., .f., .f., .f., .f., .f., .f. }
   DATA  lAno        AS LOGIC    INIT .f.
   DATA  aEstado     AS ARRAY    INIT { "No facturado", "Facturado", "Todos" }

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

METHOD OpenFiles() CLASS TInfGrfAlb

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
   ::oAlbCliL:SetOrder( "CREF" )

   DATABASE NEW ::oDbfFam PATH ( cPatArt() ) FILE "FAMILIAS.DBF" VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

   DATABASE NEW ::oDbfArt PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   RECOVER USING oError

      lOpen := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TInfGrfAlb

   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if

   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if

   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   if !Empty( ::oDbfFam ) .and. ::oDbfFam:Used()
      ::oDbfFam:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TInfGrfAlb

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

METHOD lGenerate() CLASS TInfGrfAlb

   local bValid   := {|| .t. }

   ::oDlg:Disable()

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| !::oAlbCliT:lEstado }
      case ::oEstado:nAt == 2
         bValid   := {|| ::oAlbCliT:lEstado }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

      ::oDbf:Zap()
      ::oDbfArt:GoTop()

   WHILE !::oDbfArt:Eof()

      IF cCodGruFam( ::oDbfArt:Codigo, ::oDbfArt, ::oDbfFam ) >= ::cGruFamOrg .AND.;
         cCodGruFam( ::oDbfArt:Codigo, ::oDbfArt, ::oDbfFam ) <= ::cGruFamDes

         IF ::oAlbCliL:Seek( ::oDbfArt:Codigo )

                  WHILE ::oAlbCliL:CREF = ::oDbfArt:Codigo .AND. !::oAlbCliL:Eof()

                     IF ::oAlbCliT:Seek( ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb )

                        IF ::oAlbCliL:CREF   >= ::cArtOrg              .AND.;
                           ::oAlbCliL:CREF   <= ::cArtDes              .AND.;
                           ::oDbfFam:cCodGrp >= ::cGruFamOrg           .AND.;
                           ::oDbfFam:cCodGrp <= ::cGruFamDes           .AND.;
                           !( ::lExcCero .AND. nTotNAlbCli( ::oAlbCliL ) == 0 )

                           IF !::oDbf:Seek( ::oAlbCliL:cAlmLin + ::oAlbCliL:cRef )
                           ::oDbf:Blank()
                           ::oDbf:cGrpFam := cCodGruFam( ::oDbfArt:Codigo, ::oDbfArt, ::oDbfFam )
                           ::oDbf:cCodArt := ::oAlbCliL:cRef
                           ::oDbf:cNomArt := oRetFld( ::oAlbCliL:cRef, ::oDbfArt )
                           ::AddCliente( ::oAlbCliT:cCodCli, ::oAlbCliT, .f. )
                           ::oDbf:Insert()
                           END IF
                           ::AddImporte( ::oAlbCliT:dFecAlb, nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )

                       END IF

                     END IF

                     ::oAlbCliL:Skip()
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