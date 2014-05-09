#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Xbrowse.ch"

//--------------------------------------------------------------------------//

#define ubiGeneral                  0
#define ubiLlevar                   1
#define ubiSala                     2
#define ubiRecoger                  3
#define ubiEncargar                 4

CLASS TpvUtilidadesMesa FROM TpvTactil

	DATA oSender

	DATA oBrwOriginal
	DATA oBrwNuevoTicket

	DATA oDlg
		DATA oGrupoOriginal
		DATA oGrupoNuevo
		DATA oBtnEscandallosOrg  
		DATA oBtnEscandallosNew

	DATA oOfficeBar
 	DATA oOfficeBarDividirMesas

 	DATA cCodSala
 	DATA cPntVenta

 	DATA oSelectedPunto

 	DATA oSayZonaDestino
 	DATA cSayZonaDestino
 	DATA oSayInfoDestino
 	DATA cSayInfoDestino
 	DATA oSayZonaOrigen
 	DATA cSayZonaOrigen
 	DATA oSayInfoOrigen
 	DATA cSayInfoOrigen

 	DATA TiketOrigen
 	DATA TiketDestino

 	METHOD cTiketOrigen( uValue ) 	INLINE ( if( !empty( uValue ), ::TiketOrigen 	:= uValue, ::TiketOrigen ) )
 	METHOD cTiketDestino( uValue )	INLINE ( if( !empty( uValue ), ::TiketDestino 	:= uValue, ::TiketDestino ) )

	METHOD New( oSender ) CONSTRUCTOR

	METHOD End()

 	METHOD oRestaurante()   INLINE ( ::oSender:oRestaurante )

	METHOD DividirMesas()
		//METHOD StartDividirMesas()
		METHOD lInitCheckDividirMesas()

	METHOD CargaTemporalOrigen()
	METHOD CargaTemporalDestino()

	METHOD AceptarDividirMesa()

	METHOD GuardaTicketOrigen() INLINE 		( ::GuardaLineasTicketOrigen(), ::oSender:GuardaDocumento( .f. ) )
		METHOD GuardaLineasTicketOrigen()

	METHOD CreaNuevoTicket()

	METHOD AddLinea()
	METHOD AddAllLine()

	METHOD AddEscandallo()

	//METHOD AddLineOrgToNew()
	//METHOD AddLineNewToOrg()

	//METHOD AddAllOrgToNew()
	//METHOD AddAllNewToOrg()

	METHOD PasaLinea()
	//METHOD PasaLineaOrgToNew( nUnidades ) INLINE ( ::PasaLinea( nUnidades, ::oOriginal(), ::oNuevo() ) )
	//METHOD PasaLineaNewToOrg( nUnidades )	INLINE ( ::PasaLinea( nUnidades, ::oNuevo(), ::oOriginal() ) )

	METHOD BorraLinea( oDbf )				INLINE ( oDbf:Delete(.f.) )
	//METHOD BorraLineaOrigen()				INLINE ( ::oOriginal():Delete(.f.) )
	//METHOD BorraLineaDestino()			INLINE ( ::oNuevo():Delete(.f.) )

	METHOD lNuevoTicket() 					INLINE ( empty( ::oSelectedPunto:cTiket() ) .or. ( ::oSender:cNumeroTicket() == ::oSelectedPunto:cTiket() ) )

	METHOD GuardaTicketDestino()
		METHOD BorraLineasAnteriores()
		METHOD GuardaLineasTicketDestino()
		METHOD CreaNuevaCabecera()

	METHOD oOriginal() 						INLINE ( ::oSender:oTemporalDivisionOriginal )
	METHOD oNuevo() 						INLINE ( ::oSender:oTemporalDivisionNuevoTicket )

//---------------------------------------------------------------------------//

   INLINE METHOD lShowEscandallosDivision()

      local cFocusOriginal
      local cFocusNuevoTicket

      cFocusOriginal      := Upper( ::oOriginal():OrdSetFocus() )

      if ( cFocusOriginal == Upper( "nRecNum" ) )
         ::oOriginal():OrdSetFocus( "lRecNum" )
      else
         ::oOriginal():OrdSetFocus( "nRecNum" )
      end if

      cFocusNuevoTicket   := Upper( ::oNuevo():OrdSetFocus() )

      if ( cFocusNuevoTicket == Upper( "nRecNum" ) )
         ::oNuevo():OrdSetFocus( "lRecNum" )
      else
         ::oNuevo():OrdSetFocus( "nRecNum" )
      end if

      ::oBrwOriginal:GoTop()
      ::oBrwOriginal:Refresh()

      ::oBrwNuevoTicket:GoTop()
      ::oBrwNuevoTicket:Refresh()

      RETURN ( Self )

   ENDMETHOD

//---------------------------------------------------------------------------//

   INLINE METHOD cInfo()

      local cInfo       := ""

      cInfo             += "Sesión : " + Alltrim( Transform( cCurSesion(), "######" ) ) + Space( 1 )

      if ::lNuevoTicket()
         cInfo          += "*Nuevo*"
      else
         cInfo          += "Ticket : " + ::oSelectedPunto:cSerie + "/" + Alltrim( ::oSelectedPunto:cNumero) + Space( 1 )
      end if

      
      if !Empty( ::oSelectedPunto:dFecha ) .and. !::lNuevoTicket()
         cInfo          += Dtoc( ::oSelectedPunto:dFecha ) + Space( 1 )
      end if

      if !Empty( ::oSelectedPunto:cHora ) .and. !::lNuevoTicket()
         cInfo          += ( ::oSelectedPunto:cHora ) + Space( 1 )
      end if

      RETURN ( cInfo )

   ENDMETHOD

