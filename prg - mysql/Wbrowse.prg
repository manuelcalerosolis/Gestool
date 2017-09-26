// Modificaciones y Agregados a la TWBrowse version FW2.1
// ======================================================
// 1) Nueva varialble ::bLogicPos. Sirve para el Scroll Vertical en DBf. Si
//    devuelve nil, se usa el calculo por defecto. Si devuelve un valor
//    numerico especifica la posicion relativa respecto al total de registros.
// 2) Todos los movimientos del oVScroll, se controlan con ::bLogicPos si
//    estuviera definida.
// 3) Para DBFs se define por defecto a ::bLogicLen y a ::bLogicPos, al
//    tratarse de Drivers DBFCDX de Clip53, COMIX y DBFCDXAX de ADS Advantage
//    DataBase Server.
// 4) Nuevas variables ::lAdjLastCol y ::lAdjBrowse. La primera contiene un
//    valor logico que indica si se quiere estirar la ultima columna al
//    tama¤o del control. Por defecto es .T., es lo que hace FW originalmente.
//    La segunda variable indica si se quiere ajustar el browse hasta el final
//    del control, osea, cuando se ha seleccionado la modalidad ultima columna
//    no ajustada, es decir, ::lAdjLastCol:= .F., si asume .T. se pintar  una
//    una columna ficticia vac¡a.
//    ....y recordar que sobre gustos, no hay nada escrito !!!!
// 5) BUG Arrglado en los metodos ::GoRight() y ::GoLeft(). Cuando no
//    exist¡an elementos en el browse, y siendo lCellStyle:= .t., mostraba
//    una celda seleccionada si se presionaban las teclas de movimiento. Ha sido
//    solucionado.
// 6) Nueva varaible ::aHJustify. Funciona igual que ::aJustify, es decir, un
//    array cuyos elementos asumen valores, que idicaran a la clase la
//    justificacion de la columna para Cabeceras (Headers). En caso de no
//    definirse, o enviarse menor cantidad de elementos, se toma por defecto
//    los valores de ::aJustify. Valores que puede asumir cada elemento del
//    Array, (tambien aplicable a ::aJustify) :
//    a) .F. o 0  -> Indica justificado a la derecha
//    b) .T. o 1  -> Indica justificado a la izquierda
//    c)       2  -> Indica justificado al centro.
// 7) Nueva variable ::lDrawHeaders, permite manejar la visualizacion de las
//    cabeceras. Por defecto es .T., un valor .F. indicar  la no visualizacion.
// 8) BUG Arreglado en metodo ::LButtonDown(). Si con el Mouse se accedia a
//    una celda visualizada parcialmente, estando en modalidad lCellStyle:= .t.,
//    TWbrowse no se reacomodaba, para su visualizacion completa. Fue corregido.
// 9) BUG Arreglado en metodo ::iscolvisible(). Fue reescrita y simplificada.
//    Eventuales errores se producian en ambientes MDI por errores en el codigo.
//10) Nuevas variables ::bTextColor y ::bBkColor. Son bloques de codigo que
//    se eval£an en tiempo de pintado. Pueden devolver una valor NUMERICO,
//    que representa el color RGB con el cual se pintar  el texto o fondo,
//    segun el bloque. Si devuelve otro valor, los colores ser n los especi-
//    ficados en las respectivas varialbes de instancia de la clase.
//    Se env¡an 3 argumentos: {|nRow,nCol,nStyleLine| ... }
//    nStyleLine, puede asumir los siguientes valores:
//              0 -> Celda standard normal
//              1 -> Celda Header
//              2 -> Celda Footer
//              3 -> Celda standard normal seleccionada
//    Ver Pto. 41)
//11) Nueva variable ::nClrLine. Especifica un color especifico para las lineas
//    separadoras de celdas. Por defecto se utilizan los colores de linea
//    especificos, segun el valor de ::nLineSyle. (Jose Gimenez)
//12) Nuevos Metodos ::DrawHeaders( nColPressed ) y ::DrawFooters( nColPressed ).
//    Estos metodos son usados internamente por la clase para el pintado de
//    cabeceras y pies del grid. Puede recibir como parametro el numero de
//    columna, la cual quiere que se pinte con efecto PUSH, osea presionada.
//13) Nuevas Variables:
//      ::lDrawFooters -> Especifica si se quiere pintar los Footers o no.
//                    Por defecto es .F.
//      ::aFooters -> Array o Bloque de Codigo que devuelva un Array, de
//                    cadenas o numeros (Bmp), que se pintaran el el borde
//                    inferior del browse.
//      ::aFJustify -> Cumple la misma funcion que aJustify, pero para Footers.
//                    En caso de no especificarse se toman por defecto, los
//                    valores de aJustify.
//      ::nClrFFore y ::nClrFBack -> Color RGB de texto y fondo respectiva-
//                    mente de los (Pies) Footers. Son analogas a las
//                    variables ::nClrForeHead y ::nClrBackHead, usadas en
//                    las Cabeceras (Headers).
//14) BUG Arreglado en metodo ::LDblClick(). No se procesaba el bloque
//    ::bDblClick definido por el usuario.
//15) Nuevos metodos ::GetColHeader() y ::GetColFooter(). A ellos deben
//    pasarse los siguientes par metros ( nMRow, nMCol ), es decir,
//    coordenadas de Mouse nRow y nCol. Si me retorta valor > 0 indica que
//    se presiono sobre el Header o Footer, representando ese valor la columan
//    en la que se hizo el click. Es util para procesar dentro de ::bLDblClick y
//    ::bLCkicked.
//    Analogamente, si se quiere saber la posicion de celda, en la cual se
//    ha presionado el Mouse, puede usarse el metodo ::nWRow( nMRow ).
//16) Nuevo metodo ::bGoLogicPos. Bloque que se ejecuta cuando se quiere ir a
//    un registro especifico de la tabla. Por defecto se define para RDD
//    DBFCDX de Clip53, COMIX y DBFCDXAX de ADS Advantage DataBase Server.
//17) Nuevas variables ::nClrNFFore y ::nClrNFBack. NF (no focus). Indican
//    el color RGB de Texto y Fondo respectivamente de la(s) Celda(s)
//    seleccionada(s) cuando NO HAY FOCO sobre el control. Ambas son analogas
//    a las variables ::nClrForeFocus y ::nClrBackFocus.
//    Resumiendo Color(es) de Celda(s) Seleccionada(s):
//    +-------------------------+--------------+-----------------+
//    | Color celda seleccionada|   CON FOCO   |     SIN FOCO    |
//    +-------------------------+--------------+-----------------+
//    | Colores de Texto (Fore) | ::nClrNFFore | ::nClrForeFocus |
//    | Colores de Fondo (Back) | ::nClrNFBack | ::nClrBackFocus |
//    +-------------------------+--------------+-----------------+
//18) Modificacion al metodo ::GoRight(), en caso de que no exista Barra Scroll
//    Horizontal y no exita modalidad ::lCellStyle:= .F., y, ademas, las
//    columnas sean perfectamente visualizadas en el area del control, no se
//    corr¡a hacia la derecha. Arreglado.
//19) Modificacion de Colores: Se arreglaron algunos colores por defecto, que
//    se tomen los definidos en Windows.
//20) Se corrigio el metodo para determinar el ancho de los Scrolles verticales
//    Se usa para ello el GetSysMetrics( SM_CXSCROLL ) y no mas 16 fijo.
//21) Nuevas variables "DE CLASE": ::lVScroll y ::lHScroll. Las mismas fijan
//    si debe o no crearse los scrolles respectivos cuando se genera el
//    control "desde codigo". Por defecto simpre se crean. PERO OJO: Se crearon
//    de clase, porque no era posible crearlas de otra forma, debido a que
//    el encargado de definir el nStyle es el contructor New(). Para no
//    modificar los comandos xBase, se opto por esta solucion. Por eso deben
//    setearse ANTES de definir el control.
//       Ejemplo:  TWBrowse():lHScroll:= .f.
//                 @y,x LISTBOX ......
//    Pero OJO, el valor .F. no queda para todos los controles que sean creados
//    posteriori, sino, la clase se encarg  de volver a .T. a ::lHScroll.
//22) Los metodos ::DrawHeader() y ::DrawFooters() soportan como argumento el
//    Nro.de columna que queremos que apresca presionada.
//    Ver Pto.12)
//23) Nueva variable ::nFreeze. Indica el numero de columnas que deber n
//    congelarse a la izquierda. Funciona igual que la variable de instancia
//    TBrowse:Freeze de CA-Clipper. Por defecto asume 0. Para ello han sido
//    redefinidos TOTALMENTE y optimizados los metodos ::GoRight() y
//    ::GoLeft(), y ademas se modific¢ ::HScroll() tambien. ::lButtonUp() y
//    ::lButtonDown(), y ::VertLine() devuelve la columna que se ha modificado.
//24) Nuevo metodo GoToCol( <nCol> ). Este desplaza a una determinada columna
//    y hace el ajuste del browse que corresponda.
//25) Adios y Chau al parpadeo.... La funcion WBrwPane() se encarga de pintar
//    las zonas excedetes, es decir, no cobiertas por las celdas, con el color
//    de fondo del control, por supuesto. Se evita el borrado del control, en
//    el metodo ::Refresh().
//26) Los metodos ::lEditCol y ::EditCol, editan con el color de fondo que
//    tenga la celda en curso, aun cuando tenga color de columna personalizado.
//27) Se modifico el metodo ::Edit() y se agrego la funcion __Edit(),
//    para evitar el parpadeo, cuando pasamos de celda en celda, debido a la
//    modalidad MODAL que tienen los dialogos. Para ello se crea un dialogo
//    oculto y se evita es parpadeo antiest‚tico.
//28) El metodo ::Refresh() ha sido redefinido, y estabiliza automaticamente
//    despues de un ABM, ademas refresca automaticamente los Footers en caso
//    de que hay sido definido como Bloque de Codigo.
//---15/11/2000---
//29) Se incorpor¢ el metodo ::SetPage() en los objetos Scroll, para ver
//    proporcionales los ThumbPos de los mismos. NOTA: La clase Scroll tiene
//    este metodo, pero por razones desconocidas esta comentado. Debe borrarse
//    el comentario e incorporar la clase Scroll.c modificada por Jose Gimenez.
//30) En bloques ::bLogicPos y ::bLogicLen se incorporo la posibilidad de que
//    NO haya un alias, osea asignarlo como "", para que no se desplace el
//    browse durante un proceso determinado.
//31) Se modifico ::LostFocus() y ::GotFocus(). En ambientes MDI, en las
//    clausulas VALID, generalmente, se usan para cerrar las bases de datos
//    asociadas al MDICHILD. Ocurria que el metodo ::LostFocus() y en ocasiones
//    ::GotFocus(), se ejecutaban POSTERIORMENTE al VALID del la MDI, lo cual,
//    estando las bases ya cerradas, y llamandose en consecuencia a DrawSelect()
//    osea, hacian uso del (::cAlias)->, se produc¡a un RunTimeError, dado
//    que el alias no exitia.
//    Se soluciono agregando una funcion EmtpyAlias() que verfica si el area
//    de trabajo esta activa. Ya no sera necesesario, incorporar en los VALIDs
//    de las MDI, cosas como oLbx:Destroy() o "artilugios" similares !!!!
//32) Nueva variable ::bEdit, que es un bloque de codigo que se ejecuta por
//    cada edicion de columna. Este bloque permite que el usuario con poco
//    esfuerzo, (ya que del rastreo y movimiento de columnas se encarga
//    ::Edit() ), cree su propia edicion, es decir, llame de forma
//    PERSONALIZADA a ::lEdit() o a un GET creado por el mismo, evite edicion
//    de determinadas columnas, etc, etc. En pocas palabras, sirve para
//    personalizar la edicion por celdas. El bloque recibe argumentos:
//       nCol (Columna a editar)
//       cBuffer (Buffer de Campo)
//       lFirstEdit (Valor logico  que indica si es la primera columna que
//                   se edita en el bucle de rastreo)
//    El usuario, deber  entonces asignar el valor de edicion a la base de datos
//    o al Array, dado que no es mas automatico al definirse un ::bEdit.
//    La asignacion automatica de buffer trae muchos problemas; cuando el orden
//    de las columnas no coincide con el orden Fisico de la base de datos, o,
//    cuando la columna tiene una concatenacion o resultado compuesto distinto al
//    dato real alojado en la base de datos, o tambien cuando se editan campos
//    en un Browse de Array.
//    El bloque DEBE DEVOLVER un valor Logico, que indicara al bucle del metodo
//    ::Edit(), si se quiere o no finalizar el mismo.
//---15/05/2001---
//33) Nueva variable ::lDrawSelect, que especifica si el usuario quiere
//    mostrar o no la celda o linea seleccionada.(Dedicado a mi amigo Giancarlo)
//    Por defecto es verdadero.
//34) Nueva variable ::lOnlyBorder, que especifica si el usuario quiere
//    mostrar solamente el borde de la celda o fila seleccionada, respetandose
//    entonces los colores de fondo o los bloques de color en su caso. Por
//    defecto es .F.. No se aplica a nLineStyle==3 (3D).
//35) Nueva variable ::lDrawFocusRect, por defecto es .T., y especifica si
//    se quiere el borde punteado cuando hay foco. No aplicable nLineStyle==3.
//36) Los BitMaps ya no se estiran, se centran en la celda, o se ajustan, en
//    caso que su tama¤o sea superior a la celda.
//37) Las coordenadas de EditCell ya se ajustaron, para que no se exceda el
//    area de celda.
//38) Las Lineas, Footers y Headers, soportan MULTILINE, que esta dado por
//    la separacion CRLF de la cadena respectiva. Se ajusta a centrado vertical,
//    salvo que su alto supere el alto de celda, entoces, se ajustar  al borde
//    superior de celda.
//39) Nuevas variables ::nHeaderHeight, nFooterHeight, ::nLineHeight, que
//    especifican el alto en pixels de Headers, Footers y Linea Standard del
//    browse. Ya no depende la altura de la fuente. Por defecto las tres
//    asumen el valor de la fuente, por compatibilidad.
//40) Nueva variable: ::bFont. Es un bloque de codigo opcional, que se ejecuta
//    en tiempo de pintado, y envia 3 argumentos: {|nRow,nCol,nStyleLine| ... }
//    nStyleLine, puede asumir los siguientes valores:
//              0 -> Celda standard normal
//              1 -> Celda Header
//              2 -> Celda Footer
//              3 -> Celda standard normal seleccionada
//    Este bloque puede devolver un valor NUMERICO, que representa el handle o
//    manejador de una fuente de Windows (HFONT). Cualquier otro valor que no
//    sea numerico ser  rechazado, y se asumir  que debe usarse la fuente del
//    control standard. Como vemos esto trae una altisima flexibilidad en cuanto
//    a las fuentes del grid, la cual si quisieramos, cada celda podr¡a asumir
//    fuentes de distinto tipo, tama¤o y estilo.
//41) !!!PRECAUCION!!!: Modificaciones a los argumentos de las variables y la
//    ejecucion de ::bTextColor y ::bBkColor. Al igual que la variable ::bFont,
//    se agrega tambien ademas de nRow, nCol, un tercer argumento "nStyleLine".
//    Pero AHORA ESTE BLOQUE TAMBIEN SE EJECUTA CUANDO SE PINTEN HEADERS,
//    FOOTERS Y CELDA(S) SELECCIONADAS. Es por eso que hay que tener mucho
//    cuidado (MAS LO QUE YA LOS USABAN), dado que antes solo se ejecutaba
//    el bloque para lineas stardard del grid, y ahora para TODO TIPO DE LINEA.
//    Es por eso que utilizando el argumento nLineStyle se puede controlar la
//    TOTALIDAD de los colores del grid en tiempo de ejecucion, aportando alta
//    flexibilidad.
//42) Nuevo metodo ::Set3DStyle(). Su sola ejecucion indicar  que el Grid se
//    pinte como en las viejas epocas de FW, osea los colores y el formato 3D
//    que ten¡a en versiones 1.8 o inferiores.
//---27/06/2001---Revision 10.-
//43) Nueva variable de instancia ::lSelect. Determina si estamos parados en
//    la fila seleccionada.
//44) Nueva navegacion por celdas. El bloque lEditCol puede devolver los sig.
//    nuevos valores numericos tambien:
//           1 Contiunar en Proxima Celda
//           2 Contiunar en Proxima Fila (desde 1ra col)
//           3 Contiunar en Proxima Fila (desde la misma col)
//          -1 Contiunar en Anterior Celda
//          -2 Contiunar en Anterior Fila (desde 1ra.Col)
//          -3 Contiunar en Anterior Fila (desde la misma col)
//    Recordemos que ::nLastKey es actualizado por este metodo para tener la
//    ultima tecla presionada.
//45) Nueva variable de instancia ::bSeek, ::cBuffer, ::nBuffer, ::bUpdateBuffer
//    y el Metodo DbfSeek().
//    Sirven  para automamtizar busqueda incremental. Ello implica que
//    si esta definido el bloque ::bSeek, al presionar las teclas de caracteres
//    o borrado, la variable ::cBuffer asumira valores, y luego se ejecutara el
//    code block ::bSeek.
//    Para bases de datos esta automatizado, con solo usar DbfSeek(),
//    o sea: oLbx:bSeek:= {|| oLbx:DbfSeek( .T. ) }. Este metodo "puede" tener
//    4 argumentos:
//       1ro-> Si la busqueda es Soft (default lo es)
//       2do-> Un codeblock que identifique un error cuando se produsca eof().
//       3ro-> Tama¤o del Buffer al momento de la busqueda. Por defecto asume
//             el real.
//       4to-> Si al momento de la busqueda se quiere que lo haga en mayusculas
//             (default lo es).
//    Si el bloque ::bSeek devuelve .T. indicara al sistema que debera hacer el
//    refresh respectivo, caso contrario, le podemos retornar .F. y estabilizar
//    de la manera que se nos ocurra el Grid.-
//    Cuando se ejecuta el codeblock ::bSeek se activa una nueva variable de
//    instancia llamada ::lWorking, que sirve como bandera para evitar agota-
//    mientos del stack. El que considere que no es necesario esto, puede poner
//    el flag a .F., osea, oLbx:bSeek:= {|| oLbx:lWorking:= .F., .... }
//    El CodeBlock ::bUpdateBuffer se ejecuta cada vez que se produzca alguna
//    modificacion el la variable de instancia ::cBuffer.
//    La variable de instancia ::nBuffer determina el tama¤o maximo de caracteres
//    que puede asumir el ::cBuffer.
//46) Nuevos codeblocks ::bGoRight, ::bGoLeft, cuyo resultado deben devolver
//    una variable logica. Un valor false inhabilita ir hacia la derecha/izquirda
//---03/07/2001---Revision 11.-
//    Se han corregido algunos bugs que se presentaban en la busqueda incremental
//47) Nueva Justificacion. Los valores que pueden asumir los elementos de
//    ::aJustify, ::aHJustify y ::aFJustify, pueden identificar adicionalmente,
//    la justificacion vertical, ademas de la clasica justificacion horizontal,
//    usando la funcion nOr() ( similar a | en lenguaje C )
//    A estos efectos se han definido las constantes respectivas:
//
//     Para Justificacion Horizontal
//      #define HA_LEFT    0     (Default)
//      #define HA_RIGHT   1
//      #define HA_CENTER  2
//
//     Para Justificacion Horizontal
//      #define VA_TOP     4
//      #define VA_BOTTOM  8
//      #define VA_CENTER  32    (Default)
//---21/09/2001---Revision 12.-
//    Se han corregido algunos bugs que se presentaban en la busqueda incremental
//48) Nuevo Metodo SetTXT(). Este metodo permite mostrar un archivo de texto
//    automaticamente dentro del area del browse. Es muy facil de usar:
//      oLbx:SetTXT( [ <uParam> ] )
//      <uParam> Puede ser:
//         Character -> Es el nombre del archivo a mostrar. La classe en este
//                      caso crea automaticamente un objeto TTxtFile que se
//                      autodestruira al finalizar el ListBox en forma automa-
//                      tica. No debe preocuparse.
//         Objeto TTxtFile -> Un objeto creado previamente por el usuario. En
//                            este caso la classe NO destruye el objeto que
//                            fue creado por el usuario.
//         Si no se especifica parametros, se pedira que seleccion el archivo
//         de texto a mostrar, mediate el Common Dialog de Windows.
// 49) Nuevas variables de Instancia relacionadas con ::SetTXT()
//
//      ::oTXT........... Objeto TTXTFile creado automaticamente, cuando se
//                        especifica el nombre de archivo en el metodo SetTXT
//                        Este objeto sera destruido automaticamente.
//
//      Estas 3 son de uso interno, y sirven para controlar el desplazamiento
//      horizontal del browse de datos.
//
//      ::nTXTFrom....... Valor que sirve para recortar la cadena de muestra
//      ::nTXTSkip....... Valor que incrementa/decrementa la ::nTXTFrom cada
//                        vez que se quiera ir hacia la derecha o izquierda
//                        respectivamente.
//      ::nTXTMaxSkip.... Valor tope, que identifica el maximo que puede
//                        asumir lar variable ::nTXTSkip
//
//---26/10/2001---Revision 13.-
// 50)  Se corrigio un BUG en el metodo KeyDown(). Gracias Ing.Mario Gonzalez
//
//---12/12/2001---Revision 14.-
// 51)  Se incorporo ::nColFPressed y ::nColHPressed, si se quiere mantener o
//      mostrar como presionada, una celda de las cabeceras o los pies.
//
//---11/05/2002---Revision 15.-
// 52) Compatible con FW para Harbour :-) MUCHAS gracias a mi amigo Jose Gimenez
// 53) Soporte automatico para ADS Local para Harbour
// 54) Nuevos Metodos: nWCol( nMCol )
//                     IsOverHeader( nMRow, nMCol )
//                     IsOverFooter( nMRow, nMCol )
// 55) Nuevas Variables de Instancia: nHeaderStyle
//     (Similares a nLineStyle)       nFooterStyle
////---20/02/2004---Revision 16.-
// 56) Fixes en VScroll y HScroll en ambientes de 32 bits
// 57) Implementacion de MouseWheel() de Fivewin en ambientes no 16 bits
// 58) Aumento de Velocidad. Minimización a la máxima expresión de las llamadas de calculos
//     de Nros. de Registros en Tabla ( ::bLogicLen )
////---18/08/2004---Revision 17.-
// 59) El Bloque bChange no se ejecutaba en busquedas incrementales automaticas.
// 60) Metodo VerifyLogicLen( nLogicLen ) de uso interno, sirve para determinar si realmente existen
//     registros en una base de datos.
// 61) Fixes de compatibilidad con xHarbour/Harbour y fixes varios de clase
// 62) Tecnica de doble buffer


