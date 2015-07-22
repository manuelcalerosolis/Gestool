#include "FiveWin.Ch"
#include "Factu.ch"

CLASS OrderCustomer FROM DocumentsSales  

   DATA oViewEdit

   DATA oCliente

   DATA oDocumentLines

   DATA oLinesOrderCustomer

   DATA cTextSummaryDocument             INIT "Resumen pedido"

   METHOD New()

   METHOD getSerie()                   INLINE ( hGet( ::hDictionaryMaster, "Serie" ) )
   METHOD getNumero()                  INLINE ( hGet( ::hDictionaryMaster, "Numero" ) )
   METHOD getSufijo()                  INLINE ( hGet( ::hDictionaryMaster, "Sufijo" ) )

   METHOD getID()                      INLINE ( ::getSerie() + str( ::getNumero() ) + ::getSufijo() )

   METHOD isPuntoVerde()               INLINE ( hGet( ::hDictionaryMaster, "OperarPuntoVerde" ) )

   METHOD isRecargoEquivalencia()      INLINE ( hGet( ::hDictionaryMaster, "lRecargo" ) )

   METHOD setEnviroment()              INLINE ( ::setDataTable( "PedCliT" ),;
                                                ::setDataTableLine( "PedCliL" ),;
                                                ::setDataTableLineID( D():PedidosClientesLineasId( ::nView ) ),;
                                                ( ::getWorkArea() )->( OrdSetFocus( "dFecDes" ) ), ( ::getWorkArea() )->( dbgotop() ) )

   METHOD setNavigator()

   METHOD Resource( nMode )

   METHOD ResourceDetail( nMode )      INLINE ( ::oLinesOrderCustomer:ResourceDetail( nMode ) )

   METHOD GetAppendDocumento()

   METHOD GetEditDocumento()

   METHOD GetAppendDetail()
   
   METHOD GetEditDetail()

   METHOD StartResourceDetail()

   METHOD onClickRotor()                  INLINE ( ::oCliente:edit() )

   METHOD getLinesDocument()

   METHOD getDocumentLine()

   METHOD addDocumentLine()

   METHOD getLines()                      INLINE ( ::oDocumentLines:getLines() )
   METHOD getLineDetail()                 INLINE ( ::oDocumentLines:getLineDetail( ::nPosDetail ) )

   METHOD SetDocuments()

   METHOD saveEditDocumento()  
   METHOD deleteLinesDocument() 
   METHOD delDocumentLine()               INLINE ( D():deleteRecord( "PedCliL", ::nView ) )
   METHOD saveAppendDocumento()

   METHOD assignLinesDocument()
   METHOD setLinesDocument()
   METHOD appendDocumentLine( oDocumentLine ) INLINE ( D():appendHashRecord( oDocumentLine:hDictionary, "PedCliL", ::nView ) )

   METHOD onPreSaveAppendDocumento()
   METHOD onPreSaveEditDocumento()

   METHOD setViewEditDetail()             INLINE ( ::oViewEditDetail := ::oLinesOrderCustomer:oViewEditDetail )

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS OrderCustomer

   if !::OpenFiles()
      Return ( self )
   end if 

   ::oViewSearchNavigator  := OrderCustomerViewSearchNavigator():New( self )

   ::oViewEdit             := OrderCustomerViewEdit():New( self )

   ::oCliente              := Customer():Init( self )  

   ::oDocumentLines        := DocumentLines():New( self ) 

   ::oTotalDocument        := TotalDocument():New( self )

   ::oLinesOrderCustomer   := LinesOrderCustomer():New( self )

   ::setEnviroment()

   ::setNavigator()

   ::CloseFiles()

return ( self )

//---------------------------------------------------------------------------//

METHOD setNavigator() CLASS OrderCustomer

   if !Empty( ::oViewSearchNavigator )
      ::oViewSearchNavigator:Resource()
   end if

return ( self )

//---------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS OrderCustomer

   local lResource   := .f.

   if !Empty( ::oViewEdit )

      ::oViewEdit:SetTextoTipoDocumento( LblTitle( nMode ) + "pedido" )
      
      lResource      := ::oViewEdit:Resource( nMode )

   end if

Return ( lResource )   

//---------------------------------------------------------------------------//

/*METHOD ResourceDetail( nMode ) CLASS OrderCustomer

   local lResult     := .f.

   ::oViewEditDetail := ViewDetail():New( self )

   if !Empty( ::oViewEditDetail )

      ::oViewEditDetail:SetTextoTipoDocumento( LblTitle( nMode ) + "linea de pedido" )

      lResult        := ::oViewEditDetail:Resource( nMode )

   end if

Return ( lResult )*/

//---------------------------------------------------------------------------//

METHOD StartResourceDetail() CLASS OrderCustomer

   ::cargaArticulo()

   ::recalcularTotal()

Return ( self )

//---------------------------------------------------------------------------//

METHOD GetAppendDocumento() CLASS OrderCustomer

   ::hDictionaryMaster      := D():GetPedidoClienteDefaultValue( ::nView )
   ::hDictionaryDetail      := {}

Return ( self )

//---------------------------------------------------------------------------//

METHOD GetEditDocumento() CLASS OrderCustomer

   local id                := D():PedidosClientesId( ::nView )

   ::hDictionaryMaster     := D():GetPedidoClienteById( id, ::nView )

   ::getLinesDocument( id )

RETURN ( self ) 

//---------------------------------------------------------------------------//
//
// Convierte las lineas del pedido en objetos
//

