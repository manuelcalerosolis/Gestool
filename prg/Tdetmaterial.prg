#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Menu.ch"
#include "Report.ch"
#include "MesDbf.ch"
#include "Xbrowse.ch"

//--------------------------------------------------------------------------//

CLASS TDetMaterial FROM TDetalleArticulos

   DATA  oDlg
   DATA  oFld

   DATA  oGetCaja
   DATA  oGetUnidades
   DATA  oGetBultos
   DATA  oGetFormato
   DATA  oGetPrecio
   DATA  oLote
   DATA  oFecCad
   DATA  oSayPr1
   DATA  oSayPr2
   DATA  oValPr1
   DATA  oValPr2
   DATA  oSayVp1
   DATA  oSayVp2
   DATA  cOldCodArt           INIT  ""
   DATA  dOldFecCad           
   DATA  oStkAct
   DATA  nStkAct              INIT  0
   DATA  oMenu

   DATA  oGetTotalUnidades
   DATA  nGetTotalUnidades    INIT  0
   DATA  oGetTotalPrecio
   DATA  nGetTotalPrecio      INIT  0

   DATA  oGetPes
   DATA  oGetUndPes
   DATA  oGetTotPes
   DATA  nGetTotPes           INIT  0
   DATA  oGetVol
   DATA  oGetUndVol
   DATA  oGetTotVol
   DATA  nGetTotVol           INIT  0

   METHOD New( cPath, oParent )

   METHOD DefineFiles()

   METHOD OpenFiles( lExclusive )

   METHOD Resource( nMode, lLiteral )
   METHOD SetResource( nMode )
   METHOD SaveResource( oGetArt, oDlg )

   METHOD LoaArticulo( oGetArticulo, oGetNombre )

   METHOD SaveDetails()
   METHOD DeleteDetails()

   METHOD nUnidades( oDbf )
   METHOD cUnidades( oDbf )      INLINE ( Trans( ::nUnidades( oDbf ), ::oParent:cPicUnd ) )
   METHOD lUnidades( oDbf )      INLINE ( ( ::oGetTotalUnidades:cText( ::nUnidades( oDbf ) ), .t. ) )

   METHOD nPrecio( oDbf )        INLINE ( Round( ::nUnidades( oDbf ) * oDbf:FieldGetByName( "nImpOrd" ), ::oParent:nDorDiv ) )
   METHOD cPrecio( oDbf )        INLINE ( Trans( ::nPrecio( oDbf ), ::oParent:cPorDiv ) )
   METHOD lPrecio( oDbf )        INLINE ( ::oGetTotalPrecio:cText( ::nPrecio( oDbf ) ), .t. )

   METHOD nTotal( oDbf )
   METHOD cTotal( oDbf )         INLINE ( Trans( ::nTotal( oDbf ), ::oParent:cPorDiv ) )
   METHOD lTotal( oDbf, oGet )   INLINE ( oGet:cText( ::nTotal( oDbf ) ), .t. )

   METHOD nTotPeso( oDbf )
   METHOD nTotVolumen( oDbf )
   METHOD lTotPeso( oDbf )
   METHOD lTotVolumen( oDbf )
   METHOD lStkAct()

   METHOD EdtRotor( oDlg )

//   METHOD SyncAllDbf()

END CLASS

//--------------------------------------------------------------------------//

