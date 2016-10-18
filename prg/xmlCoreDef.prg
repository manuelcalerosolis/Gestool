/* v.1.0 31/12/2013
 * SEPA Core Direct Debit Versi�n 6.0 RB Noviembre 2012
 * Adeudos Directos SEPA ESQUEMA B�SICO (pain.008.001.02) 
 * Para lenguaje Harbour - http://harbour-project.org
 * (c) Joaquim Ferrer Godoy <quim_ferrer@yahoo.es>
 *
 * Notas :
 * (1) TRUE = Un apunte en cuenta por la suma de los importes de todas las operaciones del mensaje.
 *    FALSE= Un apunte en cuenta por cada una de las operaciones incluidas en el mensaje.
 * (2) FNAL=�ltimo adeudo de una serie de adeudos recurrentes.
 *     FRST=Primer adeudo de una serie de adeudos recurrentes.
 *    OOFF=Adeudo correspondiente a una operaci�n con un �nico pago(*).
 *    RCUR=Adeudo de una serie de adeudos recurrentes, cuando no se trata ni del primero ni del �ltimo.
 *    (*) Para este tipo de operaciones el mandato y su referencia deben ser �nicos y no pueden utilizarse para operaciones 
 *    puntuales posteriores. Si siempre se factura a los mismos clientes, aunque varie el importe de los adeudos y la periodicidad
 *    de los mismos, es necesario utilizar el tipo de adeudo recurrente si se utiliza la misma referencia, creando para cada 
 *    cliente deudor un solo mandato que ampare todos los adeudos que se emitan. 
 *    El primer adeudo deber� ser FRST y los siguientes RCUR.
 * (3) Esta etiqueta s�lo debe usarse cuando un mismo n�mero de cuenta cubra diferentes divisas y el presentador 
 *       necesite identificar en cu�l de estas divisas debe realizarse el asiento sobre su cuenta.
 * (4) Regla de uso: Solamente se admite el c�digo �SLEV�
 * (5) La etiqueta �Cl�usula de gastos� puede aparecer, bien en el nodo �Informaci�n del pago� (2.0), bien en el 
 *       nodo �Informaci�n de la operaci�n de adeudo directo� (2.28), pero solamente en uno de ellos. 
 *       Se recomienda que se recoja en el bloque �Informaci�n del pago� (2.0).
 * (6) Regla de uso: Para el sistema de adeudos SEPA se utilizar� exclusivamente la etiqueta �Otra� estructurada 
 *    seg�n lo definido en el ep�grafe �Identificador del presentador� de la secci�n 3.3 del cuaderno.
 */

#include "hbmxml.ch"

#define CRLF chr(13)+chr(10)

#define ENTIDAD_JURIDICA   0
#define ENTIDAD_FISICA     1
#define ENTIDAD_OTRA       2

static aItems := {}
static aData  := {=>}

//--------------------------------------------------------------------------------------//