//---------------------------------------------------------------------------//

	INLINE METHOD cTxtUbicacion()
		
		local cTxtUbicacion	:= ""

		cTxtUbicacion 		+= ::oRestaurante:cTextoSala( ::oSelectedPunto:cSala ) + Space( 1 ) + ":" + Space( 1 )
		cTxtUbicacion 		+= Rtrim( ::oSelectedPunto:cPuntoVenta )

		RETURN ( cTxtUbicacion )

	ENDMETHOD

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS TpvUtilidadesMesa

	::oSender     	:= oSender

Return ( Self )

//--------------------------------------------------------------------------//

METHOD End() CLASS TpvUtilidadesMesa

   if !Empty( ::oDlg )
      ::oDlg:End()
   end if

   ::oDlg               := nil

Return( Self )

//--------------------------------------------------------------------------//

METHOD DividirMesas() CLASS TpvUtilidadesMesa

	local cSelectedSala
	local cSelectedPunto
      
   //Comprobaciones iniciales----------------------------------------------------
   
	if !::lInitCheckDividirMesas()
	  	return .f.
	end if

	::oRestaurante():oSalon:cTitle( "Seleccionar punto de venta destino" )

	if ::oRestaurante():Sala( nil, .t. )

        cSelectedSala  		:= ::oRestaurante():cSelectedSala
        cSelectedPunto 		:= ::oRestaurante():cSelectedPunto

        ::oSelectedPunto 	:= ::oRestaurante():oSelectedPunto

    else

    	return .f.

    end if 


    ::cTiketOrigen( ::oSender:cNumeroTicket() )
    ::cTiketDestino( ::oSelectedPunto:cTiket() )


    // Inicializacion de variables--------------------------------------------- 

	::cSayZonaOrigen 	:= ::oSender:cTxtUbicacion()
	::cSayInfoOrigen 	:= ::oSender:cInfo()

    ::cSayZonaDestino 	:= ::cTxtUbicacion()
	::cSayInfoDestino	:= ::cInfo()

	//Rellenamos la temporal oiginal----------------------------------------------

	::CargaTemporalOrigen()

	::CargaTemporalDestino()

	// Comenzamos el dialogo---------------------------------------------------

	DEFINE DIALOG ::oDlg RESOURCE "DIVIDIR_MESAS"

	REDEFINE GROUP ::oGrupoOriginal ID 100 OF ::oDlg TRANSPARENT

	::oGrupoOriginal:SetFont( ::oSender:oFntFld )

	// Browse de Lineas Originales-------------------------------------------------

	REDEFINE SAY ::oSayZonaOrigen ;
	  PROMPT   ::cSayZonaOrigen ;
	  FONT     ::oSender:oFntBrw ;
	  ID       110 ;
	  OF       ::oDlg

	REDEFINE SAY ::oSayInfoOrigen ;
	  PROMPT   ::cSayInfoOrigen ;
	  FONT     ::oSender:oFntBrw ;
	  ID       120 ;
	  OF       ::oDlg

	::oBrwOriginal                        := IXBrowse():New( ::oDlg )

	::oBrwOriginal:bClrStd          := {|| ::oSender:ColorLinea( ::oSender:oTemporalDivisionOriginal ) }
   	::oBrwOriginal:bClrSel          := {|| ::oSender:ColorLineaSeleccionada( ::oSender:oTemporalDivisionOriginal ) } 
   	::oBrwOriginal:bClrSelFocus     := {|| ::oSender:ColorLineaFocus( ::oSender:oTemporalDivisionOriginal ) }

	//::oBrwOriginal:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
	//::oBrwOriginal:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

	::oBrwOriginal:lRecordSelector        := .f.
	::oBrwOriginal:lHScroll               := .f. 
	::oBrwOriginal:lVScroll               := .f.

	::oBrwOriginal:nMarqueeStyle          := MARQSTYLE_HIGHLROW
	::oBrwOriginal:nRowHeight             := 36
	::oBrwOriginal:cName                  := "Tactil.Lineas.Originales" 
	::oBrwOriginal:lFooter                := .t.

	::oBrwOriginal:SetFont( ::oSender:oFntBrw )

	::oOriginal():SetBrowse( ::oBrwOriginal )

	::oBrwOriginal:CreateFromResource( 130 )

	with object ( ::oBrwOriginal:AddCol() )
	  :cHeader          := "Und"
	  :bEditValue       := {|| ::oSender:nUnidadesLinea( ::oSender:oTemporalDivisionOriginal, .t. ) }
	  :nWidth           := 50
	  :nDataStrAlign    := AL_RIGHT
	  :nHeadStrAlign    := AL_RIGHT
	end with

	with object ( ::oBrwOriginal:AddCol() )
	  :cHeader          := "Detalle"
	  :bEditValue       := {|| ::oSender:cTextoLineaDivision( ::oSender:oTemporalDivisionOriginal ) }
	  :nWidth           := 230
	end with

	with object ( ::oBrwOriginal:AddCol() )
	  :cHeader          := "Total"
	  :bEditValue       := {|| ::oSender:nTotalLinea( ::oSender:oTemporalDivisionOriginal, .t. ) }
	  :nWidth           := 90
	  :bFooter       := {|| Trans( ::oSender:nTotalTemporalDivision( ::oSender:oTemporalDivisionOriginal ), ::oSender:cPictureTotal ) }
	  :nDataStrAlign := AL_RIGHT      
	  :nHeadStrAlign := AL_RIGHT
	  :nFootStrAlign := AL_RIGHT 
	end with


	TButtonBmp():ReDefine( 320, {|| ::oBrwOriginal:GoUp() }, ::oDlg, , , .f., , , , .f., "Navigate_up" )
	TButtonBmp():ReDefine( 330, {|| ::oBrwOriginal:GoDown() }, ::oDlg, , , .f., , , , .f., "Navigate_down" ) 

	TButtonBmp():ReDefine( 300, {|| ::AddLinea( ::oOriginal(), ::oNuevo() ) }, ::oDlg, , , .f., , , , .f., "Navigate_right" )
	TButtonBmp():ReDefine( 310, {|| ::AddLinea( ::oNuevo(), ::oOriginal() ) }, ::oDlg, , , .f., , , , .f., "Navigate_left" ) 
	TButtonBmp():ReDefine( 360, {|| ::AddAllLine( ::oOriginal(), ::oNuevo() ) }, ::oDlg, , , .f., , , , .f., "Navigate_right2" )
	TButtonBmp():ReDefine( 370, {|| ::AddAllLine( ::oNuevo(), ::oOriginal() ) }, ::oDlg, , , .f., , , , .f., "Navigate_left2" ) 

	//Browse de Lineas para el Nuevo Ticket---------------------------------------

	REDEFINE GROUP ::oGrupoNuevo ID 200 OF ::oDlg TRANSPARENT
	  
	::oGrupoNuevo:SetFont( ::oSender:oFntFld )

	REDEFINE SAY ::oSayZonaDestino ;
	  	PROMPT   ::cSayZonaDestino ;
	  	FONT     ::oSender:oFntBrw ;
	  	ID       210 ;
	  	OF       ::oDlg

	REDEFINE SAY ::oSayInfoDestino ;
	  	PROMPT   ::cSayInfoDestino;
	  	FONT     ::oSender:oFntBrw ;
	  	ID       220 ;
	  	OF       ::oDlg

	::oBrwNuevoTicket                        := IXBrowse():New( ::oDlg )

	::oBrwNuevoTicket:bClrStd          		 := {|| ::oSender:ColorLinea( ::oSender:oTemporalDivisionNuevoTicket ) }
   	::oBrwNuevoTicket:bClrSel          		 := {|| ::oSender:ColorLineaSeleccionada( ::oSender:oTemporalDivisionNuevoTicket ) } 
   	::oBrwNuevoTicket:bClrSelFocus     		 := {|| ::oSender:ColorLineaFocus( ::oSender:oTemporalDivisionNuevoTicket ) }

	::oBrwNuevoTicket:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
	::oBrwNuevoTicket:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

	::oBrwNuevoTicket:lRecordSelector        := .f.
	::oBrwNuevoTicket:lHScroll               := .f.
	::oBrwNuevoTicket:lVScroll               := .f.

	::oBrwNuevoTicket:nMarqueeStyle          := MARQSTYLE_HIGHLROW
	::oBrwNuevoTicket:nRowHeight             := 36
	::oBrwNuevoTicket:cName                  := "Tactil.Lineas.NuevoTicket"
	::oBrwNuevoTicket:lFooter                := .t.

	::oBrwNuevoTicket:SetFont( ::oSender:oFntBrw )

	::oNuevo():SetBrowse( ::oBrwNuevoTicket )

	::oBrwNuevoTicket:CreateFromResource( 230 )

	with object ( ::oBrwNuevoTicket:AddCol() )
	  :cHeader       := "Und"
	  :bEditValue    := {|| ::oSender:nUnidadesLinea( ::oSender:oTemporalDivisionNuevoTicket, .t. ) }
	  :nWidth        := 50
	  :nDataStrAlign := AL_RIGHT      
	  :nHeadStrAlign := AL_RIGHT
	end with

	with object ( ::oBrwNuevoTicket:AddCol() )
	  :cHeader       := "Detalle"
	  :bEditValue    := {|| ::oSender:cTextoLineaDivision( ::oSender:oTemporalDivisionNuevoTicket ) }
	  :nWidth        := 230
	end with

	with object ( ::oBrwNuevoTicket:AddCol() )
	  :cHeader       := "Total"
	  :bEditValue    := {|| ::oSender:nTotalLinea( ::oSender:oTemporalDivisionNuevoTicket, .t. ) }
	  :nWidth        := 90
	  :bFooter       := {|| Trans( ::oSender:nTotalTemporalDivision( ::oSender:oTemporalDivisionNuevoTicket ), ::oSender:cPictureTotal ) }
	  :nDataStrAlign := AL_RIGHT 
	  :nHeadStrAlign := AL_RIGHT
	  :nFootStrAlign := AL_RIGHT 
	end with

	TButtonBmp():ReDefine( 340, {|| ::oBrwNuevoTicket:GoUp() },   ::oDlg, , , .f., , , , .f., "Navigate_up" )
	
	TButtonBmp():ReDefine( 350, {|| ::oBrwNuevoTicket:GoDown() }, ::oDlg, , , .f., , , , .f., "Navigate_down" )

	TButtonBmp():ReDefine( 380, {|| ::lShowEscandallosDivision() }, ::oDlg, , , .f., , , , .f., "Text_code_32" )

	TButtonBmp():ReDefine( IDOK, {|| ::AceptarDividirMesa() }, ::oDlg, , , .f., , , , .f., "Check_32" )

	TButtonBmp():ReDefine( IDCANCEL, {|| ::oDlg:End() }, ::oDlg, , , .f., , , , .f., "End32"  )

	//Activamos el diálogo--------------------------------------------------------

	ACTIVATE DIALOG ::oDlg CENTER

	//Matamos la Officebar antes de salir-----------------------------------------

	if !Empty( ::oOfficeBar )
	  ::oOfficeBarDividirMesas:End()
	end if

	::oOfficeBarDividirMesas      := nil

	::EnableDialog()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD lInitCheckDividirMesas() class TpvUtilidadesMesa

   if Empty( ::oSender:oTemporalLinea ) .or. Empty( ::oSender:oTemporalLinea:RecCount() )

      MsgStop( "No puede dividir un documento sin línea" )

      return .f.

   end if

   if ::oSender:oTiketCabecera:nUbiTik != ubiSala

      MsgStop( "Sólo se puede dividir mesas" )

      return .f.

   end if

