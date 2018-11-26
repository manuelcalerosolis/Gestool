#include "FiveWin.Ch"
#include "Factu.Ch"

#define __LENCIF__            9
#define __LENSS__             12

//-------------------------------------------------------------------------//
//Funciones del programa
//-------------------------------------------------------------------------//

FUNCTION CalcDigit( cCtaBanco, oCtaBanco )

   local cDc      := Space( 2 )
   local cEntidad := Substr( cCtaBanco, 1, 4 )
	local cSucursal:= Substr( cCtaBanco, 5, 4 )
	local cDigito	:= Substr( cCtaBanco, 9, 2 )
	local cCuenta	:= SubStr( cCtaBanco, 11   )

   if !Empty( cEntidad ) .and. !Empty( cSucursal )

      cDc            := cDgtControl( cEntidad, cSucursal, cDigito, cCuenta )

      if oCtaBanco != nil
         oCtaBanco:cText( cEntidad + cSucursal + cDc + cCuenta )
      end if

   end if

RETURN ( .t. )

//-------------------------------------------------------------------------//

FUNCTION lCalcDC( cEntidad, cSucursal, cDigito, cCuenta, oDigito )

   local cDC   := ""

   if !Empty( cEntidad ) .and. !Empty( cSucursal )

      cDC   := cDgtControl( cEntidad, cSucursal, cDigito, cCuenta )

      if oDigito != nil
         oDigito:cText( cDc )
      end if

   end if

RETURN ( .t. )

//-------------------------------------------------------------------------//

/*
Funci¢n para calcular los 2 d¡gitos de control del
C¢digo de Cuenta de Cliente ( CCC )
seg£n las normas del Consejo Superior Bancario ( Cuaderno 19 )
*/

FUNCTION cDgtControl( cEntidad, cSucursal, cDigito, cCuenta )

	local i
	local cDc
	local cC1
	local cC2
	local cD1
	local cD2
	local nPesos	 := { 6, 3, 7, 9, 10, 5, 8, 4, 2, 1 }
   local nD1       := 0      // primer digito
	local nD2		 := 0

   if Empty( cCuenta )
      RETURN ( cDigito )
   end if

   cCuenta        := RJust( RTrim( cCuenta ), '0', 10 )

   cC1            := cEntidad + cSucursal  // primera cadena : Banco y Oficina
   cC2            := cCuenta

   if len( cC1 ) > len( nPesos ) .or. len( cC2 ) > len( nPesos )
       RETURN ( cDigito )    
   end if 

	for i	:= 1 to len( cC1 )
      nD1         := nD1 + ( val( subStr( cC1, len( cC1 ) - i + 1, 1 ) ) * nPesos[ i ] )
	next i

   nD1            := mod( nD1, 11 )
   nD1            := 11 - nD1

	/*
	Excepciones
	*/

   if nD1 == 10
      nD1         := 1
	endif

   if nD1 == 11
      nD1         := 0
	endif

   cD1            := Trans( nD1, "#" )

	/*
	Calcula el segundo d¡gito de control
	*/

	for i :=	1 to len( cC2 )
      nD2         := nD2+ ( val( substr( cC2, len( cC2 ) - i + 1, 1 ) ) * nPesos[ i ] )
	next i

   nD2 := mod( nD2, 11 )
   nD2            := 11 -  nD2

	/*
	Excepciones
	*/

   if nD2 == 10
      nD2         := 1
	endif

   if nD2 == 11
      nD2         := 0
	endif

   cD2            := Trans( nD2, "#" )
   cDc            := cD1 + cD2

RETURN ( cDc )

//--------------------------------------------------------------------------//

FUNCTION cCuentaBancaria( dbf )

RETURN ( ( dbf )->cEntBnc + ( dbf )->cSucBnc + ( dbf )->cDigBnc + ( dbf )->cCtaBnc )

//--------------------------------------------------------------------------//

FUNCTION aCuentaBancaria( aTmp, dbf )

RETURN ( aTmp[ ( dbf )->( Fieldpos( "cEntBnc" ) ) ] + aTmp[ ( dbf )->( Fieldpos( "cSucBnc" ) ) ] + aTmp[ ( dbf )->( Fieldpos( "cDigBnc" ) ) ] + aTmp[ ( dbf )->( Fieldpos( "cCtaBnc" ) ) ] )

//--------------------------------------------------------------------------//

FUNCTION DateTimeFormatTimestamp( dDate, cTime )

   local cTimestamp  := ""

   cTimestamp        += AllTrim( Str( Year( dDate ) ) ) + "-"
   cTimestamp        += AllTrim( Str( Month( dDate ) ) ) + "-"
   cTimestamp        += AllTrim( Str( Day( dDate ) ) )
   cTimestamp        += Space( 1 )
   
   if at( cTime, ":" ) == 0
      cTimestamp     += SubStr( cTime, 1, 2 ) + ":"
      cTimestamp     += SubStr( cTime, 3, 2 ) + ":"
      cTimestamp     += SubStr( cTime, 5, 2 )
   else 
      cTimestamp     += SubStr( cTime, 1, 8 )
   end if 

RETURN ( cTimestamp )

//--------------------------------------------------------------------------//

FUNCTION Iban( cCountry, cAccount, nLen )

  local cIban

  if nLen  != len( cCountry + cAccount ) + 2
    cIban := "incorrect IBAN code"
  else
    cIban := cCountry + IbanDigit( cCountry, cAccount ) + cAccount
  endif

RETURN( cIban )

//----------------------------------------------------------------//

FUNCTION lIbanDigit( cCountry, cEntidad, cSucursal, cDigito, cCuenta, oGet )

  oGet:cText( IbanDigit( cCountry, cEntidad, cSucursal, cDigito, cCuenta ) )

RETURN ( .t. )  

//----------------------------------------------------------------//

FUNCTION IbanDigit( cCountry, cEntidad, cSucursal, cDigito, cCuenta )

  local n
  local cDC         := ""
  local cIban       := cEntidad + cSucursal + cDigito + cCuenta
  local cAlgorithm  := "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

  DEFAULT cCountry  := Space( 2 )

  if !Empty( cIban )
  
    cIban += str( at( substr(cCountry,1,1), cAlgorithm ) +9, 2, 0 )
    cIban += str( at( substr(cCountry,2,1), cAlgorithm ) +9, 2, 0 )
    cIban += "00"
   
    do while len( cIban ) > 3
      cDC   := str( val(substr( cIban, 1, 9 )) % 97, 2 )
      cIban := cDC + substr( cIban, 10 )
    enddo
    cDC := strzero( 98 - val(cDC), 2 )
    
  end if
 
RETURN( cDC ) 

//----------------------------------------------------------------//

FUNCTION IbanCheck( cIban )

 local cAlgorithm := "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
 local cCountry   := substr( cIban, 1, 2 )
 local cDC        := substr( cIban, 3, 2 )

 cIban            := substr( cIban, 5 )
 cIban            += str( at( substr(cCountry,1,1), cAlgorithm ) +9, 2, 0 )
 cIban            += str( at( substr(cCountry,2,1), cAlgorithm ) +9, 2, 0 )
 cIban            += cDC

 do while len( cIban ) > 3
   cDC            := str( val(substr( cIban, 1, 9 )) % 97, 2 )
   cIban          := cDC + substr( cIban, 10 )
 enddo
 
RETURN( val(cDC) == 1 )

//----------------------------------------------------------------//

FUNCTION cCuentaIBAN( dbf )

RETURN ( ( dbf )->cPaisIBAN + ( dbf )->cCrtlIBAN + cCuentaBancaria( dbf ) )

//----------------------------------------------------------------//

FUNCTION aCuentaIBAN( aTmp, dbf )

RETURN ( aTmp[ ( dbf )->( FieldPos( "cPaisIBAN" ) ) ] + aTmp[ ( dbf )->( FieldPos( "cCtrlIBAN" ) ) ] + aCuentaBancaria( aTmp, dbf ) )

//----------------------------------------------------------------//

FUNCTION PictureCuentaIBAN( dbf )

RETURN ( ( dbf )->cPaisIBAN + ( dbf )->cCtrlIBAN + "-" + ( dbf )->cEntBnc + "-" + ( dbf )->cSucBnc + "-" + ( dbf )->cDigBnc + "-" + ( dbf )->cCtaBnc )

//----------------------------------------------------------------//

/*
Esta funcion sirve para transformar numero en cadenas para EDM
*/

