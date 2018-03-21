#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Menu.ch"
#include "Report.ch"
#include "MesDbf.ch"

#define IDFOUND         3

#define _CCODFAC        1
#define _CCODART        2
#define _CDETALLE       3
#define _MLNGDES        4
#define _CCODPR1        5
#define _CCODPR2        6
#define _CVALPR1        7
#define _CVALPR2        8
#define _NCAJAS         9
#define _NUNIDADES     10
#define _NPREUNIT      11
#define _LKITART       12
#define _LKITCHL       13
#define _NIVA          14
#define _NNUMLIN       15
#define _LKITPRC       16
#define _LPRCATP       17

static oMenu

//--------------------------------------------------------------------------//

CLASS TDetFacAutomatica FROM TDet

   DATA oDbfArt
   DATA oDbfPro
   DATA oDbfTblPro
   DATA oDbfArtDiv
   DATA oDbfDiv
   DATA oDbfKit
   DATA oDbfIva
   DATA oDbfArtPrv
   DATA oDbfCodeBar

   DATA cOldCodArt
   DATA cOldPrpArt

   DATA oTotLin
   DATA nTotLin

   METHOD DefineFiles()

   METHOD OpenFiles( lExclusive )

   METHOD OpenService( lExclusive )

   METHOD CloseFiles()

   METHOD CloseService()

   METHOD Resource( nMode, lLiteral )

   METHOD SaveDetails()

   METHOD lPreSave( oDlg )

   METHOD SetDlgMode( aGet, nMode )

   METHOD lLoaArt( aGet )

   METHOD lCalcDeta()

   METHOD Descrip()

   METHOD nTotLFacAut()

   METHOD nTotNFacAut()

   METHOD AppendKit()

   METHOD AppendDet( oBrw )

   METHOD lChangePrcAtp( aGet )

END CLASS

