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
   oOleExcel:oExcel:WorkBooks:Open( "C:\ficheros\clientes.xls" )

   oOleExcel:oExcel:WorkSheets( 1 ):Activate()

   /*
   Recorremos la hoja de calculo--------------------------------------------
   */

   SysRefresh()

   for n := nLineaComienzo to 65536

   /*
   Si no encontramos mas líneas nos salimos------------------------------
   */

      if n == 23300
         Exit
      end if

      if !Empty( oOleExcel:oExcel:ActiveSheet:Range( "A" + lTrim( Str( n ) ) ):Value ) .and.;
         !dbSeekInOrd( oOleExcel:oExcel:ActiveSheet:Range( "A" + lTrim( Str( n ) ) ):Value, "cUsrDef01", D():Clientes( nView ) )

         cCodCli     := NextKey( dbLast( D():Clientes( nView ), 1 ), D():Clientes( nView ), "0", RetNumCodCliEmp() )

         MsgWait( "Cliente añadido - " + cCodCli, "Cliente", 0.1 )

         ( D():Clientes( nView ) )->( dbAppend() )

            ( D():Clientes( nView ) )->Cod            := cCodCli
            ( D():Clientes( nView ) )->Nif            := SubStr( cGetChar( if( !Empty( oOleExcel:oExcel:ActiveSheet:Range( "D" + lTrim( Str( n ) ) ):Value ), oOleExcel:oExcel:ActiveSheet:Range( "D" + lTrim( Str( n ) ) ):Value, "" ) ), 3 )
            ( D():Clientes( nView ) )->Poblacion      := cGetChar( if( !Empty( oOleExcel:oExcel:ActiveSheet:Range( "C" + lTrim( Str( n ) ) ):Value ), oOleExcel:oExcel:ActiveSheet:Range( "C" + lTrim( Str( n ) ) ):Value, "" ) )
            ( D():Clientes( nView ) )->cMeiInt        := cGetChar( if( !Empty( oOleExcel:oExcel:ActiveSheet:Range( "F" + lTrim( Str( n ) ) ):Value ), oOleExcel:oExcel:ActiveSheet:Range( "F" + lTrim( Str( n ) ) ):Value, "" ) )
            ( D():Clientes( nView ) )->Movil          := cGetChar( if( !Empty( oOleExcel:oExcel:ActiveSheet:Range( "E" + lTrim( Str( n ) ) ):Value ), oOleExcel:oExcel:ActiveSheet:Range( "E" + lTrim( Str( n ) ) ):Value, "" ) )
            ( D():Clientes( nView ) )->Titulo         := cGetChar( if( !Empty( oOleExcel:oExcel:ActiveSheet:Range( "B" + lTrim( Str( n ) ) ):Value ), oOleExcel:oExcel:ActiveSheet:Range( "B" + lTrim( Str( n ) ) ):Value, "" ) )

            Referencia                                := oOleExcel:oExcel:ActiveSheet:Range( "A" + lTrim( Str( n ) ) ):Value

            if !Empty( Referencia )

               if ValType( Referencia ) == "N"
                  ( D():Clientes( nView ) )->cUsrDef01   := RJust( Referencia, "0", 6 )
               else
                  if Len( Referencia ) < 6
                     ( D():Clientes( nView ) )->cUsrDef01   := RJust( cGetChar( if( !Empty( Referencia ), Referencia, "" ) ), "0", 6 )
                  else
                     ( D():Clientes( nView ) )->cUsrDef01   := cGetChar( if( !Empty( Referencia ), Referencia, "" ) )
                  end if   

               end if

            end if

         ( D():Clientes( nView ) )->( dbUnLock() )

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