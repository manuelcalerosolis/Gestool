#include "FiveWin.ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SuperUsuarioController FROM SQLBaseController
   
   METHOD New()
   METHOD End()

   METHOD isDialogViewActivate()    INLINE ( ::oDialogView:Activate() == IDOK ) 
   METHOD isNotDialogViewActivate() INLINE ( ::oDialogView:Activate() != IDOK ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS SuperUsuarioController

   ::hImage                := { "48" => "gc_spy_48" }

   ::oRepository           := UsuariosRepository():New( self )

   ::oDialogView           := SuperUsuarioView():New( self )

   ::oValidator            := SuperUsuarioValidator():New( self, ::oDialogView )

RETURN ( Self )

//---------------------------------------------------------------------------//
 
METHOD End() CLASS SuperUsuarioController

   if !empty( ::oDialogView )
      ::oDialogView:End()
      ::oDialogView           := nil
   endif

   if !empty( ::oValidator )
      ::oValidator:End()
      ::oValidator            := nil
   endif

   ::Super:End()

   Self                       := nil

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SuperUsuarioView FROM SQLBaseView

   DATA oGetPassword       
   DATA cGetPassword                   INIT space( 100 )

   METHOD Activate()
      METHOD endActivate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS SuperUsuarioView

   ::cGetPassword := space( 100 )
   
   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "SUPER_USUARIO" 

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   REDEFINE GET   ::oGetPassword ;
      VAR         ::cGetPassword ;
      ID          100 ;
      OF          ::oDialog
   
   ::oGetPassword:bValid   := {|| ::oController:validate( "password", ::cGetPassword ) }

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::endActivate(), ) }
   end if

   ::oDialog:Activate( , , , .t. )

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD endActivate() CLASS SuperUsuarioView

   if !( validateDialog( ::oDialog ) )
      RETURN ( IDCANCEL )
   end if 

   ::oDialog:end( IDOK )

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SuperUsuarioValidator FROM SQLBaseValidator

   METHOD getValidators()

   METHOD Password( cPassword )

END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS SuperUsuarioValidator

   ::hValidators  := {  "password" =>  {  "password"  => "Contraseña de super usuario ¡incorrecta!" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//

METHOD Password( cPassword )

   local hUsuario := ::oController:oRepository:validSuperUserPassword( cPassword )

RETURN ( hb_ishash( hUsuario ) )

//---------------------------------------------------------------------------//
