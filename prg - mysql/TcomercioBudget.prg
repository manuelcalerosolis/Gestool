#include "FiveWin.Ch" 
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch" 

//---------------------------------------------------------------------------//

CLASS TComercioDocument

   DATA TComercio

   DATA idDocumentPrestashop
   DATA dateDocumentPrestashop

   DATA cSerieDocument   
   DATA nNumeroDocument  
   DATA cSufijoDocument  
  
   METHOD New( TComercio )                                  CONSTRUCTOR

   METHOD insertDocumentInGestoolIfNotExist( oQuery )
   METHOD isDocumentInGestool( oQuery )                     VIRTUAL

   METHOD insertDocumentGestool( oQuery )
      
      METHOD getCountersDocumentGestool( oQuery )           VIRTUAL
      METHOD insertHeaderDocumentGestool( oQuery )
         METHOD setCustomerInDocument( oQuery )

      METHOD insertLinesDocumentGestool( oQuery )
         METHOD setProductInDocumentLine( oQueryLine )
         METHOD getProductProperty( idPropertyGestool, productName )
         METHOD getNameProductProperty( idPropertyGestool ) 

      METHOD insertMessageDocument( oQuery )
      METHOD insertStateDocumentPrestashop( oQuery ) 

   METHOD setGestoolIdDocument( oDatabase )                 VIRTUAL
   METHOD setGestoolSpecificDocument( oQuery )              VIRTUAL
   METHOD setPrestashopIdDocument()                         VIRTUAL
   METHOD setGestoolSpecificLineDocument()                  VIRTUAL

   METHOD idDocumentGestool()                               INLINE ( ::cSerieDocument + str( ::nNumeroDocument ) + ::cSufijoDocument ) 

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

   METHOD oCounterDatabase()                                INLINE ( ::TComercio:oCount )
   METHOD oPaymentDatabase()                                INLINE ( ::TComercio:oFPago )
   METHOD oDivisasDatabase()                                INLINE ( ::TComercio:oDivisas )
   METHOD oConexionMySQLDatabase()                          INLINE ( ::TComercio:oCon )
   METHOD oArticleDatabase()                                INLINE ( ::TComercio:oArt )
   METHOD oKitDatabase()                                    INLINE ( ::TComercio:oKit )
   METHOD oFamilyDatabase()                                 INLINE ( ::TComercio:oFam )
   METHOD oProductDatabase()                                INLINE ( ::TComercio:oArt )
   METHOD oPropertyDatabase()                               INLINE ( ::TComercio:oPro )
   METHOD oPropertyLinesDatabase()                          INLINE ( ::TComercio:oTblPro )
   
END CLASS

//---------------------------------------------------------------------------//

METHOD New( TComercio ) CLASS TComercioDocument

   ::TComercio          := TComercio

Return ( Self )

//---------------------------------------------------------------------------//

METHOD insertDocumentInGestoolIfNotExist( oQuery ) CLASS TComercioDocument

   ::idDocumentPrestashop     := oQuery:fieldGet( 1 )
    
   if ::isDocumentInGestool()
      ::writeText( "El documento con el identificador " + alltrim( str( ::idDocumentPrestashop ) ) + " ya ha sido recibido." )
   else
      ::insertDocumentGestool( oQuery )
   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD insertDocumentGestool( oQuery ) CLASS TComercioDocument

   ::TComercioCustomer():insertCustomerInGestoolIfNotExist( oQuery )

   ::getCountersDocumentGestool(      oQuery )
   ::insertHeaderDocumentGestool(     oQuery )
   ::insertLinesDocumentGestool(      oQuery )
   ::insertMessageDocument(           oQuery )
   ::insertStateDocumentPrestashop(   oQuery )  

   ::setPrestashopIdDocument()
   
Return ( .f. )

//---------------------------------------------------------------------------//

