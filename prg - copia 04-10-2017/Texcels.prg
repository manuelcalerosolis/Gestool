/*
 * Clase TExcelScript v1.12a  04-Dic-2003
 *
 * Esta Clase usa la Libreria Ole2 de José F. Giménez
 *
 * Autor: Víctor Manuel Tomas Díaz [Vikthor]
 *
 * Modificaciones y agregados realizadas por:
 * Daniel Andrade - [AD2K] 26/08/2002
 * Rimantas Usevicius - [RimUs] 25-09-2002
 * Carlos Sincur Romero - [CSR] 4/9/2002
 * El Browse es un concepto original de René Flores , adaptado a esta clase.
 *
 * Nuevos metodos   [ Vikthor ]   7-Oct-2003
   ++ METHOD Headers( nOpc , cVal )
   ++ METHOD Footers( nOpc , cVal )
   ++ METHOD Margins( nOpc , nVal )
   ++ METHOD SetPrintArea(cRange)
   ++ METHOD lCenterH( lCenter)
   ++ METHOD lCenterV( lCenter)
   ++ METHOD Zoom( nZoom )
   ++ METHOD SetPage( nPage  )

 * Nuevos metodos   [ Vikthor ]   10-Nov-2003
   ++ METHOD SendMail( cMail , cSubject , lReturn )
   ++ METHOD MailSystem()     // Devuelve el sistema de correo de la maquina
   ++ METHOD WebPagePreview() // Genera una vista en HTML del libro.
   ++ METHOD AddPicture( cFile, nRow , nCol , nWidth , nHeight ) // Agrega un imagen
   ++ METHOD AddShape( nShape, nLeft , nTop , nWidth , nHeight ) // Agrega un forma
   ++ METHOD Dialog( nTypeDlg )

 * Nuevos metodos   [ AD2K ]   04-Dic-2003
   ++ METHOD Get()            // Metodo Alternativo (ver al final) tiene encuenta los decimales
   ++ METHOD Copy() y Paste() // Metodos Faltantes de versiones anteriores

// [eof]

 */

# include "FiveWin.Ch"

/*
 *  TExcelScript()
 */
