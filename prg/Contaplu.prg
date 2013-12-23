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

static cDiario
static cCuenta
static cSubCuenta
static cEmpresa

static aLenSubCuenta       := {}

static cProyecto

static dFechaInicioEmpresa
static dFechaFinEmpresa

static lOpenDiario         := .f.
static lOpenSubCuenta      := .f.

static aSerie              := {"A","B","C","D","E","F","G","H","I","J","K","M","N","O","P","O","R","S","T","U","V","W","X","Y","Z"}

//----------------------------------------------------------------------------//

Function ChkRuta( cRutaConta, lMessage )

   local lReturn     := .f.

   DEFAULT lMessage  := .f.

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

   if Empty( cRuta )
      return .f.
   end if

   if ( Empty( dFecha ) .or. Empty( cRuta ) )
      return .t.
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

   REDEFINE GET oGet1 VAR cGet1;
      ID       104 ;
      ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, cEmpresa ) );
      VALID    ( OrdClearScope( oBrw, cEmpresa ) );
      BITMAP   "Find" ;
      OF       oDlg

   REDEFINE COMBOBOX oCbxOrd ;
      VAR      cCbxOrd ;
      ID       102 ;
      ITEMS    aCbxOrd ;
      OF       oDlg

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

Function nLenSubCta( cRuta, cCodEmp, lMensaje )

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
   local nPosition   := aScan( aLenSubCuenta, {|a| a[ 1 ] == cCodEmp } )

   if nPosition != 0
      Return ( aLenSubCuenta[ nPosition, 2 ] )
   end if

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

      /*
      Nivel de desglose menos 3 que es el numero de digitos de la cuenta----
      */

      nReturn        := ( cEmpresa )->Nivel

      /*
      Añadimos los valoresa al buffer---------------------------------------
      */

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

   DEFAULT lMessage  := .f.
   DEFAULT cCodEmp   := cEmpCnt( "A" )
   DEFAULT cRuta     := cRutCnt()

   if Empty( cRuta )
      Return .f.
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

			lReturn = .F.

      end if

      CLOSE ( cArea )

   end if

RETURN lReturn

//----------------------------------------------------------------------------//

FUNCTION ChkSubCta( cRuta, cCodEmp, cCodSubCta, oGetCta, lMessage, lEmpty )

   local lClose      := .f.
   local lReturn     := .t.

   DEFAULT cCodEmp   := cEmpCnt( "A" )
   DEFAULT lMessage  := .f.
   DEFAULT lEmpty    := .t.
   DEFAULT cRuta     := cRutCnt()

   if Empty( cRuta )
      Return .f.
   end if

   cRuta             := cPath( cRuta )
   cCodSubCta        := Padr( cCodSubCta, 12 )

   if ( Empty( cCodSubCta ) .or. Empty( cRuta ) ) .and. lEmpty
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

   if ( cSubCuenta )->( dbSeek( cCodSubCta ) )

      if !Empty( oGetCta )
         oGetCta:cText( ( cSubCuenta )->Titulo )
      end if

   else

      if lMessage
         msgStop( "Subcuenta : " + cCodSubCta + CRLF + "no encontrada", "Contaplus" )
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

   DEFAULT cCodEmp   := cEmpCnt( "A" )
   DEFAULT cRuta     := cRutCnt()

   if Empty( cRuta )
      Return .f.
   end if

   cRuta             := cPath( cRuta )

   if OpnCta( cRuta, cCodEmp, @cArea )

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

