#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfArtAlb FROM TInfGen

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "No facturado", "Facturado", "Todos" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create() CLASS TInfArtAlb

   ::AddField(  "CCODART", "C", 18, 0, {|| "@!" },            "Código artículo",    .f., "Código artículo" , 14 )
   ::AddField(  "CNOMART", "C",100, 0, {|| "@!" },            "Nom. Art.",    .f., "Nombre artículo" , 35 )
   ::AddField(  "CDOCMOV", "C", 18, 0, {|| "@!" },            "Albaran",      .t., "Albaran"         , 10 )
   ::AddField(  "DFECMOV", "D",  8, 0, {|| "@!" },            "Fecha",        .t., "Fecha"           ,  8 )
   ::AddField(  "NNUMCAJ", "N", 13, 6, {|| MasUnd() },        "Caj.",         .t., "Cajas"           , 12 )
   ::AddField(  "NUNIDAD", "N", 16, 6, {|| MasUnd() },        "Und.",         .t., "Unidades"        , 12 )
   ::AddField(  "NNUMUNI", "N", 13, 6, {|| MasUnd() },        "Tot. Und.",    .t., "Total unidades"  , 12 )
   ::AddField(  "NIMPART", "N", 13, 6, {|| ::cPicOut },       "Importe",      .t., "Importe"         , 12 )
   ::AddField(  "CTIPVEN", "C", 20, 0, {|| "@!" },            "Venta",        .t., "Tipo de venta"   , 10 )

   ::AddTmpIndex( "cCodArt", "cCodArt" )

   ::AddGroup( {|| ::oDbf:cCodArt }, {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( ::oDbf:cNomArt ) }, {||""} )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TInfArtAlb

  local oBlock
  local oError
  local lOpen := .t.

   /*
   Ficheros necesarios
   */

   oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"
   ::oAlbCliL:SetOrder( "CREF" )

   RECOVER USING oError

      lOpen := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TInfArtAlb

   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if

   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld ) CLASS TInfArtAlb

   local cEstado := "Todos"

   if !::StdResource( "INF_GEN10A" )
      return .f.
   end if

   /*
   Monta los articulos de manera automatica
   */

   ::lDefArtInf( 110, 120, 130, 140 )

   /*
   Damos valor al meter--------------------------------------------------------
   */

   ::oMtrInf:SetTotal( ::oDbfArt:Lastrec() )

   ::oDefExcInf( 204 )

   ::oDefExcImp( 205 )

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmArt(), ::oDbfArt )

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TInfArtAlb

   local bValid   := {|| .t. }

   ::oDlg:Disable()

   ::oDbf:Zap()

   ::oDbfArt:GoTop()

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| !lFacturado( ::oAlbCliT ) }
      case ::oEstado:nAt == 2
         bValid   := {|| lFacturado( ::oAlbCliT ) }
   end case

   ::aHeader      := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                        {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Artículo: " + ::cArtOrg         + " > " + ::cArtDes },;
                        {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ] } }

   WHILE !::oDbfArt:Eof()

      IF ::oDbfArt:Codigo >= ::cArtOrg .AND. ::oDbfArt:Codigo <= ::cArtDes

         IF ::oAlbCliL:Seek( ::oDbfArt:Codigo )

         WHILE ::oAlbCliL:cRef == ::oDbfArt:Codigo .AND. !::oAlbCliL:Eof()

            if ::oAlbCliT:Seek( ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb )

               if Eval ( bValid )                                                         .AND.;
                  ::oAlbCliT:dFecAlb >= ::dIniInf                                         .AND.;
                  ::oAlbCliT:dFecAlb <= ::dFinInf                                         .AND.;
                  ::oDbfArt:CODIGO >= ::cArtOrg                                           .AND.;
                  ::oDbfArt:CODIGO <= ::cArtDes                                           .AND.;
                  lChkSer( ::oAlbCliT:cSerAlb, ::aSer )                                   .AND.;
                  !( ::lExcCero .AND. ::oAlbCliL:NPREDIV == 0 )

                  /*
                  Añadimos un nuevo registro
                  */

                  ::oDbf:Append()

                  ::oDbf:CCODART    := ::oDbfArt:CODIGO
                  ::oDbf:CNOMART    := ::oDbfArt:NOMBRE
                  ::oDbf:NNUMCAJ    := ::oAlbCliL:nCanEnt
                  ::oDbf:NUNIDAD    := ::oAlbCliL:NUNICAJA
                  ::oDbf:NNUMUNI    := nTotNAlbCli( ::oAlbCliL )
                  ::oDbf:NIMPART    := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:CDOCMOV    := Alltrim( ::oAlbCliL:CSERALB + "/" + Str( ::oAlbCliL:NNUMALB ) + "/" + ::oAlbCliL:CSUFALB )
                  ::oDbf:DFECMOV    := ::oAlbCliT:DFECALB

                  ::oDbf:Save()

               end if

            end if

            ::oAlbCliL:Skip()

         END WHILE

         END IF

      END IF

      ::oDbfArt:Skip()
      ::oMtrInf:AutoInc( ::oDbfArt:OrdKeyNo() )

   END WHILE

   ::oMtrInf:AutoInc( ::oDbfArt:OrdKeyNo() )
   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//