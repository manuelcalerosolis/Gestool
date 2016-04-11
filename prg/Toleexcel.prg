#include "FiveWin.Ch"

//------------------------------------------------------------------------//

CLASS TOleExcel

   DATA  cTitle
   DATA  lMeter
   DATA  cMessage

   DATA  oExcel
   DATA  oClipBoard

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
   DEFAULT cMessage  := "Conectando con Excel"

   ::cTitle          := cTitle
   ::lMeter          := lMeter
   ::cMessage        := cMessage

   if ::lMeter
      ::oWaitMeter   := TWaitMeter():New( ::cTitle, ::cMessage )
      ::oWaitMeter:Run()
   end if

   TRY
      ::oExcel       := GetActiveObject( "Excel.Application" )
   CATCH
      TRY
         ::oExcel    := CreateObject( "Excel.Application" )
      CATCH
         ::lError    := .t.
         MsgStop( "ERROR! Excel no disponible. [" + Ole2TxtError()+ "]" )
         RETURN ( Self )
      END
   END

   ::oClipBoard   := TClipBoard():New()
   ::oClipBoard:Clear()

Return ( Self )

//----------------------------------------------------------------------------//

Method ExportBrowse( oBrowse )

   local nRec
   local nRow
   local nCol
   local uData
   local oBook
   local oSheet
   local oRange
   local cCell
   local cRange
   local aText
   local nLine       := 1
   local nStart      := 1
   local cText       := ""
   local nBrowseLen
   local nBrowseHead
   local nBrowseAt
   local nEvery

   if ::lError
      Return ( Self )
   end if

   nBrowseLen        := oBrowse:nLen
   nBrowseHead       := len( oBrowse:aHeaders )
   nBrowseAt         := oBrowse:nAt
   nEvery            := Max( 1, Int( nBrowseLen / 10 ) )


   if !Empty( oBrowse:cAlias ) .and. Upper( oBrowse:cAlias ) != "ARRAY" .and. Upper( oBrowse:cAlias ) != "_TXT_"
      nRec           := ( oBrowse:cAlias )->( Recno() )
   end if

   if ::lMeter
      ::oWaitMeter:SetTotal( nBrowseLen )
      ::oWaitMeter:SetMessage( "Exportando datos a Excel" )
   end if

   ::oExcel:WorkBooks:Add()

   oBook             := ::oExcel:Get( "ActiveWorkBook")
   oSheet            := ::oExcel:Get( "ActiveSheet" )

   oBrowse:GoTop()

   for nRow := 1 to nBrowseLen

      if nRow == 1

         oSheet:Cells( nLine++, 1 ):Value := "GST+ exportación a Excel"
         oSheet:Range( "A1:" + Chr( 64 + nBrowseHead ) + "1" ):HorizontalAlignment := 7
         ++nLine
         nStart      := nLine

         for nCol := 1 To nBrowseHead

            uData    := oBrowse:aHeaders[ nCol ]

            if ValType( uData ) != "C"
               loop
            end if

            cText    += StrTran( uData, CRLF, Chr( 10 ) ) + Chr( 9 )

         next

         cText       += Chr( 13 )

      end if

      aText          := Eval( oBrowse:bLine )

      for nCol := 1 To Len( aText )

         if ValType( aText[ nCol ] ) != "C"
            uData    := ""
         else
            uData    := StrTran( aText[ nCol ], CRLF, Chr( 10 ) )
         end if

         cText       += AllTrim( uData ) + Chr( 9 )

      next

      oBrowse:Skip( 1 )

      SysRefresh()

      if ::lMeter .and. Mod( nRow, nEvery ) == 0
         ::oWaitMeter:RefreshMeter( nRow )
      end if

      cText          += Chr( 13 )

      ++nLine

      /*
      Cada 20k volcamos el texto a la hoja de Excel , usando el portapapeles , algo muy rapido y facil
      */

      if Len( cText ) > 20000

         ::oClipBoard:Clear()
         ::oClipBoard:SetText( cText )

         cCell       := "A" + Alltrim( Str( nStart ) )
         oRange      := oSheet:Range( cCell )
         oRange:Select()
         oSheet:Paste()

         cText       := ""
         nStart      := nLine + 1

      end if

   next

   if !Empty( oBrowse:cAlias ) .and. Upper( oBrowse:cAlias ) != "ARRAY" .and. Upper( oBrowse:cAlias ) != "_TXT_"
      ( oBrowse:cAlias )->( dbGoTo( nRec ) )
   end if

   oBrowse:nAt          := nBrowseAt

   if Len( cText ) > 0
      ::oClipBoard:Clear()
      ::oClipBoard:SetText( cText )

      cCell             := "A" + Alltrim( Str( nStart ) )
      oRange            := oSheet:Range( cCell )
      oRange:Select()
      oSheet:Paste()

      cText             := ""
   end if

   cRange               := "A3:" + Chr( 64 + nBrowseHead ) + Alltrim( Str( oSheet:UsedRange:Rows:Count() ) )
   oRange               := oSheet:Range( cRange )

   if oBrowse:oFont != nil
      oRange:Font:Name  := oBrowse:oFont:cFaceName
      oRange:Font:Size  := Abs( oBrowse:oFont:nSize() )
      oRange:Font:Bold  := oBrowse:oFont:lBold
   end if

   oRange:Borders():LineStyle  := 1

   oRange:Columns:AutoFit()

   oSheet:Range( "A1" ):Select()

   if ::lMeter
      ::oWaitMeter:RefreshMeter( nBrowseLen )
   end if

   ::oExcel:Visible     := .t.

Return ( Self )

//----------------------------------------------------------------------------//

Method End()

   if !Empty( ::oExcel )
      ::oExcel := nil
   end if

   if !Empty( ::oClipBoard )
      ::oClipBoard:End()
   end if

   if ::lMeter
      ::oWaitMeter:End()
   end if

Return ( Self )

//----------------------------------------------------------------------------//