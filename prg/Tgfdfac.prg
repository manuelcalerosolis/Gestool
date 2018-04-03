#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"
//---------------------------------------------------------------------------//

CLASS TInfGfdFac FROM TInfGrp

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Liquidada", "Todas" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::DetalleCreateFields()

   ::AddTmpIndex( "CGRPFAM", "CGRPFAM + CCODART" )
   ::AddGroup( {|| ::oDbf:cGrpFam }, {|| "Grupo Familia  : " + Rtrim( ::oDbf:cGrpFam ) + "-" + oRetFld( ::oDbf:cGrpFam, ::oGruFam:oDbf ) }, {||"Total Grupo de Familia..."} )
   ::AddGroup( {|| ::oDbf:cGrpFam + ::oDbf:cCodArt },    {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oDbfArt ) ) }, {||""} )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TInfGFDFac

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

METHOD CloseFiles() CLASS TInfGFDFac

   if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if

   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if

   if !Empty( ::oDbfFam ) .and. ::oDbfFam:Used()
      ::oDbfFam:End()
   end if

   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TInfGFDFac

   local cEstado  := "Todas"

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

   ::oMtrInf:SetTotal( ::oFacCliL:Lastrec() )

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
      ITEMS    ::aEstado  ;
      OF       ::oFld:aDialogs[1]

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TInfGFDFac

   local bValid   := {|| .t. }

   ::oDlg:Disable()
   ::oDbf:Zap()

   ::oDbfArt:GoTop()

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| !::oFacCliT:lLiquidada }
      case ::oEstado:nAt == 2
         bValid   := {|| ::oFacCliT:lLiquidada }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

   ::aHeader   := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Gr. Fam.: " + ::cGruFamOrg      + " > " + ::cGruFamDes },;
                     {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ] } }

   ::oFacCliL:GoTop()
   while !::OFacCliL:Eof()

      if cCodGruFam( ::oFacCliL:cRef, ::oDbfArt, ::oDbfFam ) >= ::cGruFamOrg .AND.;
         cCodGruFam( ::oFacCliL:cRef, ::oDbfArt, ::oDbfFam ) <= ::cGruFamDes

         if ::oFacCliT:Seek( ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac )

            if Eval ( bValid )                                                        .AND.;
            ::oFacCliT:DFECFAC >= ::dIniInf                                           .AND.;
            ::oFacCliT:DFECFAC <= ::dFinInf                                           .AND.;
            ::oFacCliL:cRef    >= ::cArtOrg                                           .AND.;
            ::oFacCliL:cRef    <= ::cArtDes                                           .AND.;
            lChkSer( ::oFacCliT:CSERIE, ::aSer )                                      .AND.;
            !( ::lExcCero .AND. ::oFacCliL:NPREDIV == 0 )

            /*
            Añadimos un nuevo registro
            */

            ::AddFac()

         end if

      end if

   end if

   ::oFacCliL:Skip()

   ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oFacCliL:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//