FUNCTION RetNum( nNum, nUnd, nDec )

   local cChr
   local cLst

   DEFAULT nUnd   := len( nNum )
   DEFAULT nDec   := 2

   nNum           := nNum * val( "1" + replicate( "0", nDec ) )

   cChr           := Str( Int( nNum ), nUnd )
   cChr           := StrTran( cChr, " ", "0" )

   /*
   Si el numero es negativo
   */

   IF nNum < 0

      cLst        := SubStr( cChr, -1 )

      DO CASE
         CASE cLst == "0"
            cChr := SubStr( cChr, 1, len( cChr ) - 1 ) + "}"
         CASE cLst == "1"
            cChr := SubStr( cChr, 1, len( cChr ) - 1 ) + "J"
         CASE cLst == "2"
            cChr := SubStr( cChr, 1, len( cChr ) - 1 ) + "K"
         CASE cLst == "3"
            cChr := SubStr( cChr, 1, len( cChr ) - 1 ) + "L"
         CASE cLst == "4"
            cChr := SubStr( cChr, 1, len( cChr ) - 1 ) + "M"
         CASE cLst == "5"
            cChr := SubStr( cChr, 1, len( cChr ) - 1 ) + "N"
         CASE cLst == "6"
            cChr := SubStr( cChr, 1, len( cChr ) - 1 ) + "O"
         CASE cLst == "7"
            cChr := SubStr( cChr, 1, len( cChr ) - 1 ) + "P"
         CASE cLst == "8"
            cChr := SubStr( cChr, 1, len( cChr ) - 1 ) + "Q"
         CASE cLst == "9"
            cChr := SubStr( cChr, 1, len( cChr ) - 1 ) + "R"
      END DO

   END IF

RETURN ( cChr )

//--------------------------------------------------------------------------//

static FUNCTION nValDec( num )

   local cDec  := Str( ( num - int( num ) ) * 1000000 )

   while len( cDec ) > 0 .and. ( SubStr( cDec, -1 ) == "0" .or. SubStr( cDec, -1 ) == "." )
      cDec := SubStr( cDec, 1, len( cDec ) - 1 )
   end while

RETURN ( Val( cDec ) )

//--------------------------------------------------------------------------//

FUNCTION BigCalculadora( nNumber, cTitulo )

RETURN Calculadora( nNumber, nil, nil, cTitulo )

//--------------------------------------------------------------------------//

FUNCTION Calculadora( nNumber, oGet, lBig, cTitulo )

   local oDialogo
   local cNumber
   local oNumber
   local nValue      := 0
   local cOperacion  := ""
   local cTitle     

    if Empty( cTitulo) 
      cTitle         := "Calculadora"
    else
      cTitle         := cTitulo
    end if

   DEFAULT nNumber   := oGet:VarGet()
   DEFAULT lBig      := .t.

   cNumber           := Ltrim( Str( nNumber, 20 ) )

   if lBig
      DEFINE DIALOG oDialogo RESOURCE "Calculadora" TITLE cTitle
   else
      DEFINE DIALOG oDialogo RESOURCE "CalculadoraLittle" TITLE cTitle
   end if

      REDEFINE GET oNumber VAR cNumber ID 100 OF oDialogo

      REDEFINE BUTTON ID 101 OF oDialogo ACTION KeyCal( "C", @cNumber, oNumber, @cOperacion, @nValue )
      REDEFINE BUTTON ID 102 OF oDialogo ACTION KeyCal( "<", @cNumber, oNumber, @cOperacion, @nValue )
      REDEFINE BUTTON ID 103 OF oDialogo ACTION KeyCal( "S", @cNumber, oNumber, @cOperacion, @nValue )
      REDEFINE BUTTON ID 104 OF oDialogo ACTION KeyCal( "/", @cNumber, oNumber, @cOperacion, @nValue )
      REDEFINE BUTTON ID 108 OF oDialogo ACTION KeyCal( "*", @cNumber, oNumber, @cOperacion, @nValue )
      REDEFINE BUTTON ID 112 OF oDialogo ACTION KeyCal( "-", @cNumber, oNumber, @cOperacion, @nValue )
      REDEFINE BUTTON ID 116 OF oDialogo ACTION KeyCal( "+", @cNumber, oNumber, @cOperacion, @nValue )
      REDEFINE BUTTON ID 119 OF oDialogo ACTION KeyCal( "=", @cNumber, oNumber, @cOperacion, @nValue )
      REDEFINE BUTTON ID 118 OF oDialogo ACTION KeyCal( ".", @cNumber, oNumber, @cOperacion, @nValue )
      REDEFINE BUTTON ID 117 OF oDialogo ACTION KeyCal( "0", @cNumber, oNumber, @cOperacion, @nValue )
      REDEFINE BUTTON ID 113 OF oDialogo ACTION KeyCal( "1", @cNumber, oNumber, @cOperacion, @nValue )
      REDEFINE BUTTON ID 114 OF oDialogo ACTION KeyCal( "2", @cNumber, oNumber, @cOperacion, @nValue )
      REDEFINE BUTTON ID 115 OF oDialogo ACTION KeyCal( "3", @cNumber, oNumber, @cOperacion, @nValue )
      REDEFINE BUTTON ID 109 OF oDialogo ACTION KeyCal( "4", @cNumber, oNumber, @cOperacion, @nValue )
      REDEFINE BUTTON ID 110 OF oDialogo ACTION KeyCal( "5", @cNumber, oNumber, @cOperacion, @nValue )
      REDEFINE BUTTON ID 111 OF oDialogo ACTION KeyCal( "6", @cNumber, oNumber, @cOperacion, @nValue )
      REDEFINE BUTTON ID 105 OF oDialogo ACTION KeyCal( "7", @cNumber, oNumber, @cOperacion, @nValue )
      REDEFINE BUTTON ID 106 OF oDialogo ACTION KeyCal( "8", @cNumber, oNumber, @cOperacion, @nValue )
      REDEFINE BUTTON ID 107 OF oDialogo ACTION KeyCal( "9", @cNumber, oNumber, @cOperacion, @nValue )

      REDEFINE BUTTONBMP ;
         BITMAP   "gc_check_32" ;
         ID       IDOK ;
         OF       oDialogo ;
         ACTION   ( oDialogo:End( IDOK ) )

      REDEFINE BUTTONBMP ;
         BITMAP   "Delete_32" ;
         ID       IDCANCEL ;
         OF       oDialogo ;
         ACTION   ( oDialogo:End() )

      oDialogo:bKeydown   := { | nKey | KeyCal( nKey, @cNumber, oNumber, @cOperacion, @nValue ) }

   ACTIVATE DIALOG oDialogo CENTERED ON INIT oNumber:SelectAll()

   if oDialogo:nResult == IDOK
      if !Empty( oGet )
         oGet:cText( Val( cNumber ) )
      end if
   else 
      cNumber             := ""      
   end if

RETURN ( Val( cNumber ) )

//--------------------------------------------------------------------------//

