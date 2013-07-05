#include "FiveWin.Ch"
#include "Factu.ch"
#include "Menu.ch"
#include "Report.ch"
#include "MesDbf.ch"
#include "Xbrowse.ch"

//--------------------------------------------------------------------------//

CLASS TDetProduccion FROM TDet

   DATA  oGetCaja
   DATA  oGetUnd
   DATA  oImpOrd
   DATA  oMenu

   DATA  oGetTotalUnidades
   DATA  nGetTotalUnidades    INIT  0
   DATA  oGetTotalPrecio
   DATA  nGetTotalPrecio      INIT  0
   DATA  oLote
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

   METHOD DefineFiles()

   METHOD OpenFiles( lExclusive )
   METHOD CloseFiles()

   MESSAGE OpenService( lExclusive )   METHOD OpenFiles( lExclusive )

   METHOD Resource( nMode, lLiteral )
   METHOD SetDialogMode()
   METHOD lPreSave( oGetArt, oDlg, nMode )

   METHOD LoaArticulo( oGetArticulo, oGetNombre )

   METHOD SaveDetails()
   METHOD DeleteDetails()

   METHOD nTotUnidades( oDbf )
   METHOD cTotUnidades( oDbf )
   METHOD lTotUnidades( oDbf )

   METHOD nTotPrecio( oDbf )
   METHOD cTotPrecio( oDbf )
   METHOD lTotPrecio( oDbf )

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

END CLASS

//--------------------------------------------------------------------------//

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

      FIELD NAME "cSerOrd"    TYPE "C" LEN 01  DEC 0 COMMENT "Código"                        HIDE        OF oDbf
      FIELD NAME "nNumOrd"    TYPE "N" LEN 09  DEC 0 COMMENT "Número"                        HIDE        OF oDbf
      FIELD NAME "cSufOrd"    TYPE "C" LEN 02  DEC 0 COMMENT "Sufijo"                        HIDE        OF oDbf
      FIELD NAME "nNumLin"    TYPE "N" LEN 04  DEC 0 COMMENT "Número de línea"               COLSIZE  20 OF oDbf
      FIELD NAME "cCodArt"    TYPE "C" LEN 18  DEC 0 COMMENT "Artículo"                      COLSIZE  60 OF oDbf
      FIELD NAME "cNomArt"    TYPE "C" LEN 100 DEC 0 COMMENT "Nombre"                        COLSIZE 240 OF oDbf
      FIELD NAME "cAlmOrd"    TYPE "C" LEN 03  DEC 0 COMMENT "Almacén"                       COLSIZE  50 OF oDbf
      FIELD NAME "nCajOrd"    TYPE "N" LEN 16  DEC 6 COMMENT "Cajas"                         HIDE        OF oDbf
      FIELD NAME "nUndOrd"    TYPE "N" LEN 16  DEC 6 COMMENT "Unidades"                      HIDE        OF oDbf
      FIELD NAME "nImpOrd"    TYPE "N" LEN 16  DEC 6 COMMENT "Precio"                        COLSIZE  80 OF oDbf
      FIELD NAME "nPeso"      TYPE "N" LEN 16  DEC 6 COMMENT "Peso del artículo"             COLSIZE  80 OF oDbf
      FIELD NAME "cUndPes"    TYPE "C" LEN  2  DEC 0 COMMENT "Unidad del peso"               COLSIZE  80 OF oDbf
      FIELD NAME "nVolumen"   TYPE "N" LEN 16  DEC 6 COMMENT "Volumen del artículo"          COLSIZE  80 OF oDbf
      FIELD NAME "cUndVol"    TYPE "C" LEN  2  DEC 0 COMMENT "Unidad del volumen"            COLSIZE  80 OF oDbf
      FIELD NAME "cCodPr1"    TYPE "C" LEN 10  DEC 0 COMMENT "Código de primera propiedad"   COLSIZE  80 OF oDbf
      FIELD NAME "cCodPr2"    TYPE "C" LEN 10  DEC 0 COMMENT "Código de segunda propiedad"   COLSIZE  80 OF oDbf
      FIELD NAME "cValPr1"    TYPE "C" LEN 10  DEC 0 COMMENT "Valor de primera propiedad"    COLSIZE  80 OF oDbf
      FIELD NAME "cValPr2"    TYPE "C" LEN 10  DEC 0 COMMENT "Valor de segunda propiedad"    COLSIZE  80 OF oDbf
      FIELD NAME "lLote"      TYPE "L" LEN  1  DEC 0 COMMENT "Lógico lote"                   COLSIZE  80 OF oDbf
      FIELD NAME "cLote"      TYPE "C" LEN 12  DEC 0 COMMENT "Lote"                          COLSIZE  80 OF oDbf
      FIELD NAME "dFecOrd"    TYPE "D" LEN  8  DEC 0 COMMENT "Fecha"                         HIDE        OF oDbf

      INDEX TO ( cFileName )  TAG "cNumOrd" ON "cSerOrd + Str( nNumOrd,9 ) + cSufOrd"        NODELETED   OF oDbf
      INDEX TO ( cFileName )  TAG "cCodArt" ON "cCodArt"                                     NODELETED   OF oDbf
      INDEX TO ( cFileName )  TAG "nNumLin" ON "Str( nNumLin, 4 )"                           NODELETED   OF oDbf
      INDEX TO ( cFileName )  TAG "cLote"   ON "cLote"                                       NODELETED   OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//--------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive ) CLASS TDetProduccion

   local lOpen             := .t.
   local oBlock

   DEFAULT  lExclusive     := .f.

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf            := ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !lExclusive )

      ::bOnPreSaveDetail   := {|| ::SaveDetails() }
      ::bOnPreDelete       := {|| ::DeleteDetails() }

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      lOpen                := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpen
      ::CloseFiles()
   end if

