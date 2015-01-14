#include "FiveWin.Ch"
#include "Factu.ch" 

//--------------------------------*-------------------------------------------//

CLASS TGenMailingSerialDocuments FROM TGenMailingDatabase 

   METHOD New( nView )

   METHOD columnPageDatabase( oDlg )   

   //METHOD iniciarProceso()

   METHOD getPara()              INLINE ( alltrim( retFld( ( D():FacturasClientes( ::nView ) )->cCodCli, D():Clientes( ::nView ), "cMeiInt" ) ) )
   METHOD getAdjunto()           INLINE ( mailReportFacCli() )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS TGenMailingSerialDocuments

   ::Create()

   ::Super:New( nView )

   ::setItems( aItmFacCli() )

   ::setWorkArea( D():FacturasClientes( nView ) )

   ::setOrderDatabase( { "Número", "Fecha", "Código", "Nombre" } )

   ::setTypeDocument( "nFacCli" )

   ::setBmpDatabase( "Factura_cliente_48_alpha" )

   ( ::getWorkArea() )->( ordsetfocus( "lMail" ) )
   ( ::getWorkArea() )->( dbgotop() )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD columnPageDatabase( oDlg ) CLASS TGenMailingSerialDocuments

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
/*
METHOD IniciarProceso() CLASS TGenMailingSerialDocuments

   local aDatabaseList    

   aDatabaseList          := ::getDatabaseList()
   if !empty( aDatabaseList )
      msgAlert( valtoprg( aDatabaseList ) )
   else
      msgStop( "No hay direcciones de correos para mandar.")
   end if 

Return ( self )
*/
//---------------------------------------------------------------------------//

