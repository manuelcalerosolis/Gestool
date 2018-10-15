#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS MailController 

   DATA oController

   DATA oDialogView

   DATA oValidator

   DATA cMail

   DATA oMailSender

   DATA cTypeDocument

   DATA cHtmlFile

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD selectHtmlFile()

   METHOD loadDefaultHtmlFile()

   METHOD loadHtmlFile( cFile )

   METHOD setFileDefaultHtml( cFile )
   
   METHOD saveAsHtml()
   
   METHOD saveHTML()

   METHOD getController()              INLINE ( ::oController )

   METHOD loadDocuments()              INLINE ( ::getController():loadDocuments() )

   METHOD getDocumentPdf()             INLINE ( ::getController():getDocumentPdf() )

   METHOD getIds()                     INLINE ( iif( !empty( ::oController ), ::oController:getIds(), {} ) )

   METHOD getUuidIdentifiers()         INLINE ( hGetValues( ::oController:getIdentifiers() ) )

   // Envio de mails----------------------------------------------------------

   METHOD hasMail()

   METHOD Send()

   METHOD generatePdf( uuidIdentifier, cDocumentPdf ) INLINE ;
                                       ( ::oController:generatePdf( uuidIdentifier, cDocumentPdf ) )

   // Construcciones tardias---------------------------------------------------

   METHOD getDialogView()              INLINE ( if( empty( ::oDialogView ), ::oDialogView := MailView():New( self ), ), ::oDialogView )

   METHOD getValidator()               INLINE ( if( empty( ::oValidator ), ::oValidator := MailValidator():New( self ), ), ::oValidator )

   METHOD getMailSender()              INLINE ( if( empty( ::oMailSender ), ::oMailSender := MailSender():New( self ), ), ::oMailSender )

   METHOD dialogViewActivate()         INLINE ( ::getDialogView():Activate() )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS MailController

   ::oController                    := oController

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS MailController

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if

   if !empty( ::oValidator )
      ::oValidator:End()
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD hasMail( uuidIdentifier )

   ::cMail  := ::getController():getRepository():getClientMailWhereFacturaUuid( uuidIdentifier )
      
   if empty( ::cMail )
      RETURN ( .f. )
   end if 
   
RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD Send()

   local hMail
   local cMail
   local uuidIdentifier

   if empty( ::getMailSender() )
      RETURN ( nil )
   end if 

   hMail          := {=>}

   for each uuidIdentifier in ::getUuidIdentifiers() 

      if ::hasMail( uuidIdentifier )

         ::generatePdf( uuidIdentifier, ::getDialogView():getComboDocument() )

         hset( hMail, "mail", ::cMail )
         hset( hMail, "subject", "Mail de prueba" )

         ::getMailSender():Send( hMail )
      
      else 
   
         msgalert( cMail, "mail vacio" )
   
      end if 

   next

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD selectHtmlFile() CLASS MailController

   ::cHtmlFile    := cGetFile( 'Html (*.html, *.htm) |*.html;*.htm|', 'Seleccione el fichero HTML', , cPatHtml() )

   if !empty( ::cHtmlFile )
      ::loadHtmlFile( ::cHtmlFile )
   end if 

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD loadDefaultHtmlFile() CLASS MailController

   local cFile    

   if empty( ::cTypeDocument )
      msgInfo( "No se ha especificado el tipo de documento." )
      RETURN ( nil )
   end if 

   cFile             := cGetHtmlDocumento( ::cTypeDocument )
   if !empty( cFile )
      ::loadHtmlFile( cFile )
   end if 

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD loadHtmlFile( cFile ) CLASS MailController

   local oBlock
   local cMensaje
   local lLoadHtmlFile  := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::cHtmlFile          := alltrim( cFile )

   if file( ::cHtmlFile )  // !Empty( ::oActiveX )

      cMensaje          := memoread( ::cHtmlFile )

      if !empty( cMensaje )
         ::getDialogView():setMensaje( cMensaje )
      end if

      lLoadHtmlFile     := .t.

   end if

   RECOVER

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lLoadHtmlFile )

//--------------------------------------------------------------------------//

