#include "hbclass.ch"

#define CRLF                        chr( 13 ) + chr( 10 )

#define OFN_PATHMUSTEXIST            0x00000800
#define OFN_NOCHANGEDIR              0x00000008
#define OFN_ALLOWMULTISELECT         0x00000200
#define OFN_EXPLORER                 0x00080000     // new look commdlg
#define OFN_LONGNAMES                0x00200000     // force long names for 3.x modules
#define OFN_ENABLESIZING             0x00800000

#define __porcentajeIVA__            1.21

//---------------------------------------------------------------------------//

Function Inicio()

   ArticulosICG():New()

   msgInfo( "Proceso finalizado")

Return ( nil )

//---------------------------------------------------------------------------//

CLASS ArticulosICG

   DATA nView

   DATA cTarifa              INIT  "00 Netos T/4 al 30 margen "
   DATA aTarifa              INIT  {}

   DATA hTarifa              INIT  {   {  "00 Netos T/4 al 30 margen ",; 
                                          {  "Factor descuento 1" => 2,;
                                             "Descuento 1" => 0,;
                                             "Factor descuento 2" => 1.80,;
                                             "Descuento 2" => 20,;
                                             "Factor descuento 3" => 1.60,;
                                             "Descuento 3" => 20,;
                                             "Factor descuento 4" => 1.30,;
                                             "Descuento 4" => 35,;
                                             "Factor descuento 5" => 1.25,;
                                             "Descuento 5" => 37.5,;
                                             "Factor descuento 6" => 1.20,;
                                             "Descuento 6" => 40 } },;
					{  "1 Andel Filtros 65%  T2 igual a T1 ",;
                                          {  "Factor descuento 1" => 1,;
                                             "Descuento 1" => 0,;
                                             "Factor descuento 2" => 1,;
                                             "Descuento 2" => 0,;
                                             "Factor descuento 3" => 0.60,;
                                             "Descuento 3" => 40,;
                                             "Factor descuento 4" => 0.45,;
                                             "Descuento 4" => 55,;
                                             "Factor descuento 5" => 0.43,;
                                             "Descuento 5" => 57,;
                                             "Factor descuento 6" => 0.40,;
                                             "Descuento 6" => 60 } },;
					{  "6 Junta homcinetica Neto*3 ",; 
                                          {  "Factor descuento 1" => 3,;
                                             "Descuento 1" => 0,;
                                             "Factor descuento 2" => 2,;
                                             "Descuento 2" => 33,;
                                             "Factor descuento 3" => 1.75,;
                                             "Descuento 3" => 45,;
                                             "Factor descuento 4" => 1.30,;
                                             "Descuento 4" => 47,;
                                             "Factor descuento 5" => 1.20,;
                                             "Descuento 5" => 60,;
                                             "Factor descuento 6" => 1.15,;
                                             "Descuento 6" => 62 } },;
					{  "15 LUK 53% ",; 
                                          {  "Factor descuento 1" => 1,;
                                             "Descuento 1" => 0,;
                                             "Factor descuento 2" => 0.85,;
                                             "Descuento 2" => 15,;
                                             "Factor descuento 3" => 0.70,;
                                             "Descuento 3" => 30,;
                                             "Factor descuento 4" => 0.58,;
                                             "Descuento 4" => 42,;
                                             "Factor descuento 5" => 0.55,;
                                             "Descuento 5" => 45,;
                                             "Factor descuento 6" => 0.50,;
                                             "Descuento 6" => 50 } },;
					{  "19 Hella 40% ",; 
                                          {  "Factor descuento 1" => 1,;
                                             "Descuento 1" => 0,;
                                             "Factor descuento 2" => 0.90,;
                                             "Descuento 2" => 10,;
                                             "Factor descuento 3" => 0.85,;
                                             "Descuento 3" => 15,;
                                             "Factor descuento 4" => 0.78,;
                                             "Descuento 4" => 22,;
                                             "Factor descuento 5" => 0.75,;
                                             "Descuento 5" => 25,;
                                             "Factor descuento 6" => 0.70,;
                                             "Descuento 6" => 30 } },;
					{  "20 Carbureibar 42% ",; 
                                          {  "Factor descuento 1" => 1,;
                                             "Descuento 1" => 0,;
                                             "Factor descuento 2" => 0.90,;
                                             "Descuento 2" => 10,;
                                             "Factor descuento 3" => 0.85,;
                                             "Descuento 3" => 15,;
                                             "Factor descuento 4" => 0.75,;
                                             "Descuento 4" => 25,;
                                             "Factor descuento 5" => 0.70,;
                                             "Descuento 5" => 30,;
                                             "Factor descuento 6" => 0.65,;
                                             "Descuento 6" => 35 } },;
					{  "24 Bottari 40% ",; 
                                          {  "Factor descuento 1" => 1,;
                                             "Descuento 1" => 0,;
                                             "Factor descuento 2" => 0.85,;
                                             "Descuento 2" => 15,;
                                             "Factor descuento 3" => 0.80,;
                                             "Descuento 3" => 20,;
                                             "Factor descuento 4" => 0.75,;
                                             "Descuento 4" => 25,;
                                             "Factor descuento 5" => 0.75,;
                                             "Descuento 5" => 25,;
                                             "Factor descuento 6" => 0.70,;
                                             "Descuento 6" => 30 } },;
					{  "27 Dayco Scooter 50% ",; 
                                          {  "Factor descuento 1" => 1,;
                                             "Descuento 1" => 0,;
                                             "Factor descuento 2" => 0.90,;
                                             "Descuento 2" => 10,;
                                             "Factor descuento 3" => 0.80,;
                                             "Descuento 3" => 20,;
                                             "Factor descuento 4" => 0.65,;
                                             "Descuento 4" => 35,;
                                             "Factor descuento 5" => 0.63,;
                                             "Descuento 5" => 37,;
                                             "Factor descuento 6" => 0.57,;
                                             "Descuento 6" => 43 } },;
					{  "33 Luk Embragues 57% ",; 
                                          {  "Factor descuento 1" => 1,;
                                             "Descuento 1" => 0,;
                                             "Factor descuento 2" => 0.80,;
                                             "Descuento 2" => 20,;
                                             "Factor descuento 3" => 0.70,;
                                             "Descuento 3" => 30,;
                                             "Factor descuento 4" => 0.55,;
                                             "Descuento 4" => 45,;
                                             "Factor descuento 5" => 0.50,;
                                             "Descuento 5" => 50,;
                                             "Factor descuento 6" => 0.48,;
                                             "Descuento 6" => 52 } },;
					{  "37 Carbureibar 45% ",; 
                                          {  "Factor descuento 1" => 1,;
                                             "Descuento 1" => 0,;
                                             "Factor descuento 2" => 0.90,;
                                             "Descuento 2" => 10,;
                                             "Factor descuento 3" => 0.85,;
                                             "Descuento 3" => 15,;
                                             "Factor descuento 4" => 0.72,;
                                             "Descuento 4" => 28,;
                                             "Factor descuento 5" => 0.68,;
                                             "Descuento 5" => 32,;
                                             "Factor descuento 6" => 0.63,;
                                             "Descuento 6" => 37 } },;
					{  "44 Mdr 55% ",; 
                                          {  "Factor descuento 1" => 1,;
                                             "Descuento 1" => 0,;
                                             "Factor descuento 2" => 0.85,;
                                             "Descuento 2" => 15,;
                                             "Factor descuento 3" => 0.75,;
                                             "Descuento 3" => 25,;
                                             "Factor descuento 4" => 0.60,;
                                             "Descuento 4" => 40,;
                                             "Factor descuento 5" => 0.55,;
                                             "Descuento 5" => 45,;
                                             "Factor descuento 6" => 0.53,;
                                             "Descuento 6" => 47 } },;
					{  "59 OJO Costo+neto ",; 
                                          {  "Factor descuento 1" => 2,;
                                             "Descuento 1" => 0,;
                                             "Factor descuento 2" => 1.80,;
                                             "Descuento 2" => 10,;
                                             "Factor descuento 3" => 1.60,;
                                             "Descuento 3" => 20,;
                                             "Factor descuento 4" => 1.30,;
                                             "Descuento 4" => 35,;
                                             "Factor descuento 5" => 1.25,;
                                             "Descuento 5" => 37.5,;
                                             "Factor descuento 6" => 1.20,;
                                             "Descuento 6" => 40 } },;
					{  "60 Andel transmisiones 58% ",; 
                                          {  "Factor descuento 1" => 1,;
                                             "Descuento 1" => 0,;
                                             "Factor descuento 2" => 0.85,;
                                             "Descuento 2" => 15,;
                                             "Factor descuento 3" => 0.75,;
                                             "Descuento 3" => 25,;
                                             "Factor descuento 4" => 0.55,;
                                             "Descuento 4" => 45,;
                                             "Factor descuento 5" => 0.53,;
                                             "Descuento 5" => 47,;
                                             "Factor descuento 6" => 0.50,;
                                             "Descuento 6" => 50 } },;
					{  "67 Trw direcciones 48% ",; 
                                          {  "Factor descuento 1" => 1,;
                                             "Descuento 1" => 0,;
                                             "Factor descuento 2" => 0.90,;
                                             "Descuento 2" => 10,;
                                             "Factor descuento 3" => 0.80,;
                                             "Descuento 3" => 20,;
                                             "Factor descuento 4" => 0.70,;
                                             "Descuento 4" => 30,;
                                             "Factor descuento 5" => 0.65,;
                                             "Descuento 5" => 35,;
                                             "Factor descuento 6" => 0.60,;
                                             "Descuento 6" => 40 } },;
					{  "68 Rinder Rotativos 32% ",; 
                                          {  "Factor descuento 1" => 1,;
                                             "Descuento 1" => 0,;
                                             "Factor descuento 2" => 0.95,;
                                             "Descuento 2" => 5,;
                                             "Factor descuento 3" => 0.90,;
                                             "Descuento 3" => 10,;
                                             "Factor descuento 4" => 0.85,;
                                             "Descuento 4" => 15,;
                                             "Factor descuento 5" => 0.83,;
                                             "Descuento 5" => 17,;
                                             "Factor descuento 6" => 0.80,;
                                             "Descuento 6" => 20 } },;
					{  "69 Ngk 62% ",; 
                                          {  "Factor descuento 1" => 1,;
                                             "Descuento 1" => 0,;
                                             "Factor descuento 2" => 0.80,;
                                             "Descuento 2" => 20,;
                                             "Factor descuento 3" => 0.65,;
                                             "Descuento 3" => 35,;
                                             "Factor descuento 4" => 0.50,;
                                             "Descuento 4" => 50,;
                                             "Factor descuento 5" => 0.48,;
                                             "Descuento 5" => 52,;
                                             "Factor descuento 6" => 0.45,;
                                             "Descuento 6" => 55 } },;
					{  "70 Dayco Ktb 70% ",; 
                                          {  "Factor descuento 1" => 1,;
                                             "Descuento 1" => 0,;
                                             "Factor descuento 2" => 0.75,;
                                             "Descuento 2" => 25,;
                                             "Factor descuento 3" => 0.60,;
                                             "Descuento 3" => 40,;
                                             "Factor descuento 4" => 0.38,;
                                             "Descuento 4" => 62,;
                                             "Factor descuento 5" => 0.36,;
                                             "Descuento 5" => 64,;
                                             "Factor descuento 6" => 0.34,;
                                             "Descuento 6" => 66 } },;
					{  "82 Snr rodamientos 78% ",;
                                          {  "Factor descuento 1" => 1,;
                                             "Descuento 1" => 0,;
                                             "Factor descuento 2" => 0.65,;
                                             "Descuento 2" => 35,;
                                             "Factor descuento 3" => 0.55,;
                                             "Descuento 3" => 45,;
                                             "Factor descuento 4" => 0.30,;
                                             "Descuento 4" => 70,;
                                             "Factor descuento 5" => 0.28,;
                                             "Descuento 5" => 72,;
                                             "Factor descuento 6" => 0.26,;
                                             "Descuento 6" => 74 } },;
                                       {  "84 fAE 59% ",;
                                          {  "Factor descuento 1" => 1,;
                                             "Descuento 1" => 0,;
                                             "Factor descuento 2" => 0.80,;
                                             "Descuento 2" => 20,;
                                             "Factor descuento 3" => 0.70,;
                                             "Descuento 3" => 30,;
                                             "Factor descuento 4" => 0.53,;
                                             "Descuento 4" => 47,;
                                             "Factor descuento 5" => 0.50,;
                                             "Descuento 5" => 50,;
                                             "Factor descuento 6" => 0.47,;
                                             "Descuento 6" => 53 } },;
					{  "85 Dayco correas 74% ",;
                                          {  "Factor descuento 1" => 1,;
                                             "Descuento 1" => 0,;
                                             "Factor descuento 2" => 0.65,;
                                             "Descuento 2" => 35,;
                                             "Factor descuento 3" => 0.55,;
                                             "Descuento 3" => 45,;
                                             "Factor descuento 4" => 0.35,;
                                             "Descuento 4" => 65,;
                                             "Factor descuento 5" => 0.33,;
                                             "Descuento 5" => 67,;
                                             "Factor descuento 6" => 0.30,;
                                             "Descuento 6" => 70 } },;
					{  "87 Costo+margen baterias ",;
                                          {  "Factor descuento 1" => 2,;
                                             "Descuento 1" => 0,;
                                             "Factor descuento 2" => 1.35,;
                                             "Descuento 2" => 33,;
                                             "Factor descuento 3" => 1.35,;
                                             "Descuento 3" => 33,;
                                             "Factor descuento 4" => 1.20,;
                                             "Descuento 4" => 40,;
                                             "Factor descuento 5" => 1.15,;
                                             "Descuento 5" => 43,;
                                             "Factor descuento 6" => 1.10,;
                                             "Descuento 6" => 45 } },;
					{  "88 Andel escobillas 65% ",;
                                          {  "Factor descuento 1" => 1,;
                                             "Descuento 1" => 0,;
                                             "Factor descuento 2" => 0.75,;
                                             "Descuento 2" => 25,;
                                             "Factor descuento 3" => 0.60,;
                                             "Descuento 3" => 40,;
                                             "Factor descuento 4" => 0.45,;
                                             "Descuento 4" => 55,;
                                             "Factor descuento 5" => 0.43,;
                                             "Descuento 5" => 57,;
                                             "Factor descuento 6" => 0.40,;
                                             "Descuento 6" => 60 } },;
					{  "89 Textar pastillas 75% ",;
                                          {  "Factor descuento 1" => 1,;
                                             "Descuento 1" => 0,;
                                             "Factor descuento 2" => 0.60,;
                                             "Descuento 2" => 40,;
                                             "Factor descuento 3" => 0.50,;
                                             "Descuento 3" => 50,;
                                             "Factor descuento 4" => 0.32,;
                                             "Descuento 4" => 68,;
                                             "Factor descuento 5" => 0.30,;
                                             "Descuento 5" => 70,;
                                             "Factor descuento 6" => 0.28,;
                                             "Descuento 6" => 72 } },;
					{  "90 Conti Correa+rodillo 65% ",;
                                          {  "Factor descuento 1" => 1,;
                                             "Descuento 1" => 0,;
                                             "Factor descuento 2" => 0.75,;
                                             "Descuento 2" => 25,;
                                             "Factor descuento 3" => 0.65,;
                                             "Descuento 3" => 35,;
                                             "Factor descuento 4" => 0.46,;
                                             "Descuento 4" => 54,;
                                             "Factor descuento 5" => 0.44,;
                                             "Descuento 5" => 56,;
                                             "Factor descuento 6" => 0.42,;
                                             "Descuento 6" => 58 } },;
					{  "91 Purflux con * 68.98% ",;
                                          {  "Factor descuento 1" => 1,;
                                             "Descuento 1" => 0,;
                                             "Factor descuento 2" => 0.75,;
                                             "Descuento 2" => 25,;
                                             "Factor descuento 3" => 0.6,;
                                             "Descuento 3" => 40,;
                                             "Factor descuento 4" => 0.4,;
                                             "Descuento 4" => 60,;
                                             "Factor descuento 5" => 0.38,;
                                             "Descuento 5" => 62,;
                                             "Factor descuento 6" => 0.35,;
                                             "Descuento 6" => 65 } },;
					{  "99 OJO Cascos Netos+30% ",;
                                          {  "Factor descuento 1" => 1.3,;
                                             "Descuento 1" => 0,;
                                             "Factor descuento 2" => 1.3,;
                                             "Descuento 2" => 0,;
                                             "Factor descuento 3" => 1.3,;
                                             "Descuento 3" => 0,;
                                             "Factor descuento 4" => 1.3,;
                                             "Descuento 4" => 0,;
                                             "Factor descuento 5" => 1.30,;
                                             "Descuento 5" => 0,;
                                             "Factor descuento 6" => 1.30,;
                                             "Descuento 6" => 0 } },;
					{  "100 OJO Netos especiales ",;
                                          {  "Factor descuento 1" => 2,;
                                             "Descuento 1" => 0,;
                                             "Factor descuento 2" => 1.6,;
                                             "Descuento 2" => 20,;
                                             "Factor descuento 3" => 1.4,;
                                             "Descuento 3" => 30,;
                                             "Factor descuento 4" => 1.15,;
                                             "Descuento 4" => 42.50,;
                                             "Factor descuento 5" => 1.10,;
                                             "Descuento 5" => 45,;
                                             "Factor descuento 6" => 1.10,;
                                             "Descuento 6" => 45 } };
					                                    }    

   DATA cPrecio            INIT "P.V.P."
   DATA aPrecio            INIT { "P.V.P.", "Costo" }                                                                    

   DATA oOleExcel
   
   DATA nRow
   DATA nLineaComienzo     INIT  2

   DATA cCodigoArticulo    INIT  ""
   DATA cDescipcionArticulo
   DATA cCodigoBarrasArticulo
   DATA cSustituyeA
   DATA cSustituidoPor
   DATA cDescipcionCasco
   DATA cReferenciaCasco
   DATA cFechaCreacion

   DATA nPrecioCosto
   DATA nPrecioCasco

   DATA nLitros

   DATA nPrecioVigor       INIT  0
   DATA nDescuentoVigor    INIT  0
   DATA nPrecioVenta1      INIT  0
   DATA nPrecioVentaIVA1   INIT  0
   DATA nPrecioVenta2      INIT  0
   DATA nPrecioVentaIVA2   INIT  0
   DATA nPrecioVenta3      INIT  0
   DATA nPrecioVentaIVA3   INIT  0
   DATA nPrecioVenta4      INIT  0
   DATA nPrecioVentaIVA4   INIT  0
   DATA nPrecioVenta5      INIT  0
   DATA nPrecioVentaIVA5   INIT  0
   DATA nPrecioVenta6      INIT  0
   DATA nPrecioVentaIVA6   INIT  0

   DATA cFamilia
   DATA cFamilia1
   DATA cFamilia2
   DATA cFamilia3
   DATA cFamilia4

   DATA aFichero

   METHOD New()               CONSTRUCTOR

   METHOD Dialog()

   METHOD showDescuentos()

   METHOD AddFichero()  

   METHOD OpenFiles()
   METHOD CloseFiles()        INLINE ( D():DeleteView( ::nView ) )

   METHOD ProcessFile()

   METHOD ProcessRow()

   METHOD AppendArticulo()
      METHOD SetArticulo()

   METHOD AppendEscandallo()
      METHOD setEscandallo()

   METHOD AppendCodigosBarras()
      METHOD SetCodigosBarras()

   METHOD getReferenciaCasco()

   METHOD GetRange()
   METHOD GetNumeric()

   METHOD getTarifa()

   METHOD factorDescuento1()  INLINE ::getTarifa( "Factor descuento 1" )
   METHOD descuento1()        INLINE ::getTarifa( "Descuento 1" )
   METHOD factorDescuento2()  INLINE ::getTarifa( "Factor descuento 2" )
   METHOD descuento2()        INLINE ::getTarifa( "Descuento 2" )
   METHOD factorDescuento3()  INLINE ::getTarifa( "Factor descuento 3" )
   METHOD descuento3()        INLINE ::getTarifa( "Descuento 3" )
   METHOD factorDescuento4()  INLINE ::getTarifa( "Factor descuento 4" )
   METHOD descuento4()        INLINE ::getTarifa( "Descuento 4" )
   METHOD factorDescuento5()  INLINE ::getTarifa( "Factor descuento 5" )
   METHOD descuento5()        INLINE ::getTarifa( "Descuento 5" )
   METHOD factorDescuento6()  INLINE ::getTarifa( "Factor descuento 6" )
   METHOD descuento6()        INLINE ::getTarifa( "Descuento 6" )

   METHOD lEscandallos()      INLINE ( !empty( ::cDescipcionCasco ) .or. ::nLitros > 0 )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS ArticulosICG

   local cFichero

	if !::Dialog() 
		Return ( Self )
	end if 

   ::AddFichero()
   if empty( ::aFichero )
      Return ( Self )
   end if 

   if !::showDescuentos()
      Return ( Self )
   end if 

   if !::OpenFiles()
		Return ( Self )
	end if 

   for each cFichero in ::aFichero
      if !empty(cFichero)
         msgRun( "Procesando hoja de calculo " + cFichero, "Espere", {|| ::ProcessFile( cFichero ) } )
      end if 
   next 

   ::CloseFiles()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Dialog() CLASS ArticulosICG

   local oDlg
   local oBtn
   local aTarifa
   local bTarifa       := { | u | if( pCount () == 0, ::cTarifa, ::cTarifa := u ) }
   local bPrecio       := { | u | if( pCount () == 0, ::cPrecio, ::cPrecio := u ) }

   ::aTarifa           := {}

   for each aTarifa in ::hTarifa
      aAdd( ::aTarifa, aTarifa[ 1 ] )
   next

   oDlg                 := TDialog():New( 5, 5, 15, 40, "Importacion ICG" )

   TSay():New( 1, 1, {|| "Tarifa" }, oDlg )      

   TCombobox():New( 1, 4, bTarifa, ::aTarifa, 100, 14, oDlg )      

   TSay():New( 2, 1, {|| "Precio" }, oDlg )      

   TCombobox():New( 2, 4, bPrecio, ::aPrecio, 100, 14, oDlg )      

   TButton():New( 3, 4, "&Aceptar", oDlg, {|| ( oDlg:End(1) ) }, 40, 12 )

   TButton():New( 3, 12, "&Cancel", oDlg, {|| oDlg:End() }, 40, 12 )

   oDlg:Activate( , , , .t. )

