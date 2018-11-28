#include "Error.ch"
#include "FiveWin.ch"
#include "Factu.ch" 

#define  HKEY_LOCAL_MACHINE      2147483650

#define NTRIM(n)                 ( ltrim( str( n ) ) )

static cFullCurDir

static oMeter
static nMeter  := 0

static oText
static cText   := ""

static hRoles  := { "Fiscal"                => "01",;
                    "Oficina contable"      => "01",;
                    "Receptor"              => "02",;
                    "Organo gestor"         => "02",;
                    "Tercero"               => "03",;
                    "Pagador"               => "03",;
                    "Unidad tramitadora"    => "03",;
                    "Comprador"             => "04",;
                    "Organo proponente"     => "04",;
                    "Cobrador"              => "05",;
                    "Vendedor"              => "06",;
                    "Receptor del pago"     => "07",;
                    "Receptor del cobro"    => "08",;
                    "Emisor"                => "09" }

static hPaises := { "Afganist�n" => "AFG",;
                    "Albania" => "ALB",;
                    "Alemania" => "DEU",;
                    "Algeria" => "DZA",;
                    "Andorra" => "AND",;
                    "Angola" => "AGO",;
                    "Anguila" => "AIA",;
                    "Ant�rtida" => "ATA",;
                    "Antigua y Barbuda" => "ATG",;
                    "Antillas Neerlandesas" => "ANT",;
                    "Arabia Saudita" => "SAU",;
                    "Argentina" => "ARG",;
                    "Armenia" => "ARM",;
                    "Aruba" => "ABW",;
                    "Australia" => "AUS",;
                    "Austria" => "AUT",;
                    "Azerbay�n" => "AZE",;
                    "B�lgica" => "BEL",;
                    "Bahamas" => "BHS",;
                    "Bahrein" => "BHR",;
                    "Bangladesh" => "BGD",;
                    "Barbados" => "BRB",;
                    "Belice" => "BLZ",;
                    "Ben�n" => "BEN",;
                    "Bhut�n" => "BTN",;
                    "Bielorrusia" => "BLR",;
                    "Birmania" => "MMR",;
                    "Bolivia" => "BOL",;
                    "Bosnia y Herzegovina" => "BIH",;
                    "Botsuana" => "BWA",;
                    "Brasil" => "BRA",;
                    "Brun�i" => "BRN",;
                    "Bulgaria" => "BGR",;
                    "Burkina Faso" => "BFA",;
                    "Burundi" => "BDI",;
                    "Cabo Verde" => "CPV",;
                    "Camboya" => "KHM",;
                    "Camer�n" => "CMR",;
                    "Canad�" => "CAN",;
                    "Chad" => "TCD",;
                    "Chile" => "CHL",;
                    "China" => "CHN",;
                    "Chipre" => "CYP",;
                    "Ciudad del Vaticano" => "VAT",;
                    "Colombia" => "COL",;
                    "Comoras" => "COM",;
                    "Congo" => "COG",;
                    "Congo" => "COD",;
                    "Corea del Norte" => "PRK",;
                    "Corea del Sur" => "KOR",;
                    "Costa de Marfil" => "CIV",;
                    "Costa Rica" => "CRI",;
                    "Croacia" => "HRV",;
                    "Cuba" => "CUB",;
                    "Dinamarca" => "DNK",;
                    "Dominica" => "DMA",;
                    "Ecuador" => "ECU",;
                    "Egipto" => "EGY",;
                    "El Salvador" => "SLV",;
                    "Emiratos �rabes Unidos" => "ARE",;
                    "Eritrea" => "ERI",;
                    "Eslovaquia" => "SVK",;
                    "Eslovenia" => "SVN",;
                    "Espa�a" => "ESP",;
                    "Estados Unidos de Am�rica" => "USA",;
                    "Estonia" => "EST",;
                    "Etiop�a" => "ETH",;
                    "Filipinas" => "PHL",;
                    "Finlandia" => "FIN",;
                    "Fiyi" => "FJI",;
                    "Francia" => "FRA",;
                    "Gab�n" => "GAB",;
                    "Gambia" => "GMB",;
                    "Georgia" => "GEO",;
                    "Ghana" => "GHA",;
                    "Gibraltar" => "GIB",;
                    "Granada" => "GRD",;
                    "Grecia" => "GRC",;
                    "Groenlandia" => "GRL",;
                    "Guadalupe" => "GLP",;
                    "Guam" => "GUM",;
                    "Guatemala" => "GTM",;
                    "Guayana Francesa" => "GUF",;
                    "Guernsey" => "GGY",;
                    "Guinea" => "GIN",;
                    "Guinea Ecuatorial" => "GNQ",;
                    "Guinea-Bissau" => "GNB",;
                    "Guyana" => "GUY",;
                    "Hait�" => "HTI",;
                    "Honduras" => "HND",;
                    "Hong kong" => "HKG",;
                    "Hungr�a" => "HUN",;
                    "India" => "IND",;
                    "Indonesia" => "IDN",;
                    "Ir�n" => "IRN",;
                    "Irak" => "IRQ",;
                    "Irlanda" => "IRL",;
                    "Isla Bouvet" => "BVT",;
                    "Isla de Man" => "IMN",;
                    "Isla de Navidad" => "CXR",;
                    "Isla Norfolk" => "NFK",;
                    "Islandia" => "ISL",;
                    "Islas Bermudas" => "BMU",;
                    "Islas Caim�n" => "CYM",;
                    "Islas Cocos (Keeling)" => "CCK",;
                    "Islas Cook" => "COK",;
                    "Islas de �land" => "ALA",;
                    "Islas Feroe" => "FRO",;
                    "Islas Georgias del Sur y Sandwich del Sur" => "SGS",;
                    "Islas Heard y McDonald" => "HMD",;
                    "Islas Maldivas" => "MDV",;
                    "Islas Malvinas" => "FLK",;
                    "Islas Marianas del Norte" => "MNP",;
                    "Islas Marshall" => "MHL",;
                    "Islas Pitcairn" => "PCN",;
                    "Islas Salom�n" => "SLB",;
                    "Islas Turcas y Caicos" => "TCA",;
                    "Islas Ultramarinas Menores de Estados Unidos" => "UMI",;
                    "Islas V�rgenes Brit�nicas" => "VG",;
                    "Islas V�rgenes de los Estados Unidos" => "VIR",;
                    "Israel" => "ISR",;
                    "Italia" => "ITA",;
                    "Jamaica" => "JAM",;
                    "Jap�n" => "JPN",;
                    "Jersey" => "JEY",;
                    "Jordania" => "JOR",;
                    "Kazajist�n" => "KAZ",;
                    "Kenia" => "KEN",;
                    "Kirgizst�n" => "KGZ",;
                    "Kiribati" => "KIR",;
                    "Kuwait" => "KWT",;
                    "L�bano" => "LBN",;
                    "Laos" => "LAO",;
                    "Lesoto" => "LSO",;
                    "Letonia" => "LVA",;
                    "Liberia" => "LBR",;
                    "Libia" => "LBY",;
                    "Liechtenstein" => "LIE",;
                    "Lituania" => "LTU",;
                    "Luxemburgo" => "LUX",;
                    "M�xico" => "MEX",;
                    "M�naco" => "MCO",;
                    "Macao" => "MAC",;
                    "Maced�nia" => "MKD",;
                    "Madagascar" => "MDG",;
                    "Malasia" => "MYS",;
                    "Malawi" => "MWI",;
                    "Mali" => "MLI",;
                    "Malta" => "MLT",;
                    "Marruecos" => "MAR",;
                    "Martinica" => "MTQ",;
                    "Mauricio" => "MUS",;
                    "Mauritania" => "MRT",;
                    "Mayotte" => "MYT",;
                    "Micronesia" => "FSM",;
                    "Moldavia" => "MDA",;
                    "Mongolia" => "MNG",;
                    "Montenegro" => "MNE",;
                    "Montserrat" => "MSR",;
                    "Mozambique" => "MOZ",;
                    "Namibia" => "NAM",;
                    "Nauru" => "NRU",;
                    "Nepal" => "NPL",;
                    "Nicaragua" => "NIC",;
                    "Niger" => "NER",;
                    "Nigeria" => "NGA",;
                    "Niue" => "NIU",;
                    "Noruega" => "NOR",;
                    "Nueva Caledonia" => "NCL",;
                    "Nueva Zelanda" => "NZL",;
                    "Om�n" => "OMN",;
                    "Pa�ses Bajos" => "NLD",;
                    "Pakist�n" => "PAK",;
                    "Palau" => "PLW",;
                    "Palestina" => "PSE",;
                    "Panam�" => "PAN",;
                    "Pap�a Nueva Guinea" => "PNG",;
                    "Paraguay" => "PRY",;
                    "Per�" => "PER",;
                    "Polinesia Francesa" => "PYF",;
                    "Polonia" => "POL",;
                    "Portugal" => "PRT",;
                    "Puerto Rico" => "PRI",;
                    "Qatar" => "QAT",;
                    "Reino Unido" => "GBR",;
                    "Rep�blica Centroafricana" => "CAF",;
                    "Rep�blica Checa" => "CZE",;
                    "Rep�blica Dominicana" => "DOM",;
                    "Reuni�n" => "REU",;
                    "Ruanda" => "RWA",;
                    "Ruman�a" => "ROU",;
                    "Rusia" => "RUS",;
                    "Sahara Occidental" => "ESH",;
                    "Samoa" => "WSM",;
                    "Samoa Americana" => "ASM",;
                    "San Bartolom�" => "BLM",;
                    "San Crist�bal y Nieves" => "KNA",;
                    "San Marino" => "SMR",;
                    "San Mart�n (Francia)" => "MAF",;
                    "San Pedro y Miquel�n" => "SPM",;
                    "San Vicente y las Granadinas" => "VCT",;
                    "Santa Elena" => "SHN",;
                    "Santa Luc�a" => "LCA",;
                    "Santo Tom� y Pr�ncipe" => "STP",;
                    "Senegal" => "SEN",;
                    "Serbia" => "SRB",;
                    "Seychelles" => "SYC",;
                    "Sierra Leona" => "SLE",;
                    "Singapur" => "SGP",;
                    "Siria" => "SYR",;
                    "Somalia" => "SOM",;
                    "Sri lanka" => "LKA",;
                    "Sud�frica" => "ZAF",;
                    "Sud�n" => "SDN",;
                    "Suecia" => "SWE",;
                    "Suiza" => "CHE",;
                    "Surin�m" => "SUR",;
                    "Svalbard y Jan Mayen" => "SJM",;
                    "Swazilandia" => "SWZ",;
                    "Tadjikist�n" => "TJK",;
                    "Tailandia" => "THA",;
                    "Taiw�n" => "TWN",;
                    "Tanzania" => "TZA",;
                    "Territorio Brit�nico del Oc�ano �ndico" => "IOT",;
                    "Territorios Australes y Ant�rticas Franceses" => "ATF",;
                    "Timor Oriental" => "TLS",;
                    "Togo" => "TGO",;
                    "Tokelau" => "TKL",;
                    "Tonga" => "TON",;
                    "Trinidad y Tobago" => "TTO",;
                    "Tunez" => "TUN",;
                    "Turkmenist�n" => "TKM",;
                    "Turqu�a" => "TUR",;
                    "Tuvalu" => "TUV",;
                    "Ucrania" => "UKR",;
                    "Uganda" => "UGA",;
                    "Uruguay" => "URY",;
                    "Uzbekist�n" => "UZB",;
                    "Vanuatu" => "VUT",;
                    "Venezuela" => "VEN",;
                    "Vietnam" => "VNM",;
                    "Wallis y Futuna" => "WLF",;
                    "Yemen" => "YEM",;
                    "Yibuti" => "DJI",;
                    "Zambia" => "ZMB",;
                    "Zimbabue" => "ZWE" }

