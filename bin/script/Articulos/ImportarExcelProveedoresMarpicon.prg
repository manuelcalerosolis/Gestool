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

   METHOD New()

   METHOD procesaFicheroExcel()

   METHOD importarCampos()   

   METHOD getCampoClave()        INLINE ( strzero( ::getExcelNumeric( ::cColumnaCampoClave ), 6 ) )

   METHOD existeRegistro()       INLINE ( D():gotoProveedores( ::getCampoClave(), ::nView ) )

   METHOD appendRegistro()       INLINE ( ( D():Proveedores( ::nView ) )->( dbappend() ), logwrite( 'appendRegistro' + ::getCampoClave() ) )

   METHOD bloqueaRegistro()      INLINE ( ( D():Proveedores( ::nView ) )->( dbrlock() ), logwrite( 'bloqueaRegistro' + ::getCampoClave() ) )

   METHOD desbloqueaRegistro()   INLINE ( ( D():Proveedores( ::nView ) )->( dbcommit() ),;
                                          ( D():Proveedores( ::nView ) )->( dbunlock() ) )


END CLASS

//----------------------------------------------------------------------------//

METHOD New( nView )

   ::Super:New( nView )

   /*
   Cambiar el nombre del fichero
   */

   ::cFicheroExcel            := "C:\Users\calero\Desktop\Proveedores_marpicon.csv"

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

      if ::seekOrAppend()      

         ::importarCampos()

         ::desbloqueaRegistro()

      endif

      ::siguienteLinea()

   end if

   ::closeExcel()

Return nil

//---------------------------------------------------------------------------//

METHOD importarCampos()

   ( D():Proveedores( ::nView ) )->Cod       := ::getCampoClave()
   ( D():Proveedores( ::nView ) )->Titulo    := ::getExcelValue( "D" )
   ( D():Proveedores( ::nView ) )->Nif       := ::getExcelString( "M" )  

Return nil

//---------------------------------------------------------------------------//

#include "ImportarExcel.prg"

