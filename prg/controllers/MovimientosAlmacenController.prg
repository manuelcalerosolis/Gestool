#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenController FROM SQLBaseController

   METHOD   New()

   METHOD   buildSQLModel( this )         INLINE ( MovimientosAlmacenModel():New( this ) )
   
   METHOD   buildSQLView( this )				INLINE ( MovimientosAlmacen():New( this ) )

   METHOD   initAppendMode() 

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::idUserMap             := "01050"

   ::setTitle( "Movimientos almacen" )

   ::Super:New()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD initAppendMode() 

   ::oModel:hBuffer[ "delegacion"   ]  := retSufEmp()
   ::oModel:hBuffer[ "usuario"      ]  := cCurUsr()

Return ( Self )

//---------------------------------------------------------------------------//



