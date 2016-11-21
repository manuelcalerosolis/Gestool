#include "FiveWin.Ch"

#include "Hbxml.ch"
#include "Hbclass.ch"
#include "Fileio.ch"

#include "Factu.ch" 
      
//---------------------------------------------------------------------------//

Function ImportarExcelProveedoresMarpicon( nView )                	 
	      
   local oImportarExcel    := TImportarExcelProveedoresMarpicon():New( nView )

   oImportarExcel:Run()

Return nil

//---------------------------------------------------------------------------//

CLASS TImportarExcelProveedoresMarpicon FROM TImportarExcel

   DATA idClient

   DATA nAutoIncremental         INIT 0

   METHOD New()

   METHOD procesaFicheroExcel()

   METHOD importarCampos()  

   METHOD actualizaDireccionCliente()

   METHOD getCampoClave()        INLINE ( padr( strzero( ::getExcelNumeric( ::cColumnaCampoClave ), 6 ), 12 ) )

   METHOD addAutoIncremental()   INLINE ( ++::nAutoIncremental )

   METHOD getAutoIncremental()   INLINE ( strzero( ::nAutoIncremental, 4 ) )

   METHOD existeRegistro()       

   METHOD appendRegistro()       INLINE ( ( D():Proveedores( ::nView ) )->( dbappend() ) )

   METHOD bloqueaRegistro()      INLINE ( ( D():Proveedores( ::nView ) )->( dbrlock() ) )

   METHOD desbloqueaRegistro()   INLINE ( ( D():Proveedores( ::nView ) )->( dbcommit() ),;
                                          ( D():Proveedores( ::nView ) )->( dbunlock() ) )


END CLASS

//----------------------------------------------------------------------------//

METHOD New( nView )

   ::Super:New( nView )

   /*
   Cambiar el nombre del fichero
   */

   ::cFicheroExcel            := "C:\Users\calero\Desktop\Proveedores_direcciones_marpicon.csv"

   /*
   Cambiar la fila de cominezo de la importacion
   */

   ::nFilaInicioImportacion   := 2

   /*
   Columna de campo clave
   */

   ::cColumnaCampoClave       := "C"

Return ( Self )

//----------------------------------------------------------------------------// 

METHOD procesaFicheroExcel()

   ::openExcel()

   while ( ::filaValida() )

      ::getCampoClave()

      ::addAutoIncremental()

      if ::seekOrAppend()      

         ::importarCampos()

         ::actualizaDireccionCliente()

         ::desbloqueaRegistro()

      endif

      ::siguienteLinea()

   end if

   ::closeExcel()

Return nil

//---------------------------------------------------------------------------//

METHOD existeRegistro()

Return ( D():gotoProveedores( ::getCampoClave() + ::getAutoIncremental(), ::nView ) )

//---------------------------------------------------------------------------//

METHOD importarCampos()

Return nil

//---------------------------------------------------------------------------//

METHOD actualizaDireccionCliente()

   if D():gotoProveedores( ::getCampoClave(), ::nView ) .and. ( ( D():Proveedores( ::nView ) )->( dbrlock() ) )

      if empty( ( D():Proveedores( ::nView ) )->Domicilio )
         ( D():Proveedores( ::nView ) )->Domicilio    := ::getExcelString( "F" ) + space( 1 ) + ::getExcelString( "G" )
      end if 
      
      if empty( ( D():Proveedores( ::nView ) )->Poblacion )
         ( D():Proveedores( ::nView ) )->Poblacion    := ::getExcelString( "J" )
      end if 
      
      if empty( ( D():Proveedores( ::nView ) )->CodPostal )
         ( D():Proveedores( ::nView ) )->CodPostal    := rjust( ::getExcelString( "K" ), "0", 5 )
      end if 

      if empty( ( D():Proveedores( ::nView ) )->Provincia )
         if D():gotoProvincias( left( ( D():Proveedores( ::nView ) )->CodPostal, 2 ), ::nView )
            ( D():Proveedores( ::nView ) )->Provincia := ( D():Provincias( ::nView ) )->cNomPrv
         end if 
      end if 

      if empty( ( D():Proveedores( ::nView ) )->Telefono )
         ( D():Proveedores( ::nView ) )->Telefono     := ::getExcelString( "O" )
      end if 

      if empty( ( D():Proveedores( ::nView ) )->cMeiInt )
         ( D():Proveedores( ::nView ) )->cMeiInt      := ::getExcelString( "S" )
      end if 

      ( D():Proveedores( ::nView ) )->( dbcommit() )
      ( D():Proveedores( ::nView ) )->( dbunlock() ) 

   else 

      logwrite( 'no encontrado ' + ::getCampoClave())

   end if 

Return nil

//---------------------------------------------------------------------------//

#include "ImportarExcel.prg"

/*
   aAdd( aItmObr, { "cCodCli",   "C",   12,    0, "" ,                                 "",                  "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cCodObr",   "C",   10,    0, "Código de la dirección" ,           "",                  "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cNomObr",   "C",  150,    0, "Nombre de la dirección" ,           "'@!'",              "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cDirObr",   "C",  100,    0, "Domicilio de la dirección" ,        "'@!'",              "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cPobObr",   "C",  100,    0, "Población de la dirección" ,        "'@!'",              "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cPrvObr",   "C",   20,    0, "Provincia de la dirección" ,        "'@!'",              "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cPosObr",   "C",   10,    0, "Código postal de la dirección" ,    "'@!'",              "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cTelObr",   "C",   17,    0, "Teléfono de la dirección" ,         "",                  "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cFaxObr",   "C",   17,    0, "Fax de la dirección" ,              "",                  "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cCntObr",   "C",  100,    0, "Contacto de la dirección" ,         "'@!'",              "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cMovObr",   "C",   17,    0, "Móvil de la dirección" ,            "",                  "", "( cDbfObr )" } )
   aAdd( aItmObr, { "lDefObr",   "L",    1,    0, "Lógico de dirección por defecto" ,  "",                  "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cCodEdi",   "C",   17,    0, "Código del cliente en EDI (EAN)",   "",                  "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cCodWeb",   "N",   11,    0, "Codigo para la web             ",   "",                  "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cEstObr",   "C",   35,    0, "Nombre del establecimiento     ",   "",                  "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cCodPos",   "C",   12,    0, "Número operacional" ,               "",                  "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cDeparta",  "C",    4,    0, "Departamento" ,                     "",                  "", "( cDbfObr )" } )
   aAdd( aItmObr, { "Nif",       "C",   30,    0, "Nif de la dirección" ,              "",                  "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cDomEnt",   "C",  200,    0, "Domicilio de entrega" ,             "",                  "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cPobEnt",   "C",  200,    0, "Población de entrega" ,             "",                  "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cCPEnt",    "C",   15,    0, "Código postal de entrega" ,         "",                  "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cPrvEnt",   "C",  100,    0, "Provincia de entrega" ,             "",                  "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cProvee",   "C",   50,    0, "Código de proveedor" ,              "",                  "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cCodBic",   "C",   50,    0, "Código Bic" ,                       "",                  "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cHorario",  "C",   50,    0, "Horario" ,                          "",                  "", "( cDbfObr )" } )
   aAdd( aItmObr, { "cTipo",     "C",   50,    0, "Tipo de obra" ,                     "",                  "", "( cDbfObr )" } )
*/