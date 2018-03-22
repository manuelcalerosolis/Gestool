#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"
//---------------------------------------------------------------------------//

CLASS TDiaCPed FROM TInfGen

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  oPedCliT    AS OBJECT
   DATA  oPedCliL    AS OBJECT
   DATA  oDbfPago    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Parcialmente", "Entregado", "Todos" }
   DATA  lExcCredito AS LOGIC    INIT .f.

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

   if ::xOthers
   ::AddTmpIndex( "CCODCLI", "CCODCLI" )
   ::AddGroup( {|| ::oDbf:cCodCli }, {|| "Cliente  : " + Rtrim( ::oDbf:cCodCli ) + "-" + oRetFld( ::oDbf:cCodCli, ::oDbfCli ) } )
   else
   ::AddTmpIndex( "dFecMov", "Dtos( dFecMov ) + cDocMov" )
   end if

   ::dIniInf := GetSysDate()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TDiaCPed

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oPedCliT := TDataCenter():oPedCliT()

   DATABASE NEW ::oPedCliL  PATH ( cPatEmp() ) FILE "PEDCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "PEDCLIL.CDX"

   DATABASE NEW ::oDbfIva   PATH ( cPatDat() ) FILE "TIVA.DBF"  VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   DATABASE NEW ::oDbfPago  PATH ( cPatEmp() ) FILE "FPAGO.DBF"  VIA ( cDriver() ) SHARED INDEX "FPAGO.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TDiaCPed

   if !Empty( ::oPedCliT ) .and. ::oPedCliT:Used()
      ::oPedCliT:End()
   end if
   if !Empty( ::oPedCliL ) .and. ::oPedCliL:Used()
      ::oPedCliL:End()
   end if
   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if
   if !Empty( ::oDbfPago ) .and. ::oDbfPago:Used()
      ::oDbfPago:End()
   end if

   ::oPedCliT := nil
   ::oPedCliL := nil
   ::oDbfIva  := nil
   ::oDbfPago := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TDiaCPed

   local cEstado := "Todos"

   if !::StdResource( "INF_GEN05" )
      return .f.
   end if

   /*
   Monta los obras de manera automatica
   */

   if !::oDefCliInf( 70, 80, 90, 100, , 600 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oPedCliT:Lastrec() )

   ::oDefExcInf()

   REDEFINE CHECKBOX ::lExcCredito ;
      ID       191;
      OF       ::oFld:aDialogs[1]

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmPedCli(), ::oPedCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TDiaCPed

   local lExcCero := .f.
   local aTotTmp  := {}
   local cExpHead := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader   := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Cliente : " + if( ::lAllCli, "Todos", AllTrim ( ::cCliOrg ) + " > " + AllTrim ( ::cCliDes ) ) },;
                     {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ] } }

   //Ordenamos la tabla
   ::oPedCliT:OrdSetFocus( "dFecPed" )

   cExpHead          := "!lCancel "

   do case
      case ::oEstado:nAt == 1
         cExpHead    += ' .and. nEstado == 1'
      case ::oEstado:nAt == 2
         cExpHead    += ' .and. nEstado == 2'
      case ::oEstado:nAt == 3
         cExpHead    += ' .and. nEstado == 3'
   end case

   cExpHead          += ' .and. dFecPed >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecPed <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   //Creamos el índice
   ::oPedCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oPedCliT:cFile ), ::oPedCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oPedCliT:OrdKeyCount() )

   //Nos movemos por las cabeceras de los albaranes a clientes

   ::oPedCliT:GoTop()

   WHILE !::lBreak .and. !::oPedCliT:Eof()

      if lChkSer( ::oPedCliT:cSerPed, ::aSer )                                                          .AND.;
         if( ::lExcCredito, lClienteBloquearRiesgo( ::oPedCliT:cCodCli, ::oDbfCli:cAlias ), .t. )

         aTotTmp        := aTotPedCli (::oPedCliT:CSERPED + Str( ::oPedCliT:NNUMPED ) + ::oPedCliT:CSUFPED, ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oDbfPago:cAlias, nil, cDivEmp())

         if !( ::lExcCero .AND. aTotTmp[4]== 0 )

            ::oDbf:Append()

            ::oDbf:cCodCli := ::oPedCliT:cCodCli
            ::oDbf:cNomCli := ::oPedCliT:cNomCli
            ::oDbf:dFecMov := ::oPedCliT:dFecPed
            ::oDbf:dFecEnt := ::oPedCliT:dFecEnt

            ::oDbf:nTotNet := aTotTmp[1] - aTotTmp[5] - aTotTmp[6]
            ::oDbf:nTotIva := aTotTmp[2]
            ::oDbf:nTotReq := aTotTmp[3]
            ::oDbf:nTotDoc := aTotTmp[4]
            ::oDbf:nTotPnt := aTotTmp[5]
            ::oDbf:nTotTrn := aTotTmp[6]
            ::oDbf:cDocMov := ::oPedCliT:cSerPed + Str( ::oPedCliT:nNumPed ) + ::oPedCliT:cSufPed

            ::AddCliente( ::oPedCliT:cCodCli, ::oPedCliT, .f. )

            ::oDbf:Save()

         end if

      end if

      ::oMtrInf:AutoInc()

      ::oPedCliT:Skip()

   end while

   //Eliminamos el índice creado anteriormente
   ::oPedCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oPedCliT:cFile ) )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//