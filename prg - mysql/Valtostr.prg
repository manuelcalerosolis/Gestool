#include "fivewin.ch"
#include "hbcompat.ch"

#ifndef _SET_TIMEFORMAT  // fwppc
   #define _SET_TIMEFORMAT 116
#endif

//----------------------------------------------------------------------------//

static cRegion := 'A', lCommas := .f., lDisplayZeros := nil

//----------------------------------------------------------------------------//

function FWNumFormat( cIntl, lThouSep, lDispZeros )

   local aPrevSet    := { cRegion, lCommas, lDisplayZeros }

   if ValType( cIntl ) == 'C' .and. ( cIntl := Upper( cIntl ) ) $ "AEI"
      cRegion        := cIntl
   endif
   if ValType( lThouSep ) == 'L'
      lCommas        := lThouSep
   endif
   if PCount() >= 3 .and. ( lDispZeros == nil .or. ValType( lDispZeros ) == 'L' )
      lDisplayZeros  := lDispZeros
   endif

return aPrevSet

//----------------------------------------------------------------------------//

function NumPict( nLen, nDec, lDBF, lComma, lDispZeros )

   local   cPic

   DEFAULT  nDec        := 0, lDBF := .t., ;
            lComma      := If( nDec > 0, lCommas, .f. ), ;
            lDispZeros  := lDisplayZeros

   nLen        += 2  // to accommdate totals

   if nDec > 0
      nLen     -= ( nDec + If( lDbf, 1, 0 ) )
   endif

   nLen        := Max( Min( 14, nLen ), 1 )
   cPic        := Replicate( '9', nLen )

   if lComma
      cPic     := LTrim( Transform( Val( cPic ), If( cRegion == 'I', ;
                     "99,999,99,99,99,999", "99,999,999,999,999" ) ) )
   endif

   if cRegion == "E"
     cPic      := If( lDispZeros == .f., "@ZE ",  "@E " ) + cPic
   else
     cPic      := If( lDispZeros == .f., "@Z ",  "" ) + cPic
   endif

   if nDec > 0
      cPic      += ( '.' + Replicate( '9', nDec ) )
   endif

return cPic

//----------------------------------------------------------------------------//

function cValToStr( uVal, cPic, cInternational, lDispZeros )

   local cVal

   DEFAULT cInternational := cRegion, lDispZeros := lDisplayZeros

   if ValType( cPic ) == 'B'
      cPic     := Eval( cPic, uVal )
   endif

#ifdef __XHARBOUR__
      // new valtype 'T'
      // fails with picture clause '@D' and '@E'
      // cmonth and cdow fail too

      if ValType( uVal ) == 'T' .and. ! Empty( cPic )
         uVal  := CToD( DToC( uVal ) )
      endif
#endif

   if uVal == nil
      cVal = "nil"

   elseif Empty( cPic )
      if ValType( uVal ) == 'N' .and. cInternational == 'E'
         cVal  := Transform( uVal, '@E' )
      else
         cVal     := cValToChar( uVal )
      endif

#ifdef __HARBOUR__
   elseif cPic == '@T'
#ifdef __XHARBOUR__
      cVal     := If( Year( uVal ) == 0, TTOC( uVal, 2 ), TTOC( uVal ) )
#else
      cVal     := If( Year( uVal ) == 0, HB_TToC( uVal, '', Set( _SET_TIMEFORMAT ) ), HB_TToC( uVal ) )
#endif
#endif

   elseif ValType( uVal ) $ 'DT' .and. Left( cPic, 1 ) != "@"
      if Empty( uVal )
         cVal  := Space( Len( cPic ) )
      else
         cVal := Lower( cPic )
         cVal    := StrTran( cVal, 'dd', StrZero( Day( uVal ), 2 ) )
         if 'mmmm' $ cVal
            cVal    := StrTran( cVal, 'mmmm', If( 'MMMM' $ cPic, Upper( cMonth( uVal ) ), cMonth( uVal ) ) )
         elseif 'mmm' $ cVal
            cVal    := StrTran( cVal, 'mmm', Left( If( 'MMM' $ cPic, Upper( cMonth( uVal ) ), cMonth( uVal ) ), 3 ) )
         else
            cVal    := StrTran( cVal, 'mm', StrZero( Month( uVal ), 2 ) )
         endif
         if 'yyyy' $ cVal
            cVal    := StrTran( cVal, 'yyyy', Str( Year( uVal ), 4, 0 ) )
         else
            cVal    := StrTran( cVal, 'yy',   StrZero( Year( uVal ) % 100, 2 ) )
         endif