//--------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cVia, lUniqueName, cFileName )

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT lUniqueName  := .f.
   DEFAULT cFileName    := "FacAutL"
   DEFAULT cVia         := cDriver()

   if lUniqueName
      cFileName         := cGetNewFileName( cFileName, , , cPath )
   end if

   DEFINE TABLE oDbf FILE ( cFileName ) CLASS ( cFileName ) ALIAS ( cFileName ) PATH ( cPath ) VIA ( cVia ) COMMENT "líneas de plantillas de ventas automáticas"

      FIELD NAME "cCodFac"   TYPE "C" LEN  03 DEC 0 COMMENT "Código"                            OF oDbf
      FIELD NAME "cCodArt"   TYPE "C" LEN  18 DEC 0 COMMENT "Código del artículo"               OF oDbf
      FIELD NAME "cDetalle"  TYPE "C" LEN 250 DEC 0 COMMENT "Detalle del artículo"              OF oDbf
      FIELD NAME "mLngDes"   TYPE "M" LEN  10 DEC 0 COMMENT "Descripción larga del artículo"    OF oDbf
      FIELD NAME "cCodPr1"   TYPE "C" LEN  20 DEC 0 COMMENT "Código de la primera propiedad"    OF oDbf
      FIELD NAME "cCodPr2"   TYPE "C" LEN  20 DEC 0 COMMENT "Código de la segunda propiedad"    OF oDbf
      FIELD NAME "cValPr1"   TYPE "C" LEN  20 DEC 0 COMMENT "Valor de la primera propiedad"     OF oDbf
      FIELD NAME "cValPr2"   TYPE "C" LEN  20 DEC 0 COMMENT "Valor de la segunda propiedad"     OF oDbf
      FIELD NAME "nCajas"    TYPE "N" LEN  16 DEC 6 COMMENT cNombreCajas()                      OF oDbf
      FIELD NAME "nUnidades" TYPE "N" LEN  16 DEC 6 COMMENT cNombreUnidades()                   OF oDbf
      FIELD NAME "nPreUnit"  TYPE "N" LEN  16 DEC 6 COMMENT "Precio unitario"                   OF oDbf
      FIELD NAME "lKitArt"   TYPE "L" LEN  01 DEC 0 COMMENT "Línea con escandallo"              OF oDbf
      FIELD NAME "lKitChl"   TYPE "L" LEN  01 DEC 0 COMMENT "Línea perteneciente a escandallo"  OF oDbf
      FIELD NAME "nIva"      TYPE "N" LEN  06 DEC 2 COMMENT "Porcentaje de " + cImp()           OF oDbf
      FIELD NAME "nNumLin"   TYPE "N" LEN  04 DEC 0 COMMENT "Número de línea"                   OF oDbf
      FIELD NAME "lKitPrc"   TYPE "L" LEN  01 DEC 0 COMMENT "Linea precios escandallo"          OF oDbf
      FIELD NAME "lPrcAtp"   TYPE "L" LEN  01 DEC 0 COMMENT "Buscar precios en las líneas"      OF oDbf

      INDEX TO ( cFileName ) TAG "cCodFac"   ON "cCodFac"                             NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cCodArt"   ON "cCodArt"                             NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "nNumLin"   ON "Str( nNumLin, 4 )"                   NODELETED OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//--------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive )

   local lOpen             := .t.
   local oError
   local oBlock

   DEFAULT  lExclusive     := .f.

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf            := ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !lExclusive )

      DATABASE NEW ::oDbfArt     PATH ( cPatArt() )   FILE "ARTICULO.DBF"     VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

      DATABASE NEW ::oDbfPro     PATH ( cPatArt() )   FILE "PRO.DBF"          VIA ( cDriver() ) SHARED INDEX "PRO.CDX"

      DATABASE NEW ::oDbfTblPro  PATH ( cPatArt() )   FILE "TBLPRO.DBF"       VIA ( cDriver() ) SHARED INDEX "TBLPRO.CDX"

      DATABASE NEW ::oDbfArtDiv  PATH ( cPatArt() )   FILE "ARTDIV.DBF"       VIA ( cDriver() ) SHARED INDEX "ARTDIV.CDX"

      DATABASE NEW ::oDbfDiv     PATH ( cPatDat() )   FILE "DIVISAS.DBF"      VIA ( cDriver() ) SHARED INDEX "DIVISAS.CDX"

      DATABASE NEW ::oDbfKit     PATH ( cPatArt() )   FILE "ARTKIT.DBF"       VIA ( cDriver() ) SHARED INDEX "ARTKIT.CDX"

      DATABASE NEW ::oDbfIva     PATH ( cPatDat() )   FILE "TIVA.DBF"         VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

      DATABASE NEW ::oDbfArtPrv  PATH ( cPatArt() )   FILE "PROVART.DBF"      VIA ( cDriver() ) SHARED INDEX "PROVART.CDX"

      DATABASE NEW ::oDbfCodeBar PATH ( cPatArt() )   FILE "ARTCODEBAR.DBF"   VIA ( cDriver() ) SHARED INDEX "ARTCODEBAR.CDX"

      ::bOnPreSaveDetail   := {|| ::SaveDetails() }

      ::bOnPreDelete       := {|| if( ::oDbfVir:lKitArt, ( ::oDbfVir:KillFilter(), DbDelKit( nil, ::oDbfVir:cAlias, ::oDbfVir:nNumLin ) ), ) }

   RECOVER USING oError

      msgStop( "Imposible abrir lineas de facturas automáticas" + CRLF + ErrorMessage( oError ) )

      lOpen                := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpen
      ::CloseFiles()
   end if

RETURN ( lOpen )

//--------------------------------------------------------------------------//

