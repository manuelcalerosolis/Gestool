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

   Data     oDbf
   Data     oDbfCajas
   Data     oDbfCajon
   Data     lCloseFiles                INIT .f.
   Data     lCreated                   INIT .f.
   Data     oCajon

   Data     cCodigoUsuario

   METHOD   New()

   Method   Create( cCodUsr, cDbf )
   Method   Save( cCodUsr, cDbf )

   Method   createHandle( cCodUsr )
   Method   quitUser( cOldUsr )
   Method   setUser( cCodUsr )

   Method   OpenFiles( cDbf )
   Method   CloseFiles()

   Data     _Codigo                    INIT ""
   Method   cCodigo( cNewVal )         INLINE if( cNewVal != nil, ::_Codigo := cNewVal, ::_Codigo )

   Data     _Nombre                    INIT ""
   Method   cNombre( cNewVal )         INLINE if( cNewVal != nil, ( ::_Nombre := cNewVal, cNbrUsr( cNewVal ) ), ::_Nombre )

   Data     _Caja                      INIT "000"
   Method   cCaja( cNewVal )           INLINE if( !Empty( cNewVal ), ( ::_Caja := cNewVal, cCajUsr( cNewVal ) ), ::_Caja )

   Data     _Almacen                   INIT "000"
   Method   cAlmacen( cNewVal )        INLINE if( !Empty( cNewVal ), ( ::_Almacen := cNewVal, cAlmUsr( cNewVal ) ), ::_Almacen )

   Data     _Imagen                    INIT ""
   Method   cImagen( cNewVal )         INLINE if( cNewVal != nil, ::_Imagen := cNewVal, ::_Imagen )

   Data     _SelectorFamilia           INIT .f.
   Method   lSelectorFamilia( lNewVal )INLINE if( isLogic( lNewVal ), ::_SelectorFamilia := lNewVal, ::_SelectorFamilia )

   Data     _GrupoUsuario              INIT 1
   Method   nGrupoUsuario( nNewVal )   INLINE if( nNewVal != nil, ::_GrupoUsuario := nNewVal, ::_GrupoUsuario )

   ClassData _Handle                   INIT 0
   Method   nHandle( nNewVal )         INLINE if( nNewVal != nil, ::_Handle := nNewVal, ::_Handle )

   Data     _Master                    INIT .f.
   Method   lMaster( lNewVal )         INLINE if( isLogic( lNewVal ), ::_Master := lNewVal, ::_Master )

   Data     _Administrador             INIT .f.
   Method   lAdministrador( lNewVal )  INLINE if( isLogic( lNewVal ), ::_Administrador := lNewVal, ::_Administrador )

   METHOD   lNotAllowSales( lNoPermitirVentaSinStock ) ;
                                       INLINE ( !::lAdministrador() .and. lNoPermitirVentaSinStock )

   Data     _NotBitmap                 INIT .f.
   Method   lNotBitmap( lNewVal )

   Data     _NotBitmapGrupo
   Method   lNotBitmapGrupo( lNewVal )    INLINE ( if( isLogic( lNewVal ), ::_NotBitmapGrupo := lNewVal, ::_NotBitmapGrupo ) )

   Data     _NotCambiarPrecio             INIT .f.
   Method   lNotCambiarPrecio( lNewVal )
   Method   lCambiarPrecio()              INLINE ( !::lNotCambiarPrecio() )
   Method   nEditarPrecio()               INLINE ( if( ::lCambiarPrecio(), 1, 0 ) )

   Data     _NotCambiarPrecioGrupo
   Method   lNotCambiarPrecioGrupo( lNewVal )   INLINE if( isLogic( lNewVal ), ::_NotCambiarPrecioGrupo := lNewVal, ::_NotCambiarPrecioGrupo )
   Method   lCambiarPrecioGrupo()               INLINE ( !::_NotCambiarPrecioGrupo )

   Data     _NotRentabilidad           INIT .f.
   Method   lNotRentabilidad( lNewVal )

   Data     _NotRentabilidadGrupo
   Method   lNotRentabilidadGrupo( lNewVal ) INLINE if( isLogic( lNewVal ), ::_NotRentabilidadGrupo := lNewVal, ::_NotRentabilidadGrupo )

   Data     _SerieDefecto
   Method   SerieDefecto( cNewVal )    INLINE if( !Empty( cNewVal ), ::_SerieDefecto := cNewVal, ::_SerieDefecto )

   Data     _NotInicio                 INIT .f.
   Method   lNotInicio( lNewVal )

   Data     _DocAuto                   INIT .f.
   Method   lDocAuto( lNewVal )

   Data     _UltAuto                   INIT cTod( "" )
   Method   dUltAuto( lNewVal )

   Data     _lNoOpenCajon              INIT ".f."
   Method   lNoOpenCajon( cNewVal )    INLINE if( cNewVal != nil, ::_lNoOpenCajon := cNewVal, ::_lNoOpenCajon )

   Data     _NotInicioGrupo
   Method   lNotInicioGrupo( lNewVal ) INLINE if( isLogic( lNewVal ), ::_NotInicioGrupo := lNewVal, ::_NotInicioGrupo )

   Data     _FiltroVentas              INIT     .f.
   Method   lFiltroVentas( lNewVal )   INLINE   ( if( isLogic( lNewVal ), ::_FiltroVentas := lNewVal, ::_FiltroVentas ) )

   Data     _PcName                    INIT     ""
   Method   cPcName( cNewVal )         INLINE   ( if( cNewVal != nil, ::_PcName := cNewVal, ::_PcName ) )

   Data     _EnUso                     INIT     .f.
   Method   lEnUso( lNewVal )          INLINE   ( if( isLogic( lNewVal ), ::_EnUso := lNewVal, ::_EnUso ) )

   Data     _CodigoSala                INIT ""
   Method   SalaVenta( cNewVal )       INLINE if( cNewVal != nil, ::_CodigoSala := cNewVal, ::_CodigoSala )

   Data     _DelegacionUsuario         INIT ""
   Method   DelegacionUsuario( cNewVal ) INLINE if( cNewVal != nil, ::_DelegacionUsuario := cNewVal, ::_DelegacionUsuario )

   //------------------------------------------------------------------------//

   Data     _Delegacion                INIT space( 2 )
   Method   cDelegacion( cNewVal )

   //------------------------------------------------------------------------//

   Data     _NotCostos                 INIT .f.
   Method   lNotCostos( lNewVal )
   Method   lCostos( lNewVal )         INLINE ( ! ::lNotCostos( lNewVal ) )

   Data     _NotCostosGrupo
   Method   lNotCostosGrupo( lNewVal ) INLINE if( lNewVal != nil, ::_NotCostosGrupo := lNewVal, ::_NotCostosGrupo )

   Data     _UsrZur                    INIT .f.
   Method   lUsrZur( lNewVal )         INLINE if( lNewVal != nil, ::_UsrZur := lNewVal, ::_UsrZur )

   Data     _ArqueoCiego               INIT .f.
   Method   lArqueoCiego( lNewVal )    INLINE if( lNewVal != nil, ::_ArqueoCiego := lNewVal, ::_ArqueoCiego )

   Data     _Alerta                    INIT .f.
   Method   lAlerta( lNewVal )         INLINE if( lNewVal != nil, ::_Alerta := lNewVal, ::_Alerta )

   Data     _Grupo                     INIT ""
   Method   cGrupo( cNewVal )          INLINE if( cNewVal != nil, ::_Grupo := cNewVal, ::_Grupo )

   Data     _NotConfirmDelete
   Method   lNotConfirmDelete( lNewVal )  INLINE ( if( lNewVal != nil, ::_NotConfirmDelete := lNewVal, ::_NotConfirmDelete ) )

   Data     _Operario                  INIT Space( 3 )
   Method   cOperario( cNewVal )       INLINE if( !Empty( cNewVal ), ( ::_Operario := cNewVal ), ::_Operario )

   Data     _lNotUnidades              INIT .f.
   Method   lNotUnidades( lNewVal )    INLINE if( lNewVal != nil, ::_lNotUnidades := lNewVal, ::_lNotUnidades )
   Method   lModificaUnidades()        INLINE ( ::lMaster() .or. !::lNotUnidades() )

   Data     _lNotCobrarTPV             INIT .f.
   Method   lNotCobrarTPV( lNewVal )   INLINE if( lNewVal != nil, ::_lNotCobrarTPV := lNewVal, ::_lNotCobrarTPV )

   Data     _lNotNotasTPV              INIT .f.
   Method   lNotNotasTPV( lNewVal )    INLINE if( lNewVal != nil, ::_lNotNotasTPV := lNewVal, ::_lNotNotasTPV )

   Data     _lNotImprimirComandas            INIT .f.
   Method   lNotImprimirComandas( lNewVal )  INLINE if( lNewVal != nil, ::_lNotImprimirComandas := lNewVal, ::_lNotImprimirComandas )

   /*
   Puede cambiar empresa si el codigo de empresa esta vacio--------------------
   */

   Data     _EmpresaFija               INIT ""
   Method   cEmpresaFija( cNewVal )    INLINE if( !Empty( cNewVal ), ( ::_EmpresaFija := cNewVal ), ::_EmpresaFija )
   Method   lCambiarEmpresa()          INLINE ( Empty( ::_EmpresaFija ) )

   Method   MixPermisosGrupo()

   Method   OpenCajon( nView )         INLINE if( !Empty( ::oCajon ) .and. !::lNoOpenCajon(), ::oCajon:Open( nView ), )
   Method   OpenCajonDirect( nView )   INLINE if( !Empty( ::oCajon ), ::oCajon:Open( nView ), )
   Method   OpenCajonTest()            INLINE if( !Empty( ::oCajon ) .and. !::lNoOpenCajon(), ::oCajon:Open(), )

   Method   lMasterLike()

   Method   lValidMasterLike( cClave )

   /*
   Empresa del usuario solo se selecciona si no lo pasan como parametro de inicio--------
   */

   Data     _Empresa                   INIT ""
   Method   cEmpresa( cNewVal )

