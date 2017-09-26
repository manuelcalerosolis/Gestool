*********************************************************************
* File Name:	DBCombo.prg
* Author:	    Elliott Whitticar, 71221.1413@Compuserve.com
* Created:	    4/25/96
* Description:  Data-aware ComboBox class
//----------------------------------------------------------------------------//
//
// The TDBCombo class provides a combo-box which displays one field from
// a table (such as DeptName) and returns another (such as DeptID).
//
// It overrides the TComboBox class from FiveWin 1.9.1.
//
// If redefining a ComboBox, make sure the ComboBox does not sort aList,
// or DBCombo will not return the matching element of aItems.
//
// As of 4/25/96, the DBCombo class has been tested displaying one column
// from an open work area, and returning another.  I have not tried supplying
// two arrays.  It could also use the following enhancements:
//
// 1) Display nothing if the bound Set/Get variable is NIL (or an illegal value).
// 2) Add support for an index and/or filter for the table of displayed values.
// 3) Add support for using the same field in the list box as is returned
//    (workaround: specify the same field for cFldList and cFldItem).
// 4) It hasn't been tested passing the aItems and aList array without
//    specifying any database fields.
// 5) Fix the ::Initiate() method to invoke the TControl:Initiate() method
//    from the grandparent TControl class (I just cut/pasted code).
//----------------------------------------------------------------------------//

#include "FiveWin.Ch"
#include "objects.ch"
#include "font.ch"
#include "Constant.ch"

#define CB_ADDSTRING     ( WM_USER +  3 )
#define CB_DELETESTRING  ( WM_USER +  4 )
#define CB_GETCURSEL     ( WM_USER +  7 )
#define CB_INSERTSTRING  ( WM_USER + 10 )
#define CB_RESETCONTENT  ( WM_USER + 11 )
#define CB_SETCURSEL     ( WM_USER + 14 )
#define CB_ERR                       -1

#define COLOR_WINDOW       5
#define COLOR_WINDOWTEXT   8

#define MB_ICONEXCLAMATION  48   // 0x0030

#ifdef __XPP__
#define Super ::TComboBox
#endif

CLASS TDBCombo FROM TComboBox

	DATA	cAlias			// Workarea alias for fields to display
	DATA	cFldList		// Field to display in the ComboBox
	DATA	cFldItem		// Field to return in the bound variable
	DATA	aList			// Array of display items corresponding to aItems.
							// May be specified in the constructor or read from
							// cAlias->cFldList
	DATA  cFldBitmap	// Calero

	METHOD New( nRow, nCol, bSetGet, aItems, nWidth, nHeight, oWnd, nHelpId, ;
	           bChange, bValid, nClrText, nClrBack, lPixel, oFont, ;
				  cMsg, lUpdate, bWhen, lDesign, acBitmaps, bDrawItem, ;
				  cAlias, cFldItem, cFldList, aList, cFldBitmap ) CONSTRUCTOR

	METHOD ReDefine( nId, bSetGet, aItems, oWnd, nHelpId, bValid, ;
	           bChange, nClrText, nClrBack, cMsg, lUpdate, ;
				  bWhen, acBitmaps, bDrawItem, ;
				  cAlias, cFldItem, cFldList, aList, cFldBitmap ) CONSTRUCTOR

	METHOD Add( cItem, nAt, cList )
	METHOD Default()
	METHOD Del( nAt )
	METHOD Initiate( hDlg )
	METHOD Insert( cItem, nAt, cList )
	METHOD LostFocus()
	METHOD Modify( cItem, nAt, cList )
	METHOD Refill()			// Refill aItems and aList from cFldItem and cFldList
	METHOD SetItems( aItems, aList )

	// What does this code from TComboBox do?  Should it erase aItem and aList?
	METHOD Reset() INLINE Eval( ::bSetGet,;
                         If( ValType( Eval( ::bSetGet ) ) == "N", 0, "" ) ),;
                         ::nAt := 0, ::SendMsg( CB_RESETCONTENT ),;
                         ::Change()

   METHOD FillMeasure( nPInfo ) INLINE  LbxMeasure( nPInfo, ::nBmpHeight )

   METHOD DrawItem( nIdCtl, nPStruct )

	METHOD ListGet()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, bSetGet, aItems, nWidth, nHeight, oWnd, nHelpId, ;
            bChange, bValid, nClrFore, nClrBack, lPixel, oFont, ;
				cMsg, lUpdate, bWhen, lDesign, acBitmaps, bDrawItem, ;
				cAlias, cFldItem, cFldList, aList, cFldBitmap ) CLASS TDBCombo

	DEFAULT cAlias := "", ;
			cFldList := "", ;
			cFldItem := "", ;
			aList := {}

	::aList    		:= aList
	::cAlias   		:= cAlias
	::cFldList 		:= cFldList
	::cFldItem 		:= cFldItem
	::cFldBitmap	:= cFldBitmap
	::cFldBitmap	:= cFldBitmap

	::refill()

	msginfo( len( ::aBitmaps ), ::aBitmaps[1] )

	Super:New( nRow, nCol, bSetGet, ::aItems, nWidth, nHeight, oWnd, nHelpId, ;
		bChange, bValid, nClrFore, nClrBack, lPixel, oFont, ;
		cMsg, lUpdate, bWhen, lDesign, ::aBitmaps, bDrawItem )

	msginfo( len( ::aBitmaps ), ::aBitmaps[1] )


