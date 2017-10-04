// Clase TWord
// Esta clase fue iniciada por Pedro Arribas Lopez
// Se ha de linkar junto con la clase Ole2 de Jose Gimenez, ya que la
// clase OLE original de Fivewin produce un error
//
// Modificaciones y añadidos:
//
// 7-5-2002 Sebastian Almiron - Se ha incorporado el metodo CheckSpelling() que
// llama al corrector ortografico. Debe tenerse el documento en pantalla. Por
// ejemplo despues de llamar a ::Visualizar().
//
// 7-5-2002 Sebastian Almiron - Se han incorporados los metodos ::Gotop y
// ::GoBottom()
//
// 6-5-2002 Sebastian Almiron - Los metodos say, line, etc. ahora pueden
// referirse a la cabecera o al cuerpo principal del documento
// Ello nos permitirá crear el "impreso" sobre la cabecera cuando este
// se repita en muchas hojas, consiguiendo con ello un ahorro
// considerable de tiempo y espacio. El metodo SetHeader() hace que todos
// los metodos de pintado/escritura se redirijan a la cabecera y el metodo
// SetMainDoc() hace que se escriban en el cuerpo principal del documento.
//
// 6-5-2002 Sebastian Almiron - El metodo tabpredeterminado(ncmpos) es para
// indicar la distancia de los tabuladores predeterminados
//
// 6-5-2002 Sebastian Almiron - Existe una nueva propiedad ::oLastsay
// que es el ultimo say mandado al documento, ello nos permitirá darle
// formato, como por ejemplo añadirle tabuladores.
//
// 6-5-2002 Sebastian Almiron - El metodo TabClearAll(ocuadrotext) elimina
// todos los tabuladores existentes, se le puede pasar de parametro el
// ultimo say (::olastsay), por defecto se refiere al documento.
//
// 6-5-2002 Sebastian Almiron - El metodo AddTabulador(ocuadrotexto) sirve
// para añadir un tabulador, bien al documento (valor por defecto) o bien
// al ultimo say (::olastsay)
//
// 6-5-2002 Sebastian Almiron - Se ha añadido el metodo ::Box(), su uso es
// similar al mismo metodo de TPrinter
//
// 6-5-2002 Sebastian Almiron - Se han añadido los metodos ::SetPortrair() y
// setlandscape() al igual que en TPrinter
//
// 6-5-2002 Sebastian Almiron - Se ha añadido el metodo ::Protect(password) que
// permite proteger el documento contra cualquier modificacion.
//
// 6-5-2002 Sebastian Almiron - Se ha modificado el metodo ::startpage() y endpage()
// que producia bajo ciertas circunstancias paginas en blanco,
// ahora se aproxima mas a su uso con TPrinter. En realidad Endpage() no
// hace nada pero lo he dejado por mantener la compatibilidad con TPrinter
//
// 6-5-2002 Sebastian Almiron - Se ha motificado el metodo ::Say(), ahora se le
// puede indicar la anchura del cuadro de texto, por defecto calcula la anchura
// para ajustarlo al texto. Se le puede pasar la altura del cuadro con ello
// nos permitirá crear cuadros grandes en el que el texto esté separado por
// tabuladores y retornos de carro, evitando tener que crear tantos cuadros
// de texto.

//
//
//----------------------------------------------------------------//

#include "FiveWin.Ch"
#define  TAB   chr(9)
#define  ENTER chr(13)

#define  ALI_LEFT    0
#define  ALI_CENTER  1
#define  ALI_RIGHT   2
#define  ALI_JUSTIFY 3

#define  LOGPIXELSX  88
#define  LOGPIXELSY  90

//----------------------------------------------------------------------------//
// LA CLASE TWORD
//----------------------------------------------------------------------------//