Return( .t. )

//---------------------------------------------------------------------------//

/*
METHOD StartDividirMesas() Class TpvUtilidadesMesa

	local oCarpeta
	local oGrupo
	local oBoton

   ::oOfficeBarDividirMesas            := TDotNetBar():New( 0, 0, 1020, 120, ::oDlg, 1 )

   ::oOfficeBarDividirMesas:lPaintAll  := .f.
   ::oOfficeBarDividirMesas:lDisenio   := .f.

   ::oOfficeBarDividirMesas:SetStyle( 1 )

   oCarpeta                           	:= TCarpeta():New( ::oOfficeBarDividirMesas, "División de mesas" )

   oGrupo                             	:= TDotNetGroup():New( oCarpeta, 66,  "Aceptar", .f. )
                                           TDotNetButton():New( 60, oGrupo,    "Check_32",      "Aceptar",                 1, {|| ::AceptarDividirMesa() }, , , .f., .f., .f. )

   oGrupo                             	:= TDotNetGroup():New( oCarpeta, 66,  "Escandallos", .f. )
                                           TDotNetButton():New( 60, oGrupo,    "Text_code_32",  "Ocultar o mostrar",       1, {|| ::lShowEscandallosDivision() }, , , .f., .f., .f. )
                                          
   oGrupo                             	:= TDotNetGroup():New( oCarpeta, 66,  "Aceptar", .f. )
                                           TDotNetButton():New( 60, oGrupo,    "End32",         "Salida",                  1, {|| ::oDlg:End() }, , , .f., .f., .f. )                                                                              

   ::oDlg:oTop                          := ::oOfficeBarDividirMesas

Return ( Self )
*/


