//Sat de clientes--------------------------------------------------------------
//Hay que crear los siguientes estados de artículos
//000 - Instalación - No Disponible
//001 - Revisión - No Disponible
//002 - Avería - No Disponible
//003 - Retirada - Disponible
//004 - Baja - No disponible
//005 - Máquina Nueva - Disponible

#include "c:\fw195\gestool\bin\include\Factu.ch"

static nView
static nLineaComienzo   := 25015
static defSituacion     := "Finalizado"
static oOleExcel

//---------------------------------------------------------------------------//

function InicioHRB( nVista )

   nView                := nVista

   SET DATE FORMAT "mm/dd/yyyy"

   CursorWait()
   
   ImportaSat()

   SET DATE FORMAT "dd/mm/yyyy"

   Msginfo( "Importación realizada con éxito" )

return .t.

//---------------------------------------------------------------------------//

static function ImportaSat( cFichero )

   local n
   local oBlock
   local oError
   local cCodCli        := ""
   local NumeroSerie    := ""
   local cCodEst
   local Observaciones  := ""

   CursorWait()

   /*
   Creamos el objeto oOleExcel-------------------------------------------------
   */

   oOleExcel                        := TOleExcel():New( "Importando hoja de excel", "Conectando...", .f. )

   oOleExcel:oExcel:Visible         := .f.
   oOleExcel:oExcel:DisplayAlerts   := .f.
   oOleExcel:oExcel:WorkBooks:Open( "C:\ficheros\satclientes.xls" )

   oOleExcel:oExcel:WorkSheets( 1 ):Activate()

   /*
   Recorremos la hoja de calculo-----------------------------------------------
   */

   SysRefresh()

   for n := nLineaComienzo to 65536

      NumeroSerie    := cGetChar( oOleExcel:oExcel:ActiveSheet:Range( "D" + lTrim( Str( n ) ) ):Value )
      cCodCli        := oOleExcel:oExcel:ActiveSheet:Range( "AC" + lTrim( Str( n ) ) ):Value
      if !Empty( cCodCli )
         cCodCli        := Rjust( cCodCli, "0", RetNumCodCliEmp() )
      end if

      if Empty( NumeroSerie )
         Exit
      end if

      LogWrite( Str( n ) )
      MsgWait( NumeroSerie , Str( n ), 0.0005 )

      /*
      Añadimos un Sat--------------------------------------------------------
      */

      if !Empty( cCodCli )
         //!Empty( oOleExcel:oExcel:ActiveSheet:Range( "G" + lTrim( Str( n ) ) ):Value ) .or.;
         //!Empty( oOleExcel:oExcel:ActiveSheet:Range( "J" + lTrim( Str( n ) ) ):Value )

         /*
         Añadimos la cabecera--------------------------------------------------
         */

         cSerie         := "A"
         nNumero        := nNewDoc( "A", D():SatClientes( nView ), "nSatCli", , D():Contadores( nView ) )
         cSufijo        := RetSufEmp()

         ( D():SatClientes( nView ) )->( dbAppend() )

         ( D():SatClientes( nView ) )->CSERSAT     := cSerie
         ( D():SatClientes( nView ) )->NNUMSAT     := nNumero
         ( D():SatClientes( nView ) )->CSUFSAT     := cSufijo
         ( D():SatClientes( nView ) )->CTURSAT     := cCurSesion()
         ( D():SatClientes( nView ) )->DFECSAT     := FormatoFecha( oOleExcel:oExcel:ActiveSheet:Range( "P" + lTrim( Str( n ) ) ):Value )
         ( D():SatClientes( nView ) )->CCODALM     := oUser():cAlmacen()
         ( D():SatClientes( nView ) )->CCODCAJ     := oUser():cCaja()
         ( D():SatClientes( nView ) )->CCODPGO     := cDefFpg()
         ( D():SatClientes( nView ) )->lEstado     := .f.
         ( D():SatClientes( nView ) )->CDIVSAT     := cDivEmp()
         ( D():SatClientes( nView ) )->NVDVSAT     := nChgDiv( cDivEmp(), D():Divisas( nView ) )
         ( D():SatClientes( nView ) )->LSNDDOC     := .t.
         ( D():SatClientes( nView ) )->LIVAINC     := uFieldEmpresa( "lIvaInc" )
         ( D():SatClientes( nView ) )->NIVAMAN     := nIva( D():TiposIva( nView ), cDefIva() )
         ( D():SatClientes( nView ) )->cCodUsr     := cCurUsr()
         ( D():SatClientes( nView ) )->nDiaVal     := nDiasValidez()
         ( D():SatClientes( nView ) )->cCodDlg     := oUser():cDelegacion()
         ( D():SatClientes( nView ) )->dFecCre     := FormatoFecha( oOleExcel:oExcel:ActiveSheet:Range( "P" + lTrim( Str( n ) ) ):Value )
         ( D():SatClientes( nView ) )->cTimCre     := Time()
         ( D():SatClientes( nView ) )->cCodOpe     := CodigoOperario( oOleExcel:oExcel:ActiveSheet:Range( "Z" + lTrim( Str( n ) ) ):Value )
         cCodEst                                   := CodigoEstado( oOleExcel:oExcel:ActiveSheet:Range( "AI" + lTrim( Str( n ) ) ):Value )
         ( D():SatClientes( nView ) )->cCodEst     := cCodEst
         ( D():SatClientes( nView ) )->cSituac     := defSituacion
         ( D():SatClientes( nView ) )->nTarifa     := 1
         
         /*
         Buscamos el cliente y ponemos los datos del cliente-------------------
         */

         if !Empty( cCodCli )

            if ( D():Clientes( nView ) )->( dbSeek( cCodCli ) )

               ( D():SatClientes( nView ) )->cCodCli     := cCodCli
               ( D():SatClientes( nView ) )->cNomCli     := ( D():Clientes( nView ) )->Titulo
               ( D():SatClientes( nView ) )->cDirCli     := ( D():Clientes( nView ) )->Domicilio
               ( D():SatClientes( nView ) )->cPobCli     := ( D():Clientes( nView ) )->Poblacion
               ( D():SatClientes( nView ) )->cPrvCli     := ( D():Clientes( nView ) )->Provincia
               ( D():SatClientes( nView ) )->cPosCli     := ( D():Clientes( nView ) )->CodPostal
               ( D():SatClientes( nView ) )->cDniCli     := ( D():Clientes( nView ) )->Nif
               ( D():SatClientes( nView ) )->cTlfCli     := ( D():Clientes( nView ) )->Telefono
               ( D():SatClientes( nView ) )->lRecargo    := ( D():Clientes( nView ) )->lReq
               ( D():SatClientes( nView ) )->nRegIva     := ( D():Clientes( nView ) )->nRegIva
               ( D():SatClientes( nView ) )->cCodGrp     := ( D():Clientes( nView ) )->cCodGrp
               ( D():SatClientes( nView ) )->lOperPV     := ( D():Clientes( nView ) )->lPntVer
               ( D():SatClientes( nView ) )->LMODCLI     := ( D():Clientes( nView ) )->lModDat
               
            end if

         end if

         ( D():SatClientes( nView ) )->( dbUnLock() )

         /*
         Campos extra de la cabecera----------------------------------------------
         */

         CamposExtra( cSerie + Str( nNumero ) + cSufijo, n )

         /*
         Insertamos las lineas----------------------------------------------------
         */

         ( D():SatClientesLineas( nView ) )->( dbAppend() )

            ( D():SatClientesLineas( nView ) )->cSerSat     := cSerie
            ( D():SatClientesLineas( nView ) )->nNumSat     := nNumero
            ( D():SatClientesLineas( nView ) )->cSufSat     := cSufijo
            ( D():SatClientesLineas( nView ) )->cTipMov     := cDefVta()
            ( D():SatClientesLineas( nView ) )->nCanSat     := 1
            ( D():SatClientesLineas( nView ) )->nUniCaja    := 1
            ( D():SatClientesLineas( nView ) )->lIvaLin     := uFieldEmpresa( "lIvaInc" )
            ( D():SatClientesLineas( nView ) )->cAlmLin     := oUser():cAlmacen()
            ( D():SatClientesLineas( nView ) )->nTarLin     := 1
            ( D():SatClientesLineas( nView ) )->cCodCli     := cCodCli
            ( D():SatClientesLineas( nView ) )->dFecSat     := FormatoFecha( oOleExcel:oExcel:ActiveSheet:Range( "P" + lTrim( Str( n ) ) ):Value )
            ( D():SatClientesLineas( nView ) )->cRef        := NumeroSerie
            ( D():SatClientesLineas( nView ) )->cDetalle    := RetFld( NumeroSerie, D():Articulos( nView ) )
            ( D():SatClientesLineas( nView ) )->nCtlStk     := 2

            Observaciones                                   := if( !Empty( oOleExcel:oExcel:ActiveSheet:Range( "N" + lTrim( Str( n ) ) ):Value ) .and. oOleExcel:oExcel:ActiveSheet:Range( "N" + lTrim( Str( n ) ) ):Value != "NULL", oOleExcel:oExcel:ActiveSheet:Range( "N" + lTrim( Str( n ) ) ):Value, "" )
            Observaciones                                   += if( !Empty( oOleExcel:oExcel:ActiveSheet:Range( "AE" + lTrim( Str( n ) ) ):Value ) .and. oOleExcel:oExcel:ActiveSheet:Range( "AE" + lTrim( Str( n ) ) ):Value != "NULL", oOleExcel:oExcel:ActiveSheet:Range( "AE" + lTrim( Str( n ) ) ):Value, "" )
            Observaciones                                   += if( !Empty( oOleExcel:oExcel:ActiveSheet:Range( "AM" + lTrim( Str( n ) ) ):Value ) .and. oOleExcel:oExcel:ActiveSheet:Range( "AM" + lTrim( Str( n ) ) ):Value != "NULL", oOleExcel:oExcel:ActiveSheet:Range( "AM" + lTrim( Str( n ) ) ):Value, "" )
            Observaciones                                   += if( !Empty( oOleExcel:oExcel:ActiveSheet:Range( "AN" + lTrim( Str( n ) ) ):Value ) .and. oOleExcel:oExcel:ActiveSheet:Range( "AN" + lTrim( Str( n ) ) ):Value != "NULL", oOleExcel:oExcel:ActiveSheet:Range( "AN" + lTrim( Str( n ) ) ):Value, "" )
            
            ( D():SatClientesLineas( nView ) )->mObsLin     := Observaciones
            ( D():SatClientesLineas( nView ) )->nCntAct     := nGetNumeric( oOleExcel:oExcel:ActiveSheet:Range( "AJ" + lTrim( Str( n ) ) ):Value )

         ( D():SatClientesLineas( nView ) )->( dbUnLock() )

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