function main()

   local cDocType, cFileOut
   local hXmlDoc, hDoc
   local aCreditor := {=>}

   cDocType    := "pain.008.001.02"
   cFileOut    := "testSepa.xml"
   hXmlDoc     := mxmlNewXML()
   hDoc     := mxmlNewElement(hXmlDoc, "Document")

   mxmlElementSetAttr( hDoc, "xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance" )
   mxmlElementSetAttr( hDoc, "xmlns","urn:iso:std:iso:20022:tech:xsd:"+ cDocType )

   aCreditor["Id"]      := "NL64ZZZ321096320000"         // Identificaci�n 
   aCreditor["Prtry"]      := "SEPA"                     // Propietario 

   aData[ "MsgId"        ] := "MFISH-20131021195435-wzkR23K"   // Identificaci�n del mensaje
   aData[ "CreDtTm"      ] := "2013-10-21T19:54:35"         // Fecha y hora de creaci�n

   /* Variables contador */
   NbOfTxs           := "1"                        // N�mero de operaciones 
   CtrlSum           := "100.00"                   // Control de suma total importes

   aData[ "PmtInfId"      ] := "M20131021195-wzkR23K-1"     // Identificaci�n de la informaci�n del pago 
   aData[ "PmtMtd"        ] := "DD"                      // M�todo de pago Regla de uso: Solamente se admite el c�digo �DD�
   aData[ "BtchBookg"     ] := "TRUE"                    // Indicador de apunte en cuenta (1)

   /* Variables contador */
   NbOfTxs           := "1"                        // N�mero de operaciones 
   CtrlSum           := "100.00"                   // Control de suma total importes

   aData["SeqTp"           ] := "RCUR"                   // Tipo de secuencia (2)
   aData["PurpCode"     ] := ""                    // C�digo 
   aData["PurpProprietary" ] := ""                    // Propietario
   aData["ReqdColltnDt"    ] := "2013-10-21"             // Fecha de cobro
   aData["CreditorName"    ] := "NOMBRE DEL ACREEDOR"          // Nombre 
   aData["CreditorCountry" ] := "ES"                     // Pa�s
   aData["CreditorAdress"  ] := ""                    // Direcci�n en texto libre
   aData["CreditorIban"    ] := "NL71RABO0300300301"        // IBAN
   aData["Ccy"             ] := ""                    // Moneda (3) 
   aData["CreditorBic"     ] := "RABONL2U"               // BIC 
   aData["ChrgBr"          ] := "SLEV"                   // Cl�usula de gastos (4)
   aData["InstrId"         ] := ""                    // Identificaci�n de la instrucci�n
   aData["EndToEndId"      ] := "M20131021195-wzkR23K-1-0001"  // Identificaci�n de extremo a extremo 
   aData["InstdAmt"           ] := "5.00"                   // Importe ordenado 
   aData["MndtId"          ] := "NL17ZZZ412004150001"       // Identificaci�n del mandato 
   aData["DtOfSgntr"    ] := "2012-10-28"                // Fecha de firma 
   aData["AmdmntInd"    ] := "FALSE"                  // Indicador de modificaci�n, TRUE=El mandato se ha modificado
   aData["OrgnlMndtId"     ] := ""                    // Identificaci�n del mandato original 
   aData["DebtorIban"      ] := "NL31INGB0000000044"        // IBAN
   aData["DebtorAgent"     ] := ""                    // Identificaci�n
   aData["ElctrncSgntr" ] := ""                    // Firma electr�nica
   aData["DebtorBic"    ] := "INGBNL2A"                  // BIC 
   
   // aData["DebtorIban"      ] := ""        // IBAN
   aData["Purpose"         ] := ""                    // Codigo Proposito
   aData["DbtCdtRptgInd"   ] := ""                       // Alcance de la informaci�n
   aData["DtlsCode"     ] := ""                    // C�digo
   aData["Amt"          ] := ""                    // Importe
   aData["Inf"          ] := ""                       // Informaci�n
   aData["Ustrd"        ] := "Donation Greenpeace"          // No estructurado
   aData["RefInf"       ] := ""                    // C�digo
   aData["Issr"         ] := ""                    // Emisor
   aData["Ref"          ] := ""                       // Referencia

   MsgStruct( hDoc, aCreditor )

   mxmlSaveFile( hXmlDoc, cFileOut, MXML_NO_CALLBACK )

   cStr := Space( 64000 )
      mxmlSaveString( hXmlDoc, @cStr, MXML_NO_CALLBACK ) 
   //mxmlSaveString( hXmlDoc, @cStr, @type_cb() ) 
   //OutStd( cStr + CRLF )

      mxmlSAXLoadString( NIL, cStr, @type_cb(), NIL, MXML_NO_CALLBACK )

    //hXmlDoc := mxmlLoadString( nil, cStr, @type_cb() )


   mxmlDelete( hXmlDoc )

return NIL

//--------------------------------------------------------------------------------------//

