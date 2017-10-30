#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS NumerosSeriesController FROM SQLBaseController

   DATA cParentUUID

   METHOD New()

   METHOD Edit()

   METHOD Dialog()                              INLINE ( ::oDialogView:Dialog() )

   METHOD GenerarSeries()

   METHOD SetTotalUnidades( nUnidades )         INLINE ( if( !Empty( nUnidades ), ::oDialogView:nTotalUnidades := Abs( nUnidades ), ::oDialogView:nTotalUnidades := 0 ) )

   METHOD SetParentUUID( uUid )                 INLINE ( if( !Empty( uUid ), ::cParentUUID := uUid, ::cParentUUID := "" ) )

   METHOD getaBuffer()                          INLINE ( ::oModel:aBuffer )

   METHOD getValueBuffer( nArrayAt, key )            INLINE ( hGet( ::oModel:aBuffer[ nArrayAt ], key ) )
   METHOD setValueBuffer( nArrayAt, key, value )     INLINE ( hSet( ::oModel:aBuffer[ nArrayAt ], key, value ) )

   METHOD endResource( oDlg )

   METHOD deletedSelected( aRecords )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::cTitle                := "Series"

   ::oModel                := SQLNumerosSeriesModel():New( self )

   ::oDialogView           := NumerosSeriesView():New( self )

   ::Super:New( oController )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD GenerarSeries()

   local n
   local nChg  := 1

   CursorWait()

   ::oDialogView:oDialog:Disable()

   if Empty( ::oDialogView:nNumGen )
      aEval( ::getaBuffer(), {| a, n | ::setValueBuffer( n, "numero_serie", Padr( Rtrim( ::oDialogView:cPreFix ) + Ltrim( Str( ::oDialogView:nSerIni + n - 1 ) ), 30 ) ) } )
   else
      for n := 1 to len( ::getaBuffer() )
            ::setValueBuffer( n, "numero_serie", Padr( Rtrim( ::oDialogView:cPreFix ) + Ltrim( Str( ::oDialogView:nSerIni + nChg - 1 ) ), 30 ) )
            nChg++
         if nChg == ::oDialogView:nNumGen
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

   local aBufferOld

   ::oModel:RollBack()

   if !Empty( oDlg )
      oDlg:End( IDOK )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Edit() 

   local lEdit    := .t. 

   if ::notUserEdit()
      msgStop( "Acceso no permitido." )
      RETURN ( .f. )
   end if 

   if !( ::fireEvent( 'editing' ) )
      RETURN ( .f. )
   end if

   ::setEditMode()

   ::beginTransactionalMode()

   ::oModel:setIdToFind( ::getIdFromRowSet() )

   ::oModel:loadCurrentBuffer() 

   ::fireEvent( 'openingDialog' )

   if ::oDialogView:Dialog()
      
      ::fireEvent( 'closedDialog' )    

      ::oModel:updateCurrentBuffer()

      ::fireEvent( 'editedted' ) 

      ::commitTransactionalMode()

   else

      lEdit       := .f.

      ::fireEvent( 'cancelEdited' ) 

      ::rollbackTransactionalMode()

   end if 

   ::fireEvent( 'exitEdited' ) 

RETURN ( lEdit )

//---------------------------------------------------------------------------//

METHOD deletedSelected( aRecords )

   if hb_isArray( aRecords ) .and. Len( aRecords ) > 0

      aEval( aRecords, {| h | ::oModel:deleteWhereUuid( hGet( h, "uuid" ) ) } )

   end if

RETURN ( self )

//---------------------------------------------------------------------------//