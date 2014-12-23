#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TGenMailing

   DATA oDlg
   DATA oFld

   DATA oMenu

   DATA nView

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
   DATA oGetCopia                      

   DATA oGetPara
   DATA cGetAsunto
   DATA cGetAdjunto
   DATA cGetHtml
   DATA cGetCSS
   DATA cGetMensaje
   DATA cGetDe                         INIT Padr( uFieldEmpresa( "cNombre" ), 250 )
   DATA cGetPara                       INIT Space( 250 )
   DATA cGetCopia                      INIT Padr( uFieldEmpresa( "cCcpMai" ), 250 )

   DATA aAdjuntos                      INIT {}

   DATA oActiveX
   DATA cActiveX

   DATA aItems

   DATA aFields
   DATA oField
   DATA aField
   DATA cField

   DATA cTypeDocument

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

   DATA nPaquetesTotales               INIT 1
   DATA nPaqueteActual                 INIT 1

   DATA nTime

   DATA cTiempo                        INIT "0 seg."
   DATA aTiempo                        INIT { "0 seg.", "5 seg.", "10 seg.", "15 seg.", "20 seg.", "25 seg.", "30 seg.", "35 seg.", "40 seg.", "45 seg.", "50 seg.", "55 seg.", "60 seg." }

   DATA oBmpClient
   DATA oBmpGeneral
   DATA oBmpProcess

   METHOD New()
   METHOD Create()
   METHOD Init()

   METHOD SetAsunto( cText )           INLINE ( ::cGetAsunto   := Padr( cText, 250 ) )
   METHOD SetAdjunto( cText )          INLINE ( ::cGetAdjunto  := Padr( cText, 250 ) )
   METHOD SetHtml( cText )             INLINE ( ::cGetHtml     := Padr( cText, 250 ) )
   METHOD SetDe( cText )               INLINE ( ::cGetDe       := Padr( cText, 250 ) )
   METHOD SetPara( cText )             INLINE ( ::cGetPara     := Padr( cText, 250 ) )
   METHOD SetCopia( cText )            INLINE ( ::cGetCopia    := Padr( cText, 250 ) )
   METHOD SetItems( aItems )           INLINE ( ::aItems       := aItems )

   METHOD AddAdjunto( cText )          INLINE ( aAdd( ::aAdjuntos, cText ) )

   METHOD SetMensaje( cText )          INLINE ( ::cGetMensaje  += cText )
   METHOD GetMensajeHTML()             INLINE ( "<HTML>" + strtran( alltrim( ::cGetMensaje ), CRLF, "<p>" ) + "</HTML>" )

   METHOD SetTypeDocument( cText )     INLINE ( ::cTypeDocument   := cText )

   // Recursos-----------------------------------------------------------------

   METHOD ClientResource()
      METHOD BotonAnterior()
      METHOD BotonSiguiente()

   METHOD Resource()
      METHOD buildPageRedectar( oDlg )
      METHOD buildPageCliente( oDlg )
      METHOD buildPageProceso( oDlg )
      METHOD buildButtonsGeneral()

   METHOD startDialog()

   METHOD freeResources()

   METHOD lCargaHTML()
   METHOD lSalvaHTML()
   METHOD lDefectoHTML()

   METHOD SelMailing()
      METHOD SelAllMailing( lValue )

   METHOD IniciarEnvio()

   METHOD lBuildMail()                 INLINE ( iff( ::lCreateMail(), ( ::waitMail(), ::lSendMail(), ::oMail := nil ), ) )

   METHOD lCreateMail()

   METHOD MailMerge()

   METHOD ExpresionReplace( cDocumentHTML, cExpresion )

   METHOD IsMailServer()               INLINE ( !Empty( ::MailServer ) .and. !Empty( ::MailServerUserName ) .and. !Empty( ::MailServerPassword ) )

   METHOD lSend()                      INLINE ( iif( ::IsMailServer(), ::Resource(), ::outlookDisplayMail() ) )
   METHOD lExternalSend()              INLINE ( iif( ::IsMailServer(), ::lExternalSendMail(), ::outlookSendMail() ) )

   METHOD lExternalSendMail()
   METHOD buildOutlookMail()
   METHOD outlookSendMail()
   METHOD outlookDisplayMail()

   METHOD lSendMail()

   METHOD lEditaCSS()

   METHOD MailServerSend()             INLINE ( ::MailServer + if( !Empty( ::MailServerPort ), ":" + Alltrim( Str( ::MailServerPort ) ), "" ) )

   METHOD SelectColumn( oCombo )

   METHOD InsertField()                INLINE ( ::oActiveX:oClp:SetText( "{" + ( Alltrim( ::cField ) ) + "}" ), ::oActiveX:oRTF:Paste() )

   METHOD GetAdjunto()

   METHOD buildMenuDialog()

   METHOD waitMail()
   METHOD waitSeconds( nTime )

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS TGenMailing

   ::Create()

   ::MailServer            := Rtrim( uFieldEmpresa( "cSrvMai" ) )
   ::MailServerPort        := uFieldEmpresa( "nPrtMai" )
   ::MailServerUserName    := Rtrim( uFieldEmpresa( "cCtaMai" ) )
   ::MailServerPassword    := Rtrim( uFieldEmpresa( "cPssMai" ) )
   ::MailServerConCopia    := Rtrim( uFieldEmpresa( "cCcpMai" ) )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Create() CLASS TGenMailing

   ::cGetAsunto            := Space( 254 )
   ::cGetAdjunto           := Space( 254 )
   ::cGetHtml              := Space( 254 )

   ::cGetMensaje           := ""
   ::cCmbMensaje           := "Sin formato"

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Init() CLASS TGenMailing

   ::New()

   ::SetDe( uFieldEmpresa( "cNombre" ) )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD ClientResource( aItems, nView ) CLASS TGenMailing

   local cTag
   local nRecno

   ::Init()

   ::lCancel         := .f.
   ::aItems          := aItems
   ::nView           := nView

   if !Empty( ::oFlt )
      ::aFields      := ::oFlt:aTblMask
   end if 

   D():getStatusClientes( nView )
   ( D():Clientes( nView ) )->( dbGoTop() )

   DEFINE DIALOG ::oDlg RESOURCE "Select_Mail_Container" OF oWnd()

      REDEFINE PAGES ::oFld ;
         ID          10;
         OF          ::oDlg ;
         DIALOGS     "Select_Mail_Redactar",;
                     "Select_Mail_Registros",;
                     "Internet_4"

         ::buildPageRedectar( ::oFld:aDialogs[ 1 ] )

         ::buildPageCliente( ::oFld:aDialogs[ 2 ] )

         ::buildPageProceso( ::oFld:aDialogs[ 3 ] )

         ::buildButtonsGeneral()

      ::oDlg:bStart  := {|| ::startDialog() }

   ACTIVATE DIALOG ::oDlg CENTER 

   ::freeResources()

   D():setStatusClientes( nView )

