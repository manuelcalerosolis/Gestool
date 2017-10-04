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

   DATA SchmeNm            AS CHARACTER   INIT "COR1"
   DATA cFileOut           
   DATA lMinified          AS LOGICAL     INIT .t.             // Documento compactado o con espacios y tabuladores
   DATA aErrors            AS ARRAY       INIT {}              // Control de errores
   DATA ErrorMessages      AS ARRAY       INIT {=>}            // Hash mensajes de error multilenguaje
   DATA aDebtors           AS ARRAY       INIT {}              // Lista de deudores

   DATA MsgId                                                  // Identificaci�n del mensaje
   DATA CreDtTm                                                // Fecha y hora de creaci�n
   DATA NbOfTxs            AS NUMERIC     INIT 0               // N�mero de operaciones 
   DATA CtrlSum            AS NUMERIC     INIT 0.00            // Control de suma

   DATA ServiceLevel       AS CHARACTER   INIT "SEPA"          // C�digo Nivel de servicio (7)
   DATA SeqTp              AS CHARACTER   INIT "OOFF"          // Tipo de secuencia (2) RCUR es la alternativa da problemas BSCH
   DATA PurposeCd                                              // C�digo categoria proposito
   DATA PurposePrtry                                           // Propietario categoria proposito

   DATA oInitPart
   DATA oCreditor
   DATA oUltimateCreditor
   DATA oDebtor
   DATA oUltimateDebtor

   DATA PmtInfId
   DATA PmtMtd             AS CHARACTER INIT "DD" READONLY     // M�todo de pago Regla de uso: Solamente se admite el c�digo �DD�
   DATA BtchBookg          AS CHARACTER INIT "false"           // Indicador de apunte en cuenta (1)

   METHOD New()
   METHOD setFinancialMessage( nFinancialMessage )
   METHOD setScheme( nScheme )
   METHOD setSeqTp( SeqTp )                                       INLINE ( ::SeqTp := SeqTp )
   METHOD setPaymentInformationIdentification( informationId )    INLINE ( ::PmtInfId := informationId )
   METHOD setOriginalMessageIdentification( messageId )           INLINE ( ::MsgId := messageId )

   DATA ReqdColltnDt
   
   METHOD setRequestedCollectionDate( sDate )                     INLINE ( ::ReqdColltnDt := sDate )
   METHOD getRquiredPayDateXML()                                  INLINE ( TXmlParseNode():New( "ReqdColltnDt", ::ReqdColltnDt, 10 ) )

   METHOD CreateDocumentXML()
   METHOD CreateFinancialNode()                                   INLINE ( ::oXmlFinancial   := TXmlNode():new( , ::FinancialMessage ),;
                                                                           ::oXmlDocument:addBelow( ::oXmlFinancial ) )

   METHOD getInfoPaymentXML()
   METHOD getTypePaymentXML()

   METHOD CalculateOperationsNumber()   

   METHOD ProcessDebtors()
   METHOD SaveDocumentXML()
   METHOD trimDocumentXML()

   METHOD addDebtor( oDebtor )                                    INLINE ( aadd( ::aDebtors, oDebtor ) )

   METHOD GroupHeader()
   METHOD InfoPayment()
   METHOD InitPart()

   METHOD SetLanguage()
   METHOD Activate()

   METHOD resetErrors()                                           INLINE ( ::aErrors := {} )
   METHOD addError( cError )                                      INLINE ( aadd( ::aErrors, cError ) )

ENDCLASS

//--------------------------------------------------------------------------------------//

METHOD New( cFileOut ) CLASS SepaXml

   ::cFileOut           := cFileOut
   ::CreDtTm            := IsoDateTime()  // Fecha y hora de creaci�n

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

METHOD setScheme( uScheme ) CLASS SepaXml

   if valtype( uScheme ) == "C"
      ::SchmeNm         := uScheme
      Return ( Self )
   end if 

   if valtype( uScheme ) == "N"
      switch uScheme
         case SEPA_SCHEME_CORE  
            ::SchmeNm   := "CORE" ; exit
         case SEPA_SCHEME_COR1  
            ::SchmeNm   := "COR1" ; exit
         case SEPA_SCHEME_B2B   
            ::SchmeNm   := "B2B"  ; exit
         otherwise              
            ::SchmeNm   := "SEPA"
      end
   end if 

RETURN ( Self )

//------------------------------------------------------------------------//

