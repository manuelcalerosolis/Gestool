#include "FiveWin.Ch"

#define dfnTreeViewWidth      250
#define dfnSplitterWidth      0
#define dfnSplitterHeight     44

//------------------------------------------------------------------------// 
// Clases/métodos del programa
//------------------------------------------------------------------------//

CLASS TShellSQL FROM TShell

   DATA  oModel

   METHOD setXAlias( oModel )      INLINE ( if( hb_isobject( oModel ), ::oModel := oModel, ) )

   METHOD createXBrowse()
   METHOD createXFromCode()

   METHOD selectColumnOrder()

   METHOD clickOnHeader( oCol )

   METHOD setFilter()               INLINE ( Self )

   METHOD ChgCombo()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD CreateXBrowse() 

   local oError
   local oBlock
   local lCreateXBrowse       := .t.

   oBlock                     := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::oBrw                  := TXBrowse():New( Self )
      ::oBrw:nStyle           := nOr( WS_CHILD, WS_VISIBLE, WS_TABSTOP )
      ::oBrw:l2007            := .f.

      ::oBrw:lRecordSelector  := .f.
      ::oBrw:lAutoSort        := .t.
      ::oBrw:lSortDescend     := .f.   

      // Propiedades del control ----------------------------------------------

      ::oBrw:nMarqueeStyle    := MARQSTYLE_HIGHLROWMS

      ::oBrw:bClrStd          := {|| { CLR_BLACK, CLR_WHITE } }
      ::oBrw:bClrSel          := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrw:bClrSelFocus     := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrw:bRClicked        := {| nRow, nCol, nFlags | ::RButtonDown( nRow, nCol, nFlags ) }

      ::oBrw:lAutoSort        := .f.
      ::oBrw:nDataType        := DATATYPE_USER
      ::oBrw:bGoTop           := {|| ::oModel:oRowSet:GoTop() }
      ::oBrw:bGoBottom        := {|| ::oModel:oRowSet:GoBottom() }
      ::oBrw:bBof             := {|| ::oModel:oRowSet:Bof() }
      ::oBrw:bEof             := {|| ::oModel:oRowSet:Eof() }
      ::oBrw:bBookMark        := {| n | iif( n == nil, ::oModel:oRowSet:RecNo(), ::oModel:oRowSet:GoTo( n ) ) }
      ::oBrw:bSkip            := {| n | iif( n == nil, n := 1, ), ::oModel:oRowSet:Skipper( n ) }
      ::oBrw:bKeyNo           := {| n | ::oModel:oRowSet:RecNo() }
      ::oBrw:bKeyCount        := {|| ::oModel:oRowSet:RecCount() }

      if ::oBrw:oVScroll() != nil
         ::oBrw:oVscroll():SetRange( 1, ::oModel:oRowSet:RecCount() )
      endif

      ::oBrw:lFastEdit        := .t.
      
      ::oBrw:bKeyChar         := {|nKey| ::CtrlKey( nKey ) }

      // Dimensiones del control -------------------------------------------------

      if !::lBigStyle
         ::oBrw:nTop          := dfnSplitterHeight + dfnSplitterWidth
      else
         ::oBrw:nTop          := 0
         ::oBrw:nRowHeight    := 36
      endif

      ::oBrw:nLeft            := dfnTreeViewWidth + dfnSplitterWidth // 1
      ::oBrw:nRight           := ::nRight - ::nLeft
      ::oBrw:nBottom          := ::nBottom - ::nTop

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible crear rejilla de datos" )

      lCreateXBrowse          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lCreateXBrowse )

//---------------------------------------------------------------------------//

METHOD CreateXFromCode()

   local oCol

   ::aPrompt                  := {}

   // Insertamos el action por columnas----------------------------------------

   for each oCol in ::oBrw:aCols
      
      if empty( oCol:bLDClickData ) .and. !( oCol:lEditable )
         oCol:bLDClickData    := {|| ::RecEdit() }
      end if 

      aadd( ::aPrompt, oCol:cHeader )

   next

   // Creamos el objeto -------------------------------------------------------

   ::oBrw:CreateFromCode()

   ::oBrw:SetFocus()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD selectColumnOrder( oCol )

   if empty( oCol )
      Return ( nil )
   end if

   aeval( ::oBrw:aCols, {|o| if( o:cSortOrder != oCol:cSortOrder, o:cOrder := "", ) } )    

   if oCol:cOrder == 'D' .or. empty( oCol:cOrder )
      oCol:cOrder    := 'A'
   else
      oCol:cOrder    := 'D'
   end if 

   ::oWndBar:setComboBoxSet( oCol:cHeader )   

RETURN NIL

//----------------------------------------------------------------------------//

METHOD ClickOnHeader( oCol )

   ::selectColumnOrder( oCol )

   ::oModel:refreshSelectOrderBy( oCol:cSortOrder, oCol:cOrder )

   ::oBrw:Refresh()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ChgCombo()

   local nPosition   := ascan( ::oBrw:aCols, {|o| o:cHeader == ::oWndBar:GetComboBox() } ) 

   if nPosition != 0

      ::selectColumnOrder( ::oBrw:aCols[ nPosition ] )

      ::oModel:refreshSelectOrderBy( ::oBrw:aCols[ nPosition ]:cSortOrder, ::oBrw:aCols[ nPosition ]:cOrder )

   end if

RETURN ( Self )
