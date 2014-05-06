#include "FiveWin.Ch"
#include "Ini.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

#define HTCAPTION                         2

#define WM_NCHITTEST                      0x0084
#define WM_ERASEBKGND                     0x0014
#define WM_LBUTTONDBLCLK                  515    // 0x203

#define DT_BOTTOM                         8
#define DT_CALCRECT                       1024
#define DT_CENTER                         1
#define DT_END_ELLIPSIS                   0x00008000
#define DT_EXPANDTABS                     64
#define DT_EXTERNALLEADING                512
#define DT_INTERNAL                       4096
#define DT_LEFT                           0
#define DT_NOCLIP                         256
#define DT_NOPREFIX                       2048
#define DT_RIGHT                          2
#define DT_SINGLELINE                     32
#define DT_TABSTOP                        128
#define DT_TOP                            0
#define DT_VCENTER                        4
#define DT_WORDBREAK                      16
#define DT_WORD_ELLIPSIS                  0x00040000

#define BITMAP_HANDLE                     1
#define BITMAP_PALETTE                    2
#define BITMAP_WIDTH                      3
#define BITMAP_HEIGHT                     4
#define BITMAP_ZEROCLR                    5

#define CLRTEXTBACK                       RGB( 113, 106, 183 )

//---------------------------------------------------------------------------//

#define itmMesaRedonda                    1
#define itmMesaEliptica                   2
#define itmMesaCuadrada                   3
#define itmMesaRectangular                4

#define itmBarrraHorizontal               5
#define itmBarrraVertical                 6
#define itmBarrraEsquinaDerechaAbajo      7
#define itmBarrraEsquinaIzquierdaAbajo    8
#define itmBarrraEsquinaDerechaArriba     9
#define itmBarrraEsquinaIzquierdaArriba   10

#define itmPlantaBlanca                   11
#define itmPlantaAmarilla                 12
#define itmPlantaAzul                     13
#define itmPlantaRoja                     14

#define itmPanelHorizontal                15
#define itmPanelVertical                  16
#define itmPanelCruce                     17
#define itmPanelConexionAbajo             18
#define itmPanelConexionArriba            19
#define itmPanelConexionDerecha           20
#define itmPanelConexionIzquierda         21
#define itmPanelCurvaAbajo                22
#define itmPanelCurvaDerecha              23
#define itmPanelCurvaIzquierda            24
#define itmPanelCurvaArriba               25

#define itmGenerico                       26
#define itmLlevar                         27
#define itmNewGenerico                    28
#define itmNewLlevar                      29
#define itmRecoger                        30
#define itmEncargar                       31

#define itmStateLibre                     1
#define itmStateOcupada                   2

#define ubiGeneral                        0
#define ubiLlevar                         1
#define ubiSala                           2
#define ubiRecoger                        3
#define ubiEncargar                       4

#define stateMesaLibre                    1
#define stateMesaOcupada                  2

#define NINICIO                           0
#define NROWINSERT                        28
#define NCOLINSERT                        2

//---------------------------------------------------------------------------//

