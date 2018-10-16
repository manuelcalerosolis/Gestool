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

   METHOD isMultiMails()               INLINE ( len( ::getUuidIdentifiers() ) > 1 ) 

   METHOD hasMail()                    INLINE ( !empty( ::getMail() ) )

   METHOD getMail( uuid )              INLINE ( ::getController():getRepository():getClientMailWhereFacturaUuid( uuid ) )

   METHOD getSelectedMail()            INLINE ( ::getMail( afirst( ::getUuidIdentifiers() ) ) )

   METHOD getMailToSend( uuid )        INLINE ( if( ::isMultiMails(), ::getMail( uuid ), ::getDialogView():getMail() ) )

   METHOD getNumero( uuid )            INLINE ( ::getController():getModel():getNumeroWhereUuid( uuid ) )
      
   METHOD getSubject( uuid )           INLINE ( ::getController():getSubject() + space( 1 ) + ::getController():getModel():getNumeroWhereUuid( uuid ) )

   METHOD getSelectedSubject()         INLINE ( ::getSubject( afirst( ::getUuidIdentifiers() ) ) )

   METHOD getSubjectToSend( uuid )     INLINE ( if( ::isMultiMails(), ::getSubject( uuid ), ::getDialogView():getAsunto() ) )

   METHOD getAttachmentsToSend()       

   METHOD Send()

   METHOD generatePdf( uuid, cDocumentPdf ) 

   // Construcciones tardias---------------------------------------------------

   METHOD getDialogView()              INLINE ( if( empty( ::oDialogView ), ::oDialogView := MailView():New( self ), ), ::oDialogView )

   METHOD getValidator()               INLINE ( if( empty( ::oValidator ), ::oValidator := MailValidator():New( self ), ), ::oValidator )

   METHOD getMailSender()              INLINE ( if( empty( ::oMailSender ), ::oMailSender := MailSender():New( self ), ), ::oMailSender )

   METHOD dialogViewActivate()         INLINE ( ::getDialogView():Activate() )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS MailController

   ::oController                       := oController

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

METHOD Send()

   local hMail
   local cMail
   local uuidIdentifier

   if empty( ::getMailSender() )
      RETURN ( nil )
   end if 

   hMail          := {=>}

   for each uuidIdentifier in ::getUuidIdentifiers() 

      ::generatePdf( uuidIdentifier, ::getDialogView():getComboDocument() )

      hset( hMail, "mail",          ::getMailToSend( uuidIdentifier ) )
      hset( hMail, "subject",       ::getSubjectToSend( uuidIdentifier ) )
      hset( hMail, "attachments",   ::getAttachmentsToSend() )
      hSet( hMail, "mailcc",        ::getDialogView():getCopia() )
      hSet( hMail, "mailcco",       ::getDialogView():getCopiaOculta() )
      
      /*
      hSet( hashDatabaseList, "message", ::getMessageHTML() )
      hSet( hashDatabaseList, "postSend", ::getPostSend() )
      hSet( hashDatabaseList, "postError", ::getPostError() )
      hSet( hashDatabaseList, "cargo", ::getCargo() )
      */

      sysRefresh()

      ::getMailSender():Send( hMail )
      
   next

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getAttachmentsToSend()

   local cAttachments   := ::getController():getReport():getFullPathPdfFileName()

   if !empty( ::getDialogView():getAdjunto() )
      cAttachments      += "; "
      cAttachments      += ::getDialogView():getAdjunto()
   end if 

RETURN ( cAttachments )

//---------------------------------------------------------------------------//

METHOD generatePdf( uuid, cDocumentPdf ) CLASS MailController

   local hReport  := {=>}

   hset( hReport, "uuid",                 uuid )
   hset( hReport, "device",               IS_PDF )
   hset( hReport, "fileName",             cDocumentPdf )
   hset( hReport, "pdfFileName",          ::getController():getModel():getNumeroWhereUuid( uuid ) )
   hset( hReport, "pdfDefaultPath",       cPatTmp() )
   hset( hReport, "pdfOpenAfterExport",   .t. )