Return ( Self )

//--------------------------------------------------------------------------//

METHOD startDialog() CLASS TGenMailing

   if Empty( ::oActiveX )
      MsgStop( "No se ha podido instanciar el control." )
      Return ( Self )
   else 
      ::oActiveX:SetHTML()
   end if

   if !empty(::oBtnAnterior)
      ::oBtnAnterior:Hide()
   end if 

   ::buildMenuDialog()

Return ( Self )

//--------------------------------------------------------------------------//

METHOD buildPageRedectar( oDlg )

   REDEFINE GET ::oGetDe VAR ::cGetDe ;
      ID       90 ;
      OF       oDlg

   REDEFINE GET ::oGetPara VAR ::cGetPara ;
      ID       120 ;
      OF       oDlg

   REDEFINE GET ::oGetAsunto VAR ::cGetAsunto ;
      ID       100 ;
      OF       oDlg

   REDEFINE GET ::oGetAdjunto VAR ::cGetAdjunto ;
      ID       110 ;
      OF       oDlg

   REDEFINE GET ::oGetCopia VAR ::cGetCopia ;
      ID       150 ;
      OF       oDlg

   ::oGetAdjunto:cBmp   := "Folder"
   ::oGetAdjunto:bHelp  := {|| ::oGetAdjunto:cText( cGetFile( 'Fichero ( *.* ) | *.*', 'Seleccione el fichero a adjuntar' ) ) }

   TBtnBmp():ReDefine( 140, "Document_16",,,,,{|| ShellExecute( oDlg:hWnd, "open", Rtrim( ::cGetAdjunto ) ) }, oDlg, .f., , .f.,  )

   REDEFINE COMBOBOX ::oField ;
      VAR      ::cField ;
      ITEMS    ::aFields ;
      ID       160 ;
      OF       oDlg

   TBtnBmp():ReDefine( 170, "Down16", , , , , {|| ::InsertField() }, oDlg, .f., , .f., "Insertar campo" )

   // Componentes-----------------------------------------------------------

   ::oActiveX  := GetRichEdit():ReDefine( 600, oDlg )