CLASS sTpvPunto

   DATA oSender

   DATA nNumero            INIT 0

   DATA oSala

   DATA cCodigoSala
   DATA cPuntoVenta

   DATA cAlias             INIT ""
   DATA cNombre            INIT ""

   DATA nEstado            INIT 1

   DATA cSerie             INIT ""
   DATA cNumero            INIT ""
   DATA cSufijo            INIT ""

   DATA cImagen
   DATA nPrecio
   DATA nPreCmb

   DATA nTotal             INIT 0
   DATA cTotal             INIT ""

   DATA cToolTip           INIT ""

   DATA lAbierto
   DATA nUbicacion

   DATA lMultiple          INIT .f.

   DATA nType

   DATA nTop               INIT 0
   DATA nLeft              INIT 0
   DATA nHeight            INIT 160
   DATA nWidth             INIT 100

   DATA oSalon

   DATA oMesa

   Method CreateFromSala( nNumero, oSender )
   Method CreateFromSalon( nNumero, oSender )

   Method CreateMesa()
   Method LoadMesa()

   Method Llevar()

   Method Encargar()

   Method cPunto()         INLINE ( ::cCodigoSala + ::cPuntoVenta )
   Method cSala()          INLINE ( ::cCodigoSala )

   Method cTiket()         INLINE ( ::cSerie + ::cNumero + ::cSufijo )
   Method cTextoTiket()    INLINE ( ::cSerie + "/" + Alltrim( ::cNumero ) + "/" + Alltrim( ::cSufijo ) )

   Method cTextoPunto()
   Method cImagenPunto( nItem )

   Method cTexto()         INLINE ( if( !Empty( ::cPuntoVenta ), ::cTextoPunto(), ::cTextoTiket() ) )

   Method lGenerico()      INLINE ( ::nUbicacion == ubiGeneral )
   Method lLlevar()        INLINE ( ::nUbicacion == ubiLlevar )
   Method lRecoger()       INLINE ( ::nUbicacion == ubiRecoger )
   Method lEncargar()       INLINE ( ::nUbicacion == ubiEncargar )

   Method oTiketCabecera() INLINE ( ::oSender:oSender:oSender:oTiketCabecera )

   METHOD lMultipleTicket()

   METHOD nTotalMultipleTicket()

   //------------------------------------------------------------------------//

   Inline Method cTextoTotalTiket()

      local cTexto         := ::cTextoTiket() + CRLF
      cTexto               += "[ Total : " + lTrim( Trans( ::nTotal, cPorDiv() ) ) + cSimDiv() + " ]"

      Return ( cTexto )

   EndMethod

   //------------------------------------------------------------------------//

   Inline Method nImagenTiket( n )

      local nImagen        := ( ( ( n + 1 ) * 2 ) - 2 )

      if !Empty( ::cTiket() ) .and. ::lAbierto
         ++nImagen
      end if

      Return ( nImagen )

   EndMethod

   //------------------------------------------------------------------------//

   Inline Method cAliasTiket( n )

      local cTexto         := Upper( Rtrim( ::cAlias ) ) + CRLF
      cTexto               += "[ Total : " + lTrim( Trans( ::nTotal, cPorDiv() ) ) + cSimDiv() + " ]"

      Return ( cTexto )

   EndMethod

   //------------------------------------------------------------------------//

   Inline Method SetSalon( oSalon )
      ::oSalon                := oSalon
   EndMethod

   //------------------------------------------------------------------------//

   Method GetSalon( oSalon )  INLINE ( ::oSalon )
   Method GetSalonWnd()       INLINE ( ::oSalon:oWnd:oClient )

   //------------------------------------------------------------------------//

END CLASS

//---------------------------------------------------------------------------//
/*
oSender           -> sTpvRestaurante
oSender:oSender   -> sTpvSala
*/

Method CreateFromSala( nNumero, oSender ) CLASS sTpvPunto

   ::nNumero         := nNumero
   ::oSender         := oSender

   ::SetSalon( ::oSender:oSender:oSalon )

   ::cPuntoVenta     := ::oSender:oSender:oDetSalaVta:oDbf:FieldGetByName( "cDescrip" )
   ::nType           := ::oSender:oSender:oDetSalaVta:oDbf:FieldGetByName( "nTipo"    )
   ::nTop            := ::oSender:oSender:oDetSalaVta:oDbf:FieldGetByName( "nFila"    )
   ::nLeft           := ::oSender:oSender:oDetSalaVta:oDbf:FieldGetByName( "nColumna" )

   ::cCodigoSala     := ::oSender:cCodigo
   ::nPrecio         := ::oSender:nPrecio
   ::nPreCmb         := ::oSender:nPreCmb
   ::nUbicacion      := ubiSala

   ::cImagen         := ::cImagenPunto( ::nType )

Return ( Self )

//---------------------------------------------------------------------------//
/*
Crea la mesa-------------------------------------------------------------------
*/

Method CreateMesa( lPuntosPendientes ) CLASS sTpvPunto

   local oMesa       := TTpvMesa():New( ::nTop, ::nLeft, ::nType, ::GetSalonWnd() )

   oMesa:LoadFromPunto( Self )

   if !Empty( oMesa ) .and. IsChar( oMesa:cPuntoVenta )

      if ( IsTrue( lPuntosPendientes ) .and. ::nEstado <= 1 )
         oMesa:Disable()
      end if

      if ( IsFalse( lPuntosPendientes ) .and. ::nEstado > 1 )
         oMesa:Disable()
      end if

      ::oMesa        := oMesa

   end if

Return ( Self )

//---------------------------------------------------------------------------//

