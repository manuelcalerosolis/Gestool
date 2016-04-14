#include "FiveWin.Ch" 
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch" 

//---------------------------------------------------------------------------//

CLASS TComercioBudget

   DATA  TComercio

   DATA idBudgetPrestashop

   DATA cSerieBudget   
   DATA nNumeroBudget  
   DATA cSufijoBudget  

   DATA idBudgetPrestashop
   
   METHOD New( TComercio )                                  CONSTRUCTOR

   METHOD insertBudgetInGestoolIfNotExist( oQuery )
   METHOD isBudgetInGestool( oQuery )

   METHOD insertBudgetGestool( oQuery )
      
      METHOD getCountersBudgetGestool( oQuery )
      METHOD insertDatosHeaderBudgetGestool( oQuery )
         METHOD setCustomerInBudget( oQuery )

      METHOD insertLineaBudgetGestool( oQuery )
         METHOD setProductInBudgetLine( oQueryLine )
         METHOD parseProductProperties( idPropertyGestool ) 

      METHOD appendMessageBudget( oQuery )
      METHOD appendStateBudgetPrestashop( oQuery ) 

   METHOD idBudgetGestool()                                 INLINE ( ::cSerieBudget + str( ::nNumeroBudget ) + ::cSufijoBudget ) 

   // facades------------------------------------------------------------------

   METHOD TPrestashopId()                                   INLINE ( ::TComercio:TPrestashopId )
   METHOD TPrestashopConfig()                               INLINE ( ::TComercio:TPrestashopConfig )
   METHOD TComercioCustomer()                               INLINE ( ::TComercio:TComercioCustomer )

   METHOD getCurrentWebName()                               INLINE ( ::TComercio:getCurrentWebName() )

   METHOD writeText( cText )                                INLINE ( ::TComercio:writeText( cText ) )
   METHOD getDate( dDate )                                  INLINE ( ::TComercio:getDate( dDate ) )
   METHOD getTime( dTime )                                  INLINE ( ::TComercio:getTime( dTime ) )

   METHOD oCustomerDatabase()                               INLINE ( ::TComercio:oCli )
   METHOD oAddressDatabase()                                INLINE ( ::TComercio:oObras )
   METHOD oPaymentDatabase()                                INLINE ( ::TComercio:oFPago )
   METHOD oBudgetHeaderDatabase()                           INLINE ( ::TComercio:oPreCliT )
   METHOD oBudgetLineDatabase()                             INLINE ( ::TComercio:oPreCliL )
   METHOD oBudgetIncidenciaDatabase()                       INLINE ( ::TComercio:oPreCliI )
   METHOD oBudgetEstadoDatabase()                           INLINE ( ::TComercio:oPreCliE )

   METHOD oCounterDatabase()                                INLINE ( ::TComercio:oCount )
   METHOD oPaymentDatabase()                                INLINE ( ::TComercio:oFPago )
   METHOD oDivisasDatabase()                                INLINE ( ::TComercio:oDivisas )
   METHOD oConexionMySQLDatabase()                          INLINE ( ::TComercio:oCon )
   METHOD oArticleDatabase()                                INLINE ( ::TComercio:oArt )
   METHOD oKitDatabase()                                    INLINE ( ::TComercio:oKit )
   METHOD oFamilyDatabase()                                 INLINE ( ::TComercio:oFam )
   METHOD oProductDatabase()                                INLINE ( ::TComercio:oArt )
   METHOD oPropertyDatabase()                               INLINE ( ::TComercio:oPro )
   
END CLASS

//---------------------------------------------------------------------------//

METHOD New( TComercio ) CLASS TComercioBudget

   ::TComercio          := TComercio

Return ( Self )

//---------------------------------------------------------------------------//

METHOD insertBudgetInGestoolIfNotExist( oQuery ) CLASS TComercioBudget

   ::idBudgetPrestashop := oQuery:fieldGet( 1 )
    
   if ::isBudgetInGestool()
      ::writeText( "El documento con el indentificador " + alltrim( str( ::idBudgetPrestashop ) ) + " ya ha sido recibido." )
   else
      ::insertBudgetGestool( oQuery )
   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD isBudgetInGestool() CLASS TComercioBudget

   local idBudgetGestool               := ::TPrestashopId():getGestoolBudget( ::idBudgetPrestashop, ::getCurrentWebName() )

   if !empty( idBudgetGestool )
      if ::oBudgetHeaderDatabase():seekInOrd( idBudgetGestool, "NNUMPRE")
         Return ( .t. )
      end if 
   end if 