METHOD GroupHeader( hParent ) CLASS SepaXml

   local hItem
   local lError   := .f.

   if empty( ::MsgId )
      ::addError( "Identificaci�n del mensaje no puede estar vacio." )
      lError      := .t.
   endif

   if empty( ::CreDtTm )
      ::addError( "Fecha y hora de creaci�n no puede estar vacio." )
      lError      := .t.
   endif

   if empty( ::NbOfTxs )
      ::addError( "N�mero de operaciones no puede estar vacia." )
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

METHOD getInfoPaymentXML() CLASS SepaXml

   ::oXmlPmtInf      := TXmlNode():New( , "PmtInf" )
   ::oXmlPmtInf:addBelow( TXmlParseNode():New( "PmtInfId",  ::PmtInfId, 35 ) )
   ::oXmlPmtInf:addBelow( TXmlParseNode():New( "PmtMtd",    ::PmtMtd, 2 ) )
   ::oXmlPmtInf:addBelow( TXmlParseNode():New( "BtchBookg", ::BtchBookg, 5 ) )
   ::oXmlPmtInf:addBelow( TXmlParseNode():New( "NbOfTxs",   str( ::NbOfTxs, 0 ), 15 ) )
   ::oXmlPmtInf:addBelow( TXmlParseNode():New( "CtrlSum",   ::CtrlSum, 18 ) )

Return ( ::oXmlPmtInf )

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

   ::CalculateOperationsNumber()

   ::CreateDocumentXML()

   ::CreateFinancialNode()

   ::GroupHeader()                                               // Cabecera

   ::InfoPayment()

   ::ProcessDebtors()

   ::saveDocumentXML()

   ::trimDocumentXML()

return nil

//--------------------------------------------------------------------------------------//

METHOD CreateDocumentXML()

   ::oXml            := TXmlDocument():new( '<?xml version="1.0" encoding="UTF-8" standalone="no"?>' )

   ::oXmlDocument    := TXmlNode():new( , "Document", { "xmlns" => "urn:iso:std:iso:20022:tech:xsd:" + ::DocumentType } )
   ::oXml:oRoot:addBelow( ::oXmlDocument )   

return ( nil )

//--------------------------------------------------------------------------------------//

METHOD SaveDocumentXML()

   ferase( ::cFileOut )

   ::oXml:Write( ::cFileOut, 2 ) //HBXML_STYLE_NONEWLINE ) // HBXML_STYLE_TAB ) //

return nil

//--------------------------------------------------------------------------------------//

METHOD trimDocumentXML()

   local cString 
   local nHandle

   if file( ::cFileOut )

      cString  := memoread( ::cFileOut ) 
      cString  := alltrim( cString )
      cString  := StrTran( cString, CRLF, "" )

      ferase( ::cFileOut )
      nHandle  := fcreate( ::cFileOut )
      if ferror() == 0
         fwrite( nHandle, cString, len( cString ) )
         fclose( nHandle )
      end if 

   end if 

Return nil

//--------------------------------------------------------------------------------------//

// Comprobar numero de operaciones y suma total de importes

METHOD CalculateOperationsNumber()

   local oDebtor

   for each oDebtor in ::aDebtors
      ::NbOfTxs         += 1
      ::CtrlSum         += oDebtor:InstdAmt
   next

return nil

//--------------------------------------------------------------------------------------//

METHOD InfoPayment()

   ::oXmlPmtInf         := ::getInfoPaymentXML()
   ::oXmlPmtInf:addBelow( ::getTypePaymentXML() )
   ::oXmlPmtInf:addBelow( ::getRquiredPayDateXML() ) 

   ::InitPart()

   ::oXmlFinancial:addBelow( ::oXmlPmtInf )   

return nil

//--------------------------------------------------------------------------------------//

METHOD InitPart()

   ::oXmlPmtInf:addBelow( ::oInitPart:getCreditorXML() ) 
   ::oXmlPmtInf:addBelow( ::oInitPart:getCreditorIBANXML() )
   ::oXmlPmtInf:addBelow( ::oInitPart:getCreditorBICXML() )
   ::oXmlPmtInf:addBelow( ::oInitPart:getChrgBrXML() )
   ::oXmlPmtInf:addBelow( ::oInitPart:getIdCreditorXML() )

return nil

//--------------------------------------------------------------------------------------//