CLASS TWord
		DATA OleWord
		DATA hdc INIT 0
		DATA OleDocs
		DATA OleActiveDoc
		DATA OleTexto
		DATA oselection
		DATA cNombreDoc
		DATA nLinea,nCol, nPage
		DATA nYoffset, nXoffset
		DATA lstartpag
		DATA oLastSay

		METHOD New()
		METHOD NewDoc( cNombreDoc )
		METHOD OpenDoc( cNombreDoc )
		METHOD Write( cTexto, cFuente, cSize, lBold, lShadow, nColor )
		METHOD Say( nLin,nCol,cTexto,oFuente,nSizeHorz,nClrText,nBkMode,nPad )
		METHOD CmSay( nLin,nCol,cTexto,oFuente,nSizeHorz )
		METHOD Say2( nLin,nCol,cTexto,oFuente,nSizeHorz )
		METHOD TextBox( nTop, nLeft, nButtom, nRight, lLine, nColor, cTexto, oFuente, nJustify )
		METHOD Line( nTop, nLeft, nButtom, nRight, oPen )
		METHOD FillRect( aRect, oBrush )
		METHOD AddImagen( nTop,nLeft,nButtom,nRight, cImagen )
		METHOD Visualizar INLINE OleSetProperty( ::OleWord, "Visible", .t. )
		METHOD JustificaDoc( nJustify )
		METHOD Replace( cOld,cNew )
		METHOD Save()
		METHOD StartPage()
		METHOD EndPage()
		METHOD nHorzRes()
		METHOD nHorzSize()
		METHOD nVertRes()
		METHOD nVertSize()
		METHOD nLogPixelX()
		METHOD nLogPixelY()
		METHOD GetTextHeight( cFont, oFont )
		METHOD PrintDoc()
		METHOD Preview()
		METHOD VistaCompleta()
		METHOD End()
		METHOD Protect(cpassword) // bySebastianAlmiron
		METHOD SetLandScape()     // bySebastianAlmiron
		METHOD SetPortrait()     // bySebastianAlmiron
		METHOD Box(ntop, nleft, nbottom, nright) //bySebastianAlmiron
		METHOD GetTextWidth(cText, oFont)//bySebastianAlmiron
		METHOD addTabulador(ncmpos,ocuadrotext)//bySebastianAlmiron
		METHOD TabClearAll(ocuadrotext)//bySebastianAlmiron
		METHOD TabPredeterminado(ncmpos)//bySebastianAlmiron
		METHOD SetHeader()//bySebastianAlmiron
		METHOD SetMainDoc()//bySebastianAlmiron
		METHOD Gotop() //bySebastianAlmiron
		METHOD GoBottom() //bySebastianAlmiron
		METHOD CheckSpelling() //bySebastianAlmiron
ENDCLASS

//------------------------------------------------------------------------------
METHOD NEW( cDoc )
		 ::OleWord := CreateOleObject( "Word.Application" )
		 return Self

//------------------------------------------------------------------------------
METHOD NewDoc( cNombreDoc )
		 ::OleDocs       := OleGetProperty( ::OleWord, "Documents")
		 OleInvoke( ::OleDocs,"Add")
		 ::OleActiveDoc  := OleGetProperty( ::OleWord, "ActiveDocument")
		 ::OleTexto      := OleGetProperty( ::OleWord, "Selection")
		 ::cNombreDoc    := cNombreDoc
		 ::nLinea        := 0
		 ::nCol          := 0
		 ::nPage         := 0
		 ::nYoffset      := 0
		 ::nXoffset      := 0
		 ::lstartpag     := .t.
		 ::oselection    := ::OleActiveDoc
		 return nil

//------------------------------------------------------------------------------
METHOD OpenDoc( cNombreDoc )
		 ::OleDocs       := OleGetProperty( ::OleWord, "Documents")
		 IF FILE( cNombreDoc )
			 ::OleActiveDoc  := OleInvoke( ::OleDocs,"Open",cNombreDoc )
		 ELSE
			 OleInvoke( ::OleDocs,"Add")
			 ::OleActiveDoc  := OleGetProperty( ::OleWord, "ActiveDocument")
		 ENDIF
		 ::OleTexto      := OleGetProperty( ::OleWord, "Selection")
		 ::cNombreDoc    := cNombreDoc
		 ::nLinea        := 0
		 ::nCol          := 0
		 ::nPage         := 0
		 ::nYoffset      := 0
		 ::nXoffset      := 0
		 ::oselection    := ::OleactiveDoc
		 ::lstartpag     := .t.
		 return nil

