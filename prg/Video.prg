/* Ampliaciones de la Clase TVideo by TheFull

   DATA cStatus -> Informa sobre el estado del dispositovo
   METHOD Pause() -> Hacer Pausa, si esta en pausa, continuar
          Resume()-> Continuar
          Play()  -> Si ha sido pausado, continuar
          Status()-> Pregunta por el estado del dispositivo
          End()   -> Cierra dispositivo
      lStretch()  -> No para el avi, asi si redimensionamos la ventana del video,
                     el video se adapta a la nueva resolucion de la ventana contenedora ,
                     tal y como hace el Media Player de Moco$oft */

#include "FiveWin.Ch"
#include "Constant.ch"

#ifdef __XPP__
#define Super ::TControl
#endif

memvar oApp

static cBuffer

//----------------------------------------------------------------------------//

CLASS TVideo FROM TControl

   CLASSDATA lRegistered AS LOGICAL

   CLASSDATA aProperties INIT {"cAviFile", ;
                               "lStretch", ;
                               "nAlign",   ;
                               "nHeight",  ;
                               "nLeft",    ;
                               "nTop",     ;
                               "nWidth" }
  /*Posibles valores del estado del dispositivo

   CLASSDATA aState      INIT {"not ready", ;
                               "paused", ;
                               "playing",   ;
                               "stopped"} */
   DATA   cAviFile
   DATA   cBuffer
   DATA   lxStretch
   DATA   cStatus
   METHOD New( nRow, nCol, nWidth, nHeight, cFileName, oWnd,;
               bWhen, bValid, lNoBorder ) CONSTRUCTOR

   METHOD ReDefine( nId, cFileName, oDlg, bWhen, bValid ) CONSTRUCTOR

   METHOD Initiate( hDlg )

   // Si esta en pausa y pulso PLay Continuo, sino empiezo desde el principio
   METHOD Play( nFrom, nTo ) INLINE  (::Status(),;
                             IF( ::cStatus == "paused", ::Resume(),;
                                                         mciSendStr("PLAY VIDEO FROM 0",@cBuffer,::oWnd:hWnd)))

   METHOD Stop() INLINE mciSendStr("STOP VIDEO",@cBuffer,::oWnd:hWnd)

   // Si pulso pausa, paro, y si esta pausado, reproduzco.
   METHOD Pause() INLINE (::Status(),;
                           IF( ::cStatus == "playing", mciSendStr("PAUSE VIDEO",@cBuffer,::oWnd:hWnd),;
                         ( IF( ::cStatus == "paused", ::Resume(), ) ) ) )

   METHOD Resume() INLINE mciSendStr("RESUME VIDEO",@cBuffer,::oWnd:hWnd)

   METHOD Status() INLINE ( mciSendStr( "STATUS VIDEO MODE",@cBuffer,::oWnd:hWnd),::cStatus := cBuffer )

   METHOD Inspect ( cData )

   METHOD OpenFile()

   METHOD lStretch( lNewVal ) SETGET

   METHOD Foward( nPistas )
   METHOD Rewind( nPistas )
   METHOD End()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, nWidth, nHeight, cFileName, oWnd, lNoBorder ) CLASS TVideo

   DEFAULT nRow := 10, nCol := 10, nWidth := 200, nHeight := 200,;
           cFileName := "", oWnd := oApp:oAuxForm, lNoBorder := .f.

   cBuffer := space( 200 )

   ::nTop      = nRow //*  VID_CHARPIX_H  // 8
   ::nLeft     = nCol //* VID_CHARPIX_W   // 14
   ::nBottom   = ::nTop  + nHeight - 1
   ::nRight    = ::nLeft + nWidth + 1
   ::nStyle    = nOR( WS_CHILD, WS_VISIBLE, WS_TABSTOP, If( ! lNoBorder, WS_BORDER, 0 ) )
   ::nId       = ::GetNewId()
   ::oWnd      = oWnd
   ::cAviFile  = cFileName
   *::oMci      = TMci():New( "avivideo", cFileName )
   ::lDrag     = .f.
   ::lCaptured = .f.
   ::lxStretch := .f.


   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   if ! Empty( oWnd:hWnd )
      ::Create()
      mciSendStr("OPEN AVIVIDEO!"+Upper(Alltrim(::cAviFile))+" ALIAS VIDEO PARENT "+Alltrim(str(::hWnd)),@cBuffer,::oWnd:hWnd)
      mciSendStr("put video destination at 0 0" +;
            if( ::lStretch, " " + alltrim(str(::nWidth)) + " " +;
                 alltrim(str(::nHeight)),"") ,@cBuffer,::oWnd:hWnd)
      mciSendStr("WINDOW VIDEO HANDLE "+Alltrim(str(::hWnd)),@cBuffer,::oWnd:hWnd)
   else
      oWnd:DefControl( Self )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, cFileName, oDlg, bWhen, bValid ) CLASS TVideo

   ::nId      = nId
   ::cAviFile = cFileName
   ::bWhen    = bWhen
   ::bValid   = bValid
   ::oWnd     = oDlg
   ::oMci     = TMci():New( "avivideo", cFileName )

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   oDlg:DefControl( Self )