Return ( Self )   

//---------------------------------------------------------------------------//

METHOD buildPageCliente( oDlg )

   local oGetOrd
   local oCbxOrd
   local cGetOrd           := Space( 100 )
   local cCbxOrd           := "Código"
   local aCbxOrd           := { "Código", "Nombre", "Correo electrónico" }

   REDEFINE BITMAP ::oBmpClient ;
      ID       500 ;
      RESOURCE "Businessman2_Alpha_48" ;
      TRANSPARENT ;
      OF       oDlg

   REDEFINE GET oGetOrd ;
      VAR      cGetOrd;
      ID       100 ;
      BITMAP   "FIND" ;
      OF       oDlg

   oGetOrd:bChange   := {| nKey, nFlags, oGet | AutoSeek( nKey, nFlags, oGet, ::oBrwClient, D():Clientes( ::nView ) ) }

   REDEFINE COMBOBOX oCbxOrd ;
      VAR      cCbxOrd ;
      ID       110 ;
      ITEMS    aCbxOrd ;
      OF       oDlg

   oCbxOrd:bChange   := {|| ::SelectColumn( oCbxOrd ) }

   REDEFINE BUTTON ;
      ID       130 ;
      OF       oDlg ;
      ACTION   ( ::SelMailing( D():Clientes( ::nView ) ) )

   REDEFINE BUTTON ;
      ID       140 ;
      OF       oDlg ;
      ACTION   ( ::SelAllMailing( .t. ) )

   REDEFINE BUTTON ;
      ID       150 ;
      OF       oDlg ;
      ACTION   ( ::SelAllMailing( .f. ) )

   ::oBrwClient                 := IXBrowse():New( oDlg )

   ::oBrwClient:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwClient:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrwClient:cAlias          := D():Clientes( ::nView )

   ::oBrwClient:nMarqueeStyle   := 5

   ::oBrwClient:CreateFromResource( 160 )

   ::oBrwClient:bLDblClick      := {|| ::SelMailing() }

   with object ( ::oBrwClient:AddCol() )
      :cHeader          := "Se. seleccionado"
      :bStrData         := {|| "" }
      :bEditValue       := {|| ( D():Clientes( ::nView ) )->lMail }
      :nWidth           := 20
      :SetCheck( { "Sel16", "Nil16" } )
   end with

   with object ( ::oBrwClient:AddCol() )
      :cHeader          := "Código"
      :cSortOrder       := "Cod"
      :bEditValue       := {|| ( D():Clientes( ::nView ) )->Cod }
      :nWidth           := 70
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
   end with

   with object ( ::oBrwClient:AddCol() )
      :cHeader          := "Nombre"
      :cSortOrder       := "Titulo"
      :bEditValue       := {|| ( D():Clientes( ::nView ) )->Titulo }
      :nWidth           := 300
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
   end with

   with object ( ::oBrwClient:AddCol() )
      :cHeader          := "Correo electrónico"
      :cSortOrder       := "cMeiInt"
      :bEditValue       := {|| ( D():Clientes( ::nView ) )->cMeiInt }
      :nWidth           := 260
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
   end with

   REDEFINE GET ::nPaquetesTotales ;
      ID       180 ;
      SPINNER ;
      PICTURE  "@E 999" ;
      OF       oDlg

   REDEFINE COMBOBOX ::cTiempo ;
      ITEMS    ::aTiempo ;
      ID       170 ;
      OF       oDlg