FUNCTION BrwChkSubCta( oCodCta, oGetCta, cRuta, cCodEmp )

	local oDlg
	local oBrw
	local oGet1
	local cGet1
	local oCbxOrd
   local cArea
   local cCbxOrd     := "Cuenta"

   DEFAULT cCodEmp   := cEmpCnt( "A" )
   DEFAULT cRuta     := cRutCnt()

   if Empty( cRuta )
      Return .f.
   end if

   cRuta             := cPath( cRuta )

   if OpenSubCuenta( cRuta, cCodEmp, @cArea, .f. )

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

      /*
			REDEFINE LISTBOX oBrw ;
				FIELDS ;
							(cArea)->COD,;
							(cArea)->TITULO ;
				HEAD ;
                     "Código",;
							"Cuenta" ;
				ID 		105 ;
				ALIAS 	( cArea ) ;
				OF 		oDlg

         oBrw:bLDblClick   := {|| oDlg:end( IDOK ) }
         oBrw:bKeyDown     := {|nKey, nFalg| if( nKey == VK_RETURN, oDlg:end( IDOK ), ) }
      */

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

      Return .f.

   end if

	oCodCta:setFocus()

Return ( nil )

//----------------------------------------------------------------------------//

/*
Crea una subcuenta en contaplus
*/

FUNCTION MkSubCta( oGetSubCta, aTemp, oGet, cRuta, cCodEmp, oGetDebe, oGetHaber, oGetSaldo )

   local n
   local cArea
   local nSumaDB     := 0
   local nSumaHB     := 0
   local cTitCta     := ""
   local cCodSubCta  := oGetSubCta:VarGet()
   local aEmpProced  := {}

   DEFAULT cCodEmp   := cEmpCnt( "A" )
   DEFAULT cRuta     := cRutCnt()

   if Empty( cRuta )
      Return .f.
   end if

   cRuta             := cPath( cRuta )

   cCodSubCta        := PntReplace( oGetSubCta, "0", nLenSubCta() )
   cCodSubCta        := PadR( cCodSubCta, nLenSubCta() )
   cCodSubCta        := AllTrim( cCodSubCta )

   /*
   if len( cCodSubCta ) != nLenSubCta()
      MsgStop( "La longitud de la subcuenta no es correcta." )
      Return .t.
   end if
   */

   if !Empty( cCodSubCta )

      for n := 1 to len( aSerie )

         cCodEmp     := cCodEmpCnt( aSerie[ n ] )

         if !Empty( cCodEmp ) .and. aScan( aEmpProced, cCodEmp ) == 0

            if OpenSubCuenta( cRuta, cCodEmp, @cArea )

               if !( cArea )->( dbSeek( cCodSubCta, .t. ) ) .and. !Empty( aTemp )

                  if ApoloMsgNoYes( "Subcuenta : " + Rtrim( cCodSubCta ) + " no existe en empresa : " + cCodEmp + CRLF + ;
                                    "¿ Desea crearla ?" ,;
                                    "Contabilidad" )

                     aSize( aTemp, 10 )

                     ( cArea )->( DbAppend() )
                     ( cArea )->Cod       := cCodSubCta

                     if ( cArea )->( FieldPos( "IDNIF" ) ) != 0
                        ( cArea )->IdNif     := 1
                     end if

                     if aTemp[ 2 ] != nil
                        ( cArea )->Titulo    := aTemp[ 2 ]
                     end if

                     if aTemp[ 3 ] != NIL
                        ( cArea )->Nif       := aTemp[ 3 ]
                     end if

                     if aTemp[ 4 ] != NIL
                        ( cArea )->Domicilio := aTemp[ 4 ]
                     end if

                     if aTemp[ 5 ] != NIL
                        ( cArea )->Poblacion := aTemp[ 5 ]
                     end if

                     if aTemp[ 6 ] != NIL
                        ( cArea )->Provincia := aTemp[ 6 ]
                     end if

                     if aTemp[ 7 ] != NIL
                        ( cArea )->CodPostal := aTemp[ 7 ]
                     end if

                     if aTemp[ 8 ] != NIL
                        ( cArea )->Telef01   := aTemp[ 8 ]
                     end if

                     if aTemp[ 9 ] != NIL
                        ( cArea )->Fax01     := aTemp[ 9 ]
                     end if

                     if aTemp[ 10 ] != nil
                        ( cArea )->eMail     := aTemp[ 10 ]
                     end if

                     ( cArea )->( DbCommit() )

                     if Empty( cTitCta )
                        cTitCta              := ( cArea )->Titulo
                     end if

                  //else

                     //exit

                  end if

               else

                  if Empty( cTitCta )
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

   end if

   if ValType( oGet ) == "O"
      do case
         case oGet:ClassName() == "TGET" .or. oGet:ClassName() == "TGETHLP"
            oGet:cText( cTitCta )
         case oGet:ClassName() == "TSAY"
            oGet:SetText( cTitCta )
      end case
   end if

   if ValType( oGetDebe ) == "O"
      oGetDebe:cText( nSumaDB )
   elseif ValType( oGetDebe ) == "N"
      oGetDebe := nSumaDB
   end if

   if ValType( oGetHaber ) == "O"
      oGetHaber:cText( nSumaHB )
   elseif ValType( oGetHaber ) == "N"
      oGetHaber := nSumaHB
   end if

   if ValType( oGetSaldo ) == "O"
      oGetSaldo:cText( nSumaDB - nSumaHB )
   end if

