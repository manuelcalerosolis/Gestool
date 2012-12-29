// FiveWin Class TFTP for Internet FTP management. Based on Windows WinINet.dll

#include "FiveWin.Ch"
#include "Struct.ch"

#define INTERNET_SERVICE_FTP    1
#define FTP_PORT               21

//----------------------------------------------------------------------------//

CLASS TFTP

   DATA   oInternet                  // TInternet container object
   DATA   cSite                      // URL address
   DATA   hFTP                       // handle of the FTP connection
   DATA   cUserName                  // user name to login
   DATA   cPassword                  // password to login

   METHOD New( cFTPSite, oInternet ) CONSTRUCTOR  // generic constructor

   METHOD End()                        // generic destructor

   METHOD DeleteFile( cFileName )    // deletes a remote FTP file

   METHOD Directory( cMask )         // as Clipper Directory() but on a FTP site!

   METHOD DeleteMask( cMask )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cFTPSite, oInternet, cUserName, cPassword ) CLASS TFTP

   ::oInternet = oInternet
   ::cSite     = cFTPSite
   ::cUserName = cUserName
   ::cPassword = cPassword

   if oInternet:hSession != nil
      ::hFTP = InternetConnect( oInternet:hSession, cFTPSite, FTP_PORT,;
                                ::cUserName, ::cPassword,;
                                INTERNET_SERVICE_FTP, 0, 0 )
      AAdd( oInternet:aFTPs, Self )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD End() CLASS TFTP

   if ::hFTP != nil
      InternetCloseHandle( ::hFTP )
      ::hFTP = nil
   endif

return nil

//----------------------------------------------------------------------------//

METHOD DeleteFile( cFileName ) CLASS TFTP

return If( ::hFTP != nil, FtpDeleteFile( ::hFTP, cFileName ), .f. )

//----------------------------------------------------------------------------//

METHOD Directory( cMask ) CLASS TFTP

   local hFTPDir, aFiles := {}
   local oWin32FindData, cBuffer

   DEFAULT cMask := "*.*"

   STRUCT oWin32FindData
      MEMBER nFileAttributes  AS DWORD
      MEMBER nCreationTime    AS STRING LEN 8
      MEMBER nLastReadAccess  AS STRING LEN 8
      MEMBER nLastWriteAccess AS STRING LEN 8
      MEMBER nSizeHight       AS DWORD
      MEMBER nSizeLow         AS DWORD
      MEMBER nReserved0       AS DWORD
      MEMBER nReserved1       AS DWORD
      MEMBER cFileName        AS STRING LEN 260
      MEMBER cAltName         AS STRING LEN  14
   ENDSTRUCT

   if ::hFTP != nil
      cBuffer = oWin32FindData:cBuffer
      hFTPDir = FtpFindFirstFile( ::hFTP, cMask, @cBuffer, 0, 0 )
      oWin32FindData:cBuffer = cBuffer
      if ! Empty( oWin32FindData:cFileName )
         AAdd( aFiles, { oWin32FindData:cFileName,;
                         oWin32FindData:nSizeLow } )
         while InternetFindNextFile( hFTPDir, @cBuffer )
            oWin32FindData:cBuffer = cBuffer
            AAdd( aFiles, { oWin32FindData:cFileName,;
                            oWin32FindData:nSizeLow } )
         end
      endif
      InternetCloseHandle( hFTPDir )
   endif

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