//------------------------------------------------------------------------------
METHOD Say2( nLin,nCol,cTexto,oFuente,nSizeHorz )
		 Local oFont := OleGetProperty( ::OleTexto, "Font")
		 OleSetProperty( oFont, "Name", oFuente:cFaceName )
		 OleSetProperty( oFont, "Size", int(oFuente:nHeight) )
		 OleSetProperty( oFont, "Bold", oFuente:lBold     )

		 if ::nLinea < nLin
			 OleInvoke( ::OleTexto,"TypeText", chr(13) )
			 ::nLinea:= nLin
			 ::nCol  := 0
		 endif
		 if ::nCol < nCol
			 OleInvoke( ::OleTexto,"TypeText", chr(9) )
			 ::nCol:=nCol
		 endif


		 OleInvoke( ::OleTexto,"TypeText", cTexto )
		 OleInvoke( oFont,"Reset" )
		 release oFont
		 return nil

//------------------------------------------------------------------------------
METHOD TextBox( nTop, nLeft, nButtom, nRight, lLinea, nColor, cTexto, oFuente, nJustify )
		 LOCAL oShapes,oCuadro,oFill,oLinea, oFontC, oText, oCuadroText

		 oShapes     := OleGetProperty( ::oselection,"Shapes" )
		 oCuadro     := OleInvoke( oShapes, "AddTextbox", 1,INT(nLeft),INT(nTop),INT(nRight-nLeft),INT(nButtom-nTop) )
		 oFill       := OleGetProperty( oCuadro, "Fill" )
		 oFillColor  := OleGetProperty( oFill,"ForeColor")
		 OleSetProperty( oFillColor,"RGB",nColor )

		 oLinea      := OleGetProperty( oCuadro, "Line" )
		 if lLinea
			 OleSetProperty( oLinea, "Weight", 1 )
		 else
			 OleSetProperty( oLinea, "Transparency",0)
			 OleSetProperty( oLinea, "Visible",0)
		 endif

		 oCuadroText := OleGetProperty( oCuadro, "TextFrame" )
		 oText       := OleGetProperty( oCuadroText, "TextRange" )
		 oFontC      := OleGetProperty( oText, "Font")

		 OleSetProperty( oFontC, "Name",      oFuente:cFaceName )
		 OleSetProperty( oFontC, "Size",      INT(oFuente:nHeight)  )
		 OleSetProperty( oFontC, "Bold",      oFuente:lBold     )
		 OleSetProperty( oText, "Text", cTexto )

		 oParagraph  := OleGetProperty( oText, "ParagraphFormat")
		 OleSetProperty( oParagraph, "Alignment", nJustify )

		 release oParagraph, OLinea, oFillColor, oFill, oFontC, oText,oCuadroText, oCuadro
		 return nil

//------------------------------------------------------------------------------
METHOD AddImagen( nTop, nLeft, nButtom, nRight, cImagen )
		 LOCAL oShapes,oCuadro
		 oShapes     := OleGetProperty( ::oselection,"Shapes" )
		 oCuadro     := OleInvoke( oShapes, "AddPicture", cImagen,.F.,.T.,INT(nLeft),INT(nTop),INT(nRight-nLeft),INT(nButtom-nTop) )
		 release oCuadro
		 return nil


//------------------------------------------------------------------------------
METHOD Say( nLin,nCol,cTexto,oFuente,nSizeHorz,nClrText,nBkMode,nPad, naltura )
		 LOCAL oShapes,oFill,oLine,oCuadroText,oText,oFontC,oParagraph
		 local nTamFuente := if(oFuente:nHeight > 0, int(oFuente:nHeight + 2), int((oFuente:nHeight*-1)+2) )

		 DEFAULT nClrText := nRGB(0,0,0), nBkMode := 2, nPad := 0
		 DEFAULT nSizeHorz := ::GetTextWidth(ctexto,oFuente)
		 DEFAULT naltura := if(oFuente:nHeight > 0, oFuente:nHeight + 10, (oFuente:nHeight*-1)+10)

		 nSizeHorz := nSizeHorz + (nSizeHorz*25/100)

		 do case
			 case  npad = 1
					 npad := 2
			 case npad = 2
					 ncol = ncol - (nSizeHorz/2)
					 npad := 1
		 endcase
		 oShapes     := OleGetProperty( ::oselection,"Shapes" )  //::OleactiveDoc
		 oCuadro     := OleInvoke( oShapes, "AddTextbox", 1,INT(nCol),INT(nLin),nSizeHorz,naltura )
		 oFill       := OleGetProperty( oCuadro, "Fill" )
		 oLine       := OleGetProperty( oCuadro, "Line" )
		 oCuadroText := OleGetProperty( oCuadro, "TextFrame" )
		 oText       := OleGetProperty( oCuadroText, "TextRange" )
		 oFontC      := OleGetProperty( oText, "Font")
		 oParagraph  := OleGetProperty( oText, "ParagraphFormat")
		 OleSetProperty( oParagraph, "Alignment", nPad )
		 OleSetProperty( oFill, "Transparency",0)
		 OleSetProperty( oFill, "Visible",0)
		 OleSetProperty( oLine, "Transparency",0)
		 OleSetProperty( oLine, "Visible",0)
		 OleSetProperty( oFontC, "Name",      oFuente:cFaceName )
		 OleSetProperty( oFontC, "Size",      nTamfuente ) //INT(oFuente:nHeight*-1)  )
		 OleSetProperty( oFontC, "Bold",      oFuente:lBold     )
		 OleSetProperty( oFontC, "Italic",      oFuente:lItalic     )
		 OleSetProperty( oText, "Text", cTexto )

		 OleSetProperty( oCuadroText, "MarginLeft",0)
		 OleSetProperty( oCuadroText, "MarginRight",0)

		 ::oLastSay := otext

		 release oFontC,oText,oCuadro,oLine,oFill,oShapes,oParagraph,ocuadrotext

		 return nil

