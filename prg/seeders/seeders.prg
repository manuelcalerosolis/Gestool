#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS Seeders

   DATA oMsg

   METHOD New()

   METHOD runSeederDatos()
   METHOD runSeederEmpresa()

   METHOD getInsertStatement( hCampos, cDataBaseName )

   METHOD SeederSituaciones()
   METHOD getStatementSituaciones( dbfSitua )

   METHOD SeederTiposImpresoras()
   METHOD getStatementTiposImpresoras( dbfTipImp )

   METHOD SeederTiposNotas()
   METHOD getStatementTiposNotas( dbfTipNotas )

   METHOD SeederTiposVentas()
   METHOD getStatementTiposVentas( dbfTipVentas )

   METHOD SeederMovimientosAlmacen()
   METHOD getStatementSeederMovimientosAlmacen( dbfRemMov )

   METHOD SeederMovimientosAlmacenLineas()
   METHOD getStatementSeederMovimientosAlmacenLineas( dbfHisMov )

   METHOD SeederMovimientosAlmacenSeries()
   METHOD getStatementSeederMovimientosAlmacenLineasNumerosSeries( dbfMovSer )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oMsg ) CLASS Seeders

   ::oMsg            := oMsg

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD runSeederDatos()

   ::oMsg:SetText( "Datos: Ejecutando seeder de situaciones" )
   ::SeederSituaciones()

   ::oMsg:SetText( "Datos: Ejecutando seeder de tipos de impresoras" )
   ::SeederTiposImpresoras()

   ::oMsg:SetText( "Datos: Ejecutando seeder de tipos de notas" )
   ::SeederTiposNotas()

   ::oMsg:SetText( "Datos: Ejecutando seeder de tipos de ventas" )
   ::SeederTiposVentas()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD runSeederEmpresa()

   ::oMsg:SetText( "Ejecutando seeder de cabeceras de movimientos de almacén" )
   ::SeederMovimientosAlmacen()
   
   ::oMsg:SetText( "Ejecutando seeder de líneas de movimientos de almacén" )
   ::SeederMovimientosAlmacenLineas()

   ::oMsg:SetText( "Ejecutando seeder de números de serie de lineas de movimientos de almacén" )
   ::SeederMovimientosAlmacenSeries()

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

METHOD SeederSituaciones() CLASS Seeders

   local cPath       := cPatDat( .t. )
   local dbfSitua

   if ( file( cPath + "Situa.old" ) )
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

METHOD SeederTiposNotas() CLASS Seeders

   local cPath       := cPatDat( .t. )
   local dbfTipNotas

   if ( file( cPath + "TipoNotas.old" ) )
      RETURN ( self )
   end if

   if !( file( cPath + "TipoNotas.Dbf" ) )
      msgStop( "El fichero " + cPath + "\TipoNotas.Dbf no se ha localizado", "Atención" )  
      RETURN ( self )
   end if 

   USE ( cPath + "TipoNotas.Dbf" ) NEW VIA ( 'DBFCDX' ) SHARED ALIAS ( cCheckArea( "TipoNotas", @dbfTipNotas ) )
   ( dbfTipNotas )->( ordsetfocus(0) )
   
   ( dbfTipNotas )->( dbgotop() )
   while !( dbfTipNotas )->( eof() )

      getSQLDatabase():Exec( ::getStatementTiposNotas( dbfTipNotas ) )

      ( dbfTipNotas )->( dbSkip() )

   end while

   if dbfTipNotas != nil
      ( dbfTipNotas )->( dbCloseArea() )
   end if

   frename( cPath + "TipoNotas.dbf", cPath + "TipoNotas.old" )
   
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getStatementTiposNotas( dbfTipNotas )

   local hCampos        := { "nombre" => quoted( ( dbfTipNotas )->cTipo ) }

RETURN ( ::getInsertStatement( hCampos, "tipos_notas" ) )

//---------------------------------------------------------------------------//

