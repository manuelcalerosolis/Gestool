#ifndef __PDA__
   #include "FiveWin.Ch"
   #include "Menu.ch"
   #include "Report.ch"
   #include "Xbrowse.ch"
#else
   #include "FWCE.ch"
   REQUEST DBFCDX
#endif

#include "Factu.ch" 
#include "MesDbf.ch"

//--------------------------------------------------------------------------//

CLASS TDetOrdCar FROM TDet

   DATA cPath
   DATA oParent

   DATA oMenu

   DATA  cOldCodArt           INIT  ""

   DATA  oGetTotalUnidades
   DATA  nGetTotalUnidades    INIT 0
   DATA  oGetTotPes
   DATA  nGetTotPes           INIT 0

   DATA  oGetArt
   DATA  oNomArt
   DATA  oGetCaj
   DATA  oGetUni
   DATA  oGetPeso
   DATA  oUndPeso
   DATA  oLote
   DATA  oSayPr1
   DATA  oValPr1
   DATA  oSayVp1
   DATA  oSayPr2
   DATA  oValPr2
   DATA  oSayVp2
   DATA  oSayLote
   DATA  oDbfDetalle

   METHOD New()

   METHOD DefineFiles()

   METHOD OpenFiles( lExclusive )

   METHOD Resource( nMode, lLiteral )

   METHOD SaveDetails()

   METHOD lPreSave( oDlg )

   METHOD LoaArticulo()

#ifndef __PDA__

   METHOD EdtRotor( oDlg )

   METHOD lTotUnidades()

   METHOD lTotPeso()

   METHOD nTotPeso( oDbf )

#endif

   METHOD nTotUnidades( oDbf )

   METHOD SetDialogMode( nMode )

END CLASS

//--------------------------------------------------------------------------//

METHOD New( cPath, oParent )

   DEFAULT cPath        := cPatEmp()
   DEFAULT oParent      := oWnd()

   ::cPath              := cPath
   ::oParent            := oParent

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cVia, lUniqueName, cFileName )

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT cVia         := cDriver()
   DEFAULT lUniqueName  := .f.
   DEFAULT cFileName    := "OrdCarL"

   if lUniqueName
      cFileName         := cGetNewFileName( cFileName, , , cPath )
   end if

   DEFINE TABLE oDbf FILE ( cFileName ) CLASS ( cFileName ) ALIAS ( cFileName ) PATH ( cPath ) VIA ( cVia ) COMMENT "Materiales producidos"

      FIELD NAME "NNUMORD"    TYPE "N" LEN   9 DEC  0 COMMENT "Número del orden de carga"          OF oDbf
      FIELD NAME "CSUFORD"    TYPE "C" LEN   2 DEC  0 COMMENT "Sufijo del orden de carga"          OF oDbf
      FIELD NAME "CREF"       TYPE "C" LEN  18 DEC  0 COMMENT "Referencia de artículo"             OF oDbf
      FIELD NAME "CDETALLE"   TYPE "C" LEN 240 DEC  0 COMMENT "Detalle de artículo"                OF oDbf
      FIELD NAME "CCODPR1"    TYPE "C" LEN  20 DEC  0 COMMENT "Código de primera propiedad"        OF oDbf
      FIELD NAME "CCODPR2"    TYPE "C" LEN  20 DEC  0 COMMENT "Código de segunda propiedad"        OF oDbf
      FIELD NAME "CVALPR1"    TYPE "C" LEN  20 DEC  0 COMMENT "Valor de primera propiedad"         OF oDbf
      FIELD NAME "CVALPR2"    TYPE "C" LEN  20 DEC  0 COMMENT "Valor de segunda propiedad"         OF oDbf
      FIELD NAME "LLOTE"      TYPE "L" LEN   1 DEC  0 COMMENT "Lógico de lote"                     OF oDbf
      FIELD NAME "cLote"      TYPE "C" LEN  14 DEC  0 COMMENT "Número de lote"                     OF oDbf
      FIELD NAME "NCAJORD"    TYPE "N" LEN  16 DEC  6 COMMENT cNombreCajas()                       OF oDbf
      FIELD NAME "NUNIORD"    TYPE "N" LEN  16 DEC  6 COMMENT cNombreUnidades()                    OF oDbf
      FIELD NAME "NPESO"      TYPE "N" LEN  16 DEC  6 COMMENT "Peso del artículo"                  OF oDbf
      FIELD NAME "CUNDPES"    TYPE "C" LEN   2 DEC  0 COMMENT "Unidad del peso"                    OF oDbf
      FIELD NAME "CNUMALB"    TYPE "C" LEN  12 DEC  0 COMMENT "Número de albarán"                  OF oDbf

      INDEX TO ( cFileName ) TAG "NNUMORD"      ON  "Str( NNUMORD ) + CSUFORD"         NODELETED   OF oDbf
      INDEX TO ( cFileName ) TAG "CREF"         ON  "CREF"                             NODELETED   OF oDbf
      INDEX TO ( cFileName ) TAG "CLOTE"        ON  "CLOTE"                            NODELETED   OF oDbf

   END DATABASE oDbf

   ::oDbfDetalle  := oDbf