/*
La informacion del pago puede incluir varios adeudos por fecha de cobro
Aqui se asume fecha de cobro distinta para cada adeudo, no realizando agrupacion.
*/

METHOD ProcessDebtors( hItem )

   local oDebtor

   for each oDebtor in ::aDebtors
      
      ::oDebtor            := oDebtor // __objClone( oDebtor )

      ::oXmlPmtInf:addBelow( ::oDebtor:getDirectDebitTransactionInformationXml() )

   next

return nil

//--------------------------------------------------------------------------------------//

METHOD getTypePaymentXML() 

   ::oXmlPmtTpInf       := TXmlNode():New( , "PmtTpInf")                         // Informaci�n del tipo de pago 

      ::oXmlSvcLvl      := TXmlNode():New( , "SvcLvl")                           // Nivel de servicio 
      if ::ServiceLevel != nil
         ::oXmlSvcLvl:addBelow( TXmlParseNode():New( "Cd", ::ServiceLevel, 4 ) )
      end if 

   ::oXmlPmtTpInf:addBelow( ::oXmlSvcLvl )

      ::oXmlLclInstrm   := TXmlNode():New( , "LclInstrm" )   
      if ::SchmeNm != nil                 // Instrumento local
         ::oXmlLclInstrm:addBelow( TXmlParseNode():New( "Cd", ::SchmeNm, 35 ) )  // C�digo Instrumento local
      end if 

   ::oXmlPmtTpInf:addBelow( ::oXmlLclInstrm )

   ::oXmlPmtTpInf:addBelow( TXmlParseNode():New( "SeqTp", ::SeqTp, 4 ) )        // Tipo de secuencia

   // Lista de c�digos recogidos en la norma ISO 20022----------------------------------- 
   // Ex: CASH=CashManagementTransfer (Transaction is a general cash management instruction) 

   if ::PurposeCd != nil
   
      ::oXmlCtgyPurp    := TXmlNode():New( , "CtgyPurp" )                               // Categor�a del prop�sito 
      if ::PurposeCd != nil
         ::oXmlCtgyPurp:addBelow( TXmlParseNode():New( "Cd", ::PurposeCd, 4 ) )         // C�digo 
      end if 
      ::oXmlCtgyPurp:addBelow( TXmlParseNode():New( "Prtry", ::PurposePrtry, 35 ) )     // Propietario

      ::oXmlPmtTpInf:addBelow( ::oXmlCtgyPurp )

   endif

Return ( ::oXmlPmtTpInf )

//--------------------------------------------------------------------------------------//

