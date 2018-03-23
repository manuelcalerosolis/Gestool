#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

#define  DEFAULT_CODE   "000"

//----------------------------------------------------------------------------//

CLASS TCaptura FROM TMasDet

   DATA oCapCampos

   DATA oVisible
   DATA oCaptura
   DATA oTitulo
   DATA oAncho
   DATA oChkBitmap

   DATA cMru            INIT "gc_window_pencil_16"
   DATA cBitmap         INIT "WebTopGreen"

   Method New( cPath, oWndParent, oMenuItem )

   Method OpenFiles( lExclusive )
   METHOD OpenService( lExclusive )

   Method CloseFiles()
   METHOD CloseService()

   METHOD Reindexa()

   METHOD Activate()

   Method lExistCaptura( cCodCaptura )    INLINE ( ::oCapCampos:oDbf:Seek( cCodCaptura ) )

   Method DefineFiles()

   Method Resource( nMode )

   Method lPreSave( nMode )

   Method RefreshGet( nMode )

   Method CreateFields( cCodCaptura )
   Method CreateTitles( cCodCaptura )
   Method CreateSizes( cCodCaptura )
   Method CreateJustify( cCodCaptura )

   Method CreateColumns( cCodCaptura, oBrw )

END CLASS

//----------------------------------------------------------------------------//

Method New( cPath, oWndParent, oMenuItem )

   DEFAULT cPath           := cPatDat()
   DEFAULT oWndParent      := GetWndFrame()
   DEFAULT oMenuItem       := "01083"

   ::nLevel                := Auth():Level( oMenuItem )

   ::cPath                 := cPath
   ::oWndParent            := oWndParent
   ::lReport               := .f.

   ::bFirstKey             := {|| ::oDbf:cCodigo }

   ::oCapCampos            := TDetCaptura():New( cPath, , Self )
   ::AddDetail( ::oCapCampos )

   //::bOnPreAppend        := {|| ::oCapCampos:CheckDefault( Space( 3 ), .t. ) }
   ::oCapCampos:bDefaultValues        := {|| ::oCapCampos:CheckDefaultVir() }
   ::bOnPreEdit            := {|| if( ::oDbf:cCodigo == DEFAULT_CODE, ( msgStop( "No se puede modificar la captura por defecto" ),.f. ), .t. ) }

RETURN ( Self )

//----------------------------------------------------------------------------//

Method OpenFiles( lExclusive )

   DEFAULT  lExclusive  := .f.

   if Empty( ::oDbf )
      ::DefineFiles()
   end if

   ::oDbf:Activate( .f., !( lExclusive ) )

   if !::oDbf:Seek( DEFAULT_CODE )
      ::oDbf:Append()
      ::oDbf:cCodigo       := DEFAULT_CODE
      ::oDbf:cNombre       := "Captura por defecto"
      ::oDbf:Save()
   end if

   ::OpenDetails()

RETURN ( .t. )

//----------------------------------------------------------------------------//

Method CloseFiles()

   if !Empty( ::oDbf ) .and. ::oDbf:Used()
      ::oDbf:end()
      ::oDbf      := nil
   end if

   ::CloseDetails()

   ::oCapCampos:End()

RETURN .t.

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE TABLE ::oDbf FILE "Captura.Dbf" CLASS "Captura" ALIAS "Captura" PATH ( cPath ) VIA ( cDriver ) COMMENT "Captura de TPV"

      FIELD NAME "cCodigo"    TYPE "C" LEN  3  DEC 0 COMMENT "Código"   COLSIZE 100    OF ::oDbf
      FIELD NAME "cNombre"    TYPE "C" LEN 35  DEC 0 COMMENT "Nombre"   COLSIZE 400    OF ::oDbf

      INDEX TO "Captura.Cdx"  TAG "cCodigo" ON "cCodigo" COMMENT "Código" NODELETED    OF ::oDbf
      INDEX TO "Captura.Cdx"  TAG "cNombre" ON "cNombre" COMMENT "Nombre" NODELETED    OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