Return .t.

//----------------------------------------------------------------------------//

FUNCTION LoadSubCta( cCodSubCta, cRuta, dbfTmp )

   local n
   local cCodEmp
   local dbfDiario
   local aEmpProced  := {}

   DEFAULT cRuta     := cRutCnt()

   if Empty( cRuta )
      Return .f.
   end if

   cRuta             := cPath( cRuta )

   ( dbfTmp )->( __dbZap() )

   if Empty( AllTrim( cCodSubCta ) )
      return .t.
   end if

   for n := 1 to len( aSerie )

      cCodEmp        := cCodEmpCnt( aSerie[ n ] )

      if !Empty( cCodEmp ) .and. aScan( aEmpProced, cCodEmp ) == 0

         dbfDiario   := OpnDiario( cRuta, cCodEmp, .f. )
         if dbfDiario != nil

            ( dbfDiario )->( OrdSetFocus( "SubCd" ) )

            if ( dbfDiario )->( dbSeek( cCodSubCta ) )

               while ( dbfDiario )->SubCta == cCodSubCta .and. !( dbfDiario )->( eof() )

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

RETURN cCtaEsp

//----------------------------------------------------------------------------//

Function lOpenDiario()

Return ( lOpenDiario )

//----------------------------------------------------------------------------//

Function OpenDiario( cRuta, cCodEmp, lMessage )

   local oError
   local oBlock

   DEFAULT cRuta     := cRutCnt()
   DEFAULT cCodEmp   := cEmpCnt( "A" )
   DEFAULT lMessage  := .f.

   if lOpenDiario
      Return ( lOpenDiario )
   end if

   if Empty( cRuta )
      if lMessage
         MsgStop( "Ruta de contaplus ® no valida" )
      end if
      return .f.
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

   RECOVER USING oError

      lOpenDiario    := .f.

      msgStop( "Imposible abrir todas las bases de datos de contaplus" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lOpenDiario )

//----------------------------------------------------------------------------//

FUNCTION CloseDiario()

   if !Empty( cDiario )
      ( cDiario    )->( dbCloseArea() )
   end if

   if !Empty( cCuenta )
      ( cCuenta    )->( dbCloseArea() )
   end if

   if !Empty( cSubCuenta )
      ( cSubCuenta )->( dbCloseArea() )
   end if

   if !Empty( cEmpresa )
      ( cEmpresa )->( dbCloseArea() )
   end if

   cDiario           := nil
   cCuenta           := nil
   cSubCuenta        := nil
   cEmpresa          := nil

   lOpenDiario       := .f.

Return ( lOpenDiario )

//----------------------------------------------------------------------------//
// Esta funci¢n devuelve el ultimo numero de asiento de Contaplus

