#include "FiveWin.Ch"
#include "Factu.ch" 

//----------------------------------------------------------------------------//

CLASS TemplateHtml
   
   DATA oController 

   DATA cTypeDocument

   DATA cHtmlFile

   METHOD New( oController )

   METHOD selectHtmlFile()
   METHOD loadDefaultHtmlFile()
   METHOD loadHtmlFile( cFile ) 
   METHOD setFileDefaultHtml( cFile )   

   METHOD saveHTML()
   METHOD saveAsHtml()

   METHOD setTypeDocument( cTypeDocument );
                                       INLINE ( ::cTypeDocument := cTypeDocument, ::loadDefaultHtmlFile() )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS TemplateHtml

   ::oController     := oController

RETURN ( self )   

//---------------------------------------------------------------------------//

METHOD selectHtmlFile() CLASS TemplateHtml

   ::cHtmlFile       := cGetFile( 'Html (*.html, *.htm) |*.html;*.htm|', 'Seleccione el fichero HTML', , cPatHtml() )

   if !empty( ::cHtmlFile )
      ::loadHtmlFile( ::cHtmlFile )
   end if 

Return ( nil )

//--------------------------------------------------------------------------//

METHOD loadDefaultHtmlFile() CLASS TemplateHtml

   local cFile    

   if empty( ::cTypeDocument )
      msgInfo( "No se ha especificado el tipo de documento." )
      Return ( nil )
   end if 

   cFile             := cGetHtmlDocumento( ::cTypeDocument )
   if !empty( cFile )
      ::loadHtmlFile( cFile )
   end if 

Return ( nil )

//--------------------------------------------------------------------------//

METHOD loadHtmlFile( cFile ) CLASS TemplateHtml

   local oBlock
   local cMensaje
   local lLoadHtmlFile  := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::cHtmlFile          := alltrim( cFile )

   if file( ::cHtmlFile )  // !Empty( ::oActiveX )

      cMensaje          := memoread( ::cHtmlFile )

      if !empty( cMensaje )
         ::oController:setMensaje( cMensaje )
      end if

      lLoadHtmlFile     := .t.

   end if

   RECOVER

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lLoadHtmlFile )

//--------------------------------------------------------------------------//

METHOD setFileDefaultHtml( cFile ) CLASS TemplateHtml

   if empty( ::cTypeDocument )
      msgInfo( "No se ha especificado el tipo de documento." )
      Return ( nil )
   end if 

   if !Empty( ::cHtmlFile )
      if ApoloMsgNoYes( "¿Desea establecer el documento " + Rtrim( ::cHtmlFile ) + " como documento por defecto?", "Confirme" )
         setHtmlDocumento( ::cTypeDocument, ::cHtmlFile )
      end if
   else
      MsgInfo( "No ha documentos para establecer por defecto" )
   end if

Return ( nil )

//---------------------------------------------------------------------------//

METHOD saveAsHtml() CLASS TemplateHtml

   local cHtmlFile   := cGetFile( 'Html (*.html, *.htm) |*.html;*.htm|', 'Seleccione el fichero HTML', , cPatHtml() )

   if empty( cHtmlFile )
      Return ( nil )
   end if 

   if !( lower( cFileExt( cHtmlFile ) ) $ "html" )
      cHtmlFile      := cFilePath( cHtmlFile ) + cFileNoExt( cHtmlFile ) + ".Html"
   endif

   if file( cHtmlFile ) .and. apoloMsgNoYes( "El fichero " + cHtmlFile + " ya existe. ¿Desea sobreescribir el fichero?", "Guardar fichero" )
      ferase( cHtmlFile )
   end if

   ::oController:SaveToFile( cHtmlFile )

Return ( nil )

//--------------------------------------------------------------------------//

METHOD saveHTML() CLASS TemplateHtml

   if empty( ::cHtmlFile )
      Return ( ::saveAsHtml() )
   end if 

   ::oController:SaveToFile( ::cHtmlFile )

Return ( nil )

//--------------------------------------------------------------------------//

