//----------------------------------------------------------------------------//
//  AUTOR.....: Manuel Exp¢sito Su rez    Soft 4U '1994-2000                  //
//  e-Mail....: maex14@dipusevilla.es                                         //
//  CLASE.....: CLFORCE.C                                                     //
//  FECHA MOD.: 10/11/2000                                                    //
//  VERSION...: 9.00                                                          //
//  PROPOSITO.: Accesos a bajo nivel a la estructura WorkArea de Clipper      //
//----------------------------------------------------------------------------//

#include "extend.api"
#include "rdd.api"

//----------------------------------------------------------------------------//

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

