#include "FiveWin.Ch"
#include "Factu.ch" 
 
CLASS TotalDocument 

   DATA oIva
   DATA oSender

   DATA Bruto                                      INIT 0

   METHOD New( oSender )
   METHOD Calculate()

   METHOD getBruto()                               INLINE ( ::Bruto )
   METHOD getBase()                                //INLINE ( ::getBruto() )
   METHOD transBase()                              INLINE ( Trans( ::getBase(), cPorDiv() ) )
   METHOD getDescuento()                           INLINE ( 0 )
   METHOD transDescuento()                         INLINE ( Trans( ::getDescuento, cPorDiv() ) )
   METHOD getImporteIva() 
   METHOD transImporteIva()                        INLINE ( Trans( ::getImporteIva(), cPorDiv() ) ) 
   METHOD getImporteRecargo()
   METHOD transImporteRecargo()                    INLINE ( Trans( ::getImporteRecargo(), cPorDiv() ) )
   METHOD transImporte()
   METHOD getTotalDocument()
   METHOD transTotalDocument()                     INLINE ( Trans( ::getTotalDocument, cPorDiv() ) )

   METHOD Reset()                                  INLINE ( ::Bruto := 0, ::oIva:Reset() )

   METHOD showBaseIVA( nPosition )                 INLINE ( ::oIva:ShowBase( nPosition ) )
   METHOD ShowPorcentajesIVA( nPosition )          INLINE ( ::oIva:ShowPorcentajes( nPosition ) )
   METHOD ShowImportesIVA( nPosition )             INLINE ( ::oIva:ShowImportes( nPosition ) )
   METHOD ShowTotalIVA( nPosition )                INLINE ( ::oIva:ShowTotal( nPosition ) )
 
END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS TotalDocument

   ::oSender      := oSender
   ::oIva         := Iva():New( Self )

Return( Self )

//---------------------------------------------------------------------------//

METHOD Calculate() CLASS TotalDocument

   Local oDocumentLine

   ::Reset()

   for each oDocumentLine in ::oSender:oDocumentLines:aLines
      
      ::Bruto  += oDocumentLine:Total()

      ::oIva:add( oDocumentLine )

   next

Return ( Self )

//---------------------------------------------------------------------------//

METHOD getBase() CLASS TotalDocument

   Local TotalBase         := 0

   aeval( ::oIva:aIva, {|hIva, nPosition| TotalBase += ::oIva:Base( nPosition ) } )

Return( TotalBase )

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

METHOD transImporte() CLASS TotalDocument

   Local transImporte := ""

   transImporte := ::getImporteIva()

   if ::oIva:getDictionaryMaster( "RecargoEquivalencia" )
      transImporte += ::getImporteRecargo()
   endif

Return( Trans( transImporte, cPorDiv() ) )
