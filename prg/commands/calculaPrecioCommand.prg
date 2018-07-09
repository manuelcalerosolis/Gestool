#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS CalculaPrecioCommand 

   DATA nCosto                         INIT 0

   DATA nMargen                        INIT 0

   DATA nMargenReal                    INIT 0

   DATA nPrecioBase                    INIT 0

   DATA nPorcentajeIVA                 INIT 0

   DATA nPrecioIVAIncluido             INIT 0

   // Constructores------------------------------------------------------------

   METHOD New()

   METHOD Build( hBuilder )

   // SETGET-------------------------------------------------------------------

   METHOD Say() 

   METHOD Costo( value )               INLINE ( iif( hb_isnil( value ), ::nCosto, ::nCosto := value ) )

   METHOD Margen( value )              INLINE ( iif( hb_isnil( value ), ::nMargen, ::nMargen := value ) )

   METHOD MargenReal( value )          INLINE ( iif( hb_isnil( value ), ::nMargenReal, ::nMargenReal := value ) )

   METHOD PrecioBase( value )          INLINE ( iif( hb_isnil( value ), ::nPrecioBase, ::nPrecioBase := value ) )

   METHOD PorcentajeIVA( value )       INLINE ( iif( hb_isnil( value ), ::nPorcentajeIVA, ::nPorcentajeIVA := value ) )

   METHOD PrecioIVAIncluido( value )   INLINE ( iif( hb_isnil( value ), ::nPrecioIVAIncluido, ::nPrecioIVAIncluido := value ) )

   // Calculos-----------------------------------------------------------------

   METHOD caclculaPreciosUsandoMargen()

   METHOD caclculaPreciosUsandoBase()
   
   METHOD caclculaPreciosUsandoIVAIncluido()

   METHOD caclculaMargen()             INLINE ( ::Margen( ( ::PrecioBase() - ::Costo() ) / ::Costo() * 100 ) )

   METHOD caclculaMargenReal()         INLINE ( ::MargenReal( ( ::PrecioBase() - ::Costo() ) / ::PrecioBase() * 100 ) )

   METHOD caclculaPrecioBaseSobreCosto() ;
                                       INLINE ( ::PrecioBase( ( ::Costo() * ::Margen() / 100 ) + ::Costo() ) )

   METHOD caclculaPrecioBaseSobrePrecioIVA() ;
                                       INLINE ( ::PrecioBase( ::PrecioIVAIncluido() / ( 1 + ( ::PorcentajeIVA() / 100 ) ) ) )

   METHOD caclculaPrecioIVAIncluido()  INLINE ( ::PrecioIVAIncluido( ( ::PrecioBase() * ::PorcentajeIVA() / 100 ) + ::PrecioBase() ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( nCosto, nPrecioBase, nPrecioIVAIncluido, nPorcentajeIVA, nMargen ) CLASS CalculaPrecioCommand 

   ::Costo( nCosto )

   ::PrecioBase( nPrecioBase )

   ::PorcentajeIVA( nPorcentajeIVA )   

   ::PrecioIVAIncluido( nPrecioIVAIncluido )    

   ::Margen( nMargen )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Build( hBuilder ) CLASS CalculaPrecioCommand 

   if hhaskey( hBuilder, "Costo" )
      ::Costo( hBuilder[ "Costo" ] )
   end if 

   if hhaskey( hBuilder, "PrecioBase" )
      ::PrecioBase( hBuilder[ "PrecioBase" ] )
   end if 

   if hhaskey( hBuilder, "PorcentajeIVA" )
      ::PorcentajeIVA( hBuilder[ "PorcentajeIVA" ] )
   end if 

   if hhaskey( hBuilder, "PrecioIVAIncluido" )
      ::PrecioIVAIncluido( hBuilder[ "PrecioIVAIncluido" ] )
   end if 

   if hhaskey( hBuilder, "Margen" )
      ::Margen( hBuilder[ "Margen" ] )
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Say()

   local cSay  

   cSay  := "Costo : " + hb_ntos( ::nCosto )                         + CRLF
   cSay  += "Margen : " + hb_ntos( ::nMargen )                       + CRLF
   cSay  += "MargenReal : " + hb_ntos( ::nMargenReal )               + CRLF
   cSay  += "PrecioBase : " + hb_ntos( ::nPrecioBase )               + CRLF
   cSay  += "PorcentajeIVA : " + hb_ntos( ::nPorcentajeIVA )         + CRLF
   cSay  += "PrecioIVAIncluido : " + hb_ntos( ::nPrecioIVAIncluido ) + CRLF

   msgInfo( cSay, "CalculaPrecioCommand" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD caclculaPreciosUsandoMargen()

   ::caclculaPrecioBaseSobreCosto()

   ::caclculaPrecioIVAIncluido()

   ::caclculaMargenReal()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD caclculaPreciosUsandoBase()

   ::caclculaMargen()
   
   ::caclculaMargenReal()

   ::caclculaPrecioIVAIncluido()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD caclculaPreciosUsandoIVAIncluido()

   ::caclculaPrecioBaseSobrePrecioIVA()

   ::caclculaMargen()
   
   ::caclculaMargenReal()

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//