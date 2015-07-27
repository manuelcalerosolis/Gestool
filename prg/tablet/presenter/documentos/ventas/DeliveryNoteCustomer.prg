#include "FiveWin.Ch"
#include "Factu.ch"
#include "Xbrowse.ch"

CLASS DeliveryNoteCustomer FROM DocumentsSales  

   DATA oLinesDeliveryNoteCustomer

   DATA cTextSummaryDocument              INIT "Resumen albarán"

   METHOD New()

   METHOD setEnviroment()                 INLINE ( ::setDataTable( "AlbCliT" ),;
                                                ::setDataTableLine( "AlbCliL" ),;
                                                ( ::getWorkArea() )->( OrdSetFocus( "dFecDes" ) ), ( ::getWorkArea() )->( dbgotop() ) )

   METHOD Resource( nMode )

   METHOD ResourceDetail( nMode )         INLINE ( ::oLinesDeliveryNoteCustomer:ResourceDetail( nMode ) )

   METHOD GetAppendDocumento()
   METHOD GetEditDocumento()

   METHOD getLinesDocument( id )
   METHOD addDocumentLine()
   METHOD getDocumentLine()

   METHOD getLines()                      INLINE ( ::oDocumentLines:getLines() )
   METHOD getLineDetail()                 INLINE ( ::oDocumentLines:getLineDetail( ::nPosDetail ) )

   METHOD onPreSaveAppendDocumento()
   METHOD GetAppendDetail()
   METHOD GetEditDetail()
   METHOD deleteLinesDocument()

   METHOD SetDocuments()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS DeliveryNoteCustomer

   ::super:New( self )

   ::oViewSearchNavigator:setTextoTipoDocumento( "Albaranes de clientes" )  

   ::oLinesDeliveryNoteCustomer           := LinesDeliveryNoteCustomer():New( self )

return ( self )

//---------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS DeliveryNoteCustomer

   local lResource   := .f.

   if !Empty( ::oViewEdit )

      ::oViewEdit:SetTextoTipoDocumento( LblTitle( nMode ) + "albarán" )
      
      lResource      := ::oViewEdit:Resource( nMode )

   end if

Return ( lResource )   

//---------------------------------------------------------------------------//

METHOD GetAppendDocumento() CLASS DeliveryNoteCustomer

   ::hDictionaryMaster      := D():GetDefaultHashAlbaranCliente( ::nView )

Return ( self )

//---------------------------------------------------------------------------//

METHOD GetEditDocumento() CLASS DeliveryNoteCustomer

   local id                := D():AlbaranesClientesId( ::nView )

   ::hDictionaryMaster     := D():getAlbaranCliente( ::nView )

   ::getLinesDocument( id )

Return ( self )

//---------------------------------------------------------------------------//
//
// Convierte las lineas del albaran en objetos
//

METHOD getLinesDocument( id ) CLASS DeliveryNoteCustomer

   ::oDocumentLines:reset()

   D():getStatusAlbaranesClientesLineas( ::nView )

   ( D():AlbaranesClientesLineas( ::nView ) )->( ordSetFocus( 1 ) )

   if ( D():AlbaranesClientesLineas( ::nView ) )->( dbSeek( id ) )  

      while ( D():AlbaranesClientesLineasId( ::nView ) == id ) .and. !( D():AlbaranesClientesLineas( ::nView ) )->( eof() ) 

         ::addDocumentLine()
      
         ( D():AlbaranesClientesLineas( ::nView ) )->( dbSkip() ) 
      
      end while

   end if 
   
   D():setStatusAlbaranesClientesLineas( ::nView ) 

RETURN ( self ) 

//---------------------------------------------------------------------------//

METHOD addDocumentLine() CLASS DeliveryNoteCustomer

   local oDocumentLine  := ::getDocumentLine()

   if !empty( oDocumentLine )
      ::oDocumentLines:addLines( oDocumentLine )
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD getDocumentLine() CLASS DeliveryNoteCustomer

   local hLine    := D():GetAlbaranClienteLineasHash( ::nView )

   if empty( hLine )
      Return ( nil )
   end if 

Return ( DocumentLine():New( hLine, self ) )

//---------------------------------------------------------------------------//

METHOD onPreSaveAppendDocumento() CLASS DeliveryNoteCustomer

   local lPreSaveDocument  := .f.
   local NumeroDocumento   := nNewDoc( ::getSerie(), D():AlbaranesClientes( ::nView ), "nAlbCli", , D():Contadores( ::nView ) )
   local nTotAlb           := ::oTotalDocument:getTotalDocument()
   local nTotIVA           := ::oTotalDocument:getImporteIva()
   local nTotReq           := ::oTotalDocument:getImporteRecargo()
   local nTotNeto          := ::oTotalDocument:getBase()

   if !empty( NumeroDocumento )
      hSet( ::hDictionaryMaster, "Numero", NumeroDocumento )
      lPreSaveDocument     := .t.
   end if 

   if !empty( nTotAlb )
      hSet( ::hDictionaryMaster, "TotalDocumento", nTotAlb )
      lPreSaveDocument        := .t.
   end if

   if !empty( nTotIVA )
      hSet( ::hDictionaryMaster, "TotalImpuesto", nTotIVA )
      lPreSaveDocument     := .t.
   end if

   if !empty( nTotReq )
      hSet( ::hDictionaryMaster, "TotalRecargo", nTotReq )
      lPreSaveDocument     := .t.
   end if

   if !empty( nTotNeto )
      hSet( ::hDictionaryMaster, "TotalNeto", nTotNeto )
      lPreSaveDocument     := .t.
   end if

Return ( lPreSaveDocument )

//---------------------------------------------------------------------------//

METHOD GetAppendDetail() CLASS DeliveryNoteCustomer

   local hLine             := D():GetAlbaranClienteLineaBlank( ::nView )
   ::oDocumentLineTemporal := DocumentLine():New( hLine, self )

Return ( self )

//---------------------------------------------------------------------------//

METHOD GetEditDetail() CLASS DeliveryNoteCustomer

   if !Empty( ::nPosDetail )
      ::oDocumentLineTemporal   := ::oDocumentLines:getCloneLineDetail( ::nPosDetail )
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD deleteLinesDocument() CLASS DeliveryNoteCustomer

   D():getStatusAlbaranesClientesLineas( ::nView )

   ( D():AlbaranesClientesLineas( ::nView ) )->( ordSetFocus( 1 ) )

   while ( D():AlbaranesClientesLineas( ::nView ) )->( dbSeek( ::getID() ) ) 
      ::delDocumentLine()
   end while

   D():setStatusAlbaranesClientesLineas( ::nView ) 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD SetDocuments() CLASS DeliveryNoteCustomer

   local cSerie         := hGet( ::hDictionaryMaster, "Serie" )
   local cDocumento     := ""
   local cFormato
   local nFormato
   local aFormatos      := aDocs( "AB", D():Documentos( ::nView ), .t. )

   cFormato             := cFormatoDocumento( cSerie, "nAlbCli", D():Contadores( ::nView ) )

   if Empty( cFormato )
      cFormato          := cFirstDoc( "AB", D():Documentos( ::nView ) )
   end if

   nFormato             := aScan( aFormatos, {|x| Left( x, 3 ) == cFormato } )
   nFormato             := Max( Min( nFormato, len( aFormatos ) ), 1 )

   ::oViewEditResumen:SetImpresoras( aFormatos )
   ::oViewEditResumen:SetImpresoraDefecto( aFormatos[ nFormato ] )

return ( .t. )

//---------------------------------------------------------------------------//