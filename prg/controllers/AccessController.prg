#include "FiveWin.Ch"
#include "Factu.ch" 

#define  __encryption_key__   "snorlax"
#define  __admin_name__       "Super administrador"
#define  __admin_password__   "superusuario"

#define ADP_NAME              1

//---------------------------------------------------------------------------//

CLASS AccessController FROM SQLBaseController

   DATA hUsuario
   DATA hEmpresa

   DATA lSelectCompany                 INIT .t.

   DATA oAccessView
   DATA oAccessTactilView
   
   DATA cValidError                    INIT "" 

   DATA oUsuariosController
   DATA oEmpresasController
   DATA oAjustableController

   DATA aComboUsuarios
   DATA cComboUsuario  

   DATA cComboEmpresa
   DATA aComboEmpresas

   DATA cGetPassword

   DATA cMacAddress                    INIT ""

   METHOD New()
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

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS AccessController

   ::Super:New()

   ::cTitle                            := "Access"

   ::cName                             := "access"

   ::hImage                            := {  "16" => "gc_businesspeople_16",;
                                             "48" => "gc_businesspeople_48" }

   ::oAccessView                       := AccessView():New( self )

   ::oAccessTactilView                 := AccessTactilView():New( self )

   ::oUsuariosController               := UsuariosController():New( self )

   ::oEmpresasController               := EmpresasController():New( self )

   ::oAjustableController              := AjustableController():New( self )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS AccessController

   ::oUsuariosController:End()
   
   ::oEmpresasController:End()

   ::oAjustableController:End()
   
   ::Super:End()

   Self                                := nil

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadUsersAndCompanies() CLASS AccessController

   local cUltimaEmpresa
   local cUltimoUsuario

   ::cGetPassword          := space( 100 )

   // Usuario------------------------------------------------------------------

   ::aComboUsuarios        := ::oUsuariosController:oModel:getArrayNombres()

   cUltimoUsuario          := ::oAjustableController:oModel:getUltimoUsuarioInMac( ::getMacAddress() )
   if empty( cUltimoUsuario )
      ::cComboUsuario      := atail( ::aComboUsuarios )
   else 
      ::cComboUsuario      := ::oUsuariosController:oModel:getNombreWhereUuid( cUltimoUsuario )
   end if 

   // Empresa------------------------------------------------------------------

   if ::isSelectCompany()

      ::aComboEmpresas     := ::oEmpresasController:oModel:getArrayNombres()

      cUltimaEmpresa       := ::oAjustableController:oModel:getUltimaEmpresaInMac( ::getMacAddress() )
      if empty( cUltimaEmpresa )
         ::cComboEmpresa   := atail( ::cComboEmpresa )
      else
         ::cComboEmpresa   := ::oEmpresasController:oModel:getNombreWhereUuid( cUltimaEmpresa )
      end if 

   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadSuperAdmin() CLASS AccessController

   ::cGetPassword          := space( 100 )

   ::aComboUsuarios        := { __admin_name__ }
   ::cComboUsuario         := __admin_name__

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD saveUsersAndCompanies() CLASS AccessController

   ::oAjustableController:oModel:setUltimaEmpresaInMac( Company():uuid(), ::getMacAddress() )

   ::oAjustableController:oModel:setUltimoUsuarioInMac( Auth():uuid(), ::getMacAddress() )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD isLogin() CLASS AccessController

   ::loadUsersAndCompanies()

   if ( ::oAccessView:Activate() != IDOK )
      RETURN ( .f. )
   end if 

   if !empty( ::hUsuario )
      Auth( ::hUsuario )
   end if 

   if ::isSelectCompany() .and. !empty( ::hEmpresa )
      Company( ::hEmpresa )
   end if 

   ::saveUsersAndCompanies()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD isLoginSuperAdmin() CLASS AccessController

   ::lSelectCompany  := .f.

   ::loadSuperAdmin()

   if ( ::oAccessView:Activate() != IDOK )
      RETURN ( .f. )
   end if 

   if !empty( ::hUsuario )
      Auth( ::hUsuario )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD isLoginTactil() CLASS AccessController

   if ( ::oLoginTactilView:Activate() != IDOK )
      RETURN ( .f. )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD validUserPassword() CLASS AccessController

   ::hUsuario                 := ::oUsuariosController:oModel:validUserPassword( ::cComboUsuario, ::cGetPassword )

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

   ::hEmpresa                 := ::oEmpresasController:oModel:validEmpresa( ::cComboEmpresa )

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
      FONT        getBoldFont() ;
      OF          ::oDialog

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          ::oDialog ;
      ACTION      ( ::Validate() )

   ::oDialog:bStart  := {|| ::startActivate() }

   ::oDialog:AddFastKey( VK_F5, {|| ::Validate() } )

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

RETURN ( self )

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
