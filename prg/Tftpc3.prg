// FiveWin Class TFTP for Internet FTP management. Based on Windows WinINet.dll

#include "FiveWin.Ch"
#include "Struct.ch"

#define INTERNET_SERVICE_FTP        1
#define FTP_PORT                    21

#define FTP_TRANSFER_TYPE_ASCII     1
#define FTP_TRANSFER_TYPE_BINARY    2

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