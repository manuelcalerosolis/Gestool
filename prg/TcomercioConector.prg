#include "FiveWin.Ch" 
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch" 

#define __tipoProducto__      1
#define __tipoCategoria__     2     

//---------------------------------------------------------------------------//

CLASS TComercioConector

   DATA  TComercio

   METHOD New( TComercio )                                  CONSTRUCTOR

   // facades------------------------------------------------------------------

   METHOD TPrestashopId()                                   INLINE ( ::TComercio:TPrestashopId )
   METHOD TPrestashopConfig()                               INLINE ( ::TComercio:TPrestashopConfig )

   METHOD isSyncronizeAll()                                 INLINE ( ::TComercio:lSyncAll )
   METHOD getLanguage()                                     INLINE ( ::TComercio:nLanguage )

   METHOD TComercioCustomer()                               INLINE ( ::TComercio:TComercioCustomer )
   METHOD TComercioBudget()                                 INLINE ( ::TComercio:TComercioBudget )
   METHOD TComercioOrder()                                  INLINE ( ::TComercio:TComercioOrder )
   METHOD TComercioProduct()                                INLINE ( ::TComercio:TComercioProduct )
   METHOD TComercioCategory()                               INLINE ( ::TComercio:TComercioCategory )

   METHOD getCurrentWebName()                               INLINE ( ::TComercio:getCurrentWebName() )

   METHOD writeText( cText )                                INLINE ( ::TComercio:writeText( cText ) )
   METHOD writeTextOk( cValue, cTable )                     INLINE ( ::TComercio:writeTextOk( cValue, cTable ) )
   METHOD writeTextError( cValue, cTable )                  INLINE ( ::TComercio:writeTextError( cValue, cTable ) )

   METHOD oStock()                                          INLINE ( ::TComercio:oStock )

   METHOD oConexionMySQLDatabase()                          INLINE ( ::TComercio:oCon )

   METHOD cPrefixtable( cTable )                            INLINE ( ::TComercio:cPrefixTable( cTable ) )

   METHOD meterTotalText( cText )                           INLINE ( ::TComercio:meterTotalText( cText ) )
   METHOD meterTotalSetTotal( nTotal )                      INLINE ( ::TComercio:meterTotalSetTotal( nTotal ) )
   METHOD meterProcesoText( cText )                         INLINE ( ::TComercio:meterProcesoText( cText ) )
   METHOD meterProcesoSetTotal( nTotal )                    INLINE ( ::TComercio:meterProcesoSetTotal( nTotal ) )

   METHOD lProductIdColumnImageShop()                       INLINE ( ::TComercio:lProductIdColumnImageShop )   
   METHOD lProductIdColumnProductAttribute()                INLINE ( ::TComercio:lProductIdColumnProductAttribute )   
   METHOD lProductIdColumnProductAttributeShop()            INLINE ( ::TComercio:lProductIdColumnProductAttributeShop )   
   METHOD lSpecificPriceIdColumnReductionTax()              INLINE ( ::TComercio:lSpecificPriceIdColumnReductionTax )   
   METHOD aTypeImagesPrestashop()                           INLINE ( ::TComercio:aTypeImagesPrestashop )   

   METHOD oProductDatabase()                                INLINE ( ::TComercio:oArt )
   METHOD oIvaDatabase()                                    INLINE ( ::TComercio:oIva )
   METHOD oManufacturerDatabase()                           INLINE ( ::TComercio:oFab )
   METHOD oCustomerDatabase()                               INLINE ( ::TComercio:oCli )
   METHOD oAddressDatabase()                                INLINE ( ::TComercio:oObras )
   METHOD oPaymentDatabase()                                INLINE ( ::TComercio:oFPago )
   METHOD oCategoryDatabase()                               INLINE ( ::TComercio:oFam )
   METHOD oPropertyDatabase()                               INLINE ( ::TComercio:oPro )
   METHOD oPropertiesLinesDatabase()                        INLINE ( ::TComercio:oTblPro )
   METHOD oPropertyProductDatabase()                        INLINE ( ::TComercio:oArtDiv )
   METHOD oImageProductDatabase()                           INLINE ( ::TComercio:oArtImg )

   METHOD oFtp()                                            INLINE ( ::TComercio:oFtp )
   METHOD cDirectoryProduct()                               INLINE ( ::TComercio:cDirectoryProduct() )
   METHOD cDirectoryCategories()                            INLINE ( ::TComercio:cDirectoryCategories() )
   METHOD getRecursiveFolderPrestashop( cCarpeta )          INLINE ( ::TComercio:getRecursiveFolderPrestashop( cCarpeta ) )

   METHOD commandExecDirect( cCommand )                     INLINE ( ::writeText( cCommand ), TMSCommand():New( ::oConexionMySQLDatabase() ):ExecDirect( cCommand ) )
   METHOD queryExecDirect( cQuery )                         INLINE ( TMSQuery():New( ::oConexionMySQLDatabase(), cQuery ) )

   METHOD truncateTable( cTable )   

END CLASS

//---------------------------------------------------------------------------//

METHOD New( TComercio ) CLASS TComercioConector

   ::TComercio          := TComercio

Return ( Self )

//---------------------------------------------------------------------------//

METHOD truncateTable( cTable ) CLASS TComercioConector

   if ::commandExecDirect( "TRUNCATE TABLE " + ::cPreFixtable( cTable ) )
      ::writeText( 'Tabla ' + ::cPreFixtable( cTable ) + ' borrada correctamente' )
   else
      ::writeText( 'Error al borrar la tabla ' + ::cPreFixtable( cTable ) ) 
   end if

Return ( Self )

//---------------------------------------------------------------------------//
