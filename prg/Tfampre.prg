#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfFamPre FROM TInfFam

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oPreCliT    AS OBJECT
   DATA  oPreCliL    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Aceptado", "Todos" }

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
   ::AddGroup( {|| ::oDbf:cCodFam }, {|| "Familia  : " + Rtrim( ::oDbf:cCodFam ) + "-" + oRetFld( ::oDbf:cCodFam, ::oDbfFam ) }, {||"Total familia..."}, , ::lSalto )
   ::AddGroup( {|| ::oDbf:cCodFam + ::oDbf:cCodArt },    {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oDbfArt ) ) }, {||""} )

RETURN ( self )
//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TInfFamPre

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

   DATABASE NEW ::oDbfArt PATH ( cPatEmp() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   RECOVER USING oError

      lOpen := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TInfFamPre

   if !Empty( ::oPreCliT ) .and. ::oPreCliT:Used()
      ::oPreCliT:End()
   end if

   if !Empty( ::oPreCliL ) .and. ::oPreCliL:Used()
      ::oPreCliL:End()
   end if

   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TInfFamPre

   local cEstado := "Todos"

   if !::StdResource( "INF_GEN11" )
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

   ::oDefExcInf( 204 )

   ::oDefSalInf( 201 )

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

METHOD lGenerate() CLASS TInfFamPre

   local bValid   := {|| .t. }
   local cCodFam

   ::oDlg:Disable()

   ::oDbf:Zap()

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| !::oPreCliT:lEstado }
      case ::oEstado:nAt == 2
         bValid   := {|| ::oPreCliT:lEstado }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

   ::aHeader   := {  {|| "Fecha  : " + Dtoc( Date() ) },;
                     {|| "Periodo: " + Dtoc( ::dIniInf )     + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Familia: " + AllTrim (::cFamOrg)   + " > " + AllTrim ( ::cFamDes ) },;
                     {|| "Estado : " + ::aEstado[ ::oEstado:nAt ] } }


   ::oPreCliL:GoTop()

   WHILE !::oPreCliL:Eof()

      cCodFam := cCodFam( ::oPrecliL:cRef, ::oDbfArt )

      if cCodFam >= ::cFamOrg                       .AND.;
         cCodFam <= ::cFamDes

         if ::oPreCliT:Seek( ::oPreCliL:cSerPre + Str( ::oPreCliL:nNumPre ) + ::oPreCliL:cSufPre )

            if Eval ( bValid )                                                 .AND.;
               ::oPreCliT:DFECPRE >= ::dIniInf                                 .AND.;
               ::oPreCliT:DFECPRE <= ::dFinInf                                 .AND.;
               ::oPreCliL:cRef    >= ::cArtOrg                                 .AND.;
               ::oPreCliL:cRef    <= ::cArtDes                                 .AND.;
               lChkSer( ::oPreCliT:CSERPRE, ::aSer )                           .AND.;
               !( ::lExcCero .AND. ::oPreCliL:NUNICAJA == 0 )                  .AND.;
               !( ::lExcMov  .AND. nImpLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                  /*
                  Añadimos un nuevo registro
                  */

                  ::oDbf:Append()

                  ::AddCliente      ( ::oPreCliT:cCodCli, ::oPreCliT, .f. )

                  ::oDbf:cCodArt    := ::oDbfArt:CODIGO
                  ::oDbf:cNomArt    := ::oDbfArt:NOMBRE
                  ::oDbf:cCodFam    := ::oDbfArt:FAMILIA
                  ::oDbf:nNumCaj    := ::oPreCliL:nCanPre
                  ::oDbf:nUniDad    := ::oPreCliL:NUNICAJA
                  ::oDbf:nNumUni    := nTotNPreCli( ::oPreCliL )
                  ::oDbf:nImpArt    := nTotUPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTrn    := nTrnUPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nPntVer    := nPntUPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTot    := nImpLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                  ::oDbf:nIvaArt    := Round( ::oDbf:nImpArt * ::oPreCliL:nIva / 100, ::nDerOut )

                  ::oDbf:cDocMov    := lTrim( ::oPreCliL:CSERPRE ) + "/" + lTrim ( Str( ::oPreCliL:NNUMPRE ) ) + "/" + lTrim ( ::oPreCliL:CSUFPRE )
                  ::oDbf:dFecMov    := ::oPreCliT:DFECPRE

                  ::oDbf:Save()

               end if

         end if

      end if

      ::oPreCliL:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oPreCliL:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )


//---------------------------------------------------------------------------//