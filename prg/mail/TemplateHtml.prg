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

   if empty( ::cTypeDocument )
      msgInfo( "No se ha especificado el tipo de documento." )
      RETURN ( nil )
   end if 

RETURN ( ::selectHtmlFile() )

//--------------------------------------------------------------------------//

METHOD loadHtmlFile( cFile ) CLASS TemplateHtml

   local lLoad          := .f.

   ::cHtmlFile          := alltrim( cFile )

   if !file( cFile )
      ::cHtmlFile       := cPatHtml() + ::cHtmlFile
   end if 

   if !file( ::cHtmlFile )  
      RETURN ( lLoad )
   end if 

   try

      ::oEvents:fire( 'loadHtmlFile', memoread( ::cHtmlFile ) )

      lLoad             := .t.

   catch 

      msgStop( "Error al cargar el documento " + ::cHtmlFile )

   end 

RETURN ( lLoad )

//--------------------------------------------------------------------------//

METHOD setFileDefaultHtml( cFile ) CLASS TemplateHtml

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

