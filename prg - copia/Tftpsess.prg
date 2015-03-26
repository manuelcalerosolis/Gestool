// FiveWin InterNet FTP Session (used from Class TFtpServer)
// (c) FiveTech

#include "FiveWin.Ch"

//----------------------------------------------------------------------------//

CLASS TFtpSession

   DATA   cUserName, cPassword

   DATA   cCurDir          // Current directory for the Client

   DATA   cIP              // FTP Client IP (PORT command info)
   DATA   nPort            // FTP Client port (PORT command info)

   DATA   oSocket          // response socket

   METHOD New( cUserName ) CONSTRUCTOR

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cUserName ) CLASS TFtpSession

return nil

//----------------------------------------------------------------------------//