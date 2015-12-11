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
static cFicheroAgentes     := "agentes.xls"
static cFicheroFamilias    := "familias.xls"
static cFicheroArticulos   := "articulos.xls"
static cFicheroClientes    := "clientes.xls"
static cFicheroCategoria   := "categoria.xls"
static cFicheroFPago       := "fpago.xls"
static cFicheroTipoCliente := "tipocliente.xls"
static cFicheroZonas       := "zonas.xls"
static cFicheroProveedores := "proveedores.xls"

//---------------------------------------------------------------------------//

function InicioHRB()

   if !OpenFiles( .f. )
      return .f.
   end if

   CursorWait()
   
   if MsgYesNo( "Importar agentes", "" )
      ImportacionAgentes()
   end if

   if MsgYesNo( "Importar familias", "" )
      ImportacionFamilias()
   end if

   if MsgYesNo( "Importar artículos", "" )
      ImportacionArticulos()
   end if

   if MsgYesNo( "Importar categorias", "" )
      ImportacionCategorias()
   end if

   if MsgYesNo( "Importar clientes", "" )
      ImportacionClientes()
   end if

   if MsgYesNo( "Formas de pago", "" )
      ImportacionFPago()
   end if

   /*if MsgYesNo( "Grupos de clientes", "" )
      ImportacionGrupoCliente()
   end if*/

   if MsgYesNo( "Ruta", "" )
      ImportacionRuta()
   end if

   if MsgYesNo( "Proveedores", "" )
      ImportacionProveedores()
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

Static Function ImportacionAgentes()

   local n

   msgwait( "Importamos agentes", , .1 )

   Conexion( cFicheroAgentes )

   for n := nLineaComienzo to 65536

      /*
      Si no encontramos mas líneas nos salimos------------------------------
      */

      if Empty( oOleExcel:oExcel:ActiveSheet:Range( "B" + lTrim( Str( n ) ) ):Value )
         Exit
      end if

      ( D():Agentes( nView ) )->( dbAppend() )

      ( D():Agentes( nView ) )->cCodAge   := GetRange( "B", n )
      ( D():Agentes( nView ) )->cNbrAge   := GetRange( "C", n )
      ( D():Agentes( nView ) )->nCom1     := GetNumeric( "E", n )
      ( D():Agentes( nView ) )->cDniNif   := GetRange( "K", n )
      ( D():Agentes( nView ) )->cDirAge   := GetRange( "F", n )
      ( D():Agentes( nView ) )->cPobAge   := GetRange( "G", n )
      ( D():Agentes( nView ) )->cProv     := GetRange( "I", n )
      ( D():Agentes( nView ) )->cPtlAge   := GetRange( "H", n )
      ( D():Agentes( nView ) )->cTfoAge   := GetRange( "J", n )

      ( D():Agentes( nView ) )->( dbUnlock() )

      msgwait( "Procesando agentes: " + str( n ), , .001 )

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

      ( D():Familias( nView ) )->( dbAppend() )

      ( D():Familias( nView ) )->cCodFam   := GetRange( "B", n )
      ( D():Familias( nView ) )->cNomFam   := GetRange( "C", n )

      ( D():Familias( nView ) )->( dbUnlock() )

      msgwait( "Procesando familias: " + str( n ), , .001 )

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

      ( D():Articulos( nView ) )->Codigo        := GetRange( "B", n )
      ( D():Articulos( nView ) )->Nombre        := GetRange( "S", n )
      ( D():Articulos( nView ) )->Familia       := GetRange( "F", n )
      ( D():Articulos( nView ) )->cCodCate      := GetRange( "AD", n )

      ( D():Articulos( nView ) )->TipoIva       := cCodTerToCodIva( Str( GetNumeric( "L", n ), 1 ), D():TiposIva( nView ) )

      ( D():Articulos( nView ) )->pCosto        := GetNumeric( "M", n )
      ( D():Articulos( nView ) )->pVenta1       := GetNumeric( "H", n )
      ( D():Articulos( nView ) )->pVenta2       := GetNumeric( "I", n )
      ( D():Articulos( nView ) )->pVenta3       := GetNumeric( "J", n )
      ( D():Articulos( nView ) )->pVenta4       := GetNumeric( "K", n )

      ( D():Articulos( nView ) )->cCodEdi       := GetRange( "EZ", n )

      ( D():Articulos( nView ) )->cRefAux       := GetRange( "N", n )
      ( D():Articulos( nView ) )->cRefAux2      := GetRange( "BA", n )

      cCodBar                                   := GetRange( "E", n )

      if !Empty( cCodBar )

         ( D():ArticulosCodigosBarras( nView ) )->( dbAppend() )

         ( D():ArticulosCodigosBarras( nView ) )->cCodArt   := GetRange( "B", n )
         ( D():ArticulosCodigosBarras( nView ) )->cCodBar   := cCodBar

         ( D():ArticulosCodigosBarras( nView ) )->( dbUnlock() )

      end if

      ImportaArticulosCamposExtra( n )

      ( D():Articulos( nView ) )->( dbUnlock() )

      //msgwait( "Procesando artículos: " + str( n ), , .0001 )

   next

   Desconexion()

