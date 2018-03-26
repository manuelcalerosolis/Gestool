#include "FiveWin.Ch"
#include "Folder.ch"
#include "Factu.ch" 
#include "Report.ch"
#include "Menu.ch"

static   nAcumulaAlbaran      := 0
static   nAcumulaDescuento1   := 0
static   nAcumulaDescuento2   := 0
static   nAcumulaDescuento3   := 0
static   nAcumulaDescuento4   := 0
static   cAnteriorAlbaran     := 0
static   nTotalAlbaranes      := 0
static   nTotalFacturas       := 0

//---------------------------------------------------------------------------//

Function GenFCli( oBrw, dbfAlbCliT, dbfAlbCliL, dbfAlbCliP, dbfAlbCliS, dbfClient, dbfCliAtp, dbfIva, dbfDiv, dbfFPago, dbfUsr, dbfCount, oGrpCli, oStock )

   local oDlg
   local oPag
   local oBmp
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
   local oBrwAlb
   local lAllCli           := .t.
   local lAllGrp           := .t.
   local oMetMsg
   local nMetMsg           := 0
   local lGrpCli           := .t.
   local nGrpObr           := 1
   local lTotAlb           := .f.
   local lUniPgo           := .f.
   local lNotImp           := .f.
   local lSoloEntregados   := .f.
   local oSerieFactura
   local cSerieFactura     := cNewSer( "nFacCli", dbfCount )
   local nTipoSerie        := 1

   local nRadFec           := 1
   local dFecFac           := GetSysDate()
   local dDesAlb           := ctoD( "01/" + Str( Month( GetSysDate() ), 2 ) + "/" + Str( Year( GetSysDate() ) ) )
   local dHasAlb           := GetSysDate()
   local oSer              := Array( 26 )
   local aSer              := { .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t. }
   local oDbfTmp
   local nRec              := ( dbfAlbCliT )->( Recno() )
   local nOrd              := ( dbfAlbCliT )->( OrdSetFocus( "nNumAlb" ) )

   nTotalAlbaranes         := 0
   nTotalFacturas          := 0

   if File( cPatTmp() + "GenFac.Dbf" ) .and. fErase( cPatTmp() + "GenFac.Dbf" ) == -1
      MsgStop( "Esta opción esta en uso por otro usuario" )
      Return nil
   end if

   oDbfTmp              := dbfServer( "GenFac", SubStr( Str( Seconds() ), -6 ) ):New( "GenFac", "GenFac", cLocalDriver(), , cEmpTmp() )
   oDbfTmp:AddField( "lFacAlb", "L", 1, 0 )
   oDbfTmp:AddField( "cSerDoc", "C", 1, 0 )
   oDbfTmp:AddField( "nNumDoc", "N", 9, 0 )
   oDbfTmp:AddField( "lNewDoc", "L", 1, 0 )
   oDbfTmp:AddField( "cNumAlb", "C",12, 0 )
   oDbfTmp:AddField( "dFecAlb", "D", 8, 0 )
   oDbfTmp:AddField( "cCodCli", "C",12, 0 )
   oDbfTmp:AddField( "cNomCli", "C",50, 0 )
   oDbfTmp:AddField( "cCodObr", "C",10, 0 )
   oDbfTmp:AddField( "lIvaInc", "L", 1, 0 )
   oDbfTmp:AddField( "lRecargo","L", 1, 0 )
   oDbfTmp:AddField( "lOperPv", "L", 1, 0 )
   oDbfTmp:AddField( "cCodPgo", "C", 2, 0 )
   oDbfTmp:AddField( "nTotAlb", "N",19, 6 )
   oDbfTmp:AddField( "nTotEnt", "N",19, 6 )
   oDbfTmp:AddField( "nPctDto1","N",19, 6 )
   oDbfTmp:AddField( "nPctDto2","N",19, 6 )
   oDbfTmp:AddField( "nPctDto3","N",19, 6 )
   oDbfTmp:AddField( "nPctDto4","N",19, 6 )
   oDbfTmp:Activate( .f., .f. )

   oDbfTmp:AddTmpIndex( "cCodObr", "GenFac", "cSerDoc + cCodCli + if( lIvaInc, '0', '1' ) + if( lRecargo, '0', '1' ) + cCodObr" )
   oDbfTmp:AddTmpIndex( "cCodPgo", "GenFac", "cSerDoc + cCodCli + cCodPgo + if( lIvaInc, '0', '1' ) + if( lRecargo, '0', '1' ) + cCodObr" )
   oDbfTmp:AddTmpIndex( "nNumDoc", "GenFac", "cSerDoc + Str( nNumDoc ) + if( lNewDoc, '0', '1' )" )
   oDbfTmp:AddTmpIndex( "cNumAlb", "GenFac", "cNumAlb" )

	/*
	Obtenemos los valores del primer y ultimo codigo
	*/

   if dbfAlbCliT != nil
      cCliDes     := ( dbfAlbCliT )->cCodCli
      cCliHas     := ( dbfAlbCliT )->cCodCli
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

   REDEFINE BITMAP oBmp ;
      ID       600 ;
      RESOURCE "gc_document_text_gear_48" ;
      TRANSPARENT ;
      OF       oDlg

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

   REDEFINE GET dDesAlb;
      SPINNER ;
      ID       130 ;
      OF       oPag:aDialogs[ 1 ]

   REDEFINE GET dHasAlb;
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

   REDEFINE CHECKBOX lSoloEntregados;
      ID       188 ;
      OF       oPag:aDialogs[ 1 ]

   REDEFINE CHECKBOX lTotAlb;
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

   REDEFINE RADIO nTipoSerie ;
      ID       201, 202 ;
      OF       oPag:aDialogs[ 1 ]

   REDEFINE GET oSerieFactura VAR cSerieFactura;
      ID       200 ;
      PICTURE  "@!" ;
      UPDATE ;
      SPINNER ;
      ON UP    ( UpSerie( oSerieFactura ) );
      ON DOWN  ( DwSerie( oSerieFactura ) );
      VALID    ( cSerieFactura >= "A" .and. cSerieFactura <= "Z"  );
      OF       oPag:aDialogs[ 1 ]      

      oSerieFactura:bWhen := {|| ( nTipoSerie == 2 ) }

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

   oBrwAlb                 := IXBrowse():New( oPag:aDialogs[2] )

   oBrwAlb:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrwAlb:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   oBrwAlb:nMarqueeStyle   := 5
   oBrwAlb:cName           := "Linea de generar factura cliente detalle"

   oBrwAlb:CreateFromResource( 180 )

   oDbfTmp:SetBrowse( oBrwAlb )

   with object ( oBrwAlb:AddCol() )
      :cHeader             := "Se.Seleccionado"
      :bStrData            := {|| "" }
      :bEditValue          := {|| !oDbfTmp:lFacAlb }
      :nWidth              := 20
      :SetCheck( { "Sel16", "Nil16" } )
   end with

   with object ( oBrwAlb:AddCol() )
      :cHeader             := ""
      :bStrData            := {|| "" }
      :bEditValue          := {|| oDbfTmp:lNewDoc }
      :nWidth              := 20
      :SetCheck( { "Sel16", "Nil16" } )
   end with

   with object ( oBrwAlb:AddCol() )
      :cHeader             := "Num. Alb."
      :bEditValue          := {|| oDbfTmp:cNumAlb }
      :cEditPicture        := "@R #/#########/##"
      :nWidth              := 80
   end with

   with object ( oBrwAlb:AddCol() )
      :cHeader             := "Fecha"
      :bEditValue          := {|| dtoc( oDbfTmp:dFecAlb ) }
      :nWidth              := 75
   end with

   with object ( oBrwAlb:AddCol() )
      :cHeader             := "Cliente"
      :bEditValue          := {|| Rtrim( oDbfTmp:cCodCli ) + Space(1) + AllTrim( oDbfTmp:cNomCli ) }
      :nWidth              := 150
   end with

   with object ( oBrwAlb:AddCol() )
      :cHeader             := cImp()
      :bEditValue          := {|| if( oDbfTmp:lIvaInc, "Inc.", "Des." ) }
      :nWidth              := 35
   end with

   with object ( oBrwAlb:AddCol() )
      :cHeader             := "Dirección"
      :bEditValue          := {|| oDbfTmp:cCodObr }
      :nWidth              := 35
   end with

   with object ( oBrwAlb:AddCol() )
      :cHeader             := "F.Pago"
      :bEditValue          := {|| oDbfTmp:cCodPgo }
      :nWidth              := 40
   end with

   with object ( oBrwAlb:AddCol() )
      :cHeader             := "Importe"
      :bEditValue          := {|| oDbfTmp:nTotAlb }
      :cEditPicture        := PicOut()
      :nWidth              := 80
      :nDataStrAlign       := 1
      :nHeadStrAlign       := 1
   end with

   with object ( oBrwAlb:AddCol() )
      :cHeader             := "Entregado"
      :bEditValue          := {|| oDbfTmp:nTotEnt }
      :cEditPicture        := PicOut()
      :nWidth              := 80
      :nDataStrAlign       := 1
      :nHeadStrAlign       := 1
   end with

   REDEFINE BUTTON ;
      ID       514;
      OF       oPag:aDialogs[ 2 ] ;
      ACTION   ( oDbfTmp:Load(), oDbfTmp:lFacAlb := !oDbfTmp:lFacAlb, oDbfTmp:Save(), oBrwAlb:refresh() )

   REDEFINE BUTTON ;
      ID       516;
      OF       oPag:aDialogs[ 2 ] ;
      ACTION   ( oDbfTmp:GetStatus(), oDbfTmp:DbEval( {|| oDbfTmp:Load(), oDbfTmp:lFacAlb := .f., oDbfTmp:Save() } ), oDbfTmp:SetStatus(), oBrwAlb:refresh() )

   REDEFINE BUTTON ;
      ID       517;
      OF       oPag:aDialogs[ 2 ] ;
      ACTION   ( oDbfTmp:GetStatus(), oDbfTmp:DbEval( {|| oDbfTmp:Load(), oDbfTmp:lFacAlb := .t., oDbfTmp:Save() } ), oDbfTmp:SetStatus(), oBrwAlb:refresh() )

   oMetMsg  := TApoloMeter():ReDefine( 120, { | u | if( pCount() == 0, nMetMsg, nMetMsg := u ) }, 10, oDlg, .f., , , .t., rgb( 255,255,255 ), , rgb( 128,255,0 ) )

   REDEFINE BUTTON oBtnPrv ;
      ID       500;
		OF 		oDlg ;
      ACTION   ( GoPrev( oPag, oBtnPrv, oBtnNxt ) )

   REDEFINE BUTTON oBtnNxt ;
      ID       501;
		OF 		oDlg ;
      ACTION   ( GoNext(   cCliDes, cCliHas, cGrpDes, cGrpHas, dDesAlb, lAllGrp, lAllCli, dHasAlb,;
                           nRadFec, dFecFac, aSer, oDbfTmp, oBrwAlb, oDlg, oPag, lGrpCli, nGrpObr,;
                           lTotAlb, lUniPgo, lNotImp, oBtnPrv, oBtnNxt, oMetMsg, dbfAlbCliT, dbfAlbCliL, dbfAlbCliS, dbfAlbCliP,;
                           dbfClient, dbfCliAtp, dbfIva, dbfDiv, dbfUsr, dbfFPago, dbfCount, oStock, nTipoSerie, cSerieFactura, lSoloEntregados ) )

   REDEFINE BUTTON ;
      ID       IDCANCEL ;
		OF 		oDlg ;
      CANCEL ;
      ACTION   ( oDlg:End() )

      oDlg:bStart := {|| oCliDes:lValid(), oCliHas:lValid(), oGrpDes:lValid(), oGrpHas:lValid() }

   ACTIVATE DIALOG oDlg CENTER ON INIT ( oBtnPrv:Hide(), oBrwAlb:Load() )

   /*
   Reposicionamiento-----------------------------------------------------------
   */

   ( dbfAlbCliT )->( OrdSetFocus( nOrd ) )
   ( dbfAlbCliT )->( dbGoTo( nRec ) )

   /*
   Desbloqueo de todas los registros-------------------------------------------
   */

   Desbloqueo( oDbfTmp, dbfAlbCliT )

   /*
   Fin de tarea----------------------------------------------------------------
   */

   oDbfTmp:End()

   fErase( cPatTmp() + "GenFac.Dbf" )
   fErase( cPatTmp() + "GenFac.Cdx" )

   oBrw:Refresh()

   /*
    Guardamos los datos del browse---------------------------------------------
   */

   oBrwAlb:CloseData()

   /*
   Liberamos la imagen---------------------------------------------------------
   */

   oBmp:End()

