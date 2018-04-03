#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfFamTik FROM TInfFam

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT

   METHOD Create ()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create ()

   ::DetCreateFields()

   ::AddTmpIndex( "CCODFAM", "cCodFam + CCODART" )
   ::AddGroup( {|| ::oDbf:cCodFam }, {|| "Familia  : " + Rtrim( ::oDbf:cCodFam ) + "-" + oRetFld( ::oDbf:cCodFam, ::oDbfFam ) }, {||"Total familia..."} )
   ::AddGroup( {|| ::oDbf:cCodFam + ::oDbf:cCodArt },    {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oDbfArt ) ) }, {||""} )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TInfFamTik

  local oBlock
  local oError
  local lOpen := .t.

    /*
   Ficheros necesarios
   */

   oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) FILE "TIKET.DBF" VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) FILE "TIKEL.DBF" VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"
   ::oTikCliL:SetOrder( "CCBATIL" )

   DATABASE NEW ::oDbfArt PATH ( cPatEmp() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   RECOVER USING oError

      lOpen := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TInfFamTik

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

METHOD Resource( cFld ) CLASS TInfFamTik

   if !::StdResource( "INF_GEN11D" )
      return .f.
   end if

   /* Monta familias */

   ::lDefFamInf( 110, 120, 130, 140 )

   /*
   Monta los articulos de manera automatica
   */

   ::lDefArtInf( 70, 80, 90, 100 )

   /* Meter */

   ::oMtrInf:SetTotal( ::oDbfArt:Lastrec() )

   ::oDefExcInf(204)

   ::oDefSalInf(201)

   ::oDefResInf()

   REDEFINE CHECKBOX ::lExcMov ;
      ID       ( 203 );
      OF       ::oFld:aDialogs[1]


RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TInfFamTik

   local cCodFam

   ::oDlg:Disable()

   ::oDbf:Zap()

   ::aHeader   := {  {|| "Fecha  : " + Dtoc( Date() ) },;
                     {|| "Periodo: " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Familia: " + AllTrim ( ::cFamOrg ) + " > " + AllTrim ( ::cFamDes ) } }

   ::oTikCliL:GoTop()

   WHILE !::oTikCliL:Eof()

      cCodFam := cCodFam( ::oTikCliL:cCbaTil, ::oDbfArt )

      if !Empty( ::oTikCliL:cCbaTil )                                      .AND.;
         cCodFam    >= ::cFamOrg                                           .AND.;
         cCodFam    <= ::cFamDes                                           .AND.;
         ::oTikCliL:cCbaTil  >= ::cArtOrg                                  .AND.;
         ::oTikCliL:cCbaTil  <= ::cArtDes                                  .AND.;
         !( ::lExcCero .AND. ::oTikCliL:nPvpTil == 0 )

         if ::oTikCliT:Seek( ::oTikCliL:CSERTIL + ::oTikCliL:CNUMTIL + ::oTikCliL:CSUFTIL )

            if ( ::oTikCliT:cTipTik == "1" .OR. ::oTikCliT:cTipTik == "4" )      .AND.;
                ::oTikCliT:dFecTik  >= ::dIniInf                                 .AND.;
                ::oTikCliT:dFecTik  <= ::dFinInf

                /*
                Añadimos un nuevo registro
                */

                ::AddTik ( cCodFam )

            end if

         end if

      end if

      cCodFam := cCodFam( ::oTikCliL:cComTil, ::oDbfArt )

      if !Empty( ::oTikCliL:cComTil )                                      .AND.;
         cCodFam    >= ::cFamOrg                                           .AND.;
         cCodFam    <= ::cFamDes                                           .AND.;
         ::oTikCliL:cComTil  >= ::cArtOrg                                  .AND.;
         ::oTikCliL:cComTil  <= ::cArtDes                                  .AND.;
         !( ::lExcCero .AND. ::oTikCliL:nPvpTil == 0 )

         if ::oTikCliT:Seek( ::oTikCliL:CSERTIL + ::oTikCliL:CNUMTIL + ::oTikCliL:CSUFTIL )

            if ( ::oTikCliT:cTipTik == "1" .OR. ::oTikCliT:cTipTik == "4" )      .AND.;
                ::oTikCliT:dFecTik  >= ::dIniInf                                 .AND.;
                ::oTikCliT:dFecTik  <= ::dFinInf

                /*
                Añadimos un nuevo registro
                */

                ::AddTik ( cCodFam )

            end if

         end if

      end if

      ::oTikCliL:Skip()

      ::oMtrInf:AutoInc( ::oTikCliL:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oTikCliL:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//