METHOD OpenService( lExclusive, cPath )

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lExclusive   := .f.

   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf         := ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !lExclusive )

   RECOVER USING oError
      
      lOpen             := .f.
      
      ::CloseService()

      msgStop( "Imposible abrir lineas de facturas automáticas" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   if ::oDbfArt != nil .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   if ::oDbfPro != nil .and. ::oDbfPro:Used()
      ::oDbfPro:End()
   end if

   if ::oDbfTblPro != nil .and. ::oDbfTblPro:Used()
      ::oDbfTblPro:End()
   end if


   if ::oDbfArtDiv != nil .and. ::oDbfArtDiv:Used()
      ::oDbfArtDiv:End()
   end if

   if ::oDbfDiv != nil .and. ::oDbfDiv:Used()
      ::oDbfDiv:End()
   end if

   if ::oDbfKit != nil .and. ::oDbfKit:Used()
      ::oDbfKit:End()
   end if

   if ::oDbfIva != nil .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if

   if ::oDbfArtPrv != nil .and. ::oDbfArtPrv:Used()
      ::oDbfArtPrv:End()
   end if

   if ::oDbfCodeBar != nil .and. ::oDbfCodeBar:Used()
      ::oDbfCodeBar:End()
   end if

   ::oDbf         := nil
   ::oDbfArt      := nil
   ::oDbfPro      := nil
   ::oDbfTblPro   := nil
   ::oDbfArtDiv   := nil
   ::oDbfDiv      := nil
   ::oDbfKit      := nil
   ::oDbfIva      := nil
   ::oDbfArtPrv   := nil
   ::oDbfCodeBar  := nil

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD CloseService()

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   ::oDbf   := nil

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD SaveDetails()

   ::oDbfVir:cCodFac  := ::oParent:oDbf:cCodFac

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( nMode )

   local oDlg
   local aGet              := Array( 17 )

   if nMode == APPD_MODE

      ::oDbfVir:nCajas     := 1
      ::oDbfVir:nUnidades  := 1
      ::oDbfVir:nPreUnit   := 0
      ::nTotLin            := 0
      ::oDbfVir:nNumLin    := nLastNum( ::oDbfVir:cAlias )

   end if

   ::cOldCodArt            := ::oDbfVir:cCodArt
   ::cOldPrpArt            := ::oDbfVir:cCodPr1 + ::oDbfVir:cCodPr2 + ::oDbfVir:cValPr1 + ::oDbfVir:cValPr2

   DEFINE DIALOG  oDlg ;
      RESOURCE    "LFacAutomatica" ;
      TITLE       LblTitle( nMode ) + "línea de plantilla de venta automática"

      REDEFINE GET aGet[ _CCODART ] VAR ::oDbfVir:cCodArt;
         ID       110 ;
         WHEN     ( nMode == APPD_MODE );
         BITMAP   "LUPA" ;
         OF       oDlg

      aGet[ _CCODART ]:bValid := {|| ::lLoaArt( aGet ), ::lCalcDeta() }
      aGet[ _CCODART ]:bHelp  := {|| BrwArticulo( aGet[ _CCODART ], aGet[ _CDETALLE ] ), ::lLoaArt( aGet ) }

      REDEFINE GET aGet[ _CDETALLE ] VAR ::oDbfVir:cDetalle ;
         ID       111 ;
         WHEN     ( ( lModDes() .or. Empty( ::oDbfVir:cDetalle ) ) .AND. nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ _MLNGDES ] VAR ::oDbfVir:mLngDes ;
			MEMO ;
         ID       190 ;
         WHEN     ( ( lModDes() .or. Empty( ::oDbfVir:mLngDes ) ) .AND. nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ _CVALPR1 ] VAR ::oDbfVir:cValPr1 ;
         ID       120 ;
         IDSAY    122 ;
         IDTEXT   121 ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

         aGet[ _CVALPR1 ]:bHelp  := {|| brwPropiedadActual( aGet[ _CVALPR1 ], aGet[ _CVALPR1 ]:oHelpText, ::oDbfVir:cCodPr1 ) }
         aGet[ _CVALPR1 ]:bValid := {|| if( lPrpAct( ::oDbfVir:cValPr1, aGet[ _CVALPR1 ]:oHelpText, ::oDbfVir:cCodPr1, ::oDbfTblPro:cAlias ), ( ::lLoaArt( aGet ), ::lCalcDeta() ), .f. ) }

      REDEFINE GET aGet[ _CVALPR2 ] VAR ::oDbfVir:cValPr2 ;
         ID       130 ;
         IDSAY    132 ;
         IDTEXT   131 ;
         BITMAP   "LUPA" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

         aGet[ _CVALPR2 ]:bHelp  := {|| brwPropiedadActual( aGet[ _CVALPR2 ], aGet[ _CVALPR2 ]:oHelpText, ::oDbfVir:cCodPr2 ) }
         aGet[ _CVALPR2 ]:bValid := {|| if( lPrpAct( ::oDbfVir:cValPr2, aGet[ _CVALPR2 ]:oHelpText, ::oDbfVir:cCodPr2, ::oDbfTblPro:cAlias ), ( ::lLoaArt( aGet ), ::lCalcDeta() ), .f. ) }

      REDEFINE GET aGet[ _NIVA ] VAR ::oDbfVir:nIva ;
         ID       200 ;
         WHEN     ( ( lModIva() .or. Empty( ::oDbfVir:cCodArt ) .and. nMode != ZOOM_MODE ) );
         PICTURE  "@E 999.99" ;
         BITMAP   "Lupa" ;
         OF       oDlg

         aGet[ _NIVA ]:bValid    := {|| lTiva( ::oDbfIva:cAlias, ::oDbfVir:nIva ) }
         aGet[ _NIVA ]:bHelp     := {|| BrwIva( aGet[ _NIVA ], ::oDbfIva:cAlias, , .t. ) }
         aGet[ _NIVA ]:bChange   := {|| ::lCalcDeta() }

      REDEFINE GET aGet[ _NCAJAS ] VAR ::oDbfVir:nCajas ;
         ID       140 ;
         IDSAY    141 ;
			SPINNER ;
         WHEN     ( nMode != ZOOM_MODE .AND. lUseCaj() ) ;
         PICTURE  MasUnd() ;
         OF       oDlg

         aGet[ _NCAJAS ]:bChange  := {|| ::lCalcDeta() }
         aGet[ _NCAJAS ]:bValid   := {|| ::lCalcDeta() }

      REDEFINE GET aGet[ _NUNIDADES ] VAR ::oDbfVir:nUnidades ;
         ID       150 ;
         IDSAY    151 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  MasUnd() ;
         OF       oDlg

         aGet[ _NUNIDADES ]:bChange  := {|| ::lCalcDeta() }
         aGet[ _NUNIDADES ]:bValid   := {|| ::lCalcDeta() }

      REDEFINE CHECKBOX aGet[ _LPRCATP ] VAR ::oDbfVir:lPrcAtp ;
         ID       411 ;
         ON CHANGE ( ::lChangePrcAtp( aGet ) );
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET aGet[ _NPREUNIT ] VAR ::oDbfVir:nPreUnit ;
         ID       170 ;
         IDSAY    171 ;
			SPINNER ;
         WHEN     ( !::oDbfVir:lPrcAtp .and. nMode != ZOOM_MODE ) ;
         PICTURE  ::oParent:cPouDiv ;
         OF       oDlg

         aGet[ _NPREUNIT ]:bChange  := {|| ::lCalcDeta() }
         aGet[ _NPREUNIT ]:bValid   := {|| ::lCalcDeta() }

      REDEFINE GET ::oTotLin VAR ::nTotLin ;
         ID       180 ;
         IDSAY     181 ;
			WHEN 		.F. ;
         PICTURE  ::oParent:cPorDiv ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::lPreSave( aGet, oDlg ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:End() )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F5, {|| ::lPreSave( aGet, oDlg ) } )
      end if

   oDlg:bStart := {|| ::SetDlgMode( aGet, nMode ), ::lCalcDeta() }

   oDlg:Activate( , , , .t., , , {|| EdtMenu( Self, oDlg ) } )

   oMenu:End()

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

