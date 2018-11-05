#include "FiveWin.Ch"
#include "Factu.ch" 

#define  __encryption_key__   "snorlax"
#define  __admin_name__       "Super administrador"
#define  __admin_password__   "superusuario"

#define ADP_NAME              1

//---------------------------------------------------------------------------//

CLASS AccessController FROM SQLApplicationController

   DATA hUsuario
   DATA hEmpresa

   DATA lSelectCompany                 INIT .t.

   DATA oAccessView
   DATA oAccessTactilView
   
   DATA cValidError                    INIT "" 

   DATA aComboUsuarios
   DATA cComboUsuario  

   DATA cComboEmpresa
   DATA aComboEmpresas

   DATA cGetPassword

   DATA cMacAddress                    INIT ""

   METHOD New() CONSTRUCTOR
   METHOD End()

   METHOD validUserPassword( cUsuario, cPassword )
   METHOD validCompany( cEmpresa )

   METHOD isLogin()
   METHOD isLoginSuperAdmin()
   METHOD isLoginTactil()

   METHOD loadSuperAdmin()

   METHOD loadUsersAndCompanies()
   METHOD saveUsersAndCompanies()

   METHOD isSelectCompany()            INLINE ( ::lSelectCompany )

   METHOD getMacAddress()              

   METHOD getAccessView()              INLINE ( iif( empty( ::oAccessView ), ::oAccessView := AccessView():New( self ), ), ::oAccessView )

   METHOD getAccessTactilView()        INLINE ( iif( empty( ::oAccessTactilView ), ::oAccessTactilView := AccessTactilView():New( self ), ), ::oAccessTactilView )

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS AccessController

   ::Super:New()

   ::cTitle                            := "Access"

   ::cName                             := "access"

   ::hImage                            := {  "16" => "gc_businesspeople_16",;
                                             "48" => "gc_businesspeople_48" }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS AccessController

   if !empty( ::oAccessView )
      ::oAccessView:End()
   end if 

   if !empty( ::oAccessTactilView )
      ::oAccessTactilView:End()
   end if 

   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD isLogin() CLASS AccessController

   local isLogin  := .f.

   ::New()

   ::loadUsersAndCompanies()

   isLogin        := ::getAccessView():Activate() == IDOK

   if ( isLogin )

      if !empty( ::hUsuario )
         Auth( ::hUsuario )
      end if 

      if ::isSelectCompany() .and. !empty( ::hEmpresa )
         Company( ::hEmpresa )
      end if 

      ::saveUsersAndCompanies()

   end if 

   ::End()

RETURN ( isLogin )

//---------------------------------------------------------------------------//

METHOD loadUsersAndCompanies() CLASS AccessController

   local cUltimaEmpresa
   local cUltimoUsuario

   ::cGetPassword          := space( 100 )

   // Usuario------------------------------------------------------------------

   ::aComboUsuarios        := ::getUsuariosController():getModel():getNombres()

   cUltimoUsuario          := ::getAjustableGestoolController():getModel():getUltimoUsuarioInMac( ::getMacAddress() )
   if empty( cUltimoUsuario )
      ::cComboUsuario      := atail( ::aComboUsuarios )
   else 
      ::cComboUsuario      := ::getUsuariosController():getModel():getNombreWhereUuid( cUltimoUsuario )
   end if 

   // Empresa------------------------------------------------------------------

   if ::isSelectCompany()

      ::aComboEmpresas     := ::getEmpresasController():getModel():getNombres()

      cUltimaEmpresa       := ::getAjustableGestoolController():getModel():getUltimaEmpresaInMac( ::getMacAddress() )
      if empty( cUltimaEmpresa )
         ::cComboEmpresa   := atail( ::cComboEmpresa )
      else
         ::cComboEmpresa   := ::getEmpresasController():getModel():getNombreWhereUuid( cUltimaEmpresa )
      end if 

   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadSuperAdmin() CLASS AccessController

   ::cGetPassword          := space( 100 )

   ::aComboUsuarios        := { __admin_name__ }
   ::cComboUsuario         := __admin_name__

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD saveUsersAndCompanies() CLASS AccessController

   ::getAjustableController():getModel():setUltimaEmpresaInMac( Company():uuid(), ::getMacAddress() )

   ::getAjustableController():getModel():setUltimoUsuarioInMac( Auth():uuid(), ::getMacAddress() )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD isLoginSuperAdmin() CLASS AccessController

   ::lSelectCompany  := .f.

   ::loadSuperAdmin()

   if ( ::getAccessView():Activate() != IDOK )
      RETURN ( .f. )
   end if 

   if !empty( ::hUsuario )
      Auth( ::hUsuario )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD isLoginTactil() CLASS AccessController

   if ( ::getLoginTactilView():Activate() != IDOK )
      RETURN ( .f. )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD validUserPassword() CLASS AccessController

   ::hUsuario                 := ::getUsuariosController():getModel():validUserPassword( ::cComboUsuario, ::cGetPassword )

   if empty( ::hUsuario )
      ::cValidError           := "Usuario y contraseña no coinciden" 
      RETURN ( .f. )
   end if 

   if setUserActive( hget( ::hUsuario, "uuid" ) )
      ::cValidError           := "Usuario actualmente en uso"
      RETURN ( .f. )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD validCompany() CLASS AccessController

   if !( ::isSelectCompany() )
      RETURN ( .t. )
   end if 

   ::hEmpresa                 := ::getEmpresasController():getModel():validEmpresa( ::cComboEmpresa )

   if empty( ::hEmpresa )
      ::cValidError           := "Empresa no existe" 
      RETURN ( .f. )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD getMacAddress() CLASS AccessController

   local aNetCardInfo    

   if !empty( ::cMacAddress )
      RETURN ( ::cMacAddress )
   end if 

   aNetCardInfo         := getNetCardInfo()

   if !empty( aNetCardInfo )
      ::cMacAddress     := afirst( getNetCardInfo() )[ ADP_NAME ]
   end if 