CLASS SepaDebitActor

   DATA oSender
   DATA cName

   DATA nEntity

   DATA Nm                                                  // Nombre
   DATA Ctry                                                   // Pais
   DATA AdrLine1                                               // Direcci�n en texto libre
   DATA AdrLine2                                               // Se permiten 2 etiquetas para direccion
   DATA IBAN                                                   // IBAN
   DATA BIC                                                 // BIC
   DATA BICOrBEI                                               // BIC o BEI 
   DATA BirthDt                                                // Fecha de nacimiento 
   DATA PrvcOfBirth                                            // Provincia de nacimiento
   DATA CityOfBirth                                            // Ciudad de nacimiento 
   DATA CtryOfBirth                                            // Pa�s de nacimiento
   DATA Id                                                     // Identificaci�n 
   DATA Issr                                                   // Emisor 
   DATA Cd                                                  // Codigo
   DATA Prtry           AS CHARACTER INIT "SEPA"            // Propietario

   DATA PmtInfId                                            // Identificaci�n de la informaci�n del pago 
   DATA BtchBookg       AS CHARACTER INIT "false"           // Indicador de apunte en cuenta (1)
   DATA ReqdColltnDt                                        // Fecha de cobro (Vencimiento)
   DATA Ustrd                                               // Informacion no estructurada, p.e., concepto del cobro
   DATA NbOfTxs         AS NUMERIC INIT 0                   // N�mero de operaciones 
   DATA CtrlSum         AS NUMERIC INIT 0.00                   // Control de suma 
   DATA PmtMtd          AS CHARACTER INIT "DD"   READONLY   // M�todo de pago Regla de uso: Solamente se admite el c�digo �DD�
   DATA ChrgBr          AS CHARACTER INIT "SLEV" READONLY   // Cl�usula de gastos (4)
   DATA InstrId                                             // Identificaci�n de la instrucci�n
   DATA EndToEndId                                          // Identificaci�n de extremo a extremo 
   DATA InstdAmt        AS NUMERIC INIT 0.00                // Importe ordenado 
   DATA MndtId                                              // Identificaci�n del mandato 
   DATA DtOfSgntr                                           // Fecha de firma 
   DATA AmdmntInd       AS CHARACTER INIT "false"           // Indicador de modificaci�n 
   DATA OrgnlMndtId                                         // Identificaci�n del mandato original 

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

   ::oXmlId          := TXmlNode():new( , "Id" )                               // Identificaci�n 
      ::oXmlActor:addBelow( ::oXmlId )

   do case
   case ( ::nEntity == ENTIDAD_JURIDICA )

      ::oXmlOrgId    := TXmlNode():new( , "OrgId" )                          // Persona jur�dica

      if !empty( ::BICOrBEI )
         ::oXmlOrgId:addBelow( TXmlParseNode():New( "BICOrBEI", ::BICOrBEI, 11 ) )         // BIC o BEI 
      else 
         ::oSender:addError( "BIC o BEI no puede estar vacio." )
      end if 

      ::oXmlId:addBelow( ::oXmlOrgId )

      ::getOtherNodeXML() 

   case ( ::nEntity == ENTIDAD_FISICA )

      ::oXmlOrgId    := TXmlNode():New( , "PrvtId" )

         ::oXmlDtAndPlcOfBirth    := TXmlNode():New( , "DtAndPlcOfBirth" )
         ::oXmlDtAndPlcOfBirth:addBelow( TXmlParseNode():New( "BirthDt", ::BirthDt, 8 ) )
         ::oXmlDtAndPlcOfBirth:addBelow( TXmlParseNode():New( "PrvcOfBirth", ::PrvcOfBirth, 35 ) )
         ::oXmlDtAndPlcOfBirth:addBelow( TXmlParseNode():New( "CityOfBirth", ::CityOfBirth, 35 ) )
         ::oXmlDtAndPlcOfBirth:addBelow( TXmlParseNode():New( "CtryOfBirth", ::CtryOfBirth, 2 ) )

         ::oXmlOrgId:addBelow( ::oXmlDtAndPlcOfBirth )

      ::oXmlId:addBelow( ::oXmlOrgId )            

      ::getOtherNodeXML() 

   otherwise 

      ::oSender:addError( "No se ha especificado el tipo de entidad juridica o f�sica." )

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
         if ::Cd != nil
            ::oXmlSchmeNm:addBelow( TXmlParseNode():New( "Cd", ::Cd, 4 ) ) 
         end if 
         ::oXmlSchmeNm:addBelow( TXmlParseNode():New( "Prtry", ::Prtry, 35 ) ) 

   ::oXmlOthr:addBelow( ::oXmlSchmeNm )

   if ::Issr != nil
      ::oXmlOthr:addBelow( TXmlParseNode():New( "Issr", ::Issr, 35 ) )
   end if

   ::oXmlOrgId:addBelow( ::oXmlOthr )

Return ( nil )

//--------------------------------------------------------------------------------------//

