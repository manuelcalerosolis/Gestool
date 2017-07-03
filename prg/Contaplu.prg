#include "FiveWin.Ch"
#include "Factu.ch" 

// Estructura del fichero de asientos diarios

#define _ASIEN                    1     //   N      6     0
#define _FECHA                    2     //   D      8     0
#define _SUBCTA                   3     //   C     12     0
#define _CONTRA                   4     //   C     12     0
#define _PTADEBE                  5     //   N     12     0
#define _CONCEPTO                 6     //   C     25     0
#define _PTAHABER                 7     //   N     12     0
#define _FACTURA                  8     //   N      7     0
#define _BASEIMPO                 9     //   N     11     0
#define _IVA                     10     //   N      5     2
#define _RECEQUIV                11     //   N      5     2
#define _DOCUMENTO               12     //   C      6     0
#define _DEPARTA                 13     //   C      3     0
#define _CLAVE                   14     //   C      6     0
#define _ESTADO                  15     //   C      1     0
#define _NCASADO                 16     //   N      6     0
#define _TCASADO                 17     //   N      1     0
#define _TRANS                   18     //   N      6     0
#define _CAMBIO                  19     //   N     16     6
#define _DEBEME                  20     //   N     16     6
#define _HABERME                 21     //   N     16     6
#define _AUXILIAR                22     //   C      1     0
#define _SERIE                   23     //   C      1     0
#define _SUCURSAL                24     //   C      4     0
#define _CODDIVISA               25     //   C      1     0
#define _IMPAUXME                26     //   N     16     6
#define _MONEDAUSO               27     //   C      1     0
#define _EURODEBE                28     //   N     16     2
#define _EUROHABER               29     //   N     16     2
#define _BASEEURO                30     //   N     16     2
#define _NOCONV                  31     //   L      1     0
#define _NUMEROINV               32     //   C     10     0

#define _NLENSUBCTAA3            10

static cDiario
static cCuenta
static cEmpresa
static cDiarioSii
static cSubCuenta

static aLenSubCuenta             := {}

static cProyecto

static dFechaInicioEmpresa
static dFechaFinEmpresa

static lOpenDiario               := .f.
static lOpenSubCuenta            := .f.

static nAplicacionContable

static aSerie                    := {"A","B","C","D","E","F","G","H","I","J","K","M","N","O","P","O","R","S","T","U","V","W","X","Y","Z"}

static lAsientoIntraComunitario  := .f.

//----------------------------------------------------------------------------//

Function getDiarioDatabaseContaplus()     ; return ( cDiario )
Function getDiarioSiiDatabaseContaplus()  ; return ( cDiarioSii )
Function getCuentaDatabaseContaplus()     ; return ( cCuenta )
Function getSubCuentaDatabaseContaplus()  ; return ( cSubCuenta )
Function getEmpresaDatabaseContaplus()    ; return ( cEmpresa )

//----------------------------------------------------------------------------//

Function ChkRuta( cRutaConta, lMessage )

   local lReturn     := .f.

   DEFAULT lMessage  := .f.

   if lAplicacionA3()
      Return .t.
   end if

   if Empty( cRutaConta )
      Return .f.
   end if

   cRutaConta        := cPath( cRutaConta )

   if file( cRutaConta + "\CONTAPLW.EXE" )      .OR. ;
      file( cRutaConta + "\CONTAPLU.EXE" )      .OR. ;
      file( cRutaConta + "\CONTABILIDAD.EXE" )

      lReturn := .t.

   else

      if lMessage
         msgStop( "Ruta invalida, fichero Contaplus no encontrado" + CRLF + "en ruta " + cRutaConta + "." )
      end if

      lReturn        := .f.

   end if

RETURN lReturn

//----------------------------------------------------------------------------//

Function chkEmpresaAsociada( cCodigoEmpresa )

   if lAplicacionA3()
      Return ( .t. )
   end if 

Return ( !empty( cCodigoEmpresa ) )

//----------------------------------------------------------------------------//
/*
Comprueba si la fecha esta dentro del margen contable
*/

FUNCTION ChkFecha( cRuta, cCodEmp, dFecha, lMessage, oTree, cText )

   local lClose      := .f.
   local lValidFecha := .t.

   DEFAULT cRuta     := cRutCnt()
   DEFAULT cCodEmp   := cEmpCnt()
   DEFAULT lMessage  := .f.
   DEFAULT cText     := Space( 1 )

   if lAplicacionA3()
      Return ( .t. )
   end if 

   if Empty( cRuta )
      Return ( .f. )
   end if

   if ( Empty( dFecha ) .or. Empty( cRuta ) )
      Return ( .t. )
   end if

   if Empty( cEmpresa )
      cEmpresa       := OpnEmpresa( cRuta, lMessage )
      if Empty( cEmpresa )
         return .f.
      else
         lClose      := .t.
      end if
   end if

   if ( cEmpresa )->( dbSeek( cCodEmp ) )

      dFechaInicioEmpresa  := ( cEmpresa )->FechaIni
      dFechaFinEmpresa     := ( cEmpresa )->FechaFin

   else

      lValidFecha          := .f.
      cText                += "Empresa no encontrada"

      if lMessage
         msgStop( cText )
      end if

   end if

   if lClose
      CloEmpresa()
   end if

   if lValidFecha

      if ( dFecha >= dFechaInicioEmpresa .and. dFecha <= dFechaFinEmpresa )

         lValidFecha       := .t.

      else

         cText             += " fecha del documento " + Dtoc( dFecha ) + " fuera de intervalo de empresa " + cCodEmp + " desde " + Dtoc( dFechaInicioEmpresa ) + " hasta " + Dtoc( dFechaFinEmpresa ) + "."

         if lMessage
            msgStop( cText )
         end if

         if !Empty( oTree )
            oTree:Select( oTree:Add( Alltrim( cText ) ) )
         end if

         lValidFecha       := .f.

      end if

   end if

RETURN ( lValidFecha )

//----------------------------------------------------------------------------//

/*
Comprueba si existe la empresa en Contaplus
*/

FUNCTION ChkEmpresaContaplus( cRuta, cCodEmp, oGetEmp, lMessage )

   local lClose      := .f.
   local lEmpresa    := .t.

   DEFAULT cRuta     := cRutCnt()
   DEFAULT cCodEmp   := cEmpCnt()
   DEFAULT lMessage  := .f.

   if lAplicacionA3()
      Return ( .t. )
   end if 

   if Empty( cRuta )
      Return ( .f. )
   end if

   if Empty( cCodEmp )
      if !Empty( oGetEmp )
         oGetEmp:cText( "" )
      end if
      Return ( .f. )
   end if

   if Empty( cEmpresa )
      cEmpresa       := OpnEmpresa( cRuta, lMessage )
      if Empty( cEmpresa )
         Return ( .f. )
      else
         lClose      := .t.
      end if
   end if

   lEmpresa          := ( cEmpresa )->( dbSeek( cCodEmp ) )
   if lEmpresa
      if !Empty( oGetEmp )
         oGetEmp:cText( ( cEmpresa )->Nombre )
      end if
   else
      if lMessage
         msgStop( "Empresa no encontrada" )
      end if
   end if

   if lClose
      CloEmpresa()
   end if

Return ( lEmpresa )

//----------------------------------------------------------------------------//

FUNCTION cEmpresaContaplus( cRuta, cCodEmp )

   local lClose      := .f.
   local cNbrEmp     := ""

   DEFAULT cRuta     := cRutCnt()
   DEFAULT cCodEmp   := cEmpCnt()

   if !lAplicacionContaplus()
      Return ( cNbrEmp )
   end if

   if Empty( cRuta )
      Return ( cNbrEmp )
   end if

   if Empty( cCodEmp )
      Return ( cNbrEmp )
   end if

   if Empty( cEmpresa )
      cEmpresa       := OpnEmpresa( cRuta, .f. )
      if Empty( cEmpresa )
         Return ( cNbrEmp )
      else
         lClose      := .t.
      end if
   end if

   if ( cEmpresa )->( dbSeek( cCodEmp ) )
      cNbrEmp        := ( cEmpresa )->Nombre
   else
      cNbrEmp        := ""
   end if

   if lClose
      CloEmpresa()
   end if

RETURN ( cNbrEmp )

//----------------------------------------------------------------------------//

