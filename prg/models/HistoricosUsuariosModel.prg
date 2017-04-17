#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS HistoricosUsuariosModel FROM SQLBaseModel

   METHOD   New()

   //METHOD   getHistory()

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::cTableName                  := "historicos_usuarios"

   ::hColumns                    := {  "id"         	=>   "INTEGER PRIMARY KEY AUTOINCREMENT"   , ;
                                       "usuario_id"	    =>   "CHARACTER ( 3 ) NOT NULL"		  	   , ;
                                       "tabla"    		=>   "VARCHAR( 30 ) NOT NULL"		       , ;
                                       "orden"    		=>   "VARCHAR( 30 ) NOT NULL" 		       , ;
                                       "orientacion"	=>   "CHARACTER ( 1 ) NOT NULL"			   , ;
                                       "recno"    		=>   "INT NOT NULL"						   }

   ::Super:New()

Return ( Self )

//---------------------------------------------------------------------------//

/*Function getHistory( cTableName )

   Local sentencia  := "SELECT orden, orientacion, recno from historicos_usuarios WHERE tabla =" + cTableName + " and usuario_id = " + oUser():cCodigo()

   local oStmt

   try 
      oStmt          := getSQLDatabase():Query( ::getSelectSentence() )

      ::oRowSet      := oStmt:fetchAll()
      ::oRowSet:goTop()

   catch

      msgstop( hb_valtoexp( getSQLDatabase():errorInfo() ) )

      if !empty( oStmt )
         oStmt:free()
      end if    
   
   end

   ::cColumnOrder                := 
   ::cColumnOrientation          :=
   ::setRowSetRecno( nRecno )

Return ( nil )*/
       
//---------------------------------------------------------------------------//