METHOD getCreditorXML()

   ::oXmlCdrt     := TXmlNode():New( , "Cdtr" )

   if ::Nm != nil

      ::oXmlCdrt:addBelow( TXmlParseNode():New( "Nm", ::Nm, 70 ) )

      if ::Ctry != nil .or. ::AdrLine1 != nil
         ::oXmlPstlAdr  := TXmlNode():New( , "PstlAdr" )                               // Direcci�n postal
         ::oXmlPstlAdr:addBelow( TXmlParseNode():New( "Ctry", ::oCtry, 2 ) )           // Pa�s
         ::oXmlPstlAdr:addBelow( TXmlParseNode():New( "AdrLine", ::AdrLine1, 70 ) )    // Direcci�n en texto libre
         ::oXmlPstlAdr:addBelow( TXmlParseNode():New( "AdrLine", ::AdrLine2, 70 ) )    // Direcci�n en texto libre
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
   local oXmlDrctDbtTx
   local oXmlMndtRltdInf
   local oXmlAmdmntInd
   local oXmlAmdmntInfDtls   
   local oXmlDbtrAgt
   local oXmlFinInstnId
   local oXmlDbtr
   local oXmlDbtrAcct
   local oXmlId
   local oXmlPurp
   local oXmlRmtInf

   ::oXmlDrctDbtTxInf   := TXmlNode():New( , "DrctDbtTxInf" )

   if ::InstdAmt > 0
      
      // Importe ordenado------------------------------------------------------
      
      if ::InstrId != nil .or. ::EndToEndId != nil

         oXmlPmtId      := TXmlNode():New( , "PmtId")                                  // Identificaci�n del pago  
         
         if ::InstrId != nil         
            oXmlPmtId:addBelow( TXmlParseNode():New( "InstrId", ::InstrId, 35 ) )         // Identificaci�n de la instrucci�n
         end if 
         
         if ::EndToEndId != nil
            oXmlPmtId:addBelow( TXmlParseNode():New( "EndToEndId", ::EndToEndId, 35 ) )   // Identificaci�n de extremo a extremo 
         end if 

         ::oXmlDrctDbtTxInf:addBelow( oXmlPmtId )

      endif

      ::oXmlDrctDbtTxInf:addBelow( TXmlParseNode():New( "InstdAmt", ::InstdAmt, 12, .t. ) )  // Importe ordenado

      if ::MndtId != nil .or. ::DtOfSgntr != nil 

         oXmlDrctDbtTx        := TXmlNode():New( , "DrctDbtTx" )                             // Operaci�n de adeudo directo 
            oXmlMndtRltdInf   := TXmlNode():New( , "MndtRltdInf" )                           // Informaci�n del mandato 

            if ::MndtId != nil
               oXmlMndtRltdInf:addBelow( TXmlParseNode():New( "MndtId", ::MndtId, 35 ) )        
            end if 
            
            if ::DtOfSgntr != nil
               oXmlMndtRltdInf:addBelow( TXmlParseNode():New( "DtOfSgntr", ::DtOfSgntr, 10 ) )   // Fecha de firma 
            end if 

            oXmlAmdmntInd     := TXmlParseNode():New( "AmdmntInd", ::AmdmntInd, 5 )

            if ::OrgnlMndtId != nil
               oXmlAmdmntInfDtls := TXmlNode():New( , "AmdmntInfDtls" )                               // Detalles de la modificaci�n 
               oXmlAmdmntInfDtls:addBelow( TXmlParseNode():New( "OrgnlMndtId", ::OrgnlMndtId, 35 ) )  // Identificaci�n del mandato original 

               oXmlAmdmntInd:addBelow( oXmlAmdmntInfDtls )
            endif

            oXmlMndtRltdInf:addBelow( oXmlAmdmntInd )

         oXmlDrctDbtTx:addBelow( oXmlMndtRltdInf )

      ::oXmlDrctDbtTxInf:addBelow( oXmlDrctDbtTx )

      endif

      // Entidad del deudor original-------------------------------------------

      if ::BICOrBEI != nil
         oXmlDbtrAgt       := TXmlNode():New( , "DbtrAgt" )          // Entidad del deudor 
            oXmlFinInstnId := TXmlNode():New( , "FinInstnId" )       // Identificaci�n de la entidad 
            oXmlFinInstnId:addBelow( TXmlParseNode():New( "BIC", ::BICOrBEI, 11 ) )
         oXmlDbtrAgt:addBelow( oXmlFinInstnId )

         ::oXmlDrctDbtTxInf:addBelow( oXmlDbtrAgt )
      
      else
         ::oSender:addError( ::oSender:ErrorMessages[ 'SEPA_DEBTOR_AGENT' ] )
      
      endif

      // Deudor----------------------------------------------------------------

      if ::Nm != nil
         ::oXmlDrctDbtTxInf:addBelow( ::getNodeXML() )         
      else
         ::oSender:addError( ::oSender:ErrorMessages[ 'SEPA_DEBTOR_NAME' ] )
      endif

      // Cuenta del deudor-----------------------------------------------------

      if ::IBAN != nil 
         oXmlDbtrAcct   := TXmlNode():New( , "DbtrAcct" )
            oXmlId      := TXmlNode():New( , "Id" )
            oXmlId:addBelow( TXmlParseNode():New( "IBAN", ::IBAN, 34 ) )   // IBAN
         oXmlDbtrAcct:addBelow( oXmlId )

         ::oXmlDrctDbtTxInf:addBelow( oXmlDbtrAcct )
      else
         ::oSender:addError( ::oSender:ErrorMessages[ 'SEPA_DEBTOR_ACCOUNT' ] )
      endif

      // Prop�sito ------------------------------------------------------------

      if ::oSender:PurposeCd != nil
         oXmlPurp       := TXmlNode():New( , "Purp" )

         if ::oSender:PurposeCd != nil
            oXmlPurp:addBelow( TXmlParseNode():New( "Cd", ::oSender:PurposeCd, 4 ) )
         end if 

         ::oXmlDrctDbtTxInf:addBelow( oXmlPurp )
      endif

      // Concepto--------------------------------------------------------------

      if ::Ustrd != nil
         oXmlRmtInf     := TXmlNode():New( , "RmtInf" )                       // Concepto
         oXmlRmtInf:addBelow( TXmlParseNode():New( "Ustrd", ::Ustrd, 140 ) )  // No estructurado

         ::oXmlDrctDbtTxInf:addBelow( oXmlRmtInf )
      endif

   else
      ::oSender:addError( 'Recibo sin importe' )
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
         cData    := alltrim( strToIso2022( padr( xValue, nLen ) ) )
      else
         cData    := alltrim( strToIso2022( xValue ) )
      end if
   end case

   if lCurrency != nil
      hAttributes := { "Ccy" => "EUR" }
   endif

   ::Super:New( , cName, hAttributes, cData )

