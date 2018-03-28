#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ini.ch"

//---------------------------------------------------------------------------//

CLASS TCajon

   CLASSDATA lCreated      AS LOGIC INIT .f.

   DATA  cPrinter
   DATA  cApertura                  INIT ""

   Method Create()                  CONSTRUCTOR

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

   if !Empty( D():Get( "LogPorta", nView ) )

      ( D():Get( "LogPorta", nView ) )->( dbAppend() )

      ( D():Get( "LogPorta", nView ) )->cNumTur   := cCurSesion()
      ( D():Get( "LogPorta", nView ) )->cSufTur   := RetSufEmp()
      ( D():Get( "LogPorta", nView ) )->cCodCaj   := Application():CodigoCaja()
      ( D():Get( "LogPorta", nView ) )->cCodUse   := Auth():Codigo()
      ( D():Get( "LogPorta", nView ) )->dFecApt   := GetSysDate()
      ( D():Get( "LogPorta", nView ) )->cHorApt   := Substr( Time(), 1, 5 )

      ( D():Get( "LogPorta", nView ) )->( dbUnLock() )

   end if

   RECOVER USING oError

      msgStop( "Imposible abrir bases de datos log de cajón portamonedas" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

return .t.

//---------------------------------------------------------------------------//

Function PrintEscCode( cEscCode, cPrinter )

   local nResult
   local cFile    := "EscFile.txt"

   if memowrit( cFile, alltrim( retChr( cEscCode ) ) )
      nResult     := win_printFileRaw( alltrim( cPrinter ), cFile )
      fErase( cFile )
   end if 

Return ( nil )

//--------------------------------------------------------------------------//