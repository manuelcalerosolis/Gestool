#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TGenMailingDatabase FROM TGenMailing 

   DATA oFilter

   DATA oBrwDatabase

   DATA oBntCreateFilter
   DATA oBntQuitFilter

   METHOD New()

   METHOD databaseDialog()

   DATA oOrderDatabase 
   DATA cOrderDatabase 
   DATA aOrderDatabase                    INIT     { "Código", "Nombre", "Correo electrónico" }

   METHOD buildPageDatabase( oDlg )
   METHOD columnPageDatabase( oDlg )   
   METHOD selectColumn( oCombo )
   METHOD freeResources() 

   METHOD SelMailing()
      METHOD SelAllMailing( lValue )

   METHOD getDatabaseList()              
      METHOD addDatabaseList()            INLINE   ( iif( ( ::getWorkArea() )->lMail, ::addSelectedList(), ) ) 

   METHOD setItems( aItems )              INLINE   (  ::Super:setItems( aItems ),;
                                                      iif( !empty( ::oFilter ), ::oFilter:setFields( aItems ), ) )

   METHOD dialogFilter()
      METHOD buildFilter()
      METHOD quitFilter()

   METHOD setOrderDatabase( aOrderDatabase ) ;
                                          INLINE   ( ::aOrderDatabase := aOrderDatabase )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( nView )

   ::Super:New( nView )

   ::oFilter         := TFilterCreator():Init( Self )   

Return ( Self )   

//---------------------------------------------------------------------------//

METHOD databaseDialog() CLASS TGenMailingDatabase

   ::lPageDatabase   := .t.

   ::setMultiselect( .t. )

   ::aPages          := { "Select_Mail_Redactar", "Select_Mail_Registros", "Select_Mail_Proceso" }

   ::hideRecipients()

   ::Resource()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD buildPageDatabase() CLASS TGenMailingDatabase

   local oDlg        
   local oGetOrd
   local cGetOrd     := Space( 100 )
   local oCbxOrd
   local cCbxOrd  

   oDlg              := ::oFld:aDialogs[ 2 ]

   ::cOrderDatabase  := ::aOrderDatabase[ 1 ]

   REDEFINE BITMAP   ::oBmpDatabase ;
      ID             500 ;
      RESOURCE       ::cBmpDatabase ;
      TRANSPARENT ;
      OF             oDlg

   REDEFINE GET      oGetOrd ;
      VAR            cGetOrd ;
      ID             100 ;
      BITMAP         "FIND" ;
      OF             oDlg

   oGetOrd:bChange   := {| nKey, nFlags, oGet | AutoSeek( nKey, nFlags, oGet, ::oBrwDatabase, ::getWorkArea() ) }

   REDEFINE COMBOBOX ::oOrderDatabase ;
      VAR            ::cOrderDatabase ;
      ID             110 ;
      ITEMS          ::aOrderDatabase ;
      OF             oDlg

   ::oOrderDatabase:bChange   := {|| ::selectColumn() }

   REDEFINE BUTTON ;
      ID             130 ;
      OF             oDlg ;
      ACTION         ( ::selMailing() )

   REDEFINE BUTTON ;
      ID             140 ;
      OF             oDlg ;
      ACTION         ( ::selAllMailing( .t. ) )

   REDEFINE BUTTON ;
      ID             150 ;
      OF             oDlg ;
      ACTION         ( ::selAllMailing( .f. ) )

   REDEFINE BUTTON ::oBntCreateFilter ;
      ID             170 ;
      OF             oDlg ;
      ACTION         ( ::dialogFilter() )

   ::oBntQuitFilter  := TBtnBmp():ReDefine( 180, "Del16", , , , , {|| ::quitFilter() }, oDlg, .f., , .f., "Quitar filtro" )

   // Browse-------------------------------------------------------------------

   ::oBrwDatabase                 := IXBrowse():New( oDlg )

   ::oBrwDatabase:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwDatabase:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrwDatabase:cAlias          := ::getWorkArea()

   ::oBrwDatabase:nMarqueeStyle   := 5

   ::oBrwDatabase:CreateFromResource( 160 )

   ::oBrwDatabase:bLDblClick      := {|| ::SelMailing() }

   // Añade las columnas-------------------------------------------------------

   ::columnPageDatabase( oDlg )