FUNCTION BrwEmpresaContaplus( cRuta, oGetEmp ) 

   local oDlg
	local oBrw
	local oGet1
	local cGet1
   local lClose      := .f.
	local oCbxOrd
   local aCbxOrd     := { "Código", "Empresa" }
   local cCbxOrd     := "Código"

   if lAplicacionA3()
      msgStop( "Opción no disponible para A3CON ®" )
      Return( nil )
   end if 

   DEFAULT cRuta     := cRutCnt()

   if Empty( cRuta )
      return .f.
   end if

   if Empty( cEmpresa )
      cEmpresa       := OpnEmpresa( cRuta, .t. )
      if Empty( cEmpresa )
         return .f.
      else
         lClose      := .t.
      end if
   end if

   ( cEmpresa )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Empresas de contaplus ®"

   REDEFINE GET         oGet1 ;
      VAR               cGet1 ;
      ID                104 ;
      ON CHANGE         ( AutoSeek( nKey, nFlags, Self, oBrw, cEmpresa ) );
      VALID             ( OrdClearScope( oBrw, cEmpresa ) );
      BITMAP            "Find" ;
      OF                oDlg

   REDEFINE COMBOBOX    oCbxOrd ;
      VAR               cCbxOrd ;
      ID                102 ;
      ITEMS             aCbxOrd ;
      OF                oDlg

   oBrw                 := IXBrowse():New( oDlg )

   oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   oBrw:cAlias          := cEmpresa
   oBrw:nMarqueeStyle   := 5
   oBrw:cName           := "Browse.Empresas contaplus"

      with object ( oBrw:AddCol() )
         :cHeader       := "Código"
         :cSortOrder    := "Cod"
         :bEditValue    := {|| ( cEmpresa )->Cod }
         :nWidth        := 60
         :bLClickHeader := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader       := "Empresa"
         :cSortOrder    := "Nombre"
         :bEditValue    := {|| ( cEmpresa )->Nombre }
         :nWidth        := 420
         :bLClickHeader := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

   oBrw:CreateFromResource( 105 )

   oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }
   oBrw:bKeyDown        := {|nKey, nFalg| if( nKey == VK_RETURN, oDlg:end( IDOK ), ) }

   REDEFINE BUTTON ;
      ID       500 ;
      OF       oDlg ;
      WHEN     ( .f. ) ;
      ACTION   ( nil )

   REDEFINE BUTTON ;
      ID       501 ;
      OF       oDlg ;
      WHEN     ( .f. ) ;
      ACTION   ( nil )

   REDEFINE BUTTON ;
      ID       IDOK ;
      OF       oDlg ;
      ACTION   ( oDlg:end( IDOK ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
      OF       oDlg ;
      CANCEL ;
      ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK .and. !Empty( oGetEmp )
      oGetEmp:cText( ( cEmpresa )->Cod )
   end if

   if lClose
      CloEmpresa()
   end if

RETURN ( nil )

//----------------------------------------------------------------------------//
/*
Devuelve el numero de digitos de una subcuenta
*/

Function nLenSubcuenta( cRuta, cCodEmp, lMensaje )

Return ( nLenCuentaContaplus( cRuta, cCodEmp, lMensaje ) + 3 )

//----------------------------------------------------------------------------//

FUNCTION nLenCuentaContaplus( cRuta, cCodEmp, lMensaje )

   local nLenCuentaContaplus  := nLenSubcuentaContaplus( cRuta, cCodEmp, lMensaje )

   if nLenCuentaContaplus != 0
      nLenCuentaContaplus -= 3
   end if

Return ( nLenCuentaContaplus )

//----------------------------------------------------------------------------//

FUNCTION nLenSubcuentaContaplus( cRuta, cCodEmp, lMensaje )

   local lClose      := .f.
   local nReturn     := 0
   local nPosition   

   if lAplicacionA3()
      Return ( _NLENSUBCTAA3 )
   end if 

   DEFAULT cRuta     := cRutCnt()
   DEFAULT cCodEmp   := cEmpCnt()
   DEFAULT lMensaje  := .f.

   nPosition         := aScan( aLenSubCuenta, {|a| a[ 1 ] == cCodEmp } )
   if nPosition != 0
      Return ( aLenSubCuenta[ nPosition, 2 ] )
   end if

   if Empty( cRuta )
      if lMensaje
         msgStop( "Ruta vacia" )
      end if
      Return ( nReturn )
   end if

   if Empty( cEmpresa )
      cEmpresa       := OpnEmpresa( cRuta, lMensaje )
      if Empty( cEmpresa )
         Return ( nReturn )
      else
         lClose      := .t.
      end if
   end if

   if ( cEmpresa )->( dbSeek( cCodEmp ) )

      // Nivel de desglose menos 3 que es el numero de digitos de la cuenta----

      nReturn        := ( cEmpresa )->Nivel

      // Añadimos los valoresa al buffer---------------------------------------

      aAdd( aLenSubCuenta, { cCodEmp, nReturn } )

   else

      if lMensaje
         MsgStop( "Empresa " + cCodEmp + " no encontrada." )
      end if

   end if

   if lClose
      CloEmpresa()
   end if

Return ( nReturn )

//----------------------------------------------------------------------------//

FUNCTION nEjercicioContaplus( cRuta, cCodEmp, lMensaje )

   local lClose      := .f.
   local nReturn     := 0

   DEFAULT cRuta     := cRutCnt()
   DEFAULT cCodEmp   := cEmpCnt()
   DEFAULT lMensaje  := .f.

   if Empty( cRuta )
      if lMensaje
         msgStop( "Ruta vacia" )
      end if
      Return ( nReturn )
   end if

   if Empty( cEmpresa )
      cEmpresa       := OpnEmpresa( cRuta, lMensaje )
      if Empty( cEmpresa )
         Return ( nReturn )
      else
         lClose      := .t.
      end if
   end if

   if ( cEmpresa )->( dbSeek( cCodEmp ) )

      nReturn        := ( cEmpresa )->Ejercicio
      
   else

      if lMensaje
         MsgStop( "Empresa " + cCodEmp + " no encontrada." )
      end if

   end if

   if lClose
      CloEmpresa()
   end if

Return ( nReturn )

//----------------------------------------------------------------------------//

/*
Cheque la existencia de una cuenta en contaplus
*/

FUNCTION ChkCta( cCodCuenta, oGetCta, lMessage, cRuta, cCodEmp )

	local cArea
   local lOld        := .t.
   local lReturn     := .t.

   if lAplicacionA3()
      Return ( .t. )
   end if

   DEFAULT lMessage  := .f.
   DEFAULT cCodEmp   := cEmpCnt( "A" )
   DEFAULT cRuta     := cRutCnt()

   if Empty( cRuta )
      Return ( .f. )
   end if

   cRuta             := cPath( cRuta )

   if Empty( cCodCuenta )
      Return .t.
   end if

   if OpnCta( cRuta, cCodEmp, @cArea, lMessage )

      if ( cArea )->( dbSeek( cCodCuenta ) )

         if oGetCta != nil

            do case
               case oGetCta:ClassName() == "TGET" .or. oGetCta:ClassName() == "TGETHLP"
                  oGetCta:cText( ( cArea )->Descrip )
               case oGetCta:ClassName() == "TSAY"
                  oGetCta:SetText( ( cArea )->Descrip )
            end case

         end if

      else

         if lMessage
            msgStop( "Cuenta no encontrada" )
         end if

			lReturn  := .f.

      end if

      CLOSE ( cArea )

   end if

RETURN lReturn

//----------------------------------------------------------------------------//

FUNCTION ChkSubcuenta( cRuta, cCodEmp, cCodSubcuenta, oGetCta, lMessage, lEmpty )

   local lClose      := .f.
   local lReturn     := .t.

   if lAplicacionA3()
      Return ( .t. )
   end if

   DEFAULT cCodEmp   := cEmpCnt( "A" )
   DEFAULT lMessage  := .f.
   DEFAULT lEmpty    := .t.
   DEFAULT cRuta     := cRutCnt()

   if Empty( cRuta )
      Return ( .f. )
   end if

   cRuta             := cPath( cRuta )
   cCodSubcuenta        := Padr( cCodSubcuenta, 12 )

   if ( Empty( cCodSubcuenta ) .or. Empty( cRuta ) ) .and. lEmpty
      return .t.
   end if

   if Empty( cSubCuenta )
      cSubCuenta     := OpnSubCuenta( cRuta, cCodEmp, lMessage )
      if Empty( cSubCuenta )
         return .f.
      else
         lClose      := .t.
      end if
   end if

   if ( cSubCuenta )->( dbSeek( cCodSubcuenta ) )

      if !Empty( oGetCta )
         oGetCta:cText( ( cSubCuenta )->Titulo )
      end if

   else

      if lMessage
         msgStop( "Subcuenta : " + cCodSubcuenta + CRLF + "no encontrada", "Contaplus" )
      end if

      lReturn        := .f.

   end if

   if lClose
      CloSubCuenta()
   end if

RETURN ( lReturn )

//----------------------------------------------------------------------------//

FUNCTION BrwChkCta( oCodCta, oGetCta, cRuta, cCodEmp )

	local oDlg
	local oBrw
	local oGet1
	local cGet1
	local oCbxOrd
	local cArea
   local aCbxOrd     := { "Código", "Cuenta" }
   local cCbxOrd     := "Código"

   if lAplicacionA3()
      msgStop( "Opción no disponible para A3CON ®" )
      Return( nil )
   end if 

   DEFAULT cCodEmp   := cEmpCnt()
   DEFAULT cRuta     := cRutCnt()

   if Empty( cRuta )
      Return ( nil )
   end if

   cRuta             := cPath( cRuta )

   if OpnCta( cRuta, cCodEmp, @cArea, .t. )

      ( cArea )->( dbSetFilter( {|| !Empty( Field->Cta ) }, "!Empty( Field->Cta )" ) )
      ( cArea )->( dbGoTop() )

      DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Cuentas de contaplus ®"

		REDEFINE GET oGet1 VAR cGet1;
			ID 		104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, cArea ) );
         VALID    ( OrdClearScope( oBrw, cArea ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         OF       oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := cArea
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse.Cuenta contaplus"

         with object ( oBrw:AddCol() )
            :cHeader       := "Código"
            :cSortOrder    := "Cta"
            :bEditValue    := {|| ( cArea )->Cta }
            :nWidth        := 60
            :bLClickHeader := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
         end with

         with object ( oBrw:AddCol() )
            :cHeader       := "Cuenta"
            :cSortOrder    := "Descrip"
            :bEditValue    := {|| ( cArea )->Descrip }
            :nWidth        := 420
            :bLClickHeader := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
         end with

      oBrw:CreateFromResource( 105 )

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }
      oBrw:bKeyDown        := {|nKey, nFalg| if( nKey == VK_RETURN, oDlg:end( IDOK ), ) }

      REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oDlg ;
         WHEN     ( .f. ) ;
         ACTION   ( nil )

		REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oDlg ;
         WHEN     ( .f. ) ;
         ACTION   ( nil )

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( oDlg:end(IDOK) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )
      oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )

      ACTIVATE DIALOG oDlg CENTER

      if oDlg:nResult == IDOK

         oCodCta:cText( ( cArea )->Cta )

         do case
            case oGetCta:ClassName() == "TGET" .or. oGetCta:ClassName() == "TGETHLP"
               oGetCta:cText( ( cArea )->Descrip )
            case oGetCta:ClassName() == "TSAY"
               oGetCta:SetText( ( cArea )->Descrip )
         end case

      end if

		CLOSE ( cArea )

   end if

	oCodCta:setFocus()

RETURN ( nil )

//----------------------------------------------------------------------------//

FUNCTION BrwChkSubcuenta( oCodCta, oGetCta, cRuta, cCodEmp )

	local oDlg
	local oBrw
	local oGet1
	local cGet1
	local oCbxOrd
   local cArea
   local cCbxOrd     := "Cuenta"

   if lAplicacionA3()
      msgStop( "Opción no disponible para A3CON ®" )
      Return( nil )
   end if 

   DEFAULT cCodEmp   := cEmpCnt( "A" )
   DEFAULT cRuta     := cRutCnt()

   if Empty( cRuta )
      msgStop( "Ruta no definida" )
      Return ( nil )
   end if

   cRuta             := cPath( cRuta )

   if OpenSubCuenta( cRuta, cCodEmp, @cArea, .t. )

		( cArea )->( dbGoTop() )

      DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Subcuentas de contaplus ®"

			REDEFINE GET oGet1 VAR cGet1;
				ID 		104 ;
				ON CHANGE AutoSeek( nKey, nFlags, Self, oBrw, cArea ) ;
            BITMAP   "FIND" ;
            OF       oDlg

			REDEFINE COMBOBOX oCbxOrd ;
				VAR 		cCbxOrd ;
				ID 		102 ;
            ITEMS    { "Cuenta", "Nombre" } ;
            OF       oDlg

         oBrw                 := IXBrowse():New( oDlg )

         oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
         oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

         oBrw:cAlias          := cArea
         oBrw:nMarqueeStyle   := 5
         oBrw:cName           := "Browse.Cuentas de contaplus"

         with object ( oBrw:AddCol() )
            :cHeader          := "Cuenta"
            :cSortOrder       := "Cods"
            :bEditValue       := {|| ( cArea )->Cod }
            :nWidth           := 80
            :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
         end with

         with object ( oBrw:AddCol() )
            :cHeader          := "Nombre"
            :cSortOrder       := "Tits"
            :bEditValue       := {|| ( cArea )->Titulo }
            :nWidth           := 400
            :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
         end with

         oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }
         oBrw:bRClicked       := {| nRow, nCol, nFlags | oBrw:RButtonDown( nRow, nCol, nFlags ) }

         oBrw:CreateFromResource( 105 )

         REDEFINE BUTTON ;
            ID       500 ;
            OF       oDlg ;
            WHEN     ( .f. ) ;
            ACTION   ( nil )

         REDEFINE BUTTON ;
            ID       501 ;
            OF       oDlg ;
            WHEN     ( .f. ) ;
            ACTION   ( nil )

         REDEFINE BUTTON ;
            ID       IDOK ;
				OF 		oDlg ;
            ACTION   ( oDlg:end(IDOK) )

			REDEFINE BUTTON ;
            ID       IDCANCEL ;
				OF 		oDlg ;
            CANCEL ;
            ACTION   ( oDlg:end() )

         oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
         oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

         oDlg:bStart := {|| oBrw:Load() }

      ACTIVATE DIALOG oDlg CENTER

      if oDlg:nResult == IDOK

         oCodCta:cText( ( cArea )->Cod )

         do case
            case oGetCta:ClassName() == "TGET" .or. oGetCta:ClassName() == "TGETHLP"
               oGetCta:cText( ( cArea )->Titulo )
            case oGetCta:ClassName() == "TSAY"
               oGetCta:SetText( ( cArea )->Titulo )
         end case

      end if

		CLOSE ( cArea )

   else

      msgStop( "Imposible abrir ficheros de Contaplus ®")
      Return .f.

   end if

	oCodCta:setFocus()

Return ( nil )

//----------------------------------------------------------------------------//

/*
Crea una subcuenta en contaplus
*/

