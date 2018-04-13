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
   DATA aTipo              INIT { "Texto", "N�mero", "Fecha", "Si/No", "Lista" } 
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

   METHOD New( cPath, oWndParent, oMenuItem )   CONSTRUCTOR

   METHOD DefineFiles()

   METHOD Activate()

   METHOD OpenFiles( lExclusive )
   METHOD CloseFiles()

   METHOD OpenService( lExclusive )
   METHOD CloseService()

   METHOD Reindexa( oMeter )

   METHOD Resource( nMode )

   METHOD ChangeTipo()                 INLINE ( if( hhaskey( ::hActions, ::cTipo ), Eval( hGet( ::hActions, ::cTipo ) ), ) )

   METHOD PreSave()

   METHOD initCombo()                  INLINE ( ::cTipo := ::aTipo[ Max( ::oDbf:nTipo, 1 ) ] )

   METHOD initDefecto()                INLINE ( ::cValorDefecto := Space( 100 ) )

   METHOD initValores()                INLINE ( ::initCombo(),;
                                                ::initDefecto(),;
                                                ::GetValoresDefecto() )

   METHOD enableLongitud()             INLINE ( ::oLongitud:Enable(),;
                                                ::oDecimales:Enable() )

   METHOD disableLongitud()            INLINE ( ::oLongitud:Disable(),;
                                                ::oDecimales:Disable() )

   METHOD cTextLongitud( nLon, nDec)   INLINE ( ::oLongitud:cText( nLon ),;
                                                ::oDecimales:cText( nDec ) )
   
   METHOD enableDefecto()              INLINE ( ::oValorDefecto:Enable(),; 
                                                ::oAddDefecto:Enable(),;
                                                ::oDelDefecto:Enable(),;
                                                ::oListaDefecto:Enable() )

   METHOD disableDefecto()             INLINE ( ::oValorDefecto:Disable(),;
                                                ::oAddDefecto:Disable(),;
                                                ::oDelDefecto:Disable(),;
                                                ::oListaDefecto:Disable() )

   METHOD SetValoresDefecto()          INLINE ( ::oDbf:mDefecto   := hb_serialize( ::oListaDefecto:aItems ) )
   METHOD GetValoresDefecto()          INLINE ( ::aValoresDefecto := hb_deserialize( ::oDbf:mDefecto ) )

   METHOD setDocumentos()              INLINE ( ::oDbf:mDocumento := hb_serialize( ::aDocumentos ) )
   METHOD getDocumentos()              INLINE ( ::aDocumentos     := hb_deserialize( ::oDbf:mDocumento ) )
   METHOD readDocumentos()             
   METHOD initDocumentos()             INLINE ( ::aDocumentos     := DOCUMENTOS_SELECTED ) 

   METHOD cargaValoresDocumentos( nMode )

   METHOD CreaTreeDocumentos()
   METHOD CreaListaImagenes()
   METHOD AddItemTree( k, v, i )

   METHOD lValidResource( nMode )

   METHOD aCamposExtra( cTipoCampo )
   METHOD getCodigoCampoExtra( cNombreCampo )
   
   METHOD Syncronize()

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
                                 "N�mero" => {|| ::enableLongitud(), ::disableDefecto(), ::cTextLongitud( 1, 0 ) } ,;
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

      FIELD NAME "cCodigo"       TYPE "C" LEN   3  DEC 0 PICTURE "@!" COMMENT "C�digo"                 COLSIZE 100    OF ::oDbf
      FIELD NAME "cNombre"       TYPE "C" LEN 100  DEC 0 PICTURE "@!" COMMENT "Descripci�n"            COLSIZE 600    OF ::oDbf
      FIELD NAME "mDocumento"    TYPE "M" LEN  10  DEC 0              COMMENT "Documentos"             HIDE           OF ::oDbf
      FIELD NAME "lRequerido"    TYPE "L" LEN   1  DEC 0              COMMENT "Campo obligatorio"      HIDE           OF ::oDbf
      FIELD NAME "nTipo"         TYPE "N" LEN   1  DEC 0              COMMENT "Tipo de campo"          HIDE           OF ::oDbf
      FIELD NAME "nLongitud"     TYPE "N" LEN   3  DEC 0              COMMENT "Longitud campo"         HIDE           OF ::oDbf
      FIELD NAME "nDecimales"    TYPE "N" LEN   1  DEC 0              COMMENT "Decimales campo"        HIDE           OF ::oDbf
      FIELD NAME "mDefecto"      TYPE "M" LEN  10  DEC 0              COMMENT "Valores por defecto"    HIDE           OF ::oDbf
      FIELD NAME "uuid"          TYPE "C" LEN  40  DEC 0              COMMENT "Uuid"                   HIDE           OF ::oDbf

      INDEX TO "CAMPOEXTRA.Cdx" TAG "cCodigo"   ON "cCodigo"          COMMENT "C�digo"        NODELETED OF ::oDbf
      INDEX TO "CAMPOEXTRA.Cdx" TAG "cNombre"   ON Upper( "cNombre" ) COMMENT "Descripci�n"   NODELETED OF ::oDbf

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
      TOOLTIP  "(A)�adir";
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