//--------------------------------------------------------------------------//

Function aRolesValues()           

Return hGetKeys( hRoles )         

//--------------------------------------------------------------------------//

Function getRolCode( cRolName )     

   local cRolCode := ""

   if empty( cRolName )
      Return ( cRolCode )
   end if 

   cRolName       := alltrim( cRolName )

   if hHasKey( hRoles, cRolName ) 
      cRolCode    := hGet( hRoles, cRolName )
   end if 

Return ( cRolCode )         

//--------------------------------------------------------------------------//

Function aPaisesValues()           

Return hGetKeys( hPaises )         

//--------------------------------------------------------------------------//

Function getPaisCode( cPaisName )     

   local cPaisCode := ""

   if empty( cPaisName )
      Return ( cPaisCode )
   end if 

   cPaisName       := alltrim( cPaisName )

   if hHasKey( hPaises, cPaisName ) 
      cPaisCode    := hGet( hPaises, cPaisName )
   end if 

Return ( cPaisCode )         

//--------------------------------------------------------------------------//

#ifndef __PDA__

/*
Alinea por la derecha una cadena con el caracter pasado como 2�
argumento
*/

FUNCTION LJust( cCadena, cChar, nLen )

	DEFAULT cChar := ' '
	DEFAULT nLen  := Len( cCadena )

	IF ValType( cCadena ) == "N"
		cCadena := Str( Int( cCadena ) )
	END IF