METHOD insertHeaderDocumentGestool( oQuery ) CLASS TComercioDocument

   ::oDocumentHeaderDatabase():Append()

   ::setGestoolIdDocument( ::oDocumentHeaderDatabase() ) 

   ::setGestoolSpecificDocument( oQuery )

   ::oDocumentHeaderDatabase():cCodWeb      := ::idDocumentPrestashop
   ::oDocumentHeaderDatabase():cCodAlm      := oUser():cAlmacen()
   ::oDocumentHeaderDatabase():cCodCaj      := oUser():cCaja()
   ::oDocumentHeaderDatabase():cCodObr      := "@" + alltrim( str( oQuery:FieldGetByName( "id_address_delivery" ) ) )
   ::oDocumentHeaderDatabase():cCodPgo      := cFPagoWeb( alltrim( oQuery:FieldGetByName( "module" ) ), ::oPaymentDatabase():cAlias )
   ::oDocumentHeaderDatabase():nTarifa      := 1
   ::oDocumentHeaderDatabase():lSndDoc      := .t.
   ::oDocumentHeaderDatabase():lIvaInc      := uFieldEmpresa( "lIvaInc" )
   ::oDocumentHeaderDatabase():cManObr      := Padr( "Gastos envio", 250 )
   ::oDocumentHeaderDatabase():nManObr      := oQuery:FieldGetByName( "total_shipping_tax_excl" )
   ::oDocumentHeaderDatabase():nIvaMan      := oQuery:FieldGetByName( "carrier_tax_rate" )
   ::oDocumentHeaderDatabase():cCodUsr      := cCurUsr()
   ::oDocumentHeaderDatabase():dFecCre      := GetSysDate()
   ::oDocumentHeaderDatabase():cTimCre      := Time()
   ::oDocumentHeaderDatabase():cCodDlg      := oUser():cDelegacion()
   ::oDocumentHeaderDatabase():lWeb         := .t.
   ::oDocumentHeaderDatabase():lInternet    := .t.
   ::oDocumentHeaderDatabase():nTotNet      := oQuery:FieldGetByName( "total_products" )
   ::oDocumentHeaderDatabase():nTotIva      := oQuery:FieldGetByName( "total_paid_tax_incl" ) - ( oQuery:FieldGetByName( "total_products" ) + oQuery:FieldGetByName( "total_shipping_tax_incl" ) )

   ::setCustomerInDocument( oQuery )

   if ::oDocumentHeaderDatabase():Save()
      ::writeText( "Documento " + ::cSerieDocument + "/" + alltrim( str( ::nNumeroDocument ) ) + "/" + ::cSufijoDocument + " introducido correctamente.", 3 )
   else
      ::writeText( "Error al descargar el documento : " + ::cSerieDocument + "/" + alltrim( str( ::nNumeroDocument ) ) + "/" + ::cSufijoDocument, 3 )
   end if   

