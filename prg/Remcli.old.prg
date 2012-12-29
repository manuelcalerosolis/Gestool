#include "Fivewin.ch"
#include "MesDbf.ch"
#include "Factu.Ch"
#include "Report.ch"

static   nLevel

//---------------------------------------------------------------------------//

CLASS TRemesas FROM TMasDet

   DATA  oCtaRem
   DATA  oDivisas
   DATA  oRecibos
   DATA  oClientes
   DATA  oBandera
   DATA  cPorDiv
   DATA  dCarCta
   DATA  cPatExp
   DATA  dFecIni
   DATA  dFecFin

   /*
   Metodos de Edición
   */

   METHOD Set()
   METHOD OpenFiles()
   METHOD CloseFiles()     INLINE   ( ::oDivisas:End(), ::oClientes:End(), ::oDbfDetalle:End(), ::oCtaRem:End(), ::oDbf:End() )
   METHOD Resource( nMode )
   METHOD Activate()
   METHOD lSave()

   METHOD GetRecCli( oGet, oSay, oBrw )
   METHOD AppRecCli( oBrw )
   METHOD DelRecCli( oBrw )

   METHOD Del()
   METHOD DelItem()

   METHOD nTotRem( lPic )
   METHOD cNumRem()        INLINE   ( Str( ::oDbf:nNumRem, 9 ) + "/" + ::oDbf:cSufRem )
   METHOD cBmp()           INLINE   cBmpDiv( ::oDbf:cCodDiv, ::oDivisas:cAlias, ::oBandera )

   /*
   Metodos para el modelo 19
   */

   METHOD SaveMod19()
   METHOD InitMod19()
   METHOD ShowMod19( oDlg )

   METHOD Report()
   METHOD PrnReport( aNumDes, aNumHas, cTitulo, cSubTitulo, nDevice )

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate()

   local oSnd

   ::CreateShell( nLevel )

   ::oWndBrw:GralButtons( Self )

   DEFINE BTNSHELL RESOURCE "BMPEXPTAR" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::SaveMod19() ) ;
      TOOLTIP  "E(x)portar" ;
      HOTKEY   "X";
      LEVEL    4

   ::oWndBrw:EndButtons( Self )

   ::oWndBrw:Activate(  nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,;
                        nil, nil, nil, nil, {|| ::CloseFiles() }, nil, nil )

RETURN NIL

//----------------------------------------------------------------------------//

