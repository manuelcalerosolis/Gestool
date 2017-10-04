#include "FiveWin.Ch"
#include "Font.ch"
#include "Report.ch"

#define  FULL_SIZE  675
#define  HALF_SIZE  390

//---------------------------------------------------------------------------//

CLASS TInforme

   DATA nDevice      AS NUMERIC
   DATA cTitle
   DATA cSubTitle
   DATA aDbfTmp      AS ARRAY    INIT {}
   DATA cIndex
   DATA aStru        AS ARRAY    INIT {}
   DATA bRedefine
   DATA aCols        AS ARRAY    INIT {}
   DATA bFilter
   DATA uFrom
   DATA uTo
   DATA nSize        AS NUMERIC  INIT 12
   DATA aOrd         AS ARRAY    INIT {}
   DATA cAlias
   DATA lOpen        AS LOGIC    INIT .f.
   DATA aoCols       AS ARRAY    INIT {}
   DATA bHelp
   DATA oIni         AS OBJECT
   DATA lSave2Exit   AS LOGIC    INIT .t.

   METHOD New( aoCols, aOrd, bHelp, cTitle, cSubTitle, uAlias ) CONSTRUCTOR

   METHOD Activate()

   METHOD Generate( nDevice )

   METHod lResources()

   METHOD ChgIndex( oCmb )       INLINE ( ::cAlias )->( OrdSetFocus( oCmb:nAt ) )

   METHOD Redefine() INLINE Eval( ::bRedefine, self )

   METHOD UpColumn( oBrw )

   METHOD DwColumn( oBrw )

   METHOD Default()

   METHOD Save()

   METHOD Filter()   INLINE msgInfo( "Filter" )

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( aoCols, aOrd, bHelp, cTitle, cSubTitle, uAlias, uAliasDet ) CLASS TInforme

   DEFAULT aoCols    := {}
   DEFAULT cTitle    := "Titulo del informe"
   DEFAULT cSubTitle := "Subtitulo del informe"
   DEFAULT aOrd      := {""}
   DEFAULT uAlias    := Alias()
   DEFAULT bHelp     := {|| msginfo( "No definida ayuda." ) }

   ::aoCols          := aoCols
   ::cAlias          := if( Valtype( uAlias ) == "O", uAlias:cAlias, uAlias )
   ::aOrd            := aOrd
   ::cTitle          := cTitle
   ::cSubTitle       := cSubTitle
   ::bHelp           := bHelp

   /*
   Aplicamos los valores segun se han archivado--------------------------------
   */

   ::Default()

   /*
   ::aColPos         := array( len( aFlds ) )
   aeval( ::aColPos, {| x, n | ::aColPos[n] := n } )
   */

RETURN Self

//----------------------------------------------------------------------------//

METHOD Activate() CLASS TInforme

   /*
   if ::Resources()
      msginfo( "Salida OK" )
   else
      msginfo( "Salida no OK" )
   end if
   */

RETURN ::Resources()

//----------------------------------------------------------------------------//

METHOD End() CLASS TInforme

   if ::lSave2Exit
      ::Save()
   end if

RETURN .t.

//----------------------------------------------------------------------------//