RETURN NIL

//---------------------------------------------------------------------------//

Static Function Desbloqueo( oDbfTmp, dbfAlbCliT )

   local nRec
   local nOrd
   local oBlock

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   nRec              := ( dbfAlbCliT )->( Recno() )
   nOrd              := ( dbfAlbCliT )->( OrdSetFocus() )

   /*
   Desbloqueo------------------------------------------------------------------
   */

   oDbfTmp:GoTop()
   while !oDbfTmp:Eof()
      if ( dbfAlbCliT )->( dbSeek( oDbfTmp:cNumAlb ) )
         ( dbfAlbCliT )->( dbRUnLock( ( dbfAlbCliT )->( Recno() ) ) )
      end if
      oDbfTmp:Skip()
   end while
   oDbfTmp:GoTop()

   ( dbfAlbCliT )->( OrdSetFocus( nOrd ) )
   ( dbfAlbCliT )->( dbGoTo( nRec ) )

   END SEQUENCE

   ErrorBlock( oBlock )

return nil

//---------------------------------------------------------------------------//

Static Function GetFormaDePago( cCodCli, cCodPgo, oDbfTmp )

   local lFormaPago  := .f.
   local cFormaPago  := oDbfTmp:cCodPgo

   oDbfTmp:GetStatus()
   oDbfTmp:GoTop()

   while !oDbfTmp:Eof()

      if oDbfTmp:cCodCli == cCodCli .and. !oDbfTmp:lFacAlb .and. cFormaPago != oDbfTmp:cCodPgo
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

