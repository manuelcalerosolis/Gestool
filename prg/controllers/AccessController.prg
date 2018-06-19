#include "FiveWin.Ch"
#include "Factu.ch" 

#define  __encryption_key__   "snorlax"
#define  __admin_name__       "Super administrador"
#define  __admin_password__   "superusuario"

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

   METHOD New()
   METHOD End()

   METHOD validUserPassword( cUsuario, cPassword )
   METHOD validCompany( cEmpresa )

   METHOD isLogin()
   METHOD isLoginSuperAdmin()
   METHOD isLoginTactil()

   METHOD isSelectCompany()            INLINE ( ::lSelectCompany )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( lSelectCompany ) CLASS AccessController

   DEFAULT lSelectCompany              := .t.

   ::Super:New()

   ::cTitle                            := "Access"

   ::cName                             := "access"

   ::hImage                            := {  "16" => "gc_businesspeople_16",;
                                             "48" => "gc_businesspeople_48" }

   ::lSelectCompany                    := lSelectCompany

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

METHOD isLogin() CLASS AccessController

   ::oAccessView:loadUsersAndCompanies()

   if ( ::oAccessView:Activate() != IDOK )
      RETURN ( .f. )
   end if 

   if !empty( ::hUsuario )
      Auth( ::hUsuario )
   end if 

   if ::isSelectCompany() .and. !empty( ::hEmpresa )
      Company( ::hEmpresa )
   end if 

   ::oAjustableController:oModel:setUsuarioPcEnUso( rtrim( netname() ), Auth():uuid() )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD isLoginSuperAdmin() CLASS AccessController

   ::aComboUsuarios        := ::oController:oUsuariosController:oModel:getArrayNombres()

   if ( ::oAccessView:Activate() != IDOK )
      RETURN ( .f. )
   end if 

   if !empty( ::hUsuario )
      Auth( ::hUsuario )
   end if 

   ::oAjustableController:oModel:setUsuarioPcEnUso( rtrim( netname() ), Auth():uuid() )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD isLoginTactil() CLASS AccessController

   if ( ::oLoginTactilView:Activate() != IDOK )
      RETURN ( .f. )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD validUserPassword( cUsuario, cPassword ) CLASS AccessController

   ::hUsuario                 := ::oUsuariosController:oModel:validUserPassword( cUsuario, cPassword )

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

METHOD validCompany( cEmpresa ) CLASS AccessController

   ::hEmpresa                 := ::oEmpresasController:oModel:validEmpresa( cEmpresa )

   if empty( ::hEmpresa )
      ::cValidError           := "Empresa no existe" 
      RETURN ( .f. )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS AccessView FROM SQLBaseView

   DATA oSayError

   DATA oGetPassword
   DATA cGetPassword

   DATA oComboUsuario
   DATA cComboUsuario   
   DATA aComboUsuarios  

   DATA oSayEmpresa
   DATA oComboEmpresa
   DATA cComboEmpresa
   DATA aComboEmpresas

   METHOD isSelectCompany()         INLINE ( ::oController:lSelectCompany )

   METHOD Activate()
   METHOD ActivateWithCompany()     INLINE ( ::setShowEmpresa( .t. ), ::Activate() )
   METHOD startActivate()

   METHOD loadSuperAdmin() 
   METHOD loadUsersAndCompanies()

   METHOD Validate()

   METHOD sayError( cError )        INLINE ( ::oSayError:setText( cError ), ::oSayError:Show(), dialogSayNo( ::oDialog ) )
   
END CLASS

//---------------------------------------------------------------------------//

METHOD loadUsersAndCompanies() CLASS AccessView

   if ::isSelectCompany()
      ::aComboEmpresas     := ::oController:oEmpresasController:oModel:getArrayNombres()
      ::cComboEmpresa      := atail( ::aComboEmpresas )
   end if 

   ::aComboUsuarios        := ::oController:oUsuariosController:oModel:getArrayNombres()
   ::cComboUsuario         := ::oController:oUsuariosController:oModel:getNombreUsuarioWhereNetName( netname() )
   
   ::cGetPassword          := space( 100 )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD loadSuperAdmin() CLASS AccessView

   ::aComboUsuarios        := { __admin_name__ }
   ::cComboUsuario         := __admin_name__

   ::cGetPassword          := space( 100 )

RETURN ( self )

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
      VAR         ::cComboEmpresa ;
      ID          130 ;
      ITEMS       ::aComboEmpresas ;
      OF          ::oDialog

   REDEFINE COMBOBOX ::oComboUsuario ;
      VAR         ::cComboUsuario ;
      ID          100 ;
      ITEMS       ::aComboUsuarios ;
      OF          ::oDialog

   REDEFINE GET   ::oGetPassword ;
      VAR         ::cGetPassword ;
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

   if !( ::oController:validUserPassword( ::cComboUsuario, ::cGetPassword ) )
      ::sayError( ::oController:cValidError )
      RETURN ( nil )
   end if 

   if ::isSelectCompany() .and. !( ::oController:validCompany( ::cComboEmpresa ) )
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

   METHOD sayError( cError )  INLINE ( ::oSayError:setText( cError ), ::oSayError:Show(), dialogSayNo( ::oDialog ) )
   
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
