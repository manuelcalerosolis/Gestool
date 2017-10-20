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
   METHOD getStatementSeederMovimientosAlmacenSeries( dbfMovSer )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oMsg ) CLASS Seeders

   ::oMsg            := oMsg

Return ( self )

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

Return ( self )

//---------------------------------------------------------------------------//

METHOD runSeederEmpresa()

   local cTxtEmpresa    := "Empresa " + cCodEmp() + "-" + cNbrEmp() + ": "

   ::oMsg:SetText( cTxtEmpresa + "Ejecutando seeder de cabeceras de movimientos de almacén" )
   ::SeederMovimientosAlmacen()
   
   ::oMsg:SetText( cTxtEmpresa + "Ejecutando seeder de lineas de movimientos de almacén" )
   ::SeederMovimientosAlmacenLineas()

   ::oMsg:SetText( cTxtEmpresa + "Ejecutando seeder de números de serie de lineas de movimientos de almacén" )
   ::SeederMovimientosAlmacenSeries()

Return ( self )

//---------------------------------------------------------------------------//

METHOD getInsertStatement( hCampos, cDataBaseName )

   local cStatement  := ""

   cStatement     := "INSERT INTO "
   cStatement     += cDataBaseName + Space( 1 )
   cStatement     += "( "
   hEval( hCampos, {| k, v | cStatement += k + ", " } )
   cStatement     := chgAtEnd( cStatement, " ) VALUES ( ", 2 )
   hEval( hCampos, {| k, v | cStatement += v + ", " } )
   cStatement     := chgAtEnd( cStatement, " )", 2 )

Return cStatement

//---------------------------------------------------------------------------//

