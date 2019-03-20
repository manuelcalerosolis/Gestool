#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS ProductOdooConvert

   DATA oController

   DATA oTextFile

   DATA cDatabaseFile

   DATA nPack                          INIT 0

   METHOD New( oController )

   METHOD isGetFile()

   METHOD Run()

   METHOD openDatabase() 

   METHOD createFile()

   METHOD closeFile()                  INLINE ( ::oTextFile:Close() )

   METHOD writeHeader()

   METHOD convert()

   METHOD closeDatabse()               INLINE ( WAREA->( dbclosearea() ) )

   METHOD isNewFile()

END CLASS

//----------------------------------------------------------------------------//

METHOD New( oController )

   ::oController  := oController

RETURN ( self )

//----------------------------------------------------------------------------//

METHOD isGetFile()

   ::cDatabaseFile  := ::oController:cDirectory + "\Articulo.dbf"

   if empty( ::cDatabaseFile )
      RETURN ( .f. )
   end if 

   if !( file( ::cDatabaseFile ) )
      RETURN ( .f. )
   end if 

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD Run()

   if !( ::isGetFile() ) 
      RETURN ( .f. )
   end if 

   if !( ::openDatabase() )
      RETURN ( .f. )
   end if 

   ::createFile()

   ::writeHeader()

   ::convert()

   ::closeDatabse()

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD openDatabase()

   dbUseArea( .t., "DBFCDX", ::cDatabaseFile, "WAREA", .t., .f. )

   if WAREA->( neterr() )
      RETURN ( .f. )
   end if 

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD createFile()

   ++::nPack

   ferase( ::oController:cDirectory + "\product_template_" + hb_ntos( ::nPack ) + ".csv" )

   ::oTextFile    := TTxtFile():New( ::oController:cDirectory + "\product_template_" + hb_ntos( ::nPack ) + ".csv" )

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD writeHeader()

   if ::oTextFile:Open()
      ::oTextFile:Add( "External ID;Name;Product Type;Internal Reference;Barcode;Sales Price;Cost;Weight;Sale Description" )
   endif

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD Convert()

   local nId         := 0
   local nProcesed   := 0

   ::oController:oMeterProductos:SetTotal( WAREA->( reccount() ) )

   WAREA->( dbgotop() )

   while !( WAREA->( eof() ) )

      ::oTextFile:Add(                                      ;
         "product_template_" + hb_ntos( ++nId )    + ";" +  ; // id
         alltrim( WAREA->nombre )                  + ";" +  ; // name
         ""                                        + ";" +  ; // Product Type
         WAREA->codigo                             + ";" +  ; // Internal Reference
         WAREA->codebar                            + ";" +  ; // Barcode
         hb_ntos( WAREA->pventa1 )                 + ";" +  ; // Sales Price
         hb_ntos( WAREA->pcosto )                  + ";" +  ; // Cost
         hb_ntos( WAREA->npesokg )                 + ";" +  ; // Weight
         alltrim( WAREA->descrip )                          ; // Sale Description
      )

      WAREA->( dbskip() )

      ::isNewFile( ++nProcesed )

      ::oController:oMeterProductos:Set( nProcesed )

   end

   ::closeFile()

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD isNewFile( nPosition )

   if mod( nPosition, 1000 ) == 0

      ::closeFile()
      
      ::createFile()

      ::writeHeader()

   end if 

RETURN ( nil )

//----------------------------------------------------------------------------//

