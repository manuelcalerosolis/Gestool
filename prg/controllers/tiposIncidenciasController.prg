#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TiposIncidenciasController FROM SQLBaseController

   METHOD   New()

   METHOD   buildSQLModel( this )               INLINE ( TiposIncidenciasModel():New( this ) )
   
   METHOD   buildSQLView( this )			INLINE ( TiposIncidencias():New( this ) )
  
   METHOD   buildSQLBrowse( oGet )        INLINE ( TiposIncidencias():New():buildSQLBrowse( ::oModel ) )        

   METHOD   getFieldFromBrowse()          INLINE ( ::getRowSet():fieldGet( "codigo" ) )

   METHOD   validDialog( oDlg, oGetNombre )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::idUserMap            := "01089"

   ::Super:New()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD validDialog( oDlg, oGetNombre, oGetCodigo )

   if empty( ::oModel:hBuffer[ "nombre_incidencia" ] )
      MsgStop( "El nombre del tipo de incidencia no puede estar vacío." )
      oGetNombre:setFocus()
      Return ( .f. )
   end if

   if ::getRowSet():find( ::oModel:hBuffer[ "nombre_incidencia" ], "nombre_incidencia" ) != 0 .and. ( ::getRowSet():find( ::oModel:hBuffer[ "id" ], "id" ) == 0 .or. ::isDuplicateMode() )
      msgStop( "El nombre de la incidencia ya existe" )
      oGetNombre:setFocus()
      RETURN ( .f. )
   end if

   if empty( ::oModel:hBuffer[ "codigo" ] )
      MsgStop( "El codigo del tipo de incidencia no puede estar vacío." )
      oGetCodigo:setFocus()
      Return ( .f. )
   end if

   if ::getRowSet():find( ::oModel:hBuffer[ "codigo" ], "codigo" ) != 0 .and. ( ::getRowSet():find( ::oModel:hBuffer[ "id" ], "id" ) == 0 .or. ::isDuplicateMode() )
      msgStop( "El codigo de la incidencia ya existe" )
      oGetCodigo:setFocus()
      RETURN ( .f. )
   end if

RETURN ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//