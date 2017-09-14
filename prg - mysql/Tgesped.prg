#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfGesPed FROM TInfGen

   DATA  lDesglose   AS LOGIC    INIT .t.
   DATA  oEstado     AS OBJECT
   DATA  oPedPrvL    AS OBJECT
   DATA  oPedCliT    AS OBJECT
   DATA  oPedCliL    AS OBJECT
   DATA  oPedCliR    AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oAlbPrvT    AS OBJECT
   DATA  oAlbPrvL    AS OBJECT
   DATA  oFacPrvT    AS OBJECT
   DATA  oFacPrvL    AS OBJECT
   DATA  oRctPrvL    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT
   DATA  oHisMov     AS OBJECT
   DATA  oAlbPrvL    AS OBJECT
   DATA  oFacRecL    AS OBJECT
   DATA  oProducL    AS OBJECT
   DATA  oProducM    AS OBJECT
   DATA  oObras      AS OBJECT
   DATA  oStock      AS OBJECT
   DATA  aEstado     AS ARRAY    INIT { "Pendiente", "Parcialmente", "Pendiente y parc.", "Entregado", "Todos" }
   DATA  dIniEnt                 INIT CtoD( "01/01/" + Str( Year( Date() ) ) )   
   DATA  dFinEnt                 INIT Date()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Create()

   METHOD lResource( cFld )

   METHOD lGenerate()

   METHOD cStkLibre()

   METHOD NewGroup()

   METHOD QuiGroup()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodArt", "C", 18, 0, {|| "@!" },           "Código",          .f., "Código artículo",                 12, .f. )
   ::AddField( "cNomArt", "C",100, 0, {|| "@!" },           "Artículo",        .f., "Nombre artículo",                 40, .f. )
   ::FldPropiedades()
   ::AddField( "cLote",   "C", 14, 0, ,                     "Lote",            .f., "Número de lote",                  10, .f. )
   ::AddField( "cCodCli", "C", 12, 0, {|| "@!" },           "Cod. cliente",    .t., "Código Cliente",                   9, .f. )
   ::AddField( "cNomCli", "C", 50, 0, {|| "@!" },           "Cliente",         .t., "Cliente",                         35, .f. )
   ::AddField( "cCodObr", "C",  3, 0, {|| "@!" },           "Cod.",            .t., "Código dirección",                      3, .f. )
   ::AddField( "cNomObr", "C", 20, 0, {|| "@!" },           "Dirección",            .t., "Dirección",                            20, .f. )
   ::AddField( "nPedIdo", "N", 16, 6, {|| MasUnd() },       "Pedido",          .t., "Pedido",                          12, .t. )
   ::AddField( "nPeso",   "N", 16, 6, {|| MasUnd() },       "Peso",            .f., "Peso",                            12, .f. )
   ::AddField( "nTotPeso","N", 16, 6, {|| MasUnd() },       "Total peso",      .f., "Total peso",                      12, .t. )
   ::AddField( "nVol",    "N", 16, 6, {|| MasUnd() },       "Volumen",         .f., "Volumen",                         12, .f. )
   ::AddField( "nTotVol", "N", 16, 6, {|| MasUnd() },       "Total Vol.",      .f., "Total volumen",                   12, .t. )
   ::AddField( "nSerVid", "N", 16, 6, {|| MasUnd() },       "Servido",         .t., "Servido",                         12, .t. )
   ::AddField( "nPenDie", "N", 13, 6, {|| MasUnd() },       "Pendiente",       .t., "Pendiente",                       12, .t. )
   ::AddField( "nResErv", "N", 16, 6, {|| MasUnd() },       "Resevado",        .t., "Reservado",                       12, .t. )
   ::AddField( "cNumDoc", "C", 14, 0, {|| "@!" },           "Pedido",          .t., "Número pedido",                   14, .f. )
   ::AddField( "dFecDoc", "D",  8, 0, {|| "@!" },           "Fecha",           .t., "Fecha pedido",                    12, .f. )
   ::AddField( "dFecEnt", "D",  8, 0, {|| "@!" },           "Entrega",         .t., "Fecha entrega",                   12, .f. )

   ::AddTmpIndex( "CCODART", "CCODART + CCODCLI + CCODPR1 + CCODPR2 + CVALPR1 + CVALPR2 + cLote" )

   ::AddGroup(    {|| ::oDbf:cCodArt }, {|| "Artículo  : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oDbfArt ) ) }, {|| ::cStkLibre() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oPedCliT := TDataCenter():oPedCliT()

   DATABASE NEW ::oPedCliL  PATH ( cPatEmp() )   FILE "PEDCLIL.DBF"   VIA ( cDriver() ) SHARED INDEX "PEDCLIL.CDX"

   DATABASE NEW ::oPedCliR  PATH ( cPatEmp() )   FILE "PEDCLIR.DBF"   VIA ( cDriver() ) SHARED INDEX "PEDCLIR.CDX"

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL  PATH ( cPatEmp() )   FILE "ALBCLIL.DBF"   VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   DATABASE NEW ::oAlbPrvT  PATH ( cPatEmp() )   FILE "ALBPROVT.DBF"  VIA ( cDriver() ) SHARED INDEX "ALBPROVT.CDX"

   DATABASE NEW ::oAlbPrvL  PATH ( cPatEmp() )   FILE "ALBPROVL.DBF"  VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"

   DATABASE NEW ::oFacPrvT  PATH ( cPatEmp() )   FILE "FACPRVT.DBF"   VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"

   DATABASE NEW ::oFacPrvL  PATH ( cPatEmp() )   FILE "FACPRVL.DBF"   VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"

   DATABASE NEW ::oRctPrvL  PATH ( cPatEmp() )   FILE "RctPrvL.DBF"   VIA ( cDriver() ) SHARED INDEX "RctPrvL.CDX"

   ::oFacCliT     := TDataCenter():oFacCliT()   

   DATABASE NEW ::oFacCliL  PATH ( cPatEmp() )   FILE "FACCLIL.DBF"   VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oTikCliT  PATH ( cPatEmp() )   FILE "TIKET.DBF"     VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL  PATH ( cPatEmp() )   FILE "TIKEL.DBF"     VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oObras    PATH ( cPatCli() )   FILE "OBRAST.DBF"    VIA ( cDriver() ) SHARED INDEX "OBRAST.CDX"

   DATABASE NEW ::oHisMov   PATH ( cPatEmp() )   FILE "HISMOV.DBF"    VIA ( cDriver() ) SHARED INDEX "HISMOV.CDX"

   DATABASE NEW ::oAlbPrvL  PATH ( cPatEmp() )   FILE "ALBPROVL.DBF"  VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"

   DATABASE NEW ::oFacRecL  PATH ( cPatEmp() )   FILE "FACRECL.DBF"   VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   DATABASE NEW ::oProducL  PATH ( cPatEmp() )   FILE "PROLIN.DBF"    VIA ( cDriver() ) SHARED INDEX "PROLIN.CDX"

   DATABASE NEW ::oProducM  PATH ( cPatEmp() )   FILE "PROMAT.DBF"    VIA ( cDriver() ) SHARED INDEX "PROMAT.CDX"

   DATABASE NEW ::oPedPrvL  PATH ( cPatEmp() )   FILE "PEDPROVL.DBF"  VIA ( cDriver() ) SHARED INDEX "PEDPROVL.CDX"

   ::oStock          := TStock():Create()
   if !::oStock:lOpenFiles()
      lOpen          := .f.
   end if

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oPedPrvL ) .and. ::oPedPrvL:Used()
      ::oPedPrvL:End()
   end if

   if !Empty( ::oPedCliT ) .and. ::oPedCliT:Used()
      ::oPedCliT:End()
   end if

   if !Empty( ::oPedCliL ) .and. ::oPedCliL:Used()
      ::oPedCliL:End()
   end if

   if !Empty( ::oPedCliR ) .and. ::oPedCliR:Used()
      ::oPedCliR:End()
   end if

   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if

   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if

   if !Empty( ::oObras ) .and. ::oObras:Used()
      ::oObras:End()
   end if

   if !Empty( ::oAlbPrvT ) .and. ::oAlbPrvT:Used()
      ::oAlbPrvT:End()
   end if

   if !Empty( ::oAlbPrvL ) .and. ::oAlbPrvL:Used()
      ::oAlbPrvL:End()
   end if

   if !Empty( ::oFacPrvT ) .and. ::oFacPrvT:Used()
      ::oFacPrvT:End()
   end if

   if !Empty( ::oFacPrvL ) .and. ::oFacPrvL:Used()
      ::oFacPrvL:End()
   end if

   if !Empty( ::oRctPrvL ) .and. ::oRctPrvL:Used()
      ::oRctPrvL:End()
   end if

   if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if

   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if

   if !Empty( ::oTikCliT ) .and. ::oTikCliT:Used()
      ::oTikCliT:End()
   end if

   if !Empty( ::oTikCliL ) .and. ::oTikCliL:Used()
      ::oTikCliL:End()
   end if

   if !Empty( ::oHisMov ) .and. ::oHisMov:Used()
      ::oHisMov:End()
   end if

   if !Empty( ::oAlbPrvL ) .and. ::oAlbPrvL:Used()
      ::oAlbPrvL:End()
   end if

   if !Empty( ::oFacRecL ) .and. ::oFacRecL:Used()
      ::oFacRecL:End()
   end if

   if !Empty( ::oFacPrvL ) .and. ::oFacPrvL:Used()
      ::oFacPrvL:End()
   end if

   if !Empty( ::oProducL ) .and. ::oProducL:Used()
      ::oProducL:End()
   end if

   if !Empty( ::oProducM ) .and. ::oProducM:Used()
      ::oProducM:End()
   end if

   if !Empty( ::oStock )
      ::oStock:End()
   end if

   ::oPedPrvL := nil
   ::oHisMov  := nil
   ::oAlbPrvT := nil
   ::oAlbPrvL := nil
   ::oFacPrvT := nil
   ::oFacPrvL := nil
   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oTikCliT := nil
   ::oTikCliL := nil
   ::oPedCliT := nil
   ::oPedCliL := nil
   ::oPedCliR := nil
   ::oAlbCliT := nil
   ::oAlbCliL := nil
   ::oObras   := nil
   ::oAlbPrvL := nil
   ::oFacRecL := nil
   ::oFacPrvL := nil
   ::oRctPrvL := nil
   ::oProducL := nil
   ::oProducM := nil
   ::oStock   := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cEstado  := "Todos"

   if !::StdResource( "INF_GEN10A" )
      return .f.
   end if

   /*
   Monta los articulos de manera automatica
   */

   if !::lDefArtInf( 110, 120, 130, 140, 800 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oPedCliT:Lastrec() )

   ::oDefExcInf( 204 )

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET ::dIniEnt;
		SPINNER ;
      ID       150 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET ::dFinEnt;
		SPINNER ;
      ID       160 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lDesglose ;
      ID       600 ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmPedCli(), ::oPedCliT:cAlias )

   ::bPreGenerate    := {|| ::NewGroup( ::lDesglose ) }
   ::bPostGenerate   := {|| ::QuiGroup( ::lDesglose ) }

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local dFecRes              := Ctod( "" )
   local nTotPed              := 0
   local nTotSer              := 0
   local nTotPdt              := 0
   local cCondicionCabecera   := ""
   local cCondicionLinea      := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                        {|| "Periodo : " + Dtoc( ::dIniInf )    + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Artículo: " + AllTrim( ::cArtOrg ) + " > " + AllTrim( ::cArtDes ) },;
                        {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ] } }

   ::oPedCliT:OrdSetFocus( "nNumPed" )
   ::oPedCliL:OrdSetFocus( "nNumPed" )

   /*
   Condiciones de cabecera-----------------------------------------------------
   */

   cCondicionCabecera         := 'dFecPed >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecPed <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   do case
      case ::oEstado:nAt == 1
         cCondicionCabecera   += '.and. nEstado == 1'
      case ::oEstado:nAt == 2
         cCondicionCabecera   += '.and. nEstado == 2'
      case ::oEstado:nAt == 3
         cCondicionCabecera   += '.and. ( nEstado == 1 .or. nEstado == 2 )'
      case ::oEstado:nAt == 4
         cCondicionCabecera   += '.and. nEstado == 3'
   end case

   if !Empty( ::oFilter:cExpresionFilter )
      cCondicionCabecera      += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oPedCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oPedCliT:cFile ), ::oPedCliT:OrdKey(), ( cCondicionCabecera ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oPedCliT:OrdKeyCount() )

   /*
   Condiciones de linea--------------------------------------------------------
   */

   cCondicionLinea            := '!lTotLin .and. !lControl .and. !lKitArt'

   if !::lAllArt
      cCondicionLinea         += '.and. Rtrim( cRef ) >= "' + Rtrim( ::cArtOrg ) + '" .and. Rtrim( cRef ) <= "' + Rtrim( ::cArtDes ) + '"'
   end if

   if ::lExcCero
      cCondicionLinea         += '.and. !Empty( nPreDiv )'
   end if

   ::oPedCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oPedCliL:cFile ), ( ::oPedCliL:OrdKey() ), ( cCondicionLinea ), , , , , , , , .t. )

   /*
   Nos movemos por las cabeceras de los pedidos a proveedores------------------
	*/

   ::oPedCliT:GoTop()

   while !::lBreak .and. !::oPedCliT:Eof()

      if lChkSer( ::oPedCliT:cSerPed, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oPedCliL:Seek( ::oPedCliT:cSerPed + Str( ::oPedCliT:nNumPed ) + ::oPedCliT:cSufPed )

            while ::oPedCliT:cSerPed + Str( ::oPedCliT:nNumPed ) + ::oPedCliT:cSufPed == ::oPedCliL:cSerPed + Str( ::oPedCliL:nNumPed ) + ::oPedCliL:cSufPed .and. !::oPedCliL:eof()

               if ( !Empty( ::oPedCliL:dFecha ) .and. ( ::oPedCliL:dFecha >= ::dIniEnt .and. ::oPedCliL:dFecha <= ::dFinEnt ) ) .or. ;
                  ( Empty( ::oPedCliL:dFecha ) .and. ( ::oPedCliT:dFecEnt >= ::dIniEnt .and. ::oPedCliT:dFecEnt <= ::dFinEnt  ) )

                  nTotPed        := Round( nTotNPedCli( ::oPedCliL:cAlias ), DecUnd() )
                  dFecRes        := dFecPdtRec( ::oPedCliL:cSerPed + Str( ::oPedCliL:nNumPed ) + ::oPedCliL:cSufPed, ::oPedCliL:cRef, ::oPedCliL:cValPr1, ::oPedCliL:cValPr2, ::oPedCliR:cAlias )
                  nTotSer        := Round( nUnidadesRecibidasAlbaranesClientes( ::oPedCliL:cSerPed + Str( ::oPedCliL:nNumPed ) + ::oPedCliL:cSufPed, ::oPedCliL:cRef, , , ::oAlbCliL:cAlias ), DecUnd() )
                  nTotPdt        := Round( nUnidadesReservadasEnPedidosCliente( ::oPedCliL:cSerPed + Str( ::oPedCliL:nNumPed ) + ::oPedCliL:cSufPed, ::oPedCliL:cRef, ::oPedCliL:cValPr1, ::oPedCliL:cValPr2, ::oPedCliR:cAlias ), DecUnd() )

                  if nTotPdt != 0 .and. nTotSer > nTotPdt
                     nTotPdt     := Min( nTotSer, nTotPdt )
                  end if

                  if ::oEstado:nAt == 5 .or. ( nTotPed - nTotSer != 0 )

                     ::oDbf:Append()
                     ::oDbf:Blank()

                     ::oDbf:cCodArt    := ::oPedCliL:cRef
                     ::oDbf:cNomArt    := ::oPedCliL:cDetalle
                     ::oDbf:cCodPr1    := ::oPedCliL:cCodPr1
                     ::oDbf:cNomPr1    := retProp( ::oPedCliL:cCodPr1 )
                     ::oDbf:cCodPr2    := ::oPedCliL:cCodPr2
                     ::oDbf:cNomPr2    := retProp( ::oPedCliL:cCodPr2 )
                     ::oDbf:cValPr1    := ::oPedCliL:cValPr1
                     ::oDbf:cNomVl1    := retValProp( ::oPedCliL:cCodPr1 + ::oPedCliL:cValPr1 )
                     ::oDbf:cValPr2    := ::oPedCliL:cValPr2
                     ::oDbf:cNomVl2    := retValProp( ::oPedCliL:cCodPr2 + ::oPedCliL:cValPr2 )
                     ::oDbf:cLote      := ::oPedCliL:cLote
                     ::oDbf:cCodCli    := ::oPedCliT:cCodCli
                     ::oDbf:cNomCli    := ::oPedCliT:cNomCli
                     ::oDbf:cCodObr    := ::oPedCliT:cCodObr
                     ::oDbf:cNomObr    := RetObras( ::oPedCliT:cCodCli, ::oPedCliT:cCodObr, ::oObras:cAlias )
                     ::oDbf:nPedIdo    := nTotPed
                     ::oDbf:nSerVid    := nTotSer
                     ::oDbf:nPenDie    := nTotPed - nTotSer
                     ::oDbf:nResErv    := NotMinus( nTotPdt )
                     ::oDbf:cNumDoc    := ::oPedCliT:cSerPed + "/" + AllTrim( Str( ::oPedCliT:nNumPed ) ) + ::oPedCliT:cSufPed
                     ::oDbf:dFecDoc    := ::oPedCliT:dFecPed

                     if Empty( ::oPedCliL:dFecha )
                        ::oDbf:dFecEnt := ::oPedCliT:dFecEnt
                     else
                        ::oDbf:dFecEnt := ::oPedCliL:dFecha
                     end if

                     ::oDbf:nPeso      := oRetFld( ::oPedCliL:cRef, ::oDbfArt, "nPesoKg" )
                     ::oDbf:nTotPeso   := nTotPed * ::oDbf:nPeso
                     ::oDbf:nVol       := oRetFld( ::oPedCliL:cRef, ::oDbfArt, "nVolumen" )
                     ::oDbf:nTotVol    := nTotPed * ::oDbf:nVol

                     ::oDbf:Save()

                  end if

               end if

            ::oPedCliL:Skip()

            ::oMtrInf:AutoInc()

            end while

         end if

      end if

      ::oPedCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oPedCliT:LastRec() )

   ::oPedCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oPedCliT:cFile ) )

   ::oPedCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oPedCliL:cFile ) )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD cStkLibre()

   local cCodArt     := ::oReport:aGroups[ 1 ]:cValue
   local nTotEntStk  := ::oStock:nStockArticulo( cCodArt )
   local nTotResStk  := nTotRStk( cCodArt, ::oPedCliT:cAlias, ::oPedCliR:cAlias, ::oAlbCliT:cAlias, ::oAlbCliL:cAlias )