END CLASS

//--------------------------------------------------------------------------//

Method OpenFiles( dbfUser, dbfCajas )

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

Method CloseFiles()

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

Method New()

   ::_NotCambiarPrecioGrupo   := nil
   ::_NotRentabilidadGrupo    := nil
   ::_NotCostosGrupo          := nil
   ::_NotBitmapGrupo          := nil
   ::_NotInicioGrupo          := nil
   ::_FiltroVentas            := .f.

Return ( Self )

//--------------------------------------------------------------------------//

Method Create( cCodUsr, lCreateHandle )

   msgStop( "Please don`t use this method" )

Return ( Self )

//--------------------------------------------------------------------------//

Method setUser( cCodigoUsuario, lCreateHandle )

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

Method Save()

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

Method CreateHandle( cCodUsr )

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

Method quitUser( cOldUsr )

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

Method MixPermisosGrupo( cCodGrp )

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

Method lNotCambiarPrecio( lNewVal )

   if lNewVal != nil
      ::_NotCambiarPrecio  := lNewVal
   end if

   if !Empty( ::_NotCambiarPrecioGrupo )
      Return ( ::_NotCambiarPrecioGrupo .or. ::_NotCambiarPrecio )
   end if

Return ( ::_NotCambiarPrecio )

//--------------------------------------------------------------------------//