//------------------------------------------------------------------------------
METHOD CmSay( nLin,nCol,cTexto,oFuente,nSizeHorz )
		 LOCAL oShapes,oCuadro,oFill,oLine,oCuadroText,oText,oFontC

		 nCol :=  Max( 0, ( nCol * 10 * ::nHorzRes() / ::nHorzSize() ) - ::nYoffset )
		 nLin :=  Max( 0, ( nLin * 10 * ::nVertRes() / ::nVertSize() ) - ::nXoffset )

		 oShapes     := OleGetProperty( ::oselection,"Shapes" )
		 oCuadro     := OleInvoke( oShapes, "AddTextbox", 1,INT(nCol),INT(nLin),201,21 )
		 oFill       := OleGetProperty( oCuadro, "Fill" )
		 oLine       := OleGetProperty( oCuadro, "Line" )
		 oCuadroText := OleGetProperty( oCuadro, "TextFrame" )
		 oText       := OleGetProperty( oCuadroText, "TextRange" )
		 oFontC      := OleGetProperty( oText, "Font")

		 OleSetProperty( oFill, "Transparency",0)
		 OleSetProperty( oFill, "Visible",0)
		 OleSetProperty( oLine, "Transparency",0)
		 OleSetProperty( oLine, "Visible",0)
		 OleSetProperty( oFontC, "Name",      oFuente:cFaceName )
		 OleSetProperty( oFontC, "Size",      INT(oFuente:nHeight)  )
		 OleSetProperty( oFontC, "Bold",      oFuente:lBold     )
		 OleSetProperty( oText, "Text", cTexto )

		 release oFontC,oText,oCuadroText,oLine,oFill,oCuadro,oShapes
		 return nil

//------------------------------------------------------------------------------
METHOD Line( nTop, nLeft, nButtom, nRight, oPen )
		 LOCAL oShapes,oShapLinea, oLinea
		 if oPen = NIL
			 DEFINE PEN oPen
		 endif

		 oShapes     := OleGetProperty(  ::oselection ,"Shapes" )
		 oShapLinea  := OleInvoke( oShapes, "AddLine", nLeft,nTop,nRight,nButtom )
		 oLinea      := OleGetProperty( oShapLinea, "Line" )
		 OleSetProperty( oLinea, "Weight", oPen:nWidth-2 )
		 oPen:End()
		 release oLinea,oShapLinea,oShapes

		 return nil

//------------------------------------------------------------------------------
METHOD FillRect( aRect, oBrush )
		 LOCAL oShapes,oShapBox, oFill, oFillColor
		 LOCAL nTop    := INT(arect[1])
		 LOCAL nLeft   := INT(arect[2])
		 LOCAL nWidth  := INT(aRect[4]-aRect[2])
		 LOCAL nHeight := INT(aRect[3]-aRect[1])

		 oShapes     := OleGetProperty( ::oselection,"Shapes" )
		 oShapBox    := OleInvoke( oShapes, "AddShape",1,nLeft,nTop,nWidth,nHeight )
		 oFill       := OleGetproperty( oShapBox,"Fill")
		 oFillColor  := OleGetProperty( oFill,"ForeColor")
		 OleSetProperty( oFillColor,"RGB",oBrush:nRGBColor )
		 oBrush:End()

		 release oFillColor,oFill,oShapBox,oShapes
		 return nil

