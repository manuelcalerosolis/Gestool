#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Hdo.ch"
#include "HdoCommon.ch"

//---------------------------------------------------------------------------//

CLASS SQLCompanyModel FROM SQLBaseModel

   METHOD getTableName()   INLINE ( Company():getTableName( ::cTableName ) )

ENDCLASS

//---------------------------------------------------------------------------//