Return ( Self )

//--------------------------------------------------------------------//

/* v.1.0 14/11/2013
 * Funciones miscel�neas de apoyo a formatos SEPA
 * (c) Joaquim Ferrer Godoy <quim_ferrer@yahoo.es>
 */

function cTime()

   local strTime  := time()
   strTime        := substr(strTime,1,2) + substr(strTime,4,2) + substr(strTime,7,2)

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
   strVal := str( nVal, nLen + 1, 2 )     // +1 espacio que resta punto decimal
   strVal := strtran( strVal, "." )      // Quitar punto decimal
   strVal := strtran( strVal, " ", "0" ) // Reemplazar espacios por 0

return( strVal )

function IsoDateTime()

return( sDate() + "T" + time() )     // YYYY-MM-DDThh:mm:ss

function OutFile(nHandle, a)

   local strRec := ""

   aeval( a, {|e|  strRec += e } )
   fwrite(nHandle, strRec + CRLF)

return nil

function Id_Name( cCountry, cCode, cNif )

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

   local cId   := "PRE" + fDate() + cTime() + strzero( seconds(), 5 ) + cRef

return padR(cId, 35)

function strToIso2022( xtxt )

   LOCAL afrm, i, xret := "", xpos

   afrm  := {  { "�", "A" },;
               { "�", "A" },;
               { "�", "A" },;
               { "�", "A" },;
               { "�", "A" },;
               { "�", "A" },;
               { "�", "A" },;
               { "�", "C" },;
               { "�", "E" },;
               { "�", "E" },;
               { "�", "E" },;
               { "�", "E" },;
               { "�", "I" },;
               { "�", "I" },;
               { "�", "I" },;
               { "�", "I" },;
               { "�", "D" },;
               { "�", "N" },;
               { "�", "O" },;
               { "�", "O" },;
               { "�", "O" },;
               { "�", "O" },;
               { "�", "O" },;
               { "�", "U" },;
               { "�", "U" },;
               { "�", "U" },;
               { "�", "U" },;
               { "�", "Y" },;
               { "�", "a" },;
               { "�", "a" },;
               { "�", "a" },;
               { "�", "a" },;
               { "�", "a" },;
               { "�", "a" },;
               { "�", "a" },;
               { "�", "c" },;
               { "�", "e" },;
               { "�", "e" },;
               { "�", "e" },;
               { "�", "e" },;
               { "�", "i" },;
               { "�", "i" },;
               { "�", "i" },;
               { "�", "i" },;
               { "�", "n" },;
               { "�", "o" },;
               { "�", "o" },;
               { "�", "o" },;
               { "�", "o" },;
               { "�", "o" },;
               { "�", "u" },;
               { "�", "u" },;
               { "�", "u" },;
               { "�", "u" },;
               { "�", "y" },;
               { "�", "y" },;
               { "�", "S" },;
               { "�", "s" },;
               { "�", "Y" } }

   for i := 1 to len( xtxt )
      xpos := ascan( afrm, {| x | substr( xtxt, i, 1 ) == x[ 1 ] } )
      if ( xpos > 0 )
         xret += afrm[ xpos, 2 ]
      else
         xret += substr( xtxt, i, 1 )
      endif
   next

return xret