//------------------------------------------------------------------------------
METHOD GetTextHeight( cFont, oFont )
		 return oFont:nHeight

//------------------------------------------------------------------------------
METHOD Write( cTexto, cFuente, nSize, lBold, lShadow, nColor )
		 Local oFont := OleGetProperty( ::OleTexto, "Font")
		 OleSetProperty( oFont, "Name", cFuente     )
		 OleSetProperty( oFont, "Size", nSize       )
		 OleSetProperty( oFont, "Bold", lBold       )
		 OleSetProperty( oFont, "ColorIndex",nColor )
		 OleSetProperty( oFont, "Emboss",lShadow    )

		 OleInvoke( ::OleTexto,"TypeText", cTexto )
		 OleInvoke( oFont,"Reset" )
		 release oFont
		 return nil

//------------------------------------------------------------------------------
METHOD Replace( cOld, cNew )
		 LOCAL oTexto, oFind, oReplace

		 oTexto := OleInvoke( ::oselection, "Range" )
		 oFind  := OleGetProperty( oTexto, "Find" )

		 OleSetProprerty( oFind, "Text", cOld )
		 OleSetProprerty( oFind, "Forward", .T. )
		 OleSetProprerty( oFind, "Wrap", INT(1) )
		 OleSetProprerty( oFind, "Format", .f.            )
		 OleSetProprerty( oFind, "MatchCase", .f.         )
		 OleSetProprerty( oFind, "MatchWholeWord", .f.    )
		 OleSetProprerty( oFind, "MatchWildcards", .f.    )
		 OleSetProprerty( oFind, "MatchSoundsLike", .f.   )
		 OleSetProprerty( oFind, "MatchAllWordForms", .f. )

		 OleInvoke( oFind, "Execute")
		 DO WHILE OleGetProprerty( oFind, "Found" )
			 OleSetProprerty( oTexto, "Text", cNew )
			 OleInvoke( oFind, "Execute")
		 Enddo

		 release oReplace,oFind,oTexto
		 return nil
//------------------------------------------------------------------------------
METHOD JustificaDoc( nJustify )
		 LOCAL oParagraph  := OleGetProperty( ::OleTexto, "ParagraphFormat")
		 OleSetProperty( oParagraph, "Alignment", nJustify )
		 release oParagraph
		 return nil

//------------------------------------------------------------------------------
METHOD Save()
		 OleInvoke( ::OleActiveDoc,"SaveAs", ::cNombreDoc )
		 return nil

//------------------------------------------------------------------------------
METHOD StartPage()
		 if ::lstartpag = .t.
			 ::lstartpag := .f.
		 else
			 OleInvoke(::OleTexto,"EndKey",6,0)
			 OleInvoke(::OleTexto,"InsertBreak")
			 OleInvoke(::Oletexto,"GotoNext",1)
			 ::nPage++
			 ::nLinea:=0
			 ::nCol  :=0
		 endif
		 return nil

//------------------------------------------------------------------------------
METHOD EndPage()
		 return nil

//------------------------------------------------------------------------------
METHOD PrintDoc()
		 OleInvoke( ::OleWord, "PrintOut"  )
		 return nil

//------------------------------------------------------------------------------
METHOD Preview()
		 OleSetProperty( ::OleWord, "PrintPreview",.f.)
		 OleInvoke( ::OleActiveDoc, "PrintPreview")
		 ::Visualizar()
		 return nil

//------------------------------------------------------------------------------
METHOD VistaCompleta()
		 LOCAL oWindow, oView

		 oWindow := OleGetProperty( ::OleActiveDoc , "ActiveWindow" )
		 oView   := OleGetProperty( oWindow , "View" )
		 OleSetProperty( oView,"FullScreen", .T. )
		 ::Visualizar()
		 release oView
		 return nil

//------------------------------------------------------------------------------
METHOD nHorzRes()
		 nRes := 2
		 return nres

//------------------------------------------------------------------------------
METHOD nHorzSize()
		 nRes := 1
		 return nres

//------------------------------------------------------------------------------
METHOD nVertRes()
		 nRes := 2
		 return nres

//------------------------------------------------------------------------------
METHOD nVertSize()
		 nRes := 1
		 return nres