#ifdef __HARBOUR__
         if 'hh' $ cVal
   #ifdef __XHARBOUR__
            cVal     := Left( cVal, At( 'hh', cVal ) - 1 ) + TToC( uVal, 2 )
   #else
            cVal     := Left( cVal, At( 'hh', cVal ) - 1 ) + HB_TToC( uVal, '', Set( _SET_TIMEFORMAT ) )
   #endif
         endif
      endif
#endif
   else
      cVal     := Transform( uVal, cPic )
   endif
   if Empty( uVal ) .and. lDispZeros != nil .and. ValType( uVal ) $ "DNT"    // date, number, datetime
      if lDispZeros
         if Empty( cVal ) .and. ValType( uVal ) == 'N'
            cPic  := LTrim( StrTran( StrTran( StrTran( StrTran( cPic, '@Z ', '' ), '@z ', '' ), 'Z', ), 'z', '' ) )
         endif
         cVal  := Transform( uVal, cPic )
      else
         cVal  := Space( Len( cVal ) )
      endif
   endif
   if Left( cVal, 1 ) == "*" .and. Len( cVal ) > 2 .and. ValType( uVal ) == 'N'
      cVal  := N2E( uVal, Max( Len( cVal ) - 4, 0 ) )
   endif

return cVal

//----------------------------------------------------------------------------//

static function N2E( nNum, nDec )

   local e := 0, nLog, cRet

   DEFAULT nDec := 2

   nLog  := Log10( nNum )
   e     := Floor( nLog )
   nNum  := 10 ^ ( nLog - e )
   if e > 9 .and. nDec > 0
      nDec--
   endif
   cRet  := Str( nNum, nDec + 2, nDec ) + "E" + LTrim( Str( e ) )

return cRet

//----------------------------------------------------------------------------//

static function dCharToDate( cDate )

   local cFormat, cc
   local dDate

   if ( cc := Upper( cDate ) ) != Lower( cDate )
      return dAlphaToDate( cc )
   endif
   cFormat  := Lower( Set( _SET_DATEFORMAT ) )
   dDate    := CToD( cDate )
   if Empty( dDate )
      cc    := Left( cFormat, 2 )
      Set( _SET_DATEFORMAT, If( cc == 'dd', 'mm/dd/yy', 'dd/mm/yy' ) )
      dDate := CToD( cDate )
      if cc == 'yy' .and. Empty( dDate )
         SET DATE AMERICAN
         dDate := CToD( cDate )
      endif
   endif
   Set( _SET_DATEFORMAT, cFormat )

return dDate

//----------------------------------------------------------------------------//

static function dAlphaToDate( cDate )

   local dDate := CToD( '' )
   local c, d, m, y, n, nEpoch
   local aMonths  := { 'JAN','FEB','MAR','APR','MAY', 'JUN','JUL','AUG','SEP','OCT','NOV','DEC' }
   local aNum     := {'',''}

   for n := 1 to 12
      if aMonths[ n ] $ cDate
         m  := n
         exit
      endif
   next n

   if ! Empty( m )
      aNum     := ParseNumsFromDateStr( cDate )
      if Empty( aNum[ 2 ] )
         aNum[ 2 ]      := Year( Date() )
      else
         if aNum[ 2 ] < 100
            nEpoch      := Set(_SET_EPOCH)
            aNum[ 2 ]   += 1900
            if aNum[ 2 ] < nEpoch
               aNum[ 2 ] += 100
            endif
         endif
      endif
      // yet to implement time part
      dDate    := SToD( StrZero( aNum[ 2 ], 4 ) + StrZero( m, 2 ) + StrZero( aNum[ 1 ], 2 ) )
   endif

return dDate

//----------------------------------------------------------------------------//


static function ParseNumsFromDateStr( cStr )

   local aNum  := {}
   local cNum  := ''
   local c

   for each c in cStr
      if IsDigit( c )
         cNum  += c
      else
         if c == ':' .and. Len( aNum ) < 2
            ASize( aNum, 2 )
         endif
         if ! Empty( cNum )
            AAdd( aNum, cNum )
            cNum  := ''
         endif
      endif
   next c
   if !Empty( cNum )
      AAdd( aNum, cNum )
   endif
   if Len( aNum ) < 2
      ASize( aNum, 2 )
   endif


   AEval( aNum, { |c,i| aNum[ i ] := If( c == nil, 0, Val( c ) ) } )

   if aNum[ 1 ] > 31
      c           := aNum[ 1 ]
      aNum[ 1 ]   := aNum[ 2 ]
      aNum[ 2 ]   := c
   endif