METHOD Set()

   ::cPorDiv      := cPorDiv( cDivEmp(), ::oDivisas:cAlias ) // Picture de la divisa redondeada
   ::dCarCta      := Date()
   ::cPatExp      := PadR( "A:\RECIBOS.TXT", 100 )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles( cPath )

   DEFAULT  cPath := cPatEmp()

   DATABASE NEW ::oDivisas ;
         FILE  "DIVISAS.DBF" ;
         PATH  ( cPatDat() ) ;
         VIA   cLocalDriver() ;
         SHARED ;
         INDEX "DIVISAS.CDX"

   DATABASE NEW ::oClientes ;
         FILE  "CLIENT.DBF" ;
         PATH  ( cPath ) ;
         VIA   cLocalDriver() ;
         SHARED ;
         INDEX "CLIENT.CDX"

   ::Set()

   ::oCtaRem  := TCtaRem():New( cPatEmp() )
   ::oCtaRem:OpenFiles()

   ::oBandera := TBandera():New

   DATABASE NEW ::oDbfDetalle ;
         FILE     "FACCLIP.DBF" ;
         PATH     ( cPath ) ;
         VIA      cLocalDriver() ;
         SHARED ;
         INDEX    "FACCLIP.CDX"

   /*
   Definicion del master-------------------------------------------------------
   */

   DEFINE DATABASE ::oDbf ;
        FILE      "REMCLIT.DBF" ;
        CLASS     "REMCLI" ;
        ALIAS     "REMCLI" ;
        PATH      ( cPath );
        VIA       cLocalDriver() ;
        COMMENT   "Remesas bancarias"

   FIELD NAME "nNumRem"             TYPE "N" LEN  9  DEC 0 PICTURE "999999999"         DEFAULT  nCurRem()                                 COMMENT ""                                HIDE  OF ::oDbf
   FIELD NAME "cSufRem"             TYPE "C" LEN  2  DEC 0 PICTURE "@!"                DEFAULT  RetSufEmp()                               COMMENT ""                                HIDE  OF ::oDbf
   FIELD CALCULATE NAME "cNumRem"            LEN 12  DEC 0                             VAL      ::cNumRem()                               COMMENT "Número" COLSIZE  80                    OF ::oDbf
   FIELD NAME "cCodRem"             TYPE "C" LEN  3  DEC 0 PICTURE "@!"                                                                   COMMENT "Cuenta" COLSIZE  80                    OF ::oDbf
   FIELD CALCULATE NAME "cNomRem"            LEN 60  DEC 0                             VAL      ::oCtaRem:cRetCtaRem( ::oDbf:cCodRem )    COMMENT "Nombre" COLSIZE 200                    OF ::oDbf
   FIELD NAME "dFecRem"             TYPE "D" LEN  8  DEC 0                             DEFAULT  Date()                                    COMMENT "Fecha"  COLSIZE  80                    OF ::oDbf
   FIELD NAME "cCodDiv"             TYPE "C" LEN  3  DEC 0 PICTURE "@!"                DEFAULT  cDivEmp()                                 COMMENT ""                                HIDE  OF ::oDbf
   FIELD NAME "nVdvDiv"             TYPE "N" LEN 16  DEC 6 PICTURE "@E 999,999.9999"   DEFAULT  1                                         COMMENT ""                                HIDE  OF ::oDbf
   FIELD CALCULATE NAME "cBmpDiv"            LEN 20  DEC 0                             VAL      ::cBmp()                                  COMMENT "Div."   COLSIZE  25                    OF ::oDbf
   FIELD CALCULATE NAME "nTotRem"            LEN 16  DEC 6                             VAL      ::nTotRem(.t.)                            COMMENT "Total"  COLSIZE 100  ALIGN RIGHT       OF ::oDbf

   INDEX TO "RemCliT.Cdx" TAG "cNumRem" ON "Str( nNumRem ) + cSufRem" COMMENT "Número" NODELETED OF ::oDbf

   END DATABASE ::oDbf

   ACTIVATE DATABASE ::oDbf SHARED NORECYCLE

   /*
   Definicion del detalle------------------------------------------------------
   */

   DEFINE DATABASE ::oDbfDetalle ;
         FILE     "FACCLIP.DBF" ;
         CLASS    "FACCLIP" ;
         ALIAS    "FACCLIP" ;
         PATH     ( cPath );
         VIA      cLocalDriver() ;
         COMMENT  "Remesas bancarias"

   FIELD NAME "CSERIE"     TYPE "C" LEN   1 DEC  0 COMMENT "Serie de fctura"                 OF ::oDbfDetalle
   FIELD NAME "NNUMFAC"    TYPE "N" LEN   9 DEC  0 COMMENT "Numero de factura"               OF ::oDbfDetalle
   FIELD NAME "CSUFFAC"    TYPE "C" LEN   2 DEC  0 COMMENT "Sufijo de factura"               OF ::oDbfDetalle
   FIELD NAME "NNUMREC"    TYPE "N" LEN   2 DEC  0 COMMENT "Numero del recibo"               OF ::oDbfDetalle
   FIELD NAME "CCODCLI"    TYPE "C" LEN  12 DEC  0 COMMENT "Codigo de cliente"               OF ::oDbfDetalle
   FIELD NAME "DENTRADA"   TYPE "D" LEN   8 DEC  0 COMMENT "Fecha de entrada"                OF ::oDbfDetalle
   FIELD NAME "NIMPORTE"   TYPE "N" LEN  16 DEC  6 COMMENT "Importe del pago"                OF ::oDbfDetalle
   FIELD NAME "CDESCRIP"   TYPE "C" LEN 100 DEC  0 COMMENT "Concepto del pago"               OF ::oDbfDetalle
   FIELD NAME "DPRECOB"    TYPE "D" LEN   8 DEC  0 COMMENT "Fecha de previsión de cobro"     OF ::oDbfDetalle
   FIELD NAME "CPGDOPOR"   TYPE "C" LEN  50 DEC  0 COMMENT "Pagado por"                      OF ::oDbfDetalle
   FIELD NAME "LCOBRADO"   TYPE "L" LEN   1 DEC  0 COMMENT "Logico de cobrado"               OF ::oDbfDetalle
   FIELD NAME "CDIVPGO"    TYPE "C" LEN   3 DEC  0 COMMENT "Codigo de la divisa"             OF ::oDbfDetalle
   FIELD NAME "NVDVPGO"    TYPE "N" LEN  10 DEC  6 COMMENT "Cambio de la divisa"             OF ::oDbfDetalle
   FIELD NAME "LCONPGO"    TYPE "L" LEN   1 DEC  0 COMMENT "Contabilizado el recibo"         OF ::oDbfDetalle
   FIELD NAME "CCTAREC"    TYPE "C" LEN  12 DEC  0 COMMENT "Cuenta de contabilidad"          OF ::oDbfDetalle
   FIELD NAME "NIMPEUR"    TYPE "N" LEN  16 DEC  6 COMMENT "Importe del pago en Euros"       OF ::oDbfDetalle
   FIELD NAME "LIMPEUR"    TYPE "L" LEN   1 DEC  0 COMMENT "Cobrar en Euros"                 OF ::oDbfDetalle
   FIELD NAME "NNUMREM"    TYPE "N" LEN   9 DEC  0 COMMENT "Numero de la remesas"            OF ::oDbfDetalle
   FIELD NAME "CSUFREM"    TYPE "C" LEN   2 DEC  0 COMMENT "Sufijo de remesas"               OF ::oDbfDetalle
   FIELD NAME "CCTAREM"    TYPE "C" LEN   3 DEC  0 COMMENT "Cuenta de remesa"                OF ::oDbfDetalle

   INDEX TO "FacCliP.Cdx" TAG "cNumFac"   ON "cSerie + Str( nNumFac ) + cSufFac"                   COMMENT "Número"   NODELETED OF ::oDbfDetalle
   INDEX TO "FacCliP.Cdx" TAG "cCodCli"   ON "cCodCli"                                             COMMENT "Cliente"  NODELETED OF ::oDbfDetalle
   INDEX TO "FacCliP.Cdx" TAG "dEntrada"  ON "dEntrada"                                            COMMENT "Fecha"    NODELETED OF ::oDbfDetalle
   INDEX TO "FacCliP.Cdx" TAG "lNumFac"   ON "cSerie + Str( nNumFac ) + cSufFac + Str( nNumRec )"  COMMENT "Recibo"   NODELETED OF ::oDbfDetalle
   INDEX TO "FacCliP.Cdx" TAG "nNumRem"   ON "Str( nNumRem ) + cSufRem"                            COMMENT "Remesa"   NODELETED OF ::oDbfDetalle
   INDEX TO "FacCliP.Cdx" TAG "cCtaRem"   ON "cCtaRem"                                             COMMENT "Cuenta"   NODELETED OF ::oDbfDetalle

   END DATABASE ::oDbfDetalle

   ACTIVATE DATABASE ::oDbfDetalle SHARED NORECYCLE

   ::oDbfDetalle:OrdSetFocus( "NNUMREM" )

   ::dFecIni   := Ctod( "01/" + Str( Month( Date() ), 2 ) + "/" + Str( Year( Date() ), 4 ) )
   ::dFecFin   := Date()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( nMode )

   local oDlg
   local oBrw
   local oGet     := Array( 3 )
   local oSay
   local This     := Self
   local cSay     := ""
   local oBmpDiv

   /*
   msginfo( ::oDbf:nNumRem )

   if nMode == APPD_MODE
      ::oDbf:nNumRem    := nCurRem()
      ::oDbf:GetStatus()
      while ( ::oDbf:nArea )->( dbSeek( Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem ) )
         NewRem()
         ::oDbf:nNumRem := nCurRem()
      end while
      ::oDbf:SetStatus()
   end if

   msginfo( ::oDbf:nNumRem )
  */

   DEFINE DIALOG oDlg RESOURCE "RemCli" TITLE LblTitle( nMode ) + "remesas de recibos a clientes"

      REDEFINE GET ::oDbf:nNumRem ;
			ID 		100 ;
         WHEN     ( .f. ) ;
         PICTURE  ::oDbf:FieldByName( "nNumRem" ):cPict ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cSufRem ;
			ID 		110 ;
         WHEN     ( .f. ) ;
         PICTURE  ::oDbf:FieldByName( "cSufRem" ):cPict ;
         OF       oDlg

      REDEFINE GET ::oDbf:dFecRem ;
         ID       120 ;
         SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::dFecIni UPDATE ;
         ID       121 ;
         SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::dFecFin UPDATE ;
         ID       122 ;
         SPINNER ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET oGet[1] VAR ::oDbf:cCodRem UPDATE ;
         ID       130 ;
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    ( This:GetRecCli( oGet, oSay, oBrw ) ) ;
         PICTURE  ::oDbf:FieldByName( "cCodRem" ):cPict ;
         ON HELP  ( This:oCtaRem:Buscar( oGet[1] ) ) ;
         BITMAP   "LUPA" ;
			OF 		oDlg

      REDEFINE GET oSay VAR cSay UPDATE ;
         ID       131 ;
         WHEN     ( .f. ) ;
			OF 		oDlg

      REDEFINE GET oGet[2] VAR ::oDbf:cCodDiv UPDATE ;
         WHEN     ( nMode == APPD_MODE .AND. ::oDbf:LastRec() == 0 ) ;
         VALID    ( cDivOut( oGet[2], oBmpDiv, oGet[3], nil, nil, nil, nil, nil, nil, nil, ::oDivisas:cAlias, ::oBandera ), .t. );
         PICTURE  "@!";
         ID       140 ;
         BITMAP   "LUPA" ;
         ON HELP  BrwDiv( oGet[2], oBmpDiv, oGet[3], ::oDivisas:cAlias, ::oBandera ) ;
         OF       oDlg

		REDEFINE BITMAP oBmpDiv ;
         RESOURCE "BAN_EURO" ;
         ID       141;
         OF       oDlg

      REDEFINE GET oGet[3] VAR ::oDbf:nVdvDiv ;
			WHEN		( .F. ) ;
         ID       142 ;
         VALID    ( ::oDbf:nVdvDiv > 0 ) ;
			PICTURE	"@E 999,999.9999" ;
         OF       oDlg

       /*
       Botones de acceso________________________________________________________________
       */

		REDEFINE BUTTON ;
			ID 		500 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::AppRecCli( oBrw ) )

		REDEFINE BUTTON ;
			ID 		502 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::DelRecCli( oBrw ) )

      REDEFINE LISTBOX oBrw ;
			FIELDS ;
                  ::oDbfDetalle:cSerie + "/" + Str( ::oDbfDetalle:nNumFac ) + "/" + ::oDbfDetalle:cSufFac + "-" + Str( ::oDbfDetalle:nNumRec ),;
                  DtoC( ::oDbfDetalle:dPreCob ),;
                  ::oDbfDetalle:cCodCli + Space( 1 ) + RetClient( ::oDbfDetalle:cCodCli, ::oClientes:cAlias ),;
                  ::oDbfDetalle:cDescrip,;
                  cBmpDiv( ::oDbfDetalle:cDivPgo, ::oDivisas:cAlias, ::oBandera ),;
                  nTotRecCli( ::oDbfDetalle:cAlias, ::oDivisas:cAlias, ::oDbf:cCodDiv, .t. ) ;
         FIELDSIZES ;
                  80,;
                  70,;
                  200,;
                  200,;
                  30,;
                  90 ;
         HEAD ;
                  "Número",;
                  "Fecha",;
                  "Cliente",;
                  "Descripción",;
                  "Div.",;
                  "Importe" ;
         ID       150 ;
         OF       oDlg

         ::oDbfDetalle:OrdScope( Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem )
         ::oDbfDetalle:SetBrowse( oBrw )

         oBrw:aJustify        := { .f., .f., .f., .f., .f., .t. }
         oBrw:bLogicLen       := { || ::oDbfDetalle:RecCount() }
         oBrw:aFooters        := {||{ "", "", "" , "", "", ::nTotRem( .t. ) } }
         oBrw:lDrawFooters    := .t.

         if nMode != ZOOM_MODE
            oBrw:bAdd         := {|| ::AppRecCli( oBrw ) }
            oBrw:bDel         := {|| ::DelRecCli( oBrw ) }
         end if

      REDEFINE BUTTON ;
         ID       511 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( if( ::lSave( nMode ), oDlg:End( IDOK ), ) )

		REDEFINE BUTTON ;
         ID       510 ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

   REDEFINE BUTTON ;
         ID       559 ;
			OF 		oDlg ;
         ACTION   ( HtmlHelp( "Cuentas de remesas" ) )

	ACTIVATE DIALOG oDlg	CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD lSave( nMode )

   local lReturn  := .f.

   if nMode == APPD_MODE

      if !Empty( ::oDbf:cCodRem )
         ::oDbf:insert()
         NewRem()
         lReturn  := .t.
      else
         MsgStop( "Este numero de cuenta no puede estar vacio." )
         lReturn  := .f.
      end if

   else

      ::oDbf:update()
      lReturn     := .t.

   end if