Return ( Self )   

//---------------------------------------------------------------------------//

METHOD buildPageProceso( oDlg )

   REDEFINE BITMAP ::oBmpProcess ;
      ID       500 ;
      RESOURCE "Gears_48_alpha" ;
      TRANSPARENT ;
      OF       oDlg

   ::oTree     := TTreeView():Redefine( 100, oDlg )

   REDEFINE SAY ::oPro ;
      PROMPT   ::cPro ;
      ID       110 ;
      OF       oDlg

   REDEFINE APOLOMETER ::oMtr ;
      VAR      ::nMtr ;
      ID       120 ;
      OF       oDlg

Return ( Self )   

//---------------------------------------------------------------------------//

METHOD buildButtonsGeneral()

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

Return ( Self )   

//---------------------------------------------------------------------------//

METHOD freeResources()

   if !Empty( ::oBmpGeneral )
      ::oBmpGeneral:End()
   end if

   if !Empty( ::oBmpProcess )
      ::oBmpProcess:End()
   end if

   if !empty(::oBmpClient)
      ::oBmpClient:end()
   end if 

   if !empty(::oMenu)
      ::oMenu:end()
   end if

   if !empty(::oActiveX)
      ::oActiveX:end()
   end if 

Return ( Self )   

//---------------------------------------------------------------------------//

METHOD lSalvaHtml() CLASS TGenMailing

   local cHtmlFile   := cGetFile( 'Html ( *.Html ) | *.Html', 'Seleccione el nombre del fichero' )

   if !( Lower( cFileExt( cHtmlFile ) ) $ "html" )
      cHtmlFile      := cFilePath( cHtmlFile ) + cFileNoExt( cHtmlFile ) + ".Html"
   endif

   if file( cHtmlFile ) .and. ApoloMsgNoYes( "El fichero " + cHtmlFile + " ya existe. ¿Desea sobreescribir el fichero?", "Guardar fichero" )
      fErase( cHtmlFile )
   else 
      Return ( Self )
   end if

   ::oActiveX:SaveToFile( cHtmlFile )

Return ( Self )

//--------------------------------------------------------------------------//

METHOD GetAdjunto() CLASS TGenMailing

   local cFile                         := cGetFile( 'Fichero ( *.* ) | *.*', 'Seleccione el fichero a adjuntar' )

   if !Empty( cFile )

      if !Empty( ::cGetAdjunto )
         cFile                         := Alltrim( ::cGetAdjunto ) + "; " + cFile
      end if

      ::oGetAdjunto:cText( cFile )

   end if

Return ( Self )

//--------------------------------------------------------------------------//

METHOD SelectColumn( oCombo ) CLASS TGenMailing

   local oCol
   local cOrd                    := oCombo:VarGet()

   if ::oBrwClient != nil

      with object ::oBrwClient

         for each oCol in :aCols

            if Equal( cOrd, oCol:cHeader )
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

METHOD BotonAnterior() CLASS TGenMailing

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

METHOD BotonSiguiente() CLASS TGenMailing

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

METHOD SelMailing( lValue ) CLASS TGenMailing

   DEFAULT lValue := !( D():Clientes( ::nView ) )->lMail

   if dbDialogLock( D():Clientes( ::nView ) )
      ( D():Clientes( ::nView ) )->lMail   := lValue
      ( D():Clientes( ::nView ) )->( dbUnlock() )
   end if

   ::oBrwClient:Refresh()
   ::oBrwClient:SetFocus()

