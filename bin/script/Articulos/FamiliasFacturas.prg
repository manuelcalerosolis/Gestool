#include "hbclass.ch"

#define CRLF chr( 13 ) + chr( 10 )

//---------------------------------------------------------------------------//

Function Inicio( nView )

   local oImportaArticulos := ImportaFamiliaArticulos():New( nView )

Return ( nil )

//---------------------------------------------------------------------------//

CLASS ImportaFamiliaArticulos

   DATA nView

   METHOD New()
   METHOD ImpFamilias()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS ImportaFamiliaArticulos

   ::nView     := nView

   ::ImpFamilias()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD ImpFamilias() CLASS ImportaFamiliaArticulos

   local cCodFam
   local n        := 1

   msgWait( "Comenzamos el proceso", "Atención", 1 )

   ( D():FacturasClientesLineas( ::nView ) )->( dbSetFilter( {|| Field->dFecFac >= ctod( "01/01/2016" ) }, "Field->dFecFac >= ctod('" + "01/01/2016" + "')" ) )
   ( D():FacturasClientesLineas( ::nView ) )->( dbGoTop() )

   while !( D():FacturasClientesLineas( ::nView ) )->( Eof() )

      if Empty( ( D():FacturasClientesLineas( ::nView ) )->cCodFam )

         cCodFam  := RetFld( ( D():FacturasClientesLineas( ::nView ) )->cRef, D():Articulos( ::nView ), "Familia", "Codigo" )

         if !Empty( cCodFam )

            if dbLock( D():FacturasClientesLineas( ::nView ) )
               
               ( D():FacturasClientesLineas( ::nView ) )->cCodFam    := cCodFam
               ( D():FacturasClientesLineas( ::nView ) )->cGrpFam    := RetFld( cCodFam, D():Familias( ::nView ), "CCODGRP", "cCodFam" )
               ( D():FacturasClientesLineas( ::nView ) )->( dbUnLock() )

            end if

         end if

      else

         if Empty( ( D():FacturasClientesLineas( ::nView ) )->cGrpFam )

            if dbLock( D():FacturasClientesLineas( ::nView ) )
               
               ( D():FacturasClientesLineas( ::nView ) )->cGrpFam    := RetFld( ( D():FacturasClientesLineas( ::nView ) )->cCodFam, D():Familias( ::nView ), "CCODGRP", "cCodFam" )

               ( D():FacturasClientesLineas( ::nView ) )->( dbUnLock() )

            end if

         end if

      end if

      ( D():FacturasClientesLineas( ::nView ) )->( dbSkip() )

      n++

      msgWait( "Registro " + Str( n ), "Atención", 0.01 )

   end while

   msgWait( "Fin del proceso", "Atención", 1 )

Return .t.

//---------------------------------------------------------------------------//