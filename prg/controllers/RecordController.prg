#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS RecordController FROM SQLBaseController

   METHOD New()

   METHOD getModel()             INLINE ( ::oController:oModel() )

   METHOD getBuffer( cColumn )   INLINE ( ::getModel():getBuffer( cColumn ) )

   METHOD setItems()

   METHOD Edit()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS RecordController

   ::Super:New( oController )

   ::oDialogView           := RecordView():New( self )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Edit() CLASS RecordController

   ::setItems()

   ::oDialogView:Activate()

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD setItems() CLASS RecordController

   local aItems   := {}

   aadd( aItems,  {  'clave'  => 'empresa',;     
                     'valor'  => ::getBuffer( "empresa" ),;     
                     'tipo'   => "C" } )

   aadd( aItems,  {  'clave'  => 'id',;          
                     'valor'  => alltrim(str( ::getBuffer( "id" ) ) ),;          
                     'tipo'   => "C" } )

   aadd( aItems,  {  'clave'  => 'uuid',;        
                     'valor'  => ::getBuffer( "uuid" ),;        
                     'tipo'   => "C" } )

   aadd( aItems,  {  'clave'  => 'creado',;      
                     'valor'  => hb_ttoc( ::getBuffer( "creado" ) ),;      
                     'tipo'   => "D" } )

   aadd( aItems,  {  'clave'  => 'modificado',;  
                     'valor'  => hb_ttoc( ::getBuffer( "modificado" ) ),;  
                     'tipo'   => "D" } )

   aadd( aItems,  {  'clave'  => 'enviado',;     
                     'valor'  => hb_ttoc( ::getBuffer( "enviado" ) ),;     
                     'tipo'   => "B",; 
                     'lista'  => { "NULL" } } )

   ::oDialogView:setItems( aItems )

RETURN ( nil )

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

CLASS RecordView FROM ConfiguracionesView

END CLASS

//---------------------------------------------------------------------------//


