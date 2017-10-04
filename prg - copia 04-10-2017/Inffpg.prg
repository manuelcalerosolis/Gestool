#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS InfFpg FROM TInfGen

   DATA oDbfBnc   AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "CCODPAGO", "C", 2, 0, {|| "" },   "Cod.",        .t., "Código de la forma de pago",                    5, .f. )
   ::AddField( "CDESPAGO", "C",30, 0, {|| "" },   "Divisa",      .t., "Descripción de forma de pago",                 30, .f. )
   ::AddField( "CCODBNC",  "C", 4, 2, {|| "" },   "Cod. banco",  .f., "Código del banco de la forma de pago",         10, .f. )
   ::AddField( "CNOMBNC",  "C",50, 2, {|| "" },   "Banco",       .t., "Nombre del banco de la forma de pago",         35, .f. )
   ::AddField( "CTIPPGO",  "C",10, 0, {|| "" },   "Tip. Pgo.",   .t., "Tipo de la forma de pago",                     10, .f. )
   ::AddField( "NPCTCOM",  "N", 6, 2, {|| "" },   "% Comisión",  .f., "Porcentaje de comisión de la forma de pago",   10, .f. )
   ::AddField( "NPLAZOS",  "N", 3, 0, {|| "999" },"Plazos",      .t., "Números de plazos del aplazamiento",           10, .f. )
   ::AddField( "NPLAUNO",  "N", 3, 0, {|| "999" },"Día pago 1",  .t., "Días hasta el primer pago",                    10, .f. )
   ::AddField( "NDIAPLA",  "N", 3, 0, {|| "999" },"Días aplaz.", .t., "Días entre plazos",                            12, .f. )

   ::AddTmpIndex ( "CCODPAGO", "CCODPAGO" )

   ::lDefFecInf   := .f.
   ::lDefSerInf   := .f.
   ::lDefDivInf   := .f.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfBnc  PATH ( cPatEmp() )  FILE "BANCOS.DBF"      VIA ( cDriver() ) SHARED INDEX "BANCOS.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbfBnc ) .and. ::oDbfBnc:Used()
      ::oDbfBnc:End()
   end if

   ::oDbfBnc := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INF_FPG01" )
      return .f.
   end if

   ::oDefFpgInf( 70, 80, 90, 100, 60 )

   ::oMtrInf:SetTotal( ::oDbfFpg:Lastrec() )

   ::CreateFilter( aItmFPago(), ::oDbfFpg:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha         : " + Dtoc( Date() ) },;
                        {|| "Forma de pago : " + if( ::lAllFpg, "Todas", AllTrim( ::cFpgDes ) + " > " + AllTrim( ::cFpgHas ) ) } }

   ::oDbfFpg:OrdSetFocus( "CCODPAGO" )

   ::oDbfFpg:GoTop()
   while !::lBreak .and. !::oDbfFpg:Eof()

      if ( ::lAllFpg .or. ( ::oDbfFpg:cCodPago >= ::cFpgDes .AND. ::oDbfFpg:cCodPago <= ::cFpgHas ) )

         ::oDbf:Append()

         ::oDbf:cCodPago  := ::oDbfFpg:cCodPago
         ::oDbf:cDesPago  := ::oDbfFpg:cDesPago
         ::oDbf:cCodBnc   := ::oDbfFpg:cBanco
         ::oDbf:cNomBnc   := oRetFld( ::oDbfFpg:cBanco, ::oDbfBnc, "cNomBnc" )

         if ::oDbfFpg:nTipPgo <= 1
            ::oDbf:cTipPgo   := "Efectivo"
         else
            ::oDbf:cTipPgo   := "Tarjeta"
         end if

         ::oDbf:nPctCom   := ::oDbfFpg:nPctCom
         ::oDbf:nPlazos   := ::oDbfFpg:nPlazos
         ::oDbf:nPlaUno   := ::oDbfFpg:nPlaUno
         ::oDbf:nDiaPla   := ::oDbfFpg:nDiaPla

         ::oDbf:Save()

      end if

      ::oDbfFpg:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oDbfFpg:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//