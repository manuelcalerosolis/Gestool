#include "FiveWin.Ch"
#include "Factu.ch"
#include "Menu.ch"
#include "Report.ch"
#include "MesDbf.ch"
#include "Xbrowse.ch"

//--------------------------------------------------------------------------//

CLASS TDetMaterial FROM TDetalleArticulos

   DATA  oGetCaja
   DATA  oGetUnidades
   DATA  oGetPrecio
   DATA  oLote
   DATA  oSayPr1
   DATA  oSayPr2
   DATA  oValPr1
   DATA  oValPr2
   DATA  oSayVp1
   DATA  oSayVp2
   DATA  cOldCodArt           INIT  ""
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
   METHOD nTotVolumen( oDbf )
   METHOD lTotPeso( oDbf )
   METHOD lTotVolumen( oDbf )
   METHOD lStkAct()

   METHOD EdtRotor( oDlg )

END CLASS

//--------------------------------------------------------------------------//

METHOD New( cPath, oParent ) 

   DEFAULT cPath        := cPatEmp()

   ::cPath              := cPath
   ::oParent            := oParent

   ::bOnPreSaveDetail   := {|| ::SaveDetails() }
   ::bOnPreDelete       := {|| ::DeleteDetails() }

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
      FIELD NAME "cCodPr1"    TYPE "C" LEN 20  DEC 0 COMMENT "Código de primera propiedad"   COLSIZE  80 OF oDbf
      FIELD NAME "cCodPr2"    TYPE "C" LEN 20  DEC 0 COMMENT "Código de segunda propiedad"   COLSIZE  80 OF oDbf
      FIELD NAME "cValPr1"    TYPE "C" LEN 20  DEC 0 COMMENT "Valor de primera propiedad"    COLSIZE  80 OF oDbf
      FIELD NAME "cValPr2"    TYPE "C" LEN 20  DEC 0 COMMENT "Valor de segunda propiedad"    COLSIZE  80 OF oDbf
      FIELD NAME "lLote"      TYPE "L" LEN  1  DEC 0 COMMENT "Lógico lote"                   COLSIZE  80 OF oDbf
      FIELD NAME "cLote"      TYPE "C" LEN 12  DEC 0 COMMENT "Lote"                          COLSIZE  80 OF oDbf
      FIELD NAME "cCodPro"    TYPE "C" LEN 18  DEC 0 COMMENT "Código del artídulo producido" COLSIZE  80 OF oDbf
      FIELD NAME "dFecOrd"    TYPE "D" LEN 08  DEC 0 COMMENT "Fecha"                         HIDE        OF oDbf
      FIELD NAME "nTipArt"    TYPE "N" LEN  1  DEC 0 COMMENT ""                              HIDE        OF oDbf              

      ::CommunFields( oDbf )

      INDEX TO ( cFileName )  TAG "cNumOrd" ON "cSerOrd + Str( nNumOrd, 9 ) + cSufOrd"       NODELETED OF oDbf
      INDEX TO ( cFileName )  TAG "cCodPro" ON "cCodPro"                                     NODELETED OF oDbf
      INDEX TO ( cFileName )  TAG "cCodArt" ON "cCodArt"                                     NODELETED OF oDbf
      INDEX TO ( cFileName )  TAG "nNumLin" ON "Str( nNumLin, 4 )"                           NODELETED OF oDbf
      INDEX TO ( cFileName )  TAG "cLote"   ON "cLote"                                       NODELETED OF oDbf

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

   local oDlg
   local oFld 
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
      ::nStkAct         := ::oParent:oStock:nStockActual( ::oDbfVir:cCodArt, ::oDbfVir:cAlmOrd )
   else
      ::nStkAct         := 0
   end if

   ::nGetTotalUnidades  := ::nTotUnidades( ::oDbfVir )
   ::nGetTotalPrecio    := ::nTotPrecio( ::oDbfVir )
   ::nGetTotPes         := ::nTotPeso( ::oDbfVir )
   ::nGetTotVol         := ::nTotVolumen( ::oDbfVir )

   cSayAlm              := RetAlmacen( ::oDbfVir:cAlmOrd, ::oParent:oAlm )

   DEFINE DIALOG  oDlg ;
      RESOURCE    "LProducido" ;
      TITLE       LblTitle( nMode ) + "articulos producidos"
      
      REDEFINE FOLDER oFld ;
         ID       400 ;
         OF       oDlg ;
         PROMPT   "&Artículo",;
                  "Da&tos" ;
         DIALOGS  "LProducido_1",;
                  "LProducido_2"

      /*
      Codigo de articulo-------------------------------------------------------
      */

      REDEFINE GET oGetArt VAR ::oDbfVir:cCodArt;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE );
         BITMAP   "LUPA" ;
         OF       oFld:aDialogs[1]

      oGetArt:bValid := {|| ::LoaArticulo( oGetArt, oGetNom ) }
      oGetArt:bHelp  := {|| BrwArticulo( oGetArt, oGetNom ) }

      REDEFINE GET oGetNom VAR ::oDbfVir:cNomArt ;
         ID       111 ;
         WHEN     ( lModDes() .and. nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      /*
      Lotes-------------------------------------------------------------------
      */

      REDEFINE GET ::oLote VAR ::oDbfVir:cLote;
         ID       210 ;
         IDSAY    211 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

       /*
      Propiedades--------------------------------------------------------------
      */

      REDEFINE SAY ::oSayPr1 VAR cSayPr1;
         ID       221 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET ::oValPr1 VAR ::oDbfVir:cValPr1;
         ID       220 ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

         ::oValPr1:bValid := {|| lPrpAct( ::oDbfVir:cValPr1, ::oSayVp1, ::oDbfVir:cCodPr1, ::oParent:oTblPro:cAlias ) }
         ::oValPr1:bHelp  := {|| brwPrpAct( ::oValPr1, ::oSayVp1, ::oDbfVir:cCodPr1 ) }

      REDEFINE GET ::oSayVp1 VAR cSayVp1;
         ID       222 ;
         WHEN     .f. ;
         COLOR    CLR_GET ;
         OF       oFld:aDialogs[1]

      REDEFINE SAY ::oSayPr2 VAR cSayPr2;
         ID       231 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET ::oValPr2 VAR ::oDbfVir:cValPr2;
         ID       230 ;
			COLOR 	CLR_GET ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

         ::oValPr2:bValid := {|| lPrpAct( ::oDbfVir:cValPr2, ::oSayVp2, ::oDbfVir:cCodPr2, ::oParent:oTblPro:cAlias ) }
         ::oValPr2:bHelp  := {|| brwPrpAct( ::oValPr2, ::oSayVp2, ::oDbfVir:cCodPr2 ) }

      REDEFINE GET ::oSayVp2 VAR cSayVp2;
         ID       232 ;
         WHEN     .f. ;
         OF       oFld:aDialogs[1]

      /*
      Cajas y unidades---------------------------------------------------------
      */

      REDEFINE GET ::oGetCaja VAR ::oDbfVir:nCajOrd ;
         ID       120;
			SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  ::oParent:cPicUnd ;
         OF       oFld:aDialogs[1]

      ::oGetCaja:bChange   := {|| ::lTotUnidades( ::oDbfVir ), ::lTotPrecio( ::oDbfVir ), ::lTotPeso( ::oDbfVir ), ::lTotVolumen( ::oDbfVir ) }
      ::oGetCaja:bValid    := {|| ::lTotUnidades( ::oDbfVir ), ::lTotPrecio( ::oDbfVir ), ::lTotPeso( ::oDbfVir ), ::lTotVolumen( ::oDbfVir ) }

      REDEFINE GET ::oGetUnidades VAR ::oDbfVir:nUndOrd ;
         ID       130;
			SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  ::oParent:cPicUnd ;
         OF       oFld:aDialogs[1]

      ::oGetUnidades:bChange  := {|| ::lTotUnidades( ::oDbfVir ), ::lTotPrecio( ::oDbfVir ), ::lTotPeso( ::oDbfVir ), ::lTotVolumen( ::oDbfVir ) }
      ::oGetUnidades:bValid   := {|| ::lTotUnidades( ::oDbfVir ), ::lTotPrecio( ::oDbfVir ), ::lTotPeso( ::oDbfVir ), ::lTotVolumen( ::oDbfVir ) }

      REDEFINE GET ::oGetTotalUnidades VAR ::nGetTotalUnidades ;
         ID       140;
         WHEN     ( .f. ) ;
         PICTURE  ::oParent:cPicUnd ;
         OF       oFld:aDialogs[1]

      REDEFINE GET ::oGetPrecio VAR ::oDbfVir:nImpOrd ;
         ID       150;
			SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  ::oParent:cPouDiv ;
         OF       oFld:aDialogs[1]

      ::oGetPrecio:bChange := {|| ::lTotPrecio( ::oDbfVir ) }
      ::oGetPrecio:bChange := {|| ::lTotPrecio( ::oDbfVir ) }

      REDEFINE GET ::oGetTotalPrecio VAR ::nGetTotalPrecio ;
         ID       160;
         WHEN     ( .f. ) ;
         PICTURE  ::oParent:cPorDiv ;
         OF       oFld:aDialogs[1]

      /*
      Pesos--------------------------------------------------------------------
      */

      REDEFINE GET ::oGetPes VAR ::oDbfVir:nPeso ;
         ID       170;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

      ::oGetPes:bChange   := {|| ::lTotPeso( ::oDbfVir ) }
      ::oGetPes:bValid    := {|| ::lTotPeso( ::oDbfVir ) }

      REDEFINE GET ::oGetUndPes VAR ::oDbfVir:cUndPes ;
         ID       171;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET ::oGetTotPes VAR ::nGetTotPes ;
         ID       172;
         WHEN     ( .f. ) ;
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

      /*
      Volumen------------------------------------------------------------------
      */

      REDEFINE GET ::oGetVol VAR ::oDbfVir:nVolumen ;
         ID       180;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

      ::oGetVol:bChange   := {|| ::lTotVolumen( ::oDbfVir ) }
      ::oGetVol:bValid    := {|| ::lTotVolumen( ::oDbfVir ) }

      REDEFINE GET ::oGetUndVol VAR ::oDbfVir:cUndVol ;
         ID       181;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

      REDEFINE GET ::oGetTotVol VAR ::nGetTotVol ;
         ID       182;
         WHEN     ( .f. ) ;
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

      /*
      Código de almacen--------------------------------------------------------
      */

      REDEFINE GET oGetAlm VAR ::oDbfVir:cAlmOrd;
         ID       190 ;
         WHEN     ( nMode != ZOOM_MODE );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( oGetAlm, oSayAlm ) ) ;
         OF       oFld:aDialogs[1]

      oGetAlm:bChange   := {|| ::lStkAct() }
      oGetAlm:bValid    := {|| cAlmacen( oGetAlm, ::oParent:oAlm, oSayAlm ), ::lStkAct() }

      REDEFINE GET oSayAlm VAR cSayAlm ;
         ID       191 ;
         WHEN     ( .f. ) ;
         OF       oFld:aDialogs[1]

      /*
      Stock Actual-------------------------------------------------------------
      */

      REDEFINE GET ::oStkAct VAR ::nStkAct ;
         ID       200 ;
         WHEN     .f. ;
         PICTURE  MasUnd() ;
         OF       oFld:aDialogs[1]

      /*
      Pestaña de datos---------------------------------------------------------
      */

      ::LoadPropiedadesArticulos( oFld:aDialogs[ 2 ], nMode )

      /*
      Botones globales a toda la caja de dailogo-------------------------------
      */

      REDEFINE BUTTON oBtnSer ;
         ID       3 ;
         OF       oDlg ;
         ACTION   ( nil )

      oBtnSer:bAction   := {|| ::oParent:oDetSeriesMaterial:Resource( nMode ) }

      REDEFINE BUTTON oBtnAtras ;
         ID       4 ;
         OF       oDlg ;
         ACTION   ( if( oFld:nOption > 1, oFld:SetOption( oFld:nOption - 1 ), ) )

      REDEFINE BUTTON oBtnAdelante ;
         ID       5 ;
         OF       oDlg ;
         ACTION   ( if( oFld:nOption < Len( oFld:aDialogs ), oFld:SetOption( oFld:nOption + 1 ), ) )

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::SaveResource( oGetArt, oDlg ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
			ACTION 	( oDlg:end() )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F6, {|| oBtnSer:Click() } )
         oDlg:AddFastKey( VK_F5, {|| ::SaveResource( oGetArt, oDlg ) } )
         oDlg:AddFastKey( VK_F7, {|| oBtnAtras:Click() } )
         oDlg:AddFastKey( VK_F8, {|| oBtnAdelante:Click() } )
      end if

      oDlg:bStart := {|| ::EdtRotor( oDlg ), ::SetResource( nMode ) }

   ACTIVATE DIALOG oDlg CENTER

   ::oMenu:End()

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

