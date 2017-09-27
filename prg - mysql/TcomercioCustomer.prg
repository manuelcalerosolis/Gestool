#include "FiveWin.Ch" 
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch" 

//---------------------------------------------------------------------------//

CLASS TComercioCustomer

   DATA  TComercio

   DATA  idCustomerGestool
   
   METHOD New( TComercio )                                  CONSTRUCTOR

   METHOD isCustomerInGestool( oQueryCustomer )
   METHOD isAddressInGestool( idAddress )                   

   METHOD insertCustomerInGestoolIfNotExist( idCustomer ) 

   METHOD getCustomerFromPrestashop()
      METHOD appendCustomerInGestool()

   METHOD createAddressInGestool()    
   METHOD getAddressFromPrestashop()
      METHOD appendAddressInGestool()
      METHOD assertAddressInGestoolCustomer()

   METHOD getState( idState ) 
   METHOD getPaymentGestool( module ) 

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

METHOD New( TComercio ) CLASS TComercioCustomer

   ::TComercio          := TComercio

Return ( Self )

//---------------------------------------------------------------------------//

METHOD isCustomerInGestool( oQuery ) CLASS TComercioCustomer

   local idCustomer     
   local email

   if oQuery:RecCount() > 0

      idCustomer           := oQuery:fieldGetByName( 'id_customer' )
      email                := oQuery:fieldGetByName( 'email' )

      ::idCustomerGestool  := ::TPrestashopId():getGestoolCustomer( idCustomer, ::getCurrentWebName() )

      if !empty( ::idCustomerGestool )
         if ::oCustomerDatabase():seekInOrd( email, "Nif")
            Return ( .t. )
         end if 
      end if 

   end if 

Return ( .f. )

//---------------------------------------------------------------------------//

METHOD isAddressInGestool( idAddress ) CLASS TComercioCustomer                  

   local idAddressInGestool   := ::TPrestashopId():getGestoolAddress( idAddress, ::getCurrentWebName() )

   if !empty( idAddressInGestool )
      if ::oAddressDatabase():seekInOrd( idAddressInGestool, "cCodCli" )      
         Return ( .t. )
      end if 
   end if 

Return ( .f. )

//---------------------------------------------------------------------------//

METHOD insertCustomerInGestoolIfNotExist( oQuery ) CLASS TComercioCustomer

   local idCustomer           := oQuery:FieldGetByName( "id_customer" )
   local idAddressDelivery    := oQuery:FieldGetByName( "id_address_delivery" )
   local idAddressInvoice     := oQuery:FieldGetByName( "id_address_invoice" ) 

   local oQueryCustomer       := ::getCustomerFromPrestashop( idCustomer )      

   if !( ::isCustomerInGestool( oQueryCustomer ) )
      ::appendCustomerInGestool( oQueryCustomer )
   end if 

   oQueryCustomer:free()

   if !( ::isAddressInGestool( idAddressDelivery ) )
      ::createAddressInGestool( idAddressDelivery )
   end if 

   if !( ::isAddressInGestool( idAddressInvoice ) )
      ::createAddressInGestool( idAddressInvoice )
   end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD getCustomerFromPrestashop( idCustomer ) CLASS TComercioCustomer

   local cQuery
   local oQuery 

   cQuery            := "SELECT * FROM " + ::TComercio:cPrefixTable( "customer" ) + " WHERE id_customer = " + alltrim( str( idCustomer ) ) 
   oQuery            := TMSQuery():New( ::TComercio:oCon, cQuery )

   if oQuery:Open() 
      Return ( oQuery )   
   end if 

Return ( nil )

//---------------------------------------------------------------------------//

METHOD appendCustomerInGestool( oQuery ) CLASS TComercioCustomer

   ::idCustomerGestool              := nextkey( dbLast( ::oCustomerDatabase(), 1 ), ::oCustomerDatabase():cAlias, "0", retnumcodcliemp() )

   ::oCustomerDatabase():Append()
   ::oCustomerDatabase():Cod        := ::idCustomerGestool
   
   if ::TPrestashopConfig():isInvertedNameFormat()
      ::oCustomerDatabase():Titulo  := upper( oQuery:fieldGetbyName( "lastname" ) ) + ", " + upper( oQuery:fieldGetByName( "firstname" ) ) // Last Name - firstname
   else   
      ::oCustomerDatabase():Titulo  := upper( oQuery:fieldGetbyName( "firstname" ) ) + space( 1 ) + upper( oQuery:fieldGetByName( "lastname" ) ) //firstname - Last Name
   end if   
   
   ::oCustomerDatabase():nTipCli    := 3
   ::oCustomerDatabase():CopiasF    := 1
   ::oCustomerDatabase():Serie      := ::TPrestashopConfig():getOrderSerie()
   ::oCustomerDatabase():nRegIva    := 1
   ::oCustomerDatabase():nTarifa    := 1
   ::oCustomerDatabase():cMeiInt    := oQuery:fieldGetByName( "email" ) //email
   ::oCustomerDatabase():lChgPre    := .t.
   ::oCustomerDatabase():lSndInt    := .t.
   ::oCustomerDatabase():CodPago    := ::getPaymentGestool( oQuery:FieldGetByName( "module" ) )
   ::oCustomerDatabase():cCodAlm    := ::TPrestashopConfig():getStore()
   ::oCustomerDatabase():dFecChg    := GetSysDate()
   ::oCustomerDatabase():cTimChg    := Time()
   ::oCustomerDatabase():lWeb       := .t.

   if ::oCustomerDatabase():Save()

      ::TPrestashopId():setValueCustomer( ::idCustomerGestool, ::getCurrentWebName(), oQuery:fieldGet( 1 ) ) 

      ::writeText( "Cliente " + alltrim( oQuery:fieldGetByName( "ape" ) ) + Space( 1 ) + alltrim( oQuery:fieldGetByName( "firstname" ) ) + " introducido correctamente.", 3 )

   else
      
      ::writeText( "Error al guardar el cliente en gestool : " + alltrim( oQuery:fieldGetByName( "ape" ) ) + Space( 1 ) + alltrim( oQuery:fieldGetByName( "firstname" ) ), 3 )

      Return ( .f. )

   end if

