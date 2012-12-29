#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch"
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TGruCli FROM TInfGen

   DATA  oDbfCli  AS OBJECT

   METHOD create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cGrpCli", "C",  4, 0, {|| "@!" },        "Cod. grupo",    .f., "Cod. grupo"        ,  5, .f. )
   ::AddField( "cNomGrp", "C", 20, 0, {|| "@!" },        "Nom. grupo",    .f., "Nom. grupo"        , 20, .f. )
   ::FldCliente()

   ::AddTmpIndex( "CGRPCLI", "CGRPCLI + CCODCLI" )

   ::AddGroup( {|| ::oDbf:cGrpCli }, {|| "Grupo de cliente  : " + Rtrim( ::oDbf:cGrpCli ) + "-" + Rtrim( ::oDbf:cNomGrp ) }, {||"Total grupo de cliente..."} )

   ::lDefSerInf := .f.
   ::lDefFecInf := .f.
   ::lDefDivInf := .f.

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfCli PATH ( cPatCli() ) FILE "CLIENT.DBF" VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbfCli ) .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if

   ::oDbfCli := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource ( cFld )

   if !::StdResource( "INF_GRU_CLI" )
      return .f.
   end if

   /*
   Monta los grupos de familias de manera automatica
   */

   if !::oDefGrpCli( 70, 80, 90, 100, 150 )
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

   local cExpCli  := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha         : " + Dtoc( Date() ) },;
                        {|| "Grp. clientes : " + if( ::lGrpAll, "Todos", AllTrim( ::cGrpOrg ) + " > " + AllTrim( ::cGrpDes ) ) } }

   ::oDbfCli:OrdSetFocus( "Cod" )

   if !::lGrpAll
      cExpCli      := 'cCodGrp >= "' + Rtrim( ::cGrpOrg ) + '" .and. cCodGrp <= "' + Rtrim( ::cGrpDes ) + '"'
   else
      cExpCli      := '.t.'
   end if

   if !Empty( ::oFilter:cExpFilter )
      cExpCli      += ' .and. ' + ::oFilter:cExpFilter
   end if

   ::oDbfCli:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oDbfCli:cFile ), ::oDbfCli:OrdKey(), ( cExpCli ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oDbfCli:OrdKeyCount() )

   /*
   Nos movemos por la base de datos de clientes
	*/

   ::oDbfCli:GoTop()

   while !::lBreak .and. !::oDbfCli:Eof()

      ::oDbf:Append()

      ::oDbf:cGrpCli  := ::oDbfCli:cCodGrp
      ::oDbf:cNomGrp  := oRetFld( ::oDbfCli:cCodGrp, ::oGrpCli:oDbf )
      ::oDbf:cCodCli  := ::oDbfCli:Cod
      ::oDbf:cNomCli  := ::oDbfCli:Titulo
      ::oDbf:cNifCli  := ::oDbfCli:Nif
      ::oDbf:cDomCli  := ::oDbfCli:Domicilio
      ::oDbf:cPobCli  := ::oDbfCli:Poblacion
      ::oDbf:cProCli  := ::oDbfCli:Provincia
      ::oDbf:cCdpCli  := ::oDbfCli:CodPostal
      ::oDbf:cTlfCli  := ::oDbfCli:Telefono
      ::oDbf:cDefI01  := ::oDbfCli:cUsrDef01
      ::oDbf:cDefI02  := ::oDbfCli:cUsrDef02
      ::oDbf:cDefI03  := ::oDbfCli:cUsrDef03
      ::oDbf:cDefI04  := ::oDbfCli:cUsrDef04
      ::oDbf:cDefI05  := ::oDbfCli:cUsrDef05
      ::oDbf:cDefI06  := ::oDbfCli:cUsrDef06
      ::oDbf:cDefI07  := ::oDbfCli:cUsrDef07
      ::oDbf:cDefI08  := ::oDbfCli:cUsrDef08
      ::oDbf:cDefI09  := ::oDbfCli:cUsrDef09
      ::oDbf:cDefI10  := ::oDbfCli:cUsrDef10

      ::oDbf:Save()

      ::oDbfCli:Skip()

      ::oMtrInf:AutoInc( ::oDbfCli:OrdKeyNo() )

   end while

   ::oDbfCli:IdxDelete( cCurUsr(), GetFileNoExt( ::oDbfCli:cFile ) )

   ::oMtrInf:AutoInc( ::oDbfCli:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//