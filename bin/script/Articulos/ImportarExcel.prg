#include "FiveWin.Ch"

#include "Hbxml.ch"
#include "Hbclass.ch"
#include "Fileio.ch"

#include "Factu.ch" 
      
//---------------------------------------------------------------------------//

Function ImportarExcel( nView )                	 
	      
   TImportarExcel():New( nView ):Run()

Return nil

//---------------------------------------------------------------------------//

CLASS TImportarExcel

   DATA nView

   DATA oExcel

   DATA cFicheroExcel

   DATA nFilaInicioImportacion

   DATA cColumnaCampoClave
   
   METHOD New()

   METHOD Run()
   
   METHOD procesaFicheroExcel()

   METHOD filaValida()
   
   METHOD siguienteLinea()       INLINE ( ++::nFilaInicioImportacion )

   METHOD getExcelValue()

   METHOD getExcelString()

   METHOD getExcelNumeric( columna, fila )
   
   METHOD getExcelLogic( columna, fila )

   METHOD openExcel()

   METHOD closeExcel()  

   METHOD existeRegistro()       INLINE ( D():gotoArticulos( ::getExcelValue( ::cColumnaCampoClave ), ::nView ) )

   METHOD appendRegistro()       INLINE ( ( D():Articulos( ::nView ) )->( dbappend() ) )

   METHOD bloqueaRegistro()      INLINE ( ( D():Articulos( ::nView ) )->( dbrlock() ) )

   METHOD desbloqueaRegistro()   INLINE ( ( D():Articulos( ::nView ) )->( dbcommit() ),;
                                          ( D():Articulos( ::nView ) )->( dbunlock() ) )

   METHOD importarCampos()

END CLASS

//----------------------------------------------------------------------------//

METHOD New( nView )

   ::nView                    := nView

   /*
   Cambiar el nombre del fichero
   */

   ::cFicheroExcel            := "C:\Users\calero\Desktop\Importar.xlsx"

   /*
   Cambiar la fila de cominezo de la importacion
   */

   ::nFilaInicioImportacion   := 7

   /*
   Columna de campo clave
   */

   ::cColumnaCampoClave       := 'A'

Return ( Self )

//----------------------------------------------------------------------------//

METHOD Run()

   if !file( ::cFicheroExcel )
      msgStop( "El fichero " + ::cFicheroExcel + " no existe." )
      Return ( .f. )
   end if 

   msgrun(  "Procesando fichero " + ::cFicheroExcel,;
            "Espere por favor...",;
            {|| ::procesaFicheroExcel() } )

   msginfo( "Proceso finalizado" )

Return ( .t. )

//----------------------------------------------------------------------------//

METHOD openExcel()

   ::oExcel                        := TOleExcel():New( "Importando hoja de excel", "Conectando...", .f. )

   ::oExcel:oExcel:Visible         := .t.
   ::oExcel:oExcel:DisplayAlerts   := .f.
   ::oExcel:oExcel:WorkBooks:Open( ::cFicheroExcel )
   ::oExcel:oExcel:WorkSheets( 1 ):Activate()

Return ( Self )

//----------------------------------------------------------------------------//

METHOD closeExcel()

   ::oExcel:oExcel:Quit()
   ::oExcel:oExcel:DisplayAlerts := .t.
   ::oExcel:End()

Return ( Self )

//----------------------------------------------------------------------------//

METHOD procesaFicheroExcel()

   ::oExcel                        := TOleExcel():New( "Importando hoja de excel", "Conectando...", .f. )

   ::oExcel:oExcel:Visible         := .t.
   ::oExcel:oExcel:DisplayAlerts   := .f.
   ::oExcel:oExcel:WorkBooks:Open( ::cFicheroExcel )
   ::oExcel:oExcel:WorkSheets( 1 ):Activate()

   while ( ::filaValida() )

      if ::existeRegistro()
         ::bloqueaRegistro()
      else
         ::appendRegistro()
      end if 

      if !( neterr() )      

         ::importarCampos()

         ::desbloqueaRegistro()

      endif

      ::siguienteLinea()

   end if

   ::oExcel:oExcel:Quit()
   ::oExcel:oExcel:DisplayAlerts := .t.
   ::oExcel:End()

Return nil

//---------------------------------------------------------------------------//
/*
Campos que voy a importar------------------------------------------------------
*/