METHod lResources() CLASS TInforme

   local oDlg
   local oOrdCmb
   local cOrdCmb
   local oFrom
   local oTo
   local oSayFrom
   local uSayFrom    := ""
   local oSayTo
   local uSayTo      := ""
   local oBmp        := LoadBitmap( 0, 32760 )
   local oBrwCol

   ( ::cAlias )->( dbGoTop() )
   ::uFrom           := ( ::cAlias )->( OrdKeyVal() )
   ( ::cAlias )->( dbGoBottom() )
   ::uTo             := ( ::cAlias )->( OrdKeyVal() )
   ( ::cAlias )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "REP_STD"

   REDEFINE COMBOBOX oOrdCmb VAR cOrdCmb ;
      ITEMS    ::aOrd ;
      ID       100 ;
		OF 		oDlg

      oOrdCmb:bChange := {|| ::ChgIndex( oOrdCmb ) }

   REDEFINE GET oFrom VAR ::uFrom ;
		ID 		110 ;
      VALID    lRetFld( ::uFrom, ::cAlias, oSayFrom ) ;
		OF 		oDlg

      oFrom:bHelp := ::bHelp

   REDEFINE GET oSayFrom VAR uSayFrom ;
      ID       120 ;
      WHEN     .f. ;
		OF 		oDlg

   REDEFINE GET oTo VAR ::uTo ;
      ID       130 ;
      VALID    lRetFld( ::uTo, ::cAlias, oSayTo ) ;
		OF 		oDlg

      oTo:bHelp   := ::bHelp

   REDEFINE GET oSayTo VAR uSayTo ;
      ID       140 ;
      WHEN     .f. ;
		OF 		oDlg

   REDEFINE GET ::nSize ;
		PICTURE	"@E 99" ;
		SPINNER ;
      MIN      6 ;
      MAX      72 ;
      VALID    ::nSize >= 6 .AND. ::nSize <= 72 ;
      ID       160 ;
		OF 		oDlg

   REDEFINE GET ::cTitle ;
      ID       170 ;
		OF 		oDlg

   REDEFINE GET ::cSubTitle ;
      ID       180 ;
		OF 		oDlg

   REDEFINE CHECKBOX ::lOpen ;
      ID       190 ;
      ON CHANGE( setSize( oDlg, ::lOpen ) );
      OF       oDlg

   REDEFINE CHECKBOX ::lSave2Exit ;
      ID       191 ;
      OF       oDlg

   REDEFINE LISTBOX oBrwCol;
      FIELDS   if( ::aoCols[ oBrwCol:nAt ]:lSelect, oBmp, "" ),;
               ::aoCols[ oBrwCol:nAt ]:cTitle ;
      FIELDSIZES ;
               14,;
               40 ;
      HEAD     "S",;
               "Columna" ;
      ID       200 ;
      OF       oDlg

      oBrwCol:SetArray( ::aoCols )

   REDEFINE BUTTON ;
      ID       538 ;
		OF 		oDlg ;
      ACTION   ::UpColumn( oBrwCol )

   REDEFINE BUTTON ;
      ID       539 ;
		OF 		oDlg ;
      ACTION   ::DwColumn( oBrwCol )

   REDEFINE BUTTON ;
      ID       514 ;
      OF       oDlg ;
      ACTION   ( ::aoCols[ oBrwCol:nAt ]:Select(), oBrwCol:SetFocus(), oBrwCol:Refresh() )

   REDEFINE BUTTON ;
      ID       540 ;
      OF       oDlg ;
      ACTION   ( ::aoCols[ oBrwCol:nAt ]:UnSelect(), oBrwCol:SetFocus(), oBrwCol:Refresh() )

   REDEFINE BUTTON ;
      ID       501 ;
      OF       oDlg ;
      ACTION   ( ::aoCols[ oBrwCol:nAt ]:lEditCol(), oBrwCol:Refresh() )

   REDEFINE BUTTON ;
		ID 		531 ;
		OF 		oDlg ;
      ACTION   ( ::Filter() )

   REDEFINE BUTTON ;
      ID       508;
		OF 		oDlg ;
      ACTION   ( ::Generate( 1 ) )

	REDEFINE BUTTON ;
		ID 		505;
		OF 		oDlg ;
      ACTION   ( ::Generate( 2 ) )

	REDEFINE BUTTON ;
		ID 		510;
		OF 		oDlg ;
		ACTION 	( oDlg:end() )

   oDlg:bStart := {|| SetSize( oDlg, ::lOpen ), oFrom:lValid(), oTo:lValid() }

   ACTIVATE DIALOG oDlg CENTER

   DeleteObject( oBmp )

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