FUNCTION mkSubcuenta( oGetSubcuenta, aTemp, oGet, cRuta, cCodEmp, oGetDebe, oGetHaber, oGetSaldo )

   local n
   local cArea
   local nSumaDB        := 0
   local nSumaHB        := 0
   local cTitCta        := ""
   local aEmpProced     := {}
   local cCodSubcuenta  

   if lAplicacionA3()
      Return ( .t. )
   end if 

   DEFAULT cCodEmp      := cEmpCnt( "A" )
   DEFAULT cRuta        := cRutCnt()

   if Empty( cRuta )
      Return ( .f. )
   end if

   cRuta                := cPath( cRuta )

   cCodSubcuenta        := oGetSubcuenta:varGet()
   cCodSubcuenta        := pntReplace( oGetSubcuenta, "0", nLenSubcuenta() )
   cCodSubcuenta        := padr( cCodSubcuenta, nLenSubcuenta() )
   cCodSubcuenta        := alltrim( cCodSubcuenta )

   if empty( cCodSubcuenta )
      RETURN .t.
   end if 

   for n := 1 to len( aSerie )

      cCodEmp           := cCodEmpCnt( aSerie[ n ] )

      if !Empty( cCodEmp ) .and. aScan( aEmpProced, cCodEmp ) == 0

         if OpenSubCuenta( cRuta, cCodEmp, @cArea )

            if !( cArea )->( dbSeek( cCodSubcuenta, .t. ) ) .and. !empty( aTemp )

               if ApoloMsgNoYes( "Subcuenta : " + rtrim( cCodSubcuenta ) + " no existe en empresa : " + cCodEmp + CRLF + ;
                                 "¿ Desea crearla ?" ,;
                                 "Contabilidad" )

                  ( cArea )->( dbappend() )

                  ( cArea )->Cod          := cCodSubcuenta

                  if ( cArea )->( fieldpos( "IDNIF" ) ) != 0
                     ( cArea )->idNif     := 1
                  end if

                  if len( aTemp ) > 1
                     ( cArea )->Titulo    := aTemp[ 2 ]
                  end if

                  if len( aTemp ) > 2
                     ( cArea )->Nif       := aTemp[ 3 ]
                  end if

                  if len( aTemp ) > 3
                     ( cArea )->Domicilio := aTemp[ 4 ]
                  end if

                  if len( aTemp ) > 4
                     ( cArea )->Poblacion := aTemp[ 5 ]
                  end if

                  if len( aTemp ) > 5
                     ( cArea )->Provincia := aTemp[ 6 ]
                  end if

                  if len( aTemp ) > 6
                     ( cArea )->CodPostal := aTemp[ 7 ]
                  end if

                  if len( aTemp ) > 7
                     ( cArea )->Telef01   := aTemp[ 8 ]
                  end if

                  if len( aTemp ) > 8
                     ( cArea )->Fax01     := aTemp[ 9 ]
                  end if

                  if len( aTemp ) > 9
                     ( cArea )->eMail     := aTemp[ 10 ]
                  end if

                  ( cArea )->( dbcommit() )

                  if empty( cTitCta )
                     cTitCta              := ( cArea )->Titulo
                  end if

               end if

            else

               if empty( cTitCta )
                  cTitCta                 := ( cArea )->Titulo
               end if

               nSumaDB                    += ( cArea )->SumaDBEU
               nSumaHB                    += ( cArea )->SumaHBEU

            end if

            CLOSE ( cArea )

            aAdd( aEmpProced, cCodEmp )

         end if

      end if

   next

   if isObject( oGet )
      do case
         case oGet:ClassName() == "TGET" .or. oGet:ClassName() == "TGETHLP"
            oGet:cText( cTitCta )
         case oGet:ClassName() == "TSAY"
            oGet:SetText( cTitCta )
      end case
   end if

   if isObject( oGetDebe )
      oGetDebe:cText( nSumaDB )
   end if 

   if isNum( oGetDebe )
      oGetDebe := nSumaDB
   end if

   if isObject( oGetHaber )
      oGetHaber:cText( nSumaHB )
   end if 

   if isNum( oGetHaber )
      oGetHaber := nSumaHB
   end if

   if isObject( oGetSaldo )
      oGetSaldo:cText( nSumaDB - nSumaHB )
   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION LoadSubcuenta( cCodSubcuenta, cRuta, dbfTmp )

   local n
   local cCodEmp
   local dbfDiario
   local aEmpProced  := {}

   if lAplicacionA3()
      Return ( .t. )
   end if

   DEFAULT cRuta     := cRutCnt()

   if Empty( cRuta )
      Return .f.
   end if

   cRuta             := cPath( cRuta )

   ( dbfTmp )->( __dbZap() )

   if Empty( AllTrim( cCodSubcuenta ) )
      return .t.
   end if

   for n := 1 to len( aSerie )

      cCodEmp        := cCodEmpCnt( aSerie[ n ] )

      if !Empty( cCodEmp ) .and. aScan( aEmpProced, cCodEmp ) == 0

         dbfDiario   := OpnDiario( cRuta, cCodEmp, .f. )
         if dbfDiario != nil

            ( dbfDiario )->( OrdSetFocus( "SubCd" ) )

            if ( dbfDiario )->( dbSeek( cCodSubcuenta ) )

               while ( dbfDiario )->SubCta == cCodSubcuenta .and. !( dbfDiario )->( eof() )

                  ( dbfTmp )->( dbAppend() )

                  ( dbfTmp )->nAsiento  := ( dbfDiario )->Asien
                  ( dbfTmp )->dFecha    := ( dbfDiario )->Fecha
                  ( dbfTmp )->cConcepto := ( dbfDiario )->Concepto
                  ( dbfTmp )->nDebe     := ( dbfDiario )->EuroDebe
                  ( dbfTmp )->nHaber    := ( dbfDiario )->EuroHaber
                  ( dbfTmp )->cDeparta  := ( dbfDiario )->Departa + "." + ( dbfDiario )->Clave
                  ( dbfTmp )->nFactura  := ( dbfDiario )->Factura
                  ( dbfTmp )->nBase     := ( dbfDiario )->BaseEuro
                  ( dbfTmp )->nIva      := ( dbfDiario )->Iva

                  ( dbfDiario )->( dbSkip() )

               end while

            end if

         end if

         ( dbfDiario )->( dbCloseArea() )

         aAdd( aEmpProced, cCodEmp )

      end if

   next

   ( dbfTmp )->( dbGoTop() )

RETURN .T.

//----------------------------------------------------------------------------//
// Esta funci¢n devuelve la cuenta Especial de Contaplus

FUNCTION RetCtaEsp( nCuenta, cRuta, cCodEmp, lMessage )

	local cArea
   local oBlock
	local cCtaEsp		:= ""

   if lAplicacionA3()
      Return ( cCtaEsp )
   end if

	DEFAULT nCuenta	:= 1
   DEFAULT cCodEmp   := cEmpCnt( "A" )
   DEFAULT lMessage  := .f.
   DEFAULT cRuta     := cRutCnt()

   if Empty( cRuta )
      Return ( cCtaEsp )
   end if

   cRuta             := cPath( cRuta )

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   do case
   case File( cRuta + "EMP" + cCodEmp + "\TCTA" + cCodEmp + ".DBF" )

      USE ( cRuta + "EMP" + cCodEmp + "\TCTA" + cCodEmp + ".DBF" ) NEW VIA ( cLocalDriver() ) ALIAS ( cCheckArea( "CUENTA", @cArea ) )

   case File( cRuta + "EMP" + cCodEmp + "\TCTA.DBF" )

      USE ( cRuta + "EMP" + cCodEmp + "\TCTA.DBF" ) NEW VIA ( cLocalDriver() ) ALIAS ( cCheckArea( "CUENTA", @cArea ) )

   end case

   ( cArea )->( dbGoTo( nCuenta ) )

   cCtaEsp           := Rtrim( ( cArea )->Cuenta )

	CLOSE ( cArea )

   RECOVER

      if lMessage
         MsgStop( "Imposible acceder a fichero de empresas de Contaplus ®", "Abriendo fichero de cuentas especiales" )
      end if

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( cCtaEsp )

//----------------------------------------------------------------------------//

Function lOpenDiario()

Return ( lOpenDiario )

//----------------------------------------------------------------------------//

Function OpenDiario( cRuta, cCodEmp, lMessage )

   local oError
   local oBlock

   if lAplicacionA3()
      Return ( .t. )
   end if

   DEFAULT cRuta     := cRutCnt()
   DEFAULT cCodEmp   := cEmpCnt()
   DEFAULT lMessage  := .f.

   if lOpenDiario
      Return ( lOpenDiario )
   end if

   if Empty( cRuta )
      if lMessage
         MsgStop( "Ruta de contaplus ® no valida" )
      end if
      lOpenDiario    := .f.
      Return ( lOpenDiario )
   end if

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      lOpenDiario    := .t.
      cRuta          := cPath( cRuta )

      cDiario        := OpnDiario( cRuta, cCodEmp, lMessage )
      if Empty( cDiario )
         lOpenDiario := .f.
      end if

      cCuenta        := OpnBalance( cRuta, cCodEmp, lMessage )
      if Empty( cCuenta )
         lOpenDiario := .f.
      end if

      cSubCuenta     := OpnSubCuenta( cRuta, cCodEmp, lMessage )
      if Empty( cSubCuenta )
         lOpenDiario := .f.
      end if

      cEmpresa       := OpnEmpresa( cRuta, lMessage )
      if Empty( cEmpresa )
         lOpenDiario := .f.
      end if

      cDiarioSii     := OpnDiarioSii( cRuta, cCodEmp, lMessage )

   RECOVER USING oError

      lOpenDiario    := .f.

      msgStop( "Imposible abrir todas las bases de datos de contaplus" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lOpenDiario )

//----------------------------------------------------------------------------//

FUNCTION CloseDiario()

   if !Empty( cDiario )
      ( cDiario )->( dbCloseArea() )
   end if

   if !Empty( cCuenta )
      ( cCuenta )->( dbCloseArea() )
   end if

   if !Empty( cSubCuenta )
      ( cSubCuenta )->( dbCloseArea() )
   end if

   if !Empty( cEmpresa )
      ( cEmpresa )->( dbCloseArea() )
   end if

   if !empty( cDiarioSii )
      ( cDiarioSii )->( dbCloseArea() )
   end if 

   cDiario           := nil
   cCuenta           := nil
   cEmpresa          := nil
   cSubCuenta        := nil
   cDiarioSii        := nil

   lOpenDiario       := .f.

Return ( lOpenDiario )

//----------------------------------------------------------------------------//
// Esta funci¢n devuelve el ultimo numero de asiento de Contaplus

Function RetLastAsi()

   local nRecno
   local nLastAsi    := 0

   if lAplicacionA3()
      Return ( nLastAsi )
   end if

   if !Empty( cDiario ) .and. ( cDiario )->( Used() )

      nRecno         := ( cDiario )->( Recno() )

      ( cDiario )->( dbGoBottom() )

      nLastAsi       := ( cDiario )->Asien + 1

      ( cDiario )->( dbGoTo( nRecno ) )

   end if

Return ( nLastAsi )

//----------------------------------------------------------------------------//
/*
Realiza los asientos
*/

