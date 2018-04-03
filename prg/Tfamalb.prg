#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfFamAlb FROM TInfFam

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "No facturado", "Facturado", "Todos" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()


END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::DetCreateFields()

   ::AddTmpIndex( "CCODFAM", "cCodFam + CCODART" )
   ::AddGroup( {|| ::oDbf:cCodFam }, {|| "Familia  : " + Rtrim( ::oDbf:cCodFam ) + "-" + oRetFld( ::oDbf:cCodFam, ::oDbfFam ) }, {||"Total familia..."} )
   ::AddGroup( {|| ::oDbf:cCodFam + ::oDbf:cCodArt },    {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oDbfArt ) ) }, {||""} )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TInfFamAlb

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

   DATABASE NEW ::oDbfArt PATH ( cPatEmp() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   RECOVER USING oError

      lOpen := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TInfFamAlb

   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if

   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if

   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TInfFamAlb

   local cEstado := "Todos"

   if !::StdResource( "INF_GEN11" )
      return .f.
   end if

   /*
   Monta familias
   */

   ::lDefFamInf( 110, 120, 130, 140 )

   /*
   Monta los articulos de manera automatica
   */

   ::lDefArtInf( 70, 80, 90, 100 )

   /*
   Meter
   */

   ::oMtrInf:SetTotal( ::oDbfArt:Lastrec() )

   ::oDefExcInf(204)

   ::oDefSalInf(201)

   ::oDefResInf()

   REDEFINE CHECKBOX ::lExcMov ;
      ID       ( 203 );
      OF       ::oFld:aDialogs[1]

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

METHOD lGenerate() CLASS TInfFamAlb

   local bValid   := {|| .t. }
   local cCodFam

   ::oDlg:Disable()

   ::oDbf:Zap()

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| !lFacturado( ::oAlbCliT ) }
      case ::oEstado:nAt == 2
         bValid   := {|| lFacturado( ::oAlbCliT ) }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

   ::aHeader   := {  {|| "Fecha  : " + Dtoc( Date() ) },;
                     {|| "Periodo: " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Familia: " + AllTrim ( ::cFamOrg )  + " > " + AllTrim ( ::cFamDes ) },;
                     {|| "Estado : " + ::aEstado[ ::oEstado:nAt ] } }

   ::oAlbCliL:GoTop()

   WHILE !::oAlbCliL:Eof()

      cCodFam := cCodFam( ::oAlbcliL:cRef, ::oDbfArt )

      if cCodFam >= ::cFamOrg                                                          .AND.;
         cCodFam <= ::cFamDes

         if ::oAlbCliT:Seek( ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb )

            if Eval ( bValid )                                                         .AND.;
               ::oAlbCliT:DFECALB >= ::dIniInf                                         .AND.;
               ::oAlbCliT:DFECALB <= ::dFinInf                                         .AND.;
               ::oAlbCliL:cRef    >= ::cArtOrg                                         .AND.;
               ::oAlbCliL:cRef    <= ::cArtDes                                         .AND.;
               lChkSer( ::oAlbCliT:CSERALB, ::aSer )                                   .AND.;
               !( ::lExcCero .AND. ::oAlbCliL:NPREDIV == 0 )

               /*
               Añadimos un nuevo registro
               */

               ::AddAlb( ::oDbfArt:FAMILIA )

            end if

         end if

      end if

      ::oAlbCliL:Skip()
      ::oMtrInf:AutoInc( ::oAlbCliL:OrdKeyNo() )

   END WHILE

   ::oMtrInf:AutoInc( ::oAlbCliL:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )


//---------------------------------------------------------------------------//