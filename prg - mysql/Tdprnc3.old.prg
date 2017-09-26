/*
ÚÄ Programa ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³   Aplication: Class TDosPrint                                            ³
³         File: TDOSPRN.PRG                                                ³
³       Author: Ignacio Ortiz de Z£¤iga Echeverr¡a                         ³
³          CIS: Ignacio Ortiz (Ignacio_Ortiz)                              ³
³     Internet: http://ourworld.compuserve.com/homepages/Ignacio_Ortiz     ³
³         Date: 09/13/96                                                   ³
³         Time: 20:20:07                                                   ³
³    Copyright: 1997 by Ortiz de Zu¤iga, S.L.                              ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

NOTES:

This peace of software is freeware and is not part of FiveWin.

The following code will let you print directly to the printer from inside
any Fivewin program, like OLD DOS days. Those users that need DOS printing
speed can use this class instead of the TPrinter class.

The use of the class is very easy and is very similar to the TPrinter class
of Fivewin, but we have not create any command to avoid the use of any
static vars.

This is a little sample of how to use the new class:

  LOCAL oPrn

  oPrn := TDosPrn():New("lpt1")

  oPrn:Say(10,20, "This goes in line 10, column 20")
  oPrn:EndPage()                                      // optional

  oPrn:End()

A little description of all the members of this class:

DATA:

 cPort:        Printing port, by default "LPT1"
 cCompress:    String for compressed mode, by default "15"
 cNormal:      String for normal mode, by default "18"
 cFormFeed:    String for EJECT, by default "12"
 hDC:          Printing file Handle (Internal use)
 nRow:         Current printing row
 nCol:         Current pringing column
 nLeftMargin:  Left margin, by default 0
 nTopMargin:   Top margin, by default 0
 lAnsiToOem:   If .T. a Ansi to Oem translation is done automatically
               whe printing, by default is .T.

METHODS:

 New(cPort)    Constructor, no comment
 End()         Destructor, no comment
 EndPage()     End of page, this method is optional if there is only on page
 Command(c)    Let you send any command to the printer without changing the
               current row and col. The string to pass as a parameter should
               content the ascii values of the command separated with commas,
               for example, the command to reset Epson printers should
               be: "27,69"
 SetCoors(r,c) Let you change the current row and col is the equivalent of
               SetPrc() of Ca-Clipper
 NewLine()     Increments the current row
 Write(cText)  Prints the string cText in the current row and column
 Say(nRow   ,; Prints the string cText in nRow, nCol
     nCol   ,; lAtoO indicates if the string should be transformed to Oem,
     cText  ,; by default is ::lAnsiToOem
     lAtoO )
 SayCmp()      The same as the method Say but prints in compressed mode and
               the row is updated accordly.

NOTE:

If you try to print on a row before the current one a EJECT will be
done automatically.

In the same way if you try to print on the same row as the current, but
in a previous column from the current one a EJECT will be done automatically

At the end of this class is a little function call WorkSheet that will make
the job of DOS printing a lot easier.

Enjoy it!


********************************************************************************
********************************************************************************

 La Clase desarrollada originalmente por Ignacio Ortiz me ha resultado útil por
 su sencillez y efectividad.

 El único punto debil de esta clase se encuentra cuando el usuario manda a imprimir
 y la impresora no está lista (sea cual sea la causa). Esto hace que FiveWin capture
 el error, saltando sobre cualquier manejador de error que el programador defina,
 y mostrando esa horrorosa ventana blanca que ya todos conocemos.
 Si el usuario resuelve el problema de la impresora (sigo hablando de cuando aparece
 la horrorosa ventana blanca), la impresión se realiza, pero a la final el programa
 termina explotando igual.

 Ahora les presento algunas modificaciones que le realizado a esta clase con la idea
 que la impresión se realice directamente en los puertos físicos de la impresora,
 emulando (en cierta forma) la función que realiza el ROM BIOS, y buscando evitar que
 el manejador de errores se adelante en situaciones como la que les comenté en el
 parrafo enterior.

 La idea es que hagan todas las pruebas posibles para pulirla, y dejarle abierta a Uds.
 la posibilidad de manejar los eventuales errores de acuerdo a la necesidad particular
 de cada quien.

 Este trabajo ES GRATIS!. Lo único que les pido es que no borren este comentario, ni la
 documentación anexa, ni los comentarios intercalados en los lugares donde se han realizado
 las modificaciones.

 En mi caso real, utilizo esta misma clase, pero la que ha sido modificada por el
 compañero Jose E. Serrano E. (JESE), quien le añadió algunas características más,
 pero manteniendo la misma estructura de la clase original de Ignacio.
 Cuando estas modificaciones funcionen sin inconvenientes, las transferiré a la clase
 modificada por JESE.

 Un Abrazo a todos,
 y que les sea útil

 Giancarlo J. Sabattino S.
 08 Julio 2001
 gsabattino@cantv.net


 Este trabajo se lo dedico a los compañeros Hernán D. Cecarrelli, José E. Serrano E. (JESE),
 Juan José Machado, y a Willy Quintana.


 NOTAS IMPORTANTES:

 Esta clase está orientada totalmente a impresoras matriciales, o impresoras que se comporten
 como impresores matriciales, por lo que su uso en cualquier otro tipo de impresora puede
 causar resultados indeseados.

 Esta clase trabaja directamente sobre los puertos PRN, LPT1 y LPT2 que existan físicamente en el
 equipo, por lo que no funcionará en ningún otro tipo de dispositivo. Para mantener compatibilidad,
 se puede pasar un nombre de archivo para grabar la impresión en disco tal como lo hace la clase
 original.

 En teoría, no debe ser activada si alguna aplicación Windows se encuentra haciendo uso de la
 misma impresora que se desea utilizar. Yo no he intentado utilizarla de esta forma, pero la
 lógica me dice que los resultados serán totalmente impredecibles.

 =================================================

 Nuevas Variables de Instancia:

    lLPT            .t. Indica si la impresión se está realizando sobre una salida de impresora
                    que existe físicamente.
    nLPTBase        Guarda la dirección base del puerto de impresora. Si no existe puerto físico
                    el valor será 0.
    lTimeOut        .t. indica que se ha excedido el tiempo de espera para que la impresora esté
                    en condiciones de imprimir.
    cLastError      Cadena que describe el ultimo error encontrado
    lCanceled       .t. Ha sico cancelado el proceso de impresión.

 Las variables que se nombran a continuación toman los valores directamente de las líneas de status
 del puerto de la impresora.

    lPrnBusy        .t. Indica que la impresora esta ocupada imprimiendo. No Admite el envío de
                    más caracteres mientras este indicador esté encendido.
    lDataAck        .t. La impresora ha recibido el caracter enviado
    lPaperOut       .t. La impresora no tiene papel
    lPrnSelect      .t. La impresora está en pausa (fuera de línea)
    lPrnError       .t. Ha ocurrido un error en la impresora (usualmente atascos de los componentes
                    mecñanicos)

 --------------------
 Añadidas el 25/Jul/2001:

    bError          CodeBlock: cuando se presente un error indefinido en la impresora
    bPaperOut       CodeBlock: cuando el impresor se quede sin papel
    bTimeOut        CodeBlock: cuando se exceda el tiempo de espera
    bPrnSelect      CodeBlock: cuando la impresora esté en pausa
    bCheck          CodeBlock: cualquier acción que el programador desee que se ejecute
                               en cada envío de datos hacia la impresora
   Estas nuevas variables permiten personalizar las acciones por cada uno de los casos
   indicados.

   --------------------

    aCompress       Comandos para activar/desactivar impresión a 17 CPI
    aPica           Comandos para activar/desactivar impresión a 12 CPI
    aDouble         Comandos para activar/desactivar impresión a  5 CPI
    aBold           Comandos para activar/desactivar impresión en Negrillas
    aItalic         Comandos para activar/desactivar impresión en Italicas

 <<--------- 25/Jul/2001

 Nuevos Métodos:

   Añadido el 25/Jul/2001:
    StartPage()                   Para compatibilidad con otras clases, en especial con la
                                  clase tPrinter. Invoca al método EndPage() si el buffer
                                  tiene datos pendientes por imprimir.
   <<--------- 25/Jul/2001

    Status()                      Este Método lee el puerto de las líneas de estado que
                                  vienen de la impresora, y vuelca el resultado en las
                                  variables de instancias ya indicadas.
                                  25/Jul/2001: atendiendo algunas sugerencias, se cambió
                                  el nombre anterior del Método ( :PrinStatus() ) por este.
                                  <<--------- 25/Jul/2001

    PrintBuffer( cString )        Este Método se utiliza en lugar de la función fWrite()
                                  cuando se trate de una salida directa hacia LPT o PRN.

    CharOut( cChar )              Este es el Método del cual depende PrintBuffer() para
                                  el envío de los caracteres a la impresora. En su
                                  encabezado se explica más detalladamente su funcionamiento.

   Añadido el 25/Jul/2001:
    ScanPorts()                   Hace una búsqueda de los puertos instalados en el equipo,
                                  y arma un arreglo con esos datos de manera que si existe
                                  la necesidad de tener más de una impresora conectadas en un
                                  mismo equipo, Uds. puedan ofrecer las distintas alternativas
                                  para impresión.
   <<--------- 25/Jul/2001

    tambien se han modificado los Métodos Init(), End(), Command(), NewLine(), y EndPage()
    En cada uno de esos métodos se encuentra el comentario que explica la modificación.

 Nueva Función de la Clase:

    lIsBit( nValor, nPosBit )     Es una función que indica que bits estan prendidos, o apagados,
                                  en un valor de 8 bits (0..255). Es el soporte principal de la
                                  función Status() ya que las líneas de estado de la impresora son
                                  tomados juntos, y el apoyo sobre esta función permite separarlos.

 =================================================

 A partir de esta primera revisión, la clase comienza a tener una identidad propia. Trataré, en la
 medida de lo posible, de mantener compatibilidad con la clase original de Ignacio.
 Las nuevas características añadidas a algunos métodos las explico a continuación:

 * Método Command(): Originalmente admitía solo un comando por vez. Ahora puede recibir varios
   comandos contenidos en un arreglo, siguiendo la misma sintaxis de la clase original. Ej.

   Antes:

       oPrn:Command( '27, 67, 33' )
       oPrn:Command( '27, 87, 49' )
       oPrn:Command( '27, 69' )

       o había quienes preferían hacerlo de esta forma:

       oPrn:Command( '27, 67, 33, 27, 87, 49, 27, 69' )

   Ahora, para quienes les gustaba usar el primer método, pueden hacerlo de la siguiente manera:

       oPrn:Command( { '27, 67, 33',;
                       '27, 87, 49',;
                       '27, 69' } )

   Añadido el 25/Jul/2001:

   Se pueden pasar comandos también en forma numérica:

       oPrn:Command( 15 )

   Si se van a pasar varios comandos, debe hacerse en forma de arreglo:

       oPrn:Command( { 27, 67, 33 } )             // Un solo comando

       oPrn:Command( { { 27, 67, 33 },;           // Varios comandos
                       { 27, 87, 49 },;
                       { 27, 69 } } )
   <<--------- 25/Jul/2001

 * Método End():  Permite pasar un comando como parte de la destrucción del objeto. El comando debe
   ser pasado siguiendo la misma sintanxis del método Command(). Esto resulta muy útil para quienes
   imprimen sobre formularios con longitud de papel diferente al tamaño Carta Americano (11 pulgadas),
   y necesitan restituir la longitud del papel a su tamaño original. Ej.

   oPrn:End( '27, 67, 33' )

   Cómo en método End() se apoya en el método Command(), entonces también se pueden enviar varios
   comandos de acuerdo a lo especificado en los casos ya descritos.

 =================================================
 Fallas corregidas:

 25/Jul/2001
 * Método :Init()         Admite los dos puntos como parte de la identificación del puerto ("LPT1:").
                          Se mantiene también la forma anterior sin los dos puntos ("LPT1").

 * Método :Command()      Imprimía los códigos en lugar de enviarlos a la Impresora.
 <<--------- 25/Jul/2001

 =================================================
 Cambios realizados:
 25/Jul/2001
 * Método :NewLine()      Envía datos a la Impresora en cada cambio de línea en lugar de hacerlo
                          al terminar de armar la página. Esto es con la intención de que Uds.
                          puedan monitorizar las variables de estado en cada línea que se
                          desea imprimir, y así mostrarle al usuario cualquier cosa que le
                          indique lo que está pasando con la impresora.

 * Método :Write()        Fué reescrito completamente para añadir algunas características nuevas:
                          Write( cText, nStyle, nPad, lAToO ).
                          Ahora admite 2 nuevos parámetros, con los cuales logramos los siguientes
                          resultados:
                          aStyle: Valor entre 1 y 5, o un arreglo con valores en el mismo rango.
                                  Esto permite cambiar los estilos de letras durante la impresión.
                                  1 -> Imprimir a 17 CPI ( Comprimido )
                                  2 -> Imprimir a 12 CPI ( Pica )
                                  3 -> Imprimir a  5 CPI ( Doble Ancho )
                                  4 -> Imprimir en Negrillas
                                  5 -> Imprimir en Italico
                                  Es importante tener en cuenta que se utilizan características que
                                  son nativas de las impresoras matriciales, y por lo tanto, depen-
                                  diendo de la marca y modelo, habrán características que no pueden
                                  ser combinadas (Ej: 17 CPI+Negrillas)
                          nPad  : Valor entre 1 y 3: Alineación con respecto a la columna :nCol.
                                  0 -> Izquierda ( por defecto )
                                  1 -> Derecha
                                  2 -> Centrada
                          Estas nuevas características hacen necesario tener que calcular la distancia
                          utilizada durante la impresión de una línea, de manera que las coordenadas
                          pasadas al método :Say() sean siempre reales.
                          Esto se basa en que, además de la fuente estandard de 10 CPI, se pueden utilizar
                          fuentes de 5, 12, y 17 CPI (pre-definidas en las nuevas variables de instancia
                          creadas para ello), las cuales afectarían las posiciones de impresión si no son
                          calculados los avances de manera adecuada a cada tamaño. La idea es minimizar el
                          uso del método :Command() y a la vez llevar el control de la columna en la
                          que se imprimirá un dato.
                          Otra cosa con este método es que se buscó cierta similitud sintáctica con los
                          Métodos :InchSay y CmSay de la clase tPrinter
 <<--------- 25/Jul/2001

********************************************************************************
********************************************************************************

*/