CLASS TExcelScript

  DATA oExcel
  DATA oBook
  DATA oSheet
  DATA oShape
  DATA oCell
  DATA oFind
  DATA cFile

  DATA cFont
  DATA nSize
  DATA lBold
  DATA lItalic
  DATA lUnderLine
  DATA nAlign
  DATA lOpen      AS LOGICAL    INIT .F.
  DATA lDefault   AS LOGICAL    INIT .T.

  DATA aExcelCols AS ARRAY INIT {}
  DATA aData      AS ARRAY INIT {}
  DATA cAlias
  DATA nAt
  DATA nFormat

  METHOD New()
  METHOD Open( cFilexls )
  METHOD Create( cFilexls )
  METHOD Get( nRow , nCol ,cValue )
  METHOD Say( nRow, nCol, xValue, cFont, nSize, lBold, lItalic, ;
              lUnderLine, nAlign, nColor, nFondo , nBorder )

  METHOD CellFormat( nRow, nCol, nBackGround, nLine, cFormat )
  METHOD Borders( cRange, nRow, nCol, nStyle )
  METHOD GetCell()          INLINE (::oCell := ::oExcel:Get( "ActiveCell" ), ::oCell)
  METHOD Visualizar(lValue) INLINE ::oExcel:Visible := lValue
  METHOD nRows INLINE   :: oExcel : oSheet : UsedRange : Rows : Count()
  METHOD nCols INLINE   :: oExcel : oSheet : UsedRange : Columns : Count()



  METHOD AutoFit( nCol )    INLINE ::oSheet:Columns( nCol ):AutoFit()
  METHOD Save()             INLINE IIF( ::lOpen , ::oBook:Save(), ::oBook:SaveAs( ::cFile , ::nFormat ) )
  METHOD SaveAs( cFilexls , nFormat ) INLINE ::oBook:SaveAs( cFilexls , nFormat )

  METHOD Print()
  METHOD SetFont(cFont)     INLINE ::oSheet:Cells:Font:Name := cFont
  METHOD SizeFont(nSize)    INLINE ::oSheet:Cells:Font:Size := 12
  METHOD Font(cFont)        INLINE ::cFont := cFont
  METHOD Size(nSize)        INLINE ::nSize := nSize
  METHOD Align(nPos)        INLINE ::nAlign := nPos
  METHOD AddCol( bAction , nAlign , bClrText , bClrPane , bHeading , bFooting )
  METHOD Browse( nRow , nCol , cAlias , cFont , nSize , bClrText , bClrPane  )
  METHOD SetArray(aArray)   INLINE ::aData := aArray

  METHOD Headers( nOpc , cVal )
  METHOD Footers( nOpc , cVal )
  METHOD Margins( nOpc , nVal )
  METHOD SetPrintArea(cRange)     INLINE ::oSheet:PageSetup:Set( "printarea"  , cRange )
  METHOD lCenterH( lCenter)       INLINE ::oSheet:PageSetup:Set( "CenterHorizontally" , lCenter )
  METHOD lCenterV( lCenter)       INLINE ::oSheet:PageSetup:Set( "CenterVertically" , lCenter )
  METHOD Zoom( nZoom )            INLINE ::oSheet:PageSetup:Set( "Zoom" , nZoom )
  METHOD SetPage( nPage  )        INLINE ::oSheet:PageSetup:Set( "PaperSize" , nPage )

  /*
   * Metodos para las propiedades de la hoja
   */
  METHOD AddSheet()         INLINE ::oExcel:Sheets:Add()
  METHOD CopySheet()        INLINE ::oExcel:Sheets:Copy()
  METHOD DelSheet(cSheet)   INLINE ::oExcel:Sheets(cSheet):Delete()

  // cPos -> "After" | "Before"
  METHOD MoveSheet(cSheet,cPos,nSheet)  INLINE ::oExcel:Sheets(cSheet):Move(cPos,nSheet)
  METHOD SetSheet(cSheet)               INLINE ::oExcel:Sheets(cSheet):Select() , ::oSheet := ::oExcel:Get( "ActiveSheet" )
  METHOD NameSheet(cSheet,cName)        INLINE ::oExcel:Sheets(cSheet):Name := cName
  METHOD MultiLine(nRow , nCol )        INLINE ::oSheet:Cells( nRow, nCol ):Set("WrapText",.T.)
  METHOD RanMultiLine( cRange )         INLINE ::oSheet:Range( cRange ):Set("WrapText",.T.)
  METHOD AddComent( nRow, nCol, cText )
  METHOD Combinar( cRange )             INLINE ::oSheet:Range( cRange ):Merge()
  METHOD RangeFondo( cRange, nColor )
  METHOD ColumnWidth( nCol, nWidth )    INLINE ::oSheet:Columns( nCol ):Set("ColumnWidth",Alltrim(Str(nWidth)))
  METHOD Subtotal(cRange, nGroup, nOpe, nCol)
  METHOD AutoFilter(cRange, nCol, uVal) INLINE ::oSheet:Range( cRange ):AutoFilter(nCol,uVal)
  METHOD End( lClose )
  METHOD ReadOnly( lMsg )

  // ***** Agregados[AD2K] *******
  MESSAGE Eval()	            METHOD eEval( cCommand, lOemAnsi )

  METHOD SetPos( cRange )     INLINE (::oSheet:Range( cRange ):Select(), ::GetCell())
  METHOD InsertRow( cRange )  INLINE (iif( cRange != NIL, ::SetPos( cRange ),), ::GetCell():EntireRow():Insert())
  METHOD InsertCol( cRange )  INLINE (iif( cRange != NIL, ::SetPos( cRange ),), ::GetCell():Get("EntireColumn"):Insert())

  METHOD Find( cSearch, lMatch, lPart )
  METHOD FindNext()
  METHOD Replace( cSearch, cReplace, lMatch, lPart, lAll, lFull, cFormat )

  METHOD Duplicate( cRange )
  MESSAGE Clear()             METHOD eClear( cRange )
  // *****************************

  METHOD Chart( cRange , cTitle , nType ) //  [RimUs]

  // ****** Agregados [CSR] ******
  METHOD Picture( cFile, cRange )  INLINE (iif( cRange != NIL, ::SetPos(cRange ),), ::oSheet:Pictures:insert(cFile) )
  METHOD SetLandScape()      INLINE ::oSheet:PageSetup:Set("Orientation",2 )
  METHOD SetPortrait()       INLINE ::oSheet:PageSetup:Set("Orientation",1 )
  METHOD Copy( cRange )
  METHOD Paste()
  // *****************************

  // ****** Agregados [Salo] ******
  METHOD nRowsCount() INLINE ::oSheet:UsedRange:Rows:Count()
  METHOD nColsCount() INLINE ::oSheet:UsedRange:Columns:Count()

  // ****** Agregados [Daniel] *****
  METHOD TitleRows(cRange) INLINE (iif(cRange!=NIL,::oSheet:PageSetup:Set("PrintTitleRows",cRange), Nil))


  METHOD SendMail( cMail , cSubject , lReturn )    // [ Vikthor ]
  METHOD MailSystem()                              // [ Vikthor ]
  METHOD WebPagePreview() INLINE ::oBook:Get("WebPagePreview") // [ Vikthor ]
  METHOD AddPicture( cFile, nRow , nCol ) // [ Vikthor ]
  METHOD AddShape( nShape, nLeft , nTop , nWidth , nHeight ) INLINE ::oShape:AddShape( nShape , nLeft , nTop , nWidth , nHeight ) // [ Vikthor ]
  METHOD Dialogs( nTypeDlg ) INLINE ::oExcel:Dialogs(nTypeDlg):Show() // [ Vikthor ]
  METHOD SendeMail( cSender, cSubject, lShowMessage, lIncludeAttachment) // [ Vikthor ]

