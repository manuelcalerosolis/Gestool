#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TOrdenComanda FROM TMant

   DATA oDlg
   DATA oNomOrd
   DATA oCodOrd

   METHOD Create( cPath ) CONSTRUCTOR

   METHOD New( cPath, oWndParent, oMenuItem ) CONSTRUCTOR

   METHOD Activate()

   METHOD OpenFiles( lExclusive )
   MESSAGE OpenService( lExclusive )   METHOD OpenFiles( lExclusive )

   METHOD DefineFiles()

   METHOD Resource( nMode )

   METHOD cNombre( cCodOrd )
   METHOD cCodigoOrden( cOrdOrd )

   METHOD cOrden( cNombre )

   METHOD lPreSave( nMode )

   METHOD SubirOrden()
   METHOD BajarOrden() 

   METHOD aNombreOrdenComanda()
   METHOD EmptyOrdenComanda()          INLINE ( if( !Empty( ::oDbf ) .and. ::oDbf:Used(), !( ::oDbf:OrdKeyCount() > 0 ), .t. ) )

   METHOD Selector()
   METHOD getFirstOrderId()

END CLASS

//----------------------------------------------------------------------------//

METHOD Create( cPath )

   DEFAULT cPath        := cPatArt()

   ::cPath              := cPath
   ::oDbf               := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD New( cPath, oWndParent, oMenuItem )

   DEFAULT cPath        := cPatArt()
   DEFAULT oWndParent   := GetWndFrame()

   if oMenuItem != nil
      ::nLevel          := nLevelUsr( oMenuItem )
   else
      ::nLevel          := nLevelUsr( "01093" )
   end if

   ::cPath              := cPath
   ::oWndParent         := oWndParent

   ::oDbf               := nil

   ::cMru               := "gc_sort_az_descending_16"

   ::cBitmap            := clrTopArchivos

   ::lCreateShell       := .f.

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Activate()

   if nAnd( ::nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      Return ( Self )
   end if

   /*
   Cerramos todas las ventanas-------------------------------------------------
   */

   if ::oWndParent != nil
      ::oWndParent:CloseAll()
   end if

   if Empty( ::oDbf ) .or. !::oDbf:Used()
      ::lOpenFiles      := ::OpenFiles()
   end if

   /*
   Creamos el Shell------------------------------------------------------------
   */

   if ::lOpenFiles

      if !::lCreateShell
         ::CreateShell( ::nLevel )
      end if

      ::oWndBrw:GralButtons( Self )

      DEFINE BTNSHELL RESOURCE "Up" GROUP OF ::oWndBrw ;
         NOBORDER ;
         ACTION      ( ::SubirOrden() ) ;
         TOOLTIP     "S(u)bir";
         HOTKEY      "U" ;
         LEVEL       ACC_EDIT

      DEFINE BTNSHELL RESOURCE "Down" GROUP OF ::oWndBrw ;
         NOBORDER ;
         ACTION      ( ::BajarOrden() ) ;
         TOOLTIP     "Ba(j)ar";
         HOTKEY      "J" ;
         LEVEL       ACC_EDIT

      ::oWndBrw:EndButtons( Self )

      if ::cHtmlHelp != nil
         ::oWndBrw:cHtmlHelp  := ::cHtmlHelp
      end if

      ::oWndBrw:Activate( nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, {|| ::CloseFiles() } )

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath )

   local lOpen          := .t.
   local oBlock

   DEFAULT lExclusive   := .f.
   DEFAULT cPath        := ::cPath

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER

      lOpen             := .f.

      ::CloseFiles()

      msgStop( "Imposible abrir las bases de datos ordenes de comanda" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE ::oDbf FILE "OrdenComanda.Dbf" CLASS "OrdenComanda" ALIAS "OrdenComanda" PATH ( cPath ) VIA ( cDriver ) COMMENT "Orden Comanda"

      FIELD NAME "cCodOrd"          TYPE "C" LEN   2  DEC 0 COMMENT "Código"                 COLSIZE  60 OF ::oDbf
      FIELD NAME "cNomOrd"          TYPE "C" LEN  30  DEC 0 COMMENT "Nombre"                 COLSIZE 300 OF ::oDbf
      FIELD NAME "cOrdOrd"          TYPE "C" LEN   2  DEC 0 COMMENT "Posición"   ALIGN RIGHT COLSIZE  80 OF ::oDbf 

      INDEX TO "OrdenComanda.Cdx"   TAG "cCodOrd"  ON "cCodOrd"   COMMENT "Código"           NODELETED   OF ::oDbf
      INDEX TO "OrdenComanda.Cdx"   TAG "cNomOrd"  ON "cNomOrd"   COMMENT "Nombre"           NODELETED   OF ::oDbf
      INDEX TO "OrdenComanda.Cdx"   TAG "cOrdOrd"  ON "cOrdOrd"   COMMENT "Posición"         NODELETED   OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

   DEFINE DIALOG ::oDlg RESOURCE "OrdenComanda" TITLE LblTitle( nMode ) + "orden de comanda"

      REDEFINE GET      ::oCodOrd ;
         VAR            ::oDbf:cCodOrd ;
         UPDATE ;
			ID             100 ;
         WHEN           ( nMode == APPD_MODE ) ;
         VALID          NotValid( ::oCodOrd, ::oDbf:cAlias, .t., "0" ) ;
			OF             ::oDlg

      REDEFINE GET      ::oNomOrd ;
         VAR            ::oDbf:cNomOrd ;
         UPDATE ;
         ID             101 ;
         WHEN           ( nMode != ZOOM_MODE ) ;
         PICTURE        "@!" ;
         OF             ::oDlg

      REDEFINE BUTTON ;
         ID             IDOK ;
			OF             ::oDlg ;
         WHEN           ( nMode != ZOOM_MODE ) ;
         ACTION         ( ::lPreSave( nMode ) )

		REDEFINE BUTTON ;
         ID             IDCANCEL ;
			OF             ::oDlg ;
         CANCEL ;
			ACTION         ( ::oDlg:end() )

      if nMode != ZOOM_MODE
         ::oDlg:AddFastKey( VK_F5, {|| ::lPreSave( nMode ) } )
      end if

   ACTIVATE DIALOG ::oDlg CENTER

RETURN ( ::oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD lPreSave( nMode )

   if Empty( ::oCodOrd:VarGet() )
      MsgStop( "Códido de orden de comanda no puede estar vacío." )
      ::oCodOrd:SetFocus()
      Return .f.
   end if

   if Empty( ::oNomOrd:VarGet() )
      MsgStop( "Orden de comanda no puede estar vacío." )
      ::oNomOrd:SetFocus()
      Return .f.
   end if

   if ( nMode == APPD_MODE .or. nMode == DUPL_MODE )
      ::oDbf:cOrdOrd    := Str( ::oDbf:RecCount() + 1, 2 )
   end if

RETURN ( ::oDlg:end( IDOK ) )

//--------------------------------------------------------------------------//

METHOD cCodigoOrden( cOrdOrd )

   local cCodOrden   := ""

   if ::oDbf:SeekInOrd( cOrdOrd, "cOrdOrd" )
      cCodOrden      := ::oDbf:cCodOrd
   end if

RETURN ( cCodOrden )

//---------------------------------------------------------------------------//

METHOD cNombre( cCodOrd )

   local cNombre        := ""

   ::oDbf:GetStatus()

   if ::oDbf:SeekInOrd( cCodOrd, "cCodOrd" )
      cNombre           := alltrim( ::oDbf:cNomOrd )
   end if

   ::oDbf:SetStatus()

RETURN ( cNombre )

//---------------------------------------------------------------------------//

METHOD cOrden( cNomOrd )

   local cCodigo        := ""

   ::oDbf:GetStatus()

   if !Empty( cNomOrd ) .and. ::oDbf:SeekInOrd( cNomOrd, "cNomOrd" )
      cCodigo           := ::oDbf:cOrdOrd
   end if

   ::oDbf:SetStatus()

RETURN ( cCodigo )

//---------------------------------------------------------------------------//

METHOD SubirOrden()

   local nRecno      := ::oDbf:Recno()

   if ( ::oDbf:OrdSetFocus() != Upper( "cOrdOrd" ) )
      msgStop( "La tabla debe estar ordenada por posición" )
      Return ( Self )      
   end if 

   if ( ::oDbf:OrdKeyNo() == 1 )
      msgStop( "Este orden ya está en la primera posición" )
      Return ( Self )          
   end if 

   CursorWait()

   ::oDbf:Skip( -1 )

   ::oDbf:FieldPutByName( "cOrdOrd", Str( Val( ::oDbf:cOrdOrd ) + 1, 2 ) )

   ::oDbf:GoTo( nRecno )

   ::oDbf:FieldPutByName( "cOrdOrd", Str( Val( ::oDbf:cOrdOrd ) - 1, 2 ) )

   ::oWndBrw:oBrw:Refresh()
   ::oWndBrw:oBrw:SelectOne()

   CursorWE()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD BajarOrden() 

   local nRecno      := ::oDbf:Recno()

   if ( ::oDbf:OrdSetFocus() != Upper( "cOrdOrd" ) )
      msgStop( "La tabla debe estar ordenada por posición" )
      Return ( Self )
   end if 

   if ( ::oDbf:Eof() )
      msgStop( "Este orden ya está en la última posición" )
      Return ( Self )          
   end if 

   CursorWait()

   ::oDbf:Skip( 1 )

   ::oDbf:FieldPutByName( "cOrdOrd", Str( Val( ::oDbf:cOrdOrd ) - 1, 2 ) )

   ::oDbf:GoTo( nRecno )

   ::oDbf:FieldPutByName( "cOrdOrd", Str( Val( ::oDbf:cOrdOrd ) + 1, 2 ) )

   ::oWndBrw:oBrw:Refresh()
   ::oWndBrw:oBrw:SelectOne()

   CursorWE()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD aNombreOrdenComanda()

   local aNombreOrdenComanda  := { "" }

   if Empty( ::oDbf ) .or. !( ::oDbf:Used() )
      Return ( aNombreOrdenComanda )
   end if 

   CursorWait()

   ::oDbf:GetStatus()
   ::oDbf:GoTop()

   while !( ::oDbf:Eof() )
      aAdd( aNombreOrdenComanda, AllTrim( ::oDbf:cNomOrd ) )
      ::oDbf:Skip()
   end while

   ::oDbf:SetStatus()

   CursorWE()

Return ( aNombreOrdenComanda ) 

//---------------------------------------------------------------------------//

METHOD Selector()

   local oDlg
   local oBrw
   local oFont
   local oBlock
   local oError
   local cReturn

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::oDbf:GetStatus()
   ::oDbf:GoTop()

   oFont                   := TFont():New( "Segoe UI",  0, 20, .f., .t. )

   DEFINE DIALOG oDlg RESOURCE "HelpEntryTactilIva" TITLE "Ordenes de comanda"

      oBrw                 := IXBrowse():New( oDlg )

      ::oDbf:SetBrowse( oBrw )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:nMarqueeStyle   := 5
      oBrw:nRowHeight      := 48
      oBrw:oFont           := oFont 
      oBrw:lHeader         := .f.

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

      with object ( oBrw:AddCol() )
         :cHeader          := ""
         :bEditValue       := {|| ::oDbf:cNomOrd }
         :nWidth           := 300
      end with

      oBrw:CreateFromResource( 105 )

      REDEFINE BUTTONBMP ;
         ID                140 ;
         OF                oDlg ;
         BITMAP            "UP32" ;
         ACTION            ( oBrw:GoUp() )

      REDEFINE BUTTONBMP ;
         ID                150 ;
         OF                oDlg ;
         BITMAP            "DOWN32" ;
         ACTION            ( oBrw:GoDown() )

      REDEFINE BUTTONBMP ;
         BITMAP            "gc_check_32" ;
         ID                IDOK ;
         OF                oDlg ;
         ACTION            ( oDlg:end(IDOK) )

      REDEFINE BUTTONBMP ;
         BITMAP            "Delete_32" ;
         ID                IDCANCEL ;
         OF                oDlg ;
         ACTION            ( oDlg:End() )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK
      cReturn              := ::oDbf:cCodOrd
   end if

   RECOVER USING oError

      msgStop( "Imposible abrir ordenes de comandas." + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !Empty( oFont )
      oFont:End()
   end if

Return ( cReturn )

//---------------------------------------------------------------------------//

METHOD getFirstOrderId()

   local cCodigoOrden

   ::oDbf:getStatus()
   ::oDbf:goTop()

   cCodigoOrden         := ::oDbf:cCodOrd   

   ::oDbf:setStatus()

Return ( cCodigoOrden )

//---------------------------------------------------------------------------//
