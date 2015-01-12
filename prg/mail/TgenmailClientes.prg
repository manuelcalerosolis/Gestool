#include "FiveWin.Ch"
#include "Factu.ch" 

//--------------------------------*-------------------------------------------//

CLASS TGenMailingClientes FROM TGenMailing 

   DATA oFilter

   DATA oBmpClient
   DATA oBrwClient

   DATA oBntCreateFilter
   DATA oBntQuitFilter

   METHOD New( nView )

   METHOD buildPageDatabase( oDlg )
   METHOD selectColumn( oCombo )
   METHOD freeResources() 

   METHOD selMailing()
   METHOD selAllMailing()

   METHOD getClientList()              
   METHOD addClientList()              INLINE ( iif(  ( ::getWorkArea() )->lMail .and. !empty( ( ::getWorkArea() )->cMeiInt ),;
                                                      aAdd( ::aMailingList, ::hashClientList() ),;
                                                   ) )
   METHOD hashClientList()        

   METHOD dialogFilter()
   METHOD buildFilter()
   METHOD quitFilter()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS TGenMailingClientes

   ::Create()

   ::setItems( aItmCli() )
   ::setWorkArea( D():Clientes( nView ) )

   ::oSendMail       := TSendMail():New( Self )
   ::oTemplateHtml   := TTemplatesHtml():New( Self )

   msgalert("Filter")
   ::oFilter         := TFilterCreator():Init( Self )   
   ::oFilter:SetFields( aItmCli() )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD buildPageDatabase( oDlg ) CLASS TGenMailingClientes

   local oGetOrd
   local oCbxOrd
   local cGetOrd  := Space( 100 )
   local cCbxOrd  := "Código"
   local aCbxOrd  := { "Código", "Nombre", "Correo electrónico" }

   msgalert("entrada")

   REDEFINE BITMAP ::oBmpClient ;
      ID          500 ;
      RESOURCE    "Businessman2_Alpha_48" ;
      TRANSPARENT ;
      OF          oDlg

   REDEFINE GET   oGetOrd ;
      VAR         cGetOrd;
      ID          100 ;
      BITMAP      "FIND" ;
      OF          oDlg

   oGetOrd:bChange   := {| nKey, nFlags, oGet | AutoSeek( nKey, nFlags, oGet, ::oBrwClient, ::getWorkArea() ) }

   REDEFINE COMBOBOX oCbxOrd ;
      VAR         cCbxOrd ;
      ID          110 ;
      ITEMS       aCbxOrd ;
      OF          oDlg

   oCbxOrd:bChange   := {|| ::SelectColumn( oCbxOrd ) }

   REDEFINE BUTTON ;
      ID          130 ;
      OF          oDlg ;
      ACTION      ( ::SelMailing() )

   REDEFINE BUTTON ;
      ID          140 ;
      OF          oDlg ;
      ACTION      ( ::SelAllMailing( .t. ) )

   REDEFINE BUTTON ;
      ID          150 ;
      OF          oDlg ;
      ACTION      ( ::SelAllMailing( .f. ) )

   REDEFINE BUTTON ::oBntCreateFilter ;
      ID          170 ;
      OF          oDlg ;
      ACTION      ( ::dialogFilter() )

   ::oBntQuitFilter  := TBtnBmp():ReDefine( 180, "Del16", , , , , {|| ::quitFilter() }, oDlg, .f., , .f., "Quitar filtro" )

   // Browse-------------------------------------------------------------------

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

   msgalert("salida")

Return ( Self )   

//---------------------------------------------------------------------------//

METHOD selectColumn( oCombo ) CLASS TGenMailingClientes

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

METHOD selMailing( lValue ) CLASS TGenMailingClientes

   DEFAULT lValue       := !( ::getWorkArea() )->lMail

   if dbDialogLock( ::getWorkArea() )
      ( ::getWorkArea() )->lMail   := lValue
      ( ::getWorkArea() )->( dbUnlock() )
   end if

   ::oBrwClient:Refresh()
   ::oBrwClient:SetFocus()

Return ( Self )

//--------------------------------------------------------------------------//

METHOD selAllMailing( lValue ) CLASS TGenMailingClientes

   local nRecord

   DEFAULT lValue  := .t.

	CursorWait()

   nRecord         := ( ::getWorkArea() )->( recno() )
   ( ::getWorkArea() )->( dbeval( {|| ::selMailing( lValue ) } ) )
   ( ::getWorkArea() )->( dbgoto( nRecord ) )

	CursorArrow()

Return ( Self )

//--------------------------------------------------------------------------//

METHOD getClientList() CLASS TGenMailingClientes

   local nRecord

   CursorWait()

   ::aMailingList    := {}
   
   nRecord           := ( ::getWorkArea() )->( recno() )
   ( ::getWorkArea() )->( dbeval( {|| ::addClientList() } ) )
   ( ::getWorkArea() )->( dbgoto( nRecord ) )

   CursorArrow()

Return ( ::aMailingList )

//--------------------------------------------------------------------------//

METHOD hashClientList() CLASS TGenMailingClientes

   local hashClientList := {=>}

   hSet( hashClientList, "mail", alltrim( ( ::getWorkArea() )->cMeiInt ) )
   hSet( hashClientList, "mailcc", ::cGetCopia )
   hSet( hashClientList, "subject", ::cSubject )
   hSet( hashClientList, "attachments", ::cGetAdjunto )
   hSet( hashClientList, "message", ::getMessageHTML() )

Return ( hashClientList )

//---------------------------------------------------------------------------//

METHOD freeResources() CLASS TGenMailingClientes

   ::Super:freeResources()

   if !empty(::oBmpClient)
      ::oBmpClient:end()
   end if 

   if !empty(::oFilter)
      ::oFilter:end()
   end if

Return ( Self )

//--------------------------------------------------------------------------//

METHOD dialogFilter() CLASS TGenMailingClientes

   ::oFilter:Dialog()

   if !empty( ::oFilter:cExpresionFilter )
      ::buildFilter()
   else
      ::quitFilter()
   end if

Return ( Self )

//--------------------------------------------------------------------------//

METHOD buildFilter()

   createFastFilter( ::oFilter:cExpresionFilter, ::getWorkArea(), .f. )

   SetWindowText( ::oBntCreateFilter:hWnd, "&Filtro activo" )

   ::oBntQuitFilter:Show()

   ::oBrwClient:Refresh()

Return ( Self )

//--------------------------------------------------------------------------//

METHOD quitFilter() CLASS TGenMailingClientes

   destroyFastFilter( ::getWorkArea() )

   SetWindowText( ::oBntCreateFilter:hWnd, "&Filtro" )

   ::oBntQuitFilter:Hide()

   ::oBrwClient:Refresh()

Return ( Self )

//--------------------------------------------------------------------------//