//---------------------------------------------------------------------------//

METHOD CargaTemporalOrigen() class TpvUtilidadesMesa

   ::oOriginal():Zap()

   ::oSender:oTemporalLinea:GetStatus()

   ::oSender:oTemporalLinea:OrdSetFocus( "lRecNum" )

   ::oSender:oTemporalLinea:GoTop()  
   while !::oSender:oTemporalLinea:Eof()

      dbPass( ::oSender:oTemporalLinea:cAlias, ::oOriginal():cAlias, .t. )

      ::oSender:oTemporalLinea:Skip()

   end while

   ::oSender:oTemporalLinea:SetStatus()
   ::oOriginal():GoTop()
 
Return ( Self )

//---------------------------------------------------------------------------//

METHOD CargaTemporalDestino() class TpvUtilidadesMesa

	local cNumeroTicket 	:= ::oSelectedPunto:cTiket()

   	::oNuevo():Zap()

   	if !::lNuevoTicket()

   		::oSender:oTiketLinea:GetStatus()

   		::oSender:oTiketLinea:OrdSetFocus( "cNumTil" )

   		::oSender:oTiketLinea:Seek( cNumeroTicket )
   		while ( ::oSender:oTiketLinea:cSerTil + ::oSender:oTiketLinea:cNumTil + ::oSender:oTiketLinea:cSufTil == cNumeroTicket ) .and. !::oSender:oTiketLinea:Eof()

			dbPass( ::oSender:oTiketLinea:cAlias, ::oNuevo():cAlias, .t. )
   			
   			::oSender:oTiketLinea:Skip()

   		end while

   		::oSender:oTiketLinea:SetStatus()
   		
   		::oNuevo():GoTop()

   	end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD AceptarDividirMesa() Class TpvUtilidadesMesa

	local lDeleteOriginal 	:= .f.

	::cCodSala 				:= ::oRestaurante():cSelectedSala
	::cPntVenta 			:= ::oRestaurante():cSelectedPunto

	// Preguntamos si el ticket de origen se va a quedar vacio--------------------------

	if 	( ::oOriginal():OrdKeyCount() == 0 )

		if ( ApoloMsgNoYes( "¿ Desea realmente eliminar el ticket " + ::oSender:cNumeroTicketFormato() + " ?", "Atención", .t. ) )

      		// Eliminamos origen y guardamos destino----------------------------

			::oDlg:Disable()

			::oSender:EliminaDocumento( ::cTiketOrigen )
         		
       		::GuardaTicketDestino()

       		//Cargo documento destino-------------------------------------------

       		::oSender:CargaDocumento( ::TiketDestino )

	       	::oDlg:Enable()

	       	::oDlg:End()

	       	Return ( .t. )

	    else

	    	Return ( .f. )

    	end if

	end if 

	// Si el ticket destino esta vacio y no es nuevo---------------------------

	if ( ::oNuevo():OrdKeyCount() == 0 ) .and. ( !::lNuevoTicket() )

		if ( ApoloMsgNoYes( "¿ Desea realmente eliminar el ticket " + ::oSelectedPunto:cTextoTiket() + " ?", "Atención", .t. ) )

      		// Eliminamos destino y guardamos origen----------------------------

			::oDlg:Disable()
         		
       		::GuardaTicketOrigen()
         		
       		// Elimino documento destino-----------------------------------------

       		::oSender:EliminaDocumento( ::TiketDestino )

       		// Cargo el documento origen-----------------------------------------

       		::oSender:CargaDocumento( ::TiketOrigen )

	       	::oDlg:Enable()

       		::oDlg:End()

	       	Return ( .t. )

	    else

	    	Return ( .f. )

	    end if

	end if


	// Si no estan vacios ninguno de los dos tickets -------------------------------

	::oDlg:Disable()		

	// Pasar la temporal------------------------------------------------------------

 	::GuardaTicketOrigen()

	// Guardamos el ticket de destino si no esta vacio------------------------------
	
	if ( ::oNuevo():OrdKeyCount() != 0 )

 		::GuardaTicketDestino()

 	end if

 	::oSender:CargaDocumento( ::cTiketDestino )

   	::oDlg:Enable()
   	::oDlg:End( IDOK )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD GuardaLineasTicketOrigen() Class TpvUtilidadesMesa

   ::oSender:oTemporalLinea:Zap()

   ::oOriginal():OrdSetFocus( "lRecNum" )

   ::oOriginal():GoTop()
   while !::oOriginal():Eof()

      dbPass( ::oOriginal():cAlias, ::oSender:oTemporalLinea:cAlias, .t. )

      ::oOriginal():Skip()

   end while

   ::oSender:oTemporalLinea:GoTop()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD GuardaTicketDestino()
	
	local cNumeroTicket

	if !::lNuevoTicket()

		cNumeroTicket 			:= ::oSelectedPunto:cTiket()

		::BorraLineasAnteriores( cNumeroTicket )

	else
		
		cNumeroTicket 			:= ::CreaNuevaCabecera()

		::cTiketDestino( cNumeroTicket )

	end if

	::GuardaLineasTicketDestino( cNumeroTicket )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD BorraLineasAnteriores( cNumeroTicket )

	while ::oSender:oTiketLinea:SeekInOrd( cNumeroTicket, "cNumTil" )
		::oSender:oTiketLinea:Delete()
	end while