RETURN ( oDbf )

//--------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive )

   local lOpen             := .t.
   local oError
   local oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT  lExclusive     := .f.

   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf            := ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !lExclusive )

      ::bOnPreSaveDetail   := {|| ::SaveDetails() }

#ifndef __PDA__

      ::bOnPostAppend      := {|| ::oParent:nPesOrdVir() }
      ::bOnPostEdit        := {|| ::oParent:nPesOrdVir() }
      ::bOnPostDelete      := {|| ::oParent:nPesOrdVir() }

#endif

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

      lOpen                := .f.

      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//--------------------------------------------------------------------------//

#ifndef __PDA__

METHOD Resource( nMode )

   local oDlg
   local cSayPr1        := ""
   local cSayVp1        := ""
   local cSayPr2        := ""
   local cSayVp2        := ""

   ::cOldCodArt         := ::oDbfVir:cRef

   if nMode == APPD_MODE
      ::oDbfVir:nCajOrd := 1
      ::oDbfVir:nUniOrd := 1
   else

      cSayVp1           :=  oRetFld( ::oDbfVir:cCodPr1 + ::oDbfVir:cValPr1, ::oParent:oTblPro, "cDesTbl" )
      cSayVp2           :=  oRetFld( ::oDbfVir:cCodPr2 + ::oDbfVir:cValPr2, ::oParent:oTblPro, "cDesTbl" )

   end if

   ::nGetTotalUnidades  := ::nTotUnidades( ::oDbfVir )
   ::nGetTotPes         := ::nTotPeso( ::oDbfVir )

   DEFINE DIALOG oDlg RESOURCE "LORDENCARGA" TITLE LblTitle( nMode ) + "linea de orden de carga"

      /*
      Código y descripción-----------------------------------------------------
      */

      REDEFINE GET ::oGetArt VAR ::oDbfVir:cRef;
         ID       110 ;
         WHEN     ( nMode == APPD_MODE );
         BITMAP   "LUPA" ;
         OF       oDlg

      ::oGetArt:bValid := {|| ::LoaArticulo() }
      ::oGetArt:bHelp  := {|| BrwArticulo( ::oGetArt, ::oNomArt ), ::LoaArticulo() }

      REDEFINE GET ::oNomArt VAR ::oDbfVir:cDetalle ;
         ID       111 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      /*
      Lote---------------------------------------------------------------------
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
         ::oValPr1:bHelp  := {|| brwPropiedadActual( ::oValPr1, ::oSayVp1, ::oDbfVir:cCodPr1 ) }

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
         ::oValPr2:bHelp  := {|| brwPropiedadActual( ::oValPr2, ::oSayVp2, ::oDbfVir:cCodPr2 ) }

      REDEFINE GET ::oSayVp2 VAR cSayVp2;
         ID       232 ;
         WHEN     .f. ;
         COLOR    CLR_GET ;
         OF       oDlg

      /*
      Unidades y cajas---------------------------------------------------------
      */

      REDEFINE GET ::oGetCaj VAR ::oDbfVir:nCajOrd;
         ID       120 ;
         IDSAY    121 ;
			SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  ::oParent:cPicUnd ;
         OF       oDlg

      ::oGetCaj:bChange   := {|| ::lTotUnidades( ::oDbfVir ), ::lTotPeso( ::oDbfVir ) }
      ::oGetCaj:bValid    := {|| ::lTotUnidades( ::oDbfVir ), ::lTotPeso( ::oDbfVir ) }

      REDEFINE GET ::oGetUni VAR ::oDbfVir:nUniOrd;
         ID       130;
			SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  ::oParent:cPicUnd ;
         OF       oDlg

      ::oGetUni:bChange   := {|| ::lTotUnidades( ::oDbfVir ), ::lTotPeso( ::oDbfVir ) }
      ::oGetUni:bValid    := {|| ::lTotUnidades( ::oDbfVir ), ::lTotPeso( ::oDbfVir ) }

      REDEFINE GET ::oGetTotalUnidades VAR ::nGetTotalUnidades ;
         ID       140;
         WHEN     ( .f. ) ;
         PICTURE  ::oParent:cPicUnd ;
         OF       oDlg

      /*
      Pesos--------------------------------------------------------------------
      */

      REDEFINE GET ::oGetPeso VAR ::oDbfVir:nPeso ;
         ID       170;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  ::oParent:cPicUnd ;
         OF       oDlg

      ::oGetPeso:bChange   := {|| ::lTotPeso( ::oDbfVir ) }
      ::oGetPeso:bValid    := {|| ::lTotPeso( ::oDbfVir ) }

      REDEFINE GET ::oUndPeso VAR ::oDbfVir:cUndPes ;
         ID       171;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oGetTotPes VAR ::nGetTotPes ;
         ID       172;
         WHEN     ( .f. ) ;
         PICTURE  ::oParent:cPicUnd ;
         OF       oDlg

      /*
      Botones aceptar y cancelar-----------------------------------------------
      */

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::lPreSave( nMode, oDlg ) )

      REDEFINE BUTTON ;
         ID       550 ;
         OF       oDlg ;
         ACTION   ( oDlg:End() )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F5, {|| ::lPreSave( nMode, oDlg ) } )
      end if

   oDlg:bStart    := {|| ::EdtRotor( oDlg ), ::SetDialogMode( nMode ) }

   ACTIVATE DIALOG oDlg CENTER

   ::oMenu:End()

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

