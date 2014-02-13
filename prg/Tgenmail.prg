#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TGenMailing

   DATA oDlg
   DATA oFld

   DATA oMenu

   DATA oBrwClient
   DATA oTree
   DATA oPro
   DATA cPro
   DATA oMtr
   DATA nMtr
   DATA oFlt

   DATA oBtnSiguiente
   DATA oBtnAnterior
   DATA oBtnCancel
   DATA oBtnFilter
   DATA oBtnCargarHTML
   DATA oBtnSalvarHTML
   DATA oBtnDefectoHTML

   DATA oGetAsunto
   DATA oGetAdjunto
   DATA oGetHtml
   DATA oGetMensaje
   DATA oGetDe
   DATA oGetPara
   DATA oGetCopia

   DATA cGetAsunto
   DATA cGetAdjunto
   DATA cGetHtml
   DATA cGetCSS
   DATA cGetMensaje
   DATA cGetDe                         INIT Space( 250 )
   DATA cGetPara                       INIT Space( 250 )
   DATA cGetCopia                      INIT Space( 250 )

   DATA aAdjuntos                      INIT {}

   DATA oActiveX
   DATA cActiveX

   DATA aItems

   DATA aFields
   DATA oField
   DATA aField
   DATA cField

   DATA cTypeDocument

   Method SetAsunto( cText )           INLINE ( ::cGetAsunto   := Padr( cText, 250 ) )
   Method SetAdjunto( cText )          INLINE ( ::cGetAdjunto  := Padr( cText, 250 ) )
   Method SetHtml( cText )             INLINE ( ::cGetHtml     := Padr( cText, 250 ) )
   Method SetDe( cText )               INLINE ( ::cGetDe       := Padr( cText, 250 ) )
   Method SetPara( cText )             INLINE ( ::cGetPara     := Padr( cText, 250 ) )
   Method SetCopia( cText )            INLINE ( ::cGetCopia    := Padr( cText, 250 ) )

   Method AddAdjunto( cText )          INLINE ( aAdd( ::aAdjuntos, cText ) )

   Method SetMensaje( cText )          INLINE ( ::cGetMensaje  += cText )

   Method SetTypeDocument( cText )     INLINE ( ::cTypeDocument   := cText )

   DATA oCmbMensaje
   DATA cCmbMensaje

   DATA cNombre
   DATA cDireccion

   DATA MailServer
   DATA MailServerPort
   DATA MailServerUserName
   DATA MailServerPassword
   DATA MailServerConCopia

   DATA dbfAlias

   DATA cHtml
   DATA lHtml                          INIT .t.

   DATA oMail

   DATA lCancel

   DATA nPaquetes                      INIT 1

   DATA cTiempo                        INIT "0 seg."
   DATA aTiempo                        INIT { "0 seg.", "5 seg.", "10 seg.", "15 seg.", "20 seg.", "25 seg.", "30 seg.", "35 seg.", "40 seg.", "45 seg.", "50 seg.", "55 seg.", "60 seg." }

   Method New()

   Method Create()

   Method Init()

   Method ClientResource( dbfAlias )

   Method InitClientResource()

   Method BotonAnterior()

   Method BotonSiguiente()

   Method SelMailing()

   Method SelAllMailing( lValue )

   Method IniciarEnvio()

   Method lCreateMail()

   Method MailMerge()

   Method ExpresionReplace( cDocumentHTML, cExpresion )

   Method lExternalSendMail()

   Method lSendMail()

   Method lCargaHTML()
   Method lSalvaHTML()
   Method lDefectoHTML()

   Method lEditaCSS()

   Method MailServerSend()    INLINE ( ::MailServer + if( !Empty( ::MailServerPort ), ":" + Alltrim( Str( ::MailServerPort ) ), "" ) )

   Method SelectColumn( oCombo )

   Method GeneralResource()

   Method InsertField()       INLINE ( ::oActiveX:InsertAtCursor( "{" + ValText( Alltrim( ::cField ) ) + "}", 0 ) )

   Method GetAdjunto()

   Method HTMLMenu()

   Method lCheckActiveX()

   Inline Method WaitSeconds( nTime )

      local n

      for n := 1 to nTime

         if ::lCancel
            exit
         end if

         WaitSeconds( 1 )

         SysRefresh()

      next

   Endmethod


END CLASS

//---------------------------------------------------------------------------//

Method New() CLASS TGenMailing

   ::cGetAsunto            := Space( 254 )
   ::cGetAdjunto           := Space( 254 )
   ::cGetHtml              := Space( 254 )

   ::cGetMensaje           := ""
   ::cCmbMensaje           := "Sin formato"

   ::MailServer            := Rtrim( uFieldEmpresa( "cSrvMai" ) )
   ::MailServerPort        := uFieldEmpresa( "nPrtMai" )
   ::MailServerUserName    := Rtrim( uFieldEmpresa( "cCtaMai" ) )
   ::MailServerPassword    := Rtrim( uFieldEmpresa( "cPssMai" ) )
   ::MailServerConCopia    := Rtrim( uFieldEmpresa( "cCcpMai" ) )

Return ( Self )

//---------------------------------------------------------------------------//

Method Create() CLASS TGenMailing

   ::cGetAsunto            := Space( 254 )
   ::cGetAdjunto           := Space( 254 )
   ::cGetHtml              := Space( 254 )

   ::cGetMensaje           := ""
   ::cCmbMensaje           := "Sin formato"

Return ( Self )

//---------------------------------------------------------------------------//

Method Init() CLASS TGenMailing

   ::cGetAsunto            := Space( 254 )
   ::cGetAdjunto           := Space( 254 )
   ::cGetHtml              := Space( 254 )

   ::cGetMensaje           := ""
   ::cCmbMensaje           := "Sin formato"

   ::MailServer            := Rtrim( uFieldEmpresa( "cSrvMai" ) )
   ::MailServerPort        := uFieldEmpresa( "nPrtMai" )
   ::MailServerUserName    := Rtrim( uFieldEmpresa( "cCtaMai" ) )
   ::MailServerPassword    := Rtrim( uFieldEmpresa( "cPssMai" ) )
   ::MailServerConCopia    := Rtrim( uFieldEmpresa( "cCcpMai" ) )

   ::SetDe( uFieldEmpresa( "cNombre" ) )

