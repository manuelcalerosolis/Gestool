#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TRenATVta FROM TInfTip

   DATA  lCosAct        AS LOGIC    INIT .f.
   DATA  oAlbCliT       AS OBJECT
   DATA  oAlbCliL       AS OBJECT
   DATA  oFacCliT       AS OBJECT
   DATA  oFacCliL       AS OBJECT
   DATA  oFacRecT       AS OBJECT
   DATA  oFacRecL       AS OBJECT
   DATA  oTikCliT       AS OBJECT
   DATA  oTikCliL       AS OBJECT
   DATA  oDbfArt        AS OBJECT

   DATA  nTotVentas     AS NUMERIC   INIT 0
   DATA  nTotCosto      AS NUMERIC   INIT 0
   DATA  nTotAtipica    AS NUMERIC   INIT 0

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodTip", "C",  4, 0, {|| "@!" },           "Cod.",              .t., "Código tipo",            5, .f. )
   ::AddField( "cNomTip", "C", 35, 0, {|| "@!" },           "Tipo",              .t., "Nombre tipo",           20, .f. )
   ::AddField( "cCodAlm", "C", 16, 0, {|| "@!" },           "Cod. Alm.",         .f., "Código almacén",         5, .f. )
   ::AddField( "cNomAlm", "C", 20, 0, {|| "@!" },           "Nom. Alm.",         .f., "Nombre almacén",        20, .f. )
   ::AddField( "nTotCaj", "N", 16, 6, {|| MasUnd() },       "Cajas",             .f., "Cajas",                 12, .t. )
   ::AddField( "nTotUni", "N", 16, 6, {|| MasUnd() },       "Unds.",             .t., "Unidades",              10, .t. )
   ::AddField( "nTotImp", "N", 16, 6, {|| ::cPicOut },      "Tot. importe",      .t., "Tot. importe",          12, .t. )
   ::AddField( "nTotPes", "N", 16, 6, {|| MasUnd() },       "Tot. peso",         .f., "Total peso",            12, .t. )
   ::AddField( "nPreKgr", "N", 16, 6, {|| ::cPicImp },      "Pre. Kg.",          .f., "Precio kilo",           12, .f. )
   ::AddField( "nTotVol", "N", 16, 6, {|| MasUnd() },       "Tot. volumen",      .f., "Total volumen",         12, .t. )
   ::AddField( "nPreVol", "N", 16, 6, {|| ::cPicImp },      "Pre. vol.",         .f., "Precio volumen",        12, .f. )
   ::AddField( "nTotCos", "N", 16, 6, {|| ::cPicOut },      "Tot. costo",        .t., "Total costo",           12, .t. )
   ::AddField( "nDtoAtp", "N", 16, 6, {|| ::cPicOut },      "Dto. Atipico",      .f., "Importe dto. atipico",  12, .t. )
   ::AddField( "nMarGen", "N", 16, 6, {|| ::cPicOut },      "Margen",            .t., "Margen",                12, .t. )
   ::AddField( "nRenTab", "N", 16, 6, {|| ::cPicOut },      "%Rent.",            .t., "Rentabilidad",          12, .f. )
   ::AddField( "nPreMed", "N", 16, 6, {|| ::cPicImp },      "Precio medio",      .f., "Precio medio",          12, .f. )
   ::AddField( "nCosMed", "N", 16, 6, {|| ::cPicOut },      "Costo medio",       .t., "Costo medio",           12, .f. )

   ::AddTmpIndex( "cCodTip", "cCodAlm + cCodTip" )

   ::AddGroup( {|| ::oDbf:cCodAlm }, {|| "Almacén  : " + Rtrim( ::oDbf:cCodAlm ) + "-" + AllTrim( ::oDbf:cNomAlm ) },  {||"Total almacén ..."} )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TRenATVta

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "ALBCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   ::oFacCliT     := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oFacRecT PATH ( cPatEmp() ) FILE "FACRECT.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL PATH ( cPatEmp() ) FILE "FACRECL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) FILE "TIKET.DBF"    VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) FILE "TIKEL.DBF"    VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oDbfArt  PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TRenATVta

   if !Empty( ::oTikCliT ) .and. ::oTikCliT:Used()
      ::oTikCliT:End()
   end if
   if !Empty( ::oTikCliL ) .and. ::oTikCliL:Used()
      ::oTikCliL:End()
   end if
   if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if
   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if
   if !Empty( ::oFacRecT ) .and. ::oFacRecT:Used()
      ::oFacRecT:End()
   end if
   if !Empty( ::oFacRecL ) .and. ::oFacRecL:Used()
      ::oFacRecL:End()
   end if
   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if
   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if
   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   ::oTikCliT := nil
   ::oTikCliL := nil
   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oFacRecT := nil
   ::oFacRecL := nil
   ::oAlbCliT := nil
   ::oAlbCliL := nil
   ::oDbfArt := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TRenATVta

   if !::StdResource( "INFRENTIP_C" )
      return .f.
   end if

   ::CreateFilter( , ::oDbf, .t. )

   /* Monta tipo de artículos */

   if !::oDefAlmInf( 310, 311, 320, 321, 330 )
      return .f.
   end if

   if !::oDefTipInf( 110, 120, 130, 140, 910 )
      return .f.
   end if

   ::oDefExcInf( 210 )
   ::oDefExcImp( 211 )

   REDEFINE CHECKBOX ::lCosAct ;
      ID       ( 205 );
      OF       ::oFld:aDialogs[1]

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TRenATVta

   local cCodTip
   local cExpHead    := ""
   local cExpLine    := ""
   local nTotUni     := 0
   local nTotImpUni  := 0
   local nImpDtoAtp  := 0

   ::nTotVentas      := 0
   ::nTotCosto       := 0
   ::nTotAtipica     := 0

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader   := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                     {|| "Periodo   : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Almacén   : " + if( ::lAllAlm, "Todos", AllTrim( ::cAlmOrg ) + " > " + AllTrim( ::cAlmDes ) ) },;
                     {|| "Tipo Art. : " + if( ::lAllTip, "Todos", AllTrim( ::cTipOrg ) + " > " + AllTrim( ::cTipDes ) ) },;
                     {|| "Rnt med   : " + Alltrim( Trans( ( ( ( ( ::nTotVentas - ::nTotAtipica ) / ::nTotCosto ) - 1 )* 100 ), ::cPicOut ) ) + "%" } }

   /*Albaranes de clientes*/

   ::oAlbCliT:OrdSetFocus( "dFecAlb" )
   ::oAlbCliL:OrdSetFocus( "nNumAlb" )

   cExpHead          := 'nFacturado < 3 .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !Empty( ::oFilter:cExpresionFilter ) 
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oAlbCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oAlbCliT:cFile ), ::oAlbCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Procesando albaranes"
   ::oMtrInf:SetTotal( ::oAlbCliT:OrdKeyCount() )

   cExpLine          := '!lTotLin .and. !lControl .and. !lKitChl'

   if !::lAllAlm
      cExpLine       += ' .and. Rtrim( cAlmLin ) >= "' + Rtrim( ::cAlmOrg ) + '" .and. Rtrim( cAlmLin ) <= "' + Rtrim( ::cAlmDes ) + '"'
   end if

   ::oAlbCliL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oAlbCliL:cFile ), ::oAlbCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oAlbCliT:GoTop()

    while !::lBreak .and. !::oAlbCliT:Eof()

      if lChkSer( ::oAlbCliT:cSerAlb, ::aSer )

         if ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

            while ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb == ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb

               cCodTip := oRetFld( ::oAlbCliL:cRef, ::oDbfArt , "cCodTip")

               if ( ::lAllTip .or. ( cCodTip >= ::cTipOrg .AND. cCodTip <= ::cTipDes ) )                 .AND.;
                  !( ::lExcCero .AND. nTotNAlbCli( ::oAlbCliL:cAlias ) == 0 )                            .AND.;
                  !( ::lExcImp .AND. nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut ) == 0 )

                  nTotUni              := nTotNAlbCli( ::oAlbCliL:cAlias )
                  nTotImpUni           := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )
                  nImpDtoAtp           := nDtoAtpAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )

                  if ::oDbf:Seek( ::oAlbCliL:cAlmLin + cCodTip )

                     ::oDbf:Load()

                     ::oDbf:nTotCaj    += ::oAlbCliL:nCanEnt
                     ::oDbf:nTotUni    += nTotUni
                     ::oDbf:nTotPes    += nTotUni * oRetFld( ::oAlbCliL:cRef, ::oDbfArt, "nPesoKg" )
                     ::oDbf:nTotImp    += nTotImpUni
                     ::oDbf:nPreKgr    := if( ::oDbf:nTotPes != 0, nTotImpUni / ::oDbf:nTotPes, 0 )
                     ::oDbf:nTotVol    += nTotUni * oRetFld( ::oAlbCliL:cRef, ::oDbfArt, "nVolumen" )
                     ::oDbf:nPreVol    := if( ::oDbf:nTotVol != 0, nTotImpUni / ::oDbf:nTotVol, 0 )

                     if ::lCosAct .or. ::oAlbCliL:nCosDiv == 0
                        ::oDbf:nTotCos += nRetPreCosto( ::oDbfArt:cAlias, ::oAlbCliL:cRef ) * nTotUni
                        ::nTotCosto    += nRetPreCosto( ::oDbfArt:cAlias, ::oAlbCliL:cRef ) * nTotUni
                     else
                        ::oDbf:nTotCos += ::oAlbCliL:nCosDiv * nTotUni
                        ::nTotCosto    += ::oAlbCliL:nCosDiv * nTotUni
                     end if

                     ::oDbf:nDtoAtp    += nImpDtoAtp
                     ::oDbf:nMargen    := ::oDbf:nTotImp - ::oDbf:nTotCos - ::oDbf:nDtoAtp

                     if ::oDbf:nTotUni != 0 .and. ::oDbf:nTotCos != 0
                        ::oDbf:nRentab := nRentabilidad( ::oDbf:nTotImp, ::oDbf:nDtoAtp, ::oDbf:nTotCos )
                        ::oDbf:nPreMed := ::oDbf:nTotImp / ::oDbf:nTotUni
                        ::oDbf:nCosMed := ::oDbf:nTotCos / ::oDbf:nTotUni
                     else
                        ::oDbf:nRentab := 0
                        ::oDbf:nPreMed := 0
                        ::oDbf:nCosMed := 0
                     end if

                     ::nTotVentas      += nTotImpUni
                     ::nTotAtipica     += nImpDtoAtp

                     ::oDbf:Save()

                  else

                     ::oDbf:Append()

                     ::oDbf:cCodAlm    := ::oAlbCliL:cAlmLin
                     ::oDbf:cNomAlm    := oRetFld( ::oAlbCliL:cAlmLin, ::oDbfAlm )
                     ::oDbf:cCodTip    := cCodTip
                     ::oDbf:cNomTip    := oRetFld( cCodTip, ::oTipArt:oDbf, "cNomTip" )
                     ::oDbf:nTotCaj    := ::oAlbCliL:nCanEnt
                     ::oDbf:nTotUni    := nTotUni
                     ::oDbf:nTotPes    := nTotUni * oRetFld( ::oAlbCliL:cRef, ::oDbfArt, "nPesoKg" )
                     ::oDbf:nTotImp    := nTotImpUni
                     ::oDbf:nPreKgr    := if( ::oDbf:nTotPes != 0, nTotImpUni / ::oDbf:nTotPes, 0 )
                     ::oDbf:nTotVol    := nTotUni * oRetFld( ::oAlbCliL:cRef, ::oDbfArt, "nVolumen" )
                     ::oDbf:nPreVol    := if( ::oDbf:nTotVol != 0, nTotImpUni / ::oDbf:nTotVol, 0 )

                     if ::lCosAct .or. ::oAlbCliL:nCosDiv == 0
                        ::oDbf:nTotCos := nRetPreCosto( ::oDbfArt:cAlias, ::oAlbCliL:cRef ) * nTotUni
                        ::nTotCosto    += nRetPreCosto( ::oDbfArt:cAlias, ::oAlbCliL:cRef ) * nTotUni
                     else
                        ::oDbf:nTotCos := ::oAlbCliL:nCosDiv * nTotUni
                        ::nTotCosto    += ::oAlbCliL:nCosDiv * nTotUni
                     end if

                     ::oDbf:nDtoAtp    := nImpDtoAtp
                     ::oDbf:nMargen    := ::oDbf:nTotImp - ::oDbf:nTotCos - ::oDbf:nDtoAtp

                     if ::oDbf:nTotUni != 0 .and. ::oDbf:nTotCos != 0
                        ::oDbf:nRentab := nRentabilidad( ::oDbf:nTotImp, ::oDbf:nDtoAtp, ::oDbf:nTotCos )
                        ::oDbf:nPreMed := ::oDbf:nTotImp / ::oDbf:nTotUni
                        ::oDbf:nCosMed := ::oDbf:nTotCos / ::oDbf:nTotUni
                     else
                        ::oDbf:nRentab := 0
                        ::oDbf:nPreMed := 0
                        ::oDbf:nCosMed := 0
                     end if

                     ::nTotVentas      += ::oDbf:nTotImp
                     ::nTotAtipica     += nImpDtoAtp

                     ::oDbf:Save()

                  end if

               end if

               ::oAlbCliL:Skip()

            end while

         end if

      end if

      ::oAlbCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oAlbCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oAlbCliT:cFile ) )
   ::oAlbCliL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oAlbCliL:cFile ) )

   /*Facturas de clientes*/

   ::oFacCliT:OrdSetFocus( "dFecFac" )
   ::oFacCliL:OrdSetFocus( "nNumFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText := "Procesando factura"
   ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )

   cExpLine          := '!lTotLin .and. !lControl .and. !lKitChl'

   if !::lAllAlm
      cExpLine       += ' .and. Rtrim( cAlmLin ) >= "' + Rtrim( ::cAlmOrg ) + '" .and. Rtrim( cAlmLin ) <= "' + Rtrim( ::cAlmDes ) + '"'
   end if

   ::oFacCliL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacCliL:cFile ), ::oFacCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacCliT:GoTop()

   while !::lBreak .and. !::oFacCliT:Eof()

      if lChkSer( ::oFacCliT:cSerie, ::aSer )

         if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

            while ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac == ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac

               cCodTip := oRetFld( ::oFacCliL:cRef, ::oDbfArt , "cCodTip")

               if ( ::lAllTip .or. ( cCodTip >= ::cTipOrg .AND. cCodTip <= ::cTipDes ) )                        .AND.;
                  !( ::lExcCero .AND. nTotNFacCli( ::oFacCliL:cAlias ) == 0 )                                   .AND.;
                  !( ::lExcImp .AND. nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut ) == 0 )

                  nTotUni              := nTotNFacCli( ::oFacCliL:cAlias )
                  nTotImpUni           := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )
                  nImpDtoAtp           := nDtoAtpFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )

                  if ::oDbf:Seek( ::oFacCliL:cAlmLin + cCodTip )

                     ::oDbf:Load()

                     ::oDbf:nTotCaj    += ::oFacCliL:nCanEnt
                     ::oDbf:nTotUni    += nTotUni
                     ::oDbf:nTotPes    += nTotUni * oRetFld( ::oFacCliL:cRef, ::oDbfArt, "nPesoKg" )
                     ::oDbf:nTotImp    += nTotImpUni
                     ::oDbf:nPreKgr    := if( ::oDbf:nTotPes != 0, nTotImpUni / ::oDbf:nTotPes, 0 )
                     ::oDbf:nTotVol    += nTotUni * oRetFld( ::oFacCliL:cRef, ::oDbfArt, "nVolumen" )
                     ::oDbf:nPreVol    := if( ::oDbf:nTotVol != 0, nTotImpUni / ::oDbf:nTotVol, 0 )

                     if ::lCosAct .or. ::oFacCliL:nCosDiv == 0
                        ::oDbf:nTotCos += nRetPreCosto( ::oDbfArt:cAlias, ::oFacCliL:cRef ) * nTotUni
                        ::nTotCosto    += nRetPreCosto( ::oDbfArt:cAlias, ::oFacCliL:cRef ) * nTotUni
                     else
                        ::oDbf:nTotCos += ::oFacCliL:nCosDiv * nTotUni
                        ::nTotCosto    += ::oFacCliL:nCosDiv * nTotUni
                     end if

                     ::oDbf:nDtoAtp    += nImpDtoAtp
                     ::oDbf:nMargen    := ::oDbf:nTotImp - ::oDbf:nTotCos - ::oDbf:nDtoAtp

                     if ::oDbf:nTotUni != 0 .and. ::oDbf:nTotCos != 0
                        ::oDbf:nRentab := nRentabilidad( ::oDbf:nTotImp, ::oDbf:nDtoAtp, ::oDbf:nTotCos )
                        ::oDbf:nPreMed := ::oDbf:nTotImp / ::oDbf:nTotUni
                        ::oDbf:nCosMed := ::oDbf:nTotCos / ::oDbf:nTotUni
                     else
                        ::oDbf:nRentab := 0
                        ::oDbf:nPreMed := 0
                        ::oDbf:nCosMed := 0
                     end if

                     ::nTotVentas      += nTotImpUni
                     ::nTotAtipica     += nImpDtoAtp

                     ::oDbf:Save()

                  else

                     ::oDbf:Append()

                     ::oDbf:cCodAlm    := ::oFacCliL:cAlmLin
                     ::oDbf:cNomAlm    := oRetFld( ::oFacCliL:cAlmLin, ::oDbfAlm )
                     ::oDbf:cCodTip    := cCodTip
                     ::oDbf:cNomTip    := oRetFld( cCodTip, ::oTipArt:oDbf, "cNomTip" )
                     ::oDbf:nTotCaj    := ::oFacCliL:nCanEnt
                     ::oDbf:nTotUni    := nTotUni
                     ::oDbf:nTotPes    := nTotUni * oRetFld( ::oFacCliL:cRef, ::oDbfArt, "nPesoKg" )
                     ::oDbf:nTotImp    := nTotImpUni
                     ::oDbf:nPreKgr    := if( ::oDbf:nTotPes != 0, nTotImpUni / ::oDbf:nTotPes, 0 )
                     ::oDbf:nTotVol    := nTotUni * oRetFld( ::oFacCliL:cRef, ::oDbfArt, "nVolumen" )
                     ::oDbf:nPreVol    := if( ::oDbf:nTotVol != 0, nTotImpUni / ::oDbf:nTotVol, 0 )

                     if ::lCosAct .or. ::oFacCliL:nCosDiv == 0
                        ::oDbf:nTotCos := nRetPreCosto( ::oDbfArt:cAlias, ::oFacCliL:cRef ) * nTotUni
                        ::nTotCosto    += nRetPreCosto( ::oDbfArt:cAlias, ::oFacCliL:cRef ) * nTotUni
                     else
                        ::oDbf:nTotCos := ::oFacCliL:nCosDiv * nTotUni
                        ::nTotCosto    += ::oFacCliL:nCosDiv * nTotUni
                     end if

                     ::oDbf:nDtoAtp    := nImpDtoAtp
                     ::oDbf:nMargen    := ::oDbf:nTotImp - ::oDbf:nTotCos - ::oDbf:nDtoAtp

                     if ::oDbf:nTotUni != 0 .and. ::oDbf:nTotCos != 0
                        ::oDbf:nRentab := nRentabilidad( ::oDbf:nTotImp, ::oDbf:nDtoAtp, ::oDbf:nTotCos )
                        ::oDbf:nPreMed := ::oDbf:nTotImp / ::oDbf:nTotUni
                        ::oDbf:nCosMed := ::oDbf:nTotCos / ::oDbf:nTotUni
                     else
                        ::oDbf:nRentab := 0
                        ::oDbf:nPreMed := 0
                        ::oDbf:nCosMed := 0
                     end if

                     ::nTotVentas      += ::oDbf:nTotImp
                     ::nTotAtipica     += nImpDtoAtp

                     ::oDbf:Save()

                  end if

               end if

               ::oFacCliL:Skip()

            end while

         end if

      end if

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oFacCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacCliT:cFile ) )
   ::oFacCliL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacCliL:cFile ) )

   /*Facturas rectificativas de cliente*/

   ::oFacRecT:OrdSetFocus( "dFecFac" )
   ::oFacRecL:OrdSetFocus( "nNumFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter 
   end if

   ::oFacRecT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText := "Procesando fac. rec."
   ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )

   cExpLine          := '!lTotLin .and. !lControl .and. !lKitChl'

   if !::lAllAlm
      cExpLine       += ' .and. Rtrim( cAlmLin ) >= "' + Rtrim( ::cAlmOrg ) + '" .and. Rtrim( cAlmLin ) <= "' + Rtrim( ::cAlmDes ) + '"'
   end if

   ::oFacRecL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacRecL:cFile ), ::oFacRecL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacRecT:GoTop()

   while !::lBreak .and. !::oFacRecT:Eof()

      if lChkSer( ::oFacRecT:cSerie, ::aSer )

         if ::oFacRecL:Seek( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac )

            while ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac == ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac

               cCodTip := oRetFld( ::oFacRecL:cRef, ::oDbfArt , "cCodTip")

               if ( ::lAllTip .or. ( cCodTip >= ::cTipOrg .AND. cCodTip <= ::cTipDes ) )                        .AND.;
                  !( ::lExcCero .AND. nTotNFacRec( ::oFacRecL:cAlias ) == 0 )                                   .AND.;
                  !( ::lExcImp .AND. nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut ) == 0 )

                  nTotUni              := nTotNFacRec( ::oFacRecL:cAlias )
                  nTotImpUni           := nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut )
                  nImpDtoAtp           := 0

                  if ::oDbf:Seek( ::oFacRecL:cAlmLin + cCodTip )

                     ::oDbf:Load()

                     ::oDbf:nTotCaj    += ::oFacRecL:nCanEnt
                     ::oDbf:nTotUni    += nTotUni
                     ::oDbf:nTotPes    += nTotUni * oRetFld( ::oFacRecL:cRef, ::oDbfArt, "nPesoKg" )
                     ::oDbf:nTotImp    += nTotImpUni
                     ::oDbf:nPreKgr    := if( ::oDbf:nTotPes != 0, nTotImpUni / ::oDbf:nTotPes, 0 )
                     ::oDbf:nTotVol    += nTotUni * oRetFld( ::oFacRecL:cRef, ::oDbfArt, "nVolumen" )
                     ::oDbf:nPreVol    := if( ::oDbf:nTotVol != 0, nTotImpUni / ::oDbf:nTotVol, 0 )

                     if ::lCosAct .or. ::oFacRecL:nCosDiv == 0
                        ::oDbf:nTotCos += nRetPreCosto( ::oDbfArt:cAlias, ::oFacRecL:cRef ) * nTotUni
                        ::nTotCosto    += nRetPreCosto( ::oDbfArt:cAlias, ::oFacRecL:cRef ) * nTotUni
                     else
                        ::oDbf:nTotCos += ::oFacRecL:nCosDiv * nTotUni
                        ::nTotCosto    += ::oFacRecL:nCosDiv * nTotUni
                     end if

                     ::oDbf:nDtoAtp    += nImpDtoAtp
                     ::oDbf:nMargen    := ::oDbf:nTotImp - ::oDbf:nTotCos - ::oDbf:nDtoAtp

                     if ::oDbf:nTotUni != 0 .and. ::oDbf:nTotCos != 0
                        ::oDbf:nRentab := nRentabilidad( ::oDbf:nTotImp, ::oDbf:nDtoAtp, ::oDbf:nTotCos )
                        ::oDbf:nPreMed := ::oDbf:nTotImp / ::oDbf:nTotUni
                        ::oDbf:nCosMed := ::oDbf:nTotCos / ::oDbf:nTotUni
                     else
                        ::oDbf:nRentab := 0
                        ::oDbf:nPreMed := 0
                        ::oDbf:nCosMed := 0
                     end if

                     ::nTotVentas      += nTotImpUni
                     ::nTotAtipica     += nImpDtoAtp

                     ::oDbf:Save()

                  else

                     ::oDbf:Append()

                     ::oDbf:cCodAlm    := ::oFacRecL:cAlmLin
                     ::oDbf:cNomAlm    := oRetFld( ::oFacRecL:cAlmLin, ::oDbfAlm )
                     ::oDbf:cCodTip    := cCodTip
                     ::oDbf:cNomTip    := oRetFld( cCodTip, ::oTipArt:oDbf, "cNomTip" )
                     ::oDbf:nTotCaj    := ::oFacRecL:nCanEnt
                     ::oDbf:nTotUni    := nTotUni
                     ::oDbf:nTotPes    := nTotUni * oRetFld( ::oFacRecL:cRef, ::oDbfArt, "nPesoKg" )
                     ::oDbf:nTotImp    := nTotImpUni
                     ::oDbf:nPreKgr    := if( ::oDbf:nTotPes != 0, nTotImpUni / ::oDbf:nTotPes, 0 )
                     ::oDbf:nTotVol    := nTotUni * oRetFld( ::oFacRecL:cRef, ::oDbfArt, "nVolumen" )
                     ::oDbf:nPreVol    := if( ::oDbf:nTotVol != 0, nTotImpUni / ::oDbf:nTotVol, 0 )

                     if ::lCosAct .or. ::oFacRecL:nCosDiv == 0
                        ::oDbf:nTotCos := nRetPreCosto( ::oDbfArt:cAlias, ::oFacRecL:cRef ) * nTotUni
                        ::nTotCosto    += nRetPreCosto( ::oDbfArt:cAlias, ::oFacRecL:cRef ) * nTotUni
                     else
                        ::oDbf:nTotCos := ::oFacRecL:nCosDiv * nTotUni
                        ::nTotCosto    += ::oFacRecL:nCosDiv * nTotUni
                     end if

                     ::oDbf:nDtoAtp    := nImpDtoAtp
                     ::oDbf:nMargen    := ::oDbf:nTotImp - ::oDbf:nTotCos - ::oDbf:nDtoAtp

                     if ::oDbf:nTotUni != 0 .and. ::oDbf:nTotCos != 0
                        ::oDbf:nRentab := nRentabilidad( ::oDbf:nTotImp, ::oDbf:nDtoAtp, ::oDbf:nTotCos )
                        ::oDbf:nPreMed := ::oDbf:nTotImp / ::oDbf:nTotUni
                        ::oDbf:nCosMed := ::oDbf:nTotCos / ::oDbf:nTotUni
                     else
                        ::oDbf:nRentab := 0
                        ::oDbf:nPreMed := 0
                        ::oDbf:nCosMed := 0
                     end if

                     ::nTotVentas      += ::oDbf:nTotImp
                     ::nTotAtipica     += nImpDtoAtp

                     ::oDbf:Save()

                  end if

               end if

               ::oFacRecL:Skip()

            end while

         end if

      end if

      ::oFacRecT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oFacRecT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacRecT:cFile ) )
   ::oFacRecL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacRecL:cFile ) )

   /*Tikets de clientes*/

   ::oTikCliT:OrdSetFocus( "dFecTik" )
   ::oTikCliL:OrdSetFocus( "cNumTil" )

   cExpHead          := 'dFecTik >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecTik <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   cExpHead          += ' .and. ( cTipTik == "1" .or. cTipTik == "4" )'

   if !::lAllAlm
      cExpHead       += ' .and. Rtrim( cAlmTik ) >= "' + Rtrim( ::cAlmOrg ) + '" .and. Rtrim( cAlmTik ) <= "' + Rtrim( ::cAlmDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter 
   end if

   ::oTikCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oTikCliT:cFile ), ::oTikCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText := "Procesando tikets"
   ::oMtrInf:SetTotal( ::oTikCliT:OrdKeyCount() )

   cExpLine       := '!lControl .and. !lKitChl'

   ::oTikCliL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oTikCliL:cFile ), ::oTikCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oTikCliT:GoTop()

   while !::lBreak .and. !::oTikCliT:Eof()

      if lChkSer( ::oTikCliT:cSerTik, ::aSer )

         if ::oTikCliL:Seek( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik )

            while ::oTikCliL:cSerTiL + ::oTikCliL:cNumTiL + ::oTikCliL:cSufTiL == ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik

                cCodTip := oRetFld( ::oTikCliL:cCbaTil, ::oDbfArt , "cCodTip")

                if !Empty( ::oTikCliL:cCbaTil )                                                                 .AND.;
                  ( ::lAllTip .or. ( cCodTip >= ::cTipOrg .AND. cCodTip <= ::cTipDes ) )                        .AND.;
                  !( ::lExcCero .AND. ::oTikCliL:nUntTil == 0 )                                                 .AND.;
                  !( ::lExcImp .AND. ::oTikCliL:nPvpTil == 0 )

                  nTotUni              := ::oTikCliL:nUntTil
                  nTotImpUni           := nImpLTpv( ::oTikCliT, ::oTikCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, nil, 1 )
                  nImpDtoAtp           := 0

                  if ::oDbf:Seek( ::oTikCliT:cAlmTik + cCodTip )

                     ::oDbf:Load()

                     ::oDbf:nTotUni    += nTotUni
                     ::oDbf:nTotPes    += nTotUni * oRetFld( ::oTikCliL:cCbaTil, ::oDbfArt, "nPesoKg" )
                     ::oDbf:nTotImp    += nTotImpUni
                     ::oDbf:nPreKgr    := if( ::oDbf:nTotPes != 0, nTotImpUni / ::oDbf:nTotPes, 0 )
                     ::oDbf:nTotVol    += nTotUni / oRetFld( ::oTikCliL:cCbaTil, ::oDbfArt, "nVolumen" )
                     ::oDbf:nPreVol    := if( ::oDbf:nTotVol != 0, nTotImpUni / ::oDbf:nTotVol, 0 )

                     if ::lCosAct .or. ::oTikCliL:nCosDiv == 0
                        ::oDbf:nTotCos += nRetPreCosto( ::oDbfArt:cAlias, ::oTikCliL:cCbaTil ) * nTotUni
                        ::nTotCosto    += nRetPreCosto( ::oDbfArt:cAlias, ::oTikCliL:cCbaTil ) * nTotUni
                     else
                        ::oDbf:nTotCos += ::oTikCliL:nCosDiv * nTotUni
                        ::nTotCosto    += ::oTikCliL:nCosDiv * nTotUni
                     end if

                     ::oDbf:nDtoAtp    += nImpDtoAtp
                     ::oDbf:nMargen    := ::oDbf:nTotImp - ::oDbf:nTotCos - ::oDbf:nDtoAtp

                     if ::oDbf:nTotUni != 0 .and. ::oDbf:nTotCos != 0
                        ::oDbf:nRentab := nRentabilidad( ::oDbf:nTotImp, ::oDbf:nDtoAtp, ::oDbf:nTotCos )
                        ::oDbf:nPreMed := ::oDbf:nTotImp / ::oDbf:nTotUni
                        ::oDbf:nCosMed := ::oDbf:nTotCos / ::oDbf:nTotUni
                     else
                        ::oDbf:nRentab := 0
                        ::oDbf:nPreMed := 0
                        ::oDbf:nCosMed := 0
                     end if

                     ::nTotVentas      += nTotImpUni
                     ::nTotAtipica     += nImpDtoAtp

                     ::oDbf:Save()

                  else

                     ::oDbf:Append()

                     ::oDbf:cCodAlm    := ::oTikCliT:cAlmTik
                     ::oDbf:cNomAlm    := oRetFld( ::oTikCliT:cAlmTik, ::oDbfAlm )
                     ::oDbf:cCodTip    := cCodTip
                     ::oDbf:cNomTip    := oRetFld( cCodTip, ::oTipArt:oDbf, "cNomTip" )
                     ::oDbf:nTotUni    := nTotUni
                     ::oDbf:nTotPes    := nTotUni * oRetFld( ::oTikCliL:cCbaTil, ::oDbfArt, "nPesoKg" )
                     ::oDbf:nTotImp    := nTotImpUni
                     ::oDbf:nPreKgr    := if( ::oDbf:nTotPes != 0, nTotImpUni / ::oDbf:nTotPes, 0 )
                     ::oDbf:nTotVol    := nTotUni / oRetFld( ::oTikCliL:cCbaTil, ::oDbfArt, "nVolumen" )
                     ::oDbf:nPreVol    := if( ::oDbf:nTotVol != 0, nTotImpUni / ::oDbf:nTotVol, 0 )

                     if ::lCosAct .or. ::oTikCliL:nCosDiv == 0
                        ::oDbf:nTotCos := nRetPreCosto( ::oDbfArt:cAlias, ::oTikCliL:cCbaTil ) * nTotUni
                        ::nTotCosto    += nRetPreCosto( ::oDbfArt:cAlias, ::oTikCliL:cCbaTil ) * nTotUni
                     else
                        ::oDbf:nTotCos := ::oTikCliL:nCosDiv * nTotUni
                        ::nTotCosto    += ::oTikCliL:nCosDiv * nTotUni
                     end if

                     ::oDbf:nDtoAtp    := nImpDtoAtp
                     ::oDbf:nMargen    := ::oDbf:nTotImp - ::oDbf:nTotCos - ::oDbf:nDtoAtp

                     if ::oDbf:nTotUni != 0 .and. ::oDbf:nTotCos != 0
                        ::oDbf:nRentab := nRentabilidad( ::oDbf:nTotImp, ::oDbf:nDtoAtp, ::oDbf:nTotCos )
                        ::oDbf:nPreMed := ::oDbf:nTotImp / ::oDbf:nTotUni
                        ::oDbf:nCosMed := ::oDbf:nTotCos / ::oDbf:nTotUni
                     else
                        ::oDbf:nRentab := 0
                        ::oDbf:nPreMed := 0
                        ::oDbf:nCosMed := 0
                     end if

                     ::nTotVentas      += ::oDbf:nTotImp
                     ::nTotAtipica     += nImpDtoAtp

                     ::oDbf:Save()

                  end if

               end if

               cCodTip := oRetFld( ::oTikCliL:cComTil, ::oDbfArt , "cCodTip")

               if !Empty( ::oTikCliL:cComTil )                                                                  .AND.;
                  ( ::lAllTip .or. ( cCodTip >= ::cTipOrg .AND. cCodTip <= ::cTipDes ) )                        .AND.;
                  !( ::lExcCero .AND. ::oTikCliL:nUntTil == 0 )                                                 .AND.;
                  !( ::lExcImp .AND. ::oTikCliL:nPcmTil == 0 )

                  nTotUni              := ::oTikCliL:nUntTil
                  nTotImpUni           := nImpLTpv( ::oTikCliT, ::oTikCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, nil, 2 )

                  if ::oDbf:Seek( ::oTikCliT:cAlmTik + cCodTip )

                     ::oDbf:Load()

                     ::oDbf:nTotUni    += nTotUni
                     ::oDbf:nTotPes    += nTotUni * oRetFld( ::oTikCliL:cComTil, ::oDbfArt, "nPesoKg" )
                     ::oDbf:nTotImp    += nTotImpUni
                     ::oDbf:nPreKgr    := if( ::oDbf:nTotPes != 0, nTotImpUni / ::oDbf:nTotPes, 0 )
                     ::oDbf:nTotVol    += nTotUni / oRetFld( ::oTikCliL:cComTil, ::oDbfArt, "nVolumen" )
                     ::oDbf:nPreVol    := if( ::oDbf:nTotVol != 0, nTotImpUni / ::oDbf:nTotVol, 0 )

                     if ::lCosAct .or. ::oTikCliL:nCosDiv == 0
                        ::oDbf:nTotCos += nRetPreCosto( ::oDbfArt:cAlias, ::oTikCliL:cComTil ) * nTotUni
                        ::nTotCosto    += nRetPreCosto( ::oDbfArt:cAlias, ::oTikCliL:cComTil ) * nTotUni
                     else
                        ::oDbf:nTotCos += ::oTikCliL:nCosDiv * nTotUni
                        ::nTotCosto    += ::oTikCliL:nCosDiv * nTotUni
                     end if

                     ::oDbf:nDtoAtp    += nImpDtoAtp
                     ::oDbf:nMargen    := ::oDbf:nTotImp - ::oDbf:nTotCos - ::oDbf:nDtoAtp

                     if ::oDbf:nTotUni != 0 .and. ::oDbf:nTotCos != 0
                        ::oDbf:nRentab := nRentabilidad( ::oDbf:nTotImp, ::oDbf:nDtoAtp, ::oDbf:nTotCos )
                        ::oDbf:nPreMed := ::oDbf:nTotImp / ::oDbf:nTotUni
                        ::oDbf:nCosMed := ::oDbf:nTotCos / ::oDbf:nTotUni
                     else
                        ::oDbf:nRentab := 0
                        ::oDbf:nPreMed := 0
                        ::oDbf:nCosMed := 0
                     end if

                     ::nTotVentas      += nTotImpUni
                     ::nTotAtipica     += nImpDtoAtp

                     ::oDbf:Save()

                  else

                     ::oDbf:Append()

                     ::oDbf:cCodAlm    := ::oTikCliT:cAlmTik
                     ::oDbf:cNomAlm    := oRetFld( ::oTikCliT:cAlmTik, ::oDbfAlm )
                     ::oDbf:cCodTip    := cCodTip
                     ::oDbf:cNomTip    := oRetFld( cCodTip, ::oTipArt:oDbf, "cNomTip" )
                     ::oDbf:nTotUni    := nTotUni
                     ::oDbf:nTotPes    := nTotUni * oRetFld( ::oTikCliL:cComTil, ::oDbfArt, "nPesoKg" )
                     ::oDbf:nTotImp    := nTotImpUni
                     ::oDbf:nPreKgr    := if( ::oDbf:nTotPes != 0, nTotImpUni / ::oDbf:nTotPes, 0 )
                     ::oDbf:nTotVol    := nTotUni / oRetFld( ::oTikCliL:cComTil, ::oDbfArt, "nVolumen" )
                     ::oDbf:nPreVol    := if( ::oDbf:nTotVol != 0, nTotImpUni / ::oDbf:nTotVol, 0 )

                     if ::lCosAct .or. ::oTikCliL:nCosDiv == 0
                        ::oDbf:nTotCos := nRetPreCosto( ::oDbfArt:cAlias, ::oTikCliL:cComTil ) * nTotUni
                        ::nTotCosto    += nRetPreCosto( ::oDbfArt:cAlias, ::oTikCliL:cComTil ) * nTotUni
                     else
                        ::oDbf:nTotCos := ::oTikCliL:nCosDiv * nTotUni
                        ::nTotCosto    += ::oTikCliL:nCosDiv * nTotUni
                     end if

                     ::oDbf:nDtoAtp    := nImpDtoAtp
                     ::oDbf:nMargen    := ::oDbf:nTotImp - ::oDbf:nTotCos - ::oDbf:nDtoAtp

                     if ::oDbf:nTotUni != 0 .and. ::oDbf:nTotCos != 0
                        ::oDbf:nRentab := nRentabilidad( ::oDbf:nTotImp, ::oDbf:nDtoAtp, ::oDbf:nTotCos )
                        ::oDbf:nPreMed := ::oDbf:nTotImp / ::oDbf:nTotUni
                        ::oDbf:nCosMed := ::oDbf:nTotCos / ::oDbf:nTotUni
                     else
                        ::oDbf:nRentab := 0
                        ::oDbf:nPreMed := 0
                        ::oDbf:nCosMed := 0
                     end if

                     ::nTotVentas      += ::oDbf:nTotImp
                     ::nTotAtipica     += nImpDtoAtp

                     ::oDbf:Save()

                  end if

               end if

               ::oTikCliL:Skip()

            end while

         end if

      end if

      ::oTikCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oTikCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oTikCliT:cFile ) )
   ::oTikCliL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oTikCliL:cFile ) )

   ::oMtrInf:AutoInc( ::oTikCliT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//