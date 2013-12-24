#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Menu.ch"
#include "Report.ch"
#include "Print.ch"
#include "MesDbf.ch"

//--------------------------------------------------------------------------//

CLASS TDetItems FROM TDet

   CLASSDATA   aResAjust      AS ARRAY    INIT  { "ALIGN_LEFT", "ALIGN_CENTER", "ALIGN_RIGHT" }
   CLASSDATA   aCbxAjust      AS ARRAY    INIT  { "Izquierda", "Centro", "Derecha" }
   CLASSDATA   aFont          AS ARRAY    INIT  aGetFont( oWnd() )
   CLASSDATA   aSizes         AS ARRAY    INIT  { " 6", " 7", " 8", " 9", "10", "11", "12", "13", "14", "16", "18", "20", "22", "24", "26", "28", "36", "48", "72" }
   CLASSDATA   aEstilo        AS ARRAY    INIT  { "Normal", "Cursiva", "Negrita", "Negrita Cursiva" }

   METHOD DefineFiles()

   METHOD OpenFiles( lExclusive )

   METHOD Resource( nMode, lLiteral )

END CLASS

//--------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver ) CLASS TDetItems

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   /*
   Chequa la concordancia entre estructuras
   */

   DEFINE DATABASE ::oDbf FILE "Ritems.Dbf" CLASS "Ritems" ALIAS "Ritmes" PATH ( cPath ) VIA ( cDriver ) COMMENT  "Items de los informes"

      FIELD NAME "Codigo"     TYPE "C" LEN   3 DEC 0 COMMENT "Código"                                                OF ::oDbf
      FIELD NAME "cLiteral"   TYPE "C" LEN  25 DEC 0 COMMENT "Expresión"                                             OF ::oDbf
      FIELD NAME "nLinea"     TYPE "N" LEN   6 DEC 2 COMMENT "Fila"                            PICTURE "@E 999.99"   OF ::oDbf
      FIELD NAME "nColumna"   TYPE "N" LEN   6 DEC 2 COMMENT "Columna"                         PICTURE "@E 999.99"   OF ::oDbf
      FIELD NAME "cFichero"   TYPE "C" LEN  50 DEC 0 COMMENT "Fichero"                                               OF ::oDbf
      FIELD NAME "cCampo"     TYPE "C" LEN 100 DEC 0 COMMENT "Campo"                                                 OF ::oDbf
      FIELD NAME "cMascara"   TYPE "C" LEN 100 DEC 0 COMMENT "Mascara"                                               OF ::oDbf
      FIELD NAME "lLiteral"   TYPE "L" LEN   1 DEC 0 COMMENT "Texto fijo"                                            OF ::oDbf
      FIELD NAME "nAjuste"    TYPE "N" LEN   1 DEC 0 COMMENT "Alineación"                                            OF ::oDbf
      FIELD NAME "lCondicion" TYPE "C" LEN  60 DEC 0 COMMENT ""                                HIDE                  OF ::oDbf
      FIELD NAME "nSize"      TYPE "N" LEN   6 DEC 2 COMMENT ""                                HIDE                  OF ::oDbf
      FIELD NAME "fHeight"    TYPE "N" LEN  10 DEC 0 COMMENT ""                                HIDE                  OF ::oDbf
      FIELD NAME "fWidth"     TYPE "N" LEN  10 DEC 0 COMMENT ""            DEFAULT " 8"        HIDE                  OF ::oDbf
      FIELD NAME "fEscape"    TYPE "N" LEN  10 DEC 0 COMMENT ""                                HIDE                  OF ::oDbf
      FIELD NAME "fOrient"    TYPE "N" LEN  10 DEC 0 COMMENT ""                                HIDE                  OF ::oDbf
      FIELD NAME "fWeight"    TYPE "N" LEN  10 DEC 0 COMMENT ""                                HIDE                  OF ::oDbf
      FIELD NAME "fItalic"    TYPE "L" LEN   1 DEC 0 COMMENT ""                                HIDE                  OF ::oDbf
      FIELD NAME "fUnderline" TYPE "L" LEN   1 DEC 0 COMMENT ""                                HIDE                  OF ::oDbf
      FIELD NAME "fStrikeout" TYPE "L" LEN   1 DEC 0 COMMENT ""                                HIDE                  OF ::oDbf
      FIELD NAME "fCharset"   TYPE "N" LEN  10 DEC 0 COMMENT ""                                HIDE                  OF ::oDbf
      FIELD NAME "fOutprecis" TYPE "N" LEN  10 DEC 0 COMMENT ""                                HIDE                  OF ::oDbf
      FIELD NAME "fCliprecis" TYPE "N" LEN  10 DEC 0 COMMENT ""                                HIDE                  OF ::oDbf
      FIELD NAME "fQuality"   TYPE "N" LEN  10 DEC 0 COMMENT ""                                HIDE                  OF ::oDbf
      FIELD NAME "fPitchand"  TYPE "N" LEN  10 DEC 0 COMMENT ""                                HIDE                  OF ::oDbf
      FIELD NAME "fFacename"  TYPE "C" LEN  20 DEC 0 COMMENT ""            DEFAULT "Courier"   HIDE                  OF ::oDbf
      FIELD NAME "fColor"     TYPE "N" LEN  10 DEC 0 COMMENT ""                                HIDE                  OF ::oDbf
      FIELD NAME "lNotCaja"   TYPE "L" LEN   1 DEC 0 COMMENT ""                                HIDE                  OF ::oDbf
      FIELD NAME "lSel"       TYPE "L" LEN   1 DEC 0 COMMENT ""                                HIDE                  OF ::oDbf

      INDEX TO "Ritems.Cdx" TAG "Codigo" ON "Codigo + Str( nLinea) + Str( nColumna )" COMMENT "Código" NODELETED     OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//--------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive ) CLASS TDetItems

   DEFAULT lExclusive   := .f.

   if Empty( ::oDbf )
      ::DefineFiles()
   end if

   ::oDbf:Activate( .f., !( lExclusive ) )

   msginfo( "Abierto" )

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD Resource( nMode, lLiteral )

   local oCbxAjust
   local cCbxAjust      := ::aCbxAjust[ Max( ::oDbf:nAjuste, 1 ) ]
   local oEstilo
   local cEstilo        := cEstilo( ::oDbf:fItalic, ::oDbf:fStrikeOut )
   local nSeaColor      := aScan( ::oParent:aRgbColor, ::oDbf:fColor )

   DEFAULT lLiteral     := .f.

   DEFINE DIALOG oDlg RESOURCE "CABECERA_1"

      REDEFINE GET ::aGet:cLiteral VAR ::oDbf:cLiteral;
         ID       110 ;
			OF 		oDlg

      REDEFINE GET ::aGet:cCampo VAR ::oDbf:cCampo ;
			ID 		120 ;
			OF 		oDlg

      REDEFINE GET ::aGet:cFichero VAR ::oDbf:cFichero ;
			ID 		130 ;
			OF 		oDlg

      REDEFINE GET ::aGet:nLinea VAR ::oDbf:nLinea;
			SPINNER ;
         ON UP    ::aGet:nLinea:cText( ::aGet:nLinea:Value + .1 ) ;
         ON DOWN  ::aGet:nLinea:cText( ::aGet:nLinea:Value - .1 ) ;
			PICTURE 	"@E 9,999.9" ;
			ID 		150 ;
			OF 		oDlg

      REDEFINE GET ::aGet:nColumna VAR ::oDbf:nColumna ;
			SPINNER ;
         ON UP    ::aGet:nColumna:cText( ::aGet:nColumna:Value + .1 ) ;
         ON DOWN  ::aGet:nColumna:cText( ::aGet:nColumna:Value - .1 ) ;
			PICTURE 	"@E 9,999.9" ;
			ID 		160 ;
			OF 		oDlg

		REDEFINE COMBOBOX oCbxAjust VAR cCbxAjust ;
         ITEMS    ::aCbxAjust ;
         BITMAPS  ::aResAjust ;
         ID       170 ;
			OF 		oDlg

      REDEFINE GET ::aGet:nSize VAR ::oDbf:nSize ;
			SPINNER ;
         PICTURE  "@E 9,999" ;
			ID 		180 ;
			OF 		oDlg

      REDEFINE GET ::aGet:cMascara VAR ::oDbf:cMascara ;
			ID 		190 ;
			OF 		oDlg

      REDEFINE COMBOBOX ::aGet:fFaceName VAR ::oDbf:fFaceName ;
         ID       200 ;
         ITEMS    ::aFont ;
         OF       oDlg

      REDEFINE COMBOBOX ::aGet:fWidth VAR ::oDbf:fWidth ;
         ID       201 ;
         ITEMS    ::aSizes ;
         OF       oDlg

      REDEFINE COMBOBOX oEstilo VAR cEstilo ;
         ID       202 ;
         ITEMS    ::aEstilo ;
         OF       oDlg

      REDEFINE COMBOBOX ::aGet:fColor VAR cTxtColor;
         ID       203;
         ITEMS    ::aStrColor;
         BITMAPS  ::aResColor;
         OF       oDlg

      REDEFINE GET ::aGet:lCondicion VAR ::oDbf:lCondicion ;
         ID       220 ;
			OF 		oDlg

      REDEFINE CHECKBOX ::oDbf:lNotCaja ;
         ID       230 ;
			OF 		oDlg

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//