static function CodigoEstado( Referencia )

   local cEstado     := ""

   if Empty( Referencia )

      cEstado        := "000"

   else

      do case
         case AllTrim( Lower( Referencia ) ) == "installation"
            cEstado  := "000"

         case AllTrim( Lower( Referencia ) ) == "service"
            cEstado  := "001"

         case AllTrim( Lower( Referencia ) ) == "repair"
            cEstado  := "002"

         case AllTrim( Lower( Referencia ) ) == "withdrawal"
            cEstado  := "003"

         otherwise
            cEstado  := "000"

      end case      

   end if

Return cEstado

//--------------------------------------------------------------------------//

static function CodigoOperario( Referencia )

   local cCodOpe  := ""
   local nRec     := ( D():Operarios( nView ) )->( Recno() )
   local nOrdAnt  := ( D():Operarios( nView ) )-> ( OrdSetFocus( "cNomTra" ) )

   if !Empty( Referencia )

      if ( D():Operarios( nView ) )->( dbSeek( AllTrim( Referencia ) ) )
   
         cCodOpe  := ( D():Operarios( nView ) )->cCodTra

      end if

   end if

   ( D():Operarios( nView ) )->( OrdSetFocus( nOrdAnt ) )
   ( D():Operarios( nView ) )->( dbGoto( nRec ) )

