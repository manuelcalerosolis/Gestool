#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ConversorDocumentosController FROM ConversorGenericoController

   METHOD Convert( uuidOrigen )

   METHOD convertDocument()

   METHOD convertDocumentHeader()

   METHOD convertDocumentLines()

   METHOD convertDocumentDiscounts()

END CLASS

//---------------------------------------------------------------------------//

METHOD Convert( uuidOrigen ) CLASS ConversorDocumentosController

   if empty( ::getOrigenController() )
      RETURN ( nil )
   end if

   if empty( ::getDestinoController() )
      RETURN ( nil )
   end if

   if ::getOrigenController:className() == ::getDestinoController():className()
      RETURN ( nil )
   end if

   ::uuidDocumentoOrigen     := uuidOrigen

   if empty( ::uuidDocumentoOrigen )
      RETURN( nil )
   end if

   if ::getModel():countDocumentoWhereUuidOigenAndTableDestino( ::uuidDocumentoOrigen, ::getDestinoController():getModel():cTableName ) > 0
      msgstop( "El documento seleccionado ya ha sido convertido" )
      RETURN ( nil )
   end if

   ::convertDocument()

   ::getDestinoController():Edit( ::getDestinoController():getModel():getIdWhereUuid( ::uuidDocumentoDestino ) )

RETURN ( nil )   

//---------------------------------------------------------------------------//

METHOD convertDocument() CLASS ConversorDocumentosController

   ::uuidDocumentoDestino              := ::convertDocumentHeader()

   ::convertDocumentLines()

   ::convertDocumentDiscounts()
   

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD convertDocumentHeader() CLASS ConversorDocumentosController

   local hHeader   := ::getOrigenController:getModel():getHashWhere( "uuid", ::uuidDocumentoOrigen )

   hDels( hHeader, { "uuid", "id", "numero" } )

   if empty( ::getDestinoController():getModel():insertBlankBuffer( hHeader ) )
      RETURN ( nil )
   end if 

   ::getModel():insertRelationDocument( ::uuidDocumentoOrigen,;
                                        ::getOrigenController():getModel():cTableName,;
                                        ::getDestinoController:getModelBuffer( "uuid" ),;
                                        ::getDestinoController():getModel():cTableName )

   ::getHistoryController():getModel():insertConvert( ::uuidDocumentoOrigen, ::oController():getConversorView():cDocumentoDestino )
      
   ::getHistoryController():getModel():insertConvertDestino( ::getDestinoController:getModelBuffer( "uuid" ) )

RETURN ( ::getDestinoController:getModelBuffer( "uuid" ) )

//---------------------------------------------------------------------------//

METHOD convertDocumentLines() CLASS ConversorDocumentosController

   local hLine
   local uuidLineaOrigen
   local aLines   := ::getOrigenController():getLinesController():getModel():getHashWhereUuid( ::uuidDocumentoOrigen )

   if empty( aLines )
      RETURN ( nil )
   end if

   for each hLine in aLines

      uuidLineaOrigen                  := hget( hLine, "uuid" )

      hDels( hLine, { "uuid", "id" } )

      hSet( hLine, "parent_uuid", ::uuidDocumentoDestino )

      ::getDestinoController():getLinesController():getModel():insertBlankBuffer( hLine )

      ::getModel():insertRelationDocument( uuidLineaOrigen,;
                                           ::getOrigenController:getLinesController:getModel():cTableName,;
                                           ::getDestinoController:getLinesController():getModelBuffer( "uuid" ),;
                                           ::getDestinoController():getLinesController():getModel():cTableName )  

   next 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD convertDocumentDiscounts() CLASS ConversorDocumentosController

   local hDiscount
   local uuidDiscountOrigen
   local aDiscounts   := ::getOrigenController():getDiscountController():getModel():getHashWhereUuid( ::uuidDocumentoOrigen )

   if empty( aDiscounts )
      RETURN ( nil )
   end if

   for each hDiscount in aDiscounts

      uuidDiscountOrigen                  := hget( hDiscount, "uuid" )

      hDels( hDiscount, { "uuid", "id" } )

      hSet( hDiscount, "parent_uuid", ::uuidDocumentoDestino )

      ::getDestinoController():getDiscountController():getModel():insertBlankBuffer( hDiscount )

      ::getModel():insertRelationDocument( uuidDiscountOrigen,;
                                           ::getOrigenController:getDiscountController:getModel():cTableName,;
                                           ::getDestinoController():getDiscountController():getModelBuffer( "uuid" ),;
                                           ::getDestinoController():getDiscountController():getModel():cTableName )

   next 

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//