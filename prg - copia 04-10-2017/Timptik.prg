#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ini.ch"

#define CHAR_PATTERN       "B"

#define NOPARITY            0
#define ODDPARITY           1
#define EVENPARITY          2
#define MARKPARITY          3
#define SPACEPARITY         4

#define ONESTOPBIT          0
#define ONESTOPBITS         1
#define TWOSTOPBITS         2

//---------------------------------------------------------------------------//

CLASS TImpresoraTiket

   DATA  lWin           AS LOGIC INIT .f.
   DATA  lCreated       AS LOGIC INIT .f.
   DATA  lPreview       AS LOGIC INIT .f.
   DATA  oPrn
   DATA  cPort
   DATA  nBitsSec
   DATA  nBitsParada
   DATA  nBitsDatos
   DATA  nBitsParidad
   DATA  cActCentrado
   DATA  cDesCentrado
   DATA  cActNegrita
   DATA  cDesNegrita
   DATA  cActExpandida
   DATA  cDesExpandida
   DATA  cActColor
   DATA  cDesColor
   DATA  cSalto
   DATA  cCorte
   DATA  cIniApp
   DATA  oIniApp
   DATA  cLastError
   DATA  nRetardo
   DATA  cMru           INIT "gc_printer2_16"
   DATA  cModel

   DATA  oFont

   DATA  nRow
   DATA  nCol
   DATA  nRowStep

   DATA  nWidth
   DATA  nHeight

   METHOD New()                                    CONSTRUCTOR
   METHOD Create()                                 CONSTRUCTOR
   METHOD Initiate( cCodImp, oImpresora, lPrev )   CONSTRUCTOR

   METHOD lBuildComm()

   Method lCloseComm()     INLINE ( if( ::oPrn:lCreated, ::oPrn:End(), ) )

   METHOD End()

   METHOD Test()

   METHOD Write( cTexto )

   Method WriteExpresion( cExpresion, lCentrado, lNegrita, lExpandida, lColor, lPreview )

   Method ActivaCentrado()       INLINE   ::Write( RetChr( ::cActCentrado ) )
   Method DesactivaCentrado()    INLINE   ::Write( RetChr( ::cDesCentrado ) )

   Method ActivaNegrita()        INLINE   ::Write( RetChr( ::cActNegrita ) )
   Method DesactivaNegrita()     INLINE   ::Write( RetChr( ::cDesNegrita ) )

   Method ActivaExpandida()      INLINE   ::Write( RetChr( ::cActExpandida ) )
   Method DesactivaExpandida()   INLINE   ::Write( RetChr( ::cDesExpandida ) )

   Method ActivaColor()          INLINE   ::Write( RetChr( ::cActColor ) )
   Method DesactivaColor()       INLINE   ::Write( RetChr( ::cDesColor ) )

   Method Salto()                INLINE   ::Write( RetChr( ::cSalto ) )

   Method Corte()                INLINE   ::Write( RetChr( ::cCorte ) )

   METHOD NeedNewPage()          INLINE   ( ::nRow + ::nRowStep >= ::nHeight )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( cPort, nBitsSec, nBitsParada, nBitsDatos, nBitsParidad ) CLASS TImpresoraTiket

   DEFAULT cPort        := "COM1"
   DEFAULT nBitsSec     := "9600"
   DEFAULT nBitsParada  := "0"
   DEFAULT nBitsDatos   := "8"
   DEFAULT nBitsParidad := "Sin paridad"

   ::cPort              := cPort
   ::nBitsSec           := nBitsSec
   ::nBitsParada        := nBitsParada
   ::nBitsDatos         := nBitsDatos
   ::nBitsParidad       := nBitsParidad
   ::cActCentrado       := Space( 100 )
   ::cDesCentrado       := Space( 100 )
   ::cActExpandida      := Space( 100 )
   ::cDesExpandida      := Space( 100 )
   ::cActNegrita        := Space( 100 )
   ::cDesNegrita        := Space( 100 )
   ::cActColor          := Space( 100 )
   ::cDesColor          := Space( 100 )
   ::cSalto             := Space( 100 )
   ::cCorte             := Space( 100 )
   ::nRetardo           := 0.1
   ::lCreated           := .f.
   ::nRow               := 0
   ::nCol               := 0

RETURN Self

//----------------------------------------------------------------------------//

