#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TiposImpresorasController FROM SQLBaseController

   METHOD   New()

   METHOD   buildSQLModel( this )         INLINE ( TiposImpresorasModel():New( this ) )
   
   METHOD   buildSQLView( this )				INLINE ( TiposImpresoras():New( this ) )
  
   METHOD   buildSQLBrowse( oGet )			INLINE ( TiposImpresoras():New():buildSQLBrowse( ::oModel ) )

   METHOD   getFieldFromBrowse()          INLINE ( ::getRowSet():fieldGet( "nombre" ) )
 
   METHOD   validDialog( oDlg, oGetNombre )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::idUserMap            := "01115"

   ::Super:New()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD validDialog( oDlg, oGetNombre )

   if empty( ::oModel:hBuffer[ "nombre" ] )
      msgStop( "El nombre de la impresora no puede estar vacío." )
      oGetNombre:setFocus()
      RETURN ( .f. )
   end if

   if ::getRowSet():find( ::oModel:hBuffer[ "nombre" ], "nombre" ) != 0 .and. ( ::getRowSet():find( ::oModel:hBuffer[ "id" ], "id" ) == 0 .or. ::isDuplicateMode() )
      msgStop( "El nombre de la impresora ya existe" )
      oGetNombre:setFocus()
      RETURN ( .f. )
   end if

//---------------------------------------------------------------------------//

RETURN ( oDlg:end( IDOK ) )