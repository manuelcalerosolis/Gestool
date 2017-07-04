#include "FiveWin.Ch"
#include "Ini.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

#define HTCAPTION                            2

#define WM_NCHITTEST                         0x0084
#define WM_ERASEBKGND                        0x0014
#define WM_LBUTTONDBLCLK                     515    // 0x203

#define DT_BOTTOM                            8
#define DT_CALCRECT                          1024
#define DT_CENTER                            1
#define DT_END_ELLIPSIS                      0x00008000
#define DT_EXPANDTABS                        64
#define DT_EXTERNALLEADING                   512
#define DT_INTERNAL                          4096
#define DT_LEFT                              0
#define DT_NOCLIP                            256
#define DT_NOPREFIX                          2048
#define DT_RIGHT                             2
#define DT_SINGLELINE                        32
#define DT_TABSTOP                           128
#define DT_TOP                               0
#define DT_VCENTER                           4
#define DT_WORDBREAK                         16
#define DT_WORD_ELLIPSIS                     0x00040000

#define BITMAP_HANDLE                        1
#define BITMAP_PALETTE                       2
#define BITMAP_WIDTH                         3
#define BITMAP_HEIGHT                        4
#define BITMAP_ZEROCLR                       5

#define CLRTEXTBACK                          RGB( 113, 106, 183 )

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
#define ubiRecoger                        2
#define ubiEncargar                       2

#define stateMesaLibre                    1
#define stateMesaOcupada                  2

#define NINICIO                           0
#define NROWINSERT                        28
#define NCOLINSERT                        2

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TTpvRestaurante FROM TMasDet

   DATA  oSender

   DATA  cMru     INIT "gc_cup_16"
   DATA  cBitmap  INIT "WebTopBlack"

   CLASSDATA aResource  AS ARRAY          INIT  {  "GC_BEER_BOTTLE_16"     ,;
                                                   "GC_BEER_GLASS_16"      ,;
                                                   "GC_WINE_BOTTLE_16"     ,;
                                                   "GC_WINE_GLASS_16"      ,;
                                                   "GC_COCKTAIL2_16"       ,;
                                                   "GC_LEMONADE_GLASS_16"  ,;
                                                   "GC_COCKTAIL_16"        ,;
                                                   "GC_ICE_CREAM2_16"      ,;
                                                   "GC_GOLDFISH_16"        ,;
                                                   "GC_PIG_16"             }

   CLASSDATA aBigResource  AS ARRAY       INIT {   "GC_BEER_BOTTLE_32"     ,;
                                                   "GC_BEER_GLASS_32"      ,;
                                                   "GC_WINE_BOTTLE_32"     ,;
                                                   "GC_WINE_GLASS_32"      ,;
                                                   "GC_COCKTAIL2_32"       ,;
                                                   "GC_LEMONADE_GLASS_32"  ,;
                                                   "GC_COCKTAIL_32"        ,;
                                                   "GC_ICE_CREAM2_32"      ,;
                                                   "GC_GOLDFISH_32"        ,;
                                                   "GC_PIG_32"             }

   CLASSDATA aImagen    AS ARRAY          INIT {   "Botella cerveza"    ,;
                                                   "Cerveza barril"     ,;
                                                   "Botella de tinto"   ,;
                                                   "Copa de tinto"      ,;
                                                   "Copa de blanco"     ,;
                                                   "Vaso de limonada"   ,;
                                                   "Cocktail"           ,;
                                                   "Helado"             ,;
                                                   "Pescado"            ,;
                                                   "Carne"              }

   DATA aPrecio         AS ARRAY          INIT {   uFieldEmpresa( "cTxtTar1", "Precio 1" ),;
                                                   uFieldEmpresa( "cTxtTar2", "Precio 2" ),;
                                                   uFieldEmpresa( "cTxtTar3", "Precio 3" ),;
                                                   uFieldEmpresa( "cTxtTar4", "Precio 4" ),;
                                                   uFieldEmpresa( "cTxtTar5", "Precio 5" ),;
                                                   uFieldEmpresa( "cTxtTar6", "Precio 6" ),;
                                                   "Precio por defecto" }

   CLASSDATA oDlgSalaVenta

   CLASSDATA aSalas        AS ARRAY    INIT {}
   CLASSDATA aTikets       AS ARRAY    INIT {}
   CLASSDATA oGenerico
   CLASSDATA oLlevar

   DATA oSalon
    
   DATA lMinimize          AS LOGIC    INIT .f.
   DATA lPuntosVenta
   DATA cInitialSala

   DATA oDetSalaVta        AS OBJECT

   DATA nTarifa            AS NUMERIC  INIT  1  

   DATA cSelectedSala

   DATA cSelectedPunto
   DATA oSelectedPunto

   DATA nSelectedUbicacion 

   DATA nSelectedPrecio    AS NUMERIC  INIT  1
   DATA nSelectedCombinado AS NUMERIC  INIT  2

   DATA cSelectedTiket

   DATA cSelectedImagen
   DATA cSelectedTexto

   DATA lComensal          AS LOGIC    INIT .f.
   DATA cArticulo
   DATA lMultiplicar       AS LOGIC    INIT .f.

   METHOD New( cPath, oWndParent, oMenuItem )
   METHOD Create( cPath )

   METHOD SetSender( oSender )   INLINE ( ::oSender := oSender )

   METHOD End()

   METHOD Selector( lPuntosPendientes, lLlevar )

   METHOD BuildSalas()
   METHOD InitSala()
   METHOD Sala( lPuntosPendientes )

   METHOD OpenFiles( lExclusive )
   MESSAGE OpenService( lExclusive )   METHOD OpenFiles( lExclusive )
   METHOD CloseFiles()
   METHOD DefineFiles()

   METHOD SetPunto( sPunto )

   METHOD cSelected()                  INLINE ( if( !empty( ::cSelectedSala ), ::cSelectedSala + ::cSelectedPunto, Space( 3 ) + ::cSelectedPunto ) )

   METHOD cTextoSala()

   METHOD SetTicket()

   METHOD Resource( nMode )

   METHOD lPreSave( nMode )

   METHOD Dialog()
   METHOD InitDialog( oImgUsr, oLstUsr )
   METHOD SelectDialog( nOpt, oDlg, oLstSala )

   METHOD Tikets()
   METHOD InitTikets( oImgUsr, oLstUsr )
   METHOD SelectTikets( nOpt, oDlg, oLstSala )

   METHOD Reset( oBtnTarifa )

   METHOD ConfigButton( oBtnTarifa )

   METHOD cTextoPunto( sSala, sPunto )
   METHOD cTextoGenerico( sPunto )
   METHOD cTextoTiket( sSala, sPunto )
   METHOD nStatePunto( sPunto )
   METHOD nImagenPunto( sPunto, n )
   METHOD nImagenTiket( sSala, sPunto, n )

   METHOD lCambiaPunto( cTiket ) INLINE ( !empty( ::cSelectedTiket ) .and. ( cTiket != ::cSelectedTiket ) )

   METHOD cSelectedTicket()      INLINE ( ::cSelectedTiket )

   METHOD SetSelected( aTmp )
   METHOD SetSelectedImagen()
   METHOD SetSelectedTexto()

   METHOD SetGenerico( sPunto )
   METHOD SetLlevar( sPunto )

   METHOD lLlevar()              INLINE ( empty( ::cSelectedSala ) .and. AllTrim( ::cSelectedPunto ) == "Llevar" )
   METHOD lGeneric()             INLINE ( !::lNotGeneric() )
   METHOD lNotGeneric()          INLINE ( !empty( ::cSelectedSala ) .and. !empty( ::cSelectedPunto ) )

   METHOD cImagen()              INLINE ( ::aImagen[ Min( Max( ::oDbf:nImagen, 1 ), len( ::aImagen ) ) ] )
   METHOD cPrecio()              INLINE ( ::aPrecio[ Min( Max( ::oDbf:nPrecio, 1 ), len( ::aPrecio ) ) ] )
   METHOD cPrecioCombinado()     INLINE ( ::aPrecio[ Min( Max( ::oDbf:nPreCmb, 1 ), len( ::aPrecio ) ) ] )
   METHOD cResource()            INLINE ( ::aResource[ Min( Max( ::oDbf:nImagen, 1 ), len( ::aResource ) ) ] )
   METHOD cBigResource()         INLINE ( ::aBigResource[ Min( Max( ::oDbf:nImagen, 1 ), len( ::aBigResource ) ) ] )

   METHOD cTextoPrecio( nPrecio )

   METHOD GetSelectedTexto()

   METHOD SetSalaVta( aTmp, dbfTikT )

   METHOD SelectedPrecio( nPrecio )       INLINE ( if(   !empty( nPrecio ),;
                                                         ::nSelectedPrecio    := if( nPrecio == 7, Max( uFieldEmpresa( "nPreTPro" ), 1 ), nPrecio ),;
                                                         ::nSelectedPrecio ) )

   METHOD SelectedCombinado( nPrecio )    INLINE ( if(   !empty( nPrecio ),;
                                                         ::nSelectedCombinado := if( nPrecio == 7, Max( uFieldEmpresa( "nPreTCmb" ), 1 ), nPrecio ),;
                                                         ::nSelectedCombinado ) )

