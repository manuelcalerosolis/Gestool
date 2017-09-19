#include "FiveWin.Ch"
#include "Factu.Ch"

#define dfnTreeViewWidth      250
#define dfnSplitterWidth      1
#define dfnSplitterHeight     76
#define dfnColorTop           rgb( 238, 110, 115 )

//------------------------------------------------------------------------//

CLASS SQLSelectorView FROM SQLNavigatorView 

   DATA oController

   DATA aRect

   METHOD New( oController )

   METHOD Activate()

   METHOD End()

   // Facades -----------------------------------------------------------------

   METHOD getModel()                      INLINE ( ::oController:getModel() )

   METHOD getModelColumns()               INLINE ( if( !empty( ::getModel() ), ::getModel():hColumns, ) )
   METHOD getModelExtraColumns()          INLINE ( if( !empty( ::getModel() ), ::getModel():hExtraColumns, ) )

   METHOD getModelColumnsForNavigator()   INLINE ( if( !empty( ::getModel() ), ::getModel():getColumnsForNavigator(), ) )
   METHOD getModelHeadersForNavigator()   INLINE ( if( !empty( ::getModel() ), ::getModel():getHeadersForNavigator(), ) )

   METHOD getModelHeaderFromColumnOrder() INLINE ( if( !empty( ::getModel() ), ::getModel():getHeaderFromColumnOrder(), ) )

   // MDI child----------------------------------------------------------------

   DATA oMdiChild

   METHOD CreateMDIChild()                INLINE ( ::oMdiChild := TMdiChild():New(  ::aRect[ 1 ], ::aRect[ 2 ], ::aRect[ 3 ], ::aRect[ 4 ], /*cTitle*/, /*nStyle*/, /*oMenu*/, oWnd(),;
                                                                                    /*oIcon*/, /*lVScroll*/, /*nClrText*/, /*nClrBack*/, /*oCursor*/, /*oBrush*/, /*lPixel*/ .t.,;
                                                                                    /*lHScroll*/, /*nHelpId*/, /*cBorder*/ "NONE", /*lSysMenu*/, /*lCaption*/ .f., /*lMin*/, /*lMax*/, /*nMenuInfo*/ ) )

   METHOD ActivateMDIChild()              INLINE ( ::oMdiChild:Activate() )   // cShow, bLClicked, bRClicked, bMoved, bResized, bPainted,;
                                                                              // bKeyDown, bInit, bUp, bDown, bPgUp, bPgDn,;
                                                                              // bLeft, bRight, bPgLeft, bPgRight, bValid )

   // Top webbar---------------------------------------------------------------

   DATA oTopWebBar

   METHOD CreateTopWebBar()

   // Tree menu----------------------------------------------------------------

   DATA oTreeMenu
   DATA oImageListTreeMenu
   DATA oButtonMainTreeMenu
   DATA hFastKeyTreeMenu                  INIT  {=>}

   METHOD CreateTreeMenu()

   METHOD AddImageTreeMenu()

   METHOD AddButtonTreeMenu()

   METHOD AddSearchButtonTreeMenu()    
   METHOD AddAppendButtonTreeMenu()    
   METHOD AddDuplicateButtonTreeMenu() 
   METHOD AddEditButtonTreeMenu()      
   METHOD AddZoomButtonTreeMenu()      
   METHOD AddDeleteButtonTreeMenu()    
   METHOD AddSalirButtonTreeMenu()     

   METHOD AddGeneralButtonTreeMenu()      INLINE ( ::AddSearchButtonTreeMenu(),;
                                                   ::AddAppendButtonTreeMenu(),;
                                                   ::AddDuplicateButtonTreeMenu(),;
                                                   ::AddEditButtonTreeMenu(),;
                                                   ::AddZoomButtonTreeMenu(),;
                                                   ::AddDeleteButtonTreeMenu() )

   METHOD AddAutoButtonTreeMenu()         INLINE ( ::AddGeneralButtonTreeMenu(),;
                                                   ::AddSalirButtonTreeMenu(),;
                                                   ::oButtonMainTreeMenu:Expand() )

   METHOD onClickTreeMenu()

   // XBrowse------------------------------------------------------------------

   DATA oBrowse

   METHOD CreateBrowse()

   METHOD GenerateColumnsBrowse()

   METHOD AddColumnBrowse( cColumn, hColumn )

   METHOD CreateFromCodeBrowse()          INLINE ( ::oBrowse:CreateFromCode() )

   // Splitters------------------------------------------------------------------

   DATA oVerticalSplitter
   DATA oHorizontalSplitter

   METHOD CreateSplitters()

   // Aplication windows bar---------------------------------------------------

   DATA oWindowsBar

   METHOD EnableWindowsBar()

   METHOD DisableWindowsBar()

   // Eventos------------------------------------------------------------------

   METHOD onChangeCombo()

   METHOD onClickHeaderBrowse()

   METHOD onChangeSearch()

   METHOD onBrowseKeyChar( nKey )

   METHOD refreshNavigator()              INLINE ( ::oTreeMenu:Select( ::oButtonMainTreeMenu ), ::oBrowse:SetFocus() )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oController )

   ::oController           := oController

   ::oImageListTreeMenu    := TImageList():New( 16, 16 )

   ::aRect                 := GetWndRect( GetDeskTopWindow() )

   ::oWindowsBar           := oWndBar()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Activate()

   ::CreateMDIChild()
   
   ::CreateTopWebBar()

   ::CreateTreeMenu()

      ::AddAutoButtonTreeMenu()

   ::CreateBrowse()

      ::GenerateColumnsBrowse()

      ::CreateFromCodeBrowse()

   ::CreateSplitters()

   ::ActivateMDIChild()

   ::oWindowsBar:setComboBoxChange( {|| ::onChangeCombo() } )

   ::oWindowsBar:setGetChange( {|| ::onChangeSearch() } ) 

   ::EnableWindowsBar()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD End()

   ::DisableWindowsBar()

   ::oController:End()

   if !empty( ::oMdiChild )
      ::oMdiChild:End()
   end if 

   if !empty( ::oImageListTreeMenu )
      ::oImageListTreeMenu:End()
   end if 

   if !empty( ::oTopWebBar )
      ::oTopWebBar:End()
   end if 

   if !empty( ::oBrowse )
      ::oBrowse:End()
   end if 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD CreateTopWebBar()

   ::oTopWebBar   := TWebBar():New( 0, dfnTreeViewWidth, ::aRect[ 4 ] - dfnTreeViewWidth, dfnSplitterHeight,,,, rgb( 255, 255, 255 ), dfnColorTop, , , , , , ::oMdiChild )
   
   ::oTopWebBar:Say( 0, dfnSplitterWidth + 10, ::oController:cTitle ) 