Return ( Self )

//---------------------------------------------------------------------------//

METHOD CreaNuevaCabecera()

	::oSender:oTiketCabecera:Load()

	::oSender:CargaValoresDefecto( ubiSala, .t. )

	::oSender:oTiketCabecera:cNumTik   	:= ::oSender:nNuevoNumeroTicket()
	::oSender:oTiketCabecera:cCodSala  	:= ::cCodSala
	::oSender:oTiketCabecera:cPntVenta 	:= ::cPntVenta 
	::oSender:oTiketCabecera:dFecTik   	:= GetSysDate()
	::oSender:oTiketCabecera:cHorTik   	:= Time()
	::oSender:oTiketCabecera:dFecCre   	:= GetSysDate()
	::oSender:oTiketCabecera:cTimCre   	:= Time()
	::oSender:oTiketCabecera:lAbierto  	:= .t.

	::oSender:oTiketCabecera:Insert()

Return ( ::oSender:oTiketCabecera:cSerTik + ::oSender:oTiketCabecera:cNumTik + ::oSender:oTiketCabecera:cSufTik )

//---------------------------------------------------------------------------//

METHOD GuardaLineasTicketDestino( cNumeroTicket )

	if ::oSender:oTiketCabecera:SeekInOrd( cNumeroTicket, "cNumTik" )

		::oNuevo():GoTop()
      	while !::oNuevo():Eof()

         	appendPass( ::oNuevo():cAlias,;
                     	::oSender:oTiketLinea:cAlias,;
						{ 	"cSerTil" => ::oSender:oTiketCabecera:FieldGetByName( "cSerTik" ),;
                        	"cNumTil" => ::oSender:oTiketCabecera:FieldGetByName( "cNumTik" ),;
                        	"cSufTil" => ::oSender:oTiketCabecera:FieldGetByName( "cSufTik" ),;
                        	"dTipTil" => ::oSender:oTiketCabecera:FieldGetByName( "cTipTik" ),;
                        	"dFecTik" => ::oSender:oTiketCabecera:FieldGetByName( "dFecTik" ) } )

         	::oNuevo():Skip()

   		end while

   	end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD CreaNuevoTicket() Class TpvUtilidadesMesa

	local oError
   	local oBlock

	return .f.

   ::DisableDialog()