return aNum

//----------------------------------------------------------------------------//

function uCharToVal( cText, cType )

   local uVal, c
   local cTrue    := "|.T.|T|TRUE|YES|VERDADERO|VERO|WAHR|VRAI|VERDADEIRO|"
   local cFalse   := "|.F.|F|FALSE|NO|FALSO|FALSCH|FAUX|"
   local lPercent := .f.

   if ValType( cType ) == 'C' .and. Len( cType ) == 1 .and. ;
      Upper( cType ) $ 'CDLMN'
      cType    := Upper( cType )
      if cType == 'M'
         cType := 'C'
      endif
   else
      cType    := ValType( cType )
   endif
   if cType == 'T'
      cType := 'D'
   endif

   if ValType( cText ) == 'C'
      cText    := AllTrim( cText )

      do case
      case cType == 'C'
         uVal  := cText
      case cType == 'N'
         lPercent := '%' $ cText
         do while !Empty( cText ) .and. !IsDigit( cText ) .and. Left( cText, 1 ) != '-'
            cText    := SubStr( cText, 2 )
         enddo
         uVal  := Val( StrTran( StrTran( cText, ',', nil ), '%', '' ) )
         if lPercent
            uVal  *= 0.01
         endif
      case cType == 'L'
         uVal  := ( '|' + Upper( cText ) + '|' $ cTrue )
      case cType == 'D'
         UvAL  := dCharToDate( cText )
      otherwise
         lPercent       := ( '%' $ cText )
         if ( IsDigit( cText ) .or. Left( cText, 1 ) == '-' ) .and. ;
            LTrim( Str( Val( c := StrTran( StrTran( cText, ",", nil ), '%', '' ) ) ) ) == c
               uVal     := Val( c )
               if lPercent
                  uVal  *= 0.01
               endif
               cType    := 'N'
         elseif '|' + Upper( cText ) + '|'  $ cTrue
            uVal     := .t.
            cType    := 'L'
         elseif '|' + Upper( cText ) + '|'  $ cFalse
            uVal     := .f.
            cType    := 'L'
         else
            uVal     := dCharToDate( cText )
            if Empty( uVal )
               uVal  := cText
               cType := 'C'
            else
               cType := 'D'
            endif
         endif

      endcase
    else
       uVal       := cText
       cType      := ValType( uVal )
    endif

return uVal

//----------------------------------------------------------------------------//

function WheelScroll()

   #ifndef HKEY_CURRENT_USER
      #define  HKEY_CURRENT_USER       2147483649        // 0x80000001
   #endif

   static nScrLines  := nil

   local oReg

   if nScrLines == nil
      // oReg:= TReg32():New( HKEY_CURRENT_USER, "Control Panel\Desktop" )
      // nScrLines := oReg:Get( "WheelScrollLines" )
      // oReg:Close()

      if Empty( nScrLines )
         nScrLines   := 1
      else
         nScrLines   := Val( nScrLines )
      endif
   endif

return nScrLines

//----------------------------------------------------------------------------//


function IsBinaryData( cData )

   local c, n, nLen, lBinary  := .f.
   local hMem, nFormat, hBmp

   nLen  := Min( 200, Len( cData ) )
   for n := 1 to nLen
      c  := SubStr( cData, n, 1 )
      if ( c < ' ' .and. !( c $ Chr( 9 ) + Chr( 10 ) + Chr( 13 ) + Chr(26) ) )
         lBinary  := .t.
         exit
      endif
   next

return lBinary

//------------------------------------------------------------------//

function FW_ValToExp( uVar )

   local cExp, cType := ValType( uVar )

   do case
   case uVar == nil
      cExp  := ''
   case cType == 'A'
      cExp  := '{'
      if ! Empty( uVar )
         cExp     += FW_ValToExp( uVar[ 1 ] )
         AEval( uVar, { |x| cExp += ',' + FW_ValToExp( x ) }, 2 )
      endif
      cExp  += '}'
   case cType == 'C'
//      cExp  := '[' + uVar + ']'
      cExp  := StringToLiteral( uVar )
   case cType == 'D'
      cExp  := 'SToD("' + DToS( uVar ) + '")'
   case cType == 'T'
      cExp  := 'FW_SToT("' + TToS( uVar ) + '")'
   otherwise
      cExp  := cValToChar( uVar )
   endcase

return cExp

//----------------------------------------------------------------------------//

function FW_SToT( c ); return SToT( c )

//----------------------------------------------------------------------------//