FUNCTION KeyCal( cKey, cNumber, oNumber, cOperacion, nValue )

   IF VALTYPE(cKey) = "N"
      IF cKey =  96
         cKey = "0"
      ELSEIF cKey =  97
         cKey = "1"
      ELSEIF cKey =  98
         cKey = "2"
      ELSEIF cKey =  99
         cKey = "3"
      ELSEIF cKey = 100
         cKey = "4"
      ELSEIF cKey = 101
         cKey = "5"
      ELSEIF cKey = 102
         cKey = "6"
      ELSEIF cKey = 103
         cKey = "7"
      ELSEIF cKey = 104
         cKey = "8"
      ELSEIF cKey = 105
         cKey = "9"
      ELSEIF cKey = 106 .OR. cKey = 186
         cKey = "*"
      ELSEIF cKey = 107 .OR. cKey = 187
         cKey = "+"
      ELSEIF cKey = 109 .OR. cKey = 189
         cKey = "-"
      ELSEIF cKey = 110 .OR. cKey = 190
         cKey = "."
      ELSEIF cKey = 111 .OR. cKey = 191
         cKey = "/"
      ELSEIF cKey = 226
         cKey = "<"
      ELSE
         cKey = UPPER(CHR(cKey))
      ENDIF
   ENDIF

   DO CASE
      CASE AT(cKey,"+-*/=") > 0
           IF nValue <> 0
              IF VAL(cNumber) = 0 .AND. cOperacion = "/"
                 MsgStop(OemToAnsi("Divisi¢n por cero ..."))
                 cNumber = "0"
              ELSE
                 cNumber = LTRIM(STR(&(STR(nValue)+cOperacion+cNumber)))
              ENDIF
              nValue = 0
           ENDIF
           DO CASE
              CASE cKey = "+"
                 cOperacion = "+"
              CASE cKey = "-"
                 cOperacion = "-"
              CASE cKey = "*"
                 cOperacion = "*"
              CASE cKey = "/"
                 cOperacion = "/"
              CASE cKey = "="
                 cOperacion = "="
                 nValue = 0
           ENDCASE
           oNumber:Refresh()
           RETURN nil
      CASE cKey = "C"
           cNumber = "0"
           nValue  = 0
           cOperacion = "="
      CASE cKey = "<"
           cNumber = LEFT(cNumber,LEN(cNumber)-IF(RIGHT(cNumber,1)=".",2,1))
           IF EMPTY(cNumber)
              cNumber = "0"
           ENDIF
      CASE cKey = "S"
           IF AT("-",cNumber) > 0
              cNumber = STRTRAN(cNumber,"-","")
           ELSE
              cNumber = "-" + cNumber
           ENDIF
      CASE AT(cKey,"-01234567890.") > 0
           IF cOperacion <> "=" .AND. nValue = 0 .AND. !EMPTY(cOperacion)
              nValue = VAL(cNumber)
              cNumber = "0"
           ELSEIF cOperacion == "="
              nValue = 0
              cNumber = "0"
              cOperacion = ""
           ENDIF
           IF LEFT(cNumber,1) = "0"
              cNumber = SUBS(cNumber,2)
           ENDIF
           IF !( cKey = "." .AND. AT(".",cNumber) > 0 )
              cNumber += cKey
           ENDIF
      OTHERWISE
           //? cKey
           //Informacion(cKey)
   ENDCASE

   oNumber:Refresh()

RETURN nil

//--------------------------------------------------------------------------//

FUNCTION MsgDebug( cText, cTitle )

RETURN ( msgStop( cText, cTitle ) )

//--------------------------------------------------------------------------//

CLASS TVirtualMoney

   DATA oGetActive
   DATA oGet500Euros
   DATA oGet200Euros
   DATA oGet100Euros
   DATA oGet50Euros
   DATA oGet20Euros
   DATA oGet10Euros
   DATA oGet5Euros
   DATA oGet2Euros
   DATA oGet1Euro
   DATA oGet050Euros
   DATA oGet020Euros
   DATA oGet010Euros
   DATA oGet005Euros
   DATA oGet002Euros
   DATA oGet001Euro

   DATA nGet500Euros    INIT 0
   DATA nGet200Euros    INIT 0
   DATA nGet100Euros    INIT 0
   DATA nGet50Euros     INIT 0
   DATA nGet20Euros     INIT 0
   DATA nGet10Euros     INIT 0
   DATA nGet5Euros      INIT 0
   DATA nGet2Euros      INIT 0
   DATA nGet1Euro       INIT 0
   DATA nGet050Euros    INIT 0
   DATA nGet020Euros    INIT 0
   DATA nGet010Euros    INIT 0
   DATA nGet005Euros    INIT 0
   DATA nGet002Euros    INIT 0
   DATA nGet001Euro     INIT 0

   DATA oSayTotal
   DATA nSayTotal       INIT 0

   DATA cStream         INIT ""

   Method New()               INLINE   ( Self )
   Method Dialog()

   Method ClickMoneda( oGet ) INLINE   ( ::PutFocus( oGet ), oGet:cText( oGet:VarGet() + 1 ), ::Total() )
   Method PressKey( cNumero )
   Method PutFocus( oGet )    INLINE   ( ::oGetActive := oGet )

   Method GetStream()
   Method SetStream( cStream )

   Method Total()
   Method Clean()

END CLASS

//----------------------------------------------------------------------------//