Return ( .t. )

//----------------------------------------------------------------------------//

Static Function ImportaArticulosCamposExtra( nLin )

   ImportaCampoExtra( "001", "Q", nLin, "C" ) //Memo

   ImportaCampoExtra( "002", "N", nLin, "C" ) //Referencia

   ImportaCampoExtra( "003", "BA", nLin, "C" ) //Auxiliar

   ImportaCampoExtra( "004", "DJ", nLin, "C" ) //Barco

   ImportaCampoExtra( "005", "DR", nLin, "C" ) //Observaciones ventas

   ImportaCampoExtra( "006", "AQ", nLin, "C" ) //Factor

   ImportaCampoExtra( "007", "DU", nLin, "C" ) //Nombre científico

   ImportaCampoExtra( "008", "DV", nLin, "C" ) //Composición

   ImportaCampoExtra( "009", "DW", nLin, "C" ) //Neto

   ImportaCampoExtra( "010", "DX", nLin, "C" ) //Conservación

   ImportaCampoExtra( "011", "DY", nLin, "C" ) //Lugar procedencia

   ImportaCampoExtra( "012", "ED", nLin, "C" ) //Formato

   ImportaCampoExtra( "013", "EE", nLin, "C" ) //Talla

   ImportaCampoExtra( "014", "EF", nLin, "C" ) //Presentación

   ImportaCampoExtra( "015", "EG", nLin, "C" ) //Origen

   ImportaCampoExtra( "016", "EH", nLin, "C" ) //Observación formato

   ImportaCampoExtra( "017", "FI", nLin, "C" ) //Descripción aAlternativa

   ImportaCampoExtra( "018", "DL", nLin, "N" ) //Marea

   ImportaCampoExtra( "019", "DS", nLin, "D" ) //Fecha pedido

Return ( .t. )

//----------------------------------------------------------------------------//

Static Function ImportaCampoExtra( cCod, cCol, nLin, cType )

   local cValor      := ""
   //DEFAULT lNum      := .f.

   do case
      case cType == "C"
         cValor      := GetRange( cCol, nLin )

      case cType == "N"
         cValor      := int( GetNumeric( cCol, nLin ) )
         cValor      := if( cValor != 0, Str( cValor ), "" )

      case cType == "D"
         cValor      := GetDate( cCol, nLin )

   end case

   if !Empty( cValor )

      ( D():DetCamposExtras( nView ) )->( dbAppend() )

      ( D():DetCamposExtras( nView ) )->cTipDoc    := ART_TBL
      ( D():DetCamposExtras( nView ) )->cCodTipo   := cCod
      ( D():DetCamposExtras( nView ) )->cClave     := GetRange( "B", nLin )
      ( D():DetCamposExtras( nView ) )->cValor     := cValor

      ( D():DetCamposExtras( nView ) )->( dbUnlock() )

   end if

Return ( .t. )

//----------------------------------------------------------------------------//

