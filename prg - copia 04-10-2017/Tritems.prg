#include "FiveWin.Ch"
#include "Folder.ch"
#include "Factu.ch" 
#include "Menu.ch"
#include "Report.ch"
#include "Print.ch"
#include "MesDbf.ch"

#define FW_NORMAL          400
#define FW_BOLD            700

//----------------------------------------------------------------------------//

CLASS TRItems FROM TMASDET

   DATA  oDbfItm

   DATA  aStrColor  AS  ARRAY    INIT  {  "Negro",;
                                          "Rojo oscuro",;
                                          "Verde oscuro",;
                                          "Oliva",;
                                          "Azul marino",;
                                          "Púrpura",;
                                          "Verde azulado",;
                                          "Gris",;
                                          "Plateado",;
                                          "Rojo",;
                                          "Verde",;
                                          "Amarillo",;
                                          "Azul",;
                                          "Fucsia",;
                                          "Aguamarina",;
                                          "Blanco" }

   DATA  aResColor  AS ARRAY     INIT  {  "COL_00",;
                                          "COL_01",;
                                          "COL_02",;
                                          "COL_03",;
                                          "COL_04",;
                                          "COL_05",;
                                          "COL_06",;
                                          "COL_07",;
                                          "COL_08",;
                                          "COL_09",;
                                          "COL_10",;
                                          "COL_11",;
                                          "COL_12",;
                                          "COL_13",;
                                          "COL_14",;
                                          "COL_15" }

   DATA  aRgbColor  AS ARRAY     INIT  {  Rgb( 0, 0, 0 ),;
                                          Rgb( 128, 0, 0 ),;
                                          Rgb( 0, 128, 0 ),;
                                          Rgb( 128, 128, 128 ),;
                                          Rgb( 0, 0, 128 ),;
                                          Rgb( 128, 0, 128 ),;
                                          Rgb( 0, 128, 128 ),;
                                          Rgb( 128, 128, 128 ),;
                                          Rgb( 192, 192, 192 ),;
                                          Rgb( 255, 0, 0 ),;
                                          Rgb( 0, 255, 0 ),;
                                          Rgb( 255, 255, 0 ),;
                                          Rgb( 0, 0, 255 ),;
                                          Rgb( 255, 0, 255 ),;
                                          Rgb( 0, 255, 255 ) }

   DATA  aTipDoc  AS ARRAY    INIT     {  "PP - Pedido proveedores",;
                                          "AP - Albaran proveedores",;
                                          "FP - Factura proveedores",;
                                          "RP - Recibos facturas proveedor",;
                                          "RC - Presupuesto clientes",;
                                          "PC - Pedido clientes",;
                                          "AC - Albaran clientes",;
                                          "FC - Factura clientes",;
                                          "TC - Tikets clientes",;
                                          "RF - Recibos facturas clientes",;
                                          "DA - Depositos almacen" }

   METHOD DefineFiles()

   METHOD OpenFiles( lExclusive )

   METHOD Resource( nMode )

   METHOD AddDetail()

