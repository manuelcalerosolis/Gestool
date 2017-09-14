#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TOperacion FROM TMant

   DATA      cMru       INIT "gc_worker2_hammer_16"
   DATA      cBitmap    INIT clrTopProduccion
   DATA      oTipOpera

   CLASSDATA aStrColor  INIT { "Negro", "Rojo oscuro", "Verde oscuro", "Oliva", "Azul marino", "Púrpura", "Verde azulado", "Gris",  "Plateado", "Rojo", "Verde", "Amarillo", "Azul", "Fucsia", "Aguamarina", "Blanco" }
   CLASSDATA aResColor  INIT { "COL_00", "COL_01", "COL_02", "COL_03", "COL_04", "COL_05", "COL_06", "COL_07", "COL_08", "COL_09", "COL_10", "COL_11", "COL_12", "COL_13", "COL_14", "COL_15" }
   CLASSDATA aRgbColor  INIT { Rgb( 0, 0, 0 ), Rgb( 128, 0, 0 ), Rgb( 0, 128, 0 ), Rgb( 128, 128, 128 ), Rgb( 0, 0, 128 ), Rgb( 128, 0, 128 ), Rgb( 0, 128, 128 ), Rgb( 128, 128, 128 ), Rgb( 192, 192, 192 ), Rgb( 255, 0, 0 ), Rgb( 0, 255, 0 ), Rgb( 255, 255, 0 ), Rgb( 0, 0, 255 ), Rgb( 255, 0, 255 ), Rgb( 0, 255, 255 ), Rgb( 255, 255, 255 ) }

   METHOD New( cPath, oWndParent, oMenuItem )

   METHOD CreateInit( cPath )

   METHOD OpenFiles( lExclusive )

   METHOD CloseFiles()

   METHOD DefineFiles()

   METHOD Resource( nMode )

   METHOD lPreSave( oTxtColor, nMode )

   METHOD cStrColor()

   METHOD cStrTipo()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( cPath, cDriver, oWndParent, oMenuItem )

   DEFAULT cPath        := cPatEmp()
   DEFAULT cDriver      := cDriver()
   DEFAULT oWndParent   := GetWndFrame()

   if oMenuItem != nil .and. ::nLevel == nil
      ::nLevel          := nLevelUsr( oMenuItem )
   end if

   ::cPath              := cPath
   ::cDriver            := cDriver
   ::oWndParent         := oWndParent
   ::oDbf               := nil

   ::lAutoButtons       := .t.
   ::lCreateShell       := .f.

   ::cPicUnd            := MasUnd()

   ::oTipOpera          := TTipOpera():Create()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CreateInit( cPath, cDriver )

   DEFAULT cPath        := cPatEmp()
   DEFAULT cDriver      := cDriver()

   ::cPath              := cPath
   ::cDriver            := cDriver

   ::oTipOpera          := TTipOpera():Create( cPath )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive )

   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT  lExclusive  := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

      if ::oTipOpera != nil
         ::oTipOpera:OpenFiles()
      end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError )  )

      ::CloseFiles()

      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD CloseFiles()

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
      ::oDbf      := nil
   end if

   if ::oTipOpera != nil
      ::oTipOpera:End()
   end if

   ::oTipOpera    := nil

