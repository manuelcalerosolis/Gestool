// FiveWin Class TInternet based on Windows WinINet.dll layer !!!

#include "FiveWin.Ch"

//----------------------------------------------------------------------------//

CLASS TInternet

   CLASSDATA  hWinINet           // handle to opened WinINet.dll
   CLASSDATA  hSession           // handle of current session

   CLASSDATA  aFTPs INIT {}      // Array of all TFTP objects in use

   METHOD     New() CONSTRUCTOR  // Generic constructor

   METHOD     End()              // Generic destructor

   METHOD     FTP( cFTPSite )    // generates a new TFTP object and connect to it

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New() CLASS TInternet

   local hWinINet := WinINet()

   if hWinINet < 0 .or. hWinINet >= 32
      ::hSession  := InternetOpen( 0, 0, 0, 0, 0 )
   endif

return Self

//----------------------------------------------------------------------------//

METHOD End() CLASS TInternet

   aSend( ::aFTPs, "End()" )

   if ::hSession != nil
      InternetCloseHandle( ::hSession )
      ::hSession = nil
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Ftp( cFTPSite ) CLASS TInternet

return TFTP():New( cFTPSite, Self )

//----------------------------------------------------------------------------//