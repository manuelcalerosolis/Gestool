/*
旼 Programa 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
�   Aplication: class TLabel                                               �
�         File: LABEL.PRG                                                  �
�       Author: Manuel Calero Solis                                        �
�         Date: 04/24/95                                                   �
�         Time: 20:20:07                                                   �
�    Copyright: by Manuel Calero Solis.                                    �
읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
*/

#include "FiveWin.Ch"
#include "Objects.ch"
#include "Font.ch"
#include "label.ch"

//----------------------------------------------------------------------------//

CLASS TLabel

	  DATA oDevice, oLblWnd, oBrush, oPenHorz
	  DATA aFont, aData, aPen, aDataHeight, aClrText
	  DATA bFor, bWhile , bInit, bEnd, bStartLine, bEndLine, bStartLabel,;
			 bEndLabel, bStartPage, bEndPage, bSkip, bStdFont, bPreview, ;
			 bChange
	  DATA cLblFile, cResName, cFile, cName
	  DATA nWidth, nHeight, nMargin, nRow, nStartRow,;
			 nHSeparator, nVSeparator, nLeftMargin, nRightMargin, nTopMargin,;
			 nDnMargin, nBottomRow, nStdLineHeight, nLogPixX, nLogPixY,;
			 nFirstdrow, nLastdrow, nCounter, nPageWidth, nPage
	  DATA lFinish, lStable, lPrinter, lScreen, lFirstRow, lCreated,;
			 lPreview, lBreak, lSpanish, lShadow, lGrid
	  DATA cargo, nOnLineNow, nItemNow
	  DATA hOldRes
	  DATA nLblHeight, nLblOnLine, nLblWidth, nItems, aoItems, aColumnStart
	  DATA lNoEnd
     DATA nLblCurrent

	  METHOD New( nLblWidth, nLblHeight, nHSeparator, nVSeparator, nLblOnLine,;
					  aFont, aPen, cLblFile, cResName, lPrinter,;
					  lScreen, cFile, oDevice, cName, lNoEnd );
					  CONSTRUCTOR

     //METHOD FromFile() CONSTRUCTOR    Not available yet!
     //METHOD Resource() CONSTRUCTOR    Not available yet!

	  METHOD AddItem(oItem) INLINE Aadd(::aoItems, oItem )

	  METHOD DelItem(nItem) INLINE Adel(::aoItem, nItem ) ,;
												  Asize(::aoItems, len(::aoItems) - 1 )

	  METHOD InsItem(oItem ,;
							 nItem ) INLINE Ains(::aoItems, nItem ) ,;
												  ::aoItems[nItem]:= oItem

	  METHOD Stabilize()
	  METHOD Skip(n)

     METHOD Init()
     METHOD End()

	  METHOD StartLabel(nOnLineNow)
	  METHOD EndLabel(nOnLineNow)

	  METHOD StartLine(nHeight)
	  METHOD EndLine(nHeight)

	  METHOD StartPage()
	  METHOD EndPage()
	  METHOD NeedNewPage() INLINE  ( !::lNoEnd .AND. ( ::nRow >= ::nBottomRow ) )

	  METHOD NewLabel(nHeight)  INLINE ::StartLine(nHeight) ,;
				iif(!::lFirstRow, ::EndLabel(nHeight), )

     METHOD BackLine(nLine) INLINE  ::nRow -= ::nStdLineHeight* ;
				iif(nLine == Nil,1 ,nLine )

     METHOD NewLine(nLine) INLINE  ::nRow += ::nStdLineHeight* ;
				iif(nLine == Nil,1 ,nLine )

     METHOD Activate(bFor, bWhile, bInit, bEnd, bStartPage, ;
				bEndPage, bStartLine, bEndLine, bChange )

     METHOD Play()

     METHOD Margin(nValue,nType,nScale)

     METHOD Say(nCol, xText, nFont, nPad, nRow)

     METHOD SayBitmap(nRow, nCol, cBitmap, nWidth, nHeight, nScale)
	  METHOD Box(nRow, nCol, nBottom, nRight, nPen, nScale )

     METHOD Line( nTop, nLeft, nBottom, nRight, nPen, nScale )
     METHOD Shadow(nHeight)
	  METHOD Grid(nHeight, nItem, nLblOnLine)

	  METHOD Column() INLINE ( ::aColumnStart[::nOnLineNow] )

	  METHOD PhyWidth(nValue, nScale)
	  METHOD PhyHeight(nValue, nScale)

	  METHOD SetTxtColor(nColor,nFont) INLINE                          ;
						  (iif(nColor != NIL .AND.                          ;
								 nFont   > 0   .AND.                          ;
								 nFont   < len(::aClrText)                   ,;
								 ::aClrText[nFont] := nColor, ) )

	  METHOD SetPenColor(nColor)

