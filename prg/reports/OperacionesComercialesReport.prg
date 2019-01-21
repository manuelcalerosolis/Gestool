#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"
#include "HdoCommon.ch"
#include "FastRepH.ch"

//---------------------------------------------------------------------------//

CLASS OperacionesComercialesReport FROM SQLBaseReport

   DATA oDocumentRowSet

   DATA oLinesRowSet
   
   DATA oDocumentModel
   
   DATA oLinesModel

   DATA hTotal

   DATA aTotalsByIVA

   METHOD New( oController )           CONSTRUCTOR

   METHOD End()

   METHOD getDocumentModel()           VIRTUAL

   METHOD getLinesModel()              VIRTUAL

   METHOD setLinesGeneralWhere( uuid ) VIRTUAL

   METHOD buidSentenceAndRowSetDocument( uIds )

   METHOD buidSentenceAndRowSetLines()

   METHOD buildRowSet() 

   METHOD freeRowSet()

   METHOD setUserDataSet()

   METHOD getDocumentRowSet()          INLINE ( if( empty( ::oDocumentRowSet ), ::oDocumentRowSet := SQLRowSet():New(), ), ::oDocumentRowSet )

   METHOD getLinesRowSet()             INLINE ( if( empty( ::oLinesRowSet ), ::oLinesRowSet := SQLRowSet():New(), ), ::oLinesRowSet )

   METHOD getTotalesDocument( uuid )   INLINE ( ::hTotal := ::getController():getRepository():getTotalesDocument( uuid ) )
   
   METHOD getTotalesDocumentByIVA( uuid ) INLINE ( ::aTotalsByIVA := ::getController():getRepository():getTotalesDocumentGroupByIVA( uuid ) ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::Super:New( oController )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oDocumentModel )
      ::oDocumentModel:End()
   end if

   if !empty( ::oLinesModel )
      ::oLinesModel:End()
   end if

   ::freeRowSet()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD buidSentenceAndRowSetDocument( uuid )

   if empty( uuid )
      ::getDocumentModel():setLimit( 1 )
   else
      ::getDocumentModel():setGeneralWhere( ::getDocumentModel():cTableName + ".uuid = " + quoted( uuid ) )
   end if 

RETURN ( ::getDocumentRowSet():Build( ::getDocumentModel():getGeneralSelect() ) )

//---------------------------------------------------------------------------//

METHOD buidSentenceAndRowSetLines( uuid )

   ::getLinesModel():setGeneralWhere( ::getLinesModel():cTableName + ".parent_uuid = " + quoted( uuid ) )

RETURN ( ::getLinesRowSet():Build( ::getLinesModel():getGeneralSelect() ) )

//---------------------------------------------------------------------------//

METHOD buildRowSet( uuid )

   ::getDocumentRowSet()

   ::getLinesRowSet()

   ::buidSentenceAndRowSetDocument( uuid )

   ::buidSentenceAndRowSetLines( uuid )

   ::getTotalesDocument( uuid )

   ::getTotalesDocumentByIVA( uuid )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD freeRowSet() 

   if !empty( ::oDocumentRowSet )
      ::oDocumentRowSet:End()
   end if 
   
   if !empty( ::oLinesRowSet )
      ::oLinesRowSet:End()
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setUserDataSet() 

   local nRow

   ::oFastReport:ClearDataSets()

   ::oFastReport:setUserDataSet(    "Documento",;
                                    ::getDocumentModel():getSerializeColumnsSelect(),;
                                    {|| ::oDocumentRowSet:gotop() },;
                                    {|| ::oDocumentRowSet:skip( 1 ) },;
                                    {|| ::oDocumentRowSet:skip( -1 ) },;
                                    {|| ::oDocumentRowSet:eof() },;
                                    {|cField| ::oDocumentRowSet:fieldGet( cField ) } )

   ::oFastReport:setUserDataSet(   "Líneas",;
                                    ::getLinesModel():getSerializeColumnsSelect(),;
                                    {|| ::oLinesRowSet:gotop() },;
                                    {|| ::oLinesRowSet:skip( 1 ) },;
                                    {|| ::oLinesRowSet:skip( -1 ) },;
                                    {|| ::oLinesRowSet:eof() },;
                                    {|cField| ::oLinesRowSet:fieldGet( cField ) } )

   ::oFastReport:setUserDataSet(   "Totales",;
                                    serializeArray( hgetKeys( ::hTotal ), ";" ),;
                                    {|| nil },;
                                    {|| nil },;
                                    {|| nil },;
                                    {|| nil },;
                                    {|cField| if( hhaskey( ::hTotal, cField ), hget( ::hTotal, cField ), "" ) } )

   ::oFastReport:setUserDataSet(   "Totales por impuestos ",;
                                    serializeArray( hgetKeys( ::hTotal ), ";" ),;
                                    {|| nRow := 1 },;
                                    {|| nRow++ },;
                                    {|| nRow-- },;
                                    {|| nRow > len( ::aTotalsByIVA ) },;
                                    {|cField| if( hhaskey( ::aTotalsByIVA[ nRow ], cField ), hget( ::aTotalsByIVA[ nRow ], cField ), "" ) } )

RETURN ( nil )

//---------------------------------------------------------------------------//

