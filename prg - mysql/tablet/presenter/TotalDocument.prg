#include "FiveWin.Ch"
#include "Factu.ch" 
 
CLASS TotalDocument 

   DATA oIva
   DATA oSender

   METHOD New( oSender )
   METHOD Calculate()

   METHOD getBruto()      
   METHOD transBruto()                             INLINE ( Trans( ::getBruto(), cPorDiv() ) )

   METHOD getBase()                                
   METHOD transBase()                              INLINE ( Trans( ::getBase(), cPorDiv() ) )
   
   METHOD getDescuento()                           
   METHOD transDescuento()                         INLINE ( Trans( ::getDescuento(), cPorDiv() ) )

   METHOD getImporteIva() 
   METHOD transImporteIva()                        INLINE ( Trans( ::getImporteIva(), cPorDiv() ) ) 

   METHOD getImporteRecargo()
   METHOD transImporteRecargo()                    INLINE ( Trans( ::getImporteRecargo(), cPorDiv() ) )
   METHOD transPrice()

   METHOD getTotalDocument()
   METHOD transTotalDocument()                     INLINE ( Trans( ::getTotalDocument(), cPorDiv() ) )

   METHOD Reset()                                  INLINE ( ::oIva:Reset() )

   METHOD showBrutoIVA( nPosition )                INLINE ( ::oIva:showBruto( nPosition ) )
   METHOD showBaseIVA( nPosition )                 INLINE ( ::oIva:showBase( nPosition ) )
   METHOD showPorcentajesIVA( nPosition )          INLINE ( ::oIva:showPorcentajes( nPosition ) )
   METHOD showImportesIVA( nPosition )             INLINE ( ::oIva:showImportes( nPosition ) )
   METHOD showTotalIVA( nPosition )                INLINE ( ::oIva:showTotal( nPosition ) )
 
END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS TotalDocument

   ::oSender      := oSender

   ::oIva         := Iva():New( oSender )

Return( Self )

//---------------------------------------------------------------------------//

METHOD Calculate() CLASS TotalDocument

   local oDocumentLine

   ::Reset()

   for each oDocumentLine in ::oSender:oDocumentLines:aLines
      ::oIva:add( oDocumentLine )
   next

Return ( Self )

//---------------------------------------------------------------------------//

METHOD getBase() CLASS TotalDocument

   Local Base           := 0

   aeval( ::oIva:aIva, {|hIva, nPosition| Base += ::oIva:Base( nPosition ) } )

Return( Base )

//---------------------------------------------------------------------------//

METHOD getBruto() CLASS TotalDocument

   Local Bruto          := 0

   aeval( ::oIva:aIva, {|hIva, nPosition| Bruto += ::oIva:Bruto( nPosition ) } )

Return( Bruto )

//---------------------------------------------------------------------------//


METHOD getImporteIva() CLASS TotalDocument

   local TotalImporteIVA   := 0

   aeval( ::oIva:aIva, {|hIva, nPosition| TotalImporteIVA += ::oIva:ImporteImpuesto( nPosition ) } )

Return ( TotalImporteIVA )

//---------------------------------------------------------------------------//

METHOD getImporteRecargo() CLASS TotalDocument

   local TotalImporteRecargo     := 0

   aeval( ::oIva:aIva, {|hIva, nPosition| TotalImporteRecargo += ::oIva:ImporteRecargo( nPosition ) } )

Return ( TotalImporteRecargo )

//---------------------------------------------------------------------------//

METHOD getTotalDocument() CLASS TotalDocument

   local TotalDocument

   TotalDocument        := ::getBase()
   TotalDocument        += ::getImporteIva()
   TotalDocument        += ::getImporteRecargo()

Return ( TotalDocument )

//---------------------------------------------------------------------------//

METHOD getDescuento()

   local Descuento      := 0

   if !empty( ::oSender:hGetMaster( "PorcentajeDescuento1" ) )
      Descuento         := ::getBruto() * ::oSender:hGetMaster( "PorcentajeDescuento1" ) / 100
   end if 

Return ( Descuento )

//---------------------------------------------------------------------------//

METHOD transPrice() CLASS TotalDocument

   Local transImporte 

   transImporte         := ::getImporteIva()

   if ::oIva:getValueMaster( "RecargoEquivalencia" )
      transImporte      += ::getImporteRecargo()
   endif

Return( Trans( transImporte, cPorDiv() ) )

//---------------------------------------------------------------------------//