ENDCLASS
/*
 *  TExcelScript():New()
 */
METHOD New() CLASS TExcelScript

  ::oExcel := TOleAuto():New("Excel.Application")
  ::aExcelCols := {}

RETURN Self

/*
 *  TExcelScript():Open()
 */
METHOD Open( cFilexls )  CLASS TExcelScript
  LOCAL lNotify  := .T.
  LOCAL lAddToMRU := .T.
  ::cFile := cFilexls
  ::oExcel:WorkBooks:Open( ::cFile , , , , , , , , , , lNotify, , lAddToMRU)
  //Open(FileName, UpdateLinks, ReadOnly, Format, Password, WriteResPassword, IgnoreReadOnlyRecommended, Origin, Delimiter, Editable, Notify, Converter, AddToMRU)


  ::oBook       := ::oExcel:Get( "ActiveWorkBook")
  ::oSheet      := ::oExcel:Get( "ActiveSheet" )
  ::oShape      := ::oSheet:Get( "Shapes" )
  ::cFont       := "Arial"
  ::nSize       := 10
  ::lBold       := .F.
  ::lItalic     := .F.
  ::lUnderLine  := .F.
  ::nAlign      := 1
  ::lDefault    := .F.
  ::lOpen       := .T.
  ::nFormat     :=   ::oBook:Get("FileFormat")

  ::SetPos("A1")
  ::GetCell()

RETURN Self


METHOD ReadOnly(lMsg)  CLASS TExcelScript
lVret := .F.
IF ::oBook:ReadOnly
   lVret := .T.
   IF lMsg
      MsgInfo(" El archivo " +::cFile + " está abierto en otra sesión" )
   ENDIF
ENDIF
RETURN( lVret )
/*
 *  TExcelScript():Create()
 */
METHOD Create( cFilexls )  CLASS TExcelScript

  ::cFile := cFilexls
  ::oExcel:WorkBooks:Add()

  ::oBook       := ::oExcel:Get( "ActiveWorkBook")
  ::oSheet      := ::oExcel:Get( "ActiveSheet" )
  ::oShape      := ::oSheet:Get( "Shapes" )
  ::cFont       := "Arial"
  ::nSize       := 10
  ::lBold       := .F.
  ::lItalic     := .F.
  ::lUnderLine  := .F.
  ::nAlign      := 1
  ::lDefault    := .T.
  ::nFormat     :=   ::oBook:Get("FileFormat")

  ::SetPos("A1")
  ::GetCell()

RETURN Self

/*
 *  TExcelScript():Get()
 */
/*
METHOD Get( nRow, nCol, cValue , nLong)  CLASS TExcelScript

  local xVret, cType

  DEFAULT cValue  := NIL
  DEFAULT nLong   := 1

  if nRow == NIL .or. nCol == NIL
    ::GetCell()
    DEFAULT nRow  := ::oCell:Row
    DEFAULT nCol  := ::oCell:Column
  endif
  xVret := ::oSheet:Cells( nRow, nCol ):Value
  xVret := IIF( ValType( xVret )=="U", "" , xVret )
  cType := ValType( xVret )

*
*  if cValue == "T"
*     xVret := ::oSheet:Cells( nRow, nCol ):Value
*     if ValType( xVret ) == "N"
*        xVret:= str(xVret,nLong)
*     endif
*     RETURN xVret
*  endif
*
  IF cValue != NIL
    IF cValue == "N"
    *   ::oSheet:Cells( nRow, nCol):Text()         // By Victor Reyes
    ?   xVret := ::oSheet:Cells( nRow, nCol ):Value
       xVret := IIF( ValType( xVret )=="C", Val(xVret) ,;
               IIF( ValType( xVret )=="D", xVret, xVret )  )
    ENDIF
    IF cValue == "C"
      xVret := IIF( ValType( xVret )=="N", Ltrim(Str(xVret) ),;
               IIF( ValType( xVret )=="D", Dtos(xVret), xVret )  )
    ENDIF
  ENDIF

RETURN xVret
*/
METHOD Get( nRow , nCol , cValue )  CLASS TExcel
       LOCAL xVret
       LOCAL cType
       DEFAULT cValue := "C"
       xVret := ::oSheet:Cells( nRow, nCol ):Value
       xVret := IIF( ValType( xVret )=="U", "" , xVret )
       cType := ValType( xVret )
       // 999,999,999,999,999,999.99
       IF cValue != Nil
          IF cValue == "N"
             xVret := IIF( ValType( xVret )=="C",Val(xVret) ,;
                      IIF( ValType( xVret )=="D",xVret , Val(Alltrim(Str(xVret,21,2))) )  )
          ENDIF
          IF cValue == "C"
             xVret := IIF( ValType( xVret )=="N",Ltrim(Str(xVret) ),;
                      IIF( ValType( xVret )=="D",Dtos(xVret) ,xVret )  )
          ENDIF
       ENDIF