METHOD SetResource( nMode )

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

   ::oClasificacionArticulo:SetNumber( ::oDbfVir:nTipArt )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD LoaArticulo( oGetArticulo, oGetNombre )

   local cCodArt  := oGetArticulo:VarGet()
   local lChgCodArt  := ( Empty( ::cOldCodArt ) .or. Rtrim( ::cOldCodArt ) != Rtrim( cCodArt ) )

   if Empty( cCodArt )

      if lRetCodArt()
         MsgStop( "No se pueden añadir lineas sin codificar" )
         return .f.
      end if

      return .t.

   else

      /*
      Primero buscamos por codigos de barra
      */

      ::oParent:oArt:ordSetFocus( "CodeBar" )

      if ::oParent:oArt:Seek( cCodArt )
         cCodArt  := ::oParent:oArt:Codigo
      end if

      ::oParent:oArt:ordSetFocus( "Codigo" )

      /*
      Ahora buscamos por el codigo interno
      */

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
               ::oGetUnidades:cText( ::oParent:oArt:nUniCaja )
            end if

            if Empty( ::oDbf:nImpOrd )
               ::oGetPrecio:cText( nPreMedCom( cCodArt, nil, ::oParent:oAlbPrvT:cAlias, ::oParent:oAlbPrvL:cAlias, ::oParent:oFacPrvT:cAlias, ::oParent:oFacPrvL:cAlias, ::oParent:oDbf:nVdvDiv, ::oParent:nDouDiv, ::oParent:nDorDiv, ::oParent:oHisMov:cAlias ) )
            end if

            if ::oParent:oArt:lLote
               ::oLote:Show()
               ::oLote:cText( ::oParent:oArt:cLote )
               ::oDbfVir:lLote   := ::oParent:oArt:lLote
            else
               ::oLote:Hide()
            end if

            ::oGetPes:cText(     ::oParent:oArt:nPesoKg )
            ::oGetUndPes:cText(  ::oParent:oArt:cUndDim )
            ::oGetVol:cText(     ::oParent:oArt:nVolumen )
            ::oGetUndVol:cText(  ::oParent:oArt:cVolumen )

            ::LoadCommunFields()

         end if

         ::lTotUnidades( ::oDbfVir )
         ::lTotPrecio( ::oDbfVir )
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

         ::cOldCodArt   := cCodArt

         return .t.

      else

         MsgStop( "Artículo no encontrado" )

         return .f.

      end if

   end if

