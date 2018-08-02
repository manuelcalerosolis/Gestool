#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS GetSelector

   DATA oController

   DATA oDialog

   DATA bValue

   DATA cPicture                                  
   
   DATA oGet
   DATA cGet

   DATA cKey                                    INIT  "codigo"

   DATA uFields

   DATA oEvents

   DATA bWhen
   DATA bValid

   METHOD New( oSender )
   METHOD End()                                 

   METHOD setKey( cKey )                        INLINE ( ::cKey := cKey )
   METHOD getKey()                              INLINE ( ::cKey )

   METHOD getView()                             INLINE ( ::oController:getView() )

   METHOD Build( hBuilder )

   METHOD Activate( idGet, idText, oDlg )
   METHOD Bind( bValue )                        INLINE ( ::bValue := bValue )
   
   METHOD setValid( bValid )                    INLINE ( ::bValid := bValid )

   METHOD helpAction()

   METHOD validAction()

   METHOD loadHelpText()
      METHOD cleanHelpText()                    
      METHOD setHelpText( value )               

   METHOD getFields()                           INLINE ( ::uFields   := ::oController:oModel:getField( "nombre", ::getKey(), ::oGet:varGet() ) )
   
   METHOD start()                               INLINE ( ::loadHelpText( .t. ) )

   METHOD evalValue( value )                    INLINE ( eval( ::bValue, value ) )

   METHOD showMessage()

   METHOD cText( value )                        INLINE ( if( !empty( ::oGet ), ::oGet:cText( value ), ) )
   METHOD Hide()                                INLINE ( if( !empty( ::oGet ), ::oGet:Hide(), ) )
   METHOD Show()                                INLINE ( if( !empty( ::oGet ), ::oGet:Show(), ) )
   METHOD lValid()                              INLINE ( if( !empty( ::oGet ), ::oGet:lValid(), ) )

   // Events-------------------------------------------------------------------

   METHOD setEvent( cEvent, bEvent )            INLINE ( if( !empty( ::oEvents ), ::oEvents:set( cEvent, bEvent ), ) )
   METHOD fireEvent( cEvent )                   INLINE ( if( !empty( ::oEvents ), ::oEvents:fire( cEvent ), ) )

   METHOD setWhen( bWhen )                      INLINE ( if( !empty( bWhen ),    ::bWhen        := bWhen, ),;
                                                         if( !empty( ::oGet ),   ::oGet:bWhen   := ::bWhen, ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS GetSelector

   ::oController  := oController

   ::oEvents      := Events():New()

   ::bWhen        := {|| ::oController:getSenderController():isNotZoomMode() } 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oEvents )
      ::oEvents:End()
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Build( hBuilder ) CLASS GetSelector

   local idGet    := if( hhaskey( hBuilder, "idGet" ),   hBuilder[ "idGet" ],    nil )
   local idText   := if( hhaskey( hBuilder, "idText" ),  hBuilder[ "idText" ],   nil )
   local idSay    := if( hhaskey( hBuilder, "idSay" ),   hBuilder[ "idSay"],     nil )
   local oDlg     := if( hhaskey( hBuilder, "oDialog" ), hBuilder[ "oDialog" ],  nil )

RETURN ( ::Activate( idGet, idText, oDlg, idSay ) )

//---------------------------------------------------------------------------//

METHOD Activate( idGet, idText, oDlg, idSay ) CLASS GetSelector

   if isFalse( ::fireEvent( 'activating' ) )
      RETURN ( nil )
   end if

   ::cGet        := eval( ::bValue )

   REDEFINE GET   ::oGet ;
      VAR         ::cGet ;
      ID          idGet ;
      PICTURE     ::cPicture ;
      UPDATE ;
      IDTEXT      idText ;
      IDSAY       idSay ;
      BITMAP      "Lupa" ;
      OF          oDlg

   ::oGet:bHelp   := {|| ::helpAction() }
   ::oGet:bValid  := {|| ::validAction() }
   ::oGet:bWhen   := ::bWhen

   ::fireEvent( 'activated' ) 

RETURN ( ::oGet )

//---------------------------------------------------------------------------//

METHOD helpAction() CLASS GetSelector

   local hResult

   if isFalse( ::fireEvent( 'helping' ) )
      RETURN ( .f. )
   end if

   hResult        := ::oController:ActivateSelectorView()

   if hb_isnil( hResult )
      RETURN ( .f. )
   end if 

   if hhaskey( hResult, ::getKey() )

      ::oGet:cText( hGet( hResult, ::getKey() ) )

      ::evalValue( hGet( hResult, ::getKey() ) )

   end if

   ::fireEvent( 'helped' ) 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD validAction()

   if isFalse( ::fireEvent( 'validating' ) )
      RETURN ( .f. )
   end if

   ::evalValue( ::oGet:varGet() )

   if empty( ::bValid ) .or. eval( ::bValid, ::oGet )

      ::loadHelpText()

      ::fireEvent( 'validated' )

      RETURN ( .t. )

   else
   
      ::oGet:oWnd:nLastKey    := 0

   end if 

RETURN ( .f. )

//---------------------------------------------------------------------------//

METHOD loadHelpText( lSilenceMode ) CLASS GetSelector

   local value             := ""

   DEFAULT lSilenceMode    := .f.

   if empty( ::oGet )
      RETURN ( .t. )
   end if

   if isFalse( ::fireEvent( 'loading' ) )
      RETURN ( .f. )
   end if

   // ::evalValue( ::oGet:varGet() )

   ::cleanHelpText()

   if empty( ::oGet:varGet() )

      ::fireEvent( 'loadingEmpty' )

      RETURN ( .t. )

   end if

   ::getFields()

   if empty( ::uFields )

      ::fireEvent( 'loadedError' )

      ::showMessage( lSilenceMode )

      RETURN ( .f. )

   end if

   ::setHelpText( ::uFields )

   ::oGet:Refresh()

   ::fireEvent( 'loaded' ) 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD showMessage( lSilenceMode )

   if lSilenceMode 
      RETURN ( self )
   end if 

   if empty( ::getView() ) .or. empty( ::getView():oMessage )
      msgStop( ::oController:cTitle + " no encontrado" )
   else
      ::getView():showMessage( ::oController:cTitle + " no encontrado" )
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD cleanHelpText()

   if isFalse( ::fireEvent( 'cleaningHelpText' ) )
      RETURN ( .f. )
   end if

   ::oGet:oHelptext:cText( "" ) 

   ::fireEvent( 'cleanedHelpText' ) 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setHelpText( value )               

   if isFalse( ::fireEvent( 'settingHelpText' ) )
      RETURN ( .f. )
   end if

   ::oGet:oHelptext:cText( value ) 

   ::fireEvent( 'settedHelpText' ) 

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