METHOD lPreSave( aGet, oDlg )

   local cCodArt  := aGet[ _CCODART ]:VarGet()

   if !Empty( cCodArt ) .and. !::oDbfArt:SeekInOrd( cCodArt, "Codigo" )
      msgStop( "Artículo no encontrado" )
      Return .f.
   end if

   ::cOldPrpArt   := ""
   ::cOldCodArt   := ""

   oDlg:End( IDOK )

RETURN .t.

//---------------------------------------------------------------------------//

METHOD SetDlgMode( aGet, nMode )

   if !lUseCaj()
      aGet[ _NCAJAS ]:Hide()
   else
      aGet[ _NCAJAS ]:oSay:SetText( cNombreCajas() )
   end if

   aGet[ _NUNIDADES ]:oSay:SetText( cNombreUnidades() )

   do case
      case nMode == APPD_MODE

         aGet[ _CDETALLE]:Show()
         aGet[ _MLNGDES ]:Hide()

      otherwise

         if !Empty( ::oDbfVir:cCodArt )

            aGet[ _CDETALLE ]:show()
            aGet[ _MLNGDES  ]:hide()

         end if

   end case

   if !Empty( ::oDbfVir:cCodPr1 )

      if !Empty( aGet[ _CVALPR1 ] )
         aGet[ _CVALPR1 ]:Show()
         aGet[ _CVALPR1 ]:lValid()
         aGet[ _CVALPR1 ]:oSay:SetText( retProp( ::oDbfArt:cCodPrp1, ::oDbfPro ) )
      end if

   else

      if !Empty( aGet[ _CVALPR1 ] )
         aGet[_CVALPR1 ]:hide()
      end if

   end if

   if !Empty( ::oDbfVir:cCodPr2 )

      if !Empty( aGet[ _CVALPR2 ] )
         aGet[ _CVALPR2 ]:Show()
         aGet[ _CVALPR2 ]:lValid()
         aGet[ _CVALPR2 ]:oSay:SetText( retProp( ::oDbfArt:cCodPrp2, ::oDbfPro ) )
      end if

   else

      if !Empty( aGet[ _CVALPR2 ] )
         aGet[_CVALPR2 ]:hide()
      end if

   end if

   if ::oDbfVir:lPrcAtp
      aGet[ _NPREUNIT ]:Hide()
      ::oTotLin:Hide()
   else
      aGet[ _NPREUNIT ]:Show()
      ::oTotLin:Show()
   end if

   aGet[ _NPREUNIT ]:Refresh()
   ::oTotLin:Refresh()

   /*
   Solo pueden modificar los precios los administradores-----------------------
   */

   if ( Empty( ::oDbfVir:nPreUnit ) .or. ( SQLAjustableModel():getRolCambiarPrecios( Auth():rolUuid() ) ) ) .and. nMode != ZOOM_MODE
      aGet[ _NPREUNIT ]:HardEnable()
   else
      aGet[ _NPREUNIT ]:HardDisable()
   end if

