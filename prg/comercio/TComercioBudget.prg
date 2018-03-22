#include "FiveWin.Ch" 
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch" 

//---------------------------------------------------------------------------//

CLASS TComercioDocument FROM TComercioConector

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

   METHOD insertLinesKitsGestool()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( TComercio ) CLASS TComercioDocument

   ::TComercio          := TComercio

Return ( Self )

//---------------------------------------------------------------------------//

METHOD insertDocumentInGestoolIfNotExist( oQuery ) CLASS TComercioDocument

   ::idDocumentPrestashop     := oQuery:fieldGet( 1 )
    
   if ::isDocumentInGestool( oQuery:fieldGetByName( "reference" ) )
      ::writeText( "El documento con el identificador " + alltrim( str( ::idDocumentPrestashop ) ) + " ya ha sido recibido." )
   else
      ::insertDocumentGestool( oQuery )
   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD insertDocumentGestool( oQuery ) CLASS TComercioDocument

   ::TComercioCustomer():insertCustomerInGestoolIfNotExist( oQuery )

   if empty( ::TComercioCustomer():getCustomerGestool() )
      ::writeText( "Cliente no encontrado, imposible añadir documento" )
      Return ( .f. )
   end if 

   ::getCountersDocumentGestool(      oQuery )
   ::insertHeaderDocumentGestool(     oQuery )
   ::insertLinesDocumentGestool(      oQuery )
   ::insertMessageDocument(           oQuery )
   ::insertStateDocumentPrestashop(   oQuery )

   ::setPrestashopIdDocument()
   
Return ( .t. )

//---------------------------------------------------------------------------//

METHOD insertHeaderDocumentGestool( oQuery ) CLASS TComercioDocument

   ( ::oDocumentHeaderDatabase() )->( dbappend() )

   ::setGestoolIdDocument( ::oDocumentHeaderDatabase() ) 

   ::setGestoolSpecificDocument( oQuery )

   ( ::oDocumentHeaderDatabase() )->cCodWeb      := ::idDocumentPrestashop
   ( ::oDocumentHeaderDatabase() )->cCodAlm      := oUser():cAlmacen()
   ( ::oDocumentHeaderDatabase() )->cCodCaj      := oUser():cCaja()
   ( ::oDocumentHeaderDatabase() )->cCodObr      := "@" + alltrim( str( oQuery:FieldGetByName( "id_address_delivery" ) ) )
   ( ::oDocumentHeaderDatabase() )->cCodPgo      := cFPagoWeb( alltrim( oQuery:FieldGetByName( "module" ) ), D():FormasPago( ::getView() ) )
   ( ::oDocumentHeaderDatabase() )->nTarifa      := 1
   ( ::oDocumentHeaderDatabase() )->lSndDoc      := .t.
   ( ::oDocumentHeaderDatabase() )->lIvaInc      := uFieldEmpresa( "lIvaInc" )
   ( ::oDocumentHeaderDatabase() )->cManObr      := Padr( "Gastos envio", 250 )
   ( ::oDocumentHeaderDatabase() )->nManObr      := oQuery:FieldGetByName( "total_shipping_tax_excl" )
   ( ::oDocumentHeaderDatabase() )->nIvaMan      := oQuery:FieldGetByName( "carrier_tax_rate" )
   ( ::oDocumentHeaderDatabase() )->cCodUsr      := Auth():Codigo()
   ( ::oDocumentHeaderDatabase() )->dFecCre      := GetSysDate()
   ( ::oDocumentHeaderDatabase() )->cTimCre      := Time()
   ( ::oDocumentHeaderDatabase() )->cCodDlg      := oUser():cDelegacion()
   ( ::oDocumentHeaderDatabase() )->lWeb         := .t.
   ( ::oDocumentHeaderDatabase() )->lInternet    := .t.
   ( ::oDocumentHeaderDatabase() )->nTotNet      := oQuery:FieldGetByName( "total_products" )
   ( ::oDocumentHeaderDatabase() )->nTotIva      := oQuery:FieldGetByName( "total_paid_tax_incl" ) - ( oQuery:FieldGetByName( "total_products" ) + oQuery:FieldGetByName( "total_shipping_tax_incl" ) )

   ::setCustomerInDocument( oQuery )

   if !( ::oDocumentHeaderDatabase() )->( neterr() )
      ( ::oDocumentHeaderDatabase() )->( dbcommit() )
      ( ::oDocumentHeaderDatabase() )->( dbunlock() )

      ::writeText( "Documento " + ::cSerieDocument + "/" + alltrim( str( ::nNumeroDocument ) ) + "/" + ::cSufijoDocument + " introducido correctamente.", 3 )

   else
      
      ::writeText( "Error al descargar el documento : " + ::cSerieDocument + "/" + alltrim( str( ::nNumeroDocument ) ) + "/" + ::cSufijoDocument, 3 )

   end if   