END CLASS

//----------------------------------------------------------------------------//

METHOD New( cPath, cDriver, oWndParent, oMenuItem ) CLASS TTpvRestaurante

   DEFAULT cPath           := cPatEmp()
   DEFAULT cDriver         := cDriver()

   DEFAULT oWndParent      := GetWndFrame()

   if oMenuItem != nil .and. ::nLevel == nil
      ::nLevel             := nLevelUsr( oMenuItem )
   else
      ::nLevel             := 0
   end if

   ::Create( cPath, cDriver )
   ::oWndParent            := oWndParent

   ::bFirstKey             := {|| ::oDbf:cCodigo }

   ::oSalon                := TTpvSalon():New( Self )

   ::oDetSalaVta           := TDetSalaVenta():New( cPath, cDriver, Self )
   ::AddDetail( ::oDetSalaVta )

   ::SelectedPrecio(    Max( uFieldEmpresa( "nPreTPro" ), 1 ) )
   ::SelectedCombinado( Max( uFieldEmpresa( "nPreTCmb" ), 1 ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Create( cPath, cDriver ) CLASS TTpvRestaurante

   DEFAULT cPath           := cPatEmp()
   DEFAULT cDriver         := cDriver()

   ::cPath                 := cPath
   ::cDriver               := cDriver

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Selector( lPuntosPendientes, lLlevar, nSelectOption ) CLASS TTpvRestaurante

   local lSelector         := .t.

   if ::oSalon:Selector( lPuntosPendientes, lLlevar, nSelectOption )

      if !empty( ::oSalon:oSelectedPunto )

         if ::oSalon:oSelectedPunto:lGenerico()

            ::SetGenerico( ::oSalon:oSelectedPunto )

         else

            // Vamos a ver si en esta ubicacion hay tickets-----------------------

            if !empty( ::oSalon:oSelectedPunto:cTiket() )
               ::SetTicket()
            else
               ::SetPunto( ::oSalon:oSelectedPunto )
            end if

         end if

      else

         lSelector         := .f.

      end if

   else

      lSelector            := .f.

   end if

Return ( lSelector )

//---------------------------------------------------------------------------//
//
// Han seleccionado un ticket
//

METHOD SetTicket() CLASS TTpvRestaurante

   local aStatus

   aStatus                             := ::oSender:oTiketCabecera:GetStatus()

   if ::oSender:oTiketCabecera:SeekInOrd( ::oSalon:oSelectedPunto:cTiket(), "cNumTik" )

      ::oSelectedPunto                 := ::oSalon:oSelectedPunto

      ::oSelectedPunto:cSerie          := ::oSender:oTiketCabecera:FieldGetByName( "cSerTik" )
      ::oSelectedPunto:cNumero         := ::oSender:oTiketCabecera:FieldGetByName( "cNumTik" )
      ::oSelectedPunto:cSufijo         := ::oSender:oTiketCabecera:FieldGetByName( "cSufTik" )
      ::oSelectedPunto:cAlias          := ::oSender:oTiketCabecera:FieldGetByName( "cAliasTik" )

      if !empty( ::oSender:oTiketCabecera:FieldGetByName( "nTarifa" ) )
         ::oSelectedPunto:nPrecio      := ::oSender:oTiketCabecera:FieldGetByName( "nTarifa" )
      end if
      
      if !empty( ::oSender:oTiketCabecera:FieldGetByName( "cCodSala" ) )
         ::oSelectedPunto:cCodigoSala  := ::oSender:oTiketCabecera:FieldGetByName( "cCodSala" )
      end if
      
      if !empty( ::oSender:oTiketCabecera:FieldGetByName( "cPntVenta" ) )
         ::oSelectedPunto:cPuntoVenta  := ::oSender:oTiketCabecera:FieldGetByName( "cPntVenta" )
      end if

      /*
      Rellenamos los datos-----------------------------------------------
      */

      ::cSelectedSala                  := ::oSelectedPunto:cSala
      ::cSelectedPunto                 := ::oSelectedPunto:cPuntoVenta
      ::nSelectedUbicacion             := ::oSelectedPunto:nUbicacion
      ::cSelectedImagen                := ::oSelectedPunto:cImagen
      ::lComensal                      := ::oSelectedPunto:lComensal
      ::cArticulo                      := ::oSelectedPunto:cArticulo
      ::lMultiplicar                   := ::oSelectedPunto:lMultiplicar

      ::SelectedPrecio(    ::oSelectedPunto:nPrecio )
      ::SelectedCombinado( ::oSelectedPunto:nPreCmb )

      ::cSelectedTiket                 := ::oSelectedPunto:cTiket()
      ::cSelectedTexto                 := ::oSelectedPunto:cTextoPunto()

      ::SetSelectedImagen()
      ::SetSelectedTexto()

   end if

   ::oSender:oTiketCabecera:SetStatus( aStatus )   

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Sala( lPuntosPendientes, lLlevar, nSelectOption ) CLASS TTpvRestaurante

   if Len( ::aSalas ) < 1
      MsgStop( "No existen salas de ventas para seleccionar" )
      Return .f.
   end if

   do case
      case IsTrue( ::lPuntosVenta )

         Return ( ::Selector( lPuntosPendientes, lLlevar, nSelectOption ) )

      case IsFalse( ::lPuntosVenta )

         ++::nTarifa

         if ::nTarifa > len( ::aSalas )
            ::nTarifa         := 1
         end if

         ::cSelectedTiket     := ""
         ::cSelectedPunto     := ""
         ::oSelectedPunto     := nil

         ::lComensal          := .f.

         ::cSelectedSala      := ::aSalas[ ::nTarifa ]:cCodigo
         ::cSelectedImagen    := ::aSalas[ ::nTarifa ]:cImagen
         ::cSelectedTexto     := ::aSalas[ ::nTarifa ]:cDescripcion

         ::SelectedPrecio(    ::aSalas[ ::nTarifa ]:nPrecio )
         ::SelectedCombinado( ::aSalas[ ::nTarifa ]:nPreCmb )

   end case

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD BuildSalas() CLASS TTpvRestaurante

   local n                 := 0
   local sSala

   ::cInitialSala          := nil
   ::aSalas                := {}
   ::lPuntosVenta          := .f.

   ::oDbf:GoTop()
   while !::oDbf:Eof()

      if empty( ::cInitialSala )
         ::cInitialSala    := ::oDbf:cCodigo
      end if

      sSala                := sTpvSala():New( Self ) // ::oDbf, ::cBigResource() )

      sSala:BuildPuntos()

      aAdd( ::aSalas, sSala )

      ::oDbf:Skip()

   end while

   /*
   Punto generico--------------------------------------------------------------
   */

   ::oGenerico             := sPunto():Generico()

   /*
   Punto para llevar-----------------------------------------------------------
   */

   ::oLlevar               := sPunto():Llevar()

   /*
   Valores por defecto---------------------------------------------------------
   */

   ::InitSala()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD InitSala() CLASS TTpvRestaurante

   do case
      case ( IsTrue( ::lPuntosVenta ) )

         ::SelectedPrecio(    Max( uFieldEmpresa( "nPreTPro" ), 1 ) )
         ::SelectedCombinado( Max( uFieldEmpresa( "nPreTCmb" ), 1 ) )

         ::cSelectedSala      := ""
         ::cSelectedTiket     := ""
         ::cSelectedImagen    := ""
         ::cSelectedTexto     := ""
         ::cSelectedPunto     := ""
         ::lComensal          := .f.
         ::oSelectedPunto     := nil

      case ( IsFalse( ::lPuntosVenta ) .and. ( len( ::aSalas ) > 0 ) )

         ::SelectedPrecio(    ::aSalas[ 1 ]:nPrecio )
         ::SelectedCombinado( ::aSalas[ 1 ]:nPreCmb )

         ::cSelectedSala      := ::aSalas[ 1 ]:cCodigo
         ::cSelectedImagen    := ::aSalas[ 1 ]:cImagen
         ::cSelectedTexto     := ::aSalas[ 1 ]:cDescripcion
         ::cSelectedTiket     := ""
         ::cSelectedPunto     := ""
         ::lComensal          := .f.
         ::oSelectedPunto     := nil

   end case

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive ) CLASS TTpvRestaurante

   local lOpen          := .t.
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lExclusive   := .f.

   BEGIN SEQUENCE

      if empty( ::oDbf )
         ::defineFiles()
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

      ::OpenDetails()

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos de las salas de ventas." )
      ::CloseFiles()
      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TTpvRestaurante

   if !empty( ::oDbf ) .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   if Valtype( ::oDbfDet ) == "A"
      aSend( ::oDbfDet, "End()" )
   end if

   if Valtype( ::oDbfDet ) == "O"
      ::oDbfDet:End()
   end if

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver ) CLASS TTpvRestaurante

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := ::cDriver

   DEFINE TABLE ::oDbf FILE "SalaVta.Dbf" CLASS "SalaVta" ALIAS "SalaVta" PATH ( cPath ) VIA ( cDriver ) COMMENT "Sala de ventas"

      FIELD NAME "cCodigo"       TYPE "C" LEN  3  DEC 0 COMMENT "Código"            DEFAULT Space( 3 )   COLSIZE 100    OF ::oDbf
      FIELD NAME "cDescrip"      TYPE "C" LEN 35  DEC 0 COMMENT "Nombre"            DEFAULT Space( 35 )  COLSIZE 400    OF ::oDbf
      FIELD NAME "lSala"         TYPE "L" LEN  1  DEC 0 COMMENT "Sala"              HIDE                                OF ::oDbf
      FIELD NAME "cSala"         TYPE "C" LEN  3  DEC 0 COMMENT "Código sala"       HIDE                                OF ::oDbf
      FIELD NAME "nPrecio"       TYPE "N" LEN  1  DEC 0 COMMENT "Precios sala"      HIDE                                OF ::oDbf
      FIELD NAME "nImagen"       TYPE "N" LEN  2  DEC 0 COMMENT "Imagen"            HIDE                                OF ::oDbf
      FIELD NAME "nPreCmb"       TYPE "N" LEN  1  DEC 0 COMMENT "Precio Combinado"  HIDE                                OF ::oDbf
      FIELD NAME "lComensal"     TYPE "L" LEN  1  DEC 0 COMMENT "Solicitar comensales"                HIDE              OF ::oDbf
      FIELD NAME "cArticulo"     TYPE "C" LEN 18  DEC 0 COMMENT "Artículo"                            HIDE              OF ::oDbf
      FIELD NAME "lMultipli"     TYPE "L" LEN  1  DEC 0 COMMENT "Multiplicar artículo por comensal"   HIDE              OF ::oDbf

      INDEX TO "SalaVta.Cdx" TAG "cCodigo"      ON "cCodigo"      COMMENT "Código" NODELETED                            OF ::oDbf
      INDEX TO "SalaVta.Cdx" TAG "cDescrip"     ON "cDescrip"     COMMENT "Nombre" NODELETED                            OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//---------------------------------------------------------------------------//

