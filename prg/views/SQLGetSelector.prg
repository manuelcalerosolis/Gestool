#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS GetSelector

   DATA oController

   DATA oDialog

   DATA bValue

   DATA cPicture                                INIT "@!"                                  

   DATA oLink
   
   DATA oGet
   DATA cGet

   DATA oHelp
   DATA cHelp

   DATA cOriginal

   DATA cKey                                    INIT  "codigo"

   DATA uFields

   DATA oEvents

   DATA bWhen
   DATA bValid

   METHOD New( oController ) CONSTRUCTOR
   METHOD End()                                 

   METHOD setKey( cKey )                        INLINE ( ::cKey := cKey )
   METHOD getKey()                              INLINE ( ::cKey )

   METHOD setPrompt( cPrompt )                  INLINE ( ::cPrompt := cPrompt )
   METHOD getPrompt()                           INLINE ( if( empty( ::cPrompt ), ::getKey(), ::cPrompt ) )
   
   METHOD cText( value )                        INLINE ( if( !empty( ::oGet ), ::oGet:cText( value ), ) )

   METHOD getView()                             INLINE ( ::oController:getView() )

   METHOD Build( hBuilder )

   METHOD Activate( idGet, idText, oDlg )

   METHOD addGetSelector( cLink, oTaskPanel ) 

   METHOD Bind( bValue )                        INLINE ( ::bValue := bValue )
   
   METHOD setValid( bValid )                    INLINE ( ::bValid := bValid )

   METHOD helpAction()
   METHOD validAction()

   METHOD assignResults( hResult )

   METHOD loadHelpText()
      METHOD cleanHelpText()                    
      METHOD setHelpText( value )               

   METHOD getFields()                           INLINE ( ::uFields   := ::oController:getModel():getField( "nombre", ::getKey(), ::oGet:varGet() ) )
   
   METHOD start()                               INLINE ( ::loadHelpText( .t. ) )

   METHOD evalValue( value )                    INLINE ( eval( ::bValue, value ) )

   METHOD showMessage()

   METHOD varGet()                              INLINE ( if( !empty( ::oGet ), ::oGet:varGet(), ) )
  
   METHOD Hide()
   METHOD Show()
  
   METHOD setFocus()                            INLINE ( if( !empty( ::oGet ), ::oGet:setFocus(), ) )
  
   METHOD Refresh()                             INLINE ( if( !empty( ::oGet ), ::oGet:Refresh(), ) )
  
   METHOD lValid()                              INLINE ( if( !empty( ::oGet ), ::oGet:lValid(), ) )
   METHOD evalWhen()                            INLINE ( if( !empty( ::oGet ) .and. !empty( ::bWhen ), ( if( eval( ::bWhen ), ::oGet:Enable(), ::oGet:Disable() ) ), ) )

   METHOD getHelp()                             INLINE ( if( empty( ::oHelp ), ::oGet:oHelpText, ::oHelp ) )

   // Events-------------------------------------------------------------------

   METHOD setEvent( cEvent, bEvent )            INLINE ( if( !empty( ::oEvents ), ::oEvents:set( cEvent, bEvent ), ) )
   METHOD fireEvent( cEvent, uValue )           INLINE ( if( !empty( ::oEvents ), ::oEvents:fire( cEvent, uValue ), ) )

   METHOD setWhen( bWhen )                      INLINE ( if( !empty( bWhen ),    ::bWhen        := bWhen, ),;
                                                         if( !empty( ::oGet ),   ::oGet:bWhen   := ::bWhen, ) )

   METHOD isChangeGet()                         INLINE ( ::varGet() != ::getOriginal() )
   METHOD isNotChangeGet()                      INLINE ( ::varGet() == ::getOriginal() )

   METHOD setOriginal( cOriginal )              INLINE ( ::cOriginal := cOriginal )
   METHOD getOriginal()                         INLINE ( ::cOriginal )

   METHOD setBlank()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS GetSelector

   ::oController  := oController

   ::oEvents      := Events():New()

   ::bWhen        := {|| ::oController:getController():isNotZoomMode() } 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS GetSelector

   if !empty( ::oEvents )
      ::oEvents:End()
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Build( hBuilder ) CLASS GetSelector

   local idGet    := if( hhaskey( hBuilder, "idGet" ),   hBuilder[ "idGet" ],    nil )
   local idText   := if( hhaskey( hBuilder, "idText" ),  hBuilder[ "idText" ],   nil )
   local idSay    := if( hhaskey( hBuilder, "idSay" ),   hBuilder[ "idSay"],     nil )
   local idLink   := if( hhaskey( hBuilder, "idLink" ),  hBuilder[ "idLink"],    nil )
   local oDlg     := if( hhaskey( hBuilder, "oDialog" ), hBuilder[ "oDialog" ],  nil )

RETURN ( ::Activate( idGet, idText, oDlg, idSay, idLink ) )

//---------------------------------------------------------------------------//

