#include "FiveWin.Ch" 
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch" 

//---------------------------------------------------------------------------//

CLASS TComercioCustomer

   DATA  TComercio
   
   METHOD New( TComercio )                      CONSTRUCTOR
   METHOD TPrestashopId()                       INLINE ( ::TComercio:TPrestashopId )
   METHOD TPrestashopConfig()                   INLINE ( ::TComercio:TPrestashopConfig )
   METHOD getCurrentWebName()                   INLINE ( ::TComercio:getCurrentWebName() )

   METHOD isCustomerInGestool( idCustomer )     INLINE ( ::TPrestashopId():getGestoolCustomer( idCustomer, ::getCurrentWebName() ) )

   METHOD insertCustomerInGestoolIfNotExist( idCustomer ) ;
                                                INLINE ( if( ::isCustomerInGestool( idCustomer ), , ::createCustomerInGestool( idCustomer ) ) )

   METHOD createCustomerInGestool()    
   METHOD getCustomerFromPrestashop()
      METHOD appendCustomerInGestool()

   METHOD oCustomerDatabase()                   INLINE ( ::TComercio:oCli )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( TComercio ) CLASS TComercioCustomer

   debug( Tcomercio, "self dede TComercioCustomer")
   
   ::TComercio    := TComercio

   debug( Self, "self dede TComercioCustomer")

Return ( Self )

//---------------------------------------------------------------------------//

METHOD createCustomerInGestool( idCustomer )

   local oQuery   := ::getCustomerFromPrestashop( idCustomer )

   if hb_isobject( oQuery )

      ::appendCustomerInGestool( oQuery )

      oQuery:Free()

   end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD getCustomerFromPrestashop( idCustomer ) CLASS TComercioCustomer

   local cQuery
   local oQuery 

   cQuery            := "SELECT * FROM " + ::TComercio:cPrefixTable( "customer" ) + " " + ;
                           "WHERE id_customer = '" + alltrim( str( idCustomer ) ) + "'" 

   oQuery            := TMSQuery():New( ::TComercio:oCon, cQuery )

   if oQuery:Open() .and. oQuery:recCount() > 0
      Return ( oQuery )   
   end if 

Return ( nil )

//---------------------------------------------------------------------------//

METHOD appendCustomerInGestool( oQuery ) CLASS TComercioCustomer

   local cCodCli                    := nextkey( dbLast( ::oCustomerDatabase(), 1 ), ::oCustomerDatabase():cAlias, "0", retnumcodcliemp() )

   ::oCustomerDatabase():Append()
   ::oCustomerDatabase():Cod        := cCodCli
   
   if ::TPrestashopConfig():InvertedNameFormat()
      ::oCustomerDatabase():Titulo  := upper( oQuery:FieldGetbyName( "lastname" ) ) + ", " + upper( oQuery:FieldGetByName( "firstname" ) ) // Last Name - firstname
   else   
      ::oCustomerDatabase():Titulo  := upper( oQuery:FieldGetbyName( "firstname" ) ) + space( 1 ) + upper( oQuery:FieldGetByName( "lastname" ) ) //firstname - Last Name
   end if   
   
   ::oCustomerDatabase():nTipCli    := 3
   ::oCustomerDatabase():CopiasF    := 1
   ::oCustomerDatabase():Serie      := ::TPrestashopConfig():getOrderSerie()
   ::oCustomerDatabase():nRegIva    := 1
   ::oCustomerDatabase():nTarifa    := 1
   ::oCustomerDatabase():cMeiInt    := oQuery:FieldGetByName( "email" ) //email
   ::oCustomerDatabase():lChgPre    := .t.
   ::oCustomerDatabase():lSndInt    := .t.
   ::oCustomerDatabase():CodPago    := cDefFpg()
   ::oCustomerDatabase():cCodAlm    := cDefAlm()
   ::oCustomerDatabase():dFecChg    := GetSysDate()
   ::oCustomerDatabase():cTimChg    := Time()
   ::oCustomerDatabase():lWeb       := .t.

   if ::oCustomerDatabase():Save()
      ::TPrestashopId():setValueCustomer( cCodCli, ::getCurrentWebName(), oQuery:FieldGet( 1 ) ) 
      ::writeText( "Cliente " + alltrim( oQuery:FieldGetByName( "ape" ) ) + Space( 1 ) + alltrim( oQuery:FieldGetByName( "firstname" ) ) + " introducido correctamente.", 3 )
   else
      ::writeText( "Error al guardar el cliente en gestool : " + alltrim( oQuery:FieldGetByName( "ape" ) ) + Space( 1 ) + alltrim( oQuery:FieldGetByName( "firstname" ) ), 3 )
   end if

Return ( .t. )

//---------------------------------------------------------------------------//