Method Dialog( oGet ) CLASS TVirtualMoney

   local oDlg
   local oFnt        := TFont():New( "Arial", 12, 32, .f., .t. )
   local cResource   := "CashBig"

   if GetSysMetrics( 1 ) == 560

      DEFINE DIALOG oDlg RESOURCE "CashBig_1024x576"

   else

      DEFINE DIALOG oDlg RESOURCE cResource

   end if

      /*
      Monedas y billetes__________________________________________________________________
		*/

      REDEFINE BUTTONBMP ;
         ID       800 ;
         OF       oDlg ;
         BITMAP   "Img500Euros" ;
         ACTION   ( ::ClickMoneda( ::oGet500Euros ) )

      REDEFINE GET ::oGet500Euros ;
         VAR      ::nGet500Euros ;
         FONT     oFnt ;
         PICTURE  "999" ;
         ID       100 ;
         OF       oDlg

      ::oGet500Euros:bValid      := {|| ::PutFocus( ::oGet500Euros ), ::Total() }
      ::oGet500Euros:bLostFocus  := {|| ::PutFocus( ::oGet500Euros ) }

      REDEFINE BUTTONBMP ;
         ID       801 ;
         OF       oDlg ;
         BITMAP   "Img200Euros" ;
         ACTION   ( ::ClickMoneda( ::oGet200Euros ) )

      REDEFINE GET ::oGet200Euros ;
         VAR      ::nGet200Euros ;
         FONT     oFnt ;
         PICTURE  "999" ;
         ID       101 ;
         OF       oDlg

      ::oGet200Euros:bValid      := {|| ::PutFocus( ::oGet200Euros ), ::Total() }
      ::oGet200Euros:bLostFocus  := {|| ::PutFocus( ::oGet200Euros ) }

      REDEFINE BUTTONBMP ;
         BITMAP   "Img100Euros" ;
         ACTION   ( ::ClickMoneda( ::oGet100Euros ) ) ;
         ID       802;
         OF       oDlg

      REDEFINE GET ::oGet100Euros ;
         VAR      ::nGet100Euros ;
         FONT     oFnt ;
         PICTURE  "999" ;
         ID       102 ;
         OF       oDlg

      ::oGet100Euros:bValid      := {|| ::PutFocus( ::oGet100Euros ), ::Total() }
      ::oGet100Euros:bLostFocus  := {|| ::PutFocus( ::oGet100Euros ) }

      REDEFINE BUTTONBMP ;
         BITMAP   "Img50Euros" ;
         ACTION   ( ::ClickMoneda( ::oGet50Euros ) ) ;
         ID       803;
         OF       oDlg

      REDEFINE GET ::oGet50Euros ;
         VAR      ::nGet50Euros ;
         FONT     oFnt ;
         PICTURE  "999" ;
         ID       103 ;
         OF       oDlg

      ::oGet50Euros:bValid       := {|| ::PutFocus( ::oGet50Euros ), ::Total() }
      ::oGet50Euros:bLostFocus   := {|| ::PutFocus( ::oGet50Euros ) }

      REDEFINE BUTTONBMP ;
         BITMAP   "Img20Euros" ;
         ACTION   ( ::ClickMoneda( ::oGet20Euros ) ) ;
         ID       804;
         OF       oDlg

      REDEFINE GET ::oGet20Euros ;
         VAR      ::nGet20Euros ;
         FONT     oFnt ;
         PICTURE  "999" ;
         ID       104 ;
         OF       oDlg

      ::oGet20Euros:bValid       := {|| ::PutFocus( ::oGet20Euros ), ::Total() }
      ::oGet20Euros:bLostFocus   := {|| ::PutFocus( ::oGet20Euros ) }

      REDEFINE BUTTONBMP ;
         BITMAP   "Img10Euros" ;
         ACTION   ( ::ClickMoneda( ::oGet10Euros ) ) ;
         ID       805;
         OF       oDlg

      REDEFINE GET ::oGet10Euros ;
         VAR      ::nGet10Euros ;
         FONT     oFnt ;
         PICTURE  "999" ;
         ID       105 ;
         OF       oDlg

      ::oGet10Euros:bValid       := {|| ::PutFocus( ::oGet10Euros ), ::Total() }
      ::oGet10Euros:bLostFocus   := {|| ::PutFocus( ::oGet10Euros ) }

      REDEFINE BUTTONBMP ;
         BITMAP   "Img5Euros" ;
         ACTION   ( ::ClickMoneda( ::oGet5Euros ) ) ;
         ID       806;
         OF       oDlg

      REDEFINE GET ::oGet5Euros ;
         VAR      ::nGet5Euros ;
         FONT     oFnt ;
         PICTURE  "999" ;
         ID       106 ;
         OF       oDlg

      ::oGet5Euros:bValid        := {|| ::PutFocus( ::oGet5Euros ), ::Total() }
      ::oGet5Euros:bLostFocus    := {|| ::PutFocus( ::oGet5Euros ) }

      REDEFINE BUTTONBMP ;
         BITMAP   "Img2Euros" ;
         ACTION   ( ::ClickMoneda( ::oGet2Euros ) ) ;
         ID       807;
         OF       oDlg

      REDEFINE GET ::oGet2Euros ;
         VAR      ::nGet2Euros ;
         FONT     oFnt ;
         PICTURE  "999" ;
         ID       107 ;
         OF       oDlg

      ::oGet2Euros:bValid        := {|| ::PutFocus( ::oGet2Euros ), ::Total() }
      ::oGet2Euros:bLostFocus    := {|| ::PutFocus( ::oGet2Euros ) }

      REDEFINE BUTTONBMP ;
         BITMAP   "Img1Euro" ;
         ACTION   ( ::ClickMoneda( ::oGet1Euro ) ) ;
         ID       808;
         OF       oDlg

      REDEFINE GET ::oGet1Euro ;
         VAR      ::nGet1Euro ;
         FONT     oFnt ;
         PICTURE  "999" ;
         ID       108 ;
         OF       oDlg

      ::oGet1Euro:bValid         := {|| ::PutFocus( ::oGet1Euro ), ::Total() }
      ::oGet1Euro:bLostFocus     := {|| ::PutFocus( ::oGet1Euro ) }

      REDEFINE BUTTONBMP ;
         BITMAP   "Img50Cent" ;
         ACTION   ( ::ClickMoneda( ::oGet050Euros ) ) ;
         ID       809;
         OF       oDlg

      REDEFINE GET ::oGet050Euros ;
         VAR      ::nGet050Euros ;
         FONT     oFnt ;
         PICTURE  "999" ;
         ID       109 ;
         OF       oDlg

      ::oGet050Euros:bValid      := {|| ::PutFocus( ::oGet050Euros ), ::Total() }
      ::oGet050Euros:bLostFocus  := {|| ::PutFocus( ::oGet050Euros ) }

      REDEFINE BUTTONBMP ;
         BITMAP   "Img20Cent" ;
         ACTION   ( ::ClickMoneda( ::oGet020Euros ) ) ;
         ID       810;
         OF       oDlg

      REDEFINE GET ::oGet020Euros ;
         VAR      ::nGet020Euros ;
         FONT     oFnt ;
         PICTURE  "999" ;
         ID       110 ;
         OF       oDlg

      ::oGet020Euros:bValid      := {|| ::PutFocus( ::oGet020Euros ), ::Total() }
      ::oGet020Euros:bLostFocus  := {|| ::PutFocus( ::oGet020Euros ) }

      REDEFINE BUTTONBMP ;
         BITMAP   "Img10Cent" ;
         ACTION   ( ::ClickMoneda( ::oGet010Euros ) ) ;
         ID       811;
         OF       oDlg

      REDEFINE GET ::oGet010Euros ;
         VAR      ::nGet010Euros ;
         FONT     oFnt ;
         PICTURE  "999" ;
         ID       111 ;
         OF       oDlg

      ::oGet010Euros:bValid      := {|| ::PutFocus( ::oGet010Euros ), ::Total() }
      ::oGet010Euros:bLostFocus  := {|| ::PutFocus( ::oGet010Euros )  }

      REDEFINE BUTTONBMP ;
         BITMAP   "Img5Cent" ;
         ACTION   ( ::ClickMoneda( ::oGet005Euros ) ) ;
         ID       812;
         OF       oDlg

      REDEFINE GET ::oGet005Euros ;
         VAR      ::nGet005Euros ;
         FONT     oFnt ;
         PICTURE  "999" ;
         ID       112 ;
         OF       oDlg

      ::oGet005Euros:bValid      := {|| ::PutFocus( ::oGet005Euros ), ::Total() }
      ::oGet005Euros:bLostFocus  := {|| ::PutFocus( ::oGet005Euros ) }

      REDEFINE BUTTONBMP ;
         BITMAP   "Img2Cent" ;
         ACTION   ( ::ClickMoneda( ::oGet002Euros ) ) ;
         ID       813;
         OF       oDlg

      REDEFINE GET ::oGet002Euros ;
         VAR      ::nGet002Euros ;
         FONT     oFnt ;
         PICTURE  "999" ;
         ID       113 ;
         OF       oDlg

      ::oGet002Euros:bValid      := {|| ::PutFocus( ::oGet002Euros ), ::Total() }
      ::oGet002Euros:bLostFocus  := {|| ::PutFocus( ::oGet002Euros ) }

      REDEFINE BUTTONBMP ;
         BITMAP   "Img1Cent" ;
         ACTION   ( ::ClickMoneda( ::oGet001Euro ) ) ;
         ID       814;
         OF       oDlg

      REDEFINE GET ::oGet001Euro ;
         VAR      ::nGet001Euro ;
         FONT     oFnt ;
         PICTURE  "999" ;
         ID       114 ;
         OF       oDlg

      ::oGet001Euro:bValid       := {|| ::PutFocus( ::oGet001Euro ), ::Total() }
      ::oGet001Euro:bLostFocus   := {|| ::PutFocus( ::oGet001Euro ) }

      REDEFINE BUTTONBMP ;
         BITMAP   "Img0Euros" ;
         ACTION   ( ::Clean() ) ;
         ID       815;
         OF       oDlg

      /*
      Importe total------------------------------------------------------------
      */

      REDEFINE SAY ::oSayTotal ;
         VAR      ::nSayTotal ;
         PICTURE  "@E 999,999.99" ;
         FONT     oFnt ;
         ID       300 ;
         OF       oDlg

      /*
      Teclado numerico---------------------------------------------------------
      */


      REDEFINE BUTTON ;
         ID       202 ;
         OF       oDlg ;
         ACTION   ( ::oGetActive:cText( 0 ), ::Total() )

      REDEFINE BUTTON ;
         ID       200 ;
         OF       oDlg ;
         ACTION   ( ::PressKey( "0" ) )

      REDEFINE BUTTON ;
         ID       203 ;
         OF       oDlg ;
         ACTION   ( ::PressKey( "1" ) )

      REDEFINE BUTTON ;
         ID       204 ;
         OF       oDlg ;
         ACTION   ( ::PressKey( "2" ) )

      REDEFINE BUTTON ;
         ID       205 ;
         OF       oDlg ;
         ACTION   ( ::PressKey( "3" ) )

      REDEFINE BUTTON ;
         ID       206 ;
         OF       oDlg ;
         ACTION   ( ::PressKey( "4" ) )

      REDEFINE BUTTON ;
         ID       207 ;
         OF       oDlg ;
         ACTION   ( ::PressKey( "5" ) )

      REDEFINE BUTTON ;
         ID       208 ;
         OF       oDlg ;
         ACTION   ( ::PressKey( "6" ) )

      REDEFINE BUTTON ;
         ID       209 ;
         OF       oDlg ;
         ACTION   ( ::PressKey( "7" ) )

      REDEFINE BUTTON ;
         ID       210 ;
         OF       oDlg ;
         ACTION   ( ::PressKey( "8" ) )

      REDEFINE BUTTON ;
         ID       211 ;
         OF       oDlg ;
         ACTION   ( ::PressKey( "9" ) )

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:End( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:End() )

   ACTIVATE DIALOG oDlg CENTERED

   oFnt:End()

   if oDlg:nResult == IDOK

      if !Empty( oGet )
         oGet:cText( ::nSayTotal )
      end if

   end if

RETURN ( Self )

//--------------------------------------------------------------------------//

Method Total() CLASS TVirtualMoney

   ::nSayTotal    := ::nGet500Euros * 500
   ::nSayTotal    += ::nGet200Euros * 200
   ::nSayTotal    += ::nGet100Euros * 100
   ::nSayTotal    += ::nGet50Euros  * 50
   ::nSayTotal    += ::nGet20Euros  * 20
   ::nSayTotal    += ::nGet10Euros  * 10
   ::nSayTotal    += ::nGet5Euros   * 5
   ::nSayTotal    += ::nGet2Euros   * 2
   ::nSayTotal    += ::nGet1Euro
   ::nSayTotal    += ::nGet050Euros * 0.5
   ::nSayTotal    += ::nGet020Euros * 0.2
   ::nSayTotal    += ::nGet010Euros * 0.1
   ::nSayTotal    += ::nGet005Euros * 0.05
   ::nSayTotal    += ::nGet002Euros * 0.02
   ::nSayTotal    += ::nGet001Euro  * 0.01

   if !Empty( ::oSayTotal )
      ::oSayTotal:Refresh()
   end if