return nil

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, bSetGet, aItems, oWnd, nHelpId, bValid, ;
                 bChange, nClrFore, nClrBack, cMsg, lUpdate, ;
					  bWhen, acBitmaps, bDrawItem, ;
					  cAlias, cFldItem, cFldList, aList, cFldBitmap ) CLASS TDBCombo

	DEFAULT cAlias := "", ;
			cFldList := "", ;
			cFldItem := "", ;
			aList := {}

	::aList    		:= aList
	::cAlias   		:= cAlias
	::cFldList 		:= cFldList
	::cFldItem 		:= cFldItem
	::cFldBitmap	:= cFldBitmap
	::cFldBitmap	:= cFldBitmap

	::refill()

	msginfo( len( ::aBitmaps ), ::aBitmaps[1] )

	Super:ReDefine( nId, bSetGet, aItems, oWnd, nHelpId, bValid, ;
					bChange, nClrFore, nClrBack, cMsg, lUpdate, ;
					bWhen, ::aBitmaps, bDrawItem )

return nil

//----------------------------------------------------------------------------//

METHOD Add( cItem, nAt, cList ) CLASS TDBCombo
	// Note that compared to the parent class, we've added an arg at the end.

	DEFAULT nAt := 0
	DEFAULT cList := cItem

	if nAt == 0
	  AAdd( ::aItems, cItem )
	  AAdd( ::aList,  cList )
	else
	  ASize( ::aItems, Len( ::aItems ) + 1 )
	  ASize( ::aList, Len( ::aList ) + 1 )
	  AIns( ::aItems, nAt )
	  AIns( ::aList, nAt )
	  ::aItems[ nAt ] = cItem
	  ::aList[ nAt ] = cList
	endif

	::SendMsg( CB_ADDSTRING, nAt, cList )

return nil

//----------------------------------------------------------------------------//

METHOD Default() CLASS TDBCombo

   local cStart := Eval( ::bSetGet )

   if cStart == nil
      Eval( ::bSetGet, If( Len( ::aItems ) > 0, ::aItems[ 1 ], "" ) )
      cStart = If( Len( ::aItems ) > 0, ::aItems[ 1 ], "" )
   endif

   AEval( ::aList, { | cList, nAt | ::SendMsg( CB_ADDSTRING, nAt, cList ) } )

   if ValType( cStart ) != "N"
   		//MsgInfo( "::cAlias = " + ::cAlias )
   		//MsgInfo( "Len(::aItems) = " + STR(Len(::aItems)))
   		//IF Len(::aItems) > 0
   		//	MsgInfo( "ValType(::aItems[1]) = " + ValType(::aItems[1]))
   		//ENDIF
      ::nAt = AScan( ::aItems, { | cItem | Upper( AllTrim( cItem ) ) == ;
                                           Upper( AllTrim( cStart ) ) } )
   else
      ::nAt = cStart
   endif

   ::nAt = If( ::nAt > 0, ::nAt, 1 )
   ::Select( ::nAt )

   if ::oFont != nil
      ::SetFont( ::oFont )
   else
      ::SetFont( ::oWnd:oFont )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Del( nAt ) CLASS TDBCombo

	DEFAULT nAt := 0

	if nAt != 0
		ADel( ::aItems, nAt )
		ADel( ::aList, nAt )
		ASize( ::aItems, Len( ::aItems ) - 1 )
		ASize( ::aList, Len( ::aList ) - 1 )
		::SendMsg( CB_DELETESTRING, nAt - 1 )
	endif

return nil

//----------------------------------------------------------------------------//

METHOD DrawItem( nIdCtl, nPStruct ) CLASS TDBCombo

return LbxDrawItem( nPStruct, ::aBitmaps, ::aList, ::nBmpWidth, ::bDrawItem )

//----------------------------------------------------------------------------//

