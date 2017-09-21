#include "hbclass.ch"

#define CRLF chr( 13 ) + chr( 10 )

//---------------------------------------------------------------------------//

Function Inicio()

/*
   local oError
   local oBlock

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
*/
   
   ImportacionUVERisi():New()

/*
   RECOVER USING oError
      msgStop( "Error en la ejecución del script." + CRLF + ErrorMessage( oError ) )
   END SEQUENCE
   ErrorBlock( oBlock )
*/

RETURN ( nil )

//---------------------------------------------------------------------------//

CREATE CLASS ImportacionUVERisi

   DATA nView

   DATA oUve

   DATA oDlg

   DATA cFileUVE
   DATA nFileHandle

   DATA aUVELines                               INIT {}

   DATA currentInvoice

   DATA calculateInvoice

   DATA serieInvoice
   DATA numberInvoice
   DATA delegationInvoice

   DATA nLineNumber                             INIT 0

   DATA aSepartors                              INIT { "|#|", ";" }
   DATA cSeparator                              INIT "|#|"

   DATA oComboDistributor

   DATA aDitributors                            INIT { "90 - Blanco", "91 - Begines", "92 - Dismaga", "93 - Jujuca", "94 - Gonzalo Marin", "Vacio" }
   DATA cDistributor                            INIT "90 - Blanco"

   DATA oComboSeparator
   DATA oComboDistributor