RETURN ( .t. )

//--------------------------------------------------------------------------//

Method Clean() CLASS TVirtualMoney

   ::oGet500Euros:cText( 0 )
   ::oGet200Euros:cText( 0 )
   ::oGet100Euros:cText( 0 )
   ::oGet50Euros:cText( 0 )
   ::oGet20Euros:cText( 0 )
   ::oGet10Euros:cText( 0 )
   ::oGet5Euros:cText( 0 )
   ::oGet2Euros:cText( 0 )
   ::oGet1Euro:cText( 0 )
   ::oGet050Euros:cText( 0 )
   ::oGet020Euros:cText( 0 )
   ::oGet010Euros:cText( 0 )
   ::oGet005Euros:cText( 0 )
   ::oGet002Euros:cText( 0 )
   ::oGet001Euro:cText( 0 )

   ::Total()

RETURN ( .t. )

//--------------------------------------------------------------------------//

Method PressKey( cKey ) CLASS TVirtualMoney

   local cNumber

   if !Empty( ::oGetActive )

      cNumber        := Str( ::oGetActive:VarGet() )

      if at( cKey, "01234567890." ) > 0

         if Left( cNumber, 1 ) = "0"
            cNumber  := Substr( cNumber, 2 )
         end if

         if !( cKey == "." .and. at(".",cNumber) > 0 )
            cNumber  += cKey
         endif

      end if

      ::oGetActive:cText( Val( cNumber ) )

      ::Total()

   end if

RETURN ( .t. )

//--------------------------------------------------------------------------//

Method GetStream() CLASS TVirtualMoney

   ::cStream   := StrZero( ::nGet500Euros, 3 ) + ";"       //"500,"   +
   ::cStream   += StrZero( ::nGet200Euros, 3 ) + ";"       //"200,"   +
   ::cStream   += StrZero( ::nGet100Euros, 3 ) + ";"       //"100,"   +
   ::cStream   += StrZero( ::nGet50Euros , 3 ) + ";"       //"50,"    +
   ::cStream   += StrZero( ::nGet20Euros , 3 ) + ";"       //"20,"    +
   ::cStream   += StrZero( ::nGet10Euros , 3 ) + ";"       //"10,"    +
   ::cStream   += StrZero( ::nGet5Euros  , 3 ) + ";"       //"5,"     +
   ::cStream   += StrZero( ::nGet2Euros  , 3 ) + ";"       //"2,"     +
   ::cStream   += StrZero( ::nGet1Euro   , 3 ) + ";"       //"1,"     +
   ::cStream   += StrZero( ::nGet050Euros, 3 ) + ";"       //"0.50,"  +
   ::cStream   += StrZero( ::nGet020Euros, 3 ) + ";"       //"0.20,"  +
   ::cStream   += StrZero( ::nGet010Euros, 3 ) + ";"       //"0.10,"  +
   ::cStream   += StrZero( ::nGet005Euros, 3 ) + ";"       //"0.05,"  +
   ::cStream   += StrZero( ::nGet002Euros, 3 ) + ";"       //"0.02,"  +
   ::cStream   += StrZero( ::nGet001Euro , 3 ) + ";"       //"0.01,"  +

RETURN ( ::cStream )

//--------------------------------------------------------------------------//

Method SetStream( cStream ) CLASS TVirtualMoney

   local aStream  := hb_aTokens( cStream, ";" )

   if len( aStream ) >= 15

      ::nGet500Euros    := Val( aStream[ 1 ] )
      ::nGet200Euros    := Val( aStream[ 2 ] )
      ::nGet100Euros    := Val( aStream[ 3 ] )
      ::nGet50Euros     := Val( aStream[ 4 ] )
      ::nGet20Euros     := Val( aStream[ 5 ] )
      ::nGet10Euros     := Val( aStream[ 6 ] )
      ::nGet5Euros      := Val( aStream[ 7 ] )
      ::nGet2Euros      := Val( aStream[ 8 ] )
      ::nGet1Euro       := Val( aStream[ 9 ] )
      ::nGet050Euros    := Val( aStream[ 10] )
      ::nGet020Euros    := Val( aStream[ 11] )
      ::nGet010Euros    := Val( aStream[ 12] )
      ::nGet005Euros    := Val( aStream[ 13] )
      ::nGet002Euros    := Val( aStream[ 14] )
      ::nGet001Euro     := Val( aStream[ 15] )

      if( !Empty( ::oGet500Euros ), ::oGet500Euros:Refresh(), )
      if( !Empty( ::oGet200Euros ), ::oGet200Euros:Refresh(), )
      if( !Empty( ::oGet100Euros ), ::oGet100Euros:Refresh(), )
      if( !Empty( ::oGet50Euros ),  ::oGet50Euros:Refresh() , )
      if( !Empty( ::oGet20Euros ),  ::oGet20Euros:Refresh() , )
      if( !Empty( ::oGet10Euros ),  ::oGet10Euros:Refresh() , )
      if( !Empty( ::oGet5Euros ),   ::oGet5Euros:Refresh()  , )
      if( !Empty( ::oGet2Euros ),   ::oGet2Euros:Refresh()  , )
      if( !Empty( ::oGet1Euro ),    ::oGet1Euro:Refresh()   , )
      if( !Empty( ::oGet050Euros ), ::oGet050Euros:Refresh(), )
      if( !Empty( ::oGet020Euros ), ::oGet020Euros:Refresh(), )
      if( !Empty( ::oGet010Euros ), ::oGet010Euros:Refresh(), )
      if( !Empty( ::oGet005Euros ), ::oGet005Euros:Refresh(), )
      if( !Empty( ::oGet002Euros ), ::oGet002Euros:Refresh(), )
      if( !Empty( ::oGet001Euro ),  ::oGet001Euro:Refresh(),  )

   end if

   ::Total()

RETURN ( .t. )

//--------------------------------------------------------------------------//

FUNCTION nVirtualNumKey( cBitmap, cTitle, nVar )

   local oGet
   local oDlg
   local oBmp
   local oBtn
   local cVar

   DEFAULT nVar         := 0

   DEFAULT cTitle       := "Teclado virtual"

   cVar                 := Str( nVar, 4 )

   DEFINE DIALOG oDlg NAME "NumKey" TITLE cTitle

      REDEFINE BITMAP oBmp ID 500 RESOURCE ( cBitmap ) TRANSPARENT OF oDlg

      REDEFINE GET oGet VAR cVar PICTURE "9999" ID 100 OF oDlg

      REDEFINE BUTTON ID 101 OF oDlg ACTION ( sayNumber( oGet, 1 ) )

      REDEFINE BUTTON ID 102 OF oDlg ACTION ( sayNumber( oGet, 2 ) )

      REDEFINE BUTTON ID 103 OF oDlg ACTION ( sayNumber( oGet, 3 ) )

      REDEFINE BUTTON ID 104 OF oDlg ACTION ( sayNumber( oGet, 4 ) )

      REDEFINE BUTTON ID 105 OF oDlg ACTION ( sayNumber( oGet, 5 ) )

      REDEFINE BUTTON ID 106 OF oDlg ACTION ( sayNumber( oGet, 6 ) )

      REDEFINE BUTTON ID 107 OF oDlg ACTION ( sayNumber( oGet, 7 ) )

      REDEFINE BUTTON ID 108 OF oDlg ACTION ( sayNumber( oGet, 8 ) )

      REDEFINE BUTTON ID 109 OF oDlg ACTION ( sayNumber( oGet, 9 ) )

      REDEFINE BUTTON ID 110 OF oDlg ACTION ( sayNumber( oGet, 0 ) )

      REDEFINE BUTTON ID 150 OF oDlg ACTION ( oGet:SetFocus(.t.), oGet:cText( "0" ) )

      REDEFINE BUTTONBMP oBtn BITMAP "gc_check_32" ID 130 OF oDlg ACTION ( oDlg:End( IDOK ) )

      oDlg:AddFastKey( VK_F5, {|| oDlg:End( IDOK ) } )

      oDlg:bStart       := {|| oGet:SetFocus( .t. ), oGet:selectAll() }

   ACTIVATE DIALOG oDlg CENTERED

   if ( oDlg:nResult == IDOK )
      cVar   := val( cVar )   
   else 
      cVar   := 0
   endif 

   if !Empty( oBmp )
      oBmp:End()
   end if

   if !empty( oBtn ) 
      oBtn:end()
   end if 

