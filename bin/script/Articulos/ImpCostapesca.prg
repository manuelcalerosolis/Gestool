//---------------------------------------------------------------------------//
//---------------------NOTAS PARA LA IMPORTACION-----------------------------//
//Campo Extra 001 para código de cliente en artículos------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

//#include "c:\gestool\include\Factu.ch"
#include "c:\fw195\gestool\bin\include\Factu.ch"

static nView
static lOpenFiles          := .f.
static nLineaComienzo      := 2
static oOleExcel
static cCarpeta            := "c:\ficheros\"
static cFicheroFamilias    := "familias.xls"
static cFicheroArticulos   := "articulos.xls"

//---------------------------------------------------------------------------//

function InicioHRB()

   if !OpenFiles( .f. )
      return .f.
   end if

   CursorWait()
   
   if MsgYesNo( "Importar familias padre", "" )
      ImportacionFamiliasPadre()
   end if

   if MsgYesNo( "Importar familias", "" )
      ImportacionFamilias()
   end if

   if MsgYesNo( "Importar artículos", "" )
      ImportacionArticulos()
   end if

   MsgInfo( "Proceso terminado" )

   CursorWe()

   CloseFiles()

return .t.

//---------------------------------------------------------------------------//

static function OpenFiles()

   local oError
   local oBlock

   if lOpenFiles
      MsgStop( 'Imposible abrir ficheros' )
      Return ( .f. )
   end if

   CursorWait()

   oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      nView       := D():CreateView()

      lOpenFiles  := .t.

      D():Agentes( nView )
      D():Familias( nView )
      D():Articulos( nView )
      D():Clientes( nView )
      D():Categorias( nView )
      D():FormasPago( nView )
      D():GrupoClientes( nView )
      D():Ruta( nView )
      D():Proveedores( nView )
      D():ArticulosCodigosBarras( nView )
      D():DetCamposExtras( nView )
      D():ClientesDirecciones( nView )
      D():ClientesBancos( nView )
      D():TiposIva( nView )
      D():TarifaPreciosLineas( nView )

   RECOVER USING oError

      lOpenFiles           := .f.

      msgStop( ErrorMessage( oError ), 'Imposible abrir las bases de datos' )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpenFiles
      CloseFiles()
   end if

   CursorWE()

return ( lOpenFiles )

//---------------------------------------------------------------------------//

static function CloseFiles()

   D():DeleteView( nView )

   lOpenFiles        := .f.

RETURN ( .t. )

//----------------------------------------------------------------------------//

Static Function Conexion( cFile )

   oOleExcel                        := TOleExcel():New( "Importando hoja de excel", "Conectando...", .f. )

   oOleExcel:oExcel:Visible         := .f.
   oOleExcel:oExcel:DisplayAlerts   := .f.
   oOleExcel:oExcel:WorkBooks:Open( cCarpeta + cFile )

   oOleExcel:oExcel:WorkSheets( 1 ):Activate()

   SysRefresh()

Return ( .t. )

//---------------------------------------------------------------------------//

Static Function Desconexion()

   oOleExcel:oExcel:WorkBooks:Close()

   oOleExcel:oExcel:Quit()

   oOleExcel:oExcel:DisplayAlerts   := .t.

   oOleExcel:End()

Return ( .t. )

//----------------------------------------------------------------------------//