/*
   aAdd( aItmPrv, { "COD",       "C", 12, 0, "Código proveedor",                     "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "TITULO",    "C", 80, 0, "Nombre proveedor",                     "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "NIF",       "C", 15, 0, "NIF proveedor",                        "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "DOMICILIO", "C",200, 0, "Domicilio proveedor",                  "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "POBLACION", "C",200, 0, "Población proveedor",                  "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "PROVINCIA", "C",100, 0, "Provincia proveedor",                  "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CCODPAI",   "C",  4, 0, "Código de país" ,                      "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CPERCTO",   "C", 40, 0, "Persona de contacto",                  "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CSUCLI",    "C", 14, 0, "Código de su cliente" ,                "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CODPOSTAL", "C", 15, 0, "Código postal proveedor",              "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "TELEFONO",  "C", 50, 0, "Teléfono proveedor",                   "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "FAX",       "C", 50, 0, "Fax proveedor",                        "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "MOVIL",     "C", 50, 0, "Movil proveedor",                      "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "cDtoEsp",   "C", 50, 0, "Descripción de descuento especial",    "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "nDtoEsp",   "N",  6, 2, "Descuento especial",                   "'@R 99.9 %'",        "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "cDtoPp",    "C", 50, 0, "Descripción de descuento pronto pago", "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "DtoPp",     "N",  6, 2, "Descuento pronto pago",                "'@R 99.9 %'",        "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "FPAGO",     "C",  2, 0, "Forma de pago proveedor",              "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "DIAPAGO",   "N",  2, 0, "Primer día pago proveedor",            "'99'",               "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "DIAPAGO2",  "N",  2, 0, "Segundo día pago proveedor",           "'99'",               "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "SUBCTA",    "C", 12, 0, "Subcuenta contaplus proveedor",        "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CTAVENTA",  "C",  3, 0, "Cuenta contaplus proveedor",           "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "LLABEL",    "L",  1, 0, "Lógico para etiquetas",                "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "NLABEL",    "N",  5, 0, "Número de etiquetas a imprimir",       "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CCODSND",   "C",  3, 0, "Código de envio proveedor",            "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CMEIINT",   "C", 65, 0, "dirección e-mail proveedor",           "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CWEBINT",   "C",100, 0, "Página web proveedor",                 "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CUSRINT",   "C", 14, 0, "Usuario para la web del proveedor",    "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CPSWINT",   "C", 14, 0, "Clave de acceso para la web del proveedor", "",              "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "MCOMENT",   "M", 10, 0, "Memo para comentarios",                "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "NMESVAC",   "N",  1, 0, "Mes de vacaciones",                    "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "NCOPIASF",  "N",  1, 0, "Número de facturas a imprimir",        "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CUSRDEF01", "C",100, 0, "Campo definido 1" ,                    "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CUSRDEF02", "C",100, 0, "Campo definido 2" ,                    "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CUSRDEF03", "C",100, 0, "Campo definido 3" ,                    "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CUSRDEF04", "C",100, 0, "Campo definido 4" ,                    "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CUSRDEF05", "C",100, 0, "Campo definido 5" ,                    "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CUSRDEF06", "C",100, 0, "Campo definido 6" ,                    "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CUSRDEF07", "C",100, 0, "Campo definido 7" ,                    "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CUSRDEF08", "C",100, 0, "Campo definido 8" ,                    "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CUSRDEF09", "C",100, 0, "Campo definido 9" ,                    "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CUSRDEF10", "C",100, 0, "Campo definido 10" ,                   "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "NVALPUNT",  "N", 16, 6, "Valor del punto" ,                     "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "CTELCTO",   "C", 12, 0, "Teléfono del contacto" ,               "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "Benef1",    "N",  6, 2, "Porcentaje de beneficio1" ,            "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "Benef2",    "N",  6, 2, "Porcentaje de beneficio2" ,            "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "Benef3",    "N",  6, 2, "Porcentaje de beneficio3" ,            "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "Benef4",    "N",  6, 2, "Porcentaje de beneficio4" ,            "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "Benef5",    "N",  6, 2, "Porcentaje de beneficio5" ,            "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "Benef6",    "N",  6, 2, "Porcentaje de beneficio6" ,            "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "nBnfSbr1",  "N",  1, 0, "Sobre compra o sobre venta 1" ,        "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "nBnfSbr2",  "N",  1, 0, "Sobre compra o sobre venta 2" ,        "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "nBnfSbr3",  "N",  1, 0, "Sobre compra o sobre venta 3" ,        "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "nBnfSbr4",  "N",  1, 0, "Sobre compra o sobre venta 4" ,        "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "nBnfSbr5",  "N",  1, 0, "Sobre compra o sobre venta 5" ,        "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "nBnfSbr6",  "N",  1, 0, "Sobre compra o sobre venta 6" ,        "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "lSndInt",   "L",  1, 0, "Lógico para envio",                    "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "cCodUsr",   "C",  3, 0, "Código de usuario que realiza el cambio" ,"",                "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "dFecChg",   "D",  8, 0, "Fecha de cambio" ,                     "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "cTimChg",   "C",  5, 0, "Hora de cambio" ,                      "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "nTipRet",   "N",  1, 0, "Tipo de retención ( 1. Base / 2. Base+IVA )","",             "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "nPctRet",   "N",  6, 2, "Porcentaje de retención",              "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "nPlzEnt",   "N",  3, 0, "Plazo de entrega en días",             "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "lBlqPrv",   "L",  1, 0, "Proveedor bloqueado",                  "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "dFecBlq",   "D",  8, 0, "Fecha de bloqueo del proveedor",       "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "cMotBlq",   "C", 50, 0, "Motivo del bloqueo del proveedor",     "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "cCodGrp",   "C",  4, 0, "Código grupo de proveedor",            "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "nRegIva",   "N",  1, 0, "Regimen de " + cImp(),                 "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "lMail",     "L",  1, 0, "Lógico para enviar mail",              "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "mObserv",   "M", 10, 0, "Observaciones",                        "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "lMosCom",   "L",  1, 0, "Mostrar comentario" ,                  "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "lReq",      "L",  1, 0, "Lógico recargo equivalencia" ,         "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "cNbrEst",   "C",150, 0, "Nombre del establecimiento" ,          "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "cDirEst",   "C",150, 0, "dirección del establecimiento" ,       "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "Serie",     "C",  1, 0, "Serie del documento" ,                 "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "lRECC",     "L",  1, 0, "Acogido al régimen especial del criterio de caja",  "",      "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "TELEFONO2", "C", 50, 0, "Teléfono2 proveedor",                  "",                   "", "( cDbfPrv )" } )
   aAdd( aItmPrv, { "MOVIL2",    "C", 50, 0, "Movil2 proveedor",                     "",                   "", "( cDbfPrv )" } )
*/