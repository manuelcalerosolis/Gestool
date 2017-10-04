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

   METHOD DebtorAdd(oDebtor)     INLINE aadd( ::aDebtors, oDebtor )

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

   ::oInitPart          := SepaDebitActor():New()     
   ::oCreditor          := SepaDebitActor():New()
   ::oUltimateCreditor  := SepaDebitActor():New()
   ::oDebtor            := SepaDebitActor():New()
   ::oUltimateDebtor    := SepaDebitActor():New()

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

   if empty( ::oInitPart:Nm )                               // Nombre presentador
      ::addError( "Nombre de presentador no puede estar vacio." )
      lError      := .t.
   endif

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
      hItem       := ItemNew( hParent, "GrpHdr" )           // Cabecera

      ItemNew( hItem, "MsgId",   35, ::MsgId )              // Identificación del mensaje
      ItemNew( hItem, "CreDtTm", 19, ::CreDtTm )            // Fecha y hora de creación
      ItemNew( hItem, "NbOfTxs", 15, str( ::NbOfTxs, 0 ) )  // Número de operaciones 
      ItemNew( hItem, "CtrlSum", 18, ::CtrlSum )            // Control de suma
      
      ::SetActor( hItem, "InitgPty", ::oInitPart )          // Parte iniciadora (6)
   endif 

Return ( nil )

//--------------------------------------------------------------------------------------//

METHOD InfoPayment( hParent ) CLASS SepaXml
/*
Regla de uso: Las etiquetas ‘Último acreedor’, ‘Cláusula de gastos’ e ‘Identificación del acreedor’ pueden aparecer, 
bien en el nodo ‘Información del pago’ (2.0), bien en el nodo ‘Información de la operación de adeudo directo’ (2.28), 
pero solamente en uno de ellos. 
Se recomienda que se recojan en el bloque ‘Información del pago’ (2.0).
*/
 
   local hItem

   if ::oDebtor:PmtInfId != nil .or.;
      ::oDebtor:PmtMtd != nil .or. ;
      ::oDebtor:BtchBookg != nil .or. ;
      ::oDebtor:NbOfTxs != nil .or. ;
      ::oDebtor:CtrlSum != nil .or. ;
      ::oDebtor:ReqdColltnDt != nil .or. ;
      ::oDebtor:ChrgBr != nil

      hItem       := ItemNew( hParent, "PmtInf")                      // Información del pago 

      ::IdPayment( hItem )                                           // Identificación de la información del pago 

      ::TypePayment( hItem )                                         // Información del tipo de pago 

      ItemNew( hItem, "ReqdColltnDt", 8, ::oDebtor:ReqdColltnDt )    // Fecha de cobro (Vencimiento)

      ::Creditor( hItem )                                            // Datos Acreedor, Cuenta, Entidad

      if ::oUltimateCreditor:Nm != nil                               // Opcional, Último acreedor (6)
         ::SetActor( hItem, "UltmtCdtr", ::oUltimateCreditor )   
      endif                                                          // No produce error, es opcional

      ItemNew( hItem, "ChrgBr", 4, ::oDebtor:ChrgBr )                // Cláusula de gastos (5)

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

METHOD SetActor( hParent, cLabel, oActor ) CLASS SepaXml

   local hItem 
   local hChild

   hItem    := ItemNew( hParent, cLabel )                           // Actor
   ItemNew( hItem, "Nm", 70, oActor:Nm )                            // Nombre 

   hItem    := ItemNew( hItem, "Id" )                               // Identificación 

   do case
   case ( oActor:nEntity == ENTIDAD_JURIDICA )

      hItem := ItemNew( hItem, "OrgId" )                          // Persona jurídica

      if !empty( oActor:BICOrBEI )

         ItemNew( hItem, "BICOrBEI", 11, oActor:BICOrBEI)          // BIC o BEI 

         ::SetActorOther( hItem, oActor )
      
      else
      
         ::addError( "BIC o BEI no puede estar vacio." )
      
      endif

   case ( oActor:nEntity == ENTIDAD_FISICA )

      hItem    := ItemNew( hItem, "PrvtId" )                         // Persona física 

         hItem := ItemNew( hItem, "DtAndPlcOfBirth" )                // Fecha y lugar de nacimiento 

         ItemNew( hItem, "BirthDt", 8, oActor:BirthDt )              // Fecha de nacimiento 
         ItemNew( hItem, "PrvcOfBirth", 35, oActor:PrvcOfBirth )     // Provincia de nacimiento
         ItemNew( hItem, "CityOfBirth", 35, oActor:CityOfBirth )     // Ciudad de nacimiento 
         ItemNew( hItem, "CtryOfBirth", 2, oActor:CtryOfBirth )      // País de nacimiento

         ::SetActorOther( hItem, oActor )
   
   otherwise
      
      ::addError( "No se ha especificado el tipo de entidad juridica o física." )

   end case