Return ( .t. )

 //---------------------------------------------------------------------------//

 METHOD setCustomerInDocument( oQuery ) CLASS TComercioDocument

   local idCustomerGestool                := ::TComercioCustomer():getCustomerGestool()

   if !( D():gotoCliente( idCustomerGestool, ::getView() ) )
      ::writeText( "Código de cliente " + alltrim( idCustomerGestool ) + " no encontrado", 3 )
      Return ( .f. )
   end if 

   ( ::oDocumentHeaderDatabase() )->cCodCli    := ( D():Clientes( ::getView() ) )->Cod
   ( ::oDocumentHeaderDatabase() )->cNomCli    := ( D():Clientes( ::getView() ) )->Titulo
   ( ::oDocumentHeaderDatabase() )->cDirCli    := ( D():Clientes( ::getView() ) )->Domicilio
   ( ::oDocumentHeaderDatabase() )->cPobCli    := ( D():Clientes( ::getView() ) )->Poblacion
   ( ::oDocumentHeaderDatabase() )->cPrvCli    := ( D():Clientes( ::getView() ) )->Provincia
   ( ::oDocumentHeaderDatabase() )->cPosCli    := ( D():Clientes( ::getView() ) )->CodPostal
   ( ::oDocumentHeaderDatabase() )->cDniCli    := ( D():Clientes( ::getView() ) )->Nif
   ( ::oDocumentHeaderDatabase() )->cTlfCli    := ( D():Clientes( ::getView() ) )->Telefono
   ( ::oDocumentHeaderDatabase() )->cCodGrp    := ( D():Clientes( ::getView() ) )->cCodGrp
   ( ::oDocumentHeaderDatabase() )->nRegIva    := ( D():Clientes( ::getView() ) )->nRegIva
   ( ::oDocumentHeaderDatabase() )->lModCli    := .t.

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD insertLinesDocumentGestool( oQuery ) CLASS TComercioDocument

   local nNumLin           := 1
   local cQueryLine        
   local oQueryLine  
   local lKitArt           := .f.
   local cCodArt           := ""         

   cQueryLine              := "SELECT * FROM " + ::TComercio:cPrefixtable( "order_detail" ) + " " + ;
                              "WHERE id_order = " + alltrim( str( ::idDocumentPrestashop ) )
   oQueryLine              := TMSQuery():New( ::oConexionMySQLDatabase(), cQueryLine )

   if oQueryLine:Open() .and. ( oQueryLine:RecCount() > 0 )

      oQueryLine:GoTop()
      while !( oQueryLine:eof() )

         ( ::oDocumentLineDatabase() )->( dbappend() )

         ::setGestoolIdDocument( ::oDocumentLineDatabase() )
         
         ::setGestoolSpecificLineDocument()

         ( ::oDocumentLineDatabase() )->dFecha        := ::getDate( oQuery:FieldGetByName( "date_add" ) )
         ( ::oDocumentLineDatabase() )->cDetalle      := oQueryLine:FieldGetByName( "product_name" )
         ( ::oDocumentLineDatabase() )->mLngDes       := oQueryLine:FieldGetByName( "product_name" )
         ( ::oDocumentLineDatabase() )->nPosPrint     := nNumLin
         ( ::oDocumentLineDatabase() )->nNumLin       := nNumLin
         ( ::oDocumentLineDatabase() )->cAlmLin       := cDefAlm()
         ( ::oDocumentLineDatabase() )->nTarLin       := 1
         ( ::oDocumentLineDatabase() )->nUniCaja      := oQueryLine:FieldGetByName( "product_quantity" )
         ( ::oDocumentLineDatabase() )->nPreDiv       := oQueryLine:FieldGetByName( "product_price" ) 
         ( ::oDocumentLineDatabase() )->nDto          := oQueryLine:FieldGetByName( "reduction_percent" )
         ( ::oDocumentLineDatabase() )->nDtoDiv       := oQueryLine:FieldGetByName( "reduction_amount_tax_excl" )
         ( ::oDocumentLineDatabase() )->nIva          := ::TComercio:nIvaProduct( oQueryLine:FieldGetByName( "product_id" ) )

         ::setProductInDocumentLine( oQueryLine, @lKitArt, @cCodArt )

         if ( ::oDocumentLineDatabase() )->( neterr() )
            ::writeText( "Error al guardar las lineas del documento " + ::idDocumentGestool() )
         else 
            ( ::oDocumentLineDatabase() )->( dbunlock() )
         end if

         if lKitArt
            ::insertLinesKitsGestool( nNumLin, cCodArt, oQuery )
         end if

         lKitArt     := .f.

         oQueryLine:Skip()

         nNumLin++

      end while

   end if

   oQueryLine:Free()