RETURN( xVret )

/*
 *  TExcelScript():RangeFondo()
 */
METHOD RangeFondo( cRange , nColor )  CLASS TExcelScript

  DEFAULT nColor := Rgb(255 , 255 , 255 )

  ::oSheet:Range( cRange ):Interior:Color := nColor

RETURN Self

/*
 *  TExcelScript():Borders()
 */
METHOD Borders( cRange , nRow , nCol , nStyle )  CLASS TExcelScript

  if Empty( cRange )
    ::oSheet:Cells( nRow, nCol ):Borders():LineStyle  := nStyle
  else
    ::oSheet:Range( cRange ):Borders():LineStyle  := nStyle
  endif

RETURN Self

/*
 *  TExcelScript():CellFormat()
 */
METHOD CellFormat( nRow, nCol, nColor, nLine, cFormat )  CLASS TExcelScript

  if nRow == NIL .or. nCol == NIL
    ::GetCell()
    DEFAULT nRow  := ::oCell:Row
    DEFAULT nCol  := ::oCell:Column
  endif

  if ::lDefault
    DEFAULT nColor := Rgb(255 , 255 , 255 )
  endif

  if nColor != NIL
    ::oSheet:Cells( nRow, nCol ):Interior:Color := nColor
  endif

  if cFormat != NIL
    ::oSheet:Cells( nRow, nCol ):Set("NumberFormat",cFormat)
  endif
  //::oSheet:Cells( nRow, nCol ):Set("Text",cFormat)

  //::oSheet:Cells( nRow, nCol ):Interior:Pattern := 2
  //::oSheet:Cells( nRow, nCol ):Borders(nLine):LineStyle  := 1  // Bottom

RETURN Self

/*
 *  TExcelScript():AddComent()
 */
METHOD AddComent( nRow , nCol , cText )  CLASS TExcelScript

  DEFAULT cText := ""

  IF !Empty( cText )
    ::oSheet:Cells( nRow, nCol ):AddComment(cText)
  ENDIF

RETURN Self

/*
 *  TExcelScript():Print()
 */
METHOD Print()   CLASS TExcelScript

  ::oSheet:PrintOut()

RETURN Self

/*
 *  TExcelScript():Say()
 */
METHOD Say( nRow, nCol, xValue, cFont, nSize, lBold, lItalic, ;
            lUnderLine, nAlign, nColor, nFondo , nOrien , nStyle , cFormat )  CLASS TExcelScript
  * nAlign -> 1  // Derecha
  * nAlign -> 4  // Izquierda
  * nAlign -> 7  // Centrado

  local xVret

  if ::lDefault
    DEFAULT cFont       := ::cFont
    DEFAULT nSize       := ::nSize
    DEFAULT lBold       := ::lBold
    DEFAULT lItalic     := ::lItalic
    DEFAULT lUnderLine  := ::lUnderLine
    DEFAULT nAlign      := ::nAlign
    DEFAULT nColor      := Rgb( 0 , 0 , 0)
    DEFAULT nFondo      := RGB( 255, 255, 255 )
    DEFAULT nOrien      := 0
    DEFAULT nStyle      := 1
    DEFAULT cFormat     := "0"

  endif

  if nRow == NIL .or. nCol == NIL
    ::GetCell()
    DEFAULT nRow  := ::oCell:Row
    DEFAULT nCol  := ::oCell:Column
  endif

  if cFont != NIL
    ::oSheet:Cells( nRow, nCol ):Font:Name := cFont
  endif

  if nSize != NIL
    ::oSheet:Cells( nRow, nCol ):Font:Size := nSize
  endif

  if lBold != NIL
    ::oSheet:Cells( nRow, nCol ):Font:Bold := lBold
  endif

  if lItalic != NIL
    ::oSheet:Cells( nRow, nCol ):Font:Italic := lItalic
  endif

  if lUnderLine != NIL
    ::oSheet:Cells( nRow, nCol ):Font:UnderLine := lUnderLine
  endif

  if nColor != NIL
    ::oSheet:Cells( nRow, nCol ):Font:Color := nColor
  endif

  IF ValType( xValue ) == "N"
     ::oSheet:Cells( nRow, nCol ):Set("NumberFormat",cFormat)
  ENDIF
  ::oSheet:Cells( nRow, nCol ):Value := xValue

  if nFondo != NIL
    ::oSheet:Cells( nRow, nCol ):Interior:Color := nFondo
  endif

  if nAlign != NIL                                              
    ::oSheet:Cells( nRow, nCol ):Set("HorizontalAlignment",Alltrim(Str(nAlign)))
    ::oSheet:Cells( nRow, nCol ):Set("Orientation",nOrien)
  endif

  if nStyle != NIL
    ::oSheet:Cells( nRow, nCol ):Borders():LineStyle  := nStyle
  ENDIF

