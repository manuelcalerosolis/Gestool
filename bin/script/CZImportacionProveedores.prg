//CLIENTES---------------------------------------------------------------------

#include "c:\fw195\gestool\bin\include\Factu.ch"

static nView
static lOpenFiles       := .f.
static nLineaComienzo   := 2

//---------------------------------------------------------------------------//

function InicioHRB()

   /*
   Abrimos los ficheros necesarios---------------------------------------------
   */

   if !OpenFiles( .f. )
      return .f.
   end if

   CursorWait()
   
   ImportaProveedor()

   Msginfo( "Importación realizada con éxito" )

   CursorWe()

   /*
   Cerramos los ficheros abiertos anteriormente--------------------------------
   */

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

      lOpenFiles  := .t.

      nView             := D():CreateView()

      D():Proveedores( nView )

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

//--------------------------------------------------------------------------//

static function CloseFiles()

   D():DeleteView( nView )

   lOpenFiles     := .f.

RETURN ( .t. )

//----------------------------------------------------------------------------//

static function ImportaProveedor( cFichero )

   local n
   local oBlock
   local oError
   local oOleExcel
   local cCodCli
   local Referencia

   CursorWait()

   /*
   Creamos el objeto oOleExcel----------------------------------------------
   */

   oOleExcel                        := TOleExcel():New( "Importando hoja de excel", "Conectando...", .f. )

   oOleExcel:oExcel:Visible         := .f.
   oOleExcel:oExcel:DisplayAlerts   := .f.
   oOleExcel:oExcel:WorkBooks:Open( "C:\ficheros\proveedores.xls" )

   oOleExcel:oExcel:WorkSheets( 1 ):Activate()

   /*
   Recorremos la hoja de calculo--------------------------------------------
   */

   SysRefresh()

   for n := nLineaComienzo to 55

   /*
   Si no encontramos mas líneas nos salimos------------------------------
   */

      if !Empty( oOleExcel:oExcel:ActiveSheet:Range( "A" + lTrim( Str( n ) ) ):Value )

         MsgWait( "Proveedor añadido - " + cGetChar( oOleExcel:oExcel:ActiveSheet:Range( "A" + lTrim( Str( n ) ) ):Value ), "Proveedor", 0.1 )

         ( D():Proveedores( nView ) )->( dbAppend() )

            ( D():Proveedores( nView ) )->Cod            := cGetChar( oOleExcel:oExcel:ActiveSheet:Range( "A" + lTrim( Str( n ) ) ):Value )
            ( D():Proveedores( nView ) )->Titulo         := cGetChar( oOleExcel:oExcel:ActiveSheet:Range( "B" + lTrim( Str( n ) ) ):Value )
            ( D():Proveedores( nView ) )->Nif            := cGetChar( oOleExcel:oExcel:ActiveSheet:Range( "C" + lTrim( Str( n ) ) ):Value )
            ( D():Proveedores( nView ) )->SubCta         := cGetChar( oOleExcel:oExcel:ActiveSheet:Range( "D" + lTrim( Str( n ) ) ):Value )
            ( D():Proveedores( nView ) )->Domicilio      := cGetChar( oOleExcel:oExcel:ActiveSheet:Range( "E" + lTrim( Str( n ) ) ):Value )
            ( D():Proveedores( nView ) )->Telefono       := cGetChar( oOleExcel:oExcel:ActiveSheet:Range( "F" + lTrim( Str( n ) ) ):Value )
            ( D():Proveedores( nView ) )->CodPostal      := cGetChar( oOleExcel:oExcel:ActiveSheet:Range( "G" + lTrim( Str( n ) ) ):Value )
            ( D():Proveedores( nView ) )->Poblacion      := cGetChar( oOleExcel:oExcel:ActiveSheet:Range( "H" + lTrim( Str( n ) ) ):Value )
            ( D():Proveedores( nView ) )->Provincia      := cGetChar( oOleExcel:oExcel:ActiveSheet:Range( "I" + lTrim( Str( n ) ) ):Value )

         ( D():Proveedores( nView ) )->( dbUnLock() )

      end if

   next

   /*
   Cerramos la conexion con el objeto oOleExcel-----------------------------
   */

   oOleExcel:oExcel:WorkBooks:Close()

   oOleExcel:oExcel:Quit()

   oOleExcel:oExcel:DisplayAlerts   := .t.

   oOleExcel:End()

   CursorWE()

Return .t.

//------------------------------------------------------------------------

static function nGetNumeric( uVal )

   local nVal     := 0

   do case
      case Valtype( uVal ) == "C"
         nVal     := Val( StrTran( uVal, ",", "." ) )
      case Valtype( uVal ) == "N"
         nVal     := uVal
   end case 

Return ( nVal )
 
//------------------------------------------------------------------------

static function cGetChar( uVal )

   if Valtype( uVal ) == "N"
      uVal := Str( uVal )
   end if

Return ( cValToChar( uVal ) )

//------------------------------------------------------------------------