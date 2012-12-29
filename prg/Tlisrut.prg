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
   ::AddField ( "cDefI01", "C",100, 0, {|| "@!" },    {|| ::cNameIniCli(1) },      .f., {|| ::cNameIniCli(1) },       50 )
   ::AddField ( "cDefI02", "C",100, 0, {|| "@!" },    {|| ::cNameIniCli(2) },      .f., {|| ::cNameIniCli(2) },       50 )
   ::AddField ( "cDefI03", "C",100, 0, {|| "@!" },    {|| ::cNameIniCli(3) },      .f., {|| ::cNameIniCli(3) },       50 )
   ::AddField ( "cDefI04", "C",100, 0, {|| "@!" },    {|| ::cNameIniCli(4) },      .f., {|| ::cNameIniCli(4) },       50 )
   ::AddField ( "cDefI05", "C",100, 0, {|| "@!" },    {|| ::cNameIniCli(5) },      .f., {|| ::cNameIniCli(5) },       50 )
   ::AddField ( "cDefI06", "C",100, 0, {|| "@!" },    {|| ::cNameIniCli(6) },      .f., {|| ::cNameIniCli(6) },       50 )
   ::AddField ( "cDefI07", "C",100, 0, {|| "@!" },    {|| ::cNameIniCli(7) },      .f., {|| ::cNameIniCli(7) },       50 )
   ::AddField ( "cDefI08", "C",100, 0, {|| "@!" },    {|| ::cNameIniCli(8) },      .f., {|| ::cNameIniCli(8) },       50 )
   ::AddField ( "cDefI09", "C",100, 0, {|| "@!" },    {|| ::cNameIniCli(9) },      .f., {|| ::cNameIniCli(9) },       50 )
   ::AddField ( "cDefI10", "C",100, 0, {|| "@!" },    {|| ::cNameIniCli(10)},      .f., {|| ::cNameIniCli(10)},       50 )

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

   if !Empty( ::oFilter:cExpFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpFilter
   end if

   ::oDbfCli:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oDbfCli:cFile ), ::oDbfCli:OrdKey(), ( cExpHead ), , , , , , , , .t. )

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
      ::oDbf:cDefI01 := ::oDbfCli:CusRDef01
      ::oDbf:cDefI02 := ::oDbfCli:CusRDef02
      ::oDbf:cDefI03 := ::oDbfCli:CusRDef03
      ::oDbf:cDefI04 := ::oDbfCli:CusRDef04
      ::oDbf:cDefI05 := ::oDbfCli:CusRDef05
      ::oDbf:cDefI06 := ::oDbfCli:CusRDef06
      ::oDbf:cDefI07 := ::oDbfCli:CusRDef07
      ::oDbf:cDefI08 := ::oDbfCli:CusRDef08
      ::oDbf:cDefI09 := ::oDbfCli:CusRDef09
      ::oDbf:cDefI10 := ::oDbfCli:CusRDef10

      ::oDbf:Save()

      ::oDbfCli:Skip()

      ::oMtrInf:AutoInc( ::oDbfCli:OrdKeyNo() )

   end while

   ::oDbfCli:IdxDelete( cCurUsr(), GetFileNoExt( ::oDbfCli:cFile ) )

   ::oMtrInf:AutoInc( ::oDbfCli:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//