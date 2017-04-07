#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS HistoricosUsuariosModel FROM SQLBaseModel

   METHOD   New()

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cTableName                  := "historicos_usuarios"

   ::cSQLCreateTable             := "CREATE TABLE " + ::cTableName + " ( "                     + ;
                                       "id         	   INTEGER PRIMARY KEY AUTOINCREMENT, "    + ;
                                       "usuario_id     CHARACTER ( 3 ) NOT NULL, "		  	   + ;
                                       "tabla          VARCHAR( 30 ) NOT NULL, "		       + ;
                                       "orden          VARCHAR( 30 ) NOT NULL, " 		       + ;
                                       "orientacion	   CHARACTER ( 1 ) NOT NULL, "			   + ;
                                       "recno          INT NOT NULL);"

   ::Super:New()

Return ( Self )

//---------------------------------------------------------------------------//