Method CreateFromSalon( nNumero, oSender ) CLASS sTpvPunto

   ::nNumero         := nNumero

   ::oSender         := oSender

   ::SetSalon( oSender )

   ::nTop            := oSender:nTop
   ::nLeft           := oSender:nLeft
   ::nType           := oSender:nType

   ::cSerie          := oSender:oSender:oSender:oTiketCabecera:FieldGetByName( "cSerTik"   )
   ::cNumero         := oSender:oSender:oSender:oTiketCabecera:FieldGetByName( "cNumTik"   )
   ::cSufijo         := oSender:oSender:oSender:oTiketCabecera:FieldGetByName( "cSufTik"   )
   ::cCodigoSala     := oSender:oSender:oSender:oTiketCabecera:FieldGetByName( "cCodSala"  )
   ::cPuntoVenta     := oSender:oSender:oSender:oTiketCabecera:FieldGetByName( "cPntVenta" )
   ::cAlias          := oSender:oSender:oSender:oTiketCabecera:FieldGetByName( "cAliasTik" )
   ::cNombre         := oSender:oSender:oSender:oTiketCabecera:FieldGetByName( "cNomTik"   )
   ::nPrecio         := oSender:oSender:oSender:oTiketCabecera:FieldGetByName( "nTarifa"   )
   ::nTotal          := oSender:oSender:oSender:oTiketCabecera:FieldGetByName( "nTotTik"   )
   ::lAbierto        := oSender:oSender:oSender:oTiketCabecera:FieldGetByName( "lAbierto"  )
   ::nUbicacion      := oSender:oSender:oSender:oTiketCabecera:FieldGetByName( "nUbiTik"   )

   ::nPreCmb         := uFieldEmpresa( "nPreTCmb" )

Return ( Self )

//---------------------------------------------------------------------------//

Method Llevar( dbfTikT ) CLASS sTpvPunto

   ::nNumero         := 0

   if !Empty( dbfTikT )
      ::cSerie       := ( dbfTikT )->cSerTik
      ::cNumero      := ( dbfTikT )->cNumTik
      ::cSufijo      := ( dbfTikT )->cSufTik
      ::cAlias       := ( dbfTikT )->cAliasTik
   else
      ::cSerie       := ""
      ::cNumero      := ""
      ::cSufijo      := ""
      ::cAlias       := ""
   end if

   ::cCodigoSala     := ""
   ::cPuntoVenta     := "Llevar"

   if !Empty( uFieldEmpresa( "nPreTPro" ) )
      ::nPrecio      := Max( uFieldEmpresa( "nPreTPro" ), 1 )
   else
      ::nPrecio      := 1
   end if

   if !Empty( uFieldEmpresa( "nPreTCmb" ) )
      ::nPreCmb      := Max( uFieldEmpresa( "nPreTCmb" ), 1 )
   else
      ::nPreCmb      := 1
   end if

   ::cImagen         := "Wheel_32"
   ::oSala           := nil

Return ( Self )

//---------------------------------------------------------------------------//

Method Encargar( dbfTikT ) CLASS sTpvPunto

   ::nNumero         := 0

   if !Empty( dbfTikT )
      ::cSerie       := ( dbfTikT )->cSerTik
      ::cNumero      := ( dbfTikT )->cNumTik
      ::cSufijo      := ( dbfTikT )->cSufTik
      ::cAlias       := ( dbfTikT )->cAliasTik
   else
      ::cSerie       := ""
      ::cNumero      := ""
      ::cSufijo      := ""
      ::cAlias       := ""
   end if

   ::cCodigoSala     := ""
   ::cPuntoVenta     := "Encargar"

   if !Empty( uFieldEmpresa( "nPreTPro" ) )
      ::nPrecio      := Max( uFieldEmpresa( "nPreTPro" ), 1 )
   else
      ::nPrecio      := 1
   end if

   if !Empty( uFieldEmpresa( "nPreTCmb" ) )
      ::nPreCmb      := Max( uFieldEmpresa( "nPreTCmb" ), 1 )
   else
      ::nPreCmb      := 1
   end if

   ::cImagen         := "address_book2_32"
   ::oSala           := nil

Return ( Self )

//---------------------------------------------------------------------------//

