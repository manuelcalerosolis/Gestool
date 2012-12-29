#include "FiveWin.Ch"
#include "Factu.ch"
#include "Constant.ch"
#include "Mesdbf.ch"

#define SC_MAXIMIZE           61488    // 0xF030

#define WM_ERASEBKGND         20       // 0x14
#define WM_CHILDACTIVATE      34       // 0x22
#define WM_ICONERASEBKGND     39       // 0x27

#define  ACC_DELE             0        // Acceso Eliminar
#define  ACC_APPD             1        // Acceso Añadir
#define  ACC_EDIT             2        // Solo modificar
#define  ACC_ZOOM             3        // Solo visualizar

//----------------------------------------------------------------------------//

CLASS TShell FROM TMdiChild

   DATA  oBrw
   DATA  oBtnBar
   DATA  oBtnTop
   DATA  oMsgBar
   DATA  oTabs
   DATA  oComb
   DATA  cComb
   DATA  oFont
   DATA  oIcon
   DATA  xAlias
   DATA  nArea
   DATA  cTitle
   DATA  cWinName
   DATA  aPrompt
   DATA  aFastKey
   DATA  aFlds       AS ARRAY    INIT {}
   DATA  aHeaders    AS ARRAY    INIT {}
   DATA  aColSizes   AS ARRAY    INIT {}
   DATA  aColSelect  AS ARRAY    INIT {}
   DATA  aColPos     AS ARRAY    INIT {}
   DATA  aJustify    AS ARRAY    INIT {}
   DATA  nLevel
   DATA  lCenter
   DATA  nSizeBtn
   DATA  aMru        AS ARRAY    INIT {}
   DATA  aKey        AS ARRAY    INIT {}
   DATA  oTxtSea
   DATA  aLstSea     AS ARRAY    INIT {}
   DATA  lMru        AS LOGIC    INIT .t.
   DATA  cMru
   DATA  oDbfUsr
   DATA  oDbfCol
   DATA  nRecno
   DATA  nTab        AS NUMERIC  INIT 1
   DATA  lMin
   DATA  lZoom
   DATA  lNoSave     AS LOGIC    INIT .f.
   DATA  aOriginal   AS ARRAY    INIT {}
   DATA  lBmpMenu    AS LOGIC    INIT .f.
   DATA  lAutoSeek   AS LOGIC    INIT .f.
   DATA  bExpFilter
   DATA  aRecFilter  AS ARRAY
   DATA  lBigStyle   AS LOGIC    INIT .f.
   DATA  lDrag       AS LOGIC
   DATA  lAutoPos    AS LOGIC    INIT .t.
   DATA  nFlds
   DATA  nColUno
   DATA  nColDos
   DATA  cHtmlHelp

   METHOD New(  nTop, nLeft, nBottom, nRight, cTitle, oMenu, oWnd, oIcon,;
             oCursor, lPixel, nHelpId, aFlds, xAlias, aHeaders,;
             aColSizes, aColSelect, aJustify, aPrompt, bAdd, bEdit, bDel,;
             bDup, nSizeBtn, nLevel, cMru, cInifile, lBigStyle, bZoo )

   METHOD xActivate( cShow, bLClicked, bRClicked, bMoved, bResized, bPainted,;
                    bKeyDown, bInit, bUp, bDown, bPgUp, bPgDn,;
                    bLeft, bRight, bPgLeft, bPgRight, bValid, bDropFiles,;
                    bLButtonUp, lCenter )

   METHOD ChgTabs()

   METHOD SaveOriginal()

   METHOD OpenData()

   METHOD CloseData()

   METHOD XEnd()

   METHOD Destroy()

   METHOD ActColSizes()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New(  nTop, nLeft, nBottom, nRight, cTitle, oMenu, oWnd, oIcon,;
             oCursor, lPixel, nHelpId, aFlds, xAlias, aHeaders,;
             aColSizes, aColSelect, aJustify, aPrompt, bAdd, bEdit, bDel,;
             bDup, nSizeBtn, nLevel, cMru, cInifile, lBigStyle, bZoo ) CLASS TShell

   local n
   local oDlg
   local nPos
   local cSea
   local nSize
   local aRect
   local bLine
   local lSelect
   local nRecno
   local nClrFore
   local aTmpFld
   local aTmpHea
   local aTmpJus
   local nStyle      := 0

   DEFAULT nTop      := 0
   DEFAULT nLeft     := 0
   DEFAULT nBottom   := 22
   DEFAULT nRight    := 80
   DEFAULT cTitle    := "MDI Child"
   DEFAULT oWnd      := GetWndFrame()
   DEFAULT lPixel    := .f.
   DEFAULT oIcon     := TIcon():New( ,, "BROWSE",, )
   DEFAULT oCursor   := TCursor():New( , "ARROW" )
   DEFAULT aPrompt   := { "General" }
   DEFAULT nSizeBtn  := 42
   DEFAULT nLevel    := ACC_APPD
   DEFAULT aFlds     := {}
   DEFAULT aHeaders  := {}
   DEFAULT aColSizes := {}
   DEFAULT aColSelect:= {}
   DEFAULT aJustify  := {}
   DEFAULT lBigStyle := .f.

   // Adaptamos la longitud de pantalla a la resolución

   aRect := GetWndRect( GetDeskTopWindow() )
   if aRect[4] >= 800
      nBottom  += 6
      nRight   += 20
   endif

   ::nTop            := nTop
   ::nLeft           := nLeft
   ::nBottom         := nBottom
   ::nRight          := nRight
   ::cTitle          := cTitle
	::aFastKey			:= {}
   ::aPrompt         := aPrompt
   ::oIcon           := oIcon
   ::nSizeBtn        := nSizeBtn
   ::cMru            := cMru
   ::aKey            := {}
   ::aFlds           := aFlds
   ::aHeaders        := aHeaders
   ::aColSizes       := aColSizes
   ::aColSelect      := aColSelect
   ::aJustify        := aJustify
   ::lBigStyle       := lBigStyle

   /*
   Fuentes en funcion del estilo
   */

   if ::lBigStyle
      ::oFont        := TFont():New( "Ms Sans Serif", 6, 18, .f. )
   else
      ::oFont        := TFont():New( "Ms Sans Serif", 6, 12, .f. )
   end if

   ::xAlias          := xAlias

   do case
   case Valtype( xAlias ) == "O"
      ::nArea        := xAlias:nArea
   case ValType( xAlias ) == "C"
      ::nArea        := xAlias
   end case

   /*
   Tamaño de la ventana siempre a pixels---------------------------------------
   */

   ::nTop            := nTop    * if( !lPixel, MDIC_CHARPIX_H, 1 )
   ::nLeft           := nLeft   * if( !lPixel, MDIC_CHARPIX_W, 1 )
   ::nBottom         := nBottom * if( !lPixel, MDIC_CHARPIX_H, 1 )
   ::nRight          := nRight  * if( !lPixel, MDIC_CHARPIX_W, 1 )

   ::nFlds           := len( aFlds )

   /*
   Todos deben de ser de la misma longuitud------------------------------------
   */

   if len( ::aColSelect ) < ::nFlds
      aSize( ::aColSelect, ::nFlds )
      aEval( ::aColSelect, {| x, n | if( x == nil, ::aColSelect[n] := .t., ) } )
   end if

   if len( ::aHeaders ) < ::nFlds
      aSize( ::aHeaders, ::nFlds )
      aEval( ::aHeaders, {| x, n | if( x == nil, ::aHeaders[n] := "", ) } )
   end if

   if len( ::aJustify ) < ::nFlds
      aSize( ::aJustify, ::nFlds )
      aEval( ::aJustify, {| x, n | if( x == nil, ::aJustify[n] := .f., ) } )
   end if

   if len( ::aColSizes ) < ::nFlds
      aSize( ::aColSizes, ::nFlds )
      aEval( ::aColSizes, {| x, n | if( x == nil, ::aColSizes[n] := 0, ) } )
   end if

   for n := 1 to ::nFlds
      if ::aColSizes[ n ] == 0
         ::aColSizes[ n ] := if( ValType( Eval( aFlds[ n ] ) ) != "C", 15, GetTextWidth( 0, Replicate( "B", Max( Len( aHeaders[ n ] ), Len( Eval( aFlds[ n ] ) ) + 1 ) ) ) )
      elseif ::aColSizes[ n ] == -1
         ::aColSizes[ n ]:= 0
      end if
   next

   ::aColPos   := array( ::nFlds )

   aEval( ::aColPos, {| x, n | ::aColPos[n] := n } )

   /*
   Guadamos la situación original----------------------------------------------
   */

   ::SaveOriginal()

   /*
   Creamos el objeto ini-------------------------------------------------------
   */

   ::OpenData()

   /*
   Ultimo registro activo------------------------------------------------------
   */

   if at( ":", ::cTitle ) != 0
      ::cWinName     := Padr( SubStr( ::cTitle, 1, at( ":", ::cTitle ) ), 30 )
   else
      ::cWinName     := Padr( Rtrim( ::cTitle ), 30 )
   end if

   if ::oDbfUsr != nil
      if ::oDbfUsr:Seek( cCurUsr() + ::cWinName )
         ::nRecNo    := ::oDbfUsr:nRecCfg
         ::nTab      := ::oDbfUsr:nTabCfg
      else
         ::nRecNo    := 1
         ::nTab      := 1
      end if
   end if

   /*
   Fin de la captura del error-------------------------------------------------
   */

   ::lAutoSeek       := .f. //::oDbfUsr:Get( ::cTitle, "ISAUTOSEEK", .t. )

   /*
   Llamada al objeto padre para que se cree------------------------------------
   */

   Super:New( ::nTop, ::nLeft, ::nBottom, ::nRight, cTitle, 0, oMenu, oWnd,;
            oIcon, , , , oCursor, , .t., , nHelpId, "NONE", .f., .f., .f., .f. )

   /*
   Vamos a obtener el orden de las columnas -----------------------------------
   */

   for n := 1 to ::nFlds
      if ::oDbfCol:Seek( cCurUsr() + ::cWinName + Str( n, 2 ) ) .and.;
         n <= len( ::aColPos )
         ::aColPos[ n ]    := ::oDbfCol:nPosCol
         ::aColSelect[ n ] := ::oDbfCol:lSelCol
         ::aColSizes[ n ]  := ::oDbfCol:nSizCol
         ::aJustify[ n ]   := ::oDbfCol:lJusCol
      end if
   next

   aTmpFld  := Array( ::nFlds )
   aTmpHea  := Array( ::nFlds )
   aTmpJus  := Array( ::nFlds )

   for n := 1 to ::nFlds
      nPos              := ::aColPos[ n ]
      if nPos > 0 .and. nPos <= len( ::aFlds )
         aTmpFld[ n ]   := ::aFlds[ nPos ]
         aTmpHea[ n ]   := ::aHeaders[ nPos ]
         aTmpJus[ n ]   := ::aJustify[ nPos ]
      end if
   next

   ::aFlds              := aTmpFld
   ::aHeaders           := aTmpHea
   ::aJustify           := aTmpJus

   /*
   Ya tenemos los datos para montar la linea-----------------------------------
   */

   bLine                := {|| _aFld( ::aFlds, ::aColSelect ) }

   /*
   Anchos automaticos----------------------------------------------------------
   */

   aColSizes            := _aColSize( ::aColSizes, ::aColSelect )

   /*
   Cabeceras segun las columnas seleccionadas----------------------------------
   */

   aHeaders             := _aColHead( ::aHeaders, ::aColSelect )

   /*
   Justificaciones segun las columnas seleccionadas----------------------------
   */

   aJustify             := _aColJustify( ::aJustify, ::aColSelect )

   ::oClient            := TPanel():New( , , , , )

   /*
   Barra de botones-----------------------------------------------------------
   */