RETURN ( lReturn )

//---------------------------------------------------------------------------//

METHOD SaveMod19()

   local oDlg
   local oMtr
   local nMtr        := 0
   local oBtnInfo

   DEFINE DIALOG oDlg RESOURCE "EXPMOD19"

      REDEFINE GET ::dCarCta          ID 120   SPINNER                              OF oDlg
      REDEFINE GET ::cPatExp          ID 130                                        OF oDlg

      REDEFINE METER oMtr VAR nMtr    ID 140   PROMPT  "Procesando" TOTAL 100       OF oDlg

      REDEFINE BUTTON                           ;
            ID       IDOK                       ;
            OF       oDlg                       ;
            ACTION   ::InitMod19( oDlg, oMtr )

      REDEFINE BUTTON                           ;
            ID       IDCANCEL                   ;
            OF       oDlg                       ;
            ACTION   oDlg:End()

   ACTIVATE DIALOG oDlg CENTER

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD InitMod19( oDlg, oMtr )

   local nHandle
   local cBuffer
   local cHeader
   local cBanCli
   local nImpRec
   local nTotImp  := 0
   local nTotRec  := 0
   local nTotLin  := 0
   local cPreMon  := if( cDivEmp() == "EUR", "5", "0" )

   oDlg:Disable()

   if file( Rtrim( ::cPatExp ) )
      fErase( Rtrim( ::cPatExp ) )
   end if

   nHandle  := fCreate( Rtrim( ::cPatExp ) )

   if nHandle > 0

      /*
      Cabecera de registro--------------------------------------------------------
      */

      cHeader  := ::oCtaRem:oDbf:cNifPre     // Nif del presentador
      cHeader  += ::oCtaRem:oDbf:cSufCta     // SubClave

      /*
      Datos del presentador-------------------------------------------------------
      */

      cBuffer  := cPreMon
      cBuffer  += "1"
      cBuffer  += "8"                        // Constante para el modelo 19
      cBuffer  += "0"                        // Numero de linea
      cBuffer  += cHeader                    // Cabecera
      cBuffer  += Left( Dtoc( ::dCarCta ), 2) + SubStr( Dtoc( ::dCarCta ), 4, 2 ) + Right( Dtoc( ::dCarCta ), 2 )
      cBuffer  += Space( 6 )                 // Libre
      cBuffer  += ::oCtaRem:oDbf:cNomPre     // Nombre
      cBuffer  += Space( 20 )                // Libre
      cBuffer  += ::oCtaRem:oDbf:cEntPre     // Entidad
      cBuffer  += ::oCtaRem:oDbf:cAgcPre     // Agencia
      cBuffer  += CRLF

      fWrite( nHandle, cBuffer )
      nTotLin  ++

      /*
      Datos del propietario-------------------------------------------------------
      */

      cBuffer  := cPreMon
      cBuffer  += "3"                        // Cte para la empresa
      cBuffer  += "8"                        // Constante para el modelo 19
      cBuffer  += "0"                        // Numero de linea
      cBuffer  += cHeader                    // Cabecera
      cBuffer  += Left( Dtoc( ::dCarCta ), 2) + SubStr( Dtoc( ::dCarCta ), 4, 2 ) + Right( Dtoc( ::dCarCta ), 2 )
      cBuffer  += Left( Dtoc( ::dCarCta ), 2) + SubStr( Dtoc( ::dCarCta ), 4, 2 ) + Right( Dtoc( ::dCarCta ), 2 )
      cBuffer  += ::oCtaRem:oDbf:cNomPre     // Nombre de la empresa igual a del presentador
      cBuffer  += ::oCtaRem:oDbf:cEntBan     // Entidad
      cBuffer  += ::oCtaRem:oDbf:cAgcBan     // Agencia
      cBuffer  += ::oCtaRem:oDbf:cDgcBan     // Digito de control
      cBuffer  += ::oCtaRem:oDbf:cCtaBan     // Cuenta
      cBuffer  += Space( 8 )                 // Libre
      cBuffer  += "01"                       // Para la 19
      cBuffer  += CRLF

      fWrite( nHandle, cBuffer )
      nTotLin  ++

      /*
      Traspaso de recibos------------------------------------------------------
      */

      if ::oDbfDetalle:Seek( Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem )
         ::oDbfDetalle:Load()

         while Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem == Str( ::oDbfDetalle:nNumRem ) + ::oDbfDetalle:cSufRem

            if ::oClientes:Seek( ::oDbfDetalle:cCodCli )
               ::oClientes:Load()
               cBanCli        := ::oClientes:Cuenta
            else
               cBanCli        := ""
            end if

            if !Empty( cBanCli )

               if ::oDbfDetalle:cDivPgo != cDivEmp()
                  nImpRec  := nCnv2Div( ::oDbfDetalle:nImporte, ::oDbfDetalle:cDivPgo, cDivEmp(), ::oDivisas:cAlias )
               else
                  nImpRec  := ::oDbfDetalle:nImporte
               end if

               nTotImp     += nImpRec
               nTotRec     ++

               cBuffer     := cPreMon
               cBuffer     += "6"                        // Constante para las lineas de recibos
               cBuffer     += "8"                        // Constante para el modelo 19
               cBuffer     += "0"                        // Numero de linea
               cBuffer     += cHeader                    // Cabecera
               cBuffer     += Right( AllTrim( ::oDbfDetalle:cCodCli ), 6 )  // Codigo del cliente
               cBuffer     += Space( 6 )
               cBuffer     += Left( ::oClientes:Titulo, 40 )   // Nombre del cliente
               cBuffer     += cBanCli                          // Banco del cliente
               cBuffer     += cToCeros( nImpRec, ::cPorDiv )   // Importe del recibo
               cBuffer     += Space( 6 )
               cBuffer     += ::oDbfDetalle:cSerie + cToCeros( ::oDbfDetalle:nNumFac, "99999", 5 ) // Numero del recibo
               cBuffer     += Space( 1 )
               cBuffer     += CRLF

               fWrite( nHandle, cBuffer )
               nTotLin     ++

               /*
               Detalles de la factura------------------------------------------
               */

               cBuffer     := cPreMon
               cBuffer     += "6"                        // Constante para las lineas de recibos
               cBuffer     += "8"                        // Constante para el modelo 19
               cBuffer     += "1"                        // Numero de linea
               cBuffer     += cHeader                    // Cabecera
               cBuffer     += Right( AllTrim( ::oDbfDetalle:cCodCli ), 6 )  // Codigo del cliente
               cBuffer     += Space( 6 )
               cBuffer     += "Factura Nº" + ::oDbfDetalle:cSerie + "/" + AllTrim( Str( ::oDbfDetalle:nNumFac ) ) + "/" +  ::oDbfDetalle:cSufFac + " de " + Dtoc( ::oDbfDetalle:dEntrada )
               cBuffer     += CRLF

               fWrite( nHandle, cBuffer )
               nTotLin     ++

               /*
               Detalles del cliente--------------------------------------------
               */

               cBuffer     := cPreMon
               cBuffer     += "6"                        // Constante para las lineas de recibos
               cBuffer     += "8"                        // Constante para el modelo 19
               cBuffer     += "2"                        // Numero de linea
               cBuffer     += cHeader                    // Cabecera
               cBuffer     += Right( AllTrim( ::oDbfDetalle:cCodCli ), 6 )  // Codigo del cliente
               cBuffer     += Space( 6 )
               cBuffer     += Left( ::oClientes:Titulo, 40 )   // Nombre del cliente
               cBuffer     += Left( ::oClientes:Domicilio, 40 )// Domicilio del cliente
               cBuffer     += ::oClientes:CodPostal            // Codigo postal
               cBuffer     += Space( 1 )
               cBuffer     += ::oClientes:Poblacion            // Población
               cBuffer     += CRLF

               fWrite( nHandle, cBuffer )
               nTotLin     ++

            end if

            ::oDbfDetalle:Skip():Load()

         end while

      end if

      /*
      Total de presentador-----------------------------------------------------
      */

      cBuffer  := cPreMon
      cBuffer  += "8"                              // Constante para las lineas de recibos
      cBuffer  += "8"                              // Constante para el modelo 19
      cBuffer  += "0"                              // Numero de linea
      cBuffer  += cHeader                          // Cabecera
      cBuffer  += Space( 72 )
      cBuffer  += cToCeros( nTotImp, ::cPorDiv )   // Importe total del Recibos
      cBuffer  += Space( 6 )
      cBuffer  += cToCeros( nTotRec )              // Numero de recibos por ordenante
      cBuffer  += cToCeros( nTotLin )              // Numero Total de lineas
      cBuffer  += CRLF

      fWrite( nHandle, cBuffer )
      nTotLin  ++

      /*
      Total de archivo---------------------------------------------------------
      */

      cBuffer  := cPreMon
      cBuffer  += "9"                              // Constante para las lineas de recibos
      cBuffer  += "8"                              // Constante para el modelo 19
      cBuffer  += "0"                              // Numero de linea
      cBuffer  += cHeader                          // Cabecera
      cBuffer  += Space( 72 )
      cBuffer  += cToCeros( nTotImp, ::cPorDiv )   // Importe total del Recibos
      cBuffer  += Space( 6 )
      cBuffer  += cToCeros( nTotRec )              // Numero de recibos por ordenante
      cBuffer  += cToCeros( ++nTotLin )            // Numero Total de lineas del fichero
      cBuffer  += CRLF
      fWrite( nHandle, cBuffer )

   end if

   fClose( nHandle )

   MsgInfo( "Proceso terminado satisfactorioamente." )

   oDlg:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ShowMod19( oDlg, oBtn )

   local aRect := GetWndRect( oDlg:hWnd )

   oDlg:Move( aRect[1], aRect[2], oDlg:nWidth , 420, .t. )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD GetRecCli( oGet, oSay, oBrw )

   local nRec  := 0

   if ::oCtaRem:lGetCtaRem( ::oDbf:cCodRem, oSay )

      oGet[ 1 ]:bWhen   := {|| .f. }
      oGet[ 1 ]:Disable()

      ::oDbfDetalle:OrdSetFocus( "CCTAREM" )

      if ::oDbfDetalle:Seek( ::oDbf:cCodRem )

         while ::oDbfDetalle:cCtaRem == ::oDbf:cCodRem .and. !::oDbfDetalle:Eof()

            if !::oDbfDetalle:lCobrado             .and. ;
               Empty( ::oDbfDetalle:nNumRem )      .and. ;
               ::oDbfDetalle:dPreCob >= ::dFecIni  .and. ;
               ::oDbfDetalle:dPreCob <= ::dFecFin  .and. ;
               !Empty( ::oDbfDetalle:dPreCob )     .and. ;
               ::oDbfDetalle:nImporte > 0

               ::oDbfDetalle:SetBuffer( .t. )
               ::oDbfDetalle:Load()
               ::oDbfDetalle:lCobrado  := .t.
               ::oDbfDetalle:nNumRem   := ::oDbf:nNumRem
               ::oDbfDetalle:cSufRem   := ::oDbf:cSufRem
               ::oDbfDetalle:dEntrada  := ::oDbf:dFecRem
               ::oDbfDetalle:Save()
               ::oDbfDetalle:SetBuffer( .f. )

            end if

            ::oDbfDetalle:Skip()

         end while

      else

         MsgStop( "No se encuentran recibos, en la cuenta " + ::oDbf:cCodRem )

      end if

      ::oDbfDetalle:OrdSetFocus( "NNUMREM" )

      ::oDbfDetalle:ClearScope()
      ::oDbfDetalle:OrdScope( Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem )
      ::oDbfDetalle:SetBrowse( oBrw )

      oBrw:Refresh()

   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD nTotRem( lPic )

   local nTot     := 0
   local nPos     := ::oDbfDetalle:Recno()

   DEFAULT lPic   := .f.

   if ::oDbfDetalle:Seek( Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem )
      ::oDbfDetalle:Load()
      while Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem == Str( ::oDbfDetalle:nNumRem ) + ::oDbfDetalle:cSufRem .and. !::oDbfDetalle:eof()
         nTot  += nTotRecCli( ::oDbfDetalle:cAlias, ::oDivisas:cAlias, ::oDbf:cCodDiv, .f. )
         ::oDbfDetalle:Skip():Load()
      end while
   end if

   ::oDbfDetalle:GoTo( nPos )

