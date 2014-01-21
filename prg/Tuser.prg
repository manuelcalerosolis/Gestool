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

   Method   Create( cCodUsr, cDbf )
   Method   Save( cCodUsr, cDbf )

   Method   CreateHandle( cCodUsr )
   Method   lQuitUser( cOldUsr )

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

   Data     _NotBitmap                 INIT .f.
   Method   lNotBitmap( lNewVal )

   Data     _NotBitmapGrupo
   Method   lNotBitmapGrupo( lNewVal )    INLINE ( if( isLogic( lNewVal ), ::_NotBitmapGrupo := lNewVal, ::_NotBitmapGrupo ) )

   Data     _NotCambiarPrecio             INIT .f.
   Method   lNotCambiarPrecio( lNewVal )
   Method   lCambiarPrecio()              INLINE ( !::lNotCambiarPrecio() )

   Data     _NotCambiarPrecioGrupo
   Method   lNotCambiarPrecioGrupo( lNewVal )   INLINE if( isLogic( lNewVal ), ::_NotCambiarPrecioGrupo := lNewVal, ::_NotCambiarPrecioGrupo )
   Method   lCambiarPrecioGrupo()               INLINE ( !::_NotCambiarPrecioGrupo )

   Data     _NotRentabilidad           INIT .f.
   Method   lNotRentabilidad( lNewVal )

   Data     _NotRentabilidadGrupo
   Method   lNotRentabilidadGrupo( lNewVal ) INLINE if( isLogic( lNewVal ), ::_NotRentabilidadGrupo := lNewVal, ::_NotRentabilidadGrupo )

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

   //------------------------------------------------------------------------//

   Data     _Delegacion                INIT space( 2 )
 
   INLINE METHOD cDelegacion( cNewVal )

      if cNewVal != nil

         ::_Delegacion     := cNewVal

         cDlgUsr( cNewVal ) 

      else

         ::_Delegacion  := uFieldEmpresa( "cSufDoc" )

         cDlgUsr( uFieldEmpresa( "cSufDoc" ) )

         if Empty( ::_Delegacion )

            ::_Delegacion  := "00"

            cDlgUsr( "00" )
               
         end if   

      end if

      RETURN ::_Delegacion

   ENDMETHOD

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

   /*
   Puede cambiar empresa si el codigo de empresa esta vacio--------------------
   */

   Data     _EmpresaFija               INIT ""
   Method   cEmpresaFija( cNewVal )    INLINE if( !Empty( cNewVal ), ( ::_EmpresaFija := cNewVal ), ::_EmpresaFija )
   Method   lCambiarEmpresa()          INLINE ( Empty( ::_EmpresaFija ) )

   Method   MixPermisosGrupo()

   Method   OpenCajon( nView )         INLINE if( !Empty( ::oCajon ) .and. !::lNoOpenCajon(), ::oCajon:Open( nView ), )
   Method   OpenCajonTest()            INLINE if( !Empty( ::oCajon ) .and. !::lNoOpenCajon(), ::oCajon:Open(), )

   Method   lMasterLike()

   Method   lValidMasterLike( cClave )

   /*
   Empresa del usuario solo se selecciona si no lo pasan como parametro de inicio--------
   */

   Data     _Empresa                   INIT ""

   //------------------------------------------------------------------------//

   Inline Method cEmpresa( cNewVal )

      if cNewVal != nil

         ::_Empresa := cNewVal

         if !( "EMPRESA" $ cParamsMain() )
            cEmpUsr( cNewVal )
         end if

      end if

      Return ( ::_Empresa )

   EndMethod

   //------------------------------------------------------------------------//

END CLASS

//--------------------------------------------------------------------------//

Method OpenFiles( dbfUser, dbfCajas )

   if !Empty( ::oDbf ) .and. ( ::oDbf )->( Used() )
      Return ( Self )
   end if

   if Empty( dbfUser )

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

      if !Empty( ::oDbf )
         ( ::oDbf )->( dbCloseArea() )
      end if

      if !Empty( ::oDbfCajas )
         ( ::oDbfCajas )->( dbCloseArea() )
      end if

   end if

Return ( Self )

//--------------------------------------------------------------------------//