return ( cCodOpe )

//---------------------------------------------------------------------------//

static function FormatoFecha( fecha )

   if Empty( fecha )
      Return ( Stod( "" ) )
   end if

   fecha    := SubStr( fecha, 1, 10 )
   fecha    := cTod( fecha )

return ( fecha )

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
 
//---------------------------------------------------------------------------//

static function cGetChar( uVal )

   if Valtype( uVal ) == "N"
      uVal := Int( uVal )
   end if

Return ( cValToChar( uVal ) )

//---------------------------------------------------------------------------//

static function GetLogic( uVal, n )

   local Valor := oOleExcel:oExcel:ActiveSheet:Range( uVal + lTrim( Str( n ) ) ):Value

   if Valtype( Valor ) == "L"
      if Valor
         Return "Si"
      else
         Return "No"
      end if
   end if

Return "No"

//---------------------------------------------------------------------------//

Static Function CamposExtra( cClave, n )

   local cValor := ""

   getCampoExtra( cClave, "001", GetLogic( "B", n ) ) //Limpieza whipper

   getCampoExtra( cClave, "002", GetLogic( "E", n ) ) //Limpieza Filtro

   getCampoExtra( cClave, "003", GetLogic( "F", n ) ) //Chequeo Panel

   cValor       := cGetChar( oOleExcel:oExcel:ActiveSheet:Range( "G" + lTrim( Str( n ) ) ):Value )
   getCampoExtra( cClave, "004", if( AllTrim( cValor ) == "NULL", "", cValor ) ) //Servicio Tecnico Externo

   cValor       := cGetChar( oOleExcel:oExcel:ActiveSheet:Range( "H" + lTrim( Str( n ) ) ):Value )
   getCampoExtra( cClave, "005", if( AllTrim( cValor ) == "NULL", "", cValor ) ) //Persona que atiende

   getCampoExtra( cClave, "006", GetLogic( "I", n ) ) //Chequeo Pegatinas CZ

   cValor       := cGetChar( oOleExcel:oExcel:ActiveSheet:Range( "M" + lTrim( Str( n ) ) ):Value )
   getCampoExtra( cClave, "007", if( AllTrim( cValor ) == "NULL", "", cValor ) ) //Averia detectada

   cValor       := cGetChar( oOleExcel:oExcel:ActiveSheet:Range( "L" + lTrim( Str( n ) ) ):Value )
   getCampoExtra( cClave, "008", if( AllTrim( cValor ) == "NULL", "", cValor ) ) //Horario

   getCampoExtra( cClave, "009", GetLogic( "O", n ) ) //Chequeo Pegatinas Pulsadores

   getCampoExtra( cClave, "010", GetLogic( "S", n ) ) //Control de plagas ( Producto Correctivo )

   cValor       := cGetChar( oOleExcel:oExcel:ActiveSheet:Range( "T" + lTrim( Str( n ) ) ):Value )
   getCampoExtra( cClave, "011", if( AllTrim( cValor ) == "NULL", "", cValor ) ) //Motivo

   getCampoExtra( cClave, "012", GetLogic( "U", n ) ) //Chequeo Agua

   getCampoExtra( cClave, "013", GetLogic( "V", n ) ) //Maquina Limpiada

   getCampoExtra( cClave, "014", GetLogic( "W", n ) ) //Chequeo Motores

   getCampoExtra( cClave, "015", GetLogic( "X", n ) ) //Tipo de Filtro

   getCampoExtra( cClave, "016", GetLogic( "Y", n ) ) //Control de plagas( Producto Preventivo )

   getCampoExtra( cClave, "017", GetLogic( "AA", n ) ) //Chequeo Productos

   getCampoExtra( cClave, "018", GetLogic( "AB", n ) ) //Contador Activo

   getCampoExtra( cClave, "019", GetLogic( "AD", n ) ) //Control de plagas( Limpieza )

   getCampoExtra( cClave, "020", GetLogic( "AF", n ) ) //Chequeo Corriente

   getCampoExtra( cClave, "021", GetLogic( "AG", n ) ) //Limpieza de grupo

   getCampoExtra( cClave, "022", GetLogic( "AH", n ) ) //Cata    

   getCampoExtra( cClave, "023", GetLogic( "AK", n ) ) //Chequeo llave 

   getCampoExtra( cClave, "024", GetLogic( "AO", n ) ) //Filtro Cambiado

   getCampoExtra( cClave, "025", GetLogic( "AP", n ) ) //Chequeo Llave Amarillo

return .t.

//---------------------------------------------------------------------------//

Static Function getCampoExtra( cClave, cCodTipo, cValor )

   ( D():DetCamposExtras( nView ) )->( dbAppend() )

   ( D():DetCamposExtras( nView ) )->cTipDoc     := '32'
   ( D():DetCamposExtras( nView ) )->cCodTipo    := cCodTipo
   ( D():DetCamposExtras( nView ) )->cClave      := cClave
   ( D():DetCamposExtras( nView ) )->cValor      := if( isLogic( cValor ) , "", cValor )

   ( D():DetCamposExtras( nView ) )->( dbUnLock() )

Return .t.

//---------------------------------------------------------------------------//