#include "FiveWin.Ch"

//----------------------------------------------------------------------------//

CLASS TDosPrn

    ClassData aPorts    INIT      {}              // Puertos Presentes

    DATA      cPort     ,;
              cLastError,;                        // G. Sabattino S.
              cCompress ,;
              cNormal   ,;
              cFormFeed ,;
              cBuffer             AS STRING

    DATA      nPos      ,;                        // G. Sabattino S. --> 25/Jul/2001
              hDC       ,;
              LastError ,;
              nLPTBase  ,;                        // G. Sabattino S.
              nRow      ,;
              nCol      ,;
              nLeftMargin,;
              nTopMargin          AS NUMERIC

    DATA      lAnsiToOem,;
              lLPT      ,;                        // G. Sabattino S.
              lPrnBusy  ,;                        // G. Sabattino S.
              lDataAck  ,;                        // G. Sabattino S.
              lTimeOut  ,;                        // G. Sabattino S.
              lPaperOut ,;                        // G. Sabattino S.
              lPrnSelect,;                        // G. Sabattino S.
              lPrnError ,;                        // G. Sabattino S.
              lCanceled           AS LOGICAL      // G. Sabattino S.

    // Añadido 25/Jul/2001:
    // Codeblocks por defecto para...
    DATA      bError      INIT { || MsgInfo( 'Error en la Impresora !!!', 'Atención' ),;
                                    .f. }
    DATA      bPaperOut   INIT { || MsgYesNo( 'Impresora sin Papel !!!'+CRLF+'Continúa Impresión?', 'Atención' ) }
    DATA      bTimeOut    INIT { || MsgYesNo( 'Tiempo de espera Excedido !!!'+CRLF+'Continúa Impresión?', 'Atención' ) }
    DATA      bCheck      INIT { || NIL }
    DATA      bPrnSelect  INIT { || MsgYesNo( 'Impresora En Pausa !!!'+CRLF+'Continúa Impresión?', 'Atención' ) }

    // Comandos para impresores Epson, y compatibles
    // 1er elemento del arreglo: Activa el estilo
    // 2do elemento del arreglo: Desactiva el estilo
    // 3er elemento del arreglo: Pitch. 0=No afecta el Pitch Actual
    DATA      aCompress INIT      { { 15 },;                    // Chr( 15 )
                                    { 18 },;                    // Chr( 18 )
                                    17 }                        // 17 CPI
    DATA      aPica     INIT      { { 27, 77 },;                // Chr( 27 )+'M'
                                    { 27, 80 },;                // Chr( 27 )+'P'
                                    12 }                        // 12 CPI
    DATA      aDouble   INIT      { { 27, 87, 49 },;            // Chr( 27 )+'W1'
                                    { 27, 87, 48 },;            // Chr( 27 )+'W0'
                                    5 }                         // 5 CPI
    DATA      aBold     INIT      { { 27, 69 },;                // Chr( 27 )+'E'
                                    { 27, 70 },;                // Chr( 27 )+'F'
                                    0 }                         // No Cambia Pitch
    DATA      aItalic   INIT      { { 27, 52 },;                // Chr( 27 )+'4'
                                    { 27, 53 },;                // Chr( 27 )+'5'
                                    0 }                         // No Cambia Pitch
    // <<--------- 25/Jul/2001

    // Añadido 25/Jul/2001:
    Method  ScanPorts()
    // <<--------- 25/Jul/2001

    METHOD  New( cPort ) CONSTRUCTOR

    METHOD  End( aCommands )

    // Añadido 25/Jul/2001:
    METHOD  StartPage()  INLINE         iif(  .not. empty( ::cBuffer ),;
                                              ::EndPage(),   ;
                                              NIL )
    // <<--------- 25/Jul/2001

    METHOD  EndPage()

    METHOD  Command( aCommands )

    METHOD  SetCoors( nRow, nCol )

    METHOD  NewLine()

    METHOD  Write( cText, nStyle, nPad, lAToO )

    METHOD  Say( nRow, nCol, xText, nStyle, nPad, lAToO )

    METHOD  SayCmp( nRow, nCol, cText )

    // ---------------------------------------------------------
    // Nuevos Métodos - G. Sabattino S.
    // 08/Jul/2001

    Method  PrintBuffer()

    Method  CharOut( cChar )

    Method  Status()

