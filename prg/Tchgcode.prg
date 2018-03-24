#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Report.ch"
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TChgCode

   DATA  oDlg
   DATA  oDbfArt
   DATA  oDbfFam
   DATA  oDbfPrv
   DATA  oDbfPrc
   DATA  oDbfTar
   DATA  oDbfOfe
   DATA  oDbfArd
   DATA  oDbfKit
   DATA  oDbfPedPrv
   DATA  oDbfAlbPrv
   DATA  oDbfFacPrv
   DATA  oDbfPro
   DATA  oDbfDepAge
   DATA  oDbfExtAge
   DATA  oDbfDepAge
   DATA  oDbfExtAge
   DATA  oDbfPreCli
   DATA  oDbfPedCli
   DATA  oDbfAlbCli
   DATA  oDbfFacCli
   DATA  oDbfPreCliT
   DATA  oDbfPedCliT
   DATA  oDbfAlbCliT
   DATA  oDbfFacCliT
   DATA  oDbfFacCliP
   DATA  oDbfTpvCli
   DATA  oDbfCliAtp
   DATA  oDbfTblPro
   DATA  oDbfArtKit
   DATA  oDbfAgentes
   DATA  oDbfClient
   DATA  oDbfTpvCliT
   DATA  oDbfEmpresa
   DATA  oDbfPedPrvT
   DATA  oDbfAlbPrvT
   DATA  oDbfFacPrvT
   DATA  oDbfMatProd
   DATA  oDbfMatPrima
   DATA  oDbfPago
   DATA  oPrcArt
   DATA  oRadCod
   DATA  nRadCod        AS NUMERIC     INIT  1
   DATA  oMtrInf
   DATA  nMtrInf        AS NUMERIC     INIT  0
   DATA  oGrpFam
   DATA  cGetGrfOld
   DATA  cGetGrfNew
   DATA  cGetFamOld
   DATA  cGetFamNew
   DATA  cGetArtOld
   DATA  cGetArtNew
   DATA  oGetGrfOld
   DATA  oGetGrfNew
   DATA  oGetFamOld
   DATA  oGetFamNew
   DATA  oGetArtOld
   DATA  oGetArtNew
   DATA  oSayGrfOld
   DATA  oSayGrfNew
   DATA  oSayFamOld
   DATA  oSayFamNew
   DATA  oSayArtOld
   DATA  oSayArtNew
   DATA  cAgenteNew
   DATA  cAgenteOld
   DATA  oAgenteNew
   DATA  oAgenteOld
   DATA  cSayAgenteNew
   DATA  cSayAgenteOld
   DATA  oSayAgenteNew
   DATA  oSayAgenteOld
   DATA  cPagoNew
   DATA  cPagoOld
   DATA  oPagoNew
   DATA  oPagoOld
   DATA  cSayPagoNew
   DATA  cSayPagoOld
   DATA  oSayPagoNew
   DATA  oSayPagoOld

   DATA  oGetEscOld
   DATA  cGetEscOld
   DATA  oGetEscNew
   DATA  cGetEscNew
   DATA  oSayEscOld
   DATA  cSayEscOld
   DATA  oSayEscNew
   DATA  cSayEscNew

   /*
   Propiedades
   */

   DATA  oTxtPr1Old
   DATA  oSayPr1Old
   DATA  oGetPr1Old
   DATA  cGetPr1Old
   DATA  cCodPr1Old

   DATA  oTxtPr2Old
   DATA  oSayPr2Old
   DATA  oGetPr2Old
   DATA  cGetPr2Old
   DATA  cCodPr2Old

   DATA  oTxtPr1New
   DATA  oSayPr1New
   DATA  oGetPr1New
   DATA  cGetPr1New
   DATA  cCodPr1New

   DATA  oTxtPr2New
   DATA  oSayPr2New
   DATA  oGetPr2New
   DATA  cGetPr2New
   DATA  cCodPr2New

   DATA  lStabilize     AS LOGIC       INIT  .f.
   DATA  nRecChanged    AS NUMERIC     INIT  0

   METHOD New( oMenuItem, oWnd ) CONSTRUCTOR

   METHOD End()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource()

   METHOD ChgCode()

   METHOD loaArtOld()

   METHOD loaArtNew()

   METHOD changeSecondPropertie()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oMenuItem, oWnd ) CLASS TChgCode

   local nLevel

   DEFAULT  oMenuItem   := "01080"
   DEFAULT  oWnd        := oWnd()

   nLevel               := Auth():Level( oMenuItem )
   if nAnd( nLevel, 1 ) == 0
      msgStop( "Acceso no permitido." )
      return ( Self )
   end if

   if !oUser():lAdministrador()
      msgStop( "Solo puede cambiar codigos los administradores." )
      return ( Self )
   end if

   if nUsrInUse() > 1
      msgStop( "Hay más de un usuario conectado a la aplicación", "Atención" )
      return ( Self )
   end if

   /*
   Cerramos todas las ventanas
   */

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   ::cGetGrfOld         := Space( 3 )
   ::cGetGrfNew         := Space( 3 )
   ::cGetFamOld         := Space( 8 )
   ::cGetFamNew         := Space( 8 )
   ::cGetArtOld         := Space( 18 )
   ::cGetArtNew         := Space( 18 )
   ::cGetEscOld         := Space( 18 )
   ::cGetEscNew         := Space( 18 )
   ::cGetPr1Old         := Space( 40 )
   ::cGetPr2Old         := Space( 40 )

   ::oGrpFam            := TGrpFam():Create( cPatArt() )

   ::OpenFiles()

   ::lStabilize         := .t.

RETURN Self

//----------------------------------------------------------------------------//

