#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfFPed FROM TInfFam

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oPedCliT    AS OBJECT
   DATA  oPedCliL    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Parcialmente", "Entregado", "Todos" }

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

METHOD OpenFiles() CLASS TInfFPed

  local oBlock
  local oError
  local lOpen := .t.

    /*
   Ficheros necesarios
   */

   oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::oPedCliT := TDataCenter():oPedCliT()

   DATABASE NEW ::oPedCliL PATH ( cPatEmp() ) FILE "PEDCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "PEDCLIL.CDX"
   ::oPedCliL:SetOrder( "CREF" )

   DATABASE NEW ::oDbfArt PATH ( cPatEmp() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   RECOVER USING oError

      lOpen := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TInfFPed

   if !Empty( ::oPedCliT ) .and. ::oPedCliT:Used()
      ::oPedCliT:End()
   end if

   if !Empty( ::oPedCliL ) .and. ::oPedCliL:Used()
      ::oPedCliL:End()
   end if

   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TInfFPed

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

METHOD lGenerate() CLASS TInfFPed

   local cPed
   local bValid   := {|| .t. }
   local cCodFam

   ::oDlg:Disable()

   ::oDbf:Zap()

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| !::oPedCliT:lCancel .and. ::oPedCliT:nEstado == 1 }
      case ::oEstado:nAt == 2
         bValid   := {|| !::oPedCliT:lCancel .and. ::oPedCliT:nEstado == 2 }
      case ::oEstado:nAt == 3
         bValid   := {|| !::oPedCliT:lCancel .and. ::oPedCliT:nEstado == 3 }
      case ::oEstado:nAt == 4
         bValid   := {|| !::oPedCliT:lCancel }
   end case

   ::aHeader   := {  {|| "Fecha  : " + Dtoc( Date() ) },;
                     {|| "Periodo: " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Familia: " + AllTrim ( ::cFamOrg ) + " > " + AllTrim ( ::cFamDes ) },;
                     {|| "Estado : " + ::aEstado[ ::oEstado:nAt ] } }


   ::oPedCliL:GoTop()

   WHILE !::oPedCliL:Eof()

      cCodFam := cCodFam( ::oPedcliL:cRef, ::oDbfArt )

      if cCodFam >= ::cFamOrg                                                          .AND.;
         cCodFam <= ::cFamDes

         if ::oPedCliT:Seek( ::oPedCliL:cSerPed + Str( ::oPedCliL:nNumPed ) + ::oPedCliL:cSufPed )

            if Eval ( bValid )                                                         .AND.;
               ::oPedCliT:DFECPED >= ::dIniInf                                         .AND.;
               ::oPedCliT:DFECPED <= ::dFinInf                                         .AND.;
               ::oPedCliL:cRef    >= ::cArtOrg                                         .AND.;
               ::oPedCliL:cRef    <= ::cArtDes                                         .AND.;
               lChkSer( ::oPedCliT:CSERPED, ::aSer )                                   .AND.;
               !( ::lExcCero .AND. ::oPedCliL:NPREDIV == 0 )

                  /*
                  Añadimos un nuevo registro
                  */

                  ::oDbf:Append()

                  ::AddCliente      ( ::oPedCliT:cCodCli, ::oPedCliT, .f. )

                  ::oDbf:cCodArt    := ::oDbfArt:CODIGO
                  ::oDbf:cNomArt    := ::oDbfArt:NOMBRE
                  ::oDbf:cCodFam    := ::oDbfArt:FAMILIA
                  ::oDbf:nNumCaj    := ::oPedCliL:nCanPed
                  ::oDbf:nUniDad    := ::oPedCliL:NUNICAJA
                  ::oDbf:nNumUni    := nTotNPedCli( ::oPedCliL )
                  ::oDbf:nImpArt    := nTotUPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTrn    := nTrnUPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nPntVer    := nPntUPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTot    := nImpLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                  ::oDbf:nIvaArt    := Round( ::oDbf:nImpArt * ::oPedCliL:nIva / 100, ::nDerOut )

                  ::oDbf:cDocMov    := lTrim( ::oPedCliL:CSERPED ) + "/" + lTrim ( Str( ::oPedCliL:NNUMPED ) ) + "/" + lTrim ( ::oPedCliL:CSUFPED )
                  ::oDbf:dFecMov    := ::oPedCliT:dFecPed

                  ::oDbf:Save()

            end if

         end if

      end if

      ::oPedCliL:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oPedCliL:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//