Return ( .t. )
 
//---------------------------------------------------------------------------//

METHOD insertLinesKitsGestool( nNumLin, cCodArt, oQuery ) CLASS TComercioDocument

   local nRec     := ( D():Kit( ::getView() ) )->( Recno() )
   local nOrdAnt  := ( D():Kit( ::getView() ) )->( OrdSetFocus( "CCODKIT" ) )
   local nNumKit  := 1

   if ( D():Kit( ::getView() ) )->( dbSeek( cCodArt ) )

      while ( D():Kit( ::getView() ) )->cCodKit == cCodArt .and. !( D():Kit( ::getView() ) )->( Eof() )

         ( ::oDocumentLineDatabase() )->( dbappend() )

         ::setGestoolIdDocument( ::oDocumentLineDatabase() )
         
         ::setGestoolSpecificLineDocument()

         ( ::oDocumentLineDatabase() )->cRef          := ( D():Kit( ::getView() ) )->cRefKit
         ( ::oDocumentLineDatabase() )->cAlmLin       := cDefAlm()
         ( ::oDocumentLineDatabase() )->nPosPrint     := nNumLin
         ( ::oDocumentLineDatabase() )->nNumLin       := nNumLin
         ( ::oDocumentLineDatabase() )->nNumKit       := nNumKit
         ( ::oDocumentLineDatabase() )->nUniCaja      := ( D():Kit( ::getView() ) )->nUndKit
         ( ::oDocumentLineDatabase() )->lKitChl       := .t.
         ( ::oDocumentLineDatabase() )->nTarLin       := 1
         ( ::oDocumentLineDatabase() )->dFecha        := ::getDate( oQuery:FieldGetByName( "date_add" ) )
         
         if ( D():gotoArticulos( ( D():Kit( ::getView() ) )->cRefKit, ::getView() ) )

            ( ::oDocumentLineDatabase() )->cDetalle    := ( D():Articulos( ::getView() ) )->Nombre
            ( ::oDocumentLineDatabase() )->mLngDes     := ( D():Articulos( ::getView() ) )->Descrip
            ( ::oDocumentLineDatabase() )->cUnidad     := ( D():Articulos( ::getView() ) )->cUnidad
            ( ::oDocumentLineDatabase() )->nPesoKg     := ( D():Articulos( ::getView() ) )->nPesoKg 
            ( ::oDocumentLineDatabase() )->cPesoKg     := ( D():Articulos( ::getView() ) )->cUnidad
            ( ::oDocumentLineDatabase() )->nVolumen    := ( D():Articulos( ::getView() ) )->nVolumen
            ( ::oDocumentLineDatabase() )->cVolumen    := ( D():Articulos( ::getView() ) )->cVolumen
            ( ::oDocumentLineDatabase() )->nCtlStk     := ( D():Articulos( ::getView() ) )->nCtlStock
            ( ::oDocumentLineDatabase() )->cCodTip     := ( D():Articulos( ::getView() ) )->cCodTip
            ( ::oDocumentLineDatabase() )->cCodFam     := ( D():Articulos( ::getView() ) )->Familia
            ( ::oDocumentLineDatabase() )->cGrpFam     := retfld( ( D():Articulos( ::getView() ) )->Familia, D():Familias( ::getView() ), "cCodGrp" )
            
            ( ::oDocumentLineDatabase() )->lLote       := ( D():Articulos( ::getView() ) )->lLote 
            ( ::oDocumentLineDatabase() )->cLote       := ( D():Articulos( ::getView() ) )->cLote 

            ( ::oDocumentLineDatabase() )->nIva        := nIva( D():TiposIva( ::getView() ), ( D():Articulos( ::getView() ) )->TipoIva )

         end if

         ( ::oDocumentLineDatabase() )->( dbunlock() )
            
         nNumKit++

         ( D():Kit( ::getView() ) )->( dbSkip() )

      end while

   end if

   ( D():Kit( ::getView() ) )->( OrdSetFocus( nOrdAnt ) )
   ( D():Kit( ::getView() ) )->( dbGoTo( nRec ) )