Return ( .t. )

 //---------------------------------------------------------------------------//

 METHOD setCustomerInDocument( oQuery ) CLASS TComercioDocument

   local cCodigocli                          := ::TPrestashopId:getGestoolCustomer( oQuery:FieldGetByName( "id_customer" ), ::getCurrentWebName() )

   if ::oCustomerDatabase():SeekInOrd( cCodigocli , "Cod")

      ::oDocumentHeaderDatabase():cCodCli    := ::oCustomerDatabase():Cod
      ::oDocumentHeaderDatabase():cNomCli    := ::oCustomerDatabase():Titulo
      ::oDocumentHeaderDatabase():cDirCli    := ::oCustomerDatabase():Domicilio
      ::oDocumentHeaderDatabase():cPobCli    := ::oCustomerDatabase():Poblacion
      ::oDocumentHeaderDatabase():cPrvCli    := ::oCustomerDatabase():Provincia
      ::oDocumentHeaderDatabase():cPosCli    := ::oCustomerDatabase():CodPostal
      ::oDocumentHeaderDatabase():cDniCli    := ::oCustomerDatabase():Nif
      ::oDocumentHeaderDatabase():lModCli    := .t.
      ::oDocumentHeaderDatabase():cTlfCli    := ::oCustomerDatabase():Telefono
      ::oDocumentHeaderDatabase():cCodGrp    := ::oCustomerDatabase():cCodGrp
      ::oDocumentHeaderDatabase():nRegIva    := ::oCustomerDatabase():nRegIva

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD insertLinesDocumentGestool( oQuery ) CLASS TComercioDocument

   local nNumLin           := 1
   local cQueryLine        
   local oQueryLine           

   cQueryLine              := "SELECT * FROM " + ::TComercio:cPrefixtable( "order_detail" ) + " " + ;
                              "WHERE id_order = " + alltrim( str( ::idDocumentPrestashop ) )
   oQueryLine              := TMSQuery():New( ::oConexionMySQLDatabase(), cQueryLine )

   if oQueryLine:Open() .and. ( oQueryLine:RecCount() > 0 )

      oQueryLine:GoTop()
      while !oQueryLine:Eof()

         ::oDocumentLineDatabase():Append()

         ::setGestoolIdDocument( ::oDocumentLineDatabase() )
         
         ::setGestoolSpecificLineDocument()
         
         ::oDocumentLineDatabase():dFecha         := ::getDate( oQuery:FieldGetByName( "date_add" ) )
         ::oDocumentLineDatabase():cDetalle       := oQueryLine:FieldGetByName( "product_name" )
         ::oDocumentLineDatabase():mLngDes        := oQueryLine:FieldGetByName( "product_name" )
         ::oDocumentLineDatabase():nPosPrint      := nNumLin
         ::oDocumentLineDatabase():nNumLin        := nNumLin
         ::oDocumentLineDatabase():cAlmLin        := cDefAlm()
         ::oDocumentLineDatabase():nTarLin        := 1
         ::oDocumentLineDatabase():nUniCaja       := oQueryLine:FieldGetByName( "product_quantity" )
         ::oDocumentLineDatabase():nPreDiv        := oQueryLine:FieldGetByName( "product_price" ) 
         ::oDocumentLineDatabase():nDto           := oQueryLine:FieldGetByName( "reduction_percent" )
         ::oDocumentLineDatabase():nDtoDiv        := oQueryLine:FieldGetByName( "reduction_amount_tax_excl" )
         ::oDocumentLineDatabase():nIva           := ::TComercio:nIvaProduct( oQueryLine:FieldGetByName( "product_id" ) )

         ::setProductInDocumentLine( oQueryLine )

         if !::oDocumentLineDatabase():Save()
            ::writeText( "Error al guardar las lineas del documento " + ::idDocumentGestool() )
         end if

         oQueryLine:Skip()

         nNumLin++

      end while

   end if

   oQueryLine:Free()

Return ( .t. )
 
//---------------------------------------------------------------------------//
         
METHOD setProductInDocumentLine( oQueryLine )

   local idProductGestool                 := oQueryLine:FieldGetByName( "product_reference" )

   if empty( idProductGestool )
      idProductGestool                    := ::TPrestashopId:getGestoolProduct( oQueryLine:FieldGetByName( "product_id" ), ::getCurrentWebName() )
   end if 

   if empty( idProductGestool )
      Return ( .f. )
   end if 

   if ::oArticleDatabase():seekInOrd( idProductGestool, "Codigo" )

      ::oDocumentLineDatabase():cRef        := ::oArticleDatabase():Codigo
      ::oDocumentLineDatabase():cUnidad     := ::oArticleDatabase():cUnidad
      ::oDocumentLineDatabase():nPesoKg     := ::oArticleDatabase():nPesoKg
      ::oDocumentLineDatabase():cPesoKg     := ::oArticleDatabase():cUnidad
      ::oDocumentLineDatabase():nVolumen    := ::oArticleDatabase():nVolumen
      ::oDocumentLineDatabase():cVolumen    := ::oArticleDatabase():cVolumen
      ::oDocumentLineDatabase():nCtlStk     := ::oArticleDatabase():nCtlStock
      ::oDocumentLineDatabase():nCosDiv     := nCosto( ::oArticleDatabase():Codigo, ::oArticleDatabase():cAlias, ::oKitDatabase():cAlias )
      ::oDocumentLineDatabase():cCodTip     := ::oArticleDatabase():cCodTip
      ::oDocumentLineDatabase():cCodFam     := ::oArticleDatabase():Familia
      ::oDocumentLineDatabase():cGrpFam     := retfld( ::oArticleDatabase():Familia, ::oFamilyDatabase():cAlias, "cCodGrp" )
      ::oDocumentLineDatabase():lLote       := ::oArticleDatabase():lLote 
      ::oDocumentLineDatabase():cLote       := ::oArticleDatabase():cLote 

      ::oDocumentLineDatabase():cCodPr1     := ::oArticleDatabase():cCodPrp1
      ::oDocumentLineDatabase():cCodPr2     := ::oArticleDatabase():cCodPrp2
      ::oDocumentLineDatabase():cValPr1     := ::getProductProperty( ::oArticleDatabase():cCodPrp1, oQueryLine:FieldGetByName( "product_name" ) )
      ::oDocumentLineDatabase():cValPr2     := ::getProductProperty( ::oArticleDatabase():cCodPrp2, oQueryLine:FieldGetByName( "product_name" ) )

      Return ( .t. )

   end if