/*
   oBlock                           := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
*/
      
      //Si el numero de ticket esta vacio debemos tomar un nuevo numero-------------

      ::oSender:oTiketCabecera:Load()

      ::oSender:CargaValoresDefecto( ubiSala, .t. )

      ::oSender:oTiketCabecera:cNumTik   	:= ::oSender:nNuevoNumeroTicket()
      ::oSender:oTiketCabecera:cCodSala  	:= ::cCodSala
      ::oSender:oTiketCabecera:cPntVenta 	:= ::cPntVenta 
      ::oSender:oTiketCabecera:dFecTik   	:= GetSysDate()
      ::oSender:oTiketCabecera:cHorTik   	:= Time()
      ::oSender:oTiketCabecera:dFecCre   	:= GetSysDate()
      ::oSender:oTiketCabecera:cTimCre   	:= Time()
      ::oSender:oTiketCabecera:lAbierto  	:= .t.

      ::oSender:oTiketCabecera:Insert()

      //Ahora metemos una linea-----------------------------------------------------
      
      ::oNuevo():GoTop()

      while !::oNuevo():Eof()

         appendPass( ::oNuevo():cAlias,;
                     ::oSender:oTiketLinea:cAlias,;
                     {  "cSerTil" => ::oSender:oTiketCabecera:cSerTik,;
                        "cNumTil" => ::oSender:oTiketCabecera:cNumTik,;
                        "cSufTil" => ::oSender:oTiketCabecera:cSufTik,;
                        "dTipTil" => ::oSender:oTiketCabecera:cTipTik,;
                        "dFecTik" => ::oSender:oTiketCabecera:dFecTik } )

         ::oNuevo():Skip()

   end while

   ::oSender:CargaDocumento( ::oSender:cNumeroTicket() )

/*
   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Error al generar nuevo ticket" )

   END SEQUENCE

   ErrorBlock( oBlock )
*/
   ::EnableDialog()
   
Return ( Self )

//---------------------------------------------------------------------------//

METHOD PasaLinea( nUnidades, oOrigen, oDestino )

	if !oDestino:SeekinOrd( Str( oOrigen:nNumLin ) + oOrigen:cCbaTil, "cLinCba" )

		dbPass( oOrigen:cAlias, oDestino:cAlias, .t. )

		oDestino:nUntTil := nUnidades

		if oOrigen:lKitArt

			::AddEscandallo( oOrigen, oDestino )

		end if

	 else

		oDestino:nUntTil += nUnidades

		if oOrigen:lKitArt

			::AddEscandallo( oOrigen, oDestino )

		end if

	end if  

Return ( Self )

//---------------------------------------------------------------------------//

METHOD AddLinea( oOrigen, oDestino ) class TpvUtilidadesMesa


	if oOrigen:lDelTil
		msgStop( "No se pueden pasar lineas eliminadas de una mesa a otra." )
		return ( Self )
	end if   

	if oOrigen:lKitChl
		msgStop( "No se pueden pasar lineas pertenecientes a un escandallo." )
		return ( Self )
	end if 

	if empty( oOrigen:RecCount() )
		msgStop( "No hay lineas que pasar." )
		return ( Self )
	end if


	if oOrigen:nUntTil > 0 .and. isInteger( oOrigen:nUntTil )

		::PasaLinea( 1, oOrigen, oDestino )

		oOrigen:nUntTil--

		if oOrigen:nUntTil == 0
			
			::BorraLinea( oOrigen )
		
		end if

	else

		::PasaLinea( oOrigen:nUntTil, oOrigen, oDestino )

		::BorraLinea( oOrigen )

	end if

	oOrigen:GoTop()

	::oBrwOriginal:Refresh()
	::oBrwNuevoTicket:Refresh()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD AddEscandallo( oOrigen, oDestino )

	local nLinea
	local cCodArt
	local nUnidades
	
	nLinea      := oOrigen:nNumLin
	cCodArt     := oOrigen:cCbaTil
	nUnidades   := oOrigen:nUntTil

    oOrigen:GetStatus()

    oOrigen:OrdSetFocus( "lRecNum" )

    oOrigen:GoTop()

       while !oOrigen:Eof()

          if oOrigen:nNumLin == nLinea .and. oOrigen:cCbaTil != cCodArt

             if !oDestino:SeekinOrd( Str( oOrigen:nNumLin ) + oOrigen:cCbaTil, "cLinCba" )

                dbPass( oOrigen:cAlias, oDestino:cAlias, .t. )

                oDestino:nUntTil := oOrigen:nUntTil / nUnidades

             else

                oDestino:nUntTil += oOrigen:nUntTil / nUnidades

             end if

             oOrigen:nUntTil -= oOrigen:nUntTil / nUnidades

          end if

          oOrigen:Skip()

       end while

    oOrigen:OrdSetFocus( "nRecNum" )   

    oOrigen:SetStatus()

Return ( Self )

//---------------------------------------------------------------------------//