ENDCLASS

//----------------------------------------------------------------------------//
METHOD New( nLblWidth, nLblHeight, nHSeparator, nVSeparator, nLblOnLine,;
			  aFont, aPen, cLblFile, cResName, lPrinter, lScreen,;
			  cFile, oDevice, cName, lNoEnd )

     LOCAL lFontDefined := .T. ,;
           lPenDefined  := .T.

	  DEFAULT nLblHeight  := 20           ,;
				 nLblWidth   := 120          ,;
				 nLblOnLine  := 2            ,;
				 nHSeparator := 10           ,;
				 nVSeparator := 5            ,;
				 cResName    := ""           ,;
				 lPrinter    := .F.          ,;
				 lScreen     := .F.          ,;
				 cFile       := ""           ,;
				 cName       := "FiveWin Labels",;
				 lNoEnd      := .F.

	  ::cLblFile      = cLblFile
	  ::cResName      = cResName
	  ::lStable       = .F.
	  ::nRow          = 0
	  ::nStartRow     = 0
	  ::nPage         = 0
	  ::nPageWidth    = 0
     ::nLblCurrent   = 1
	  ::nLblOnLine    = nLblOnLine
     ::aoItems       = {}
	  ::aColumnStart  = {}
	  ::nCounter      = 0
	  ::nOnLineNow    = 0
     ::nItemNow      = 0
	  ::bStdFont      = {|| 1 }
	  ::bPreview      = {|oDevice| rPreview(oDevice) }
	  ::lPrinter      = lPrinter
     ::lScreen       = lScreen
     ::lFirstRow     = .T.
     ::lCreated      = .F.
	  ::lPreview      = .F.
     ::lSpanish      = (GetProfString("intl", "sLanguage") == "esp")
     ::lBreak        = .F.
     ::lShadow       = .F.
     ::cFile         = cFile
	  ::cName         = cName
	  ::lNoEnd			= lNoEnd

	  /*
	  Indicar device
	  */

     IF oDevice <> NIL
          ::oDevice := oDevice
     ELSEIF ::lPrinter
			 ::oDevice := TPrinter():New(cName,.F.)
	  ELSEIF ::lScreen
			 ::lPreview := .T.
			 ::oDevice := TPrinter():New(cName,.F.,.T.)
     ELSEIF !empty(::cFile)
          ::oDevice := TRFile():New(::cFile)
     ELSE
          ::oDevice := TPrinter():New(cName,.T.)
     ENDIF

     /*
     Control de que el device es correcto
     */

     IF empty(::oDevice:hDC)
          RETU NIL
     ELSE
          ::lCreated := .T.
     ENDIF

     /*
     Pedir coordenadas del device
     */

     ::nWidth  := ::oDevice:nHorzRes()
     ::nHeight := ::oDevice:nVertRes()

	  /*
	  Pasar los anchos de las etiquetas a pixels
	  */

	  ::nLblHeight    = ::PhyHeight( nLblHeight, RPT_MMETERS )
	  ::nLblWidth     = ::PhyWidth( nLblWidth, RPT_MMETERS )

	  /*
	  Y los Separadores tanto vertical como horizontal
	  */

	  ::nVSeparator   = ::PhyHeight( nVSeparator, RPT_MMETERS )
	  ::nHSeparator   = ::PhyWidth( nHSeparator, RPT_MMETERS )

	  /*
	  Calcular n� de pixels por pulgada del device
     (nLogPixelX y nLogPixelY siempre me devuelven el valor
     de nLogPixelY, cuando p.p.p. es igual en X que en Y no hay
     problema (lasers) pero sin embargo con matriciales no funciona.)
     Por lo que tengo que calcular el dato jugando con las dimensiones
     f죛icas y en pixeles del device.
	  */

     ::nLogPixX := Round(::nWidth/(::oDevice:nHorzSize()/25.4),0)
     ::nLogPixY := Round(::nHeight/(::oDevice:nVertSize()/25.4),0)

     /*
     Si no ha especificado font asignar ARIAL 10
     */

     IF len(aFont) == 0
          lFontDefined := .F.
          Asize(aFont,1)
          DEFINE FONT aFont[1] NAME "Arial" SIZE 0,-10
     ENDIF

     /*
     Crear pen para las lineas horizontales
     */

     DEFINE PEN ::oPenHorz ;
            STYLE 0 ;
            WIDTH Int(1*::nLogPixX/72) ;
            COLOR CLR_BLACK

	  /*
	  Si no se ha especificado pen crearlo (por si acaso)
	  */

     IF len(aPen) == 0
          lPenDefined := .F.
          Asize(aPen,1)
          DEFINE PEN aPen[1] STYLE 0 WIDTH 1 COLOR CLR_BLACK
     ENDIF

     /*
     Crear nuevos fonts basandonos en el Device para ajustar
     el tama쨚 de los mismos al device elegido
     */

     ::aFont := Array(len(aFont))

     Aeval(aFont                                       ,;
          {|val,elem|                                   ;
          ::aFont[elem]:= TFont():New(val:cFaceName    ,;
			 Int(val:nWidth*::nLogPixX/72)                ,;
          Int(val:nHeight*::nLogPixY/72)               ,;
          .F.                                          ,;
          val:lBold                                    ,;
          val:nEscapement                              ,;
          val:nOrientation                             ,;
          val:nWeight                                  ,;
          val:lItalic                                  ,;
          val:lUnderline                               ,;
          val:lStrikeOut                               ,;
          val:nCharSet                                 ,;
          val:nOutPrecision                            ,;
          val:nClipPrecision                           ,;
          val:nQuality) })

     IF !lFontDefined
          aFont[1]:end()
     ENDIF

     /*
     Crear nuevos Pens basandonos en el device
     */

     ::aPen := Array(len(aPen))

     Aeval(aPen, {|val,elem|                             ;
                 ::aPen[elem] := Tpen():New( val:nStyle ,;
                 Int(val:nWidth*::nLogPixX/72)          ,;
                 val:nColor)} )

     IF !lPenDefined
          aPen[1]:end()
     ENDIF

     /*
     Crear Matriz de colores para impresi줻 de texto
     */

     ::aClrText := Array(len(::aFont))

     Aeval(::aClrText,{|val,elem| ::aClrText[elem] := CLR_BLACK })

     /*
     Establecer margenes de impresi줻 a 0,2 pulgadas
     */

     ::nLeftMargin  := Int(::nLogPixX*0.2)
     ::nRightMargin := Int(::nLogPixX*0.2)
     ::nTopMargin   := Int(::nLogPixY*0.2)
     ::nDnMargin    := Int(::nLogPixY*0.2)

