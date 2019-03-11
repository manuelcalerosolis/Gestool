#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS MailController 

   DATA oController

   DATA uuidIdentifier

   DATA oDialogView

   DATA oValidator

   DATA cMail

   DATA oMailSender

   DATA oEvents

   DATA oTemplateHTML

   DATA oLogFile

   DATA cTypeDocument

   DATA cHTMLFile

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD getController()              INLINE ( ::oController )

   METHOD loadDocuments()              INLINE ( ::getController():loadDocuments() )

   METHOD getDocumentPdf()             INLINE ( ::getController():getDocumentPdf() )

   METHOD getTemplateMails()           INLINE ( ::getController():getTemplateMails() )

   METHOD getIds()                     INLINE ( iif( !empty( ::oController ), ::oController:getIds(), {} ) )

   METHOD getUuidIdentifiers()         INLINE ( hGetValues( ::oController:getIdentifiers() ) )

   // Envio de mails----------------------------------------------------------

   METHOD isMultiMails()               INLINE ( ::getTotalMails() > 1 ) 

   METHOD getTotalMails()              INLINE ( len( ::getUuidIdentifiers() ) ) 

   METHOD hasMail()                    INLINE ( !empty( ::getMail() ) )

   METHOD getMail( uuid )              INLINE ( ::getController():getRepository():getMailWhereOperacionUuid( uuid ) )

   METHOD getSelectedMail()            INLINE ( ::getMail( afirst( ::getUuidIdentifiers() ) ) )

   METHOD getMailToSend( uuid )        INLINE ( if( ::isMultiMails(), ::getMail( uuid ), ::getDialogView():getMail() ) )

   METHOD getNumero( uuid )            INLINE ( ::getController():getModel():getNumeroWhereUuid( uuid ) )
      
   METHOD getSubject( uuid )           INLINE ( ::getController():getSubject() + space( 1 ) + ::getController():getModel():getNumeroWhereUuid( uuid ) )

   METHOD getSelectedSubject()         INLINE ( ::getSubject( afirst( ::getUuidIdentifiers() ) ) )

   METHOD getSubjectToSend( uuid )     INLINE ( if( ::isMultiMails(), ::getSubject( uuid ), ::getDialogView():getAsunto() ) )

   METHOD getAttachmentsToSend()       

   METHOD Send()

   METHOD getMailHash() 

   METHOD generatePdf( uuid, cDocumentPdf ) 

   METHOD writeMessage( cText )

   METHOD setMessage( cMessage )       INLINE ( ::getDialogView():setMessage( cMessage ) )
   METHOD getMessageHTMLToSend()       INLINE ( "<HTML>" + strtran( alltrim( ::getDialogView():getMessage() ), CRLF, "<p>" ) + "</HTML>" )

   METHOD saveToFile( cFile )          INLINE ( ::getDialogView():getRichEdit():saveToFile( cFile ) )

   // Events-------------------------------------------------------------------

   METHOD setEvents( aEvents, bEvent )
   METHOD setEvent( cEvent, bEvent )   INLINE ( ::getEvents():set( cEvent, bEvent ) )
   METHOD fireEvent( cEvent, uValue )  INLINE ( ::getEvents():fire( cEvent, uValue ) )

   // Construcciones tardias---------------------------------------------------

   METHOD getLogFile()                 INLINE ( if( empty( ::oLogFile ), ::oLogFile := LogFile():New( "Mail" ), ), ::oLogFile )

   METHOD getTemplateHTML()            INLINE ( if( empty( ::oTemplateHTML ), ::oTemplateHTML := TemplateHTML():New( self ), ), ::oTemplateHTML )
   
   METHOD getDialogView()              INLINE ( if( empty( ::oDialogView ), ::oDialogView := MailView():New( self ), ), ::oDialogView )

   METHOD getValidator()               INLINE ( if( empty( ::oValidator ), ::oValidator := MailValidator():New( self ), ), ::oValidator )

   METHOD getMailSender()              INLINE ( if( empty( ::oMailSender ), ::oMailSender := MailSender():New( self ), ), ::oMailSender )

   METHOD dialogViewActivate()         INLINE ( ::getDialogView():Activate() )
   
   METHOD getEvents()                  INLINE ( if( empty( ::oEvents ), ::oEvents := Events():New(), ), ::oEvents )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS MailController

   ::oController                       := oController

   ::getMailSender():getEvents():Set( 'message', {| cText | ::writeMessage( cText ) } )

   ::getTemplateHTML():getEvents():Set( 'loadHTMLFile', {| cMessage | ::setMessage( cMessage ) } )

   ::getTemplateHTML():getEvents():Set( 'saveHTML', {| cFile | ::saveToFile( cFile ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS MailController

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if

   if !empty( ::oValidator )
      ::oValidator:End()
   end if

   if !empty( ::oMailSender )
      ::oMailSender:End()
   end if

   if !empty( ::oLogFile )
      ::oLogFile:End()
   end if

   if !empty( ::oEvents )
      ::oEvents:End()
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Send() CLASS MailController

   local uuid
   local cMail

   if empty( ::getMailSender() )
      RETURN ( nil )
   end if 

   ::getLogFile():Create()

   ::writeMessage( "Se ha iniciado el proceso de envio" ) 

   ::getEvents():fire( 'sending' )

   for each uuid in ::getUuidIdentifiers() 

      ::uuidIdentifier := uuid

      ::generatePdf( uuid )

      if ::getMailSender():Send( ::getMailHash( uuid ) ) 

         ::fireEvent( 'sendsuccess', self )

      else 

         ::fireEvent( 'senderror', self )

      end if 

      sysRefresh()

   next

   ::getEvents():fire( 'sendexit' )

   ::writeMessage( "Ha finalizado el proceso de envio" ) 

   ::getLogFile():Close()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getMailHash( uuidIdentifier ) CLASS MailController
   
   local hMail    := {=>}
   
   hset( hMail,   "mail",        ::getMailToSend( uuidIdentifier ) )
   hset( hMail,   "subject",     ::getSubjectToSend( uuidIdentifier ) )
   hset( hMail,   "attachments", ::getAttachmentsToSend() )
   hSet( hMail,   "mailcc",      ::getDialogView():getCopia() )
   hSet( hMail,   "mailcco",     ::getDialogView():getCopiaOculta() )
   hSet( hMail,   "message",     ::getMessageHTMLToSend() )
 
RETURN ( hMail )

//---------------------------------------------------------------------------//

METHOD getAttachmentsToSend()

   local cAttachments   := ::getController():getReport():getFullPathPdfFileName()

   if !empty( ::getDialogView():getAdjunto() )
      cAttachments      += "; "
      cAttachments      += ::getDialogView():getAdjunto()
   end if 

RETURN ( cAttachments )

//---------------------------------------------------------------------------//

METHOD generatePdf( uuid ) CLASS MailController

   local hReport  := {=>}

   hset( hReport, "uuid",                 uuid )
   hset( hReport, "device",               IS_PDF )
   hset( hReport, "fileName",             ::getDialogView():getDocument() )
   hset( hReport, "pdfFileName",          ::getController():getModel():getNumeroWhereUuid( uuid ) )
   hset( hReport, "pdfDefaultPath",       cPatTmp() )
   hset( hReport, "pdfOpenAfterExport",   .f. )

RETURN ( ::getController():getReport():Generate( hReport ) )

//---------------------------------------------------------------------------//

METHOD writeMessage( cText )

   ::getLogFile():Write( cText )

   with object ( ::getDialogView():oTreeProceso )
      :Select( :Add( cText ) )
   end with

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setEvents( aEvents, bEvent )

RETURN ( aeval( aEvents, {|cEvent| ::setEvent( cEvent, bEvent ) } ) )

//----------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS MailView FROM SQLBaseView

   DATA oRemitente
   DATA cRemitente               INIT space( 250 )

   DATA oMail
   DATA cMail                    INIT space( 250 )

   DATA oCopia
   DATA cCopia                   INIT space( 250 )

   DATA oCopiaOculta
   DATA cCopiaOculta             INIT space( 250 )

   DATA oAsunto
   DATA cAsunto                  INIT space( 250 )

   DATA oAdjunto
   DATA cAdjunto                 INIT space( 250 )

   DATA oDocument      
   DATA cDocument     

   DATA oRichEdit      
   DATA oMessage      
   DATA cMessage                 INIT ""

   DATA oBtnCargarHTML
   DATA oBtnSalvarHTML
   DATA oBtnSalvarAsHTML
   
   DATA oBtnAceptar
   DATA oBtnCancel

   DATA oTreeProceso

   DATA oMeterProceso
   DATA nMeterProceso            INIT 0

   DATA oFld 

   METHOD New( oController ) CONSTRUCTOR

   METHOD Activate()

   METHOD startActivate()

   METHOD runActivate()

   METHOD setMail( cMail )       INLINE ( ::oMail:cText( padr( cMail, 250 ) ) )
   METHOD getMail()              INLINE ( alltrim( ::cMail ) )

   METHOD setCopia( cCopia )     INLINE ( ::oCopia:cText( padr( cCopia, 250 ) ) )
   METHOD getCopia()             INLINE ( alltrim( ::cCopia ) )

   METHOD setCopiaOculta( cCopiaOculta ) ;
                                 INLINE ( ::oCopiaOculta:cText( padr( cCopiaOculta, 250 ) ) )
   METHOD getCopiaOculta()       INLINE ( alltrim( ::cCopiaOculta ) )

   METHOD setAsunto( cAsunto )   INLINE ( ::oAsunto:cText( padr( cAsunto, 250 ) ) )
   METHOD getAsunto()            INLINE ( alltrim( ::cAsunto ) )

   METHOD setAdjunto( cAdjunto ) INLINE ( ::oAdjunto:cText( padr( cAdjunto, 250 ) ) )
   METHOD getAdjunto()           INLINE ( alltrim( ::cAdjunto ) )
   METHOD addAjunto() 

   METHOD getDocument()          INLINE ( ::cDocument )

   METHOD getMeterProceso()      INLINE ( ::oMeterProceso )

   METHOD setMessage( cMessage ) INLINE ( ::cMessage := cMessage, if( !empty( ::oRichEdit ), ::oRichEdit:oRTF:SetText( cMessage ), ) )
   METHOD getMessage()           INLINE ( ::oRichEdit:getText() )

   METHOD loadDocuments()        INLINE ( ::getController():loadDocuments() )

   METHOD getRichEdit()          INLINE ( ::oRichEdit )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::Super:New( oController )

   ::getController():getEvents():set( 'sending', {|| ::getMeterProceso():setTotal( ::getController():getTotalMails() ) } )

   ::getController():getEvents():set( 'send', {|| ::getMeterProceso():autoInc() } )

RETURN ( self )

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

   REDEFINE COMBOBOX ::oDocument ;
      VAR            ::cDocument ;
      ITEMS          ::loadDocuments() ;
      ID             160 ;
      OF             ::oFld:aDialogs[ 1 ]

   //Cargar HTML---------------------------------------------------------------

   REDEFINE BTNBMP ::oBtnCargarHTML ;
      ID             170 ;
      OF             ::oFld:aDialogs[ 1 ] ;
      RESOURCE       "gc_folder_open_16" ;
      NOBORDER ;
      TOOLTIP        "Cargar HTML" ;

      ::oBtnCargarHTML:bAction  := {|| ::getController():getTemplateHTML():selectHTMLFile() }

   // Guardar HTML--------------------------------------------------------------
   
   REDEFINE BTNBMP ::oBtnSalvarHTML ;
      ID             180 ;
      OF             ::oFld:aDialogs[ 1 ] ;
      RESOURCE       "gc_save_16" ;
      NOBORDER ;
      TOOLTIP        "Guardar HTML" ;

      ::oBtnSalvarHTML:bAction  := {|| ::getController():getTemplateHTML():saveHTML() }

   // Cargar HTML como---------------------------------------------------------

   REDEFINE BTNBMP ::oBtnSalvarAsHTML ;
      ID             190 ;
      OF             ::oFld:aDialogs[ 1 ] ;
      RESOURCE       "gc_save_as_16" ;
      NOBORDER ;
      TOOLTIP        "Guardar HTML como" ;

      ::oBtnSalvarAsHTML:bAction  := {|| ::getController():getTemplateHTML():saveAsHTML() }

   // Texto enriquecido--------------------------------------------------------

   ::oRichEdit       := GetRichEdit():ReDefine( 600, ::oFld:aDialogs[ 1 ] )

   ::setMessage( ::cMessage )

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

   ::oBtnAceptar     := ApoloBtnFlat():Redefine( IDOK, {|| ::runActivate() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ::oBtnCancel      := ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

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

   ::setCopia( Auth():enviarEmailCopia() )

   ::setCopiaOculta( Auth():enviarCopiaOculta() )

   if ::getController():isMultiMails()
      ::oAsunto:Disable()
      ::setAsunto( "< multiples asuntos >" )
   else 
      ::oAsunto:Enable()
      ::setAsunto( ::getController():getSelectedSubject() )
   end if 

   ::setAdjunto( "" )

   ::oDocument:Set( ::getController():getDocumentPdf() )

   ::getController():getTemplateHTML():loadHtmlFile( ::getController():getTemplateMails() )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD runActivate() CLASS MailView

   ::oBtnAceptar:Hide()

   ::oFld:GoNext()

   ::getController():Send()

   ::oBtnAceptar:bAction   := {|| ::getController():getLogFile():Show() }

   ::oBtnAceptar:setCaption( "Ver log" )

   ::oBtnAceptar:setColor( CLR_BLACK, CLR_WHITE )

   ::oBtnAceptar:Show()

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