Method cTextoPunto() CLASS sTpvPunto

   local cTextoPunto := ""

   if !Empty( ::cPuntoVenta )
      cTextoPunto    += Alltrim( ::cPuntoVenta )
   else
      if !Empty( ::oSala )
         cTextoPunto += Alltrim( ::oSala:cDescripcion )
      end if
   end if

Return ( cTextoPunto )

//---------------------------------------------------------------------------//

Method cImagenPunto( nItem ) CLASS sTpvPunto

   do case
      case nItem == itmMesaRedonda
         Return ( "Shape_circle_32" )

      case nItem == itmMesaEliptica
         Return ( "Shape_ellipse_32" )

      case nItem == itmMesaCuadrada
         Return ( "Shape_square_32" )

      case nItem == itmMesaRectangular
         Return ( "Shape_rectangle_32" )

      case nItem == itmBarrraHorizontal
         Return ( "Bar_center_32" )

      case nItem == itmBarrraVertical
         Return ( "Bar_left_32" )

      case nItem == itmBarrraEsquinaDerechaAbajo
         Return ( "Bar_corner_left_32" )

      case nItem == itmBarrraEsquinaIzquierdaAbajo
         Return ( "Bar_corner_right_32" )

      case nItem == itmBarrraEsquinaDerechaArriba
         Return ( "Bar_corner_top_left_32" )

      case nItem == itmBarrraEsquinaIzquierdaArriba
         Return ( "Bar_corner_top_right_32" )

   end case

Return ( "" )

//---------------------------------------------------------------------------//

Method LoadMesa() CLASS sTpvPunto

   local aStatus

   ::cSerie       := ""
   ::cNumero      := ""
   ::cSufijo      := ""
   ::cAlias       := ""
   ::cNombre      := ""
   ::nTotal       := 0
   ::nEstado      := 1
   ::lMultiple    := .f.

   aStatus        := ::oTiketCabecera():GetStatus()

   if ::oTiketCabecera():SeekInOrd( ::cPunto(), "cCodSal" )

      ::cSerie    := ::oTiketCabecera():FieldGetByName( "cSerTik"   )
      ::cNumero   := ::oTiketCabecera():FieldGetByName( "cNumTik"   )
      ::cSufijo   := ::oTiketCabecera():FieldGetByName( "cSufTik"   )
      ::cAlias    := ::oTiketCabecera():FieldGetByName( "cAliasTik" )
      ::cNombre   := ::oTiketCabecera():FieldGetByName( "cNomTik"   )
      ::nEstado   := if( ::oTiketCabecera():FieldGetByName( "lAbierto" ), 2, 3 )
      ::lMultiple := ::lMultipleTicket()

      if ::lMultiple 
         ::nTotal := ::nTotalMultipleTicket()
      else
         ::nTotal := ::oTiketCabecera():FieldGetByName( "nTotTik"   )   
      end if

   end if

   ::oTiketCabecera():SetStatus( aStatus )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD lMultipleTicket()

   local lMultiple   := .t.
   local aNumeros    := {}

   with object ( ::oTiketCabecera() )
      
      :GetStatus()

      :OrdSetFocus( "cCodSal" )

      if :Seek( ::cCodigoSala + Padr( ::cPuntoVenta, 30 ) )

         while :FieldGetByName( "cCodSala" ) + :FieldGetByName( "cPntVenta" ) == ::cCodigoSala + Padr( ::cPuntoVenta, 30 ) .and. !:Eof()

            aAdd( aNumeros, :FieldGetByName( "cSerTik" ) + :FieldGetByName( "cNumTik" ) + :FieldGetByName( "cSufTik" ) )

            :Skip()

         end while

      end if

      :SetStatus()

   end with

Return ( Len( aNumeros ) > 1 )

//---------------------------------------------------------------------------//

METHOD nTotalMultipleTicket()

   local nTotal         := 0

   with object ( ::oTiketCabecera() )
      
      :GetStatus()

      :OrdSetFocus( "cCodSal" )

      if :Seek( ::cCodigoSala + Padr( ::cPuntoVenta, 30 ) )

         while :FieldGetByName( "cCodSala" ) + :FieldGetByName( "cPntVenta" ) == ::cCodigoSala + Padr( ::cPuntoVenta, 30 ) .and. !:Eof()

            nTotal      += :FieldGetByName( "nTotTik" )

            :Skip()

         end while

      end if

      :SetStatus()

   end with

Return nTotal

//---------------------------------------------------------------------------//