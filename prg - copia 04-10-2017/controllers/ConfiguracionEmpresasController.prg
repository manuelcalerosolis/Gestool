#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS ConfiguracionEmpresasController FROM SQLBaseController

   METHOD   New()

   METHOD   buildSQLModel( this )         	 INLINE ( ConfiguracionEmpresasModel():New( this ) )
   
   METHOD   buildSQLView( this )			       VIRUTAL
   
   METHOD   getValue( name )

   METHOD   setValue( name, value, type )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::Super:New()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD   getValue( name, default )
   
   ::oModel:
   

METHOD   setValue( name, value, type )