//------------------------------------------------------------------------------
METHOD nLogPixelY()
		 LOCAL nPixels := 55.38
		 return nPixels

//------------------------------------------------------------------------------
METHOD nLogPixelX()
		 LOCAL nPixels := 55.38
		 return nPixels

//------------------------------------------------------------------------------
METHOD End()
		 OleInvoke(::OleWord,"Quit",0)
		 ::OleTexto     := NIL
		 ::OleActiveDoc := NIL
		 ::OleDocs      := NIL
		 ::Oleword      := NIL
		 OleUninitialize()
		 return nil

//------------------------------------------------------------------------------
METHOD Protect(cpassword)
		 OleInvoke( ::OleActiveDoc,"Protect", 2, .F., cpassword )
		 return

//------------------------------------------------------------------------------
METHOD SetLandScape()
		 local oPageSetup := OleGetProperty( ::OleactiveDoc,'PageSetup')
		 OleSetProperty( oPageSetup,'Orientation','1')
		 release oPageSetup
		 return

//------------------------------------------------------------------------------
METHOD SetPortrait()
		 local oPageSetup := OleGetProperty( ::OleactiveDoc,'PageSetup')
		 OleSetProperty( oPageSetup,'Orientation','0')
		 release oPageSetup
		 return

//------------------------------------------------------------------------------
METHOD Box( nTop, nLeft, nButtom, nRight )
		 local oShapes,oShapBox

		 oShapes     := OleGetProperty( ::oselection,"Shapes" )

		 nRight := nRight - nLeft
		 nButtom := nButtom - nTop

		 oShapBox    := OleInvoke( oShapes, "AddShape",1,nLeft,nTop,nRight,nButtom )

		 release oShapBox,oShapes
		 return nil

//------------------------------------------------------------------------------
METHOD GetTextWidth(cText, oFont)
		 local nancho
		 if oFont:nHeight > 0
			 nancho := (oFont:nHeight/1.6)*len(ctext)
		 else
			 nancho :=((oFont:nHeight*-1)/1.6)*len(ctext)
		 endif
		 return nancho

//------------------------------------------------------------------------------
METHOD addtabulador(npos, ocuadrotext)
		 local otabstop, oParagraphFormat
		 DEFAULT ocuadrotext := ::OleTexto
		 oParagraphFormat := OleGetProperty(ocuadrotext, 'ParagraphFormat')
		 otabstop := OleGetProperty(oParagraphFormat, 'TabStops')
		 OleInvoke(otabstop,'Add',npos)
		 release oParagraphFormat, otabstop
		 return nil

//------------------------------------------------------------------------------
METHOD TabClearAll(ocuadrotext)
		 local oparagraphformat, otabstop
		 DEFAULT ocuadrotext := ::Oletexto
		 oparagraphformat := OleGetProperty(ocuadrotext,'ParagraphFormat')
		 otabstop := OleGetProperty(oParagraphformat, 'TabStops')
		 OleInvoke(otabstop,'ClearAll')
		 release oparagraphformat, otabstop
		 return nil

//------------------------------------------------------------------------------
METHOD TabPredeterminado(npos)
		 OleSetProperty(::OleactiveDoc,'DefaultTabStop', npos )
		 return nil

//------------------------------------------------------------------------------
METHOD SetHeader()
		 local oWindow := OleGetProperty( ::OleActiveDoc , "ActiveWindow" )
		 local oView   := OleGetProperty( oWindow , "View")
		 OleSetProperty(oView,"SeekView",9)
		 ::oselection := OleGetProperty( ::OleTexto, "HeaderFooter")
		 release oWindow, oView
		 return

//------------------------------------------------------------------------------
METHOD SetMainDoc()
		 local oWindow := OleGetProperty( ::OleActiveDoc , "ActiveWindow" )
		 local oView   := OleGetProperty( oWindow , "View")
		 OleSetProperty(oView,"SeekView",0)
		 ::oselection := ::OleActiveDoc
		 release oWindow, oView
		 return

//------------------------------------------------------------------------------
METHOD Gotop()
		 OleInvoke(::OleTexto, 'HomeKey', 6)
		 return

//------------------------------------------------------------------------------
METHOD GoBottom()
		 OleInvoke(::OleTexto, 'EndKey', 6)
		 return

//------------------------------------------------------------------------------
METHOD CheckSpelling()
		 Oleinvoke(::OleActiveDoc, 'CheckSpelling')
		 return


