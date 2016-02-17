/* v.1.0 31/12/2013
 * SEPA ISO 20022 http://http://www.iso20022.org/
 * pain.008.001.02 Direct Debit Core y B2B 
 * pain.001.001.03 Credit Transfer 
 *
 * Para lenguaje Harbour - http://harbour-project.org
 * (c) Joaquim Ferrer Godoy <quim_ferrer@yahoo.es>
 *
 * Características :
 * Generacion de formato XML
 * Control de errores en campos requeridos
 * Verifica importes y numero total de efectos
 * 
 * Reglas de uso locales AEB:
 * (1) TRUE = Un apunte en cuenta por la suma de los importes de todas las operaciones del mensaje.
 *    FALSE= Un apunte en cuenta por cada una de las operaciones incluidas en el mensaje.
 * (2) FNAL=Último adeudo de una serie de adeudos recurrentes.
 *     FRST=Primer adeudo de una serie de adeudos recurrentes.
 *    OOFF=Adeudo correspondiente a una operación con un único pago(*).
 *    RCUR=Adeudo de una serie de adeudos recurrentes, cuando no se trata ni del primero ni del último.
 *    (*) Para este tipo de operaciones el mandato y su referencia deben ser únicos y no pueden utilizarse para operaciones 
 *    puntuales posteriores. Si siempre se factura a los mismos clientes, aunque varie el importe de los adeudos y la periodicidad
 *    de los mismos, es necesario utilizar el tipo de adeudo recurrente si se utiliza la misma referencia, creando para cada 
 *    cliente deudor un solo mandato que ampare todos los adeudos que se emitan. 
 *    El primer adeudo deberá ser FRST y los siguientes RCUR.
 * (3) Esta etiqueta sólo debe usarse cuando un mismo número de cuenta cubra diferentes divisas y el presentador 
 *       necesite identificar en cuál de estas divisas debe realizarse el asiento sobre su cuenta.
 * (4) Regla de uso: Solamente se admite el código ‘SLEV’
 * (5) La etiqueta ‘Cláusula de gastos’ puede aparecer, bien en el nodo ‘Información del pago’ (2.0), bien en el 
 *       nodo ‘Información de la operación de adeudo directo’ (2.28), pero solamente en uno de ellos. 
 *       Se recomienda que se recoja en el bloque ‘Información del pago’ (2.0).
 * (6) Regla de uso: Para el sistema de adeudos SEPA se utilizará exclusivamente la etiqueta 'Otra' estructurada 
 *    según lo definido en el epígrafe 'Identificador del presentador' de la sección 3.3 del cuaderno.
 * (7) Regla de uso: Solamente se admite el código 'SEPA'
 */

#include "hbclass.ch"
#include "hbmxml.ch"

#include "hbxml.ch"
#include "fileio.ch"

#define CRLF                  chr( 13 ) + chr( 10 )

#define SEPA_DIRECT_DEBIT     0
#define SEPA_CREDIT_TRANSFER  1

#define SEPA_SCHEME_CORE      0
#define SEPA_SCHEME_COR1      1
#define SEPA_SCHEME_B2B       2

#define ENTIDAD_JURIDICA      0
#define ENTIDAD_FISICA        1
#define ENTIDAD_OTRA          2

//--------------------------------------------------------------------------------------//

CLASS SepaXml

   DATA hXmlDoc

   DATA oXml
   DATA oXmlDocument
   DATA oXmlFinancial
   DATA oXmlHeader
   DATA oXmlPmtInf
   DATA oXmlPmtTpInf
   DATA oXmlSvcLvl
   DATA oXmlLclInstrm
   DATA oXmlCtgyPurp

   DATA FinancialMessage   AS CHARACTER   INIT "CstmrDrctDbtInitn" 
   DATA DocumentType       AS CHARACTER   INIT "pain.008.001.02" 

   DATA SchmeNm            AS CHARACTER   INIT "CORE"
   DATA cFileOut           
   DATA lMinified          AS LOGICAL     INIT .t.             // Documento compactado o con espacios y tabuladores
   DATA aErrors            AS ARRAY       INIT {}              // Control de errores
   DATA ErrorMessages      AS ARRAY       INIT {=>}            // Hash mensajes de error multilenguaje
   DATA aDebtors           AS ARRAY       INIT {}              // Lista de deudores

   DATA MsgId                                                  // Identificación del mensaje
   DATA CreDtTm                                                // Fecha y hora de creación
   DATA NbOfTxs            AS NUMERIC     INIT 0               // Número de operaciones 
   DATA CtrlSum            AS NUMERIC     INIT 0.00            // Control de suma

   DATA ServiceLevel       AS CHARACTER   INIT "SEPA"          // Código Nivel de servicio (7)
   DATA SeqTp              AS CHARACTER   INIT "OOFF"          // Tipo de secuencia (2)
   DATA PurposeCd                                              // Código categoria proposito
   DATA PurposePrtry                                           // Propietario categoria proposito

   DATA oInitPart
   DATA oCreditor
   DATA oUltimateCreditor
   DATA oDebtor
   DATA oUltimateDebtor

   METHOD New()
   METHOD setFinancialMessage( nFinancialMessage )
   METHOD setScheme( nScheme )

   METHOD CreateDocumentXML()
   METHOD CreateFinancialNode()  INLINE ( ::oXmlFinancial   := TXmlNode():new( , ::FinancialMessage ),;
                                          ::oXmlDocument:addBelow( ::oXmlFinancial ) )
   METHOD getTypePaymentXML()

   METHOD CalculateOperationsNumber()   

   METHOD ProcessDebtors()
   METHOD SaveDocumentXML()

   METHOD DebtorAdd( oDebtor )   INLINE aadd( ::aDebtors, oDebtor )

   METHOD GroupHeader()
   METHOD InfoPayment()
   METHOD DirectDebit()

   METHOD SetActor()
   METHOD SetActorOther()
   METHOD TypePayment()
   METHOD IdPayment()
   METHOD Creditor()
   METHOD IdCreditor()

   METHOD SetLanguage()
   METHOD Activate()
   METHOD End()               INLINE mxmlDelete( ::hXmlDoc )

   METHOD resetErrors()       INLINE ( ::aErrors := {} )
   METHOD addError( cError )  INLINE ( aadd( ::aErrors, cError ) )