FUNCTION MkAsiento( 	Asien,;
                     cDivisa,;
							Fecha,;
							Subcuenta,;
							Contrapartida,;
                     nImporteDebe,;
							Concepto,;
                     nImporteHaber,;
							Factura,;
							BaseImponible,;
                     IVA,;
							RecargoEquivalencia,;
							Documento,;
							Departamento,;
							Clave,;
                     lRectificativa,;
							nCasado,;
							tCasado,;
                     lSimula,;
                     cNif,;
                     cNombre,;
                     nEjeCon,;
                     cEjeCta,;
                     l340 )

   local cSerie            := "A"
   local oError
   local oBlock
   local nImporte
   local aAsiento
   local hAsiento

   if lAplicacionA3()
      return .t.
   end if 

   DEFAULT cDivisa         := cDivEmp()
   DEFAULT lRectificativa  := .f.
   DEFAULT lSimula         := .t.
   DEFAULT nImporteDebe    := 0
   DEFAULT nImporteHaber   := 0
   DEFAULT nEjeCon         := 0

   if ischar( Factura ) 
      cSerie               := substr( Factura, 1, 1 )
      if len( Factura ) <= 12
         Factura           := substr( Factura, 2, 9 )
      else
         Factura           := substr( Factura, 2, 10 )
      end if 
   end if

   if isnum( Factura )
      Factura              := alltrim( str( Factura ) )
   end if

   if Factura != nil
      Factura              := val( substr( Factura, -7 ) )
   end if

   if IsChar( nEjeCon )
      nEjeCon              := val( nEjeCon )
   end if

   /*
   Solo para bancas importes cero no pasa--------------------------------------
   */

   if lBancas() .and. ( nImporteDebe == 0  ) .and. ( nImporteHaber == 0 )
      return ( nil )
   end if

   oBlock                  := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      /*
      Importes en negativo--------------------------------------------------------
      */

      if !uFieldEmpresa( "lAptNeg" ) .and. ( nImporteDebe < 0 .or. nImporteHaber < 0 )
         nImporte          := abs( nImporteDebe )
         nImporteDebe      := abs( nImporteHaber )
         nImporteHaber     := nImporte
         if IsNum( BaseImponible )
            BaseImponible  := abs( BaseImponible )
         end if 
      end if

      /*
      Asignacion de campos--------------------------------------------------------
      */

      aAsiento          :=  MkAsientoContaplus( Asien,;
                                                cDivisa,;
                                                Fecha,;
                                                Subcuenta,;
                                                Contrapartida,;
                                                nImporteDebe,;
                                                Concepto,;
                                                nImporteHaber,;
                                                cSerie,;
                                                Factura,;
                                                BaseImponible,;
                                                IVA,;
                                                RecargoEquivalencia,;
                                                Documento,;
                                                Departamento,;
                                                Clave,;
                                                lRectificativa,;
                                                nCasado,;
                                                tCasado,;
                                                lSimula,;
                                                cNif,;
                                                cNombre,;
                                                nEjeCon,;
                                                cEjeCta,;
                                                l340 )   

   RECOVER USING oError

      msgStop( "Error al realizar apunte contable." + CRLF + ErrorMessage( oError ) )

   END SEQUENCE
   ErrorBlock( oBlock )

RETURN ( aAsiento )

//----------------------------------------------------------------------------//

Static Function MkAsientoContaplus( Asien,;
                                    cDivisa,;
                                    Fecha,;
                                    Subcuenta,;
                                    Contrapartida,;
                                    nImporteDebe,;
                                    Concepto,;
                                    nImporteHaber,;
                                    cSerie,;
                                    Factura,;
                                    BaseImponible,;
                                    IVA,;
                                    RecargoEquivalencia,;
                                    Documento,;
                                    Departamento,;
                                    Clave,;
                                    lRectificativa,;
                                    nCasado,;
                                    tCasado,;
                                    lSimula,;
                                    cNif,;
                                    cNombre,;
                                    nEjeCon,;
                                    cEjeCta,;
                                    l340 )

   local aTemp

   // Asignacion de campos--------------------------------------------------------

   aTemp                   := dbBlankRec( cDiario )

   aTemp[ ( cDiario )->( FieldPos( "ASIEN" ) ) ]         := If ( Asien    != NIL, Asien,      RetLastAsi() )
   aTemp[ ( cDiario )->( FieldPos( "FECHA" ) ) ]         := If ( Fecha    != NIL, Fecha,      aTemp[ ( cDiario )->( FieldPos( "FECHA" ) ) ] )

   if ( cDiario )->( FieldPos( "FECHA_OP" ) ) != 0
      aTemp[ ( cDiario )->( FieldPos( "FECHA_OP" ) ) ]   := If ( Fecha    != NIL, Fecha,      aTemp[ ( cDiario )->( FieldPos( "FECHA_OP" ) ) ] )
   end if

   if ( cDiario )->( FieldPos( "FECHA_EX" ) ) != 0
      aTemp[ ( cDiario )->( FieldPos( "FECHA_EX" ) ) ]   := If ( Fecha    != NIL, Fecha,      aTemp[ ( cDiario )->( FieldPos( "FECHA_EX" ) ) ] )
   end if

   aTemp[ ( cDiario )->( FieldPos( "SERIE" ) ) ]         := If ( cSerie   != NIL, cSerie,     aTemp[ ( cDiario )->( FieldPos( "SERIE" ) ) ] )
   aTemp[ ( cDiario )->( FieldPos( "FACTURA" ) ) ]       := If ( Factura  != NIL, Factura,    aTemp[ ( cDiario )->( FieldPos( "FACTURA" ) ) ] )

   aTemp[ ( cDiario )->( FieldPos( "BASEEURO" ) ) ]      := If ( BaseImponible != NIL, BaseImponible,   aTemp[ ( cDiario )->( FieldPos( "BASEEURO" ) ) ] )
   aTemp[ ( cDiario )->( FieldPos( "EURODEBE" ) ) ]      := If ( nImporteDebe  != NIL, nImporteDebe,    aTemp[ ( cDiario )->( FieldPos( "EURODEBE" ) ) ] )
   aTemp[ ( cDiario )->( FieldPos( "EUROHABER" ) ) ]     := If ( nImporteHaber != NIL, nImporteHaber,   aTemp[ ( cDiario )->( FieldPos( "EUROHABER" ) ) ] )

   aTemp[ ( cDiario )->( FieldPos( "SUBCTA" ) ) ]        := If ( Subcuenta   != NIL, Subcuenta,     aTemp[ ( cDiario )->( FieldPos( "SUBCTA" ) ) ] )
   aTemp[ ( cDiario )->( FieldPos( "CONTRA" ) ) ]        := If ( Contrapartida   != NIL, Contrapartida,     aTemp[ ( cDiario )->( FieldPos( "CONTRA" ) ) ] )

   aTemp[ ( cDiario )->( FieldPos( "CONCEPTO" ) ) ]      := If ( Concepto != NIL, Concepto,   aTemp[ ( cDiario )->( FieldPos( "CONCEPTO" ) ) ] )

   aTemp[ ( cDiario )->( FieldPos( "IVA" ) )       ]     := If ( IVA      != NIL, IVA,        aTemp[ ( cDiario )->( FieldPos( "IVA" ) )        ] )
   aTemp[ ( cDiario )->( FieldPos( "RECEQUIV" ) )  ]     := If ( RecargoEquivalencia != NIL, RecargoEquivalencia,   aTemp[ ( cDiario )->( FieldPos( "RECEQUIV" ) )   ] )
   aTemp[ ( cDiario )->( FieldPos( "DOCUMENTO" ) ) ]     := If ( Documento!= NIL, Documento,  aTemp[ ( cDiario )->( FieldPos( "DOCUMENTO" ) )  ] )
   aTemp[ ( cDiario )->( FieldPos( "DEPARTA" ) )   ]     := If ( Departamento != NIL, Departamento,    aTemp[ ( cDiario )->( FieldPos( "DEPARTA" ) )    ] )
   aTemp[ ( cDiario )->( FieldPos( "CLAVE" ) )     ]     := If ( Clave    != NIL, Clave,      aTemp[ ( cDiario )->( FieldPos( "CLAVE" ) )      ] )
   aTemp[ ( cDiario )->( FieldPos( "NCASADO" ) )   ]     := If ( nCasado  != NIL, nCasado,    aTemp[ ( cDiario )->( FieldPos( "NCASADO" ) )    ] )
   aTemp[ ( cDiario )->( FieldPos( "TCASADO" ) )   ]     := If ( tCasado  != NIL, tCasado,    aTemp[ ( cDiario )->( FieldPos( "TCASADO" ) )    ] )

   if ( cDiario )->( FieldPos( "TERNIF" ) ) != 0
      aTemp[ ( cDiario )->( FieldPos( "TERNIF" ) ) ]     := If ( cNif  != NIL, cNif,    aTemp[ ( cDiario )->( FieldPos( "TERNIF" ) ) ] )
   end if

   if ( cDiario )->( FieldPos( "TERNOM" ) ) != 0
      aTemp[ ( cDiario )->( FieldPos( "TERNOM" ) ) ]     := If ( cNombre  != NIL, cNombre,    aTemp[ ( cDiario )->( FieldPos( "TERNOM" ) ) ] )
   end if

   aTemp[ ( cDiario )->( FieldPos( "RECTIFICA" ) ) ]     := lRectificativa

   // Para contaplus euro 2000----------------------------------------------------

   aTemp[ ( cDiario )->( FieldPos( "MONEDAUSO" ) ) ]     := "2"

   // Pagos en metalico-----------------------------------------------------------

   if !Empty( nEjeCon ) .and. !Empty( cEjeCta )

      if ( cDiario )->( FieldPos( "METAL" ) ) != 0
         aTemp[ ( cDiario )->( FieldPos( "METAL") ) ]       := .t.
      end if
      if ( cDiario )->( FieldPos( "METALIMP" ) ) != 0      
         aTemp[ ( cDiario )->( FieldPos( "METALIMP" ) ) ]   := if( nImporteDebe != NIL,  nImporteDebe,  aTemp[ ( cDiario )->( FieldPos( "METALIMP" ) ) ] )      
      end if
      if ( cDiario )->( FieldPos( "METALEJE" ) ) != 0
         aTemp[ ( cDiario )->( FieldPos( "METALEJE") ) ]    := nEjeCon 
      end if

   end if 

   // Operaciones intracomunitarias--------------------------------------------

   if ( cDiario )->( FieldPos( "TipoOpe" ) ) != 0
      aTemp[ ( cDiario )->( FieldPos( "TipoOpe" ) ) ]    := if( getAsientoIntraComunitario(), "P", "" )
   end if

   if ( cDiario )->( FieldPos( "TERIDNIF" ) ) != 0
      aTemp[ ( cDiario )->( FieldPos( "TERIDNIF" ) ) ]   := if( getAsientoIntraComunitario(), 2, 1 )
   end if

   // Conectores GUID--------------------------------------------

   if ( cDiario )->( FieldPos( "Guid" ) ) != 0
      aTemp[ ( cDiario )->( FieldPos( "Guid" ) ) ]       := win_uuidcreatestring()
   end if

   // escritura en el fichero--------------------------------------------

   if !lSimula
      WriteAsiento( aTemp, cDivisa )
   end if

Return ( aTemp )

//---------------------------------------------------------------------------//

