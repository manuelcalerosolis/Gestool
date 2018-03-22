#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"
//---------------------------------------------------------------------------//

CLASS TDiaCAlb FROM TInfGen

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oAlbCliP    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "No facturado", "Facturado", "Todos" }
   DATA  lExcCredito AS LOGIC    INIT .f.
   DATA  aEntregado  AS ARRAY    INIT  { "No entregados", "Entregados", "Todos"}
   DATA  oEntregado  AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD create()

   ::FldDiario( .f. )
   ::AddField( "dFecEnt",     "D",  8, 0, {|| "@!" },          "Fec. entrega",              .t., "Fecha de entrega"          , 10 )
   ::AddField( "nTotEnt",     "N", 16, 6, {|| ::cPicOut },     "Entregado",                 .f., "Total entregas a cuenta"   , 20, .t. )

   if ::xOthers
   ::AddTmpIndex( "CCODCLI", "CCODCLI" )
   ::AddGroup( {|| ::oDbf:cCodCli }, {|| "Cliente  : " + Rtrim( ::oDbf:cCodCli ) + "-" + oRetFld( ::oDbf:cCodCli, ::oDbfCli ) } )
   else
   ::AddTmpIndex( "dFecMov", "Dtos( dFecMov ) + cDocMov" )
   end if

   ::dIniInf := GetSysDate()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TDiaCAlb

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

METHOD CloseFiles() CLASS TDiaCAlb

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

METHOD lResource( cFld ) CLASS TDiaCAlb

   local cEstado    := "Todos"
   local cEntregado := "Todos"

   if !::StdResource( "INFDIAALB" )
      return .f.
   end if

   /*
   Monta los obras de manera automatica
   */

   if !::oDefCliInf( 70, 80, 90, 100, , 160 )
      return .f.
   end if

   REDEFINE COMBOBOX ::oEntregado ;
      VAR      cEntregado ;
      ID       219 ;
      ITEMS    ::aEntregado ;
      OF       ::oFld:aDialogs[1]

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lExcCredito ;
      ID       191;
      OF       ::oFld:aDialogs[1]

   ::oDefExcInf()

   ::oMtrInf:SetTotal( ::oAlbCliT:Lastrec() )

   ::CreateFilter( aItmAlbCli(), ::oAlbCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TDiaCAlb

   local lExcCero     := .f.
   local aTotTmp      := {}
   local cExpHead     := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader   := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                     {|| "Periodo   : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Cliente   : " + if( ::lAllCli, "Todos", AllTrim ( ::cCliOrg ) + " > " + AllTrim ( ::cCliDes ) ) },;
                     {|| "Estado    : " + ::aEstado[ ::oEstado:nAt ] },;
                     {|| "Entregado : " + ::aEntregado[ ::oEntregado:nAt ] } }

   ::oAlbCliT:OrdSetFocus( "dFecAlb" )

   do case
      case ::oEstado:nAt == 1
         cExpHead    += 'nFacturado < 3'
      case ::oEstado:nAt == 2
         cExpHead    += 'nFacturado == 3'
      case ::oEstado:nAt == 3
         cExpHead    += '.t.'
   end case

   do case
      case ::oEntregado:nAt == 1
         cExpHead    += ' .and. !lEntregado'
      case ::oEntregado:nAt == 2
         cExpHead    += ' .and. lEntregado'
      case ::oEntregado:nAt == 3
         cExpHead    += ' .and. .t.'
   end case

   if ::oEntregado:nAt != 2
      cExpHead       += ' .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   else
      cExpHead       += ' .and. dFecEnv >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecEnv <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   end if

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oAlbCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oAlbCliT:cFile ), ::oAlbCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oAlbCliT:OrdKeyCount() )

   /*
   Nos movemos por las cabeceras de los albaranes a clientes
	*/

   ::oAlbCliT:GoTop()

   while !::lBreak .and. !::oAlbCliT:Eof()

      if lChkSer( ::oAlbCliT:cSerAlb, ::aSer )                             .AND.;
         if( ::lExcCredito, lClienteBloquearRiesgo( ::oAlbCliT:cCodCli, ::oDbfCli:cAlias ), .t. )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         ::oDbf:Append()

         ::oDbf:cCodCli := ::oAlbCliT:cCodCli
         ::oDbf:cNomCli := ::oAlbCliT:cNomCli
         ::oDbf:dFecMov := ::oAlbCliT:dFecAlb
         ::oDbf:dFecEnt := if( ::oAlbCliT:dFecEnv == nil, dtos( "" ), ::oAlbCliT:dFecEnv )

         aTotTmp        := aTotAlbCli( ::oAlbCliT:CSERALB + Str( ::oAlbCliT:NNUMALB ) + ::oAlbCliT:CSUFALB, ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::cDivInf  )

         ::oDbf:nTotNet := aTotTmp[1] - aTotTmp[5] - aTotTmp[6]
         ::oDbf:nTotIva := aTotTmp[2]
         ::oDbf:nTotReq := aTotTmp[3]
         ::oDbf:nTotDoc := aTotTmp[4]
         ::oDbf:nTotPnt := aTotTmp[5]
         ::oDbf:nTotTrn := aTotTmp[6]
         ::oDbf:cDocMov := ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb
         ::oDbf:nTotEnt := nPagAlbCli( ::oAlbCliT:CSERALB + Str( ::oAlbCliT:NNUMALB ) + ::oAlbCliT:CSUFALB, ::oAlbCliP:cAlias, ::oDbfDiv:cAlias )

         ::AddCliente( ::oAlbCliT:cCodCli, ::oAlbCliT, .f. )

         ::oDbf:Save()

      end if

      ::oMtrInf:AutoInc()

      ::oAlbCliT:Skip()

   end while

   ::oAlbCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oAlbCliT:cFile ) )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//