Return ( .f. )

//---------------------------------------------------------------------------//

METHOD getProductProperty( idPropertyGestool, productName ) CLASS TComercioDocument

   local productProperty      := ""
   local productPropertyName  := ::getNameProductProperty( idPropertyGestool, productName )

   if !empty( productPropertyName )

      if ::oPropertyLinesDatabase():seekInOrd( upper( idPropertyGestool ) + upper( productPropertyName ), "cCodDes" )
         productProperty      := ::oPropertyLinesDatabase():cCodTbl      
      end if 

   end if 

Return ( productProperty )

//---------------------------------------------------------------------------//

METHOD getNameProductProperty( idPropertyGestool, productName ) CLASS TComercioDocument

   local cPropertieCode       := ""
   local cPropertieName       := oRetFld( idPropertyGestool, ::oPropertyDatabase(), "cDesPro" ) 

   if empty( cPropertieName )
      Return ( cPropertieCode )
   end if

   cPropertieName             := alltrim( cPropertieName ) + " : "

   if at( cPropertieName, productName ) > 0
      cPropertieCode          := substr( productName, at( cPropertieName, productName ) ) 
      cPropertieCode          := strtran( cPropertieCode, cPropertieName, "" )   
      if at( ",", cPropertieCode ) > 0
         cPropertieCode       := substr( cPropertieCode, 1, at( ",", cPropertieCode ) - 1 )
      end if 
   end if 

Return ( cPropertieCode )

//---------------------------------------------------------------------------//

METHOD insertMessageDocument( oQuery ) CLASS TComercioDocument

   local dFecha   
   local cQueryThead
   local oQueryThead
   local cQueryMessage
   local oQueryMessage

   dFecha                  := ::getDate( oQuery:FieldGetByName( "date_add" ) )

   cQueryThead             := "SELECT * FROM " + ::Tcomercio:cPrefixtable( "customer_thread" ) + " " + ;
                              "WHERE id_order = " + alltrim( str( ::idDocumentPrestashop ) )
   oQueryThead             := TMSQuery():New( ::oConexionMySQLDatabase(), cQueryThead )

   if oQueryThead:Open() .and. ( oQueryThead:recCount() > 0 )

      oQueryThead:GoTop()
      while !oQueryThead:eof()

         cQueryMessage     := "SELECT * FROM " + ::Tcomercio:cPrefixtable( "customer_message" ) + " " +;
                              "WHERE id_customer_thread = " + alltrim( str( oQueryThead:fieldget( 1 ) ) )
         oQueryMessage     := TMSQuery():New( ::oConexionMySQLDatabase(), cQueryMessage )

         if oQueryMessage:Open() .and. ( oQueryMessage:recCount() > 0 )

            oQueryMessage:GoTop()
            while !oQueryMessage:eof()

               ::oDocumentIncidenciaDatabase():Append()

               ::setGestoolIdDocument( ::oDocumentIncidenciaDatabase() )

               ::oDocumentIncidenciaDatabase():dFecInc   := dFecha
               ::oDocumentIncidenciaDatabase():mDesInc   := oQueryMessage:FieldGetByName( "message" )
               ::oDocumentIncidenciaDatabase():lAviso    := .t.

               ::oDocumentIncidenciaDatabase():Save()

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

