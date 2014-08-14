#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ini.ch"

//---------------------------------------------------------------------------//

CLASS TCajon

   CLASSDATA   lCreated    AS LOGIC INIT .f.

   DATA  cPrinter
   DATA  cApertura                  INIT ""

   Method Create()   CONSTRUCTOR

   Method New( cApertura, cPrinter )

   Method Open( nView )
   Method OpenTest()                INLINE ( ::Open() )

   Method End()                     VIRTUAL

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

      ::cApertura          := ( dbfCajPorta )->cCodAper
      ::cPrinter           := ( dbfCajPorta )->cPrinter

   else

      ::cApertura          := "27 112 0 60 240"
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

Method New( cApertura, cPrinter ) CLASS TCajon

   DEFAULT cApertura    := "27 112 0 60 240"
   DEFAULT cPrinter     := ""

   ::cApertura          := cApertura
   ::cPrinter           := cPrinter

RETURN Self

//---------------------------------------------------------------------------//

METHOD Open( nView )

   PrintEscCode( ::cApertura, ::cPrinter )

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
      ( TDataView():Get( "LogPorta", nView ) )->cCodCaj   := oUser():cCaja()
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