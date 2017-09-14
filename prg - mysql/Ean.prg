#include "FiveWin.Ch"
#include "Font.ch"

/*
Pintar codigo de barras
*/


function DrwBar( uCodBar, nTipBar, oGetBar, lCalDigit )

   local oFnt
   local oFntBar
   local cPinta      := ""
   local cFuente     := ""
   local lTexto      := .t.
   local lEan13      := .f.
   local cCodBar

   DEFAULT lCalDigit := .f.
   DEFAULT cCodBar   := ""
   DEFAULT nTipBar   := 1

   if Valtype( uCodBar ) == "O"
      cCodBar        := uCodBar:VarGet()
   else
      cCodBar        := uCodBar
   end if

   // Correcciones para Ean 13 le ponemos el digito de control.

   if lCalDigit .and. nTipBar == 1 .and. len( alltrim( cCodBar ) ) == 12
      cCodBar        := AllTrim( cCodBar ) + Ean13Check( cCodBar )
   end if

   lEan13            := ( nTipBar == 1 )                    .AND. ;
                        ( (len( AllTrim( cCodBar ) ) != 13  .AND. ;
                           len( AllTrim( cCodBar ) ) != 15  .AND. ;
                           len( AllTrim( cCodBar ) ) != 18 ).OR.  ;
                           lBadDigits( AllTrim( cCodBar ) ) )

   if !lEan13

      do case
         case nTipBar == 1
              DEFINE FONT oFntBar NAME "UPCHeightA"  SIZE  5, 40  // EAN 13
              cPinta  = If( Empty( cCodBar ) .OR. cCodBar == space( 18 ), "", cEan13( cCodBar ) )
              cFuente = "EAN13"
         case nTipBar == 2
              DEFINE FONT oFntBar NAME "Code 39"  SIZE 1, 70
              cPinta  = If( Empty( cCodBar ) .OR. cCodBar == space( 18 ), "", cCode39( cCodBar ) )
              cFuente = "CODE39"
         case nTipBar == 3
              DEFINE FONT oFntBar NAME "Code128B" SIZE 7, 60
              cPinta  = If( Empty( cCodBar ) .OR. cCodBar == space( 18 ), "", cCode128( cCodBar ) )
              cFuente = "CODE128"
      endcase

      if Upper( AllTrim( oFntBar:cFaceName ) ) != "UPCHEIGHTA"   .AND. ;
         Upper( AllTrim( oFntBar:cFaceName ) ) != "CODE 39"      .AND. ;
         Upper( AllTrim( oFntBar:cFaceName ) ) != "CODE128B"

         DEFINE FONT oFnt NAME "Arial" SIZE 0,- 10

         oGetBar:SetFont( oFnt )
         oGetBar:SetText( "Fuente " + cFuente + " no instalada." )
         lTexto      := .f.

         oFnt:end()

      else

         oGetBar:SetFont( oFntBar )
         oGetBar:SetText( cPinta )

      endif

      sysRefresh()

      oFntBar:end()

      if nTipBar == 1 .and. Valtype( uCodBar ) == "O"
         uCodBar:cText( cCodBar )
      end if

   end if

return .t. // para los valid

//-----------------------------------------------------------------------------//

function lCalEan13( oCodBar )

   local cCodBar

   if !Empty( oCodBar )

      cCodBar           := oCodBar:VarGet()

      if len( AllTrim( cCodBar ) ) == 12
         cCodBar        := AllTrim( cCodBar ) + Ean13Check( cCodBar )
      end if

      oCodBar:cText( cCodBar )
      oCodBar:Refresh()

   end if

return .t.

//-----------------------------------------------------------------------------//

function cEan13( cCode )

   local n
   local cCodeBar := ""
   local nNumero  := 0
   local nAdemdum := 0
   local nNumeroA := 0
   local nNumeroB := 0
   local nNumeroX := 0
   local nValor1  := 8

   cCode          := AllTrim( cCode )
   nValor1        := Val( Left( cCode, 1 )  )

   if Len( cCode ) == 12
      cCode       += Ean13Check( cCode )
   end if

   if Len( cCode ) > 13
      if Len( cCode ) == 15
         nAdemdum := 2  // Tiene ademdum de 2 dígitos
      else
         nAdemdum := 5  // Tiene ademdum de 5 dígitos
         nNumeroA := 3 * (  Val( SubStr( cCode, 14, 1 ) ) + Val( SubStr( cCode, 16, 1 ) ) + Val( SubStr( cCode, 18, 1 ) ) )
         nNumeroB := 9 * (  Val( SubStr( cCode, 15, 1 ) ) + Val( SubStr( cCode, 17, 1 ) )                                 )
         nNumeroX := nNumeroA + nNumeroB
         nNumeroX := Val( Right( AllTrim( Str( nNumeroX ) ), 1 )  )
      endif
   endif

   for n := 1 to Len( cCode )
      nNumero = Val( SubStr( cCode, n, 1 ) )
      do case
         case n ==  1              // PRIMER DIGITO
              cCodeBar += Chr( nNumero + 117 )   // Primer Nº a la Izda del separador
              cCodeBar += "<"                    // Separador Izquierdo
         case n >=  2 .AND. n <=  7  // PARTE IZQUIERDA
              cCodeBar += Tabla1( n, nValor1, nNumero )
              if n == 7
                 cCodeBar += "="                  // Separador Central
              endif
         case n >=  8 .AND. n <= 13  // PARTE DERECHA
              cCodeBar += Chr( nNumero + 97 )
              if n == 13
                 cCodeBar += "<"                  // Separador Derecho
              endif
         case n >= 14 .AND. n <= 15  // PRIMERA PARTE DEL ADENDUM
              if n == 14
                 cCodeBar += " +"     // Siempre un espacio y un + al empezar el Ademdum
              endif
              if nAdemdum == 2     // Si es ademdum de 2 dígitos
                 do case
                    case Val( SubStr( cCode ,14, 2  ) ) % 4 == 0 // Si es múltiplo de 4
                         cCodeBar += Chr( nNumero +  85 )
                    case Val( SubStr( cCode ,14, 2  ) ) % 4 == 1 // Si resta 1
                         if n == 14
                            cCodeBar += Chr( nNumero +  85 )
                         else   // 15
                            cCodeBar += Chr( nNumero + 128 )
                         endif
                    case Val( SubStr( cCode ,14, 2  ) ) % 4 == 2 // Si resta 2
                         if n == 14
                            cCodeBar += Chr( nNumero + 128 )
                         else   // 15
                            cCodeBar += Chr( nNumero +  85 )
                         endif
                    case Val( SubStr( cCode ,14, 2  ) ) % 4 == 3 // Si resta 3
                         cCodeBar += Chr( nNumero + 128 )
                 endcase
                if n == 14
                   cCodeBar += "-"
                endif
              else                 // Si es de 5 Dígitos
                 cCodeBar += Tabla5( n, nNumero, nNumeroX )
                 cCodeBar += "-"
              endif
         case n >= 16 .AND. n <= 18  // SEGUNDA PARTE DEL ADENDUM
              cCodeBar += Tabla5( n, nNumero, nNumeroX )
              if n != 18
                 cCodeBar += "-"
              endif
      endcase
   next

