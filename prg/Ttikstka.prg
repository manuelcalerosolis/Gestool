#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch"
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TTikStkA FROM TInfGen

   DATA  oStock         AS OBJECT
   DATA  oEstado        AS OBJECT
   DATA  lControlStock  AS LOGIC    INIT .f.
   DATA  oPedPrvL
   DATA  oAlbPrvL
   DATA  oFacPrvL
   DATA  oRctPrvL
   DATA  oPedCliL
   DATA  oAlbCliL
   DATA  oFacCliL
   DATA  oFacRecL
   DATA  oTikCliL
   DATA  oPedCliR
   DATA  oHisMov
   DATA  oProLin
   DATA  oProMat

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( lImpTik )

   METHOD lGenerate()

   METHOD oDefIniInf() VIRTUAL

   METHOD oDefFinInf() VIRTUAL

   METHOD oDefDivInf() VIRTUAL

   METHOD nTotReserva( cCodArt )

   METHOD PrnTiket( lPrev )

   END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodAlm", "C",  3, 0, {|| "@!" },            "Cod. alm.",     .f., "Código almacén",      3 )
   ::AddField( "cCodArt", "C", 18, 0, {|| "@!" },            "Código",        .t., "Código artículo",     8 )
   ::AddField( "cDesArt", "C", 20, 0, {|| "@!" },            "Des. breve",    .t., "Descripción breve",   40)
   ::AddField( "cNomArt", "C", 50, 0, {|| "@!" },            "Descripción",   .f., "Descripción",         40)
   ::AddField( "nNumUnd", "N", 19, 6, {|| MasUnd() },        "Stock",         .t., "Stock",               13)
   ::AddField( "nStkCmp", "N", 19, 6, {|| MasUnd() },        "Stock comp.",   .f., "Stock comprometido",  13)
   ::AddField( "nStkLib", "N", 19, 6, {|| MasUnd() },        "Stock libre",   .f., "Stock libre",         13)

   if ::xOthers
   ::AddTmpIndex( "cDesArt", "cCodAlm + cDesArt" )
   else
   ::AddTmpIndex( "cNomArt", "cCodAlm + cNomArt" )
   end if
   ::AddTmpIndex( "cCodArt", "cCodAlm + cCodArt" )

   ::AddGroup( {|| ::oDbf:cCodAlm }, {|| "Almacén : " + Rtrim( ::oDbf:cCodAlm ) + "-" + oRetFld( ::oDbf:cCodAlm, ::oDbfAlm ) }, {||"Total almacén..."} )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oPedPrvL    PATH ( cPatEmp() ) FILE "PedProvL.DBF" VIA ( cDriver() ) SHARED INDEX "PedProvL.Cdx"

   DATABASE NEW ::oAlbPrvL    PATH ( cPatEmp() ) FILE "ALBPROVL.DBF"   VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"

   DATABASE NEW ::oFacPrvL    PATH ( cPatEmp() ) FILE "FACPRVL.DBF"    VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"

   DATABASE NEW ::oRctPrvL    PATH ( cPatEmp() ) FILE "RctPrvL.DBF"  VIA ( cDriver() ) SHARED INDEX "RctPrvL.Cdx"

   DATABASE NEW ::oPedCliL    PATH ( cPatEmp() ) FILE "PedCliL.DBF"  VIA ( cDriver() ) SHARED INDEX "PedCliL.Cdx"

   DATABASE NEW ::oAlbCliL  PATH ( cPatEmp() ) FILE "ALBCLIL.DBF"    VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   DATABASE NEW ::oPedCliR  PATH ( cPatEmp() ) FILE "PEDCLIR.DBF"    VIA ( cDriver() ) SHARED INDEX "PEDCLIR.CDX"
   ::oPedCliR:OrdSetFocus( "cRef" )

   DATABASE NEW ::oFacCliL  PATH ( cPatEmp() ) FILE "FACCLIL.DBF"    VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oFacRecL  PATH ( cPatEmp() ) FILE "FACRECL.DBF"    VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   DATABASE NEW ::oTikCliL  PATH ( cPatEmp() ) FILE "TikeL.DBF"      VIA ( cDriver() ) SHARED INDEX "TikeL.CDX"

   DATABASE NEW ::oHisMov   PATH ( cPatEmp() ) FILE "HisMov.DBF"     VIA ( cDriver() ) SHARED INDEX "HisMov.CDX"

   DATABASE NEW ::oProLin    PATH ( cPatEmp() ) FILE "PROLIN.DBF"    VIA ( cDriver() ) SHARED INDEX "PROLIN.CDX"

   DATABASE NEW ::oProMat    PATH ( cPatEmp() ) FILE "PROMAT.DBF"    VIA ( cDriver() ) SHARED INDEX "PROMAT.CDX"

      ::oStock                := TStock():New()
      if !::oStock:lOpenFiles()
         lOpen                := .f.
      else
         ::oStock:cPedPrvL    := ::oPedPrvL:cAlias
         ::oStock:cAlbPrvL    := ::oAlbPrvL:cAlias
         ::oStock:cFacPrvL    := ::oFacPrvL:cAlias
         ::oStock:cRctPrvL    := ::oRctPrvL:cAlias
         ::oStock:cPedCliL    := ::oPedCliL:cAlias
         ::oStock:cAlbCliL    := ::oAlbCliL:cAlias
         ::oStock:cFacCliL    := ::oFacCliL:cAlias
         ::oStock:cFacRecL    := ::oFacRecL:cAlias
         ::oStock:cProducL    := ::oProLin:cAlias
         ::oStock:cProducM    := ::oProMat:cAlias
         ::oStock:cHisMov     := ::oHisMov:cAlias
         ::oStock:cTikL       := ::oTikCliL:cAlias
      end if

   RECOVER

      lOpen       := .f.
      msgStop( 'Imposible abrir todas las bases de datos' )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpen
      ::CloseFiles()
   end if

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oPedPrvL ) .and. ::oPedPrvL:Used()
      ::oPedPrvL:End()
   end if

   if !Empty( ::oAlbPrvL ) .and. ::oAlbPrvL:Used()
      ::oAlbPrvL:End()
   end if

   if !Empty( ::oFacPrvL ) .and. ::oFacPrvL:Used()
      ::oFacPrvL:End()
   end if

   if !Empty( ::oRctPrvL ) .and. ::oRctPrvL:Used()
      ::oRctPrvL:End()
   end if

   if !Empty( ::oPedCliL ) .and. ::oPedCliL:Used()
      ::oPedCliL:End()
   end if

   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if

   if !Empty( ::oPedCliR ) .and. ::oPedCliR:Used()
      ::oPedCliR:End()
   end if

   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if

   if !Empty( ::oFacRecL ) .and. ::oFacRecL:Used()
      ::oFacRecL:End()
   end if

   if !Empty( ::oTikCliL ) .and. ::oTikCliL:Used()
      ::oTikCliL:End()
   end if

   if !Empty( ::oHisMov ) .and. ::oHisMov:Used()
      ::oHisMov:End()
   end if

   if !Empty( ::oProLin ) .and. ::oProLin:Used()
      ::oProLin:End()
   end if

   if !Empty( ::oProMat ) .and. ::oProMat:Used()
      ::oProMat:End()
   end if

   if !Empty( ::oStock )
      ::oStock:End()
   end if

   ::oAlbPrvL := nil
   ::oFacPrvL := nil
   ::oAlbCliL := nil
   ::oPedCliR := nil
   ::oFacCliL := nil
   ::oFacRecL := nil
   ::oTikCliL := nil
   ::oHisMov  := nil
   ::oProLin  := nil
   ::oProMat  := nil
   ::oStock   := nil