RETURN .t.

//--------------------------------------------------------------------------//

METHOD nTotUnidades( oDbf )

   DEFAULT oDbf   := ::oDbf

RETURN ( if( !Empty( ::oParent:nDouDiv ), Round( NotCaja( oDbf:nCajOrd ) * oDbf:nUndOrd, ::oParent:nDouDiv ), ( NotCaja( oDbf:nCajOrd ) * oDbf:nUndOrd ) ) )

//--------------------------------------------------------------------------//

METHOD cTotUnidades( oDbf )

   DEFAULT oDbf   := ::oDbf

RETURN ( Trans( ::nTotUnidades( oDbf ), ::oParent:cPicUnd ) )

//--------------------------------------------------------------------------//

METHOD lTotUnidades( oDbf )

   DEFAULT oDbf   := ::oDbf

RETURN ( ::oGetTotalUnidades:cText( ::nTotUnidades( oDbf ) ), .t. )

//--------------------------------------------------------------------------//

METHOD nTotPrecio( oDbf )

   DEFAULT oDbf   := ::oDbf

RETURN ( Round( ::nTotUnidades( oDbf ) * oDbf:nImpOrd, ::oParent:nDorDiv ) )

//--------------------------------------------------------------------------//

METHOD cTotPrecio( oDbf )

   DEFAULT oDbf   := ::oDbf