static function lRetFld( uSearch, Alias, oSay, nFld )

   local lReturn  := .t.

   DEFAULT nFld   := 2

   if valtype( uSearch ) == "C"
      uSearch     := Upper( uSearch )
   end if

   if ( Alias )->( dbSeek( uSearch ) )
      oSay:cText( ( Alias )->( fieldGet( nFld ) ) )
   else
      msgStop( "Registro no encontrado" )
      lReturn     := .f.
   end if

return lReturn

//----------------------------------------------------------------------------//

static function setSize( oDlg, lOpen )

   local aRect := GetWndRect( oDlg:hWnd )

   if lOpen
      oDlg:Move( aRect[1], aRect[2], FULL_SIZE, oDlg:nHeight, .t. )
   else
      oDlg:Move( aRect[1], aRect[2], HALF_SIZE, oDlg:nHeight, .t. )
   end if

return nil

//----------------------------------------------------------------------------//
//
// Genera el infome
//

METHOD Generate( nDevice ) CLASS TInforme

   local nFor
   local oFnt1
   local oFnt2
   local oReport

   ( ::cAlias )->( DbGoTop() )

   DEFINE FONT oFnt1 NAME "Arial" SIZE 0, - ( ::nSize ) BOLD
   DEFINE FONT oFnt2 NAME "Arial" SIZE 0, - ( ::nSize )

   IF nDevice == 1

      REPORT oReport ;
            TITLE    Rtrim( ::cTitle    ),;
                     Rtrim( ::cSubTitle ) ;
            FONT     oFnt1, oFnt2 ;
            HEADER   "Fecha : " + dtoc(date()) RIGHT ;
				FOOTER 	"Página : " + str( oReport:nPage, 3 ) CENTERED;
            CAPTION  Rtrim( ::cTitle ) ;
				PREVIEW

   ELSE

      REPORT oReport ;
            TITLE    Rtrim( ::cTitle    ),;
                     Rtrim( ::cSubTitle ) ;
            FONT     oFnt1, oFnt2 ;
            HEADER   "Fecha : " + dtoc(date()) RIGHT ;
				FOOTER 	"Página : " + str( oReport:nPage, 3 ) CENTERED;
            CAPTION  Rtrim( ::cTitle ) ;
            TO PRINTER

   END IF

   for nFor := 1 to len( ::aoCols )

      if ::aoCols[ nFor ]:lSelect

         RptAddColumn(  { bHeaders( nFor, Self ) } ,;       // aTitle
                        ,;                                  // nCol
                        { bFlds( nFor, Self ) } ,;          // aData
                        ::aoCols[ nFor ]:nSize ,;           // nSize ::aColSizes[ nFor ]
                        { ::aoCols[ nFor ]:bPict } ,;       // aPicture
                        {|| 2 } ,;                          // uFont
                        ::aoCols[ nFor ]:lTotal ,;          // lTotal
                        nil ,;                              // bTotalExpr
                        nil ,;                              // cColFmt
                        ::aoCols[ nFor ]:lSombra ,;         // lShadow
                        ::aoCols[ nFor ]:lSeparador ,;      // lGrid
                        nil )                               // nPen)

      end if

   next

   END REPORT

   IF !Empty( oReport ) .and.  oReport:lCreated
      oReport:Margin( 0, RPT_RIGHT, RPT_CMETERS)
      oReport:bSkip  := {|| ( ::cAlias )->( DbSkip( 1 ) ) }
   END IF

   ACTIVATE REPORT oReport;
      FOR   ( ::cAlias )->( fieldGet( 1 ) ) >= ::uFrom .AND. ;
            ( ::cAlias )->( fieldGet( 1 ) ) <= ::uTo ;
      WHILE !( ::cAlias )->( eof() )

   oFnt1:end()
   oFnt2:end()

RETURN NIL

//----------------------------------------------------------------------------//

static function bHeaders( nFor, Self )
return {|| ::aoCols[ nFor ]:cTitle }

//----------------------------------------------------------------------------//

static function bFlds( nFor, Self )

   if valType( ::aoCols[ nFor ] ) == "B"
      return ::aoCols[ nFor ]
   end if