RETURN Self

/*
 *  TExcelScript():End()
 */
METHOD End( lClose ) CLASS TExcelScript

  DEFAULT lClose  := .F.

  if lClose
    ::oExcel:WorkBooks:Close()
  endif

  if ValType(::oFind) == "O"
    ::oFind:End() ; ::oFind   := NIL
  endif

  if ValType(::oCell) == "O"
    ::oCell:End() ; ::oCell   := NIL
  endif

  if ValType(::oSheet) == "O"
    ::oSheet:End(); ::oSheet  := NIL
  endif

  if ValType(::oBook) == "O"
    ::oBook:End() ; ::oBook   := NIL
  endif

  ::oExcel:End()  ; ::oExcel  := NIL

RETURN NIL

/*
 *  TExcelScript():Eval()
 */
METHOD eEval( cCommand, lOemAnsi, xParam ) CLASS TExcelScript   // [AD2K]

  DEFAULT lOemAnsi  := .F.

  if lOemAnsi
     cCommand  := OemToAnsi( cCommand )
  endif

  // Soporte de lineas de Comentarios
  if Left( AllTrim( cCommand ), 1 ) $ "*/#"             // No procesar linea de comentario

  elseif Left( AllTrim( cCommand ), 1 ) == "!"          // Ejecutar Funcion Clipper/FW
    cCommand  := AllTrim(SubStr( cCommand, 2 ))
    Eval( &("{|oThis, uParam| " + cCommand + " }" ), Self, xParam )

  else                                                  // Ejecuta Metodo TExcelScript
    // Ahora sin uso de privadas [LKM]
    Eval( &("{|oThis, uParam| oThis:" + cCommand + " }" ), Self, xParam )

  endif

RETURN Self

/*
 *  TExcelScript():SubTotal()
 */
METHOD SubTotal( cRange, nGroup, nOpe, nCol  ) CLASS TExcelScript

  DEFAULT nOpe := 1

  DO CASE
  CASE nOpe == 1
    nOpe := -4157   // Sum
  CASE nOpe == 2
    nOpe := -4106   // Ave
  CASE nOpe == 3
    nOpe := -4112   // Count
  CASE nOpe == 4
    nOpe := -4155   // StDev
   CASE nOpe == 5
    nOpe := -4156   // StDevP
  OTHERWISE
    nOpe := -4157   // Sum
  ENDCASE

  ::oSheet:Range( cRange ):SubTotal( nGroup, nOpe, nCol  )

RETURN Self

/*
 *  TExcelScript():Duplicate()
 */
METHOD Duplicate( cRange ) CLASS TExcelScript   // [AD2K]

  DEFAULT cRange  := ::oCell:Row

  ::oExcel:Rows( cRange ):Select()
  ::oExcel:Selection:Copy()
  ::oExcel:Selection:Insert()

RETURN Self

/*
 *  TExcelScript():Clear()
 */
METHOD eClear( cRange ) CLASS TExcelScript  // [AD2K]

  ::oExcel:Range( cRange ):Select()
  ::oExcel:Selection:Invoke("ClearContents")

RETURN Self

/*
 *  TExcelScript():Find()
 */
METHOD Find( cSearch, lMatch, lPart ) CLASS TExcelScript    // [AD2K]

  local oRange, lFound := .F.

  if cSearch == NIL
    RETURN lFound
  endif

  DEFAULT lMatch  := .F.  ,;
          lPart   := .F.

  ::GetCell():Activate()
  oRange := ::oSheet:Cells:Find( cSearch )

  if ValType( oRange ) == "O" .and. oRange[1] > 0
    oRange:Activate()

    ::GetCell()
    ::oFind   := oRange
    lFound    := .T.

    if (lMatch) .or. !(lPart)
      while !iif( lPart, cSearch $ ::Get( ::oCell:Row, ::oCell:Column ),  ;
                         cSearch == ::Get( ::oCell:Row, ::oCell:Column ))
        if !(::FindNext( oRange ))
          lFound  := .F.
          exit
        endif
      enddo
    endif
  endif

  RELEASE oRange

