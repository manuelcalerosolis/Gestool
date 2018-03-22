#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TRenUsrPre FROM TInfUsr

   DATA  lDesglose   AS LOGIC    INIT .t.
   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  lCosAct     AS LOGIC    INIT .f.
   DATA  oPreCliT    AS OBJECT
   DATA  oPreCliL    AS OBJECT
   DATA  oEstado     AS OBJECT
    
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Aceptado", "Todos" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()


END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

    

   ::oPreCliT  := TDataCenter():oPreCliT()

   DATABASE NEW ::oPreCliL PATH ( cPatEmp() ) FILE "PRECLIL.DBF" VIA ( cDriver() ) SHARED INDEX "PRECLIL.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

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

    
   ::oPreCliT := nil
   ::oPreCliL := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Create()

   ::RentCreateFields()

   ::AddTmpIndex( "CCODUSR", "CCODUSR + CCODART + CCODPR1 + CCODPR2 + CVALPR1 + CVALPR2 + CLOTE" )

   ::AddGroup( {|| ::oDbf:cCodUsr }, {|| "Usuario : " + Rtrim( ::oDbf:cCodUsr ) + "-" + Rtrim( ::oDbf:cNomUsr ) } , {|| "Total usuario... "   } )
   ::AddGroup( {|| ::oDbf:cCodUsr + ::oDbf:cCodArt },    {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oDbfArt ) ) }, {|| "Total artículo..." } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cEstado := "Todos"

   if !::StdResource( "INFRENUSR" )
      return .f.
   end if

   /*
   Monta los usuarios de manera automatica
   */

   if !::oDefUsrInf( 70, 71, 80, 81, 910 )
      return .f.
   end if

   /*
   Monta los articulos de manera automatica
   */

   if !::lDefArtInf( 110, 120, 130, 140, 800 )
      return .f.
   end if

   ::oDefExcInf( 204 )

   ::oDefResInf()

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

   REDEFINE CHECKBOX ::lDesglose ;
      ID       600 ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmPreCli(), ::oPreCliT:cAlias )

   ::bPreGenerate    := {|| ::NewGroup( ::lDesglose ) }
   ::bPostGenerate   := {|| ::QuiGroup( ::lDesglose ) }

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local nTotUni
   local nTotImpUni  := 0
   local nTotCosUni  := 0
   local cExpHead    := ""
   local cExpLine    := ""
   local nImpDtoAtp  := 0

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader   := {  {|| "Fecha      : " + Dtoc( Date() ) },;
                     {|| "Periodo    : " + Dtoc( ::dIniInf )   + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Usuarios   : " + if( ::lAllUsr, "Todos", AllTrim( ::cUsrOrg )+ " > " + AllTrim( ::cUsrDes ) ) },;
                     {|| "Artículos  : " + if( ::lAllArt, "Todos", AllTrim( ::cArtOrg )+ " > " + AllTrim (::cArtDes ) ) },;
                     {|| "Estado     : " + ::aEstado[ ::oEstado:nAt ] } }

   ::oPreCliT:OrdSetFocus( "dFecPre" )
   ::oPreCliL:OrdSetFocus( "nNumPre" )

   do case
      case ::oEstado:nAt == 1
         cExpHead    := '!lEstado .and. dFecPre >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecPre <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 2
         cExpHead    := 'lEstado.and. dFecPre >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecPre <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      otherwise
         cExpHead    := 'dFecPre >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecPre <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   end case

   if !::lAllUsr
      cExpHead       += ' .and. cCodUsr >= "' + Rtrim( ::cUsrOrg ) + '" .and. cCodUsr <= "' + Rtrim( ::cUsrDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oPreCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oPreCliT:cFile ), ::oPreCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oPreCliT:OrdKeyCount() )

   /*
   Lineas de albaranes
   */

   cExpLine          := '!lTotLin .and. !lControl .and. !lKitChl'

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oPreCliL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oPreCliL:cFile ), ::oPreCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oPreCliT:GoTop()

   while !::lBreak .and. !::oPreCliT:Eof()

      if lChkSer( ::oPreCliT:cSerPre, ::aSer )

         if ::oPreCliL:Seek( ::oPreCliT:cSerPre + Str( ::oPreCliT:nNumPre ) + ::oPreCliT:cSufPre )

            while ::oPreCliL:cSerPre + Str( ::oPreCliL:nNumPre ) + ::oPreCliL:cSufPre == ::oPreCliT:cSerPre + Str( ::oPreCliT:nNumPre ) + ::oPreCliT:cSufPre

               if !( ::lExcMov  .AND. ( nTotNPreCli( ::oPreCliL:cAlias ) == 0  ) )

                  /*
                  Calculamos las cajas en vendidas entre dos fechas
                  */

                  nTotUni              := nTotNPreCli( ::oPreCliL:cAlias )
                  nTotImpUni           := nImpLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut )
                  nIMpDtoAtp           := nDtoAtpPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut )

                  if ::lCosAct .or. ::oPreCliL:nCosDiv == 0
                     nTotCosUni        := nRetPreCosto( ::oDbfArt:cAlias, ::oPreCliL:cRef ) * nTotUni
                  else
                     nTotCosUni        := ::oPreCliL:nCosDiv * nTotUni
                  end if

                  ::oDbf:Append()

                  ::oDbf:cCodUsr    := ::oPreCliT:cCodUsr
                  ::oDbf:cNomUsr    := oRetFld( ::oDbf:cCodUsr, ::oDbfUsr )
                  ::oDbf:cCodArt    := ::oPreCliL:cRef
                  ::oDbf:cNomArt    := ::oPreCliL:cDetalle
                  ::oDbf:cCodPr1    := ::oPreCliL:cCodPr1
                  ::oDbf:cNomPr1    := retProp( ::oPreCliL:cCodPr1 )
                  ::oDbf:cCodPr2    := ::oPreCliL:cCodPr2
                  ::oDbf:cNomPr2    := retProp( ::oPreCliL:cCodPr2 )
                  ::oDbf:cValPr1    := ::oPreCliL:cValPr1
                  ::oDbf:cNomVl1    := retValProp( ::oPreCliL:cCodPr1 + ::oPreCliL:cValPr1 )
                  ::oDbf:cValPr2    := ::oPreCliL:cValPr2
                  ::oDbf:cNomVl2    := retValProp( ::oPreCliL:cCodPr2 + ::oPreCliL:cValPr2 )
                  ::oDbf:cLote      := ::oPreCliL:cLote

                  ::AddCliente( ::oPreCliT:cCodCli, ::oPreCliT, .f. )

                  ::oDbf:nTotCaj    := ::oPreCliL:nCanEnt
                  ::oDbf:nTotUni    := nTotUni
                  ::oDbf:nTotPes    := ::oDbf:nTotUni * oRetFld( ::oPreCliL:cRef, ::oDbfArt, "nPesoKg" )
                  ::oDbf:nTotImp    := nTotImpUni
                  ::oDbf:nPreKgr    := if( ::oDbf:nTotPes != 0, ::oDbf:nTotImp / ::oDbf:nTotPes, 0 )
                  ::oDbf:nTotVol    := ::oDbf:nTotUni * oRetFld( ::oPreCliL:cRef, ::oDbfArt, "nVolumen" )
                  ::oDbf:nPreVol    := if( ::oDbf:nTotVol != 0, ::oDbf:nTotImp / ::oDbf:nTotVol, 0 )
                  ::oDbf:nTotCos    := nTotCosUni
                  ::oDbf:nMargen    := nTotImpUni - nTotCosUni
                  ::oDbf:nDtoAtp    := nImpDtoAtp

                  if nTotUni != 0 .and. nTotCosUni != 0
                     ::oDbf:nRentab := nRentabilidad( nTotImpUni, nImpDtoAtp, nTotCosUni )
                     ::oDbf:nPreMed := nTotImpUni / nTotUni
                     ::oDbf:nCosMed := nTotCosUni / nTotUni
                  else
                     ::oDbf:nRentab := 0
                     ::oDbf:nPreMed := 0
                     ::oDbf:nCosMed := 0
                  end if

                  ::oDbf:cNumDoc    := ::oPreCliL:cSerPre + "/" + Alltrim( Str( ::oPreCliL:nNumPre ) ) + "/" + ::oPreCliL:cSufPre

                  ::oDbf:Save()

               end if

               ::oPreCliL:Skip()

            end while

         end if

      end if

      ::oMtrInf:AutoInc()

      ::oPreCliT:Skip()

   end while

   ::oPreCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oPreCliT:cFile ) )

   ::oPreCliL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oPreCliL:cFile ) )

   ::oMtrInf:AutoInc( ::oPreCliT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//