ENDCLASS

//--------------------------------------------------------------------------------------//

METHOD New( cFileOut ) CLASS SepaXml

   ::cFileOut           := cFileOut
   ::CreDtTm            := IsoDateTime()  // Fecha y hora de creación

   ::oInitPart          := SepaDebitActor():New( Self, "InitgPty" )     
   ::oCreditor          := SepaDebitActor():New( Self )
   ::oUltimateCreditor  := SepaDebitActor():New( Self )
   ::oDebtor            := SepaDebitActor():New( Self )
   ::oUltimateDebtor    := SepaDebitActor():New( Self )

return Self

//--------------------------------------------------------------------------------------//

METHOD setFinancialMessage( nFinancialMessage ) CLASS SepaXml

   if nFinancialMessage == SEPA_DIRECT_DEBIT 
      ::FinancialMessage   := "CstmrDrctDbtInitn" 
      ::DocumentType       := "pain.008.001.02" 
   end if 

   if nFinancialMessage == SEPA_CREDIT_TRANSFER 
      ::FinancialMessage   := "CstmrCdtTrfInitn"  
      ::DocumentType       := "pain.001.001.03" 
   end if 

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD setScheme( nScheme ) CLASS SepaXml

   switch nScheme
      case SEPA_SCHEME_CORE  
         ::SchmeNm   := "CORE" ; exit
      case SEPA_SCHEME_COR1  
         ::SchmeNm   := "COR1" ; exit
      case SEPA_SCHEME_B2B   
         ::SchmeNm   := "B2B"  ; exit
      otherwise              
         ::SchmeNm   := "SEPA"
   end

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD GroupHeader( hParent ) CLASS SepaXml

   local hItem
   local lError   := .f.

   if empty( ::MsgId )
      ::addError( "Identificación del mensaje no puede estar vacio." )
      lError      := .t.
   endif

   if empty( ::CreDtTm )
      ::addError( "Fecha y hora de creación no puede estar vacio." )
      lError      := .t.
   endif

   if empty( ::NbOfTxs )
      ::addError( "Número de operaciones no puede estar vacia." )
      lError      := .t.
   endif

   if empty( ::CtrlSum )
      ::addError( "Control de suma no puede estar vacio." )
      lError      := .t.
   endif

   if !lError

      ::oXmlHeader   := TXmlNode():new( , "GrpHdr" )
         ::oXmlHeader:addBelow( TXmlParseNode():New( "MsgId", ::MsgId, 35 ) )         
         ::oXmlHeader:addBelow( TXmlParseNode():New( "CreDtTm", ::CreDtTm, 19 ) )         
         ::oXmlHeader:addBelow( TXmlParseNode():New( "NbOfTxs", str( ::NbOfTxs, 0 ), 15 ) )         
         ::oXmlHeader:addBelow( TXmlParseNode():New( "CtrlSum", ::CtrlSum, 18 ) )         

      ::oXmlFinancial:addBelow( ::oXmlHeader )                                          

      ::oXmlHeader:addBelow( ::oInitPart:getNodeXML() )

   endif 

Return ( nil )

//--------------------------------------------------------------------------------------//

METHOD SetActor( oParent, cLabel, oActor ) CLASS SepaXml

return nil

//--------------------------------------------------------------------------------------//

METHOD SetActorOther( hParent, oActor ) CLASS SepaXml

return nil

//--------------------------------------------------------------------------------------//

METHOD InfoPayment( hParent ) CLASS SepaXml
/*
Regla de uso: Las etiquetas ‘Último acreedor’, ‘Cláusula de gastos’ e ‘Identificación del acreedor’ pueden aparecer, 
bien en el nodo ‘Información del pago’ (2.0), bien en el nodo ‘Información de la operación de adeudo directo’ (2.28), 
pero solamente en uno de ellos. 
Se recomienda que se recojan en el bloque ‘Información del pago’ (2.0).
*/

   local hItem
 

   Return nil 

   if ::oDebtor:PmtInfId != nil .or.;
      ::oDebtor:PmtMtd != nil .or. ;
      ::oDebtor:BtchBookg != nil .or. ;
      ::oDebtor:NbOfTxs != nil .or. ;
      ::oDebtor:CtrlSum != nil .or. ;
      ::oDebtor:ReqdColltnDt != nil .or. ;
      ::oDebtor:ChrgBr != nil

                                                 // Identificación de la información del pago 

      ::IdCreditor( hItem )                                          // Identificación del acreedor
   endif

return hItem

//--------------------------------------------------------------------------------------//