METHOD New( cPath, oParent ) 

   DEFAULT cPath        := cPatEmp()

   ::cPath              := cPath
   ::oParent            := oParent

   ::bOnPreSaveDetail   := {|| ::SaveDetails() }
   ::bOnPreDelete       := {|| ::DeleteDetails() }

   ::setPathBeforeAppend( "Produccion\MateriaPrima\beforeAppend" )
   ::setPathAfterAppend( "Produccion\MateriaPrima\AfterAppend" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cVia, lUniqueName, cFileName )

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT lUniqueName  := .f.
   DEFAULT cFileName    := "ProMat"
   DEFAULT cVia         := cDriver()

   if lUniqueName
      cFileName         := cGetNewFileName( cFileName, , , cPath )
   end if

   DEFINE TABLE oDbf FILE ( cFileName ) CLASS ( cFileName ) ALIAS ( cFileName ) PATH ( cPath ) VIA ( cVia ) COMMENT "Materias primas"

      FIELD NAME "cSerOrd"    TYPE "C" LEN 01  DEC 0 COMMENT "Serie"                         HIDE        OF oDbf
      FIELD NAME "nNumOrd"    TYPE "N" LEN 09  DEC 0 COMMENT "Número"                        HIDE        OF oDbf
      FIELD NAME "cSufOrd"    TYPE "C" LEN 02  DEC 0 COMMENT "Sufijo"                        HIDE        OF oDbf
      FIELD NAME "nNumLin"    TYPE "N" LEN 04  DEC 0 COMMENT "Número de línea"               COLSIZE  20 OF oDbf
      FIELD NAME "cCodArt"    TYPE "C" LEN 18  DEC 0 COMMENT "Código artículo"               COLSIZE  60 OF oDbf
      FIELD NAME "cNomArt"    TYPE "C" LEN 100 DEC 0 COMMENT "Nombre artículo"               COLSIZE 240 OF oDbf
      FIELD NAME "cAlmOrd"    TYPE "C" LEN 16  DEC 0 COMMENT "Almacén"                       COLSIZE  50 OF oDbf
      FIELD NAME "nCajOrd"    TYPE "N" LEN 16  DEC 6 COMMENT "Cajas"                         HIDE        OF oDbf
      FIELD NAME "nUndOrd"    TYPE "N" LEN 16  DEC 6 COMMENT "Unidades"                      HIDE        OF oDbf
      FIELD NAME "nImpOrd"    TYPE "N" LEN 16  DEC 6 COMMENT "Precio"                        COLSIZE  80 OF oDbf
      FIELD NAME "nPeso"      TYPE "N" LEN 16  DEC 6 COMMENT "Peso del artículo"             COLSIZE  80 OF oDbf
      FIELD NAME "cUndPes"    TYPE "C" LEN  2  DEC 0 COMMENT "Unidad del peso"               COLSIZE  80 OF oDbf
      FIELD NAME "nVolumen"   TYPE "N" LEN 16  DEC 6 COMMENT "Volumen del artículo"          COLSIZE  80 OF oDbf
      FIELD NAME "cUndVol"    TYPE "C" LEN  2  DEC 0 COMMENT "Unidad del volumen"            COLSIZE  80 OF oDbf
      FIELD NAME "cCodPr1"    TYPE "C" LEN 20  DEC 0 COMMENT "Código de primera propiedad"   COLSIZE  80 OF oDbf
      FIELD NAME "cCodPr2"    TYPE "C" LEN 20  DEC 0 COMMENT "Código de segunda propiedad"   COLSIZE  80 OF oDbf
      FIELD NAME "cValPr1"    TYPE "C" LEN 20  DEC 0 COMMENT "Valor de primera propiedad"    COLSIZE  80 OF oDbf
      FIELD NAME "cValPr2"    TYPE "C" LEN 20  DEC 0 COMMENT "Valor de segunda propiedad"    COLSIZE  80 OF oDbf
      FIELD NAME "lLote"      TYPE "L" LEN  1  DEC 0 COMMENT "Lógico lote"                   COLSIZE  80 OF oDbf
      FIELD NAME "cLote"      TYPE "C" LEN 14  DEC 0 COMMENT "Lote"                          COLSIZE  80 OF oDbf
      FIELD NAME "cCodPro"    TYPE "C" LEN 18  DEC 0 COMMENT "Código del artídulo producido" COLSIZE  80 OF oDbf
      FIELD NAME "dFecOrd"    TYPE "D" LEN 08  DEC 0 COMMENT "Fecha"                         HIDE        OF oDbf
      FIELD NAME "nTipArt"    TYPE "N" LEN  1  DEC 0 COMMENT "Clasificación"                 HIDE        OF oDbf 
      FIELD NAME "dFecCad"    TYPE "D" LEN 08  DEC 0 COMMENT "Fecha caducidad"               COLSIZE 80  OF oDbf
      FIELD NAME "cHorIni"    TYPE "C" LEN  6  DEC 0 COMMENT "Hora"                          HIDE        OF oDbf             
      FIELD NAME "nBultos"    TYPE "N" LEN 16  DEC 6 COMMENT "Numero de bultos en líneas"    HIDE        OF oDbf           
      FIELD NAME "cFormato"   TYPE "C" LEN 100 DEC 0 COMMENT "Formato"                       HIDE        OF oDbf 

      ::CommunFields( oDbf )

      INDEX TO ( cFileName )  TAG "cNumOrd"  ON "cSerOrd + Str( nNumOrd, 9 ) + cSufOrd"                     NODELETED OF oDbf
      INDEX TO ( cFileName )  TAG "cCodPro"  ON "cCodPro"                                                   NODELETED OF oDbf
      INDEX TO ( cFileName )  TAG "cCodArt"  ON "cCodArt"                                                   NODELETED OF oDbf
      INDEX TO ( cFileName )  TAG "cArtLot"  ON "cCodArt + cValPr1 + cValPr2 + cLote"                       NODELETED OF oDbf
      INDEX TO ( cFileName )  TAG "nNumLin"  ON "Str( nNumLin, 4 )"                                         NODELETED OF oDbf
      INDEX TO ( cFileName )  TAG "cLote"    ON "cLote"                                                     NODELETED OF oDbf
      INDEX TO ( cFileName )  TAG "cGrpFam"  ON "cSerOrd + Str( nNumOrd, 9 ) + cSufOrd + cGrpFam"           NODELETED OF oDbf       
      INDEX TO ( cFileName )  TAG "cCodFam"  ON "cSerOrd + Str( nNumOrd, 9 ) + cSufOrd + cCodFam"           NODELETED OF oDbf       
      INDEX TO ( cFileName )  TAG "cCodTip"  ON "cSerOrd + Str( nNumOrd, 9 ) + cSufOrd + cCodTip"           NODELETED OF oDbf        
      INDEX TO ( cFileName )  TAG "cCodCat"  ON "cSerOrd + Str( nNumOrd, 9 ) + cSufOrd + cCodCat"           NODELETED OF oDbf       
      INDEX TO ( cFileName )  TAG "cCodTmp"  ON "cSerOrd + Str( nNumOrd, 9 ) + cSufOrd + cCodTmp"           NODELETED OF oDbf       
      INDEX TO ( cFileName )  TAG "cCodFab"  ON "cSerOrd + Str( nNumOrd, 9 ) + cSufOrd + cCodFab"           NODELETED OF oDbf       
      INDEX TO ( cFileName )  TAG "nTipArt"  ON "cSerOrd + Str( nNumOrd, 9 ) + cSufOrd + Str( nTipArt, 1 )" NODELETED OF oDbf
      INDEX TO ( cFileName )  TAG "iNumOrd"  ON "'30' + cSerOrd + Str( nNumOrd, 9 ) + cSufOrd"              NODELETED OF oDbf
      INDEX TO ( cFileName )  TAG "cStkFast" ON "cCodArt + cAlmOrd + dtos( dFecOrd ) + cHorIni + cValPr1 + cValPr2 + cLote";
                                                                                                            NODELETED DESCENDING OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//--------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath )

   local lOpen             := .t.
   local oError
   local oBlock

   DEFAULT  lExclusive     := .f.

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf            := ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !lExclusive )

   RECOVER USING oError

      lOpen                := .f.

      ::CloseFiles()

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//--------------------------------------------------------------------------//