END CLASS

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver ) CLASS TRItems

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE ::oDbf FILE "RDocumen.Dbf" CLASS "RDOCUMEN" ALIAS "RDOCUMEN" PATH ( cPath ) VIA ( cDriver ) COMMENT "Documentos"

      FIELD NAME "cTipo"      TYPE "C" LEN   2  DEC 0 PICTURE "@!"                         COMMENT "Tipo"             COLSIZE 40  HIDE  OF ::oDbf
      FIELD NAME "Codigo"     TYPE "C" LEN   3  DEC 0 PICTURE "@!"                         COMMENT "Código"           COLSIZE 40        OF ::oDbf
      FIELD NAME "nLenPag"    TYPE "N" LEN   6  DEC 2 PICTURE "@E 9.999,99"                COMMENT "Longitud página"  COLSIZE 40  HIDE  OF ::oDbf
      FIELD NAME "nWidPag"    TYPE "N" LEN   6  DEC 2 PICTURE "@E 9.999,99"                COMMENT "Ancho página"     COLSIZE 40  HIDE  OF ::oDbf
      FIELD NAME "nInicio"    TYPE "N" LEN   6  DEC 2 PICTURE "@E 9.999,99"                COMMENT "Longitud página"  COLSIZE 40  HIDE  OF ::oDbf
      FIELD NAME "nFin"       TYPE "N" LEN   6  DEC 2 PICTURE "@E 9.999,99"                COMMENT "Longitud página"  COLSIZE 40  HIDE  OF ::oDbf
      FIELD NAME "nLefT"      TYPE "N" LEN   6  DEC 2 PICTURE "@E 9.999,99"                COMMENT "Longitud página"  COLSIZE 40  HIDE  OF ::oDbf
      FIELD NAME "nRight"     TYPE "N" LEN   6  DEC 2 PICTURE "@E 9.999,99"                COMMENT "Longitud página"  COLSIZE 40  HIDE  OF ::oDbf
      FIELD NAME "nTypeline"  TYPE "N" LEN   1  DEC 0                                      COMMENT "Longitud página"  COLSIZE 40  HIDE  OF ::oDbf
      FIELD NAME "cDescrip"   TYPE "C" LEN 100  DEC 0 PICTURE "@!"                         COMMENT "Descripción"      COLSIZE 400       OF ::oDbf
      FIELD NAME "nAjuste"    TYPE "N" LEN   1  DEC 0                                      COMMENT "Longitud página"  COLSIZE 40  HIDE  OF ::oDbf
      FIELD NAME "nImpSel"    TYPE "N" LEN   1  DEC 0                                      COMMENT "Longitud página"  COLSIZE 40  HIDE  OF ::oDbf
      FIELD NAME "cImpSel"    TYPE "C" LEN 256  DEC 0                                      COMMENT "Longitud página"  COLSIZE 40  HIDE  OF ::oDbf

      INDEX TO "RDocumen.Cdx" TAG "Codigo"  ON "Codigo"          COMMENT "Código"  NODELETED OF ::oDbf
      INDEX TO "RDocumen.Cdx" TAG "Tipo"    ON "cTipo + Codigo"  COMMENT ""        NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive ) CLASS TRItems

   DEFAULT lExclusive   := .f.

   if Empty( ::oDbf )
      ::DefineFiles()
   end if

   ::oDbf:Activate( .f., !( lExclusive ) )

   ::cFirstKey          := ::oDbf:Codigo

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS TRItems

   local oDlg
   local oFld
   local nPos
   local oBrwItm
   local cTipDoc
   local oCodDes
   local cCodDes  := Space( 3 )
   local oDesDes
   local cDesDes  := ""
   local aAjuste  := { "Izquierda", "Centro", "Derecha" }
   local aLiteral := { LoadBitmap( 0, 32760 ) }

   if nMode == APPD_MODE
      nPos        := aScan( ::aTipDoc, {| cTipDoc | substr( cTipDoc, 1, 2 ) == ::oDbf:cTipo } )
      cTipDoc     := aTipDoc[ if( nPos != 0, nPos, 1 )  ]
   end if

   DEFINE DIALOG oDlg RESOURCE "DOCUMENTS" TITLE "Documento : " + Rtrim( ::oDbf:cDescrip )

	REDEFINE FOLDER oFld ;
      ID       400 ;
      OF       oDlg ;
      PROMPT   "&General",    "&Campos" ,    "C&olumnas",   "&Bitmaps",    "C&ajas" ;
      DIALOGS  "DOCUMENTS_2", "DOCUMENTS_1", "DOCUMENTS_3", "DOCUMENTS_5", "DOCUMENTS_4"

	/*
	Creamos la segunda caja de Dialogo
	---------------------------------------------------------------------------
	*/

		REDEFINE COMBOBOX cTipDoc ;
			WHEN 		( nMode == APPD_MODE ) ;
         ITEMS    ::aTipDoc ;
			ID 		100 ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET ::aGet:Codigo VAR ::oDbf:Codigo ;
         VALID    ( NotValid( ::aGet:Codigo, ::oDbf ) );
         WHEN     ( nMode == APPD_MODE ) ;
         PICTURE  "@!" ;
			ID 		110 ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET ::aGet:cDescrip VAR ::oDbf:cDescrip ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			ON CHANGE( ActTitle( nKey, nFlags, Self, nMode, oDlg ) );
			ID 		120 ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oCodDes VAR cCodDes ;
			WHEN 		( nMode == APPD_MODE ) ;
         VALID    ( lImpDoc( SubStr( cTipDoc, 1, 2 ), cCodDes, ::oDbf, oDesDes ) );
         PICTURE  "@!" ;
         ID       130 ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET oDesDes VAR cDesDes ;
			WHEN 		( .F. ) ;
			ID 		140 ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET ::aGet:nLenPag VAR ::oDbf:nLenPag ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			PICTURE	"@E 999.99" ;
         ID       150 ;
         OF       oFld:aDialogs[1] ;
         SPINNER ;
         MIN       1 ;
         MAX      28

      REDEFINE GET ::aGet:nWidPag VAR ::oDbf:nWidPag ;
			SPINNER ;
         MIN       1 ;
         MAX      30 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			PICTURE	"@E 999.99" ;
         ID       160 ;
			OF 		oFld:aDialogs[1]

      REDEFINE GET ::aGet:nInicio VAR ::oDbf:nInicio ;
			SPINNER ;
         MIN      0 ;
         MAX      28 ;
         PICTURE  "@E 999.99" ;
         ID       170 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET ::aGet:nLeft VAR ::oDbf:nLeft ;
			SPINNER ;
         MIN      0 ;
         MAX      30 ;
         PICTURE  "@E 999.99" ;
         ID       180 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET ::aGet:nRight VAR ::oDbf:nRight ;
			SPINNER ;
         MIN      0 ;
         MAX      30 ;
         PICTURE  "@E 999.99" ;
         ID       190 ;
         OF       oFld:aDialogs[1]

      REDEFINE GET ::aGet:nFin VAR ::oDbf:nFin ;
			SPINNER ;
         MIN      0 ;
         MAX      28 ;
         PICTURE  "@E 999.99" ;
         ID       200 ;
         OF       oFld:aDialogs[1]

      REDEFINE RADIO ::aGet:nTypeLine VAR ::oDbf:nTypeLine ;
         ID       210, 211, 212 ;
         OF       oFld:aDialogs[1]

      // Segunda caja de dialogo ----------------------------------------------

      REDEFINE LISTBOX oBrwItm ;
			FIELDS ;
                  if( ::oDbfItm:oDbfVir:lSel, aLiteral[1], "" )                     ,;
                  ::oDbfItm:oDbfVir:cLiteral                                        ,;
                  Trans( ::oDbfItm:oDbfVir:nLinea, "@E 999.99" )                    ,;
                  Trans( ::oDbfItm:oDbfVir:nColumna, "@E 999.99" )                  ,;
                  aAjuste[ Max( ::oDbfItm:oDbfVir:nAjuste, 1 ) ]                    ,;
                  ::oDbfItm:oDbfVir:cMascara                                        ,;
                  ::oDbfItm:oDbfVir:fFaceName                                       ,;
                  Trans( ::oDbfItm:oDbfVir:fWidth, "@E 999" )                       ,;
                  cEstilo( ::oDbfItm:oDbfVir:fItalic, ::oDbfItm:oDbfVir:fStrikeOut );
         HEAD                                                                       ;
                  ""                                                                ,;
                  "Campo"                                                           ,;
                  "Fila"                                                            ,;
                  "Col."                                                            ,;
                  "Alineación"                                                      ,;
                  "Mascara"                                                         ,;
                  "Fuente"                                                          ,;
                  "Tamaño"                                                          ,;
                  "Estilo"                                                          ;
         FIELDSIZES                                                                 ;
                  15                                                                ,;
                  180                                                               ,;
                  35                                                                ,;
                  35                                                                ,;
                  80                                                                ,;
                  80                                                                ,;
                  80                                                                ,;
                  45                                                                ,;
                  20                                                                ;
         ID       150                                                               ;
			OF 		oFld:aDialogs[2]

         ::oDbfItm:oDbfVir:SetBrowse( oBrwItm )

         oBrwItm:aJustify    := { .f., .f., .t., .t., .f., .f., .f., .t., .f. }

      //::oDbfDet[ 1 ]:CreateBrowse( 150, oFld:aDialogs[ 2 ] )

      REDEFINE BUTTON ;
         ID       506 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( Preview( aTmp, oDlg ) )

      REDEFINE BUTTON ;
         ID       511 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oDbf:cTipo := SubStr( cTipDoc, 1, 2 ), oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID       510 ;
         OF       oDlg ;
         ACTION   ( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTERED

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

METHOD AddDetail() CLASS TRItems

   ::oDbfDet   := {}

   ::oDbfItm   := TDetItems():New( Self )

   aAdd( ::oDbfDet, ::oDbfItm )

RETURN ( Self )

//---------------------------------------------------------------------------//

STATIC FUNCTION ActTitle( nKey, nFlags, oGet, nMode, oDlg )

	oGet:assign()
	oDlg:cTitle( "Documento : " + rtrim( oGet:varGet() ) + Chr( nKey ) )

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION lImpDoc( aTmp, cDes, oBrw, nMode )

RETURN NIL

//--------------------------------------------------------------------------//

STATIC FUNCTION Preview()

RETURN NIL

//---------------------------------------------------------------------------//