/*
METHOD AddLineOrgToNew() Class TpvUtilidadesMesa
/*
   local nLinea
   local cCodArt
   local nUnidades

   if valor:lDelTil
      msgStop( "No se pueden pasar lineas eliminadas de una mesa a otra." )
      return ( Self )
   end if   

   if valor:lKitChl
      msgStop( "No se pueden pasar lineas pertenecientes a un escandallo." )
      return ( Self )
   end if 

   if empty( valor:RecCount() )
      msgStop( "No hay lineas que pasar." )
      return ( Self )
   end if
/*
   nLinea      := ::oOriginal():nNumLin
   cCodArt     := ::oOriginal():cCbaTil
   nUnidades   := ::oOriginal():nUntTil

   	if ::oOriginal():nUntTil > 0 .and. isInteger( ::oOriginal():nUntTil )

		::PasaLineaOrgToNew( 1 )

		::oOriginal():nUntTil-- 

		if ::oOriginal():nUntTil == 0
			::BorraLineaOrigen()
		end if

	else
		
		::PasaLineaOrgToNew( ::oOriginal():nUntTil )

		::BorraLineaOrigen()

	end if



/*


   do case
      case ::oOriginal():nUntTil > 0 .and. 





         ::oOriginal():nUntTil 		:= ::oOriginal():nUntTil - 1
         if ::oOriginal():nUntTil == 0
         	::oOriginal():Delete(.f.)
         end if 

         if !::oNuevo():SeekinOrd( Str( ::oOriginal():nNumLin ) + ::oOriginal():cCbaTil, "cLinCba" )

            dbPass( ::oOriginal():cAlias, ::oNuevo():cAlias, .t. )

            ::oNuevo():nUntTil := 1

         else

            ::oNuevo():nUntTil++

         end if  

         
         //Si es un producto kit pasamos tambien los productos kit---------------
         
         if ::oOriginal():lKitArt

            ::oOriginal():GetStatus()

            ::oOriginal():OrdSetFocus( "lRecNum" )

            ::oOriginal():GoTop()

               while !::oOriginal():Eof()

                  if ::oOriginal():nNumLin == nLinea .and. ::oOriginal():cCbaTil != cCodArt

                     if !::oNuevo():SeekinOrd( Str( ::oOriginal():nNumLin ) + ::oOriginal():cCbaTil, "cLinCba" )

                        dbPass( ::oOriginal():cAlias, ::oNuevo():cAlias, .t. )

                        ::oNuevo():nUntTil := ::oOriginal():nUntTil / nUnidades

                     else

                        ::oNuevo():nUntTil += ::oOriginal():nUntTil / nUnidades

                     end if

                     ::oOriginal():nUntTil -= ::oOriginal():nUntTil / nUnidades

                  end if

                  ::oOriginal():Skip()

               end while

            ::oOriginal():OrdSetFocus( "nRecNum" )   

            ::oOriginal():SetStatus()

         end if

      case ::oOriginal():nUntTil == 0

         if !::oNuevo():SeekinOrd( Str( ::oOriginal():nNumLin ) + ::oOriginal():cCbaTil, "cLinCba" )

            dbPass( ::oOriginal():cAlias, ::oNuevo():cAlias, .t. )

            ::oNuevo():nUntTil := 1

         else

            ::oNuevo():nUntTil++

         end if
         
         //Si es un producto kit pasamos tambien los productos kit---------------

         if ::oOriginal():lKitArt

            ::oOriginal():GetStatus()

            ::oOriginal():OrdSetFocus( "lRecNum" )

            ::oOriginal():GoTop()

            while !::oOriginal():Eof()

               if ::oOriginal():nNumLin == nLinea .and. ::oOriginal():cCbaTil != cCodArt

                  if !::oNuevo():SeekinOrd( Str( ::oOriginal():nNumLin ) + ::oOriginal():cCbaTil, "cLinCba" )

                     dbPass( ::oOriginal():cAlias, ::oNuevo():cAlias, .t. )

                     ::oNuevo():nUntTil := ::oOriginal():nUntTil / nUnidades

                  else

                     ::oNuevo():nUntTil += ::oOriginal():nUntTil / nUnidades

                  end if

                  ::oOriginal():nUntTil -= ::oOriginal():nUntTil / nUnidades

               end if

               ::oOriginal():Skip()

            end while

            ::oOriginal():GoTop()

            while ( ::oOriginal():nNumLin == nLinea )
               ::oOriginal():Delete( .f. )
            end while

            ::oOriginal():OrdSetFocus( "nRecNum" )

            ::oOriginal():SetStatus()

         end if

         ::oOriginal():Delete(.f.)

      otherwise
      
         if !::oNuevo():SeekinOrd( Str( ::oOriginal():nNumLin ) + ::oOriginal():cCbaTil, "cLinCba" )

            dbPass( ::oOriginal():cAlias, ::oNuevo():cAlias, .t. )

         else

            ::oNuevo():nUntTil += ::oOriginal():nUntTil

         end if

         
         //Si es un producto kit pasamos tambien los productos kit---------------
         

         if ::oOriginal():lKitArt

            ::oOriginal():GetStatus()

            ::oOriginal():OrdSetFocus( "lRecNum" )

            ::oOriginal():GoTop()

            while !::oOriginal():Eof()

               if ::oOriginal():nNumLin == nLinea .and. ::oOriginal():cCbaTil != cCodArt

                  if !::oNuevo():SeekinOrd( Str( ::oOriginal():nNumLin ) + ::oOriginal():cCbaTil, "cLinCba" )

                     dbPass( ::oOriginal():cAlias, ::oNuevo():cAlias, .t. )

                  else

                     ::oNuevo():nUntTil += ::oOriginal():nUntTil

                  end if

                  ::oOriginal():nUntTil -= ::oOriginal():nUntTil

               end if

               ::oOriginal():Skip()

            end while

            ::oOriginal():GoTop()  

            while ::oOriginal():nNumLin == nLinea
               ::oOriginal():Delete(.f.)
            end while

            ::oOriginal():OrdSetFocus( "nRecNum" )

            ::oOriginal():SetStatus()

         end if

         ::oOriginal():Delete(.f.)   

      end case



   ::oOriginal():GoTop()

   ::oBrwOriginal:Refresh()
   ::oBrwNuevoTicket:Refresh()

Return ( Self )
*/
//---------------------------------------------------------------------------//

METHOD AddAllLine( oOrigen, oDestino ) class TpvUtilidadesMesa

	if empty( oOrigen:RecCount() )
		msgStop( "No hay lineas que pasar." )
		return ( Self )
	end if

	oOrigen:GoTop()
	while !oOrigen:Eof()
		
		::AddLinea( oOrigen, oDestino )

	end while

	::oBrwOriginal:Refresh()
	::oBrwNuevoTicket:Refresh()

