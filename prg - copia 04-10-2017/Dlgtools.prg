#ifndef __PDA__
#include "FiveWin.Ch"
#include "Font.ch"
#else
#include "FWCE.ch"
REQUEST DBFCDX
#endif

#ifndef __PDA__

#command SET FILTER TO <xpr> INTO <cAlias>   => (cAlias)->( dbSetFilter( <{xpr}>, <"xpr"> ) )

#define ID_EXPR      110
#define ID_WORKAREAS 120
#define ID_FIELDS    130
#define ID_EQUAL     150
#define ID_NOEQUAL   160
#define ID_AND       170
#define ID_PLUS      180
#define ID_LESS      190
#define ID_GREATER   200
#define ID_OR        210
#define ID_MINUS     220
#define ID_LESS_EQ   230
#define ID_GREA_EQ   240
#define ID_NOT       250
#define ID_MULTIPLY  260
#define ID_OPEN_PR   270
#define ID_CLOSE_PR  280
#define ID_INCLUDE   290
#define ID_DIVIDE    300
#define ID_DATE      310
#define ID_CHAR      320
#define ID_NUMBER    330
#define ID_OBJECT    340

#define ID_UNDO      345
#define ID_CHECK     350

#define APPD_MODE		1
#define EDIT_MODE		2
#define ZOOM_MODE		3
#define DUPL_MODE		4

#endif

#ifndef __PDA__

//--------------------------------------------------------------------------//
//Funciones del programa
//--------------------------------------------------------------------------//


/*
Expression Builder Dialog
FiveWin - Dialog tools
Retocada y ampliada por Manolo Calero
*/

