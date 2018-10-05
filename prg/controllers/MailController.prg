#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS MailController FROM SQLNavigatorController

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

   // Construcciones tardias---------------------------------------------------

   METHOD getDialogView()              INLINE ( if( empty( ::oDialogView ), ::oDialogView := MailView():New( self ), ), ::oDialogView )

   METHOD getValidator()               INLINE ( if( empty( ::oValidator ), ::oValidator := MailValidator():New( self ), ), ::oValidator )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS MailController

   ::Super:New( oController )

   ::cTitle                         := "Mail"

   ::cName                          := "mail"

   ::hImage                         := {  "16" => "gc_mail_earth_16",;
                                          "32" => "gc_mail_earth_32",;
                                          "48" => "gc_mail_earth_48" }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS MailController

   if !empty(::oDialogView)
      ::oDialogView:End()
   end if

   if !empty(::oValidator)
      ::oValidator:End()
   end if

   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD selectHtmlFile() CLASS MailController

   ::cHtmlFile    := cGetFile( 'Html (*.html, *.htm) |*.html;*.htm|', 'Seleccione el fichero HTML', , cPatHtml() )

   if !empty( ::cHtmlFile )
      ::loadHtmlFile( ::cHtmlFile )
   end if 

Return ( Self )

//--------------------------------------------------------------------------//

METHOD loadDefaultHtmlFile() CLASS MailController

   local cFile    

   if empty( ::cTypeDocument )
      msgInfo( "No se ha especificado el tipo de documento." )
      Return ( Self )
   end if 

   cFile             := cGetHtmlDocumento( ::cTypeDocument )
   if !empty( cFile )
      ::loadHtmlFile( cFile )
   end if 

Return ( Self )

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

Return ( lLoadHtmlFile )

//--------------------------------------------------------------------------//

METHOD setFileDefaultHtml( cFile ) CLASS MailController

   if empty( ::cTypeDocument )
      msgInfo( "No se ha especificado el tipo de documento." )
      Return ( Self )
   end if 

   if !Empty( ::cHtmlFile )
      if ApoloMsgNoYes( "¿Desea establecer el documento " + Rtrim( ::cHtmlFile ) + " como documento por defecto?", "Confirme" )
         setHtmlDocumento( ::cTypeDocument, ::cHtmlFile )
      end if
   else
      MsgInfo( "No ha documentos para establecer por defecto" )
   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD saveAsHtml() CLASS MailController

   local cHtmlFile   := cGetFile( 'Html (*.html, *.htm) |*.html;*.htm|', 'Seleccione el fichero HTML', , cPatHtml() )

   if empty( cHtmlFile )
      Return ( Self )
   end if 

   if !( lower( cFileExt( cHtmlFile ) ) $ "html" )
      cHtmlFile      := cFilePath( cHtmlFile ) + cFileNoExt( cHtmlFile ) + ".Html"
   endif

   if file( cHtmlFile ) .and. apoloMsgNoYes( "El fichero " + cHtmlFile + " ya existe. ¿Desea sobreescribir el fichero?", "Guardar fichero" )
      ferase( cHtmlFile )
   end if

   ::getDialogView():SaveToFile( cHtmlFile )

Return ( Self )

//--------------------------------------------------------------------------//

METHOD saveHTML() CLASS MailController

   if empty( ::cHtmlFile )
      Return ( ::saveAsHtml() )
   end if 

   ::getDialogView():SaveToFile( ::cHtmlFile )

Return ( Self )

