#include "fivewin.ch"
#include "oficebar.ch"


CLASS TCarpeta

      CLASSDATA nInitID         AS NUMERIC INIT 2000
      
      DATA aGrupos              AS ARRAY INIT {}
      DATA bWhen
      DATA cName                AS CHARACTER INIT "oCarpeta"
      DATA cPrompt
      DATA lAjustados           AS LOGICAL INIT .F.
      DATA lEnabled             AS LOGICAL INIT .T.
      DATA nClrBorde            AS NUMERIC INIT RGB( 141, 178, 227 )
      DATA nClrPane0            AS NUMERIC INIT RGB( 218, 229, 243 ) // parte superior de los grupos
      DATA nClrPane1            AS NUMERIC INIT RGB( 199, 216, 237 ) // siguiente 1º del degradado
      DATA nClrPane2            AS NUMERIC INIT RGB( 217, 232, 246 ) // siguiente 2º del degradado
      DATA nClrPane3            AS NUMERIC INIT RGB( 195, 217, 243 ) // parte inferior de los grupos
      DATA nClrSolapa1          AS NUMERIC INIT RGB( 239, 245, 254 )
      DATA nClrSolapa2          AS NUMERIC INIT RGB( 239, 245, 254 )
      DATA nClrText             AS NUMERIC INIT RGB( 141, 178, 227 )
      DATA nID
      DATA nOption              AS NUMERIC INIT 0
      DATA oParent
      DATA rcSolapa             AS ARRAY INIT {0,0,0,0}
      DATA lHide                AS LOGICAL INIT .F.
      DATA bAction
      DATA aColorsTab


      METHOD New( oWnd, cText, lDefine, bAction, aColorsTab ) CONSTRUCTOR
      METHOD Paint( hDC )
      METHOD PintaSolapa( hDC, lSolapa, lOver )

      METHOD CalcSizes()
      METHOD Copy()
      METHOD Edit()
      METHOD End() VIRTUAL
      METHOD GenPrg()
      METHOD HideGroups()
      METHOD IsOverSolapa( nRow, nCol ) INLINE PtInRect( nRow, nCol, ::rcSolapa )
      METHOD RButtonDown( nRow, nCol, nFlags )
      METHOD Search( cGrupo )
      METHOD ShowGroups()
      METHOD oGrupoOver( nRow, nCol )
      METHOD Paste()

ENDCLASS


*****************************************************************************************************
  METHOD New( oWnd, cText, lDefine, bAction, aColorsTab )  CLASS TCarpeta
*****************************************************************************************************

   if cText == nil;   cText   := "item" ;endif
   if lDefine == nil; lDefine := .f.    ;endif

   ::oParent  := oWnd
   ::cPrompt  := cText

   ::nClrBorde    := ::oParent:oColor:_GRISB       //AS NUMERIC INIT RGB( 141, 178, 227 )
   ::nClrPane0    := ::oParent:oColor:P1GRUPOS     //AS NUMERIC INIT RGB( 218, 229, 243 ) // parte superior de los grupos
   ::nClrPane1    := ::oParent:oColor:_GRIS2       //AS NUMERIC INIT RGB( 199, 216, 237 ) // siguiente 1º del degradado
   ::nClrPane2    := ::oParent:oColor:_GRIS3       //AS NUMERIC INIT RGB( 217, 232, 246 ) // siguiente 2º del degradado
   ::nClrPane3    := ::oParent:oColor:_BACKTITLE   //AS NUMERIC INIT RGB( 195, 217, 243 ) // parte inferior de los grupos
   ::nClrSolapa1  := ::oParent:oColor:_GRISBOX2    //AS NUMERIC INIT RGB( 239, 245, 254 )
   ::nClrSolapa2  := ::oParent:oColor:_GRISBOX2    //AS NUMERIC INIT RGB( 239, 245, 254 )
   ::nClrText     := ::oParent:oColor:_GRISB       //AS NUMERIC INIT RGB( 141, 178, 227 )

   if ::nInitID == nil
      ::nInitID  := 20000
   endif

   ::nID      := ::nInitID++

   if !lDefine
      aadd( ::oParent:aCarpetas, self )
      ::oParent:GetCoords()
   endif

   ::bAction := bAction
   ::aColorsTab := aColorsTab

return self


