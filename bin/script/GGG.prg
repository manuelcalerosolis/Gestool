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
static lOpenFiles       := .f.
static nLineaComienzo   := 30235
static defSituacion     := "Finalizado"

//---------------------------------------------------------------------------//

function InicioHRB()

   /*
   Abrimos los ficheros necesarios---------------------------------------------
   */

   if !OpenFiles( .f. )
      return .f.
   end if

   CursorWait()
   
   ImportaSat()

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

      D():Articulos( nView )

      D():SatClientes( nView )

      D():SatClientesLineas( nView )

      D():Divisas( nView )

      D():Contadores( nView )

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

static function ImportaSat( cFichero )

   local n
   local oBlock
   local oError
   local oOleExcel
   local cCodCli        := ""
   local NumeroSerie
   local cModelo        := ""
   local cMarca         := ""
   local cCodArt        := ""
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

      LogWrite( Str( n ) )

      if n == 40000
         Exit
      end if

      NumeroSerie    := oOleExcel:oExcel:ActiveSheet:Range( "D" + lTrim( Str( n ) ) ):Value

      if !Empty( oOleExcel:oExcel:ActiveSheet:Range( "D" + lTrim( Str( n ) ) ):Value )

         cCodCli     := Rjust( oOleExcel:oExcel:ActiveSheet:Range( "A" + lTrim( Str( n ) ) ):Value, "0", RetNumCodCliEmp() )
         cModelo     := oOleExcel:oExcel:ActiveSheet:Range( "E" + lTrim( Str( n ) ) ):Value
         cMarca      := oOleExcel:oExcel:ActiveSheet:Range( "F" + lTrim( Str( n ) ) ):Value
         cCodArt     := NumeroSerie

         LogWrite( NumeroSerie )
         LogWrite( cCodCli )

      end if

      /*
      Añadimos un Sat--------------------------------------------------------
      */

      /*if cCodCli == "000000"

         if ( D():Articulos( nView ) )->( dbSeek( cCodArt ) )  .and.;
            dbLock( D():Articulos( nView ) )

            ( D():Articulos( nView ) )->cCodEst          := "005"

            ( D():Articulos( nView ) )->( dbUnLock() )

         end if 

      else*/

         if !Empty( oOleExcel:oExcel:ActiveSheet:Range( "G" + lTrim( Str( n ) ) ):Value ) .or.;
            !Empty( oOleExcel:oExcel:ActiveSheet:Range( "J" + lTrim( Str( n ) ) ):Value )

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
            ( D():SatClientes( nView ) )->DFECSAT     := FormatoFecha( oOleExcel:oExcel:ActiveSheet:Range( "H" + lTrim( Str( n ) ) ):Value )
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
            ( D():SatClientes( nView ) )->dFecCre     := FormatoFecha( oOleExcel:oExcel:ActiveSheet:Range( "H" + lTrim( Str( n ) ) ):Value )
            ( D():SatClientes( nView ) )->cTimCre     := Time()
            ( D():SatClientes( nView ) )->cCodOpe     := CodigoOperario( oOleExcel:oExcel:ActiveSheet:Range( "N" + lTrim( Str( n ) ) ):Value )
            cCodEst                                   := CodigoEstado( oOleExcel:oExcel:ActiveSheet:Range( "J" + lTrim( Str( n ) ) ):Value )
            ( D():SatClientes( nView ) )->cCodEst     := cCodEst
            ( D():SatClientes( nView ) )->cSituac     := defSituacion
            ( D():SatClientes( nView ) )->nTarifa     := 1
            
            /*
            Buscamos el cliente y ponemos los datos del cliente-------------------
            */

            if ValType( cCodCli ) == "C"
               MsgWait( "Cliente añadido - " + cCodCli, Str( n ), 0.001 )
            end if

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
               ( D():SatClientesLineas( nView ) )->dFecSat     := FormatoFecha( oOleExcel:oExcel:ActiveSheet:Range( "H" + lTrim( Str( n ) ) ):Value )
               ( D():SatClientesLineas( nView ) )->cRef        := cCodArt
               ( D():SatClientesLineas( nView ) )->cDetalle    := RetFld( cCodArt, D():Articulos( nView ) )
               ( D():SatClientesLineas( nView ) )->nCtlStk     := 2

               Observaciones                                   := if( !Empty( oOleExcel:oExcel:ActiveSheet:Range( "K" + lTrim( Str( n ) ) ):Value ), oOleExcel:oExcel:ActiveSheet:Range( "K" + lTrim( Str( n ) ) ):Value, "" )
               Observaciones                                   += if( !Empty( oOleExcel:oExcel:ActiveSheet:Range( "L" + lTrim( Str( n ) ) ):Value ), oOleExcel:oExcel:ActiveSheet:Range( "L" + lTrim( Str( n ) ) ):Value, "" )
               Observaciones                                   += if( !Empty( oOleExcel:oExcel:ActiveSheet:Range( "M" + lTrim( Str( n ) ) ):Value ), oOleExcel:oExcel:ActiveSheet:Range( "M" + lTrim( Str( n ) ) ):Value, "" )
               
               ( D():SatClientesLineas( nView ) )->mObsLin     := Observaciones
               ( D():SatClientesLineas( nView ) )->nCntAct     := nGetNumeric( oOleExcel:oExcel:ActiveSheet:Range( "P" + lTrim( Str( n ) ) ):Value )

               if ( D():Articulos( nView ) )->( dbSeek( cCodArt ) )  .and.;
                  dbLock( D():Articulos( nView ) )

                  ( D():Articulos( nView ) )->cCodEst          := cCodEst

                  ( D():Articulos( nView ) )->( dbUnLock() )

               end if

            ( D():SatClientesLineas( nView ) )->( dbUnLock() )

         end if

      //end if

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
         case AllTrim( Referencia ) == "installation"
            cEstado  := "000"

         case AllTrim( Referencia ) == "service"
            cEstado  := "001"

         case AllTrim( Referencia ) == "repair"
            cEstado  := "002"

         case AllTrim( Referencia ) == "withdrawal"
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

return ( StoD( StrTran( SubStr( fecha, 1, 10 ), "-", "" ) ) )

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