ENDCLASS

********************************************************************************
//----------------------------------------------------------------------------//
// Este metodo se encarga de buscar los puertos que se encuentren instalados
// en el equipo.
// 3BCh  Puerto Paralelo { 956, 'LPTx:'  }
// 378h  Puerto Paralelo { 888, 'LPTx:'  }
// 278h  Puerto Paralelo { 632, 'LPTx:'  }
// Tal como lo hace el BIOS, los puertos toman las asignaciones LPT1, LPT2, o LPT3
// de acuerdo al orden en que son encontrados en el equipo siguiendo secuencia de
// busqueda: 3BCh, 378h, 278h
// El puerto 3BCh fué asignado inicialmente a los puertos integrados en las antígüas
// tarjetas monocromáticas. Luego fué dezplazado por los puertos 378h y 278h, pero
// los BIOS todavía le asignan el primer lugar en la secuencia de identificación.
//
// Añadido el 25/Jul/2001
//
Method ScanPorts() CLASS TDosPrn
local     nPtr      ,;
          aPorts    :={ 'LPT1:', 'LPT2:', 'LPT3:' },;
          bPresent  :={ | nAddress |  OutPortByte( nAddress, 170 ),;
                                      InPortByte( nAddress )==170 }

if len( ::aPorts )=0
  ::LastError :=0
  ::cLastError:=''
  iif( eval( bPresent, 956 ),;            // Puerto Paralelo 3BCh
      aAdd( ::aPorts, { '', 956, .f. } ),;
      NIL )
  iif( eval( bPresent, 888 ),;            // Puerto Paralelo 378h
      aAdd( ::aPorts, { '', 888, .f. } ),;
      NIL )
  iif( eval( bPresent, 632 ),;            // Puerto Paralelo 278h
      aAdd( ::aPorts, { '', 632, .f. } ),;
      NIL )

  if len( ::aPorts )>0
    for nPtr:=1 to len( ::aPorts )
      ::aPorts[ nPtr, 1 ]:=aPorts[ nPtr ]
    next
  else
    ::LastError :=-1
    ::cLastError:='No hay puertos físicos instalados en este equipo'
  endif
