// Quick Browse sample

//----------------------------------------------------------------------------//
// Para HDO

#include "hdo.ch"

#define SEL_TABLE	"SELECT * FROM clientes ORDER BY nombre;"
#define DEL_TABLE	"DELETE FROM clientes WHERE idReg = ?;"
#define UPD_TABLE	"UPDATE clientes SET Nombre = ?, Direccion = ?, Telefono = ?, Edad = ?, Productos = ?, Nivel = ? WHERE idReg = ?;"
#define INS_TABLE	"INSERT INTO clientes ( Nombre, Direccion, Telefono, Edad, Productos, Nivel ) VALUES ( ?, ?, ?, ?, ?, ? );"

static oDb, oSel, oUpd, oIns, oDel, oRS

//----------------------------------------------------------------------------//
// Para FieveWin

#include "FiveWin.ch"

static oWnd

//----------------------------------------------------------------------------//

PROCEDURE RddInit()

   ANNOUNCE RDDSYS

   REQUEST DBFCDX
   REQUEST DBFFPT

   REQUEST RDLMYSQL 

   REQUEST OrdKeyCount
   REQUEST OrdKeyNo
   REQUEST OrdKeyGoto

RETURN

//---------------------------------------------------------------------------//

function Main()

   local oBrush, oBar

   SET _3DLOOK ON                         // Microsoft 3D Look

   SkinButtons()

   DEFINE BRUSH oBrush STYLE TILED       // FiveWin new predefined Brushes

   DEFINE WINDOW oWnd FROM 4, 4 TO 50, 150 ;
      TITLE "HDO y FWH - Browsing power" ;
      MENU BuildMenu() ;
      BRUSH oBrush

   DEFINE BUTTONBAR oBar OF oWnd

   DEFINE BUTTON FILENAME "..\bitmaps\Exit.bmp" OF oBar ;
      ACTION If( MsgYesNo( "Do you want to End ?", "Please, Select" ), oWnd:End(), ) ;
      MESSAGE "End this session"

   DEFINE BUTTON FILENAME "..\bitmaps\Edit.bmp" OF oBar GROUP ;
      MESSAGE "Using a Browse with dynamic Bitmap selection" ACTION Clients() ;
      TOOLTIP "Edit"

   DEFINE BUTTON FILENAME "..\bitmaps\Ques2.bmp" OF oBar ;
      MESSAGE "FiveWin info" ACTION MsgAbout()

   SET MESSAGE OF oWnd TO "HDO for SQLite by Manu Exposito Version 1.00" CLOCK DATE

   ACTIVATE WINDOW oWnd CENTERED

return nil

//----------------------------------------------------------------------------//

static function BuildMenu()

   local oMenu

   MENU oMenu

      MENUITEM "&Information"
      MENU
         MENUITEM "&About..." + Chr( 9 ) + "Alt+A" ;
            ACTION MsgAbout( "HDO for SQLite by Manu Exposito", "V.1.00" ) ;
            MESSAGE "Some information about this demo" ;
            ACCELERATOR ACC_ALT, Asc( "A" ) ;
            FILENAME "..\bitmaps\16x16\info.bmp"
         SEPARATOR
         MENUITEM "&Exit demo..." ACTION ;
            If( MsgYesNo( "Do you want to end ?", "Please, Select" ), oWnd:End,) ;
            MESSAGE "End the execution of this demo"
      ENDMENU

      MENUITEM "&Clients Control" ACTION Clients()

      MENUITEM "&Utilities"
      MENU
         MENUITEM "&Calculator..." ACTION WinExec( "Calc" ) ;
            MESSAGE "Calling Windows Calculator"

         MENUITEM "C&alendar..."  ACTION WinExec( "Calendar" ) ;
            MESSAGE "Calling Windows Calendar"

         SEPARATOR

         MENUITEM "&Writing..."    ACTION WinExec( "Write" ) ;
            MESSAGE "Calling Windows Write"
      ENDMENU

   ENDMENU

return oMenu

//----------------------------------------------------------------------------//

