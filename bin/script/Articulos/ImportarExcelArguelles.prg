#include "FiveWin.Ch"

#include "Hbxml.ch"
#include "Hbclass.ch"
#include "Fileio.ch"

#include "Factu.ch" 
      
//---------------------------------------------------------------------------//

Function ImportarExcelArguelles( nView )                	 
	      
   local oImportarExcel    := TImportarExcelArguelles():New( nView )

   oImportarExcel:Run()

Return nil

//---------------------------------------------------------------------------//  

CLASS TImportarExcelArguelles FROM TImportarExcel

   DATA hUnidadesMedicion     

   DATA idArticulo

   DATA idProveedor

   DATA referenciaProveedor

   DATA proveedorDefecto
   
   METHOD New()

   METHOD Run()

   METHOD getCampoClave()        INLINE ( alltrim( ::getExcelString( ::cColumnaCampoClave ) ) )

   METHOD procesaFicheroExcel()

   METHOD filaValida()
   
   METHOD siguienteLinea()       INLINE ( ++::nFilaInicioImportacion )

   METHOD existeRegistro()       INLINE ( D():gotoArticulos( ::getCampoClave(), ::nView ) )

   METHOD appendRegistro()       INLINE ( ( D():Articulos( ::nView ) )->( dbappend() ) )

   METHOD bloqueaRegistro()      INLINE ( ( D():Articulos( ::nView ) )->( dbrlock() ) )

   METHOD desbloqueaRegistro()   INLINE ( ( D():Articulos( ::nView ) )->( dbcommit() ),;
                                          ( D():Articulos( ::nView ) )->( dbunlock() ) )

   METHOD importarCampos()

   METHOD importarReferenciaProveedor()

   METHOD importarCodigoBarras()

   METHOD getCodigoUnidadMedicion( textoUnidadMedicion )

END CLASS

//----------------------------------------------------------------------------//

METHOD New( nView )

   ::nView                    := nView

   /*
   Cambiar el nombre del fichero-----------------------------------------------
   */

   ::cFicheroExcel            := "C:\importar\alta.xlsx"

   /*
   Cambiar la fila de cominezo de la importacion-------------------------------
   */

   ::nFilaInicioImportacion   := 2

   /*
   Columna de campo clave------------------------------------------------------
   */

   ::cColumnaCampoClave       := 'A'

   /*
   Tabla de unidades medidion solo para marpicon-------------------------------
   */

   ::hUnidadesMedicion        := {  "KILO"      => "01",;
                                    "ESTUCHE"   => "02",;
                                    "CAJA"      => "03",;
                                    "BOTE"      => "04",;
                                    "CUBO"      => "05",;
                                    "ROLLO"     => "06",;
                                    "BOBINA"    => "07",;
                                    "UDS"       => "08",;
                                    "UNIDAD"    => "08",;
                                    "LITRO"     => "09",;
                                    "METRO"     => "10",;
                                    "SOBRE"     => "11",;
                                    "LATA"      => "12" }

Return ( Self )

//----------------------------------------------------------------------------//

METHOD Run()

   if !file( ::cFicheroExcel )
      msgStop( "El fichero " + ::cFicheroExcel + " no existe." )
      Return ( .f. )
   end if 

   msgrun( "Procesando fichero " + ::cFicheroExcel, "Espere por favor...",  {|| ::procesaFicheroExcel() } )

   msginfo( "Proceso finalizado" )

Return ( .t. )

//----------------------------------------------------------------------------//

METHOD procesaFicheroExcel()

   ::openExcel()

   while ( ::filaValida() )

      if ::existeRegistro()
         ::bloqueaRegistro()
      else
         ::appendRegistro()
      end if 

      if !( neterr() )      

         ::importarCampos()

         ::desbloqueaRegistro()

         ::importarReferenciaProveedor()

         ::importarCodigoBarras()

      endif

      ::siguienteLinea()

   end if

   ::closeExcel()

Return nil

//---------------------------------------------------------------------------//

