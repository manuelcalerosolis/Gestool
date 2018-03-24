#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS ActualizaCosto FROM TInfGen

   DATA oDbfArt      AS OBJECT
   DATA oDbfDiv      AS OBJECT
   DATA oProduccT    AS OBJECT
   DATA oMetMsg      AS OBJECT

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Activate( oMenuItem, oWnd )

   METHOD Search()

END CLASS

//----------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen       := .t.
   local oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      DATABASE NEW ::oDbfArt PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

      DATABASE NEW ::oDbfDiv PATH ( cPatDat() ) FILE "DIVISAS.DBF" VIA ( cDriver() ) SHARED INDEX "DIVISAS.CDX"

      ::oProduccT    :=  TProduccion():Create( cPatEmp() )
      ::oProduccT:OpenFiles()

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos.", "Atención" )

      ::CloseFiles()

      lOpen := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN( lOpen )

//----------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbfArt )
      ::oDbfArt:End()
   end if

   if !Empty( ::oProduccT )
      ::oProduccT:end()
   end if

   if !Empty( ::oDbfDiv )
      ::oDbfDiv:End()
   end if

   ::oDbfArt   := nil
   ::oDbfDiv   := nil
   ::oProduccT := nil

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Activate( oMenuItem, oWnd )

   local oDlg
   local nLevel
   local nMetMsg        := 0
   local oCodArt
   local cCodArt        := ""
   local oSayArt
   local cSayArt        := ""
   local oBmp

   DEFAULT  oMenuItem   := "04008"
   DEFAULT  oWnd        := oWnd()

   // Nivel de usuario---------------------------------------------------------

   nLevel               := Auth():Level( oMenuItem )
   if nAnd( nLevel, 1 ) == 0
      msgStop( "Acceso no permitido." )
      return nil
   end if

   // Cerramos todas las ventanas----------------------------------------------

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   if !::OpenFiles()
      Return ( Self )
   end if

   DEFINE DIALOG oDlg RESOURCE "ACTUALIZACOSTOS" OF oWnd()

   REDEFINE BITMAP oBmp;
      RESOURCE "gc_worker2_48" ;
      ID       600  ;
      TRANSPARENT ;
      OF       oDlg

   ::oDefIniInf( 100, oDlg )
   ::oDefFinInf( 110, oDlg )

   REDEFINE GET oCodArt VAR cCodArt;
      ID       ( 120 ) ;
      VALID    cArticulo( oCodArt, ::oDbfArt:cAlias, oSayArt );
      BITMAP   "LUPA" ;
      ON HELP  BrwArticulo( oCodArt, oSayArt );
      OF       oDlg

   REDEFINE GET oSayArt VAR cSayArt ;
		WHEN 		.F.;
      ID       ( 130 ) ;
      OF       oDlg

   REDEFINE APOLOMETER ::oMetMsg VAR nMetMsg ;
      ID       140 ;
      TOTAL    ( ::oProduccT:oDbf:Lastrec() ) ;
      OF       oDlg

   REDEFINE BUTTON ;
      ID       500 ;
      OF       oDlg ;
      ACTION   ( ::Search( cCodArt, oDlg ) )

   REDEFINE BUTTON ;
      ID       550 ;
      OF       oDlg ;
      ACTION   ( oDlg:End() )

   ACTIVATE DIALOG oDlg CENTER

   ::CloseFiles()

   oBmp:End()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Search( cCodArt, oDlg )

   local cExpHead          := ""
   local nTotCostoPersonal := 0
   local nTotLitros        := 0

   // Comprobaciones iniciales-------------------------------------------------

   if Empty( cCodArt )
      MsgStop( "Tiene que seleccionar el artículo al que va a cambiar el costo" )
      return .f.
   end if

   if ::dFinInf < ::dIniInf
      MsgStop( "Margen de fecha erróneo" )
      return .f.
   end if

   // Recorremos las tablas para sacar los totales-----------------------------

   ::oProduccT:oDbf:OrdSetFocus( "dFecOrd" )

   cExpHead       := 'dFecOrd >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFin <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   ::oProduccT:oDbf:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oProduccT:oDbf:cFile ), ::oProduccT:oDbf:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMetMsg:SetTotal( ::oProduccT:oDbf:OrdKeyCount() )

   ::oProduccT:oDbf:GoTop()

   while !::oProduccT:oDbf:Eof()

      nTotCostoPersonal    += ::oProduccT:nTotalPersonal( ::oProduccT:oDbf:cSerOrd + Str( ::oProduccT:oDbf:nNumOrd ) + ::oProduccT:oDbf:cSufOrd )

      if ::oProduccT:oDetProduccion:oDbf:Seek( ::oProduccT:oDbf:cSerOrd + Str( ::oProduccT:oDbf:nNumOrd ) + ::oProduccT:oDbf:cSufOrd )

         while ::oProduccT:oDetProduccion:oDbf:cSerOrd + Str( ::oProduccT:oDetProduccion:oDbf:nNumOrd ) + ::oProduccT:oDetProduccion:oDbf:cSufOrd == ::oProduccT:oDbf:cSerOrd + Str( ::oProduccT:oDbf:nNumOrd ) + ::oProduccT:oDbf:cSufOrd .and. !::oProduccT:oDetProduccion:oDbf:eof()

            nTotLitros     += NotCaja( ::oProduccT:oDetProduccion:oDbf:nCajOrd ) * NotCero( ::oProduccT:oDetProduccion:oDbf:nUndOrd ) * NotCero( ::oProduccT:oDetProduccion:oDbf:nVolumen )

            ::oProduccT:oDetProduccion:oDbf:Skip()

         end while

      end if

      ::oProduccT:oDbf:Skip()

      ::oMetMsg:Set( ::oProduccT:oDbf:OrdKeyNo() )

   end while

   ::oProduccT:oDbf:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oProduccT:oDbf:cFile ) )

   ::oMetMsg:Set( ::oProduccT:oDbf:Lastrec() )

   // Preguntamos si queremos cambiar el registro y lo cambiamos---------------

   if ApoloMsgNoYes( "Se va a cambiar costo del artículo."                                         + CRLF + ;
                     AllTrim( cCodArt ) + " - " + AllTrim( oRetFld( cCodArt, ::oDbfArt ) ) + ";"   + CRLF + ;
                     "el nuevo costo será : " + AllTrim( Trans( ( nTotCostoPersonal / nTotLitros ), cPinDiv( cDivEmp(), ::oDbfDiv ) ) ) + cSimDiv( cDivEmp(), ::oDbfDiv ) ,;
                     "¿ Desea proceder ?" )

      if ::oDbfArt:SeekInOrd( cCodArt, "Codigo" )

         ::oDbfArt:Load()
         ::oDbfArt:pCosto  := ( nTotCostoPersonal / nTotLitros )
         ::oDbfArt:Save()

         msgInfo( "El precio del artículo se ha actualizado correctamente", AllTrim( cCodArt ) + " - " + AllTrim( oRetFld( cCodArt, ::oDbfArt ) ) )

      end if

   end if

RETURN ( oDlg:End() )

//----------------------------------------------------------------------------//