#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TLisAgeInf FROM TInfGen

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

   ::AddField ( "CCODAGE", "C",  3, 0, {|| "@!" },   "Age",                       .f., "Cod. Agente",                 3 )
   ::AddField ( "CNOMAGE", "C", 50, 0, {|| "@!" },   "Nom Age",                   .f., "Nom. Agente",                25 )
   ::AddField ( "CCODGRP", "C",  4, 0, {|| "@!" },   "Grp.",                      .f., "Código de grupo de cliente",  6 )
   ::AddField ( "CCODCLI", "C", 12, 0, {|| "@!" },   "Cliente",                   .t., "Cod. Cliente",                8 )
   ::AddField ( "CNOMCLI", "C", 50, 0, {|| "@!" },   "Nombre",                    .t., "Nom. Cliente",               50 )
   ::AddField ( "CNIFCLI", "C", 15, 0, {|| "@!" },   "Nif",                       .t., "Nif",                        15 )
   ::AddField ( "CDOMCLI", "C", 35, 0, {|| "@!" },   "Domicilio",                 .t., "Domicilio",                  25 )
   ::AddField ( "CPOBCLI", "C", 25, 0, {|| "@!" },   "Población",                 .f., "Población",                  25 )
   ::AddField ( "CPROCLI", "C", 20, 0, {|| "@!" },   "Provincia",                 .f., "Provincia",                  20 )
   ::AddField ( "CCDPCLI", "C",  7, 0, {|| "@!" },   "Código postal",             .f., "Cod. Postal",                 7 )
   ::AddField ( "CTLFCLI", "C", 12, 0, {|| "@!" },   "Teléfono",                  .f., "Teléfono",                   12 )

   ::AddTmpIndex( "CCODAGE", "CCODAGE + CCODGRP + CCODCLI" )
   ::AddGroup( {|| ::oDbf:cCodAge }, {|| "Agente  : " + Rtrim( ::oDbf:cCodAge ) + "-" + oRetFld( ::oDbf:cCodAge, ::oDbfAge ) } )
   ::AddGroup( {|| ::oDbf:cCodAge + ::oDbf:cCodGrp }, {|| "Grupo  : " + Rtrim( ::oDbf:cCodGrp ) + "-" + oRetFld( ::oDbf:cCodGrp, ::oGrpCli:oDbf ) } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TLisAgeInf

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TLisAgeInf

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TLisAgeInf

   if !::StdResource( "INF_GEN23" )
      return .f.
   end if

   /*
   Monta los agentes de manera automatica
   */

   if !::oDefAgeInf( 70, 80, 90, 100, 930 )
      return .f.
   end if

   /*
   Monta los grupos de clientes
   */

   if !::oDefGrpCli( 170, 171, 180, 181, 888 )
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

   ::oDbfCli:GoTop()

   ::aHeader   := {{|| "Fecha         : "   + Dtoc( Date() ) },;
                   {|| "Agentes       : "   + AllTrim( ::cAgeOrg ) + " > " + AllTrim( ::cAgeDes ) },;
                   {|| "Grp. clientes : "   + AllTrim( ::cGrpOrg ) + " > " + AllTrim( ::cGrpDes ) },;
                   {|| "Clientes      : "   + AllTrim( ::cCliOrg ) + " > " + AllTrim( ::cCliDes ) } }

   ::oDbfCli:OrdSetFocus( "COD" )

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       := ::oFilter:cExpresionFilter
   else
      cExpHead       := '.t.'
   end if

   ::oDbfCli:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oDbfCli:cFile ), ::oDbfCli:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oDbfCli:OrdKeyCount() )

   /*
   Nos movemos por las cabeceras de los clientes
   */

   while !::lBreak .and. !::oDbfCli:Eof()

      if ( ::lAllCli .or. ( ::oDbfCli:Cod >= ::cCliOrg .and. ::oDbfCli:Cod <= ::cCliDes ))           .and.;
         ( ::lGrpAll .or. ( ::oDbfCli:cCodGrp >= ::cGrpOrg .and. ::oDbfCli:cCodGrp <= ::cGrpDes ))   .and.;
         ( ::lAgeAll .or. ( ::oDbfCli:cAgente >= ::cAgeOrg .and. ::oDbfCli:cAgente <= ::cAgeDes ) )

         ::oDbf:Append()

         ::oDbf:cCodAge := ::oDbfCli:cAgente
         ::oDbf:cNomAge := ::oDbfAge:cNbrAge
         ::oDbf:cCodGrp := ::oDbfCli:cCodGrp
         ::oDbf:cCodCli := ::oDbfCli:Cod
         ::oDbf:cNomCli := ::oDbfCli:Titulo
         ::oDbf:CNIFCLI := ::oDbfCli:Nif
         ::oDbf:CDOMCLI := ::oDbfCli:Domicilio
         ::oDbf:CPOBCLI := ::oDbfCli:Poblacion
         ::oDbf:CPROCLI := ::oDbfCli:Provincia
         ::oDbf:CCDPCLI := ::oDbfCli:CodPostal
         ::oDbf:CTLFCLI := ::oDbfCli:Telefono

         ::oDbf:Save()

      end if

      ::oDbfCli:Skip()

      ::oMtrInf:AutoInc( ::oDbfCli:OrdKeyNo() )

   end while

   ::oDbfCli:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oDbfCli:cFile ) )

   ::oMtrInf:AutoInc( ::oDbfCli:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//