RETURN ( Self )

//---------------------------------------------------------------------------//


METHOD lResource()

   local cEstado  := "Nombre"

   ::lDefFecInf   := .f.
   ::lDefSerInf   := .f.

   if !::StdResource( "INF_GEN03C" )
      return .f.
   end if

   /*
   Monta los almacenes de manera automatica
   */

   if !::oDefAlmInf( 70, 80, 90, 100, 600 )
      return .f.
   end if

   /*
   Monta los proveedores de manera automatica----------------------------------
   */

   if !::lDefArtInf( 110, 120, 130, 140, 800 )
      return .f.
   end if

   REDEFINE CHECKBOX ::lControlStock ;
      ID       190 ;
      OF       ::oFld:aDialogs[1]

   /*
   Ordenado por----------------------------------------------------------------
   */

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    { "Nombre", "Código" } ;
      OF       ::oFld:aDialogs[1]

   ::oDefExcInf( 210 )

   /*
   Damos valor al meter
   */

   if ::xOthers

      ::oBtnAction:bAction    := {|| if( ::lGenerate(), ::PrnTiket( ::oCmbReport:nAt == 1 ), msgStop( "No hay registros en las condiciones solictadas" ) ) }

   end if

   ::oMtrInf:SetTotal( ::oDbfArt:OrdKeyCount() )

   ::CreateFilter( aItmArt(), ::oDbfArt:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpAlm        := ""
   local cExpArt        := ""
   local nStockActual   := 0

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha      : " + Dtoc( Date() ) },;
                        {|| "Almacenes  : " + if( ::lAllAlm, "Todos", AllTrim( ::cAlmOrg ) + " > " + AllTrim( ::cAlmDes ) ) },;
                        {|| "Artículos  : " + if( ::lAllArt, "Todos", AllTrim( ::cArtOrg ) + " > " + AllTrim( ::cArtDes ) ) } }

   ::oDbfAlm:OrdSetFocus( "cCodAlm" )
   ::oDbfArt:OrdSetFocus( "Codigo" )

   if !::lAllAlm
      cExpAlm        += 'cCodAlm >= "' + Rtrim( ::cAlmOrg ) + '" .and. cCodAlm <= "' + Rtrim( ::cAlmDes ) + '"'
   else
      cExpAlm        += '.t.'
   end if

   ::oDbfAlm:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oDbfAlm:cFile ), ::oDbfAlm:OrdKey(), ( cExpAlm ), , , , , , , , .t. )

   cExpArt           := 'nCtlStock != 3'

   if !::lAllArt
      cExpArt        += ' .and. Codigo >= "' + Rtrim( ::cArtOrg ) + '" .and. Codigo <= "' + Rtrim( ::cArtDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpFilter )
      cExpArt        += ' .and. ' + ::oFilter:cExpFilter
   end if

   ::oDbfArt:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oDbfArt:cFile ), ::oDbfArt:OrdKey(), ( cExpArt ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oDbfArt:OrdKeyCount() )

   ::oDbfAlm:GoTop()

   while !::lBreak .and. !::oDbfAlm:Eof()

      if !Empty( ::oDbfAlm:cCodAlm )

         ::oMtrInf:cText   := ::oDbfAlm:cNomAlm

         ::oDbfArt:GoTop()

         while !::lBreak .and. !::oDbfArt:Eof()

            if ( ( ::lControlStock .and. ::oDbfArt:nCtlStock == 1 ) .or. !::lControlStock )

               nStockActual   := ::oStock:nStockAlmacen( ::oDbfArt:Codigo, ::oDbfAlm:cCodAlm )

               if !( ::lExcCero .AND. nStockActual == 0 )

                  ::oDbf:Append()

                  ::oDbf:cCodAlm := ::oDbfAlm:cCodAlm
                  ::oDbf:cCodArt := ::oDbfArt:Codigo
                  ::oDbf:cNomArt := ::oDbfArt:Nombre
                  ::oDbf:cDesArt := if( Empty( ::oDbfArt:cDesTik ), ::oDbfArt:Nombre, ::oDbfArt:cDesTik )
                  ::oDbf:nNumUnd := nStockActual
                  ::oDbf:nStkCmp := ::nTotReserva( ::oDbfArt:Codigo )
                  ::oDbf:nStkLib := nStockActual - ::oDbf:nStkCmp

                  ::oDbf:Save()

               end if

            end if

            ::oDbfArt:Skip()

            ::oMtrInf:AutoInc( ::oDbfArt:OrdKeyNo() )

         end while

         ::oMtrInf:AutoInc( ::oDbfArt:LastRec() )

      end if

      ::oDbfAlm:Skip()

   end while

   ::oDbfAlm:IdxDelete( cCurUsr(), GetFileNoExt( ::oDbfAlm:cFile ) )

   ::oDbfArt:IdxDelete( cCurUsr(), GetFileNoExt( ::oDbfArt:cFile ) )

   ::oDlg:Enable()

   ::oDbf:OrdSetFocus( ::oEstado:nAt )