Return ( Self )

//--------------------------------------------------------------------------//

METHOD SelAllMailing( lValue ) CLASS TGenMailing

   local nRecord

   DEFAULT lValue := .t.

	CursorWait()

   nRecord         := ( D():Clientes( ::nView ) )->( recno() )
   ( D():Clientes( ::nView ) )->( dbeval( {|| ::selMailing( lValue ) } ) )
   ( D():Clientes( ::nView ) )->( dbgoto(nRecord) )

	CursorArrow()

Return ( Self )

//--------------------------------------------------------------------------//

METHOD IniciarEnvio() CLASS TGenMailing

   local nRecno         := ( D():Clientes( ::nView ) )->( RecNo() )

   ::nTime              := Val( ::cTiempo )

   ::oBtnCancel:bAction := {|| ::lCancel := .t. }

   /*
   Información por pantalla----------------------------------------------------
   */

   CursorWait()

   ::oTree:Add( "Se ha iniciado el proceso de envio" )

   /*
   Actualizamos el meter-------------------------------------------------------
   */

   ::oMtr:nTotal        := ( D():Clientes( ::nView ) )->( OrdKeyCount() )

   ( D():Clientes( ::nView ) )->( dbGoTop() )
   while !::lCancel .and. !( D():Clientes( ::nView ) )->( eof() )

      if ( D():Clientes( ::nView ) )->lMail .and. !Empty( ( D():Clientes( ::nView ) )->cMeiInt )
         ::lBuildMail()
      end if

      ( D():Clientes( ::nView ) )->( dbSkip() )

      ::oMtr:Set( ( D():Clientes( ::nView ) )->( OrdKeyNo() ) )

   end do

   ( D():Clientes( ::nView ) )->( dbGoTo( nRecno ) )

   CursorArrow()

   if ::lCancel
      ::oTree:Select( ::oTree:Add( "El envio ha sido cancelado por el usuario" ) )
   else
      ::oTree:Select( ::oTree:Add( "El proceso de envio ha finalizado" ) )
   end if

   ::oBtnCancel:bAction := {|| ::oDlg:End() }

Return ( Self )

//--------------------------------------------------------------------------//

METHOD lCargaHtml( cFile ) CLASS TGenMailing

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

      ::cGetMensaje  := memoread( ::cGetHtml )

      if !Empty( ::oActiveX )
         ::oActiveX:oRTF:SetText( ::cGetMensaje )
      end if

   else 

      msgStop( "El fichero " + alltrim( ::cGetHtml ) + " no existe." )

   end if

   RECOVER

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( Self )

//--------------------------------------------------------------------------//

METHOD lDefectoHtml( cFile ) CLASS TGenMailing

   if !Empty( ::cGetHtml )
      if ApoloMsgNoYes( "¿Desea establecer el documento " + Rtrim( ::cGetHtml ) + " como documento por defecto?", "Confirme" )
         cSetHtmlDocumento( ::cTypeDocument, ::cGetHtml )
      end if
   else
      MsgInfo( "No ha documentos para establecer por defecto" )
   end if

Return ( Self )

//--------------------------------------------------------------------------//

METHOD lEditaCSS() CLASS TGenMailing

   local oBlock

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ShellExecute( ::oDlg:hWnd, "open", fullcurdir() + "Styles.css" )

   RECOVER

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( Self )

//--------------------------------------------------------------------------//

METHOD lCreateMail() CLASS TGenMailing

   local oError
   local oBlock
   local lCreateMail             := .t.

   oBlock                        := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::oMail                    := win_oleCreateObject( "JMail.Message" )

   RECOVER USING oError

      WaitRun( "regsvr32 /s " + fullcurDir() + "JMail.Dll" )

      ::oMail                    := win_oleCreateObject( "JMail.Message" )

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

      lCreateMail                := .f.

      msgStop( "Error al crear objeto para envío de correo electrónico." )

   end if

