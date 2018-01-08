#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS NumerosSeriesController FROM SQLBaseController

   DATA cParentUUID

   METHOD New()

   METHOD GenerarSeries()

   METHOD SetTotalUnidades( nUnidades )               INLINE ( if( !empty( nUnidades ), ::oDialogView:nTotalUnidades := Abs( nUnidades ), ::oDialogView:nTotalUnidades := 0 ) )

   METHOD getValueBuffer( nArrayAt, key )             INLINE ( hGet( ::oModel:aBuffer[ nArrayAt ], key ) )
   METHOD setValueBuffer( nArrayAt, key, value )      INLINE ( hSet( ::oModel:aBuffer[ nArrayAt ], key, value ) )

   METHOD endResource( oDlg )

   METHOD deletedSelected( aRecords )

   METHOD loadedBlankBuffer()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::Super:New( oController )

   ::cTitle                := "Series"

   ::oModel                := SQLMovimientosAlmacenLineasNumerosSeriesModel():New( self )

   ::oDialogView           := NumerosSeriesView():New( self )

   ::oModel:setEvent( 'loadedBlankBuffer', {|| ::loadedBlankBuffer() } ) 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD GenerarSeries()

   local n
   local nChg  := 1

   CursorWait()

   ::oDialogView:oDialog:Disable()

   if empty( ::oDialogView:nNumGen )

      aeval( ::oModel:aBuffer, {| a, n | ::setValueBuffer( n, "numero_serie", Padr( Rtrim( ::oDialogView:cPreFix ) + Ltrim( Str( ::oDialogView:nSerIni + n - 1 ) ), 30 ) ) } )
   
   else
   
      for n := 1 to len( ::oModel:aBuffer )

         ::setValueBuffer( n, "numero_serie", Padr( Rtrim( ::oDialogView:cPreFix ) + Ltrim( Str( ::oDialogView:nSerIni + nChg - 1 ) ), 30 ) )

         if ++nChg == ::oDialogView:nNumGen
            exit
         end if

      next
   
   end if

   ::oDialogView:oBrwSer:Refresh()

   ::oDialogView:oDialog:Enable()

   CursorWE()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD endResource( oDlg )

   ::oModel:RollBack()

   if !empty( oDlg )
      oDlg:End( IDOK )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD loadedBlankBuffer()

   local uuid        := ::getSenderController():getUuid() 

   if !empty( uuid )
      hset( ::oModel:hBuffer, "parent_uuid", uuid )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD deletedSelected( aRecords )

   if hb_isArray( aRecords ) .and. len( aRecords ) > 0
      aeval( aRecords, {| h | ::oModel:deleteWhereUuid( hGet( h, "uuid" ) ) } )
   end if

RETURN ( self )

//---------------------------------------------------------------------------//