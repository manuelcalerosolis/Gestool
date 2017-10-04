#include "FiveWin.Ch"
#include "Factu.ch" 

//--------------------------------*-------------------------------------------//

CLASS TGenMailingDatabaseFacturasClientes FROM TGenMailingDatabase 

   METHOD New( nView )

   METHOD columnPageDatabase( oDlg )   

   METHOD getPara()              INLINE ( alltrim( retFld( ( D():FacturasClientes( ::nView ) )->cCodCli, D():Clientes( ::nView ), "cMeiInt" ) ) )
   METHOD getAdjunto()           INLINE ( mailReportFacCli() )

   METHOD setFacturasCleintesSend( hMail )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS TGenMailingDatabaseFacturasClientes

   ::Create()

   ::Super:New( nView )

   ::setItems( aItmFacCli() )

   ::setWorkArea( D():FacturasClientes( nView ) )

   ::setOrderDatabase( { "Número", "Fecha", "Código", "Nombre" } )

   ::setTypeDocument( "nFacCli" )

   ::setBmpDatabase( "gc_document_text_user2_48" )

   ::setAsunto( "Envio de nuestra factura de cliente {Serie de la factura}/{Número de la factura}" )

   ::setPostSend( {|hMail| ::setFacturasCleintesSend( hMail ) } )

   ::setCargo( {|| D():FacturasClientesId( nView ) } )

   ( ::getWorkArea() )->( ordsetfocus( "lMail" ) )
   ( ::getWorkArea() )->( dbgotop() )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD columnPageDatabase( oDlg ) CLASS TGenMailingDatabaseFacturasClientes

   with object ( ::oBrwDatabase:AddCol() )
      :cHeader          := "Se. seleccionado"
      :cSortOrder       := "lMail"
      :bStrData         := {|| "" }
      :bEditValue       := {|| ( ::getWorkArea() )->lMail }
      :nWidth           := 20
      :SetCheck( { "Sel16", "Nil16" } )
   end with

   with object ( ::oBrwDatabase:AddCol() )
      :cHeader          := "Número"
      :cSortOrder       := "nNumFac"
      :bEditValue       := {|| ( ::getWorkArea() )->cSerie + "/" + alltrim( str( ( ::getWorkArea() )->nNumFac ) ) }
      :nWidth           := 80
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::oOrderDatabase:Set( oCol:cHeader ) }
   end with

   with object ( ::oBrwDatabase:AddCol() )
      :cHeader          := "Fecha"
      :cSortOrder       := "dFecDes"
      :bEditValue       := {|| dtoc( ( ::getWorkArea() )->dFecFac ) }
      :nWidth           := 80
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::oOrderDatabase:Set( oCol:cHeader ) }
   end with

   with object ( ::oBrwDatabase:AddCol() )
      :cHeader          := "Código"
      :cSortOrder       := "cCodCli"
      :bEditValue       := {|| ( ::getWorkArea() )->cCodCli }
      :nWidth           := 70
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::oOrderDatabase:Set( oCol:cHeader ) }
   end with

   with object ( ::oBrwDatabase:AddCol() )
      :cHeader          := "Nombre"
      :cSortOrder       := "cNomCli"
      :bEditValue       := {|| ( ::getWorkArea() )->cNomCli }
      :nWidth           := 300
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::oOrderDatabase:Set( oCol:cHeader ) }
   end with

   with object ( ::oBrwDatabase:AddCol() )
      :cHeader          := "Total"
      :bEditValue       := {|| ( ::getWorkArea() )->nTotFac }
      :cEditPicture     := cPorDiv()
      :nWidth           := 80
      :nDataStrAlign    := 1
      :nHeadStrAlign    := 1
   end with

Return ( Self )   

//---------------------------------------------------------------------------//

METHOD setFacturasCleintesSend( hMail ) CLASS TGenMailingDatabaseFacturasClientes

   local idFactura

   if !hhaskey( hMail, "cargo" )
      Return .f.
   end if 

   idFactura         := hGet( hMail, "cargo" )

   if dbSeekInOrd( idFactura, "nNumFac", D():FacturasClientes( ::nView ) ) 

      if ( D():FacturasClientes( ::nView ) )->( dbrlock() )
         ( D():FacturasClientes( ::nView ) )->lMail   := .f.
         ( D():FacturasClientes( ::nView ) )->tMail   := DateTime()
         ( D():FacturasClientes( ::nView ) )->( dbunlock() )
      end if

   end if 

Return ( .t. )   

//---------------------------------------------------------------------------//