Return ( lCreateMail )

//--------------------------------------------------------------------------//

METHOD MailMerge()  CLASS TGenMailing

   local nScan
   local nAtInit           := 0
   local nAtEnd            := 0
   local cExpresion        := ""
   local cDocumentHTML     := ::oActiveX:GetText()

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

METHOD ExpresionReplace( cDocumentHTML, cExpresion ) CLASS TGenMailing

   local nScan
   local cExpresionToSearch

   cExpresionToSearch      := Alltrim( SubStr( cExpresion, 2, len( cExpresion ) - 2 ) )

   if ( "()" $ cExpresionToSearch )

      cDocumentHTML        := StrTran( cDocumentHTML, cExpresion, cValToText( Eval( bChar2Block( cExpresionToSearch ) ) ) )

   else

      nScan                := aScan( ::aItems, {|a| alltrim( a[ 5 ] ) == cExpresionToSearch .or. alltrim( a[ 5 ] ) == HtmlEntities( cExpresionToSearch ) } )
      if nScan != 0
         cDocumentHTML     := StrTran( cDocumentHTML, cExpresion, cValToChar( ( D():Clientes( ::nView ) )->( Eval( Compile( ::aItems[ nScan, 1 ] ) ) ) ) )
      else
         cDocumentHTML     := StrTran( cDocumentHTML, cExpresion, "" )
      end if

   end if

Return ( Self )

//--------------------------------------------------------------------------//

METHOD lSendMail() CLASS TGenMailing

   local oError
   local oBlock
   local lSendMail         := .t.

   if Empty( uFieldEmpresa( "cSrvMai" ) ) .or. Empty( uFieldEmpresa( "cCtaMai" ) )
      Return ( .f. )
   end if

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::oMail:AddRecipient( Rtrim( ( D():Clientes( ::nView ) )->cMeiInt ) )

      if File( Rtrim( ::cGetAdjunto ) )
         ::oMail:AddAttachment( Rtrim( ::cGetAdjunto ) )
      end if

      lSendMail            := ::oMail:Send( ::MailServerSend() )

      if lSendMail
         ::oTree:Select( ::oTree:Add( "Cliente " + Rtrim( ( D():Clientes( ::nView ) )->Titulo ) + "<" + Rtrim( ( D():Clientes( ::nView ) )->cMeiInt ) + "> enviado satisfactoriamente" ) )
      else
         ::oTree:Select( ::oTree:Add( "Cliente " + Rtrim( ( D():Clientes( ::nView ) )->Titulo ) + "<" + Rtrim( ( D():Clientes( ::nView ) )->cMeiInt ) + "> no enviado" ) )
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

METHOD lExternalSendMail( lMessage )  CLASS TGenMailing

   local oError
   local oBlock
   local cDireccion
   local lSendMail         := .t.

   DEFAULT lMessage        := .f.

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

METHOD buildOutlookMail()

   local oMail
   local lSend          := .f.
   local oRecipient
   local oOutLook

   oOutLook             := win_oleCreateObject( "Outlook.Application" )

   if !empty( oOutLook )

      oMail             := oOutLook:CreateItem( 0 ) // olMailItem 

      // Destinatario----------------------------------------------------------

      oMail:Recipients:Add( ::cGetPara )   

      // Con copia------------------------------------------------------------- 

      oRecipient        := oMail:Recipients:Add( ::cGetCopia )  
      oRecipient:Type   := 2

      // Adjunto--------------------------------------------------------------- 

      oMail:Attachments:Add( ::cGetAdjunto ) 

      // Asunto

      oMail:Subject      := ::cGetAsunto

      // Cuerpo del mensaje

      oMail:BodyFormat  := 2 // olFormatHTML 
      oMail:HTMLBody    := ::GetMensajeHTML()

      // Mostarmos el dialogo de envio

      oMail:Display()

      lSend             := .t.
   
   else
      
      msgStop( "Error. MS Outlook not available.", win_oleErrorText() )

   end if 