Function WriteAsiento( aTemp, cDivisa, lMessage )

   local cMes
   local nFld
   local nVal
   local oBlock
   local oError

   DEFAULT lMessage  := .f.

   if isFalse( runEventScript( "Contaplus\beforeWriteAsiento", aTemp ) )
      debug( "isFalse" )
      Return .f.
   end if    

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if !Empty( cDiario ) .and. !Empty( aTemp[ ( cDiario )->( FieldPos( "FECHA" ) ) ] )

      WinGather( aTemp, , cDiario, , APPD_MODE, , .f. )

      cMes           := Rjust( Month( aTemp[ ( cDiario )->( FieldPos( "FECHA" ) ) ] ), "0", 2 )

      if ( cSubCuenta )->( dbSeek( aTemp[ ( cDiario )->( FieldPos( "SubCta" ) ) ] ) ) .and. ( cSubCuenta )->( dbRLock() )

         ( cSubCuenta )->SUMADBEU               += aTemp[ ( cDiario )->( FieldPos( "EURODEBE" ) ) ]
         ( cSubCuenta )->SUMAHBEU               += aTemp[ ( cDiario )->( FieldPos( "EUROHABER" ) ) ]

         nFld        := ( cSubCuenta )->( FieldPos( "SDB" + cMes + "EU" ) )
         nVal        := ( cSubCuenta )->( FieldGet( nFld ) )
         ( cSubCuenta )->( FieldPut( nFld, nVal + aTemp[ ( cDiario )->( FieldPos( "EURODEBE" ) ) ] ) )

         nFld        := ( cSubCuenta )->( FieldPos( "SHB" + cMes + "EU" ) )
         nVal        := ( cSubCuenta )->( FieldGet( nFld ) )
         ( cSubCuenta )->( FieldPut( nFld, nVal + aTemp[ ( cDiario )->( FieldPos( "EUROHABER" ) ) ] ) )

         nFld        := ( cSubCuenta )->( FieldPos( "NDB" + cMes + "EU" ) )
         nVal        := ( cSubCuenta )->( FieldGet( nFld ) )
         ( cSubCuenta )->( FieldPut( nFld, nVal + aTemp[ ( cDiario )->( FieldPos( "EURODEBE" ) ) ] ) )

         nFld        := ( cSubCuenta )->( FieldPos( "NHB" + cMes + "EU" ) )
         nVal        := ( cSubCuenta )->( FieldGet( nFld ) )
         ( cSubCuenta )->( FieldPut( nFld, nVal + aTemp[ ( cDiario )->( FieldPos( "EUROHABER" ) ) ] ) )

         ( cSubCuenta )->( dbUnLock() )

      else

         if lMessage
            MsgStop( "Subcuenta no encontrada " + aTemp[ ( cDiario )->( FieldPos( "SubCta" ) ) ], "Imposible actualizar saldos" )
         end if

      end if

   end if

   RECOVER USING oError

      msgStop( "Error al escribir apunte contable." + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( nil )

//----------------------------------------------------------------------------//

Function aWriteAsiento( aTemp, cDivisa, lMessage )

   local a

   for each a in aTemp
      WriteAsiento( a, cDivisa, lMessage )
   next

Return ( nil )

//----------------------------------------------------------------------------//

/*
Devuelve la cuenta de venta de un articulo
*/

FUNCTION retCtaVta( cCodArt, lDevolucion, dbfArticulo )

   local cCtaVta        := ""

   DEFAULT lDevolucion  := .f.

   if ( dbfArticulo )->( dbSeek( cCodArt ) )

      if lDevolucion
         cCtaVta        := rtrim( ( dbfArticulo )->cCtaVtaDev )
      end if 

      if empty(cCtaVta)
         cCtaVta        := rtrim( ( dbfArticulo )->cCtaVta )
      end if 
   
   end if

RETURN ( cCtaVta )

//--------------------------------------------------------------------------//

/*
Devuelve la cuenta de compra de un articulo
*/

FUNCTION RetCtaCom( cCodArt, lDevolucion, dbfArticulo )

   local cCtaCom        := ""

   DEFAULT lDevolucion  := .f.

   if ( dbfArticulo )->( dbSeek( cCodArt ) )

      if lDevolucion
         cCtaCom        := rtrim( ( dbfArticulo )->cCtaComDev )
      end if 

      if empty(cCtaCom)
         cCtaCom        := rtrim( ( dbfArticulo )->cCtaCom )
      end if 

   end if

RETURN ( cCtaCom )

//---------------------------------------------------------------------------//

FUNCTION RetCtaTrn( cCodArt, dbfArticulo )

   local cCtaVta  := uFieldEmpresa( "cCtaPor" )

   if ( dbfArticulo )->( dbSeek( cCodArt ) )
      cCtaVta     := Rtrim( ( dbfArticulo )->cCtaTrn )
   end if

RETURN ( cCtaVta )

//--------------------------------------------------------------------------//

/*
Devuelve el grupo de venta de un articulo
*/

FUNCTION RetGrpVta( cCodArt, cRuta, cCodEmp, cAlias, nIva )

   local cCtaVent := Replicate( "0", nLenCuentaContaplus( cRuta, cCodEmp ) )

   if ( cAlias )->( dbSeek( cCodArt ) ) .and. !Empty( ( cAlias )->GrpVent )
      cCtaVent    := Rtrim( ( cAlias )->GrpVent )
   else
      if nIva != nil
         cCtaVent := retGrpAsc( nIva, , cRuta, cCodEmp ) // Devuelve el grupo asociado TIVA.PRG
      end if
   end if

RETURN ( cCtaVent )

//--------------------------------------------------------------------------//

FUNCTION cCtaConta( oGet, dbfCuentas, oGet2 )

	local lClose 	:= .F.
	local lValid	:= .F.
	local xValor	:= oGet:varGet()
   local cRuta    := cRutCnt()
   local cCodEmp  := cEmpCnt()

   if Empty( xValor )
      Return .t.
   elseif At( ".", xValor ) != 0
      xValor      := PntReplace( oGet, "0", nLenCuentaContaplus() )
   else
      xValor      := RJustObj( oGet, "0", nLenCuentaContaplus() )
   end if

   if dbfCuentas == NIL

      if OpenSubCuenta( cRuta, cCodEmp, @dbfCuentas )
         lClose   := .t.
      else
         return .f.
      end if

   end if

	IF !(dbfCuentas)->( DbSeek( xValor, .t. ) )

      oGet:cText( ( dbfCuentas )->Cod )

		IF oGet2 != NIL
         oGet2:cText( ( dbfCuentas )->Titulo )
		END IF

		lValid	:= .T.

	ELSE

		msgStop( "Subcuentas no encontrada" )

	END IF

	IF lClose
      CLOSE ( dbfCuentas )
	END IF

RETURN lValid

//---------------------------------------------------------------------------//

/*
Abre el Fichero de Empresas
*/

STATIC FUNCTION OpnEmpresa( cRuta, lMessage )

   local oBlock

   DEFAULT lMessage  := .f.
   DEFAULT lMessage  := .f.
   DEFAULT cRuta     := cRutCnt()

   if Empty( cRuta )
      return ( nil )
   end if

   cRuta             := cPath( cRuta )

   if !File( cRuta + "Emp\Empresa.Dbf" ) .or. !File( cRuta + "Emp\Empresa.Cdx" )
      if lMessage
         MsgStop( "Fichero de empresa de Contaplus ® " +  cRuta + "Emp\Empresa.Dbf, no encontrado", "Abriendo fichero de empresas" )
      end if
      Return ( nil )
   end if

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      USE ( cRuta + "EMP\EMPRESA.DBF" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "EMPRESA", @cEmpresa ) )
      SET INDEX TO ( cRuta + "EMP\EMPRESA.CDX" )

   RECOVER

      cEmpresa       := nil

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( cEmpresa )

//--------------------------------------------------------------------------//

Function CloEmpresa()

   if !Empty( cEmpresa )
      ( cEmpresa )->( dbCloseArea() )
   end if

   cEmpresa          := nil

Return ( cEmpresa )

//--------------------------------------------------------------------------//
/*
Abre el fichero de Cuentas
*/

STATIC FUNCTION OpnCta( cRuta, cCodEmp, cArea, lMessage )

   local oBlock
   local lOpen       := .t.

   DEFAULT cRuta     := cRutCnt()
   DEFAULT lMessage  := .f.

   if Empty( cRuta )
      return .f.
   end if

   cRuta             := cPath( cRuta )
   cCodEmp           := alltrim( cCodEmp )

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if File( cRuta + "EMP" + cCodEmp + "\Balan.Dbf" )  .and.;
         File( cRuta + "EMP" + cCodEmp + "\Balan.Cdx" )

         USE ( cRuta + "EMP" + cCodEmp + "\Balan.Dbf" ) NEW SHARED VIA ( cLocalDriver() ) ALIAS ( cCheckArea( "CUENTA", @cArea ) )
         SET INDEX TO ( cRuta + "EMP" + cCodEmp + "\Balan.Cdx" )
   		SET TAG TO "CTA"

      else

         if lMessage
            msgStop( "Ficheros no encontrados en ruta " + cRuta + " empresa " + cCodEmp, "Abriendo subcuentas" )
         end if

         lOpen          := .f.

      end if

      if ( cArea )->( RddName() ) == nil .or. NetErr()
         lOpen          := .f.
      end if

   RECOVER

      if lMessage
         msgStop( "Imposible acceder a fichero Contaplus", "Abriendo subcuentas" )
      end if
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lOpen )

//--------------------------------------------------------------------------//
/*
Abre fichero de Subcuentas
*/

FUNCTION OpenSubCuenta( cRuta, cCodEmp, cArea, lMessage )

   local oBlock
   local lOpen       := .t.

   if lAplicacionA3()
      msgStop( "Opción no disponible para A3CON ®" )
      Return ( .f. )
   end if 

   DEFAULT cRuta     := cRutCnt()
   DEFAULT cCodEmp   := cEmpCnt()   
   DEFAULT lMessage  := .f.

   if Empty( cRuta )
      msgStop( "Ruta de Contaplus esta vacia")
      Return ( .f. )
   end if

   cRuta             := cPath( cRuta )
   cCodEmp           := alltrim( cCodEmp )

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if File( cRuta + "EMP" + cCodEmp + "\SubCta.Dbf" ) .and. ;
         File( cRuta + "EMP" + cCodEmp + "\SubCta.Cdx" ) 

         USE ( cRuta + "EMP" + cCodEmp + "\SubCta.Dbf" ) NEW SHARED VIA ( cLocalDriver() ) ALIAS ( cCheckArea( "CUENTA", @cArea ) )
         SET INDEX TO ( cRuta + "EMP" + cCodEmp + "\SubCta.Cdx" ) ADDITIVE

      else

         if lMessage
            msgStop( "Ficheros no encontrados", "Abriendo subcuentas" )
         end if

         lOpen       := .f.

      end if

      if ( cArea )->( RddName() ) == nil .or. NetErr()
         if lMessage
            MsgStop( "Imposible acceder a fichero Contaplus", "Abriendo subcuentas" )
         end if
         lOpen       := .f.
      end if

   RECOVER

      if lMessage
         MsgStop( "Imposible acceder a fichero Contaplus", "Abriendo subcuentas" )
      end if
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lOpen )

//--------------------------------------------------------------------------//

FUNCTION OpenVencimientos( cRuta, cCodEmp, cArea, lMessage )

   local oBlock
   local lOpen       := .t.

   DEFAULT cRuta     := cRutCnt()
   DEFAULT cCodEmp   := cEmpCnt()   
   DEFAULT lMessage  := .f.

   if Empty( cRuta )
      msgStop( "Ruta de Contaplus esta vacia")
      Return ( .f. )
   end if

   cRuta             := cPath( cRuta )
   cCodEmp           := alltrim( cCodEmp )

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if File( cRuta + "EMP" + cCodEmp + "\Venci.Dbf" ) .and. ;
         File( cRuta + "EMP" + cCodEmp + "\Venci.Cdx" ) 

         USE ( cRuta + "EMP" + cCodEmp + "\Venci.Dbf" ) NEW SHARED VIA ( cLocalDriver() ) ALIAS ( cCheckArea( "Venci", @cArea ) )
         SET INDEX TO ( cRuta + "EMP" + cCodEmp + "\Venci.Cdx" ) ADDITIVE

      else

         if lMessage
            msgStop( "Ficheros no encontrados", "Abriendo vencimientos" )
         end if

         lOpen       := .f.

      end if

      if ( cArea )->( RddName() ) == nil .or. NetErr()
         if lMessage
            MsgStop( "Imposible acceder a fichero Contaplus", "Abriendo vencimientos" )
         end if
         lOpen       := .f.
      end if

   RECOVER

      if lMessage
         MsgStop( "Imposible acceder a fichero de vencimientos Contaplus", "Abriendo vencimientos" )
      end if
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lOpen )

//--------------------------------------------------------------------------//