METHOD getLinesDocument( id ) CLASS OrderCustomer

   ::oDocumentLines:reset()

   D():getStatusPedidosClientesLineas( ::nView )

   ( D():PedidosClientesLineas( ::nView ) )->( ordSetFocus( 1 ) )

   if ( D():PedidosClientesLineas( ::nView ) )->( dbSeek( id ) )  

      while ( D():PedidosClientesLineasId( ::nView ) == id ) .and. !( D():PedidosClientesLineas( ::nView ) )->( eof() ) 

         ::addDocumentLine()
      
         ( D():PedidosClientesLineas( ::nView ) )->( dbSkip() ) 
      
      end while

   end if 
   
   D():setStatusPedidosClientesLineas( ::nView ) 

RETURN ( self ) 

//---------------------------------------------------------------------------//

METHOD addDocumentLine() CLASS OrderCustomer

   local oDocumentLine  := ::getDocumentLine()

   if !empty( oDocumentLine )
      ::oDocumentLines:addLines( oDocumentLine )
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD getDocumentLine() CLASS OrderCustomer

   local hLine    := D():GetPedidoClienteLineasHash( ::nView )

   if empty( hLine )
      Return ( nil )
   end if 

Return ( DocumentLine():New( hLine, self ) )

//---------------------------------------------------------------------------//

METHOD getAppendDetail() CLASS OrderCustomer

   local hLine             := D():GetPedidoClienteLineaBlank( ::nView )
   ::oDocumentLineTemporal := DocumentLine():New( hLine, self )

Return ( self )

//---------------------------------------------------------------------------//

METHOD GetEditDetail() CLASS OrderCustomer

   if !Empty( ::nPosDetail )
      ::oDocumentLineTemporal   := ::oDocumentLines:getCloneLineDetail( ::nPosDetail )
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD SetDocuments() CLASS OrderCustomer

   local cSerie         := hGet( ::hDictionaryMaster, "Serie" )
   local cDocumento     := ""
   local cFormato
   local nFormato
   local aFormatos      := aDocs( "PC", D():Documentos( ::nView ), .t. )

   cFormato             := cFormatoDocumento( cSerie, "nPedCli", D():Contadores( ::nView ) )

   if Empty( cFormato )
      cFormato          := cFirstDoc( "PC", D():Documentos( ::nView ) )
   end if

   nFormato             := aScan( aFormatos, {|x| Left( x, 3 ) == cFormato } )
   nFormato             := Max( Min( nFormato, len( aFormatos ) ), 1 )

   ::oViewEditResumen:SetImpresoras( aFormatos )
   ::oViewEditResumen:SetImpresoraDefecto( aFormatos[ nFormato ] )

return ( .t. )

//---------------------------------------------------------------------------//

METHOD saveEditDocumento() CLASS OrderCustomer            

   ::Super:saveEditDocumento()

   ::deleteLinesDocument()

   ::assignLinesDocument()   

   ::setLinesDocument()

return ( .t. )

//---------------------------------------------------------------------------//

METHOD saveAppendDocumento() CLASS OrderCustomer

   ::Super:saveAppendDocumento()

   ::assignLinesDocument()

   ::setLinesDocument()

return ( .t. )

//---------------------------------------------------------------------------//

METHOD deleteLinesDocument() CLASS OrderCustomer

local id    := hGet( ::hDictionaryMaster, "Serie" ) + Str( hGet( ::hDictionaryMaster, "Numero" ) ) + hGet( ::hDictionaryMaster, "Sufijo" )

   D():getStatusPedidosClientesLineas( ::nView )

   ( D():PedidosClientesLineas( ::nView ) )->( ordSetFocus( 1 ) )

   while ( D():PedidosClientesLineas( ::nView ) )->( dbSeek( id ) ) 
      ::delDocumentLine()
   end while

   D():setStatusPedidosClientesLineas( ::nView ) 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD assignLinesDocument() CLASS OrderCustomer

   local oDocumentLine
   Local nNumeroLinea   := 0

   for each oDocumentLine in ::oDocumentLines:aLines
      oDocumentLine:setNumeroLinea( ++nNumeroLinea )
      oDocumentLine:setSerieMaster()
      oDocumentLine:setNumeroMaster()
      oDocumentLine:setSufijoMaster()
   next

Return( self )

//---------------------------------------------------------------------------//

METHOD setLinesDocument() CLASS OrderCustomer

   local oDocumentLine

   for each oDocumentLine in ::oDocumentLines:aLines
      ::appendDocumentLine( oDocumentLine )
   next

RETURN ( self ) 

//---------------------------------------------------------------------------//

METHOD onPreSaveAppendDocumento() CLASS OrderCustomer

   local lPreSaveDocument  := .f.
   local NumeroDocumento   := nNewDoc( ::hDictionaryMaster[ "Serie" ], D():PedidosClientes( ::nView ), "nPedCli", , D():Contadores( ::nView ) )
   local nTotPed           := ::oTotalDocument:getTotalDocument()

   if !empty( NumeroDocumento )
      lPreSaveDocument     := .t.
      hSet( ::hDictionaryMaster, "Numero", NumeroDocumento )
   end if 

   if !empty( nTotPed )
      hSet( ::hDictionaryMaster, "TotalDocumento", nTotPed )
      lPreSaveDocument        := .t.
   end if

Return ( lPreSaveDocument )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD onPreSaveEditDocumento() CLASS OrderCustomer

   Local lPreSaveDocument     := .f.
   local nTotPed              := ::oTotalDocument:getTotalDocument()

   if !empty( nTotPed )
      hSet( ::hDictionaryMaster, "TotalDocumento", nTotPed )
      lPreSaveDocument        := .t.
   end if

Return ( lPreSaveDocument )

//---------------------------------------------------------------------------//

