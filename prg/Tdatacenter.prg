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

   DATA        aEmpresas                  INIT {}

   DATA        oDlg
   DATA        oBrwEmpresas

   DATA        oDlgAuditor
   DATA        oBrwOperation
   DATA        oBrwColumn

   DATA        oMtrActualiza
   DATA        nMtrActualiza              INIT 0

   DATA        oMtrDiccionario
   DATA        nMtrDiccionario            INIT 0

   DATA        oSayProceso
   DATA        cSayProceso                INIT ""

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

   METHOD DeleteAllTable()

   METHOD BuildData()
   METHOD BuildEmpresa()

   METHOD BuildTrigger()

   METHOD AddDataTable( oTable )          INLINE aAdd( ::aDataTables, oTable )
   METHOD AddEmpresaTable( oTable )       INLINE aAdd( ::aEmpresaTables, oTable )

   METHOD CreateOperationLogTable()
   METHOD CreateColumnLogTable()

   METHOD lAdministratorTask()
   METHOD StartAdministratorTask()

   METHOD Auditor()
   METHOD StartAuditor()                  VIRTUAL

   METHOD lValidOperationLog()
   METHOD lSelectOperationLog()

   METHOD lValidColumnLog()
   METHOD lSelectColumnLog()

   METHOD lCreaArrayPeriodos()
   METHOD lRecargaFecha()

   METHOD cEmpresaDescription( cTableName )
   METHOD cTableDescription( cTableName )
   METHOD cOperationDescription( cOperation )

   METHOD DisableTriggers()
   METHOD EnableTriggers()

   METHOD Resource( nId )
   METHOD Reindex()

   //---------------------------------------------------------------------------//

   INLINE METHOD oFacCliT()

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

   ENDMETHOD

   //------------------------------------------------------------------------//

   INLINE METHOD OpenFacCliT( dbf )

      local lOpen
      local cFilter

      USE ( cPatEmp() + "FacCliT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIT", @dbf ) )
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

/*      
      local lOpen
      local cSqlStatement

      dbf                     := cCheckArea( "FACCLIT" )

      if lAIS() 

         cSqlStatement        := "SELECT * FROM " + ( cPatEmp() + "FacCliT" ) 

         if !oUser():lAdministrador()
            
            cSqlStatement     += " WHERE cSufFac = '" + oUser():cDelegacion() + "' AND cCodCaj = '" + oUser():cCaja() + "'"
            if oUser():lFiltroVentas()         
               cSqlStatement  += " AND cCodUsr = '" + oUser():cCodigo() + "'"
            end if 

         end if 

         lOpen                := ADSRunSQL( @dbf, cSqlStatement )

      else

         USE ( cPatEmp() + "FacCliT.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( @dbf ) 
         SET ADSINDEX TO ( cPatEmp() + "FacCliT.Cdx" ) ADDITIVE

         lOpen                := !neterr()

      end if 

      Return ( lOpen )
*/
   
   ENDMETHOD

   //---------------------------------------------------------------------------//

   INLINE METHOD oFacCliP()

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

   ENDMETHOD

   //---------------------------------------------------------------------------//

   INLINE METHOD OpenFacCliP( dbf )

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

   ENDMETHOD

   //---------------------------------------------------------------------------//

   INLINE METHOD oAlbCliT()

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

   ENDMETHOD

   //---------------------------------------------------------------------------//

   INLINE METHOD OpenAlbCliT( dbf )

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

   ENDMETHOD

   //---------------------------------------------------------------------------//

   INLINE METHOD oPedCliT()

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

   ENDMETHOD

   //---------------------------------------------------------------------------//

   INLINE METHOD OpenPedCliT( dbf )

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
      
            cFilter     := "Field->cSufPed == '" + oUser():cDelegacion() + "' .and. Field->cCodCaj == '" + oUser():cCaja() + "'"
            if oUser():lFiltroVentas()         
               cFilter  += " .and. Field->cCodUsr == '" + oUser():cCodigo() + "'"
            end if 

            ( dbf )->( AdsSetAOF( cFilter ) )

         end if

      end if 

      Return ( lOpen )   

   ENDMETHOD

   //---------------------------------------------------------------------------//

   INLINE METHOD oSatCliT()

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

   ENDMETHOD

   //---------------------------------------------------------------------------//

   INLINE METHOD OpenSatCliT( dbf )

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

   ENDMETHOD

   //---------------------------------------------------------------------------//

   INLINE METHOD oPreCliT()

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

   ENDMETHOD

   //---------------------------------------------------------------------------//

   INLINE METHOD OpenPreCliT( dbf )

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

   ENDMETHOD

   //---------------------------------------------------------------------------//

END CLASS

//---------------------------------------------------------------------------//

