#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TAnuAAlb FROM TInfAlm

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
    
   DATA  aEstado     AS ARRAY    INIT  { "No facturado", "Facturado", "Todos" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::CreateFldAnu()

   ::AddTmpIndex( "CCODALM", "CCODALM" )

   ::lDefFecInf   := .f.
   ::lDefGraph    := .t.

RETURN ( self )

//---------------------------------------------------------------------------//
METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   DATABASE NEW ::oDbfCli  PATH ( cPatCli() ) FILE "CLIENT.DBF" VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

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
   if !Empty( ::oDbfCli ) .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if

   ::oAlbCliT := nil
   ::oAlbCliL := nil
   ::oDbfCli  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld )

   local cEstado := "Todos"

   if !::StdResource( "INF_GEN01N" )
      return .f.
   end if

   /*
   Monta los años
   */

   ::oDefYea()

   /*
   Monta los almacenes de manera automatica
   */

   if !::oDefAlmInf( 70, 80, 90, 100, 700 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oAlbCliT:Lastrec() )

   ::oDefExcInf()

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmAlbCli(), ::oAlbCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead := ""
   local cExpLine := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                        {|| "Año     : " + AllTrim( Str( ::nYeaInf ) ) },;
                        {|| "Almacén : " + if( ::lAllAlm, "Todos", AllTrim( ::cAlmOrg ) + " > " + AllTrim( ::cAlmDes ) ) } ,;
                        {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ] } }

   ::oAlbCliT:OrdSetFocus( "dFecAlb" )
   ::oAlbCliL:OrdSetFocus( "nNumAlb" )

   do case
      case ::oEstado:nAt == 1
         cExpHead    := '!lFacturado'
      case ::oEstado:nAt == 2
         cExpHead    := 'lFacturado'
      otherwise
         cExpHead    := '.t.'
   end case

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oAlbCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ), ::oAlbCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oAlbCliT:OrdKeyCount() )

   /*
   Lineas de albaranes
   */

   cExpLine          := '!lTotLin .and. !lControl'

   if !::lAllAlm
      cExpLine       += ' .and. cAlmLin >= "' + Rtrim( ::cAlmOrg ) + '" .and. cAlmLin <= "' + Rtrim( ::cAlmDes ) + '"'
   end if

   ::oAlbCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbCliL:cFile ), ::oAlbCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   /*
   Nos movemos por las cabeceras de los pedidos
	*/

   ::oAlbCliT:GoTop()

   while !::lBreak .and. !::oAlbCliT:Eof()

      if Year( ::oAlbCliT:dFecAlb ) == ::nYeaInf                                            .AND.;
         lChkSer( ::oAlbCliT:cSerAlb, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

            while ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb == ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb .AND. ! ::oAlbCliL:eof()

               if !( ::lExcCero .AND. nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                  if !::oDbf:Seek( ::oAlbCliT:cCodAlm )
                     ::oDbf:Blank()
                     ::oDbf:cCodAlm := ::oAlbCliL:cAlmLin
                     ::oDbf:cNomAlm := oRetFld( ::oDbf:cCodAlm, ::oDbfAlm )
                     ::oDbf:Insert()
                  end if

                  ::AddImporte( ::oAlbCliT:dFecAlb, nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )
                  ::nMediaMes( ::nYeaInf )

               end if

               ::oAlbCliL:Skip()

            end while

         end if

      end if

      ::oAlbCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oAlbCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ) )

   ::oAlbCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbCliL:cFile ) )

   ::oMtrInf:AutoInc( ::oAlbCliT:Lastrec() )

   if !::lExcCero
      ::IncluyeCero()
   end if

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//