METHOD importarCampos()

   ::idArticulo                                 := ::getCampoClave()

   ( D():Articulos( ::nView ) )->Codigo         := ::idArticulo

   if !empty( ::getExcelString("B") )
      ( D():Articulos( ::nView ) )->Nombre      := ::getExcelString( "B" )
   end if 

   if !empty( ::getExcelString("C") )
      ( D():Articulos( ::nView ) )->Familia     := ::getExcelString( "C" )
   end if 

   if !empty( ::getExcelNumeric("E") )
      ( D():Articulos( ::nView ) )->pCosto      := ::getExcelNumeric( "E" )   
   end if 

   ( D():Articulos( ::nView ) )->TipoIva        := "G"

   if !empty( ::getExcelNumeric("F") )
      ( D():Articulos( ::nView ) )->pVenta1     := ::getExcelNumeric( "F" )   
      ( D():Articulos( ::nView ) )->pVtaIva1    := ( ::getExcelNumeric( "F" ) * 0.21 ) + ::getExcelNumeric( "F" )
   end if 

   if !empty( ::getExcelNumeric("G") )
      ( D():Articulos( ::nView ) )->pVenta2     := ::getExcelNumeric( "G" )   
      ( D():Articulos( ::nView ) )->pVtaIva2    := ( ::getExcelNumeric( "G" ) * 0.21 ) + ::getExcelNumeric( "G" )
   end if 

   if !empty( ::getExcelNumeric("H") )
      ( D():Articulos( ::nView ) )->pVenta3     := ::getExcelNumeric( "H" )   
      ( D():Articulos( ::nView ) )->pVtaIva3    := ( ::getExcelNumeric( "H" ) * 0.21 ) + ::getExcelNumeric( "H" )
   end if 

   if !empty( ::getExcelNumeric("I") )
      ( D():Articulos( ::nView ) )->pVenta4     := ::getExcelNumeric( "I" )   
      ( D():Articulos( ::nView ) )->pVtaIva4    := ( ::getExcelNumeric( "I" ) * 0.21 ) + ::getExcelNumeric( "I" )
   end if 

   if !empty( ::getExcelNumeric("J") )
      ( D():Articulos( ::nView ) )->pVenta5     := ::getExcelNumeric( "J" )   
      ( D():Articulos( ::nView ) )->pVtaIva5    := ( ::getExcelNumeric( "J" ) * 0.21 ) + ::getExcelNumeric( "J" )
   end if 

   if !empty( ::getExcelNumeric("K") )
      ( D():Articulos( ::nView ) )->pVenta6     := ::getExcelNumeric( "K" )   
      ( D():Articulos( ::nView ) )->pVtaIva6    := ( ::getExcelNumeric( "K" ) * 0.21 ) + ::getExcelNumeric( "K" )
   end if 

   if !empty( ::getExcelString("N") )
      ( D():Articulos( ::nView ) )->lPubInt     := ::getExcelLogic( "N" )
   end if 

   if !empty( ::getExcelNumeric("O") )
      ( D():Articulos( ::nView ) )->nPesoKg     := ::getExcelNumeric( "O" )   
   end if

   if !empty( ::getExcelString("P") )
      ( D():Articulos( ::nView ) )->cUnidad     := ::getExcelString( "P" )
   end if

   if ( D():Articulos( ::nView ) )->nCtlStock == 0 
      ( D():Articulos( ::nView ) )->nCtlStock   := 1
   end if 

   ::idProveedor                                := padr( ::getExcelString("L"), 12 )

   ::referenciaProveedor                        := padr( ::getExcelString("M"), 60 )

   ::proveedorDefecto                           := ::getExcelLogic( "Q" )

   if ( ::proveedorDefecto )
      ( D():Articulos( ::nView ) )->cPrvHab  := ::idProveedor
   end if 

Return nil

//---------------------------------------------------------------------------// 

