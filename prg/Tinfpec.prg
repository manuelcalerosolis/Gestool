#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfDetPed FROM TInfAlm

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

   ::CreateFields()

   ::AddTmpIndex ( "CCODALM", "CCODALM + CCODART" )

   ::AddGroup( {|| ::oDbf:cCodAlm },                     {|| "Almacén  : " + Rtrim( ::oDbf:cCodAlm ) + "-" + oRetFld( ::oDbf:cCodAlm, ::oDbfAlm ) },  {||"Total almacén ..."} )
   ::AddGroup( {|| ::oDbf:cCodAlm + ::oDbf:cCodArt },    {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + oRetFld( ::oDbf:cCodArt, ::oDbfArt ) },  {||"Total articulo..."} )

RETURN ( self )

//---------------------------------------------------------------------------//
METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   /*
   Ficheros necesarios
   */

   BEGIN SEQUENCE

   ::oPedCliT := TDataCenter():oPedCliT()

   DATABASE NEW ::oPedCliL PATH ( cPatEmp() ) FILE "PEDCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "PEDCLIL.CDX"

   DATABASE NEW ::oDbfCli PATH ( cPatEmp() ) FILE "CLIENT.DBF" VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

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

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld )

   local cEstado := "Todos"

   if !::StdResource( "INF_GEN01C" )
      return .f.
   end if

   /*
   Monta los almacenes de manera automatica
   */

   ::oDefAlmInf( 70, 80, 90, 100 )

   /*
   Monta los articulos de manera automatica
   */

   ::lDefArtInf( 110, 120, 130, 140 )

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oPedCliT:Lastrec() )

   ::oDefExcInf()

   ::oDefResInf()

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local bValid   := {|| .t. }
   local lExcCero := .f.

   ::oDlg:Disable()

   ::oDbf:Zap()
   ::oPedCliT:GoTop()

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| ::oPedCliT:nEstado == 1 }
      case ::oEstado:nAt == 2
         bValid   := {|| ::oPedCliT:nEstado == 2 }
      case ::oEstado:nAt == 3
         bValid   := {|| ::oPedCliT:nEstado == 3 }
      case ::oEstado:nAt == 4
         bValid   := {|| .t. }
   end case

   /*
   Creamos la cabcera del listado
   */

   ::aHeader   := {  {|| "Fecha  : " + Dtoc( Date() ) },;
                     {|| "Periodo: " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Almacen: " + ::cAlmOrg         + " > " + ::cAlmDes },;
                     {|| "Estado : " + ::aEstado[ ::oEstado:nAt ] } }

   /*
   Nos movemos por las cabeceras de los pedidos a proveedores
	*/

   WHILE ! ::oPedCliT:Eof()

      IF Eval( bValid )                                        .AND.;
         ::oPedCliT:DFECPED >= ::dIniInf                       .AND.;
         ::oPedCliT:DFECPED <= ::dFinInf                       .AND.;
         lChkSer( ::oPedCliT:CSERPED, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oPedCliL:Seek( ::oPedCliT:CSERPED + Str( ::oPedCliT:NNUMPED ) + ::oPedCliT:CSUFPED )

            while ::oPedCliT:CSERPED + Str( ::oPedCliT:NNUMPED ) + ::oPedCliT:CSUFPED == ::oPedCliL:CSERPED + Str( ::oPedCliL:NNUMPED ) + ::oPedCliL:CSUFPED .AND. ! ::oPedCliL:eof()

               if ::oPedCliL:CREF >= ::cArtOrg                 .AND.;
                  ::oPedCliL:CREF <= ::cArtDes                 .AND.;
                  ::oPedCliL:cAlmLin >= ::cAlmOrg              .AND.;
                  ::oPedCliL:cAlmLin <= ::cAlmDes              .AND.;
                  !( ::lExcCero .AND. ::oPedCliL:NUNICAJA == 0 )

                  ::oDbf:Append()

                  ::oDbf:cCodAlm := ::oPedCliL:cAlmLin
                  ::oDbf:dFecMov := ::oPedCliT:dFecPed

                  ::oDbf:cCodArt := ::oPedCliL:cRef
                  ::oDbf:cNomArt    := RetArticulo( ::oPedCliL:cRef, ::oDbfArt )

                  ::oDbf:nCajEnt := ::oPedCliL:nCanEnt
                  ::oDbf:nUntEnt := nTotNPedCli( ::oPedCliL )
                  ::oDbf:nUnidad := ::oPedCliL:nUniCaja
                  ::oDbf:nPreDiv    := nTotUPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTrn    := nTrnUPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nPntVer    := nPntUPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTot    := nImpLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:cTipDoc := "Pedido"
                  ::oDbf:cDocMov := lTrim ( ::oPedCliL:cSerPed ) + "/" + lTrim ( Str( ::oPedCliL:nNumPed ) ) + "/" + lTrim ( ::oPedCliL:cSufPed )

                  ::AddCliente( ::oPedCliT:cCodCli, ::oPedCliT, .f. )

                  ::oDbf:Save()

               end if

               ::oPedCliL:Skip()

            end while

         end if

      end if

      ::oPedCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oPedCliT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//