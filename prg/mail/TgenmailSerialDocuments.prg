#include "FiveWin.Ch"
#include "Factu.ch" 

//--------------------------------*-------------------------------------------//

CLASS TGenMailingSerialDocuments FROM TGenMailingDatabase 

   METHOD New( nView )

   METHOD columnPageDatabase( oDlg )   
   
END CLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS TGenMailingSerialDocuments

   ::Create()

   ::Super:New( aItmFacCli(), D():FacturasClientes( nView ) )

   ::setOrderDatabase( { "Número", "Fecha", "Código", "Nombre", "Población", "Dirección" } )

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