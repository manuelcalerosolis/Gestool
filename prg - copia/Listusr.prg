#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS ListUsr FROM TInfGen

   METHOD Create()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodUse",   "C",  3, 0, {|| "" },     "Cod.",              .t., "Código de usuario",              10, .f. )
   ::AddField( "cNbrUse",   "C", 30, 0, {|| "" },     "Usuario",           .t., "Nombre de usuario",              40, .f. )
   ::AddField( "cEmpUse",   "C",  4, 0, {|| "" },     "Empresa",           .f., "Empresa por defecto",             5, .f. )
   ::AddField( "cCajUse",   "C",  3, 0, {|| "" },     "Caja",              .f., "Caja por defecto",                5, .f. )
   ::AddField( "cAlmUse",   "C", 16, 0, {|| "" },     "Almacén",           .f., "Almacén por defecto",             5, .f. )
   ::AddField( "cFpgUse",   "C",  3, 0, {|| "" },     "F. Pago",           .f., "Forma de pago por defecto",       5, .f. )

   ::AddTmpIndex ( "cCodUse", "cCodUse" )

   ::lDefFecInf   := .f.
   ::lDefSerInf   := .f.
   ::lDefDivInf   := .f.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INF_USR01" )
      return .f.
   end if

   ::oDefUsrInf( 70, 80, 90, 100, 60 )

   ::oMtrInf:SetTotal( ::oDbfUsr:Lastrec() )

   ::CreateFilter( aItmUsuario(), ::oDbfUsr:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                        {|| "Usuarios : " + if( ::lAllUsr, "Todos", AllTrim( ::cUsrOrg ) + " > " + AllTrim( ::cUsrDes ) ) } }

   ::oDbfUsr:OrdSetFocus( "CCODUSE" )

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       := ::oFilter:cExpresionFilter
   else
      cExpHead       := '.t.'
   end if

   ::oDbfUsr:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oDbfUsr:cFile ), ::oDbfUsr:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oDbfUsr:GoTop()

   while !::oDbfUsr:Eof()

      if ( ::lAllUsr .or. ( ::oDbfUsr:cCodUse >= ::cUsrOrg .AND. ::oDbfUsr:cCodUse <= ::cUsrDes ) )

         ::oDbf:Append()

         ::oDbf:cCodUse  := ::oDbfUsr:cCodUse
         ::oDbf:cNbrUse  := ::oDbfUsr:cNbrUse
         ::oDbf:cEmpUse  := ::oDbfUsr:cEmpUse
         ::oDbf:cCajUse  := ::oDbfUsr:cCajUse
         ::oDbf:cAlmUse  := ::oDbfUsr:cAlmUse
         ::oDbf:cFpgUse  := ::oDbfUsr:cFpgUse

         ::oDbf:Save()

      end if

      ::oDbfUsr:Skip()

      ::oMtrInf:AutoInc( ::oDbfUsr:OrdKeyNo() )

   end while

   ::oDbfUsr:IdxDelete( cCurUsr(), GetFileNoExt( ::oDbfUsr:cFile ) )

   ::oMtrInf:AutoInc( ::oDbfUsr:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//