#include "FiveWin.Ch"
#include "Factu.ch" 
#include "DBStruct.ch"
#include "Ads.ch"
#include "Xbrowse.ch"
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TDataCenter

   CLASSDATA   oInstance

   CLASSDATA   cDataDictionaryComment     INIT "Gestool ADS data dictionary"

   CLASSDATA   aDDTables                  INIT {}
   CLASSDATA   aDDTriggers                INIT {}

   CLASSDATA   lAdsConnection
   CLASSDATA   hAdsConnection

   CLASSDATA   aDataTables                INIT {}
   CLASSDATA   aEmpresaTables             INIT {}
   CLASSDATA   aEmpresaObject             INIT {} 

   CLASSDATA   aDataTmp                   INIT {}

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
   DATA        cMsg                       INIT ""

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
   DATA        lSeeders                   INIT .f.

   DATA        aLgcIndices                INIT { .t., .t., .t. }
   DATA        aChkIndices                INIT Array( 3 )

   DATA        aProgress                  INIT Array( 3 )
   DATA        nProgress                  INIT { 0, 0, 0 }

   DATA        cMsg                       INIT ""
   DATA        oMsg

   METHOD getDataDictionaryFile()         INLINE ( cAdsIp() + cPath( cAdsData() ) + ( getSinglePathADS() ) + cAdsFile() )
   METHOD getDataDictionaryConnection()   INLINE ( cAdsIp() + if( !empty( cAdsPort() ), ":" + cAdsPort(), "" ) + cPath( cAdsData() ) + ( getSinglePathADS() ) + cAdsFile() )

   METHOD CreateDataDictionary()
   METHOD ConnectDataDictionary()

   METHOD CreateDataUser( oDataUser )

   METHOD CreateDataTable()
   METHOD addEmpresaTablesToDataDictionary()

   METHOD ReLoadTables()                  INLINE ( ::aDDTables := AdsDirectory() )

   METHOD CreateDataTrigger()
   METHOD CreateEmpresaTrigger()

   METHOD isTableInDataDictionary( oTable )
   METHOD isTriggerInDataDictionary( oTable )

   METHOD CreateTriggerUpdate( oTable )
   METHOD CreateColumnTriggerUpdate( oTable, cTrigger )

   METHOD CreateTriggerInsert( oTable )
   METHOD CreateColumnTriggerInsert( oTable, cTrigger )

   METHOD CreateTriggerDelete( oTable )
   METHOD CreateColumnTriggerDelete( oTable, cTrigger )

   METHOD addTableToDataDictionary( oTable )
   METHOD AddTableName( cTableName )
   
   METHOD AddTrigger( oTable, cAction )

   METHOD deleteEmpresaTablesFromDataDictionary()
   METHOD deleteTableFromDataDictionary( oTable )  
   METHOD deleteTableNameFromDataDictionary( cTableName )         
   
   METHOD deleteAllTableFromDataDictionary()

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

   METHOD CloseArea( cArea )              INLINE ( if( select( cArea ) > 0, ( cArea )->( dbclosearea() ), ), dbselectarea( 0 ), .t. )

   METHOD CreateAllLocksTablesUsers()
   METHOD DeleteAllLocksTablesUsers()
   METHOD GetAllLocksTablesUsers()
   METHOD GetAllTables()
   METHOD CloseAllLocksTablesUsers()      INLINE ( ::CloseArea( "AllLocks" ) )

   METHOD configDatabaseCDXLocal()
   METHOD dialogEmpresas()
   METHOD loadEmpresas()

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

   METHOD SqlCreateIndex( tableName, indexName, tagName, Expression, Condition )

   METHOD ExecuteSqlStatement( cSql, cSqlStatement )
   METHOD ExecuteSqlDirect( cSql )
   
   METHOD selectSATFromClient( cCodigoCliente )
      METHOD treeProductFromSAT()

   METHOD selectSATFromArticulo( cCodigoArticulo )

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
   METHOD ScanDataTableInView()
   METHOD ScanDataArea( cArea )
   METHOD ScanDataTmp( cDataTable )
   METHOD ScanObject()

   METHOD getIdBlock( cDataTable )
   METHOD getDictionary( cDataTable )
   METHOD getDictionaryFromArea( cArea )
   METHOD getDeFaultValue( cDataTable )  
   METHOD getIndexFromArea( cArea )

   METHOD DatosName( cDatabase )             INLINE   ( upper( cPathDatos() + cDatabase ) )
   METHOD EmpresaName( cDatabase )           INLINE   ( upper( cPathEmpresa() + cDatabase ) )

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

   METHOD ConvertDatosToSQL()
   METHOD ConvertEmpresaToSQL()
   METHOD MigrateEmpresaToSQL()

END CLASS

//---------------------------------------------------------------------------//

METHOD CheckData() CLASS TDataCenter

   if lAIS()
      aeval( ::aDataTables, {|oTable| ::AddTableToDataDictionary( oTable, .t. ) } )
   end if 

RETURN ( Self )  

//---------------------------------------------------------------------------//

METHOD CheckEmpresa() CLASS TDataCenter

   if lAIS()
      aeval( ::aEmpresaTables, {|oTable| ::AddTableToDataDictionary( oTable, .t. ) } )
   end if

RETURN ( Self )  

//---------------------------------------------------------------------------//

METHOD oFacCliP() CLASS TDataCenter

   local cFilter
   local oFacCliP

   DATABASE NEW oFacCliP PATH ( cPatEmp() ) FILE "FacCliP.Dbf" VIA ( cDriver() ) SHARED INDEX "FacCliP.Cdx"

Return ( oFacCliP )   

//---------------------------------------------------------------------------//

METHOD OpenFacCliP( dbf ) CLASS TDataCenter

   local cFilter

   USE ( cPatEmp() + "FacCliP.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIP", @dbf ) )
   SET ADSINDEX TO ( cPatEmp() + "FacCliP.Cdx" ) ADDITIVE

Return ( !neterr() )   

//---------------------------------------------------------------------------//

METHOD oAlbCliT() CLASS TDataCenter

   local cFilter
   local oAlbCliT

   DATABASE NEW oAlbCliT PATH ( cPatEmp() ) FILE "AlbCliT.Dbf" VIA ( cDriver() ) SHARED INDEX "AlbCliT.Cdx"

Return ( oAlbCliT )   

//---------------------------------------------------------------------------//

METHOD OpenAlbCliT( dbf ) CLASS TDataCenter

   local cFilter

   USE ( cPatEmp() + "AlbCliT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AlbCliT", @dbf ) )
   SET ADSINDEX TO ( cPatEmp() + "AlbCliT.Cdx" ) ADDITIVE

Return ( !neterr() )   

   //---------------------------------------------------------------------------//

METHOD oPedCliT() CLASS TDataCenter

   local cFilter
   local oPedCliT

   DATABASE NEW oPedCliT PATH ( cPatEmp() ) FILE "PedCliT.Dbf" VIA ( cDriver() ) SHARED INDEX "PedCliT.Cdx"

Return ( oPedCliT )   

//---------------------------------------------------------------------------//