METHOD importarCampos()

   ( D():Articulos( ::nView ) )->Codigo   := ::getExcelValue( "A" )
   ( D():Articulos( ::nView ) )->Nombre   := ::getExcelValue( "B" )

Return nil

//---------------------------------------------------------------------------//

METHOD filaValida()

Return ( !empty( ::getExcelValue( ::cColumnaCampoClave ) ) )

//---------------------------------------------------------------------------//

METHOD getExcelValue( columna, fila, valorPorDefecto )

   local oBlock
   local oError
   local excelValue  

   DEFAULT fila         := ::nFilaInicioImportacion

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   excelValue           := ::oExcel:oExcel:ActiveSheet:Range( columna + ltrim( str( fila ) ) ):Value

   RECOVER USING oError

   END SEQUENCE

   ErrorBlock( oBlock )

   if empty( excelValue )
      Return ( valorPorDefecto )
   end if 

Return ( excelValue )   

//---------------------------------------------------------------------------// 

METHOD getExcelString( columna, fila )

   local excelValue  
   local valorPorDefecto      := ""

   DEFAULT fila               := ::nFilaInicioImportacion
 
   excelValue                 := ::getExcelValue( columna, fila, valorPorDefecto )

   if valtype( excelValue ) == "N" 
      excelValue              := int( excelValue )
   end if 

   if valtype( excelValue ) != "C" 
      excelValue              := cvaltochar( excelValue )
   end if 

   if empty( excelValue ) 
      Return ( valorPorDefecto )
   end if 

Return ( excelValue )   

//---------------------------------------------------------------------------//

METHOD getExcelNumeric( columna, fila )

   local excelValue  
   local valorPorDefecto      := 0

   DEFAULT fila               := ::nFilaInicioImportacion

   excelValue                 := ::getExcelValue( columna, fila, valorPorDefecto )

   if valtype( excelValue ) != "N"
      excelValue              := strtran( excelValue, ",", "." )
      excelValue              := val( AllTrim( excelValue ) )
   end if 

   /*if empty( excelValue )
      Return ( valorPorDefecto ) 
   end if */

Return ( excelValue )   

//---------------------------------------------------------------------------// 

METHOD getExcelLogic( columna, fila )

   local excelValue  
   local valorPorDefecto      := .f. 

   DEFAULT fila               := ::nFilaInicioImportacion

   excelValue                 := ::getExcelValue( columna, fila, valorPorDefecto )

   if valtype( excelValue ) == "C" 
      excelValue              := ( upper( excelValue ) == "SI" )
   end if 

   if valtype( excelValue ) == "N" 
      excelValue              := ( excelValue == 1 )
   end if 

   if empty( excelValue )
      Return ( valorPorDefecto )
   end if 

Return ( excelValue )    

//---------------------------------------------------------------------------// 