RETURN ( ::getController():getReport():Generate( hReport ) )

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

   if file( ::cHtmlFile )  

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
      if ApoloMsgNoYes( "¿Desea establecer el documento " + Rtrim( ::cHtmlFile ) + " como documento por defecto?", "Confirme" )
         setHtmlDocumento( ::cTypeDocument, ::cHtmlFile )
      end if
   else
      msgInfo( "No ha documentos para establecer por defecto" )
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

   if file( cHtmlFile ) .and. apoloMsgNoYes( "El fichero " + cHtmlFile + " ya existe. ¿Desea sobreescribir el fichero?", "Guardar fichero" )
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

   DATA oMail
   DATA cMail                 INIT space( 250 )

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
   DATA nMeterProceso            INIT 0

   DATA oFld 

   METHOD Activate()

   METHOD startActivate()

   METHOD runActivate()

   METHOD setMail( cMail )       INLINE ( ::oMail:cText( padr( cMail, 250 ) ) )
   METHOD getMail()              INLINE ( alltrim( ::cMail ) )

   METHOD setCopia( cCopia )     INLINE ( ::oCopia:cText( padr( cCopia, 250 ) ) )
   METHOD getCopia()             INLINE ( alltrim( ::cCopia ) )

   METHOD setCopiaOculta( cCopiaOculta ) INLINE ( ::oCopiaOculta:cText( padr( cCopiaOculta, 250 ) ) )
   METHOD getCopiaOculta()       INLINE ( alltrim( ::cCopiaOculta ) )

   METHOD setAsunto( cAsunto )   INLINE ( ::oAsunto:cText( padr( cAsunto, 250 ) ) )
   METHOD getAsunto()            INLINE ( alltrim( ::cAsunto ) )

   METHOD setAdjunto( cAdjunto ) INLINE ( ::oAdjunto:cText( padr( cAdjunto, 250 ) ) )
   METHOD getAdjunto()           INLINE ( alltrim( ::cAdjunto ) )
   METHOD addAjunto() 

   METHOD getComboDocument()     INLINE ( ::cComboDocument )

   METHOD setMensaje( cMensaje ) INLINE ( ::cMensaje := cMensaje, if( !empty( ::oRichEdit ), ::oRichEdit:oRTF:SetText( cMensaje ), ) )

   METHOD saveToFile( cFile )    INLINE ( if( !empty( ::oRichEdit ), ::oRichEdit:saveToFile( cFile ), ) )

   METHOD loadDocuments()        INLINE ( ::getController():loadDocuments() )

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS MailView

   DEFINE DIALOG     ::oDialog ;
      RESOURCE       "SELECT_MAIL_CONTAINER" ;
      TITLE          "Enviar correo electrónico"

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

   REDEFINE GET      ::oMail ;
      VAR            ::cMail ;
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

   ::oAdjunto:cBmp   := "Folder"
   ::oAdjunto:bHelp  := {|| ::addAjunto() }

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

   // Página de proceso--------------------------------------------------------

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

   if ::getController():isMultiMails()
      ::oMail:Disable()
      ::setMail( "< multiples receptores >" )
   else 
      ::oMail:Enable()
      ::setMail( ::getController():getSelectedMail() )
   end if 

   ::oCopia:cText( Auth():enviarEmailCopia() )

   ::oCopiaOculta:cText( Auth():enviarCopiaOculta() )

   if ::getController():isMultiMails()
      ::oAsunto:Disable()
      ::setAsunto( "< multiples asuntos >" )
   else 
      ::oAsunto:Enable()
      ::setAsunto( ::getController():getSelectedSubject() )
   end if 

   ::oComboDocument:Set( ::getController():getDocumentPdf() )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD runActivate() CLASS MailView

   ::oFld:GoNext()

   ::getController():Send()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addAjunto() CLASS MailView

   local cFile    := cGetFile( 'Fichero ( *.* ) | *.*', 'Seleccione el fichero a adjuntar' )

   if !empty( cFile )
      ::oAdjunto:cText( alltrim( ::cAdjunto ) + cFile + "; " )
   end if 

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
                        "codigo" =>       {  "required"     => "El código es un dato requerido" ,;
                                             "unique"       => "EL código introducido ya existe" },;
                        "parent_uuid" =>  {  "required"     => "La tarifa base es un dato requerido" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//