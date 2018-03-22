#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS OAnuXFac FROM TPrvGrpPrv

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oFacPrvT    AS OBJECT
   DATA  oFacPrvL    AS OBJECT
   DATA  oDbfPrv     AS OBJECT
   DATA  aEstado     AS ARRAY    INIT { "Liquidadas", "Pendientes", "Todas" }

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

   DATABASE NEW ::oFacPrvT PATH ( cPatEmp() ) FILE "FACPRVT.DBF"  VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"

   DATABASE NEW ::oFacPrvL PATH ( cPatEmp() ) FILE "FACPRVL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"

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

   if !Empty( ::oFacPrvT ) .and. ::oFacPrvT:Used()
      ::oFacPrvT:End()
   end if
   if !Empty( ::oFacPrvL ) .and. ::oFacPrvL:Used()
      ::oFacPrvL:End()
   end if
   if !Empty( ::oDbfPrv ) .and. ::oDbfPrv:Used()
      ::oDbfPrv:End()
   end if

   ::oFacPrvT := nil
   ::oFacPrvL := nil
   ::oDbfPrv := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cEstado  := "Todas"

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
   ::oMtrInf:SetTotal( ::oFacPrvT:Lastrec() )

   ::CreateFilter( aItmFacPrv(), ::oFacPrvT:cAlias )

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
   ::oFacPrvT:OrdSetFocus( "dFecFac" )
   ::oFacPrvL:OrdSetFocus( "nNumFac" )

   do case
      case ::oEstado:nAt == 1
         cExpHead    := 'lLiquidada'
      case ::oEstado:nAt == 2
         cExpHead    := '!lLiquidada'
      case ::oEstado:nAt == 3
         cExpHead    := '.t.'
   end case

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacPrvT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacPrvT:cFile ), ::oFacPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacPrvT:OrdKeyCount() )

   cExpLine          := '!lControl'

   ::oFacPrvL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacPrvL:cFile ), ::oFacPrvL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacPrvT:GoTop()

   while !::lBreak .and.! ::oFacPrvT:Eof()

      /*Tomamos el valor del grupo de proveedor*/
      cCodGrp        := cGruPrv( ::oFacPrvT:cCodPrv, ::oDbfPrv )

      /*Comprobaciones previas*/
      if Year( ::oFacPrvT:dFecFac ) == ::nYeaInf                                           .AND.;
         ( ::lGrpPrvAll .or. ( cCodGrp >= ::cGrpPrvOrg .AND. cCodGrp <= ::cGrpPrvDes ) )   .AND.;
         lChkSer( ::oFacPrvT:cSerFac, ::aSer )

         if ::oFacPrvL:Seek( ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac )

            while ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac == ::oFacPrvL:cSerFac + Str( ::oFacPrvL:nNumFac ) + ::oFacPrvL:cSufFac .AND. ! ::oFacPrvL:eof()

               if !( ::lExcCero .AND. nImpLFacPrv( ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                  /*Cargamos los valores del informe*/

                  if !::oDbf:Seek( cCodGrp )
                     ::oDbf:Blank()
                     ::oDbf:cCodGrp    := cCodGrp
                     ::oDbf:cNomGrp    := cNomGrp( cCodGrp, ::oGrpPrv:oDbf )
                     ::oDbf:Insert()
                  end if

                  ::AddImporte( ::oFacPrvT:dFecFac, nImpLFacPrv( ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )

               end if

               ::oFacPrvL:Skip()

            end while

         end if

      end if

      ::oFacPrvT:Skip()

      ::oMtrInf:AutoInc( ::oFacPrvT:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oFacPrvT:Lastrec() )

   /*Destruimos los filtros*/
   ::oFacPrvT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacPrvT:cFile ) )
   ::oFacPrvL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacPrvL:cFile ) )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//