RETURN ( Trans( ::nTotPrecio( oDbf ), ::oParent:cPorDiv ) )

//--------------------------------------------------------------------------//

METHOD lTotPrecio( oDbf )

   DEFAULT oDbf   := ::oDbf

RETURN ( ::oGetTotalPrecio:cText( ::nTotPrecio( oDbf ) ), .t. )

//--------------------------------------------------------------------------//

METHOD nTotal( oDbf )

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

METHOD cTotal( oDbf )

   DEFAULT oDbf   := ::oDbf

RETURN ( Trans( ::nTotal( oDbf ), ::oParent:cPorDiv ) )

//---------------------------------------------------------------------------//

METHOD lTotal( oDbf, oGet )

   DEFAULT oDbf   := ::oDbf

RETURN ( oGet:cText( ::nTotal( oDbf ) ), .t. )

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

RETURN ( Round( NotCaja( oDbf:nCajOrd ) * oDbf:nUndOrd, ::oParent:nDouDiv ) * oDbf:nPeso )

//---------------------------------------------------------------------------//

METHOD nTotVolumen( oDbf )

   DEFAULT oDbf   := ::oDbf

RETURN ( Round( NotCaja( oDbf:nCajOrd ) * oDbf:nUndOrd, ::oParent:nDouDiv ) * oDbf:nVolumen )

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