METHOD OpenFiles()

  local oBlock
  local oError
  local lOpen     := .t.

   /*
   Ficheros necesarios
   */

   oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   DATABASE NEW ::oDbfFam     PATH ( cPatArt() ) FILE "FAMILIAS.DBF" VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

   DATABASE NEW ::oDbfArt     PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   DATABASE NEW ::oDbfArtKit  PATH ( cPatArt() ) FILE "ArtKit.Dbf"   VIA ( cDriver() ) SHARED INDEX "ArtKit.Cdx"

   DATABASE NEW ::oDbfPrv     PATH ( cPatArt() ) FILE "PROVART.DBF"  VIA ( cDriver() ) SHARED INDEX "PROVART.CDX"

   DATABASE NEW ::oDbfTar     PATH ( cPatArt() ) FILE "TARPREL.DBF"  VIA ( cDriver() ) SHARED INDEX "TARPREL.CDX"

   DATABASE NEW ::oDbfOfe     PATH ( cPatArt() ) FILE "OFERTA.DBF"   VIA ( cDriver() ) SHARED INDEX "OFERTA.CDX"

   DATABASE NEW ::oDbfArd     PATH ( cPatArt() ) FILE "ARTDIV.DBF"   VIA ( cDriver() ) SHARED INDEX "ARTDIV.CDX"

   DATABASE NEW ::oDbfKit     PATH ( cPatArt() ) FILE "ARTKIT.DBF"   VIA ( cDriver() ) SHARED INDEX "ARTKIT.CDX"

   DATABASE NEW ::oDbfCliAtp  PATH ( cPatCli() ) FILE "CLIATP.DBF"   VIA ( cDriver() ) SHARED INDEX "CLIATP.CDX"

   DATABASE NEW ::oDbfPedPrv  PATH ( cPatEmp() ) FILE "PEDPROVL.DBF" VIA ( cDriver() ) SHARED INDEX "PEDPROVL.CDX"

   DATABASE NEW ::oDbfAlbPrv  PATH ( cPatEmp() ) FILE "ALBPROVL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"

   DATABASE NEW ::oDbfFacPrv  PATH ( cPatEmp() ) FILE "FACPRVL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"

   DATABASE NEW ::oDbfDepAge  PATH ( cPatEmp() ) FILE "DEPAGEL.DBF"  VIA ( cDriver() ) SHARED INDEX "DEPAGEL.CDX"

   DATABASE NEW ::oDbfExtAge  PATH ( cPatEmp() ) FILE "EXTAGEL.DBF"  VIA ( cDriver() ) SHARED INDEX "EXTAGEL.CDX"

   DATABASE NEW ::oDbfPreCli  PATH ( cPatEmp() ) FILE "PRECLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "PRECLIL.CDX"

   DATABASE NEW ::oDbfPedCli  PATH ( cPatEmp() ) FILE "PEDCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "PEDCLIL.CDX"

   DATABASE NEW ::oDbfAlbCli  PATH ( cPatEmp() ) FILE "ALBCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   DATABASE NEW ::oDbfFacCli  PATH ( cPatEmp() ) FILE "FACCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oDbfTpvCli  PATH ( cPatEmp() ) FILE "TIKEL.DBF"    VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oDbfTpvCliT PATH ( cPatEmp() ) FILE "TIKET.DBF"    VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oDbfTblPro  PATH ( cPatArt() ) FILE "TBLPRO.DBF"   VIA ( cDriver() ) SHARED INDEX "TBLPRO.CDX"

   DATABASE NEW ::oDbfAgentes PATH ( cPatCli() ) FILE "AGENTES.DBF"  VIA ( cDriver() ) SHARED INDEX "AGENTES.CDX"

   DATABASE NEW ::oDbfPreCliT PATH ( cPatEmp() ) FILE "PRECLIT.DBF"  VIA ( cDriver() ) SHARED INDEX "PRECLIT.CDX"

   DATABASE NEW ::oDbfPedCliT PATH ( cPatEmp() ) FILE "PEDCLIT.DBF"  VIA ( cDriver() ) SHARED INDEX "PEDCLIT.CDX"

   DATABASE NEW ::oDbfAlbCliT PATH ( cPatEmp() ) FILE "ALBCLIT.DBF"  VIA ( cDriver() ) SHARED INDEX "ALBCLIT.CDX"

   DATABASE NEW ::oDbfFacCliT PATH ( cPatEmp() ) FILE "FacCLIT.DBF"  VIA ( cDriver() ) SHARED INDEX "FacCLIT.CDX"

   DATABASE NEW ::oDbfFacCliP PATH ( cPatEmp() ) FILE "FACCLIP.DBF"  VIA ( cDriver() ) SHARED INDEX "FACCLIP.CDX"

   DATABASE NEW ::oDbfPago    PATH ( cPatEmp() ) FILE "FPAGO.DBF"    VIA ( cDriver() ) SHARED INDEX "FPAGO.CDX"

   DATABASE NEW ::oDbfEmpresa PATH ( cPatDat() ) FILE "EMPRESA.DBF"  VIA ( cDriver() ) SHARED INDEX "EMPRESA.CDX"

   DATABASE NEW ::oDbfPedPrvT PATH ( cPatEmp() ) FILE "PEDPROVT.DBF"  VIA ( cDriver() ) SHARED INDEX "PEDPROVT.CDX"

   DATABASE NEW ::oDbfAlbPrvT PATH ( cPatEmp() ) FILE "ALBPROVT.DBF"  VIA ( cDriver() ) SHARED INDEX "ALBPROVT.CDX"

   DATABASE NEW ::oDbfFacPrvT PATH ( cPatEmp() ) FILE "FACPRVT.DBF"  VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"

   DATABASE NEW ::oDbfClient  PATH ( cPatCli() ) FILE "CLIENT.DBF"   VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   DATABASE NEW ::oDbfMatProd PATH ( cPatEmp() ) FILE "PROLIN.DBF"   VIA ( cDriver() ) SHARED INDEX "PROLIN.CDX"

   DATABASE NEW ::oDbfMatPrima PATH ( cPatEmp() ) FILE "PROMAT.DBF"   VIA ( cDriver() ) SHARED INDEX "PROMAT.CDX"

   ::oGrpFam:OpenFiles()

   RECOVER USING oError

      lOpen    := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbfFam ) .and. ::oDbfFam:Used()
      ::oDbfFam:End()
   end if

   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   if !Empty( ::oDbfArtKit ) .and. ::oDbfArtKit:Used()
      ::oDbfArtKit:End()
   end if

   if !Empty( ::oDbfPrv ) .and. ::oDbfPrv:Used()
      ::oDbfPrv:End()
   end if

   if !Empty( ::oDbfTar ) .and. ::oDbfTar:Used()
      ::oDbfTar:End()
   end if

   if !Empty( ::oDbfOfe ) .and. ::oDbfOfe:Used()
      ::oDbfOfe:End()
   end if

   if !Empty( ::oDbfArd ) .and. ::oDbfArd:Used()
      ::oDbfArd:End()
   end if

   if !Empty( ::oDbfKit ) .and. ::oDbfKit:Used()
      ::oDbfKit:End()
   end if

   if !Empty( ::oDbfCliAtp ) .and. ::oDbfCliAtp:Used()
      ::oDbfCliAtp:End()
   end if

   if !Empty( ::oDbfPedPrv ) .and. ::oDbfPedPrv:Used()
      ::oDbfPedPrv:End()
   end if

   if !Empty( ::oDbfAlbPrv ) .and. ::oDbfAlbPrv:Used()
      ::oDbfAlbPrv:End()
   end if

   if !Empty( ::oDbfFacPrv ) .and. ::oDbfFacPrv:Used()
      ::oDbfFacPrv:End()
   end if

   if !Empty( ::oDbfDepAge ) .and. ::oDbfDepAge:Used()
      ::oDbfDepAge:End()
   end if

   if !Empty( ::oDbfExtAge ) .and. ::oDbfExtAge:Used()
      ::oDbfExtAge:End()
   end if

  if !Empty( ::oDbfPreCli ) .and. ::oDbfPreCli:Used()
      ::oDbfPreCli:End()
   end if

  if !Empty( ::oDbfPedCli ) .and. ::oDbfPedCli:Used()
      ::oDbfPedCli:End()
   end if

   if !Empty( ::oDbfAlbCli ) .and. ::oDbfAlbCli:Used()
      ::oDbfAlbCli:End()
   end if

   if !Empty( ::oDbfFacCli ) .and. ::oDbfFacCli:Used()
      ::oDbfFacCli:End()
   end if

   if !Empty( ::oDbfTpvCli ) .and. ::oDbfTpvCli:Used()
      ::oDbfTpvCli:End()
   end if

   if !Empty( ::oDbfTblPro ) .and. ::oDbfTblPro:Used()
      ::oDbfTblPro:End()
   end if

   if !Empty( ::oDbfAgentes ) .and. ::oDbfAgentes:Used()
      ::oDbfAgentes:End()
   end if

   if !Empty( ::oDbfClient ) .and. ::oDbfClient:Used()
      ::oDbfClient:End()
   end if

   if !Empty( ::oDbfTpvCliT ) .and. ::oDbfTpvCliT:Used()
      ::oDbfTpvCliT:End()
   end if

   if !Empty( ::oDbfPreCliT ) .and. ::oDbfPreCliT:Used()
      ::oDbfPreCliT:End()
   end if

   if !Empty( ::oDbfPedCliT ) .and. ::oDbfPedCliT:Used()
      ::oDbfPedCliT:End()
   end if

   if !Empty( ::oDbfAlbCliT ) .and. ::oDbfAlbCliT:Used()
      ::oDbfAlbCliT:End()
   end if

  if !Empty( ::oDbfFacCliT ) .and. ::oDbfFacCliT:Used()
      ::oDbfFacCliT:End()
   end if

  if !Empty( ::oDbfFacCliP ) .and. ::oDbfFacCliP:Used()
      ::oDbfFacCliP:End()
   end if

  if !Empty( ::oDbfPago ) .and. ::oDbfPago:Used()
      ::oDbfPago:End()
   end if

  if !Empty( ::oDbfPedPrvT ) .and. ::oDbfPedPrvT:Used()
      ::oDbfPedPrvt:End()
   end if

  if !Empty( ::oDbfAlbPrvT ) .and. ::oDbfAlbPrvT:Used()
      ::oDbfAlbPrvT:End()
   end if

  if !Empty( ::oDbfFacPrvT ) .and. ::oDbfFacPrvT:Used()
      ::oDbfFacPrvT:End()
   end if

   if !Empty( ::oDbfEmpresa ) .and. ::oDbfEmpresa:Used()
      ::oDbfEmpresa:End()
   end if

   if !Empty( ::oDbfMatProd ) .and. ::oDbfMatProd:Used()
      ::oDbfMatProd:End()
   end if

   if !Empty( ::oDbfMatPrima ) .and. ::oDbfMatPrima:Used()
      ::oDbfMatPrima:End()
   end if

  if !Empty( ::oGrpFam )
      ::oGrpFam:End()
   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Resource( cFldRes ) CLASS TChgCode

   local oThis       := Self
   local cSayGrfOld  := ""
   local cSayGrfNew  := ""
   local cSayFamOld  := ""
   local cSayFamNew  := ""
   local cSayArtOld  := ""
   local cTxtPr1Old  := ""
   local cSayPr1Old  := ""
   local cTxtPr2Old  := ""
   local cSayPr2Old  := ""
   local cSayEscOld  := ""
   local cSayArtNew  := ""
   local cTxtPr1New  := ""
   local cSayPr1New  := ""
   local cTxtPr2New  := ""
   local cSayPr2New  := ""

   if !::lStabilize
      RETURN ( Self )
   end if

   /*
   Caja de dialogo-------------------------------------------------------------
   */

   DEFINE DIALOG ::oDlg RESOURCE "CHGCODE" OF oWnd()

   REDEFINE RADIO ::oRadCod VAR ::nRadCod ;
      ID       100, 101, 102, 103, 104, 105 ;
      OF       ::oDlg

   /*
   Grupos de familias----------------------------------------------------------
   */

   REDEFINE GET ::oGetGrfOld VAR ::cGetGrfOld;
      ID       110;
      WHEN     ( ::nRadCod == 1 );
      VALID    oThis:oGrpFam:Existe( oThis:oGetGrfOld, oThis:oSayGrfOld ) ;
      BITMAP   "LUPA" ;
      ON HELP  oThis:oGrpFam:Buscar( oThis:oGetGrfOld ) ;
      OF       ::oDlg

   REDEFINE GET ::oSayGrfOld VAR cSayGrfOld ;
      ID       111;
      WHEN     .f.;
      OF       ::oDlg

   REDEFINE GET ::oGetGrfNew VAR ::cGetGrfNew;
      ID       120;
      WHEN     ( ::nRadCod == 1 );
      VALID    ( oThis:oGrpFam:Existe( oThis:oGetGrfNew, oThis:oSayGrfNew ), .t. );
      BITMAP   "LUPA" ;
      ON HELP  oThis:oGrpFam:Buscar( oThis:oGetGrfNew ) ;
      OF       ::oDlg

   REDEFINE GET ::oSayGrfNew VAR cSayGrfNew ;
      ID       121;
      WHEN     .f.;
      OF       ::oDlg

   /*
   Familias--------------------------------------------------------------------
   */

   REDEFINE GET ::oGetFamOld VAR ::cGetFamOld ;
      ID       130;
      WHEN     ( ::nRadCod == 2 );
      VALID    ( cFamilia( oThis:oGetFamOld, oThis:oDbfFam:cAlias, oThis:oSayFamOld ) );
      BITMAP   "LUPA" ;
      ON HELP  BrwFamilia( oThis:oGetFamOld, oThis:oSayFamOld ) ;
      OF       ::oDlg

   REDEFINE GET ::oSayFamOld VAR cSayFamOld ;
      ID       131;
      WHEN     .f.;
      OF       ::oDlg

   REDEFINE GET ::oGetFamNew VAR ::cGetFamNew ;
      ID       140;
      WHEN     ( ::nRadCod == 2 );
      VALID    ( cFamilia( oThis:oGetFamNew, oThis:oDbfFam:cAlias, oThis:oSayFamNew, .f. ), .t. );
      BITMAP   "LUPA" ;
      ON HELP  BrwFamilia( oThis:oGetFamNew, oThis:oSayFamNew ) ;
      OF       ::oDlg

   REDEFINE GET ::oSayFamNew VAR cSayFamNew ;
      ID       141;
      WHEN     .f.;
      OF       ::oDlg

   /*
   Articulos-------------------------------------------------------------------
   */

   REDEFINE GET ::oGetArtOld VAR ::cGetArtOld ;
      ID       150;
      WHEN     ( ::nRadCod == 3 );
      VALID    ( oThis:loaArtOld() );
      BITMAP   "LUPA" ;
      ON HELP  BrwArticulo( oThis:oGetArtOld, oThis:oSayArtOld ) ;
      OF       ::oDlg

   REDEFINE GET ::oSayArtOld VAR cSayArtOld ;
      ID       151;
      WHEN     .f.;
      OF       ::oDlg

   REDEFINE SAY ::oTxtPr1Old VAR cTxtPr1Old ;
      ID       160 ;
      OF       ::oDlg

   REDEFINE GET ::oGetPr1Old VAR ::cGetPr1Old;
      ID       161 ;
      BITMAP   "LUPA" ;
      VALID    ( lPrpAct( oThis:oGetPr1Old, oThis:oSayPr1Old, oThis:cCodPr1Old, oThis:oDbfTblPro:cAlias ), .t. ) ;
      ON HELP  ( brwPropiedadActual( oThis:oGetPr1Old, oThis:oSayPr1Old, oThis:cCodPr1Old ) ) ;
      OF       ::oDlg

   REDEFINE GET ::oSayPr1Old VAR cSayPr1Old ;
      ID       162 ;
      WHEN     .f. ;
      OF       ::oDlg

   REDEFINE SAY ::oTxtPr2Old VAR cTxtPr2Old ;
      ID       170 ;
      OF       ::oDlg

   REDEFINE GET ::oGetPr2Old VAR ::cGetPr2Old;
      ID       171 ;
      BITMAP   "LUPA" ;
      VALID    ( lPrpAct( oThis:oGetPr2Old, oThis:oSayPr2Old, oThis:cCodPr2Old, oThis:oDbfTblPro:cAlias ), .t. ) ;
      ON HELP  ( brwPropiedadActual( oThis:oGetPr2Old, oThis:oSayPr2Old, oThis:cCodPr2Old ) ) ;
      OF       ::oDlg

   REDEFINE GET ::oSayPr2Old VAR cSayPr2Old ;
      ID       172 ;
      WHEN     .f. ;
      OF       ::oDlg

   REDEFINE GET ::oGetArtNew VAR ::cGetArtNew ;
      ID       180;
      WHEN     ( ::nRadCod == 3 );
      VALID    ( oThis:loaArtNew() );
      BITMAP   "LUPA" ;
      ON HELP  BrwArticulo( oThis:oGetArtNew, oThis:oSayArtNew ) ;
      OF       ::oDlg

   REDEFINE GET ::oSayArtNew VAR cSayArtNew ;
      ID       181;
      WHEN     .f.;
      OF       ::oDlg

   REDEFINE SAY ::oTxtPr1New VAR cTxtPr1New ;
      ID       190 ;
      OF       ::oDlg

   REDEFINE GET ::oGetPr1New VAR ::cGetPr1New;
      ID       191 ;
      BITMAP   "LUPA" ;
      VALID    ( lPrpAct( oThis:oGetPr1New, oThis:oSayPr1New, oThis:cCodPr1New, oThis:oDbfTblPro:cAlias ), .t. ) ;
      ON HELP  ( brwPropiedadActual( oThis:oGetPr1New, oThis:oSayPr1New, oThis:cCodPr1New ) ) ;
      OF       ::oDlg

   REDEFINE GET ::oSayPr1New VAR cSayPr1New ;
      ID       192 ;
      WHEN     .f. ;
      OF       ::oDlg

   REDEFINE SAY ::oTxtPr2New VAR cTxtPr2New ;
      ID       200 ;
      OF       ::oDlg

   REDEFINE GET ::oGetPr2New VAR ::cGetPr2New;
      ID       201 ;
      BITMAP   "LUPA" ;
      VALID    ( lPrpAct( oThis:oGetPr2New, oThis:oSayPr2New, oThis:cCodPr2New, oThis:oDbfTblPro:cAlias ), .t. ) ;
      ON HELP  ( brwPropiedadActual( oThis:oGetPr2New, oThis:oSayPr2New, oThis:cCodPr2New ) ) ;
      OF       ::oDlg

   REDEFINE GET ::oSayPr2New VAR cSayPr2New ;
      ID       202 ;
      WHEN     .f. ;
      OF       ::oDlg

   /*
   Lineas de escandallos-------------------------------------------------------
   */

   REDEFINE GET ::oGetEscOld VAR ::cGetEscOld ;
      ID       210;
      WHEN     ( ::nRadCod == 4 );
      VALID    ( cArticulo( oThis:oGetEscOld, ::oDbfArt:cAlias, oThis:oSayEscOld ) );
      BITMAP   "LUPA" ;
      ON HELP  BrwArticulo( oThis:oGetEscOld, oThis:oSayEscOld ) ;
      OF       ::oDlg

   REDEFINE GET ::oSayEscOld VAR cSayEscOld ;
      ID       211;
      WHEN     .f.;
      OF       ::oDlg

   REDEFINE GET ::oGetEscNew VAR ::cGetEscNew ;
      ID       220;
      WHEN     ( ::nRadCod == 4 );
      VALID    ( cArticulo( oThis:oGetEscNew, ::oDbfArt:cAlias, oThis:oSayEscNew ), .t. );
      BITMAP   "LUPA" ;
      ON HELP  BrwArticulo( oThis:oGetEscNew, oThis:oSayEscNew ) ;
      OF       ::oDlg

   REDEFINE GET ::oSayEscNew VAR ::cSayEscNew ;
      ID       221;
      WHEN     .f.;
      OF       ::oDlg

   //Agentes

   REDEFINE GET ::oAgenteOld VAR ::cAgenteOld ;
      ID       300;
      WHEN     ( ::nRadCod == 5 );
      VALID    ( cAgentes( oThis:oAgenteOld, ::oDbfAgentes:cAlias, oThis:oSayAgenteOld ) );
      BITMAP   "LUPA" ;
      ON HELP  BrwAgentes( oThis:oAgenteOld, oThis:oSayAgenteOld ) ;
      OF       ::oDlg

   REDEFINE GET ::oSayAgenteOld VAR ::cSayAgenteOld ;
      ID       310;
      WHEN     .f.;
      OF       ::oDlg

   REDEFINE GET ::oAgenteNew VAR ::cAgenteNew ;
      ID       320;
      WHEN     ( ::nRadCod == 5 );
      BITMAP   "LUPA" ;
      ON HELP  BrwAgentes( oThis:oAgenteNew, oThis:oSayAgenteNew ) ;
      OF       ::oDlg

   REDEFINE GET ::oSayAgenteNew VAR ::cSayAgenteNew ;
      ID       330;
      WHEN     .f.;
      OF       ::oDlg

   //Formas de pago

   REDEFINE GET ::oPagoOld VAR ::cPagoOld ;
      ID       400;
      WHEN     ( ::nRadCod == 6 );
      VALID    ( cFPago( oThis:oPagoOld, ::oDbfPago:cAlias, oThis:oSayPagoOld ) );
      BITMAP   "LUPA" ;
      ON HELP  BrwFPago( oThis:oPagoOld, oThis:oSayPagoOld ) ;
      OF       ::oDlg

   REDEFINE GET ::oSayPagoOld VAR ::cSayPagoOld ;
      ID       410;
      WHEN     .f.;
      OF       ::oDlg

   REDEFINE GET ::oPagoNew VAR ::cPagoNew ;
      ID       420;
      WHEN     ( ::nRadCod == 6 );
      BITMAP   "LUPA" ;
      ON HELP  BrwFPago( oThis:oPagoNew, oThis:oSayPagoNew ) ;
      OF       ::oDlg

   REDEFINE GET ::oSayPagoNew VAR ::cSayPagoNew ;
      ID       430;
      WHEN     .f.;
      OF       ::oDlg

   /*
   Meter-----------------------------------------------------------------------
   */

 REDEFINE APOLOMETER ::oMtrInf VAR ::nMtrInf ;
		PROMPT	"Procesando" ;
      ID       1160;
      TOTAL    100 ;
      OF       ::oDlg

   REDEFINE BUTTON ;
      ID       IDOK ;
      OF       ::oDlg ;
      ACTION   ( oThis:ChgCode() )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
      OF       ::oDlg ;
      ACTION   ( oThis:End()  )

   ::oDlg:AddFastKey( VK_F5, {|| oThis:ChgCode() } )

   ACTIVATE DIALOG ::oDlg CENTER

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD ChgCode()

   local pVenta1
   local pVtaIva1
   local pVenta2
   local pVtaIva2
   local pVenta3
   local pVtaIva3
   local pVenta4
   local pVtaIva4
   local pVenta5
   local pVtaIva5
   local pVenta6
   local pVtaIva6
   local lErrors  := .f.

   ::oDlg:Disable()

   ::nRecChanged  := 0

   do case
      case ::nRadCod == 1

         if Empty( ::cGetGrfOld )
            MsgStop( "Grupo de familia actual no válido" )
            lErrors  := .t.
         end if

         if !lErrors .and. Empty( ::cGetGrfNew )
            MsgStop( "Grupo de familia nuevo no válido" )
            lErrors  := .t.
         end if

         if !lErrors .and. ::cGetGrfOld == ::cGetGrfNew
            MsgStop( "Grupo de familia actual y nuevo son iguales" )
            lErrors  := .t.
         end if

         if !lErrors .and. ::oGrpFam:oDbf:Seek( ::cGetGrfNew ) .and. !ApoloMsgNoYes( "El grupo de familias nuevo ya existe.", "¿Desea anexar al código existente?" )
            lErrors  := .t.
         end if

         if !lErrors

         ::oMtrInf:nTotal           := ::oDbfFam:Lastrec()

         ::oDbfFam:OrdSetFocus( 0 )
         ::oDbfFam:GoTop()
         while !::oDbfFam:Eof()
            if ::oDbfFam:cCodGrp == ::cGetGrfOld
               ::oDbfFam:Load()
               ::oDbfFam:cCodGrp    := ::cGetGrfNew
               ::oDbfFam:Save()
               ::nRecChanged++
            end if
            ::oDbfFam:Skip()
            ::oMtrInf:AutoInc( ::oDbfFam:Recno() )
         end while

         if !::oGrpFam:oDbf:Seek( ::cGetGrfNew )
            if ::oGrpFam:oDbf:Seek( ::cGetGrfOld )
               ::oGrpFam:oDbf:Load()
               ::oGrpFam:oDbf:cCodGrp  := ::cGetGrfNew
               ::oGrpFam:oDbf:Save()
            end if
         else
            if ::oGrpFam:oDbf:Seek( ::cGetGrfOld )
               ::oGrpFam:oDbf:Delete(.f.)
            end if
         end if

         MsgInfo( "Total de registros cambiados : " + Str( ::nRecChanged ) )

         ::oGetGrfOld:cText( Space( 3 ) )
         ::oGetGrfNew:cText( Space( 3 ) )
         ::oSayGrfOld:cText( "" )
         ::oSayGrfNew:cText( "" )

         ::oGetGrfOld:SetFocus()

         end if

      case ::nRadCod == 2

         if Empty( ::cGetFamOld )
            MsgStop( "Familia actual no válida" )
            lErrors  := .t.
         end if

         if !lErrors .and. Empty( ::cGetFamNew )
            MsgStop( "Familia nueva no válida" )
            lErrors  := .t.
         end if

         if !lErrors .and. ::cGetFamOld == ::cGetFamNew
            MsgStop( "Familia actual y nueva son iguales" )
            lErrors  := .t.
         end if

         if !lErrors .and. ::oDbfFam:Seek( ::cGetFamNew ) .and. !ApoloMsgNoYes( "La familia nueva ya existe.", "¿Desea anexar al código existente?" )
            lErrors  := .t.
         end if

         if !lErrors

         ::oMtrInf:nTotal           := ::oDbfArt:Lastrec()

         ::oDbfArt:OrdSetFocus( 0 )
         ::oDbfArt:GoTop()
         while !::oDbfArt:Eof()
            if ::oDbfArt:Familia == ::cGetFamOld
               ::oDbfArt:Load()
               ::oDbfArt:Familia    := ::cGetFamNew
               ::oDbfArt:Save()
               ::nRecChanged++
            end if
            ::oDbfArt:Skip()
            ::oMtrInf:AutoInc( ::oDbfArt:Recno() )
         end while

         if !::oDbfFam:Seek( ::cGetFamNew )
            if ::oDbfFam:Seek( ::cGetFamOld )
               ::oDbfFam:Load()
               ::oDbfFam:cCodFam       := ::cGetFamNew
               ::oDbfFam:Save()
            end if
         else
            if ::oDbfFam:Seek( ::cGetFamOld )
               ::oDbfFam:Delete(.f.)
            end if
         end if

         MsgInfo( "Total de registros cambiados : " + Str( ::nRecChanged ) )

         ::oGetFamOld:cText( Space( 8 ) )
         ::oGetFamNew:cText( Space( 8 ) )
         ::oSayFamOld:cText( "" )
         ::oSayFamNew:cText( "" )

         ::oGetFamOld:SetFocus()

         end if

      case ::nRadCod == 3
