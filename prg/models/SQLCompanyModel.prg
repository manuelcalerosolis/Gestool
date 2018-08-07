#include "FiveWin.Ch"

//---------------------------------------------------------------------------//

CLASS SQLCompanyModel FROM SQLBaseModel

   METHOD getTableName()   INLINE ( Company():getTableName( ::cTableName ) )

ENDCLASS

//---------------------------------------------------------------------------//

