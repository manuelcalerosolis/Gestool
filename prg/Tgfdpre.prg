#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfGFDPre FROM TInfGrp

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oPreCliT    AS OBJECT
   DATA  oPreCliL    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT { "Pendiente", "Aceptado", "Todos" }

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

METHOD OpenFiles() CLASS TInfGFDPre

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

METHOD CloseFiles() CLASS TInfGFDPre

   if !Empty( ::oPreCliT ) .and. ::oPreCliT:Used()
      ::oPreCliT:End()
   end if

   if !Empty( ::oPreCliL ) .and. ::oPreCliL:Used()
      ::oPreCliL:End()
   end if

   if !Empty( ::oDbfFam ) .and. ::oDbfFam:Used()
      ::oDbfFam:End()
   end if

   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TInfGFDPre

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

   ::oMtrInf:SetTotal( ::oPreCliL:Lastrec() )

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

METHOD lGenerate() CLASS TInfGFDPre

   local bValid   := {|| .t. }

   ::oDlg:Disable()
   ::oDbf:Zap()

   ::oDbfArt:GoTop()

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| !::oPreCliT:lEstado }
      case ::oEstado:nAt == 2
         bValid   := {|| ::oPreCliT:lEstado }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

   ::aHeader   := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Gr. Fam.: " + ::cGruFamOrg      + " > " + ::cGruFamDes },;
                     {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ] } }

   ::oPreCliL:GoTop()
   WHILE !::oPreCliL:Eof()

      if cCodGruFam( ::oPreCliL:cRef, ::oDbfArt, ::oDbfFam ) >= ::cGruFamOrg .AND.;
         cCodGruFam( ::oPreCliL:cRef, ::oDbfArt, ::oDbfFam ) <= ::cGruFamDes

         if ::oPreCliT:Seek( ::oPreCliL:cSerPre + Str( ::oPreCliL:nNumPre ) + ::oPreCliL:cSufPre )

            if Eval ( bValid )                                                         .AND.;
               ::oPreCliT:DFECPRE >= ::dIniInf                                         .AND.;
               ::oPreCliT:DFECPRE <= ::dFinInf                                         .AND.;
               ::oPreCliL:cRef    >= ::cArtOrg                                         .AND.;
               ::oPreCliL:cRef    <= ::cArtDes                                         .AND.;
               lChkSer( ::oPreCliT:CSERPRE, ::aSer )                                   .AND.;
               !( ::lExcCero .AND. ::oPreCliL:NPREDIV == 0 )

               /*
               Añadimos un nuevo registro
               */

               ::oDbf:Append()

               ::oDbf:cCodArt    := ::oPreCliL:cRef
               ::oDbf:cNomArt    := RetArticulo( ::oPreCliL:cRef, ::oDbfArt )
               ::oDbf:cGrpFam    := cCodGruFam( ::oPreCliL:cRef, ::oDbfArt, ::oDbfFam )
               ::oDbf:nNumCaj    := ::oPreCliL:nCanEnt
               ::oDbf:nUniDad    := ::oPreCliL:NUNICAJA
               ::oDbf:nNumUni    := nTotNPreCli( ::oPreCliL )
               ::oDbf:nImpArt    := nTotUPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nValDiv )
               ::oDbf:nImpTrn    := nTrnUPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nValDiv )
               ::oDbf:nPntVer    := nPntUPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nValDiv )
               ::oDbf:nImpTot    := nImpLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:cDocMov    := lTrim( ::oPreCliL:CSERPRE ) + "/" + lTrim( Str ( ::oPreCliL:NNUMPRE ) ) + "/" + lTrim ( ::oPreCliL:CSUFPRE )
               ::oDbf:cTipDoc := "Presupuesto"
               ::oDbf:dFecMov    := ::oPreCliT:DFECPRE

               ::AddCliente( ::oPreCliT:cCodCli, ::oPreCliT, .f. )

               ::oDbf:Save()

            end if

         end if

      end if

      ::oPreCliL:Skip()

      ::oMtrInf:AutoInc()

   END WHILE

   ::oMtrInf:AutoInc( ::oPreCliL:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//