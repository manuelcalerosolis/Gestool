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

   METHOD getValueBuffer( nArrayAt )            INLINE ( hGet( ::oModel:aBuffer[ nArrayAt ], "numero_serie" ) )
   METHOD setValueBuffer( nArrayAt, value )     INLINE ( hSet( ::oModel:aBuffer[ nArrayAt ], "numero_serie", value ) )

   METHOD endResource( oDlg )

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

   MsgInfo( "GenerarSeries" )

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