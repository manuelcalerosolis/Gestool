#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS OAnuXAlb FROM TPrvGrpPrv

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oAlbPrvT    AS OBJECT
   DATA  oAlbPrvL    AS OBJECT
   DATA  oDbfPrv     AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Facturado", "No facturado", "Todos" } ;

   METHOD create ()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD create ()

   ::AnuFields()

   ::AddTmpIndex( "cCodGrp", "cCodGrp" )

RETURN ( self )
//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oAlbPrvT PATH ( cPatEmp() ) FILE "ALBPROVT.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVT.CDX"

   DATABASE NEW ::oAlbPrvL PATH ( cPatEmp() ) FILE "ALBPROVL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"

   DATABASE NEW ::oDbfPrv  PATH ( cPatPrv() ) FILE "PROVEE.DBF"   VIA ( cDriver() ) SHARED INDEX "PROVEE.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oAlbPrvT ) .and. ::oAlbPrvT:Used()
      ::oAlbPrvT:End()
   end if
   if !Empty( ::oAlbPrvL ) .and. ::oAlbPrvL:Used()
      ::oAlbPrvL:End()
   end if
   if !Empty( ::oDbfPrv ) .and. ::oDbfPrv:Used()
      ::oDbfPrv:End()
   end if

   ::oAlbPrvT := nil
   ::oAlbPrvL := nil
   ::oDbfPrv := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cEstado  := "Todos"

   ::lDefFecInf   := .f.

   if !::StdResource( "ANUGRPPRV" )
      return .f.
   end if

   /*Monta el año*/
   ::oDefYea( )

   /*Monta los desde - hasta*/
   if !::oDefGrpPrv ( 70, 71, 80, 81, 90 )
      return .f.
   end if

   /*Monta el check y el combo*/
   ::oDefExcInf()

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   /*Damos valor al meter*/
   ::oMtrInf:SetTotal( ::oAlbPrvT:Lastrec() )

   ::CreateFilter( aItmAlbPrv(), ::oAlbPrvT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead  := ""
   local cExpLine  := ""
   local cCodGrp

   /*Desabilitamos el diálogo para que no lo toquen mientras se procesa el informe*/
   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   /*Creamos los filtros para que entre sólo lo que interesa*/
   ::oAlbPrvT:OrdSetFocus( "dFecAlb" )
   ::oAlbPrvL:OrdSetFocus( "nNumAlb" )

   do case
      case ::oEstado:nAt == 1
         cExpHead    := '!lFacturado'
      case ::oEstado:nAt == 2
         cExpHead    := 'lFacturado'
      case ::oEstado:nAt == 3
         cExpHead    := '.t.'
   end case

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oAlbPrvT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbPrvT:cFile ), ::oAlbPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oAlbPrvT:OrdKeyCount() )

   cExpLine          := '!lControl'

   ::oAlbPrvL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbPrvL:cFile ), ::oAlbPrvL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oAlbPrvT:GoTop()

   while !::lBreak .and. !::oAlbPrvT:Eof()

      /*Tomamos el valor del grupo de proveedor*/
      cCodGrp        := cGruPrv( ::oAlbPrvT:cCodPrv, ::oDbfPrv )

      /*Comprobaciones previas*/
      if Year( ::oAlbPrvT:dFecAlb ) == ::nYeaInf                                           .AND.;
         ( ::lGrpPrvAll .or. ( cCodGrp >= ::cGrpPrvOrg .AND. cCodGrp <= ::cGrpPrvDes ) )   .AND.;
         lChkSer( ::oAlbPrvT:cSerAlb, ::aSer )

         if ::oAlbPrvL:Seek( ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb )

            while ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb == ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb .AND. ! ::oAlbPrvL:eof()

               if !( ::lExcCero .AND. nImpLAlbPrv( ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                  /*Cargamos los valores del informe*/

                  if !::oDbf:Seek( cCodGrp )
                     ::oDbf:Blank()
                     ::oDbf:cCodGrp    := cCodGrp
                     ::oDbf:cNomGrp    := cNomGrp( cCodGrp, ::oGrpPrv:oDbf )
                     ::oDbf:Insert()
                  end if

                  ::AddImporte( ::oAlbPrvT:dFecAlb, nImpLAlbPrv( ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )

               end if

               ::oAlbPrvL:Skip()

            end while

         end if

      end if

      ::oAlbPrvT:Skip()

      ::oMtrInf:AutoInc( ::oAlbPrvT:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oAlbPrvT:Lastrec() )

   /*Destruimos los filtros*/
   ::oAlbPrvT:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbPrvT:cFile ) )
   ::oAlbPrvL:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbPrvL:cFile ) )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//