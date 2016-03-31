#include "FiveWin.Ch"
#include "Report.ch"
#include "Xbrowse.ch"
#include "MesDbf.ch"
#include "Factu.ch" 
#include "FastRepH.ch"


//---------------------------------------------------------------------------//
    
CLASS TPrestaShopId FROM TMant

   DATA lOpenFiles         INIT .f.      

   METHOD New( cPath, oWndParent, oMenuItem )         CONSTRUCTOR

   METHOD DefineFiles()

   METHOD setValue( cTipoDocumento, cClave, cWeb, idWeb )
   METHOD getValue( cTipoDocumento, cClave, cWeb )
   METHOD deleteValue( cTipoDocumento, cClave, cWeb )

   METHOD setValueArticulos( cClave, cWeb, idWeb )    INLINE ::setValue( "01", cClave, cWeb, idWeb )
   METHOD getValueArticulos( cClave, cWeb )           INLINE ::getValue( "01", cClave, cWeb )

   METHOD setValueFamilias( cClave, cWeb, idWeb )     INLINE ::setValue( "02", cClave, cWeb, idWeb )
   METHOD getValueFamilias( cClave, cWeb )            INLINE ::getValue( "02", cClave, cWeb )

   METHOD setValueTax( cClave, cWeb, idWeb )          INLINE ::setValue( "03", cClave, cWeb, idWeb )
   METHOD getValueTax( cClave, cWeb )                 INLINE ::getValue( "03", cClave, cWeb )

   METHOD setValueTaxRuleGroup( cClave, cWeb, idWeb ) INLINE ::setValue( "04", cClave, cWeb, idWeb )
   METHOD getValueTaxRuleGroup( cClave, cWeb )        INLINE ::getValue( "04", cClave, cWeb )

   METHOD setValueManufacturer( cClave, cWeb, idWeb ) INLINE ::setValue( "05", cClave, cWeb, idWeb )
   METHOD getValueManufacturer( cClave, cWeb )        INLINE ::getValue( "05", cClave, cWeb )

   METHOD setValueCategory( cClave, cWeb, idWeb )     INLINE ::setValue( "06", cClave, cWeb, idWeb )
   METHOD getValueCategory( cClave, cWeb )            INLINE ::getValue( "06", cClave, cWeb )

   METHOD setValueAttributeGroup( cClave, cWeb, idWeb )     INLINE ::setValue( "07", cClave, cWeb, idWeb )
   METHOD getValueAttributeGroup( cClave, cWeb )            INLINE ::getValue( "07", cClave, cWeb )

   METHOD setValueAttribute( cClave, cWeb, idWeb )     INLINE ::setValue( "08", cClave, cWeb, idWeb )
   METHOD getValueAttribute( cClave, cWeb )            INLINE ::getValue( "08", cClave, cWeb )

   METHOD isValidParameters( cTipoDocumento, cClave, cWeb, idWeb ) 
   METHOD isSeekValues( cTipoDocumento, cClave, cWeb )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( cPath ) 

   DEFAULT cPath           := cPatEmp()

   ::cPath                 := cPath
   ::oDbf                  := nil

   ::bFirstKey             := {|| ::oDbf:cDocumento }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver ) 

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE ::oDbf FILE "PrestaId.Dbf" CLASS "PRESTAID" ALIAS "PRESTAID" PATH ( cPath ) VIA ( cDriver ) COMMENT "Prestashop id"

      FIELD NAME "cDocumento"    TYPE "C" LEN   2  DEC 0 COMMENT "Tipo documento"      OF ::oDbf
      FIELD NAME "cClave"        TYPE "C" LEN  60  DEC 0 COMMENT "Clave principal"     OF ::oDbf
      FIELD NAME "cWeb"          TYPE "C" LEN  80  DEC 0 COMMENT "Web de Prestashop"   OF ::oDbf
      FIELD NAME "idWeb"         TYPE "N" LEN  11  DEC 0 COMMENT "Id en Prestashop"    OF ::oDbf

      INDEX TO "PrestaId.Cdx" TAG "cDocumento"  ON "cDocumento"                        COMMENT "Documento"             NODELETED OF ::oDbf
      INDEX TO "PrestaId.Cdx" TAG "cClave"      ON "cDocumento + cClave"               COMMENT "Documento clave"       NODELETED OF ::oDbf
      INDEX TO "PrestaId.Cdx" TAG "cWeb"        ON "cDocumento + cClave + cWeb"        COMMENT "Documento clave web"   NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//---------------------------------------------------------------------------//

METHOD setValue( cTipoDocumento, cClave, cWeb, idWeb )

   if !::isValidParameters( cTipoDocumento, cClave, cWeb, idWeb )
      RETURN ( .f. )
   end if 

   if ::isSeekValues( cTipoDocumento, cClave, cWeb )
      ::oDbf:fieldPutByName( "idWeb", idWeb )
   else
      ::oDbf:Append()
      ::oDbf:cDocumento    := cTipoDocumento
      ::oDbf:cClave        := cClave
      ::oDbf:cWeb          := cWeb
      ::oDbf:idWeb         := idWeb
      ::oDbf:Save()
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD getValue( cTipoDocumento, cClave, cWeb )

   local idWeb    := 0

   if !::isValidParameters( cTipoDocumento, cClave, cWeb )
      RETURN ( 0 )
   end if 

   if ::isSeekValues( cTipoDocumento, cClave, cWeb )
      idWeb       := ::oDbf:idWeb
   end if 

RETURN ( idWeb )

//---------------------------------------------------------------------------//

METHOD deleteValue( cTipoDocumento, cClave, cWeb )

   if !::isValidParameters( cTipoDocumento, cClave, cWeb )
      RETURN ( .f. )
   end if 

   if ::isSeekValues( cTipoDocumento, cClave, cWeb )
      ::oDbf:Delete()
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD isValidParameters( cTipoDocumento, cClave, cWeb, idWeb )

   if empty( cTipoDocumento )
      msgStop( "El tipo de documento " + cTipoDocumento + " no existe" )
      RETURN ( .f. )
   end if 

   if empty( cClave )
      msgStop( "El campo clave no puede estar vacio" )
      RETURN ( .f. )
   end if 

   if empty( cWeb )
      msgStop( "El nombre de la tienda en prestashop no puede estar vacio" )
      RETURN ( .f. )
   end if 

   if !isNil( idWeb ) .and. empty( idWeb )
      msgStop( "El identificador de la tienda en prestashop no puede estar vacio" )
      RETURN ( .f. )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD isSeekValues( cTipoDocumento, cClave, cWeb )

   cClave               := padr( cClave, 60 )
   cWeb                 := padr( cWeb, 80 )

RETURN ( ::oDbf:seekInOrd( cTipoDocumento + cClave + cWeb, "cWeb" ) )

//---------------------------------------------------------------------------//