#xtranslate __LOGIC_LEN__ => ;
            ( if( ::lLogicLen, ( n:= ::VerifyLogicLen(Eval( bLogicLen )),;
                                 ::lLogicLen:= .F.,;
                                 if( "N"$ValType(n), ::nLogicLen:= n, nil ) ) ,nil ),;
              ::nLogicLen )

#xtranslate __LOGIC_POS__ => ;
            ( if( ::lLogicPos, ( n:= Eval( bLogicPos ),;
                                 ::lLogicPos:= .F.,;
                                 if( "N"$ValType(n), ::nLogicPos:= n, nil ) ) ,nil ),;
              ::VerifyLogicPos(::nLogicPos) )




#xtranslate VSCROLL_WIDTH => ;
            If( ::oVScroll != Nil .and. Eval(::bLogicLen) > 1, 18, 0 )
#xtranslate _POSVSCROLL_ =>;
            ( Eval( ::bLogicPos ) - 1 ) / Max( 1, ::nLen - 1 ) * 100
#xtranslate _JHEADERS_ =>;
             If( ::aHJustify != Nil, ::aHJustify, ::aJustify )
#xtranslate _JFOOTERS_ =>;
             If( ::aFJustify != Nil, ::aFJustify, ::aJustify )
#xtranslate _WBRWSET_ =>;
             WBrwSet( ::lAdjLastCol, ::lAdjBrowse,;
                      ::lDrawHeaders, ::lDrawFooters,;
                      ::nHeaderHeight, ::nFooterHeight,;
                      ::nLineHeight )


#define _DLL_CH
#define _FOLDER_CH
#define _ODBC_CH
#define _DDE_CH
#define _VIDEO_CH
#define _TREE_CH
#include "FiveWin.Ch"
#include "WinApi.ch"
#include "InKey.ch"
#include "Constant.ch"
#include "Report.ch"


#define MK_MBUTTON           16

#define HA_LEFT    0  // by CeSoTech Alineaciones Horizontales y Verticales
#define HA_RIGHT   1
#define HA_CENTER  2
#define VA_TOP     4
#define VA_BOTTOM  8
#define VA_CENTER  32

#ifdef __CLIPPER__
   #define EM_SETSEL    (WM_USER+1)
#else
   #define EM_SETSEL      177
#endif


#define GW_HWNDFIRST          0
#define GW_HWNDLAST           1
#define GW_HWNDNEXT           2
#define GWL_STYLE           -16

#define HWND_BROADCAST    65535  // 0xFFFF

#define CS_DBLCLKS            8
#define COLOR_ACTIVECAPTION   2
#define COLOR_WINDOW          5
#define COLOR_CAPTIONTEXT     9
#define COLOR_HIGHLIGHT      13
#define COLOR_HIGHLIGHTTEXT  14
#define COLOR_BTNFACE        15
#define COLOR_BTNTEXT        18

#define COLOR_WINDOWTEXT      8  // by CeSoTech
#define COLOR_BTNSHADOW      16  // by CeSoTech
#define ES_CENTER             1  // by CeSoTech

#define WM_SETFONT           48  // 0x30

// Lines Styles
#define LINES_NONE            0
#define LINES_BLACK           1
#define LINES_GRAY            2
#define LINES_3D              3
#define LINES_DOTED           4

#ifdef __XPP__
   #define Super ::TControl
   #define New   _New
   #xtranslate   _DbSkipper => DbSkipper
#endif

#ifdef __HARBOUR__
   #xtranslate   _DbSkipper => DbSkipper
#endif

extern DBSKIP

//----------------------------------------------------------------------------//

CLASS TWBrowse FROM TControl

   DATA   cAlias, cField, uValue1, uValue2
   DATA   bLine, bSkip, bGoTop, bGoBottom, bLogicLen, bChange, bAdd
   DATA   nRowPos, nColPos, nLen, nAt, nColAct
   // nColPos -> 1ra. Columna que se muestra en pantalla
   // nColAct -> Columna Activa

   DATA   nMaxFilter      // Maximum number of records to count
                          // on indexed filters
   DATA   lHitTop, lHitBottom, lCaptured, lMChange
   DATA   lAutoEdit, lAutoSkip
   DATA   lCellStyle AS LOGICAL INIT .f.
   DATA   aHeaders, aColSizes
   DATA   nClrBackHead, nClrForeHead
   DATA   nClrBackFocus, nClrForeFocus
   DATA   aJustify, aActions
   DATA   oGet
   DATA   nLineStyle
   DATA   lIconView, aIcons, bIconDraw, bIconText
   DATA   nIconPos

   DATA   bLogicPos                  // CeSoTech
   DATA   bGoLogicPos                // CeSoTech
   DATA   lAdjLastCol INIT .t.       // CeSoTech
   DATA   lAdjBrowse  INIT .f.       // CeSoTech
   DATA   lDrawHeaders INIT .t.      // CeSoTech
   DATA   aHJustify                  // CeSoTech
   DATA   bTextColor, bBkColor       // CeSoTech
   DATA   nClrLine                   // CeSoTech

   DATA   aFooters                   // CeSoTech
   DATA   lDrawFooters INIT .f.      // CeSoTech
   DATA   aFJustify                  // CeSoTech
   DATA   nClrFBack, nClrFFore       // CeSoTech de Footers
   DATA   nClrNFBack, nClrNFFore     // CeSoTech de Celda Seleccionada
                                     // cuando no esta lFocused.
   CLASSDATA lVScroll                // CeSoTech
   CLASSDATA lHScroll                // CeSoTech
   DATA   nFreeze INIT 0             // CeSoTech
   DATA   aTmpColSizes               // CeSoTech
   DATA   bEdit                      // CeSoTech
   DATA   lDrawSelect INIT .t.       // CeSoTech
   DATA   lOnlyBorder INIT .f.       // CeSoTech
   DATA   lDrawFocusRect INIT .t.    // CeSoTech

   DATA   nHeaderHeight INIT -1      // CeSoTech ->Alto Header
   DATA   nFooterHeight INIT -1      // CeSoTech ->Alto Footer
   DATA   nLineHeight   INIT -1      // CeSoTech ->Alto linea Browse
   DATA   bFont                      // CeSoTech ->Bloque q'dev.Handle Font
   DATA   lSelect INIT .f.           // CeSoTech


   DATA   lWorking INIT .F.          // CeSoTech Evita posibles desbordamientos
   DATA   cBuffer INIT ""            // CeSoTech  Ideas de Jose Maria Torres
   DATA   nBuffer INIT 50            // CeSoTech
   DATA   bSeek                      // CeSoTech
   DATA   bUpdateBuffer              // CeSoTech

   DATA   bGoLeft  INIT {|| .T. }    // CeSoTech
   DATA   bGoRight INIT {|| .T. }    // CeSoTech

   DATA   oTXT                       // Objetos TXT construidos por TWBrowse
   DATA   nTXTFrom INIT 1            // CeSoTech
   DATA   nTXTSkip INIT 4            // CeSoTech
   DATA   nTXTMaxSkip INIT 49        // CeSoTech

   DATA   nColFPressed               // CeSoTech
   DATA   nColHPressed               // CeSoTech

   DATA   nHeaderStyle INIT 3        // CeSoTech
   DATA   nFooterStyle INIT 3        // CeSoTech

   DATA   nLogicLen INIT 0           // CeSoTech
   DATA   lLogicLen INIT .T.         // CeSoTech
   DATA   nLogicPos INIT 0           // CeSoTech
   DATA   lLogicPos INIT .T.         // CeSoTech
   DATA   lGoTop INIT .F.
   DATA   lGoBottom INIT .F.

   CLASSDATA lRegistered AS LOGICAL

   /*
   Datas de uso propio
   */

   DATA   bDel, bDup, bMod, bZoo
   DATA   aLinActions
   DATA   oFontFooter

   /*
   Fin de las datas
   */

   METHOD New( nRow, nCol, nWidth, nHeigth, bLine, aHeaders, ;
               aColSizes, oWnd, cField, uVal1, uVal2, bChange,;
               bLDblClick, bRClick, oFont, oCursor, nClrFore,;
               nForeBack, cMsg, lUpdate, cAlias, lPixel, bWhen,;
               lDesign, bValid, bLClick, aActions ) CONSTRUCTOR

   METHOD ReDefine( nId, bLine, oDlg, aHeaders, aColSizes, cField, uVal1,;
                    uVal2, bChange, bLDblClick, bRClick, oFont,;
                    oCursor, nClrFore, nClrBack, cMsg, lUpdate,;
                    cAlias, bWhen, bValid, bLClick, aActions ) CONSTRUCTOR

   METHOD nAtCol( nCol ) INLINE ::nWCol( nCol )
   METHOD nAtIcon( nRow, nCol )

   METHOD lCloseArea() INLINE ;
             If( ! Empty( ::cAlias ), ( ::cAlias )->( DbCloseArea() ),),;
             If( ! Empty( ::cAlias ), ::cAlias := "",), .t.

   METHOD LDblClick( nRow, nCol, nKeyFlags )
   METHOD Default()

   METHOD BugUp() INLINE ::UpStable()

   METHOD Display()

   METHOD DrawIcons()

   METHOD DrawLine( nRow ) INLINE ;
               _WBRWSET_,; // CeSoTech
               wBrwLine( ::hWnd, ::hDC, If( nRow == nil, ::nRowPos, nRow ), ;
               Eval( ::bLine ), ::GetColSizes(), ::nColPos,;
               ::nClrText, ::nClrPane,;
               If( ::oFont != nil, ::oFont:hFont, 0 ),;
               ValType( ::aColSizes ) == "B", ::aJustify, nil, ::nLineStyle,;
               0, .f., ::bTextColor, ::bBkColor, ::nClrLine,,,::bFont )

   METHOD DrawSelect()

   METHOD lEditCol( nCol, uVar, cPicture, bValid, nClrFore, nClrBack,;
                    aItems, bAction )

   METHOD Edit( nCol, lModal )

   METHOD EditCol( nCol, uVar, cPicture, bValid, nClrFore, nClrBack,;
                   aItems, bAction )

   METHOD GetColSizes() INLINE ;
          If( ValType( ::aColSizes ) == "A", ::aColSizes, Eval( ::aColSizes ) )

   METHOD GetDlgCode( nLastKey )

   METHOD GoUp()
   METHOD GoDown()
   METHOD GoLeft()
   METHOD GoRight()
   METHOD GoTop()
   METHOD GoBottom()

   METHOD GotFocus() INLINE ::Super:GotFocus(),;
                     If( ::nLen > 0 .and. ! EmptyAlias( ::cAlias ) .and. ;
                     ! ::lIconView, ::DrawSelect(),)

   METHOD HScroll( nWParam, nLParam )

   MESSAGE DrawIcon METHOD _DrawIcon( nIcon, lFocused )

   METHOD Initiate( hDlg ) INLINE ::Super:Initiate( hDlg ), ::Default()

   METHOD IsColVisible( nCol )
   METHOD KeyDown( nKey, nFlags )
   METHOD KeyChar( nKey, nFlags )
   METHOD LButtonDown( nRow, nCol, nKeyFlags )
   METHOD LButtonUp( nRow, nCol, nKeyFlags )

   METHOD LostFocus( hCtlFocus ) INLINE ::Super:LostFocus( hCtlFocus ),;
                   If( ::nLen > 0 .and. ! EmptyAlias( ::cAlias ) .and. ;
                   ! ::lIconView, ::DrawSelect(),)

   METHOD MouseMove( nRow, nCol, nKeyFlags )
   #ifndef __CLIPPER__
   METHOD MouseWheel( nKeys, nDelta, nXPos, nYPos )
   #endif
   METHOD PageUp( nLines )
   METHOD PageDown( nLines )
   METHOD Paint()

   METHOD RecAdd() INLINE If( ::bAdd != nil, Eval( ::bAdd ),)

   MESSAGE RecCount METHOD _RecCount( uSeekValue )

   METHOD Report( cTitle, lPreview )

   METHOD ReSize( nSizeType, nWidth, nHeight )

   METHOD nRowCount()

   METHOD SetArray( aArray )
   METHOD SetCols( aData, aHeaders, aColSizes )
   METHOD SetFilter( cField, uVal1, uVal2 )
   METHOD SetTree( oTree )
   METHOD ShowSizes()
   METHOD Skip( n )
   METHOD UpStable()    INLINE ( if( ::nRowPos < ::nRowCount(), ::nRowPos++, ), ::Refresh() )
   METHOD VertLine( nColPos, nColInit )
   METHOD VScroll( nWParam, nLParam )

   METHOD DrawHeaders( nColPressed )   // CeSoTech
   METHOD DrawFooters( nColPressed )   // CeSoTech
   METHOD GetColHeader( nMRow, nMCol ) // CeSoTech
   METHOD GetColFooter( nMRow, nMCol ) // CeSoTech
   METHOD GoToCol( nCol )              // CeSoTech
   METHOD Refresh( lSysRefresh )       // CeSoTech
   METHOD nWRow( nMRow )               // CeSoTech
   METHOD nWCol( nMCol )               // CeSoTech
   METHOD Set3DStyle()                 // CeSoTech -> Estilo del viejo FW
   METHOD aBrwPosRect()
   METHOD DbfSeek( lSoftSeek, bEof )   // CeSoTech
   METHOD SetTXT( uTxt )               // CeSoTech
   METHOD Destroy() INLINE If( ::oTXT !=Nil, (::oTXT:End(), ::oTXT:= Nil),),;
                           If( ::oFontFooter != Nil, ::oFontFooter:End(), ),;
                           ::Super:Destroy()
   METHOD IsOverHeader( nMRow, nMCol )
   METHOD IsOverFooter( nMRow, nMCol )
   METHOD VerifyLogicLen( nLogicLen )
   METHOD VerifyLogicPos( nLogicPos )

   METHOD RightButtonDown( nRow, nCol, nFlags )

   Method ExportToExcel()     INLINE TOleExcel():New():ExportBrowse( Self ):End()
   Method ExportToWord()      INLINE TOleWord():New():ExportBrowse( Self ):End()



   /*
   METHOD DispBegin( lCreateDC )
   METHOD DispEnd( aRestore )
   */

