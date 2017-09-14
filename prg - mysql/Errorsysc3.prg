#include "\C3\Include\Error.ch"

#define IDI_HAND            32513

/*
 * Establece el manejo de errores.
 */
Procedure ErrorSys()

   ErrorBlock( { | oError | DefError( oError ) } )

Return 

/*
 * Rutina de mensaje de errores.
 */
Function DefError( oError )

   Local nHandle
   Local cMessage
   Local aStack := {}
   Local j,i

   If oError:GenCode == EG_ZERODIV
      Return 0
   EndIf

   If oError:GenCode == EG_OPEN .And. oError:OsCode == 32 .And. oError:CanDefault
      NetErr( .T. )
      Return .F.
   EndIf

   If oError:GenCode == EG_APPENDLOCK .And. oError:CanDefault
      NetErr( .T. )
      Return .F.
   EndIf

   /*
   Nuevas añadidas por mis para q no me de la lata
   */

   If oError:GenCode == EG_CORRUPTION .And. oError:CanDefault
      Return .F.
   EndIf

   If oError:GenCode == EG_DATAWIDTH .And. oError:CanDefault
      Return .F.
   EndIf

   If oError:GenCode == 1035 .And. oError:CanDefault // DBFNTX/1035  Record lock timeout
      Return .F.
   EndIf

   cMessage := ErrorMessage( oError )

   If !Empty( oError:OsCode )
      cMessage += " (DOS Error " + LTrim( Str( oError:OsCode ) ) + ") "
   EndIf

   i := 2

   Do While !Empty( ProcName( i ) )
      aAdd( aStack, "- Llamado desde " + Trim( ProcName( i ) ) + "(" + LTrim( Str( ProcLine( i ) ) ) + ")" )

          for j = 1 to ParamCount( i )
             aAdd( aStack, "     Param " + Str( j, 3 ) + ":" + ValType( GetParam( i, j ) ) + " " + cGetInfo( GetParam( i, j ) ) )
          next

          for j = 1 to LocalCount( i )
             aAdd( aStack, "     Local " + Str( j, 3 ) + ":" + ValType( GetLocal( i, j ) ) + " " + cGetInfo( GetLocal( i, j ) ) )
          next

      i++
   EndDo

   /*
   Escribimos en el fichero de Errores
   */

   fErase( "Error.log" )

   nHandle  := fCreate( "Error.log" )

   fWrite( nHandle, cMessage + Chr( 13 ) + Chr( 10 ) )
   for i := 1 to len( aStack )
      fWrite( nHandle, aStack[ i ] + Chr( 13 ) + Chr( 10 ) )
   next

   fClose( nHandle )

   /*
   Mostramos el error
   */

   ShowErrorMessage( cMessage, aStack )

   /*
   If oError:CanDefault
      if ApoloMsgNoYes( cMessage, "¿ Defecto ?" )
         Return .F.
      Endif
   Else
      ShowErrorMessage( cMessage, aStack )
   EndIf
   */

   ErrorLevel( 1 )
   __QUIT()

return .F.

/*
 * Genera el mensaje del error.
 */
Function ErrorMessage( oError )

   Local i        := 1
   Local cMessage := ""

   if Valtype( oError ) != "O"
      Return cMessage
   end if

   cMessage       := If( oError:Severity > ES_WARNING, "Error ", "Warning " )

   If ValType( oError:SubSystem ) == "C"
      cMessage    += oError:SubSystem()
   Else
      cMessage    += "???"
   EndIf

   If ValType( oError:SubCode ) == "N"
      cMessage    += "/" + LTrim( Str( oError:SubCode ) )
   Else
      cMessage    += "/???"
   EndIf

   If ValType( oError:Description ) == "C"
      cMessage    += "  " + oError:Description
   EndIf

   If !Empty( oError:FileName )
      cMessage    += ": " + oError:FileName
   ElseIf !Empty( oError:Operation )
      cMessage    += ": " + oError:Operation
   EndIf

   Do While !Empty( ProcName( i ) )
      cMessage    += Chr( 13 ) + Chr( 10 ) + "Llamado desde " + Trim( ProcName( i ) ) + "(" + LTrim( Str( ProcLine( i ) ) ) + ")"
      i++
   EndDo

Return cMessage

/*
 * Informacion sobre el estado de las variables.
 */
Function cGetInfo( uVal )

   local cType := ValType( uVal )

   do case
      case cType == "C"
           return uVal

      case cType == "O"
           return "Class: " + uVal:ClassName()

      case cType == "A"
           return "Len: " + Str( Len( uVal ), 4 )

      otherwise
           return cValToChar( uVal )
   endcase

return nil

/*
 * Muestra el error por pantalla.
 */
Static Function ShowErrorMessage( cMessage, aStack )

   Local oDlg
   Local oIco

   oDlg := TDialog():New( ,,,, 'Error',,, .f.,,,,,, .f.,,,,480, 316 )
   oIco := LoadIcon( 0, IDI_HAND )

   TButton():New( 140, 70, '&Enviar error', oDlg, {|| SendErrorMessage( cMessage, aStack ), oDlg:End() }, 50, 12,,, .t., .t., .f.,, .f.,,, .f. )

   TButton():New( 140, 130, '&Salir', oDlg, {|| oDlg:End() }, 50, 12,,, .t., .t., .f.,, .f.,,, .f. )

   TSay():New( 9, 26, {|| OemToAnsi( cMessage ) }, oDlg,,, .f., .f., .f., .t.,,, 149, 20, .f., .f., .f., .f., .f. )

   TListBox():New( 23, 3, { || nil }, aStack, 234, 114,, oDlg,,,, .t., .f.,,,, .f.,,,, .f., .f. )

   oDlg:Activate( ,, {| hDC | DrawIcon( hDC, 6, 6, oIco ) }, .t. )

   DestroyIcon( oIco )

return nil

Static Function SendErrorMessage( cMessage, aStack )

   Local n

   for n := 1 to len( aStack )
      cMessage += aStack[ n ] + Chr( 13 ) + Chr( 10 )
   next

   ShellExecute( 0, "open",   "mailto:watchdog@telefonica.net" + Space( 1 ) +;
                              "?Subject=Error"                 + Space( 1 ) +;
                              "&body=" + cMessage )

/*
#ifdef __HARBOUR__
   MAPISendMailDialog( 0, cMessage, cText, '', '', 'Gst+ error system', 'SMTP:watchdog@telefonica.net' )
#endif
*/

return nil

















































































































































































































































































































































































