#else

METHOD Resource( nMode )

   local oDlg
   local oCodArt
   local oNomArt
   local oThis          := Self
   local cSayPr1        := ""
   local cSayVp1        := oRetFld( ::oDbfVir:cCodPr1 + ::oDbfVir:cValPr1, ::oParent:oTblPro, "cDesTbl" )
   local cSayPr2        := ""
   local cSayVp2        := oRetFld( ::oDbfVir:cCodPr2 + ::oDbfVir:cValPr2, ::oParent:oTblPro, "cDesTbl" )
   local oTotUnd
   local nTotUnd        := ::nTotUnidades( ::oDbfVir )

   DEFINE DIALOG oDlg RESOURCE "LINORDCAR_PDA"

      REDEFINE GET oCodArt VAR ::oDbfVir:cRef ;
         ID       120 ;
         WHEN     ( nMode == APPD_MODE ) ;
         BITMAP   "LUPA" ;
         VALID    ( .t. ) ;
         OF       oDlg

         //oCodArt:bValid := {|| loaart }
         oCodArt:bHelp  := {|| BrwArticulo( oCodArt, oNomArt ) }

      REDEFINE GET oNomArt VAR ::oDbfVir:cDetalle ;
         ID       130 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oLote VAR ::oDbfVir:cLote ;
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE SAY ::oSayLote ;
         ID       141 ;
         OF       oDlg

      ::oSayLote:SetColor( 0, nRGB( 255, 255, 255 )  )

      REDEFINE SAY ::oSayPr1 VAR cSayPr1;
         ID       152 ;
         OF       oDlg

      ::oSayPr1:SetColor( 0, nRGB( 255, 255, 255 )  )

      REDEFINE GET ::oValPr1 VAR ::oDbfVir:cValPr1;
         ID       150 ;
			COLOR 	CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oSayVp1 VAR cSayVp1;
         ID       151 ;
         WHEN     .f. ;
         OF       oDlg

      REDEFINE SAY ::oSayPr2 VAR cSayPr2;
         ID       162 ;
         OF       oDlg

      ::oSayPr2:SetColor( 0, nRGB( 255, 255, 255 )  )

      REDEFINE GET ::oValPr2 VAR ::oDbfVir:cValPr2;
         ID       160 ;
			COLOR 	CLR_GET ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oSayVp2 VAR cSayVp2;
         ID       161 ;
         WHEN     .f. ;
         OF       oDlg

      REDEFINE GET ::oDbfVir:nCajOrd ;
         ID       170 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  MasUnd() ;
         OF       oDlg

      REDEFINE GET ::oDbfVir:nUniOrd ;
         ID       180 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  MasUnd() ;
         OF       oDlg

      REDEFINE GET oTotUnd VAR nTotUnd ;
         ID       190 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  MasUnd() ;
         OF       oDlg

      oDlg:bStart    := {|| ::SetDialogMode( nMode ) }

   ACTIVATE DIALOG oDlg ON INIT( oDlg:SetMenu( pdaMenuLinea( oDlg, oThis ) ) )

      // Restauramos la ventana---------------------------------------------------

   oWnd():Show()