/*
         if Empty( ::cGetArtOld )
            MsgStop( "Artículo actual no válido" )
            lErrors  := .t.
         end if

         if !lErrors .and. Empty( ::cGetArtNew )
            MsgStop( "Artículo nuevo no válido" )
            lErrors  := .t.
         end if

         if !lErrors .and. ::cGetArtOld == ::cGetArtNew
            MsgStop( "Artículo actual y nuevo son iguales" )
            lErrors  := .t.
         end if

         if !lErrors .and. ::oDbfArt:Seek( ::cGetArtNew ) .and. !ApoloMsgNoYes( "El artículo nuevo ya existe.", "¿Desea anexar al código existente?" )
            lErrors  := .t.
         end if
*/
         if !lErrors

         ::oMtrInf:nTotal           := ::oDbfTblPro:Lastrec()

         ::oDbfTblPro:OrdSetFocus( 0 )

         ::oDbfTblPro:GoTop()
         while !::oDbfTblPro:Eof()

            if alltrim( ::oDbfTblPro:cCodTbl ) == alltrim( ::cGetPr2Old )
               ::oDbfTblPro:Load()
               ::oDbfTblPro:cCodTbl := ::cGetPr2New
               ::oDbfTblPro:Save()
               ::nRecChanged++
            end if
            
            ::oDbfTblPro:Skip()
            
            ::oMtrInf:AutoInc( ::oDbfTblPro:Recno() )

         end while

         ::oMtrInf:nTotal           := ::oDbfPrv:Lastrec()

         ::oDbfPrv:OrdSetFocus( 0 )

         ::oDbfPrv:GoTop()
         while !::oDbfPrv:Eof()
            if Trim( ::oDbfPrv:cCodArt ) == Trim( ::cGetArtOld )
               ::oDbfPrv:Load()
               ::oDbfPrv:cCodArt    := ::cGetArtNew
               ::oDbfPrv:Save()
               ::nRecChanged++
            end if
            ::oDbfPrv:Skip()
            ::oMtrInf:AutoInc( ::oDbfPrv:Recno() )
         end while

         ::oMtrInf:nTotal           := ::oDbfTar:Lastrec()

         ::oDbfTar:OrdSetFocus( 0 )

         ::oDbfTar:GoTop()
         while !::oDbfTar:Eof()

            if Trim( ::oDbfTar:cCodArt ) == Trim( ::cGetArtOld )
               ::oDbfTar:Load()
               ::oDbfTar:cCodArt    := ::cGetArtNew
               ::oDbfTar:Save()
               ::nRecChanged++
            end if
            ::oDbfTar:Skip()
            ::oMtrInf:AutoInc( ::oDbfTar:Recno() )
         end while


         // Cambios de ofertas-------------------------------------------------

         ::oMtrInf:nTotal           := ::oDbfOfe:Lastrec()

         ::oDbfOfe:OrdSetFocus( 0 )

         ::oDbfOfe:GoTop()
         while !::oDbfOfe:Eof()

            if Trim( ::oDbfOfe:cArtOfe ) == Trim( ::cGetArtOld )
               ::oDbfOfe:Load()
               ::oDbfOfe:cArtOfe    := ::cGetArtNew
               ::oDbfOfe:Save()
               ::nRecChanged++
            end if
            ::oDbfOfe:Skip()
            ::oMtrInf:AutoInc( ::oDbfOfe:Recno() )
         end while


         ::oMtrInf:nTotal           := ::oDbfArd:Lastrec()

         ::oDbfArd:OrdSetFocus( 0 )

         ::oDbfArd:GoTop()
         while !::oDbfArd:Eof()

            if Trim( ::oDbfArd:cCodArt ) == Trim( ::cGetArtOld )
               ::oDbfArd:Load()
               ::oDbfArd:cCodArt    := ::cGetArtNew
               ::oDbfArd:Save()
               ::nRecChanged++
            end if

            ::changeSecondPropertie( ::oDbfArd )

            ::oDbfArd:Skip()

            ::oMtrInf:AutoInc( ::oDbfArd:Recno() )

         end while

         ::oMtrInf:nTotal           := ::oDbfKit:Lastrec()

         ::oDbfKit:OrdSetFocus( 0 )
         ::oDbfKit:GoTop()
         while !::oDbfKit:Eof()

            if Trim( ::oDbfKit:cCodKit ) == Trim( ::cGetArtOld )
               ::oDbfKit:Load()
               ::oDbfKit:cCodKit    := ::cGetArtNew
               ::oDbfKit:Save()
               ::nRecChanged++
            end if
            ::oDbfKit:Skip()
            ::oMtrInf:AutoInc( ::oDbfKit:Recno() )
         end while

         ::oMtrInf:nTotal           := ::oDbfCliAtp:Lastrec()

         ::oDbfCliAtp:OrdSetFocus( 0 )
         ::oDbfCliAtp:GoTop()
         while !::oDbfCliAtp:Eof()

            if Trim( ::oDbfCliAtp:cCodArt ) == Trim( ::cGetArtOld )
               ::oDbfCliAtp:Load()
               ::oDbfCliAtp:cCodArt := ::cGetArtNew
               ::oDbfCliAtp:Save()
               ::nRecChanged++
            end if
            ::oDbfCliAtp:Skip()
            ::oMtrInf:AutoInc( ::oDbfCliAtp:Recno() )
         end while

         ::oMtrInf:nTotal           := ::oDbfPedPrv:Lastrec()

         ::oDbfPedPrv:OrdSetFocus( 0 )

         ::oDbfPedPrv:GoTop()
         while !::oDbfPedPrv:Eof()

            if Trim( ::oDbfPedPrv:cRef ) == Trim( ::cGetArtOld )
               ::oDbfPedPrv:Load()
               ::oDbfPedPrv:cRef    := ::cGetArtNew
               ::oDbfPedPrv:cCodPr1 := ::cCodPr1New
               ::oDbfPedPrv:cValPr1 := ::cGetPr1New
               ::oDbfPedPrv:cCodPr2 := ::cCodPr2New
               ::oDbfPedPrv:cValPr2 := ::cGetPr2New
               ::oDbfPedPrv:Save()
               ::nRecChanged++
            end if

            ::changeSecondPropertie( ::oDbfPedPrv )

            ::oDbfPedPrv:Skip()

            ::oMtrInf:AutoInc( ::oDbfPedPrv:Recno() )

         end while

         ::oMtrInf:nTotal           := ::oDbfAlbPrv:Lastrec()

         ::oDbfAlbPrv:OrdSetFocus( 0 )

         ::oDbfAlbPrv:GoTop()
         while !::oDbfAlbPrv:Eof()

            if Trim( ::oDbfAlbPrv:cRef ) == Trim( ::cGetArtOld )
               ::oDbfAlbPrv:Load()
               ::oDbfAlbPrv:cRef    := ::cGetArtNew
               ::oDbfAlbPrv:cCodPr1 := ::cCodPr1New
               ::oDbfAlbPrv:cValPr1 := ::cGetPr1New
               ::oDbfAlbPrv:cCodPr2 := ::cCodPr2New
               ::oDbfAlbPrv:cValPr2 := ::cGetPr2New
               ::oDbfAlbPrv:Save()
               ::nRecChanged++
            end if

            ::changeSecondPropertie( ::oDbfAlbPrv )

            ::oDbfAlbPrv:Skip()
            ::oMtrInf:AutoInc( ::oDbfAlbPrv:Recno() )
         end while

         ::oMtrInf:nTotal           := ::oDbfFacPrv:Lastrec()

         ::oDbfFacPrv:OrdSetFocus( 0 )

         ::oDbfFacPrv:GoTop()
         while !::oDbfFacPrv:Eof()

            if Trim( ::oDbfFacPrv:cRef ) == Trim( ::cGetArtOld )
               ::oDbfFacPrv:Load()
               ::oDbfFacPrv:cRef    := ::cGetArtNew
               ::oDbfFacPrv:cCodPr1 := ::cCodPr1New
               ::oDbfFacPrv:cValPr1 := ::cGetPr1New
               ::oDbfFacPrv:cCodPr2 := ::cCodPr2New
               ::oDbfFacPrv:cValPr2 := ::cGetPr2New
               ::oDbfFacPrv:Save()
               ::nRecChanged++
            end if

            ::changeSecondPropertie( ::oDbfFacPrv )
            
            ::oDbfFacPrv:Skip()
            ::oMtrInf:AutoInc( ::oDbfFacPrv:Recno() )

         end while

         ::oMtrInf:nTotal           := ::oDbfDepAge:Lastrec()

         ::oDbfDepAge:OrdSetFocus( 0 )
         ::oDbfDepAge:GoTop()
         while !::oDbfDepAge:Eof()
            if Trim( ::oDbfDepAge:cRef ) == Trim( ::cGetArtOld )
               ::oDbfDepAge:Load()
               ::oDbfDepAge:cRef    := ::cGetArtNew
               ::oDbfDepAge:Save()
               ::nRecChanged++
            end if
            ::oDbfDepAge:Skip()
            ::oMtrInf:AutoInc( ::oDbfDepAge:Recno() )
         end while

         ::oMtrInf:nTotal           := ::oDbfExtAge:Lastrec()

         ::oDbfExtAge:OrdSetFocus( 0 )
         ::oDbfExtAge:GoTop()
         while !::oDbfExtAge:Eof()
            if Trim( ::oDbfExtAge:cRef ) == Trim( ::cGetArtOld )
               ::oDbfExtAge:Load()
               ::oDbfExtAge:cRef    := ::cGetArtNew
               ::oDbfExtAge:Save()
               ::nRecChanged++
            end if
            ::oDbfExtAge:Skip()
            ::oMtrInf:AutoInc( ::oDbfExtAge:Recno() )
         end while

         ::oMtrInf:nTotal           := ::oDbfPreCli:Lastrec()

         ::oDbfPreCli:OrdSetFocus( 0 )

         ::oDbfPreCli:GoTop()
         while !::oDbfPreCli:Eof()
            if Trim( ::oDbfPreCli:cRef ) == Trim( ::cGetArtOld )
               ::oDbfPreCli:Load()
               ::oDbfPreCli:cRef    := ::cGetArtNew
               ::oDbfPreCli:cCodPr1 := ::cCodPr1New
               ::oDbfPreCli:cValPr1 := ::cGetPr1New
               ::oDbfPreCli:cCodPr2 := ::cCodPr2New
               ::oDbfPreCli:cValPr2 := ::cGetPr2New
               ::oDbfPreCli:Save()
               ::nRecChanged++
            end if

            ::changeSecondPropertie( ::oDbfPreCli )

            ::oDbfPreCli:Skip()
            ::oMtrInf:AutoInc( ::oDbfPreCli:Recno() )
         end while

         ::oMtrInf:nTotal           := ::oDbfPedCli:Lastrec()

         ::oDbfPedCli:OrdSetFocus( 0 )

         ::oDbfPedCli:GoTop()
         while !::oDbfPedCli:Eof()
            if Trim( ::oDbfPedCli:cRef ) == Trim( ::cGetArtOld )
               ::oDbfPedCli:Load()
               ::oDbfPedCli:cRef    := ::cGetArtNew
               ::oDbfPedCli:cCodPr1 := ::cCodPr1New
               ::oDbfPedCli:cValPr1 := ::cGetPr1New
               ::oDbfPedCli:cCodPr2 := ::cCodPr2New
               ::oDbfPedCli:cValPr2 := ::cGetPr2New
               ::oDbfPedCli:Save()
               ::nRecChanged++
            end if

            ::changeSecondPropertie( ::oDbfPedCli )

            ::oDbfPedCli:Skip()
            
            ::oMtrInf:AutoInc( ::oDbfPedCli:Recno() )

         end while

         ::oMtrInf:nTotal           := ::oDbfAlbCli:Lastrec()

         ::oDbfAlbCli:OrdSetFocus( 0 )

         ::oDbfAlbCli:GoTop()
         while !::oDbfAlbCli:Eof()
            if Trim( ::oDbfAlbCli:cRef ) == Trim( ::cGetArtOld )
               ::oDbfAlbCli:Load()
               ::oDbfAlbCli:cRef    := ::cGetArtNew
               ::oDbfAlbCli:cCodPr1 := ::cCodPr1New
               ::oDbfAlbCli:cValPr1 := ::cGetPr1New
               ::oDbfAlbCli:cCodPr2 := ::cCodPr2New
               ::oDbfAlbCli:cValPr2 := ::cGetPr2New
               ::oDbfAlbCli:Save()
               ::nRecChanged++
            end if

            ::changeSecondPropertie( ::oDbfAlbCli )

            ::oDbfAlbCli:Skip()
            
            ::oMtrInf:AutoInc( ::oDbfAlbCli:Recno() )

         end while

         ::oMtrInf:nTotal           := ::oDbfFacCli:Lastrec()

         ::oDbfFacCli:OrdSetFocus( 0 )

         ::oDbfFacCli:GoTop()
         while !::oDbfFacCli:Eof()
            if Trim( ::oDbfFacCli:cRef ) == Trim( ::cGetArtOld )
               ::oDbfFacCli:Load()
               ::oDbfFacCli:cRef    := ::cGetArtNew
               ::oDbfFacCli:cCodPr1 := ::cCodPr1New
               ::oDbfFacCli:cValPr1 := ::cGetPr1New
               ::oDbfFacCli:cCodPr2 := ::cCodPr2New
               ::oDbfFacCli:cValPr2 := ::cGetPr2New
               ::oDbfFacCli:Save()
               ::nRecChanged++
            end if

            ::changeSecondPropertie( ::oDbfFacCli )

            ::oDbfFacCli:Skip()
            ::oMtrInf:AutoInc( ::oDbfFacCli:Recno() )
         end while

         ::oMtrInf:nTotal           := ::oDbfTpvCli:Lastrec()

         ::oDbfTpvCli:OrdSetFocus( 0 )

         ::oDbfTpvCli:GoTop()
         while !::oDbfTpvCli:Eof()
            if Trim( ::oDbfTpvCli:cCbaTil ) == Trim( ::cGetArtOld )
               ::oDbfTpvCli:Load()
               ::oDbfTpvCli:cCbaTil := ::cGetArtNew
               ::oDbfTpvCli:cCodPr1 := ::cCodPr1New
               ::oDbfTpvCli:cValPr1 := ::cGetPr1New
               ::oDbfTpvCli:cCodPr2 := ::cCodPr2New
               ::oDbfTpvCli:cValPr2 := ::cGetPr2New
               ::oDbfTpvCli:Save()
               ::nRecChanged++
            end if

            ::changeSecondPropertie( ::oDbfTpvCli )

            ::oDbfTpvCli:Skip()
            ::oMtrInf:AutoInc( ::oDbfTpvCli:Recno() )
         end while

         ::oMtrInf:nTotal             := ::oDbfMatProd:Lastrec()

         ::oDbfMatProd:OrdSetFocus( 0 )

         ::oDbfMatProd:GoTop()
         while !::oDbfMatProd:Eof()
            if Trim( ::oDbfMatProd:cCodArt ) == Trim( ::cGetArtOld )
               ::oDbfMatProd:Load()
               ::oDbfMatProd:cCodArt   :=  ::cGetArtNew
               ::oDbfMatProd:cCodPr1   := ::cCodPr1New
               ::oDbfMatProd:cValPr1   := ::cGetPr1New
               ::oDbfMatProd:cCodPr2   := ::cCodPr2New
               ::oDbfMatProd:cValPr2   := ::cGetPr2New
               ::oDbfMatProd:Save()
               ::nRecChanged++
            end if 

            ::changeSecondPropertie( ::oDbfMatProd )

            ::oDbfMatProd:Skip()
            ::oMtrInf:AutoInc( ::oDbfMatProd:Recno() )
         end while

         ::oMtrInf:nTotal             := ::oDbfMatPrima:Lastrec()

         ::oDbfMatPrima:OrdSetFocus( 0 )

         ::oDbfMatPrima:GoTop()
         while !::oDbfMatPrima:Eof()
            if Trim( ::oDbfMatPrima:cCodArt ) == Trim( ::cGetArtOld )
               ::oDbfMatPrima:Load()
               ::oDbfMatPrima:cCodArt   :=  ::cGetArtNew
               ::oDbfMatPrima:cCodPr1   := ::cCodPr1New
               ::oDbfMatPrima:cValPr1   := ::cGetPr1New
               ::oDbfMatPrima:cCodPr2   := ::cCodPr2New
               ::oDbfMatPrima:cValPr2   := ::cGetPr2New
               ::oDbfMatPrima:Save()
               ::nRecChanged++
            end if 

            ::changeSecondPropertie( ::oDbfMatPrima )

            ::oDbfMatPrima:Skip()
            ::oMtrInf:AutoInc( ::oDbfMatPrima:Recno() )
         end while

         /*
         Si existe el codigo anterior
         */

         if ::oDbfArt:Seek( ::cGetArtNew )

            if ::oDbfArt:Seek( ::cGetArtOld )

               ::oDbfArt:Load()
               pVenta1  := ::oDbfArt:pVenta1
               pVtaIva1 := ::oDbfArt:pVtaIva1
               pVenta2  := ::oDbfArt:pVenta2
               pVtaIva2 := ::oDbfArt:pVtaIva2
               pVenta3  := ::oDbfArt:pVenta3
               pVtaIva3 := ::oDbfArt:pVtaIva3
               pVenta4  := ::oDbfArt:pVenta4
               pVtaIva4 := ::oDbfArt:pVtaIva4
               pVenta5  := ::oDbfArt:pVenta5
               pVtaIva5 := ::oDbfArt:pVtaIva5
               pVenta6  := ::oDbfArt:pVenta6
               pVtaIva6 := ::oDbfArt:pVtaIva6
               ::oDbfArt:Save()

            end if

            if ::oDbfArt:Seek( ::cGetArtNew )

               ::oDbfArt:Load()
               ::oDbfArt:pVenta1    := pVenta1
               ::oDbfArt:pVtaIva1   := pVtaIva1
               ::oDbfArt:pVenta2    := pVenta2
               ::oDbfArt:pVtaIva2   := pVtaIva2
               ::oDbfArt:pVenta3    := pVenta3
               ::oDbfArt:pVtaIva3   := pVtaIva3
               ::oDbfArt:pVenta4    := pVenta4
               ::oDbfArt:pVtaIva4   := pVtaIva4
               ::oDbfArt:pVenta5    := pVenta5
               ::oDbfArt:pVtaIva5   := pVtaIva5
               ::oDbfArt:pVenta6    := pVenta6
               ::oDbfArt:pVtaIva6   := pVtaIva6
               ::oDbfArt:Save()

            end if

         else

            if ::oDbfArt:Seek( ::cGetArtOld )
               ::oDbfArt:Load()
               ::oDbfArt:Codigo     := ::cGetArtNew
               ::oDbfArt:Save()
            end if

         end if

         MsgInfo( "Total de registros cambiados : " + Str( ::nRecChanged ) )

         ::oGetArtOld:SetFocus()

         end if

      case ::nRadCod == 4   //Escandallos

         if Empty( ::cGetEscOld )
            MsgStop( "Artículo actual no válido" )
            lErrors  := .t.
         end if

         if !lErrors .and. Empty( ::cGetEscNew )
            MsgStop( "Artículo nuevo no válido" )
            lErrors  := .t.
         end if

         if !lErrors .and. ::cGetEscOld == ::cGetEscNew
            MsgStop( "Artículo actual y nuevo son iguales" )
            lErrors  := .t.
         end if

         if !lErrors

         ::oMtrInf:nTotal           := ::oDbfArtKit:Lastrec()

         ::oDbfArtKit:OrdSetFocus( 0 )
         ::oDbfArtKit:GoTop()
         while !::oDbfArtKit:Eof()
            if ::oDbfArtKit:cRefKit == ::cGetEscOld
               ::oDbfArtKit:Load()
               ::oDbfArtKit:cRefKit := ::cGetEscNew
               if !Empty( ::cSayEscNew )
                  ::oDbfArtKit:cDesKit := ::cSayEscNew
               end if
               ::oDbfArtKit:Save()
               ::nRecChanged++
            end if
            ::oDbfArtKit:Skip()
            ::oMtrInf:AutoInc( ::oDbfArtKit:Recno() )
         end while

         MsgInfo( "Total de registros cambiados : " + Str( ::nRecChanged ) )

         ::oGetEscOld:cText( Space( 18 ) )
         ::oGetEscNew:cText( Space( 18 ) )
         ::oSayEscOld:cText( "" )
         ::oSayEscNew:cText( "" )

         ::oGetEscOld:SetFocus()

         end if

      //cambio de codigos de agentes

      case ::nRadCod == 5  //Agente

         if Empty( ::cAgenteOld )
            MsgStop( "Agente actual no válido" )
            lErrors  := .t.
         end if

         if !lErrors .and. Empty( ::cAgenteNew )
            MsgStop( "Agente nuevo no válido" )
            lErrors  := .t.
         end if

         if !lErrors .and. ::cAgenteOld == ::cAgenteNew
            MsgStop( "Agente actual y nuevo son iguales" )
            lErrors  := .t.
         end if

         if !lErrors .and. ::oDbfAgentes:Seek( ::cAgenteNew ) .and. !ApoloMsgNoYes( "El agente nuevo ya existe.", "¿Desea anexar al código existente?" )
            lErrors  := .t.
         end if

         //actualizar clientes

         if !lErrors

         ::oMtrInf:nTotal           := ::oDbfClient:Lastrec()

         ::oDbfClient:OrdSetFocus( 0 )
         ::oDbfClient:GoTop()
         while !::oDbfClient:Eof()
            if ::oDbfClient:cAgente == ::cAgenteOld
               ::oDbfClient:Load()
               ::oDbfClient:cAgente := ::cAgenteNew
               ::oDbfClient:Save()
               ::nRecChanged++
            end if
            ::oDbfClient:Skip()
            ::oMtrInf:AutoInc( ::oDbfClient:Recno() )
         end while

         // presupuesto cliente

         ::oMtrInf:nTotal           := ::oDbfPreCliT:Lastrec()

         ::oDbfPreCliT:OrdSetFocus( 0 )
         ::oDbfPreCliT:GoTop()
         while !::oDbfPreCliT:Eof()
            if ::oDbfPreCliT:cCodAge == ::cAgenteOld
               ::oDbfPreCliT:Load()
               ::oDbfPreCliT:cCodAge := ::cAgenteNew
               ::oDbfPreCliT:Save()
               ::nRecChanged++
            end if
            ::oDbfPreCliT:Skip()
            ::oMtrInf:AutoInc( ::oDbfPreCliT:Recno() )
         end while

         ::oMtrInf:nTotal           := ::oDbfPedCliT:Lastrec()

         ::oDbfPedCliT:OrdSetFocus( 0 )
         ::oDbfPedCliT:GoTop()
         while !::oDbfPedCliT:Eof()
            if ::oDbfPedCliT:cCodAge == ::cAgenteOld
               ::oDbfPedCliT:Load()
               ::oDbfPedCliT:cCodAge := ::cAgenteNew
               ::oDbfPedCliT:Save()
               ::nRecChanged++
            end if
            ::oDbfPedCliT:Skip()
            ::oMtrInf:AutoInc( ::oDbfPedCliT:Recno() )
         end while

         ::oMtrInf:nTotal           := ::oDbfAlbCliT:Lastrec()

         ::oDbfAlbCliT:OrdSetFocus( 0 )
         ::oDbfAlbCliT:GoTop()
         while !::oDbfAlbCliT:Eof()
            if ::oDbfAlbCliT:cCodAge == ::cAgenteOld
               ::oDbfAlbCliT:Load()
               ::oDbfAlbCliT:cCodAge := ::cAgenteNew
               ::oDbfAlbCliT:Save()
               ::nRecChanged++
            end if
            ::oDbfAlbCliT:Skip()
            ::oMtrInf:AutoInc( ::oDbfAlbCliT:RecNo() )
         end while

         ::oMtrInf:nTotal           := ::oDbfFacCliT:Lastrec()

         ::oDbfFacCliT:OrdSetFocus( 0 )
         ::oDbfFacCliT:GoTop()
         while !::oDbfFacCliT:Eof()
            if ::oDbfFacCliT:cCodAge == ::cAgenteOld
               ::oDbfFacCliT:Load()
               ::oDbfFacCliT:cCodAge := ::cAgenteNew
               ::oDbfFacCliT:Save()
               ::nRecChanged++
            end if
            ::oDbfFacCliT:Skip()
            ::oMtrInf:AutoInc( ::oDbfFacCliT:RecNo() )
         end while

         ::oMtrInf:nTotal           := ::oDbfTpvCliT:Lastrec()

         ::oDbfTpvCliT:OrdSetFocus( 0 )
         ::oDbfTpvCliT:GoTop()
         while !::oDbfTpvCliT:Eof()
            if ::oDbfTpvCliT:cCodAge == ::cAgenteOld
               ::oDbfTpvCliT:Load()
               ::oDbfTpvCliT:cCodAge := ::cAgenteNew
               ::oDbfTpvCliT:Save()
               ::nRecChanged++
            end if
            ::oDbfTpvCliT:Skip()
            ::oMtrInf:AutoInc( ::oDbfTpvCliT:RecNo() )
         end while

         ::oMtrInf:nTotal           := ::oDbfFacCliP:Lastrec()

         ::oDbfFacCliP:OrdSetFocus( 0 )
         ::oDbfFacCliP:GoTop()
         while !::oDbfFacCliP:Eof()
            if ::oDbfFacCliP:cCodAge == ::cAgenteOld
               ::oDbfFacCliP:Load()
               ::oDbfFacCliP:cCodAge := ::cAgenteNew
               ::oDbfFacCliP:Save()
               ::nRecChanged++
            end if
            ::oDbfFacCliP:Skip()
            ::oMtrInf:AutoInc( ::oDbfFacCliP:RecNo() )
         end while

         if !::oDbfAgentes:Seek( ::cAgenteNew )
            if ::oDbfAgentes:Seek( ::cAgenteOld )
               ::oDbfAgentes:Load()
               ::oDbfAgentes:cCodAge := ::cAgenteNew
               ::oDbfAgentes:Save()
            end if
         else
            if ::oDbfAgentes:Seek( ::cAgenteOld )
               ::oDbfAgentes:Delete(.f.)
            end if
         end if

         MsgInfo( "Total de registros cambiados : " + Str( ::nRecChanged ) )

         ::oAgenteOld:cText( Space( 18 ) )
         ::oAgenteNew:cText( Space( 18 ) )
         ::oSayAgenteOld:cText( "" )
         ::oSayAgenteNew:cText( "" )

         ::oAgenteOld:SetFocus()

         end if

      //cambio de codigos de formas de pago

      case ::nRadCod == 6

         if Empty( ::cPagoOld )
            MsgStop( "Forma de pago actual no válida" )
            lErrors  := .t.
         end if

         if !lErrors .and. Empty( ::cPagoNew )
            MsgStop( "Forma de pago nueva no válida" )
            lErrors  := .t.
         end if

         if !lErrors .and. ::cPagoOld == ::cPagoNew
            MsgStop( "Forma de pago actual y nueva son iguales" )
            lErrors  := .t.
         end if

         if !lErrors .and. ::oDbfPago:Seek( ::cPagoNew ) .and. !ApoloMsgNoYes( "La forma de pago nueva ya existe.", "¿Desea anexar al código existente?" )
            lErrors  := .t.
         end if

         if !lErrors

         ::oMtrInf:nTotal           := ::oDbfPreCliT:Lastrec()
         ::oMtrInf:AutoInc( 0 )

         //presupuesto cliente
         ::oDbfPreCliT:OrdSetFocus( 0 )
         ::oDbfPreCliT:GoTop()
         while !::oDbfPreCliT:Eof()
            if ::oDbfPreCliT:cCodPgo == ::cPagoOld
               ::oDbfPreCliT:Load()
               ::oDbfPreCliT:cCodPgo := ::cPagoNew
               ::oDbfPreCliT:Save()
               ::nRecChanged++
            end if
            ::oDbfPreCliT:Skip()
            ::oMtrInf:AutoInc( ::oDbfPreCliT:RecNo() )
         end while

         //pedido cliente
         ::oMtrInf:nTotal           := ::oDbfPedCliT:Lastrec()
         ::oMtrInf:AutoInc( 0 )

         ::oDbfPedCliT:OrdSetFocus( 0 )
         ::oDbfPedCliT:GoTop()
         while !::oDbfPedCliT:Eof()
            if ::oDbfPedCliT:cCodPgo == ::cPagoOld
               ::oDbfPedCliT:Load()
               ::oDbfPedCliT:cCodPgo := ::cPagoNew
               ::oDbfPedCliT:Save()
               ::nRecChanged++
            end if
            ::oDbfPedCliT:Skip()
            ::oMtrInf:AutoInc( ::oDbfPedCliT:RecNo() )
         end while

         //albaran cliente
         ::oMtrInf:nTotal           := ::oDbfAlbCliT:Lastrec()
         ::oMtrInf:AutoInc( 0 )

         ::oDbfAlbCliT:OrdSetFocus( 0 )
         ::oDbfAlbCliT:GoTop()
         while !::oDbfAlbCliT:Eof()
            if ::oDbfAlbCliT:cCodPago == ::cPagoOld
               ::oDbfAlbCliT:Load()
               ::oDbfAlbCliT:cCodPago := ::cPagoNew
               ::oDbfAlbCliT:Save()
               ::nRecChanged++
            end if
            ::oDbfAlbCliT:Skip()
            ::oMtrInf:AutoInc( ::oDbfAlbCliT:RecNo() )
         end while

         //factura cliente
         ::oMtrInf:nTotal           := ::oDbfFacCliT:Lastrec()

         ::oDbfFacCliT:OrdSetFocus( 0 )
         ::oDbfFacCliT:GoTop()
         while !::oDbfFacCliT:Eof()
            if ::oDbfFacCliT:cCodPago == ::cPagoOld
               ::oDbfFacCliT:Load()
               ::oDbfFacCliT:cCodPago := ::cPagoNew
               ::oDbfFacCliT:Save()
               ::nRecChanged++
            end if
            ::oDbfFacCliT:Skip()
            ::oMtrInf:AutoInc( ::oDbfFacCliT:Recno() )
         end while

         //pedido proveedor
         ::oMtrInf:nTotal           := ::oDbfPedPrvT:Lastrec()

         ::oDbfPedPrvT:OrdSetFocus( 0 )
         ::oDbfPedPrvT:GoTop()
         while !::oDbfPedPrvT:Eof()
            if ::oDbfPedPrvT:cCodPgo == ::cPagoOld
               ::oDbfPedPrvT:Load()
               ::oDbfPedPrvT:cCodPgo := ::cPagoNew
               ::oDbfPedPrvT:Save()
               ::nRecChanged++
            end if
            ::oDbfPedPrvT:Skip()
            ::oMtrInf:AutoInc( ::oDbfPedPrvT:Recno() )
         end while

         //albaran proveedor
         ::oMtrInf:nTotal           := ::oDbfAlbPrvT:Lastrec()

         ::oDbfAlbPrvT:OrdSetFocus( 0 )
         ::oDbfAlbPrvT:GoTop()
         while !::oDbfAlbPrvT:Eof()
            if ::oDbfAlbPrvT:cCodPgo == ::cPagoOld
               ::oDbfAlbPrvT:Load()
               ::oDbfAlbPrvT:cCodPgo := ::cPagoNew
               ::oDbfAlbPrvT:Save()
               ::nRecChanged++
            end if
            ::oDbfAlbPrvT:Skip()
            ::oMtrInf:AutoInc( ::oDbfAlbPrvT:Recno() )
         end while

         //factura proveedor
         ::oMtrInf:nTotal           := ::oDbfFacPrvT:Lastrec()

         ::oDbfFacPrvT:OrdSetFocus( 0 )
         ::oDbfFacPrvT:GoTop()
         while !::oDbfFacPrvT:Eof()
            if ::oDbfFacPrvT:cCodPago == ::cPagoOld
               ::oDbfFacPrvT:Load()
               ::oDbfFacPrvT:cCodPago := ::cPagoNew
               ::oDbfFacPrvT:Save()
               ::nRecChanged++
            end if
            ::oDbfFacPrvT:Skip()
            ::oMtrInf:AutoInc( ::oDbfFacPrvT:Recno() )
         end while

         //tpv-rec

         ::oMtrInf:nTotal           := ::oDbfTpvCliT:Lastrec()
         ::oMtrInf:AutoInc( 0 )

         ::oDbfTpvCliT:OrdSetFocus( 0 )
         ::oDbfTpvCliT:GoTop()
         while !::oDbfTpvCliT:Eof()
            if ::oDbfTpvCliT:cFpgTik == ::cPagoOld
               ::oDbfTpvCliT:Load()
               ::oDbfTpvCliT:cFpgTik := ::cPagoNew
               ::oDbfTpvCliT:Save()
               ::nRecChanged++
            end if
            ::oDbfTpvCliT:Skip()
            ::oMtrInf:AutoInc( ::oDbfTpvCliT:Recno() )
         end while

         //si esta en la configuracion por defecto de la empresa

         ::oDbfEmpresa:Seek( cCodEmp() )
         if ::oDbfEmpresa:cDefFPg == ::cPagoOld

            ::oDbfEmpresa:Load()
            ::oDbfEmpresa:cDefFPg := ::cPagoNew
            ::oDbfEmpresa:Save()

         end if

         if !::oDbfPago:Seek( ::cPagoNew )
            if ::oDbfPago:Seek( ::cPagoOld )
               ::oDbfPago:Load()
               ::oDbfPago:cCodPago := ::cPagoNew
               ::oDbfPago:Save()
            end if
         else
            if ::oDbfPago:Seek( ::cPagoOld )
               ::oDbfPago:Delete(.f.)
            end if
         end if

         MsgInfo( "Total de registros cambiados : " + Str( ::nRecChanged ) )

         ::oPagoOld:cText( Space( 18 ) )
         ::oPagoNew:cText( Space( 18 ) )
         ::oSayPagoNew:cText( "" )
         ::oSayPagoOld:cText( "" )

         ::oPagoOld:SetFocus()

         end if

   end case

   ::oDlg:Enable()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD End() CLASS TChgCode

   ::oDlg:End()

   ::CloseFiles()

   Self           := nil