Return ( .t. )

//---------------------------------------------------------------------------//
         
METHOD setProductInDocumentLine( oQueryLine, lKitArt, cCodArt )

   local idProductGestool                 := oQueryLine:FieldGetByName( "product_reference" )

   if empty( idProductGestool )
      idProductGestool                    := ::TPrestashopId:getGestoolProduct( oQueryLine:FieldGetByName( "product_id" ), ::getCurrentWebName() )
   end if 

   if empty( idProductGestool )
      Return ( .f. )
   end if 

   if ( D():gotoArticulos( idProductGestool, ::getView() ) )

      ( ::oDocumentLineDatabase() )->cRef        := ( D():Articulos( ::getView() ) )->Codigo
      cCodArt                                    := ( D():Articulos( ::getView() ) )->Codigo
      ( ::oDocumentLineDatabase() )->cUnidad     := ( D():Articulos( ::getView() ) )->cUnidad
      ( ::oDocumentLineDatabase() )->nPesoKg     := ( D():Articulos( ::getView() ) )->nPesoKg
      ( ::oDocumentLineDatabase() )->cPesoKg     := ( D():Articulos( ::getView() ) )->cUnidad
      ( ::oDocumentLineDatabase() )->nVolumen    := ( D():Articulos( ::getView() ) )->nVolumen
      ( ::oDocumentLineDatabase() )->cVolumen    := ( D():Articulos( ::getView() ) )->cVolumen
      ( ::oDocumentLineDatabase() )->nCtlStk     := ( D():Articulos( ::getView() ) )->nCtlStock
      ( ::oDocumentLineDatabase() )->nCosDiv     := nCosto( ( D():Articulos( ::getView() ) )->Codigo, D():Articulos( ::getView() ), D():ArticulosCodigosBarras( ::getView() ) )
      ( ::oDocumentLineDatabase() )->cCodTip     := ( D():Articulos( ::getView() ) )->cCodTip
      ( ::oDocumentLineDatabase() )->cCodFam     := ( D():Articulos( ::getView() ) )->Familia
      ( ::oDocumentLineDatabase() )->cGrpFam     := retfld( ( D():Articulos( ::getView() ) )->Familia, D():Familias( ::getView() ), "cCodGrp" )
      
      ( ::oDocumentLineDatabase() )->lLote       := ( D():Articulos( ::getView() ) )->lLote 
      ( ::oDocumentLineDatabase() )->cLote       := ( D():Articulos( ::getView() ) )->cLote 

      ( ::oDocumentLineDatabase() )->cCodPr1     := ( D():Articulos( ::getView() ) )->cCodPrp1
      ( ::oDocumentLineDatabase() )->cCodPr2     := ( D():Articulos( ::getView() ) )->cCodPrp2
      ( ::oDocumentLineDatabase() )->cValPr1     := ::getProductProperty( ( D():Articulos( ::getView() ) )->cCodPrp1, oQueryLine:FieldGetByName( "product_name" ) )
      ( ::oDocumentLineDatabase() )->cValPr2     := ::getProductProperty( ( D():Articulos( ::getView() ) )->cCodPrp2, oQueryLine:FieldGetByName( "product_name" ) )

      ( ::oDocumentLineDatabase() )->lKitArt     := ( D():Articulos( ::getView() ) )->lKitArt

      lKitArt                                    := ( D():Articulos( ::getView() ) )->lKitArt

      Return ( .t. )

   end if

Return ( .f. )

//---------------------------------------------------------------------------//

