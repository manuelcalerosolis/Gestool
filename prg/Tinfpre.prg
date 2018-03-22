#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfPre FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oSitua      AS OBJECT
   DATA  cSitua      AS CHARACTER     INIT "Todas"
   DATA  oPreCliT    AS OBJECT
   DATA  oPreCliL    AS OBJECT
   Data  oDbfObr     AS OBJECT
    
   DATA  oOrden      AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Aceptado", "Todos" }
   DATA  aSitua      AS ARRAY    INIT  { "Todas", "En curso", "En estudio", "Finalizado", "A revisar", "Aceptado", "Rechazado", "Espera", "Enviado", "Pdte. envio" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

   Method ImprimeInicioGrupo()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cNumDoc",   "C", 14, 0, {|| "@!" },        "Doc",            .f., "Documento",            8, .f. )
   ::AddField( "dFecDoc",   "D",  8, 0, {|| "@!" },        "Fecha",          .f., "Fecha del documento", 10, .f. )
   ::AddField( "cCodCli",   "C", 12, 0, {|| "@!" },        "Cliente",        .f., "Cod. cliente",         8, .f. )
   ::AddField( "cNomCli",   "C", 50, 0, {|| "@!" },        "Nombre",         .f., "Nom. cliente",         8, .f. )
   ::AddField( "cCodObr",   "C", 12, 0, {|| "@!" },        "Dirección",           .f., "Cod. dirección",            8, .f. )
   ::AddField( "cEstado",   "C",  9, 0, {|| "@!" },        "Estado",         .f., "Estado del doc.",     10, .f. )
   ::AddField( "cSituac",   "C", 20, 0, {|| "@!" },        "Situac.",        .f., "Situación del doc.",  10, .f. )
   ::AddField( "cRetPor",   "C",100, 0, {|| "@!" },        "Retirado por",   .f., "Retirado por",        70, .f. )
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
   ::AddTmpIndex( "dFecDoc", "dToc( dFecDoc )" )
   ::AddTmpIndex( "cCodCli", "cCodCli" )
   ::AddTmpIndex( "cNomCli", "cNomCli" )

   ::AddGroup( {|| ::oDbf:cNumDoc }, {|| if( !Empty( ::oDbf:cCodObr), " Obra: " + Rtrim( ::oDbf:cCodObr ) + " - " + AllTrim( retObras( ::oDbf:cCodCli, ::oDbf:cCodObr, ::oDbfObr:cAlias ) ), "" ) +;
                                         if( !Empty( ::oDbf:cRetPor), " Contacto: " + Rtrim( ::oDbf:cRetPor ), "" ) + ;
                                         " Estado:" + RTrim( ::oDbf:cEstado ) + ;
                                         if( !Empty( ::oDbf:cSituac ), " Situación:" + RTrim( ::oDbf:cSituac ), "" ) },;
                                     {|| Space(1) }  )

   /*
   Creamos la cabcera del listado----------------------------------------------
   */

   ::aHeader      := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                        {|| "Periodo   : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Clientes  : " + if( ::lAllCli, "Todos", AllTrim( ::cCliOrg ) + " > " + AllTrim( ::cCliDes ) ) },;
                        {|| "Estado    : " + ::aEstado[ ::oEstado:nAt ] },;
                        {|| "Situación : " + ::aSitua[ ::oSitua:nAt ] } }

   ::bStartGroup  := {| oGroup | ::ImprimeInicioGrupo( oGroup ) }


RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oPreCliT  := TDataCenter():oPreCliT()

   DATABASE NEW ::oPreCliL PATH ( cPatEmp() ) FILE "PRECLIL.DBF" VIA ( cDriver() ) SHARED INDEX "PRECLIL.CDX"

   DATABASE NEW ::oDbfObr  PATH ( cPatCli() ) FILE "OBRAST.DBF"  VIA ( cDriver() ) SHARED INDEX "OBRAST.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oPreCliT ) .and. ::oPreCliT:Used()
      ::oPreCliT:End()
   end if
   if !Empty( ::oPreCliL ) .and. ::oPreCliL:Used()
      ::oPreCliL:End()
   end if
   if !Empty( ::oDbfObr ) .and. ::oDbfObr:Used()
      ::oDbfObr:End()
   end if

   ::oDbfObr  := nil
   ::oPreCliT := nil
   ::oPreCliL := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource ( cFld )

   local cOrden   := "Número"
   local cEstado  := "Todos"

   if !::StdResource( "INFPRESUPUESTOSB" )
      return .f.
   end if

   /*
   Monta los almacenes de manera automatica
   */

   if !::oDefCliInf( 70, 71, 80, 81, , 910 )
      return .f.
   end if

   REDEFINE COMBOBOX ::oOrden ;
      VAR      cOrden ;
      ID       217 ;
      ITEMS    { "Número", "Fecha", "Código cliente", "Nombre cliente" } ;
      OF       ::oFld:aDialogs[1]

   REDEFINE COMBOBOX ::oSitua ;
      VAR      ::cSitua ;
      ID       219 ;
      ITEMS    ::aSitua ;
      OF       ::oFld:aDialogs[1]

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmPreCli(), ::oPreCliT:cAlias )

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oPreCliT:Lastrec() )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpresion  := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::oPreCliT:OrdSetFocus( "dFecPre" )

   do case
      case ::oEstado:nAt == 1
         cExpresion  := '!lEstado .and. dFecPre >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecPre <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 2
         cExpresion  := 'lEstado .and. dFecPre >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecPre <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 3
         cExpresion  := 'dFecPre >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecPre <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   end case

   /*if ::cSitua != "Todas"
      cExpresion     += ' .and. Rtrim( cSituac ) == "' + Rtrim( ::cSitua ) + '"'
   end if*/

   cExpresion        += " .and. !Empty( cCodCli )"

   if !::lAllCli
      cExpresion     += " .and. cCodCli >= '" + Alltrim( ::cCliOrg ) + "' .and. cCodCli <= '" + Alltrim( ::cCliDes ) + "'"
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpresion     += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oPreCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oPreCliT:cFile ), ::oPreCliT:OrdKey(), ( cExpresion ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oPreCliT:OrdKeyCount() )

   ::oPreCliT:GoTop()

   while !::lBreak .and. !::oPreCliT:Eof()

      if lChkSer( ::oPreCliT:cSerPre, ::aSer )

         if ::oPreCliL:Seek( ::oPreCliT:cSerPre + Str( ::oPreCliT:nNumPre ) + ::oPreCliT:cSufPre )

            while ::oPreCliT:cSerPre + Str( ::oPreCliT:nNumPre ) + ::oPreCliT:cSufPre == ::oPreCliL:cSerPre + Str( ::oPreCliL:nNumPre ) + ::oPreCliL:cSufPre .AND. ! ::oPreCliL:eof()

               if ::cSitua == "Todas" .or. Rtrim( ::oPreCliT:cSituac ) == ::cSitua

                  ::oDbf:Append()

                  ::oDbf:cNumDoc     := AllTrim( ::oPreCliT:cSerPre ) + "/" + AllTrim( Str( ::oPreCliT:nNumPre ) ) + "/" + AllTrim( ::oPreCliT:cSufPre )
                  ::oDbf:dFecDoc     := ::oPreCliT:dFecPre
                  ::oDbf:cCodCli     := ::oPreCliT:cCodCli
                  ::oDbf:cNomCli     := ::oPreCliT:cNomCli
                  ::oDbf:cCodObr     := ::oPreCliT:cCodObr
                  ::oDbf:cRetPor     := ::oPreCliT:cRetPor
                  if !::oPreCliT:lEstado
                     ::oDbf:cEstado  := "Pendiente"
                  else
                     ::oDbf:cEstado  := "Aceptado"
                  end if
                  ::oDbf:cSituac     := ::oPreCliT:cSituac
                  ::oDbf:cCodArt     := ::oPreCliL:cRef
                  ::oDbf:cNomArt     := ::oPreCliL:cDetalle
                  ::oDbf:cCodPr1     := ::oPreCliL:cCodPr1
                  ::oDbf:cNomPr1     := retProp( ::oPreCliL:cCodPr1 )
                  ::oDbf:cCodPr2     := ::oPreCliL:cCodPr2
                  ::oDbf:cNomPr2     := retProp( ::oPreCliL:cCodPr2 )
                  ::oDbf:cValPr1     := ::oPreCliL:cValPr1
                  ::oDbf:cNomVl1     := retValProp( ::oPreCliL:cCodPr1 + ::oPreCliL:cValPr1 )
                  ::oDbf:cValPr2     := ::oPreCliL:cValPr2
                  ::oDbf:cNomVl2     := retValProp( ::oPreCliL:cCodPr2 + ::oPreCliL:cValPr2 )
                  ::oDbf:nCajas      := ::oPreCliL:nCanPre
                  ::oDbf:nUnidades   := ::oPreCliL:nUniCaja
                  ::oDbf:nUniCaj     := nTotNPreCli( ::oPreCliL )
                  ::oDbf:nPreArt     := nTotUPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nBase       := nImpLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nIva        := nIvaLPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotal      := ::oDbf:nBase + ::oDbf:nIva

                  ::oDbf:Save()

               end if

               ::oPreCliL:Skip()

            end while

         end if

      end if

      ::oPreCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oPreCliT:LastRec() )

   ::oPreCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oPreCliT:cFile ) )

   ::oDbf:OrdSetFocus( ::oOrden:nAt )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

Method ImprimeInicioGrupo( oGroup )

   local cText    := "Presupuesto: " + Rtrim( ::oDbf:cNumDoc )+ " - " + Dtoc( ::oDbf:dFecDoc )

   cText          += " Cliente:" + Rtrim( ::oDbf:cCodCli ) + "-" + Rtrim( ::oDbf:cNomCli )

   ::oReport:StartLine()
   ::oReport:oDevice:Say(  ::oReport:nRow ,;
                           ::oReport:nMargin ,;
                           cText ,;
                           ::oReport:aFont[ Eval( oGroup:bHeadFont ) ] ,;
                           nil ,;
                           ::oReport:aClrText[ Eval( oGroup:bHeadFont ) ], 2 )
   ::oReport:EndLine()

Return nil

//---------------------------------------------------------------------------//