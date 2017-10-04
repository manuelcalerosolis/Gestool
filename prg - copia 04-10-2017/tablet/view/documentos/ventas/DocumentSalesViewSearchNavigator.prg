#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS DocumentSalesViewSearchNavigator FROM ViewSearchNavigator

   METHOD getDataTable()                  INLINE ( ::oSender:getDataTable() )

   METHOD getView()                       INLINE ( ::oSender:nView )

   METHOD setItemsBusqueda()              INLINE ( ::hashItemsSearch := { "Fecha" => "dFecDes", "Número" => 1, "Código" => "cCodCli", "Nombre" => "cNomCli" } )   

   METHOD setColumns()

   METHOD getField( cField )              INLINE ( D():getFieldDictionary( cField, ::getDataTable(), ::getView() ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD setColumns() CLASS DocumentSalesViewSearchNavigator

   ::setBrowseConfigurationName( "grid_ventas" )

   with object ( ::addColumn() )
      :cHeader          := "Envio"
      :nHeadBmpNo       := 3
      :bStrData         := {|| "" }
      :bEditValue       := {|| ::getField( "Envio" ) }
      :nWidth           := 33
      :lHide            := .t.
      :SetCheck( { "gc_mail2_24", "Nil16" } )
      :AddResource( "gc_mail2_24" )
   end with

   with object ( ::addColumn() )
      :cHeader           := "Id"
      :bEditValue        := {|| ::getField( "Serie" ) + "/" + alltrim( str( ::getField( "Numero" ) ) ) + CRLF + dtoc( ::getField( "Fecha" ) ) }
      :nWidth            := 165
   end with

   with object ( ::addColumn() )
      :cHeader           := "Cliente"
      :bEditValue        := {|| alltrim( ::getField( "Cliente" ) ) + CRLF + alltrim( ::getField( "NombreCliente" ) ) }
      :nWidth            := 310
   end with

   with object ( ::addColumn() )
      :cHeader           := "Agente"
      :bEditValue        := {|| ::getField( "Agente" ) }
      :nWidth            := 100
      :lHide             := .t.
   end with

   with object ( ::addColumn() )
      :cHeader           := "Base"
      :bEditValue        := {|| ::getField( "TotalNeto" ) }
      :cEditPicture      := cPorDiv()
      :nWidth            := 100
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
      :lHide             := .t.
   end with

   with object ( ::addColumn() )
      :cHeader           := cImp()
      :bEditValue        := {|| ::getField( "TotalImpuesto" ) }
      :cEditPicture      := cPorDiv()
      :nWidth            := 100
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
      :lHide             := .t.
   end with

   with object ( ::addColumn() )
      :cHeader           := "R.E."
      :bEditValue        := {|| ::getField( "TotalRecargo" ) }
      :cEditPicture      := cPorDiv()
      :nWidth            := 100
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
      :lHide             := .t.
   end with

   with object ( ::addColumn() )
      :cHeader           := "Total"
      :bEditValue        := {|| ::getField( "TotalDocumento" ) }
      :cEditPicture      := cPorDiv()
      :nWidth            := 155
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
   end with

Return ( self )

//---------------------------------------------------------------------------//