return ( ::aoCols[ nFor ]:bFld )

//----------------------------------------------------------------------------//

METHOD UpColumn( oBrw ) CLASS TInforme

   local nPos  := oBrw:nAt

   if nPos <= len( ::aoCols ) .and. nPos > 1

      SwapUpArray( ::aoCols, nPos )

      oBrw:GoUp()
      oBrw:Refresh()
      oBrw:SetFocus()

   end if

return nil

//----------------------------------------------------------------------------//

METHOD DwColumn( oBrw ) CLASS TInforme

   local nPos  := oBrw:nAt

   if nPos < len( ::aoCols ) .and. nPos > 0

      SwapDwArray( ::aoCols, nPos )

      oBrw:GoDown()
      oBrw:Refresh()
      oBrw:SetFocus()

   end if

return nil

//----------------------------------------------------------------------------//
//
// Este metodo compara los valores con el fichero ini
//

METHOD Default() CLASS TInforme

   /*
   Orden de las columnas

   for n := 1 to nCols
      nPos        := ::oIni:Get( ::cTitle, "POSINF" + allTrim( str( n ) ), n )
      atCols[ n ] := ::aoCols[ nPos ]
   next
   ::aoCols       := atCols
   */

   /*
   Columnas seleccionadas o no seleccionadas

   for n := 1 to nCols

      cStr  := allTrim( str( n ) )
      ::aoCols[ n ]:lSelect   := ::oIni:Get( ::cTitle, "SELINF" + cStr, ::aoCols[ n ]:lSelect )
      ::aoCols[ n ]:cTitle    := ::oIni:Get( ::cTitle, "TITINF" + cStr, ::aoCols[ n ]:cTitle )
      ::aoCols[ n ]:nSize     := ::oIni:Get( ::cTitle, "SIZINF" + cStr, ::aoCols[ n ]:nSize )
      ::aoCols[ n ]:nPad      := ::oIni:Get( ::cTitle, "ALNINF" + cStr, ::aoCols[ n ]:nPad )       // Alineacion
      ::aoCols[ n ]:lTotal    := ::oIni:Get( ::cTitle, "TOTINF" + cStr, ::aoCols[ n ]:lTotal )     // Totalizada
      ::aoCols[ n ]:lSombra   := ::oIni:Get( ::cTitle, "SOMINF" + cStr, ::aoCols[ n ]:lSombra )    // Sombreada
      ::aoCols[ n ]:lSeparador:= ::oIni:Get( ::cTitle, "SEPINF" + cStr, ::aoCols[ n ]:lSeparador ) // Separador

   next
   */

RETURN ( SELF )

//----------------------------------------------------------------------------//

METHOD Save() CLASS TInforme

   /*
   for n := 1 to nCols

      cStr  := allTrim( str( n ) )
      ::oIni:Set( ::cTitle, "POSINF" + cStr, ::aoCols[ n ]:nPos )       // Posicion
      ::oIni:Set( ::cTitle, "SELINF" + cStr, ::aoCols[ n ]:lSelect )    // Seleccionada o no
      ::oIni:Set( ::cTitle, "TITINF" + cStr, ::aoCols[ n ]:cTitle )     // Titulo
      ::oIni:Set( ::cTitle, "SIZINF" + cStr, ::aoCols[ n ]:nSize )      // Ancho
      ::oIni:Set( ::cTitle, "ALNINF" + cStr, ::aoCols[ n ]:nPad )       // Alineacion
      ::oIni:Set( ::cTitle, "TOTINF" + cStr, ::aoCols[ n ]:lTotal )     // Totalizada
      ::oIni:Set( ::cTitle, "SOMINF" + cStr, ::aoCols[ n ]:lSombra )    // Sombreada
      ::oIni:Set( ::cTitle, "SEPINF" + cStr, ::aoCols[ n ]:lSeparador ) // Separador

   next
   */

RETURN ( SELF )

//----------------------------------------------------------------------------//