METHOD insertStateDocumentPrestashop( oQuery ) CLASS TComercioDocument
   
   local nLanguage
   local cQueryState
   local oQueryState
   
   cQueryState    := "SELECT * FROM " + ::TComercio:cPrefixtable( "order_history" ) + " h " + ;
                     "INNER JOIN " + ::TComercio:cPrefixtable( "order_state_lang" ) + " s on h.id_order_state = s.id_order_state " + ;
                     "WHERE s.id_lang = " + str( ::TComercio:nLanguage ) + " and id_order = " + alltrim( str( ::idDocumentPrestashop ) )
   oQueryState    := TMSQuery():New( ::oConexionMySQLDatabase(), cQueryState  )

   if oQueryState:Open() .and. oQueryState:RecCount() > 0

      oQueryState:GoTop()

      while !oQueryState:Eof()

         ::oDocumentEstadoDatabase():Append()

         ::setGestoolIdDocument( ::oDocumentEstadoDatabase() )

         ::oDocumentEstadoDatabase():cSitua    := oQueryState:FieldGetByName( "name" )
         ::oDocumentEstadoDatabase():dFecSit   := ::getDate( oQueryState:FieldGetByName( "date_add" ) )
         ::oDocumentEstadoDatabase():tFecSit   := ::getTime( oQueryState:FieldGetByName( "date_add" ) )
         ::oDocumentEstadoDatabase():idPs      := oQueryState:FieldGetByName( "id_order_history" )
                  
         ::oDocumentEstadoDatabase():Save()

         oQueryState:Skip()

      end while

   end if
               
Return ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TComercioBudget FROM TComercioDocument

   METHOD isDocumentInGestool() 
   METHOD getCountersDocumentGestool( oQuery ) 

   METHOD setGestoolIdDocument( oDatabase ) 
   METHOD setGestoolSpecificDocument( oQuery )
   METHOD setGestoolSpecificLineDocument()

   METHOD setPrestashopIdDocument()

   METHOD oDocumentHeaderDatabase()                     INLINE ( ::TComercio:oPreCliT )
   METHOD oDocumentLineDatabase()                       INLINE ( ::TComercio:oPreCliL )
   METHOD oDocumentIncidenciaDatabase()                 INLINE ( ::TComercio:oPreCliI )
   METHOD oDocumentEstadoDatabase()                     INLINE ( ::TComercio:oPreCliE )

END CLASS

//---------------------------------------------------------------------------//

METHOD isDocumentInGestool() CLASS TComercioBudget

   local idDocumentGestool := ::TPrestashopId():getGestoolBudget( ::idDocumentPrestashop, ::getCurrentWebName() )

   if !empty( idDocumentGestool )
      if ::oDocumentHeaderDatabase():seekInOrd( idDocumentGestool, "nNumPre" )
         Return ( .t. )
      else 
         ::TPrestashopId():deleteValueBudget( idDocumentGestool, ::getCurrentWebName() )
      end if 
   end if 

Return ( .f. )

//---------------------------------------------------------------------------//

METHOD getCountersDocumentGestool( oQuery ) CLASS TComercioBudget

   ::idDocumentPrestashop  := oQuery:fieldGet( 1 )
   ::cSerieDocument        := ::TPrestashopConfig():getBudgetSerie()
   ::nNumeroDocument       := nNewDoc( ::cSerieDocument, ::oDocumentHeaderDatabase():cAlias, "nPreCli", , ::oCounterDatabase():cAlias )
   ::cSufijoDocument       := retSufEmp()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD setGestoolIdDocument( oDatabase ) CLASS TComercioBudget

   oDatabase:cSerPre   := ::cSerieDocument
   oDatabase:nNumPre   := ::nNumeroDocument
   oDatabase:cSufPre   := ::cSufijoDocument

Return ( self )

//---------------------------------------------------------------------------//

METHOD setGestoolSpecificDocument( oQuery ) CLASS TComercioBudget

   ::oDocumentHeaderDatabase():dFecPre    := ::getDate( oQuery:FieldGetByName( "date_add" ) )
   ::oDocumentHeaderDatabase():cTurPre    := cCurSesion()
   ::oDocumentHeaderDatabase():cSuPre     := oQuery:FieldGetByName( "reference" )
   ::oDocumentHeaderDatabase():lEstado    := .t.
   ::oDocumentHeaderDatabase():cDivPre    := cDivEmp()
   ::oDocumentHeaderDatabase():nVdvPre    := nChgDiv( cDivEmp(), ::oDivisasDatabase():cAlias )
   ::oDocumentHeaderDatabase():lCloPre    := .f.
   ::oDocumentHeaderDatabase():nTotPre    := oQuery:FieldGetByName( "total_paid_tax_incl" )

