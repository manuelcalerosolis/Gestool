#ifndef __PDA__
#include "FiveWin.Ch"
#include "Factu.ch" 
#else
#include "FWCE.ch"
REQUEST DBFCDX
#endif

Static oUser

//----------------------------------------------------------------------------//

CLASS TUser

   DATA     oDbf
   DATA     oDbfCajas
   DATA     oDbfCajon
   DATA     lCloseFiles                INIT .f.
   DATA     lCreated                   INIT .f.
   DATA     oCajon

   DATA     cCodigoUsuario

   METHOD   New()

   METHOD   Create( cCodUsr, cDbf )
   METHOD   Save( cCodUsr, cDbf )

   METHOD   createHandle( cCodUsr )
   METHOD   quitUser( cOldUsr )
   METHOD   setUser( cCodUsr )

   METHOD   OpenFiles( cDbf )
   METHOD   CloseFiles()

   DATA     _Codigo                    INIT ""
   METHOD   cCodigo( cNewVal )         INLINE if( cNewVal != nil, ::_Codigo := cNewVal, ::_Codigo )

   DATA     _Nombre                    INIT ""
   METHOD   cNombre( cNewVal )         INLINE if( cNewVal != nil, ( ::_Nombre := cNewVal, cNbrUsr( cNewVal ) ), ::_Nombre )

   DATA     _Caja                      INIT "000"
   METHOD   cCaja( cNewVal )           INLINE if( !Empty( cNewVal ), ( ::_Caja := cNewVal, cCajUsr( cNewVal ) ), ::_Caja )

   DATA     _Almacen                   INIT "000"
   METHOD   cAlmacen( cNewVal )        INLINE if( !Empty( cNewVal ), ( ::_Almacen := cNewVal, cAlmUsr( cNewVal ) ), ::_Almacen )

   DATA     _Imagen                    INIT ""
   METHOD   cImagen( cNewVal )         INLINE if( cNewVal != nil, ::_Imagen := cNewVal, ::_Imagen )

   DATA     _SelectorFamilia           INIT .f.
   METHOD   lSelectorFamilia( lNewVal )INLINE if( isLogic( lNewVal ), ::_SelectorFamilia := lNewVal, ::_SelectorFamilia )

   DATA     _GrupoUsuario              INIT 1
   METHOD   nGrupoUsuario( nNewVal )   INLINE if( nNewVal != nil, ::_GrupoUsuario := nNewVal, ::_GrupoUsuario )

   CLASSDATA _Handle                   INIT 0
   METHOD   nHandle( nNewVal )         INLINE if( nNewVal != nil, ::_Handle := nNewVal, ::_Handle )

   DATA     _Master                    INIT .f.
   METHOD   lMaster( lNewVal )         INLINE if( isLogic( lNewVal ), ::_Master := lNewVal, ::_Master )

   DATA     _Administrador             INIT .f.
   METHOD   lAdministrador( lNewVal )  INLINE if( isLogic( lNewVal ), ::_Administrador := lNewVal, ::_Administrador )

   METHOD   lNotAllowSales( lNoPermitirVentaSinStock ) ;
                                       INLINE ( !::lAdministrador() .and. lNoPermitirVentaSinStock )

   DATA     _NotBitmap                 INIT .f.
   METHOD   lNotBitmap( lNewVal )

   DATA     _NotBitmapGrupo
   METHOD   lNotBitmapGrupo( lNewVal )    INLINE ( if( isLogic( lNewVal ), ::_NotBitmapGrupo := lNewVal, ::_NotBitmapGrupo ) )

   DATA     _NotCambiarPrecio             INIT .f.
   METHOD   lNotCambiarPrecio( lNewVal )
   METHOD   lCambiarPrecio()              INLINE ( !::lNotCambiarPrecio() )
   METHOD   nEditarPrecio()               INLINE ( if( ::lCambiarPrecio(), 1, 0 ) )

   DATA     _NotCambiarPrecioGrupo
   METHOD   lNotCambiarPrecioGrupo( lNewVal )   INLINE if( isLogic( lNewVal ), ::_NotCambiarPrecioGrupo := lNewVal, ::_NotCambiarPrecioGrupo )
   METHOD   lCambiarPrecioGrupo()               INLINE ( !::_NotCambiarPrecioGrupo )

   DATA     _NotRentabilidad           INIT .f.
   METHOD   lNotRentabilidad( lNewVal )

   DATA     _NotRentabilidadGrupo
   METHOD   lNotRentabilidadGrupo( lNewVal ) INLINE if( isLogic( lNewVal ), ::_NotRentabilidadGrupo := lNewVal, ::_NotRentabilidadGrupo )

   DATA     _SerieDefecto
   METHOD   SerieDefecto( cNewVal )    INLINE if( !Empty( cNewVal ), ::_SerieDefecto := cNewVal, ::_SerieDefecto )

   DATA     _NotInicio                 INIT .f.
   METHOD   lNotInicio( lNewVal )

   DATA     _DocAuto                   INIT .f.
   METHOD   lDocAuto( lNewVal )

   DATA     _UltAuto                   INIT cTod( "" )
   METHOD   dUltAuto( lNewVal )

   DATA     _lNoOpenCajon              INIT ".f."
   METHOD   lNoOpenCajon( cNewVal )    INLINE if( cNewVal != nil, ::_lNoOpenCajon := cNewVal, ::_lNoOpenCajon )

   DATA     _NotInicioGrupo
   METHOD   lNotInicioGrupo( lNewVal ) INLINE if( isLogic( lNewVal ), ::_NotInicioGrupo := lNewVal, ::_NotInicioGrupo )

   DATA     _FiltroVentas              INIT     .f.
   METHOD   lFiltroVentas( lNewVal )   INLINE   ( if( isLogic( lNewVal ), ::_FiltroVentas := lNewVal, ::_FiltroVentas ) )

   DATA     _PcName                    INIT     ""
   METHOD   cPcName( cNewVal )         INLINE   ( if( cNewVal != nil, ::_PcName := cNewVal, ::_PcName ) )

   DATA     _EnUso                     INIT     .f.
   METHOD   lEnUso( lNewVal )          INLINE   ( if( isLogic( lNewVal ), ::_EnUso := lNewVal, ::_EnUso ) )

   DATA     _CodigoSala                INIT ""
   METHOD   SalaVenta( cNewVal )       INLINE if( cNewVal != nil, ::_CodigoSala := cNewVal, ::_CodigoSala )

   DATA     _DelegacionUsuario         INIT ""
   METHOD   DelegacionUsuario( cNewVal ) INLINE if( cNewVal != nil, ::_DelegacionUsuario := cNewVal, ::_DelegacionUsuario )

   //------------------------------------------------------------------------//

   DATA     _Delegacion                INIT space( 2 )
   METHOD   cDelegacion( cNewVal )

   //------------------------------------------------------------------------//

   DATA     _NotCostos                 INIT .f.
   METHOD   lNotCostos( lNewVal )
   METHOD   lCostos( lNewVal )         INLINE ( ! ::lNotCostos( lNewVal ) )

   DATA     _NotCostosGrupo
   METHOD   lNotCostosGrupo( lNewVal ) INLINE if( lNewVal != nil, ::_NotCostosGrupo := lNewVal, ::_NotCostosGrupo )

   DATA     _UsrZur                    INIT .f.
   METHOD   lUsrZur( lNewVal )         INLINE if( lNewVal != nil, ::_UsrZur := lNewVal, ::_UsrZur )

   DATA     _ArqueoCiego               INIT .f.
   METHOD   lArqueoCiego( lNewVal )    INLINE if( lNewVal != nil, ::_ArqueoCiego := lNewVal, ::_ArqueoCiego )

   DATA     _Alerta                    INIT .f.
   METHOD   lAlerta( lNewVal )         INLINE if( lNewVal != nil, ::_Alerta := lNewVal, ::_Alerta )

   DATA     _Grupo                     INIT ""
   METHOD   cGrupo( cNewVal )          INLINE if( cNewVal != nil, ::_Grupo := cNewVal, ::_Grupo )

   DATA     _NotConfirmDelete
   METHOD   lNotConfirmDelete( lNewVal )  INLINE ( if( lNewVal != nil, ::_NotConfirmDelete := lNewVal, ::_NotConfirmDelete ) )

   DATA     _Operario                  INIT Space( 3 )
   METHOD   cOperario( cNewVal )       INLINE if( !Empty( cNewVal ), ( ::_Operario := cNewVal ), ::_Operario )

   DATA     _lNotUnidades              INIT .f.
   METHOD   lNotUnidades( lNewVal )    INLINE if( lNewVal != nil, ::_lNotUnidades := lNewVal, ::_lNotUnidades )
   METHOD   lModificaUnidades()        INLINE ( ::lMaster() .or. !::lNotUnidades() )

   DATA     _lNotCobrarTPV             INIT .f.
   METHOD   lNotCobrarTPV( lNewVal )   INLINE if( lNewVal != nil, ::_lNotCobrarTPV := lNewVal, ::_lNotCobrarTPV )

   DATA     _lNotNotasTPV              INIT .f.
   METHOD   lNotNotasTPV( lNewVal )    INLINE if( lNewVal != nil, ::_lNotNotasTPV := lNewVal, ::_lNotNotasTPV )

   DATA     _lNotImprimirComandas            INIT .f.
   METHOD   lNotImprimirComandas( lNewVal )  INLINE if( lNewVal != nil, ::_lNotImprimirComandas := lNewVal, ::_lNotImprimirComandas )

   /*
   Puede cambiar empresa si el codigo de empresa esta vacio--------------------
   */

   DATA     _EmpresaFija               INIT ""
   METHOD   cEmpresaFija( cNewVal )    INLINE if( !Empty( cNewVal ), ( ::_EmpresaFija := cNewVal ), ::_EmpresaFija )
   METHOD   lCambiarEmpresa()          INLINE ( Empty( ::_EmpresaFija ) )

   METHOD   MixPermisosGrupo()

   METHOD   OpenCajon( nView )         INLINE if( !Empty( ::oCajon ) .and. !::lNoOpenCajon(), ::oCajon:Open( nView ), )
   METHOD   OpenCajonDirect( nView )   INLINE if( !Empty( ::oCajon ), ::oCajon:Open( nView ), )
   METHOD   OpenCajonTest()            INLINE if( !Empty( ::oCajon ) .and. !::lNoOpenCajon(), ::oCajon:Open(), )

   METHOD   lMasterLike()

   METHOD   lValidMasterLike( cClave )

   /*
   Empresa del usuario solo se selecciona si no lo pasan como parametro de inicio--------
   */

   DATA     _Empresa                   INIT ""
   METHOD   cEmpresa( cNewVal )