static function Clients()

   local oDlg
   local oLbx
   local cVar

   local aHBitMaps:= { ReadBitmap( 0, "..\bitmaps\Level1.bmp" ), ; // BitMaps de 14 x 32
                       ReadBitmap( 0, "..\bitmaps\Level2.bmp" ), ;
                       ReadBitmap( 0, "..\bitmaps\Level3.bmp" ), ;
                       ReadBitmap( 0, "..\bitmaps\Level4.bmp" ),;
                       ReadBitmap( 0, "..\bitmaps\Level5.bmp" ) }
   local n

	openDataBase()

   DEFINE DIALOG oDlg FROM 3, 3 TO 26, 79 TITLE "Clients Management"

   @ 0,  1 SAY " &Clients List"  OF oDlg

   @ 1, 1 LISTBOX oLbx FIELDS aHBitmaps[ Max( 1, oRS:fieldGet( "Nivel" ) ) ],;
                              oRS:fieldGet( "Nombre" ), rtrim( oRS:fieldGet( "Direccion" ) ),;
                              oRS:fieldGet( "Telefono" ),;
                              Str( oRS:fieldGet( "Edad" ), 3 ) ;
          HEADERS    "L", "Name", "Address", "Phone", "Age" ;
          FIELDSIZES 16, 222, 213, 58, 24 ;
          SIZE 284, 137 OF oDlg

   // Lets use different row colors
   oLbx:nClrText      = { || SelColor( oRS:getValueByName( "Nivel" ) ) }
   oLbx:nClrForeFocus = { || SelColor( oRS:getValueByName( "Nivel" ) ) }
   oLbx:bRClicked     = { | nRow, nCol | ShowPopup( nRow, nCol, oLbx ) }
   // Try different line styles !!!
   oLbx:nLineStyle = 1

   oLbx:aJustify = { .f., .f., .t., .f., .t. }

   @ 8.7,  1.4 BUTTON "&New"    OF oDlg ACTION EditClient( oLbx, .t. ) ;
                                            SIZE 40, 12
   @ 8.7,  9.4 BUTTON "&Modify" OF oDlg ACTION EditClient( oLbx, .f. ) ;
                                              SIZE 40, 12
   @ 8.7, 17.4 BUTTON "&Delete" OF oDlg ACTION DelClient( oLbx )  SIZE 40, 12
   @ 8.7, 25.4 BUTTON "&Search" OF oDlg ACTION SeekClient( oLbx ) SIZE 40, 12

   @ 8.7, 33.4 BUTTON "&Print"  OF oDlg ;
      ACTION oLbx:Report( "clients Report", .t. ) ;  // .t. --> wants preview
      SIZE 40, 12

   @ 8.7, 42 BUTTON "&Exit"   OF oDlg ACTION oDlg:End()         SIZE 40, 12

   MySetBrowse( oLbx, oRS )

   ACTIVATE DIALOG oDlg CENTERED

   closeDataBase()

   AEval( aHBitmaps, { | hBmp | DeleteObject( hBmp ) } )

return nil

//----------------------------------------------------------------------------//

static function ShowPopup( nRow, nCol, oLbx )

   local oPopup

   MENU oPopup POPUP
      MENUITEM "&New"      ACTION EditClient( oLbx, .t. )
      MENUITEM "&Modify"   ACTION EditClient( oLbx, .f. )
      MENUITEM "&Delete"   ACTION DelClient( oLbx )
      MENUITEM "&Search"   ACTION SeekClient( oLbx )
      MENUITEM "&Print"    ACTION oLbx:Report( "clients Report", .t. )
      SEPARATOR
      MENUITEM "&Browse lines style"
      MENU
         MENUITEM "None    (0)" ACTION oLbx:nLineStyle := 0, oLbx:Refresh()
         MENUITEM "Black   (1)" ACTION oLbx:nLineStyle := 1, oLbx:Refresh()
         MENUITEM "Gray    (2)" ACTION oLbx:nLineStyle := 2, oLbx:Refresh()
         MENUITEM "3D      (3)" ACTION oLbx:nLineStyle := 3, oLbx:Refresh()
         MENUITEM "DOTED   (4)" ACTION oLbx:nLineStyle := 4, oLbx:Refresh()
         MENUITEM "V_BLACK (5)" ACTION oLbx:nLineStyle := 5, oLbx:Refresh()
         MENUITEM "V_GRAY  (6)" ACTION oLbx:nLineStyle := 6, oLbx:Refresh()
         MENUITEM "H_BLACK (7)" ACTION oLbx:nLineStyle := 7, oLbx:Refresh()
         MENUITEM "H_GRAY  (8)" ACTION oLbx:nLineStyle := 8, oLbx:Refresh()
      ENDMENU
      SEPARATOR
      MENUITEM "&Exit"     ACTION oLbx:oWnd:End()
   ENDMENU

   ACTIVATE POPUP oPopup AT nRow, nCol OF oLbx

return nil

//----------------------------------------------------------------------------//