Return ( oDlg:nResult == 1 )

//---------------------------------------------------------------------------//

METHOD showDescuentos()

   local cTexto
   local cFichero

   cTexto         := ""

   for each cFichero in ::aFichero
      if !empty( cFichero )
         cTexto   += "Fichero a procesar " + cFichero + CRLF
      end if 
   next 

   cTexto         += replicate( "-", 40 ) + CRLF
   cTexto         += "Factor descuento 1 : (" + cValtoChar( ::factorDescuento1() ) + ") > " + alltrim( cValtoChar( ::descuento1() ) ) + "%" + CRLF
   cTexto         += "Factor descuento 2 : (" + cValtoChar( ::factorDescuento2() ) + ") > " + alltrim( cValtoChar( ::descuento2() ) ) + "%" + CRLF
   cTexto         += "Factor descuento 3 : (" + cValtoChar( ::factorDescuento3() ) + ") > " + alltrim( cValtoChar( ::descuento3() ) ) + "%" + CRLF
   cTexto         += "Factor descuento 4 : (" + cValtoChar( ::factorDescuento4() ) + ") > " + alltrim( cValtoChar( ::descuento4() ) ) + "%" + CRLF
   cTexto         += "Factor descuento 5 : (" + cValtoChar( ::factorDescuento5() ) + ") > " + alltrim( cValtoChar( ::descuento5() ) ) + "%" + CRLF
   cTexto         += "Factor descuento 6 : (" + cValtoChar( ::factorDescuento6() ) + ") > " + alltrim( cValtoChar( ::descuento6() ) ) + "%" 

