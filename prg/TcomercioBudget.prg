#include "FiveWin.Ch" 
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch" 

//---------------------------------------------------------------------------//

CLASS TComercioBudget

   DATA  TComercio
   
   METHOD New( TComercio )                                  CONSTRUCTOR

   METHOD insertBudgetInGestoolIfNotExist( oQuery )
   METHOD isBudgetAlreadyRecived( oQuery )


   // facades------------------------------------------------------------------

   METHOD TPrestashopId()                                   INLINE ( ::TComercio:TPrestashopId )
   METHOD TPrestashopConfig()                               INLINE ( ::TComercio:TPrestashopConfig )
   METHOD getCurrentWebName()                               INLINE ( ::TComercio:getCurrentWebName() )

   METHOD writeText( cText )                                INLINE ( ::TComercio:writeText( cText ) )

   METHOD oCustomerDatabase()                               INLINE ( ::TComercio:oCli )
   METHOD oAddressDatabase()                                INLINE ( ::TComercio:oObras )
   METHOD oPaymentDatabase()                                INLINE ( ::TComercio:oFPago )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( TComercio ) CLASS TComercioBudget

   ::TComercio          := TComercio

Return ( Self )

//---------------------------------------------------------------------------//

METHOD insertBudgetInGestoolIfNotExist( oQuery ) CLASS TComercioBudget

   if !( ::isBudgetAlreadyRecived( oQuery ) )
      ::insertPresupuestoPrestashop( oQuery )
   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD isBudgetAlreadyRecived( oQuery ) CLASS TComercioBudget

   local isOrderAlreadyRecived      := .t.
   local idOrderPrestashop          := oQuery:fieldGet( 1 )

   if empty( ::TPrestashopId():getGestoolOrder( idOrderPrestashop, ::getCurrentWebName() ) )
      isOrderAlreadyRecived         := .f.
   else
      ::writeText( "El documento con el indentificador " + alltrim( str( idOrderPrestashop ) ) + " ya ha sido recibido.", 3 )
   end if 

Return ( isOrderAlreadyRecived )   

//---------------------------------------------------------------------------//



