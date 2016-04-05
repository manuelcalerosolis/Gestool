#include "FiveWin.Ch" 
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch" 
#include "hbcurl.ch"

#require "hbcurl"

//----------------------------------------------------------------//
//----------------------------------------------------------------//
//----------------------------------------------------------------//
//----------------------------------------------------------------//
//----------------------------------------------------------------//

CLASS TFtpLinux

   DATA oFTP
   DATA cError                                  INIT ""

   DATA lHasSSL                                 INIT .f.

   DATA TPrestashopConfig

   DATA cServer                                 
   DATA cUser              
   DATA cPassword       
   DATA nPort                                   INIT 21

   DATA lPassive                                INIT .f.

   METHOD new( cUser, cPassword, cServer, nPort )
   METHOD newPrestashopConfig( TPrestashopConfig ) 

   METHOD createConexion() 
   METHOD endConexion()

   METHOD setPassive( lPassive )                INLINE ( if( hb_islogical( lPassive ), ::lPassive := lPassive, ::lPassive ) )

   METHOD getError()                            INLINE ( ::cError )

   METHOD createDirectory( cCarpeta ) 
   METHOD createDirectoryRecursive( cCarpeta ) 
   METHOD returnDirectory( cCarpeta ) 

   METHOD createFile( cFile, cDirectory ) 

   METHOD say()                                 INLINE ( msgInfo( "Server : "    + ::TPrestashopConfig:getFtpServer()   + CRLF + ;
                                                                  "User : "      + ::TPrestashopConfig:getFtpUser()     + CRLF + ;
                                                                  "Password : "  + ::TPrestashopConfig:getFtpPassword() + CRLF + ;
                                                                  if( ::TPrestashopConfig:getFtpPassive(), "Passive", "No passive" ), ;
                                                                  "ClassName : " + ::ClassName() ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( cUser, cPassword, cServer, nPort ) CLASS TFtpLinux

   DEFAULT nPort  := 21

   ::cUser        := cUser
   ::cPassword    := cPassword
   ::cServer      := cServer
   ::nPort        := nPort

Return ( Self )

//----------------------------------------------------------------//

METHOD NewPrestashopConfig( TPrestashopConfig ) CLASS TFtpLinux

   ::TPrestashopConfig  := TPrestashopConfig

   ::New( ::TPrestashopConfig:getFtpUser(), ::TPrestashopConfig:getFtpPassword(), ::TPrestashopConfig:getFtpServer(), ::TPrestashopConfig:getFtpPort() )

Return ( Self )

//----------------------------------------------------------------//

METHOD CreateConexion() CLASS TFtpLinux

   local cStr
   local cUrl 
   local oUrl          
   local lOpen             := .f.

   if !empty( ::TPrestashopConfig:getFtpServer() )
 
      cUrl                 := "ftp://" + ::cUser + ":" + ::cPassword + "@" + ::cServer

      oUrl                 := TUrl():New( cUrl )
      oUrl:cProto          := "ftp"
      oUrl:cServer         := ::cServer
      oUrl:cUserID         := ::cUser
      oUrl:cPassword       := ::cPassword
      oUrl:nPort           := ::nPort

      ::oFTP               := TIPClientFTP():New( oUrl, .t. )
      ::oFTP:nConnTimeout  := 20000
      ::oFTP:bUsePasv      := ::lPassive
      ::oFTP:nDefaultPort  := ::nPort
 
      lOpen                := ::oFTP:Open()
      if !lOpen

         ::cError          := "Could not connect to FTP server " + oURL:cServer
         if empty( ::oFTP:SocketCon )
            ::cError       += hb_eol() + "Connection not initialized"
         elseif hb_inetErrorCode( ::oFTP:SocketCon ) == 0
            ::cError       += hb_eol() + "Server response:" + " " + ::oFTP:cReply
         else
            ::cError       += hb_eol() + "Error in connection:" + " " + hb_inetErrorDesc( ::oFTP:SocketCon )
         endif

         msgStop( ::cError )

      end if

   end if 

Return ( lOpen )

//---------------------------------------------------------------------------//

METHOD EndConexion() CLASS TFtpLinux

   if !empty( ::oFTP )
      ::oFTP:Close()
   end if 

Return( nil )

//---------------------------------------------------------------------------//

METHOD CreateDirectory( cCarpeta ) CLASS TFtpLinux

   if !empty( ::oFtp )   
      ::oFtp:MKD( cCarpeta )
      ::oFtp:CWD( cCarpeta )
   end if 

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD CreateDirectoryRecursive( cCarpeta ) CLASS TFtpLinux

   local n

   for n := 1 to len( cCarpeta )
      ::CreateDirectory( substr( cCarpeta , n, 1 ) )
   next 

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD CreateFile( cFile ) CLASS TFtpLinux

   local lCreate  := .f.

   if !empty( ::oFtp )   
      lCreate     := ::oFtp:UploadFile( cFile )
   end if 

Return ( lCreate )

//---------------------------------------------------------------------------//

METHOD ReturnDirectory( cCarpeta ) CLASS TFtpLinux

   local n

   if !empty( ::oFtp )   
      for n := 1 to len( cCarpeta )
         ::oFtp:CWD( ".." )
      next
   end if

Return ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TFTPWindows FROM TFtpLinux

   DATA oInt

   METHOD createConexion() 
   METHOD endConexion()

   METHOD createDirectory( cCarpeta ) 
   METHOD returnDirectory( cCarpeta ) 

   METHOD createFile( cFile, cDirectory ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD createConexion() CLASS TFTPWindows

   local lCreate     := .f.

   if !empty( ::cServer )   

      ::oInt         := TInternet():New()
      ::oFtp         := TFtp():New( ::cServer, ::oInt, ::cUser, ::cPassword, ::lPassive )

      if !empty( ::oFtp )
         lCreate     := ( ::oFtp:hFtp != 0 )
      end if 

   end if 

Return ( lCreate )

//---------------------------------------------------------------------------//

METHOD endConexion() CLASS TFTPWindows

   if !empty( ::oInt )
      ::oInt:end()
   end if

   if !empty( ::oFtp )
      ::oFtp:end()
   end if 

Return( nil )

//---------------------------------------------------------------------------//

METHOD CreateDirectory( cCarpeta ) CLASS TFTPWindows

   if !empty( ::oFtp )   
      ::oFtp:CreateDirectory( cCarpeta ) 
      ::oFtp:SetCurrentDirectory( cCarpeta ) 
   end if 

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD CreateFile( cFile, oMeter ) CLASS TFTPWindows
   
   local oFile
   local nBytes
   local hSource
   local lPutFile    := .f.
   local cBuffer     := Space( 20000 )
   local nTotalBytes := 0
   local nWriteBytes := 0

   if !file( cFile )
      msgStop( "No existe el fichero " + alltrim( cFile ) )
      Return ( .f. )
   end if 

   oFile             := TFtpFile():New( cNoPath( cFile ), ::oFtp )
   oFile:OpenWrite()

   hSource           := fOpen( cFile ) 
   if ferror() == 0

      fseek( hSource, 0, 0 )

      while ( nBytes := fread( hSource, @cBuffer, 20000 ) ) > 0 
         nWriteBytes += nBytes
         oFile:write( substr( cBuffer, 1, nBytes ) )
         sysrefresh()
      end while

      lPutFile       := .t.

   end if

   oFile:End()

   fClose( hSource )

   sysrefresh()

Return ( lPutFile )

//---------------------------------------------------------------------------//

METHOD ReturnDirectory( cCarpeta ) CLASS TFTPWindows

   local n

   for n := 1 to len( cCarpeta )
      ::oFtp:SetCurrentDirectory( ".." )
   next   

Return ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TFTPCurl FROM TFtpLinux

   DATA idCurl
   DATA cInitialDirectory
   DATA cRecursiveDirectory

   METHOD createConexion() 
   METHOD endConexion()                            INLINE ( curl_global_cleanup() )

   METHOD createDirectory( cDirectory )            VIRTUAL // INLINE ( ::cInitialDirectory := cDirectory )
   METHOD createDirectoryRecursive( cDirectory )   VIRTUAL // INLINE ( ::cRecursiveDirectory := cDirectory )

   METHOD returnDirectory( cCarpeta )              VIRTUAL

   METHOD createFile( cFile, cDirectory ) 
   METHOD downloadFile( cFile, cDirectory )

END CLASS

//---------------------------------------------------------------------------//

METHOD createConexion() CLASS TFTPCurl

   curl_global_init()

   ::idCurl             := curl_easy_init()

Return ( !empty( ::idCurl ) )

//---------------------------------------------------------------------------//

METHOD createFile( cFile, cDirectory ) CLASS TFTPCurl

   local cURL
   local createFile  := .f.

   if empty(::idCurl)
      Return .f.
   endif

   cDirectory        := cLeftPath( cDirectory )

   cURL              := "ftp://" + ::cUser + ":" + ::cPassword + "@" + ::cServer + "/" + cDirectory + cFile

   curl_easy_setopt( ::idCurl, HB_CURLOPT_UPLOAD )
   curl_easy_setopt( ::idCurl, HB_CURLOPT_URL, cURL )
   curl_easy_setopt( ::idCurl, HB_CURLOPT_UL_FILE_SETUP, cFile )
   curl_easy_setopt( ::idCurl, HB_CURLOPT_INFILESIZE, hb_fsize( cFile ) )
   curl_easy_setopt( ::idCurl, HB_CURLOPT_FTP_CREATE_MISSING_DIRS, .t. )
   
   createFile        := curl_easy_perform( ::idCurl )

   // curl_easy_getinfo( ::idCurl, HB_CURLINFO_EFFECTIVE_URL )
   // curl_easy_getinfo( ::idCurl, HB_CURLINFO_TOTAL_TIME )
   curl_easy_reset( ::idCurl )

Return ( createFile )

//---------------------------------------------------------------------------//

METHOD downloadFile( cFile, cDirectory ) CLASS TFTPCurl

   local cURL
   local createFile  := .f.

   if empty(::idCurl)
      Return .f.
   endif

   cDirectory        := cLeftPath( cDirectory )

   cURL              := "ftp://" + ::cUser + ":" + ::cPassword + "@" + ::cServer + "/" + cDirectory + cFile

   curl_easy_setopt( ::idCurl, HB_CURLOPT_DOWNLOAD )
   curl_easy_setopt( ::idCurl, HB_CURLOPT_URL, cURL )
   curl_easy_setopt( ::idCurl, HB_CURLOPT_UL_FILE_SETUP, cFile )
   curl_easy_setopt( ::idCurl, HB_CURLOPT_FTP_CREATE_MISSING_DIRS, .t. )
   
   createFile        := curl_easy_perform( ::idCurl )

   curl_easy_reset( ::idCurl )

Return ( createFile )

//---------------------------------------------------------------------------//