FUNCTION cGetExpression( cExpr, aBase, cAlias )

	local oDlg, oExpr, oFields, cTemp
	local oBtnDate, oBtnChar, oBtnNumber
	local aUnDo   	:= { "" }
	local nField  	:= 1
	local cTitle  	:= "Generador de Expresiones"
	local hOldRes 	:= GetResources()

	DEFAULT cExpr 	:= Space( 200 )
	DEFAULT aBase  := { {"Not passed"}, {"C"} }
	DEFAULT cAlias	:= Alias()

	cTemp = PadR( cExpr, 200 )

	SET RESOURCES TO "FwTools.dll"

   DEFINE DIALOG oDlg RESOURCE "ExpBuilder" TITLE cTitle

	REDEFINE GET oExpr VAR cTemp ID ID_EXPR OF oDlg

	REDEFINE LISTBOX oFields VAR nField ID ID_FIELDS OF oDlg ;
      ON DBLCLICK ExprAdd( " " + cAlias + " > " + ( aBase[nField, 1] ),;
						@cTemp, oExpr, aUnDo );
		ON CHANGE CheckBtn( aBase[nField,2] , oBtnDate, oBtnChar, oBtnNumber )

   REDEFINE BUTTON ID ID_EQUAL OF oDlg ;
      ACTION ExprAdd( " = ", @cTemp, oExpr, aUnDo )

   REDEFINE BUTTON ID ID_NOEQUAL OF oDlg ;
      ACTION ExprAdd( " <> ", @cTemp, oExpr, aUnDo )

   REDEFINE BUTTON ID ID_AND OF oDlg ;
      ACTION ExprAdd( " .and. ", @cTemp, oExpr, aUnDo )

   REDEFINE BUTTON ID ID_PLUS OF oDlg ;
      ACTION ExprAdd( " + ", @cTemp, oExpr, aUnDo )

   REDEFINE BUTTON ID ID_LESS OF oDlg ;
      ACTION ExprAdd( " < ", @cTemp, oExpr, aUnDo )

   REDEFINE BUTTON ID ID_GREATER OF oDlg ;
      ACTION ExprAdd( " > ", @cTemp, oExpr, aUnDo )

   REDEFINE BUTTON ID ID_OR OF oDlg ;
      ACTION ExprAdd( " .or. ", @cTemp, oExpr, aUnDo )

	REDEFINE BUTTON ID ID_MINUS OF oDlg ;
      ACTION ExprAdd( " - ", @cTemp, oExpr, aUnDo )

	REDEFINE BUTTON ID ID_LESS_EQ OF oDlg ;
		ACTION ExprAdd( " <= ", @cTemp, oExpr, aUnDo )

	REDEFINE BUTTON ID ID_GREA_EQ OF oDlg ;
		ACTION ExprAdd( " >= ", @cTemp, oExpr, aUnDo )

	REDEFINE BUTTON ID ID_NOT OF oDlg ;
		ACTION ExprAdd( " .not. ", @cTemp, oExpr, aUnDo )

	REDEFINE BUTTON ID ID_MULTIPLY OF oDlg ;
		ACTION ExprAdd( " * ", @cTemp, oExpr, aUnDo )

	REDEFINE BUTTON ID ID_OPEN_PR OF oDlg ;
		ACTION ExprAdd( " ( ", @cTemp, oExpr, aUnDo )

	REDEFINE BUTTON ID ID_CLOSE_PR OF oDlg ;
		ACTION ExprAdd( " ) ", @cTemp, oExpr, aUnDo )

	REDEFINE BUTTON ID ID_INCLUDE OF oDlg ;
		ACTION ExprAdd( " $ ", @cTemp, oExpr, aUnDo )

	REDEFINE BUTTON ID ID_DIVIDE OF oDlg ;
		ACTION ExprAdd( " / ", @cTemp, oExpr, aUnDo )

	REDEFINE BUTTON oBtnDate ID ID_DATE OF oDlg ;
		ACTION ( ExprAdd( GetValue("D"), @cTemp, oExpr, aUnDo ) )

	REDEFINE BUTTON oBtnChar ID ID_CHAR OF oDlg ;
		ACTION ( ExprAdd( GetValue("C"), @cTemp, oExpr, aUnDo ) )

	REDEFINE BUTTON oBtnNumber ID ID_NUMBER OF oDlg ;
		ACTION ( ExprAdd( GetValue("N"), @cTemp, oExpr, aUnDo ) )

	/*
	REDEFINE BUTTON ID ID_OBJECT OF oDlg ;
		ACTION NIL
	*/

	REDEFINE BUTTON ID ID_UNDO OF oDlg ;
		ACTION UnDo( @cTemp, oExpr, aUnDo )

   REDEFINE BUTTON ID ID_CHECK OF oDlg ;
      ACTION If( At( Type( cTemp ), "UIUE" ) == 0,;
					  MsgInfo( "Expresion Correcta" ),;
					  msgStop( "Expresion Invalida" ) )

	ACTIVATE DIALOG oDlg CENTERED ;
		ON INIT ( ShowFields( aBase, oFields ),;
					CheckBtn( aBase[nField,2], oBtnDate, oBtnChar, oBtnNumber ) )

   IF oDlg:nResult == IDOK
		cExpr = AllTrim( cTemp )
	ENDIF

	SetResources(hOldRes)

RETURN cExpr

//----------------------------------------------------------------------------//

/*
Funcion axiliar de la caja de dialogo para recoger expresiones
*/

STATIC FUNCTION UnDo( cTemp, oExpr, aUnDo )

   if Len( aUnDo ) > 0
      cTemp = PadR( ATail( aUnDo ), 100 )
      oExpr:Refresh()
      ASize( aUnDo, Len( aUnDo ) - 1 )
   else
      Tone( 900, 2 )
   endif

RETURN NIL

//----------------------------------------------------------------------------//

/*
Funcion auxiliar de la caja de dialogo para recoger expresiones
*/

STATIC FUNCTION ExprAdd( cNew, cExpr, oExpr, aUnDo )

   AAdd( aUnDo, RTrim( cExpr ) )
   cExpr = PadR( RTrim( cExpr ) + cNew, 100 )
   oExpr:Refresh()

RETURN NIL

//----------------------------------------------------------------------------//

