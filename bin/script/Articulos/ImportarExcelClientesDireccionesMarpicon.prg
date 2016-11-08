#include "FiveWin.Ch"

#include "Hbxml.ch"
#include "Hbclass.ch"
#include "Fileio.ch"

#include "Factu.ch" 
      
//---------------------------------------------------------------------------//

Function ImportarExcelClientesMarpicon( nView )                	 
	      
   local oImportarExcel    := TImportarExcelClientesMarpicon():New( nView )

   oImportarExcel:Run()

Return nil

//---------------------------------------------------------------------------//

CLASS TImportarExcelClientesMarpicon FROM TImportarExcel

   DATA idClient

   DATA nAutoIncremental         INIT 0

   METHOD New()

   METHOD procesaFicheroExcel()

   METHOD importarCampos()   

   METHOD getCampoClave()        

   METHOD addAutoIncremental()   INLINE ( ++::nAutoIncremental )

   METHOD getAutoIncremental()   INLINE ( strzero( ::nAutoIncremental, 4 ) )

   METHOD existeRegistro()       

   METHOD appendRegistro()       INLINE ( ( D():ClientesDirecciones( ::nView ) )->( dbappend() ) )

   METHOD bloqueaRegistro()      INLINE ( ( D():ClientesDirecciones( ::nView ) )->( dbrlock() ) )

   METHOD desbloqueaRegistro()   INLINE ( ( D():ClientesDirecciones( ::nView ) )->( dbcommit() ),;
                                          ( D():ClientesDirecciones( ::nView ) )->( dbunlock() ) )


END CLASS

//----------------------------------------------------------------------------//

METHOD New( nView )

   ::Super:New( nView )

   /*
   Cambiar el nombre del fichero
   */

   ::cFicheroExcel            := "C:\Users\calero\Desktop\clientes_direcciones_marpicon.csv"

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

METHOD getCampoClave()

   local keyClient            := str( int( ::getExcelNumeric( ::cColumnaCampoClave ) ), 11 )

   ::idClient                 := nil

   if !empty( keyClient )
      if ( D():SeekInOrd( D():Clientes( ::nView ), keyClient, "cCodWeb" ) ) 
         ::idClient           := D():ClientesId( ::nView )
      end if 
   end if 

Return ( ::idClient )

//----------------------------------------------------------------------------// 

METHOD procesaFicheroExcel()

   ::openExcel()

   while ( ::filaValida() )

      ::getCampoClave()

      ::addAutoIncremental()

      if ::existeRegistro()

         // msgalert( "existeRegistro" )

        ::bloqueaRegistro()
      else
         
         // msgalert( "appendRegistro" )

         ::appendRegistro()

      end if 

      if !( neterr() )      

         // msgalert( "importarCampos")

         ::importarCampos()

         ::desbloqueaRegistro()

      endif

      ::siguienteLinea()

   end if

   ::closeExcel()

Return nil

//---------------------------------------------------------------------------//

METHOD existeRegistro()

Return ( D():gotoIdClientesDirecciones( ::idClient + ::getAutoIncremental(), ::nView ) )

//---------------------------------------------------------------------------//

METHOD importarCampos()

   ( D():ClientesDirecciones( ::nView ) )->cCodCli    := ::idClient
   ( D():ClientesDirecciones( ::nView ) )->cCodObr    := ::getAutoIncremental()

   ( D():ClientesDirecciones( ::nView ) )->cTipo      := ::getExcelString( "D" )
   ( D():ClientesDirecciones( ::nView ) )->cNomObr    := ::getExcelString( "E" )  
   ( D():ClientesDirecciones( ::nView ) )->cDirObr    := ::getExcelString( "F" )  

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