RETURN ( lOpen )

//--------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TDetProduccion

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
      ::oDbf               := nil
   end if

RETURN .t.

//---------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS TDetProduccion

   local oDlg
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
      ::nStkAct         := ::oParent:oStock:nStockActual( ::oDbfVir:cCodArt, ::oDbfVir:cAlmOrd )
   else
      ::nStkAct         := 0
   end if

   ::nGetTotalUnidades  := ::nTotUnidades( ::oDbfVir )
   ::nGetTotalPrecio    := ::nTotPrecio( ::oDbfVir )
   ::nGetTotPes         := ::nTotPeso( ::oDbfVir )
   ::nGetTotVol         := ::nTotVolumen( ::oDbfVir )

   cSayAlm              := RetAlmacen( ::oDbfVir:cAlmOrd, ::oParent:oAlm )

   DEFINE DIALOG oDlg RESOURCE "LPRODUCIDO" TITLE LblTitle( nMode ) + "articulos producidos"

      /*
      Codigo de articulo-------------------------------------------------------
      */

      REDEFINE GET oGetArt VAR ::oDbfVir:cCodArt;
         ID       110 ;
         WHEN     ( nMode == APPD_MODE );
         BITMAP   "LUPA" ;
         OF       oDlg

      oGetArt:bValid := {|| cArticulo( oGetArt, ::oParent:oArt:cAlias, oGetNom ), ::LoaArticulo( oGetArt, oGetNom ) }
      oGetArt:bHelp  := {|| BrwArticulo( oGetArt, oGetNom ), ::LoaArticulo( oGetArt, oGetNom ) }

      REDEFINE GET oGetNom VAR ::oDbfVir:cNomArt ;
         ID       111 ;
         WHEN     ( nMode == APPD_MODE ) ;
         OF       oDlg

      /*
      Lotes-------------------------------------------------------------------
      */

      REDEFINE GET ::oLote VAR ::oDbfVir:cLote;
         ID       210 ;
         IDSAY    211 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      /*
      Propiedades--------------------------------------------------------------
      */

      REDEFINE SAY ::oSayPr1 VAR cSayPr1;
         ID       221 ;
         OF       oDlg

      REDEFINE GET ::oValPr1 VAR ::oDbfVir:cValPr1;
         ID       220 ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

         ::oValPr1:bValid := {|| lPrpAct( ::oDbfVir:cValPr1, ::oSayVp1, ::oDbfVir:cCodPr1, ::oParent:oTblPro:cAlias ) }
         ::oValPr1:bHelp  := {|| brwPrpAct( ::oValPr1, ::oSayVp1, ::oDbfVir:cCodPr1 ) }

      REDEFINE GET ::oSayVp1 VAR cSayVp1;
         ID       222 ;
         WHEN     .f. ;
         COLOR    CLR_GET ;
         OF       oDlg

      REDEFINE SAY ::oSayPr2 VAR cSayPr2;
         ID       231 ;
         OF       oDlg

      REDEFINE GET ::oValPr2 VAR ::oDbfVir:cValPr2;
         ID       230 ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

         ::oValPr2:bValid := {|| lPrpAct( ::oDbfVir:cValPr2, ::oSayVp2, ::oDbfVir:cCodPr2, ::oParent:oTblPro:cAlias ) }
         ::oValPr2:bHelp  := {|| brwPrpAct( ::oValPr2, ::oSayVp2, ::oDbfVir:cCodPr2 ) }

      REDEFINE GET ::oSayVp2 VAR cSayVp2;
         ID       232 ;
         WHEN     .f. ;
         COLOR    CLR_GET ;
         OF       oDlg

      /*
      Cajas y unidades---------------------------------------------------------
      */

      REDEFINE GET ::oGetCaja VAR ::oDbfVir:nCajOrd ;
         ID       120 ;
         IDSAY    121 ;
			SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  ::oParent:cPicUnd ;
         OF       oDlg

      ::oGetCaja:bChange   := {|| ::lTotUnidades( ::oDbfVir ), ::lTotPrecio( ::oDbfVir ), ::lTotPeso( ::oDbfVir ), ::lTotVolumen( ::oDbfVir ) }
      ::oGetCaja:bValid    := {|| ::lTotUnidades( ::oDbfVir ), ::lTotPrecio( ::oDbfVir ), ::lTotPeso( ::oDbfVir ), ::lTotVolumen( ::oDbfVir ) }

      REDEFINE GET ::oGetUnd VAR ::oDbfVir:nUndOrd ;
         ID       130;
			SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  ::oParent:cPicUnd ;
         OF       oDlg

      ::oGetUnd:bChange   := {|| ::lTotUnidades( ::oDbfVir ), ::lTotPrecio( ::oDbfVir ), ::lTotPeso( ::oDbfVir ), ::lTotVolumen( ::oDbfVir ) }
      ::oGetUnd:bValid    := {|| ::lTotUnidades( ::oDbfVir ), ::lTotPrecio( ::oDbfVir ), ::lTotPeso( ::oDbfVir ), ::lTotVolumen( ::oDbfVir ) }

      REDEFINE GET ::oGetTotalUnidades VAR ::nGetTotalUnidades ;
         ID       140;
         WHEN     ( .f. ) ;
         PICTURE  ::oParent:cPicUnd ;
         OF       oDlg

      /*
      Importe y Total----------------------------------------------------------
      */

      REDEFINE GET ::oImpOrd VAR ::oDbfVir:nImpOrd ;
         ID       150;
			SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  ::oParent:cPouDiv ;
         OF       oDlg

      ::oImpOrd:bChange   := {|| ::lTotPrecio( ::oDbfVir ) }
      ::oImpOrd:bValid    := {|| ::lTotPrecio( ::oDbfVir ) }

      REDEFINE GET ::oGetTotalPrecio VAR ::nGetTotalPrecio ;
         ID       160;
         WHEN     ( .f. ) ;
         PICTURE  ::oParent:cPorDiv ;
         OF       oDlg

      /*
      Pesos--------------------------------------------------------------------
      */

      REDEFINE GET ::oGetPes VAR ::oDbfVir:nPeso ;
         ID       170;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  MasUnd() ;
         OF       oDlg

      ::oGetPes:bChange   := {|| ::lTotPeso( ::oDbfVir ) }
      ::oGetPes:bValid    := {|| ::lTotPeso( ::oDbfVir ) }

      REDEFINE GET ::oGetUndPes VAR ::oDbfVir:cUndPes ;
         ID       171;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oGetTotPes VAR ::nGetTotPes ;
         ID       172;
         WHEN     ( .f. ) ;
         PICTURE  MasUnd() ;
         OF       oDlg

      /*
      Volumen------------------------------------------------------------------
      */

      REDEFINE GET ::oGetVol VAR ::oDbfVir:nVolumen ;
         ID       180;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  MasUnd() ;
         OF       oDlg

      ::oGetVol:bChange   := {|| ::lTotVolumen( ::oDbfVir ) }
      ::oGetVol:bValid    := {|| ::lTotVolumen( ::oDbfVir ) }

      REDEFINE GET ::oGetUndVol VAR ::oDbfVir:cUndVol ;
         ID       181;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oGetTotVol VAR ::nGetTotVol ;
         ID       182;
         WHEN     ( .f. ) ;
         PICTURE  MasUnd() ;
         OF       oDlg

      /*
      Almacén------------------------------------------------------------------
      */

      REDEFINE GET oGetAlm VAR ::oDbfVir:cAlmOrd;
         ID       190 ;
         WHEN     ( nMode != ZOOM_MODE );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( oGetAlm, oSayAlm ) ) ;
         OF       oDlg

      oGetAlm:bChange   := {|| ::lStkAct() }
      oGetAlm:bValid    := {|| cAlmacen( oGetAlm, ::oParent:oAlm, oSayAlm ), ::lStkAct() }

      REDEFINE GET oSayAlm VAR cSayAlm ;
         ID       191 ;
         WHEN     ( .f. ) ;
         OF       oDlg

      /*
      Stock Actual-------------------------------------------------------------
      */

      REDEFINE GET ::oStkAct VAR ::nStkAct ;
         ID       200 ;
         WHEN     .f. ;
         PICTURE  MasUnd() ;
         OF       oDlg

      REDEFINE BUTTON oBtnSer ;
         ID       552 ;
			OF 		oDlg ;
         ACTION   ( nil )

      oBtnSer:bAction   := {|| ::oParent:oDetSeriesProduccion:Resource( nMode ) }

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::lPreSave( oGetArt, oDlg, nMode ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

      REDEFINE BUTTON ;
         ID       9 ;
			OF 		oDlg ;
         ACTION   ( MsgInfo( "Ayuda no disponible", "Perdonen las molestias" ) )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F1, {|| MsgInfo( "Ayuda no disponible", "Perdonen las molestias" ) } )
         oDlg:AddFastKey( VK_F6, {|| oBtnSer:Click() })
         oDlg:AddFastKey( VK_F5, {|| ::lPreSave( oGetArt, oDlg, nMode ) } )
      end if

      oDlg:bStart := {|| ::EdtRotor( oDlg ), ::SetDialogMode( nMode ) }

   ACTIVATE DIALOG oDlg CENTER

   ::oMenu:End()

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

