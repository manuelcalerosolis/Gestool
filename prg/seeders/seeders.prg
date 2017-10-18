#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS Seeders

   DATA oMsg

   METHOD New()

   METHOD runSeederDatos()
   METHOD runSeederEmpresa()

   METHOD SeederSituaciones()
   METHOD getStatementSituaciones( dbfSitua )      INLINE   ( "INSERT INTO situaciones ( nombre ) VALUES ( " + quoted( ( dbfSitua )->cSitua ) + " )" )

   METHOD SeederTiposImpresoras()
   METHOD getStatementTiposImpresoras( dbfTipImp ) INLINE   ( "INSERT INTO tipos_impresoras ( nombre ) VALUES ( " + quoted( ( dbfTipImp )->cTipImp ) + " )" )

   METHOD SeederTiposNotas()
   METHOD getStatementTiposNotas( dbfTipNotas )    INLINE   ( "INSERT INTO tipos_notas ( nombre ) VALUES ( " + quoted( ( dbfTipNotas )->cTipo ) + " )" )

   METHOD SeederTiposVentas()
   METHOD getStatementTiposVentas( dbfTipVentas )  INLINE   ( "INSERT INTO tipos_ventas ( codigo, nombre ) VALUES ( " + quoted( ( dbfTipVentas )->cCodMov ) + ", " + quoted( ( dbfTipVentas )->cDesMov ) + " )" )

   METHOD SeederMovimientosAlmacen( cCodEmpresa )
   METHOD getStatementSeederMovimientosAlmacen( dbfRemMov )

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

Return ( self )

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

METHOD SeederMovimientosAlmacen()

   local cPath       := cPatEmp( , .t. )
   local dbfRemMovT

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

      getSQLDatabase():Exec( ::getStatementSeederMovimientosAlmacen( dbfRemMovT ) )

      ( dbfRemMovT )->( dbSkip() )

   end while

   if dbfRemMovT != nil
      ( dbfRemMovT )->( dbCloseArea() )
   end if

   //frename( cPath + "RemMovT.dbf", cPath + "RemMovT.old" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getStatementSeederMovimientosAlmacen( dbfRemMov )

   local cStatement     := "INSERT INTO movimientos_almacen "
         cStatement     += "( uuid, "
         cStatement     += "empresa, "
         cStatement     += "delegacion, "
         cStatement     += "usuario, "
         cStatement     += "numero, "
         cStatement     += "tipo_movimiento, " 
         cStatement     += "fecha_hora, "
         cStatement     += "almacen_origen, "
         cStatement     += "almacen_destino, "
         cStatement     += "grupo_movimiento, "
         cStatement     += "agente, "
         cStatement     += "divisa, " 
         cStatement     += "divisa_cambio, "
         cStatement     += "comentarios ) "
         cStatement     += "VALUES ( " + quoted( ( dbfRemMov )->cGuid ) + ", "
         cStatement     += quoted( cCodEmp() ) + ", "
         cStatement     += quoted( ( dbfRemMov )->cCodDlg ) + ", "
         cStatement     += quoted( ( dbfRemMov )->cCodUsr ) + ", "
         cStatement     += quoted( ( dbfRemMov )->nNumRem ) + ", "
         cStatement     += quoted( ( dbfRemMov )->nTipMov ) + ", "
         cStatement     += quoted( DateTimeToTimestamp( ( dbfRemMov )->dFecRem, ( dbfRemMov )->cTimRem ) ) + ", "
         cStatement     += quoted( ( dbfRemMov )->cAlmOrg ) + ", "
         cStatement     += quoted( ( dbfRemMov )->cAlmDes ) + ", "
         cStatement     += quoted( ( dbfRemMov )->cCodMov ) + ", "
         cStatement     += quoted( ( dbfRemMov )->cCodAge ) + ", "
         cStatement     += quoted( ( dbfRemMov )->cCodDiv ) + ", "
         cStatement     += quoted( ( dbfRemMov )->nVdvDiv ) + ", "
         cStatement     += quoted( ( dbfRemMov )->cComMov ) + " )"

Return cStatement

//---------------------------------------------------------------------------//

//TDataCenter():ExecuteSqlStatement( 'SELECT * FROM datosSitua', "resultado" )