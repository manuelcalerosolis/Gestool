#include "FiveWin.Ch"
#include "Report.ch"
#include "Xbrowse.ch"
#include "MesDbf.ch"
#include "Factu.ch" 
#include "FastRepH.ch"

static oCamposExtra

//---------------------------------------------------------------------------//
    
CLASS TCamposExtra FROM TMant

   DATA cMru               INIT  "gc_form_plus2_16"
   DATA cBitmap            INIT  Rgb( 128, 57, 123 )
    
   DATA oDlg

   DATA lOpenFiles         INIT .f.          

   DATA oCodigo
   DATA oNombre
   DATA oTipo
   DATA cTipo              INIT "Texto"
   DATA aTipo              INIT { "Texto", "Número", "Fecha", "Si/No", "Lista" } 
   DATA oLongitud
   DATA oDecimales
   DATA hActions
   DATA oValorDefecto
   DATA cValorDefecto      INIT Space( 100 )
   DATA oAddDefecto
   DATA oDelDefecto

   DATA oListaDefecto
   DATA cListaDefecto      INIT ""
   DATA aValoresDefecto

   DATA oTree
   DATA oTreeImageList

   DATA aDocumentos        INIT {}

   Method New( cPath, oWndParent, oMenuItem )   CONSTRUCTOR

   Method DefineFiles()

   Method Activate()

   Method OpenFiles( lExclusive )
   Method CloseFiles()

   Method OpenService( lExclusive )
   Method CloseService()

   Method Reindexa( oMeter )

   Method Resource( nMode )

   Method ChangeTipo()                 INLINE ( if( hhaskey( ::hActions, ::cTipo ), Eval( hGet( ::hActions, ::cTipo ) ), ) )

   Method PreSave()

   Method initCombo()                  INLINE ( ::cTipo := ::aTipo[ Max( ::oDbf:nTipo, 1 ) ] )

   Method initDefecto()                INLINE ( ::cValorDefecto := Space( 100 ) )

   Method initValores()                INLINE ( ::initCombo(),;
                                                ::initDefecto(),;
                                                ::GetValoresDefecto() )

   Method enableLongitud()             INLINE ( ::oLongitud:Enable(),;
                                                ::oDecimales:Enable() )

   Method disableLongitud()            INLINE ( ::oLongitud:Disable(),;
                                                ::oDecimales:Disable() )

   Method cTextLongitud( nLon, nDec)   INLINE ( ::oLongitud:cText( nLon ),;
                                                ::oDecimales:cText( nDec ) )
   
   Method enableDefecto()              INLINE ( ::oValorDefecto:Enable(),; 
                                                ::oAddDefecto:Enable(),;
                                                ::oDelDefecto:Enable(),;
                                                ::oListaDefecto:Enable() )

   Method disableDefecto()             INLINE ( ::oValorDefecto:Disable(),;
                                                ::oAddDefecto:Disable(),;
                                                ::oDelDefecto:Disable(),;
                                                ::oListaDefecto:Disable() )

   Method SetValoresDefecto()          INLINE ( ::oDbf:mDefecto   := hb_serialize( ::oListaDefecto:aItems ) )
   Method GetValoresDefecto()          INLINE ( ::aValoresDefecto := hb_deserialize( ::oDbf:mDefecto ) )

   Method setDocumentos()              INLINE ( ::oDbf:mDocumento := hb_serialize( ::aDocumentos ) )
   Method getDocumentos()              INLINE ( ::aDocumentos     := hb_deserialize( ::oDbf:mDocumento ) )
   Method readDocumentos()             
   Method initDocumentos()             INLINE ( ::aDocumentos     := DOCUMENTOS_SELECTED ) 

   Method cargaValoresDocumentos( nMode )

   Method CreaTreeDocumentos()
   Method CreaListaImagenes()
   Method AddItemTree( k, v, i )

   Method lValidResource( nMode )

   Method aCamposExtra( cTipoCampo )
   Method getCodigoCampoExtra( cNombreCampo )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( cPath, oWndParent, oMenuItem ) CLASS TCamposExtra

   DEFAULT cPath           := cPatEmp()
   DEFAULT oWndParent      := oWnd()
   DEFAULT oMenuItem       := "campos_extra"

   ::cPath                 := cPath
   ::oWndParent            := oWndParent
   ::oMenuItem             := oMenuItem

   ::oDbf                  := nil

   ::hActions              := {  "Texto"  => {|| ::enableLongitud(), ::disableDefecto(), ::cTextLongitud( 1, 0 ) } ,;
                                 "Número" => {|| ::enableLongitud(), ::disableDefecto(), ::cTextLongitud( 1, 0 ) } ,;
                                 "Fecha"  => {|| ::disableLongitud(), ::cTextLongitud( 8, 0 ), ::disableDefecto() } ,;
                                 "Si/No"  => {|| ::disableLongitud(), ::cTextLongitud( 1, 0 ), ::disableDefecto() } ,;
                                 "Lista"  => {|| ::disableLongitud(), ::cTextLongitud( 10, 0 ), ::enableDefecto() } }

   ::aValoresDefecto       := { }

   ::bFirstKey             := {|| ::oDbf:cCodigo }
   ::bOnPreSave            := {|| ::PreSave() }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver ) CLASS TCamposExtra

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE ::oDbf FILE "CAMPOEXTRA.DBF" CLASS "CAMPOEXTRA" ALIAS "CAMPOEXTRA" PATH ( cPath ) VIA ( cDriver ) COMMENT "Campos extra"

      FIELD NAME "cCodigo"       TYPE "C" LEN   3  DEC 0 PICTURE "@!" COMMENT "Código"                 COLSIZE 100    OF ::oDbf
      FIELD NAME "cNombre"       TYPE "C" LEN 100  DEC 0 PICTURE "@!" COMMENT "Descripción"            COLSIZE 600    OF ::oDbf
      FIELD NAME "mDocumento"    TYPE "M" LEN  10  DEC 0              COMMENT "Documentos"             HIDE           OF ::oDbf
      FIELD NAME "lRequerido"    TYPE "L" LEN   1  DEC 0              COMMENT "Campo obligatorio"      HIDE           OF ::oDbf
      FIELD NAME "nTipo"         TYPE "N" LEN   1  DEC 0              COMMENT "Tipo de campo"          HIDE           OF ::oDbf
      FIELD NAME "nLongitud"     TYPE "N" LEN   3  DEC 0              COMMENT "Longitud campo"         HIDE           OF ::oDbf
      FIELD NAME "nDecimales"    TYPE "N" LEN   1  DEC 0              COMMENT "Decimales campo"        HIDE           OF ::oDbf
      FIELD NAME "mDefecto"      TYPE "M" LEN  10  DEC 0              COMMENT "Valores por defecto"    HIDE           OF ::oDbf

      INDEX TO "CAMPOEXTRA.Cdx" TAG "cCodigo"   ON "cCodigo"          COMMENT "Código"        NODELETED OF ::oDbf
      INDEX TO "CAMPOEXTRA.Cdx" TAG "cNombre"   ON Upper( "cNombre" ) COMMENT "Descripción"   NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS TCamposExtra

   local oSnd
   local oDel
   local oImp
   local oPrv
   local nLevel   := Auth():Level( ::oMenuItem )

   if nAnd( nLevel, 1 ) == 0
      msgStop( "Acceso no permitido." )
      RETURN ( Self )
   end if 

   /*
   Cerramos todas las ventanas----------------------------------------------
   */

   if ::oWndParent != nil
      ::oWndParent:CloseAll()
   end if

   ::CreateShell( nLevel )

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

   DEFINE BTNSHELL oDel RESOURCE "DEL" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::oWndBrw:RecDel() );
      TOOLTIP  "(E)liminar";
      HOTKEY   "E";
      LEVEL    ACC_DELE

   ::oWndBrw:EndButtons( Self )

   if ::cHtmlHelp != nil
      ::oWndBrw:cHtmlHelp  := ::cHtmlHelp
   end if

   ::oWndBrw:Activate( nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, {|| ::CloseFiles() }, nil, nil )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive ) CLASS TCamposExtra

   local oError
   local oBlock           

   DEFAULT lExclusive      := .f.

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if !::lOpenFiles

         if Empty( ::oDbf )
            ::DefineFiles()
         end if

         ::oDbf:Activate( .f., !( lExclusive ) )

         ::lOpenFiles      := .t.

      end if

   RECOVER USING oError

      ::lOpenFiles         := .f.

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !::lOpenFiles
      ::CloseFiles()
   end if

