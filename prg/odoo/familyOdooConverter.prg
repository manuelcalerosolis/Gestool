#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS FamilyOdooConvert

   DATA oController

   DATA oTextFile

   DATA cDatabaseFile

   METHOD New( oController )

   METHOD isGetFile()

   METHOD Run()

   METHOD openDatabase() 

   METHOD createFile()

   METHOD closeFile()                  INLINE ( ::oTextFile:Close() )

   METHOD writeHeader()

   METHOD convert()

   METHOD closeDatabse()               INLINE ( WAREA->( dbclosearea() ) )

END CLASS

//----------------------------------------------------------------------------//

METHOD New( oController )

   ::oController  := oController

RETURN ( self )

//----------------------------------------------------------------------------//

METHOD isGetFile()

   ::cDatabaseFile  := ::oController:cDirectory + "\Familias.dbf"

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

   ferase( ::oController:cDirectory + "\res_category.csv" )

   ::oTextFile    := TTxtFile():New( ::oController:cDirectory + "\res_category.csv" )

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD writeHeader()

   if ::oTextFile:Open()
      ::oTextFile:Add( "External ID;Name" )
   endif

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD Convert()

   local nId         := 0
   local nProcesed   := 0

   ::oController:oMeterFamilias:SetTotal( WAREA->( reccount() ) )

   WAREA->( dbgotop() )

   while !( WAREA->( eof() ) )

      ::oTextFile:Add(                                ;
         "res_category_" + hb_ntos( ++nId )  + ";" +  ; // id
         alltrim( WAREA->cnomfam )                     ; // name
      )

      WAREA->( dbskip() )

      ::oController:oMeterFamilias:Set( ++nProcesed )

   end

   ::closeFile()

RETURN ( nil )

//----------------------------------------------------------------------------//