/*
Funcion auxiliar de la caja de dialogo para recoger expresiones
*/

STATIC FUNCTION ShowFields( aBase, oLbx )

   local n

   oLbx:Reset()

	for n = 1 to Len( aBase )
		oLbx:Add( aBase[ n ][ 2 ]  )
   next

   oLbx:GoTop()

RETURN NIL

//----------------------------------------------------------------------------//

STATIC FUNCTION CheckBtn( cType, oBtnDate, oBtnChar, oBtnNumber )

	DO CASE
	CASE ( cType == "D" )
		oBtnDate:Enable()
		oBtnChar:Disable()
		oBtnNumber:Disable()

	CASE ( cType == "C" )
		oBtnDate:Disable()
		oBtnChar:Enable()
		oBtnNumber:Disable()

	CASE ( cType == "N" )
		oBtnDate:Disable()
		oBtnChar:Disable()
		oBtnNumber:Enable()

	END CASE

RETURN ( .T. )

//--------------------------------------------------------------------------//

STATIC FUNCTION GetValue( cType )

	local oDlg
	local cTemp   := Space( 100 )

	DEFAULT cType := "C"

	DEFINE DIALOG oDlg RESOURCE "GETVALUE"

	REDEFINE GET cTemp ;
		ID 101 ;
		OF oDlg

	REDEFINE BUTTON ;
		ID 1;
		OF oDlg ;
      ACTION ( oDlg:end( IDOK ) )

	ACTIVATE DIALOG oDlg CENTERED

   IF oDlg:nResult == IDOK

		DO CASE
		CASE cType == "C"
			cTemp = '"' + AllTrim( cTemp ) + '"'
		CASE cType == "N"
			cTemp = AllTrim( cTemp )
		CASE cType == "D"
			cTemp = 'CTOD( "' + AllTrim( cTemp ) + '" )'
		END CASE

	ELSE

		cTemp = ""

	END IF

RETURN ( cTemp )

//--------------------------------------------------------------------------//

/*
Esta funci¢n llama a la caja de dialogo encargada de obtener el codeblock
para filtrar la base de datos de manera analoga trabaja si no le pansan
argumentos quita el filtro
*/

FUNCTION Filtering( cAlias, aBase, oBrw )

	local cExpression := cGetExpression( cExpression, aBase, cAlias)

	IF At( Type( cExpression ), "UEUI" ) == 0
		(cAlias)->(dbSetFilter( &( "{|| " + cExpression + " }" ) ) )
	ELSE
		(cAlias)->(dbClearFilter(NIL))
	ENDIF

	(cAlias)->(DbGotop())

	IF oBrw != NIL
		oBrw:refresh()
	END IF

RETURN NIL

//----------------------------------------------------------------------------//

FUNCTION ChangeIndx( aIndexes, cAlias, oBrw )

	local oDlg
	local nLbx

	DEFAULT cAlias := Alias()

	nLbx := (cAlias)->(ORDNUMBER())

	DEFINE DIALOG oDlg RESOURCE "ChangeIndx"

	REDEFINE LISTBOX nLbx;
		ITEMS aIndexes;
		ID 110;
		OF oDlg

   REDEFINE BUTTON ID IDOK OF oDlg ;
      ACTION ( oDlg:End( IDOK ) )

	REDEFINE BUTTON ID IDCANCEL OF oDlg ;
		ACTION ( oDlg:End() )

	ACTIVATE DIALOG oDlg CENTERED

   IF oDlg:nResult == IDOK
		(cAlias)->(DBSETORDER( nLbx ) )
	END IF

	IF oBrw != NIL
		oBrw:refresh()
		oBrw:setfocus()
	END IF


RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION SetRep( cTitulo, cSubTitulo, nDevice )

	local oDlg

	DEFAULT cTitulo 		:= Space( 100 )
	DEFAULT cSubTitulo 	:= Space( 100 )
	DEFAULT nDevice		:= 1

	DEFINE DIALOG oDlg RESOURCE "SETREP"

	REDEFINE GET cTitulo ;
		ID 100 ;
		OF oDlg

	REDEFINE GET cSubTitulo ;
		ID 110 ;
		OF oDlg

	REDEFINE BUTTON ;
		ID 506;
		OF oDlg ;
      ACTION ( nDevice := 1, oDlg:end( IDOK ) )

	REDEFINE BUTTON ;
		ID 505;
		OF oDlg ;
      ACTION ( nDevice := 2, oDlg:end( IDOK ) )

	REDEFINE BUTTON ;
		ID 510;
		OF oDlg ;
		ACTION ( oDlg:end() )

	ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

/*
Caja de dialogo antes de abandonar la Aplicaci¢n por limite
de fechas
*/

FUNCTION DlgDateLimit()

	local oDlg
   local oFont1
	local hOldRes := GetResources()

	DEFINE FONT oFont1 NAME "Arial" SIZE 0, -14 BOLD

	SET RESOURCES TO "FwTools.dll"

	DEFINE DIALOG oDlg RESOURCE "REGISTER"

	REDEFINE SAY PROMPT "La aplicación ha Excedido la fecha" ;
		ID 10 ;
		OF oDlg ;
		FONT oFont1 ;
		COLOR "R/W"

	REDEFINE SAY PROMPT "programada para su uso.";
		ID 11;
		OF oDlg ;
		FONT oFont1 ;
		COLOR "R/W"

	REDEFINE BUTTON ;
      ID IDOK ;
		OF oDlg ;
		ACTION ( oDlg:end() )

	ACTIVATE DIALOG oDlg CENTER

	RELEASE FONT oFont1

	SetResources(hOldRes)

RETURN NIL

//----------------------------------------------------------------------------//

FUNCTION HelpBrowse( oGet, cAlias, cTitle, bAppend, bEdit )

	local oDlg
	local oGet1, cGet1
	local nRadio := 1
	local oBrw

	DEFAULT cAlias 	:= Alias()
	DEFAULT cTitle 	:= "Ayuda a la Entrada"
	DEFAULT bAppend	:= MsgInfo( "Append !" )
	DEFAULT bEdit		:= MsgInfo( "Edit !" )

	(cAlias)->(DBGOTOP())

	DEFINE DIALOG oDlg;
				RESOURCE "HELPENTRY";
				TITLE cTitle

		REDEFINE GET oGet1 VAR cGet1;
				ID 104 ;
            ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, cAlias ) );
            VALID    ( OrdClearScope( oBrw, cAlias ) );
            BITMAP   "FIND" ;
            OF oDlg

		REDEFINE RADIO nRadio ;
				ID 102, 103 ;
				ON CHANGE ( (cAlias)->(ORDSETFOCUS(nRadio )), oBrw:refresh() ) ;
				OF oDlg

		REDEFINE LISTBOX oBrw ;
				FIELDS (cAlias)->(FieldGet(1)), (cAlias)->(FieldGet(2)) ;
				ID 105 ;
				OF oDlg

		REDEFINE BUTTON ;
				ID 1 ;
				OF oDlg ;
            ACTION ( oGet:varput( (cAlias)->(FieldGet(1)) ), oDlg:end(IDOK) )

		REDEFINE BUTTON ;
				ID 2 ;
				OF oDlg ;
				ACTION ( oDlg:end() )

		REDEFINE BUTTON ;
				ID 110 ;
				OF oDlg ;
				ACTION ( Eval( bAppend, oBrw, cAlias ) )

		REDEFINE BUTTON ;
				ID 120 ;
				OF oDlg ;
				ACTION ( Eval( bEdit, oBrw, cAlias ) )

	ACTIVATE DIALOG oDlg

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

/*
Vacia un directorio completo
*/

FUNCTION EraseFilesInDirectory(cPath, cMask )

   DEFAULT cMask     := "*.*"

   aEval( Directory( cPath + cMask ), {|aFile| fErase( cPath + aFile[ 1 ] ) } )

   // aEval( Directory( cPath + cMask ), {|aFile| msgWait( str( fErase( cPath + aFile[ 1 ] ) ), cPath + aFile[ 1 ], 0.1 ) } )