RETURN ( ::oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD cargaValoresDocumentos( nMode ) CLASS TCamposExtra

   if nMode == APPD_MODE .or. Empty( ::oDbf:mDocumento )
      ::initDocumentos()
      ::oDbf:Uuid    := win_uuidcreatestring()
   else
      ::getDocumentos()
   end if

RETURN ( self )

//----------------------------------------------------------------------------//

METHOD CreaTreeDocumentos() CLASS TCamposExtra

   local oItem

   ::CreaListaImagenes()

   hEval( ::aDocumentos, {| k, v, i | ::AddItemTree( k, v, i ) } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD CreaListaImagenes() CLASS TCamposExtra

   ::oTreeImageList  := TImageList():New( 16, 16 )

   hEval( ::aDocumentos, {| k, v, i | ::oTreeImageList:AddMasked( TBitmap():Define( hGet( ICONOS_DOCUMENTOS_ITEMS, k ) ), Rgb( 255, 0, 255 ) ) } )

   ::oTree:SetImageList( ::oTreeImageList )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddItemTree( k, v, i ) CLASS TCamposExtra

   local oItem  :=  ::oTree:Add( k, i - 1 )

   ::oTree:SetCheck( oItem, v )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD readDocumentos() CLASS TCamposExtra

   local oItem

   for each oItem in ::oTree:aItems
      if hhaskey( ::aDocumentos, oItem:cPrompt )
         hset( ::aDocumentos, oItem:cPrompt, ::oTree:GetCheck( oItem ) )
      end if 
   next

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lValidResource( nMode ) CLASS TCamposExtra

   local oItem

   if Empty( ::oDbf:cCodigo )
      MsgStop( "C�digo del campo extra no puede estar vac�o." )
      ::oCodigo:SetFocus()
      RETURN .f.
   end if

   if Empty( ::oDbf:cNombre )
      MsgStop( "Nombre del campo extra no puede estar vac�o." )
      ::oNombre:SetFocus()
      RETURN .f.
   end if

   ::readDocumentos()

RETURN .t.

//---------------------------------------------------------------------------//

METHOD PreSave() CLASS TCamposExtra

   ::oDbf:nTipo  := ::oTipo:nAt
   
   ::setValoresDefecto()

   ::setDocumentos()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD aCamposExtra( cTipoCampo ) CLASS TCamposExtra

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

            aAdd( aCamposExtra, {   "c�digo"       => ::oDbf:cCodigo,;
                                    "descripci�n"  => ::oDbf:cNombre,;
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

RETURN ( aCamposExtra )

//---------------------------------------------------------------------------//

METHOD getCodigoCampoExtra( cNombreCampo ) CLASS TCamposExtra

   local cCodigo  := ""

   ::oDbf:getStatus()
   ::oDbf:ordsetfocus( "cNombre" )

   if ::oDbf:seek( cNombreCampo )
      cCodigo     := ::oDbf:cCodigo
   end if

   ::oDbf:setStatus()

RETURN ( cCodigo )

//---------------------------------------------------------------------------//

METHOD Syncronize()

   local oDetCamposExtra

   if ::OpenFiles()

      while !( ::oDbf:Eof() )

         if empty( ::oDbf:Uuid ) 
            ::oDbf:fieldputByName( "uuid", win_uuidcreatestring() )
         end if 

         ::oDbf:Skip()

      end if

      ::CloseService()

   end if

   oDetCamposExtra            := TDetCamposExtra():New()
   
   if oDetCamposExtra:OpenFiles()

      while !( oDetCamposExtra:oDbf:Eof() )

         if empty( oDetCamposExtra:oDbf:Uuid ) 
            oDetCamposExtra:oDbf:fieldputByName( "uuid", win_uuidcreatestring() )
         end if 

         oDetCamposExtra:oDbf:Skip()

      end if

      oDetCamposExtra:CloseService()

   end if

RETURN .t.

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
      RETURN ( cExtraField )
   end if 

   oDetCamposExtra:oDbf:getStatus()
   oDetCamposExtra:oDbf:ordsetfocus( "cTotClave" )

   oDetCamposExtra:oDbf:Seek( cTipoDocumento + cCodigoCampo + Id )

   cExtraField          := oDetCamposExtra:oDbf:cValor
   
   oDetCamposExtra:oDbf:setStatus()

RETURN ( cExtraField )

//---------------------------------------------------------------------------//

Function getCustomExtraField( cFieldName, cDocumentType, Id )

   local cExtraField          := ""
   local cTipoDocumento       := ""
   local oDetCamposExtra

   if Empty( Id )
      RETURN cExtraField
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

RETURN ( cExtraField )

//---------------------------------------------------------------------------//

CLASS CamposExtraModel FROM ADSBaseModel

   METHOD getTableName()                     INLINE ::getEmpresaTableName( "CampoExtra" )

   METHOD getUuid( cCodigoTipo )

END CLASS

//---------------------------------------------------------------------------//

METHOD getUuid( cCodigoTipo ) CLASS CamposExtraModel

   local cStm
   local cSql  := "SELECT Uuid "                                  + ;
                     "FROM " + ::getTableName() + " "             + ;
                     "WHERE cCodigo = " + quoted( cCodigoTipo ) 

   if ::ExecuteSqlStatement( cSql, @cStm )
      RETURN ( ( cStm )->Uuid ) 
   end if 

RETURN ( "" )

//---------------------------------------------------------------------------//