*****************************************************************************************************
      METHOD Paint( hDC )  CLASS TCarpeta
*****************************************************************************************************
local lSelected := .f.
local nTop, nLeft, nBottom, nRight
local hPen, hBrush
local hOldPen, hOldBrush
local n
local nLen := len(::aGrupos)
local lRet
local a := {::oParent:nRow, ::oParent:nCol }
local aPoint := {a[1],a[2]}
local lIsOver
local rc := GetClientRect( ::oParent:hWnd )

// version 1.05 21.12.06
if ::lHide
   return 0
endif


if ::bWhen != nil
   lRet := eval( ::bWhen, self )
   ::lEnabled := lRet
endif


if ::oParent:nOption != 0
   if ::oParent:aCarpetas[::oParent:nOption]:nID == ::nID
      lSelected := .t.
   endif
endif

nTop    := ::rcSolapa[1]
nLeft   := ::rcSolapa[2]
nBottom := ::rcSolapa[3] + 5
nRight  := ::rcSolapa[4]

lIsOver := ::IsOverSolapa( aPoint[1], aPoint[2] ) .and. !lSelected .and. GetActiveWindow() == ::oParent:oWnd:hWnd

//::PintaSolapa( hDC, lSelected, lIsOver )

if lSelected
   if empty( ::aColorsTab )
      FillSolidRect( hDC, {::rcSolapa[3]-2,::rcSolapa[2]+2,::rcSolapa[3]+10,::rcSolapa[4]-2}, ::oParent:oColor:_GRIS1 )
   else
      FillSolidRect( hDC, {::rcSolapa[3]-2,::rcSolapa[2]+2,::rcSolapa[3]-1,::rcSolapa[4]-2}, ::aColorsTab[2] )
      FillSolidRect( hDC, {::rcSolapa[3]-1,rc[2]+4,::rcSolapa[3]+1,rc[4]-3}, ::aColorsTab[2] )
   endif
endif

/*
if lSelected
   FillSolidRect( hDC, {::rcSolapa[3]-2,::rcSolapa[2]+2,::rcSolapa[3]-1,::rcSolapa[4]-2}, if(!empty(::aColorsTab),::aColorsTab[2],::oParent:oColor:_GRIS1) )
endif
*/

if lIsOver
   Box( hDC, {::rcSolapa[3]-3,::rcSolapa[2]+1,::rcSolapa[3]-2,::rcSolapa[4]-1}, RGB( 206,194,151) )
endif

   nLeft := 3
   for n := 1 to nLen

       if lSelected
          ::aGrupos[n]:Show()
          ::aGrupos[n]:Paint( hDC )
       else
          ::aGrupos[n]:Hide()
       endif

   next



return 0


***********************************************************************************************************************
METHOD PintaSolapa( hDC, lSolapa, lOver ) CLASS TCarpeta
***********************************************************************************************************************
local hOldFont, nColor, nMode, hFont
local rc := {::rcSolapa[1],::rcSolapa[2],::rcSolapa[3],::rcSolapa[4]}
local oFont := nil
local nClrPane1     := ::oParent:oColor:nClrPaneSolapa1
local nClrPane2     := ::oParent:oColor:nClrPaneSolapa2
local nClrPane1Over := ::oParent:oColor:nClrPaneSolapaOver1
local nClrPane2Over := ::oParent:oColor:nClrPaneSolapaOver2
local a := {::oParent:nRow, ::oParent:nCol }
local aPoint := {a[1],a[2]}
local lIsOver

// version 1.05 21.12.06
if ::lHide
   return 0
