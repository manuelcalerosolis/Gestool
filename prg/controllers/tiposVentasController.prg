#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TiposVentasController FROM SQLBaseController

   METHOD   New()

   METHOD   buildSQLModel( this )               INLINE ( TiposVentasModel():New( this ) )
   
   METHOD   buildSQLView( this )				INLINE ( TiposVentas():New( this ) )
  
   METHOD   buildSQLBrowse()					INLINE ( TiposVentas():New():buildSQLBrowse() )

   METHOD   getFieldFromBrowse()          INLINE ( ::getRowSet():fieldGet( "codigo" ) )
 
   METHOD   validDialog( oDlg, oGetNombre, oGetCodigo )

   METHOD   isValidGet( oGet )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::idUserMap            := "01043"

   ::Super:New()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD validDialog( oDlg, oGetNombre, oGetCodigo )

   if empty( ::oModel:hBuffer[ "nombre" ] )
      msgStop( "El nombre de la venta no puede estar vacío." )
      oGetNombre:setFocus()
      RETURN ( .f. )
   end if

   if ::getRowSet():find( ::oModel:hBuffer[ "nombre" ], "nombre" ) != 0 .and. ( ::getRowSet():fieldget( "id" ) != ::oModel:hBuffer[ "id" ] .or. ::isDuplicateMode() )
      msgStop( "El nombre de la venta ya existe" )
      oGetNombre:setFocus()
      RETURN ( .f. )
   end if

   if empty( ::oModel:hBuffer[ "codigo" ] )
      MsgStop( "El codigo del tipo de venta no puede estar vacío." )
      oGetCodigo:setFocus()
      Return ( .f. )
   end if

   if ::getRowSet():find( ::oModel:hBuffer[ "codigo" ], "codigo" ) != 0 .and. ( ::getRowSet():fieldget( "id" ) != ::oModel:hBuffer[ "id" ] .or. ::isDuplicateMode() )
      msgStop( "El codigo de la venta ya existe" )
      oGetCodigo:setFocus()
      RETURN ( .f. )
   end if

RETURN ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//

METHOD isValidGet( oGet )

   local uValue
   local uReturn

   if empty( oGet )
      RETURN ( uReturn )
   end if 

   uValue            := oGet:varGet()

   if !( ::oModel:exist( uValue ) )
      RETURN .f.
   end if 

   if !empty( oGet:oHelpText )
      oGet:oHelpText:cText( ::oModel:getName( uValue ) )
   end if 

RETURN ( uReturn )

//--------------------------------------------------------------------------//
