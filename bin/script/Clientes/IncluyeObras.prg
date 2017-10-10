#include "FiveWin.Ch"

#include "Hbxml.ch"
#include "Hbclass.ch"
#include "Fileio.ch"

#include "Factu.ch"

//---------------------------------------------------------------------------//

Function Actualiza( nView )

   msgrun( "Integrando obras", "Espere por favor", {|| ActualizaObras():New( nView ):Run() } )

Return ( nil )

//---------------------------------------------------------------------------//

CLASS ActualizaObras

   DATA  nView

   METHOD New( nView )

   METHOD Run()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( nView )

   ::nView                    := nView

Return ( self )

//---------------------------------------------------------------------------//
   
METHOD Run()

   local tmpObras
   local nRec                 := ( D():ClientesDirecciones( ::nView ) )->( Recno() )
   local nOrdAnt              := ( D():ClientesDirecciones( ::nView ) )->( OrdSetFocus( "CCODCLI" ) )

   USE ( "c:\Ficheros\ObrasT.Dbf" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "ObrasT", @tmpObras ) )

   while !( tmpObras )->( Eof() )

      MsgWait( ( tmpObras )->cCodObr, "Haciendolo", 0.000001 )
      logwrite( ( tmpObras )->cCodCli + ( tmpObras )->cCodObr )
      logwrite( ( tmpObras )->( recno() ) )


      if !( D():ClientesDirecciones( ::nView ) )->( dbSeek( ( tmpObras )->cCodCli + ( tmpObras )->cCodObr ) )
         dbPass( tmpObras, D():ClientesDirecciones( ::nView ), .t. )
      end if

      ( tmpObras )->( dbSkip() )

   end while

   CLOSE ( tmpObras )

   ( D():ClientesDirecciones( ::nView ) )->( OrdSetFocus( nOrdAnt ) )
   
   ( D():ClientesDirecciones( ::nView ) )->( dbGoTo( nRec ) )

   MsgInfo( "Proceso terminado correctamente" )

Return ( self )

//---------------------------------------------------------------------------//