endif


   if lOver == nil; lOver := .f.; endif

   if lOver .or. ( ::oParent:lPaintAll .and. !lSolapa )
      nClrPane1 := nClrPane1Over
      nClrPane2 := nClrPane2Over
   endif

   if ::oParent:oFont != nil
      hFont := ::oParent:oFont:hFont
   else
      DEFINE FONT oFont NAME "Ms Sans Serif" SIZE 0,-12.3
      hFont := oFont:hFont                                 //hFont := GetStockObject( DEFAULT_GUI_FONT )
   endif

   if empty( ::aColorsTab )

      if ( lSolapa .and. !lOver ) .or. ( lOver .and. !lSolapa ) .or. ::oParent:lPaintAll
         VerticalGradient( hDC, { rc[1] + ::oParent:nTopMargin+1, rc[2]+4, rc[3], rc[4] -4}, nClrPane1, nClrPane2 ) //GRIS3
         RoundBox        ( hDC,   rc[2] + 2, rc[1]+::oParent:nTopMargin  , rc[4] -  2, rc[3] + 6, ::oParent:oColor:nCorner1, ::oParent:oColor:nCorner1, ::oParent:oColor:_GRISB )
         RoundBox        ( hDC,   rc[2] + 3, rc[1]+::oParent:nTopMargin+1, rc[4] -  3, rc[3] + 6, ::oParent:oColor:nCorner1, ::oParent:oColor:nCorner1, CLR_WHITE )
      endif

      if lSolapa .and. ::IsOverSolapa( aPoint[1], aPoint[2] )
         VerticalGradient( hDC, { rc[1] + ::oParent:nTopMargin+1, rc[2]+4, rc[3], rc[4] -4}, nClrPane1, nClrPane2 ) //GRIS3
         RoundBox        ( hDC,   rc[2] + 2, rc[1]+::oParent:nTopMargin  , rc[4] -  2, rc[3] + 6, ::oParent:oColor:nCorner1, ::oParent:oColor:nCorner1, ::oParent:oColor:ROUNDBOXCAR1 )
         RoundBox        ( hDC,   rc[2] + 3, rc[1]+::oParent:nTopMargin+1, rc[4] -  3, rc[3] + 6, ::oParent:oColor:nCorner1, ::oParent:oColor:nCorner1, ::oParent:oColor:ROUNDBOXCAR2 )
      endif

   else

      VerticalGradient( hDC, { rc[1] + ::oParent:nTopMargin+1, rc[2]+4, rc[3], rc[4] -4}, ::aColorsTab[1], ::aColorsTab[2] ) //GRIS3

      if ::aColorsTab[3] != nil
         RoundBox        ( hDC,   rc[2] + 2, rc[1]+::oParent:nTopMargin  , rc[4] -  2, rc[3] + 6, ::oParent:oColor:nCorner1, ::oParent:oColor:nCorner1, ::aColorsTab[3] )
      endif

      if ::aColorsTab[4] != nil
         RoundBox        ( hDC,   rc[2] + 3, rc[1]+::oParent:nTopMargin+1, rc[4] -  3, rc[3] + 6, ::oParent:oColor:nCorner1, ::oParent:oColor:nCorner1, ::aColorsTab[4] )
      endif

   endif

   hOldFont := SelectObject( hDC, hFont )

   if empty(::aColorsTab )
      nColor   := SetTextColor( hDC, CLRTEXTTOP )
   else
      nColor   := SetTextColor( hDC, ::aColorsTab[5] )
   endif

   nMode    := SetBkMode( hDC, 1 )

   // version 1.05 21.12.06  +3 -3
   DrawText( hDC, ::cPrompt, {rc[1]+1, rc[2]+ 3, rc[3], rc[4]-3}, nOr( DT_SINGLELINE, DT_VCENTER, DT_CENTER, DT_NOPREFIX, DT_WORD_ELLIPSIS ) )

   SetBkMode( hDC, nMode )
   SetTextColor( hDC, nColor )
   SelectObject( hDC, hOldFont )

   if oFont != nil ;      oFont:End();   endif


return 0


***********************************************************************************************************************
      METHOD HideGroups() CLASS TCarpeta
***********************************************************************************************************************
local n
local nLen := len(::aGrupos)
for n := 1 to nLen
    ::aGrupos[n]:Hide()
next


return 0

***********************************************************************************************************************
      METHOD ShowGroups() CLASS TCarpeta
***********************************************************************************************************************
local n
local nLen := len(::aGrupos)
for n := 1 to nLen
    ::aGrupos[n]:Show()
next

return 0

**********************************************************************************************************************
      METHOD CalcSizes() CLASS TCarpeta
***********************************************************************************************************************
local n
local nLen := len( ::aGrupos )
local nWidth
local lAjustado
local oGrupo


   for n := 1 to nLen
       oGrupo := ::aGrupos[n]
       if oGrupo:lAjustado()
          nWidth := oGrupo:SizeCapSm()[1]
       else
          nWidth := ::aGrupos[n]:nWidth
       endif
       if n > 1
          ::aGrupos[n]:nLeft := ::aGrupos[n-1]:nRight + 3
       endif
       ::aGrupos[n]:nRight := ::aGrupos[n]:nLeft + nWidth
       oGrupo:ResizeItems()
   next


