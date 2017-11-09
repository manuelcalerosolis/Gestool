#include "FiveWin.Ch"
#include "Factu.Ch"

//------------------------------------------------------------------------//

CLASS SQLBrowseView

   DATA oBrowse

   DATA oSender

   DATA oController

   DATA oModel

   DATA lFooter                              INIT .f.

   METHOD New( oSender )

   METHOD Create()

   METHOD End()

   METHOD Activate()                         VIRTUAL

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
   METHOD getController()                    INLINE ( iif( empty( ::oController ), ::oSender:getController(), ::oController ) )
   
   METHOD getName()                          INLINE ( ::getController():getName() )

   METHOD setModel( oModel )                 INLINE ( ::oModel := oModel )
   METHOD getModel()                         INLINE ( iif( empty( ::oModel ), ::getController():getModel(), ::oModel ) )

   METHOD getModelColumnsForBrowse()         INLINE ( ::getModel():getColumnsForBrowse() )
   METHOD getModelHeadersForBrowse()         INLINE ( ::getModel():getHeadersForBrowse() )

   METHOD getComboBoxOrder()                 INLINE ( if( !empty( ::oSender ), ::oSender:getComboBoxOrder(), ) )
   METHOD getMenuTreeView()                  INLINE ( if( !empty( ::oSender ), ::oSender:getMenuTreeView(), ) )

   // Columns------------------------------------------------------------------

   METHOD generateColumns()

   METHOD addColumn( cColumn, hColumn )

   // Events---------------------------------------------------------------------

   METHOD onKeyChar( nKey )
   METHOD onClickHeader( oColumn )          

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oSender )

   ::oSender         := oSender

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

   ::oBrowse:lFooter          := ::lFooter

   // Propiedades del control--------------------------------------------------

   ::oBrowse:nMarqueeStyle    := MARQSTYLE_HIGHLROWMS

   ::oBrowse:bClrStd          := {|| { CLR_BLACK, CLR_WHITE } }
   ::oBrowse:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrowse:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrowse:bRClicked        := {| nRow, nCol, nFlags | ::RButtonDown( nRow, nCol, nFlags ) }

   ::oBrowse:setRowSet( ::getModel() )

   ::oBrowse:setName( ::getName() )

   ::oBrowse:bKeyChar         := {|nKey| ::getController():onKeyChar( nKey ) }

   ::oBrowse:bLDblClick       := {|| ::getController():Edit(), ::Refresh() }

RETURN ( ::oBrowse )

//---------------------------------------------------------------------------//

METHOD GenerateColumns()

   local hColumnstoBrowse     := ::getModelColumnsForBrowse()

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

      if hhaskey( hColumn, "hide" ) 
         :lHide            := hColumn[ "hide" ]
      end if 

      if hhaskey( hColumn, "method" ) 
         :bEditValue       := ::getModel():getMethod( hColumn[ "method" ] )
      else 
         :bEditValue       := ::getModel():getEditValue( cColumn ) 
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

//---------------------------------------------------------------------------//

METHOD onClickHeader( oColumn ) 

   local oCombobox

   oComboBox      := ::getComboBoxOrder()

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
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

CLASS SQLBrowseViewDialog FROM SQLBrowseView

   METHOD Activate()

   METHOD onClickHeader( oColumn ) 

ENDCLASS

//----------------------------------------------------------------------------//

METHOD Activate( id, oWindow ) CLASS SQLBrowseViewDialog

   ::Create( oWindow )

   ::GenerateColumns()

   ::CreateFromResource( id )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD onClickHeader( oColumn ) 

   ::getController():changeModelOrderAndOrientation( oColumn:cSortOrder, oColumn:cOrder )

   ::getBrowse():selectColumnOrder( oColumn )

   ::getBrowse():refreshCurrent()
   
RETURN ( Self )

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

CLASS SQLBrowseViewMDI FROM SQLBrowseView

   METHOD Activate()

   METHOD setSize( nTop, nLeft, nRight, nBottom )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD Activate( nTop, nLeft, nRight, nBottom ) CLASS SQLBrowseViewMDI

   ::Create()

   ::setSize( nTop, nLeft, nRight, nBottom )

   ::GenerateColumns()

   ::CreateFromCode()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD setSize( nTop, nLeft, nRight, nBottom ) CLASS SQLBrowseViewMDI

   ::oBrowse:nStyle     := nOr( WS_CHILD, WS_VISIBLE, WS_TABSTOP )

   ::oBrowse:nTop       := nTop 
   ::oBrowse:nLeft      := nLeft 
   ::oBrowse:nRight     := nRight 
   ::oBrowse:nBottom    := nBottom 

RETURN ( self )

//---------------------------------------------------------------------------//
