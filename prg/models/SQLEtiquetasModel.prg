
#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLEtiquetasModel FROM SQLBaseModel

   DATA cTableName                                 INIT "etiquetas"

   DATA cConstraints                               INIT "PRIMARY KEY (id), KEY (uuid)"

   METHOD getColumns()

   METHOD   updateAfterDelete()

   METHOD   deleteSelection( aRecno )              INLINE   ( getSQLDatabase():Execs( ::getdeleteSentence( aRecno ) ), ::updateAfterDelete( aRecno ), ::buildRowSet() )

   METHOD   insertChildBuffer()                    INLINE   ( getSQLDatabase():Query( ::getInsertSentence() ), ::buildRowSetAndFind() )

   METHOD   makeParent()

   METHOD   makeImportCategorias()

   METHOD   makeImportDbfSQL()

   METHOD   getSentenceFromOldCategories( idParent )

   METHOD   translateIdsToNames( aIds )

   METHOD   translateNamesToIds( aNames )

   METHOD   arrayCodigoAndId()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns()

   hset( ::hColumns, "id",          {  "create"    => "INTEGER AUTO_INCREMENT"                  ,;
                                       "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",        {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                       "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "nombre",      {  "create"    => "VARCHAR( 50 )"                          ,;
                                       "default"   => {|| space( 50 ) } }                       )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD updateAfterDelete( aRecno )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD makeParent( cName )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getSentenceFromOldCategories( idParent )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD makeImportCategorias()

Return ( nil )

//---------------------------------------------------------------------------//

METHOD makeImportDbfSQL()

   //::makeImportCategorias()
   
Return ( nil )

//---------------------------------------------------------------------------//

METHOD translateIdsToNames( aIds )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD translateNamesToIds( aNames )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD arrayCodigoAndId()

RETURN ( nil )

//---------------------------------------------------------------------------//
