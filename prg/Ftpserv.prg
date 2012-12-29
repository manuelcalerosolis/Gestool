// FiveWin Class TFtpServer demo

#include "FiveWin.Ch"

static oWnd, oFTPServer

function Main()

   local oBar

   DEFINE WINDOW oWnd TITLE "FiveWin FTP server"

   DEFINE BUTTONBAR oBar _3D OF oWnd

   DEFINE BUTTON OF oBar ACTION BuildServer()

   ACTIVATE WINDOW oWnd

return nil

function BuildServer()

   oFTPServer := TFtpServer():New()

   oFtpServer:cLogFile = "ftpserv.log"
   oFtpServer:lDebug   = .t.

   oFTPServer:Activate()

return nil