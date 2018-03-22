#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS oAnuGPed FROM TPrvGrp

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oPedPrvT    AS OBJECT
   DATA  oPedPrvL    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Parcilamente", "Entregado", "Todos" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AnuGrpFields()

   ::AddTmpIndex( "cGrpFam", "cGrpFam" )

   ::lDefFecInf   := .f.
   ::lDefGraph    := .t.

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()


   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oPedPrvT PATH ( cPatEmp() ) FILE "PEDPROVT.DBF" VIA ( cDriver() ) SHARED INDEX "PEDPROVT.CDX"

   DATABASE NEW ::oPedPrvL PATH ( cPatEmp() ) FILE "PEDPROVL.DBF" VIA ( cDriver() ) SHARED INDEX "PEDPROVL.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oPedPrvT ) .and. ::oPedPrvT:Used()
      ::oPedPrvT:End()
   end if
   if !Empty( ::oPedPrvL ) .and. ::oPedPrvL:Used()
      ::oPedPrvL:End()
   end if

   ::oPedPrvT := nil
   ::oPedPrvL := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cEstado := "Todos"

   if !::StdResource( "InfAnuGrp" )
      return .f.
   end if

   ::oDefYea( )

   if !::oDefGrFInf( 70, 80, 90, 100, 900 )
      return .f.
   end if

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   ::oDefExcInf(200)

   ::oMtrInf:SetTotal( ::oPedPrvT:Lastrec() )

   ::CreateFilter( aItmPedPrv(), ::oPedPrvT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead    := ""
   local cExpLine    := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader         := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                           {|| "Año     : " + AllTrim( Str( ::nYeaInf ) ) },;
                           {|| "Grp.Fam.: " + if( ::lAllGrp, "Todos", AllTrim( ::cGruFamOrg ) + " > " + AllTrim( ::cGruFamDes ) ) } }

   ::oPedPrvT:OrdSetFocus( "dFecPed" )
   ::oPedPrvL:OrdSetFocus( "nNumPed" )

   do case
      case ::oEstado:nAt == 1
         cExpHead    := 'nEstado == 1'
      case ::oEstado:nAt == 2
         cExpHead    := 'nEstado == 2'
      case ::oEstado:nAt == 3
         cExpHead    := 'nEstado == 3'
      case ::oEstado:nAt == 4
         cExpHead    := '.t.'
   end case

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oPedPrvT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oPedPrvT:cFile ), ::oPedPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oPedPrvT:OrdKeyCount() )

   if !::lAllGrp
      cExpLine       := 'cGrpFam >= "' + ::cGruFamOrg + '" .and. cGrpFam <= "' + ::cGruFamDes + '"'
   else
      cExpLine       := '.t.'
   end if

   ::oPedPrvL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oPedPrvL:cFile ), ::oPedPrvL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oPedPrvT:GoTop()

   while !::lBreak .and. !::oPedPrvT:Eof()

      if Year( ::oPedPrvT:dFecPed ) == ::nYeaInf                                            .AND.;
         lChkSer( ::oPedPrvT:cSerPed, ::aSer )

         if ::oPedPrvL:Seek( ::oPedPrvT:cSerPed + Str( ::oPedPrvT:nNumPed ) + ::oPedPrvT:cSufPed )

            while ::oPedPrvT:cSerPed + Str( ::oPedPrvT:nNumPed ) + ::oPedPrvT:cSufPed == ::oPedPrvL:cSerPed + Str( ::oPedPrvL:nNumPed ) + ::oPedPrvL:cSufPed .AND. ! ::oPedPrvL:eof()

               if !( ::lExcCero .AND. nImpLPedPrv( ::oPedPrvT:cAlias, ::oPedPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                  if !::oDbf:Seek( ::oPedPrvL:cGrpFam )
                     ::oDbf:Blank()
                     ::oDbf:cGrpFam := ::oPedPrvL:cGrpFam
                     ::oDbf:cNomGrp := oRetFld( ::oDbf:cGrpFam, ::oGruFam:oDbf )
                     ::oDbf:Insert()
                  end if

                  ::AddImporte( ::oPedPrvT:dFecPed, nImpLPedPrv( ::oPedPrvT:cAlias, ::oPedPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )

               end if

               ::oPedPrvL:Skip()

            end while

         end if

      end if

      ::oPedPrvT:Skip()

      ::oMtrInf:AutoInc( ::oPedPrvT:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oPedPrvT:Lastrec() )

   ::oPedPrvT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oPedPrvT:cFile ) )
   ::oPedPrvL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oPedPrvL:cFile ) )

   if !::lExcCero
      ::IncluyeCero()
   end if

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//