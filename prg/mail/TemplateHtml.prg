#include "FiveWin.Ch"
#include "Factu.ch" 

//----------------------------------------------------------------------------//

CLASS TemplateHtml
   
   DATA oController 

   DATA cTypeDocument

   DATA cHtmlFile

   DATA oEvents

   METHOD New( oController )
   METHOD End()

   METHOD getController()              INLINE ( ::oController )

   METHOD selectHtmlFile()
   METHOD loadDefaultHtmlFile()
   METHOD loadHtmlFile( cFile ) 
   METHOD setFileDefaultHtml( cFile )   

   METHOD saveHTML()
   METHOD saveAsHTML()

   METHOD setTypeDocument( cTypeDocument );
                                       INLINE ( ::cTypeDocument := cTypeDocument, ::loadDefaultHtmlFile() )

   // Contrucciones tardias----------------------------------------------------

   METHOD getEvents()                  INLINE ( if( empty( ::oEvents ), ::oEvents := Events():New(), ), ::oEvents )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS TemplateHtml

   ::oController     := oController

RETURN ( self )   

//---------------------------------------------------------------------------//

METHOD End( oController ) CLASS TemplateHtml

   if !empty(::oEvents)
      ::oEvents:End()
   end if 

RETURN ( nil )   

//---------------------------------------------------------------------------//

METHOD selectHtmlFile() CLASS TemplateHtml

   ::cHtmlFile       := cGetFile( 'Html (*.html, *.htm) |*.html;*.htm|', 'Seleccione el fichero HTML', , cPatHtml() )

   if !empty( ::cHtmlFile )
      ::loadHtmlFile( ::cHtmlFile )
   end if 

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD loadDefaultHtmlFile() CLASS TemplateHtml

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

METHOD loadHtmlFile( cFile ) CLASS TemplateHtml

   local oBlock
   local oError
   local cMensaje
   local lLoadHtmlFile  := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::cHtmlFile          := alltrim( cFile )

   if file( ::cHtmlFile )  

      cMensaje          := memoread( ::cHtmlFile )

      ::oEvents:fire( 'loadHtmlFile', cMensaje )

      lLoadHtmlFile     := .t.

   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError )  )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lLoadHtmlFile )

//--------------------------------------------------------------------------//

METHOD setFileDefaultHtml( cFile ) CLASS TemplateHtml

   if empty( ::cTypeDocument )
      msgInfo( "No se ha especificado el tipo de documento." )
      RETURN ( nil )
   end if 

   if !Empty( ::cHtmlFile )
      if ApoloMsgNoYes( "¿Desea establecer el documento " + Rtrim( ::cHtmlFile ) + " como documento por defecto?", "Confirme" )
         setHtmlDocumento( ::cTypeDocument, ::cHtmlFile )
      end if
   else
      MsgInfo( "No ha documentos para establecer por defecto" )
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD saveAsHtml() CLASS TemplateHtml

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

   ::oEvents:fire( 'saveHTML', ::cHtmlFile )

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD saveHTML() CLASS TemplateHtml

   if empty( ::cHtmlFile )
      RETURN ( ::saveAsHtml() )
   end if 

   ::oEvents:fire( 'saveHTML', ::cHtmlFile )

RETURN ( nil )

//--------------------------------------------------------------------------//

