#include "FiveWin.Ch"

#define dfnTreeViewWidth      250
#define dfnSplitterWidth      0
#define dfnSplitterHeight     44

//------------------------------------------------------------------------// 
// Clases/métodos del programa
//------------------------------------------------------------------------//

CLASS TShellSQL FROM TShell

   DATA  oRowSet

   METHOD setXAlias( oRowSet )      INLINE ( if( hb_isobject( oRowSet ), ::oRowSet := oRowSet, ) )

   METHOD createXBrowse()
   METHOD createXFromCode()

   METHOD selectColumnOrder()

   METHOD clickOnHeader( oCol )

   METHOD setFilter()               INLINE ( Self )

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
      ::oBrw:bGoTop           := {|| ::oRowSet:GoTop() }
      ::oBrw:bGoBottom        := {|| ::oRowSet:GoBottom() }
      ::oBrw:bBof             := {|| ::oRowSet:Bof() }
      ::oBrw:bEof             := {|| ::oRowSet:Eof() }
      ::oBrw:bBookMark        := {| n | iif( n == nil, ::oRowSet:RecNo(), ::oRowSet:GoTo( n ) ) }
      ::oBrw:bSkip            := {| n | iif( n == nil, n := 1, ), ::oRowSet:Skipper( n ) }
      ::oBrw:bKeyNo           := {| n | ::oRowSet:RecNo() }
      ::oBrw:bKeyCount        := {|| ::oRowSet:RecCount() }

      if ::oBrw:oVScroll() != nil
         ::oBrw:oVscroll():SetRange( 1, ::oRowSet:RecCount() )
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

   // Insertamos el action por columnas----------------------------------------

   for each oCol in ::oBrw:aCols
      if empty( oCol:bLDClickData ) .and. !( oCol:lEditable )
         oCol:bLDClickData    := {|| ::RecEdit() }
      end if 
   next

   // Creamos el objeto -------------------------------------------------------

   ::oBrw:CreateFromCode()

   ::oBrw:SetFocus()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD selectColumnOrder()

RETURN NIL

//----------------------------------------------------------------------------//

METHOD ClickOnHeader( oCol )

   msgAlert( oCol:cSortOrder )

RETURN ( Self )

//---------------------------------------------------------------------------//

