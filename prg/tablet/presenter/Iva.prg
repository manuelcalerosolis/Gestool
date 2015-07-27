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

   METHOD getBase( nPosition )                     INLINE ( hGet( ::aIva[ nPosition ], "Base" ) )
   METHOD getBaseHash( hIva )                      INLINE ( hGet( hIva, "Base" ) )

   METHOD setBase( nPosition, nValue )             INLINE ( ::setValue( nPosition, "Base", nValue ) )
   METHOD sumBase( nPosition, nValue )             INLINE ( ::setBase( nPosition, ::getBase( nPosition ) + nValue ) )

   METHOD getPorcentajeImpuesto( nPosition )       INLINE ( hGet( ::aIva[ nPosition ], "PorcentajeImpuesto" ) )
   METHOD getImporteImpuesto( nPosition )          INLINE ( hGet( ::aIva[ nPosition ], "ImporteImpuesto" ) )
   METHOD getPorcentajeRecargo( nPosition )        INLINE ( hGet( ::aIva[ nPosition ], "PorcentajeRecargo" ) )
   METHOD getImporteRecargo( nPosition )           INLINE ( hGet( ::aIva[ nPosition ], "ImporteRecargo" ) )
   METHOD getTotal( nPosition )                    INLINE ( hGet( ::aIva[ nPosition ], "Total" ) )

   METHOD addIva( oDocumentLine )

   METHOD ImporteImpuesto( nPosition )
   METHOD ImporteRecargo( nPosition )
   METHOD CalculaTotal( nPosition )

   METHOD ShowPorcentajes( nPosition )
   METHOD ShowImportes( nPosition )
   METHOD ShowTotal( nPosition )

   METHOD getDictionaryMaster( cField )            INLINE ( hGet( ::oSender:oSender:hDictionaryMaster, cField ) )

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

   local nPositionR
   local nPosition

   nPosition      := aScan( ::aIva, {|hIva| oDocumentLine:getPorcentajeImpuesto() == ::getTipoIva( hIva ) .and. oDocumentLine:getRecargoEquivalencia() == ::getTipoRecargo( hIva ) } )

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

   Local ImporteImpuesto      := 0

   if ::getPorcentajeImpuesto( nPosition ) !=0
      ImporteImpuesto         := ( ::getBase( nPosition ) * ::getPorcentajeImpuesto( nPosition ) ) / 100
   endif

Return( ImporteImpuesto )

//---------------------------------------------------------------------------//

METHOD ImporteRecargo( nPosition )

   Local ImporteRecargo    := 0

   if !( ::getDictionaryMaster( "RecargoEquivalencia" ) )
      Return ImporteRecargo    
   endif

   if ::getPorcentajeRecargo( nPosition ) != 0
      ImporteRecargo       := ( ::getBase( nPosition ) * ::getPorcentajeRecargo( nPosition ) ) / 100
   endif

Return( ImporteRecargo )

//---------------------------------------------------------------------------//

METHOD CalculaTotal( nPosition )

   Local CalculaTotal      := 0

   CalculaTotal            := ::getBase( nPosition ) 
   CalculaTotal            += ::ImporteImpuesto( nPosition )
   CalculaTotal            += ::ImporteRecargo( nPosition ) 

Return( CalculaTotal )

//---------------------------------------------------------------------------//

METHOD ShowPorcentajes( nPosition )

   Local Porcentaje := ""

   if !IsNil( ::getPorcentajeImpuesto( nPosition ) )
      Porcentaje  += Trans( ::getPorcentajeImpuesto( nPosition ), "@E 999.99" )
   endif

   Porcentaje     += CRLF

   if !( ::getDictionaryMaster( "RecargoEquivalencia" ) )
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

   if !( ::getDictionaryMaster( "RecargoEquivalencia" ) )
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