ENDCLASS


//----------------------------------------------------------------------------//
METHOD nRowCount() CLASS TWBrowse
   _WBRWSET_

   If ! "TCBROWSE" $ ::ClassName
      return wBrwRows( ::hWnd, 0, If( ::oFont != nil, ::oFont:hFont, 0 ) ) // CeSoTech
   EndIf
    // Por defecto para evitar conflictos con TCBrowse
return nWRows( ::hWnd, 0, If( ::oFont != nil, ::oFont:hFont, 0 ) ) - 1
//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, nWidth, nHeigth, bLine, aHeaders, aColSizes, oWnd,;
            cField, uVal1, uVal2, bChange, bLDblClick, bRClick,;
            oFont, oCursor, nClrFore, nClrBack, cMsg, lUpdate, cAlias,;
            lPixel, bWhen, lDesign, bValid, bLClick, aActions ) CLASS TWBrowse

#ifdef __XPP__
   #undef New
#endif

   DEFAULT nRow := 0, nCol := 0, nHeigth := 100, nWidth := 100,;
           oWnd := GetWndDefault(),;
           nClrFore := GetSysColor( COLOR_WINDOWTEXT ),; // CeSoTech CLR_BLACK,;
           nClrBack := GetSysColor( COLOR_WINDOW ),;
           lUpdate  := .f., cAlias := Alias(), lPixel := .f.,;
           lDesign  := .f.,;
           bRClick  := {| nRow, nCol, nFlags | ::RightButtonDown( nRow, nCol, nFlags ) }

   #ifdef __XPP__
      DEFAULT cAlias := ""
   #endif

   ::cCaption   = ""
   ::nTop       = nRow * If( lPixel, 1, BRSE_CHARPIX_H ) // 14
   ::nLeft      = nCol * If( lPixel, 1, BRSE_CHARPIX_W )  //8
   ::nBottom    = ::nTop + nHeigth - 1
   ::nRight     = ::nLeft + nWidth - 1
   ::oWnd       = oWnd
   ::lHitTop    = .f.
   ::lHitBottom = .f.
   ::lFocused   = .f.
   ::lCaptured  = .f.
   ::lMChange   = .t.
   ::nRowPos    = 1
   ::nColPos    = 1
   ::nColAct    = 1
   ::nStyle     = nOr(  WS_CHILD, ; //CeSoTech /// WS_VSCROLL, WS_HSCROLL,
                        WS_BORDER,;
                        WS_VISIBLE,;
                        WS_TABSTOP,;
                        If( lDesign, WS_CLIPSIBLINGS, 0 ) )
   ::nId        = ::GetNewId()
   ::cAlias     = cAlias
   ::bLine      = bLine
   ::lAutoEdit  = .f.
   ::lAutoSkip  = .f.
   ::lIconView  = .f.
   ::lCellStyle = .f.
   ::nIconPos   = 0

   ::SetFilter( cField, uVal1, uVal2 )

   ::bAdd       = { || ( ::cAlias )->( DbAppend() ), ::UpStable() }

   ::aHeaders   = aHeaders
   ::aColSizes  = aColSizes
   ::nLen       = 0
   ::lDrag      = lDesign
   ::lCaptured  = .f.
   ::lMChange   = .t.
   ::bChange    = bChange
   ::bLClicked  = bLClick
   ::bLDblClick = bLDblClick
   ::bRClicked  = bRClick

   ::oCursor    = oCursor
   ::oFont      = oFont

   ::nLineStyle := 7     //LINES_NONE
   ::nClrLine   := Rgb( 234, 233, 225 )

   /// CeSoTech ///
   If (::lVScroll== Nil .or. (::lVScroll!=Nil .and. ::lVScroll))
      ::nStyle:= nOr( ::nStyle, WS_VSCROLL )
   EndIf
   If (::lHScroll== Nil .or. (::lHScroll!=Nil .and. ::lHScroll))
      ::nStyle:= nOr( ::nStyle, WS_HSCROLL )
   EndIf
   /// CeSoTech ///

   ::nClrBackHead  := GetSysColor( COLOR_BTNFACE )
   ::nClrForeHead  := GetSysColor( COLOR_BTNTEXT )
   ::nClrBackFocus := GetSysColor( COLOR_HIGHLIGHT )
   ::nClrForeFocus := GetSysColor( COLOR_HIGHLIGHTTEXT) // CeSoTech CLR_WHITE


   ::nClrFBack     := ::nClrBackHead  // by CeSoTech
   ::nClrFFore     := ::nClrForeHead  // by CeSoTech

   ::nClrNFBack    := GetSysColor( COLOR_HIGHLIGHT ) // COLOR_BTNSHADOW ) // by CeSoTech
   ::nClrNFFore    := ::nClrForeFocus // by CeSoTech

   ::cMsg          = cMsg
   ::lUpdate       = lUpdate
   ::bWhen         = bWhen
   ::bValid        = bValid
   ::aActions      = aActions

   ::SetColor( nClrFore, nClrBack )

   #ifdef __XPP__
      DEFAULT ::lRegistered := .f.
   #endif

   ::Register( nOr( CS_VREDRAW, CS_HREDRAW, CS_DBLCLKS ) )

   if ! Empty( oWnd:hWnd )
      ::Create()
      ::Default()
      ::lVisible = .t.
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
      ::lVisible = .f.
   endif

   if lDesign
      ::CheckDots()
   endif

return Self

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, bLine, oDlg, aHeaders, aColSizes, cField, uVal1, uVal2,;
                 bChange, bLDblClick, bRClick, oFont, oCursor,;
                 nClrFore, nClrBack, cMsg, lUpdate, cAlias,;
                 bWhen, bValid, bLClick, aActions ) CLASS TWBrowse

   DEFAULT oDlg      := GetWndDefault(),;
           nClrFore  := GetSysColor( COLOR_WINDOWTEXT ),; // CeSoTech CLR_BLACK,;
           nClrBack  := GetSysColor( COLOR_WINDOW ),;
           lUpdate   := .f.,;
           cAlias    := Alias(),;
           bRClick   := {| nRow, nCol, nFlags | ::RightButtonDown( nRow, nCol, nFlags ) }

   ::lHitTop    = .f.
   ::lHitBottom = .f.
   ::lFocused   = .f.
   ::nId        = nId
   ::nRowPos    = 1
   ::nColPos    = 1
   ::nColAct    = 1
   ::cAlias     = cAlias
   ::oWnd       = oDlg
   ::aHeaders   = aHeaders
   ::aColSizes  = aColSizes
   ::nClrPane   = CLR_LIGHTGRAY
   ::nClrText   = CLR_WHITE
   ::nLen       = 0
   ::lDrag      = .f.
   ::lCaptured  = .f.
   ::lVisible   = .f.
   ::lCaptured  = .f.
   ::lMChange   = .t.

   ::bLine      = bLine
   ::bChange    = bChange
   ::bLClicked  = bLClick
   ::bLDblClick = bLDblClick
   ::bRClicked  = bRClick

   ::oCursor    = oCursor
   ::oFont      = oFont

   ::nLineStyle := 7     //LINES_NONE
   ::nClrLine   := Rgb( 234, 233, 225 )

   ::nClrBackHead  := GetSysColor( COLOR_BTNFACE )
   ::nClrForeHead  := GetSysColor( COLOR_BTNTEXT ) // CeSoTech CLR_BLACK
   ::nClrBackFocus := GetSysColor( COLOR_HIGHLIGHT )
   ::nClrForeFocus := GetSysColor( COLOR_HIGHLIGHTTEXT ) // CeSoTech CLR_WHITE

   ::nClrFBack     := ::nClrBackHead  // by CeSoTech
   ::nClrFFore     := ::nClrForeHead  // by CeSoTech

   ::nClrNFBack    := GetSysColor( COLOR_HIGHLIGHT )  // COLOR_BTNSHADOW ) // by CeSoTech
   ::nClrNFFore    := ::nClrForeFocus // by CeSoTech

   ::cMsg          = cMsg
   ::lUpdate       = lUpdate
   ::bWhen         = bWhen
   ::bValid        = bValid
   ::aActions      = aActions
   ::lAutoEdit     = .f.
   ::lAutoSkip     = .f.
   ::lIconView     = .f.
   ::lCellStyle    = .f.
   ::nIconPos      = 0

   ::SetColor( nClrFore, nClrBack )

   ::SetFilter( cField, uVal1, uVal2 )
   ::bAdd       = { || ( ::cAlias )->( DbAppend() ), ::UpStable() }

   ::Register( nOr( CS_VREDRAW, CS_HREDRAW, CS_DBLCLKS ) )

   oDlg:DefControl( Self )

return Self

//----------------------------------------------------------------------------//

METHOD DrawSelect() CLASS TWBrowse

 LOCAL nTextColor, nBkColor

   _WBRWSET_     /*CeSoTech*/
   If ::nLen < 1
      return Nil
   EndIf

   ::lSelect:= .T.

   If ! ::lDrawSelect  // Si no quiere mostrar celda(s) activa !!!
      ::DrawLine()
      ::lSelect:= .F.
      return Nil
   EndIf

   If ::lOnlyBorder
      nTextColor:= ::nClrText
      nBkColor  := ::nClrPane
   Else
      nTextColor:= If( ::lFocused, ::nClrForeFocus, ::nClrNFFore )
      nBkColor  := If( ::lFocused, ::nClrBackFocus, ::nClrNFBack )
   EndIf

   if ::lCellStyle
      ::DrawLine()

      WBrwLine( ::hWnd, ::hDC, ::nRowPos, Eval( ::bLine ),;
                ::GetColSizes(), ::nColPos,;
                nTextColor, nBkColor,;
                If( ::oFont != nil, ::oFont:hFont, 0 ),;
                ValType( ::aColSizes ) == "B", ::aJustify,, ::nLineStyle,;
                ::nColAct, ::lFocused, ::bTextColor, ::bBkColor, ::nClrLine,;
                .f., .T., ::bFont, ::lDrawFocusRect )

   else

      WBrwLine( ::hWnd, ::hDC, ::nRowPos, Eval( ::bLine ),;
                ::GetColSizes(), ::nColPos,;
                nTextColor, nBkColor,;
                If( ::oFont != nil, ::oFont:hFont, 0 ),;
                ValType( ::aColSizes ) == "B", ::aJustify,, ::nLineStyle, ;
                .f., ::lFocused, ::bTextColor, ::bBkColor, ::nClrLine,;
                .f., .T., ::bFont, ::lDrawFocusRect )

   endif
   ::lSelect:= .F.
return nil

//----------------------------------------------------------------------------//

METHOD DrawIcons() CLASS TWBrowse

   local nWidth := ::nWidth(), nHeight := ::nHeight()
   local nRow := 10, nCol := 10
   local n := 1, nIcons := Int( nWidth / 50 ) * Int( nHeight / 50 )
   local hIcon := ExtractIcon( "user.exe", 0 )
   local oFont, cText

   DEFINE FONT oFont NAME "Ms Sans Serif" SIZE 0, -8 UNDERLINE

   SelectObject( ::hDC, oFont:hFont )
   SetBkColor( ::hDC, CLR_BLUE )
   SetTextColor( ::hDC, CLR_WHITE )

   while n <= nIcons .and. ! ( ::cAlias )->( EoF() )
      if ::bIconDraw != nil .and. ::aIcons != nil
         hIcon = ::aIcons[ Eval( ::bIconDraw, Self ) ]
      endif
      DrawIcon( ::hDC, nRow, nCol, hIcon )
      if ::bIconText != nil
         cText = cValToChar( Eval( ::bIconText, Self ) )
      else
         cText = Str( ( ::cAlias )->( RecNo() ) )
      endif
      DrawText( ::hDC, cText, { nRow + 35, nCol - 5, nRow + 48, nCol + 40 },;
                1 )
      nCol += 50
      if nCol >= nWidth - 32
         nRow += 50
         nCol  = 10
      endif
      ( ::cAlias )->( DbSkip() )
      n++
   end
   ( ::cAlias )->( DbSkip( 1 - n ) )

   oFont:End()

return nil

//----------------------------------------------------------------------------//

METHOD ReSize( nSizeType, nWidth, nHeight ) CLASS TWBrowse

   ::nRowPos = Min( ::nRowPos, Max( ::nRowCount(), 1 ) )

return ::Super:ReSize( nSizeType, nWidth, nHeight )

//----------------------------------------------------------------------------//

METHOD SetArray( aArray ) CLASS TWBrowse

   ::nAt       = 1
   ::cAlias    = "ARRAY"
   // ::bLine     = { || { aArray[ ::nAt ] } }
   ::bLogicLen = { || ::nLen := Len( aArray ) }

   ::bLogicPos  := Nil // CeSoTech
   ::bGoLogicPos:= Nil // CeSoTech

   ::bGoTop    = { || ::nAt := 1 }
   ::bGoBottom = { || ::nAt := Eval( ::bLogicLen ) }
   ::bSkip     = { | nSkip, nOld | nOld := ::nAt, ::nAt += nSkip,;
                  ::nAt := Min( Max( ::nAt, 1 ), Eval( ::bLogicLen ) ),;
                  ::nAt - nOld }
return nil

//----------------------------------------------------------------------------//

METHOD SetTree( oTree ) CLASS TWBrowse

   local oItem := oTree:oFirst

   ::lMChange   = .f.
   ::bLine      = { || oItem:GetLabel() }
   ::aColSizes  = { || oItem:ColSizes() }
   ::bGoTop     = { || oItem := oTree:oFirst }
   ::bGoBottom  = { || oItem := oTree:GetLast() }
   ::bSkip      = { | n | oItem := oItem:Skip( @n ), ::Cargo := oItem, n }
   ::bLogicLen  = { || ::nLen := oTree:nCount() }

   ::bLogicPos   := Nil // CeSoTech
   ::bGoLogicPos := Nil // CeSoTech
   ::lDrawHeaders:= .f. // CeSoTech

   ::bLDblClick = { || If( oItem:oTree != nil,;
                         ( oItem:Toggle(), ::Refresh() ),) }
   ::Cargo      = oItem

   ::bKeyChar   = { | nKey | If( nKey == 13 .and. oItem:oTree != nil,;
                         ( oItem:Toggle(), ::Refresh() ),) }

   if ::oHScroll != nil
      ::oHScroll:SetRange( 0, 0 )
      ::oHScroll = nil
   endif

   oTree:Draw()

return nil

//----------------------------------------------------------------------------//

METHOD Paint() CLASS TWBrowse

   local nSkip
   local nRealSkip

   _WBRWSET_
   if ::lIconView
      ::DrawIcons()
      return 0
   endif

   if ::nRowPos == 1 .and. ! Empty( ::cAlias ) .and. ;
      Upper( ::cAlias ) != "ARRAY" .and. Upper( ::cAlias ) != "_TXT_"
      if ! ( ::cAlias )->( EoF() )
         ( ::cAlias )->( DbSkip( -1 ) )
         if ! ( ::cAlias )->( BoF() )
            ( ::cAlias )->( DbSkip() )
         endif
      endif
   endif

   ::DrawHeaders()  // CeSoTech

   ::DrawFooters()  // CeSoTech

   if ::bLogicLen != nil
      ::nLen   := Eval( ::bLogicLen )
   else
      ::nLen   := 0
   end if

   if ::nLen > 0

   ////////////////////////////////////
   // AutoEstabilizacion by CeSoTech //
   ////////////////////////////////////

   nSkip    := 1 - ::nRowPos
   nRealSkip:= ::Skip( nSkip )
   if nSkip <> nRealSkip
      ::nRowPos-= nRealSkip - nSkip
      ::nRowPos:= Max( ::nRowPos, 1 )
   EndIf

       // WBrwPane() returns the nº of visible rows
       // WBrwPane recieves at aColSizes the Array or a Block
       // to get dinamically the Sizes !!!
      ::Skip( ::nRowPos - wBrwPane( ::hWnd, ::hDC, Self, ::bLine,;
              ::aColSizes, ::nColPos, ::nClrText, ::nClrPane,;
              If( ::oFont != nil, ::oFont:hFont, 0 ), ::aJustify, ;
              ::nLineStyle, 0  , .f., ::bTextColor, ::bBkColor, ::nClrLine,;
              ::oBrush:nRGBColor, ::bFont ) )


      if ::nLen < ::nRowPos
         ::nRowPos = ::nLen
      endif
      ::DrawSelect()

   endif

   If ::oVScroll != Nil .and. ::bLogicPos != Nil
      ::oVScroll:SetPos( _POSVSCROLL_ )
   EndIf

   if ! Empty( ::cAlias ) .and. Upper( ::cAlias ) != "ARRAY" ;
       .and. Upper( ::cAlias ) != "_TXT_"
       ::lHitTop    = ( ::cAlias )->( BoF() )
       ::lHitBottom = ( ::cAlias )->( EoF() )
   endif

return 0

//----------------------------------------------------------------------------//

METHOD GoUp() CLASS TWBrowse

   _WBRWSET_
   ::lGoTop:= .F.
   ::lGoBottom:= .F.

   if ( ::nLen := Eval( ::bLogicLen ) ) < 1
      return nil
   endif


   if ! ::lHitTop

      ::DrawLine()
      if ::Skip( -1 ) == -1
         ::lHitBottom = .f.
         if ::nRowPos > 1
            ::nRowPos--
         else
            WBrwScrl( ::hWnd, -1, If( ::oFont != nil, ::oFont:hFont, 0 ), ::nLineStyle, ::hDC )
         endif
         ::nLogicPos--
      else
         ::lHitTop = .t.
      endif
      ::DrawSelect()
      if ::oVScroll != nil

         If ::bLogicPos != Nil  // By CeSoTech
            ::oVScroll:SetPos( _POSVSCROLL_ )
         Else
            ::oVScroll:GoUp()
         EndIf


      endif
      if ::bChange != nil
         Eval( ::bChange, Self )
      endif

   endif


