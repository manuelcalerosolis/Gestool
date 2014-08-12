#include "FiveWin.Ch"
#include "Factu.ch" 
#include "DBStruct.ch"
#include "Ads.ch"
#include "Xbrowse.ch"
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TDataCenter

   CLASSDATA   oInstance

   CLASSDATA   cDataDictionaryFile        INIT cAdsUNC() + "GstApolo.Add"
   CLASSDATA   cDataDictionaryComment     INIT "GstApolo ADS data dictionary"

   CLASSDATA   aDDTables                  INIT {}
   CLASSDATA   aDDTriggers                INIT {}

   CLASSDATA   lAdsConnection
   CLASSDATA   hAdsConnection

   CLASSDATA   aDataTables                INIT {}
   CLASSDATA   aEmpresaTables             INIT {}
   CLASSDATA   aEmpresaObject             INIT {}

   CLASSDATA   hOperationDescription      INIT { "INSERT" => "Añadido", "UPDATE" => "Modificado", "DELETE" => "Eliminado" }

   DATA        aEmpresas                  INIT {}

   DATA        oDlg
   DATA        oBrwEmpresas

   DATA        oDlgAuditor
   DATA        oFldAuditor

   DATA        oBrwOperation
   DATA        oBrwColumn
   DATA        oBrwBlocks

   DATA        oMtrActualiza
   DATA        nMtrActualiza              INIT 0

   DATA        oMtrDiccionario
   DATA        nMtrDiccionario            INIT 0

   DATA        oMsg
   DATA        cMsg                INIT ""

   DATA        oBtnOk
   DATA        oBntCancel

   DATA        lValidDlg                  INIT .t.

   DATA        oPeriodo
   DATA        cPeriodo                   INIT "Mes en curso"
   DATA        aPeriodo                   INIT {}

   DATA        oIniInf
   DATA        dIniInf                    INIT CtoD( "01/01/" + Str( Year( Date() ) ) )

   DATA        oFinInf
   DATA        dFinInf                    INIT Date()

   DATA        lAppend                    INIT .t.
   DATA        lEdit                      INIT .t.
   DATA        lDelete                    INIT .t.

   DATA        lActualizaBaseDatos        INIT .f.
   DATA        lTriggerAuxiliares         INIT .f.

   DATA        aLgcIndices                INIT { .t., .t., .t. }
   DATA        aChkIndices                INIT Array( 3 )

   DATA        aProgress                  INIT Array( 3 )
   DATA        nProgress                  INIT { 0, 0, 0 }

   DATA        cMsg                       INIT ""
   DATA        oMsg

   METHOD CreateDataDictionary()
   METHOD ConnectDataDictionary()

   METHOD CreateDataUser( oDataUser )

   METHOD CreateDataTable()
   METHOD CreateEmpresaTable()

   METHOD ReLoadTables()                  INLINE ( ::aDDTables := AdsDirectory() )

   METHOD CreateDataTrigger()
   METHOD CreateEmpresaTrigger()

   METHOD ExistTable( oTable )
   METHOD ExistTrigger( oTable )

   METHOD CreateTriggerUpdate( oTable )
   METHOD CreateColumnTriggerUpdate( oTable, cTrigger )

   METHOD CreateTriggerInsert( oTable )
   METHOD CreateColumnTriggerInsert( oTable, cTrigger )

   METHOD CreateTriggerDelete( oTable )
   METHOD CreateColumnTriggerDelete( oTable, cTrigger )

   METHOD AddTable( oTable )
   METHOD AddTrigger( oTable, cAction )

   METHOD DeleteTable( oTable )           
   METHOD DeleteAllTable()

   METHOD BuildData()
   METHOD BuildEmpresa()

   METHOD CheckData()
   METHOD CheckEmpresa()

   METHOD BuildTrigger()

   METHOD AddDataTable( oTable )          INLINE aAdd( ::aDataTables, oTable )
   METHOD AddEmpresaTable( oTable )       INLINE aAdd( ::aEmpresaTables, oTable )
   
   METHOD AddEmpresaObject( oObject )     INLINE aAdd( ::aEmpresaObject, oObject )

   METHOD CreateOperationLogTable()
   METHOD CreateColumnLogTable()

   METHOD CreateTemporalTable( oTable )

   METHOD CloseArea( cArea )              INLINE ( if( Select( cArea ) > 0, ( cArea )->( dbCloseArea() ), ), dbSelectArea( 0 ), .t. )

   METHOD CreateAllLocksTablesUsers()
   METHOD DeleteAllLocksTablesUsers()
   METHOD GetAllLocksTablesUsers()
   METHOD CloseAllLocksTablesUsers()      INLINE ( ::CloseArea( "AllLocks" ) )

   METHOD lAdministratorTask() 
   METHOD StartAdministratorTask()

   METHOD Auditor()
   METHOD StartAuditor()                  VIRTUAL

   METHOD lSelectOperationLog()
   METHOD CloseOperationLog()             INLINE ( ::CloseArea( "SqlOperation" ) )
   METHOD InlineSelectOperationLog()      INLINE ( CursorWait(), ::lSelectOperationLog(), ::oBrwOperation:Refresh(), ::oBrwOperation:GoTop(), CursorWE() )

   METHOD lSelectColumnLog( id )
   METHOD CloseColumnLog()                INLINE ( ::CloseArea( "SqlColumn" ) )
   METHOD InlineSelectColumnLog( id )     INLINE ( CursorWait(), msgStop( id ), ::lSelectColumnLog( id ), ::oBrwColumn:Refresh(), ::oBrwColumn:GoTop(), CursorWait() )

   METHOD lCreaArrayPeriodos()
   METHOD lRecargaFecha()

   METHOD cEmpresaDescription( cTableName )
   METHOD cTableDescription( cTableName )
   METHOD cOperationDescription( cOperation )

   METHOD DisableTriggers()
   METHOD EnableTriggers()
   METHOD SetAplicationID( cNombreUsuario )

   METHOD ExecuteSqlStatement( cSql, cSqlStatement )

   METHOD Resource( nId )
   METHOD StartResource()

   METHOD Reindex()
   METHOD ReindexTable( oTable )

   METHOD Syncronize()

   METHOD ActualizaDataTable( oTable )       INLINE  ( ::ActualizaTable( oTable, cPatDat() ) )
   METHOD ActualizaEmpresaTable( oTable )    INLINE  ( ::ActualizaTable( oTable, cPatEmp() ) )
   METHOD ActualizaTable( oTable, cPath )
   METHOD ActualizaEmpresa()

   //---------------------------------------------------------------------------//

   METHOD ScanDataTable()
   METHOD ScanObject()

   METHOD DataName( cDatabase )              INLINE   ( if( lAIS(), upper( cPatDat() + cDatabase ), upper( cDatabase ) ) )
   METHOD EmpresaName( cDatabase )           INLINE   ( if( lAIS(), upper( cPatEmp() + cDatabase ), upper( cDatabase ) ) )

   //---------------------------------------------------------------------------//

   METHOD oFacCliT()
   
   METHOD OpenFacCliT( dbf )

	METHOD oFacCliP()
	METHOD OpenFacCliP( dbf )

	METHOD oAlbCliT()
	METHOD OpenAlbCliT( dbf )

   	METHOD oPedCliT()
   	METHOD OpenPedCliT( dbf )

	METHOD oSatCliT()
	METHOD OpenSatCliT( dbf )

   	METHOD oPreCliT()
	METHOD OpenPreCliT( dbf )

	METHOD oCnfFlt()
	
	METHOD oProCab()
   	METHOD oProLin()

   	METHOD oCliBnc()

END CLASS

//---------------------------------------------------------------------------//

METHOD CheckData() CLASS TDataCenter

   if lAIS()
      aeval( ::aDataTables, {|oTable| ::AddTable( oTable, .t. ) } )
   end if 

RETURN ( Self )  

//---------------------------------------------------------------------------//

METHOD CheckEmpresa() CLASS TDataCenter

   if lAIS()
      aeval( ::aEmpresaTables, {|oTable| ::AddTable( oTable, .t. ) } )
   end if

RETURN ( Self )  

//---------------------------------------------------------------------------//


METHOD oFacCliP() CLASS TDataCenter

      local cFilter
      local oFacCliP

      DATABASE NEW oFacCliP PATH ( cPatEmp() ) FILE "FacCliP.Dbf" VIA ( cDriver() ) SHARED INDEX "FacCliP.Cdx"

         if lAIS() .and. !oUser():lAdministrador()
      
            cFilter     := "Field->cSufFac == '" + oUser():cDelegacion() + "' .and. Field->cCodCaj == '" + oUser():cCaja() + "'"
            if oUser():lFiltroVentas()         
               cFilter  += " .and. Field->cCodUsr == '" + oUser():cCodigo() + "'"
            end if 

            ( oFacCliP:cAlias )->( AdsSetAOF( cFilter ) )

         end if

      Return ( oFacCliP )   

//---------------------------------------------------------------------------//

METHOD OpenFacCliP( dbf ) CLASS TDataCenter

      local lOpen
      local cFilter

      USE ( cPatEmp() + "FacCliP.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIP", @dbf ) )
      SET ADSINDEX TO ( cPatEmp() + "FacCliP.Cdx" ) ADDITIVE

      lOpen             := !neterr()
      if lOpen

         /*
         Limitaciones de cajero y cajas----------------------------------------
         */

         if lAIS() .and. !oUser():lAdministrador()
      
            cFilter     := "Field->cSufFac == '" + oUser():cDelegacion() + "' .and. Field->cCodCaj == '" + oUser():cCaja() + "'"
            if oUser():lFiltroVentas()         
               cFilter  += " .and. Field->cCodUsr == '" + oUser():cCodigo() + "'"
            end if 

            ( dbf )->( AdsSetAOF( cFilter ) )

         end if

      end if 

      Return ( lOpen )   

//---------------------------------------------------------------------------//

METHOD oAlbCliT() CLASS TDataCenter

      local cFilter
      local oAlbCliT

      DATABASE NEW oAlbCliT PATH ( cPatEmp() ) FILE "AlbCliT.Dbf" VIA ( cDriver() ) SHARED INDEX "AlbCliT.Cdx"

         if lAIS() .and. !oUser():lAdministrador()
      
            cFilter     := "Field->cSufAlb == '" + oUser():cDelegacion() + "' .and. Field->cCodCaj == '" + oUser():cCaja() + "'"
            if oUser():lFiltroVentas()         
               cFilter  += " .and. Field->cCodUsr == '" + oUser():cCodigo() + "'"
            end if 

            ( oAlbCliT:cAlias )->( AdsSetAOF( cFilter ) )

         end if

      Return ( oAlbCliT )   

   //---------------------------------------------------------------------------//

METHOD OpenAlbCliT( dbf ) CLASS TDataCenter

      local lOpen
      local cFilter

      USE ( cPatEmp() + "AlbCliT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbCliT", @dbf ) )
      SET ADSINDEX TO ( cPatEmp() + "AlbCliT.Cdx" ) ADDITIVE

      lOpen             := !neterr()
      if lOpen

         /*
         Limitaciones de cajero y cajas----------------------------------------
         */

         if lAIS() .and. !oUser():lAdministrador()
      
            cFilter     := "Field->cSufAlb == '" + oUser():cDelegacion() + "' .and. Field->cCodCaj == '" + oUser():cCaja() + "'"
            if oUser():lFiltroVentas()         
               cFilter  += " .and. Field->cCodUsr == '" + oUser():cCodigo() + "'"
            end if 

            ( dbf )->( AdsSetAOF( cFilter ) )

         end if

      end if 

      Return ( lOpen )   

   //---------------------------------------------------------------------------//

METHOD oPedCliT() CLASS TDataCenter

      local cFilter
      local oPedCliT

      DATABASE NEW oPedCliT PATH ( cPatEmp() ) FILE "PedCliT.Dbf" VIA ( cDriver() ) SHARED INDEX "PedCliT.Cdx"

         if lAIS() .and. !oUser():lAdministrador()
      
            cFilter     := "Field->cSufPed == '" + oUser():cDelegacion() + "' .and. Field->cCodCaj == '" + oUser():cCaja() + "'"
            if oUser():lFiltroVentas()         
               cFilter  += " .and. Field->cCodUsr == '" + oUser():cCodigo() + "'"
            end if 

            ( oPedCliT:cAlias )->( AdsSetAOF( cFilter ) )

         end if

      Return ( oPedCliT )   

//---------------------------------------------------------------------------//

METHOD OpenPedCliT( dbf ) CLASS TDataCenter

	local lOpen
	local cFilter

	USE ( cPatEmp() + "PedCliT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedCliT", @dbf ) )
	SET ADSINDEX TO ( cPatEmp() + "PedCliT.Cdx" ) ADDITIVE

	lOpen             := !neterr()
	if lOpen

		/*
		Limitaciones de cajero y cajas----------------------------------------
		*/

		if lAIS() .and. !oUser():lAdministrador()

			cFilter   	:= "Field->cSufPed == '" + oUser():cDelegacion() + "' .and. Field->cCodCaj == '" + oUser():cCaja() + "'"
			if oUser():lFiltroVentas()         
		   		cFilter += " .and. Field->cCodUsr == '" + oUser():cCodigo() + "'"
			end if 

			( dbf )->( AdsSetAOF( cFilter ) )

		end if

	end if 

Return ( lOpen )   

//---------------------------------------------------------------------------//

METHOD oSatCliT() CLASS TDataCenter

	local cFilter
	local oSatCliT

	DATABASE NEW oSatCliT PATH ( cPatEmp() ) FILE "SatCliT.Dbf" VIA ( cDriver() ) SHARED INDEX "SatCliT.Cdx"

	if lAIS() .and. !oUser():lAdministrador()

		cFilter     := "Field->cSufSat == '" + oUser():cDelegacion() + "' .and. Field->cCodCaj == '" + oUser():cCaja() + "'"
		if oUser():lFiltroVentas()         
		   cFilter  += " .and. Field->cCodUsr == '" + oUser():cCodigo() + "'"
		end if 

		( oSatCliT:cAlias )->( AdsSetAOF( cFilter ) )

	end if

Return ( oSatCliT )   

//---------------------------------------------------------------------------//

METHOD OpenSatCliT( dbf ) CLASS TDataCenter

      local lOpen
      local cFilter

      USE ( cPatEmp() + "SatCliT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "SatCliT", @dbf ) )
      SET ADSINDEX TO ( cPatEmp() + "SatCliT.Cdx" ) ADDITIVE

      lOpen             := !neterr()
      if lOpen

         /*
         Limitaciones de cajero y cajas----------------------------------------
         */

         if lAIS() .and. !oUser():lAdministrador()
      
            cFilter     := "Field->cSufSat == '" + oUser():cDelegacion() + "' .and. Field->cCodCaj == '" + oUser():cCaja() + "'"
            if oUser():lFiltroVentas()         
               cFilter  += " .and. Field->cCodUsr == '" + oUser():cCodigo() + "'"
            end if 

            ( dbf )->( AdsSetAOF( cFilter ) )

         end if

      end if 

      Return ( lOpen )   

//---------------------------------------------------------------------------//

METHOD oPreCliT() CLASS TDataCenter

	local cFilter
	local oPreCliT

	DATABASE NEW oPreCliT PATH ( cPatEmp() ) FILE "PreCliT.Dbf" VIA ( cDriver() ) SHARED INDEX "PreCliT.Cdx"

	if lAIS() .and. !oUser():lAdministrador()

		cFilter     := "Field->cSufPre == '" + oUser():cDelegacion() + "' .and. Field->cCodCaj == '" + oUser():cCaja() + "'"
		if oUser():lFiltroVentas()         
		   cFilter  += " .and. Field->cCodUsr == '" + oUser():cCodigo() + "'"
		end if 

		( oPreCliT:cAlias )->( AdsSetAOF( cFilter ) )

	end if

Return ( oPreCliT )   

//---------------------------------------------------------------------------//

METHOD OpenPreCliT( dbf ) CLASS TDataCenter

	local lOpen
	local cFilter

	USE ( cPatEmp() + "PreCliT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PreCliT", @dbf ) )
	SET ADSINDEX TO ( cPatEmp() + "PreCliT.Cdx" ) ADDITIVE

	lOpen             := !neterr()
	if lOpen

		/*
		Limitaciones de cajero y cajas----------------------------------------
		*/

		if lAIS() .and. !oUser():lAdministrador()

		cFilter     := "Field->cSufPre == '" + oUser():cDelegacion() + "' .and. Field->cCodCaj == '" + oUser():cCaja() + "'"
		if oUser():lFiltroVentas()         
		   cFilter  += " .and. Field->cCodUsr == '" + oUser():cCodigo() + "'"
		end if 

		( dbf )->( AdsSetAOF( cFilter ) )

		end if

	end if 

Return ( lOpen )   

//---------------------------------------------------------------------------//

METHOD oCnfFlt() CLASS TDataCenter

	local oCnfFlt

	DATABASE NEW oCnfFlt PATH ( cPatDat() ) FILE "CnfFlt.Dbf" VIA ( cDriver() ) SHARED INDEX "CnfFlt.Cdx"

Return ( oCnfFlt )   

//---------------------------------------------------------------------------//

METHOD oProCab() CLASS TDataCenter

	local cFilter
	local oProCab

	DATABASE NEW oProCab PATH ( cPatEmp() ) FILE "ProCab.Dbf" VIA ( cDriver() ) SHARED INDEX "ProCab.Cdx"

	 if lAIS() .and. !oUser():lAdministrador()

	    cFilter     := "Field->cSufOrd == '" + oUser():cDelegacion() 

	    ( oProCab:cAlias )->( AdsSetAOF( cFilter ) )

	 end if

Return ( oProCab )   

//---------------------------------------------------------------------------//

METHOD oProLin() CLASS TDataCenter

    local cFilter
    local oProLin

    DATABASE NEW oProLin PATH ( cPatEmp() ) FILE "ProLin.Dbf" VIA ( cDriver() ) SHARED INDEX "ProLin.Cdx"

    if lAIS() .and. !oUser():lAdministrador()
  
        cFilter     := "Field->cSufOrd == '" + oUser():cDelegacion() 

        ( oProLin:cAlias )->( AdsSetAOF( cFilter ) )

    end if

Return ( oProLin )   

//---------------------------------------------------------------------------//

METHOD oCliBnc() CLASS TDataCenter

 	local oCliBnc

 	DATABASE NEW oCliBnc PATH ( cPatCli() ) FILE "CliBnc.Dbf" VIA ( cDriver() ) SHARED INDEX "CliBnc.Cdx"

Return ( oCliBnc )   

//---------------------------------------------------------------------------//

METHOD oFacCliT() CLASS TDataCenter

   local cFilter
   local oFacCliT

   DATABASE NEW oFacCliT PATH ( cPatEmp() ) FILE "FacCliT.Dbf" VIA ( cDriver() ) SHARED INDEX "FacCliT.Cdx"

      if lAIS() .and. !oUser():lAdministrador()
      
         cFilter     := "Field->cSufFac == '" + oUser():cDelegacion() + "' .and. Field->cCodCaj == '" + oUser():cCaja() + "'"
         if oUser():lFiltroVentas()         
            cFilter  += " .and. Field->cCodUsr == '" + oUser():cCodigo() + "'"
         end if 

         ( oFacCliT:cAlias )->( AdsSetAOF( cFilter ) )

      end if

Return ( oFacCliT )   

//---------------------------------------------------------------------------//

METHOD OpenFacCliT( dbf )

   local lOpen
   local cFilter

   USE ( cPatEmp() + "FacCliT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FacCliT", @dbf ) )
   SET ADSINDEX TO ( cPatEmp() + "FacCliT.Cdx" ) ADDITIVE

   lOpen             := !neterr()
   if lOpen

      // Limitaciones de cajero y cajas----------------------------------------

      if lAIS() .and. !oUser():lAdministrador()
      
         cFilter     := "Field->cSufFac == '" + oUser():cDelegacion() + "' .and. Field->cCodCaj == '" + oUser():cCaja() + "'"
         if oUser():lFiltroVentas()         
               cFilter  += " .and. Field->cCodUsr == '" + oUser():cCodigo() + "'"
            end if 

            ( dbf )->( AdsSetAOF( cFilter ) )

         end if

      end if 