RETURN ( if( !uFieldEmpresa( "lNStkAct" ), ::oStkAct:cText( ::oParent:oStock:nStockActual( ::oDbfVir:cCodArt, ::oDbfVir:cAlmOrd ) ), ), .t. )

//---------------------------------------------------------------------------//

METHOD EdtRotor( oDlg )

   MENU ::oMenu

      MENUITEM    "&1. Rotor"

         MENU

            MENUITEM    "&1. Modificar artículo";
               MESSAGE  "Modificar la ficha del artículo" ;
               RESOURCE "Cube_Yellow_16";
               ACTION   ( if( Empty( ::oDbfVir:cCodArt ), msgStop( "No hay artículo seleccionado" ), EdtArticulo( ::oDbfVir:cCodArt ) ) );

            MENUITEM    "&2. Informe de artículo";
               MESSAGE  "Abrir el informe del artículo" ;
               RESOURCE "Info16";
               ACTION   ( if( Empty( ::oDbfVir:cCodArt ), msgStop( "No hay artículo seleccionado" ), InfArticulo( ::oDbfVir:cCodArt ) ) );

         ENDMENU

   ENDMENU

   oDlg:SetMenu( ::oMenu )

RETURN ( ::oMenu )

//---------------------------------------------------------------------------//

METHOD SaveResource( oGetArt, oDlg )

   if Empty( ::oDbfVir:cCodArt )
      MsgStop( "Tiene que seleccionar un artículo." )
      oGetArt:SetFocus()
      Return .f.
   end if

   ::oDbfVir:nTipArt    := ::oClasificacionArticulo:GetNumber()

   ::oParent:oTotProducido:Refresh()
   ::oParent:oTotMaterias:Refresh()
   ::oParent:oTotPersonal:Refresh()

RETURN oDlg:end( IDOK )

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

   METHOD OpenFiles( lExclusive )
   METHOD CloseFiles()

   MESSAGE OpenService( lExclusive )   METHOD OpenFiles( lExclusive )

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
      FIELD NAME "cAlmOrd"    TYPE "C" LEN 03  DEC 0 COMMENT "Almacén"                          COLSIZE  50 OF oDbf
      FIELD NAME "lUndNeg"    TYPE "L" LEN 01  DEC 0 COMMENT "Lógico de unidades en negativo"   HIDE        OF oDbf
      FIELD NAME "cNumSer"    TYPE "C" LEN 30  DEC 0 COMMENT "Número de serie"                  HIDE        OF oDbf

      INDEX TO ( cFileName ) TAG "cNumOrd" ON "cSerOrd + Str( nNumOrd ) + cSufOrd + Str( nNumLin )"   NODELETED   OF oDbf
      INDEX TO ( cFileName ) TAG "cCodArt" ON "cCodArt + cAlmOrd + cNumSer"                           NODELETED   OF oDbf
      INDEX TO ( cFileName ) TAG "cNumSer" ON "cNumSer"                                               NODELETED   OF oDbf
      INDEX TO ( cFileName ) TAG "nNumLin" ON "Str( nNumLin, 4 ) + cCodArt"                           NODELETED   OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//--------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath ) CLASS TDetSeriesMaterial

   local lOpen             := .t.
   local oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT  lExclusive     := .f.

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

METHOD CloseFiles() CLASS TDetSeriesMaterial

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
      ::oDbf         := nil
   end if