METHOD DirectDebit( hParent ) CLASS SepaXml

 local hItem, hChild

   if ::oDebtor:InstdAmt > 0
      hItem := ItemNew(hParent, "DrctDbtTxInf")                      // Información de la operación de adeudo directo

      if ::oDebtor:InstrId != nil .or. ::oDebtor:EndToEndId != nil   
         hChild := ItemNew(hItem, "PmtId")                        // Identificación del pago  
         ItemNew(hChild, "InstrId", 35, ::oDebtor:InstrId)           // Identificación de la instrucción
         ItemNew(hChild, "EndToEndId", 35, ::oDebtor:EndToEndId)     // Identificación de extremo a extremo 
      endif

      ItemNew(hItem, "InstdAmt", 12, ::oDebtor:InstdAmt, .t.)        // Importe ordenado 

      if ::oDebtor:MndtId != nil .or. ::oDebtor:DtOfSgntr != nil 
         hChild := ItemNew(hItem, "DrctDbtTx")                    // Operación de adeudo directo 
         hChild := ItemNew(hChild, "MndtRltdInf")                 // Información del mandato 
         ItemNew(hChild, "MndtId", 35, ::oDebtor:MndtId)             // Identificación del mandato 
         ItemNew(hChild, "DtOfSgntr", 8, ::oDebtor:DtOfSgntr)        // Fecha de firma 
         
         if ::oDebtor:AmdmntInd != nil .and. ::oDebtor:OrgnlMndtId != nil
            ItemNew(hChild, "AmdmntInd", 5, ::oDebtor:AmdmntInd)     // Indicador de modificación 
            hChild := ItemNew(hChild, "AmdmntInfDtls")               // Detalles de la modificación 
            ItemNew(hChild, "OrgnlMndtId", 35, ::oDebtor:OrgnlMndtId)   // Identificación del mandato original 
         endif
      endif


      //CreditItem(7, "OrgnlCdtrSchmeId")                // Identificación del acreedor original  
      /*
      REVISAR !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      ItemNew(7, "OrgnlDbtrAcct")                     // Cuenta del deudor original 
      ItemNew(8, "Id")                             // Identificación 
      ItemNew(9, "IBAN", 34, aData["DebtorIban"])        // IBAN
      ItemNew(7, "OrgnlDbtrAgt")                         // Entidad del deudor original
      ItemNew(8, "FinInstnId")                        // Identificación de la entidad 
      ItemNew(9, "Othr")                              // Otra 
      ItemNew(10,"Id", 35, aData["DebtorAgent"])            // Identificación
      ItemNew(6, "ElctrncSgntr", 1025, aData["ElctrncSgntr"]) // Firma electrónica

      CreditItem(5, "CdtrSchmeId", aCreditor)            // Identificación del acreedor 

      FieldNew(4, "UltmtCdtr")                        // Último acreedor (6)
      */
    
      if ::oDebtor:BICOrBEI != nil
         hChild := ItemNew(hItem, "DbtrAgt")          // Entidad del deudor 
         hChild := ItemNew(hChild, "FinInstnId")      // Identificación de la entidad 
         ItemNew(hChild, "BIC", 11, ::oDebtor:BICOrBEI)  // BIC 
      else
         aadd( ::aErrors, ::ErrorMessages['SEPA_DEBTOR_AGENT'] )
      endif

      if ::oDebtor:Nm != nil                       // Requerido
         ::SetActor(hItem, "Dbtr", ::oDebtor )        // Deudor (6)
      else
         aadd( ::aErrors, ::ErrorMessages['SEPA_DEBTOR_NAME'] )
      endif

      if ::oDebtor:IBAN != nil 
         hChild := ItemNew(hItem, "DbtrAcct")         // Cuenta del deudor
         hChild := ItemNew(hChild, "Id")           // Identificación
         ItemNew(hChild, "IBAN", 34, ::oDebtor:IBAN)  // IBAN
      else
         aadd( ::aErrors, ::ErrorMessages['SEPA_DEBTOR_ACCOUNT'] )
      endif

      if ::oUltimateDebtor:Nm != nil                  // Opcional o Requerido ?
         ::SetActor(hItem, "UltmtDbtr", ::oUltimateDebtor)     // Último deudor (6)
      endif

      if ::PurposeCd != nil
         hChild := ItemNew(hItem, "Purp")                   // Propósito 
         ItemNew(hChild, "Cd", 4, ::PurposeCd)              // Código
      endif

      /* Bloque solo a efectos estadisticos, para obligados en Balanza de Pagos
      REVISAR !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      ItemNew(4, "RgltryRptg")                        // Información regulatoria
      ItemNew(5, "DbtCdtRptgInd", 4, aData["DbtCdtRptgInd"])   // Alcance de la información
      ItemNew(5, "Dtls")                              // Detalles
      ItemNew(6, "Cd", 3, aData["DtlsCode"])                // Código
      ItemNew(6, "Amt", 21, aData["Amt"], .t.)           // Importe
      ItemNew(6, "Inf", 35, aData["Inf"])                // Información
      */

      if ::oDebtor:Info != nil
         hChild := ItemNew(hItem, "RmtInf")                 // Concepto
         ItemNew(hChild, "Ustrd", 140, ::oDebtor:Info)         // No estructurado
      endif

      /* Bloque para informacion estructurada
      REVISAR !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      ItemNew(5, "Strd")                              // Estructurado
      ItemNew(6, "CdtrRefInf")                        // Referencia facilitada por el acreedor
      ItemNew(7, "Tp")                             // Tipo de referencia
      ItemNew(8, "CdOrPrtry")                         // Código o propietario
      ItemNew(9, "Cd", 4, aData["RefInf"])               // Código
      ItemNew(8, "Issr", 35, aData["Issr"])              // Emisor
      ItemNew(7, "Ref", 35, aData["Ref"])                // Referencia
      */
   else
      // Error
   endif

return nil

//--------------------------------------------------------------------------------------//
// Generar identificador de pago, a partir del mensaje 

METHOD IdPayment( hItem ) CLASS SepaXml

return nil

//--------------------------------------------------------------------------------------//

