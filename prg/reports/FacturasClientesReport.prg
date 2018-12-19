#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"
#include "HdoCommon.ch"
#include "FastRepH.ch"

//---------------------------------------------------------------------------//

CLASS FacturasClientesReport FROM SQLBaseReport

   DATA oFacturasClientesRowSet

   DATA oFacturasClientesLineasRowSet
   
   DATA oFacturasClientesModel
   
   DATA oFacturasClientesLineasModel

   DATA hTotal

   DATA hTotalByIVA

   METHOD New( oController ) CONSTRUCTOR

   METHOD End()

   METHOD buidSentenceAndRowsetFacturasClientes( uIds )

   METHOD buidSentenceAndRowsetFacturasClientesLineas()

   METHOD buildRowSet() 

   METHOD freeRowSet()

   METHOD setUserDataSet()

   METHOD getFacturasClientesModel()         INLINE ( if( empty( ::oFacturasClientesModel ), ::oFacturasClientesModel := SQLFacturasClientesModel():New( self ), ), ::oFacturasClientesModel )

   METHOD getFacturasClientesLineasModel()   INLINE ( if( empty( ::oFacturasClientesLineasModel ), ::oFacturasClientesLineasModel := SQLFacturasClientesLineasModel():New( self ), ), ::oFacturasClientesLineasModel )

   METHOD getFacturasClientesRowSet()        INLINE ( if( empty( ::oFacturasClientesRowSet ), ::oFacturasClientesRowSet := SQLRowSet():New(), ), ::oFacturasClientesRowSet )

   METHOD getFacturasClientesLineasRowSet()  INLINE ( if( empty( ::oFacturasClientesLineasRowSet ), ::oFacturasClientesLineasRowSet := SQLRowSet():New(), ), ::oFacturasClientesLineasRowSet )

   METHOD getTotalesDocument( uuid )         INLINE ( ::hTotal  := ::getController():getRepository():getTotalesDocument( uuid ) )
   
   METHOD getTotalesDocumentByIVA( uuid )    INLINE ( ::hTotalByIVA  := ::getController():getRepository():getTotalesDocumentGroupByIVA( uuid ) ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::Super:New( oController )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oFacturasClientesModel )
      ::oFacturasClientesModel:End()
   end if

   if !empty( ::oFacturasClientesLineasModel )
      ::oFacturasClientesLineasModel:End()
   end if

   ::freeRowSet()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD buidSentenceAndRowsetFacturasClientes( uuid )

   if empty( uuid )
      ::getFacturasClientesModel():setLimit( 1 )
   else
      ::getFacturasClientesModel():setGeneralWhere( "operaciones_comerciales.uuid = " + quoted( uuid ) )
   end if 

   ::getFacturasClientesRowSet():Build( ::getFacturasClientesModel():getGeneralSelect() )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD buidSentenceAndRowsetFacturasClientesLineas( uuid )

   ::getFacturasClientesLineasModel():setGeneralWhere( "facturas_clientes_lineas.parent_uuid = " + quoted( uuid ) )
   
   ::getFacturasClientesLineasRowSet():Build( ::getFacturasClientesLineasModel():getGeneralSelect() )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD buildRowSet( uuid )

   ::getFacturasClientesRowSet()

   ::getFacturasClientesLineasRowSet()

   ::buidSentenceAndRowsetFacturasClientes( uuid )

   ::buidSentenceAndRowsetFacturasClientesLineas( uuid )

   ::getTotalesDocument( uuid )

   ::getTotalesDocumentByIVA( uuid )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD freeRowSet() 

   if !empty( ::oFacturasClientesRowSet )
      ::oFacturasClientesRowSet:End()
   end if 
   
   if !empty( ::oFacturasClientesLineasRowSet )
      ::oFacturasClientesLineasRowSet:End()
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setUserDataSet() 

   local nRow

   ::oFastReport:ClearDataSets()

   ::oFastReport:setUserDataSet(    "Factura",;
                                    ::getFacturasClientesModel():getSerializeColumnsSelect(),;
                                    {|| ::oFacturasClientesRowSet:gotop() },;
                                    {|| ::oFacturasClientesRowSet:skip( 1 ) },;
                                    {|| ::oFacturasClientesRowSet:skip( -1 ) },;
                                    {|| ::oFacturasClientesRowSet:eof() },;
                                    {|cField| ::oFacturasClientesRowSet:fieldGet( cField ) } )

   ::oFastReport:setUserDataSet(   "Líneas",;
                                    ::getFacturasClientesLineasModel():getSerializeColumnsSelect(),;
                                    {|| ::oFacturasClientesLineasRowSet:gotop() },;
                                    {|| ::oFacturasClientesLineasRowSet:skip( 1 ) },;
                                    {|| ::oFacturasClientesLineasRowSet:skip( -1 ) },;
                                    {|| ::oFacturasClientesLineasRowSet:eof() },;
                                    {|cField| ::oFacturasClientesLineasRowSet:fieldGet( cField ) } )

   ::oFastReport:setUserDataSet(   "Totales",;
                                    serializeArray( hgetKeys( ::hTotal ), ";" ),;
                                    {|| nil },;
                                    {|| nil },;
                                    {|| nil },;
                                    {|| nil },;
                                    {|cField| hget( ::hTotal, cField ) } )

   msgalert( valtype( ::hTotalByIVA ), "hTotalByIVA" )

   ::oFastReport:setUserDataSet(   "Totales por impuestos ",;
                                    serializeArray( hgetKeys( ::hTotal ), ";" ),;
                                    {|| nRow := 1 },;
                                    {|| nRow++ },;
                                    {|| nRow-- },;
                                    {|| nRow > len( ::hTotalByIVA ) },;
                                    {|cField| hget( ::hTotalByIVA[ nRow ], cField ) } )


RETURN ( nil )

//---------------------------------------------------------------------------//

