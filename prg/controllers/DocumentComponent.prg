#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS DocumentComponent FROM Events

   DATA oController

   DATA bValue

   DATA oGet

   DATA uOriginal

   METHOD New() CONSTRUCTOR

   METHOD End()                     

   METHOD Activate()

   METHOD Validate()                VIRTUAL

   METHOD createControl()           VIRTUAL

   METHOD getValue()                INLINE ( eval( ::bValue ) )
   METHOD setValue( uValue )        INLINE ( ::oGet:cText( uValue ) )
   METHOD bindValue( bValue )       INLINE ( ::bValue := bValue )

   METHOD storeOriginal()           INLINE ( ::uOriginal := ::getValue() )
   METHOD setOriginal( uOriginal )  INLINE ( ::uOriginal := uOriginal )
   METHOD getOriginal()             INLINE ( ::uOriginal )
   METHOD isOriginalChanged()       INLINE ( alltrim( ::getOriginal() ) != alltrim( ::getValue() ) )
   METHOD isNotOriginalChanged()    INLINE ( alltrim( ::getOriginal() ) == alltrim( ::getValue() ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS DocumentComponent

   ::oController  := oController 

   ::Super():New()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS DocumentComponent

RETURN ( ::Super():End() )

//---------------------------------------------------------------------------//

METHOD Activate( id, oDialog ) CLASS DocumentComponent

   ::storeOriginal()

   ::createControl( id, oDialog )

RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SerieDocumentoComponent FROM DocumentComponent

   METHOD Validate() 

   METHOD createControl( id, oDialog )

END CLASS

//---------------------------------------------------------------------------//

METHOD createControl( id, oDialog ) CLASS SerieDocumentoComponent

RETURN ( ::oGet := TGet():ReDefine( id, ::bValue, oDialog, , "@! XXXXXXXXXXXXXXXXXXXX", {|| ::Validate() }, , , , , , .f., {|| ::oController:isAppendOrDuplicateMode() }, , .f., .f. ) )

//---------------------------------------------------------------------------//

METHOD Validate() CLASS SerieDocumentoComponent

   local cSerie   := alltrim( ::oGet:varGet() )

   if ::isNotOriginalChanged()
      RETURN ( .t. )
   end if 

   if ::oController:getContadoresModel():isSerie( ::oController:getName(), cSerie )
      ::fireEvent( 'changedAndExist' )
      RETURN ( .t. )
   end if

   if !( msgYesNo( "La serie " + cSerie + ", no existe.", "¿ Desea crear una nueva serie ?" ) )
      ::oGet:cText( ::getOriginal() )
      RETURN ( .f. )
   end if 

   ::storeOriginal()

   ::oController:getContadoresModel():insertSerie( ::oController:getName(), cSerie ) 

   ::fireEvent( 'inserted' )   

RETURN ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS NumeroDocumentoComponent FROM DocumentComponent

   METHOD createControl( id, oDialog )        

   METHOD Validate()    INLINE ( ::oGet:varGet() > 0 )

END CLASS

//---------------------------------------------------------------------------//

METHOD createControl( id, oDialog ) CLASS NumeroDocumentoComponent        

RETURN ( ::oGet := TGet():ReDefine( id, ::bValue, oDialog, , "999999", {|| ::Validate() }, , , , , , .f., {|| .f. }, , .f., .f. ))

//---------------------------------------------------------------------------//