Return ( .f. )

//---------------------------------------------------------------------------//

METHOD insertBudgetGestool( oQuery ) CLASS TComercioBudget

   ::TComercioCustomer():insertCustomerInGestoolIfNotExist( oQuery:FieldGetByName( "id_customer" ),;
                                                            oQuery:FieldGetByName( "id_address_delivery" ),;
                                                            oQuery:FieldGetByName( "id_address_invoice" ) ) 


   ::getCountersBudgetGestool(                  oQuery )
   ::insertDatosHeaderBudgetGestool(            oQuery )
   ::insertLineaBudgetGestool(                  oQuery )
   // ::appendMessageBudget(                       oQuery )
  // ::appendStateBudgetPrestashop(               oQuery )  
   
   ::TPrestashopId():setGestoolBudget( ::idBudgetGestool(), ::getCurrentWebName(), ::idBudgetPrestashop )

Return ( .f. )

 //---------------------------------------------------------------------------//

METHOD getCountersBudgetGestool( oQuery ) CLASS TComercioBudget

   ::idBudgetPrestashop          := oQuery:fieldGet( 1 )
   ::cSerieBudget                := ::TPrestashopConfig():getBudgetSerie()
   ::nNumeroBudget               := nNewDoc( ::cSerieBudget, ::oBudgetHeaderDatabase():cAlias, "nPreCli", , ::oCounterDatabase():cAlias )
   ::cSufijoBudget               := retSufEmp()

Return ( .t. )

 //---------------------------------------------------------------------------//
 
METHOD insertDatosHeaderBudgetGestool( oQuery ) CLASS TComercioBudget

   ::oBudgetHeaderDatabase():Append()

   ::oBudgetHeaderDatabase():cSerPre      := ::cSerieBudget
   ::oBudgetHeaderDatabase():nNumPre      := ::nNumeroBudget
   ::oBudgetHeaderDatabase():cSufPre      := ::cSufijoBudget
   ::oBudgetHeaderDatabase():cCodWeb      := ::idBudgetPrestashop
   ::oBudgetHeaderDatabase():dFecPre      := ::getDate( oQuery:FieldGetByName( "date_add" ) )
   ::oBudgetHeaderDatabase():cSuPre       := oQuery:FieldGetByName( "reference" )
   ::oBudgetHeaderDatabase():cTurPre      := cCurSesion()
   ::oBudgetHeaderDatabase():cCodAlm      := oUser():cAlmacen()
   ::oBudgetHeaderDatabase():cCodCaj      := oUser():cCaja()
   ::oBudgetHeaderDatabase():cCodObr      := "@" + alltrim( str( oQuery:FieldGetByName( "id_address_delivery" ) ) )
   ::oBudgetHeaderDatabase():cCodPgo      := cFPagoWeb( alltrim( oQuery:FieldGetByName( "module" ) ), ::oPaymentDatabase():cAlias )
   ::oBudgetHeaderDatabase():lEstado      := .t.
   ::oBudgetHeaderDatabase():nTarifa      := 1
   ::oBudgetHeaderDatabase():cDivPre      := cDivEmp()
   ::oBudgetHeaderDatabase():nVdvPre      := nChgDiv( cDivEmp(), ::oDivisasDatabase():cAlias )
   ::oBudgetHeaderDatabase():lSndDoc      := .t.
   ::oBudgetHeaderDatabase():lIvaInc      := uFieldEmpresa( "lIvaInc" )
   ::oBudgetHeaderDatabase():cManObr      := Padr( "Gastos envio", 250 )
   ::oBudgetHeaderDatabase():nManObr      := oQuery:FieldGetByName( "total_shipping_tax_excl" )
   ::oBudgetHeaderDatabase():nIvaMan      := oQuery:FieldGetByName( "carrier_tax_rate" )
   ::oBudgetHeaderDatabase():lCloPre      := .f.
   ::oBudgetHeaderDatabase():cCodUsr      := cCurUsr()
   ::oBudgetHeaderDatabase():dFecCre      := GetSysDate()
   ::oBudgetHeaderDatabase():cTimCre      := Time()
   ::oBudgetHeaderDatabase():cCodDlg      := oUser():cDelegacion()
   ::oBudgetHeaderDatabase():lWeb         := .t.
   ::oBudgetHeaderDatabase():lInternet    := .t.
   ::oBudgetHeaderDatabase():nTotNet      := oQuery:FieldGetByName( "total_products" )
   ::oBudgetHeaderDatabase():nTotIva      := oQuery:FieldGetByName( "total_paid_tax_incl" ) - ( oQuery:FieldGetByName( "total_products" ) + oQuery:FieldGetByName( "total_shipping_tax_incl" ) )
   ::oBudgetHeaderDatabase():nTotPre      := oQuery:FieldGetByName( "total_paid_tax_incl" )

   ::setCustomerInBudget( oQuery )

   if ::oBudgetHeaderDatabase():Save()
      ::writeText( "Presupuesto " + ::cSerieBudget + "/" + alltrim( str( ::nNumeroBudget ) ) + "/" + ::cSufijoBudget + " introducido correctamente.", 3 )
   else
      ::writeText( "Error al descargar el presupuesto: " + ::cSerieBudget + "/" + alltrim( str( ::nNumeroBudget ) ) + "/" + ::cSufijoBudget, 3 )
   end if   

