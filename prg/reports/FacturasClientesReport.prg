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

   METHOD New( oController ) CONSTRUCTOR

   METHOD End()

   METHOD buidSentenceAndRowsetFacturasClientes( uIds )

   METHOD buidSentenceAndRowsetFacturasClientesLineas()

   METHOD buildRowSet() 

   METHOD freeRowSet()

   METHOD setUserDataSet()

   METHOD Synchronize() 

   METHOD getFacturasClientesModel()         INLINE ( if( empty( ::oFacturasClientesModel ), ::oFacturasClientesModel := SQLFacturasClientesModel():New( self ), ), ::oFacturasClientesModel )

   METHOD getFacturasClientesLineasModel()   INLINE ( if( empty( ::oFacturasClientesLineasModel ), ::oFacturasClientesLineasModel := SQLFacturasClientesLineasModel():New( self ), ), ::oFacturasClientesLineasModel )

   METHOD getFacturasClientesRowSet()        INLINE ( if( empty( ::oFacturasClientesRowSet ), ::oFacturasClientesRowSet := SQLRowSet():New(), ), ::oFacturasClientesRowSet )

   METHOD getFacturasClientesLineasRowSet()  INLINE ( if( empty( ::oFacturasClientesLineasRowSet ), ::oFacturasClientesLineasRowSet := SQLRowSet():New(), ), ::oFacturasClientesLineasRowSet )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::Super:New( oController )

   ::getFacturasClientesModel()

   ::getFacturasClientesLineasModel()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oFacturasClientesModel )
      ::oFacturasClientesModel:End()
   end if

   if !empty( ::oFacturasClientesLineasModel )
      ::oFacturasClientesLineasModel:End()
   end if

   msgalert( "destruido")

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD buidSentenceAndRowsetFacturasClientes( uIds )

   if empty( uIds )
      ::oFacturasClientesModel:setLimit( 1 )
   else
      ::oFacturasClientesModel:setGeneralWhere( "facturas_clientes.id = " + hb_ntos( uIds ) )
   end if 

   msgalert( ::oFacturasClientesModel:getGeneralSelect(), "facturas" )

   ::oFacturasClientesRowSet:Build( ::oFacturasClientesModel:getGeneralSelect() )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD buidSentenceAndRowsetFacturasClientesLineas()

   ::oFacturasClientesLineasModel:setGeneralWhere( "facturas_clientes_lineas.parent_uuid = " + quoted( ::oFacturasClientesRowSet:fieldget( "uuid" ) ) )
   
   ::oFacturasClientesLineasModel:setGroupBy( "facturas_clientes_lineas.id" ) 

   msgalert( ::oFacturasClientesLineasModel:getGeneralSelect(), "lineas" )

   ::oFacturasClientesLineasRowSet:Build( ::oFacturasClientesLineasModel:getGeneralSelect() )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD buildRowSet( uIds )

   ::getFacturasClientesRowSet()

   ::getFacturasClientesLineasRowSet()

   ::buidSentenceAndRowsetFacturasClientes( uIds )

   ::buidSentenceAndRowsetFacturasClientesLineas()

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

   ::oFastReport:ClearDataSets()

   ::oFastReport:setUserDataSet(    "Facturas de clientes",;
                                    SQLFacturasClientesModel():getSerializeColumnsSelect(),;
                                    {|| ::oFacturasClientesRowSet:gotop() },;
                                    {|| ::oFacturasClientesRowSet:skip( 1 ) },;
                                    {|| ::oFacturasClientesRowSet:skip( -1 ) },;
                                    {|| ::oFacturasClientesRowSet:eof() },;
                                    {|cField| ::oFacturasClientesRowSet:fieldGet( cField ) } )

   ::oFastReport:setUserDataSet(   "Líneas de facturas de clientes",;
                                    SQLFacturasClientesLineasModel():getSerializeColumnsSelect(),;
                                    {|| ::oFacturasClientesLineasRowSet:gotop() },;
                                    {|| ::oFacturasClientesLineasRowSet:skip( 1 ) },;
                                    {|| ::oFacturasClientesLineasRowSet:skip( -1 ) },;
                                    {|| ::oFacturasClientesLineasRowSet:eof() },;
                                    {|cField| ::oFacturasClientesLineasRowSet:fieldGet( cField ) } )

   ::oFastReport:SetMasterDetail(   "Facturas de clientes",;
                                    "Líneas de facturas de clientes",;
                                    {|| ::synchronize() } )

   ::oFastReport:SetResyncPair(    "Facturas de clientes", "Líneas de facturas de clientes" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Synchronize() 

   msgalert( ::oFacturasClientesRowSet:fieldget( "uuid" ), "uuid" )

RETURN ( nil )

//---------------------------------------------------------------------------//