#ifndef __C3__

   @ 0, 0   WEBBAR      ::oBtnTop ;
            SIZE        400, 40 ;
            CTLHEIGHT   20 ;
            FONT        ( TFont():New( "Verdana", 0, -22, .f., .t. ) );
            COLOR       Rgb( 255,255,255) ;
            RESOURCE    "WebTop" ;
            OF          Self


#else

   @ 0, 0   WEBBAR      ::oBtnTop ;
            SIZE        400, 40 ;
            CTLHEIGHT   20 ;
            FONT        ( TFont():New( "Verdana", 0, -22, .f., .t. ) );
            COLOR       Rgb( 255,255,255) ;
            RESOURCE    "WebTop32" ;
            OF          Self

#endif

   ::oBtnTop:Say( 6, 200, ::cTitle )
   ::oTop               := ::oBtnTop

#ifndef __C3__

   @ 0, 0   WEBBAR      ::oBtnBar ;
            SIZE        144, 400 ;
            CTLHEIGHT   if( ::lBigStyle, 36, 20 ) ;
            RESOURCE    "WebLeft" ;
            OF          Self

#else

   @ 0, 0   WEBBAR      ::oBtnBar ;
            SIZE        144, 400 ;
            CTLHEIGHT   if( ::lBigStyle, 36, 20 ) ;
            RESOURCE    "WebLeft32" ;
            OF          Self

   ::oBtnBar:nTopMargin := 30

