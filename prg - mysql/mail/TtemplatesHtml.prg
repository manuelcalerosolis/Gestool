#include "FiveWin.Ch"
#include "Factu.ch" 

//----------------------------------------------------------------------------//

CLASS TTemplatesHtml
   
   DATA oSender 

   DATA cTypeDocument

   DATA cHtmlFile

   METHOD New( oSender )

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

METHOD New( oSender ) CLASS TTemplatesHtml

   ::oSender      := oSender

RETURN (  Self )   

//---------------------------------------------------------------------------//

METHOD selectHtmlFile() CLASS TTemplatesHtml

   ::cHtmlFile    := cGetFile( 'Html (*.html, *.htm) |*.html;*.htm|', 'Seleccione el fichero HTML', , cPatHtml() )

   if !empty( ::cHtmlFile )
      ::loadHtmlFile( ::cHtmlFile )
   end if 

Return ( Self )

//--------------------------------------------------------------------------//

METHOD loadDefaultHtmlFile() CLASS TTemplatesHtml

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

METHOD loadHtmlFile( cFile ) CLASS TTemplatesHtml

   local oBlock
   local cMensaje
   local lLoadHtmlFile  := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::cHtmlFile          := alltrim( cFile )

   if file( ::cHtmlFile )  // !Empty( ::oActiveX )

      cMensaje          := memoread( ::cHtmlFile )

      if !empty( cMensaje )
         ::oSender:setMensaje( cMensaje )
      end if

      lLoadHtmlFile     := .t.

   end if

   RECOVER

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lLoadHtmlFile )

//--------------------------------------------------------------------------//

METHOD setFileDefaultHtml( cFile ) CLASS TTemplatesHtml

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

METHOD saveAsHtml() CLASS TTemplatesHtml

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

   ::oSender:SaveToFile( cHtmlFile )

Return ( Self )

//--------------------------------------------------------------------------//

METHOD saveHTML() CLASS TTemplatesHtml

   if empty( ::cHtmlFile )
      Return ( ::saveAsHtml() )
   end if 

   ::oSender:SaveToFile( ::cHtmlFile )

Return ( Self )

//--------------------------------------------------------------------------//