METHOD setFileDefaultHtml( cFile ) CLASS MailController

   if empty( ::cTypeDocument )
      msgInfo( "No se ha especificado el tipo de documento." )
      RETURN ( Self )
   end if 

   if !Empty( ::cHtmlFile )
      if ApoloMsgNoYes( "�Desea establecer el documento " + Rtrim( ::cHtmlFile ) + " como documento por defecto?", "Confirme" )
         setHtmlDocumento( ::cTypeDocument, ::cHtmlFile )
      end if
   else
      MsgInfo( "No ha documentos para establecer por defecto" )
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD saveAsHtml() CLASS MailController

   local cHtmlFile   := cGetFile( 'Html (*.html, *.htm) |*.html;*.htm|', 'Seleccione el fichero HTML', , cPatHtml() )

   if empty( cHtmlFile )
      RETURN ( nil )
   end if 

   if !( lower( cFileExt( cHtmlFile ) ) $ "html" )
      cHtmlFile      := cFilePath( cHtmlFile ) + cFileNoExt( cHtmlFile ) + ".Html"
   endif

   if file( cHtmlFile ) .and. apoloMsgNoYes( "El fichero " + cHtmlFile + " ya existe. �Desea sobreescribir el fichero?", "Guardar fichero" )
      ferase( cHtmlFile )
   end if

   ::getDialogView():saveToFile( cHtmlFile )

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD saveHTML() CLASS MailController

   if empty( ::cHtmlFile )
      RETURN ( ::saveAsHtml() )
   end if 

   ::getDialogView():saveToFile( ::cHtmlFile )

RETURN ( nil )

