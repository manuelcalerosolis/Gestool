#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS PdaEnvioRecepcionController

   DATA oDialogView

   DATA aJson

   METHOD New()
   METHOD End()

   METHOD Activate()

   METHOD exportJson()

   METHOD exportArticulosJson()

   METHOD exportUsuariosJson()   

   METHOD buildArticuloJson()

   METHOD writeArticulosJson()

   METHOD buildUsuariosJson()

   METHOD writeUsuariosJson()

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::oDialogView        := PdaEnvioRecepcionView():New( Self )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Activate()

   ::oDialogView:Activate()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD exportJson()

   ::exportArticulosJson()

   ::exportUsuariosJson()

   msgInfo( "Proceso finalizado" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD exportArticulosJson() 

   local cArea    := "ArtJson"

   ::aJson        := {}

   ArticulosModel():getArticulosToJson( @cArea ) 

   ::oDialogView:oProgress:setTotal( ( cArea )->( lastrec() ) )

   while !( cArea )->( eof() )

      aadd( ::aJson, ::buildArticuloJson( cArea ) )

      ::oDialogView:oProgress:AutoInc()

      ( cArea )->( dbskip() )

   end while

   CLOSE ( cArea )

   ::writeArticulosJson()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD buildArticuloJson( cArea )

   local hJson    := {=>}
   local aCodebar := {}

   hset( hJson, "id", alltrim( ( cArea )->Codigo ) )
   hset( hJson, "nombre", alltrim( ( cArea )->Nombre ) )
   hset( hJson, "uuid", alltrim( ( cArea )->uuid ) )
   hset( hJson, "precio_venta", ( cArea )->pVenta1 )
   hset( hJson, "porcentaje_iva", ( cArea )->tpIva )
   hset( hJson, "precio_impuestos_incluidos", ( cArea )->pVtaIva1 )

   aadd( aCodebar, alltrim( ( cArea )->Codigo ) )

   if !empty( ( cArea )->cCodBar )
      aadd( aCodebar, alltrim( ( cArea )->cCodBar ) )
   end if 

   hset( hJson, "codigos_barras", aCodebar )

RETURN ( hJson )   

//---------------------------------------------------------------------------//

METHOD writeArticulosJson()

   local cJson    := hb_jsonencode( ::aJson, .t. )

RETURN ( memowrit( "articulos.json", cJson ) ) 

//---------------------------------------------------------------------------//

METHOD exportUsuariosJson() 

   local cArea    := "UsrJson"

   ::aJson        := {}

   UsuariosModel():getUsuariosToJson( @cArea ) 

   ::oDialogView:oProgress:setTotal( ( cArea )->( lastrec() ) )

   while !( cArea )->( eof() )

      aadd( ::aJson, ::buildUsuariosJson( cArea ) )

      ::oDialogView:oProgress:AutoInc()

      ( cArea )->( dbskip() )

   end while

   CLOSE ( cArea )

   ::writeUsuariosJson()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD buildUsuariosJson( cArea )

   local hJson    := {=>}

   hset( hJson, "id", alltrim( ( cArea )->cCodUse ) )
   hset( hJson, "nombre", alltrim( ( cArea )->cNbrUse ) )

RETURN ( hJson )   

//---------------------------------------------------------------------------//

METHOD writeUsuariosJson()

   local cJson    := hb_jsonencode( ::aJson, .t. )

RETURN ( memowrit( "usuarios.json", cJson ) ) 

//---------------------------------------------------------------------------//

