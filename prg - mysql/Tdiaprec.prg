#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"
//---------------------------------------------------------------------------//

CLASS TDiaPRec FROM TInfGen

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  oFacPrvP    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendientes", "Pagados", "Todos" }
   DATA  lExcCredito AS LOGIC    INIT .f.

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cDocMov", "C", 14, 0, {|| "@!" },         "Doc.",                      .t., "Documento",                14 )
   ::AddField( "dFecMov", "D",  8, 0, {|| "@!" },         "Fecha",                     .t., "Fecha de expedición",      14 )
   ::AddField( "dFecVto", "D",  8, 0, {|| "@!" },         "Vencimiento",               .t., "Fecha de vencimiento",     14 )
   ::AddField( "dFecCob", "D",  8, 0, {|| "@!" },         "Pago",                      .t., "Fecha de pago",            14 )
   ::AddField( "cCodPrv", "C", 12, 0, {|| "@!" },         "Prv.",                      .t., "Cod. Proveedor",            9 )
   ::AddField( "cNomPrv", "C", 50, 0, {|| "@!" },         "Proveedor",                 .t., "Nombre Proveedor",         35 )
   ::AddField( "nTotDoc", "N", 16, 6, {|| ::cPicOut },    "Total",                     .t., "Total",                    35 )
   ::AddField( "cBanco",  "C", 50, 0, {|| "@!" },         "Banco",                     .f., "Nombre del banco",         20 )
   ::AddField( "cCuenta", "C", 30, 0, {|| "@!" },         "Cuenta",                    .f., "Cuenta bancaria",          35 )

   ::AddTmpIndex( "dFecMov", "dFecMov" )

   ::dIniInf := GetSysDate()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfIva   PATH ( cPatDat() ) FILE "TIVA.DBF"  VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   DATABASE NEW ::oFacPrvP  PATH ( cPatEmp() ) FILE "FACPRVP.DBF"  VIA ( cDriver() ) SHARED INDEX "FACPRVP.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if
   if !Empty( ::oFacPrvP ) .and. ::oFacPrvP:Used()
      ::oFacPrvP:End()
   end if

   ::oDbfIva  := nil
   ::oFacPrvP := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cEstado := "Pagados"

   if !::StdResource( "PRVDIAREC" )
      return .f.
   end if

   /*
   Monta los obras de manera automatica
   */

   if !::oDefPrvInf( 70, 80, 90, 100, 400 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oFacPrvP:Lastrec() )

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmRecPrv(), ::oFacPrvP:cAlias  )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local bFecha   := {|| .t. }
   local bValid   := {|| .t. }
   local lExcCero := .f.
   local aTotTmp  := {}
   local cExpHead := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| !::oFacPrvP:lCobrado }
         bFecha   := {|| ::oFacPrvP:dPreCob >= ::dIniInf .and. ::oFacPrvP:dPreCob <= ::dFinInf }
         ::oFacPrvP:OrdSetFocus( "dPreCob" )
      case ::oEstado:nAt == 2
         bValid   := {|| ::oFacPrvP:lCobrado }
         bFecha   := {|| ::oFacPrvP:dEntrada >= ::dIniInf .and. ::oFacPrvP:dEntrada <= ::dFinInf }
         ::oFacPrvP:OrdSetFocus( "dEntrda" )
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
         bFecha   := {|| ::oFacPrvP:dPreCob >= ::dIniInf .and. ::oFacPrvP:dPreCob <= ::dFinInf }
         ::oFacPrvP:OrdSetFocus( "dPreCob" )
   end case

   ::aHeader      := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                        {|| "Periodo   : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Proveedor : " + AllTrim( ::cPrvOrg ) + " > " + AllTrim( ::cPrvDes ) },;
                        {|| "Estado    : " + ::aEstado[ ::oEstado:nAt ] } }

   ::oFacPrvP:OrdSetFocus( "DENTRADA" )

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       := ::oFilter:cExpresionFilter
   else
      cExpHead       := '.t.'
   end if

   ::oFacPrvP:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacPrvP:cFile ), ::oFacPrvP:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oFacPrvP:GoTop()

   while !::lBreak .and. !::oFacPrvP:Eof()

      if Eval( bValid )                                                                                  .and.;
         Eval( bFecha )                                                                                  .and.;
         ( ::lAllPrv .or. ( ::oFacPrvP:cCodPrv >= ::cPrvOrg .AND. ::oFacPrvP:cCodPrv <= ::cPrvDes ) )    .and.;
         lChkSer( ::oFacPrvP:cSerFac, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if !( ::lExcCero .AND. nTotRecPrv( ::oFacPrvP:cAlias, ::oDbfDiv:cAlias, ::cDivInf ) == 0 )

            ::oDbf:Append()

            ::oDbf:cCodPrv    := ::oFacPrvP:cCodPrv

            if ::oDbfPrv:Seek( ::oFacPrvP:cCodPrv )
               ::oDbf:cNomPrv := ::oDbfPrv:Titulo
            end if

            ::oDbf:dFecMov    := ::oFacPrvP:dPreCob
            ::oDbf:dFecCob    := ::oFacPrvP:dEntrada
            ::oDbf:dFecVto    := ::oFacPrvP:dFecVto
            ::oDbf:nTotDoc    := nTotRecPrv( ::oFacPrvP:cAlias, ::oDbfDiv:cAlias, ::cDivInf )
            ::oDbf:cDocMov    := AllTrim( ::oFacPrvP:cSerFac ) + "/" + AllTrim( Str( ::oFacPrvP:nNumFac ) )+ "/" + AllTrim( ::oFacPrvP:cSufFac )
            ::oDbf:cBanco     := ::oFacPrvP:cBncPrv
            ::oDbf:cCuenta    := ::oFacPrvP:cEntPrv + "-" + ::oFacPrvP:cSucPrv + "-" + ::oFacPrvP:cDigPrv + "-" + ::oFacPrvP:cCtaPrv

            ::oDbf:Save()

         end if

      end if

      ::oFacPrvP:Skip()

      ::oMtrInf:AutoInc( ::oFacPrvP:OrdKeyNo() )

   end while

   ::oFacPrvP:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacPrvP:cFile ) )

   ::oMtrInf:AutoInc( ::oFacPrvP:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//