/*
Campos a importar--------------------------------------------------------------

   aAdd( aBase, { "Codigo",    "C", 18, 0, "Código del artículo" ,                    "'@!'",               "", "( cDbfArt )", nil } )
   aAdd( aBase, { "Nombre",    "C",100, 0, "Nombre del artículo",                     "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cDesTik",   "C", 20, 0, "Descripción para el tiket" ,              "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "pCosto",    "N", 15, 6, "Precio de costo" ,                        "PicIn()",            "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PvpRec",    "N", 15, 6, "Precio venta recomendado" ,               "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lBnf1",     "L",  1, 0, "Lógico aplicar porcentaje de beneficio 1","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LBNF2",     "L",  1, 0, "Lógico aplicar porcentaje de beneficio 2","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LBNF3",     "L",  1, 0, "Lógico aplicar porcentaje de beneficio 3","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LBNF4",     "L",  1, 0, "Lógico aplicar porcentaje de beneficio 4","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LBNF5",     "L",  1, 0, "Lógico aplicar porcentaje de beneficio 5","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LBNF6",     "L",  1, 0, "Lógico aplicar porcentaje de beneficio 6","",                   "", "( cDbfArt )", nil } )
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
   aAdd( aBase, { "NPNTVER1",  "N", 15, 6, "Contribución punto verde" ,                               "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NPNVIVA1",  "N", 15, 6, "Contribución punto verde " + cImp() + " inc.",            "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NACTUAL",   "N", 15, 6, "Número de artículos" ,                    "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NCAJENT",   "N", 15, 6, "Número de cajas por defecto" ,            "MasUnd()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NUNICAJA",  "N", 15, 6, "Número de unidades por defecto" ,         "MasUnd()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NMINIMO",   "N", 15, 6, "Número de stock mínimo" ,                 "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NMAXIMO",   "N", 15, 6, "Número de stock maximo" ,                 "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NCNTACT",   "N", 15, 6, "Número del contador" ,                    "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LASTIN",    "D",  8, 0, "Fecha ultima entrada" ,                   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LASTCHG",   "D",  8, 0, "Fecha de creación" ,                      "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LASTOUT",   "D",  8, 0, "Fecha ultima salida" ,                    "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "TIPOIVA",   "C",  1, 0, "Código tipo de " + cImp(),                "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LIVAINC",   "L",  1, 0, "Lógico " + cImp() + " incluido (S/N)" ,   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "FAMILIA",   "C", 16, 0, "Código de la familia del artículo" ,      "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CSUBFAM",   "C",  8, 0, "Código de la subfamilia del artículo" ,   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "GRPVENT",   "C",  9, 0, "Código del grupo de ventas" ,             "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCTAVTA",   "C", 12, 0, "Código de la cuenta de ventas" ,          "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCTACOM",   "C", 12, 0, "Código de la cuenta de compras" ,         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCTATRN",   "C", 12, 0, "Código de la cuenta de portes" ,          "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CODEBAR",   "C", 20, 0, "Código de barras" ,                       "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NTIPBAR",   "N",  2, 0, "Tipo de código de barras" ,               "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "DESCRIP",   "M", 10, 0, "Descripción larga" ,                      "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LLABEL",    "L",  1, 0, "Lógico de selección de etiqueta",         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NLABEL",    "N",  5, 0, "Número de etiquetas a imprimir",          "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NCTLSTOCK", "N",  1, 0, "Control de stock (1/2/3)",                "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LSELPRE",   "L",  1, 0, "",                                        "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NSELPRE",   "N",  5, 0, "",                                        "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NTIPPRE",   "N",  1, 0, "",                                        "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NPESOKG",   "N", 16, 6, "Peso del artículo" ,                      "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "CUNIDAD",   "C",  2, 0, "Unidad de medición del peso" ,            "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NVOLUMEN",  "N", 16, 6, "Volumen del artículo" ,                   "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "CVOLUMEN",  "C",  2, 0, "Unidad de medición del volumen" ,         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NLNGART",   "N", 16, 6, "Largo del artículo" ,                     "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "NALTART",   "N", 16, 6, "Alto del artículo" ,                      "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "NANCART",   "N", 16, 6, "Ancho del artículo" ,                     "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "CUNDDIM",   "C",  2, 0, "Unidad de medición de las longitudes" ,   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPPES",   "N", 15, 6, "Importe de peso/volumen del articulo" ,   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CIMAGEN",   "C",250, 0, "Fichero de imagen" ,                      "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lSndDoc",   "L",  1, 0, "Lógico para envios" ,                     "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodUsr",   "C",  3, 0, "Código de usuario que realiza el cambio" ,"",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "dFecChg",   "D",  8, 0, "Fecha de cambio" ,                        "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cTimChg",   "C",  5, 0, "Hora de cambio" ,                         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lKitArt",   "L",  1, 0, "Lógico de escandallos" ,                  "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lKitAsc",   "L",  1, 0, "Lógico de asociado" ,                     "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nKitImp",   "N",  1, 0, "" ,                                       "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nKitStk",   "N",  1, 0, "" ,                                       "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nKitPrc",   "N",  1, 0, "" ,                                       "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lAutSer",   "L",  1, 0, "Lógico de autoserializar" ,               "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LOBS",      "L",  1, 0, "Lógico de obsoleto" ,                     "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LNUMSER",   "L",  1, 0, "Lógico solicitar numero de serie" ,       "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CPRVHAB",   "C", 12, 0, "Proveedor habitual" ,                     "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LFACCNV",   "L",  1, 0, "Usar factor de conversión" ,              "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CFACCNV",   "C",  2, 0, "Código del factor de conversión" ,        "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCODTNK",   "C",  3, 0, "Código del tanque de combustible" ,       "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCODTIP",   "C",  4, 0, "Código del tipo de artículo" ,            "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LTIPACC",   "L",  1, 0, "Lógico de acceso por unidades o importe", "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LCOMBUS",   "L",  1, 0, "Lógico si el artículo es del tipo combustible", "",             "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCODIMP",   "C",  3, 0, "Código del impuesto especiales",          "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LMSGVTA",   "L",  1, 0, "Lógico para avisar en venta sin stock",   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LNOTVTA",   "L",  1, 0, "Lógico para no permitir venta sin stock", "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NLOTE",     "N",  9, 0, "",                                        "'999999999'",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cLote",     "C", 14, 0, "Número de lote",                          "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LLOTE",     "L",  1, 0, "Lote (S/N)",                              "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LPUBINT",   "L",  1, 0, "Lógico para publicar en internet (S/N)",  "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LPUBOFE",   "L",  1, 0, "Lógico para publicar como oferta (S/N)",  "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LPUBPOR",   "L",  1, 0, "Lógico para publicar como artículo destacado (S/N)",  "",       "", "( cDbfArt )", nil } )
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
   aAdd( aBase, { "MDESTEC",   "M", 10, 0, "Descripción técnica del artículo",        "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NLNGCAJ",   "N", 16, 6, "Largo de la caja" ,                       "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "NALTCAJ",   "N", 16, 6, "Alto de la caja" ,                        "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "NANCCAJ",   "N", 16, 6, "Ancho de la caja" ,                       "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "CUNDCAJ",   "C",  2, 0, "Unidad de medición de la caja" ,          "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NPESCAJ",   "N", 16, 6, "Peso de la caja" ,                        "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCAJPES",   "C",  2, 0, "Unidad de medición del peso de la caja" , "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NVOLCAJ",   "N", 16, 6, "Volumen de la caja" ,                     "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCAJVOL",   "C",  2, 0, "Unidad de medición del volumen de la caja","",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NCAJPLT",   "N", 16, 6, "Número de cajas por palets" ,             "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "NBASPLT",   "N", 16, 6, "Base del palet" ,                         "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "NALTPLT",   "N", 16, 6, "Altura del palet" ,                       "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "CUNDPLT",   "C",  2, 0, "Unidad de medición de la altura del palet","",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LINCTCL",   "L",  1, 0, "Incluir en pantalla táctil",               "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CDESTCL",   "C", 20, 0, "Descripción en pantalla táctil",           "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CDESCMD",   "M", 10, 0, "Descripción para comanda",                 "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NPOSTCL",   "N", 16, 6, "Posición en pantalla táctil",              "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCODCAT",   "C",  4, 0, "Código del catálogo del artículo" ,        "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NPUNTOS",   "N", 16, 6, "Puntos del catalogo" ,                     "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NDTOPNT",   "N",  6, 2, "Dto. del catalogo" ,                       "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NRENMIN",   "N",  6, 2, "Rentabilidad mínima" ,                     "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCODCATE",  "C", 10, 0, "Código de categoría",                      "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCODTEMP",  "C", 10, 0, "Código de la temporada",                   "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LECOTASA",  "L",  1, 0, "Lógico para usar ECOTASA",                 "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LMOSCOM",   "L",  1, 0, "Lógico mostrar comentario" ,               "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "MCOMENT",   "M", 10, 0, "Comentario a mostrar" ,                    "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LPUNTO",    "L",  1, 0, "Lógico para trabajar con puntos" ,         "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCODPRP1",  "C", 20, 0, "Código de la primera propiedad" ,          "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCODPRP2",  "C", 20, 0, "Código de la segunda propiedad" ,          "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lCodPrp",   "L",  1, 0, "" ,                                        "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodFra",   "C",  3, 0, "Código de frases publiciarias",            "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodWeb",   "N", 11, 0, "Código del producto en la web",            "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nPosTpv",   "N", 10, 2, "Posición para mostrar en TPV táctil",      "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDuracion", "N",  3, 0, "Duración del producto",                    "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nTipDur",   "N",  1, 0, "Tipo duración (dia, mes, año)",            "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodFab",   "C",  3, 0, "Código del fabricante",                    "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nImpCom1",  "N",  1, 0, "Impresora de comanda 1",                   "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nImpCom2",  "N",  1, 0, "Impresora de comanda 2",                   "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lMsgMov",   "L",  1, 0, "Lógico para avisar en movimientos sin stock","",                "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cImagenWeb","C",250, 0, "Imagen para la web",                       "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cChgBar",   "D",  8, 0, "Fecha de cambio de código de barras",      "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cDesUbi",   "C",200, 0, "Ubicación",                                "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "dFecVta",   "D",  8, 0, "Fecha de puesta a la venta",               "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "dFinVta",   "D",  8, 0, "Fecha de fin de la venta",                 "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lMsgSer",   "L",  1, 0, "Avisar en ventas por series sin stock",    "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cValPrp1",  "C", 20, 0, "Valor de la primera propiedad",            "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cValPrp2",  "C", 20, 0, "Valor de la segunda propiedad",            "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "mValPrp1",  "M", 10, 0, "Valores seleccionables de la primera propiedad", "",            "", "( cDbfArt )", nil } )
   aAdd( aBase, { "mValPrp2",  "M", 10, 0, "Valores seleccionables de la segunda propiedad", "",            "", "( cDbfArt )", nil } )
   aAdd( aBase, { "dChgBar",   "D",  8, 0, "Fecha de cambio de codigos de barras",     "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodSus",   "C", 18, 0, "Código del artículo al que se sustituye" , "'@!'",              "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodPor",   "C", 18, 0, "Código del artículo por el que es sustituido" , "'@!'",         "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDtoArt1",  "N",  6, 2, "Primer descuento de artículo",             "@EZ 99.99",         "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDtoArt2",  "N",  6, 2, "Segundo descuento de artículo",            "@EZ 99.99",         "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDtoArt3",  "N",  6, 2, "Tercer descuento de artículo",             "@EZ 99.99",         "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDtoArt4",  "N",  6, 2, "Cuarto descuento de artículo",             "@EZ 99.99",         "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDtoArt5",  "N",  6, 2, "Quinto descuento de artículo",             "@EZ 99.99",         "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDtoArt6",  "N",  6, 2, "Sexto descuento de artículo",              "@EZ 99.99",         "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lMarAju",   "L",  1, 0, "Lógico para utilizar el margen de ajuste", "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cMarAju",   "C",  5, 0, "Cadena descriptiva del margen de ajuste",  "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nTarWeb",   "N",  1, 0, "Tarifa a aplicar en la Web" ,              "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "pVtaWeb",   "N", 16, 6, "Precio venta en la Web",                   "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cTipImp1",  "C", 50, 0, "Tipo impresora comanda 1",                 "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cTipImp2",  "C", 50, 0, "Tipo impresora comanda 2",                 "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cRefPrv",   "C", 18, 0, "Referencia del proveedor al artículo" ,    "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodSec",   "C",  3, 0, "Código de la sección para producción" ,    "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nFacCnv",   "N", 16, 6, "Factor de conversión" ,                    "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lSbrInt",   "L",  1, 0, "Lógico precio libre internet" ,            "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nColBtn",   "N", 10, 0, "Color para táctil" ,                       "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cOrdOrd",   "C",  2, 0, "Orden de comanda" ,                        "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lTerminado","L",  1, 0, "Lógico de producto terminado (producción)" , "",                "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lPeso",     "L",  1, 0, "Lógico de producto por peso",              "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cMenu",     "C",  3, 0, "Código del menú de acompañamiento",        "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cTitSeo",   "C", 70, 0, "Meta-título",                              "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cDesSeo",   "C",160, 0, "Meta-descripcion",                         "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cKeySeo",   "C",160, 0, "Meta-keywords",                            "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodEst",   "C",  3, 0, "Estado del artículo",                      "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodEdi",   "C", 20, 0, "Código normalizado del artículo",          "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cRefAux",   "C", 18, 0, "Referencia auxiliar",                      "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cRefAux2",  "C", 18, 0, "Referencia auxiliar 2",                    "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "Matriz",    "C", 18, 0, "Matriz para código de barras" ,            "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nStkCal",   "N", 16, 6, "Stock calculado" ,                         "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lIvaInc2",  "L",  1, 0, "Iva incluido para el precio 2" ,           "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lIvaInc3",  "L",  1, 0, "Iva incluido para el precio 3" ,           "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lIvaInc4",  "L",  1, 0, "Iva incluido para el precio 4" ,           "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lIvaInc5",  "L",  1, 0, "Iva incluido para el precio 5" ,           "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lIvaInc6",  "L",  1, 0, "Iva incluido para el precio 6" ,           "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lIvaPver",  "L",  1, 0, "Iva incluido para el punto verde" ,        "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cWebShop",  "C",100, 0, "Tienda web donde se publica el producto",  "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lIvaWeb",   "L",  1, 0, "Iva incluido para precio web" ,            "",                  "", "( cDbfArt )", nil } )

*/