Function RetLastAsi()

   local nRecno
   local nLastAsi    := 0

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
                     cCodDiv,;
							Fecha,;
							SubCta,;
							Contra,;
                     nImporteDebe,;
							Concepto,;
                     nImporteHaber,;
							Factura,;
							BaseImpo,;
                     IVA,;
							RecEquiv,;
							Documento,;
							Departa,;
							Clave,;
                     lRectificativa,;
							nCasado,;
							tCasado,;
                     lSimula,;
                     cTerNif,;
                     cTerNom,;
                     nEjeCon,;
                     cEjeCta )

   local aTemp
   local cSerie            := "A"
   local oError
   local oBlock
   local nImporte

   DEFAULT cCodDiv         := cDivEmp()
   DEFAULT lRectificativa  := .f.
   DEFAULT lSimula         := .t.
   DEFAULT nImporteDebe    := 0
   DEFAULT nImporteHaber   := 0
   DEFAULT nEjeCon         := 0

   if IsChar( Factura ) 
      cSerie               := SubStr( Factura, 1, 1 )
      Factura              := SubStr( Factura, 2, 9 )
   end if

   if IsNum( Factura )
      Factura              := Alltrim( Str( Factura ) )
   end if

   if Factura != nil
      Factura              := Val( SubStr( Factura, -7 ) )
   end if

   if IsChar( nEjeCon )
      nEjeCon              := Val( nEjeCon )
   end if

   /*
   Solo para bancas importes cero no pasa--------------------------------------
   */

   if lBancas() .and. ( nImporteDebe == 0  ) .and. ( nImporteHaber == 0 )
      return ( aTemp )
   end if

   oBlock                  := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   /*
   Importes en negativo--------------------------------------------------------
   */

   if !uFieldEmpresa( "lAptNeg" ) .and. ( nImporteDebe < 0 .or. nImporteHaber < 0 )
      nImporte             := abs( nImporteDebe )
      nImporteDebe         := abs( nImporteHaber )
      nImporteHaber        := nImporte
   end if

   /*
   Asignacion de campos--------------------------------------------------------
   */

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

   aTemp[ ( cDiario )->( FieldPos( "BASEEURO" ) ) ]      := If ( BaseImpo != NIL, BaseImpo,   aTemp[ ( cDiario )->( FieldPos( "BASEEURO" ) ) ] )
   aTemp[ ( cDiario )->( FieldPos( "EURODEBE" ) ) ]      := If ( nImporteDebe  != NIL, nImporteDebe,    aTemp[ ( cDiario )->( FieldPos( "EURODEBE" ) ) ] )
   aTemp[ ( cDiario )->( FieldPos( "EUROHABER" ) ) ]     := If ( nImporteHaber != NIL, nImporteHaber,   aTemp[ ( cDiario )->( FieldPos( "EUROHABER" ) ) ] )

   aTemp[ ( cDiario )->( FieldPos( "SUBCTA" ) ) ]        := If ( SubCta   != NIL, SubCta,     aTemp[ ( cDiario )->( FieldPos( "SUBCTA" ) ) ] )
   aTemp[ ( cDiario )->( FieldPos( "CONTRA" ) ) ]        := If ( Contra   != NIL, Contra,     aTemp[ ( cDiario )->( FieldPos( "CONTRA" ) ) ] )

   aTemp[ ( cDiario )->( FieldPos( "CONCEPTO" ) ) ]      := If ( Concepto != NIL, Concepto,   aTemp[ ( cDiario )->( FieldPos( "CONCEPTO" ) ) ] )

   aTemp[ ( cDiario )->( FieldPos( "IVA" ) )       ]     := If ( IVA      != NIL, IVA,        aTemp[ ( cDiario )->( FieldPos( "IVA" ) )        ] )
   aTemp[ ( cDiario )->( FieldPos( "RECEQUIV" ) )  ]     := If ( RecEquiv != NIL, RecEquiv,   aTemp[ ( cDiario )->( FieldPos( "RECEQUIV" ) )   ] )
   aTemp[ ( cDiario )->( FieldPos( "DOCUMENTO" ) ) ]     := If ( Documento!= NIL, Documento,  aTemp[ ( cDiario )->( FieldPos( "DOCUMENTO" ) )  ] )
   aTemp[ ( cDiario )->( FieldPos( "DEPARTA" ) )   ]     := If ( Departa  != NIL, Departa,    aTemp[ ( cDiario )->( FieldPos( "DEPARTA" ) )    ] )
   aTemp[ ( cDiario )->( FieldPos( "DEPARTA" ) )   ]     := If ( Departa  != NIL, Departa,    aTemp[ ( cDiario )->( FieldPos( "DEPARTA" ) )    ] )
   aTemp[ ( cDiario )->( FieldPos( "CLAVE" ) )     ]     := If ( Clave    != NIL, Clave,      aTemp[ ( cDiario )->( FieldPos( "CLAVE" ) )      ] )
   aTemp[ ( cDiario )->( FieldPos( "NCASADO" ) )   ]     := If ( nCasado  != NIL, nCasado,    aTemp[ ( cDiario )->( FieldPos( "NCASADO" ) )    ] )
   aTemp[ ( cDiario )->( FieldPos( "TCASADO" ) )   ]     := If ( tCasado  != NIL, tCasado,    aTemp[ ( cDiario )->( FieldPos( "TCASADO" ) )    ] )

   if ( cDiario )->( FieldPos( "TERIDNIF" ) ) != 0
      aTemp[ ( cDiario )->( FieldPos( "TERIDNIF" ) ) ]   := 1
   end if

   if ( cDiario )->( FieldPos( "TERNIF" ) ) != 0
      aTemp[ ( cDiario )->( FieldPos( "TERNIF" ) ) ]     := If ( cTerNif  != NIL, cTerNif,    aTemp[ ( cDiario )->( FieldPos( "TERNIF" ) ) ] )
   end if

   if ( cDiario )->( FieldPos( "TERNOM" ) ) != 0
      aTemp[ ( cDiario )->( FieldPos( "TERNOM" ) ) ]     := If ( cTerNom  != NIL, cTerNom,    aTemp[ ( cDiario )->( FieldPos( "TERNOM" ) ) ] )
   end if

   if lRectificativa
      aTemp[ ( cDiario )->( FieldPos( "RECTIFICA" ) ) ]  := .t.
   end if

   /*
	Para contaplus euro 2000----------------------------------------------------
	*/

   aTemp[ ( cDiario )->( FieldPos( "MONEDAUSO" ) ) ]     := "2"

   /*
   Pagos en metalico-----------------------------------------------------------
   */

   if !Empty( nEjeCon ) .and. !Empty( cEjeCta )

      if ( cDiario )->( FieldPos( "METAL" ) ) != 0
         aTemp[ ( cDiario )->( FieldPos( "METAL") ) ]       := .t.
      end if
      if ( cDiario )->( FieldPos( "METALIMP" ) ) != 0      
         aTemp[ ( cDiario )->( FieldPos( "METALIMP" ) ) ]   := If ( nImporteDebe != NIL,  nImporteDebe,  aTemp[ ( cDiario )->( FieldPos( "METALIMP" ) ) ] )      
      end if
      if ( cDiario )->( FieldPos( "TERNOM" ) ) != 0
         aTemp[ ( cDiario )->( FieldPos( "TERNOM" ) ) ]     := cEjeCta
      end if
      if ( cDiario )->( FieldPos( "METALEJE" ) ) != 0
         aTemp[ ( cDiario )->( FieldPos( "METALEJE") ) ]    := nEjeCon 
      end if

   end if 

   if !lSimula
      WriteAsiento( aTemp, cCodDiv )
   end if

   RECOVER USING oError

      msgStop( "Error al realizar apunte contable." + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( aTemp )

//----------------------------------------------------------------------------//

Function WriteAsiento( aTemp, cCodDiv, lMessage )

   local cMes
   local nFld
   local nVal
   local oBlock
   local oError

   DEFAULT lMessage  := .f.

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if !Empty( cDiario ) .and. !Empty( aTemp[ ( cDiario )->( FieldPos( "FECHA" ) ) ] )

      WinGather( aTemp, , cDiario, , APPD_MODE, , .f. )

      cMes           := Rjust( Month( aTemp[ ( cDiario )->( FieldPos( "FECHA" ) ) ] ), "0", 2 )

      if ( cSubCuenta )->( dbSeek( aTemp[ ( cDiario )->( FieldPos( "SUBCTA" ) ) ] ) ) .and. ( cSubCuenta )->( dbRLock() )

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
            MsgStop( "Subcuenta no encontrada " + aTemp[ ( cDiario )->( FieldPos( "SUBCTA" ) ) ], "Imposible actualizar saldos" )
         end if

      end if

   end if

   RECOVER USING oError

      msgStop( "Error al escribir apunte contable." + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( nil )

//----------------------------------------------------------------------------//

Function aWriteAsiento( aTemp, cCodDiv, lMessage )

   local a

   for each a in aTemp
      WriteAsiento( a, cCodDiv, lMessage )
   next

Return ( nil )

//----------------------------------------------------------------------------//

/*
Devuelve la cuenta de venta de un articulo
*/

FUNCTION RetCtaVta( cCodArt, dbfArticulo )

   local cCtaVta  := ""

   if ( dbfArticulo )->( dbSeek( cCodArt ) )
      cCtaVta     := Rtrim( ( dbfArticulo )->cCtaVta )
   end if

RETURN ( cCtaVta )

//--------------------------------------------------------------------------//

/*
Devuelve la cuenta de compra de un articulo
*/

FUNCTION RetCtaCom( cCodArt, dbfArticulo )

   local cCtaCom  := ""

   if ( dbfArticulo )->( dbSeek( cCodArt ) )
      cCtaCom     := Rtrim( ( dbfArticulo )->cCtaCom )
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
   local cCodEmp  := cEmpCnt( "A" )

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

		msgStop( "Subcuentas no encontradas" )

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
   local lOpen       := .t.

   DEFAULT lMessage  := .f.
   DEFAULT lMessage  := .f.
   DEFAULT cRuta     := cRutCnt()

   if Empty( cRuta )
      return .f.
   end if

   cRuta             := cPath( cRuta )

   if !File( cRuta + "Emp\Empresa.Dbf" ) .or. !File( cRuta + "Emp\Empresa.Cdx" )
      if lMessage
         MsgStop( "Fichero de empresa de Contaplus ® " +  cRuta + "Emp\Empresa.Dbf, no encontrado", "Abriendo fichero de empresas" )
      end if
      Return .f.
   end if

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      USE ( cRuta + "EMP\EMPRESA.DBF" ) NEW VIA ( cLocalDriver() ) SHARED ALIAS ( cCheckArea( "EMPRESA", @cEmpresa ) )
      SET INDEX TO ( cRuta + "EMP\EMPRESA.CDX" )

   RECOVER

      lOpen          := .f.

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

   DEFAULT lMessage  := .f.
   DEFAULT cRuta     := cRutCnt()

   if Empty( cRuta )
      return .f.
   end if

   cRuta             := cPath( cRuta )

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   if File( cRuta + "EMP" + cCodEmp + "\BALAN.DBF" )  .and.;
      File( cRuta + "EMP" + cCodEmp + "\BALAN.CDX" )

		/*
      Nuevo Contaplus----------------------------------------------------------
		*/

      USE ( cRuta + "EMP" + cCodEmp + "\BALAN.DBF" ) NEW SHARED VIA ( cLocalDriver() ) ALIAS ( cCheckArea( "CUENTA", @cArea ) )
      SET INDEX TO ( cRuta + "EMP" + cCodEmp + "\BALAN.CDX" )
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

   DEFAULT lMessage  := .f.
   DEFAULT cRuta     := cRutCnt()

   if Empty( cRuta )
      return .f.
   end if

   cRuta             := cPath( cRuta )

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      /*
      Nuevo Contaplus
      do case
         case File( cRuta + "EMP" + cCodEmp + "\SUBCTA" + cCodEmp + ".CDX" )


         USE ( cRuta + "EMP" + cCodEmp + "\SUBCTA" + cCodEmp + ".DBF" ) NEW SHARED VIA ( cLocalDriver() ) ALIAS ( cCheckArea( "CUENTA", @cArea ) )
         SET ADSINDEX TO ( cRuta + "EMP" + cCodEmp + "\SUBCTA" + cCodEmp + ".CDX" ) ADDITIVE
      */

      if File( cRuta + "EMP" + cCodEmp + "\SUBCTA.CDX" )

         /*
         Primavera
         */

         USE ( cRuta + "EMP" + cCodEmp + "\SUBCTA.DBF" ) NEW SHARED VIA ( cLocalDriver() ) ALIAS ( cCheckArea( "CUENTA", @cArea ) )
         SET INDEX TO ( cRuta + "EMP" + cCodEmp + "\SUBCTA.CDX" ) ADDITIVE

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

FUNCTION MsgTblCon( aTable, cCodDiv, dbfDiv, lConAsi, cTitle, bConta )

   local oDlg
	local oBrw
   local oBtnCon
   local cPorDiv           := cPorDiv( cCodDiv, dbfDiv )

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
         :bEditValue       := {|| aTable[ oBrw:nArrayAt, ( cDiario )->( FieldPos( "Subcta" ) ) ] }
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
         :bFooter          := {|| nTotDebe( aTable, cCodDiv ) }
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
         :bFooter          := {|| nTotHaber( aTable, cCodDiv ) }
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
         :bEditValue       := {|| if( .t. , aTable[ oBrw:nArrayAt, ( cDiario )->( FieldPos( "BaseEuro" ) ) ], aTable[ oBrw:nArrayAt, ( cDiario )->( FieldPos( "BaseImpo" ) ) ] ) }
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
         :bEditValue       := {|| aTable[ oBrw:nArrayAt, ( cDiario )->( FieldPos( "RecEquiv" ) ) ] }
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
         :bEditValue       := {|| aTable[ oBrw:nArrayAt, ( cDiario )->( FieldPos( "Departa" ) ) ] }
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

function nTotDebe( aTable, cCodDiv, cPorDiv )

   local nTotal      := 0
   local oError
   local oBlock

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if !Empty( aTable )

   if .t. // cCodDiv == "EUR"
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

function nTotHaber( aTable, cCodDiv, cPorDiv )

   local nTotal   := 0
   local oError
   local oBlock

   oBlock            := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if .t. // cCodDiv == "EUR"
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

function dbfSubCta() ; return ( cSubCuenta )

//---------------------------------------------------------------------------//

function dbfProyecto() ; return ( cProyecto )

//---------------------------------------------------------------------------//

Function OpnDiario( cRuta, cCodEmp, lMessage )

   local oBlock
   local dbfDiario      := nil

   DEFAULT cCodEmp      := cEmpCnt( "A" )
   DEFAULT lMessage     := .f.
   DEFAULT cRuta        := cRutCnt()

   if Empty( cRuta )
      if lMessage
         MsgStop( "Ruta de Contaplus ® no valida" )
      end if
      Return nil
   end if

   cRuta                := cPath( cRuta )

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

   if File( cRuta + "EMP" + cCodEmp + "\DIARIO.CDX" )

      USE ( cRuta + "EMP" + cCodEmp + "\BALAN.DBF" ) NEW SHARED VIA ( cLocalDriver() ) ALIAS ( cCheckArea( "CUENTA", @dbfBalance ) )
      SET INDEX TO ( cRuta + "EMP" + cCodEmp + "\BALAN.CDX" )
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

   local dbfSubCta

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

   /*
   do case
   case File( cRuta + "EMP" + cCodEmp + "\SUBCTA" + cCodEmp + ".CDX" )

      USE ( cRuta + "EMP" + cCodEmp + "\SUBCTA" + cCodEmp + ".DBF" ) NEW SHARED VIA ( cLocalDriver() ) ALIAS ( cCheckArea( "SUBCUENTA", @dbfSubCta ) )
      SET ADSINDEX TO ( cRuta + "EMP" + cCodEmp + "\SUBCTA" + cCodEmp + ".CDX" )
   */

   if File( cRuta + "EMP" + cCodEmp + "\SUBCTA.CDX" )

      USE ( cRuta + "EMP" + cCodEmp + "\SUBCTA.DBF" ) NEW SHARED VIA ( cLocalDriver() ) ALIAS ( cCheckArea( "SUBCUENTA", @dbfSubCta ) )
      SET INDEX TO ( cRuta + "EMP" + cCodEmp + "\SUBCTA.CDX" )

   else

      if lMessage
         msgStop( "Ficheros no encontrados en ruta " + cRuta + " empresa " + cCodEmp, "Abriendo subcuentas" )
      end if

      Return nil

   end if

   if ( dbfSubCta )->( RddName() ) == nil .or. NetErr()
      if lMessage
         msgStop( "Imposible acceder a fichero Contaplus", "Abriendo subcuentas" )
      end if
      Return nil
   end if

Return ( dbfSubCta )

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

/*
Function SynDiarioContaplus()

   local dbfDiario
   local cDirName       := cGetDir( "Select directory" )
   local cFileNameCdx
   local cFileNameDbf

   cFileNameDbf         := cDirName + "\Diario.Dbf"
   cFileNameCdx         := cDirName + "\Diario.Cdx"

   if !File( cFileNameDbf )
      msgStop( "Fichero " + cFileNameDbf + " no existe" )
      Return .f.
   end if

   if !ApoloMsgNoYes( "Vamos a procesar el fichero" + cFileNameDbf + " desea continuar ?" )
      Return .f.
   end if

   USE ( cFileNameDbf ) NEW VIA ( cDriver() )ALIAS ( cCheckArea( "DIARIO", @dbfDiario ) )
   SET ADSINDEX TO ( cFileNameCdx ) ADDITIVE

   while !( dbfDiario )->( Eof() )

      if ( dbfDiario )->EuroDebe < 0
         LogWrite( Str( ( dbfDiario )->Asien ) + " asiento cambiado EuroDebe" + Str( ( dbfDiario )->EuroDebe ) + " importe anterior" , "Contaplus.Txt" )
         ( dbfDiario )->EuroHaber   := Abs( ( dbfDiario )->EuroDebe )
         ( dbfDiario )->EuroDebe    := 0
      end if

      if ( dbfDiario )->EuroHaber < 0
         LogWrite( Str( ( dbfDiario )->Asien ) + " asiento cambiado EuroHaber" + Str( ( dbfDiario )->EuroHaber ) + " importe anterior" , "Contaplus.Txt" )
         ( dbfDiario )->EuroDebe    := Abs( ( dbfDiario )->EuroHaber )
         ( dbfDiario )->EuroHaber   := 0
      end if

      if ( dbfDiario )->PtaDebe < 0
         LogWrite( Str( ( dbfDiario )->Asien ) + " asiento cambiado PtaDebe" + Str( ( dbfDiario )->PtaDebe ) + " importe anterior" , "Contaplus.Txt" )
         ( dbfDiario )->PtaHaber    := Abs( ( dbfDiario )->PtaDebe )
         ( dbfDiario )->PtaDebe     := 0
      end if

      if ( dbfDiario )->PtaHaber < 0
         LogWrite( Str( ( dbfDiario )->Asien ) + " asiento cambiado PtaHaber" + Str( ( dbfDiario )->PtaDebe ) + " importe anterior" , "Contaplus.Txt" )
         ( dbfDiario )->PtaDebe   := Abs( ( dbfDiario )->PtaHaber )
         ( dbfDiario )->PtaHaber  := 0
      end if

      Titulo( Str( ( dbfDiario )->( OrdKeyNo() ) ) )

      ( dbfDiario )->( dbSkip() )

   end while

   CLOSE( dbfDiario )

   msginfo( "proceso finalizado" )

Return .f.
*/