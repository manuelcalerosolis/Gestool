#include "FiveWin.Ch" 
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch" 

//---------------------------------------------------------------------------//

CLASS TComercioCustomer

   DATA  TComercio

   DATA  idCustomerGestool
  
   METHOD New( TComercio )                         CONSTRUCTOR

   METHOD isCustomerInGestool( oQueryCustomer )
   METHOD isNotCustomerInGestool( oQueryCustomer ) INLINE ( !( ::isCustomerInGestool( oQueryCustomer ) ) )                  

   METHOD isAddressInGestool( idAddress ) 
   METHOD isNotAddressInGestool( idAddress )       INLINE ( !( ::isAddressInGestool( idAddress ) ) )                  

   METHOD insertCustomerInGestoolIfNotExist( oQuery ) 

   METHOD getCustomerFromPrestashop()
      METHOD appendCustomerInGestool()

   METHOD createAddressInGestool()    
   METHOD getAddressFromPrestashop()
      METHOD appendAddressInGestool()
      METHOD assertAddressInGestoolCustomer()

   METHOD getState( idState ) 
   METHOD getPaymentGestool( module ) 

   METHOD setCustomerGestool( idCustomerGestool )  INLINE ( ::idCustomerGestool := padr( idCustomerGestool, 12 ) )
   METHOD getCustomerGestool()                     INLINE ( padr( ::idCustomerGestool, 12 ) )

   METHOD getCustomerName( oQuery )                INLINE ( if ( ::TComercioConfig():isInvertedNameFormat(),;
                                                               upper( oQuery:fieldGetbyName( "lastname" ) ) + ", " + upper( oQuery:fieldGetByName( "firstname" ) ),;
                                                               upper( oQuery:fieldGetbyName( "firstname" ) ) + space( 1 ) + upper( oQuery:fieldGetByName( "lastname" ) ) ) )

   // facades------------------------------------------------------------------

   METHOD TPrestashopId()                          INLINE ( ::TComercio:TPrestashopId )
   METHOD TComercioConfig()                        INLINE ( ::TComercio:TComercioConfig )
   METHOD getCurrentWebName()                      INLINE ( ::TComercio:getCurrentWebName() )

   METHOD writeText( cText )                       INLINE ( ::TComercio:writeText( cText ) )

   METHOD oCustomerDatabase()                      INLINE ( ::TComercio:oCli )
   METHOD oAddressDatabase()                       INLINE ( ::TComercio:oObras )
   METHOD oPaymentDatabase()                       INLINE ( ::TComercio:oFPago )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( TComercio ) CLASS TComercioCustomer

   ::TComercio          := TComercio

Return ( Self )

//---------------------------------------------------------------------------//

METHOD isCustomerInGestool( oQuery ) CLASS TComercioCustomer

   local email
   local idCustomer
   local idCustomerGestool     

   if oQuery:recCount() > 0

      email                := oQuery:fieldGetByName( 'email' )
      idCustomer           := oQuery:fieldGetByName( 'id_customer' )

      idCustomerGestool    := ::TPrestashopId():getGestoolCustomer( idCustomer, ::getCurrentWebName() )

      if empty( idCustomerGestool )
         Return ( .f. )
      end if 

      if ::oCustomerDatabase():seekInOrd( idCustomer, "Cod" )
         ::setCustomerGestool( idCustomerGestool )
         Return ( .t. )
      end if 

      if !empty( email ) .and. ::oCustomerDatabase():seekInOrd( upper( email ), "cMeiInt")
         ::setCustomerGestool( ::oCustomerDatabase():Cod )
         Return ( .t. )
      end if 

   end if 

Return ( .f. )

//---------------------------------------------------------------------------//

METHOD isAddressInGestool( idAddress ) CLASS TComercioCustomer                  

   local idAddressInGestool   

   idAddressInGestool         := ::TPrestashopId():getGestoolAddress( idAddress, ::getCurrentWebName() )

   if empty( idAddressInGestool )
      Return ( .f. )
   end if 

   if ::oAddressDatabase():seekInOrd( idAddressInGestool, "cCodCli" )  
      ::writeText( "La dirección " + idAddressInGestool + " ya exite en las direcciones" )    
      Return ( .t. )
   end if 

   ::writeText( "La dirección " + idAddressInGestool + " no exite en las direcciones" )    

Return ( .f. )

//---------------------------------------------------------------------------//

