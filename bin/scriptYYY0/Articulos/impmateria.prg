#include "hbclass.ch"

#define CRLF                        chr( 13 ) + chr( 10 )

#define OFN_PATHMUSTEXIST            0x00000800
#define OFN_NOCHANGEDIR              0x00000008
#define OFN_ALLOWMULTISELECT         0x00000200
#define OFN_EXPLORER                 0x00080000     // new look commdlg
#define OFN_LONGNAMES                0x00200000     // force long names for 3.x modules
#define OFN_ENABLESIZING             0x00800000

//---------------------------------------------------------------------------//

Function Inicio()

   local oArticulosICG

   oArticulosICG        := ArticulosICG():New()

Return ( nil )

//---------------------------------------------------------------------------//

CLASS ArticulosICG

   DATA nView

   DATA oOleExcel
   
   DATA nRow
   DATA nLineaComienzo     INIT  2

   DATA cCodigoArticulo    INIT  ""
   DATA cNombreArticulo    INIT  ""

   DATA aFichero

   METHOD New()            CONSTRUCTOR

   METHOD AddFichero()  

   METHOD OpenFiles()
   METHOD CloseFiles()     INLINE ( TDataView():DeleteView( ::nView ) )

   METHOD ProcessFile()

   METHOD AppendArticulo()

   METHOD GetRange()

   METHOD GetNumeric()

ENDCLASS

//---------------------------------------------------------------------------//

   METHOD New() CLASS ArticulosICG

      local cFichero

      ::AddFichero()

      if empty( ::aFichero )
         Return ( Self )
      end if 
   
      if !::OpenFiles()
   		Return ( Self )
   	end if 

      for each cFichero in ::aFichero
         ::ProcessFile( cFichero )
      next 

      ::CloseFiles()

   Return ( Self )

//---------------------------------------------------------------------------//

METHOD AddFichero() CLASS ArticulosICG

   local i
   local cFile
   local aFile
   local nFlag    := nOr( OFN_PATHMUSTEXIST, OFN_NOCHANGEDIR, OFN_ALLOWMULTISELECT, OFN_EXPLORER, OFN_LONGNAMES )

   ::aFichero     := {}

   cFile          := cGetFile( "All | *.xls", "Seleccione los ficheros a importar", "*.xls" , , .f., .t., nFlag )
   cFile          := Left( cFile, At( Chr( 0 ) + Chr( 0 ), cFile ) - 1 )

   if !Empty( cFile ) //.or. Valtype( cFile ) == "N"

      cFile       := StrTran( cFile, Chr( 0 ), "," )
      aFile       := hb_aTokens( cFile, "," )

      if Len( aFile ) > 1

         for i := 2 to Len( aFile )
            aFile[ i ] := aFile[ 1 ] + "\" + aFile[ i ]
         next

         aDel( aFile, 1, .t. )

      endif

      if IsArray( aFile )

         for i := 1 to Len( aFile )
            aAdd( ::aFichero, aFile[ i ] ) // if( SubStr( aFile[ i ], 4, 1 ) == "\", aFileDisc( aFile[i] ) + "\" + aFileName( aFile[ i ] ), aFile[ i ] ) )
         next

      else

         aAdd( ::aFichero, aFile )

      endif

   end if

RETURN ( ::aFichero )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS ArticulosICG

   local oError
   local oBlock
   local lOpenFiles     := .t.

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::nView           := TDataView():CreateView()

      TDataView():Articulos( ::nView )

      TDataView():Get( "ArtCodebar", ::nView )  

      TDataView():Get( "Ruta", ::nView )

      TDataView():Get( "Agentes", ::nView )

   RECOVER USING oError

      lOpenFiles        := .f.

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lOpenFiles )

//---------------------------------------------------------------------------//

METHOD ProcessFile( cFichero ) CLASS ArticulosICG

   CursorWait()

      ::oOleExcel                        := TOleExcel():New( "Importando hoja de excel", "Conectando...", .f. )

      ::oOleExcel:oExcel:Visible         := .f.
      ::oOleExcel:oExcel:DisplayAlerts   := .f.
      ::oOleExcel:oExcel:WorkBooks:Open( cFichero )

      ::oOleExcel:oExcel:WorkSheets( 1 ):Activate()   //Hojas de la hoja de calculo

      /*
      Recorremos la hoja de calculo--------------------------------------------
      */

      SysRefresh()

      for ::nRow := ::nLineaComienzo to 65536

         /*
         Si no encontramos mas líneas nos salimos------------------------------
         */

         ::cCodigoArticulo               := ::GetRange( "A" )
         ::nPrecioVigor                  := ::GetRange( "F" )

         if empty( ::cCodigoArticulo )

            exit
         
         else 
         
            ::AppendArticulo()
         
         end if

      next

      /*
      Cerramos la conexion con el objeto oOleExcel-----------------------------
      */

      ::oOleExcel:oExcel:WorkBooks:Close() 
      ::oOleExcel:oExcel:Quit()
      ::oOleExcel:oExcel:DisplayAlerts   := .t.

      ::oOleExcel:End()

      Msginfo( "Porceso finalizado con exito" )

      /*
      Cerrando el control de errores-------------------------------------------

      RECOVER USING oError


         msgStop( "Error en el proceso de importación : " + ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )
      */

   CursorWE()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD AppendArticulo()

   if ( TDataView():Articulos( ::nView ) )->( dbseek( ::cCodigoArticulo ) )
      
      if ( TDataView():Articulos( ::nView ) )->( dbrlock() )

         ( TDataView():Articulos( ::nView ) )->Nombre  := ::cNombreArticulo

         ( TDataView():Articulos( ::nView ) )->( dbunlock() )

      end if

   else

      if ( TDataView():Articulos( ::nView ) )->( dbappend() )
         
         ( TDataView():Articulos( ::nView ) )->Codigo    := ::cCodigoArticulo
         ( TDataView():Articulos( ::nView ) )->Nombre    := ::cNombreArticulo

         ( TDataView():Articulos( ::nView ) )->( dbunlock() )

      end if 

   end if 