Return ( .t. )

//---------------------------------------------------------------------------//
 
METHOD createAddressInGestool( idAddress ) CLASS TComercioCustomer

   local oQuery 
  
   oQuery      := ::getAddressFromPrestashop( idAddress )

   if empty( oQuery )
      Return ( Self )
   end if 

   if oQuery:recCount() > 0 
   
      ::appendAddressInGestool( oQuery )
      
      ::assertAddressInGestoolCustomer( oQuery )
   end if 

   oQuery:Free()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD getAddressFromPrestashop( idAddress ) CLASS TComercioCustomer

   local cQuery   := "SELECT * FROM " + ::TComercio:cPrefixTable( "address" ) + " " +;
                     "WHERE id_address = " + alltrim( str( idAddress ) ) 
   local oQuery   := TMSQuery():New( ::TComercio:oCon, cQuery )

   if oQuery:Open() 
      Return ( oQuery )   
   end if 

Return ( nil )

//---------------------------------------------------------------------------//

METHOD appendAddressInGestool( oQuery ) CLASS TComercioCustomer

   local idAddressGestool        := "@" + alltrim( str( oQuery:fieldGet( 1 ) ) ) 
   local nameAddressGestool      := upper( oQuery:fieldGetbyName( "firstname" ) ) + space( 1 ) + upper( oQuery:fieldGetByName( "lastname" ) ) 

   ::oAddressDatabase():Append()

   ::oAddressDatabase():cCodObr  := idAddressGestool
   ::oAddressDatabase():cCodCli  := ::idCustomerGestool
   ::oAddressDatabase():cNomObr  := nameAddressGestool
   ::oAddressDatabase():cDirObr  := oQuery:fieldGetByName( "address1" ) + " " + oQuery:fieldGetByName( "address2" ) 
   ::oAddressDatabase():cPobObr  := oQuery:fieldGetByName( "city" )           
   ::oAddressDatabase():cPosObr  := oQuery:fieldGetByName( "postcode" )       
   ::oAddressDatabase():cTelObr  := oQuery:fieldGetByName( "phone" )          
   ::oAddressDatabase():cMovObr  := oQuery:fieldGetByName( "phone_mobile" )   

   ::oAddressDatabase():cPrvObr  := ::getState( oQuery:fieldGetbyName( "id_state" ) )

   if ::oAddressDatabase():Save()
      
      ::TPrestashopId():setValueAddress( ::idCustomerGestool + idAddressGestool, ::getCurrentWebName(), oQuery:fieldGet( 1 ) ) 

      ::writeText( "Dirección de cliente " + nameAddressGestool + " introducida correctamente.", 3 )

   else
      
      ::writeText( "Error al guardar la dirección del cliente en gestool " + nameAddressGestool, 3 )

      Return ( .f. )

   end if 

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD assertAddressInGestoolCustomer ( oQuery ) class TComercioCustomer

   if ::oCustomerDatabase():seekInOrd(::idCustomerGestool, "Cod")

      if empty(::oCustomerDatabase():fieldGetbyName( "Domicilio" ) )

         ::oCustomerDatabase():load()
         ::oCustomerDatabase():Domicilio     := oQuery:fieldGetByName( "address1" ) + " " + oQuery:fieldGetByName( "address2" )  
         ::oCustomerDatabase():Poblacion     := oQuery:fieldGetByName( "city" )           
         ::oCustomerDatabase():CodPostal     := oQuery:fieldGetByName( "postcode" ) 
         ::oCustomerDatabase():Provincia     := ::getState( oQuery:fieldGetbyName( "id_state" ) )  
         ::oCustomerDatabase():Telefono      := oQuery:fieldGetByName( "phone" )  
         ::oCustomerDatabase():Movil         := oQuery:fieldGetByName( "phone_mobile" )          
         ::oCustomerDatabase():save()

      end if 

   end if 
    
Return(.t.)

//---------------------------------------------------------------------------//

METHOD getState( idState ) CLASS TComercioCustomer
             
   local cQuery
   local oQuery
   local cState      := ""

   cQuery            := "SELECT * FROM " + ::TComercio:cPrefixTable( "state" ) + " WHERE id_state = " + alltrim( str( idState ) )
   oQuery            := TMSQuery():New( ::TComercio:oCon, cQuery )

   if oQuery:Open() .and. oQuery:RecCount() > 0
      cState         := oQuery:fieldGetbyName( "name" )
      oQuery:free()
   end if   

Return ( cState )

//---------------------------------------------------------------------------//

METHOD getPaymentGestool( cPrestashopModule ) CLASS TComercioCustomer

   local paymentGestool    := cDefFpg()

   if empty( cPrestashopModule )
      Return ( paymentGestool )
   end if 

   if ::oPaymentDatabase():seekInOrd( upper( cPrestashopModule ), "cCodWeb" )
      paymentGestool       := ::oPaymentDatabase():cCodPago 
   end if 

Return ( paymentGestool )

//---------------------------------------------------------------------------//