RETURN NIL

//--------------------------------------------------------------------------//

/*
Funcion que espera unos segundos hasta que se pulse una tecla
*/

FUNCTION MsgTime( cMsg, cTitle, nSec )

   local oDlg, oMeter, oText, oBtn
	local nVal := 0
	local oTimer

	DEFAULT cMsg := "Processing...", cTitle := "Waiting...", nSec := 4

   DEFINE DIALOG oDlg FROM 5, 5 TO 10.4, 45 TITLE cTitle

	DEFINE TIMER oTimer INTERVAL 100;
					ACTION ( nVal := nVal + 0.1, oMeter:set( nVal ), if( nVal == nSec, oDlg:end(), ) )

   @ 0.2, 0.5  SAY oText VAR cMsg SIZE 130, 10 OF oDlg

	@ 1.2, 0.5  METER oMeter VAR nVal TOTAL nSec ;
					PROMPT "" ;
					NOPERCENTAGE ;
					SIZE 150, 5 ;
					OF oDlg

	@ 2.8,  18  BUTTON oBtn PROMPT "&Aceptar" OF oDlg ;
					ACTION ( oDlg:End() ) SIZE 32, 11

	oDlg:bStart = { || oTimer:activate() }

	ACTIVATE DIALOG oDlg CENTERED ;
					ON PAINT ( sysrefresh() ) ;
					VALID ( oTimer:end(), .t. )

RETURN NIL

//--------------------------------------------------------------------------//
/*
FUNCTION Calendario( dDate, cTitle)


  LOCAL oDialogo
  LOCAL oBrowse
  LOCAL aSemanas
  LOCAL nSemana   := 1
  LOCAL cMes
  LOCAL oMes
  LOCAL nMes
  LOCAL nAno,oAno
  LOCAL lSelect   := .f.
  LOCAL aMes      := {"Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"}
  LOCAL dSelect

  DEFAULT dDate   := Date()
  DEFAULT cTitle  := "Calendario"

  dSelect         := dDate

  nMes            := Max( Month( dDate ), 1 )
  cMes            := aMes[ nMes ]
  nAno            := Year( dDate )

  aSemanas        := aSemanas(nMes,nAno)

  DEFINE DIALOG oDialogo RESOURCE "Calendario" TITLE cTitle

    REDEFINE COMBOBOX oMes VAR cMes ID 101 OF oDialogo ITEMS aMes ;
             ON CHANGE ( aSemanas := aSemanas(oMes:nAt,nAno) , dSelect := RowColDate(DAY(dSelect),oMes:nAt,nAno,oBrowse,@nSemana) )
    REDEFINE GET oAno VAR nAno ID 102 OF oDialogo ;
             SPINNER ON UP (++nAno,oAno:Refresh(),EVAL(oAno:bValid)) ON DOWN (--nAno,oAno:Refresh(),EVAL(oAno:bValid)) MIN 0 MAX 9999 ;
             VALID ( aSemanas := aSemanas(oMes:nAt,nAno) , dSelect := RowColDate(DAY(dSelect),oMes:nAt,nAno,oBrowse,@nSemana) , .T. )

    REDEFINE LISTBOX oBrowse ;
                           FIELDS   aSemanas[nSemana][1], ;
                                    aSemanas[nSemana][2], ;
                                    aSemanas[nSemana][3], ;
                                    aSemanas[nSemana][4], ;
                                    aSemanas[nSemana][5], ;
                                    aSemanas[nSemana][6], ;
                                    aSemanas[nSemana][7] ;
                           HEADERS  " Lu",;
                                    " Ma",;
                                    " Mi",;
                                    " Ju",;
                                    " Vi",;
                                    " Sa",;
                                    " Do" ;
                           OF oDialogo ;
                           ON CLICK dSelect := GetDate(VAL(aSemanas[nSemana][oBrowse:nColact]),oMes:nAt,nAno) ;
                           ON DBLCLICK IF( EMPTY(aSemanas[nSemana][oBrowse:nColAct]) ,;
                                            ( nMes := oMes:nAt ,;
                               IF( nSemana = 1 , ( --nMes , IF(nMes<1,(nMes:=12,--nAno),) ) ,;
                                                 ( ++nMes , IF(nMes>12,(nMes:=1,++nAno),) ) ) ,;
                                                 oMes:Set(aMes[nMes]), oAno:Refresh(),;
                                                 aSemanas := aSemanas(nMes,nAno) , dSelect := RowColDate(DAY(dSelect),oMes:nAt,nAno,oBrowse,@nSemana) ) ,;
                             ( lSelect := .t. , oDialogo:End() ) ) ;
             ID 100

    oBrowse:bGotop     := { || nSemana := MIN(EVAL( oBrowse:bLogicLen ),1) }
    oBrowse:bGoBottom  := { || nSemana := EVAL( oBrowse:bLogicLen ) }
    oBrowse:bSkip      := { | nWant, nOld | nold := nSemana , nSemana += nWant,;
                             nSemana := MAX( 1, MIN( nSemana, EVAL( oBrowse:bLogicLen ))),;
                             nSemana - nOld }
    oBrowse:bLogicLen  := { || LEN(aSemanas) }
    oBrowse:cAlias     := "Array"
    oBrowse:bKeydown   := { | nKey | If( nKey == VK_RETURN , EVAL(oBrowse:bLDblClick) , EVAL(oBrowse:bLClicked) ) }
    oBrowse:aColSizes  := {25,25,25,25,25,25,25}
    oBrowse:lCellStyle := .t.
    oBrowse:lVScroll   := .f.
    oBrowse:lHScroll   := .f.

  ACTIVATE DIALOG oDialogo ON INIT RowColDate(DAY(dDate),nMes,nAno,oBrowse,@nSemana) CENTER

RETURN IF(lSelect,GetDate(VAL(aSemanas[nSemana][oBrowse:nColact]),oMes:nAt,nAno),dDate)
*/
//----------------------------------------------------------------------------//

