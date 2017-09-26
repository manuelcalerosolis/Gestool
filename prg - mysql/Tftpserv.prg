// FiveWin InterNet FTP Server
// (c) FiveTech 1997
// by Antonio Linares & Jesus Salas 1997

#include "FiveWin.Ch"

//----------------------------------------------------------------------------//

CLASS TFtpServer

   DATA   oSocket                       // main listening socket object

   DATA   aSockets INIT {}              // clients attending sockets objects

   DATA   cAddress
   DATA   cDefPath                      // default FTP directory

   DATA   lDebug
   DATA   cLogFile

   METHOD New( nPort ) CONSTRUCTOR

   METHOD Activate() INLINE ::oSocket:Listen()

   METHOD End() INLINE ::oSocket:End()

   METHOD OnAccept()
   METHOD OnRead()

   METHOD Sockets() INLINE MsgInfo( Len( ::oSocket:aSockets ) )

   METHOD Dir( cMask )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nPort ) CLASS TFtpServer

   DEFAULT nPort := 21

   ::oSocket  = TSocket():New( nPort )
   ::cAddress = ::oSocket:cIPAddr
   ::cDefPath = "ftp"
   ::cLogFile = "ftp.log"
   ::lDebug   = .f.

   if ! lIsDir( ::cDefPath )
      lMkDir( ::cDefPath )
   endif

   ::oSocket:bAccept = { || ::OnAccept() }

return nil

//----------------------------------------------------------------------------//

METHOD OnAccept() CLASS TFtpServer

   local oClientSocket := TSocket():Accept( ::oSocket:nSocket )

   if ::lDebug .and. ! Empty( ::cLogFile )
      LogFile( ::cLogFile, { "TFtpServer : Accept",;
               "oClientSocket:nSocket = " + ;
               AllTrim( Str( oClientSocket:nSocket ) ) } )
   endif

   oClientSocket:bRead  = { | oSocket | ::OnRead( oSocket ) }
   oClientSocket:bClose = { | oSocket | oSocket:End() }

   oClientSocket:SendData( "220 FiveWin FTP 1.0 Server ready." + CRLF )

return oClientSocket

//----------------------------------------------------------------------------//

