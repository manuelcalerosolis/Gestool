#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TPrueba FROM TNewInfGen

   METHOD Create()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodGCli",    "C",  4, 0,  {|| "@!" },        "Cod. Grp.",   .f., "Código grupo cliente",   14, .f. )
   ::AddField( "cNomGCli",    "C", 30, 0,  {|| "@!" },        "Grupo Cli.",  .f., "Nombre grupo cliente",   14, .f. )
   ::AddField( "cCodRut",     "C",  4, 0,  {|| "@!" },        "Cod. ruta",   .f., "Código ruta",            14, .f. )
   ::AddField( "cNomRut",     "C", 30, 0,  {|| "@!" },        "Ruta",        .f., "Nombre ruta",            14, .f. )
   ::AddField( "cCodCli",     "C", 12, 0,  {|| "@!" },        "Cod. Cli.",   .f., "Código cliente",         14, .f. )
   ::AddField( "cNomCli",     "C", 80, 0,  {|| "@!" },        "Cliente",     .f., "Nombre cliente",         14, .f. )
   ::AddField( "cCodArt",     "C", 18, 0,  {|| "@!" },        "Código artículo",   .f., "Código artículo",        14, .f. )
   ::AddField( "cNomArt",     "C",100, 0,  {|| "@!" },        "Artículo",    .f., "Nombre artículo",        14, .f. )
   ::AddField( "cFactura",    "C", 12, 0,  {|| "@!" },        "Factura",     .f., "Número factura",         14, .f. )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TPrueba

   ::lNewInforme  := .t.
   ::cEmptyIndex  := "cFactura"

   if !::NewResource()
      return .f.
   end if

   if !::lGrupoGrupoCliente( .f. )
      return .f.
   end if

   if !::lGrupoRuta( .f. )
      return .f.
   end if

   if !::lGrupoCliente( .f. )
      return .f.
   end if

   if !::lGrupoArticulo( .f. )
      return .f.
   end if

   if !::lGrupoFacturas( .f. )
      return .f.
   end if

   ::lDefCondiciones := .f.

RETURN .t.

//---------------------------------------------------------------------------//

METHOD lGenerate() CLASS TPrueba

   msginfo( "Entro en el Generate" )

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//