#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION TComVta()

   local oInf
   local aCol  := {}
   local aIdx  := {}

   aAdd( aCol, { "cCodFam", "C", 16, 0, {|| "@!" },     "Fam. artículo", .f., "Familia artículo",    5 } )
   aAdd( aCol, { "CCODALM", "C", 16, 0, {|| "@!" },     "Alm.",          .t., "Código almacén",      3 } )
   aAdd( aCol, { "CCODART", "C", 18, 0, {|| "@!" },     "Código",        .t., "Código artículo",     8 } )
   aAdd( aCol, { "CNOMART", "C",100, 0, {|| "@!" },     "Descripción",   .t., "Descripción",         40} )
   aAdd( aCol, { "NUNDCOM", "N", 19, 6, {|| MasUnd() }, "Compras",       .t., "Compras",             13} )
   aAdd( aCol, { "NUNDVTA", "N", 19, 6, {|| MasUnd() }, "Ventas",        .t., "Ventas",              13} )
   aAdd( aCol, { "NUNDMOV", "N", 19, 6, {|| MasUnd() }, "Mov. alm.",     .t., "Moviemntos almacen",  13} )
   aAdd( aCol, { "NNUMUND", "N", 19, 6, {|| MasUnd() }, "Stock",         .t., "Stock",               13} )
   aAdd( aCol, { "NSTKCMP", "N", 19, 6, {|| MasUnd() }, "Stock comp.",   .f., "Stock comprometido",  13} )
   aAdd( aCol, { "NSTKLIB", "N", 19, 6, {|| MasUnd() }, "Stock libre",   .f., "Stock libre",         13} )

   aAdd( aIdx, { "CNOMART", "CNOMART" } )
   aAdd( aIdx, { "CCODART", "CCODART" } )
   aAdd( aIdx, { "CCODALM", "cCodFam + cCodArt" } )

   oInf  := TInfComVta():New( "Informe resumido de compras, ventas y stocks de artículos por familias", aCol, aIdx, "01046" )

   oInf:AddGroup( {|| oInf:oDbf:cCodFam }, {|| "Família : " + Rtrim( oInf:oDbf:cCodFam ) + "-" + oRetFld( oInf:oDbf:cCodFam, oInf:oDbfFam ) }, {||"Total família..."} )
   oInf:AddGroup( {|| oInf:oDbf:cCodArt }, {|| "Artículo: " + Rtrim( oInf:oDbf:cCodArt ) + "-" + oRetFld( oInf:oDbf:cCodArt, oInf:oDbfArt ) }, {||""} )

   oInf:Resource()
   oInf:Activate()

   oInf:End()

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TInfComVta FROM TInfGen

   DATA  oAlmacen    AS OBJECT
   DATA  oFamilia    AS OBJECT
   DATA  oStock      AS OBJECT
   DATA  oEstado     AS OBJECT
   DATA  oAlbPrvT
   DATA  oAlbPrvL
   DATA  oFacPrvT
   DATA  oFacPrvL
   DATA  oAlbCliT
   DATA  oAlbCliL
   DATA  oFacCliT
   DATA  oFacCliL
   DATA  oTikCliT
   DATA  oTikCliL
   DATA  oHisMov

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource()

   METHOD lGenerate()

   METHOD oDefIniInf() VIRTUAL

   METHOD oDefFinInf() VIRTUAL

   METHOD oDefDivInf() VIRTUAL

   METHOD nTotVta()

   METHOD nTotCom()

   METHOD nTotMov()  INLINE nTotVMovAlm( ::oDbfArt:Codigo, ::oHisMov:cAlias, ::oDbfAlm:cCodAlm )

   END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles()

  local oBlock
  local oError
  local lOpen     := .t.

   /*
   Ficheros necesarios
   */

   oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      DATABASE NEW ::oAlbPrvT  PATH ( cPatEmp() ) FILE "ALBPROVT.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVT.CDX"

      DATABASE NEW ::oAlbPrvL  PATH ( cPatEmp() ) FILE "ALBPROVL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"
      ::oAlbPrvL:OrdSetFocus( "cRef" )

      DATABASE NEW ::oFacPrvT  PATH ( cPatEmp() ) FILE "FACPRVT.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"

      DATABASE NEW ::oFacPrvL  PATH ( cPatEmp() ) FILE "FACPRVL.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"
      ::oFacPrvL:OrdSetFocus( "cRef" )

      ::oAlbCliT := TDataCenter():oAlbCliT()

      DATABASE NEW ::oAlbCliL  PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"
      ::oAlbCliL:OrdSetFocus( "cRef" )

      ::oFacCliT := TDataCenter():oFacCliT()

      DATABASE NEW ::oFacCliL  PATH ( cPatEmp() ) FILE "FacCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FacCLIL.CDX"
      ::oFacCliL:OrdSetFocus( "cRef" )

      DATABASE NEW ::oTikCliT  PATH ( cPatEmp() ) FILE "TikeT.DBF" VIA ( cDriver() ) SHARED INDEX "TikeT.CDX"

      DATABASE NEW ::oTikCliL  PATH ( cPatEmp() ) FILE "TikeL.DBF" VIA ( cDriver() ) SHARED INDEX "TikeL.CDX"
      ::oTikCliL:OrdSetFocus( "cCbaTil" )

      DATABASE NEW ::oHisMov  PATH ( cPatEmp() ) FILE "HisMov.DBF" VIA ( cDriver() ) SHARED INDEX "HisMov.CDX"
      ::oHisMov:OrdSetFocus( "cRefMov" )

      ::oStock    := TStock():Create()
      if !::oStock:lOpenFiles()
         lOpen    := .f.
      end if

   RECOVER USING oError

      lOpen       := .f.

      msgStop( "Imposible abrir todas las bases de datos" )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpen
      ::CloseFiles()
   end if

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   if !Empty( ::oDbfPrvT ) .and. ::oDbfPrvT:Used()
      ::oDbfPrvT:End()
   end if

   if !Empty( ::oAlbPrvL ) .and. ::oAlbPrvL:Used()
      ::oAlbPrvL:End()
   end if

   if !Empty( ::oFacPrvT ) .and. ::oFacPrvT:Used()
      ::oFacPrvT:End()
   end if

   if !Empty( ::oFacPrvL ) .and. ::oFacPrvL:Used()
      ::oFacPrvL:End()
   end if

   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if

   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if

   if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if

   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if

   if !Empty( ::oTikCliT ) .and. ::oTikCliT:Used()
      ::oTikCliT:End()
   end if

  if !Empty( ::oTikCliL ) .and. ::oTikCliL:Used()
      ::oTikCliL:End()
   end if

  if !Empty( ::oHisMov ) .and. ::oHisMov:Used()
      ::oHisMov:End()
   end if

  if !Empty( ::oStock ) .and. ::oStock:Used()
      ::oStock:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource()

   local cEstado  := "Almacen"

   ::lDefSerInf   := .f.

   if !::StdResource( "INF_GEN03" )
      return .f.
   end if

   /*
   Monta los almacenes de manera automatica
   */

   ::oDefAlmInf( 70, 80, 90, 100 )

   /*
   Monta los proveedores de manera automatica
   */

   ::lDefArtInf( 110, 120, 130, 140 )

   /*
   Monta las familias de manera automatica
   */

   ::lDefFamInf( 150, 160, 170, 180 )

   /*
   Monta Excluidos Cero
   */

   ::oDefExcInf( 210 )

   /*
   Ordenado por
   */

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    { "Nombre", "Código", "Almacen" } ;
      OF       ::oFld:aDialogs[1]

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oDbfAlm:Lastrec() )

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   ::oDlg:Disable()

   ::oDbf:Zap()

   ::oMtrInf:SetTotal( ::oDbfArt:Lastrec() )

   ::oDbfAlm:Seek( ::cAlmOrg )

   ::aHeader   := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "Almacén : " + ::cAlmOrg         + " > " + ::cAlmDes },;
                     {|| "Familia : " + ::cFamOrg       + " > " + ::cFamDes },;
                     {|| "Artículo: " + ::cArtOrg         + " > " + ::cArtDes } }

   ::oDbf:OrdSetFocus( ::oEstado:nAt )

   while ::oDbfAlm:CCODALM >= ::cAlmOrg .AND. ::oDbfAlm:CCODALM <= ::cAlmDes .AND. !::oDbfAlm:Eof()

      if ::oDbfArt:Seek( ::cArtOrg, .t. )

         while ::oDbfArt:Codigo <= ::cArtDes .and. !::oDbfArt:Eof()

            if ::oDbfArt:NCTLSTOCK == 1            .and.;
               ::oDbfArt:FAMILIA >= ::cFamOrg      .and.;
               ::oDbfArt:FAMILIA <= ::cFamDes      .and.;
               !::oDbfArt:lKitArt                  .and.;
               !( ::lExcCero .AND. ::oStock:nTotStockAct( ::oDbfArt:Codigo, ::oDbfAlm:cCodAlm, , , , ::oDbfArt:lKitArt, ::oDbfArt:nCtlStock ) == 0 )

               ::oDbf:Append()
               ::oDbf:Blank()

               ::oDbf:cCodAlm := ::oDbfAlm:cCodAlm
               ::oDbf:cCodFam := ::oDbfArt:Familia
               ::oDbf:cCodArt := ::oDbfArt:Codigo
               ::oDbf:nUndCom := ::nTotCom()
               ::oDbf:nUndVta := ::nTotVta()
               ::oDbf:nUndMov := ::nTotMov()
               ::oDbf:cNomArt := ::oDbfArt:Nombre
               ::oDbf:nNumUnd := ::oStock:nTotStockAct( ::oDbfArt:Codigo, ::oDbfAlm:cCodAlm, , , , ::oDbfArt:lKitArt, ::oDbfArt:nCtlStock )
               ::oDbf:nStkCmp := ::oStock:nPdtEntCom( ::oDbfArt:Codigo, ::oDbfAlm:cCodAlm )
               ::oDbf:nStkLib := ::oDbf:nNumUnd - ::oDbf:nStkCmp

               ::oDbf:Save()

            End If

         ::oDbfArt:Skip()
         ::oMtrInf:AutoInc( ::oDbfArt:OrdKeyNo() )

         End Do

      end if

      ::oDbfAlm:Skip()

   END DO

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD nTotVta()

   local nTotVta  := 0

   nTotVta        += nTotDAlbCli( ::oDbfArt:Codigo, ::oAlbCliL:cAlias, ::oAlbCliT:cAlias, ::oDbfAlm:cCodAlm )
   nTotVta        += nTotDFacCli( ::oDbfArt:Codigo, ::oFacCliL:cAlias, ::oDbfAlm:cCodAlm  )
   nTotVta        += nTotDTikCli( ::oDbfArt:Codigo, ::oTikCliT:cAlias, ::oTikCliL:cAlias, ::oDbfAlm:cCodAlm )

return ( nTotVta )

//---------------------------------------------------------------------------//

METHOD nTotCom()

   local nTotCom  := 0

   nTotCom        += nTotDAlbPrv( ::oDbfArt:Codigo, ::oAlbPrvL:cAlias, ::oAlbPrvT:cAlias, ::oDbfAlm:cCodAlm )
   nTotCom        += nTotDFacPrv( ::oDbfArt:Codigo, ::oFacPrvL:cAlias, ::oDbfAlm:cCodAlm )

return ( nTotCom )

//-----------------------------------------------------------------------------//