return 0

***********************************************************************************************************************
      METHOD Search( cGrupo ) CLASS TCarpeta
***********************************************************************************************************************
local oGrupo
local n, o
local nLen := len( ::aGrupos )

for n := 1 to nLen
    oGrupo := ::aGrupos[n]
    if alltrim( oGrupo:cPrompt ) == alltrim( cGrupo )
       o := oGrupo
       exit
    endif
next

return o

***********************************************************************************************
  METHOD RButtonDown( nRow, nCol, nOption ) CLASS TCarpeta
***********************************************************************************************
local oPopup
local o := self
local oClp
local cInfo := ""
local lPaste := .f.

  DEFINE CLIPBOARD oClp FORMAT TEXT

  if oClp:Open()
     cInfo := oClp:GetText()
     oClp:End()
  endif

  lPaste := at( "tcarpeta()",lower(cInfo)) == 0 .and. at("tdotnetgroup",lower(cInfo) ) != 0

  MENU oPopup POPUP
     MENUITEM ADDGROUP ACTION ( SetFocus(o:oParent:hWnd ), TDotNetGroup():New( self, 200, "cItem"  ), ::oParent:Refresh())
     SEPARATOR
     MENUITEM "Copy"   ACTION ::Copy()
     if lPaste
        MENUITEM "Paste" ACTION ::Paste()
     endif
  ENDMENU
  ACTIVATE POPUP oPopup AT nRow, nCol OF ::oParent
  SetFocus(::oParent:hWnd )

return 0



***********************************************************************************************************************
   METHOD oGrupoOver( nRow, nCol ) CLASS TCarpeta
***********************************************************************************************************************
local n, nLen, oGrupo

nLen := len( ::aGrupos )

for n := 1 to nLen

    oGrupo := ::aGrupos[n]

    if oGrupo:IsOver( nRow, nCol )
       return oGrupo
    endif

next

return nil

***************************************************************************************************
   METHOD Edit() CLASS TCarpeta
***************************************************************************************************
local oFont
local bValid := {||.t.}
local o := self
local uVar
local nTop, nLeft, nWidth, nHeight

uVar := padr(::cPrompt, 100)

nTop    := ::rcSolapa[1] + 6
nLeft   := ::rcSolapa[2] +4
nWidth  := ::rcSolapa[4]-::rcSolapa[2] -8
nHeight := ::rcSolapa[3]-::rcSolapa[1] -8

DEFINE FONT oFont NAME "Ms Sans Serif" SIZE 0,-10

   ::oParent:oGet := TGet():New(nTop,nLeft,{ | u | If( PCount()==0, uVar, uVar:= u ) },o:oParent,nWidth,nHeight,,,0,16777215,oFont,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,.T.,)

   ::oParent:nLastKey := 0
   ::oParent:oGet:SetFocus()
   ::oParent:oGet:bValid := {|| .t. }

   ::oParent:oGet:bLostFocus := {||  o:oParent:oGet:Assign(),;
                                  o:oParent:oGet:VarPut( o:oParent:oGet:oGet:VarGet() ),;
                                  o:cPrompt := if( o:oParent:nLastKey != VK_ESCAPE, alltrim(o:oParent:oGet:oGet:VarGet()), o:cPrompt ) ,;
                                  o:oParent:GetCoords(), o:oParent:Refresh() }

   ::oParent:oGet:bKeyDown := { | nKey | If( nKey == VK_RETURN .or. nKey == VK_ESCAPE, ( o:oParent:nLastKey := nKey, o:oParent:oGet:End()), ) }



return nil


***************************************************************************************************
   METHOD GenPrg() CLASS TCarpeta
***************************************************************************************************
local cPrg := ""
local n
local nGrupos
local cGrupo := ""
local aGrupos

::cName := "oCarpeta" + + alltrim(str(::nId-2000))

::oParent:cVars += "local " + ::cName + CRLF

cPrg := space( 7 ) + ::cName + " := TCarpeta():New( oBar, " + '"' + ::cPrompt + '"' + " )" + CRLF

nGrupos := len( ::aGrupos )

aGrupos := array( nGrupos )