RETURN PadR( AllTrim( cCadena ), nLen, cChar )

//--------------------------------------------------------------------------//

/*
Devuelve una cadena con la fecha pasada como argumento
*/

FUNCTION cHoy( dFecha )

	local cMes
	local aMeses := { "Enero",;
							"Febrero",;
							"Marzo",;
							"Abril",;
							"Mayo",;
							"Junio",;
							"Julio",;
							"Agosto",;
							"Septiembre",;
							"Octubre",;
							"Noviembre",;
							"Diciembre" }

	DEFAULT dFecha := DATE()

	cMes	:= aMeses[ month( dFecha ) ]

RETURN ( Str(Day(dFecha)) + " de " +  cMes + " de " + str(year(dFecha)) )

//--------------------------------------------------------------------------//

/*
Crear un codeblock con la expresi�n pasada como argumento comprobando
antes de ralizar esta operacion que sea una expresion valida
*/

FUNCTION Compile( cExpression )

	local bExpression

   if !Empty( cExpression ) .and. Type( cExpression ) != "UE" .and. Type( cExpression ) != "UI"
      bExpression    := &( "{|| " + Rtrim( cExpression ) + " } " )
   else
      bExpression    := nil 
   end if

RETURN ( bExpression )

//----------------------------------------------------------------------------//

