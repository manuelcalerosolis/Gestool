#include "FiveWin.Ch"
#include "Folder.ch"
#include "Factu.ch" 
#include "Report.ch"
#include "Menu.ch"

//---------------------------------------------------------------------------//

Function GenFacAlqCli( oBrw, aDbfBmp, dbfAlqCliT, dbfAlqCliL, dbfAlqCliP, dbfClient, dbfCliAtp, dbfIva, dbfDiv, dbfFPago, dbfUsr, dbfCount, oGrpCli, oStock )

   local oDlg
   local oPag
   local oGrpDes
   local cGrpDes
   local oNomGrpDes
   local cNomGrpDes
   local oGrpHas
   local cGrpHas
   local oNomGrpHas
   local cNomGrpHas
   local oCliDes
   local cCliDes
   local oNomCliDes
   local cNomCliDes
   local oCliHas
   local cCliHas
   local oNomCliHas
   local cNomCliHas
   local oBtnPrv
   local oBtnNxt
   local oBrwAlq
   local lAllCli        := .t.
   local lAllGrp        := .t.
   local oMetMsg
   local nMetMsg        := 0
   local lGrpCli        := .t.
   local nGrpObr        := 1
   local lTotAlq        := .f.
   local lUniPgo        := .f.
   local lNotImp        := .f.

   local nRadFec        := 1
   local dFecFac        := GetSysDate()
   local dDesAlq        := ctoD( "01/" + Str( Month( GetSysDate() ), 2 ) + "/" + Str( Year( GetSysDate() ) ) )
   local dHasAlq        := GetSysDate()
   local oSer           := Array( 26 )
   local aSer           := { .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t. }
   local oDbfTmp
   local nRec           := ( dbfAlqCliT )->( Recno() )
   local nOrd           := ( dbfAlqCliT )->( OrdSetFocus( "nNumAlq" ) )

   if File( cPatTmp() + "GenFac.Dbf" ) .and. fErase( cPatTmp() + "GenFac.Dbf" ) == -1
      MsgStop( "Esta opción esta en uso por otro usuario" )
      Return nil
   end if

   oDbfTmp              := dbfServer( "GenFac", SubStr( Str( Seconds() ), -6 ) ):New( "GenFac", "GenFac", cDriver(), , cPatTmp() )
   oDbfTmp:AddField( "lFacAlq", "L", 1, 0 )
   oDbfTmp:AddField( "cSerDoc", "C", 1, 0 )
   oDbfTmp:AddField( "nNumDoc", "N", 9, 0 )
   oDbfTmp:AddField( "lNewDoc", "L", 1, 0 )
   oDbfTmp:AddField( "cNumAlq", "C",12, 0 )
   oDbfTmp:AddField( "dFecAlq", "D", 8, 0 )
   oDbfTmp:AddField( "cCodCli", "C",12, 0 )
   oDbfTmp:AddField( "cNomCli", "C",50, 0 )
   oDbfTmp:AddField( "cCodObr", "C",10, 0 )
   oDbfTmp:AddField( "lIvaInc", "L", 1, 0 )
   oDbfTmp:AddField( "lRecargo","L", 1, 0 )
   oDbfTmp:AddField( "cCodPgo", "C", 2, 0 )
   oDbfTmp:AddField( "nTotAlq", "N",19, 6 )
   oDbfTmp:Activate( .f., .f. )

   oDbfTmp:AddTmpIndex( "cCodObr", "GenFac", "cSerDoc + cCodCli + if( lIvaInc, '0', '1' ) + if( lRecargo, '0', '1' ) + cCodObr" )
   oDbfTmp:AddTmpIndex( "cCodPgo", "GenFac", "cSerDoc + cCodCli + cCodPgo + if( lIvaInc, '0', '1' ) + if( lRecargo, '0', '1' ) + cCodObr" )
   oDbfTmp:AddTmpIndex( "nNumDoc", "GenFac", "cSerDoc + Str( nNumDoc ) + if( lNewDoc, '0', '1' )" )
   oDbfTmp:AddTmpIndex( "cNumAlq", "GenFac", "cNumAlq" )


	/*
	Obtenemos los valores del primer y ultimo codigo
	*/

   if dbfAlqCliT != nil
      cCliDes     := ( dbfAlqCliT )->cCodCli
      cCliHas     := ( dbfAlqCliT )->cCodCli
   else
      cCliDes     := dbFirst( dbfClient, 1 )
      cCliHas     := dbLast(  dbfClient, 1 )
   end if

   cGrpDes        := dbFirst( oGrpCli:oDbf, 1 )
   cGrpHas        := dbLast(  oGrpCli:oDbf, 1 )

   /*
   Dialogo---------------------------------------------------------------------
   */

   DEFINE DIALOG oDlg RESOURCE "GENFAC"

   REDEFINE PAGES oPag ;
      ID       110 ;
      OF       oDlg ;
      DIALOGS  "GENFAC_01",;
               "GENFAC_02"

   /*
   Clientes--------------------------------------------------------------------
   */

   REDEFINE CHECKBOX lAllCli ;
      ID       100 ;
      OF       oPag:aDialogs[ 1 ]

   REDEFINE GET oCliDes VAR cCliDes;
		ID 		110 ;
      WHEN     ( !lAllCli );
      VALID    ( cClient( oCliDes, dbfClient, oNomCliDes ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwClient( oCliDes, oNomCliDes ) ) ;
      OF       oPag:aDialogs[ 1 ]

   REDEFINE GET oNomCliDes VAR cNomCliDes ;
		WHEN 		.F. ;
		ID 		111 ;
      OF       oPag:aDialogs[ 1 ]

   REDEFINE GET oCliHas VAR cCliHas;
		ID 		120 ;
      WHEN     ( !lAllCli );
      VALID    ( cClient( oCliHas, dbfClient, oNomCliHas ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwClient( oCliHas, oNomCliHas ) ) ;
      OF       oPag:aDialogs[ 1 ]

   REDEFINE GET oNomCliHas VAR cNomCliHas ;
		WHEN 		.F. ;
      ID       121 ;
      OF       oPag:aDialogs[ 1 ]

   /*
   Grupos de clientes----------------------------------------------------------
   */

   REDEFINE CHECKBOX lAllGrp ;
      ID       90 ;
      OF       oPag:aDialogs[ 1 ]

   REDEFINE GET oGrpDes VAR cGrpDes;
      ID       160 ;
      WHEN     ( !lAllGrp );
      VALID    ( oGrpCli:Existe( oGrpDes, oNomGrpDes, "CNOMGRP", .t., .t., "0" ) );
      ON HELP  ( oGrpCli:Buscar( oGrpDes ) );
      BITMAP   "LUPA" ;
      OF       oPag:aDialogs[ 1 ]

   REDEFINE GET oNomGrpDes VAR cNomGrpDes ;
		WHEN 		.F. ;
      ID       161 ;
      OF       oPag:aDialogs[ 1 ]

   REDEFINE GET oGrpHas VAR cGrpHas;
      ID       170 ;
      WHEN     ( !lAllGrp );
      VALID    ( oGrpCli:Existe( oGrpHas, oNomGrpHas, "CNOMGRP", .t., .t., "0" ) );
      ON HELP  ( oGrpCli:Buscar( oGrpHas ) );
      BITMAP   "LUPA" ;
      OF       oPag:aDialogs[ 1 ]

   REDEFINE GET oNomGrpHas VAR cNomGrpHas ;
		WHEN 		.F. ;
      ID       171 ;
      OF       oPag:aDialogs[ 1 ]

   REDEFINE GET dDesAlq;
      SPINNER ;
      ID       130 ;
      OF       oPag:aDialogs[ 1 ]

   REDEFINE GET dHasAlq;
      SPINNER ;
      ID       140 ;
      OF       oPag:aDialogs[ 1 ]

   REDEFINE CHECKBOX lGrpCli;
      ID       175 ;
      OF       oPag:aDialogs[ 1 ]

   REDEFINE RADIO nGrpObr ;
      WHEN     ( lGrpCli );
      ID       180, 181, 182 ;
      OF       oPag:aDialogs[ 1 ]

   REDEFINE CHECKBOX lTotAlq;
      ID       185 ;
      OF       oPag:aDialogs[ 1 ]

   REDEFINE CHECKBOX lUniPgo;
      ID       186 ;
      OF       oPag:aDialogs[ 1 ]

   REDEFINE CHECKBOX lNotImp;
      ID       187 ;
      OF       oPag:aDialogs[ 1 ]

   REDEFINE RADIO nRadFec ;
      ID       190, 191 ;
      OF       oPag:aDialogs[ 1 ]

   REDEFINE GET dFecFac;
      WHEN     ( nRadFec == 1 ) ;
      SPINNER ;
      ID       150 ;
      OF       oPag:aDialogs[ 1 ]

   TWebBtn():Redefine(310,,,,, {|This| ( aEval( oSer, {|o| Eval( o:bSetGet, .T. ), o:refresh() } ) ) }, oPag:aDialogs[ 1 ],,,,, "LEFT",,,,, ( 0 + ( 0 * 256 ) + ( 255 * 65536 ) ), ( 0 + ( 0 * 256 ) + ( 255 * 65536 ) ),,,, "Seleccionar todas las series",,,, )

   TWebBtn():Redefine(320,,,,, {|This| ( aEval( oSer, {|o| Eval( o:bSetGet, .F. ), o:refresh() } ) ) }, oPag:aDialogs[ 1 ],,,,, "LEFT",,,,, ( 0 + ( 0 * 256 ) + ( 255 * 65536 ) ), ( 0 + ( 0 * 256 ) + ( 255 * 65536 ) ),,,, "Deseleccionar todas las series",,,, )

   REDEFINE CHECKBOX oSer[  1 ] VAR aSer[  1 ] ID 370 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX oSer[  2 ] VAR aSer[  2 ] ID 371 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX oSer[  3 ] VAR aSer[  3 ] ID 372 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX oSer[  4 ] VAR aSer[  4 ] ID 373 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX oSer[  5 ] VAR aSer[  5 ] ID 374 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX oSer[  6 ] VAR aSer[  6 ] ID 375 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX oSer[  7 ] VAR aSer[  7 ] ID 376 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX oSer[  8 ] VAR aSer[  8 ] ID 377 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX oSer[  9 ] VAR aSer[  9 ] ID 378 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX oSer[ 10 ] VAR aSer[ 10 ] ID 379 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX oSer[ 11 ] VAR aSer[ 11 ] ID 380 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX oSer[ 12 ] VAR aSer[ 12 ] ID 381 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX oSer[ 13 ] VAR aSer[ 13 ] ID 382 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX oSer[ 14 ] VAR aSer[ 14 ] ID 383 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX oSer[ 15 ] VAR aSer[ 15 ] ID 384 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX oSer[ 16 ] VAR aSer[ 16 ] ID 385 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX oSer[ 17 ] VAR aSer[ 17 ] ID 386 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX oSer[ 18 ] VAR aSer[ 18 ] ID 387 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX oSer[ 19 ] VAR aSer[ 19 ] ID 388 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX oSer[ 20 ] VAR aSer[ 20 ] ID 389 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX oSer[ 21 ] VAR aSer[ 21 ] ID 390 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX oSer[ 22 ] VAR aSer[ 22 ] ID 391 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX oSer[ 23 ] VAR aSer[ 23 ] ID 392 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX oSer[ 24 ] VAR aSer[ 24 ] ID 393 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX oSer[ 25 ] VAR aSer[ 25 ] ID 394 OF oPag:aDialogs[ 1 ]
   REDEFINE CHECKBOX oSer[ 26 ] VAR aSer[ 26 ] ID 395 OF oPag:aDialogs[ 1 ]

   /*
   Segunda caja de dialogo-----------------------------------------------------
   */

   REDEFINE IBROWSE oBrwAlq ;
         FIELDS ;
                  if( !oDbfTmp:lFacAlq, aDbfBmp[ 8 ], "" ),;
                  if( oDbfTmp:lNewDoc,  aDbfBmp[ 8 ], "" ),;
                  StrTran( Trans( oDbfTmp:cNumAlq, '@R #/#########/##' ), " ", "" ),;
                  dtoc( oDbfTmp:dFecAlq ),;
                  Rtrim( oDbfTmp:cCodCli ) + Space(1) + oDbfTmp:cNomCli,;
                  if( oDbfTmp:lIvaInc, "Inc.", "Des." ),;
                  oDbfTmp:cCodObr,;
                  oDbfTmp:cCodPgo,;
                  Trans( oDbfTmp:nTotAlq, PicOut() ) ;
         FIELDSIZES ;
                  17 ,;
                  17,;
                  80 ,;
                  70 ,;
                  200 ,;
                  30 ,;
                  60 ,;
                  40 ,;
                  100 ;
         HEAD ;
                  "S",;
                  "",;
                  "Num. Alq." ,;
                  "Fecha" ,;
                  "Cliente",;
                  cImp(),;
                  "Dirección",;
                  "F. Pago",;
                  "Importe" ;
         JUSTIFY  .f., .f., .f., .f., .f., .f., .f., .f., .t. ;
         ID       180 ;
         OF       oPag:aDialogs[ 2 ]

   oBrwAlq:bLDblClick   := {|| oDbfTmp:lFacAlq := !oDbfTmp:lFacAlq, oBrwAlq:refresh() }
   oBrwAlq:cWndName     := "Linea de generar factura cliente detalle"
   oBrwAlq:Load()

   oDbfTmp:SetBrowse( oBrwAlq )

   REDEFINE BUTTON ;
      ID       514;
      OF       oPag:aDialogs[ 2 ] ;
      ACTION   ( oDbfTmp:Load(), oDbfTmp:lFacAlq := !oDbfTmp:lFacAlq, oDbfTmp:Save(), oBrwAlq:refresh() )

   REDEFINE BUTTON ;
      ID       516;
      OF       oPag:aDialogs[ 2 ] ;
      ACTION   ( oDbfTmp:GetStatus(), oDbfTmp:DbEval( {|| oDbfTmp:Load(), oDbfTmp:lFacAlq := .f., oDbfTmp:Save() } ), oDbfTmp:SetStatus(), oBrwAlq:refresh() )

   REDEFINE BUTTON ;
      ID       517;
      OF       oPag:aDialogs[ 2 ] ;
      ACTION   ( oDbfTmp:GetStatus(), oDbfTmp:DbEval( {|| oDbfTmp:Load(), oDbfTmp:lFacAlq := .t., oDbfTmp:Save() } ), oDbfTmp:SetStatus(), oBrwAlq:refresh() )

 REDEFINE APOLOMETER oMetMsg VAR nMetMsg ;
      ID       120 ;
      OF       oDlg

   REDEFINE BUTTON oBtnPrv ;
      ID       500;
		OF 		oDlg ;
      ACTION   ( GoPrev( oPag, oBtnPrv, oBtnNxt ) )

   REDEFINE BUTTON oBtnNxt ;
      ID       501;
		OF 		oDlg ;
      ACTION   ( GoNext(   cCliDes, cCliHas, cGrpDes, cGrpHas, dDesAlq, lAllGrp, lAllCli, dHasAlq,;
                           nRadFec, dFecFac, aSer, oDbfTmp, oBrwAlq, oDlg, oPag, lGrpCli, nGrpObr,;
                           lTotAlq, lUniPgo, lNotImp, oBtnPrv, oBtnNxt, oMetMsg, dbfAlqCliT, dbfAlqCliL, dbfAlqCliP,;
                           dbfClient, dbfCliAtp, dbfIva, dbfDiv, dbfUsr, dbfFPago, dbfCount, oStock ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
		OF 		oDlg ;
      CANCEL ;
      ACTION   ( oDlg:End() )

      oDlg:bStart := {|| oCliDes:lValid(), oCliHas:lValid(), oGrpDes:lValid(), oGrpHas:lValid() }

   ACTIVATE DIALOG oDlg CENTER ON INIT ( oBtnPrv:Hide() )

   /*
   Reposicionamiento-----------------------------------------------------------
   */

   ( dbfAlqCliT )->( OrdSetFocus( nOrd ) )
   ( dbfAlqCliT )->( dbGoTo( nRec ) )

   /*
   Desbloqueo de todas los registros-------------------------------------------
   */

   Desbloqueo( oDbfTmp, dbfAlqCliT )

   /*
   Fin de tarea----------------------------------------------------------------
   */

   oDbfTmp:End()

   fErase( cPatTmp() + "GenFac.Dbf" )
   fErase( cPatTmp() + "GenFac.Cdx" )

   oBrw:Refresh()

   /*
    Guardamos los datos del browse
   */
   oBrwAlq:CloseData()

RETURN NIL

//---------------------------------------------------------------------------//

Static Function Desbloqueo( oDbfTmp, dbfAlqCliT )

   local nRec  := ( dbfAlqCliT )->( Recno() )
   local nOrd  := ( dbfAlqCliT )->( OrdSetFocus() )

   /*
   Desbloqueo------------------------------------------------------------------
   */

   oDbfTmp:GoTop()
   while !oDbfTmp:Eof()
      if ( dbfAlqCliT )->( dbSeek( oDbfTmp:cNumAlq ) )
         ( dbfAlqCliT )->( dbRUnLock( ( dbfAlqCliT )->( Recno() ) ) )
      end if
      oDbfTmp:Skip()
   end while
   oDbfTmp:GoTop()

   ( dbfAlqCliT )->( OrdSetFocus( nOrd ) )
   ( dbfAlqCliT )->( dbGoTo( nRec ) )

return nil

//---------------------------------------------------------------------------//

Static Function GetFormaDePago( cCodCli, cCodPgo, oDbfTmp )

   local lFormaPago  := .f.
   local cFormaPago  := oDbfTmp:cCodPgo

   oDbfTmp:GetStatus()
   oDbfTmp:GoTop()

   while !oDbfTmp:Eof()

      if oDbfTmp:cCodCli == cCodCli .and. !oDbfTmp:lFacAlq .and. cFormaPago != oDbfTmp:cCodPgo
         lFormaPago  := .t.
      end if

      oDbfTmp:Skip()

   end while

   oDbfTmp:SetStatus()

   if lFormaPago
      cFormaPago     := cCodPgo
   end if

return ( cFormaPago )

//---------------------------------------------------------------------------//

static function GoPrev( oPag, oBtnPrv, oBtnNxt )

   if oPag:nOption == 2
      SetWindowText( oBtnNxt:hWnd, "&Siguiente >" )
      oBtnPrv:Hide()
      oPag:GoPrev()
   end

return nil

//---------------------------------------------------------------------------//

static function GoNext( cCliDes, cCliHas, cGrpDes, cGrpHas, dDesAlq, lAllGrp, lAllCli, dHasAlq,;
                        nRadFec, dFecFac, aSer, oDbfTmp, oBrwAlq, oDlg, oPag, lGrpCli, nGrpObr,;
                        lTotAlq, lUniPgo, lNotImp, oBtnPrv, oBtnNxt, oMetMsg, dbfAlqCliT, dbfAlqCliL, dbfAlqCliP,;
                        dbfClient, dbfCliAtp, dbfIva, dbfDiv, dbfUsr, dbfFPago, dbfCount, oStock )

   do case
   case oPag:nOption == 1
      LoaAlqFac(  cCliDes, cCliHas, cGrpDes, cGrpHas, dDesAlq, lAllGrp, lAllCli, dHasAlq, lGrpCli, nGrpObr,;
                  lTotAlq, lUniPgo, lNotImp, aSer, oDbfTmp, oBrwAlq, oDlg, oMetMsg, dbfAlqCliT, dbfAlqCliL, dbfClient,;
                  dbfCliAtp, dbfIva, dbfDiv, dbfFPago )

      oBtnPrv:Show()
      SetWindowText( oBtnNxt:hWnd, "&Terminar" )
      oPag:GoNext()

   case oPag:nOption == 2
      MakFacCli(  oDbfTmp, dFecFac, lGrpCli, nGrpObr, lTotAlq, lUniPgo, lNotImp, nRadFec, oBrwAlq, oMetMsg,;
                  dbfAlqCliT, dbfAlqCliL, dbfAlqCliP, dbfClient, dbfCliAtp, dbfIva, dbfDiv,;
                  dbfFPago, dbfUsr, dbfCount, oStock, oDlg )

      oDlg:End()

   end case

return nil

//---------------------------------------------------------------------------//

STATIC FUNCTION loaAlqFac( cCliDes, cCliHas, cGrpDes, cGrpHas, dDesAlq, lAllGrp, lAllCli, dHasAlq, lGrpCli, nGrpObr,;
                           lTotAlq, lUniPgo, lNotImp, aSer, oDbfTmp, oBrwAlq, oDlg, oMetMsg, dbfAlqCliT, dbfAlqCliL, dbfClient,;
                           dbfCliAtp, dbfIva, dbfDiv, dbfFPago )

   local lNuevo   := .t.
   local nOrdAnt
   local cIvaInc
   local cRecargo
   local nNumero  := 0
   local nRecAnt  := ( dbfAlqCliT )->( RecNo() )
   local cExpHead := '!lFacturado'
   local cCodPgo

   if lGrpCli

      if nGrpObr == 1
         nOrdAnt  := ( dbfAlqCliT )->( ordSetFocus( "cCodCli" ) )
      else
         nOrdAnt  := ( dbfAlqCliT )->( ordSetFocus( "cCodObr" ) )
      end if

      if lUniPgo
         oDbfTmp:OrdSetFocus( "cCodObr" )
      else
         oDbfTmp:OrdSetFocus( "cCodPgo" )
      end if

   else

      nOrdAnt     := ( dbfAlqCliT )->( ordSetFocus( "nNumAlq" ) )

      oDbfTmp:OrdSetFocus( "cNumAlq" )

   end if

   oDlg:Disable()

   CursorWait()

   /*
   Tablas temporales inicializadas---------------------------------------------
   */

   Desbloqueo( oDbfTmp, dbfAlqCliT )

   oDbfTmp:Zap()

   /*
   Selección de registros------------------------------------------------------
	*/

   // Creamos los indices para que esto vaya mucho mas rápido y informamos el meter

   if !lAllGrp
      cExpHead    += '.and. cCodGrp >= "' + Rtrim( cGrpDes ) + '" .and. cCodGrp <= "' + Rtrim( cGrpHas ) + '"'
   end if
   if !lAllCli
      cExpHead    += '.and. cCodCli >= "' + Rtrim( cCliDes ) + '" .and. cCodCli <= "' + Rtrim( cCliHas ) + '"'
   end if
   cExpHead       += '.and. dFecAlq >= Ctod( "' + Dtoc( dDesAlq ) + '" ) .and. dFecAlq <= Ctod( "' + Dtoc( dHasAlq ) + '" )'
   cExpHead       += '.and. !Deleted()'

   // Texto y creacion de filtros----------------------------------------------

   oMetMsg:cText  := "Creando filtros..."
   oMetMsg:Refresh()

   if CreateFastFilter( cExpHead, dbfAlqCliT, .f. )

      // fin de creacion del indice rapido----------------------------------------

      oMetMsg:SetTotal( ( dbfAlqCliT )->( OrdKeyCount() ) )

      ( dbfAlqCliT )->( dbGoTop() )
      while !( dbfAlqCliT )->( eof() )

         if lChkSer( ( dbfAlqCliT )->cSerAlq, aSer )

            lNuevo            := .f.

            if lGrpCli

               cIvaInc        := if( ( dbfAlqCliT )->lIvaInc,  '0', '1' )
               cRecargo       := if( ( dbfAlqCliT )->lRecargo, '0', '1' )

               /*
               Para unificar formas de pagos todas nos valen----------------------
               */

               if lUniPgo
                  cCodPgo     := ""
               else
                  cCodPgo     := ( dbfAlqCliT )->cCodPago
               end if

               do case
               case nGrpObr == 1 .or. nGrpObr == 2

                  if oDbfTmp:Seek( ( dbfAlqCliT )->cSerAlq + ( dbfAlqCliT )->cCodCli + cCodPgo + cIvaInc + cRecargo )

                     AgregaAlquiler( oDbfTmp:nNumDoc, .f., oDbfTmp, dbfAlqCliT, dbfAlqCliL, dbfIva, dbfDiv )

                  else

                     AgregaAlquiler( ++nNumero, .t., oDbfTmp, dbfAlqCliT, dbfAlqCliL, dbfIva, dbfDiv )

                  end if

               case nGrpObr == 3

                  if oDbfTmp:Seek( ( dbfAlqCliT )->cSerAlq + ( dbfAlqCliT )->cCodCli + cCodPgo + cIvaInc + cRecargo + ( dbfAlqCliT )->cCodObr )

                     AgregaAlquiler( oDbfTmp:nNumDoc, .f., oDbfTmp, dbfAlqCliT, dbfAlqCliL, dbfIva, dbfDiv )

                  else

                     AgregaAlquiler( ++nNumero, .t., oDbfTmp, dbfAlqCliT, dbfAlqCliL, dbfIva, dbfDiv )

                  end if

               end case

            else

               AgregaAlquiler( ++nNumero, .t., oDbfTmp, dbfAlqCliT, dbfAlqCliL, dbfIva, dbfDiv )

            end if

         end if

         ( dbfAlqCliT )->( dbSkip() )

         oMetMsg:Set( ( dbfAlqCliT )->( OrdKeyNo() ) )

         SysRefresh()

      end do

      oMetMsg:Set( ( dbfAlqCliT )->( OrdKeyCount() ) )

      /*
      Borramos el filtro----------------------------------------------------------
      */

      DestroyFastFilter( dbfAlqCliT )

   end if

   ( dbfAlqCliT )->( OrdSetFocus( nOrdAnt ) )
   ( dbfAlqCliT )->( dbGoTo( nRecAnt ) )

   /*
   Nos vamos al primer registro------------------------------------------------
   */

   oDbfTmp:OrdSetFocus( "nNumDoc" )
   oDbfTmp:GoTop()

	/*
   Puede que no hay alquileres que facturar-------------------------------------
	*/

   oBrwAlq:Refresh()

   /*
   Ponemos enable--------------------------------------------------------------
	*/

   oDlg:Enable()

   CursorWE()

RETURN NIL

//---------------------------------------------------------------------------//

Static Function AgregaAlquiler( nNumero, lNuevo, oDbfTmp, dbfAlqCliT, dbfAlqCliL, dbfIva, dbfDiv )

   if ( dbfAlqCliT )->( dbRLock( ( dbfAlqCliT )->( Recno() ) ) )
      oDbfTmp:Append()
      oDbfTmp:nNumDoc   := nNumero
      oDbfTmp:lNewDoc   := lNuevo
      oDbfTmp:cSerDoc   := ( dbfAlqCliT )->cSerAlq
      oDbfTmp:lFacAlq   := ( dbfAlqCliT )->lFacturado
      oDbfTmp:cNumAlq   := ( dbfAlqCliT )->cSerAlq + Str( ( dbfAlqCliT )->nNumAlq ) + ( dbfAlqCliT )->cSufAlq
      oDbfTmp:dFecAlq   := ( dbfAlqCliT )->dFecAlq
      oDbfTmp:cCodCli   := ( dbfAlqCliT )->cCodCli
      oDbfTmp:cNomCli   := ( dbfAlqCliT )->cNomCli
      oDbfTmp:cCodObr   := ( dbfAlqCliT )->cCodObr
      oDbfTmp:lIvaInc   := ( dbfAlqCliT )->lIvaInc
      oDbfTmp:lRecargo  := ( dbfAlqCliT )->lRecargo
      oDbfTmp:cCodPgo   := ( dbfAlqCliT )->cCodPago
      oDbfTmp:nTotAlq   := nTotAlqCli( ( dbfAlqCliT )->cSerAlq + Str( ( dbfAlqCliT)->nNumAlq ) + ( dbfAlqCliT )->cSufAlq, dbfAlqCliT, dbfAlqCliL, dbfIva, dbfDiv, nil, cDivEmp(), .f. )
      oDbfTmp:Save()
   end if

Return nil

//---------------------------------------------------------------------------//

Static Function MarcaAlquiler( dbfAlqCliT, dbfFacCliT )

   ( dbfAlqCliT )->lFacturado := .t.
   ( dbfAlqCliT )->cNumFac    := ( dbfFacCliT )->cSerie + Str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac

Return nil

//---------------------------------------------------------------------------//

Static Function MakFacCli( oDbfTmp, dFecFac, lGrpCli, nGrpObr, lTotAlq, lUniPgo, lNotImp, nRadFec, oBrw, oMetMsg,;
                           dbfAlqCliT, dbfAlqCliL, dbfAlqCliP, dbfClient, dbfCliAtp, dbfIva, dbfDiv,;
                           dbfFPago, dbfUsr, dbfCount, oStock, oDlg )

   local oBlock
   local oError
   local nNumRec     := 0
   local dbfFacCliT
   local dbfFacCliL
   local dbfFacCliP
   local dbfAntCliT
   local aProcesado  := {}
   local nProcesando := 0
   local cLinObr     := Space( 1 )
   local cSerAlq
   local nNewFac     := 0
   local cSufEmp     := RetSufEmp()
   local lTotAlqCli
   local nNumLin     := 0
   local cPath       := cPatEmp()
   local nRec        := ( dbfAlqCliT )->( Recno() )
   local nOrd        := ( dbfAlqCliT )->( OrdSetFocus( "nNumAlq" ) )
   local aMsg        := {}
   local cDesAlq
   local cCodPgo
   local cCodCli

   if oDbfTmp:LastRec() <= 0
      msgStop( "No hay alquileres para facturar" )
      return nil
   end if

   oDlg:Disable()

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( cPath + "FACCLIT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIT", @dbfFacCliT ) )
   SET ADSINDEX TO ( cPath + "FACCLIT.CDX" ) ADDITIVE

   USE ( cPath + "FACCLIL.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIL", @dbfFacCliL ) )
   SET ADSINDEX TO ( cPath + "FACCLIL.CDX" ) ADDITIVE

   USE ( cPath + "FACCLIP.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIP", @dbfFacCliP ) )
   SET ADSINDEX TO ( cPath + "FACCLIP.CDX" ) ADDITIVE

   USE ( cPath + "AntCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AntCliT", @dbfAntCliT ) )
   SET ADSINDEX TO ( cPath + "AntCliT.CDX" ) ADDITIVE

   /*
   Meter-----------------------------------------------------------------------
   */

   oMetMsg:SetTotal( oDbfTmp:LastRec() )

   oDbfTmp:GoTop()
   while !oDbfTmp:Eof()

      /*
      Posicionamiento en el alquiler
      */

      if ( dbfAlqCliT )->( dbSeek( oDbfTmp:cNumAlq ) ) .and. !oDbfTmp:lFacAlq

         nProcesando                   := oDbfTmp:nNumDoc

         /*
         Encontrado uno valido
         */

         if aScan( aProcesado, nProcesando ) == 0

            aAdd( aProcesado, nProcesando )

            /*
            Nueva factura______________________________________________________
            */

            cSerAlq                    := ( dbfAlqCliT )->cSerAlq
            nNewFac                    := nNewDoc( ( dbfAlqCliT )->cSerAlq, dbfFacCliT, "NFACCLI", , dbfCount )
            nNumLin                    := 0
            cLinObr                    := Space( 1 )

            ( dbfFacCliT )->( dbAppend() )
            ( dbfFacCliT )->cSerie     := cSerAlq
            ( dbfFacCliT )->nNumFac    := nNewFac
            ( dbfFacCliT )->cSufFac    := cSufEmp
            ( dbfFacCliT )->cTurFac    := cCurSesion()
            ( dbfFacCliT )->cCodAlm    := ( dbfAlqCliT )->cCodAlm
            ( dbfFacCliT )->cCodUsr    := cCurUsr()
            ( dbfFacCliT )->dFecCre    := Date()
            ( dbfFacCliT )->cTimCre    := Time()
            ( dbfFacCliT )->lImpAlq    := .t.
            ( dbfFacCliT )->cCodDlg    := RetFld( cCurUsr(), dbfUsr, "cCodDlg" )

            if nRadFec == 1
               ( dbfFacCliT )->dFecFac := dFecFac
            else
               ( dbfFacCliT )->dFecFac := ( dbfAlqCliT )->dFecAlq
            end if

            /*
            Si no estamos agrupando por clientes anotamos el numero del alquiler en la
            factura
            */

            if !lGrpCli
               ( dbfFacCliT )->cNumAlq    := ( dbfAlqCliT )->cSerAlq + Str( ( dbfAlqCliT )->nNumAlq ) + ( dbfAlqCliT )->cSufAlq
            end if

            /*
            Asignando datos del cliente
            */

            cCodCli                       := ( dbfAlqCliT )->cCodCli
            ( dbfFacCliT )->cCodCli       := cCodCli

            if ( dbfClient )->( dbSeek( cCodCli ) )
               ( dbfFacCliT )->cNomCli    := ( dbfClient )->Titulo
               ( dbfFacCliT )->cDirCli    := ( dbfClient )->Domicilio
               ( dbfFacCliT )->cPobCli    := ( dbfClient )->Poblacion
               ( dbfFacCliT )->cPrvCli    := ( dbfClient )->Provincia
               ( dbfFacCliT )->cPosCli    := ( dbfClient )->CodPostal
               ( dbfFacCliT )->cDniCli    := ( dbfClient )->Nif
               ( dbfFacCliT )->nTarifa    := Max( ( dbfClient )->nTarifa, 1 )
               lTotAlqCli                 := ( dbfClient )->lTotAlb
               cCodPgo                    := ( dbfClient )->CodPago
            end if

            /*
            Recoje la forma de pago--------------------------------------------
            */

            if lUniPgo
               ( dbfFacCliT )->cCodPago   := GetFormaDePago( cCodCli, cCodPgo, oDbfTmp )
            else
               ( dbfFacCliT )->cCodPago   := oDbfTmp:cCodPgo
            end if

            if Empty( ( dbfFacCliT )->nTarifa )
               ( dbfFacCliT )->nTarifa    := Max( ( dbfAlqCliT )->nTarifa, 1 )
            end if

            ( dbfFacCliT )->cCodAge       := ( dbfAlqCliT )->cCodAge
            ( dbfFacCliT )->cCodRut       := ( dbfAlqCliT )->cCodRut
            ( dbfFacCliT )->cCodTar       := ( dbfAlqCliT )->cCodTar
            ( dbfFacCliT )->cCodObr       := ( dbfAlqCliT )->cCodObr
            ( dbfFacCliT )->cDivFac       := ( dbfAlqCliT )->cDivAlq
            ( dbfFacCliT )->nVdvFac       := ( dbfAlqCliT )->nVdvAlq
            ( dbfFacCliT )->cDtoEsp       := ( dbfAlqCliT )->cDtoEsp
            ( dbfFacCliT )->nDtoEsp       := ( dbfAlqCliT )->nDtoEsp
            ( dbfFacCliT )->cDpp          := ( dbfalqclit )->cDpp
            ( dbfFacCliT )->nDpp          := ( dbfalqclit )->nDpp
            ( dbfFacCliT )->cDtoUno       := ( dbfAlqCliT )->cDtoUno
            ( dbfFacCliT )->nDtoUno       := ( dbfAlqCliT )->nDtoUno
            ( dbfFacCliT )->cDtoDos       := ( dbfAlqCliT )->cDtoDos
            ( dbfFacCliT )->nDtoDos       := ( dbfAlqCliT )->nDtoDos
            ( dbfFacCliT )->lRecargo      := ( dbfAlqCliT )->lRecargo
            ( dbfFacCliT )->mComent       := ( dbfAlqCliT )->mComent
            ( dbfFacCliT )->mObserv       := ( dbfAlqCliT )->mObserv
            ( dbfFacCliT )->cCodTrn       := ( dbfAlqCliT )->cCodTrn
            ( dbfFacCliT )->cCodPro       := cProCnt( ( dbfAlqCliT )->cSerAlq )
            ( dbfFacCliT )->lIvaInc       := ( dbfAlqCliT )->lIvaInc
            ( dbfFacCliT )->lSndDoc       := .t.

            aAdd( aMsg, {.t., "Factura generada : " + ( dbfFacCliT )->cSerie + "/" + Alltrim( Str( ( dbfFacCliT )->nNumFac ) ) + "/" + ( dbfFacCliT )->cSufFac } )

         end if

         /*
         Marca para no volver a facturar el alquiler____________________________
         */

         MarcaAlquiler( dbfAlqCliT, dbfFacCliT )

         /*
         Posicinamiento en lineas de alquiler_________________________________
         */

         if ( dbfAlqCliL )->( dbSeek( oDbfTmp:cNumAlq ) )

            /*
            Obras
            */

            if lNumObr() .and. ( dbfAlqCliT )->cCodObr != cLinObr
               ( dbfFacCliL )->( dbAppend() )
               ( dbfFacCliL )->nNumLin    := ++nNumLin
               ( dbfFacCliL )->cSerie     := cSerAlq
               ( dbfFacCliL )->nNumFac    := nNewFac
               ( dbfFacCliL )->cSufFac    := cSufEmp
               ( dbfFacCliL )->cDetalle   := Alltrim( cNumObr() ) + Space( 1 ) + ( dbfAlqCliT )->cCodObr
               ( dbfFacCliL )->lControl   := .t.
               cLinObr                    := ( dbfAlqCliT )->cCodObr
            end if

            /*
            Alquileres
            */

            if lNumAlq() .or. lSuAlq()
               ( dbfFacCliL )->( dbAppend() )
               ( dbfFacCliL )->nNumLin    := ++nNumLin
               ( dbfFacCliL )->cSerie     := cSerAlq
               ( dbfFacCliL )->nNumFac    := nNewFac
               ( dbfFacCliL )->cSufFac    := cSufEmp
               cDesAlq                    := ""
               if lNumAlq()
                  cDesAlq                 += Alltrim( cNumAlq() ) + " " + Left( oDbfTmp:cNumAlq, 1 ) + "/" + AllTrim( SubStr( oDbfTmp:cNumAlq, 2, 9 ) ) + "/" + Right( oDbfTmp:cNumAlq, 2 ) + Space( 1 )
               end if
               if lSuAlq()
                  cDesAlq                 += Alltrim( cSuAlq() ) + " " + Rtrim( ( dbfAlqCliT )->cCodSuAlq ) + Space( 1 )
               end if
               cDesAlq                    += dtoc( oDbfTmp:dFecAlq )
               ( dbfFacCliL )->cDetalle   := cDesAlq
               ( dbfFacCliL )->lControl   := .t.
            end if

            /*
            Añadimos lineas de detalle
            */

            while ( ( dbfAlqCliL )->cSerAlq + Str( ( dbfAlqCliL )->nNumAlq ) + ( dbfAlqCliL )->cSufAlq == oDbfTmp:cNumAlq ) .AND. !( dbfAlqCliL )->( eof() )

               ( dbfFacCliL )->( dbAppend() )
               ( dbfFacCliL )->nNumLin    := ++nNumLin
               ( dbfFacCliL )->cSerie     := cSerAlq
               ( dbfFacCliL )->nNumFac    := nNewFac
               ( dbfFacCliL )->cSufFac    := cSufEmp
               ( dbfFacCliL )->cRef       := ( dbfAlqCliL )->cRef
               ( dbfFacCliL )->cDetalle   := ( dbfAlqCliL )->cDetalle
               ( dbfFacCliL )->mLngDes    := ( dbfAlqCliL )->mLngDes
               ( dbfFacCliL )->mNumSer    := ( dbfAlqCliL )->mNumSer
               ( dbfFacCliL )->nCanEnt    := ( dbfAlqCliL )->dFecEnt - ( dbfAlqCliL )->dFecSal // ( dbfAlqCliL )->nCanEnt
               ( dbfFacCliL )->cUnidad    := ( dbfAlqCliL )->cUnidad
               ( dbfFacCliL )->nUniCaja   := ( dbfAlqCliL )->nUniCaja
               ( dbfFacCliL )->nUndKit    := ( dbfAlqCliL )->nUndKit
               ( dbfFacCliL )->nPesoKg    := ( dbfAlqCliL )->nPesoKg
               ( dbfFacCliL )->nIva       := ( dbfAlqCliL )->nIva
               ( dbfFacCliL )->nReq       := ( dbfAlqCliL )->nReq
               ( dbfFacCliL )->nDto       := ( dbfAlqCliL )->nDto
               ( dbfFacCliL )->nDtoDiv    := ( dbfAlqCliL )->nDtoDiv
               ( dbfFacCliL )->nPntVer    := ( dbfAlqCliL )->nPntVer
               ( dbfFacCliL )->nDtoPrm    := ( dbfAlqCliL )->nDtoPrm
               ( dbfFacCliL )->nComAge    := ( dbfAlqCliL )->nComAge
               ( dbfFacCliL )->dFecha     := ( dbfAlqCliL )->dFecha
               ( dbfFacCliL )->cTipMov    := ( dbfAlqCliL )->cTipMov
               ( dbfFacCliL )->cAlmLin    := ( dbfAlqCliL )->cAlmLin
               ( dbfFacCliL )->nCtlStk    := ( dbfAlqCliL )->nCtlStk
               ( dbfFacCliL )->nCosDiv    := ( dbfAlqCliL )->nCosDiv
               ( dbfFacCliL )->lControl   := ( dbfAlqCliL )->lControl
               ( dbfFacCliL )->lKitArt    := ( dbfAlqCliL )->lKitArt
               ( dbfFacCliL )->lKitChl    := ( dbfAlqCliL )->lKitChl
               ( dbfFacCliL )->lKitPrc    := ( dbfAlqCliL )->lKitPrc
               ( dbfFacCliL )->lNotVta    := ( dbfAlqCliL )->lNotVta
               ( dbfFacCliL )->lImpLin    := ( dbfAlqCliL )->lImpLin
               ( dbfFacCliL )->nValImp    := ( dbfAlqCliL )->nValImp
               ( dbfFacCliL )->lIvaLin    := ( dbfAlqCliL )->lIvaLin
               ( dbfFacCliL )->nPreUnit   := ( dbfAlqCliL )->nPreUnit
               ( dbfFacCliL )->cImagen    := ( dbfAlqCliL )->cImagen
               ( dbfFacCliL )->cCodFam    := ( dbfAlqCliL )->cCodFam
               ( dbfFacCliL )->cGrpFam    := ( dbfAlqCliL )->cGrpFam

               ( dbfFacCliL )->cCodAlq    := oDbfTmp:cNumAlq
               ( dbfFacCliL )->dFecAlq    := oDbfTmp:dFecAlq
               ( dbfFacCliL )->dFecEnt    := ( dbfAlqCliL )->dFecEnt
               ( dbfFacCliL )->dFecSal    := ( dbfAlqCliL )->dFecSal

               ( dbfFacCliL )->lAlquiler  := .t.

               if lNotImp
                  ( dbfFacCliL )->lImpLin := lNotImp
               else
                  ( dbfFacCliL )->lImpLin := ( dbfAlqCliL )->lImpLin
               end if

               /*
               Esto es para el Sr. Perez no borrar aqui se aplican los descuentos
               de la ficha del cliente
               */

               if ( dbfCliAtp )->( dbSeek( ( dbfFacCliT )->cCodCli + ( dbfAlqCliL )->cRef ) )                  .and. ;
                  ( dbfCliAtp )->lAplFac                                                                       .and. ;
                  ( ( dbfCliAtp )->dFecIni <= ( dbfFacCliT )->dFecFac .or. Empty( ( dbfCliAtp )->dFecIni ) )   .and. ;
                  ( ( dbfCliAtp )->dFecFin >= ( dbfFacCliT )->dFecFac .or. Empty( ( dbfCliAtp )->dFecFin ) )

                  /*
                  if ( dbfCliAtp )->nPrcArt != 0
                     ( dbfFacCliL )->nPreUnit   := ( dbfCliAtp )->nPrcArt
                  end if
                  */

                  if ( dbfCliAtp )->nDtoArt != 0
                     ( dbfFacCliL )->nDto       := ( dbfCliAtp )->nDtoArt
                  end if

                  if ( dbfCliAtp )->nDprArt != 0
                     ( dbfFacCliL )->nDtoPrm    := ( dbfCliAtp )->nDprArt
                  end if

                  if ( dbfCliAtp )->nComAge != 0
                     ( dbfFacCliL )->nComAge    := ( dbfCliAtp )->nComAge
                  end if

                  if ( dbfCliAtp )->nDtoDiv != 0
                     ( dbfFacCliL )->nDtoDiv    := ( dbfCliAtp )->nDtoDiv
                  end if

               end if

               ( dbfAlqCliL )->( dbSkip( 1 ) )

            end do

            if lTotAlq .or. lTotAlqCli
               ( dbfFacCliL )->( dbAppend() )
               ( dbfFacCliL )->nNumLin    := ++nNumLin
               ( dbfFacCliL )->cSerie     := cSerAlq
               ( dbfFacCliL )->nNumFac    := nNewFac
               ( dbfFacCliL )->cSufFac    := cSufEmp
               ( dbfFacCliL )->mLngDes    := "Total alquiler..."
               ( dbfFacCliL )->lTotLin    := .t.
            end if

         end if

         /*
         Pasamos los pagos-----------------------------------------------------
         */

         if ( dbfAlqCliP )->( dbSeek( oDbfTmp:cNumAlq ) )

            while ( dbfAlqCliP )->cSerAlq + Str( ( dbfAlqCliP )->nNumAlq ) + ( dbfAlqCliP )->cSufAlq == oDbfTmp:cNumAlq .and. !( dbfAlqCliP )->( Eof() )

               ( dbfFacCliP )->( dbAppend() )

               ( dbfFacCliP )->cSerie   := cSerAlq
               ( dbfFacCliP )->nNumFac  := nNewFac
               ( dbfFacCliP )->cSufFac  := cSufEmp
               ( dbfFacCliP )->nNumRec  := ++nNumRec
               ( dbfFacCliP )->cCodCaj  := ( dbfAlqCliP )->cCodCaj
               ( dbfFacCliP )->cTurRec  := ( dbfAlqCliP )->cTurRec
               ( dbfFacCliP )->cCodCli  := ( dbfAlqCliP )->cCodCli
               ( dbfFacCliP )->dEntrada := ( dbfAlqCliP )->dEntrega
               ( dbfFacCliP )->dPreCob  := ( dbfAlqCliP )->dEntrega
               ( dbfFacCliP )->dFecVto  := ( dbfAlqCliP )->dEntrega
               ( dbfFacCliP )->nImporte := ( dbfAlqCliP )->nImporte
               ( dbfFacCliP )->nImpCob  := ( dbfAlqCliP )->nImporte
               if !Empty( ( dbfAlqCliP )->cDescrip )
               ( dbfFacCliP )->cDescrip := ( dbfAlqCliP )->cDescrip
               else
               ( dbfFacCliP )->cDescrip := "Entrega nº " + AllTrim( Str( nNumRec ) ) + " alquiler " + ( dbfAlqCliP )->cSerAlq + "/" + AllTrim( Str( ( dbfAlqCliP )->nNumAlq ) ) + "/" + ( dbfAlqCliP )->cSufAlq
               end if
               ( dbfFacCliP )->cPgdoPor := ( dbfAlqCliP )->cPgdoPor
               ( dbfFacCliP )->cDocPgo  := ( dbfAlqCliP )->cDocPgo
               ( dbfFacCliP )->cDivPgo  := ( dbfAlqCliP )->cDivPgo
               ( dbfFacCliP )->nVdvPgo  := ( dbfAlqCliP )->nVdvPgo
               ( dbfFacCliP )->cCodAge  := ( dbfAlqCliP )->cCodAge
               ( dbfFacCliP )->lCobrado := .t.
               ( dbfFacCliP )->lConPgo  := .f.
               ( dbfFacCliP )->lRecImp  := .f.
               ( dbfFacCliP )->lRecDto  := .f.

               ( dbfAlqCliP )->( dbSkip() )

            end while

         end if

         ( dbfAlqCliP )->( dbGoTop() )

      end if

      oDbfTmp:Skip()

      /*
      Damos valor al meter-----------------------------------------------------
      */

      oMetMsg:Set( oDbfTmp:OrdKeyNo() )

      /*
      Si el proceso ha sido iniciado o sea un alquiler valido encontrado entonces preguntamos si
      es el ultimo item con lo cual hay q cerrar o bien hacemos prelectura del siguiente alquiler
      y si cambian las condiciones tambien tenemos q cerrar
      */

      if nProcesando != 0 .and. ( nProcesando != oDbfTmp:nNumDoc .or. oDbfTmp:Eof() )

         /*
         Generamos los pagos______________________________________________________
         */

         GenPgoFacCli( cSerAlq + Str( nNewFac ) + cSufEmp, dbfFacCliT, dbfFacCliL, dbfFacCliP, dbfAntCliT, dbfClient, dbfFPago, dbfDiv, dbfIva )

         ChkLqdFacCli( nil, dbfFacCliT, dbfFacCliL, dbfFacCliP, dbfAntCliT, dbfIva, dbfDiv, .f. )

      end if

   end do

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos de agentes" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( dbfFacCliT )
   CLOSE ( dbfFacCliL )
   CLOSE ( dbfFacCliP )
   CLOSE ( dbfAntCliT )

   ( dbfAlqCliT )->( OrdSetFocus( nOrd ) )
   ( dbfAlqCliT )->( dbGoTo( nRec ) )

   oDlg:Enable()

   if Empty( aMsg )
      MsgStop( "No se generaron facturas." )
   else
      Visor( aMsg )
   end if

RETURN NIL

//---------------------------------------------------------------------------//

Function cNumAlq()

Return ( "Alquiler : " )

//---------------------------------------------------------------------------//

Function cSuAlq()

Return ( " de fecha " )

//---------------------------------------------------------------------------//

Function lNumAlq()

Return (.t.)

//---------------------------------------------------------------------------//

Function lSuAlq()

Return (.t.)

//---------------------------------------------------------------------------//