RETURN ( cVar )

//--------------------------------------------------------------------------//

Static FUNCTION sayNumber( oGet, uNumber )
  
   local cText   := alltrim( oGet:cText() )

   if val( cText ) == 0
      cText      := ""
   end if 
 
   oGet:cText( padr( alltrim( cText ) + cValToChar( uNumber ), 100, ' ' ) )

   oGet:setFocus()

RETURN ( nil )

//--------------------------------------------------------------------------//
//Funciones para el programa y pda
//--------------------------------------------------------------------------//

FUNCTION RetPic( nUnd, nDec, lEsp )

   local n
	local cRetPic	:= ""

   if Empty( nUnd )
      nUnd        := 1
   end if

	DEFAULT nDec	:= 0
	DEFAULT lEsp	:= .t.

	/*
	Parte entera
   */

   for n := 1 to nUnd
      cRetPic     := "9" + cRetPic
      if n % 3 == 0
         cRetPic  := "," + cRetPic
      end if
   next

	/*
	Comprobamos que el primer digito no sea una coma
	*/

	IF Left( cRetPic, 1 ) == ','
		cRetPic 		:= Substr( cRetPic, 2 )
	END IF

	/*
	Spanish
	*/

	IF lEsp
		cRetPic		:= "@E " + cRetPic
	ELSE
		cRetPic		:= "@R " + cRetPic
	END IF

	/*
	Parte decimal
	*/

	IF nDec > 0
		cRetPic		+= "." + Replicate( "9", nDec )
	END IF

RETURN ( cRetPic )

//--------------------------------------------------------------------------//

FUNCTION CheckCif( oGet )

   local cCif         := oGet:varGet()
   local cNumero      := ""
   local cLetra       := ""

   if isDigit( cCif )

      do case
         case Len( RTrim( cCif ) ) < __LENCIF__

            cCif      := RJust( RTrim( cCif ) + Cif( cCif ) , '0', __LENCIF__ )
            oGet:cText( cCif )

         case Len( RTrim( cCif ) ) == __LENCIF__

            cNumero   := Left( cCif, __LENCIF__ - 1 )
            cLetra    := Right( cCif, 1 )

            if cLetra != Cif( cNumero )

               cCif   := cNumero + Cif( cNumero )
               oGet:cText( cCif )

            end if

      end case

   end if

RETURN .T.

//---------------------------------------------------------------------------//

/*
Calcula letras del CIF
*/

FUNCTION Cif( cCif )

	LOCAL acLetras := {'R','W','A','G','M','Y','F','P','D','X','B','N','J','Z','S','Q','V','H','L','C','K','E','T'}
	LOCAL nPosition:= Val( cCif ) % 23

	/*
	Excepciones
	*/

	IF nPosition == 0
		nPosition = 23
	END IF

RETURN ( acLetras[ nPosition ] )

//--------------------------------------------------------------------------//

FUNCTION Num2Text( nNum, lMas, nDec )

   local cTxt
   local cDec

   DEFAULT lMas      := .t.
   DEFAULT nDec      := 2

   cTxt              := Letras( int( nNum ), lMas )

   /*
   Si la cantidad tiene unidades
   */

   if int( nNum ) != nNum

      cTxt  += " con "
      cDec  := Str( nNum - int( nNum ) )
      cDec  := SubStr( cDec, At( ".", cDec ) + 1, nDec )

      /*
      Ceros por la derecha
      */

      while len( cDec ) > 0 .and. SubStr( cDec, 1, 1 ) == "0"
         //cTxt  += "Cero "
         cDec  := SubStr( cDec, 2 )
      end while

      if len( cDec ) > 0
         cTxt  += Rtrim( Letras( Val( cDec ), lMas ) ) + Space( 1 ) + "Centimos"
      end if

   end if

RETURN ( Upper( cTxt ) )

//---------------------------------------------------------------------------//

FUNCTION Letras( chk_num, lMas )

	local chk_list
	local chk_it
	local chk_out

   DEFAULT lMas      := .f.

	DO CASE

   CASE chk_num < 0
      RETURN "Negativo " + Num2Text( chk_num * -1, lMas )

	CASE chk_num < 11
		chk_list = { "Cero", "Uno", "Dos", "Tres", "Cuatro", "Cinco", "Seis", "Siete", "Ocho", "Nueve", "Diez" }
      RETURN chk_list[ chk_num + 1 ]

	CASE chk_num < 20
		chk_list = { "Once", "Doce", "Trece", "Catorce", "Quince", "Dieciseis", "Diecisiete", "Dieciocho", "Diecinueve" }
      RETURN chk_list[ chk_num - 10 ] // + " " + Num2Text( chk_num - 10, lMas )

	CASE chk_num = 20
      RETURN "Veinte" // + Num2Text( chk_num - 20, lMas )

	CASE chk_num < 30
      RETURN "Venti" + If( chk_num > 20, Num2Text( chk_num - 20, lMas ), " ")

	CASE chk_num < 40
      RETURN "Treinta" + If( chk_num > 30, " y " + Num2Text( chk_num - 30, lMas ), " ")

	CASE chk_num < 50
      RETURN "Cuarenta" + If( chk_num > 40, " y " + Num2Text( chk_num - 40, lMas ), " ")

	CASE chk_num < 60
      RETURN "Cincuenta" + If( chk_num > 50, " y " + Num2Text( chk_num - 50, lMas ), " ")

	CASE chk_num < 70
      RETURN "Sesenta" + If( chk_num > 60, " y " + Num2Text( chk_num - 60, lMas ), " ")

	CASE chk_num < 80
      RETURN "Setenta" + If( chk_num > 70, " y " + Num2Text( chk_num - 70, lMas ), " ")

	CASE chk_num < 90
      RETURN "Ochenta" + If( chk_num > 80, " y " + Num2Text( chk_num - 80, lMas ), " ")

	CASE chk_num < 100
      RETURN "Noventa" + If( chk_num > 90, " y " + Num2Text( chk_num - 90, lMas ), " ")

	CASE chk_num < 1000
		chk_it  = Int( chk_num / 100 )
		chk_out = chk_num - ( chk_it * 100 )

		DO CASE
		CASE chk_num = 100
			RETURN "Cien"

		CASE chk_num < 200
			chk_it = "Ciento"

		CASE chk_num < 300
         chk_it = if( lMas, "Doscientos", "Doscientas" )

		CASE chk_num < 400
         chk_it = if( lMas, "Trescientos", "Trescientas" )

		CASE chk_num < 500
         chk_it = if( lMas, "Cuatrocientos", "Cuatrocientas" )

		CASE chk_num < 600
         chk_it = if( lMas, "Quinientos", "Quinientas" )

		CASE chk_num < 700
         chk_it = if( lMas, "Seiscientos", "Seiscientas" )

		CASE chk_num < 800
         chk_it = if( lMas, "Setecientos", "Setecientas" )

		CASE chk_num < 900
         chk_it = if( lMas, "Ochocientos" , "Ochocientas" )

		CASE chk_num < 1000
         chk_it = if( lMas, "Novecientos", "Novecientas" )

		END CASE

      RETURN chk_it + If( chk_out > 0, " " + Num2Text( chk_out, lMas ), " ")

	CASE chk_num < 1000000
		chk_it  = Int( chk_num / 1000 )
		chk_out = chk_num - ( chk_it * 1000 )
      RETURN If( chk_it != 1, Num2Text( chk_it, lMas ), "" ) + "Mil" + If( chk_out > 0, " " + Num2Text( chk_out, lMas ), " ")

	CASE chk_num < 1000000000
		chk_it  = Int( chk_num / 1000000 )
		chk_out = chk_num - ( chk_it * 1000000 )
      RETURN Num2Text( chk_it, lMas ) + "Millón" + If( chk_out > 0, ", " + Num2Text( chk_out, lMas )," ")

	CASE chk_num < 1000000000000
		chk_it  = INT( chk_num / 1000000000 )
		chk_out = chk_num - ( chk_it * 1000000000 )
      RETURN Num2Text( chk_it, lMas ) + "Billón" + If( chk_out > 0, ", " + Num2Text( chk_out, lMas )," ")

	ENDCASE

RETURN "Número no convertido"

//--------------------------------------------------------------------------//