RETURN ( if( lPic, Trans( nTot, ::cPorDiv ), nTot ) )

//---------------------------------------------------------------------------//

METHOD AppRecCli( oBrw )

   local cCodRec  := ""
   local nOrdAnt  := ::oDbfDetalle:OrdNumber()

   if BrwRecCli( @cCodRec, ::oDbfDetalle:cAlias, ::oClientes:cAlias, ::oDivisas:cAlias, ::oBandera )

      /*
      if ::oDbfDetalle:Seek( cCodRec )
      */
         ::oDbfDetalle:Load()

         if !::oDbfDetalle:lCobrado

            if Empty( ::oDbfDetalle:nNumRem )

               ::oDbfDetalle:lCobrado   := .t.
               ::oDbfDetalle:nNumRem    := ::oDbf:nNumRem
               ::oDbfDetalle:cSufRem    := ::oDbf:cSufRem
               ::oDbfDetalle:dEntrada   := ::oDbf:dFecRem
               ::oDbfDetalle:Save()

            else

               msgStop( "Recibo ya remesado." )

            end if

         else

            msgStop( "Recibo ya cobrado." )

         end if
      /*
      else

         msgStop( "Recibo no encontrado." )

      end if

      ::oDbfDetalle:OrdSetFocus( "NNUMREM" )
      */

      ::oDbfDetalle:OrdScope( Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem )
      ::oDbfDetalle:SetBrowse( oBrw )
      oBrw:Refresh()

   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Del()

   local nRec

   if msgNoYes( "¿ Desea eliminar el registro en curso ?", "Confirme supresión" )

      if ::oDbfDetalle:Seek( Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem )
         ::oDbfDetalle:Load()

         while Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem == Str( ::oDbfDetalle:nNumRem ) + ::oDbfDetalle:cSufRem

            nRec                  := ::oDbfDetalle:Recno()
            ::oDbfDetalle:nNumRem    := 0
            ::oDbfDetalle:cSufRem    := ""
            ::oDbfDetalle:lCobrado   := .f.
            ::oDbfDetalle:dEntrada   := Ctod( "" )
            ::oDbfDetalle:Save()
            ::oDbfDetalle:GoTo( nRec )

            ::oDbfDetalle:Skip():Load()

         end while

      end if

      ::oDbf:Delete()

   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD DelRecCli( oBrw )

   if MsgNoYes( "¿ Desea eliminar definitivamente este registro ?", "Confirme supersión" )

      ::DelItem()
      ::oDbfDetalle:OrdScope( Str( ::oDbf:nNumRem, 9 ) + ::oDbf:cSufRem )
      oBrw:Refresh()

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DelItem()

   ::oDbfDetalle:nNumRem    := 0
   ::oDbfDetalle:cSufRem    := ""
   ::oDbfDetalle:lCobrado   := .f.
   ::oDbfDetalle:dEntrada   := Ctod( "" )
   ::oDbfDetalle:Save()

