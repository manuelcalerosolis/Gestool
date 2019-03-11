#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ConversorDocumentosController FROM ConversorGenericoController

   METHOD Convert( uuidOrigen )

   METHOD convertDocument()

   METHOD convertDocumentHeader()

   METHOD convertDocumentLines()

   METHOD convertDocumentDiscounts()

   METHOD insertConvertHistory()

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

   ::insertConvertHistory()

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

   ::getModel():insertRelationDocument(   ::uuidDocumentoOrigen,;
                                          ::getOrigenController():getModel():cTableName,;
                                          ::getDestinoController:getModelBuffer( "uuid" ),;
                                          ::getDestinoController():getModel():cTableName )

RETURN ( ::getDestinoController:getModelBuffer( "uuid" ) )

//---------------------------------------------------------------------------//

METHOD convertDocumentLines() CLASS ConversorDocumentosController

   local hLine
   local aLines   
   local uuidLinea

   aLines         := ::getOrigenController():getLinesController():getModel():getHashWhereUuid( ::uuidDocumentoOrigen )

   if empty( aLines )
      RETURN ( nil )
   end if

   for each hLine in aLines

      uuidLinea   := hget( hLine, "uuid" )

      hDels( hLine, { "uuid", "id" } )

      hSet( hLine, "parent_uuid", ::uuidDocumentoDestino )

      ::getDestinoController():getLinesController():getModel():insertBlankBuffer( hLine )

      ::getModel():insertRelationDocument(   uuidLinea,;
                                             ::getOrigenController:getLinesController:getModel():cTableName,;
                                             ::getDestinoController:getLinesController():getModelBuffer( "uuid" ),;
                                             ::getDestinoController():getLinesController():getModel():cTableName )  

   next 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD convertDocumentDiscounts() CLASS ConversorDocumentosController

   local hDiscount
   local aDiscounts
   local uuidDiscount

   aDiscounts        := ::getOrigenController():getDiscountController():getModel():getHashWhereUuid( ::uuidDocumentoOrigen )

   if empty( aDiscounts )
      RETURN ( nil )
   end if

   for each hDiscount in aDiscounts

      uuidDiscount   := hget( hDiscount, "uuid" )

      hDels( hDiscount, { "uuid", "id" } )

      hSet( hDiscount, "parent_uuid", ::uuidDocumentoDestino )

      ::getDestinoController():getDiscountController():getModel():insertBlankBuffer( hDiscount )

      ::getModel():insertRelationDocument(   uuidDiscount,;
                                             ::getOrigenController:getDiscountController:getModel():cTableName,;
                                             ::getDestinoController():getDiscountController():getModelBuffer( "uuid" ),;
                                             ::getDestinoController():getDiscountController():getModel():cTableName )

   next 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD insertConvertHistory()

   ::getHistoryController():getModel():insertConvert( ::uuidDocumentoOrigen, ::oController():getConversorView():cDocumentoDestino )
      
   ::getHistoryController():getModel():insertConvertDestino( ::getDestinoController:getModelBuffer( "uuid" ) )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//