static function GoNext( cCliDes, cCliHas, cGrpDes, cGrpHas, dDesAlb, lAllGrp, lAllCli, dHasAlb,;
                        nRadFec, dFecFac, aSer, oDbfTmp, oBrwAlb, oDlg, oPag, lGrpCli, nGrpObr,;
                        lTotAlb, lUniPgo, lNotImp, oBtnPrv, oBtnNxt, oMetMsg, dbfAlbCliT, dbfAlbCliL, dbfAlbCliS, dbfAlbCliP,;
                        dbfClient, dbfCliAtp, dbfIva, dbfDiv, dbfUsr, dbfFPago, dbfCount, oStock, nTipoSerie, cSerieFactura, lSoloEntregados )

   do case
   case oPag:nOption == 1

      LoaAlbFac(  cCliDes, cCliHas, cGrpDes, cGrpHas, dDesAlb, lAllGrp, lAllCli, dHasAlb, lGrpCli, nGrpObr,;
                  lTotAlb, lUniPgo, lNotImp, aSer, oDbfTmp, oBrwAlb, oDlg, oMetMsg, dbfAlbCliT, dbfAlbCliL,;
                  dbfAlbCliS, dbfClient, dbfCliAtp, dbfIva, dbfDiv, dbfFPago, dbfAlbCliP, lSoloEntregados )

      oBtnPrv:Show()
   
      SetWindowText( oBtnNxt:hWnd, "&Terminar" )
   
      oPag:GoNext()

   case oPag:nOption == 2

      MakFacCli(  oDbfTmp, dFecFac, lGrpCli, nGrpObr, lTotAlb, lUniPgo, lNotImp, nRadFec, oBrwAlb, oMetMsg,;
                  dbfAlbCliT, dbfAlbCliL, dbfAlbCliP, dbfAlbCliS, dbfClient, dbfCliAtp, dbfIva, dbfDiv,;
                  dbfFPago, dbfUsr, dbfCount, oStock, oDlg, nTipoSerie, cSerieFactura )

      oDlg:End()

   end case

return nil

//---------------------------------------------------------------------------//

STATIC FUNCTION loaAlbFac( cCliDes, cCliHas, cGrpDes, cGrpHas, dDesAlb, lAllGrp, lAllCli, dHasAlb, lGrpCli, nGrpObr,;
                           lTotAlb, lUniPgo, lNotImp, aSer, oDbfTmp, oBrwAlb, oDlg, oMetMsg, dbfAlbCliT, dbfAlbCliL,;
                           dbfAlbCliS, dbfClient, dbfCliAtp, dbfIva, dbfDiv, dbfFPago, dbfAlbCliP, lSoloEntregados )

   local lNuevo   := .t.
   local nOrdAnt
   local cIvaInc
   local cRecargo
   local nNumero  := 0
   local nRecAnt  := ( dbfAlbCliT )->( RecNo() )
   local cExpHead
   local cCodPgo
   local cLastRec

   if lGrpCli

      if nGrpObr == 1
         nOrdAnt  := ( dbfAlbCliT )->( ordSetFocus( "cCodCli" ) )
      else
         nOrdAnt  := ( dbfAlbCliT )->( ordSetFocus( "cCodObr" ) )
      end if

      if lUniPgo
         oDbfTmp:OrdSetFocus( "cCodObr" )
      else
         oDbfTmp:OrdSetFocus( "cCodPgo" )
      end if

   else

      nOrdAnt     := ( dbfAlbCliT )->( ordSetFocus( "nNumAlb" ) )

      oDbfTmp:OrdSetFocus( "cNumAlb" )

   end if

   oDlg:Disable()

   CursorWait()

   /*
   Tablas temporales inicializadas---------------------------------------------
   */

   Desbloqueo( oDbfTmp, dbfAlbCliT )

   oDbfTmp:Zap()

   /*
   Selección de registros------------------------------------------------------
	*/

   // Creamos los indices para que esto vaya mucho mas rápido y informamos el meter

   cExpHead       := '!Field->lFacturado'

   if lSoloEntregados
      cExpHead    += ' .and. Field->lEntregado'
   end if

   if !lAllGrp
      cExpHead    += ' .and. Field->cCodGrp >= "' + Rtrim( cGrpDes ) + '" .and. Field->cCodGrp <= "' + Rtrim( cGrpHas ) + '"'
   end if
   if !lAllCli
      cExpHead    += ' .and. Field->cCodCli >= "' + Rtrim( cCliDes ) + '" .and. Field->cCodCli <= "' + Rtrim( cCliHas ) + '"'
   end if
   cExpHead       += ' .and. Field->dFecAlb >= Ctod( "' + Dtoc( dDesAlb ) + '" ) .and. Field->dFecAlb <= Ctod( "' + Dtoc( dHasAlb ) + '" )'
   cExpHead       += ' .and. !Deleted()'

   // Texto y creacion de filtros----------------------------------------------

   oMetMsg:cText  := "Creando filtros..."
   oMetMsg:Refresh()

   if CreateFastFilter( cExpHead, dbfAlbCliT, .f. )

      /*
      Guardamos el último registro para los calculos de descuentos-------------
      */

      cLastRec    := dbLast( dbfAlbCliT, "cSerAlb" )
      cLastRec    += Str( dbLast( dbfAlbCliT, "nNumAlb" ) )
      cLastRec    += dbLast( dbfAlbCliT, "cSufAlb" )

      // fin de creacion del indice rapido-------------------------------------

      oMetMsg:SetTotal( ( dbfAlbCliT )->( OrdKeyCount() ) )

      ( dbfAlbCliT )->( dbGoTop() )
      while !( dbfAlbCliT )->( eof() )

         if lChkSer( ( dbfAlbCliT )->cSerAlb, aSer )

            lNuevo            := .f.

            if lGrpCli

               cIvaInc        := if( ( dbfAlbCliT )->lIvaInc,  '0', '1' )
               cRecargo       := if( ( dbfAlbCliT )->lRecargo, '0', '1' )

               /*
               Para unificar formas de pagos todas nos valen----------------------
               */

               if lUniPgo
                  cCodPgo     := ""
               else
                  cCodPgo     := ( dbfAlbCliT )->cCodPago
               end if

               do case
               case nGrpObr == 1 .or. nGrpObr == 2

                  if oDbfTmp:Seek( ( dbfAlbCliT )->cSerAlb + ( dbfAlbCliT )->cCodCli + cCodPgo + cIvaInc + cRecargo )

                     AgregaAlbaran( oDbfTmp:nNumDoc, .f., oDbfTmp, dbfAlbCliT, dbfAlbCliL, dbfAlbCliP, dbfIva, dbfDiv, ( ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb == cLastRec ) )

                  else

                     AgregaAlbaran( ++nNumero, .t., oDbfTmp, dbfAlbCliT, dbfAlbCliL, dbfAlbCliP, dbfIva, dbfDiv, ( ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb == cLastRec ) )

                  end if

               case nGrpObr == 3

                  if oDbfTmp:Seek( ( dbfAlbCliT )->cSerAlb + ( dbfAlbCliT )->cCodCli + cCodPgo + cIvaInc + cRecargo + ( dbfAlbCliT )->cCodObr )

                     AgregaAlbaran( oDbfTmp:nNumDoc, .f., oDbfTmp, dbfAlbCliT, dbfAlbCliL, dbfAlbCliP, dbfIva, dbfDiv, ( ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb == cLastRec ) )

                  else

                     AgregaAlbaran( ++nNumero, .t., oDbfTmp, dbfAlbCliT, dbfAlbCliL, dbfAlbCliP, dbfIva, dbfDiv, ( ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb == cLastRec ) )

                  end if

               end case

            else

               AgregaAlbaran( ++nNumero, .t., oDbfTmp, dbfAlbCliT, dbfAlbCliL, dbfAlbCliP, dbfIva, dbfDiv, ( ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb == cLastRec ) )

            end if

         end if

         ( dbfAlbCliT )->( dbSkip() )

         oMetMsg:Set( ( dbfAlbCliT )->( OrdKeyNo() ) )

         SysRefresh()

      end do

      oMetMsg:Set( ( dbfAlbCliT )->( OrdKeyCount() ) )

      /*
      Borramos el filtro----------------------------------------------------------
      */

      DestroyFastFilter( dbfAlbCliT )

   end if

   ( dbfAlbCliT )->( OrdSetFocus( nOrdAnt ) )
   ( dbfAlbCliT )->( dbGoTo( nRecAnt ) )

   /*
   Nos vamos al primer registro------------------------------------------------
   */

   oDbfTmp:OrdSetFocus( "nNumDoc" )
   oDbfTmp:GoTop()

	/*
   Puede que no hay albaranes que facturar-------------------------------------
	*/

   oBrwAlb:Refresh()

   /*
   Ponemos enable--------------------------------------------------------------
	*/

   oDlg:Enable()

   CursorWE()

