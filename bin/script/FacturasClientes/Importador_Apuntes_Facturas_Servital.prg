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

   ImportadorFacturas():New()

   msgInfo( "Proceso finalizado")

Return ( nil )

//---------------------------------------------------------------------------//

CLASS ImportadorFacturas

   DATA oOleExcel

   DATA aFichero              INIT {}
   
   DATA nRow
   DATA nLineaComienzo        INIT 2

   DATA fechaApunte

   METHOD New()               CONSTRUCTOR

   METHOD addFichero()  

   METHOD processFile()

      METHOD getRow()
      METHOD validRow()
      METHOD processRow()
      METHOD emptyRow()       INLINE ( empty( ::fechaApunte ) )

   METHOD getRange()
   METHOD getNumeric()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS ImportadorFacturas

   local cFichero

   ::addFichero()
   if empty( ::aFichero )
      Return ( Self )
   end if 

   for each cFichero in ::aFichero
      if !empty( cFichero )
         msgRun( "Procesando hoja de calculo " + cFichero, "Espere", {|| ::ProcessFile( cFichero ) } )
      end if 
   next 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD AddFichero() CLASS ImportadorFacturas

   local i
   local cFile
   local aFile
   local nFlag    := nOr( OFN_PATHMUSTEXIST, OFN_NOCHANGEDIR, OFN_ALLOWMULTISELECT, OFN_EXPLORER, OFN_LONGNAMES )

   ::aFichero     := {}

   cFile          := cGetFile( "Excel ( *.Xls ) | *.xls |Excel ( *.Xlsx ) | *.xlsx", "Seleccione los ficheros a importar", "*.*" , , .f., .t., nFlag )
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

METHOD ProcessFile( cFichero ) CLASS ImportadorFacturas

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

      sysrefresh()

      for ::nRow := ::nLineaComienzo to 65536

         msgWait( "Procesando linea " + str(::nRow), "", 0.0001 )

         ::getRow()

         if ::validRow()
            ::processRow()
         end if 

         if ::emptyRow()
            msgAlert( "SALIDA" )
            exit 
         end if

         sysrefresh()

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

METHOD getRow() CLASS ImportadorFacturas

   ::fechaApunte  := ::GetRange( "A" )

Return ( nil )

//---------------------------------------------------------------------------//

METHOD validRow() CLASS ImportadorFacturas

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD ProcessRow() CLASS ImportadorFacturas

   msgAlert( ::fechaApunte )

Return ( nil )

//---------------------------------------------------------------------------//

METHOD getRange( cColumn ) CLASS ImportadorFacturas

   local oError
   local oBlock
   local uValue

   oBlock         := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      uValue      := ::oOleExcel:oExcel:ActiveSheet:Range( cColumn + lTrim( Str( ::nRow ) ) ):Value

   RECOVER USING oError

      msgStop( "Imposible obtener columna de excel" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( uValue )

//---------------------------------------------------------------------------//

METHOD getDate( cColumn ) CLASS ImportadorFacturas

   local dValue   := ::getRange( cColumn )

   if valtype( dValue ) == "C"
      dValue      := ctod( dValue )
   end if 

Return ( dValue )

//---------------------------------------------------------------------------//

METHOD getNumeric( cColumn ) CLASS ImportadorFacturas

   local nValue   := ::getRange( cColumn )

   if Valtype( nValue ) == "C"
      nValue      := Val( StrTran( nValue, ",", "." ) )
   end if 

Return ( nValue ) 

//------------------------------------------------------------------------