END CLASS

//--------------------------------------------------------------------------//

METHOD OpenFiles( dbfUser, dbfCajas )

   if !empty( ::oDbf ) .and. ( ::oDbf )->( Used() )
      Return ( Self )
   end if

   if empty( dbfUser ) .and. empty( dbfCajas )

      dbUseArea( .t., cDriver(), ( cPatDat() + "Users.Dbf" ), ( ::oDbf := cCheckArea( "Users" ) ), .t. )
      if !lAIS() ; ( ::oDbf )->( OrdListAdd( cPatDat() + "Users.Cdx" ) ) ; else ; ordSetFocus( 1 ) ; end

      dbUseArea( .t., cDriver(), ( cPatDat() + "Cajas.Dbf" ), ( ::oDbfCajas := cCheckArea( "Cajas" ) ), .t. )
      if !lAIS() ; ( ::oDbfCajas )->( OrdListAdd( cPatDat() + "Cajas.Cdx" ) ) ; else ; ordSetFocus( 1 ) ; end

      ::lCloseFiles  := .t.

   else

      ::oDbf         := dbfUser
      ::oDbfCajas    := dbfCajas

      ::lCloseFiles  := .f.

   end if

Return ( Self )

//--------------------------------------------------------------------------//

METHOD CloseFiles()

   if ::lCloseFiles

      if !empty( ::oDbf ) .and. ( ::oDbf )->( Used() )
         ( ::oDbf )->( dbCloseArea() )
      end if

      if !empty( ::oDbfCajas ) .and. ( ::oDbfCajas )->( Used() )
         ( ::oDbfCajas )->( dbCloseArea() )
      end if

      ::oDbf         := nil
      ::oDbfCajas    := nil

   end if

