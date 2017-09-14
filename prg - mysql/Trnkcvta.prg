#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TRnkCVta FROM TInfGen

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oDbfIva     AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oFacCliP    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT
   DATA  oAntCliT    AS OBJECT
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT
    
   DATA  oLimit      AS OBJECT
   DATA  nTotalNeto  AS NUMERIC  INIT 0
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

   ::AddField ( "cDocMov", "C", 18, 0, {|| "@!" },         "Doc.",                      .f., "Documento",                  9 )
   ::AddField ( "dFecMov", "D",  8, 0, {|| "@!" },         "Fecha",                     .f., "Fecha",                      8 )
   ::AddField ( "cCodCli", "C", 12, 0, {|| "@!" },         "Cód. cli.",                 .t., "Cod. Cliente",               8 )
   ::AddField ( "cNomCli", "C", 50, 0, {|| "@!" },         "Cliente",                   .t., "Nom. Cliente",              30 )
   ::AddField ( "cNifCli", "C", 15, 0, {|| "@!" },         "Nif",                       .f., "Nif",                       15 )
   ::AddField ( "cDomCli", "C", 35, 0, {|| "@!" },         "Domicilio",                 .f., "Domicilio",                 35 )
   ::AddField ( "cPobCli", "C", 25, 0, {|| "@!" },         "Población",                 .f., "Población",                 25 )
   ::AddField ( "cProCli", "C", 20, 0, {|| "@!" },         "Provincia",                 .f., "Provincia",                 20 )
   ::AddField ( "cCdpCli", "C",  7, 0, {|| "@!" },         "CP",                        .f., "Cod. Postal",                7 )
   ::AddField ( "cTlfCli", "C", 12, 0, {|| "@!" },         "Tlf",                       .f., "Teléfono",                  12 )
   ::AddField ( "nTotNet", "N", 16, 6, {|| ::cPicOut  },   "Neto",                      .t., "Neto",                      10 )
   ::AddField ( "nTotIva", "N", 16, 6, {|| ::cPicOut  },   cImp(),                       .t., cImp(),                       10 )
   ::AddField ( "nTotReq", "N", 16, 3, {|| ::cPicOut  },   "Rec",                       .t., "Recargo equivalencia",      10 )
   ::AddField ( "nTotDoc", "N", 16, 6, {|| ::cPicOut  },   "Total",                     .t., "Total",                     10 )
   ::AddField ( "nNumOpe", "N", 16, 0, {|| '9999999'  },   "Operaciones",               .f., "Número de operaciones",     12 )
   ::AddField ( "nPorVta", "N", 10, 2, {|| '999.99'    },  "% Ventas",                  .f., "Porcentaje sobre ventas",   12 )

   ::AddTmpIndex ( "cCodCli", "cCodCli", , , , .t. )
   ::AddTmpIndex ( "nTotNet", "nTotNet", , , , .t. )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL  PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL  PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   ::oFacCliP := TDataCenter():oFacCliP()

   DATABASE NEW ::oFacRecT PATH ( cPatEmp() ) FILE "FACRECT.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL PATH ( cPatEmp() ) FILE "FACRECL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   DATABASE NEW ::oTikCliT  PATH ( cPatEmp() ) FILE "TIKET.DBF"   VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL  PATH ( cPatEmp() ) FILE "TIKEL.DBF"   VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oDbfIva   PATH ( cPatDat() ) FILE "TIVA.DBF"    VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   DATABASE NEW ::oAntCliT  PATH ( cPatEmp() ) FILE "ANTCLIT.DBF" VIA ( cDriver() ) SHARED INDEX "ANTCLIT.CDX"

   ::bForReport   := {|| ::lAllPrc .or. ::oDbf:nTotNet >= ::nLimit }

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if
   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if
   if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if
   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if
   if !Empty( ::oFacCliP ) .and. ::oFacCliP:Used()
      ::oFacCliP:End()
   end if
   if !Empty( ::oFacRecT ) .and. ::oFacRecT:Used()
      ::oFacRecT:End()
   end if
   if !Empty( ::oFacRecL ) .and. ::oFacRecL:Used()
      ::oFacRecL:End()
   end if
   if !Empty( ::oTikCliT ) .and. ::oTikCliT:Used()
      ::oTikCliT:End()
   end if
   if !Empty( ::oTikCliL ) .and. ::oTikCliL:Used()
      ::oTikCliL:End()
   end if
    
   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if
   if !Empty( ::oAntCliT ) .and. ::oAntCliT:Used()
      ::oAntCliT:End()
   end if

   ::oAlbCliT := nil
   ::oAlbCliL := nil
   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oFacCliP := nil
   ::oFacRecT := nil
   ::oFacRecL := nil
   ::oTikCliT := nil
   ::oTikCliL := nil
    
   ::oDbfIva  := nil
   ::oAntCliT := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INF_GEN15B" )
      return .f.
   end if

   ::CreateFilter( , ::oDbf, .t. )

   ::aHeader   :={ {|| "Fecha     : "  + Dtoc( Date() ) },;
                   {|| "Periodo   : "  + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                   {|| "Clientes  : "  + if( ::lAllCli, "Todos", AllTrim( ::cCliOrg )+ " > " + AllTrim( ::cCliDes ) ) },;
                   {|| "Importe   : "  + if( ::lAllPrc, "Todos los importes", "Mayor de : " + Str( ::nLimit ) ) } }

   /*
   Monta los clientes de manera automatica
   */

   if !::oDefCliInf( 110, 120, 130, 140, , 600 )
      return .f.
   end if

   REDEFINE CHECKBOX ::lAllPrc ;
      ID       160 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET ::oLimit VAR ::nLimit ;
		COLOR 	CLR_GET ;
      PICTURE  PicOut() ;
      WHEN     !::lAllPrc ;
      ID       150 ;
      OF       ::oFld:aDialogs[1]

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local aTotAlbCli
   local aTotFacCli
   local aTotTikCli
   local cExpHead := ""

   ::nTotalNeto   := 0

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::oDbf:OrdSetFocus( "cCodCli" )

   ::oAlbCliT:OrdSetFocus( "dFecAlb" )

   cExpHead          := 'nFacturado < 3 .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter ) 
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oAlbCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ), ::oAlbCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Albaranes"
   ::oMtrInf:SetTotal( ::oAlbCliT:OrdKeyCount() )

   ::oAlbCliT:GoTop()

   while !::lBreak .and. !::oAlbCliT:Eof()

      aTotAlbCli  := aTotAlbCli( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb, ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::cDivInf )

      if lChkSer( ::oAlbCliT:cSerAlb, ::aSer )

         if ::oDbf:Seek( ::oAlbCliT:cCodCli )

            ::oDbf:Load()

            ::oDbf:nTotNet += aTotAlbCli[1]
            ::oDbf:nTotIva += aTotAlbCli[2]
            ::oDbf:nTotReq += aTotAlbCli[3]
            ::oDbf:nTotDoc += aTotAlbCli[4]
            ::oDbf:nNumOpe++
            ::nTotalNeto   += aTotAlbCli[1]

            ::oDbf:Save()

         else

            ::oDbf:Append()
            ::oDbf:Blank()

               ::oDbf:cCodCli := ::oAlbCliT:cCodCli
               ::oDbf:cNomCli := ::oAlbCliT:cNomCli
               ::oDbf:dFecMov := ::oAlbCliT:dFecAlb
               ::oDbf:nTotNet := aTotAlbCli[1]
               ::oDbf:nTotIva := aTotAlbCli[2]
               ::oDbf:nTotReq := aTotAlbCli[3]
               ::oDbf:nTotDoc := aTotAlbCli[4]
               ::oDbf:nNumOpe := 1
               ::nTotalNeto   += aTotAlbCli[1]

               ::AddCliente( ::oAlbCliT:cCodCli, ::oAlbCliT, .f. )

            ::oDbf:Save()

         end if

      end if

      ::oAlbCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oAlbCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ) )

   /*
   Facturas de clientes--------------------------------------------------------
   */

   ::oFacCliT:OrdSetFocus( "dFecFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Facturas"
   ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )

   ::oFacCliT:GoTop()

   /*
   Nos movemos por las cabeceras de las facturas a clientes
	*/

   while !::lBreak .and. !::oFacCliT:Eof()

      aTotFacCli  := aTotFacCli( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacCliP:cAlias, ::oAntCliT:cAlias, nil, ::cDivInf )

      if lChkSer( ::oFacCliT:cSerie, ::aSer )

         if ::oDbf:Seek( ::oFacCliT:cCodCli )

            ::oDbf:Load()

            ::oDbf:nTotNet += aTotFacCli[1]
            ::oDbf:nTotIva += aTotFacCli[2]
            ::oDbf:nTotReq += aTotFacCli[3]
            ::oDbf:nTotDoc += aTotFacCli[4]
            ::oDbf:nNumOpe++
            ::nTotalNeto   += aTotFacCli[1]

            ::oDbf:Save()

         else

            ::oDbf:Append()
            ::oDbf:Blank()

               ::oDbf:cCodCli := ::oFacCliT:CCODCLI
               ::oDbf:cNomCli := ::oFacCliT:CNOMCLI
               ::oDbf:dFecMov := ::oFacCliT:DFECFAC
               ::oDbf:nTotNet := aTotFacCli[1]
               ::oDbf:nTotIva := aTotFacCli[2]
               ::oDbf:nTotReq := aTotFacCli[3]
               ::oDbf:nTotDoc := aTotFacCli[4]
               ::oDbf:nNumOpe := 1
               ::nTotalNeto   += aTotFacCli[1]

               ::AddCliente( ::oFacCliT:cCodCli, ::oFacCliT, .f. )

            ::oDbf:Save()

         end if

      end if

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oFacCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ) )

   ::oFacCliT:OrdSetFocus( "dFecTik" )

   /*
   Facturas rectificativas--------------------------------------------------------
   */

   ::oFacRecT:OrdSetFocus( "dFecFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacRecT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Facturas rectificativas"
   ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )

   ::oFacRecT:GoTop()

   /*
   Nos movemos por las cabeceras de las facturas rectificativas
	*/

   while !::lBreak .and. !::oFacRecT:Eof()

      aTotFacCli  := aTotFacRec( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac, ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::cDivInf )

      if lChkSer( ::oFacRecT:cSerie, ::aSer )

         if ::oDbf:Seek( ::oFacRecT:cCodCli )

            ::oDbf:Load()

            ::oDbf:nTotNet -= aTotFacCli[1]
            ::oDbf:nTotIva -= aTotFacCli[2]
            ::oDbf:nTotReq -= aTotFacCli[3]
            ::oDbf:nTotDoc -= aTotFacCli[4]
            ::oDbf:nNumOpe++
            ::nTotalNeto   -= aTotFacCli[1]

            ::oDbf:Save()

         else

            ::oDbf:Append()
            ::oDbf:Blank()

            ::oDbf:cCodCli := ::oFacRecT:cCodCli
            ::oDbf:cNomCli := ::oFacRecT:cNomCli
            ::oDbf:dFecMov := ::oFacRecT:dFecFac
            ::oDbf:nTotNet := - ( aTotFacCli[1] )
            ::oDbf:nTotIva := - ( aTotFacCli[2] )
            ::oDbf:nTotReq := - ( aTotFacCli[3] )
            ::oDbf:nTotDoc := - ( aTotFacCli[4] )
            ::oDbf:nNumOpe := 1
            ::nTotalNeto   -= aTotFacCli[1]

            ::AddCliente( ::oFacRecT:cCodCli, ::oFacRecT, .f. )

            ::oDbf:Save()

         end if

      end if

      ::oFacRecT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oFacRecT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ) )

   /*
   Tickets de clientes --------------------------------------------------------
   */

   ::oTikCliT:OrdSetFocus( "dFecTik" )

   cExpHead          := 'dFecTik >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecTik <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead       += ' .and. cCliTik >= "' + Rtrim( ::cCliOrg ) + '" .and. cCliTik <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter 
   end if

   ::oTikCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ), ::oTikCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Tickets"
   ::oMtrInf:SetTotal( ::oTikCliT:OrdKeyCount() )

   ::oTikCliT:GoTop()

   /*
   Nos movemos por las cabeceras de los albaranes a clientes
	*/

   while !::lBreak .and. !::oTikCliT:Eof()

      aTotTikCli  := aTotTik( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik, ::oTikCliT:cAlias, ::oTikCliL:cAlias, ::oDbfDiv:cAlias, nil, ::cDivInf )

      if lChkSer( ::oTikCliT:cSerTik, ::aSer )

         if ::oDbf:Seek( ::oTikCliT:cCliTik )

            ::oDbf:Load()

            ::oDbf:nTotNet += aTotTikCli[1]
            ::oDbf:nTotIva += aTotTikCli[2]
            ::oDbf:nTotDoc += aTotTikCli[3]
            ::oDbf:nNumOpe++
            ::nTotalNeto   += aTotTikCli[1]

            ::oDbf:Save()

         else

            ::oDbf:Append()
            ::oDbf:Blank()

               ::oDbf:cCodCli := ::oTikCliT:cCliTik
               ::oDbf:cNomCli := ::oTikCliT:cNomTik
               ::oDbf:dFecMov := ::oTikCliT:dFecTik
               ::oDbf:nTotNet := aTotTikCli[1]
               ::oDbf:nTotIva := aTotTikCli[2]
               ::oDbf:nTotDoc := aTotTikCli[3]
               ::oDbf:nNumOpe := 1
               ::nTotalNeto   += aTotTikCli[1]

               ::AddCliente( ::oTikCliT:cCliTik, ::oTikCliT, .t. )

            ::oDbf:Save()

         end if

      end if

      ::oTikCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oTikCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ) )

   ::oMtrInf:AutoInc( ::oTikCliT:Lastrec() )

   ::oDlg:Enable()

   ::oDbf:OrdSetFocus( "NTOTNET" )

   ::oDbf:GoTop()
   while !::oDbf:Eof()
      ::oDbf:Load()
      ::oDbf:nPorVta := ( ::oDbf:nTotNet * 100 )/ ::nTotalNeto
      ::oDbf:Save()
      ::oDbf:Skip()
   end while

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//