METHOD SetDialogMode( nMode ) CLASS TDetProduccion

   if !lUseCaj()
      ::oGetCaja:Hide()
   end if

   if nMode == APPD_MODE

      ::oLote:Hide()

      ::oSayPr1:Hide()
      ::oValPr1:Hide()
      ::oSayVp1:Hide()

      ::oSayPr2:Hide()
      ::oValPr2:Hide()
      ::oSayVp2:Hide()

   else

      if ::oDbfVir:lLote
         ::oLote:Show()
      else
         ::oLote:Hide()
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

         cCodArt  := ::oParent:oArt:Codigo

         if !uFieldEmpresa( "lNStkAct" )
            ::oStkAct:cText( ::oParent:oStock:nStockActual( cCodArt, ::oDbfVir:cAlmOrd ) )
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
            ::oImpOrd:cText(     ::oParent:oArt:pCosto )
            ::oGetUndPes:cText(  ::oParent:oArt:cUndDim )
            ::oGetUndVol:cText(  ::oParent:oArt:cVolumen )

            if ::oParent:oArt:lLote
               ::oLote:Show()
               ::oLote:cText( ::oParent:oArt:cLote )
               ::oDbfVir:lLote   := ::oParent:oArt:lLote
            else
               ::oLote:Hide()
            end if

         end if

         ::lTotUnidades( ::oDbfVir )
         ::lTotPrecio( ::oDbfVir )
         ::lTotPeso( ::oDbfVir )
         ::lTotVolumen( ::oDbfVir )

         if ::oParent:oFam:Seek( ::oParent:oArt:Familia )
            ::oDbfVir:cCodPr1 := ::oParent:oFam:cCodPrp1
            ::oDbfVir:cCodPr2 := ::oParent:oFam:cCodPrp2
         else
            ::oDbfVir:cCodPr1 := Space( 10 )
            ::oDbfVir:cCodPr2 := Space( 10 )
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

         ::cOldCodArt   := cCodArt

         return .t.

      else

         MsgStop( "Artículo no encontrado" )

         return .f.

      end if

   end if