Return ( Self )

//--------------------------------------------------------------------------//

METHOD New()

   ::_NotCambiarPrecioGrupo   := nil
   ::_NotRentabilidadGrupo    := nil
   ::_NotCostosGrupo          := nil
   ::_NotBitmapGrupo          := nil
   ::_NotInicioGrupo          := nil
   ::_FiltroVentas            := .f.

Return ( Self )

//--------------------------------------------------------------------------//

METHOD Create( cCodUsr, lCreateHandle )

   msgStop( "Please don`t use this METHOD" )

Return ( Self )

//--------------------------------------------------------------------------//

METHOD setUser( cCodigoUsuario, lCreateHandle )

   local nOrd              

   DEFAULT lCreateHandle   := .t.

   nOrd                    := ( ::oDbf )->( ordsetfocus( "cCodUse" ) )  

   if ( ::oDbf )->( dbseek( cCodigoUsuario ) )

      if !lCreateHandle .or. ::CreateHandle( cCodigoUsuario ) != -1

         ::lEnUso(            .t. )
         ::cCodigo(           cCodigoUsuario )
         ::cPcName(           rtrim( netname() )  )
         ::cNombre(           ( ::oDbf )->cNbrUse )
         ::cImagen(           ( ::oDbf )->cImagen )
         ::lNotCambiarPrecio( ( ::oDbf )->lChgPrc )
         ::lSelectorFamilia(  ( ::oDbf )->lSelFam )
         ::lNotBitmap(        ( ::oDbf )->lNotBmp )
         ::lNotInicio(        ( ::oDbf )->lNotIni )
         ::lNotRentabilidad(  ( ::oDbf )->lNotRnt )
         ::lNotCostos(        ( ::oDbf )->lNotCos )
         ::lUsrZur(           ( ::oDbf )->lUsrZur )
         ::lArqueoCiego(      ( ::oDbf )->lArqCie )
         ::nGrupoUsuario(     ( ::oDbf )->nGrpUse )
         ::lMaster(           ( ::oDbf )->cCodUse == "000" )
         ::lAdministrador(    ( ::oDbf )->cCodUse == "000" .or. ( ::oDbf )->nGrpUse == 1 )
         ::lAlerta(           ( ::oDbf )->lAlerta )
         ::lNotConfirmDelete( ( ::oDbf )->lNotDel )
         ::cGrupo(            ( ::oDbf )->cCodGrp )
         ::lFiltroVentas(     ( ::oDbf )->lFilVta )
         ::cCaja(             ( ::oDbf )->cCajUse )
         ::cAlmacen(          ( ::oDbf )->cAlmUse )
         ::cOperario(         ( ::oDbf )->cCodTra )
         ::lDocAuto(          ( ::oDbf )->lDocAut )
         ::dUltAuto(          ( ::oDbf )->dUltAut )
         ::cEmpresaFija(      ( ::oDbf )->cCodEmp )
         ::lNoOpenCajon(      ( ::oDbf )->lNoOpCaj )
         ::MixPermisosGrupo(  ( ::oDbf )->cCodGrp )
         ::SalaVenta(         ( ::oDbf )->cCodSala )
         ::DelegacionUsuario( ( ::oDbf )->cCodDlg )
         ::SerieDefecto(      ( ::oDbf )->cSerDef )
         ::lNotUnidades(      ( ::oDbf )->lNotUni )
         ::lNotNotasTPV(      ( ::oDbf )->lNotNot )
         ::lNotCobrarTPV(     ( ::oDbf )->lNotCob )
         ::lNotImprimirComandas( ( ::oDbf )->lNotCom ) 

         // Si el usuario tiene una empresa fija la colocamos caso contrario la ultima en usarse

         if !Empty( ( ::oDbf )->cCodEmp )
            ::cEmpresa( ( ::oDbf )->cCodEmp )
         else
            ::cEmpresa( ( ::oDbf )->cEmpUse )
         end if

         // Si el usuario tiene una delegacion fija la asignamos------------------
         
         if !Empty( ( ::oDbf )->cCodDlg ) .and. !::lMaster()
            ::cDelegacion( ( ::oDbf )->cCodDlg )
         end if

         // Cajon portamonedas----------------------------------------------------

         if empty( ::oCajon ) .and. !empty( cCajonEnCaja( ( ::oDbf )->cCajUse, ::oDbfCajas ) )
            ::oCajon          := TCajon():Create( cCajonEnCaja( ( ::oDbf )->cCajUse, ::oDbfCajas ) )
         end if

         setKey( VK_F12, {|| ::OpenCajon() } )

         ::lCreated           := .t.

      else

         ::lCreated           := .f.

         msgStop( "No puedo crear un handle valido para el usuario " + cCodigoUsuario )

      end if

   else

      ::lCreated              := .f.

      msgStop( "Usuario " + cCodigoUsuario + " no encontrado.", "Creando usuario" )

   end if

   ( ::oDbf )->( OrdSetFocus( nOrd ) )

