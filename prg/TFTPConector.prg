#include "FiveWin.Ch" 
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch" 

//----------------------------------------------------------------//
//----------------------------------------------------------------//
//----------------------------------------------------------------//
//----------------------------------------------------------------//
//----------------------------------------------------------------//

CLASS TFtpLinux

   DATA oFtp

   DATA TPrestashopConfig

   METHOD new( TPrestashopConfig )

   METHOD createConexion() 
   METHOD endConexion()

   METHOD createDirectory( cCarpeta ) 
   METHOD createDirectoryRecursive( cCarpeta ) 
   METHOD returnDirectory( cCarpeta ) 

   METHOD createFile( cFile, cDirectory ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New( TPrestashopConfig ) CLASS TFtpLinux

   ::TPrestashopConfig  := TPrestashopConfig

Return ( Self )

//----------------------------------------------------------------//

METHOD CreateConexion() CLASS TFtpLinux

   local cStr
   local cUrl           
   local lOpen             := .t.

   if !empty( ::TPrestashopConfig:getFtpServer() )

      cUrl                 := "ftp://" + ::TPrestashopConfig:getFtpUser() + ":" + ::TPrestashopConfig:getFtpPassword() + "@" + ::TPrestashopConfig:getFtpServer()

      ::oUrl               := TUrl():New( cUrl )

      ::oFTP               := TIPClientFTP():New( ::oUrl, .t. )
      ::oFTP:nConnTimeout  := 20000
      ::oFTP:bUsePasv      := ::TPrestashopConfig:getFtpPassive()

      lOpen                := ::oFTP:Open( cUrl )

      if !lOpen
         cStr              := "Could not connect to FTP server " + ::oURL:cServer
         if empty( ::oFTP:SocketCon )
            cStr           += hb_eol() + "Connection not initialized"
         elseif hb_inetErrorCode( ::oFTP:SocketCon ) == 0
            cStr           += hb_eol() + "Server response:" + " " + ::oFTP:cReply
         else
            cStr           += hb_eol() + "Error in connection:" + " " + hb_inetErrorDesc( ::oFTP:SocketCon )
         endif
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

METHOD CreateFile( cFile, cDirectory ) CLASS TFtpLinux

   local lCreate  := .f.

   if !empty( ::oFtp )   
      lCreate     := ::oFtp:UploadFile( cFile )
   end if 

Return ( lCreate )

//---------------------------------------------------------------------------//

METHOD ReturnDirectory( cCarpeta ) CLASS TComercio

   local n

   if !empty( ::oFtp )   
      for n := 1 to len( cCarpeta )
         ::oFtp:CWD( ".." )
      next
   end if

Return ( nil )

//---------------------------------------------------------------------------//
//----------------------------------------------------------------//
//----------------------------------------------------------------//
//----------------------------------------------------------------//
//----------------------------------------------------------------//
//----------------------------------------------------------------//

//----------------------------------------------------------------//
//----------------------------------------------------------------//
//----------------------------------------------------------------//
//----------------------------------------------------------------//
//----------------------------------------------------------------//

CLASS TFtpWindows FROM TFtpLinux

   METHOD createConexion() 
   METHOD endConexion()

   METHOD createDirectory( cCarpeta ) 
   METHOD createDirectoryRecursive( cCarpeta ) 
   METHOD returnDirectory( cCarpeta ) 

   METHOD createFile( cFile, cDirectory ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD createConexion() CLASS TFtpWindows

   local lCreate     := .f.

   if !empty( ::TPrestashopConfig:getFtpServer() )   

      ::oInt         := TInternet():New()
      ::oFtp         := TFtp():New( ::TPrestashopConfig:getFtpServer(),;
                                    ::oInt,;
                                    ::TPrestashopConfig:getFtpUser(),;
                                    ::TPrestashopConfig:getFtpPassword(),;
                                    ::TPrestashopConfig:getFtpPassive() )

      if !empty( ::oFtp )
         lCreate     := ( ::oFtp:hFtp != 0 )
      end if 

   end if 

Return ( lCreate )

//---------------------------------------------------------------------------//

METHOD endConexion() CLASS TFtpWindows

   if !empty( ::oInt )
      ::oInt:end()
   end if

   if !empty( ::oFtp )
      ::oFtp:end()
   end if 

Return( nil )

//---------------------------------------------------------------------------//

METHOD ftpCreateDirectory( cCarpeta ) CLASS TFtpWindows

   if !empty( ::oFtp )   
      ::oFtp:CreateDirectory( cCarpeta ) 
      ::oFtp:SetCurrentDirectory( cCarpeta ) 
   end if 

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD CreateFile( cFile, oMeter ) CLASS TFtpWindows
   
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

METHOD ReturnDirectory( cCarpeta ) CLASS TFtpWindows

   local n

   for n := 1 to len( cCarpeta )
      ::oFtp:SetCurrentDirectory( ".." )
   next   

Return ( .t. )

//---------------------------------------------------------------------------//

