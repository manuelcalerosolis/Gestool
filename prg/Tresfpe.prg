#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION ResFamPedCli()

   local oInf
   local aCol  := {}
   local aIdx  := {}

   aAdd( aCol, { "cCodFam", "C", 16, 0, {|| "@!" },            "Cod.",           .t., "Código familia"              ,  5 } )
   aAdd( aCol, { "CNOMFAM", "C", 50, 0, {|| "@!" },            "Familia",        .t., "Familia"                     , 28 } )
   aAdd( aCol, { "NNUMCAJ", "N", 19, 6, {|| MasUnd() },        "Caj.",           .f., "Cajas"                       , 12 } )
   aAdd( aCol, { "NNUMUNI", "N", 19, 6, {|| MasUnd() },        "Und.",           .f., "Unidades"                    , 12 } )
   aAdd( aCol, { "NTOTUNI", "N", 19, 6, {|| MasUnd() },        "Tot. Und.",      .t., "Total unidades"              , 12 } )
   aAdd( aCol, { "NIMPART", "N", 19, 6, {|| oInf:cPicOut },    "Importe",        .t., "Importe"                     , 12 } )
   aAdd( aCol, { "NPedMED", "N", 19, 6, {|| oInf:cPicOut },    "Pedcio medio",   .f., "Pedcio medio"                , 12 } )
   aAdd( aCol, { "NIMPCOM", "N", 19, 6, {|| oInf:cPicOut },    "Pedvisión",      .f., "Pedvisión"                   , 12 } )
   aAdd( aCol, { "NACUCAJ", "N", 19, 6, {|| MasUnd() },        "Caj. Acu.",      .f., "Total caja acumuladas"       , 12 } )
   aAdd( aCol, { "NACUUNI", "N", 19, 6, {|| MasUnd() },        "Und. Acu.",      .f., "Total unidades acumuladas"   , 12 } )
   aAdd( aCol, { "NACUTOT", "N", 19, 6, {|| MasUnd() },        "Tot. Und. Acu.", .f., "Total unidades"              , 12 } )
   aAdd( aCol, { "NACUIMP", "N", 19, 6, {|| oInf:cPicOut },    "Tot. Importe",   .f., "Total importe acumulado"     , 12 } )
   aAdd( aCol, { "NIMPDES", "N", 19, 6, {|| oInf:cPicOut },    "Desviación",     .f., "Desviación"                  , 12 } )

   aAdd( aIdx, { "cCodFam", "cCodFam" } )

   oInf  := TResFamPed():New( "Informe resumido de ventas en pedidos de clientes agrupado por familias", aCol, aIdx, "01055" )

   oInf:Resource()
   oInf:Activate()

   oInf:End()

   oInf  := nil

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TResFamPed FROM TInfGen

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oPedCliT    AS OBJECT
   DATA  oPedCliL    AS OBJECT
    
   DATA  aMes        AS ARRAY    INIT {.f., .f., .f., .f., .f., .f., .f., .f., .f., .f., .f., .f. }
   DATA  lAno        AS LOGIC    INIT .f.
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Parcialmente", "Entregado", "Todos" }

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()