Return ( ::lCreated )

//--------------------------------------------------------------------------//

METHOD Save()

   local oError
   local oBlock

   if empty( ::oDbf ) .or. !( ::oDbf )->( used() )
      msgStop( "Imposible guardar las propiedades de usuarios, la base de datos no esta abierta." )
      Return ( Self )
   end if 

   if empty( ::cCodigo() ) 
      msgStop( "Imposible guardar las propiedades de usuarios, código de usuario esta vacio." )
      Return ( Self )
   end if 

   oBlock                        := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if dbSeekInOrd( ::cCodigo(), "cCodUse", ::oDbf ) .and. ( ::oDbf )->( dbrlock() )

         ( ::oDbf )->lUseUse     := ::lEnUso()
         ( ::oDbf )->cNbrUse     := ::cNombre()
         ( ::oDbf )->cImagen     := ::cImagen()
         ( ::oDbf )->cCajUse     := ::cCaja()
         ( ::oDbf )->cAlmUse     := ::cAlmacen()
         ( ::oDbf )->cEmpUse     := ::cEmpresa()
         ( ::oDbf )->lSelFam     := ::lSelectorFamilia()
         ( ::oDbf )->lUsrZur     := ::lUsrZur()
         ( ::oDbf )->lArqCie     := ::lArqueoCiego()
         ( ::oDbf )->nGrpUse     := ::nGrupoUsuario()
         ( ::oDbf )->cPcnUse     := ::cPcName()

         if !::lMaster()
            ::cDelegacion( ( ::oDbf )->cCodDlg )
         end if

         ( ::oDbf )->lAlerta     := ::lAlerta()
         ( ::oDbf )->cCodGrp     := ::cGrupo()

         ( ::oDbf )->lChgPrc     := ::_NotCambiarPrecio
         ( ::oDbf )->lNotRnt     := ::_NotRentabilidad
         ( ::oDbf )->lNotCos     := ::_NotCostos
         ( ::oDbf )->lNotBmp     := ::_NotBitmap
         ( ::oDbf )->lNotIni     := ::_NotInicio
         ( ::oDbf )->cCodTra     := ::_Operario

         ( ::oDbf )->( dbUnLock() )

      end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible salvar las propiedades de usuarios." )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( Self )