RETURN .t.

//----------------------------------------------------------------------------//

METHOD loaArtOld()

   if ::oDbfArt:Seek( ::cGetArtOld )

      ::oSayArtOld:cText( ::oDbfArt:Nombre )

      if ::oDbfFam:Seek( ::oDbfArt:Familia )
         ::cCodPr1Old      := ::oDbfFam:cCodPrp1
         ::cCodPr2Old      := ::oDbfFam:cCodPrp2
      else
         ::cCodPr1Old      := ""
         ::cCodPr2Old      := ""
      end if

      if !empty( ::cCodPr1Old )
         ::oGetPr1Old:show()
         ::oSayPr1Old:show()
         ::oTxtPr1Old:show()
         ::oTxtPr1Old:SetText( retProp( ::cCodPr1Old ) )
      else
         ::oTxtPr1Old:hide()
         ::oGetPr1Old:hide()
         ::oSayPr1Old:hide()
      end if

      if !empty( ::cCodPr2Old )
         ::oGetPr2Old:show()
         ::oSayPr2Old:show()
         ::oTxtPr2Old:show()
         ::oTxtPr2Old:SetText( retProp( ::cCodPr2Old ) )
      else
         ::oTxtPr2Old:hide()
         ::oGetPr2Old:hide()
         ::oSayPr2Old:hide()
      end if

   end if

return .t.

//----------------------------------------------------------------------------//

METHOD loaArtNew()

return .t.

//---------------------------------------------------------------------------//

METHOD changeSecondPropertie( oDbf )

   if alltrim( oDbf:cValPr2 ) == alltrim( ::cGetPr2Old )
      oDbf:load()
      oDbf:cValPr2 := ::cGetPr2New
      oDbf:save()
      ::nRecChanged++
   end if 

return .t.

//---------------------------------------------------------------------------//
