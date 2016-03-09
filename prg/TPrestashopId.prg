#include "FiveWin.Ch"
#include "Report.ch"
#include "Xbrowse.ch"
#include "MesDbf.ch"
#include "Factu.ch" 
#include "FastRepH.ch"

static oCamposExtra

//---------------------------------------------------------------------------//
    
CLASS TPrestaShopId FROM TMant

   DATA lOpenFiles         INIT .f.      

   METHOD New( cPath, oWndParent, oMenuItem )   CONSTRUCTOR

   METHOD DefineFiles()

   METHOD getTipoDocumento( cTipoDocumento )    INLINE ( hGet( DOCUMENTOS_ITEMS, cTipoDocumento ) )
   
   METHOD setValue( cTipoDocumento, cClave, cWeb, idWeb )
   METHOD getValue( cTipoDocumento, cClave, cWeb )

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

      FIELD NAME "cDocumento"    TYPE "C" LEN   2  DEC 0 COMMENT "Tipo documento"         HIDE           OF ::oDbf
      FIELD NAME "cClave"        TYPE "C" LEN  20  DEC 0 COMMENT "Clave principal"        HIDE           OF ::oDbf
      FIELD NAME "cWeb"          TYPE "C" LEN  80  DEC 0 COMMENT "Web de Prestashop"      HIDE           OF ::oDbf
      FIELD NAME "idWeb"         TYPE "N" LEN  11  DEC 0 COMMENT "Id en Prestashop"       HIDE           OF ::oDbf

      INDEX TO "PrestaId.Cdx" TAG "cDocumento"          ON "cDocumento"                     COMMENT "Documento"             NODELETED OF ::oDbf
      INDEX TO "PrestaId.Cdx" TAG "cDocumentoClave"     ON "cDocumento + cClave"            COMMENT "Documento clave"       NODELETED OF ::oDbf
      INDEX TO "PrestaId.Cdx" TAG "cDocumentoClaveWeb"  ON "cDocumento + cClave + cWeb"     COMMENT "Documento clave web"   NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//---------------------------------------------------------------------------//

METHOD setValue( cTipoDocumento, cClave, cWeb, idWeb )

   local idDocumento    := ::getTipoDocumento( cTipoDocumento )

   if empty( idDocumento )
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

   if empty( idWeb )
      msgStop( "El identificador de la tienda en prestashop no puede estar vacio" )
      RETURN ( .f. )
   end if 

   cClave                  := padr( cClave, 20 )
   cWeb                    := padr( cWeb, 80 )

   ::oDbf:ordsetfocus( "cDocumentoClaveWeb" )

   if ::oDbf:seek( idDocumento + cClave + cWeb )
      ::oDbf:fieldPutByName( "idWeb", idWeb )
   else
      ::oDbf:Blank()
      ::oDbf:cDocumento    := idDocumento
      ::oDbf:cClave        := cClave
      ::oDbf:cWeb          := cWeb
      ::oDbf:idWeb         := idWeb
      ::oDbf:Save()
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD getValue( cTipoDocumento, cClave, cWeb )

   local idWeb          := 0
   local idDocumento    := ::getTipoDocumento( cTipoDocumento )

   if empty( idDocumento )
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

   cClave                  := padr( cClave, 20 )
   cWeb                    := padr( cWeb, 80 )

   ::oDbf:ordsetfocus( "cDocumentoClaveWeb" )

   if ::oDbf:seek( idDocumento + cClave + cWeb )
      idWeb                := ::oDbf:idWeb
   end if 

RETURN ( idWeb )

//---------------------------------------------------------------------------//









