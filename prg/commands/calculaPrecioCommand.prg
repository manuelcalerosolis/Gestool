#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS CalculaPrecioCommand 

   DATA nPrecioBase

   DATA nPorcentajeIVA

   DATA nPrecioIVAIncluido

   METHOD PrecioBase( value )           INLINE ( iif( hb_isnil( value ), ::nPrecioBase, ::nPrecioBase := value ) )

   METHOD PorcentajeIVA( value )        INLINE ( iif( hb_isnil( value ), ::nPorcentajeIVA, ::nPorcentajeIVA := value ) )

   METHOD PrecioIVAIncluido( value )    INLINE ( iif( hb_isnil( value ), ::nPrecioIVAIncluido, ::nPrecioIVAIncluido := value ) )

   METHOD New( nPrecioBase, nPrecioIVAIncluido, nPorcentajeIVA )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( nPrecioBase, nPrecioIVAIncluido, nPorcentajeIVA ) CLASS CalculaPrecioCommand 

   ::PrecioBase( nPrecioBase )

   ::PorcentajeIVA( nPorcentajeIVA )   

   ::PrecioIVAIncluido( nPrecioIVAIncluido )    

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CalculaPrecioCommandHandler

   DATA oCommand

   METHOD New( oCommand ) 

   METHOD caclulaPrecioBase()

   METHOD caclulaIVA()

   METHOD caclulaPrecioIVAIncluido()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oCommand ) 

   ::oCommand  := oCommand

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD caclulaPrecioBase()

RETURN ( ::oCommand:nPrecioIVAIncluido / ( 1 + ::oCommand:nPorcentajeIVA / 100 ) )

//---------------------------------------------------------------------------//

METHOD caclulaIVA()

RETURN ( ::oCommand:nPrecioBase * ::oCommand:nPorcentajeIVA / 100 )

//---------------------------------------------------------------------------//

METHOD caclulaPrecioIVAIncluido()

RETURN ( ::oCommand:nPrecioBase + ::caclulaIVA() )

//---------------------------------------------------------------------------//