#endif

   ::oLeft              := ::oBtnBar

   /*
   Montamos el objeto browse---------------------------------------------------
   */

   do case
   case Valtype( xAlias ) == "O"
      ::oBrw            := TWBrowse():New( nSizeBtn, -1, ::nRight - ::nLeft, ::nBottom - ::nTop - 33 - 25, bLine, aHeaders, aColSizes, ::oClient,,,,,,, ::oFont,,,,, .f., ::xAlias:cAlias, .t., , .f. )
      xAlias:SetBrowse( ::oBrw, .f. )

   case ValType( xAlias ) == "C"
      ::oBrw            := TWBrowse():New( nSizeBtn, -1, ::nRight - ::nLeft, ::nBottom - ::nTop - 33 - 25, bLine, aHeaders, aColSizes, ::oClient,,,,,,, ::oFont,,,,, .f., ::xAlias, .t.,, .f. )

      if ( ::xAlias )->( OrdNumber() ) <= 0
         ::oBrw:oVScroll:SetPos( ( ::xAlias )->( OrdKeyNo() ) )
      else
         ::oBrw:oVScroll:SetPos( ( ::xAlias )->( RecNo() ) )
      end if

   case xAlias == nil
      ::oBrw            := TWBrowse():New( nSizeBtn, -1, ::nRight - ::nLeft, ::nBottom - ::nTop - 33 - 25, bLine, aHeaders, aColSizes, ::oClient,,,,,,, ::oFont,,,,, .f., ::xAlias, .t., , .f. )

   end case

   ::oBrw:Default()
   ::oBrw:aJustify      := aJustify
   ::oBrw:bKeyChar      := {|nKey| ::CtrlKey( nKey ) }

   // Enterprise---------------------------------------------------------------

   ::oBrw:lAdjLastCol   := .f.
   ::oBrw:lAdjBrowse    := .t.

   if ::lBigStyle
      ::oBrw:nHeaderHeight := 36
      ::oBrw:nFooterHeight := 36
      ::oBrw:nLineHeight   := 36
   else
      ::oBrw:nHeaderHeight := 16
      ::oBrw:nFooterHeight := 16
      ::oBrw:nLineHeight   := 16
   end if

   // Colores---------------------------------------------------------------------

   ::oBrw:nClrForeFocus := GetSysColor( 14 )
   ::oBrw:nClrBackFocus := GetSysColor( 13 )
   ::oBrw:SetColor( CLR_BLACK, GetSysColor( 5 ) )

   do case
      case ValType( ::xAlias ) == "O"
         ::oBrw:nClrPane   := {|| ::ClrPan( ::xAlias:OrdKeyNo() ) }
      case ValType( ::xAlias ) == "C"
         ::oBrw:nClrPane   := {|| ::ClrPan( ( ::xAlias )->( OrdKeyNo() ) ) }
      case ValType( ::xAlias ) == "A"
         ::oBrw:nClrPane   := {|| ::ClrPan( ::oBrw:nAt ) }
   end case

   ::oBrw:nClrBackHead  := Rgb( 239, 231, 222 )
   ::oBrw:nClrForeHead  := CLR_BLACK

   // Asignando-------------------------------------------------------------------

   ::oBrw:bAdd          := bAdd
   ::oBrw:bEdit         := bEdit
   ::oBrw:bLDblClick    := {|| ::recEdit() }
   ::oBrw:bDel          := bDel
   ::oBrw:bDup          := bDup
   ::oBrw:bZoo          := bZoo
   ::oBrw:oDragCursor   := oCursor
   ::oBrw:bRClicked     := {| nRow, nCol, nFlags | ::RButtonDown( nRow, nCol, nFlags ) }
   ::oBrw:aActions      := { {|| ::lPressCol() } }
   ::oBrw:setFocus()

   ::oClient:oClient    := ::oBrw

   /*
   las tabs--------------------------------------------------------------------
   */

   if valType( aPrompt ) == "A"
      ::oTabs           := TTabs():New( ::nBottom - ::nTop - 43, 3, aPrompt, , ::oClient, , , Rgb( 239, 231, 222 ), .T., .F., ::nRight - ::nLeft, 24 )
      ::oTabs:bAction   := {|| ::ChgTabs() }
      ::oTabs:oBrush    := TBrush():New( , GetSysColor( 15 ) )
      ::oClient:oBottom := ::oTabs
   end if

   /*
   Nivel de Acceso-------------------------------------------------------------
   */

   ::nLevel             := nLevel

   /*
   Colores del browse----------------------------------------------------------
   */

   if ::nColUno == nil
      ::nColUno  := nColUno()
   end if

   if ::nColDos == nil
      ::nColDos  := nColDos()
   end if

