#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"
//---------------------------------------------------------------------------//

CLASS TLisRutInf FROM TInfGen

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

   METHOD oDefIniInf()  VIRTUAL
   METHOD oDefFinInf()  VIRTUAL

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField ( "cCodRut", "C",  4, 0, {|| "@!" },    "Cod.",                      .f., "Código ruta",                 4 )
   ::AddField ( "cNomRut", "C", 50, 0, {|| "@!" },    "Ruta",                      .f., "Nombre de la ruta",          25 )
   ::AddField ( "cCodCli", "C", 12, 0, {|| "@!" },    "Cod. Cli.",                 .t., "Código de cliente",           8 )
   ::AddField ( "cNomCli", "C", 50, 0, {|| "@!" },    "Cliente",                   .t., "Nombre de cliente",          30 )
   ::AddField ( "cNifCli", "C", 15, 0, {|| "@!" },    "Nif",                       .f., "Nif",                        15 )
   ::AddField ( "cDomCli", "C", 35, 0, {|| "@!" },    "Domicilio",                 .t., "Domicilio",                  25 )
   ::AddField ( "cPobCli", "C", 25, 0, {|| "@!" },    "Población",                 .t., "Población",                  25 )
   ::AddField ( "cProCli", "C", 20, 0, {|| "@!" },    "Provincia",                 .t., "Provincia",                  20 )
   ::AddField ( "cCdpCli", "C",  7, 0, {|| "@!" },    "CP",                        .t., "Cod. Postal",                 7 )
   ::AddField ( "cTlfCli", "C", 12, 0, {|| "@!" },    "Tlf",                       .f., "Teléfono",                   12 )
   ::AddField ( "cFaxCli", "C", 12, 0, {|| "@!" },    "Fax",                       .f., "Fax",                        12 )
   ::AddField ( "cMovCli", "C", 12, 0, {|| "@!" },    "Móvil",                     .f., "Móvil",                      12 )

   ::AddTmpIndex ( "CCODRUT", "CCODRUT + CCODCLI" )

   ::AddGroup( {|| ::oDbf:cCodRut }, {|| "Ruta  : " + ::oDbf:cCodRut + "-" + ::oDbf:cNomRut }, {|| Space(1) } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TLisRutInf

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TLisRutInf

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TLisRutInf

   ::lDefFecInf   := .f.
   ::lDefSerInf   := .f.
   ::lDefDivInf   := .f.

   if !::StdResource( "INF_GEN27" )
      return .f.
   end if

   /*
   Monta los Rutntes de manera automatica
   */

   if !::oDefRutInf( 70, 80, 90, 100, 900 )
      return .f.
   end if

   /*
   Monta los clientes de manera automática
   */

   if !::oDefCliInf( 110, 120, 130, 140, , 600 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oDbfCli:Lastrec() )

   ::CreateFilter( aItmCli(), ::oDbfCli:cAlias )

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

   ::aHeader   := {{|| "Fecha    : " + Dtoc( Date() ) },;
                   {|| "Ruta     : " + if( ::lAllRut, "Todas", AllTrim( ::cRutOrg ) + " > " + AllTrim( ::cRutDes ) ) },;
                   {|| "Clientes : " + if( ::lAllCli, "Todos", AllTrim( ::cCliOrg ) + " > " + AllTrim( ::cCliDes ) ) } }

   ::oDbfCli:OrdSetFocus( "COD" )

   if !::lAllCli
      cExpHead       := 'Cod >= "' + Rtrim( ::cCliOrg ) + '" .and. Cod <= "' + Rtrim( ::cCliDes ) + '"'
   else
      cExpHead       := '.t.'
   end if

   if !::lAllRut
      cExpHead       += ' .and. cCodRut >= "' + Rtrim( ::cRutOrg ) + '" .and. cCodRut <= "' + Rtrim( ::cRutDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oDbfCli:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oDbfCli:cFile ), ::oDbfCli:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oDbfCli:OrdKeyCount() )

   ::oDbfCli:GoTop()

   while !::lBreak .and. !::oDbfCli:Eof()

      ::oDbf:Append()

      ::oDbf:cCodRut := ::oDbfCli:cCodRut
      ::oDbf:cNomRut := oRetFld( ::oDbfCli:cCodRut, ::oDbfRut )
      ::oDbf:cCodCli := ::oDbfCli:Cod
      ::oDbf:cNomCli := ::oDbfCli:Titulo
      ::oDbf:cNifCli := ::oDbfCli:Nif
      ::oDbf:cDomCli := ::oDbfCli:Domicilio
      ::oDbf:cPobCli := ::oDbfCli:Poblacion
      ::oDbf:cProCli := ::oDbfCli:Provincia
      ::oDbf:cCdpCli := ::oDbfCli:CodPostal
      ::oDbf:cTlfCli := ::oDbfCli:Telefono
      ::oDbf:cFaxCli := ::oDbfCli:Fax
      ::oDbf:cMovCli := ::oDbfCli:Movil

      ::oDbf:Save()

      ::oDbfCli:Skip()

      ::oMtrInf:AutoInc( ::oDbfCli:OrdKeyNo() )

   end while

   ::oDbfCli:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oDbfCli:cFile ) )

   ::oMtrInf:AutoInc( ::oDbfCli:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//