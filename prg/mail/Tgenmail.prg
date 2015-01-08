#include "FiveWin.Ch"
#include "Factu.ch" 

//--------------------------------*-------------------------------------------//

CLASS TGenMailing 

   DATA oDlg
   DATA oFld
   DATA oMenu

   DATA oSendMail

   DATA nView

   DATA oBrwClient
   DATA oTree
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
   DATA cSubject
   DATA cGetAdjunto
   DATA cGetHtml
   DATA cGetCSS
   DATA cGetMensaje                    INIT ""
   DATA cGetDe                         INIT Padr( uFieldEmpresa( "cNombre" ), 250 )
   DATA cGetPara                       INIT Space( 250 )
   DATA cGetCopia                      INIT Padr( uFieldEmpresa( "cCcpMai" ), 250 )

   DATA cWorkArea                      INIT ""

   DATA lHidePara                      INIT .f.
   DATA lHideCopia                     INIT .f.

   DATA aAdjuntos                      INIT {}

   DATA oActiveX
   DATA cActiveX

   DATA aItems

   DATA aFields
   DATA oField
   DATA aField
   DATA cField

   DATA cTypeDocument

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

   DATA oPaquetesTotales
   DATA nPaquetesTotales               INIT 1
   DATA nPaqueteActual                 INIT 1

   DATA nTime

   DATA cTiempo                        INIT "0 seg."
   DATA aTiempo                        INIT { "0 seg.", "5 seg.", "10 seg.", "15 seg.", "20 seg.", "25 seg.", "30 seg.", "35 seg.", "40 seg.", "45 seg.", "50 seg.", "55 seg.", "60 seg." }

   DATA oBmpClient
   DATA oBmpRedactar
   DATA oBmpProceso

   DATA aMailingList                   INIT {}

   METHOD New()
   METHOD Create()

   METHOD setWorkArea( cWorkArea )     INLINE ( ::cWorkArea := cWorkArea )
   METHOD getWorkArea()                INLINE ( ::cWorkArea )

   METHOD setAsunto( cText )           INLINE ( ::cSubject := padr( cText, 250 ) )
   METHOD getAsunto()                  INLINE ( alltrim( ::cSubject ) )

   METHOD setHtml( cText )             INLINE ( ::cGetHtml := padr( cText, 250 ) )
   METHOD setDe( cText )               INLINE ( ::cGetDe := padr( cText, 250 ) )
   
   METHOD setPara( cText )             INLINE ( ::cGetPara := padr( cText, 250 ) )
   METHOD getPara()                    INLINE ( alltrim( ::cGetPara ) )
      METHOD HidePara()                INLINE ( ::lHidePara := .t., if ( !empty( ::oGetPara ), ::oGetPara:Hide(), ) )
      METHOD ShowPara()                INLINE ( ::lHidePara := .f., if ( !empty( ::oGetPara ), ::oGetPara:Show(), ) )

   METHOD setCopia( cText )            INLINE ( ::cGetCopia := padr( cText, 250 ) )
   METHOD getCopia()                   INLINE ( alltrim(::cGetCopia) )
      METHOD HideCopia()               INLINE ( ::lHideCopia := .t., if ( !empty( ::oGetCopia ), ::oGetCopia:Hide(), ) )
      METHOD ShowCopia()               INLINE ( ::lHideCopia := .f., if ( !empty( ::oGetCopia ), ::oGetCopia:Show(), ) )

   METHOD setAlias( cAlias )           INLINE ( nil )

   METHOD setAdjunto( cText )          INLINE ( ::cGetAdjunto := padr( cText, 250 ) )
   METHOD getAdjunto()                 INLINE ( alltrim( ::cGetAdjunto ) )
   METHOD addAdjunto( cText )          INLINE ( aAdd( ::aAdjuntos, cText ) )
   METHOD addFileAdjunto()

   METHOD setMensaje( cText )          INLINE ( ::cGetMensaje += cText )

   METHOD setTypeDocument( cText )     INLINE ( ::cTypeDocument := cText )

   METHOD setItems( aItems )           INLINE ( if( !empty(aItems),;
                                                ( ::aItems := aItems, ::aFields := getSubArray( aItems, 5 ) ), ) )
   METHOD getItems()                   INLINE ( ::aItems )

   // Recursos-----------------------------------------------------------------

   METHOD Resource()

      METHOD botonAnterior()
      METHOD botonSiguiente()

      METHOD buildPageRedactar( oDlg )
      METHOD buildPageCliente( oDlg )
      METHOD buildPageProceso( oDlg )
      METHOD buildButtonsGeneral()

   METHOD startResource()
   METHOD freeResources()

   METHOD lCargaHTML()
   METHOD lSalvaHTML()
   METHOD lDefectoHTML()

   METHOD SelMailing()
      METHOD SelAllMailing( lValue )

   METHOD setMeterTotal( nTotal )      INLINE ( ::oMtr:nTotal := nTotal )
   METHOD setMeter( nSet )             INLINE ( ::oMtr:Set( nSet ) )

   METHOD IniciarProceso()

   METHOD replaceExpresion( cDocumentHTML, cExpresion )

   METHOD isMailServer()               INLINE ( !Empty( ::MailServer ) .and. !Empty( ::MailServerUserName ) .and. !Empty( ::MailServerPassword ) )


   METHOD MailServerSend()             INLINE ( ::MailServer + if( !Empty( ::MailServerPort ), ":" + Alltrim( Str( ::MailServerPort ) ), "" ) )

   METHOD SelectColumn( oCombo )

   METHOD InsertField()                INLINE ( ::oActiveX:oClp:SetText( "{" + ( Alltrim( ::cField ) ) + "}" ), ::oActiveX:oRTF:Paste() )


   METHOD waitMail()
   METHOD waitSeconds( nTime )

   METHOD getClientList()              
   METHOD addClientList()              INLINE ( iif(  ( ::getWorkArea() )->lMail .and. !empty( ( ::getWorkArea() )->cMeiInt ),;
                                                      aAdd( ::aMailingList, ::hashClientList() ),;
                                                   ) )
   METHOD hashClientList()        
   METHOD getMessage()
   METHOD getMessageHTML()             INLINE ( "<HTML>" + strtran( alltrim( ::getMessage() ), CRLF, "<p>" ) + "</HTML>" )   
   METHOD getExpression()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( aItems, cWorkArea, nView ) CLASS TGenMailing

   ::Create()

   ::aItems                := aItems
   ::aFields               := getSubArray( aItems, 5 )
   ::nView                 := nView
   ::setWorkArea( cWorkArea )

   ::oSendMail             := TSendMail():New( Self )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Create() CLASS TGenMailing

   ::cSubject              := Space( 254 )
   ::cGetAdjunto           := Space( 254 )
   ::cGetHtml              := Space( 254 )

   ::SetDe( uFieldEmpresa( "cNombre" ) )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Resource() CLASS TGenMailing

   ::lCancel         := .f.

   ::HidePara()

   DEFINE DIALOG     ::oDlg ;
      RESOURCE       "Select_Mail_Container";
       OF            oWnd()

      REDEFINE PAGES ::oFld ;
         ID          10;
         OF          ::oDlg ;
         DIALOGS     "Select_Mail_Redactar",;
                     "Select_Mail_Registros",;
                     "Select_Mail_Proceso"

         ::buildPageRedactar( ::oFld:aDialogs[ 1 ] )

         ::buildPageCliente( ::oFld:aDialogs[ 2 ] )

         ::buildPageProceso( ::oFld:aDialogs[ 3 ] )

         ::buildButtonsGeneral()

      ::oDlg:bStart  := {|| ::startResource() }

   ACTIVATE DIALOG ::oDlg CENTER 

   ::freeResources()