//--------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS MailView FROM SQLBaseView

   DATA oRemitente
   DATA cRemitente         INIT space( 250 )

   DATA oReceptor
   DATA cReceptor          INIT space( 250 )

   DATA oCopia
   DATA cCopia             INIT space( 250 )

   DATA oCopiaOculta
   DATA cCopiaOculta       INIT space( 250 )

   DATA oAsunto
   DATA cAsunto            INIT space( 250 )

   DATA oAdjunto
   DATA cAdjunto           INIT space( 250 )

   DATA oComboFormato      
   DATA cComboFormato      INIT space( 250 )   

   DATA oRichEdit      
   DATA oMensaje      
   DATA cMensaje           INIT space( 250 )

   DATA oBtnCargarHTML
   DATA oBtnSalvarHTML
   DATA oBtnSalvarAsHTML

   DATA oFld 

   DATA aPages             INIT { "Select_Mail_Redactar_sql" }

   METHOD Activate()

   METHOD setMensaje( cMensaje ) ;
                           INLINE ( ::cMensaje := cMensaje, if( !empty( ::oRichEdit ), ::oRichEdit:oRTF:SetText( cMensaje ), ) )

   METHOD saveToFile( cFile ) ;
                           INLINE ( if( !empty( ::oRichEdit ), ::oRichEdit:saveToFile( cFile ), ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS mailView

   DEFINE DIALOG     ::oDialog ;
      RESOURCE       "SELECT_MAIL_CONTAINER" ;
      TITLE          ::LblTitle() + "enviar mail"

   ::oFld            := TPages():Redefine( 10, ::oDialog, ::aPages )

   REDEFINE BITMAP   ::oBitmap ;
      ID             900 ;
      RESOURCE       ::oController:getimage( "48" ) ;
      TRANSPARENT ;
      OF             ::oFld:aDialogs[ 1 ]

   REDEFINE GET      ::oRemitente ;
      VAR            ::cRemitente ;
      ID             100 ;
      WHEN           ( ::oController:isAppendOrDuplicateMode() ) ;
      OF             ::oFld:aDialogs[ 1 ]

   REDEFINE GET      ::oReceptor ;
      VAR            ::cReceptor ;
      ID             110 ;
      WHEN           ( ::oController:isAppendOrDuplicateMode() ) ;
      OF             ::oFld:aDialogs[ 1 ]

   REDEFINE GET      ::oCopia ;
      VAR            ::cCopia ;
      ID             120 ;
      WHEN           ( ::oController:isAppendOrDuplicateMode() ) ;
      OF             ::oFld:aDialogs[ 1 ]   

   REDEFINE GET      ::oCopiaOculta ;
      VAR            ::cCopiaOculta ;
      ID             130 ;
      WHEN           ( ::oController:isAppendOrDuplicateMode() ) ;
      OF             ::oFld:aDialogs[ 1 ]   

   REDEFINE GET      ::oAsunto ;
      VAR            ::cAsunto ;
      ID             140 ;
      WHEN           ( ::oController:isAppendOrDuplicateMode() ) ;
      OF             ::oFld:aDialogs[ 1 ]   

   REDEFINE GET      ::oAdjunto ;
      VAR            ::cAdjunto ;
      ID             150 ;
      WHEN           ( ::oController:isAppendOrDuplicateMode() ) ;
      OF             ::oFld:aDialogs[ 1 ]

   REDEFINE COMBOBOX ::oComboFormato ;
      VAR            ::cComboFormato ;
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

   //Guardar HTML---------------------------------------------------------------
   
   REDEFINE BTNBMP ::oBtnSalvarHTML ;
      ID             180 ;
      OF             ::oFld:aDialogs[ 1 ] ;
      RESOURCE       "gc_save_16" ;
      NOBORDER ;
      TOOLTIP        "Guardar HTML" ;

      ::oBtnSalvarHTML:bAction  := {|| ::oController:saveHtml() }

   //Cargar HTML como----------------------------------------------------------
   REDEFINE BTNBMP ::oBtnSalvarAsHTML ;
      ID             190 ;
      OF             ::oFld:aDialogs[ 1 ] ;
      RESOURCE       "gc_save_as_16" ;
      NOBORDER ;
      TOOLTIP        "Guardar HTML como" ;

      ::oBtnSalvarAsHTML:bAction  := {|| ::oController:saveAsHtml() }

   //Texto enriquecido------------------------------------------------------------

   ::oRichEdit       := GetRichEdit():ReDefine( 600, ::oFld:aDialogs[ 1 ] )

   ::setMensaje( ::cMensaje )

   ACTIVATE DIALOG ::oDialog CENTER

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
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
                                             "unique"       => "El nombre introducido ya existe",;
                                             "notNameCosto" => "El nombre de la tarifa no puede ser '" + __tarifa_costo__ + "'" },;
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