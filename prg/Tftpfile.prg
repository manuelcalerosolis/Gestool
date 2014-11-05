// FiveWin Class TFTPFile for managing remote FTP files. Based on WinINet.dll

#include "FiveWin.Ch"

#define GENERIC_READ     2147483648  // 0x80000000
#define GENERIC_WRITE    1073741824  // 0x40000000

#define FTP_TRANSFER_TYPE_ASCII    1
#define FTP_TRANSFER_TYPE_BINARY   2

#define FILE_BEGIN                 0
#define FILE_CURRENT               1
#define FILE_END                   2

//----------------------------------------------------------------------------//

CLASS TFTPFile

   DATA     oFTP                            // TFTP container object
   DATA     cFileName                       // name of the file
   DATA     hFile                           // Internet handle of the file
   DATA     lBinary                         // binary management vs. ascii management
   DATA     cSortFileName

   METHOD   New( cFileName, oFTP ) CONSTRUCTOR    // generic constructor

   METHOD   End()                           // generic destructor

   METHOD   OpenRead()                      // opens the file for reading
   METHOD   OpenWrite()                     // opens the file for writting

   METHOD   PutFile()

   METHOD   Write( cData )                  // write data to the file
   METHOD   Read( nBytes )                  // read n bytes from the file
   METHOD   Seek( nBytes, nFrom )           // skips + / - bytes file pointer
   METHOD   CreateDir( cDirName )           // create directory

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cFileName, oFTP ) CLASS TFTPFile

   ::cFileName       := cFileName
   ::cSortFileName   := cNoPath( cFileName )
   ::oFTP            := oFTP
   ::lBinary         := .t.

return Self

//----------------------------------------------------------------------------//

METHOD End() CLASS TFTPFile

   if ::hFile != nil
      InternetCloseHandle( ::hFile )
      ::hFile        := nil
   end if

return nil

//----------------------------------------------------------------------------//

METHOD OpenWrite() CLASS TFTPFile

   ::hFile           := FtpOpenFile( ::oFTP:hFTP, ::cFileName, GENERIC_WRITE, If( ::lBinary, FTP_TRANSFER_TYPE_BINARY, FTP_TRANSFER_TYPE_ASCII ), 0 )

return Self

//----------------------------------------------------------------------------//

METHOD OpenRead() CLASS TFTPFile

   ::hFile           := FtpOpenFile( ::oFTP:hFTP, ::cFileName, GENERIC_READ, If( ::lBinary, FTP_TRANSFER_TYPE_BINARY, FTP_TRANSFER_TYPE_ASCII ), 0 )

return Self

//----------------------------------------------------------------------------//

METHOD Write( cData ) CLASS TFTPFile

   local nWritten    := 0
   local nToWrite    := Len( cData )

   InternetWriteFile( ::hFile, cData, nToWrite, @nWritten )

return ( nWritten )

//----------------------------------------------------------------------------//

METHOD Read( nBytes ) CLASS TFTPFile

   local nRead       := 0
   local cBuffer

   DEFAULT nBytes    := 2000

   cBuffer           := Space( nBytes )

   InternetReadFile( ::hFile, @cBuffer, nBytes, @nRead )

return ( SubStr( cBuffer, 1, nRead ) )

//----------------------------------------------------------------------------//

METHOD Seek( nBytes, nFrom ) CLASS TFTPFile

   DEFAULT nFrom     := FILE_CURRENT

return InternetSetFilePointer( ::hFile, nBytes, 0, nFrom, 0 )

//----------------------------------------------------------------------------//

METHOD CreateDir( cDirName ) CLASS TFTPFile

return FtpCreateDirectory( ::oFtp:hFTP, cDirName )

//----------------------------------------------------------------------------//

