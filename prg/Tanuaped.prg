#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//
CLASS TAnuAPed FROM TInfAlm

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oPedCliT    AS OBJECT
   DATA  oPedCliL    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Parcilamente", "Entregado", "Todos" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::CreateFldAnu()

   ::AddTmpIndex( "cCodAlm", "cCodAlm" )

   ::lDefFecInf   := .f.
   ::lDefGraph    := .t.

RETURN ( Self )

//---------------------------------------------------------------------------//
METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oPedCliT := TDataCenter():oPedCliT()

   DATABASE NEW ::oPedCliL PATH ( cPatEmp() ) FILE "PEDCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "PEDCLIL.CDX"

   DATABASE NEW ::oDbfCli  PATH ( cPatEmp() ) FILE "CLIENT.DBF" VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

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

METHOD lResource( cFld )

   local cEstado := "Todos"

   if !::StdResource( "INF_GEN01N" )
      return .f.
   end if

   /*
   Monta los a�os
   */

   ::oDefYea()

   /*
   Monta los almacenes de manera automatica
   */

   if !::oDefAlmInf( 70, 80, 90, 100, 700 )
      return .f.
   end if

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

   local cExpHead       := ""
   local cExpLine       := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader            := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                              {|| "A�o     : " + AllTrim( Str( ::nYeaInf ) ) },;
                              {|| "Almac�n : " + if( ::lAllAlm, "Todos", AllTrim( ::cAlmOrg ) + " > " + AllTrim( ::cAlmDes ) ) } ,;
                              {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ] } }

   ::oPedCliT:OrdSetFocus( "dFecPed" )
   ::oPedCliL:OrdSetFocus( "nNumPed" )

   cExpHead             := "!lCancel"

   do case
      case ::oEstado:nAt == 1
         cExpHead       += ' .and. nEstado == 1'
      case ::oEstado:nAt == 2
         cExpHead       += ' .and. nEstado == 2'
      case ::oEstado:nAt == 3
         cExpHead       += ' .and. nEstado == 3'
   end case
         
   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead          += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oPedCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oPedCliT:cFile ), ::oPedCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oPedCliT:OrdKeyCount() )

   // Lineas de pedidos

   cExpLine          := ' !lTotLin .and. !lControl '

   if !::lAllAlm
      cExpLine       += ' .and. cAlmLin >= "' + Rtrim( ::cAlmOrg ) + '" .and. cAlmLin <= "' + Rtrim( ::cAlmDes ) + '"'
   end if

   ::oPedCliL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oPedCliL:cFile ), ::oPedCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   /*
   Nos movemos por las cabeceras de los pedidos
	*/

   ::oPedCliT:GoTop()

   while !::lBreak .and. !::oPedCliT:Eof()

      IF Year( ::oPedCliT:dFecPed ) == ::nYeaInf                                            .AND.;
         lChkSer( ::oPedCliT:cSerPed, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oPedCliL:Seek( ::oPedCliT:cSerPed + Str( ::oPedCliT:nNumPed ) + ::oPedCliT:cSufPed )

            while ::oPedCliT:cSerPed + Str( ::oPedCliT:nNumPed ) + ::oPedCliT:cSufPed == ::oPedCliL:cSerPed + Str( ::oPedCliL:nNumPed ) + ::oPedCliL:cSufPed .AND. ! ::oPedCliL:eof()

               if !( ::lExcCero .AND. nImpLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                  if !::oDbf:Seek( ::oPedCliL:cAlmLin + ::oPedCliL:cRef )
                     ::oDbf:Blank()
                     ::oDbf:cCodAlm := ::oPedCliL:cAlmLin
                     ::oDbf:cNomAlm := oRetFld( ::oDbf:cCodAlm, ::oDbfAlm )
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

   ::oPedCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oPedCliT:cFile ) )

   ::oPedCliL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oPedCliL:cFile ) )

   ::oMtrInf:AutoInc( ::oPedCliT:Lastrec() )

   if !::lExcCero
      ::IncluyeCero()
   end if

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//