return nil

//----------------------------------------------------------------------------//

METHOD GoDown() CLASS TWBrowse

   local nLines := ::nRowCount()

    _WBRWSET_
   ::lGoTop:= .F.
   ::lGoBottom:= .F.

   if ( ::nLen := Eval( ::bLogicLen ) ) < 1
      return nil
   endif


   if ! ::lHitBottom

      ::DrawLine()
      if ::Skip( 1 ) == 1
         ::lHitTop = .f.
         if ::nRowPos < nLines
            ::nRowPos++
         else
            WBrwScrl( ::hWnd, 1, If( ::oFont != nil, ::oFont:hFont, 0 ), ::nLineStyle, ::hDC )
         endif
         ::nLogicPos++
      else
         ::lHitBottom = .t.
      endif

      ::DrawSelect()

      if ::oVScroll != nil
         If ::bLogicPos != Nil  // By CeSoTech
            ::oVScroll:SetPos( _POSVSCROLL_ )
         Else
            ::oVScroll:GoDown()
         EndIf
      endif

      if ::bChange != nil
         Eval( ::bChange, Self )
      endif

   endif

return nil

//---------------------------------------------------------------------------//

METHOD GoLeft( lRefresh ) CLASS TWBrowse // by CeSoTech
 LOCAL aSizes:= ::GetColSizes()
 LOCAL nCols := Len( aSizes )
 LOCAL lColVisible, lRefreshAll:= .t.
 LOCAL lGoLeft:= Eval( ::bGoLeft )


    DEFAULT lRefresh:= .T.

    _WBRWSET_

    If ::cAlias == "_TXT_"
       If lGoLeft .and. ::nTXTFrom > 1
          ::nTXTFrom-= ::nTXTSkip
          return .T.
       Else
          MsgBeep()
          return .F.
       EndIf
    EndIf

    If !( ::nColAct > 1 ) .or. ! lGoLeft
       return .f.
    Else
         If ::aTmpColSizes == Nil
            ::aTmpColSizes:= AClone( aSizes ) // Guardo Long. Originales
         EndIf

       If ::nFreeze > 0
          ::nFreeze:= Max( Min( ::nFreeze, nCols - 1 ), 1 )
          ::nColPos:= 1
          If !::lCellStyle
             ::nColAct--
             aSizes[::nColAct]:= ::aTmpColSizes[::nColAct]
             If ::nColAct <= ::nFreeze + 1
                ::nColAct:= 1
             EndIf
             if lRefresh
                If( ::nLen > 0, ::Refresh(), )
             endif
          Else
             ::nColAct--
             lColVisible:= !( aSizes[::nColAct] == 0 )
             aSizes[::nColAct]:= ::aTmpColSizes[::nColAct]
             if lRefresh
                If !lColVisible
                   If( ::nLen > 0, ::Refresh(), )
                Else
                   lRefreshAll:= .f.
                   If( ::nLen > 0, ::DrawSelect(), )
                EndIf
             endif
          EndIf

       Else // No tiene Columnas Freeze

          If !::lCellStyle
             ::nColAct--
             ::nColPos--
             If( ::nLen > 0, ::Refresh(), )

          Else
             ::nColAct--
             lColVisible:= .t.
             While .t.
                If ! ::IsColVisible( ::nColAct ) .and. ::nColAct < ::nColPos
                   lColVisible:= .f.
                   ::nColPos--
                   Loop
                Else
                   Exit
                EndIf
             EndDo
             if lRefresh
                If !lColVisible
                   If( ::nLen > 0, ::Refresh(), )
                Else
                   lRefreshAll:= .f.
                   If( ::nLen > 0, ::DrawSelect(), )
                EndIf
             endif
          EndIf

       EndIf

       If ::oHScroll != Nil .and. lRefresh
          ::oHScroll:SetPos( ::nColAct )
       EndIf

       if ::bChange != nil
          Eval( ::bChange, Self )
       endif

    EndIf
return lRefreshAll

//---------------------------------------------------------------------------//

METHOD GoRight( lRefresh ) CLASS TWBrowse  // by CeSoTech

 LOCAL aSizes:= ::GetColSizes()
 LOCAL nCols := Len( aSizes )
 LOCAL lColVisible, nColAct, lRefreshAll:= .t.
 LOCAL lGoRight:= Eval( ::bGoRight )

    DEFAULT lRefresh:= .T.

    _WBRWSET_

    If ::cAlias == "_TXT_"
       If lGoRight .and. ::nTXTFrom <= ::nTXTMaxSkip
          ::nTXTFrom+= ::nTXTSkip
          return .T.
       Else
          MsgBeep()
          return .F.
       EndIf
    EndIf

    If !( ::nColAct < nCols ) .or. ! lGoRight
       return .f.
    Else
         If ::aTmpColSizes == Nil
            ::aTmpColSizes:= AClone( aSizes ) // Guardo Long. Originales
         EndIf

       ////////////// Hagamos un simple razonamiento :-) que la cabeza no solo
       ////////////// es para pinarnos :-)
       If !::lCellStyle .and. ::IsColVisible( nCols ) .and. ::oHScroll == Nil
                                                      // Si no hay edicion por
          return .f.                                  // celdas y cabe todo en
       EndIf                                          // el control no es necesario
       //////////////                                 // ir hacia la derecha !!!:-)

       If ::nFreeze > 0
          ::nFreeze:= Max( Min( ::nFreeze, nCols - 1 ), 1 )
          ::nColPos:= 1
          If !::lCellStyle
             ::nColAct:= Max( ::nColAct, ::nFreeze + 1 )
             If ::nColAct < nCols
                aSizes[::nColAct]:= 0
                ::nColAct++
                if lRefresh
                   If( ::nLen > 0, ::Refresh(), )
                endif
             EndIf
          Else
             lColVisible:= .t.
             ::nColAct++
             nColAct:= ::nFreeze + 1  // Rellena con Size 0 a su izquierda
             While .t.                // desde la 1ra.no congelada
                If ! ::IsColVisible( ::nColAct ) .and. nColAct < ::nColAct
                   lColVisible:= .f.
                   aSizes[nColAct]:= 0
                   nColAct++
                   Loop
                Else
                   Exit
                EndIf
             EndDo
             if lRefresh
                If !lColVisible
                   If( ::nLen > 0, ::Refresh(), )
                Else
                   lRefreshAll:= .f.
                   If( ::nLen > 0, ::DrawSelect(), )
                EndIf
             endif
          EndIf

       Else // No tiene Columnas Freeze

          If !::lCellStyle
             ::nColAct++
             ::nColPos++
             If( ::nLen > 0, ::Refresh(), )
          Else
             ::nColAct++
             lColVisible:= .t.
             While .t.
                If ! ::IsColVisible( ::nColAct ) .and. ::nColAct > ::nColPos
                   lColVisible:= .f.
                   ::nColPos++
                   Loop
                Else
                   Exit
                EndIf
             EndDo
             if lRefresh
                If !lColVisible
                   If( ::nLen > 0, ::Refresh(), )
                Else
                   lRefreshAll:= .f.
                   If( ::nLen > 0, ::DrawSelect(), )
                EndIf
             endif
          EndIf

       EndIf

       If ::oHScroll != Nil .and. lRefresh
          ::oHScroll:SetPos( ::nColAct )
       EndIf

       if ::bChange != nil
          Eval( ::bChange, Self )
       endif

    EndIf

return lRefreshAll

//----------------------------------------------------------------------------//

METHOD GoTop() CLASS TWBrowse

   ::lGoTop:= .T.
   ::lGoBottom:= .F.

   _WBRWSET_

   if ( ::nLen := Eval( ::bLogicLen ) ) < 1
      return nil
   endif

   if ! ::lHitTop

      Eval( ::bGoTop )

      ::nRowPos = 1
      ::Refresh()
      ::lHitTop = .t.
      ::lHitBottom = .f.

      if ::oVScroll != nil

         If ::bLogicPos != Nil  // By CeSoTech
            ::oVScroll:SetPos( _POSVSCROLL_ )
         Else
            ::oVScroll:GoTop()
         EndIf

      endif

      if ::bChange != nil
         Eval( ::bChange, Self )
      endif

   endif

return nil

//----------------------------------------------------------------------------//

METHOD GoBottom() CLASS TWBrowse

   local nSkipped
   local nLines // := ::nRowCount()
   local n

   ::lGoTop:= .F.
   ::lGoBottom:= .T.

   _WBRWSET_                 // by CeSoTech
   nLines := ::nRowCount()   //  "    "
   ::lLogicPos:= .T.

   if ( ::nLen := Eval( ::bLogicLen ) ) < 1
      return nil
   endif

   if ! ::lHitBottom

      ::lHitBottom = .t.
      ::lHitTop    = .f.

      Eval( ::bGoBottom )

      nSkipped = ::Skip( -( nLines - 1 ) )
      ::nRowPos = 1 - nSkipped

      ::GetDC()
      for n = 1 to -nSkipped
          ::DrawLine( n )
          ::Skip( 1 )
      next
      ::DrawSelect()
      ::ReleaseDC()
      if ::oVScroll != nil
         ::nLen = Eval( ::bLogicLen )

         If ::bLogicPos != Nil  // By CeSoTech
            ::oVScroll:SetPos( _POSVSCROLL_ )
         Else
            if ::oVScroll:nMax != ::nLen
               ::oVScroll:SetRange( 1, ::nLen )
            endif
            ::oVScroll:GoBottom()
         EndIf

      endif


      if ::bChange != nil
         Eval( ::bChange, Self )
      endif

   endif

return nil

//----------------------------------------------------------------------------//

METHOD LDblClick( nRow, nCol, nKeyFlags ) CLASS TWBrowse
   local nClickRow := ::nWRow( nRow )
   local nBrwCol

   if nClickRow == ::nRowPos .and. ::nLen > 0

      nBrwCol = ::nAtCol( nCol )
      if ::lAutoEdit .and. nBrwCol > 0
         ::Edit( nBrwCol )
      else
         return ::Super:LDblClick( nRow, nCol, nKeyFlags )
      endif

   else                                                // CeSoTech
      return ::Super:LDblClick( nRow, nCol, nKeyFlags )  // CeSoTech
   endif

return nil

//----------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol, nKeyFlags ) CLASS TWBrowse

   local nClickRow, nSkipped
   local nColPos := 0, nColInit := ::nColPos - 1
   local nAtCol

   if ::lDrag
      return ::Super:LButtonDown( nRow, nCol, nKeyFlags )
   endif

   nClickRow = ::nWRow( nRow )

   if ::nLen < 1 .and. nClickRow != 0
      return nil
   endif

   if ::lMChange .and. ;
       (::IsOverHeader( nRow, nCol ) .or. ::IsOverFooter( nRow, nCol )) .and.;
       AScan( ::GetColSizes(),;
             { | nColumn | nColPos += nColumn,;
                           nColInit++,;
                           nCol >= nColPos - 1 .and. ;
                           nCol <= nColPos + 1 }, ::nColPos ) != 0


      if ! ::lCaptured
         ::lCaptured = .t.
         ::Capture()
         ::VertLine( nColPos, nColInit )
      endif
      return nil
   endif

   ::SetFocus()

   if ::IsOverHeader(nRow,nCol) .and. Valtype(nKeyFlags) == "N" .and. ::nWCol(nCol) > 0

   /*
   Nuevo para MCS--------------------------------------------------------------
   */

      if Valtype( ::aActions ) == "A"                          .and.;
         ( nAtCol := ::nAtCol( nCol ) ) <= Len( ::aActions )   .and.;
         ::aActions[ nAtCol ] != nil

         ::DrawHeaders() ; ::DrawFooters() ; ::ReleaseDC()

         Eval( ::aActions[ nAtCol ], Self, nRow, nCol )

         ::DrawHeaders(); ::DrawFooters(); ::ReleaseDC()

      endif

      if Valtype( ::aActions ) == "B"

         ::DrawHeaders(); ::DrawFooters(); ::ReleaseDC()

         Eval( ::aActions, ::nAtCol( nCol ), Self, nRow, nCol )

         ::DrawHeaders(); ::DrawFooters(); ::ReleaseDC()

      end if

   /*
   Fin nuevo para MCS--------------------------------------------------------------
   */

   endif

   if nClickRow > 0 .and. nClickRow != ::nRowPos .and. ;
      nClickRow < ::nRowCount() + 1  .and. ::nWCol(nCol) > 0

      ::DrawLine()
      nSkipped  = ::Skip( nClickRow - ::nRowPos )
      ::nRowPos += nSkipped
      ::lGoTop:= .F.
      ::lGoBottom:= .F.
      if ::oVScroll != nil
         If ::bLogicPos != Nil  // By CeSoTech
            ::oVScroll:SetPos( _POSVSCROLL_ )
         Else
            ::oVScroll:SetPos( ::oVScroll:GetPos() + nSkipped )
         EndIf
      endif

      if ::lCellStyle

         If ( nAtCol:= ::nAtCol( nCol ) ) > 0
            ::GoToCol( nAtCol )
         EndIf

      endif

      ::DrawSelect()
      ::lHitTop = .f.
      ::lHitBottom = .f.
      if ::bChange != nil
         Eval( ::bChange, Self )
      endif

   else

      if ::lCellStyle
           If ( nAtCol:= ::nAtCol( nCol ) ) > 0
              ::GoToCol( nAtCol )
           EndIf
      endif
   endif

   /*
   Nuevo para MCS--------------------------------------------------------------
   */

   if ::aLinActions != nil .and. ( nAtCol := ::nAtCol( nCol ) ) <= Len( ::aLinActions )
      if ::aLinActions[ nAtCol ] != nil
         Eval( ::aLinActions[ nAtCol ], Self, nRow, nCol )
      endif
   endif

   /*
   Fin nuevo para MCS----------------------------------------------------------
   */

   ::Super:LButtonDown( nRow, nCol, nKeyFlags )

return 0

//----------------------------------------------------------------------------//

METHOD LButtonUp( nRow, nColM, nFlags ) CLASS TWBrowse
 LOCAL aSizes, nColChange // CeSoTech

   if ::lDrag
      return ::Super:LButtonUp( nRow, nColM, nFlags )
   endif

   if ::lCaptured
      ::lCaptured = .f.
      ReleaseCapture()

      nColChange:= ::VertLine()  // Asignacion by CeSoTech

      // CeSoTech -> Si cambio el ancho de columna, y estoy en nFreeze > 0
      // deber‚ redimensionar el items de la matriz temporaria real de
      // dimensiones !!!.
      If ::nFreeze > 0
         aSizes:= ::GetColSizes()
         If ::aTmpColSizes == Nil
            ::aTmpColSizes:= AClone( aSizes )
         Else
            ::aTmpColSizes[nColChange]:= aSizes[nColChange]
         EndIf
      EndIf
      // CeSoTech //

   endif

   ::Super:LButtonUp( nRow, nColM, nFlags )

return nil

//----------------------------------------------------------------------------//

METHOD Default() CLASS TWBrowse

   local n, aFields
   local cAlias := Alias()
   local nElements, nTotal := 0
   local nDefaultHeight


   if ::oFont == nil
      ::oFont = ::oWnd:oFont
   endif

   /*
   nDefaultHeight := WBrwHeight( ::hWnd, If( ::oFont != nil, ::oFont:hFont, 0 ) )
   */

   nDefaultHeight := 16

   If ::nHeaderHeight <= 0
      ::nHeaderHeight:= nDefaultHeight
   EndIf
   If ::nFooterHeight <= 0
      ::nFooterHeight:= nDefaultHeight
   EndIf
   If ::nLineHeight <= 0
      ::nLineHeight:= nDefaultHeight
   EndIf

   DEFAULT ::aHeaders := {}, ::aColSizes := {}

   if ::bLine == nil
      if Empty( ::cAlias )
         ::cAlias = cAlias
      else
         cAlias = ::cAlias
      endif
      ::bLine  = { || _aFields( Self ) }
      if ::aJustify == nil
         ::aJustify = Array( nElements := Len( Eval( ::bLine ) ) )
         for n = 1 to nElements
             ::aJustify[ n ] = ( ValType( ( cAlias )->( FieldGet( n ) ) ) == "N" )
         next
      endif
   endif

   DEFAULT nElements := Len( Eval( ::bLine ) )

   if Len( ::aHeaders ) < nElements              //  == nil
      if ::Cargo == nil
         ::aHeaders = Array( nElements )
         if !Empty( cAlias )
            for n = 1 to nElements
                ::aHeaders[ n ] = ( cAlias )->( FieldName( n ) )
            next
         else
            aFill( ::aHeaders, "" )
         endif
      else
         ::aHeaders = { "" }
      endif
   endif

   DEFAULT ::aColSizes:= Afill(Array( nElements ), 0 )

   if Len( ::GetColSizes() ) < nElements
      ::aColSizes = Afill(Array( nElements ), 0 )
      if !Empty( cAlias )
         aFields = Eval( ::bLine )
         for n = 1 to nElements
             ::aColSizes[ n ] := If( ValType( aFields[ n ] ) != "C",;
                                      15,; // Bitmap handle
                                      GetTextWidth( 0, Replicate( "B", ;
                                      Max( Len( ::aHeaders[ n ] ), ;
                                           Len( aFields[ n ] ) ) + 1 ),;
                                      If( ! Empty( ::oFont ), ::oFont:hFont,) ) )
         next
      endif
   endif

   if lAnd( GetWindowLong( ::hWnd, GWL_STYLE ), WS_VSCROLL ) .or. ;
      GetClassName( ::hWnd ) == "ListBox"

      if ::bLogicLen != nil
         ::nLen := Eval( ::bLogicLen )
      else
         ::nLen := 0
      end if

      If ::bLogicPos == Nil  // CeSoTech
         DEFINE SCROLLBAR ::oVScroll VERTICAL OF Self RANGE Min( 1, ::nLen ), ::nLen
      Else
         DEFINE SCROLLBAR ::oVScroll VERTICAL OF Self RANGE 1, If( ::nLen == 0, 0, 100 )
      EndIf
      ::oVScroll:SetPage( Min( ::nRowCount(), ::nLen - 1 ) )

   endif

   if lAnd( GetWindowLong( ::hWnd, GWL_STYLE ), WS_HSCROLL )
      if ::Cargo == nil // it is not a tree

         DEFINE SCROLLBAR ::oHScroll HORIZONTAL OF Self ;
            RANGE 1, Len( ::GetColSizes() )

         AEval( ::GetColSizes(), { | nSize | nTotal += nSize } )

         ::oHScroll:SetPage( 1, Len( ::GetColSizes() ) )
      endif
   endif


   if ::uValue1 != nil
      Eval( ::bGoTop )
   endif
   if ::bChange != nil
      Eval( ::bChange, Self )
   endif

   // CeSoTech -> Actualizo las variables de la Clase a Nil, para que siempre
   //             por defecto haya Scrolles, salvo que el usuario antes de
   //             algun constructor diga lo contrario.
   ::lVScroll:= Nil
   ::lHScroll:= Nil
