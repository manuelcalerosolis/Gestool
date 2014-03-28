#include "hbclass.ch"

#define CRLF chr( 13 ) + chr( 10 )

//---------------------------------------------------------------------------//

CLASS Redur FROM Cuaderno

   DATA cTipoRegisto                      INIT 'R00'
   DATA cCodigoCliente                    INIT 'CAZU' 
   DATA nTracking                         INIT 0
   DATA cRemitente                        INIT ''
   DATA cCodigoConsignatario              INIT ''
   DATA cDocumentacion                    INIT 'SALIDAS NACIONALES'
   DATA cProducto                         INIT '002'
   DATA dPreparacion                      INIT date() 
   DATA dRecogida                         INIT date() 
   DATA cNombreConsignatario              INIT ''
   DATA cDireccionConsignatario           INIT ''
   DATA cPoblacionConsignatario           INIT ''
   DATA cCodigoPostalConsignatario        INIT ''
   DATA cProvinciaConsignatario           INIT ''
   DATA cTipoMercancia                    INIT '05'
   DATA nBultos                           INIT 0
   DATA nPeso                             INIT 0

   METHOD TipoRegisto( cValue )                 INLINE ( if( !Empty( cValue ), ::cTipoRegisto               := cValue, padr( ::cTipoRegisto, 3 ) )
   METHOD CodigoCliente( cValue )               INLINE ( if( !Empty( cValue ), ::cCodigoCliente             := cValue, padr( ::cCodigoCliente, 12 ) )
   METHOD Tracking( cValue )                    INLINE ( if( !Empty( cValue ), ::nTracking                  := cValue, padr( str( ::nTracking ), 14 ) )
   METHOD Remitente( cValue )                   INLINE ( if( !Empty( cValue ), ::cRemitente                 := cValue, padr( ::cRemitente, 12 ) )
   METHOD CodigoConsignatario( cValue )         INLINE ( if( !Empty( cValue ), ::cCodigoConsignatario       := cValue, padr( ::cCodigoConsignatario, 12 ) )
   METHOD Documentacion( cValue )               INLINE ( if( !Empty( cValue ), ::cDocumentacion             := cValue, padr( ::cDocumentacion, 20 ) )
   METHOD Producto( cValue )                    INLINE ( if( !Empty( cValue ), ::cProducto                  := cValue, padr( ::cProducto, 3 ) )
   METHOD Preparacion( cValue )                 INLINE ( if( !Empty( cValue ), ::dPreparacion               := cValue, dtos( ::dPreparacion ) )
   METHOD Recogida( cValue )                    INLINE ( if( !Empty( cValue ), ::dRecogida                  := cValue, dtos( ::dRecogida ) )
   METHOD NombreConsignatario( cValue )         INLINE ( if( !Empty( cValue ), ::cNombreConsignatario       := cValue, padr( ::cNombreConsignatario, 35 ) )
   METHOD DireccionConsignatario( cValue )      INLINE ( if( !Empty( cValue ), ::cDireccionConsignatario    := cValue, padr( ::cDireccionConsignatario, 60 ) )
   METHOD PoblacionConsignatario( cValue )      INLINE ( if( !Empty( cValue ), ::cPoblacionConsignatario    := cValue, padr( ::cPoblacionConsignatario, 35 ) )
   METHOD CodigoPostalConsignatario( cValue )   INLINE ( if( !Empty( cValue ), ::cCodigoPostalConsignatario := cValue, padr( ::cCodigoPostalConsignatario, 10 ) )
   METHOD ProvinciaConsignatario( cValue )      INLINE ( if( !Empty( cValue ), ::cProvinciaConsignatario    := cValue, padr( ::cProvinciaConsignatario, 25 ) )
   METHOD TipoMercancia( cValue )               INLINE ( if( !Empty( cValue ), ::cTipoMercancia             := cValue, padr( ::cTipoMercancia, 2 ) )
   METHOD Bultos( cValue )                      INLINE ( if( !Empty( cValue ), ::nBultos                    := cValue, strzero( ::nBultos, 6 ) )
   METHOD Peso( cValue )                        INLINE ( if( !Empty( cValue ), ::nPeso                      := cValue, strzero( round( ::nPeso * 10, 0 ), 8 ) )















   METHOD New()

   METHOD WriteASCII()
   METHOD SerializeASCII()

ENDCLASS

   //------------------------------------------------------------------------//

   METHOD New() CLASS Redur 

   Return ( Self )

   //------------------------------------------------------------------------//

   METHOD WriteASCII() CLASS Redur 

      ::hFile  := fCreate( ::cFile )

      if !Empty( ::hFile )
         fWrite( ::hFile, ::SerializeASCII() )
         fClose( ::hFile )
      end if

   Return ( Self )

   //------------------------------------------------------------------------//

   METHOD SerializeASCII() CLASS Redur 

      local cBuffer     := ""

      cBuffer           := ::GetPresentador():SerializeASCII()

      cBuffer           += ::CodigoRegistro()
      cBuffer           += ::TotalImporte() 
      cBuffer           += ::TotalRegistros() 
      cBuffer           += ::TotalFinalRegistros()

   Return ( cBuffer )

//---------------------------------------------------------------------------//

