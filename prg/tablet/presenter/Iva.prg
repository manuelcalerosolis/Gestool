#include "FiveWin.Ch"
#include "Factu.ch" 
 
CLASS Iva 

   Data aIva                                       
   Data hIva
   Data oSender

   METHOD New()
   METHOD Reset()

   METHOD add()

   METHOD getTipoIva( hIva )                       INLINE ( hGet( hIva, "PorcentajeImpuesto" ) )
   METHOD getTipoRecargo( hIva )                   INLINE ( hGet( hIva, "PorcentajeRecargo" ) )

   METHOD setValue( nPosition, Field, Value )      INLINE ( hSet( ::aIva[ nPosition ], Field, Value ) )

   METHOD getBaseArray( nPosition )                INLINE ( hGet( ::aIva[ nPosition ], "Base" ) )
   METHOD getBaseHash( hIva )                      INLINE ( hGet( hIva, "Base" ) )

   METHOD Base( nPosition )

   METHOD setBase( nPosition, nValue )             INLINE ( ::setValue( nPosition, "Base", nValue ) )
   METHOD sumBase( nPosition, nValue )             INLINE ( ::setBase( nPosition, ::getBaseArray( nPosition ) + nValue ) )

   METHOD getPorcentajeImpuesto( nPosition )       INLINE ( hGet( ::aIva[ nPosition ], "PorcentajeImpuesto" ) )
   METHOD getImporteImpuesto( nPosition )          INLINE ( hGet( ::aIva[ nPosition ], "ImporteImpuesto" ) )
   METHOD getPorcentajeRecargo( nPosition )        INLINE ( hGet( ::aIva[ nPosition ], "PorcentajeRecargo" ) )
   METHOD getImporteRecargo( nPosition )           INLINE ( hGet( ::aIva[ nPosition ], "ImporteRecargo" ) )
   METHOD getTotal( nPosition )                    INLINE ( hGet( ::aIva[ nPosition ], "Total" ) )

   METHOD addIva( oDocumentLine )

   METHOD ImporteImpuesto( nPosition )
   METHOD ImporteRecargo( nPosition )
   METHOD CalculaTotal( nPosition )

   METHOD ShowBase( nPosition )
   METHOD ShowPorcentajes( nPosition )
   METHOD ShowImportes( nPosition )
   METHOD ShowTotal( nPosition )

   METHOD getValueMaster( cField )                 INLINE ( hGet( ::oSender:oSender:hDictionaryMaster, cField ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender )

   ::oSender      := oSender
   ::aIva         := {}

Return( Self )

//---------------------------------------------------------------------------//

METHOD Reset()

   ::aIva         := {}

Return( Self )

//---------------------------------------------------------------------------//

METHOD add( oDocumentLine )

   local nPosition

   nPosition      := aScan( ::aIva, {|hIva| oDocumentLine:getPercentageTax() == ::getTipoIva( hIva ) .and. oDocumentLine:getRecargoEquivalencia() == ::getTipoRecargo( hIva ) } )

   if nPosition != 0
      ::sumBase( nPosition, oDocumentLine:Total() )
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
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD ImporteImpuesto( nPosition )

   Local ImporteImpuesto         := 0

   if ::getPorcentajeImpuesto( nPosition ) !=0
      if ::getValueMaster( "ImpuestosIncluidos" )
         ImporteImpuesto         := ::getBaseArray( nPosition ) - ( ::getBaseArray( nPosition ) / ( 1 + ::getPorcentajeImpuesto( nPosition ) / 100 ) )
      else
         ImporteImpuesto         := ( ::getBaseArray( nPosition ) * ::getPorcentajeImpuesto( nPosition ) ) / 100
      endif

   endif

Return( ImporteImpuesto )

//---------------------------------------------------------------------------//

METHOD ImporteRecargo( nPosition )

   Local ImporteRecargo       := 0

   if !( ::getValueMaster( "RecargoEquivalencia" ) )
      Return ImporteRecargo    
   endif

   if ::getPorcentajeRecargo( nPosition ) != 0
      if ::getValueMaster( "ImpuestosIncluidos" )
         ImporteRecargo       := ::getBaseArray( nPosition ) - ( ::getBaseArray( nPosition ) / ( 1 + ::getPorcentajeRecargo( nPosition ) / 100 ) )
      else
         ImporteRecargo       := ( ::getBaseArray( nPosition ) * ::getPorcentajeRecargo( nPosition ) ) / 100
      endif
   endif

Return( ImporteRecargo )

//---------------------------------------------------------------------------//

METHOD Base( nPosition )

   Local Base     := ::getBaseArray( nPosition )

   if ::getValueMaster( "ImpuestosIncluidos" )
      Base        -= ::ImporteImpuesto( nPosition )
      if ( ::getValueMaster( "RecargoEquivalencia" ) )
         Base     -= ::ImporteRecargo( nPosition )
      endif        
   endif

Return( Base )

//---------------------------------------------------------------------------//

METHOD CalculaTotal( nPosition )

   Local CalculaTotal      := 0

   CalculaTotal            := ::Base( nPosition ) 
   CalculaTotal            += ::ImporteImpuesto( nPosition )
   CalculaTotal            += ::ImporteRecargo( nPosition ) 

Return( CalculaTotal )

//---------------------------------------------------------------------------//

METHOD ShowBase( nPosition )

   Local Base := ""

   if !IsNil( ::Base( nPosition ) )
      Base := Trans( ::Base( nPosition ), cPorDiv() )
   endif

Return( Base )

//---------------------------------------------------------------------------//

METHOD ShowPorcentajes( nPosition )

   Local Porcentaje := ""

   if !IsNil( ::getPorcentajeImpuesto( nPosition ) )
      Porcentaje  += Trans( ::getPorcentajeImpuesto( nPosition ), "@E 999.99" )
   endif

   Porcentaje     += CRLF

   if !( ::getValueMaster( "RecargoEquivalencia" ) )
      Return Porcentaje
   else
      if !IsNil( ::getPorcentajeRecargo( nPosition ) )
         Porcentaje += Trans( ::getPorcentajeRecargo( nPosition ), "@E 999.99")
      endif
   endif

Return( Porcentaje )

//---------------------------------------------------------------------------//

METHOD ShowImportes( nPosition )

   Local Importe := ""

   if !IsNil( ::ImporteImpuesto( nPosition ) )
      Importe += Trans( ::ImporteImpuesto( nPosition ), cPorDiv() )
   endif

   Importe += CRLF 

   if !( ::getValueMaster( "RecargoEquivalencia" ) )
      Return Importe
   else
      if !IsNil( ::ImporteRecargo( nPosition ) )
         Importe += Trans( ::ImporteRecargo( nPosition ), cPorDiv() )
      endif
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