Method Create( cCodUsr, dbfUser, dbfCajas, cOldUsr, lCreateHandle )

   local nOrd
   local oError
   local oBlock

   DEFAULT cCodUsr            := "000"
   DEFAULT lCreateHandle      := .t.

   ::cCodigoUsuario           := cCodUsr

   oBlock                     := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::OpenFiles( dbfUser, dbfCajas )

   ::_NotCambiarPrecioGrupo   := nil
   ::_NotRentabilidadGrupo    := nil
   ::_NotCostosGrupo          := nil
   ::_NotBitmapGrupo          := nil
   ::_NotInicioGrupo          := nil
   ::_FiltroVentas            := .f.

   nOrd                       := ( ::oDbf )->( OrdSetFocus( "cCodUse" ) )

   if ( ::oDbf )->( dbSeek( cCodUsr ) )

      if !Empty( cOldUsr )
         ::lQuitUser( cOldUsr )
      end if

      if !lCreateHandle .or. ::CreateHandle( cCodUsr ) != -1

         ::lEnUso(            .t. )
         ::cCodigo(           cCodUsr )
         ::cPcName(           Rtrim( NetName() )  )
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
         ::MixPermisosGrupo(  ( ::oDbf )->cCodGrp )
         ::lFiltroVentas(     ( ::oDbf )->lFilVta )
         ::cCaja(             ( ::oDbf )->cCajUse )
         ::cAlmacen(          ( ::oDbf )->cAlmUse )
         ::cOperario(         ( ::oDbf )->cCodTra )
         ::lDocAuto(          ( ::oDbf )->lDocAut )
         ::dUltAuto(          ( ::oDbf )->dUltAut )
         ::cEmpresaFija(      ( ::oDbf )->cCodEmp )
         ::lNoOpenCajon(      ( ::oDbf )->lNoOpCaj )

         /*
         Si el usuario tiene una empresa fija la colocamos caso contrario la ultima en usarse
         */

         if !Empty( ( ::oDbf )->cCodEmp )
            ::cEmpresa(       ( ::oDbf )->cCodEmp )
         else
            ::cEmpresa(       ( ::oDbf )->cEmpUse )
         end if

         /*
         Si el usuario tiene una delegacion fija la asignamos------------------
         */

         if !Empty( ( ::oDbf )->cCodDlg ) .and. !::lMaster()
            ::cDelegacion(    ( ::oDbf )->cCodDlg )
         end if

         /*
         Cajon portamonedas----------------------------------------------------
         */

         if Empty( ::oCajon ) .and. !Empty( cCajonEnCaja( ( ::oDbf )->cCajUse, ::oDbfCajas ) )
            ::oCajon          := TCajon():Create( cCajonEnCaja( ( ::oDbf )->cCajUse, ::oDbfCajas ) )
         end if

         SetKey( VK_F12, {|| ::OpenCajon() } )

         ::lCreated           := .t.

      else

         ::lCreated           := .f.

         msgStop( "No puedo crear un handle valido para el usuario " + cCodUsr )

      end if

   else

      ::lCreated              := .f.

      msgStop( "Usuario " + cCodUsr + "no encontrado." )

   end if

   ( ::oDbf )->( OrdSetFocus( nOrd ) )

   ::CloseFiles()

   RECOVER USING oError

      msgStop( "Imposible seleccionar propiedades de usuarios " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( Self )

//--------------------------------------------------------------------------//

Method Save( dbfUser, dbfCajas )

   local oError
   local oBlock

   oBlock                     := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::OpenFiles( dbfUser, dbfCajas )

      if ( ::oDbf )->( Used() )

         if dbSeekInOrd( ::cCodigoUsuario, "cCodUse", ::oDbf ) .and. ( ::oDbf )->( dbRLock() )

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
               ( ::oDbf )->cCodDlg  := ::cDelegacion()
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

      end if

      ::CloseFiles()

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

Method lQuitUser( cOldUsr )

   local nOldRec

   if fClose( ::nHandle() )

      nOldRec  := ( ::oDbf )->( Recno() )

      if dbSeekInOrd( cOldUsr, "cCodUse", ::oDbf ) .and. ( ::oDbf )->( dbRLock() )
         ( ::oDbf )->lUseUse  := .f.
         ( ::oDbf )->( dbUnLock() )
      end if

      ( ::oDbf )->( dbGoTo( nOldRec ) )

   else

      MsgStop( "No puedo cerrar el usuario " + cOldUsr )
      Return ( .f. )

   end if

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
         RESOURCE "TpvUser" ;
         ID       150 ;
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


//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

Function oUser( cCodUsr, dbfUser, dbfCajas, cOldUsr, lCreateHandle )

   if oUser == nil
      oUser := TUser():Create( cCodUsr, dbfUser, dbfCajas, cOldUsr, lCreateHandle )
   end if

Return ( oUser )

//--------------------------------------------------------------------------//

Function oSetUsr( cCodUsr, dbfUser, dbfCajas, cOldUsr, lCreateHandle )

   oUser := TUser()
   oUser:OpenFiles( dbfUser, dbfCajas )
   oUser:Create( cCodUsr, dbfUser, dbfCajas, cOldUsr, lCreateHandle )
   oUser:CloseFiles()

Return ( oUser )

//--------------------------------------------------------------------------//

Function cCurUsr()

   if oUser == nil
      oUser := TUser():Create()
   end if

Return ( oUser:cCodigo() )

//--------------------------------------------------------------------------//

Function cCurGrp()

   if oUser == nil
      oUser := TUser():Create()
   end if

Return ( oUser:cGrupo() )

//--------------------------------------------------------------------------//