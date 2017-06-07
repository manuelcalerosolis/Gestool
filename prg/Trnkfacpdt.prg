#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TRnkFacPdt FROM TInfGen

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oDbfIva     AS OBJECT
   DATA  oFacCliP    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
    
   DATA  oAntCliT    AS OBJECT
   DATA  oLimit      AS OBJECT
   DATA  nTotalNeto              INIT 0
   DATA  nLimit                  INIT 0
   DATA  lAllPrc     AS LOGIC    INIT .t.

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField ( "cCodCli", "C", 12, 0, {|| "@!" },         "Código",                    .t., "Código cliente",             9 )
   ::AddField ( "cNomCli", "C", 50, 0, {|| "@!" },         "Cliente",                   .t., "Nombre cliente",            35 )
   ::AddField ( "cDocMov", "C", 18, 0, {|| "@!" },         "Fac",                       .f., "Factura",                    9 )
   ::AddField ( "dFecMov", "D",  8, 0, {|| "@!" },         "Fecha",                     .f., "Fecha",                      8 )
   ::AddField ( "cNifCli", "C", 15, 0, {|| "@!" },         "Nif",                       .f., "Nif",                       15 )
   ::AddField ( "cDomCli", "C", 35, 0, {|| "@!" },         "Domicilio",                 .f., "Domicilio",                 35 )
   ::AddField ( "cPobCli", "C", 25, 0, {|| "@!" },         "Población",                 .f., "Población",                 25 )
   ::AddField ( "cProCli", "C", 20, 0, {|| "@!" },         "Provincia",                 .f., "Provincia",                 20 )
   ::AddField ( "cCdpCli", "C",  7, 0, {|| "@!" },         "CP",                        .f., "Cod. Postal",                7 )
   ::AddField ( "cTlfCli", "C", 12, 0, {|| "@!" },         "Tlf",                       .f., "Teléfono",                  12 )
   ::AddField ( "cObrCli", "C",  3, 0, {|| "@!" },         "Dirección",                      .f., "Dirección",                       4 )
   ::AddField ( "nTotPdt", "N", 16, 6, {|| ::cPicOut  },   "Pendiente",                 .t., "Pendiente",                 10 )
   ::AddField ( "nTotCob", "N", 16, 6, {|| ::cPicOut  },   "Cobrado",                   .t., "Cobrado",                   10 )
   ::AddField ( "nTotNet", "N", 16, 6, {|| ::cPicOut  },   "Neto",                      .f., "Neto",                      10 )
   ::AddField ( "nTotIva", "N", 16, 6, {|| ::cPicOut  },   cImp(),                       .f., cImp(),                       10 )
   ::AddField ( "nTotReq", "N", 16, 3, {|| ::cPicOut  },   "Rec",                       .f., "Recargo equivalencia",      10 )
   ::AddField ( "nTotDoc", "N", 16, 6, {|| ::cPicOut  },   "Total",                     .T., "Total",                     10 )
   ::AddField ( "nNumOpe", "N", 16, 0, {|| '9999999'  },   "Operaciones",               .f., "Número de operaciones",     12 )
   ::AddField ( "nPorVta", "N", 10, 2, {|| '999.99'    },  "% Ventas",                  .f., "Porcentaje sobre ventas",   12 )

   ::AddTmpIndex ( "cCodCli", "cCodCli", , , , .t. )
   ::AddTmpIndex ( "nTotPdt", "nTotPdt", , , , .t. )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TRnkFacPdt

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL  PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oDbfIva   PATH ( cPatDat() ) FILE "TIVA.DBF" VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   ::oFacCliP := TDataCenter():oFacCliP()

   DATABASE NEW ::oAntCliT  PATH ( cPatEmp() ) FILE "ANTCLIT.DBF" VIA ( cDriver() ) SHARED INDEX "ANTCLIT.CDX"

   ::bForReport   := {|| ::lAllPrc .or. ::oDbf:nTotPdt >= ::nLimit }

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TRnkFacPdt

   if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if
   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if
    
   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if
   if !Empty( ::oFacCliP ) .and. ::oFacCliP:Used()
      ::oFacCliP:End()
   end if
   if !Empty( ::oAntCliT ) .and. ::oAntCliT:Used()
      ::oAntCliT:End()
   end if

   ::oFacCliT := nil
   ::oFacCliL := nil
    
   ::oDbfIva  := nil
   ::oFacCliP := nil
   ::oAntCliT := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TRnkFacPdt

   if !::StdResource( "INF_GEN15C" )
      return .f.
   end if

   ::aHeader   :={ {|| "Fecha    : "  + Dtoc( Date() ) },;
                   {|| "Clientes : "  + if( ::lAllCli, "Todos", AllTrim( ::cCliOrg )+ " > " + AllTrim( ::cCliDes ) ) },;
                   {|| "Importe  : "  + if( ::lAllPrc, "Todos los importes", "Mayor de : " + Str( ::nLimit ) ) } }

   /*
   Monta los clientes de manera automatica
   */

   if !::oDefCliInf( 110, 120, 130, 140, , 600 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )

   REDEFINE CHECKBOX ::lAllPrc ;
      ID       160 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET ::oLimit VAR ::nLimit ;
		COLOR 	CLR_GET ;
      PICTURE  PicOut() ;
      WHEN     !::lAllPrc ;
      ID       150 ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmFacCli(), ::oFacCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TRnkFacPdt

   local aTotFacCli
   local nCobFacCli
   local cExpHead     := ""
   local nCobrado     := 0

   ::nTotalNeto       := 0

   ::oDlg:Disable()
   ::oBtnCancel:Enable()

   ::oDbf:Zap()
   ::oDbf:OrdSetFocus( "CCODCLI" )

   ::oFacCliT:OrdSetFocus( "dFecFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )

   /*
   Nos movemos por las cabeceras de las facturas a clientes
	*/

   ::oFacCliT:GoTop()

   while !::lBreak .and. !::oFacCliT:Eof()

      if lChkSer( ::oFacCliT:cSerie, ::aSer )

         aTotFacCli  := aTotFacCli( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacCliP:cAlias, ::oAntCliT:cAlias )
         nCobFacCli  := nPagFacCli( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac, ::oFacCliT:cAlias, ::oFacCliP:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, nil, .t. )

         if ::oDbf:Seek( ::oFacCliT:cCodCli )

            ::oDbf:Load()

            ::oDbf:nTotNet += aTotFacCli[1]
            ::oDbf:nTotIva += aTotFacCli[2]
            ::oDbf:nTotReq += aTotFacCli[3]
            ::oDbf:nTotDoc += aTotFacCli[4]
            ::oDbf:nTotCob += nCobFacCli

            ::nTotalNeto   += aTotFacCli[1]

            ::oDbf:nNumOpe++

            ::oDbf:Save()

         else

            ::oDbf:Append()

            ::oDbf:cCodCli := ::oFacCliT:cCodCli
            ::oDbf:cNomCli := ::oFacCliT:cNomCli
            ::oDbf:dFecMov := ::oFacCliT:dFecFac
            ::oDbf:nTotNet := aTotFacCli[1]
            ::oDbf:nTotIva := aTotFacCli[2]
            ::oDbf:nTotReq := aTotFacCli[3]
            ::oDbf:nTotDoc := aTotFacCli[4]
            ::oDbf:nTotCob := nCobFacCli

            ::nTotalNeto   += aTotFacCli[1]

            ::oDbf:nNumOpe := 1

            ::AddCliente( ::oFacCliT:cCodCli, ::oFacCliT, .f. )

            ::oDbf:Save()

         end if

      end if

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oFacCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ) )

   ::oMtrInf:AutoInc( ::oFacCliT:LastRec() )

   ::oDlg:Enable()

   ::oDbf:GoTop()

   while !::oDbf:Eof()

      ::oDbf:Load()
      ::oDbf:nPorVta := ( ::oDbf:nTotNet * 100 ) / ::nTotalNeto
      ::oDbf:nTotPdt := ::oDbf:nTotDoc - ::oDbf:nTotCob
      ::oDbf:Save()

      ::oDbf:Skip()

   end while

   ::oDbf:OrdSetFocus( "nTotPdt" )

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//