RETURN .t.

//--------------------------------------------------------------------------//

METHOD nTotUnidades( oDbf ) CLASS TDetProduccion

   DEFAULT oDbf   := ::oDbf

RETURN ( if( !Empty( ::oParent:nDouDiv ), Round( NotCaja( oDbf:nCajOrd ) * oDbf:nUndOrd, ::oParent:nDouDiv ), ( NotCaja( oDbf:nCajOrd ) * oDbf:nUndOrd ) ) )

//--------------------------------------------------------------------------//

METHOD cTotUnidades( oDbf ) CLASS TDetProduccion

   DEFAULT oDbf   := ::oDbf

RETURN ( Trans( ::nTotUnidades( oDbf ), ::oParent:cPicUnd ) )

//--------------------------------------------------------------------------//

METHOD lTotUnidades( oDbf ) CLASS TDetProduccion

   DEFAULT oDbf   := ::oDbf

RETURN ( ::oGetTotalUnidades:cText( ::nTotUnidades( oDbf ) ), .t. )

//--------------------------------------------------------------------------//

METHOD nTotPrecio( oDbf ) CLASS TDetProduccion

   DEFAULT oDbf   := ::oDbf

RETURN ( Round( ::nTotUnidades( oDbf ) * oDbf:nImpOrd, ::oParent:nDorDiv ) )