METHOD Create( cCodImp, lPreview ) CLASS TImpresoraTiket

   local oBlock
   local oError
   local dbfImpTik

   DEFAULT lPreview        := .f.

   // Abrimos el fichero de impresoras de tickets para cargar los valores

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPatDat() + "IMPTIK.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "IMPTIK", @dbfImpTik ) )
   SET ADSINDEX TO ( cPatDat() + "IMPTIK.CDX" ) ADDITIVE

   if !Empty( cCodImp ) .and. ( dbfImpTik )->( dbSeek( cCodImp ) )

      // Cargamos los valores de la impresora

      ::lPreview           := lPreview
      ::cPort              := Alltrim( if( lPreview, "Print.prn", ( dbfImpTik )->cPort ) )
      ::lWin               := ( dbfImpTik )->lWin
      ::nBitsSec           := Str( ( dbfImpTik )->nBitsSec )
      ::nBitsParada        := Str( ( dbfImpTik )->nBitsPara )
      ::nBitsDatos         := Str( ( dbfImpTik )->nBitsDatos )
      ::nBitsParidad       := Alltrim( ( dbfImpTik )->cBitsPari )
      ::cActCentrado       := Alltrim( ( dbfImpTik )->cActCentr )
      ::cDesCentrado       := Alltrim( ( dbfImpTik )->cDesCentr )
      ::cActExpandida      := Alltrim( ( dbfImpTik )->cActExp )
      ::cDesExpandida      := Alltrim( ( dbfImpTik )->cDesExp )
      ::cActNegrita        := Alltrim( ( dbfImpTik )->cActNegr )
      ::cDesNegrita        := Alltrim( ( dbfImpTik )->cDesNegr )
      ::cActColor          := Alltrim( ( dbfImpTik )->cActColor )
      ::cDesColor          := Alltrim( ( dbfImpTik )->cDesColor )
      ::cSalto             := Alltrim( ( dbfImpTik )->cSalto )
      ::cCorte             := Alltrim( ( dbfImpTik )->cCorte )
      ::nRetardo           := ( dbfImpTik )->nRetardo

   else

      // Metemos valores por defecto

      ::lPreview           := lPreview
      ::lWin               := .f.
      ::cPort              := "COM1"
      ::nBitsSec           := "9600"
      ::nBitsParada        := "0"
      ::nBitsDatos         := "8"
      ::nBitsParidad       := "Sin paridad"
      ::nRetardo           := 0

   end if

   //Cerramos el fichero de impresoras de tickets

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !Empty( dbfImpTik )
      ( dbfImpTik )->( dbCloseArea() )
   end if

   dbfImpTik               := nil

RETURN Self

//---------------------------------------------------------------------------//

METHOD Initiate( cCodImp, oImpresora, lPreview ) CLASS TImpresoraTiket

   DEFAULT lPreview        := .f.

   if !Empty( cCodImp ) .and. oImpresora:Seek( cCodImp )

      // Cargamos los valores de la impresora

      ::lPreview           := lPreview
      ::cPort              := Alltrim( if( lPreview, "Print.prn", oImpresora:cPort ) )
      ::lWin               := oImpresora:lWin
      ::nBitsSec           := Str( oImpresora:nBitsSec )
      ::nBitsParada        := Str( oImpresora:nBitsPara )
      ::nBitsDatos         := Str( oImpresora:nBitsDatos )
      ::nBitsParidad       := Alltrim( oImpresora:cBitsPari )
      ::cActCentrado       := Alltrim( oImpresora:cActCentr )
      ::cDesCentrado       := Alltrim( oImpresora:cDesCentr )
      ::cActExpandida      := Alltrim( oImpresora:cActExp )
      ::cDesExpandida      := Alltrim( oImpresora:cDesExp )
      ::cActNegrita        := Alltrim( oImpresora:cActNegr )
      ::cDesNegrita        := Alltrim( oImpresora:cDesNegr )
      ::cActColor          := Alltrim( oImpresora:cActColor )
      ::cDesColor          := Alltrim( oImpresora:cDesColor )
      ::cSalto             := Alltrim( oImpresora:cSalto )
      ::cCorte             := Alltrim( oImpresora:cCorte )
      ::nRetardo           := oImpresora:nRetardo

   else

      // Metemos valores por defecto

      ::lPreview           := lPreview
      ::lWin               := .f.
      ::cPort              := "COM1"
      ::nBitsSec           := "9600"
      ::nBitsParada        := "0"
      ::nBitsDatos         := "8"
      ::nBitsParidad       := "Sin paridad"
      ::nRetardo           := 0

   end if

RETURN Self

//---------------------------------------------------------------------------//

Method lBuildComm( lMessage ) CLASS TImpresoraTiket

   DEFAULT lMessage        := .f.

   if !::lWin

      /*
      Creamos el puerto--------------------------------------------------------
      */

      if ::oPrn != nil
         ::oPrn:End()
      end if

      ::oPrn               := TPort():New( ::cPort, ::nBitsSec, ::nBitsParada, ::nBitsDatos, ::nBitsParidad, .t. )
      if ::oPrn:lCreated
         ::lCreated        := .t.
      end if

      if lMessage
         msgInfo( "Puerto  : " + ::cPort        + CRLF +;
                  "Bits    : " + ::nBitsSec     + CRLF +;
                  "Datos   : " + ::nBitsDatos   + CRLF +;
                  "Paridad : " + ::nBitsParidad + CRLF +;
                  "Parada  : " + ::nBitsParada  + CRLF +;
                  "Handle  : " + Str( ::oPrn:nHComm ) )
      end if

   else

      ::oPrn               := PrintBegin( "Imprimiendo...", .f., ::lPreview, ::cModel, .t. )

      if Empty( ::oPrn:hDC )

         ::lCreated        := .f.

      else

         ::oFont           := TFont():New( "Courier New", 0, -12, , .t., , , , , , , , , , , ::oPrn )
         ::nRow            := 0
         ::nRowStep        := ::oPrn:GetTextHeight( CHAR_PATTERN, ::oFont )

         ::nWidth          := ::oPrn:nHorzRes()
         ::nHeight         := ::oPrn:nVertRes()

         ::lCreated        := .t.

         PageBegin()

      end if

   end if