RETURN ( ::oTopWebBar  )

//----------------------------------------------------------------------------//

METHOD CreateBrowse() 

   ::oBrowse                  := SQLXBrowse():New( ::oMdiChild )
   ::oBrowse:nStyle           := nOr( WS_CHILD, WS_VISIBLE, WS_TABSTOP )
   ::oBrowse:l2007            := .f.

   ::oBrowse:lRecordSelector  := .f.
   ::oBrowse:lAutoSort        := .t.
   ::oBrowse:lSortDescend     := .f.   

   // Propiedades del control -------------------------------------------------

   ::oBrowse:nMarqueeStyle    := MARQSTYLE_HIGHLROWMS

   ::oBrowse:bClrStd          := {|| { CLR_BLACK, CLR_WHITE } }
   ::oBrowse:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrowse:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrowse:bRClicked        := {| nRow, nCol, nFlags | ::RButtonDown( nRow, nCol, nFlags ) }

   ::oBrowse:setModel( ::getModel() )

   ::oBrowse:bKeyChar         := {|nKey| ::onBrowseKeyChar( nKey ) }

   ::oBrowse:bLDblClick       := {|| ::oController:Edit(), ::refreshNavigator() }

   // Dimensiones del control -------------------------------------------------

   ::oBrowse:nTop             := dfnSplitterHeight + dfnSplitterWidth

   ::oBrowse:nLeft            := dfnTreeViewWidth + dfnSplitterWidth 
   ::oBrowse:nRight           := ::oMdiChild:nRight - ::oMdiChild:nLeft
   ::oBrowse:nBottom          := ::oMdiChild:nBottom - ::oMdiChild:nTop

RETURN ( ::oBrowse )

//---------------------------------------------------------------------------//

