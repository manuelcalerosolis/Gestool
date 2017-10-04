#include "FiveWin.Ch"

//---------------------------------------------------------------------------//

CLASS TItemGroup

   DATA Nombre

   DATA Expresion

   DATA Valor

   DATA Todos
   DATA Desde
   DATA Hasta

   DATA HelpDesde
   DATA HelpHasta

   DATA ValidDesde
   DATA ValidHasta

   DATA TextDesde
   DATA TextHasta

   DATA Imagen
   DATA bCondition
   DATA lImprimir

   DATA cPicDesde
   DATA cPicHasta

   DATA cBitmap

   DATA bValidMayorIgual
   DATA bValidMenorIgual

   METHOD ValidMayorIgual( uVal, uMayor )
   METHOD ValidMenorIgual( uVal, uMenor )

   METHOD GetDesde()       INLINE ( if( Empty( ::Desde ), "", alltrim( ::Desde ) ) )
   METHOD GetHasta()       INLINE ( if( Empty( ::Hasta ), "", alltrim( ::Hasta ) ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD ValidMayorIgual( uVal, uMayor )

   if IsBlock( ::bValidMayorIgual )
      Return ( Eval( ::bValidMayorIgual, uVal, uMayor ) )
   end if

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD ValidMenorIgual( uVal, uMenor )

   if IsBlock( ::bValidMenorIgual )
      Return ( Eval( ::bValidMenorIgual, uVal, uMenor ) )
   end if

Return ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TItemGroupArticulo FROM TItemGroup

   METHOD New( nView )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS TItemGroupArticulo

   ::Nombre       := "Artículo"
   ::Desde        := Space( 18 )
   ::Hasta        := Replicate( "Z", 18 )
   ::cPicDesde    := Replicate( "#", 18 )
   ::cPicHasta    := Replicate( "#", 18 )
   ::TextDesde    := {|| RetFld( ::Desde, D():Articulos( nView ), "Nombre", "Codigo" ) }
   ::TextHasta    := {|| RetFld( ::Hasta, D():Articulos( nView ), "Nombre", "Codigo" ) }
   ::HelpDesde    := {|oGet| BrwArticulo( oGet, , , .f. ) }
   ::HelpHasta    := {|oGet| BrwArticulo( oGet, , , .f. ) }
   ::ValidDesde   := {|oGet| cArticulo( oGet, D():Articulos( nView ) ) }
   ::ValidHasta   := {|oGet| cArticulo( oGet, D():Articulos( nView ) ) }
   ::cBitmap      := "gc_object_cube_16"

Return ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TItemGroupFamilia FROM TItemGroup

   METHOD New( nView )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS TItemGroupFamilia

   ::Nombre       := "Familia"
   ::Desde        := Space( 16 )
   ::Hasta        := Replicate( "Z", 16 )
   ::cPicDesde    := "@!"
   ::cPicHasta    := "@!"
   ::TextDesde    := {|| RetFld( ::Desde, D():Familias( nView ), "cNomFam", "cCodFam" ) }
   ::TextHasta    := {|| RetFld( ::Hasta, D():Familias( nView ), "cNomFam", "cCodFam" ) }
   ::HelpDesde    := {|oGet| BrwFamilia( oGet ) }
   ::HelpHasta    := {|oGet| BrwFamilia( oGet ) }
   ::ValidDesde   := {|oGet| cFamilia( oGet, D():Familias( nView ) ) }
   ::ValidHasta   := {|oGet| cFamilia( oGet, D():Familias( nView ) ) }
   ::cBitmap      := "gc_cubes_16"

Return ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TItemGroupTemporada FROM TItemGroup

   METHOD New( nView )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS TItemGroupTemporada

   ::Nombre       := "Temporadas"
   ::Desde        := Space( 3 )
   ::Hasta        := Replicate( "Z", 3 )
   ::cPicDesde    := "@!"
   ::cPicHasta    := "@!"
   ::TextDesde    := {|| RetFld( ::Desde, D():Temporadas( nView ), "cNombre", "Codigo" ) }
   ::TextHasta    := {|| RetFld( ::Hasta, D():Temporadas( nView ), "cNombre", "Codigo" ) }
   ::HelpDesde    := {|oGet| BrwTemporada( oGet ) }
   ::HelpHasta    := {|oGet| BrwTemporada( oGet ) }
   ::ValidDesde   := {|oGet| cTemporada( oGet, D():Temporadas( nView ) ) }
   ::ValidHasta   := {|oGet| cTemporada( oGet, D():Temporadas( nView ) ) }
   ::cBitmap      := "gc_cloud_sun_16"

Return ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TItemGroupFabricante FROM TItemGroup

   METHOD New( nView, oFabricante )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( nView, oFabricante ) CLASS TItemGroupFabricante

   ::Nombre       := "Fabricante"
   ::Desde        := Space( 3 )
   ::Hasta        := Replicate( "Z", 3 )
   ::cPicDesde    := "@!"
   ::cPicHasta    := "@!"
   ::TextDesde    := {|| oRetFld( ::Desde, oFabricante:oDbf, "cNomFab", "cCodFab" ) }
   ::TextHasta    := {|| oRetFld( ::Hasta, oFabricante:oDbf, "cNomFab", "cCodFab" ) }
   ::HelpDesde    := {|oGet| oFabricante:Buscar( oGet ) }
   ::HelpHasta    := {|oGet| oFabricante:Buscar( oGet ) }
   ::ValidDesde   := {|oGet| oFabricante:Existe( oGet, , "cNomFab", .t., .t., "0" ) }
   ::ValidHasta   := {|oGet| oFabricante:Existe( oGet, , "cNomFab", .t., .t., "0" ) }
   ::cBitmap      := "gc_bolt_16"

Return ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TItemGroupTipoArticulo FROM TItemGroup

   METHOD New( nView, oTipoArticulo )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( nView, oTipoArticulo ) CLASS TItemGroupTipoArticulo

   ::Nombre       := "Tipo artículo"
   ::Desde        := Space( 4 )
   ::Hasta        := Replicate( "Z", 4 )
   ::cPicDesde    := "@!"
   ::cPicHasta    := "@!"
   ::TextDesde    := {|| oRetFld( ::Desde, oTipoArticulo:oDbf, "cNomTip", "cCodTip" ) }
   ::TextHasta    := {|| oRetFld( ::Hasta, oTipoArticulo:oDbf, "cNomTip", "cCodTip" ) }
   ::HelpDesde    := {|oGet| oTipoArticulo:Buscar( oGet ) }
   ::HelpHasta    := {|oGet| oTipoArticulo:Buscar( oGet ) }
   ::ValidDesde   := {|oGet| oTipoArticulo:Existe( oGet, , "cNomTip", .t., .t., "0" ) }
   ::ValidHasta   := {|oGet| oTipoArticulo:Existe( oGet, , "cNomTip", .t., .t., "0" ) }
   ::cBitmap      := "gc_objects_16"

Return ( Self )

//---------------------------------------------------------------------------//