RETURN lFound

/*
 *  TExcelScript():FindNext()
 */
METHOD FindNext() CLASS TExcelScript    // [AD2K]

  local lFound := .F.
  local oRange, cRange, oCell

  if ValType( ::oFind ) == "O"
    oCell   := ::oCell
    cRange  := ::oExcel:Get( "ActiveCell" ):Address
    oRange  := ::oExcel:Cells:FindNext( ::oFind )

    if ValType( oRange ) == "O" .and. oRange[1] > 0
      oRange:Activate()
      ::GetCell()

      if ::oCell:Row == oCell:Row
        lFound  := ::oCell:Column > oCell:Column
      elseif ::oCell:Row > oCell:Row
        lFound  := .T.
      endif

      if lFound
        ::oFind := oRange
      else
        ::SetPos( cRange )
        ::oFind := NIL
      endif
    endif
  endif

RETURN lFound

/*
 *  TExcelScript():Replace()
 */
METHOD Replace( cSearch, cReplace, lMatch, lPart, lAll, lFull, cFormat ) CLASS TExcelScript    // [AD2K]

  local lFound  := .F.

  DEFAULT lAll  := .F.
  DEFAULT lFull := .F.

  if cReplace != NIL
    while ::Find( cSearch, lMatch, lPart )
      lFound := .T.

      if cFormat != NIL
        ::CellFormat( ,,,, cFormat )
      endif

      if (lFull)
        ::Say(,, cReplace )
      else
        ::Say(,, StrTran(::Get(), cSearch, cReplace ) )
      endif

      if !(lAll)
        exit
      endif
    enddo
  endif

RETURN lFound

/*
 *  TExcelScript():Chart()
 */
METHOD Chart( cRange , cTitle , nType , nDepth , nGapDepth ) CLASS TExcelScript    // [RimUs]
   LOCAL oChart , oSheet
   DEFAULT cTitle := "Grafica"
   DEFAULT nDepth := 20     // Profundidad de la Grafica
   DEFAULT nGapDepth := 20     // Separacion entre series
   ::oSheet:Range( cRange ):Select()
   ::oExcel:Charts:Add()
   oChart := ::oExcel:Get( "ActiveChart" )
   oChart:ChartType := nType
   oChart:HasTitle := .T.
   oChart:ChartTitle:Text := cTitle
   oChart:Set("DepthPercent" , nDepth)
   oChart:Set("GapDepth" , nGapDepth)
RETURN Self


/*
 *  TExcelScript():aAddCol()
 */
METHOD AddCol(  bAction , nAlign ,  bClrText , bClrPane , bHeading , bFooting ) CLASS TExcelScript    // [ Vikthor ]
   DEFAULT nAlign := 1  // Derecha
   DEFAULT bAction    := {|| ""}
   DEFAULT bClrText  := {||Rgb( 0,0,0)}
   DEFAULT bClrPane  := {||Rgb( 255,255,255)}
   DEFAULT bHeading  := {|| "" }
   DEFAULT bFooting  := {|| "" }

   aadd( ::aExcelCols , { bAction , nAlign , bClrText , bClrPane , bHeading , bFooting  } )

RETURN Self

/*
 *  TExcelScript():Browse()
 */