METHOD Initiate( hDlg ) CLASS TDbCombo
/*
  TControl():Initiate( hDlg )
*/

	/// This code is copied from TControl since I don't know how
	/// to invoke the Init from the grandparent class

	local oRect

	DEFAULT ::lActive := .t., ::lDrag := .f., ::lCaptured := .f.

	if( ( ::hWnd := GetDlgItem( hDlg, ::nId ) ) != 0 )
		oRect     = ::GetRect()
		::nBottom = oRect:nBottom
		::nRight  = oRect:nRight

		If( ::lActive, ::Enable(), ::Disable() )

		::Link()

		if ::oFont != nil
			::SetFont( ::oFont )
		else
			::GetFont()
		endif

	else
		#define NOVALID_CONTROLID   1
		Eval( ErrorBlock(), _FWGenError( NOVALID_CONTROLID, "No: " + ;
		                              Str( ::nId, 6 ) ) )
	endif

	// Now get the data to display and return
	msginfo( "refill()" )
	::Refill()
	::Default()

RETURN NIL

//----------------------------------------------------------------------------//

METHOD Insert( cItem, nAt, cList ) CLASS TDBCombo

	DEFAULT nAt := 0
	DEFAULT cList := cItem

	if nAt != 0
		ASize( ::aItems, Len( ::aItems ) + 1 )
		ASize( ::aList, Len( ::aList ) + 1 )
		AIns( ::aItems, nAt )
		AIns( ::aItems, nAt )
		::aItems[ nAt ] = cItem
		::aList[ nAt ] = cList
		::SendMsg( CB_INSERTSTRING, nAt - 1, cList )
	endif

return nil

//----------------------------------------------------------------------------//

METHOD ListGet() CLASS TDBCombo

   local cRet, nAt := ::SendMsg( CB_GETCURSEL )

   if nAt != CB_ERR
      ::nAt = nAt + 1
      cRet :=  ::aList[ nAt + 1 ]
   else
      cRet := GetWindowText( ::hWnd )
   endif

return cRet

//----------------------------------------------------------------------------//

METHOD LostFocus() CLASS TDBCombo

   local nAt := ::SendMsg( CB_GETCURSEL )

   Super:LostFocus()

   if nAt != CB_ERR
      ::nAt = nAt + 1
      if ValType( Eval( ::bSetGet ) ) == "N"
         Eval( ::bSetGet, nAt + 1 )
      else
         Eval( ::bSetGet, ::aItems[ nAt + 1 ] )
      endif
   else
      Eval( ::bSetGet, GetWindowText( ::hWnd ) )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Modify( cItem, nAt, cList ) CLASS TDBCombo

	DEFAULT nAt := 0
	DEFAULT cList := cItem

	if nAt != 0
		::aItems[ nAt ] = cItem
		::aList[ nAt ] = cList
		::SendMsg( CB_DELETESTRING, nAt - 1 )
		::SendMsg( CB_INSERTSTRING, nAt - 1, cList )
	endif

return nil

//----------------------------------------------------------------------------//

METHOD Refill() CLASS TDBCombo

	// Refill aItems and aList from cAlias->cFldItem and cAlias->cFldList
	/// Note that we have yet to define an index!

	LOCAL nOldRecNo
	LOCAL nOldArea := SELECT()
	LOCAL nItem, nList, nBitmap

	IF ::cAlias == ""
		// There's no workarea defined, so do nothing
		RETURN NIL
	END IF

	IF SELECT( ::cAlias ) == 0
		MsgInfo( "TDBCombo:Refill() - Alias '" + ::cAlias + "' does not exist." )
		RETURN NIL
	ELSE
		DBSELECTAREA(::cAlias)
	END IF

	::aItems 	:= {}
	::aList 		:= {}
	::aBitmaps 	:= {}

	IF ( nItem := FIELDPOS( ::cFldItem ) ) > 0 .AND.;
		( nList := FIELDPOS( ::cFldList ) ) > 0

		nBitmap	:= FIELDPOS( ::cFldBitmap )

		nOldRecNo := RECNO()
		DBGOTOP()

		DO WHILE !EOF()

			IF nBitmap > 0
				AADD( ::aBitmaps, FIELDGET( nBitmap ) )
			END IF

			AADD( ::aItems, FIELDGET( nItem ) )
			AADD( ::aList, FIELDGET( nList ) )

			DBSKIP()

		ENDDO

		DBGOTO( nOldRecNo )

	ENDIF

	SELECT (nOldArea)

	IF nBitmap > 0
		Super:SetBitmaps( ::aBitmaps )
	END IF

RETURN NIL

//----------------------------------------------------------------------------//

METHOD SetItems( aItems, aList ) CLASS TDbCombo

	IF LEN(aItems) != LEN(aList)
		MsgInfo( "Invalid args to TDBCombo:SetItems()" )
	ELSE
		::Reset()
		::aItems := aItems
		::aList := aList
		::Default()
		::Change()
	END IF

RETURN NIL

//----------------------------------------------------------------------------//