METHOD End() CLASS TTpvRestaurante

   if !empty( ::oSalon )
      ::oSalon:End()
   end if

   ::oSalon    := nil

Return ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS TTpvRestaurante

	local oDlg
   local oGet
   local oArticulo
   local oCmbImagen
   local cCmbImagen     := ::cImagen()
   local oCmbPrecio
   local cCmbPrecio
   local oCmbPreCmb
   local cCmbPreCmb
   local oBrwDetSalaVta

   if nMode == APPD_MODE
      cCmbPrecio        := ::aPrecio[ Min( Max( uFieldEmpresa( "nPreTPro" ), 1 ), len( ::aPrecio ) ) ]
      cCmbPreCmb        := ::aPrecio[ Min( Max( uFieldEmpresa( "nPreTCmb" ), 1 ), len( ::aPrecio ) ) ]
   else
      cCmbPrecio        := ::cPrecio()
      cCmbPreCmb        := ::cPrecioCombinado()
   end if

   DEFINE DIALOG oDlg RESOURCE "SalaVentas" TITLE LblTitle( nMode ) + "sala de ventas"

      REDEFINE GET oGet VAR ::oDbf:cCodigo;
         ID       100 ;
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    ( NotValid( oGet, ::oDbf:cAlias, .t., "0" ) ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cDescrip ;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE COMBOBOX oCmbImagen VAR cCmbImagen ;
         ID       120;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ITEMS    ::aImagen ;
         BITMAPS  ::aResource

      REDEFINE COMBOBOX oCmbPrecio VAR cCmbPrecio ;
         ID       130;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ITEMS    ::aPrecio

      REDEFINE COMBOBOX oCmbPreCmb VAR cCmbPreCmb ;
         ID       140;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ITEMS    ::aPrecio

      REDEFINE CHECKBOX ::oDbf:lComensal ;
         ID       150 ;
         OF       oDlg

      REDEFINE GET oArticulo VAR ::oDbf:cArticulo ;
         ID       160 ;
         IDTEXT   161 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         BITMAP   "LUPA" ;
         VALID    cArticulo( oArticulo, nil, oArticulo:oHelpText );
         ON HELP  brwArticulo( oArticulo, oArticulo:oHelpText );
         OF       oDlg

      REDEFINE CHECKBOX ::oDbf:lMultipli ;
         WHEN     ( nMode != ZOOM_MODE .and. ::oDbf:lComensal ) ;
         ID       170 ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       503 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oSalon:Design( Self, oDlg ) )

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( if( ::lPreSave( nMode, oCmbImagen, oCmbPrecio, oCmbPreCmb ), oDlg:end( IDOK ), ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F3, {|| ::oSalon:Design( ::oDetSalaVta:oDbfVir, oDlg ) } )
         oDlg:AddFastKey( VK_F5, {|| if( ::lPreSave( nMode, oCmbImagen, oCmbPrecio, oCmbPreCmb ), oDlg:end( IDOK ), ) } )
      end if

      oDlg:bStart := { || oArticulo:lValid(), oGet:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD lPreSave( nMode, oCmbImagen, oCmbPrecio, oCmbPreCmb ) CLASS TTpvRestaurante

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if ::oDbf:seekInOrd( ::oDbf:cCodigo, "cCodigo" )
         msgStop( "Código ya existe " + Rtrim( ::oDbf:cCodigo ) )
         Return .f.
      end if

   end if

   if empty( ::oDbf:cDescrip )
      msgStop( "La descripción de la sala no puede estar vacía." )
      Return .f.
   end if

   ::oDbf:nImagen := oCmbImagen:nAt
   ::oDbf:nPrecio := oCmbPrecio:nAt
   ::oDbf:nPreCmb := oCmbPreCmb:nAt

Return .t.

//--------------------------------------------------------------------------//

METHOD Dialog( oBtnTarifa, lPuntosLibres ) CLASS TTpvRestaurante

   local oDlg
   local oImgSala
   local oLstSala

   DEFAULT lPuntosLibres   := .f.

   DEFINE DIALOG oDlg RESOURCE "SelectSalaVta"

      oImgSala             := TImageList():New( 44, 44 )

      oLstSala             := TListView():Redefine( 100, oDlg )
      oLstSala:nOption     := 0
      oLstSala:bAction     := {| nOpt | ::SelectDialog( nOpt, oDlg, oBtnTarifa, lPuntosLibres ) }

      REDEFINE BUTTONBMP ;
         ID       500 ;
         OF       oDlg ;
         ACTION   ( ::InitSala(), oDlg:end() );
         BITMAP   "gc_cup_48" ;

      REDEFINE BUTTONBMP ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( ::InitSala(), oDlg:end() );
         BITMAP   "gc_delete_48" ;

   oDlg:Activate( , , , .t., , , {|| ::InitDialog( oImgSala, oLstSala, lPuntosLibres ) } )

Return ( Self )

//--------------------------------------------------------------------------//

METHOD InitDialog( oImgSala, oLstSala, lPuntosLibres ) CLASS TTpvRestaurante

   local n                 := 0
   local sSala
   local sPunto
   local cPunto

   DEFAULT lPuntosLibres   := .f.

   oLstSala:SetImageList( oImgSala )

   oLstSala:EnableGroupView()

   for each sSala in ::aSalas

      oImgSala:AddMasked( TBitmap():Define( sSala:cImagen ), Rgb( 255, 0, 255 ) )

      oLstSala:InsertGroup( n, sSala:cDescripcion )

      for each sPunto in sSala:aPunto

         if lPuntosLibres

            oLstSala:InsertItemGroup( ::nImagenPunto( sPunto, n ), ::cTextoPunto( sPunto ), n )

         else

            oLstSala:InsertItemGroup( ::nImagenPunto( sPunto, n ), ::cTextoPunto( sPunto ), n )

         end if

      next

      n++

   next

Return ( Self )

//---------------------------------------------------------------------------//

METHOD SelectDialog( nOpt, oDlg, oBtnTarifa, lPuntosLibres ) CLASS TTpvRestaurante

   local sSala
   local sPunto

   DEFAULT lPuntosLibres         := .f.

   for each sSala in ::aSalas

      for each sPunto in sSala:aPunto

         if sPunto:nNumero == nOpt

            ::oSelectedPunto     := sPunto

            /*
            Vamos a ver si en esta ubicacion hay tickets-----------------------
            */

            if ::oSender:oTiketCabecera:SeekInOrd( sPunto:cPunto(), "cCodSal" )

               if lPuntosLibres
                  msgStop( "El punto de venta esta actualmente ocupado." )
                  Return ( Self )
               end if

               ::SetSelected( .t., sPunto )

            else

               ::SetSelected( .f., sPunto )

            end if

            oDlg:End()

         end if

      next

   next

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Tikets( oBtnTarifa, oBtnRenombrar ) CLASS TTpvRestaurante

   local oDlg
   local oImgSala
   local oLstSala

   DEFINE DIALOG oDlg RESOURCE "SelectTickets"

      oImgSala          := TImageList():New( 46, 46 )

      oLstSala          := TListView():Redefine( 100, oDlg )
      oLstSala:nOption  := 0
      oLstSala:bAction  := {| nOpt | ::SelectTikets( nOpt, oDlg, oBtnTarifa, oBtnRenombrar ) }

      REDEFINE BUTTONBMP ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:end() );
         BITMAP   "gc_delete_48" ;

   oDlg:Activate( , , , .t., , , {|| ::InitTikets( oImgSala, oLstSala ) } )

Return ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD InitTikets( oImgSala, oLstSala ) CLASS TTpvRestaurante

   local n           := 0
   local nOrd
   local sSala
   local sPunto
   local nLastGroup

   /*
   Cargamos los datos en una tabla --------------------------------------------
   */

   ::aTikets         := {}

   oLstSala:SetImageList( oImgSala )

   oLstSala:EnableGroupView()

   do case
      case ( IsNil( ::lPuntosVenta ) )

         oImgSala:AddMasked( TBitmap():Define( "gc_cup_48" ), Rgb( 255, 0, 255 ) )

         oLstSala:InsertGroup( 0, "Tickets pendientes" )

         nOrd        := ::oSender:oTiketCabecera:OrdSetFocus( "cCodSal" )

         ::oSender:oTiketCabecera:OrdSetFocus:GoTop()
         while !( ::oSender:oTiketCabecera:Eof() )

            sPunto   := sTpvPunto():New( n++, sSala, Self )

            oLstSala:InsertItemGroup( 0, sPunto:cTextoTotalTiket(), 0 )

            aAdd( ::aTikets, sPunto )

            ::oSender:oTiketCabecera:Skip()

         end while

         ::oSender:oTiketCabecera:OrdSetFocus( nOrd )

      case ( IsFalse( ::lPuntosVenta ) )

         /*
         Orden actual----------------------------------------------------------------
         */

         ::oSender:oTiketCabecera:OrdSetFocus( "cCodSal" )

         /*
         Recorremos todas las salas--------------------------------------------------
         */

         for each sSala in ::aSalas

            oImgSala:AddMasked( TBitmap():Define( sSala:cImagen ),      Rgb( 255, 0, 255 ) )

            oLstSala:InsertGroup( hb_EnumIndex() - 1, sSala:cDescripcion )

            /*
            Buscamos si hay tikets pendientes en esta sala---------------------------
            */

            if ::oSender:oTiketCabecera:Seek( sSala:cCodigo )

               while ::oSender:oTiketCabecera:FieldGetByName( "cCodSala" ) == sSala:cCodigo .and. !::oSender:oTiketCabecera:eof()

                  sPunto   := sTpvPunto():New( n++, sSala, Self )

                  oLstSala:InsertItemGroup( sPunto:nImagenTiket( hb_EnumIndex() - 1 ), sPunto:cTextoTiket(), hb_EnumIndex() - 1 )

                  aAdd( ::aTikets, sPunto )

                  ::oSender:oTiketCabecera:Skip()

               end while

            end if

         next

         ::oSender:oTiketCabecera:OrdSetFocus( nOrd )

      case ( IsTrue( ::lPuntosVenta ) )

         /*
         Orden actual----------------------------------------------------------
         */

         nOrd     := ::oSender:oTiketCabecera:OrdSetFocus( "cCodSal" )

         /*
         Recorremos todas las salas--------------------------------------------------
         */

         for each sSala in ::aSalas

            oImgSala:AddMasked( TBitmap():Define( sSala:cImagen ), Rgb( 255, 0, 255 ) )

            oLstSala:InsertGroup( hb_EnumIndex() - 1, sSala:cDescripcion )

            /*
            Buscamos si hay tikets pendientes en esta sala---------------------------
            */

            if ::oSender:oTiketCabecera:Seek( sSala:cCodigo )

               while ::oSender:oTiketCabecera:FieldGetByName( "cCodSala" ) == sSala:cCodigo .and. !::oSender:oTiketCabecera:eof()

                  if !empty( ::oSender:oTiketCabecera:FieldGetByName( "cPntVenta" ) )

                     sPunto   := sTpvPunto():New( n++, sSala, Self )

                     oLstSala:InsertItemGroup( sPunto:nImagenTiket( hb_EnumIndex() - 1 ), sPunto:cTextoTiket(), hb_EnumIndex() - 1 )

                     aAdd( ::aTikets, sPunto )

                  end if

                  ::oSender:oTiketCabecera:Skip()

               end while

            end if

            nLastGroup  := hb_EnumIndex()

         next

         /*
         Buscamos si hay tikets pendientes en la sala generica-----------------
         */

         oImgSala:AddMasked( TBitmap():Define( "gc_cup_48" ), Rgb( 255, 0, 255 ) )

         oLstSala:InsertGroup( nLastGroup, "General" )

         ::oSender:oTiketCabecera:GoTop()
         while !( ::oSender:oTiketCabecera:eof() )

            if empty( ::oSender:oTiketCabecera:FieldGetByName( "cPntVenta" ) )

               sPunto   := sTpvPunto():New( n++, nil, Self )

               oLstSala:InsertItemGroup( ( nLastGroup * 2 ), sPunto:cTextoGenerico(), nLastGroup )

               aAdd( ::aTikets, sPunto )

            end if

            ::oSender:oTiketCabecera:Skip()

         end while

         ::oSender:oTiketCabecera:OrdSetFocus( nOrd )

   end case

Return ( Self )

//---------------------------------------------------------------------------//

METHOD SelectTikets( nOpt, oDlg, oBtnTarifa, oBtnRenombrar ) CLASS TTpvRestaurante

   local sPunto            := ::aTikets[ Min( Max( nOpt, 1 ), len( ::aTikets ) ) ]

   ::SelectedPrecio( sPunto:nPrecio() )

   ::cSelectedSala         := sPunto:cSala()
   ::cSelectedTiket        := sPunto:cTiket()
   ::cSelectedImagen       := sPunto:cImagen()
   ::cSelectedTexto        := sPunto:cTextoPunto()
   ::cSelectedPunto        := sPunto:cPuntoVenta()
   ::oSelectedPunto        := sPunto

   ::ConfigButton( oBtnTarifa, oBtnRenombrar )

   oDlg:End( IDOK )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD ConfigButton( oBtnTarifa, oBtnRenombrar ) CLASS TTpvRestaurante

   do case
      case ( IsNil( ::lPuntosVenta ) )

         oBtnRenombrar:Hide()

      case IsFalse( ::lPuntosVenta )

         if empty( ::cSelectedImagen )
            oBtnTarifa:cBmp( "gc_cup_32" )
         else
            oBtnTarifa:cBmp( ::cSelectedImagen )
         end if

         if empty( ::cSelectedTexto )
            oBtnTarifa:cCaption( "General" )
         else
            oBtnTarifa:cCaption( ::cSelectedTexto )
         end if

         oBtnRenombrar:Hide()

      case IsTrue( ::lPuntosVenta )

         if empty( ::cSelectedImagen )
            oBtnTarifa:cBmp( "gc_cup_32" )
         else
            oBtnTarifa:cBmp( ::cSelectedImagen )
         end if

         if empty( ::cSelectedTexto )
            oBtnTarifa:cCaption( "General" )
         else
            oBtnTarifa:cCaption( ::cSelectedTexto )
         end if

         oBtnRenombrar:Show()

   end case

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Reset( oBtnTarifa ) CLASS TTpvRestaurante

   if !empty( oBtnTarifa )
      oBtnTarifa:cBmp( "gc_cup_48" )
      oBtnTarifa:cCaption( "General" )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD nImagenTiket( sSala, sPunto, n ) CLASS TTpvRestaurante

   local nImagen        := ( ( ( n + 1 ) * 2 ) - 2 )

   ::oSender:oTiketCabecera:GetStatus()

   if !empty( sPunto:cTiket() )
      if ( ::oSender:oTiketCabecera:SeekInOrd( sPunto:cTiket(), "cNumTik" ) ) .and. !( ::oSender:oTiketCabecera:FieldGetByName( "lAbierto" ) )
         ++nImagen
      end if
   end if

   ::oSender:oTiketCabecera:SetStatus()

RETURN ( nImagen )

//---------------------------------------------------------------------------//

METHOD nStatePunto( sPunto ) CLASS TTpvRestaurante

   local nImagen        := 1

   ::oSender:oTiketCabecera:GetStatus()

   if !empty( sPunto:cPunto() ) .and. !empty( sPunto:cPuntoVenta )

      if ( ::oSender:oTiketCabecera:SeekInOrd( sPunto:cPunto(), "cCodSal" ) ) .and. ( ::oSender:oTiketCabecera:FieldGetByName( "lAbierto" ) )
         ++nImagen
      end if

   end if

   ::oSender:oTiketCabecera:SetStatus()

RETURN ( nImagen )

//---------------------------------------------------------------------------//

METHOD nImagenPunto( sPunto, n ) CLASS TTpvRestaurante

   local nImagen        := ( ( ( n + 1 ) * 2 ) - 2 )

   ::oSender:oTiketCabecera:GetStatus()

      if !empty( sPunto:cPunto() )
         if ( ::oSender:oTiketCabecera:SeekInOrd( sPunto:cPunto(), "cCodSal" ) ) .and. !( ::oSender:oTiketCabecera:FieldGetByName( "lAbierto" ) )
            ++nImagen
         end if
      end if

   ::oSender:oTiketCabecera:SetStatus()

RETURN ( nImagen )

//---------------------------------------------------------------------------//

METHOD cTextoTiket( sPunto ) CLASS TTpvRestaurante

   local cTextoPunto

   cTextoPunto          := sPunto:cTextoPunto()

   ::oSender:oTiketCabecera:GetStatus()

      if ( ::oSender:oTiketCabecera:SeekInOrd( sPunto:cTiket(), "cNumTik" ) ) .and. !( ::oSender:oTiketCabecera:FieldGetByName( "lPgdTik" ) )
         cTextoPunto    += CRLF
         cTextoPunto    += "[ Total : " + Ltrim( nTotTik( ::oSender:cNumeroTicket(), ::oSender:oTiketCabecera, ::oSender:oTiketLinea, ::oSender:oDivisas, , , .t. ) ) + " ]"
      end if

   ::oSender:oTiketCabecera:SetStatus()

RETURN ( cTextoPunto )

//---------------------------------------------------------------------------//

METHOD cTextoPunto( sPunto ) CLASS TTpvRestaurante

   local cTextoPunto

   DEFAULT sPunto       := ::oSelectedPunto

   cTextoPunto          := sPunto:cTextoPunto()

   ::oSender:oTiketCabecera:GetStatus()

      if ( ::oSender:oTiketCabecera:SeekInOrd( sPunto:cPunto(), "cCodSal" ) ) .and. ( ::oSender:oTiketCabecera:FieldGetByName( "lPgdTik" ) )

         if !empty( ::oSender:oTiketCabecera:FieldGetByName( "cAliasTik" ) )
            cTextoPunto := Upper( Rtrim( ::oSender:oTiketCabecera:FieldGetByName( "cAliasTik" ) ) )
         end if

         cTextoPunto    += CRLF
         cTextoPunto    += "[ Total : " + Ltrim( nTotTik( ::oSender:cNumeroTicket(), ::oSender:oTiketCabecera, ::oSender:oTiketLinea, ::oSender:oDivisas, , , .t. ) ) + " ]"

      end if

   ::oSender:oTiketCabecera:SetStatus()

RETURN ( cTextoPunto )

//---------------------------------------------------------------------------//

METHOD cTextoGenerico( sPunto ) CLASS TTpvRestaurante

   local nRecno
   local cTextoPunto

   DEFAULT sPunto       := ::oSelectedPunto

   cTextoPunto          := "General"

   if !empty( ::cTikT ) .and. !empty( ::cTikL )

      nRecno            := ( ::cTikT )->( Recno() )

      if ( dbSeekInOrd( sPunto:cTiket(), "cNumTik", ::cTikT ) .and. !( ::cTikT )->lPgdTik )

         if !empty( ( ::cTikT )->cAliasTik )
            cTextoPunto := Upper( Rtrim( ( ::cTikT )->cAliasTik ) )
         end if

         cTextoPunto    += CRLF
         cTextoPunto    += "[ Total : " + Ltrim( nTotTik( ( ::cTikT )->cSerTik + ( ::cTikT )->cNumTik + ( ::cTikT )->cSufTik, ::cTikT, ::cTikL, ::cDiv, , , .t. ) ) + " ]"

      end if

      ( ::cTikT )->( dbGoTo( nRecno ) )

   end if

RETURN ( cTextoPunto )

//---------------------------------------------------------------------------//

METHOD cTextoPrecio( nPrecio ) CLASS TTpvRestaurante

   DEFAULT nPrecio   := ::nSelectedPrecio

   if !IsNum( nPrecio )
      nPrecio        := 1
   end if

Return ( ::aPrecio[ Min( Max( nPrecio, 1 ), len( ::aPrecio ) ) ] )

//---------------------------------------------------------------------------//

METHOD SetSelectedImagen() CLASS TTpvRestaurante

   local nScan

   if empty( ::aSalas )
      Return ( Self )
   end if

   do case
      case IsFalse( ::lPuntosVenta )

         ::cSelectedImagen       := ::aSalas[ Min( Max( ::nSelectedPrecio, 1 ), len( ::aSalas ) ) ]:cImagen

      case IsTrue( ::lPuntosVenta )

         if empty( ::cSelectedImagen )
            nScan                := aScan( ::aSalas, {|o| o:cCodigo == ::cSelectedSala } )
            if nScan != 0
               ::cSelectedImagen := ::aSalas[ nScan ]:cImagen
            end if
         end if

   end case

Return ( Self )

//---------------------------------------------------------------------------//

METHOD SetSelectedTexto() CLASS TTpvRestaurante

   local nScan

   if empty( ::aSalas )
      Return ( Self )
   end if

   do case
      case IsFalse( ::lPuntosVenta )

         ::cSelectedTexto     := Rtrim( ::aSalas[ Min( Max( ::nSelectedPrecio, 1 ), len( ::aSalas ) ) ]:cDescripcion )

      case IsTrue( ::lPuntosVenta )

         ::cSelectedTexto     := Rtrim( ::cSelectedPunto )

   end case

Return ( Self )

//---------------------------------------------------------------------------//

METHOD SetGenerico( sPunto ) CLASS TTpvRestaurante

   ::cSelectedSala               := ""
   ::cSelectedPunto              := "General"
   ::lComensal                   := .f.

   ::SelectedPrecio(    sPunto:nPrecio )
   ::SelectedCombinado( sPunto:nPreCmb )
   
   ::cSelectedImagen             := sPunto:cImagen
   ::cSelectedTiket              := sPunto:cTiket()
   ::cSelectedTexto              := sPunto:cTextoPunto()

   ::SetSelectedImagen()
   ::SetSelectedTexto()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD SetLlevar( sPunto ) CLASS TTpvRestaurante

   ::cSelectedSala               := ""
   ::cSelectedPunto              := "Llevar"
   ::lComensal                   := .f.
   
   ::cSelectedImagen             := sPunto:cImagen
   ::cSelectedTiket              := sPunto:cTiket()
   ::cSelectedTexto              := sPunto:cTextoPunto()

   ::SelectedPrecio(    sPunto:nPrecio )
   ::SelectedCombinado( sPunto:nPreCmb )

   ::SetSelectedImagen()
   ::SetSelectedTexto()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD SetSelected( uTmp, sPunto ) CLASS TTpvRestaurante

   if empty( sPunto )
      if !empty( ::oSelectedPunto )
         sPunto               := ::oSelectedPunto
      else
         sPunto               := sPunto():Generico()
      end if
   end if

   do case
      case IsChar( uTmp )

         sPunto:cSerie           := ( ::cTikT )->cSerTik
         sPunto:cNumero          := ( ::cTikT )->cNumTik
         sPunto:cSufijo          := ( ::cTikT )->cSufTik
         sPunto:cAlias           := ( ::cTikT )->cAliasTik

         if !empty( ( ::cTikT )->nTarifa )
            sPunto:nPrecio       := ( ::cTikT )->nTarifa
         end if
         if !empty( ( ::cTikT )->cCodSala )
            sPunto:cCodigoSala   := ( ::cTikT )->cCodSala
         end if
         if !empty( ( ::cTikT )->cPntVenta )
            sPunto:cPuntoVenta   := ( ::cTikT )->cPntVenta
         end if

      case IsArray( uTmp )

         sPunto:cSerie           := uTmp[ ( ::cTikT )->( FieldPos( "cSerTik"   ) ) ]
         sPunto:cNumero          := uTmp[ ( ::cTikT )->( FieldPos( "cNumTik"   ) ) ]
         sPunto:cSufijo          := uTmp[ ( ::cTikT )->( FieldPos( "cSufTik"   ) ) ]
         sPunto:cAlias           := uTmp[ ( ::cTikT )->( FieldPos( "cAliasTik" ) ) ]

         if !empty( uTmp[ ( ::cTikT )->( FieldPos( "nTarifa" ) ) ] )
            sPunto:nPrecio       := uTmp[ ( ::cTikT )->( FieldPos( "nTarifa"   ) ) ]
         end if
         if !empty( uTmp[ ( ::cTikT )->( FieldPos( "cCodSala" ) ) ] )
            sPunto:cCodigoSala   := uTmp[ ( ::cTikT )->( FieldPos( "cCodSala"  ) ) ]
         end if
         if !empty( uTmp[ ( ::cTikT )->( FieldPos( "cPntVenta" ) ) ] )
            sPunto:cPuntoVenta   := uTmp[ ( ::cTikT )->( FieldPos( "cPntVenta" ) ) ]
         end if

   end case

   /*
   Rellenamos los datos-----------------------------------------------
   */

   ::cSelectedSala               := sPunto:cSala
   ::cSelectedPunto              := sPunto:cPuntoVenta
   ::nSelectedUbicacion          := sPunto:nUbicacion
   ::lComensal                   := sPunto:lComensal

   ::SelectedPrecio(    sPunto:nPrecio )
   ::SelectedCombinado( sPunto:nPreCmb )
   
   ::cSelectedImagen             := sPunto:cImagen
   ::cSelectedTiket              := sPunto:cTiket()
   ::cSelectedTexto              := sPunto:cTextoPunto()
   ::oSelectedPunto              := sPunto

   ::SetSelectedImagen()
   ::SetSelectedTexto()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD GetSelectedTexto( lExtend ) CLASS TTpvRestaurante

   local nRecno
   local cTextoPunto    := Rtrim( ::cSelectedPunto )

   DEFAULT lExtend      := .f.

Return ( cTextoPunto )

//---------------------------------------------------------------------------//

METHOD SetSalaVta( aTmp, dbfTikT ) CLASS TTpvRestaurante

   DEFAULT dbfTikT   := ::cTikT

   if empty( aTmp[ ( dbfTikT )->( FieldPos( "cCodSala" ) ) ] )

      do case
         case empty( aTmp[ ( dbfTikT )->( FieldPos( "cPntVenta" ) ) ] )
             ::SetPunto( sPunto():New( , dbfTikT ) )

         case AllTrim( aTmp[ ( dbfTikT )->( FieldPos( "cPntVenta" ) ) ] ) == "General"
             ::SetGenerico( sPunto():Generico( dbfTikT ) )

         case AllTrim( aTmp[ ( dbfTikT )->( FieldPos( "cPntVenta" ) ) ] ) == "Llevar"
             ::SetLlevar( sPunto():Llevar( dbfTikT ) )

         end case

   else

      ::SetPunto( sPunto():New( , dbfTikT ) )

   end if

return .t.

//---------------------------------------------------------------------------//

METHOD SetPunto( sPunto ) CLASS TTpvRestaurante

   if !empty( sPunto )

      ::oSelectedPunto                 := sPunto

      /*
      Rellenamos los datos-----------------------------------------------
      */

      ::cSelectedSala                  := ::oSelectedPunto:cSala
      ::cSelectedPunto                 := ::oSelectedPunto:cPuntoVenta
      ::nSelectedUbicacion             := ::oSelectedPunto:nUbicacion
      ::lComensal                      := ::oSelectedPunto:lComensal
      ::cArticulo                      := ::oSelectedPunto:cArticulo
      ::lMultiplicar                   := ::oSelectedPunto:lMultiplicar
     
      ::SelectedPrecio(    ::oSelectedPunto:nPrecio )             
      ::SelectedCombinado( ::oSelectedPunto:nPreCmb )             

      ::cSelectedImagen                := ::oSelectedPunto:cImagen

      ::cSelectedTiket                 := ::oSelectedPunto:cTiket()
      ::cSelectedTexto                 := ::oSelectedPunto:cTextoPunto()

      ::SetSelectedImagen()
      ::SetSelectedTexto()

   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD cTextoSala( cSala ) CLASS TTpvRestaurante

   local nScan
   local cTextoSala  := ""

   DEFAULT cSala     := ::cSelectedSala

   nScan             := aScan( ::aSalas, {|o| o:cCodigo == cSala } )
   if nScan != 0
      cTextoSala     := Rtrim( ::aSalas[ nScan ]:cDescripcion )
   end if

Return ( cTextoSala )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TDetSalaVenta FROM TDet

   METHOD Create( cPath )

   METHOD OpenFiles( lExclusive )
   MESSAGE OpenService( lExclusive )   METHOD OpenFiles( lExclusive )

   METHOD CloseFiles()

   METHOD DefineFiles()

   METHOD Resource( nMode, lLiteral )

   METHOD SaveDetails()

   METHOD lPresave( oGetCod, nMode )

END CLASS

//--------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cVia, lUniqueName, cFileName ) CLASS TDetSalaVenta

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT lUniqueName  := .f.
   DEFAULT cFileName    := "SlaPnt"
   DEFAULT cVia         := cDriver()

   if lUniqueName
      cFileName         := cGetNewFileName( cFileName, , , cPath )
   end if

   DEFINE TABLE oDbf FILE ( cFileName ) CLASS ( cFileName ) ALIAS ( cFileName ) PATH ( cPath ) VIA ( cVia ) COMMENT "Puntos de venta en sala"

      FIELD NAME "cCodigo"    TYPE "C" LEN  3   DEC 0 COMMENT "Código"                          HIDE        OF oDbf
      FIELD NAME "cDescrip"   TYPE "C" LEN  35  DEC 0 COMMENT "Descripción de punto de venta"   COLSIZE 200 OF oDbf
      FIELD NAME "nTipo"      TYPE "N" LEN  2   DEC 0 COMMENT "Tipo de objeto"                  HIDE        OF oDbf
      FIELD NAME "nFila"      TYPE "N" LEN  6   DEC 0 COMMENT "Fila del objeto"                 HIDE        OF oDbf
      FIELD NAME "nColumna"   TYPE "N" LEN  6   DEC 0 COMMENT "Columna del objeto"              HIDE        OF oDbf

      INDEX TO ( cFileName ) TAG "Codigo"    ON "cCodigo"   NODELETED   OF oDbf
      INDEX TO ( cFileName ) TAG "Descrip"   ON "cDescrip"  NODELETED   OF oDbf
      INDEX TO ( cFileName ) TAG "cCodDes"   ON "cCodigo + cDescrip"  NODELETED   OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//--------------------------------------------------------------------------//

METHOD CloseFiles()

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
      ::oDbf      := nil
   end if

RETURN .t.

//---------------------------------------------------------------------------//

METHOD Create( cPath ) CLASS TDetSalaVenta

   DEFAULT cPath        := cPatEmp()

   ::cPath              := cPath

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive ) CLASS TDetSalaVenta

   local lOpen          := .t.
   local oBlock

   DEFAULT  lExclusive  := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if empty( ::oDbf )
         ::oDbf            := ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !lExclusive )

      ::bOnPreSaveDetail   := {|| ::SaveDetails() }

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos de puntos de venta" )
      ::CloseFiles()
      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//--------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS TDetSalaVenta

   local oDlg
   local oGetDescrip

   if nMode == APPD_MODE
      ::oDbfVir:cDescrip   := Alltrim( ::oParent:oDbf:cDescrip ) + Space( 1 ) + Alltrim( Str( ::oDbfVir:Lastrec() + 1 ) )
   end if

   /*
   Caja de dialogo-------------------------------------------------------------
   */

   DEFINE DIALOG oDlg RESOURCE "LSalaVentas" TITLE LblTitle( nMode ) + "puntos de venta"

      /*
      Código de maquinaria-----------------------------------------------------
      */

      REDEFINE GET oGetDescrip VAR ::oDbfVir:cDescrip ;
         ID       100 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE );
         ACTION   ( if( ::lPresave( oGetDescrip, nMode ), oDlg:end( IDOK ), ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F5, {|| if( ::lPresave( oGetDescrip, nMode ), oDlg:end( IDOK ), ) } )
      end if

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

METHOD SaveDetails() CLASS TDetSalaVenta

   ::oDbfVir:cCodigo := ::oParent:oDbf:cCodigo

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lPreSave( oGetDescrip, nMode ) CLASS TDetSalaVenta

   local lOk   := .t.

   if nMode == APPD_MODE

      ::oDbfVir:GetStatus()

      if ::oDbfVir:SeekInOrd( ::oDbfVir:cDescrip, "cDescrip" )
         msgStop( "Descripción ya existe" )
         oGetDescrip:SetFocus()
         lOk   := .f.
      end if

      ::oDbfVir:SetStatus()

   end if

Return ( lOk )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//