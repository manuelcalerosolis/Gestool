#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION TResFpc()

   local oInf
   local aCol  := {}
   local aIdx  := {}

   aAdd( aCol, { "cCodFam", "C", 16, 0, {|| "@!" },            "Cod. Fam.",    .t., "Codigo Familia",  5, } )
   aAdd( aCol, { "CNOMFAM", "C", 50, 0, {|| "@!" },            "Familia",      .t., "Familia"       , 20, } )
   aAdd( aCol, { "NNUMCAJ", "N", 13, 6, {|| MasUnd() },        "Cajas",        .t., "Cajas"         ,  8, } )
   aAdd( aCol, { "NNUMUNI", "N", 13, 6, {|| MasUnd() },        "Unds.",        .t., "Unidades"      ,  8, } )
   aAdd( aCol, { "NIMPART", "N", 13, 6, {|| oInf:cPicOut },    "Importe",      .t., "Importe"       , 10, } )
   aAdd( aCol, { "NIMPCOM", "N", 13, 6, {|| oInf:cPicOut },    "Previsión",    .t., "Previsión"     , 10, } )
   aAdd( aCol, { "NIVAART", "N", 13, 6, {|| oInf:cPicOut },    cImp(),       .t., cImp()        , 10, } )
   aAdd( aCol, { "NACUCAJ", "N", 13, 6, {|| MasUnd() },        "Tot. Caja",    .t., "Total caja"    ,  8, } )
   aAdd( aCol, { "NACUUNI", "N", 13, 6, {|| MasUnd() },        "Tot. Und.",    .t., "Total und."    ,  8, } )
   aAdd( aCol, { "NACUIMP", "N", 13, 6, {|| oInf:cPicOut },    "Tot. Importe", .t., "Total importe" , 12, } )
   aAdd( aCol, { "NIMPDES", "N", 13, 6, {|| oInf:cPicOut },    "Desviación",   .t., "Desviación"    , 12, } )
   aAdd( aCol, { "NPREMED", "N", 13, 6, {|| oInf:cPicImp },    "Precio medio", .f., "Precio medio"  , 12, .f. } )

   aAdd( aIdx, { "cCodFam", "cCodFam" } )

   oInf  := TInfResFpc():New( "Informe resumido de ventas en pedidos de clientes agrupado por familias", aCol, aIdx, "01056" )

   oInf:Resource()
   oInf:Activate()

   oInf:End()

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TInfResFpc FROM TInfGen

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oPedCliT    AS OBJECT
   DATA  oPedCliL    AS OBJECT
    
   DATA  aMes        AS ARRAY    INIT {.f., .f., .f., .f., .f., .f., .f., .f., .f., .f., .f., .f. }
   DATA  lAno        AS LOGIC    INIT .f.
   DATA  aEstado     AS ARRAY    INIT { "Pendiente", "Parcialmente", "Entregado", "Todos" }

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()