RETURN ( ::lOpenFiles )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TCamposExtra

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   ::oDbf         := nil

   ::lOpenFiles   := .f.

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD OpenService( lExclusive, cPath ) CLASS TCamposExtra
       
   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT lExclusive   := .f.
   DEFAULT cPath        := ::cPath

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf         := ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER USING oError

      lOpen             := .f.

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

   END SEQUENCE

   ErrorBlock( oBlock )

   ::CloseFiles()

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseService() CLASS TCamposExtra

   if !Empty( ::oDbf ) .and. ::oDbf:Used()
      ::oDbf:End()
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD Reindexa() CLASS TCamposExtra

   if Empty( ::oDbf )
      ::oDbf      := ::DefineFiles()
   end if

   ::oDbf:IdxFDel()

   ::oDbf:Activate( .f., .t., .f. )

   ::oDbf:Pack()

   ::oDbf:End()

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS TCamposExtra

   local oBmp
   local oBtnAceptar
   local oBtnCancelar

   ::initValores()

   ::cargaValoresDocumentos( nMode )

   DEFINE DIALOG ::oDlg RESOURCE "EXTRA" TITLE LblTitle( nMode ) + "campo extra"

   REDEFINE BITMAP oBmp ;
      ID          600 ;
      RESOURCE    "gc_form_plus2_48" ;
      TRANSPARENT ;
      OF          ::oDlg
   
   REDEFINE GET ::oCodigo VAR ::oDbf:cCodigo ;
      ID          100 ;
      WHEN        ( nMode == APPD_MODE ) ;
      OF          ::oDlg

   ::oCodigo:bHelp  := {|| ::oCodigo:cText( NextKey( ::oDbf:cCodigo, ::oDbf:cAlias, "0", 3 ) ) }
   ::oCodigo:cBmp   := "BOT"

   REDEFINE GET ::oNombre VAR ::oDbf:cNombre ;
      ID          110 ;
      WHEN        ( nMode != ZOOM_MODE ) ;
      OF          ::oDlg

   REDEFINE CHECKBOX ::oDbf:lRequerido ;
      ID          120 ;
      WHEN        ( nMode != ZOOM_MODE ) ;
      OF          ::oDlg

   REDEFINE COMBOBOX ::oTipo ;
      VAR         ::cTipo ;
      ITEMS       ::aTipo ;
      ID          130 ;
      OF          ::oDlg

      ::oTipo:bChange   := {|| ::ChangeTipo() }

   REDEFINE GET ::oLongitud VAR ::oDbf:nLongitud ;
      ID          140 ;
      PICTURE     "999" ;
      SPINNER ;
      MIN         1 ;
      MAX         200 ;
      VALID       ( ::oDbf:nLongitud >= 1 .and. ::oDbf:nLongitud <= 200 ) ;
      OF          ::oDlg   

   REDEFINE GET ::oDecimales VAR ::oDbf:nDecimales ;
      ID          150 ;
      PICTURE     "9" ;
      SPINNER ;
      MIN         0 ;
      MAX         6 ;
      VALID       ( ::oDbf:nDecimales >= 0 .and. ::oDbf:nDecimales <= 6 ) ;
      OF          ::oDlg

   REDEFINE GET ::oValorDefecto VAR ::cValorDefecto ;
      ID          160 ;
      OF          ::oDlg

   REDEFINE BUTTON ::oAddDefecto;
      ID          170 ;
      OF          ::oDlg ;
      ACTION      ( if( !Empty( ::cValorDefecto ), ::oListaDefecto:Add( ::cValorDefecto ), ) )

   REDEFINE BUTTON ::oDelDefecto;
      ID          180 ;
      OF          ::oDlg ;
      ACTION      ( ::oListaDefecto:Del() )

   REDEFINE LISTBOX ::oListaDefecto ;
      VAR         ::cListaDefecto ;
      ITEMS       ::aValoresDefecto ;
      ID          190 ;
      OF          ::oDlg

   ::oTree        := TTreeView():Redefine( 200, ::oDlg )

   REDEFINE BUTTON oBtnAceptar ;
      ID          IDOK ;
      OF          ::oDlg ;
      ACTION      ( if( ::lValidResource( nMode ), ::oDlg:End( IDOK ), ) )

   REDEFINE BUTTON oBtnCancelar ;
      ID          IDCANCEL ;
      OF          ::oDlg ;
      CANCEL ;
      ACTION      ( ::oDlg:End( IDCANCEL ) )

      ::oDlg:AddFastKey( VK_F5, {|| oBtnAceptar:Click() } )

      ::oDlg:bStart  := {|| ::CreaTreeDocumentos() } // ::ChangeTipo(),

   ACTIVATE DIALOG ::oDlg CENTER

   oBmp:End()

