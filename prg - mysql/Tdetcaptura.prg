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

   Method CheckDefaultVir()

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

      ::oDbf:cCodigo    := cCod
      ::oDbf:Append()
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
      ::oDbf:cNombre    := "Ubicación"
      ::oDbf:lEditable  := .f.
      ::oDbf:lVisible   := .t.
      ::oDbf:nCaptura   := 2
      ::oDbf:cTitulo    := "Ubi."
      ::oDbf:lAlign     := .f.
      ::oDbf:cPicture   := Space( 60 )
      ::oDbf:nAncho     := 100
      ::oDbf:lBitmap    := .f.
      ::oDbf:Save()

      ::oDbf:Append()
      ::oDbf:cCodigo    := cCod
      ::oDbf:nNumero    := 23
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
      ::oDbf:nNumero    := 24
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

   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

Method CheckDefaultVir()

      ::oDbfVir:Append()
      ::oDbfVir:cCodigo    := Space( 3 )
      ::oDbfVir:nNumero    := 1
      ::oDbfVir:cNombre    := "Código del artículo"
      ::oDbfVir:lEditable  := .f.
      ::oDbfVir:lVisible   := .t.
      ::oDbfVir:nCaptura   := 3
      ::oDbfVir:cTitulo    := "Código"
      ::oDbfVir:lAlign     := .f.
      ::oDbfVir:cPicture   := Space( 50 )
      ::oDbfVir:nAncho     := 100
      ::oDbfVir:lBitmap    := .f.
      ::oDbfVir:Save()

      ::oDbfVir:Append()
      ::oDbfVir:cCodigo    := Space( 3 )
      ::oDbfVir:nNumero    := 2
      ::oDbfVir:cNombre    := "Unidades"
      ::oDbfVir:lEditable  := .f.
      ::oDbfVir:lVisible   := .t.
      ::oDbfVir:nCaptura   := 3
      ::oDbfVir:cTitulo    := "Und."
      ::oDbfVir:lAlign     := .t.
      ::oDbfVir:cPicture   := "cPicUnd"
      ::oDbfVir:nAncho     := 60
      ::oDbfVir:lBitmap    := .f.
      ::oDbfVir:Save()

      ::oDbfVir:Append()
      ::oDbfVir:cCodigo    := Space( 3 )
      ::oDbfVir:nNumero    := 3
      ::oDbfVir:cNombre    := "Medición 1"
      ::oDbfVir:lEditable  := .t.
      ::oDbfVir:lVisible   := .f.
      ::oDbfVir:nCaptura   := 1
      ::oDbfVir:cTitulo    := "Med. 1"
      ::oDbfVir:lAlign     := .t.
      ::oDbfVir:cPicture   := "cPicUnd"
      ::oDbfVir:nAncho     := 60
      ::oDbfVir:lBitmap    := .f.
      ::oDbfVir:Save()

      ::oDbfVir:Append()
      ::oDbfVir:cCodigo    := Space( 3 )
      ::oDbfVir:nNumero    := 4
      ::oDbfVir:cNombre    := "Medición 2"
      ::oDbfVir:lEditable  := .t.
      ::oDbfVir:lVisible   := .f.
      ::oDbfVir:nCaptura   := 1
      ::oDbfVir:cTitulo    := "Med. 2"
      ::oDbfVir:lAlign     := .t.
      ::oDbfVir:cPicture   := "cPicUnd"
      ::oDbfVir:nAncho     := 60
      ::oDbfVir:lBitmap    := .f.
      ::oDbfVir:Save()

      ::oDbfVir:Append()
      ::oDbfVir:cCodigo    := Space( 3 )
      ::oDbfVir:nNumero    := 5
      ::oDbfVir:cNombre    := "Medición 3"
      ::oDbfVir:lEditable  := .t.
      ::oDbfVir:lVisible   := .f.
      ::oDbfVir:nCaptura   := 1
      ::oDbfVir:cTitulo    := "Med. 3"
      ::oDbfVir:lAlign     := .t.
      ::oDbfVir:cPicture   := "cPicUnd"
      ::oDbfVir:nAncho     := 60
      ::oDbfVir:lBitmap    := .f.
      ::oDbfVir:Save()

      ::oDbfVir:Append()
      ::oDbfVir:cCodigo    := Space( 3 )
      ::oDbfVir:nNumero    := 6
      ::oDbfVir:cNombre    := "Propiedad 1"
      ::oDbfVir:lEditable  := .t.
      ::oDbfVir:lVisible   := .f.
      ::oDbfVir:nCaptura   := 2
      ::oDbfVir:cTitulo    := "Prop. 1"
      ::oDbfVir:lAlign     := .f.
      ::oDbfVir:cPicture   := Space( 50 )
      ::oDbfVir:nAncho     := 40
      ::oDbfVir:lBitmap    := .f.
      ::oDbfVir:Save()

      ::oDbfVir:Append()
      ::oDbfVir:cCodigo    := Space( 3 )
      ::oDbfVir:nNumero    := 7
      ::oDbfVir:cNombre    := "Propiedad 2"
      ::oDbfVir:lEditable  := .t.
      ::oDbfVir:lVisible   := .f.
      ::oDbfVir:nCaptura   := 2
      ::oDbfVir:cTitulo    := "Prop. 2"
      ::oDbfVir:lAlign     := .f.
      ::oDbfVir:cPicture   := Space( 50 )
      ::oDbfVir:nAncho     := 40
      ::oDbfVir:lBitmap    := .f.
      ::oDbfVir:Save()

      ::oDbfVir:Append()
      ::oDbfVir:cCodigo    := Space( 3 )
      ::oDbfVir:nNumero    := 8
      ::oDbfVir:cNombre    := "Nombre propiedad 1"
      ::oDbfVir:lEditable  := .t.
      ::oDbfVir:lVisible   := .f.
      ::oDbfVir:nCaptura   := 2
      ::oDbfVir:cTitulo    := "Nombre prp. 1"
      ::oDbfVir:lAlign     := .f.
      ::oDbfVir:cPicture   := Space( 50 )
      ::oDbfVir:nAncho     := 40
      ::oDbfVir:lBitmap    := .f.
      ::oDbfVir:Save()

      ::oDbfVir:Append()
      ::oDbfVir:cCodigo    := Space( 3 )
      ::oDbfVir:nNumero    := 9
      ::oDbfVir:cNombre    := "Nombre propiedad 2"
      ::oDbfVir:lEditable  := .t.
      ::oDbfVir:lVisible   := .f.
      ::oDbfVir:nCaptura   := 2
      ::oDbfVir:cTitulo    := "Nombre prp. 2"
      ::oDbfVir:lAlign     := .f.
      ::oDbfVir:cPicture   := Space( 50 )
      ::oDbfVir:nAncho     := 40
      ::oDbfVir:lBitmap    := .f.
      ::oDbfVir:Save()

      ::oDbfVir:Append()
      ::oDbfVir:cCodigo    := Space( 3 )
      ::oDbfVir:nNumero    := 10
      ::oDbfVir:cNombre    := "Lote"
      ::oDbfVir:lEditable  := .t.
      ::oDbfVir:lVisible   := .f.
      ::oDbfVir:nCaptura   := 2
      ::oDbfVir:cTitulo    := "Lote"
      ::oDbfVir:lAlign     := .t.
      ::oDbfVir:cPicture   := "@Z 999999999"
      ::oDbfVir:nAncho     := 60
      ::oDbfVir:lBitmap    := .f.
      ::oDbfVir:Save()

      ::oDbfVir:Append()
      ::oDbfVir:cCodigo    := Space( 3 )
      ::oDbfVir:nNumero    := 11
      ::oDbfVir:cNombre    := "Caducidad"
      ::oDbfVir:lEditable  := .t.
      ::oDbfVir:lVisible   := .f.
      ::oDbfVir:nCaptura   := 2
      ::oDbfVir:cTitulo    := "Caducidad"
      ::oDbfVir:lAlign     := .t.
      ::oDbfVir:cPicture   := ""
      ::oDbfVir:nAncho     := 75
      ::oDbfVir:lBitmap    := .f.
      ::oDbfVir:Save()

      ::oDbfVir:Append()
      ::oDbfVir:cCodigo    := Space( 3 )
      ::oDbfVir:nNumero    := 12
      ::oDbfVir:cNombre    := "Detalle"
      ::oDbfVir:lEditable  := .t.
      ::oDbfVir:lVisible   := .t.
      ::oDbfVir:nCaptura   := 2
      ::oDbfVir:cTitulo    := "Detalle"
      ::oDbfVir:lAlign     := .f.
      ::oDbfVir:cPicture   := Space( 50 )
      ::oDbfVir:nAncho     := 200
      ::oDbfVir:lBitmap    := .f.
      ::oDbfVir:Save()

      ::oDbfVir:Append()
      ::oDbfVir:cCodigo    := Space( 3 )
      ::oDbfVir:nNumero    := 13
      ::oDbfVir:cNombre    := "Importe"
      ::oDbfVir:lEditable  := .t.
      ::oDbfVir:lVisible   := .t.
      ::oDbfVir:nCaptura   := 2
      ::oDbfVir:cTitulo    := "Importe"
      ::oDbfVir:lAlign     := .t.
      ::oDbfVir:cPicture   := "cPouDiv"
      ::oDbfVir:nAncho     := 80
      ::oDbfVir:lBitmap    := .f.
      ::oDbfVir:Save()

      ::oDbfVir:Append()
      ::oDbfVir:cCodigo    := Space( 3 )
      ::oDbfVir:nNumero    := 14
      ::oDbfVir:cNombre    := "Descuento lineal"
      ::oDbfVir:lEditable  := .t.
      ::oDbfVir:lVisible   := .t.
      ::oDbfVir:nCaptura   := 2
      ::oDbfVir:cTitulo    := "Dto. lin."
      ::oDbfVir:lAlign     := .t.
      ::oDbfVir:cPicture   := "cPouDiv"
      ::oDbfVir:nAncho     := 80
      ::oDbfVir:lBitmap    := .f.
      ::oDbfVir:Save()

      ::oDbfVir:Append()
      ::oDbfVir:cCodigo    := Space( 3 )
      ::oDbfVir:nNumero    := 15
      ::oDbfVir:cNombre    := "Descuento porcentual"
      ::oDbfVir:lEditable  := .t.
      ::oDbfVir:lVisible   := .t.
      ::oDbfVir:nCaptura   := 2
      ::oDbfVir:cTitulo    := "%Dto."
      ::oDbfVir:lAlign     := .t.
      ::oDbfVir:cPicture   := '"@E 99.99"'
      ::oDbfVir:nAncho     := 40
      ::oDbfVir:lBitmap    := .f.
      ::oDbfVir:Save()

      ::oDbfVir:Append()
      ::oDbfVir:cCodigo    := Space( 3 )
      ::oDbfVir:nNumero    := 16
      ::oDbfVir:cNombre    := "Total"
      ::oDbfVir:lEditable  := .f.
      ::oDbfVir:lVisible   := .t.
      ::oDbfVir:nCaptura   := 2
      ::oDbfVir:cTitulo    := "Total"
      ::oDbfVir:lAlign     := .t.
      ::oDbfVir:cPicture   := 'cPorDiv'
      ::oDbfVir:nAncho     := 80
      ::oDbfVir:lBitmap    := .f.
      ::oDbfVir:Save()

      ::oDbfVir:Append()
      ::oDbfVir:cCodigo    := Space( 3 )
      ::oDbfVir:nNumero    := 17
      ::oDbfVir:cNombre    := "Número de serie"
      ::oDbfVir:lEditable  := .t.
      ::oDbfVir:lVisible   := .f.
      ::oDbfVir:nCaptura   := 2
      ::oDbfVir:cTitulo    := "Nº Serie"
      ::oDbfVir:lAlign     := .f.
      ::oDbfVir:cPicture   := Space( 50 )
      ::oDbfVir:nAncho     := 56
      ::oDbfVir:lBitmap    := .f.
      ::oDbfVir:Save()

      ::oDbfVir:Append()
      ::oDbfVir:cCodigo    := Space( 3 )
      ::oDbfVir:nNumero    := 18
      ::oDbfVir:cNombre    := "Número de línea"
      ::oDbfVir:lEditable  := .t.
      ::oDbfVir:lVisible   := .f.
      ::oDbfVir:nCaptura   := 2
      ::oDbfVir:cTitulo    := "Nº Línea"
      ::oDbfVir:lAlign     := .t.
      ::oDbfVir:cPicture   := "9999"
      ::oDbfVir:nAncho     := 40
      ::oDbfVir:lBitmap    := .f.
      ::oDbfVir:Save()

      ::oDbfVir:Append()
      ::oDbfVir:cCodigo    := Space( 3 )
      ::oDbfVir:nNumero    := 19
      ::oDbfVir:cNombre    := "Código de barras"
      ::oDbfVir:lEditable  := .t.
      ::oDbfVir:lVisible   := .t.
      ::oDbfVir:nCaptura   := 2
      ::oDbfVir:cTitulo    := "C. barras"
      ::oDbfVir:lAlign     := .f.
      ::oDbfVir:cPicture   := Space( 50 )
      ::oDbfVir:nAncho     := 100
      ::oDbfVir:lBitmap    := .f.
      ::oDbfVir:Save()

      ::oDbfVir:Append()
      ::oDbfVir:cCodigo    := Space( 3 )
      ::oDbfVir:nNumero    := 20
      ::oDbfVir:cNombre    := "Promoción"
      ::oDbfVir:lEditable  := .t.
      ::oDbfVir:lVisible   := .f.
      ::oDbfVir:nCaptura   := 2
      ::oDbfVir:cTitulo    := "Prm."
      ::oDbfVir:lAlign     := .f.
      ::oDbfVir:cPicture   := Space( 50 )
      ::oDbfVir:nAncho     := 20
      ::oDbfVir:lBitmap    := .t.
      ::oDbfVir:Save()

      ::oDbfVir:Append()
      ::oDbfVir:cCodigo    := Space( 3 )
      ::oDbfVir:nNumero    := 21
      ::oDbfVir:cNombre    := "Oferta"
      ::oDbfVir:lEditable  := .t.
      ::oDbfVir:lVisible   := .f.
      ::oDbfVir:nCaptura   := 2
      ::oDbfVir:cTitulo    := "Ofe."
      ::oDbfVir:lAlign     := .f.
      ::oDbfVir:cPicture   := Space( 50 )
      ::oDbfVir:nAncho     := 20
      ::oDbfVir:lBitmap    := .t.
      ::oDbfVir:Save()

      ::oDbfVir:Append()
      ::oDbfVir:cCodigo    := Space( 3 )
      ::oDbfVir:nNumero    := 22
      ::oDbfVir:cNombre    := "Ubicación"
      ::oDbfVir:lEditable  := .f.
      ::oDbfVir:lVisible   := .t.
      ::oDbfVir:nCaptura   := 2
      ::oDbfVir:cTitulo    := "Ubi."
      ::oDbfVir:lAlign     := .f.
      ::oDbfVir:cPicture   := Space( 60 )
      ::oDbfVir:nAncho     := 100
      ::oDbfVir:lBitmap    := .f.
      ::oDbfVir:Save()

      ::oDbfVir:Append()
      ::oDbfVir:cCodigo    := Space( 3 )
      ::oDbfVir:nNumero    := 23
      ::oDbfVir:cNombre    := "Factor"
      ::oDbfVir:lEditable  := .t.
      ::oDbfVir:lVisible   := .f.
      ::oDbfVir:nCaptura   := 3
      ::oDbfVir:cTitulo    := "Factor"
      ::oDbfVir:lAlign     := .t.
      ::oDbfVir:cPicture   := "@E 999,999.999999"
      ::oDbfVir:nAncho     := 60
      ::oDbfVir:lBitmap    := .f.
      ::oDbfVir:Save()

      ::oDbfVir:Append()
      ::oDbfVir:cCodigo    := Space( 3 )
      ::oDbfVir:nNumero    := 24
      ::oDbfVir:cNombre    := "Porcentaje I.V.A."
      ::oDbfVir:lEditable  := .t.
      ::oDbfVir:lVisible   := .t.
      ::oDbfVir:nCaptura   := 2
      ::oDbfVir:cTitulo    := "%IVA"
      ::oDbfVir:lAlign     := .t.
      ::oDbfVir:cPicture   := '"@E 99.99"'
      ::oDbfVir:nAncho     := 40
      ::oDbfVir:lBitmap    := .f.
      ::oDbfVir:Save()

RETURN ( .t. )

//---------------------------------------------------------------------------//