#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TListadoTemporadas FROM TInfGen

   DATA dbfCategoria

   METHOD Create()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create( dbf )

   ::AddField( "cCodigo",    "C",   3, 0, {|| "" },    "Código",   .t., "Código de categoría",   10, .f. )
   ::AddField( "cNombre",    "C",  50, 0, {|| "" },    "Nombre",   .t., "Nombre de categoría",   40, .f. )
   ::AddField( "cTipo",      "C",  30, 0, {|| "" },    "Tipo",     .t., "Tipo de categoría",     30, .f. )

   ::lDefFecInf   := .f.
   ::lDefSerInf   := .f.
   ::lDefDivInf   := .f.

   ::dbfCategoria := dbf

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INF_CATEGORIA" )
      return .f.
   end if

   ::oBtnFilter:Disable()

   ::lIntCatInf( 110, 120, 130, 140, 150, ::dbfCategoria )

   ::oMtrInf:SetTotal( ( ::dbfCategoria )->( Lastrec() ) )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD lGenerate()

   ::oDlg:Disable()
   ::oBtnCancel:Enable()

   ::oDbf:Zap()

   ::aHeader         := {  {|| "Fecha      : " + Dtoc( Date() ) },;
                           {|| getConfigTraslation( "Temporadas" ) + " : " + if( ::lAllCat, "Todos", AllTrim( ::cCatOrg ) + " > " + AllTrim( ::cCatDes ) ) } }

   ( ::dbfCategoria )->( OrdSetFocus( "Codigo" ) )

   ::oMtrInf:SetTotal( ( ::dbfCategoria )->( OrdKeyCount() ) )

   ( ::dbfCategoria )->( dbGoTop() )

   while !::lBreak .and. !( ::dbfCategoria )->( Eof() )

      if ::lAllCat .or. ( ( ::dbfCategoria )->cCodigo >= Rtrim( ::cCatOrg ) .and. ( ::dbfCategoria )->cCodigo <= Rtrim( ::cCatDes ) )

         ::oDbf:Append()

         ::oDbf:cCodigo := ( ::dbfCategoria )->cCodigo
         ::oDbf:cNombre := ( ::dbfCategoria )->cNombre
         ::oDbf:cTipo   := ( ::dbfCategoria )->cTipo

         ::oDbf:Save()

      end if

      ( ::dbfCategoria )->( dbSkip() )

      ::oMtrInf:AutoInc( ( ::dbfCategoria )->( OrdKeyNo() ) )

   end while

   ::oMtrInf:AutoInc( ( ::dbfCategoria )->( LastRec() ) )

   ::oDlg:Enable()

   ::oBtnFilter:Disable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//