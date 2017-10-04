#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Menu.ch"
#include "Report.ch"
#include "MesDbf.ch"
#include "Xbrowse.ch"

//--------------------------------------------------------------------------//

CLASS TDetProduccion FROM TDetalleArticulos

   DATA  oDlg
   DATA  oFld

   DATA  oMenu

   DATA  oGetCaja
   DATA  oGetUnd
   DATA  oGetBultos
   DATA  oGetFormato
   DATA  oImpOrd

   DATA  oGetTotalUnidades
   DATA  nGetTotalUnidades    INIT  0
   DATA  oGetTotalPrecio
   DATA  nGetTotalPrecio      INIT  0
   DATA  oLote
   DATA  oFecCad 
   DATA  oSayPr1
   DATA  oValPr1
   DATA  oSayVp1
   DATA  oSayPr2
   DATA  oValPr2
   DATA  oSayVp2
   DATA  oGetPes
   DATA  oGetUndPes
   DATA  oGetTotPes
   DATA  nGetTotPes           INIT  0
   DATA  oGetVol
   DATA  oGetUndVol
   DATA  oGetTotVol
   DATA  nGetTotVol           INIT  0
   DATA  cOldCodArt           INIT  ""
   DATA  oStkAct
   DATA  nStkAct              INIT  0

   DATA  oDbfSeries

   DATA  oTagsEver

   METHOD New( cPath, oParent )

   METHOD DefineFiles()

   METHOD OpenFiles( lExclusive )
   METHOD CloseFiles()

   METHOD Resource( nMode, lLiteral )
   METHOD SetResource()
   METHOD SaveResource( oGetArt, nMode )

   METHOD LoaArticulo( oGetArticulo, oGetNombre )

   METHOD SaveDetails()
   METHOD DeleteDetails()

   METHOD nUnidades( oDbf )
   METHOD cUnidades( oDbf )
   METHOD lUnidades( oDbf )

   METHOD nTotalUnidades( oDbf )

   METHOD nPrecio( oDbf )
   METHOD cPrecio( oDbf )
   METHOD lPrecio( oDbf )

   METHOD nTotal( oDbf )
   METHOD cTotal( oDbf )
   METHOD lTotal( oDbf )

   METHOD nTotPeso( oDbf )
   METHOD lTotPeso( oDbf )
   METHOD nTotVolumen( oDbf )
   METHOD lTotVolumen( oDbf )

   METHOD EdtRotor( oDlg )
   METHOD lStkAct()

   METHOD Del( oBrw1, oBrw2 )

   METHOD getEtiquetasBrowse()

   // METHOD migrateToEtiquetas()

END CLASS

//--------------------------------------------------------------------------//