RETURN Self

//----------------------------------------------------------------------------//

METHOD xActivate( cShow, bLClicked, bRClicked, bMoved, bResized, bPainted,;
                    bKeyDown, bInit, bUp, bDown, bPgUp, bPgDn,;
                    bLeft, bRight, bPgLeft, bPgRight, bValid, bDropFiles,;
                    bLButtonUp, lCenter ) CLASS TShell

   local nUp         := 0

   DEFAULT lCenter   := ( ::nTop == 0 .and. ::nLeft == 0 )
   DEFAULT bValid    := {|| .t. }

   ::lCenter         := lCenter

   Super:Activate( cShow, bLClicked, bRClicked, bMoved, bResized, bPainted,;
                    bKeyDown, bInit, bUp, bDown, bPgUp, bPgDn, bLeft, bRight,;
                    bPgLeft, bPgRight, bValid, bDropFiles, bLButtonUp )

   if ::lCenter
      ::Center( ::hWnd )
   end if

   ::Maximize()

   if ::lAutoPos
      if !empty( ::nRecNo ) .AND. ::nRecNo != 0
         do case
         case ValType( ::xAlias ) == "O"
            ::xAlias:GoTo( ::nRecNo )
         case ValType( ::xAlias ) == "C"
            (::xAlias)->( dbGoTo( ::nRecNo ) )
         end case
      end if

      if !empty( ::nTab ) .and. ::nTab != 0
         ::ChgTabs( ::nTab )
         ::oTabs:nOption   := ::nTab
         ::oTabs:Refresh()
      end if

   end if