Return .t.

//---------------------------------------------------------------------------//

METHOD lLoaArt( aGet )

   Local cCodArt        := aGet[ _CCODART ]:VarGet()
   local lChgCodArt
   local cPrpArt
   local nPrePro        := 0
   local nPosComa
   local cProveedor

   if Empty( cCodArt )

      if !Empty( aGet[ _CDETALLE ] )
         aGet[ _CDETALLE ]:cText( Space( 250 ) )
         aGet[ _CDETALLE ]:Hide()
      end if

      if !Empty( aGet[ _MLNGDES ] )
         aGet[ _MLNGDES ]:Show()
         aGet[ _MLNGDES ]:SetFocus()
      end if

      if !Empty( aGet[_CVALPR1 ] )
         aGet[_CVALPR1 ]:Hide()
      end if

      if !Empty( aGet[_CVALPR2 ] )
         aGet[_CVALPR2 ]:Hide()
      end if

   else

      /*
      búsquedas por códigos de barras o por ref. proveedor---------------------
      */

      if "," $ cCodArt
         nPosComa                := At( ",", cCodArt )
         cProveedor              := RJust( Left( cCodArt, nPosComa - 1 ), "0", RetNumCodPrvEmp() )
         cCodArt                 := cSeekProveedor( cCodArt, ::oDbfArtPrv:cAlias )
      else
         cCodArt                 := cSeekCodebar( cCodArt, ::oDbfCodebar:cAlias, ::oDbfArt:cAlias )
      end if

      lChgCodArt     := ( Rtrim( ::cOldCodArt ) != Rtrim( cCodArt ) )

      if ::oDbfArt:SeekInOrd( cCodArt, "Codigo" ) .or. ::oDbfArt:SeekInOrd( Upper( cCodArt ), "Codigo" )

         if ( lChgCodArt )

            if ::oDbfArt:lObs
               MsgStop( "Artículo catalogado como obsoleto" )
               return .f.
            end if

            ::oDbfVir:cCodArt := cCodArt
            aGet[ _CCODART ]:cText( cCodArt )

            if !Empty( aGet[ _CDETALLE ] )
               aGet[ _CDETALLE ]:show()
               aGet[ _CDETALLE ]:cText( ::oDbfArt:Nombre )
            end if

            if !Empty( aGet[ _MLNGDES ] )
               aGet[ _MLNGDES ]:hide()
            end if

            if ::oDbfArt:nCajEnt != 0
               aGet[ _NCAJAS ]:cText( ::oDbfArt:nCajEnt )
            end if

            if ::oDbfArt:nUniCaja != 0
               aGet[ _NUNIDADES ]:cText( ::oDbfArt:nUniCaja )
            end if

            if !Empty( aGet[ _NIVA ] )
               aGet[ _NIVA ]:cText( nIva( ::oDbfIva:cAlias, ::oDbfArt:TipoIva ) )
            end if

            ::oDbfVir:lKitArt    := ::oDbfArt:lKitArt

            if ::oDbfVir:lKitArt
               ::oDbfVir:lKitPrc := lPreciosCompuestos( cCodArt, ::oDbfArt:cAlias )
            end if

         end if

         cPrpArt                 := ::oDbfVir:cCodPr1 + ::oDbfVir:cCodPr2 + ::oDbfVir:cValPr1 + ::oDbfVir:cValPr2

         if ( lChgCodArt ) .or. ( cPrpArt != ::cOldPrpArt )

            ::oDbfVir:cCodPr1    := ::oDbfArt:cCodPrp1
            ::oDbfVir:cCodPr2    := ::oDbfArt:cCodPrp2

            if !Empty( ::oDbfVir:cCodPr1 )

               if aGet[ _CVALPR1 ] != nil
                  aGet[ _CVALPR1 ]:show()
                  aGet[ _CVALPR1 ]:SetFocus()
                  aGet[ _CVALPR1 ]:oSay:SetText( retProp( ::oDbfArt:cCodPrp1, ::oDbfPro ) )
               end if

            else

               if !Empty( aGet[ _CVALPR1 ] )
                  aGet[ _CVALPR1 ]:hide()
                  aGet[ _CVALPR1 ]:oHelpText:cText( "" )
               end if

            end if

            if !Empty( ::oDbfVir:cCodPr2 )

               if aGet[ _CVALPR2 ] != nil
                  aGet[ _CVALPR2 ]:show()
                  aGet[ _CVALPR2 ]:SetFocus()
                  aGet[ _CVALPR2 ]:oSay:SetText( retProp( ::oDbfArt:cCodPrp2, ::oDbfPro ) )
               end if

            else

               if !Empty( aGet[ _CVALPR2 ] )
                  aGet[ _CVALPR2 ]:hide()
                  aGet[ _CVALPR2 ]:oHelpText:cText( "" )
               end if

            end if

            //--guardamos el precio del artículo dependiendo de las propiedades--//

            nPrePro           := nPrePro( ::oDbfVir:cCodArt, ::oDbfVir:cCodPr1, ::oDbfVir:cValPr1, ::oDbfVir:cCodPr2, ::oDbfVir:cValPr2, 1, .f., ::oDbfArtDiv:cAlias )

            if nPrePro == 0
               aGet[ _NPREUNIT]:cText( nRetPreArt( 1, cDivEmp(), .f., ::oDbfArt:cAlias, ::oDbfDiv:cAlias, ::oDbfKit:cAlias, ::oDbfIva:cAlias, .f. ) )
            else
               aGet[ _NPREUNIT]:cText( nPrePro )
            end if

         end if

         ::cOldPrpArt  := cPrpArt
         ::cOldCodArt  := cCodArt

      else

         MsgStop( "Artículo no encontrado" )
         aGet[ _CCODART ]:SetFocus()
         Return .f.

      end if

   end if

