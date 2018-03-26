#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfOrdCar FROM TInfGen

   DATA  nOrdDes
   DATA  nOrdHas
   DATA  cSufDes
   DATA  cSufHas
   DATA  oOrdCarT
   DATA  oOrdCarL
   DATA  oDbfAge
   DATA  oDbfArt
   DATA  oTrans
   DATA  lDesglose   AS LOGIC INIT .f.

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "nNumOrd", "N",  9, 0, {|| "@!" },      "Número",           .f., "Número de la orden",     9 )
   ::AddField( "cSufOrd", "C",  2, 0, {|| "@!" },      "Suf.",             .f., "Sufijo de la orden",     2 )
   ::AddField( "cCodTrn", "C",  9, 0, {|| "@!" },      "Cod. Trn.",        .f., "Cod. transportista",     6 )
   ::AddField( "cNomTrn", "C", 20, 0, {|| "@!" },      "Transportista",    .f., "Nombre transportista",  20 )
   ::AddField( "cCodAge", "C",  3, 0, {|| "@!" },      "Cod. Age.",        .f., "Código agente",         20 )
   ::AddField( "cNomAge", "C", 30, 0, {|| "@!" },      "Agente",           .f., "Nombre agente",         20 )
   ::AddField( "dFecOrd", "D",  8, 0, {|| "@!" },      "Fecha",            .f., "Fecha del orden",        8 )
   ::AddField( "nTara",   "N", 16, 6, {|| MasUnd() },  "TARA",             .f., "Tara",                  12 )
   ::AddField( "cNumAlb", "C", 12, 0, {|| "@R #/#########/##"}, "Albarán", .f., "Albarán",               16 )
   ::AddField( "cCodArt", "C", 18, 0, {|| "@!" },      "Código",           .t., "Código",                14 )
   ::AddField( "cNomArt", "C",250, 0, {|| "" },        "Artículo",         .t., "Artículo",              40 )
   ::AddField( "cValPr1", "C", 20, 0, {|| "" },        "Prop. 1",          .t., "Propiedad 1",           12 )
   ::AddField( "cValPr2", "C", 20, 0, {|| "" },        "Prop. 2",          .t., "Propiedad 2",           12 )
   ::AddField( "cLote",   "C", 14, 0, {|| "" },        "Lote",             .t., "Lote",                  15 )
   ::AddField( "nCajEnt", "N", 19, 6, {|| MasUnd() },  "Caj.",             .f., "Cajas",                 12 )
   ::AddField( "nUniDad", "N", 19, 6, {|| MasUnd() },  "Und.",             .f., "Unidades",              12 )
   ::AddField( "nTotUni", "N", 19, 6, {|| MasUnd() },  "Tot. und.",        .t., "Total unidades",        12 )
   ::AddField( "nPeso",   "N", 19, 6, {|| MasUnd() },  "Peso",             .f., "Peso",                  12 )
   ::AddField( "nTotPes", "N", 19, 6, {|| MasUnd() },  "Tot. peso",        .t., "Total peso",            12 )

   ::AddTmpIndex( "cCodTrn", "Str( nNumOrd ) + cSufOrd + cCodArt" )

   ::AddGroup( {|| Str( ::oDbf:nNumOrd ) + ::oDbf:cSufOrd }, {|| "Orden : " + AllTrim( Str( ::oDbf:nNumOrd ) ) + "/" + AllTrim( ::oDbf:cSufOrd ) + " Transportista : " + AllTrim( ::oDbf:cNomTrn ) + " Tara : " + AllTrim( Trans( ::oDbf:nTara, "@EZ 999,999.99" ) ) }, {|| "Total orden..." } )

   ::oOrdCarT  := ::xOthers[ 1 ]
   ::oOrdCarL  := ::xOthers[ 2 ]

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   DATABASE NEW ::oDbfDiv PATH ( cPatDat() ) FILE "DIVISAS.DBF"  VIA ( cDriver() ) SHARED INDEX "DIVISAS.CDX"

   DATABASE NEW ::oDbfArt PATH ( cPatEmp() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   DATABASE NEW ::oDbfAge PATH ( cPatEmp() ) FILE "AGENTES.DBF"  VIA ( cDriver() ) SHARED INDEX "AGENTES.CDX"

   ::oTrans    := TTrans():New( cPatEmp() )
   ::oTrans:OpenFiles()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbfDiv ) .and. ::oDbfDiv:Used()
      ::oDbfDiv:End()
   end if

   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   if !Empty( ::oDbfAge ) .and. ::oDbfAge:Used()
      ::oDbfAge:End()
   end if

   if !Empty( ::oTrans )
      ::oTrans:End()
   end if

   ::oDbfDiv  := nil
   ::oDbfArt  := nil
   ::oDbfAge  := nil
   ::oTrans   := nil

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   ::nOrdDes      := ::oOrdCarT:nNumOrd
   ::nOrdHas      := ::oOrdCarT:nNumOrd
   ::cSufDes      := ::oOrdCarT:cSufOrd
   ::cSufHas      := ::oOrdCarT:cSufOrd

   ::lDefFecInf   := .f.
   ::lDefDivInf   := .f.
   ::lDefSerInf   := .f.

   if !::StdResource( "INF_GENORDCAR" )
      return .f.
   end if

   ::lLoadDivisa()

   /*
	Llamada a la funcion que activa la caja de dialogo
	*/

   REDEFINE GET ::nOrdDes ;
      PICTURE  "999999999" ;
      ID       100 ;
      SPINNER ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET ::cSufDes ;
      ID       110 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET ::nOrdHas ;
      PICTURE  "999999999" ;
      ID       120 ;
      SPINNER ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET ::cSufHas ;
      ID       130 ;
      OF       ::oFld:aDialogs[1]

   ::oMtrInf:SetTotal( ::oOrdCarT:Lastrec() )

   ::CreateFilter( , ::oOrdCarT )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local nKlgEnt  := 0
   local cExpHead := ""

   ::oDlg:Disable()

   ::oDbf:Zap()
   ::oOrdCarT:GetStatus()

   ::aHeader      := {  {|| "Fecha : " + Dtoc( Date() ) },;
                        {|| "Rango : " + Alltrim( Str( ::nOrdDes ) ) + "/" + AllTrim( ::cSufDes ) + " > " + Alltrim( Str( ::nOrdHas ) ) + "/" + Alltrim( ::cSufHas ) } }

   ::oOrdCarT:OrdSetFocus( "NNUMORD" )
   ::oOrdCarL:OrdSetFocus( "NNUMORD" )

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       := ::oFilter:cExpresionFilter
   else
      cExpHead       := '.t.'
   end if

   ::oOrdCarT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oOrdCarT:cFile ), ::oOrdCarT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   if ::oOrdCarT:Seek( Str( ::nOrdDes ) + ::cSufDes )

      while Str( ::oOrdCarT:nNumOrd ) + ::oOrdCarT:cSufOrd <= Str( ::nOrdHas ) + ::cSufHas .and. !::oOrdCarT:eof()

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oOrdCarL:Seek( Str( ::oOrdCarT:nNumOrd ) + ::oOrdCarT:cSufOrd )

            while Str( ::oOrdCarT:nNumOrd ) + ::oOrdCarT:cSufOrd == Str( ::oOrdCarL:nNumOrd ) + ::oOrdCarL:cSufOrd .and.;
                  !::oOrdCarL:Eof()

                  ::oDbf:Append()

                  ::oDbf:nNumOrd    := ::oOrdCarT:nNumOrd
                  ::oDbf:cSufOrd    := ::oOrdCarT:cSufOrd
                  ::oDbf:cCodTrn    := ::oOrdCarT:cCodTrn
                  ::oDbf:cNomTrn    := oRetFld( ::oOrdCarT:cCodTrn, ::oTrans:oDbf )
                  ::oDbf:cCodAge    := ::oOrdCarT:cCodAge
                  ::oDbf:cNomAge    := oRetFld( ::oOrdCarT:cCodAge, ::oDbfAge )
                  ::oDbf:dFecOrd    := ::oOrdCarT:dFecOrd
                  ::oDbf:nTara      := ::oOrdCarT:nKgsTrn
                  ::oDbf:cCodArt    := ::oOrdCarL:cRef
                  ::oDbf:cNomArt    := ::oOrdCarL:cDetalle
                  ::oDbf:cValPr1    := ::oOrdCarL:cValPr1
                  ::oDbf:cValPr2    := ::oOrdCarL:cValPr2
                  ::oDbf:cLote      := ::oOrdCarL:cLote
                  ::oDbf:nCajEnt    := ::oOrdCarL:nCajOrd
                  ::oDbf:nUniDad    := ::oOrdCarL:nUniOrd
                  ::oDbf:nTotUni    := NotCaja( ::oOrdCarL:nCajOrd ) * ::oOrdCarL:nUniOrd
                  ::oDbf:nPeso      := ::oOrdCarL:nPeso
                  ::oDbf:nTotPes    := NotCaja( ::oOrdCarL:nCajOrd ) * ::oOrdCarL:nUniOrd * ::oOrdCarL:nPeso
                  ::oDbf:cNumAlb    := ::oOrdCarL:cNumAlb

                  ::oDbf:Save()

               ::oOrdCarL:Skip()

            end  while

         end if

         ::oOrdCarT:Skip()

         ::oMtrInf:AutoInc( ::oOrdCarT:OrdKeyNo() )

      end while

   end if

   ::oOrdCarT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oOrdCarT:cFile ) )

   ::oMtrInf:AutoInc( ::oOrdCarT:LastRec() )

   ::oOrdCarT:SetStatus()

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//