#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS DeliveryNoteCustomerViewSearchNavigator FROM ViewSearchNavigator


   METHOD getDataTable()               INLINE ( ::oSender:getDataTable() )

   METHOD setTextoTipoDocumento( cName )      INLINE ( ::cTextoTipoDocumento := cName ) 

   METHOD setItemsBusqueda( aItems )   INLINE ( ::aItemsBusqueda := { "Número", "Fecha", "Código", "Nombre" } )   

   METHOD setColumns()

   METHOD getField( cField )           INLINE ( D():getFieldDictionary( cField, ::getDataTable(), ::getView() )

END CLASS

//---------------------------------------------------------------------------//

METHOD setColumns() CLASS DeliveryNoteCustomerViewSearchNavigator

   ::setBrowseConfigurationName( ::cTextoTipoDocumento )

   with object ( ::addColumn() )
      :cHeader           := "Id"
      :bEditValue        := {||  ::getField( "Serie" ) + "/" + alltrim(str(::getField( "Numero" ))) + "/" + alltrim(::getField( "Sufijo" )) + CRLF +;
                                 dtoc( ::getField( "Fecha") }
      :nWidth            := 160
   end with

   with object ( ::addColumn() )
      :cHeader           := "Cliente"
      :bEditValue        := {|| AllTrim( ::getField( "Cliente" ) ) + CRLF + AllTrim( ::getField( "NombreCliente" ) ) }
      :nWidth            := 320
   end with

   with object ( ::addColumn() )
      :cHeader           := "Base"
      :bEditValue        := {|| ::getField( "TotalNeto" ) }
      :cEditPicture      := cPorDiv()
      :nWidth            := 80
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
      :lHide             := .t.
   end with

   with object ( ::addColumn() )
      :cHeader           := cImp()
      :bEditValue        := {|| ::getField( "TotalImpuesto" ) }
      :cEditPicture      := cPorDiv()
      :nWidth            := 80
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
      :lHide             := .t.
   end with

   with object ( ::addColumn() )
      :cHeader           := "R.E."
      :bEditValue        := {|| ::getField( "TotalRecargo" ) }
      :cEditPicture      := cPorDiv()
      :nWidth            := 80
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
      :lHide             := .t.
   end with

   with object ( ::addColumn() )
      :cHeader           := "Total"
      :bEditValue        := {|| ::getField( "TotalDocumento" ) }
      :cEditPicture      := cPorDiv()
      :nWidth            := 190
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
   end with

Return ( self )

//---------------------------------------------------------------------------//