RETURN ( ::oDbf:RecCount() > 0 )

//---------------------------------------------------------------------------//

METHOD PrnTiket( lPrev )

   local oPrnTik
   local cCodAlm     := Space( 3 )
   local cImpTik     := cImpresoraTicketEnCaja( oUser():cCaja() )

   DEFAULT lPrev     := .t.

   oPrnTik           := TImpresoraTiket():Create( cImpTik, lPrev )

   if Empty( oPrnTik:cPort )
      MsgStop( "No hay puerto de impresora" )
      return nil
   end if

   if !oPrnTik:lBuildComm()
      MsgStop( "No se puede crear un handle a la impresora" )
      return nil
   end if

   /*
   Impresi¢n de Tiket. Titulo Centrado y enfatizado----------------------------
	*/

   oPrnTik:Write( PadC( Rtrim( ::cTitle ), 40 )       + CRLF )
   oPrnTik:Write( PadC( Rtrim( ::cSubTitle ), 40 )    + CRLF )
   oPrnTik:Write( CRLF )
   oPrnTik:Write( CRLF )

   ::oDbf:OrdSetFocus( ::oEstado:nAt )

   ::oDbf:GoTop()
   while !::oDbf:Eof()

      if ::oDbf:cCodAlm != cCodAlm
         oPrnTik:Write( Replicate( "-", 40 ) + CRLF )
         oPrnTik:Write( "Almacén : " + ::oDbf:cCodAlm + CRLF )
         oPrnTik:Write( Replicate( "-", 40 ) + CRLF )
         oPrnTik:Write( Padr( "Código", 8 ) + Space( 1 ) + Padr( "Artículo", 20 ) + Space( 1 ) + Padl( "Unidades", 10 ) + CRLF )
         oPrnTik:Write( Replicate( "-", 40 ) + CRLF )
         cCodAlm     := ::oDbf:cCodAlm
      end if

      oPrnTik:Write( left( ::oDbf:cCodArt, 8 ) + Space( 1 ) + Padr( ::oDbf:cDesArt, 20 ) + Space( 1 ) + Trans( ::oDbf:nNumUnd, Right( MasUnd(), 10 ) ) + CRLF )

      ::oDbf:Skip()

   end while

   oPrnTik:Write( Replicate( "-", 40 ) + CRLF )

   oPrnTik:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD nTotReserva( cCodArt )

   local nTotal  := 0

   if ::oPedCliR:Seek( cCodArt )

      while ::oPedCliR:cRef == cCodArt .and. !::oPedCliR:Eof()

         nTotal += nTotRPedCli( ::oPedCliR:cSerPed + Str( ::oPedCliR:nNumPed ) + ::oPedCliR:cSufPed, ::oPedCliR:cRef, ::oPedCliR:cValPr1, ::oPedCliR:cValPr2, ::oPedCliR:cAlias )

      ::oPedCliR:Skip()

      end while

   end if

RETURN ( nTotal )

//---------------------------------------------------------------------------//