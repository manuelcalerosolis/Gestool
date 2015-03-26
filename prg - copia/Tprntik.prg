#ifndef __PDA__
   #include "FiveWin.Ch"
   #include "Factu.ch" 
#else
   #include "FWCE.ch"
   REQUEST DBFCDX
#endif

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

#define BUFFER             4096

#ifndef __PDA__

//---------------------------------------------------------------------------//
//Funciones del programa
//---------------------------------------------------------------------------//

CLASS TPort

   DATA  cPort
   DATA  lCreated       AS LOGIC INIT .t.
   DATA  nHComm         AS NUMERIC
   DATA  cLastError
   DATA  nBitsSec       AS NUMERIC
   DATA  nBitsParada    AS NUMERIC
   DATA  nBitsDatos     AS NUMERIC
   DATA  nBitsParidad   AS NUMERIC

   METHOD New( cPort, nBitsSec, nBitsParada, nBitsDatos, nBitsParidad ) CONSTRUCTOR

   METHOD OpenCommError()

   METHOD End()         INLINE ( fClose( ::nHComm ) )

   METHOD Write( cTexto )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( cPort, nBitsSec, nBitsParada, nBitsDatos, nBitsParidad, lMessage )

   local fDCB

   DEFAULT cPort        := "COM1"
   DEFAULT nBitsSec     := "9600"
   DEFAULT nBitsDatos   := "8"
   DEFAULT nBitsParada  := "0"
   DEFAULT nBitsParidad := "Sin paridad"
   DEFAULT lMessage     := .f.

   ::cPort              := Rtrim( cPort )

   /*
   Velocidad----------------------------------------------------------------
   */

   if ValType( nBitsSec ) == "C"
      ::nBitsSec        := Val( nBitsSec )
   else
      ::nBitsSec        := nBitsSec
   end if

   /*
   Bits de datos------------------------------------------------------------
   */

   if ValType( nBitsDatos ) == "C"
      ::nBitsDatos      := Val( nBitsDatos )
   else
      ::nBitsDatos      := nBitsDatos
   end if

   /*
   Bits de parada-----------------------------------------------------------
   */

   if ValType( ::nBitsParada ) == "C"
      ::nBitsParada     := Val( nBitsParada )
   else
      ::nBitsParada     := nBitsParada
   end if

   /*
   Paridad----------------------------------------------------------------
   */

   nBitsParidad         := Rtrim( nBitsParidad )

   do case
      case nBitsParidad == "Sin paridad"
         ::nBitsParidad := NOPARITY
      case nBitsParidad == "Paridad par"
         ::nBitsParidad := ODDPARITY
      case nBitsParidad == "Paridad impar"
         ::nBitsParidad := EVENPARITY
   end do

   ::nHComm             := fCreate( ::cPort )

   if ::nHComm > 0

      ::OpenCommError()

      msgStop( "Puerto  : " + cValToChar( ::cPort )          + CRLF +;
               "Bits    : " + cValToChar( ::nBitsSec )       + CRLF +;
               "Parada  : " + cValToChar( ::nBitsParada )    + CRLF +;
               "Datos   : " + cValToChar( ::nBitsDatos )     + CRLF +;
               "Paridad : " + cValToChar( ::nBitsParidad ),;
               ::cLastError )

      ::lCreated        := .f.

   end if

RETURN Self

//----------------------------------------------------------------------------//

METHOD OpenCommError()

   if ( ::nHComm >= 0 )
      ::cLastError         := "No error"
	else
		do case
         case ::nHComm == IE_BADID
            ::cLastError   := "ID: Inválido o no soportado"
         case ::nHComm == IE_BAUDRATE
            ::cLastError   := "BAUDIOS: No soportado"
         case ::nHComm == IE_BYTESIZE
            ::cLastError   := "BYTE: Tamaño no válido"
         case ::nHComm == IE_DEFAULT
            ::cLastError   := "Valores por defecto son erroneos"
         case ::nHComm == IE_HARDWARE
            ::cLastError   := "HARDWARE: No presente"
         case ::nHComm == IE_MEMORY
            ::cLastError   := "MEMORIA: Insuficiente"
         case ::nHComm == IE_NOPEN
            ::cLastError   := "HARDWARE: Dispositivo no abierto"
         case ::nHComm == IE_OPEN
            ::cLastError   := "HARDWARE: Dispositivo ya abierto"
			otherwise
            ::cLastError   := "Error no determinado"
		endcase
	endif

return ::nHComm

//----------------------------------------------------------------------------//

METHOD Write( cTexto, nRetardo )

   local lWrite      := .t.
   local nLenTexto   := len( cTexto )

   DEFAULT nRetardo  := 0

   fWrite( ::nHComm, cTexto, nLenTexto )

   if nRetardo != 0
      DlgWait( nRetardo )
   end if

   // fCommit( ::nHComm )

return ( lWrite )

//---------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//
//Funciones de PDA
//---------------------------------------------------------------------------//

#ifdef __PDA__

#define GENERIC_READ          0x80000000
#define GENERIC_WRITE         0x40000000
#define READ_WRITE            0xC0000000
#define OPEN_EXISTING         3
#define FILE_ATTRIBUTE_NORMAL 0x00000080

FUNCTION SendText( cText, cPort )

   local i
   local hOut
   local dbfConfig
   local nLin           := 0
   local n
   local nLinesPage     := nTotLin()
   local nLinesSalto    := nSalLin()

   do case
      case Empty( cPort )
         cPort    := cPortPrint()
      case Valtype( cPort ) == "N"
         cPort    := "COM" + Alltrim( Str( cPort ) ) + ":"
   end case

   hOut           := CreateFile( cPort, GENERIC_WRITE, 0, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL )

   if hOut == -1
      MsgStop( 'No pudo abrise el puerto de impresora, puerto ' + cPort + CRLF + 'Handle' + Str( hOut ) )
   else

      for i := 1 to Len( cText )

         if SubStr( cText, i, 1 ) == Chr(13)
            nLin++
         endif

         WriteByte( hOut, Asc( SubStr( cText, i, 1 ) ) )

         if nLin == nLinesPage

            for n := 1 to nLinesSalto
               WriteByte( hOut, Asc( chr(10)+chr(13) ) )
            next

            nLin := 0

         end if

      next

      for i := 1 to 64
         WriteByte( hOut, 27 )
      next

      CloseHandle( hOut )

   end if

Return nil

//---------------------------------------------------------------------------//

#endif