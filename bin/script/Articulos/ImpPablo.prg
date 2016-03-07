//#include "c:\gestool\include\Factu.ch"
#include "c:\fw195\gestool\bin\include\Factu.ch"

static nView
static lOpenFiles          := .f.
static nLineaComienzo      := 2
static oOleExcel
static cCarpeta            := "c:\ficheros\"
static cFichero            := "articulos.xls"

//---------------------------------------------------------------------------//

function InicioHRB()

   if !OpenFiles( .f. )
      return .f.
   end if

   CursorWait()
   
   if MsgYesNo( "Importar familias", "" )
      ImportacionFamilias()
   end if

   if MsgYesNo( "Importar artículos", "" )
      ImportacionArticulos()
   end if

   if MsgYesNo( "Importar stock", "" )
      ImportacionStock()
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
      D():MovimientosAlmacenLineas( nView )

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

Static Function ImportacionFamilias()

   local n
   local cNomFam
   local nCount      := 1
   local aFamilias   := {}
   local familia
   local nOrdAnt     := ( D():Familias( nView ) )->( OrdSetFocus( "cNomFam" ) )

   msgwait( "Importamos familias", , .1 )

   Conexion( cFichero )

   for n := nLineaComienzo to 3550

      /*
      Si no encontramos mas líneas nos salimos------------------------------
      */

      cNomFam        := oOleExcel:oExcel:ActiveSheet:Range( "D" + lTrim( Str( n ) ) ):Value

      if !Empty( cNomFam )

         if !( D():Familias( nView ) )->( dbSeek( Padr( Upper( cNomFam ), 40 ) ) )

            ( D():Familias( nView ) )->( dbAppend() )

            ( D():Familias( nView ) )->cCodFam   := Str( nCount )
            ( D():Familias( nView ) )->cNomFam   := Padr( Upper( cNomFam ), 40 )

            ( D():Familias( nView ) )->( dbUnlock() )

            nCount++

         end if

      end if

      msgwait( "Procesando familias: " + if( !Empty( cNomFam ), cNomFam, "" ), , .0001 )

   next

   Desconexion()

   ( D():Familias( nView ) )->( OrdSetFocus( nOrdAnt ) )

Return ( .t. )

//----------------------------------------------------------------------------//

Static Function ImportacionArticulos()

   local n
   local TipoIva
   local cCodBar     := ""
   local cCodArt

   msgwait( "Importamos artículos", , 1 )

   Conexion( cFichero )

   for n := nLineaComienzo to 3550

      
      cCodArt        := oOleExcel:oExcel:ActiveSheet:Range( "A" + lTrim( Str( n ) ) ):Value   

      if !Empty( cCodArt )

         ( D():Articulos( nView ) )->( dbAppend() )

         ( D():Articulos( nView ) )->Codigo        := cCodArt
         ( D():Articulos( nView ) )->Nombre        := GetRange( "F", n )
         ( D():Articulos( nView ) )->Familia       := RetFld( GetRange( "D", n ), D():Familias( nView ), "cCodFam", "cNomFam" )
         ( D():Articulos( nView ) )->TipoIva       := "G"

         ( D():Articulos( nView ) )->pCosto        := GetNumeric( "I", n )
         ( D():Articulos( nView ) )->pVenta1       := GetNumeric( "J", n ) / 1.21
         ( D():Articulos( nView ) )->pVtaIva1      := GetNumeric( "J", n )
         ( D():Articulos( nView ) )->pVenta2       := GetNumeric( "K", n ) / 1.21
         ( D():Articulos( nView ) )->pVtaIva2      := GetNumeric( "K", n )

         ( D():Articulos( nView ) )->nMinimo       := GetNumeric( "H", n )

         ( D():Articulos( nView ) )->( dbUnlock() )

         cCodBar                                   := GetNumeric( "C", n )

         if !Empty( cCodBar )

            ( D():ArticulosCodigosBarras( nView ) )->( dbAppend() )

            ( D():ArticulosCodigosBarras( nView ) )->cCodArt   := cCodArt
            ( D():ArticulosCodigosBarras( nView ) )->cCodBar   := AllTrim( Str( Int( cCodBar ) ) )

            ( D():ArticulosCodigosBarras( nView ) )->( dbUnlock() )

         end if

      end if

      msgwait( "Procesando artículos: " + str( n ), , .0001 )

   next

   Desconexion()

Return ( .t. )

//---------------------------------------------------------------------------//

Static Function ImportacionStock()

   local n
   local TipoIva
   local cCodBar     := ""
   local cCodArt

   msgwait( "Importamos stock artículos", , 1 )

   Conexion( cFichero )

   for n := nLineaComienzo to 3550

      
      cCodArt        := oOleExcel:oExcel:ActiveSheet:Range( "A" + lTrim( Str( n ) ) ):Value   

      if !Empty( cCodArt )

         if !Empty( GetNumeric( "G", n ) )

            ( D():MovimientosAlmacenLineas( nView ) )->( dbAppend() )

            ( D():MovimientosAlmacenLineas( nView ) )->cRefMov       := cCodArt
            ( D():MovimientosAlmacenLineas( nView ) )->cNomMov       := GetRange( "F", n )
            ( D():MovimientosAlmacenLineas( nView ) )->dFecMov       := ctod( "01/01/2016" )
            ( D():MovimientosAlmacenLineas( nView ) )->cTimMov       := "080000"
            ( D():MovimientosAlmacenLineas( nView ) )->cAliMov       := "000"
            ( D():MovimientosAlmacenLineas( nView ) )->nUndMov       := GetNumeric( "G", n )
            ( D():MovimientosAlmacenLineas( nView ) )->nPreDiv       := GetNumeric( "I", n )
            ( D():MovimientosAlmacenLineas( nView ) )->nNumRem       := 1
            ( D():MovimientosAlmacenLineas( nView ) )->cSufRem       := "00"
            ( D():MovimientosAlmacenLineas( nView ) )->nTipMov       := 4
    
            ( D():MovimientosAlmacenLineas( nView ) )->( dbUnlock() )

         end if

      end if

      msgwait( "Procesando artículos: " + str( n ), , .0001 )

   next

   Desconexion()

Return ( .t. )

//---------------------------------------------------------------------------//