Return ( .t. )

 //---------------------------------------------------------------------------//

 METHOD setCustomerInBudget( oQuery ) CLASS TComercioBudget

   local cCodigocli                       := ::TPrestashopId:getGestoolCustomer( oQuery:FieldGetByName( "id_customer" ), ::getCurrentWebName() )

   if ::oCustomerDatabase():SeekInOrd( cCodigocli , "Cod")

      ::oBudgetHeaderDatabase():cCodCli   := ::oCustomerDatabase():Cod
      ::oBudgetHeaderDatabase():cNomCli   := ::oCustomerDatabase():Titulo
      ::oBudgetHeaderDatabase():cDirCli   := ::oCustomerDatabase():Domicilio
      ::oBudgetHeaderDatabase():cPobCli   := ::oCustomerDatabase():Poblacion
      ::oBudgetHeaderDatabase():cPrvCli   := ::oCustomerDatabase():Provincia
      ::oBudgetHeaderDatabase():cPosCli   := ::oCustomerDatabase():CodPostal
      ::oBudgetHeaderDatabase():cDniCli   := ::oCustomerDatabase():Nif
      ::oBudgetHeaderDatabase():lModCli   := .t.
      ::oBudgetHeaderDatabase():cTlfCli   := ::oCustomerDatabase():Telefono
      ::oBudgetHeaderDatabase():cCodGrp   := ::oCustomerDatabase():cCodGrp
      ::oBudgetHeaderDatabase():nRegIva   := ::oCustomerDatabase():nRegIva

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD insertLineaBudgetGestool( oQuery ) CLASS TComercioBudget

   local cQueryLine        
   local oQueryLine           
   local nNumLin           := 1

   cQueryLine              := "SELECT * FROM " + ::TComercio:cPrefixtable( "order_detail" ) + " WHERE id_order = " + alltrim( str( ::idBudgetPrestashop ) )
   oQueryLine              := TMSQuery():New( ::oConexionMySQLDatabase(), cQueryLine )

   if oQueryLine:Open() .and. ( oQueryLine:RecCount() > 0 )

      oQueryLine:GoTop()
      while !oQueryLine:Eof()

         ::oBudgetLineDatabase():Append()

         ::oBudgetLineDatabase():cSerPre        := ::cSerieBudget
         ::oBudgetLineDatabase():nNumPre        := ::nNumeroBudget
         ::oBudgetLineDatabase():cSufPre        := ::cSufijoBudget
         ::oBudgetLineDatabase():dFecha         := ::getDate( oQuery:FieldGetByName( "date_add" ) )
         ::oBudgetLineDatabase():cDetalle       := oQueryLine:FieldGetByName( "product_name" )
         ::oBudgetLineDatabase():mLngDes        := oQueryLine:FieldGetByName( "product_name" )
         ::oBudgetLineDatabase():nCanPre        := 1
         ::oBudgetLineDatabase():nPosPrint      := nNumLin
         ::oBudgetLineDatabase():nNumLin        := nNumLin
         ::oBudgetLineDatabase():cAlmLin        := cDefAlm()
         ::oBudgetLineDatabase():nTarLin        := 1
         ::oBudgetLineDatabase():nUniCaja       := oQueryLine:FieldGetByName( "product_quantity" )
         ::oBudgetLineDatabase():nPreDiv        := oQueryLine:FieldGetByName( "product_price" )
         ::oBudgetLineDatabase():nDto           := oQueryLine:FieldGetByName( "reduction_percent" )
         ::oBudgetLineDatabase():nDtoDiv        := oQueryLine:FieldGetByName( "reduction_amount" )
         ::oBudgetLineDatabase():nIva           := ::TComercio:nIvaProduct( oQueryLine:FieldGetByName( "product_id" ) )

         ::setProductInBudgetLine( oQueryLine )

         if !::oBudgetLineDatabase():Save()
            ::writeText( "Error al guardaar las lineas el pedido " + ::idBudgetGestool() )
         end if

         oQueryLine:Skip()

         nNumLin++

      end while

   end if

   oQueryLine:Free()