//--------------------------------------------------------------------------//

METHOD cTotPrecio( oDbf )  CLASS TDetProduccion

   DEFAULT oDbf   := ::oDbf

RETURN ( Trans( ::nTotPrecio( oDbf ), ::oParent:cPorDiv ) )

//--------------------------------------------------------------------------//

METHOD lTotPrecio( oDbf )  CLASS TDetProduccion

   DEFAULT oDbf   := ::oDbf

RETURN ( ::oGetTotalPrecio:cText( ::nTotPrecio( oDbf ) ), .t. )

//--------------------------------------------------------------------------//

METHOD nTotal( oDbf ) CLASS TDetProduccion

   local nTotal   := 0

   DEFAULT oDbf   := ::oDbf

   oDbf:GetStatus()

   oDbf:GoTop()

   while !oDbf:Eof()
      nTotal      += ::nTotPrecio( oDbf )
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

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD DeleteDetails() CLASS TDetProduccion

   while ::oParent:oDetSeriesProduccion:oDbfVir:SeekInOrd( Str( ::oDbfVir:nNumLin, 4 ) + ::oDbfVir:cCodArt, "nNumLin" )
      ::oParent:oDetSeriesProduccion:oDbfVir:Delete(.f.)
   end while

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD EdtRotor( oDlg ) CLASS TDetProduccion

   MENU ::oMenu

      MENUITEM "&1. Rotor"

         MENU

            MENUITEM    "&1. Modificar artículo";
               MESSAGE  "Modificar la ficha del artículo" ;
               RESOURCE "Cube_Yellow_16";
               ACTION   ( if( Empty( ::oDbfVir:cCodArt ), msgStop( "No hay artículo seleccionado" ), EdtArticulo( ::oDbfVir:cCodArt ) ) );

            MENUITEM    "&2. Informe de artículo";
               MESSAGE  "Abrir el informe del articulo" ;
               RESOURCE "Info16";
               ACTION   ( if( Empty( ::oDbfVir:cCodArt ), msgStop( "No hay artículo seleccionado" ), InfArticulo( ::oDbfVir:cCodArt ) ) );

         ENDMENU

   ENDMENU

   oDlg:SetMenu( ::oMenu )

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

