#include "FiveWin.Ch"
#include "Factu.Ch"

//------------------------------------------------------------------------//

CLASS SQLBrowseView

   DATA oBrowse

   DATA oController

   DATA oModel

   DATA lFooter                              INIT .f.

   METHOD New( oController )

   METHOD Create()

   METHOD End()

   METHOD ActivateDialog()
   METHOD ActivateMDI()
   
   METHOD setSize( nTop, nLeft, nRight, nBottom ) 

   METHOD setFooter( lFooter )               INLINE ( ::lFooter := lFooter )

   // Facades------------------------------------------------------------------

   METHOD getBrowse()                        INLINE ( ::oBrowse )
   METHOD getBrowseSelected()                INLINE ( ::oBrowse:aSelected )

   METHOD getColumnByHeader( cHeader )       INLINE ( ::oBrowse:getColumnByHeader( cHeader ) )
   METHOD getColumnOrder( cSortOrder )       INLINE ( ::oBrowse:getColumnOrder( cSortOrder ) )
   METHOD getColumnOrderByHeader( cHeader )  INLINE ( ::oBrowse:getColumnOrderByHeader( cHeader ) )

   METHOD selectColumnOrder( oCol )          INLINE ( ::oBrowse:selectColumnOrder( oCol ) )
   METHOD refreshCurrent()                   INLINE ( ::oBrowse:refreshCurrent() )

   METHOD createFromCode()                   INLINE ( ::oBrowse:CreateFromCode() )
   METHOD createFromResource( id )           INLINE ( ::oBrowse:CreateFromResource( id ) )

   METHOD setLDblClick( bLDblClick )         INLINE ( ::oBrowse:bLDblClick := bLDblClick )

   METHOD Refresh()                          INLINE ( ::oBrowse:MakeTotals(), ::oBrowse:Refresh() )

   METHOD setView()                          INLINE ( ::oBrowse:setView() )
   METHOD saveView()                         INLINE ( ::oBrowse:saveView() )

   METHOD setController( oController )       INLINE ( ::oController := oController )
   METHOD getController()                    INLINE ( iif( empty( ::oController ), ::oController:getController(), ::oController ) )
   
   METHOD getName()                          INLINE ( ::getController():getName() )

   METHOD getComboBoxOrder()                 INLINE ( if( !empty( ::oController ), ::oController:getComboBoxOrder(), ) )
   METHOD getMenuTreeView()                  INLINE ( if( !empty( ::oController ), ::oController:getMenuTreeView(), ) )

   // Models-------------------------------------------------------------------

   METHOD getModel()                         INLINE ( ::getController():getModel() )
   METHOD getModelColumnsForBrowse()         INLINE ( ::getModel():getColumnsForBrowse() )
   METHOD getModelHeadersForBrowse()         INLINE ( ::getModel():getHeadersForBrowse() )

   // RowSet-------------------------------------------------------------------

   METHOD getRowSet()                        INLINE ( ::getController():getRowSet() )

   // Columns------------------------------------------------------------------

   METHOD addColumns()                       VIRTUAL

   // METHOD addColumn( cColumn, hColumn )

   // Events---------------------------------------------------------------------

   METHOD onKeyChar( nKey )
   METHOD onClickHeader( oColumn )          

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oController )

   ::oController         := oController

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oBrowse )
      ::oBrowse:End()
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Create( oWindow ) 

   default oWindow            := ::oController:getWindow()

   ::oBrowse                  := SQLXBrowse():New( oWindow )
   ::oBrowse:l2007            := .f.

   ::oBrowse:lRecordSelector  := .f.
   ::oBrowse:lAutoSort        := .t.
   ::oBrowse:lSortDescend     := .f.  

   ::oBrowse:lFooter          := ::lFooter

   // Propiedades del control--------------------------------------------------

   ::oBrowse:nMarqueeStyle    := MARQSTYLE_HIGHLROWMS

   ::oBrowse:bClrStd          := {|| { CLR_BLACK, CLR_WHITE } }
   ::oBrowse:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrowse:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrowse:bRClicked        := {| nRow, nCol, nFlags | ::RButtonDown( nRow, nCol, nFlags ) }

   ::oBrowse:setRowSet( ::getRowSet() )

   ::oBrowse:setName( ::getName() )

   ::oBrowse:bKeyChar         := {|nKey| ::getController():onKeyChar( nKey ) }

   ::oBrowse:bLDblClick       := {|| ::getController():Edit(), ::Refresh() }

RETURN ( ::oBrowse )

//---------------------------------------------------------------------------//

/*
METHOD addColumns()

   if empty( ::oController )
      ::oController:addColumns( ::oBrowse )
   end if 

RETURN ( Self )

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

      if hhaskey( hColumn, "hide" ) 
         :lHide            := hColumn[ "hide" ]
      end if 

      if hhaskey( hColumn, "method" ) 
         :bEditValue       := ::getModel():getMethod( hColumn[ "method" ] )
      else 
         :bEditValue       := {|| ::getRowSet():fieldGet( ::getModel():getEditValue( cColumn ) ) }
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oColumn | ::onClickHeader( oColumn ) }
      end if 

      if hhaskey( hColumn, "footer" ) 
         :nFootStyle       := :nDataStrAlign               
         :nFooterType      := AGGR_SUM
         :cFooterPicture   := :cEditPicture
         :cDataType        := "N"
      end if 

      if hhaskey( hColumn, "footAlign" ) 
         :nFootStrAlign    := hColumn[ "footAlign" ]
      end if 

   end with

RETURN ( self )
*/
//---------------------------------------------------------------------------//

METHOD onClickHeader( oColumn ) 

   local oCombobox

   oComboBox      := ::getComboBoxOrder()

   if empty( oComboBox )

      ::getController():changeModelOrderAndOrientation( oColumn:cSortOrder, oColumn:cOrder )

      ::getBrowse():selectColumnOrder( oColumn )

      ::getBrowse():refreshCurrent()

   else

      if ascan( oCombobox:aItems, oColumn:cHeader ) != 0
         oComboBox:Set( oColumn:cHeader )
      end if

   end if 
   
RETURN ( ::oController:onChangeCombo() )

//---------------------------------------------------------------------------//

METHOD onKeyChar( nKey )

RETURN ( heval( ::oController:oMenuTreeView:hFastKey, {|k,v| msgalert( nKey, "nKey" ), if( k == nKey, eval( v ), ) } ) ) 
   
//----------------------------------------------------------------------------//

METHOD ActivateDialog( id, oDialog )

   ::Create( oDialog )

   ::addColumns()

   ::CreateFromResource( id )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD ActivateMDI( oWindow, nTop, nLeft, nRight, nBottom )

   ::Create( oWindow )

   ::setSize( nTop, nLeft, nRight, nBottom )

   ::addColumns()

   ::CreateFromCode()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD setSize( nTop, nLeft, nRight, nBottom ) 

   ::oBrowse:nStyle     := nOr( WS_CHILD, WS_VISIBLE, WS_TABSTOP )

   ::oBrowse:nTop       := nTop 
   ::oBrowse:nLeft      := nLeft 
   ::oBrowse:nRight     := nRight 
   ::oBrowse:nBottom    := nBottom 

RETURN ( self )

//---------------------------------------------------------------------------//