RETURN ( ::cMacAddress )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS AccessView FROM SQLBaseView

   DATA oSayError

   DATA oGetPassword

   DATA oComboUsuario

   DATA oSayEmpresa

   DATA oComboEmpresa

   METHOD isSelectCompany()         INLINE ( ::oController:lSelectCompany )

   METHOD Activate()
   METHOD ActivateWithCompany()     INLINE ( ::setShowEmpresa( .t. ), ::Activate() )
   METHOD startActivate()

   METHOD Validate()

   METHOD sayError( cError )        INLINE ( ::oSayError:setText( cError ), ::oSayError:Show(), dialogSayNo( ::oDialog ) )
   
END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS AccessView 

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "LOGIN" 

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gestool_logo" ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oSayEmpresa ;
      ID          131 ;
      OF          ::oDialog

   REDEFINE COMBOBOX ::oComboEmpresa ;
      VAR         ::oController:cComboEmpresa ;
      ID          130 ;
      ITEMS       ::oController:aComboEmpresas ;
      OF          ::oDialog

   REDEFINE COMBOBOX ::oComboUsuario ;
      VAR         ::oController:cComboUsuario ;
      ID          100 ;
      ITEMS       ::oController:aComboUsuarios ;
      OF          ::oDialog

   REDEFINE GET   ::oGetPassword ;
      VAR         ::oController:cGetPassword ;
      ID          110 ;
      OF          ::oDialog

   REDEFINE SAY   ::oSayError ;
      ID          120 ;
      COLOR       Rgb( 183, 28, 28 ) ;
      FONT        ::oFontBold ;
      OF          ::oDialog

   ApoloBtnFlat():Redefine( IDOK, {|| ::Validate() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::Validate(), ) }    

   ::oDialog:bStart     := {|| ::startActivate() }

   ::oDialog:Activate( , , , .t. )

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD startActivate() CLASS AccessView

   if ::isSelectCompany()
      RETURN ( nil )
   end if 

   ::oSayEmpresa:Hide()
   
   ::oComboEmpresa:Hide()

   // ::oDialog:bKeyDown     := {| nKey | msgalert( nKey ) } //  if( nKey == VK_F5, ::Validate(), ) }    

//   setKey( VK_F5, {|| ::Validate() } )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Validate() CLASS AccessView

   if !( ::oController:validUserPassword() )
      ::sayError( ::oController:cValidError )
      RETURN ( nil )
   end if 

   if !( ::oController:validCompany() )
      ::sayError( ::oController:cValidError )
      RETURN ( nil )
   end if 

   ::oDialog:end( IDOK ) 

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS AccessTactilView FROM SQLBaseView

   DATA oSayError

   DATA oImageList

   DATA oListView

   METHOD Activate()
      METHOD startActivate()
      METHOD initActivate() 

   METHOD sayError( cError )     INLINE ( ::oSayError:setText( cError ), ::oSayError:Show(), dialogSayNo( ::oDialog ) )
   
   METHOD Validate( nOpt )

END CLASS

//---------------------------------------------------------------------------//

METHOD startActivate() CLASS AccessTactilView

   local oStatement

   oStatement  := UsuariosRepository():fetchDirect()
   
   if !empty( oStatement )

      while oStatement:fetchDirect()
   
         with object ( TListViewItem():New() )
            :Cargo   := oStatement:fieldget( "nombre" )
            :cText   := Capitalize( oStatement:fieldget( "nombre" ) )
            :nImage  := 0
            :nGroup  := 1
            :Create( ::oListView )
         end with
   
      end while
   
      oStatement:free()
   
   end if 

   ::oListView:Refresh()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD initActivate() CLASS AccessTactilView

   ::oListView:SetImageList( ::oImageList )
   ::oListView:EnableGroupView()
   ::oListView:SetIconSpacing( 120, 140 )

   with object ( TListViewGroup():New() )
      :cHeader := "Usuarios"
      :Create( ::oListView )
   end with

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS AccessTactilView 

   ::oImageList   := TImageList():New( 50, 50 ) 

   ::oImageList:AddMasked( TBitmap():Define( "gc_businessman2_50" ),   Rgb( 255, 0, 255 ) )
   ::oImageList:AddMasked( TBitmap():Define( "gc_user2_50" ),          Rgb( 255, 0, 255 ) )

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "LOGIN_TACTIL" 

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gestool_logo" ;
      TRANSPARENT ;
      OF          ::oDialog

   ::oListView          := TListView():Redefine( 100, ::oDialog )
   ::oListView:nOption  := 0
   ::oListView:bClick   := {| nOpt | ::Validate( nOpt ) }

   REDEFINE SAY   ::oSayError ;
      ID          120 ;
      COLOR       Rgb( 183, 28, 28 ) ;
      OF          ::oDialog

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          ::oDialog ;
      ACTION      ( ::oDialog:End( IDCANCEL ) )

   ::oDialog:bStart := {|| ::startActivate() }

   ::oDialog:Activate( , , , .t., , , {|| ::initActivate() } )

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD Validate( nOpt ) CLASS AccessTactilView 

   local cUsuario    := ::oListView:GetItem( nOpt ):Cargo
   local cPassword   := VirtualKey( .t., , "Introduzca contraseña" )

   if ::oController:validUserPassword( cUsuario, cPassword )
      ::oDialog:End( IDOK )
   else
      ::sayError( ::oController:cValidError )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//
