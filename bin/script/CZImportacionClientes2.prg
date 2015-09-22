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
   
   ImportaClientes()

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

      D():Clientes( nView )

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

static function ImportaClientes( cFichero )

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
   oOleExcel:oExcel:WorkBooks:Open( "C:\ficheros\clientesnuevos.xls" )

   oOleExcel:oExcel:WorkSheets( 1 ):Activate()

   /*
   Recorremos la hoja de calculo--------------------------------------------
   */

   SysRefresh()

   for n := nLineaComienzo to 65536

      /*
      Si no encontramos mas líneas nos salimos------------------------------
      */

      if Empty( oOleExcel:oExcel:ActiveSheet:Range( "A" + lTrim( Str( n ) ) ):Value )
         Exit
      end if

      //cCodCli     := NextKey( dbLast( D():Clientes( nView ), 1 ), D():Clientes( nView ), "0", RetNumCodCliEmp() )

      MsgWait( "Cliente añadido - " + cGetChar( oOleExcel:oExcel:ActiveSheet:Range( "A" + lTrim( Str( n ) ) ):Value ), "Cliente", 0.1 )

      ( D():Clientes( nView ) )->( dbAppend() )

      ( D():Clientes( nView ) )->Cod            := RJust( cGetChar( oOleExcel:oExcel:ActiveSheet:Range( "A" + lTrim( Str( n ) ) ):Value ), "0", RetNumCodCliEmp() )

      ( D():Clientes( nView ) )->Titulo         := cGetChar( if( !Empty( oOleExcel:oExcel:ActiveSheet:Range( "B" + lTrim( Str( n ) ) ):Value ), oOleExcel:oExcel:ActiveSheet:Range( "B" + lTrim( Str( n ) ) ):Value, "" ) )
      ( D():Clientes( nView ) )->NbrEst         := cGetChar( if( !Empty( oOleExcel:oExcel:ActiveSheet:Range( "C" + lTrim( Str( n ) ) ):Value ), oOleExcel:oExcel:ActiveSheet:Range( "C" + lTrim( Str( n ) ) ):Value, "" ) )
      ( D():Clientes( nView ) )->Nif            := cGetChar( if( !Empty( oOleExcel:oExcel:ActiveSheet:Range( "D" + lTrim( Str( n ) ) ):Value ), oOleExcel:oExcel:ActiveSheet:Range( "D" + lTrim( Str( n ) ) ):Value, "" ) )
      ( D():Clientes( nView ) )->Domicilio      := cGetChar( if( !Empty( oOleExcel:oExcel:ActiveSheet:Range( "AR" + lTrim( Str( n ) ) ):Value ), oOleExcel:oExcel:ActiveSheet:Range( "AR" + lTrim( Str( n ) ) ):Value, "" ) )
      ( D():Clientes( nView ) )->Poblacion      := cGetChar( if( !Empty( oOleExcel:oExcel:ActiveSheet:Range( "AU" + lTrim( Str( n ) ) ):Value ), oOleExcel:oExcel:ActiveSheet:Range( "AU" + lTrim( Str( n ) ) ):Value, "" ) )
      ( D():Clientes( nView ) )->CodPostal      := cGetChar( if( !Empty( oOleExcel:oExcel:ActiveSheet:Range( "AS" + lTrim( Str( n ) ) ):Value ), oOleExcel:oExcel:ActiveSheet:Range( "AS" + lTrim( Str( n ) ) ):Value, "" ) )
      ( D():Clientes( nView ) )->Provincia      := cGetChar( if( !Empty( oOleExcel:oExcel:ActiveSheet:Range( "AY" + lTrim( Str( n ) ) ):Value ), oOleExcel:oExcel:ActiveSheet:Range( "AY" + lTrim( Str( n ) ) ):Value, "" ) )
      ( D():Clientes( nView ) )->Telefono       := cGetChar( if( !Empty( oOleExcel:oExcel:ActiveSheet:Range( "BB" + lTrim( Str( n ) ) ):Value ), oOleExcel:oExcel:ActiveSheet:Range( "BB" + lTrim( Str( n ) ) ):Value, "" ) )
      ( D():Clientes( nView ) )->nDtoEsp        := nGetNumeric( if( !Empty( oOleExcel:oExcel:ActiveSheet:Range( "I" + lTrim( Str( n ) ) ):Value ), oOleExcel:oExcel:ActiveSheet:Range( "I" + lTrim( Str( n ) ) ):Value, 0 ) )
      ( D():Clientes( nView ) )->cCodAlm        := "000"
      ( D():Clientes( nView ) )->CodPago        := "00"
      ( D():Clientes( nView ) )->lChgPre        := .t.
      ( D():Clientes( nView ) )->Subcta         := cGetChar( if( !Empty( oOleExcel:oExcel:ActiveSheet:Range( "Z" + lTrim( Str( n ) ) ):Value ), oOleExcel:oExcel:ActiveSheet:Range( "Z" + lTrim( Str( n ) ) ):Value, "" ) )
      ( D():Clientes( nView ) )->CtaVenta       := cGetChar( if( !Empty( oOleExcel:oExcel:ActiveSheet:Range( "AA" + lTrim( Str( n ) ) ):Value ), oOleExcel:oExcel:ActiveSheet:Range( "AA" + lTrim( Str( n ) ) ):Value, "" ) )

      ( D():Clientes( nView ) )->( dbUnLock() )

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