FUNCTION MsgTblCon( aTable, cDivisa, dbfDiv, lConAsi, cTitle, bConta )

   local oDlg
	local oBrw
   local oBtnCon
   local cPorDiv           := cPorDiv( cDivisa, dbfDiv )

   DEFAULT lConAsi         := .f.
   DEFAULT cTitle          := ""

   if !IsArray( aTable ) .or. len( aTable ) < 1
      return nil
   end if

   DEFINE DIALOG oDlg RESOURCE "CONTA" TITLE "Simulador de asientos." + Space( 1 ) + cTitle

   oBrw                    := IXBrowse():New( oDlg )

   oBrw:bClrSel            := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrw:bClrSelFocus       := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   oBrw:SetArray( aTable, , , .f. )

   oBrw:lFooter            := .t.
   oBrw:nMarqueeStyle      := 5
   oBrw:cName              := "Simulador de asientos"

   oBrw:CreateFromResource( 100 )

      with object ( oBrw:AddCol() )
         :cHeader          := "Asiento"
         :bEditValue       := {|| aTable[ oBrw:nArrayAt, ( cDiario )->( FieldPos( "Asien" ) ) ] }
         :nWidth           := 50
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Fecha"
         :bEditValue       := {|| aTable[ oBrw:nArrayAt, ( cDiario )->( FieldPos( "Fecha" ) ) ] }
         :nWidth           := 70
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Subcuenta"
         :bEditValue       := {|| aTable[ oBrw:nArrayAt, ( cDiario )->( FieldPos( "SubCta" ) ) ] }
         :nWidth           := 80
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Contapartida"
         :bEditValue       := {|| aTable[ oBrw:nArrayAt, ( cDiario )->( FieldPos( "Contra" ) ) ] }
         :nWidth           := 80
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Debe"
         :bEditValue       := {|| if( .t. , aTable[ oBrw:nArrayAt, ( cDiario )->( FieldPos( "EuroDebe" ) ) ], aTable[ oBrw:nArrayAt, ( cDiario )->( FieldPos( "PtaDebe" ) ) ] ) }
         :bFooter          := {|| nTotDebe( aTable, cDivisa ) }
         :cEditPicture     := cPorDiv
         :nWidth           := 70
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :nFootStrAlign    := 1
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Concepto"
         :bEditValue       := {|| aTable[ oBrw:nArrayAt, ( cDiario )->( FieldPos( "Concepto" ) ) ] }
         :nWidth           := 170
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Haber"
         :bEditValue       := {|| if( .t., aTable[ oBrw:nArrayAt, ( cDiario )->( FieldPos( "EuroHaber" ) ) ], aTable[ oBrw:nArrayAt, ( cDiario )->( FieldPos( "PtaHaber" ) ) ] ) }
         :bFooter          := {|| nTotHaber( aTable, cDivisa ) }
         :cEditPicture     := cPorDiv
         :nWidth           := 70
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :nFootStrAlign    := 1
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Serie"
         :bEditValue       := {|| aTable[ oBrw:nArrayAt, ( cDiario )->( FieldPos( "Serie" ) ) ] }
         :nWidth           := 20
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Factura"
         :bEditValue       := {|| aTable[ oBrw:nArrayAt, ( cDiario )->( FieldPos( "Factura" ) ) ] }
         :nWidth           := 80
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Base imponible"
         :bEditValue       := {|| if( .t. , aTable[ oBrw:nArrayAt, ( cDiario )->( FieldPos( "BaseEuro" ) ) ], aTable[ oBrw:nArrayAt, ( cDiario )->( FieldPos( "BaseImponible" ) ) ] ) }
         :cEditPicture     := cPorDiv
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := cImp()
         :bEditValue       := {|| aTable[ oBrw:nArrayAt, ( cDiario )->( FieldPos( "IVA" ) ) ] }
         :cEditPicture     := cPorDiv
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "R.E."
         :bEditValue       := {|| aTable[ oBrw:nArrayAt, ( cDiario )->( FieldPos( "RecargoEquivalencia" ) ) ] }
         :cEditPicture     := cPorDiv
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Documento"
         :bEditValue       := {|| aTable[ oBrw:nArrayAt, ( cDiario )->( FieldPos( "Documento" ) ) ] }
         :nWidth           := 100
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Departamento"
         :bEditValue       := {|| aTable[ oBrw:nArrayAt, ( cDiario )->( FieldPos( "Departamento" ) ) ] }
         :nWidth           := 40
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Clave"
         :bEditValue       := {|| aTable[ oBrw:nArrayAt, ( cDiario )->( FieldPos( "Clave" ) ) ] }
         :nWidth           := 60
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Estado"
         :bEditValue       := {|| aTable[ oBrw:nArrayAt, ( cDiario )->( FieldPos( "Estado" ) ) ] }
         :nWidth           := 40
      end with

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

      REDEFINE BUTTON oBtnCon ;
         ID       110 ;
			OF 		oDlg ;
         ACTION   ( if( !Empty( bConta ), Eval( bConta ), ), oDlg:end() )

      REDEFINE BUTTON ;
         ID       120 ;
			OF 		oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      oDlg:AddFastKey( VK_F5, {|| if( !Empty( bConta ), Eval( bConta ), ), oDlg:end() } )

      oDlg:bStart          := {|| if( !lConAsi .or. Empty( bConta ), oBtnCon:Hide(), ) }

	ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//-------------------------------------------------------------------------//

function nTotDebe( aTable, cDivisa, cPorDiv )

   local nTotal      := 0
   local oError
   local oBlock

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if !Empty( aTable )

   if .t. // cDivisa == "EUR"
      aEval( aTable, {|x| nTotal += if( valType( x[ ( cDiario )->( FieldPos( "EURODEBE" ) ) ] ) == "N", x[ ( cDiario )->( FieldPos( "EURODEBE" ) ) ], 0 ) } )
   else
      aEval( aTable, {|x| nTotal += if( valType( x[ ( cDiario )->( FieldPos( "PTADEBE" ) ) ] ) == "N", x[ ( cDiario )->( FieldPos( "PTADEBE" ) ) ], 0 ) } )
   end if

   end if

   RECOVER USING oError

   END SEQUENCE

   ErrorBlock( oBlock )

return ( if( Empty( cPorDiv ), nTotal, Trans( nTotal, cPorDiv ) ) )

//-------------------------------------------------------------------------//

function nTotHaber( aTable, cDivisa, cPorDiv )

   local nTotal   := 0
   local oError
   local oBlock

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if .t. // cDivisa == "EUR"
      aEval( aTable, {|x| nTotal += if( valType( x[ ( cDiario )->( FieldPos( "EUROHABER" ) ) ] ) == "N", x[ ( cDiario )->( FieldPos( "EUROHABER" ) ) ], 0 ) } )
   else
      aEval( aTable, {|x| nTotal += if( valType( x[ ( cDiario )->( FieldPos( "PTAHABER" ) ) ] ) == "N", x[ ( cDiario )->( FieldPos( "PTAHABER" ) ) ], 0 ) } )
   end if

   RECOVER USING oError

   END SEQUENCE

   ErrorBlock( oBlock )

return ( if( Empty( cPorDiv ), nTotal, Trans( nTotal, cPorDiv ) ) )

//-------------------------------------------------------------------------//

FUNCTION BrwProyecto( oCodPro, oGetPro, cRuta, cCodEmp )

	local oDlg
	local oBrw
   local oAdd
   local oEdt
	local oGet1
	local cGet1
	local oCbxOrd
	local cCbxOrd		:= "Nombre"
	local cAreaAnt 	:= Alias()

   if lAplicacionA3()
      msgStop( "Opción no disponible para A3CON ®" )
      Return( nil )
   end if 

   DEFAULT cCodEmp   := cEmpCnt( "A" )
   DEFAULT cRuta     := cRutCnt()

   if Empty( cRuta )
      return .f.
   end if

   cRuta             := cPath( cRuta )

   IF OpnProyecto( cRuta, cCodEmp )

      ( cProyecto )->( dbGoTop() )

      DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Proyectos de contaplus ®"

		REDEFINE GET oGet1 VAR cGet1;
			ID 		104 ;
         ON CHANGE AutoSeek( nKey, nFlags, Self, oBrw, cProyecto ) ;
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    { "Código", "Proyecto" } ;
			OF oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := cProyecto
      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Browse.Proyectos de contaplus"

         with object ( oBrw:AddCol() )
            :cHeader       := "Código"
            :cSortOrder    := "Proye"
            :bEditValue    := {|| ( cProyecto )->Proye }
            :cEditPicture  := "@R ####.######"
            :nWidth        := 80
            :bLClickHeader := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
         end with

         with object ( oBrw:AddCol() )
            :cHeader       := "Proyecto"
            :cSortOrder    := "Descrip"
            :bEditValue    := {|| ( cProyecto )->Descrip }
            :nWidth        := 260
            :bLClickHeader := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
         end with

      oBrw:CreateFromResource( 105 )

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }
      oBrw:bKeyDown        := {|nKey, nFalg| if( nKey == VK_RETURN, oDlg:end( IDOK ), ) }

      REDEFINE BUTTON oAdd;
         ID       500 ;
         OF       oDlg ;
         ACTION   ( nil )

      REDEFINE BUTTON oEdt;
         ID       501 ;
         OF       oDlg ;
         ACTION   ( nil )

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      ACTIVATE DIALOG oDlg CENTER ON INIT ( oAdd:Hide(), oEdt:Hide() )

      IF oDlg:nResult == IDOK

         oCodPro:cText( ( cProyecto )->Proye )

         IF ValType( oGetPro ) == "O"
            oGetPro:cText( ( cProyecto )->Descrip )
			END IF

		END IF

      CloseProyecto()

	END IF

	IF cAreaAnt != ""
		SELECT( cAreaAnt )
	END IF

   oCodPro:setFocus()

RETURN ( nil )

//----------------------------------------------------------------------------//

FUNCTION ChkProyecto( cCodPro, oGetPro, cRuta, cCodEmp, lMessage )

   local cNombreProyecto   := ""

   DEFAULT cRuta           := cRutCnt()
   DEFAULT cCodEmp         := cEmpCnt()
   DEFAULT lMessage        := .f.

   if Empty( cRuta )
      return ( cNombreProyecto )
   end if

   cRuta                   := cPath( cRuta )

   if Empty( cCodPro ) .OR. Empty( cRuta )
      return ( cNombreProyecto )
   end if

   if OpnProyecto( cRuta, cCodEmp )

      if ( cProyecto )->( dbSeek( cCodPro ) )

         cNombreProyecto   := ( cProyecto )->Descrip

      else

         if lMessage
            msgStop( "Proyecto : " + cCodPro + CRLF + "no encontrada", "Contaplus" )
         end if

      end if

      if !Empty( oGetPro )
         oGetPro:cText( cNombreProyecto )
      end if

      CloseProyecto()

   end if

Return ( cNombreProyecto )

//----------------------------------------------------------------------------//

FUNCTION OpnProyecto( cRuta, cCodEmp )

   local lRet        := .f.

   DEFAULT cCodEmp   := cEmpCnt()
   DEFAULT cRuta     := cRutCnt()

   if Empty( cRuta )
      return .f.
   end if

   cRuta             := cPath( cRuta )

   do case
   case File( cRuta + "EMP" + cCodEmp + "\PROYEC" + cCodEmp + ".CDX" )

		/*
		Contaplus nuevo
		*/

      USE ( cRuta + "EMP" + cCodEmp + "\PROYEC" + cCodEmp + ".DBF" ) NEW VIA ( cLocalDriver() ) ALIAS ( cCheckArea( "PROYEC", @cProyecto ) )
      SET INDEX TO ( cRuta + "EMP" + cCodEmp + "\PROYEC" + cCodEmp + ".CDX" )

      IF ( cProyecto )->( RddName() ) == nil .or. NetErr()
         MsgStop( "Imposible acceder a fichero Contaplus", "Abriendo fichero de proyecto" )
         lRet  := .f.
      ELSE
         lRet  := .t.
      END IF

   case File( cRuta + "EMP" + cCodEmp + "\PROYEC.CDX" )

		/*
		Contaplus primavera
		*/

      USE ( cRuta + "EMP" + cCodEmp + "\PROYEC.DBF" ) NEW VIA ( cLocalDriver() ) ALIAS ( cCheckArea( "PROYEC", @cProyecto ) )
      SET INDEX TO ( cRuta + "EMP" + cCodEmp + "\PROYEC.CDX" )

      IF ( cProyecto )->( RddName() ) == nil .or. NetErr()
         MsgStop( "Imposible acceder a fichero Contaplus", "Abriendo fichero de proyecto" )
         lRet  := .f.
      ELSE
         lRet  := .t.
      END IF

   END case

