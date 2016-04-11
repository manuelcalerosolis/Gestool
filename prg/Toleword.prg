#include "FiveWin.Ch"
#include "Factu.ch" 

//------------------------------------------------------------------------//

CLASS TOleWord

   DATA  cTitle
   DATA  lMeter
   DATA  cMessage

   DATA  oWord

   DATA  oWaitMeter

   DATA  lError      INIT  .f.

   Method New()

   Method ExportBrowse( oBrowse )

   Method End()

END CLASS

//----------------------------------------------------------------------------//

Method New( cTitle, cMessage, lMeter )

   local oBlock

   DEFAULT cTitle    := "Espere por favor"
   DEFAULT lMeter    := .t.
   DEFAULT cMessage  := "Conectando con Word"

   ::cTitle          := cTitle
   ::lMeter          := lMeter
   ::cMessage        := cMessage

   if ::lMeter
      ::oWaitMeter   := TWaitMeter():New( ::cTitle, ::cMessage )
      ::oWaitMeter:Run()
   end if

   TRY
      ::oWord        := GetActiveObject( "Word.Application" )
   CATCH
      TRY
         ::oWord     := CreateObject( "Word.Application" )
      CATCH
         ::lError    := .t.
         MsgStop( "ERROR! Word no disponible. [" + Ole2TxtError()+ "]" )
         RETURN ( Self )
      END
   END

Return ( Self )

//----------------------------------------------------------------------------//

Method ExportBrowse( oBrowse )

   local nRec
   local nRow
   local nCol
   local uData
   local oDocs
   local oActiveDoc
   local oRange
   local oTables
   local oTable
   local oTablesItem
   local oTablesItemCell
   local oTablesItemCellRange
   local aText
   local cText       := ""
   local nBrowseLen
   local nBrowseHead
   local nBrowseAt
   local nEvery
   local oBlock
   local oError

   if ::lError
      Return ( Self )
   end if

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if !Empty( oBrowse:cAlias ) .and. Upper( oBrowse:cAlias ) != "ARRAY" .and. Upper( oBrowse:cAlias ) != "_TXT_"
         nRec           := ( oBrowse:cAlias )->( Recno() )
      end if

      nBrowseLen        := oBrowse:nLen
      nBrowseHead       := len( oBrowse:aHeaders )
      nBrowseAt         := oBrowse:nAt
      nEvery            := Max( 1, Int( nBrowseLen / 10 ) )

      if ::lMeter
         ::oWaitMeter:SetTotal( nBrowseLen )
         ::oWaitMeter:SetMessage( "Exportando datos a Word" )
      end if

      oDocs             := ::oWord:Get( "Documents" )
      oDocs:Add()

      oActiveDoc        := ::oWord:Get( "ActiveDocument" )
      oRange            := oActiveDoc:Range( 0, 0 )

      oTables           := oActiveDoc:Tables()
      oTable            := oTables:Add( oRange, nBrowseLen, nBrowseHead )
      oTablesItem       := oTables:Item( 1 )

      /*
      Recorremos el browse--------------------------------------------------------
      */

      oBrowse:GoTop()

      for nRow := 1 to nBrowseLen

         aText          := Eval( oBrowse:bLine )

         for nCol := 1 to Len( aText )

            if ValType( aText[ nCol ] ) != "C"
               uData    := ""
            else
               uData    := StrTran( aText[ nCol ], CRLF, Chr( 10 ) )
            end if

            oTablesItemCell            := oTablesItem:Cell( nRow, nCol )
            oTablesItemCellRange       := oTablesItemCell:Range()
            oTablesItemCellRange:Text  := uData

            cText       += AllTrim( uData ) + Chr( 9 )

         next

         oBrowse:Skip( 1 )

         SysRefresh()

         if ::lMeter .and. Mod( nRow, nEvery ) == 0
            ::oWaitMeter:RefreshMeter( nRow )
         end if

      next

      oTablesItem:AutoFitBehavior( 1 )

      if !Empty( oBrowse:cAlias ) .and. Upper( oBrowse:cAlias ) != "ARRAY" .and. Upper( oBrowse:cAlias ) != "_TXT_"
         ( oBrowse:cAlias )->( dbGoTo( nRec ) )
      end if

      oBrowse:nAt       := nBrowseAt

      if ::lMeter
         ::oWaitMeter:RefreshMeter( nBrowseLen )
      end if

      ::oWord:Visible   := .t.

   RECOVER USING oError

      msgStop( "Error al exportar a Word." + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( Self )

//----------------------------------------------------------------------------//

Method End()

   if !Empty( ::oWord )
      ::oWord           := nil
   end if

   if ::lMeter .and. !Empty( ::oWaitMeter )
      ::oWaitMeter:End()
   end if

Return ( Self )

//----------------------------------------------------------------------------//