RETURN NIL

//---------------------------------------------------------------------------//

Static Function AgregaAlbaran( nNumero, lNuevo, oDbfTmp, dbfAlbCliT, dbfAlbCliL, dbfAlbCliP, dbfIva, dbfDiv, lUltimo )

   local nRecAnt
   local aTotAlb        := {}

   DEFAULT lUltimo      := .f.

   if ( dbfAlbCliT )->( dbRLock( ( dbfAlbCliT )->( Recno() ) ) )

      aTotAlb           := aTotAlbCli( ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT)->nNumAlb ) + ( dbfAlbCliT )->cSufAlb, dbfAlbCliT, dbfAlbCliL, dbfIva, dbfDiv )

      nTotalAlbaranes   += aTotAlb[4]

      if lNuevo

         if !Empty( cAnteriorAlbaran ) .and. cAnteriorAlbaran != ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb

            nRecAnt     := oDbfTmp:Recno()

            if oDbfTmp:SeekInOrd( cAnteriorAlbaran, "cNumAlb" )

               oDbfTmp:Load()

               if nAcumulaDescuento1 != 0
                  oDbfTmp:nPctDto1  := ( nAcumulaDescuento1 * 100 ) / nAcumulaAlbaran
               end if

               if nAcumulaDescuento2 != 0
                  oDbfTmp:nPctDto2  := ( nAcumulaDescuento2 * 100 ) / ( nAcumulaAlbaran - nAcumulaDescuento1 )
               end if

               if nAcumulaDescuento3 != 0
                  oDbfTmp:nPctDto3  := ( nAcumulaDescuento3 * 100 ) / ( nAcumulaAlbaran - nAcumulaDescuento1 - nAcumulaDescuento2 )
               end if

               if nAcumulaDescuento4 != 0
                  oDbfTmp:nPctDto4  := ( nAcumulaDescuento4 * 100 ) / ( nAcumulaAlbaran - nAcumulaDescuento1 - nAcumulaDescuento2 - nAcumulaDescuento3 )
               end if

               oDbfTmp:Save()

            end if

            oDbfTmp:GoTo( nRecAnt )

         end if

         cAnteriorAlbaran        := ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb
         nAcumulaAlbaran         := aTotAlb[ 16 ]
         nAcumulaDescuento1      := aTotAlb[ 12 ]
         nAcumulaDescuento2      := aTotAlb[ 13 ]
         nAcumulaDescuento3      := aTotAlb[ 14 ]
         nAcumulaDescuento4      := aTotAlb[ 15 ]

      else

         nAcumulaAlbaran         += aTotAlb[ 16 ]
         nAcumulaDescuento1      += aTotAlb[ 12 ]
         nAcumulaDescuento2      += aTotAlb[ 13 ]
         nAcumulaDescuento3      += aTotAlb[ 14 ]
         nAcumulaDescuento4      += aTotAlb[ 15 ]

      end if

      oDbfTmp:Append()
      oDbfTmp:Blank()

      oDbfTmp:nNumDoc            := nNumero
      oDbfTmp:lNewDoc            := lNuevo
      oDbfTmp:cSerDoc            := ( dbfAlbCliT )->cSerAlb
      oDbfTmp:lFacAlb            := ( dbfAlbCliT )->lFacturado
      oDbfTmp:cNumAlb            := ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb
      oDbfTmp:dFecAlb            := ( dbfAlbCliT )->dFecAlb
      oDbfTmp:cCodCli            := ( dbfAlbCliT )->cCodCli
      oDbfTmp:cNomCli            := ( dbfAlbCliT )->cNomCli
      oDbfTmp:cCodObr            := ( dbfAlbCliT )->cCodObr
      oDbfTmp:lIvaInc            := ( dbfAlbCliT )->lIvaInc
      oDbfTmp:lRecargo           := ( dbfAlbCliT )->lRecargo
      oDbfTmp:lOperPv            := ( dbfAlbCliT )->lOperPv
      oDbfTmp:cCodPgo            := ( dbfAlbCliT )->cCodPago
      oDbfTmp:nTotAlb            := nTotAlbCli( ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT)->nNumAlb ) + ( dbfAlbCliT )->cSufAlb, dbfAlbCliT, dbfAlbCliL, dbfIva, dbfDiv, nil, cDivEmp(), .f. )
      oDbfTmp:nTotEnt            := nPagAlbCli( ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb, dbfAlbCliP, dbfDiv, cDivEmp(), .f. )

      if lUltimo

         if nAcumulaDescuento1 != 0
            oDbfTmp:nPctDto1     := ( nAcumulaDescuento1 * 100 ) / nAcumulaAlbaran
         end if

         if nAcumulaDescuento2 != 0
            oDbfTmp:nPctDto2     := ( nAcumulaDescuento2 * 100 ) / ( nAcumulaAlbaran - nAcumulaDescuento1 )
         end if

         if nAcumulaDescuento3 != 0
            oDbfTmp:nPctDto3     := ( nAcumulaDescuento3 * 100 ) / ( nAcumulaAlbaran - nAcumulaDescuento1 - nAcumulaDescuento2 )
         end if

         if nAcumulaDescuento4 != 0
            oDbfTmp:nPctDto4     := ( nAcumulaDescuento4 * 100 ) / ( nAcumulaAlbaran - nAcumulaDescuento1 - nAcumulaDescuento2 - nAcumulaDescuento3 )
         end if

      end if

      oDbfTmp:Save()

   end if

   ( dbfAlbCliT )->( dbRUnLock() )