Static Function GetRange( cColumn, nRow )

   local oError
   local oBlock
   local uValue
   local cValue   := ""

   oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   uValue         := oOleExcel:oExcel:ActiveSheet:Range( cColumn + lTrim( Str( nRow ) ) ):Value
   if Valtype( uValue ) == "C"
      cValue      := alltrim( uValue )
   end if 

   RECOVER USING oError

      msgStop( "Imposible obtener columna de excel" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( cValue )

//---------------------------------------------------------------------------//

Static Function GetDate( cColumn, nRow )

   local oError
   local oBlock
   local uValue
   local cValue   := ""

   oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   uValue         := oOleExcel:oExcel:ActiveSheet:Range( cColumn + lTrim( Str( nRow ) ) ):Value
   if Valtype( uValue ) == "D"
      cValue      := alltrim( dtoc( uValue ) )
   end if 

   RECOVER USING oError

      msgStop( "Imposible obtener columna de excel" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( cValue )

//---------------------------------------------------------------------------//

Static Function GetNumeric( cColumn, nRow )

   local oError
   local oBlock
   local uValue
   local nValue   := 0

   oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   uValue         := oOleExcel:oExcel:ActiveSheet:Range( cColumn + lTrim( Str( nRow ) ) ):Value

   if Valtype( uValue ) == "C"
      nValue      := Val( StrTran( uValue, ",", "." ) )
   end if 

   if Valtype( uValue ) == "N"
      nValue      := uValue
   end if 

   RECOVER USING oError

      msgStop( "Imposible obtener columna de excel" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( nValue ) 

//------------------------------------------------------------------------

Static Function ImportacionFamiliasPadre()

   local n

   msgwait( "Importamos familias padre", , .1 )

   Conexion( cFicheroFamilias )

   for n := nLineaComienzo to 65536

      /*
      Si no encontramos mas líneas nos salimos------------------------------
      */

      if Empty( oOleExcel:oExcel:ActiveSheet:Range( "B" + lTrim( Str( n ) ) ):Value )
         Exit
      end if

      if !( D():Familias( nView ) )->( dbSeek( Padr( GetRange( "D", n ), 16 ) ) )

         ( D():Familias( nView ) )->( dbAppend() )

         ( D():Familias( nView ) )->cCodFam   := GetRange( "D", n )
         ( D():Familias( nView ) )->cNomFam   := GetRange( "E", n )

         ( D():Familias( nView ) )->( dbUnlock() )

      end if

      msgwait( "Procesando familia padre: " + str( n ), , .001 )

   next

   Desconexion()

Return ( .t. )

//----------------------------------------------------------------------------//

Static Function ImportacionFamilias()

   local n

   msgwait( "Importamos familias", , .1 )

   Conexion( cFicheroFamilias )

   for n := nLineaComienzo to 65536

      /*
      Si no encontramos mas líneas nos salimos------------------------------
      */

      if Empty( oOleExcel:oExcel:ActiveSheet:Range( "B" + lTrim( Str( n ) ) ):Value )
         Exit
      end if

      if !( D():Familias( nView ) )->( dbSeek( Padr( GetRange( "F", n ), 16 ) ) )

         ( D():Familias( nView ) )->( dbAppend() )

         ( D():Familias( nView ) )->cCodFam   := GetRange( "F", n )
         ( D():Familias( nView ) )->cNomFam   := GetRange( "G", n )
         ( D():Familias( nView ) )->cFamCmb   := GetRange( "D", n )

         ( D():Familias( nView ) )->( dbUnlock() )

      end if

      msgwait( "Procesando familia: " + str( n ), , .001 )

   next

   Desconexion()

Return ( .t. )

//----------------------------------------------------------------------------//

Static Function ImportacionArticulos()

   local n
   local TipoIva
   local cCodBar     := ""

   msgwait( "Importamos artículos", , 1 )

   Conexion( cFicheroArticulos )

   for n := nLineaComienzo to 65536

      /*
      Si no encontramos mas líneas nos salimos------------------------------
      */

      if Empty( oOleExcel:oExcel:ActiveSheet:Range( "B" + lTrim( Str( n ) ) ):Value )
         Exit
      end if

      ( D():Articulos( nView ) )->( dbAppend() )

      ( D():Articulos( nView ) )->Codigo        := cCodigoArticulo( GetRange( "B", n ) )
      ( D():Articulos( nView ) )->Nombre        := GetRange( "C", n )
      ( D():Articulos( nView ) )->Familia       := GetRange( "F", n )

      ( D():Articulos( nView ) )->TipoIva       := "G"

      ( D():Articulos( nView ) )->( dbUnlock() )

      msgwait( "Procesando artículos: " + str( n ), , .0001 )

   next

   Desconexion()

Return ( .t. )

//----------------------------------------------------------------------------//

static function cCodigoArticulo( cCodArt )

   if Len( AllTrim( cCodArt ) ) == 11
      cCodArt           := subStr( cCodArt, 1, 6 ) + subStr( cCodArt, 8 )
   end if

Return cCodArt

//----------------------------------------------------------------------------//