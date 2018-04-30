#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS Seeders

   DATA oMsg

   DATA hConfig

   METHOD New()

   METHOD runSeederDatos()
   METHOD runSeederEmpresa()

   METHOD getFullFileProvincias()            INLINE ( cPatConfig() + "insertprovincias.sql" )

   METHOD getInsertStatement( hCampos, cDataBaseName )

   METHOD SeederUsuarios()
   METHOD insertUsuarios( dbf )

   METHOD SeederSituaciones()
   METHOD getStatementSituaciones( dbfSitua )

   METHOD SeederTiposImpresoras()
   METHOD getStatementTiposImpresoras( dbfTipImp )

   METHOD SeederMovimientosAlmacen()
   METHOD getStatementSeederMovimientosAlmacen( dbfRemMov )

   METHOD SeederMovimientosAlmacenLineas()
   METHOD getStatementSeederMovimientosAlmacenLineas( dbfHisMov )

   METHOD SeederMovimientosAlmacenSeries()
   METHOD getStatementSeederMovimientosAlmacenLineasNumerosSeries( dbfMovSer )

   METHOD SeederSqlFiles()

   METHOD SeederLenguajes()
   METHOD insertLenguaje( dbf )

   METHOD SeederTransportistas()
   METHOD insertTransportista( dbfTransportista )

   METHOD SeederCamposExtra() 
   METHOD getStatementCamposExtra() 
   METHOD getStatementCamposExtraValores() 
   METHOD getEntidadUuid( cTipoDocumento, cClave ) 

   METHOD SeederCamposExtraValores()

   METHOD SeederFabricantes()
   METHOD insertFabricantes( dbf )

   METHOD SeederEmpresas()
   METHOD insertEmpresas( dbf )

   METHOD SeederAgentes()
   METHOD insertAgentes( dbf )

   METHOD SeederListin()
   METHOD insertListin()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oMsg ) CLASS Seeders

   ::oMsg            := oMsg

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD runSeederDatos()

   SincronizaListin()

   ::oMsg:SetText( "Datos: Ejecutando seeder de usuarios" )
   ::SeederUsuarios()

   ::oMsg:SetText( "Datos: Ejecutando seeder de situaciones" )
   ::SeederSituaciones()

   ::oMsg:SetText( "Datos: Ejecutando seeder de tipos de impresoras" )
   ::SeederTiposImpresoras()

   ::oMsg:SetText( "Datos: Ejecutando lenguajes" )
   ::SeederLenguajes()

   ::oMsg:SetText( "Datos: Listín" )
   ::SeederListin()

   ::oMsg:SetText( "Datos: Ejecutando ficheros SQL" )
   ::SeederSqlFiles()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD runSeederEmpresa()

   SincronizaRemesasMovimientosAlmacen()

   /*::oMsg:SetText( "Ejecutando seeder de cabeceras de movimientos de almacén" )
   ::SeederMovimientosAlmacen()
   
   ::oMsg:SetText( "Ejecutando seeder de líneas de movimientos de almacén" )
   ::SeederMovimientosAlmacenLineas()

   ::oMsg:SetText( "Ejecutando seeder de números de serie de lineas de movimientos de almacén" )
   ::SeederMovimientosAlmacenSeries()*/

   ::oMsg:SetText( "Ejecutando seeder de transportistas" )
   ::SeederTransportistas()

   ::oMsg:SetText( "Ejecutando seeder de agentes" )
   ::SeederAgentes()

   /*::oMsg:SetText( "Ejecutando seeder de campos extra" )
   ::SeederCamposExtra()

   ::oMsg:SetText( "Ejecutando seeder de campos extra valores" )
   ::SeederCamposExtraValores()*/

   ::oMsg:SetText( "Ejecutando seeder de fabricantes" )
   ::SeederFabricantes()

   ::oMsg:SetText( "Ejecutando seeder de empresas" )
   ::SeederEmpresas()

   ::oMsg:SetText( "Seeders finalizados" )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD getInsertStatement( hCampos, cTableName )

   local cStatement  

   cStatement        := "INSERT IGNORE INTO " + cTableName + " ( "

   hEval( hCampos, {| k, v | cStatement += k + ", " } )

   cStatement        := chgAtEnd( cStatement, " ) VALUES ( ", 2 )

   hEval( hCampos, {| k, v | cStatement += v + ", " } )

   cStatement        := chgAtEnd( cStatement, " )", 2 )

RETURN cStatement

//---------------------------------------------------------------------------//
//--LO DEJO CON EL MÉTODO ANTIGUO PORQUE YA SE HA QUITADO EL CÓDIGO DEL TODO-//
//---------------------------------------------------------------------------//