METHOD Resource( nMode )

   local oGetArt
   local oGetNom
   local oGetAlm
   local oSayAlm
   local cSayAlm
   local cSayPr1
   local cSayPr2
   local cSayVp1
   local cSayVp2
   local oBtnSer
   local oBtnAdelante
   local oBtnAtras

   ::cOldCodArt         := ::oDbfVir:cCodArt

   if nMode == APPD_MODE
      ::oDbfVir:cAlmOrd := ::oParent:oDbf:cAlmOrg
      ::oDbfVir:nCajOrd := 1
      ::oDbfVir:nUndOrd := 1
      ::oDbfVir:nNumLin := nLastNum( ::oDbfVir )
   else
      cSayVp1           :=  oRetFld( ::oDbfVir:cCodPr1 + ::oDbfVir:cValPr1, ::oParent:oTblPro, "cDesTbl" )
      cSayVp2           :=  oRetFld( ::oDbfVir:cCodPr2 + ::oDbfVir:cValPr2, ::oParent:oTblPro, "cDesTbl" )
   end if

   if !uFieldEmpresa( "lNStkAct" )
      ::nStkAct         := ::oParent:oStock:nStockAlmacen( ::oDbfVir:cCodArt, ::oDbfVir:cAlmOrd )
   else
      ::nStkAct         := 0
   end if

   ::nGetTotalUnidades  := ::nUnidades( ::oDbfVir )
   ::nGetTotalPrecio    := ::nPrecio( ::oDbfVir )
   ::nGetTotPes         := ::nTotPeso( ::oDbfVir )
   ::nGetTotVol         := ::nTotVolumen( ::oDbfVir )

   cSayAlm              := RetAlmacen( ::oDbfVir:cAlmOrd, ::oParent:oAlm )

   DEFINE DIALOG     ::oDlg ;
      RESOURCE       "LProducido" ;
      TITLE          LblTitle( nMode ) + "materia prima"
      
      REDEFINE FOLDER ::oFld ;
         ID          400 ;
         OF          ::oDlg ;
         PROMPT      "&Artículo",;
                     "Da&tos" ;
         DIALOGS     "LProducido_1",;
                     "LProducido_2"

      /*
      Codigo de articulo-------------------------------------------------------
      */

      REDEFINE GET   oGetArt ;
         VAR         ::oDbfVir:cCodArt;
         ID          110 ;
         WHEN        ( nMode != ZOOM_MODE );
         BITMAP      "LUPA" ;
         OF          ::oFld:aDialogs[1]

      oGetArt:bValid := {|| ::LoaArticulo( oGetArt, oGetNom ) }
      oGetArt:bHelp  := {|| BrwArticulo( oGetArt, oGetNom, .f., .t., , ::oLote, ::oDbfVir:cCodPr1, ::oDbfVir:cCodPr2, ::oValPr1, ::oValPr2, ::oFecCad  ) }
                                       
      REDEFINE GET   oGetNom ;
         VAR         ::oDbfVir:cNomArt ;
         ID          111 ;
         WHEN        ( lModDes() .and. nMode != ZOOM_MODE ) ;
         OF          ::oFld:aDialogs[1]

      /*
      Lotes-------------------------------------------------------------------
      */

      REDEFINE GET   ::oLote ;
         VAR         ::oDbfVir:cLote ;
         ID          210 ;
         IDSAY       211 ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         OF          ::oFld:aDialogs[1]

      ::oLote:bValid := {|| ::LoaArticulo( oGetArt, oGetNom ) }


      REDEFINE GET   ::oFecCad ; 
         VAR         ::oDbfVir:dFecCad;
         ID          320 ;
         IDSAY       321 ;
         SPINNER ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         OF          ::oFld:aDialogs[1]


       /*
      Propiedades--------------------------------------------------------------
      */

      REDEFINE SAY ::oSayPr1 VAR cSayPr1;
         ID       221 ;
         OF       ::oFld:aDialogs[1]

      REDEFINE GET ::oValPr1 VAR ::oDbfVir:cValPr1;
         ID       220 ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       ::oFld:aDialogs[1]

         ::oValPr1:bValid := {|| lPrpAct( ::oDbfVir:cValPr1, ::oSayVp1, ::oDbfVir:cCodPr1, ::oParent:oTblPro:cAlias ) }
         ::oValPr1:bHelp  := {|| brwPropiedadActual( ::oValPr1, ::oSayVp1, ::oDbfVir:cCodPr1 ) }

      REDEFINE GET ::oSayVp1 VAR cSayVp1;
         ID       222 ;
         WHEN     .f. ;
         COLOR    CLR_GET ;
         OF       ::oFld:aDialogs[1]

      REDEFINE SAY ::oSayPr2 VAR cSayPr2;
         ID       231 ;
         OF       ::oFld:aDialogs[1]

      REDEFINE GET ::oValPr2 VAR ::oDbfVir:cValPr2;
         ID       230 ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       ::oFld:aDialogs[1]

         ::oValPr2:bValid := {|| lPrpAct( ::oDbfVir:cValPr2, ::oSayVp2, ::oDbfVir:cCodPr2, ::oParent:oTblPro:cAlias ) }
         ::oValPr2:bHelp  := {|| brwPropiedadActual( ::oValPr2, ::oSayVp2, ::oDbfVir:cCodPr2 ) }

      REDEFINE GET ::oSayVp2 VAR cSayVp2;
         ID       232 ;
         WHEN     .f. ;
         OF       ::oFld:aDialogs[1]

      /*
      Bultos, cajas y unidades---------------------------------------------------------
      */

      REDEFINE GET ::oGetBultos VAR ::oDbfVir:nBultos ;
         ID       330 ;
         IDSAY    331 ;
         SPINNER ;
         WHEN     ( uFieldEmpresa( "lUseBultos" ) .AND. nMode != ZOOM_MODE ) ;
         PICTURE  ::oParent:cPicUnd ;
         OF       ::oFld:aDialogs[1]

      REDEFINE GET ::oGetCaja VAR ::oDbfVir:nCajOrd ;
         ID       120;
         IDSAY    121 ;
			SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  ::oParent:cPicUnd ;
         OF       ::oFld:aDialogs[1]

      ::oGetCaja:bChange   := {|| ::lUnidades( ::oDbfVir ), ::lPrecio( ::oDbfVir ), ::lTotPeso( ::oDbfVir ), ::lTotVolumen( ::oDbfVir ) }
      ::oGetCaja:bValid    := {|| ::lUnidades( ::oDbfVir ), ::lPrecio( ::oDbfVir ), ::lTotPeso( ::oDbfVir ), ::lTotVolumen( ::oDbfVir ) }

      REDEFINE GET ::oGetUnidades VAR ::oDbfVir:nUndOrd ;
         ID       130;
			SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  ::oParent:cPicUnd ;
         OF       ::oFld:aDialogs[1]      

      ::oGetUnidades:bChange  := {|| ::lUnidades( ::oDbfVir ), ::lPrecio( ::oDbfVir ), ::lTotPeso( ::oDbfVir ), ::lTotVolumen( ::oDbfVir ) }
      ::oGetUnidades:bValid   := {|| ::lUnidades( ::oDbfVir ), ::lPrecio( ::oDbfVir ), ::lTotPeso( ::oDbfVir ), ::lTotVolumen( ::oDbfVir ) }

      REDEFINE GET ::oGetTotalUnidades VAR ::nGetTotalUnidades ;
         ID       140;
         WHEN     ( .f. ) ;
         PICTURE  ::oParent:cPicUnd ;
         OF       ::oFld:aDialogs[1]

      REDEFINE GET ::oGetPrecio VAR ::oDbfVir:nImpOrd ;
         ID       150;
			SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  ::oParent:cPouDiv ;
         OF       ::oFld:aDialogs[1]

      ::oGetPrecio:bChange := {|| ::lPrecio( ::oDbfVir ) }
      ::oGetPrecio:bChange := {|| ::lPrecio( ::oDbfVir ) }

      REDEFINE GET ::oGetTotalPrecio VAR ::nGetTotalPrecio ;
         ID       160;
         WHEN     ( .f. ) ;
         PICTURE  ::oParent:cPorDiv ;
         OF       ::oFld:aDialogs[1]

      /*
      Pesos--------------------------------------------------------------------
      */

      REDEFINE GET ::oGetPes VAR ::oDbfVir:nPeso ;
         ID       170;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  MasUnd() ;
         OF       ::oFld:aDialogs[1]

      ::oGetPes:bChange   := {|| ::lTotPeso( ::oDbfVir ) }
      ::oGetPes:bValid    := {|| ::lTotPeso( ::oDbfVir ) }

      REDEFINE GET ::oGetUndPes VAR ::oDbfVir:cUndPes ;
         ID       171;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       ::oFld:aDialogs[1]

      REDEFINE GET ::oGetTotPes VAR ::nGetTotPes ;
         ID       172;
         WHEN     ( .f. ) ;
         PICTURE  MasUnd() ;
         OF       ::oFld:aDialogs[1]

      /*
      Volumen------------------------------------------------------------------
      */

      REDEFINE GET ::oGetVol VAR ::oDbfVir:nVolumen ;
         ID       180;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  MasUnd() ;
         OF       ::oFld:aDialogs[1]

      ::oGetVol:bChange   := {|| ::lTotVolumen( ::oDbfVir ) }
      ::oGetVol:bValid    := {|| ::lTotVolumen( ::oDbfVir ) }

      REDEFINE GET ::oGetUndVol VAR ::oDbfVir:cUndVol ;
         ID       181;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       ::oFld:aDialogs[1]

      REDEFINE GET ::oGetTotVol VAR ::nGetTotVol ;
         ID       182;
         WHEN     ( .f. ) ;
         PICTURE  MasUnd() ;
         OF       ::oFld:aDialogs[1]

      /*
      Código de almacen--------------------------------------------------------
      */

      REDEFINE GET oGetAlm VAR ::oDbfVir:cAlmOrd;
         ID       190 ;
         WHEN     ( nMode != ZOOM_MODE );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( oGetAlm, oSayAlm ) ) ;
         OF       ::oFld:aDialogs[1]

      oGetAlm:bChange   := {|| ::lStkAct() }
      oGetAlm:bValid    := {|| cAlmacen( oGetAlm, ::oParent:oAlm, oSayAlm ), ::lStkAct() }

      REDEFINE GET oSayAlm VAR cSayAlm ;
         ID       191 ;
         WHEN     ( .f. ) ;
         OF       ::oFld:aDialogs[1]

      REDEFINE GET ::oGetFormato VAR ::oDbfVir:cFormato;
         ID       340;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       ::oFld:aDialogs[1]

      /*
      Stock Actual-------------------------------------------------------------
      */

      REDEFINE GET ::oStkAct VAR ::nStkAct ;
         ID       200 ;
         WHEN     .f. ;
         PICTURE  MasUnd() ;
         OF       ::oFld:aDialogs[1]

      /*
      Pestaña de datos---------------------------------------------------------
      */

      ::LoadPropiedadesArticulos( ::oFld:aDialogs[ 2 ], nMode )

      /*
      Botones globales a toda la caja de dailogo-------------------------------
      */

      REDEFINE BUTTON oBtnSer ;
         ID       3 ;
         OF       ::oDlg ;
         ACTION   ( nil )

      oBtnSer:bAction   := {|| ::oParent:oDetSeriesMaterial:Resource( nMode ) }

      REDEFINE BUTTON oBtnAtras ;
         ID       4 ;
         OF       ::oDlg ;
         ACTION   ( if( ::oFld:nOption > 1, ::oFld:SetOption( ::oFld:nOption - 1 ), ) )

      REDEFINE BUTTON oBtnAdelante ;
         ID       5 ;
         OF       ::oDlg ;
         ACTION   ( if( ::oFld:nOption < Len( ::oFld:aDialogs ), ::oFld:SetOption( ::oFld:nOption + 1 ), ) )

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		::oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::SaveResource( oGetArt ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       ::oDlg ;
			ACTION 	( ::oDlg:end() )

      if nMode != ZOOM_MODE
         ::oDlg:AddFastKey( VK_F6, {|| oBtnSer:Click() } )
         ::oDlg:AddFastKey( VK_F5, {|| ::SaveResource( oGetArt ) } )
         ::oDlg:AddFastKey( VK_F7, {|| oBtnAtras:Click() } )
         ::oDlg:AddFastKey( VK_F8, {|| oBtnAdelante:Click() } )
      end if

      ::oDlg:bStart := {|| ::EdtRotor(), ::SetResource( nMode ) }

   ACTIVATE DIALOG ::oDlg CENTER

   ::oMenu:End()

RETURN ( ::oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

METHOD SetResource( nMode )

   if !lUseCaj()
      ::oGetCaja:Hide()
   end if

   if !uFieldEmpresa( "lUseBultos" )
      if !Empty( ::oGetBultos )
         ::oGetBultos:Hide()
      end if   
   else
      if !Empty( ::oGetBultos )
         ::oGetBultos:SetText( uFieldempresa( "cNbrBultos" ) )
      end if 
   end if

   if nMode == APPD_MODE

      ::oLote:Hide()
      ::oFecCad:Hide()

      ::oSayPr1:Hide()
      ::oValPr1:Hide()
      ::oSayVp1:Hide()

      ::oSayPr2:Hide()
      ::oValPr2:Hide()
      ::oSayVp2:Hide()

   else

      if ::oDbfVir:lLote
         ::oLote:Show()
         ::oFecCad:Show()
      else
         ::oLote:Hide()
         ::oFecCad:Hide()
      end if

      if !Empty( ::oDbfVir:cCodPr1 )
         ::oSayPr1:Show()
         ::oSayPr1:SetText( retProp( ::oDbfVir:cCodPr1, ::oParent:oPro:cAlias ) )
         ::oValPr1:Show()
         ::oSayVp1:Show()
      else
         ::oSayPr1:Hide()
         ::oValPr1:Hide()
         ::oSayVp1:Hide()
      end if

      if !Empty( ::oDbfVir:cCodPr2 )
         ::oSayPr2:Show()
         ::oSayPr2:SetText( retProp( ::oDbfVir:cCodPr2, ::oParent:oPro:cAlias ) )
         ::oValPr2:Show()
         ::oSayVp2:Show()
      else
         ::oSayPr2:Hide()
         ::oValPr2:Hide()
         ::oSayVp2:Hide()
      end if

   end if

   ::oClasificacionArticulo:SetNumber( ::oDbfVir:nTipArt )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD LoaArticulo( oGetArticulo, oGetNombre )

   local cCodArt           := oGetArticulo:VarGet()
   local lChgCodArt        := .f.
   local cLote
   local dFechaCaducidad   

   if Empty( cCodArt )

      if lRetCodArt()
         MsgStop( "No se pueden añadir lineas sin codificar" )
         return .f.
      end if

      return .t.

   else

      lChgCodArt     := Empty( ::cOldCodArt ) .or. ( ::oDbfVir:cCodArt + ::oDbfVir:cValPr1 + ::oDbfVir:cValPr2 + ::oDbfVir:cLote != ::cOldCodArt )

      /*
      Primero buscamos por codigos de barra
      */

      ::oParent:oArt:ordSetFocus( "CodeBar" )

      if ::oParent:oArt:Seek( cCodArt )
         cCodArt  := ::oParent:oArt:Codigo
      end if

      /*
      Ahora buscamos por el codigo interno-------------------------------------
      */

      ::oParent:oArt:ordSetFocus( "Codigo" )

      if ::oParent:oArt:Seek( cCodArt ) .or. ::oParent:oArt:Seek( Upper( cCodArt ) )

         cCodArt  := ::oParent:oArt:Codigo

         //Si cambia el código del artículo------------------------------------

         if lChgCodArt 

            oGetNombre:cText( ::oParent:oArt:Nombre )

            if ::oParent:oArt:nCajEnt != 0
               ::oGetCaja:cText( ::oParent:oArt:nCajEnt )
            end if

            if ::oParent:oArt:nUniCaja != 0
               ::oGetUnidades:cText( ::oParent:oArt:nUniCaja )
            end if

            if ::oParent:oArt:lLote
               
               ::oDbfVir:lLote   := ::oParent:oArt:lLote

               if Empty( cLote )
                  cLote          := ::oParent:oArt:cLote
               end if 

               if !Empty( ::oLote )

                  ::oLote:Show()

                  if Empty( ::oLote:VarGet() )
                     ::oLote:cText( cLote )
                  end if 

               else 

                  if Empty( ::oDbfVir:cLote)
                     ::oDbfVir:cLote := cLote
                  end if

               end if 
         
               if Empty( dFechaCaducidad )
                  dFechaCaducidad      := dFechaCaducidadLote( cCodArt, ::oDbfVir:cValPr1, ::oDbfVir:cValPr2, ::oDbfVir:cLote, ::oParent:oAlbPrvL:cAlias, ::oParent:oFacPrvL:cAlias, ::oParent:oDetProduccion:oDbf:calias )
               end if 

               
               if !Empty( ::oFecCad )

                  ::oFecCad:Show()

                  if Empty( ::oFecCad:VarGet() ) .or. (dFechaCaducidad != ::oDbfVir:dFecCad )
                     ::oFecCad:cText( dFechaCaducidad )
                  end if

               else 

                  if Empty( ::oDbfVir:dFecCad )
                     ( ::oDbfVir:dFecCad ) := dFechaCaducidad
                  end if 

               end if

            else

               ::oLote:Hide()
               ::oFecCad:Hide()
               
            end if

            if !uFieldEmpresa( "lCosAct" )
               ::oGetPrecio:cText( ::oParent:oStock:nCostoMedio( cCodArt, ::oParent:oDbf:cAlmOrd, ::oDbfVir:cCodPr1, ::oDbfVir:cCodPr2, ::oDbfVir:cValPr1, ::oDbfVir:cValPr2, ::oDbfVir:cLote ) )         
            else
               ::oGetPrecio:cText( ::oParent:oArt:pCosto ) 
            end if

            ::oGetPes:cText(     ::oParent:oArt:nPesoKg )
            ::oGetUndPes:cText(  ::oParent:oArt:cUndDim )
            ::oGetVol:cText(     ::oParent:oArt:nVolumen )
            ::oGetUndVol:cText(  ::oParent:oArt:cVolumen )

            ::LoadCommunFields()

            // Cotrol de stock-------------------------------------------------

            if !uFieldEmpresa( "lNStkAct" )
               ::oStkAct:cText( ::oParent:oStock:nTotStockAct( cCodArt, ::oDbfVir:cAlmOrd, ::oDbfvir:cValPr1, ::oDbfVir:cValPr2, ::oDbfVir:cLote  ) )
            end if

         end if

         ::lUnidades( ::oDbfVir )
         ::lPrecio( ::oDbfVir )
         ::lTotPeso( ::oDbfVir )
         ::lTotVolumen( ::oDbfVir )

         ::oDbfVir:cCodPr1    := ::oParent:oArt:cCodPrp1
         ::oDbfVir:cCodPr2    := ::oParent:oArt:cCodPrp2

         if !Empty( ::oDbfVir:cCodPr1 )
            ::oSayPr1:Show()
            ::oSayPr1:SetText( retProp( ::oDbfVir:cCodPr1, ::oParent:oPro:cAlias ) )
            ::oValPr1:Show()
            ::oSayVp1:Show()
         else
            ::oSayPr1:Hide()
            ::oValPr1:Hide()
            ::oSayVp1:Hide()
         end if

         if !Empty( ::oDbfVir:cCodPr2 )
            ::oSayPr2:Show()
            ::oSayPr2:SetText( retProp( ::oDbfVir:cCodPr2, ::oParent:oPro:cAlias ) )
            ::oValPr2:Show()
            ::oSayVp2:Show()
         else
            ::oSayPr2:Hide()
            ::oValPr2:Hide()
            ::oSayVp2:Hide()
         end if

         ::cOldCodArt         := ::oDbfVir:cCodArt + ::oDbfVir:cValPr1 + ::oDbfVir:cValPr2 + ::oDbfVir:cLote

         return .t.

      else

         MsgStop( "Artículo no encontrado" )

         return .f.

      end if

   end if

RETURN .t.

//--------------------------------------------------------------------------//

METHOD nUnidades( oDbf )

   DEFAULT oDbf   := ::oDbf

RETURN ( if( !Empty( ::oParent:nDouDiv ), Round( NotCaja( oDbf:FieldGetByName( "nCajOrd" ) ) * oDbf:FieldGetByName( "nUndOrd" ), ::oParent:nDouDiv ), ( NotCaja( oDbf:FieldGetByName( "nCajOrd" ) ) * oDbf:FieldGetByName( "nUndOrd" ) ) ) )

//--------------------------------------------------------------------------//

METHOD nTotal( oDbf )

   local nTotal   := 0

   DEFAULT oDbf   := ::oDbf

   oDbf:GetStatus()

   oDbf:GoTop()
   while !oDbf:Eof()
      nTotal      += ::nPrecio( oDbf )
      oDbf:Skip()
   end while

   oDbf:SetStatus()

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD SaveDetails()

   ::oDbfVir:cSerOrd  := ::oParent:oDbf:cSerOrd
   ::oDbfVir:nNumOrd  := ::oParent:oDbf:nNumOrd
   ::oDbfVir:cSufOrd  := ::oParent:oDbf:cSufOrd
   ::oDbfVir:dFecOrd  := ::oParent:oDbf:dFecOrd

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD DeleteDetails()

   while ::oParent:oDetSeriesMaterial:oDbfVir:SeekInOrd( Str( ::oDbfVir:nNumLin, 4 ) + ::oDbfVir:cCodArt, "nNumLin" )
      ::oParent:oDetSeriesMaterial:oDbfVir:Delete(.f.)
   end while

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD nTotPeso( oDbf )

   DEFAULT oDbf   := ::oDbf

RETURN ( Round( ::nUnidades( oDbf ), ::oParent:nDouDiv ) * oDbf:nPeso )

//---------------------------------------------------------------------------//

METHOD nTotVolumen( oDbf )

   DEFAULT oDbf   := ::oDbf

RETURN ( Round( ::nUnidades( oDbf ), ::oParent:nDouDiv ) * oDbf:nVolumen )

//---------------------------------------------------------------------------//

METHOD lTotPeso( oDbf )

   DEFAULT oDbf   := ::oDbf

RETURN ( ::oGetTotPes:cText( ::nTotPeso( oDbf ) ), .t. )

//---------------------------------------------------------------------------//

METHOD lTotVolumen( oDbf )

   DEFAULT oDbf   := ::oDbf

RETURN ( ::oGetTotVol:cText( ::nTotVolumen( oDbf ) ), .t. )

//---------------------------------------------------------------------------//

METHOD lStkAct()

RETURN ( if( !uFieldEmpresa( "lNStkAct" ), ::oStkAct:cText( ::oParent:oStock:nStockAlmacen( ::oDbfVir:cCodArt, ::oDbfVir:cAlmOrd ) ), ), .t. )

//---------------------------------------------------------------------------//

METHOD EdtRotor()

   MENU ::oMenu

      MENUITEM    "&1. Rotor"

         MENU

            MENUITEM    "&1. Modificar artículo";
               MESSAGE  "Modificar la ficha del artículo" ;
               RESOURCE "gc_object_cube_16";
               ACTION   ( if( Empty( ::oDbfVir:cCodArt ), msgStop( "No hay artículo seleccionado" ), EdtArticulo( ::oDbfVir:cCodArt ) ) );

            MENUITEM    "&2. Informe de artículo";
               MESSAGE  "Abrir el informe del artículo" ;
               RESOURCE "Info16";
               ACTION   ( if( Empty( ::oDbfVir:cCodArt ), msgStop( "No hay artículo seleccionado" ), InfArticulo( ::oDbfVir:cCodArt ) ) );

         ENDMENU

   ENDMENU

   ::oDlg:SetMenu( ::oMenu )

RETURN ( ::oMenu )

//---------------------------------------------------------------------------//

METHOD SaveResource( oGetArt )

   if Empty( ::oDbfVir:cCodArt )
      MsgStop( "Tiene que seleccionar un artículo." )
      oGetArt:SetFocus()
      Return .f.
   end if

   if !::runScriptBeforeAppend( self )
      Return .f.
   end if

   ::oDbfVir:nTipArt    := ::oClasificacionArticulo:GetNumber()

   ::oParent:oTotProducido:Refresh()
   ::oParent:oTotMaterias:Refresh()
   ::oParent:oTotPersonal:Refresh()

RETURN ::oDlg:end( IDOK )

//---------------------------------------------------------------------------//

/*
Metodo creado para marbaroso para rellenar el almacen-------------------------- 
en las líneas de materia prima en partes de producción-------------------------
*/
/*
METHOD SyncAllDbf()

   ::Super():SyncAllDbf()

   ::OpenFiles()

   while !::oDbf:Eof()

      if Empty( ::oDbf:cAlmOrd )

         if ::oDbf:Lock()
            ::oDbf:cAlmOrd := uFieldEmpresa( "CDEFALM" )
            ::oDbf:Unlock()
         end if

      end if 

      ::oDbf:Skip()

   end while

   ::CloseFiles()   

RETURN ( Self )
*/
//---------------------------------------------------------------------------//

Function nTotNMaterial( uDbf )

   local nTotUnd

   do case
      case ValType( uDbf ) == "O"
         nTotUnd  := NotCaja( uDbf:nCajOrd )
         nTotUnd  *= uDbf:nUndOrd

      otherwise
         nTotUnd  := NotCaja( ( uDbf )->nCajOrd )
         nTotUnd  *= ( uDbf )->nUndOrd

   end case

RETURN ( nTotUnd )

//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//
//--------------------------------------------------------------------------//

CLASS TDetSeriesMaterial FROM TDet

   METHOD New( cPath, oParent )

   METHOD DefineFiles()

   METHOD SaveDetails()

   METHOD Resource( nMode, lLiteral )

END CLASS

//--------------------------------------------------------------------------//

METHOD New( cPath, oParent ) CLASS TDetSeriesMaterial

   DEFAULT cPath        := cPatEmp()

   ::cPath              := cPath
   ::oParent            := oParent

   ::bOnPreSaveDetail   := {|| ::SaveDetails() }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cVia, lUniqueName, cFileName ) CLASS TDetSeriesMaterial

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT lUniqueName  := .f.
   DEFAULT cFileName    := "MatSer"
   DEFAULT cVia         := cDriver()

   if lUniqueName
      cFileName         := cGetNewFileName( cFileName, , , cPath )
   end if

   DEFINE TABLE oDbf FILE ( cFileName ) CLASS ( cFileName ) ALIAS ( cFileName ) PATH ( cPath ) VIA ( cVia ) COMMENT "Números de serie de materias primas"

      FIELD NAME "cSerOrd"    TYPE "C" LEN 01  DEC 0 COMMENT "Código"                           HIDE        OF oDbf
      FIELD NAME "nNumOrd"    TYPE "N" LEN 09  DEC 0 COMMENT "Número"                           HIDE        OF oDbf
      FIELD NAME "cSufOrd"    TYPE "C" LEN 02  DEC 0 COMMENT "Sufijo"                           HIDE        OF oDbf
      FIELD NAME "dFecOrd"    TYPE "D" LEN 08  DEC 0 COMMENT "Fecha"                            HIDE        OF oDbf
      FIELD NAME "nNumLin"    TYPE "N" LEN 04  DEC 0 COMMENT "Número de línea"                  COLSIZE  60 OF oDbf
      FIELD NAME "cCodArt"    TYPE "C" LEN 18  DEC 0 COMMENT "Artículo"                         COLSIZE  60 OF oDbf
      FIELD NAME "cAlmOrd"    TYPE "C" LEN 16  DEC 0 COMMENT "Almacén"                          COLSIZE  50 OF oDbf
      FIELD NAME "lUndNeg"    TYPE "L" LEN 01  DEC 0 COMMENT "Lógico de unidades en negativo"   HIDE        OF oDbf
      FIELD NAME "cNumSer"    TYPE "C" LEN 30  DEC 0 COMMENT "Número de serie"                  HIDE        OF oDbf

      INDEX TO ( cFileName ) TAG "cNumOrd" ON "cSerOrd + Str( nNumOrd ) + cSufOrd + Str( nNumLin )"   NODELETED   OF oDbf
      INDEX TO ( cFileName ) TAG "cCodArt" ON "cCodArt + cAlmOrd + cNumSer"                           NODELETED   OF oDbf
      INDEX TO ( cFileName ) TAG "cNumSer" ON "cNumSer"                                               NODELETED   OF oDbf
      INDEX TO ( cFileName ) TAG "nNumLin" ON "Str( nNumLin, 4 ) + cCodArt"                           NODELETED   OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//---------------------------------------------------------------------------//

METHOD SaveDetails() CLASS TDetSeriesMaterial

   ::oDbfVir:cSerOrd  := ::oParent:oDbf:cSerOrd
   ::oDbfVir:nNumOrd  := ::oParent:oDbf:nNumOrd
   ::oDbfVir:cSufOrd  := ::oParent:oDbf:cSufOrd
   ::oDbfVir:dFecOrd  := ::oParent:oDbf:dFecOrd

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS TDetSeriesMaterial

   with object ( TNumerosSerie() )

      :nMode            := nMode

      :cCodArt          := ::oParent:oDetMaterial:oDbfVir:cCodArt
      :nNumLin          := ::oParent:oDetMaterial:oDbfVir:nNumLin
      :cCodAlm          := ::oParent:oDbf:cAlmOrd

      :nTotalUnidades   := ::oParent:oDetMaterial:nUnidades( ::oParent:oDetMaterial:oDbfVir )

      :oStock           := ::oParent:oStock

      ::oDbfVir:GetStatus()
      ::oDbfVir:OrdSetFocus( "nNumLin" )

      :uTmpSer          := ::oDbfVir

      :Resource()

      ::oDbfVir:SetStatus()

   end with

RETURN ( Self )

//---------------------------------------------------------------------------//
