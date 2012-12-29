#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch"
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TAcuNAlb FROM TInfPAge

   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oDbfTvta    AS OBJECT
   DATA  lTvta       AS LOGIC    INIT .f.
   DATA  cTipVen
   DATA  cTipVen2
   DATA  oEstado     AS OBJECT
   DATA  aEstado     AS ARRAY    INIT { "No facturados", "Facturados", "Todos" }

   METHOD Create ()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//
/*Creamos la temporal, los ordenes y los grupos*/

METHOD Create()

   ::AcuCreate()

   ::AddTmpIndex( "cCodAge", "cCodAge" )

   ::AddGroup( {|| ::oDbf:cCodAge }, {|| "Agente : " + Rtrim( ::oDbf:cCodAge ) + "-" + Rtrim( ::oDbf:cNomAge ) }, {|| "Total Agente..." } )

RETURN ( self )

//---------------------------------------------------------------------------//
/*Abrimos las tablas necesarias*/

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oAlbCliT PATH ( cPatEmp() ) FILE "ALBCLIT.DBF"  VIA ( cDriver() ) SHARED INDEX "ALBCLIT.CDX"

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "ALBCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   DATABASE NEW ::oDbfTvta PATH ( cPatDat() ) FILE "TVTA.DBF"     VIA ( cDriver() ) SHARED INDEX "TVTA.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//
/*
Cerramos las tablas abiertas anteriormente
*/

METHOD CloseFiles()

   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if

   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if

   if !Empty( ::oDbfTvta ) .and. ::oDbfTvta:Used()
      ::oDbfTvta:End()
   end if

   ::oAlbCliT := nil
   ::oAlbCliL := nil
   ::oDbfTvta := nil

RETURN ( Self )

//---------------------------------------------------------------------------//
/*Se montan los recursos*/