METHOD OpenPedCliT( dbf ) CLASS TDataCenter

	USE ( cPatEmp() + "PedCliT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "PedCliT", @dbf ) )
	SET ADSINDEX TO ( cPatEmp() + "PedCliT.Cdx" ) ADDITIVE

Return ( !neterr() )   

//---------------------------------------------------------------------------//

METHOD oSatCliT() CLASS TDataCenter

	local cFilter
	local oSatCliT

	DATABASE NEW oSatCliT PATH ( cPatEmp() ) FILE "SatCliT.Dbf" VIA ( cDriver() ) SHARED INDEX "SatCliT.Cdx"

	/*if lAIS() .and. !oUser():lAdministrador()

		cFilter     := "Field->cSufSat == '" + oUser():cDelegacion() + "' .and. Field->cCodCaj == '" + oUser():cCaja() + "'"
		if oUser():lFiltroVentas()         
		   cFilter  += " .and. Field->cCodUsr == '" + oUser():cCodigo() + "'"
		end if 

		( oSatCliT:cAlias )->( AdsSetAOF( cFilter ) )

	end if*/

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

         /*if lAIS() .and. !oUser():lAdministrador()
      
            cFilter     := "Field->cSufSat == '" + oUser():cDelegacion() + "' .and. Field->cCodCaj == '" + oUser():cCaja() + "'"
            if oUser():lFiltroVentas()         
               cFilter  += " .and. Field->cCodUsr == '" + oUser():cCodigo() + "'"
            end if 

            ( dbf )->( AdsSetAOF( cFilter ) )

         end if*/

      end if 

      Return ( lOpen )   

//---------------------------------------------------------------------------//

METHOD oPreCliT() CLASS TDataCenter

	local cFilter
	local oPreCliT

	DATABASE NEW oPreCliT PATH ( cPatEmp() ) FILE "PreCliT.Dbf" VIA ( cDriver() ) SHARED INDEX "PreCliT.Cdx"

	/*if lAIS() .and. !oUser():lAdministrador()

		cFilter     := "Field->cSufPre == '" + oUser():cDelegacion() + "' .and. Field->cCodCaj == '" + oUser():cCaja() + "'"
		if oUser():lFiltroVentas()         
		   cFilter  += " .and. Field->cCodUsr == '" + oUser():cCodigo() + "'"
		end if 

		( oPreCliT:cAlias )->( AdsSetAOF( cFilter ) )

	end if*/

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

		/*if lAIS() .and. !oUser():lAdministrador()

		cFilter     := "Field->cSufPre == '" + oUser():cDelegacion() + "' .and. Field->cCodCaj == '" + oUser():cCaja() + "'"
		if oUser():lFiltroVentas()         
		   cFilter  += " .and. Field->cCodUsr == '" + oUser():cCodigo() + "'"
		end if 

		( dbf )->( AdsSetAOF( cFilter ) )

		end if*/

	end if 

Return ( lOpen )   

//---------------------------------------------------------------------------//

METHOD oCnfFlt() CLASS TDataCenter

	local oCnfFlt

	DATABASE NEW oCnfFlt PATH ( cPatDat() ) FILE "CnfFlt.Dbf" VIA ( cDriver() ) SHARED INDEX "CnfFlt.Cdx"

Return ( oCnfFlt )   

//---------------------------------------------------------------------------//

METHOD oProCab( cPath, cDriver ) CLASS TDataCenter

	local cFilter
	local oProCab

   DEFAULT cPath     := cPatEmp()
   DEFAULT cDriver   := cDriver()

	DATABASE NEW oProCab PATH ( cPath ) FILE "ProCab.Dbf" VIA ( cDriver ) SHARED INDEX "ProCab.Cdx"

	 if lAIS() .and. !oUser():lAdministrador()

	    cFilter     := "Field->cSufOrd == '" + oUser():cDelegacion() 

	    ( oProCab:cAlias )->( AdsSetAOF( cFilter ) )

	 end if

Return ( oProCab )   

//---------------------------------------------------------------------------//

METHOD oProLin( cPath, cDriver ) CLASS TDataCenter

    local cFilter
    local oProLin

    DEFAULT cPath    := cPatEmp()
    DEFAULT cDriver  := cDriver()

    DATABASE NEW oProLin PATH ( cPath ) FILE "ProLin.Dbf" VIA ( cDriver ) SHARED INDEX "ProLin.Cdx"

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

   dbcloseall()

   if getSQLDatabase():ConnectWithoutDataBase()
      SQLMigrations():run()
   else 
      msgStop( "No se ha podido conectar a la base de datos MySQL" + CRLF + getSQLDatabase():sayConexionInfo() )
      RETURN ( nil )
   end if

   TstEmpresa()

   TstDivisas()
   
   TstCajas()
 
   ::configDatabaseCDXLocal()

   ::loadEmpresas()

   ::dialogEmpresas()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD configDatabaseCDXLocal()

   setIndexToCdx()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD loadEmpresas()

   local dbfEmp

   ::aEmpresas       := {}

   USE ( cPatDat() + "Empresa.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "EMPRESA", @dbfEmp ) )

   ( dbfEmp )->( dbgotop() )
   while !( dbfEmp )->( eof() )
      if !( dbfEmp )->lGrupo
         aAdd( ::aEmpresas, { ( dbfEmp )->CodEmp, ( dbfEmp )->cNombre, ( dbfEmp )->lGrupo, .f., .f., .t. } )
      end if 
      ( dbfEmp )->( dbskip() )
   end while

   ( dbfEmp )->( dbclosearea() )

RETURN ( Self )   

//---------------------------------------------------------------------------//

METHOD dialogEmpresas()

   if Empty( ::aEmpresas )
      msgStop( "No hay empresas que procesar" )
      Return ( self )
   end if

   DEFINE DIALOG ::oDlg RESOURCE "AdsAdmin" TITLE "Creación de diccionario de datos para " + ::getDataDictionaryFile()

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
      :SetCheck( { "gc_check_12", "gc_delete_12" } )
   end with 

   with object ( ::oBrwEmpresas:AddCol() )
      :cHeader          := "Ac. Actualizada"
      :bStrData         := {|| "" }
      :nWidth           := 20
      :bEditValue       := {|| ::aEmpresas[ ::oBrwEmpresas:nArrayAt, 4 ] }
      :SetCheck( { "gc_check_12", "gc_delete_12" } )
   end with 

   with object ( ::oBrwEmpresas:AddCol() )
      :cHeader          := "Pr. Procesada"
      :bStrData         := {|| "" }
      :nWidth           := 20
      :bEditValue       := {|| ::aEmpresas[ ::oBrwEmpresas:nArrayAt, 5 ] }
      :SetCheck( { "gc_check_12", "gc_delete_12" } )
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

   ::oMtrActualiza      := TApoloMeter():ReDefine( 500, { | u | if( pCount() == 0, ::nMtrActualiza, ::nMtrActualiza := u ) }, 10, ::oDlg, .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )

   ::oMtrDiccionario    := TApoloMeter():ReDefine( 510, { | u | if( pCount() == 0, ::nMtrDiccionario, ::nMtrDiccionario := u ) }, 10, ::oDlg, .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )

   REDEFINE CHECKBOX    ::lActualizaBaseDatos ;
      ID                600 ;
      OF                ::oDlg

   REDEFINE CHECKBOX    ::lSeeders ;
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

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD StartAdministratorTask()

   local aEmpresa
   local oSeeder

   ::lValidDlg       := .f.

   ::oBtnOk:Disable()
   ::oBntCancel:Disable()

   ::oMsg:SetText( "Iniciando proceso..." )

   if !empty( ::oMtrActualiza )
   	::oMtrActualiza:SetTotal( len( ::aEmpresas ) )
   end if 
   
   if !empty( ::oMtrDiccionario )
	   ::oMtrDiccionario:SetTotal( 5 )
	end if 

   if ::lSeeders
      oSeeder  := Seeders():New( ::oMsg )
   end if

   // Alteracion de tablas de SQLite------------------------------------------

   // ::AlterTableSQLite()

   // Conversion de tablas a SQLite-------------------------------------------

   // ::ConvertDatosToSQL()
   
   // Recorremos el array de las empresas par actualizarlas--------------------

   if ::lActualizaBaseDatos

      ::oBrwEmpresas:GoTop()

      for each aEmpresa in ::aEmpresas

         if aEmpresa[ 6 ]

            ::oMsg:SetText( "Actualizando empresa " + Rtrim( aEmpresa[ 1 ] ) + " - " + Rtrim( aEmpresa[ 2 ] ) )

            if !empty( ::oMtrActualiza )
            	::oMtrActualiza:Set( hb_EnumIndex() )
            end if

            selectEmpresa( aEmpresa[ 1 ] )

            lActualiza( aEmpresa[ 1 ], nil, .t., aEmpresa[ 2 ], .f. ) 

            aEmpresa[ 4 ]      := .t.

            ::ConvertEmpresaToSQL()

         end if

         ::oBrwEmpresas:GoDown()
         ::oBrwEmpresas:Refresh()

      next

   end if 
   
   if !empty(::oMtrDiccionario)
   	::oMtrDiccionario:Set( 1 )
   end if

   // Conectamos de nuevo con ADS------------------------------------------------

   lCdx( .f. )
   lAIS( .t. )

   ::oMsg:SetText( "Comprabamos la existencia de la base de datos" )

   ::CreateDataDictionary()

   ::oMsg:SetText( "Intentando conectar con la base de datos" )

   if ::ConnectDataDictionary()

      if ::lSeeders 

         oSeeder:runSeederDatos()

      else 
     
         ::oMsg:SetText( "Eliminando tablas anteriores de diccionario de datos" )
         
         ::deleteAllTableFromDataDictionary()
         
         ::oMsg:SetText( "Creando árbol de tablas de datos generales" )

         ::BuildData()

         ::CreateDataTable()

      end if

      // Recorremos el array de las empresas par actualizarlas--------------------

      ::oBrwEmpresas:GoTop()

      for each aEmpresa in ::aEmpresas

         if aEmpresa[ 6 ]

            if ::lSeeders 

               setEmpresa( aEmpresa[ 1 ] )

               oSeeder:runSeederEmpresa()
            
            else 

               ::Syncronize()

               ::oMsg:SetText( "Creando diccionario de empresa " + Rtrim( aEmpresa[ 1 ] ) + " - " + Rtrim( aEmpresa[ 2 ] ) )

               if !empty( ::oMtrActualiza )
               	::oMtrActualiza:set( hb_enumindex() )
               end if 

               setEmpresa( aEmpresa[ 1 ] )

               ::BuildEmpresa()  
                  
               ::addEmpresaTablesToDataDictionary()

               ::Reindex()

               ::MigrateEmpresaToSQL()

            end if

            aEmpresa[ 5 ]   := .t.

         end if

         ::oBrwEmpresas:GoDown()
         ::oBrwEmpresas:Refresh()

      next

      if !empty(::oMtrDiccionario)
     		::oMtrDiccionario:Set( 2 )
     	end if 

      // Creamos las tablas de operacioens-------------------------------------

      // ::oMsg:SetText( "Creando tablas de operaciones" )

      // ::CreateOperationLogTable()

      // ::CreateColumnLogTable()

      // ::CreateAllLocksTablesUsers() 
      
      if !empty(::oMtrDiccionario)
	      ::oMtrDiccionario:Set( 3 )
	   end if

      // Creamos los triggers de los datos----------------------------------------

      ::oMsg:SetText( "Creando triggers de datos" )

      ::CreateDataTrigger()

      if !empty(::oMtrDiccionario)
	      ::oMtrDiccionario:Set( 4 )
	   end if

      // Creamos los triggers de las empresas-------------------------------------

      ::oMsg:SetText( "Creando triggers de empresa" )

      ::CreateEmpresaTrigger()

      if !empty(::oMtrDiccionario)
	      ::oMtrDiccionario:Set( 5 )
	   end if

   end if

   // Saliendo--------------------------------------------------------------------

   ::lValidDlg       := .t.

   MsgInfo( "Proceso finalizado con exito" )

   ::oDlg:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CreateDataDictionary()

   if file( ::getDataDictionaryFile() )
      Return ( Self )
   end if 

   if msgYesNo( "La base de datos " + ::getDataDictionaryFile() + " no existe, ¿desea crearla?")

      AdsDDCreate( ::getDataDictionaryFile(), , ::cDataDictionaryComment )

      AdsDDSetDatabaseProperty( ADS_DD_ENABLE_INTERNET, .t. )

   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ConnectDataDictionary()

   local cError

   ::lAdsConnection     := AdsConnect60( ::getDataDictionaryConnection(), nAdsServer(), "ADSSYS", "", , @::hAdsConnection )

   if !::lAdsConnection

      adsGetLastError( @cError )

      msgStop( cError, "Error connect data dictionary " + ::getDataDictionaryConnection() )

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
      ::AddTableToDataDictionary( oTable )
   next

   ::ReLoadTables()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ScanDataTableInView( cDataTable, nView )

   local oDataTable  := ::ScanDataTable( cDataTable )

   if !empty( oDataTable )
      oDataTable:setAlias( D():get( cDataTable, nView ) )    
   end if 

RETURN ( oDataTable )

//---------------------------------------------------------------------------//

METHOD ScanDataTable( cDataTable ) CLASS TDataCenter

   local nScan
   local cDataName

   cDataTable        := cNoBrackets( cDataTable )

   cDataName         := ::DatosName( cDataTable )

   nScan             := aScan( ::aDataTables, {|o| o:getName() == cDataName } )   
   if nScan != 0
      Return ( ::aDataTables[ nScan ] )
   end if 

   cDataName         := ::EmpresaName( cDataTable )

   nScan             := aScan( ::aEmpresaTables, {|o| o:getName() == cDataName } )   
   if nScan != 0
      Return ( ::aEmpresaTables[ nScan ] )
   end if 

Return ( nil )

//---------------------------------------------------------------------------//

METHOD ScanDataArea( cArea ) CLASS TDataCenter

   local nScan

   nScan       := aScan( ::aDataTables, {|o| o:cArea == cArea } )   
   if nScan != 0
      Return ( ::aDataTables[ nScan ] )
   end if 

   if nScan == 0
      nScan    := aScan( ::aEmpresaTables, {|o| o:cArea == cArea } )   
      if nScan != 0
         Return ( ::aEmpresaTables[ nScan ] )
      end if 
   end if
 
Return ( nil )

//---------------------------------------------------------------------------//

METHOD ScanDataTmp( cDataTable ) CLASS TDataCenter

   local nScan

   nScan    := aScan( ::aDataTmp, {|o| o:cFileName() == ::DatosName( cDataTable ) } )   
   if nScan != 0
      Return ( ::aDataTmp[ nScan ] )
   end if 

Return ( nil )

//---------------------------------------------------------------------------//

METHOD getIdBlock( cDataTable )

   local bId
   local oTable

   oTable         := ::ScanDataTable( cDataTable )
   if !empty( oTable )
      bId         := oTable:bId 
   end if 

Return ( bId )

//---------------------------------------------------------------------------//

METHOD getDictionary( cDataTable )

   local aDictionary
   local oTable

   oTable            := ::ScanDataTable( cDataTable )
   if !empty( oTable )
      aDictionary    := oTable:aDictionary 
   end if 

Return ( aDictionary )

//---------------------------------------------------------------------------//

METHOD getDictionaryFromArea( cArea )

   local oTable
   local aDictionary

   oTable            := ::ScanDataArea( cArea )
   if !empty( oTable )
      aDictionary    := oTable:aDictionary 
   end if 

Return ( aDictionary )

//---------------------------------------------------------------------------//

METHOD getIndexFromArea( cArea )

   local oTable
   local hIndex

   oTable            := ::ScanDataArea( cArea )
   if !empty( oTable )
      hIndex         := oTable:hIndex 
   end if 

Return ( hIndex )

//---------------------------------------------------------------------------//

METHOD getDefaultValue( cDataTable )

   local oTable
   local aDefaultValue

   oTable            := ::ScanDataTable( cDataTable )
   if !empty( oTable )
      aDefaultValue  := oTable:aDefaultValue 
   end if 

Return ( aDefaultValue )

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

   if !empty( ::oMtrActualiza )
   	::oMtrActualiza:SetTotal( len( ::aDataTables ) )
   end if 

   for each oTable in ::aDataTables

      if !empty( ::oMtrActualiza )
      	::oMtrActualiza:Set( hb_EnumIndex() )
      end if 

      if oTable:lTrigger
         ::AddTrigger( oTable )
      end if

   next

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD addEmpresaTablesToDataDictionary( lSilent )

   local oTable

   for each oTable in ::aEmpresaTables
      ::addTableToDataDictionary( oTable, lSilent )
   next

   ::ReLoadTables()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD deleteEmpresaTablesFromDataDictionary()

   local oTable

   for each oTable in ::aEmpresaTables
      ::deleteTableFromDataDictionary( oTable )
   next

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CreateEmpresaTrigger()

   local oTable

   if !empty( ::oMtrActualiza )
   	::oMtrActualiza:SetTotal( len( ::aEmpresaTables ) )
   end if 

   for each oTable in ::aEmpresaTables

   	if !empty( ::oMtrActualiza )
   	   ::oMtrActualiza:Set( hb_EnumIndex() )
   	end if 

      if oTable:lTrigger
         ::AddTrigger( oTable )
      end if

   next

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD isTableInDataDictionary( uTable )

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

METHOD deleteTableFromDataDictionary( oTable )

   local nScan

   nScan             := aScan( ::aDDTables, oTable:cName )
   if nScan != 0
      aDel( ::aDDTables, nScan, .t. )
   end if

Return ( AdsDDRemoveTable( Upper( oTable:cName ) ) )

//---------------------------------------------------------------------------//

METHOD deleteTableNameFromDataDictionary( cTableName )

   local oTable

   oTable         := ::ScanDataTable( cTableName )

   if !empty( oTable )
      RETURN ::deleteTableFromDataDictionary( oTable ) 
   end if 

RETURN ( .f. )

//---------------------------------------------------------------------------//

METHOD DeleteAllTableFromDataDictionary()

   if Empty( ::aDDTables )
      ::aDDTables    := AdsDirectory()
   end if

   aEval( ::aDDTables, {|c| AdsDDRemoveTable( Left( Upper( c ), len( c ) - 1 ) ) } )

   ::ReLoadTables()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD isTriggerInDataDictionary( oTable )

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

      if ( n < 100 ) .and. ( Table->( fieldType( n ) ) != "M" ) 
         cTrigger += 'IF ( @co."' + Table->( FieldName( n ) ) + '" <> @cn."' + Table->( FieldName( n ) ) + '" )' + CRLF
         cTrigger +=  'THEN' + CRLF
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

   ::ExecuteSqlStatement( cStm, "AllLocks" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD GetAllTables( ctext )

  local cStm

  DEFAULT cText := ""

  /*
  Creamos la instruccion------------------------------------------------------
  */

  cStm           := "EXECUTE PROCEDURE sp_mgGetAllTables();"

  ::ExecuteSqlStatement( cStm, "GetAllTables" )

  ( "GetAllTables" )->( browse( cText ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addTableToDataDictionary( oTable, lSilent )

   local cError
   local lAddTable      := .t.

   DEFAULT lSilent      := .f.

   if !::isTableInDataDictionary( oTable )

      if file( oTable:cDataFile ) .and. file( oTable:cIndexFile )

         if !AdsDDaddTable( oTable:cName, oTable:cFullAdsDataFile, oTable:cFullAdsIndexFile )

            lAddTable   := .f.

            msgStop( "Descripción de error " + cValToChar( adsGetLastError( @cError ) ) + CRLF + ;
                     oTable:Say(),;
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
         msgStop( "La tabla " + ( oTable:cDataFile ) + " ya existe en el diccionario de datos." )
      end if

   end if

Return ( lAddTable )

//---------------------------------------------------------------------------//

METHOD AddTableName( cTableName )

   local oTable

   oTable         := ::ScanDataTable( cTableName )

   if !empty( oTable )
      RETURN ::AddTableToDataDictionary( oTable ) 
   end if 

Return ( .f. )

//---------------------------------------------------------------------------//

METHOD AddTrigger( oTable )

   ::CreateTriggerInsert( oTable )
   ::CreateTriggerUpdate( oTable )
   ::CreateTriggerDelete( oTable )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD BuildData()

   local oDataTable

   ::aDataTables           := {}

   oDataTable              := TDataTable():New( "Users", cPathDatos() )
   oDatatable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:cDataFile    := cPatDat( .t. ) + "Users.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "Users.Cdx"
   oDataTable:cDescription := "Usuarios"
   oDataTable:aStruct      := aItmUsuario()
   oDataTable:bCreateFile  := {| cPath | mkUsuario( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxUsuario( cPath ) }
   oDataTable:bSyncFile    := {| cPath | synUsuario( cPath ) }
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable():New( "Mapas", cPathDatos() )
   oDatatable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:cDataFile    := cPatDat( .t. ) + "Mapas.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "Mapas.Cdx"
   oDataTable:cDescription := "Mapas de usuarios"
   oDataTable:aStruct      := aItmMapaUsuario()  
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable():New( "Cajas", cPathDatos() )
   oDatatable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:cDataFile    := cPatDat( .t. ) + "Cajas.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "Cajas.Cdx"
   oDataTable:cDescription := "Cajas"
   oDataTable:aStruct      := aItmCaja()
   oDataTable:bCreateFile  := {| cPath | mkCajas( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxCajas( cPath ) }
   oDataTable:bSyncFile    := {|| synCajas( cPathDatos() ) }
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable():New( "CajasL", cPathDatos() )
   oDataTable:cDataFile    := cPatDat( .t. ) + "CajasL.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "CajasL.Cdx"
   oDataTable:cDescription := "Lineas de cajas"
   oDataTable:aStruct      := aItmCajaL()  
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable():New( "CajasImp", cPathDatos() )
   oDatatable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:cDataFile    := cPatDat( .t. ) + "CajasImp.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "CajasImp.Cdx"
   oDataTable:cDescription := "Cajas impresoras"
   oDataTable:aStruct      := aItmCajaImpresiones()
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable():New( "ImpTik", cPathDatos() )
   oDataTable:cDataFile    := cPatDat( .t. ) + "ImpTik.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "ImpTik.Cdx"
   oDataTable:cDescription := "Impresoras de comanda"
   oDataTable:bCreateFile  := {| cPath | mkImpTik( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxImpTik( cPath ) }
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable():New( "Visor", cPathDatos() )
   oDataTable:cDataFile    := cPatDat( .t. ) + "Visor.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "Visor.Cdx"
   oDataTable:cDescription := "Visores"
   oDataTable:bCreateFile  := {| cPath | mkVisor( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxVisor( cPath ) }
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable():New( "CajPorta", cPathDatos() )
   oDataTable:cDataFile    := cPatDat( .t. ) + "CajPorta.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "CajPorta.Cdx"
   oDataTable:cDescription := "Cajón portamonedas"
   oDataTable:bCreateFile  := {| cPath | mkCajPorta( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxCajPorta( cPath ) }
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable():New( "Agenda", cPathDatos() )
   oDataTable:cDataFile    := cPatDat( .t. ) + "Agenda.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "Agenda.Cdx"
   oDataTable:cDescription := "Agenda"
   oDataTable:bCreateFile  := {| cPath | TAgenda():BuildFiles( cPath ) }
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable():New( "AgendaUsr", cPathDatos() )
   oDataTable:cDataFile    := cPatDat( .t. ) + "AgendaUsr.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "AgendaUsr.Cdx"
   oDataTable:cDescription := "Agenda"
   oDataTable:bCreateFile  := {| cPath | TNotas():BuildFiles( cPath ) }
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable():New( "Divisas", cPathDatos() )
   oDataTable:cDataFile    := cPatDat( .t. ) + "Divisas.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "Divisas.Cdx"
   oDataTable:cDescription := "Divisas"
   oDataTable:bCreateFile  := {| cPath | mkDiv( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxDiv( cPath ) }
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable():New( "TIva", cPathDatos() )
   oDataTable:cDataFile    := cPatDat( .t. ) + "TIva.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "TIva.Cdx"
   oDataTable:cDescription := "Tipos de impuestos"
   oDataTable:bCreateFile  := {| cPath | mkTIva( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxTIva( cPath ) }
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable():New( "Empresa", cPathDatos() )
   oDataTable:cDataFile    := cPatDat( .t. ) + "Empresa.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "Empresa.Cdx"
   oDataTable:cDescription := "Empresa"
   oDataTable:bCreateFile  := {| cPath | mkEmpresa( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxEmpresa( cPath ) }
   oDataTable:bSyncFile    := {|| synEmpresa( cPathDatos() ) }
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable():New( "Delega", cPathDatos() )
   oDataTable:cDataFile    := cPatDat( .t. ) + "Delega.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "Delega.Cdx"
   oDataTable:cDescription := "Delegaciones"
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable():New( "UsrBtnBar", cPathDatos() )
   oDataTable:cDataFile    := cPatDat( .t. ) + "UsrBtnBar.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "UsrBtnBar.Cdx"
   oDataTable:cDescription := "Barra favoritos"
   oDataTable:bCreateFile  := {| cPath | TAcceso():MakeDatabase( cPath ) }
   oDataTable:bCreateIndex := {| cPath | TAcceso():ReindexDatabase( cPath ) }
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable():New( "TblCnv", cPathDatos() )
   oDataTable:cDataFile    := cPatDat( .t. ) + "TblCnv.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "TblCnv.Cdx"
   oDataTable:cDescription := "Factor conversión"
   oDataTable:bCreateFile  := {| cPath | mkTblCnv( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxTblCnv( cPath ) }
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable():New( "Captura", cPathDatos() )
   oDataTable:cDataFile    := cPatDat( .t. ) + "Captura.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "Captura.Cdx"
   oDataTable:cDescription := "Capturas T.P.V."
   oDataTable:bCreateFile  := {| cPath | TCaptura():BuildFiles( cPath ) }
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable():New( "CapturaCampos", cPathDatos() )
   oDataTable:cDataFile    := cPatDat( .t. ) + "CapturaCampos.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "CapturaCampos.Cdx"
   oDataTable:cDescription := "Capturas T.P.V."
   oDataTable:bCreateFile  := {| cPath | TDetCaptura():BuildFiles( cPath ) }
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable():New( "TMov", cPathDatos() )
   oDataTable:cDataFile    := cPatDat( .t. ) + "TMov.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "TMov.Cdx"
   oDataTable:cDescription := "Tipos de movimientos"
   oDataTable:bCreateFile  := {| cPath | mkTMov( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxTMov( cPath ) }
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable():New( "CnfFlt", cPathDatos() )
   oDataTable:cDataFile    := cPatDat( .t. ) + "CnfFlt.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "CnfFlt.Cdx"
   oDataTable:cDescription := "Configuración filtros"
   oDataTable:bCreateFile  := {| cPath | TFilterDatabase():BuildFiles( cPath ) }
   ::AddDataTable( oDataTable )
   
   oDataTable              := TDataTable():New( "CodPostal", cPathDatos() )
   oDataTable:cDataFile    := cPatDat( .t. ) + "CodPostal.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "CodPostal.Cdx"
   oDataTable:cDescription := "Código postal"
   oDataTable:bCreateFile  := {| cPath | CodigosPostales():BuildFiles( cPath ) }
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable():New( "Provincia", cPathDatos() )
   oDataTable:cDataFile    := cPatDat( .t. ) + "Provincia.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "Provincia.Cdx"
   oDataTable:cDescription := "Provincia"
   oDataTable:bCreateFile  := {| cPath | Provincias():BuildFiles( cPath ) }
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable():New( "Pais", cPathDatos() )
   oDataTable:cDataFile    := cPatDat( .t. ) + "Pais.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "Pais.Cdx"
   oDataTable:cDescription := "Paises"
   oDataTable:bCreateFile  := {| cPath | TPais():BuildFiles( cPath ) }
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable():New( "Lenguaje", cPathDatos() )
   oDataTable:cDataFile    := cPatDat( .t. ) + "Lenguaje.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "Lenguaje.Cdx"
   oDataTable:cDescription := "Lenguajes"
   oDataTable:bCreateFile  := {| cPath | TLenguaje():BuildFiles( cPath ) }
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable():New( "Backup", cPathDatos() )
   oDataTable:cDataFile    := cPatDat( .t. ) + "Backup.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "Backup.Cdx"
   oDataTable:bCreateFile  := {| cPath | TBackup():BuildFiles( cPath ) }
   oDataTable:cDescription := "Copias de seguridad"
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable():New( "CCoste", cPathDatos() )
   oDataTable:cDataFile    := cPatDat( .t. ) + "CCoste.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "CCoste.Cdx"
   oDataTable:bSyncFile    := {|| SynCentroCoste() }
   oDataTable:cDescription := "Centro de coste"
   oDataTable:bCreateFile  := {| cPath | TCentroCoste():BuildFiles( cPath ) }
   ::AddDataTable( oDataTable )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD BuildEmpresa()

   local oDataTable

   ::aEmpresaTables        := {}

   oDataTable              := TDataTable():New( "NCount" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "NCount.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "NCount.Cdx"
   oDataTable:cDescription := "Contadores"
   oDataTable:aStruct      := aItmCount()
   oDataTable:bCreateFile  := {| cPath | mkCount( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxCount( cPath ) }
   oDataTable:bSyncFile    := {| cPath | synCount( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "EntSal" )
   oDatatable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "EntSal.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "EntSal.Cdx"
   oDataTable:cDescription := "Entradas y salidas"
   oDataTable:bCreateFile  := {| cPath | mkEntSal( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxEntSal( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "LogPorta" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "LogPorta.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "LogPorta.Cdx"
   oDataTable:cDescription := "Entradas y salidas"
   oDataTable:bCreateFile  := {| cPath | mkLogPorta( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxLogPorta( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "Almacen" )
   oDatatable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Almacen.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Almacen.Cdx"
   oDataTable:cDescription := "Almacenes"
   oDataTable:bCreateFile  := {| cPath | mkAlmacen( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxAlmacen( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "AlmacenL" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AlmacenL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AlmacenL.Cdx"
   oDataTable:cDescription := "Almacenes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "FPago" )
   oDatatable:lTrigger     := ::lTriggerAuxiliares   
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FPago.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FPago.Cdx"
   oDataTable:cDescription := "Formas de pago"
   oDataTable:bCreateFile  := {| cPath | mkFPago( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxFPago( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "Invita" )
   oDatatable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Invita.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Invita.Cdx"
   oDataTable:cDescription := "Invitaciones"
   oDataTable:bCreateFile  := {| cPath | TInvitacion():buildfiles(cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "Catalogo" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Catalogo.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Catalogo.Cdx"
   oDataTable:cDescription := "Catálogos"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "UndMed" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "UndMed.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "UndMed.Cdx"
   oDataTable:bSyncFile    := {|| UniMedicion():Create():Syncronize() }
   oDataTable:cDescription := "Unidades de medición"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "Bancos" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Bancos.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Bancos.Cdx"
   oDataTable:cDescription := "Bancos"
   oDataTable:bCreateFile  := {| cPath | TBancos():BuildFiles( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "EmpBnc" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "EmpBnc.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "EmpBnc.Cdx"
   oDataTable:cDescription := "Cuentas bancos"
   oDataTable:bCreateFile  := {| cPath | TCuentasBancarias():BuildFiles( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "Turno" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Turno.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Turno.Cdx"
   oDataTable:cDescription := "Sesiones"
   oDataTable:bCreateFile  := {| cPath | TTurno():BuildFiles( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "TurnoC" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TurnoC.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TurnoC.Cdx"
   oDataTable:cDescription := "Sesiones cajas"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "TurnoL" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TurnoL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TurnoL.Cdx"
   oDataTable:cDescription := "Lineas cajas"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "NewImp" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "NewImp.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "NewImp.Cdx"
   oDataTable:cDescription := "Impuestos"
   oDataTable:bCreateFile  := {| cPath | TNewImp():BuildFiles( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "UbiCat" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "UbiCat.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "UbiCat.Cdx"
   oDataTable:cDescription := "Ubicaciones"
   oDataTable:bCreateFile  := {| cPath | mkUbi( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxUbi( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "UbiCal" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "UbiCal.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "UbiCal.Cdx"
   oDataTable:cDescription := "Ubicaciones calles"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "GrpVent" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "GrpVent.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "GrpVent.Cdx"
   oDataTable:cDescription := "Grupos de ventas"
   oDataTable:bCreateFile  := {| cPath | mkGrpVenta( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxGrpVenta( cPath ) }
   ::AddEmpresaTable( oDataTable )

   /*
   Movimientos de almacén ( Al final es para quitarlo )------------------------
   */

   oDataTable              := TDataTable():New( "RemMovT" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "RemMovT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "RemMovT.Cdx"
   oDataTable:cDescription := "Remesas de movimientos"
   oDataTable:bCreateFile  := {| cPath | TRemMovAlm():BuildFiles( cPath ) }
   oDataTable:bCreateIndex := {| cPath | TRemMovAlm():Create( cPath ):Reindexa() }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "HisMov" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "HisMov.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "HisMov.Cdx"
   oDataTable:cDescription := "Movimientos de almacén"
   oDataTable:bCreateFile  := {| cPath | TDetMovimientos():BuildFiles( cPath ) }
   oDataTable:bCreateIndex := {| cPath | TDetMovimientos():Create( cPath ):Reindexa() }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "MovSer" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "MovSer.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "MovSer.Cdx"
   oDataTable:cDescription := "Movimientos"
   oDataTable:bCreateFile  := {| cPath | TDetSeriesMovimientos():BuildFiles( cPath ) }
   oDataTable:bCreateIndex := {| cPath | TDetSeriesMovimientos():Create( cPath ):Reindexa() }
   ::AddEmpresaTable( oDataTable )

   /*
   Articulos-------------------------------------------------------------------
   */

   oDataTable              := TDataTable():New( "Articulo" )
   oDatatable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Articulo.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Articulo.Cdx"
   oDataTable:bSyncFile    := {|| SynArt( cPatEmp() ) }
   oDataTable:cDescription := "Artículos"
   oDataTable:bCreateFile  := {| cPath | mkArticulo( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxArticulo( cPath ) }
   oDataTable:bId          := {|| Field->Codigo }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "ProvArt" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ProvArt.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ProvArt.Cdx"
   oDataTable:cDescription := "Artículos proveedor"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "ArtLeng" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ArtLeng.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ArtLeng.Cdx"
   oDataTable:cDescription := "Artículos lenguaje"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "ArtDiv" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ArtDiv.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ArtDiv.Cdx"
   oDataTable:cDescription := "Artículos precios por porpiedades"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "ArtKit" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ArtKit.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ArtKit.Cdx"
   oDataTable:cDescription := "Artículos escandallos"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "ArtCodebar" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ArtCodebar.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ArtCodebar.Cdx"
   oDataTable:cDescription := "Artículos codigos de barra"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "ArtLbl" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ArtLbl.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ArtLbl.Cdx"
   oDataTable:cDescription := "Artículos etiquetas"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "ArtImg" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ArtImg.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ArtImg.Cdx"
   oDataTable:cDescription := "Artículos imagenes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "ArtAlm" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ArtAlm.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ArtAlm.Cdx"
   oDataTable:bSyncFile    := {|| SynArt( cPatEmp() ) }
   oDataTable:cDescription := "Artículos stock almacenes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "Familias" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Familias.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Familias.Cdx"
   oDataTable:bCreateFile  := {| cPath | mkFamilia( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxFamilia( cPath ) }
   oDataTable:cDescription := "Familias"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "FamPrv" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FamPrv.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FamPrv.Cdx"
   oDataTable:cDescription := "Familias proveedor"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "FamLeng" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FamLeng.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FamLeng.Cdx"
   oDataTable:cDescription := "Familias lenguaje"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "Temporadas" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Temporadas.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Temporadas.Cdx"
   oDataTable:cDescription := "Temporadas"
   oDataTable:bCreateFile  := {| cPath | mkTemporada( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxTemporada( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "Categorias" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Categorias.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Categorias.Cdx"
   oDataTable:cDescription := "Categorias"
   oDataTable:bCreateFile  := {| cPath | mkCategoria( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxCategoria( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "EstadoSat" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "EstadoSat.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "EstadoSat.Cdx"
   oDataTable:cDescription := "EstadoSat"
   oDataTable:bCreateFile  := {| cPath | mkEstadoSat( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxEstadoSat( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "TipArt" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TipArt.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TipArt.Cdx"
   oDataTable:cDescription := "Tipos de artículos"
   oDataTable:bCreateFile  := {| cPath | TTipArt():BuildFiles( cPath ) }
   ::AddEmpresaTable( oDataTable )

/*
   oDataTable              := TDataTable():New( "Proyecto" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Proyecto.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Proyecto.Cdx"
   oDataTable:cDescription := "Proyectos"
   oDataTable:bCreateFile  := {| cPath | TProyecto():BuildFiles( cPath ) }
   ::AddEmpresaTable( oDataTable )
*/

   oDataTable              := TDataTable():New( "Fabric" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Fabric.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Fabric.Cdx"
   oDataTable:cDescription := "Fabricantes"
   oDataTable:bCreateFile  := {| cPath | TFabricantes():BuildFiles( cPath ) }
   oDataTable:bSyncFile    := {|| TFabricantes():Create():Syncronize() }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "TarPreT" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TarPreT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TarPreT.Cdx"
   oDataTable:cDescription := "Tarifas personalizadas"
   oDataTable:bCreateFile  := {| cPath | mkTarifa( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxTarifa( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "TarPreL" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TarPreL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TarPreL.Cdx"
   oDataTable:cDescription := "Tarifas personalizadas"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "TarPreS" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TarPreS.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TarPreS.Cdx"
   oDataTable:cDescription := "Tarifas personalizadas"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "Oferta" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Oferta.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Oferta.Cdx"
   oDataTable:cDescription := "Ofertas"
   oDataTable:bCreateFile  := {| cPath | mkOferta( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxOferta( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "Pro" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Pro.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Pro.Cdx"
   oDataTable:cDescription := "Propiedades"
   oDataTable:bCreateFile  := {| cPath | mkPro( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxPro( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "TblPro" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TblPro.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TblPro.Cdx"
   oDataTable:cDescription := "Propiedades"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "GrpFam" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "GrpFam.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "GrpFam.Cdx"
   oDataTable:cDescription := "Grupo de familias"
   oDataTable:bCreateFile  := {| cPath | TGrpFam():BuildFiles( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "FraPub" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FraPub.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FraPub.Cdx"
   oDataTable:cDescription := "Frases publicitarias"
   oDataTable:bCreateFile  := {| cPath | TFrasesPublicitarias():BuildFiles( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "TComandas" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TComandas.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TComandas.Cdx"
   oDataTable:cDescription := "Comandas"
   oDataTable:bCreateFile  := {| cPath | TComandas():BuildFiles( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "OrdenComanda" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "OrdenComanda.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "OrdenComanda.Cdx"
   oDataTable:cDescription := "OrdenComanda"
   oDataTable:bCreateFile  := {| cPath | TOrdenComanda():BuildFiles( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "ComentariosT" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ComentariosT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ComentariosT.Cdx"
   oDataTable:cDescription := "Comentarios"
   oDataTable:bCreateFile  := {| cPath | TComentarios():BuildFiles( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "ComentariosL" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ComentariosL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ComentariosL.Cdx"
   oDataTable:cDescription := "Comentarios lineas"
   oDataTable:bCreateFile  := {| cPath | TDetComentarios():BuildFiles( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "PromoT" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PromoT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PromoT.Cdx"
   oDataTable:cDescription := "Promociones"
   oDataTable:bCreateFile  := {| cPath | mkPromo( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxPromo( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "PromoL" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PromoL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PromoL.Cdx"
   oDataTable:cDescription := "Promociones lineas"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "PromoC" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PromoC.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PromoC.Cdx"
   oDataTable:cDescription := "Promociones"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "Fideliza" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Fideliza.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Fideliza.Cdx"
   oDataTable:cDescription := "Fidelización"
   oDataTable:bCreateFile  := {| cPath | TFideliza():BuildFiles( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "DetFideliza" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "DetFideliza.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "DetFideliza.Cdx"
   oDataTable:cDescription := "Fidelización lineas"
   oDataTable:bCreateFile  := {| cPath | TDetFideliza():BuildFiles( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "CampoExtra" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "CampoExtra.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "CampoExtra.Cdx"
   oDataTable:cDescription := "Campos extra"
   oDataTable:bCreateFile  := {| cPath | TCamposExtra():BuildFiles( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "DetCExtra" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "DetCExtra.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "DetCExtra.Cdx"
   oDataTable:cDescription := "Detalle de campos extra"
   oDataTable:bCreateFile  := {| cPath | TDetCamposExtra():BuildFiles( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "PrestaId" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PrestaId.DBF"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PrestaId.CDX"
   oDataTable:cDescription := "Identificadores de prestashop"
   oDataTable:bCreateFile  := {| cPath | TPrestaShopId():BuildFiles( cPath ) }
   ::AddEmpresaTable( oDataTable )

   /*
   Clientes--------------------------------------------------------------------
   */

   oDataTable              := TDataTable():New( "Client" )
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:cDataFile    := cPatCli( , .t. ) + "Client.Dbf"
   oDataTable:cIndexFile   := cPatCli( , .t. ) + "Client.Cdx"
   oDataTable:bCreateFile  := {| cPath | mkClient( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxClient( cPath ) }
   oDataTable:bSyncFile    := {|| synClient( cPatEmp() ) }
   oDataTable:cDescription := "Clientes"
   oDatatable:aDictionary  := hashDictionary( aItmCli() )
   oDatatable:aDefaultValue:= hashDefaultValue( aItmCli() )
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "ClientD" )
   oDataTable:cDataFile    := cPatCli( , .t. ) + "ClientD.Dbf"
   oDataTable:cIndexFile   := cPatCli( , .t. ) + "ClientD.Cdx"
   oDataTable:cDescription := "Clientes documentos"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "CliAtp" )
   oDataTable:cDataFile    := cPatCli( , .t. ) + "CliAtp.Dbf"
   oDataTable:cIndexFile   := cPatCli( , .t. ) + "CliAtp.Cdx"
   oDataTable:cDescription := "Atípicas de clientes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "ObrasT" )
   oDataTable:cDataFile    := cPatCli( , .t. ) + "ObrasT.Dbf"
   oDataTable:cIndexFile   := cPatCli( , .t. ) + "ObrasT.Cdx"
   oDataTable:cDescription := "Clientes direcciones"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "CliCto" )
   oDataTable:cDataFile    := cPatCli( , .t. ) + "CliCto.Dbf"
   oDataTable:cIndexFile   := cPatCli( , .t. ) + "CliCto.Cdx"
   oDataTable:cDescription := "Clientes contactos"
   ::AddEmpresaTable( oDataTable )


   oDataTable              := TDataTable():New( "CliDad" )
   oDataTable:cDataFile    := cPatCli( , .t. ) + "CliDad.Dbf"
   oDataTable:cIndexFile   := cPatCli( , .t. ) + "CliDad.Cdx"
   oDataTable:cDescription := "Clientes contactos"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "CliBnc" )
   oDataTable:cDataFile    := cPatCli( , .t. ) + "CliBnc.Dbf"
   oDataTable:cIndexFile   := cPatCli( , .t. ) + "CliBnc.Cdx"
   oDataTable:cDescription := "Clientes bancos"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "CliInc" )
   oDataTable:cDataFile    := cPatCli( , .t. ) + "CliInc.Dbf"
   oDataTable:cIndexFile   := cPatCli( , .t. ) + "CliInc.Cdx"
   oDataTable:cDescription := "Clientes incidencias"
   oDatatable:aDictionary  := hashDictionary( aCliInc() )
   oDatatable:aDefaultValue:= hashDefaultValue( aCliInc() )
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "GrpCli" )
   oDataTable:cDataFile    := cPatCli( , .t. ) + "GrpCli.Dbf"
   oDataTable:cIndexFile   := cPatCli( , .t. ) + "GrpCli.Cdx"
   oDataTable:cDescription := "Grupos de clientes"
   oDataTable:bCreateFile  := {| cPath | TGrpCli():BuildFiles( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "Transpor" )
   oDataTable:cDataFile    := cPatCli( , .t. ) + "Transpor.Dbf"
   oDataTable:cIndexFile   := cPatCli( , .t. ) + "Transpor.Cdx"
   oDataTable:cDescription := "Transportistas"
   oDataTable:bCreateFile  := {| cPath | TTrans():BuildFiles( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "Ruta" )
   oDataTable:cDataFile    := cPatCli( , .t. ) + "Ruta.Dbf"
   oDataTable:cIndexFile   := cPatCli( , .t. ) + "Ruta.Cdx"
   oDataTable:cDescription := "Rutas"
   oDataTable:bCreateFile  := {| cPath | mkRuta( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxRuta( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "CtaRem" )
   oDataTable:cDataFile    := cPatCli( , .t. ) + "CtaRem.Dbf"
   oDataTable:cIndexFile   := cPatCli( , .t. ) + "CtaRem.Cdx"
   oDataTable:cDescription := "Cuentas de remesas"
   oDataTable:bCreateFile  := {| cPath | TCtaRem():BuildFiles( cPath ) }
   ::AddEmpresaTable( oDataTable )

   /*
   Agentes---------------------------------------------------------------------
   */

   oDataTable              := TDataTable():New( "Agentes" )
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Agentes.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Agentes.Cdx"
   oDataTable:cDescription := "Agentes"
   oDataTable:bCreateFile  := {| cPath | mkAgentes( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxAgentes( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "AgeCom" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AgeCom.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AgeCom.Cdx"
   oDataTable:cDescription := "Agentes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "AgeRel" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AgeRel.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AgeRel.Cdx"
   oDataTable:cDescription := "Agentes"
   ::AddEmpresaTable( oDataTable )

   /*
   Proveedores-----------------------------------------------------------------
   */

   oDataTable              := TDataTable():New( "GrpPrv" )
   oDataTable:cDataFile    := cPatPrv( , .t. ) + "GrpPrv.Dbf"
   oDataTable:cIndexFile   := cPatPrv( , .t. ) + "GrpPrv.Cdx"
   oDataTable:bSyncFile    := {|| SynProvee( cPatEmp() ) }
   oDataTable:cDescription := "Grupos de proveedores"
   oDataTable:bCreateFile  := {| cPath | TGrpPrv():BuildFiles( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "Provee" )
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:cDataFile    := cPatPrv( , .t. ) + "Provee.Dbf"
   oDataTable:cIndexFile   := cPatPrv( , .t. ) + "Provee.Cdx"
   oDataTable:cDescription := "Proveedores"
   oDataTable:bCreateFile  := {| cPath | mkProvee( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxProvee( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "ProveeD" )
   oDataTable:cDataFile    := cPatPrv( , .t. ) + "ProveeD.Dbf"
   oDataTable:cIndexFile   := cPatPrv( , .t. ) + "ProveeD.Cdx"
   oDataTable:cDescription := "Proveedores"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "PrvBnc" )
   oDataTable:cDataFile    := cPatPrv( , .t. ) + "PrvBnc.Dbf"
   oDataTable:cIndexFile   := cPatPrv( , .t. ) + "PrvBnc.Cdx"
   oDataTable:cDescription := "Bancos de proveedores"
   ::AddEmpresaTable( oDataTable )

   /*
   Varios de empresa-----------------------------------------------------------
   */

   oDataTable              := TDataTable():New( "RemAgeT" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "RemAgeT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "RemAgeT.Cdx"
   oDataTable:cDescription := "Remesas de agentes"
   oDataTable:bCreateFile  := {| cPath | TCobAge():BuildFiles( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "CfgUse" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "CfgUse.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "CfgUse.Cdx"
   oDataTable:cDescription := "Configuración"
   oDataTable:bCreateFile  := {| cPath | ColumnasUsuariosModel():CreateFile( cPath ) }
   oDataTable:bCreateIndex := {| cPath | ColumnasUsuariosModel():CreateIndex( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "CfgInf" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "CfgInf.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "CfgInf.Cdx"
   oDataTable:cDescription := "Configuración"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "CfgFnt" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "CfgFnt.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "CfgFnt.Cdx"
   oDataTable:cDescription := "Configuración"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "CfgGrp" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "CfgGrp.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "CfgGrp.Cdx"
   oDataTable:cDescription := "Configuración"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "RDocumen" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "RDocumen.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "RDocumen.Cdx"
   oDataTable:cDescription := "Documentos"
   oDataTable:bCreateFile  := {| cPath | mkDocs( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxDocs( cPath ) }
    ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "RItems" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "RItems.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "RItems.Cdx"
   oDataTable:cDescription := "Documentos"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "RColum" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "RColum.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "RColum.Cdx"
   oDataTable:cDescription := "Documentos"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "RBitmap" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "RBitmap.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "RBitmap.Cdx"
   oDataTable:cDescription := "Documentos"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "RBox" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "RBox.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "RBox.Cdx"
   oDataTable:cDescription := "Documentos"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "FstInf" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FstInf.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FstInf.Cdx"
   oDataTable:cDescription := "Documentos"
   oDataTable:bCreateFile  := {| cPath | TFastReportInfGen():BuildFiles( cPath ) }
   ::AddEmpresaTable( oDataTable )

   /*
   Pedido Proveedores----------------------------------------------------------
   */

   oDataTable              := TDataTable():New( "PedProvT" )
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PedProvT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PedProvT.Cdx"
   oDataTable:bSyncFile    := {|| SynPedPrv( cPatEmp() ) }
   oDatatable:aDictionary  := hashDictionary( aItmPedPrv() )
   oDatatable:aDefaultValue:= hashDefaultValue( aItmPedPrv() )
   oDatatable:hIndex       := hashIndex( aIndexPedidoProveedor() )
   oDataTable:cDescription := "Pedidos de proveedor"
   oDataTable:bCreateFile  := {| cPath | mkPedPrv( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxPedPrv( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "PedProvL" )
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PedProvL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PedProvL.Cdx"
   oDatatable:aDictionary  := hashDictionary( aColPedPrv() )
   oDatatable:aDefaultValue:= hashDefaultValue( aColPedPrv() )
   oDataTable:cDescription := "Pedidos de proveedor"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "PedPrvI" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PedPrvI.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PedPrvI.Cdx"
   oDataTable:cDescription := "Pedidos de proveedor"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "PedPrvD" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PedPrvD.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PedPrvD.Cdx"
   oDataTable:cDescription := "Pedidos de proveedor"
   ::AddEmpresaTable( oDataTable )

   /*
   Albaran Proveedores
   */

   oDataTable              := TDataTable():New( "AlbProvT" )
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AlbProvT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AlbProvT.Cdx"
   oDataTable:bSyncFile    := {|| SynAlbPrv( cPatEmp() ) }
   oDataTable:cDescription := "Albaranes de proveedor"
   oDataTable:bCreateFile  := {| cPath | mkAlbPrv( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxAlbPrv( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "AlbProvL" )
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:cDescription := "Albaranes de proveedor lineas"
   oDataTable:aStruct      := aColAlbPrv()
   oDatatable:aDictionary  := hashDictionary( aColAlbPrv() )
   oDatatable:aDefaultValue:= hashDefaultValue( aColAlbPrv() )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AlbProvL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AlbProvL.Cdx"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "AlbPrvI" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AlbPrvI.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AlbPrvI.Cdx"
   oDataTable:cDescription := "Albaranes de proveedor incidencias"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "AlbPrvD" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AlbPrvD.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AlbPrvD.Cdx"
   oDataTable:cDescription := "Albaranes de proveedor documentos"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "AlbPrvS" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AlbPrvS.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AlbPrvS.Cdx"
   oDataTable:cDescription := "Albaranes de proveedor series"
   ::AddEmpresaTable( oDataTable )

   /*
   Facturas Proveedores--------------------------------------------------------
   */

   oDataTable              := TDataTable():New( "FacPrvT" )
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacPrvT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacPrvT.Cdx"
   oDataTable:bSyncFile    := {|| SynFacPrv( cPatEmp() ) }
   oDataTable:cDescription := "Facturas de proveedor"
   oDataTable:bCreateFile  := {| cPath | mkFacPrv( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxFacPrv( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "FacPrvL" )
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacPrvL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacPrvL.Cdx"
   oDataTable:cDescription := "Líneas de facturas de proveedor"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "FacPrvI" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacPrvI.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacPrvI.Cdx"
   oDataTable:cDescription := "Incidencias de facturas de proveedor"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "FacPrvD" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacPrvD.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacPrvD.Cdx"
   oDataTable:cDescription := "Documentos de facturas de proveedor"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "FacPrvP" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacPrvP.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacPrvP.Cdx"
   oDataTable:cDescription := "Pagos de facturas de proveedor"
   oDataTable:bSyncFile    := {|| SynRecPrv( cPatEmp() ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "FacPrvS" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacPrvS.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacPrvS.Cdx"
   oDataTable:cDescription := "Series de facturas de proveedor"
   ::AddEmpresaTable( oDataTable )

   /*
   Rectificativas de proveedores
   */

   oDataTable              := TDataTable():New( "RctPrvT" )
   oDataTable:lTrigger     := ::lTriggerAuxiliares   
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "RctPrvT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "RctPrvT.Cdx"
   oDataTable:cDescription := "Rectificativas de proveedor"
   oDataTable:bCreateFile  := {| cPath | mkRctPrv( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxRctPrv( cPath ) }
   oDataTable:bSyncFile    := {|| SynRctPrv( cPatEmp() ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "RctPrvL" )
   oDataTable:lTrigger     := ::lTriggerAuxiliares   
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "RctPrvL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "RctPrvL.Cdx"
   oDataTable:cDescription := "Líneas de rectificativas de proveedor"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "RctPrvI" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "RctPrvI.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "RctPrvI.Cdx"
   oDataTable:cDescription := "Rectificativas de proveedor"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "RctPrvD" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "RctPrvD.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "RctPrvD.Cdx"
   oDataTable:cDescription := "Rectificativas de proveedor"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "RctPrvS" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "RctPrvS.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "RctPrvS.Cdx"
   oDataTable:cDescription := "Rectificativas de proveedor"
   ::AddEmpresaTable( oDataTable )

   /*
   SAT Clientes
   */

   oDataTable              := TDataTable():New( "SatCliT" )
   oDataTable:lTrigger     := ::lTriggerAuxiliares   
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "SatCliT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "SatCliT.Cdx"
   oDataTable:cDescription := "S.A.T. de clientes"
   oDatatable:aDictionary  := hashDictionary( aItmSatCli() )
   oDatatable:aDefaultValue:= hashDefaultValue( aItmSatCli() )
   oDataTable:bCreateFile  := {| cPath | mkSatCli( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxSatCli( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "SatCliL" )
   oDataTable:lTrigger     := ::lTriggerAuxiliares   
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "SatCliL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "SatCliL.Cdx"
   oDataTable:cDescription := "S.A.T. de clientes"
   oDatatable:aDictionary  := hashDictionary( aColSatCli() )
   oDatatable:aDefaultValue:= hashDefaultValue( aColSatCli() )
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "SatCliI" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "SatCliI.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "SatCliI.Cdx"
   oDataTable:cDescription := "S.A.T. de clientes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "SatCliD" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "SatCliD.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "SatCliD.Cdx"
   oDataTable:cDescription := "S.A.T. de clientes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "SatCliS" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "SatCliS.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "SatCliS.Cdx"
   oDataTable:cDescription := "S.A.T. de clientes"
   oDataTable:bSyncFile    := {|| SynSatCli( cPatEmp() ) }
   ::AddEmpresaTable( oDataTable )

   /*
   Presupuestos Clientes
   */

   oDataTable              := TDataTable():New( "PreCliT" )
   oDataTable:lTrigger     := ::lTriggerAuxiliares   
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PreCliT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PreCliT.Cdx"
   oDataTable:cDescription := "Presupuestos de clientes"
   oDatatable:aDictionary  := hashDictionary( aItmPreCli() )
   oDatatable:aDefaultValue:= hashDefaultValue( aItmPreCli() )
   oDataTable:bCreateFile  := {| cPath | mkPreCli( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxPreCli( cPath ) }
   oDataTable:bSyncFile    := {|| SynPreCli( cPatEmp() ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "PreCliL" )
   oDataTable:lTrigger     := ::lTriggerAuxiliares   
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PreCliL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PreCliL.Cdx"
   oDataTable:cDescription := "Presupuestos de clientes"
   oDatatable:aDictionary  := hashDictionary( aColPreCli() )
   oDatatable:aDefaultValue:= hashDefaultValue( aColPreCli() )
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "PreCliI" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PreCliI.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PreCliI.Cdx"
   oDataTable:cDescription := "Presupuestos de clientes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "PreCliD" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PreCliD.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PreCliD.Cdx"
   oDataTable:cDescription := "Presupuestos de clientes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "PreCliE" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PreCliE.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PreCliE.Cdx"
   oDataTable:cDescription := "Situaciones de presupuestos de clientes"
   ::AddEmpresaTable( oDataTable )

   /*
   Pedidos Clientes
   */

   oDataTable              := TDataTable():New( "PedCliT" )
   oDataTable:lTrigger     := ::lTriggerAuxiliares   
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PedCliT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PedCliT.Cdx"
   oDataTable:cDescription := "Pedidos de clientes"
   oDataTable:bCreateFile  := {| cPath | mkPedCli( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxPedCli( cPath ) }
   oDataTable:bSyncFile    := {|| SynPedCli( cPatEmp() ) }
   oDatatable:aDictionary  := hashDictionary( aItmPedCli() )
   oDatatable:aDefaultValue:= hashDefaultValue( aItmPedCli() )
   oDatatable:bId          := {|| Field->cSerPed + str( Field->nNumPed ) + Field->cSufPed }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "PedCliL" )
   oDataTable:lTrigger     := ::lTriggerAuxiliares   
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PedCliL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PedCliL.Cdx"
   oDataTable:cDescription := "Líneas de pedidos de clientes"
   oDatatable:aDictionary  := hashDictionary( aColPedCli() )
   oDatatable:aDefaultValue:= hashDefaultValue( aColPedCli() )
   oDatatable:bId          := {|| Field->cSerPed + str( Field->nNumPed ) + Field->cSufPed }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "PedCliI" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PedCliI.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PedCliI.Cdx"
   oDataTable:cDescription := "Incidencias de pedidos de clientes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "PedCliD" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PedCliD.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PedCliD.Cdx"
   oDataTable:cDescription := "Documentos de pedidos de clientes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "PedCliP" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PedCliP.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PedCliP.Cdx"
   oDataTable:cDescription := "Pagos de pedidos de clientes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "PedCliR" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PedCliR.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PedCliR.Cdx"
   oDataTable:cDescription := "Pedidos de clientes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "PedCliE" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PedCliE.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PedCliE.Cdx"
   oDataTable:cDescription := "Pedidos de clientes situaciones"
   ::AddEmpresaTable( oDataTable )

   /*
   Albaranes Clientes
   */

   oDataTable                 := TDataTable():New( "AlbCliT" )
   oDataTable:lTrigger        := ::lTriggerAuxiliares   
   oDataTable:cDataFile       := cPatEmp( , .t. ) + "AlbCliT.Dbf"
   oDataTable:cIndexFile      := cPatEmp( , .t. ) + "AlbCliT.Cdx"
   oDataTable:cDescription    := "Albaranes de clientes"
   oDataTable:bCreateFile     := {|| mkAlbCli( cPatEmp() ) }
   oDataTable:adsCreateIndex  := {|| reindexAdsAlbCli( cPatEmp() ) }
   oDataTable:bSyncFile       := {|| synAlbCli( cPatEmp() ) }
   oDatatable:aDictionary     := hashDictionary( aItmAlbCli() )
   oDatatable:aDefaultValue   := hashDefaultValue( aItmAlbCli() )
   oDatatable:bId             := {|| Field->cSerAlb + str( Field->nNumAlb ) + Field->cSufAlb }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "AlbCliL" )
   oDataTable:lTrigger     := ::lTriggerAuxiliares   
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AlbCliL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AlbCliL.Cdx"
   oDataTable:cDescription := "Albaranes de clientes"
   oDatatable:aDictionary  := hashDictionary( aColAlbCli() )
   oDatatable:aDefaultValue:= hashDefaultValue( aColAlbCli() )
   oDatatable:bId          := {|| Field->cSerAlb + str( Field->nNumAlb ) + Field->cSufAlb }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "AlbCliI" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AlbCliI.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AlbCliI.Cdx"
   oDataTable:cDescription := "Albaranes de clientes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "AlbCliD" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AlbCliD.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AlbCliD.Cdx"
   oDataTable:cDescription := "Albaranes de clientes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "AlbCliP" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AlbCliP.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AlbCliP.Cdx"
   oDataTable:cDescription := "Albaranes de clientes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "AlbCliS" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AlbCliS.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AlbCliS.Cdx"
   oDataTable:cDescription := "Albaranes de clientes"
   oDatatable:bId          := {|| Field->cSerAlb + str( Field->nNumAlb ) + Field->cSufAlb }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "AlbCliE" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AlbCliE.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AlbCliE.Cdx"
   oDataTable:cDescription := "Situaciones de albaranes de clientes"
   ::AddEmpresaTable( oDataTable )

   /*
   Remesas---------------------------------------------------------------------
   */

   oDataTable              := TDataTable():New( "RemCliT" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "RemCliT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "RemCliT.Cdx"
   oDataTable:cDescription := "Remesas de clientes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "RemAgeL" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "RemAgeL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "RemAgeL.Cdx"
   ::AddEmpresaTable( oDataTable )

   /*
   Facturas Clientes-----------------------------------------------------------
   */

   oDataTable              := TDataTable():New( "FacCliT" )
   oDataTable:lTrigger     := ::lTriggerAuxiliares   
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacCliT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacCliT.Cdx"
   oDataTable:cDescription := "Facturas de clientes"
   oDataTable:bCreateFile  := {| cPath | mkFacCli( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxFacCli( cPath ) }
   oDataTable:bSyncFile    := {|| SynFacCli( cPatEmp() ) }
   oDatatable:aDictionary  := hashDictionary( aItmFacCli() )
   oDatatable:aDefaultValue:= hashDefaultValue( aItmFacCli() )
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "FacCliL" )
   oDataTable:lTrigger     := ::lTriggerAuxiliares   
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacCliL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacCliL.Cdx"
   oDataTable:cDescription := "Facturas de clientes"
   oDatatable:aDictionary  := hashDictionary( aColFacCli() )
   oDatatable:aDefaultValue:= hashDefaultValue( aColFacCli() )
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "FacCliI" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacCliI.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacCliI.Cdx"
   oDataTable:cDescription := "Facturas de clientes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "FacCliD" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacCliD.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacCliD.Cdx"
   oDataTable:cDescription := "Facturas de clientes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "FacCliS" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacCliS.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacCliS.Cdx"
   oDataTable:cDescription := "Facturas de clientes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "FacCliE" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacCliE.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacCliE.Cdx"
   oDataTable:cDescription := "Facturas de clientes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "FacRecT" )
   oDataTable:lTrigger     := ::lTriggerAuxiliares   
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacRecT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacRecT.Cdx"
   oDataTable:cDescription := "Rectificativas de clientes"
   oDataTable:bCreateIndex := {| cPath | rxFacRec( cPath ) }
   oDataTable:bCreateFile  := {| cPath | mkFacRec( cPath ) }
   oDataTable:bSyncFile    := {|| SynFacRec( cPatEmp() ) }
   oDatatable:aDictionary  := hashDictionary( aItmFacRec() )
   oDatatable:aDefaultValue:= hashDefaultValue( aItmFacRec() )
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "FacRecL" )
   oDataTable:lTrigger     := ::lTriggerAuxiliares   
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacRecL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacRecL.Cdx"
   oDataTable:cDescription := "Rectificativas de clientes"
   oDatatable:aDictionary  := hashDictionary( aColFacRec() )
   oDatatable:aDefaultValue:= hashDefaultValue( aColFacRec() )
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "FacRecI" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacRecI.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacRecI.Cdx"
   oDataTable:cDescription := "Rectificativas de clientes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "FacRecD" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacRecD.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacRecD.Cdx"
   oDataTable:cDescription := "Rectificativas de clientes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "FacRecS" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacRecS.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacRecS.Cdx"
   oDataTable:cDescription := "Rectificativas de clientes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "FacCliP" )
   oDataTable:lTrigger     := ::lTriggerAuxiliares   
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacCliP.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacCliP.Cdx"
   oDataTable:cDescription := "Facturas de clientes recibos"
   oDataTable:bCreateIndex := {| cPath | rxRecCli( cPath ) }
   oDataTable:bCreateFile  := {| cPath | mkRecCli( cPath ) }
   oDataTable:bSyncFile    := {|| SynRecCli( cPatEmp() ) }
   oDatatable:aDictionary  := hashDictionary( aItmRecCli() )
   oDatatable:aDefaultValue:= hashDefaultValue( aItmRecCli() )
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "FacCliG" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacCliG.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacCliG.Cdx"
   oDataTable:cDescription := "Facturas de clientes grupos de recibos"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "FacAutT" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacAutT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacAutT.Cdx"
   oDataTable:cDescription := "Plantillas automáticas de clientes"
   oDataTable:bCreateFile  := {| cPath | TFacAutomatica():buildfiles(cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "GrpFac" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "GrpFac.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "GrpFac.Cdx"
   oDataTable:cDescription := "Grupos de facturas automáticas"
   oDataTable:bCreateFile  := {| cPath | TGrpFacturasAutomaticas():buildfiles(cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "FacAutL" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacAutL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacAutL.Cdx"
   oDataTable:cDescription := "Plantillas automáticas de clientes lineas"
   oDataTable:bCreateFile  := {| cPath | TDetFacAutomatica():buildfiles(cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "FacAutI" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacAutI.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacAutI.Cdx"
   oDataTable:cDescription := "Plantillas automáticas de clientes historico"
   oDataTable:bCreateFile  := {| cPath | THisFacAutomatica():buildfiles(cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "FacCliC" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacCliC.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacCliC.Cdx"
   oDataTable:cDescription := "Situaciones de Facturas de clientes"
   ::AddEmpresaTable( oDataTable )

   /*
   Facturas Rectificativas-----------------------------------------------
   */

   oDataTable              := TDataTable():New( "FacRecE" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacRecE.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacRecE.Cdx"
   oDataTable:cDescription := "Situaciones de Facturas rectificativas de clientes"
   ::AddEmpresaTable( oDataTable )

   /*
   Facturas de anticipo-----------------------------------------------
   */

   oDataTable              := TDataTable():New( "AntCliT" )
   oDataTable:lTrigger     := ::lTriggerAuxiliares   
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AntCliT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AntCliT.Cdx"
   oDataTable:cDescription := "Anticipos de clientes"
   oDataTable:bCreateIndex := {| cPath | rxAntCli( cPath ) }
   oDataTable:bCreateFile  := {| cPath | mkAntCli( cPath ) }
   // oDataTable:bSyncFile    := {|| SynAntCli( cPatEmp() ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "AntCliI" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AntCliI.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AntCliI.Cdx"
   oDataTable:cDescription := "Anticipos de clientes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "AntCliD" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AntCliD.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AntCliD.Cdx"
   oDataTable:cDescription := "Anticipos de clientes"
   ::AddEmpresaTable( oDataTable )

   /*
   Ticket Clientes
   */

   oDataTable              := TDataTable():New( "TikeT" )
   oDataTable:lTrigger     := ::lTriggerAuxiliares      
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TikeT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TikeT.Cdx"
   oDataTable:cDescription := "Tickets de clientes"
   oDataTable:bCreateIndex := {| cPath | rxTpv( cPath ) }
   oDataTable:bCreateFile  := {| cPath | mkTpv( cPath ) }
   oDataTable:bSyncFile    := {|| SynTikCli( cPatEmp() ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "TikeL" )
   oDataTable:lTrigger     := ::lTriggerAuxiliares      
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TikeL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TikeL.Cdx"
   oDataTable:cDescription := "Líneas de tickets de clientes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "TikeP" )
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TikeP.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TikeP.Cdx"
   oDataTable:cDescription := "Pagos de tickets de clientes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "TikeS" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TikeS.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TikeS.Cdx"
   oDataTable:cDescription := "Series de tickets de clientes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "TikeM" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TikeM.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TikeM.Cdx"
   oDataTable:cDescription := "Mesas tickets de clientes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "TikeC" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TikeC.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TikeC.Cdx"
   oDataTable:cDescription := "Pagos de tickets de clientes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "TiketImp" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TiketImp.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TiketImp.Cdx"
   oDataTable:cDescription := "Log de impresión de tickets de clientes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "TpvMenus" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TpvMenus.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TpvMenus.Cdx"
   oDataTable:cDescription := "Menus para TPV"
   ::AddEmpresaTable( oDataTable  )

   oDataTable              := TDataTable():New( "TpvMnuArt" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TpvMnuArt.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TpvMnuArt.Cdx"
   oDataTable:cDescription := "Artículos para menus de TPV"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "TpvMnuOrd" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TpvMnuOrd.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TpvMnuOrd.Cdx"
   oDataTable:cDescription := "Ordenes para menus de TPV"
   ::AddEmpresaTable( oDataTable )

   /*
   Salas de venta--------------------------------------------------------------
   */

   oDataTable              := TDataTable():New( "SalaVta" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "SalaVta.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "SalaVta.Cdx"
   oDataTable:cDescription := "Salas de ventas"
   oDataTable:bCreateFile  := {| cPath | TSalaVenta():buildfiles(cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "SlaPnt" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "SlaPnt.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "SlaPnt.Cdx"
   oDataTable:cDescription := "Puntos de la sala de ventas"
   oDataTable:bCreateFile  := {| cPath | TDetSalaVenta():buildfiles(cPath ) }
   ::AddEmpresaTable( oDataTable )

   /*
   Produccion------------------------------------------------------------------
   */

   oDataTable              := TDataTable():New( "ProCab" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ProCab.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ProCab.Cdx"
   oDataTable:cDescription := "Producción"
   oDataTable:bCreateFile  := {| cPath | TProduccion():buildfiles(cPath ) }
   oDataTable:hDefinition  := TProduccion():DefineHash()
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "ProLin" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ProLin.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ProLin.Cdx"
   oDataTable:cDescription := "Líneas de producción"
   oDataTable:bCreateFile  := {| cPath | TDetProduccion():buildfiles(cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "ProSer" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ProSer.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ProSer.Cdx"
   oDataTable:cDescription := "Series de producción"
   oDataTable:bCreateFile  := {| cPath | TDetSeriesProduccion():buildfiles(cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "ProMat" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ProMat.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ProMat.Cdx"
   oDataTable:cDescription := "Materiales de producción"
   oDataTable:bCreateFile  := {| cPath | TDetMaterial():buildfiles(cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "ProMaq" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ProMaq.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ProMaq.Cdx"
   oDataTable:cDescription := "Producción"
   oDataTable:bCreateFile  := {| cPath | TDetMaquina():buildfiles(cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "MaqCosT" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "MaqCosT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "MaqCosT.Cdx"
   oDataTable:cDescription := "Producción"
   oDataTable:bCreateFile  := {| cPath | TMaquina():buildfiles(cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "MaqCosL" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "MaqCosL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "MaqCosL.Cdx"
   oDataTable:cDescription := "Producción"
   oDataTable:bCreateFile  := {| cPath | TDetCostes():buildfiles(cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "Costes" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Costes.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Costes.Cdx"
   oDataTable:cDescription := "Producción"
   oDataTable:bCreateFile  := {| cPath | TCosMaq():buildfiles(cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "ProPer" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ProPer.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ProPer.Cdx"
   oDataTable:bCreateFile  := {| cPath | TDetPersonal():buildfiles(cPath ) }
   oDataTable:cDescription := "Producción"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "OpeT" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "OpeT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "OpeT.Cdx"
   oDataTable:cDescription := "Producción"
   oDataTable:bCreateFile  := {| cPath | TOperarios():buildfiles(cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "OpeL" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "OpeL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "OpeL.Cdx"
   oDataTable:cDescription := "Producción"
   oDataTable:bCreateFile  := {| cPath | TDetHoras():buildfiles(cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "Operacio" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Operacio.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Operacio.Cdx"
   oDataTable:cDescription := "Producción"
   oDataTable:bCreateFile  := {| cPath | TOperacion():buildfiles(cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "Seccion" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Seccion.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Seccion.Cdx"
   oDataTable:cDescription := "Producción"
   oDataTable:bCreateFile  := {| cPath | TSeccion():buildfiles(cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "Horas" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Horas.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Horas.Cdx"
   oDataTable:cDescription := "Producción"
   oDataTable:bCreateFile  := {| cPath | THoras():buildfiles(cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "ProHPer" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ProHPer.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ProHPer.Cdx"
   oDataTable:cDescription := "Producción"
   oDataTable:bCreateFile  := {| cPath | TDetHorasPersonal():buildfiles(cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "MatSer" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "MatSer.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "MatSer.Cdx"
   oDataTable:cDescription := "Producción"
   oDataTable:bCreateFile  := {| cPath | TDetMaterial():buildfiles(cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "TipOpera" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TipOpera.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TipOpera.Cdx"
   oDataTable:cDescription := "Producción"
   oDataTable:bCreateFile  := {| cPath | TTipOpera():buildfiles(cPath ) }
   ::AddEmpresaTable( oDataTable )

   /*
   Ordenes de carga------------------------------------------------------------
   */

   oDataTable              := TDataTable():New( "OrdCarP" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "OrdCarP.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "OrdCarP.Cdx"
   oDataTable:cDescription := "Ordenes de carga"
   oDataTable:bCreateFile  := {| cPath | TOrdCarga():buildfiles(cPath ) }
   oDataTable:bSyncFile    := {|| SynOrdCar( cPatEmp() ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "OrdCarL" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "OrdCarL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "OrdCarL.Cdx"
   oDataTable:cDescription := "Ordenes de carga"
   oDataTable:bCreateFile  := {| cPath | TDetOrdCar():buildfiles(cPath ) }
   ::AddEmpresaTable( oDataTable )

   /*
   Expedientes-----------------------------------------------------------------
   */

   oDataTable              := TDataTable():New( "ExpCab" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ExpCab.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ExpCab.Cdx"
   oDataTable:cDescription := "Expedientes"
   oDataTable:bCreateFile  := {| cPath | TExpediente():buildfiles(cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "ExpDet" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ExpDet.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ExpDet.Cdx"
   oDataTable:cDescription := "Expedientes"
   oDataTable:bCreateFile  := {| cPath | TDetActuacion():buildfiles(cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "TipExpT" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TipExpT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TipExpT.Cdx"
   oDataTable:cDescription := "Expedientes"
   oDataTable:bCreateFile  := {| cPath | TTipoExpediente():buildfiles(cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "TipExpL" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TipExpL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TipExpL.Cdx"
   oDataTable:cDescription := "Expedientes"
   oDataTable:bCreateFile  := {| cPath | TDetTipoExpediente():buildfiles(cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "Entidades" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Entidades.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Entidades.Cdx"
   oDataTable:cDescription := "Expedientes"
   oDataTable:bCreateFile  := {| cPath | TEntidades():buildfiles(cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "Colaboradores" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Colaboradores.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Colaboradores.Cdx"
   oDataTable:cDescription := "Expedientes"
   oDataTable:bCreateFile  := {| cPath | TColaboradores():buildfiles(cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "Actuaciones" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Actuaciones.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Actuaciones.Cdx"
   oDataTable:cDescription := "Expedientes"
   oDataTable:bCreateFile  := {| cPath | TActuaciones():buildfiles(cPath ) }
   ::AddEmpresaTable( oDataTable )

   /*
   Envios----------------------------------------------------------------------
   */

   oDataTable              := TDataTable():New( "SndLog" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "SndLog.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "SndLog.Cdx"
   oDataTable:cDescription := "Envios y recepción"
   oDataTable:bCreateFile  := {| cPath | TSndRecInf():buildfiles(cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "SndFil" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "SndFil.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "SndFil.Cdx"
   oDataTable:cDescription := "Envios y recepción"
   ::AddEmpresaTable( oDataTable )

   /*
   Reportes----------------------------------------------------------------------
   */

   oDataTable              := TDataTable():New( "CfgCar" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "CfgCar.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "CfgCar.Cdx"
   oDataTable:cDescription := "Reportes"
   oDataTable:bCreateFile  := {| cPath | mkReport( cPath ) }
   oDataTable:bCreateIndex := {| cPath | rxReport( cPath ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "CfgFav" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "CfgFav.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "CfgFav.Cdx"
   oDataTable:cDescription := "Reportes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable():New( "Scripts" )
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Scripts.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Scripts.Cdx"
   oDataTable:cDescription := "Reportes"
   oDataTable:bCreateFile  := {| cPath | TScripts():buildfiles(cPath ) }
   ::AddEmpresaTable( oDataTable )

   // Objetos -----------------------------------------------------------------

   ::AddEmpresaObject( TGrpCli():Create( cPatCli() ) )

   ::AddEmpresaObject( TGrpPrv():Create( cPatPrv() ) )

   ::AddEmpresaObject( UniMedicion():Create() )

   ::AddEmpresaObject( TBancos():Create() )

   ::AddEmpresaObject( TNewImp():Create() )

   oDataTable              := TDetCamposExtra():Create()
   oDataTable:cName        := "CamposExtraHeader"
   ::AddEmpresaObject( oDataTable )

   oDataTable              := TDetCamposExtra():Create()
   oDataTable:cName        := "CamposExtraLine"
   ::AddEmpresaObject( oDataTable )

   ::AddEmpresaObject( TCentroCoste():Create() )

   ::AddEmpresaObject( TStock():Create( cPatEmp() ) )

   ::AddEmpresaObject( CodigosPostales():Create( cPatDat() ) )

   ::AddEmpresaObject( TBandera():New() )

   if !isReport()
      ::AddEmpresaObject( TPrestaShopId():Create() )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD BuildTrigger()

   with object ( TAuditor() )
      :Create( cPatDat() )
   end with

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CreateOperationLogTable()

   local cSqlStatement

   if file( cPatADS(.t.) + "SqlOperationLog.adt" )
      ferase( cPatADS(.t.) + "SqlOperationLog.adt" )
   end if

   // cSqlStatement         := 'DROP TABLE SqlOperationLog'
   // ::ExecuteSqlStatement( cSqlStatement, "OperationLog", ADS_ADT )

   cSqlStatement         := 'CREATE TABLE SqlOperationLog (' + CRLF
   cSqlStatement         +=    'ID AUTOINC CONSTRAINT NOT NULL,'               + CRLF
   cSqlStatement         +=    'DATETIME TIMESTAMP CONSTRAINT NOT NULL,'       + CRLF
   cSqlStatement         +=    'USERNAME CHAR(50) CONSTRAINT NOT NULL,'        + CRLF
   cSqlStatement         +=    'APPNAME CHAR(50),'                             + CRLF
   cSqlStatement         +=    'TABLENAME CHAR(150) CONSTRAINT NOT NULL,'      + CRLF
   cSqlStatement         +=    'OPERATION CHAR(6) CONSTRAINT NOT NULL )'       + CRLF
   cSqlStatement         +=    'IN DATABASE;' + CRLF

Return ( ::ExecuteSqlStatement( cSqlStatement, "OperationLog", ADS_ADT ) )

//---------------------------------------------------------------------------//

METHOD CreateColumnLogTable()

   local cSqlStatement

   if file( cPatADS(.t.) + "SqlColumnLog.adt" )
      ferase( cPatADS(.t.) + "SqlColumnLog.adt" )
   end if

   // cSqlStatement         := 'DROP TABLE SqlColumnLog'
   // ::ExecuteSqlStatement( cSqlStatement, "ColumnLog", ADS_ADT )

   cSqlStatement         := 'CREATE TABLE SqlColumnLog (' + CRLF
   cSqlStatement         +=    'ID AUTOINC CONSTRAINT NOT NULL,'            + CRLF
   cSqlStatement         +=    'OPERATIONID INTEGER CONSTRAINT NOT NULL,'   + CRLF
   cSqlStatement         +=    'COLUMNNAME CHAR(50) CONSTRAINT NOT NULL,'   + CRLF
   cSqlStatement         +=    'USERNAME CHAR(50) CONSTRAINT NOT NULL,'     + CRLF
   cSqlStatement         +=    'APPNAME CHAR(50),'                          + CRLF
   cSqlStatement         +=    'TABLENAME CHAR(150) CONSTRAINT NOT NULL,'   + CRLF
   cSqlStatement         +=    'OLDVALUE CHAR(250),'                        + CRLF
   cSqlStatement         +=    'NEWVALUE CHAR(250) )'                       + CRLF
   cSqlStatement         +=    'IN DATABASE;'                               + CRLF

Return ( ::ExecuteSqlStatement( cSqlStatement, "ColumnLog", ADS_ADT ) )

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

      ::oBrwOperation                        := IXBrowse():New( ::oFldAuditor:aDialogs[1] )

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

      ::oBrwColumn                        := IXBrowse():New( ::oFldAuditor:aDialogs[1] )

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

      ::oBrwBlocks                        := IXBrowse():New( ::oFldAuditor:aDialogs[2] )

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

      ::aProgress[ 1 ]  := TApoloMeter():ReDefine( 200, { | u | if( pCount() == 0, ::nProgress[ 1 ], ::nProgress[ 1 ] := u ) }, 10, ::oDlg, .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )
      ::aProgress[ 2 ]  := TApoloMeter():ReDefine( 210, { | u | if( pCount() == 0, ::nProgress[ 2 ], ::nProgress[ 2 ] := u ) }, 10, ::oDlg, .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )
      ::aProgress[ 3 ]  := TApoloMeter():ReDefine( 220, { | u | if( pCount() == 0, ::nProgress[ 3 ], ::nProgress[ 3 ] := u ) }, 10, ::oDlg, .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )

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
   ::oDlg:bValid  := {|| .f. }

   CursorWait()

   ::BuildData()

   ::BuildEmpresa()

   ::Reindex()

   ::Syncronize()
    
   CursorWE()

   msgInfo( "Proceso finalizado con exito.")

   ::oDlg:bValid  := {|| .t. }
   ::oDlg:Enable()
   ::oDlg:End()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Reindex()

   local oTable
   local cAlias

   dbCloseAll()

   ::DisableTriggers()

   // Bases de datos de directorio datos------------------------------------------

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

         sysrefresh() 

      next

   end if   

   // Bases de datos de empresa---------------------------------------------------

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

         sysrefresh() 

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
         ::aProgress[ 3 ]:SetTotal( len( ::aEmpresaTables ) + len( ::aDataTables ) )
      end if 

      for each oTable in ::aDataTables

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
/*
      if !empty( oTable:adsCreateIndex )
         eval( oTable:adsCreateIndex )
      else
*/      
         dbusearea( .t., ( cDriver() ), ( oTable:cName ), "Table", .f. )
         if !neterr() .and. ( "Table" )->( used() )
            ( "Table" )->( ordsetfocus( 1 ) )
            ( "Table" )->( adsReindex() )
            ( "Table" )->( dbclosearea() )
         end if 
//    end if 

   RECOVER USING oError

      msgStop( ErrorMessage( oError ) + CRLF + oTable:Say(), 'Imposible regenerar indices' )

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

      oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

      USE ( cOld + ".Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OLD", @dbfOld ) )
      if NetErr()
         msgStop( cOld + ".Dbf", "Error de apertura " )
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
      
         aeval( aField, {| nFld, i | if( nFld != 0, ( dbfTmp )->( FieldPut( nFld, ( dbfOld )->( FieldGet( i ) ) ) ), ) } )
      
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

   setIndexToADSCDX()

   ::BuildData()

   ::BuildEmpresa()

   // Creamos las nuesvas estructuras------------------------------------------

   for each oTable in ::aDataTables

      ::oMsg:SetText( "Eliminado tabla del diccionario : " + oTable:cDescription )
      ::deleteTableFromDataDictionary( oTable )

      ::oMsg:SetText( "Añadiendo tabla al diccionario de datos : " + oTable:cDescription )
      ::AddTableToDataDictionary( oTable )

      ::oMsg:SetText( "Reindexando : " + oTable:cDescription )
      ::ReindexTable( oTable )

   next 

   for each oTable in ::aEmpresaTables

      ::oMsg:SetText( "Eliminado tabla del diccionario : " + oTable:cDescription )
      ::deleteTableFromDataDictionary( oTable )

      ::oMsg:SetText( "Añadiendo tabla al diccionario de datos : " + oTable:cDescription )
      ::AddTableToDataDictionary( oTable )

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

METHOD SqlCreateIndex( tableName, indexName, tagName, Expression, Condition, Options, PageSize )

   local cStm              

   tableName            := quoted( tableName )

   if empty( indexName )
      indexName         := "N"
   else
      indexName         := quoted( indexName )
   end if
   tagName              := quoted( tagName )
   Expression           := quoted( Expression )

   if empty( Condition )
      Condition         := "NULL"
   else
      Condition         := quoted( Condition )
   end if 

   if empty( Options )
      Options           := alltrim( str( 2 ) )
   else
      Options           := alltrim( str( Options ) )
   end if 

   if empty( PageSize )
      PageSize          := alltrim( str( 2048 ) )
   else
      PageSize          := alltrim( str( PageSize ) )
   end if 

   cStm                 := "EXECUTE PROCEDURE sp_CreateIndex( " + tableName + ", " + indexName + ", " + tagName + ", " + Expression + ", " +  Condition + ", " + Options + ", " + PageSize + " );"

RETURN ( ::ExecuteSqlStatement( cStm, "CreateIndex" ) )

//---------------------------------------------------------------------------//

METHOD ExecuteSqlStatement( cSql, cSqlStatement, hStatement )

   local lOk
   local nError
   local oError
   local oBlock
   local cErrorAds

   DEFAULT cSqlStatement   := "ADSArea" // + alltrim( strtran( str( seconds() ), ".", "" ) )
   DEFAULT hStatement      := ADS_CDX

   if hStatement == ADS_ADT
      msgalert( cSql, "ADS_ADT" )
   end if 

   CursorWait()

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::CloseArea( cSqlStatement )

      ADSCacheOpenCursors( 0 )

      dbSelectArea( 0 )

      lOk                  := ADSCreateSQLStatement( cSqlStatement, hStatement )
      if lOk
   
         lOk               := ADSExecuteSQLDirect( cSql )
         if !lOk
            nError         := AdsGetLastError( @cErrorAds )
            msgStop( "Error : " + Str( nError) + "[" + cErrorAds + "]" + CRLF +  ;
                     "SQL : " + cSql                                             ,;
                     'ERROR en AdsExecuteSqlDirect' )
         endif
   
      else
   
         nError            := AdsGetLastError( @cErrorAds )
         msgStop( "Error : " + Str( nError) + "[" + cErrorAds + "]" + CRLF +  ;
                  "SQL : " + cSql                                             ,;
                  'ERROR en ADSCreateSQLStatement' )
   
      end if
   
      if lOk 
         ADSCacheOpenCursors( 0 )
         ADSClrCallBack()
      endif

   RECOVER USING oError
      msgStop( ErrorMessage( oError ), "Error en sentencia SQL" )
   END SEQUENCE
   ErrorBlock( oBlock )

   CursorWE()

RETURN ( lOk )

//---------------------------------------------------------------------------//

METHOD ExecuteSqlDirect( cSql )

   local lOk
   local nError
   local cErrorAds

   lOk               := ADSExecuteSQLDirect( cSql )
   if !lOk
      nError         := AdsGetLastError( @cErrorAds )
      msgStop( "Error : " + Str( nError) + "[" + cErrorAds + "]" + CRLF +  ;
               "SQL : " + cSql                                             ,;
               'ERROR en AdsExecuteSqlDirect' )
   endif

RETURN ( lOk )

//---------------------------------------------------------------------------//

METHOD selectSATFromClient( cCodigoCliente, cAnno, cCodigoArticulo )

   local cStm

   /*
   Creamos la instruccion------------------------------------------------------
   */

   cStm           := "SELECT lineasSat.cRef, "           
   cStm           +=          "lineasSat.cSerSat, "
   cStm           +=          "lineasSat.nNumSat, "
   cStm           +=          "lineasSat.cSufSat, "
   cStm           +=          "lineasSat.nCntAct, "
   cStm           +=          "lineasSat.mObsLin, "
   cStm           +=          "cabeceraSat.dFecSat, "
   cStm           +=          "cabeceraSat.cSerSat, "
   cStm           +=          "cabeceraSat.cCodOpe, "
   cStm           +=          "cabeceraSat.cCodEst, "
   cStm           +=          "cabeceraSat.cSituac, "
   cStm           +=          "operario.cNomTra, "
   cStm           +=          "estadoSat.cNombre, "
   cStm           +=          "estadoSat.cTipo, "
   cStm           +=          "articulos.Nombre, " 
   cStm           +=          "articulos.cDesUbi " 
   cStm           += "FROM " + cPatEmp() + "SatCliL lineasSat "
   cStm           += "INNER JOIN " + cPatEmp() + "SatCliT cabeceraSat on lineasSat.cSerSat = cabeceraSat.cSerSat and lineasSat.nNumSat = cabeceraSat.nNumSat and lineasSat.cSufSat = cabeceraSat.cSufSat "
   cStm           += "LEFT JOIN " + cPatEmp() + "OpeT operario on cabeceraSat.cCodOpe = operario.cCodTra "
   cStm           += "LEFT JOIN " + cPatEmp() + "EstadoSat estadoSat on cabeceraSat.cCodEst = estadoSat.cCodigo "
   cStm           += "LEFT JOIN " + cPatEmp() + "Articulo articulos on lineasSat.cRef = articulos.Codigo "

   if empty( cAnno )
      cStm        += "WHERE lineasSat.cCodCli = '" + alltrim( cCodigoCliente ) + "' AND lineasSat.cRef = '" + cCodigoArticulo + "' "
   else
      cStm        += "WHERE lineasSat.cCodCli = '" + alltrim( cCodigoCliente ) + "' AND YEAR( lineasSat.dFecSat ) = " + cAnno + " "
   end if 

   cStm           += "ORDER BY lineasSat.cRef, lineasSat.dFecSat DESC"

RETURN ( ::ExecuteSqlStatement( cStm, "SatCli" ) )

//---------------------------------------------------------------------------//
 
METHOD treeProductFromSAT()

   local oTree
   local cCodigoArticulo   

   if !SatCli->( used() )
      RETURN ( nil )
   end if

   SatCli->( dbgotop() )

   TreeInit()
   oTree                   := TreeBegin()

      while !SatCli->( eof() )
         
         if empty( cCodigoArticulo )
            TreeAddItem( SatCli->cRef ):Cargo     := hashRecord( "SatCli" )
            TreeBegin()
            cCodigoArticulo   := SatCli->cRef

         else

            if cCodigoArticulo != SatCli->cRef
               TreeEnd()
               cCodigoArticulo   := SatCli->cRef
               TreeAddItem( SatCli->cRef ):Cargo  := hashRecord( "SatCli" )
               TreeBegin(,)
            endif

         endif 

         if SatCli->cRef == cCodigoArticulo
            TreeAddItem( SatCli->cRef ):Cargo     := hashRecord( "SatCli" )
         endif

         SatCli->( dbSkip() )

      end while

   TreeEnd()

   TreeEnd()

   SatCli->( dbgotop() )

RETURN ( oTree )

//---------------------------------------------------------------------------//

METHOD selectSATFromArticulo( cCodigoArticulo )

   local cStm

   /*
   Creamos la instruccion------------------------------------------------------
   */

   cStm           := "SELECT lineasSat.cRef        AS codigoArticulo, "           
   cStm           +=          "lineasSat.cSerSat   AS serieLineaSAT, "
   cStm           +=          "lineasSat.nNumSat   AS numeroLineaSAT, "
   cStm           +=          "lineasSat.cSufSat   AS sufijoLineaSAT, "
   cStm           +=          "lineasSat.mObsLin   AS observacionesLineaSAT, "
   cStm           +=          "lineasSat.nCntAct   AS contadorLineaSAT, "
   cStm           +=          "cabeceraSat.dFecSat AS fechaSAT, "
   cStm           +=          "cabeceraSat.cCodOpe, "
   cStm           +=          "cabeceraSat.cCodEst, "
   cStm           +=          "cabeceraSat.cSituac, "
   cStm           +=          "cabeceraSat.cHorIni AS horaInicioSAT, "
   cStm           +=          "cabeceraSat.cHorFin AS horaFinSAT, "
   cStm           +=          "operario.cNomTra    AS operarioNombre, "
   cStm           +=          "estadoSat.cNombre   AS nombreEstado, "
   cStm           +=          "estadoSat.cTipo     AS tipoEstadoSAT, "
   cStm           +=          "articulos.cDesUbi   AS ubicacionArticulo, "
   cStm           +=          "clientes.titulo     AS clienteNombre " 

   cStm           += "FROM " + cPatEmp() + "SatCliL lineasSat "
   
   cStm           += "INNER JOIN " + cPatEmp() + "SatCliT   cabeceraSat on lineasSat.cSerSat = cabeceraSat.cSerSat and lineasSat.nNumSat = cabeceraSat.nNumSat and lineasSat.cSufSat = cabeceraSat.cSufSat "
   
   cStm           += "LEFT JOIN " + cPatEmp() + "EstadoSat  estadoSat on cabeceraSat.cCodEst = estadoSat.cCodigo "
   cStm           += "LEFT JOIN " + cPatEmp() + "OpeT       operario on cabeceraSat.cCodOpe = operario.cCodTra "
   cStm           += "LEFT JOIN " + cPatEmp() + "Articulo   articulos on lineasSat.cRef = articulos.Codigo "
   cStm           += "LEFT JOIN " + cPatCli() + "Client     clientes on cabeceraSat.cCodCli = clientes.Cod "

   cStm           += "WHERE lineasSat.cRef = '" + alltrim( cCodigoArticulo ) + "' "

   cStm           += "ORDER BY lineasSat.cRef, lineasSat.dFecSat DESC"

RETURN ( ::ExecuteSqlStatement( cStm, "SatCliArticulos" ) )

//---------------------------------------------------------------------------//

METHOD ConvertDatosToSQL()

   SQLTiposImpresorasModel();
      :New();
      :makeImportDbfSQL()

   SQLSituacionesModel();
      :New();
      :makeImportDbfSQL()

   SQLTiposVentasModel();
      :New();
      :makeImportDbfSQL()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ConvertEmpresaToSQL()

   SQLEtiquetasModel();
      :New();
      :makeImportDbfSQL()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD MigrateEmpresaToSQL()

   TransaccionesComercialesLineasModel() ;
      :TranslateSATClientesLineasCodigoTiposVentaToId() ;
      :TranslatePresupuestoClientesLineasCodigoTiposVentaToId() ;
      :TranslatePedidosClientesLineasCodigoTiposVentaToId() ;
      :TranslateAlbaranesClientesLineasCodigoTiposVentaToId() ;
      :TranslateFacturasClientesLineasCodigoTiposVentaToId() ;
      :TranslateFacturasRectificativasLineasCodigoTiposVentaToId()

RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TDataTable

   DATA  cName
   DATA  cArea
   DATA  cPath
   DATA  cAlias
   DATA  cDataFile
   DATA  cIndexFile
   DATA  cDescription         INIT ""
   DATA  aStruct    
   DATA  lTrigger             INIT .f.
   DATA  hDefinition 
   DATA  bSyncFile   
   DATA  bCreateFile
   DATA  bCreateIndex
   DATA  adsCreateIndex   
   DATA  aDictionary
   DATA  hIndex         
   DATA  aDefaultValue
   DATA  bId

   DATA  cShortDataFile
   DATA  cShortIndexFile

   DATA  cFullADSDataFile
   DATA  cFullADSIndexFile
   DATA  cFullCdxDataFile
   DATA  cFullCdxIndexFile

   METHOD New( cArea )

   METHOD Name()              INLINE ( ::cPath + ::cArea )
   METHOD NameTable()         INLINE ( ::cArea + ".Dbf" )
   METHOD NameIndex()         INLINE ( ::cArea + ".Cdx" )

   METHOD cFileName()         INLINE ( Upper( ::cArea ) )

   METHOD getDataBase( cDriver )

   METHOD msgInfo()           INLINE ( msgInfo( ::Say() ) )

   METHOD Say()               INLINE ( "cArea"              + " : "  +  ::cArea               + CRLF +;
                                       "cName"              + " : "  +  ::cName               + CRLF +;
                                       "cShortDataFile"     + " : "  +  ::cShortDataFile     + CRLF +;
                                       "cShortIndexFile"    + " : "  +  ::cShortIndexFile    + CRLF +;
                                       "cFullADSDataFile"   + " : "  +  ::cFullADSDataFile    + CRLF +;
                                       "cFullADSIndexFile"  + " : "  +  ::cFullADSIndexFile   + CRLF +;
                                       "cFullCdxDataFile"   + " : "  +  ::cFullCdxDataFile    + CRLF +;
                                       "cFullCdxIndexFile"  + " : "  +  ::cFullCdxIndexFile   + CRLF +;
                                       "cDataFile"          + " : "  +  ::cDataFile           + CRLF +;
                                       "cIndexFile"         + " : "  +  ::cIndexFile          + CRLF +;
                                       "cDescription"       + " : "  +  ::cDescription )

   METHOD setAlias( cAlias )  INLINE ( ::cAlias := cAlias )
   METHOD getAlias()          INLINE ( ::cAlias )

   METHOD getDictionary()     INLINE ( ::aDictionary )
   METHOD getIndex()          INLINE ( ::hIndex )

   METHOD checkArea( area )   INLINE ( cCheckArea( ::cArea, @area ) )

   METHOD getName()           INLINE ( ::cName )

END CLASS

//---------------------------------------------------------------------------//

   METHOD New( cArea, cPath ) CLASS TDataTable

      DEFAULT cPath           := cPathEmpresa()

      ::cArea                 := cArea
      ::cPath                 := cPath
      ::cName                 := Upper( cPath + cArea )

      ::cShortDataFile        := cPath + "\" + ::NameTable()
      ::cShortIndexFile       := cPath + "\" + ::NameIndex()

      ::cFullAdsDataFile      := cAdsUNC() + ::cShortDataFile 
      ::cFullAdsIndexFile     := cAdsUNC() + ::cShortIndexFile 

      ::cFullCdxDataFile      := fullCurDir() + ::cShortDataFile 
      ::cFullCdxIndexFile     := fullCurDir() + ::cShortIndexFile 

   Return ( Self )

//---------------------------------------------------------------------------//

   METHOD getDataBase( cDriver ) CLASS TDataTable

      if isADSDriver( cDriver )
         Return ( ::cName )
      end if 

   Return ( ::cFullCdxDataFile ) 

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

   if !AdsisTableInDataDictionary( cTableName )
      if !AdsDDaddTable( cTableName, cTableDatabase, cTableIndex )
         lAddTable   := .f.
         msgInfo( "Error adding table : " + cValToChar( adsGetLastError( @cError ) ), cError )
      end if
   end if

Return ( lAddTable )

//--------------------------------------------------------------------------//

Function adsIsTableInDataDictionary( cTable )

   local aAdsTables

   if Empty( aAdsTables )
      aAdsTables  := AdsDirectory()
   end if

Return ( aScan( aAdsTables, {|c| Left( Upper( c ), len( c ) - 1 ) == Upper( cTable ) } ) != 0 )

//--------------------------------------------------------------------------//

Function adsSelectSQLScript( cScript )

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

      if !ADSCreateSQLStatement( cSqlAlias, ADS_CDX ) 

         ( cSqlAlias )->( dbCloseArea() )

         MsgStop( "AdsCreateSqlStatement() failed with error " + cValToChar( ADSGetLastError() ) )

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
/*
#pragma BEGINDUMP

#include "hbvm.h"
#include "hbapi.h"
#include "hbapiitm.h"
#include "hbapierr.h"
#include "hbapilng.h"
#include "hbstack.h"
#include "hbdate.h"

#include "rddsys.ch"
#include "rddads.h"

UNSIGNED32 ENTRYPOINT AdsReindex61( ADSHANDLE hTbl, UNSIGNED32 ulPageSize ); 

HB_FUNC( ADSREINDEX61 )
{
   ADSAREAP pArea = hb_adsGetWorkAreaPointer();

   hb_retl( AdsReindex61( pArea ? pArea->hTable : ( ADSHANDLE ) -1, hb_parnl( 1 ) ) == AE_SUCCESS );
}

#pragma ENDDUMP
*/


//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---Clases de prg que vamos quitando pero que todavia hace falta------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TRemMovAlm FROM TMasDet

   METHOD DefineFiles()

END CLASS

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath ) CLASS TRemMovAlm

   local oDbf

   DEFAULT cPath  := ::cPath

   DEFINE DATABASE oDbf FILE "REMMOVT.DBF" CLASS "TRemMovT" ALIAS "RemMovT" PATH ( cPath ) VIA ( cDriver() ) COMMENT "Movimientos de almacén"

      FIELD NAME "lSelDoc"  TYPE "L" LEN  1  DEC 0                                  COMMENT ""                             OF oDbf
      FIELD NAME "nNumRem"  TYPE "N" LEN  9  DEC 0 PICTURE "999999999"              COMMENT "Número"           COLSIZE 80  OF oDbf
      FIELD NAME "cSufRem"  TYPE "C" LEN  2  DEC 0 PICTURE "@!"                     COMMENT "Delegación"       COLSIZE 40  OF oDbf
      FIELD NAME "nTipMov"  TYPE "N" LEN  1  DEC 0                                  COMMENT "Tipo del movimiento"          OF oDbf
      FIELD NAME "cCodUsr"  TYPE "C" LEN  3  DEC 0                                  COMMENT "Código usuario"               OF oDbf
      FIELD NAME "cCodDlg"  TYPE "C" LEN  2  DEC 0                                  COMMENT ""                             OF oDbf
      FIELD NAME "cCodAge"  TYPE "C" LEN  3  DEC 0                                  COMMENT "Código agente"                OF oDbf
      FIELD NAME "cCodMov"  TYPE "C" LEN  2  DEC 0                                  COMMENT "Tipo de movimiento"           OF oDbf
      FIELD NAME "dFecRem"  TYPE "D" LEN  8  DEC 0                                  COMMENT "Fecha"            COLSIZE 80  OF oDbf
      FIELD NAME "cTimRem"  TYPE "C" LEN  6  DEC 0 PICTURE "@R 99:99:99"            COMMENT "Hora"             COLSIZE 60  OF oDbf
      FIELD NAME "cAlmOrg"  TYPE "C" LEN 16  DEC 0 PICTURE "@!"                     COMMENT "Alm. org."        COLSIZE 60  OF oDbf
      FIELD NAME "cAlmDes"  TYPE "C" LEN 16  DEC 0 PICTURE "@!"                     COMMENT "Alm. des."        COLSIZE 60  OF oDbf
      FIELD NAME "cCodDiv"  TYPE "C" LEN  3  DEC 0 PICTURE "@!"                     COMMENT "Div."                         OF oDbf
      FIELD NAME "nVdvDiv"  TYPE "N" LEN 13  DEC 6 PICTURE "@E 999,999.999999"      COMMENT "Cambio de la divisa"          OF oDbf
      FIELD NAME "cComMov"  TYPE "C" LEN 100 DEC 0 PICTURE "@!"                     COMMENT "Comentario"       COLSIZE 240 OF oDbf
      FIELD NAME "nTotRem"  TYPE "N" LEN 16  DEC 6 PICTURE "@E 999,999,999,999.99"  COMMENT "Importe"          COLSIZE 100 OF oDbf
      FIELD NAME "lWait"    TYPE "L" LEN  1  DEC 0                                  COMMENT ""                             OF oDbf
      FIELD NAME "cGuid"    TYPE "C" LEN 40  DEC 0                                  COMMENT "Guid de la cabecera"          OF oDbf

      INDEX TO "RemMovT.Cdx" TAG "cNumRem"   ON "Str( nNumRem ) + cSufRem"          COMMENT "Número"           NODELETED   OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TDetMovimientos FROM TDet

   METHOD DefineFiles()

END CLASS

//---------------------------------------------------------------------------//


METHOD DefineFiles( cPath ) CLASS TDetMovimientos

   local oDbf

   DEFAULT cPath  := ::cPath

   DEFINE TABLE oDbf FILE "HisMov.dbf" CLASS "HisMov" ALIAS "HisMov" PATH ( cPath ) VIA ( cDriver() )

      FIELD NAME "dFecMov"    TYPE "D" LEN   8 DEC 0 COMMENT "Fecha movimiento"                    OF oDbf
      FIELD NAME "cTimMov"    TYPE "C" LEN   6 DEC 0 COMMENT "Hora movimiento"                     OF oDbf
      FIELD NAME "nTipMov"    TYPE "N" LEN   1 DEC 0 COMMENT "Tipo movimiento"                     OF oDbf
      FIELD NAME "cAliMov"    TYPE "C" LEN  16 DEC 0 COMMENT "Alm. ent."                           OF oDbf
      FIELD NAME "cAloMov"    TYPE "C" LEN  16 DEC 0 COMMENT "Alm. sal."                           OF oDbf
      FIELD NAME "cRefMov"    TYPE "C" LEN  18 DEC 0 COMMENT "Código"                              OF oDbf
      FIELD NAME "cNomMov"    TYPE "C" LEN  50 DEC 0 COMMENT "Nombre"                              OF oDbf
      FIELD NAME "cCodMov"    TYPE "C" LEN   2 DEC 0 COMMENT "TM"                                  OF oDbf
      FIELD NAME "cCodPr1"    TYPE "C" LEN  20 DEC 0 COMMENT "Código propiedad 1"                  OF oDbf
      FIELD NAME "cCodPr2"    TYPE "C" LEN  20 DEC 0 COMMENT "Código propiedad 2"                  OF oDbf
      FIELD NAME "cValPr1"    TYPE "C" LEN  20 DEC 0 COMMENT "Valor propiedad 1"                   OF oDbf
      FIELD NAME "cValPr2"    TYPE "C" LEN  20 DEC 0 COMMENT "Valor propiedad 2"                   OF oDbf
      FIELD NAME "dFecCad"    TYPE "D" LEN   8 DEC 0 COMMENT "Fecha caducidad"                     OF oDbf
      FIELD NAME "cCodUsr"    TYPE "C" LEN   3 DEC 0 COMMENT "Código usuario"                      OF oDbf
      FIELD NAME "cCodDlg"    TYPE "C" LEN   2 DEC 0 COMMENT "Código delegación"                   OF oDbf
      FIELD NAME "lLote"      TYPE "L" LEN   1 DEC 0 COMMENT "Lógico lote"                         OF oDbf
      FIELD NAME "nLote"      TYPE "N" LEN   9 DEC 0 COMMENT "Número de lote"                      OF oDbf
      FIELD NAME "cLote"      TYPE "C" LEN  14 DEC 0 COMMENT "Lote"                                OF oDbf
      FIELD NAME "nCajMov"    TYPE "N" LEN  19 DEC 6 COMMENT "Caj."                                OF oDbf
      FIELD NAME "nUndMov"    TYPE "N" LEN  19 DEC 6 COMMENT "Und."                                OF oDbf
      FIELD NAME "nCajAnt"    TYPE "N" LEN  19 DEC 6 COMMENT "Caj. ant."                           OF oDbf
      FIELD NAME "nUndAnt"    TYPE "N" LEN  19 DEC 6 COMMENT "Und. ant."                           OF oDbf
      FIELD NAME "nPreDiv"    TYPE "N" LEN  19 DEC 6 COMMENT "Precio"                              OF oDbf
      FIELD NAME "lSndDoc"    TYPE "L" LEN   1 DEC 0 COMMENT "Lógico enviar"                       OF oDbf
      FIELD NAME "nNumRem"    TYPE "N" LEN   9 DEC 0 COMMENT "Número remesa"                       OF oDbf
      FIELD NAME "cSufRem"    TYPE "C" LEN   2 DEC 0 COMMENT "Sufijo remesa"                       OF oDbf
      FIELD NAME "lSelDoc"    TYPE "L" LEN   1 DEC 0 COMMENT "Lógico selecionar"                   OF oDbf
      FIELD NAME "lNoStk"     TYPE "L" LEN   1 DEC 0 COMMENT "Lógico no stock"                     OF oDbf
      FIELD NAME "lKitArt"    TYPE "L" LEN   1 DEC 0 COMMENT "Línea con escandallo"                OF oDbf
      FIELD NAME "lKitEsc"    TYPE "L" LEN   1 DEC 0 COMMENT "Línea perteneciente a escandallo"    OF oDbf
      FIELD NAME "lImpLin"    TYPE "L" LEN   1 DEC 0 COMMENT "Lógico imprimir linea"               OF oDbf
      FIELD NAME "lKitPrc"    TYPE "L" LEN   1 DEC 0 COMMENT "Lógico precio escandallo"            OF oDbf
      FIELD NAME "nNumLin"    TYPE "N" LEN   9 DEC 0 COMMENT "Número de linea"                     OF oDbf
      FIELD NAME "mNumSer"    TYPE "M" LEN  10 DEC 0 COMMENT "Numeros de serie"                    OF oDbf
      FIELD NAME "nVolumen"   TYPE "N" LEN  16 DEC 6 COMMENT "Volumen del producto"                OF oDbf
      FIELD NAME "cVolumen"   TYPE "C" LEN   2 DEC 0 COMMENT "Unidad del volumen"                  OF oDbf
      FIELD NAME "nPesoKg"    TYPE "N" LEN  16 DEC 6 COMMENT "Peso del producto"                   OF oDbf
      FIELD NAME "cPesoKg"    TYPE "C" LEN   2 DEC 0 COMMENT "Unidad de peso del producto"         OF oDbf
      FIELD NAME "nBultos"    TYPE "N" LEN  16 DEC 0 COMMENT "Número de bultos en líneas"          OF oDbf
      FIELD NAME "cFormato"   TYPE "C" LEN 100 DEC 0 COMMENT "Formato de compra/venta"             OF oDbf
      FIELD NAME "lLabel"     TYPE "L" LEN   1 DEC 0 COMMENT "Lógico para imprimir etiqueta"       OF oDbf
      FIELD NAME "nLabel"     TYPE "N" LEN  16 DEC 6 COMMENT "Número de etiquetas a imprimir"      OF oDbf
      FIELD NAME "lWait"      TYPE "L" LEN   1 DEC 0 COMMENT "Lógico para documento no finalizado" OF oDbf
      FIELD NAME "cGuid"      TYPE "C" LEN  40 DEC 0 COMMENT "cGuid de las lineas"                 OF oDbf
      FIELD NAME "cGuidPar"   TYPE "C" LEN  40 DEC 0 COMMENT "cGuid de la cabecera"                OF oDbf

      INDEX TO "HisMov.Cdx"   TAG "cNumRem"    ON "str( nNumRem ) + cSufRem + Str( nNumLin )" NODELETED OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TDetSeriesMovimientos FROM TDet

   METHOD DefineFiles()

END CLASS

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath ) CLASS TDetSeriesMovimientos

   local oDbf

   DEFAULT cPath  := ::cPath

   DEFINE TABLE oDbf FILE "MovSer.dbf" CLASS ( "MovSer" ) ALIAS ( "MovSer" ) PATH ( cPath ) VIA ( cDriver() ) COMMENT "Números de serie de movimientos de almacen"

      FIELD NAME "nNumRem"    TYPE "N" LEN  9  DEC 0                                                     OF oDbf
      FIELD NAME "cSufRem"    TYPE "C" LEN  2  DEC 0                                                     OF oDbf
      FIELD NAME "dFecRem"    TYPE "D" LEN  8  DEC 0                                                     OF oDbf
      FIELD NAME "nNumLin"    TYPE "N" LEN 04  DEC 0 COMMENT "Número de línea"                           OF oDbf
      FIELD NAME "cCodArt"    TYPE "C" LEN 18  DEC 0 COMMENT "Artículo"                                  OF oDbf
      FIELD NAME "cAlmOrd"    TYPE "C" LEN 16  DEC 0 COMMENT "Almacén"                                   OF oDbf
      FIELD NAME "lUndNeg"    TYPE "L" LEN 01  DEC 0 COMMENT "Lógico de unidades en negativo"            OF oDbf
      FIELD NAME "cNumSer"    TYPE "C" LEN 30  DEC 0 COMMENT "Número de serie"                           OF oDbf
      FIELD NAME "cGuid"      TYPE "C" LEN  40 DEC 0 COMMENT "cGuid de las lineas"                       OF oDbf
      FIELD NAME "cGuidPar"   TYPE "C" LEN  40 DEC 0 COMMENT "cGuid de la cabecera"                      OF oDbf

      INDEX TO ( "MovSer.cdx" ) TAG "cNumRem" ON "Str( nNumRem ) + cSufRem + Str( nNumLin )"   NODELETED OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//--------------------------------------------------------------------------//