return nil

//---------------------------------------------------------------------------//

METHOD KeyDown( nKey, nFlags ) CLASS TWBrowse

   local lRefresh

   do case
      case nKey == VK_UP
           ::cBuffer:= ""
           ::GoUp()

      case nKey == VK_DOWN
           ::cBuffer:= ""
           ::GoDown()

      case nKey == VK_LEFT
           ::cBuffer:= ""
           If ::GoLeft()
              ::Refresh()
           EndIf

      case nKey == VK_RIGHT
           ::cBuffer:= ""
           If ::GoRight()
              ::Refresh()
           EndIf

      case nKey == VK_HOME
           ::cBuffer:= ""
           ::GoTop()

      case nKey == VK_END
           ::cBuffer:= ""
           ::GoBottom()

      case nKey == VK_PRIOR
           ::cBuffer:= ""
           if GetKeyState( VK_CONTROL )
              ::GoTop()
           else
              ::PageUp()
           endif

      case nKey == VK_NEXT
           ::cBuffer:= ""
           if GetKeyState( VK_CONTROL )
              ::GoBottom()
           else
              ::PageDown()
           endif

      // mcs
      case nKey == VK_RETURN .and. ::bMod != nil
           Eval( ::bMod )

      case ::bSeek != Nil .and. !::lWorking .and. nKey == VK_BACK
           ::lWorking:= .T.
           ::cBuffer := SubStr( ::cBuffer, 1, Len(::cBuffer) - 1 )
           if "L" $ ValType( lRefresh:= Eval( ::bSeek ) ) .and. lRefresh
              ::nRowPos:= Max( Min( ::nLen, ::nRowCount ), 1 )
              ::Refresh()
           endif
           ::lWorking:= .F.

      case ::bSeek != Nil .and. ( nKey == VK_SHIFT .or. nKey >= 32 )
           // No Hacer nada !!!, pero respetar el Super.
           ::Super:KeyDown( nKey, nFlags )

      otherwise
           ::cBuffer:= ""
           If( ::bSeek != Nil .and. ::bUpdateBuffer != Nil, Eval( ::bUpdateBuffer ), )

           // Posibilidad de efectuar acciones con TABs 13/05/04
           if nKey == VK_TAB .and. ::bKeyDown != nil
              Eval( ::bKeyDown, nKey, nFlags )
           endif

           return ::Super:KeyDown( nKey, nFlags )
   endcase

   If( ::bSeek != Nil .and. ::bUpdateBuffer != Nil, Eval( ::bUpdateBuffer ), )

return 0

//----------------------------------------------------------------------------//

METHOD DbfSeek( lSoftSeek, bEof, nLenBuffer, lUpper, cBuffer ) CLASS TWBrowse

   local nRecNo := (::cAlias)->( Recno() )

   DEFAULT lSoftSeek := .T., ;
           bEof:= {|| .T. }, ;
           lUpper:= .T.,;
           cBuffer:= ::cBuffer

   cBuffer:= If( ! lUpper, cBuffer, Upper( cBuffer ) )

   If nLenBuffer != Nil
      cBuffer:= SubStr( cBuffer, 1, nLenBuffer )
   EndIf

   If Len( cBuffer ) > 0 .and. ! Empty( cBuffer )

      (::cAlias)->( DbSeek( cBuffer, lSoftSeek ) )

      if nRecNo != (::cAlias)->( Recno() )
         if ( ::cAlias ) ->( Eof() )
            ( ::cAlias ) -> ( DbGoto( nRecNo ) )
            Eval( bEof )
         else
            if ::bChange != nil
               Eval( ::bChange, Self )
            endif
            return .T.
         endif
      endif
   EndIf
   if ::bChange != nil
      Eval( ::bChange, Self )
   endif
return .F.

//----------------------------------------------------------------------------//

METHOD KeyChar( nKey, nFlags ) CLASS TWBrowse

 LOCAL lRefresh

   do case
      case nKey == K_PGUP
           ::cBuffer:= ""
           ::oVScroll:PageUp()

      case nKey == K_PGDN
           ::cBuffer:= ""
           ::oVScroll:PageDown()

      case ::bSeek != Nil .and. !::lWorking .and. nKey >= 32 // ;
//           .and. ! Chr(nKey)$"+-/*"

           ::lWorking:= .T.
           if Len( ::cBuffer ) < ::nBuffer
              ::cBuffer += Chr( nKey )
              if "L" $ ValType( lRefresh:= Eval( ::bSeek ) ) .and. lRefresh
                 ::nRowPos:= Max( Min( ::nLen, ::nRowCount ), 1 )
                 ::Refresh()
              endif
           endif
           ::lWorking:= .F.

      otherwise
           return ::Super:KeyChar( nKey, nFlags )
   endcase

   If( ::bSeek != Nil .and. ::bUpdateBuffer != Nil, Eval( ::bUpdateBuffer ), )

return 0

//----------------------------------------------------------------------------//

METHOD PageUp( nLines ) CLASS TWBrowse

   local nSkipped

   _WBRWSET_

   DEFAULT nLines := ::nRowCount()

   nSkipped = ::Skip( -nLines )

   if ( ::nLen := Eval( ::bLogicLen ) ) < 1
      return nil
   endif

   if ! ::lHitTop

      if nSkipped == 0
         ::lHitTop = .t.
      else
         ::lHitBottom = .f.
         if -nSkipped < nLines
            ::nRowPos = 1
            if ::oVScroll != nil
               If ::bLogicPos != Nil  // By CeSoTech
                  ::oVScroll:SetPos( _POSVSCROLL_ )
               Else
                  ::oVScroll:SetPos( 1 )
               EndIf
            endif
         else

            nSkipped = ::Skip( -nLines )
            ::Skip( -nSkipped )

            if ::oVScroll != nil

               If ::bLogicPos != Nil  // By CeSoTech
                  ::oVScroll:SetPos( _POSVSCROLL_ )
               Else
                  ::oVScroll:SetPos( ::oVScroll:GetPos() + nSkipped )
               EndIf

            endif

         endif
         ::Refresh()
         if ::bChange != nil
            Eval( ::bChange, Self )
         endif

      endif

      // ::oVScroll:PageUp()

   else
      if ::oVScroll != nil

         If ::bLogicPos != Nil  // By CeSoTech
            ::oVScroll:SetPos( _POSVSCROLL_ )
         Else
            ::oVScroll:GoTop()
         EndIf

      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD PageDown( nLines ) CLASS TWBrowse

   local nSkipped, n

   _WBRWSET_

   ::lGoTop:= .F.
   ::lGoBottom:= .F.

   DEFAULT nLines := ::nRowCount()

   if ( ::nLen := Eval( ::bLogicLen ) ) < 1
      return nil
   endif

   if ! ::lHitBottom

      ::DrawLine()
      nSkipped = ::Skip( ( nLines * 2 ) - ::nRowPos )

      if nSkipped != 0
         ::lHitTop = .f.
      endif

      do case
         case nSkipped == 0 .or. nSkipped < nLines
              if nLines - ::nRowPos < nSkipped
                 ::GetDC()
                 ::Skip( -( nLines ) )
                 for n = 1 to ( nLines - 1 )
                     ::Skip( 1 )
                     ::DrawLine( n )
                 next
                 ::ReleaseDC()
                 ::Skip( 1 )
              endif
              ::nRowPos = Min( ::nRowPos + nSkipped, nLines )
              ::lHitBottom = .t.
              if ::oVScroll != nil
                  If ::bLogicPos != Nil  // By CeSoTech
                     ::oVScroll:SetPos( _POSVSCROLL_ )
                  Else
                     ::oVScroll:GoBottom()
                  EndIf

              endif

         otherwise
              ::GetDC()
              for n = nLines to 1 step -1
                  ::DrawLine( n )
                  ::Skip( -1 )
              next
              ::ReleaseDC()
              ::Skip( ::nRowPos )
      endcase
      ::DrawSelect()

      if ::bChange != nil
         Eval( ::bChange, Self )
      endif

      ::lLogicPos:= .T.
      if ::oVScroll != nil
         if ! ::lHitBottom

            If ::bLogicPos != Nil  // By CeSoTech
               ::oVScroll:SetPos( _POSVSCROLL_ )
            Else
               ::oVScroll:SetPos( ::oVScroll:GetPos() + nSkipped - ( nLines - ::nRowPos ) )
            EndIf

         else
            If ::bLogicPos != Nil  // By CeSoTech
               ::oVScroll:SetPos( _POSVSCROLL_ )
            Else
               ::oVScroll:GoBottom()
            EndIf

         endif
      endif

   endif

return nil

//----------------------------------------------------------------------------//

METHOD VScroll( nWParam, nLParam ) CLASS TWBrowse

   local nLen
   local nLines      := ::nRowCount()
   local nScrollCode := nLoWord( nWParam )
   local nPos        := nHiWord( nWParam )

   if GetFocus() != ::hWnd
      SetFocus( ::hWnd )
   endif

   do case
      case nScrollCode == SB_LINEUP
           ::GoUp()

      case nScrollCode == SB_LINEDOWN
           ::GoDown()

      case nScrollCode == SB_PAGEUP
           ::PageUp()

      case nScrollCode == SB_PAGEDOWN
           ::PageDown()

      case nScrollCode == SB_TOP
           ::GoTop()

      case nScrollCode == SB_BOTTOM
           ::GoBottom()

      case nScrollCode == SB_THUMBPOSITION
           if ( ::nLen := Eval( ::bLogicLen ) ) < 1
              return 0
           endif

           if nPos <= 1 // CeSoTech  /// == 0
              ::GoTop()

           elseif nPos == ::oVScroll:GetRange()[ 2 ]
              ::GoBottom()

           else

              ::lHitTop = .f.
              ::lHitBottom = .f.

              // CeSoTech //
              If ::bGoLogicPos != Nil // Si tiene soporte de ir a un nKeyNo

                 CursorWait()

                 Eval( ::bGoLogicPos, Int( nPos / 100 * ::nLen ) )

                 ::oVScroll:SetPos( _POSVSCROLL_ )

                 ::Refresh()
 **                ::nRowPos:= 1  // Para asegurarnos que vaya donde corresponde

                 CursorArrow()
                 if ::bChange != nil
                    Eval( ::bChange, Self )
                 endif
                 return 0

              Else  // Lo por defecto de FW

                 CursorWait()
                 ::Skip( nPos - ::oVScroll:GetPos() )
                 CursorArrow()

              EndIf
           endif

           ::oVScroll:SetPos( nPos )

           nLen = Eval( ::bLogicLen )
           if nPos - ::oVScroll:nMin < nLines
              ::nRowPos = 1
           endif
           if ::oVScroll:nMax - nPos < Min( nLines, nLen )
              ::nRowPos = Min( nLines, nLen ) - ( ::oVScroll:nMax - nPos )
           endif
           ::Refresh()
           if ::bChange != nil
              Eval( ::bChange, Self )
           endif

      otherwise
           return nil
   endcase

return 0

//----------------------------------------------------------------------------//

METHOD HScroll( nWParam, nLParam ) CLASS TWBrowse

   local nCol := ::nColPos

   #ifdef __CLIPPER__
      local nScrHandle  := nHiWord( nLParam )
      local nScrollCode := nWParam
      local nPos        := nLoWord( nLParam )
   #else
      local nScrollCode := nLoWord( nWParam )
      local nPos        := nHiWord( nWParam )
   #endif

   if ::oGet != nil .and. ! Empty( ::oGet:hWnd )
      ::oGet:End()
   endif

   // CeSoTech !!!!
   // Para gente que define como style desde recursos WS_HSCROLL,
   // y es un Tree, que no puede tenerlo x motivos del default() !!!
   // Windows ejecutaria este evento, pero ::oHscroll seria Nil y
   // produciria un RunTimeError. Asi que lo evitamos.
   If ::oHScroll == nil
      return 0
   EndIf
   // CeSoTech !!!!


   do case
      case nScrollCode == SB_LINEUP
           If ::GoLeft()
              ::Refresh()
           EndIf
      case nScrollCode == SB_LINEDOWN
           If ::GoRight()
              ::Refresh()
           EndIf

      case nScrollCode == SB_PAGEUP

           If ! ::nFreeze > 0 // CeSoTech
              while ::nColPos > 1 .and. ;
                   (::IsColVisible( nCol ) .or. ::nColPos == nCol)
                 ::nColPos--
              end
              ::nColAct := ::nColPos
              ::oHScroll:SetPos( ::nColAct )
              ::Refresh()

           Else
              ::GoLeft()  // CeSoTech
           EndIf

      case nScrollCode == SB_PAGEDOWN
//           ::GoToCol( nCol )
           If ! ::nFreeze > 0 // CeSoTech
              while nCol < Len( ::GetColSizes() ) .and. ;
                   (::IsColVisible( nCol ) .or. ::nColPos == nCol)
                 nCol++
              end
              ::nColPos := nCol
              ::nColAct := nCol
              ::oHScroll:SetPos( nCol )
              ::Refresh()

           Else
              ::GoRight() // CeSoTech
           EndIf

      case nScrollCode == SB_TOP
           ::GoToCol( 1 ) // CeSoTech


      case nScrollCode == SB_BOTTOM
           ::GoToCol( Len( ::GetColSizes() ) ) // CeSoTech

      case nScrollCode == SB_THUMBPOSITION
           ::GoToCol( nPos ) // CeSoTech

      otherwise
           return nil
   endcase

return 0

//----------------------------------------------------------------------------//

METHOD Skip( n ) CLASS TWBrowse

   if ::bSkip != nil
      return Eval( ::bSkip, n )
   endif

return ( ::cAlias )->( _DBSkipper( n ) )

//----------------------------------------------------------------------------//

static function BrwGoBottom( uExpr )

   local lSoftSeek := Set( _SET_SOFTSEEK, .t. )

   if ValType( uExpr ) == "C"
      DbSeek( SubStr( uExpr, 1, Len( uExpr ) - 1 ) + ;
              Chr( Asc( SubStr( uExpr, Len( uExpr ) ) ) + 1 ) )
   else
      DbSeek( uExpr + 1 )
   endif
   DbSkip( -1 )

   Set( _SET_SOFTSEEK, lSoftSeek )

return nil

//----------------------------------------------------------------------------//

// To simulate Filters using INDEXES         -they go extremely fast!-

static function BuildSkip( cAlias, cField, uValue1, uValue2 )

   local bSkipBlock
   local cType := ValType( uValue1 )

   do case
      case cType == "C"
           bSkipBlock = { | n | ( cAlias )->( BrwGoTo( n, ;
           &( "{||" + cField + ">= '" + uValue1 + "' .and." + ;
           cField + "<= '" + uValue2 + "' }" ) ) ) }

      case cType == "D"
           bSkipBlock = { | n | ( cAlias )->( BrwGoTo( n, ;
           &( "{||" + cField + ">= CToD( '" + DToC( uValue1 ) + "') .and." + ;
            cField + "<= CToD( '" + DToC( uValue2 ) + "') }" ) ) ) }

      case cType == "N"
           bSkipBlock = { | n | ( cAlias )->( BrwGoTo( n, ;
           &( "{||" + cField + ">= " + cValToChar( uValue1 ) + " .and." + ;
           cField + "<= " + cValToChar( uValue2 ) + " }" ) ) ) }

      case cType == "L"
           bSkipBlock = { | n | ( cAlias )->( BrwGoTo( n, ;
           &( "{||" + cField + ">= " + cValToChar( uValue1 ) + " .and." + ;
           cField + "<= " + cValToChar( uValue2 ) + " }" ) ) ) }
   endcase

return bSkipBlock

//----------------------------------------------------------------------------//

static function BrwGoTo( n, bWhile )

   local nSkipped := 0, nDirection := If( n > 0, 1, -1 )

   while nSkipped != n .and. Eval( bWhile ) .and. ! EoF() .and. ! BoF()
      DbSkip( nDirection )
      nSkipped += nDirection
   enddo

   do case
      case EoF()
         DbSkip( -1 )
         nSkipped += -nDirection

      case BoF()
         DbGoTo( RecNo() )
         nSkipped++

      case ! Eval( bWhile )
         DbSkip( -nDirection )
         nSkipped += -nDirection
   endcase

return nSkipped

//----------------------------------------------------------------------------//
// Many thanks to Kathy Hayes

METHOD _RecCount( uSeekValue ) CLASS TWBrowse

   local nRecNo := ( ::cAlias )->( RecNo() )
   local nRecs  := 1
   local bField := &( "{ || " + ::cField + "}" )

   if .not. ( ::cAlias )->( DbSeek( uSeekValue, .t. ) )
      if ( ::cAlias )->( Eval( bField ) ) > ::uValue2 ;
         .or. ( ::cAlias )->( EoF() )
         nRecs := 0
      endif
   endif

   // When Filters show a lot of records, the application
   // may loose a lot of time counting. nMaxFilter controls this
   if ::nMaxFilter == nil
      while ::Skip( 1 ) == 1
         nRecs++
      end
   else
      while ::Skip( 1 ) == 1 .and. nRecs < ::nMaxFilter
         nRecs++
      end
   endif

   ( ::cAlias )->( DbGoTo( nRecNo ) )

return nRecs