METHOD Activate( idGet, idText, oDlg, idSay, idLink ) CLASS GetSelector

   if isFalse( ::fireEvent( 'activating' ) )
      RETURN ( nil )
   end if

   ::cGet               := eval( ::bValue )

   ::setOriginal( ::cGet )

   REDEFINE GET         ::oGet ;
      VAR               ::cGet ;
      ID                idGet ;
      PICTURE           ::cPicture ;
      UPDATE ;
      IDTEXT            idText ;
      IDSAY             idSay ;
      BITMAP            "Lupa" ;
      OF                oDlg

   ::oGet:bHelp         := {|| ::helpAction() }
   ::oGet:bValid        := {|| ::validAction() }
   ::oGet:bWhen         := ::bWhen

   if !empty( idLink )   

   REDEFINE SAY         ::oLink ;
      FONT              oFontBold() ; 
      COLOR             rgb( 10, 152, 234 ) ;
      ID                idLink ;
      OF                oDlg ;

   ::oLink:lWantClick   := .t.
   ::oLink:OnClick      := {|| ::oController:Edit( ::oController:getModel():getIdWhereCodigo( ::cGet ) ) }

   end if 

   ::fireEvent( 'activated' ) 

RETURN ( ::oGet )

//---------------------------------------------------------------------------//

METHOD addGetSelector( cLink, oTaskPanel ) CLASS GetSelector

   local nTop           := oTaskPanel:getTopControl()

   if isFalse( ::fireEvent( 'activating' ) )
      RETURN ( nil )
   end if

   ::cGet               := eval( ::bValue )

   ::setOriginal( ::cGet )

   @ nTop + 3, 10 SAY   ::oLink ; 
      PROMPT            cLink ;
      OF                oTaskPanel ;
      PIXEL             ;
      COLOR             Rgb( 10, 152, 234 ), Rgb( 255, 255, 255 )
   
   ::oLink:lWantClick   := .t.
   ::oLink:OnClick      := {|| ::oController:Edit( ::oController:getModel():getIdWhereCodigo( ::cGet ) ) }

   @ nTop, 120 GET      ::oGet ;
      VAR               ::cGet ;
      SIZE              100, 22 ;
      ACTION            ( msgInfo( "Action not redefined" ) ) ;
      BITMAP            "Lupa" ;
      OF                oTaskPanel ;
      PIXEL

   ::oGet:bAction       := {|| ::helpAction() }
   ::oGet:bValid        := {|| ::validAction() }
   ::oGet:bWhen         := ::bWhen

   @ nTop, 222 GET      ::oHelp ;
      VAR               ::cHelp ;
      SIZE              360, 22 ;
      WHEN              .f. ;
      OF                oTaskPanel ;
      PIXEL

   ::loadHelpText( .t. )

   oTaskPanel:setHeight( ::oGet:nTop, ::oGet:nHeight )

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

   ::assignResults( hResult )

   ::fireEvent( 'helped' ) 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD assignResults( hResult ) CLASS GetSelector

   if hhaskey( hResult, ::getKey() )

      ::cText( hGet( hResult, ::getKey() ) )

      ::evalValue( hGet( hResult, ::getKey() ) )

   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD validAction() CLASS GetSelector

   if isFalse( ::fireEvent( 'validating' ) )
      RETURN ( .f. )
   end if

   ::evalValue( ::varGet() )

   if !empty( ::bValid ) .and. !eval( ::bValid, ::oGet ) 
      RETURN ( .f. )
   end if 

   ::fireEvent( 'validated' )

   ::oGet:oWnd:nLastKey    := 0

   if ::isChangeGet()

      ::loadHelpText()

      ::setOriginal( ::varGet() )

   end if  

RETURN ( .t. )

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

METHOD showMessage( lSilenceMode ) CLASS GetSelector

   if lSilenceMode 
      RETURN ( nil )
   end if 

   if empty( ::getView() ) .or. empty( ::getView():oMessage )
      msgStop( ::oController:cTitle + " no encontrado" )
   else
      ::getView():showMessage( ::oController:cTitle + " no encontrado" )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD cleanHelpText() CLASS GetSelector

   if isFalse( ::fireEvent( 'cleaningHelpText' ) )
      RETURN ( .f. )
   end if

   ::getHelp():cText( "" ) 

   ::fireEvent( 'cleanedHelpText' ) 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setHelpText( value ) CLASS GetSelector            

   if isFalse( ::fireEvent( 'settingHelpText' ) )
      RETURN ( .f. )
   end if

   ::getHelp():cText( value ) 

   ::fireEvent( 'settedHelpText' ) 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Hide() CLASS GetSelector

   if !empty( ::oGet )
      ::oGet:Hide()
   end if

   if !empty( ::oLink )
      ::oLink:Hide()
   end if

RETURN ( nil )                                

//---------------------------------------------------------------------------//

METHOD Show() CLASS GetSelector

   if !empty( ::oGet )
      ::oGet:Show()
   end if

   if !empty( ::oLink )
      ::oLink:Show()
   end if

RETURN ( nil )                                

//---------------------------------------------------------------------------//

METHOD setBlank()

   ::oGet:varPut( space( 20 ) )

   ::cleanHelpText()

   ::Refresh()

RETURN ( nil )




//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
