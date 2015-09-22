//MAQUINA----------------------------------------------------------------------
//Hay que crear los siguientes estados de artículos
//000 - Instalación - No Disponible
//001 - Revisión - No Disponible
//002 - Avería - No Disponible
//003 - Retirada - Disponible
//004 - Baja - No disponible
//005 - Máquina Nueva - Disponible


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
   
   ImportaMaquinas()

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

      D():Articulos( nView )
      D():TipoArticulos( nView )

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

static function ImportaMaquinas( cFichero )

   local n
   local oBlock
   local oError
   local oOleExcel
   local cModeloMaquina
   local cCodigoTipo

   ( D():TipoArticulos( nView ) )->( ordSetFocus( "cNomTip" ) )

   CursorWait()

   /*
   Creamos el objeto oOleExcel----------------------------------------------
   */

   oOleExcel                        := TOleExcel():New( "Importando hoja de excel", "Conectando...", .f. )

   oOleExcel:oExcel:Visible         := .f.
   oOleExcel:oExcel:DisplayAlerts   := .f.
   oOleExcel:oExcel:WorkBooks:Open( "C:\ficheros\maquinas.xls" )

   oOleExcel:oExcel:WorkSheets( 1 ):Activate()

   /*
   Recorremos la hoja de calculo--------------------------------------------
   */

   SysRefresh()

   for n := nLineaComienzo to 65536

   /*
   Si no encontramos mas líneas nos salimos------------------------------
   */

      if n == 40000
         Exit
      end if

      if !Empty( oOleExcel:oExcel:ActiveSheet:Range( "D" + lTrim( Str( n ) ) ):Value )

         MsgWait( "Maquina añadido - " + oOleExcel:oExcel:ActiveSheet:Range( "D" + lTrim( Str( n ) ) ):Value, "Máquina", 0.1 )

         ( D():Articulos( nView ) )->( dbAppend() )

         ( D():Articulos( nView ) )->Codigo              := cGetChar( if( !Empty( oOleExcel:oExcel:ActiveSheet:Range( "D" + lTrim( Str( n ) ) ):Value ), oOleExcel:oExcel:ActiveSheet:Range( "D" + lTrim( Str( n ) ) ):Value, "" ) )
         ( D():Articulos( nView ) )->Nombre              := cGetChar( if( !Empty( oOleExcel:oExcel:ActiveSheet:Range( "E" + lTrim( Str( n ) ) ):Value ), oOleExcel:oExcel:ActiveSheet:Range( "E" + lTrim( Str( n ) ) ):Value, "" ) )
         ( D():Articulos( nView ) )->NCTLSTOCK           := 2
         ( D():Articulos( nView ) )->cCodEst             := "005"

         cModeloMaquina                                  := cGetChar( oOleExcel:oExcel:ActiveSheet:Range( "E" + lTrim( Str( n ) ) ):Value )

         if !Empty( cModeloMaquina )

            if ( D():TipoArticulos( nView ) )->( dbSeek( Upper( Padr( cModeloMaquina, 100 ) ) ) )

               ( D():Articulos( nView ) )->cCodTip       := ( D():TipoArticulos( nView ) )->cCodTip

            else

               cCodigoTipo       := NextKey( dbLast( D():TipoArticulos( nView ), 1 ), D():TipoArticulos( nView ), "0", 3 )
               
               ( D():TipoArticulos( nView ) )->( dbAppend() )         

               ( D():TipoArticulos( nView ) )->cCodTip   := cCodigoTipo
               ( D():TipoArticulos( nView ) )->cNomTip   := Upper( cModeloMaquina )

               ( D():TipoArticulos( nView ) )->( dbUnLock() )

               ( D():Articulos( nView ) )->cCodTip       := cCodigoTipo

            end if

         end if

         ( D():Articulos( nView ) )->( dbUnLock() )

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
      uVal := Int( uVal )
   end if

Return ( cValToChar( uVal ) )

//------------------------------------------------------------------------