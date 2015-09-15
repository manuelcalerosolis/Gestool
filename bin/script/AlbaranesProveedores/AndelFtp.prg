#include "FiveWin.Ch"
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch"
#include "Report.ch"
#include "Print.ch"

//----------------------------------------------------------------------------//

Function AndelFtpConexion()
   
   AndelFtp():New()

Return nil

//----------------------------------------------------------------------------//
   
CLASS AndelFtp

   DATA  cFtpSite
   DATA  cUserName
   DATA  cPassword
   DATA  cUrl
   DATA  lPassive
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

   ::cFtpSite              := "pedidos.andelautomocion.com"
   ::cUserName             := "andelftp"
   ::cPassword             := "ftp123"
   ::cUrl                  := "ftp://" + ::cUserName + ":" + ::cPassword + "@" + ::cFtpSite
   ::lPassive              := .t.

   msgRun( "Conectando con el sito " + ::cUrl, "Espere por favor...", {|| ::Run() } )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Run()

   DATABASE NEW ::oAlbPrvT PATH ( cPatEmp() ) FILE "ALBPROVT.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVT.CDX"
   ::oAlbPrvT:ordsetfocus( "cSuAlb" )

   if ::ftpConexion()
      ::ftpGetFiles()
      ::closeConexion()
   else 
      msgInfo( "Error al conectar" )
   end if 

   ::oAlbPrvT:End()

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
   local aFiles            := ::oFTP:listFiles( "430000093*.*" ) // 
   
   ::oFtp:oUrl:cPath       := "."

   for each cFile in aFiles 
      if ::fileNotProccess( cFile[ 1 ] )
         ::fileDownload( cFile[ 1 ] )
      end if 
   next

Return ( Self )

//---------------------------------------------------------------------------//

METHOD fileNotProccess( cFile )

   local cFileDocument  := ::fileDocument( cFile )

Return ( !::oAlbPrvT:Seek( cFileDocument ) )

//---------------------------------------------------------------------------//

METHOD fileDownload( cFile )

   msgRun( "Descargando fichero " + cFile, "Espere por favor...", {|| ::oFtp:downLoadFile( "C:\ImportacionAlbaranes\" + cFile, cFile ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD fileDocument( cFile )

   local cSerie   := SubStr( cFile, 18, 1 ) 
   local nNumero  := "0" + SubStr( cFile, 20, 7 ) 
   local cSufijo  := SubStr( cFile, 18, 2 ) 

Return ( cSerie + nNumero + cSufijo )

//---------------------------------------------------------------------------//
/*
430000093-AlbaranIS0080133.txt -> I/00080133/IS
*/