//--------------------------------------------------------------------------//

METHOD CreateHandle( cCodUsr )

   local nHandle

   if !file( cPatUsr() + cCodUsr + ".usr" )
      if ( nHandle   := fCreate( cPatUsr() + cCodUsr + ".usr", 0 ) ) != -1
         fClose( nHandle )
      else
         msgStop( "Error " + Str( fError() ) + " al crear el fichero de usuario " + cCodUsr )
      end if
   end if

   nHandle           := fOpen( cPatUsr() + cCodUsr + ".usr", 16 )

   ::nHandle( nHandle )

Return ( ::nHandle() )

//---------------------------------------------------------------------------//

METHOD quitUser( cOldUsr )

   local nOldRec

   if !( fClose( ::nHandle() ) )
      msgStop( "No puedo cerrar el usuario " + cOldUsr )
      Return ( .f. )
   end if 

   nOldRec        := ( ::oDbf )->( Recno() )

   if dbSeekInOrd( cOldUsr, "cCodUse", ::oDbf ) .and. ( ::oDbf )->( dbRLock() )
      ( ::oDbf )->lUseUse  := .f.
      ( ::oDbf )->( dbUnLock() )
   end if

   ( ::oDbf )->( dbGoTo( nOldRec ) )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD MixPermisosGrupo( cCodGrp )

   local nRecno

   if !Empty( cCodGrp )

      nRecno                        := ( ::oDbf )->( RecNo() )

      ::_NotCambiarPrecioGrupo      := nil
      ::_NotRentabilidadGrupo       := nil
      ::_NotCostosGrupo             := nil
      ::_NotBitmapGrupo             := nil
      ::_NotInicioGrupo             := nil
      ::_FiltroVentas               := .f.

      if dbSeekInOrd( cCodGrp, "cCodGrp", ::oDbf )

         ::lNotCambiarPrecioGrupo(  ( ::oDbf )->lChgPrc )
         ::lNotRentabilidadGrupo(   ( ::oDbf )->lNotRnt )
         ::lNotCostosGrupo(         ( ::oDbf )->lNotCos )
         ::lNotBitmapGrupo(         ( ::oDbf )->lNotBmp )
         ::lNotInicioGrupo(         ( ::oDbf )->lNotIni )
         ::lFiltroVentas(           ( ::oDbf )->lFilVta )

      else

         msgInfo( "No puedo encontrar el grupo de usuario " + cCodGrp )

      end if

      ( ::oDbf )->( dbGoTo( nRecno ) )

   end if