Return .t.

//---------------------------------------------------------------------------//

METHOD lCalcDeta()

   local nCalculo
   local nUnidades

   nCalculo       := ::oDbfVir:nPreUnit

   nUnidades      := ::nTotNFacAut( ::oDbfVir )

   nCalculo       *= nUnidades

   ::oTotLin:cText( nCalculo )

RETURN .t.

//---------------------------------------------------------------------------//

METHOD Descrip()

   local cReturn     := ""

   if !Empty( ::oDbfVir:cDetalle )
      cReturn        := Rtrim( ::oDbfVir:FieldGetByName( "cDetalle" ) )
   else
      cReturn        := Rtrim( ::oDbfVir:FieldGetByName( "mLngDes" ) )
   end if

RETURN ( cReturn )

//---------------------------------------------------------------------------//

METHOD nTotLFacAut( oDbfDet )

RETURN ( oDbfDet:nPreUnit * ::nTotNFacAut( oDbfDet ) )

//---------------------------------------------------------------------------//

METHOD nTotNFacAut( oDbfDet )

   local nTotUnd  := 0

      nTotUnd        := NotCaja( oDbfDet:nCajas )
      nTotUnd        *= oDbfDet:nUnidades

Return ( nTotUnd )

//---------------------------------------------------------------------------//

