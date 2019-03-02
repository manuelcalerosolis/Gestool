#include "FiveWin.Ch"
#include "Factu.ch" 

static oCompany

//----------------------------------------------------------------------------//

CLASS CompanyManager

   DATA id
   DATA nif
   DATA uuid
   DATA nombre
   DATA codigo
   DATA registroMercantil
   DATA delegacionUuid

   DATA lUsarUbicaciones

   METHOD New() CONSTRUCTOR

   METHOD Set( hCompany )              INLINE ( ::guard( hCompany ) )
   METHOD Guard( hCompany )

   METHOD guardWhereUuid( uuid )
   METHOD guardWhereCodigo( cCodigo )

   METHOD getDefaultDelegacion()

   METHOD getDatabaseName()            INLINE ( 'gestool' + '_' + ::codigo )
   METHOD getTableName( cTableName )   INLINE ( ::getDatabaseName() + '.' + cTableName )

   METHOD getDefaultTarifa()           INLINE ( SQLAjustableModel():getEmpresaTarifaDefecto( ::uuid ) )
   
   METHOD getDefaultMetodoPago()       INLINE ( SQLAjustableModel():getMetodoPago( ::uuid ) )

   METHOD getDefaultCertificado()      INLINE ( SQLAjustableModel():getCertificado( ::uuid ) )

   METHOD getDefaultUsarUbicaciones()  INLINE ( if( hb_isnil( ::lUsarUbicaciones ), SQLAjustableModel():getUsarUbicaciones( ::uuid ), ::lUsarUbicaciones ) )
   
   METHOD setDefaultUsarUbicaciones( lValue ) ;
                                       INLINE ( ::lUsarUbicaciones := lValue )
   
   METHOD getPathDocuments( cDirectory ) ;
                                       INLINE ( cCompanyPathDocuments( ::codigo, cDirectory ) )

   METHOD getDocuments( cDirectory ) 

   METHOD getId()                      INLINE ( ::id )
   METHOD getNif()                     INLINE ( ::nif )
   METHOD getUuid()                    INLINE ( ::uuid )
   METHOD getNombre()                  INLINE ( ::nombre )
   METHOD getCodigo()                  INLINE ( ::codigo )
   METHOD getDelegacionUuid()          INLINE ( ::delegacionUuid )
   METHOD getRegistroMercantil()       INLINE ( ::registroMercantil )

   METHOD isPersonType()               INLINE ( val( left( ::nif, 1 ) ) != 0 )

   METHOD getTemplatesHTML()    

END CLASS

//--------------------------------------------------------------------------//

METHOD New( hCompany )

   if !empty( hCompany )
      ::guard( hCompany )
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD guard( hCompany )

   if !hb_ishash( hCompany )
      RETURN ( self )
   end if 

   if hhaskey( hCompany, "id" )
      ::id                 := hget( hCompany, "id" ) 
   end if 

   if hhaskey( hCompany, "uuid" )
      ::uuid               := hget( hCompany, "uuid" ) 
   end if 
   
   if hhaskey( hCompany, "nombre" )
      ::nombre             := hget( hCompany, "nombre" ) 
   end if 

   if hhaskey( hCompany, "codigo" )
      ::codigo             := hget( hCompany, "codigo" ) 
   end if 

   if hhaskey( hCompany, "nif" )
      ::nif                := hget( hCompany, "nif" ) 
   end if 

   if hhaskey( hCompany, "registro_mercantil" )
      ::registroMercantil  := hget( hCompany, "registro_mercantil" ) 
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD guardWhereUuid( uuid )

   local hCompany    := SQLEmpresasModel():getWhereUuid( Uuid )

   if hb_ishash( hCompany )
      ::guard( hCompany )
   endif 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD guardWhereCodigo( cCodigo )

   local hCompany    := SQLEmpresasModel():getWhereCodigo( cCodigo )

   if hb_ishash( hCompany )
      ::guard( hCompany )
   endif 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD getDefaultDelegacion()

   local delegacionUuid    
   
   delegacionUuid    := SQLAjustableModel():getUsuarioEmpresaExclusiva( Auth():Uuid() )

   if empty( delegacionUuid )
      delegacionUuid := SQLAjustableModel():getEmpresaDelegacionDefecto( ::uuid )
   end if

RETURN ( delegacionUuid )

//---------------------------------------------------------------------------//

METHOD getDocuments( cDirectory )      

   local aFiles      := {}
   local aDocuments  := {}

   if !( isDirectory( ::getPathDocuments( cDirectory ) ) )
      recursiveMakeDir( ::getPathDocuments( cDirectory ) )
   end if 

   aFiles            := directory( ::getPathDocuments( cDirectory ) + "*.fr3" )

   if empty( aFiles )
      aDocuments     := { "No hay documentos definidos..." }
   else
      aeval( aFiles, {|aFile| aadd( aDocuments, aFile[ 1 ] ) } )
   end if 

RETURN ( aDocuments )

//---------------------------------------------------------------------------//

METHOD getTemplatesHTML()      

   local aFiles      := {}
   local aDocuments  := {}

   aFiles            := directory( cPatHtml() + "*.htm?" )

   if empty( aFiles )
      aDocuments     := { "No hay documentos definidos..." }
   else
      aeval( aFiles, {|aFile| aadd( aDocuments, aFile[ 1 ] ) } )
   end if 

RETURN ( aDocuments )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

FUNCTION Company( hCompany )

   if empty( oCompany )
      oCompany       := CompanyManager():New() 
   end if

   if !empty( hCompany )
      oCompany:Guard( hCompany )
   end if 

RETURN ( oCompany )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