RETURN ( oMail )

//--------------------------------------------------------------------------//

METHOD outlookSendMail()
   
   local oMail    := ::buildOutlookMail()

   if !empty( oMail )
      oMail:Send()
   end if 

Return ( nil )

//--------------------------------------------------------------------------//

METHOD outlookDisplayMail()
   
   local oMail    := ::buildOutlookMail()

   if !empty( oMail )
      oMail:Display()
   end if 

Return ( nil )

//--------------------------------------------------------------------------//

METHOD Resource() CLASS TGenMailing

   local cTag
   local nRecno
   local oBmpGeneral

   if Empty( ::aItems )
      MsgStop( "Campos de la base de datos no pasados." )
      Return .f.
   end if

   if Empty( D():Clientes( ::nView ) )
      MsgStop( "Base de datos no pasada." )
      Return .f.
   end if

   cTag           := ( D():Clientes( ::nView ) )->( OrdSetFocus() )
   nRecno         := ( D():Clientes( ::nView ) )->( RecNo() )

   ::aFields      := GetSubArray( ::aItems, 5 )

   // Mostramos el dialogo-----------------------------------------------------

   DEFINE DIALOG ::oDlg RESOURCE "SendDocumentoMail" OF oWnd()

      ::buildPageRedectar( ::oDlg )

      // Botones generales-----------------------------------------------------

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
         ID       900 ;
         OF       ::oDlg ;
         ACTION   ( if( ::lExternalSendMail( .t. ), ::oDlg:End(), ) )

      REDEFINE BUTTON ;            // Boton de Siguiente
         ID       IDCANCEL ;
         OF       ::oDlg ;
         ACTION   ( ::oDlg:End() )

   ::oDlg:AddFastKey( VK_F5, {|| if( ::lExternalSendMail( .t. ), ::oDlg:End(), ) } )

   ::oDlg:bStart  := {|| ::startDialog() }

   ACTIVATE DIALOG ::oDlg CENTER 

   if !Empty( D():Clientes( ::nView ) )
      ( D():Clientes( ::nView ) )->( dbGoTo( nRecno ) )
      ( D():Clientes( ::nView ) )->( OrdSetFocus( cTag ) )
   end if

Return ( Self )

//--------------------------------------------------------------------------//

METHOD buildMenuDialog() CLASS TGenMailing

   MENU ::oMenu

      MENUITEM "&Archivo"

         MENU

            MENUITEM    "&Abrir HTML";
               MESSAGE  "Abrir un fichero HTML para incorporarlo al editor" ;
               RESOURCE "Folder16" ;
               ACTION   ( ::lCargaHTML() )

            MENUITEM    "&Guardar como ...";
               RESOURCE "BmpExptar16" ;
               MESSAGE  "Guardar fichero HTML" ;
               ACTION   ( ::lSalvaHTML() )

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

METHOD WaitSeconds( nTime )

	local n

	for n := 1 to nTime

		if ::lCancel
			exit
		end if

	 	WaitSeconds( 1 )

	 	SysRefresh()

	next

RETURN ( Self )

//---------------------------------------------------------------------------//


METHOD waitMail()

   ::oTree:Select( ::oTree:Add( "Envio " + Alltrim( Str( ( D():Clientes( ::nView ) )->( OrdKeyNo() ) ) ) + " de " + Alltrim( Str( ::oMtr:nTotal ) ) ) )

   if ::nPaqueteActual >= ::nPaquetesTotales

      ::oTree:Select( ::oTree:Add( "Esperando " + ::cTiempo + "para proximo envio" ) )

      ::WaitSeconds( ::nTime )

      ::nPaqueteActual := 1

   else

      ::nPaqueteActual++

   end if

Return ( Self )   

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
      if aTran[ 2 ] $ cString
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

