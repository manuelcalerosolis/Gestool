//Operarios--------------------------------------------------------------------

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
   
   ImportaOperarios()

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

      D():Operarios( nView )

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

   lOpenFiles     := .f.

RETURN ( .t. )

//---------------------------------------------------------------------------//

static function ImportaOperarios( cFichero )

   local n
   local oBlock
   local oError
   local oOleExcel
   local cCodOpe

   CursorWait()

   /*
   Creamos el objeto oOleExcel-------------------------------------------------
   */

   oOleExcel                        := TOleExcel():New( "Importando hoja de excel", "Conectando...", .f. )

   oOleExcel:oExcel:Visible         := .f.
   oOleExcel:oExcel:DisplayAlerts   := .f.
   oOleExcel:oExcel:WorkBooks:Open( "C:\ficheros\operarios.xls" )

   oOleExcel:oExcel:WorkSheets( 1 ):Activate()

   /*
   Recorremos la hoja de calculo-----------------------------------------------
   */

   SysRefresh()

   for n := nLineaComienzo to 65536

      /*
      Si no encontramos mas líneas nos salimos---------------------------------
      */

      if n == 23300
         Exit
      end if

      cCodOpe     := NextKey( dbLast( D():Operarios( nView ), 1 ), D():Operarios( nView ), "0", 5 )
      cNomOpe     := oOleExcel:oExcel:ActiveSheet:Range( "L" + lTrim( Str( n ) ) ):Value

      MsgWait( "Operario añadido - " + cCodOpe, "Operario", 0.1 )

      if !Empty( cNomOpe )

         if !dbSeekInOrd( cNomOpe, "cNomTra", D():Operarios( nView ) )

            ( D():Operarios( nView ) )->( dbAppend() )

               ( D():Operarios( nView ) )->cCodTra     := cCodOpe
               ( D():Operarios( nView ) )->cNomTra     := cNomOpe

            ( D():Operarios( nView ) )->( dbUnLock() )

         end if   

      end if   

   next

   /*
   Cerramos la conexion con el objeto oOleExcel--------------------------------
   */

   oOleExcel:oExcel:WorkBooks:Close()

   oOleExcel:oExcel:Quit()

   oOleExcel:oExcel:DisplayAlerts   := .t.

   oOleExcel:End()

   CursorWE()

Return .t.

//---------------------------------------------------------------------------//

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