METHOD lPreSave( oGetArt, oDlg, nMode ) CLASS TDetProduccion

   local nOrdAnt

   if Empty( ::oDbfVir:cCodArt )
      MsgStop( "Tiene que seleccionar un artículo." )
      oGetArt:SetFocus()
      Return .f.
   end if

   do case
      case nMode == APPD_MODE

         //Añadimos las materias primas----------------------------------------

         if ::oParent:oArt:Seek( ::oDbfVir:cCodArt )

            /*Vemos que el artículo tenga componentes pero que no tenga asociados*/

            if ::oParent:oArt:lKitArt .and. !::oParent:oArt:lKitAsc

               /*Pasamos a la base de datos de los kits*/

               if ::oParent:oKitArt:Seek( ::oDbfVir:cCodArt )

                  while ::oParent:oKitArt:cCodKit == ::oDbfVir:cCodArt .and. !::oParent:oKitArt:Eof()

                     /*Añadimos todos los arículos del kit*/

                     if !::oParent:oKitArt:lExcPro

                        ::oParent:oDetMaterial:oDbfVir:Append()

                        ::oParent:oDetMaterial:oDbfVir:cCodArt    := ::oParent:oKitArt:cRefKit
                        ::oParent:oDetMaterial:oDbfVir:cNomArt    := ::oParent:oKitArt:cDesKit
                        ::oParent:oDetMaterial:oDbfVir:cAlmOrd    := ::oParent:oDbf:cAlmOrg
                        ::oParent:oDetMaterial:oDbfVir:nCajOrd    := 1
                        ::oParent:oDetMaterial:oDbfVir:nUndOrd    := ::nTotUnidades( ::oDbfVir ) * ::oParent:oKitArt:nUndKit
                        ::oParent:oDetMaterial:oDbfVir:nImpOrd    := oRetFld( ::oParent:oKitArt:cRefKit, ::oParent:oArt, "pCosto" )
                        ::oParent:oDetMaterial:oDbfVir:nPeso      := oRetFld( ::oParent:oKitArt:cRefKit, ::oParent:oArt, "nPesoKg" )
                        ::oParent:oDetMaterial:oDbfVir:cUndPes    := oRetFld( ::oParent:oKitArt:cRefKit, ::oParent:oArt, "cUnidad" )
                        ::oParent:oDetMaterial:oDbfVir:nVolumen   := oRetFld( ::oParent:oKitArt:cRefKit, ::oParent:oArt, "nVolumen" )
                        ::oParent:oDetMaterial:oDbfVir:cUndVol    := oRetFld( ::oParent:oKitArt:cRefKit, ::oParent:oArt, "cVolumen" )
                        ::oParent:oDetMaterial:oDbfVir:cCodPr1    := Space(5)
                        ::oParent:oDetMaterial:oDbfVir:cCodPr2    := Space(5)
                        ::oParent:oDetMaterial:oDbfVir:cValPr1    := Space(5)
                        ::oParent:oDetMaterial:oDbfVir:cValPr2    := Space(5)
                        ::oParent:oDetMaterial:oDbfVir:lLote      := oRetFld( ::oParent:oKitArt:cRefKit, ::oParent:oArt, "lLote" )
                        ::oParent:oDetMaterial:oDbfVir:cLote      := oRetFld( ::oParent:oKitArt:cRefKit, ::oParent:oArt, "cLote" )
                        ::oParent:oDetMaterial:oDbfVir:cCodPro    := ::oDbfVir:cCodArt

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
                  ::oParent:oDetMaterial:oDbfVir:nUndOrd    := ::nTotUnidades( ::oDbfVir ) * ::oParent:oKitArt:nUndKit
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