RETURN Self

//----------------------------------------------------------------------------//

METHOD Margin(nValue, nType, nScale) CLASS TLabel

     DEFAULT nValue := .2     ,;
             nType  := RPT_LEFT   ,;
				 nScale := RPT_MMETERS

     IF nScale == RPT_CMETERS
			 nValue := nValue/2.54
	  ELSEIF nScale == RPT_MMETERS
			 nValue := nValue/25.4
	  ENDIF

     DO CASE
     CASE nType == RPT_TOP
          ::nTopMargin   := Int(::nLogPixY*nValue)
     CASE nType == RPT_BOTTOM
          ::nDnMargin    := Int(::nLogPixY*nValue)
     CASE nType == RPT_LEFT
          ::nLeftMargin  := Int(::nLogPixX*nValue)
     CASE nType == RPT_RIGHT
          ::nRightMargin := Int(::nLogPixX*nValue)
     ENDCASE

     ::lStable := .F.

RETURN Self

//----------------------------------------------------------------------------//

METHOD Say( nRow, nCol, xText, nFont, nPad ) CLASS TLabel

     LOCAL nFor
     LOCAL nStartCol
     LOCAL cText
     LOCAL nWidth
     LOCAL cLine
     LOCAL nMemLine

     DEFAULT nCol  := 1       ,;
             nFont := 1       ,;
             xText := ""      ,;
				 nRow  := ::nRow  ,;
				 nPad  := 1

	  IF nCol <1 .OR. nCol > len(::aColumnStart)
			 nCol := 1
	  ENDIF

     IF nFont <1 .OR. nFont > len(::aFont)
          nFont := 1
     ENDIF

     cText  := cValToChar(xText)
     nWidth := ::oDevice:GetTextWidth(cText,::aFont[nFont])

     DO CASE

          CASE nPad == RPT_LEFT
					nStartCol := ::aColumnStart[nCol]

          CASE nPad == RPT_RIGHT
               nStartCol := ::aColumnStart[nCol] + ::aoItems[nCol]:nWidth - nWidth

          CASE nPad == RPT_CENTER
               nStartCol := ::aColumnStart[nCol] + Int( ::aoItems[nCol]:nWidth / 2 ) - Int( nWidth / 2 )
			 OTHERWISE
					nStartCol := ::aColumnStart[nCol]
	  ENDCASE

     ::oDevice:Say(nRow, nStartCol, cLine, ::aFont[nFont], nil, ::aClrText[nFont] )