METHOD SeederSituaciones() CLASS Seeders

   local cPath       := cPatDat( .t. )
   local dbfSitua

   if ( file( cPath + "Situa.Old" ) )
      RETURN ( self )
   end if

   if !( file( cPath + "Situa.Dbf" ) )
      msgStop( "El fichero " + cPath + "\Situa.Dbf no se ha localizado", "Atención" )  
      RETURN ( self )
   end if 

   USE ( cPath + "SITUA.Dbf" ) NEW VIA ( 'DBFCDX' ) SHARED ALIAS ( cCheckArea( "SITUA", @dbfSitua ) )
   ( dbfSitua )->( ordsetfocus(0) )

   ( dbfSitua )->( dbgotop() )

   while !( dbfSitua )->( eof() )

      getSQLDatabase():Exec( ::getStatementSituaciones( dbfSitua ) )

      ( dbfSitua )->( dbSkip() )

   end while

   if dbfSitua != nil
      ( dbfSitua )->( dbCloseArea() )
   end if

   frename( cPath + "Situa.dbf", cPath + "Situa.old" )
   
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getStatementSituaciones( dbfSitua )
   
   local hCampos        := { "nombre" => quoted( ( dbfSitua )->cSitua ) }

RETURN ( ::getInsertStatement( hCampos, "situaciones" ) )

//---------------------------------------------------------------------------//
//--LO DEJO CON EL MÉTODO ANTIGUO PORQUE YA SE HA QUITADO EL CÓDIGO DEL TODO-//
//---------------------------------------------------------------------------//

METHOD SeederTiposImpresoras() CLASS Seeders

   local cPath       := cPatDat( .t. )
   local dbfTipImp

   if ( file( cPath + "TipImp.old" ) )
      RETURN ( self )
   end if

   if !( file( cPath + "TipImp.Dbf" ) )
      msgStop( "El fichero " + cPath + "\TipImp.Dbf no se ha localizado", "Atención" )  
      RETURN ( self )
   end if 

   USE ( cPath + "TipImp.Dbf" ) NEW VIA ( 'DBFCDX' ) SHARED ALIAS ( cCheckArea( "TipImp", @dbfTipImp ) )
   ( dbfTipImp )->( ordsetfocus(0) )
   
   ( dbfTipImp )->( dbgotop() )
   while !( dbfTipImp )->( eof() )

      getSQLDatabase():Exec( ::getStatementTiposImpresoras( dbfTipImp ) )

      ( dbfTipImp )->( dbSkip() )

   end while

   if dbfTipImp != nil
      ( dbfTipImp )->( dbCloseArea() )
   end if

   frename( cPath + "TipImp.dbf", cPath + "TipImp.old" )
   
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getStatementTiposImpresoras( dbfTipImp )

   local hCampos        := { "nombre" => quoted( ( dbfTipImp )->cTipImp ) }

