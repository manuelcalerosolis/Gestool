#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TGenMailingClientes FROM TGenMailingDatabase 

   METHOD New( nView )

   METHOD getPara()        INLINE ( ( ::getWorkArea() )->cMeiInt )
   
END CLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS TGenMailingClientes

   ::Create()

   ::setItems( aItmCli() )

   ::setWorkArea( D():Clientes( nView ) )

   ::setBlockRecipients( {|| ( D():Clientes( nView ) )->cMeiInt } )

   ::oSendMail       := TSendMail():New( Self )

   ::oTemplateHtml   := TemplateHtml():New( Self )

   ::oFilter         := TFilterCreator():Init( Self )   
   ::oFilter:SetFields( aItmCli() )

   ::cBmpDatabase    := "gc_businessman_48"

Return ( Self )

//---------------------------------------------------------------------------//

CLASS TGenMailingProveedores FROM TGenMailingDatabase 

   METHOD New( dbfProveedores )
   
END CLASS

//---------------------------------------------------------------------------//

METHOD New( dbfProveedores ) CLASS TGenMailingProveedores

   ::Create()

   ::setItems( aItmPrv() )
   
   ::setWorkArea( dbfProveedores ) 

   ::oSendMail       := TSendMail():New( Self )

   ::oTemplateHtml   := TemplateHtml():New( Self )

   ::oFilter         := TFilterCreator():Init( Self )   
   ::oFilter:SetFields( aItmPrv() )

   ::cBmpDatabase    := "gc_businessman_48"

Return ( Self )

//---------------------------------------------------------------------------//