METHOD PutFile( oMeter ) CLASS TFTPFile

   local oFile
   local nBytes
   local hSource
   local lPutFile    := .t.
   local cBuffer     := Space( 2000 )
   local nTotalBytes := 0
   local nWriteBytes := 0

   Msgalert( "OpenWrite" )
   //oFile             := TFtpFile():New( ::cSortFileName, ::oFTP )
   ::OpenWrite()

   nTotalBytes       := nGetBytes( ::cFileName )

   if !Empty( oMeter )
      oMeter:SetTotal( nTotalBytes )
   end if

   msgAlert( "hSource           := fOpen( ::cFileName )" )

   hSource           := fOpen( ::cFileName )

   msgAlert( "if fError() == 0")

   if fError() == 0

      msgAlert( "fSeek( hSource, 0, 0 )" )

      fSeek( hSource, 0, 0 )

      msgAlert( "while ( nBytes := fRead( hSource, @cBuffer, 2000 ) ) > 0" )

      while ( nBytes := fRead( hSource, @cBuffer, 2000 ) ) > 0

         msgAlert( "nWriteBytes += nBytes" )
         nWriteBytes += nBytes

         msgAlert( "::Write( SubStr( cBuffer, 1, nBytes ) )" )  
         ::Write( SubStr( cBuffer, 1, nBytes ) )

         msgAlert( "if !Empty( oMeter )" )  
         if !Empty( oMeter )
            msgAlert( "oMeter:Set( nWriteBytes )")
            oMeter:Set( nWriteBytes )
         end if

      end while

   else

      lPutFile       := .f.

   end if

   ::End()

   fClose( hSource )

   SysRefresh()

/*
return FtpPutFile( ::oFTP:hFTP, ::cFileName, ::cSortFileName, If( ::lBinary, FTP_TRANSFER_TYPE_BINARY, FTP_TRANSFER_TYPE_ASCII ), 0 )
*/

Return ( lPutFile )

//----------------------------------------------------------------------------//

#include "Struct.ch"

#define INTERNET_SERVICE_FTP        1
#define FTP_PORT                    21

#define INTERNET_FLAG_NEED_FILE     16
#define INTERNET_FLAG_PASSIVE       0x08000000

//----------------------------------------------------------------------------//

CLASS TFTP

   DATA   oInternet                  // TInternet container object
   DATA   cSite                      // URL address
   DATA   hFTP                       // handle of the FTP connection
   DATA   cUserName                  // user name to login
   DATA   cPassword                  // password to login
   DATA   lPassive

   METHOD New( cFTPSite, oInternet ) CONSTRUCTOR  // generic constructor

   METHOD End()                        // generic destructor

   METHOD DeleteFile( cFileName )    // deletes a remote FTP file

   METHOD Directory( cMask )         // as Clipper Directory() but on a FTP site!
 
   METHOD DeleteMask( cMask )        // as Clipper Directory() but on a FTP site!

   // METHOD GetCurrentDirectory()              INLINE ( FtpGetCurrentDirectory( ::hFTP ) )

   Method SetCurrentDirectory( cDirectory )  INLINE ( FtpSetCurrentDirectory( ::hFTP, cDirectory ) )

   Method CreateDirectory( cDirectory )      INLINE ( FtpCreateDirectory( ::hFTP, cDirectory ) )

   Method RemoveDirectory( cDirectory )      INLINE ( if( !FtpRemoveDirectory( ::hFTP, cDirectory ), msgStop( GetErrMsg() ), .t. ) )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cFTPSite, oInternet, cUserName, cPassword, lPassive ) CLASS TFTP

   DEFAULT lPassive  := .f.

   ::oInternet       := oInternet
   ::cSite           := cFTPSite
   ::cUserName       := cUserName
   ::cPassword       := cPassword
   ::lPassive        := lPassive

   if oInternet:hSession != nil
      ::hFTP         := InternetConnect( oInternet:hSession, cFTPSite, FTP_PORT, ::cUserName, ::cPassword, INTERNET_SERVICE_FTP, if( lPassive, INTERNET_FLAG_PASSIVE, 0 ), 0 )
      AAdd( oInternet:aFTPs, Self )
   endif

return ( Self )

//----------------------------------------------------------------------------//

METHOD End() CLASS TFTP

   if ::hFTP != nil
      InternetCloseHandle( ::hFTP )
      ::hFTP         := nil
   endif

return nil

//----------------------------------------------------------------------------//

METHOD DeleteFile( cFileName ) CLASS TFTP

return If( ::hFTP != nil, FtpDeleteFile( ::hFTP, cFileName ), .f. )

//----------------------------------------------------------------------------//

METHOD Directory( cMask ) CLASS TFTP

   local aFiles   := {}

   DEFAULT cMask  := "*.*"

   aFiles         := InternetDirectory( ::hFtp, cMask, INTERNET_FLAG_NEED_FILE, 0 )

return aFiles

//----------------------------------------------------------------------------//

METHOD DeleteMask( cMask ) CLASS TFTP

   local n
   local aFiles

   DEFAULT cMask := "*.*"

   IF ::hFTP != nil

      aFiles := ::Directory( cMask )

      FOR n = 1 TO len( aFiles )

         FtpDeleteFile( ::hFTP, aFiles[ n, 1 ] )

      NEXT

   END IF

return nil

//----------------------------------------------------------------------------//