RETURN lRet

//----------------------------------------------------------------------------//

FUNCTION CloseProyecto()

   ( cProyecto  )->( dbCloseArea() )

RETURN NIL

//----------------------------------------------------------------------------//

function cCodEmpCnt( cSer )

   local cCodEmp  := ""

   DEFAULT cSer   := "A"

   cCodEmp        := cEmpCnt( cSer )

RETURN ( cCodEmp )

//---------------------------------------------------------------------------//

function dbfDiario() ; return ( cDiario )

//---------------------------------------------------------------------------//

function dbfCuenta() ; return ( cCuenta )

//---------------------------------------------------------------------------//

function dbfSubcuenta() ; return ( cSubCuenta )

//---------------------------------------------------------------------------//

function dbfProyecto() ; return ( cProyecto )

//---------------------------------------------------------------------------//

Function OpnDiario( cRuta, cCodEmp, lMessage )

   local oBlock
   local dbfDiario      := nil

   DEFAULT cRuta        := cRutCnt()
   DEFAULT cCodEmp      := cEmpCnt()
   DEFAULT lMessage     := .f.

   if Empty( cRuta )
      if lMessage
         MsgStop( "Ruta de Contaplus ® no valida" )
      end if
      Return nil
   end if

   cRuta                := cPath( cRuta )
   cCodEmp              := alltrim( cCodEmp )

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if File( cRuta + "EMP" + cCodEmp + "\DIARIO.CDX" )

         USE ( cRuta + "EMP" + cCodEmp + "\DIARIO.DBF" ) NEW SHARED VIA ( cLocalDriver() ) ALIAS ( cCheckArea( "DIARIO", @dbfDiario ) )
         SET INDEX TO ( cRuta + "EMP" + cCodEmp + "\DIARIO.CDX" ) ADDITIVE
         SET TAG TO "NUASI"

         if ( dbfDiario )->( RddName() ) == nil .or. ( dbfDiario )->( NetErr() )

            if lMessage
               msgStop( "Imposible acceder a fichero Contaplus ®.", "Abriendo diario" )
            end if

            dbfDiario   := nil

         end if

      else

         if lMessage
            msgStop( "Ficheros no encontrados en ruta " + cRuta + " empresa " + cCodEmp, "Abriendo diario" )
         end if

      end if

   RECOVER

      msgStop( "Imposible abrir las bases de datos del diario de Contaplus ®." )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( dbfDiario )

//----------------------------------------------------------------------------//

Function OpnDiarioSii( cRuta, cCodEmp, lMessage )

   local oBlock
   local dbfDiarioSii   := nil

   DEFAULT cRuta        := cRutCnt()
   DEFAULT cCodEmp      := cEmpCnt()
   DEFAULT lMessage     := .f.

   if Empty( cRuta )
      if lMessage
         MsgStop( "Ruta de Contaplus ® no valida" )
      end if
      Return nil
   end if

   cRuta                := cPath( cRuta )
   cCodEmp              := alltrim( cCodEmp )

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if File( cRuta + "EMP" + cCodEmp + "\DIARIOF.CDX" )

         USE ( cRuta + "EMP" + cCodEmp + "\DIARIOF.DBF" ) NEW SHARED VIA ( cLocalDriver() ) ALIAS ( cCheckArea( "DIARIO", @dbfDiarioSii ) )
         SET INDEX TO ( cRuta + "EMP" + cCodEmp + "\DIARIOF.CDX" ) ADDITIVE
         SET TAG TO "NUASI"

         if ( dbfDiarioSii )->( RddName() ) == nil .or. ( dbfDiarioSii )->( NetErr() )

            if lMessage
               msgStop( "Imposible acceder a fichero Contaplus ®.", "Abriendo diario" )
            end if

            dbfDiarioSii   := nil

         end if

      else

         if lMessage
            msgStop( "Ficheros no encontrados en ruta " + cRuta + " empresa " + cCodEmp, "Abriendo diario" )
         end if

      end if

   RECOVER

      msgStop( "Imposible abrir las bases de datos del diario de Contaplus ®." )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( dbfDiarioSii )

//----------------------------------------------------------------------------//


Function OpnBalance( cRuta, cCodEmp, lMessage )

   local dbfBalance

   DEFAULT cCodEmp   := cEmpCnt( "A" )
   DEFAULT lMessage  := .f.
   DEFAULT cRuta     := cRutCnt()

   if Empty( cRuta )
      if lMessage
         MsgStop( "Ruta de Contaplus ® no valida" )
      end if
      Return nil
   end if

   cRuta             := cPath( cRuta )
   cCodEmp           := alltrim( cCodEmp )

   if file( cRuta + "EMP" + cCodEmp + "\Balan.Dbf" ) .and. ;
      file( cRuta + "EMP" + cCodEmp + "\Balan.Cdx" )

      USE ( cRuta + "EMP" + cCodEmp + "\Balan.Dbf" ) NEW SHARED VIA ( cLocalDriver() ) ALIAS ( cCheckArea( "BALAN", @dbfBalance ) )
      SET INDEX TO ( cRuta + "EMP" + cCodEmp + "\Balan.Cdx" )
		SET TAG TO "CTA"

   else

      if lMessage
         msgStop( "Ficheros no encontrados en ruta " + cRuta + " empresa " + cCodEmp, "Abriendo balances" )
      end if

      Return nil

   end if

   if ( dbfBalance )->( RddName() ) == nil .or. NetErr()
      if lMessage
         msgStop( "Imposible acceder a fichero Contaplus", "Abriendo balances" )
      end if
      Return nil
   end if

Return ( dbfBalance )

//----------------------------------------------------------------------------//

Function OpnSubCuenta( cRuta, cCodEmp, lMessage )

   local dbfSubcuenta

   DEFAULT cRuta     := cRutCnt()
   DEFAULT cCodEmp   := cEmpCnt()
   DEFAULT lMessage  := .f.

   if Empty( cRuta )
      if lMessage
         MsgStop( "Ruta de Contaplus ® no valida" )
      end if
      Return nil
   end if

   cRuta             := cPath( cRuta )
   cCodEmp           := alltrim( cCodEmp )

   if file( cRuta + "EMP" + cCodEmp + "\SubCta.Dbf" ) .and. ;
      file( cRuta + "EMP" + cCodEmp + "\SubCta.Cdx" )

      USE ( cRuta + "EMP" + cCodEmp + "\SubCta.Dbf" ) NEW SHARED VIA ( cLocalDriver() ) ALIAS ( cCheckArea( "SUBCUENTA", @dbfSubcuenta ) )
      SET INDEX TO ( cRuta + "EMP" + cCodEmp + "\SubCta.Cdx" )

   else

      if lMessage
         msgStop( "Ficheros no encontrados en ruta " + cRuta + " empresa " + cCodEmp, "Abriendo subcuentas" )
      end if

      Return nil

   end if

   if ( dbfSubcuenta )->( RddName() ) == nil .or. NetErr()
      if lMessage
         msgStop( "Imposible acceder a fichero Contaplus", "Abriendo subcuentas" )
      end if
      Return nil
   end if

Return ( dbfSubcuenta )

//----------------------------------------------------------------------------//

Function CloSubCuenta()

   if !Empty( cSubCuenta )
      ( cSubCuenta )->( dbCloseArea() )
   end if

   cSubCuenta  := nil

Return ( cSubCuenta )

//----------------------------------------------------------------------------//

Function ODiario()

Return ( nil )

//----------------------------------------------------------------------------//

Function CDiario()

Return ( nil )

//----------------------------------------------------------------------------//

Function SetAplicacionContable( nAplicacion )
   
   if nAplicacionContable != nAplicacion
      nAplicacionContable := nAplicacion
   end if 

Return ( nAplicacion )

//---------------------------------------------------------------------------//
       
Function lAplicacionContaplus()

Return ( nAplicacionContable <= 1 )

//---------------------------------------------------------------------------//

Function lAplicacionA3()

Return ( nAplicacionContable == 2 )

//---------------------------------------------------------------------------//

Function setAsientoIntraComunitario( lIntracomunitario )

   lAsientoIntraComunitario   := lIntracomunitario

Return ( lAsientoIntraComunitario )

//---------------------------------------------------------------------------//

Function getAsientoIntraComunitario()

Return ( lAsientoIntraComunitario )

//---------------------------------------------------------------------------//