RETURN Self

//----------------------------------------------------------------------------//

METHOD SayBitmap(nRow, nCol, cBitmap, nWidth, nHeight, nScale) CLASS TLabel

     LOCAL nPixRow, nPixCol, nPixWidth, nPixHeight

     DEFAULT nRow    := .2       ,;
             nCol    := .2       ,;
             nWidth  := 1        ,;
             nHeight := 1        ,;
             nScale  := RPT_INCHES

     IF nScale == RPT_CMETERS
          nRow := Int(nRow/2.54)
          nCol := Int(nCol/2.54)
          nWidth := Int(nWidth/2.54)
			 nHeight := Int(nHeight/2.54)
	  ELSEIF nScale == RPT_MMETERS
			 nRow := Int(nRow/25.4)
			 nCol := Int(nCol/25.4)
			 nWidth := Int(nWidth/25.4)
			 nHeight := Int(nHeight/25.4)
	  ENDIF

     nPixRow    := Int(::nLogPixY*nRow)
     nPixCol    := Int(::nLogPixX*nCol)
     nPixWidth  := Int(::nLogPixX*nWidth)
     nPixHeight := Int(::nLogPixY*nHeight)

     ::oDevice:SayBitmap(nPixRow, nPixCol, cBitmap, nPixWidth, nPixHeight)

RETURN Self

//----------------------------------------------------------------------------//

METHOD Box(nRow, nCol, nBottom, nRight, nPen, nScale ) CLASS TLabel

     LOCAL nPixRow, nPixCol, nPixBottom, nPixRight

     DEFAULT nRow    := .2   ,;
             nCol    := .2   ,;
             nBottom := 5    ,;
             nRight  := 5    ,;
             nPen    := 1    ,;
             nScale  := RPT_INCHES

     IF nScale == RPT_CMETERS
          nRow    := Int(nRow/2.54)
          nCol    := Int(nCol/2.54)
          nBottom := Int(nBottom/2.54)
			 nRight  := Int(nRight/2.54)
	  ELSEIF nScale == RPT_MMETERS
			 nRow := Int(nRow/25.4)
			 nCol := Int(nCol/25.4)
			 nBottom := Int(nBottom/25.4)
			 nRight  := Int(nRight/25.4)
	  ENDIF

	  nPixRow    := Int(::nLogPixY*nRow)
	  nPixCol    := Int(::nLogPixX*nCol)
	  nPixBottom := Int(::nLogPixY*nBottom)
	  nPixRight  := Int(::nLogPixX*nRight)

     ::oDevice:Box(nPixRow, nPixCol, nPixBottom, nPixRight, ::aPen[nPen])

RETURN Self

//----------------------------------------------------------------------------//