Return ( Self )

//--------------------------------------------------------------------------//

METHOD startResource() CLASS TGenMailing

   if ::lHidePara
      ::oGetPara:Hide()
   end if 

   if ::lHideCopia
      ::oGetCopia:Hide()
   end if 

   if Empty( ::oActiveX )
      MsgStop( "No se ha podido instanciar el control." )
      Return ( Self )
   else 
      ::oActiveX:SetHTML()
   end if

   if !empty(::oBtnAnterior)
      ::oBtnAnterior:Hide()
   end if 

   // ::buildMenuDialog()

Return ( Self )

//--------------------------------------------------------------------------//

METHOD buildPageRedactar( oDlg )

   REDEFINE BITMAP ::oBmpRedactar ;
      ID       500 ;
      RESOURCE "Businessman2_Alpha_48" ;
      TRANSPARENT ;
      OF       oDlg

   REDEFINE GET ::oGetDe VAR ::cGetDe ;
      ID       90 ;
      OF       oDlg

   REDEFINE GET ::oGetPara VAR ::cGetPara ;
      IDSAY    121 ;
      ID       120 ;
      OF       oDlg

   REDEFINE GET ::oGetAsunto VAR ::cSubject ;
      ID       100 ;
      OF       oDlg

   REDEFINE GET ::oGetAdjunto VAR ::cGetAdjunto ;
      ID       110 ;
      OF       oDlg

   REDEFINE GET ::oGetCopia VAR ::cGetCopia ;
      IDSAY    151 ;
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

   ::oActiveX:oRTF:SetText( ::cGetMensaje )

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

   oGetOrd:bChange   := {| nKey, nFlags, oGet | AutoSeek( nKey, nFlags, oGet, ::oBrwClient, ::getWorkArea() ) }

   REDEFINE COMBOBOX oCbxOrd ;
      VAR      cCbxOrd ;
      ID       110 ;
      ITEMS    aCbxOrd ;
      OF       oDlg

   oCbxOrd:bChange   := {|| ::SelectColumn( oCbxOrd ) }

   REDEFINE BUTTON ;
      ID       130 ;
      OF       oDlg ;
      ACTION   ( ::SelMailing( ::getWorkArea() ) )

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

   ::oBrwClient:cAlias          := ::getWorkArea()

   ::oBrwClient:nMarqueeStyle   := 5

   ::oBrwClient:CreateFromResource( 160 )

   ::oBrwClient:bLDblClick      := {|| ::SelMailing() }

   with object ( ::oBrwClient:AddCol() )
      :cHeader          := "Se. seleccionado"
      :bStrData         := {|| "" }
      :bEditValue       := {|| ( ::getWorkArea() )->lMail }
      :nWidth           := 20
      :SetCheck( { "Sel16", "Nil16" } )
   end with

   with object ( ::oBrwClient:AddCol() )
      :cHeader          := "Código"
      :cSortOrder       := "Cod"
      :bEditValue       := {|| ( ::getWorkArea() )->Cod }
      :nWidth           := 70
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
   end with

   with object ( ::oBrwClient:AddCol() )
      :cHeader          := "Nombre"
      :cSortOrder       := "Titulo"
      :bEditValue       := {|| ( ::getWorkArea() )->Titulo }
      :nWidth           := 300
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
   end with

   with object ( ::oBrwClient:AddCol() )
      :cHeader          := "Correo electrónico"
      :cSortOrder       := "cMeiInt"
      :bEditValue       := {|| ( ::getWorkArea() )->cMeiInt }
      :nWidth           := 260
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
   end with

