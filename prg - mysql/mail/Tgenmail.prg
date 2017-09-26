#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TGenMailing 

   DATA oDlg
   DATA oFld
   DATA oMenu

   DATA nView 

   DATA oSendMail

   DATA oTree
   DATA oMtr
   DATA nMtr
   DATA oFlt

   DATA lPageDatabase                     INIT .f.
   DATA lMultiSelect                      INIT .f.

   DATA oBtnSiguiente
   DATA oBtnAnterior
   DATA oBtnCancel
   DATA oBtnFilter
   DATA oBtnCargarHTML
   DATA oBtnSalvarHTML
   DATA oBtnSalvarAsHTML
   DATA oBtnDefectoHTML

   DATA aPages

   // Para---------------------------------------------------------------------

   DATA oRecipients

   DATA bRecipients
      METHOD setBlockRecipients( bRecipients ) ;
                                          INLINE ( ::bRecipients := bRecipients )
      METHOD evalBlockRecipients()        INLINE ( iif( !empty( ::bRecipients ), eval( ::bRecipients ), "" ) )

   DATA cRecipients                       INIT Space( 250 )

   METHOD setRecipients( cText )          INLINE ( ::cRecipients := padr( cText, 250 ) )
   METHOD getRecipients()                 INLINE ( iif(  ::getMultiSelect(),;
                                                         ::evalBlockRecipients(),;
                                                         alltrim( ::cRecipients ) ) )

      METHOD hideRecipients()             INLINE ( ::lHideRecipients := .t., if ( !empty( ::oRecipients ), ::oRecipients:Disable(), ) )
      METHOD showRecipients()             INLINE ( ::lHideRecipients := .f., if ( !empty( ::oRecipients ), ::oRecipients:Enable(), ) )

   // Asunto-------------------------------------------------------------------

   DATA oGetAsunto
   DATA cSubject

   METHOD setAsunto( cText )              INLINE ( ::cSubject := padr( cText, 250 ) )
   METHOD getAsunto()                  

   // Adjunto------------------------------------------------------------------
   
   DATA oGetAdjunto
   DATA cGetAdjunto

   // Formato------------------------------------------------------------------

   DATA oFormatoDocumento
   DATA cFormatoDocumento 
   
   DATA oEditDocumento

   // Tipos de documentos------------------------------------------------------

   DATA cTypeDocument
   DATA cTypeFormat

   // Seleccion de registros---------------------------------------------------

   DATA aSelected                         INIT {}
   METHOD setSelected( aSelected )        INLINE ( ::aSelected := aSelected, ::setMultiSelect( len( aSelected ) > 1 ) )
   METHOD setMultiSelect( lMultiSelect )  INLINE ( ::lMultiSelect := lMultiSelect )
   METHOD getMultiSelect()                INLINE ( ::lMultiSelect )

   METHOD setMultiSelectMode()            INLINE ( iif(  ::getMultiSelect(),;
                                                         ( ::setRecipients( ::getTextSelectedMails() ), ::HideRecipients() ),;
                                                         ( ::setRecipients( ::evalBlockRecipients() ), ::showRecipients() ) ) )

   DATA cBmpDatabase
   METHOD setBmpDatabase( cBmpDatabase )  INLINE ( ::cBmpDatabase := cBmpDatabase )

   DATA cMensaje                          INIT ""
   METHOD setMensaje( cMensaje )          INLINE ( ::cMensaje := cMensaje, if( !empty( ::oRichEdit ), ::oRichEdit:oRTF:SetText( cMensaje ), ) )
   METHOD saveToFile( cFile )             INLINE ( if( !empty( ::oRichEdit ), ::oRichEdit:saveToFile( cFile ), ) )

   DATA oGetCopia                      
   DATA cGetCopia                         INIT Padr( uFieldEmpresa( "cCcpMai" ), 250 )

   DATA oGetCopiaOculta                
   DATA cGetCopiaOculta                   INIT Padr( uFieldEmpresa( "cCcoMai" ), 250 )
   
   DATA oGetDe                         
   DATA cGetDe                            INIT Padr( uFieldEmpresa( "cNombre" ), 250 )

   DATA cWorkArea                         INIT ""
   DATA hWorkAreaStatus

   DATA lHideRecipients                   INIT .f.
   DATA lHideCopia                        INIT .f.
   DATA lHideCopiaOculta                  INIT .f.
   DATA lHideFormato                      INIT .f.

   DATA aAdjuntos                         INIT {}

   DATA oRichEdit
   DATA cActiveX

   DATA aItems

   DATA aFields
   DATA oField
   DATA aField
   DATA cField

   DATA oTemplateHtml

   DATA cHtml
   DATA lHtml                             INIT .t.

   DATA oMail

   DATA lCancel

   DATA oPaquetesTotales
   DATA nPaquetesTotales                  INIT 1
   DATA nPaqueteActual                    INIT 1

   DATA nTime

   DATA cTiempo                           INIT "0 seg."
   DATA aTiempo                           INIT { "0 seg.", "5 seg.", "10 seg.", "15 seg.", "20 seg.", "25 seg.", "30 seg.", "35 seg.", "40 seg.", "45 seg.", "50 seg.", "55 seg.", "60 seg." }

   DATA oBmpRedactar
   DATA oBmpProceso
   DATA oBmpDatabase

   DATA aMailingList                      INIT {}

   METHOD New()
   METHOD Create()

   METHOD setWorkArea( cWorkArea )        INLINE ( ::cWorkArea := cWorkArea )
   METHOD getWorkArea()                   INLINE ( ::cWorkArea )
   METHOD getStatusWorkArea()             INLINE ( ::hWorkAreaStatus := hGetStatus( ::cWorkArea, .t. ) )
   METHOD setStatusWorkArea()             INLINE ( hSetStatus( ::hWorkAreaStatus ) )
   METHOD gotoRecord( nRecord )           INLINE ( ( ::getWorkArea() )->( dbgoto( nRecord ) ) )

   METHOD setDe( cText )                  INLINE ( ::cGetDe := padr( cText, 250 ) )

   METHOD setCopia( cText )               INLINE ( ::cGetCopia := padr( cText, 250 ) )
   METHOD getCopia()                      INLINE ( alltrim( ::cGetCopia ) )
      METHOD HideCopia()                  INLINE ( ::lHideCopia := .t., if ( !empty( ::oGetCopia ), ::oGetCopia:Hide(), ) )
      METHOD ShowCopia()                  INLINE ( ::lHideCopia := .f., if ( !empty( ::oGetCopia ), ::oGetCopia:Show(), ) )

   METHOD setCopiaOculta( cText )         INLINE ( ::cGetCopiaOculta := padr( cText, 250 ) )
   METHOD getCopiaOculta()                INLINE ( alltrim( ::cGetCopiaOculta ) )
      METHOD HideCopiaOculta()            INLINE ( ::lHideCopiaOculta := .t., if ( !empty( ::oGetCopiaOculta ), ::oGetCopiaOculta:Hide(), ) )
      METHOD ShowCopiaOculta()            INLINE ( ::lHideCopiaOculta := .f., if ( !empty( ::oGetCopiaOculta ), ::oGetCopiaOculta:Show(), ) )

   METHOD getMessage()
   METHOD getMessageHTML()                INLINE ( "<HTML>" + strtran( alltrim( ::getMessage() ), CRLF, "<p>" ) + "</HTML>" )   
      METHOD getExpression()
      METHOD replaceExpresion( cDocumentHTML, cExpresion )

   // Post send mail

   DATA bPostSend           
   METHOD setPostSend( bPostSend )        INLINE ( ::bPostSend := bPostSend )
   METHOD getPostSend                     INLINE ( ::bPostSend )

   // Post send mail

   DATA bPostError           
   METHOD setPostError( bPostError )      INLINE ( ::bPostError := bPostError )
   METHOD getPostError                    INLINE ( ::bPostError )

   // Cargo

   DATA bCargo           
   METHOD setCargo( bCargo )              INLINE ( ::bCargo := bCargo )
   METHOD getCargo()                      INLINE ( if( !empty( ::bCargo ), eval( ::bCargo ), ) )

   METHOD setAdjunto( cText )             INLINE ( ::cGetAdjunto := padr( cText, 250 ) )
   METHOD getAdjunto()                    INLINE ( alltrim( ::cGetAdjunto ) )
   METHOD addAdjunto( cText )             INLINE ( aAdd( ::aAdjuntos, cText ) )
   METHOD addFileAdjunto()

   METHOD setItems( aItems )              INLINE ( iif( !empty( aItems ), ( ::aItems := aItems, ::aFields := getSubArray( aItems, 5 ) ), ) )
                                                      
   METHOD getItems()                      INLINE ( ::aItems )

   METHOD setTypeDocument( cTypeDocument ) ;
                                          INLINE ( ::oTemplateHtml:setTypeDocument( cTypeDocument ) )

   METHOD setTypeFormat( cTypeFormat )    INLINE ( ::cTypeFormat := cTypeFormat )

   METHOD setFormatoDocumento( cFormatoDocumento ) ;
                                          INLINE ( ::cFormatoDocumento := cFormatoDocumento )

   METHOD documentsDialog( aSelected )

   // Recursos-----------------------------------------------------------------

   METHOD Resource()

      METHOD botonAnterior()
      METHOD botonSiguiente()

      METHOD buildPageRedactar()
      METHOD buildPageDatabase( oDlg )    VIRTUAL
      METHOD buildPageProceso( oDlg )
      METHOD buildButtonsGeneral()

      METHOD startResource()
      METHOD endResources()

      METHOD setMeterTotal( nTotal )      INLINE ( ::oMtr:nTotal := nTotal )
      METHOD setMeter( nSet )             INLINE ( ::oMtr:Set( nSet ) )

   // Inicio del proceso-------------------------------------------------------

   METHOD IniciarProceso()

   METHOD InsertField()                   INLINE ( ::oRichEdit:oClp:SetText( "{" + ( alltrim( ::cField ) ) + "}" ), ::oRichEdit:oRTF:Paste() )

   METHOD waitMail()
   METHOD waitSeconds( nTime )

   METHOD getDatabaseList()               VIRTUAL
   METHOD getSelectedList()
   METHOD getTextSelectedMails()

   METHOD addDatabaseList()
      METHOD hashDatabaseList()
      METHOD addSelectedList()            INLINE ( aAdd( ::aMailingList, ::hashDatabaseList() ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS TGenMailing

   ::Create()

   ::nView           := nView

   ::oSendMail       := TSendMail():New( Self )

   ::oTemplateHtml   := TTemplatesHtml():New( Self )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Create() CLASS TGenMailing

   ::cSubject        := Space( 254 )
   ::cGetAdjunto     := Space( 254 )

   ::SetDe( uFieldEmpresa( "cNombre" ) )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD documentsDialog( aSelected ) CLASS TGenMailing

   ::lPageDatabase   := .f.

   ::aPages          := { "Select_Mail_Redactar", "Select_Mail_Proceso" }

   ::setSelected( aSelected )

   ::setMultiSelectMode()

   ::Resource()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Resource() CLASS TGenMailing

   ::lCancel         := .f.

   DEFINE DIALOG     ::oDlg ;
      RESOURCE       "Select_Mail_Container";
       OF            oWnd()

      ::oFld         := TPages():Redefine( 10, ::oDlg, ::aPages )

      ::buildPageRedactar()

      if ::lPageDatabase
         ::buildPageDatabase()
      end if

      ::buildPageProceso()

      ::buildButtonsGeneral()

      ::oDlg:bStart  := {|| ::startResource() }

   ACTIVATE DIALOG ::oDlg CENTER 

   ::endResources()

Return ( Self )

//--------------------------------------------------------------------------//

METHOD startResource() CLASS TGenMailing

   ::getStatusWorkArea()

   if ::lHideRecipients
      ::oRecipients:Disable()
   end if 

   if ::lHideCopia
      ::oGetCopia:Hide()
   end if 

   if ::lHideCopiaOculta
      ::oGetCopiaOculta:Hide()
   end if 

   if ::lHideFormato
      ::oFormatoDocumento:Hide()
      ::oEditDocumento:Hide()
   end if 

   if !empty(::oBtnAnterior)
      ::oBtnAnterior:Hide()
   end if 

   if !empty( ::cFormatoDocumento )
      ::oFormatoDocumento:lValid()
   end if 

   if !empty( ::oRichEdit )
      ::oRichEdit:SetHTML()
   end if

Return ( Self )

//--------------------------------------------------------------------------//

METHOD endResources() CLASS TGenMailing

   ::setStatusWorkArea()

   if !Empty( ::oBmpRedactar )
      ::oBmpRedactar:end()
   end if

   if !Empty( ::oBmpProceso )
      ::oBmpProceso:end()
   end if

   if !empty( ::oMenu )
      ::oMenu:end()
   end if

   if !empty( ::oRichEdit )
      ::oRichEdit:end()
   end if 

Return ( Self )   

//---------------------------------------------------------------------------//

METHOD buildPageRedactar()

   local oDlg  := ::oFld:aDialogs[ 1 ]

   REDEFINE BITMAP ::oBmpRedactar ;
      ID       500 ;
      RESOURCE "gc_mail_earth_48" ;
      TRANSPARENT ;
      OF       oDlg

   REDEFINE GET ::oGetDe VAR ::cGetDe ;
      ID       90 ;
      OF       oDlg

   REDEFINE GET ::oRecipients VAR ::cRecipients ;
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

   REDEFINE GET ::oGetCopiaOculta VAR ::cGetCopiaOculta ;
      IDSAY    156 ;
      ID       155 ;
      OF       oDlg

   // Formato------------------------------------------------------------------

   if !empty( ::nView )

      REDEFINE GET ::oFormatoDocumento VAR ::cFormatoDocumento ;
         IDSAY    191 ;
         ID       190 ;
         IDTEXT   192 ;
         BITMAP   "Lupa" ;
         OF       oDlg

      ::oFormatoDocumento:bValid    := {|| cDocumento( ::oFormatoDocumento, ::oFormatoDocumento:oHelpText, D():Documentos( ::nView ) ) }
      ::oFormatoDocumento:bHelp     := {|| brwDocumento( ::oFormatoDocumento, ::oFormatoDocumento:oHelpText, ::cTypeFormat ) }

      ::oEditDocumento              := TBtnBmp():ReDefine( 193, "gc_document_text_pencil_12",,,,,{|| EdtDocumento( ::cFormatoDocumento ) }, oDlg, .f., , .f.,  )

   end if 

   // Adjunto------------------------------------------------------------------

   ::oGetAdjunto:cBmp   := "Folder"
   ::oGetAdjunto:bHelp  := {|| ::oGetAdjunto:cText( cGetFile( 'Fichero ( *.* ) | *.*', 'Seleccione el fichero a adjuntar' ) ) }

   TBtnBmp():ReDefine( 140, "gc_document_text_16",,,,,{|| ShellExecute( oDlg:hWnd, "open", Rtrim( ::cGetAdjunto ) ) }, oDlg, .f., , .f.,  )

   // Campos-------------------------------------------------------------------

   REDEFINE COMBOBOX ::oField VAR ::cField ;
      ITEMS    ::aFields ;
      ID       160 ;
      OF       oDlg

   TBtnBmp():ReDefine( 170, "Down16", , , , , {|| ::InsertField() }, oDlg, .f., , .f., "Insertar campo" )

   // Componentes-----------------------------------------------------------

   ::oRichEdit          := GetRichEdit():ReDefine( 600, oDlg )

   ::oRichEdit:oRTF:SetText( ::cMensaje )

Return ( Self )   

//---------------------------------------------------------------------------//

METHOD buildPageProceso()

   local oDlg  := atail( ::oFld:aDialogs )

   REDEFINE BITMAP ::oBmpProceso ;
      ID       500 ;
      RESOURCE "gc_mail_earth_48" ;
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
      ACTION   ( ::oTemplateHtml:selectHtmlFile() )

   REDEFINE BUTTON ::oBtnSalvarHTML ;          // Boton anterior
      ID       50 ;
      OF       ::oDlg ;
      ACTION   ( ::oTemplateHtml:saveHtml() )

   REDEFINE BUTTON ::oBtnSalvarAsHTML ;          // Boton anterior
      ID       60 ;
      OF       ::oDlg ;
      ACTION   ( ::oTemplateHtml:saveAsHtml() )

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

METHOD addFileAdjunto() CLASS TGenMailing

   local cFile       := cGetFile( 'Fichero ( *.* ) | *.*', 'Seleccione el fichero a adjuntar' )

   if !Empty( cFile )

      if !Empty( ::cGetAdjunto )
         cFile       := alltrim( ::cGetAdjunto ) + "; " + cFile
      end if

      ::oGetAdjunto:cText( cFile )

   end if

Return ( Self )

//--------------------------------------------------------------------------//

METHOD BotonAnterior() CLASS TGenMailing

   ::oFld:GoPrev()

   if ::oFld:nOption = 1
      ::oBtnAnterior:Hide()
      ::oBtnSiguiente:Show() 
      ::oBtnCargarHTML:Show()
      ::oBtnSalvarHTML:Show()
      ::oBtnSalvarAsHTML:Show()
   end if

   if ::oFld:nOption == len( ::oFld:aDialogs ) - 1
      ::oBtnAnterior:Show()
      ::oBtnSiguiente:setText( "&Enviar" )
      ::oBtnSiguiente:Show() 
   end if 

Return ( Self )

//--------------------------------------------------------------------------//

METHOD BotonSiguiente() CLASS TGenMailing

   ::oFld:GoNext()

   if ::oFld:nOption > 1
      ::oBtnCargarHTML:Hide()
      ::oBtnSalvarHTML:Hide()
      ::oBtnSalvarAsHTML:Hide()
      ::oBtnAnterior:Show()
   end if 

   if ::oFld:nOption == ( len( ::oFld:aDialogs ) - 1 )
      ::oBtnAnterior:Show()
      ::oBtnSiguiente:setText( "&Enviar" )
      ::oBtnSiguiente:Show() 
   end if 

   if ::oFld:nOption == len( ::oFld:aDialogs ) 
      ::oBtnAnterior:Hide()
      ::oBtnSiguiente:Hide() 
      ::IniciarProceso()
      ::oBtnAnterior:Show()
   end if 

Return ( Self )

//--------------------------------------------------------------------------//

METHOD IniciarProceso() CLASS TGenMailing

   local aDatabaseList   

   ::oSendMail:initMessage()

   if ::lPageDatabase 
      aDatabaseList           := ::getDatabaseList()
   else 
      aDatabaseList           := ::getSelectedList()
   end if 

   if !empty( aDatabaseList )
      ::oSendMail:sendList( aDatabaseList )
   else
      msgStop( "No hay direcciones de correos para mandar.")
   end if 

Return ( self )

//--------------------------------------------------------------------------//

METHOD WaitSeconds( nTime ) CLASS TGenMailing

	local n

	for n := 1 to nTime

		if ::lCancel
			exit
		end if

	 	waitSeconds( 1 )

	 	SysRefresh()

	next

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD waitMail() CLASS TGenMailing

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

METHOD getAsunto() CLASS TGenMailing

   local cExpresion
   local cDocument     := alltrim( ::cSubject )

   while .t. 

      cExpresion       := ::getExpression( cDocument ) 
      if empty( cExpresion )
         exit
      end if

      ::replaceExpresion( @cDocument, cExpresion )

   end while

Return ( cDocument )

//--------------------------------------------------------------------------//

METHOD getMessage() CLASS TGenMailing

   local cExpresion
   local cDocument     := ::oRichEdit:getText()

   while .t. 

      cExpresion       := ::getExpression( cDocument ) 
      if empty(cExpresion)
         exit
      end if

      ::replaceExpresion( @cDocument, cExpresion )

   end while

Return ( cDocument )

//--------------------------------------------------------------------------//

METHOD getExpression( cDocument ) CLASS TGenMailing

   local nAtEnd         := At( "}", cDocument )
   local nAtInit        := At( "{", cDocument )
   local cExpresion     := ""

   if ( nAtInit != 0 .and. nAtEnd != 0 )
      cExpresion     := SubStr( cDocument, nAtInit, ( nAtEnd - nAtInit ) + 1 )
   end if 

Return ( cExpresion )

//--------------------------------------------------------------------------//

METHOD replaceExpresion( cDocument, cExpresion ) CLASS TGenMailing

   local nScan
   local oError
   local oBlock
   local cExpresionToSearch

   /*
   oBlock                     := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
   */

      cExpresionToSearch      := Alltrim( SubStr( cExpresion, 2, len( cExpresion ) - 2 ) )

      if ( "(" $ cExpresionToSearch .and. ")" $ cExpresionToSearch )

         // cDocument            := StrTran( cDocument, cExpresion, cValToText( eval( bChar2Block( cExpresionToSearch ) ) ) )
         cDocument            := StrTran( cDocument, cExpresion, cValToText( eval( &( "{| Self | " + cExpresionToSearch + "}" ), Self ) ) )

      else

         nScan                := aScan( ::aItems, {|a| alltrim( a[ 5 ] ) == cExpresionToSearch .or. alltrim( a[ 5 ] ) == HtmlEntities( cExpresionToSearch ) } )
         if nScan != 0
            cDocument         := StrTran( cDocument, cExpresion, alltrim( cValToChar( ( ::getWorkArea() )->( eval( Compile( ::aItems[ nScan, 1 ] ) ) ) ) ) )
         else
            cDocument         := StrTran( cDocument, cExpresion, "" )
         end if

      end if

   /*
   RECOVER USING oError
      msgStop( ErrorMessage( oError ), 'Error al evaluar las expresiones' )
   END SEQUENCE
   ErrorBlock( oBlock )
   */

Return ( Self )

//--------------------------------------------------------------------------//

METHOD addDatabaseList() CLASS TGenMailing

   if ( ::getWorkArea() )->lMail 
      ::addSelectedList()
   end if 

Return ( Self )   

//---------------------------------------------------------------------------//

METHOD hashDatabaseList() CLASS TGenMailing

   local hashDatabaseList := {=>}

   hSet( hashDatabaseList, "mail", ::getRecipients() )
   hSet( hashDatabaseList, "mailcc", ::getCopia() )
   hSet( hashDatabaseList, "mailcco", ::getCopiaOculta() )
   hSet( hashDatabaseList, "subject", ::getAsunto() )
   hSet( hashDatabaseList, "attachments", ::getAdjunto() )
   hSet( hashDatabaseList, "message", ::getMessageHTML() )
   hSet( hashDatabaseList, "postSend", ::getPostSend() )
   hSet( hashDatabaseList, "postError", ::getPostError() )
   hSet( hashDatabaseList, "cargo", ::getCargo() )

   ::oSendMail:readyMessage( hashDatabaseList )

Return ( hashDatabaseList )

//---------------------------------------------------------------------------//

METHOD getSelectedList() CLASS TGenMailing

   local nSelect

   CursorWait()

   ::aMailingList    := {}
   
   for each nSelect in ::aSelected 
      ::gotoRecord( nSelect )
      ::addSelectedList()
   next 

   CursorArrow()

Return ( ::aMailingList )

//--------------------------------------------------------------------------//

METHOD getTextSelectedMails() CLASS TGenMailing

   local nSelect
   local nMails            := 0
   local cSelectedMails    := ""   

   CursorWait()

   for each nSelect in ::aSelected 

      ::gotoRecord( nSelect )
   
      if !empty( ::getRecipients() )
         nMails++
         cSelectedMails    += alltrim( ::getRecipients() ) + ";" 
      end if 

   next 

   cSelectedMails          := alltrim( str( nMails ) ) + " registros ( " + cSelectedMails + " )"

   CursorArrow()

Return ( cSelectedMails )

//--------------------------------------------------------------------------//


