#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Menu.ch"
#include "Report.ch"
#include "MesDbf.ch"

#define  DEFAULT_CODE      "000"

//--------------------------------------------------------------------------//

CLASS TDetCaptura FROM TDet

   Method DefineFiles()

   Method OpenFiles( lExclusive )

   METHOD OpenService( lExclusive )

   Method CheckDefault()

   Method SaveLines()

END CLASS

//--------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cVia ) CLASS TDetCaptura

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT cVia         := cDriver()

   DEFINE TABLE oDbf FILE "CapturaCampos.Dbf" CLASS "TCapCam" ALIAS "CapCam" PATH ( cPath ) VIA ( cVia )

      FIELD NAME "cCodigo"    TYPE "C" LEN  3  DEC 0 COMMENT "Código"                  OF oDbf
      FIELD NAME "nNumero"    TYPE "N" LEN  2  DEC 0 COMMENT "Número"                  OF oDbf
      FIELD NAME "cNombre"    TYPE "C" LEN 50  DEC 0 COMMENT "Nombre"                  OF oDbf
      FIELD NAME "lEditable"  TYPE "L" LEN  1  DEC 0 COMMENT "Editable"                OF oDbf
      FIELD NAME "lVisible"   TYPE "L" LEN  1  DEC 0 COMMENT "Visble"                  OF oDbf
      FIELD NAME "nCaptura"   TYPE "N" LEN  1  DEC 0 COMMENT "Captura"                 OF oDbf
      FIELD NAME "cTitulo"    TYPE "C" LEN 50  DEC 0 COMMENT "Título"                  OF oDbf
      FIELD NAME "lAlign"     TYPE "L" LEN  1  DEC 0 COMMENT "Align"                   OF oDbf
      FIELD NAME "cPicture"   TYPE "C" LEN 50  DEC 0 COMMENT "Picture"                 OF oDbf
      FIELD NAME "nAncho"     TYPE "N" LEN  3  DEC 0 COMMENT "Ancho"                   OF oDbf
      FIELD NAME "lBitmap"    TYPE "L" LEN  1  DEC 0 COMMENT "Recurso"                 OF oDbf

      INDEX TO "CapturaCampos.Cdx" TAG "cCodigo" ON "cCodigo" COMMENT "Código" NODELETED     OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//--------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath ) CLASS TDetCaptura

   DEFAULT lExclusive   := .f.
   DEFAULT cPath        := ::cPath

   if Empty( ::oDbf )
      ::oDbf            := ::DefineFiles( cPath )
   end if

   ::oDbf:Activate( .f., !lExclusive )

   ::CheckDefault( DEFAULT_CODE, .f. )

   ::bOnPreSaveDetail   := {|| ::SaveLines() }
   ::bOnPreSaveDetail   := {|| ::SaveLines() }

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD OpenService( lExclusive, cPath )

   local lOpen          := .t.
   local oBlock         

   DEFAULT lExclusive   := .f.
   DEFAULT cPath        := ::cPath

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf         := ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER

      lOpen             := .f.

      ::CloseService()

      msgStop( "Imposible abrir todas las bases de datos de detalle de capturas" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD SaveLines() CLASS TDetCaptura

   ::oDbfVir:cCodigo    := ::oParent:oDbf:cCodigo

RETURN ( Self )

//---------------------------------------------------------------------------//

Method CheckDefault( cCod, lNew )

   DEFAULT cCod         := DEFAULT_CODE
   DEFAULT lNew         := .f.

   if lNew
      while ::oDbf:Seek( cCod ) .and. !::oDbf:Eof()
         ::oDbf:Delete( .f. )
      end
   end if

   if empty( cCod ) .or. !( ::oDbf:Seek( cCod ) )

      ::oDbf:Append()
      ::oDbf:cCodigo    := cCod
      ::oDbf:nNumero    := 1
      ::oDbf:cNombre    := "Código del artículo"
      ::oDbf:lEditable  := .f.
      ::oDbf:lVisible   := .t.
      ::oDbf:nCaptura   := 3
      ::oDbf:cTitulo    := "Código"
      ::oDbf:lAlign     := .f.
      ::oDbf:cPicture   := Space( 50 )
      ::oDbf:nAncho     := 100
      ::oDbf:lBitmap    := .f.
      ::oDbf:Save()

      ::oDbf:Append()
      ::oDbf:cCodigo    := cCod
      ::oDbf:nNumero    := 2
      ::oDbf:cNombre    := "Unidades"
      ::oDbf:lEditable  := .f.
      ::oDbf:lVisible   := .t.
      ::oDbf:nCaptura   := 3
      ::oDbf:cTitulo    := "Und."
      ::oDbf:lAlign     := .t.
      ::oDbf:cPicture   := "cPicUnd"
      ::oDbf:nAncho     := 60
      ::oDbf:lBitmap    := .f.
      ::oDbf:Save()

      ::oDbf:Append()
      ::oDbf:cCodigo    := cCod
      ::oDbf:nNumero    := 3
      ::oDbf:cNombre    := "Medición 1"
      ::oDbf:lEditable  := .t.
      ::oDbf:lVisible   := .f.
      ::oDbf:nCaptura   := 1
      ::oDbf:cTitulo    := "Med. 1"
      ::oDbf:lAlign     := .t.
      ::oDbf:cPicture   := "cPicUnd"
      ::oDbf:nAncho     := 60
      ::oDbf:lBitmap    := .f.
      ::oDbf:Save()

      ::oDbf:Append()
      ::oDbf:cCodigo    := cCod
      ::oDbf:nNumero    := 4
      ::oDbf:cNombre    := "Medición 2"
      ::oDbf:lEditable  := .t.
      ::oDbf:lVisible   := .f.
      ::oDbf:nCaptura   := 1
      ::oDbf:cTitulo    := "Med. 2"
      ::oDbf:lAlign     := .t.
      ::oDbf:cPicture   := "cPicUnd"
      ::oDbf:nAncho     := 60
      ::oDbf:lBitmap    := .f.
      ::oDbf:Save()

      ::oDbf:Append()
      ::oDbf:cCodigo    := cCod
      ::oDbf:nNumero    := 5
      ::oDbf:cNombre    := "Medición 3"
      ::oDbf:lEditable  := .t.
      ::oDbf:lVisible   := .f.
      ::oDbf:nCaptura   := 1
      ::oDbf:cTitulo    := "Med. 3"
      ::oDbf:lAlign     := .t.
      ::oDbf:cPicture   := "cPicUnd"
      ::oDbf:nAncho     := 60
      ::oDbf:lBitmap    := .f.
      ::oDbf:Save()

      ::oDbf:Append()
      ::oDbf:cCodigo    := cCod
      ::oDbf:nNumero    := 6
      ::oDbf:cNombre    := "Propiedad 1"
      ::oDbf:lEditable  := .t.
      ::oDbf:lVisible   := .f.
      ::oDbf:nCaptura   := 2
      ::oDbf:cTitulo    := "Prop. 1"
      ::oDbf:lAlign     := .f.
      ::oDbf:cPicture   := Space( 50 )
      ::oDbf:nAncho     := 40
      ::oDbf:lBitmap    := .f.
      ::oDbf:Save()

      ::oDbf:Append()
      ::oDbf:cCodigo    := cCod
      ::oDbf:nNumero    := 7
      ::oDbf:cNombre    := "Propiedad 2"
      ::oDbf:lEditable  := .t.
      ::oDbf:lVisible   := .f.
      ::oDbf:nCaptura   := 2
      ::oDbf:cTitulo    := "Prop. 2"
      ::oDbf:lAlign     := .f.
      ::oDbf:cPicture   := Space( 50 )
      ::oDbf:nAncho     := 40
      ::oDbf:lBitmap    := .f.
      ::oDbf:Save()

      ::oDbf:Append()
      ::oDbf:cCodigo    := cCod
      ::oDbf:nNumero    := 8
      ::oDbf:cNombre    := "Nombre propiedad 1"
      ::oDbf:lEditable  := .t.
      ::oDbf:lVisible   := .f.
      ::oDbf:nCaptura   := 2
      ::oDbf:cTitulo    := "Nombre prp. 1"
      ::oDbf:lAlign     := .f.
      ::oDbf:cPicture   := Space( 50 )
      ::oDbf:nAncho     := 40
      ::oDbf:lBitmap    := .f.
      ::oDbf:Save()

      ::oDbf:Append()
      ::oDbf:cCodigo    := cCod
      ::oDbf:nNumero    := 9
      ::oDbf:cNombre    := "Nombre propiedad 2"
      ::oDbf:lEditable  := .t.
      ::oDbf:lVisible   := .f.
      ::oDbf:nCaptura   := 2
      ::oDbf:cTitulo    := "Nombre prp. 2"
      ::oDbf:lAlign     := .f.
      ::oDbf:cPicture   := Space( 50 )
      ::oDbf:nAncho     := 40
      ::oDbf:lBitmap    := .f.
      ::oDbf:Save()

      ::oDbf:Append()
      ::oDbf:cCodigo    := cCod
      ::oDbf:nNumero    := 10
      ::oDbf:cNombre    := "Lote"
      ::oDbf:lEditable  := .t.
      ::oDbf:lVisible   := .f.
      ::oDbf:nCaptura   := 2
      ::oDbf:cTitulo    := "Lote"
      ::oDbf:lAlign     := .t.
      ::oDbf:cPicture   := "@Z 999999999"
      ::oDbf:nAncho     := 60
      ::oDbf:lBitmap    := .f.
      ::oDbf:Save()

      ::oDbf:Append()
      ::oDbf:cCodigo    := cCod
      ::oDbf:nNumero    := 11
      ::oDbf:cNombre    := "Caducidad"
      ::oDbf:lEditable  := .t.
      ::oDbf:lVisible   := .f.
      ::oDbf:nCaptura   := 2
      ::oDbf:cTitulo    := "Caducidad"
      ::oDbf:lAlign     := .t.
      ::oDbf:cPicture   := ""
      ::oDbf:nAncho     := 75
      ::oDbf:lBitmap    := .f.
      ::oDbf:Save()

      ::oDbf:Append()
      ::oDbf:cCodigo    := cCod
      ::oDbf:nNumero    := 12
      ::oDbf:cNombre    := "Detalle"
      ::oDbf:lEditable  := .t.
      ::oDbf:lVisible   := .t.
      ::oDbf:nCaptura   := 2
      ::oDbf:cTitulo    := "Detalle"
      ::oDbf:lAlign     := .f.
      ::oDbf:cPicture   := Space( 50 )
      ::oDbf:nAncho     := 200
      ::oDbf:lBitmap    := .f.
      ::oDbf:Save()

      ::oDbf:Append()
      ::oDbf:cCodigo    := cCod
      ::oDbf:nNumero    := 13
      ::oDbf:cNombre    := "Importe"
      ::oDbf:lEditable  := .t.
      ::oDbf:lVisible   := .t.
      ::oDbf:nCaptura   := 2
      ::oDbf:cTitulo    := "Importe"
      ::oDbf:lAlign     := .t.
      ::oDbf:cPicture   := "cPouDiv"
      ::oDbf:nAncho     := 80
      ::oDbf:lBitmap    := .f.
      ::oDbf:Save()

      ::oDbf:Append()
      ::oDbf:cCodigo    := cCod
      ::oDbf:nNumero    := 14
      ::oDbf:cNombre    := "Descuento lineal"
      ::oDbf:lEditable  := .t.
      ::oDbf:lVisible   := .t.
      ::oDbf:nCaptura   := 2
      ::oDbf:cTitulo    := "Dto. lin."
      ::oDbf:lAlign     := .t.
      ::oDbf:cPicture   := "cPouDiv"
      ::oDbf:nAncho     := 80
      ::oDbf:lBitmap    := .f.
      ::oDbf:Save()

      ::oDbf:Append()
      ::oDbf:cCodigo    := cCod
      ::oDbf:nNumero    := 15
      ::oDbf:cNombre    := "Descuento porcentual"
      ::oDbf:lEditable  := .t.
      ::oDbf:lVisible   := .t.
      ::oDbf:nCaptura   := 2
      ::oDbf:cTitulo    := "%Dto."
      ::oDbf:lAlign     := .t.
      ::oDbf:cPicture   := '"@E 99.99"'
      ::oDbf:nAncho     := 40
      ::oDbf:lBitmap    := .f.
      ::oDbf:Save()

      ::oDbf:Append()
      ::oDbf:cCodigo    := cCod
      ::oDbf:nNumero    := 16
      ::oDbf:cNombre    := "Total"
      ::oDbf:lEditable  := .f.
      ::oDbf:lVisible   := .t.
      ::oDbf:nCaptura   := 2
      ::oDbf:cTitulo    := "Total"
      ::oDbf:lAlign     := .t.
      ::oDbf:cPicture   := 'cPorDiv'
      ::oDbf:nAncho     := 80
      ::oDbf:lBitmap    := .f.
      ::oDbf:Save()

      ::oDbf:Append()
      ::oDbf:cCodigo    := cCod
      ::oDbf:nNumero    := 17
      ::oDbf:cNombre    := "Número de serie"
      ::oDbf:lEditable  := .t.
      ::oDbf:lVisible   := .f.
      ::oDbf:nCaptura   := 2
      ::oDbf:cTitulo    := "Nº Serie"
      ::oDbf:lAlign     := .f.
      ::oDbf:cPicture   := Space( 50 )
      ::oDbf:nAncho     := 56
      ::oDbf:lBitmap    := .f.
      ::oDbf:Save()

      ::oDbf:Append()
      ::oDbf:cCodigo    := cCod
      ::oDbf:nNumero    := 18
      ::oDbf:cNombre    := "Número de línea"
      ::oDbf:lEditable  := .t.
      ::oDbf:lVisible   := .f.
      ::oDbf:nCaptura   := 2
      ::oDbf:cTitulo    := "Nº Línea"
      ::oDbf:lAlign     := .t.
      ::oDbf:cPicture   := "9999"
      ::oDbf:nAncho     := 40
      ::oDbf:lBitmap    := .f.
      ::oDbf:Save()

      ::oDbf:Append()
      ::oDbf:cCodigo    := cCod
      ::oDbf:nNumero    := 19
      ::oDbf:cNombre    := "Código de barras"
      ::oDbf:lEditable  := .t.
      ::oDbf:lVisible   := .t.
      ::oDbf:nCaptura   := 2
      ::oDbf:cTitulo    := "C. barras"
      ::oDbf:lAlign     := .f.
      ::oDbf:cPicture   := Space( 50 )
      ::oDbf:nAncho     := 100
      ::oDbf:lBitmap    := .f.
      ::oDbf:Save()

      ::oDbf:Append()
      ::oDbf:cCodigo    := cCod
      ::oDbf:nNumero    := 20
      ::oDbf:cNombre    := "Promoción"
      ::oDbf:lEditable  := .t.
      ::oDbf:lVisible   := .f.
      ::oDbf:nCaptura   := 2
      ::oDbf:cTitulo    := "Prm."
      ::oDbf:lAlign     := .f.
      ::oDbf:cPicture   := Space( 50 )
      ::oDbf:nAncho     := 20
      ::oDbf:lBitmap    := .t.
      ::oDbf:Save()

      ::oDbf:Append()
      ::oDbf:cCodigo    := cCod
      ::oDbf:nNumero    := 21
      ::oDbf:cNombre    := "Oferta"
      ::oDbf:lEditable  := .t.
      ::oDbf:lVisible   := .f.
      ::oDbf:nCaptura   := 2
      ::oDbf:cTitulo    := "Ofe."
      ::oDbf:lAlign     := .f.
      ::oDbf:cPicture   := Space( 50 )
      ::oDbf:nAncho     := 20
      ::oDbf:lBitmap    := .t.
      ::oDbf:Save()

      ::oDbf:Append()
      ::oDbf:cCodigo    := cCod
      ::oDbf:nNumero    := 22
      ::oDbf:cNombre    := "Factor"
      ::oDbf:lEditable  := .t.
      ::oDbf:lVisible   := .f.
      ::oDbf:nCaptura   := 3
      ::oDbf:cTitulo    := "Factor"
      ::oDbf:lAlign     := .t.
      ::oDbf:cPicture   := "@E 999,999.999999"
      ::oDbf:nAncho     := 60
      ::oDbf:lBitmap    := .f.
      ::oDbf:Save()

      ::oDbf:Append()
      ::oDbf:cCodigo    := cCod
      ::oDbf:nNumero    := 23
      ::oDbf:cNombre    := "Porcentaje I.V.A."
      ::oDbf:lEditable  := .t.
      ::oDbf:lVisible   := .t.
      ::oDbf:nCaptura   := 2
      ::oDbf:cTitulo    := "%IVA"
      ::oDbf:lAlign     := .t.
      ::oDbf:cPicture   := '"@E 99.99"'
      ::oDbf:nAncho     := 40
      ::oDbf:lBitmap    := .f.
      ::oDbf:Save()

      ::oDbf:Append()
      ::oDbf:cCodigo    := cCod
      ::oDbf:nNumero    := 24
      ::oDbf:cNombre    := "Ubicacion"
      ::oDbf:lEditable  := .f.
      ::oDbf:lVisible   := .t.
      ::oDbf:nCaptura   := 2
      ::oDbf:cTitulo    := "Ubi."
      ::oDbf:lAlign     := .f.
      ::oDbf:cPicture   := Space( 60 )
      ::oDbf:nAncho     := 100
      ::oDbf:lBitmap    := .f.
      ::oDbf:Save()

   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//