METHOD Browse( nRow , nCol , cAlias , cFont , nSize , bClrText , bClrPane ) CLASS TExcelScript    // [ Vikthor ]
   LOCAL nCiclo
   LOCAL nI

   ::nAt := 0
   DEFAULT cFont := "Tahoma"
   DEFAULT nSize := 10
   DEFAULT bClrText := {|| Rgb( 0 , 0 , 0)}
   DEFAULT bClrPane := {|| Rgb( 255 , 255 , 255 )}
   DEFAULT nRow := 1
   DEFAULT nCol := 1
   nCol--
   ::cAlias := cAlias

   IF !Empty( ::cAlias )
     /* encabezados */
     FOR nCiclo := 1 TO LEN( ::aExcelCols )
       ::Say( nRow , nCol + nCiclo, Eval( ::aExcelCols[nCiclo, 5 ] ), cFont, nSize,,,, ::aExcelCols[nCiclo, 2 ], ;
              Eval(  bClrText  ), Eval(  bClrPane  ) )
       ::Borders( , nRow , nCol+nCiclo , 1 )
     NEXT
     nRow ++
     /* arreglo o DBF */
     IF Lower(::cAlias) == "array"
        (::cAlias)->( DbGoTop() )
        FOR nI := 1 TO LEN( ::aData )
           FOR nCiclo := 1 TO LEN(::aExcelCols)
            ::Say( nRow , nCol+nCiclo, ::aData[nI,nCiclo], cFont, nSize,,,, ::aExcelCols[nCiclo, 2 ], ;
                  Eval(  ::aExcelCols[nCiclo, 3 ]  ), Eval(  ::aExcelCols[nCiclo, 4 ]  ) )
            ::Borders( , nRow , nCol+nCiclo , 1 )
           NEXT
           ::nAt++
           nRow++
        NEXT
     ELSE
        DO WHILE !(::cAlias)->(EOF())
           FOR nCiclo := 1 TO LEN(::aExcelCols)
              ::Say( nRow , nCol+nCiclo, Eval( ::aExcelCols[nCiclo, 1 ] ), cFont, nSize,,,, ::aExcelCols[nCiclo, 2 ], ;
                      Eval( ::aExcelCols[nCiclo, 3 ] ), Eval( ::aExcelCols[nCiclo, 4 ] ))
              ::Borders( , nRow , nCol+nCiclo , 1 )
           NEXT
           ::nAt++
           nRow++
           (::cAlias)->(DbSkip(1))
        ENDDO
     ENDIF
     /* Footers */
     FOR nCiclo := 1 TO LEN(::aExcelCols)
       ::Say( nRow , nCol+nCiclo, Eval( ::aExcelCols[nCiclo, 6 ] ), cFont, nSize,,,, ::aExcelCols[nCiclo, 2 ] ,;
              Eval(  bClrText  ), Eval(  bClrPane  ) )
       ::Borders( , nRow , nCol+nCiclo , 1 )
     NEXT
     FOR nCiclo := 1 TO LEN(::aExcelCols)
       ::AutoFit( nCol+nCiclo )
     NEXT
  ENDIF

RETURN Self


/*
 *  Margins( nOpc , cVal )
 */
METHOD Margins( nOpc , nVal )  CLASS TExcelScript    // [ Vikthor ]
DEFAULT nVal := 0
DEFAULT nOpc := 0
DO CASE
   CASE nOpc == 0  // Todos
        ::oSheet:PageSetup:Set( "RightMargin"  , nVal )
        ::oSheet:PageSetup:Set( "TopMargin"    , nVal )
        ::oSheet:PageSetup:Set( "LeftMargin"   , nVal )
        ::oSheet:PageSetup:Set( "BottomMargin" , nVal )
        ::oSheet:PageSetup:Set( "FooterMargin" , nVal )
        ::oSheet:PageSetup:Set( "HeaderMargin" , nVal )
   CASE nOpc == 1  // Right
        ::oSheet:PageSetup:Set( "RightMargin" , nVal )
   CASE nOpc == 2  // Top
        ::oSheet:PageSetup:Set( "TopMargin" , nVal )
   CASE nOpc == 3  // Left
        ::oSheet:PageSetup:Set( "LeftMargin" , nVal )
   CASE nOpc == 4  // Bottom
        ::oSheet:PageSetup:Set( "BottomMargin" , nVal )
   CASE nOpc == 5  // Footer Margin
        ::oSheet:PageSetup:Set( "FooterMargin" , nVal )
   CASE nOpc == 6  // Header Margin
        ::oSheet:PageSetup:Set( "HeaderMargin" , nVal )
ENDCASE
RETURN self


/*
 *  Footers( nOpc , cVal )
 */
METHOD Footers( nOpc , cVal )  CLASS TExcelScript    // [ Vikthor ]
DEFAULT cVal := 1  // Centrado
DEFAULT nOpc := 0
DO CASE
   CASE nOpc == 1  // Center
        ::oSheet:PageSetup:Set( "CenterFooter" , cVal )
   CASE nOpc == 2  // Left
        ::oSheet:PageSetup:Set( "LeftFooter" , cVal )
   CASE nOpc == 3  // Right
        ::oSheet:PageSetup:Set( "RightFooter" , cVal )
ENDCASE
RETURN self

/*
 *  Headers( nOpc , cVal )
 */
METHOD Headers( nOpc , cVal )  CLASS TExcelScript    // [ Vikthor ]
DEFAULT cVal := 1  // Centrado
DEFAULT nOpc := 0
DO CASE
   CASE nOpc == 1  // Center
        ::oSheet:PageSetup:Set( "CenterHeader" , cVal )
   CASE nOpc == 2  // Left
        ::oSheet:PageSetup:Set( "LeftHeader" , cVal )
   CASE nOpc == 3  // Right
        ::oSheet:PageSetup:Set( "RightHeader" , cVal )
ENDCASE
RETURN Self