METHOD TypePayment( hParent ) CLASS SepaXml

 local hItem, hChild

   hItem := ItemNew(hParent, "PmtTpInf")                 // Información del tipo de pago 

   hChild := ItemNew(hItem, "SvcLvl")                    // Nivel de servicio 
   ItemNew(hChild, "Cd", 4, ::ServiceLevel)              // Código Nivel de servicio

   hChild := ItemNew(hItem, "LclInstrm")                 // Instrumento local  
   ItemNew(hChild, "Cd", 35, ::SchmeNm)                  // Código Instrumento local

   ItemNew(hItem, "SeqTp", 4, ::SeqTp)                   // Tipo de secuencia

   /* Lista de códigos recogidos en la norma ISO 20022 
      Ex: CASH=CashManagementTransfer (Transaction is a general cash management instruction) */
   if ::PurposeCd != nil
      hChild := ItemNew(hItem, "CtgyPurp")               // Categoría del propósito 
      ItemNew(hChild, "Cd", 4, ::PurposeCd)              // Código 
      ItemNew(hChild, "Prtry", 35, ::PurposePrtry)          // Propietario
   endif

return nil

//--------------------------------------------------------------------------------------//

METHOD Creditor( hParent ) CLASS SepaXml

 local hItem

   if ::oCreditor:Nm != nil
      hItem := ItemNew(hParent, "Cdtr")                     // Acreedor 
      ItemNew(hItem, "Nm", 70, ::oCreditor:Nm)              // Nombre 

      if ::oCreditor:Ctry != nil .or. ::oCreditor:AdrLine1 != nil
         hItem := ItemNew(hItem, "PstlAdr")                 // Dirección postal
         ItemNew(hItem, "Ctry", 2, ::oCreditor:Ctry)        // País
         ItemNew(hItem, "AdrLine", 70, ::oCreditor:AdrLine1)   // Dirección en texto libre
         ItemNew(hItem, "AdrLine", 70, ::oCreditor:AdrLine2)   // Dirección en texto libre
      else
         // Error
         //aadd( ::aErrors, ::aMessages['creditor_does_not_exist'] )
      endif
   else
      // Error
   endif

   if ::oCreditor:IBAN != nil
      hItem := ItemNew(hParent, "CdtrAcct")                 // Cuenta del acreedor
   // ItemNew(hItem, "Ccy", 3, aData["Ccy"])                   // Moneda 
      hItem := ItemNew(hItem, "Id")                         // Identificación
      ItemNew(hItem, "IBAN", 34, ::oCreditor:IBAN)             // IBAN
   else
      // Error
   endif

   if ::oCreditor:BIC != nil
      hItem := ItemNew(hParent, "CdtrAgt")                  // Entidad del acreedor
      hItem := ItemNew(hItem, "FinInstnId")                 // Identificación de la entidad 
      ItemNew(hItem, "BIC", 11, ::oCreditor:BIC)               // BIC
   else
      // Error
   endif 

return nil

//--------------------------------------------------------------------------------------//

METHOD IdCreditor( hParent ) CLASS SepaXml

   local hItem

   if ::oCreditor:Id != nil
      hItem := ItemNew(hParent, "CdtrSchmeId")              // Identificación del acreedor 
      hItem := ItemNew(hItem, "Id")                         // Identificación  
      hItem := ItemNew(hItem, "PrvtId")                     // Identificación privada  
      hItem := ItemNew(hItem, "Othr")                    // Otra 

      ItemNew(hItem, "Id", 35, ::oCreditor:Id)              // Identificación 

      if ::oCreditor:Prtry != nil
         hItem := ItemNew(hItem +4, "SchmeNm")              // Nombre del esquema 
         ItemNew(hItem, "Prtry", 35, ::oCreditor:Prtry)        // Propietario 
      endif
   else
      // Error
   endif

return nil

//--------------------------------------------------------------------------------------//

METHOD SetLanguage() CLASS SepaXml

   ::ErrorMessages['SEPA_DEBTOR_AGENT']      := "La entidad del cliente no existe"
   ::ErrorMessages['SEPA_DEBTOR_NAME']       := "El nombre del deudor no existe"
   ::ErrorMessages['SEPA_DEBTOR_ACCOUNT']    := "La cuenta del deudor no existe"

return nil

//--------------------------------------------------------------------------------------//

METHOD Activate() CLASS SepaXml

   local hItem, oDebtor

   ::SetLanguage()

   ::ResetErrors()

   ::CalculateOperationsNumber()

   ::CreateDocumentXML()

   ::CreateFinancialNode()

   ::GroupHeader()                                               // Cabecera

   ::ProcessDebtors()

   ::SaveDocumentXML()

   // ::End()

return nil

//--------------------------------------------------------------------------------------//

METHOD CreateDocumentXML()

   ::oXml            := TXmlDocument():new( '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' )

   ::oXmlDocument    := TXmlNode():new( , "Document", { "xmlns" => "urn:iso:std:iso:20022:tech:xsd:" + ::DocumentType } )
   ::oXml:oRoot:addBelow( ::oXmlDocument )   

return ( nil )

//--------------------------------------------------------------------------------------//

METHOD SaveDocumentXML()

   local fileHandle

   ferase( ::cFileOut )

   fileHandle       := fCreate( ::cFileOut )

   ::oXml:Write( fileHandle, HBXML_STYLE_NONEWLINE )

   fClose( fileHandle )

return nil

//--------------------------------------------------------------------------------------//
// Comprobar numero de operaciones y suma total de importes

METHOD CalculateOperationsNumber()

   local oDebtor

   for each oDebtor in ::aDebtors
      ::NbOfTxs   += 1
      ::CtrlSum   += oDebtor:InstdAmt
   next

return nil

//--------------------------------------------------------------------------------------//
/*
La informacion del pago puede incluir varios adeudos por fecha de cobro
Aqui se asume fecha de cobro distinta para cada adeudo, no realizando agrupacion.
*/