END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TResFamPed

   /*
   Ficheros necesarios
   */

   ::oPedCliT := TDataCenter():oPedCliT()

   DATABASE NEW ::oPedCliL PATH ( cPatEmp() ) FILE "PedCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "PedCLIL.CDX"
   ::oPedCliL:SetOrder( "CREF" )

   DATABASE NEW ::oDbfArt   PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TResFamPed

   ::oPedCliT:End()
   ::oPedCliL:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TResFamPed

   local cEstado := "Todos"

   if !::StdResource( "INF_GEN11A" )
      return .f.
   end if

   /*
   Monta familias
   */

   ::lDefFamInf( 110, 120, 130, 140 )

   /*
   Meter
   */

   ::oMtrInf:SetTotal( ::oDbfArt:Lastrec() )

   ::oDefExcInf(204)

   ::oDefResInf(202)

   ::oDefSalInf(201)

   REDEFINE CHECKBOX ::lExcMov ;
      ID       ( 203 );
      OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::aMes[ 1] ID 205 OF ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::aMes[ 2] ID 206 OF ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::aMes[ 3] ID 207 OF ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::aMes[ 4] ID 208 OF ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::aMes[ 5] ID 209 OF ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::aMes[ 6] ID 210 OF ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::aMes[ 7] ID 211 OF ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::aMes[ 8] ID 212 OF ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::aMes[ 9] ID 213 OF ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::aMes[10] ID 214 OF ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::aMes[11] ID 215 OF ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::aMes[12] ID 216 OF ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lAno     ID 217 OF ::oFld:aDialogs[1]

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TResFamPed

   local bValid   := {|| .t. }

   ::oDlg:Disable()

   ::oDbf:Zap()

   ::oDbfArt:GoTop()

   ::aHeader   := {  {|| "Fecha  : " + Dtoc( Date() ) },;
                     {|| "Periodo: " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dIniInf ) },;
                     {|| "Familia: " + ::cFamOrg       + " > " + ::cFamDes },;
                     {|| "Estado : " + ::aEstado[ ::oEstado:nAt ] } }

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

   WHILE !::oDbfArt:Eof()

      IF ::oDbfArt:FAMILIA >= ::cFamOrg .AND. ::oDbfArt:FAMILIA <= ::cFamDes

         IF ::oPedCliL:Seek( ::oDbfArt:Codigo )

            WHILE ::oPedCliL:CREF = ::oDbfArt:Codigo .AND. !::oPedCliL:Eof()

               IF ::oPedCliT:Seek( ::oPedCliL:cSerPed + Str( ::oPedCliL:nNumPed ) + ::oPedCliL:cSufPed )

                  IF lChkSer( ::oPedCliT:CSERPed, ::aSer )                                .AND.;
                     Eval( bValid )                                                       .AND.;
                     !( ::lExcCero .AND. ::oPedCliL:nPreDiv == 0 )

                     /*
                     Comparativa entre fechas
                     */

                     IF ::oPedCliT:DFECPed >= ::dIniInf .AND. ::oPedCliT:DFECPed <= ::dFinInf

                        IF ::oDbf:Seek( ::oDbfArt:Familia )

                           ::oDbf:Load()
                           ::oDbf:nNumCaj    += ::oPedCliL:NCANPed
                           ::oDbf:nNumUni    += ::oPedCliL:NUNICAJA
                           ::oDbf:nTotUni    += nTotNPedCli( ::oPedCliL )
                           ::oDbf:nImpArt    += nImpLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDerOut, ::nDerOut, ::nValDiv )
                           ::oDbf:nImpCom    := nPreFamilia( ::oDbfArt:FAMILIA, ::aMes, ::lAno, ::oDbfFam:cAlias )
                           ::oDbf:nImpDes    := ::oDbf:NNUMUNI - ::oDbf:NIMPCOM
                           ::oDbf:nPedMed    := ::oDbf:NIMPART / ::oDbf:NNUMUNI
                           ::oDbf:Save()

                        ELSE

                           ::oDbf:Append()
                           ::oDbf:cCodFam    := ::oDbfArt:Familia
                           ::oDbf:cNomFam    := RetFamilia( ::oDbfArt:Familia, ::oDbfFam:cAlias )
                           ::oDbf:nNumCaj    := ::oPedCliL:NCANPed
                           ::oDbf:nNumUni    := ::oPedCliL:NUNICAJA
                           ::oDbf:nTotUni    := nTotNPedCli( ::oPedCliL )
                           ::oDbf:nImpArt    := nImpLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDerOut, ::nDerOut, ::nValDiv )
                           ::oDbf:nImpCom    := nPreFamilia( ::oDbfArt:FAMILIA, ::aMes, ::lAno, ::oDbfFam:cAlias )
                           ::oDbf:nImpDes    := ::oDbf:NNUMUNI - ::oDbf:NIMPCOM
                           ::oDbf:nPedMed    := ::oDbf:NIMPART / ::oDbf:NNUMUNI
                           ::oDbf:Save()

                        END IF

                     END IF
                     /*
                     Acumulado
                     */

                     IF ::oDbf:Seek( ::oDbfArt:Familia )

                        ::oDbf:Load ()
                        ::oDbf:nAcuCaj    += ::oPedCliL:nCanPed
                        ::oDbf:nAcuUni    += ::oPedCliL:nUniCaja
                        ::oDbf:nAcuTot    += nTotNPedCli( ::oPedCliL )
                        ::oDbf:nAcuImp    += nImpLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDerOut, ::nDerOut, ::nValDiv )
                        ::oDbf:Save()

                     ELSE

                        ::oDbf:Append()
                        ::oDbf:cCodFam    := ::oDbfArt:Familia
                        ::oDbf:cNomFam    := RetFamilia( ::oDbfArt:Familia, ::oDbfFam:cAlias )
                        ::oDbf:nAcuCaj    := ::oPedCliL:nCanPed
                        ::oDbf:nAcuUni    := ::oPedCliL:nUniCaja
                        ::oDbf:nAcuTot    := nTotNPedCli( ::oPedCliL )
                        ::oDbf:nAcuImp    := nImpLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDerOut, ::nDerOut, ::nValDiv )
                        ::oDbf:Save()

                     END IF

                  END IF

               END IF

               ::oPedCliL:Skip()

            END WHILE

         END IF

      END IF

      ::oDbfArt:Skip()
      ::oMtrInf:AutoInc( ::oDbfArt:OrdKeyNo() )

   END WHILE

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//