FUNCTION CheckRut( oGet )

   local cNumero     := ""
   local cLetra      := ""
   local cRut        := Rtrim( oGet:varGet() )

   if isDigit( cRut )

      do case
         case Len( cRut ) < __LENCIF__

            cRut     := Rtrim( RJust( cRut, '0', __LENCIF__ ) )
            cRut     += Rut( cRut )

            oGet:cText( cRut )

         case Len( cRut ) == __LENCIF__

            cNumero  := Left( cRut, __LENCIF__ - 1 )
            cLetra   := Right( cRut, 1 )

            if cLetra != Rut( cNumero )
               cRut  := cNumero + Rut( cNumero )
               oGet:cText( cRut )
            end if

      end case

   end if

RETURN .t.

//---------------------------------------------------------------------------//

FUNCTION Rut( cRut )

   local nRut

   nRut     := (  Val( SubStr( cRut, 1, 1 ) ) * 4 +;
                  Val( SubStr( cRut, 2, 1 ) ) * 3 +;
                  Val( SubStr( cRut, 3, 1 ) ) * 2 +;
                  Val( SubStr( cRut, 4, 1 ) ) * 7 +;
                  Val( SubStr( cRut, 5, 1 ) ) * 6 +;
                  Val( SubStr( cRut, 6, 1 ) ) * 5 +;
                  Val( SubStr( cRut, 7, 1 ) ) * 4 +;
                  Val( SubStr( cRut, 8, 1 ) ) * 3 +;
                  Val( SubStr( cRut, 9, 1 ) ) * 2 ) % 11
   nRut     := 11 - nRut

   if nRut < 10
      nRut  := Str( nRut, 1 )
   elseif nRut == 10
      nRut  := "K"
   else
      nRut  := "0"
   end if

RETURN ( nRut )

//--------------------------------------------------------------------------//

FUNCTION VirtualKey( lPassword, uGetKey, cTitle )

   local oGet
   local oDlg
   local cVar
   local oFnt        := TFont():New( "Arial", 12, 32, .f., .t. )

   DEFAULT lPassword := .f.
   DEFAULT cTitle    := "Teclado virtual"

   do case
      case Valtype( uGetKey ) == "O"
         cVar        := uGetKey:VarGet()
      case Valtype( uGetKey ) == "C"
         cVar        := uGetKey
      otherwise
         cVar        := Space( 200 )
   end case

   cVar              := Padr( cVar, 200 )

   if lPassword
      DEFINE DIALOG oDlg NAME "KEYBPASSWORD" TITLE cTitle // FONT oFnt
   else
      DEFINE DIALOG oDlg NAME "KEYB"         TITLE cTitle // FONT oFnt
   end if

      //REDEFINE GET oGet VAR cVar FONT oFnt ID 100 OF oDlg

      oGet           := TGet():ReDefine( 100, { | u | if( pcount() == 0, cVar, cVar:= u ) }, oDlg,,,,,, oFnt,,, .f.,,, .f., .f. ) 

      REDEFINE BUTTON ID 101 OF oDlg ACTION ( keybPressed( oGet, "1" ) )

      REDEFINE BUTTON ID 102 OF oDlg ACTION ( keybPressed( oGet, "2" ) )

      REDEFINE BUTTON ID 103 OF oDlg ACTION ( keybPressed( oGet, "3" ) ) 

      REDEFINE BUTTON ID 104 OF oDlg ACTION ( keybPressed( oGet, "4" ) )

      REDEFINE BUTTON ID 105 OF oDlg ACTION ( keybPressed( oGet, "5" ) ) 

      REDEFINE BUTTON ID 106 OF oDlg ACTION ( keybPressed( oGet, "6" ) ) 

      REDEFINE BUTTON ID 107 OF oDlg ACTION ( keybPressed( oGet, "7" ) ) 

      REDEFINE BUTTON ID 108 OF oDlg ACTION ( keybPressed( oGet, "8" ) ) 

      REDEFINE BUTTON ID 109 OF oDlg ACTION ( keybPressed( oGet, "9" ) )

      REDEFINE BUTTON ID 110 OF oDlg ACTION ( keybPressed( oGet, "0" ) )

      REDEFINE BUTTON ID 111 OF oDlg ACTION ( keybPressed( oGet, "Q" ) )

      REDEFINE BUTTON ID 112 OF oDlg ACTION ( keybPressed( oGet, "W" ) )

      REDEFINE BUTTON ID 113 OF oDlg ACTION ( keybPressed( oGet, "E" ) )

      REDEFINE BUTTON ID 114 OF oDlg ACTION ( keybPressed( oGet, "R" ) )

      REDEFINE BUTTON ID 115 OF oDlg ACTION ( keybPressed( oGet, "T" ) )

      REDEFINE BUTTON ID 116 OF oDlg ACTION ( keybPressed( oGet, "Y" ) )

      REDEFINE BUTTON ID 117 OF oDlg ACTION ( keybPressed( oGet, "U" ) )

      REDEFINE BUTTON ID 118 OF oDlg ACTION ( keybPressed( oGet, "I" ) )

      REDEFINE BUTTON ID 119 OF oDlg ACTION ( keybPressed( oGet, "O" ) )

      REDEFINE BUTTON ID 120 OF oDlg ACTION ( keybPressed( oGet, "P" ) )

      REDEFINE BUTTON ID 121 OF oDlg ACTION ( keybPressed( oGet, "A" ) )

      REDEFINE BUTTON ID 122 OF oDlg ACTION ( keybPressed( oGet, "S" ) )

      REDEFINE BUTTON ID 123 OF oDlg ACTION ( keybPressed( oGet, "D" ) )

      REDEFINE BUTTON ID 124 OF oDlg ACTION ( keybPressed( oGet, "F" ) )

      REDEFINE BUTTON ID 125 OF oDlg ACTION ( keybPressed( oGet, "G" ) )

      REDEFINE BUTTON ID 126 OF oDlg ACTION ( keybPressed( oGet, "H" ) )

      REDEFINE BUTTON ID 127 OF oDlg ACTION ( keybPressed( oGet, "J" ) )

      REDEFINE BUTTON ID 128 OF oDlg ACTION ( keybPressed( oGet, "K" ) )

      REDEFINE BUTTON ID 129 OF oDlg ACTION ( keybPressed( oGet, "L" ) )

      REDEFINE BUTTON ID 130 OF oDlg ACTION ( keybPressed( oGet, "Ñ" ) )

      REDEFINE BUTTON ID 131 OF oDlg ACTION ( keybPressed( oGet, "Z" ) )

      REDEFINE BUTTON ID 132 OF oDlg ACTION ( keybPressed( oGet, "X" ) )

      REDEFINE BUTTON ID 133 OF oDlg ACTION ( keybPressed( oGet, "C" ) )

      REDEFINE BUTTON ID 134 OF oDlg ACTION ( keybPressed( oGet, "V" ) )

      REDEFINE BUTTON ID 135 OF oDlg ACTION ( keybPressed( oGet, "B" ) )

      REDEFINE BUTTON ID 136 OF oDlg ACTION ( keybPressed( oGet, "N" ) )

      REDEFINE BUTTON ID 137 OF oDlg ACTION ( keybPressed( oGet, "M" ) )

      REDEFINE BUTTON ID 138 OF oDlg ACTION ( keybPressed( oGet, "," ) )

      REDEFINE BUTTON ID 139 OF oDlg ACTION ( keybPressed( oGet, "." ) )

      REDEFINE BUTTON ID 140 OF oDlg ACTION ( keybPressed( oGet, "-" ) )

      REDEFINE BUTTON ID 150 OF oDlg ACTION ( setFocus( oGet:hWnd ), oGet:keyDown( VK_BACK ) )  //oGet:KeyChar( VK_BACK ) )

      REDEFINE BUTTON ID 151 OF oDlg ACTION ( keybPressed( oGet, " " ) )

      REDEFINE BUTTON ID IDOK       OF oDlg ACTION ( oDlg:End( IDOK ) )

      REDEFINE BUTTON ID IDCANCEL   OF oDlg ACTION ( oDlg:End() )

      oDlg:bStart := {|| oGet:SetFocus( .t. ) }

   ACTIVATE DIALOG oDlg CENTERED

   oFnt:End()

   if oDlg:nResult == IDOK

      if Valtype( uGetKey ) == "O"
         uGetKey:cText( cVar)
      end if

      RETURN ( Rtrim( cVar ) )

   end if

RETURN ( "" )

//---------------------------------------------------------------------------//