METHOD Line( nTop, nLeft, nBottom, nRight, nPen, nScale ) CLASS TLabel

	  LOCAL nPixTop, nPixLeft, nPixBottom, nPixRight

     DEFAULT nTop    := .2   ,;
             nLeft   := .2   ,;
             nBottom := 5    ,;
             nRight  := 5    ,;
             nPen    := 1    ,;
             nScale  := RPT_INCHES

     IF nScale == RPT_CMETERS
          nTop    := Int(nTop/2.54)
          nLeft   := Int(nLeft/2.54)
          nBottom := Int(nBottom/2.54)
			 nRight  := Int(nRight/2.54)
	  ELSEIF nScale == RPT_MMETERS
			 nTop    := Int(nTop/25.4)
			 nLeft   := Int(nLeft/25.4)
			 nBottom := Int(nBottom/25.4)
			 nRight  := Int(nRight/25.4)
	  ENDIF

     nPixTop    := Int(::nLogPixY*nTop)
     nPixLeft   := Int(::nLogPixX*nLeft)
     nPixBottom := Int(::nLogPixY*nBottom)
     nPixRight  := Int(::nLogPixX*nRight)

     ::oDevice:Line(nPixTop, nPixLeft, nPixBottom, nPixRight, ::aPen[nPen])

RETURN Self

//----------------------------------------------------------------------------//

METHOD Shadow(nHeight, nItem, nLblOnLine) CLASS TLabel

	  IF ::oBrush == NIL
          DEFINE BRUSH ::oBrush COLOR CLR_LIGHTGRAY
     ENDIF

	  ::oDevice:FillRect({::nRow            ,;
				  ::aColumnStart[nLblOnLine]   ,;
				  ::nRow+nHeight               ,;
				  ::aColumnStart[nLblOnLine]+::aoItems[nItem]:nWidth} ,;
				  ::oBrush)

RETURN Self

//----------------------------------------------------------------------------//

METHOD Grid (nHeight, nItem, nLblOnLine) CLASS TLabel

		::oDevice:line(::nRow + nHeight ,;
							::aColumnStart[nLblOnLine] ,;
							::nRow + nHeight ,;
							::aColumnStart[nLblOnLine] + ::aoItems[nItem]:nWidth ,;
							::aPen[ ::aoItems[nItem]:nPen ] )

RETURN Self

//----------------------------------------------------------------------------//

METHOD Activate(bFor, bWhile, bInit, bEnd, bStartPage, ;
					 bEndPage, bStartLabel, bEndLabel, bStartLine, ;
					 bEndLine, bChange  ) CLASS TLabel

	  LOCAL oPagina

     DEFAULT bFor     := {|| .T.    } ,;
             bWhile   := {|| !eof() }

     /*
     ::hOldRes := GetResources()

     SET RESOURCES TO "Preview.dll"
     */

     ::bFor        = bFor
     ::bWhile      = bWhile
     ::bInit       = bInit
     ::bEnd        = bEnd
     ::bStartPage  = bStartPage
     ::bEndPage    = bEndPage
	  ::bStartLabel = bStartLabel
	  ::bEndLabel   = bEndLabel
	  ::bStartLine  = bStartLine
	  ::bEndLine    = bEndLine
     ::bChange     = bChange

     /*
     Estabilizar el listado
     */

     IF !::lCreated
			::End()
			RETU NIL
	  ENDIF

     ::Stabilize()

     IF !::lStable
			 ::End()
          RETU NIL
     ENDIF

     /*
     Creaci줻 de la ventana de impresi줻
     */

	IF !::lPreview

		DEFINE DIALOG ::oLblWnd TITLE ::cName RESOURCE "PRINT_PROC"

		REDEFINE BUTTON ID IDCANCEL OF ::oLblWnd ;
			ACTION (::lBreak := .T., ::oLblWnd:End())

		REDEFINE SAY oPagina VAR ::nPage ID 101 OF ::oLblWnd

		::oLblWnd:bPainted := {|| iif(::nPage>0,oPagina:Refresh(), )}

		::oLblWnd:bStart := {|| ::Play(),::oLblWnd:End()}

		ACTIVATE DIALOG ::oLblWnd CENTER

   ELSE

		DEFINE DIALOG ::oLblWnd TITLE ::cName RESOURCE "PREVIEW_PROC"

		REDEFINE BUTTON ID IDCANCEL OF ::oLblWnd ;
			ACTION (::lBreak := .T., ::oLblWnd:End())

		REDEFINE SAY oPagina VAR ::nPage ID 101 OF ::oLblWnd

		::oLblWnd:bPainted := {|| iif(::nPage>0,oPagina:Refresh(), )}

		::oLblWnd:bStart := {|| ::Play(),::oLblWnd:End()}

		ACTIVATE DIALOG ::oLblWnd CENTER

      Eval(::bPreview,::oDevice)

   ENDIF

