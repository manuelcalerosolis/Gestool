#include "FiveWin.Ch"
#include "Factu.Ch"

//------------------------------------------------------------------------//

CLASS SQLBrowseView

   DATA oBrowse

   DATA oSender

   DATA oController

   DATA oModel

   METHOD New( oSender )

   METHOD Create()

   METHOD End()

   METHOD ActivateMDI()
   METHOD ActivateDialog()

   // Facades------------------------------------------------------------------

   METHOD getBrowse()                     INLINE ( ::oBrowse )

   METHOD setController( oController )    INLINE ( ::oController := oController )
   METHOD getController()                 INLINE ( iif( empty( ::oController ), ::oSender:getController(), ::oController ) )

   METHOD setModel( oModel )              INLINE ( ::oModel := oModel )
   METHOD getModel()                      INLINE ( iif( empty( ::oModel ), ::getController():getModel(), ::oModel ) )

   METHOD getModelColumnsForBrowse()      INLINE ( ::getModel():getColumnsForBrowse() )
   METHOD getModelHeadersForBrowse()      INLINE ( ::getModel():getHeadersForBrowse() )

   METHOD getComboBoxOrder()              INLINE ( ::oSender:getComboBoxOrder() )
   METHOD getMenuTreeView()               INLINE ( ::oSender:getMenuTreeView() )

   // Columns------------------------------------------------------------------

   METHOD setSize( nTop, nLeft, nRight, nBottom )

   METHOD GenerateColumns()

   METHOD AddColumn( cColumn, hColumn )

   // Browse methods-----------------------------------------------------------

   METHOD CreateFromCode()                INLINE ( ::oBrowse:CreateFromCode() )
   METHOD CreateFromResource( id )        INLINE ( ::oBrowse:CreateFromResource( id ) )

   METHOD setLDblClick( bLDblClick )      INLINE ( ::oBrowse:bLDblClick := bLDblClick )

   METHOD Refresh()                       INLINE ( ::oBrowse:Refresh() )

   // Events---------------------------------------------------------------------

   METHOD onKeyChar( nKey )
   METHOD onClickHeader( oColumn )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oSender )

   ::oSender         := oSender

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD ActivateMDI( nTop, nLeft, nRight, nBottom )

   ::Create()

   ::setSize( nTop, nLeft, nRight, nBottom )

   ::GenerateColumns()

   ::CreateFromCode()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD ActivateDialog( id, oWindow )

   ::Create( oWindow )

   ::GenerateColumns()

   ::CreateFromResource( id )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oBrowse )
      ::oBrowse:End()
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Create( oWindow ) 

   default oWindow            := ::oSender:getWindow()

   ::oBrowse                  := SQLXBrowse():New( oWindow )
   ::oBrowse:l2007            := .f.

   ::oBrowse:lRecordSelector  := .f.
   ::oBrowse:lAutoSort        := .t.
   ::oBrowse:lSortDescend     := .f.   

   // Propiedades del control--------------------------------------------------

   ::oBrowse:nMarqueeStyle    := MARQSTYLE_HIGHLROWMS

   ::oBrowse:bClrStd          := {|| { CLR_BLACK, CLR_WHITE } }
   ::oBrowse:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrowse:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrowse:bRClicked        := {| nRow, nCol, nFlags | ::RButtonDown( nRow, nCol, nFlags ) }

   ::oBrowse:setModel( ::getModel() )

   ::oBrowse:bKeyChar         := {|nKey| ::getController():onKeyChar( nKey ) }

   ::oBrowse:bLDblClick       := {|| ::getController():Edit(), ::Refresh() }

RETURN ( ::oBrowse )

//---------------------------------------------------------------------------//

METHOD setSize( nTop, nLeft, nRight, nBottom )

   ::oBrowse:nStyle           := nOr( WS_CHILD, WS_VISIBLE, WS_TABSTOP )

   ::oBrowse:nTop             := nTop 
   ::oBrowse:nLeft            := nLeft 
   ::oBrowse:nRight           := nRight 
   ::oBrowse:nBottom          := nBottom 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD GenerateColumns()

   local hColumnstoBrowse  := ::getModelColumnsForBrowse()

   if empty( hColumnstoBrowse )
      RETURN ( self )
   end if 

   hEval( hColumnstoBrowse, { | cColumn, hColumn | ::addColumn( cColumn, hColumn ) } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD addColumn( cColumn, hColumn )

   with object ( ::oBrowse:AddCol() )

      :cSortOrder          := cColumn
      :cHeader             := hColumn[ "header" ]
      :nWidth              := hColumn[ "width" ]

      if hhaskey( hColumn, "picture" ) 
         :cEditPicture     := hColumn[ "picture" ]
      end if 

      if hhaskey( hColumn, "headAlign" ) 
         :nHeadStrAlign    := hColumn[ "headAlign" ]
      end if 

      if hhaskey( hColumn, "dataAlign" ) 
         :nDataStrAlign    := hColumn[ "dataAlign" ]
      end if 

      if hhaskey( hColumn, "footAlign" ) 
         :nFootStrAlign    := hColumn[ "footAlign" ]
      end if 

      :bEditValue          := ::getModel():getEditValue( cColumn ) 

      :bLClickHeader       := {| nMRow, nMCol, nFlags, oColumn | ::onClickHeader( oColumn ) }

   end with

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD onClickHeader( oColumn )

   local oCombobox   := ::getComboBoxOrder()

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
   
RETURN ( ::oSender:onChangeCombo() )

//---------------------------------------------------------------------------//

METHOD onKeyChar( nKey )

RETURN ( heval( ::oSender:oMenuTreeView:hFastKey, {|k,v| msgalert( nKey, "nKey" ), if( k == nKey, eval( v ), ) } ) ) 
   
//----------------------------------------------------------------------------//