RETURN ( "Real : " + AllTrim( Trans( nTotEntStk, MasUnd() ) ) + " Libre : " + AllTrim( Trans( nTotEntStk - nTotResStk , MasUnd() ) ) )

//---------------------------------------------------------------------------//

METHOD NewGroup( lDesPrp )

   if lDesPrp
      ::AddGroup( {|| ::oDbf:cCodArt + ::oDbf:cCodCli + ::oDbf:cCodPr1 + ::oDbf:cCodPr2 + ::oDbf:cValPr1 + ::oDbf:cValPr2 + ::oDbf:cLote },;
      {||   if( !Empty( ::oDbf:cValPr1 ), AllTrim( ::oDbf:cNomPr1 ) + ": " + AllTrim( ::oDbf:cNomVl1 ) + " - ", "" ) + ;
            if( !Empty( ::oDbf:cValPr2 ), AllTrim( ::oDbf:cNomPr2 ) + ": " + AllTrim( ::oDbf:cNomVl2 ) + " - ", "" ) + ;
            if( !Empty( ::oDbf:cLote ), "Lote:" + AllTrim( ::oDbf:cLote ), Space(1) ) },;
      {|| Space(1) } )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD QuiGroup( lDesPrp )

   if lDesPrp
      ::DelGroup()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//