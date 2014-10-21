#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"
//---------------------------------------------------------------------------//

CLASS TInfAlbPdt FROM TInfGen

   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oAlbCliP    AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  oEstado     AS OBJECT
   DATA  cEstado     AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "No facturados", "Facturados", "Todos" }
   DATA  oPagos      AS OBJECT
   DATA  cPagos      AS OBJECT
   DATA  aPagos      AS ARRAY    INIT  { "Pendientes", "Pagados", "Todos" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD create()

   ::AddField( "cDocMov", "C", 14, 0, {|| "@!" },                 "Doc.",           .t., "Documento",     14 )
   ::AddField( "dFecMov", "D",  8, 0, {|| "@!" },                 "Fecha",          .t., "Fecha",         10 )
   ::FldCliente()
   ::AddField( "nTotAlb", "N", 16, 6, {|| ::cPicOut },            "Importe",        .t., "Neto",          15, .t. )
   ::AddField( "nTotEnt", "N", 16, 6, {|| ::cPicOut },            "Entregado",      .t., "Punto verde",   15, .t. )
   ::AddField( "nTotPdt", "N", 16, 6, {|| ::cPicOut },            "Pendiente",      .t., "Punto verde",   15, .t. )

   ::AddTmpIndex( "cDocMov", "cDocMov" )

   ::AddGroup( {|| ::oDbf:cCodCli }, {|| "Cliente  : " + Rtrim( ::oDbf:cCodCli ) + "-" + Rtrim( ::oDbf:cNomCli ) }, {||"Total cliente..."} )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TInfAlbPdt

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL  PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   DATABASE NEW ::oAlbCliP  PATH ( cPatEmp() ) FILE "ALBCLIP.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIP.CDX"

   DATABASE NEW ::oDbfIva   PATH ( cPatDat() ) FILE "TIVA.DBF"    VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TInfAlbPdt

   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if
   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if
   if !Empty( ::oAlbCliP ) .and. ::oAlbCliP:Used()
      ::oAlbCliP:End()
   end if
   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if

   ::oAlbCliT := nil
   ::oAlbCliL := nil
   ::oAlbCliP := nil
   ::oDbfIva  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TInfAlbPdt

   ::cEstado   := "No facturados"
   ::cPagos    := "Pendientes"

   if !::StdResource( "INFALBPDT" )
      return .f.
   end if

   /*
   Monta los obras de manera automatica
   */

   if !::oDefCliInf( 70, 80, 90, 100, , 160 )
      return .f.
   end if

   REDEFINE COMBOBOX ::oEstado ;
      VAR      ::cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   REDEFINE COMBOBOX ::oPagos ;
      VAR      ::cPagos ;
      ID       219 ;
      ITEMS    ::aPagos ;
      OF       ::oFld:aDialogs[1]

   ::oMtrInf:SetTotal( ::oAlbCliT:Lastrec() )

   ::CreateFilter( aItmAlbCli(), ::oAlbCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TInfAlbPdt

   local cExpHead     := ""
   local nTotAlb      := 0
   local nTotEnt      := 0

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader   := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                     {|| "Periodo   : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Cliente   : " + if( ::lAllCli, "Todos", AllTrim ( ::cCliOrg ) + " > " + AllTrim ( ::cCliDes ) ) } }

   ::oAlbCliT:OrdSetFocus( "dFecAlb" )

   do case
      case ::oEstado:nAt == 1
         cExpHead    := 'nFacturado < 3 .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 2
         cExpHead    := 'nFacturado == 3 .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 3
         cExpHead    := 'dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   end case

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oAlbCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ), ::oAlbCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oAlbCliT:OrdKeyCount() )

   ::oAlbCliT:GoTop()

   while !::lBreak .and. !::oAlbCliT:Eof()

      if lChkSer( ::oAlbCliT:cSerAlb, ::aSer )

         nTotAlb        := nTotAlbCli( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb, ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias )
         nTotEnt        := nPagAlbCli( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb, ::oAlbCliP:cAlias, ::oDbfDiv:cAlias )

         do case
            case ::oPagos:nAt == 1

               if nTotAlb - nTotEnt > 0

                  ::oDbf:Append()

                  ::oDbf:cCodCli := ::oAlbCliT:cCodCli
                  ::oDbf:cNomCli := ::oAlbCliT:cNomCli
                  ::AddCliente( ::oAlbCliT:cCodCli, ::oAlbCliT, .f. )
                  ::oDbf:dFecMov := ::oAlbCliT:dFecAlb
                  ::oDbf:cDocMov := AllTrim( ::oAlbCliT:cSerAlb ) + "/" + AllTrim( Str( ::oAlbCliT:nNumAlb ) ) + "/" + AllTrim( ::oAlbCliT:cSufAlb )
                  ::oDbf:nTotAlb := nTotAlb
                  ::oDbf:nTotEnt := nTotEnt
                  ::oDbf:nTotPdt := nTotAlb - nTotEnt

                  ::oDbf:Save()

               end if

            case ::oPagos:nAt == 2

               if nTotAlb - nTotEnt == 0

                  ::oDbf:Append()

                  ::oDbf:cCodCli := ::oAlbCliT:cCodCli
                  ::oDbf:cNomCli := ::oAlbCliT:cNomCli
                  ::AddCliente( ::oAlbCliT:cCodCli, ::oAlbCliT, .f. )
                  ::oDbf:dFecMov := ::oAlbCliT:dFecAlb
                  ::oDbf:cDocMov := AllTrim( ::oAlbCliT:cSerAlb ) + "/" + AllTrim( Str( ::oAlbCliT:nNumAlb ) ) + "/" + AllTrim( ::oAlbCliT:cSufAlb )
                  ::oDbf:nTotAlb := nTotAlb
                  ::oDbf:nTotEnt := nTotEnt
                  ::oDbf:nTotPdt := nTotAlb - nTotEnt

                  ::oDbf:Save()

               end if

            case ::oPagos:nAt == 3

               ::oDbf:Append()

               ::oDbf:cCodCli := ::oAlbCliT:cCodCli
               ::oDbf:cNomCli := ::oAlbCliT:cNomCli
               ::AddCliente( ::oAlbCliT:cCodCli, ::oAlbCliT, .f. )
               ::oDbf:dFecMov := ::oAlbCliT:dFecAlb
               ::oDbf:cDocMov := AllTrim( ::oAlbCliT:cSerAlb ) + "/" + AllTrim( Str( ::oAlbCliT:nNumAlb ) ) + "/" + AllTrim( ::oAlbCliT:cSufAlb )
               ::oDbf:nTotAlb := nTotAlb
               ::oDbf:nTotEnt := nTotEnt
               ::oDbf:nTotPdt := nTotAlb - nTotEnt

               ::oDbf:Save()

         end case

      end if

      ::oMtrInf:AutoInc()

      ::oAlbCliT:Skip()

   end while

   ::oAlbCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ) )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//