RETURN oDlg:end( IDOK )

//---------------------------------------------------------------------------//

METHOD lStkAct() CLASS TDetProduccion

RETURN ( if ( !uFieldEmpresa( "lNStkAct" ), ::oStkAct:cText( ::oParent:oStock:nStockActual( ::oDbfVir:cCodArt, ::oDbfVir:cAlmOrd ) ), ), .t. )

//---------------------------------------------------------------------------//

METHOD Del( oBrw1, oBrw2 ) CLASS TDetProduccion

   while ::oParent:oDetMaterial:oDbfVir:SeekInOrd( ::oDbfVir:cCodArt, "cCodPro" )
      ::oParent:oDetMaterial:oDbfVir:Delete(.f.)
   end while

   while ::oParent:oDetSeriesProduccion:oDbfVir:SeekInOrd( Str( ::oDbfVir:nNumLin, 4 ), "nNumLin" )
      ::oParent:oDetSeriesProduccion:oDbfVir:Delete(.f.)
   end while

   Super:Del( oBrw1 )

   ::oParent:oTotProducido:Refresh()

   ::oParent:oTotMaterias:Refresh()

   oBrw1:Refresh()
   oBrw2:Refresh()

RETURN .t.

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

   METHOD DefineFiles()

   METHOD OpenFiles( lExclusive )
   METHOD CloseFiles()

   MESSAGE OpenService( lExclusive )   METHOD OpenFiles( lExclusive )

   METHOD SaveDetails()

   METHOD Resource( nMode, lLiteral )

END CLASS

//--------------------------------------------------------------------------//

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
      FIELD NAME "cAlmOrd"    TYPE "C" LEN 03  DEC 0 COMMENT "Almacén"                          COLSIZE  50 OF oDbf
      FIELD NAME "lUndNeg"    TYPE "L" LEN 01  DEC 0 COMMENT "Lógico de unidades en negativo"   HIDE        OF oDbf
      FIELD NAME "cNumSer"    TYPE "C" LEN 30  DEC 0 COMMENT "Número de serie"                  HIDE        OF oDbf

      INDEX TO ( cFileName ) TAG "cNumOrd" ON "cSerOrd + Str( nNumOrd,9 ) + cSufOrd"            NODELETED   OF oDbf
      INDEX TO ( cFileName ) TAG "cCodArt" ON "cCodArt + cAlmOrd + cNumSer"                     NODELETED   OF oDbf
      INDEX TO ( cFileName ) TAG "cNumSer" ON "cNumSer"                                         NODELETED   OF oDbf
      INDEX TO ( cFileName ) TAG "nNumLin" ON "Str( nNumLin, 4 ) + cCodArt"                     NODELETED   OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//--------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive ) CLASS TDetSeriesProduccion

   local lOpen             := .t.
   local oBlock

   DEFAULT  lExclusive     := .f.

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf            := ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !lExclusive )

      ::bOnPreSaveDetail   := {|| ::SaveDetails() }

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      lOpen                := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpen
      ::CloseFiles()
   end if

RETURN ( lOpen )

//--------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TDetSeriesProduccion

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
      ::oDbf         := nil
   end if

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

      :nTotalUnidades   := ::oParent:oDetProduccion:nTotUnidades( ::oParent:oDetProduccion:oDbfVir )

      :oStock           := ::oParent:oStock

      ::oDbfVir:GetStatus()
      ::oDbfVir:OrdSetFocus( "nNumLin" )

      :uTmpSer          := ::oDbfVir

      :Resource()

      ::oDbfVir:SetStatus()

   end with

RETURN ( Self )

//--------------------------------------------------------------------------//