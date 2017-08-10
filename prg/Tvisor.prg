#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ini.ch"

#define NOPARITY            0
#define ODDPARITY           1
#define EVENPARITY          2
#define MARKPARITY          3
#define SPACEPARITY         4

#define ONESTOPBIT          0
#define ONESTOPBITS         1
#define TWOSTOPBITS         2

#define IE_BADID           -1
#define IE_OPEN            -2
#define IE_NOPEN           -3
#define IE_MEMORY          -4
#define IE_DEFAULT         -5
#define IE_HARDWARE        -10
#define IE_BYTESIZE        -11
#define IE_BAUDRATE        -12

//---------------------------------------------------------------------------//

CLASS TVisor

   CLASSDATA   lCreated    AS LOGIC INIT .f.

   DATA  oPrn

   DATA  cPort
   DATA  nBitsSec
   DATA  nBitsParada
   DATA  nBitsDatos
   DATA  nBitsParidad
   DATA  nHComm            AS NUMERIC
   DATA  cLastError
   DATA  nLineas           AS NUMERIC  INIT  2
   DATA  nChrLineas        AS NUMERIC  INIT  20
   DATA  cRetroceso                    INIT  Space( 50 )
   DATA  cAvanceChr                    INIT  Space( 50 )
   DATA  cAvanceLinea                  INIT  Space( 50 )
   DATA  cReset                        INIT  Space( 50 )
   DATA  cActiveCursor                 INIT  Space( 50 )
   DATA  cInactiveCursor               INIT  Space( 50 )
   DATA  cNormalWrite                  INIT  Space( 50 )
   DATA  cOffsetWrite                  INIT  Space( 50 )
   DATA  nPosInit          AS NUMERIC  INIT  0
   DATA  nPosEnd           AS NUMERIC  INIT  0
   DATA  nFirstRow         AS NUMERIC  INIT  0
   DATA  nFirstCol         AS NUMERIC  INIT  0
   DATA  cWellcomeLine1                INIT  Space( 50 )
   DATA  cWellcomeLine2                INIT  Space( 50 )
   DATA  nInact            AS NUMERIC  INIT  10
   DATA  nRetardo          AS NUMERIC

   DATA  aTextLine                     INIT  Array( 2 )

   DATA  oTimer

   METHOD Create() CONSTRUCTOR

   Method New( cPort, nBitsSec, nBitsParada, nBitsDatos, nBitsParidad, cApertura )

   METHOD Wellcome()

   METHOD Say( cWellcomeLine1, cWellcomeLine2 )

   METHOD SetBufferLine( cTextLine, nLine )

   METHOD WriteBufferLine()

   Method End()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create( cCodImp )

   local oBlock
   local oError
   local dbfVisor

   // Abrimos el fichero de impresoras de tickets para cargar los valores

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatDat() + "Visor.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Visor", @dbfVisor ) )
   SET ADSINDEX TO ( cPatDat() + "Visor.Cdx" ) ADDITIVE

   if !Empty( cCodImp ) .and. ( dbfVisor )->( dbSeek( cCodImp ) )

      //Cargamos los valores de la impresora

      ::cPort              := ( dbfVisor )->cPort
      ::nBitsSec           := Str( ( dbfVisor )->nBitSec )
      ::nBitsParada        := Str( ( dbfVisor )->nBitPar )
      ::nBitsDatos         := Str( ( dbfVisor )->nBitDat )
      ::nBitsParidad       := ( dbfVisor )->cBitPari
      ::nLineas            := ( dbfVisor )->nLinea
      ::nChrLineas         := ( dbfVisor )->nChaLin
      ::cRetroceso         := ( dbfVisor )->cRetro
      ::cAvanceChr         := ( dbfVisor )->cAvCha
      ::cAvanceLinea       := ( dbfVisor )->cAvLin
      ::cReset             := ( dbfVisor )->cReset
      ::cActiveCursor      := ""
      ::cInactiveCursor    := ""
      ::cNormalWrite       := ( dbfVisor )->cEscNor
      ::cOffsetWrite       := ( dbfVisor )->cEscDes
      ::nPosInit           := ( dbfVisor )->cPosIni
      ::nPosEnd            := ( dbfVisor )->cPosFin
      ::nFirstRow          := ( dbfVisor )->cPriFil
      ::nFirstCol          := ( dbfVisor )->cPriCol
      ::cWellcomeLine1     := Rtrim( ( dbfVisor )->cText1 )
      ::cWellcomeLine2     := Rtrim( ( dbfVisor )->cText2 )
      ::nInact             := ( dbfVisor )->nInact

   else

      // Metemos valores por defecto

      ::cPort              := "COM1"
      ::nBitsSec           := "9600"
      ::nBitsParada        := "0"
      ::nBitsDatos         := "8"
      ::nBitsParidad       := "Sin paridad"
      ::nLineas            := 2
      ::nChrLineas         := 20
      ::cRetroceso         := ""
      ::cAvanceChr         := ""
      ::cAvanceLinea       := ""
      ::cReset             := "20"
      ::cActiveCursor      := ""
      ::cInactiveCursor    := ""
      ::cNormalWrite       := ""
      ::cOffsetWrite       := ""
      ::nPosInit           := ""
      ::nPosEnd            := ""
      ::nFirstRow          := ""
      ::nFirstCol          := ""
      ::cWellcomeLine1     := ""
      ::cWellcomeLine2     := ""
      ::nInact             := 20

   end if

   //Cerramos el fichero de impresoras de tickets

   if dbfVisor != nil
      ( dbfVisor )->( dbCloseArea() )
   end if

   dbfVisor                := nil

   // Conversion

   ::cReset                := RetChr( ::cReset )

   ::oPrn                  := TCommPort():New( ::cPort, ::nBitsSec, ::nBitsParada, ::nBitsDatos, ::nBitsParidad, .f. )

   if ::oPrn:lCreated

      ::lCreated           := .t.

      if ::nInact != 0
         ::oTimer          := TTimer():New( ::nInact * 1000, {|| ::Wellcome() } )
      end if

   end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN Self

