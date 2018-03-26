#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfGFDPed FROM TInfGrp

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oPedCliT    AS OBJECT
   DATA  oPedCliL    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Parcialmente", "Entregado", "Todas" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()


END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::DetalleCreateFields()

   ::AddTmpIndex ( "CGRPFAM", "CGRPFAM + CCODART" )
   ::AddGroup( {|| ::oDbf:cGrpFam }, {|| "Grupo Familia  : " + Rtrim( ::oDbf:cGrpFam ) + "-" + oRetFld( ::oDbf:cGrpFam, ::oGruFam:oDbf ) }, {||"Total Grupo de Familia..."} )
   ::AddGroup( {|| ::oDbf:cGrpFam + ::oDbf:cCodArt },    {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oDbfArt ) ) }, {||""} )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TInfGFDPed

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

METHOD CloseFiles() CLASS TInfGFDPed

   if !Empty( ::oPedCliT ) .and. ::oPedCliT:Used()
      ::oPedCliT:End()
   end if

   if !Empty( ::oPedCliL ) .and. ::oPedCliL:Used()
      ::oPedCliL:End()
   end if

   if !Empty( ::oDbfFam ) .and. ::oDbfFam:Used()
      ::oDbfFam:End()
   end if

   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TInfGFDPed

   local cEstado  := "Pendiente"

   if !::StdResource( "INF_GEN14" )
      return .f.
   end if

   /*
   Monta Grupos de Familias
   */

   ::oDefGrFInf( 110, 120, 130, 140 )

   /*
   Meter
   */

   ::oMtrInf:SetTotal( ::oPedCliL:Lastrec() )

   /*
   Monta los articulos de manera automatica
   */

   ::lDefArtInf( 150, 160, 170, 180 )

   ::oDefExcInf(204)

   ::oDefSalInf(201)

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

METHOD lGenerate() CLASS TInfGFDPed

   local bValid   := {|| .t. }

   ::oDlg:Disable()
   ::oDbf:Zap()

   ::oDbfArt:GoTop()

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

   ::aHeader   := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Gr. Fam.: " + ::cGruFamOrg      + " > " + ::cGruFamDes },;
                     {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ] } }

   WHILE !::oPedCliL:Eof()

      if cCodGruFam( ::oPedCliL:cRef, ::oDbfArt, ::oDbfFam ) >= ::cGruFamOrg      .AND.;
         cCodGruFam( ::oPedCliL:cRef, ::oDbfArt, ::oDbfFam ) <= ::cGruFamDes

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

               ::oDbf:cCodArt    := ::oPedCliL:cRef
               ::oDbf:cNomArt    := RetArticulo( ::oPedCliL:cRef, ::oDbfArt )
               ::oDbf:cGrpFam    := cCodGruFam( ::oPedCliL:cRef, ::oDbfArt, ::oDbfFam )
               ::oDbf:nNumCaj    := ::oPedCliL:nCanEnt
               ::oDbf:nUniDad    := ::oPedCliL:NUNICAJA
               ::oDbf:nNumUni    := nTotNPedCli( ::oPedCliL )
               ::oDbf:nImpArt    := nTotUPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nValDiv )
               ::oDbf:nImpTrn    := nTrnUPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nValDiv )
               ::oDbf:nPntVer    := nPntUPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nValDiv )
               ::oDbf:nImpTot    := nImpLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

               ::oDbf:cDocMov    := lTrim ( ::oPedCliL:CSERPED ) + "/" + lTrim ( Str( ::oPedCliL:NNUMPED ) ) + "/" + lTrim ( ::oPedCliL:CSUFPED )
               ::oDbf:cTipDoc := "Pedido"
               ::oDbf:dFecMov    := ::oPedCliT:DFECPED

               ::AddCliente( ::oPedCliT:cCodCli, ::oPedCliT, .f. )

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