static function MsgStruct( hDoc, aCreditor )

 local ServiceLevel     := "SEPA"                     // C�digo nivel de servicio, admitido s�lo SEPA
 local LocalInstrument  := "CORE"                     // C�digo Instrumento local, admitido s�lo CORE o COR1

   ItemNew(1, "CstmrDrctDbtInitn",,,, hDoc)           // Ra�z del mensaje 
   ItemNew(2, "GrpHdr")                            // Cabecera 
   ItemNew(3, "MsgId", 35, aData["MsgId"])            // Identificaci�n del mensaje
   ItemNew(3, "CreDtTm", 19, aData["CreDtTm"])        // Fecha y hora de creaci�n
   ItemNew(3, "NbOfTxs", 15, NbOfTxs)                 // N�mero de operaciones 
   ItemNew(3, "CtrlSum", 18, CtrlSum)                 // Control de suma 

   FieldNew(3, "InitgPty")                         // Parte iniciadora (6)

   ItemNew(2, "PmtInf")                            // Informaci�n del pago 
   ItemNew(3, "PmtInfId", 35, aData["PmtInfId"])         // Identificaci�n de la informaci�n del pago 
   ItemNew(3, "PmtMtd", 2, aData["PmtMtd"])           // M�todo de pago
   ItemNew(3, "BtchBookg", 5, aData["BtchBookg"])        // Indicador de apunte en cuenta
   ItemNew(3, "NbOfTxs", 15, NbOfTxs)                 // N�mero de operaciones 
   ItemNew(3, "CtrlSum", 18, CtrlSum)                 // Control de suma 

   ItemNew(3, "PmtTpInf")                          // Informaci�n del tipo de pago 
   ItemNew(4, "SvcLvl")                            // Nivel de servicio 
   ItemNew(5, "Cd", 4, ServiceLevel)                  // C�digo Nivel de servicio
   ItemNew(4, "LclInstrm")                         // Instrumento local  
   ItemNew(5, "Cd", 35, LocalInstrument)              // C�digo Instrumento local
   ItemNew(4, "SeqTp", 4, aData["SeqTp"])                // Tipo de secuencia
   ItemNew(4, "CtgyPurp")                          // Categor�a del prop�sito 
   ItemNew(5, "Cd", 4, aData["PurpCode"])                // C�digo 
   ItemNew(5, "Prtry", 35, aData["PurpProprietary"])     // Propietario

   ItemNew(3, "ReqdColltnDt", 8, aData["ReqdColltnDt"])  // Fecha de cobro

   ItemNew(3, "Cdtr")                              // Acreedor 
   ItemNew(4, "Nm", 70, aData["CreditorName"])        // Nombre 
   ItemNew(4, "PstlAdr")                           // Direcci�n postal
   ItemNew(5, "Ctry", 2, aData["CreditorCountry"])       // Pa�s
   ItemNew(5, "AdrLine", 70, aData["CreditorAdress"])       // Direcci�n en texto libre

   ItemNew(3, "CdtrAcct")                          // Cuenta del acreedor
   ItemNew(4, "Id")                             // Identificaci�n
   ItemNew(5, "IBAN", 34, aData["CreditorIban"])         // IBAN