RETURN .t.

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE TABLE ::oDbf FILE "Operacio.Dbf" CLASS "Operacion" ALIAS "Operacion" PATH ( cPath ) VIA ( cDriver ) COMMENT "Operaciones"

      FIELD NAME "cCodOpe"    TYPE "C" LEN  3  DEC 0 COMMENT "Código"      COLSIZE 100                      OF ::oDbf
      FIELD NAME "cDesOpe"    TYPE "C" LEN 35  DEC 0 COMMENT "Nombre"      COLSIZE 400                      OF ::oDbf
      FIELD NAME "cTipOpe"    TYPE "C" LEN  3  DEC 0 COMMENT "Tipo"                    HIDE                 OF ::oDbf
      FIELD CALCULATE NAME "TipoOpe"   LEN  20 DEC 0 COMMENT "Tipo"        COLSIZE 100 VAL ::cStrTipo       OF ::oDbf
      FIELD NAME "nColor"     TYPE "N" LEN 10  DEC 0 COMMENT "Color de la operación"   HIDE                 OF ::oDbf
      FIELD CALCULATE NAME "cColor"    LEN 20  DEC 0 COMMENT "Color"       COLSIZE 120 VAL ::cStrColor()    OF ::oDbf

      INDEX TO "Operacio.Cdx" TAG "cCodOpe" ON "cCodOpe" COMMENT "Código" NODELETED OF ::oDbf
      INDEX TO "Operacio.Cdx" TAG "cDesOpe" ON "cDesOpe" COMMENT "Nombre" NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

	local oDlg
   local oGet
   local oGetTip
   local oTxtColor
   local cTxtColor
   local nSeaColor

   if nMode == APPD_MODE
      nSeaColor   := aScan( ::aRgbColor, Rgb( 255, 255, 255 ) )
   else
      nSeaColor   := aScan( ::aRgbColor, ::oDbf:nColor )
   end if

   if nSeaColor != 0
      cTxtColor         := ::aStrColor[ nSeaColor ]
   end if

   DEFINE DIALOG oDlg RESOURCE "Operacion" TITLE LblTitle( nMode ) + "operaciones"

      REDEFINE GET oGet VAR ::oDbf:cCodOpe;
         ID       110 ;
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    ( NotValid( oGet, ::oDbf:cAlias, .t., "0" ) );
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cDesOpe;
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET oGetTip VAR ::oDbf:cTipOpe ;
         ID       130 ;
         IDTEXT   131 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         OF       oDlg

         oGetTip:bHelp     := {|| ::oTipOpera:Buscar( oGetTip ) }
         oGetTip:bValid    := {|| ::oTipOpera:Existe( oGetTip, oGetTip:oHelpText, "cDesTip", .t., .t., "0" ) }

      REDEFINE COMBOBOX oTxtColor VAR cTxtColor;
         ID       140;
         ITEMS    ::aStrColor;
         BITMAPS  ::aResColor;
         WHEN     ( nMode != ZOOM_MODE );
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( if( ::lPreSave( oTxtColor, nMode ), oDlg:end( IDOK ), ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

      REDEFINE BUTTON ;
         ID       559 ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( MsgInfo( "Ayuda no definida" ) )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| if( ::lPreSave( oTxtColor, nMode ), oDlg:end( IDOK ), ) } )
   end if

   oDlg:bStart := { || oGet:SetFocus(), oGetTip:lValid() }

	ACTIVATE DIALOG oDlg	CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD lPreSave( oTxtColor, nMode )

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if ::oDbf:SeekInOrd( ::oDbf:cCodOpe, "CCODOPE" )
         MsgStop( "Código ya existe " + Rtrim( ::oDbf:cCodOpe ) )
         return .f.
      end if

   end if

   if Empty( ::oDbf:cDesOpe )
      MsgStop( "La descripción de la operación no puede estar vacía." )
      Return .f.
   end if

   ::oDbf:nColor := ::aRgbColor[ oTxtColor:nAt ]

RETURN .t.

//--------------------------------------------------------------------------//

METHOD cStrColor()

   local nPos
   local cStrColor   := ""

   if Empty( ::aStrColor )
      Return ( cStrColor )
   end if

   if Empty( ::aRgbColor )
      Return ( cStrColor )
   end if

   if Empty( ::oDbf )
      Return ( cStrColor )
   end if

   nPos  := aScan( ::aRgbColor, ::oDbf:nColor )
   if nPos != 0
      cStrColor   := ::aStrColor[ nPos ]
   end if

Return ( cStrColor )

//---------------------------------------------------------------------------//

METHOD cStrTipo()

Return ( ::oDbf:cTipOpe + " - " + oRetFld( ::oDbf:cTipOpe, ::oTipOpera:oDbf ) )

//---------------------------------------------------------------------------//