return ( nil )

//------------------------------------------------------------------------

METHOD GetRange( cColumn )

   local oError
   local oBlock
   local uValue   := ""

   oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   uValue         := ::oOleExcel:oExcel:ActiveSheet:Range( cColumn + lTrim( Str( ::nRow ) ) ):Value
   if Valtype( uValue ) == "C"
      uValue      := alltrim( uValue )
   end if 

   RECOVER USING oError

      msgStop( "Imposible obtener columna de excel" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( uValue )

//---------------------------------------------------------------------------//

METHOD GetNumeric( cColumn )

   local uValue

   uValue         := ::GetRange( cColumn )

   if Valtype( uValue ) == "C"
      uValue      := Val( StrTran( uValue, ",", "." ) )
   end if

Return ( uValue ) 

//------------------------------------------------------------------------

function aItmArt()

   local aBase  := {}

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
   aAdd( aBase, { "CCODTIP",   "C",  3, 0, "Código del tipo de artículo" ,            "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LTIPACC",   "L",  1, 0, "Lógico de acceso por unidades o importe", "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LCOMBUS",   "L",  1, 0, "Lógico si el artículo es del tipo combustible", "",             "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCODIMP",   "C",  3, 0, "Código del impuesto especiales",          "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LMSGVTA",   "L",  1, 0, "Lógico para avisar en venta sin stock",   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LNOTVTA",   "L",  1, 0, "Lógico para no permitir venta sin stock", "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NLOTE",     "N",  9, 0, "",                                        "'999999999'",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CLOTE",     "C", 12, 0, "Número de lote",                          "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LLOTE",     "L",  1, 0, "Lote (S/N)",                              "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LPUBINT",   "L",  1, 0, "Lógico para publicar en internet (S/N)",  "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LPUBOFE",   "L",  1, 0, "Lógico para publicar como oferta (S/N)",  "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LPUBPOR",   "L",  1, 0, "Lógico para publicar como artículo destacado (S/N)",  "",       "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NDTOINT1",  "N",  6, 2, "Descuento de oferta para tienda web 1",   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPINT1",  "N", 15, 6, "Precio del producto en oferta 1",         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPIVA1",  "N", 15, 6, "Precio del producto en oferta con " + cImp() + " 1", "",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NDTOINT2",  "N",  6, 2, "Descuento de oferta para tienda web 2",   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPINT2",  "N", 15, 6, "Precio del producto en oferta 2",         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPIVA2",  "N", 15, 6, "Precio del producto en oferta con " + cImp() + " 2", "",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NDTOINT3",  "N",  6, 2, "Descuento de oferta para tienda web 3",   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPINT3",  "N", 15, 6, "Precio del producto en oferta 3",         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPIVA3",  "N", 15, 6, "Precio del producto en oferta con " + cImp() + " 3", "",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NDTOINT4",  "N",  6, 2, "Descuento de oferta para tienda web 4",   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPINT4",  "N", 15, 6, "Precio del producto en oferta 4",         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPIVA4",  "N", 15, 6, "Precio del producto en oferta con " + cImp() + " 4", "",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NDTOINT5",  "N",  6, 2, "Descuento de oferta para tienda web 5",   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPINT5",  "N", 15, 6, "Precio del producto en oferta 5",         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPIVA5",  "N", 15, 6, "Precio del producto en oferta con " + cImp() + " 5", "",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NDTOINT6",  "N",  6, 2, "Descuento de oferta para tienda web 6",   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPINT6",  "N", 15, 6, "Precio del producto en oferta 6",         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPIVA6",  "N", 15, 6, "Precio del producto en oferta con " + cImp() + " 6", "",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NMESGRT",   "N",  2, 0, "Meses de garantía",                       "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NINFENT",   "N",  1, 0, "Información de entrega",                  "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NINFENT1",  "N",  3, 0, "Dias en entregar la mercancia ( desde )", "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NINFENT2",  "N",  3, 0, "Dias en entregar la mercancia ( hasta )", "",                   "", "( cDbfArt )", nil } )
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
   aAdd( aBase, { "CCODCATE",  "C",  3, 0, "Código de categoría",                      "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCODTEMP",  "C",  3, 0, "Código de la temporada",                   "",                  "", "( cDbfArt )", nil } )
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
   aAdd( aBase, { "cCodUbi1",  "C",  5, 0, "Código primera ubicación",                 "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodUbi2",  "C",  5, 0, "Código segunda ubicación",                 "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodUbi3",  "C",  5, 0, "Código tercera ubicación",                 "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cValUbi1",  "C",  5, 0, "Valor primera ubicación",                  "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cValUbi2",  "C",  5, 0, "Valor segunda ubicación",                  "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cValUbi3",  "C",  5, 0, "Valor tercera ubicación",                  "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "dFecVta",   "D",  8, 0, "Fecha de puesta a la venta",               "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "dFinVta",   "D",  8, 0, "Fecha de fin de la venta",                 "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lMsgSer",   "L",  1, 0, "Avisar en ventas por series sin stock",    "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cValPrp1",  "C", 10, 0, "Valor de la primera propiedad",            "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cValPrp2",  "C", 10, 0, "Valor de la segunda propiedad",            "",                  "", "( cDbfArt )", nil } )
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

return ( aBase )