Return ( self )

//---------------------------------------------------------------------------//

METHOD setGestoolSpecificLineDocument() CLASS TComercioBudget

   ::oDocumentLineDatabase():nCanPre      := 1

Return ( self )

//---------------------------------------------------------------------------//

METHOD setPrestashopIdDocument() CLASS TComercioBudget

   ::TPrestashopId():setGestoolBudget( ::idDocumentGestool(), ::getCurrentWebName(), ::idDocumentPrestashop )

Return ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TComercioOrder FROM TComercioDocument

   METHOD isDocumentInGestool() 
   METHOD getCountersDocumentGestool( oQuery ) 
   METHOD setGestoolIdDocument( oDatabase ) 

   METHOD setPrestashopIdDocument()
   METHOD setGestoolSpecificDocument( oQuery )
   METHOD setGestoolSpecificLineDocument() 

   METHOD oDocumentHeaderDatabase()                     INLINE ( ::TComercio:oPedCliT )
   METHOD oDocumentLineDatabase()                       INLINE ( ::TComercio:oPedCliL )
   METHOD oDocumentIncidenciaDatabase()                 INLINE ( ::TComercio:oPedCliI )
   METHOD oDocumentEstadoDatabase()                     INLINE ( ::TComercio:oPedCliE )

END CLASS

//---------------------------------------------------------------------------//

METHOD isDocumentInGestool() CLASS TComercioOrder

   local idDocumentGestool := ::TPrestashopId():getGestoolOrder( ::idDocumentPrestashop, ::getCurrentWebName() )

   if !empty( idDocumentGestool )
      if ::oDocumentHeaderDatabase():seekInOrd( idDocumentGestool, "nNumPed" )
         Return ( .t. )
      else 
         ::TPrestashopId():deleteValueOrder( idDocumentGestool, ::getCurrentWebName() )
      end if 
   end if 

Return ( .f. )

//---------------------------------------------------------------------------//

METHOD getCountersDocumentGestool( oQuery ) CLASS TComercioOrder

   ::idDocumentPrestashop  := oQuery:fieldGet( 1 )
   ::cSerieDocument        := ::TPrestashopConfig():getBudgetSerie()
   ::nNumeroDocument       := nNewDoc( ::cSerieDocument, ::oDocumentHeaderDatabase():cAlias, "nPedCli", , ::oCounterDatabase():cAlias )
   ::cSufijoDocument       := retSufEmp()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD setGestoolIdDocument( oDatabase ) CLASS TComercioOrder

   oDatabase:cSerPed       := ::cSerieDocument
   oDatabase:nNumPed       := ::nNumeroDocument
   oDatabase:cSufPed       := ::cSufijoDocument

Return ( self )

//---------------------------------------------------------------------------//

METHOD setGestoolSpecificDocument( oQuery ) CLASS TComercioOrder

   ::oDocumentHeaderDatabase():dFecPed    := ::getDate( oQuery:FieldGetByName( "date_add" ) ) 
   ::oDocumentHeaderDatabase():cTurPed    := cCurSesion()
   ::oDocumentHeaderDatabase():cSuPed     := oQuery:FieldGetByName( "reference" )
   ::oDocumentHeaderDatabase():cDivPed    := cDivEmp()
   ::oDocumentHeaderDatabase():nVdvPed    := nChgDiv( cDivEmp(), ::oDivisasDatabase():cAlias )
   ::oDocumentHeaderDatabase():lCloPed    := .f.
   ::oDocumentHeaderDatabase():nTotPed    := oQuery:FieldGetByName( "total_paid_tax_incl" )

Return ( self )

//---------------------------------------------------------------------------//

METHOD setGestoolSpecificLineDocument() CLASS TComercioOrder

   ::oDocumentLineDatabase():nCanPed      := 1

Return ( self )

//---------------------------------------------------------------------------//

METHOD setPrestashopIdDocument() CLASS TComercioOrder

   ::TPrestashopId():setGestoolOrder( ::idDocumentGestool(), ::getCurrentWebName(), ::idDocumentPrestashop )

Return ( self )

//---------------------------------------------------------------------------//