Return ( .t. )
 
//---------------------------------------------------------------------------//
         
METHOD setProductInBudgetLine( oQueryLine )

   local idProductGestool                 := ::TPrestashopId:getGestoolProduct( oQueryLine:FieldGetByName( "product_id" ), ::getCurrentWebName() )

   debug(idProductGestool, "idProductGestool" )

   if empty( idProductGestool )
      Return ( .f. )
   end if 

   if ::oArticleDatabase():seekInOrd( idProductGestool, "Codigo" )

      debug( "found" )

      ::oBudgetLineDatabase():cRef        := ::oArticleDatabase():Codigo
      ::oBudgetLineDatabase():cUnidad     := ::oArticleDatabase():cUnidad
      ::oBudgetLineDatabase():nPesoKg     := ::oArticleDatabase():nPesoKg
      ::oBudgetLineDatabase():cPesoKg     := ::oArticleDatabase():cUnidad
      ::oBudgetLineDatabase():nVolumen    := ::oArticleDatabase():nVolumen
      ::oBudgetLineDatabase():cVolumen    := ::oArticleDatabase():cVolumen
      ::oBudgetLineDatabase():nCtlStk     := ::oArticleDatabase():nCtlStock
      ::oBudgetLineDatabase():nCosDiv     := nCosto( ::oArticleDatabase():Codigo, ::oArticleDatabase():cAlias, ::oKitDatabase():cAlias )
      ::oBudgetLineDatabase():cCodTip     := ::oArticleDatabase():cCodTip
      ::oBudgetLineDatabase():cCodFam     := ::oArticleDatabase():Familia
      ::oBudgetLineDatabase():cGrpFam     := RetFld( ::oArticleDatabase():Familia, ::oFamilyDatabase():cAlias, "cCodGrp" )
      ::oBudgetLineDatabase():cCodPr1     := ::oArticleDatabase():cCodPrp1
      ::oBudgetLineDatabase():cCodPr2     := ::oArticleDatabase():cCodPrp2
      ::oBudgetLineDatabase():lLote       := ::oArticleDatabase():lLote 
      ::oBudgetLineDatabase():cLote       := ::oArticleDatabase():cLote 

      ::parseProductProperties( ::oArticleDatabase():cCodPrp1, oQueryLine:FieldGetByName( "product_name" ) )
      ::parseProductProperties( ::oArticleDatabase():cCodPrp2, oQueryLine:FieldGetByName( "product_name" ) )

//      ::oBudgetLineDatabase():cValPr1     := ::TComercio:GetValPrp( oRetFld( ::oArticleDatabase():cCodPrp1, ::oProductDatabase(), "cCodWeb", "cCodPro" ), oQueryLine:FieldGetbyname( "product_attribute_id" ) )
//      ::oBudgetLineDatabase():cValPr2     := ::TComercio:GetValPrp( oRetFld( ::oArticleDatabase():cCodPrp2, ::oProductDatabase(), "cCodWeb", "cCodPro" ), oQueryLine:FieldGetbyname( "product_attribute_id" ) )

      Return ( .t. )

   end if

Return ( .f. )

//---------------------------------------------------------------------------//

METHOD parseProductProperties( idPropertyGestool, productName ) CLASS TComercioBudget

   local cPropertieCode
   local cPropertieName                   := oRetFld( idPropertyGestool, ::oPropertyDatabase(), "cDesPro" ) 

   if empty(cPropertieName)
      Return ( cPropertieName )
   end if

   cPropertieName                         := alltrim( cPropertieName ) + " : "

   if at( cPropertieName, productName ) > 0
      cPropertieCode                      := substr( productName, at( cPropertieName, productName ) ) 
      cPropertieCode                      := strtran( cPropertieCode, cPropertieName, "" )   
      if at( ",", cPropertieCode ) > 0
         cPropertieCode                   := substr( cPropertieCode, 1, at( ",", cPropertieCode ) - 1 )
      end if 
   end if 

   msgAlert( idPropertyGestool, "idPropertyGestool" )
   msgAlert( cPropertieCode, "cPropertieCode" )