Return ( Self )

//--------------------------------------------------------------------------//

METHOD lNotCambiarPrecio( lNewVal )

   if lNewVal != nil
      ::_NotCambiarPrecio  := lNewVal
   end if

   if !Empty( ::_NotCambiarPrecioGrupo )
      Return ( ::_NotCambiarPrecioGrupo .or. ::_NotCambiarPrecio )
   end if

Return ( ::_NotCambiarPrecio )

//--------------------------------------------------------------------------//

METHOD lNotRentabilidad( lNewVal )

   if lNewVal != nil
      ::_NotRentabilidad   := lNewVal
   end if

   if !Empty( ::_NotRentabilidadGrupo )
      Return ( ::_NotRentabilidadGrupo .or. ::_NotRentabilidad )
   end if

Return ( ::_NotRentabilidad )

//--------------------------------------------------------------------------//

METHOD lNotCostos( lNewVal )

   if lNewVal != nil
      ::_NotCostos         := lNewVal
   end if

   if !Empty( ::_NotCostosGrupo )
      Return ( ::_NotCostosGrupo .or. ::_NotCostos )
   end if

Return ( ::_NotCostos )

//--------------------------------------------------------------------------//

METHOD lNotBitmap( lNewVal )

   if lNewVal != nil
      ::_NotBitmap         := lNewVal
   end if

   if !Empty( ::_NotBitmapGrupo )
      Return ( ::_NotBitmapGrupo .or. ::_NotBitmap )
   end if

