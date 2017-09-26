#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS InfAge FROM TInfGen

   METHOD Create()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodAge",       "C",  3, 0, {|| "" },     "Cod.",             .t., "Código del agente",          5, .f. )
   ::AddField( "cApeAge",       "C", 30, 0, {|| "" },     "Apellidos",        .f., "Apellidos del agente",      30, .f. )
   ::AddField( "cNbrAge",       "C", 15, 0, {|| "" },     "Nombre",           .t., "Nombre del agente",         15, .f. )
   ::AddField( "cDniNif",       "C", 15, 0, {|| "" },     "DNI",              .t., "DNI del agente",            15, .f. )
   ::AddField( "cDirAge",       "C", 35, 0, {|| "" },     "Domicilio",        .t., "dirección del agente",      15, .f. )
   ::AddField( "cPobAge",       "C", 25, 0, {|| "" },     "Población",        .t., "Población del agente",      15, .f. )
   ::AddField( "cPtlAge",       "C",  5, 0, {|| "" },     "C.P.",             .t., "Código postal del agente",   6, .f. )
   ::AddField( "cProv",         "C", 15, 0, {|| "" },     "Provincia",        .t., "Provincia del agente",      15, .f. )
   ::AddField( "cTfoAge",       "C", 12, 0, {|| "" },     "Teléfono",         .f., "Teléfono del agente",       12, .f. )
   ::AddField( "cFaxAge",       "C", 12, 0, {|| "" },     "Fax",              .f., "Fax del agente",            12, .f. )
   ::AddField( "cMovAge",       "C", 12, 0, {|| "" },     "Movíl",            .f., "Movíl del agente",          12, .f. )
   ::AddField( "nIrpfAge",      "N",  5, 2, {|| "" },     "IRPF",             .t., "IRPF del agente",            6, .f. )

   ::AddTmpIndex ( "cCodAge", "cCodAge" )

   ::lDefFecInf   := .f.
   ::lDefSerInf   := .f.
   ::lDefDivInf   := .f.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INF_AGE01" )
      return .f.
   end if

   /*
   Montamos los agentes
   */

   ::oDefAgeInf( 70, 80, 90, 100, 60 )

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oDbfAge:Lastrec() )

   ::CreateFilter( aItmAge(), ::oDbfAge:cAlias )

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

   ::aHeader      := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                        {|| "Agentes   : " + if( ::lAgeAll, "Todos", AllTrim( ::cAgeOrg ) + " > " + AllTrim( ::cAgeDes ) ) } }

   ::oDbfAge:OrdSetFocus( "CCODAGE" )

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       := ::oFilter:cExpresionFilter
   else
      cExpHead       := '.t.'
   end if

   ::oDbfAge:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oDbfAge:cFile ), ::oDbfAge:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oDbfAge:GoTop()

   while !::lBreak .and. !::oDbfAge:Eof()

      if ( ::lAgeAll .or. ( ::oDbfAge:cCodAge >= ::cAgeOrg .AND. ::oDbfAge:cCodAge <= ::cAgeDes ) )

         ::oDbf:Append()
         ::oDbf:cCodAge     := ::oDbfAge:cCodAge
         ::oDbf:cApeAge     := ::oDbfAge:cApeAge
         ::oDbf:cNbrAge     := ::oDbfAge:cNbrAge
         ::oDbf:cDniNif     := ::oDbfAge:cDniNif
         ::oDbf:cDirAge     := ::oDbfAge:cDirAge
         ::oDbf:cPobAge     := ::oDbfAge:cPobAge
         ::oDbf:cPtlAge     := ::oDbfAge:cPtlAge
         ::oDbf:cProv       := ::oDbfAge:cProv
         ::oDbf:cTfoAge     := ::oDbfAge:cTfoAge
         ::oDbf:cFaxAge     := ::oDbfAge:cFaxAge
         ::oDbf:cMovAge     := ::oDbfAge:cMovAge
         ::oDbf:nIrpfAge    := ::oDbfAge:nIrpfAge
         ::oDbf:Save()

      end if

      ::oDbfAge:Skip()

      ::oMtrInf:AutoInc( ::oDbfAge:OrdKeyNo() )

   end while

   ::oDbfAge:IdxDelete( cCurUsr(), GetFileNoExt( ::oDbfAge:cFile ) )

   ::oMtrInf:AutoInc( ::oDbfAge:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//