METHOD insertCustomerInGestoolIfNotExist( oQuery ) CLASS TComercioCustomer

   local idCustomer           := oQuery:FieldGetByName( "id_customer" )
   local idAddressDelivery    := oQuery:FieldGetByName( "id_address_delivery" )
   local idAddressInvoice     := oQuery:FieldGetByName( "id_address_invoice" ) 

   local oQueryCustomer       := ::getCustomerFromPrestashop( idCustomer )      

   if ::isNotCustomerInGestool( oQueryCustomer )
      ::appendCustomerInGestool( oQueryCustomer )
   end if 

   oQueryCustomer:free()

   if ::isNotAddressInGestool( idAddressDelivery ) 
      ::createAddressInGestool( idAddressDelivery )
   end if 

   if ::isNotAddressInGestool( idAddressDelivery ) 
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

   ::setCustomerGestool( nextkey( dbLast( ::oCustomerDatabase(), 1 ), ::oCustomerDatabase():cAlias, "0", retnumcodcliemp() ) )

   ::oCustomerDatabase():Append()
   ::oCustomerDatabase():Blank()
   
   ::oCustomerDatabase():Cod        := ::getCustomerGestool()
   ::oCustomerDatabase():Titulo     := ::getCustomerName( oQuery )
   ::oCustomerDatabase():nTipCli    := 3
   ::oCustomerDatabase():CopiasF    := 1
   ::oCustomerDatabase():Serie      := ::TComercioConfig():getOrderSerie()
   ::oCustomerDatabase():nRegIva    := 1
   ::oCustomerDatabase():nTarifa    := 1
   ::oCustomerDatabase():cMeiInt    := oQuery:fieldGetByName( "email" ) //email
   ::oCustomerDatabase():lChgPre    := .t.
   ::oCustomerDatabase():lSndInt    := .t.
   ::oCustomerDatabase():CodPago    := ::getPaymentGestool( oQuery:FieldGetByName( "module" ) )
   ::oCustomerDatabase():cCodAlm    := ::TComercioConfig():getStore()
   ::oCustomerDatabase():dFecChg    := GetSysDate()
   ::oCustomerDatabase():cTimChg    := Time()
   ::oCustomerDatabase():lWeb       := .t.

   if ::oCustomerDatabase():Save()
      ::TPrestashopId():setValueCustomer( ::getCustomerGestool(), ::getCurrentWebName(), oQuery:fieldGet( 1 ) ) 
      ::writeText( "Cliente " + ::getCustomerName( oQuery ) + " introducido con el código " + alltrim( ::getCustomerGestool() ), 3 )
   else
      ::writeText( "Error al guardar el cliente en gestool : " + ::getCustomerName( oQuery ), 3 )
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

   ::oAddressDatabase():Append()
   ::oAddressDatabase():Blank()

   ::oAddressDatabase():cCodObr  := idAddressGestool
   ::oAddressDatabase():cCodCli  := ::getCustomerGestool()
   ::oAddressDatabase():cNomObr  := ::getCustomerName( oQuery )
   ::oAddressDatabase():cDirObr  := oQuery:fieldGetByName( "address1" ) + " " + oQuery:fieldGetByName( "address2" ) 
   ::oAddressDatabase():cPobObr  := oQuery:fieldGetByName( "city" )           
   ::oAddressDatabase():cPosObr  := oQuery:fieldGetByName( "postcode" )       
   ::oAddressDatabase():cTelObr  := oQuery:fieldGetByName( "phone" )          
   ::oAddressDatabase():cMovObr  := oQuery:fieldGetByName( "phone_mobile" )   
   ::oAddressDatabase():cPrvObr  := ::getState( oQuery:fieldGetbyName( "id_state" ) )

   if ::oAddressDatabase():Save()
      ::TPrestashopId():setValueAddress( ::getCustomerGestool() + idAddressGestool, ::getCurrentWebName(), oQuery:fieldGet( 1 ) ) 
      ::writeText( "Dirección de cliente " + ::getCustomerName( oQuery ) + " introducida correctamente", 3 )
   else
      ::writeText( "Error al guardar la dirección del cliente en gestool " + ::getCustomerName( oQuery ), 3 )
      Return ( .f. )
   end if 

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD assertAddressInGestoolCustomer ( oQuery ) class TComercioCustomer

   if !( ::oCustomerDatabase():seekInOrd( ::getCustomerGestool(), "Cod" ) )
      ::writeText( "Cliente con el código " + alltrim( ::getCustomerGestool() ) + " no encontrado, imposible asignar dirección." )
      Return ( .f. )
   end if 

   if empty( ::oCustomerDatabase():fieldGetbyName( "Domicilio" ) )
      ::oCustomerDatabase():load()
      ::oCustomerDatabase():Domicilio     := oQuery:fieldGetByName( "address1" ) + " " + oQuery:fieldGetByName( "address2" )  
      ::oCustomerDatabase():Poblacion     := oQuery:fieldGetByName( "city" )           
      ::oCustomerDatabase():CodPostal     := oQuery:fieldGetByName( "postcode" ) 
      ::oCustomerDatabase():Provincia     := ::getState( oQuery:fieldGetbyName( "id_state" ) )  
      ::oCustomerDatabase():Telefono      := oQuery:fieldGetByName( "phone" )  
      ::oCustomerDatabase():Movil         := oQuery:fieldGetByName( "phone_mobile" )          
      ::oCustomerDatabase():save()
   end if 

Return ( .t. )

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