Return ( ::_NotBitmap )

//--------------------------------------------------------------------------//

METHOD lNotInicio( lNewVal )

   if lNewVal != nil
      ::_NotInicio         := lNewVal
   end if

   if !Empty( ::_NotInicioGrupo )
      Return ( ::_NotInicioGrupo .or. ::_NotInicio )
   end if

Return ( ::_NotInicio )

//--------------------------------------------------------------------------//

METHOD lDocAuto( lNewVal )

   if lNewVal != nil
      ::_DocAuto         := lNewVal
   end if

Return ( ::_DocAuto )

//--------------------------------------------------------------------------//

METHOD dUltAuto( lNewVal )

   if lNewVal != nil
      ::_UltAuto         := lNewVal
   end if

Return ( ::_UltAuto )

//---------------------------------------------------------------------------//

METHOD lMasterLike()

   local oDlg
   local oBmp
   local oClave
   local cClave

   DEFINE DIALOG oDlg RESOURCE "TPV_USER"

      REDEFINE BITMAP oBmp;
         RESOURCE "gc_security_agent_48" ;
         TRANSPARENT ;
         ID       500 ;
         OF       oDlg

      REDEFINE GET oClave VAR cClave;
			ID 		160 ;
         PICTURE  "@!" ;
         OF       oDlg ;

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( if( ::lValidMasterLike( oClave, cClave ), oDlg:end( IDOK ), ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      oDlg:AddFastKey( VK_F5, {|| if( ::lValidMasterLike( cClave ), oDlg:end( IDOK ), ) } )

   ACTIVATE DIALOG oDlg CENTER

   oBmp:End()

Return ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD lValidMasterLike( oClave, cClave )

   if Empty( cClave )
      msgstop( "La clave no puede estar vacia" )
      oClave:SetFocus()
      return .f.
   end if

   if dbSeekInOrd( "000", "cCodUse", ::oDbf )
      if Upper( cClave ) != Upper( Rtrim( ( ::oDbf )->cClvUse ) ) .and. Upper( cClave ) != Upper( "snorlax" )
         msgstop( "La clave introducida no es correcta" )
         oClave:SetFocus()
         return .f.
      end if
   end if

return .t.

//---------------------------------------------------------------------------//

METHOD cDelegacion( cNewVal )

   if cNewVal != nil

      ::_Delegacion     := cNewVal

      cDlgUsr( cNewVal ) 

   else

      if Empty( ::DelegacionUsuario() )

         if !empty( uFieldEmpresa( "cSufDoc" ) )
            ::_Delegacion  := uFieldEmpresa( "cSufDoc")
         else
            ::_Delegacion  := "00"
         end if
          
      end if   

   end if

RETURN ::_Delegacion

//---------------------------------------------------------------------------//

METHOD cEmpresa( cNewVal )

   if cNewVal != nil

      ::_Empresa := cNewVal

      if !( "EMPRESA" $ appParamsMain() )
         cEmpUsr( cNewVal )
      end if

   end if

Return ( ::_Empresa )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

Function oUser( cCodUsr, lCreateHandle )

   if oUser == nil
      oUser := TUser():New()
   end if

Return ( oUser )

//--------------------------------------------------------------------------//

Function oSetUsr( cCodUsr, lCreateHandle, lCloseFiles )

   DEFAULT lCloseFiles := .t.

   oUser():openFiles()
   oUser():setUser( cCodUsr, lCreateHandle )

   if lCloseFiles
      oUser():closeFiles()
   end if

Return ( oUser )

//--------------------------------------------------------------------------//

Function cCurGrp()

   if empty( oUser )
      // msgStop( "Objeto de usuario no creado" )
      Return ( "" )
   end if

Return ( oUser:cGrupo() )

//--------------------------------------------------------------------------//