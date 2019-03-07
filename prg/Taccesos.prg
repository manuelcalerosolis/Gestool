#include "FiveWin.Ch"
#include "Factu.ch" 

#define RB_SETBKCOLOR   (WM_USER +  19) // sets the default BK color 

//----------------------------------------------------------------------------//

CLASS TAcceso

   DATA  cDbf
   DATA  lOpenFiles                 INIT  .f.

   DATA  oBmpLogo

   DATA  oImageList
   DATA  oImageListBig

   DATA  oTree
   DATA  oReBar
   DATA  oToolBar
   DATA  oSearchBar
   DATA  oOfficeBar

   DATA  oEmpresaBar

   DATA  oFavoritosBar
   DATA  oFavoritosGroup

   DATA lCreateEmpresaOfficeBar     INIT .t.
   DATA lCreateFavoritosOfficeBar   INIT .t.

   DATA  oGet
   DATA  cGet                       INIT  space( 200 )
   DATA  bGetChange                 

   DATA  oComboBox
   DATA  cComboBox
   DATA  aComboBox                  INIT  {'id', 'c�digo'}

   DATA  oComboFilter
   DATA  cComboFilter               INIT  __txtFilters__ 
   DATA  aComboFilter               INIT  {__txtFilters__}

   DATA  oYearComboBox
   DATA  cYearComboBox              INIT  __txtAllYearsFilter__
   DATA  aYearComboBox              INIT  {}
   DATA  lYearComboBox              INIT  .t.

   DATA  cYearComboBoxExpression

   DATA  oButtonDeleteFilter
   DATA  oButtonAddFilter
   DATA  oButtonCleanFilter
   DATA  oButtonEditFilter

   DATA  aAccesos

   DATA  lBig                       INIT  .f.
   DATA  lTactil                    INIT  .f.

   DATA  nLittleButtons

   METHOD New() CONSTRUCTOR
   METHOD End()

   METHOD Add()

   METHOD CreateImageList()
   METHOD AddImageList( aAccesos )
   METHOD SetImageList()

   METHOD CreateTree()
   METHOD AddTree( cPrompt, nImage, Cargo )

   METHOD AddBitmapMasked( oAcceso )

   METHOD EditButtonBar()
   METHOD InitButtonBar()

   METHOD Save()
   METHOD SaveTree()
   METHOD saveItem( oItem, Uuid )

   METHOD LoadTree()
   METHOD setItem()

   METHOD CreateButtonBar( oWnd )

   METHOD CreateFavoritosOfficeBar()

   METHOD CreateToolbar( aAccesos )
   METHOD AddToolBar( oToolBar, oAcceso )

   METHOD lGetShowToolBar( oAcceso, cCurUsr )

   METHOD lHideCarpeta( oAcceso, cCurUsr )

   METHOD CreateSearchBar()
   METHOD EndSearchBar()
   METHOD HideSearchBar()                 INLINE ( ::HideGet(),;
                                                   ::HideComboFilter(),;
                                                   ::HideDeleteButtonFilter(),;
                                                   ::HideAddButtonFilter(),;
                                                   ::HideEditButtonFilter(),;
                                                   ::HideCleanButtonFilter(),;
                                                   ::HideYearComboBox() )

   METHOD InsertSearchBand()              INLINE ( ::oReBar:InsertBand( ::oSearchBar, "Buscar " ) )
   METHOD DeleteSearchBand()              INLINE ( ::oReBar:DeleteBand(), ::oSearchBar := nil )

   METHOD CreateLogo( oWnd )

   METHOD InsertToolBand()                INLINE ( ::oReBar:InsertBand( ::oToolBar ) )
   METHOD DeleteToolBand()                INLINE ( ::oReBar:DeleteBand(), ::oToolBar := nil )

   METHOD CreateOfficeBar()
   METHOD ReCreateOfficeBar()
   METHOD InsertOfficeBand()              INLINE ( ::oReBar:InsertBand( ::oOfficeBar ) )

   METHOD setBitmapGet()

   METHOD CreateCarpetaOfficeBar( aAccesos )
   METHOD CreateBotonesOfficeBar( aAcceso, oCarpeta, oGrupo )

   METHOD setComboFilterItem( cItem )     INLINE ( if( !empty( ::oComboFilter ), ( ::oComboFilter:Set( cItem ) ), ) )
   METHOD setComboFilterItems( aItems )   INLINE ( if( !empty( ::oComboFilter ), ::oComboFilter:SetItems( aItems, .f. ), ) )
   METHOD setComboFilterSelect( nItems )  INLINE ( if( !empty( ::oComboFilter ), ( ::oGet:cText( space( 200 ) ), ::oGet:oGet:Home(), ::oComboFilter:Select( nItems ) ), ) )
   METHOD setComboFilterChange( bBlock )  INLINE ( if( !empty( ::oComboFilter ), ( ::oComboFilter:bChange := bBlock ), ) )
   METHOD evalComboFilterChange()         INLINE ( if( !empty( ::oComboFilter ) .and. !empty( ::oComboFilter:bChange ), eval( ::oComboFilter:bChange ), ) )
   METHOD getComboFilter()                INLINE ( if( !empty( ::oComboFilter ), ( ::oComboFilter:VarGet() ), "" ) )
   METHOD getComboFilterAt()              INLINE ( if( !empty( ::oComboFilter ), ( ::oComboFilter:nAt ), 0 ) )
   METHOD hideComboFilter()               INLINE ( if( !empty( ::oComboFilter ), ::oComboFilter:Hide(), ) )

   METHOD DisableComboFilter()            INLINE ( if( !empty( ::oComboFilter ), ( ::setComboFilterChange( nil ), ::oComboFilter:Hide() ), ) )
   METHOD EnableComboFilter( aItems )
   METHOD SetDefaultComboFilter()         INLINE ( if( !empty( ::oComboFilter ), ::oComboFilter:Set( __txtFilters__ ), ) )
   METHOD SetComboFilter( cItem )         INLINE ( if( !empty( ::oComboFilter ), ( ::oComboFilter:Set( cItem ), ::evalComboFilterChange() ), ) )
   METHOD AddComboFilter( cItem )         INLINE ( if( !empty( ::oComboFilter ), ::oComboFilter:Add( cItem ), ) )

   METHOD SetGetChange( bBlock )          INLINE ( if( !empty( ::oGet ), ( ::bGetChange         := bBlock ), ) )
   METHOD EvalGetChange( bBlock )         

   METHOD SetGetPostKey( bBlock )         INLINE ( if( !empty( ::oGet ), ( ::oGet:bPostKey      := bBlock ), ) )
   METHOD SetGetValid( bBlock )           INLINE ( if( !empty( ::oGet ), ( ::oGet:bValid        := bBlock ), ) )
   METHOD SetGetLostFocus( bBlock )       INLINE ( if( !empty( ::oGet ), ( ::oGet:bLostFocus    := bBlock ), ) )
   METHOD SetGetKeyDown( bBlock )         INLINE ( if( !empty( ::oGet ), ( ::oGet:bKeyDown      := bBlock ), ) )
   METHOD SetGetKeyChar( bBlock )         INLINE ( if( !empty( ::oGet ), ( ::oGet:bKeyChar      := bBlock ), ) )
   METHOD SetGetKeyUp( bBlock )           INLINE ( if( !empty( ::oGet ), ( ::oGet:bKeyUp        := bBlock ), ) )

   METHOD DisableGet()                    INLINE ( if( !empty( ::oGet ), ( ::oGet:cText( space( 200 ) ), ::oGet:Hide(), ::oGet:SetColor( Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) ) ), ) )
   METHOD EnableGet()                     INLINE ( if( !empty( ::oGet ), ( ::oGet:Enable(), ::oGet:Show(), ::oGet:SetColor( Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) ) ), ) )
   METHOD CleanGet()                      INLINE ( if( !empty( ::oGet ), ( ::oGet:cText( space( 200 ) ), ::oGet:SetColor( Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) ) ), ) )
   METHOD SetGetFocus()                   INLINE ( if( !empty( ::oGet ), ::oGet:SetFocus(), ) )
   METHOD SetFocusGet()                   INLINE ( if( !empty( ::oGet ), ::oGet:SetFocus(), ) )   
   METHOD HideGet()                       INLINE ( if( !empty( ::oGet ), ::oGet:Hide(), ) )

   METHOD ShowAddButtonFilter()           INLINE ( if( !empty( ::oButtonAddFilter ), ::oButtonAddFilter:Show(), ) )
   METHOD HideAddButtonFilter()           INLINE ( if( !empty( ::oButtonAddFilter ), ::oButtonAddFilter:Hide(), ) )
   METHOD SetActionAddButtonFilter( bAction );
                                          INLINE ( if( !empty( ::oButtonAddFilter ), ( ::oButtonAddFilter:bAction := bAction ), ) )

   METHOD ShowCleanButtonFilter()         INLINE ( if( !empty( ::oButtonCleanFilter ), ::oButtonCleanFilter:Show(), ) )
   METHOD HideCleanButtonFilter()         INLINE ( if( !empty( ::oButtonCleanFilter ), ::oButtonCleanFilter:Hide(), ) )
   METHOD SetActionCleanButtonFilter( bAction );
                                          INLINE ( if( !empty( ::oButtonCleanFilter ), ( ::oButtonCleanFilter:bAction := bAction ), ) )

   METHOD ShowEditButtonFilter()          INLINE ( if( !empty( ::oButtonEditFilter ), ::oButtonEditFilter:Show(), ) )
   METHOD HideEditButtonFilter()          INLINE ( if( !empty( ::oButtonEditFilter ), ::oButtonEditFilter:Hide(), ) )
   METHOD SetActionEditButtonFilter( bAction );
                                          INLINE ( if( !empty( ::oButtonEditFilter ), ( ::oButtonEditFilter:bAction := bAction ), ) )

   METHOD ShowDeleteButtonFilter()        INLINE ( if( !empty( ::oButtonDeleteFilter ), ::oButtonDeleteFilter:Show(), ) )
   METHOD HideDeleteButtonFilter()        INLINE ( if( !empty( ::oButtonDeleteFilter ), ::oButtonDeleteFilter:Hide(), ), if( !empty( ::oComboFilter ), ::oComboFilter:Select( 1 ), ) )
   METHOD SetActionDeleteButtonFilter( bBlock );
                                          INLINE ( if( !empty( ::oButtonDeleteFilter ), ( ::oButtonDeleteFilter:bAction := bBlock ), ) )

   METHOD ShowYearComboBox()              INLINE ( if( !empty( ::oYearComboBox ), ( ::lYearComboBox := .t., ::oYearComboBox:Show(), ::oYearComboBox:Set( 1 ) ), ) )
   METHOD HideYearComboBox()              INLINE ( if( !empty( ::oYearComboBox ), ( ::lYearComboBox := .f., ::oYearComboBox:bChange := nil, ::oYearComboBox:Hide() ), ) )
   METHOD lAllYearComboBox()              INLINE ( if( !empty( ::oYearComboBox ), ( ::oYearComboBox:nAt == 1 ), .f. ) )
   METHOD cYearComboBox()                 INLINE ( if( !empty( ::oYearComboBox ), ( ::oYearComboBox:varget() ), "" ) )
   METHOD setYearComboBox( nYear )        
   METHOD nYearComboBox()                 INLINE ( if( !empty( ::oYearComboBox ), ( Val( ::oYearComboBox:varget() ) ), 0 ) )
   METHOD setYearComboBoxExpression( cExpression );
                                          INLINE ( if( !empty( ::oYearComboBox ), ::cYearComboBoxExpression := cExpression, ) )
   METHOD getYearComboBoxExpression()     INLINE ( if( !empty( ::oYearComboBox ) .and. ::lYearComboBox, ::cYearComboBoxExpression, "" ) )
   METHOD setYearComboBoxChange( bBlock ) INLINE ( if( !empty( ::oYearComboBox ), ( ::oYearComboBox:bChange  := bBlock ), ) )

   METHOD Disable()                       INLINE ( CursorWait(),  if( !empty( ::oOfficeBar ), ( ::oOfficeBar:Disable(), SysRefresh() ), ) )
   METHOD Enable()                        INLINE ( CursorWE(),    if( !empty( ::oOfficeBar ), ( ::oOfficeBar:Enable(), SysRefresh() ), ) )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New() CLASS TAcceso

   local n
   local nSize

   ::aAccesos        := {}
   ::cGet            := space( 200 )
   ::cYearComboBox   := __txtAllYearsFilter__

   /*
   Rellenamos los a�os---------------------------------------------------------
   */

   aAdd( ::aYearComboBox, __txtAllYearsFilter__ )
   for n := 2000 to year( date() )
      aAdd( ::aYearComboBox, str( n, 4 ) )
   next

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Add() CLASS TAcceso

   local oAcceso  := TItemAcceso():New()

   aAdd( ::aAccesos, oAcceso )