Static Function ImportacionClientes()

   local n
   local cCodigoCliente    := ""
   local cMail

   msgwait( "Importamos clientes", , .1 )

   Conexion( cFicheroClientes )

   for n := nLineaComienzo to 65536

      /*
      Si no encontramos mas líneas nos salimos------------------------------
      */

      if Empty( oOleExcel:oExcel:ActiveSheet:Range( "B" + lTrim( Str( n ) ) ):Value )
         Exit
      end if

      cCodigoCliente                         := GetRange( "B", n )

      if At( ".", cCodigoCliente ) == 0

         ( D():Clientes( nView ) )->( dbAppend() )

         ( D():Clientes( nView ) )->Cod         := Padr( RJust( cCodigoCliente, "0", RetNumCodCliEmp() ), 12 )
         ( D():Clientes( nView ) )->Titulo      := GetRange( "C", n )
         ( D():Clientes( nView ) )->Domicilio   := GetRange( "G", n )
         ( D():Clientes( nView ) )->Poblacion   := GetRange( "H", n )
         ( D():Clientes( nView ) )->Provincia   := GetRange( "I", n )
         ( D():Clientes( nView ) )->CodPostal   := GetRange( "J", n )
         ( D():Clientes( nView ) )->Nif         := GetRange( "K", n )
         ( D():Clientes( nView ) )->SubCta      := GetRange( "L", n )
         ( D():Clientes( nView ) )->Telefono    := GetRange( "M", n )
         ( D():Clientes( nView ) )->Telefono2   := GetRange( "N", n )
         
         cMail                                  := GetRange( "O", n )

         if At( "@", cMail ) != 0
            ( D():Clientes( nView ) )->cMeiInt  := cMail
         else
            ( D():Clientes( nView ) )->mComent  := cMail
         end if

         ( D():Clientes( nView ) )->Fax         := GetRange( "P", n )
         ( D():Clientes( nView ) )->CodPago     := GetRange( "AK", n )
         ( D():Clientes( nView ) )->lReq        := ( AllTrim( GetRange( "AM", n ) ) == "S" )
         ( D():Clientes( nView ) )->cDtoEsp     := "General"
         ( D():Clientes( nView ) )->nDtoEsp     := GetNumeric( "AN", n )
         ( D():Clientes( nView ) )->cDpp        := "Pronto pago"
         ( D():Clientes( nView ) )->nDpp        := GetNumeric( "AO", n )
         ( D():Clientes( nView ) )->cAgente     := GetRange( "AQ", n )
         ( D():Clientes( nView ) )->Riesgo      := GetNumeric( "AR", n )
         ( D():Clientes( nView ) )->mObserv     := GetRange( "AQ", n )
         ( D():Clientes( nView ) )->cCodRut     := GetRange( "F", n )
         //( D():Clientes( nView ) )->cCodGrp     := GetRange( "D", n )
         ( D():Clientes( nView ) )->cCodEdi     := GetRange( "EG", n )
         ( D():Clientes( nView ) )->cDeparta    := if( Empty( GetRange( "EA", n ) ), "", Padr( RJust( GetRange( "EA", n ), "0", 4 ), 4 ) )
         ( D():Clientes( nView ) )->lChgPre     := .t.
         ( D():Clientes( nView ) )->cDomEnt     := GetRange( "Z", n )
         ( D():Clientes( nView ) )->cPobEnt     := GetRange( "AA", n )
         ( D():Clientes( nView ) )->cCpEnt      := GetRange( "AC", n )
         ( D():Clientes( nView ) )->cPrvEnt     := GetRange( "AB", n )
         ( D():Clientes( nView ) )->cProvee     := GetRange( "BE", n )
         ( D():Clientes( nView ) )->cCodBic     := GetRange( "EO", n )
         ( D():Clientes( nView ) )->cHorario    := GetRange( "BD", n )

         ( D():Clientes( nView ) )->( dbUnlock() )

         if !Empty( GetRange( "AG", n ) )

            ( D():ClientesBancos( nView ) )->( dbAppend() )

            ( D():ClientesBancos( nView ) )->cCodCli  := Padr( RJust( cCodigoCliente, "0", RetNumCodCliEmp() ), 12 )
            ( D():ClientesBancos( nView ) )->lBncDef  := .t.
            ( D():ClientesBancos( nView ) )->cEntBnc  := GetRange( "AH", n )
            ( D():ClientesBancos( nView ) )->cSucBnc  := GetRange( "AI", n )
            ( D():ClientesBancos( nView ) )->cDigBnc  := GetRange( "AJ", n )
            ( D():ClientesBancos( nView ) )->cCtaBnc  := GetRange( "AG", n )

            ( D():ClientesBancos( nView ) )->( dbUnlock() )

         end if

      else

         ( D():ClientesDirecciones( nView ) )->( dbAppend() )

         ( D():ClientesDirecciones( nView ) )->cCodCli   := Padr( RJust( Substr( cCodigoCliente, 1, 3 ), "0", RetNumCodCliEmp() ), 12 )
         ( D():ClientesDirecciones( nView ) )->cCodObr   := Substr( cCodigoCliente, 5 )
         ( D():ClientesDirecciones( nView ) )->cNomObr   := GetRange( "C", n )
         ( D():ClientesDirecciones( nView ) )->cDirObr   := GetRange( "G", n )
         ( D():ClientesDirecciones( nView ) )->cPobObr   := GetRange( "H", n )
         ( D():ClientesDirecciones( nView ) )->cPrvObr   := GetRange( "I", n )
         ( D():ClientesDirecciones( nView ) )->cPosObr   := GetRange( "J", n )
         ( D():ClientesDirecciones( nView ) )->cTelObr   := GetRange( "M", n )
         ( D():ClientesDirecciones( nView ) )->cFaxObr   := GetRange( "P", n )
         ( D():ClientesDirecciones( nView ) )->cCodEdi   := GetRange( "EG", n )
         ( D():ClientesDirecciones( nView ) )->cDeparta  := if( Empty( GetRange( "EA", n ) ), "", Padr( RJust( GetRange( "EA", n ), "0", 4 ), 4 ) )

         ( D():ClientesDirecciones( nView ) )->Nif       := GetRange( "K", n )
         ( D():ClientesDirecciones( nView ) )->cDomEnt   := GetRange( "Z", n )
         ( D():ClientesDirecciones( nView ) )->cPobEnt   := GetRange( "AA", n )
         ( D():ClientesDirecciones( nView ) )->cCpEnt    := GetRange( "AC", n )
         ( D():ClientesDirecciones( nView ) )->cPrvEnt   := GetRange( "AB", n )
         ( D():ClientesDirecciones( nView ) )->cProvee   := GetRange( "BE", n )
         ( D():ClientesDirecciones( nView ) )->cCodBic     := GetRange( "EO", n )
         ( D():ClientesDirecciones( nView ) )->cHorario    := GetRange( "BD", n )

         ( D():ClientesDirecciones( nView ) )->( dbUnlock() )
      
      end if   

         msgwait( "Procesando clientes: " + str( n ), , .001 )

   next

   Desconexion()