Return ( msgYesNo( cTexto, "Valores" ) )   

//---------------------------------------------------------------------------//

METHOD AddFichero() CLASS ArticulosICG

   local i
   local cFile
   local aFile
   local nFlag    := nOr( OFN_PATHMUSTEXIST, OFN_NOCHANGEDIR, OFN_ALLOWMULTISELECT, OFN_EXPLORER, OFN_LONGNAMES )

   ::aFichero     := {}

   cFile          := cGetFile( "All | *.xls", "Seleccione los ficheros a importar", "*.xls" , , .f., .t., nFlag )
   cFile          := Left( cFile, At( Chr( 0 ) + Chr( 0 ), cFile ) - 1 )

   if !Empty( cFile ) //.or. Valtype( cFile ) == "N"

      cFile       := StrTran( cFile, Chr( 0 ), "," )
      aFile       := hb_aTokens( cFile, "," )

      if Len( aFile ) > 1

         for i := 2 to Len( aFile )
            aFile[ i ] := aFile[ 1 ] + "\" + aFile[ i ]
         next

         aDel( aFile, 1, .t. )

      endif

      if IsArray( aFile )

         for i := 1 to Len( aFile )
            aAdd( ::aFichero, aFile[ i ] ) // if( SubStr( aFile[ i ], 4, 1 ) == "\", aFileDisc( aFile[i] ) + "\" + aFileName( aFile[ i ] ), aFile[ i ] ) )
         next

      else

         aAdd( ::aFichero, aFile )

      endif

   end if