END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TInfResFpc

   /*
   Ficheros necesarios
   */

   ::oPedCliT := TDataCenter():oPedCliT()

   DATABASE NEW ::oPedCliL PATH ( cPatEmp() ) FILE "PEDCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "PEDCLIL.CDX"
   ::oPedCliL:SetOrder( "CREF" )

   DATABASE NEW ::oDbfArt PATH ( cPatEmp() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TInfResFpc

   ::oPedCliT:End()
   ::oPedCliL:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TInfResFpc

   local cEstado := "Todos"

   if !::StdResource( "INF_GEN11A" )
      return .f.
   end if

   /* Monta familias */

   ::lDefFamInf( 110, 120, 130, 140 )

   /* Meter */

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

   REDEFINE CHECKBOX ::lAno;
      ID       217 ;
      OF       ::oFld:aDialogs[1]

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

METHOD lGenerate() CLASS TInfResFpc

   local cPed
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

               cPed := ::oPedCliL:cSerPed + Str( ::oPedCliL:nNumPed ) + ::oPedCliL:cSufPed

                   /*
                   Preguntamos si esta entre fechas
                   */

                     IF ::oPedCliT:Seek( cPed )

                        IF lChkSer( ::oPedCliT:CSERPED, ::aSer )                                   .AND.;
                           Eval( bValid )                                                          .AND.;
                           !( ::lExcCero .AND. ::oPedCliL:NPREDDIV == 0 )

                           /*
                           Comparativa entre fechas
                           */

                           IF ::oPedCliT:DFECPED >= ::dIniInf .AND. ::oPedCliT:DFECPED <= ::dFinInf

                              IF ::oDbf:Seek( ::oDbfArt:Familia )

                                 ::oDbf:Load()

                                 ::oDbf:NNUMCAJ    += ::oPedCliL:NCANPED
                                 ::oDbf:NNUMUNI    += NotCaja( ::oPedCliL:NCANPED ) * ::oPedCliL:NUNICAJA
                                 ::oDbf:NIMPART    += nTotLPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                                 ::oDbf:NIVAART    += Round( nTotLPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) * ::oPedCliL:NIVA / 100, ::nDerOut )
                                 ::oDbf:NIMPCOM    := nPreFamilia( ::oDbfArt:FAMILIA, ::aMes, ::lAno, ::oDbfFam:cAlias )
                                 ::oDbf:NIMPDES    := ::oDbf:NNUMUNI - ::oDbf:NIMPCOM
                                 ::oDbf:NPREMED    := ::oDbf:NIMPART / ::oDbf:NNUMUNI

                                 ::oDbf:Save()

                              ELSE

                                 ::oDbf:Append()
                                 ::oDbf:Blank()

                                 ::oDbf:cCodFam    := ::oDbfArt:Familia
                                 ::oDbf:CNOMFAM    := RetFamilia( ::oDbfArt:Familia, ::oDbfFam:cAlias )
                                 ::oDbf:NNUMCAJ    := ::oPedCliL:NCANPED
                                 ::oDbf:NNUMUNI    := NotCaja( ::oPedCliL:NCANPED ) * ::oPedCliL:NUNICAJA
                                 ::oDbf:NIMPART    := nTotLPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                                 ::oDbf:NIMPCOM    := nPreFamilia( ::oDbfArt:FAMILIA, ::aMes, ::lAno, ::oDbfFam:cAlias )
                                 ::oDbf:NIVAART    := Round( nTotLPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) * ::oPedCliL:NIVA / 100, ::nDerOut )
                                 ::oDbf:NIMPDES    := ::oDbf:NNUMUNI - ::oDbf:NIMPCOM
                                 ::oDbf:NPREMED    := ::oDbf:NIMPART / ::oDbf:NNUMUNI

                                 ::oDbf:Save()

                              END IF

                           END IF
                              /*
                              Acumulado
                              */

                           IF ::oDbf:Seek( ::oDbfArt:Familia )

                              ::oDbf:Load ()

                              ::oDbf:NACUCAJ    += ::oPedCliL:nCanPed
                              ::oDbf:NACUUNI    += NotCaja( ::oPedCliL:NCANPED ) * ::oPedCliL:NUNICAJA
                              ::oDbf:NACUIMP    += nTotLPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                              ::oDbf:Save()

                           ELSE

                              ::oDbf:Append()
                              ::oDbf:Blank()

                              ::oDbf:cCodFam    := ::oDbfArt:Familia
                              ::oDbf:CNOMFAM    := RetFamilia( ::oDbfArt:Familia, ::oDbfFam:cAlias )
                              ::oDbf:NACUCAJ    := ::oPedCliL:nCanPed
                              ::oDbf:NACUUNI    := NotCaja( ::oPedCliL:NCANPED ) * ::oPedCliL:NUNICAJA
                              ::oDbf:NACUIMP    := nTotLPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                              ::oDbf:Save()

                           END IF

                        END IF

                     END IF

                     ::oPedCliL:Skip()
                     ::oMtrInf:AutoInc( ::oDbfArt:OrdKeyNo() )

               END WHILE

          END IF

      END IF

      ::oDbfArt:Skip()

   END WHILE

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//