METHOD AppendKit()

   local nRec        := ::oDbfVir:Recno()
   local cCodFac     := ::oDbfVir:cCodFac
   local cCodArt     := ::oDbfVir:cCodArt
   local nCajas      := ::oDbfVir:nCajas
   local nUnidades   := ::oDbfVir:nUnidades
   local nNumLin     := ::oDbfVir:nNumLin

   if ::oDbfKit:SeekInOrd( cCodArt, "cCodKit" )

      while ::oDbfKit:cCodKit == cCodArt .and. !( ::oDbfKit:Eof() )

         if ::oDbfArt:SeekInOrd( ::oDbfKit:cRefKit, "Codigo" )

            ::oDbfVir:Append()

            ::oDbfVir:cCodFac       := cCodFac
            ::oDbfVir:cCodArt       := ::oDbfKit:cRefKit
            ::oDbfVir:cDetalle      := ::oDbfArt:Nombre
            ::oDbfVir:cCodPr1       := Space(20)
            ::oDbfVir:cCodPr2       := Space(20)
            ::oDbfVir:cValPr1       := Space(40)
            ::oDbfVir:cValPr2       := Space(40)
            ::oDbfVir:nCajas        := nCajas
            ::oDbfVir:nUnidades     := nUnidades * ::oDbfKit:nUndKit
            ::oDbfVir:nPreUnit      := nRetPreArt( 1, cDivEmp(), .f., ::oDbfArt:cAlias, ::oDbfDiv:cAlias, ::oDbfKit:cAlias, ::oDbfIva:cAlias, .f. )
            ::oDbfVir:lKitArt       := .f.
            ::oDbfVir:lKitChl       := .t.
            ::oDbfVir:lKitPrc       := lPreciosComponentes( cCodArt, ::oDbfArt:cAlias )
            ::oDbfVir:nIva          := nIva( ::oDbfIva, ::oDbfArt:TipoIva )
            ::oDbfVir:nNumLin       := nNumLin

            ::oDbfVir:Save()

         end if

         ::oDbfKit:Skip()

      end while

   end if

   /*
   Volvemos al registro en el que estabamos y refrescamos el browse------------
   */

   ::oDbfVir:GoTo( nRec )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AppendDet( oBrw )

   ::oDbfVir:Blank()

   if ::bOnPreAppend != nil
      Eval( ::bOnPreAppend, Self )
   end if

   if ::Resource( 1 )

      if ::bOnPreSave != nil
         Eval( ::bOnPreSave, Self )
      end if

      ::oDbfVir:Insert()

      ::AppendKit()

      if ::bOnPostSave != nil
         Eval( ::bOnPostSave, Self )
      end if

      if ::bOnPostAppend != nil
         Eval( ::bOnPostAppend, Self )
      end if

   end if

   ::oDbfVir:Cancel()

   if( oBrw != nil, oBrw:Refresh(), )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lChangePrcAtp( aGet )

   if ::oDbfVir:lPrcAtp
      aGet[ _NPREUNIT ]:Hide()
      ::oTotLin:Hide()
   else
      aGet[ _NPREUNIT ]:Show()
      ::oTotLin:Show()
   end if


   if !Empty( aGet[ _NPREUNIT ] )
      aGet[ _NPREUNIT ]:Refresh()
   end if

   if !Empty( ::oTotLin )
      ::oTotLin:Refresh()
   end if

Return .t.

//---------------------------------------------------------------------------//

static function EdtMenu( oThis, oDlg )

   local cCodArt     := oThis:oDbfVir:cCodArt

   MENU oMenu

      MENUITEM    "&1. Rotor  "

         MENU

            MENUITEM    "&1. Modificar de artículo";
               MESSAGE  "Modificar la ficha del artículo" ;
               RESOURCE "gc_object_cube_16";
               ACTION   ( EdtArticulo( cCodArt ) );

            MENUITEM    "&2. Informe de artículo";
               MESSAGE  "Abrir el informe del artículo" ;
               RESOURCE "Info16";
               ACTION   ( if( oUser():lNotCostos(), msgStop( "No tiene permiso para ver los precios de costo" ), InfArticulo( cCodArt ) ) );

         ENDMENU

   ENDMENU

   oDlg:SetMenu( oMenu )

Return ( oMenu )

//---------------------------------------------------------------------------//