RETURN ( ::getInsertStatement( hCampos, "tipos_impresoras" ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD SeederUsuarios()

   local dbf
   local cPath    := ( fullCurDir() + cPatDat() + "\" )

   if !( file( cPath + "Users.Dbf" ) )
      msgStop( "El fichero " + cPath + "\Users.Dbf no se ha localizado", "Atención" )  
      RETURN ( self )
   end if

   USE ( cPath + "Users.Dbf" ) NEW VIA ( 'DBFCDX' ) SHARED ALIAS ( cCheckArea( "Users", @dbf ) )
   ( dbf )->( ordsetfocus( 0 ) )

   ( dbf )->( dbeval( {|| ::insertUsuarios( dbf ) } ) )

   ( dbf )->( dbCloseArea() )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD insertUsuarios( dbf )

   local hBuffer

   hBuffer        := SQLUsuariosModel():loadBlankBuffer()

   hset( hBuffer, "uuid",              ( dbf )->Uuid     )
   hset( hBuffer, "codigo",            ( dbf )->cCodUse  )
   hset( hBuffer, "nombre",            ( dbf )->cNbrUse  )
   hset( hBuffer, "password",          SQLUsuariosModel():Crypt( ( dbf )->cClvUse )  )

   SQLUsuariosModel():insertIgnoreBuffer( hBuffer )

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD SeederListin()

   local dbf
   local cPath    := ( fullCurDir() + cPatDat() + "\" )

   if !( file( cPath + "Agenda.Dbf" ) )
      msgStop( "El fichero " + cPath + "\Agenda.Dbf no se ha localizado", "Atención" )  
      RETURN ( self )
   end if

   USE ( cPath + "Agenda.Dbf" ) NEW VIA ( 'DBFCDX' ) SHARED ALIAS ( cCheckArea( "Agenda", @dbf ) )
   ( dbf )->( ordsetfocus( 0 ) )

   ( dbf )->( dbeval( {|| ::insertListin( dbf ) } ) )

   ( dbf )->( dbCloseArea() )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD insertListin( dbf )

   local hBuffer
   local nId

   hBuffer        := SQLListinModel():loadBlankBuffer()

   hset( hBuffer, "uuid",              ( dbf )->Uuid     )
   hset( hBuffer, "nombre",            ( dbf )->cApellidos  )
   hset( hBuffer, "dni",               ( dbf )->cNif  )

   nId            := SQLListinModel():insertIgnoreBuffer( hBuffer )

   if empty( nId )
      RETURN ( self )
   end if 

   // Direcciones--------------------------------------------------------------

   hBuffer        := SQLDireccionesModel():loadBlankBuffer()

   hset( hBuffer, "parent_uuid",    ( dbf )->Uuid         )
   hset( hBuffer, "nombre",         ( dbf )->cApellidos   )
   hset( hBuffer, "direccion",      ( dbf )->cDomicilio   )
   hset( hBuffer, "poblacion",      ( dbf )->cPoblacion   )
   hset( hBuffer, "provincia",      ( dbf )->cProvincia   )
   hset( hBuffer, "codigo_postal",  ( dbf )->cCodpostal   )
   hset( hBuffer, "telefono",       ( dbf )->cTel         )
                        
   nId            := SQLDireccionesModel():insertIgnoreBuffer( hBuffer )

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//


METHOD SeederLenguajes()

   local dbf
   local cPath    := ( fullCurDir() + cPatDat() + "\" )

   if !( file( cPath + "LENGUAJE.Dbf" ) )
      msgStop( "El fichero " + cPath + "\LENGUAJE.Dbf no se ha localizado", "Atención" )  
      RETURN ( self )
   end if

   USE ( cPath + "LENGUAJE.Dbf" ) NEW VIA ( 'DBFCDX' ) SHARED ALIAS ( cCheckArea( "LENGUAJE", @dbf ) )
   ( dbf )->( ordsetfocus( 0 ) )

   ( dbf )->( dbeval( {|| ::insertLenguaje( dbf ) } ) )

   ( dbf )->( dbCloseArea() )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD insertLenguaje( dbf )

   local hBuffer

   hBuffer        := SQLLenguajesModel():loadBlankBuffer()

   hset( hBuffer, "uuid",              ( dbf )->Uuid     )
   hset( hBuffer, "codigo",            ( dbf )->cCodLen  )
   hset( hBuffer, "nombre",            ( dbf )->cNomLen  )

   SQLLenguajesModel():insertIgnoreBuffer( hBuffer )

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD SeederSqlFiles()

   local cStm
   local aFile
   local cPath          := cPatConfig() + "sql\"
   local aDirectory     := directory( cPath + "*.sql" )

   if len( aDirectory ) == 0
      RETURN ( Self )
   end if

   for each aFile in aDirectory

      ::oMsg:SetText( "Procesando fichero " + cPath + aFile[1] )

      cStm              := memoread( cPath + aFile[1] )

      if !empty( cStm )
         getSQLDatabase():Exec( cStm )
      end if

   next

RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD SeederAgentes()

   local dbf
   local cPath    := ( fullCurDir() + cPatEmp() + "\" )

   if !( file( cPath + "Agentes.Dbf" ) )
      msgStop( "El fichero " + cPath + "\Agentes.Dbf no se ha localizado", "Atención" )  
      RETURN ( self )
   end if

   USE ( cPath + "Agentes.Dbf" ) NEW VIA ( 'DBFCDX' ) SHARED ALIAS ( cCheckArea( "Agentes", @dbf ) )
   ( dbf )->( ordsetfocus( 0 ) )

   ( dbf )->( dbeval( {|| ::insertAgentes( dbf ) } ) )

   ( dbf )->( dbCloseArea() )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD insertAgentes( dbf )

   local nId
   local hBuffer

   hBuffer        := SQLAgentesModel():loadBlankBuffer()

   hset( hBuffer, "uuid",              ( dbf )->Uuid     )
   hset( hBuffer, "codigo",            ( dbf )->cCodAge  )
   hset( hBuffer, "nombre",            ( dbf )->cNbrAge + Space(1) + ( dbf )->cApeAge )
   hset( hBuffer, "dni",               ( dbf )->cDniNif  )
   hset( hBuffer, "comision",          ( dbf )->nCom1    )
   hset( hBuffer, "empresa_uuid",      uuidEmpresa()     )

   nId            := SQLAgentesModel():insertIgnoreBuffer( hBuffer )

   if empty( nId )
      RETURN ( self )
   end if

   hBuffer        := SQLDireccionesModel():loadBlankBuffer()

   hset( hBuffer, "principal",      1                    )
   hset( hBuffer, "parent_uuid",    ( dbf )->Uuid        )
   hset( hBuffer, "direccion",      ( dbf )->cDirAge     )
   hset( hBuffer, "poblacion",      ( dbf )->cPobAge     )
   hset( hBuffer, "provincia",      ( dbf )->cProv       )
   hset( hBuffer, "codigo_postal",  ( dbf )->cPtlAge     )
   hset( hBuffer, "telefono",       ( dbf )->cTfoAge     )
   hset( hBuffer, "movil",          ( dbf )->cMovAge     )
   hset( hBuffer, "email",          ( dbf )->cMailAge    )
                        
   nId            := SQLDireccionesModel():insertIgnoreBuffer( hBuffer )

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD SeederTransportistas()

   local dbf
   local cPath    := ( fullCurDir() + cPatEmp() + "\" )

   if !( file( cPath + "Transpor.Dbf" ) )
      msgStop( "El fichero " + cPath + "\Transpor.Dbf no se ha localizado", "Atención" )  
      RETURN ( self )
   end if 

   USE ( cPath + "Transpor.Dbf" ) NEW VIA ( 'DBFCDX' ) SHARED ALIAS ( cCheckArea( "Transpor", @dbf ) )
   ( dbf )->( ordsetfocus( 0 ) )

   ( dbf )->( dbeval( {|| ::insertTransportista( dbf ) } ) )

   ( dbf )->( dbCloseArea() )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD insertTransportista( dbf )

   local nId
   local hBuffer

   hBuffer        := SQLTransportistasModel():loadBlankBuffer()

   hset( hBuffer, "uuid",              ( dbf )->Uuid     )
   hset( hBuffer, "codigo",            ( dbf )->cCodTrn  )
   hset( hBuffer, "nombre",            ( dbf )->cNomTrn  )
   hset( hBuffer, "dni",               ( dbf )->cDniTrn  )
   hset( hBuffer, "empresa_uuid",      uuidEmpresa()     )

   nId            := SQLTransportistasModel():insertIgnoreBuffer( hBuffer )

   if empty( nId )
      RETURN ( self )
   end if

   hBuffer        := SQLDireccionesModel():loadBlankBuffer()

   hset( hBuffer, "principal",      0                    )
   hset( hBuffer, "parent_uuid",    ( dbf )->Uuid        )
   hset( hBuffer, "nombre",         ( dbf )->cNomTrn     )
   hset( hBuffer, "direccion",      ( dbf )->cDirTrn     )
   hset( hBuffer, "poblacion",      ( dbf )->cLocTrn     )
   hset( hBuffer, "provincia",      ( dbf )->cPrvTrn     )
   hset( hBuffer, "codigo_postal",  ( dbf )->cCdpTrn     )
   hset( hBuffer, "telefono",       ( dbf )->cTlfTrn     )
   hset( hBuffer, "movil",          ( dbf )->cMovTrn     )
                        
   nId            := SQLDireccionesModel():insertIgnoreBuffer( hBuffer )

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD SeederEmpresas() CLASS Seeders

   local dbf
   local cPath    := ( fullCurDir() + cPatDat() + "\" )

   if !( file( cPath + "Empresa.Dbf" ) )
      msgStop( "El fichero " + cPath + "\Empresa.Dbf no se ha localizado", "Atención" )  
      RETURN ( self )
   end if 

   USE ( cPath + "Empresa.Dbf" ) NEW VIA ( 'DBFCDX' ) SHARED ALIAS ( cCheckArea( "Empresa", @dbf ) )
   ( dbf )->( ordsetfocus( 0 ) )

   ( dbf )->( dbeval( {|| ::insertEmpresas( dbf ) } ) )

   ( dbf )->( dbCloseArea() )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD insertEmpresas( dbf ) CLASS Seeders

   local nId
   local cSql
   local hBuffer  

   hBuffer        := SQLEmpresasModel():loadBlankBuffer()

   hset( hBuffer, "uuid",              ( dbf )->Uuid      )
   hset( hBuffer, "codigo",            ( dbf )->CodEmp    )
   hset( hBuffer, "nombre",            ( dbf )->cNombre   )
   hset( hBuffer, "nif",               ( dbf )->cNif      )
   hset( hBuffer, "administrador",     ( dbf )->cAdminis  )
   hset( hBuffer, "pagina_web",        ( dbf )->web       )

   nId            := SQLEmpresasModel():insertIgnoreBuffer( hBuffer )

   if empty( nId )
      RETURN ( self )
   end if 

   // Direcciones--------------------------------------------------------------

   hBuffer        := SQLDireccionesModel():loadBlankBuffer()

   hset( hBuffer, "principal",      1                     )
   hset( hBuffer, "parent_uuid",    ( dbf )->Uuid         )
   hset( hBuffer, "direccion",      ( dbf )->cDomicilio   )
   hset( hBuffer, "poblacion",      ( dbf )->cPoblacion   )
   hset( hBuffer, "provincia",      ( dbf )->cProvincia   )
   hset( hBuffer, "codigo_postal",  ( dbf )->cCodPos      )
   hset( hBuffer, "telefono",       ( dbf )->cTlf         )
   hset( hBuffer, "email",          ( dbf )->email        )
                        
   nId            := SQLDireccionesModel():insertIgnoreBuffer( hBuffer )

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD SeederFabricantes() CLASS Seeders

   local dbf
   local cPath    := ( fullCurDir() + cPatEmp() + "\" )

   if !( file( cPath + "Fabric.Dbf" ) )
      msgStop( "El fichero " + cPath + "\Fabric.Dbf no se ha localizado", "Atención" )
      RETURN ( self )
   end if 

   USE ( cPath + "Fabric.Dbf" ) NEW VIA ( 'DBFCDX' ) SHARED ALIAS ( cCheckArea( "Fabric", @dbf ) )
   ( dbf )->( ordsetfocus( 0 ) )

   ( dbf )->( dbeval( {|| ::insertFabricantes( dbf ) } ) )

   ( dbf )->( dbCloseArea() )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD insertFabricantes( dbf ) CLASS Seeders

   local nId
   local cSql
   local hBuffer  

   hBuffer        := SQLFabricantesModel():loadBlankBuffer()

   hset( hBuffer, "uuid",              ( dbf )->Uuid     )
   hset( hBuffer, "codigo",            ( dbf )->cCodFab  )
   hset( hBuffer, "nombre",            ( dbf )->cNomFab  )
   hset( hBuffer, "pagina_web",        ( dbf )->cUrlFab  )
   hset( hBuffer, "empresa_uuid",      uuidEmpresa()     )

   nId            := SQLFabricantesModel():insertIgnoreBuffer( hBuffer )

RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD SeederCamposExtra() CLASS Seeders

   local dbf
   local cPath    := ( fullCurDir() + cPatEmp() + "\" )

   if !( file( cPath + "CampoExtra.Dbf" ) )
      msgStop( "El fichero " + cPath + "\CampoExtra.Dbf no se ha localizado", "Atención" )  
      RETURN ( self )
   end if 

   USE ( cPath + "CampoExtra.Dbf" ) NEW VIA ( 'DBFCDX' ) SHARED ALIAS ( cCheckArea( "CampoExtra", @dbf ) )
   ( dbf )->( ordsetfocus( 0 ) )

   ( dbf )->( dbeval( {|| getSQLDatabase():Exec( ::getStatementCamposExtra( dbf ) ) } ) )

   ( dbf )->( dbCloseArea() )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getStatementCamposExtra( dbf ) CLASS Seeders

   local aTipo    := {  "Texto", "Número", "Fecha", "Lógico", "Lista" } 
   local hCampos  := {  "uuid"      => quoted( ( dbf )->Uuid ),;
                        "nombre"    => quoted( ( dbf )->cNombre ),;
                        "requerido" => if( ( dbf )->lRequerido, '1', '0' ),;
                        "tipo"      => quoted( aTipo[ minmax( ( dbf )->nTipo, 1, 5 ) ] ),;
                        "longitud"  => quoted( ( dbf )->nLongitud ),;
                        "decimales" => quoted( ( dbf )->nDecimales ),;
                        "lista"     => quoted( ( dbf )->mDefecto ) }

RETURN ( ::getInsertStatement( hCampos, "campos_extra" ) )

//---------------------------------------------------------------------------//

METHOD SeederCamposExtraValores() CLASS Seeders

   local dbf
   local cPath    := ( fullCurDir() + cPatEmp() + "\" )

   if !( file( cPath + "Detcextra.Dbf" ) )
      msgStop( "El fichero " + cPath + "\Detcextra.Dbf no se ha localizado", "Atención" )  
      RETURN ( self )
   end if 

   USE ( cPath + "Detcextra.Dbf" ) NEW VIA ( 'DBFCDX' ) SHARED ALIAS ( cCheckArea( "Cextra", @dbf ) )
   ( dbf )->( ordsetfocus( 0 ) )

   ( dbf )->( dbeval( {|| getSQLDatabase():Exec( ::getStatementCamposExtraValores( dbf ) ) } ) )

   ( dbf )->( dbCloseArea() )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getStatementCamposExtraValores( dbf ) CLASS Seeders

   local hCampos  := {  "uuid"                     => quoted( ( dbf )->Uuid ),;
                        "campo_extra_entidad_uuid" => quoted( CamposExtraModel():getUuid( ( dbf )->cCodTipo ) ),;
                        "entidad_uuid"             => quoted( ::getEntidadUuid( ( dbf )->cTipDoc, ( dbf )->cClave ) ),;
                        "valor"                    => quoted( ( dbf )->cValor ) }

RETURN ( ::getInsertStatement( hCampos, "campos_extra_valores" ) )

//---------------------------------------------------------------------------//

METHOD getEntidadUuid( cTipoDocumento, cClave ) CLASS Seeders

   local cEntidadUuid   := ""

   cTipoDocumento       := alltrim( cTipoDocumento )
   cClave               := alltrim( cClave )
   
   msgalert( cTipoDocumento, "cTipoDocumento" )

   do case 
      case cTipoDocumento == "20" // "Artículos" => "20"
         
         cEntidadUuid   := ArticulosModel():getUuid( cClave )

      case cTipoDocumento == "21" // "Clientes" => "21"
         
         cEntidadUuid   := ClientesModel():getUuid( cClave )

   end case

   msgalert( cEntidadUuid, "cEntidadUuid" )

RETURN ( cEntidadUuid )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD SeederMovimientosAlmacen()

   local dbf
   local cLastRec

   if ( file( cPatEmp( , .t. ) + "RemMovT.old" ) )
      RETURN ( self )
   end if

   if !( file( cPatEmp( , .t. ) + "RemMovT.Dbf" ) )
      msgStop( "El fichero " + cPatEmp( , .t. ) + "\RemMovT.Dbf no se ha localizado", "Atención" )  
      RETURN ( self )
   end if 

   USE ( cPatEmp( , .t. ) + "RemMovT.Dbf" ) NEW VIA ( 'DBFCDX' ) SHARED ALIAS ( cCheckArea( "RemMovT", @dbf ) )
   
   ( dbf )->( ordsetfocus( 0 ) )

   cLastRec       := alltrim( str( ( dbf )->( lastrec() ) ) )

   ( dbf )->( dbgotop() )

   while !( dbf )->( eof() )

      ::oMsg:SetText( "Seeder de movimientos de almacén " + alltrim( str( ( dbf )->( recno() ) ) ) + " de " + cLastRec )
      
      getSQLDatabase():Exec( ::getStatementSeederMovimientosAlmacen( dbf ) )

      ( dbf )->( dbSkip() )

      sysrefresh()

   end while

   if dbf != nil
      ( dbf )->( dbCloseArea() )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD SeederMovimientosAlmacenLineas()

   local dbf
   local cLastRec

   if ( file( cPatEmp( , .t. ) + "HisMov.old" ) )
      RETURN ( self )
   end if

   if !( file( cPatEmp( , .t. ) + "HisMov.Dbf" ) )
      msgStop( "El fichero " + cPatEmp( , .t. ) + "\HisMov.Dbf no se ha localizado", "Atención" )  
      RETURN ( self )
   end if 

   USE ( cPatEmp( , .t. ) + "HisMov.Dbf" ) NEW VIA ( 'DBFCDX' ) SHARED ALIAS ( cCheckArea( "HisMov", @dbf ) )
   
   ( dbf )->( ordsetfocus(0) )

   cLastRec       := alltrim( str( ( dbf )->( lastrec() ) ) )

   ( dbf )->( dbgotop() )

   while !( dbf )->( eof() )
      
      ::oMsg:SetText( "Seeder de líneas de movimientos de almacén " + alltrim( str( ( dbf )->( recno() ) ) ) + " de " + cLastRec )

      getSQLDatabase():Exec( ::getStatementSeederMovimientosAlmacenLineas( dbf ) )

      ( dbf )->( dbSkip() )

      sysrefresh()

   end while

   if dbf != nil
      ( dbf )->( dbCloseArea() )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getStatementSeederMovimientosAlmacen( dbfRemMov )

   local hCampos  := {  "empresa" =>            quoted( cCodEmp() ),;
                        "usuario" =>            quoted( ( dbfRemMov )->cCodUsr ),;
                        "uuid" =>               quoted( ( dbfRemMov )->cGuid ),;
                        "numero" =>             quoted( rjust( ( dbfRemMov )->nNumRem, "0", 6 ) ),;
                        "tipo_movimiento" =>    quoted( ( dbfRemMov )->nTipMov ),;
                        "fecha_hora" =>         quoted( DateTimeFormatTimestamp( ( dbfRemMov )->dFecRem, ( dbfRemMov )->cTimRem ) ),;
                        "almacen_origen" =>     quoted( ( dbfRemMov )->cAlmOrg ),;
                        "almacen_destino" =>    quoted( ( dbfRemMov )->cAlmDes ),;
                        "divisa" =>             quoted( ( dbfRemMov )->cCodDiv ),;
                        "divisa_cambio" =>      quoted( ( dbfRemMov )->nVdvDiv ),;
                        "comentarios" =>        quoted( ( dbfRemMov )->cComMov ),;
                        "empresa_uuid" =>       quoted( uuidEmpresa() ) }

RETURN ( ::getInsertStatement( hCampos, "movimientos_almacen" ) )

//---------------------------------------------------------------------------//

METHOD getStatementSeederMovimientosAlmacenLineas( dbfHisMov )

   local hCampos  

   hCampos        := {  "uuid"                     => quoted( ( dbfHisMov )->cGuid ),;
                        "parent_uuid"              => quoted( ( dbfHisMov )->cGuidPar ),;
                        "codigo_articulo"          => quoted( ( dbfHisMov )->cRefMov ),;
                        "nombre_articulo"          => quoted( ( dbfHisMov )->cNomMov ),;
                        "codigo_primera_propiedad" => quoted( ( dbfHisMov )->cCodPr1 ),;
                        "valor_primera_propiedad"  => quoted( ( dbfHisMov )->cValPr1 ),;
                        "codigo_segunda_propiedad" => quoted( ( dbfHisMov )->cCodPr2 ),;
                        "valor_segunda_propiedad"  => quoted( ( dbfHisMov )->cValPr2 ),;
                        "lote"                     => quoted( ( dbfHisMov )->cLote ),;
                        "bultos_articulo"          => quoted( str( ( dbfHisMov )->nBultos ) ),;
                        "cajas_articulo"           => quoted( str( ( dbfHisMov )->nCajMov ) ),;
                        "unidades_articulo"        => quoted( str( ( dbfHisMov )->nUndMov ) ),;
                        "precio_articulo"          => quoted( str( ( dbfHisMov )->nPreDiv ) ) }

RETURN ( ::getInsertStatement( hCampos, "movimientos_almacen_lineas" ) )

//---------------------------------------------------------------------------//

METHOD SeederMovimientosAlmacenSeries()

   local dbf
   local cLastRec

   if ( file( cPatEmp( , .t. ) + "MovSer.Old" ) )
      RETURN ( self )
   end if

   if !( file( cPatEmp( , .t. ) + "MovSer.Dbf" ) )
      msgStop( "El fichero " + cPatEmp( , .t. ) + "\MovSer.Dbf no se ha localizado", "Atención" )  
      RETURN ( self )
   end if 

   USE ( cPatEmp( , .t. ) + "MovSer.Dbf" ) NEW VIA ( 'DBFCDX' ) SHARED ALIAS ( cCheckArea( "MovSer", @dbf ) )
   
   ( dbf )->( ordsetfocus(0) )
   
   cLastRec       := alltrim( str( ( dbf )->( lastrec() ) ) )

   ( dbf )->( dbgotop() )

   while !( dbf )->( eof() )
      
      ::oMsg:SetText( "Seeder de líneas de movimientos de almacén " + alltrim( str( ( dbf )->( recno() ) ) ) + " de " + cLastRec )

      getSQLDatabase():Exec( ::getStatementSeederMovimientosAlmacenLineasNumerosSeries( dbf ) )

      ( dbf )->( dbSkip() )

      sysrefresh()

   end while

   if dbf != nil
      ( dbf )->( dbCloseArea() )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getStatementSeederMovimientosAlmacenLineasNumerosSeries( dbfMovSer )

   local hCampos        

   hCampos        := {  "uuid"            => quoted( ( dbfMovSer )->cGuid ),;
                        "parent_uuid"     => quoted( ( dbfMovSer )->cGuidPar ),;
                        "numero_serie"    => quoted( ( dbfMovSer )->cNumSer ) }

RETURN ( ::getInsertStatement( hCampos, SQLMovimientosAlmacenLineasNumerosSeriesModel():getTableName() ) )

//---------------------------------------------------------------------------//

STATIC FUNCTION SincronizaRemesasMovimientosAlmacen()

   local oBlock
   local oError
   local dbfRemMov
   local dbfHisMov
   local dbfMovSer
   local cPath    := ( fullCurDir() + cPatEmp() + "\" )

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   dbUseArea( .t., cLocalDriver(), ( cPath + "RemMovT.Dbf" ), cCheckArea( "RemMovT", @dbfRemMov ), .f. ) 
   ( dbfRemMov )->( ordListAdd( cPath + "RemMovT.Cdx"  ) )

   dbUseArea( .t., cLocalDriver(), ( cPath + "HisMov.Dbf" ), cCheckArea( "HisMov", @dbfHisMov ), .f. ) 
   ( dbfHisMov )->( ordListAdd( cPath + "HisMov.Cdx"  ) )

   dbUseArea( .t., cLocalDriver(), ( cPath + "MovSer.Dbf" ), cCheckArea( "MovSer", @dbfMovSer ), .f. )  
   ( dbfMovSer )->( ordListAdd( cPath + "MovSer.Cdx"  ) )

   // Cabeceras-------------------------------------------------------------------

   ( dbfRemMov )->( ordSetFocus( 0 ) )

   ( dbfRemMov )->( dbGoTop() )
   while !( dbfRemMov )->( eof() )

      if empty( ( dbfRemMov )->cGuid )
         ( dbfRemMov )->cGuid          := win_uuidcreatestring()
      end if

      ( dbfRemMov )->( dbSkip() )

   end while

   ( dbfRemMov )->( ordSetFocus( 1 ) )

   // Lineas----------------------------------------------------------------------

   ( dbfHisMov )->( ordSetFocus( 0 ) )

   ( dbfHisMov )->( dbGoTop() )
   while !( dbfHisMov )->( eof() )

      if empty( ( dbfHisMov )->cGuid )
         ( dbfHisMov )->cGuid          := win_uuidcreatestring()
      end if

      if empty( ( dbfHisMov )->cGuidPar )
         ( dbfHisMov )->cGuidPar       := retfld( str( ( dbfHisMov )->nNumRem ) + ( dbfHisMov )->cSufRem, dbfRemMov, "cGuid", "cNumRem" )
      end if

      ( dbfHisMov )->( dbSkip() )

   end while

   ( dbfHisMov )->( ordSetFocus( 1 ) )

   // Series----------------------------------------------------------------------
   
   ( dbfMovSer )->( dbGoTop() )

   while !( dbfMovSer )->( eof() )

      if empty( ( dbfMovSer )->cGuid )
         ( dbfMovSer )->cGuid          := win_uuidcreatestring()
      end if

      //Vas por aqui----------------------------------------------------------

      if empty( ( dbfMovSer )->cGuidPar )
         ( dbfMovSer )->cGuidPar       := RetFld( Str( ( dbfMovSer )->nNumRem ) + ( dbfMovSer )->cSufRem + Str( ( dbfMovSer )->nNumLin, 9 ), dbfHisMov, "cGuid", "cNumRem" )
      end if

      ( dbfMovSer )->( dbSkip() )

   end while

   RECOVER USING oError
      msgstop( "Imposible abrir todas las bases de datos de movimientos de almacén" + CRLF + ErrorMessage( oError ) )
   END SEQUENCE
   ErrorBlock( oBlock )

   CLOSE ( dbfRemMov )
   CLOSE ( dbfHisMov )
   CLOSE ( dbfMovSer )

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION SincronizaListin()

   local oBlock
   local oError
   local dbfAgenda
   local cPath    := ( fullCurDir() + cPatDat() + "\" )

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   dbUseArea( .t., cLocalDriver(), ( cPath + "Agenda.Dbf" ), cCheckArea( "Agenda", @dbfAgenda ), .f. ) 
   ( dbfAgenda )->( ordListAdd( cPath + "Agenda.Cdx"  ) )

   // Cabeceras-------------------------------------------------------------------

   ( dbfAgenda )->( ordSetFocus( 0 ) )

   ( dbfAgenda )->( dbGoTop() )
   while !( dbfAgenda )->( eof() )

      if empty( ( dbfAgenda )->Uuid )
         ( dbfAgenda )->Uuid          := win_uuidcreatestring()
      end if

      ( dbfAgenda )->( dbSkip() )

   end while

   ( dbfAgenda )->( ordSetFocus( 1 ) )

   RECOVER USING oError
      msgstop( "Imposible abrir todas las bases de datos de movimientos de almacén" + CRLF + ErrorMessage( oError ) )
   END SEQUENCE
   ErrorBlock( oBlock )

   CLOSE ( dbfAgenda )

RETURN NIL

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//