Return ( Self )   

//---------------------------------------------------------------------------//

METHOD buildPageProceso( oDlg )

   REDEFINE BITMAP ::oBmpProceso ;
      ID       500 ;
      RESOURCE "Gears_48_alpha" ;
      TRANSPARENT ;
      OF       oDlg

   REDEFINE GET ::oPaquetesTotales ;
      VAR      ::nPaquetesTotales ;
      IDSAY    181 ;
      ID       180 ;
      SPINNER ;
      PICTURE  "@E 999" ;
      OF       oDlg

   REDEFINE COMBOBOX ::cTiempo ;
      ITEMS    ::aTiempo ;
      ID       170 ;
      OF       oDlg

   ::oTree     := TTreeView():Redefine( 100, oDlg )

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
      ACTION   ( ::oDlg:end() )

Return ( Self )   

//---------------------------------------------------------------------------//

METHOD freeResources()

   if !Empty( ::oBmpRedactar )
      ::oBmpRedactar:end()
   end if

   if !Empty( ::oBmpProceso )
      ::oBmpProceso:end()
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

METHOD addFileAdjunto() CLASS TGenMailing

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

   if ::oFld:nOption == 2
      ::oBtnAnterior:Hide()
      ::oBtnSiguiente:Show() 
      ::oBtnCargarHTML:Show()
      ::oBtnSalvarHTML:Show()
   end if

   if ::oFld:nOption <= len( ::oFld:aDialogs ) 
      ::oBtnSiguiente:Show() 
      SetWindowText( ::oBtnSiguiente:hWnd, "Siguien&te >" )
   end if 

   ::oFld:GoPrev()

Return ( Self )

//--------------------------------------------------------------------------//

METHOD BotonSiguiente() CLASS TGenMailing

   ::oFld:GoNext()

   if ::oFld:nOption == 2
      ::oBtnCargarHTML:Hide()
      ::oBtnSalvarHTML:Hide()
      ::oBtnAnterior:Show()
   end if 

   if ::oFld:nOption == len( ::oFld:aDialogs ) - 1
      ::oBtnAnterior:Show()
      ::oBtnSiguiente:Show() 
      SetWindowText( ::oBtnSiguiente:hWnd, "&Terminar" )
   end if 

   if ::oFld:nOption == len( ::oFld:aDialogs ) 
      ::oBtnSiguiente:Hide() 
      ::IniciarProceso()
   end if 

Return ( Self )

//--------------------------------------------------------------------------//