Return ( ::oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD cargaValoresDocumentos( nMode ) CLASS TCamposExtra

   if nMode == APPD_MODE .or. Empty( ::oDbf:mDocumento )
      ::initDocumentos()
   else
      ::getDocumentos()
   end if

Return ( self )

//----------------------------------------------------------------------------//

METHOD CreaTreeDocumentos() CLASS TCamposExtra

   local oItem

   ::CreaListaImagenes()

   hEval( ::aDocumentos, {| k, v, i | ::AddItemTree( k, v, i ) } )

Return ( self )

//---------------------------------------------------------------------------//

METHOD CreaListaImagenes() CLASS TCamposExtra

   ::oTreeImageList  := TImageList():New( 16, 16 )

   hEval( ::aDocumentos, {| k, v, i | ::oTreeImageList:AddMasked( TBitmap():Define( hGet( ICONOS_DOCUMENTOS_ITEMS, k ) ), Rgb( 255, 0, 255 ) ) } )

   ::oTree:SetImageList( ::oTreeImageList )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD AddItemTree( k, v, i ) CLASS TCamposExtra

   local oItem  :=  ::oTree:Add( k, i - 1 )

   ::oTree:SetCheck( oItem, v )

Return ( Self )

//---------------------------------------------------------------------------//

Method readDocumentos() CLASS TCamposExtra

   local oItem

   for each oItem in ::oTree:aItems
      if hhaskey( ::aDocumentos, oItem:cPrompt )
         hset( ::aDocumentos, oItem:cPrompt, ::oTree:GetCheck( oItem ) )
      end if 
   next

Return ( Self )

//---------------------------------------------------------------------------//

METHOD lValidResource( nMode ) CLASS TCamposExtra

   local oItem

   if Empty( ::oDbf:cCodigo )
      MsgStop( "Código del campo extra no puede estar vacío." )
      ::oCodigo:SetFocus()
      Return .f.
   end if

   if Empty( ::oDbf:cNombre )
      MsgStop( "Nombre del campo extra no puede estar vacío." )
      ::oNombre:SetFocus()
      Return .f.
   end if

   ::readDocumentos()

Return .t.

//---------------------------------------------------------------------------//

Method PreSave() CLASS TCamposExtra

   ::oDbf:nTipo  := ::oTipo:nAt
   
   ::setValoresDefecto()

   ::setDocumentos()

Return ( self )

//---------------------------------------------------------------------------//

Method aCamposExtra( cTipoCampo ) CLASS TCamposExtra

   local nLen
   local nDec
   local cValor
   local aCampos
   local aCamposExtra   := {}

   ::oDbf:GoTop()

   while !::oDbf:Eof()

      aCampos           := hb_deserialize( ::oDbf:mDocumento )

      if !empty( aCampos )

         if hhaskey( aCampos, cTipoCampo ) .and. hGet( aCampos, cTipoCampo )

            do case 
               case ::oDbf:nTipo == 2
                  cValor   := 0
               case ::oDbf:nTipo == 3
                  cValor   := cTod( "" ) 
               otherwise
                  cValor   := Space( 100 )
            end case

            aAdd( aCamposExtra, {   "código"       => ::oDbf:cCodigo,;
                                    "descripción"  => ::oDbf:cNombre,;
                                    "tipo"         => ::oDbf:nTipo,;
                                    "longitud"     => ::oDbf:nLongitud,;
                                    "decimales"    => ::oDbf:nDecimales,;
                                    "lrequerido"   => ::oDbf:lRequerido,;
                                    "valores"      => hb_deserialize( ::oDbf:mDefecto ),;
                                    "valor"        => cValor,;
                                    "clave"        => space( 30 ),;
                                    "claveinterna" => "" } )

         end if

      end if

      ::oDbf:Skip()

   end while

Return ( aCamposExtra )

//---------------------------------------------------------------------------//

Method getCodigoCampoExtra( cNombreCampo ) CLASS TCamposExtra

   local cCodigo  := ""

   ::oDbf:getStatus()
   ::oDbf:ordsetfocus( "cNombre" )

   if ::oDbf:seek( cNombreCampo )
      cCodigo     := ::oDbf:cCodigo
   end if

   ::oDbf:setStatus()

Return ( cCodigo )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

FUNCTION CamposExtra( oMenuItem, oWnd )  

   DEFAULT oMenuItem    := "campos_extra"
   DEFAULT oWnd         := oWnd()

   if Empty( oCamposExtra )

      /*
      Cerramos todas las ventanas
      */

      if oWnd != nil
         SysRefresh(); oWnd:CloseAll(); SysRefresh() 
      end if

      /*
      Anotamos el movimiento para el navegador
      */

      AddMnuNext( "Campos extra", ProcName() )

      oCamposExtra        := TCamposExtra():New( cPatEmp(), oWnd )
      
      if !Empty( oCamposExtra )
         oCamposExtra:Play()
      end if

      oCamposExtra         := nil

   end if

RETURN NIL

//--------------------------------------------------------------------------//     

Function getExtraField( cFieldName, oDetCamposExtra, Id )

   local cExtraField    := ""
   local cTipoDocumento := ""
   local cCodigoCampo   := ""

   cTipoDocumento       := hGet( DOCUMENTOS_ITEMS, oDetCamposExtra:TipoDocumento )
   cCodigoCampo         := oDetCamposExtra:oCamposExtra:getCodigoCampoExtra( cFieldName )

   if empty(cTipoDocumento) .or. empty(cCodigoCampo) .or. empty(Id)
      Return ( cExtraField )
   end if 

   oDetCamposExtra:oDbf:getStatus()
   oDetCamposExtra:oDbf:ordsetfocus( "cTotClave" )

   oDetCamposExtra:oDbf:Seek( cTipoDocumento + cCodigoCampo + Id )

   cExtraField          := oDetCamposExtra:oDbf:cValor
   
   oDetCamposExtra:oDbf:setStatus()

Return ( cExtraField )

//---------------------------------------------------------------------------//

Function getCustomExtraField( cFieldName, cDocumentType, Id )

   local cExtraField          := ""
   local cTipoDocumento       := ""
   local oDetCamposExtra

   if Empty( Id )
      Return cExtraField
   end if

   oDetCamposExtra            := TDetCamposExtra():New()
   oDetCamposExtra:OpenFiles()

   cTipoDocumento             := hGet( DOCUMENTOS_ITEMS, cDocumentType )

   oDetCamposExtra:oCamposExtra:oDbf:ordsetfocus( "cCodigo" )
   oDetCamposExtra:oDbf:ordsetfocus( "cTotClave" )

   if oDetCamposExtra:oDbf:Seek( cTipoDocumento + cFieldName + Id )

      if oDetCamposExtra:oCamposExtra:oDbf:Seek( cFieldName )

         do case
            case oDetCamposExtra:oCamposExtra:oDbf:nTipo == 2
               cExtraField    := val( oDetCamposExtra:oDbf:cValor )

            case oDetCamposExtra:oCamposExtra:oDbf:nTipo == 3
               cExtraField    := ctod( oDetCamposExtra:oDbf:cValor )   

            otherwise
               cExtraField    := oDetCamposExtra:oDbf:cValor   

         end case
         
      end if

   end if
   
   oDetCamposExtra:CloseFiles()
   oDetCamposExtra:End()

Return ( cExtraField )

//---------------------------------------------------------------------------//