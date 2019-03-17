#include "FiveWin.Ch"
#include "Factu.ch"

#define __odoo_states__ ;    
{ ;
   { "code" => "VI", "name" => "(01) Araba/Álava" },;
   { "code" => "AB", "name" => "(02) Albacete" },;
   { "code" => "A",  "name" => "(03) Alicante/Alacant" },;
   { "code" => "AL", "name" => "(04) Almería" },;
   { "code" => "AV", "name" => "(05) Ávila" },;
   { "code" => "BA", "name" => "(06) Badajoz" },;
   { "code" => "PM", "name" => "(07) Illes Balears" },;
   { "code" => "B",  "name" => "(08) Barcelona" },;
   { "code" => "BU", "name" => "(09) Burgos" },;
   { "code" => "CC", "name" => "(10) Cáceres" },;
   { "code" => "CA", "name" => "(11) Cádiz" },;
   { "code" => "CS", "name" => "(12) Castellón/Castelló" },;
   { "code" => "CR", "name" => "(13) Ciudad Real" },;
   { "code" => "CO", "name" => "(14) Córdoba" },;
   { "code" => "C",  "name" => "(15) A Coruña" },;
   { "code" => "CU", "name" => "(16) Cuenca" },;
   { "code" => "GI", "name" => "(17) Girona" },;
   { "code" => "GR", "name" => "(18) Granada" },;
   { "code" => "GU", "name" => "(19) Guadalajara" },;
   { "code" => "SS", "name" => "(20) Gipuzkoa" },;
   { "code" => "H",  "name" => "(21) Huelva" },;
   { "code" => "HU", "name" => "(22) Huesca" },;
   { "code" => "J",  "name" => "(23) Jaén" },;
   { "code" => "LE", "name" => "(24) León" },;
   { "code" => "L",  "name" => "(25) Lleida" },;
   { "code" => "LO", "name" => "(26) La Rioja" },;
   { "code" => "LU", "name" => "(27) Lugo" },;
   { "code" => "M",  "name" => "(28) Madrid" },;
   { "code" => "MA", "name" => "(29) Málaga" },;
   { "code" => "MU", "name" => "(30) Murcia" },;
   { "code" => "NA", "name" => "(31) Navarra/Nafarroa" },;
   { "code" => "OR", "name" => "(32) Ourense" },;
   { "code" => "O",  "name" => "(33) Asturias" },;
   { "code" => "P",  "name" => "(34) Palencia" },;
   { "code" => "GC", "name" => "(35) Las Palmas" },;
   { "code" => "PO", "name" => "(36) Pontevedra" },;
   { "code" => "SA", "name" => "(37) Salamanca" },;
   { "code" => "TF", "name" => "(38) Santa Cruz de Tenerife" },;
   { "code" => "S",  "name" => "(39) Cantabria" },;
   { "code" => "SG", "name" => "(40) Segovia" },;
   { "code" => "SE", "name" => "(41) Sevilla" },;
   { "code" => "SO", "name" => "(42) Soria" },;
   { "code" => "T",  "name" => "(43) Tarragona" },;
   { "code" => "TE", "name" => "(44) Teruel" },;
   { "code" => "TO", "name" => "(45) Toledo" },;
   { "code" => "V",  "name" => "(46) Valencia/Valéncia" },;
   { "code" => "VA", "name" => "(47) Valladolid" },;
   { "code" => "BI", "name" => "(48) Bizkaia" },;
   { "code" => "ZA", "name" => "(49) Zamora" },;
   { "code" => "Z",  "name" => "(50) Zaragoza" },;
   { "code" => "CE", "name" => "(51) Ceuta" },;
   { "code" => "ML", "name" => "(52) Melilla" };
}

//---------------------------------------------------------------------------//

CLASS ClientOdooConvert

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

   METHOD getState()

   METHOD isNewFile()

END CLASS

//----------------------------------------------------------------------------//

METHOD New( oController )

   ::oController  := oController

RETURN ( self )

//----------------------------------------------------------------------------//

METHOD isGetFile()

   ::cDatabaseFile  := ::oController:cDirectory + "\Client.dbf"

   msgalert( ::cDatabaseFile, "cDatabaseFile" )

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

   ferase( "res_partner_" + hb_ntos( ::nPack ) + ".csv" )

   ::oTextFile    := TTxtFile():New( "res_partner_" + hb_ntos( ::nPack ) + ".csv" )

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD writeHeader()

   if ::oTextFile:Open()
      ::oTextFile:Add( "External ID;Name;Company Type;Related Company;Address Type;Street;Street2;City;State;ZIP;Country;Website;Phone;Mobile;Email" )
   endif

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD Convert()

   local nId         := 0
   local nProcesed   := 0

   ::oController:oMeterClientes:SetTotal( WAREA->( reccount() ) )

   WAREA->( dbgotop() )

   while !( WAREA->( eof() ) )

      ::oTextFile:Add(                                ;
         "res_partner_" + hb_ntos( ++nId )   + ";" +  ; // id
         alltrim( WAREA->titulo )            + ";" +  ; // name
         "Individual"                        + ";" +  ; // Company Type
         ""                                  + ";" +  ; // Related Company
         "Invoice address"                   + ";" +  ; // Address Type
         alltrim( WAREA->domicilio )         + ";" +  ; // Street
         ""                                  + ";" +  ; // Street 2
         alltrim( WAREA->poblacion )         + ";" +  ; // City
         ::getState()                        + ";" +  ; // State;
         alltrim( WAREA->codpostal )         + ";" +  ; // ZIP
         "ES"                                + ";" +  ; // Country
         ""                                  + ";" +  ; // Website
         alltrim( WAREA->telefono )          + ";" +  ; // Phone
         alltrim( WAREA->movil )             + ";" +  ; // Mobile
         alltrim( WAREA->cmeiint )                    ; // Email
      )

      WAREA->( dbskip() )

      ::isNewFile( ++nProcesed )

      ::oController:oMeterClientes:Set( nProcesed )

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

METHOD getState()

   local nPosition
   local cStateCode  

   if empty( WAREA->codpostal ) 
      RETURN ( "" ) 
   end if 

   cStateCode  := left( alltrim( WAREA->codpostal ), 2 )

   nPosition   := ascan( __odoo_states__, {| hState | cStateCode $ hget( hState, "name" ) } )
   if nPosition != 0
      RETURN ( hget( __odoo_states__[ nPosition ], "code" ) )
   end if 

RETURN ( "" )

//----------------------------------------------------------------------------//