RETURN ( .t. )

//---------------------------------------------------------------------------//

static function pdaMenuLinea( oDlg, oThis )

   local oMenu

   DEFINE MENU oMenu ;
      RESOURCE 100 ;
      BITMAPS  10 ; // bitmaps resoruces ID
      IMAGES   3     // number of images in the bitmap

      REDEFINE MENUITEM ID 110 OF oMenu ACTION ( oDlg:End( IDOK ) )

      REDEFINE MENUITEM ID 120 OF oMenu ACTION ( oDlg:End( IDCANCEL ) )

   oDlg:SetMenu( oMenu )

Return oMenu

#endif

//----------------------------------------------------------------------------//


METHOD SaveDetails()

   ::oDbfVir:nNumOrd  := ::oParent:oDbf:nNumOrd
   ::oDbfVir:cSufOrd  := ::oParent:oDbf:cSufOrd

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD lPreSave( nMode, oDlg )

   if nMode == APPD_MODE

      if Empty( ::oDbfVir:cRef )
         MsgStop( "El código de artículo no puede estar vacío." )
         ::oGetArt:SetFocus()
         Return .f.
      end if

   end if

   if Empty( ::oDbfVir:cDetalle )
      MsgStop( "La descripción de artículo no puede estar vacío." )
      ::oNomArt:SetFocus()
      Return .f.
   end if

RETURN oDlg:end( IDOK )

//---------------------------------------------------------------------------//

METHOD SetDialogMode( nMode )

#ifndef _PDA__

   if !lUseCaj()
      ::oGetCaj:Hide()
   end if

#endif

   if nMode == APPD_MODE

      ::oLote:Hide()

      #ifdef __PDA__
         ::oSayLote:Hide()
      #endif

      ::oSayPr1:Hide()
      ::oValPr1:Hide()
      ::oSayVp1:Hide()

      ::oSayPr2:Hide()
      ::oValPr2:Hide()
      ::oSayVp2:Hide()

   else

      if ::oDbfVir:lLote

         ::oLote:Show()

         #ifdef __PDA__
            ::oSayLote:Show()
         #endif

      else

         ::oLote:Hide()

         #ifdef __PDA__
            ::oSayLote:Hide()
         #endif

      end if

      if !Empty( ::oDbfVir:cCodPr1 )
         ::oSayPr1:Show()
         ::oSayPr1:SetText( retProp( ::oDbfVir:cCodPr1, ::oParent:oDbfPro:cAlias ) )
         ::oValPr1:Show()
         ::oSayVp1:Show()
      else
         ::oSayPr1:Hide()
         ::oValPr1:Hide()
         ::oSayVp1:Hide()
      end if

      if !Empty( ::oDbfVir:cCodPr2 )
         ::oSayPr2:Show()
         ::oSayPr2:SetText( retProp( ::oDbfVir:cCodPr2, ::oParent:oDbfPro:cAlias ) )
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