return nil

//--------------------------------------------------------------------------------------//

METHOD SetActorOther( hParent, oActor )

   local hItem
   local hChild

   if !empty( oActor:Id )

      hItem       := ItemNew( hParent, "Othr" )                // Otra 
      
      ItemNew( hItem, "Id", 35, oActor:Id )                    // Identificación 

      if !empty( oActor:Cd ) .or. !empty( oActor:Prtry )
         
         hChild   := ItemNew( hItem, "SchmeNm" )               // Nombre del esquema 

         ItemNew( hChild, "Cd", 4, oActor:Cd )             // Código 
         ItemNew( hChild, "Prtry", 35, oActor:Prtry )      // Propietario

      endif
      
      ItemNew( hItem, "Issr", 35, oActor:Issr )                // Emisor

   else
      
      ::addError( "No se ha especificado el id de la entidad juridica o física." )

   endif

return nil

//--------------------------------------------------------------------------------------//

METHOD IdPayment( hItem ) CLASS SepaXml

   /* Generar identificador de pago, a partir del mensaje */
   ::oDebtor:PmtInfId := alltrim(::MsgId) +"-"+ strzero(::oDebtor:NbOfTxs, 4)

   ItemNew(hItem, "PmtInfId", 35, ::oDebtor:PmtInfId)       // Identificación de la información del pago 
   ItemNew(hItem, "PmtMtd", 2, ::oDebtor:PmtMtd)            // Método de pago
   ItemNew(hItem, "BtchBookg", 5, ::oDebtor:BtchBookg)      // Indicador de apunte en cuenta
   ItemNew(hItem, "NbOfTxs", 15, str(::oDebtor:NbOfTxs, 0))    // Número de operaciones 
   ItemNew(hItem, "CtrlSum", 18, ::oDebtor:CtrlSum)         // Control de suma 

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

   // Comprobar numero de operaciones y suma total de importes

   for each oDebtor in ::aDebtors
      ::NbOfTxs   += 1
      ::CtrlSum   += oDebtor:InstdAmt
   next

   ::hXmlDoc      := mxmlNewXML()
   hItem          := mxmlNewElement( ::hXmlDoc, "Document" )
   // mxmlElementSetAttr( hItem, "xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance" )
   mxmlElementSetAttr( hItem, "xmlns", "urn:iso:std:iso:20022:tech:xsd:" + ::DocumentType )

   hItem          := ItemNew( hItem, ::FinancialMessage )               // Raíz del mensaje 

   ::GroupHeader( hItem )                                               // Cabecera

   /*
   La informacion del pago puede incluir varios adeudos por fecha de cobro
   Aqui se asume fecha de cobro distinta para cada adeudo, no realizando agrupacion.
   */

   for each oDebtor in ::aDebtors
      ::oDebtor         := __objClone( oDebtor )
      ::oDebtor:NbOfTxs := 1
      ::oDebtor:CtrlSum := oDebtor:InstdAmt

      hItem             := ::InfoPayment( hItem )
      ::DirectDebit( hItem )                                            // Adeudo individual
   next

   if empty( ::aErrors ) 
      if ::lMinified
         mxmlSaveFile( ::hXmlDoc, ::cFileOut, MXML_NO_CALLBACK )
      else
         mxmlSaveFile( ::hXmlDoc, ::cFileOut, @WhiteSpace() )
      endif
   endif

   ::End()

return nil

//--------------------------------------------------------------------------------------//

CLASS SepaDebitActor

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
   DATA Prtry                                   // Propietario

   DATA PmtInfId                                // Identificación de la información del pago 
   DATA BtchBookg       AS CHARACTER INIT "TRUE"         // Indicador de apunte en cuenta (1)
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

   METHOD New()         INLINE ( Self )   

ENDCLASS

//--------------------------------------------------------------------------------------//

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


