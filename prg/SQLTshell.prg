#include "FiveWin.Ch"

#define dfnTreeViewWidth      250
#define dfnSplitterWidth      0
#define dfnSplitterHeight     44

//------------------------------------------------------------------------// 
// Clases/métodos del programa
//------------------------------------------------------------------------//

CLASS SQLTShell FROM TShell

   DATA  bEnd

   DATA  oModel

   METHOD setXAlias( oModel )             INLINE ( if( hb_isobject( oModel ), ::oModel := oModel, ) )

   METHOD createXBrowse()
   METHOD createXFromCode()

   METHOD selectColumnOrder()

   METHOD setFilter()                     INLINE ( Self )

   METHOD setComboBoxChange( bChange )    INLINE ( ::oWndBar:SetComboBoxChange( bChange ) )

   METHOD fastSeek()

   METHOD setDClickData( bAction )       

   METHOD end()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD CreateXBrowse() 

   local oError
   local oBlock
   local lCreateXBrowse       := .t.

   oBlock                     := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::oBrw                  := SQLXBrowse():New( Self )
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

      ::oBrw:setModel( ::oModel )

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

   ::oBrw:CreateFromCode()

   ::oBrw:SetFocus()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD selectColumnOrder( oCol )

   if empty(oCol)
      Return ( Self )
   end if 

   ::oBrw:selectColumnOrder( oCol )

   ::oWndBar:setComboBoxSet( oCol:cHeader )   

Return ( Self )

//---------------------------------------------------------------------------//

METHOD FastSeek()

   local nRec
   local nOrd
   local oCol
   local oGet
   local lFind
   local xValueToSearch

   if empty( ::oWndBar ) .or. empty( ::oWndBar:oGet )
      Return .f.
   end if

   oGet              := ::oWndBar:oGet

   // Estudiamos la cadena de busqueda-------------------------------------------

   xValueToSearch    := oGet:oGet:Buffer()
   xValueToSearch    := alltrim( upper(cvaltochar( xValueToSearch ) ) )
   xValueToSearch    := strtran( xValueToSearch, chr( 8 ), "" )

   // Guradamos valores iniciales-------------------------------------------------

   lFind             := ::oModel:find( xValueToSearch )

   // color para el get informar al cliente de busqueda erronea----------------

   if lFind .or. empty( xValueToSearch ) 
      oGet:SetColor( Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) )
   else
      oGet:SetColor( Rgb( 255, 255, 255 ), Rgb( 255, 102, 102 ) )
   end if

   ::oBrw:refreshCurrent()

Return ( lFind )

//--------------------------------------------------------------------------//

METHOD setDClickData( bAction )

   aeval( ::oBrw:aCols, {|oCol| if( empty( oCol:bLDClickData ) .and. !( oCol:lEditable ), oCol:bLDClickData := bAction, ) } )

Return ( Self )      

//--------------------------------------------------------------------------//

METHOD End( lForceExit )

   DEFAULT lForceExit         := .f.

   if ::lOnProcess .and. !lForceExit
      Return ( .f. )
   end if

   if !empty( ::bValid ) .and. !( eval( ::bValid ) )
      Return ( .f. )
   end if 

   ::oWndClient:ChildClose( Self )

   CursorWait()

   // Barra de busqueda--------------------------------------------------------

   if !empty( ::oWndBar )
      ::oWndBar:DisableGet()
      ::oWndBar:DisableComboBox()
      ::oWndBar:DisableComboFilter()
      ::oWndBar:HideYearCombobox()

      ::HideDeleteButtonFilter()
      ::HideAddButtonFilter()
      ::HideEditButtonFilter()
   end if

   // Cerramos el browse ------------------------------------------------------

   if !empty( ::oBrw )
      ::oBrw:End()
      ::oBrw   := nil
   end if

   if !empty( ::bEnd )
      eval( ::bEnd )
   end if 

   sysRefresh()

   CursorWE()

Return ( .t. )

//----------------------------------------------------------------------------//