RETURN ( Self )

//---------------------------------------------------------------------------//

FUNCTION Remesas( oMenuItem, oWnd )

   local oRemesas

   DEFAULT  oMenuItem   := "01023"
   DEFAULT  oWnd        := oWnd()

   if nLevel == nil
      nLevel := nLevelUsr( oMenuItem )
   end if

   if nAnd( nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      return nil
   end if

   /*
   Cerramos todas las ventanas
   */

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   /*
   Anotamos el movimiento para el navegador
   */

   AddMnuNext( "Remesas de recibos", ProcName() )

   if oRemesas == nil
      oRemesas  := TRemesas():New( cPatEmp() )
      oRemesas:Activate( nLevel )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

static function cToCeros( nImporte, cPicture, nLen )

   local cImporte

   DEFAULT cPicture  := "9999999999"
   DEFAULT nLen      := 10

   cImporte          := Trans( nImporte, cPicture )
   cImporte          := StrTran( cImporte, ",", "" )
   cImporte          := StrTran( cImporte, ".", "" )
   cImporte          := StrTran( Right( cImporte, 10 ), " ", "0" )

return ( cImporte )

//--------------------------------------------------------------------------//

METHOD Report()

	local oDlg
   local aNumDes     := Array( 2 )
   local aNumHas     := Array( 2 )
   local nDevice     := 1
	local nRadio		:= 1
	local nFont			:= 12
   local cTitulo     := Padr( RetEmpresa() + " - " + NbrEmpresa(), 50 )
   local cSubTitulo  := Padr( "Listado de remesas", 50 )

   ::oDbf:GetStatus()
   ::oDbfDetalle:GetStatus()

   aNumDes[ 1 ]      := DBFirst( ::oDbf:cAlias, 1 )
   aNumDes[ 2 ]      := DBFirst( ::oDbf:cAlias, 2 )
   aNumHas[ 1 ]      := DBLast ( ::oDbf:cAlias, 1 )
   aNumHas[ 2 ]      := DBLast ( ::oDbf:cAlias, 2 )

	/*
	Llamada a la funcion que activa la caja de dialogo
	*/

   DEFINE DIALOG oDlg RESOURCE "REP_REMESA"

   REDEFINE GET aNumDes[1] ;
      ID       100 ;
		OF 		oDlg

   REDEFINE GET aNumDes[2] ;
      ID       110 ;
		OF 		oDlg

   REDEFINE GET aNumHas[1] ;
      ID       120 ;
		OF 		oDlg

   REDEFINE GET aNumHas[2] ;
      ID       130 ;
		OF 		oDlg

	REDEFINE GET cTitulo ;
		ID 		180 ;
		OF 		oDlg

	REDEFINE GET cSubTitulo ;
		ID 		190 ;
		OF 		oDlg

	REDEFINE BUTTON ;
		ID 		508;
		OF 		oDlg ;
      ACTION   ::PrnReport( aNumDes, aNumHas, cTitulo, cSubTitulo, 1 )

	REDEFINE BUTTON ;
		ID 		505;
		OF 		oDlg ;
      ACTION   ::PrnReport( aNumDes, aNumHas, cTitulo, cSubTitulo, 2 )

	REDEFINE BUTTON ;
		ID 		510;
		OF 		oDlg ;
		ACTION 	( oDlg:end() )

   ACTIVATE DIALOG oDlg CENTER

   ::oDbf:SetStatus()
   ::oDbfDetalle:SetStatus()

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD PrnReport( aNumDes, aNumHas, cTitulo, cSubTitulo, nDevice )

   local oFont1
   local oFont2

   /*
	Cambiamos los indices
	*/

   ::oDbf:OrdSetFocus( 1 )
   ::oDbfDetalle:OrdSetFocus( "NNUMREM" )

	/*
	Posicionamos en el primer registro
	*/

   ::oDbfDetalle:Seek( Str( aNumDes[ 1 ] ) + aNumDes[ 2 ] )

	/*
	Tipos de Letras
	*/

   oFont1   := TFont():New( "Arial", 0, - 8, .f., .t. )
   oFont2   := TFont():New( "Arial", 0, - 8, .f. )

		IF nDevice == 1

			REPORT oReport ;
				TITLE  	Rtrim( cTitulo ),;
                     Rtrim( cSubTitulo ) ;
				FONT   	oFont1, oFont2 ;
            HEADER   "Fecha : " + dtoc(date())  ;
				FOOTER 	"Página : " + str( oReport:nPage, 3 ) CENTERED;
            CAPTION  "Listado de remesas";
				PREVIEW

		ELSE

         REPORT oReport ;
				TITLE  	Rtrim( cTitulo ),;
                     Rtrim( cSubTitulo ) ;
				FONT   	oFont1, oFont2 ;
            HEADER   "Fecha : " + dtoc(date())  ;
				FOOTER 	"Página : " + str( oReport:nPage, 3 ) CENTERED;
            CAPTION  "Listado de remesas";
            TO PRINTER

		END IF

      COLUMN TITLE   "Número" ;
            DATA     ::oDbfDetalle:cSerie + "/" + Str( ::oDbfDetalle:nNumFac ) + "/" + ::oDbfDetalle:cSufFac + "-" + Str( ::oDbfDetalle:nNumRec ) ;
            SIZE     16 ;
            FONT     2

      COLUMN TITLE   "Fecha" ;
            DATA     DtoC( ::oDbfDetalle:dEntrada ) ;
            SIZE     10 ;
            FONT     2

      COLUMN TITLE    "Cliente" ;
            DATA     ::oDbfDetalle:cCodCli + Space( 1 ) + RetClient( ::oDbfDetalle:cCodCli, ::oClientes:cAlias );
            SIZE     40 ;
            FONT     2

      COLUMN TITLE   "Descripción" ;
            DATA     ::oDbfDetalle:cDescrip ;
            SIZE     30 ;
            FONT     2

      COLUMN TITLE   "Total" ;
            DATA     nTotRecCli( ::oDbfDetalle:cAlias, ::oDivisas:cAlias, ::oDbf:cCodDiv ) ;
            PICTURE  PicOut() ;
				RIGHT ;
            TOTAL ;
            SIZE     12 ;
            FONT     2

      GROUP ON    Str( ::oDbfDetalle:nNumRem ) + ::oDbfDetalle:cSufRem ;
         HEADER   "Remesa : " + oReport:aGroups[1]:cValue ;
         FOOTER   "";
			FONT 2

		END REPORT

		IF oReport:lCreated
			oReport:Margin(0, RPT_RIGHT, RPT_CMETERS)
         oReport:bSkip  := {|| ::oDbfDetalle:Skip( 1 ) }
		END IF

      ACTIVATE REPORT oReport ;
         FOR   Str( ::oDbfDetalle:nNumRem ) + ::oDbfDetalle:cSufRem >= Str( aNumDes[ 1 ] ) + aNumDes[ 2 ] .AND. ;
               Str( ::oDbfDetalle:nNumRem ) + ::oDbfDetalle:cSufRem <= Str( aNumHas[ 1 ] ) + aNumHas[ 2 ] ;
         WHILE !::oDbfDetalle:Eof()

	oFont1:end()
	oFont2:end()
   oReport:End()

RETURN NIL

//--------------------------------------------------------------------------//