RETURN Self

//----------------------------------------------------------------------------//

METHOD Play() CLASS TLabel

   local n := 0
   LOCAL nItems, nFor

   /*
   Inicializar variables
   */

   nItems    := len(::aoItems)

   /*
   Comienzo de la Impresi줻
   */

   ::StartPage()

   ::Init()

   /*
   Bucle de rastreo
   */

   DO WHILE !::lBreak .AND. eval(::bWhile)

      /*
      Comprobar condici줻 for
      */

      if eval(::bFor)

         /*
         Retomamos la linea anterior
         */

         ::nRow := ::nStartRow

         /*
         Aviso del comienzo de las etiquetas
         */

         ::StartLabel( ::nLblCurrent )

         /*
         Imprimimos tantas lineas como tenga la etiqueta en las
         posiciones anteriormente calculadas.
         */

         for nFor := 1 to ::nItems

            if ::aoItems[nFor]:lGrid
               ::Grid( ::aoItems[nFor]:nDataHeight, nFor, ::nLblCurrent )
            endif

            if ::aoItems[nFor]:lShadow
               ::Shadow( ::aoItems[nFor]:nDataHeight, nFor, ::nLblCurrent )
            endif

            ::aoItems[nFor]:SayData( ::nRow, ::aColumnStart[::nLblCurrent] )

            ::EndLine( ::aoItems[nFor]:nDataHeight, nFor )

         next

         /*
         Aviso de finalizacion de la etiqueta
         */

         ::EndLabel(::nLblCurrent)

         ::nLblCurrent++

         if ::nLblCurrent > ::nLblOnLine

            ::nLblCurrent  := 1

            /*
            Avance de Linea := Linea Actual + Altura de Label + Separacion Vertical
            */

            ::nRow      := ::nStartRow + ::nLblHeight + ::nVSeparator

            /*
            Cuando finalice la etiqueta posicionamos en la linea para
            la etiqueta siguiente
            */

            ::nStartRow := ::nRow

            /*
            Comprobamos la necesidad de una nueva pagina
            */

            if ::NeedNewPage()
               ::EndPage()
            end if

         end if

      end if

      /*
      Refresh
      */

      SysRefresh()

      /*
      Skip
      */

      ::Skip(1)

   ENDDO

   ::End()

RETURN Self

//----------------------------------------------------------------------------//