//----------------------------------------------------------------------------//

static function GenLocal( aArray, nPos )

return { || If( nPos <= Len( aArray ), aArray[ nPos ], "  " ) }

static function GenBlock( bLine, nPos ) ;  return { || Eval( bLine )[ nPos ] }

//----------------------------------------------------------------------------//

METHOD Report( cTitle, lPreview ) CLASS TWBrowse

   local oRpt
   local nRecNo := If( Upper( ::cAlias ) != "ARRAY" .and. ;
                       Upper( ::cAlias ) != "_TXT_" , ( ::cAlias )->( RecNo() ), 0 )
   local aData  := Eval( ::bLine )
   local n
   local nCharWidth

   nCharWidth := GetTextWidth( 0, "B", If( ::oFont != nil, ::oFont:hFont, 0 ))

   DEFAULT cTitle := ::oWnd:cTitle, lPreview := .t.

   if lPreview
      REPORT oRpt TITLE cTitle PREVIEW ;
         HEADER "Fecha: " + DToC( Date() ) + ", Hora: " + Time() ;
         FOOTER "Página: " + Str( oRpt:nPage, 3 )
   else
      REPORT oRpt TITLE cTitle ;
         HEADER "Fecha: " + DToC( Date() ) + ", Hora: " + Time() ;
         FOOTER "Página: " + Str( oRpt:nPage, 3 )
   endif

   if Empty( oRpt ) .or. oRpt:oDevice:hDC == 0
      return nil
   else
      Eval( ::bGoTop )
   endif

   if ::aColSizes == nil
      ::aColSizes = Array( Len( aData ) )
      for n = 1 to Len( aData )
         ::aColSizes[ n ] = 80
      next
   else
      if Len( ::aColSizes ) < Len( aData )
         n = Len( ::aColSizes )
         while n++ < Len( aData )
            AAdd( ::aColSizes, 80 )
         end
      endif
   endif

   for n = 1 to Len( aData )
      if ValType( aData[ n ] ) != "N"
         oRpt:AddColumn( TrColumn():New( { GenLocal( ::aHeaders, n ) },,;
                         { GenBlock( ::bLine, n ) },;
                         Int( ::aColSizes[ n ]/ nCharWidth ),,,,,,,,, oRpt ) )
      else
         oRpt:AddColumn( TrColumn():New( { GenLocal( ::aHeaders, n ) },,;
                         { { || "   " } },;
                         Int( ::aColSizes[ n ] / nCharWidth ),,,,,,,,, oRpt ) )
      endif
   next
   ENDREPORT

   oRpt:bSkip = { || oRpt:Cargo := ::Skip( 1 ) }
   oRpt:Cargo = 1

   ACTIVATE REPORT oRpt ;
      WHILE If( Upper( ::cAlias ) == "ARRAY" .or. Upper( ::cAlias ) == "_TXT_" ,;
                oRpt:nCounter < Eval( ::bLogicLen ),;
                oRpt:Cargo == 1 )

   if Upper( ::cAlias ) != "ARRAY" .AND. Upper( ::cAlias ) != "_TXT_"
      ( ::cAlias )->( DbGoTo( nRecNo ) )
   endif
   ::Refresh()

return nil

//----------------------------------------------------------------------------//
/*
METHOD UpStable() CLASS TWBrowse

   local nRow   := ::nRowPos
   local nRecNo := ( ::cAlias )->( RecNo() )
   local nRows  := ::nRowCount()
   local n      := 1
   local lSkip  := .t.

   ::nRowPos    = 1
   ::GoTop()
   ::lHitTop    = .f.
   ::lHitBottom = .f.

   while ! ( ::cAlias )->( EoF() )
      if n > nRows
         ( ::cAlias )->( DbGoTo( nRecNo ) )
         ::nRowPos = nRow
         lSkip     = .f.
         exit
      endif
      if nRecNo == ( ::cAlias )->( RecNo() )
         ::nRowPos = n
         exit
      else
         ( ::cAlias )->( DbSkip() )
      endif
      n++
   end while

   if lSkip
      ( ::cAlias )->( DbSkip( -::nRowPos ) )
   endif

   ::Refresh( .f. )

   if ::bChange != nil
      Eval( ::bChange, Self )
   endif

return nil
*/
//----------------------------------------------------------------------------//

METHOD SetFilter( cField, uVal1, uVal2 ) CLASS TWBrowse

   local bGoTop, bGoBottom, bLogicLen, bLogicPos, bGoLogicPos, bSkip
   local cIndexType

   DEFAULT uVal2  := uVal1

   ::cField       := cField
   ::uValue1      := uVal1
   ::uValue2      := uVal2

   if Select( ::cAlias ) == 0
      Return nil
   end if

   if uVal1 != nil
      cIndexType  := ( ::cAlias )->( ValType( &( IndexKey() ) ) )
      if ( ::cAlias )->( ValType( &cField ) ) != cIndexType .or. ;
         ValType( uVal1 ) != cIndexType .or. ;
         ValType( uVal2 ) != cIndexType
         msgStop( "TWBrowse SetFilter() types don't match with current Index Key type!" )
      endif
   endif

   // Posibility of using FILTERs based on INDEXES!!!

   if !Empty( ::cAlias )

      bGoTop       = If( uVal1 != nil, { || ( ::cAlias )->( DbSeek( uVal1, .t. ) ) }, { || ( ::cAlias )->( DbGoTop() ) } )
      ::bGoTop     = {|| If( Empty( ::cAlias ), 0, Eval( bGoTop ) ) }

      bGoBottom    = If( uVal2 != nil, { || ( ::cAlias )->( BrwGoBottom( uVal2 ) ) }, { || ( ::cAlias )->( DbGoBottom() ) } )
      ::bGoBottom  = {|| If( Empty( ::cAlias ), 0, Eval( bGoBottom ) ) }

      bSkip        = If( uVal1 != nil, BuildSkip( ::cAlias, cField, uVal1, uVal2 ),;
                      { | n | ( ::cAlias )->( _DbSkipper( n ) ) } )
      ::bSkip      = {|n| If( Empty( ::cAlias ), 0, Eval( bSkip, n ) ) }

      // Compatible con 5.3 RDD DBFCDX !!!

      If cDriver() $ ( ::cAlias )->( RddName() ) //.and. uVal1 == Nil .and. ( "5.3" $ Version() .or. "HARBOUR" $ Upper(Version()) )

          bLogicLen     = { |n| n := If( Empty( Select( ::cAlias ) ), 0, ( ::cAlias )->( OrdKeyCount() ) ), If( "N" $ ValType( n ), n, 0 ) }
          ::bLogicLen   = { |n| If( Empty( Select( ::cAlias ) ), 0, Eval( bLogicLen ) ) }

          bLogicPos     = { |n| n := If( Empty( Select( ::cAlias ) ), 0, ( ::cAlias )->( OrdKeyNo() ) ), If( "N" $ ValType( n ), n, 0 ) }
          ::bLogicPos   = { |n| If( Empty( Select( ::cAlias ) ), 0, Eval( bLogicPos ) ) }

          bGoLogicPos   = { |nKeyNo| If( Empty( Select( ::cAlias ) ), 0, ( ::cAlias )->( OrdKeyGoTo( nKeyNo ) ) ) }
          ::bGoLogicPos = { |n| If( Empty( Select( ::cAlias ) ), 0, Eval( bGoLogicPos, n ) ) }

      Else  // Por defecto como FW

          bLogicLen    = If( uVal1 != nil,;
                             { || ( ::cAlias )->( Self:RecCount( uVal1 ) ) },;
                             { || ( ::cAlias )->( RecCount() ) } )
          ::bLogicLen   = {|n| If( Empty( ::cAlias ), 0, Eval( bLogicLen ) ) }

          ::bLogicPos   = Nil
          ::bGoLogicPos = Nil

      EndIf
      // CeSoTech //

      ::nLen       = Eval( ::bLogicLen )

      ::lHitTop    = .f.
      ::lHitBottom = .f.

      if uVal1 != nil
         Eval( ::bGoTop )
      endif
   else
      ::bLogiclen = { || 0 }
   endif

return nil

//----------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol, nKeyFlags ) CLASS TWBrowse

   local nColPos := 0

   ::Super:MouseMove( nRow, nCol, nKeyFlags )

   if ::lDrag
      return ::Super:MouseMove( nRow, nCol, nKeyFlags )
   endif

   if ::lCaptured
      CursorWE()
      ::VertLine( nCol )
      return 0
   endif

   if ::lMChange .and. ;
      (::IsOverHeader( nRow, nCol ) .or. ::IsOverFooter( nRow, nCol )) .and.;
      AScan( ::GetColSizes(),;
              { | nColumn | nColPos += nColumn,;
                            nCol >= nColPos - 1 .and. ;
                            nCol <= nColPos + 1 }, ::nColPos ) != 0
      CursorWE()
   else
      ::Super:MouseMove( nRow, nCol, nKeyFlags )
   endif

return 0

//----------------------------------------------------------------------------//
#ifndef __CLIPPER__
METHOD MouseWheel( nKeys, nDelta, nXPos, nYPos ) CLASS TWBrowse

   local aPos := { nYPos, nXPos }

   aPos = ScreenToClient( ::hWnd, aPos )

   if aPos[ 1 ] > ::nHeight * 0.80
      if nDelta > 0
         ::GoUp()
         // ::GoLeft()
      else
         ::GoDown()
         // ::GoRight()
      endif
   else
      if lAnd( nKeys, MK_MBUTTON )
         if nDelta > 0
            ::PageUp()
         else
            ::PageDown()
         endif
      else
         if nDelta > 0
            ::GoUp()
         else
            ::GoDown()
         endif
      endif
   endif

return nil
#endif

//----------------------------------------------------------------------------//

METHOD VertLine( nColPos, nColInit ) CLASS TWBrowse

   local oRect, aSizes, nFor

   static nCol, nWidth, nMin, nOldPos := 0

   if nColInit != nil
      nCol    = nColInit
      nWidth  = nColPos
      nOldPos = 0
      nMin := 0
      aSizes := ::GetColSizes()

      FOR nFor := ::nColPos TO nColInit - 1
          nMin += aSizes[nFor]
      NEXT

      nMin += 5
   endif

   if nColPos == nil .and. nColInit == nil   // We have finish draging
      ::aColSizes[ nCol ] -= ( nWidth - nOldPos )
      ::Refresh()
   endif

   if nColPos != nil
     nColPos := Max(nColPos, nMin)
   endif

   oRect = ::GetRect()
   ::GetDC()
   if nOldPos != 0
//    InvertRect( ::hDC, { 0, nOldPos - 2, oRect:nBottom, nOldPos + 2 } )
      InvertRect( ::hDC, { 0, nOldPos - 0.5, oRect:nBottom, nOldPos + 0.5 } )
      nOldPos = 0
   endif
   if nColPos != nil .and. ( nColPos - 2 ) > 0
//    InvertRect( ::hDC, { 0, nColPos - 2, oRect:nBottom, nColPos + 2 } )
      InvertRect( ::hDC, { 0, nColPos - 0.5, oRect:nBottom, nColPos + 0.5 } )
      nOldPos = nColPos
   endif
   ::ReleaseDC()

return nCol //-> Columna que cambio !!!

//----------------------------------------------------------------------------//

METHOD nAtIcon( nRow, nCol ) CLASS TWBrowse

   local nIconsByRow := Int( ::nWidth() / 50 )

   nRow -= 9
   nCol -= 1

   if ( nCol % 50 ) >= 9 .and. ( nCol % 50 ) <= 41
      return Int( ( nIconsByRow * Int( nRow / 50 ) ) + Int( nCol / 50 ) ) + 1
   else
      return 0
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Display() CLASS TWBrowse

   local nRecs

   ::BeginPaint()
   if ::oVScroll != nil   // They generate WM_PAINT msgs when range 0

      if ::bLogicLen != nil
         nRecs := Eval( ::bLogicLen )
      else
         nRecs := 0
      end if

      If ::bLogicPos != Nil // CeSoTech

         If nRecs > 0 .and. ::oVScroll:GetRange()[1] < 1
            ::oVScroll:SetRange( 1, 100 )
         ElseIf nRecs < 1
            ::oVScroll:SetRange( 1, 100 )
//            ::oVScroll:SetRange( 0, 0 )
         EndIf
         ::oVScroll:SetPage( Min( ::nRowCount(), ::nLen - 1 ) )

      Else

         if ::oVScroll:nMax != nRecs .or. nRecs != ::nLen
            ::oVScroll:SetRange( 1, ::nLen := nRecs )
            ::oVScroll:SetPage( Min( ::nRowCount(), ::nLen - 1 ) )
         endif
     EndIf
   endif                  // so here we avoid 'flicking'

   if ::oHScroll != nil
      ::oHScroll:SetRange( 1, Len( ::GetColSizes() ) )
      ::oHScroll:SetPage( 1, Len( ::GetColSizes() ) )
   endif

   ::Paint()
   ::EndPaint()

return 0

//----------------------------------------------------------------------------//

METHOD GetDlgCode( nLastKey ) CLASS TWBrowse

   // This method is very similar to TControl:GetDlgCode() but it is
   // necessary to have WHEN working

   if .not. ::oWnd:lValidating
      if nLastKey == VK_UP .or. nLastKey == VK_DOWN ;
         .or. nLastKey == VK_RETURN .or. nLastKey == VK_TAB
         ::oWnd:nLastKey = nLastKey
      else
         ::oWnd:nLastKey = 0
      endif
   endif

return If( IsWindowEnabled( ::hWnd ), DLGC_WANTALLKEYS, 0 )

//----------------------------------------------------------------------------//

function _aFields( Self )

   local aFld, aSizes, cAlias := ::cAlias
   local nCols, nFirstCol, nLastCol, nWidth, nBrwWidth

   if Empty( cAlias )
      return {}
   endif

   if Len( ::aColSizes ) == 0
      return Array( ( cAlias )->( Fcount() ) )
   endif

  aSizes    = ::aColSizes
  nCols     = Len( aSizes )
  nFirstCol = ::nColPos
  nLastCol  = nFirstCol
  nWidth    = 0
  nBrwWidth = ::nWidth()
  aFld      = Array( nCols )

  AFill( aFld, "" ) // , 1, nFirstCol - 1 )

  while nWidth < nBrwWidth .and. nLastCol <= nCols
     nWidth += aSizes[ nLastCol ]
     if ValType( ( cAlias )->( FieldGet( nLastCol ) ) ) == "M"
        aFld[ nLastCol ] = If( ! Empty( ( cAlias )->( ;
              FieldGet( nLastCol ) ) ), "<Memo>", "<memo>" )
        nLastCol++   // Keep this here! XBase+ and Clipper difference!!!
     else
        aFld[ nLastCol ] = cValToChar( ( cAlias )->( FieldGet( nLastCol ) ) )
        nLastCol++   // Keep this here! XBase+ and Clipper difference!!!
     endif
  end

return aFld

//----------------------------------------------------------------------------//

METHOD SetCols( aData, aHeaders, aColSizes ) CLASS TWBrowse

   local aFields
   local nElements, n

   nElements   := Len( aData )

   ::aHeaders  := If( aHeaders  != nil, aHeaders, ::aHeaders )
   ::aColSizes := If( aColSizes != nil, aColSizes, {} )
   ::bLine     := {|| _aData( aData ) }
   ::aJustify  := AFill( Array( nElements ), .F. )

   if Len( ::GetColSizes() ) < nElements
      ::aColSizes = AFill( Array( nElements ), 0 )
      aFields = Eval( ::bLine )
      for n = 1 to nElements
          ::aColSizes[ n ] := If( ValType( aFields[ n ] ) != "C",;
                                   15,; // Bitmap handle
                                   GetTextWidth( 0, Replicate( "B", ;
                                   Max( Len( ::aHeaders[ n ] ), ;
                                        Len( aFields[ n ] ) ) + 1 ),;
                                   If( ! Empty( ::oFont ), ::oFont:hFont,) ) )
      next
   endif

   if ::oHScroll != nil
      ::oHScroll:nMax := ::GetColSizes()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD ShowSizes() CLASS TWBrowse

   local cText := ""

   AEval( ::aColSizes,;
          { | v,e | cText += ::aHeaders[ e ] + ": " + Str( v, 3 ) + CRLF } )

   MsgInfo( cText )

return nil

//----------------------------------------------------------------------------//

METHOD _DrawIcon( nIcon, lFocused ) CLASS TWBrowse

   local nIconsByRow := Int( ::nWidth() / 50 )
   local nRow := Int( --nIcon / nIconsByRow )
   local nCol := If( nRow > 0, nIcon % ( nRow * nIconsByRow ), nIcon )

   DEFAULT lFocused := .f.

   if lFocused
      DrawIconFocus( ::GetDC(), ( nRow * 50 ) + 10, ( nCol * 50 ) + 10,;
                     ExtractIcon( "user.exe" ) )
   else
      DrawIcon( ::GetDC(), ( nRow * 50 ) + 10, ( nCol * 50 ) + 10,;
                ExtractIcon( "user.exe" ) )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD IsColVisible( nCol ) CLASS TWBrowse
 // CeSoTech la reescribio completita porque originaba RTE !!!!
 LOCAL aSizes:= ::GetColSizes()
 LOCAL nLenSizes:= Len( aSizes )
 LOCAL nSizeAcum:= 0, nId
 LOCAL nBrwWidth := ::nWidth - ;
                    If( ::oVScroll != nil, VSCROLL_WIDTH , 0 )

    For nId = ::nColPos To nLenSizes
        If nId < 1
          return .f.
        EndIf
        nSizeAcum+= aSizes[nId]
        If nId == nCol
           If nSizeAcum <= nBrwWidth
              return .t.
           EndIf
           Exit
        EndIf
    Next

return .F.

//----------------------------------------------------------------------------//
METHOD DrawHeaders( nColPressed ) CLASS TWBrowse // CeSoTech
   If ::lDrawHeaders
      _WBRWSET_
      DEFAULT nColPressed:= ::nColHPressed
      WBrwLine( ::hWnd, ::hDC, 0, ::aHeaders, ::GetColSizes(),;
                ::nColPos, ::nClrForeHead, ::nClrBackHead,;
                If( ::oFont != nil, ::oFont:hFont, 0 ),.f.,;
                _JHEADERS_, nColPressed, ::nHeaderStyle,;
                0, .f., ::bTextColor, ::bBkColor, ::nClrLine,,,::bFont )

      EndIf