METHOD importarReferenciaProveedor()

   local ordenAnterior        := ( D():ProveedorArticulo( ::nView ) )->( ordsetfocus( "cRefArt" ) )

   if !empty( ::referenciaProveedor )

      if ( D():ProveedorArticulo( ::nView ) )->( dbseek( ::idArticulo + ::idProveedor ) )
         ( ( D():ProveedorArticulo( ::nView ) )->( dbrlock() ) )
      else
         ( ( D():ProveedorArticulo( ::nView ) )->( dbappend() ) )
      end if 

      if !( neterr() )
         ( D():ProveedorArticulo( ::nView ) )->cCodArt   := ::idArticulo
         ( D():ProveedorArticulo( ::nView ) )->cCodPrv   := ::idProveedor
         ( D():ProveedorArticulo( ::nView ) )->cRefPrv   := ::referenciaProveedor
         ( D():ProveedorArticulo( ::nView ) )->lDefPrv   := ::proveedorDefecto
      end if

      ( D():ProveedorArticulo( ::nView ) )->( dbcommit() )
      ( D():ProveedorArticulo( ::nView ) )->( dbunlock() )

   end if 

   ( D():ProveedorArticulo( ::nView ) )->( ordsetfocus( ordenAnterior ) )

Return nil

//---------------------------------------------------------------------------//

METHOD importarCodigoBarras()

   local idArticulo           := ( D():Articulos( ::nView ) )->Codigo // cCodArt + cCodPrv + cRefPrv
   local codigoBarra          := ::getExcelString("D")

   local ordenAnterior        := ( D():ArticulosCodigosBarras( ::nView ) )->( ordsetfocus( "cArtBar" ) )

   if !empty( codigoBarra )

      if ( D():ArticulosCodigosBarras( ::nView ) )->( dbseek( idArticulo + codigoBarra ) )
         ( ( D():ArticulosCodigosBarras( ::nView ) )->( dbrlock() ) )
      else
         ( ( D():ArticulosCodigosBarras( ::nView ) )->( dbappend() ) )
      end if

      if !( neterr() )
         ( D():ArticulosCodigosBarras( ::nView ) )->cCodArt   := idArticulo
         ( D():ArticulosCodigosBarras( ::nView ) )->cCodBar   := codigoBarra
      end if

      ( D():ArticulosCodigosBarras( ::nView ) )->( dbcommit() )
      ( D():ArticulosCodigosBarras( ::nView ) )->( dbunlock() )

   end if

   ( D():ArticulosCodigosBarras( ::nView ) )->( ordsetfocus( ordenAnterior ) )

Return nil

//---------------------------------------------------------------------------//


METHOD getCodigoUnidadMedicion( textoUnidadMedicion )

   if empty( textoUnidadMedicion ) 
      Return ""
   end if 

   if valtype( textoUnidadMedicion ) == "N"
      Return ""
   end if 

   nScan    := hScan( ::hUnidadesMedicion, {|k,v| ( k $ upper( textoUnidadMedicion ) ) } )
   if nScan != 0
      Return ( hgetvalueat( ::hUnidadesMedicion, nScan ) )
   end if 

Return ( "" )

//---------------------------------------------------------------------------//

METHOD filaValida()

Return ( !empty( ::getExcelValue( ::cColumnaCampoClave ) ) )

//---------------------------------------------------------------------------//

#include "ImportarExcel.prg"