METHOD Stabilize() CLASS TLabel

   LOCAL nFor1, nMaxHeight, nPrnWidth, nColStart

   nMaxHeight := 0

   ::nItems   := len(::aoItems)

   IF ::nItems == 0
        ::lCreated := .F.
        Retu (NIL)                           // No hay columnas
   ENDIF

   /*
   C쟫culo del alto standard de una linea
   */

   ::nStdLineHeight := ::oDevice:GetTextHeight("B",::aFont[eval(::bStdFont)])

   /*
   Estabilizar objetos
   */

   Asend(::aoItems, "Stabilize")

   /*
   Calculamos la altura maxima de la etiqueta
   */

   AEval( ::aoItems, {|val| nMaxHeight += val:nDataHeight } )

   /*
   Comprobamos que no exista ningun campo de mayor tama쨚 q el ancho
   de la etiqueta, caso de que esto sea asi, llevamos el ancho hasta
   la longuitud maxima de la etiqueta.
   */

   FOR nFor1 := 1 TO ::nItems

      IF ::aoItems[nFor1]:nWidth > ::nLblWidth
         ::aoItems[nFor1]:nWidth := ::nLblWidth
      END IF

   NEXT

   /*
   Comprobar si hay alguna columna con Sombra
   */

   ::lShadow := .F.
   aeval(::aoItems, {|Val| iif(Val:lShadow,::lShadow := .T. ,NIL ) })

   /*
   Comprobar si hay alguna columna con Grid
   */

   ::lGrid := .F.
   AEval(::aoItems, {|Val| iif(Val:lGrid,::lGrid := .T. ,NIL ) })

   /*
   C쟫culo del ancho del Listado
   */

   aeval(::aoItems, {|Val| ::nPageWidth += Val:nWidth + ::nHSeparator })

   ::nPageWidth -= ::nHSeparator

   ::nWidth := min(::nPageWidth, ::nWidth)

	/*
	Margen del Listado
	*/

	nPrnWidth := ::nWidth - ::nLeftMargin - ::nRightMargin
	::nMargin := max( Int( (nPrnWidth - ::nPageWidth) /2 ), 0) + ::nLeftMargin

	/*
	Calculo de las distintas coordenadas de los campos del listado
	*/

	nColStart := ::nMargin

	FOR nFor1 := 1 TO ::nLblOnLine

		Aadd( ::aColumnStart, nColStart )
		nColStart += ( ::nLblWidth + ::nHSeparator )

	NEXT

	/*
	Inicializar variables de coordenadas
	*/

   Aeval(::aoItems, {|val| nMaxHeight := Max( nMaxHeight, val:nDataHeight) })

	/*
	Calcular coordenadas de impresi줻 de datos.
	En el caso de las Etiquetas tan solo respetar los margenes.
	*/

	::nBottomRow := ::nHeight - ::nDnMargin

	::nFirstdRow := ::nTopMargin
	::nLastdRow  := ::nDnMargin

	/*
	Indicar que ya esta estable
	*/

	::lStable := .T.
	::lFinish := .F.

RETURN (NIL)

//----------------------------------------------------------------------------//

METHOD Init() CLASS TLabel

     IF ::bInit != nil
          Eval( ::bInit )
     ENDIF

RETURN Self

//----------------------------------------------------------------------------//

METHOD End() CLASS TLabel

     ::lFinish := .T.

	  IF !::lCreated .OR. !::lStable

        IF ::oBrush != NIL
            ::oBrush:end()
        ENDIF
        Asend(::aFont,"End")
        Asend(::aPen,"End")

        if ::oPenHorz != nil
           ::oPenHorz:End()
        endif

        ::oDevice:End()

        /*
        SetResources(::hOldRes)
        */

        RETU NIL

	  ENDIF

     IF !::lBreak .AND. ::bEnd != nil
          Eval( ::bEnd )
     ENDIF

     ::EndPage()

	  SetResources(::hOldRes)

     IF !::lPreview
          ::oDevice:End()
     ENDIF

     IF ::oBrush != NIL
          ::oBrush:end()
     ENDIF

     Asend(::aFont,"End")
     Asend(::aPen,"End")

     ::oPenHorz:End()

RETURN Self

//----------------------------------------------------------------------------//

METHOD Skip( n ) CLASS TLabel

     STATIC lRunning := .F.

     ::nCounter++

     IF ::bChange != nil .AND. !lRunning
          lRunning := .T.
          Eval( ::bChange )
          lRunning := .F.
     ENDIF

     IF ::bSkip != nil
			 retu Eval( ::bSkip, n )
	  ENDIF

RETURN DbSkip( n )

//----------------------------------------------------------------------------//

METHOD StartPage() CLASS TLabel

     STATIC lRunning := .F.

     ::oDevice:StartPage()

	  /*
	  Colocamos como linea actual y linea de comienzo el margen superior
	  */

	  ::nRow :=	::nStartRow := ::nTopMargin

	  /*
	  Una nueva pagina
	  */

     ::nPage++

	  ::oLblWnd:Refresh()

     IF ::bStartPage != nil .AND. !lRunning
          lRunning := .T.
          Eval( ::bStartPage )
          lRunning := .F.
     ENDIF

	  ::lFirstRow := .T.

RETURN Self

//----------------------------------------------------------------------------//