METHOD getProductProperty( idPropertyGestool, productName ) CLASS TComercioDocument

   local productProperty      := ""
   local productPropertyName  := ::getNameProductProperty( idPropertyGestool, productName )

   if !empty( productPropertyName )
      Return ( productProperty )
   end if 
   
   if ( D():PropiedadesLineas( ::getView() ) )->( dbseekinord( upper( idPropertyGestool ) + upper( productPropertyName ), "cCodDes" ) )
      productProperty         := ( D():PropiedadesLineas( ::getView() ) )->cCodTbl      
   end if 

Return ( productProperty )

//---------------------------------------------------------------------------//

METHOD getNameProductProperty( idPropertyGestool, productName ) CLASS TComercioDocument

   local cPropertieCode       := ""
   local cPropertieName       := retFld( idPropertyGestool, D():Propiedades( ::getView() ), "cDesPro" ) 

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

               ( ::oDocumentIncidenciaDatabase() )->( dbappend() )

               ::setGestoolIdDocument( ::oDocumentIncidenciaDatabase() )

               ( ::oDocumentIncidenciaDatabase() )->dFecInc    := dFecha
               ( ::oDocumentIncidenciaDatabase() )->mDesInc    := oQueryMessage:FieldGetByName( "message" )
               ( ::oDocumentIncidenciaDatabase() )->lAviso     := .t.

               ( ::oDocumentIncidenciaDatabase() )->( dbunlock() )

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
                     "WHERE s.id_lang = " + ::TComercio:nLanguage + " and id_order = " + alltrim( str( ::idDocumentPrestashop ) )
   oQueryState    := TMSQuery():New( ::oConexionMySQLDatabase(), cQueryState  )

   if oQueryState:Open() .and. oQueryState:RecCount() > 0

      oQueryState:GoTop()

      while !oQueryState:Eof()

         ( ::oDocumentEstadoDatabase() )->( dbappend() )

         ::setGestoolIdDocument( ::oDocumentEstadoDatabase() )

         ( ::oDocumentEstadoDatabase() )->cSitua    := oQueryState:FieldGetByName( "name" )
         ( ::oDocumentEstadoDatabase() )->dFecSit   := ::getDate( oQueryState:FieldGetByName( "date_add" ) )
         ( ::oDocumentEstadoDatabase() )->tFecSit   := ::getTime( oQueryState:FieldGetByName( "date_add" ) )
         ( ::oDocumentEstadoDatabase() )->idPs      := oQueryState:FieldGetByName( "id_order_history" )
                  
         ( ::oDocumentEstadoDatabase() )->( dbunlock() )

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

   METHOD oDocumentHeaderDatabase()                     INLINE ( D():PresupuestosClientes( ::getView() )  )
   METHOD oDocumentLineDatabase()                       INLINE ( D():PresupuestosClientesLineas( ::getView() )  )
   METHOD oDocumentIncidenciaDatabase()                 INLINE ( D():PresupuestosClientesIncidencias( ::getView() ) )
   METHOD oDocumentEstadoDatabase()                     INLINE ( D():PresupuestosClientesSituaciones( ::getView() ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD isDocumentInGestool( idDocumentPrestashop ) CLASS TComercioBudget

   if empty( idDocumentPrestashop )
      Return .f.
   end if 

Return ( ( ::oDocumentHeaderDatabase() )->( dbseekInOrd( idDocumentPrestashop, "cSuPre" ) ) )

//---------------------------------------------------------------------------//

METHOD getCountersDocumentGestool( oQuery ) CLASS TComercioBudget

   ::idDocumentPrestashop  := oQuery:fieldGet( 1 )
   ::cSerieDocument        := ::TComercioConfig():getBudgetSerie()
   ::nNumeroDocument       := nNewDoc( ::cSerieDocument, ::oDocumentHeaderDatabase(), "nPreCli", , D():Contadores( ::getView() ) )
   ::cSufijoDocument       := retSufEmp()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD setGestoolIdDocument( oDatabase ) CLASS TComercioBudget

   ( oDatabase )->cSerPre  := ::cSerieDocument
   ( oDatabase )->nNumPre  := ::nNumeroDocument
   ( oDatabase )->cSufPre  := ::cSufijoDocument

Return ( self )

//---------------------------------------------------------------------------//

METHOD setGestoolSpecificDocument( oQuery ) CLASS TComercioBudget

   ( ::oDocumentHeaderDatabase() )->dFecPre  := ::getDate( oQuery:FieldGetByName( "date_add" ) )
   ( ::oDocumentHeaderDatabase() )->cTurPre  := cCurSesion()
   ( ::oDocumentHeaderDatabase() )->cSuPre   := oQuery:FieldGetByName( "reference" )
   ( ::oDocumentHeaderDatabase() )->lEstado  := .t.
   ( ::oDocumentHeaderDatabase() )->cDivPre  := cDivEmp()
   ( ::oDocumentHeaderDatabase() )->nVdvPre  := nChgDiv( cDivEmp(), D():Divisas( ::getView() ) )
   ( ::oDocumentHeaderDatabase() )->lCloPre  := .f.
   ( ::oDocumentHeaderDatabase() )->nTotPre  := oQuery:FieldGetByName( "total_paid_tax_incl" )

Return ( self )

//---------------------------------------------------------------------------//

METHOD setGestoolSpecificLineDocument() CLASS TComercioBudget

   ( ::oDocumentLineDatabase() )->nCanPre    := 1

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

   METHOD oDocumentHeaderDatabase()                     INLINE ( D():PedidosClientes( ::getView() )  )
   METHOD oDocumentLineDatabase()                       INLINE ( D():PedidosClientesLineas( ::getView() )  )
   METHOD oDocumentIncidenciaDatabase()                 INLINE ( D():PedidosClientesIncidencias( ::getView() ) )
   METHOD oDocumentEstadoDatabase()                     INLINE ( D():PedidosClientesSituaciones( ::getView() ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD isDocumentInGestool( idDocumentPrestashop ) CLASS TComercioOrder

   if empty( idDocumentPrestashop )
      Return .f.
   end if 

Return ( ( ::oDocumentHeaderDatabase() )->( dbseekInOrd( idDocumentPrestashop, "cSuPed" ) ) )

//---------------------------------------------------------------------------//

METHOD getCountersDocumentGestool( oQuery ) CLASS TComercioOrder

   ::idDocumentPrestashop  := oQuery:fieldGet( 1 )
   ::cSerieDocument        := ::TComercioConfig():getBudgetSerie()
   ::nNumeroDocument       := nNewDoc( ::cSerieDocument, ::oDocumentHeaderDatabase(), "nPedCli", , D():Contadores( ::getView() ) )
   ::cSufijoDocument       := retSufEmp()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD setGestoolIdDocument( oDatabase ) CLASS TComercioOrder

   ( oDatabase )->cSerPed  := ::cSerieDocument
   ( oDatabase )->nNumPed  := ::nNumeroDocument
   ( oDatabase )->cSufPed  := ::cSufijoDocument

Return ( self )

//---------------------------------------------------------------------------//

METHOD setGestoolSpecificDocument( oQuery ) CLASS TComercioOrder

   ( ::oDocumentHeaderDatabase() )->dFecPed  := ::getDate( oQuery:FieldGetByName( "date_add" ) ) 
   ( ::oDocumentHeaderDatabase() )->cTurPed  := cCurSesion()
   ( ::oDocumentHeaderDatabase() )->cSuPed   := oQuery:FieldGetByName( "reference" )
   ( ::oDocumentHeaderDatabase() )->cDivPed  := cDivEmp()
   ( ::oDocumentHeaderDatabase() )->nVdvPed  := nChgDiv( cDivEmp(), D():Divisas( ::getView() ) )
   ( ::oDocumentHeaderDatabase() )->lCloPed  := .f.
   ( ::oDocumentHeaderDatabase() )->nTotPed  := oQuery:FieldGetByName( "total_paid_tax_incl" )

Return ( self )

//---------------------------------------------------------------------------//

METHOD setGestoolSpecificLineDocument() CLASS TComercioOrder

   ( ::oDocumentLineDatabase() )->nCanPed    := 1

Return ( self )

//---------------------------------------------------------------------------//

METHOD setPrestashopIdDocument() CLASS TComercioOrder

   ::TPrestashopId():setGestoolOrder( ::idDocumentGestool(), ::getCurrentWebName(), ::idDocumentPrestashop )

Return ( self )

//---------------------------------------------------------------------------//