METHOD SeederSituaciones() CLASS Seeders

   local cPath       := cPatDat( .t. )
   local dbfSitua

   if ( file( cPath + "Situa.old" ) )
      Return ( self )
   end if

   if !( file( cPath + "Situa.Dbf" ) )
      msgStop( "El fichero " + cPath + "\Situa.Dbf no se ha localizado", "Atención" )  
      Return ( self )
   end if 

   USE ( cPath + "SITUA.Dbf" ) NEW VIA ( 'DBFCDX' ) SHARED ALIAS ( cCheckArea( "SITUA", @dbfSitua ) )
   ( dbfSitua )->( ordsetfocus(0) )

   ( dbfSitua )->( dbGoTop() )

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
      Return ( self )
   end if

   if !( file( cPath + "TipImp.Dbf" ) )
      msgStop( "El fichero " + cPath + "\TipImp.Dbf no se ha localizado", "Atención" )  
      Return ( self )
   end if 

   USE ( cPath + "TipImp.Dbf" ) NEW VIA ( 'DBFCDX' ) SHARED ALIAS ( cCheckArea( "TipImp", @dbfTipImp ) )
   ( dbfTipImp )->( ordsetfocus(0) )
   
   ( dbfTipImp )->( dbGoTop() )
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
      Return ( self )
   end if

   if !( file( cPath + "TipoNotas.Dbf" ) )
      msgStop( "El fichero " + cPath + "\TipoNotas.Dbf no se ha localizado", "Atención" )  
      Return ( self )
   end if 

   USE ( cPath + "TipoNotas.Dbf" ) NEW VIA ( 'DBFCDX' ) SHARED ALIAS ( cCheckArea( "TipoNotas", @dbfTipNotas ) )
   ( dbfTipNotas )->( ordsetfocus(0) )
   
   ( dbfTipNotas )->( dbGoTop() )
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
      Return ( self )
   end if

   if !( file( cPath + "TVTA.Dbf" ) )
      msgStop( "El fichero " + cPath + "\TVTA.Dbf no se ha localizado", "Atención" )  
      Return ( self )
   end if 

   USE ( cPath + "TVTA.Dbf" ) NEW VIA ( 'DBFCDX' ) SHARED ALIAS ( cCheckArea( "TVTA", @dbfTipVentas ) )
   ( dbfTipVentas )->( ordsetfocus(0) )
   
   ( dbfTipVentas )->( dbGoTop() )
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

   local cPath       := cPatEmp( , .t. )
   local dbfRemMovT
   local cStatement

   if ( file( cPath + "RemMovT.old" ) )
      Return ( self )
   end if

   if !( file( cPath + "RemMovT.Dbf" ) )
      msgStop( "El fichero " + cPath + "\RemMovT.Dbf no se ha localizado", "Atención" )  
      Return ( self )
   end if 

   USE ( cPath + "RemMovT.Dbf" ) NEW VIA ( 'DBFCDX' ) SHARED ALIAS ( cCheckArea( "RemMovT", @dbfRemMovT ) )
   
   ( dbfRemMovT )->( ordsetfocus(0) )

   ( dbfRemMovT )->( dbGoTop() )

   while !( dbfRemMovT )->( eof() )
      
      cStatement  := "SELECT id "                                                         + ;
                        "FROM movimientos_almacen "                                       + ;
                        "WHERE uuid = " + quoted( ( dbfRemMovT )->cGuid ) + Space( 1 )    + ;
                        "LIMIT 1"

      if Empty( getSQLDatabase():selectFetchArrayOneColumn( cStatement ) )
         getSQLDatabase():Exec( ::getStatementSeederMovimientosAlmacen( dbfRemMovT ) )
      end if

      ( dbfRemMovT )->( dbSkip() )

   end while

   if dbfRemMovT != nil
      ( dbfRemMovT )->( dbCloseArea() )
   end if

   //frename( cPath + "RemMovT.dbf", cPath + "RemMovT.old" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getStatementSeederMovimientosAlmacen( dbfRemMov )

   local hCampos        := {  "uuid" => quoted( ( dbfRemMov )->cGuid ),;
                              "empresa" => quoted( cCodEmp() ),;
                              "delegacion" => quoted( ( dbfRemMov )->cCodDlg ),;
                              "usuario" => quoted( ( dbfRemMov )->cCodUsr ),;
                              "numero" => quoted( ( dbfRemMov )->nNumRem ),;
                              "tipo_movimiento" => quoted( ( dbfRemMov )->nTipMov ),;
                              "fecha_hora" => quoted( DateTimeToTimestamp( ( dbfRemMov )->dFecRem, ( dbfRemMov )->cTimRem ) ),;
                              "almacen_origen" => quoted( ( dbfRemMov )->cAlmOrg ),;
                              "almacen_destino" => quoted( ( dbfRemMov )->cAlmDes ),;
                              "grupo_movimiento" => quoted( ( dbfRemMov )->cCodMov ),;
                              "agente" => quoted( ( dbfRemMov )->cCodAge ),;
                              "divisa" => quoted( ( dbfRemMov )->cCodDiv ),;
                              "divisa_cambio" => quoted( ( dbfRemMov )->nVdvDiv ),;
                              "comentarios" => quoted( ( dbfRemMov )->cComMov ) }

RETURN ( ::getInsertStatement( hCampos, "movimientos_almacen" ) )

//---------------------------------------------------------------------------//