FUNCTION CompileParam( cExpression )

   local lError
   local oError
   local oBlock
   local bExpression

   lError            := .f.

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      bExpression    := &( "{| uParam | " + Rtrim( cExpression ) + " } " )

   RECOVER USING oError

      lError         := .t.

   END SEQUENCE

   ErrorBlock( oBlock )

   if lError

      msgStop( "Expresi�n incorrecta " + cExpression + CRLF + ErrorMessage( oError ), cExpression )

      bExpression    := nil

   end if

RETURN ( bExpression )

//----------------------------------------------------------------------------//
/*
Camino completo dentro de un disco
*/

FUNCTION FullCurDir()

   if empty( cFullCurDir )

      cFullCurDir    := hb_curdrive()
 
      if isalpha( cFullCurDir ) .and. ( cFullCurDir != "A" )
         cFullCurDir += ":\"
      else 
         cFullCurDir := "\"
      end if

      cFullCurDir    += curdir() + if( !empty( curdir() ), "\", "" )

   end if

RETURN ( cFullCurDir )

//----------------------------------------------------------------------------//
/*
Funcion Len con mas tipos de datos y acepta pictures
*/

FUNCTION nlen( xVar, xPicture )

   LOCAL nLen  := 0
   LOCAL cTipo := ValType( xVar )

   do case
      case ( cTipo == 'N' ) .AND. ( xPicture == NIL )
			nLen := len( str( xVar ) )   // Controlar decimales y tama�o

      case ( cTipo == 'N' ) .AND. ( xPicture != NIL )
			nLen := len( Transform( xVar, xPicture ) )

      case ( cTipo == 'C' ) .AND. ( xPicture == NIL )
			nLen := len( xVar )

      case ( cTipo == 'C' ) .AND. ( xPicture != NIL )
			nLen := len( Transform( xVar, xPicture ) )

      case ( cTipo == 'D' )
			 nLen := len( dtoc( xVar ) )  // Por el SET CENTURY

      case ( cTipo == 'L' )
			 nLen := 1

      case ( cTipo == 'A' )
			 nLen := Len( xVar )

      case ( cTipo == 'B' )
          nLen := nLen( Eval( xVar ) ) // Recursiva hasta devolver la len del valor de la ultima evaluacion

   end case

RETURN nLen

//--------------------------------------------------------------------------//

FUNCTION nPadR( cText, nSize, oFont, nCol, oInf )

	local nStartCol
	local nWidth

	nWidth 		:= oInf:oDevice:GetTextWidth( cText, oFont ) / oInf:nLogPixX
	nSize			:= oInf:oDevice:GetTextWidth( Replicate( "B", nSize),	oFont ) / oInf:nLogPixX

   nStartCol   := nCol - nWidth + nSize

RETURN nStartCol

//---------------------------------------------------------------------------//

FUNCTION nPadC( cText, nSize, oFont, nCol, oInf )

	local nStartCol
	local nWidth

	nWidth 		:= oInf:oDevice:GetTextWidth( cText, oFont ) / oInf:nLogPixX
	nSize			:= oInf:oDevice:GetTextWidth( Replicate( "B", nSize),	oFont ) / oInf:nLogPixX

	nStartCol	:= nCol + ( ( nWidth - nSize ) / 2 )

RETURN nStartCol

//---------------------------------------------------------------------------//

FUNCTION cDayToStr( dDate )

RETURN ( { "Domingo", "Lunes", "Martes", "Mi�rcoles", "Jueves", "Viernes", "S�bado" }[ DoW( dDate ) ] )

//---------------------------------------------------------------------------//

FUNCTION cMonthToStr( dDate )

RETURN ( {  "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto",;
            "Septiembre", "Octubre", "Noviembre", "Diciembre" }[ Month( dDate ) ] )

//---------------------------------------------------------------------------//
//Devuelve informaci�n sobre la impresora indicada
//

function aPrinterInfo( cPrnName )

   local aInfo    := {}

return ( aInfo )

//---------------------------------------------------------------------------//

Function GoWeb( cUrl )

   DEFAULT cUrl   := __GSTWEB__

   IF !IsWinNt()
      WinExec('start urlto:'+cURL,0)
   ELSE
      WinExec("rundll32.exe url.dll,FileProtocolHandler " + cURL)
   ENDIF

Return NIL

//---------------------------------------------------------------------------//

Function GoHelp( cUrl )

   IF !IsWinNt()
      WinExec( 'start urlto:' + __GSTHELP__ , 0 )
   ELSE
      WinExec( "rundll32.exe url.dll,FileProtocolHandler " + __GSTHELP__ )
   ENDIF

Return NIL

//---------------------------------------------------------------------------//

Static Function DecodeUrlHelp( cUrl )

   cUrl     := StrTran( cUrl, ' ', '_' )
   cUrl     := StrTran( cUrl, '�', '%C3%B1' )
   cUrl     := StrTran( cUrl, '�', '%C3%91' )
   cUrl     := StrTran( cUrl, '�', '%C3%A1' )
   cUrl     := StrTran( cUrl, '�', '%C3%A9' )
   cUrl     := StrTran( cUrl, '�', '%C3%AD' )
   cUrl     := StrTran( cUrl, '�', '%C3%B3' )
   cUrl     := StrTran( cUrl, '�', '%C3%BA' )
   cUrl     := StrTran( cUrl, '�', '%C3%81' )
   cUrl     := StrTran( cUrl, '�', '%C3%89' )
   cUrl     := StrTran( cUrl, '�', '%C3%8D' )
   cUrl     := StrTran( cUrl, '�', '%C3%93' )
   cUrl     := StrTran( cUrl, '�', '%C3%9A' )

Return ( cUrl )


#endif

//---------------------------------------------------------------------------//

Function cNamePath( cFile )

   local nPos     := 0
   local cPath    := ""

   if ( nPos := rat( "\", cFile ) ) != 0
      cPath       := ( substr( cFile, 1, nPos - 1 ) )
   endif

Return( cPath )

//---------------------------------------------------------------------------//

FUNCTION RJustObj( oGet, cChar, nLen )

   local cCadena  := oGet:varGet()

   DEFAULT cChar  := ' '
   DEFAULT nLen   := Len( cCadena )

   cCadena        := RJust( cCadena, cChar, nLen )

	oGet:varPut( cCadena )
	oGet:refresh()

RETURN cCadena

//--------------------------------------------------------------------------//

FUNCTION PntReplace( oGet, cChar, nLen )

   local cCadena     := ""
   local nPointPos

   if !hb_isobject( oGet )
      RETURN cCadena
   end if 

   cCadena           := oGet:varGet()

   DEFAULT cChar     := "0"
   DEFAULT nLen      := len( cCadena )

   nPointPos         := at( ".", cCadena )

	if nPointPos != 0

      cCadena        := strtran( cCadena, ".", "0" )

		while len( alltrim( cCadena ) ) < nLen
			cCadena     := substr( cCadena, 1, nPointPos - 1 ) + cChar + substr( cCadena, nPointPos )
		end while

		oGet:cText( cCadena )

	end if

RETURN cCadena

//--------------------------------------------------------------------------//

/*
Alinea por la derecha una cadena con el caracter pasado como 2�
argumento
*/

FUNCTION RJust( cCadena, cChar, nLen )

	DEFAULT cChar := '0'
	DEFAULT nLen  := Len( cCadena )

	IF ValType( cCadena ) == "N"
		cCadena    := Str( Int( cCadena ) )
	END IF

RETURN PadL( AllTrim( cCadena ), nLen, cChar )

//--------------------------------------------------------------------------//

FUNCTION nextDocumentNumber( cNumero, nLen )

   local nAt
   local cSerie     := ""
   local nNumero

   DEFAULT cNumero  := "0"
   DEFAULT nLen     := 50

   cNumero          := alltrim( cNumero )

   nAt              := rat( "/", cNumero )
   if nAt == 0
      nNumero       := val( cNumero ) + 1
      RETURN ( padr( rjust( nNumero, "0", 6 ), nLen ) )
   end if 
   
   cSerie           := substr( cNumero, 1, nAt  )
   nNumero          := val( substr( cNumero, nAt + 1 ) ) + 1

RETURN ( padr( cSerie + rjust( nNumero, "0", 6 ), nLen ) )

//--------------------------------------------------------------------------//

Function GetSubArray( aArray, nPos )

   local a
   local aKeys    := {}

   for each a in aArray
      if !empty(a[ nPos ])
         aAdd( aKeys, a[ nPos ] )
      end if 
   next 

RETURN ( aKeys )

//--------------------------------------------------------------------------//

FUNCTION cGetValue( xVal, cType )

   local cTemp    := ""

   DEFAULT cType  := ValType( xVal )

   xVal           := IsCharBlock( xVal )

   do case
      case cType == "C" .or. cType == "M"

         if !Empty( xVal )
            xVal  := Rtrim( xVal )
         end if
         
         if ( '"' $ xVal ) .or. ( "'" $ xVal )
            cTemp := Rtrim( cValToChar( xVal ) )
         else
            cTemp := '"' + Rtrim( cValToChar( xVal ) ) + '"'
         end if

      case cType == "N"
         cTemp    := cValToChar( xVal )

      case cType == "D"

         cTemp    := 'Ctod( "' + Rtrim( cValToChar( xVal ) ) + '" )'

      case cType == "L"
         if "S" $ Rtrim( Upper( xVal ) )
            cTemp := ".t."
         else
            cTemp := ".f."
         end if

   end case

RETURN ( Rtrim( cTemp ) )

//---------------------------------------------------------------------------//

Static Function IsCharBlock( xVal )

   if IsChar( xVal )

      xVal           := AllTrim( xVal )

      if left( xVal, 1 ) == "{" .and. right( xVal, 1 ) == "}"
         xVal        := StrTran( xVal, "{", "" )
         xVal        := StrTran( xVal, "}", "" )
         xVal        := c2Block( xVal )
         if IsBlock( xVal )
            xVal     := Eval( xVal )
         end if 

      end if 

   end if

Return ( xVal )

//---------------------------------------------------------------------------//

Function AutoMeterDialog( oDialog )

   oDialog:Disable()

   oMeter   := TMeter():New( 0, 0, {| u | if( pCount() == 0, nMeter, nMeter := u ) }, 100, oDialog, oDialog:nWidth, 4, .t., .t., , "", .t., , ,rgb( 128,255,0 ) )

RETURN ( oMeter )

//---------------------------------------------------------------------------//

Function SetTotalAutoMeterDialog( nSet )

   if !empty(oMeter)
      oMeter:SetTotal( nSet )  
   end if 

RETURN ( oMeter )

//---------------------------------------------------------------------------//

Function SetAutoMeterDialog( nSet )

   if !empty(oMeter)
      oMeter:Set( nSet )
   end if 

RETURN ( oMeter )

//---------------------------------------------------------------------------//

Function EndAutoMeterDialog( oDialog )

   if !empty( oMeter )    
      oMeter:Hide()
      oMeter:End()
   end if 

   oMeter   := nil

   oDialog:Enable()

RETURN ( nil )

//---------------------------------------------------------------------------//

Function GetAutoMeterDialog( nSet )

RETURN ( oMeter )

//---------------------------------------------------------------------------//

Function autoTextDialog( oDialog, textColor, backgroundColor )

   DEFAULT textColor        := rgb(0,0,0)
   DEFAULT backgroundColor  := rgb(239,228,176)

   oText                    := TSay():New( 2, 0, {||cText}, oDialog, , , .t., .f., .f., .t., textColor, backgroundColor, oDialog:nWidth, 16, .f., .t., .f., .f., .f. )

RETURN ( oText )

//---------------------------------------------------------------------------//

Function SetAutoTextDialog( cText, oDialog, textColor, backgroundColor ) 

   DEFAULT textColor        := rgb(0,0,0)
   DEFAULT backgroundColor  := rgb(239,228,176)

   if empty(oText) .and. !empty(oDialog)
      autoTextDialog( oDialog, textColor, backgroundColor )
   end if 

   if !empty(oText)
      oText:SetText( cText )  
   end if 

   sysRefresh()

RETURN ( oText )

//---------------------------------------------------------------------------//

Function setAlertTextDialog( cText, oDialog )

Return ( setAutoTextDialog( cText, oDialog, rgb(255,255,255), rgb(234,67,53) ) )

//---------------------------------------------------------------------------//

Function HideAutoTextDialog()

   if !empty(oText)
      oText:Hide()
   end if

RETURN ( oText )

//---------------------------------------------------------------------------//

Function EndAutoTextDialog()

   HideAutoTextDialog()

   if !empty(oText)
      oText:End()
      oText   := nil
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

Function GetAutoTextDialog()

RETURN ( oText )

//---------------------------------------------------------------------------//