return Nil

//----------------------------------------------------------------------------//
METHOD DrawFooters( nColPressed ) CLASS TWBrowse // CeSoTech

   LOCAL aFooters
   LOCAL nLen
   LOCAL cType

   if ::lDrawFooters

      cType       := Valtype( ::aFooters )

      If Empty( ::oFontFooter )
         ::oFontFooter:= ::oFont
      EndIf

      If "B" $ cType
         aFooters := Eval( ::aFooters )
      ElseIf "A"$cType
         aFooters := aClone( ::aFooters )
      Else
         aFooters := {}
      EndIf

      If Len( aFooters ) <> ( nLen := Len( ::GetColSizes() ) )
         ASize( aFooters, nLen )
      EndIf

      AEval( aFooters, {|uElem,n| aFooters[n] := If( "B" $ ValType( uElem ), Eval( uElem ), uElem ) } )

      _WBRWSET_

      DEFAULT nColPressed:= ::nColFPressed

      WBrwLine( ::hWnd, ::hDC, 0, aFooters, ::GetColSizes(),;
                ::nColPos, ::nClrFFore, ::nClrFBack,;
                If( ::oFontFooter != nil, ::oFontFooter:hFont, 0 ),.f.,;
                _JFOOTERS_, nColPressed, ::nFooterStyle,;
                0, .f., ::bTextColor, ::bBkColor, ::nClrLine, .t.,,::bFont )

   end if

return Nil

//----------------------------------------------------------------------------//
METHOD IsOverHeader( nMRow, nMCol ) CLASS TWBrowse
    // Piso en Header
    If ::lDrawHeaders .and. nMRow <= ::nHeaderHeight
       If nMCol != Nil
          return ::nWCol( nMCol ) > 0
       Else
          return .T.
       EndIf
    EndIf
return .F.
//----------------------------------------------------------------------------//
METHOD IsOverFooter( nMRow, nMCol ) CLASS TWBrowse
 LOCAL aRect
    If ::lDrawFooters
       aRect:= GetClientRect( ::hWnd )
        // Piso en Footer
       If nMRow <= aRect[3] .and. nMRow >= ( aRect[3] - (::nFooterHeight+1) )
          If nMCol != Nil
             return ::nWCol( nMCol ) > 0
          Else
             return .T.
          EndIf
       EndIf
    EndIf
return .F.
//----------------------------------------------------------------------------//
METHOD GetColHeader( nMRow, nMCol ) CLASS TWBrowse
   If ::IsOverHeader( nMRow, nMCol )
      return ::nWCol( nMCol )
   EndIf
return 0
//----------------------------------------------------------------------------//
METHOD GetColFooter( nMRow, nMCol ) CLASS TWBrowse
   If ::IsOverFooter( nMRow, nMCol )
      return ::nWCol( nMCol )
   EndIf
return 0

//----------------------------------------------------------------------------//
METHOD GoToCol( nCol ) CLASS TWBrowse // by CeSoTech
 LOCAL nCols
 LOCAL nLen:= ::nLen
 LOCAL lRefreshAll:= .f., nColAct

    If nCol > ::nColAct
      ::nLen:= 0   // Para que no haga los refresh en GoLeft y GoRight
       nCols:= Len( ::aColSizes() )


       Do While nCol > ::nColAct .and. ::nColAct < nCols
          nColAct:= ::nColAct
          If ::GoRight(.F.) .and. !lRefreshAll
             lRefreshAll:= .t.
          EndIf
          If nColAct == ::nColAct // Si no se movio, significa que no puede !!!
             Exit
          EndIf
       EndDo

    ElseIf nCol < ::nColAct
      ::nLen:= 0   // Para que no haga los refresh en GoLeft y GoRight
       Do While nCol < ::nColAct .and. ::nColAct > 1
          nColAct:= ::nColAct
          If ::GoLeft(.F.) .and. !lRefreshAll
             lRefreshAll:= .t.
          EndIf
          If nColAct == ::nColAct // Si no se movio, significa que no puede !!!
             Exit
          EndIf
       EndDo

    EndIf

    If lRefreshAll
       ::Refresh()
    Else
       ::nLen:= nLen
       ::DrawSelect()
    EndIf

    If ::oHScroll != Nil
       ::oHScroll:SetPos( ::nColAct )
    EndIf

return Nil

//----------------------------------------------------------------------------//
METHOD Refresh( lSysRefresh ) CLASS TWBrowse

    local n

    DEFAULT lSysRefresh := .f.

    ::lLogicLen:= .T.
    ::lLogicPos:= .T.

    if Valtype( ::aTmpColSizes ) == "A" .and. Valtype( ::aColSizes ) == "A"
       if Len( ::aTmpColSizes ) <> Len( ::aColSizes )
         ::aTmpColSizes:= aSize( ::aTmpColSizes, Len(::aColSizes) )
         for n = 1 To Len( ::aTmpColSizes )
            if ::aTmpColSizes[n] == nil
               ::aTmpColSizes[n]:= ::aColSizes[n]
            endif
         next
       endif
    endif

    if ::oHScroll != nil .and. ::oHScroll:GetRange[2] != Len( ::GetColSizes() )
       ::oHScroll:SetRange( 1, Len( ::GetColSizes() ) )
       ::oHScroll:SetPage( 1, Len( ::GetColSizes() ) )
    endif

    If ::Cargo != Nil .or. ; // Tree
       !( ::nLen := Eval( ::bLogicLen ) ) > 0
       ::Super:Refresh()
    Else // Si hay elementos en la tabla

       ::lHitBottom  := .f.
       ::lHitTop     := .f.

       ::DrawFooters()

       ::Super:Refresh( .f. ) // No borrar fondo, WBrwPane se encarga de eso !!

       If lSysRefresh       // OJO Usar con cuidado porque puede hacer agotar
          SysRefresh()      // el Stack :-(
       EndIf

    EndIf
return 0

//----------------------------------------------------------------------------//

static function _aData( aFields )

   local nFor
   local nLen   := Len( aFields )
   local aFld   := Array( nLen )

   for nFor = 1 to nLen
      aFld[ nFor ] = Eval( aFields[ nFor ] )
   next

return aFld

//----------------------------------------------------------------------------//

#ifdef __XPP__

static function wBrwLine( hWnd, hDC, nRowPos, aValues, aColSizes,;
                          nColPos, nClrText, nClrPane,;
                          hFont, lTree, aJustify, nPressed, nLineStyle,;
                          nColAct, lFocused )
   local nTxtHeight, hOldFont
   local nColStart  := -1
   local nWidth     := WndWidth( hWnd )
   local nRow := nRowPos, nTop, nBottom, nLeft, nRight, n
   local lReleaseDC := .f.
   local nForeColor, nBackColor

   DEFAULT lTree := .f.

   if Empty( hDC )
      hDC = GetDC( hWnd )
      lReleaseDC = .t.
   endif

   hOldFont   = SelectObject( hDC, hFont )
   nTxtHeight = GetTextHeight( hWnd, hDC ) + 1

   nTop    = nTxtHeight * nRow
   nBottom = nTop + nTxtHeight - 1

   SetTextColor( hDC, If( ValType( nClrText ) == "B",;
                 nClrText := Eval( nClrText ), nClrText ) )
   SetBkColor( hDC, If( ValType( nClrPane ) == "B",;
               nClrPane := Eval( nClrPane ), nClrPane ) )

   for n := nColPos to Len( aValues )
      nLeft   = nColStart + 1
      nRight  = Min( nColStart := ( nLeft + aColSizes[ n ] - 1 ), nWidth )
      if nLeft > nWidth
         exit
      endif
      if n == Len( aValues )
         nRight = nWidth
      endif

      if ValType( aValues[ n ] ) == "N"
         DrawMasked( hDC, aValues[ n ], nTop, nLeft + 2 )
      else
         if nColAct != nil .and. n == nColAct
            SetTextColor( hDC, nClrText )
            SetBkColor( hDC, nClrPane )
         else
            SetTextColor( hDC, If( nColAct != nil, GetSysColor( COLOR_HIGHLIGHTTEXT ),;
                          nClrText ) )
            SetBkColor( hDC, If( nRowPos == 0, GetSysColor( COLOR_BTNFACE ),;
                        If( nColAct == nil, nClrPane, GetSysColor( COLOR_WINDOW ) ) ) )
         endif
         if ! lTree
            ExtTextOut( hDC, nTop, nLeft + 2,;
                        { nTop, nLeft, nBottom, nRight },;
                          cValToChar( aValues[ n ] ) )
         else
            DrawText( hDC, cValToChar( aValues[ n ] ),;
                      { nTop, nLeft + 4, nBottom, nRight } )
         endif
      endif
      if ! lTree
         if nRowPos == 0
            WndBox( hDC, nTop - 1, nLeft - 1, nBottom, nRight )
            WndBoxRaised( hDC, nTop, nLeft, nBottom - 1, nRight - 1 )
         else
            WndBox( hDC, nTop - 1, nLeft - 1, nBottom, nRight )
         endif
      endif

      if nColPos > nWidth
         exit
      endif
   next

   SelectObject( hDC, hOldFont )

   if lReleaseDC
      ReleaseDC( hWnd, hDC )
   endif

return nil

#endif

//----------------------------------------------------------------------------//
STATIC Function EmptyAlias( cAlias ) //-> Devuelve un valor logico cuando un
 LOCAL lEmpty:= .T.                  //   un area de trabajo en curso
                                     //   existe y esta activa.
    If ! Empty( cAlias )
       If cAlias == "ARRAY" .or. cAlias == "_TXT_"
          lEmpty:= .F.
       Else
          lEmpty:= ! Select( cAlias ) > 0
       EndIf
    EndIf
return lEmpty

//----------------------------------------------------------------------------//

METHOD nWRow( nMRow ) CLASS TWBrowse
 LOCAL aRect, nRows, nHeight, nRow

    If ::IsOverHeader( nMRow ) .or. ::IsOverFooter( nMRow )
       return 0
    EndIf

    nRows:= ::nRowCount()
    nHeight:= ::nLineHeight + 1

    aRect:= { 0, nHeight }

    If ::lDrawHeaders
       aRect[1]:= ::nHeaderHeight + 1
       aRect[2]:= aRect[1] + nHeight
    EndIf

    For nRow = 1 To nRows
        If nMRow >= aRect[1] .and. nMRow <= aRect[2]
           return nRow
        EndIf
        aRect[1]+= nHeight
        aRect[2]+= nHeight
    Next

return 0

//----------------------------------------------------------------------------//
METHOD nWCol( nMCol ) CLASS TWBrowse
 LOCAL aSizes, nAcum:= 0, nBrwWidth, nCol

    nBrwWidth := ::nWidth -;
                 If( ::oVScroll != nil, VSCROLL_WIDTH, 0 )
    aSizes:= ::GetColSizes()
    If ::lAdjLastCol
       aSizes[Len(aSizes)]:= nBrwWidth // Me aseguro que sea bien ancho
    EndIf
    For nCol = ::nColPos To Len( aSizes )
        If nMCol <= ( nAcum + aSizes[nCol] )
           return nCol
        EndIf
        nAcum+= aSizes[nCol]
        If nAcum >= nBrwWidth
           Exit
        EndIf
    Next

return 0

//----------------------------------------------------------------------------//
METHOD Set3DStyle() CLASS TWbrowse  // Ver como en las viejas epocas !!!

   ::nLineStyle    := LINES_3D

   // Cabeceras
   ::nClrForeHead  := GetSysColor( COLOR_CAPTIONTEXT )
   ::nClrBackHead  := GetSysColor( COLOR_ACTIVECAPTION )

   // Footers
   ::nClrFFore     := ::nClrForeHead
   ::nClrFBack     := ::nClrBackHead

   // Barra Seleccion SI_Focus
   ::nClrBackFocus := CLR_CYAN
   ::nClrForeFocus := CLR_WHITE

   // Barra Seleccion NO_Focus
   ::nClrNFBack    := CLR_GRAY
   ::nClrNFFore    := CLR_WHITE

   // Color de Celdas no seleccionadas del grid
   ::SetColor( CLR_BLACK, GetSysColor( COLOR_BTNFACE ) )

   ::Refresh()

return nil

//----------------------------------------------------------------------------//

METHOD aBrwPosRect( nCol, nRow ) CLASS TWBrowse

   LOCAL nColIni  := ::nColPos
   LOCAL aColSizes:= ::aColSizes
   LOCAL aDim, nWidth, nHeight

    DEFAULT nCol  := ::nColPos
    DEFAULT nRow  := ::nRowPos

    If nCol < nColIni
       nColIni:= nCol
    EndIf

    aDim    := WBrwRect( ::hWnd, nRow, aColSizes, nColIni, nCol, ::nLineStyle, VSCROLL_WIDTH )

    nWidth  := aDim[ 4 ] - aDim[ 2 ] - 1
    nHeight := aDim[ 3 ] - aDim[ 1 ] - 1

    If ::nLineStyle == 3  // Porque el pintado lo hace 1 mas abajo y 1 mas derecha
       aDim[1]--
       aDim[2]--
       aDim[3]--
       aDim[4]--
    EndIf
    aDim[1]+= 2 + If( "TDIALOG" $ ::oWnd:ClassName, 1, 0 )
    aDim[2]+= 2 + If( "TDIALOG" $ ::oWnd:ClassName, 1, 0 )

return { aDim[1], aDim[2], aDim[3] + nWidth, aDim[4] + nHeight, nWidth, nHeight }

//----------------------------------------------------------------------------//

METHOD EditCol( nCol, uVar, cPicture, bValid, nClrFore, nClrBack, aItems,;
                bAction ) CLASS TWBrowse

   local oFont
   local uTemp
   local aDim, aPos
   local cType
   local nWidth, nHeight

   LOCAL nColorCol  // CeSoTech

   DEFAULT nCol := ::nColAct

   If nClrFore == Nil
      If "B"$Valtype( ::bTextColor ) .and. ;
         "N"$Valtype( nColorCol:= Eval( ::bTextColor, ::nRowPos, nCol ) )

         nClrFore:= nColorCol
      Else
         nClrFore := ::nClrText
      EndIf
   EndIf

   If nClrBack == Nil
      If "B"$Valtype( ::bBkColor ) .and. ;
         "N"$Valtype( nColorCol:= Eval( ::bBkColor, ::nRowPos, nCol ) )

         nClrBack:= nColorCol
      Else
         nClrBack := ::nClrPane
      EndIf
   EndIf

   // CeSoTech // -> Si son bloques de codigo habia RTError
   If "B"$ValType( nClrFore )
      nClrFore:= Eval( nClrFore )
   EndIf
   If "B"$ValType( nClrBack )
      nClrBack:= Eval( nClrBack )
   EndIf


   uTemp   := uVar

   aDim    := ::aBrwPosRect( nCol )


   aPos    := { aDim[ 1 ], aDim[ 2 ] }
   cType   := ValType( uVar )

   nWidth  := aDim[ 4 ] - aDim[ 2 ]
   nWidth  := ::aColSizes[nCol]
   nHeight := aDim[ 3 ] - aDim[ 1 ]

   ScreenToClient( Self:hWnd, aPos )

   IF ::lCellStyle .and. nCol != ::nColAct
        ::nColAct := nCol
         if ::oHScroll != nil
            ::oHScroll:SetPos(nCol)
         endif
        ::Refresh(.F.)
   ENDIF

   DEFAULT nClrFore := ::nClrText ,;
           nClrBack := ::nClrPane ,;
           bValid   := {|| nil }

   if ::oGet != nil .AND. ! Empty( ::oGet:hWnd )
      ::oGet:End()
   endif

   if ::oFont != nil
      oFont = TFont():New( ::oFont:cFaceName, ::oFont:nWidth,;
                           ::oFont:nHeight, .f., ::oFont:lBold )
   endif

   do case
      case cType == "L"
           DEFAULT aItems := { ".T.", ".F." }
           uVar = If( uTemp, aItems[ 1 ], aItems[ 2 ] )
           @  aPos[ 1 ] + 1, aPos[ 2 ] + 1 COMBOBOX ::oGet VAR uVar ITEMS aItems ;
              SIZE  Min(100,Max(nWidth,50)), 100 OF Self ;
              FONT oFont COLOR nClrFore, nClrBack ;
              ON CHANGE ::End() ;
              PIXEL

      case aItems != nil
           @  aPos[ 1 ] + 1, aPos[ 2 ] + 1 COMBOBOX ::oGet VAR uVar ITEMS aItems ;
              SIZE nWidth, Max( 200, Len( aItems ) * 25 ) OF Self ;
              FONT oFont COLOR nClrFore, nClrBack ;
              ON CHANGE ::End() ;
              PIXEL

      otherwise

          @ aPos[ 1 ] + 1, aPos[ 2 ] + 1 GET ::oGet VAR uVar ;
               SIZE nWidth, nHeight ;
               OF Self ;
               FONT oFont COLOR nClrFore, nClrBack ;
               PIXEL

          ::oGet:oGet:Picture = cPicture
   endcase

   ::nLastKey := 0
   ::oGet:Set3dLook()
   ::oGet:SetFocus()

   if ::oGet:ClassName() != "TGET"
      ::oGet:Refresh()
   endif

   ::oGet:bLostFocus := {|| If( ::oGet:ClassName() == "TGET",;
      ( ::oGet:Assign(), ::oGet:VarPut( ::oGet:oGet:VarGet())),;
      ::oGet:VarPut( If( cType == "L", ( uVar == aItems[ 1 ] ), ::oGet:VarGet() ) ) ),;
      If( Self:nLastKey != VK_ESCAPE,;
      Eval( bValid, uVar, Self:nLastKey ),;
      Eval( bValid, nil, Self:nLastKey ) ),;
      ::oGet:End() }

   ::oGet:bKeyDown := { | nKey | If( nKey == VK_RETURN .or. ;
                                     nKey == VK_ESCAPE,;
                        ( Self:nLastKey := nKey, ::oGet:End()), ) }
return .f.

//----------------------------------------------------------------------------//