METHOD ProcessDebtors( hItem )

   local oDebtor

   for each oDebtor in ::aDebtors
      
      ::oDebtor            := __objClone( oDebtor )
      ::oDebtor:NbOfTxs    := 1
      ::oDebtor:CtrlSum    := oDebtor:InstdAmt
      ::oDebtor:PmtInfId   := alltrim( ::MsgId ) + "-" + strzero( ::oDebtor:NbOfTxs, 4)

      ::oXmlPmtInf         := ::oDebtor:getInfoPaymentXML()
         ::oXmlPmtInf:addBelow( ::getTypePaymentXML() )

         ::oXmlPmtInf:addBelow( ::oDebtor:getRquiredPayDateXML() )

         ::oXmlPmtInf:addBelow( ::oDebtor:getCreditorXML() )

         ::oXmlPmtInf:addBelow( ::oDebtor:getCreditorIBANXML() )

         ::oXmlPmtInf:addBelow( ::oDebtor:getCreditorBICXML() )

         ::oXmlPmtInf:addBelow( ::oDebtor:getChrgBrXML() )

         ::oXmlPmtInf:addBelow( ::oDebtor:getIdCreditorXML() )

         ::oXmlPmtInf:addBelow( ::oDebtor:getDirectDebitTransactionInformationXml() )

      ::oXmlFinancial:addBelow( ::oXmlPmtInf )


      // ::DirectDebit( hItem )                                            // Adeudo individual
   next

return nil

//--------------------------------------------------------------------------------------//

METHOD getTypePaymentXML() 

   ::oXmlPmtTpInf       := TXmlNode():New( , "PmtTpInf")                         // Información del tipo de pago 

      ::oXmlSvcLvl      := TXmlNode():New( , "SvcLvl")                           // Nivel de servicio 
      ::oXmlSvcLvl:addBelow( TXmlParseNode():New( "Cd", ::ServiceLevel, 4 ) )

   ::oXmlPmtTpInf:addBelow( ::oXmlSvcLvl )

      ::oXmlLclInstrm   := TXmlNode():New( , "LclInstrm" )                    // Instrumento local
      ::oXmlLclInstrm:addBelow( TXmlParseNode():New( "Cd", ::SchmeNm, 35 ) )  // Código Instrumento local

   ::oXmlPmtTpInf:addBelow( ::oXmlLclInstrm )

   ::oXmlPmtTpInf:addBelow( TXmlParseNode():New( "SeqTp", ::SeqTp, 4 ) )        // Tipo de secuencia

   // Lista de códigos recogidos en la norma ISO 20022----------------------------------- 
   // Ex: CASH=CashManagementTransfer (Transaction is a general cash management instruction) 

   if ::PurposeCd != nil
   
      ::oXmlCtgyPurp    := TXmlNode():New( , "CtgyPurp" )                                       // Categoría del propósito 
      ::oXmlCtgyPurp:addBelow( TXmlParseNode():New( "Cd", ::PurposeCd, 4 ) )            // Código 
      ::oXmlCtgyPurp:addBelow( TXmlParseNode():New( "Prtry", ::PurposePrtry, 35 ) )     // Propietario

      ::oXmlPmtTpInf:addBelow( ::oXmlCtgyPurp )

   endif

Return ( ::oXmlPmtTpInf )

//--------------------------------------------------------------------------------------//

CLASS SepaDebitActor

   DATA oSender
   DATA cName

   DATA nEntity

   DATA Nm                                   // Nombre
   DATA Ctry                                    // Pais
   DATA AdrLine1                                // Dirección en texto libre
   DATA AdrLine2                                // Se permiten 2 etiquetas para direccion
   DATA IBAN                                    // IBAN
   DATA BIC                                  // BIC
   DATA BICOrBEI                                // BIC o BEI 
   DATA BirthDt                                 // Fecha de nacimiento 
   DATA PrvcOfBirth                             // Provincia de nacimiento
   DATA CityOfBirth                             // Ciudad de nacimiento 
   DATA CtryOfBirth                             // País de nacimiento
   DATA Id                                      // Identificación 
   DATA Issr                                    // Emisor 
   DATA Cd                                   // Codigo
   DATA Prtry           AS CHARACTER INIT "SEPA"  // Propietario

   DATA PmtInfId                                // Identificación de la información del pago 
   DATA BtchBookg       AS CHARACTER INIT "false"         // Indicador de apunte en cuenta (1)
   DATA ReqdColltnDt                               // Fecha de cobro (Vencimiento)
   DATA Info                                    // Informacion no estructurada, p.e., concepto del cobro
   DATA NbOfTxs         AS NUMERIC INIT 0             // Número de operaciones 
   DATA CtrlSum         AS NUMERIC INIT 0.00             // Control de suma 
   DATA PmtMtd          AS CHARACTER INIT "DD"   READONLY   // Método de pago Regla de uso: Solamente se admite el código ‘DD’
   DATA ChrgBr          AS CHARACTER INIT "SLEV" READONLY   // Cláusula de gastos (4)
   DATA InstrId                                 // Identificación de la instrucción
   DATA EndToEndId                              // Identificación de extremo a extremo 
   DATA InstdAmt        AS NUMERIC INIT 0.00             // Importe ordenado 
   DATA MndtId                                  // Identificación del mandato 
   DATA DtOfSgntr                               // Fecha de firma 
   DATA AmdmntInd                                  // Indicador de modificación 
   DATA OrgnlMndtId                             // Identificación del mandato original 

   DATA oXmlActor
   DATA oXmlId
   DATA oXmlOrgId
   DATA oXmlOthr
   DATA oXmlSchmeNm
   DATA oXmlPrvId
   DATA oXmlDtAndPlcOfBirth
   DATA oXmlPmtInf
   DATA oXmlCdrt
   DATA oXmlPstlAdr
   DATA oXmlCdtrAcct
   DATA oXmlIdIBAN
   DATA oXmlCdtrAgt
   DATA oXmlFinInstnId
   DATA oXmlCdtrSchmeId
   DATA oXmlDrctDbtTxInf

   METHOD New()

   METHOD getNodeXML()
   METHOD getOtherNodeXML()
   METHOD getInfoPaymentXML()
   METHOD getRquiredPayDateXML()    INLINE ( TXmlParseNode():New( "ReqdColltnDt", ::ReqdColltnDt, 10 ) )
   METHOD getCreditorXML()
   METHOD getCreditorIBANXML()
   METHOD getCreditorBICXML()
   METHOD getChrgBrXML()            INLINE ( TXmlParseNode():New( "ChrgBr", ::ChrgBr, 4 ) )
   METHOD getIdCreditorXML()
   METHOD getDirectDebitTransactionInformationXml()