Method Resource( nMode )

	local oDlg
   local oBrwCampos
   local oGetCodigo

   DEFINE DIALOG oDlg RESOURCE "Captura" TITLE LblTitle( nMode ) + "capturas de T.P.V."

      REDEFINE GET oGetCodigo VAR ::oDbf:cCodigo;
         ID       100 ;
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    NotValid( oGetCodigo, ::oDbf:cAlias ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cNombre;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE LISTBOX oBrwCampos ;
         FIELDS   ::oCapCampos:oDbfVir:cNombre;
         TITLE    "";
         SIZES    120;
         ID       120 ;
         OF       oDlg

         oBrwCampos:bGoTop       := {|| ::oCapCampos:oDbfVir:GoTop() }
         oBrwCampos:bGoBottom    := {|| ::oCapCampos:oDbfVir:GoBottom() }
         oBrwCampos:bSkip        := {|n|::oCapCampos:oDbfVir:Skipper( n ) }
         oBrwCampos:bLogicLen    := {|| ::oCapCampos:oDbfVir:LastRec() }
         oBrwCampos:bChange      := {|| ::RefreshGet( nMode ) }
         oBrwCampos:lDrawHeaders := .f.

      REDEFINE BUTTON ;
         ID       130 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oCapCampos:oDbfVir:SwapUp(), oBrwCampos:GoUp() )

      REDEFINE BUTTON ;
         ID       140 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oCapCampos:oDbfVir:SwapDown(), oBrwCampos:GoDown() )

      REDEFINE CHECKBOX ::oVisible VAR ::oCapCampos:oDbfVir:lVisible ;
         ID       150 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE RADIO ::oCaptura VAR ::oCapCampos:oDbfVir:nCaptura ;
         ID       160, 161, 162;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oTitulo VAR ::oCapCampos:oDbfVir:cTitulo ;
         ID       170 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oAncho VAR ::oCapCampos:oDbfVir:nAncho ;
         ID       180 ;
         SPINNER ;
         PICTURE  "999" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE CHECKBOX ::oChkBitmap VAR ::oCapCampos:oDbfVir:lBitmap ;
         ID       190 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( if( ::lPreSave( nMode ), oDlg:end( IDOK ), ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F5, {|| if( ::lPreSave( nMode ), oDlg:end( IDOK ), ) } )
      end if

      oDlg:bStart := {|| ::RefreshGet( nMode ), oGetCodigo:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Method lPreSave( nMode )

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if Empty( ::oDbf:cCodigo )
         MsgStop( "El código no puede estar vacío." )
         Return .f.
      end if

      if ::oDbf:SeekInOrd( ::oDbf:cCodigo, "cCodigo" )
         MsgStop( "Código ya existe " + Rtrim( ::oDbf:cCodigo ) )
         return .f.
      end if

   end if

   if Empty( ::oDbf:cNombre )
      MsgStop( "El nombre no puede estar vacío." )
      Return .f.
   end if

Return .t.

//---------------------------------------------------------------------------//

Method RefreshGet( nMode )

   if !Empty( ::oVisible )

      if nMode != ZOOM_MODE

         if ::oCapCampos:oDbfVir:lEditable
            ::oVisible:bWhen  := {|| .t. }
            ::oVisible:Enable()
         else
            ::oVisible:bWhen  := {|| .f. }
            ::oVisible:Disable()
         end if

      end if

      ::oVisible:Refresh()

   end if

   if !Empty( ::oCaptura )
      ::oCaptura:Refresh()
   end if

   if !Empty( ::oTitulo )
      ::oTitulo:Refresh()
   end if

   if !Empty( ::oAncho )
      ::oAncho:Refresh()
   end if

   if !Empty( ::oChkBitmap )
      ::oChkBitmap:Refresh()
   end if

Return ( .t. )

//---------------------------------------------------------------------------//

Method CreateFields( cCodCaptura )

   local aFld           := {}

   DEFAULT cCodCaptura  := DEFAULT_CODE

   if ::oCapCampos:oDbf:Seek( cCodCaptura )

      while ::oCapCampos:oDbf:cCodigo == cCodCaptura .and. !::oCapCampos:oDbf:eof()

         if ::oCapCampos:oDbf:lVisible
            aAdd( aFld, Eval( NameToField( ::oCapCampos:oDbf:cNombre ) ) )
         end if

         ::oCapCampos:oDbf:Skip()

      end while

      aAdd( aFld, "" )

   end if

return ( aFld )

//---------------------------------------------------------------------------//

Method CreateTitles( cCodCaptura )

   local aTitles        := {}

   DEFAULT cCodCaptura  := DEFAULT_CODE

   if ::oCapCampos:oDbf:Seek( cCodCaptura )

      while ::oCapCampos:oDbf:cCodigo == cCodCaptura .and. !::oCapCampos:oDbf:eof()

         if ::oCapCampos:oDbf:lVisible
            aAdd( aTitles, Rtrim( ::oCapCampos:oDbf:cTitulo ) )
         end if

         ::oCapCampos:oDbf:Skip()

      end while

      aAdd( aTitles, "" )

   end if

return aTitles

//---------------------------------------------------------------------------//

Method CreateSizes( cCodCaptura )

   local aSizes         := {}

   DEFAULT cCodCaptura  := DEFAULT_CODE

   if ::oCapCampos:oDbf:Seek( cCodCaptura )

      while ::oCapCampos:oDbf:cCodigo == cCodCaptura .and. !::oCapCampos:oDbf:eof()

         if ::oCapCampos:oDbf:lVisible
            aAdd( aSizes, ::oCapCampos:oDbf:nAncho )
         end if

         ::oCapCampos:oDbf:Skip()

      end while

      aAdd( aSizes, 200 )

   end if

return aSizes

//---------------------------------------------------------------------------//

Method CreateJustify( cCodCaptura )

   local aSizes         := {}

   DEFAULT cCodCaptura  := DEFAULT_CODE

   if ::oCapCampos:oDbf:Seek( cCodCaptura )

      while ::oCapCampos:oDbf:cCodigo == cCodCaptura .and. !::oCapCampos:oDbf:eof()

         if ::oCapCampos:oDbf:lVisible
            aAdd( aSizes, ::oCapCampos:oDbf:lAlign )
         end if

         ::oCapCampos:oDbf:Skip()

      end while

      aAdd( aSizes, 200 )

   end if

return aSizes

//---------------------------------------------------------------------------//

Method CreateColumns( cCodCaptura, oBrw )

   DEFAULT cCodCaptura  := DEFAULT_CODE

   if ::oCapCampos:oDbf:Seek( cCodCaptura )

      while ::oCapCampos:oDbf:cCodigo == cCodCaptura .and. !::oCapCampos:oDbf:eof()

         if ::oCapCampos:oDbf:lVisible

            with object ( oBrw:AddCol() )

               :cHeader             := Rtrim( ::oCapCampos:oDbf:cTitulo )
               :nWidth              := ::oCapCampos:oDbf:nAncho
               :bEditValue          := NameToField( ::oCapCampos:oDbf:cNombre )

               if ( ::oCapCampos:oDbf:lBitmap )
                  :SetCheck( { "gc_star2_blue_16", "Nil16" } )
               end if

               if ( ::oCapCampos:oDbf:lAlign )
                  :nDataStrAlign    := 1
                  :nHeadStrAlign    := 1
               end if

               :Cargo               := { Rtrim( ::oCapCampos:oDbf:cNombre ), ::oCapCampos:oDbf:nCaptura }

            end with

         end if

         ::oCapCampos:oDbf:Skip()

      end while

   end if

return ( Self )

//---------------------------------------------------------------------------//

METHOD OpenService( lExclusive, cPath )

   local lOpen          := .t.
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lExclusive   := .f.

   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER

      lOpen             := .f.

      ::CloseService()

      msgStop( "Imposible abrir todas las bases de datos de capturas" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseService()

   if !Empty( ::oDbf )
      ::oDbf:End()
   end if

   ::oDbf   := nil

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD Reindexa()

   /*
   Definicion del master-------------------------------------------------------
   */

   if Empty( ::oDbf )
      ::oDbf   := ::DefineFiles()
   end if

   ::oDbf:IdxFDel()

   if ::OpenService( .t. )
      ::oDbf:Pack()
   end if

   ::CloseService()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Activate()

   if nAnd( ::nLevel, 1 ) == 0

      /*
      Cerramos todas las ventanas
      */

      if ::oWndParent != nil
         ::oWndParent:CloseAll()
      end if

      if Empty( ::oDbf )
         if !::OpenFiles()
            return nil
         end if
      end if

      /*
      Creamos el Shell
      */

      if !::lCreateShell
         ::CreateShell( ::nLevel )
      end if

      DEFINE BTNSHELL RESOURCE "BUS" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::oWndBrw:SearchSetFocus() ) ;
         TOOLTIP  "(B)uscar" ;
         HOTKEY   "B";

         ::oWndBrw:AddSeaBar()

      DEFINE BTNSHELL RESOURCE "NEW" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::oWndBrw:RecAdd() );
         TOOLTIP  "(A)ñadir";
         BEGIN GROUP ;
         HOTKEY   "A" ;
         LEVEL    ACC_APPD

      //ACTION   ( if( ::oDbf:Seek( DEFAULT_CODE ), ::oWndBrw:RecDup(), MsgStop( "No se ha encontrado la captura por defecto" ) ) );         

      DEFINE BTNSHELL RESOURCE "DUP" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::oWndBrw:RecDup() );
         TOOLTIP  "(D)uplicar";
         HOTKEY   "D" ;
         LEVEL    ACC_APPD

      DEFINE BTNSHELL RESOURCE "EDIT" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::oWndBrw:RecEdit() );
         TOOLTIP  "(M)odificar";
         HOTKEY   "M" ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "ZOOM" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::oWndBrw:RecZoom() );
         TOOLTIP  "(Z)oom";
         HOTKEY   "Z" ;
         LEVEL    ACC_ZOOM

      DEFINE BTNSHELL RESOURCE "DEL" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::oWndBrw:RecDel() );
         TOOLTIP  "(E)liminar";
         MRU ;
         HOTKEY   "E";
         LEVEL    ACC_DELE

      ::oWndBrw:EndButtons( Self )

      if ::cHtmlHelp != nil
         ::oWndBrw:cHtmlHelp  := ::cHtmlHelp
      end if

      ::oWndBrw:Activate( nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, {|| ::CloseFiles() } )

   else

      msgStop( "Acceso no permitido." )

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//