/* v.1.0 18/12/2013
 * Test de la clase Cuaderno, para formatos AEB 19.14 Adeudos Directos y AEB 19.44 B2B
 * (c) Manuel Calero Solis <mcalero@gestool.es>
 * Valido para periodo transitorio Noviembre 2010 / Enero 2016
 */


function main()
 local oCuaderno   := Cuaderno1914():New()
 


   // Presentador--------------------------------------------------------------

   with object ( oCuaderno:GetPresentador() )
      :Entidad( '0081' )
      :Oficina( '1234' )
      :Referencia( 'REMESA0000123' )
      :Nombre( "NOMBRE DEL PRESENTADOR, S.L." )
      :Pais( "ES" )
      :Nif( "W9614457A" )
   end with


   // Acreedor 1 -----------------------------------------------------------------

   with object ( oCuaderno:InsertAcreedor() )
      :FechaCobro( Date() )
      :Nombre( "NOMBRE DEL ACREEDOR #1, S.L." )
      :Direccion( "CALLE DEL ACREEDOR #1, 1234" )
      :CodigoPostal( "12345" )
      :Poblacion( "CIUDAD DEL ACREEDOR #1" )
      :Provincia( "PROVINCIA DEL ACREEDOR #1" )
      :Pais( "ES" )
      :Nif( "E77846772" )
      :CuentaIBAN( "ES7600811234461234567890" )   
   end with


   // Deudor--------------------------------------------------------------------
  
    with object ( oCuaderno:InsertDeudor() )
      :Referencia( 'RECIBO002401' )
      :ReferenciaMandato( '2E5F9458BCD27E3C2B5908AF0B91551A' )
      :Importe( 123.45 )
      :EntidadBIC( 'CAIXESBBXXX' )
      :Nombre( 'NOMBRE DEL DEUDOR, S.L.' )
      :Direccion( "CALLE DEL DEUDOR, 1234" )
      :CodigoPostal( "12345" )
      :Poblacion( "CIUDAD DEL DEUDOR" )
      :Provincia( "PROVINCIA DEL DEUDOR" )
      :Pais( "ES" )
      :Nif( "12345678Z" )
      :CuentaIBAN( "ES0321001234561234567890" )
      :Concepto( 'CONCEPTO DEL ADEUDO FRA.1234' )
      :Categoria( "SUPP" )
   end with



   with object ( oCuaderno:InsertDeudor() )
      :Referencia( 'RECIBO002401' )
      :ReferenciaMandato( '2E5F9458BCD27E3C2B5908AF0B91551A' )
      :Importe( 123.45 )
      :EntidadBIC( 'CAIXESBBXXX' )
      :Nombre( 'NOMBRE DEL DEUDOR, S.L.' )
      :Direccion( "CALLE DEL DEUDOR, 1234" )
      :CodigoPostal( "12345" )
      :Poblacion( "CIUDAD DEL DEUDOR" )
      :Provincia( "PROVINCIA DEL DEUDOR" )
      :Pais( "ES" )
      :Nif( "12345678Z" )
      :CuentaIBAN( "ES0321001234561234567890" )
      :Concepto( 'CONCEPTO DEL ADEUDO FRA.1234' )
      :Categoria( "SUPP" )
   end with

      // Acreedor 2 -----------------------------------------------------------------

   with object ( oCuaderno:InsertAcreedor() )
      :FechaCobro( Date() )
      :Nombre( "NOMBRE DEL ACREEDOR #1, S.L." )
      :Direccion( "CALLE DEL ACREEDOR #1, 1234" )
      :CodigoPostal( "12345" )
      :Poblacion( "CIUDAD DEL ACREEDOR #1" )
      :Provincia( "PROVINCIA DEL ACREEDOR #1" )
      :Pais( "ES" )
      :Nif( "E77846772" )
      :CuentaIBAN( "ES7600811234461234567890" )   
   end with

    with object ( oCuaderno:InsertDeudor() )
      :Referencia( 'RECIBO002401' )
      :ReferenciaMandato( '2E5F9458BCD27E3C2B5908AF0B91551A' )
      :Importe( 123.45 )
      :EntidadBIC( 'CAIXESBBXXX' )
      :Nombre( 'NOMBRE DEL DEUDOR, S.L.' )
      :Direccion( "CALLE DEL DEUDOR, 1234" )
      :CodigoPostal( "12345" )
      :Poblacion( "CIUDAD DEL DEUDOR" )
      :Provincia( "PROVINCIA DEL DEUDOR" )
      :Pais( "ES" )
      :Nif( "12345678Z" )
      :CuentaIBAN( "ES0321001234561234567890" )
      :Concepto( 'CONCEPTO DEL ADEUDO FRA.1234' )
      :Categoria( "SUPP" )
   end with


  with object ( oCuaderno:InsertDeudor() )
      :Referencia( 'RECIBO002401' )
      :ReferenciaMandato( '2E5F9458BCD27E3C2B5908AF0B91551A' )
      :Importe( 123.45 )
      :EntidadBIC( 'CAIXESBBXXX' )
      :Nombre( 'NOMBRE DEL DEUDOR, S.L.' )
      :Direccion( "CALLE DEL DEUDOR, 1234" )
      :CodigoPostal( "12345" )
      :Poblacion( "CIUDAD DEL DEUDOR" )
      :Provincia( "PROVINCIA DEL DEUDOR" )
      :Pais( "ES" )
      :Nif( "12345678Z" )
      :CuentaIBAN( "ES0321001234561234567890" )
      :Concepto( 'CONCEPTO DEL ADEUDO FRA.1234' )
      :Categoria( "SUPP" )
   end with







   oCuaderno:WriteASCII()

   __Run( "notepad.exe " + AllTrim( oCuaderno:cFile ) )