METHOD OnRead( oSocket ) CLASS TFtpServer

   local cData := oSocket:GetData()
   local cIP
   local oDataSocket
   local cCommand := ""
   local cDataCmm := ""
   local cAux     := ""
   local nPos     := ""
   local lControl := .f.
   local fHandle


   if ::lDebug .and. ! Empty( ::cLogFile )
      LogFile( ::cLogFile, { oSocket:ClientIP(), cData } )
   endif
   cData    := AllTrim( StrTran( cData, Chr(13)+Chr(10), "" ))

   nPos := At( " ", cData )

   if nPos > 0
      cCommand := AllTrim( Upper( SubStr( cData, 1, nPos  ) ) )
      cDataCmm := AllTrim( Upper( SubStr( cData, nPos + 1 ) ) )
   else
      cCommand := Upper( cData )
   endif

      //msgStop(">"+cCommand+"<",">"+cDataCmm+"<")

   do case
      case cCommand == "NOOP"
           oSocket:SendData( "210 Command okay." + CRLF )
      // Access Control Commands...

      case cCommand == "ACCT"
           oSocket:SendData( "500 Command okay (Not implemented Yet!)" + CRLF )

      case cCommand == "CWD"    // changes the working directory
           If ! Empty( cDataCmm )
              ::cDefPath +="\"+cDataCmm
           endif
           oSocket:SendData( "200 Command okay." + CRLF )

      case cCommand == "CDUP"   // changes to parent directory
           ::cDefPath := SubStr(::cDefPath, 1, rAt("\",::cDefPath)-1)
           oSocket:SendData( "200 Command okay." + CRLF )

      case cCommand == "SMNT"   // Mount a different file system
           oSocket:SendData( "500 Command okay (Not implemented Yet!)" + CRLF )

      case cCommand == "REIN"   // Reinitializes an FTP Session
           oSocket:SendData( "500 Command okay (Not implemented Yet!)" + CRLF )

      case cCommand == "USER"   // for user identification
         oSocket:Cargo = TFtpSession():New( cDataCmm )

         if AllTrim( cDataCmm ) == "ANONYMOUS"
            oSocket:SendData( "331 Guest login ok, send ident as password." + CRLF )
         endif

      case cCommand == "PASS"   // specifies user's password
           oSocket:SendData( "230 Guest login ok, access restrictions apply." + CRLF )

      case cCommand == "QUIT"   // Ends FTP session
         oSocket:SendData( "205 Bye" + CRLF )

      // TRANSFER PARAMETER COMMAND

      case cCommand == "PORT"   // used to change the machine address and/or
                                // the data connection
           cIP = SubStr( cData, 6 )
           oSocket:Cargo:nPort = ( Val( StrToken( cIP, 5, "," ) ) * 256 ) + ;
                                   Val( StrToken( cIP, 6, "," ) )

           cIP = StrToken( cIP, 1, "," ) + "." + ;
                 StrToken( cIP, 2, "," ) + "." + ;
                 StrToken( cIP, 3, "," ) + "." + ;
                 StrToken( cIP, 4, "," )

           oSocket:Cargo:cIP = cIP

           oSocket:SendData( "200 PORT command successful." + CRLF )

      case cCommand == "PASV"    // Request for a server to listen for data
                                 // connection
           oSocket:SendData( "500 Command okay (Not implemented Yet!)" + CRLF )

      case cCommand == "TYPE"   // Changes file type (ascii, EBCDIC, Image,
                                // local byte size9, there may second param.
           oSocket:SendData( "200 Type set to " + cDataCmm + ;
                             "." + CRLF )

      case cCommand == "STUC"   // changes file structure (file,Record,page)
           oSocket:SendData( "500 Command okay (Not implemented Yet!)" + CRLF )

      case cCommand == "MODE"   // changes file transfer mode
                                // (Srteam, Block, compressed)

           oSocket:SendData( "500 Command okay (Not implemented Yet!)" + CRLF )


      // FTP SERVICE COMMANDS
      case cCommand == "REST"
           oSocket:SendData( "500 This server can't resume." + CRLF )

      case cCommand == "RETR"
           cAux := ::cDefPath+"\"+cDataCmm

           oSocket:SendData( "150 ASCII data connection for / (" + ;
                           cDataCmm+ "," + ;
                           AllTrim( Str( oSocket:Cargo:nPort ) ) + ;
                           ") (0 bytes)." + CRLF )

           oDataSocket = TSocket():New( 20 )

           oDataSocket:bConnect = { | oSocket | oSocket:SendFile( cAux ),;
                                       oSocket:End() }

           oDataSocket:Connect( oSocket:Cargo:cIP, oSocket:Cargo:nPort )

           oSocket:SendData( "226 Transfer complete." + CRLF )

      case cCommand == "STOR"

           cAux := ::cDefPath+"\"+cDataCmm

           oSocket:SendData( "150 ASCII data connection for / (" + ;
                           cDataCmm+ "," + ;
                           AllTrim( Str( oSocket:Cargo:nPort ) ) + ;
                           ")" + CRLF )

           oDataSocket = TSocket():New( 20 )

           fHandle := LOpen( cAux ,"w" )

           if fHandle > 0

              oDataSocket:bConnect = { | oSocket | oSocket:SendData( ,;
                                   "150 ASCII data connection for / (" + ;
                                   cDataCmm+ "," + ;
                                   AllTrim( Str( oSocket:Cargo:nPort ) ) + ;
                                   ")" + CRLF ) }

              oDataSocket:bRead = { | oDataSocket | fWrite( fHandle, oSocket:GetData() ) }

              oDataSocket:bClose = { | oDataSocket | ;
                                      LClose( fHandle ),;
                                      oDataSocket:End(),;
                                      oSocket:SendData( "226 - Transfer Complete." );
                                      }

              oDataSocket:Connect( oSocket:Cargo:cIP, oSocket:Cargo:nPort )


           endif


      case cCommand == "SITE"
           // do case
           //   case StrToken( cData, 2 ) == "DIRSTYLE"
           //        oSocket:SendData( "200 MSDOS-like directory output is on" + CRLF )

           //   otherwise
                   oSocket:SendData( "502 SITE Command not implemented." + CRLF )
           // endcase

      case cCommand == "SYST"
           oSocket:SendData( "215 Windows_NT version 4.0" + CRLF )

      case cCommand == "PWD"
           cAux := StrTran( Upper( ::cDefPath ), "FTP" ,"" )
           cAux := iif( Empty( cAux ) = .T.,"/", cAux )

           oSocket:SendData( '257 "'+lower(StrTran(cAux,"\","/"))+'" is current directory.' + CRLF )

      case cCommand == "LIST"
         oSocket:SendData( "150 ASCII data connection for / (" + ;
                           oSocket:Cargo:cIP + "," + ;
                           AllTrim( Str( oSocket:Cargo:nPort ) ) + ;
                           ") (0 bytes)." + CRLF )

         oDataSocket = TSocket():New( 20 )

         oDataSocket:bConnect = { | oSocket | oSocket:SendData( ::Dir() ),;
                                    oSocket:End() }

         oDataSocket:Connect( oSocket:Cargo:cIP, oSocket:Cargo:nPort )

         oSocket:SendData( "226 ASCII Transfer complete." + CRLF )

   endcase

return nil

//----------------------------------------------------------------------------//

METHOD Dir( cMask ) CLASS TFtpServer

   local cInfo  := "", aFiles, n

   DEFAULT cMask := "*.*"

   aFiles = Directory( If( ! Empty( ::cDefPath ),;
                           ::cDefPath + "\", "" ) + cMask, "D" )

   for n = 1 to Len( aFiles )
      if aFiles[ n ][ 1 ] != "." .and. aFiles[ n ][ 1 ] != ".."
         cInfo += If( "D" $ aFiles[ n ][ 5 ], "d", "-" ) + ;
               "rw-rw-rw-   1 0        1" + ;
               PadL( aFiles[ n ][ 2 ], 16 ) + " " + ;
               { "Jan", "Feb", "Mar", "Apr", "May", "Jun",;
                 "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" }[ Month( aFiles[ n ][ 3 ] ) ] + ;
                 " " + ;
                 Str( Day( aFiles[ n ][ 3 ] ), 2 ) + " " + ;
                 SubStr( aFiles[ n ][ 4 ], 1, 5 ) + " " + ;
                 aFiles[ n ][ 1 ] + CRLF
//               "---------   1 owner    group" + ;
      endif
   next

return cInfo

//----------------------------------------------------------------------------//