METHOD lResource( cFld )

   local oTipVen
   local oTipVen2
   local cEstado     := "Todos"
   local This        := Self

   if !::StdResource( "INF_GEN17RR" )
      return .f.
   end if

   /*
   Se montan los desde - hasta
   */

   if !::oDefAgeInf( 70, 80, 90, 100, 930 )
      return .f.
   end if

   if !::lDefArtInf( 150, 160, 170, 180, 800 )
      return .f.
   end if

   /*
   Montamos los controles para aplicar o no los tipos de ventas
   */

   REDEFINE CHECKBOX ::lTvta ;
      ID       260 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oTipVen VAR ::cTipVen ;
      VALID    ( cTVta( oTipVen, This:oDbfTvta:cAlias, oTipVen2 ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwTVta( oTipVen, This:oDbfTVta:cAlias, oTipVen2 ) ) ;
      ID       270 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oTipVen2 VAR ::cTipVen2 ;
      ID       280 ;
      WHEN     ( .F. ) ;
      COLOR    CLR_GET ;
      OF       ::oFld:aDialogs[1]

   /*Check para no dejar pasar las líneas con precio 0*/

   ::oDefExcInf( 210 )
   ::oDefExcImp( 211 )

   /*Definimos el combo con los tipos de albaranes*/

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   /*Damos valor al meter*/

   ::oMtrInf:SetTotal( ::oAlbCliT:Lastrec() )

   ::CreateFilter( aItmAlbCli(), ::oAlbCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*Generamos el informe*/

METHOD lGenerate()

   local cExpHead    := ""
   local cExpLine    := ""

   /*Desabilita el diálogo y vacía la dbf temporal*/

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha        : " + Dtoc( Date() ) },;
                        {|| "Periodo      : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Agentes      : " + if( ::lAgeAll, "Todos", AllTrim( ::cAgeOrg ) + " > " + AllTrim( ::cAgeDes ) ) },;
                        {|| "Artículos    : " + if( ::lAllArt, "Todos", AllTrim( ::cArtOrg ) + " > " + AllTrim( ::cArtDes ) ) },;
                        {|| "Estado       : " + ::aEstado[ ::oEstado:nAt ] },;
                        {|| if( ::lTvta, (if (!Empty( ::cTipVen ), "Tipo de Venta: " + ::cTipVen2, "Tipo de Venta: Todos" ) ), "Tipo de Venta: Ninguno" ) },;
                        {|| if( ::lTvta, "Aplicando comportamiento de los tipos de venta", "" ) } }

   /*Monta los filtros para las tablas de albarán*/

   ::oAlbCliT:OrdSetFocus( "dFecAlb" )
   ::oAlbCliL:OrdSetFocus( "nNumAlb" )

   do case
      case ::oEstado:nAt == 1
         cExpHead    := '!lFacturado .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 2
         cExpHead    := 'lFacturado.and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      otherwise
         cExpHead    := 'dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   end case

   if !::lAgeAll
      cExpHead       += '.and. cCodAge >= "' + Rtrim( ::cAgeOrg ) + '" .and. cCodAge <= "' + Rtrim( ::cAgeDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpFilter
   end if

   ::oAlbCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ), ::oAlbCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oAlbCliT:OrdKeyCount() )

   cExpLine          := '!lTotLin .and. !lControl'

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oAlbCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbCliL:cFile ), ::oAlbCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   /*Recorremos las cabeceras y líneas*/

   ::oAlbCliT:GoTop()

   while !::lBreak .and. !::oAlbCliT:Eof()

     if lChkSer( ::oAlbCliT:cSerAlb, ::aSer )   .and.;
        ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

        while ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb == ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb .AND. ! ::oAlbCliL:eof()

           if  !( ::lExcCero .AND. nTotNAlbCli( ::oAlbCliL:cAlias ) == 0 ) .and.;
               !( ::lExcImp .AND. nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

              /*Llenamos la base de datos temporal*/

              if ::lTvta

                 /*Aplicamos los tipos de venta*/

                 if ( if (!Empty( ::cTipVen ), ::oAlbCliL:cTipMov == ::cTipVen, .t. ) )

                     if !::oDbf:Seek( ::oAlbCliT:cCodAge + ::oAlbCliL:cRef )

                        ::oDbf:Append()

                        ::oDbf:cCodAge    := ::oAlbCliT:cCodAge
                        if ( ::oDbfAge:Seek (::oAlbCliT:cCodAge) )
                           ::oDbf:cNomAge := AllTrim ( ::oDbfAge:cApeAge ) + ", " + AllTrim ( ::oDbfAge:cNbrAge )
                        end if

                        ::oDbf:cCodArt    := ::oAlbCliL:cRef
                        ::oDbf:cNomArt    := ::oAlbCliL:cDetalle

                        if ::oDbfTvta:Seek( ::oAlbCliL:cTipMov )

                           if ::oDbfTvta:nUndMov == 1
                              ::oDbf:nNumCaj := ::oAlbCliL:nCanEnt
                              ::oDbf:nUniDad := ::oAlbCliL:nUniCaja
                              ::oDbf:nNumUni := nTotNAlbCli( ::oAlbCliL )
                           elseif ::oDbfTvta:nUndMov == 2
                              ::oDbf:nNumCaj := -( ::oAlbCliL:nCanEnt )
                              ::oDbf:nUniDad := -( ::oAlbCliL:nUniCaja )
                              ::oDbf:nNumUni := -( nTotNAlbCli( ::oAlbCliL ) )
                           elseif ::oDbfTvta:nUndMov == 3
                              ::oDbf:nNumCaj := 0
                              ::oDbf:nUniDad := 0
                              ::oDbf:nNumUni := 0
                           end if

                           if ::oDbfTvta:nImpMov == 1
                              ::oDbf:nTotCom := nComLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )
                              ::oDbf:nImpTot := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )
                              ::oDbf:nImpArt := nTotUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
                              ::oDbf:nIvaTot := nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .t., .t., .t. )
                           elseif ::oDbfTvta:nImpMov == 2
                              ::oDbf:nTotCom := -( nComLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut ) )
                              ::oDbf:nImpTot := -( nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut ) )
                              ::oDbf:nImpArt := -( nTotUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv ) )
                              ::oDbf:nIvaTot := -( nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .t., .t., .t. ) )
                           elseif ::oDbfTvta:nImpMov == 3
                              ::oDbf:nTotCom := 0
                              ::oDbf:nImpTot := 0
                              ::oDbf:nImpArt := 0
                              ::oDbf:nIvaTot := 0
                           end if

                        end if

                        ::oDbf:nImpTrn    := nTrnUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
                        ::oDbf:nPntVer    := nPntUAlbCli( ::oAlbCliL:cAlias, ::nDecPnt, ::nValDiv )
                        ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot
                        ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni

                        ::AcuPesVol( ::oAlbCliL:cRef, nTotNAlbCli( ::oAlbCliL ), ::oDbf:nImpTot, .f. )

                        ::oDbf:Save()

                     else

                        ::oDbf:Load()

                        if ::oDbfTvta:Seek( ::oAlbCliL:cTipMov )

                           if ::oDbfTvta:nUndMov == 1
                              ::oDbf:nNumCaj += ::oAlbCliL:nCanEnt
                              ::oDbf:nUniDad += ::oAlbCliL:nUniCaja
                              ::oDbf:nNumUni += nTotNAlbCli( ::oAlbCliL )
                           elseif ::oDbfTvta:nUndMov == 2
                              ::oDbf:nNumCaj += -( ::oAlbCliL:nCanEnt )
                              ::oDbf:nUniDad += -( ::oAlbCliL:nUniCaja )
                              ::oDbf:nNumUni += -( nTotNAlbCli( ::oAlbCliL ) )
                           elseif ::oDbfTvta:nUndMov == 3
                              ::oDbf:nNumCaj += 0
                              ::oDbf:nUniDad += 0
                              ::oDbf:nNumUni += 0
                           end if

                           if ::oDbfTvta:nImpMov == 1
                              ::oDbf:nTotCom += nComLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )
                              ::oDbf:nImpTot += nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )
                              ::oDbf:nImpArt += nTotUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
                              ::oDbf:nIvaTot += nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .t., .t., .t. )
                              ::oDbf:nTotFin += nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
                              ::oDbf:nTotFin += nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .t., .t., .t. )
                           elseif ::oDbfTvta:nImpMov == 2
                              ::oDbf:nTotCom += -( nComLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut ) )
                              ::oDbf:nImpTot += -( nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut ) )
                              ::oDbf:nImpArt += -( nTotUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv ) )
                              ::oDbf:nIvaTot += -( nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .t., .t., .t. ) )
                              ::oDbf:nTotFin += -( nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  ) )
                              ::oDbf:nTotFin += -( nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .t., .t., .t. ) )
                           elseif ::oDbfTvta:nImpMov == 3
                              ::oDbf:nTotCom += 0
                              ::oDbf:nImpTot += 0
                              ::oDbf:nImpArt += 0
                              ::oDbf:nIvaTot += 0
                              ::oDbf:nTotFin += 0
                              ::oDbf:nTotFin += 0
                           end if

                        end if

                        ::oDbf:nImpTrn    += nTrnUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
                        ::oDbf:nPntVer    += nPntUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
                        ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni

                        ::AcuPesVol( ::oAlbCliL:cRef, nTotNAlbCli( ::oAlbCliL ), ::oDbf:nImpTot, .t. )

                        ::oDbf:Save()

                     end if

                 end if

              else

                 /*Pasamos de los tipos venta*/

                 ::AcuAlb()

              end if

           end if

           ::oAlbCliL:Skip()

        end while

     end if

     ::oAlbCliT:Skip()

     ::oMtrInf:AutoInc()

   end while

   /*Destruimos los filtros creados anteriormente*/

   ::oAlbCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ) )
   ::oAlbCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbCliL:cFile ) )

   ::oMtrInf:AutoInc( ::oAlbCliT:Lastrec() )

   /*Incluimos almacenes y artículos sin movimiento*/

   if !::lExcCero
      ::IncluyeCeroArt()
   end if

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//