/*
   DATA aCarpetas                               INIT  {  {  "Blanco"    =>  { "Delimitador" => ";", "IdCliente" => "C1", "Segmentacion" => { { "06" => "01" },;
                                                                                                                                             { "07" => "02" } } },;
                                                            "Begines"   =>  { "Delimitador" => ";", "IdCliente" => "C1", "Segmentacion" => { { "06" => "01" },;
                                                                                                                                             { "07" => "02" } } },;
                                                            "Zoyo"      =>  { "Delimitador" => ";", "IdCliente" => "C1", "Segmentacion" => { { "06" => "01" },;
*/

   DATA hSegmentacion                           INIT  {  "V6"        => {  "0105" => "0001",;
                                                                           "0001" => "0001",;
                                                                           "0111" => "0002",;
                                                                           "0002" => "0002",;
                                                                           "0101" => "0003",;
                                                                           "0100" => "0004",; 
                                                                           "0011" => "0004",;
                                                                           "0004" => "0004",;
                                                                           "0000" => "0004",;
                                                                           "0103" => "0005",;
                                                                           "0005" => "0005",;
                                                                           "0006" => "0006",;
                                                                           "0107" => "0007",; 
                                                                           "0007" => "0007",; 
                                                                           "0106" => "0006",;  
                                                                           "0108" => "0008",;
                                                                           "0008" => "0008",;
                                                                           "0109" => "0009",;
                                                                           "0104" => "0010",;
                                                                           "0010" => "0010",;
                                                                           "0110" => "0011",;
                                                                           "0030" => "0011",;
                                                                           "0003" => "0011",;
                                                                           "0025" => "0012",;                                                                          
                                                                           "0112" => "0012" },;
                                                         "V1"        => {  "0001" => "0004",;    
                                                                           "0005" => "0001",;
                                                                           "0002" => "0003",;
                                                                           "0003" => "0005",;
                                                                           "0004" => "0010",;
                                                                           "0010" => "0011" },;
                                                         "V7"        => {  "0006" => "0001",;    
                                                                           "0011" => "0002",;
                                                                           "0001" => "0003",;
                                                                           "0002" => "0004",;
                                                                           "0003" => "0005",;
                                                                           "0007" => "0008",;
                                                                           "0008" => "0009",;
                                                                           "0009" => "0010",;
                                                                           "0010" => "0011" },;
                                                         "V8"        => {  "0006" => "0001",;    
                                                                           "0011" => "0002",;
                                                                           "0001" => "0003",;
                                                                           "0002" => "0004",;
                                                                           "0003" => "0005",;
                                                                           "0007" => "0008",;
                                                                           "0008" => "0009",;
                                                                           "0009" => "0010",;
                                                                           "0010" => "0011" } ,;
                                                         "V9"        => {  "0006" => "0001",;    
                                                                           "0011" => "0002",;
                                                                           "0001" => "0003",;
                                                                           "0002" => "0004",;
                                                                           "0003" => "0005",;
                                                                           "0007" => "0008",;
                                                                           "0008" => "0009",;
                                                                           "0009" => "0010",;
                                                                           "0010" => "0011" },;
                                                         "V10"        => { "0006" => "0001",;    
                                                                           "0011" => "0002",;
                                                                           "0001" => "0003",;
                                                                           "0002" => "0004",;
                                                                           "0003" => "0005",;
                                                                           "0007" => "0008",;
                                                                           "0008" => "0009",;
                                                                           "0009" => "0010",;
                                                                           "0010" => "0011" }}

   DATA hVendedores                             INIT  {  { "Delegacion" => "02", "Vendedor" => "027", "CodigoVendedor" => "V1", "NombreVendedor" => "CARLOS CONDE",                 "IdCliente" => "C1" },;
                                                         { "Delegacion" => "75", "Vendedor" => "001", "CodigoVendedor" => "V2", "NombreVendedor" => "MANUEL MARTIN JIMENEZ",        "IdCliente" => "C2" },;
                                                         { "Delegacion" => "76", "Vendedor" => "001", "CodigoVendedor" => "V2", "NombreVendedor" => "MANUEL MARTIN JIMENEZ",        "IdCliente" => "C2" },;
                                                         { "Delegacion" => "77", "Vendedor" => "001", "CodigoVendedor" => "V2", "NombreVendedor" => "MANUEL MARTIN JIMENEZ",        "IdCliente" => "C2" },;
                                                         { "Delegacion" => "7",  "Vendedor" => "001", "CodigoVendedor" => "V2", "NombreVendedor" => "MANUEL MARTIN JIMENEZ",        "IdCliente" => "C2" },;
                                                         { "Delegacion" => "75", "Vendedor" => "002", "CodigoVendedor" => "V3", "NombreVendedor" => "JUAN MANUEL MARTIN RUIZ",      "IdCliente" => "C2" },;
                                                         { "Delegacion" => "75", "Vendedor" => "",    "CodigoVendedor" => "V3", "NombreVendedor" => "JUAN MANUEL MARTIN RUIZ",      "IdCliente" => "C2" },;
                                                         { "Delegacion" => "76", "Vendedor" => "002", "CodigoVendedor" => "V3", "NombreVendedor" => "JUAN MANUEL MARTIN RUIZ",      "IdCliente" => "C2" },;
                                                         { "Delegacion" => "77", "Vendedor" => "002", "CodigoVendedor" => "V3", "NombreVendedor" => "JUAN MANUEL MARTIN RUIZ",      "IdCliente" => "C2" },;
                                                         { "Delegacion" => "7",  "Vendedor" => "002", "CodigoVendedor" => "V3", "NombreVendedor" => "JUAN MANUEL MARTIN RUIZ",      "IdCliente" => "C2" },;
                                                         { "Delegacion" => "36", "Vendedor" => "035", "CodigoVendedor" => "V4", "NombreVendedor" => "ENRIQUE FERNANDEZ ZOYO",       "IdCliente" => "C3" },;
                                                         { "Delegacion" => "91", "Vendedor" => "000", "CodigoVendedor" => "V6", "NombreVendedor" => "MANUEL BEGINES",               "IdCliente" => "C5" },;
                                                         { "Delegacion" => "91", "Vendedor" => "V6",  "CodigoVendedor" => "V6", "NombreVendedor" => "MANUEL BEGINES",               "IdCliente" => "C5" },;
                                                         { "Delegacion" => "40", "Vendedor" => "040", "CodigoVendedor" => "V5", "NombreVendedor" => "JOSE ANTONIO NIETO",           "IdCliente" => "C4" },;
                                                         { "Delegacion" => "00", "Vendedor" => "011", "CodigoVendedor" => "V7", "NombreVendedor" => "GENESIS CENTRAL",              "IdCliente" => "GE" },;
                                                         { "Delegacion" => "00", "Vendedor" => "COO", "CodigoVendedor" => "V7", "NombreVendedor" => "GENESIS CENTRAL",              "IdCliente" => "GE" },;
                                                         { "Delegacion" => "00", "Vendedor" => "NAV", "CodigoVendedor" => "V7", "NombreVendedor" => "GENESIS CENTRAL",              "IdCliente" => "GE" },;
                                                         { "Delegacion" => "00", "Vendedor" => "",    "CodigoVendedor" => "V7", "NombreVendedor" => "GENESIS CENTRAL",              "IdCliente" => "GE" },;
                                                         { "Delegacion" => "00", "Vendedor" => "001", "CodigoVendedor" => "V7", "NombreVendedor" => "GENESIS CENTRAL",              "IdCliente" => "GE" },;
                                                         { "Delegacion" => "02", "Vendedor" => "",    "CodigoVendedor" => "V8", "NombreVendedor" => "ESPINOLA",                     "IdCliente" => "GE" },;
                                                         { "Delegacion" => "02", "Vendedor" => "COO", "CodigoVendedor" => "V8", "NombreVendedor" => "ESPINOLA",                     "IdCliente" => "GE" },;
                                                         { "Delegacion" => "02", "Vendedor" => "011", "CodigoVendedor" => "V8", "NombreVendedor" => "ESPINOLA",                     "IdCliente" => "GE" },;
                                                         { "Delegacion" => "02", "Vendedor" => "NAV", "CodigoVendedor" => "V8", "NombreVendedor" => "ESPINOLA",                     "IdCliente" => "GE" },;
                                                         { "Delegacion" => "03", "Vendedor" => "011", "CodigoVendedor" => "V9", "NombreVendedor" => "ZAMUDIO",                      "IdCliente" => "GE" },;
                                                         { "Delegacion" => "03", "Vendedor" => "NAV", "CodigoVendedor" => "V9", "NombreVendedor" => "ZAMUDIO",                      "IdCliente" => "GE" },;
                                                         { "Delegacion" => "03", "Vendedor" => "",    "CodigoVendedor" => "V9", "NombreVendedor" => "ZAMUDIO",                      "IdCliente" => "GE" },;
                                                         { "Delegacion" => "03", "Vendedor" => "003", "CodigoVendedor" => "V9", "NombreVendedor" => "ZAMUDIO",                      "IdCliente" => "GE" },;
                                                         { "Delegacion" => "03", "Vendedor" => "COO", "CodigoVendedor" => "V9", "NombreVendedor" => "ZAMUDIO",                      "IdCliente" => "GE" },;
                                                         { "Delegacion" => "01", "Vendedor" => "001", "CodigoVendedor" => "V10","NombreVendedor" => "JAVIER",                       "IdCliente" => "GE" },;
                                                         { "Delegacion" => "29", "Vendedor" => "SAU", "CodigoVendedor" => "V11","NombreVendedor" => "ADRIAN LEBRIJA",               "IdCliente" => "C6" },;
                                                         { "Delegacion" => "29", "Vendedor" => "ADL", "CodigoVendedor" => "V11","NombreVendedor" => "ADRIAN LEBRIJA",               "IdCliente" => "C6" },;
                                                         { "Delegacion" => "29", "Vendedor" => "",    "CodigoVendedor" => "V11","NombreVendedor" => "ADRIAN LEBRIJA",               "IdCliente" => "C6" },;
                                                         { "Delegacion" => "66", "Vendedor" => "066", "CodigoVendedor" => "V12","NombreVendedor" => "JESUS PARI",                   "IdCliente" => "C7" },;
                                                         { "Delegacion" => "31", "Vendedor" => "030", "CodigoVendedor" => "V13","NombreVendedor" => "JOSELE",                       "IdCliente" => "C8" },;
                                                         { "Delegacion" => "73", "Vendedor" => "001", "CodigoVendedor" => "V14","NombreVendedor" => "JUAN RODRIGUEZ",               "IdCliente" => "C9" },;
                                                         { "Delegacion" => "72", "Vendedor" => "001", "CodigoVendedor" => "V14","NombreVendedor" => "JUAN RODRIGUEZ",               "IdCliente" => "C9" },;
                                                         { "Delegacion" => "23", "Vendedor" => "023", "CodigoVendedor" => "V15","NombreVendedor" => "JOSE LAVADO",                  "IdCliente" => "C10" },;
                                                         { "Delegacion" => "23", "Vendedor" => "060", "CodigoVendedor" => "V15","NombreVendedor" => "JOSE LAVADO",                  "IdCliente" => "C10" },;
                                                         { "Delegacion" => "81", "Vendedor" => "054", "CodigoVendedor" => "V16","NombreVendedor" => "MANOLO RUIZ",                  "IdCliente" => "C11" },;
                                                         { "Delegacion" => "32", "Vendedor" => "001", "CodigoVendedor" => "V17","NombreVendedor" => "JOSE PRADA",                   "IdCliente" => "C12" },;
                                                         { "Delegacion" => "11", "Vendedor" => "011", "CodigoVendedor" => "V18","NombreVendedor" => "MARIANGLES. RAFAEL PADRE",     "IdCliente" => "C13" },;
                                                         { "Delegacion" => "10", "Vendedor" => "010", "CodigoVendedor" => "V19","NombreVendedor" => "RAFAEL HIJO",                  "IdCliente" => "C13" },;
                                                         { "Delegacion" => "90", "Vendedor" => "000", "CodigoVendedor" => "V20","NombreVendedor" => "ANTONIO BLANCO",               "IdCliente" => "C14" },;
                                                         { "Delegacion" => "90", "Vendedor" => "V20", "CodigoVendedor" => "V20","NombreVendedor" => "ANTONIO BLANCO",               "IdCliente" => "C14" },;
                                                         { "Delegacion" => "67", "Vendedor" => "067", "CodigoVendedor" => "V21","NombreVendedor" => "JAVIER PARIS",                 "IdCliente" => "C15" },;
                                                         { "Delegacion" => "56", "Vendedor" => "027", "CodigoVendedor" => "V22","NombreVendedor" => "JOSE NOGUERO",                 "IdCliente" => "C16" },;
                                                         { "Delegacion" => "51", "Vendedor" => "051", "CodigoVendedor" => "V23","NombreVendedor" => "ADRIAN ORELLANA",              "IdCliente" => "C17" },;
                                                         { "Delegacion" => "51", "Vendedor" => "035", "CodigoVendedor" => "V23","NombreVendedor" => "ADRIAN ORELLANA",              "IdCliente" => "C17" },;
                                                         { "Delegacion" => "50", "Vendedor" => "",    "CodigoVendedor" => "V23","NombreVendedor" => "ADRIAN ORELLANA",              "IdCliente" => "C17" },;
                                                         { "Delegacion" => "C3", "Vendedor" => "",    "CodigoVendedor" => "D1", "NombreVendedor" => "FRANCISCO ROMERO VALLE",       "IdCliente" => "DC" },;
                                                         { "Delegacion" => "CE", "Vendedor" => " ",   "CodigoVendedor" => "D2", "NombreVendedor" => "CENTRAL DISGOMA",              "IdCliente" => "DC" },;
                                                         { "Delegacion" => "C1", "Vendedor" => "C01", "CodigoVendedor" => "D3", "NombreVendedor" => "JUAN GARRIDO MANZANARES",      "IdCliente" => "DC" },;
                                                         { "Delegacion" => "C3", "Vendedor" => "C01", "CodigoVendedor" => "D3", "NombreVendedor" => "JUAN GARRIDO MANZANARES",      "IdCliente" => "DC" },;
                                                         { "Delegacion" => "C2", "Vendedor" => "C02", "CodigoVendedor" => "D4", "NombreVendedor" => "ANGEL FERNANDEZ LUENGO",       "IdCliente" => "DC" },;
                                                         { "Delegacion" => "C1", "Vendedor" => "C02", "CodigoVendedor" => "D4", "NombreVendedor" => "ANGEL FERNANDEZ LUENGO",       "IdCliente" => "DC" },;
                                                         { "Delegacion" => "C4", "Vendedor" => "C04", "CodigoVendedor" => "D5", "NombreVendedor" => "JOSE MARIA ROMERO MANZANARES", "IdCliente" => "DC" },;
                                                         { "Delegacion" => "C2", "Vendedor" => "C04", "CodigoVendedor" => "D5", "NombreVendedor" => "JOSE MARIA ROMERO MANZANARES", "IdCliente" => "DC" },;
                                                         { "Delegacion" => "CE", "Vendedor" => "C00", "CodigoVendedor" => "D2", "NombreVendedor" => "CENTRAL DISGOMA",              "IdCliente" => "DC" },;
                                                         { "Delegacion" => "CE", "Vendedor" => "C01", "CodigoVendedor" => "D2", "NombreVendedor" => "CENTRAL DISGOMA",              "IdCliente" => "DC" },;
                                                         { "Delegacion" => "M6", "Vendedor" => "A02", "CodigoVendedor" => "D7", "NombreVendedor" => "JESUS RODRIGUEZ DE GUZMAN",    "IdCliente" => "DJ" },;
                                                         { "Delegacion" => "M5", "Vendedor" => "A02", "CodigoVendedor" => "D7", "NombreVendedor" => "JESUS RODRIGUEZ DE GUZMAN",    "IdCliente" => "DJ" },;
                                                         { "Delegacion" => "M6", "Vendedor" => "C04", "CodigoVendedor" => "D7", "NombreVendedor" => "JESUS RODRIGUEZ DE GUZMAN",    "IdCliente" => "DJ" },;
                                                         { "Delegacion" => "M2", "Vendedor" => "A01", "CodigoVendedor" => "D8", "NombreVendedor" => "JUAN DIAZ PINTADO",            "IdCliente" => "DP" },;
                                                         { "Delegacion" => "M1", "Vendedor" => "A01", "CodigoVendedor" => "D8", "NombreVendedor" => "JUAN DIAZ PINTADO",            "IdCliente" => "DP" },;
                                                         { "Delegacion" => "92", "Vendedor" => "14",  "CodigoVendedor" => "C8", "NombreVendedor" => "JUAN DIAZ MOYA.DISMAGA",       "IdCliente" => "CA7" },;
                                                         { "Delegacion" => "92", "Vendedor" => "2",   "CodigoVendedor" => "C9", "NombreVendedor" => "RAFAEL. DISMAGA",              "IdCliente" => "CA7" },;
                                                         { "Delegacion" => "92", "Vendedor" => "6",   "CodigoVendedor" => "C10","NombreVendedor" => "VTA PUBLICO. DISMAGA",         "IdCliente" => "CA7" },;
                                                         { "Delegacion" => "92", "Vendedor" => "3",   "CodigoVendedor" => "C11","NombreVendedor" => "MANOLO. DISMAGA",              "IdCliente" => "CA7" },;
                                                         { "Delegacion" => "92", "Vendedor" => "19",  "CodigoVendedor" => "C12","NombreVendedor" => "PACO ANTEQUERA. DISMAGA",      "IdCliente" => "CA7" },;
                                                         { "Delegacion" => "92", "Vendedor" => "4",   "CodigoVendedor" => "C13","NombreVendedor" => "M. ANGELES CORTIJO. DISMAGA",  "IdCliente" => "CA7" },;
                                                         { "Delegacion" => "92", "Vendedor" => "16",  "CodigoVendedor" => "C14","NombreVendedor" => "RUTA 16. DISMAGA",             "IdCliente" => "CA7" },;
                                                         { "Delegacion" => "31", "Vendedor" => "032", "CodigoVendedor" => "C15","NombreVendedor" => "MANUEL GUILLOTO",              "IdCliente" => "CA8" },;
                                                         { "Delegacion" => "31", "Vendedor" => "010", "CodigoVendedor" => "C15","NombreVendedor" => "MANUEL GUILLOTO",              "IdCliente" => "CA8" },;
                                                         { "Delegacion" => "94", "Vendedor" => "0",   "CodigoVendedor" => "C16","NombreVendedor" => "GONZALO MARIN",                "IdCliente" => "CA9" },;
                                                         { "Delegacion" => "93", "Vendedor" => "",    "CodigoVendedor" => "C7", "NombreVendedor" => "JUJUCA",                       "IdCliente" => "CA6" },;
                                                         { "Delegacion" => "21", "Vendedor" => "022", "CodigoVendedor" => "C6", "NombreVendedor" => "CRISTOBAL MARTINEZ",           "IdCliente" => "CA5" },;
                                                         { "Delegacion" => "16", "Vendedor" => "012", "CodigoVendedor" => "C5", "NombreVendedor" => "JOSE MANUEL GOMEZ",            "IdCliente" => "CA4" },;
                                                         { "Delegacion" => "51", "Vendedor" => "053", "CodigoVendedor" => "C3", "NombreVendedor" => "JUAN RODRIGUEZ.CHICLANA",      "IdCliente" => "CA3" },;
                                                         { "Delegacion" => "52", "Vendedor" => "053", "CodigoVendedor" => "C3", "NombreVendedor" => "JUAN RODRIGUEZ.CHICLANA",      "IdCliente" => "CA3" },;
                                                         { "Delegacion" => "52", "Vendedor" => "050", "CodigoVendedor" => "C3", "NombreVendedor" => "JUAN RODRIGUEZ.CHICLANA",      "IdCliente" => "CA3" },;
                                                         { "Delegacion" => "52", "Vendedor" => "054", "CodigoVendedor" => "C4", "NombreVendedor" => "DAVID. CHICLANA",              "IdCliente" => "CA3" },;
                                                         { "Delegacion" => "51", "Vendedor" => "054", "CodigoVendedor" => "C4", "NombreVendedor" => "DAVID. CHICLANA",              "IdCliente" => "CA3" },;
                                                         { "Delegacion" => "51", "Vendedor" => "050", "CodigoVendedor" => "C4", "NombreVendedor" => "DAVID. CHICLANA",              "IdCliente" => "CA3" },;
                                                         { "Delegacion" => "11", "Vendedor" => "",    "CodigoVendedor" => "C2", "NombreVendedor" => "EMILIO MOLERO",                "IdCliente" => "CA2" },;
                                                         { "Delegacion" => "11", "Vendedor" => "012", "CodigoVendedor" => "C2", "NombreVendedor" => "EMILIO MOLERO",                "IdCliente" => "CA2" },;
                                                         { "Delegacion" => "36", "Vendedor" => "012", "CodigoVendedor" => "C1", "NombreVendedor" => "MANUEL CALVO",                 "IdCliente" => "CA1" },;
                                                         { "Delegacion" => "36", "Vendedor" => "12",  "CodigoVendedor" => "C1", "NombreVendedor" => "MANUEL CALVO",                 "IdCliente" => "CA1" },;
                                                         { "Delegacion" => "36", "Vendedor" => "37",  "CodigoVendedor" => "C1", "NombreVendedor" => "MANUEL CALVO",                 "IdCliente" => "CA1" },;
                                                         { "Delegacion" => "36", "Vendedor" => "037", "CodigoVendedor" => "C1", "NombreVendedor" => "MANUEL CALVO",                 "IdCliente" => "CA1" };
                                                         }

   /*
   01 -> Kiosko
   */

   DATA codigoVendedor   
   DATA nombreVendedor    
   DATA idCliente

   METHOD New()                                 CONSTRUCTOR
   METHOD Dialog() 

   METHOD getFileUVE()
   METHOD isFileUVE() 
   METHOD openFileUVE()
   METHOD closeFileUVE()                        INLINE ( fclose( ::nFileHandle ) )
   METHOD processFileUVE()
      METHOD processLineUVE( cLine)             
         METHOD insertLineUVE( aLine )
   METHOD sortUveLinesByInvoiceId()
   METHOD processUVELinesByInvoiceId()
      METHOD isInvoiceChange( hUVELine )        
      METHOD insertInvoiceHeader( hUVELine )
      METHOD getNewInvoiceNumber( hUVELine )
      METHOD insertInvoiceLine( hUVELine )

   METHOD deleteInvoiceByReference()

   METHOD deleteInvoiceIfExist()

   METHOD getIdClient( hUVELine )

   METHOD isClient( hUVELine )
      METHOD createClient( hUVELine )

   METHOD isProduct( hUVELine )
      METHOD createProduct( hUVELine )

   METHOD isGrupoCliente( hUVELine )
      METHOD createGrupoCliente( hUVELine )

   METHOD isRuta( hUVELine )  
      METHOD createRuta( hUVELine )      

   METHOD getDataVendedor( hUVELine )           

   METHOD isAgente()
      METHOD createAgente()

   METHOD getTipoCliente( hUVELine )
   
   METHOD writeUVEtoGestool()                   VIRTUAL

   METHOD OpenFiles()
   METHOD CloseFiles()                          INLINE ( D():DeleteView( ::nView ) )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS ImportacionUVERisi

   if !::Dialog()
      RETURN ( Self )
   end if

   ::getFileUVE()

   if !::isFileUVE()
      RETURN ( Self )
   end if

   if ::openFileUVE()
      ::processFileUVE()
      ::closeFileUVE()
   end if 

   if !::OpenFiles()
      RETURN ( Self )
   end if 

   ::sortUveLinesByInvoiceId()

   ::processUVELinesByInvoiceId()

   ::CloseFiles()

   msgInfo( "Proceso finalizado" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Dialog() CLASS ImportacionUVERisi

   ::oDlg          := TDialog():New( 5, 5, 18, 60, "Importacion UVE Risi" )

   TSay():New( 1, 1, {|| "Separador" }, ::oDlg )      

   ::oComboSeparator    := TComboBox():New( 1, 6, {| u | if( pcount() == 0, ::cSeparator, ::cSeparator := u ) }, ::aSepartors, 100, , ::oDlg, , , , , , .f., nil, , .f., , .f., , , , , , "ocbx1" )

   TSay():New( 2, 1, {|| "Distribuidor" }, ::oDlg )      

   ::oComboDistributor  := TComboBox():New( 2, 6, {| u | if( pcount() == 0, ::cDistributor, ::cDistributor := u ) }, ::aDitributors, 100, , ::oDlg, , , , , , .f., nil, , .f., , .f., , , , , , "ocbx2" )

   TButton():New( 4, 4, "&Aceptar", ::oDlg, {|| ::oDlg:end( 1 ) }, 40, 12 )

   TButton():New( 4, 12, "&Cancel", ::oDlg, {|| ::oDlg:End() }, 40, 12 )

   ::oDlg:Activate( , , , .t. )

RETURN ( ::oDlg:nResult == 1 )

//---------------------------------------------------------------------------//


METHOD getFileUVE()

   ::cFileUVE  := cGetFile( "Csv ( *.* ) | " + "*.*", "Seleccione el fichero a importar" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD isFileUVE()

   if !empty( ::cFileUVE )
      RETURN ( file( ::cFileUVE ) )
   end if 

RETURN ( .f. )

//---------------------------------------------------------------------------//

METHOD openFileUVE()

   ::nFileHandle := fOpen( ::cFileUVE )

   if ferror() != 0
      RETURN ( .f. )
   end if  

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD processFileUVE()

   local cLine 

   while ( hb_freadline( ::nFileHandle, @cLine ) == 0 )
      ::processLineUVE( cLine )
   end while  
   
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD processLineUVE( cLine )

   local aLine

   // msgalert( cLine, "cLine" )

   aLine          := hb_atokens( cLine, ::cSeparator )

   if !( hb_isarray( aLine ) )
      msgalert( "La linea no se puede convertir en array.", "", .1 )
      RETURN ( Self )
   end if 

   if !( len( aLine ) >= 30 )
      msgwait( hb_valtoexp( aline ), "la linea no contiene los campos necesarios", .1 )
      RETURN ( Self )
   end if 

   ::insertLineUVE( aLine )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD insertLineUVE( aLine )

   local hUve   := {=>}

   hset( hUve, "NumeroFactura",                 aLine[ 1 ] )
   hset( hUve, "NumeroLinea",                   aLine[ 2 ] )
   hset( hUve, "CodigoProducto",                aLine[ 3 ] )
   hset( hUve, "DescripcionProducto",           aLine[ 4 ] )
   hset( hUve, "Fabricante",                    aLine[ 5 ] )
   hset( hUve, "CodigoProductoFabricante",      aLine[ 6 ] )
   hset( hUve, "EAN13",                         aLine[ 7 ] )
   hset( hUve, "Cantidad",                      val( strtran( aLine[ 8 ], ",", "." ) ) )
   hset( hUve, "UnidadMedicion",                aLine[ 9 ] )
   hset( hUve, "PrecioBase",                    val( strtran( aLine[ 10 ], ",", "." ) ) )
   hset( hUve, "Descuentos",                    val( aLine[ 11 ] ) )
   hset( hUve, "PrecioBrutoTotal",              val( aLine[ 12 ] ) )
   hset( hUve, "FechaFactura",                  aLine[ 13 ] )
   hset( hUve, "Ejercicio",                     aLine[ 14 ] )
   hset( hUve, "CodigoCliente",                 aLine[ 15 ] )
   hset( hUve, "Establecimiento",               aLine[ 16 ] )
   hset( hUve, "Nombre",                        aLine[ 17 ] )
   hset( hUve, "CIF",                           aLine[ 18 ] )
   hset( hUve, "Direccion",                     aLine[ 19 ] )
   hset( hUve, "Poblacion",                     aLine[ 20 ] )
   hset( hUve, "CodigoPostal",                  aLine[ 21 ] )
   hset( hUve, "Ruta",                          aLine[ 22 ] )
   hset( hUve, "NombreRuta",                    aLine[ 23 ] )
   hset( hUve, "CodigoComercial",               aLine[ 24 ] )
   hset( hUve, "NombreComercial",               aLine[ 25 ] )
   hset( hUve, "Peso",                          val( aLine[ 26 ] ) )
   hset( hUve, "UMPeso",                        aLine[ 27 ] )
   hset( hUve, "TipoCliente",                   aLine[ 28 ] )
   hset( hUve, "Telefono",                      aLine[ 29 ] )
   hset( hUve, "DescripciónTipoCliente",        aLine[ 30 ] )

   aadd( ::aUVELines, hUve )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() 

   local oError
   local oBlock
   local lOpenFiles     := .t.

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::nView           := D():CreateView()

      D():FacturasClientes( ::nView )
      ( D():FacturasClientes( ::nView ) )->( ordsetfocus( "dFecFac" ) )

      D():FacturasClientesLineas( ::nView )    
      ( D():FacturasClientesLineas( ::nView ) )->( ordsetfocus( "nNumLin" ) )

      D():Clientes( ::nView )

      D():Articulos( ::nView )

      D():GrupoClientes( ::nView )

      D():Get( "ArtCodebar", ::nView )  

      D():Get( "Ruta", ::nView )

      D():Get( "Agentes", ::nView )

      D():Contadores( ::nView )

   RECOVER USING oError

      lOpenFiles        := .f.

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpenFiles )

//---------------------------------------------------------------------------//

METHOD sortUveLinesByInvoiceId()

   // asort( ::aUVELines, , , {|x,y| hget( x, "NumeroFactura" ) < hget( y, "NumeroFactura" ) } ) // + hget( y, "NumeroLinea" )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD processUVELinesByInvoiceId()

   local hUVELine

   for each hUVELine in ::aUVELines 

      if ::isInvoiceChange( hUVELine )

         ::getNewInvoiceNumber( hUVELine )

         ::deleteInvoiceByReference( hUVELine )

         ::getDataVendedor( hUVELine )
   
         ::deleteInvoiceIfExist()

         if !( ::isClient( hUVELine ) )
            ::createClient( hUVELine )
         end if 

         ::insertInvoiceHeader( hUVELine )

      end if

      if !( ::isProduct( hUVELine ) )
         ::createProduct( hUVELine )
      end if 

      if !( ::isGrupoCliente( hUVELine ) )
         ::createGrupoCliente( hUVELine )
      end if 

      if !( ::isRuta( hUVELine ) )
         ::createRuta( hUVELine )
      end if 

      if !( ::isAgente( ::codigoVendedor ) )
         ::createAgente( ::codigoVendedor, ::nombreVendedor )
      end if 

      ::insertInvoiceLine( hUVELine )

   next

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD getNewInvoiceNumber( hUVELine )

   ::currentInvoice        := alltrim( hget( hUVELine, "NumeroFactura" ) )
   
   if ::cDistributor == "Vacio"
      
      ::serieInvoice       := substr( ::currentInvoice, 1, 1 )
      ::numberInvoice      := val( substr( ::currentInvoice, 2, len( ::currentInvoice ) - 3 ) )
      ::delegationInvoice  := right( ::currentInvoice, 2 )

      ::calculateInvoice   := ::currentInvoice 

   else

      ::delegationInvoice  := substr( ::cDistributor, 1, 2 )
      ::calculateInvoice   := ::currentInvoice + "." + ::delegationInvoice

      ::serieInvoice       := "A"
      ::numberInvoice      := nNewDoc( ::serieInvoice, D():FacturasClientes( ::nView ), "nFacCli", , D():Contadores( ::nView ) )
   
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD getIdClient( hUVELine )

   local idClient    := hget( hUVELine, "CodigoCliente" )
   local nPos        := at( ".", idClient )

   if nPos != 0
      idClient       := substr( idClient, 1, nPos )
   else
      idClient       := alltrim( idClient )
      idClient       += "."
   end if 

   idClient          += ::idCliente

RETURN ( idClient )

//---------------------------------------------------------------------------//

METHOD isClient( hUVELine )

RETURN ( dbSeekInOrd( ::getIdClient( hUVELine ), "Cod", D():Clientes( ::nView ) ) )

//---------------------------------------------------------------------------//

METHOD createClient( hUVELine )

   ( D():Clientes( ::nView ) )->( dbappend() )

   ( D():Clientes( ::nView ) )->Cod       := ::getIdClient( hUVELine )
   ( D():Clientes( ::nView ) )->Titulo    := hget( hUVELine, "Nombre" )
   ( D():Clientes( ::nView ) )->NbrEst    := hget( hUVELine, "Establecimiento" )
   ( D():Clientes( ::nView ) )->Nif       := hget( hUVELine, "CIF" )
   ( D():Clientes( ::nView ) )->Domicilio := hget( hUVELine, "Direccion" )
   ( D():Clientes( ::nView ) )->Poblacion := hget( hUVELine, "Poblacion" )
   ( D():Clientes( ::nView ) )->CodPostal := hget( hUVELine, "CodigoPostal" )
   ( D():Clientes( ::nView ) )->Telefono  := hget( hUVELine, "Telefono" )

   ( D():Clientes( ::nView ) )->cCodGrp   := ::getTipoCliente( hUVELine ) // rjust( hget( hUVELine, "TipoCliente" ), "0", 4 )

   ( D():Clientes( ::nView ) )->cCodRut   := hget( hUVELine, "Ruta" )

   ( D():Clientes( ::nView ) )->( dbrunlock() )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD getTipoCliente( hUVELine )

   local nScan
   local nPosition
   local hSegmentos
   local cTipoCliente      := hget( hUVELine, "TipoCliente" )

   // msgalert( cTipoCliente, "valor obtenido en ctipocliente")
   
   // msgalert( ::codigoVendedor, "codigoVendedor" )

   if empty( ::codigoVendedor )
      RETURN ( rjust( cTipoCliente, "0", 4 ) )
   end if 

   nPosition               := hscan( ::hSegmentacion, {|k| alltrim( k ) == alltrim( ::codigoVendedor ) } )

   if nPosition != 0

      hSegmentos           := hgetValueAt( ::hSegmentacion, nPosition )
      
      // msgalert( hb_valtoexp( hSegmentos ), "hSegmentos" )

      nScan                := hscan( hSegmentos, {|k| val( alltrim( k ) ) == val( alltrim( cTipoCliente ) ) } )
      if nScan != 0

         cTipoCliente      := hgetValueAt( hSegmentos, nScan )
      
      else

         msgalert( "no encuentro el tipo de cliente " + cTipoCliente )

      end if 

   else

      // msgalert( "no encuentro el vendedor" )
            
   end if 

RETURN ( rjust( cTipoCliente, "0", 4 ) )

//---------------------------------------------------------------------------//

METHOD deleteInvoiceByReference()

   if empty( ::calculateInvoice )
      RETURN ( Self )
   end if 

   if D():seekInOrd( D():FacturasClientes( ::nView ), ::calculateInvoice, "nNumPed" )
      ::deleteInvoiceIfExist( D():FacturasClientesId( ::nView ) )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD deleteInvoiceIfExist( cNumeroFactura )

   if empty( cNumeroFactura )
      cNumeroFactura    := ::serieInvoice + str( ::numberInvoice, 9 ) + ::delegationInvoice
   end if 

   while D():seekInOrd( D():FacturasClientes( ::nView ), cNumeroFactura, "nNumFac" ) .and. !( D():FacturasClientes( ::nView ) )->( eof() )
      if dbLock( D():FacturasClientes( ::nView ) )
         ( D():FacturasClientes( ::nView ) )->( dbDelete() )
         ( D():FacturasClientes( ::nView ) )->( dbUnLock() )
      else 
         msgalert( "No puedo bloquear la factura : " + cNumeroFactura )
      end if 
   end while

   while D():seekInOrd( D():FacturasClientesLineas( ::nView ), cNumeroFactura, "nNumFac" ) .and. !( D():FacturasClientesLineas( ::nView ) )->( eof() )
      if dbLock( D():FacturasClientesLineas( ::nView ) )
         ( D():FacturasClientesLineas( ::nView ) )->( dbDelete() )
         ( D():FacturasClientesLineas( ::nView ) )->( dbUnLock() )
      end if 
   end while

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD insertInvoiceHeader( hUVELine )
   
   ( D():FacturasClientes( ::nView ) )->( dbappend() )
   ( D():FacturasClientes( ::nView ) )->cSerie     := ::serieInvoice
   ( D():FacturasClientes( ::nView ) )->nNumFac    := ::numberInvoice
   ( D():FacturasClientes( ::nView ) )->cSufFac    := ::delegationInvoice

   // recerencia a la factura de UVE-------------------------------------------

   ( D():FacturasClientes( ::nView ) )->cSuFac     := ::calculateInvoice
   ( D():FacturasClientes( ::nView ) )->cNumPed    := ::calculateInvoice

   ( D():FacturasClientes( ::nView ) )->cCodAlm    := oUser():cAlmacen()
   ( D():FacturasClientes( ::nView ) )->cCodCaj    := oUser():cCaja()
   ( D():FacturasClientes( ::nView ) )->cDivFac    := cDivEmp()
   ( D():FacturasClientes( ::nView ) )->nVdvFac    := nChgDiv()
   ( D():FacturasClientes( ::nView ) )->cCodUsr    := cCurUsr()
   ( D():FacturasClientes( ::nView ) )->dFecCre    := date() 
   ( D():FacturasClientes( ::nView ) )->cTimCre    := time() 
   ( D():FacturasClientes( ::nView ) )->cCodDlg    := oUser():cDelegacion()

   if ::cDistributor == "Vacio" .or. ::cDistributor == "93 - Jujuca" 
      ( D():FacturasClientes( ::nView ) )->dFecFac := stod( hget( hUVELine, "FechaFactura" ) )
   else
      ( D():FacturasClientes( ::nView ) )->dFecFac := ctod( hget( hUVELine, "FechaFactura" ) )
   end if

   ( D():FacturasClientes( ::nView ) )->cCodCli    := ::getIdClient( hUVELine )
   ( D():FacturasClientes( ::nView ) )->cNomCli    := hget( hUVELine, "Nombre" )
   ( D():FacturasClientes( ::nView ) )->cDniCli    := hget( hUVELine, "CIF" )
   ( D():FacturasClientes( ::nView ) )->cDirCli    := hget( hUVELine, "Direccion" )
   ( D():FacturasClientes( ::nView ) )->cPobCli    := hget( hUVELine, "Poblacion" )
   ( D():FacturasClientes( ::nView ) )->cPosCli    := hget( hUVELine, "CodigoPostal" )

   ( D():FacturasClientes( ::nView ) )->cCodRut    := hget( hUVELine, "Ruta" )

   ( D():FacturasClientes( ::nView ) )->cCodAge    := ::codigoVendedor

   ( D():FacturasClientes( ::nView ) )->( dbrunlock() )
   
   ::nLineNumber        := 1

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD isProduct( hUVELine )

RETURN ( dbSeekInOrd( hget( hUVELine, "CodigoProducto" ), "Codigo", D():Articulos( ::nView ) ) )

//---------------------------------------------------------------------------//

METHOD createProduct( hUVELine )

   ( D():Articulos( ::nView ) )->( dbappend() )

   ( D():Articulos( ::nView ) )->Codigo      := hget( hUVELine, "CodigoProducto" )
   ( D():Articulos( ::nView ) )->Nombre      := hget( hUVELine, "DescripcionProducto" )
   ( D():Articulos( ::nView ) )->pVenta1     := hget( hUVELine, "PrecioBase" )
   ( D():Articulos( ::nView ) )->Familia     := "00001"
   
   ( D():Articulos( ::nView ) )->( dbrunlock() )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD insertInvoiceLine( hUVELine )

   ( D():FacturasClientesLineas( ::nView ) )->( dbappend() )

   ( D():FacturasClientesLineas( ::nView ) )->cSerie     := ::serieInvoice
   ( D():FacturasClienteslineas( ::nView ) )->nNumFac    := ::numberInvoice
   ( D():FacturasClienteslineas( ::nView ) )->cSufFac    := ::delegationInvoice

   ( D():FacturasClientesLineas( ::nView ) )->cAlmLin    := oUser():cAlmacen()

   ( D():FacturasClienteslineas( ::nView ) )->nNumLin    := ::nLineNumber
   ( D():FacturasClienteslineas( ::nView ) )->nPosPrint  := ::nLineNumber

   ( D():FacturasClienteslineas( ::nView ) )->cRef       := hget( hUVELine, "CodigoProducto" )
   ( D():FacturasClienteslineas( ::nView ) )->cDetalle   := hget( hUVELine, "DescripcionProducto" )
   ( D():FacturasClienteslineas( ::nView ) )->nUniCaja   := hget( hUVELine, "Cantidad" )
   ( D():FacturasClienteslineas( ::nView ) )->nPreUnit   := hget( hUVELine, "PrecioBase" )
   ( D():FacturasClienteslineas( ::nView ) )->nDtoDiv    := hget( hUVELine, "Descuentos" )
   ( D():FacturasClienteslineas( ::nView ) )->nIva       := 10
   ( D():FacturasClienteslineas( ::nView ) )->nPesoKg    := hget( hUVELine, "Peso" )
   ( D():FacturasClienteslineas( ::nView ) )->cPesoKg    := hget( hUVELine, "UMPeso" )

   ( D():FacturasClientesLineas( ::nView ) )->( dbrunlock() )

   ::nLineNumber++
   
RETURN ( self )

//---------------------------------------------------------------------------//

METHOD isGrupoCliente( hUVELine )

RETURN ( dbSeekInOrd( rjust( hget( hUVELine, "TipoCliente" ), "0", 4 ), "cCodGrp", D():GrupoClientes( ::nView ) ) )

//---------------------------------------------------------------------------//

METHOD createGrupoCliente( hUVELine )

   ( D():GrupoClientes( ::nView ) )->( dbappend() )

   ( D():GrupoClientes( ::nView ) )->cCodGrp    := rjust( hget( hUVELine, "TipoCliente" ), "0", 4 )
   ( D():GrupoClientes( ::nView ) )->cNomGrp    := hget( hUVELine, "DescripciónTipoCliente" )

   ( D():GrupoClientes( ::nView ) )->( dbrunlock() )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD isRuta( hUVELine )

RETURN ( dbSeekInOrd( hget( hUVELine, "Ruta" ), "cCodRut", D():Get( "Ruta", ::nView ) ) )

//---------------------------------------------------------------------------//

METHOD createRuta( hUVELine )

   ( D():Get( "Ruta", ::nView ) )->( dbappend() )

   ( D():Get( "Ruta", ::nView ) )->cCodRut    := hget( hUVELine, "Ruta" )
   ( D():Get( "Ruta", ::nView ) )->cDesRut    := hget( hUVELine, "NombreRuta" )

   ( D():Get( "Ruta", ::nView ) )->( dbrunlock() )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD isAgente( codigoVendedor )

RETURN ( dbSeekInOrd( codigoVendedor, "cCodAge", D():Get( "Agentes", ::nView ) ) )

//---------------------------------------------------------------------------//

METHOD createAgente( codigoVendedor, nombreVendedor )

   ( D():Get( "Agentes", ::nView ) )->( dbappend() )

   ( D():Get( "Agentes", ::nView ) )->cCodAge    := codigoVendedor
   ( D():Get( "Agentes", ::nView ) )->cApeAge    := nombreVendedor

   ( D():Get( "Agentes", ::nView ) )->( dbrunlock() )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD isInvoiceChange( hUVELine )

RETURN ( hget( hUVELine, "NumeroFactura" ) != ::currentInvoice )

//---------------------------------------------------------------------------//

METHOD getDataVendedor( hUVELine ) CLASS ImportacionUVERisi

   local hVendedor
   local cVendedor         := alltrim( hget( hUVELine, "CodigoComercial" ) )
   local cDelegacion       := alltrim( ::delegationInvoice )

   // msgalert( alltrim( hget( hUVELine, "CodigoComercial" ) ), "getDataVendedor" )
   // msgalert( len( alltrim( hget( hUVELine, "CodigoComercial" ) ) ), "len getDataVendedor" )

   for each hVendedor in ::hVendedores

      // msgalert( hb_valtoexp( hUVELine ), "getDataVendedor" )
      // msgalert( alltrim( hget( hVendedor, "Vendedor" ) ), "len hget : " + str( len( alltrim( hget( hVendedor, "Vendedor" ) ) ) ) )
      // msgalert( cVendedor, "len : " + str( len( cVendedor ) ) )
      // msgalert( ( alltrim( hget( hVendedor, "Vendedor" ) ) == cVendedor ), "comparacion" )

      if ( alltrim( hget( hVendedor, "Delegacion" ) ) == cDelegacion ) .and. ( alltrim( hget( hVendedor, "Vendedor" ) ) == cVendedor )

         ::codigoVendedor  := hget( hVendedor, "CodigoVendedor" )
         ::nombreVendedor  := hget( hVendedor, "NombreVendedor" )
         ::idCliente       := hget( hVendedor, "IdCliente" )

         RETURN ( .t. )

      end if 

   next 

   msgStop( "Combinacion de delegación : " + cDelegacion + " y vendedor : " + cVendedor + " no encontradas." )
   
   msgalert( hb_valtoexp( hUVELine ), "getDataVendedor" )

RETURN ( .f. )

//---------------------------------------------------------------------------//