Return ( .t. )

//----------------------------------------------------------------------------//

Static Function ImportacionCategorias()

   local n

   msgwait( "Importamos categorias", , .1 )

   Conexion( cFicheroCategoria )

   for n := nLineaComienzo to 65536

      /*
      Si no encontramos mas líneas nos salimos------------------------------
      */

      if Empty( oOleExcel:oExcel:ActiveSheet:Range( "B" + lTrim( Str( n ) ) ):Value )
         Exit
      end if

      ( D():Categorias( nView ) )->( dbAppend() )

      ( D():Categorias( nView ) )->cCodigo          := GetRange( "B", n )
      ( D():Categorias( nView ) )->cNombre          := GetRange( "C", n )

      ( D():Categorias( nView ) )->( dbUnlock() )

      msgwait( "Procesando categorias: " + str( n ), , .001 )

   next

   Desconexion()

Return ( .t. )

//----------------------------------------------------------------------------//

Static Function ImportacionFPago()

   local n

   msgwait( "Importamos formas de pago", , .1 )

   Conexion( cFicheroFPago )

   for n := nLineaComienzo to 65536

      /*
      Si no encontramos mas líneas nos salimos------------------------------
      */

      if Empty( oOleExcel:oExcel:ActiveSheet:Range( "B" + lTrim( Str( n ) ) ):Value )
         Exit
      end if

      ( D():FormasPago( nView ) )->( dbAppend() )

      ( D():FormasPago( nView ) )->cCodPago          := GetRange( "B", n )
      ( D():FormasPago( nView ) )->cDesPago          := GetRange( "E", n )
      ( D():FormasPago( nView ) )->nPlaUno           := GetNumeric( "D", n )
      ( D():FormasPago( nView ) )->nPlazos           := 1

      ( D():FormasPago( nView ) )->( dbUnlock() )

      msgwait( "Procesando fomas de pago: " + str( n ), , .001 )

   next

   Desconexion()