METHOD SendMail( cMail, cSubject, lReturn ) CLASS TExcelScript    // [ Vikthor ]
   DEFAULT cMail := "Vikthor@creswin.com" ,;
           cSubject := "TExcel Mailer Class" ,;
          lReturn := .T.

    ::oBook:SendMail( cMail , cSubject , lReturn )

RETURN Self

METHOD MailSystem() CLASS TExcelScript    // [ Vikthor ]
   nVret := ::oExcel:MailSystem()
/*
   DO CASE
    CASE nVret == 1  // xlMAPI
        MsgInfo( "Mail system is Microsoft Mail" )
    CASE nVret == 0  // xlPowerTalk
        MsgInfo( "Mail system is PowerTalk" )
    CASE nVret == 2  // xlNoMailSystem
        MsgInfo( "No mail system installed" )
   ENDCASE
*/
RETURN( nVret )

/*
 *  AddPicture( cFile, nRow , nCol , nWidth , nHeight)
 */
METHOD AddPicture( cFile, nRow , nCol , nWidth , nHeight ) CLASS TExcelScript    // [ Vikthor ]
  IF Empty( cFile )
     RETURN ( Nil  )
  ENDIF
  DEFAULT nRow := 1 ,;
          nCol := 1 ,;
          nWidth := 100 ,;
          nHeight := 100
  ::oShape:Invoke("AddPicture" , cFile , .T. , .T. , nRow , nCol , nWidth , nHeight )
RETURN( Nil )

METHOD SendeMail( cSender, cSubject, lShowMessage, lIncludeAttachment) CLASS TExcelScript    // [ Vikthor ]
  IF Empty( cSender )
     RETURN ( Nil  )
  ENDIF
   DEFAULT cSender := "vikthor@creswin.com" ,;
           cSubject := "TExcel Mailer Class" ,;
           lShowMessage := .F. ,;
           lIncludeAttachment := .F.
  ::oBook:Invoke("SendForReview" , cSender , cSubject, lShowMessage, lIncludeAttachment )
RETURN( Nil )


/*
 *  TExcelScript():Copy()
 */
METHOD Copy( cRange ) CLASS TExcelScript  // [CSR]

  If cRange == NIL
     RETURN Self
  End

  ::oExcel:Range( cRange ):Select()
  ::oExcel:Selection:Copy()

RETURN Self

/*
 *  TExcelScript():Paste()
 */
METHOD Paste() CLASS TExcelScript // [CSR]

  ::oSheet:Paste()

RETURN Self


// ************************ Metodo alternativo de GET ******************** [AD2K]
* /*
*  *  TExcelScript():Get()
*  */
* METHOD Get( nRow, nCol, cValue )  CLASS TExcelScript
*
*   local xVret, cType, cFormat, nDecs
*
*   if nRow == NIL .or. nCol == NIL
*     ::GetCell()
*     DEFAULT nRow  := ::oCell:Row
*     DEFAULT nCol  := ::oCell:Column
*   endif
*
*   xVret := ::oSheet:Cells( nRow, nCol ):Value
*   xVret := IIF( ValType( xVret ) == "U", "" , xVret )
*
*   if ValType( xVret ) == "N"
*     nDecs   := NumGetDecimals( xVret )
*     cFormat := "1" + iif( nDecs == 0, "", "." + Repl( "0", nDecs ) )
*     xVret   := Val( Str( xVret * Val(cFormat) ))
*     // xVret := Round( xVret, 10 )
*   endif
*
*   IF cValue != NIL
*     IF cValue == "N"
*       xVret := IIF( ValType( xVret ) == "C", Val(xVret) ,;
*                IIF( ValType( xVret ) == "D", xVret, xVret )  )
*     ENDIF
*     IF cValue == "C"
*       xVret := IIF( ValType( xVret ) == "N", LTrim(Str(xVret) ),;
*                IIF( ValType( xVret ) == "D", DtoS(xVret), xVret )  )
*     ENDIF
*   ENDIF
*
* RETURN (xVret)
*
* /*
*  *  NumGetDecimals( <nNumber> ) --> nDecimals
*  */
* STATIC FUNCTION NumGetDecimals( nNumber )
*
*   LOCAL cNum, nLen
*   LOCAL nPos, nDec
*
*   cNum := Str( nNumber,21,10)
*   nLen := Len( cNum )
*   nPos := At( ".", cNum )
*
*   IF nPos > 0
*     FOR nDec := nLen TO nPos STEP -1
*       IF SubStr( cNum, nDec, 1 ) == "0"
*         cNum := SubStr( cNum, 1, Len(cNum) - 1 )
*       ELSE
*         exit
*       ENDIF
*     NEXT
*
*     RETURN( Len( AllTrim( SubStr( cNum, nPos + 1 ))))
*   ENDIF
*
* RETURN ( 0 )


// [eof]