endif
return ::aPorts

********************************************************************************
//----------------------------------------------------------------------------//
METHOD New( cPort, lFile ) CLASS TDosPrn
local     aPorts    :={ 'PRN', 'LPT1', 'LPT2', 'LPT3' },;
          aInitPrn  :={ ::aCompress[ 2 ],;
                        ::aPica[ 2 ],;
                        ::aDouble[ 2 ],;
                        ::aBold[ 2 ],;
                        ::aItalic[ 2 ] },;
          nPos

DEFAULT   cPort     := "LPT1:" ,;
          lFile     := .T.

cPort         :=Upper( alltrim( cPort ) )
::cBuffer     :=""
::nLeftMargin :=0
::nTopMargin  :=0
::nRow        :=0
::nCol        :=0
::lAnsiToOem  :=.T.
::LastError   :=0

// ---------------------------------------------------------
// Comienza Modificaci¢n - G. Sabattino S.
//
::lLpt        :=.f.
::cLastError  :=''
::lCanceled   :=.f.
::nLPTBase    :=0
::cCompress   :='15'
::cNormal     :='18'
::cFormFeed   :='12'
::ScanPorts()

// Se valida que el puerto que se desea utilizar corresponde a LPT1: (PRN:), LPT2, o LPT3.
cPort   :=Upper( alltrim( cPort ) )
nPos    :=aScan( aPorts, { | caPort | caPort==cPort } )
cPort   :=cPort+iif( nPos>0, ':', '' )
cPort   :=iif( cPort=='PRN:', 'LPT1:', cPort )
::nPos  :=aScan( ::aPorts, { | aPort | aPort[ 1 ]==cPort } )
::cPort :=cPort

