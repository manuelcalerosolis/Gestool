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

Return ( FtpPutFile( ::oFTP:hFtp, ::cFileName, ::cSortFileName, 0, 0 ) )
