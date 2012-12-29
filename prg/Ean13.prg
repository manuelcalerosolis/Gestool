// genera codigo ean13
#include "FiveWin.Ch"
#include "Font.ch"

//-------------------------------------------------------------------------//

FUNCTION ean13( nRow, nCol, cCode, oPrint, Color, lHorz, nWidth, nHeigth,;
					lBanner, cFont)

	 local nLen

	 /*
	 Test de parametros por implementar
	 */

	 DEFAULT nHeigth 	:= 1.5
	 DEFAULT lBanner	:=	.f.

	 /*
	 Desplazamiento...
	 */

	 IF lHorz
		  goCode( _ean13( cCode ), nRow, nCol, oPrint, lHorz, lBanner, Color, nWidth, nHeigth * 0.90 )
	 ELSE
		  /*
		  10% espacios
		  */
		  nLen	:=	Round( nHeigth * 10 * oPrint:nHorzRes() / oPrint:nHorzSize(), 0 ) * 0.1
		  goCode( _ean13( cCode ), nRow, nCol + nLen, oPrint, lHorz, lBanner, Color, nWidth, nHeigth * 0.90 )
	 END

	 goCode( _ean13Bl(), nRow, nCol, oPrint, lHorz, lBanner, Color, nWidth, nHeigth )

	 IF lBanner
		  BarLen13( cCode, oPrint, nRow, nCol, Color, lHorz, nWidth, nHeigth, cFont )
	 END

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION goCode( cBarra, nx, ny, oDevice, lHorz, lBanner, nColor, nWidth, nLen )

    local n, oBr

	 IF Empty( nColor )
		  nColor 		:= CLR_BLACK
	 END

	 DEFAULT lHorz 	:= .t.

	 nWidth := 4 // pixels de la barara round( nWidth / len ( cBarra ), 0 )

	 DEFINE BRUSH oBr COLOR nColor

	 /*
	 Correcci¢n para que el banner quepa en caso de que estemos pegados al
	 borde de la p gina
	 */

	 IF lBanner .AND. lHorz
			ny := ny + nWidth * 8
	 ELSEIF lBanner .AND. !lHorz
			nx := nx + nWidth * 8
	 END IF

	 FOR n := 1 to Len( cBarra )

			IF Substr( cBarra, n, 1 ) = '1'

				IF lHorz
					 oDevice:fillRect( { nx, ny, nx + nLen, ( ny += nWidth ) }, oBr )
				ELSE
					 oDevice:fillRect( { nx, ny, ( nx += nWidth ), ny + nLen }, oBr )
				END

			ELSE

				IF lHorz
					ny += nWidth
				ELSE
					nx += nWidth
				END

			END

    NEXT

	 oBr:end()

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION BarLen13( cCode, oPrint, nRow, nCol, Color, lHorz, nWidth, nLen,;
							cFont)

	 local oFont
	 local nLenChar
	 local k

	 DEFAULT lHorz 	:= .t.,;
            cFont    := "Arial",;
				Color 	:= CLR_BLACK

	 nWidth 				:= 4 // pixels

	 DEFINE FONT oFont NAME cFont OF oPrint SIZE nWidth * 6, nLen * 0.05 ;
		  NESCAPEMENT If( lHorz, 0, 13500 )

	 k	:= left( alltrim( cCode ) + '000000000000', 12 )

	 /*
	 Calculo del digito de control
	 */

	 k	:=	k + Ean13Check( k )

	 IF lHorz
		  oPrint:say( nRow + nLen * 0.9, nCol , left( k, 1 ), oFont, , Color )
		  oPrint:say( nRow + nLen * 0.9, nCol + nWidth * 11, substr( k, 2, 6 ), oFont, , Color )
		  oPrint:say( nRow + nLen * 0.9, nCol + nWidth * 58, substr( k, 8, 6 ), oFont, , Color )
	 ELSE
		  oPrint:say( nRow , nCol + nLen * 0.1, left( k, 1 ), oFont, , Color )
		  oPrint:say( nRow + nWidth * 11, nCol + nLen * 0.1, substr( k, 2, 6 ), oFont, , Color )
		  oPrint:say( nRow + nWidth * 58, nCol + nLen * 0.1, substr( k, 8, 6 ), oFont, , Color )
	 END

RETURN NIL

//--------------------------------------------------------------------------//
/*
Pintar codigo de barras
*/

function DrwBar( uCodBar, nTipBar, oGetBar, oFntBar )

   local oFnt
   local cPinta      := ""
   local cFuente     := ""
   local lEan13      := .f.
   local cCodBar

   if Valtype( uCodBar ) == "O"
      cCodBar        := uCodBar:VarGet()
   else
      cCodBar        := uCodBar
   end if

   DEFAULT cCodBar   := ""
   DEFAULT nTipBar   := 1

   // Correcciones para Ean 13 le ponemos el digito de control.

   if nTipBar == 1 .and. Len( AllTrim( cCodBar ) ) == 12
      cCodBar        := AllTrim( cCodBar ) + Ean13Check( cCodBar )
   end if

   if nTipBar == 1 .and. Valtype( uCodBar ) == "O"
      uCodBar:cText( cCodBar )
   end if

   /*lEan13            := ( nTipBar == 1 )                    .AND. ;
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
         if oGetBar != nil
            oGetBar:SetFont( oFnt )
            oGetBar:SetText( "Fuente " + cFuente + " no instalada." )
         end if
         oFnt:end()

      else

         if oGetBar != nil
            oGetBar:SetFont( oFntBar )
            oGetBar:SetText( cPinta )
         end if

      endif

      SysRefresh()

      oFntBar:end()

      if nTipBar == 1 .and. Valtype( uCodBar ) == "O"
         uCodBar:cText( cCodBar )
      end if

   end if*/

return .t. // para los valid

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

   for n := 1 TO Len( cCode )
      nNumero     := Val( SubStr( cCode, n, 1 ) )
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
return "*" + AllTrim( cCode ) + "*"

//-----------------------------------------------------------------------------//

function cCode128( cCode )
return Chr( 202 ) + AllTrim( cCode ) + Chr( 138 )

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