METHOD New( cPath, oParent ) CLASS TDetProduccion

   DEFAULT cPath        := cPatEmp()

   ::cPath              := cPath
   ::oParent            := oParent

   ::bOnPreSaveDetail   := {|| ::SaveDetails() }
   ::bOnPreDelete       := {|| ::DeleteDetails() }

   ::setPathBeforeAppend( "Produccion\Elaborado\beforeAppend" )
   ::setPathAfterAppend( "Produccion\Elaborado\AfterAppend" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cVia, lUniqueName, cFileName ) CLASS TDetProduccion

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT lUniqueName  := .f.
   DEFAULT cFileName    := "ProLin"
   DEFAULT cVia         := cDriver()

   if lUniqueName
      cFileName         := cGetNewFileName( cFileName, , , cPath )
   end if

   DEFINE TABLE oDbf FILE ( cFileName ) CLASS ( cFileName ) ALIAS ( cFileName ) PATH ( cPath ) VIA ( cVia ) COMMENT "Materiales producidos"

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
      FIELD NAME "dFecOrd"    TYPE "D" LEN  8  DEC 0 COMMENT "Fecha"                         HIDE        OF oDbf
      FIELD NAME "nTipArt"    TYPE "N" LEN  1  DEC 0 COMMENT "Clasificación"                 HIDE        OF oDbf
      FIELD NAME "dFecCad"    TYPE "D" LEN  8  DEC 0 COMMENT "Fecha de caducidad"            COLSIZE  80 OF oDbf
      FIELD NAME "cHorIni"    TYPE "C" LEN  6  DEC 0 COMMENT "Hora"                          HIDE        OF oDbf           
      FIELD NAME "nBultos"    TYPE "N" LEN 16  DEC 6 COMMENT "Numero de bultos en líneas"    HIDE        OF oDbf           
      FIELD NAME "cFormato"   TYPE "C" LEN 100 DEC 0 COMMENT "Formato"                       HIDE        OF oDbf  
      FIELD NAME "cEtiqueta"  TYPE "M" LEN  10 DEC 0 COMMENT "Etiquetas"                     HIDE        OF oDbf  

      ::CommunFields( oDbf )

      FIELD CALCULATE NAME "Unidades" LEN 16 DEC 6 COMMENT "Unidades";
         VAL {|| ( NotCaja( oDbf:FieldGetByName( "nCajOrd" ) ) * oDbf:FieldGetByName( "nUndOrd" ) ) }    OF oDbf

      INDEX TO ( cFileName )  TAG "cNumOrd"  ON "cSerOrd + Str( nNumOrd,9 ) + cSufOrd"                               NODELETED OF oDbf
      INDEX TO ( cFileName )  TAG "cCodArt"  ON "cCodArt"                                                            NODELETED OF oDbf
      INDEX TO ( cFileName )  TAG "cArtLot"  ON "cCodArt + cValPr1 + cValPr2 + cLote"                                NODELETED OF oDbf
      INDEX TO ( cFileName )  TAG "cLote"    ON "cLote"                                                              NODELETED OF oDbf
      INDEX TO ( cFileName )  TAG "nNumLin"  ON "Str( nNumLin, 4 )"                                                  NODELETED OF oDbf
      INDEX TO ( cFileName )  TAG "cGrpFam"  ON "cSerOrd + Str( nNumOrd, 9 ) + cSufOrd + cGrpFam"                    NODELETED OF oDbf       
      INDEX TO ( cFileName )  TAG "cCodFam"  ON "cSerOrd + Str( nNumOrd, 9 ) + cSufOrd + cCodFam"                    NODELETED OF oDbf       
      INDEX TO ( cFileName )  TAG "cCodTip"  ON "cSerOrd + Str( nNumOrd, 9 ) + cSufOrd + cCodTip"                    NODELETED OF oDbf        
      INDEX TO ( cFileName )  TAG "cCodCat"  ON "cSerOrd + Str( nNumOrd, 9 ) + cSufOrd + cCodCat"                    NODELETED OF oDbf       
      INDEX TO ( cFileName )  TAG "cCodTmp"  ON "cSerOrd + Str( nNumOrd, 9 ) + cSufOrd + cCodTmp"                    NODELETED OF oDbf       
      INDEX TO ( cFileName )  TAG "cCodFab"  ON "cSerOrd + Str( nNumOrd, 9 ) + cSufOrd + cCodFab"                    NODELETED OF oDbf       
      INDEX TO ( cFileName )  TAG "nTipArt"  ON "cSerOrd + Str( nNumOrd, 9 ) + cSufOrd + Str( nTipArt, 1 )"          NODELETED OF oDbf
      INDEX TO ( cFileName )  TAG "iNumOrd"  ON "'30' + cSerOrd + Str( nNumOrd, 9 ) + space(1) + cSufOrd + Str( nNumLin, 4 )";
                                                                                                                     NODELETED OF oDbf
      INDEX TO ( cFileName )  TAG "cStkFast" ON "cCodArt + cAlmOrd + dtos( dFecOrd ) + cHorIni + cValPr1 + cValPr2 + cLote";
                                                                                                                     NODELETED DESCENDING OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//--------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath ) CLASS TDetProduccion

   local lOpen             := .t.
   local oBlock

   DEFAULT  lExclusive     := .f.

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf            := ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !lExclusive )

   RECOVER

      lOpen                := .f.

      ::CloseFiles()

      msgStop( "Imposible abrir todas las bases de datos" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//--------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TDetProduccion

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   ::oDbf                  := nil

RETURN .t.

//---------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS TDetProduccion

   local oGetArt
   local oGetNom
   local oGetAlm
   local oSayAlm
   local cSayAlm
   local cSayPr1
   local cSayVp1
   local cSayPr2
   local cSayVp2
   local oBtnSer
   local oBtnAdelante
   local oBtnAtras
   local aIdEtiquetas
   local aNombreEtiquetas

   ::cOldCodArt         := ::oDbfVir:cCodArt

   if nMode == APPD_MODE
      ::oDbfVir:cAlmOrd := ::oParent:oDbf:cAlmOrd
      ::oDbfVir:nCajOrd := 1
      ::oDbfVir:nUndOrd := 1
      ::oDbfVir:nNumLin := nLastNum( ::oDbfVir )
   else
      cSayVp1           :=  oRetFld( ::oDbfVir:cCodPr1 + ::oDbfVir:cValPr1, ::oParent:oTblPro, "cDesTbl" )
      cSayVp2           :=  oRetFld( ::oDbfVir:cCodPr2 + ::oDbfVir:cValPr2, ::oParent:oTblPro, "cDesTbl" )
   end if

   /*
   Etiquetas-------------------------------------------------------------------
   */

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

   aIdEtiquetas         := hb_deserialize( ::oDbfVir:cEtiqueta )

   aNombreEtiquetas     := EtiquetasModel():translateIdsToNames( aIdEtiquetas )

   DEFINE DIALOG  ::oDlg ;
      RESOURCE    "LProducido" ;
      TITLE       LblTitle( nMode ) + "articulos producidos"

      REDEFINE FOLDER ::oFld ;
         ID       400 ;
         OF       ::oDlg ;
         PROMPT   "&Artículo",;
                  "Da&tos" ,;
                  "&Etiquetas";
         DIALOGS  "LProducido_1",;
                  "LProducido_2",;
                  "Etiqueta_Linea"

      /*
      Codigo de articulo-------------------------------------------------------
      */

      REDEFINE GET oGetArt VAR ::oDbfVir:cCodArt;
         ID       110 ;
         WHEN     ( nMode == APPD_MODE );
         BITMAP   "LUPA" ;
         OF       ::oFld:aDialogs[1]

      oGetArt:bValid := {|| cArticulo( oGetArt, ::oParent:oArt:cAlias, oGetNom ), ::LoaArticulo( oGetArt, oGetNom ) }
      oGetArt:bHelp  := {|| BrwArticulo( oGetArt, oGetNom, .f., .t., , ::oLote, ::oDbfVir:cCodPr1, ::oDbfVir:cCodPr2, ::oValPr1, ::oValPr2, ::oFecCad  ) }

      REDEFINE GET oGetNom VAR ::oDbfVir:cNomArt ;
         ID       111 ;
         WHEN     ( nMode == APPD_MODE ) ;
         OF       ::oFld:aDialogs[1]

      /*
      Lotes-------------------------------------------------------------------
      */

      REDEFINE GET ::oLote VAR ::oDbfVir:cLote;
         ID       210 ;
         IDSAY    211 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       ::oFld:aDialogs[1]

      REDEFINE GET ::oFecCad VAR ::oDbfVir:dFecCad;
         ID       320 ;
         IDSAY    321 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       ::oFld:aDialogs[1]

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
      Bultos, cajas y unidades-------------------------------------------------
      */

      REDEFINE GET ::oGetBultos VAR ::oDbfVir:nBultos ;
         ID       330 ;
         IDSAY    331 ;
         SPINNER ;
         WHEN     ( uFieldEmpresa( "lUseBultos" ) .AND. nMode != ZOOM_MODE ) ;
         PICTURE  ::oParent:cPicUnd ;
         OF       ::oFld:aDialogs[1]

      REDEFINE GET ::oGetCaja VAR ::oDbfVir:nCajOrd ;
         ID       120 ;
         IDSAY    121 ;
			SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  ::oParent:cPicUnd ;
         OF       ::oFld:aDialogs[1]

      ::oGetCaja:bChange   := {|| ::lUnidades( ::oDbfVir ), ::lPrecio( ::oDbfVir ), ::lTotPeso( ::oDbfVir ), ::lTotVolumen( ::oDbfVir ) }
      ::oGetCaja:bValid    := {|| ::lUnidades( ::oDbfVir ), ::lPrecio( ::oDbfVir ), ::lTotPeso( ::oDbfVir ), ::lTotVolumen( ::oDbfVir ) }

      REDEFINE GET ::oGetUnd VAR ::oDbfVir:nUndOrd ;
         ID       130;
			SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  ::oParent:cPicUnd ;
         OF       ::oFld:aDialogs[1]

      ::oGetUnd:bChange   := {|| ::lUnidades( ::oDbfVir ), ::lPrecio( ::oDbfVir ), ::lTotPeso( ::oDbfVir ), ::lTotVolumen( ::oDbfVir ) }
      ::oGetUnd:bValid    := {|| ::lUnidades( ::oDbfVir ), ::lPrecio( ::oDbfVir ), ::lTotPeso( ::oDbfVir ), ::lTotVolumen( ::oDbfVir ) }

      REDEFINE GET ::oGetTotalUnidades VAR ::nGetTotalUnidades ;
         ID       140;
         WHEN     ( .f. ) ;
         PICTURE  ::oParent:cPicUnd ;
         OF       ::oFld:aDialogs[1]

      /*
      Importe y Total----------------------------------------------------------
      */

      REDEFINE GET ::oImpOrd VAR ::oDbfVir:nImpOrd ;
         ID       150;
			SPINNER ;
         WHEN     ( nMode != ZOOM_MODE .and. !::oParent:oDbf:lRecCos) ;
         PICTURE  ::oParent:cPouDiv ;
         OF       ::oFld:aDialogs[1]

      ::oImpOrd:bChange   := {|| ::lPrecio( ::oDbfVir ) }
      ::oImpOrd:bValid    := {|| ::lPrecio( ::oDbfVir ) }

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
      Almacén------------------------------------------------------------------
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
      Etiquetas----------------------------------------------------------------
      */
      
      ::oTagsEver            := TTagEver():Redefine( 100, ::oFld:aDialogs[3], nil, aNombreEtiquetas ) 
      ::oTagsEver:lOverClose := .t.

      TBtnBmp():ReDefine( 101, "Lupa",,,,,{|| ::getEtiquetasBrowse() }, ::oFld:aDialogs[3], .f., , .f.,  )

      /*
      Botones------------------------------------------------------------------
      */

      REDEFINE BUTTON oBtnSer ;
         ID       3 ;
         OF       ::oDlg ;
         ACTION   ( nil )

      oBtnSer:bAction   := {|| ::oParent:oDetSeriesProduccion:Resource( nMode ) }

      REDEFINE BUTTON oBtnAtras ;
         ID       4 ;
         OF       ::oDlg ;
         ACTION   ( if( ::oFld:nOption > 1, ::oFld:SetOption( ::oFld:nOption - 1 ), ) )

      REDEFINE BUTTON oBtnAdelante ;
         ID       5 ;
         OF       ::oDlg ;
         ACTION   ( if( ::oFld:nOption < Len( ::oFld:aDialogs ), ::oFld:SetOption( ::oFld:nOption + 1 ), ) ) ;


      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       ::oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::SaveResource( oGetArt, nMode ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       ::oDlg ;
			ACTION 	( ::oDlg:end() )

      if nMode != ZOOM_MODE
         ::oDlg:AddFastKey( VK_F6, {|| oBtnSer:Click() })
         ::oDlg:AddFastKey( VK_F5, {|| ::SaveResource( oGetArt, nMode ) } )
         ::oDlg:AddFastKey( VK_F7, {|| oBtnAtras:Click() } )
         ::oDlg:AddFastKey( VK_F8, {|| oBtnAdelante:Click() } )
      end if

      ::oDlg:bStart := {|| ::EdtRotor(), ::SetResource( nMode ) }

   ACTIVATE DIALOG ::oDlg CENTER

   ::oMenu:End()

RETURN ( ::oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

METHOD SetResource( nMode ) CLASS TDetProduccion

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
      ::oFecCad:HIde()

      ::oSayPr1:Hide()
      ::oValPr1:Hide()
      ::oSayVp1:Hide()

      ::oSayPr2:Hide()
      ::oValPr2:Hide()
      ::oSayVp2:Hide()

   else

      if ::oDbfVir:lLote
         ::oLote:Show()
         ::oFeccad:Show()
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

METHOD LoaArticulo( oGetArticulo, oGetNombre ) CLASS TDetProduccion

   local cCodArt     := oGetArticulo:VarGet()
   local lChgCodArt  := ( Empty( ::cOldCodArt ) .or. Rtrim( ::cOldCodArt ) != Rtrim( cCodArt ) )

   if Empty( cCodArt )

      if lRetCodArt()
         MsgStop( "No se pueden añadir lineas sin codificar" )
         return .f.
      end if

      return .t.

   else

      /*
      if ::oDbfVir:SeekInOrd( cCodArt, "cCodArt" )
         MsgStop( "No pueden existir dos líneas con el mismo artículo" )
         Return .f.
      end if
      */

      /*
      Primero buscamos por codigos de barra
      */

      ::oParent:oArt:ordSetFocus( "CodeBar" )

      if ::oParent:oArt:Seek( cCodArt )
         cCodArt  := ::oParent:oArt:Codigo
      end if

      /*
      Ahora buscamos por el codigo interno
      */

      ::oParent:oArt:ordSetFocus( "Codigo" )

      if ::oParent:oArt:Seek( cCodArt ) .or. ::oParent:oArt:Seek( Upper( cCodArt ) )

         cCodArt                 := ::oParent:oArt:Codigo

         if !uFieldEmpresa( "lNStkAct" )
            ::oStkAct:cText( ::oParent:oStock:nStockAlmacen( cCodArt, ::oDbfVir:cAlmOrd ) )
         end if

         if lChgCodArt

            oGetNombre:cText( ::oParent:oArt:Nombre )

            if ::oParent:oArt:nCajEnt != 0
               ::oGetCaja:cText( ::oParent:oArt:nCajEnt )
            end if

            if ::oParent:oArt:nUniCaja != 0
               ::oGetUnd:cText( ::oParent:oArt:nUniCaja )
            end if

            ::oGetPes:cText(     ::oParent:oArt:nPesoKg )
            ::oGetVol:cText(     ::oParent:oArt:nVolumen )
            ::oGetUndPes:cText(  ::oParent:oArt:cUndDim )
            ::oGetUndVol:cText(  ::oParent:oArt:cVolumen )

            if ::oParent:oArt:lLote
               ::oLote:Show()
               ::oLote:cText( ::oParent:oArt:cLote )
               ::oDbfVir:lLote   := ::oParent:oArt:lLote
               ::oFecCad:Show()
               ::oFecCad:cText( dFechaCaducidad( ::oParent:oDbf:dFecOrd, ::oParent:oArt:nDuracion, ::oParent:oArt:nTipDur ) )
            else
               ::oLote:Hide()
               ::oFecCad:Hide()
            end if

            ::LoadCommunFields()

            if !uFieldEmpresa( "lCosAct" )
               ::oImpOrd:cText( ::oParent:oStock:nCostoMedio( cCodArt, ::oParent:oDbf:cAlmOrd, ::oDbfVir:cCodPr1, ::oDbfVir:cCodPr2, ::oDbfVir:cValPr1, ::oDbfVir:cValPr2, ::oDbfVir:cLote ) )         
            else
               ::oImpOrd:cText( ::oParent:oArt:pCosto )
            end if
         
         end if

         ::lUnidades( ::oDbfVir )
         ::lPrecio( ::oDbfVir )
         ::lTotPeso( ::oDbfVir )
         ::lTotVolumen( ::oDbfVir )

         ::oDbfVir:cCodPr1       := ::oParent:oArt:cCodPrp1
         ::oDbfVir:cCodPr2       := ::oParent:oArt:cCodPrp2

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

         ::cOldCodArt            := cCodArt

         return .t.

      else

         MsgStop( "Artículo no encontrado" )

         return .f.

      end if

   end if

RETURN .t.

//--------------------------------------------------------------------------//

METHOD nUnidades( oDbf ) CLASS TDetProduccion

   local nUnidades   := 0

   DEFAULT oDbf      := ::oDbf

   if !Empty( oDbf )

      nUnidades      := NotCaja( oDbf:nCajOrd() ) * oDbf:nUndOrd() 
      
      if !Empty( ::oParent() ) .and. !Empty (::oParent:nDouDiv )
         nUnidades   := Round( nUnidades, ::oParent:nDouDiv )
      end if

   end if

RETURN ( nUnidades )

//--------------------------------------------------------------------------//

METHOD cUnidades( oDbf ) CLASS TDetProduccion

   DEFAULT oDbf   := ::oDbf

RETURN ( Trans( ::nUnidades( oDbf ), ::oParent:cPicUnd ) )

//--------------------------------------------------------------------------//

METHOD lUnidades( oDbf ) CLASS TDetProduccion

   DEFAULT oDbf   := ::oDbf

RETURN ( ::oGetTotalUnidades:cText( ::nUnidades( oDbf ) ), .t. )

//--------------------------------------------------------------------------//

METHOD nTotalUnidades( oDbf ) CLASS TDetProduccion

   local nTotal   := 0

   DEFAULT oDbf   := ::oDbf

   oDbf:GetStatus()

   oDbf:GoTop()
   while !oDbf:Eof()
      nTotal      += ::nUnidades( oDbf )
      oDbf:Skip()
   end while

   oDbf:SetStatus()

RETURN ( nTotal )

//---------------------------------------------------------------------------//

METHOD nPrecio( oDbf ) CLASS TDetProduccion

   DEFAULT oDbf   := ::oDbf

RETURN ( Round( ::nUnidades( oDbf ) * oDbf:FieldGetByName( "nImpOrd" ), ::oParent:nDorDiv ) )

//--------------------------------------------------------------------------//

METHOD cPrecio( oDbf )  CLASS TDetProduccion

   DEFAULT oDbf   := ::oDbf

RETURN ( Trans( ::nPrecio( oDbf ), ::oParent:cPorDiv ) )

//--------------------------------------------------------------------------//

METHOD lPrecio( oDbf )  CLASS TDetProduccion

   DEFAULT oDbf   := ::oDbf

RETURN ( ::oGetTotalPrecio:cText( ::nPrecio( oDbf ) ), .t. )

//--------------------------------------------------------------------------//

METHOD nTotal( oDbf ) CLASS TDetProduccion

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

METHOD cTotal( oDbf ) CLASS TDetProduccion

   DEFAULT oDbf   := ::oDbf

RETURN ( Trans( ::nTotal( oDbf ), ::oParent:cPorDiv ) )

//---------------------------------------------------------------------------//

METHOD lTotal( oDbf, oGet ) CLASS TDetProduccion

   DEFAULT oDbf   := ::oDbf

RETURN ( oGet:cText( ::nTotal( oDbf ) ), .t. )

//---------------------------------------------------------------------------//

METHOD SaveDetails() CLASS TDetProduccion

   ::oDbfVir:cSerOrd := ::oParent:oDbf:cSerOrd
   ::oDbfVir:nNumOrd := ::oParent:oDbf:nNumOrd
   ::oDbfVir:cSufOrd := ::oParent:oDbf:cSufOrd
   ::oDbfVir:dFecOrd := ::oParent:oDbf:dFecOrd
   ::oDbfVir:cHorIni := ::oParent:oDbf:cHorIni

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD DeleteDetails() CLASS TDetProduccion

   while ::oParent:oDetSeriesProduccion:oDbfVir:SeekInOrd( Str( ::oDbfVir:nNumLin, 4 ) + ::oDbfVir:cCodArt, "nNumLin" )
      ::oParent:oDetSeriesProduccion:oDbfVir:Delete(.f.)
   end while

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD EdtRotor() CLASS TDetProduccion

   MENU ::oMenu

      MENUITEM "&1. Rotor"

         MENU

            MENUITEM    "&1. Modificar artículo";
               MESSAGE  "Modificar la ficha del artículo" ;
               RESOURCE "gc_object_cube_16";
               ACTION   ( if( Empty( ::oDbfVir:cCodArt ), msgStop( "No hay artículo seleccionado" ), EdtArticulo( ::oDbfVir:cCodArt ) ) );

            MENUITEM    "&2. Informe de artículo";
               MESSAGE  "Abrir el informe del articulo" ;
               RESOURCE "Info16";
               ACTION   ( if( Empty( ::oDbfVir:cCodArt ), msgStop( "No hay artículo seleccionado" ), InfArticulo( ::oDbfVir:cCodArt ) ) );

         ENDMENU

   ENDMENU

   ::oDlg:SetMenu( ::oMenu )

RETURN ( ::oMenu )

//---------------------------------------------------------------------------//

METHOD nTotPeso( oDbf ) CLASS TDetProduccion

   DEFAULT oDbf   := ::oDbf

RETURN ( Round( NotCaja( oDbf:nCajOrd ) * oDbf:nUndOrd, ::oParent:nDouDiv ) * oDbf:nPeso )

//---------------------------------------------------------------------------//

METHOD nTotVolumen( oDbf ) CLASS TDetProduccion

   DEFAULT oDbf   := ::oDbf

RETURN ( Round( NotCaja( oDbf:nCajOrd ) * oDbf:nUndOrd, ::oParent:nDouDiv ) * oDbf:nVolumen )

//---------------------------------------------------------------------------//

METHOD lTotPeso( oDbf ) CLASS TDetProduccion

   DEFAULT oDbf   := ::oDbf

RETURN ( ::oGetTotPes:cText( ::nTotPeso( oDbf ) ), .t. )

//---------------------------------------------------------------------------//

METHOD lTotVolumen( oDbf ) CLASS TDetProduccion

   DEFAULT oDbf   := ::oDbf

RETURN ( ::oGetTotVol:cText( ::nTotVolumen( oDbf ) ), .t. )

//---------------------------------------------------------------------------//

METHOD SaveResource( oGetArt, nMode ) CLASS TDetProduccion

   local nOrdAnt
   local nUnidades := 0

   if Empty( ::oDbfVir:cCodArt )
      MsgStop( "Tiene que seleccionar un artículo." )
      oGetArt:SetFocus()
      Return .f.
   end if

   if !::runScriptBeforeAppend( self )
      Return .f.
   end if

   ::oDbfVir:nTipArt    := ::oClasificacionArticulo:GetNumber()

   do case
      case nMode == APPD_MODE

         //Añadimos las materias primas----------------------------------------

         if ::oParent:oArt:Seek( ::oDbfVir:cCodArt )

            /*Vemos que el artículo tenga componentes pero que no tenga asociados*/

            if ::oParent:oArt:lKitArt .and. !::oParent:oArt:lKitAsc

               /*Pasamos a la base de datos de los kits*/

               if ::oParent:oKitArt:Seek( ::oDbfVir:cCodArt )

                  while ::oParent:oKitArt:cCodKit == ::oDbfVir:cCodArt .and. !::oParent:oKitArt:Eof()

                     nUnidades := NotCaja( ::oDbfVir:nCajOrd ) * ::oDbfVir:nUndOrd

                     /*Añadimos todos los arículos del kit*/

                     if !::oParent:oKitArt:lExcPro

                        ::oParent:oDetMaterial:oDbfVir:Append()

                        ::oParent:oDetMaterial:oDbfVir:cCodArt    := ::oParent:oKitArt:cRefKit
                        ::oParent:oDetMaterial:oDbfVir:cNomArt    := ::oParent:oKitArt:cDesKit
                        ::oParent:oDetMaterial:oDbfVir:cAlmOrd    := ::oParent:oDbf:cAlmOrg
                        ::oParent:oDetMaterial:oDbfVir:nCajOrd    := 1
                        ::oParent:oDetMaterial:oDbfVir:nUndOrd    := nUnidades * ::oParent:oKitArt:nUndKit
                        ::oParent:oDetMaterial:oDbfVir:nImpOrd    := oRetFld( ::oParent:oKitArt:cRefKit, ::oParent:oArt, "pCosto" )
                        ::oParent:oDetMaterial:oDbfVir:nPeso      := oRetFld( ::oParent:oKitArt:cRefKit, ::oParent:oArt, "nPesoKg" )
                        ::oParent:oDetMaterial:oDbfVir:cUndPes    := oRetFld( ::oParent:oKitArt:cRefKit, ::oParent:oArt, "cUnidad" )
                        ::oParent:oDetMaterial:oDbfVir:nVolumen   := oRetFld( ::oParent:oKitArt:cRefKit, ::oParent:oArt, "nVolumen" )
                        ::oParent:oDetMaterial:oDbfVir:cUndVol    := oRetFld( ::oParent:oKitArt:cRefKit, ::oParent:oArt, "cVolumen" )
                        ::oParent:oDetMaterial:oDbfVir:cCodPr1    := Space(20)
                        ::oParent:oDetMaterial:oDbfVir:cCodPr2    := Space(20)
                        ::oParent:oDetMaterial:oDbfVir:cValPr1    := Space(20)
                        ::oParent:oDetMaterial:oDbfVir:cValPr2    := Space(20)
                        ::oParent:oDetMaterial:oDbfVir:lLote      := oRetFld( ::oParent:oKitArt:cRefKit, ::oParent:oArt, "lLote" )
                        ::oParent:oDetMaterial:oDbfVir:cLote      := oRetFld( ::oParent:oKitArt:cRefKit, ::oParent:oArt, "cLote" )
                        ::oParent:oDetMaterial:oDbfVir:cCodPro    := ::oDbfVir:cCodArt
                        ::oParent:oDetMaterial:oDbfVir:cEtiqueta  := ::oDbfVir:Etiqueta


                        ::oParent:oDetMaterial:oDbfVir:Save()

                     end if

                     ::oParent:oKitArt:Skip()

                  end while

               end if

            end if

         end if

      case nMode == EDIT_MODE

         //Actualizamos las unidades de las materias primas--------------------

         nOrdAnt  := ::oParent:oDetMaterial:oDbfVir:OrdsetFocus( "cCodPro" )

         ::oParent:oDetMaterial:oDbfVir:GoTop()

         if ::oParent:oDetMaterial:oDbfVir:Seek( ::oDbfVir:cCodArt )

            while ::oParent:oDetMaterial:oDbfVir:cCodPro == ::oDbfVir:cCodArt .and. !::oParent:oDetMaterial:oDbfVir:Eof()

               ::oParent:oDetMaterial:oDbfVir:Load()

               if ::oParent:oKitArt:SeekInOrd( ::oDbfVir:cCodArt + ::oParent:oDetMaterial:oDbfVir:cCodArt, "cCodRef" )
                  ::oParent:oDetMaterial:oDbfVir:nUndOrd    := ::nUnidades( ::oDbfVir ) * ::oParent:oKitArt:nUndKit
               end if

               ::oParent:oDetMaterial:oDbfVir:Save()

               ::oParent:oDetMaterial:oDbfVir:Skip()

            end While

         end if

         ::oParent:oDetMaterial:oDbfVir:OrdSetFocus( nOrdAnt )

   end case

   ::oParent:oDetMaterial:oDbfVir:GoTop()

   ::oParent:oTotProducido:Refresh()
   ::oParent:oTotMaterias:Refresh()
   ::oParent:oTotPersonal:Refresh()

RETURN ::oDlg:end( IDOK )

//---------------------------------------------------------------------------//

METHOD lStkAct() CLASS TDetProduccion

RETURN ( if ( !uFieldEmpresa( "lNStkAct" ), ::oStkAct:cText( ::oParent:oStock:nStockAlmacen( ::oDbfVir:cCodArt, ::oDbfVir:cAlmOrd ) ), ), .t. )

//---------------------------------------------------------------------------//

METHOD Del( oBrw1, oBrw2 ) CLASS TDetProduccion

   while ::oParent:oDetMaterial:oDbfVir:SeekInOrd( ::oDbfVir:cCodArt, "cCodPro" )
      ::oParent:oDetMaterial:oDbfVir:Delete(.f.)
   end while

   while ::oParent:oDetSeriesProduccion:oDbfVir:SeekInOrd( Str( ::oDbfVir:nNumLin, 4 ), "nNumLin" )
      ::oParent:oDetSeriesProduccion:oDbfVir:Delete(.f.)
   end while

   ::Super:Del( oBrw1 )

   ::oParent:oTotProducido:Refresh()

   ::oParent:oTotMaterias:Refresh()

   oBrw1:Refresh()
   oBrw2:Refresh()

RETURN .t.

//--------------------------------------------------------------------------//

METHOD getEtiquetasBrowse() CLASS TDetProduccion

   local aSelected

   aSelected         := EtiquetasController():New():activateBrowse( ::oTagsEver:getItems() )

   if !empty( aSelected )
      ::oTagsEver:setItems( aSelected )
      ::oTagsEver:Refresh()
   end if 

Return ( nil )

//---------------------------------------------------------------------------//

/*
METHOD migrateToEtiquetas() CLASS TDetProduccion

   local idCategory

   if !::OpenFiles()
      RETURN ( nil )
   end if 

   ::oDbf:GoTop()
   while !::oDbf:Eof()

      if !empty(::oDbf:cCodCat)
         
         idCategory  := EtiquetasModel():getEtiquetaId( ::oDbf:cCodCat )

         if !empty(idCategory)
            ::oDbf:fieldPutByName( "cEtiqueta", idCategory )
         end if 

      end if 

      ::oDbf:Skip()

   end while

   ::CloseFiles()

Return ( nil )
*/

//---------------------------------------------------------------------------//

Function nTotNProduccion( uDbf )

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

CLASS TDetSeriesProduccion FROM TDet

   METHOD New( cPath, oParent )

   METHOD DefineFiles()

   METHOD OpenFiles( lExclusive )
   METHOD CloseFiles()

   MESSAGE OpenService( lExclusive )   METHOD OpenFiles( lExclusive )

   METHOD SaveDetails()

   METHOD Resource( nMode, lLiteral )

END CLASS

//--------------------------------------------------------------------------//

METHOD New( cPath, oParent ) CLASS TDetSeriesProduccion

   DEFAULT cPath        := cPatEmp()

   ::cPath              := cPath
   ::oParent            := oParent

   ::bOnPreSaveDetail   := {|| ::SaveDetails() }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cVia, lUniqueName, cFileName ) CLASS TDetSeriesProduccion

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT lUniqueName  := .f.
   DEFAULT cFileName    := "ProSer"
   DEFAULT cVia         := cDriver()

   if lUniqueName
      cFileName         := cGetNewFileName( cFileName, , , cPath )
   end if

   DEFINE TABLE oDbf FILE ( cFileName ) CLASS ( cFileName ) ALIAS ( cFileName ) PATH ( cPath ) VIA ( cVia ) COMMENT "Números de serie de materiales producidos"

      FIELD NAME "cSerOrd"    TYPE "C" LEN 01  DEC 0 COMMENT "Código"                           HIDE        OF oDbf
      FIELD NAME "nNumOrd"    TYPE "N" LEN 09  DEC 0 COMMENT "Número"                           HIDE        OF oDbf
      FIELD NAME "cSufOrd"    TYPE "C" LEN 02  DEC 0 COMMENT "Sufijo"                           HIDE        OF oDbf
      FIELD NAME "dFecOrd"    TYPE "D" LEN 08  DEC 0 COMMENT "Fecha"                                        OF oDbf
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

//--------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath ) CLASS TDetSeriesProduccion

   local lOpen             := .t.
   local oBlock

   DEFAULT  lExclusive     := .f.

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf            := ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !lExclusive )

   RECOVER

      lOpen                := .f.

      ::CloseFiles()

      msgStop( "Imposible abrir todas las bases de datos" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//--------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TDetSeriesProduccion

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   ::oDbf                  := nil

RETURN .t.

//---------------------------------------------------------------------------//

METHOD SaveDetails() CLASS TDetSeriesProduccion

   ::oDbfVir:cSerOrd    := ::oParent:oDbf:cSerOrd
   ::oDbfVir:nNumOrd    := ::oParent:oDbf:nNumOrd
   ::oDbfVir:cSufOrd    := ::oParent:oDbf:cSufOrd
   ::oDbfVir:dFecOrd    := ::oParent:oDbf:dFecFin

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS TDetSeriesProduccion

   with object ( TNumerosSerie() )

      :nMode            := nMode

      :lCompras         := .t.

      :cCodArt          := ::oParent:oDetProduccion:oDbfVir:cCodArt
      :nNumLin          := ::oParent:oDetProduccion:oDbfVir:nNumLin
      :cCodAlm          := ::oParent:oDbf:cAlmOrd

      :nTotalUnidades   := ::oParent:oDetProduccion:nUnidades( ::oParent:oDetProduccion:oDbfVir )

      :oStock           := ::oParent:oStock

      ::oDbfVir:GetStatus()
      ::oDbfVir:OrdSetFocus( "nNumLin" )

      :uTmpSer          := ::oDbfVir

      :Resource()

      ::oDbfVir:SetStatus()

   end with

RETURN ( Self )

//--------------------------------------------------------------------------//