Return ( .t. )

//----------------------------------------------------------------------------//

Static Function ImportacionGrupoCliente()

   local n

   msgwait( "Importamos grupo de clientes", , .1 )

   Conexion( cFicheroTipoCliente )

   for n := nLineaComienzo to 65536

      /*
      Si no encontramos mas líneas nos salimos------------------------------
      */

      if Empty( oOleExcel:oExcel:ActiveSheet:Range( "B" + lTrim( Str( n ) ) ):Value )
         Exit
      end if

      ( D():GrupoClientes( nView ) )->( dbAppend() )

      ( D():GrupoClientes( nView ) )->cCodGrp          := RJust( GetRange( "B", n ), "0", 4 )
      ( D():GrupoClientes( nView ) )->cNomGrp          := GetRange( "C", n )

      ( D():GrupoClientes( nView ) )->( dbUnlock() )

      msgwait( "Procesando grupo de clientes: " + str( n ), , .001 )

   next

   Desconexion()

Return ( .t. )

//---------------------------------------------------------------------------//

Static Function ImportacionRuta()

   local n

   msgwait( "Importamos ruta", , .1 )

   Conexion( cFicheroZonas )

   for n := nLineaComienzo to 65536

      /*
      Si no encontramos mas líneas nos salimos------------------------------
      */

      if Empty( oOleExcel:oExcel:ActiveSheet:Range( "B" + lTrim( Str( n ) ) ):Value )
         Exit
      end if

      ( D():Ruta( nView ) )->( dbAppend() )

      ( D():Ruta( nView ) )->cCodRut          := GetRange( "B", n )
      ( D():Ruta( nView ) )->cDesRut          := GetRange( "C", n )

      ( D():Ruta( nView ) )->( dbUnlock() )

      msgwait( "Procesando rutas: " + str( n ), , .001 )

   next

   Desconexion()

Return ( .t. )

//---------------------------------------------------------------------------//

Static Function ImportacionProveedores()

   local n

   msgwait( "Importamos proveedores", , .1 )

   Conexion( cFicheroProveedores )

   for n := nLineaComienzo to 65536

      /*
      Si no encontramos mas líneas nos salimos------------------------------
      */

      if Empty( oOleExcel:oExcel:ActiveSheet:Range( "B" + lTrim( Str( n ) ) ):Value )
         Exit
      end if

      ( D():Proveedores( nView ) )->( dbAppend() )

      ( D():Proveedores( nView ) )->Cod          := GetRange( "B", n )
      ( D():Proveedores( nView ) )->Titulo       := GetRange( "C", n )
      ( D():Proveedores( nView ) )->Domicilio    := GetRange( "F", n )
      ( D():Proveedores( nView ) )->Poblacion    := GetRange( "G", n )
      ( D():Proveedores( nView ) )->Provincia    := GetRange( "H", n )
      ( D():Proveedores( nView ) )->CodPostal    := GetRange( "I", n )
      ( D():Proveedores( nView ) )->Nif          := GetRange( "J", n )
      ( D():Proveedores( nView ) )->SubCta       := GetRange( "K", n )
      ( D():Proveedores( nView ) )->Telefono     := GetRange( "L", n )
      ( D():Proveedores( nView ) )->Fax          := GetRange( "O", n )
      ( D():Proveedores( nView ) )->FPago        := GetRange( "AG", n )

      ( D():Proveedores( nView ) )->( dbUnlock() )

      msgwait( "Procesando proveedores: " + str( n ), , .001 )

   next

   Desconexion()

Return ( .t. )

//---------------------------------------------------------------------------//