Return ( Self )

//---------------------------------------------------------------------------//

Method ClientResource( dbfAlias, aItems, oWndBrw ) CLASS TGenMailing

   local cTag
   local nRecno
   local oGetOrd
   local oCbxOrd
   local cGetOrd           := Space( 100 )
   local cCbxOrd           := "Código"
   local aCbxOrd           := { "Código", "Nombre", "Correo electrónico" }
   local oBmpGeneral
   local oBmpClient
   local oBmpProcess

   ::Init()

   if Empty( ::MailServer ) .or. Empty( ::MailServerUserName ) .or. Empty( ::MailServerPassword )
      MsgStop( "Debe cumplimentar servidor y cuenta de correos," + CRLF + "en configurar empresa." )
      ConfEmpresa( oWnd(), , 7 )
   end if

   if !::lCheckActiveX()
      MsgStop( "No existe el editor HTML." )
      Return ( Self )
   end if

   ::lCancel         := .f.
   ::aItems          := aItems
   ::dbfAlias        := dbfAlias

   ::aFields         := ::oFlt:aTblMask

   cTag              := ( ::dbfAlias )->( OrdSetFocus() )
   nRecno            := ( ::dbfAlias )->( RecNo() )

   ( ::dbfAlias )->( dbGoTop() )

   DEFINE DIALOG ::oDlg RESOURCE "SelectMail_0"

      REDEFINE PAGES ::oFld ;
         ID       10;
         OF       ::oDlg ;
         DIALOGS  "SelectMail_2",;
                  "SelectMail_1",;
                  "Internet_4"

      /*
      Bitmap-------------------------------------------------------------------
		*/

      REDEFINE BITMAP oBmpGeneral ;
         ID       500 ;
         RESOURCE "Mail_earth_48_alpha" ;
         TRANSPARENT ;
         OF       ::oFld:aDialogs[ 1 ]

      /*
      Segunda caja de dialogo--------------------------------------------------
      */

      REDEFINE GET ::oGetDe VAR ::cGetDe ;
         ID       90 ;
         OF       ::oFld:aDialogs[ 1 ]

      REDEFINE GET ::oGetAsunto VAR ::cGetAsunto ;
         ID       100 ;
         OF       ::oFld:aDialogs[ 1 ]

      REDEFINE GET ::oGetAdjunto VAR ::cGetAdjunto ;
         ID       110 ;
         OF       ::oFld:aDialogs[ 1 ]

      ::oGetAdjunto:cBmp   := "Folder"
      ::oGetAdjunto:bHelp  := {|| ::GetAdjunto() }

      REDEFINE ACTIVEX ::oActiveX ;
         ID       130 ;
         OF       ::oFld:aDialogs[ 1 ] ;
         PROGID   "rmpHTML.HTMLed"

      REDEFINE COMBOBOX ::oField ;
         VAR      ::cField ;
         ITEMS    ::aFields ;
         ID       160 ;
         OF       ::oFld:aDialogs[ 1 ]

      TBtnBmp():ReDefine( 170, "Down16", , , , , {|| ::InsertField() }, ::oFld:aDialogs[ 1 ], .f., , .f., "Insertar campo" )

      /*
      Segunda caja de dialogo--------------------------------------------------
      */

      REDEFINE BITMAP oBmpClient ;
         ID       500 ;
         RESOURCE "Businessman2_Alpha_48" ;
         TRANSPARENT ;
         OF       ::oFld:aDialogs[ 2 ]

      REDEFINE GET oGetOrd ;
         VAR      cGetOrd;
         ID       100 ;
         BITMAP   "FIND" ;
         OF       ::oFld:aDialogs[ 2 ]

      oGetOrd:bChange   := {| nKey, nFlags, oGet | AutoSeek( nKey, nFlags, oGet, ::oBrwClient, ::dbfAlias ) }

      REDEFINE COMBOBOX oCbxOrd ;
         VAR      cCbxOrd ;
         ID       110 ;
         ITEMS    aCbxOrd ;
         OF       ::oFld:aDialogs[ 2 ]

      oCbxOrd:bChange   := {|| ::SelectColumn( oCbxOrd ) }

      REDEFINE BUTTON ::oBtnFilter ;
         ID       120 ;
         OF       ::oFld:aDialogs[ 2 ] ;
         ACTION   ( ::oBrwClient:Refresh() )

      REDEFINE BUTTON ;
         ID       130 ;
         OF       ::oFld:aDialogs[ 2 ] ;
         ACTION   ( ::SelMailing( ::dbfAlias ) )

      REDEFINE BUTTON ;
         ID       140 ;
         OF       ::oFld:aDialogs[ 2 ] ;
         ACTION   ( ::SelAllMailing( .t. ) )

      REDEFINE BUTTON ;
         ID       150 ;
         OF       ::oFld:aDialogs[ 2 ] ;
         ACTION   ( ::SelAllMailing( .f. ) )

      ::oBrwClient                 := TXBrowse():New( ::oFld:aDialogs[ 2 ] )

      ::oBrwClient:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwClient:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrwClient:cAlias          := ::dbfAlias

      ::oBrwClient:nMarqueeStyle   := 5

      ::oBrwClient:CreateFromResource( 160 )

      ::oBrwClient:bLDblClick      := {|| ::SelMailing() }

      with object ( ::oBrwClient:AddCol() )
         :cHeader          := "Se. seleccionado"
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( ::dbfAlias )->lMail }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( ::oBrwClient:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "Cod"
         :bEditValue       := {|| ( ::dbfAlias )->Cod }
         :nWidth           := 70
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( ::oBrwClient:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "Titulo"
         :bEditValue       := {|| ( ::dbfAlias )->Titulo }
         :nWidth           := 300
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( ::oBrwClient:AddCol() )
         :cHeader          := "Correo electrónico"
         :cSortOrder       := "cMeiInt"
         :bEditValue       := {|| ( ::dbfAlias )->cMeiInt }
         :nWidth           := 260
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      REDEFINE GET ::nPaquetes ;
         ID       180 ;
         SPINNER ;
         PICTURE  "@E 999" ;
         OF       ::oFld:aDialogs[ 2 ]

      REDEFINE COMBOBOX ::cTiempo ;
         ITEMS    ::aTiempo ;
         ID       170 ;
         OF       ::oFld:aDialogs[ 2 ]

      /*
      Tercera caja de dialogo--------------------------------------------------
      */

      REDEFINE BITMAP oBmpProcess ;
         ID       500 ;
         RESOURCE "Gears_48_alpha" ;
         TRANSPARENT ;
         OF       ::oFld:aDialogs[ 3 ]

      ::oTree     := TTreeView():Redefine( 100, ::oFld:aDialogs[ 3 ] )

      REDEFINE SAY ::oPro ;
         PROMPT   ::cPro ;
         ID       110 ;
         OF       ::oFld:aDialogs[ 3 ]

      REDEFINE METER ::oMtr ;
         VAR      ::nMtr ;
         ID       120 ;
         OF       ::oFld:aDialogs[ 3 ]

      /*
      Botones generales--------------------------------------------------------
      */

      REDEFINE BUTTON ::oBtnCargarHTML ;          // Boton anterior
         ID       40 ;
         OF       ::oDlg ;
         ACTION   ( ::lCargaHTML() )

      REDEFINE BUTTON ::oBtnSalvarHTML ;          // Boton anterior
         ID       50 ;
         OF       ::oDlg ;
         ACTION   ( ::lSalvaHTML() )

      REDEFINE BUTTON ::oBtnAnterior ;          // Boton anterior
         ID       20 ;
         OF       ::oDlg ;
         ACTION   ( ::BotonAnterior() )

      REDEFINE BUTTON ::oBtnSiguiente ;         // Boton de Siguiente
         ID       30 ;
         OF       ::oDlg ;
         ACTION   ( ::BotonSiguiente() )

      REDEFINE BUTTON ::oBtnCancel ;            // Boton de Siguiente
         ID       IDCANCEL ;
         OF       ::oDlg ;
         ACTION   ( ::oDlg:End() )

   ::oDlg:bStart  := {|| ::oBtnAnterior:Hide() }

   ::oDlg:Activate( , , , .t., , , {|| ::InitClientResource()} )

   ( ::dbfAlias )->( dbGoTo( nRecno ) )
   ( ::dbfAlias )->( OrdSetFocus( cTag ) )

   oWndBrw:Refresh()

   if !Empty( ::oActiveX )
      ::oActiveX:Destroy()
   end if

   if !Empty( oBmpGeneral )
      oBmpGeneral:End()
   end if

   if !Empty( oBmpGeneral )
      oBmpGeneral:End()
   end if

   if !Empty( oBmpClient )
      oBmpClient:End()
   end if

   if !Empty( oBmpProcess )
      oBmpProcess:End()
   end if

   ::oActiveX     := nil

Return ( Self )

//--------------------------------------------------------------------------//

Method InitClientResource() CLASS TGenMailing

   local oError
   local oBlock
   local cHtmlDocument

   if Empty( ::oActiveX )
      MsgStop( "No se ha podido instanciar el control." )
      Return ( Self )
   end if

   oBlock                                       := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::oActiveX:AlwaysConvertUnicodeCharacters    := .f.
   ::oActiveX:DocumentHTML                      := ::cGetMensaje
   ::oActiveX:LocalizationFile                  := fullcurdir() + "Spanish.xml"
   ::oActiveX:LocalImageStore                   := fullcurdir()
   ::oActiveX:BorderStyle                       := 0

   ::oActiveX:ShowFTPDialog                     := .t.

   ::oActiveX:CSShttp                           := .t.
   ::oActiveX:CSSText                           := "file:///" + fullcurdir( .t. ) + "Styles.css" // memoread( fullcurdir() + "Styles.css" ) //

   ::oActiveX:ShowDOMToolbar                    := .t.
   ::oActiveX:ShowFormattingToolbar1            := .t.
   ::oActiveX:ShowFormattingToolbar2            := .t.

   /*
   ::oActiveX:ShowFormToolbar                   := .t.
   */

   if !Empty( uFieldEmpresa( "cHstFtpImg" ) )
      ::oActiveX:FTPHost                        := uFieldEmpresa( "cHstFtpImg" )
      ::oActiveX:FTPPassive                     := uFieldEmpresa( "lPasFtp" )
      ::oActiveX:FTPUser                        := uFieldEmpresa( "cUsrFtpImg" )
      ::oActiveX:FTPPassword                    := uFieldEmpresa( "cPswFtpImg" )
      ::oActiveX:FTPSaveToURL                   := uFieldEmpresa( "cdImagen" )
      ::oActiveX:RelativeURLs                   := .t.

      /*
      ::oActiveX:FTPInitDirectory               :=
      */

   end if

   ::HTMLMenu()

   if !Empty( ::cTypeDocument )
      cHtmlDocument                             := cGetHtmlDocumento( ::cTypeDocument )
      if !Empty( cHtmlDocument )
         ::lCargaHtml( cHtmlDocument )
      end if
   end if

   RECOVER USING oError

     msgStop( "Error al instanciar el control." + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

  ErrorBlock( oBlock )

Return ( Self )

//--------------------------------------------------------------------------//

Method lSalvaHtml() CLASS TGenMailing

   local cHtmlFile   := cGetFile( 'Html ( *.Html ) | *.Html', 'Seleccione el nombre del fichero' )

   if !( Lower( cFileExt( cHtmlFile ) ) $ "html" )
      cHtmlFile      := cFilePath( cHtmlFile ) + cFileNoExt( cHtmlFile ) + ".Html"
   endif

   if file( cHtmlFile )
      fErase( cHtmlFile )
   end if

   ::oActiveX:Save_Document( cHtmlFile )

   /*
   if ::oActiveX:CountLocalImages() > 0
      if ApoloMsgNoYes( "¿Desea subir las imagenes locales, antes de continuar?", "Salvar en servidor web" )
         ::oActiveX:UploadAllImages()
      end if
   end if

   ::oActiveX:DocumentTitle   := "This is document title"
   // ::oActiveX:Error           := {|n,c| msginfo( Str( n ) + ":" + c )}

   if ::oActiveX:PutFileFTP( "C:\Temp.html", "news0034.html" ) // /public_html/news/
      msginfo( "salvado" )
      WinExec( "Start " + Alltrim( ::oActiveX:FTPSaveToURL ) + "news0034.html", 0 )
   end if
   */

Return ( Self )

//--------------------------------------------------------------------------//

Method GetAdjunto() CLASS TGenMailing

   local cFile                         := cGetFile( 'Fichero ( *.* ) | *.*', 'Seleccione el fichero a adjuntar' )

   if !Empty( cFile )

      if !Empty( ::cGetAdjunto )
         cFile                         := Alltrim( ::cGetAdjunto ) + "; " + cFile
      end if

      ::oGetAdjunto:cText( cFile )

   end if

Return ( Self )

//--------------------------------------------------------------------------//

Method SelectColumn( oCombo ) CLASS TGenMailing

   local oCol
   local cOrd                    := oCombo:VarGet()

   if ::oBrwClient != nil

      with object ::oBrwClient

         for each oCol in :aCols

            if Eq( cOrd, oCol:cHeader )
               oCol:cOrder       := "A"
               oCol:SetOrder()
            else
               oCol:cOrder       := " "
            end if

         next

      end with

      ::oBrwClient:Refresh()

   end if

Return ( Self )

//---------------------------------------------------------------------------//

Method BotonAnterior() CLASS TGenMailing

   do case
      case ::oFld:nOption == 2

         ::oBtnAnterior:Hide()

         ::oBtnCargarHTML:Show()
         ::oBtnSalvarHTML:Show()

         ::oFld:GoPrev()

         SetWindowText( ::oBtnSiguiente:hWnd, "Siguien&te >" )

      case ::oFld:nOption == 3

         ::oFld:GoPrev()

   end case

Return ( Self )

//--------------------------------------------------------------------------//

Method BotonSiguiente() CLASS TGenMailing

   do case
      case ::oFld:nOption == 1

         ::oBtnCargarHTML:Hide()
         ::oBtnSalvarHTML:Hide()

         ::oFld:GoNext()

         ::oBtnAnterior:Show()

         SetWindowText( ::oBtnSiguiente:hWnd, "&Terminar" )

      case ::oFld:nOption == 2

         ::oFld:GoNext()

         ::oBtnAnterior:Show()

         ::oBtnCargarHTML:Disable()
         ::oBtnSalvarHTML:Disable()

         ::oBtnAnterior:Disable()
         ::oBtnSiguiente:Disable()

         ::IniciarEnvio()

         ::oBtnCargarHTML:Enable()
         ::oBtnSalvarHTML:Enable()

         ::oBtnAnterior:Enable()
         ::oBtnSiguiente:Enable()

         SetWindowText( ::oBtnCancel:hWnd, "&Cerrar" )

   end case

Return ( Self )

//--------------------------------------------------------------------------//

Method SelMailing() CLASS TGenMailing

   if dbDialogLock( ::dbfAlias )
      ( ::dbfAlias )->lMail := !( ::dbfAlias )->lMail
      ( ::dbfAlias )->( dbUnlock() )
   end if

   ::oBrwClient:Refresh()
   ::oBrwClient:SetFocus()

Return ( Self )

//--------------------------------------------------------------------------//

Method SelAllMailing( lValue ) CLASS TGenMailing

   local nRecno

   DEFAULT lValue := .t.

	CursorWait()

   nRecno         := ( ::dbfAlias )->( RecNo() )

   ( ::dbfAlias )->( dbGoTop() )

   while !( ::dbfAlias )->( eof() )

      if dbDialogLock( ::dbfAlias )
         ( ::dbfAlias )->lMail := lValue
         ( ::dbfAlias )->( dbUnlock() )
      end if

      ( ::dbfAlias )->( dbSkip() )

   end do

   ( ::dbfAlias )->( dbGoTo( nRecno ) )

	CursorArrow()

   ::oBrwClient:Refresh()
   ::oBrwClient:SetFocus()

Return ( Self )

//--------------------------------------------------------------------------//

Method IniciarEnvio() CLASS TGenMailing

   local nTime
   local lFirst
   local nPaquetes      := 1
   local nRecno         := ( ::dbfAlias )->( RecNo() )

   nTime                := Val( ::cTiempo )
   lFirst               := .t.

   /*
   Información por pantalla----------------------------------------------------
   */

   ::oTree:Add( "Se ha iniciado el proceso de envio" )

   ::oBtnCancel:bAction := {|| ::lCancel := .t. }

	CursorWait()

   /*
   Actualizamos el meter-------------------------------------------------------
   */

   ::oMtr:nTotal        := ( ::dbfAlias )->( OrdKeyCount() )

   ( ::dbfAlias )->( dbGoTop() )
   while !::lCancel .and. !( ::dbfAlias )->( eof() )

      if ( ::dbfAlias )->lMail .and. !Empty( ( ::dbfAlias )->cMeiInt )

         if ::lCreateMail()

            /*
            Esperamos para q el servidor no se agobie--------------------------
            */

            if ( !lFirst ) .and. ( nTime != 0 ) .and. ( !( ::dbfAlias )->( eof() ) )

               ::oTree:Select( ::oTree:Add( "Envio " + Alltrim( Str( ( ::dbfAlias )->( OrdKeyNo() ) ) ) + " de " + Alltrim( Str( ::oMtr:nTotal ) ) ) )

               if nPaquetes >= ::nPaquetes

                  ::oTree:Select( ::oTree:Add( "Esperando " + ::cTiempo + "para proximo envio" ) )

                  ::WaitSeconds( nTime )

                  nPaquetes   := 1

               else

                  nPaquetes++

               end if

            end if

            ::lSendMail()

            ::oMail     := nil

            lFirst      := .f.

         end if

      end if

      ( ::dbfAlias )->( dbSkip() )

      ::oMtr:Set( ( ::dbfAlias )->( OrdKeyNo() ) )

   end do

   ( ::dbfAlias )->( dbGoTo( nRecno ) )

   CursorArrow()

   if ::lCancel
      ::oTree:Select( ::oTree:Add( "El envio ha sido cancelado por el usuario" ) )
   else
      ::oTree:Select( ::oTree:Add( "El proceso de envio ha finalizado" ) )
   end if

   ::oBtnCancel:bAction := {|| ::oDlg:End() }

Return ( Self )

//--------------------------------------------------------------------------//

Method lCargaHtml( cFile ) CLASS TGenMailing

   local hFile
   local oBlock
   local nBytes
   local nStart
   local cMensaje    := ""
   local nBufSize    := 4096
   local cRead       := Space( nBufSize )

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if File( cFile )

      ::cGetHtml     := Rtrim( cFile )

   else

      if Empty( cFile )

         ::cGetHtml  := cGetFile( 'Html (*.html, *.htm) |*.html;*.htm|', 'Seleccione el fichero HTML' )
         ::cGetHtml  := Rtrim( ::cGetHtml )

      end if

   end if

   if File( ::cGetHtml )  // !Empty( ::oActiveX )

      if !Empty( ::oActiveX )

         ::oActiveX:Open_Document( ::cGetHTML )

      else

         cMensaje          := ""

         if !Empty( ::cGetHtml ) .and. File( ::cGetHtml )

            hFile          := fOpen( ::cGetHtml )

            if fError() != 0

               MsgStop( "Error abriendo el fichero " + ::cGetHtml )

            else

               while ( nBytes := fRead( hFile, @cRead, nBufSize ) ) > 0
                  cMensaje += SubStr( cRead, 1, nBytes )
               end while

               fClose( hFile )

            end if

            // Solo nos quedamos con lo que hay entre etiquetas <Html----------------

            nStart         := At( "<HTML", Upper( cMensaje ) )
            if nStart != 0
               cMensaje    := SubStr( cMensaje, nStart )
            end if

         end if

         ::cGetMensaje     := cMensaje

      end if

   end if

   RECOVER

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( Self )

//--------------------------------------------------------------------------//

Method lDefectoHtml( cFile ) CLASS TGenMailing

   if !Empty( ::cGetHtml )
      if ApoloMsgNoYes( "¿Desea establecer el documento " + Rtrim( ::cGetHtml ) + " como documento por defecto?", "Confirme" )
         cSetHtmlDocumento( ::cTypeDocument, ::cGetHtml )
      end if
   else
      MsgInfo( "No ha documentos para establecer por defecto" )
   end if

Return ( Self )

//--------------------------------------------------------------------------//

Method lEditaCSS() CLASS TGenMailing

   local oBlock

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ShellExecute( ::oDlg:hWnd, "open", fullcurdir() + "Styles.css" )

   RECOVER

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( Self )

//--------------------------------------------------------------------------//

Method lCreateMail() CLASS TGenMailing

   local oError
   local oBlock
   local lCreateMail             := .t.

   oBlock                        := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::oMail                    := CreateObject( "JMail.Message" )

   RECOVER USING oError

      WaitRun( "regsvr32 /s " + FullcurDir() + "JMail.Dll" )

      ::oMail                    := CreateObject( "JMail.Message" )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !Empty( ::oMail )

      ::oMail:Logging            := .t.
      ::oMail:Silent             := .t.

      ::oMail:MailServerUserName := ::MailServerUserName
      ::oMail:MailServerPassword := ::MailServerPassword

      ::oMail:From               := ::MailServerUserName
      ::oMail:FromName           := Rtrim( ::cGetDe )
      ::oMail:Subject            := Rtrim( ::cGetAsunto )

      if ::lHtml

         if !Empty( ::oActiveX )

            ::MailMerge()

         else

            ::oMail:AppendHTML( Rtrim( ::cGetMensaje ) )

         end if

      else

         ::oMail:Body            := ::cGetMensaje

      end if

   else

      msgStop( "Error al crear objeto para envio de correo electrónico." )

   end if

Return ( lCreateMail )

//--------------------------------------------------------------------------//

Method MailMerge()  CLASS TGenMailing

   local nScan
   local nAtInit           := 0
   local nAtEnd            := 0
   local cExpresion        := ""
   local cDocumentHTML     := ::oActiveX:DocumentHTML

   while .t.

      nAtInit              := At( "{", cDocumentHTML )

      if nAtInit != 0

         nAtEnd            := At( "}", cDocumentHTML )

         if nAtEnd != 0

            cExpresion     := SubStr( cDocumentHTML, nAtInit, ( nAtEnd - nAtInit ) + 1 )

            ::ExpresionReplace( @cDocumentHTML, cExpresion )

         else

            exit

         end if

      else

         exit

      end if

   end while

   ::oMail:AppendHTML( cDocumentHTML )

Return ( Self )

//--------------------------------------------------------------------------//

Method ExpresionReplace( cDocumentHTML, cExpresion ) CLASS TGenMailing

   local nScan
   local cExpresionToSearch

   cExpresionToSearch      := Alltrim( SubStr( cExpresion, 2, len( cExpresion ) - 2 ) )

   if ( "()" $ cExpresionToSearch )

      cDocumentHTML        := StrTran( cDocumentHTML, cExpresion, cValToText( Eval( bChar2Block( cExpresionToSearch ) ) ) )

   else

      nScan                := aScan( ::aItems, {|a| ValText( a[ 5 ] ) == cExpresionToSearch .or. ValText( a[ 5 ] ) == HtmlEntities( cExpresionToSearch ) } )
      if nScan != 0
         cDocumentHTML     := StrTran( cDocumentHTML, cExpresion, cValToChar( ( ::dbfAlias )->( Eval( Compile( ::aItems[ nScan, 1 ] ) ) ) ) )
      else
         cDocumentHTML     := StrTran( cDocumentHTML, cExpresion, "" )
      end if

   end if

Return ( Self )

//--------------------------------------------------------------------------//

Method lSendMail()  CLASS TGenMailing

   local oError
   local oBlock
   local lSendMail         := .t.

   if Empty( uFieldEmpresa( "cSrvMai" ) ) .or. Empty( uFieldEmpresa( "cCtaMai" ) )
      Return ( .f. )
   end if

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::oMail:AddRecipient( Rtrim( ( ::dbfAlias )->cMeiInt ) )

      if File( Rtrim( ::cGetAdjunto ) )
         ::oMail:AddAttachment( Rtrim( ::cGetAdjunto ) )
      end if

      lSendMail            := ::oMail:Send( ::MailServerSend() )

      if lSendMail
         ::oTree:Select( ::oTree:Add( "Cliente " + Rtrim( ( ::dbfAlias )->Titulo ) + "<" + Rtrim( ( ::dbfAlias )->cMeiInt ) + "> enviado satisfactoriamente" ) )
      else
         ::oTree:Select( ::oTree:Add( "Cliente " + Rtrim( ( ::dbfAlias )->Titulo ) + "<" + Rtrim( ( ::dbfAlias )->cMeiInt ) + "> no enviado" ) )
         ::oTree:Select( ::oTree:Add( "Error : " + ::oMail:ErrorMessage ) )
         ::oTree:Select( ::oTree:Add( "Error : " + ::oMail:ErrorSource ) )
      end if

      SysRefresh()

   RECOVER USING oError

      msgStop( "Error al enviar correo electrónico." + CRLF + CRLF + ErrorMessage( oError ) )

      lSendMail            := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lSendMail )

//--------------------------------------------------------------------------//

Method lExternalSendMail( lMessage )  CLASS TGenMailing

   local oError
   local oBlock
   local cDireccion
   local lSendMail         := .t.

   DEFAULT lMessage        := .f.

   if Empty( ::MailServer ) .or. Empty( ::MailServerUserName ) .or. Empty( ::MailServerPassword )
      MsgStop( "Debe cumplimentar servidor y cuenta de correos," + CRLF + ;
               "en configurar empresa." )
      Return ( .f. )
   end if

   if Empty( ::cGetPara ) .and. Empty( ::cDireccion )
      MsgStop( "Debe incluir al menos una dirección de correo electrónico." )
      Return ( .f. )
   end if

   CursorWait()

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if ::lCreateMail()

      if !Empty( ::cDireccion )
         for each cDireccion in hb_aTokens( ::cDireccion, ";" )
            ::oMail:AddRecipient( cDireccion )
         next
      end if

      if !Empty( ::cGetPara )
         for each cDireccion in hb_aTokens( ::cGetPara, ";" )
            ::oMail:AddRecipient( cDireccion )
         next
      end if

      if !Empty( ::cGetCopia )
         for each cDireccion in hb_aTokens( ::cGetCopia, ";" )
            ::oMail:AddRecipientBCC( cDireccion )
         next
      end if

      if File( Rtrim( ::cGetAdjunto ) )
         ::oMail:AddAttachment( Rtrim( ::cGetAdjunto ) )
      end if

      lSendMail            := ::oMail:Send( ::MailServerSend() )

      if !lSendMail
         MsgStop( "Error al enviar correo electrónico." + CRLF + CRLF + ::oMail:ErrorMessage )
      else
         if lMessage
            MsgInfo( "Mensaje enviado satisfactoriamente." )
         end if
      end if

   end if

   RECOVER USING oError

      msgStop( "Error al enviar correo electrónico." + CRLF + CRLF + ErrorMessage( oError ) )

      lSendMail            := .f.

   END SEQUENCE
   ErrorBlock( oBlock )

   CursorWE()

Return ( lSendMail )

//--------------------------------------------------------------------------//

FUNCTION SelLabel( oFlt, oBtnFilter )

   oFlt:Resource()

   if oFlt:cExpresionFilter != nil .and. oBtnFilter != nil
      SetWindowText( oBtnFilter:hWnd, "Filtro activo" )
   else
      SetWindowText( oBtnFilter:hWnd, "Filtrar" )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION PutLabel( dbfArticulo, oBrw )

   if dbDialogLock( dbfArticulo )
      ( dbfArticulo )->lLabel := !( dbfArticulo )->lLabel
      ( dbfArticulo )->( dbUnlock() )
   end if

   oBrw:Refresh()
	oBrw:SetFocus()

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION AddLabel( dbfArticulo, oBrw )

   IF ( dbDialogLock( dbfArticulo ) )
      ( dbfArticulo )->nLabel++
		( dbfArticulo )->( dbUnlock() )
	END IF

   oBrw:Refresh()
	oBrw:SetFocus()

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION DelLabel( dbfArticulo, oBrw )

   if ( dbDialogLock( dbfArticulo ) ) .and. ( dbfArticulo )->nLabel > 1
      ( dbfArticulo )->nLabel--
		( dbfArticulo )->( dbUnlock() )
   end if

   oBrw:Refresh()
	oBrw:SetFocus()

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION ResLabel( dbfArticulo, oBrw, oMtr )

	local n			:= 0
	local nRecno 	:= (dbfArticulo)->( RecNo() )

	CursorWait()

   ( dbfArticulo )->( dbGoTop() )

   while !( dbfArticulo )->( eof() )

      if ( ( dbfArticulo )->lLabel .or. ( dbfArticulo )->nLabel != 2 ) .AND. dbDialogLock( dbfArticulo )
         ( dbfArticulo )->lLabel := .f.
         ( dbfArticulo )->nLabel := 1
			( dbfArticulo )->( dbUnlock() )
      end if

      ( dbfArticulo )->( dbSkip() )

      if oMtr != nil
         oMtr:Set( ++n )
      end if

   end do

   ( dbfArticulo )->( dbGoTo( nRecno ) )

	oBrw:refresh()

   if oMtr != NIL
		oMtr:Set( 0 )
		oMtr:refresh()
   end if

	CursorArrow()

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION EdtLabel( dbfArticulo, oLbx )

   local cPic     := "999"
   local uVar     := ( dbfArticulo )->nLabel
   local bValid   := { || .T. }

   if oLbx:lEditCol( 4, @uVar, cPic, bValid )

      if dbDialogLock( dbfArticulo )
         ( dbfArticulo )->nLabel := uVar
         ( dbfArticulo )->( dbUnlock() )
      end if

      oLbx:DrawSelect()

   end if

RETURN NIL

//--------------------------------------------------------------------------//

Method GeneralResource( dbfAlias, aItems ) CLASS TGenMailing

   local cTag
   local nRecno
   local oBmpGeneral

   if Empty( ::MailServer ) .or. Empty( ::MailServerUserName ) .or. Empty( ::MailServerPassword )
      MsgStop( "Debe cumplimentar servidor y cuenta de correos," + CRLF + "en configurar empresa." )
      ConfEmpresa( oWnd(), , 7 )
   end if

   if !::lCheckActiveX()
      MsgStop( "No existe el editor HTML." )
      Return ( Self )
   end if

   if !Empty( aItems )
      ::aItems    := aItems
   end if

   if !Empty( dbfAlias )
      ::dbfAlias  := dbfAlias
      cTag        := ( ::dbfAlias )->( OrdSetFocus() )
      nRecno      := ( ::dbfAlias )->( RecNo() )
   end if

   if !Empty( aItems ) .and. !Empty( dbfAlias )
      ::aFields   := GetSubArray( aItems, 5 ) //aArray, nPos )::oFlt:aTblMask
   end if

   DEFINE DIALOG ::oDlg RESOURCE "SendDocumentoMail"

      REDEFINE BITMAP oBmpGeneral ;
         ID       500 ;
         RESOURCE "Mail_earth_48_alpha" ;
         TRANSPARENT ;
         OF       ::oDlg

      /*
      Segunda caja de dialogo--------------------------------------------------
      */

      REDEFINE GET ::oGetDe VAR ::cGetDe ;
         ID       90 ;
         OF       ::oDlg

      REDEFINE GET ::oGetPara VAR ::cGetPara ;
         ID       120 ;
         OF       ::oDlg

      REDEFINE GET ::oGetAsunto VAR ::cGetAsunto ;
         ID       100 ;
         OF       ::oDlg

      REDEFINE GET ::oGetAdjunto VAR ::cGetAdjunto ;
         ID       110 ;
         OF       ::oDlg

      REDEFINE GET ::oGetCopia VAR ::cGetCopia ;
         ID       150 ;
         OF       ::oDlg

      ::oGetAdjunto:cBmp   := "Folder"
      ::oGetAdjunto:bHelp  := {|| ::oGetAdjunto:cText( cGetFile( 'Fichero ( *.* ) | *.*', 'Seleccione el fichero a adjuntar' ) ) }

      TBtnBmp():ReDefine( 140, "Document_16",,,,,{|| ShellExecute( ::oDlg:hWnd, "open", Rtrim( ::cGetAdjunto ) ) }, ::oDlg, .f., , .f.,  )

      REDEFINE COMBOBOX ::oField ;
         VAR      ::cField ;
         ITEMS    ::aFields ;
         ID       160 ;
         OF       ::oDlg

      TBtnBmp():ReDefine( 170, "Down16", , , , , {|| ::InsertField() }, ::oDlg, .f., , .f., "Insertar campo" )

      REDEFINE ACTIVEX ::oActiveX ;
         ID       130 ;
         OF       ::oDlg ;
         PROGID   "rmpHTML.HTMLed"

      /*
      Botones generales--------------------------------------------------------
      */

      REDEFINE BUTTON ::oBtnCargarHTML ;          // Boton anterior
         ID       40 ;
         OF       ::oDlg ;
         ACTION   ( ::lCargaHTML() )

      REDEFINE BUTTON ::oBtnSalvarHTML ;          // Boton anterior
         ID       50 ;
         OF       ::oDlg ;
         ACTION   ( ::lSalvaHTML() )

      REDEFINE BUTTON ::oBtnDefectoHTML ;          // Boton anterior
         ID       60 ;
         OF       ::oDlg ;
         WHEN     ( !Empty( ::cGetHtml ) ) ;
         ACTION   ( ::lDefectoHTML() )

      REDEFINE BUTTON ;          // Boton anterior
         ID       IDOK ;
         OF       ::oDlg ;
         ACTION   ( ::lExternalSendMail( .t. ), ::oDlg:End() )

      REDEFINE BUTTON ;            // Boton de Siguiente
         ID       IDCANCEL ;
         OF       ::oDlg ;
         ACTION   ( ::oDlg:End() )

   ::oDlg:Activate( , , , .t., , , {|| ::InitClientResource()} )

   if !Empty( dbfAlias )
      ( dbfAlias )->( dbGoTo( nRecno ) )
      ( dbfAlias )->( OrdSetFocus( cTag ) )
   end if

   if !Empty( ::oActiveX )
      ::oActiveX:Destroy()
   end if

   if !Empty( oBmpGeneral )
      oBmpGeneral:end()
   end if

   ::oActiveX     := nil

Return ( Self )

//--------------------------------------------------------------------------//

Method HTMLMenu() CLASS TGenMailing

   MENU ::oMenu

      MENUITEM "&Archivo"

         MENU

            MENUITEM    "&Abrir HTML";
               MESSAGE  "Abrir un fichero HTML para incorporarlo al editor" ;
               RESOURCE "Folder16" ;
               ACTION   ( ::oActiveX:Open_document() )

            MENUITEM    "&Guardar como ...";
               RESOURCE "BmpExptar16" ;
               MESSAGE  "Guardar fichero HTML" ;
               ACTION   ( ::oActiveX:Save_document() )

            MENUITEM    "Guardar en servidor &web ...";
               MESSAGE  "Guardar fichero HTML en servidor web" ;
               RESOURCE "SndInt16" ;
               ACTION   ( ::lSalvaHtml() )

            SEPARATOR

            MENUITEM    "Editar hoja de estilos CSS ...";
               MESSAGE  "Editar la hoja de estilos CSS para incorporarlo al editor" ;
               RESOURCE "Document_16" ;
               ACTION   ( ::lEditaCSS() )

            MENUITEM    "&Insertar imagen...";
               RESOURCE "BmpExptar16" ;
               MESSAGE  "Insertar imagen" ;
               ACTION   ( ::oActiveX:Insert_Image_NoFTP() )

         ENDMENU

      MENUITEM "&Edición"

         MENU

            MENUITEM    "&Deshacer" + Chr( 9 ) + "Ctrl+Z"   ACTION   ( ::oActiveX:Undo_document() )
            MENUITEM    "&Rehacer"  + Chr( 9 ) + "Ctrl+Y"   ACTION   ( ::oActiveX:Redo_document() )

            SEPARATOR

            MENUITEM    "&Cortar" + Chr( 9 ) + "Ctrl+X"     ACTION   ( ::oActiveX:Cut_document() )
            MENUITEM    "&Copiar" + Chr( 9 ) + "Ctrl+C"     ACTION   ( ::oActiveX:Copy_document() )
            MENUITEM    "&Pegar"  + Chr( 9 ) + "Ctrl+V"     ACTION   ( ::oActiveX:Paste_document() )

         ENDMENU

   ENDMENU

   ::oDlg:SetMenu( ::oMenu )

Return ( ::oMenu )

//---------------------------------------------------------------------------//

Method lCheckActiveX() CLASS TGenMailing

   local oBlock
   local oError
   local lCheck         := .t.
   local oActiveX

   if !File( FullCurDir() + "RmpHTML.ocx" ) .or. !File( FullCurDir() + "RmpHTML.dll" ) .or. !File( FullCurDir() + "AxrmpHTML.dll" )
      Return ( .f. )
   end if

   if !isActiveX( "rmpHTML.HTMLed" )

      oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

         WaitRun( "regsvr32 /s " + FullCurDir() + "RmpHTML.ocx" )
         WaitRun( "regsvr32 /s " + FullCurDir() + "RmpHTML.dll" )
         WaitRun( "regsvr32 /s " + FullCurDir() + "AxrmpHTML.dll" )

      RECOVER USING oError

         msgStop( 'Imposible registrar el editor HTML', ErrorMessage( oError ) )

         lCheck         := .f.

      END SEQUENCE

      ErrorBlock( oBlock )

      lCheck            := isActiveX( "rmpHTML.HTMLed" )

   end if

Return ( lCheck )

//---------------------------------------------------------------------------//

Function lInitHTMEditor()

   local oBlock
   local oError
   local oActiveX

   if !File( FullCurDir() + "RmpHTML.ocx" ) .or. !File( FullCurDir() + "RmpHTML.dll" ) .or. !File( FullCurDir() + "AxrmpHTML.dll" )
      MsgStop( "No existe el componente RmpHTML.Ocx" )
      Return ( .f. )
   end if

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      oActiveX             := CreateObject( "RmpHTML.HTMLed" )

   RECOVER USING oError

      WaitRun( "regsvr32 /s " + FullcurDir() + "RmpHTML.ocx" )
      WaitRun( "regsvr32 /s " + FullCurDir() + "RmpHTML.dll" )
      WaitRun( "regsvr32 /s " + FullCurDir() + "AxrmpHTML.dll" )

      oActiveX             := CreateObject( "RmpHTML.HTMLed" )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !Empty( oActiveX )
      oActiveX             := nil
   end if

Return ( .t. )

//---------------------------------------------------------------------------//

FUNCTION HtmlConvertChars( cString, cQuote_style, aTranslations )

   DEFAULT cQuote_style := "ENT_COMPAT"

   do case
      case cQuote_style == "ENT_COMPAT"
         aAdd( aTranslations, { '"', '&quot;'  } )
      case cQuote_style == "ENT_QUOTES"
         aAdd( aTranslations, { '"', '&quot;'  } )
         aAdd( aTranslations, { "'", '&#039;'  } )
      case cQuote_style == "ENT_NOQUOTES"
   end case

RETURN TranslateStrings( cString, aTranslations )

FUNCTION TranslateStrings( cString, aTranslate )

   local aTran

   for each aTran in aTranslate
      if aTran[ 2 ] in cString
         cString  := StrTran( cString, aTran[ 2 ], aTran[ 1 ] )
      endif
   next

RETURN cString

FUNCTION HtmlEntities( cString, cQuote_style )

   local i
   local aTranslations := {}

   for i := 160 TO 255
      aAdd( aTranslations, { Chr( i ), "&#" + Str( i, 3 ) + ";" } )
   next

RETURN HtmlConvertChars( cString, cQuote_style, aTranslations )

//---------------------------------------------------------------------------//