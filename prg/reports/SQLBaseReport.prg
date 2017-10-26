#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"
#include "HdoCommon.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseReport
  
   DATA oController

   DATA oEvents

   DATA oFastReport

   DATA cReport

   METHOD New()

   METHOD End()

   METHOD newFastReport()                 INLINE ( ::oFastReport := frReportManager():New() )
   METHOD endFastReport()                 INLINE ( ::oFastReport:End() )
   METHOD setFastReport( oFastReport )    INLINE ( ::oFastReport := oFastReport )
   METHOD getFastReport()                 INLINE ( ::oFastReport )

   METHOD setReport( cReport )            INLINE ( ::cReport := cReport )
   METHOD getReport()                     INLINE ( ::cReport )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController                 := oController

   ::oEvents                     := Events():New()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   ::oEvents:End()
   
RETURN ( nil )

//---------------------------------------------------------------------------//