RETURN oAcceso

//----------------------------------------------------------------------------//

METHOD CreateImageList()

   ::oImageList         := TImageList():New( 16, 16 )
   ::oImageListBig      := TImageList():New( 32, 32 )

   ::AddImageList( ::aAccesos )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD SetImageList( oTree )

   DEFAULT oTree        := ::oTree

   if empty( ::oImageList )
      ::CreateImageList()
   end if

   oTree:SetImagelist( ::oImageList )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD AddImageList( aAccesos )

   DEFAULT aAccesos  := ::aAccesos

   aeval( aAccesos,  {|oItem| ::addBitmapMasked( oItem ),;
                              if( len( oItem:aAccesos ) > 0, ::AddImageList( oItem:aAccesos ), ) } )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD CreateTree( oTree, aAccesos )

   local n

   DEFAULT oTree     := ::oTree
   DEFAULT aAccesos  := ::aAccesos

   for n := 1 to len( aAccesos )

      if len( aAccesos[ n ]:aAccesos ) > 0
         ::CreateTree( ::AddTree( oTree, aAccesos[ n ] ), aAccesos[ n ]:aAccesos )
      else
         ::AddTree( oTree, aAccesos[ n ] )
      end if

   next

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD AddTree( oTree, oAcceso )

   local oItemTree   := oTree:Add( oAcceso:cPrompt, oAcceso:nImageList, oAcceso:cId )

   if !empty( ::oTree )
      ::oTree:SetCheck( oItemTree, oAcceso:lShow ) 
   end if

