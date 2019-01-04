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

   METHOD setDocumentGeneralWhere( uuid ) VIRTUAL

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
      ::setDocumentGeneralWhere( uuid )
   end if 

   ::getDocumentRowSet():Build( ::getDocumentModel():getGeneralSelect() )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD buidSentenceAndRowSetLines( uuid )

   ::setLinesGeneralWhere( uuid )

   ::getLinesRowSet():Build( ::getLinesModel():getGeneralSelect() )

RETURN ( nil )

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

   ::oFastReport:setUserDataSet(   "L�neas",;
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
                                    {|cField| hget( ::hTotal, cField ) } )

   ::oFastReport:setUserDataSet(   "Totales por impuestos ",;
                                    serializeArray( hgetKeys( ::hTotal ), ";" ),;
                                    {|| nRow := 1 },;
                                    {|| nRow++ },;
                                    {|| nRow-- },;
                                    {|| nRow > len( ::aTotalsByIVA ) },;
                                    {|cField| hget( ::aTotalsByIVA[ nRow ], cField ) } )

RETURN ( nil )

//---------------------------------------------------------------------------//