return nil

//----------------------------------------------------------------------------//

METHOD Initiate( hDlg ) CLASS TVideo

   Super:Initiate( hDlg )
   ::oMci:lOpen()
   ::oMci:SetWindow( Self )

return nil

//----------------------------------------------------------------------------//

********************************
 METHOD OpenFile()
********************************
 local cFile

    cFile:=cGetFile("Animation File (*.avi) | *.avi",;
                    "Select a Animation File",,cFilePath( ::cAviFile ) )

    mciSendStr("CLOSE VIDEO",@cBuffer,::oWnd:hWnd)

    SysRefresh()

    mciSendStr("OPEN AVIVIDEO!" + Upper(Alltrim(cFile))+;
               " ALIAS VIDEO PARENT " +;
               Alltrim(str(::hWnd)),@cBuffer,::oWnd:hWnd)

    mciSendStr("put video destination at 0 0",@cBuffer,::oWnd:hWnd)

    mciSendStr("WINDOW VIDEO HANDLE "+Alltrim(str(::hWnd)),@cBuffer,::oWnd:hWnd)

    ::cAviFile := cFile

return nil

METHOD Inspect( cData ) CLASS TBitmap

   do case
      case cData == "cAviFile"
           return { | cFileName | ::OpenFile() }
   endcase

return nil

*********************************
   METHOD lStretch( lNewVal )
*********************************

if lNewVal != nil

   ::lxStretch := lNewVal

   // by Thefull
  // ::Stop() Necesario para que el Video se adapte a la MDI en el Resize.

   if lNewVal
      mciSendStr("put video destination at 0 0 " +;
                 alltrim(str(::nWidth)) + " " +;
                 alltrim(str(::nHeight)) ,@cBuffer,::oWnd:hWnd)
   else
      mciSendStr("put video destination at 0 0", @cBuffer,::oWnd:hWnd)
   endif

   ::Refresh()

endif


return ::lxStretch

*********************************
   METHOD Foward( nPistas )
*********************************
local nPista

 * avanza nPistas
 DEFAULT nPistas := 1

   mciSendStr( "STATUS VIDEO CURRENT TRACK", @cBuffer, ::oWnd:hWnd )
   nPista = val( cBuffer )

   mciSendStr("SEEK VIDEO TO " + ltrim ( str( nPista + nPistas )),;
              @cBuffer, ::oWnd:hWnd)

return nil

**************************************
   METHOD Rewind( nPistas )
**************************************

local nPista

 * retrocede nPistas
 DEFAULT nPistas := 1


   mciSendStr( "STATUS VIDEO CURRENT TRACK", @cBuffer, ::oWnd:hWnd )
   nPista = val( cBuffer )

   mciSendStr("SEEK VIDEO TO " + ltrim ( str( nPista - nPistas )),;
              @cBuffer, ::oWnd:hWnd)

return nil

**************************************
   METHOD End( )
//By TheFull
**************************************
   mciSendStr("CLOSE VIDEO",@cBuffer,::oWnd:hWnd)
return .T.