RETURN ( ::aFichero )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS ArticulosICG

   local oError
   local oBlock
   local lOpenFiles     := .t.

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::nView           := D():CreateView()

      D():Articulos( ::nView )

      D():ArticulosCodigosBarras( ::nView ) 
      ( D():ArticulosCodigosBarras( ::nView ) )->( ordsetfocus( "cArtBar" ) )

      D():Get( "ArtKit", ::nView )  
      ( D():Get( "ArtKit", ::nView ) )->( ordsetfocus( "cCodRef" ) )

      D():Get( "Ruta", ::nView )

      D():Get( "Agentes", ::nView )

   RECOVER USING oError

      lOpenFiles        := .f.

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lOpenFiles )

//---------------------------------------------------------------------------//

METHOD ProcessFile( cFichero ) CLASS ArticulosICG

   local oError
   local oBlock

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   CursorWait()

      ::oOleExcel                        := TOleExcel():New( "Importando hoja de excel", "Conectando...", .f. )

      ::oOleExcel:oExcel:Visible         := .f.
      ::oOleExcel:oExcel:DisplayAlerts   := .f.
      ::oOleExcel:oExcel:WorkBooks:Open( cFichero )

      ::oOleExcel:oExcel:WorkSheets( 1 ):Activate()   //Hojas de la hoja de calculo

      /*
      Recorremos la hoja de calculo--------------------------------------------
      */

      SysRefresh()

      for ::nRow := ::nLineaComienzo to 65536

         msgWait( "Procesando linea " + str(::nRow), "", 0.0001 )

         /*
         Si no encontramos mas líneas nos salimos------------------------------
         */

         ::cCodigoArticulo                := ::GetRange( "A" )
         if empty( ::cCodigoArticulo )
            exit
         end if 

         ::cDescipcionArticulo            := ::GetRange( "B" )
         ::cCodigoBarrasArticulo          := ::GetRange( "E" )
         ::cSustituyeA                    := ::GetRange( "S" )
         ::cSustituidoPor                 := ::GetRange( "T" )
         ::nPrecioVigor                   := ::GetNumeric( "F" )
         ::nDescuentoVigor                := ::GetNumeric( "O" )
         ::cFamilia1                      := ::GetRange( "H" )
         ::cFamilia2                      := ::GetRange( "I" )
         ::cFamilia3                      := ::GetRange( "J" )
         ::cFamilia4                      := ::GetRange( "K" )
         ::cFechaCreacion                 := ::GetRange( "G" )
         ::cDescipcionCasco               := ::GetRange( "R" )
         ::nPrecioCasco                   := ::GetNumeric( "N" )
         ::nLitros                        := ::GetNumeric( "U" )

         // Proces las lineas         
         
         ::ProcessRow()

         // procesa el registro de la base de datos

         ::AppendArticulo()

         ::AppendCodigosBarras()

         if ::lEscandallos()
            ::AppendEscandallo()
         end if 
         
      next

      // Cerramos la conexion con el objeto oOleExcel-----------------------------

      ::oOleExcel:oExcel:WorkBooks:Close() 
      ::oOleExcel:oExcel:Quit()
      ::oOleExcel:oExcel:DisplayAlerts   := .t.

      ::oOleExcel:End()

      Msginfo( "Porceso finalizado con exito" )

   CursorWE()

   RECOVER USING oError

      msgStop( "Imposible importar datos de excel" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD ProcessRow()

   ::nPrecioCosto       := ::nPrecioVigor - ( ::nPrecioVigor * ::nDescuentoVigor / 100 )

   if ::cPrecio == "Costo"
      ::nPrecioVigor    := ::nPrecioCosto
   end if 

   ::nPrecioVenta1      := ::nPrecioVigor * ::factorDescuento1()
   ::nPrecioVentaIVA1   := ::nPrecioVenta1 * __porcentajeIVA__
   
   ::nPrecioVenta2      := ::nPrecioVigor * ::factorDescuento2()
   ::nPrecioVentaIVA2   := ::nPrecioVenta2 * __porcentajeIVA__

   ::nPrecioVenta3      := ::nPrecioVigor * ::factorDescuento3()
   ::nPrecioVentaIVA3   := ::nPrecioVenta3 * __porcentajeIVA__

   ::nPrecioVenta4      := ::nPrecioVigor * ::factorDescuento4()
   ::nPrecioVentaIVA4   := ::nPrecioVenta4 * __porcentajeIVA__

   ::nPrecioVenta5      := ::nPrecioVigor * ::factorDescuento5()
   ::nPrecioVentaIVA5   := ::nPrecioVenta5 * __porcentajeIVA__

   ::nPrecioVenta6      := ::nPrecioVigor * ::factorDescuento6()
   ::nPrecioVentaIVA6   := ::nPrecioVenta6 * __porcentajeIVA__

   ::cFamilia           := ""
   if !empty( ::cFamilia1 )
      ::cFamilia        += alltrim( ::cFamilia1 ) 
   end if 
   if !empty( ::cFamilia2 )
      ::cFamilia        += "." + alltrim( ::cFamilia2 ) 
   end if 
   if !empty( ::cFamilia3 )
      ::cFamilia        += "." + alltrim( ::cFamilia3 )
   end if 
   if !empty( ::cFamilia4 )
      ::cFamilia        += "." + alltrim( ::cFamilia4 ) 
   end if 

Return ( nil )

//------------------------------------------------------------------------

METHOD AppendArticulo()

   if ( D():Articulos( ::nView ) )->( dbseek( ::cCodigoArticulo ) )
      if ( D():Articulos( ::nView ) )->( dbrlock() )
         ::SetArticulo()
         ( D():Articulos( ::nView ) )->( dbunlock() )
      end if
   else
      if ( D():Articulos( ::nView ) )->( dbappend() )
         ::SetArticulo()
         ( D():Articulos( ::nView ) )->( dbunlock() )
      end if 
   end if 

return ( nil )

//------------------------------------------------------------------------

METHOD SetArticulo()

   local oError
   local oBlock

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      SysRefresh()

      ( D():Articulos( ::nView ) )->Codigo      := ::cCodigoArticulo
      ( D():Articulos( ::nView ) )->Nombre      := ::cDescipcionArticulo
      ( D():Articulos( ::nView ) )->TipoIva     := "G"
      ( D():Articulos( ::nView ) )->CodeBar     := ::cCodigoBarrasArticulo
      ( D():Articulos( ::nView ) )->pVenta1     := ::nPrecioVenta1
      ( D():Articulos( ::nView ) )->pVenta2     := ::nPrecioVenta2
      ( D():Articulos( ::nView ) )->pVenta3     := ::nPrecioVenta3
      ( D():Articulos( ::nView ) )->pVenta4     := ::nPrecioVenta4
      ( D():Articulos( ::nView ) )->pVenta5     := ::nPrecioVenta5
      ( D():Articulos( ::nView ) )->pVenta6     := ::nPrecioVenta6
      ( D():Articulos( ::nView ) )->pVtaIVA1    := ::nPrecioVentaIVA1
      ( D():Articulos( ::nView ) )->pVtaIVA2    := ::nPrecioVentaIVA2
      ( D():Articulos( ::nView ) )->pVtaIVA3    := ::nPrecioVentaIVA3
      ( D():Articulos( ::nView ) )->pVtaIVA4    := ::nPrecioVentaIVA4
      ( D():Articulos( ::nView ) )->pVtaIVA5    := ::nPrecioVentaIVA5
      ( D():Articulos( ::nView ) )->pVtaIVA6    := ::nPrecioVentaIVA6

      ( D():Articulos( ::nView ) )->lBnf1       := .t.
      ( D():Articulos( ::nView ) )->lBnf2       := .t.
      ( D():Articulos( ::nView ) )->lBnf3       := .t.
      ( D():Articulos( ::nView ) )->lBnf4       := .t.
      ( D():Articulos( ::nView ) )->lBnf5       := .t.
      ( D():Articulos( ::nView ) )->lBnf6       := .t.
      
      ( D():Articulos( ::nView ) )->Benef1      := ( ::nPrecioVenta1 / ::nPrecioCosto * 100 ) - 100
      ( D():Articulos( ::nView ) )->Benef2      := ( ::nPrecioVenta2 / ::nPrecioCosto * 100 ) - 100
      ( D():Articulos( ::nView ) )->Benef3      := ( ::nPrecioVenta3 / ::nPrecioCosto * 100 ) - 100
      ( D():Articulos( ::nView ) )->Benef4      := ( ::nPrecioVenta4 / ::nPrecioCosto * 100 ) - 100
      ( D():Articulos( ::nView ) )->Benef5      := ( ::nPrecioVenta5 / ::nPrecioCosto * 100 ) - 100
      ( D():Articulos( ::nView ) )->Benef6      := ( ::nPrecioVenta6 / ::nPrecioCosto * 100 ) - 100

      ( D():Articulos( ::nView ) )->pCosto      := ::nPrecioCosto
      ( D():Articulos( ::nView ) )->Familia     := ::cFamilia
      ( D():Articulos( ::nView ) )->cCodSus     := ::cSustituyeA
      ( D():Articulos( ::nView ) )->cCodPor     := ::cSustituidoPor
      ( D():Articulos( ::nView ) )->lNotVta     := .t.
      ( D():Articulos( ::nView ) )->lMsgvta     := .t.
      ( D():Articulos( ::nView ) )->lMsgMov     := .t.
      ( D():Articulos( ::nView ) )->lMsgSer     := .t.
      ( D():Articulos( ::nView ) )->lMosCom     := !empty( ::cDescipcionCasco ) 
      ( D():Articulos( ::nView ) )->lKitArt     := ::lEscandallos()
      ( D():Articulos( ::nView ) )->lKitAsc     := ::lEscandallos()
      
      if !empty( ::cDescipcionCasco )
         ( D():Articulos( ::nView ) )->mComent  := "Ref. casco " + alltrim( ::cDescipcionCasco ) + " por valor de " + alltrim( transform( ::nPrecioCasco * 1.3, "99999999,99" ) ) + " euros" 
      end if 

      ( D():Articulos( ::nView ) )->LastChg     := stod( ::cFechaCreacion )
      ( D():Articulos( ::nView ) )->dFecChg     := date()

   RECOVER USING oError
      
      msgStop( "Imposible almacenar registro en base de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( nil )

//------------------------------------------------------------------------

METHOD AppendCodigosBarras()

   local cCodigo  := padr( ::cCodigoArticulo, 18 ) + padr( ::cCodigoBarrasArticulo, 20 ) 

   if ( D():ArticulosCodigosBarras( ::nView ) )->( dbseek( cCodigo ) )
      if ( D():ArticulosCodigosBarras( ::nView ) )->( dbrlock() )
         ::SetCodigosBarras()
         ( D():ArticulosCodigosBarras( ::nView ) )->( dbunlock() )
      end if
   else
      if ( D():ArticulosCodigosBarras( ::nView ) )->( dbappend() )
         ::SetCodigosBarras()
         ( D():ArticulosCodigosBarras( ::nView ) )->( dbunlock() )
      end if 
   end if 

return ( nil )

//------------------------------------------------------------------------

METHOD SetCodigosBarras()

   local oError
   local oBlock

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      SysRefresh()

      ( D():ArticulosCodigosBarras( ::nView ) )->cCodArt      := ::cCodigoArticulo
      ( D():ArticulosCodigosBarras( ::nView ) )->cCodBar      := ::cCodigoBarrasArticulo

   RECOVER USING oError
      
      msgStop( "Imposible almacenar registro en base de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( nil )

//------------------------------------------------------------------------

METHOD getReferenciaCasco()

   local cReferenciaCasco     := ""

   if !empty(::cDescipcionCasco) 
      if D():seekInOrd( D():Articulos( ::nView ), ::cDescipcionCasco, "Nombre" )
         cReferenciaCasco     := ( D():Articulos( ::nView ) )->Codigo
      end if 
   end if 

Return ( cReferenciaCasco )

//-----------------------------------------------------------------------------

METHOD AppendEscandallo()

   local cCodigo  

   if empty( ::cDescipcionCasco )
      ::cReferenciaCasco   := "1"
   else 
      ::cReferenciaCasco   := ::getReferenciaCasco()
   end if 

   if empty( ::nLitros )
      ::nLitros            := 1
   end if 

   cCodigo                 := Padr( ::cCodigoArticulo, 18 ) + Padr( ::cReferenciaCasco, 18 )

   if ( D():Kit( ::nView ) )->( dbseek( cCodigo ) )
      if ( D():Kit( ::nView ) )->( dbrlock() )
         ::setEscandallo()
         ( D():Kit( ::nView ) )->( dbunlock() )
      end if
   else
      if ( D():Kit( ::nView ) )->( dbappend() )
         ::setEscandallo()
         ( D():Kit( ::nView ) )->( dbunlock() )
      end if 
   end if 

return ( nil )

//------------------------------------------------------------------------

METHOD setEscandallo()

   ( D():Kit( ::nView ) )->cCodKit     := ::cCodigoArticulo
   ( D():Kit( ::nView ) )->cRefKit     := ::cReferenciaCasco
   ( D():Kit( ::nView ) )->cDesKit     := retFld( ::cReferenciaCasco, D():Articulos( ::nView ), "Nombre" ) 
   ( D():Kit( ::nView ) )->nUndKit     := ::nLitros

Return ( nil )

//------------------------------------------------------------------------

METHOD GetRange( cColumn )

   local oError
   local oBlock
   local uValue
   local cValue   := ""

   oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   uValue         := ::oOleExcel:oExcel:ActiveSheet:Range( cColumn + lTrim( Str( ::nRow ) ) ):Value
   if Valtype( uValue ) == "C"
      cValue      := alltrim( uValue )
   end if 

   RECOVER USING oError

      msgStop( "Imposible obtener columna de excel" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( cValue )

//---------------------------------------------------------------------------//

METHOD GetNumeric( cColumn )

   local oError
   local oBlock
   local uValue
   local nValue   := 0

   oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   uValue         := ::oOleExcel:oExcel:ActiveSheet:Range( cColumn + lTrim( Str( ::nRow ) ) ):Value

   if Valtype( uValue ) == "C"
      nValue      := Val( StrTran( uValue, ",", "." ) )
   end if 

   if Valtype( uValue ) == "N"
      nValue      := uValue
   end if 

   RECOVER USING oError

      msgStop( "Imposible obtener columna de excel" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( nValue ) 

//------------------------------------------------------------------------

METHOD getTarifa( cKey )  

   local nTarifa  := 0
   local nPos     := aScan( ::hTarifa, {|a| alltrim( a[ 1 ] ) == alltrim( ::cTarifa ) } )
   if nPos != 0
      nTarifa     := hGet( ::hTarifa[ nPos, 2 ], cKey )
   end if 

Return ( nTarifa )

//------------------------------------------------------------------------

function aItmArt()

   local aBase  := {}

   aAdd( aBase, { "Codigo",    "C", 18, 0, "Código del artículo" ,                    "'@!'",               "", "( cDbfArt )", nil } )
   aAdd( aBase, { "Nombre",    "C",100, 0, "Nombre del artículo",                     "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cDesTik",   "C", 20, 0, "Descripción para el tiket" ,              "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "pCosto",    "N", 15, 6, "Precio de costo" ,                        "PicIn()",            "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PvpRec",    "N", 15, 6, "Precio venta recomendado" ,               "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lBnf1",     "L",  1, 0, "Lógico aplicar porcentaje de beneficio 1","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LBNF2",     "L",  1, 0, "Lógico aplicar porcentaje de beneficio 2","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LBNF3",     "L",  1, 0, "Lógico aplicar porcentaje de beneficio 3","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LBNF4",     "L",  1, 0, "Lógico aplicar porcentaje de beneficio 4","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LBNF5",     "L",  1, 0, "Lógico aplicar porcentaje de beneficio 5","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LBNF6",     "L",  1, 0, "Lógico aplicar porcentaje de beneficio 6","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "BENEF1",    "N",  6, 2, "Porcentaje de beneficio precio 1" ,       "'@EZ 99.99'",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "BENEF2",    "N",  6, 2, "Porcentaje de beneficio precio 2" ,       "'@EZ 99.99'",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "BENEF3",    "N",  6, 2, "Porcentaje de beneficio precio 3" ,       "'@EZ 99.99'",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "BENEF4",    "N",  6, 2, "Porcentaje de beneficio precio 4" ,       "'@EZ 99.99'",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "BENEF5",    "N",  6, 2, "Porcentaje de beneficio precio 5" ,       "'@EZ 99.99'",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "BENEF6",    "N",  6, 2, "Porcentaje de beneficio precio 6" ,       "'@EZ 99.99'",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NBNFSBR1",  "N",  1, 0, "Beneficio sobre el costo o sobre venta 1","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NBNFSBR2",  "N",  1, 0, "Beneficio sobre el costo o sobre venta 2","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NBNFSBR3",  "N",  1, 0, "Beneficio sobre el costo o sobre venta 3","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NBNFSBR4",  "N",  1, 0, "Beneficio sobre el costo o sobre venta 4","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NBNFSBR5",  "N",  1, 0, "Beneficio sobre el costo o sobre venta 5","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NBNFSBR6",  "N",  1, 0, "Beneficio sobre el costo o sobre venta 6","",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PVENTA1",   "N", 15, 6, "Precio de venta precio 1" ,               "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PVENTA2",   "N", 15, 6, "Precio de venta precio 2" ,               "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PVENTA3",   "N", 15, 6, "Precio de venta precio 3" ,               "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PVENTA4",   "N", 15, 6, "Precio de venta precio 4" ,               "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PVENTA5",   "N", 15, 6, "Precio de venta precio 5" ,               "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PVENTA6",   "N", 15, 6, "Precio de venta precio 6" ,               "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PVTAIVA1",  "N", 15, 6, "Precio de venta precio 1 " + cImp() + " incluido" ,  "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PVTAIVA2",  "N", 15, 6, "Precio de venta precio 2 " + cImp() + " incluido" ,  "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PVTAIVA3",  "N", 15, 6, "Precio de venta precio 3 " + cImp() + " incluido" ,  "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PVTAIVA4",  "N", 15, 6, "Precio de venta precio 4 " + cImp() + " incluido" ,  "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PVTAIVA5",  "N", 15, 6, "Precio de venta precio 5 " + cImp() + " incluido" ,  "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PVTAIVA6",  "N", 15, 6, "Precio de venta precio 6 " + cImp() + " incluido" ,  "PicOut()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PALQ1",     "N", 15, 6, "Precio de alquiler precio 1" ,               "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PALQ2",     "N", 15, 6, "Precio de alquiler precio 2" ,               "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PALQ3",     "N", 15, 6, "Precio de alquiler precio 3" ,               "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PALQ4",     "N", 15, 6, "Precio de alquiler precio 4" ,               "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PALQ5",     "N", 15, 6, "Precio de alquiler precio 5" ,               "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PALQ6",     "N", 15, 6, "Precio de alquiler precio 6" ,               "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PALQIVA1",  "N", 15, 6, "Precio de alquiler precio 1 " + cImp() + " incluido" ,    "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PALQIVA2",  "N", 15, 6, "Precio de alquiler precio 2 " + cImp() + " incluido" ,    "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PALQIVA3",  "N", 15, 6, "Precio de alquiler precio 3 " + cImp() + " incluido" ,    "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PALQIVA4",  "N", 15, 6, "Precio de alquiler precio 4 " + cImp() + " incluido" ,    "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PALQIVA5",  "N", 15, 6, "Precio de alquiler precio 5 " + cImp() + " incluido" ,    "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "PALQIVA6",  "N", 15, 6, "Precio de alquiler precio 6 " + cImp() + " incluido" ,    "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NPNTVER1",  "N", 15, 6, "Contribución punto verde" ,                               "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NPNVIVA1",  "N", 15, 6, "Contribución punto verde " + cImp() + " inc.",            "PicOut()",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NACTUAL",   "N", 15, 6, "Número de artículos" ,                    "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NCAJENT",   "N", 15, 6, "Número de cajas por defecto" ,            "MasUnd()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NUNICAJA",  "N", 15, 6, "Número de unidades por defecto" ,         "MasUnd()",           "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NMINIMO",   "N", 15, 6, "Número de stock mínimo" ,                 "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NMAXIMO",   "N", 15, 6, "Número de stock maximo" ,                 "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NCNTACT",   "N", 15, 6, "Número del contador" ,                    "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LASTIN",    "D",  8, 0, "Fecha ultima entrada" ,                   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LASTCHG",   "D",  8, 0, "Fecha de creación" ,                      "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LASTOUT",   "D",  8, 0, "Fecha ultima salida" ,                    "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "TIPOIVA",   "C",  1, 0, "Código tipo de " + cImp(),                "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LIVAINC",   "L",  1, 0, "Lógico " + cImp() + " incluido (S/N)" ,   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "FAMILIA",   "C", 16, 0, "Código de la familia del artículo" ,      "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CSUBFAM",   "C",  8, 0, "Código de la subfamilia del artículo" ,   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "GRPVENT",   "C",  9, 0, "Código del grupo de ventas" ,             "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCTAVTA",   "C", 12, 0, "Código de la cuenta de ventas" ,          "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCTACOM",   "C", 12, 0, "Código de la cuenta de compras" ,         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCTATRN",   "C", 12, 0, "Código de la cuenta de portes" ,          "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CODEBAR",   "C", 20, 0, "Código de barras" ,                       "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NTIPBAR",   "N",  2, 0, "Tipo de código de barras" ,               "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "DESCRIP",   "M", 10, 0, "Descripción larga" ,                      "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LLABEL",    "L",  1, 0, "Lógico de selección de etiqueta",         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NLABEL",    "N",  5, 0, "Número de etiquetas a imprimir",          "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NCTLSTOCK", "N",  1, 0, "Control de stock (1/2/3)",                "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LSELPRE",   "L",  1, 0, "",                                        "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NSELPRE",   "N",  5, 0, "",                                        "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NTIPPRE",   "N",  1, 0, "",                                        "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NPESOKG",   "N", 16, 6, "Peso del artículo" ,                      "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "CUNIDAD",   "C",  2, 0, "Unidad de medición del peso" ,            "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NVOLUMEN",  "N", 16, 6, "Volumen del artículo" ,                   "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "CVOLUMEN",  "C",  2, 0, "Unidad de medición del volumen" ,         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NLNGART",   "N", 16, 6, "Largo del artículo" ,                     "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "NALTART",   "N", 16, 6, "Alto del artículo" ,                      "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "NANCART",   "N", 16, 6, "Ancho del artículo" ,                     "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "CUNDDIM",   "C",  2, 0, "Unidad de medición de las longitudes" ,   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPPES",   "N", 15, 6, "Importe de peso/volumen del articulo" ,   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CIMAGEN",   "C",250, 0, "Fichero de imagen" ,                      "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lSndDoc",   "L",  1, 0, "Lógico para envios" ,                     "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodUsr",   "C",  3, 0, "Código de usuario que realiza el cambio" ,"",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "dFecChg",   "D",  8, 0, "Fecha de cambio" ,                        "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cTimChg",   "C",  5, 0, "Hora de cambio" ,                         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lKitArt",   "L",  1, 0, "Lógico de escandallos" ,                  "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lKitAsc",   "L",  1, 0, "Lógico de asociado" ,                     "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nKitImp",   "N",  1, 0, "" ,                                       "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nKitStk",   "N",  1, 0, "" ,                                       "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nKitPrc",   "N",  1, 0, "" ,                                       "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lAutSer",   "L",  1, 0, "Lógico de autoserializar" ,               "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LOBS",      "L",  1, 0, "Lógico de obsoleto" ,                     "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LNUMSER",   "L",  1, 0, "Lógico solicitar numero de serie" ,       "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CPRVHAB",   "C", 12, 0, "Proveedor habitual" ,                     "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LFACCNV",   "L",  1, 0, "Usar factor de conversión" ,              "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CFACCNV",   "C",  2, 0, "Código del factor de conversión" ,        "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCODTNK",   "C",  3, 0, "Código del tanque de combustible" ,       "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCODTIP",   "C",  3, 0, "Código del tipo de artículo" ,            "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LTIPACC",   "L",  1, 0, "Lógico de acceso por unidades o importe", "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LCOMBUS",   "L",  1, 0, "Lógico si el artículo es del tipo combustible", "",             "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCODIMP",   "C",  3, 0, "Código del impuesto especiales",          "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LMSGVTA",   "L",  1, 0, "Lógico para avisar en venta sin stock",   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LNOTVTA",   "L",  1, 0, "Lógico para no permitir venta sin stock", "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NLOTE",     "N",  9, 0, "",                                        "'999999999'",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CLOTE",     "C", 12, 0, "Número de lote",                          "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LLOTE",     "L",  1, 0, "Lote (S/N)",                              "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LPUBINT",   "L",  1, 0, "Lógico para publicar en internet (S/N)",  "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LPUBOFE",   "L",  1, 0, "Lógico para publicar como oferta (S/N)",  "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LPUBPOR",   "L",  1, 0, "Lógico para publicar como artículo destacado (S/N)",  "",       "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NDTOINT1",  "N",  6, 2, "Descuento de oferta para tienda web 1",   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPINT1",  "N", 15, 6, "Precio del producto en oferta 1",         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPIVA1",  "N", 15, 6, "Precio del producto en oferta con " + cImp() + " 1", "",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NDTOINT2",  "N",  6, 2, "Descuento de oferta para tienda web 2",   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPINT2",  "N", 15, 6, "Precio del producto en oferta 2",         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPIVA2",  "N", 15, 6, "Precio del producto en oferta con " + cImp() + " 2", "",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NDTOINT3",  "N",  6, 2, "Descuento de oferta para tienda web 3",   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPINT3",  "N", 15, 6, "Precio del producto en oferta 3",         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPIVA3",  "N", 15, 6, "Precio del producto en oferta con " + cImp() + " 3", "",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NDTOINT4",  "N",  6, 2, "Descuento de oferta para tienda web 4",   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPINT4",  "N", 15, 6, "Precio del producto en oferta 4",         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPIVA4",  "N", 15, 6, "Precio del producto en oferta con " + cImp() + " 4", "",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NDTOINT5",  "N",  6, 2, "Descuento de oferta para tienda web 5",   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPINT5",  "N", 15, 6, "Precio del producto en oferta 5",         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPIVA5",  "N", 15, 6, "Precio del producto en oferta con " + cImp() + " 5", "",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NDTOINT6",  "N",  6, 2, "Descuento de oferta para tienda web 6",   "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPINT6",  "N", 15, 6, "Precio del producto en oferta 6",         "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NIMPIVA6",  "N", 15, 6, "Precio del producto en oferta con " + cImp() + " 6", "",        "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NMESGRT",   "N",  2, 0, "Meses de garantía",                       "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NINFENT",   "N",  1, 0, "Información de entrega",                  "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NINFENT1",  "N",  3, 0, "Dias en entregar la mercancia ( desde )", "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NINFENT2",  "N",  3, 0, "Dias en entregar la mercancia ( hasta )", "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "MDESTEC",   "M", 10, 0, "Descripción técnica del artículo",        "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NLNGCAJ",   "N", 16, 6, "Largo de la caja" ,                       "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "NALTCAJ",   "N", 16, 6, "Alto de la caja" ,                        "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "NANCCAJ",   "N", 16, 6, "Ancho de la caja" ,                       "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "CUNDCAJ",   "C",  2, 0, "Unidad de medición de la caja" ,          "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NPESCAJ",   "N", 16, 6, "Peso de la caja" ,                        "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCAJPES",   "C",  2, 0, "Unidad de medición del peso de la caja" , "",                   "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NVOLCAJ",   "N", 16, 6, "Volumen de la caja" ,                     "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCAJVOL",   "C",  2, 0, "Unidad de medición del volumen de la caja","",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NCAJPLT",   "N", 16, 6, "Número de cajas por palets" ,             "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "NBASPLT",   "N", 16, 6, "Base del palet" ,                         "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "NALTPLT",   "N", 16, 6, "Altura del palet" ,                       "'@E 999,999.999999'","", "( cDbfArt )", nil } )
   aAdd( aBase, { "CUNDPLT",   "C",  2, 0, "Unidad de medición de la altura del palet","",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LINCTCL",   "L",  1, 0, "Incluir en pantalla táctil",               "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CDESTCL",   "C", 20, 0, "Descripción en pantalla táctil",           "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CDESCMD",   "M", 10, 0, "Descripción para comanda",                 "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NPOSTCL",   "N", 16, 6, "Posición en pantalla táctil",              "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCODCAT",   "C",  4, 0, "Código del catálogo del artículo" ,        "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NPUNTOS",   "N", 16, 6, "Puntos del catalogo" ,                     "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NDTOPNT",   "N",  6, 2, "Dto. del catalogo" ,                       "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "NRENMIN",   "N",  6, 2, "Rentabilidad mínima" ,                     "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCODCATE",  "C",  3, 0, "Código de categoría",                      "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCODTEMP",  "C",  3, 0, "Código de la temporada",                   "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LECOTASA",  "L",  1, 0, "Lógico para usar ECOTASA",                 "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LMOSCOM",   "L",  1, 0, "Lógico mostrar comentario" ,               "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "MCOMENT",   "M", 10, 0, "Comentario a mostrar" ,                    "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "LPUNTO",    "L",  1, 0, "Lógico para trabajar con puntos" ,         "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCODPRP1",  "C", 20, 0, "Código de la primera propiedad" ,          "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "CCODPRP2",  "C", 20, 0, "Código de la segunda propiedad" ,          "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lCodPrp",   "L",  1, 0, "" ,                                        "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodFra",   "C",  3, 0, "Código de frases publiciarias",            "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodWeb",   "N", 11, 0, "Código del producto en la web",            "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nPosTpv",   "N", 10, 2, "Posición para mostrar en TPV táctil",      "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDuracion", "N",  3, 0, "Duración del producto",                    "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nTipDur",   "N",  1, 0, "Tipo duración (dia, mes, año)",            "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodFab",   "C",  3, 0, "Código del fabricante",                    "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nImpCom1",  "N",  1, 0, "Impresora de comanda 1",                   "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nImpCom2",  "N",  1, 0, "Impresora de comanda 2",                   "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lMsgMov",   "L",  1, 0, "Lógico para avisar en movimientos sin stock","",                "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cImagenWeb","C",250, 0, "Imagen para la web",                       "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cChgBar",   "D",  8, 0, "Fecha de cambio de código de barras",      "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodUbi1",  "C",  5, 0, "Código primera ubicación",                 "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodUbi2",  "C",  5, 0, "Código segunda ubicación",                 "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodUbi3",  "C",  5, 0, "Código tercera ubicación",                 "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cValUbi1",  "C",  5, 0, "Valor primera ubicación",                  "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cValUbi2",  "C",  5, 0, "Valor segunda ubicación",                  "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cValUbi3",  "C",  5, 0, "Valor tercera ubicación",                  "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "dFecVta",   "D",  8, 0, "Fecha de puesta a la venta",               "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "dFinVta",   "D",  8, 0, "Fecha de fin de la venta",                 "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lMsgSer",   "L",  1, 0, "Avisar en ventas por series sin stock",    "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cValPrp1",  "C", 10, 0, "Valor de la primera propiedad",            "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cValPrp2",  "C", 10, 0, "Valor de la segunda propiedad",            "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "mValPrp1",  "M", 10, 0, "Valores seleccionables de la primera propiedad", "",            "", "( cDbfArt )", nil } )
   aAdd( aBase, { "mValPrp2",  "M", 10, 0, "Valores seleccionables de la segunda propiedad", "",            "", "( cDbfArt )", nil } )
   aAdd( aBase, { "dChgBar",   "D",  8, 0, "Fecha de cambio de codigos de barras",     "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodSus",   "C", 18, 0, "Código del artículo al que se sustituye" , "'@!'",              "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodPor",   "C", 18, 0, "Código del artículo por el que es sustituido" , "'@!'",         "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDtoArt1",  "N",  6, 2, "Primer descuento de artículo",             "@EZ 99.99",         "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDtoArt2",  "N",  6, 2, "Segundo descuento de artículo",            "@EZ 99.99",         "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDtoArt3",  "N",  6, 2, "Tercer descuento de artículo",             "@EZ 99.99",         "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDtoArt4",  "N",  6, 2, "Cuarto descuento de artículo",             "@EZ 99.99",         "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDtoArt5",  "N",  6, 2, "Quinto descuento de artículo",             "@EZ 99.99",         "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDtoArt6",  "N",  6, 2, "Sexto descuento de artículo",              "@EZ 99.99",         "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lMarAju",   "L",  1, 0, "Lógico para utilizar el margen de ajuste", "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cMarAju",   "C",  5, 0, "Cadena descriptiva del margen de ajuste",  "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nTarWeb",   "N",  1, 0, "Tarifa a aplicar en la Web" ,              "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "pVtaWeb",   "N", 16, 6, "Precio venta en la Web",                   "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cTipImp1",  "C", 50, 0, "Tipo impresora comanda 1",                 "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cTipImp2",  "C", 50, 0, "Tipo impresora comanda 2",                 "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cRefPrv",   "C", 18, 0, "Referencia del proveedor al artículo" ,    "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cCodSec",   "C",  3, 0, "Código de la sección para producción" ,    "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nFacCnv",   "N", 16, 6, "Factor de conversión" ,                    "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lSbrInt",   "L",  1, 0, "Lógico precio libre internet" ,            "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nColBtn",   "N", 10, 0, "Color para táctil" ,                       "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cOrdOrd",   "C",  2, 0, "Orden de comanda" ,                        "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lTerminado","L",  1, 0, "Lógico de producto terminado (producción)" , "",                "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lPeso",     "L",  1, 0, "Lógico de producto por peso",              "",                  "", "( cDbfArt )", nil } )

return ( aBase )


/*
Estructura de escandallos
*/

Function aItmKit()

   local aBase := {}

   aAdd( aBase, { "cCodKit",   "C", 18, 0, "Código del contenedor"               , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cRefKit",   "C", 18, 0, "Código de artículo escandallo"       , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nUndKit",   "N", 16, 6, "Unidades de escandallo"              , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nPreKit",   "N", 16, 6, "Precio de escandallo"                , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cDesKit",   "C", 50, 0, "Descripción del escandallo"          , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "cUniDad",   "C",  2, 0, "Unidad de medición"                  , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nValPnt",   "N", 16, 6, ""                                    , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "nDtoPnt",   "N",  6, 2, "Descuento del punto"                 , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lAplDto",   "L",  1, 0, "Lógico aplicar descuentos"           , "",                  "", "( cDbfArt )", nil } )
   aAdd( aBase, { "lExcPro",   "L",  1, 0, "Lógico para excluir de producción"   , "",                  "", "( cDbfArt )", nil } )

Return ( aBase )

//----------------------------------------------------------------------------//