METHOD SeederMovimientosAlmacenLineas()

   local cPath       := cPatEmp( , .t. )
   local dbfHisMov
   local cStatement

   if ( file( cPath + "HisMov.old" ) )
      Return ( self )
   end if

   if !( file( cPath + "HisMov.Dbf" ) )
      msgStop( "El fichero " + cPath + "\HisMov.Dbf no se ha localizado", "Atención" )  
      Return ( self )
   end if 

   USE ( cPath + "HisMov.Dbf" ) NEW VIA ( 'DBFCDX' ) SHARED ALIAS ( cCheckArea( "HisMov", @dbfHisMov ) )
   
   ( dbfHisMov )->( ordsetfocus(0) )

   ( dbfHisMov )->( dbGoTop() )

   while !( dbfHisMov )->( eof() )
      
      cStatement  := "SELECT id "                                                         + ;
                        "FROM movimientos_almacen_lineas "                                + ;
                        "WHERE uuid = " + quoted( ( dbfHisMov )->cGuid ) + Space( 1 )     + ;
                        "LIMIT 1"

      if Empty( getSQLDatabase():selectFetchArrayOneColumn( cStatement ) )
         getSQLDatabase():Exec( ::getStatementSeederMovimientosAlmacenLineas( dbfHisMov ) )
      end if

      ( dbfHisMov )->( dbSkip() )

   end while

   if dbfHisMov != nil
      ( dbfHisMov )->( dbCloseArea() )
   end if

   //frename( cPath + "HisMov.dbf", cPath + "HisMov.old" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getStatementSeederMovimientosAlmacenLineas( dbfHisMov )

   local hCampos        := {  "uuid" => quoted( ( dbfHisMov )->cGuid ),;
                              "parent_uuid" => quoted( ( dbfHisMov )->cGuidPar ),;
                              "codigo_articulo" => quoted( ( dbfHisMov )->cRefMov ),;
                              "nombre_articulo" => quoted( ( dbfHisMov )->cNomMov ),;
                              "codigo_primera_propiedad" => quoted( ( dbfHisMov )->cCodPr1 ),;
                              "valor_primera_propiedad" => quoted( ( dbfHisMov )->cValPr1 ),;
                              "codigo_segunda_propiedad" => quoted( ( dbfHisMov )->cCodPr2 ),;
                              "valor_segunda_propiedad" => quoted( ( dbfHisMov )->cValPr2 ),;
                              "lote" => quoted( ( dbfHisMov )->cLote ),;
                              "bultos_articulo" => quoted( Str( ( dbfHisMov )->nBultos ) ),;
                              "cajas_articulo" => quoted( Str( ( dbfHisMov )->nCajMov ) ),;
                              "unidades_articulo" => quoted( Str( ( dbfHisMov )->nUndAnt ) ),;
                              "precio_articulo" => quoted( Str( ( dbfHisMov )->nPreDiv ) ) }


RETURN ( ::getInsertStatement( hCampos, "movimientos_almacen_lineas" ) )

//---------------------------------------------------------------------------//

METHOD SeederMovimientosAlmacenSeries()

   local cPath       := cPatEmp( , .t. )
   local dbfMovSer
   local cStatement

   if ( file( cPath + "MovSer.old" ) )
      Return ( self )
   end if

   if !( file( cPath + "MovSer.Dbf" ) )
      msgStop( "El fichero " + cPath + "\MovSer.Dbf no se ha localizado", "Atención" )  
      Return ( self )
   end if 

   USE ( cPath + "MovSer.Dbf" ) NEW VIA ( 'DBFCDX' ) SHARED ALIAS ( cCheckArea( "MovSer", @dbfMovSer ) )
   
   ( dbfMovSer )->( ordsetfocus(0) )

   ( dbfMovSer )->( dbGoTop() )

   while !( dbfMovSer )->( eof() )
      
      cStatement  := "SELECT id "                                                         + ;
                        "FROM numeros_series "                                            + ;
                        "WHERE uuid = " + quoted( ( dbfMovSer )->cGuid ) + Space( 1 )     + ;
                        "LIMIT 1"

      if Empty( getSQLDatabase():selectFetchArrayOneColumn( cStatement ) )
         getSQLDatabase():Exec( ::getStatementSeederMovimientosAlmacenSeries( dbfMovSer ) )
      end if

      ( dbfMovSer )->( dbSkip() )

   end while

   if dbfMovSer != nil
      ( dbfMovSer )->( dbCloseArea() )
   end if

   //frename( cPath + "MovSer.dbf", cPath + "MovSer.old" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getStatementSeederMovimientosAlmacenSeries( dbfMovSer )

   local hCampos        := {  "uuid" => quoted( ( dbfMovSer )->cGuid ),;
                              "parent_uuid" => quoted( ( dbfMovSer )->cGuidPar ),;
                              "numero_serie" => quoted( ( dbfMovSer )->cNumSer ) }

RETURN ( ::getInsertStatement( hCampos, "numeros_series" ) )

//---------------------------------------------------------------------------//

//TDataCenter():ExecuteSqlStatement( 'SELECT * FROM datosSitua', "resultado" )