#include "FiveWin.Ch"

//----------------------------------------------------------------------------//

CLASS TBandera

   CLASSDATA aResBan       AS ARRAY    INIT {}
   CLASSDATA aNomBan       AS ARRAY    INIT {}
   CLASSDATA aBmpBan       AS ARRAY    INIT {}

   DATA cName              INIT "Banderas"

   METHOD New()

   METHOD End()            VIRTUAL

   METHOD Destroy()

   METHOD hBandera( cRes )

   METHOD cBandera( cRes )

   METHOD OpenService()       INLINE   ( .t. )
   METHOD CloseService()      INLINE   ( .t. )

END CLASS

//----------------------------------------------------------------------------//

METHOD New()

   local cRes

   if Empty( ::aResBan )
      ::aResBan   := {  "BAN_ALB" ,;
                        "BAN_ALEM",;
                        "BAN_AND" ,;
                        "BAN_ANGO",;
                        "BAN_ARGE",;
                        "BAN_ARM" ,;
                        "BAN_AUST",;
                        "BAN_AUT" ,;
                        "BAN_AZB" ,;
                        "BAN_BOLI",;
                        "BAN_BOS" ,;
                        "BAN_BRAS",;
                        "BAN_BULG",;
                        "BAN_BELG",;
                        "BAN_CABO",;
                        "BAN_CANA",;
                        "BAN_CHIL",;
                        "BAN_CHIN",;
                        "BAN_CHIP",;
                        "BAN_COLO",;
                        "BAN_RICA",;
                        "BAN_CRO" ,;
                        "BAN_CUBA",;
                        "BAN_DINA",;
                        "BAN_ECUA",;
                        "BAN_SALV",;
                        "BAN_EMIR",;
                        "BAN_ESPA",;
                        "BAN_EST" ,;
                        "BAN_EURO",;
                        "BAN_FINL",;
                        "BAN_FRAN",;
                        "BAN_GEOR",;
                        "BAN_GRBR",;
                        "BAN_GREC",;
                        "BAN_GUAT",;
                        "BAN_GUIN",;
                        "BAN_HOLA",;
                        "BAN_HOND",;
                        "BAN_HUNG",;
                        "BAN_INDI",;
                        "BAN_IRLA",;
                        "BAN_ISLA",;
                        "BAN_ISRA",;
                        "BAN_ITAL",;
                        "BAN_JAPO",;
                        "BAN_LIEC",;
                        "BAN_LIT" ,;
                        "BAN_LUXE",;
                        "BAN_MALT",;
                        "BAN_MARR",;
                        "BAN_MOLD",;
                        "BAN_MONG",;
                        "BAN_MOZA",;
                        "BAN_MEJI",;
                        "BAN_MONC",;
                        "BAN_NIC" ,;
                        "BAN_NORM",;
                        "BAN_NORU",;
                        "BAN_REST",;
                        "BAN_PANA",;
                        "BAN_PARG",;
                        "BAN_PERU",;
                        "BAN_POLO",;
                        "BAN_PORT",;
                        "BAN_RPDO",;
                        "BAN_RUM" ,;
                        "BAN_RUS" ,;
                        "BAN_SMAR",;
                        "BAN_SING",;
                        "BAN_SLK" ,;
                        "BAN_SLN" ,;
                        "BAN_SUEC",;
                        "BAN_SUIZ",;
                        "BAN_SURA",;
                        "BAN_TURK",;
                        "BAN_TURQ",;
                        "BAN_USA" ,;
                        "BAN_URUG",;
                        "BAN_UZB" ,;
                        "BAN_VAT" ,;
                        "BAN_VENE",;
                        "BAN_YUG"  }
   end if

   if Empty( ::aNomBan )
      ::aNomBan   := {  "Albania"             ,;
                        "Alemania"            ,;
                        "Andorra"             ,;
                        "Angola"              ,;
                        "Argentina"           ,;
                        "Armenia"             ,;
                        "Australia"           ,;
                        "Austria"             ,;
                        "Azerbaijan"          ,;
                        "Bolivia"             ,;
                        "Bosnia-Herzegovina"  ,;
                        "Brasil"              ,;
                        "Bulgaria"            ,;
                        "Bélgica"             ,;
                        "Cabo Verde"          ,;
                        "Canadá"              ,;
                        "Chile"               ,;
                        "China"               ,;
                        "Chipre"              ,;
                        "Colombia"            ,;
                        "Costa Rica"          ,;
                        "Croacia"             ,;
                        "Cuba"                ,;
                        "Dinamarca"           ,;
                        "Ecuador"             ,;
                        "El Salvador"         ,;
                        "Emiratos Arabes"     ,;
                        "España"              ,;
                        "Estonia"             ,;
                        "Europa"              ,;
                        "Finlandia"           ,;
                        "Francia"             ,;
                        "Georgia"             ,;
                        "Gran Bretaña"        ,;
                        "Grecia"              ,;
                        "Guatemala"           ,;
                        "Guinea"              ,;
                        "Holanda"             ,;
                        "Honduras"            ,;
                        "Hungría"             ,;
                        "India"               ,;
                        "Irlanda"             ,;
                        "Islandia"            ,;
                        "Israel"              ,;
                        "Italia"              ,;
                        "Japón"               ,;
                        "Liechtenstein"       ,;
                        "Lituania"            ,;
                        "Luxemburgo"          ,;
                        "Malta"               ,;
                        "Marruecos"           ,;
                        "Moldavia"            ,;
                        "Mongolia"            ,;
                        "Mozambique"          ,;
                        "Méjico"              ,;
                        "Mónaco"              ,;
                        "Nicaragua"           ,;
                        "Normandía"           ,;
                        "Noruega"             ,;
                        "Otros"               ,;
                        "Panamá"              ,;
                        "Paragüay"            ,;
                        "Perú"                ,;
                        "Polonia"             ,;
                        "Portugal"            ,;
                        "República Dominicana",;
                        "Rumanía"             ,;
                        "Rusia"               ,;
                        "San Marino"          ,;
                        "Singapur"            ,;
                        "Slovakia"            ,;
                        "Slovenia"            ,;
                        "Suecia"              ,;
                        "Suiza"               ,;
                        "Suráfrica"           ,;
                        "Turkmenistan"        ,;
                        "Turquía"             ,;
                        "USA"                 ,;
                        "Urugüay"             ,;
                        "Uzbekistan"          ,;
                        "Vaticano"            ,;
                        "Venezuela"           ,;
                        "Yugoslavia"           }
   end if

   if Empty( ::aBmpBan )
      ::aBmpBan   := {}
      for each cRes in ::aResBan 
         aAdd( ::aBmpBan, LoadBitMap( GetResources(), cRes ) )
      next
   end if

return ( Self )

//---------------------------------------------------------------------------//

METHOD Destroy()

   local hBmp

   if !Empty( ::aBmpBan )
      for each hBmp in ::aBmpBan 
         DeleteObject( hBmp )
      next
   end if

return ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//
// Devuelve el handle de la bandera
//

Method hBandera( cRes )

   local n
   local h  := 0

   if IsChar( cRes )

      n     := aScan( ::aResBan, AllTrim( cRes ) )
      if n  != 0
         h  := ::aBmpBan[ n ]
      end if

   end if

return ( h )

//---------------------------------------------------------------------------//
//
// Devuelve el nombre de la bandera
//

Method cBandera( cRes )

   local n
   local c  := ""

   if IsChar( cRes )

      n     := aScan( ::aResBan, AllTrim( cRes ) )
      if n  != 0
         c  := ::aNomBan[ n ]
      end if

   end if

return ( c )

//---------------------------------------------------------------------------//