METHOD GenerateColumnsBrowse()

   local hColumnstoBrowse  := ::getModelColumnsForNavigator()

   msgalert( hb_valtoexp( hColumnstoBrowse ) )

   if empty( hColumnstoBrowse )
      RETURN ( self )
   end if 

   hEval( hColumnstoBrowse, { | cColumn, hColumn | ::addColumnBrowse( cColumn, hColumn ) } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD addColumnBrowse( cColumn, hColumn )
   
   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := "cColumn"
      :cHeader             := "header" 
      :nWidth              := 100
//      :bLClickHeader       := {| nMRow, nMCol, nFlags, oColumn | ::onClickHeaderBrowse( oColumn ) }
      :bEditValue          := {|| "cColumn" }
   end with

/*
   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := cColumn
      :cHeader             := hColumn[ "header" ]
      :nWidth              := hColumn[ "width" ]
      :bLClickHeader       := {| nMRow, nMCol, nFlags, oColumn | ::onClickHeaderBrowse( oColumn ) }
      :bEditValue          := ::getModel():getEditValue( cColumn )
   end with
*/

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD CreateSplitters()

   ::oHorizontalSplitter         := TSplitter():New(  /*nRow*/ dfnSplitterHeight, /*nCol*/ dfnTreeViewWidth, /*lVertical*/ .f.,;
                                                      /*aPrevCtrols*/ { ::oTopWebBar }, /*lAdjPrev*/ .t.,;
                                                      /*aHindCtrols*/ { ::oBrowse }, /*lAdjHind*/ .t.,;
                                                      /*bMargin1*/ {|| 0}, /*bMargin2*/ {|| 0}, /*oWnd*/ ::oMdiChild,;
                                                      /*bChange*/, /*nWidth*/ ::aRect[ 4 ], /*nHeight*/ dfnSplitterWidth, /*lPixel*/ .t.,;
                                                      /*l3D*/ .t., /*nClrBack*/ rgb( 255, 255, 255 ), /*lDesign*/ .f.,;
                                                      /*lUpdate*/ .f., /*lStyle*/ .f., /*aGradient*/, /*aGradientOver*/ )
   ::oHorizontalSplitter:lStatic := .t.

   ::oVerticalSplitter           := TSplitter():New( /*nRow*/ 0, /*nCol*/ dfnTreeViewWidth, /*lVertical*/ .t.,;
                                                      /*aPrevCtrols*/ { ::oTreeMenu }, /*lAdjPrev*/ .t., /*aHindCtrols*/ { ::oTopWebBar, ::oHorizontalSplitter, ::oBrowse },;
                                                      /*lAdjHind*/ .t., /*bMargin1*/ {|| 0}, /*bMargin2*/ {|| 0}, /*oWnd*/ ::oMdiChild,;
                                                      /*bChange*/, /*nWidth*/ dfnSplitterWidth, /*nHeight*/ ::aRect[ 3 ] - dfnSplitterHeight, /*lPixel*/ .t., /*l3D*/.t.,;
                                                      /*nClrBack*/ , /*lDesign*/ .f., /*lUpdate*/ .t., /*lStyle*/ .t. )  


RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CreateTreeMenu()

   ::oTreeMenu                := TTreeView():New( 0, 0, ::oMdiChild, , , .t., .f., dfnTreeViewWidth, ::aRect[ 3 ] - dfnSplitterHeight ) // Rgb( 51, 51, 51 )
   
   ::oTreeMenu:SetImagelist( ::oImageListTreeMenu )

   ::oTreeMenu:SetItemHeight( 20 )

   ::oTreeMenu:OnClick        := {|| ::onClickTreeMenu() }

   if !empty( ::oController:cImage )
      ::oButtonMainTreeMenu   := ::oTreeMenu:Add( ::oController:cTitle, ::AddImageTreeMenu( ::oController:cImage ) )
   end if 

RETURN ( ::oTreeMenu  )

//----------------------------------------------------------------------------//

METHOD AddButtonTreeMenu( cText, cResource, bAction, cKey, nLevel, oGroup, lAllowExit ) 

   local oTreeButton

   DEFAULT oGroup       := ::oButtonMainTreeMenu
   DEFAULT lAllowExit   := .f.

   // El nombre del boton es necesario-----------------------------------------

   if empty( cText )
      RETURN ( nil )
   end if 

   // Chequeamos los niveles de acceso si es mayor no montamos el boton--------

   if nLevel != nil .and. nAnd( ::oController:nLevel, nLevel ) == 0
      RETURN ( nil )
   end if

   oTreeButton          := oGroup:Add( cText, ::AddImageTreeMenu( cResource ), bAction )
   oTreeButton:Cargo    := lAllowExit

   if hb_ischar( cKey )
      hset( ::hFastKeyTreeMenu, cKey, bAction )
   end if

RETURN ( oTreeButton )

//----------------------------------------------------------------------------//

METHOD AddImageTreeMenu( cImage )

   local oImage
   local nImageList  := 0

   if empty( cImage )
      RETURN ( nImageList )
   end if 

   oImage            := TBitmap():Define( cImage )
   oImage:cResName   := cImage

   ::oImageListTreeMenu:addMasked( oImage, Rgb( 255, 0, 255 ) )
   
   nImageList        := len( ::oImageListTreeMenu:aBitmaps ) - 1

RETURN ( nImageList )

//----------------------------------------------------------------------------//

METHOD AddSearchButtonTreeMenu()    

RETURN ( ::AddButtonTreeMenu( "Buscar", "Bus16", {|| ::oWindowsBar:SetFocusGet() }, "B" ) )

METHOD AddAppendButtonTreeMenu()    

RETURN ( ::AddButtonTreeMenu( "Añadir", "New16", {|| ::oController:Append(), ::refreshNavigator() }, "A", ACC_APPD ) )

METHOD AddDuplicateButtonTreeMenu() 

RETURN ( ::AddButtonTreeMenu( "Duplicar", "Dup16", {|| ::oController:Duplicate(), ::refreshNavigator() }, "D", ACC_APPD ) )

METHOD AddEditButtonTreeMenu()      

RETURN ( ::AddButtonTreeMenu( "Modificar", "Edit16", {|| ::oController:Edit(), ::refreshNavigator() }, "M", ACC_EDIT ) )

METHOD AddZoomButtonTreeMenu()      

RETURN ( ::AddButtonTreeMenu( "Zoom", "Zoom16", {|| ::oController:Zoom(), ::refreshNavigator() }, "Z", ACC_ZOOM ) )

METHOD AddDeleteButtonTreeMenu()    

RETURN ( ::AddButtonTreeMenu( "Eliminar", "Del16", {|| ::oController:Delete( ::oBrowse:aSelected ), ::refreshNavigator() }, "E", ACC_DELE ) )

METHOD AddSalirButtonTreeMenu()

RETURN ( ::AddButtonTreeMenu( "Salir", "End16", {|| ::End() }, "S" ) )

//----------------------------------------------------------------------------//

METHOD onClickTreeMenu()

   local oItem       := ::oTreeMenu:GetSelected()

   if empty( oItem )
      RETURN ( nil )
   end if 

   if ( oItem:ClassName() != "TTVITEM" ) 
      RETURN ( nil )
   end if 

   if ( !hb_isblock( oItem:bAction ) )
      RETURN ( nil )
   end if 

   eval( oItem:bAction )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD EnableWindowsBar()

   if empty( ::oWindowsBar )
      RETURN ( Self )
   end if 

   ::oWindowsBar:EnableGet()

   ::oWindowsBar:EnableComboBox( ::getModelHeadersForNavigator() )

   ::oWindowsBar:setCombo( ::getModelHeaderFromColumnOrder() )

   ::oBrowse:selectColumnOrderByHeader( ::getModelHeaderFromColumnOrder() )

   ::refreshNavigator()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD DisableWindowsBar()

   if empty( ::oWindowsBar )
      RETURN ( Self )
   end if 

   ::oWindowsBar:DisableGet()

   ::oWindowsBar:DisableComboBox()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD onChangeCombo( oColumn )

   local oComboBox   := ::oWindowsBar:oComboBox()

   if empty( oComboBox )
      RETURN ( Self )
   end if 

   if empty( oColumn )
      oColumn        := ::oBrowse:getColumnByHeader( oComboBox:VarGet() )
   end if 

   if empty( oColumn )
      RETURN ( Self )
   end if 

   oComboBox:set( oColumn:cHeader )

   ::oController:changeModelOrderAndOrientation( oColumn:cSortOrder, oColumn:cOrder )

   ::oBrowse:selectColumnOrder( oColumn )

   ::oBrowse:refreshCurrent()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD onClickHeaderBrowse( oColumn )

   local oCombobox   := ::oWindowsBar:oComboBox()

   if empty( oComboBox )
      RETURN ( Self )
   end if 

   if empty( oColumn )
      RETURN ( Self )
   end if 

   if ascan( oCombobox:aItems, oColumn:cHeader ) == 0
      RETURN ( Self )
   end if

   oComboBox:Set( oColumn:cHeader )
   
RETURN ( ::onChangeCombo() )

//---------------------------------------------------------------------------//

METHOD onChangeSearch()

   local uValue
   local nFind          := 0
   local oSearch        := ::oWindowsBar:oGet()
   local cOrder         := ::oWindowsBar:GetComboBox()
   local cColumnOrder   := ::oBrowse:getColumnOrderByHeader( cOrder )

   if empty( oSearch )
      RETURN ( Self )
   end if 

   if empty( cColumnOrder )
      RETURN ( Self )
   end if 

   uValue               := oSearch:oGet:Buffer()
   uValue               := alltrim( upper( cvaltochar( uValue ) ) )
   uValue               := strtran( uValue, chr( 8 ), "" )
   
   if ::getModel():find( uValue, cColumnOrder )
      oSearch:SetColor( Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) )
   else
      oSearch:SetColor( Rgb( 255, 255, 255 ), Rgb( 255, 102, 102 ) )
   end if
   
   ::oBrowse:refreshCurrent()

RETURN ( nFind > 0 )

//----------------------------------------------------------------------------//

METHOD onBrowseKeyChar( nKey )

RETURN ( heval( ::hFastKeyTreeMenu, {|k,v| if( nKey == asc( upper( k ) ) .or. nKey == asc( lower( k ) ), eval( v ), ) } ) ) 
   
//----------------------------------------------------------------------------//

