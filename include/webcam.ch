//----------------------------------------------------------------------------//
  /*                                                                       ---
      Class TWebcam
      Autor   : Lailton Fernando Mariano | 23/08/2010
      Contato : contato@lailton.com.br | www.lailton.com.br
      Objetivo: Capturar Imagem WebCam.
      Arquivos: WebCam.prg, WebCam.ch

  ---                                                                       */
//----------------------------------------------------------------------------//
#ifndef _WEBCAM_CH_
#define _WEBCAM_CH_

#define WEBCAM_TITLE       "TWebCam"
#define WEBCAM_TITLE_ERROR "Error TWebCam"

#define ERR_NO_STARTED      9001
#define ERR_NO_INIT         9002
#define ERR_NO_PAUSE        9003
#define ERR_NO_SAVED        9004
#define ERR_NO_VIDEOCONTROL 9005
#define ERR_NO_VIDEOFORMAT  9006
#define ERR_NO_GETINFO      9007


//----------------------------------------------------------------------------//
#xcommand DEFINE WEBCAM <oWebCam>                                          ;
                 [ FROM <nTop>, <nLeft> TO <nBottom>, <nRight> ]                         ;
                 [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
                 [ <lOn: START> ] ;
                 [ <lAdjust: ADJUST > ];
                 [ ON ERROR <uOnError> ] ;
                 [ RATE <nRate> ] ;
   =>;
                 [ <oWebCam> ] := TWebCam():New( <oWnd>, <nTop>, <nLeft>, <nBottom>, <nRight>, ;
                                  <.lOn.>, <.lAdjust.>, <nRate>, [{|nError|<uOnError>}] )
   
//----------------------------------------------------------------------------//
   
#xcommand @ <nRow>, <nCol> WEBCAM [ <oWebCam> ] ;
                 [ <of:OF, WINDOW, DIALOG> <oWnd> ] ;
                 [ SIZE <nWidth>, <nHeight> ] ; 
                 [ <lOn: START> ] ;
                 [ <lAdjust: ADJUST > ];
                 [ ON ERROR <uOnError> ] ;
                 [ RATE <nRate> ] ;
   =>;
                 [<oWebCam>] := TWebCam():New( <oWnd>, <nRow>, <nCol>, <nWidth>, ;
                                <nHeight>, <.lOn.>, <.lAdjust.>, <nRate>, [{|nError|<uOnError>}] )   
   
   
//----------------------------------------------------------------------------//

#endif