Return ( lOpen )   

//---------------------------------------------------------------------------//
   
METHOD CreateTemporalTable( oTable )

   local oError
   local oBlock

   oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if !Empty( oTable:bCreateFile )
         Eval( oTable:bCreateFile, cEmpTmp() )
      end if 

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Error creando tabla temporal.' )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lAdministratorTask()

   local dbfEmp

   SetIndexToCdx()

   ::aEmpresas       := {}

   /*
   Cargamos el array de las empresas----------------------------------------
   */

   USE ( cAdsUNC() + "Datos\Empresa.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "EMPRESA", @dbfEmp ) )
   SET ADSINDEX TO ( cAdsUNC() + "Datos\Empresa.Cdx" ) ADDITIVE

   while !( dbfEmp )->( eof() )
      if !( dbfEmp )->lGrupo
         aAdd( ::aEmpresas, { ( dbfEmp )->CodEmp, ( dbfEmp )->cNombre, ( dbfEmp )->lGrupo, .f., .f., .t. } )
      end if 
      ( dbfEmp )->( dbSkip() )
   end while

   ( dbfEmp )->( dbCloseArea() )

   /*
   Si tenemos empresas q procesar----------------------------------------------
   */

   if !Empty( ::aEmpresas )

      DEFINE DIALOG ::oDlg RESOURCE "AdsAdmin" TITLE "Creación de diccionario de datos para " + ::cDataDictionaryFile

      ::oBrwEmpresas                         := TXBrowse():New( ::oDlg )

      ::oBrwEmpresas:lRecordSelector         := .t.
      ::oBrwEmpresas:lTransparent            := .f.
      ::oBrwEmpresas:nDataLines              := 1

      ::oBrwEmpresas:nMarqueeStyle           := MARQSTYLE_HIGHLROW

      ::oBrwEmpresas:bClrSel                 := {|| { CLR_WHITE, RGB( 53, 142, 182 ) } }
      ::oBrwEmpresas:bClrSelFocus            := {|| { CLR_WHITE, RGB( 53, 142, 182 ) } }

      ::oBrwEmpresas:CreateFromResource( 100 )

      ::oBrwEmpresas:SetArray( ::aEmpresas, , , .f. )

      ::oBrwEmpresas:bLDblClick              := {|| ::aEmpresas[ ::oBrwEmpresas:nArrayAt, 6 ] := !::aEmpresas[ ::oBrwEmpresas:nArrayAt, 6 ], ::oBrwEmpresas:Refresh() }

      with object ( ::oBrwEmpresas:AddCol() )
         :cHeader          := "Sl. Seleccionada"
         :bStrData         := {|| "" }
         :nWidth           := 20
         :bEditValue       := {|| ::aEmpresas[ ::oBrwEmpresas:nArrayAt, 6 ] }
         :bLClickHeader    := {|| aeval( ::aEmpresas, {|a| a[6] := !a[6] } ), ::oBrwEmpresas:Refresh() }
         :SetCheck( { "Bullet_Square_Green_16", "Bullet_Square_Red_16" } )
      end with 

      with object ( ::oBrwEmpresas:AddCol() )
         :cHeader          := "Ac. Actualizada"
         :bStrData         := {|| "" }
         :nWidth           := 20
         :bEditValue       := {|| ::aEmpresas[ ::oBrwEmpresas:nArrayAt, 4 ] }
         :SetCheck( { "Bullet_Square_Green_16", "Bullet_Square_Red_16" } )
      end with 

      with object ( ::oBrwEmpresas:AddCol() )
         :cHeader          := "Pr. Procesada"
         :bStrData         := {|| "" }
         :nWidth           := 20
         :bEditValue       := {|| ::aEmpresas[ ::oBrwEmpresas:nArrayAt, 5 ] }
         :SetCheck( { "Bullet_Square_Green_16", "Bullet_Square_Red_16" } )
      end with

      with object ( ::oBrwEmpresas:AddCol() )
         :cHeader          := "Código" 
         :nWidth           := 40
         :bEditValue       := {|| if( ::aEmpresas[ ::oBrwEmpresas:nArrayAt, 3 ], "<" + Rtrim( ::aEmpresas[ ::oBrwEmpresas:nArrayAt, 1 ] ) + ">", ::aEmpresas[ ::oBrwEmpresas:nArrayAt, 1 ] ) }
      end with
 
      with object ( ::oBrwEmpresas:AddCol() )
         :cHeader          := "Empresa"
         :nWidth           := 340
         :bEditValue       := {|| if( ::aEmpresas[ ::oBrwEmpresas:nArrayAt, 3 ], "<" + Rtrim( ::aEmpresas[ ::oBrwEmpresas:nArrayAt, 2 ] ) + ">", ::aEmpresas[ ::oBrwEmpresas:nArrayAt, 2 ] ) }
      end with

      REDEFINE SAY         ::oMsg ;
         PROMPT            ::cMsg ;
         ID                400 ;
         OF                ::oDlg

      ::oMtrActualiza      := TMeter():ReDefine( 500, { | u | if( pCount() == 0, ::nMtrActualiza, ::nMtrActualiza := u ) }, 10, ::oDlg, .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )

      ::oMtrDiccionario    := TMeter():ReDefine( 510, { | u | if( pCount() == 0, ::nMtrDiccionario, ::nMtrDiccionario := u ) }, 10, ::oDlg, .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )

      REDEFINE CHECKBOX    ::lActualizaBaseDatos ;
         ID                600 ;
         OF                ::oDlg

      REDEFINE CHECKBOX    ::lTriggerAuxiliares ;
         ID                610 ;
         OF                ::oDlg

      REDEFINE BUTTON ::oBtnOk ;
         ID                IDOK ;
         OF                ::oDlg ;
         ACTION            ( ::StartAdministratorTask() )

      REDEFINE BUTTON ::oBntCancel ;
         ID                IDCANCEL ;
         OF                ::oDlg ;
         ACTION            ( ::oDlg:end() )

      ::oDlg:AddFastKey( VK_F5, {|| ::StartAdministratorTask() } )

      ::oDlg:Activate( , , , .t., {|| ::lValidDlg } )

   else

      MsgStop( "No hay empresas que procesar" )

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD StartAdministratorTask()

   local cEmp

   ::lValidDlg       := .f.

   ::oBtnOk:Disable()
   ::oBntCancel:Disable()

   ::oMtrActualiza:SetTotal( len( ::aEmpresas ) )
   ::oMtrDiccionario:SetTotal( 5 )

   /*
   Recorremos el array de las empresas par actualizarlas--------------------
   */

   if ::lActualizaBaseDatos

      ::oBrwEmpresas:GoTop()

      for each cEmp in ::aEmpresas

         if cEmp[ 6 ]

            ::oMsg:SetText( "Actualizando empresa " + Rtrim( cEmp[ 1 ] ) + " - " + Rtrim( cEmp[ 2 ] ) )

            ::oMtrActualiza:Set( hb_EnumIndex() )

            SetEmpresa( cEmp[ 1 ], , , , , , .t. )

            lActualiza( cEmp[ 1 ], , .t., cEmp[ 2 ], .f. )

            cEmp[ 4 ]      := .t.

         end if 

         ::oBrwEmpresas:GoDown()
         ::oBrwEmpresas:Refresh()

      next

   end if 

   ::oMtrDiccionario:Set( 1 )

   /*
   Conectamos de nuevo con ADS------------------------------------------------
   */

   lCdx( .f. )
   lAIS( .t. )

   if ::ConnectDataDictionary()

      /*
      Eliminamos todas las tablas del diccionario de datos------------------
      */

      ::oMsg:SetText( "Eliminando tablas anteriores de diccionario de datos" )

      ::DeleteAllTable()

      /*
      Construimos la base de datos de estructura----------------------------
      */

      ::oMsg:SetText( "Creando arbol de tablas datos generales aplicación" )

      ::BuildData()

      ::CreateDataTable()

      /*
      Recorremos el array de las empresas par actualizarlas--------------------
      */

      ::oBrwEmpresas:GoTop()

      for each cEmp in ::aEmpresas

         if cEmp[ 6 ]

            ::oMsg:SetText( "Creando diccionario de empresa " + Rtrim( cEmp[ 1 ] ) + " - " + Rtrim( cEmp[ 2 ] ) )

            ::oMtrActualiza:Set( hb_EnumIndex() )

            SetEmpresa( cEmp[ 1 ], , , , , , .t. )

            ::BuildEmpresa()  
               
            ::CreateEmpresaTable()

            ::Reindex()

            cEmp[ 5 ]   := .t.

         end if

         ::oBrwEmpresas:GoDown()
         ::oBrwEmpresas:Refresh()

      next

      ::oMtrDiccionario:Set( 2 )

      /*
      Creamos las tablas de operacioens----------------------------------------
      */

      ::oMsg:SetText( "Creando tablas de operaciones" )

      ::CreateOperationLogTable()

      ::CreateColumnLogTable()

      ::CreateAllLocksTablesUsers()

      ::oMtrDiccionario:Set( 3 )

      /*
      Creamos los triggers de los datos----------------------------------------
      */

      ::oMsg:SetText( "Creando triggers de datos" )

      ::CreateDataTrigger()

      ::oMtrDiccionario:Set( 4 )

      /*
      Creamos los triggers de las empresas-------------------------------------
      */

      ::oMsg:SetText( "Creando triggers de empresa" )

      ::CreateEmpresaTrigger()

      ::oMtrDiccionario:Set( 5 )

   end if

   /*
   Saliendo--------------------------------------------------------------------
   */

   ::lValidDlg       := .t.

   MsgInfo( "Proceso finalizado con exito" )

   ::oDlg:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CreateDataDictionary()

   if !File( ::cDataDictionaryFile )

      AdsDDCreate( ::cDataDictionaryFile, , ::cDataDictionaryComment )

      AdsDDSetDatabaseProperty( ADS_DD_ENABLE_INTERNET, .t. )

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ConnectDataDictionary()

   local cError

   ::CreateDataDictionary()

   ::lAdsConnection     := AdsConnect60( ::cDataDictionaryFile, nAdsServer(), "ADSSYS", "", , @::hAdsConnection )
   
   if !::lAdsConnection

      adsGetLastError( @cError )

      msgInfo( cError, "Error connect data dictionary " + ::cDataDictionaryFile )

   end if

RETURN ( ::lAdsConnection )

//---------------------------------------------------------------------------//

METHOD CreateDataUser( oDataUser )

   if !Empty( oDataUser:cName ) .and. !Empty( oDataUser:cPassword )
      AdsDDCreateUser( , oDataUser:cName, oDataUser:cPassword, oDataUser:cComment )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CreateDataTable()

   local oTable

   for each oTable in ::aDataTables
      ::AddTable( oTable )
   next

   ::ReLoadTables()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ScanDataTable( cDataTable ) 

   local nScan

   nScan    := aScan( TDataCenter():aDataTables, {|o| o:cFileName() == ::DataName( cDataTable ) } )   
   if nScan != 0
      Return ( TDataCenter():aDataTables[ nScan ] )
   end if 

   if nScan == 0
      nScan    := aScan( TDataCenter():aEmpresaTables, {|o| o:cFileName() == ::EmpresaName( cDataTable ) } )   
      if nScan != 0
         Return ( TDataCenter():aEmpresaTables[ nScan ] )
      end if 
   end if
 
Return ( nil )

//---------------------------------------------------------------------------//

METHOD ScanObject( cName ) CLASS TDataCenter

   local nScan

   nScan    := aScan( ::aEmpresaObject, {|o| o:cName == cName } )   
   if nScan != 0
      Return ( ::aEmpresaObject[ nScan ] )
   end if 

Return ( nil )

//---------------------------------------------------------------------------//

METHOD CreateDataTrigger()

   local oTable

   ::oMtrActualiza:SetTotal( len( ::aDataTables ) )

   for each oTable in ::aDataTables

      ::oMtrActualiza:Set( hb_EnumIndex() )

      if oTable:lTrigger
         ::AddTrigger( oTable )
      end if

   next

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CreateEmpresaTable()

   local oTable

   for each oTable in ::aEmpresaTables
      ::AddTable( oTable )
   next

   ::ReLoadTables()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CreateEmpresaTrigger()

   local oTable

   ::oMtrActualiza:SetTotal( len( ::aEmpresaTables ) )

   for each oTable in ::aEmpresaTables

      ::oMtrActualiza:Set( hb_EnumIndex() )

      if oTable:lTrigger
         ::AddTrigger( oTable )
      end if

   next

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ExistTable( uTable )

   local cTable
   local lExistTable := .f.

   do case
      case IsObject( uTable )
         cTable      := Upper( uTable:cName )
      case IsChar( uTable )
         cTable      := Upper( uTable )
   end case

   if Empty( ::aDDTables )
      ::aDDTables    := AdsDirectory()
   end if

   lExistTable       := aScan( ::aDDTables, {|c| Left( Upper( c ), len( c ) - 1 ) == cTable } ) != 0

Return ( lExistTable )

//---------------------------------------------------------------------------//

METHOD DeleteTable( oTable )

   local nScan

   /*
   if !ExistTable( oTable )
      Return .f.
   endif
   */

   nScan             := aScan( ::aDDTables, oTable:cName )
   if nScan != 0
      aDel( ::aDDTables, nScan, .t. )
   end if

Return ( AdsDDRemoveTable( Upper( oTable:cName ) ) )

//---------------------------------------------------------------------------//

METHOD DeleteAllTable()

   if Empty( ::aDDTables )
      ::aDDTables    := AdsDirectory()
   end if

   aEval( ::aDDTables, {|c| AdsDDRemoveTable( Left( Upper( c ), len( c ) - 1 ) ) } )

   ::ReLoadTables()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD ExistTrigger( oTable )

   local cTrigger

   if !isObject( oTable )
      Return ( .f. )
   end if

   if Empty( ::aDDTriggers )
      ::aDDTriggers  := ADSSelectSQLScript( "SELECT name FROM system.triggers" )
   end if

Return ( aScan( ::aDDTriggers, {|c| Upper( Alltrim( oTable:cName ) ) $ Upper( Alltrim( c ) ) } ) != 0 )

//---------------------------------------------------------------------------//

METHOD CreateTriggerUpdate( oTable )

   local nError
   local cTrigger
   local lTrigger
   local cErrorAds

   if !isObject( oTable )
      Return ( .f. )
   end if

   cTrigger          := ''
   cTrigger          += 'CREATE TRIGGER "Update' + ( Alltrim( oTable:cName ) ) + '" ON "' + ( Alltrim( oTable:cName ) ) + '" AFTER UPDATE' + CRLF

   cTrigger          += 'BEGIN' + CRLF

   cTrigger          += 'DECLARE @id Integer;' + CRLF
   cTrigger          += 'DECLARE @co CURSOR AS SELECT * FROM __OLD;' + CRLF
   cTrigger          += 'DECLARE @cn CURSOR AS SELECT * FROM __NEW;' + CRLF
   cTrigger          += 'DECLARE @userName NCHAR(50);' + CRLF
   cTrigger          += 'DECLARE @appName NCHAR(50);' + CRLF

   cTrigger          += '@userName = USER();' + CRLF
   cTrigger          += '@appName = APPLICATIONID();' + CRLF

   cTrigger          += 'OPEN @co;' + CRLF
   cTrigger          += 'OPEN @cn;' + CRLF

   cTrigger          += 'TRY' + CRLF

   cTrigger          += 'FETCH @co;' + CRLF
   cTrigger          += 'FETCH @cn;' + CRLF

   cTrigger          += 'INSERT INTO SqlOperationLog ( DATETIME, USERNAME, APPNAME, TABLENAME, OPERATION )' + CRLF
   cTrigger          += 'VALUES ( Now(), @userName, @appName, ' + "'" + ( Alltrim( oTable:cName ) ) + "'" + ", 'UPDATE'" + ' );' + CRLF

   cTrigger          += '@id = LASTAUTOINC(STATEMENT);' + CRLF

   ::CreateColumnTriggerUpdate( oTable, @cTrigger )

   cTrigger          += 'FINALLY' + CRLF

   cTrigger          += 'CLOSE @co;' + CRLF
   cTrigger          += 'CLOSE @cn;' + CRLF

   cTrigger          += 'END TRY;' + CRLF

   cTrigger          += 'END NO MEMOS PRIORITY 1;' + CRLF

   ::ExecuteSqlStatement( cTrigger, Alltrim( oTable:cName ) )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD CreateColumnTriggerUpdate( oTable, cTrigger )

   local n
   local oError
   local oBlock

   oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   dbUseArea( .t., cDriver(), oTable:cName, "Table" )

   for n := 1 to Table->( fCount() )

      if Table->( FieldType( n ) ) != "M" // nField < 150 .and.

         cTrigger += 'IF ( @co."' + Table->( FieldName( n ) ) + '" <> @cn."' + Table->( FieldName( n ) ) + '" )' + CRLF
         cTrigger +=     'THEN' + CRLF
         cTrigger += 'INSERT INTO SqlColumnLog ( OPERATIONID, COLUMNNAME, USERNAME, APPNAME, TABLENAME, OLDVALUE, NEWVALUE )' + CRLF
         cTrigger += 'VALUES ( @id, ' + "'" + Table->( FieldName( n ) ) + "'" + ", @userName, @appName, " + "'" + Alltrim( oTable:cName ) + "'" + ", cast( @co." + '"' + Table->( FieldName( n ) ) + '"' + " as sql_varchar ), " + "cast( @cn." + '"' + Table->( FieldName( n ) ) + '"' + " as sql_varchar ) );" + CRLF
         cTrigger += 'END IF;' + CRLF
         cTrigger += CRLF

      end if

   next

   Table->( dbCloseArea() )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible crear las columnas del trigger' )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD CreateTriggerInsert( oTable, cAction )

   local cTrigger

   if !isObject( oTable )
      Return ( .f. )
   end if

   cTrigger          := ''
   cTrigger          += 'CREATE TRIGGER "Insert' + ( Alltrim( oTable:cName ) ) + '" ON "' + ( Alltrim( oTable:cName ) ) + '" AFTER INSERT' + CRLF

   cTrigger          += 'BEGIN' + CRLF

   cTrigger          += 'DECLARE @id Integer;' + CRLF
   cTrigger          += 'DECLARE @cn CURSOR AS SELECT * FROM __NEW;' + CRLF
   cTrigger          += 'DECLARE @userName NCHAR(50);' + CRLF
   cTrigger          += 'DECLARE @appName NCHAR(50);' + CRLF

   cTrigger          += '@userName = USER();' + CRLF
   cTrigger          += '@appName = APPLICATIONID();' + CRLF

   cTrigger          += 'OPEN @cn;' + CRLF

   cTrigger          += 'TRY' + CRLF

   cTrigger          += 'FETCH @cn;' + CRLF

   cTrigger          += 'INSERT INTO SqlOperationLog ( DATETIME, USERNAME, APPNAME, TABLENAME, OPERATION )' + CRLF
   cTrigger          += 'VALUES ( Now(), @userName, @appName, ' + "'" + ( Alltrim( oTable:cName ) ) + "'" + ", 'INSERT'" + ' );' + CRLF

   cTrigger          += '@id = LASTAUTOINC(STATEMENT);' + CRLF

   ::CreateColumnTriggerInsert( oTable, @cTrigger )

   cTrigger          += 'FINALLY' + CRLF

   cTrigger          += 'CLOSE @cn;' + CRLF

   cTrigger          += 'END TRY;' + CRLF

   cTrigger          += 'END NO MEMOS PRIORITY 1;' + CRLF

Return ( ::ExecuteSqlStatement( cTrigger, Alltrim( oTable:cName ) ) )

//---------------------------------------------------------------------------//

METHOD CreateColumnTriggerInsert( oTable, cTrigger )

   local n
   local oError
   local oBlock

   oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   dbUseArea( .t., cDriver(), oTable:cName, "Table" )

   for n := 1 to Table->( fCount() )

      if Table->( FieldType( n ) ) != "M"

         cTrigger += 'INSERT INTO SqlColumnLog ( OPERATIONID, COLUMNNAME, USERNAME, APPNAME, TABLENAME, OLDVALUE, NEWVALUE )' + CRLF
         cTrigger += 'VALUES ( @id, ' + "'" + Table->( FieldName( n ) ) + "'" + ", @userName, @appName, " + "'" + Alltrim( oTable:cName ) + "'" + ", '', " + "cast( @cn." + '"' + Table->( FieldName( n ) ) + '"' + " as sql_varchar ) );" + CRLF
         cTrigger += CRLF

      end if

   next

   Table->( dbCloseArea() )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible crear las columnas del trigger insert' )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD CreateTriggerDelete( oTable, cAction )

   local cTrigger

   if !isObject( oTable )
      Return ( .f. )
   end if

   cTrigger          := ''
   cTrigger          += 'CREATE TRIGGER "Delete' + ( Alltrim( oTable:cName ) ) + '" ON "' + ( Alltrim( oTable:cName ) ) + '" AFTER DELETE' + CRLF

   cTrigger          += 'BEGIN' + CRLF

   cTrigger          += 'DECLARE @id Integer;' + CRLF
   cTrigger          += 'DECLARE @co CURSOR AS SELECT * FROM __OLD;' + CRLF
   cTrigger          += 'DECLARE @userName NCHAR(50);' + CRLF
   cTrigger          += 'DECLARE @appName NCHAR(50);' + CRLF

   cTrigger          += '@userName = USER();' + CRLF
   cTrigger          += '@appName = APPLICATIONID();' + CRLF

   cTrigger          += 'OPEN @co;' + CRLF

   cTrigger          += 'TRY' + CRLF

   cTrigger          += 'FETCH @co;' + CRLF

   cTrigger          += 'INSERT INTO SqlOperationLog ( DATETIME, USERNAME, APPNAME, TABLENAME, OPERATION )' + CRLF
   cTrigger          += 'VALUES ( Now(), @userName, @appName, ' + "'" + ( Alltrim( oTable:cName ) ) + "'" + ", 'DELETE'" + ' );' + CRLF

   cTrigger          += '@id = LASTAUTOINC(STATEMENT);' + CRLF

   ::CreateColumnTriggerDelete( oTable, @cTrigger )

   cTrigger          += 'FINALLY' + CRLF

   cTrigger          += 'CLOSE @co;' + CRLF

   cTrigger          += 'END TRY;' + CRLF

   cTrigger          += 'END NO MEMOS PRIORITY 1;' + CRLF


Return ( ::ExecuteSqlStatement( cTrigger, Alltrim( oTable:cName ) ) )

//---------------------------------------------------------------------------//

METHOD CreateColumnTriggerDelete( oTable, cTrigger )

   local n
   local oError
   local oBlock

   oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   dbUseArea( .t., cDriver(), oTable:cName, "Table" )

   for n := 1 to Table->( fCount() )

      if Table->( FieldType( n ) ) != "M"

         cTrigger += 'INSERT INTO SqlColumnLog ( OPERATIONID, COLUMNNAME, USERNAME, APPNAME, TABLENAME, OLDVALUE, NEWVALUE )' + CRLF
         cTrigger += 'VALUES ( @id, ' + "'" + Table->( FieldName( n ) ) + "'" + ", @userName, @appName, " + "'" + Alltrim( oTable:cName ) + "'" + ", '', " + "cast( @co." + '"' + Table->( FieldName( n ) ) + '"' + " as sql_varchar ) );" + CRLF
         cTrigger += CRLF

      end if

   next

   Table->( dbCloseArea() )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible crear las columnas del trigger delete' )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD CreateAllLocksTablesUsers()

   local cSql  

   ::DeleteAllLocksTablesUsers()

   cSql        := "CREATE PROCEDURE mgGetAllLocksAllTablesAllUsers ( "     + CRLF 
   cSql        +=    "TableName CICHAR ( 255 ) OUTPUT, "                   + CRLF 
   cSql        +=    "RecNumber INTEGER OUTPUT, "                          + CRLF
   cSql        +=    "UserName CICHAR ( 50 ) OUTPUT, "                     + CRLF 
   cSql        +=    "IPAddress CICHAR ( 30 ) OUTPUT, "                    + CRLF 
   cSql        +=    "DictionaryUser CICHAR ( 50 ) OUTPUT ) "              + CRLF 
   cSql        +=    "BEGIN "                                              + CRLF
   cSql        +=       "DECLARE cTbls CURSOR AS EXECUTE PROCEDURE sp_mgGetAllTables(); " + CRLF 
   cSql        +=       "DECLARE cLocks CURSOR; "                          + CRLF
   cSql        +=       "DECLARE cUser CURSOR;  "                          + CRLF
   cSql        +=       " "                                                + CRLF 
   cSql        += "OPEN cTbls; "                                           + CRLF 
   cSql        +=       " "                                                + CRLF 
   cSql        += "WHILE FETCH cTbls DO "                                  + CRLF
   cSql        +=    "OPEN cLocks AS EXECUTE PROCEDURE sp_mgGetAllLocks(cTbls.TableName); " + CRLF
   cSql        +=    "WHILE FETCH cLocks DO "                              + CRLF 
   cSql        +=       "OPEN cUser as EXECUTE PROCEDURE sp_mgGetLockOwner(cTbls.TableName, cLocks.LockedRecNo); " + CRLF 
   cSql        +=       "WHILE FETCH cUser DO "                            + CRLF 
   cSql        +=          "INSERT INTO __output VALUES (cTbls.TableName, cLocks.LockedRecNo, cUser.UserName, cUser.Address, cUser.DictionaryUser); " + CRLF
   cSql        +=       "END WHILE; "                                      + CRLF 
   cSql        +=       "CLOSE cUser; "                                    + CRLF 
   cSql        +=    "END WHILE; "                                         + CRLF 
   cSql        +=    "CLOSE cLocks; "                                      + CRLF 
   cSql        += "END WHILE; "                                            + CRLF 
   cSql        += "CLOSE cTbls; "                                          + CRLF 
   cSql        += "END; "                                                  + CRLF
  
Return ( ::ExecuteSqlStatement( cSql, "Locks" ) )

//---------------------------------------------------------------------------//

METHOD DeleteAllLocksTablesUsers()

Return ( ::ExecuteSqlStatement( "DROP PROCEDURE mgGetAllLocksAllTablesAllUsers;", "Locks" ) )

//---------------------------------------------------------------------------//

METHOD GetAllLocksTablesUsers()

   local cStm

   ::CloseAllLocksTablesUsers()

   /*
   Creamos la instruccion------------------------------------------------------
   */

   cStm           := "EXECUTE PROCEDURE mgGetAllLocksAllTablesAllUsers();"

RETURN ( ::ExecuteSqlStatement( cStm, "AllLocks" ) )

//---------------------------------------------------------------------------//

METHOD AddTable( oTable, lSilent )

   local cError
   local lAddTable      := .t.

   DEFAULT lSilent      := .f.

   if !::ExistTable( oTable )

      if file( oTable:cDataFile ) .and. file( oTable:cIndexFile )

         if !AdsDDaddTable( oTable:cName, oTable:cDataFile, oTable:cIndexFile )

            lAddTable   := .f.

            msgStop(    "Name  : " + Alltrim( oTable:cName )      + CRLF + ;
                        "Table : " + Alltrim( oTable:cDataFile )  + CRLF + ;
                        "Index : " + Alltrim( oTable:cIndexFile ) + CRLF + ;
                        "Descripción de error " + cValToChar( adsGetLastError( @cError ) ),;
                        "Error adding table" )

         end if

      else

         if !file( oTable:cDataFile )
            if !lSilent
               msgStop( "No existe " + ( oTable:cDataFile ), "Atención", 1 )
            end if 
         end if

         if !file( oTable:cIndexFile )
            if !lSilent
               msgStop( "No existe " + ( oTable:cIndexFile ), "Atención", 1 )
            end if
         end if

      end if

   else 
      
      if !lSilent
         msgStop( "La tabla " + ( oTable:cDataFile ) + "ya existe en el diccionario de datos." )
      end if

   end if

Return ( lAddTable )

//---------------------------------------------------------------------------//

METHOD AddTrigger( oTable, cAction )

   ::CreateTriggerInsert( oTable )
   ::CreateTriggerUpdate( oTable )
   ::CreateTriggerDelete( oTable )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD BuildData()

   local oDataTable

   ::aDataTables           := {}

   oDataTable              := TDataTable()
   oDataTable:cArea        := "Users"
   oDataTable:cName        := cPatDat() + "Users"
   oDataTable:cDataFile    := cPatDat( .t. ) + "Users.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "Users.Cdx"
   oDataTable:cDescription := "Usuarios"
   oDataTable:aStruct      := aItmUsuario()
   oDataTable:bCreateFile  := {| cPath | mkUsuario( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxUsuario( cPath ) }
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "Mapas"
   oDataTable:cDataFile    := cPatDat( .t. ) + "Mapas.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "Mapas.Cdx"
   oDataTable:cDescription := "Mapas de usuarios"
   oDataTable:aStruct      := aItmMapaUsuario()  
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "Cajas"
   oDataTable:cName        := cPatDat() + "Cajas"
   oDataTable:cDataFile    := cPatDat( .t. ) + "Cajas.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "Cajas.Cdx"
   oDataTable:cDescription := "Cajas"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:aStruct      := aItmCaja()
   oDataTable:bCreateFile  := {| cPath | mkCajas( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxCajas( cPath ) }
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "CajasL"
   oDataTable:cDataFile    := cPatDat( .t. ) + "CajasL.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "CajasL.Cdx"
   oDataTable:cDescription := "Lineas de cajas"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:aStruct      := aItmCajaL()  
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "ImpTik"
   oDataTable:cDataFile    := cPatDat( .t. ) + "ImpTik.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "ImpTik.Cdx"
   oDataTable:cDescription := "Impresoras de comanda"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:bCreateFile  := {| cPath | mkImpTik( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxImpTik( cPath ) }
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "Visor"
   oDataTable:cDataFile    := cPatDat( .t. ) + "Visor.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "Visor.Cdx"
   oDataTable:cDescription := "Visores"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:bCreateFile  := {| cPath | mkVisor( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxVisor( cPath ) }
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "CajPorta"
   oDataTable:cDataFile    := cPatDat( .t. ) + "CajPorta.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "CajPorta.Cdx"
   oDataTable:cDescription := "Cajón portamonedas"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:bCreateFile  := {| cPath | mkCajPorta( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxCajPorta( cPath ) }
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "TipImp"
   oDataTable:cDataFile    := cPatDat( .t. ) + "TipImp.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "TipImp.Cdx"
   oDataTable:cDescription := "Tipos de impresoras"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:bCreateFile  := {| cPath | mkTipImp( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxTipImp( cPath ) }
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "Agenda"
   oDataTable:cDataFile    := cPatDat( .t. ) + "Agenda.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "Agenda.Cdx"
   oDataTable:cDescription := "Agenda"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:bCreateFile  := {| cPath | TAgenda():BuildFiles( .t., cPath ) }
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "AgendaUsr"
   oDataTable:cDataFile    := cPatDat( .t. ) + "AgendaUsr.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "AgendaUsr.Cdx"
   oDataTable:cDescription := "Agenda"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:bCreateFile  := {| cPath | TNotas():BuildFiles( .t., cPath ) }
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "TipoNotas"
   oDataTable:cDataFile    := cPatDat( .t. ) + "TipoNotas.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "TipoNotas.Cdx"
   oDataTable:cDescription := "Tipos de notas"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:bCreateFile  := {| cPath | mkTipoNotas( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxTipoNotas( cPath ) }
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "TVta"
   oDataTable:cDataFile    := cPatDat( .t. ) + "TVta.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "TVta.Cdx"
   oDataTable:cDescription := "Tipos de ventas"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:bCreateFile  := {| cPath | mkTVta( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxTVta( cPath ) }
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "Divisas"
   oDataTable:cPath        := cPatDat()
   oDataTable:cName        := cPatDat() + "Divisas"
   oDataTable:cDataFile    := cPatDat( .t. ) + "Divisas.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "Divisas.Cdx"
   oDataTable:cDescription := "Divisas"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:bCreateFile  := {| cPath | mkDiv( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxDiv( cPath ) }
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "TIva"
   oDataTable:cName        := cPatDat() + "TIva"
   oDataTable:cDataFile    := cPatDat( .t. ) + "TIva.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "TIva.Cdx"
   oDataTable:cDescription := "Tipos de impuestos"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:bCreateFile  := {| cPath | mkTIva( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxTIva( cPath ) }
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "Empresa"
   oDataTable:cName        := cPatDat() + "Empresa"
   oDataTable:cDataFile    := cPatDat( .t. ) + "Empresa.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "Empresa.Cdx"
   oDataTable:cDescription := "Empresa"
   oDataTable:lTrigger     := .f.
   oDataTable:bCreateFile  := {| cPath | mkEmpresa( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxEmpresa( cPath ) }
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "Delega"
   oDataTable:cName        := cPatDat() + "Delega"
   oDataTable:cDataFile    := cPatDat( .t. ) + "Delega.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "Delega.Cdx"
   oDataTable:cDescription := "Delegaciones"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "UsrBtnBar"
   oDataTable:cDataFile    := cPatDat( .t. ) + "UsrBtnBar.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "UsrBtnBar.Cdx"
   oDataTable:cDescription := "Barra favoritos"
   oDataTable:bCreateFile  := {| cPath | TAcceso():MakeDatabase( cPath ) }
   oDataTable:bCreateIndex := {| cPath | TAcceso():ReindexDatabase( cPath ) }
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "TblCnv"
   oDataTable:cDataFile    := cPatDat( .t. ) + "TblCnv.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "TblCnv.Cdx"
   oDataTable:cDescription := "Factor conversión"
   oDataTable:bCreateFile  := {| cPath | mkTblCnv( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxTblCnv( cPath ) }
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "Captura"
   oDataTable:cDataFile    := cPatDat( .t. ) + "Captura.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "Captura.Cdx"
   oDataTable:cDescription := "Capturas T.P.V."
   oDataTable:bCreateFile  := {| cPath | TCaptura():BuildFiles( .t., cPath ) }
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "CapturaCampos"
   oDataTable:cDataFile    := cPatDat( .t. ) + "CapturaCampos.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "CapturaCampos.Cdx"
   oDataTable:cDescription := "Capturas T.P.V."
   oDataTable:bCreateFile  := {| cPath | TDetCaptura():BuildFiles( .t., cPath ) }
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "TMov"
   oDataTable:cDataFile    := cPatDat( .t. ) + "TMov.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "TMov.Cdx"
   oDataTable:cDescription := "Tipos de movimientos"
   oDataTable:bCreateFile  := {| cPath | mkTMov( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxTMov( cPath ) }
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "CnfFlt"
   oDataTable:cDataFile    := cPatDat( .t. ) + "CnfFlt.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "CnfFlt.Cdx"
   oDataTable:cDescription := "Configuración filtros"
   oDataTable:bCreateFile  := {| cPath | TFilterDatabase():BuildFiles( .t., cPath ) }
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "Situa"
   oDataTable:cDataFile    := cPatDat( .t. ) + "Situa.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "Situa.Cdx"
   oDataTable:cDescription := "Situaciones"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:bCreateFile  := {| cPath | TSituaciones():BuildFiles( .t., cPath ) }
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "Pais"
   oDataTable:cDataFile    := cPatDat( .t. ) + "Pais.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "Pais.Cdx"
   oDataTable:cDescription := "Paises"
   oDataTable:bCreateFile  := {| cPath | TPais():BuildFiles( .t., cPath ) }
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "Backup"
   oDataTable:cDataFile    := cPatDat( .t. ) + "Backup.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "Backup.Cdx"
   oDataTable:bCreateFile  := {| cPath | TBackup():BuildFiles( .t., cPath ) }
   oDataTable:cDescription := "Copias de seguridad"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddDataTable( oDataTable )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD BuildEmpresa()

   local oDataTable

   ::aEmpresaTables        := {}

   oDataTable              := TDataTable()
   oDataTable:cArea        := "NCount"
   oDataTable:cName        := cPatEmp() + "NCount"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "NCount.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "NCount.Cdx"
   oDataTable:cDescription := "Contadores"
   oDataTable:aStruct      := aItmCount()
   oDataTable:bCreateFile  := {| cPath | mkCount( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxCount( cPath ) }
   oDataTable:bSyncFile    := {| cPath | synCount( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "EntSal"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "EntSal.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "EntSal.Cdx"
   oDataTable:cDescription := "Entradas y salidas"
   oDataTable:bCreateFile  := {| cPath | mkEntSal( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxEntSal( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "LogPorta"
   oDataTable:cName        := cPatEmp() + "LogPorta"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "LogPorta.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "LogPorta.Cdx"
   oDataTable:cDescription := "Entradas y salidas"
   oDataTable:bCreateFile  := {| cPath | mkLogPorta( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxLogPorta( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "Almacen"
   oDataTable:cName        := cPatEmp() + "Almacen"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Almacen.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Almacen.Cdx"
   oDataTable:cDescription := "Almacenes"
   oDataTable:bCreateFile  := {| cPath | mkAlmacen( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxAlmacen( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "AlmacenL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AlmacenL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AlmacenL.Cdx"
   oDataTable:cDescription := "Almacenes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "FPago"
   oDataTable:cName        := cPatEmp() + "FPago"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FPago.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FPago.Cdx"
   oDataTable:cDescription := "Formas de pago"
   oDataTable:bCreateFile  := {| cPath | mkFPago( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxFPago( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "Invita"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Invita.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Invita.Cdx"
   oDataTable:cDescription := "Invitaciones"
   oDataTable:bCreateFile  := {| cPath | TInvitacion():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "Catalogo"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Catalogo.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Catalogo.Cdx"
   oDataTable:cDescription := "Catálogos"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "UndMed"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "UndMed.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "UndMed.Cdx"
   oDataTable:bSyncFile    := {|| UniMedicion():Create():Syncronize() }
   oDataTable:cDescription := "Unidades de medición"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "Bancos"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Bancos.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Bancos.Cdx"
   oDataTable:cDescription := "Bancos"
   oDataTable:bCreateFile  := {| cPath | TBancos():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "EmpBnc"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "EmpBnc.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "EmpBnc.Cdx"
   oDataTable:cDescription := "Cuentas bancos"
   oDataTable:bCreateFile  := {| cPath | TCuentasBancarias():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "Turno"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Turno.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Turno.Cdx"
   oDataTable:cDescription := "Sesiones"
   oDataTable:bCreateFile  := {| cPath | TTurno():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "TurnoC"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TurnoC.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TurnoC.Cdx"
   oDataTable:cDescription := "Sesiones cajas"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "TurnoL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TurnoL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TurnoL.Cdx"
   oDataTable:cDescription := "Lineas cajas"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "NewImp"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "NewImp.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "NewImp.Cdx"
   oDataTable:cDescription := "Impuestos"
   oDataTable:bCreateFile  := {| cPath | TNewImp():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "HisMov"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "HisMov.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "HisMov.Cdx"
   oDataTable:cDescription := "Movimientos de almacén"
   oDataTable:bCreateFile  := {| cPath | mkHisMov( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxHisMov( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "UbiCat"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "UbiCat.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "UbiCat.Cdx"
   oDataTable:cDescription := "Ubicaciones"
   oDataTable:bCreateFile  := {| cPath | mkUbi( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxUbi( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "UbiCal"
   oDataTable:cName        := cPatEmp() + "UbiCal"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "UbiCal.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "UbiCal.Cdx"
   oDataTable:cDescription := "Ubicaciones calles"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "GrpVent"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "GrpVent.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "GrpVent.Cdx"
   oDataTable:cDescription := "Grupos de ventas"
   oDataTable:bCreateFile  := {| cPath | mkGrpVenta( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxGrpVenta( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "RemMovT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "RemMovT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "RemMovT.Cdx"
   oDataTable:cDescription := "Remesas de movimientos"
   oDataTable:bCreateFile  := {| cPath | TRemMovAlm():BuildFiles( .t., cPath ) }
   oDataTable:bSyncFile    := {|| SynRemMov( cPatEmp() ) }
   ::AddEmpresaTable( oDataTable )

   /*
   Articulos-------------------------------------------------------------------
   */

   oDataTable              := TDataTable()
   oDataTable:cArea        := "Articulo"
   oDataTable:cName        := cPatEmp() + "Articulo"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Articulo.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Articulo.Cdx"
   oDataTable:bSyncFile    := {|| SynArt( cPatEmp() ) }
   oDataTable:cDescription := "Artículos"
   oDataTable:bCreateFile  := {| cPath | mkArticulo( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxArticulo( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "ProvArt"
   oDataTable:cName        := cPatEmp() + "ProvArt"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ProvArt.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ProvArt.Cdx"
   oDataTable:cDescription := "Artículos proveedor"
   oDataTable:lTrigger     := ::lTriggerAuxiliares   
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "ArtDiv"
   oDataTable:cName        := cPatEmp() + "ArtDiv"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ArtDiv.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ArtDiv.Cdx"
   oDataTable:cDescription := "Artículos precios por porpiedades"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "Artkit"
   oDataTable:cName        := cPatEmp() + "ArtKit"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ArtKit.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ArtKit.Cdx"
   oDataTable:cDescription := "Artículos escandallos"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "ArtCodebar"
   oDataTable:cName        := cPatEmp() + "ArtCodebar"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ArtCodebar.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ArtCodebar.Cdx"
   oDataTable:cDescription := "Artículos codigos de barra"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "ArtLbl"
   oDataTable:cName        := cPatEmp() + "ArtLbl"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ArtLbl.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ArtLbl.Cdx"
   oDataTable:cDescription := "Artículos etiquetas"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "ArtImg"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ArtImg.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ArtImg.Cdx"
   oDataTable:cDescription := "Artículos imagenes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "Familias"
   oDataTable:cName        := cPatEmp() + "Familias"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Familias.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Familias.Cdx"
   oDataTable:bCreateFile  := {| cPath | mkFamilia( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxFamilia( cPath ) }
   oDataTable:cDescription := "Familias"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "FamPrv"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FamPrv.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FamPrv.Cdx"
   oDataTable:cDescription := "Familias proveedor"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "Temporadas"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Temporadas.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Temporadas.Cdx"
   oDataTable:cDescription := "Temporadas"
   oDataTable:bCreateFile  := {| cPath | mkTemporada( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxTemporada( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "Categorias"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Categorias.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Categorias.Cdx"
   oDataTable:cDescription := "Categorías"
   oDataTable:bCreateFile  := {| cPath | mkCategoria( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxCategoria( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "TipArt"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TipArt.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TipArt.Cdx"
   oDataTable:cDescription := "Tipos de artículos"
   oDataTable:bCreateFile  := {| cPath | TTipArt():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "Proyecto"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Proyecto.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Proyecto.Cdx"
   oDataTable:cDescription := "Proyectos"
   oDataTable:bCreateFile  := {| cPath | TProyecto():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "Fabricantes"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Fabricantes.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Fabricantes.Cdx"
   oDataTable:cDescription := "Fabricantes"
   oDataTable:bCreateFile  := {| cPath | TFabricantes():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "TarPreT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TarPreT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TarPreT.Cdx"
   oDataTable:cDescription := "Tarifas personalizadas"
   oDataTable:bCreateFile  := {| cPath | mkTarifa( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxTarifa( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "TarPreL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TarPreL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TarPreL.Cdx"
   oDataTable:cDescription := "Tarifas personalizadas"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "TarPreS"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TarPreS.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TarPreS.Cdx"
   oDataTable:cDescription := "Tarifas personalizadas"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "Oferta"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Oferta.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Oferta.Cdx"
   oDataTable:cDescription := "Ofertas"
   oDataTable:bCreateFile  := {| cPath | mkOferta( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxOferta( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "Pro"
   oDataTable:cName        := cPatEmp() + "Pro"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Pro.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Pro.Cdx"
   oDataTable:cDescription := "Propiedades"
   oDataTable:bCreateFile  := {| cPath | mkPro( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxPro( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "TblPro"
   oDataTable:cName        := cPatEmp() + "TblPro"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TblPro.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TblPro.Cdx"
   oDataTable:cDescription := "Propiedades"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "Tankes"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Tankes.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Tankes.Cdx"
   oDataTable:cDescription := "Tanques de combustible"
   oDataTable:bCreateFile  := {| cPath | TTankes():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "GrpFam"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "GrpFam.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "GrpFam.Cdx"
   oDataTable:cDescription := "Grupo de familias"
   oDataTable:bCreateFile  := {| cPath | TGrpFam():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "FraPub"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FraPub.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FraPub.Cdx"
   oDataTable:cDescription := "Frases publicitarias"
   oDataTable:bCreateFile  := {| cPath | TFrasesPublicitarias():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "TComandas"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TComandas.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TComandas.Cdx"
   oDataTable:cDescription := "Comandas"
   oDataTable:bCreateFile  := {| cPath | TComandas():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "OrdenComanda"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "OrdenComanda.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "OrdenComanda.Cdx"
   oDataTable:cDescription := "OrdenComanda"
   oDataTable:bCreateFile  := {| cPath | TOrdenComanda():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "ComentariosT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ComentariosT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ComentariosT.Cdx"
   oDataTable:cDescription := "Comentarios"
   oDataTable:bCreateFile  := {| cPath | TComentarios():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "ComentariosL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ComentariosL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ComentariosL.Cdx"
   oDataTable:cDescription := "Comentarios lineas"
   oDataTable:bCreateFile  := {| cPath | TDetComentarios():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "PromoT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PromoT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PromoT.Cdx"
   oDataTable:cDescription := "Promociones"
   oDataTable:bCreateFile  := {| cPath | mkPromo( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxPromo( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "PromoL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PromoL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PromoL.Cdx"
   oDataTable:cDescription := "Promociones lineas"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "PromoC"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PromoC.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PromoC.Cdx"
   oDataTable:cDescription := "Promociones"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "Fideliza"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Fideliza.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Fideliza.Cdx"
   oDataTable:cDescription := "Fidelización"
   oDataTable:bCreateFile  := {| cPath | TFideliza():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "DetFideliza"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "DetFideliza.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "DetFideliza.Cdx"
   oDataTable:cDescription := "Fidelización lineas"
   oDataTable:bCreateFile  := {| cPath | TDetFideliza():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   /*
   Clientes--------------------------------------------------------------------
   */

   oDataTable              := TDataTable()
   oDataTable:cArea        := "Client"
   oDataTable:cName        := cPatCli() + "Client"
   oDataTable:cDataFile    := cPatCli( , .t. ) + "Client.Dbf"
   oDataTable:cIndexFile   := cPatCli( , .t. ) + "Client.Cdx"
   oDataTable:bCreateFile  := {| cPath | mkClient( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxClient( cPath ) }
   oDataTable:bSyncFile    := {|| SynClient( cPatEmp() ) }
   oDataTable:cDescription := "Clientes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "ClientD"
   oDataTable:cName        := cPatCli() + "ClientD"
   oDataTable:cDataFile    := cPatCli( , .t. ) + "ClientD.Dbf"
   oDataTable:cIndexFile   := cPatCli( , .t. ) + "ClientD.Cdx"
   oDataTable:cDescription := "Clientes documentos"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "CliAtp"   
   oDataTable:cName        := cPatCli() + "CliAtp"
   oDataTable:cDataFile    := cPatCli( , .t. ) + "CliAtp.Dbf"
   oDataTable:cIndexFile   := cPatCli( , .t. ) + "CliAtp.Cdx"
   oDataTable:cDescription := "Atípicas de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "ObrasT"
   oDataTable:cName        := cPatCli() + "ObrasT"
   oDataTable:cDataFile    := cPatCli( , .t. ) + "ObrasT.Dbf"
   oDataTable:cIndexFile   := cPatCli( , .t. ) + "ObrasT.Cdx"
   oDataTable:cDescription := "Clientes direcciones"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatCli() + "CliContactos"
   oDataTable:cDataFile    := cPatCli( , .t. ) + "CliContactos.Dbf"
   oDataTable:cIndexFile   := cPatCli( , .t. ) + "CliContactos.Cdx"
   oDataTable:cDescription := "Clientes contactos"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatCli() + "CliBnc"
   oDataTable:cDataFile    := cPatCli( , .t. ) + "CliBnc.Dbf"
   oDataTable:cIndexFile   := cPatCli( , .t. ) + "CliBnc.Cdx"
   oDataTable:cDescription := "Clientes bancos"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "CliInc"
   oDataTable:cName        := cPatCli() + "CliInc"
   oDataTable:cDataFile    := cPatCli( , .t. ) + "CliInc.Dbf"
   oDataTable:cIndexFile   := cPatCli( , .t. ) + "CliInc.Cdx"
   oDataTable:cDescription := "Clientes incidencias"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "GrpCli"
   oDataTable:cName        := cPatCli() + "GrpCli"
   oDataTable:cDataFile    := cPatCli( , .t. ) + "GrpCli.Dbf"
   oDataTable:cIndexFile   := cPatCli( , .t. ) + "GrpCli.Cdx"
   oDataTable:cDescription := "Grupos de clientes"
   oDataTable:bCreateFile  := {| cPath | TGrpCli():BuildFiles( .t., cPath ) }
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatCli() + "Transpor"
   oDataTable:cDataFile    := cPatCli( , .t. ) + "Transpor.Dbf"
   oDataTable:cIndexFile   := cPatCli( , .t. ) + "Transpor.Cdx"
   oDataTable:cDescription := "Transportistas"
   oDataTable:bCreateFile  := {| cPath | TTrans():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "Ruta"
   oDataTable:cName        := cPatCli() + "Ruta"
   oDataTable:cDataFile    := cPatCli( , .t. ) + "Ruta.Dbf"
   oDataTable:cIndexFile   := cPatCli( , .t. ) + "Ruta.Cdx"
   oDataTable:cDescription := "Rutas"
   oDataTable:bCreateFile  := {| cPath | mkRuta( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxRuta( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatCli() + "CtaRem"
   oDataTable:cDataFile    := cPatCli( , .t. ) + "CtaRem.Dbf"
   oDataTable:cIndexFile   := cPatCli( , .t. ) + "CtaRem.Cdx"
   oDataTable:cDescription := "Cuentas de remesas"
   oDataTable:bCreateFile  := {| cPath | TCtaRem():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   /*
   Agentes---------------------------------------------------------------------
   */

   oDataTable              := TDataTable()
   oDataTable:cArea        := "Agentes"
   oDataTable:cName        := cPatEmp() + "Agentes"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Agentes.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Agentes.Cdx"
   oDataTable:cDescription := "Agentes"
   oDataTable:bCreateFile  := {| cPath | mkAgentes( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxAgentes( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "AgeCom"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AgeCom.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AgeCom.Cdx"
   oDataTable:cDescription := "Agentes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "AgeRel"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AgeRel.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AgeRel.Cdx"
   oDataTable:cDescription := "Agentes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )


   /*
   Proveedores-----------------------------------------------------------------
   */

   oDataTable              := TDataTable()
   oDataTable:cArea        := "GrpPrv"
   oDataTable:cName        := cPatPrv() + "GrpPrv"
   oDataTable:cDataFile    := cPatPrv( , .t. ) + "GrpPrv.Dbf"
   oDataTable:cIndexFile   := cPatPrv( , .t. ) + "GrpPrv.Cdx"
   oDataTable:bSyncFile    := {|| SynProvee( cPatEmp() ) }
   oDataTable:cDescription := "Grupos de proveedores"
   oDataTable:bCreateFile  := {| cPath | TGrpPrv():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "Provee"
   oDataTable:cName        := cPatPrv() + "Provee"
   oDataTable:cDataFile    := cPatPrv( , .t. ) + "Provee.Dbf"
   oDataTable:cIndexFile   := cPatPrv( , .t. ) + "Provee.Cdx"
   oDataTable:cDescription := "Proveedores"
   oDataTable:bCreateFile  := {| cPath | mkProvee( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxProvee( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatPrv() + "ProveeD"
   oDataTable:cDataFile    := cPatPrv( , .t. ) + "ProveeD.Dbf"
   oDataTable:cIndexFile   := cPatPrv( , .t. ) + "ProveeD.Cdx"
   oDataTable:cDescription := "Proveedores"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "PrvBnc"
   oDataTable:cName        := cPatPrv() + "PrvBnc"
   oDataTable:cDataFile    := cPatPrv( , .t. ) + "PrvBnc.Dbf"
   oDataTable:cIndexFile   := cPatPrv( , .t. ) + "PrvBnc.Cdx"
   oDataTable:cDescription := "Bancos de proveedores"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   /*
   Varios de empresa-----------------------------------------------------------
   */

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "RemAgeT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "RemAgeT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "RemAgeT.Cdx"
   oDataTable:cDescription := "Remesas de agentes"
   oDataTable:bCreateFile  := {| cPath | TCobAge():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "TipInci"
   oDataTable:cName        := cPatEmp() + "TipInci"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TipInci.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TipInci.Cdx"
   oDataTable:cDescription := "Tipos de incidencias"
   oDataTable:bCreateFile  := {| cPath | mkInci( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxInci( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "CfgCol"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "CfgCol.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "CfgCol.Cdx"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:cDescription := "Configuración"
   oDataTable:bCreateFile  := {| cPath | TShell():CreateData( cPath ) }
   oDataTable:bCreateIndex := {| cPath | TShell():ReindexData( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "CfgUse"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "CfgUse.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "CfgUse.Cdx"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:cDescription := "Configuración"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "CfgInf"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "CfgInf.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "CfgInf.Cdx"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:cDescription := "Configuración"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "CfgFnt"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "CfgFnt.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "CfgFnt.Cdx"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:cDescription := "Configuración"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "CfgGrp"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "CfgGrp.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "CfgGrp.Cdx"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:cDescription := "Configuración"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "DepAgeT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "DepAgeT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "DepAgeT.Cdx"
   oDataTable:bSyncFile    := {|| SynRctPrv( cPatEmp() ) }
   oDataTable:cDescription := "Depósitos de agentes"
   oDataTable:bCreateFile  := {| cPath | mkDepAge( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxDepAge( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "DepAgeL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "DepAgeL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "DepAgeL.Cdx"
   oDataTable:cDescription := "Depósitos de agentes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "MovSer"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "MovSer.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "MovSer.Cdx"
   oDataTable:cDescription := "Movimientos"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "RDocumen"
   oDataTable:cName        := cPatEmp() + "RDocumen"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "RDocumen.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "RDocumen.Cdx"
   oDataTable:cDescription := "Documentos"
   oDataTable:bCreateFile  := {| cPath | mkDocs( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxDocs( cPath ) }
    ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "RItems"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "RItems.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "RItems.Cdx"
   oDataTable:cDescription := "Documentos"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "RColum"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "RColum.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "RColum.Cdx"
   oDataTable:cDescription := "Documentos"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "RBitmap"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "RBitmap.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "RBitmap.Cdx"
   oDataTable:cDescription := "Documentos"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "RBox"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "RBox.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "RBox.Cdx"
   oDataTable:cDescription := "Documentos"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "FstInf"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FstInf.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FstInf.Cdx"
   oDataTable:cDescription := "Documentos"
   oDataTable:bCreateFile  := {| cPath | TFastReportInfGen():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   /*
   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "PrsInf"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PrsInf.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PrsInf.Cdx"
   oDataTable:cDescription := "Documentos"
   ::AddEmpresaTable( oDataTable )
   */
   
   /*
   Pedido Proveedores----------------------------------------------------------
   */

   oDataTable              := TDataTable()
   oDataTable:cArea        := "PedProvT"
   oDataTable:cName        := cPatEmp() + "PedProvT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PedProvT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PedProvT.Cdx"
   oDataTable:bSyncFile    := {|| SynPedPrv( cPatEmp() ) }
   oDataTable:cDescription := "Pedidos de proveedor"
   oDataTable:bCreateFile  := {| cPath | mkPedPrv( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxPedPrv( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "PedProvL"
   oDataTable:cName        := cPatEmp() + "PedProvL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PedProvL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PedProvL.Cdx"
   oDataTable:cDescription := "Pedidos de proveedor"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "PedPrvI"
   oDataTable:cName        := cPatEmp() + "PedPrvI"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PedPrvI.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PedPrvI.Cdx"
   oDataTable:cDescription := "Pedidos de proveedor"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "PedPrvD"
   oDataTable:cName        := cPatEmp() + "PedPrvD"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PedPrvD.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PedPrvD.Cdx"
   oDataTable:cDescription := "Pedidos de proveedor"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   /*
   Albaran Proveedores
   */

   oDataTable              := TDataTable()
   oDataTable:cArea        := "AlbProvT"
   oDataTable:cName        := cPatEmp() + "AlbProvT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AlbProvT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AlbProvT.Cdx"
   oDataTable:bSyncFile    := {|| SynAlbPrv( cPatEmp() ) }
   oDataTable:cDescription := "Albaranes de proveedor"
   oDataTable:bCreateFile  := {| cPath | mkAlbPrv( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxAlbPrv( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "AlbProvL"
   oDataTable:cName        := cPatEmp() + "AlbProvL"
   oDataTable:cDescription := "Albaranes de proveedor lineas"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AlbProvL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AlbProvL.Cdx"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "AlbPrvI"
   oDataTable:cName        := cPatEmp() + "AlbPrvI"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AlbPrvI.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AlbPrvI.Cdx"
   oDataTable:cDescription := "Albaranes de proveedor incidencias"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "AlbPrvD"
   oDataTable:cName        := cPatEmp() + "AlbPrvD"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AlbPrvD.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AlbPrvD.Cdx"
   oDataTable:cDescription := "Albaranes de proveedor documentos"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "AlbPrvS"
   oDataTable:cName        := cPatEmp() + "AlbPrvS"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AlbPrvS.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AlbPrvS.Cdx"
   oDataTable:cDescription := "Albaranes de proveedor series"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   /*
   Facturas Proveedores--------------------------------------------------------
   */

   oDataTable              := TDataTable()
   oDataTable:cArea        := "FacPrvT"
   oDataTable:cName        := cPatEmp() + "FacPrvT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacPrvT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacPrvT.Cdx"
   oDataTable:bSyncFile    := {|| SynFacPrv( cPatEmp() ) }
   oDataTable:cDescription := "Facturas de proveedor"
   oDataTable:bCreateFile  := {| cPath | mkFacPrv( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxFacPrv( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "FacPrvL"   
   oDataTable:cName        := cPatEmp() + "FacPrvL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacPrvL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacPrvL.Cdx"
   oDataTable:cDescription := "Líneas de facturas de proveedor"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "FacPrvI"
   oDataTable:cName        := cPatEmp() + "FacPrvI"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacPrvI.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacPrvI.Cdx"
   oDataTable:cDescription := "Incidencias de facturas de proveedor"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "FacPrvD"
   oDataTable:cName        := cPatEmp() + "FacPrvD"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacPrvD.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacPrvD.Cdx"
   oDataTable:cDescription := "Documentos de facturas de proveedor"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "FacPrvP"
   oDataTable:cName        := cPatEmp() + "FacPrvP"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacPrvP.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacPrvP.Cdx"
   oDataTable:cDescription := "Pagos de facturas de proveedor"
   oDataTable:bSyncFile    := {|| SynRecPrv( cPatEmp() ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "FacPrvS"
   oDataTable:cName        := cPatEmp() + "FacPrvS"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacPrvS.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacPrvS.Cdx"
   oDataTable:cDescription := "Series de facturas de proveedor"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   /*
   Rectificativas de proveedores
   */

   oDataTable              := TDataTable()
   oDataTable:cArea        := "RctPrvT"   
   oDataTable:cName        := cPatEmp() + "RctPrvT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "RctPrvT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "RctPrvT.Cdx"
   oDataTable:cDescription := "Rectificativas de proveedor"
   oDataTable:bCreateFile  := {| cPath | mkRctPrv( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxRctPrv( cPath ) }
   oDataTable:bSyncFile    := {|| SynRctPrv( cPatEmp() ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "RctPrvL"
   oDataTable:cName        := cPatEmp() + "RctPrvL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "RctPrvL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "RctPrvL.Cdx"
   oDataTable:cDescription := "Líneas de rectificativas de proveedor"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "RctPrvI"   
   oDataTable:cName        := cPatEmp() + "RctPrvI"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "RctPrvI.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "RctPrvI.Cdx"
   oDataTable:cDescription := "Rectificativas de proveedor"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "RctPrvD"   
   oDataTable:cName        := cPatEmp() + "RctPrvD"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "RctPrvD.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "RctPrvD.Cdx"
   oDataTable:cDescription := "Rectificativas de proveedor"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "RctPrvS"
   oDataTable:cName        := cPatEmp() + "RctPrvS"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "RctPrvS.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "RctPrvS.Cdx"
   oDataTable:cDescription := "Rectificativas de proveedor"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   /*
   SAT Clientes
   */

   oDataTable              := TDataTable()
   oDataTable:cArea        := "SatCliT"
   oDataTable:cName        := cPatEmp() + "SatCliT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "SatCliT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "SatCliT.Cdx"
   oDataTable:cDescription := "S.A.T. de clientes"
   oDataTable:bCreateFile  := {| cPath | mkSatCli( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxSatCli( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "SatCliL"
   oDataTable:cName        := cPatEmp() + "SatCliL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "SatCliL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "SatCliL.Cdx"
   oDataTable:cDescription := "S.A.T. de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "SatCliI"
   oDataTable:cName        := cPatEmp() + "SatCliI"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "SatCliI.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "SatCliI.Cdx"
   oDataTable:cDescription := "S.A.T. de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "SatCliD"
   oDataTable:cName        := cPatEmp() + "SatCliD"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "SatCliD.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "SatCliD.Cdx"
   oDataTable:cDescription := "S.A.T. de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "SatCliS"
   oDataTable:cName        := cPatEmp() + "SatCliS"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "SatCliS.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "SatCliS.Cdx"
   oDataTable:cDescription := "S.A.T. de clientes"
   oDataTable:bSyncFile    := {|| SynSatCli( cPatEmp() ) }
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   /*
   Presupuestos Clientes
   */

   oDataTable              := TDataTable()
   oDataTable:cArea        := "PreCliT"
   oDataTable:cName        := cPatEmp() + "PreCliT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PreCliT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PreCliT.Cdx"
   oDataTable:cDescription := "Presupuestos de clientes"
   oDataTable:bCreateFile  := {| cPath | mkPreCli( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxPreCli( cPath ) }
   oDataTable:bSyncFile    := {|| SynPreCli( cPatEmp() ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "PreCliL"
   oDataTable:cName        := cPatEmp() + "PreCliL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PreCliL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PreCliL.Cdx"
   oDataTable:cDescription := "Presupuestos de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "PreCliI"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PreCliI.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PreCliI.Cdx"
   oDataTable:cDescription := "Presupuestos de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "PreCliD"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PreCliD.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PreCliD.Cdx"
   oDataTable:cDescription := "Presupuestos de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   /*
   Pedidos Clientes
   */

   oDataTable              := TDataTable()
   oDataTable:cArea        := "PedCliT"
   oDataTable:cName        := cPatEmp() + "PedCliT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PedCliT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PedCliT.Cdx"
   oDataTable:cDescription := "Pedidos de clientes"
   oDataTable:bCreateFile  := {| cPath | mkPedCli( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxPedCli( cPath ) }
   oDataTable:bSyncFile    := {|| SynPedCli( cPatEmp() ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "PedCliL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PedCliL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PedCliL.Cdx"
   oDataTable:cDescription := "Líneas de pedidos de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "PedCliI"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PedCliI.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PedCliI.Cdx"
   oDataTable:cDescription := "Incidencias de pedidos de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "PedCliD"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PedCliD.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PedCliD.Cdx"
   oDataTable:cDescription := "Documentos de pedidos de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "PedCliP"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PedCliP.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PedCliP.Cdx"
   oDataTable:cDescription := "Pagos de pedidos de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "PedCliR"
   oDataTable:cName        := cPatEmp() + "PedCliR"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PedCliR.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PedCliR.Cdx"
   oDataTable:cDescription := "Pedidos de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   /*
   Albaranes Clientes
   */

   oDataTable              := TDataTable()
   oDataTable:cArea        := "AlbCliT"
   oDataTable:cName        := cPatEmp() + "AlbCliT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AlbCliT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AlbCliT.Cdx"
   oDataTable:cDescription := "Albaranes de clientes"
   oDataTable:bCreateFile  := {| cPath | mkAlbCli( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxAlbCli( cPath ) }
   oDataTable:bSyncFile    := {|| SynAlbCli( cPatEmp() ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "AlbCliL"
   oDataTable:cName        := cPatEmp() + "AlbCliL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AlbCliL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AlbCliL.Cdx"
   oDataTable:cDescription := "Albaranes de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "AlbCliI"
   oDataTable:cName        := cPatEmp() + "AlbCliI"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AlbCliI.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AlbCliI.Cdx"
   oDataTable:cDescription := "Albaranes de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "AlbCliD"
   oDataTable:cName        := cPatEmp() + "AlbCliD"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AlbCliD.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AlbCliD.Cdx"
   oDataTable:cDescription := "Albaranes de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "AlbCliP"
   oDataTable:cName        := cPatEmp() + "AlbCliP"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AlbCliP.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AlbCliP.Cdx"
   oDataTable:cDescription := "Albaranes de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "AlbCliS"
   oDataTable:cName        := cPatEmp() + "AlbCliS"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AlbCliS.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AlbCliS.Cdx"
   oDataTable:cDescription := "Albaranes de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   /*
   Remesas---------------------------------------------------------------------
   */

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "RemCliT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "RemCliT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "RemCliT.Cdx"
   oDataTable:cDescription := "Remesas de clientes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "RemAgeL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "RemAgeL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "RemAgeL.Cdx"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   /*
   Facturas Clientes-----------------------------------------------------------
   */

   oDataTable              := TDataTable()
   oDataTable:cArea        := "FacCliT"
   oDataTable:cName        := cPatEmp() + "FacCliT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacCliT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacCliT.Cdx"
   oDataTable:cDescription := "Facturas de clientes"
   oDataTable:bCreateFile  := {| cPath | mkFacCli( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxFacCli( cPath ) }
   oDataTable:bSyncFile    := {|| SynFacCli( cPatEmp() ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "FacCliL"
   oDataTable:cName        := cPatEmp() + "FacCliL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacCliL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacCliL.Cdx"
   oDataTable:cDescription := "Facturas de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "FacCliI"
   oDataTable:cName        := cPatEmp() + "FacCliI"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacCliI.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacCliI.Cdx"
   oDataTable:cDescription := "Facturas de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "FacCliD"
   oDataTable:cName        := cPatEmp() + "FacCliD"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacCliD.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacCliD.Cdx"
   oDataTable:cDescription := "Facturas de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "FacCliS"
   oDataTable:cName        := cPatEmp() + "FacCliS"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacCliS.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacCliS.Cdx"
   oDataTable:cDescription := "Facturas de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "FacRecT"
   oDataTable:cName        := cPatEmp() + "FacRecT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacRecT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacRecT.Cdx"
   oDataTable:cDescription := "Rectificativas de clientes"
   oDataTable:bCreateIndex := {| cPath | rxFacRec( cPath ) }
   oDataTable:bCreateFile  := {| cPath | mkFacRec( cPath ) }
   oDataTable:bSyncFile    := {|| SynFacRec( cPatEmp() ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "FacRecL"
   oDataTable:cName        := cPatEmp() + "FacRecL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacRecL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacRecL.Cdx"
   oDataTable:cDescription := "Rectificativas de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares   
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "FacRecI"
   oDataTable:cName        := cPatEmp() + "FacRecI"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacRecI.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacRecI.Cdx"
   oDataTable:cDescription := "Rectificativas de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "FacRecD"
   oDataTable:cName        := cPatEmp() + "FacRecD"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacRecD.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacRecD.Cdx"
   oDataTable:cDescription := "Rectificativas de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "FacRecS"
   oDataTable:cName        := cPatEmp() + "FacRecS"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacRecS.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacRecS.Cdx"
   oDataTable:cDescription := "Rectificativas de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "FacCliP"
   oDataTable:cName        := cPatEmp() + "FacCliP"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacCliP.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacCliP.Cdx"
   oDataTable:cDescription := "Facturas de clientes recibos"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:bCreateIndex := {| cPath | rxRecCli( cPath ) }
   oDataTable:bCreateFile  := {| cPath | mkRecCli( cPath ) }
   oDataTable:bSyncFile    := {|| SynRecCli( cPatEmp() ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "FacCliG"
   oDataTable:cName        := cPatEmp() + "FacCliG"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacCliG.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacCliG.Cdx"
   oDataTable:cDescription := "Facturas de clientes grupos de recibos"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "FacAutT"
   oDataTable:cName        := cPatEmp() + "FacAutT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacAutT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacAutT.Cdx"
   oDataTable:cDescription := "Plantillas automáticas de clientes"
   oDataTable:bCreateFile  := {| cPath | TFacAutomatica():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "GrpFac"
   oDataTable:cName        := cPatEmp() + "GrpFac"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "GrpFac.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "GrpFac.Cdx"
   oDataTable:cDescription := "Grupos de facturas automáticas"
   oDataTable:bCreateFile  := {| cPath | TGrpFacturasAutomaticas():BuildFiles( .t., cPath ) }
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "FacAutL"
   oDataTable:cName        := cPatEmp() + "FacAutL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacAutL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacAutL.Cdx"
   oDataTable:cDescription := "Plantillas automáticas de clientes lineas"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:bCreateFile  := {| cPath | TDetFacAutomatica():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "FacAutI"
   oDataTable:cName        := cPatEmp() + "FacAutI"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacAutI.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacAutI.Cdx"
   oDataTable:cDescription := "Plantillas automáticas de clientes historico"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:bCreateFile  := {| cPath | THisFacAutomatica():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   /*
   Facturas de anticipo-----------------------------------------------
   */

   oDataTable              := TDataTable()
   oDataTable:cArea        := "AntCliT"
   oDataTable:cName        := cPatEmp() + "AntCliT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AntCliT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AntCliT.Cdx"
   oDataTable:cDescription := "Anticipos de clientes"
   oDataTable:bCreateIndex := {| cPath | rxAntCli( cPath ) }
   oDataTable:bCreateFile  := {| cPath | mkAntCli( cPath ) }
   // oDataTable:bSyncFile    := {|| SynAntCli( cPatEmp() ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "AntCliI"
   oDataTable:cName        := cPatEmp() + "AntCliI"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AntCliI.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AntCliI.Cdx"
   oDataTable:cDescription := "Anticipos de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "AntCliD"
   oDataTable:cName        := cPatEmp() + "AntCliD"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AntCliD.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AntCliD.Cdx"
   oDataTable:cDescription := "Anticipos de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   /*
   Ticket Clientes
   */

   oDataTable              := TDataTable()
   oDataTable:cArea        := "TikeT"
   oDataTable:cName        := cPatEmp() + "TikeT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TikeT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TikeT.Cdx"
   oDataTable:cDescription := "Tickets de clientes"
   oDataTable:bCreateIndex := {| cPath | rxTpv( cPath ) }
   oDataTable:bCreateFile  := {| cPath | mkTpv( cPath ) }
   oDataTable:bSyncFile    := {|| SynTikCli( cPatEmp() ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "TikeL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TikeL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TikeL.Cdx"
   oDataTable:cDescription := "Líneas de tickets de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "TikeP"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TikeP.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TikeP.Cdx"
   oDataTable:cDescription := "Pagos de tickets de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "TikeS"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TikeS.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TikeS.Cdx"
   oDataTable:cDescription := "Series de tickets de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "TikeM"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TikeM.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TikeM.Cdx"
   oDataTable:cDescription := "Mesas tickets de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "TikeC"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TikeC.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TikeC.Cdx"
   oDataTable:cDescription := "Pagos de tickets de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "TiketImp"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TiketImp.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TiketImp.Cdx"
   oDataTable:cDescription := "Log de impresión de tickets de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "TpvMenus"
   oDataTable:cName        := cPatEmp() + "TpvMenus"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TpvMenus.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TpvMenus.Cdx"
   oDataTable:cDescription := "Menus para TPV"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "TpvMnuArt"
   oDataTable:cName        := cPatEmp() + "TpvMnuArt"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TpvMnuArt.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TpvMnuArt.Cdx"
   oDataTable:cDescription := "Artículos para menus de TPV"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "TpvMnuOrd"
   oDataTable:cName        := cPatEmp() + "TpvMnuOrd"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TpvMnuOrd.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TpvMnuOrd.Cdx"
   oDataTable:cDescription := "Ordenes para menus de TPV"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   /*
   Salas de venta--------------------------------------------------------------
   */

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "SalaVta"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "SalaVta.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "SalaVta.Cdx"
   oDataTable:cDescription := "Salas de ventas"
   oDataTable:bCreateFile  := {| cPath | TSalaVenta():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "SlaPnt"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "SlaPnt.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "SlaPnt.Cdx"
   oDataTable:cDescription := "Puntos de la sala de ventas"
   oDataTable:bCreateFile  := {| cPath | TDetSalaVenta():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   /*
   Produccion------------------------------------------------------------------
   */

   oDataTable              := TDataTable()
   oDatatable:cArea        := "ProCab"
   oDataTable:cName        := cPatEmp() + "ProCab"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ProCab.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ProCab.Cdx"
   oDataTable:cDescription := "Producción"
   oDataTable:bCreateFile  := {| cPath | TProduccion():BuildFiles( .t., cPath ) }
   oDataTable:hDefinition  := TProduccion():DefineHash()
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "ProLin"
   oDataTable:cName        := cPatEmp() + "ProLin"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ProLin.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ProLin.Cdx"
   oDataTable:cDescription := "Líneas de producción"
   oDataTable:bCreateFile  := {| cPath | TDetProduccion():BuildFiles( .t., cPath ) }
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "ProSer"
   oDataTable:cName        := cPatEmp() + "ProSer"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ProSer.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ProSer.Cdx"
   oDataTable:cDescription := "Series de producción"
   oDataTable:bCreateFile  := {| cPath | TDetSeriesProduccion():BuildFiles( .t., cPath ) }
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "ProMat"
   oDataTable:cName        := cPatEmp() + "ProMat"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ProMat.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ProMat.Cdx"
   oDataTable:cDescription := "Materiales de producción"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:bCreateFile  := {| cPath | TDetMaterial():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "ProMaq"
   oDataTable:cName        := cPatEmp() + "ProMaq"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ProMaq.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ProMaq.Cdx"
   oDataTable:cDescription := "Producción"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:bCreateFile  := {| cPath | TDetMaquina():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "MaqCosT"
   oDataTable:cName        := cPatEmp() + "MaqCosT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "MaqCosT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "MaqCosT.Cdx"
   oDataTable:cDescription := "Producción"
   oDataTable:bCreateFile  := {| cPath | TMaquina():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "MaqCosL"
   oDataTable:cName        := cPatEmp() + "MaqCosL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "MaqCosL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "MaqCosL.Cdx"
   oDataTable:cDescription := "Producción"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:bCreateFile  := {| cPath | TDetCostes():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "Costes"
   oDataTable:cName        := cPatEmp() + "Costes"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Costes.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Costes.Cdx"
   oDataTable:cDescription := "Producción"
   oDataTable:bCreateFile  := {| cPath | TCosMaq():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "ProPer"
   oDataTable:cName        := cPatEmp() + "ProPer"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ProPer.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ProPer.Cdx"
   oDataTable:bCreateFile  := {| cPath | TDetPersonal():BuildFiles( .t., cPath ) }
   oDataTable:cDescription := "Producción"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "OpeT"
   oDataTable:cName        := cPatEmp() + "OpeT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "OpeT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "OpeT.Cdx"
   oDataTable:cDescription := "Producción"
   oDataTable:bCreateFile  := {| cPath | TOperarios():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "OpeL"
   oDataTable:cName        := cPatEmp() + "OpeL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "OpeL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "OpeL.Cdx"
   oDataTable:cDescription := "Producción"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:bCreateFile  := {| cPath | TDetHoras():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "Operacio"
   oDataTable:cName        := cPatEmp() + "Operacio"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Operacio.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Operacio.Cdx"
   oDataTable:cDescription := "Producción"
   oDataTable:bCreateFile  := {| cPath | TOperacion():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "Seccion"
   oDataTable:cName        := cPatEmp() + "Seccion"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Seccion.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Seccion.Cdx"
   oDataTable:cDescription := "Producción"
   oDataTable:bCreateFile  := {| cPath | TSeccion():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "Horas"
   oDataTable:cName        := cPatEmp() + "Horas"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Horas.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Horas.Cdx"
   oDataTable:cDescription := "Producción"
   oDataTable:bCreateFile  := {| cPath | THoras():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "ProHPer"
   oDataTable:cName        := cPatEmp() + "ProHPer"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ProHPer.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ProHPer.Cdx"
   oDataTable:cDescription := "Producción"
   oDataTable:bCreateFile  := {| cPath | TDetHorasPersonal():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "MatSer"
   oDataTable:cName        := cPatEmp() + "MatSer"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "MatSer.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "MatSer.Cdx"
   oDataTable:cDescription := "Producción"
   oDataTable:bCreateFile  := {| cPath | TDetMaterial():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "TipOpera"
   oDataTable:cName        := cPatEmp() + "TipOpera"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TipOpera.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TipOpera.Cdx"
   oDataTable:cDescription := "Producción"
   oDataTable:bCreateFile  := {| cPath | TTipOpera():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "ExtAgeT"
   oDataTable:cName        := cPatEmp() + "ExtAgeT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ExtAgeT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ExtAgeT.Cdx"
   oDataTable:cDescription := "Estado depósitos"
   oDataTable:bCreateFile  := {| cPath | mkExtAge( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxExtAge( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cArea        := "ExtAgeL"
   oDataTable:cName        := cPatEmp() + "ExtAgeL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ExtAgeL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ExtAgeL.Cdx"
   oDataTable:cDescription := "Estado depósitos"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   /*
   Ordenes de carga------------------------------------------------------------
   */

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "OrdCarP"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "OrdCarP.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "OrdCarP.Cdx"
   oDataTable:cDescription := "Ordenes de carga"
   oDataTable:bCreateFile  := {| cPath | TOrdCarga():BuildFiles( .t., cPath ) }
   oDataTable:bSyncFile    := {|| SynOrdCar( cPatEmp() ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "OrdCarL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "OrdCarL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "OrdCarL.Cdx"
   oDataTable:cDescription := "Ordenes de carga"
   oDataTable:bCreateFile  := {| cPath | TDetOrdCar():BuildFiles( .t., cPath ) }
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   /*
   Expedientes-----------------------------------------------------------------
   */

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "ExpCab"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ExpCab.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ExpCab.Cdx"
   oDataTable:cDescription := "Expedientes"
   oDataTable:bCreateFile  := {| cPath | TExpediente():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "ExpDet"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ExpDet.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ExpDet.Cdx"
   oDataTable:cDescription := "Expedientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:bCreateFile  := {| cPath | TDetActuacion():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "TipExpT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TipExpT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TipExpT.Cdx"
   oDataTable:cDescription := "Expedientes"
   oDataTable:bCreateFile  := {| cPath | TTipoExpediente():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "TipExpL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TipExpL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TipExpL.Cdx"
   oDataTable:cDescription := "Expedientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:bCreateFile  := {| cPath | TDetTipoExpediente():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "Entidades"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Entidades.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Entidades.Cdx"
   oDataTable:cDescription := "Expedientes"
   oDataTable:bCreateFile  := {| cPath | TEntidades():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "Colaboradores"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Colaboradores.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Colaboradores.Cdx"
   oDataTable:cDescription := "Expedientes"
   oDataTable:bCreateFile  := {| cPath | TColaboradores():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "Actuaciones"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Actuaciones.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Actuaciones.Cdx"
   oDataTable:cDescription := "Expedientes"
   oDataTable:bCreateFile  := {| cPath | TActuaciones():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   /*
   Envios----------------------------------------------------------------------
   */

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "SndLog"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "SndLog.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "SndLog.Cdx"
   oDataTable:cDescription := "Envios y recepción"
   oDataTable:bCreateFile  := {| cPath | TSndRecInf():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "SndFil"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "SndFil.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "SndFil.Cdx"
   oDataTable:cDescription := "Envios y recepción"
   ::AddEmpresaTable( oDataTable )

   /*
   Reportes----------------------------------------------------------------------
   */

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "CfgCar"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "CfgCar.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "CfgCar.Cdx"
   oDataTable:cDescription := "Reportes"
   oDataTable:bCreateFile  := {| cPath | mkReport( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxReport( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "CfgFav"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "CfgFav.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "CfgFav.Cdx"
   oDataTable:cDescription := "Reportes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "Scripts"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Scripts.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Scripts.Cdx"
   oDataTable:cDescription := "Reportes"
   oDataTable:bCreateFile  := {| cPath | TScripts():BuildFiles( .t., cPath ) }
   ::AddEmpresaTable( oDataTable )

   // Objetos -----------------------------------------------------------------

   oDataTable              := TGrpCli():Create( cPatCli() )
   ::AddEmpresaObject( oDataTable )

   oDataTable              := TGrpPrv():Create( cPatPrv() )
   ::AddEmpresaObject( oDataTable )

   oDataTable              := UniMedicion():Create()
   ::AddEmpresaObject( oDataTable )

   oDataTable              := TBancos():Create()
   ::AddEmpresaObject( oDataTable )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD BuildTrigger()

   with object ( TAuditor() )
      :Create( cPatDat() )
   end with

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CreateOperationLogTable()

   local cTable

   if File( "Datos\SqlOperationLog.adt" )
      fErase( "Datos\SqlOperationLog.adt" )
   end if

   cTable         := 'CREATE TABLE Datos\SqlOperationLog ('          + CRLF
   cTable         +=    'ID AUTOINC CONSTRAINT NOT NULL,'            + CRLF
   cTable         +=    'DATETIME TIMESTAMP CONSTRAINT NOT NULL,'    + CRLF
   cTable         +=    'USERNAME CHAR(50) CONSTRAINT NOT NULL,'     + CRLF
   cTable         +=    'APPNAME CHAR(50),'                          + CRLF
   cTable         +=    'TABLENAME CHAR(150) CONSTRAINT NOT NULL,'   + CRLF
   cTable         +=    'OPERATION CHAR(6) CONSTRAINT NOT NULL )'    + CRLF
   cTable         +=    'IN DATABASE;' + CRLF

Return ( ::ExecuteSqlStatement( cTable, "OperationLog" ) )

//---------------------------------------------------------------------------//

METHOD CreateColumnLogTable()

   local cTable

   if File( "Datos\SqlColumnLog.adt" )
      fErase( "Datos\SqlColumnLog.adt" )
   end if

   cTable         := 'CREATE TABLE Datos\SqlColumnLog ('             + CRLF
   cTable         +=    'ID AUTOINC CONSTRAINT NOT NULL,'            + CRLF
   cTable         +=    'OPERATIONID INTEGER CONSTRAINT NOT NULL,'   + CRLF
   cTable         +=    'COLUMNNAME CHAR(50) CONSTRAINT NOT NULL,'   + CRLF
   cTable         +=    'USERNAME CHAR(50) CONSTRAINT NOT NULL,'     + CRLF
   cTable         +=    'APPNAME CHAR(50),'                          + CRLF
   cTable         +=    'TABLENAME CHAR(150) CONSTRAINT NOT NULL,'   + CRLF
   cTable         +=    'OLDVALUE CHAR(250),'                        + CRLF
   cTable         +=    'NEWVALUE CHAR(250) )'                       + CRLF
   cTable         +=    'IN DATABASE;'                               + CRLF

Return ( ::ExecuteSqlStatement( cTable, "ColumnLog" ) )

//---------------------------------------------------------------------------//

METHOD Auditor()

   if !Empty( oWnd() )
      oWnd():CloseAll()
   end if

   ::BuildData()
     
   ::BuildEmpresa()

   if !::lSelectOperationLog()
      Return ( Self )
   end if

   if !::lSelectColumnLog()
      Return ( Self )
   end if

   if !::GetAllLocksTablesUsers()
      Return ( Self )
   end if 

   ::lCreaArrayPeriodos()

   DEFINE DIALOG ::oDlgAuditor RESOURCE "AdvantageAuditor"

      REDEFINE FOLDER ::oFldAuditor;
         ID          100 ;
         OF          ::oDlgAuditor ;
         PROMPT      "&Operaciones",;
                     "&Bloqueos" ;
         DIALOGS     "AdvantageAuditor_Operaciones",;
                     "AdvantageAuditor_Bloqueos"

      REDEFINE COMBOBOX ::oPeriodo ;
         VAR         ::cPeriodo ;
         ID          100 ;
         ITEMS       ::aPeriodo ;
         OF          ::oFldAuditor:aDialogs[1]

      ::oPeriodo:bChange                     := {|| ::lRecargaFecha() } 

      REDEFINE GET   ::oIniInf ;
         VAR         ::dIniInf ;
         SPINNER ;
         ID          120 ;
         OF          ::oFldAuditor:aDialogs[1]

      REDEFINE GET   ::oFinInf ;
         VAR         ::dFinInf;
         SPINNER ;
         ID          130 ;
         OF          ::oFldAuditor:aDialogs[1]

      REDEFINE CHECKBOX ::lAppend ;
         ID          140 ;
         OF          ::oFldAuditor:aDialogs[1]

      REDEFINE CHECKBOX ::lEdit ;
         ID          141 ;
         OF          ::oFldAuditor:aDialogs[1]

      REDEFINE CHECKBOX ::lDelete ;
         ID          142 ;
         OF          ::oFldAuditor:aDialogs[1]

      REDEFINE BUTTON ;
         ID          150 ;
         OF          ::oFldAuditor:aDialogs[1] ;
         ACTION      ( ::InlineSelectOperationLog() )

      /*
      Operaciones -------------------------------------------------------------
      */

      ::oBrwOperation                        := TXBrowse():New( ::oFldAuditor:aDialogs[1] )

      ::oBrwOperation:lRecordSelector        := .t.
      ::oBrwOperation:lTransparent           := .f.
      ::oBrwOperation:nDataLines             := 1

      ::oBrwOperation:lVScroll               := .t.
      ::oBrwOperation:lHScroll               := .f.

      ::oBrwOperation:nMarqueeStyle          := MARQSTYLE_HIGHLROW

      ::oBrwOperation:cAlias                 := "SqlOperation"

      ::oBrwOperation:bClrSel                := {|| { CLR_WHITE, RGB( 53, 142, 182 ) } }
      ::oBrwOperation:bClrSelFocus           := {|| { CLR_WHITE, RGB( 53, 142, 182 ) } }

/*
      ::oBrwOperation:bKeyNo                 := {| n, Self | iif( n == nil, Round( ( "SqlOperation" )->( ADSGetRelKeyPos() ) * Self:nLen, 0 ), ( "SqlOperation" )->( ADSSetRelKeyPos( n / Self:nLen ) ) ) }
      ::oBrwOperation:bKeyCount              := {|| ( "SqlOperation" )->( ADSKeyCount( , , 1 ) ) }
*/

      ::oBrwOperation:bChange                := {|| ::InlineSelectColumnLog( SqlOperation->Id ) }

      ::oBrwOperation:CreateFromResource( 200 )

      with object ( ::oBrwOperation:AddCol() )
         :cHeader          := "Id"
         :nWidth           := 80
         :bEditValue       := {|| SqlOperation->Id } 
      end with

      with object ( ::oBrwOperation:AddCol() )
         :cHeader          := "Fecha y hora"
         :nWidth           := 140
         :cDataType        := 'T'
         :cEditPicture     := '@T'
         :nDataStrAlign    := 3
         :nHeadStrAlign    := 3 
         :bEditValue       := {|| SqlOperation->DateTime }
      end with 

      with object ( ::oBrwOperation:AddCol() )
         :cHeader          := "Usuario"
         :nWidth           := 100  
         :bEditValue       := {|| SqlOperation->AppName }
      end with

      with object ( ::oBrwOperation:AddCol() )
         :cHeader          := "Empresa"
         :nWidth           := 100
         :bEditValue       := {|| ::cEmpresaDescription( SqlOperation->TableName ) }
      end with

      with object ( ::oBrwOperation:AddCol() )
         :cHeader          := "Tabla"
         :nWidth           := 100
         :bEditValue       := {|| ::cTableDescription( SqlOperation->TableName ) }
      end with

      with object ( ::oBrwOperation:AddCol() )
         :cHeader          := "Ruta"
         :nWidth           := 100
         :bEditValue       := {|| SqlOperation->TableName }
      end with

      with object ( ::oBrwOperation:AddCol() )
         :cHeader          := "Operación"
         :nWidth           := 100
         :bEditValue       := {|| ::cOperationDescription( SqlOperation->Operation ) }
      end with

      /*
      Columnas de cambio-------------------------------------------------------
      */

      ::oBrwColumn                        := TXBrowse():New( ::oFldAuditor:aDialogs[1] )

      ::oBrwColumn:lRecordSelector        := .t.
      ::oBrwColumn:lTransparent           := .f.
      ::oBrwColumn:nDataLines             := 1

      ::oBrwColumn:lVScroll               := .t.
      ::oBrwColumn:lHScroll               := .f.

      ::oBrwColumn:nMarqueeStyle          := MARQSTYLE_HIGHLROW

      ::oBrwColumn:cAlias                 := "SqlColumn"

      ::oBrwColumn:bClrSel                := {|| { CLR_WHITE, RGB( 53, 142, 182 ) } }
      ::oBrwColumn:bClrSelFocus           := {|| { CLR_WHITE, RGB( 53, 142, 182 ) } }

/*
      ::oBrwColumn:bKeyNo                 := {| n, Self | iif( n == nil, Round( ( "SqlColumn" )->( ADSGetRelKeyPos() ) * Self:nLen, 0 ), ( "SqlColumn" )->( ADSSetRelKeyPos( n / Self:nLen ) ) ) }
      ::oBrwColumn:bKeyCount              := {|| ( "SqlColumn" )->( ADSKeyCount( , , 1 ) ) }
*/

      ::oBrwColumn:CreateFromResource( 210 )

      with object ( ::oBrwColumn:AddCol() )
         :cHeader          := "Operation"
         :nWidth           := 80
         :bEditValue       := {|| SqlColumn->OperationId } 
      end with

      with object ( ::oBrwColumn:AddCol() )
         :cHeader          := "COLUMNNAME"
         :nWidth           := 80
         :bEditValue       := {|| SqlColumn->COLUMNNAME } 
      end with

      with object ( ::oBrwColumn:AddCol() )
         :cHeader          := "OLDVALUE"
         :nWidth           := 80
         :bEditValue       := {|| SqlColumn->OLDVALUE } 
      end with

      with object ( ::oBrwColumn:AddCol() )
         :cHeader          := "NEWVALUE"
         :nWidth           := 80
         :bEditValue       := {|| SqlColumn->NEWVALUE } 
      end with

      /*
      Columnas bloqueos-------------------------------------------------------
      */

      REDEFINE BUTTON ;
         ID          150 ;
         OF          ::oFldAuditor:aDialogs[2] ;
         ACTION      ( ::GetAllLocksTablesUsers(), ::oBrwBlocks:Refresh(), ::oBrwBlocks:GoTop() )

      ::oBrwBlocks                        := TXBrowse():New( ::oFldAuditor:aDialogs[2] )

      ::oBrwBlocks:lRecordSelector        := .t.
      ::oBrwBlocks:lTransparent           := .f.
      ::oBrwBlocks:nDataLines             := 1

      ::oBrwBlocks:lVScroll               := .t.
      ::oBrwBlocks:lHScroll               := .f.

      ::oBrwBlocks:nMarqueeStyle          := MARQSTYLE_HIGHLROW

      ::oBrwBlocks:cAlias                 := "AllLocks"

      ::oBrwBlocks:bClrSel                := {|| { CLR_WHITE, RGB( 53, 142, 182 ) } }
      ::oBrwBlocks:bClrSelFocus           := {|| { CLR_WHITE, RGB( 53, 142, 182 ) } }

      ::oBrwBlocks:CreateFromResource( 100 )

      with object ( ::oBrwBlocks:AddCol() )
         :cHeader          := "Tabla"
         :nWidth           := 180
         :bEditValue       := {|| AllLocks->TableName } 
      end with

      with object ( ::oBrwBlocks:AddCol() )
         :cHeader          := "Registro Nº"
         :nWidth           := 80
         :bEditValue       := {|| Trans( AllLocks->RecNumber, "9999999999" ) } 
      end with

      with object ( ::oBrwBlocks:AddCol() )
         :cHeader          := "Usuario"
         :nWidth           := 80
         :bEditValue       := {|| AllLocks->UserName } 
      end with

      with object ( ::oBrwBlocks:AddCol() )
         :cHeader          := "Direccion IP"
         :nWidth           := 80
         :bEditValue       := {|| AllLocks->IPAddress } 
      end with

      with object ( ::oBrwBlocks:AddCol() )
         :cHeader          := "Usuario"
         :nWidth           := 80
         :bEditValue       := {|| AllLocks->DictionaryUser } 
      end with

      /*
      Boton de salida----------------------------------------------------------
      */

      REDEFINE BUTTON ;
         ID                IDOK ;
         OF                ::oDlgAuditor ;
         ACTION            ( ::oDlgAuditor:End() )

   ::oDlgAuditor:Activate( , , , .t. )

   ::CloseOperationLog()
   ::CloseColumnLog()
   ::CloseAllLocksTablesUsers()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lSelectOperationLog()

   local lOk
   local cStm
   local cOpe
   local cDateFormat

   cDateFormat    := Set( _SET_DATEFORMAT )

   Set( _SET_DATEFORMAT, "YYYY-MM-DD" )

   /*
   Creamos la instruccion------------------------------------------------------
   */

   cStm           := "SELECT * FROM SqlOperationLog "
   cStm           += "WHERE DateTime >= '" + Dtoc( ::dIniInf ) + " 00:00:00' AND DateTime <= '" + Dtoc( ::dFinInf ) + " 23:59:59' "

   cOpe           := ""

   if ::lAppend
      cOpe        += "Operation = 'INSERT'"
   end if

   if ::lEdit
      cOpe        += if( !Empty( cOpe ), " OR ", "" )
      cOpe        += "Operation = 'UPDATE'"
   end if

   if ::lDelete
      cOpe        += if( !Empty( cOpe ), " OR ", "" )
      cOpe        += "Operation = 'DELETE'"
   end if

   if !Empty( cOpe )
      cStm        += " AND ( " + cOpe + " )"
   end if

   /*
   Cerramos las areas----------------------------------------------------------
   */

   ::CloseOperationLog()

   /*
   Creamos la snetencia--------------------------------------------------------
   */

   lOk            := ::ExecuteSqlStatement( cStm, "SqlOperation" )

   /*
   Dejamos la fechas como estaban----------------------------------------------
   */

   Set( _SET_DATEFORMAT, cDateFormat )

RETURN ( lOk )

//---------------------------------------------------------------------------//

METHOD lSelectColumnLog( nOperationId )

   local cStm

   DEFAULT nOperationId    := 0

   /*
   Creamos la instruccion------------------------------------------------------
   */

   cStm           := "SELECT * FROM SqlColumnLog "
   cStm           += "WHERE OperationId = " + Alltrim( Str( nOperationId ) )

   /*
   Cerramos las areas----------------------------------------------------------
   */

   ::CloseColumnLog()

RETURN ( ::ExecuteSqlStatement( cStm, "SqlColumn" ) )

//---------------------------------------------------------------------------//

METHOD lCreaArrayPeriodos()

   aAdd( ::aPeriodo, "Hoy" )

   aAdd( ::aPeriodo, "Ayer" )

   aAdd( ::aPeriodo, "Mes en curso" )

   aAdd( ::aPeriodo, "Mes anterior" )

   do case
      case Month( GetSysDate() ) <= 3
         aAdd( ::aPeriodo, "Primer trimestre" )

      case Month( GetSysDate() ) > 3 .and. Month( GetSysDate() ) <= 6
         aAdd( ::aPeriodo, "Primer trimestre" )
         aAdd( ::aPeriodo, "Segundo trimestre" )

      case Month( GetSysDate() ) > 6 .and. Month( GetSysDate() ) <= 9
         aAdd( ::aPeriodo, "Primer trimestre" )
         aAdd( ::aPeriodo, "Segundo trimestre" )
         aAdd( ::aPeriodo, "Tercer trimestre" )

      case Month( GetSysDate() ) > 9 .and. Month( GetSysDate() ) <= 12
         aAdd( ::aPeriodo, "Primer trimestre" )
         aAdd( ::aPeriodo, "Segundo trimestre" )
         aAdd( ::aPeriodo, "Tercer trimestre" )
         aAdd( ::aPeriodo, "Cuatro trimestre" )

   end case

   aAdd( ::aPeriodo, "Doce últimos meses" )

   aAdd( ::aPeriodo, "Año en curso" )

   aAdd( ::aPeriodo, "Año anterior" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lRecargaFecha()

   do case
      case ::cPeriodo == "Hoy"

         ::oIniInf:cText( GetSysDate() )
         ::oFinInf:cText( GetSysDate() )

      case ::cPeriodo == "Ayer"

         ::oIniInf:cText( GetSysDate() -1 )
         ::oFinInf:cText( GetSysDate() -1 )

      case ::cPeriodo == "Mes en curso"

         ::oIniInf:cText( CtoD( "01/" + Str( Month( GetSysDate() ) ) + "/" + Str( Year( GetSysDate() ) ) ) )
         ::oFinInf:cText( GetSysDate() )

      case ::cPeriodo == "Mes anterior"

         ::oIniInf:cText( BoM( addMonth( GetSysDate(), - 1 ) ) )
         ::oFinInf:cText( EoM( addMonth( GetSysDate(), - 1 ) ) )

      case ::cPeriodo == "Primer trimestre"

         ::oIniInf:cText( CtoD( "01/01/" + Str( Year( GetSysDate() ) ) ) )
         ::oFinInf:cText( CtoD( "31/03/" + Str( Year( GetSysDate() ) ) ) )

      case ::cPeriodo == "Segundo trimestre"

         ::oIniInf:cText( CtoD( "01/04/" + Str( Year( GetSysDate() ) ) ) )
         ::oFinInf:cText( CtoD( "30/06/" + Str( Year( GetSysDate() ) ) ) )

      case ::cPeriodo == "Tercer trimestre"

         ::oIniInf:cText( CtoD( "01/07/" + Str( Year( GetSysDate() ) ) ) )
         ::oFinInf:cText( CtoD( "30/09/" + Str( Year( GetSysDate() ) ) ) )

      case ::cPeriodo == "Cuatro trimestre"

         ::oIniInf:cText( CtoD( "01/10/" + Str( Year( GetSysDate() ) ) ) )
         ::oFinInf:cText( CtoD( "31/12/" + Str( Year( GetSysDate() ) ) ) )

      case ::cPeriodo == "Doce últimos meses"

         ::oIniInf:cText( BoY( GetSysDate() ) )
         ::oFinInf:cText( EoY( GetSysDate() ) )

      case ::cPeriodo == "Año en curso"

         ::oIniInf:cText( CtoD( "01/01/" + Str( Year( GetSysDate() ) ) ) )
         ::oFinInf:cText( CtoD( "31/12/" + Str( Year( GetSysDate() ) ) ) )

      case ::cPeriodo == "Año anterior"

         ::oIniInf:cText( CtoD( "01/01/" + Str( Year( GetSysDate() ) - 1 ) ) )
         ::oFinInf:cText( CtoD( "31/12/" + Str( Year( GetSysDate() ) - 1 ) ) )

   end case

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD cEmpresaDescription( cTableName )

   if ( "DATOS" == Upper( Left( cTableName, 5 ) ) )
      Return ( "DATOS" )   
   end if 

   if ( "EMP" == Upper( Left( cTableName, 3 ) ) )
      Return ( SubStr( cTableName, 4, 4 ) )
   end if

Return ( cTableName )

//---------------------------------------------------------------------------//

METHOD cTableDescription( cTableName )

   local nScan
   local cDescription   := cTableName

   cTableName           := Upper( cTableName )

   if ( "DATOS" == Upper( Left( cTableName, 5 ) ) )
      nScan             := aScan( ::aDataTables, {|o| Upper( Alltrim( o:cName ) ) $ Alltrim( cTableName ) } )
      if nScan != 0
         cDescription   := ::aDataTables[ nScan ]:cDescription
      end if 
   end if 

   if ( "EMP" == Upper( Left( cTableName, 3 ) ) )
      nScan             := aScan( ::aEmpresaTables, {|o| Upper( SubStr( Alltrim( o:cName ), 8 ) ) $ SubStr( Alltrim( cTableName ), 8 ) } )
      if nScan != 0
         cDescription   := ::aEmpresaTables[ nScan ]:cDescription
      end if
   end if

Return ( cDescription )

//---------------------------------------------------------------------------//

METHOD cOperationDescription( cOperation )

Return ( ::hOperationDescription[ cOperation ] )

//---------------------------------------------------------------------------//

METHOD Resource( nId )

   local n
   local oBmp

   if nAnd( nId, 1 ) != 0
      msgStop( "Acceso no permitido." )
      return nil
   end if

   if nUsrInUse() > 1
      msgStop( "Hay más de un usuario conectado a la aplicación", "Atención" )
      return nil
   end if

   if !TReindex():lCreateHandle()
      msgStop( "Esta opción ya ha sido inicada por otro usuario", "Atención" )
      return nil
   end if

   if oWnd() != nil
      oWnd():CloseAll()
   end if

   /*
   Montamos el dialogo---------------------------------------------------------
   */

   DEFINE DIALOG ::oDlg RESOURCE "ReindexADS" OF oWnd()

      REDEFINE BITMAP oBmp RESOURCE "RegenerarIndices" ID 600 OF ::oDlg

      REDEFINE CHECKBOX ::aChkIndices[ 1 ] VAR ::aLgcIndices[ 1 ] ID 100 OF ::oDlg
      REDEFINE CHECKBOX ::aChkIndices[ 2 ] VAR ::aLgcIndices[ 2 ] ID 101 OF ::oDlg
      REDEFINE CHECKBOX ::aChkIndices[ 3 ] VAR ::aLgcIndices[ 3 ] ID 102 OF ::oDlg

      ::aProgress[ 1 ]  := TMeter():ReDefine( 200, { | u | if( pCount() == 0, ::nProgress[ 1 ], ::nProgress[ 1 ] := u ) }, 10, ::oDlg, .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )
      ::aProgress[ 2 ]  := TMeter():ReDefine( 210, { | u | if( pCount() == 0, ::nProgress[ 2 ], ::nProgress[ 2 ] := u ) }, 10, ::oDlg, .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )
      ::aProgress[ 3 ]  := TMeter():ReDefine( 220, { | u | if( pCount() == 0, ::nProgress[ 3 ], ::nProgress[ 3 ] := u ) }, 10, ::oDlg, .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )

      REDEFINE SAY ::oMsg PROMPT ::cMsg ID 110 OF ::oDlg

      /*
      Botones------------------------------------------------------------------
      */

      REDEFINE BUTTON ID IDOK       OF ::oDlg ACTION ( ::StartResource() )

      REDEFINE BUTTON ID IDCANCEL   OF ::oDlg ACTION ( ::oDlg:end() )

      ::oDlg:AddFastKey( VK_F5, {|| ::StartResource() } )

   ACTIVATE DIALOG ::oDlg CENTER

   TReindex():lCloseHandle()

   // Cerramos posibles tablas-------------------------------------------------

   dbCloseAll()

   // Iniciamos los servicios--------------------------------------------------

   InitServices()

   oBmp:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD StartResource()

   ::oDlg:Disable()

   CursorWait()

   ::BuildData()

   ::BuildEmpresa()

   ::Reindex()

   ::Syncronize()
    
   CursorWE()

   msgInfo( "Proceso finalizado con exito.")

   ::oDlg:Enable()
   ::oDlg:End()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Reindex()

   local oTable
   local cAlias

   ::DisableTriggers()

   /*
   Bases de datos de directorio datos------------------------------------------
   */

   if ::aLgcIndices[ 1 ]
      
      if !Empty( ::aProgress[ 1 ] )
         ::aProgress[ 1 ]:SetTotal( len( ::aDataTables ) )
      end if 

      for each oTable in ::aDataTables

         if !Empty( ::oMsg )
            ::oMsg:SetText( "Generando índices : " + oTable:cDescription )
         end if

         ::ReindexTable( oTable )

         if !Empty( ::aProgress[ 1 ] )
            ::aProgress[ 1 ]:Set( hb_EnumIndex() )
         end if 

      next

   end if   

   /*
   Bases de datos de empresa---------------------------------------------------
   */

   if ::aLgcIndices[ 2 ]

      if !Empty( ::aProgress[ 2 ] )
         ::aProgress[ 2 ]:SetTotal( len( ::aEmpresaTables ) )
      end if

      for each oTable in ::aEmpresaTables

         if !Empty( ::oMsg )
            ::oMsg:SetText( "Generando índices : " + oTable:cDescription )
         end if

         ::ReindexTable( oTable )

         if !Empty( ::aProgress[ 2 ] )
            ::aProgress[ 2 ]:Set( hb_EnumIndex() )
         end if 

      next

   end if   

   ::EnableTriggers()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Syncronize()

   local oTable
   local cAlias

   ::DisableTriggers()

   /*
   Sincronizacion de la empresa------------------------------------------------
   */

   if ::aLgcIndices[ 3 ]

      if !Empty( ::aProgress[ 3 ] )
         ::aProgress[ 3 ]:SetTotal( len( ::aEmpresaTables ) )
      end if 

      for each oTable in ::aEmpresaTables

         if !Empty( ::oMsg )
            ::oMsg:SetText( "Sincronizando : " + oTable:cDescription )
         end if

         if !Empty( oTable:bSyncFile )
            eval( oTable:bSyncFile )
         end if

         if !Empty( ::aProgress[ 3 ] )
            ::aProgress[ 3 ]:Set( hb_EnumIndex() )
         end if 

      next
      
   end if   

   ::EnableTriggers()

Return ( Self )

//---------------------------------------------------------------------------//


METHOD ReindexTable( oTable )

   local oError
   local oBlock

   oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      dbUseArea( .t., cDriver(), ( oTable:cName + ".Dbf" ), "Table", .f. )
      
      if !NetErr() .and. ( "Table" )->( Used() )
      
         ( "Table" )->( OrdSetFocus( 1 ) )
         ( "Table" )->( OrdListRebuild() )
         ( "Table" )->( dbCloseArea() )
      
      end if 

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible regenerar indices' )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD ActualizaTable( oTable, cPath )

   local i
   local cOld
   local cTmp
   local lCopy       
   local dbfOld
   local dbfTmp
   local nField      
   local aField

   local oError
   local oBlock
   
   lCopy             := .f.
   cOld              := oTable:cName 
   cTmp              := cEmpTmp() + cNoPath( oTable:cName )
     
   if !lExistTable( cTmp + ".Dbf" )
      msgStop( "No existe" + cTmp + ".Dbf" )
      return .f.
   end if
   
   /*
   Si tenemos tabla antigua pasamos los campos---------------------------------
   */

   if lExistTable( cOld + ".Dbf" )

      oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

      USE ( cOld + ".Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OLD", @dbfOld ) )
      if NetErr()
         msgStop(  cOld + ".Dbf", "Error de apertura " )
      end if
      
      USE ( cTmp + ".Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TMP", @dbfTmp ) )
      if NetErr()
         msgStop( cTmp + ".Dbf", "Error de apertura" )
      end if
   
      // Preparamos los campos ---------------------------------------------------
      
      nField            := ( dbfTmp )->( fCount() )
      aField            := Array( nField )

      for i := 1 to nField
         aField[ i ]    := ( dbfTmp )->( FieldPos( ( dbfOld )->( FieldName( i ) ) ) )
      next
   
      while !( dbfOld )->( eof() )
   
         ( dbfTmp )->( dbAppend() )
      
         aEval( aField, {| nFld, i | if( nFld != 0, ( dbfTmp )->( FieldPut( nFld, ( dbfOld )->( FieldGet( i ) ) ) ), ) } )
      
         ( dbfOld )->( dbSkip() )
      
         SysRefresh()
      
      end while
      
      lCopy             := ( dbfOld )->( eof() )
   
      CLOSE ( dbfOld )
      CLOSE ( dbfTmp )

      RECOVER USING oError
         msgStop( "Imposible actualizar tablas." + CRLF + ErrorMessage( oError ) )
      END SEQUENCE

      ErrorBlock( oBlock )

   end if 
   
   // Si hay copia satisfactoria cambiamos los ficheros------------------------
   
   if lCopy
   
      fEraseTable( cOld + ".Dbf" )
      fEraseTable( cOld + ".Fpt" )
      fEraseTable( cOld + ".Cdx" )
   
      fRenameTable( cTmp + ".Dbf", cOld + ".Dbf" )
      fRenameTable( cTmp + ".Fpt", cOld + ".Fpt" )
      fRenameTable( cTmp + ".Cdx", cOld + ".Cdx" )
   
   else
   
      MsgStop( "No se actualizo el fichero " + cNoPath( cOld ) + ".Dbf" )
   
   end if
   
return ( lCopy )

//------------------------------------------------------------------------------//

METHOD ActualizaEmpresa( oMsg )

   local oTable

   if !Empty( oMsg )
      ::oMsg            := oMsg
   end if               

   // ::BuildData()

   // ::BuildEmpresa()

   // Eliminando tablas del diccionario----------------------------------------
  
   // Recargamos el diccionario de datos---------------------------------------

   ::ReLoadTables()

   // Cambiamos a CDX para actualizar la nuevas estructuras--------------------

   SetIndexToCdx()

   ::BuildData()

   ::BuildEmpresa()

   // Creamos las nuesvas estructuras------------------------------------------

   for each oTable in ::aDataTables

      ::oMsg:SetText( "Creando nueva tabla : " + oTable:cDescription )
      ::CreateTemporalTable( oTable )

      ::oMsg:SetText( "Actualizando tabla : " + oTable:cDescription )
      ::ActualizaDataTable( oTable )

   next 

   for each oTable in ::aEmpresaTables

      ::oMsg:SetText( "Creando nueva tabla : " + oTable:cDescription )
      ::CreateTemporalTable( oTable )

      ::oMsg:SetText( "Actualizando tabla : " + oTable:cDescription )
      ::ActualizaEmpresaTable( oTable )

   next 

   // Creamos las nuesvas estructuras------------------------------------------

   SetIndexToAIS()

   ::BuildData()

   ::BuildEmpresa()

   // Creamos las nuesvas estructuras------------------------------------------

   for each oTable in ::aDataTables

      ::oMsg:SetText( "Eliminado tabla del diccionario : " + oTable:cDescription )
      ::DeleteTable( oTable )

      ::oMsg:SetText( "Añadiendo tabla al diccionario de datos : " + oTable:cDescription )
      ::AddTable( oTable )

      ::oMsg:SetText( "Reindexando : " + oTable:cDescription )
      ::ReindexTable( oTable )

   next 

   for each oTable in ::aEmpresaTables

      ::oMsg:SetText( "Eliminado tabla del diccionario : " + oTable:cDescription )
      ::DeleteTable( oTable )

      ::oMsg:SetText( "Añadiendo tabla al diccionario de datos : " + oTable:cDescription )
      ::AddTable( oTable )

      ::oMsg:SetText( "Reindexando : " + oTable:cDescription )
      ::ReindexTable( oTable )

   next 

   // Recargamos el diccionario de datos---------------------------------------

   ::ReLoadTables()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD DisableTriggers()

   local cStm

   /*
   Creamos la instruccion------------------------------------------------------
   */

   cStm           := "EXECUTE PROCEDURE sp_disableTriggers( NULL, NULL, FALSE, 0 );"

RETURN ( ::ExecuteSqlStatement( cStm, "DisableTriggers" ) )

//---------------------------------------------------------------------------//

METHOD EnableTriggers()

   local cStm

   /*
   Creamos la instruccion------------------------------------------------------
   */

   cStm           := "EXECUTE PROCEDURE sp_enableTriggers( NULL, NULL, FALSE, 0 );"

RETURN ( ::ExecuteSqlStatement( cStm, "EnableTriggers" ) )

//---------------------------------------------------------------------------//

METHOD SetAplicationID( cNombreUsuario )

   local cStm

   DEFAULT cNombreUsuario := "Administrador"

   /*
   Creamos la instruccion------------------------------------------------------
   */

   cStm                    := "EXECUTE PROCEDURE sp_SetApplicationID( '" + Alltrim( cNombreUsuario ) + "' ) ;"

RETURN ( ::ExecuteSqlStatement( cStm, "SetAplicationID" ) )

//---------------------------------------------------------------------------//

METHOD ExecuteSqlStatement( cSql, cSqlStatement )

   local lOk
   local nError
   local oError
   local oBlock
   local cErrorAds

   CursorWait()

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      dbSelectArea( 0 )
   
      lOk            := ADSCreateSQLStatement( cSqlStatement, 7 )
   
      if lOk
   
         lOk         := ADSExecuteSQLDirect( cSql )
         if !lOk
            nError   := AdsGetLastError( @cErrorAds )
            msgStop( "Error : " + Str( nError) + "[" + cErrorAds + "]", 'ERROR en AdsExecuteSqlDirect' )
         endif
   
      else
   
         nError      := AdsGetLastError( @cErrorAds )
         msgStop( "Error : " + Str( nError) + "[" + cErrorAds + "]", 'ERROR en ADSCreateSQLStatement' )
   
      end if
   
      if lOk 
         AdsCacheOpenCursors( 0 )
         AdsClrCallBack()
      endif

   RECOVER USING oError
      msgStop( ErrorMessage( oError ), "ExecuteSqlStatement" )
   END SEQUENCE

   ErrorBlock( oBlock )

/*
   if Select( cSqlStatement ) > 0
      ( cSqlStatement )->( dbCloseArea() )
   endif
*/
   CursorWE()

RETURN ( lOk )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TDataTable

   DATA  cName
   DATA  cArea
   DATA  cPath
   DATA  cDataFile
   DATA  cIndexFile
   DATA  cDescription   INIT ""
   DATA  aStruct    
   DATA  lTrigger       INIT .t.
   DATA  hDefinition 
   DATA  bSyncFile   
   DATA  bCreateFile
   DATA  bCreateIndex   

   METHOD Name()        INLINE ( ::cPath + ::cArea )
   METHOD NameTable()   INLINE ( ::cArea + ".Dbf" )
   METHOD NameIndex()   INLINE ( ::cArea + ".Cdx" )

   METHOD cFileName()   INLINE ( Upper( cNoPath( ::cName ) ) )
   METHOD cAreaName()   INLINE ( if( lAIS(), ::cFileName() + ".Dbf", ::cDataFile ) )

   METHOD Say()         INLINE ( "cArea"        + ::cArea         + CRLF +;
                                 "cName"        + ::cName         + CRLF +;
                                 "cDataFile"    + ::cDataFile     + CRLF +;
                                 "cIndexFile"   + ::cIndexFile    + CRLF +;
                                 "cDescription" + ::cDescription )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TDataUser

   DATA  cName       INIT ""
   DATA  cPassword   INIT ""
   DATA  cComment    INIT ""

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

Function ApoloDDAddTable( cTableName, cTableDatabase, cTableIndex )

   local nError
   local cError
   local lAddTable   := .t.

   if !AdsExistTable( cTableName )
      if !AdsDDaddTable( cTableName, cTableDatabase, cTableIndex )
         lAddTable   := .f.
         msgInfo( "Error adding table : " + cValToChar( adsGetLastError( @cError ) ), cError )
      end if
   end if

Return ( lAddTable )

//--------------------------------------------------------------------------//

Function AdsExistTable( cTable )

   local aAdsTables

   if Empty( aAdsTables )
      aAdsTables  := AdsDirectory()
   end if

Return ( aScan( aAdsTables, {|c| Left( Upper( c ), len( c ) - 1 ) == Upper( cTable ) } ) != 0 )

//--------------------------------------------------------------------------//

Function ADSSelectSQLScript( cScript )

   local i
   local aData             := {}
   local cArea
   local lGood             := .f.

   if !Empty( cScript )

      AdsCacheOpenCursors( 0 )
      dbSelectArea( 0 )

      if !ADSCreateSQLStatement( "SQLArea", 2 ) //.or. !ADSVerifySQL( cScript )

         SQLArea->( dbCloseArea() )

         MsgStop( "AdsCreateSqlStatement() failed with error "+ cValToChar( ADSGetLastError() ) )

      else

         lGood             := ADSExecuteSQLDirect( cScript )

      endif

      if lGood

         CursorWait()

         while !( SQLArea->( eof() ) )

            if !Empty( SQLArea->( fieldGet( 1 ) ) )
               aAdd( aData, SQLArea->( fieldGet( 1 ) ) )
            end if

            SQLArea->( dbSkip() )

         end

         CursorWE()

         AdsCacheOpenCursors( 0 )
         AdsClrCallBack()

         if SQLArea->( Used() )
            SQLArea->( dbCloseArea() )
         endif

      end if

   end if

Return ( aData )

//---------------------------------------------------------------------------//

Function ADSExecuteSQLScript( cScript )

   local lGood             := .f.
   local cSqlAlias         := "SQLArea"

   if !Empty( cScript )

      AdsCacheOpenCursors( 0 )
      dbSelectArea( 0 )

      if Select( cSqlAlias ) > 0
         ( cSqlAlias )->( dbCloseArea() )
      end if 

      if !ADSCreateSQLStatement( cSqlAlias, 7 ) 

         ( cSqlAlias )->( dbCloseArea() )

         MsgStop( "AdsCreateSqlStatement() failed with error "+ cValToChar( ADSGetLastError() ) )

      else

         if !ADSVerifySQL( cScript )

            MsgStop( "ADSVerifySQL() failed with error "+ cValToChar( ADSGetLastError() ) )

         else
            
            lGood          := ADSExecuteSQLDirect( cScript )

            if !lGood

               MsgStop( "ADSExecuteSQLDirect() failed with error " + cValToChar( ADSGetLastError() ) )

            end if

         end if 

      endif

      AdsCacheOpenCursors( 0 )
      AdsClrCallBack()

      if Select( cSqlAlias ) > 0
         ( cSqlAlias )->( dbCloseArea() )
      endif

   end if

Return ( lGood )

//---------------------------------------------------------------------------//

Function ADSRunSQL( cSqlAlias, cSqlStatement, lShow )

   local lGood       := .f.
   local cOldAlias   := Alias()

   DEFAULT lShow     := .f.

   if !Empty( cSqlAlias ) .and. !Empty( cSqlStatement )

      cSqlStatement  := StrTran( cSqlStatement, ";", "" )

      dbSelectArea( 0 )

      if !AdsCreateSqlStatement( cSqlAlias, 3 )

         MsgStop( "Error AdsCreateSqlStatement()" + CRLF + "Error: " + cValtoChar( AdsGetLastError() ) )

      else
         
         if lShow
            MsgInfo( cSqlStatement, "SQLDebug")
         endif
         
         if !AdsExecuteSqlDirect( cSqlStatement )
            
            ( cSqlAlias )->( dbCloseArea() )
            
            msgStop( "Error AdsExecuteSqlDirect( " + cSqlStatement + " )" + CRLF + "Error:" + cValtoChar( AdsGetLastError() ) )

         else
            
            lGood    := .t.
         
         endif
      
      endif

      if !Empty( cOldAlias )
         dbSelectArea( cOldAlias )
      endif

   endif

RETURN lGood

//---------------------------------------------------------------------------//

CLASS TDataView

   CLASSDATA   aStatus

   CLASSDATA   hViews                        INIT {=>}
   CLASSDATA   nView                         INIT 0

   METHOD CreateView()                       INLINE   ( HSet( ::hViews, ++::nView, {=>} ), ::nView )
   METHOD DeleteView( nView )

   METHOD InfoView()                         INLINE   ( MsgStop( valtoprg( hGet( ::hViews, ::nView ) ), "Vista : " + alltrim( str( ::nView ) ) ) )

   METHOD AssertView()

   METHOD Get( cDatabase, nView )
      METHOD AddView( cDatabase, cHandle )
      METHOD GetView( cDatabase )
      METHOD OpenDataBase( cDataTable, nView )

   METHOD GetObject( cObject, nView )

   METHOD AlbaranesClientes( nView )            INLINE ( ::Get( "AlbCliT", nView ) )
      METHOD AlbaranesClientesId( nView )       INLINE ( ( ::Get( "AlbCliT", nView ) )->cSerAlb + str( ( ::Get( "AlbCliT", nView ) )->nNumAlb, 9 ) + ( ::Get( "AlbCliT", nView ) )->cSufAlb )

   METHOD AlbaranesClientesLineas( nView )      INLINE ( ::Get( "AlbCliL", nView ) )
      METHOD AlbaranesClientesLineasId( nView ) INLINE ( ( ::Get( "AlbCliL", nView ) )->cSerAlb + str( ( ::Get( "AlbCliL", nView ) )->nNumAlb, 9 ) + ( ::Get( "AlbCliL", nView ) )->cSufAlb )

   METHOD FacturasClientes( nView )             INLINE ( ::Get( "FacCliT", nView ) )
      METHOD FacturasClientesId( nView )        INLINE ( ( ::Get( "FacCliT", nView ) )->cSerie + Str( ( ::Get( "FacCliT", nView ) )->nNumFac ) + ( ::Get( "FacCliT", nView ) )->cSufFac )

   METHOD FacturasClientesLineas( nView )       INLINE ( ::Get( "FacCliL", nView ) )
      METHOD FacturasClientesLineasId( nView )  INLINE ( ( ::Get( "FacCliL", nView ) )->cSerie + Str( ( ::Get( "FacCliL", nView ) )->nNumFac ) +  ( ::Get( "FacCliL", nView ) )->cSufFac )

   METHOD FacturasClientesCobros( nView )       INLINE ( ::Get( "FacCliP", nView ) )
      METHOD FacturasClientesCobrosId( nView )  INLINE ( ( ::Get( "FacCliP", nView ) )->cSerie + Str( ( ::Get( "FacCliP", nView ) )->nNumFac ) +  ( ::Get( "FacCliP", nView ) )->cSufFac + Str( ( ::Get( "FacCliP", nView ) )->nNumRec ) )

   METHOD FacturasProveedoresCobros( nView )       INLINE ( ::Get( "FacPrvP", nView ) )
      METHOD FacturasProveedoresCobrosId( nView )  INLINE ( ( ::Get( "FacPrvP", nView ) )->cSerFac + Str( ( ::Get( "FacPrvP", nView ) )->nNumFac ) +  ( ::Get( "FacPrvP", nView ) )->cSufFac + Str( ( ::Get( "FacPrvP", nView ) )->nNumRec ) )

   METHOD FacturasRectificativas( nView )       INLINE ( ::Get( "FacRecT", nView ) )
      METHOD FacturasRectificativasId( nView )  INLINE ( ( ::Get( "FacRecT", nView ) )->cSerie + str( ( ::Get( "FacRecT", nView ) )->nNumFac, 9 ) + ( ::Get( "FacRecT", nView ) )->cSufFac )

   METHOD PedidosClientes( nView )           INLINE ( ::Get( "PedCliT", nView ) )
      METHOD PedidosClientesId( nView )      INLINE ( ( ::Get( "PedCliT", nView ) )->cSerPed + str( ( ::Get( "PedCliT", nView ) )->nNumPed, 9 ) + ( ::Get( "PedCliT", nView ) )->cSufPed )

   METHOD PedidosClientesReservas( nView )   INLINE ( ::Get( "PedCliR", nView ) )

   METHOD Clientes( nView )                  INLINE ( ::Get( "Client", nView ) )
      METHOD GruposClientes( nView )         INLINE ( ::GetObject( "GruposClientes", nView ) )

   METHOD PresupuestosClientes( nView )      INLINE ( ::Get( "PreCliT", nView ) )
      METHOD PresupuestosClientesId( nView ) INLINE ( ( ::Get( "PreCliT", nView ) )->cSerPre + str( ( ::Get( "PreCliT", nView ) )->nNumPre, 9 ) + ( ::Get( "PreCliT", nView ) )->cSufPre )

   METHOD SatClientes( nView )               INLINE ( ::Get( "SatCliT", nView ) )
      METHOD SatClientesId( nView )          INLINE ( ( ::Get( "SatCliT", nView ) )->cSerSat + str( ( ::Get( "SatCliT", nView ) )->nNumSat, 9 ) + ( ::Get( "SatCliT", nView ) )->cSufSat )

   METHOD PedidosProveedores( nView )        INLINE ( ::Get( "PedProvT", nView ) )
      METHOD PedidosProveedoresId( nView )   INLINE ( ( ::Get( "PedProvT", nView ) )->cSerPed + str( ( ::Get( "PedProvT", nView ) )->nNumPed, 9 ) + ( ::Get( "PedProvT", nView ) )->cSufPed )

   METHOD PedidosProveedoresLineas( nView )        INLINE ( ::Get( "PedProvL", nView ) )
      METHOD PedidosProveedoresLineasId( nView )   INLINE ( ( ::Get( "PedProvL", nView ) )->cSerPed + str( ( ::Get( "PedProvL", nView ) )->nNumPed, 9 ) + ( ::Get( "PedProvL", nView ) )->cSufPed )

   METHOD PedidosProveedoresIncidencias( nView )   INLINE ( ::Get( "PedPrvI", nView ) )

   METHOD PedidosProveedoresDocumentos( nView )    INLINE ( ::Get( "PedPrvD", nView ) )

   METHOD Proveedores( nView )               INLINE ( ::Get( "Provee", nView ) )
      METHOD GruposProveedores( nView )      INLINE ( ::GetObject( "GruposProveedores", nView ) )

   METHOD AlbaranesProveedores( nView )               INLINE ( ::Get( "AlbProvT", nView ) ) 
   METHOD AlbaranesProveedoresLineas( nView )         INLINE ( ::Get( "AlbProvL", nView ) )
   METHOD AlbaranesProveedoresIncidencias( nView )    INLINE ( ::Get( "AlbPrvI", nView ) )
   METHOD AlbaranesProveedoresDocumentos( nView )     INLINE ( ::Get( "AlbPrvD", nView ) )
   METHOD AlbaranesProveedoresSeries( nView )         INLINE ( ::Get( "AlbPrvS", nView ) )

   METHOD FacturasProveedores( nView )       INLINE ( ::Get( "FacPrvT", nView ) ) 
      METHOD FacturasProveedoresId( nView )  INLINE ( ( ::Get( "FacPrvT", nView ) )->cSerFac + str( ( ::Get( "FacPrvT", nView ) )->nNumFac, 9 ) + ( ::Get( "FacPrvT", nView ) )->cSufFac )

   METHOD FacturasProveedoresLineas( nView )       INLINE ( ::Get( "FacPrvL", nView ) )
      METHOD FacturasProveedoresLineasId( nView )  INLINE ( ( ::Get( "FacPrvL", nView ) )->cSerFac + str( ( ::Get( "FacPrvL", nView ) )->nNumFac, 9 ) + ( ::Get( "FacPrvL", nView ) )->cSufFac )

   METHOD FacturasProveedoresIncidencias( nView )        INLINE ( ::Get( "FacPrvI", nView ) )
      METHOD FacturasProveedoresIncidenciasId ( nView )  INLINE ( ( ::Get( "FacPrvI", nView ) )->cSerFac + str( ( ::Get( "FacPrvI", nView ) )->nNumFac, 9 ) + ( ::Get( "FacPrvI", nView ) )->cSufFac )

   METHOD FacturasProveedoresDocumentos( nView )         INLINE ( ::Get( "FacPrvD", nView ) )
      METHOD FacturasProveedoresDocumentosId( nView )    INLINE ( ( ::Get( "FacPrvD", nView ) )->cSerFac + str( ( ::Get( "FacPrvD", nView ) )->nNumFac, 9 ) + ( ::Get( "FacPrvD", nView ) )->cSufFac )

   METHOD FacturasProveedoresSeries( nView )       INLINE ( ::Get( "FacPrvS", nView ) )
      METHOD FacturasProveedoresSeriesId( nView )  INLINE ( ( ::Get( "FacPrvS", nView ) )->cSerFac + str( ( ::Get( "FacPrvS", nView ) )->nNumFac, 9 ) + ( ::Get( "FacPrvS", nView ) )->cSufFac )

   METHOD FacturasProveedoresPagos( nView )        INLINE ( ::Get( "FacPrvP", nView ) )
      METHOD FacturasProveedoresPagosId( nView )   INLINE ( ( ::Get( "FacPrvP", nView ) )->cSerFac + str( ( ::Get( "FacPrvP", nView ) )->nNumFac, 9 ) + ( ::Get( "FacPrvP", nView ) )->cSufFac )

   METHOD FacturasRectificativasProveedores( nView )        INLINE ( ::Get( "RctPrvT", nView ) )
      METHOD FacturasRectificativasProveedoresId( nView )   INLINE ( ( ::Get( "RctPrvT", nView ) )->cSerFac + str( ( ::Get( "RctPrvT", nView ) )->nNumFac, 9 ) + ( ::Get( "RctPrvT", nView ) )->cSufFac )

   METHOD FacturasRectificativasProveedoresLineas( nView )        INLINE ( ::Get( "RctPrvL", nView ) )
      METHOD FacturasRectificativasProveedoresLineasId( nView )   INLINE ( ( ::Get( "RctPrvL", nView ) )->cSerFac + str( ( ::Get( "RctPrvL", nView ) )->nNumFac, 9 ) + ( ::Get( "RctPrvL", nView ) )->cSufFac )

   METHOD FacturasRectificativasProveedoresIncidencias( nView )   INLINE ( ::Get( "RctPrvI", nView ) )

   METHOD FacturasRectificativasProveedoresDocumentos( nView )    INLINE ( ::Get( "RctPrvD", nView ) )

   METHOD FacturasRectificativasProveedoresSeries( nView )        INLINE ( ::Get( "RctPrvS", nView ) )

   METHOD PartesProduccion( nView )                               INLINE ( ::Get( "ProCab", nView ) )

   METHOD PartesProduccionMaterialProducido( nView )              INLINE ( ::Get( "ProLin", nView ) )

   METHOD PartesProduccionMaterialProduccionSeries( nView )       INLINE ( ::Get( "ProSer", nView ) )

   METHOD PartesProduccionMateriaPrima( nView )                   INLINE ( ::Get( "ProMat", nView ) )

   METHOD PartesProduccionMaquinaria( nView )                     INLINE ( ::Get( "ProMaq", nView ) )  

   METHOD PartesProduccionOperarios( nView )                      INLINE ( ::Get( "ProPer", nView ) )

   METHOD BancosProveedores( nView )         INLINE ( ::Get( "PrvBnc", nView ) )

   METHOD TiposIva( nView )                  INLINE ( ::Get( "TIva", nView ) )

   METHOD ProveedorArticulo( nView )         INLINE ( ::Get( "ProvArt", nView ) )

   METHOD CodigoBarrasArticulo( nView )      INLINE ( ::Get( "ArtCodebar", nView ) )

   METHOD Articulos( nView )                 INLINE ( ::Get( "Articulo", nView ) )

   METHOD Familias( nView )                  INLINE ( ::Get( "Familias", nView ) )

   METHOD Kit( nView )                       INLINE ( ::Get( "ArtKit", nView ) )

   METHOD FormasPago( nView )                INLINE ( ::Get( "FPago", nView ) )

   METHOD ArticuloPrecioPropiedades( nView ) INLINE ( ::Get( "ArtDiv", nView ) )

   METHOD Divisas( nView )                   INLINE ( ::Get( "Divisas", nView ) )

   METHOD Cajas( nView )                     INLINE ( ::Get( "Cajas", nView ) )

   METHOD TipoIncidencia( nView )            INLINE ( ::Get( "TipInci", nView ) )

   METHOD Propiedades( nView )               INLINE ( ::Get( "Pro", nView ) )
      METHOD PropiedadesLineas( nView )      INLINE ( ::Get( "TblPro", nView ) )

   METHOD Almacen( nView )                   INLINE ( ::Get( "Almacen", nView ) )

   METHOD Documentos( nView )                INLINE ( ::Get( "RDocumen", nView ) )

   METHOD Usuarios( nView )                  INLINE ( ::Get( "Users", nView ) )

   METHOD UbicacionLineas( nView )           INLINE ( ::Get( "UbiCal", nView ) )

   METHOD Delegaciones( nView )              INLINE ( ::Get( "Delega", nView ) )

   METHOD Contadores( nView )                INLINE ( ::Get( "NCount", nView ) )

   METHOD Empresa( nView )                   INLINE ( ::Get( "Empresa", nView ) )

   METHOD Atipicas( nView )                  INLINE ( ::Get( "CliAtp", nView ) )

   METHOD Contadores( nView )                INLINE ( ::Get( "NCount", nView ) )
   METHOD Documentos( nView )                INLINE ( ::Get( "RDocumen", nView ) )

   METHOD Lock( cDatabase, nView )           INLINE ( dbLock( ::Get( cDatabase, nView ) ) )
   METHOD UnLock( cDatabase, nView )         INLINE ( ( ::Get( cDatabase, nView ) )->( dbUnLock() ) ) 

   METHOD GetStatus( cDatabase, nView )      INLINE ( ::aStatus := aGetStatus( ::Get( cDatabase, nView ) ) )
   METHOD GetInitStatus( cDatabase, nView )  INLINE ( ::aStatus := aGetStatus( ::Get( cDatabase, nView ), .t. ) )
   METHOD SetStatus( cDatabase, nView )      INLINE ( SetStatus( ::Get( cDatabase, nView ), ::aStatus ) ) 

   METHOD SeekInOrd( cDatabase, nView, uValue, cOrder ) ;
                                             INLINE ( dbSeekInOrd( uValue, cOrder, ::Get( cDatabase, nView ) ) )
   METHOD Eof( cDatabase, nView )            INLINE ( ( ::Get( cDatabase, nView ) )->( eof() ) )

   METHOD Top( cDatabase, nView )            INLINE ( dbFirst( ::Get( cDatabase, nView ) ) )
   METHOD Bottom( cDatabase, nView )         INLINE ( dbLast( ::Get( cDatabase, nView ) ) )

   METHOD OpenObject( oDataTable )

ENDCLASS

   //---------------------------------------------------------------------------//

   METHOD AssertView( nView ) CLASS TDataView

      DEFAULT nView  := ::nView

      if empty( nView )
         msgStop( "No hay vistas disponibles." )
         Return ( .f. )
      end if

      if !hHasKey( ::hViews, nView )
         msgStop( "Vista " + Alltrim( Str( nView ) ) + " no encontrada." )
         Return ( .f. )
      end if 

   Return ( .t. )

//---------------------------------------------------------------------------//

   METHOD DeleteView( nView ) CLASS TDataView

      local o
      local hView

      if ::AssertView( nView )

         hView          := hGet( ::hViews, nView )
         if hb_ishash( hView ) 

            for each o in hView
               do case
                  case isChar( o:value() )
                     if( ( o:value() )->( used() ), ( o:value() )->( dbCloseArea() ), )
                  case isObject( o:value() )
                     o:value():CloseService()
               end case
            next 

         end if 

         HDel( ::hViews, nView )
         
      end if 

   Return ( Self )

//---------------------------------------------------------------------------//

   METHOD Get( cDatabase, nView ) CLASS TDataView

      local cHandle  := ::GetView( cDatabase, nView )

      if empty( cHandle )
         ::OpenDatabase( cDatabase, nView )
      end if

   RETURN ( cHandle )

   //---------------------------------------------------------------------------//

   METHOD GetObject( cName, nView ) CLASS TDataView

      local cHandle  := ::GetView( cName, nView )

      if empty( cHandle )
         ::OpenObject( cName, nView )
      end if

   Return ( cHandle )

//---------------------------------------------------------------------------//

   METHOD GetView( cDatabase, nView ) CLASS TDataView

      local hView
      local cHandle

      if ::AssertView( nView )

         hView          := hGet( ::hViews, nView )
         if hb_ishash( hView ) 
            if hHasKey( hView, Upper( cDatabase ) )
               cHandle  := hGet( hView, Upper( cDatabase ) )
            end if 
         end if 

      end if 

   RETURN ( cHandle )

   //---------------------------------------------------------------------------//

   METHOD AddView( cDatabase, cHandle, nView ) CLASS TDataView

      local hView

      if ::AssertView( nView )

         hView    := hGet( ::hViews, nView )
         if hb_ishash( hView )
            hSet( hView, Upper( cDatabase ), cHandle )
         end if 

      end if  

   RETURN ( Self )

   //---------------------------------------------------------------------------//

   METHOD OpenDataBase( cDataTable, nView ) CLASS TDataView

      local dbf
      local lOpen
      local oDataTable

      oDataTable        := TDataCenter():ScanDataTable( cDataTable )

      if !empty( oDataTable )

         dbUseArea( .t., ( cDriver() ), ( oDataTable:cAreaName() ), ( cCheckArea( oDataTable:cArea, @dbf ) ), .t., .f. ) // oDataTable:cFileName()
         if( !lAIS(), ordListAdd( ( oDataTable:cIndexFile ) ), ordSetFocus( 1 ) )

         lOpen          := !neterr()
         if lOpen
            ::AddView( oDataTable:cArea, dbf, nView )
         end if 

      else 

         msgStop( "No puedo encontrar la tabla " + cDataTable )   

         Return ( .f. )

      end if

   Return ( .t. )

//---------------------------------------------------------------------------//

   METHOD OpenObject( cObject, nView ) CLASS TDataView

      local lOpen
      local oObject     := TDataCenter():ScanObject( cObject )

      if !empty( oObject )
         lOpen          := oObject:OpenService()

         if lOpen
            ::AddView( cObject, oObject, nView )
         end if 

      else 

         msgStop( "No puedo encontrar el objeto " + cObject )   

         Return ( .f. )

      end if

   Return ( .t. )

//---------------------------------------------------------------------------//
/*
   METHOD OpenTDbf( cDataTable, nView ) CLASS TDataView

      local oDbf
      local lOpen
      local oDataTable

      oDataTable        := TDataCenter():ScanDataTable( cDataTable )

      if !empty( oDataTable )

         DATABASE NEW oDbf PATH ( oDataTable:cPath ) FILE ( oDataTable:NameTable() ) VIA ( cDriver() ) SHARED INDEX ( oDataTable:NameIndex() )
         lOpen          := !neterr()
         if lOpen
            ::AddView( oDataTable:cArea, oDbf, nView )
         end if 

      else 

         msgStop( "No puedo encontrar la tabla " + cDataTable )   

         Return ( .f. )

      end if

   Return ( .t. )
*/

//---------------------------------------------------------------------------//