Return nil

//---------------------------------------------------------------------------//

Static Function MakFacCli( oDbfTmp, dFecFac, lGrpCli, nGrpObr, lTotAlb, lUniPgo, lNotImp, nRadFec, oBrw, oMetMsg,;
                           dbfAlbCliT, dbfAlbCliL, dbfAlbCliP, dbfAlbCliS, dbfClient, dbfCliAtp, dbfIva, dbfDiv,;
                           dbfFPago, dbfUsr, dbfCount, oStock, oDlg, nTipoSerie, cSerieFactura )

   local oBlock
   local oError
   local nNumRec              := 0
   local dbfFacCliT
   local dbfFacCliL
   local dbfFacCliP
   local dbfFacCliS
   local dbfAntCliT
   local dbfObrasT
   local aProcesado           := {}
   local nProcesando          := 0
   local cLinObr              := Space( 1 )
   local cSerAlb
   local nNewFac              := 0
   local cSufEmp              := RetSufEmp()
   local lTotAlbCli           := .f.
   local nNumLin              := 0
   local cPath                := cPatEmp()
   local nRec                 := ( dbfAlbCliT )->( Recno() )
   local nOrd                 := ( dbfAlbCliT )->( OrdSetFocus( 1 ) )
   local aMsg                 := {}
   local cDesAlb
   local cCodPgo
   local cCodCli
   local cNomCli
   local cDivFac
   local nVdvFac
   local cCodAge
   local cCodCaj
   local nTotEntAlb           := 0
   local aTotFac
   local nRecAnt
   local cDesObr              := ""

   if oDbfTmp:LastRec() <= 0
      msgStop( "No hay albaranes para facturar" )
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

   USE ( cPath + "FACCLIS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "FACCLIS", @dbfFacCliS ) )
   SET ADSINDEX TO ( cPath + "FACCLIS.CDX" ) ADDITIVE

   USE ( cPath + "AntCliT.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "AntCliT", @dbfAntCliT ) )
   SET ADSINDEX TO ( cPath + "AntCliT.CDX" ) ADDITIVE

   USE ( cPatEmp() + "OBRAST.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OBRAST", @dbfObrasT ) )
   SET ADSINDEX TO ( cPatEmp() + "OBRAST.CDX" ) ADDITIVE

   /*
   Meter-----------------------------------------------------------------------
   */

   oMetMsg:SetTotal( oDbfTmp:LastRec() )

   oDbfTmp:GoTop()
   while !oDbfTmp:Eof()

      /*
      Posicionamiento en el albaran--------------------------------------------
      */

      if ( dbfAlbCliT )->( dbSeek( oDbfTmp:cNumAlb ) ) .and. !oDbfTmp:lFacAlb

         nProcesando                   := oDbfTmp:nNumDoc

         /*
         Encontrado uno valido-------------------------------------------------
         */

         if aScan( aProcesado, nProcesando ) == 0

            aAdd( aProcesado, nProcesando )

            /*
            Nueva factura______________________________________________________
            */

            if nTipoSerie <= 1
               cSerAlb                 := ( dbfAlbCliT )->cSerAlb
            else
               cSerAlb                 := cSerieFactura
            end if

            nNewFac                    := nNewDoc( cSerAlb, dbfFacCliT, "NFACCLI", , dbfCount )
            nNumLin                    := 0
            cLinObr                    := Space( 1 )
            cCodCaj                    := oUser():cCaja()

            ( dbfFacCliT )->( dbAppend() )
            ( dbfFacCliT )->cSerie     := cSerAlb
            ( dbfFacCliT )->nNumFac    := nNewFac
            ( dbfFacCliT )->cSufFac    := cSufEmp
            ( dbfFacCliT )->cCodCaj    := cCodCaj
            ( dbfFacCliT )->cTurFac    := cCurSesion()
            ( dbfFacCliT )->cCodUsr    := Auth():Codigo()
            ( dbfFacCliT )->dFecCre    := Date()
            ( dbfFacCliT )->cTimCre    := Time()
            ( dbfFacCliT )->lImpAlb    := .t.
            ( dbfFacCliT )->cCodDlg    := RetFld( Auth():Codigo(), dbfUsr, "cCodDlg" )
            ( dbfFacCliT )->cCodAlm    := ( dbfAlbCliT )->cCodAlm

            if nRadFec == 1
               ( dbfFacCliT )->dFecFac := dFecFac
            else
               ( dbfFacCliT )->dFecFac := ( dbfAlbCliT )->dFecAlb
               dFecFac                 := ( dbfAlbCliT )->dFecAlb
            end if

            // Si no estamos agrupando por clientes anotamos el numero del albaran en la factura

            if !lGrpCli
               ( dbfFacCliT )->cNumAlb    := ( dbfAlbCliT )->cSerAlb + Str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb
            end if

            // Asignando datos del cliente----------------------------------------

            cCodCli                       := ( dbfAlbCliT )->cCodCli
            cNomCli                       := ( dbfClient )->Titulo

            ( dbfFacCliT )->cCodCli       := cCodCli

            if ( dbfClient )->( dbSeek( cCodCli ) )
               ( dbfFacCliT )->cNomCli    := ( dbfClient )->Titulo
               ( dbfFacCliT )->cDirCli    := ( dbfClient )->Domicilio
               ( dbfFacCliT )->cPobCli    := ( dbfClient )->Poblacion
               ( dbfFacCliT )->cPrvCli    := ( dbfClient )->Provincia
               ( dbfFacCliT )->cPosCli    := ( dbfClient )->CodPostal
               ( dbfFacCliT )->cDniCli    := ( dbfClient )->Nif
               ( dbfFacCliT )->nTarifa    := Max( ( dbfClient )->nTarifa, 1 )
               lTotAlbCli                 := ( dbfClient )->lTotAlb
               cCodPgo                    := ( dbfClient )->CodPago
            end if

            // Recoje la forma de pago--------------------------------------------

            if lUniPgo
               ( dbfFacCliT )->cCodPago   := GetFormaDePago( cCodCli, cCodPgo, oDbfTmp )
               cCodPgo                    := GetFormaDePago( cCodCli, cCodPgo, oDbfTmp )
            else
               ( dbfFacCliT )->cCodPago   := oDbfTmp:cCodPgo
               cCodPgo                    := oDbfTmp:cCodPgo
            end if

            if Empty( ( dbfFacCliT )->nTarifa )
               ( dbfFacCliT )->nTarifa    := Max( ( dbfAlbCliT )->nTarifa, 1 )
            end if

            cCodAge                       := ( dbfAlbCliT )->cCodAge
            cDivFac                       := ( dbfAlbCliT )->cDivAlb
            nVdvFac                       := ( dbfAlbCliT )->nVdvAlb

            ( dbfFacCliT )->cCodAge       := ( dbfAlbCliT )->cCodAge
            ( dbfFacCliT )->cCodRut       := ( dbfAlbCliT )->cCodRut
            ( dbfFacCliT )->cCodTar       := ( dbfAlbCliT )->cCodTar
            //( dbfFacCliT )->cCodObr       := ( dbfAlbCliT )->cCodObr
            ( dbfFacCliT )->cDivFac       := ( dbfAlbCliT )->cDivAlb
            ( dbfFacCliT )->nVdvFac       := ( dbfAlbCliT )->nVdvAlb
            ( dbfFacCliT )->lRecargo      := ( dbfAlbCliT )->lRecargo
            ( dbfFacCliT )->lOperPv       := ( dbfAlbCliT )->lOperPv
            ( dbfFacCliT )->mComent       := ( dbfAlbCliT )->mComent
            ( dbfFacCliT )->mObserv       := ( dbfAlbCliT )->mObserv
            ( dbfFacCliT )->cCodTrn       := ( dbfAlbCliT )->cCodTrn
            ( dbfFacCliT )->cCodPro       := cProCnt( ( dbfAlbCliT )->cSerAlb )
            ( dbfFacCliT )->lIvaInc       := ( dbfAlbCliT )->lIvaInc
            ( dbfFacCliT )->lSndDoc       := .t.

            // Informamos de la factura que de ha generado------------------------

            aAdd( aMsg, {.t., "Factura generada : " + ( dbfFacCliT )->cSerie + "/" + Alltrim( Str( ( dbfFacCliT )->nNumFac ) ) + "/" + ( dbfFacCliT )->cSufFac } )

         end if

         // Descuentos globales------------------------------------------------

         if !empty( oDbfTmp:nPctDto1 ) .and. empty( ( dbfFacCliT )->cDtoEsp )
            ( dbfFacCliT )->cDtoEsp := Padr( "General", 50 )
            ( dbfFacCliT )->nDtoEsp := oDbfTmp:nPctDto1
         end if 

         if !empty( oDbfTmp:nPctDto2 ) .and. empty( ( dbfFacCliT )->cDpp )
            ( dbfFacCliT )->cDpp    := Padr( "Pronto pago", 50 )
            ( dbfFacCliT )->nDpp    := oDbfTmp:nPctDto2
         end if 

         if !empty( oDbfTmp:nPctDto3 ) .and. empty( ( dbfFacCliT )->cDtoUno )
            ( dbfFacCliT )->cDtoUno := Space( 50 ) 
            ( dbfFacCliT )->nDtoUno := oDbfTmp:nPctDto3
         end if 

         if !empty( oDbfTmp:nPctDto4 ) .and. empty( ( dbfFacCliT )->cDtoDos )
            ( dbfFacCliT )->cDtoDos := Space(50)
            ( dbfFacCliT )->nDtoDos := oDbfTmp:nPctDto4
         end if 

         /*
         Marca para no volver a facturar el albaran____________________________
         */

         SetFacturadoAlbaranCliente( .t., , dbfAlbCliT, dbfAlbCliL, dbfAlbCliS, ( dbfFacCliT )->cSerie + Str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac )

         /*
         Posicinamiento en lineas de albaranes_________________________________
         */

         if ( dbfAlbCliL )->( dbSeek( oDbfTmp:cNumAlb ) )

            /*
            Obras
            */

            if lNumObr() .and. ( dbfAlbCliT )->cCodObr != cLinObr
               ( dbfFacCliL )->( dbAppend() )
               ( dbfFacCliL )->nNumLin    := ++nNumLin
               ( dbfFacCliL )->cSerie     := cSerAlb
               ( dbfFacCliL )->nNumFac    := nNewFac
               ( dbfFacCliL )->cSufFac    := cSufEmp
               cDesObr                    := Alltrim( cNumObr() ) + Space( 1 ) + ( dbfAlbCliT )->cCodObr +Space( 1 )
               cDesObr                    += AllTrim( RetFld( ( dbfAlbCliT )->cCodCli + ( dbfAlbCliT )->cCodObr, dbfObrasT, "cNomObr" ) )
               ( dbfFacCliL )->cDetalle   := cDesObr
               ( dbfFacCliL )->mLngDes    := cDesObr
               ( dbfFacCliL )->lControl   := .t.
               cLinObr                    := ( dbfAlbCliT )->cCodObr
            end if

            /*
            Albaranes----------------------------------------------------------
            */

            if lNumAlb() .or. lSuAlb()
               ( dbfFacCliL )->( dbAppend() )
               ( dbfFacCliL )->nNumLin    := ++nNumLin
               ( dbfFacCliL )->cSerie     := cSerAlb
               ( dbfFacCliL )->nNumFac    := nNewFac
               ( dbfFacCliL )->cSufFac    := cSufEmp
               cDesAlb                    := ""
               if lNumAlb()
                  cDesAlb                 += Alltrim( cNumAlb() ) + " " + Left( oDbfTmp:cNumAlb, 1 ) + "/" + AllTrim( SubStr( oDbfTmp:cNumAlb, 2, 9 ) ) + "/" + Right( oDbfTmp:cNumAlb, 2 ) + Space( 1 )
               end if
               if lSuAlb()
                  cDesAlb                 += Alltrim( cSuAlb() ) + " " + Rtrim( ( dbfAlbCliT )->cCodSuAlb ) + Space( 1 )
               end if
               cDesAlb                    += dtoc( oDbfTmp:dFecAlb )
               ( dbfFacCliL )->cDetalle   := cDesAlb
               ( dbfFacCliL )->lControl   := .t.
            end if

            /*
            Añadimos lineas de detalle-----------------------------------------
            */

            while ( ( dbfAlbCliL )->cSerAlb + Str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb == oDbfTmp:cNumAlb ) .AND. !( dbfAlbCliL )->( eof() )

               ( dbfFacCliL )->( dbAppend() )
               ( dbfFacCliL )->nNumLin    := ++nNumLin
               ( dbfFacCliL )->cSerie     := cSerAlb
               ( dbfFacCliL )->nNumFac    := nNewFac
               ( dbfFacCliL )->cSufFac    := cSufEmp
               ( dbfFacCliL )->cRef       := ( dbfAlbCliL )->cRef
               ( dbfFacCliL )->cDetalle   := ( dbfAlbCliL )->cDetalle
               ( dbfFacCliL )->mLngDes    := ( dbfAlbCliL )->mLngDes
               ( dbfFacCliL )->mNumSer    := ( dbfAlbCliL )->mNumSer
               ( dbfFacCliL )->nCanEnt    := ( dbfAlbCliL )->nCanEnt
               ( dbfFacCliL )->cUnidad    := ( dbfAlbCliL )->cUnidad
               ( dbfFacCliL )->nUniCaja   := ( dbfAlbCliL )->nUniCaja
               ( dbfFacCliL )->nUndKit    := ( dbfAlbCliL )->nUndKit
               ( dbfFacCliL )->nPesoKg    := ( dbfAlbCliL )->nPesoKg
               ( dbfFacCliL )->nIva       := ( dbfAlbCliL )->nIva
               ( dbfFacCliL )->nReq       := ( dbfAlbCliL )->nReq
               ( dbfFacCliL )->nDto       := ( dbfAlbCliL )->nDto
               ( dbfFacCliL )->nDtoDiv    := ( dbfAlbCliL )->nDtoDiv
               ( dbfFacCliL )->nPntVer    := ( dbfAlbCliL )->nPntVer
               ( dbfFacCliL )->nDtoPrm    := ( dbfAlbCliL )->nDtoPrm
               ( dbfFacCliL )->nComAge    := ( dbfAlbCliL )->nComAge
               ( dbfFacCliL )->dFecha     := ( dbfAlbCliL )->dFecha
               ( dbfFacCliL )->cTipMov    := ( dbfAlbCliL )->cTipMov
               ( dbfFacCliL )->cAlmLin    := ( dbfAlbCliL )->cAlmLin
               ( dbfFacCliL )->cCodPr1    := ( dbfAlbCliL )->cCodPr1
               ( dbfFacCliL )->cCodPr2    := ( dbfAlbCliL )->cCodPr2
               ( dbfFacCliL )->cValPr1    := ( dbfAlbCliL )->cValPr1
               ( dbfFacCliL )->cValPr2    := ( dbfAlbCliL )->cValPr2
               ( dbfFacCliL )->nCtlStk    := ( dbfAlbCliL )->nCtlStk
               ( dbfFacCliL )->nCosDiv    := ( dbfAlbCliL )->nCosDiv
               ( dbfFacCliL )->lControl   := ( dbfAlbCliL )->lControl
               ( dbfFacCliL )->lKitArt    := ( dbfAlbCliL )->lKitArt
               ( dbfFacCliL )->lKitChl    := ( dbfAlbCliL )->lKitChl
               ( dbfFacCliL )->lKitPrc    := ( dbfAlbCliL )->lKitPrc
               ( dbfFacCliL )->lNotVta    := ( dbfAlbCliL )->lNotVta
               ( dbfFacCliL )->lImpLin    := ( dbfAlbCliL )->lImpLin
               ( dbfFacCliL )->nValImp    := ( dbfAlbCliL )->nValImp
               ( dbfFacCliL )->lIvaLin    := ( dbfAlbCliL )->lIvaLin
               ( dbfFacCliL )->nPreUnit   := ( dbfAlbCliL )->nPreUnit
               ( dbfFacCliL )->cImagen    := ( dbfAlbCliL )->cImagen
               ( dbfFacCliL )->cCodFam    := ( dbfAlbCliL )->cCodFam
               ( dbfFacCliL )->cGrpFam    := ( dbfAlbCliL )->cGrpFam
               ( dbfFacCliL )->lLote      := ( dbfAlbCliL )->lLote
               ( dbfFacCliL )->nLote      := ( dbfAlbCliL )->nLote
               ( dbfFacCliL )->cLote      := ( dbfAlbCliL )->cLote
               ( dbfFacCliL )->dFecCad    := ( dbfAlbCliL )->dFecCad
               ( dbfFacCliL )->cNumPed    := ( dbfAlbCliL )->cNumPed
               ( dbfFacCliL )->nTarLin    := ( dbfAlbCliL )->nTarLin

               ( dbfFacCliL )->cCodAlb    := oDbfTmp:cNumAlb
               ( dbfFacCliL )->dFecAlb    := oDbfTmp:dFecAlb
               ( dbfFacCliL )->dFecFac    := oDbfTmp:dFecAlb

               if lNotImp
                  ( dbfFacCliL )->lImpLin := lNotImp
               else
                  ( dbfFacCliL )->lImpLin := ( dbfAlbCliL )->lImpLin
               end if

               // Metemos si tiene numeros de serie-------------------------------

               if ( dbfAlbCliS )->( dbSeek( oDbfTmp:cNumAlb + Str( ( dbfAlbCliL )->nNumLin ) ) )

                  while ( dbfAlbCliS )->cSerAlb + Str( ( dbfAlbCliS )->nNumAlb ) + ( dbfAlbCliS )->cSufAlb + Str( ( dbfAlbCliS )->nNumLin ) == oDbfTmp:cNumAlb + Str( ( dbfAlbCliL )->nNumLin ) .and. !( dbfAlbCliS )->( Eof() )

                     ( dbfFacCliS )->( dbAppend() )
                     ( dbfFacCliS )->cSerFac  := cSerAlb
                     ( dbfFacCliS )->nNumFac  := nNewFac
                     ( dbfFacCliS )->cSufFac  := cSufEmp
                     ( dbfFacCliS )->nNumLin  := nNumLin
                     ( dbfFacCliS )->cRef     := ( dbfAlbCliS )->cRef
                     ( dbfFacCliS )->cAlmLin  := ( dbfAlbCliS )->cAlmLin
                     ( dbfFacCliS )->cNumSer  := ( dbfAlbCliS )->cNumSer

                     ( dbfAlbCliS )->( dbSkip() )

                  end while

               end if

               /*
               Esto es para el Sr. Perez no borrar aqui se aplican los descuentos
               de la ficha del cliente
               */

               if ( "GARRIDO" $ appParamsMain() )

                  if ( dbfCliAtp )->( dbSeek( ( dbfFacCliT )->cCodCli + ( dbfAlbCliL )->cRef ) )                  .and. ;
                     ( dbfCliAtp )->lAplFac                                                                       .and. ;
                     ( ( dbfCliAtp )->dFecIni <= ( dbfFacCliT )->dFecFac .or. Empty( ( dbfCliAtp )->dFecIni ) )   .and. ;
                     ( ( dbfCliAtp )->dFecFin >= ( dbfFacCliT )->dFecFac .or. Empty( ( dbfCliAtp )->dFecFin ) )

                     /*if ( dbfCliAtp )->nPrcArt != 0
                        ( dbfFacCliL )->nPreUnit   := ( dbfCliAtp )->nPrcArt
                     end if*/

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

               end if

               ( dbfAlbCliL )->( dbSkip( 1 ) )

            end do

            if lTotAlb .or. lTotAlbCli
               ( dbfFacCliL )->( dbAppend() )
               ( dbfFacCliL )->nNumLin    := ++nNumLin
               ( dbfFacCliL )->cSerie     := cSerAlb
               ( dbfFacCliL )->nNumFac    := nNewFac
               ( dbfFacCliL )->cSufFac    := cSufEmp
               ( dbfFacCliL )->mLngDes    := "Total albaran..."
               ( dbfFacCliL )->lTotLin    := .t.
            end if

         end if

         /*
         Pasamos los pagos-----------------------------------------------------
         */

         if ( dbfAlbCliP )->( dbSeek( oDbfTmp:cNumAlb ) )

            while ( dbfAlbCliP )->cSerAlb + Str( ( dbfAlbCliP )->nNumAlb ) + ( dbfAlbCliP )->cSufAlb == oDbfTmp:cNumAlb .and. !( dbfAlbCliP )->( Eof() )

               nTotEntAlb     += ( dbfAlbCliP )->nImporte

               ( dbfAlbCliP )->( dbSkip() )

            end while

         end if

         ( dbfAlbCliP )->( dbGoTop() )

      end if

      oDbfTmp:Skip()

      /*
      Damos valor al meter-----------------------------------------------------
      */

      oMetMsg:Set( oDbfTmp:OrdKeyNo() )

      /*
      Si el proceso ha sido iniciado o sea un albaran valido encontrado entonces preguntamos si
      es el ultimo item con lo cual hay q cerrar o bien hacemos prelectura del siguiente albaran
      y si cambian las condiciones tambien tenemos q cerrar
      */

      if nProcesando != 0 .and. ( nProcesando != oDbfTmp:nNumDoc .or. oDbfTmp:Eof() )

         /*
         Generamos el pago con la suma de las entregas a cuenta----------------
         */

         if nTotEntAlb != 0

            ( dbfFacCliP )->( dbAppend() )

            ( dbfFacCliP )->cSerie     := cSerAlb
            ( dbfFacCliP )->nNumFac    := nNewFac
            ( dbfFacCliP )->cSufFac    := cSufEmp
            ( dbfFacCliP )->nNumRec    := 1
            ( dbfFacCliP )->cTurRec    := ""
            ( dbfFacCliP )->lCloPgo    := .t.
            ( dbfFacCliP )->cCodCaj    := cCodCaj
            ( dbfFacCliP )->cCodCli    := cCodCli
            ( dbfFacCliP )->cNomCli    := cNomCli
            ( dbfFacCliP )->dEntrada   := dFecFac
            ( dbfFacCliP )->dPreCob    := dFecFac
            ( dbfFacCliP )->dFecVto    := dFecFac
            ( dbfFacCliP )->nImporte   := nTotEntAlb
            ( dbfFacCliP )->nImpCob    := nTotEntAlb
            ( dbfFacCliP )->cDescrip   := "Suma entregas a cuenta de albaranes"
            ( dbfFacCliP )->cCodPgo    := cCodPgo
            ( dbfFacCliP )->cDivPgo    := cDivFac
            ( dbfFacCliP )->nVdvPgo    := nVdvFac
            ( dbfFacCliP )->cCodAge    := cCodAge
            ( dbfFacCliP )->lCobrado   := .t.
            ( dbfFacCliP )->lConPgo    := .f.
            ( dbfFacCliP )->lRecImp    := .f.
            ( dbfFacCliP )->lRecDto    := .f.
            ( dbfFacCliP )->lPasado    := .t.
         
            ( dbfFacCliP )->( dbUnLock() )

         end if

         nTotEntAlb                    := 0

         // Generamos los pagos________________________________________________

         GenPgoFacCli( cSerAlb + Str( nNewFac ) + cSufEmp, dbfFacCliT, dbfFacCliL, dbfFacCliP, dbfAntCliT, dbfClient, dbfFPago, dbfDiv, dbfIva )

         // Comprueba si la factura esta pagada--------------------------------

         ChkLqdFacCli( nil, dbfFacCliT, dbfFacCliL, dbfFacCliP, dbfAntCliT, dbfIva, dbfDiv, .f. )

         // Guardamos los totales----------------------------------------------

         nRecAnt                          := ( dbfFacCliT )->( RecNo() )

         if dbSeekInOrd( cSerAlb + Str( nNewFac ) + cSufEmp, "nNumFac", dbfFacCliT )

            aTotFac                       := aTotFacCli( cSerAlb + Str( nNewFac ) + cSufEmp, dbfFacCliT, dbfFacCliL, dbfIva, dbfDiv, dbfFacCliP, dbfAntCliT, ( dbfFacCliT )->cDivFac )

            nTotalFacturas                += aTotFac[4]

            if dbLock( dbfFacCliT )

               if !empty( oDbfTmp:nPctDto1 ) .and. empty( ( dbfFacCliT )->cDtoEsp )
                  ( dbfFacCliT )->cDtoEsp := Padr( "General", 50 )
                  ( dbfFacCliT )->nDtoEsp := oDbfTmp:nPctDto1
               end if 

               if !empty( oDbfTmp:nPctDto2 ) .and. empty( ( dbfFacCliT )->cDpp )
                  ( dbfFacCliT )->cDpp    := Padr( "Pronto pago", 50 )
                  ( dbfFacCliT )->nDpp    := oDbfTmp:nPctDto2
               end if 

               if !empty( oDbfTmp:nPctDto3 ) .and. empty( ( dbfFacCliT )->cDtoUno )
                  ( dbfFacCliT )->cDtoUno := Space( 50 ) 
                  ( dbfFacCliT )->nDtoUno := oDbfTmp:nPctDto3
               end if 

               if !empty( oDbfTmp:nPctDto4 ) .and. empty( ( dbfFacCliT )->cDtoDos )
                  ( dbfFacCliT )->cDtoDos := Space(50)
                  ( dbfFacCliT )->nDtoDos := oDbfTmp:nPctDto4
               end if 

               ( dbfFacCliT )->nTotNet    := aTotFac[1]
               ( dbfFacCliT )->nTotIva    := aTotFac[2]
               ( dbfFacCliT )->nTotReq    := aTotFac[3]
               ( dbfFacCliT )->nTotFac    := aTotFac[4]

               ( dbfFacCliT )->( dbUnLock() )

            end if

         end if

         ( dbfFacCliT )->( dbGoTo( nRecAnt ) )

      end if

   end do

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CLOSE ( dbfFacCliT )
   CLOSE ( dbfFacCliL )
   CLOSE ( dbfFacCliP )
   CLOSE ( dbfFacCliS )
   CLOSE ( dbfAntCliT )

   ( dbfAlbCliT )->( OrdSetFocus( nOrd ) )
   ( dbfAlbCliT )->( dbGoTo( nRec ) )

   oDlg:Enable()

   if Empty( aMsg )
      MsgStop( "No se generaron facturas." )
   else
      Visor( aMsg )
   end if

RETURN NIL

//---------------------------------------------------------------------------//