Return ( cPropertieName )

//---------------------------------------------------------------------------//

METHOD appendMessageBudget ( oQuery ) CLASS TComercioBudget

   local cQueryThead
   local oQueryThead
   local oQueryMessage
   local dFecha   := ::getDate( oQuery:FieldGetByName( "date_add" ) )

   oQueryThead    := TMSQuery():New( ::oConexionMySQLDatabase(), "SELECT * FROM " + ::Tcomercio:cPrefixtable( "customer_thread" ) + ;
                                     + " WHERE id_order=" + alltrim( str( ::idBudgetPrestashop ) ) )

   if oQueryThead:Open() .and. ( oQueryThead:RecCount() > 0 )

      oQueryThead:GoTop()
      while !oQueryThead:Eof()

         oQueryMessage    := TMSQuery():New( ::oConexionMySQLDatabase(), "SELECT * FROM " + ;
                                             ::Tcomercio:cPrefixtable( "customer_message" ) + " WHERE id_customer_thread=" + ;
                                             + alltrim( str( oQueryThead:FieldGet( 1 ) ) ) )

         if oQueryMessage:Open() .and. ( oQueryMessage:RecCount() > 0 )

            oQueryMessage:GoTop()
            while !oQueryMessage:Eof()

               ::oBudgetIncidenciaDatabase():Append()
               ::oBudgetIncidenciaDatabase():Blank()

               ::oBudgetIncidenciaDatabase():cSerPre   := ::cSerieBudget
               ::oBudgetIncidenciaDatabase():nNumPre   := ::nNumeroBudget
               ::oBudgetIncidenciaDatabase():cSufPre   := ::cSufijoBudget
               ::oBudgetIncidenciaDatabase():dFecInc   := dFecha
               ::oBudgetIncidenciaDatabase():mDesInc   := oQueryMessage:FieldGetByName( "message" )
               ::oBudgetIncidenciaDatabase():lAviso    := .t.

               ::oBudgetIncidenciaDatabase():Save()

               oQueryMessage:Skip()

            end while

         end if
            
         oQueryMessage:Free()    

         oQueryThead:Skip()

      end while

   end if   

   oQueryThead:Free()

Return ( .t. )
 
//---------------------------------------------------------------------------//

METHOD appendStateBudgetPrestashop( oQuery ) CLASS TComercioBudget
   
   local oQueryState
   local nLanguage
   
   oQueryState    := TMSQuery():New( ::oConexionMySQLDatabase(), "SELECT * FROM " + ;
                                     ::Tcomercio:cPrefixtable( "order_history" ) + " h inner join "+ ;
                                     ::Tcomercio:cPrefixtable( "order_state_lang" ) + " s on h.id_order_state = s.id_order_state WHERE s.id_lang = " + ;
                                     str( nLanguage ) + " and id_order = " + alltrim( str( ::idBudgetPrestashop ) ) )

   if oQueryState:Open()

      if oQueryState:RecCount() > 0

         oQueryState:GoTop()

         while !oQueryState:Eof()

            ::oBudgetEstadoDatabase():Append()
            ::oBudgetEstadoDatabase():Blank()

            ::oBudgetEstadoDatabase():cSerPre   := ::cSerieBudget
            ::oBudgetEstadoDatabase():nNumPre   := ::nNumeroBudget
            ::oBudgetEstadoDatabase():cSufPre   := ::cSufijoBudget
            ::oBudgetEstadoDatabase():cSitua    := oQueryState:FieldGetByName( "name" )
            ::oBudgetEstadoDatabase():dFecSit   := ::getDate( oQueryState:FieldGetByName( "date_add" ) )
            ::oBudgetEstadoDatabase():tFecSit   := ::getTime( oQueryState:FieldGetByName( "date_add" ) )
            ::oBudgetEstadoDatabase():idPs      := oQueryState:FieldGetByName( "id_order_history" )
                     
            ::oBudgetEstadoDatabase():Save()

         oQueryState:Skip()

          end while

      end if
               
   end if      

Return ( .t. )

//---------------------------------------------------------------------------//