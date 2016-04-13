#include "HbXml.ch"
#include "TDbfDbf.ch"
#include "FiveWin.Ch"
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch"
#include "Report.ch"
#include "Print.ch"

#define __localDirectory            "c:\Bestseller\"
#define __localDirectoryPorcessed   "c:\Bestseller\Processed\"

//----------------------------------------------------------------------------//
  
CLASS BestsellerFtp

   DATA  cFtpSite
   DATA  cUserName
   DATA  cPassword
   DATA  cUrl
   DATA  lPassive
   DATA  cLocalDirectory
   DATA  cLocalDirectoryProcessed
   DATA  cDirectory

   DATA  lConnect
   DATA  oFtp
   DATA  oInt

   DATA  oAlbPrvT

   Method New()
   METHOD Run()
   METHOD ftpConexion()
   METHOD closeConexion()

   METHOD ftpGetFiles()
   
   METHOD fileNotProccess( cFile )
   METHOD fileDownload( cFile )

END CLASS

//----------------------------------------------------------------------------//

METHOD New()

   ::cFtpSite                 := "ftp.gestool.es"
   ::cUserName                := "bestseller"
   ::cPassword                := "123Zx456"
   ::cUrl                     := "ftp://" + ::cUserName + ":" + ::cPassword + "@" + ::cFtpSite
   ::lPassive                 := .t.
   ::cLocalDirectory          := __localDirectory
   ::cLocalDirectoryProcessed := __localDirectoryPorcessed

   msgRun( "Conectando con el sito " + ::cUrl, "Espere por favor...", {|| ::Run() } )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Run()

   if ::ftpConexion()
      ::ftpGetFiles()
      ::closeConexion()
   else 
      msgInfo( "Error al conectar" )
   end if 

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD ftpConexion()

   ::oFTP               := TFTPCurl():New( ::cUserName, ::cPassword, ::cFtpSite )

   if ::oFTP:createConexion()

      ::lConnect        := .t.

   else

      msgStop( "Imposible conectar con el sitio ftp " + ::cFtpSite, "Error" )
      
      ::lConnect        := .f.

   end if

Return ( ::lConnect )

//---------------------------------------------------------------------------//

METHOD closeConexion() 

   if !empty( ::oFtp )
      ::oFtp            := nil
   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD ftpGetFiles()

   local cFile
   local aFiles            := ::oFTP:listFiles()  

   for each cFile in aFiles 

      if lower( cfileext( cFile ) ) == "xml"

         if ::fileNotProccess( cFile )
            ::fileDownload( cFile )
         end if 

      end if 

   next

Return ( Self )

//---------------------------------------------------------------------------//

METHOD fileNotProccess( cFile )

   local fileNotProccess   := file( ::cLocalDirectoryProcessed + cFile ) .or. file( ::cLocalDirectory + cFile )

Return ( !fileNotProccess )

//---------------------------------------------------------------------------//

METHOD fileDownload( cFile )

   msgRun( "Descargando fichero " + cFile, "Espere por favor...", {|| ::oFtp:downLoadFile( cFile, ::cLocalDirectory + cFile ) } ) // "httpdocs/edi/" +  

RETURN ( Self )

//---------------------------------------------------------------------------//


