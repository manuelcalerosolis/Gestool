#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TRenPre FROM TInfPArt

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  lCosAct     AS LOGIC    INIT .f.
   DATA  oPreCliT    AS OBJECT
   DATA  oPreCliL    AS OBJECT
   DATA  oEstado     AS OBJECT
   DATA  oDbfArt     AS OBJECT
    
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Aceptado", "Todos" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()


END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cNumDoc", "C", 14, 0, {|| "@R #/#########/##" }, "Documento",         .t., "Documento",             12, .f. )
   ::AddField( "dFecDoc", "D",  8, 0, {|| "@!" },                "Fecha",             .t., "Fecha",                 10, .f. )
   ::AddField( "cCodCli", "C", 12, 0, {|| "@!" },                "C�d. cli.",         .t., "Cod. Cliente",           8, .f. )
   ::AddField( "cNomCli", "C", 50, 0, {|| "@!" },                "Cliente",           .t., "Nom. Cliente",          30, .f. )
   ::AddField( "nTotCaj", "N", 16, 6, {|| MasUnd() },            cNombreCajas(),      .f., cNombreCajas(),          12, .t. )
   ::AddField( "nTotUni", "N", 16, 6, {|| MasUnd() },            cNombreUnidades(),   .t., cNombreUnidades(),       12, .t. )
   ::AddField( "nTotImp", "N", 16, 6, {|| ::cPicImp },           "Tot. importe",      .t., "Tot. importe",          12, .t. )
   ::AddField( "nTotPes", "N", 16, 6, {|| MasUnd() },            "Tot. peso",         .f., "Total peso",            12, .t. )
   ::AddField( "nPreKgr", "N", 16, 6, {|| ::cPicImp },           "Pre. Kg.",          .f., "Precio kilo",           12, .f. )
   ::AddField( "nTotVol", "N", 16, 6, {|| MasUnd() },            "Tot. volumen",      .f., "Total volumen",         12, .t. )
   ::AddField( "nPreVol", "N", 16, 6, {|| ::cPicImp },           "Pre. vol.",         .f., "Precio volumen",        12, .f. )
   ::AddField( "nTotCos", "N", 16, 6, {|| ::cPicImp },           "Tot. costo",        .t., "Total costo",           12, .t. )
   ::AddField( "nDtoAtp", "N", 16, 6, {|| ::cPicOut },           "Dto. Atipico",      .f., "Importe dto. atipico",  12, .t. )
   ::AddField( "nMarGen", "N", 16, 6, {|| ::cPicOut },           "Margen",            .t., "Margen",                12, .t. )
   ::AddField( "nRenTab", "N", 16, 6, {|| ::cPicOut },           "%Rent.",            .t., "Rentabilidad",          12, .f. )
   ::AddField( "nPreMed", "N", 16, 6, {|| ::cPicImp },           "Precio medio",      .f., "Precio medio",          12, .f. )
   ::AddField( "nCosMed", "N", 16, 6, {|| ::cPicImp },           "Costo medio",       .t., "Costo medio",           12, .f. )

   ::AddTmpIndex( "cNumDoc", "cNumDoc" )

   ::dIniInf := GetSysDate()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TRenPre

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfArt  PATH ( cPatEmp() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

    

   ::oPreCliT  := TDataCenter():oPreCliT()

   DATABASE NEW ::oPreCliL PATH ( cPatEmp() ) FILE "PRECLIL.DBF" VIA ( cDriver() ) SHARED INDEX "PRECLIL.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TRenPre

   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if
    
   if !Empty( ::oPreCliT ) .and. ::oPreCliT:Used()
      ::oPreCliT:End()
   end if
   if !Empty( ::oPreCliL ) .and. ::oPreCliL:Used()
      ::oPreCliL:End()
   end if

   ::oDbfArt  := nil
    
   ::oPreCliT := nil
   ::oPreCliL := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld ) CLASS TRenPre

   local cEstado := "Todos"

   if !::StdResource( "INFRENARTC" )
      return .f.
   end if

   /*
   Monta los Clientes de manera automatica
   */

   if !::oDefCliInf( 70, 80, 90, 100, , 600 )
      return .f.
   end if

   ::oDefExcInf( 204 )

   REDEFINE CHECKBOX ::lExcMov ;
      ID       ( 203 );
      OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lCosAct ;
      ID       ( 205 );
      OF       ::oFld:aDialogs[1]

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmPreCli(), ::oPreCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TRenPre

   local nTotUni     := 0
   local nTotImpUni  := 0
   local nTotCosUni  := 0
   local nTotPes     := 0
   local nTotVol     := 0
   local nTotCaj     := 0
   local cExpHead    := ""
   local nImpDtoAtp  := 0

   ::aHeader         := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                           {|| "Periodo  : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                           {|| "Cliente  : " + if( ::lAllCli, "Todos", AllTrim ( ::cCliOrg ) + " > " + AllTrim ( ::cCliDes ) ) },;
                           {|| "Estado   : " + ::aEstado[ ::oEstado:nAt ] } }

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::oPreCliT:OrdSetFocus( "dFecPre" )

   do case
      case ::oEstado:nAt == 1
         cExpHead    := '!lEstado .and. dFecPre >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecPre <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 2
         cExpHead    := 'lEstado.and. dFecPre >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecPre <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      otherwise
         cExpHead    := 'dFecPre >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecPre <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   end case

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oPreCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oPreCliT:cFile ), ::oPreCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oPreCliT:OrdKeyCount() )

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oPreCliT:Lastrec() )

   ::oPreCliT:GoTop()

   while !::lBreak .and. !::oPreCliT:Eof()

      if lChkSer( ::oPreCliT:cSerPre, ::aSer )

         nTotUni     := 0
         nTotImpUni  := 0
         nTotCosUni  := 0
         nTotPes     := 0
         nTotVol     := 0
         nTotCaj     := 0

         if ::oPreCliL:Seek( ::oPreCliT:cSerPre + Str( ::oPreCliT:nNumPre ) + ::oPreCliT:cSufPre )

            while ::oPreCliL:cSerPre + Str( ::oPreCliL:nNumPre ) + ::oPreCliL:cSufPre == ::oPreCliT:cSerPre + Str( ::oPreCliT:nNumPre ) + ::oPreCliT:cSufPre

               if !( ::oPreCliL:lKitChl )                                                              .AND.;
                  !( ::oPreCliL:lTotLin )                                                              .AND.;
                  !( ::oPreCliL:lControl )                                                             .AND.;
                  !( ::lExcMov .AND. ( nTotNPreCli( ::oPreCliL:cAlias ) == 0 ) )

                  nTotUni              += nTotNPreCli( ::oPreCliL:cAlias )
                  nTotImpUni           += nImpLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut )
                  nTotPes              += nTotUni * oRetFld( ::oPreCliL:cRef, ::oDbfArt, "nPesoKg" )
                  nTotVol              += nTotUni * oRetFld( ::oPreCliL:cRef, ::oDbfArt, "nVolumen" )
                  nTotCaj              += ::oPreCliL:nCanEnt
                  nImpDtoAtp           += nDtoAtpPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut )

                  if ::lCosAct .or. ::oPreCliL:nCosDiv == 0
                     nTotCosUni        += nRetPreCosto( ::oDbfArt:cAlias, ::oPreCliL:cRef ) * nTotNPreCli( ::oPreCliL:cAlias )
                  else
                     nTotCosUni        += ::oPreCliL:nCosDiv * nTotNPreCli( ::oPreCliL:cAlias )
                  end if

               end if

               ::oPreCliL:Skip()

            end while

            ::oDbf:Append()

            ::oDbf:cNumDoc    := ::oPreCliT:cSerPre + Str( ::oPreCliT:nNumPre ) + ::oPreCliT:cSufPre
            ::oDbf:dFecDoc    := ::oPreCliT:dFecPre
            ::oDbf:cCodCli    := ::oPreCliT:cCodCli
            ::oDbf:cNomCli    := ::oPreCliT:cNomCli
            ::oDbf:nTotCaj    := nTotCaj
            ::oDbf:nTotUni    := nTotUni
            ::oDbf:nTotPes    := nTotPes
            ::oDbf:nTotImp    := nTotImpUni
            ::oDbf:nPreKgr    := if( ::oDbf:nTotPes != 0, ::oDbf:nTotImp / ::oDbf:nTotPes, 0 )
            ::oDbf:nTotVol    := nTotVol
            ::oDbf:nPreVol    := if( ::oDbf:nTotVol != 0, ::oDbf:nTotImp / ::oDbf:nTotVol, 0 )
            ::oDbf:nTotCos    := nTotCosUni
            ::oDbf:nMargen    := nTotImpUni - nTotCosUni - nImpDtoAtp
            ::oDbf:nDtoAtp    := nImpDtoAtp

            if nTotUni != 0 .and. ::oDbf:nTotCos != 0
               ::oDbf:nRentab := nRentabilidad( nTotImpUni, nImpDtoAtp, nTotCosUni )
               ::oDbf:nPreMed := nTotImpUni / nTotUni
               ::oDbf:nCosMed := nTotCosUni / nTotUni
            else
               ::oDbf:nRentab := 0
               ::oDbf:nPreMed := 0
               ::oDbf:nCosMed := 0
            end if

            ::oDbf:Save()

         end if

      end if

      ::oMtrInf:AutoInc()

      ::oPreCliT:Skip()

   end while

   ::oPreCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oPreCliT:cFile ) )

   ::oMtrInf:AutoInc( ::oPreCliT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//