return cCodeBar

//-----------------------------------------------------------------------------//

function cCode39( cCode )
return "*" + Alltrim( cCode ) + "*"

//-----------------------------------------------------------------------------//

function cCode128( cCode )
return Chr( 202 ) + Alltrim( cCode ) + Chr( 138 )

//-----------------------------------------------------------------------------//

function lBadDigits( cCode )

   local i
   local lBad := .f.

   for i := 1 TO Len( cCode )
       if ! IsDigit( SubStr( cCode, i, 1 ) )
          lBad = .t.
          exit
       endif
   next

return lBad

//-----------------------------------------------------------------------------//

function Tabla1( n, nValor1, nNumero )

   local cChar := Chr( nNumero + 33  )

   if ( nValor1 == 1 .AND. ( n ==  4 .OR. n ==  6 .OR. n == 7 ) ) .OR. ;
      ( nValor1 == 2 .AND. ( n ==  4 .OR. n ==  5 .OR. n == 7 ) ) .OR. ;
      ( nValor1 == 3 .AND. ( n ==  4 .OR. n ==  5 .OR. n == 6 ) ) .OR. ;
      ( nValor1 == 4 .AND. ( n ==  3 .OR. n ==  6 .OR. n == 7 ) ) .OR. ;
      ( nValor1 == 5 .AND. ( n ==  3 .OR. n ==  4 .OR. n == 7 ) ) .OR. ;
      ( nValor1 == 6 .AND. ( n ==  3 .OR. n ==  4 .OR. n == 5 ) ) .OR. ;
      ( nValor1 == 7 .AND. ( n ==  3 .OR. n ==  5 .OR. n == 7 ) ) .OR. ;
      ( nValor1 == 8 .AND. ( n ==  3 .OR. n ==  5 .OR. n == 6 ) ) .OR. ;
      ( nValor1 == 9 .AND. ( n ==  3 .OR. n ==  4 .OR. n == 6 ) )
      cChar = Chr( nNumero + 107 )
   endif

return cChar

//-----------------------------------------------------------------------------//

function Tabla5( n, nNumero, nNumeroX )

   local Caracter := Chr( nNumero + 85  )  // Las barras del ademdum A

   if ( nNumeroX == 0 .AND. ( n == 14 .OR. n == 15 ) ) .OR. ;
      ( nNumeroX == 1 .AND. ( n == 14 .OR. n == 16 ) ) .OR. ;
      ( nNumeroX == 2 .AND. ( n == 14 .OR. n == 17 ) ) .OR. ;
      ( nNumeroX == 3 .AND. ( n == 14 .OR. n == 18 ) ) .OR. ;
      ( nNumeroX == 4 .AND. ( n == 15 .OR. n == 16 ) ) .OR. ;
      ( nNumeroX == 5 .AND. ( n == 16 .OR. n == 17 ) ) .OR. ;
      ( nNumeroX == 6 .AND. ( n == 17 .OR. n == 18 ) ) .OR. ;
      ( nNumeroX == 7 .AND. ( n == 15 .OR. n == 17 ) ) .OR. ;
      ( nNumeroX == 8 .AND. ( n == 15 .OR. n == 18 ) ) .OR. ;
      ( nNumeroX == 9 .AND. ( n == 16 .OR. n == 18 ) )
      Caracter := Chr( nNumero + 128 )
   endif

return Caracter

//-----------------------------------------------------------------------//

function Ean13Check( cCode )

	local n
   local nControl
   local s1    := 0
   local s2    := 0
   local l     := 10

   for n := 1 TO 6
      s1       := s1 + val( substr( cCode, ( n * 2 ) -1, 1 ) )
      s2       := s2 + val( substr( cCode, ( n * 2 ), 1 ) )
   next

   nControl    := ( s2 * 3 ) + s1

   while nControl > l
      l        := l + 10
   end while

   nControl    := l - nControl

return Str( nControl, 1, 0 )

//--------------------------------------------------------------------------//