static function SelColor( nNivel )

   local nColor := CLR_BLACK

   do case
      case nNivel == 1
           nColor = CLR_HRED

      case nNivel == 2
           nColor = CLR_HGREEN

      case nNivel == 3
           nColor = CLR_HBLUE
   endcase

return nColor

//----------------------------------------------------------------------------//

static function EditClient( oLbx, lAppend )

   local nIdReg, nNivel, cName, cAddress, cPhone, cProductos, nAge
   local oDlg, oStmt
   local lFivePro, lDialog, lObjects
   local lSave := .f.
   local nOldRec := RecNo()

   DEFAULT lAppend := .f.

	if lAppend
		oRS:goTo( 0 ) // Va al registro fantasma, HDO le da soporte ;-)
	else
   		nIdReg := oRS:fieldGet( "idReg" )
	endif

   lFivePro = "F" $ oRS:fieldGet( "Productos" )
   lDialog  = "D" $ oRS:fieldGet( "Productos" )
   lObjects = "O" $ oRS:fieldGet( "Productos" )
   nNivel   = max( 1, oRS:fieldGet( "Nivel" ) )
   cName    = oRS:fieldGet( "Nombre" )
   cAddress = oRS:fieldGet( "Direccion" )
   cPhone   = oRS:fieldGet( "Telefono" )
   nAge     = oRS:fieldGet( "Edad" )

   DEFINE DIALOG oDlg FROM 8, 2 TO 25, 65 ;
      TITLE If( lAppend, "New Customer", "Customer Update" )

   @ 1,  1 SAY "&Name:" OF oDlg
   @ 1,  6 GET cName OF oDlg
   @ 2,  1 SAY "&Address:" OF oDlg
   @ 2,  6 GET cAddress OF oDlg

   @ 3,  1 GROUP TO 7, 8 LABEL "&Products" OF oDlg
   @ 4,  2 CHECKBOX lFivePro PROMPT "&FivePro" OF oDlg
   @ 5,  2 CHECKBOX lDialog  PROMPT "&Dialog"  OF oDlg
   @ 6,  2 CHECKBOX lObjects PROMPT "&Objects" OF oDlg

   @ 3,  9 GROUP TO 7, 17 LABEL "&Nivel" OF oDlg
   @ 4,  9 RADIO nNivel PROMPT "&Novice", "A&vanced", "&Expert" OF oDlg

   @ 3.5, 23 SAY "&Phone:" OF oDlg
   @ 4, 21 GET cPhone OF oDlg SIZE 60, 11 PICTURE "@R 99-999-9999999"

   @ 5, 23 SAY "&Age:" OF oDlg
   @ 6, 21 GET nAge OF oDlg SIZE 20, 11

   @ 6,  9 BUTTON "&Acept"  OF oDlg SIZE 50, 12 ACTION ( lSave := .t. , oDlg:End() )
   @ 6, 19 BUTTON "&Cancel" OF oDlg SIZE 50, 12 ACTION oDlg:End()

   ACTIVATE DIALOG oDlg CENTERED

   	if lSave .and. !empty( cName )
		cProductos := If( lFivePro, "F", "" ) + If( lDialog,  "D", "" ) + If( lObjects, "O", "" )
      	
      	if lAppend
        	oStmt := oIns
      	else
        	oStmt := oUpd
        	oStmt:bindValue( 7, nIdReg ) // Este es solo para las actualizaciones
      	endif
      	
        oStmt:bindValue( 1, cName )
      	oStmt:bindValue( 2, cAddress )
      	oStmt:bindValue( 3, cPhone )
      	oStmt:bindValue( 4, nAge )
      	oStmt:bindValue( 5, cProductos )
      	oStmt:bindValue( 6, nNivel )
        oStmt:execute()
		
      	refresh( oLbx )
      	oLbx:Refresh()          // We want the ListBox to be repainted
   	else
      	if Empty( cName ) .and. lSave
         	MsgAlert( "Please write a name" )
      	endif
      	oRS:goTo( nOldRec )
   	endif

return nil

//---------------------------------------------------------------------------//

static function DelClient( oLbx )

   if MsgYesNo( "Are you sure to delete this record? -> " + alltrim( oRS:fieldGet( "nombre" ) ) )
		oDel:bindValue(  1, oRS:fieldGet( "idReg" ) )
        oDel:execute()
        refresh( oLbx )
      	oLbx:Refresh()  // Repaint the ListBox
   endif

return nil

//----------------------------------------------------------------------------//