ENDCLASS

//--------------------------------------------------------------------------------------//

METHOD New( oSender, cName ) CLASS SepaDebitActor

   ::oSender   := oSender
   ::cName     := cName

Return ( Self )

//--------------------------------------------------------------------------------------//

METHOD getNodeXML() CLASS SepaDebitActor

   ::oXmlActor       := TXmlNode():new( , ::cName ) 
   ::oXmlActor:addBelow( TXmlParseNode():New( "Nm", ::Nm, 70 ) )

   ::oXmlId          := TXmlNode():new( , "Id" )                               // Identificación 
      ::oXmlActor:addBelow( ::oXmlId )

   do case
   case ( ::nEntity == ENTIDAD_JURIDICA )

      ::oXmlOrgId    := TXmlNode():new( , "OrgId" )                          // Persona jurídica

      if !empty( ::BICOrBEI )
         ::oXmlOrgId:addBelow( TXmlParseNode():New( "BICOrBEI", ::BICOrBEI, 11 ) )         // BIC o BEI 
      else 
         ::oSender:addError( "BIC o BEI no puede estar vacio." )
      end if 

      ::oXmlId:addBelow( ::oXmlOrgId )

      ::getOtherNodeXML() 

   case ( ::nEntity == ENTIDAD_FISICA )

      ::oXmlPrvId    := TXmlNode():New( , "PrvtId" )

         ::oXmlDtAndPlcOfBirth    := TXmlNode():New( , "DtAndPlcOfBirth" )
         ::oXmlDtAndPlcOfBirth:addBelow( TXmlParseNode():New( "BirthDt", ::BirthDt, 8 ) )
         ::oXmlDtAndPlcOfBirth:addBelow( TXmlParseNode():New( "PrvcOfBirth", ::PrvcOfBirth, 35 ) )
         ::oXmlDtAndPlcOfBirth:addBelow( TXmlParseNode():New( "CityOfBirth", ::CityOfBirth, 35 ) )
         ::oXmlDtAndPlcOfBirth:addBelow( TXmlParseNode():New( "CtryOfBirth", ::CtryOfBirth, 2 ) )

      ::oXmlPrvId:addBelow( ::oXmlDtAndPlcOfBirth )            

      ::getOtherNodeXML() 

   otherwise 

      ::oSender:addError( "No se ha especificado el tipo de entidad juridica o física." )

   end case

Return ( ::oXmlActor )

//--------------------------------------------------------------------------------------//

METHOD getOtherNodeXML() CLASS SepaDebitActor

   if empty( ::Id )
      Return ( nil )
   end if 

   ::oXmlOthr        := TXmlNode():new( , "Othr" ) 
   ::oXmlOthr:addBelow( TXmlParseNode():New( "Id", ::Id, 35 ) )

      ::oXmlSchmeNm  := TXmlNode():new( , "SchmeNm" )
         ::oXmlSchmeNm:addBelow( TXmlParseNode():New( "Cd", ::Cd, 4 ) ) 
         ::oXmlSchmeNm:addBelow( TXmlParseNode():New( "Prtry", ::Prtry, 35 ) ) 

   ::oXmlOthr:addBelow( ::oXmlSchmeNm )

   ::oXmlOthr:addBelow( TXmlParseNode():New( "Issr", ::Issr, 35 ) )

   ::oXmlOrgId:addBelow( ::oXmlOthr )

Return ( nil )

//--------------------------------------------------------------------------------------//

METHOD getInfoPaymentXML() CLASS SepaDebitActor

   ::oXmlPmtInf      := TXmlNode():New( , "PmtInf" )
   ::oXmlPmtInf:addBelow( TXmlParseNode():New( "PmtInfId", ::PmtInfId, 35 ) )
   ::oXmlPmtInf:addBelow( TXmlParseNode():New( "PmtMtd", ::PmtMtd, 2 ) )
   ::oXmlPmtInf:addBelow( TXmlParseNode():New( "BtchBookg", ::BtchBookg, 5 ) )
   ::oXmlPmtInf:addBelow( TXmlParseNode():New( "NbOfTxs", ::NbOfTxs, 15 ) )
   ::oXmlPmtInf:addBelow( TXmlParseNode():New( "CtrlSum", ::CtrlSum, 18 ) )

Return ( ::oXmlPmtInf )

//--------------------------------------------------------------------------------------//

METHOD getCreditorXML()

   ::oXmlCdrt     := TXmlNode():New( , "Cdtr" )

   if ::Nm != nil

      ::oXmlCdrt:addBelow( TXmlParseNode():New( "Nm", ::Nm, 70 ) )

      if ::Ctry != nil .or. ::AdrLine1 != nil
         ::oXmlPstlAdr  := TXmlNode():New( , "PstlAdr" )                               // Dirección postal
         ::oXmlPstlAdr:addBelow( TXmlParseNode():New( "Ctry", ::oCtry, 2 ) )           // País
         ::oXmlPstlAdr:addBelow( TXmlParseNode():New( "AdrLine", ::AdrLine1, 70 ) )    // Dirección en texto libre
         ::oXmlPstlAdr:addBelow( TXmlParseNode():New( "AdrLine", ::AdrLine2, 70 ) )    // Dirección en texto libre
      endif

   else
      ::oSender:addError( "Nombre del acreedor no existe" )
   endif