METHOD LoaArticulo()

   local cCodArt     := ::oGetArt:VarGet()
   local lChgCodArt  := ( Empty( ::cOldCodArt ) .or. Rtrim( ::cOldCodArt ) != Rtrim( cCodArt ) )
   local nOrdAnt

   nOrdAnt                    := ::oParent:oDbfArt:ordSetFocus( "Codigo" )

   if ::oParent:oDbfArt:Seek( cCodArt ) .or. ::oParent:oDbfArt:Seek( Upper( cCodArt ) )

      cCodArt                 := ::oParent:oDbfArt:Codigo

      if lChgCodArt

         ::oNomArt:cText( ::oParent:oDbfArt:Nombre )

         if ::oParent:oDbfArt:nCajEnt != 0
            ::oGetCaj:cText( ::oParent:oDbfArt:nCajEnt )
         end if

         if ::oParent:oDbfArt:nUniCaja != 0
            ::oGetUni:cText( ::oParent:oDbfArt:nUniCaja )
         end if

         ::oGetPeso:cText( ::oParent:oDbfArt:nPesoKg )
         ::oUndPeso:cText( ::oParent:oDbfArt:cUndDim )

         if ::oParent:oDbfArt:lLote
            ::oLote:Show()
            ::oLote:cText( ::oParent:oDbfArt:cLote )
            ::oDbfVir:lLote   := ::oParent:oDbfArt:lLote
         else
            ::oLote:Hide()
         end if

      end if

      ::lTotUnidades( ::oDbfVir )
      ::lTotPeso( ::oDbfVir )

      if ::oParent:oDbfFam:Seek( ::oParent:oDbfArt:Familia )
         ::oDbfVir:cCodPr1 := ::oParent:oDbfFam:cCodPrp1
         ::oDbfVir:cCodPr2 := ::oParent:oDbfFam:cCodPrp2
      else
         ::oDbfVir:cCodPr1 := Space( 20 )
         ::oDbfVir:cCodPr2 := Space( 20 )
      end if

#ifndef __PDA__

      if !Empty( ::oDbfVir:cCodPr1 )
         ::oSayPr1:Show()
         ::oSayPr1:SetText( retProp( ::oDbfVir:cCodPr1, ::oParent:oDbfPro:cAlias ) )
         ::oValPr1:Show()
         ::oSayVp1:Show()
      else
         ::oSayPr1:Hide()
         ::oValPr1:Hide()
         ::oSayVp1:Hide()
      end if

      if !Empty( ::oDbfVir:cCodPr2 )
         ::oSayPr2:Show()
         ::oSayPr2:SetText( retProp( ::oDbfVir:cCodPr2, ::oParent:oDbfPro:cAlias ) )
         ::oValPr2:Show()
         ::oSayVp2:Show()
      else
         ::oSayPr2:Hide()
         ::oValPr2:Hide()
         ::oSayVp2:Hide()
      end if

#endif

   end if

   ::cOldCodArt   := cCodArt

   ::oParent:oDbfArt:ordSetFocus( nOrdAnt )

RETURN .t.

//---------------------------------------------------------------------------//

#ifndef __PDA__

METHOD EdtRotor( oDlg )

   local cCodArt  := ::oGetArt:VarGet()

   MENU ::oMenu

      MENUITEM    "&1. Rotor"

         MENU

            MENUITEM    "&1. Modificar de artículo";
               MESSAGE  "Modificar la ficha del artículo" ;
               RESOURCE "gc_object_cube_16";
               ACTION   ( if( !Empty( cCodArt ), EdtArticulo( cCodArt ), MsgStop( "Debe de seleccionar un artículo" ) ) );

            MENUITEM    "&2. Informe de artículo";
               MESSAGE  "Abrir el informe del artículo" ;
               RESOURCE "Info16";
               ACTION   ( if( !Empty( cCodArt ), InfArticulo( cCodArt ), MsgStop( "Debe de seleccionar un artículo" ) ) );

         ENDMENU

   ENDMENU

   oDlg:SetMenu( ::oMenu )

RETURN ( ::oMenu )

//---------------------------------------------------------------------------//

METHOD lTotUnidades( oDbf )

   DEFAULT oDbf   := ::oDbf

RETURN ( ::oGetTotalUnidades:cText( ::nTotUnidades( oDbf ) ), .t. )

//---------------------------------------------------------------------------//

METHOD nTotPeso( oDbf )

   DEFAULT oDbf   := ::oDbf

RETURN ( ::nTotUnidades( oDbf ) * oDbf:nPeso )

//---------------------------------------------------------------------------//

METHOD lTotPeso( oDbf )

   DEFAULT oDbf   := ::oDbf

RETURN ( ::oGetTotPes:cText( ::nTotPeso( oDbf ) ), .t. )

#endif

//---------------------------------------------------------------------------//

METHOD nTotUnidades( oDbf )

   DEFAULT oDbf   := ::oDbf

RETURN ( NotCaja( oDbf:nCajOrd ) * oDbf:nUniOrd )

//---------------------------------------------------------------------------//

Function nTotOrdCar( dbf )

RETURN ( NotCaja( ( dbf )->nCajOrd ) * ( dbf )->nUniOrd )

//---------------------------------------------------------------------------//