// ItemNew(4, "Ccy", 3, aData["Ccy"])                 // Moneda 

   ItemNew(3, "CdtrAgt")                           // Entidad del acreedor
   ItemNew(4, "FinInstnId")                        // Identificaci�n de la entidad 
   ItemNew(5, "BIC", 11, aData["CreditorBic"])        // BIC 

   FieldNew(3, "UltmtCdtr")                        // �ltimo acreedor (6)

   ItemNew(3, "ChrgBr", 4, aData["ChrgBr"])           // Cl�usula de gastos (5)

   CreditItem(3, "CdtrSchmeId", aCreditor)               // Identificaci�n del acreedor

   ItemNew(3, "DrctDbtTxInf")                         // Informaci�n de la operaci�n de adeudo directo
   ItemNew(4, "PmtId")                          // Identificaci�n del pago  
   ItemNew(5, "InstrId", 35, aData["InstrId"])        // Identificaci�n de la instrucci�n
   ItemNew(5, "EndToEndId", 35, aData["EndToEndId"])     // Identificaci�n de extremo a extremo 
   ItemNew(4, "InstdAmt", 12, aData["InstdAmt"], .t.)       // Importe ordenado 
   /*
   ItemNew(4, "ChrgBr", 4, aData["ChrgBr"])           // Cl�usula de gastos (5)
   */
   ItemNew(4, "DrctDbtTx")                         // Operaci�n de adeudo directo 
   ItemNew(5, "MndtRltdInf")                       // Informaci�n del mandato 
   ItemNew(6, "MndtId", 35, aData["MndtId"])             // Identificaci�n del mandato 
   ItemNew(6, "DtOfSgntr", 8, aData["DtOfSgntr"])        // Fecha de firma 
   ItemNew(6, "AmdmntInd", 5, aData["AmdmntInd"])        // Indicador de modificaci�n 
   ItemNew(6, "AmdmntInfDtls")                     // Detalles de la modificaci�n 
   ItemNew(7, "OrgnlMndtId", 35, aData["OrgnlMndtId"])   // Identificaci�n del mandato original 

   CreditItem(7, "OrgnlCdtrSchmeId")                  // Identificaci�n del acreedor original  
   //CreditItem(7, "OrgnlCdtrSchmeId", nombre)           // Revisar !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

   ItemNew(7, "OrgnlDbtrAcct")                     // Cuenta del deudor original 
   ItemNew(8, "Id")                             // Identificaci�n 
   ItemNew(9, "IBAN", 34, aData["DebtorIban"])        // IBAN
   ItemNew(7, "OrgnlDbtrAgt")                         // Entidad del deudor original
   ItemNew(8, "FinInstnId")                        // Identificaci�n de la entidad 
   ItemNew(9, "Othr")                              // Otra 
   ItemNew(10,"Id", 35, aData["DebtorAgent"])            // Identificaci�n
   ItemNew(6, "ElctrncSgntr", 1025, aData["ElctrncSgntr"]) // Firma electr�nica

   CreditItem(5, "CdtrSchmeId", aCreditor)            // Identificaci�n del acreedor 

   FieldNew(4, "UltmtCdtr")                        // �ltimo acreedor (6)

   ItemNew(4, "DbtrAgt")                           // Entidad del deudor 
   ItemNew(5, "FinInstnId")                        // Identificaci�n de la entidad 
   ItemNew(6, "BIC", 11, aData["DebtorBic"])          // BIC 

   /* este grupo es algo distinto, comprobar */
   FieldNew(4, "Dbtr")                          // Deudor (6)

   ItemNew(4, "DbtrAcct")                          // Cuenta del deudor
   ItemNew(5, "Id")                             // Identificaci�n
   ItemNew(6, "IBAN", 34, aData["DebtorIban"])        // IBAN

   FieldNew(4, "UltmtDbtr")                        // �ltimo deudor (6)

   ItemNew(4, "Purp")                              // Prop�sito 
   ItemNew(5, "Cd", 4, aData["Purpose"])              // C�digo

   ItemNew(4, "RgltryRptg")                        // Informaci�n regulatoria
   ItemNew(5, "DbtCdtRptgInd", 4, aData["DbtCdtRptgInd"])   // Alcance de la informaci�n
   ItemNew(5, "Dtls")                              // Detalles
   ItemNew(6, "Cd", 3, aData["DtlsCode"])                // C�digo
   ItemNew(6, "Amt", 21, aData["Amt"], .t.)           // Importe
   ItemNew(6, "Inf", 35, aData["Inf"])                // Informaci�n

   ItemNew(4, "RmtInf")                            // Concepto
   ItemNew(5, "Ustrd", 140, aData["Ustrd"])           // No estructurado
   ItemNew(5, "Strd")                              // Estructurado
   ItemNew(6, "CdtrRefInf")                        // Referencia facilitada por el acreedor
   ItemNew(7, "Tp")                             // Tipo de referencia
   ItemNew(8, "CdOrPrtry")                         // C�digo o propietario
   ItemNew(9, "Cd", 4, aData["RefInf"])               // C�digo
   ItemNew(8, "Issr", 35, aData["Issr"])              // Emisor
   ItemNew(7, "Ref", 35, aData["Ref"])                // Referencia