METHOD EndPage() CLASS TLabel

     STATIC lRunning := .F.

     IF ::bEndPage != nil .AND. !lRunning
          lRunning := .T.
          Eval( ::bEndPage )
          lRunning := .F.
     ENDIF

	  ::oDevice:EndPage()

	  IF !(::lFinish)
          ::StartPage()
     ENDIF

RETURN Self

//----------------------------------------------------------------------------//

METHOD StartLine(nHeight)

     STATIC lRunning := .F.

     DEFAULT nHeight := ::nStdLineHeight

	  IF !::lNoEnd .AND. ( ( nHeight + ::nRow ) >= ::nBottomRow )
			 ::EndPage()
	  ENDIF

     IF ::bStartLine != nil .AND. !lRunning
          lRunning := .T.
          Eval( ::bStartLine)
          lRunning := .F.
     ENDIF

RETURN Self

//----------------------------------------------------------------------------//

METHOD EndLine(nHeight, nItem)

     STATIC lRunning := .F.

     DEFAULT nHeight := ::nStdLineHeight

	  /*
	  Avance de una linea
	  */

	  ::nRow      += nHeight

	  /*
	  Guardamos el valor del campo procesado por si algien lo
	  quiere usar, puede ser interesante
	  */

	  ::nItemNow := nItem

	  IF ::bEndLine != nil .AND. !lRunning
			 lRunning := .T.
          Eval( ::bEndLine)
          lRunning := .F.
     ENDIF

	  ::lFirstRow := .F.

RETURN Self

//----------------------------------------------------------------------------//

METHOD StartLabel(nOnLineNow) CLASS TLabel

     STATIC lRunning := .F.

	  /*
	  Guardamos el valor de la etiqueta que esta siendo procesada
	  */

	  ::nOnLineNow := nOnLineNow

	  IF ::bStartLabel != nil .AND. !lRunning
			 lRunning := .T.
			 Eval( ::bStartLabel)
          lRunning := .F.
     ENDIF

RETURN Self

//----------------------------------------------------------------------------//

METHOD EndLabel(nOnLineNow) CLASS TLabel

	  STATIC lRunning := .F.

	  /*
	  Guardamos el valor de la etiqueta que esta siendo procesada
	  */

	  ::nOnLineNow := nOnLineNow

	  IF ::bEndLabel != nil .AND. !lRunning
			 lRunning := .T.
			 Eval( ::bEndLabel)
			 lRunning := .F.
	  ENDIF

	  ::lFirstRow := .F.

RETURN Self

//----------------------------------------------------------------------------//

METHOD PhyWidth(nValue, nScale) CLASS TLabel

		LOCAL nHorzSize := ( ::oDevice:nHorzRes() / ::oDevice:nHorzSize() )
		LOCAL nRetValue := 0

		DEFAULT nValue  := 1
		DEFAULT nScale  := RPT_MMETERS

		IF nScale == RPT_INCHES

			 nRetValue := nValue * nHorzSize * 25.4

		ELSEIF nScale == RPT_CMETERS

			 nRetValue := nValue * nHorzSize * 10

		ELSEIF nScale == RPT_MMETERS

			 nRetValue := nValue * nHorzSize

		END IF

RETURN Round( nRetValue, 0 )

//----------------------------------------------------------------------------//

METHOD PhyHeight(nValue, nScale) CLASS TLabel

		LOCAL nVertSize := ( ::oDevice:nVertRes() / ::oDevice:nVertSize() )
		LOCAL nRetValue := 0

		DEFAULT nValue  := 1
		DEFAULT nScale  := RPT_MMETERS

		IF nScale == RPT_INCHES

			 nRetValue := nValue * nVertSize * 25.4

		ELSEIF nScale == RPT_CMETERS

			 nRetValue := nValue * nVertSize * 10

		ELSEIF nScale == RPT_MMETERS

			 nRetValue := nValue * nVertSize

		END IF

RETURN Round( nRetValue, 0 )

//----------------------------------------------------------------------------//

METHOD SetPenColor(nColor)

     IF nColor == NIL
          RETU NIL
     ENDIF

     ::oPenHorz:End()

     DEFINE PEN ::oPenHorz ;
            STYLE 0 ;
            WIDTH Int(1*::nLogPixX/72) ;
            COLOR nColor

RETURN Self

//----------------------------------------------------------------------------//