METHOD SelMailing( lValue ) CLASS TGenMailing

   DEFAULT lValue := !( ::getWorkArea() )->lMail

   if dbDialogLock( ::getWorkArea() )
      ( ::getWorkArea() )->lMail   := lValue
      ( ::getWorkArea() )->( dbUnlock() )
   end if

   ::oBrwClient:Refresh()
   ::oBrwClient:SetFocus()

Return ( Self )

//--------------------------------------------------------------------------//

METHOD SelAllMailing( lValue ) CLASS TGenMailing

   local nRecord

   DEFAULT lValue  := .t.

	CursorWait()

   nRecord         := ( ::getWorkArea() )->( recno() )
   ( ::getWorkArea() )->( dbeval( {|| ::selMailing( lValue ) } ) )
   ( ::getWorkArea() )->( dbgoto( nRecord ) )

	CursorArrow()

Return ( Self )

//--------------------------------------------------------------------------//

METHOD getClientList()

   local nRecord

   CursorWait()

   ::aMailingList := {}
   
   nRecord         := ( ::getWorkArea() )->( recno() )
   ( ::getWorkArea() )->( dbeval( {|| ::addClientList() } ) )
   ( ::getWorkArea() )->( dbgoto( nRecord ) )

   CursorArrow()

Return ( ::aMailingList )

//--------------------------------------------------------------------------//

METHOD IniciarProceso() CLASS TGenMailing

   local aClientList    

   aClientList          := ::getClientList()
   if !empty(aClientList)
      ::oSendMail:sendList( aClientList )
   else
      msgStop( "No hay direcciones de correos para mandar.")
   end if 

Return ( self )

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

   ::oTree:Select( ::oTree:Add( "Envio " + Alltrim( Str( ( ::getWorkArea() )->( OrdKeyNo() ) ) ) + " de " + Alltrim( Str( ::oMtr:nTotal ) ) ) )

   if ::nPaqueteActual >= ::nPaquetesTotales

      ::oTree:Select( ::oTree:Add( "Esperando " + ::cTiempo + "para proximo envio" ) )

      ::WaitSeconds( ::nTime )

      ::nPaqueteActual := 1

   else

      ::nPaqueteActual++

   end if

Return ( Self )   

//---------------------------------------------------------------------------//

METHOD hashClientList()

   local hashClientList := {=>}

   hSet( hashClientList, "mail", alltrim( ( ::getWorkArea() )->cMeiInt ) )
   hSet( hashClientList, "mailcc", ::cGetCopia )
   hSet( hashClientList, "subject", ::cSubject )
   hSet( hashClientList, "attachments", ::cGetAdjunto )
   hSet( hashClientList, "message", ::getMessageHTML() )

Return ( hashClientList )

//---------------------------------------------------------------------------//

METHOD getMessage()

   local cExpresion
   local cDocument     := ::oActiveX:getText()

   while .t. 

      cExpresion       := ::getExpression( cDocument ) 
      if empty(cExpresion)
         exit
      end if

      ::replaceExpresion( @cDocument, cExpresion )

   end while

Return ( cDocument )

//--------------------------------------------------------------------------//

METHOD getExpression( cDocument )

   local nAtEnd         := At( "}", cDocument )
   local nAtInit        := At( "{", cDocument )
   local cExpresion     := ""

   if ( nAtInit != 0 .and. nAtEnd != 0 )
      cExpresion     := SubStr( cDocument, nAtInit, ( nAtEnd - nAtInit ) + 1 )
   end if 

Return ( cExpresion )

//--------------------------------------------------------------------------//

METHOD replaceExpresion( cDocument, cExpresion )

   local nScan
   local cExpresionToSearch

   cExpresionToSearch      := Alltrim( SubStr( cExpresion, 2, len( cExpresion ) - 2 ) )

   if ( "()" $ cExpresionToSearch )

      cDocument            := StrTran( cDocument, cExpresion, cValToText( Eval( bChar2Block( cExpresionToSearch ) ) ) )

   else

      nScan                := aScan( ::aItems, {|a| alltrim( a[ 5 ] ) == cExpresionToSearch .or. alltrim( a[ 5 ] ) == HtmlEntities( cExpresionToSearch ) } )
      if nScan != 0
         cDocument         := StrTran( cDocument, cExpresion, alltrim( cValToChar( ( ::getWorkArea() )->( eval( Compile( ::aItems[ nScan, 1 ] ) ) ) ) ) )
      else
         cDocument         := StrTran( cDocument, cExpresion, "" )
      end if

   end if

Return ( Self )

//--------------------------------------------------------------------------//