return NIL

//--------------------------------------------------------------------------------------//

static function FieldNew( nLevel, cLabel, lType, nId )

   lType = If( lType == NIL, .f., lType )
   nId   = If( nId == NIL, ENTIDAD_OTRA, nId )

   ItemNew(nLevel, cLabel)                   // Parte iniciadora 
   ItemNew(nLevel +1, "Nm", 70)              // Nombre 
   ItemNew(nLevel +1, "Id")                  // Identificaci�n 

   if lType 
      ItemNew(nLevel +2, "OrgId")            // Persona jur�dica
   else  
      ItemNew(nLevel +2, "PrvtId")           // Persona f�sica 
   endif

   SWITCH nId

      CASE ENTIDAD_JURIDICA
         ItemNew(nLevel +3, "BICOrBEI", 11)     // BIC o BEI 

      CASE ENTIDAD_FISICA
         ItemNew(nLevel +3, "DtAndPlcOfBirth")  // Fecha y lugar de nacimiento 
         ItemNew(nLevel +4, "BirthDt", 8)       // Fecha de nacimiento 
         ItemNew(nLevel +4, "PrvcOfBirth", 35)  // Provincia de nacimiento
         ItemNew(nLevel +4, "CityOfBirth", 35)  // Ciudad de nacimiento 
         ItemNew(nLevel +4, "CtryOfBirth", 2)   // Pa�s de nacimiento

      OTHERWISE
         ItemNew(nLevel +3, "Othr")             // Otra 
         ItemNew(nLevel +4, "Id", 35)        // Identificaci�n 
         ItemNew(nLevel +4, "SchmeNm")          // Nombre del esquema 
         ItemNew(nLevel +5, "Cd", 4)         // C�digo 
         ItemNew(nLevel +5, "Prtry", 35)     // Propietario
         ItemNew(nLevel +4, "Issr", 35)         // Emisor 
   END

return NIL

//--------------------------------------------------------------------------------------//

static function ItemNew(nLevel, cLabel, nLen, xValue, lCurrency, hParent)

 local hItem

   if len(aItems) < nLevel
      aadd( aItems, {} )
   endif

   if hParent == NIL
      hParent := atail( aItems[nLevel -1] )
   endif

   hItem := mxmlNewElement( hParent, cLabel )

   if lCurrency != NIL
      mxmlElementSetAttr( hItem, "Ccy", "EUR" )
   endif

   if nLen != NIL
      mxmlNewText( hItem, 0, xValue )
      //mxmlNewText( hItem, 0, padR(xValue, nLen) )
   endif

   aadd( aItems[nLevel], hItem )

return NIL

//--------------------------------------------------------------------//

static function CreditItem(nLevel, cLabel, aInfo, cName)

   if aInfo != NIL
      if cName != NIL
         ItemNew(nLevel +1, "Nm", 70)           // Nombre  
      endif

      ItemNew(nLevel +1, "Id")                  // Identificaci�n  
      ItemNew(nLevel +2, "PrvtId")              // Identificaci�n privada  
      ItemNew(nLevel +3, "Othr")                   // Otra 
      ItemNew(nLevel +4, "Id", 35, aInfo["Id"])    // Identificaci�n 
      ItemNew(nLevel +4, "SchmeNm")                // Nombre del esquema 
      ItemNew(nLevel +5, "Prtry", 35, aInfo["Prtry"]) // Propietario 
   endif

return NIL

//--------------------------------------------------------------------//

FUNCTION type_cb( hNode )            

  local cText :=  mxmlGetText( hNode )
    
//  if ! Empty( mxmlGetFirstChild( hNode ) )  
//     OutStd( mxmlGetElement( hNode ), mxmlGetFirstChild( hNode ) )
//  endif

  if !empty( cText )
    OutStd( "element :", mxmlGetElement( hNode ), cText + hb_eol() )
  endif

return NIL