RETURN .t.

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

      :nTotalUnidades   := ::oParent:oDetMaterial:nTotUnidades( ::oParent:oDetMaterial:oDbfVir )

      :oStock           := ::oParent:oStock

      ::oDbfVir:GetStatus()
      ::oDbfVir:OrdSetFocus( "nNumLin" )

      :uTmpSer          := ::oDbfVir

      :Resource()

      ::oDbfVir:SetStatus()

   end with

RETURN ( Self )

//--------------------------------------------------------------------------//

Function Metro()

   local oWnd, oFont, oBrw, oFont2, oFont3
   local aItems   := {  {  "Wrench_48_alpha",            "General"               },;
                        {  "Preferences_Edit_48_alpha",  "Valores por defecto"   },;
                        {  "Cube_Yellow_Alpha_48",       "Artículos"             },;
                        {  "Document_Edit_48_alpha",     "Contadores y docs."    },;
                        {  "Folder2_red_Alpha_48",       "Contabilidad"          },;
                        {  "Satellite_dish_48_alpha",    "Envios"                },;
                        {  "Earth2_Alpha_48",            "Comunicaciones"        } }


   DEFINE FONT oFont NAME "Segoe UI Light" SIZE 0, -52

   DEFINE FONT oFont2 NAME "Segoe UI Light" SIZE 0, -30

   DEFINE FONT oFont3 NAME "Segoe UI Light" SIZE 0, -16

   DEFINE WINDOW oWnd STYLE nOr( WS_POPUP, WS_VISIBLE ) ;
      COLOR RGB( 170, 170, 170 ), CLR_WHITE

   @ 2, 10 SAY "Control Panel" FONT oFont SIZE 300, 100

   @ 2, 80 SAY "Personalize" FONT oFont SIZE 300, 100

   @ 10, 7  XBROWSE  oBrw ;
            ARRAY    aItems ;
            COLUMNS  {1,2} ;
            FONT     oFont2 ;
            SIZE     400, 650 ;
            NOBORDER ;
            OF       oWnd

   oBrw:nDataLines = 1
   oBrw:lRecordSelector = .F.
   oBrw:lHeader   = .F.
   oBrw:lHScroll  = .F.
   oBrw:lVScroll  = .F.
   oBrw:nStretchCol = 1

   oBrw:nMarqueeStyle := MARQSTYLE_HIGHLROWMS

   oBrw:bClrSel       := {|| { CLR_WHITE, RGB( 251, 140,  60 ) } }
   oBrw:bClrSelFocus  := {|| { CLR_WHITE, RGB( 251, 140,  60 ) } } // Rgb( 34, 177, 76 )


   oBrw:aCols[ 1 ]:nEditType       := TYPE_IMAGE
   oBrw:aCols[ 1 ]:lBmpStretch     := .f.
   oBrw:aCols[ 1 ]:lBmpTransparent := .t.
   oBrw:aCols[ 1 ]:nDataBmpAlign   := AL_LEFT
   oBrw:aCols[ 1 ]:nWidth          := 20
   oBrw:aCols[ 1 ]:bAlphaLevel     := {|| 255 }
   oBrw:aCols[ 1 ]:bStrData        := {|| oBrw:aRow[ 2 ] }
   oBrw:aCols[ 1 ]:bStrImage       := {|oCol, oBrw| oBrw:aRow[ 1 ] }

   oBrw:aCols[ 2 ]:bStrData        := {|| oBrw:aRow[ 2 ] }
   oBrw:aCols[ 2 ]:nWidth          := 280
 
   oBrw:CreateFromCode()

   oBrw:aCols[ 1 ]:bPaintText = { | oCol, hDC, cText, aCoors, aColors, lHighlight | DrawRow( oCol, hDC, cText, aCoors, oFont3 )  }

   oBrw:SetFocus()

   ACTIVATE WINDOW oWNd MAXIMIZED ;
      ON CLICK oWnd:End()

return nil

function DrawRow( oCol, hDC, cText, aCoors, oFont )

   local hOldFont
   local aItems := { "Customize your lock screen and user tile",;
                     "Change your account or add new ones",;
                     "Choose if apps notify you" }

   DrawText( hDC, cText, aCoors )
   aCoors[ 1 ] += 45
   hOldFont = SelectObject( hDC, oFont:hFont )
   DrawText( hDC, aItems[ oCol:oBrw:KeyNo ], aCoors )
   SelectObject( hDC, hOldFont )

return nil