Return ( ::lCreated )

//----------------------------------------------------------------------------//

Method End() CLASS TImpresoraTiket

   if ::lWin

      if ::oPrn != nil
         PageEnd()
         PrintEnd()
         ::oPrn:End()
      end if

   else

      if ::oPrn != nil
         ::oPrn:End()
      end if

      if ::lPreview
         VisTik( ::cPort )
      end if

   end if

Return .t.

//----------------------------------------------------------------------------//

METHOD Test() CLASS TImpresoraTiket

   ::lBuildComm( .t. )

   if ::oPrn != nil .and. ::oPrn:nHComm > 0
      ::Write( "Test de impresora" + CRLF )
      ::oPrn:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Write( cTexto, lCenter ) CLASS TImpresoraTiket

   local nStartCol         := ::nCol

   DEFAULT lCenter         := .f.

   cTexto                  := cValToChar( cTexto )

   if ::lWin

      cTexto               := StrTran( cTexto, CRLF, "" )

      if ::oPrn != nil

         if lCenter
            nStartCol      := Int( ::nWidth / 2 ) - Int( ::oPrn:GetTextWidth( cTexto, ::oFont ) / 2 )
         end if

         ::oPrn:Say( ::nRow, nStartCol, cTexto, ::oFont )

         ::nRow            += ::nRowStep

         if ::NeedNewPage()
            ::nRow         := 0
            PageEnd()
            PageBegin()
         end if

      end if

   else

      if ::oPrn != nil
         ::oPrn:Write( cTexto, ::nRetardo )
      end if

   end if

return ( Self )

//---------------------------------------------------------------------------//

Method WriteExpresion( cExpresion, lCentrado, lNegrita, lExpandida, lColor, lPreview )

   local cTexto

   DEFAULT lPreview  := .f.

   if ::oPrn == nil
      Return ( "" )
   end if

   cTexto            := GetBanda( cExpresion )

   if !lPreview
      if lCentrado
         ::ActivaCentrado()
      end if
      if lNegrita
         ::ActivaNegrita()
      end if
      if lExpandida
         ::ActivaExpandida()
      end if
      if lColor
         ::ActivaColor()
      end if
   end if

   ::oPrn:Write( cTexto, ::nRetardo )

   if !lPreview
      if lCentrado
         ::DesactivaCentrado()
      end if
      if lNegrita
         ::DesactivaNegrita()
      end if
      if lExpandida
         ::DesactivaExpandida()
      end if
      if lColor
         ::DesactivaColor()
      end if
   end if

Return ( cTexto )

//---------------------------------------------------------------------------//

Function GetBanda( cBanda, lCrlf )

   local cEva
   local cRet     := ""
   local cTit     := AllTrim( cBanda )

   DEFAULT lCrlf  := .t.

   cTit           := StrTran( cTit, CRLF, '' )

   cEva           := bChar2Block( cTit, .f., .f., .t. )

   if cEva == nil
      cRet        += cTit + if( lCrlf, CRLF, "" )
   else
      cRet        += Rtrim( cValToChar( Eval( cEva ) ) ) + if( lCrlf, CRLF, "" )
   end if

RETURN ( cRet )

//---------------------------------------------------------------------------//

function VisTik( cFile )

   local oMemo
   local oDlg
   local cText
   local oFont

   if !File( cFile )
      MsgStop( "No existe fichero " + cFile )
      Return .f.
   end if

   oFont       := TFont():New( "Courier" )
   cText       := Memoread( cFile )

   DEFINE DIALOG oDlg TITLE "Previsulizar impresión" RESOURCE "PREVDOC"

   REDEFINE GET oMemo VAR cText ;
      MEMO ;
      READONLY ;
      ID       100  ;
      OF       oDlg ;
      FONT     oFont

   REDEFINE BUTTON;
      ID       IDOK ;
      OF       oDlg ;
      CANCEL ;
      ACTION   ( oDlg:End() )

   oDlg:AddFastKey( VK_F5, {|| oDlg:End() } )

   oDlg:bStart := { || oMemo:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER

   oFont:end()

return nil

//---------------------------------------------------------------------------//