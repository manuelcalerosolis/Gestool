#include "FiveWin.Ch"

//---------------------------------------------------------------------------//

CLASS TItemGroup

   DATA Nombre

   DATA Expresion

   DATA Valor

   DATA Todos
   DATA Desde
   DATA Hasta

   DATA HelpDesde
   DATA HelpHasta

   DATA ValidDesde
   DATA ValidHasta

   DATA TextDesde
   DATA TextHasta

   DATA Imagen
   DATA bCondition
   DATA lImprimir

   DATA cPicDesde
   DATA cPicHasta

   DATA cBitmap

   DATA bValidMayorIgual
   DATA bValidMenorIgual

   METHOD ValidMayorIgual( uVal, uMayor )
   METHOD ValidMenorIgual( uVal, uMenor )

   METHOD GetDesde()       INLINE ( alltrim( ::Desde ) )
   METHOD GetHasta()       INLINE ( alltrim( ::Hasta ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD ValidMayorIgual( uVal, uMayor )

   if IsBlock( ::bValidMayorIgual )
      Return ( Eval( ::bValidMayorIgual, uVal, uMayor ) )
   end if

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD ValidMenorIgual( uVal, uMenor )

   if IsBlock( ::bValidMenorIgual )
      Return ( Eval( ::bValidMenorIgual, uVal, uMenor ) )
   end if

Return ( .t. )

//---------------------------------------------------------------------------//
