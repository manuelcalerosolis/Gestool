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
   METHOD fileDocument( cFile )

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

   ::oInt               := TUrl():New( ::cUrl )
   ::oFTP               := TIPClientFTP():New( ::oInt, .t. )
   ::oFTP:nConnTimeout  := 2000
   ::oFTP:bUsePasv      := ::lPassive

   if !::oFTP:Open( ::cUrl )

      msgStop( "Imposible conectar con el sitio ftp " + ::cFtpSite, "Error" )

      ::lConnect        := .f.

   else

      if !Empty( ::cDirectory )
         ::oFtp:Cwd( ::cDirectory )
         ::oFtp:Pwd()
      end if

      ::lConnect        := .t.

   end if

Return ( ::lConnect )

//---------------------------------------------------------------------------//

METHOD closeConexion() 

   if !Empty( ::oFtp )
      ::oFtp:Close()
   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD ftpGetFiles()

   local cFile
   local aFiles            := ::oFTP:listFiles() // 
   
   ::oFtp:oUrl:cPath       := "."

   for each cFile in aFiles 
      if ::fileNotProccess( cFile )
         ::fileDownload( cFile )
      end if 
   next

Return ( Self )

//---------------------------------------------------------------------------//

METHOD fileNotProccess( cFile )

   local fileNotProccess   := file( ::cLocalDirectoryProcessed + ::fileDocument( cFile ) ) .or. file( ::cLocalDirectory + ::fileDocument( cFile ) )

   // msgAlert( file( ::cLocalDirectory + ::fileDocument( cFile ) ), ::cLocalDirectory + ::fileDocument( cFile ) )

Return ( !fileNotProccess )

//---------------------------------------------------------------------------//

METHOD fileDownload( cFile )

   local cFileDocument  := ::fileDocument( cFile )                

   msgRun( "Descargando fichero " + cFileDocument, "Espere por favor...", {|| ::oFtp:downLoadFile( ::cLocalDirectory + cFileDocument, cFileDocument ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD fileDocument( cFile )

   cFile    := substr( cFile[ 1 ], 40 )

Return ( cFile )

//---------------------------------------------------------------------------//

