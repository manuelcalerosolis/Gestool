//----------------------------------------------------------------------------//

#include "extend.api"
#include "rdd.api"

extern AREAP  * _WorkAreas;
char * _nversion( unsigned int );

//----------------------------------------------------------------------------//
// Handle del DOS para el fichero DBF

CLIPPER DbfHdl( void )
{
   if( _nversion( 1 )[ 14 ] == '3' )
      _retni( * ( (int *) ( ( (char *) (*_WorkAreas) ) + 0x82 ) ) ) ;
   else
      _retni( * ( (int *) ( ( (char *) (*_WorkAreas) ) + 0x70 ) ) ) ;
}

//----------------------------------------------------------------------------//
// .t. si es compartido

CLIPPER isShared()
{
   if( _nversion( 1 )[ 14 ] == '3' )
      _retl( * ( (int *) ( ( (char *) (*_WorkAreas) ) + 0x88 ) ) ) ;
   else
      _retl( * ( (int *) ( ( (char *) (*_WorkAreas) ) + 0x76 ) ) ) ;
}

//----------------------------------------------------------------------------//
// .t. si es de solo lectura

CLIPPER isReadOnly()
{
   if( _nversion( 1 )[ 14 ] == '3' )
      _retl( * ( (int *) ( ( (char *) (*_WorkAreas) ) + 0x90 ) ) ) ;
   else
      _retl( * ( (int *) ( ( (char *) (*_WorkAreas) ) + 0x78 ) ) ) ;
}

//----------------------------------------------------------------------------//


//----------------------------------------------------------------------------//
// Funciones SET GET de topes
//----------------------------------------------------------------------------//

CLIPPER _SetGBof()
{
   if ( ISLOG( 1 ) )
   {
      (*_WorkAreas)->fBof   = _parl( 1 );
      (*_WorkAreas)->fFound = FALSE;
   }
   _retl( (*_WorkAreas)->fBof );
}

CLIPPER _SetGEof()
{
   if ( ISLOG( 1 ) )
   {
      (*_WorkAreas)->fEof    = _parl( 1 );
      (*_WorkAreas)->fFound  = FALSE;
   }
   _retl( (*_WorkAreas)->fEof );
}

//----------------------------------------------------------------------------//
