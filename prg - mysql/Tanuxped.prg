#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"
//---------------------------------------------------------------------------//

CLASS TAnuXPed FROM TInfGCLI

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oPedCliT    AS OBJECT
   DATA  oPedCliL    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Parcilamente", "Entregado", "Todos" }

   METHOD create ()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD create ()

   ::AnuGCliFields()

   ::AddTmpIndex( "cCodGrc", "cCodGrc" )

RETURN ( self )
//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oPedCliT := TDataCenter():oPedCliT()

   DATABASE NEW ::oPedCliL PATH ( cPatEmp() ) FILE "PEDCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "PEDCLIL.CDX"

   DATABASE NEW ::oDbfCli PATH ( cPatCli() ) FILE "CLIENT.DBF" VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oPedCliT ) .and. ::oPedCliT:Used()
      ::oPedCliT:End()
   end if
   if !Empty( ::oPedCliL ) .and. ::oPedCliL:Used()
      ::oPedCliL:End()
   end if
   if !Empty( ::oDbfCli ) .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if

   ::oPedCliT := nil
   ::oPedCliL := nil
   ::oDbfCli  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld )

   local cEstado  := "Todos"

   ::lDefFecInf   := .f.

   if !::StdResource( "INFANUGRC" )
      return .f.
   end if

   /*
   Montamos grupos de clientes
   */
   if !::oDefGrpCli ( 70, 71, 80, 81, 90 )
      return .f.
   end if

   /*
   Monta los años
   */

   ::oDefYea( )

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oPedCliT:Lastrec() )

   ::oDefExcInf()

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmPedCli(), ::oPedCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead    := ""
   local cExpLine    := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha         : " + Dtoc( Date() ) },;
                        {|| "Año           : " + AllTrim( Str( ::nYeaInf ) ) },;
                        {|| "Grp. clientes : " + if( ::lGrpAll, "Todos", Rtrim( ::cGrpOrg ) + " > " + Rtrim( ::cGrpDes ) ) },;
                        {|| "Estado        : " + ::aEstado[ ::oEstado:nAt ] } }

   ::oPedCliT:OrdSetFocus( "dFecPed" )
   ::oPedCliL:OrdSetFocus( "nNumPed" )

   do case
      case ::oEstado:nAt == 1
         cExpHead    := 'nEstado == 1'
      case ::oEstado:nAt == 2
         cExpHead    := 'nEstado == 2'
      case ::oEstado:nAt == 3
         cExpHead    := 'nEstado == 3'
      case ::oEstado:nAt == 4
         cExpHead    := '.t.'
   end case

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oPedCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oPedCliT:cFile ), ::oPedCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oPedCliT:OrdKeyCount() )

   cExpLine          := ' !lTotLin .and. !lControl '

   ::oPedCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oPedCliL:cFile ), ::oPedCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oPedCliT:GoTop()

   while !::lBreak .and. !::oPedCliT:Eof()

      if Year( ::oPedCliT:dFecPed ) == ::nYeaInf                                  .AND.;
         ( ::lGrpAll .or. ( cGruCli( ::oPedCliT:cCodCli, ::oDbfCli ) >= ::cGrpOrg .AND. cGruCli( ::oPedCliT:cCodCli, ::oDbfCli ) <= ::cGrpDes ) ) .AND.;
         lChkSer( ::oPedCliT:cSerPed, ::aSer )

         if ::oPedCliL:Seek( ::oPedCliT:cSerPed + Str( ::oPedCliT:nNumPed ) + ::oPedCliT:cSufPed )

            while ::oPedCliT:cSerPed + Str( ::oPedCliT:nNumPed ) + ::oPedCliT:cSufPed == ::oPedCliL:cSerPed + Str( ::oPedCliL:nNumPed ) + ::oPedCliL:cSufPed .AND. ! ::oPedCliL:eof()

               if !( ::lExcCero .AND. nImpLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                  if !::oDbf:Seek( cGruCli( ::oPedCliT:cCodCli, ::oDbfCli ) )
                     ::oDbf:Blank()
                     ::oDbf:cCodGrc    := cGruCli( ::oPedCliT:cCodCli, ::oDbfCli )
                     ::oDbf:cNomGrc    := oRetFld( cGruCli( ::oPedCliT:cCodCli, ::oDbfCli ), ::oGrpCli:oDbf)
                     ::oDbf:Insert()
                  end if

                  ::AddImporte( ::oPedCliT:dFecPed, nImpLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )

                  ::nMediaMes( ::nYeaInf )

               end if

               ::oPedCliL:Skip()

            end while

         end if

      end if

      ::oPedCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oPedCliT:Lastrec() )

   ::oPedCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oPedCliT:cFile ) )
   ::oPedCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oPedCliL:cFile ) )

   if !::lExcCero
      ::IncluyeCero()
   end if

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//