Return ( ::oXmlCdrt )

//--------------------------------------------------------------------------------------//

METHOD getCreditorIBANXML()

   ::oXmlCdtrAcct    := TXmlNode():New( , "CdtrAcct" )

   if ::IBAN != nil
      ::oXmlIdIBAN   := TXmlNode():New( , "Id" )
         ::oXmlIdIBAN:addBelow( TXmlParseNode():New( "IBAN", ::IBAN, 34 ) )

      ::oXmlCdtrAcct:addBelow( ::oXmlIdIBAN )
   else
      ::oSender:addError( "IBAN del acreedor no existe" )
   endif

Return ( ::oXmlCdtrAcct )

//--------------------------------------------------------------------------------------//

METHOD getCreditorBICXML()

   ::oXmlCdtrAgt        := TXmlNode():New( , "CdtrAgt" )

   if ::BICOrBEI != nil
      ::oXmlFinInstnId  := TXmlNode():New( , "FinInstnId" )
         ::oXmlFinInstnId:addBelow( TXmlParseNode():New( "BIC", ::BICOrBEI, 11 ) )

      ::oXmlCdtrAgt:addBelow( ::oXmlFinInstnId )
   else
      ::oSender:addError( "BIC del acreedor no existe" )
   endif

Return ( ::oXmlCdtrAgt )

//--------------------------------------------------------------------------------------//

METHOD getIdCreditorXML()

   local oXmlId
   local oXmlPrvtId
   local oXmlOthr
   local oXmlSchmeNm

   ::oXmlCdtrSchmeId    := TXmlNode():New( , "CdtrSchmeId" )

   if ::Id != nil
      oXmlId            := TXmlNode():New( , "Id" )
   
         oXmlPrvtId     := TXmlNode():New( , "PrvtId" ) 

            oXmlOthr    := TXmlNode():New( , "Othr" ) 
            oXmlOthr:addBelow( TXmlParseNode():New( "Id", ::Id, 35 ) )    

            if ::Prtry != nil
               oXmlSchmeNm    := TXmlNode():New( , "SchmeNm" )                      // Nombre del esquema 
               oXmlSchmeNm:addBelow( TXmlParseNode():New( "Prtry", ::Prtry, 35 ) )  // Propietario 

               oXmlOthr:addBelow( oXmlSchmeNm )
            endif

         oXmlPrvtId:addBelow( oXmlOthr )

      oXmlId:addBelow( oXmlPrvtId )

      ::oXmlCdtrSchmeId:addBelow( oXmlId )

   else
      ::oSender:addError( "Identificador del acreedor no existe" )
   end if 

Return ( ::oXmlCdtrSchmeId )

//--------------------------------------------------------------------------------------//

METHOD getDirectDebitTransactionInformationXml()

   local oXmlPmtId

   ::oXmlDrctDbtTxInf   := TXmlNode():New( , "DrctDbtTxInf" )

   if ::InstdAmt > 0

      if ::InstrId != nil .or. ::EndToEndId != nil

         oXmlPmtId      := TXmlNode():New( , "PmtId")                                  // Identificación del pago  
         oXmlPmtId:addBelow( TXmlParseNode():New( "InstrId", ::InstrId, 35 ) )         // Identificación de la instrucción
         oXmlPmtId:addBelow( TXmlParseNode():New( "EndToEndId", ::EndToEndId, 35 ) )   // Identificación de extremo a extremo 

         ::oXmlDrctDbtTxInf:addBelow( oXmlPmtId )

      endif

      ::oXmlDrctDbtTxInf:addBelow( TXmlParseNode():New( "InstdAmt", ::InstdAmt, 12, .t. ) )  // Importe ordenado

      if ::MndtId != nil .or. ::DtOfSgntr != nil 

         oXmlDrctDbtTx        := TXmlNode():New( , "DrctDbtTx" )                             // Operación de adeudo directo 
            oXmlMndtRltdInf   := TXmlNode():New( , "MndtRltdInf" )                           // Información del mandato 
            oXmlMndtRltdInf:addBelow( TXmlParseNode():New( "MndtId", ::MndtId, 35 ) )        
            oXmlMndtRltdInf:addBelow( TXmlParseNode():New( "DtOfSgntr", ::DtOfSgntr, 8 ) )   // Fecha de firma 

               oXmlAmdmntInd  := TXmlParseNode():New( "AmdmntInd", ::AmdmntInd, 5 )

               // aki me quedo

            oXmlMndtRltdInf:addBelow( TXmlParseNode():New( "AmdmntInd", ::AmdmntInd, 5 ) )   // Indicador de modificación

         if ::oDebtor:AmdmntInd != nil .and. ::oDebtor:OrgnlMndtId != nil
            hChild := ItemNew(hChild, "AmdmntInfDtls")               // Detalles de la modificación 
            ItemNew(hChild, "OrgnlMndtId", 35, ::oDebtor:OrgnlMndtId)   // Identificación del mandato original 
         endif
      endif


      /*

      if ::oDebtor:BICOrBEI != nil
         hChild := ItemNew(hItem, "DbtrAgt")          // Entidad del deudor 
         hChild := ItemNew(hChild, "FinInstnId")      // Identificación de la entidad 
         ItemNew(hChild, "BIC", 11, ::oDebtor:BICOrBEI)  // BIC 
      else
         aadd( ::aErrors, ::ErrorMessages['SEPA_DEBTOR_AGENT'] )
      endif

      if ::oDebtor:Nm != nil                       // Requerido
         ::SetActor(hItem, "Dbtr", ::oDebtor )        // Deudor (6)
      else
         aadd( ::aErrors, ::ErrorMessages['SEPA_DEBTOR_NAME'] )
      endif

      if ::oDebtor:IBAN != nil 
         hChild := ItemNew(hItem, "DbtrAcct")         // Cuenta del deudor
         hChild := ItemNew(hChild, "Id")           // Identificación
         ItemNew(hChild, "IBAN", 34, ::oDebtor:IBAN)  // IBAN
      else
         aadd( ::aErrors, ::ErrorMessages['SEPA_DEBTOR_ACCOUNT'] )
      endif

      if ::oUltimateDebtor:Nm != nil                  // Opcional o Requerido ?
         ::SetActor(hItem, "UltmtDbtr", ::oUltimateDebtor)     // Último deudor (6)
      endif

      if ::PurposeCd != nil
         hChild := ItemNew(hItem, "Purp")                   // Propósito 
         ItemNew(hChild, "Cd", 4, ::PurposeCd)              // Código
      endif

      if ::oDebtor:Info != nil
         hChild := ItemNew(hItem, "RmtInf")                 // Concepto
         ItemNew(hChild, "Ustrd", 140, ::oDebtor:Info)         // No estructurado
      endif
      */

   else
      // Error
   endif