FUNCTION keybPressed( oGet, cKey )

   MsgBeep()

   setFocus( oGet:hWnd )

   oGet:KeyChar( ASC( cKey ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

FUNCTION LoadJSONGS128()

   local cFileGS128           
   local cConfigGS128

   static hConfigGS128

   if !empty( hConfigGS128 )
      RETURN ( hConfigGS128 )
   end if 

   cFileGS128                 := cPatConfig() + "\gs128.json"

   if !file( cFileGS128 )
      RETURN ( STRUCT_CODEGS128 )
   end if 

   cConfigGS128               := memoread( cFileGS128 )

   hb_jsonDecode( cConfigGS128, @hConfigGS128 )      

   if empty( hConfigGS128 )
      msgStop( "Fichero " + cFileGS128 + " formato no valido" )
      RETURN ( STRUCT_CODEGS128 )
   end if

RETURN ( hConfigGS128 )

//----------------------------------------------------------------//

FUNCTION ReadCodeGS128( cCode )

   local nAt
   local cLote       := ""
   local hCodeGS128  := {=>}

   // DEFAULT cCode     := "0118411859552753103439@L315140600"

   if ( len( alltrim( cCode ) ) <= 18 )
      RETURN ( hCodeGS128 )
   end if

   // Chapuza pq fw no lee bien los codigos de barras------------------------

   nAt               := at( "@", cCode )
   if nAt != 0
      cCode          := substr( cCode, 1, nAt - 1 ) + substr( cCode, nAt + 1, 2 ) + "@" + substr( cCode, nAt + 3 )
   end if 

   if Substr( cCode, 1, 2 ) == "00"

      hSet( hCodeGS128, "00", { "Codigo"        => Substr( cCode, 3, 18 ),;
                                "Descripcion"   => "Serial Shipping Container",;
                                "Tipo"          => "C",;
                                "Decimales"     => 0 } )

      cCode   := Substr( cCode, 21 )

   end if 

   if Substr( cCode, 1, 2 ) == "01"

      hSet( hCodeGS128, "01", { "Codigo"        => Substr( cCode, 3, 14 ),;
                                "Descripcion"   => "Shipping Container Code",;
                                "Tipo"          => "C",;
                                "Decimales"     => 0 } )

      cCode   := Substr( cCode, 17 )

   end if 

   if Substr( cCode, 1, 2 ) == "02"

      hSet( hCodeGS128, "02", { "Codigo"        => Substr( cCode, 3, 14 ),;
                                "Descripcion"   => "Number of containers",;
                                "Tipo"          => "N",;
                                "Decimales"     => 0 } )

      cCode   := Substr( cCode, 17 )

   end if 

   if Substr( cCode, 1, 2 ) == "10"

      cLote   := Substr( cCode, 3, at( "@", cCode ) - 3 )

      hSet( hCodeGS128, "10", { "Codigo"        => cLote,;
                                "Descripcion"   => "Batch Number",;
                                "Tipo"          => "C",;
                                "Decimales"     => 0 } )

      cCode   := Substr( cCode, at( "@", cCode ) + 1 )

   end if 

   if Substr( cCode, 1, 2 ) == "11"

      hSet( hCodeGS128, "11", { "Codigo"        => DateGS128( Substr( cCode, 3, 6 ) ),;
                                "Descripcion"   => "Production Date",;
                                "Tipo"          => "D",;
                                "Decimales"     => 0 } )

      cCode   := Substr( cCode, 9 )

   end if 
    
   if Substr( cCode, 1, 2 ) == "13"

      hSet( hCodeGS128, "13", { "Codigo"        => DateGS128( Substr( cCode, 3, 6 ) ),;
                                "Descripcion"   => "Packaging Date",;
                                "Tipo"          => "D",;
                                "Decimales"     => 0 } )

      cCode   := Substr( cCode, 9 )

   end if 
    
   if Substr( cCode, 1, 2 ) == "15"

      hSet( hCodeGS128, "15", { "Codigo"        => DateGS128( Substr( cCode, 3, 6 ) ),;
                                "Descripcion"   => "Sell by Date",;
                                "Tipo"          => "D",;
                                "Decimales"     => 0 } )

      cCode   := Substr( cCode, 9 )

   end if

   if Substr( cCode, 1, 2 ) == "17"

      hSet( hCodeGS128, "17", { "Codigo"        => DateGS128( Substr( cCode, 3, 6 ) ),;
                                "Descripcion"   => "Expiration Date",;
                                "Tipo"          => "D",;
                                "Decimales"     => 0 } )

      cCode   := Substr( cCode, 9 )

   end if

   if Substr( cCode, 1, 2 ) == "20"
      
      hSet( hCodeGS128, "20", { "Codigo"        => Val( Substr( cCode, 3, 2 ) ),;
                                "Descripcion"   => "Product Variant",;
                                "Tipo"          => "N",;
                                "Decimales"     => 0 } )

      cCode    := Substr( cCode, 5 )

   end if 

RETURN ( hCodeGS128 )

//---------------------------------------------------------------------------//

FUNCTION ReadHashCodeGS128( cCode, hCodeGS128 )

   local hStruct
   local nAncho   := ""
   local cValor   := 0
   local aGS128   := LoadJSONGS128()

   if empty( hCodeGS128 )
      hCodeGS128  := {=>}
   end if

   if !hb_ischar( cCode ) .or. len( cCode ) == 0
      RETURN ( hCodeGS128 )
   end if 

   if !hb_isarray( aGS128 ) .or. empty( aGS128 ) 
      RETURN ( hCodeGS128 )
   end if 

   for each hStruct in aGS128

      /*
      Compruebo que sea uno de los valores-------------------------------------
      */

      if SubStr( cCode, 1, Len( hGet( hStruct, "Codigo" ) ) ) == hGet( hStruct, "Codigo" )

         nAncho  := hGet( hStruct, "Ancho" ) + hGet( hStruct, "Decimales" )
         cValor  := formatCodeGS128( SubStr( cCode, Len( hGet( hStruct, "Codigo" ) ) + 1, nAncho ), hGet( hStruct, "Tipo" ), hGet( hStruct, "Ancho" ), hGet( hStruct, "Decimales" ) )
         cCode   := SubStr( cCode, Len( hGet( hStruct, "Codigo" ) ) + nAncho + 1 )

         /*
         Lo metemos en el hash-------------------------------------------------
         */

         hSet( hCodeGS128, hGet( hStruct, "Codigo" ), cValor )

         ReadHashCodeGS128( @cCode, hCodeGS128 )

      end if  

   next

RETURN ( hCodeGS128 )

//---------------------------------------------------------------------------//

static FUNCTION formatCodeGS128( cValor, cTipo, nAncho, nDecimales )

  if Empty( cValor )
    RETURN cValor
  end if

  do case
    case cTipo == "C"
      cValor := Padr( cValor, nAncho )

    case cTipo == "N"
      cValor := Val( cValor ) / 1000

    case cTipo == "D"
      cValor := DateGS128( cValor )
      
  end case

RETURN cValor

//---------------------------------------------------------------------------//

FUNCTION uGetCodigo( hHash, cAI )

  local uGetCodigo  := ""

  /*if hHasKey( hHash, cAI )
    hCodeGS128    := hGet( hHash, cAI )
    if !Empty( hCodeGS128 )
      uGetCodigo  := hGet( hCodeGS128, "Codigo" )
    end if
  end if*/

  if hHasKey( hHash, cAI )
    uGetCodigo      := hGet( hHash, cAI )
  end if

RETURN ( uGetCodigo )

//---------------------------------------------------------------------------//

Static FUNCTION DateGS128( cDate )

RETURN ( Stod( "20" + Substr( cDate, 1, 4 ) + if( Substr( cDate, 5, 2 ) == "00", "01", Substr( cDate, 5, 2 ) ) ) )

//---------------------------------------------------------------------------//

FUNCTION PrintGS128()

  local h

  for each h in ReadCodeGS128()
    hEval( h, {|k,v| msgInfo( v, k ) } )
  next 

RETURN nil

//---------------------------------------------------------------------------//

FUNCTION cPathImageApplicationStorage()

RETURN ( FullCurDir() + "Imagen\" )

//---------------------------------------------------------------------------//

FUNCTION cRelativeImageApplicationStorage()

RETURN ( ".\Imagen\" )

//---------------------------------------------------------------------------//

FUNCTION cPathDocumentApplicationStorage()

RETURN ( FullCurDir() + "Documento\" )

//---------------------------------------------------------------------------//

FUNCTION cRelativeDocumentApplicationStorage()

RETURN ( ".\Documento\" )

//---------------------------------------------------------------------------//

