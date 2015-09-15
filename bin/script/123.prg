#include "c:\fw195\gestool\bin\include\Factu.ch"

static dbfProvee
static dbfArticulo
static dbfCodebar
static dbfFamilia
static dbfFacPrvT
static dbfFacPrvL
static dbfFacPrvP
static dbfFPago
static dbfCount
static dbfDiv
static dbfIva
static dbfPrvBnc
static dbfFabricantes
static dbfTipArt
static dbfCategorias
static dbfArtPrv

static lOpenFiles       := .f.
static nLineaComienzo   := 2

//---------------------------------------------------------------------------//

function InicioHRB()

   local cDirOrigen
   local aDirectorio
   local cFichero

   /*
   Abrimos los ficheros necesarios---------------------------------------------
   */

   if !OpenFiles( .f. )
      return .f.
   end if

   CursorWait()
   
   ImportaFactura()

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
      MsgStop( 'Imposible abrir ficheros de artículos' )
      Return ( .f. )
   end if

   CursorWait()

   oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      lOpenFiles  := .t.

      USE ( cPatArt() + "ARTICULO.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "ARTICULO", @dbfArticulo ) )
      SET ADSINDEX TO ( cPatArt() + "ARTICULO.CDX" ) ADDITIVE
      ( dbfArticulo )->( __dbZap() )

      USE ( cPatArt() + "ArtCodebar.Dbf" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "CODEBAR", @dbfCodebar ) )
      SET ADSINDEX TO ( cPatArt() + "ArtCodebar.Cdx" ) ADDITIVE
      ( dbfCodebar )->( __dbZap() )

      USE ( cPatArt() + "Familias.Dbf" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "FAMILIAS", @dbfFamilia ) )
      SET ADSINDEX TO ( cPatArt() + "Familias.Cdx" ) ADDITIVE
      ( dbfFamilia )->( __dbZap() )

      USE ( cPatArt() + "TipArt.Dbf" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "TipArt", @dbfTipArt ) )
      SET ADSINDEX TO ( cPatArt() + "TipArt.Cdx" ) ADDITIVE
      ( dbfTipArt )->( __dbZap() )

      USE ( cPatPrv() + "PROVEE.DBF" ) NEW VIA ( cDriver() )   EXCLUSIVE ALIAS ( cCheckArea( "PROVEE", @dbfProvee ) )
      SET ADSINDEX TO ( cPatPrv() + "PROVEE.CDX" )   ADDITIVE
      ( dbfProvee )->( __dbZap() )

      USE ( cPatArt() + "Fabricantes.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "Fabricantes", @dbfFabricantes ) )
      SET ADSINDEX TO ( cPatArt() + "Fabricantes.CDX" ) ADDITIVE
      ( dbfFabricantes )->( __dbZap() )

      USE ( cPatArt() + "Categorias.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "Categorias", @dbfCategorias ) )
      SET ADSINDEX TO ( cPatArt() + "Categorias.CDX" ) ADDITIVE
      ( dbfCategorias )->( __dbZap() )

      USE ( cPatArt() + "PROVART.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "PROVART", @dbfArtPrv ) )
      SET ADSINDEX TO ( cPatArt() + "PROVART.CDX" ) ADDITIVE
      ( dbfArtPrv )->( __dbZap() )

      USE ( cPatEmp() + "FACPRVT.DBF" )  NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "FACPRVT", @dbfFacPrvT ) )
      SET ADSINDEX TO ( cPatEmp() + "FACPRVT.CDX" )  ADDITIVE

      USE ( cPatEmp() + "FACPRVL.DBF" )  NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "FACPRVL", @dbfFacPrvL ) )
      SET ADSINDEX TO ( cPatEmp() + "FACPRVL.CDX" )  ADDITIVE

      USE ( cPatPrv() + "PRVBNC.DBF" ) NEW VIA ( cDriver() )   EXCLUSIVE ALIAS ( cCheckArea( "PRVBNC", @dbfPrvBnc ) )
      SET ADSINDEX TO ( cPatPrv() + "PRVBNC.CDX" )   ADDITIVE

      USE ( cPatEmp() + "NCOUNT.DBF" ) NEW VIA ( cDriver() )    EXCLUSIVE ALIAS ( cCheckArea( "NCOUNT", @dbfCount ) )
      SET ADSINDEX TO ( cPatEmp() + "NCOUNT.CDX" )   ADDITIVE

      USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
      SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

      USE ( cPatGrp() + "FPAGO.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "FPAGO", @dbfFPago ) )
      SET ADSINDEX TO ( cPatGrp() + "FPAGO.CDX" ) ADDITIVE

      USE ( cPatEmp() + "FACPRVP.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "FACPRVP", @dbfFacPrvP ) )
      SET ADSINDEX TO ( cPatEmp() + "FACPRVP.CDX" ) ADDITIVE

      USE ( cPatDat() + "TIVA.DBF" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "TIVA", @dbfIva ) )
      SET ADSINDEX TO ( cPatDat() + "TIVA.CDX" ) ADDITIVE

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

   if dbfArticulo != nil
      ( dbfArticulo )->( dbCloseArea() )
   end if

   if dbfCodebar != nil
      ( dbfCodebar )->( dbCloseArea() )
   end if 

   if dbfTipArt != nil
      ( dbfTipArt )->( dbCloseArea() )
   end if 

   if dbfFamilia != nil
      ( dbfFamilia )->( dbCloseArea() )
   end if 

   if dbfProvee != nil
      ( dbfProvee )->( dbCloseArea() )
   end if

   if dbfCategorias != nil
      ( dbfCategorias )->( dbCloseArea() )
   end if 

   if dbfArtPrv != nil
      ( dbfArtPrv )->( dbCloseArea() )
   end if 

   if dbfFacPrvT != nil
      ( dbfFacPrvT )->( dbCloseArea() )
   end if

   if dbfFacPrvL != nil
      ( dbfFacPrvL )->( dbCloseArea() )
   end if

   if dbfFacPrvP != nil
      ( dbfFacPrvP )->( dbCloseArea() )
   end if

   if dbfPrvBnc != nil
      ( dbfPrvBnc )->( dbCloseArea() )
   end if

   if dbfCount != nil
      ( dbfCount )->( dbCloseArea() )
   end if

   if dbfDiv != nil
      ( dbfDiv )->( dbCloseArea() )
   end if

   if dbfFPago != nil
      ( dbfFPago )->( dbCloseArea() )
   end if

   if dbfIva != nil
      ( dbfIva )->( dbCloseArea() )
   end if

   if dbfFabricantes != nil
      ( dbfFabricantes )->( dbCloseArea() )
   end if

   dbfArticulo    := nil
   dbfCodebar     := nil
   dbfProvee      := nil
   dbfFacPrvT     := nil
   dbfFacPrvL     := nil
   dbfFacPrvP     := nil
   dbfPrvBnc      := nil
   dbfDiv         := nil
   dbfCount       := nil
   dbfFPago       := nil
   dbfIva         := nil
   dbfFabricantes := nil 
   dbfCategorias  := nil

   lOpenFiles     := .f.

RETURN ( .t. )

//----------------------------------------------------------------------------//

static function ImportaFactura( cFichero )

   local n

   local oBlock
   local oError
   local oOleExcel
   local cSerie
   local nNumero
   local cSufijo
   local nCosto
   local nVenta
   local nUnidades
   local cConcepto
   local aTotales
   local cCodBarras     := ""
   local cRefProveedor  := ""
   local cNombre        := ""
   local cProveedor     := ""
   local cFabricante    := ""
   local cCodebar       := ""
   local cTipo          := ""
   local cCategoria     := ""

   local cCodigoFamilia             := ""
   local cCodigoCategoria           := ""
   local cCodigoTipo                := ""
   local cCodigoProveedor           := ""
   local cCodigoFabricante          := ""


      /*
      Control de errores-------------------------------------------------------

      oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE
      */

      /*
      Creamos el objeto oOleExcel----------------------------------------------
      */

      oOleExcel                        := TOleExcel():New( "Importando hoja de excel", "Conectando...", .f. )

      oOleExcel:oExcel:Visible         := .f.
      oOleExcel:oExcel:DisplayAlerts   := .f.
      oOleExcel:oExcel:WorkBooks:Open( "C:\Calero\Articulos.xls" )

      oOleExcel:oExcel:WorkSheets( 1 ):Activate()   //Hojas de la hoja de calculo

      /*
      Recorremos la hoja de calculo--------------------------------------------
      */

      SysRefresh()

      for n := nLineaComienzo to 65536

         cCodBarras                 := oOleExcel:oExcel:ActiveSheet:Range( "A" + lTrim( Str( n ) ) ):Value  
         cRefProveedor              := oOleExcel:oExcel:ActiveSheet:Range( "B" + lTrim( Str( n ) ) ):Value  
         cNombre                    := Alltrim( cValToChar( oOleExcel:oExcel:ActiveSheet:Range( "D" + lTrim( Str( n ) ) ):Value ) )
         cProveedor                 := oOleExcel:oExcel:ActiveSheet:Range( "E" + lTrim( Str( n ) ) ):Value 
         cFabricante                := oOleExcel:oExcel:ActiveSheet:Range( "F" + lTrim( Str( n ) ) ):Value  
         cCodebar                   := Alltrim( cValToChar( oOleExcel:oExcel:ActiveSheet:Range( "C" + lTrim( Str( n ) ) ):Value ) )
         cFamilia                   := oOleExcel:oExcel:ActiveSheet:Range( "G" + lTrim( Str( n ) ) ):Value  
         cTipo                      := oOleExcel:oExcel:ActiveSheet:Range( "H" + lTrim( Str( n ) ) ):Value  
         cCategoria                 := oOleExcel:oExcel:ActiveSheet:Range( "I" + lTrim( Str( n ) ) ):Value  

         cCodigoFamilia             := ""
         cCodigoCategoria           := ""
         cCodigoTipo                := ""
         cCodigoProveedor           := ""
         cCodigoFabricante          := ""

         /*
         Si no encontramos mas líneas nos salimos------------------------------
         */

         logwrite( "n:" + Str( n ) + ":" + cCodBarras )

         if Empty( cCodBarras )
            Exit
         end if

         /*
         Familias--------------------------------------------------------------
         */

         if !Empty( cFamilia )

            if !dbSeekInOrd( Alltrim( cFamilia ), "cNomFam", dbfFamilia )

               cCodigoFamilia          := NextKey( "", dbfFamilia, "0", 3 )
               ( dbfFamilia )->( dbAppend() )
               ( dbfFamilia )->cCodFam := cCodigoFamilia
               ( dbfFamilia )->cNomFam := cFamilia
               ( dbfFamilia )->( dbUnLock() )

            else
         
               cCodigoFamilia          := ( dbfFamilia )->cCodFam 
         
            end if

         end if 

         /*
         Tipo articulo---------------------------------------------------------
        */

         if !Empty( cTipo )

            if !dbSeekInOrd( Alltrim( cTipo ), "cNomTip", dbfTipArt )

               cCodigoTipo             := NextKey( "", dbfTipArt, "0", 3 )
               ( dbfTipArt )->( dbAppend() )
               ( dbfTipArt )->cCodTip  := cCodigoTipo
               ( dbfTipArt )->cNomTip  := cTipo
               ( dbfTipArt )->( dbUnLock() )

            else
         
               cCodigoTipo             := ( dbfTipArt )->cCodTip 
         
            end if

         end if 

         /*
         Proveedores-----------------------------------------------------------
         */

         if !Empty( cProveedor )

            if !dbSeekInOrd( Alltrim( cProveedor ), "Titulo", dbfProvee )

               cCodigoProveedor        := NextKey( "", dbfProvee, "0", RetNumCodPrvEmp() )
               ( dbfProvee )->( dbAppend() )
               ( dbfProvee )->Cod      := cCodigoProveedor
               ( dbfProvee )->Titulo   := cProveedor
               ( dbfProvee )->( dbUnLock() )

            else
         
               cCodigoProveedor        := ( dbfProvee )->Cod 
         
            end if

         end if 
         
         /*
         Fabricantes-----------------------------------------------------------
         */

         if !Empty( cFabricante )

            if !dbSeekInOrd( Alltrim( cFabricante ), "cNomFab", dbfFabricantes )

               cCodigoFabricante             := NextKey( "", dbfFabricantes, "0", 3 )
               ( dbfFabricantes )->( dbAppend() )
               ( dbfFabricantes )->cCodFab   := cCodigoFabricante
               ( dbfFabricantes )->cNomFab   := cFabricante
               ( dbfFabricantes )->( dbUnLock() )

            else
         
               cCodigoFabricante             := ( dbfFabricantes )->cCodFab 
         
            end if

         end if 

         /*
         Categoria-------------------------------------------------------------
         */

         if !Empty( cCategoria )

            if !dbSeekInOrd( Alltrim( cCategoria ), "Nombre", dbfCategorias )

               cCodigoCategoria             := NextKey( "", dbfCategorias, "0", 3 )
               ( dbfCategorias )->( dbAppend() )
               ( dbfCategorias )->cCodigo   := cCodigoCategoria
               ( dbfCategorias )->cNombre   := cCategoria
               ( dbfCategorias )->( dbUnLock() )

            else
         
               cCodigoCategoria             := ( dbfCategorias )->cCodigo 
         
            end if

         end if 

         /*
         Si no existe el artículo lo creamos-----------------------------------
         */

         while dbSeekInOrd( PadR( cCodBarras, 18 ), "Codigo", dbfArticulo )

            if dbLock( dbfArticulo )
               ( dbfArticulo )->( dbDelete() )
               ( dbfArticulo )->( dbUnLock() )
            end if

         end while 

         ( dbfArticulo )->( dbAppend() )

         ( dbfArticulo )->Codigo    := cCodBarras
         ( dbfArticulo )->Familia   := cCodigoFamilia 
         ( dbfArticulo )->cCodTip   := cCodigoTipo
         ( dbfArticulo )->Nombre    := cNombre
         ( dbfArticulo )->pCosto    := nGetNumeric( oOleExcel:oExcel:ActiveSheet:Range( "P" + lTrim( Str( n ) ) ):Value )
         ( dbfArticulo )->lIvaInc   := .t.
         ( dbfArticulo )->pVtaIva1  := nGetNumeric( oOleExcel:oExcel:ActiveSheet:Range( "R" + lTrim( Str( n ) ) ):Value )
         ( dbfArticulo )->pVenta1   := nGetNumeric( oOleExcel:oExcel:ActiveSheet:Range( "R" + lTrim( Str( n ) ) ):Value ) 
         ( dbfArticulo )->nCajEnt   := 1
         ( dbfArticulo )->nUniCaja  := 1
         ( dbfArticulo )->LastIn    := GetSysDate()
         ( dbfArticulo )->LastChg   := GetSysDate()
         ( dbfArticulo )->LastOut   := GetSysDate()
         ( dbfArticulo )->TipoIva   := "E"
         ( dbfArticulo )->nCtlStock := 1
         ( dbfArticulo )->lSndDoc   := .t.
         ( dbfArticulo )->cCodUsr   := "000"
         ( dbfArticulo )->dFecChg   := GetSysDate()
         ( dbfArticulo )->cTimChg   := Time()
         ( dbfArticulo )->cPrvHab   := cCodigoProveedor
         ( dbfArticulo )->cCodFab   := cCodigoFabricante
         ( dbfArticulo )->cCodCate  := cCodigoCategoria

         ( dbfArticulo )->( dbUnLock() )
   
         /*
         Codigos de barras--------------------------------------------------------
         */
   
         if !dbSeekInOrd( cCodebar, "cCodBar", dbfCodebar )
   
            ( dbfCodebar )->( dbAppend() )
            ( dbfCodebar )->cCodArt   := cCodBarras
            ( dbfCodebar )->cCodBar   := cCodebar
            ( dbfCodebar )->( dbUnLock() )
   
         end if 

         /*
         Codigos de proveedor--------------------------------------------------
         */

         if !Empty( cRefProveedor ) .and. !dbSeekInOrd( ( dbfArticulo )->cPrvHab + ( dbfArticulo )->Codigo, "cCodPrv", dbfArtPrv )
   
            ( dbfArtPrv )->( dbAppend() )
            ( dbfArtPrv )->cCodArt   := ( dbfArticulo )->Codigo
            ( dbfArtPrv )->cCodPrv   := ( dbfArticulo )->cPrvHab
            ( dbfArtPrv )->cRefPrv   := cRefProveedor
            ( dbfArtPrv )->( dbUnLock() )
   
         end if 
  
      next

      /*
      Cerramos la conexion con el objeto oOleExcel-----------------------------
      */

      oOleExcel:oExcel:WorkBooks:Close()

      oOleExcel:oExcel:Quit()

      oOleExcel:oExcel:DisplayAlerts   := .t.

      oOleExcel:End()

      /*
      Cerrando el control de errores-------------------------------------------

      RECOVER USING oError

         msgStop( "Error en el proceso de importación : " + ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )
      */

Return .t.

//------------------------------------------------------------------------

static function nGetNumeric( uVal )

   if Valtype( uVal ) == "C"
      uVal        := Val( StrTran( uVal, ",", "." ) )
   end if

Return ( uVal )

//------------------------------------------------------------------------