Return ( ::oXmlDrctDbtTxInf )

//--------------------------------------------------------------------//

CLASS TXmlParseNode FROM TXmlNode

   METHOD New()

ENDCLASS

//--------------------------------------------------------------------------------------//

METHOD new( cName, xValue, nLen, lCurrency ) CLASS TXmlParseNode

   local cType 
   local cData
   local hAttributes

   if nLen == nil
      nLen        := 0
   end if 

   cType          := valtype( xValue )

   do case
   case cType == "N"
      cData       := ltrim( str( xValue, nLen, 2 ) )
   case cType == "D"
      cData       := sDate( xValue )
   case cType == "C"
      if nLen != 0
         cData    := alltrim( padr( xValue, nLen ) )
      else
         cData    := alltrim( xValue )
      end if
   end case

   if lCurrency != nil
      hAttributes := { "Ccy" => "EUR" }
   endif

   ::Super:New( , cName, hAttributes, cData )

Return ( Self )

//--------------------------------------------------------------------//

static function ItemNew(hParent, cLabel, nLen, xValue, lCurrency)

 local hItem, cType 

   if nLen != nil 
      if xValue != nil

         hItem := mxmlNewElement( hParent, cLabel )
         cType := valtype(xValue)

         if cType == "N"
            xValue := ltrim( str(xValue, nLen, 2) )
         elseif cType == "D"
            xValue := sDate(xValue)
         endif

         // mxmlNewText( hItem, 0, xValue )
         mxmlNewText( hItem, 0, alltrim( padr( xValue, nLen ) ) )
      endif
   else
      hItem := mxmlNewElement( hParent, cLabel )
   endif

   if hItem != nil .and. lCurrency != nil
      mxmlElementSetAttr( hItem, "Ccy", "EUR" )
   endif

return hItem

//--------------------------------------------------------------------//

static function WhiteSpace( hNode, nWhere )  
return If(nWhere == MXML_WS_AFTER_OPEN .or. nWhere == MXML_WS_AFTER_CLOSE, hb_eol(), nil)

//--------------------------------------------------------------------//

/* v.1.0 14/11/2013
 * Funciones misceláneas de apoyo a formatos SEPA
 * (c) Joaquim Ferrer Godoy <quim_ferrer@yahoo.es>
 */

function cTime()
   local strTime := time()
   strTime := substr(strTime,1,2) + substr(strTime,4,2) + substr(strTime,7,2)
return strTime


function fDate( d )
   local cDateFrm := Set( 4, "yyyy/mm/dd" )
   local strDate  := If( d != nil, dtos(d), dtos(date()) )
   Set( 4, cDateFrm )
return( strDate )


function sDate( d )
   local cDateFrm := Set( 4, "yyyy-mm-dd" )
   local strDate  := If( d != nil, dtoc(d), dtoc(date()) )
   Set( 4, cDateFrm )
return( strDate )


function Dec2Str(nVal, nLen)
   local strVal
   strVal := str( nVal, nLen +1, 2 )     // +1 espacio que resta punto decimal
   strVal := strtran( strVal, "." )      // Quitar punto decimal
   strVal := strtran( strVal, " ", "0" ) // Reemplazar espacios por 0
return( strVal )


function IsoDateTime()
return( sDate() +"T"+ time() )     // YYYY-MM-DDThh:mm:ss


function OutFile(nHandle, a)
   local strRec := ""
   aeval( a, {|e|  strRec += e } )
   fwrite(nHandle, strRec + CRLF)
return nil


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
 local cId, n, nLen, cValue
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


function id_File( cRef )
/*
Identificación del fichero: referencia que asigna el presentador al fichero, para su envío a la entidad receptora. 
Esta referencia se estructurará de la siguiente manera, tomando los datos generados por el ordenador del presentador 
en el momento de la creación del fichero: 
   Indicador del tipo de mensaje (3 caracteres) -> PRE Fichero de Presentación de adeudos 
    AAAAMMDD (año, mes y día) = (8 caracteres) 
    HHMMSSmmmmm (hora minuto segundo y 5 posiciones de milisegundos = 11 caracteres) 
    Referencia identificativa que asigne el presentador (13 caracteres) 
*/
   local cId   := "PRE" + fDate() + cTime() + strzero( seconds(), 5 ) + cRef

return padR(cId, 35)