METHOD SeederTiposVentas() CLASS Seeders

   local cPath       := cPatDat( .t. )
   local dbfTipVentas

   if ( file( cPath + "TVTA.old" ) )
      RETURN ( self )
   end if

   if !( file( cPath + "TVTA.Dbf" ) )
      msgStop( "El fichero " + cPath + "\TVTA.Dbf no se ha localizado", "Atención" )  
      RETURN ( self )
   end if 

   USE ( cPath + "TVTA.Dbf" ) NEW VIA ( 'DBFCDX' ) SHARED ALIAS ( cCheckArea( "TVTA", @dbfTipVentas ) )
   ( dbfTipVentas )->( ordsetfocus(0) )
   
   ( dbfTipVentas )->( dbgotop() )
   while !( dbfTipVentas )->( eof() )

      getSQLDatabase():Exec( ::getStatementTiposVentas( dbfTipVentas ) )

      ( dbfTipVentas )->( dbSkip() )

   end while

   if dbfTipVentas != nil
      ( dbfTipVentas )->( dbCloseArea() )
   end if

   frename( cPath + "TVTA.dbf", cPath + "TVTA.old" )
   
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getStatementTiposVentas( dbfTipVentas )

   local hCampos        := { "codigo" => quoted( ( dbfTipVentas )->cCodMov ),;
                             "nombre"=> quoted( ( dbfTipVentas )->cDesMov ) }

RETURN ( ::getInsertStatement( hCampos, "tipos_ventas" ) )

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

   //frename( cPath + "RemMovT.dbf", cPath + "RemMovT.old" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getStatementSeederMovimientosAlmacen( dbfRemMov )

   local hCampos

   hCampos        := {  "empresa" =>            quoted( cCodEmp() ),;
                        "delegacion" =>         quoted( ( dbfRemMov )->cCodDlg ),;
                        "usuario" =>            quoted( ( dbfRemMov )->cCodUsr ),;
                        "uuid" =>               quoted( ( dbfRemMov )->cGuid ),;
                        "numero" =>             quoted( ( dbfRemMov )->nNumRem ),;
                        "tipo_movimiento" =>    quoted( ( dbfRemMov )->nTipMov ),;
                        "fecha_hora" =>         quoted( dateTimeToTimeStamp( ( dbfRemMov )->dFecRem, ( dbfRemMov )->cTimRem ) ),;
                        "almacen_origen" =>     quoted( ( dbfRemMov )->cAlmOrg ),;
                        "almacen_destino" =>    quoted( ( dbfRemMov )->cAlmDes ),;
                        "grupo_movimiento" =>   quoted( ( dbfRemMov )->cCodMov ),;
                        "agente" =>             quoted( ( dbfRemMov )->cCodAge ),;
                        "divisa" =>             quoted( ( dbfRemMov )->cCodDiv ),;
                        "divisa_cambio" =>      quoted( ( dbfRemMov )->nVdvDiv ),;
                        "comentarios" =>        quoted( ( dbfRemMov )->cComMov ) }

RETURN ( ::getInsertStatement( hCampos, "movimientos_almacen" ) )

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

   //frename( cPath + "HisMov.dbf", cPath + "HisMov.old" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getStatementSeederMovimientosAlmacenLineas( dbfHisMov )

   local hCampos  

   hCampos        := {  "uuid" =>                     quoted( ( dbfHisMov )->cGuid ),;
                        "parent_uuid" =>              quoted( ( dbfHisMov )->cGuidPar ),;
                        "codigo_articulo" =>          quoted( ( dbfHisMov )->cRefMov ),;
                        "nombre_articulo" =>          quoted( ( dbfHisMov )->cNomMov ),;
                        "codigo_primera_propiedad" => quoted( ( dbfHisMov )->cCodPr1 ),;
                        "valor_primera_propiedad" =>  quoted( ( dbfHisMov )->cValPr1 ),;
                        "codigo_segunda_propiedad" => quoted( ( dbfHisMov )->cCodPr2 ),;
                        "valor_segunda_propiedad" =>  quoted( ( dbfHisMov )->cValPr2 ),;
                        "lote" =>                     quoted( ( dbfHisMov )->cLote ),;
                        "bultos_articulo" =>          quoted( str( ( dbfHisMov )->nBultos ) ),;
                        "cajas_articulo" =>           quoted( str( ( dbfHisMov )->nCajMov ) ),;
                        "unidades_articulo" =>        quoted( str( ( dbfHisMov )->nUndMov ) ),;
                        "precio_articulo" =>          quoted( str( ( dbfHisMov )->nPreDiv ) ) }

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