RETURN NIL

//----------------------------------------------------------------------------//

METHOD ChgTabs( nTab ) CLASS TShell

   DEFAULT nTab   := ::oTabs:nOption

   do case
      case ValType( ::xAlias ) == "O"
         ::xAlias:SetOrder( nTab )
      case ValType( ::xAlias ) == "C"
         (::xAlias)->( dbSetOrder( nTab ) )
   end case

   ::oBrw:refresh()

   if ::oTxtSea != nil .and. ::oTxtSea:ClassName() == "TGET"

      ::oTxtSea:oGet:Home()
      ::oTxtSea:cText( Space( 100 ) )

      #ifdef __CLIPPER__
      ::oTxtSea:EditUpdate()
      #endif

   end if

return ( Self )

//----------------------------------------------------------------------------//

METHOD OpenData( lExclusive ) CLASS TShell

   DEFAULT lExclusive   := .f.

   DEFINE TABLE ::oDbfUsr FILE "CfgUse.Dbf" CLASS "CfgUseEmp" PATH ( cPatEmp() ) VIA ( cDriver() )COMMENT "Configuración de usuarios"

      FIELD NAME "cCodUse" TYPE "C" LEN  3  DEC 0 COMMENT "Código usuario"          OF ::oDbfUsr
      FIELD NAME "cNomCfg" TYPE "C" LEN 30  DEC 0 COMMENT "Nombre ventana"          OF ::oDbfUsr
      FIELD NAME "nRecCfg" TYPE "N" LEN 10  DEC 0 COMMENT "Recno de la ventana"     OF ::oDbfUsr
      FIELD NAME "nTabCfg" TYPE "N" LEN 10  DEC 0 COMMENT "Orden de la ventana"     OF ::oDbfUsr

      INDEX TO "CfgUse.Cdx" TAG "cCodUse" ON "cCodUse + cNomCfg" COMMENT "Código" NODELETED OF ::oDbfUsr

   END DATABASE ::oDbfUsr

   ::oDbfUsr:Activate( .f., !( lExclusive ) )

   /*
   Base de datos de usuarios conf de columnas de pantallas---------------------
   */

   DEFINE TABLE ::oDbfCol FILE "CfgCol.Dbf" CLASS "CfgColEmp"  PATH ( cPatEmp() ) VIA ( cDriver() )COMMENT "Configuracion de columnas de usuarios"

      FIELD NAME "cCodUse"    TYPE "C" LEN  3  DEC 0 COMMENT "Código usuario"             OF ::oDbfCol
      FIELD NAME "cNomCfg"    TYPE "C" LEN 30  DEC 0 COMMENT "Nombre ventana"             OF ::oDbfCol
      FIELD NAME "nNumCol"    TYPE "N" LEN  2  DEC 0 COMMENT "Número de la columna"       OF ::oDbfCol
      FIELD NAME "lSelCol"    TYPE "L" LEN  1  DEC 0 COMMENT "Columna seleccionada"       OF ::oDbfCol
      FIELD NAME "nPosCol"    TYPE "N" LEN  2  DEC 0 COMMENT "Posicición de la columna"   OF ::oDbfCol
      FIELD NAME "nSizCol"    TYPE "N" LEN  6  DEC 0 COMMENT "Tamaño de la columna"       OF ::oDbfCol
      FIELD NAME "lJusCol"    TYPE "L" LEN  1  DEC 0 COMMENT "Columna a la derecha"       OF ::oDbfCol

      INDEX TO "CfgCol.Cdx" TAG "cCodUse" ON "cCodUse + cNomCfg + Str( nNumCol )" COMMENT "Código" NODELETED OF ::oDbfCol

   END DATABASE ::oDbfCol

   ::oDbfCol:Activate( .f., !( lExclusive ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseData() CLASS TShell

   ? "close data"

   ::oDbfUsr:End()
   ::oDbfCol:End()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD SaveOriginal() CLASS TShell

   ::aOriginal := {}
   aAdd( ::aOriginal, { ::nTop, ::nLeft, ::nBottom, ::nRight } )
   aAdd( ::aOriginal, aClone( ::aColSelect ) )
   aAdd( ::aOriginal, aClone( ::aFlds      ) )
   aAdd( ::aOriginal, aClone( ::aHeaders   ) )
   aAdd( ::aOriginal, aClone( ::aColSizes  ) )
   aAdd( ::aOriginal, aClone( ::aColPos    ) )
   aAdd( ::aOriginal, aClone( ::aJustify   ) )

return nil

//---------------------------------------------------------------------------//

METHOD XEnd() CLASS TShell

   local n
   local nCols := Len( ::aFlds )

   if !::lNoSave

      // Tamaño de las columnas

      ::ActColSizes()

      // Orden de las columnas

      for n := 1 to nCols
         if !::oDbfCol:Seek( cCurUsr() + ::cWinName + Str( n, 2 ) )
            ::oDbfCol:Append()
         end if
         ::oDbfCol:cCodUse    := cCurUsr()
         ::oDbfCol:cNomCfg    := ::cWinName
         ::oDbfCol:nNumCol    := n
         ::oDbfCol:nPosCol    := ::aColPos[ n ]
         ::oDbfCol:lSelCol    := ::aColSelect[ n ]
         ::oDbfCol:nSizCol    := ::aColSizes[ n ]
         ::oDbfCol:lJusCol    := ::aJustify[ n ]
         ::oDbfCol:Save()
      next

      // Guardamos la pos actual -------------------------------------------------

      do case
      case ValType( ::xAlias ) == "O"
         ::nRecno := ::xAlias:RecNo()
      case ValType( ::xAlias ) == "C"
         ::nRecno := (::xAlias)->( RecNo() )
      end case

      ::nTab      := ::oTabs:nOption

      if ::oDbfUsr != nil
         if ::oDbfUsr:Seek( cCurUsr() + ::cWinName )
            ::oDbfUsr:Load()
         else
            ::oDbfUsr:Append()
         end if
         ::oDbfUsr:cCodUse := cCurUsr()
         ::oDbfUsr:cNomCfg := ::cWinName
         ::oDbfUsr:nRecCfg := ::nRecno
         ::oDbfUsr:nTabCfg := ::nTab

         ::oDbfUsr:Save()
      end if

   end if

   ? "desde end"

   ::CloseData()

RETURN ( Super:end() )

//----------------------------------------------------------------------------//

METHOD Destroy() CLASS TShell

   if ::oBrw != nil
      ::oBrw:end()
   end if

   if ::oBtnBar != nil
      ::oBtnBar:end()
   end if

   if ::oBtnTop != nil
      ::oBtnTop:end()
   end if

   if ::oMsgBar != nil
      ::oMsgBar:end()
   end if

   if ::oTabs != nil
      ::oTabs:end()
   end if

   if ::oFont != nil
      ::oFont:end()
   end if

   if ::oIcon != nil
      ::oIcon:end()
   end if

   if ::oCursor != nil
      ::oCursor:end()
   end if

   if ::oTop != nil
      ::oTop:end()
   end if

   if ::oLeft != nil
      ::oLeft:end()
   end if

   if ::oClient != nil
      ::oClient:end()
   end if

   if ::oTxtSea != nil
      ::oTxtSea:end()
   end if

return ( Super:Destroy() )

//----------------------------------------------------------------------------//

METHOD ActColSizes() CLASS TShell

   local nFor
   local n     := 1
   local nLen  := len( ::aFlds )

   /*
   Reescribimos los valores actuales del ancho de columna----------------------
   */

   for nFor := 1 to nLen
      if ::aColSelect[nFor]
         ::aColSizes[nFor] := ::oBrw:aColSizes[n]
         n++
      end if
   next

return nil

//----------------------------------------------------------------------------//

static function _aFld( aFields, aColSel )

   local nFor
   local nLen  := Len( aFields )
   local aFld  := {}

   for nFor = 1 to nLen
      if aColSel[ nFor ]
         aAdd( aFld, Eval( aFields[ nFor ] ) )
      end if
   next

return aFld

//----------------------------------------------------------------------------//

static function _aData( aFields, aColSel )

   local nFor
   local nLen  := Len( aFields )
   local aFld  := {}

   for nFor = 1 to nLen
      if aColSel[ nFor ]
         aAdd( aFld, aFields[ nFor ] )
      end if
   next

return aFld

//----------------------------------------------------------------------------//

static function _aColHead( aHeaders, aColSel )

   local nFor
   local nLen  := Len( aHeaders )
   local aHea  := {}

   for nFor = 1 to nLen
      if aColSel[ nFor ]
         aAdd( aHea, aHeaders[ nFor ] )
      end if
   next

return aHea

//----------------------------------------------------------------------------//

static function _aColSize( aColSizes, aColSel, oBrw )

   local nFor
   local nLen  := Len( aColSizes )
   local aSiz  := {}

   for nFor = 1 to nLen
      if aColSel[ nFor ]
         aAdd( aSiz, aColSizes[ nFor ] )
      end if
   next

return aSiz

//----------------------------------------------------------------------------//

static function _aColJustify( aColJustify, aColSel, oBrw )

   local nFor
   local nLen  := Len( aColJustify )
   local aJus  := {}

   for nFor = 1 to nLen
      if aColSel[ nFor ]
         aAdd( aJus, aColJustify[ nFor ] )
      end if
   next

return aJus

//----------------------------------------------------------------------------//

function SwapUpArray( aArray, nPos )

   local uTmp

   DEFAULT nPos   := len( aArray )

   if nPos <= len( aArray ) .and. nPos > 1
      uTmp              := aArray[nPos]
      aArray[nPos]      := aArray[nPos - 1 ]
      aArray[nPos - 1 ] := uTmp
   end if

return nil

//----------------------------------------------------------------------------//

function SwapDwArray( aArray, nPos )

   local uTmp

   DEFAULT nPos   := len( aArray )

   if nPos < len( aArray ) .and. nPos > 0
      uTmp              := aArray[nPos]
      aArray[nPos]      := aArray[nPos + 1 ]
      aArray[nPos + 1 ] := uTmp
   end if

return nil

//----------------------------------------------------------------------------//