//--------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS MailView FROM SQLBaseView

   DATA oRemitente
   DATA cRemitente            INIT space( 250 )

   DATA oReceptor
   DATA cReceptor             INIT space( 250 )

   DATA oCopia
   DATA cCopia                INIT space( 250 )

   DATA oCopiaOculta
   DATA cCopiaOculta          INIT space( 250 )

   DATA oAsunto
   DATA cAsunto               INIT space( 250 )

   DATA oAdjunto
   DATA cAdjunto              INIT space( 250 )

   DATA oComboDocument      
   DATA cComboDocument     

   DATA oRichEdit      
   DATA oMensaje      
   DATA cMensaje              INIT space( 250 )

   DATA oBtnCargarHTML
   DATA oBtnSalvarHTML
   DATA oBtnSalvarAsHTML
   
   DATA oBtnAceptar
   DATA oBtnCancel

   DATA oTreeProceso

   DATA oMeterProceso
   DATA nMeterProceso         INIT 0

   DATA oFld 

   METHOD Activate()

   METHOD startActivate()

   METHOD runActivate()

   METHOD getComboDocument()  INLINE ( ::cComboDocument )

   METHOD setMensaje( cMensaje ) ;
                              INLINE ( ::cMensaje := cMensaje, if( !empty( ::oRichEdit ), ::oRichEdit:oRTF:SetText( cMensaje ), ) )

   METHOD saveToFile( cFile ) ;
                              INLINE ( if( !empty( ::oRichEdit ), ::oRichEdit:saveToFile( cFile ), ) )

   METHOD loadDocuments()     INLINE ( ::getController():loadDocuments() )

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS MailView

   DEFINE DIALOG     ::oDialog ;
      RESOURCE       "SELECT_MAIL_CONTAINER" ;
      TITLE          "Enviar correo electr�nico"

   ::oFld            := TPages():Redefine( 100, ::oDialog, { "SELECT_MAIL_REDACTAR_SQL", "SELECT_MAIL_PROCESO_SQL" } )

   REDEFINE BITMAP   ;
      ID             900 ;
      RESOURCE       "gc_mail_earth_48" ;
      TRANSPARENT    ;
      OF             ::oFld:aDialogs[ 1 ]

   REDEFINE SAY      ;
      PROMPT         ::getSelectedRecords() ;
      ID             200 ;
      OF             ::oFld:aDialogs[ 1 ]

   REDEFINE GET      ::oRemitente ;
      VAR            ::cRemitente ;
      WHEN           .f. ;
      ID             100 ;
      OF             ::oFld:aDialogs[ 1 ]

   REDEFINE GET      ::oReceptor ;
      VAR            ::cReceptor ;
      ID             110 ;
      OF             ::oFld:aDialogs[ 1 ]

   REDEFINE GET      ::oCopia ;
      VAR            ::cCopia ;
      ID             120 ;
      OF             ::oFld:aDialogs[ 1 ]   

   REDEFINE GET      ::oCopiaOculta ;
      VAR            ::cCopiaOculta ;
      ID             130 ;
      OF             ::oFld:aDialogs[ 1 ]   

   REDEFINE GET      ::oAsunto ;
      VAR            ::cAsunto ;
      ID             140 ;
      OF             ::oFld:aDialogs[ 1 ]   

   REDEFINE GET      ::oAdjunto ;
      VAR            ::cAdjunto ;
      ID             150 ;
      OF             ::oFld:aDialogs[ 1 ]

   REDEFINE COMBOBOX ::oComboDocument ;
      VAR            ::cComboDocument ;
      ITEMS          ::loadDocuments() ;
      ID             160 ;
      OF             ::oFld:aDialogs[ 1 ]

   //Cargar html---------------------------------------------------------------

   REDEFINE BTNBMP ::oBtnCargarHTML ;
      ID             170 ;
      OF             ::oFld:aDialogs[ 1 ] ;
      RESOURCE       "gc_folder_open_16" ;
      NOBORDER ;
      TOOLTIP        "Cargar HTML" ;

      ::oBtnCargarHTML:bAction  := {|| ::oController:selectHtmlFile() }

   // Guardar HTML--------------------------------------------------------------
   
   REDEFINE BTNBMP ::oBtnSalvarHTML ;
      ID             180 ;
      OF             ::oFld:aDialogs[ 1 ] ;
      RESOURCE       "gc_save_16" ;
      NOBORDER ;
      TOOLTIP        "Guardar HTML" ;

      ::oBtnSalvarHTML:bAction  := {|| ::oController:saveHtml() }

   // Cargar HTML como---------------------------------------------------------

   REDEFINE BTNBMP ::oBtnSalvarAsHTML ;
      ID             190 ;
      OF             ::oFld:aDialogs[ 1 ] ;
      RESOURCE       "gc_save_as_16" ;
      NOBORDER ;
      TOOLTIP        "Guardar HTML como" ;

      ::oBtnSalvarAsHTML:bAction  := {|| ::oController:saveAsHtml() }

   // Texto enriquecido--------------------------------------------------------

   ::oRichEdit       := GetRichEdit():ReDefine( 600, ::oFld:aDialogs[ 1 ] )

   ::setMensaje( ::cMensaje )

   // P�gina de proceso--------------------------------------------------------

   REDEFINE BITMAP ;
      ID             900 ;
      RESOURCE       "gc_mail_earth_48" ;
      TRANSPARENT ;
      OF             ::oFld:aDialogs[ 2 ]

   ::oTreeProceso    := TTreeView():Redefine( 100, ::oFld:aDialogs[ 2 ] )

   REDEFINE APOLOMETER ::oMeterProceso ;
      VAR            ::nMeterProceso ;
      ID             120 ;
      OF             ::oFld:aDialogs[ 2 ]

   // Botones de accion--------------------------------------------------------

   ApoloBtnFlat():Redefine( IDOK, {|| ::runActivate() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bStart  := {|| ::startActivate() } 

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD startActivate() CLASS MailView

   ::oRemitente:cText( Company():nombre() + space( 1 ) + "<" + alltrim( Auth():email() ) + ">" )

   ::oComboDocument:Set( ::getController():getDocumentPdf() )



RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD runActivate() CLASS MailView

   ::oFld:GoNext()

   ::oController:Send()

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS MailValidator FROM SQLBaseValidator

   METHOD getValidators()

END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS MailValidator

   ::hValidators  := {  "nombre" =>       {  "required"     => "El nombre es un dato requerido",;
                                             "unique"       => "El nombre introducido ya existe" },;
                        "codigo" =>       {  "required"     => "El c�digo es un dato requerido" ,;
                                             "unique"       => "EL c�digo introducido ya existe" },;
                        "parent_uuid" =>  {  "required"     => "La tarifa base es un dato requerido" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//