METHOD lAdministratorTask()

   local dbfEmp

   lAIS( .f. )
   lCdx( .t. )

   ::aEmpresas       := {}

   /*
   Cargamos el array de las empresas----------------------------------------
   */

   USE ( cAdsUNC() + "Datos\Empresa.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "EMPRESA", @dbfEmp ) )
   SET ADSINDEX TO ( cAdsUNC() + "Datos\Empresa.Cdx" ) ADDITIVE

   while !( dbfEmp )->( eof() )
      if !( dbfEmp )->lGrupo
         aAdd( ::aEmpresas, { ( dbfEmp )->CodEmp, ( dbfEmp )->cNombre, ( dbfEmp )->lGrupo, .f., .f. } )
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

      REDEFINE SAY         ::oSayProceso ;
         PROMPT            ::cSayProceso ;
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

      ::oSayProceso:SetText( "Actualizando empresa " + Rtrim( cEmp[ 1 ] ) + " - " + Rtrim( cEmp[ 2 ] ) )

      ::oMtrActualiza:Set( hb_EnumIndex() )

      if cEmp[ 3 ]
         lActualizaGrupo( cEmp[ 1 ], cEmp[ 2 ] )
      else
         SetEmpresa( cEmp[ 1 ], , , , , , .t. )
         lActualiza( cEmp[ 1 ], , .t., cEmp[ 2 ], .f. )
      end if

      cEmp[ 4 ]      := .t.

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

      ::oSayProceso:SetText( "Eliminando tablas anteriores de diccionario de datos" )

      ::DeleteAllTable()

      /*
      Construimos la base de datos de estructura----------------------------
      */

      ::oSayProceso:SetText( "Creando arbol de tablas datos generales aplicación" )

      ::BuildData()
      ::CreateDataTable()

      /*
      Recorremos el array de las empresas par actualizarlas--------------------
      */

      ::oBrwEmpresas:GoTop()

      for each cEmp in ::aEmpresas

         ::oSayProceso:SetText( "Creando diccionario de empresa " + Rtrim( cEmp[ 1 ] ) + " - " + Rtrim( cEmp[ 2 ] ) )

         ::oMtrActualiza:Set( hb_EnumIndex() )

         SetEmpresa( cEmp[ 1 ], , , , , , .t. )

         ::BuildEmpresa()     
         ::CreateEmpresaTable()

         cEmp[ 5 ]   := .t.

         ::oBrwEmpresas:GoDown()
         ::oBrwEmpresas:Refresh()

      next

      ::oMtrDiccionario:Set( 2 )

      /*
      Creamos las tablas de operacioens----------------------------------------
      */

      ::oSayProceso:SetText( "Creando tablas de operaciones" )

      ::CreateOperationLogTable()

      ::CreateColumnLogTable()

      ::oMtrDiccionario:Set( 3 )

      /*
      Creamos los triggers de los datos----------------------------------------
      */

      ::oSayProceso:SetText( "Creando triggers de datos" )

      ::CreateDataTrigger()

      ::oMtrDiccionario:Set( 4 )

      /*
      Creamos los triggers de las empresas-------------------------------------
      */

      ::oSayProceso:SetText( "Creando triggers de empresa" )

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

   ::lAdsConnection     := AdsConnect60( ::cDataDictionaryFile, 2, "ADSSYS", "", , @::hAdsConnection )

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

   do case
   case IsObject( uTable )
      cTable         := Upper( uTable:cName )
   case IsChar( uTable )
      cTable         := Upper( uTable )
   end case

   if Empty( ::aDDTables )
      ::aDDTables    := AdsDirectory()
   end if

Return ( aScan( ::aDDTables, {|c| Left( Upper( c ), len( c ) - 1 ) == cTable } ) != 0 )

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

   dbSelectArea( 0 )

   if ADSCreateSQLStatement( ( Alltrim( oTable:cName ) ), 2 )

      lTrigger    := ADSExecuteSQLDirect( cTrigger )
      if !lTrigger

         nError   := AdsGetLastError( @cErrorAds )
         msgStop( cErrorAds + CRLF + cTrigger, 'ERROR CREATE TRIGGER en ADSExecuteSQLDirect' )

         Return ( Self )

      endif

   else

      nError      := AdsGetLastError( @cErrorAds )
      msgStop( cErrorAds + CRLF + cTrigger, 'ERROR CREATE TRIGGER en ADSCreateSQLStatement' )

   end if

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

   local nError
   local cTrigger
   local lTrigger
   local cErrorAds

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

   dbSelectArea( 0 )

   if ADSCreateSQLStatement( ( Alltrim( oTable:cName ) ), 2 )

      lTrigger    := ADSExecuteSQLDirect( cTrigger )
      if !lTrigger

         nError   := AdsGetLastError( @cErrorAds )
         msgStop( cErrorAds + CRLF + cTrigger, 'ERROR CREATE TRIGGER en ADSExecuteSQLDirect' )

         Return ( Self )

      endif

   else

      nError      := AdsGetLastError( @cErrorAds )
      msgStop( cErrorAds + CRLF + cTrigger, 'ERROR CREATE TRIGGER en ADSCreateSQLStatement' )

   end if

Return ( Self )

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

   local nError
   local cTrigger
   local lTrigger
   local cErrorAds

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

   dbSelectArea( 0 )

   if ADSCreateSQLStatement( ( Alltrim( oTable:cName ) ), 2 )

      lTrigger    := ADSExecuteSQLDirect( cTrigger )
      if !lTrigger

         nError   := AdsGetLastError( @cErrorAds )
         msgStop( cErrorAds + CRLF + cTrigger, 'ERROR CREATE TRIGGER en ADSExecuteSQLDirect' )

         Return ( Self )

      endif

   else

      nError      := AdsGetLastError( @cErrorAds )
      msgStop( cErrorAds + CRLF + cTrigger, 'ERROR CREATE TRIGGER en ADSCreateSQLStatement' )

   end if

Return ( Self )

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

METHOD AddTable( oTable )

   local cError
   local lAddTable      := .t.

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
            msgWait( "No existe " + ( oTable:cDataFile ), "Atención", 1 )
         end if

         if !file( oTable:cIndexFile )
            msgWait( "No existe " + ( oTable:cIndexFile ), "Atención", 1 )
         end if

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

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "Users"
   oDataTable:cDataFile    := cPatDat( .t. ) + "Users.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "Users.Cdx"
   oDataTable:cDescription := "Usuarios"
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "Mapas"
   oDataTable:cDataFile    := cPatDat( .t. ) + "Mapas.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "Mapas.Cdx"
   oDataTable:cDescription := "Mapas de usuarios"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "Cajas"
   oDataTable:cDataFile    := cPatDat( .t. ) + "Cajas.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "Cajas.Cdx"
   oDataTable:cDescription := "Cajas"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "CajasL"
   oDataTable:cDataFile    := cPatDat( .t. ) + "CajasL.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "CajasL.Cdx"
   oDataTable:cDescription := "Lineas de cajas"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "ImpTik"
   oDataTable:cDataFile    := cPatDat( .t. ) + "ImpTik.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "ImpTik.Cdx"
   oDataTable:cDescription := "Impresoras de comanda"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "Visor"
   oDataTable:cDataFile    := cPatDat( .t. ) + "Visor.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "Visor.Cdx"
   oDataTable:cDescription := "Visores"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "CajPorta"
   oDataTable:cDataFile    := cPatDat( .t. ) + "CajPorta.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "CajPorta.Cdx"
   oDataTable:cDescription := "Cajón portamonedas"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "TipImp"
   oDataTable:cDataFile    := cPatDat( .t. ) + "TipImp.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "TipImp.Cdx"
   oDataTable:cDescription := "Tipos de impresoras"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "Agenda"
   oDataTable:cDataFile    := cPatDat( .t. ) + "Agenda.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "Agenda.Cdx"
   oDataTable:cDescription := "Agenda"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "AgendaUsr"
   oDataTable:cDataFile    := cPatDat( .t. ) + "AgendaUsr.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "AgendaUsr.Cdx"
   oDataTable:cDescription := "Agenda"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "TipoNotas"
   oDataTable:cDataFile    := cPatDat( .t. ) + "TipoNotas.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "TipoNotas.Cdx"
   oDataTable:cDescription := "Tipos de notas"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "TVta"
   oDataTable:cDataFile    := cPatDat( .t. ) + "TVta.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "TVta.Cdx"
   oDataTable:cDescription := "Tipos de ventas"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "Divisas"
   oDataTable:cDataFile    := cPatDat( .t. ) + "Divisas.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "Divisas.Cdx"
   oDataTable:cDescription := "Divisas"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "TIva"
   oDataTable:cDataFile    := cPatDat( .t. ) + "TIva.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "TIva.Cdx"
   oDataTable:cDescription := "Tipos de impuestos"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "Empresa"
   oDataTable:cDataFile    := cPatDat( .t. ) + "Empresa.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "Empresa.Cdx"
   oDataTable:cDescription := "Empresa"
   oDataTable:lTrigger     := .f.
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
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
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "TblCnv"
   oDataTable:cDataFile    := cPatDat( .t. ) + "TblCnv.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "TblCnv.Cdx"
   oDataTable:cDescription := "Factor conversión"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "Captura"
   oDataTable:cDataFile    := cPatDat( .t. ) + "Captura.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "Captura.Cdx"
   oDataTable:cDescription := "Capturas T.P.V."
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "CapturaCampos"
   oDataTable:cDataFile    := cPatDat( .t. ) + "CapturaCampos.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "CapturaCampos.Cdx"
   oDataTable:cDescription := "Capturas T.P.V."
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "TMov"
   oDataTable:cDataFile    := cPatDat( .t. ) + "TMov.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "TMov.Cdx"
   oDataTable:cDescription := "Tipos de movimientos"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "CnfFlt"
   oDataTable:cDataFile    := cPatDat( .t. ) + "CnfFlt.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "CnfFlt.Cdx"
   oDataTable:cDescription := "Configuración filtros"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "Situa"
   oDataTable:cDataFile    := cPatDat( .t. ) + "Situa.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "Situa.Cdx"
   oDataTable:cDescription := "Situaciones"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "Pais"
   oDataTable:cDataFile    := cPatDat( .t. ) + "Pais.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "Pais.Cdx"
   oDataTable:cDescription := "Paises"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddDataTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatDat() + "Backup"
   oDataTable:cDataFile    := cPatDat( .t. ) + "Backup.Dbf"
   oDataTable:cIndexFile   := cPatDat( .t. ) + "Backup.Cdx"
   oDataTable:cDescription := "Copias de seguridad"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddDataTable( oDataTable )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD BuildEmpresa()

   local oDataTable

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "NCount"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "NCount.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "NCount.Cdx"
   oDataTable:cDescription := "Contadores"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "EntSal"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "EntSal.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "EntSal.Cdx"
   oDataTable:cDescription := "Entradas y salidas"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "LogPorta"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "LogPorta.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "LogPorta.Cdx"
   oDataTable:cDescription := "Entradas y salidas"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "Almacen"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Almacen.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Almacen.Cdx"
   oDataTable:cDescription := "Almacenes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "AlmacenL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AlmacenL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AlmacenL.Cdx"
   oDataTable:cDescription := "Almacenes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "FPago"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FPago.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FPago.Cdx"
   oDataTable:cDescription := "Formas de pago"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "Invita"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Invita.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Invita.Cdx"
   oDataTable:cDescription := "Invitaciones"
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
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "EmpBnc"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "EmpBnc.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "EmpBnc.Cdx"
   oDataTable:cDescription := "Bancos"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "Turno"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Turno.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Turno.Cdx"
   oDataTable:cDescription := "Turnos"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "TurnoC"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TurnoC.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TurnoC.Cdx"
   oDataTable:cDescription := "Turnos"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "TurnoL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TurnoL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TurnoL.Cdx"
   oDataTable:cDescription := "Turnos"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "NewImp"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "NewImp.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "NewImp.Cdx"
   oDataTable:cDescription := "Impuestos"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "HisMov"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "HisMov.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "HisMov.Cdx"
   oDataTable:cDescription := "Movimientos de almacén"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "UbiCat"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "UbiCat.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "UbiCat.Cdx"
   oDataTable:cDescription := "Ubicaciones"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "UbiCal"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "UbiCal.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "UbiCal.Cdx"
   oDataTable:cDescription := "Ubicaciones"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "GrpVent"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "GrpVent.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "GrpVent.Cdx"
   oDataTable:cDescription := "Grupos de ventas"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "RemMovT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "RemMovT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "RemMovT.Cdx"
   oDataTable:bSyncFile    := {|| SynRemMov( cPatEmp() ) }
   oDataTable:cDescription := "Remesas de movimientos"
   ::AddEmpresaTable( oDataTable )

   /*
   Articulos-------------------------------------------------------------------
   */

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "Articulo"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Articulo.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Articulo.Cdx"
   oDataTable:bSyncFile    := {|| SynArt( cPatEmp() ) }
   oDataTable:cDescription := "Artículos"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "ProvArt"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ProvArt.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ProvArt.Cdx"
   oDataTable:cDescription := "Artículos"
   oDataTable:lTrigger     := ::lTriggerAuxiliares   
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "ArtDiv"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ArtDiv.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ArtDiv.Cdx"
   oDataTable:cDescription := "Artículos"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "ArtKit"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ArtKit.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ArtKit.Cdx"
   oDataTable:cDescription := "Artículos"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "ArtCodebar"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ArtCodebar.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ArtCodebar.Cdx"
   oDataTable:cDescription := "Artículos"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "ArtLbl"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ArtLbl.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ArtLbl.Cdx"
   oDataTable:cDescription := "Artículos"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "ArtImg"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ArtImg.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ArtImg.Cdx"
   oDataTable:cDescription := "Artículos"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "Familias"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Familias.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Familias.Cdx"
   oDataTable:cDescription := "Familias"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "FamPrv"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FamPrv.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FamPrv.Cdx"
   oDataTable:cDescription := "Familias"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "Temporadas"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Temporadas.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Temporadas.Cdx"
   oDataTable:cDescription := "Temporadas"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "Categorias"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Categorias.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Categorias.Cdx"
   oDataTable:cDescription := "Categorías"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "TipArt"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TipArt.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TipArt.Cdx"
   oDataTable:cDescription := "Tipos de artículos"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "Fabricantes"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Fabricantes.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Fabricantes.Cdx"
   oDataTable:cDescription := "Fabricantes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "TarPreT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TarPreT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TarPreT.Cdx"
   oDataTable:cDescription := "Tarifas personalizadas"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "TarPreS"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TarPreS.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TarPreS.Cdx"
   oDataTable:cDescription := "Tarifas personalizadas"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "TarPreL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TarPreL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TarPreL.Cdx"
   oDataTable:cDescription := "Tarifas personalizadas"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "Oferta"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Oferta.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Oferta.Cdx"
   oDataTable:cDescription := "Ofertas"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "Pro"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Pro.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Pro.Cdx"
   oDataTable:cDescription := "Propiedades"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
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
   oDataTable:cDescription := "Tankes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "GrpFam"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "GrpFam.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "GrpFam.Cdx"
   oDataTable:cDescription := "Grupo de familias"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "FraPub"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FraPub.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FraPub.Cdx"
   oDataTable:cDescription := "Frases publicitarias"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "TComandas"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TComandas.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TComandas.Cdx"
   oDataTable:cDescription := "Comandas"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "ComentariosT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ComentariosT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ComentariosT.Cdx"
   oDataTable:cDescription := "Comentarios"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "ComentariosL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ComentariosL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ComentariosL.Cdx"
   oDataTable:cDescription := "Comentarios"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "PromoT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PromoT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PromoT.Cdx"
   oDataTable:cDescription := "Promociones"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "PromoL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PromoL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PromoL.Cdx"
   oDataTable:cDescription := "Promociones"
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
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "DetFideliza"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "DetFideliza.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "DetFideliza.Cdx"
   oDataTable:cDescription := "Fidelización"
   ::AddEmpresaTable( oDataTable )

   /*
   Clientes--------------------------------------------------------------------
   */

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "Client"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Client.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Client.Cdx"
   oDataTable:bSyncFile    := {|| SynClient( cPatEmp() ) }
   oDataTable:cDescription := "Clientes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "ClientD"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ClientD.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ClientD.Cdx"
   oDataTable:cDescription := "Clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "CliAtp"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "CliAtp.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "CliAtp.Cdx"
   oDataTable:cDescription := "Atípicas de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "GrpCli"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "GrpCli.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "GrpCli.Cdx"
   oDataTable:cDescription := "Grupos de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "ObrasT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ObrasT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ObrasT.Cdx"
   oDataTable:cDescription := "Direcciones de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "CliContactos"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "CliContactos.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "CliContactos.Cdx"
   oDataTable:cDescription := "Contactos de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "CliBnc"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "CliBnc.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "CliBnc.Cdx"
   oDataTable:cDescription := "Bancos de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "CliInc"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "CliInc.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "CliInc.Cdx"
   oDataTable:cDescription := "Incidencias de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "Agentes"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Agentes.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Agentes.Cdx"
   oDataTable:cDescription := "Agentes"
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

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "Transpor"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Transpor.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Transpor.Cdx"
   oDataTable:cDescription := "Transportistas"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "Ruta"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Ruta.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Ruta.Cdx"
   oDataTable:cDescription := "Rutas"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "CtaRem"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "CtaRem.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "CtaRem.Cdx"
   oDataTable:cDescription := "Cuentas de remesas"
   ::AddEmpresaTable( oDataTable )

   /*
   Proveedores
   */

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "GrpPrv"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "GrpPrv.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "GrpPrv.Cdx"
   oDataTable:bSyncFile    := {|| SynProvee( cPatEmp() ) }
   oDataTable:cDescription := "Grupos de proveedores"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "Provee"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Provee.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Provee.Cdx"
   oDataTable:cDescription := "Proveedores"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "ProveeD"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ProveeD.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ProveeD.Cdx"
   oDataTable:cDescription := "Proveedores"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "PrvBnc"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PrvBnc.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PrvBnc.Cdx"
   oDataTable:cDescription := "Bancos de proveedores"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   /*
   Varios de empresa
   */

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "RemAgeT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "RemAgeT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "RemAgeT.Cdx"
   oDataTable:cDescription := "Remesas de agentes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "TipInci"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TipInci.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TipInci.Cdx"
   oDataTable:cDescription := "Tipos de incidencias"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "CfgUse"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "CfgUse.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "CfgUse.Cdx"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:cDescription := "Configuración"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "CfgCol"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "CfgCol.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "CfgCol.Cdx"
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
   oDataTable:cName        := cPatEmp() + "RDocumen"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "RDocumen.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "RDocumen.Cdx"
   oDataTable:cDescription := "Documentos"
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
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "PrsInf"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PrsInf.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PrsInf.Cdx"
   oDataTable:cDescription := "Documentos"
   ::AddEmpresaTable( oDataTable )

   /*
   Pedido Proveedores
   */

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "PedProvT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PedProvT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PedProvT.Cdx"
   oDataTable:bSyncFile    := {|| SynPedPrv( cPatEmp() ) }
   oDataTable:cDescription := "Pedidos de proveedor"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "PedProvL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PedProvL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PedProvL.Cdx"
   oDataTable:cDescription := "Pedidos de proveedor"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "PedPrvI"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PedPrvI.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PedPrvI.Cdx"
   oDataTable:cDescription := "Pedidos de proveedor"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
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
   oDataTable:cName        := cPatEmp() + "AlbProvT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AlbProvT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AlbProvT.Cdx"
   oDataTable:bSyncFile    := {|| SynAlbPrv( cPatEmp() ) }
   oDataTable:cDescription := "Albaranes de proveedor"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "AlbProvL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AlbProvL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AlbProvL.Cdx"
   oDataTable:cDescription := "Albaranes de proveedor"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "AlbPrvI"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AlbPrvI.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AlbPrvI.Cdx"
   oDataTable:cDescription := "Albaranes de proveedor"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "AlbPrvD"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AlbPrvD.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AlbPrvD.Cdx"
   oDataTable:cDescription := "Albaranes de proveedor"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "AlbPrvS"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AlbPrvS.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AlbPrvS.Cdx"
   oDataTable:cDescription := "Albaranes de proveedor"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   /*
   Facturas Proveedores
   */

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "FacPrvT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacPrvT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacPrvT.Cdx"
   oDataTable:bSyncFile    := {|| SynFacPrv( cPatEmp() ) }
   oDataTable:cDescription := "Facturas de proveedor"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "FacPrvL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacPrvL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacPrvL.Cdx"
   oDataTable:cDescription := "Líneas de facturas de proveedor"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "FacPrvI"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacPrvI.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacPrvI.Cdx"
   oDataTable:cDescription := "Incidencias de facturas de proveedor"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "FacPrvD"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacPrvD.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacPrvD.Cdx"
   oDataTable:cDescription := "Documentos de facturas de proveedor"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "FacPrvP"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacPrvP.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacPrvP.Cdx"
   oDataTable:cDescription := "Pagos de facturas de proveedor"
   oDataTable:bSyncFile    := {|| SynRecPrv( cPatEmp() ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
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
   oDataTable:cName        := cPatEmp() + "RctPrvT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "RctPrvT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "RctPrvT.Cdx"
   oDataTable:cDescription := "Rectificativas de proveedor"
   oDataTable:bSyncFile    := {|| SynRctPrv( cPatEmp() ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "RctPrvL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "RctPrvL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "RctPrvL.Cdx"
   oDataTable:cDescription := "Líneas de rectificativas de proveedor"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "RctPrvI"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "RctPrvI.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "RctPrvI.Cdx"
   oDataTable:cDescription := "Rectificativas de proveedor"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "RctPrvD"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "RctPrvD.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "RctPrvD.Cdx"
   oDataTable:cDescription := "Rectificativas de proveedor"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
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
   oDataTable:cName        := cPatEmp() + "SatCliT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "SatCliT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "SatCliT.Cdx"
   oDataTable:cDescription := "S.A.T. de clientes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "SatCliL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "SatCliL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "SatCliL.Cdx"
   oDataTable:cDescription := "S.A.T. de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "SatCliI"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "SatCliI.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "SatCliI.Cdx"
   oDataTable:cDescription := "S.A.T. de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "SatCliD"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "SatCliD.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "SatCliD.Cdx"
   oDataTable:cDescription := "S.A.T. de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
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
   oDataTable:cName        := cPatEmp() + "PreCliT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PreCliT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PreCliT.Cdx"
   oDataTable:cDescription := "Presupuestos de clientes"
   oDataTable:bSyncFile    := {|| SynPreCli( cPatEmp() ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
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
   oDataTable:cName        := cPatEmp() + "PedCliT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "PedCliT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "PedCliT.Cdx"
   oDataTable:cDescription := "Pedidos de clientes"
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
   oDataTable:cName        := cPatEmp() + "AlbCliT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AlbCliT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AlbCliT.Cdx"
   oDataTable:cDescription := "Albaranes de clientes"
   oDataTable:bSyncFile    := {|| SynAlbCli( cPatEmp() ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "AlbCliL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AlbCliL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AlbCliL.Cdx"
   oDataTable:cDescription := "Albaranes de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "AlbCliI"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AlbCliI.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AlbCliI.Cdx"
   oDataTable:cDescription := "Albaranes de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "AlbCliD"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AlbCliD.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AlbCliD.Cdx"
   oDataTable:cDescription := "Albaranes de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "AlbCliP"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AlbCliP.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AlbCliP.Cdx"
   oDataTable:cDescription := "Albaranes de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "AlbCliS"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AlbCliS.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AlbCliS.Cdx"
   oDataTable:cDescription := "Albaranes de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   /*
   Remesas
   */

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "RemCliT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "RemCliT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "RemCliT.Cdx"
   oDataTable:cDescription := "Remesas de clientes"
   ::AddEmpresaTable( oDataTable )

   /*
   Remesas
   */

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "RemAgeL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "RemAgeL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "RemAgeL.Cdx"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   /*
   Facturas Clientes
   */

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "FacCliT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacCliT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacCliT.Cdx"
   oDataTable:cDescription := "Facturas de clientes"
   oDataTable:bSyncFile    := {|| SynFacCli( cPatEmp() ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "FacCliL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacCliL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacCliL.Cdx"
   oDataTable:cDescription := "Facturas de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "FacCliI"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacCliI.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacCliI.Cdx"
   oDataTable:cDescription := "Facturas de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "FacCliD"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacCliD.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacCliD.Cdx"
   oDataTable:cDescription := "Facturas de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "FacCliP"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacCliP.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacCliP.Cdx"
   oDataTable:cDescription := "Facturas de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   oDataTable:bSyncFile    := {|| SynRecCli( cPatEmp() ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "FacCliS"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacCliS.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacCliS.Cdx"
   oDataTable:cDescription := "Facturas de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "FacRecT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacRecT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacRecT.Cdx"
   oDataTable:cDescription := "Rectificativas de clientes"
   oDataTable:bSyncFile    := {|| SynFacRec( cPatEmp() ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "FacRecL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacRecL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacRecL.Cdx"
   oDataTable:cDescription := "Rectificativas de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares   
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "FacRecI"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacRecI.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacRecI.Cdx"
   oDataTable:cDescription := "Rectificativas de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "FacRecD"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacRecD.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacRecD.Cdx"
   oDataTable:cDescription := "Rectificativas de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares   
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "FacRecS"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacRecS.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacRecS.Cdx"
   oDataTable:cDescription := "Rectificativas de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares   
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "FacAutT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacAutT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacAutT.Cdx"
   oDataTable:cDescription := "Plantillas automáticas de clientes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "FacAutL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacAutL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacAutL.Cdx"
   oDataTable:cDescription := "Plantillas automáticas de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "FacAutI"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "FacAutI.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "FacAutI.Cdx"
   oDataTable:cDescription := "Plantillas automáticas de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   /*
   Facturas de anticipo
   */

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "AntCliT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AntCliT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AntCliT.Cdx"
   oDataTable:cDescription := "Anticipos de clientes"
   oDataTable:bSyncFile    := {|| SynAntCli( cPatEmp() ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "AntCliI"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "AntCliI.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "AntCliI.Cdx"
   oDataTable:cDescription := "Anticipos de clientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
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
   oDataTable:cName        := cPatEmp() + "TikeT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TikeT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TikeT.Cdx"
   oDataTable:cDescription := "Tickets de clientes"
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
   oDataTable:cName        := cPatEmp() + "SalaVta"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "SalaVta.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "SalaVta.Cdx"
   oDataTable:cDescription := "Salas de ventas"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "SlaPnt"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "SlaPnt.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "SlaPnt.Cdx"
   oDataTable:cDescription := "Puntos de la sala de ventas"
   ::AddEmpresaTable( oDataTable )

   /*
   Produccion
   */

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "ProCab"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ProCab.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ProCab.Cdx"
   oDataTable:cDescription := "Producción"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "ProLin"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ProLin.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ProLin.Cdx"
   oDataTable:cDescription := "Líneas de producción"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "ProSer"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ProSer.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ProSer.Cdx"
   oDataTable:cDescription := "Series de producción"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "ProMat"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ProMat.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ProMat.Cdx"
   oDataTable:cDescription := "Materiales de producción"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "ProMaq"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ProMaq.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ProMaq.Cdx"
   oDataTable:cDescription := "Producción"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "MaqCosT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "MaqCosT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "MaqCosT.Cdx"
   oDataTable:cDescription := "Producción"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "MaqCosL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "MaqCosL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "MaqCosL.Cdx"
   oDataTable:cDescription := "Producción"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "Costes"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Costes.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Costes.Cdx"
   oDataTable:cDescription := "Producción"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "ProPer"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ProPer.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ProPer.Cdx"
   oDataTable:cDescription := "Producción"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "OpeT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "OpeT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "OpeT.Cdx"
   oDataTable:cDescription := "Producción"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "OpeL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "OpeL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "OpeL.Cdx"
   oDataTable:cDescription := "Producción"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "Operacio"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Operacio.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Operacio.Cdx"
   oDataTable:cDescription := "Producción"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "Seccion"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Seccion.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Seccion.Cdx"
   oDataTable:cDescription := "Producción"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "Horas"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Horas.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Horas.Cdx"
   oDataTable:cDescription := "Producción"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "ProHPer"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ProHPer.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ProHPer.Cdx"
   oDataTable:cDescription := "Producción"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "MatSer"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "MatSer.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "MatSer.Cdx"
   oDataTable:cDescription := "Producción"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "TipOpera"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TipOpera.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TipOpera.Cdx"
   oDataTable:cDescription := "Producción"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "ExtAgeT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ExtAgeT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ExtAgeT.Cdx"
   oDataTable:cDescription := "Producción"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "ExtAgeL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ExtAgeL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ExtAgeL.Cdx"
   oDataTable:cDescription := "Producción"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   /*
   Ordenes de carga
   */

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "OrdCarP"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "OrdCarP.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "OrdCarP.Cdx"
   oDataTable:cDescription := "Ordenes de carga"
   oDataTable:bSyncFile    := {|| SynOrdCar( cPatEmp() ) }
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "OrdCarL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "OrdCarL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "OrdCarL.Cdx"
   oDataTable:cDescription := "Ordenes de carga"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   /*
   Expedientes
   */

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "ExpCab"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ExpCab.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ExpCab.Cdx"
   oDataTable:cDescription := "Expedientes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "ExpDet"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "ExpDet.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "ExpDet.Cdx"
   oDataTable:cDescription := "Expedientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "TipExpT"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TipExpT.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TipExpT.Cdx"
   oDataTable:cDescription := "Expedientes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "TipExpL"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "TipExpL.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "TipExpL.Cdx"
   oDataTable:cDescription := "Expedientes"
   oDataTable:lTrigger     := ::lTriggerAuxiliares
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "Entidades"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Entidades.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Entidades.Cdx"
   oDataTable:cDescription := "Expedientes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "Colaboradores"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Colaboradores.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Colaboradores.Cdx"
   oDataTable:cDescription := "Expedientes"
   ::AddEmpresaTable( oDataTable )

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "Actuaciones"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "Actuaciones.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "Actuaciones.Cdx"
   oDataTable:cDescription := "Expedientes"
   ::AddEmpresaTable( oDataTable )

   /*
   Envios----------------------------------------------------------------------
   */

   oDataTable              := TDataTable()
   oDataTable:cName        := cPatEmp() + "SndLog"
   oDataTable:cDataFile    := cPatEmp( , .t. ) + "SndLog.Dbf"
   oDataTable:cIndexFile   := cPatEmp( , .t. ) + "SndLog.Cdx"
   oDataTable:cDescription := "Envios y recepción"
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
   ::AddEmpresaTable( oDataTable )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD BuildTrigger()

   with object ( TAuditor() )
      :Create( cPatDat() )
   end with

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CreateOperationLogTable()

   local nError
   local cTable
   local lTrigger
   local cErrorAds

   if File( "SqlOperationLog.adt" )
      fErase( "SqlOperationLog.adt" )
   end if

   cTable         := 'CREATE TABLE SqlOperationLog (' + CRLF
   cTable         += 'ID AUTOINC CONSTRAINT NOT NULL,' + CRLF
   cTable         += 'DATETIME TIMESTAMP CONSTRAINT NOT NULL,' + CRLF
   cTable         += 'USERNAME CHAR(50) CONSTRAINT NOT NULL,' + CRLF
   cTable         += 'APPNAME CHAR(50),' + CRLF
   cTable         += 'TABLENAME CHAR(150) CONSTRAINT NOT NULL,' + CRLF
   cTable         += 'OPERATION CHAR(6) CONSTRAINT NOT NULL )' + CRLF
   cTable         += 'IN DATABASE;' + CRLF

   dbSelectArea( 0 )

   if ADSCreateSQLStatement( "OperationLog", 3 )

      lTrigger    := ADSExecuteSQLDirect( cTable )
      if !lTrigger
         nError   := AdsGetLastError( @cErrorAds )
         msgStop( cErrorAds + CRLF + cTable, 'ERROR CREATE TABLE en ADSExecuteSQLDirect' )
      endif

   else

      nError      := AdsGetLastError( @cErrorAds )
      msgStop( cErrorAds + CRLF + cTable, 'ERROR CREATE TABLE en ADSCreateSQLStatement' )

   end if

   AdsCacheOpenCursors( 0 )
   AdsClrCallBack()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD CreateColumnLogTable()

   local nError
   local cTable
   local lTrigger
   local cErrorAds

   if File( "SqlColumnLog.adt" )
      fErase( "SqlColumnLog.adt" )
   end if

   cTable         := 'CREATE TABLE SqlColumnLog (' + CRLF
   cTable         += 'ID AUTOINC CONSTRAINT NOT NULL,' + CRLF
   cTable         += 'OPERATIONID INTEGER CONSTRAINT NOT NULL,' + CRLF
   cTable         += 'COLUMNNAME CHAR(50) CONSTRAINT NOT NULL,' + CRLF
   cTable         += 'USERNAME CHAR(50) CONSTRAINT NOT NULL,' + CRLF
   cTable         += 'APPNAME CHAR(50),' + CRLF
   cTable         += 'TABLENAME CHAR(150) CONSTRAINT NOT NULL,' + CRLF
   cTable         += 'OLDVALUE CHAR(250),' + CRLF
   cTable         += 'NEWVALUE CHAR(250) )' + CRLF
   cTable         += 'IN DATABASE;' + CRLF

   dbSelectArea( 0 )

   if ADSCreateSQLStatement( "ColumnLog", 3 )

      lTrigger    := ADSExecuteSQLDirect( cTable )
      if !lTrigger
         nError   := AdsGetLastError( @cErrorAds )
         msgStop( cErrorAds + CRLF + cTable, 'ERROR CREATE TABLE en ADSExecuteSQLDirect' )
      endif

   else

      nError      := AdsGetLastError( @cErrorAds )
      msgStop( cErrorAds + CRLF + cTable, 'ERROR CREATE TABLE en ADSCreateSQLStatement' )

   end if

   AdsCacheOpenCursors( 0 )
   AdsClrCallBack()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Auditor()

   if !Empty( oWnd() )
      oWnd():CloseAll()
   end if

   ::BuildData()
     
   ::BuildEmpresa()

   if !::lSelectColumnLog()
      Return ( Self )
   end if

   if !::lSelectOperationLog()
      Return ( Self )
   end if

   ::lCreaArrayPeriodos()

   DEFINE DIALOG ::oDlgAuditor RESOURCE "AdvantageAuditor"

      REDEFINE COMBOBOX ::oPeriodo ;
         VAR         ::cPeriodo ;
         ID          100 ;
         ITEMS       ::aPeriodo ;
         OF          ::oDlgAuditor

      ::oPeriodo:bChange                     := {|| ::lRecargaFecha() } 

      REDEFINE GET   ::oIniInf ;
         VAR         ::dIniInf ;
         SPINNER ;
         ID          120 ;
         OF          ::oDlgAuditor

      REDEFINE GET   ::oFinInf ;
         VAR         ::dFinInf;
         SPINNER ;
         ID          130 ;
         OF          ::oDlgAuditor

      REDEFINE CHECKBOX ::lAppend ;
         ID          140 ;
         OF          ::oDlgAuditor

      REDEFINE CHECKBOX ::lEdit ;
         ID          141 ;
         OF          ::oDlgAuditor

      REDEFINE CHECKBOX ::lDelete ;
         ID          142 ;
         OF          ::oDlgAuditor

      REDEFINE BUTTON ;
         ID          150 ;
         OF          ::oDlgAuditor ;
         ACTION      ( ::lSelectOperationLog() )

      /*
      Operaciones -------------------------------------------------------------
      */

      ::oBrwOperation                        := TXBrowse():New( ::oDlgAuditor )

      ::oBrwOperation:lRecordSelector        := .t.
      ::oBrwOperation:lTransparent           := .f.
      ::oBrwOperation:nDataLines             := 1

      ::oBrwOperation:lVScroll               := .t.
      ::oBrwOperation:lHScroll               := .f.

      ::oBrwOperation:nMarqueeStyle          := MARQSTYLE_HIGHLROW

      ::oBrwOperation:cAlias                 := "SqlOperation"

      ::oBrwOperation:bClrSel                := {|| { CLR_WHITE, RGB( 53, 142, 182 ) } }
      ::oBrwOperation:bClrSelFocus           := {|| { CLR_WHITE, RGB( 53, 142, 182 ) } }

      ::oBrwOperation:bKeyNo                 := {| n, Self | iif( n == nil, Round( ( "SqlOperation" )->( ADSGetRelKeyPos() ) * Self:nLen, 0 ), ( "SqlOperation" )->( ADSSetRelKeyPos( n / Self:nLen ) ) ) }
      ::oBrwOperation:bKeyCount              := {|| ( "SqlOperation" )->( ADSKeyCount( , , 1 ) ) }

      ::oBrwOperation:bChange                := {|| ::lSelectColumnLog( SqlOperation->Id ) }

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
         :bEditValue       := {|| SqlOperation->UserName }
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

      ::oBrwColumn                        := TXBrowse():New( ::oDlgAuditor )

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
      Boton de salida----------------------------------------------------------
      */

      REDEFINE BUTTON ;
         ID                IDOK ;
         OF                ::oDlgAuditor ;
         ACTION            ( ::oDlgAuditor:End() )

   ::oDlgAuditor:Activate( , , , .t., {|| ::lValidOperationLog() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lSelectOperationLog()

   local lOk
   local cStm
   local cOpe
   local nError
   local cErrorAds
   local cDateFormat

   CursorWait()

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

   ::lValidOperationLog()

   /*
   Creamos la snetencia--------------------------------------------------------
   */

   if ADSCreateSQLStatement( "SqlOperation", 3 )

      lOk         := ADSExecuteSQLDirect( cStm )
      if !lOk
         nError   := AdsGetLastError( @cErrorAds )
         msgStop( cErrorAds, 'ERROR en ADSSqlOperationLog' )
      endif

   else

      nError      := AdsGetLastError( @cErrorAds )
      msgStop( cErrorAds, 'ERROR en ADSCreateSQLStatement' )

   end if

   AdsCacheOpenCursors( 0 )
   AdsClrCallBack()

   Set(_SET_DATEFORMAT, cDateFormat )

   /*
   Refresh en pantalla --------------------------------------------------------
   */

   if !Empty( ::oBrwOperation )
      ::oBrwOperation:Refresh()
      ::oBrwOperation:GoTop()
   end if

   CursorWE()

RETURN ( lOk )

//---------------------------------------------------------------------------//

METHOD lValidOperationLog()

   ( "SqlOperation" )->( dbCloseArea() )

   dbSelectArea( 0 )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD lSelectColumnLog( nOperationId )

   local lOk
   local cStm
   local cOpe
   local nError
   local cErrorAds

   DEFAULT nOperationId    := 0

   CursorWait()

   /*
   Creamos la instruccion------------------------------------------------------
   */

   cStm           := "SELECT * FROM SqlColumnLog "
   cStm           += "WHERE OperationId = " + Alltrim( Str( nOperationId ) )

   /*
   Cerramos las areas----------------------------------------------------------
   */

   ::lValidColumnLog()

   /*
   Creamos la snetencia--------------------------------------------------------
   */

   if ADSCreateSQLStatement( "SqlColumn", 3 )

      lOk         := ADSExecuteSQLDirect( cStm )
      if !lOk
         nError   := AdsGetLastError( @cErrorAds )
         msgStop( cErrorAds, 'ERROR en ADSSqlColumnLog' )
      endif

   else

      nError      := AdsGetLastError( @cErrorAds )
      msgStop( cErrorAds, 'ERROR en ADSCreateSQLStatement' )

   end if

   AdsCacheOpenCursors( 0 )
   AdsClrCallBack()

   /*
   Refresh en pantalla --------------------------------------------------------
   */

   if !Empty( ::oBrwColumn )
      ::oBrwColumn:Refresh()
      ::oBrwColumn:GoTop()
   end if

   CursorWE()

RETURN ( lOk )

//---------------------------------------------------------------------------//

METHOD lValidColumnLog()

   ( "SqlColumn" )->( dbCloseArea() )

   dbSelectArea( 0 )

RETURN ( .t. )

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

         ::oIniInf:cText( CtoD( "01/" + Str( Month( GetSysDate() ) - 1 ) + "/" + Str( Year( GetSysDate() ) ) ) )
         ::oFinInf:cText( nLastDay( Month( GetSysDate() ) - 1 ) )

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

         ::oIniInf:cText( CtoD( Str( Day( GetSysDate() ) ) + "/" + Str( Month( GetSysDate() ) ) + "/" + Str( Year( GetSysDate() ) -1 ) ) )
         ::oFinInf:cText( GetSysDate() )

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

   local cDescription   := "Desconocido"

   do case
      case cOperation == "INSERT"
         cDescription   := "Añadido"

      case cOperation == "UPDATE"
         cDescription   := "Modificado"

      case cOperation == "DELETE"
         cDescription   := "Eliminado"

   end case

Return ( cDescription )

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

      REDEFINE BUTTON ID IDOK       OF ::oDlg ACTION ( ::Reindex() )
      REDEFINE BUTTON ID IDCANCEL   OF ::oDlg ACTION ( ::oDlg:end() )

      ::oDlg:AddFastKey( VK_F5, {|| ::Reindex() } )

   ACTIVATE DIALOG ::oDlg CENTER

   TReindex():lCloseHandle()

   // Cerramos posibles tablas-------------------------------------------------

   dbCloseAll()

   // Iniciamos los servicios--------------------------------------------------

   InitServices()

   oBmp:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Reindex()

   local oTable
   local cAlias

   ::oDlg:Disable()

   CursorWait()

   ::BuildData()

   /*
   Bases de datos de directorio datos------------------------------------------
   */

   if ::aLgcIndices[ 1 ]
      
      ::aProgress[ 1 ]:SetTotal( len( ::aDataTables ) )

      for each oTable in ::aDataTables

         if !Empty( ::oMsg )
            ::oMsg:SetText( "Generando índices : " + oTable:cDescription )
         end if

         dbUseArea( .t., cDriver(), ( oTable:cName + ".Dbf" ), "Table", .f. )
         ( "Table" )->( OrdSetFocus( 1 ) )
         ( "Table" )->( OrdListRebuild() )
         ( "Table" )->( dbCloseArea() )

         ::aProgress[ 1 ]:Set( hb_EnumIndex() )

      next

   end if   

   /*
   Bases de datos de empresa---------------------------------------------------
   */

   if ::aLgcIndices[ 2 ]

      ::BuildEmpresa()

      ::aProgress[ 2 ]:SetTotal( len( ::aEmpresaTables ) )

      for each oTable in ::aEmpresaTables

         if !Empty( ::oMsg )
            ::oMsg:SetText( "Generando índices : " + oTable:cDescription )
         end if

         dbUseArea( .t., cDriver(), ( oTable:cName + ".Dbf" ), "Table", .f. )
         ( "Table" )->( OrdSetFocus( 1 ) )
         ( "Table" )->( OrdListRebuild() )
         ( "Table" )->( dbCloseArea() )

         ::aProgress[ 2 ]:Set( hb_EnumIndex() )

      next

   end if   

   /*
   Sincronizacion de la empresa------------------------------------------------
   */

   if ::aLgcIndices[ 3 ]

      ::aProgress[ 3 ]:SetTotal( len( ::aEmpresaTables ) )

      ::DisableTriggers()

      for each oTable in ::aEmpresaTables

         if !Empty( ::oMsg )
            ::oMsg:SetText( "Sincronizando : " + oTable:cDescription )
         end if

         if !Empty( oTable:bSyncFile )
            eval( oTable:bSyncFile )
         end if

         ::aProgress[ 3 ]:Set( hb_EnumIndex() )

      next
      
      ::EnableTriggers()

   end if   
      
   CursorWE()

   ::oDlg:Enable()

   msgInfo( "Proceso finalizado con exito.")

   ::oDlg:End()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD DisableTriggers()

   local lOk
   local cStm
   local nError
   local cErrorAds

   /*
   Creamos la instruccion------------------------------------------------------
   */

   cStm           := "EXECUTE PROCEDURE sp_disableTriggers( NULL, NULL, FALSE, 0 );"

   /*
   Creamos la snetencia--------------------------------------------------------
   */

   if ADSCreateSQLStatement( "DisableTriggers", 3 )

      lOk         := ADSExecuteSQLDirect( cStm )
      if !lOk
         nError   := AdsGetLastError( @cErrorAds )
         msgStop( cErrorAds, 'ERROR en ADSSqlOperationLog' )
      endif

   else

      nError      := AdsGetLastError( @cErrorAds )
      msgStop( cErrorAds, 'ERROR en ADSCreateSQLStatement' )

   end if

   AdsCacheOpenCursors( 0 )
   AdsClrCallBack()

RETURN ( lOk )

//---------------------------------------------------------------------------//

METHOD EnableTriggers()

   local lOk
   local cStm
   local nError
   local cErrorAds

   /*
   Creamos la instruccion------------------------------------------------------
   */

   cStm           := "EXECUTE PROCEDURE sp_enableTriggers( NULL, NULL, FALSE, 0 );"

   /*
   Creamos la snetencia--------------------------------------------------------
   */

   if ADSCreateSQLStatement( "EnableTriggers", 3 )

      lOk         := ADSExecuteSQLDirect( cStm )
      if !lOk
         nError   := AdsGetLastError( @cErrorAds )
         msgStop( cErrorAds, 'ERROR en ADSSqlOperationLog' )
      endif

   else

      nError      := AdsGetLastError( @cErrorAds )
      msgStop( cErrorAds, 'ERROR en ADSCreateSQLStatement' )

   end if

   AdsCacheOpenCursors( 0 )
   AdsClrCallBack()

RETURN ( lOk )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TDataTable

   DATA  cName
   DATA  cDataFile
   DATA  cIndexFile
   DATA  cDescription   INIT ""
   DATA  aFields        INIT {}
   DATA  lTrigger       INIT .t.
   DATA  bSyncFile      

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

      if !ADSCreateSQLStatement( cSqlAlias, 3 ) 

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