Return ( Self )

//---------------------------------------------------------------------------//
/*
METHOD AddAllOrgToNew() Class TpvUtilidadesMesa

	::oOriginal():GoTop()
	while !::oOriginal():Eof()
		
		::AddLineOrgToNew()

	end while

	::oBrwOriginal:Refresh()
	::oBrwNuevoTicket:Refresh()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD AddAllNewToOrg() Class TpvUtilidadesMesa

	::oNuevo():GoTop()
	while !::oNuevo():Eof()
		
		::AddLineNewToOrg()

	end while

	::oBrwOriginal:Refresh()
	::oBrwNuevoTicket:Refresh()

Return ( Self )
*/
//---------------------------------------------------------------------------//
/*
METHOD AddLineNewToOrg() Class TpvUtilidadesMesa
/*
	local nLinea
	local cCodArt
	local nUnidades

	if valor:lDelTil
	  msgStop( "No se pueden pasar lineas eliminadas de una mesa a otra." )
	  return ( Self )
	end if   

	if valor:lKitChl
	  msgStop( "No se pueden pasar lineas pertenecientes a un escandallo." )
	  return ( Self )
	end if 

	if empty( valor:RecCount() )
	  msgStop( "No hay lineas que pasar." )
	  return ( Self )
	end if

	nLinea      := ::oNuevo():nNumLin
	cCodArt     := ::oNuevo():cCbaTil
	nUnidades   := ::oNuevo():nUntTil


   	if ::oNuevo():nUntTil > 0 .and. isInteger( ::oNuevo():nUntTil )

		::PasaLineaNewToOrg( 1 )

		::oNuevo():nUntTil-- 

		if ::oNuevo():nUntTil == 0

			::BorraLineaDestino()

		end if

	else
		::PasaLineaNewToOrg( ::oNuevo():nUntTil )

		::BorraLineaDestino()

	end if


  /* if !::oNuevo():lKitChl .and. !Empty( ::oNuevo():RecCount() )

      if ::oNuevo():nUntTil > 1

         ::oNuevo():nUntTil := ::oNuevo():nUntTil - 1

         if !::oOriginal():SeekinOrd( Str( ::oNuevo():nNumLin ) + ::oNuevo():cCbaTil, "cLinCba" )

            dbPass( ::oNuevo():cAlias, ::oOriginal():cAlias, .t. )
            ::oOriginal():nUntTil := 1

         else

            ::oOriginal():nUntTil++

         end if

         
         //Si es un producto kit pasamos tambien los productos kit---------------
         

         if ::oNuevo():lKitArt

            ::oNuevo():GetStatus()

            ::oNuevo():OrdSetFocus( "lRecNum" )

            ::oNuevo():GoTop()

               while !::oNuevo():Eof()

                  if ::oNuevo():nNumLin == nLinea .and. ::oNuevo():cCbaTil != cCodArt

                     if !::oOriginal():SeekinOrd( Str( ::oNuevo():nNumLin ) + ::oNuevo():cCbaTil, "cLinCba" )

                        dbPass( ::oNuevo():cAlias, ::oOriginal():cAlias, .t. )
                        ::oOriginal():nUntTil := ::oNuevo():nUntTil / nUnidades

                     else

                        ::oOriginal():nUntTil += ::oNuevo():nUntTil /nUnidades

                     end if

                     ::oNuevo():nUntTil -= ::oNuevo():nUntTil /nUnidades

                  end if

                  ::oNuevo():Skip()

               end while

            ::oNuevo():OrdSetFocus( "nRecNum" )   

            ::oNuevo():SetStatus()

         end if

      else

         if !::oOriginal():SeekinOrd( Str( ::oNuevo():nNumLin ) + ::oNuevo():cCbaTil, "cLinCba" )

            dbPass( ::oNuevo():cAlias, ::oOriginal():cAlias, .t. )
            ::oOriginal():nUntTil := 1

         else

            ::oOriginal():nUntTil++

         end if

         
         //Si es un producto kit pasamos tambien los productos kit---------------
         

         if ::oNuevo():lKitArt

            ::oNuevo():GetStatus()

            ::oNuevo():OrdSetFocus( "lRecNum" )

            ::oNuevo():GoTop()

            while !::oNuevo():Eof()

               if ::oNuevo():nNumLin == nLinea .and. ::oNuevo():cCbaTil != cCodArt

                  if !::oOriginal():SeekinOrd( Str( ::oNuevo():nNumLin ) + ::oNuevo():cCbaTil, "cLinCba" )

                     dbPass( ::oNuevo():cAlias, ::oNuevo():cAlias, .t. )
                     ::oOriginal():nUntTil := ::oNuevo():nUntTil / nUnidades

                  else

                     ::oOriginal():nUntTil += ::oNuevo():nUntTil /nUnidades

                  end if

                  ::oNuevo():nUntTil -= ::oNuevo():nUntTil /nUnidades

               end if

               ::oNuevo():Skip()

            end while

            ::oNuevo():GoTop()

            while ::oNuevo():nNumLin == nLinea
               ::oNuevo():Delete(.f.)
            end while

            ::oNuevo():OrdSetFocus( "nRecNum" )

            ::oNuevo():SetStatus()

         end if   

         ::oNuevo():Delete(.f.)

      end if

   end if


   ::oNuevo():GoTop()
   ::oBrwOriginal:Refresh()
   ::oBrwNuevoTicket:Refresh()

Return ( Self )
*/

//---------------------------------------------------------------------------//