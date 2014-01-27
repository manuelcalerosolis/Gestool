#include "FiveWin.Ch"

#include "Factu.ch" 
#include "Ini.ch"

//---------------------------------------------------------------------------//

CLASS TCajon

   CLASSDATA   lCreated    AS LOGIC INIT .f.

   DATA  oPrn

   DATA  cPort
   DATA  nBitsSec
   DATA  nBitsParada
   DATA  nBitsDatos
   DATA  nBitsParidad
   DATA  nDriver
   DATA  cPrinter
   DATA  cApertura                  INIT ""

   Method Create()   CONSTRUCTOR

   Method New( cPort, nBitsSec, nBitsParada, nBitsDatos, nBitsParidad, cApertura )

   Method Open( nView )
   Method OpenTest()                INLINE ( ::Open() )

   Method End()      VIRTUAL

   Method LogCajon()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create( cCodCaj )

   local oBlock
   local oError
   local dbfCajPorta

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatDat() + "CAJPORTA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CAJPORTA", @dbfCajPorta ) )
   SET ADSINDEX TO ( cPatDat() + "CAJPORTA.CDX" ) ADDITIVE

   if !Empty( cCodCaj ) .and. ( dbfCajPorta)->( dbSeek( cCodCaj ) )

      ::cPort              := ( dbfCajPorta )->cPort
      ::nBitsSec           := ( dbfCajPorta )->nBitsSec
      ::nBitsParada        := ( dbfCajPorta )->nBitsPara
      ::nBitsDatos         := ( dbfCajPorta )->nBitsDatos
      ::nBitsParidad       := ( dbfCajPorta )->cBitsPari
      ::cApertura          := ( dbfCajPorta )->cCodAper
      ::nDriver            := ( dbfCajPorta )->nDriver
      ::cPrinter           := ( dbfCajPorta )->cPrinter

   else

      ::cPort              := "COM1"
      ::nBitsSec           := "9600"
      ::nBitsParada        := "0"
      ::nBitsDatos         := "8"
      ::nBitsParidad       := "Sin paridad"
      ::cApertura          := "27 112 0 60 240"
      ::nDriver            := 2
      ::cPrinter           := ""

   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if dbfCajPorta != nil
      ( dbfCajPorta )->( dbCloseArea() )
   end if

   dbfCajPorta             := nil

RETURN Self

//---------------------------------------------------------------------------//

Method New( cPort, nBitsSec, nBitsParada, nBitsDatos, cBitsParidad, cApertura, nDriver, cPrinter ) CLASS TCajon

   DEFAULT cPort        := "COM1"
   DEFAULT nBitsSec     := "9600"
   DEFAULT nBitsParada  := "0"
   DEFAULT nBitsDatos   := "8"
   DEFAULT cBitsParidad := "Sin paridad"
   DEFAULT cApertura    := "27 112 0 60 240"
   DEFAULT nDriver      := 2
   DEFAULT cPrinter     := ""

   ::cPort              := cPort
   ::nBitsSec           := nBitsSec
   ::nBitsParada        := nBitsParada
   ::nBitsDatos         := nBitsDatos
   ::nBitsParidad       := cBitsParidad
   ::cApertura          := cApertura
   ::nDriver            := nDriver
   ::cPrinter           := cPrinter

RETURN Self

//---------------------------------------------------------------------------//

METHOD Open( nView )

   if ::nDriver != 2

      PrintEscCode( ::cApertura, ::cPrinter )

   else

      ::oPrn            := TPort():New( ::cPort, ::nBitsSec, ::nBitsParada, ::nBitsDatos, ::nBitsParidad )

      if !Empty( ::oPrn )
         ::oPrn:Write( RetChr( ::cApertura ) )
         ::oPrn:End()
      end if

   end if

   if IsNum( nView )
      ::LogCajon( nView )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD LogCajon( nView )

   local oBlock
   local oError
   local dbfLogPorta

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if !Empty( TDataView():Get( "LogPorta", nView ) )

      ( TDataView():Get( "LogPorta", nView ) )->( dbAppend() )

      ( TDataView():Get( "LogPorta", nView ) )->cNumTur   := cCurSesion()
      ( TDataView():Get( "LogPorta", nView ) )->cSufTur   := RetSufEmp()
      ( TDataView():Get( "LogPorta", nView ) )->cCodUse   := cCurUsr()
      ( TDataView():Get( "LogPorta", nView ) )->dFecApt   := GetSysDate()
      ( TDataView():Get( "LogPorta", nView ) )->cHorApt   := Substr( Time(), 1, 5 )

      ( TDataView():Get( "LogPorta", nView ) )->( dbUnLock() )

   end if

   RECOVER USING oError

      msgStop( "Imposible abrir bases de datos log de cajón portamonedas" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

return .t.

//---------------------------------------------------------------------------//

Function PrintEscCode( cEscCode, cPrinter )

   local nHandle
   local cFile    := "EscFile.txt"

   nHandle        := fCreate( cFile, 0 )

   fWrite( nHandle, AllTrim( RetChr( cEscCode ) ) )
   fClose( nHandle )

   PrintFileRaw( AllTrim( cPrinter ), cFile )

   fErase( cFile )

Return ( nil )

//--------------------------------------------------------------------------//