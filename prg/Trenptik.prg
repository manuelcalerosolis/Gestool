#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TRenPTik FROM TInfTrn

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  lCosAct     AS LOGIC    INIT .f.
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT
   DATA  oEstado     AS OBJECT
   DATA  oArt        AS OBJECT
    

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()


END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::RentCreateFields()

   ::AddTmpIndex( "cCodRut", "cCodRut + cCodArt" )
   ::AddGroup( {|| ::oDbf:cCodRut }, {|| "Ruta  : " + Rtrim( ::oDbf:cCodRut ) + "-" + oRetFld( ::oDbf:cCodRut, ::oDbfRut ) } , {|| "Total Ruta... "   } )
   ::AddGroup( {|| ::oDbf:cCodRut + ::oDbf:cCodArt },    {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oArt ) ) }, {|| Space(1) } )

RETURN ( Self )

//---------------------------------------------------------------------------//



METHOD OpenFiles() CLASS TRenUTik

   /*
   Ficheros necesarios
   */

   DATABASE NEW ::oArt     PATH ( cPatEmp() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

    

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) FILE "TIKET.DBF" VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"
   ::oTikCliT:OrdSetFocus( "dFecTik" )

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) FILE "TIKEL.DBF" VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TRenUTik

   ::oArt:End()
   ::oTikCliT:End()
   ::oTikCliL:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld ) CLASS TRenUTik

   if !::StdResource( "INFRENTRNB" )
      return .f.
   end if

   /*
   Monta las rutas de manera automatica
   */

   ::oDefRutInf( 70, 71, 80, 81 )

   /*
   Monta los articulos de manera automatica
   */

   ::lDefArtInf( 110, 120, 130, 140 )

   ::oDefExcInf( 204 )

   ::oDefResInf()

   REDEFINE CHECKBOX ::lExcMov ;
      ID       ( 203 );
      OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lCosAct ;
      ID       ( 205 );
      OF       ::oFld:aDialogs[1]


RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TRenUTik

   local nTotUni
   local nTotImpUni  := 0
   local nTotCosUni  := 0
   local lExcCero    := .f.

   ::aHeader   := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                     {|| "Periodo  : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Rutas  : " + AllTrim( ::cRutOrg )+ " > " + AllTrim( ::cRutDes ) },;
                     {|| "Artículos: " + AllTrim( ::cArtOrg )      + " > " + AllTrim (::cArtDes ) } }

   ::oDlg:Disable()

   ::oDbf:Zap()

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oTikCliT:Lastrec() )

   ::oTikCliT:GoTop()

   ::oTikCliT:Seek( ::dIniInf , .t. )

   while ::oTikCliT:dFecTik <= ::dFinInf .and. !::oTikCliT:Eof()

      if ( ::oTikCliT:cTipTik == "1" .OR. ::oTikCliT:cTipTik == "4" )   .AND.;
         ::oTikCliT:cCodRut >= ::cRutOrg                                .AND.;
         ::oTikCliT:cCodRut <= ::cRutDes                                .AND.;
         lChkSer( ::oTikCliT:cSerTik, ::aSer )

         if ::oTikCliL:Seek( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik )

            while ::oTikCliL:cSerTiL + ::oTikCliL:cNumTiL + ::oTikCliL:cSufTiL == ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik

               if !Empty( ::oTikCliL:cCbaTil )                                                                           .AND.;
                  ::oTikCliL:cCbaTil >= ::cArtOrg                                                                        .AND.;
                  ::oTikCliL:cCbaTil <= ::cArtDes                                                                        .AND.;
                  !( ::lExcMov .AND. ( ::oTikCliL:nUntTil == 0 ) )                                                       .AND.;
                  !( ::lExcCero .AND. ::oTikCliL:nPvpTil == 0 )

                  ::AddRTik( ::oTikCliL:cCbaTil, 1 )

               end if

               if !Empty( ::oTikCliL:cComTil )                                                                           .AND.;
                  ::oTikCliL:cComTil >= ::cArtOrg                                                                        .AND.;
                  ::oTikCliL:cComTil <= ::cArtDes                                                                        .AND.;
                  !( ::lExcMov .AND. ( ::oTikCliL:nUntTil == 0 ) )                                                       .AND.;
                  !( ::lExcCero .AND. ::oTikCliL:nPcmTil == 0  )

                  ::AddRTik( ::oTikCliL:cComTil, 2 )

               end if

               ::oTikCliL:Skip()

            end while

         end if

      end if

      ::oMtrInf:AutoInc()

      ::oTikCliT:Skip()

   end while

   ::oMtrInf:AutoInc( ::oTikCliT:Lastrec() )

  ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//