RETURN ( oItemTree )

//----------------------------------------------------------------------------//

METHOD AddBitmapMasked( oAcceso )

   ::oImageList:AddMasked( TBitmap():Define( oAcceso:cBmp ), Rgb( 255, 0, 255 ) )
   ::oImageListBig:AddMasked( TBitmap():Define( oAcceso:cBmpBig ), Rgb( 255, 0, 255 ) )

   oAcceso:nImageList   := len( ::oImageList:aBitmaps ) - 1

RETURN nil

//---------------------------------------------------------------------------//

METHOD EditButtonBar( oWnd, oMenuItem )

   local oDlg
   local nLevel
   local oBmpGeneral

   DEFAULT oWnd      := oWnd()
   DEFAULT oMenuItem := "configurar_botones"

   nLevel            := Auth():Level( oMenuItem )
   if nAnd( nLevel, 1 ) == 0
      msgStop( "Acceso no permitido." )
      RETURN nil
   end if

   DEFINE DIALOG oDlg RESOURCE "ButtonBar"

   REDEFINE BITMAP oBmpGeneral ;
      ID       500 ;
      RESOURCE "gc_magic_wand_48" ;
      TRANSPARENT ;
      OF       oDlg

   ::oTree     := TTreeView():Redefine( 100, oDlg )

   REDEFINE BUTTON ;
      ID       3 ;
      OF       oDlg ;
      ACTION   ( ::Default() )

   REDEFINE BUTTON ;
      ID       IDOK ;
      OF       oDlg ;
      ACTION   ( ::Save( oDlg ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
      OF       oDlg ;
      CANCEL ;
      ACTION   ( oDlg:End() )

   oDlg:AddFastKey( VK_F5, {|| ::Save( oDlg ) } )

   oDlg:Activate( , , , .t., , , {|| ::InitButtonBar() } )

   if !empty( oBmpGeneral )
      oBmpGeneral:End()
   end if

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD InitButtonBar()

   ::SetImageList()

   ::CreateTree()

   ::LoadTree()

RETURN nil

//---------------------------------------------------------------------------//

METHOD Save( oDlg )

   ::SaveTree( Auth():Uuid(), ::oTree:aItems )

   ::ReCreateOfficeBar()

   oDlg:End( IDOK )

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD SaveTree( Uuid, aItems )

   aeval( aItems,;
            {|oItem| ::saveItem( Uuid, oItem, ::oTree:GetCheck( oItem ) ),;
                     if( !empty( oItem:aItems ), ::SaveTree( Uuid, oItem:aItems ), ) } )

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD saveItem( Uuid, oItem, lVisible )

   if hb_ischar( oItem:bAction ) 
      SQLUsuarioFavoritosModel():set( Uuid, oItem:bAction, lVisible ) 
   end if 

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD setItem( Uuid, oItem )

   local nVisible := SQLUsuarioFavoritosModel():get( Uuid, oItem:bAction )

   if hb_isnumeric( nVisible ) .and. ( nVisible == 1 )
      ::oTree:SetCheck( oItem, .t. )
   end if 

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD LoadTree( Uuid, aItems )

   DEFAULT Uuid   := Auth():Uuid()
   DEFAULT aItems := ::oTree:aItems

   aeval( aItems,;
            {|oItem| ::setItem( Uuid, oItem ),;
                     if( !empty( oItem:aItems ), ::LoadTree( Uuid, oItem:aItems ), ) } )

RETURN nil

//--------------------------------------------------------------------------//

METHOD CreateButtonBar( oWnd, lCreateButtonBar )

   DEFAULT oWnd               := oWnd()
   DEFAULT lCreateButtonBar   := .t.

   ::oReBar                   := TPanelEx():New( 0, 0, if( ::lTactil, 124, 150 ), 1000, oWnd, Rgb( 255, 255, 255 ), .f. ) 

   oWnd:oTop                  := ::oReBar

   ::CreateOfficeBar()

   if !::lTactil
      ::CreateSearchBar( oWnd )
      ::HideSearchBar()
   end if

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD CreateToolbar( aAccesos )

   local n
   local cCurUsr              := Auth():Codigo()

   DEFAULT aAccesos           := ::aAccesos

   if empty( ::oToolBar )

      if ::lBig
         if ::lTactil
            ::oToolBar        := TToolBar():New( ::oReBar, 50, 50, ::oImageListBig, .t. )
         else
            ::oToolBar        := TToolBar():New( ::oReBar, 36, 36, ::oImageListBig, .t. )
         end if
      else
         ::oToolBar           := TToolBar():New( ::oReBar, 20, 20, ::oImageList, .t. )
      end if

      ::oToolBar:nWidth       := 0

      ::oToolBar:SetBrush( TBrush():New( , Rgb( 255,255,255 ) ) )

   end if

   for n := 1 to len( aAccesos )

      if len( aAccesos[ n ]:aAccesos ) > 0
         ::CreateToolbar( aAccesos[ n ]:aAccesos )
         ::oToolBar:AddSeparator()
         ::oToolBar:nWidth    += 4
      else
         ::AddToolBar( aAccesos[ n ], cCurUsr )
      end if

   next

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD CreateSearchBar( oWnd )

   @ 124, 4 GET      ::oGet ;
            VAR      ::cGet ;
            OF       ::oRebar ;
            FONT     oFontLittleTitle() ;
            PIXEL    SIZE 244, 21 ;

   ::oGet:bChange    := {| nKey, nFlags, oGet | ::evalGetChange( nKey, nFlags, oGet ) }
   ::oGet:bHelp      := {|| ::oGet:cText( space( 200 ) ), ::evalGetChange() }
   ::oGet:cBmp       := "Lupa"

   @ 124, 254 COMBOBOX ::oComboFilter ;
            VAR      ::cComboFilter ;
            ITEMS    ::aComboFilter ;
            STYLE    2 ;
            OF       ::oRebar ;
            FONT     oFontLittleTitle() ;
            PIXEL    SIZE 200, 30

   ::oComboFilter:Disable()

   @ 125, 466 BTNBMP ::oButtonAddFilter ;
            RESOURCE "gc_funnel_add_16" ;
            SIZE     18, 18 ;
            OF       ::oRebar ;
            NOBORDER ;
            ACTION   ( msgStop( "A�adir filtro" ) ) 

   ::oButtonAddFilter:cTooltip      := "A�adir un nuevo filtro"
   ::oButtonAddFilter:lTransparent 	:= .t.
   ::oButtonAddFilter:lBoxSelect 	:= .f.

   @ 125, 492 BTNBMP ::oButtonCleanFilter ;
            RESOURCE "gc_funnel_broom_16" ;
            SIZE     18, 18 ;
            OF       ::oRebar ;
            NOBORDER 

   ::oButtonCleanFilter:cTooltip       := "Limpiar el filtro actual"
   ::oButtonCleanFilter:bAction        := {|| ::setComboFilterItem( "" ), ::evalComboFilterChange() }
   ::oButtonCleanFilter:lTransparent   := .t.
   ::oButtonCleanFilter:lBoxSelect 	   := .f.

   @ 125, 518 BTNBMP ::oButtonEditFilter ;
            RESOURCE "gc_funnel_edit_16" ;
            SIZE     18, 18 ;
            OF       ::oRebar ;
            NOBORDER ;
            ACTION   ( msgStop( "Editar filtro activo" ) )

   ::oButtonEditFilter:cTooltip        := "Modificar el filtro seleccionado"
   ::oButtonEditFilter:lTransparent    := .t.
   ::oButtonEditFilter:lBoxSelect      := .f.

   @ 125, 544 BTNBMP ::oButtonDeleteFilter ;
            RESOURCE "gc_funnel_delete_16" ;
            SIZE     18, 18 ;
            OF       ::oRebar ;
            NOBORDER ;
            ACTION   ( msgStop( "Quitar filtro activo" ) )

   ::oButtonDeleteFilter:cTooltip      := "Eliminar el filtro seleccionado"
   ::oButtonDeleteFilter:lTransparent  := .t.
   ::oButtonDeleteFilter:lBoxSelect    := .f.

   @ 124, 570 COMBOBOX ::oYearComboBox ;
            VAR      ::cYearComboBox ;
            ITEMS    ::aYearComboBox ;
            STYLE    3 ;
            OF       ::oRebar ;
            FONT     oFontLittleTitle() ;
            PIXEL    SIZE 60, 30

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD EndSearchBar( oWnd )

   if !empty( ::oGet )
      ::oGet:End()
   end if 

   if !empty( ::oComboFilter )
      ::oComboFilter:End()
   end if 

   if !empty( ::oButtonAddFilter )
      ::oButtonAddFilter:end()
   end if 

   if !empty( ::oButtonCleanFilter )
      ::oButtonCleanFilter:end()
   end if 
   
   if !empty( ::oButtonEditFilter )
      ::oButtonEditFilter:End()
   end if 

   if !empty( ::oButtonDeleteFilter )
      ::oButtonDeleteFilter:End()
   end if

   if !empty( ::oYearComboBox )
      ::oYearComboBox:End()
   end if 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD setBitmapGet()

   local cText    

   ::oGet:Assign()

   cText       := alltrim( ::oGet:VarGet() )

   if empty( cText ) .and. ( ::oGet:oBmp:cResName != "Lupa" )
      ::oGet:oBmp:setBmp( "Lupa" )
   end if 

   if !empty( cText ) .and. ( ::oGet:oBmp:cResName != "Del16" )
      ::oGet:oBmp:setBmp( "Del16" )
   end if 

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD EvalGetChange( nKey, nFlags, oGet )

   if empty( ::oGet )
      RETURN ( .t. )
   end if 

   if !empty( ::bGetChange )
      eval( ::bGetChange, nKey, nFlags, oGet ) 
   end if 

   ::setBitmapGet()

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD CreateLogo()

   if empty( ::oBmpLogo )

      @ 120, ( ::oRebar:nWidth() - 138 ) ;
            BITMAP   ::oBmpLogo ;
            RESOURCE "GesTool" ;
            PIXEL ;
            NOBORDER ;
            OF       ::oRebar

   else

      ::oBmpLogo:Move( 120, ( ::oRebar:nWidth() - 138 ), 134, 32, .t. )

   end if

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD AddToolBar( oAcceso, cCurUsr )

   if ::lTactil
      ::oToolBar:AddButton( oAcceso:bAction, oAcceso:nImageList + 1, AnsiToOem( oAcceso:cPrompt ), oAcceso:cPrompt )
      ::oToolBar:nWidth       += 50
   else
      if ::lGetShowToolBar( oAcceso, cCurUsr )
         ::oToolBar:AddButton( oAcceso:bAction, oAcceso:nImageList + 1, AnsiToOem( oAcceso:cPrompt ) )
         ::oToolBar:nWidth    += 23
      end if
   end if

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD lGetShowToolBar( oAcceso, cCurUsr )

   DEFAULT cCurUsr   := Auth():Codigo()

   if empty( cCurUsr )
      RETURN ( oAcceso:lShow )
   end if 

   if ::lOpenFiles .and. dbSeekInOrd( cCurUsr + oAcceso:cId, "cOpcion", ::cDbf )
      RETURN ( ( ::cDbf )->lShow )
   end if

RETURN ( .f. )

//----------------------------------------------------------------------------//

METHOD lHideCarpeta( oAcceso, cCurUsr )

   local lHide       := .f.

   DEFAULT cCurUsr   := Auth():Codigo()

   if ::lOpenFiles .and. dbSeekInOrd( cCurUsr + oAcceso:cPrompt, "cOpcion", ::cDbf )
      lHide          := !( ::cDbf )->lShow
   end if

RETURN ( lHide )

//----------------------------------------------------------------------------//

METHOD CreateOfficeBar()

   local oAcceso

   ::oOfficeBar                        := TDotNetBar():New( 0, 0, 1000, 120, ::oReBar, 1 )
   ::oOfficeBar:lPaintAll              := .f.
   ::oOfficeBar:lDisenio               := .f.
   ::oOfficeBar:bRClicked              := {|| ::EditButtonBar() }

   ::oOfficeBar:SetStyle( 1 )

   ::oRebar:oTop                       := ::oOfficeBar

   /*
   Creamos la carpeta de empresa-----------------------------------------------
   */

   if ::lCreateEmpresaOfficeBar
      ::oOfficeBar:SetFirstTab( "Empresa", {|| EmpresasController():New():getPanelView():Activate() } )
   end if 

   /*
   Creamos la carpeta de favoritos---------------------------------------------
   */

   if ::lCreateFavoritosOfficeBar
      ::CreateFavoritosOfficeBar()
   end if 

   /*
   Resto de carpetas-----------------------------------------------------------
   */

   for each oAcceso in ::aAccesos
      if len( oAcceso:aAccesos ) > 0
         ::CreateCarpetaOfficeBar( oAcceso )
      end if
   next

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD ReCreateOfficeBar()

   local oCarpeta

   /*
   Creamos la carpeta de favoritos---------------------------------------------
   */

   ::CreateFavoritosOfficeBar()

   /*
   Resto de carpetas-----------------------------------------------------------
   */

   for each oCarpeta in ::oOfficeBar:aCarpetas
      oCarpeta:lHide    := ::lHideCarpeta( oCarpeta )
   next

   ::oOfficeBar:GetCoords()

   ::oOfficeBar:Refresh()

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD CreateCarpetaOfficeBar( oAcceso )

   local oCarpeta

   oCarpeta                   := TCarpeta():New( ::oOfficeBar, oAcceso:cPrompt )
   oCarpeta:lHide             := ::lHideCarpeta( oAcceso )

   ::CreateBotonesOfficeBar( oAcceso:aAccesos, oCarpeta )

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD CreateBotonesOfficeBar( aAcceso, oCarpeta )

   local oBoton
   local oGrupo
   local nGroup
   local oAcceso
   local nBoton               := 0
   local nLittleButtons       := 0
   local aGrupo               := {}

   for each oAcceso in aAcceso

      if !empty( oAcceso:oGroup )

         if aScan( aGrupo, oAcceso:oGroup:cPrompt ) == 0

            nBoton            := 0
            nGroup            := ( oAcceso:oGroup:nBigItems * 60 ) + ( oAcceso:oGroup:nLittleItems * 100 ) + 6
            nLittleButtons    := 0

            oGrupo            := TDotNetGroup():New( oCarpeta, nGroup, oAcceso:oGroup:cPrompt, .f., , oAcceso:oGroup:cBigBitmap )

            aAdd( aGrupo, oAcceso:oGroup:cPrompt )

         end if

         if !empty( oGrupo )

            if !oAcceso:lLittle

               oBoton         := TDotNetButton():New( 60, oGrupo, oAcceso:cBmpBig, oAcceso:cPrompt, ++nBoton, oAcceso:bAction, , , .f., .f., .f. )

            else

               oBoton         := TDotNetButton():New( 100, oGrupo, oAcceso:cBmp, oAcceso:cPrompt, ++nBoton, oAcceso:bAction, , , .f., .f., .f. )

               nLittleButtons++

               if Mod( nLittleButtons, 3 ) != 0
                  --nBoton
               end if

            end if

            oBoton:lVisible   := !oAcceso:lHide

         end if

      end if

   next

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD CreateFavoritosOfficeBar()

   local nScan
   local oItem
   local oAcceso
   local oBoton
   local oGrupo
   local nBoton                     
   local aGrupo                  
   local cUsuarioUuid            

   if ( "TCT" $ appParamsMain() ) .or. ( "TPV" $ appParamsMain() )
      RETURN ( Self )
   end if
   
   nBoton                        := 0
   aGrupo                        := {}
   cUsuarioUuid                  := Auth():Uuid()

   // Creamos los favoritos-----------------------------------------------------

   if empty( ::oFavoritosBar )
      ::oFavoritosBar            := TCarpeta():New( ::oOfficeBar, "FAVORITOS", , , { RGB( 237, 71, 0 ), RGB( 237, 71, 0 ), , Rgb( 237, 71, 0 ), CLR_WHITE } )
   else
      ::oFavoritosBar:aGrupos    := {}
   end if

   for each oAcceso in ::aAccesos

      if len( oAcceso:aAccesos ) > 0

         for each oItem in oAcceso:aAccesos

            if SQLUsuarioFavoritosModel():getVisible( cUsuarioUuid, oItem:cId, oItem:lShow )

               if !empty( oItem:oGroup )

                  nScan                := aScan( aGrupo, oItem:oGroup:cPrompt )
                  if nScan == 0
                     aAdd( aGrupo, oItem:oGroup:cPrompt )
                     oGrupo            := TDotNetGroup():New( ::oFavoritosBar, 6, oItem:oGroup:cPrompt, .f., , oItem:oGroup:cBigBitmap )
                     nBoton            := 0
                  end if

                  if !empty( oGrupo )

                     oBoton            := TDotNetButton():New( 60, oGrupo, oItem:cBmpBig, oItem:cPrompt, ++nBoton, oItem:bAction, , , .f., .f., .f. )

                     oGrupo:nWidth     += 60
                     oGrupo:aSize[ 1 ] := oGrupo:nWidth

                     ::oFavoritosBar:CalcSizes()
                     ::oFavoritosBar:oParent:Refresh()

                  end if

               end if

            end if

         next

      end if

   next

   oGrupo   := TDotNetGroup():New( ::oFavoritosBar, 66, "Salir", .f., , "gc_door_open2_32" )
   
   oBoton   := TDotNetButton():New( 60, oGrupo, "gc_door_open2_32", "Salir", 1, {|| if ( !empty( oWnd() ), oWnd():End(), ) }, , , .f., .f., .f. )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD EnableComboFilter( aItems )

   local cItem

   if empty( ::oComboFilter )
      RETURN ( nil ) 
   end if 

   ::cComboFilter       := __txtFilters__

   ::aComboFilter       := { __txtFilters__ }

   // Cargamos los filtros-----------------------------------------------------

   if !empty( aItems )
      aeval( aItems, {|cItem| aadd( ::aComboFilter, cItem ) } )
   end if 

   ::setComboFilterItems( ::aComboFilter )
   
   ::setComboFilterItem( ::cComboFilter )

   ::oComboFilter:Show()

   ::oComboFilter:Enable()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oRebar )
      ::oRebar:End()
   end if 

   if !empty( ::oGet )
      ::oGet:End()
   end if 

   if !empty( ::oBmpLogo )
      ::oBmpLogo:End()
   end if 

   if !empty( ::oButtonAddFilter )
      ::oButtonAddFilter:End()
   end if 

   if !empty( ::oButtonEditFilter )
      ::oButtonEditFilter:End()
   end if 
   
   if !empty( ::oButtonDeleteFilter )
      ::oButtonDeleteFilter:End()
   end if 

   if !empty( ::oComboFilter )
      ::oComboFilter:End()
   end if 

   ::oRebar                := nil
   ::oGet                  := nil
   ::oBmpLogo              := nil
   ::oButtonAddFilter      := nil
   ::oButtonCleanFilter    := nil 
   ::oButtonEditFilter     := nil 
   ::oButtonDeleteFilter   := nil 
   ::oComboFilter          := nil

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setYearComboBox( nYear )

   DEFAULT nYear  := year( date() )

   if empty( ::oYearComboBox )
      RETURN ( Self )
   end if 

   ::oYearComboBox:set( str( nYear ) )

   if empty( ::oYearComboBox:bChange )
      RETURN ( Self )
   end if 

   eval( ::oYearComboBox:bChange )

RETURN ( nil )

//---------------------------------------------------------------------------//

Static Function lEndApp()

   local oBlock
   local oError

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if ( !empty( oWnd() ), oWnd():End(), )

   RECOVER

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( nil )

//---------------------------------------------------------------------------//

#pragma BEGINDUMP

#include "Windows.h"
#include "hbapi.h"

HINSTANCE GetResources( void );

//----------------------------------------------------------------------------//

HB_FUNC( GETDEFAULTFONTNAME )
{
LOGFONT lf;
GetObject( ( HFONT ) GetStockObject( DEFAULT_GUI_FONT ) , sizeof( LOGFONT ), &lf );
hb_retc( lf.lfFaceName );
}

//----------------------------------------------------------------------------//

HB_FUNC( GETDEFAULTFONTHEIGHT )
{
LOGFONT lf;
GetObject( ( HFONT ) GetStockObject( DEFAULT_GUI_FONT ) , sizeof( LOGFONT ), &lf );
hb_retni( lf.lfHeight );
}

HB_FUNC( GETRCDATA )   // ( cnResName, cType ) --> cResourceBytes
{
   HMODULE hExe;
   HRSRC hRes;
   HGLOBAL hglb;
   int iResName = hb_parni( 1 );

   hExe = LoadLibrary(hb_parc(2));
   if (hExe == NULL)
   {
       hb_retc("0");
       return;
   }

   hRes = FindResource(hExe, MAKEINTRESOURCE(iResName), MAKEINTRESOURCE(10) );



   if( hRes )
   {
      hglb = LoadResource( ( HINSTANCE ) GetResources(), hRes );

      if( hglb ) // && ! ( GlobalFlags( hglb ) && GMEM_DISCARDED ) )
      {

         hb_retclen( ( LPSTR ) LockResource( hglb ), SizeofResource( GetResources(), hRes ) );
         //UnlockResource( hglb );

      }
      else
         hb_retc( "" );
   }
   else
      hb_retc( "" );
}


#pragma ENDDUMP

//----------------------------------------------------------------------------//
