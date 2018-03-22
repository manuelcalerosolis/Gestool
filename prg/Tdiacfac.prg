#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"
//---------------------------------------------------------------------------//

CLASS TDiaCFac FROM TInfGen

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oTipo       AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  oFacCliP    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oAntCliT    AS OBJECT
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT
   DATA  oDbfObr     AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Liquidada", "Todas" }
   DATA  aTipo       AS ARRAY    INIT  { "Facturas", "Rectificativas", "Todas" }
   DATA  lExcCredito AS LOGIC    INIT .f.

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD create()

   ::AddField( "cTipDoc", "C", 35, 0, {|| "@!" },                 "Tipo",      .f., "Tipo de documento",    12, .f. )
   ::AddField( "cDocMov", "C", 14, 0, {|| "@R #/#########/##" },  "Doc.",      .t., "Documento",            14, .f. )
   ::AddField( "dFecMov", "D",  8, 0, {|| "@!" },                 "Fecha",     .t., "Fecha",                10, .f. )
   ::FldCliente()
   ::AddField( "cCodObr", "C", 10, 0, {|| "@!" },                 "Cod. Dir.", .f., "Código dirección",     12, .f. )
   ::AddField( "cNomObr", "C",150, 0, {|| "@!" },                 "Dirección", .f., "Nombre dirección",     20, .f. )
   ::AddField( "nBase18", "N", 16, 6, {|| ::cPicOut },            "Base 18%",  .f., "Base al 18%",          10, .t. )
   ::AddField( "nIva18",  "N", 16, 6, {|| ::cPicOut },            "IVA. 18%",  .f., "impuestos al 18%",          10, .t. )
   ::AddField( "nReq18",  "N", 16, 6, {|| ::cPicOut },            "REQ. 18%",  .f., "R.E. al 18%",          10, .t. )
   ::AddField( "nBase8",  "N", 16, 6, {|| ::cPicOut },            "Base 8%",   .f., "Base al 8%",           10, .t. )
   ::AddField( "nIva8",   "N", 16, 6, {|| ::cPicOut },            "IVA. 8%",   .f., "IVA al 8%",            10, .t. )
   ::AddField( "nReq8",   "N", 16, 6, {|| ::cPicOut },            "REQ. 8%",   .f., "R.E. al 8%",           10, .t. )
   ::AddField( "nBase21", "N", 16, 6, {|| ::cPicOut },            "Base 21%",  .f., "Base al 21%",          10, .t. )
   ::AddField( "nIva21",  "N", 16, 6, {|| ::cPicOut },            "IVA. 21%",  .f., "IVA al 21%",           10, .t. )
   ::AddField( "nReq21",  "N", 16, 6, {|| ::cPicOut },            "REQ. 21%",  .f., "R.E. al 21%",          10, .t. )
   ::AddField( "nBase10", "N", 16, 6, {|| ::cPicOut },            "Base 10%",  .f., "Base al 10%",          10, .t. )
   ::AddField( "nIva10",  "N", 16, 6, {|| ::cPicOut },            "IVA. 10%",  .f., "IVA al 10%",           10, .t. )
   ::AddField( "nReq10",  "N", 16, 6, {|| ::cPicOut },            "REQ. 10%",  .f., "R.E. al 10%",          10, .t. )
   ::AddField( "nBase4",  "N", 16, 6, {|| ::cPicOut },            "Base 4%",   .f., "Base al 4%",           10, .t. )
   ::AddField( "nIva4",   "N", 16, 6, {|| ::cPicOut },            "IVA. 4%",   .f., "IVA al 4%",            10, .t. )
   ::AddField( "nReq4",   "N", 16, 6, {|| ::cPicOut },            "REQ. 4%",   .f., "R.E. al 4%",           10, .t. )
   ::AddField( "nBase0",  "N", 16, 6, {|| ::cPicOut },            "Base 0%",   .f., "Base al 0%",           10, .t. )
   ::AddField( "nIva0",   "N", 16, 6, {|| ::cPicOut },            "IVA. 0%",   .f., "IVA al 0%",            10, .t. )
   ::AddField( "nReq0",   "N", 16, 6, {|| ::cPicOut },            "REQ. 0%",   .f., "R.E. al 0%",           10, .t. )
   ::AddField( "nTotNet", "N", 16, 6, {|| ::cPicOut },            "Neto",      .t., "Neto",                 10, .t. )
   ::AddField( "nTotPnt", "N", 16, 6, {|| ::cPicPnt },            "P.V.",      .f., "Punto verde",          10, .t. )
   ::AddField( "nTotTrn", "N", 16, 6, {|| ::cPicOut },            "Transp.",   .f., "Transporte",           10, .t. )
   ::AddField( "nTotIva", "N", 16, 6, {|| ::cPicOut },            cImp(),      .t., cImp(),                 10, .t. )
   ::AddField( "nTotReq", "N", 16, 3, {|| ::cPicOut },            "Rec",       .t., "Rec",                  10, .t. )
   ::AddField( "nImpEsp", "N", 16, 6, {|| ::cPicOut },            "Imp. esp.", .t., "Impuestos especiales", 10, .t. )
   ::AddField( "nTotDoc", "N", 16, 6, {|| ::cPicOut },            "Total",     .t., "Total",                10, .t. )
   ::AddField( "nCobros", "N", 16, 6, {|| ::cPicOut },            "Cobrado",   .t., "Cobrado factura",      10, .t. )
   ::AddField( "nPdtFac", "N", 16, 6, {|| ::cPicOut },            "Pendiente", .t., "Pendiente factura",    12, .t. )
   ::AddField( "nPctRet", "N", 16, 6, {|| "@E 999.99" },          "% Ret.",    .f., "Porcentaje retención", 10, .t. )
   ::AddField( "nRetFac", "N", 16, 6, {|| ::cPicOut },            "Retención", .f., "Importe retención",    10, .t. )

   if ::xOthers
   ::AddTmpIndex( "CCODCLI", "CCODCLI + Dtos( DFECMOV ) + CDOCMOV " )
   ::AddGroup( {|| ::oDbf:cCodCli }, {|| "Cliente  : " + Rtrim( ::oDbf:cCodCli ) + "-" + oRetFld( ::oDbf:cCodCli, ::oDbfCli ) } )
   else
   ::AddTmpIndex( "dFecMov", "Dtos( dFecMov ) + cDocMov" )
   end if

   ::dIniInf := GetSysDate()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TDiaCFac

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oFacCliT := TDataCenter():oFacCliT()
   ::oFacCliT:SetOrder( "dFecFac" )

   DATABASE NEW ::oFacCliL    PATH ( cPatEmp() ) FILE "FACCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oFacRecT    PATH ( cPatEmp() ) FILE "FACRECT.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL    PATH ( cPatEmp() ) FILE "FACRECL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   DATABASE NEW ::oAntCliT    PATH ( cPatEmp() ) FILE "ANTCLIT.DBF"  VIA ( cDriver() ) SHARED INDEX "ANTCLIT.CDX"

   DATABASE NEW ::oDbfObr     PATH ( cPatEmp() ) FILE "OBRAST.DBF"  VIA ( cDriver() ) SHARED INDEX "OBRAST.CDX"

   DATABASE NEW ::oDbfIva     PATH ( cPatDat() ) FILE "TIVA.DBF"     VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   ::oFacCliP := TDataCenter():oFacCliP()

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TDiaCFac

   if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if
   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if
   if !Empty( ::oFacRecT ) .and. ::oFacRecT:Used()
      ::oFacRecT:End()
   end if
   if !Empty( ::oFacRecL ) .and. ::oFacRecL:Used()
      ::oFacRecL:End()
   end if
   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if
   if !Empty( ::oFacCliP ) .and. ::oFacCliP:Used()
      ::oFacCliP:End()
   end if
   if !Empty( ::oAntCliT ) .and. ::oAntCliT:Used()
      ::oAntCliT:End()
   end if
   if !Empty( ::oDbfObr ) .and. ::oDbfObr:Used()
      ::oDbfObr:End()
   end if
   
   ::oFacCliT  := nil
   ::oFacCliL  := nil
   ::oFacRecT  := nil
   ::oFacRecL  := nil
   ::oDbfIva   := nil
   ::oFacCliP  := nil
   ::oAntCliT  := nil
   ::oDbfObr   := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TDiaCFac

   local cEstado  := "Todas"
   local cTipo    := "Todas"

   if !::StdResource( "INF_GEN05FAC" )
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

   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )

   ::oDefExcInf()

   REDEFINE CHECKBOX ::lExcCredito ;
      ID       191;
      OF       ::oFld:aDialogs[1]

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   REDEFINE COMBOBOX ::oTipo ;
      VAR      cTipo ;
      ID       219 ;
      ITEMS    ::aTipo ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmFacCli(), ::oFacCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TDiaCFac

   local lExcCero := .f.
   local aTotTmp  := {}
   local cExpHead := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                        {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Cliente : " + if( ::lAllCli, "Todos", AllTrim( ::cCliOrg ) + " > " + AllTrim ( ::cCliDes ) ) },;
                        {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ] },;
                        {|| "Tipo    : " + ::aTipo[ ::oTipo:nAt ] } }

   if ::oTipo:nAt == 1 .or. ::oTipo:nAt == 3

      ::oFacCliT:OrdSetFocus( "dFecFac" )

      do case
         case ::oEstado:nAt == 1
            cExpHead    := '!lLiquidada .and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
         case ::oEstado:nAt == 2
            cExpHead    := 'lLiquidada .and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
         otherwise
            cExpHead    := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      end case

      if !::lAllCli
         cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
      end if

      if !Empty( ::oFilter:cExpresionFilter )
         cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
      end if

      ::oFacCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

      ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )

      /*
      Nos movemos por las cabeceras de los albaranes a clientes
      */

      ::oFacCliT:GoTop()

      while !::lBreak .and. !::oFacCliT:Eof()

         if lChkSer( ::oFacCliT:cSerie, ::aSer )                      .AND.;
            if( ::lExcCredito, lClienteBloquearRiesgo( ::oFacCliT:cCodCli, ::oDbfCli:cAlias ), .t. )

            /*
            Posicionamos en las lineas de detalle --------------------------------
            */

            ::oDbf:Append()

            ::oDbf:cCodCli          := ::oFacCliT:cCodCli
            ::oDbf:cNomCli          := ::oFacCliT:cNomCli
            ::oDbf:dFecMov          := ::oFacCliT:dFecFac
            ::oDbf:cDocMov          := ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac
            ::oDbf:cCodObr          := ::oFacCliT:cCodObr
            ::oDbf:cNomObr          := oRetFld( ::oFacCliT:cCodCli + ::oFacCliT:cCodObr, ::oDbfObr, "cNomObr" )

            ::AddCliente( ::oFacCliT:cCodCli, ::oFacCliT, .f. )

            aTotTmp                 := aTotFacCli( ::oFacClit:cserie + Str( ::oFacCliT:nnumfac ) + ::ofacclit:csuffac, ::ofacclit:calias, ::ofacclil:calias, ::odbfiva:calias, ::odbfdiv:calias, ::ofacclip:calias, ::oAntCliT:cAlias, ::cDivInf )

            ::oDbf:nTotNet          := aTotTmp[1] - aTotTmp[5] - aTotTmp[6]
            ::oDbf:nTotIva          := aTotTmp[2]
            ::oDbf:nTotReq          := aTotTmp[3]
            ::oDbf:nTotDoc          := aTotTmp[4]
            ::oDbf:nTotPnt          := aTotTmp[5]
            ::oDbf:nTotTrn          := aTotTmp[6]
            ::oDbf:nPctRet          := ::oFacCliT:nPctRet
            ::oDbf:nRetFac          := aTotTmp[12]
            ::oDbf:cTipDoc          := "Factura"
            ::oDbf:nImpEsp          := aTotTmp[10]
            ::oDbf:nCobros          := nPagFacCli( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac, ::oFacCliT:cAlias, ::oFacCliP:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::cDivInf )
            ::oDbf:nPdtFac          := ::oDbf:nTotDoc - ::oDbf:nCobros

            ::oDbf:nBase18          := 0
            ::oDbf:nIva18           := 0
            ::oDbf:nReq18           := 0
            ::oDbf:nBase8           := 0
            ::oDbf:nIva8            := 0
            ::oDbf:nReq8            := 0
            ::oDbf:nBase21          := 0
            ::oDbf:nIva21           := 0
            ::oDbf:nReq21           := 0
            ::oDbf:nBase10          := 0
            ::oDbf:nIva10           := 0
            ::oDbf:nReq10           := 0
            ::oDbf:nBase4           := 0
            ::oDbf:nIva4            := 0
            ::oDbf:nReq4            := 0
            ::oDbf:nBase0           := 0
            ::oDbf:nIva0            := 0
            ::oDbf:nReq0            := 0

            do case
               case aTotTmp[8][1,3] == 18
                  ::oDbf:nBase18    := aTotTmp[8][1,2]
                  ::oDbf:nIva18     := aTotTmp[8][1,8]
                  ::oDbf:nReq18     := aTotTmp[8][1,9]

               case aTotTmp[8][2,3] == 18
                  ::oDbf:nBase18    := aTotTmp[8][2,2]
                  ::oDbf:nIva18     := aTotTmp[8][2,8]
                  ::oDbf:nReq18     := aTotTmp[8][2,9]

               case aTotTmp[8][3,3] == 18
                  ::oDbf:nBase18    := aTotTmp[8][3,2]
                  ::oDbf:nIva18     := aTotTmp[8][3,8]
                  ::oDbf:nReq18     := aTotTmp[8][3,9]
            end case

            do case
               case aTotTmp[8][1,3] == 21
                  ::oDbf:nBase21    := aTotTmp[8][1,2]
                  ::oDbf:nIva21     := aTotTmp[8][1,8]
                  ::oDbf:nReq21     := aTotTmp[8][1,9]

               case aTotTmp[8][2,3] == 21
                  ::oDbf:nBase21    := aTotTmp[8][2,2]
                  ::oDbf:nIva21     := aTotTmp[8][2,8]
                  ::oDbf:nReq21     := aTotTmp[8][2,9]

               case aTotTmp[8][3,3] == 21
                  ::oDbf:nBase21    := aTotTmp[8][3,2]
                  ::oDbf:nIva21     := aTotTmp[8][3,8]
                  ::oDbf:nReq21     := aTotTmp[8][3,9]
            end case

            do case
               case aTotTmp[8][1,3] == 10
                  ::oDbf:nBase10    := aTotTmp[8][1,2]
                  ::oDbf:nIva10     := aTotTmp[8][1,8]
                  ::oDbf:nReq10     := aTotTmp[8][1,9]

               case aTotTmp[8][2,3] == 10
                  ::oDbf:nBase10    := aTotTmp[8][2,2]
                  ::oDbf:nIva10     := aTotTmp[8][2,8]
                  ::oDbf:nReq10     := aTotTmp[8][2,9]

               case aTotTmp[8][3,3] == 10
                  ::oDbf:nBase10    := aTotTmp[8][3,2]
                  ::oDbf:nIva10     := aTotTmp[8][3,8]
                  ::oDbf:nReq10     := aTotTmp[8][3,9]
            end case

            do case
               case aTotTmp[8][1,3] == 8
                  ::oDbf:nBase8     := aTotTmp[8][1,2]
                  ::oDbf:nIva8      := aTotTmp[8][1,8]
                  ::oDbf:nReq8      := aTotTmp[8][1,9]

               case aTotTmp[8][2,3] == 8
                  ::oDbf:nBase8     := aTotTmp[8][2,2]
                  ::oDbf:nIva8      := aTotTmp[8][2,8]
                  ::oDbf:nReq8      := aTotTmp[8][2,9]

               case aTotTmp[8][3,3] == 8
                  ::oDbf:nBase8     := aTotTmp[8][3,2]
                  ::oDbf:nIva8      := aTotTmp[8][3,8]
                  ::oDbf:nReq8      := aTotTmp[8][3,9]
            end case

            do case
               case aTotTmp[8][1,3] == 4
                  ::oDbf:nBase4     := aTotTmp[8][1,2]
                  ::oDbf:nIva4      := aTotTmp[8][1,8]
                  ::oDbf:nReq4      := aTotTmp[8][1,9]

               case aTotTmp[8][2,3] == 4
                  ::oDbf:nBase4     := aTotTmp[8][2,2]
                  ::oDbf:nIva4      := aTotTmp[8][2,8]
                  ::oDbf:nReq4      := aTotTmp[8][2,9]

               case aTotTmp[8][3,3] == 4
                  ::oDbf:nBase4     := aTotTmp[8][3,2]
                  ::oDbf:nIva4      := aTotTmp[8][3,8]
                  ::oDbf:nReq4      := aTotTmp[8][3,9]
            end case

            do case

               case aTotTmp[8][1,3] == 0
                  ::oDbf:nBase0     := aTotTmp[8][1,2]
                  ::oDbf:nIva0      := aTotTmp[8][1,8]
                  ::oDbf:nReq0      := aTotTmp[8][1,9]

               case aTotTmp[8][2,3] == 0
                  ::oDbf:nBase0     := aTotTmp[8][2,2]
                  ::oDbf:nIva0      := aTotTmp[8][2,8]
                  ::oDbf:nReq0      := aTotTmp[8][2,9]

               case aTotTmp[8][3,3] == 0
                  ::oDbf:nBase0     := aTotTmp[8][3,2]
                  ::oDbf:nIva0      := aTotTmp[8][3,8]
                  ::oDbf:nReq0      := aTotTmp[8][3,9]

            end case

            ::oDbf:Save()

            aTotTmp                 := {}

         end if

         ::oMtrInf:Set( ::oFacCliT:OrdKeyNo() )

         ::oFacCliT:Skip()

      end while

      ::oFacCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacCliT:cFile ) )

   end if

  if ::oTipo:nAt == 2 .or. ::oTipo:nAt == 3

      /*
      comenzamos con las rectificativas
      */

      ::oFacRecT:OrdSetFocus( "dFecFac" )

      do case
         case ::oEstado:nAt == 1
            cExpHead    := '!lLiquidada .and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
         case ::oEstado:nAt == 2
            cExpHead    := 'lLiquidada .and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
         otherwise
            cExpHead    := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      end case

      if !::lAllCli
         cExpHead    += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
      end if

      if !Empty( ::oFilter:cExpresionFilter )
         cExpHead    += ' .and. ' + ::oFilter:cExpresionFilter
      end if

      ::oFacRecT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

      ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )

      ::oFacRecT:GoTop()
      while !::lBreak .and. !::oFacRecT:Eof()

         if lChkSer( ::oFacRecT:cSerie, ::aSer )

            ::oDbf:Append()

            ::oDbf:cCodCli := ::oFacRecT:cCodCli
            ::oDbf:cNomCli := ::oFacRecT:cNomCli
            ::oDbf:dFecMov := ::oFacRecT:dFecFac
            ::oDbf:cDocMov := ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac
            ::oDbf:cCodObr := ::oFacRecT:cCodObr
            ::oDbf:cNomObr := oRetFld( ::oFacCliT:cCodCli + ::oFacRecT:cCodObr, ::oDbfObr, "cNomObr" )

            ::AddCliente( ::oFacRecT:cCodCli, ::oFacRecT, .f. )

            aTotTmp                 := aTotFacRec( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac, ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::cDivInf )

            ::oDbf:nTotNet          := aTotTmp[1] - aTotTmp[5] - aTotTmp[6]
            ::oDbf:nTotIva          := aTotTmp[2]
            ::oDbf:nTotReq          := aTotTmp[3]
            ::oDbf:nTotDoc          := aTotTmp[4]
            ::oDbf:nTotPnt          := aTotTmp[5]
            ::oDbf:nTotTrn          := aTotTmp[6]
            ::oDbf:nPctRet          := ::oFacRecT:nPctRet
            ::oDbf:nRetFac          := aTotTmp[12]
            ::oDbf:cTipDoc          := "Rectificativa"
            ::oDbf:nImpEsp          := aTotTmp[10]

            ::oDbf:nBase18          := 0
            ::oDbf:nIva18           := 0
            ::oDbf:nReq18           := 0
            ::oDbf:nBase8           := 0
            ::oDbf:nIva8            := 0
            ::oDbf:nReq8            := 0
            ::oDbf:nBase21          := 0
            ::oDbf:nIva21           := 0
            ::oDbf:nReq21           := 0
            ::oDbf:nBase10          := 0
            ::oDbf:nIva10           := 0
            ::oDbf:nReq10           := 0
            ::oDbf:nBase4           := 0
            ::oDbf:nIva4            := 0
            ::oDbf:nReq4            := 0
            ::oDbf:nBase0           := 0
            ::oDbf:nIva0            := 0
            ::oDbf:nReq0            := 0

            do case
               case aTotTmp[8][1,3] == 18
                  ::oDbf:nBase18    := aTotTmp[8][1,2]
                  ::oDbf:nIva18     := aTotTmp[8][1,8]
                  ::oDbf:nReq18     := aTotTmp[8][1,9]

               case aTotTmp[8][2,3] == 18
                  ::oDbf:nBase18    := aTotTmp[8][2,2]
                  ::oDbf:nIva18     := aTotTmp[8][2,8]
                  ::oDbf:nReq18     := aTotTmp[8][2,9]

               case aTotTmp[8][3,3] == 18
                  ::oDbf:nBase18    := aTotTmp[8][3,2]
                  ::oDbf:nIva18     := aTotTmp[8][3,8]
                  ::oDbf:nReq18     := aTotTmp[8][3,9]
            end case

            do case
               case aTotTmp[8][1,3] == 21
                  ::oDbf:nBase21    := aTotTmp[8][1,2]
                  ::oDbf:nIva21     := aTotTmp[8][1,8]
                  ::oDbf:nReq21     := aTotTmp[8][1,9]

               case aTotTmp[8][2,3] == 21
                  ::oDbf:nBase21    := aTotTmp[8][2,2]
                  ::oDbf:nIva21     := aTotTmp[8][2,8]
                  ::oDbf:nReq21     := aTotTmp[8][2,9]

               case aTotTmp[8][3,3] == 21
                  ::oDbf:nBase21    := aTotTmp[8][3,2]
                  ::oDbf:nIva21     := aTotTmp[8][3,8]
                  ::oDbf:nReq21     := aTotTmp[8][3,9]
            end case

            do case
               case aTotTmp[8][1,3] == 10
                  ::oDbf:nBase10    := aTotTmp[8][1,2]
                  ::oDbf:nIva10     := aTotTmp[8][1,8]
                  ::oDbf:nReq10     := aTotTmp[8][1,9]

               case aTotTmp[8][2,3] == 10
                  ::oDbf:nBase10    := aTotTmp[8][2,2]
                  ::oDbf:nIva10     := aTotTmp[8][2,8]
                  ::oDbf:nReq10     := aTotTmp[8][2,9]

               case aTotTmp[8][3,3] == 10
                  ::oDbf:nBase10    := aTotTmp[8][3,2]
                  ::oDbf:nIva10     := aTotTmp[8][3,8]
                  ::oDbf:nReq10     := aTotTmp[8][3,9]
            end case

            do case

               case aTotTmp[8][1,3] == 8
                  ::oDbf:nBase8     := aTotTmp[8][1,2]
                  ::oDbf:nIva8      := aTotTmp[8][1,8]
                  ::oDbf:nReq8      := aTotTmp[8][1,9]

               case aTotTmp[8][2,3] == 8
                  ::oDbf:nBase8     := aTotTmp[8][2,2]
                  ::oDbf:nIva8      := aTotTmp[8][2,8]
                  ::oDbf:nReq8      := aTotTmp[8][2,9]

               case aTotTmp[8][3,3] == 8
                  ::oDbf:nBase8     := aTotTmp[8][3,2]
                  ::oDbf:nIva8      := aTotTmp[8][3,8]
                  ::oDbf:nReq8      := aTotTmp[8][3,9]
            end case

            do case

               case aTotTmp[8][1,3] == 4
                  ::oDbf:nBase4     := aTotTmp[8][1,2]
                  ::oDbf:nIva4      := aTotTmp[8][1,8]
                  ::oDbf:nReq4      := aTotTmp[8][1,9]

               case aTotTmp[8][2,3] == 4
                  ::oDbf:nBase4     := aTotTmp[8][2,2]
                  ::oDbf:nIva4      := aTotTmp[8][2,8]
                  ::oDbf:nReq4      := aTotTmp[8][2,9]

               case aTotTmp[8][3,3] == 4
                  ::oDbf:nBase4     := aTotTmp[8][3,2]
                  ::oDbf:nIva4      := aTotTmp[8][3,8]
                  ::oDbf:nReq4      := aTotTmp[8][3,9]
            end case

            do case

               case aTotTmp[8][1,3] == 0
                  ::oDbf:nBase0     := aTotTmp[8][1,2]
                  ::oDbf:nIva0      := aTotTmp[8][1,8]
                  ::oDbf:nReq0      := aTotTmp[8][1,9]

               case aTotTmp[8][2,3] == 0
                  ::oDbf:nBase0     := aTotTmp[8][2,2]
                  ::oDbf:nIva0      := aTotTmp[8][2,8]
                  ::oDbf:nReq0      := aTotTmp[8][2,9]

               case aTotTmp[8][3,3] == 0
                  ::oDbf:nBase0     := aTotTmp[8][3,2]
                  ::oDbf:nIva0      := aTotTmp[8][3,8]
                  ::oDbf:nReq0      := aTotTmp[8][3,9]

            end case

            ::oDbf:Save()

            aTotTmp                 := {}

         end if

         ::oMtrInf:Set( ::oFacRecT:OrdKeyNo() )

         ::oFacRecT:Skip()

      end while

      ::oFacRecT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacRecT:cFile ) )

   end if

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//