/*
Campos a importar--------------------------------------------------------------

   aAdd( aBase, { "Codigo",    "C", 18, 0, "C�digo del art�culo" ,                    "'@!'",               "", "( cDbfArt )", nil } )
   aAdd( aBase, { "Nombre",    "C",100, 0, "Nombre del art�culo",                     "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cDesTik",   "C", 20, 0, "Descripci�n para el tiket" ,              "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "pCosto",    "N", 15, 6, "Precio de costo" ,                        "PicIn()",            "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PvpRec",    "N", 15, 6, "Precio venta recomendado" ,               "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lBnf1",     "L",  1, 0, "L�gico aplicar porcentaje de beneficio 1","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LBNF2",     "L",  1, 0, "L�gico aplicar porcentaje de beneficio 2","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LBNF3",     "L",  1, 0, "L�gico aplicar porcentaje de beneficio 3","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LBNF4",     "L",  1, 0, "L�gico aplicar porcentaje de beneficio 4","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LBNF5",     "L",  1, 0, "L�gico aplicar porcentaje de beneficio 5","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LBNF6",     "L",  1, 0, "L�gico aplicar porcentaje de beneficio 6","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "BENEF1",    "N",  6, 2, "Porcentaje de beneficio precio 1" ,       "'@EZ 99.99'",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "BENEF2",    "N",  6, 2, "Porcentaje de beneficio precio 2" ,       "'@EZ 99.99'",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "BENEF3",    "N",  6, 2, "Porcentaje de beneficio precio 3" ,       "'@EZ 99.99'",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "BENEF4",    "N",  6, 2, "Porcentaje de beneficio precio 4" ,       "'@EZ 99.99'",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "BENEF5",    "N",  6, 2, "Porcentaje de beneficio precio 5" ,       "'@EZ 99.99'",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "BENEF6",    "N",  6, 2, "Porcentaje de beneficio precio 6" ,       "'@EZ 99.99'",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NBNFSBR1",  "N",  1, 0, "Beneficio sobre el costo o sobre venta 1","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NBNFSBR2",  "N",  1, 0, "Beneficio sobre el costo o sobre venta 2","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NBNFSBR3",  "N",  1, 0, "Beneficio sobre el costo o sobre venta 3","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NBNFSBR4",  "N",  1, 0, "Beneficio sobre el costo o sobre venta 4","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NBNFSBR5",  "N",  1, 0, "Beneficio sobre el costo o sobre venta 5","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NBNFSBR6",  "N",  1, 0, "Beneficio sobre el costo o sobre venta 6","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PVENTA1",   "N", 15, 6, "Precio de venta precio 1" ,               "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PVENTA2",   "N", 15, 6, "Precio de venta precio 2" ,               "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PVENTA3",   "N", 15, 6, "Precio de venta precio 3" ,               "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PVENTA4",   "N", 15, 6, "Precio de venta precio 4" ,               "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PVENTA5",   "N", 15, 6, "Precio de venta precio 5" ,               "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PVENTA6",   "N", 15, 6, "Precio de venta precio 6" ,               "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PVTAIVA1",  "N", 15, 6, "Precio de venta precio 1 " + cImp() + " incluido" ,  "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PVTAIVA2",  "N", 15, 6, "Precio de venta precio 2 " + cImp() + " incluido" ,  "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PVTAIVA3",  "N", 15, 6, "Precio de venta precio 3 " + cImp() + " incluido" ,  "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PVTAIVA4",  "N", 15, 6, "Precio de venta precio 4 " + cImp() + " incluido" ,  "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PVTAIVA5",  "N", 15, 6, "Precio de venta precio 5 " + cImp() + " incluido" ,  "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PVTAIVA6",  "N", 15, 6, "Precio de venta precio 6 " + cImp() + " incluido" ,  "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PALQ1",     "N", 15, 6, "Precio de alquiler precio 1" ,               "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PALQ2",     "N", 15, 6, "Precio de alquiler precio 2" ,               "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PALQ3",     "N", 15, 6, "Precio de alquiler precio 3" ,               "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PALQ4",     "N", 15, 6, "Precio de alquiler precio 4" ,               "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PALQ5",     "N", 15, 6, "Precio de alquiler precio 5" ,               "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PALQ6",     "N", 15, 6, "Precio de alquiler precio 6" ,               "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PALQIVA1",  "N", 15, 6, "Precio de alquiler precio 1 " + cImp() + " incluido" ,    "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PALQIVA2",  "N", 15, 6, "Precio de alquiler precio 2 " + cImp() + " incluido" ,    "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PALQIVA3",  "N", 15, 6, "Precio de alquiler precio 3 " + cImp() + " incluido" ,    "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PALQIVA4",  "N", 15, 6, "Precio de alquiler precio 4 " + cImp() + " incluido" ,    "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PALQIVA5",  "N", 15, 6, "Precio de alquiler precio 5 " + cImp() + " incluido" ,    "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PALQIVA6",  "N", 15, 6, "Precio de alquiler precio 6 " + cImp() + " incluido" ,    "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NPNTVER1",  "N", 15, 6, "Contribuci�n punto verde" ,                               "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NPNVIVA1",  "N", 15, 6, "Contribuci�n punto verde " + cImp() + " inc.",            "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NACTUAL",   "N", 15, 6, "N�mero de art�culos" ,                    "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NCAJENT",   "N", 15, 6, "N�mero de cajas por defecto" ,            "MasUnd()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NUNICAJA",  "N", 15, 6, "N�mero de unidades por defecto" ,         "MasUnd()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NMINIMO",   "N", 15, 6, "N�mero de stock m�nimo" ,                 "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NMAXIMO",   "N", 15, 6, "N�mero de stock maximo" ,                 "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NCNTACT",   "N", 15, 6, "N�mero del contador" ,                    "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LASTIN",    "D",  8, 0, "Fecha ultima entrada" ,                   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LASTCHG",   "D",  8, 0, "Fecha de creaci�n" ,                      "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LASTOUT",   "D",  8, 0, "Fecha ultima salida" ,                    "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "TIPOIVA",   "C",  1, 0, "C�digo tipo de " + cImp(),                "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LIVAINC",   "L",  1, 0, "L�gico " + cImp() + " incluido (S/N)" ,   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "FAMILIA",   "C", 16, 0, "C�digo de la familia del art�culo" ,      "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CSUBFAM",   "C",  8, 0, "C�digo de la subfamilia del art�culo" ,   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "GRPVENT",   "C",  9, 0, "C�digo del grupo de ventas" ,             "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCTAVTA",   "C", 12, 0, "C�digo de la cuenta de ventas" ,          "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCTACOM",   "C", 12, 0, "C�digo de la cuenta de compras" ,         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCTATRN",   "C", 12, 0, "C�digo de la cuenta de portes" ,          "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CODEBAR",   "C", 20, 0, "C�digo de barras" ,                       "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NTIPBAR",   "N",  2, 0, "Tipo de c�digo de barras" ,               "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "DESCRIP",   "M", 10, 0, "Descripci�n larga" ,                      "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LLABEL",    "L",  1, 0, "L�gico de selecci�n de etiqueta",         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NLABEL",    "N",  5, 0, "N�mero de etiquetas a imprimir",          "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NCTLSTOCK", "N",  1, 0, "Control de stock (1/2/3)",                "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LSELPRE",   "L",  1, 0, "",                                        "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NSELPRE",   "N",  5, 0, "",                                        "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NTIPPRE",   "N",  1, 0, "",                                        "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NPESOKG",   "N", 16, 6, "Peso del art�culo" ,                      "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "CUNIDAD",   "C",  2, 0, "Unidad de medici�n del peso" ,            "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NVOLUMEN",  "N", 16, 6, "Volumen del art�culo" ,                   "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "CVOLUMEN",  "C",  2, 0, "Unidad de medici�n del volumen" ,         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NLNGART",   "N", 16, 6, "Largo del art�culo" ,                     "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "NALTART",   "N", 16, 6, "Alto del art�culo" ,                      "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "NANCART",   "N", 16, 6, "Ancho del art�culo" ,                     "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "CUNDDIM",   "C",  2, 0, "Unidad de medici�n de las longitudes" ,   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPPES",   "N", 15, 6, "Importe de peso/volumen del articulo" ,   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CIMAGEN",   "C",250, 0, "Fichero de imagen" ,                      "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lSndDoc",   "L",  1, 0, "L�gico para envios" ,                     "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodUsr",   "C",  3, 0, "C�digo de usuario que realiza el cambio" ,"",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "dFecChg",   "D",  8, 0, "Fecha de cambio" ,                        "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cTimChg",   "C",  5, 0, "Hora de cambio" ,                         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lKitArt",   "L",  1, 0, "L�gico de escandallos" ,                  "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lKitAsc",   "L",  1, 0, "L�gico de asociado" ,                     "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nKitImp",   "N",  1, 0, "" ,                                       "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nKitStk",   "N",  1, 0, "" ,                                       "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nKitPrc",   "N",  1, 0, "" ,                                       "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lAutSer",   "L",  1, 0, "L�gico de autoserializar" ,               "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LOBS",      "L",  1, 0, "L�gico de obsoleto" ,                     "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LNUMSER",   "L",  1, 0, "L�gico solicitar numero de serie" ,       "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CPRVHAB",   "C", 12, 0, "Proveedor habitual" ,                     "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LFACCNV",   "L",  1, 0, "Usar factor de conversi�n" ,              "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CFACCNV",   "C",  2, 0, "C�digo del factor de conversi�n" ,        "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCODTNK",   "C",  3, 0, "C�digo del tanque de combustible" ,       "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCODTIP",   "C",  4, 0, "C�digo del tipo de art�culo" ,            "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LTIPACC",   "L",  1, 0, "L�gico de acceso por unidades o importe", "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LCOMBUS",   "L",  1, 0, "L�gico si el art�culo es del tipo combustible", "",             "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCODIMP",   "C",  3, 0, "C�digo del impuesto especiales",          "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LMSGVTA",   "L",  1, 0, "L�gico para avisar en venta sin stock",   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LNOTVTA",   "L",  1, 0, "L�gico para no permitir venta sin stock", "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NLOTE",     "N",  9, 0, "",                                        "'999999999'",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cLote",     "C", 14, 0, "N�mero de lote",                          "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LLOTE",     "L",  1, 0, "Lote (S/N)",                              "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LPUBINT",   "L",  1, 0, "L�gico para publicar en internet (S/N)",  "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LPUBOFE",   "L",  1, 0, "L�gico para publicar como oferta (S/N)",  "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LPUBPOR",   "L",  1, 0, "L�gico para publicar como art�culo destacado (S/N)",  "",       "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NDTOINT1",  "N", 10, 6, "Descuento de oferta para tienda web 1",   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPINT1",  "N", 15, 6, "Precio del producto en oferta 1",         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPIVA1",  "N", 15, 6, "Precio del producto en oferta con " + cImp() + " 1", "",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NDTOINT2",  "N", 10, 6, "Descuento de oferta para tienda web 2",   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPINT2",  "N", 15, 6, "Precio del producto en oferta 2",         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPIVA2",  "N", 15, 6, "Precio del producto en oferta con " + cImp() + " 2", "",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NDTOINT3",  "N", 10, 6, "Descuento de oferta para tienda web 3",   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPINT3",  "N", 15, 6, "Precio del producto en oferta 3",         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPIVA3",  "N", 15, 6, "Precio del producto en oferta con " + cImp() + " 3", "",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NDTOINT4",  "N", 10, 6, "Descuento de oferta para tienda web 4",   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPINT4",  "N", 15, 6, "Precio del producto en oferta 4",         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPIVA4",  "N", 15, 6, "Precio del producto en oferta con " + cImp() + " 4", "",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NDTOINT5",  "N", 10, 6, "Descuento de oferta para tienda web 5",   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPINT5",  "N", 15, 6, "Precio del producto en oferta 5",         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPIVA5",  "N", 15, 6, "Precio del producto en oferta con " + cImp() + " 5", "",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NDTOINT6",  "N", 10, 6, "Descuento de oferta para tienda web 6",   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPINT6",  "N", 15, 6, "Precio del producto en oferta 6",         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPIVA6",  "N", 15, 6, "Precio del producto en oferta con " + cImp() + " 6", "",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "MDESTEC",   "M", 10, 0, "Descripci�n t�cnica del art�culo",        "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NLNGCAJ",   "N", 16, 6, "Largo de la caja" ,                       "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "NALTCAJ",   "N", 16, 6, "Alto de la caja" ,                        "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "NANCCAJ",   "N", 16, 6, "Ancho de la caja" ,                       "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "CUNDCAJ",   "C",  2, 0, "Unidad de medici�n de la caja" ,          "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NPESCAJ",   "N", 16, 6, "Peso de la caja" ,                        "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCAJPES",   "C",  2, 0, "Unidad de medici�n del peso de la caja" , "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NVOLCAJ",   "N", 16, 6, "Volumen de la caja" ,                     "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCAJVOL",   "C",  2, 0, "Unidad de medici�n del volumen de la caja","",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NCAJPLT",   "N", 16, 6, "N�mero de cajas por palets" ,             "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "NBASPLT",   "N", 16, 6, "Base del palet" ,                         "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "NALTPLT",   "N", 16, 6, "Altura del palet" ,                       "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "CUNDPLT",   "C",  2, 0, "Unidad de medici�n de la altura del palet","",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LINCTCL",   "L",  1, 0, "Incluir en pantalla t�ctil",               "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CDESTCL",   "C", 20, 0, "Descripci�n en pantalla t�ctil",           "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CDESCMD",   "M", 10, 0, "Descripci�n para comanda",                 "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NPOSTCL",   "N", 16, 6, "Posici�n en pantalla t�ctil",              "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCODCAT",   "C",  4, 0, "C�digo del cat�logo del art�culo" ,        "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NPUNTOS",   "N", 16, 6, "Puntos del catalogo" ,                     "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NDTOPNT",   "N",  6, 2, "Dto. del catalogo" ,                       "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NRENMIN",   "N",  6, 2, "Rentabilidad m�nima" ,                     "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCODCATE",  "C", 10, 0, "C�digo de categor�a",                      "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCODTEMP",  "C", 10, 0, "C�digo de la temporada",                   "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LECOTASA",  "L",  1, 0, "L�gico para usar ECOTASA",                 "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LMOSCOM",   "L",  1, 0, "L�gico mostrar comentario" ,               "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "MCOMENT",   "M", 10, 0, "Comentario a mostrar" ,                    "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LPUNTO",    "L",  1, 0, "L�gico para trabajar con puntos" ,         "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCODPRP1",  "C", 20, 0, "C�digo de la primera propiedad" ,          "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCODPRP2",  "C", 20, 0, "C�digo de la segunda propiedad" ,          "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lCodPrp",   "L",  1, 0, "" ,                                        "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodFra",   "C",  3, 0, "C�digo de frases publiciarias",            "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodWeb",   "N", 11, 0, "C�digo del producto en la web",            "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nPosTpv",   "N", 10, 2, "Posici�n para mostrar en TPV t�ctil",      "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDuracion", "N",  3, 0, "Duraci�n del producto",                    "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nTipDur",   "N",  1, 0, "Tipo duraci�n (dia, mes, a�o)",            "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodFab",   "C",  3, 0, "C�digo del fabricante",                    "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nImpCom1",  "N",  1, 0, "Impresora de comanda 1",                   "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nImpCom2",  "N",  1, 0, "Impresora de comanda 2",                   "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lMsgMov",   "L",  1, 0, "L�gico para avisar en movimientos sin stock","",                "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cImagenWeb","C",250, 0, "Imagen para la web",                       "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cChgBar",   "D",  8, 0, "Fecha de cambio de c�digo de barras",      "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cDesUbi",   "C",200, 0, "Ubicaci�n",                                "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "dFecVta",   "D",  8, 0, "Fecha de puesta a la venta",               "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "dFinVta",   "D",  8, 0, "Fecha de fin de la venta",                 "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lMsgSer",   "L",  1, 0, "Avisar en ventas por series sin stock",    "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cValPrp1",  "C", 20, 0, "Valor de la primera propiedad",            "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cValPrp2",  "C", 20, 0, "Valor de la segunda propiedad",            "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "mValPrp1",  "M", 10, 0, "Valores seleccionables de la primera propiedad", "",            "", "( cDbfArt )", nil } )
   aAdd( aBase, { "mValPrp2",  "M", 10, 0, "Valores seleccionables de la segunda propiedad", "",            "", "( cDbfArt )", nil } )
   aAdd( aBase, { "dChgBar",   "D",  8, 0, "Fecha de cambio de codigos de barras",     "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodSus",   "C", 18, 0, "C�digo del art�culo al que se sustituye" , "'@!'",              "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodPor",   "C", 18, 0, "C�digo del art�culo por el que es sustituido" , "'@!'",         "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDtoArt1",  "N",  6, 2, "Primer descuento de art�culo",             "@EZ 99.99",         "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDtoArt2",  "N",  6, 2, "Segundo descuento de art�culo",            "@EZ 99.99",         "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDtoArt3",  "N",  6, 2, "Tercer descuento de art�culo",             "@EZ 99.99",         "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDtoArt4",  "N",  6, 2, "Cuarto descuento de art�culo",             "@EZ 99.99",         "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDtoArt5",  "N",  6, 2, "Quinto descuento de art�culo",             "@EZ 99.99",         "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDtoArt6",  "N",  6, 2, "Sexto descuento de art�culo",              "@EZ 99.99",         "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lMarAju",   "L",  1, 0, "L�gico para utilizar el margen de ajuste", "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cMarAju",   "C",  5, 0, "Cadena descriptiva del margen de ajuste",  "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nTarWeb",   "N",  1, 0, "Tarifa a aplicar en la Web" ,              "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "pVtaWeb",   "N", 16, 6, "Precio venta en la Web",                   "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cTipImp1",  "C", 50, 0, "Tipo impresora comanda 1",                 "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cTipImp2",  "C", 50, 0, "Tipo impresora comanda 2",                 "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cRefPrv",   "C", 18, 0, "Referencia del proveedor al art�culo" ,    "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodSec",   "C",  3, 0, "C�digo de la secci�n para producci�n" ,    "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nFacCnv",   "N", 16, 6, "Factor de conversi�n" ,                    "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lSbrInt",   "L",  1, 0, "L�gico precio libre internet" ,            "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nColBtn",   "N", 10, 0, "Color para t�ctil" ,                       "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cOrdOrd",   "C",  2, 0, "Orden de comanda" ,                        "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lTerminado","L",  1, 0, "L�gico de producto terminado (producci�n)" , "",                "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lPeso",     "L",  1, 0, "L�gico de producto por peso",              "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cMenu",     "C",  3, 0, "C�digo del men� de acompa�amiento",        "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cTitSeo",   "C", 70, 0, "Meta-t�tulo",                              "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cDesSeo",   "C",160, 0, "Meta-descripcion",                         "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cKeySeo",   "C",160, 0, "Meta-keywords",                            "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodEst",   "C",  3, 0, "Estado del art�culo",                      "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodEdi",   "C", 20, 0, "C�digo normalizado del art�culo",          "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cRefAux",   "C", 18, 0, "Referencia auxiliar",                      "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cRefAux2",  "C", 18, 0, "Referencia auxiliar 2",                    "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "Matriz",    "C", 18, 0, "Matriz para c�digo de barras" ,            "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nStkCal",   "N", 16, 6, "Stock calculado" ,                         "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lIvaInc2",  "L",  1, 0, "Iva incluido para el precio 2" ,           "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lIvaInc3",  "L",  1, 0, "Iva incluido para el precio 3" ,           "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lIvaInc4",  "L",  1, 0, "Iva incluido para el precio 4" ,           "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lIvaInc5",  "L",  1, 0, "Iva incluido para el precio 5" ,           "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lIvaInc6",  "L",  1, 0, "Iva incluido para el precio 6" ,           "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lIvaPver",  "L",  1, 0, "Iva incluido para el punto verde" ,        "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cWebShop",  "C",100, 0, "Tienda web donde se publica el producto",  "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lIvaWeb",   "L",  1, 0, "Iva incluido para precio web" ,            "",                  "", "( cDbfArt )", nil } )

   aAdd( aBase, { "cCodArt",   "C", 18, 0, "C�digo del art�culo referenciado"  , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodPrv",   "C", 12, 0, "C�digo del proveedor"              , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cRefPrv",   "C", 60, 0, "Referencia del proveedor al art�culo" , "",               "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDtoPrv",   "N",  6, 2, "Descuento del proveedor"           , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDtoPrm",   "N",  6, 2, "Descuento por promoci�n"           , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cDivPrv",   "C",  3, 0, "C�digo de la divisa"               , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nImpPrv",   "N", 19, 6, "Importe de compra"                 , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lDefPrv",   "L",  1, 0, "L�gico de proveedor por defecto"   , "",                  "", "( cDbfArt )", nil } )
*/