Return ( Self )   

//---------------------------------------------------------------------------//

METHOD columnPageDatabase( oDlg ) CLASS TGenMailingDatabase

   with object ( ::oBrwDatabase:AddCol() )
      :cHeader          := "Se. seleccionado"
      :bStrData         := {|| "" }
      :bEditValue       := {|| ( ::getWorkArea() )->lMail }
      :nWidth           := 20
      :SetCheck( { "Sel16", "Nil16" } )
   end with

   with object ( ::oBrwDatabase:AddCol() )
      :cHeader          := "Código"
      :cSortOrder       := "Cod"
      :bEditValue       := {|| ( ::getWorkArea() )->Cod }
      :nWidth           := 70
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::oOrderDatabase:Set( oCol:cHeader ) }
   end with

   with object ( ::oBrwDatabase:AddCol() )
      :cHeader          := "Nombre"
      :cSortOrder       := "Titulo"
      :bEditValue       := {|| ( ::getWorkArea() )->Titulo }
      :nWidth           := 300
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::oOrderDatabase:Set( oCol:cHeader ) }
   end with

   with object ( ::oBrwDatabase:AddCol() )
      :cHeader          := "Correo electrónico"
      :cSortOrder       := "cMeiInt"
      :bEditValue       := {|| ( ::getWorkArea() )->cMeiInt }
      :nWidth           := 260
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::oOrderDatabase:Set( oCol:cHeader ) }
   end with

Return ( Self )   

//---------------------------------------------------------------------------//

METHOD selectColumn() CLASS TGenMailingDatabase

   local oCol
   local cOrd                

   if empty(::oBrwDatabase)
      Return ( Self )
   end if

   cOrd                       := ::oOrderDatabase:VarGet()

   with object ::oBrwDatabase

      for each oCol in :aCols
         if Equal( cOrd, oCol:cHeader )
            oCol:SetOrder()
         else
            oCol:cOrder       := " "
         end if
      next

   end with

   ::oBrwDatabase:Refresh()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD getDatabaseList() CLASS TGenMailingDatabase

   local nRecord

   CursorWait()

   ::aMailingList    := {}
   
   nRecord           := ( ::getWorkArea() )->( recno() )
   ( ::getWorkArea() )->( dbeval( {|| ::addDatabaseList() } ) )
   ( ::getWorkArea() )->( dbgoto( nRecord ) )

   CursorArrow()

Return ( ::aMailingList )

//--------------------------------------------------------------------------//

METHOD freeResources() CLASS TGenMailingDatabase

   ::Super:freeResources()

   if !empty(::oBmpDatabase)
      ::oBmpDatabase:end()
   end if 

   if !empty(::oFilter)
      ::oFilter:end()
   end if

Return ( Self )

//--------------------------------------------------------------------------//

METHOD dialogFilter() CLASS TGenMailingDatabase

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

   ::oBntCreateFilter:setText( "&Filtro activo" )

   ::oBntQuitFilter:Show()

   ::oBrwDatabase:Refresh()

Return ( Self )

//--------------------------------------------------------------------------//

METHOD quitFilter() CLASS TGenMailingDatabase

   destroyFastFilter( ::getWorkArea() )

   ::oBntCreateFilter:setText( "&Filtro" )

   ::oBntQuitFilter:Hide()

   ::oBrwDatabase:Refresh()

Return ( Self )

//--------------------------------------------------------------------------//

METHOD SelMailing( lValue ) CLASS TGenMailingDatabase

   DEFAULT lValue    := !( ::getWorkArea() )->lMail

   if dbDialogLock( ::getWorkArea() )
      ( ::getWorkArea() )->lMail   := lValue
      ( ::getWorkArea() )->( dbUnlock() )
   end if

   ::oBrwDatabase:Refresh()

Return ( Self )

//--------------------------------------------------------------------------//

METHOD SelAllMailing( lValue ) CLASS TGenMailingDatabase

   local hStatus

   DEFAULT lValue := .t.

   CursorWait()

   hStatus        := hGetStatus( ::getWorkArea(), 0 )
   ( ::getWorkArea() )->( dbeval( {|| ::selMailing( lValue ) } ) )
   hSetStatus( hStatus )

   CursorArrow()

Return ( Self )

//--------------------------------------------------------------------------//