//---------------------------------------------------------------------------//

Method New( cPort, nBitsSec, nBitsParada, nBitsDatos, nBitsParidad, lMessage )

   DEFAULT lMessage     := .f.

   /*
   Creamos el puerto--------------------------------------------------------
   */

   ::oPrn               := TCommPort():New( ::cPort, nBitsSec, nBitsParada, nBitsDatos, nBitsParidad, .f. )

   if ::oPrn:lCreated

      ::lCreated        := .t.

      if !Empty( ::oTimer )
         ::oTimer:Activate()
      end if

   end if

Return ( ::lCreated )

//----------------------------------------------------------------------------//


METHOD Wellcome()

   if ::lCreated

      if !Empty( ::cReset )
         ::oPrn:Write( ::cReset )
      end if

      ::oPrn:Write(  PadC( ::cWellcomeLine1, ::nChrLineas ) + ;
                     PadC( ::cWellcomeLine2, ::nChrLineas ) )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Say( cTxtLine1, cTxtLine2 )

   if ::lCreated

      if ::oTimer != nil
         ::oTimer:DeActivate()
      end if

      if !Empty( ::cReset )
         ::oPrn:Write( ::cReset )
      end if

      ::oPrn:Write( PadR( cTxtLine1, ::nChrLineas ) + PadL( cTxtLine2, ::nChrLineas ) )

      if ::oTimer != nil
         ::oTimer:Activate()
      end if

   end if

Return ( Self )

//---------------------------------------------------------------------------//

Method End()

   if !Empty( ::oPrn )
      ::oPrn:End()
   end if

   if ::oTimer != nil
      ::oTimer:End()
   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD SetBufferLine( cTxtLine, nLine )

   local nLen

   DEFAULT nLine           := 1

   if Valtype( cTxtLine ) == "A"

      nLen                 := Len( AllTrim( cTxtLine[ 2 ] ) ) + 1

      ::aTextLine[ nLine ] := PadR( cTxtLine[ 1 ], ::nChrLineas - nLen ) + PadL( AllTrim( cTxtLine[ 2 ] ), nLen )

   else

      ::aTextLine[ nLine ] := PadR( cTxtLine, ::nChrLineas )

   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD WriteBufferLine()

   ::Say( ::aTextLine[ 1 ], ::aTextLine[ 2 ] )

Return ( Self )

//---------------------------------------------------------------------------//