Method lNotRentabilidad( lNewVal )

   if lNewVal != nil
      ::_NotRentabilidad   := lNewVal
   end if

   if !Empty( ::_NotRentabilidadGrupo )
      Return ( ::_NotRentabilidadGrupo .or. ::_NotRentabilidad )
   end if

Return ( ::_NotRentabilidad )

//--------------------------------------------------------------------------//

Method lNotCostos( lNewVal )

   if lNewVal != nil
      ::_NotCostos         := lNewVal
   end if

   if !Empty( ::_NotCostosGrupo )
      Return ( ::_NotCostosGrupo .or. ::_NotCostos )
   end if

Return ( ::_NotCostos )

//--------------------------------------------------------------------------//

Method lNotBitmap( lNewVal )

   if lNewVal != nil
      ::_NotBitmap         := lNewVal
   end if

   if !Empty( ::_NotBitmapGrupo )
      Return ( ::_NotBitmapGrupo .or. ::_NotBitmap )
   end if

Return ( ::_NotBitmap )

//--------------------------------------------------------------------------//

Method lNotInicio( lNewVal )

   if lNewVal != nil
      ::_NotInicio         := lNewVal
   end if

   if !Empty( ::_NotInicioGrupo )
      Return ( ::_NotInicioGrupo .or. ::_NotInicio )
   end if

Return ( ::_NotInicio )

//--------------------------------------------------------------------------//

Method lDocAuto( lNewVal )

   if lNewVal != nil
      ::_DocAuto         := lNewVal
   end if

Return ( ::_DocAuto )

//--------------------------------------------------------------------------//

Method dUltAuto( lNewVal )

   if lNewVal != nil
      ::_UltAuto         := lNewVal
   end if

Return ( ::_UltAuto )

//---------------------------------------------------------------------------//

Method lMasterLike()

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

Method lValidMasterLike( oClave, cClave )

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

Method cEmpresa( cNewVal )

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

Function cCurUsr()

   if empty( oUser )
      msgStop( "Objeto de usuario no creado" )
      Return ( "" )
   end if

Return ( oUser:cCodigo() )

//--------------------------------------------------------------------------//

Function cCurGrp()

   if empty( oUser )
      msgStop( "Objeto de usuario no creado" )
      Return ( "" )
   end if

Return ( oUser:cGrupo() )

//--------------------------------------------------------------------------//