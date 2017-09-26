#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfPed FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oPedCliT    AS OBJECT
   DATA  oPedCliL    AS OBJECT
    
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Parcilamente", "Entregado", "Todos" }

   METHOD create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cNumDoc",   "C", 14, 0, {|| "@!" },        "Doc",            .f., "Documento",            8, .f. )
   ::AddField( "dFecDoc",   "D",  8, 0, {|| "@!" },        "Fecha",          .f., "Fecha del documento", 10, .f. )
   ::AddField( "dFecIni",   "D",  8, 0, {|| "@!" },        "Fecha inicio",   .f., "Fecha inicio del servicio", 10, .f. )
   ::AddField( "dFecFin",   "D",  8, 0, {|| "@!" },        "Fecha fin",      .f., "Fecha fin del servicio", 10, .f. )
   ::AddField( "cCodCli",   "C", 12, 0, {|| "@!" },        "Cliente",        .f., "Cod. cliente",         8, .f. )
   ::AddField( "cNomCli",   "C", 50, 0, {|| "@!" },        "Nombre",         .f., "Nom. cliente",         8, .f. )
   ::AddField( "cCodObr",   "C", 12, 0, {|| "@!" },        "Dirección",           .f., "Cod. dirección",            8, .f. )
   ::AddField( "cEstado",   "C",  9, 0, {|| "@!" },        "Estado",         .f., "Estado del doc.",     10, .f. )
   ::AddField( "cCodArt",   "C", 18, 0, {|| "@!" },        "Cod.",           .t., "Cod. artículo",       10, .f. )
   ::AddField( "cNomArt",   "C",100, 0, {|| "@!" },        "Artículo",       .t., "Nom. artículo",       40, .f. )
   ::FldPropiedades()
   ::AddField( "nCajas",    "N", 16, 6, {|| ::cPicOut },   cNombreCajas(),   .f., cNombreCajas(),        12, .f. )
   ::AddField( "nUnidades", "N", 16, 6, {|| ::cPicOut },   cNombreUnidades(),.f., cNombreUnidades(),     12, .f. )
   ::AddField( "nUniCaj",   "N", 16, 6, {|| ::cPicOut },   "Tot. " + cNombreUnidades(), .t., "Total " + cNombreUnidades(), 12, .f. )
   ::AddField( "nPreArt",   "N", 16, 6, {|| ::cPicOut },   "Precio",         .t., "Precio artículo",     12, .f. )
   ::AddField( "nBase",     "N", 16, 6, {|| ::cPicOut },   "Base",           .t., "Base",                12, .t. )
   ::AddField( "nIva",      "N", 16, 6, {|| ::cPicOut },   cImp(),            .t., cImp(),                 12, .t. )
   ::AddField( "nTotal",    "N", 16, 6, {|| ::cPicOut },   "Total",          .t., "Total",               12, .t. )

   ::AddTmpIndex( "cNumDoc", "cNumDoc" )

   ::AddGroup( {|| ::oDbf:cNumDoc }, {|| "Pedido: " + Rtrim( ::oDbf:cNumDoc )+ " - " + Dtoc( ::oDbf:dFecDoc ) + " Cliente:" + Rtrim( ::oDbf:cCodCli ) + "-" + Rtrim( ::oDbf:cNomCli ) + if( !Empty( ::oDbf:cCodObr), " Obra:" + Rtrim( ::oDbf:cCodObr ) , " " ) + " E:" + RTrim( ::oDbf:cEstado ) }, {|| Space(1) } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oPedCliT := TDataCenter():oPedCliT()

   DATABASE NEW ::oPedCliL PATH ( cPatEmp() ) FILE "PEDCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "PEDCLIL.CDX"

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

   ::oPedCliT := nil
   ::oPedCliL := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource ( cFld )

   local cEstado := "Todos"

   if !::StdResource( "INFPRESUPUESTOS" )
      return .f.
   end if

   /*
   Monta los almacenes de manera automatica
   */

   if !::oDefCliInf( 70, 71, 80, 81, , 910 )
      return .f.
   end if

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oPedCliT:Lastrec() )

   ::CreateFilter( aItmPedCli(), ::oPedCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead  := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                        {|| "Periodo  : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Clientes : " + if( ::lAllCli, "Todos", AllTrim( ::cCliOrg ) + " > " + AllTrim( ::cCliDes ) ) },;
                        {|| "Estado   : " + ::aEstado[ ::oEstado:nAt ] } }

   ::oPedCliT:OrdSetFocus( "dFecPed" )

   cExpHead          := "!lCancel "

   do case
      case ::oEstado:nAt == 1
         cExpHead    += ' .and. nEstado == 1'
      case ::oEstado:nAt == 2
         cExpHead    += ' .and. nEstado == 2'
      case ::oEstado:nAt == 3
         cExpHead    += ' .and. nEstado == 3'
   end case

   cExpHead          += ' .and. dFecPed >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecPed <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oPedCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oPedCliT:cFile ), ::oPedCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oPedCliT:OrdKeyCount() )

   ::oPedCliT:GoTop()

   while !::lBreak .and. !::oPedCliT:Eof()

      if lChkSer( ::oPedCliT:cSerPed, ::aSer )

         if ::oPedCliL:Seek( ::oPedCliT:cSerPed + Str( ::oPedCliT:nNumPed ) + ::oPedCliT:cSufPed )

            while ::oPedCliT:cSerPed + Str( ::oPedCliT:nNumPed ) + ::oPedCliT:cSufPed == ::oPedCliL:cSerPed + Str( ::oPedCliL:nNumPed ) + ::oPedCliL:cSufPed .AND. ! ::oPedCliL:eof()

               ::oDbf:Append()

               ::oDbf:cNumDoc     := AllTrim( ::oPedCliT:cSerPed ) + "/" + AllTrim( Str( ::oPedCliT:nNumPed ) ) + "/" + AllTrim( ::oPedCliT:cSufPed )
               ::oDbf:dFecDoc     := ::oPedCliT:dFecPed
               ::oDbf:dFecIni     := ::oPedCliT:dFecEntr
               ::oDbf:dFecFin     := ::oPedCliT:dFecSal
               ::oDbf:cCodCli     := ::oPedCliT:cCodCli
               ::oDbf:cNomCli     := ::oPedCliT:cNomCli
               ::oDbf:cCodObr     := ::oPedCliT:cCodObr

               do case
                  case ::oPedCliT:nEstado == 1
                     ::oDbf:cEstado  := "Pendiente"
                  case ::oPedCliT:nEstado == 2
                     ::oDbf:cEstado  := "Parcilamente"
                  case ::oPedCliT:nEstado == 3
                     ::oDbf:cEstado  := "Entregado"
               end if
               ::oDbf:cCodArt     := ::oPedCliL:cRef
               ::oDbf:cNomArt     := ::oPedCliL:cDetalle
               ::oDbf:cCodPr1     := ::oPedCliL:cCodPr1
               ::oDbf:cNomPr1     := retProp( ::oPedCliL:cCodPr1 )
               ::oDbf:cCodPr2     := ::oPedCliL:cCodPr2
               ::oDbf:cNomPr2     := retProp( ::oPedCliL:cCodPr2 )
               ::oDbf:cValPr1     := ::oPedCliL:cValPr1
               ::oDbf:cNomVl1     := retValProp( ::oPedCliL:cCodPr1 + ::oPedCliL:cValPr1 )
               ::oDbf:cValPr2     := ::oPedCliL:cValPr2
               ::oDbf:cNomVl2     := retValProp( ::oPedCliL:cCodPr2 + ::oPedCliL:cValPr2 )
               ::oDbf:nCajas      := ::oPedCliL:nCanPed
               ::oDbf:nUnidades   := ::oPedCliL:nUniCaja
               ::oDbf:nUniCaj     := nTotNPedCli( ::oPedCliL )
               ::oDbf:nPreArt     := nTotUPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nValDiv )
               ::oDbf:nBase       := nImpLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
               ::oDbf:nIva        := nIvaLPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nDecOut, ::nValDiv )
               ::oDbf:nTotal      := ::oDbf:nBase + ::oDbf:nIva

               ::oDbf:Save()

               ::oPedCliL:Skip()

            end while

         end if

      end if

      ::oPedCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oPedCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oPedCliT:cFile ) )

   ::oPedCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oPedCliL:cFile ) )

   ::oMtrInf:AutoInc( ::oPedCliT:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//