if ::nPos=0
  // La salida se está dirigiendo hacia un archivo en disco o hacia algún otro dispositivo
  // distinto a LPT
  ::hDC   := fCreate( ::cPort )
  IF ::hDC < 0
    ::LastError :=fError()
    ::cLastError:='Error en "'+::cPort+'": '+alltrim( str( ::LastError, 4 ) )
  else
    ::Command( aInitPrn )
  endif
else
  if .not. ::aPorts[ ::nPos, 3 ]
    // se verifica que no se encuentre abierto
    ::nLPTBase            :=::aPorts[ ::nPos, 2 ]
    ::aPorts[ ::nPos, 3 ] :=.t.
    ::lLPT                :=.t.
    ::Command( aInitPrn )
  else
    // El puerto está siendo utilizado.
    // Evite su uso e indique el error
    ::LastError :=-1
    ::cLastError:='Error en "'+::cPort+'": Ya está en uso'
  endif
endif

// Termina Modificaci¢n - G. Sabattino S.
// ---------------------------------------------------------

RETURN NIL


********************************************************************************
//----------------------------------------------------------------------------//

METHOD End( aCommands ) CLASS TDosPrn
local     nCommand

::LastError := 0

IF !empty( ::nRow+::nCol )
  ::EndPage()
ENDIF