return ( nil ) 

//---------------------------------------------------------------------------//

function Id_Name( cCountry, cCode, cNif )
/*
Identificador del Presentador / Acreedor
Este identificador es una referencia con un máximo de 35 caracteres que contiene los siguientes elementos:
	a) Código del país3: (Posiciones 1ª y 2ª)
	Código ISO 3166 del país que ha emitido el identificador nacional del acreedor. “ES” en el caso español.

	b) Dígitos de control: (Posiciones 3ª y 4ª)
	Código que hace referencia a los componentes a y d. Para su cálculo se requiere la siguiente operación:
	• Excluir las posiciones 5 a 7 de esta referencia
	• Entre las posiciones 8 y 35, eliminar todos los espacios y caracteres no alfanuméricos. Esto es: “/ - ? : ( ) . , ' +”.
	• Añadir el código ISO del país, y ‘00’ a la derecha, y
	• Convertir las letras en dígitos, de acuerdo a la tabla de conversión 1
	• Aplicar el sistema de dígitos de control MOD 97-10.
		A=10, B=11... Z=35 

	c) Código comercial del Acreedor (Sufijo): (Posiciones 5 a 7) Número de tres cifras comprendido entre 000 y 999. 
	Contiene información necesaria en la relación entre la entidad del acreedor y el acreedor y permite al acreedor identificar 
	diferentes líneas comerciales o servicios.

	d) Identificación del Acreedor específica de cada país: (Posiciones 8 a 35) Para los acreedores españoles, se indicará 
	el NIF o NIE del acreedor utilizando para ello las posiciones 8 a 16.
*/
 local cId, n, nLen
 local cAlgorithm := "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

	cId  := ""
	nLen := len( cNif )
	for n:= 1 to nLen
		cValue := substr( cNif, n, 1 )
		if isDigit(cValue)
		   cId += cValue
		else
		   cId += str( at( cValue, cAlgorithm ) +9, 2, 0 )
		endif
	next

	cId += str( at( substr(cCountry,1,1), cAlgorithm ) +9, 2, 0 )
	cId += str( at( substr(cCountry,2,1), cAlgorithm ) +9, 2, 0 )
	cId += "00"
 	cId := cCountry + strzero(98 - ( val(cId) % 97 ), 2) + cCode + cNif
return padR(cId, 35)

