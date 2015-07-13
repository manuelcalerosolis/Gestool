#include "FiveWin.Ch"
#include "Factu.ch" 
 
CLASS Iva 

   Data aIva                                       
   Data hIva
   Data oSender
   Data SumImporte                                 
   Data SumTotal                                   

   METHOD New()
   METHOD Reset()

   METHOD add()

   METHOD getTipoIva( hIva )                       INLINE ( hGet( hIva, "PorcentajeImpuesto" ) )

   METHOD setValue( nPosition, Field, Value )      INLINE ( hSet( ::aIva[ nPosition ], Field, Value ) )

   METHOD getBase( nPosition )                     INLINE ( hGet( ::aIva[ nPosition ], "Base" ) )
   METHOD getBaseHash( hIva )                      INLINE ( hGet( hIva, "Base" ) )

   METHOD setBase( nPosition, nValue )             INLINE ( ::setValue( nPosition, "Base", nValue ) )
   METHOD sumBase( nPosition, nValue )             INLINE ( ::setBase( nPosition, ::getBase( nPosition ) + nValue ) )

   METHOD getPorcentajeImpuesto( nPosition )       INLINE ( hGet( ::aIva[ nPosition ], "PorcentajeImpuesto" ) )
   METHOD getImporteImpuesto( nPosition )          INLINE ( hGet( ::aIva[ nPosition ], "ImporteImpuesto" ) )
   METHOD getPorcentajeRecargo( nPosition )        INLINE ( hGet( ::aIva[ nPosition ], "PorcentajeRecargo" ) )
   METHOD getImporteRecargo( nPosition )           INLINE ( hGet( ::aIva[ nPosition ], "ImporteRecargo" ) )
   METHOD getTotal( nPosition )                    INLINE ( hGet( ::aIva[ nPosition ], "Total" ) )

   METHOD ShowBase( nPosition )                    INLINE ( Trans( ::getBase( nPosition ), cPorDiv() ) )
   METHOD ShowPorcentajes( nPosition )
   METHOD ShowImportes( nPosition )
   METHOD ShowTotal( nPosition )

   METHOD addIva( oDocumentLine )
   METHOD sumIva( oDocumentLine, nPosition )

   METHOD ImporteImpuesto( nPosition )
   METHOD ImporteRecargo( nPosition )
   METHOD CalculaTotal( nPosition )

   METHOD TotalBase()
   METHOD TotalImporte()
   METHOD transTotalImporte()                      INLINE ( Trans( ::TotalImporte(), cPorDiv() ) )
   METHOD TotalTotales()
   METHOD transTotalTotales()                      INLINE ( Trans( ::TotalTotales, cPorDiv() ) )


END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender )

   ::oSender      := oSender
   ::aIva         := {}

   ::SumImporte   := 00
   ::SumTotal     := 00

Return( Self )

//---------------------------------------------------------------------------//

METHOD Reset()

   ::aIva         := {}
   ::SumImporte   := 00
   ::SumTotal     := 00

Return( Self )

//---------------------------------------------------------------------------//

METHOD add( oDocumentLine )

   local nPosition

   nPosition      := aScan( ::aIva, {|hIva| oDocumentLine:getPorcentajeImpuesto() == ::getTipoIva( hIva ) } )

   if nPosition != 0
      ::sumIva( oDocumentLine, nPosition )
   else
      ::addIva( oDocumentLine )
   end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD addIva( oDocumentLine )

   Local hHash

   hHash    := {  "Base" => oDocumentLine:Total(),;
                  "PorcentajeImpuesto" => oDocumentLine:getPorcentajeImpuesto(),;
                  "PorcentajeRecargo" => oDocumentLine:getRecargoEquivalencia() }

   AADD( ::aIva, hHash )

Return( Self )

//---------------------------------------------------------------------------//

METHOD sumIva( oDocumentLine, nPosition )

   local hHash

   if !( nPosition > 0 .and. nPosition <= len( ::aIva ) )
      Return( self )
   end if 

   ::sumBase( nPosition, oDocumentLine:total() )

Return( Self )

//---------------------------------------------------------------------------//

//---------------------------------------------------------------------------//

METHOD ImporteImpuesto( nPosition )

   Local ImporteImpuesto      := 0

   if ::getPorcentajeImpuesto( nPosition ) !=0
      ImporteImpuesto         := ( ::getBase( nPosition ) * ::getPorcentajeImpuesto( nPosition ) ) / 100
   endif

   ::SumImporte               += ImporteImpuesto

Return( ImporteImpuesto )

//---------------------------------------------------------------------------//

METHOD ImporteRecargo( nPosition )

   Local ImporteRecargo    := 0

   if ::getPorcentajeRecargo( nPosition ) != 0
      ImporteRecargo       := ( ::getBase( nPosition ) * ::getPorcentajeRecargo( nPosition ) ) / 100
   endif

   ::SumImporte               += ImporteRecargo

Return( ImporteRecargo )

//---------------------------------------------------------------------------//

METHOD CalculaTotal( nPosition )

   Local CalculaTotal      := 0

   CalculaTotal            := ::getBase( nPosition ) + ::ImporteRecargo( nPosition ) + ::ImporteImpuesto( nPosition )

   //::SumTotal              += CalculaTotal

Return( CalculaTotal )

//---------------------------------------------------------------------------//

METHOD ShowPorcentajes( nPosition )

   Local Porcentaje := ""

   if !IsNil( ::getPorcentajeImpuesto( nPosition ) )
      Porcentaje += Trans( ::getPorcentajeImpuesto( nPosition ), "@E 999.99" )
   endif

   Porcentaje += CRLF

   if !IsNil( ::getPorcentajeRecargo( nPosition ) )
      Porcentaje += Trans( ::getPorcentajeRecargo( nPosition ), "@E 999.99")
   endif

Return( Porcentaje )

//---------------------------------------------------------------------------//

METHOD ShowImportes( nPosition )

   Local Importe := ""

   if !IsNil( ::ImporteImpuesto( nPosition ) )
      Importe += Trans( ::ImporteImpuesto( nPosition ), cPorDiv() )
   endif

   Importe += CRLF 

   if !IsNil( ::ImporteRecargo( nPosition ) )
      Importe += Trans( ::ImporteRecargo( nPosition ), cPorDiv() )
   endif

Return( Importe )

//---------------------------------------------------------------------------//

METHOD ShowTotal( nPosition )

   Local Total := ""

   if !IsNil( ::CalculaTotal( nPosition ) )
      Total := Trans( ::CalculaTotal( nPosition ), cPorDiv() )
   endif

Return( Total )

//---------------------------------------------------------------------------//

METHOD TotalBase()

   Local TotalBase := 0

   aeval( ::aIva, {|hIva| TotalBase += hGet( hIva, "Base" ) } ) 

Return( Trans( TotalBase, cPorDiv() )  )

//---------------------------------------------------------------------------//

METHOD TotalImporte()

   local TotalImporte   := 0

   aeval(::aIva, {|hIva, nPosition| TotalImporte += ::ImporteImpuesto( nPosition )  })

Return ( TotalImporte )

//---------------------------------------------------------------------------//

METHOD TotalTotales()

   local TotalTotales   := 0

   aeval(::aIva, {|hIva, nPosition| TotalTotales += ::CalculaTotal( nPosition )  })

Return ( TotalTotales )

//---------------------------------------------------------------------------//