Function Calendario( dDate, cTitle )

   local oDlg
   local oCal

   DEFAULT dDate  := Date()
   DEFAULT cTitle := "Calendario"

   DEFINE DIALOG oDlg RESOURCE "Calendar" TITLE cTitle

      oCal        := TCalendar():ReDefine( 100, { |u| if( pCount() == 0, dDate, dDate := u ) }, , oDlg, , , , , , , , , , , , {|| oDlg:End( IDOK ) }, {|| oDlg:End( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   if ( oDlg:nResult == IDOK )
      dDate       := oCal:GetDate()
   end if

RETURN ( dDate )

//----------------------------------------------------------------------------//


FUNCTION RowColDate(nDia,nMes,nAno,oBrowse,nSemana)

  LOCAL dFecha    := GetDate(nDia,nMes,nAno)
  LOCAL dFirstDay := dFecha - DAY(dFecha)

  oBrowse:GoTop()
  oBrowse:nColPos  = 1
  oBrowse:nColAct  = IF( DOW(dFecha) = 1 , 7 , DOW(dFecha) - 1 )
  nSemana = INT( ( DAY(dFecha) + DOW(dFirstDay) - 1 - oBrowse:nColAct + 7 ) / 7 )
  oBrowse:nRowPos = nSemana
  oBrowse:Refresh()

RETURN dFecha

//----------------------------------------------------------------------------//

FUNCTION GetDate(nDia,nMes,nAno)

  LOCAL dDate

  WHILE EMPTY( dDate := CTOD(STRZERO(nDia,2)+"/"+STRZERO(nMes,2)+"/"+STRZERO(nAno,4)) )
        --nDia
        nDia = MAX(nDia,1)
  END

RETURN dDate

//----------------------------------------------------------------------------//

FUNCTION aSemanas(nMes,nAno)

  LOCAL aSemana := {{"","","","","","",""}}
  LOCAL dFecha  := CTOD("01/"+STRZERO(nMes,2)+"/"+STRZERO(nAno,4))
  LOCAL nDia    := IF( DOW(dFecha) = 1 , 7 , DOW(dFecha) - 1 )
  LOCAL nSemana := 1

  WHILE MONTH(dFecha) = nMes
        IF nDia > 7
           nDia = 1
           ++nSemana
           AADD(aSemana,{"","","","","","",""})
        ENDIF
        aSemana[nSemana][nDia] = PADL( STR(DAY(dFecha)) , 4 )
        ++dFecha
        ++nDia
  END

RETURN aSemana

//---------------------------------------------------------------------------//

function aEvalValid( oDlg )

   local n
   local aControls := oDlg:aControls

   if aControls != nil .and. ! Empty( aControls )
      for n = 1 to Len( aControls )
          if aControls[ n ] != nil .and. aControls[ n ]:bValid != nil
             if !Eval( aControls[ n ]:bValid )
                oDlg:aControls[ n ]:SetFocus()
             endif
         endif
      next
   endif

return nil

//---------------------------------------------------------------------------//

Function PrintPreview( oDevice )

   local nFor
   local hMeta
   local aFiles   := oDevice:aMeta

   CursorWait()

   StartDoc( oDevice:hDC, oDevice:cDocument )

   for nFor := 1 to len( aFiles )
      StartPage( oDevice:hDC )
      hMeta := GetEnhMetaFile( aFiles[nFor] )
      PlayEnhMetaFile( oDevice:hDC, hMeta,, .t. )
      DeleteEnhMetafile( hMeta )
      EndPage( oDevice:hDC )
   next

   EndDoc( oDevice:hDC )

   CursorArrow()

return nil

//---------------------------------------------------------------------------//

Function Week( dDate )

   local nMonth
   local nDay
   local nYear
   local nWeek
   local dDate2

   if valtype( dDate ) == "D" .and. empty( dDate )
      return 0
   endif

   if empty( dDate )
      dDate    := date()
   endif

   nMonth      := month( dDate )
   nDay        := day( dDate )
   nYear       := year( dDate )

   dDate2      := dDate + 3 - ( ( dow( dDate ) + 5 ) % 7 )
   nWeek       := 1 + int( ( dDate2 - ctod( '01/01/' + str( year( dDate2 ) ) ) ) / 7 )

return nWeek

//---------------------------------------------------------------------------//

#ifndef __HARBOUR__

FUNCTION PrintPdf( oDevice )

   local aFiles      := oDevice:aMeta
   local cDocument   := oDevice:cDocument

   CursorWait()

   if I2PDF_License_C3() == 0

      aEval( aFiles, {|cFile| I2PDF_AddImage_C3( cFile ) } )

      I2PDF_SetDPI_C3( 96 )
      I2PDF_MakePDF_C3( cDocument )

   end if

   CursorArrow()

return nil

//---------------------------------------------------------------------------//

#else

//---------------------------------------------------------------------------//

FUNCTION PrintPdf( oDevice )

   CursorWait()

   I2PDF_License_xH()

   aEval( oDevice:aMeta, {|cFile| I2PDF_AddImage_xH( cFile ) } )

   I2PDF_SetDPI_xH( 96 )

   I2PDF_MakePDF_xH( oDevice:cDocument )

   CursorArrow()

return nil

//---------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//
//Funciones comunes del programa y pda
//---------------------------------------------------------------------------//


#endif

FUNCTION ExitNoSave( nMode, cAlias )

   IF ( cAlias ) != nil .and. ( cAlias )->( LastRec() ) == 0
      RETURN .t.
   END IF

	IF nMode == APPD_MODE
      RETURN ApoloMsgNoYes("¿ Salir sin grabar ?" , "!! Atención!!" )
	END IF

RETURN .t.

//--------------------------------------------------------------------------//