// ---------------------------------------------------------
// Comienza Modificaci¢n - G. Sabattino S.
if ( aCommands#NIL )
  // La Clase ahora permite enviar comandos a la impresora
  // en el momento de destruir a oPrn
  ::Command( aCommands )
endif
::LastError :=iif(  ::lLPT,;
                    ::PrintBuffer( ::cBuffer ),;
                    iif( fWrite( ::hDC, ::cBuffer )<Len( ::cBuffer ), fError(), 0 ) )

IF ( .not. ::lLPT ) .and. !fClose( ::hDC )
  // La detección de error se hace solo si el dispositivo era distindo a LPT/PRN
  ::LastError := fError()
  ::cLastError:='Error en "'+::cPort+'": '+alltrim( str( ::LastError, 4 ) )
ENDIF

::aPorts[ ::nPos, 3 ] :=.f.

// Termina Modificaci¢n - G. Sabattino S.
// ---------------------------------------------------------

RETURN NIL

//----------------------------------------------------------------------------//

METHOD EndPage() CLASS TDosPrn

::Command( ::cFormFeed )

// ---------------------------------------------------------
// Comienza Modificaci¢n - G. Sabattino S.
::LastError:=iif( ::lLPT,;
                  ::PrintBuffer( ::cBuffer ),;
                  iif( fWrite( ::hDC, ::cBuffer )<Len( ::cBuffer ), fError(), 0 ) )
// Termina Modificaci¢n - G. Sabattino S.
// ---------------------------------------------------------

::cBuffer := ""
::nRow    := 0
::nCol    := 0

RETURN NIL

//----------------------------------------------------------------------------//

METHOD Command( aCommands ) CLASS TDosPrn
LOCAL     nPtr      ,;
          cCommand  ,;
          nPos      ,;
          cCtrl     ,;
          aCtrlChar

// ---------------------------------------------------------
// Comienza Modificaci¢n - G. Sabattino S.
// Se admiten comandos organizados en un arreglo.
// Si se pasa un comando bajo el esquema de la clase original, este es
// convertido en arreglo antes de colocarse en el buffer.
if ( Valtype( aCommands )$'CA' )

  if valtype( aCommands )#'A'
    aCommands:={ aCommands }
  endif

  for nPtr:=1 to len( aCommands )
    do case
      // Se normalizan los comandos de impresora
      // convirtiendolos a un arreglo numérico

      case ValType( aCommands[ nPtr ] )='C'
        // Si estan pasando como cadenas de caracteres
        // se toman los valores numéricos y se organizan
        // en un arreglo temporal
        cCommand  :=aCommands[ nPtr ]
        aCtrlChar :={}
        Do While !Empty( cCommand )
          nPos  :=at( ',', cCommand )
          if nPos>0
            cCtrl   :=substr( cCommand, 1, nPos-1 )
            cCommand:=substr( cCommand, nPos+1 )
          else
            cCtrl   :=cCommand
            cCommand:=''
          endif
          aAdd( aCtrlChar, val( alltrim( cCtrl ) ) )
        EndDo

      case ValType( aCommands[ nPtr ] )='N'
        // Si esta pasando como número, solo se copia
        // en el arreglo temporal
        aCtrlChar :={ aCommands[ nPtr ] }

      case ValType( aCommands[ nPtr ] )='A'
        // Si esta pasando como arreglo ( se asume venga como
        // numérico ), se copia al arreglo temporal
        aCtrlChar :=aCommands[ nPtr ]

      otherwise
        // cualquier otro tipo es ignorado
        aCtrlChar :={}
    endcase

    for nPos:=1 to len( aCtrlChar )
      ::cBuffer :=::cBuffer+;
                  iif( valtype( aCtrlChar[ nPos ] )='N', chr( aCtrlChar[ nPos ] ), '' )
    next
  next

endif
// Termina Modificaci¢n - G. Sabattino S.
// ---------------------------------------------------------

RETURN NIL

//----------------------------------------------------------------------------//

METHOD SetCoors( nRow, nCol ) CLASS TDosPrn

nRow +=::nTopMargin
nCol +=::nLeftMargin

IF ::nRow > nRow
  ::EndPage()
ENDIF

IF nRow == ::nRow  .AND. nCol < ::nCol
  ::Write( Chr( 13 ) )
  ::nCol:=0
ENDIF

DO WHILE ::nRow < nRow
  ::NewLine()
ENDDO

IF nCol > ::nCol
  ::Write( Space( nCol-::nCol ) )
ENDIF

RETURN NIL

//----------------------------------------------------------------------------//

METHOD NewLine() CLASS TDosPrn

// ---------------------------------------------------------
// Comienza Modificaci¢n - G. Sabattino S.
::cBuffer+= CRLF
::LastError:=iif( ::lLPT,;
                  ::PrintBuffer( ::cBuffer ),;
                  iif( fWrite( ::hDC, ::cBuffer )<Len( ::cBuffer ), fError(), 0 ) )
::cBuffer := ""
// Termina Modificaci¢n - G. Sabattino S.
// ---------------------------------------------------------

::nRow++
::nCol:= 0
RETURN nil

//----------------------------------------------------------------------------//
// Este método fué reescrito completamente.
// Se le imcorpora la capacidad de calcular la distancia utilizada durante la
// impresión de una línea, de manera que las coordenadas pasadas al método :Say()
// sean siempre reales.
// Esto se basa en que, además de la fuente estandard de 10 CPI,  se pueden utilizar
// fuentes de 5, 12, y 17 CPI, las cuales afectarían las posiciones de impresión
// si no son calculados los avances de manera adecuada a cada tamaño.
METHOD Write( cText, aStyle, nPad, lAToO ) CLASS TDosPrn
local     nPitch    :=1,;
          nPtr      ,;
          aStyles   :={ ::aCompress,;
                        ::aPica,;
                        ::aDouble,;
                        ::aBold,;
                        ::aItalic },;
          nStyle    ,;
          aWrite    :={ { || ::cBuffer += iif( lAtoO, AnsitoOem( cText ), cText ),;
                             ::nCol    += ( len( cText )*nPitch ) },;
                        { || ::cBuffer += Replicate( Chr( 8 ), len( cText )-1 )+;
                                          iif( lAtoO, AnsitoOem( cText ), cText ) },;
                        { || ::cBuffer += Replicate( Chr( 8 ), Int( len( cText )/2 ) )+;
                                          iif( lAtoO, AnsitoOem( cText ), cText ),;
                             ::nCol    += int( len( cText )/2 )*nPitch } }

aStyle:=iif( aStyle=NIL, {}, aStyle )
aStyle:=iif( ValType( aStyle )#'A', { aStyle }, aStyle )
if len( aStyle )>0
  // Activa la fuente de impresora que se desea utilizar,
  // y calcula el avance por cada caracter
  for nPtr:=1 to len( aStyle )
    nStyle:=aStyle[ nPtr ]
    ::Command( aStyles[ nStyle, 1 ] )
    nPitch:=iif(  aStyles[ nStyle, 3 ]#0,;
                  Round( nPitch/aStyles[ nStyle, 3 ], 12 )*10,;
                  nPitch )
  next
endif
nPad  :=iif( nPad=NIL, 0, nPad )
nPad  :=iif( nPad>2,   0, nPad )
++nPad
lAToO :=iif( lAToO=NIL, ::lAnsiToOem, lAToO )
eval( aWrite[ nPad ] )
if len( aStyle )>0
  // Desactiva los estilos
  for nPtr:=1 to len( aStyle )
    ::Command( aStyles[ aStyle[ nPtr ], 2 ] )
  next
  if nPitch%1#0
    // Si el avance por caracter # 1/10 o 2/10, avanza al la columna siguiente
    ::nCol:=( Int( ::nCol )+1 )
    ::cBuffer += Chr( 13 )+;
                 space( ::nCol )
  endif
endif

RETURN nil

//----------------------------------------------------------------------------//

METHOD Say( nRow, nCol, xText, nStyle, nPad, lAToO ) CLASS TDosPrn
local     cText     :=xText

do case
  case Valtype( xText )='D'
    cText:=DtoC( xText )
  case Valtype( xText )='N'
    cText:=Str( xText )
  case Valtype( xText )='L'
    cText:=iif( xText, 'T', 'F' )
endcase

::SetCoors( nRow, nCol )
::Write( cText, nStyle, nPad, lAToO )

RETURN NIL

//----------------------------------------------------------------------------//

METHOD SayCmp( nRow, nCol, cText, lAToO ) CLASS TDosPrn

DEFAULT lAToO := ::lAnsiToOem

::SetCoors( nRow, nCol )
::Command( ::cCompress )
::cBuffer += iif( lAToO, AnsitoOem(cText), cText )
::nCol    += Int( len( cText )/1.7+.5 )
::Command( ::cNormal )

RETURN NIL


********************************************************************************
********************************************************************************
// Metodos y Funciones Añadidas a la clase

// -----------------------------------------------
// Este Metodo se encarga de enviar a la Impresora lo que haya sido colocado
// en cBuffer
// G. Sabattino S. 08/Jul/2001
Method PrintBuffer( cBuffer ) CLASS TDosPrn
local     nChar     :=1,;
          nPrinted  :=0

do while ( .not. ::lCanceled ) .and. ( nChar<=len( cBuffer ) )
  ::CharOut( substr( cBuffer, nChar, 1 ) )
  iif( .not. ::lCanceled, ++nPrinted, NIL )
  ++nChar
enddo

return nPrinted


// -----------------------------------------------
// Este metodo se encarga de enviar a la Impresora un caracter en forma de byte.
// Durante el proceso se verifica el status de la impresora y le envia los
// correspondientes mensajes al operador
// G. Sabattino S. 08/Jul/2001
Method CharOut( cChar ) CLASS TDosPrn
local     nChar     :=Asc( cChar ),;
          nTimeOut  :=30,;              // Epera 3 segundos antes de indicar error
          lPrint    :=.t.,;
          lError    ,;
          bStatus   :={ || ::Status(),;
                           ( .not. ::lPrnSelect ) .or. ( ::lPaperOut ) },;
          bError    :={ | lError, nCodigo, cDescripc |;
                          iif( lError,;
                              ( ::LastError :=nCodigo,;
                                ::cLastError:=cDescripc,;
                                ::lCanceled :=.t.,;
                                ::nLPTBase  :=0,;
                                lError ),;
                              NIL ) },;
          nPtr

if ( .not. ::lCanceled ) .and. ( ::nLPTBase>0 )

  OutPortByte( ::nLPTBase, nChar )     // Coloca caracter en el Puerto

  // -----------------------------------
  // Este segmento toma el status del puerto de la Impresora,
  // y de ser necesario avisa al usuario y espera por su
  // accion.
  lError:=eval( bStatus )
  eval( ::bCheck )
  do while lPrint .and. ( lError )
    Do case
      case ::lPaperOut
        lPrint:=eval( ::bPaperOut )
        eval( bError, .not. lPrint, -2, 'Error en "'+::cPort+'": Impresora sin Papel' )
      case .not. ::lPrnSelect
        lPrint:=eval( ::bPrnSelect )
        eval( bError, .not. lPrint, -3, 'Error en "'+::cPort+'": Impresion interrumpida' )
      case ::lPrnError
        lPrint:=eval( ::bPrnError )
        eval( bError, .not. lPrint, -1, 'Error en "'+::cPort+'": Impresion interrumpida' )
    endcase
    lError:=eval( bStatus )
  enddo

  if lPrint

    // Si no ha habido error en la impresora,
    // entonces se verifica que el buffer de la impresora
    // tenga espacio para recibir el caracter que se
    // necesita imprimir.
    ::Status()
    lError      :=::lPrnError
    ::lTimeOut  :=.f.
    do while ( .not. lError ) .and. ::lPrnBusy              // Espere que la impresora se desocupe
      Inkey( 0.1 )
      ::Status()
      --nTimeOut
      ::lTimeOut:=( nTimeOut=0 )
      lError  :=::lPrnError .or. ::lTimeOut
    enddo

    if .not. lError
      // El buffer tiene espacio para recibir el caracter,
      // envíe un pulso a la se#al de Strobe para indicarle a la
      // impresora que tome el caracter
      OutPortByte( ::nLPTBase+2, 13 )                       // Encienda se#al Strobe ( 1101b )
      for nPtr:=1 to 25                                     // Espere a estabilizar Strobe
      next
      OutPortByte( ::nLPTBase+2, 12 )                       // Apague se#al Strobe ( 1100b )
      ::lTimeOut:=( nTimeOut=0 )
    endif

    if ::lTimeOut
      ::lTimeOut:=.not. eval( ::bTimeOut )
      if ::lTimeOut
        eval( bError, ::lTimeOut, -5, 'Error en "'+::cPort+'": Exedido Tiempo de Espera por Impresora' )
      endif
    endif

  endif
endif
return NIL


// -----------------------------------------------
// Este metodo se encarga de revisar la condición de la Impresora, y coloca las
// variables de instancia de acuerdo al resultado obtenido.
// G. Sabattino S. 08/Jul/2001
Method Status( nLPTBase ) CLASS TDosPrn
local     nStatus

nLPTBase:=iif( nLPTBase=NIL, ::nLPTBase, nLPTBase )
if nLPTBase>0
  nStatus     :=InPortByte( nLPTBase+1 )
  ::lPrnError :=.not. lIsBit( nStatus, 4 )
  ::lPrnSelect:=lIsBit( nStatus, 5 )
  ::lPaperOut :=lIsBit( nStatus, 6 )
  ::lDataAck  :=.not. lIsBit( nStatus, 7 )
  ::lPrnBusy  :=.not. lIsBit( nStatus, 8 )
endif
return NIL


// -----------------------------------------------
// Esta funcion se encarga de descomponer un byte en sus
// bits para luego devolver .t. si el bit nPosBit esta en 1
// nPosBit debe estar en el rango desde 1 hasta 8
// G. Sabattino S. 08/Jul/2001
static function lIsBit( nValor, nPosBit )
local     aBits     :={ 1, 2, 4, 8, 16, 32, 64, 128 },;
          nBit      ,;
          lBit      :=.f.

if ( nPosBit>=1 ) .and. ( nPosBit<=len( aBits ) )
  for nBit:=len( aBits ) to 1 step -1
    iif( nValor>=aBits[ nBit ],;
         nValor:=nValor-aBits[ nBit ],;
         aBits[ nBit ]:=0 )
  next
  lBit:=( aBits[ nPosBit ]>0 )
endif
return lBit

// Termina Modificaci¢n - G. Sabattino S.
//----------------------------------------------------------------------------//


//----------------------------------------------------------------------------//

FUNCTION WorkSheet( cPort )

LOCAL     oPrn      :=TDosPrn():New( cPort ),;
          cLine     :="",;
          nFor

FOR nFor := 0 TO 7
  cLine += Str( nFor, 1 )+Replicate( ".", 9 )
NEXT

cLine := Substr( cLine, 3 )

FOR nFor := 0 TO 65
  oPrn:Say( nFor, 0, StrZero( nFor, 2 )+cLine )
NEXT

oPrn:EndPage()
oPrn:End()

RETURN NIL