for n := 1 to nGrupos

    aGrupos[n] := ::aGrupos[n]:GenPrg()

next

for n := 1 to nGrupos

    cGrupo += aGrupos[n]

next


cPrg += cGrupo + CRLF

return cPrg


***************************************************************************************************
   METHOD Copy() CLASS TCarpeta
***************************************************************************************************
local cInfo := ::GenPrg()
local oClp

   DEFINE CLIPBOARD oClp FORMAT TEXT

   if oClp:Open()
      oClp:Clear()
      oClp:SetText( cInfo )
      oClp:End()
   else
      msgStop( "The clipboard is not available now!" )
   endif

return nil

***************************************************************************************************
   METHOD Paste() CLASS TCarpeta
***************************************************************************************************
local cInfo
local aLines := {}
local nLines
local n := 1
local n2
local nEstado := BUSCANDO
local cLinea
local aParams := {}
local cWord
local cObject
local aWords := {{"tdotnetgroup():new(" ,PARSEANDO_GRUPO  }    ,;
                 {"tdotnetbutton():new(",PARSEANDO_BUTTON } }
local cBar
local aCarpetas := {}
local aGrupos   := {}
local o
local lDefinida := .f.
local oError
local oClp

   DEFINE CLIPBOARD oClp FORMAT TEXT

   if oClp:Open()
      cInfo := oClp:GetText()
      oClp:End()
   else
      msgStop( "The clipboard is not available now!" )
   endif


if empty( cInfo )
   MsgInfo("Proceso cancelado")
   return 0
endif

nLines := strcount( cInfo, CRLF )

for n := 1 to nLines
    aadd( aLines, memoline( cInfo,255,n) )
next

n := 1

do while n < nLines .and. nEstado != FIN

    cLinea := alltrim(aLines[n])
    cLinea := strtran(cLinea,'"',"")

    if left( lower(cLinea), len( "local "   )) == "local "   ; cLinea := substr( cLinea, len( "local "   )+1); endif
    if left( lower(cLinea), len( "private " )) == "private " ; cLinea := substr( cLinea, len( "private " )+1); endif
    if left( lower(cLinea), len( "public "  )) == "public "  ; cLinea := substr( cLinea, len( "public "  )+1); endif


    nEstado := BUSCANDO

    cWord := ""

    for n2 := 1 to len( aWords )
        cWord := lower(aWords[n2,1])
        if at( cWord, lower(cLinea) ) != 0
           nEstado := aWords[n2,2]
           exit
        endif
    next

       if nEstado != BUSCANDO

          asize( aParams, 0 )                                             // ? cLinea

          cObject := left  ( cLinea, at(":=",cLinea)-1 )                  // ? cObject
          cLinea  := substr( cLinea, at( lower(cWord), lower(cLinea) )+len(cWord)+1 )
          cLinea  := left  ( cLinea, len( cLinea ) - 1 )                  // ? cLinea
          aParams := aSplit( cLinea, "," )                                // wqout( aParams )


          do case
             case nEstado == PARSEANDO_GRUPO
                  // ( oCarpeta, nWidth, cPrompt, lByLines, bAction, cBmpClosed )

                     o := TDotNetGroup():New( self,;
                                              val( aParams[2]),;
                                              aParams[3],;
                                              lower(aParams[4])==".t.",;
                                              nil,;
                                              aParams[6] )


                     aadd( aGrupos, {cObject, o } )

             case nEstado == PARSEANDO_BUTTON
                  //( nTop, nLeft, nWidth, nHeight, oGroup, cBmp, cCaption, nColumna, bAction, oMenu, bWhen, lGrouping, lHead, lEnd )
                  //  nWidth, oGroup, cBmp, cCaption, nColumna, bAction, oMenu, bWhen, lGrouping, lHead, lEnd

                     o := GetMyObject( aGrupos, aParams[2] )
                     //wqout( aParams )
                     o := TDotNetButton():New( val( aParams[1]),;
                                               o,;
                                               alltrim(aParams[3]),;
                                               alltrim(aParams[4]),;
                                               val(aParams[5]), , , ,;
                                               lower(aParams[9])==".t.",;
                                               lower(aParams[10])==".t.",;
                                               lower(aParams[11])==".t." )
          endcase

       endif


    n++


enddo


::oParent:Refresh()


return 0