static function SeekClient( oLbx )

	local cNombre := Space( 30 )
   	local nRecNo  := oRS:RecNo()
   	local nRec

   	if MsgGet( "Search", "Customer Name", @cNombre, "..\bitmaps\lupa.bmp" )
    	nRec := oRS:find( cNombre, 2, .t. )
      	if nRec == 0
         	MsgAlert( "I don't find that customer" )
         	oRS:goTo( nRecNo )
      	else
			oRS:goTo( nRec )
         	UpStable( oLbx )          // Corrects same page stabilizing Bug
         	oLbx:Refresh()            // Repaint the ListBox
            MsgAlert( "I find that customer in position: " + ltrim( str( nRec ) ) )
      	endif
	endif

return nil

//----------------------------------------------------------------------------//

static procedure refresh( oLbx )

   	//oRS:free()
    //oRS := oSel:fetchRowSet()
    //MySetBrowse( oLbx, oRS )
	oRS:refresh()

return

//---------------------------------------------------------------------------//

static procedure openDataBase()

    oDb := THDO():new( "mysql" )

    oDb:setAttribute( ATTR_ERRMODE, .t. )

    if oDb:connect( "HDOdemo", "127.0.0.1", "root", ""  )

    	oSel := oDb:prepare( SEL_TABLE ) // Crea el objeto consultar
    	oIns := oDb:prepare( INS_TABLE ) // Crea el objeto para insertar
    	oUpd := oDb:prepare( UPD_TABLE ) // Crea el objeto para actualizar
    	oDel := oDb:prepare( DEL_TABLE ) // Crea el objeto para borrar

    	oRS := oSel:fetchRowSet()

    else 

        msgstop( "No conectado" )

    endif

return

//---------------------------------------------------------------------------//

static procedure closeDataBase()
	
    oSel:free()
    oIns:free()
    oUpd:free()
    oDel:free()
	oRS:free()

    oDb:disconnect()

return

//----------------------------------------------------------------------------//
// Asigna los codeblock de movimiento a un Browse

static function MySetBrowse( oBrw, oDataSource )

    local lRet := .t.
    local bGoTop, bGoBottom, bSkipper
    local cClsName

    if ValType( oBrw ) != "O" .or. ValType( oDataSource ) != "O"
        lRet := .f.
    else
        bGoTop := { || oDataSource:GoTop() }
        bGoBottom := { || oDataSource:GoBottom() }
        bSkipper := { | n | oDataSource:Skipper( n ) }

        cClsName := upper( oBrw:ClassName() )

        if cClsName $ "TWBROWSE TCBROWSE TSBROWSE TGRID TXBROWSE" // Browses de FWH
            oBrw:cAlias := "ARRAY"
            oBrw:bGoTop := bGoTop
            oBrw:bGoBottom := bGoBottom
            oBrw:bSkip := bSkipper
            if cClsName == "TXBROWSE"
                oBrw:bBof := { || oDataSource:Bof() }
                oBrw:bEof := { || oDataSource:Eof() }
                oBrw:bBookMark :={ | n | if( n == nil, oDataSource:RecNo(), ;
                                                       oDataSource:GoTo( n ) ) }
                oBrw:bKeyNo :=  { || oDataSource:RecNo() }
                oBrw:bKeyCount := { || oDataSource:RecCount() }
            else
                oBrw:bLogicLen := { || oDataSource:RecCount() }
            endif
            if oBrw:oVScroll() != nil
                oBrw:oVscroll():SetRange( 1, oDataSource:RecCount() )
            endif
            //oBrw:Refresh()
        else
            msgInfo( "Browse no implementado en SetBrowse" )
        endif
    endif

return( lRet )

//----------------------------------------------------------------------------//

static procedure UpStable( oBrw )

   local nRow   := oBrw:nRowPos
   local nRecNo := oRS:RecNo()
   local nRows  := oBrw:nRowCount()
   local n      := 1
   local lSkip  := .t.

   oBrw:nRowPos    = 1
   oBrw:GoTop()
   oBrw:lHitTop    = .f.
   oBrw:lHitBottom = .f.

   while !oRS:EoF()
      if n > nRows
         oRS:goTo( nRecNo )
         oBrw:nRowPos = nRow
         lSkip     = .f.
         exit
      endif
      if nRecNo == oRS:recNo()
         oBrw:nRowPos = n
         exit
      else
         oRS:skip()
      endif
      n++
   end

   if lSkip
      oRS:Skip( -oBrw:nRowPos )
   endif

   if oBrw:bChange != nil
      Eval( oBrw:bChange, oBrw )
   endif

return nil

//----------------------------------------------------------------------------//