CLASS EnlaceA3

   CLASSDATA oInstance

   DATA hAsiento
   DATA aAsiento                          INIT {}

   DATA cDirectory                        INIT "C:\ENLACEA3"
   DATA cFile                             INIT "SUENLACE.DAT" 
   DATA hFile 
   DATA cDate                             INIT DateToString()

   DATA cBuffer                           INIT ""

   METHOD New()

   METHOD getInstance()
   METHOD destroyInstance()               INLINE ( ::oInstance := nil )

   METHOD Add( hAsiento )                 INLINE ( if( hhaskey( hAsiento, "Render" ) .and. !empty( hGet( hAsiento, "Render" ) ), aAdd( ::aAsiento, hAsiento ), ) )
   METHOD Show()                          INLINE ( msgInfo( ::cBuffer ) )

   METHOD Directory( cValue )             INLINE ( if( !Empty( cValue ), ::cDirectory        := cValue,                 ::cDirectory ) )
   METHOD File( cValue )                  INLINE ( if( !Empty( cValue ), ::cFile             := cValue,                 ::cFile ) )
   METHOD cDate( dValue )                 INLINE ( if( !Empty( dValue ), ::cDate             := DateToString( dValue ), ::cDate ) )
   METHOD cFullFile()                     INLINE ( ::cDirectory + "\" + ::cFile )
   
   METHOD Render()
   METHOD AutoRender()
   METHOD RenderCabeceraFactura()
   METHOD RenderVentaFactura()
   METHOD RenderReciboFactura()
   METHOD RenderApuntesSinIVA() 

   METHOD GenerateFile()
   METHOD WriteASCII()   
   METHOD WriteInfo( oTree, cInfo )       INLINE ( oTree:Select( oTree:Add( cInfo, 1 ) ) )

   METHOD Signo( nImporte )      
   METHOD Porcentaje( nPorcentaje )         

   METHOD appendBuffer( cValue )          INLINE ( ::cBuffer   += cValue )

   METHOD TipoFormato()                   INLINE ( ::appendBuffer( '3' ) )
   METHOD Empresa()                       INLINE ( ::appendBuffer( padr( ::hAsiento[ "Empresa" ], 5 ) ) )
   METHOD FechaApunte()                   INLINE ( ::appendBuffer( dtos( ::hAsiento[ "Fecha"] ) ) )
   METHOD TipoRegistro()                  INLINE ( ::appendBuffer( if( hhaskey( ::hAsiento, "TipoRegistro" ), ::hAsiento[ "TipoRegistro" ], "0" ) ) )
   METHOD TipoImporte()                   INLINE ( ::appendBuffer( ::hAsiento[ "TipoImporte" ] ) )
   METHOD FechaFactura()                  INLINE ( ::appendBuffer( dtos( ::hAsiento[ "FechaFactura"] ) ) )
   METHOD NumeroFactura()                 INLINE ( ::appendBuffer( padr( ::hAsiento[ "NumeroFactura" ], 10 ) )  )
   METHOD DescripcionApunte()             INLINE ( ::appendBuffer( padr( ::hAsiento[ "DescripcionApunte" ], 30 ) ) )
   METHOD Importe()                       INLINE ( ::appendBuffer( ::Signo( ::hAsiento[ "Importe" ] ) ) )
   METHOD Reserva( nSpace )               INLINE ( ::appendBuffer( space( nSpace ) ) )
   METHOD NIF()                           INLINE ( ::appendBuffer( padr( trimNif( ::hAsiento[ "Nif" ] ), 14 ) ) )
   METHOD NombreCliente()                 INLINE ( ::appendBuffer( padr( ::hAsiento[ "NombreCliente" ], 40 ) ) )
   METHOD CodigoPostal()                  INLINE ( ::appendBuffer( padr( ::hAsiento[ "CodigoPostal" ], 5 ) ) )
   
   METHOD FechaOperacion()                INLINE ( ::appendBuffer( dtos( ::hAsiento[ "FechaOperacion"] ) ) )
   METHOD FechaFactura()                  INLINE ( ::appendBuffer( dtos( ::hAsiento[ "FechaFactura"] ) ) )
   METHOD Fecha()                         INLINE ( ::appendBuffer( dtos( ::hAsiento[ "Fecha" ] ) ) )
   
   METHOD Moneda()                        INLINE ( ::appendBuffer( ::hAsiento[ "Moneda" ] ) )

   METHOD Cuenta()                        INLINE ( ::appendBuffer( padr( ::hAsiento[ "Cuenta" ], 12 ) )  )
   METHOD CuentaTesoreria()               INLINE ( ::appendBuffer( padr( ::hAsiento[ "CuentaTesoreria" ], 12 ) )  )

   METHOD DescripcionCuenta()             INLINE ( ::appendBuffer( padr( ::hAsiento[ "DescripcionCuenta" ], 30 ) ) )

   METHOD SubtipoFactura()                INLINE ( ::appendBuffer( ::hAsiento[ "SubtipoFactura" ] )  )

   METHOD BaseImponible()                 INLINE ( ::appendBuffer( ::Signo( ::hAsiento[ "BaseImponible" ] ) ) )
   METHOD PorcentajeIVA()                 INLINE ( ::appendBuffer( ::Porcentaje( ::hAsiento[ "PorcentajeIVA" ], 5, 2 ) ) )
   METHOD CuotaIVA()                      INLINE ( ::appendBuffer( ::Signo( ::hAsiento[ "BaseImponible" ] * ::hAsiento[ "PorcentajeIVA" ] / 100 ) ) )

   METHOD PorcentajeRecargo()             INLINE ( ::appendBuffer( ::Porcentaje( ::hAsiento[ "PorcentajeRecargo" ], 5, 2 ) ) )
   METHOD CuotaRecargo()                  INLINE ( ::appendBuffer( ::Signo( ::hAsiento[ "BaseImponible" ] * ::hAsiento[ "PorcentajeRecargo" ] / 100 ) ) )

   METHOD PorcentajeRetencion()           INLINE ( ::appendBuffer( ::Porcentaje( ::hAsiento[ "PorcentajeRetencion" ], 5, 2 ) ) )
   METHOD CuotaRetencion()                INLINE ( ::appendBuffer( ::Signo( ::hAsiento[ "BaseImponible" ] * ::hAsiento[ "PorcentajeRetencion" ] / 100 ) ) )

   METHOD Impreso()                       INLINE ( ::appendBuffer( ::hAsiento[ "Impreso" ] ) )
   METHOD SujetaIVA()                     INLINE ( ::appendBuffer( ::hAsiento[ "SujetaIVA" ] ) )
   METHOD Modelo415()                     INLINE ( ::appendBuffer( ::hAsiento[ "Modelo415" ] ) )
   METHOD Analitico()                     INLINE ( ::appendBuffer( if( hhaskey( ::hAsiento, "Analitico" ), ::hAsiento[ "Analitico" ], space( 1 ) ) ) )

   METHOD TipoFacturaVenta()              INLINE ( ::appendBuffer( '1' ) )
   METHOD TipoFacturaCompras()            INLINE ( ::appendBuffer( '2' ) )
   METHOD TipoFacturaBienes()             INLINE ( ::appendBuffer( '3' ) )

   METHOD Generado()                      INLINE ( ::appendBuffer( 'N' ) )

   METHOD FechaVencimiento()              INLINE ( ::appendBuffer( dtos( ::hAsiento[ "FechaVencimiento"] ) ) )
   METHOD TipoVencimiento()               INLINE ( ::appendBuffer( ::hAsiento[ "TipoVencimiento" ] ) )
   METHOD DescripcionVencimiento()        INLINE ( ::appendBuffer( padr( ::hAsiento[ "DescripcionVencimiento" ], 30 ) ) )
   METHOD ImporteVencimiento()            INLINE ( ::appendBuffer( ::Signo( ::hAsiento[ "ImporteVencimiento" ] ) ) )
   METHOD NumeroVencimiento()             INLINE ( ::appendBuffer( str( ::hAsiento[ "NumeroVencimiento" ], 2 ) ) )
   METHOD FormaPago()                     INLINE ( ::appendBuffer( ::hAsiento[ "FormaPago" ] ) )

   METHOD Referencia()                    INLINE ( ::appendBuffer( padr( ::hAsiento[ "Concepto" ], 10 ) ) )
   METHOD ReferenciaDocumento()           INLINE ( ::appendBuffer( padr( ::hAsiento[ "ReferenciaDocumento" ], 10 ) ) )
   
   METHOD LineaApunte()                   INLINE ( ::appendBuffer( if( hb_enumindex() == 1, 'I', if( hb_enumindex() > 1 .and. hb_enumindex() < len( ::aAsiento ), 'M', 'U' ) ) )    )
   
   METHOD FinLinea()                      INLINE ( ::appendBuffer( CRLF ) )

ENDCLASS

//---------------------------------------------------------------------------//

   METHOD New() CLASS EnlaceA3

      if empty( cRutCnt() )
         ::cDirectory                     := "C:\ENLACEA3"
      else
         ::cDirectory                     := cRutCnt()
      end if 
      ::cFile                             := "SUENLACE.DAT" 

      ::aAsiento                          := {}
      ::cDate                             := DateToString()
      ::cBuffer                           := ""

   RETURN ( Self )

//---------------------------------------------------------------------------//

   METHOD GetInstance() CLASS EnlaceA3

      if Empty( ::oInstance )
         ::oInstance                      := ::New()
      end if

   RETURN ( ::oInstance )

//---------------------------------------------------------------------------//

   METHOD Render() CLASS EnlaceA3

      local hAsiento

      for each hAsiento in ::aAsiento

         ::hAsiento     := hAsiento

         do case 
            case hAsiento[ "Render" ] == "CabeceraFactura"
               ::RenderCabeceraFactura()
            case hAsiento[ "Render" ] == "VentaFactura"
               ::RenderVentaFactura()
            case hAsiento[ "Render" ] == "ReciboFactura"
               ::RenderReciboFactura()
            case hAsiento[ "Render" ] == "ApuntesSinIVA"
               ::RenderApuntesSinIVA()
         end case

      next

      ::aAsiento        := {}

   RETURN ( Self )

//---------------------------------------------------------------------------//

   METHOD RenderCabeceraFactura() CLASS EnlaceA3

      ::TipoFormato()
      ::Empresa()
      ::FechaApunte()
      ::TipoRegistro( 1 )
      ::Cuenta()
      ::DescripcionCuenta()
      ::TipoFacturaVenta()
      ::NumeroFactura()
      ::LineaApunte()
      ::DescripcionApunte()
      ::Importe()
      ::Reserva( 62 )
      ::NIF()
      ::NombreCliente()
      ::CodigoPostal()
      ::Reserva( 2 )
      ::FechaOperacion()
      ::FechaOperacion()
      ::Moneda()
      ::Generado()

      ::FinLinea() 

   Return ( Self )

//------------------------------------------------------------------------//

   METHOD RenderVentaFactura() CLASS EnlaceA3

      ::TipoFormato()
      ::Empresa()
      ::FechaApunte()
      ::TipoRegistro()
      ::Cuenta()
      ::DescripcionCuenta()
      ::TipoImporte()
      ::NumeroFactura()
      ::LineaApunte()
      ::DescripcionApunte()
      ::SubtipoFactura()
      ::BaseImponible()
      ::PorcentajeIVA()
      ::CuotaIVA()
      ::PorcentajeRecargo()
      ::CuotaRecargo()
      ::PorcentajeRetencion()
      ::CuotaRetencion()
      ::Impreso()
      ::SujetaIVA()
      ::Modelo415()
      ::Reserva( 75 )
      ::Analitico()
      ::Moneda()
      ::Generado()

      ::FinLinea() 

   Return ( Self )

   //------------------------------------------------------------------------//

   METHOD RenderReciboFactura() CLASS EnlaceA3

      ::TipoFormato()
      ::Empresa()
      ::FechaVencimiento()
      ::TipoRegistro()
      ::Cuenta()
      ::DescripcionCuenta()
      ::TipoVencimiento()
      ::NumeroFactura()
      ::Reserva( 1 )             // Indicador de ampliacion   
      ::DescripcionVencimiento() 
      ::ImporteVencimiento()
      ::FechaFactura()
      ::CuentaTesoreria()
      ::FormaPago()
      ::NumeroVencimiento()
      ::Reserva( 115 )
      ::Moneda()
      ::Generado()

      ::FinLinea() 

   Return ( Self )

   //------------------------------------------------------------------------//

   METHOD RenderApuntesSinIVA() CLASS EnlaceA3

      ::TipoFormato()
      ::Empresa()
      ::Fecha()
      ::TipoRegistro()
      ::Cuenta()
      ::DescripcionCuenta()
      ::TipoImporte()
      ::ReferenciaDocumento()
      ::LineaApunte()
      ::DescripcionApunte()
      ::Importe()
      ::Reserva( 138 )
      ::Analitico()
      ::Moneda()
      ::Generado()

      ::FinLinea() 

   Return ( Self )

   //------------------------------------------------------------------------//

   METHOD Signo( nImporte ) CLASS EnlaceA3

      if nImporte == 0
         Return ( space( 14 ) )
      end if 

   RETURN ( if( nImporte > 0, '+', '-' ) + strzero( abs( nImporte ), 13, 2 ) )

   //------------------------------------------------------------------------//

   METHOD Porcentaje( nPorcentaje ) CLASS EnlaceA3

      if nPorcentaje == 0
         Return ( space( 5 ) )
      end if 

   RETURN ( strzero( ::hAsiento[ "PorcentajeIVA" ], 5, 2 ) ) 

//------------------------------------------------------------------------//

   METHOD GenerateFile() CLASS EnlaceA3

      ferase( ::cFullFile() )

      ::hFile        := fCreate( ::cFullFile() )

   RETURN ( Self )   

//------------------------------------------------------------------------//

   METHOD WriteASCII() CLASS EnlaceA3

      ferase( ::cFullFile() )

      if !file( ::cFullFile() ) .or. empty( ::hFile )
         ::hFile     := fCreate( ::cFullFile() )
      end if 

      if !empty( ::hFile )

         fWrite( ::hFile, ::cBuffer )
         fClose( ::hFile )

         ::cBuffer   := ""
         ::aAsiento  := {}

         if apoloMsgNoYes( "Proceso de exportación realizado con éxito" + CRLF + ;
                           "en fichero " + ( ::cFullFile() )            + CRLF + ;
                           "¿ Desea abrir el fichero resultante ?",;
                           "Elija una opción." )
            shellExecute( 0, "open", ( ::cDirectory + "\" + ::cFile ), , , 1 )
         end if

         Return .t.

      end if

   Return ( .f. )

//------------------------------------------------------------------------//

   METHOD AutoRender() CLASS EnlaceA3

   Return ( Self )

//------------------------------------------------------------------------//