METHOD Edit( nCol, lModal ) CLASS TWBrowse  // by CeSoTech
 local oDlg
 LOCAL oTWBrowse:= Self

    DEFINE DIALOG oDlg FROM 0,0 to 0,0  ;
      STYLE nOR( WS_VISIBLE, WS_POPUP ) PIXEL
      oDlg:bStart:= {|| __Edit( oTWBrowse, nCol, lModal ), oDlg:End() }
    ACTIVATE DIALOG oDlg
return Nil

//----------------------------------------------------------------------------//
// METHOD Edit( nCol, lModal ) CLASS TWBrowse
STATIC Function __Edit(Self, nCol, lModal )  // by CeSoTech

 LOCAL nCols:=  Len( Eval( ::bLine ) ), nFail:= 0 // CeSoTech
 LOCAL lFirstEdit:= .T.
 LOCAL uControl, nControl:= 0
 LOCAL lDrawSelect:= ::lDrawSelect
 LOCAL lCellStyle := ::lCellStyle


// Valores nControl  0 No Continuar
//                   1 Contiunar en Proxima Celda
//                   2 Contiunar en Proxima Fila (desde 1ra col)
//                   3 Contiunar en Proxima Fila (desde la misma col)
//                  -1 Contiunar en Anterior Celda
//                  -2 Contiunar en Anterior Fila (desde 1ra.Col)
//                  -3 Contiunar en Anterior Fila (desde la misma col)



   local uTemp, cType, lAutoSave, lContinue:= .T. //Poner valor por defecto

   // Igualo el color del Foco al fondo para que no chispee cuando cambio
   ::lDrawSelect:= .F.
   ::lCellStyle := .T.

   ::DrawSelect()


   DEFAULT nCol := 1, lModal := .t.

   ::GotoCol( nCol )

   DO
      uTemp = Eval( ::bLine )[ nCol ]

      /* CeSoTech No debo editar columnas invisibles ni BitMaps */
      If ::GetColSizes()[ nCol ] > 0 .and. ! "N" $ ValType( uTemp )

        nFail:= 0

        If ::bEdit != Nil // Bloque particular de Edicion
            uControl:= Eval( ::bEdit, nCol, uTemp, lFirstEdit )
            lFirstEdit:= .F.
            Do Case
            Case "L" $ ValType( uControl )
               If uControl
                  lContinue:= .T.
                  nControl:= 1
               Else
                  lContinue:= .F.
                  nControl:= 0
               EndIf
            Case "N" $ ValType( uControl )
               If uControl < -3 .or. uControl > 3 .or. uControl == 0
                  lContinue:= .F.
                  nControl:= 0
               Else
                  lContinue:= .T.
                  nControl:= uControl
               EndIf
            Otherwise
               lContinue:= .F.
               nControl:= 0
            EndCase


        Else

           if ! Empty( ::cAlias ) .and. Upper( ::cAlias ) != "ARRAY" .and. Upper( ::cAlias ) != "_TXT_"
              lAutoSave = ( cValToChar( ( ::cAlias )->( FieldGet( nCol ) ) ) == uTemp )
              if ( ::cAlias )->( dbRLock() )
                 if lContinue := ::lEditCol( nCol, @uTemp )
                    if lAutoSave
                       cType = ValType( ( ::cAlias )->( FieldGet( nCol ) ) )
                       do case
                          case cType == "D"
                             ( ::cAlias )->( FieldPut( nCol, CToD( uTemp ) ) )

                          case cType == "L"
                             ( ::cAlias )->( FieldPut( nCol, Upper( uTemp ) == ".T." ) )

                          case cType == "N"
                             ( ::cAlias )->( FieldPut( nCol, Val( uTemp ) ) )

                          otherwise
                             ( ::cAlias )->( FieldPut( nCol, uTemp ) )
                       endcase
                    endif
                    ::DrawSelect()
                 endif
                 ( ::cAlias )->( DbUnLock() )
              else
                 MsgStop( "Record locked!", "Please, try again" )
              endif
           else
              ::lEditCol( nCol, @uTemp )
           endif

        EndIf

      Else

        nFail++
        If nFail > nCols
           lContinue:= .F.
        EndIf

      EndIf


////////////////////////////
/////// Nueva Rutina ///////
////////////////////////////

      if lContinue .and. ( ::lAutoSkip .or. nControl <> 0 )

         //  1 Contiunar en Proxima Celda
         //  2 Contiunar en Proxima Fila (desde 1ra col)
         //  3 Contiunar en Proxima Fila (desde la misma col)
         // -1 Contiunar en Anterior Celda
         // -2 Contiunar en Anterior Fila (desde 1ra.Col)
         // -3 Contiunar en Anterior Fila (desde la misma col)

         Do Case

         Case nControl == 1 .or. nControl == 0 // Proxima Celda
              nCol++
              If nCol > nCols
                 nCol:= 1
                 ::GoDown()
                 ::GotoCol( nCol )
              Else
                 ::GoRight()
              EndIf

         Case nControl == 2  // Proxima Fila (desde 1ra col)
              ::GoToCol( 1 )
              nCol:= 1
              ::GoDown()
              nControl:= 1   && Por si fallara sino seria un loop infinito


         Case nControl == 3  // Proxima Fila (desde misma col)
              ::GoDown()

         Case nControl == -1  // Anterior Celda
              nCol--
              If nCol < 1
                 nCol:= nCols
                 ::GoUp()
                 ::GotoCol( nCol )
              Else
                 ::GoLeft()
              EndIf

         Case nControl == -2  // Anterior Fila (desde 1ra col)
              nCol:= 1
              ::GoToCol( 1 )
              ::GoUp()
              nControl:= 1  && Por si fallara sino seria un loop infinito

         Case nControl == -3  // Anterior Fila (desde misma col)
              ::GoUp()
         EndCase

         If ::oHScroll != Nil
            ::oHScroll:SetPos( nCol )
         EndIf

      EndIf

////////////////////////////
/////// Fin.. Rutina ///////
////////////////////////////


   UNTIL ! ( ::lAutoSkip .and. lContinue )


   // Restauro el colores del Foco
   ::lDrawSelect:= lDrawSelect
   ::lCellStyle := lCellStyle

   If ! ::lCellStyle
      ::nColPos:= 1
      ::nColAct:= 1
      ::Refresh()
   EndIf
   If ::oHScroll != Nil
      ::oHScroll:SetPos( ::nColAct )
   EndIf

   ::DrawSelect()

return nil

//----------------------------------------------------------------------------//
METHOD lEditCol( nCol, uVar, cPicture, bValid, nClrFore, nClrBack, aItems, bAction, bOnInit, bOnCreate, bOnStart ) CLASS TWBrowse

   local oDlg, oGet, oFont, oBtn
   local uTemp
   local aDim
   local lOk
   local cType
   LOCAL uJustify
   LOCAL bInit
   local nDif

   LOCAL nColorCol  // CeSoTech
   LOCAL bOldValid

   DEFAULT nCol      := ::nColAct,;
           bAction   := {|| .T. },;
           bOnInit   := {|| .T. },;
           bOnStart  := {|| .T. }

   If nClrFore == Nil
      If "B"$Valtype( ::bTextColor ) .and. ;
         "N"$Valtype( nColorCol := Eval( ::bTextColor, ::nRowPos, nCol ) )

         nClrFore:= nColorCol
      Else
         nClrFore := ::nClrText
      EndIf
   EndIf

   If nClrBack == Nil
      If "B"$Valtype( ::bBkColor ) .and. ;
         "N"$Valtype( nColorCol:= Eval( ::bBkColor, ::nRowPos, nCol ) )

         nClrBack:= nColorCol
      Else
         nClrBack := ::nClrPane
      EndIf
   EndIf

   // CeSoTech // -> Si son bloques de codigo habia RTError
   If "B"$ValType( nClrFore )
      nClrFore:= Eval( nClrFore )
   EndIf
   If "B"$ValType( nClrBack )
      nClrBack:= Eval( nClrBack )
   EndIf


   uTemp  := uVar

   aDim   := ::aBrwPosRect( nCol )


   lOk    := .f.
   cType  := ValType( uVar )

   IF ::lCellStyle .and. nCol != ::nColAct
        ::nColAct := nCol
         if ::oHScroll != nil
            ::oHScroll:SetPos(nCol)
         endif
        ::Refresh(.F.)
   ENDIF

   DEFINE DIALOG oDlg FROM 0,0 TO 0,0 ;
                 STYLE nOR( WS_VISIBLE, WS_POPUP, 4 ) PIXEL ;
                 COLOR nClrFore, nClrBack

   if ::oFont != nil
      oFont = TFont():New( ::oFont:cFaceName, ::oFont:nWidth, ::oFont:nHeight, .f., ::oFont:lBold )
   endif

   do case
      case cType == "L"
           DEFAULT aItems := { ".T.", ".F." }
           uVar = If( uTemp, aItems[ 1 ], aItems[ 2 ] )
           @  0, 0 COMBOBOX oGet VAR uVar ITEMS aItems ;
              SIZE ( aDim[ 4 ] - aDim[ 2 ] ) * 0.50, 50 OF oDlg ;
              ON CHANGE ( oDlg:End(), lOk := .t. ) ;
              FONT oFont COLOR nClrFore, nClrBack

      case aItems != nil
           @  0, 0 COMBOBOX oGet VAR uVar ITEMS aItems ;
              SIZE ( aDim[ 4 ] - aDim[ 2 ] ) * 0.50, 50 OF oDlg ;
              ON CHANGE ( oDlg:End(), lOk := .t. ) ;
              FONT oFont COLOR nClrFore, nClrBack

      otherwise

         If cType == "C" .and. At( CRLF, uVar ) > 0  // MULTILINE
            @  0, 0 GET oGet VAR uVar MEMO NO VSCROLL ;
               SIZE 0,0 OF oDlg FONT oFont COLOR nClrFore, nClrBack NOBORDER
            oGet:bGotFocus := {|| PostMessage(oGet:hWnd, EM_SETSEL, 0, 0)}
         else
            @  0, 0 GET oGet VAR uVar ;
                        SIZE     0,0 ;
                        PICTURE  cPicture ;
                        OF       oDlg ;
                        FONT     oFont ;
                        COLOR    nClrFore, nClrBack ;
                        NOBORDER
         EndIf



         //////////// Ini //////////////
         //// Justificacion del GET ////
         ///////////////////////////////

         If ValType( ::aJustify ) $ "AB"
            If "B" $ ValType( ::aJustify )
               uJustify:= Eval( ::aJustify )
            Else
               uJustify:= AClone( ::aJustify )
            EndIf
            If nCol <= Len( uJustify )
               uJustify:= uJustify[ nCol ]

               If "L" $ ValType( uJustify )
                  uJustify:= If( uJustify, 1, 0 )
               ElseIf ! "N" $ ValType( uJustify )
                  uJustify:= 0
               EndIf

               If lAnd( uJustify, HA_RIGHT )
                  oGet:nStyle:= nOr( oGet:nStyle, ES_RIGHT )
               ElseIf lAnd( uJustify, HA_CENTER )
                  oGet:nStyle:= nOr( oGet:nStyle, ES_CENTER )
               EndIf

            EndIf
         EndIf
         //////////// Fin //////////////
         //// Justificacion del GET ////
         ///////////////////////////////

   EndCase


   DEFAULT bOnCreate:= {|oGet, oDlg| .T. }
   Eval( bOnCreate, oGet, oDlg )

   bOldValid:= oGet:bValid
   DEFAULT bOldValid:= {|| .T. },;
           bValid   := {|| .T. }

   oGet:bValid:= {|| ValidlEditCol( Self, oGet, oDlg, bOldValid, bValid, bAction, @lOk ) }


   @ 10, 0 BUTTON oBtn PROMPT "" OF oDlg


   If ::nLineStyle == 3
      bInit:= {|| nDif:= ((aDim[6]-GetTextHeight(oGet:hWnd))/2),; //+2,;
                  oDlg:Move( aDim[ 1 ], aDim[ 2 ], aDim[ 5 ], aDim[ 6 ] ),;
                  oGet:Move( 1+nDif, 0, aDim[ 5 ], aDim[ 6 ] )  }

   Else
      bInit:= {|| nDif:= ((aDim[6]-GetTextHeight(oGet:hWnd))/2),;// +2,;
                  oDlg:Move( aDim[ 1 ], aDim[ 2 ], aDim[ 5 ], aDim[ 6 ] ),;
                  oGet:Move( 0+nDif, 1, aDim[ 5 ], aDim[ 6 ] )  }
   EndIf

   oDlg:bStart := {|| Eval( bOnStart, oGet, oDlg ) }

   ACTIVATE DIALOG oDlg ON INIT ( Eval( bInit ), Eval( bOnInit, oGet, oDlg ) )

   if ! lOk
      uVar = uTemp
   else
      if cType == "L"
         uVar = ( uVar == aItems[ 1 ] )
      endif
   endif


return lOk

//////////////////////////

static function ValidlEditCol( Self, oGet, oDlg, bOldValid, bValid, bAction, lOk )

   local lValid:= .F.
   local bOriginal

   bOriginal:= oGet:bValid
   oGet:bValid:= NIL

   if Eval( bOldValid, oGet )
      ::nLastKey:= oDlg:nLastKey
      if Eval( bValid, oGet )
         lOk:= .T.
         Eval( bAction )
         oDlg:End()
         lValid:= .T.
      endif
   endif

   oGet:bValid:= bOriginal

return lValid

//----------------------------------------------------------------------------//

METHOD SetTXT( uTXT ) CLASS TWBrowse
 LOCAL cType, oTXT

   DEFAULT uTXT:= ""
   cType:= Valtype( uTXT )

   If cType == "C"
      If !File( uTXT )
         uTXT:= cGetFile( "*.txt", "Text Files" )
         If !File( uTXT )
            return .F.
         EndIf
      EndIf
      ::oTXT:= oTXT:= TTxtFile():New( uTXT, 0 )
   ElseIf cType == "O"
      oTXT:= uTXT
   Else
      return .F.
   EndIf

   ::lDrawHeaders  := .F.
   ::aHeaders      := { "" }
   ::aJustify      := { .F. }
   ::aColSizes     := { 2000 }
   ::nLineStyle    := 0
   ::cAlias        := "_TXT_"
   ::bLine         := { |cLine| cLine:= oTXT:ReadLine(),;
                        If( IsOem( cLine ), cLine:= OemToAnsi( cLine ),),;
                        { SubStr( cLine, ::nTXTFrom ) } }
   ::bLogicLen     := { || ::nLen := oTXT:RecCount() }
   ::bLogicPos     := nil
   ::bGoLogicPos   := nil
   ::bGoTop        := { || oTXT:GoTop() }
   ::bGoBottom     := { || oTXT:GoBottom() }
   ::bSkip         := { | nSkip, nOld | nOld:= oTXT:RecNo(), ;
                                        oTXT:Skip( nSkip ),   ;
                                        oTXT:RecNo() - nOld }
return nil

//----------------------------------------------------------------------------//

METHOD VerifyLogicLen( nLogicLen ) CLASS TWBrowse

   DEFAULT nLogicLen:= 0

   if nLogicLen > 0 .and. ! Empty( ::cAlias ) .and.;
      Upper( ::cAlias ) != "ARRAY" .and. Upper( ::cAlias ) != "_TXT_"
      if (::cAlias)->( Eof() )
         (::cAlias)->( DbGoTop() )
         if (::cAlias)->( Eof() )
            nLogicLen:= 0  // Seguramente la base esta filtrada pero el indice tiene reg.-
         endif
      endif
   endif

return nLogicLen

//----------------------------------------------------------------------------//

METHOD VerifyLogicPos( nLogicPos ) CLASS TWBrowse

   DEFAULT nLogicPos:= 0

   if ::lHitTop
      nLogicPos:= 1
      ::lHitBottom:= .F.
   elseif ::lHitBottom .and. ::nLogicLen != nil
      nLogicPos:= ::nLogicLen
      ::lHitTop:= .F.
   endif

return nLogicPos

//----------------------------------------------------------------------------//
/*
METHOD cGenPrg() CLASS TWBrowse

   local cPrg        := ""

   cPrg              += "REDEFINE LISTBOX oBrw" ;
			FIELDS ;
                  (dbfFamilia)->cCodFam,;
                  (dbfFamilia)->cNomFam;
			HEAD ;
                  "Código",;
                  "Nombre";
         FIELDSIZES ;
                  60 ,;
                  200;
         ALIAS    ( dbfFamilia );
         ID       105 ;
         OF       oDlg


   local aInfo
   local hOldDC      := ::hDC

   DEFAULT lCreateDC := .F.

   if lCreateDC
      hDC            := GetDC( ::hWnd )
   else
      hDC            := ::hDC
   endif
   aInfo             := FWDispBegin( ::hWnd, hDC )

   ::hDC             := aInfo[3]

return { aInfo, if( lCreateDC, hDC, nil ), hOldDC }

//----------------------------------------------------------------------------//

METHOD DispEnd( aRestore ) CLASS TWBrowse

   local hDC, aInfo

   FWDispEnd( aRestore[1] )

   if aRestore[2] != nil
      ReleaseDC( aRestore[2] )
   endif

   ::hDC             := aRestore[3]

return nil
*/

//----------------------------------------------------------------------------//

Method RightButtonDown( nRow, nCol, nFlags ) CLASS TWBrowse

   local oMenu
   local bMenuSelect

   if oUser():lAdministrador()

      if !::IsOverHeader( nRow, nCol )

         oMenu          := MenuBegin( .t. )
         bMenuSelect    := ::bMenuSelect

         ::bMenuSelect  := nil

         MenuAddItem( "Exportar a E&xcel", "Exportar rejilla de datos a Excel", .f., .t., {|| ::ExportToExcel() }, , "gc_spreadsheet_sum_16", oMenu )

         MenuAddItem( "Exportar a &Word", "Exportar rejilla de datos a Word", .f., .t., {|| ::ExportToWord() }, , "gc_document_text_16", oMenu )

         MenuEnd()

         oMenu:Activate( nRow, nCol, Self )

         ::bMenuSelect  := bMenuSelect

      end if

   end if

Return Self

//----------------------------------------------------------------------------//