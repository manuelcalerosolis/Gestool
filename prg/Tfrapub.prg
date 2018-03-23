#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TFrasesPublicitarias FROM TMant

   DATA  oDlg

   DATA  oGetCodigo
   DATA  oGetFrase

   DATA  cBitmap                       INIT clrTopArchivos

   DATA  oDetCamposExtra

   METHOD New( cPath, oWndParent, oMenuItem )

   METHOD Activate()

   METHOD OpenFiles( lExclusive )

   METHOD CloseFiles()
   
   METHOD DefineFiles()

   METHOD Resource( nMode )

   METHOD InvSelect( oBrw )            INLINE ( ::oDbf:Load(), ::oDbf:lSelect := !::oDbf:lSelect, ::oDbf:Save(), oBrw:Refresh() )

   Method lSelect( lSel, oBrw )

   METHOD SelectAll( lSel, oBrw )

   METHOD lValid( oGet, oSay )

   METHOD cNombre( cCodArt )

   METHOD lPreSave( oGet, oGet2, oDlg, nMode )

   METHOD CargaValoresCamposExtra()

   METHOD SaveCamposExtra()

END CLASS

//----------------------------------------------------------------------------//

METHOD New( cPath, cDriver, oWndParent, oMenuItem )

   DEFAULT cPath        := cPatArt()
   DEFAULT cDriver      := cDriver()
   DEFAULT oWndParent   := GetWndFrame()
   DEFAULT oMenuItem    := "01129"

   ::cPath              := cPath
   ::cDriver            := cDriver   
   ::oWndParent         := oWndParent
   ::nLevel             := Auth():Level( oMenuItem )

   ::oDbf               := nil
   ::cMru               := "gc_box_closed_16"

   ::lAutoButtons       := .t.
   ::lCreateShell       := .f.

   ::bOnPreDelete       := {|| ::oDetCamposExtra:RollBackValores( ::oDbf:cCodFra ) }

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Activate()

   if nAnd( ::nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      Return ( Self )
   end if

   /*
   Cerramos todas las ventanas
   */

   if ::oWndParent != nil
      ::oWndParent:CloseAll()
   end if

   if Empty( ::oDbf ) .or. !::oDbf:Used()
      ::lOpenFiles      := ::OpenFiles()
   end if

   /*
   Creamos el Shell
   */

   if ::lOpenFiles

      ::CreateShell( ::nLevel )

      DEFINE BTNSHELL RESOURCE "BUS" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::oWndBrw:SearchSetFocus() ) ;
         TOOLTIP  "(B)uscar" ;
         HOTKEY   "B";

         ::oWndBrw:AddSeaBar()

      DEFINE BTNSHELL RESOURCE "NEW" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::oWndBrw:RecAdd() );
         ON DROP  ( ::oWndBrw:RecAdd() );
         TOOLTIP  "(A)ñadir";
         BEGIN GROUP ;
         HOTKEY   "A" ;
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

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath )

   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT lExclusive   := .f.
   DEFAULT cPath        := ::cPath

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::DefineFiles( cPath )
      end if

      ::oDetCamposExtra := TDetCamposExtra():New()
      if !::oDetCamposExtra:OpenFiles()
         lOpen          := .f.
      end if

      ::oDetCamposExtra:setTipoDocumento( "Envases de artículos" )

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos de envasado" )

      ::CloseFiles()

      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD CloseFiles()

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   if ::oDetCamposExtra != nil
      ::oDetCamposExtra:End()
   end if

   ::oDbf            := nil
   ::oDetCamposExtra := nil

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := ::cDriver

   DEFINE DATABASE ::oDbf FILE "FraPub.Dbf" CLASS "FraPub" ALIAS "FraPub" PATH ( cPath ) VIA ( cDriver ) COMMENT "Envasado"

      FIELD NAME "cCodFra"    TYPE "C" LEN  3  DEC 0 COMMENT "Código"               PICTURE "@!"   COLSIZE 60  OF ::oDbf
      FIELD NAME "cTxtFra"    TYPE "C" LEN 200 DEC 0 COMMENT "Envase"                              COLSIZE 200 OF ::oDbf
      FIELD NAME "lSelect"    TYPE "L" LEN  1  DEC 0 COMMENT ""                     HIDE           COLSIZE 0   OF ::oDbf

      INDEX TO "FraPub.CDX" TAG "cCodFra" ON "cCodFra" COMMENT "Código"    NODELETED OF ::oDbf
      INDEX TO "FraPub.CDX" TAG "cTxtFra" ON "cTxtFra" COMMENT "Envase"    NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

   local oBmpDlg

   ::CargaValoresCamposExtra( nMode )

   DEFINE DIALOG ::oDlg RESOURCE "FraPub" TITLE LblTitle( nMode ) + "envase"

      REDEFINE BITMAP oBmpDlg ;
         ID       990 ;
         RESOURCE "gc_box_closed_48" ;
         TRANSPARENT ;
         OF       ::oDlg

      REDEFINE GET ::oGetCodigo VAR ::oDbf:cCodFra UPDATE;
	      ID 		100 ;
         WHEN     ( nMode == APPD_MODE ) ;
         PICTURE  "@!" ;
         OF       ::oDlg

      ::oGetCodigo:bValid  := {|| NotValid( ::oGetCodigo, ::oDbf:cAlias, .t., "0" ) }

      REDEFINE GET ::oGetFrase VAR ::oDbf:cTxtFra UPDATE;
			ID 		110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       ::oDlg

      ::oDetCamposExtra:oBrw                        := IXBrowse():New( ::oDlg )

      ::oDetCamposExtra:oBrw:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oDetCamposExtra:oBrw:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oDetCamposExtra:oBrw:SetArray( ::oDetCamposExtra:aItemSelected, , , .f. )

      ::oDetCamposExtra:oBrw:nMarqueeStyle          := MARQSTYLE_HIGHLCELL
      ::oDetCamposExtra:oBrw:lRecordSelector        := .f.
      ::oDetCamposExtra:oBrw:lHScroll               := .f.
      ::oDetCamposExtra:oBrw:lFastEdit              := .t.

      ::oDetCamposExtra:oBrw:bChange                := {|| if( nMode != ZOOM_MODE, ::oDetCamposExtra:ChangeBrowse(), ) }

      ::oDetCamposExtra:oBrw:CreateFromResource( 120 )

      with object ( ::oDetCamposExtra:oBrw:AddCol() )
         :cHeader          := "Campo"
         :bStrData         := {|| AllTrim( Capitalize( hGet( ::oDetCamposExtra:aItemSelected[ ::oDetCamposExtra:oBrw:nArrayAt ], "descripción" ) ) ) + if( hGet( ::oDetCamposExtra:aItemSelected[ ::oDetCamposExtra:oBrw:nArrayAt ], "lrequerido" ), " *", "" ) }
         :nWidth           := 180
      end with

      with object ( ::oDetCamposExtra:oCol := ::oDetCamposExtra:oBrw:AddCol() )
         :cHeader          := "Valor"
         :bEditValue       := {|| hGet( ::oDetCamposExtra:aItemSelected[ ::oDetCamposExtra:oBrw:nArrayAt ], "valor" ) }
         :bStrData         := {|| hGet( ::oDetCamposExtra:aItemSelected[ ::oDetCamposExtra:oBrw:nArrayAt ], "valor" ) }
         :nWidth           := 200
      end with

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       ::oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::lPreSave(  nMode ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       ::oDlg ;
         CANCEL ;
         ACTION   ( ::oDlg:end() )

   if nMode != ZOOM_MODE
      ::oDlg:AddFastKey( VK_F5, {|| ::lPreSave( nMode ) } )
   end if

   ::oDlg:bStart  := {|| if( nMode != ZOOM_MODE, ::oDetCamposExtra:ChangeBrowse(), ), ::oGetCodigo:SetFocus() }

   ACTIVATE DIALOG ::oDlg CENTER

   if ::oDlg:nResult == IDOK
      ::SaveCamposExtra()
   end if

   if !Empty( oBmpDlg )
      oBmpDlg:End()
   end if

RETURN ( ::oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD lPreSave( nMode )

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if Empty( ::oDbf:cCodFra )
         MsgStop( "Código de envase no puede estar vacío." )
         ::oGetCodigo:SetFocus()
         Return .f.
      end if

      if ::oDbf:SeekInOrd( ::oDbf:cCodFra, "cCodFra" )
         MsgStop( "Código ya existe " + Rtrim( ::oDbf:cCodFra ) )
         return nil
      end if

   end if

   if Empty( ::oDbf:cTxtFra )
      MsgStop( "Nombre no puede estar vacía." )
      ::oGetFrase:SetFocus()
      Return .f.
   end if

RETURN ( ::oDlg:end( IDOK ) )

//--------------------------------------------------------------------------//

Method lSelect( lSel, oBrw )

   ::oDbf:Load()
   ::oDbf:lSelect    := lSel
   ::oDbf:Save()

   if oBrw != nil
      oBrw:Refresh()
   end if

Return ( Self )

//--------------------------------------------------------------------------//

METHOD SelectAll( lSel, oBrw )

   ::oDbf:GetStatus()

   DEFAULT lSel   := .f.

   ::oDbf:GoTop()
   while !( ::oDbf:eof() )
      ::lSelect( lSel )
      ::oDbf:Skip()
   end while

   ::oDbf:SetStatus()

   if oBrw != nil
      oBrw:Refresh()
   end if

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD lValid( oGet, oSay )

   local cCodFra

   if Empty( oGet:VarGet() )
      return .t.
   end if

   cCodFra        := RJustObj( oGet, "0" )

   if ::oDbf:Seek( cCodFra )
      oGet:cText( cCodFra )
      if oSay != nil
         oSay:cText( ::oDbf:cTxtFra )
      end if
   else
      msgStop( "Código de envase no encontrado" )
      return .f.
   end if

RETURN .t.

//--------------------------------------------------------------------------//

METHOD cNombre( cCodFra )

   local cNombre  := ""

   if ::oDbf:Seek( cCodFra )
      cNombre     := ::oDbf:cTxtFra
   end if

RETURN ( cNombre )

//---------------------------------------------------------------------------//

METHOD CargaValoresCamposExtra( nMode )

   ::oDetCamposExtra:SetTemporal( ::oDbf:cCodFra, "", nMode )

   ::oDetCamposExtra:Play( Space(1), .f. )

   if len( ::oDetCamposExtra:aItemSelected ) == 0

      aAdd( ::oDetCamposExtra:aItemSelected,  {  "código"       => Space(1),;
                                                "descripción"  => Space(1),;
                                                "tipo"         => 1,;
                                                "longitud"     => 1,;
                                                "decimales"    => 0,;
                                                "lrequerido"   => .f.,;
                                                "valores"      => Space(1),;
                                                "valor"        => Space(1) } )

   end if

Return ( nil )

//---------------------------------------------------------------------------//

METHOD SaveCamposExtra()

   ::oDetCamposExtra:saveExtraField( ::oDbf:cCodFra, "" )

Return ( nil )

//---------------------------------------------------------------------------//