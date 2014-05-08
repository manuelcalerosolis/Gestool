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
		METHOD StartDividirMesas()
		METHOD lInitCheckDividirMesas()

	METHOD CargaTemporalOrigen()
	METHOD CargaTemporalDestino()

	METHOD AceptarDividirMesa()

	METHOD GuardaTicketOrigen() INLINE 		( ::GuardaLineasTicketOrigen(), ::oSender:GuardaDocumento( .f. ) )
		METHOD GuardaLineasTicketOrigen()

	METHOD CreaNuevoTicket()

	METHOD AddLineOrgToNew()
	METHOD AddAllOrgToNew()

	METHOD AddLineNewToOrg()
	METHOD AddAllNewToOrg()

	METHOD lNuevoTicket() 	INLINE empty( ::oSelectedPunto:cTiket() ) .or. ( ::oSender:cNumeroTicket() == ::oSelectedPunto:cTiket() )

	METHOD GuardaTicketDestino()
		METHOD BorraLineasAnteriores()
		METHOD GuardaLineasTicketDestino()
		METHOD CreaNuevaCabecera()

//---------------------------------------------------------------------------//

   INLINE METHOD lShowEscandallosDivision()

      local cFocusOriginal
      local cFocusNuevoTicket

      cFocusOriginal      := Upper( ::oSender:oTemporalDivisionOriginal:OrdSetFocus() )

      if ( cFocusOriginal == Upper( "nRecNum" ) )
         ::oSender:oTemporalDivisionOriginal:OrdSetFocus( "lRecNum" )
      else
         ::oSender:oTemporalDivisionOriginal:OrdSetFocus( "nRecNum" )
      end if

      cFocusNuevoTicket   := Upper( ::oSender:oTemporalDivisionNuevoTicket:OrdSetFocus() )

      if ( cFocusNuevoTicket == Upper( "nRecNum" ) )
         ::oSender:oTemporalDivisionNuevoTicket:OrdSetFocus( "lRecNum" )
      else
         ::oSender:oTemporalDivisionNuevoTicket:OrdSetFocus( "nRecNum" )
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

      
      if !Empty( ::oSelectedPunto:dFecha )
         cInfo          += Dtoc( ::oSelectedPunto:dFecha ) + Space( 1 )
      end if

      if !Empty( ::oSelectedPunto:cHora )
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

	::oGrupoOriginal:SetFont( ::oFntFld )

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

	::oBrwOriginal:bClrStd                := {|| if( ::oSender:oTemporalDivisionOriginal:lDelTil, { CLR_BLACK, Rgb( 255, 0, 0 ) }, { CLR_BLACK, Rgb( 255, 255, 255 ) } ) }
	::oBrwOriginal:bClrSel                := {|| if( ::oSender:oTemporalDivisionOriginal:lDelTil, { CLR_BLACK, Rgb( 255, 0, 0 ) }, { CLR_BLACK, Rgb( 229, 229, 229 ) } ) }
	::oBrwOriginal:bClrSelFocus           := {|| if( ::oSender:oTemporalDivisionOriginal:lDelTil, { CLR_BLACK, Rgb( 255, 128, 128 ) }, { CLR_BLACK, Rgb( 167, 205, 240 ) } ) }

	//::oBrwOriginal:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
	//::oBrwOriginal:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

	::oBrwOriginal:lRecordSelector        := .f.
	::oBrwOriginal:lHScroll               := .f. 
	::oBrwOriginal:lVScroll               := .f.

	::oBrwOriginal:nMarqueeStyle          := MARQSTYLE_HIGHLROW
	::oBrwOriginal:nRowHeight             := 36
	::oBrwOriginal:cName                  := "Tactil.Lineas.Originales" 
	::oBrwOriginal:lFooter                := .t.

	::oBrwOriginal:SetFont( ::oFntBrw )

	::oSender:oTemporalDivisionOriginal:SetBrowse( ::oBrwOriginal )

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

	TButtonBmp():ReDefine( 300, {|| ::AddLineOrgToNew() }, ::oDlg, , , .f., , , , .f., "Navigate_right" )
	TButtonBmp():ReDefine( 310, {|| ::AddLineNewToOrg() }, ::oDlg, , , .f., , , , .f., "Navigate_left" ) 
	TButtonBmp():ReDefine( 360, {|| ::AddAllOrgToNew() }, ::oDlg, , , .f., , , , .f., "Navigate_right2" )
	TButtonBmp():ReDefine( 370, {|| ::AddAllNewToOrg() }, ::oDlg, , , .f., , , , .f., "Navigate_left2" ) 

	//Browse de Lineas para el Nuevo Ticket---------------------------------------

	REDEFINE GROUP ::oGrupoNuevo ID 200 OF ::oDlg TRANSPARENT
	  
	::oGrupoNuevo:SetFont( ::oFntFld )

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

	::oBrwNuevoTicket:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
	::oBrwNuevoTicket:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

	::oBrwNuevoTicket:lRecordSelector        := .f.
	::oBrwNuevoTicket:lHScroll               := .f.
	::oBrwNuevoTicket:lVScroll               := .f.

	::oBrwNuevoTicket:nMarqueeStyle          := MARQSTYLE_HIGHLROW
	::oBrwNuevoTicket:nRowHeight             := 36
	::oBrwNuevoTicket:cName                  := "Tactil.Lineas.NuevoTicket"
	::oBrwNuevoTicket:lFooter                := .t.

	::oBrwNuevoTicket:SetFont( ::oFntBrw )

	::oSender:oTemporalDivisionNuevoTicket:SetBrowse( ::oBrwNuevoTicket )

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

	//Activamos el diálogo--------------------------------------------------------

	::oDlg:bStart := {|| ::StartDividirMesas() }

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


//---------------------------------------------------------------------------//

METHOD CargaTemporalOrigen() class TpvUtilidadesMesa

   ::oSender:oTemporalDivisionOriginal:Zap()

   ::oSender:oTemporalLinea:GetStatus()

   ::oSender:oTemporalLinea:OrdSetFocus( "lRecNum" )

   ::oSender:oTemporalLinea:GoTop()  
   while !::oSender:oTemporalLinea:Eof()

      dbPass( ::oSender:oTemporalLinea:cAlias, ::oSender:oTemporalDivisionOriginal:cAlias, .t. )

      ::oSender:oTemporalLinea:Skip()

   end while

   ::oSender:oTemporalLinea:SetStatus()
   ::oSender:oTemporalDivisionOriginal:GoTop()
 
Return ( Self )

//---------------------------------------------------------------------------//

METHOD CargaTemporalDestino() class TpvUtilidadesMesa

	local cNumeroTicket 	:= ::oSelectedPunto:cTiket()

   	::oSender:oTemporalDivisionNuevoTicket:Zap()

   	if !::lNuevoTicket()

   		::oSender:oTiketLinea:GetStatus()

   		::oSender:oTiketLinea:OrdSetFocus( "cNumTil" )

   		::oSender:oTiketLinea:Seek( cNumeroTicket )
   		while ( ::oSender:oTiketLinea:cSerTil + ::oSender:oTiketLinea:cNumTil + ::oSender:oTiketLinea:cSufTil == cNumeroTicket ) .and. !::oSender:oTiketLinea:Eof()

			dbPass( ::oSender:oTiketLinea:cAlias, ::oSender:oTemporalDivisionNuevoTicket:cAlias, .t. )
   			
   			::oSender:oTiketLinea:Skip()

   		end while

   		::oSender:oTiketLinea:SetStatus()
   		
   		::oSender:oTemporalDivisionNuevoTicket:GoTop()

   	end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD AceptarDividirMesa() Class TpvUtilidadesMesa

	local lDeleteOriginal 	:= .f.

	::cCodSala 				:= ::oRestaurante():cSelectedSala
	::cPntVenta 			:= ::oRestaurante():cSelectedPunto

	// Preguntamos si el ticket de origen se va a quedar vacio--------------------------

	if 	( ::oSender:oTemporalDivisionOriginal:OrdKeyCount() == 0 )

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

	if ( ::oSender:oTemporalDivisionNuevoTicket:OrdKeyCount() == 0 ) .and. ( !::lNuevoTicket() )

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

	// Pasar la temporal--------------------------------------------------------

 	::GuardaTicketOrigen()

 	// Guardamos el ticket de destino-------------------------------------------

 	::GuardaTicketDestino()

 	::oSender:CargaDocumento( ::cTiketDestino )

   	::oDlg:Enable()
   	::oDlg:End( IDOK )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD GuardaLineasTicketOrigen() Class TpvUtilidadesMesa

   ::oSender:oTemporalLinea:Zap()

   ::oSender:oTemporalDivisionOriginal:OrdSetFocus( "lRecNum" )

   ::oSender:oTemporalDivisionOriginal:GoTop()
   while !::oSender:oTemporalDivisionOriginal:Eof()

      dbPass( ::oSender:oTemporalDivisionOriginal:cAlias, ::oSender:oTemporalLinea:cAlias, .t. )

      ::oSender:oTemporalDivisionOriginal:Skip()

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

		::oSender:oTemporalDivisionNuevoTicket:GoTop()
      	while !::oSender:oTemporalDivisionNuevoTicket:Eof()

         	appendPass( ::oSender:oTemporalDivisionNuevoTicket:cAlias,;
                     	::oSender:oTiketLinea:cAlias,;
						{ 	"cSerTil" => ::oSender:oTiketCabecera:FieldGetByName( "cSerTik" ),;
                        	"cNumTil" => ::oSender:oTiketCabecera:FieldGetByName( "cNumTik" ),;
                        	"cSufTil" => ::oSender:oTiketCabecera:FieldGetByName( "cSufTik" ),;
                        	"dTipTil" => ::oSender:oTiketCabecera:FieldGetByName( "cTipTik" ),;
                        	"dFecTik" => ::oSender:oTiketCabecera:FieldGetByName( "dFecTik" ) } )

         	::oSender:oTemporalDivisionNuevoTicket:Skip()

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
      
      ::oSender:oTemporalDivisionNuevoTicket:GoTop()

      while !::oSender:oTemporalDivisionNuevoTicket:Eof()

         appendPass( ::oSender:oTemporalDivisionNuevoTicket:cAlias,;
                     ::oSender:oTiketLinea:cAlias,;
                     {  "cSerTil" => ::oSender:oTiketCabecera:cSerTik,;
                        "cNumTil" => ::oSender:oTiketCabecera:cNumTik,;
                        "cSufTil" => ::oSender:oTiketCabecera:cSufTik,;
                        "dTipTil" => ::oSender:oTiketCabecera:cTipTik,;
                        "dFecTik" => ::oSender:oTiketCabecera:dFecTik } )

         ::oSender:oTemporalDivisionNuevoTicket:Skip()

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

METHOD AddLineOrgToNew() Class TpvUtilidadesMesa

   local nLinea
   local cCodArt
   local nUnidades

   if ::oSender:oTemporalDivisionOriginal:lDelTil
      msgStop( "No se pueden pasar lineas eliminadas de una mesa a otra" )
      return ( Self )
   end if   
   
   nLinea      := ::oSender:oTemporalDivisionOriginal:nNumLin
   cCodArt     := ::oSender:oTemporalDivisionOriginal:cCbaTil
   nUnidades   := ::oSender:oTemporalDivisionOriginal:nUntTil

   if !::oSender:oTemporalDivisionOriginal:lKitChl .and. !Empty( ::oSender:oTemporalDivisionOriginal:RecCount() )

      do case
      case ::oSender:oTemporalDivisionOriginal:nUntTil > 1

         ::oSender:oTemporalDivisionOriginal:nUntTil := ::oSender:oTemporalDivisionOriginal:nUntTil - 1

         if !::oSender:oTemporalDivisionNuevoTicket:SeekinOrd( Str( ::oSender:oTemporalDivisionOriginal:nNumLin ) + ::oSender:oTemporalDivisionOriginal:cCbaTil, "cLinCba" )

            dbPass( ::oSender:oTemporalDivisionOriginal:cAlias, ::oSender:oTemporalDivisionNuevoTicket:cAlias, .t. )
            ::oSender:oTemporalDivisionNuevoTicket:nUntTil := 1

         else

            ::oSender:oTemporalDivisionNuevoTicket:nUntTil++

         end if  

         
         //Si es un producto kit pasamos tambien los productos kit---------------
         

         if ::oSender:oTemporalDivisionOriginal:lKitArt

            ::oSender:oTemporalDivisionOriginal:GetStatus()

            ::oSender:oTemporalDivisionOriginal:OrdSetFocus( "lRecNum" )

            ::oSender:oTemporalDivisionOriginal:GoTop()

               while !::oSender:oTemporalDivisionOriginal:Eof()

                  if ::oSender:oTemporalDivisionOriginal:nNumLin == nLinea .and. ::oSender:oTemporalDivisionOriginal:cCbaTil != cCodArt

                     if !::oSender:oTemporalDivisionNuevoTicket:SeekinOrd( Str( ::oSender:oTemporalDivisionOriginal:nNumLin ) + ::oSender:oTemporalDivisionOriginal:cCbaTil, "cLinCba" )

                        dbPass( ::oSender:oTemporalDivisionOriginal:cAlias, ::oSender:oTemporalDivisionNuevoTicket:cAlias, .t. )
                        ::oSender:oTemporalDivisionNuevoTicket:nUntTil := ::oSender:oTemporalDivisionOriginal:nUntTil / nUnidades

                     else

                        ::oSender:oTemporalDivisionNuevoTicket:nUntTil += ::oSender:oTemporalDivisionOriginal:nUntTil /nUnidades

                     end if

                     ::oSender:oTemporalDivisionOriginal:nUntTil -= ::oSender:oTemporalDivisionOriginal:nUntTil /nUnidades

                  end if

                  ::oSender:oTemporalDivisionOriginal:Skip()

               end while

            ::oSender:oTemporalDivisionOriginal:OrdSetFocus( "nRecNum" )   

            ::oSender:oTemporalDivisionOriginal:SetStatus()

         end if

      case ::oSender:oTemporalDivisionOriginal:nUntTil == 0

         if !::oSender:oTemporalDivisionNuevoTicket:SeekinOrd( Str( ::oSender:oTemporalDivisionOriginal:nNumLin ) + ::oSender:oTemporalDivisionOriginal:cCbaTil, "cLinCba" )

            dbPass( ::oSender:oTemporalDivisionOriginal:cAlias, ::oSender:oTemporalDivisionNuevoTicket:cAlias, .t. )
            ::oSender:oTemporalDivisionNuevoTicket:nUntTil := 1

         else

            ::oSender:oTemporalDivisionNuevoTicket:nUntTil++

         end if

         
         //Si es un producto kit pasamos tambien los productos kit---------------
         

         if ::oSender:oTemporalDivisionOriginal:lKitArt

            ::oSender:oTemporalDivisionOriginal:GetStatus()

            ::oSender:oTemporalDivisionOriginal:OrdSetFocus( "lRecNum" )

            ::oSender:oTemporalDivisionOriginal:GoTop()

            while !::oSender:oTemporalDivisionOriginal:Eof()

               if ::oSender:oTemporalDivisionOriginal:nNumLin == nLinea .and. ::oSender:oTemporalDivisionOriginal:cCbaTil != cCodArt

                  if !::oSender:oTemporalDivisionNuevoTicket:SeekinOrd( Str( ::oSender:oTemporalDivisionOriginal:nNumLin ) + ::oSender:oTemporalDivisionOriginal:cCbaTil, "cLinCba" )

                     dbPass( ::oSender:oTemporalDivisionOriginal:cAlias, ::oSender:oTemporalDivisionNuevoTicket:cAlias, .t. )
                     ::oSender:oTemporalDivisionNuevoTicket:nUntTil := ::oSender:oTemporalDivisionOriginal:nUntTil / nUnidades

                  else

                     ::oSender:oTemporalDivisionNuevoTicket:nUntTil += ::oSender:oTemporalDivisionOriginal:nUntTil /nUnidades

                  end if

                  ::oSender:oTemporalDivisionOriginal:nUntTil -= ::oSender:oTemporalDivisionOriginal:nUntTil /nUnidades

               end if

               ::oSender:oTemporalDivisionOriginal:Skip()

            end while

            ::oSender:oTemporalDivisionOriginal:GoTop()

            while ( ::oSender:oTemporalDivisionOriginal:nNumLin == nLinea )
               ::oSender:oTemporalDivisionOriginal:Delete( .f. )
            end while

            ::oSender:oTemporalDivisionOriginal:OrdSetFocus( "nRecNum" )

            ::oSender:oTemporalDivisionOriginal:SetStatus()

         end if

         ::oSender:oTemporalDivisionOriginal:Delete(.f.)

      otherwise
      
         if !::oSender:oTemporalDivisionNuevoTicket:SeekinOrd( Str( ::oSender:oTemporalDivisionOriginal:nNumLin ) + ::oSender:oTemporalDivisionOriginal:cCbaTil, "cLinCba" )

            dbPass( ::oSender:oTemporalDivisionOriginal:cAlias, ::oSender:oTemporalDivisionNuevoTicket:cAlias, .t. )

         else

            ::oSender:oTemporalDivisionNuevoTicket:nUntTil += ::oSender:oTemporalDivisionOriginal:nUntTil

         end if

         
         //Si es un producto kit pasamos tambien los productos kit---------------
         

         if ::oSender:oTemporalDivisionOriginal:lKitArt

            ::oSender:oTemporalDivisionOriginal:GetStatus()

            ::oSender:oTemporalDivisionOriginal:OrdSetFocus( "lRecNum" )

            ::oSender:oTemporalDivisionOriginal:GoTop()

            while !::oSender:oTemporalDivisionOriginal:Eof()

               if ::oSender:oTemporalDivisionOriginal:nNumLin == nLinea .and. ::oSender:oTemporalDivisionOriginal:cCbaTil != cCodArt

                  if !::oSender:oTemporalDivisionNuevoTicket:SeekinOrd( Str( ::oSender:oTemporalDivisionOriginal:nNumLin ) + ::oSender:oTemporalDivisionOriginal:cCbaTil, "cLinCba" )

                     dbPass( ::oSender:oTemporalDivisionOriginal:cAlias, ::oSender:oTemporalDivisionNuevoTicket:cAlias, .t. )

                  else

                     ::oSender:oTemporalDivisionNuevoTicket:nUntTil += ::oSender:oTemporalDivisionOriginal:nUntTil

                  end if

                  ::oSender:oTemporalDivisionOriginal:nUntTil -= ::oSender:oTemporalDivisionOriginal:nUntTil

               end if

               ::oSender:oTemporalDivisionOriginal:Skip()

            end while

            ::oSender:oTemporalDivisionOriginal:GoTop()  

            while ::oSender:oTemporalDivisionOriginal:nNumLin == nLinea
               ::oSender:oTemporalDivisionOriginal:Delete(.f.)
            end while

            ::oSender:oTemporalDivisionOriginal:OrdSetFocus( "nRecNum" )

            ::oSender:oTemporalDivisionOriginal:SetStatus()

         end if

         ::oSender:oTemporalDivisionOriginal:Delete(.f.)   

      end case

   end if

   ::oSender:oTemporalDivisionOriginal:GoTop()

   ::oBrwOriginal:Refresh()
   ::oBrwNuevoTicket:Refresh()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD AddAllOrgToNew() Class TpvUtilidadesMesa

	::oSender:oTemporalDivisionOriginal:GoTop()
	while !::oSender:oTemporalDivisionOriginal:Eof()
		
		::AddLineOrgToNew()

	end while

	::oBrwOriginal:Refresh()
	::oBrwNuevoTicket:Refresh()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD AddAllNewToOrg() Class TpvUtilidadesMesa

	::oSender:oTemporalDivisionNuevoTicket:GoTop()
	while !::oSender:oTemporalDivisionNuevoTicket:Eof()
		
		::AddLineNewToOrg()

	end while

	::oBrwOriginal:Refresh()
	::oBrwNuevoTicket:Refresh()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD AddLineNewToOrg() Class TpvUtilidadesMesa

   local nLinea
   local cCodArt
   local nUnidades

   nLinea      := ::oSender:oTemporalDivisionNuevoTicket:nNumLin
   cCodArt     := ::oSender:oTemporalDivisionNuevoTicket:cCbaTil
   nUnidades   := ::oSender:oTemporalDivisionNuevoTicket:nUntTil

   if !::oSender:oTemporalDivisionNuevoTicket:lKitChl .and. !Empty( ::oSender:oTemporalDivisionNuevoTicket:RecCount() )

      if ::oSender:oTemporalDivisionNuevoTicket:nUntTil > 1

         ::oSender:oTemporalDivisionNuevoTicket:nUntTil := ::oSender:oTemporalDivisionNuevoTicket:nUntTil - 1

         if !::oSender:oTemporalDivisionOriginal:SeekinOrd( Str( ::oSender:oTemporalDivisionNuevoTicket:nNumLin ) + ::oSender:oTemporalDivisionNuevoTicket:cCbaTil, "cLinCba" )

            dbPass( ::oSender:oTemporalDivisionNuevoTicket:cAlias, ::oSender:oTemporalDivisionOriginal:cAlias, .t. )
            ::oSender:oTemporalDivisionOriginal:nUntTil := 1

         else

            ::oSender:oTemporalDivisionOriginal:nUntTil++

         end if

         
         //Si es un producto kit pasamos tambien los productos kit---------------
         

         if ::oSender:oTemporalDivisionNuevoTicket:lKitArt

            ::oSender:oTemporalDivisionNuevoTicket:GetStatus()

            ::oSender:oTemporalDivisionNuevoTicket:OrdSetFocus( "lRecNum" )

            ::oSender:oTemporalDivisionNuevoTicket:GoTop()

               while !::oSender:oTemporalDivisionNuevoTicket:Eof()

                  if ::oSender:oTemporalDivisionNuevoTicket:nNumLin == nLinea .and. ::oSender:oTemporalDivisionNuevoTicket:cCbaTil != cCodArt

                     if !::oSender:oTemporalDivisionOriginal:SeekinOrd( Str( ::oSender:oTemporalDivisionNuevoTicket:nNumLin ) + ::oSender:oTemporalDivisionNuevoTicket:cCbaTil, "cLinCba" )

                        dbPass( ::oSender:oTemporalDivisionNuevoTicket:cAlias, ::oSender:oTemporalDivisionOriginal:cAlias, .t. )
                        ::oSender:oTemporalDivisionOriginal:nUntTil := ::oSender:oTemporalDivisionNuevoTicket:nUntTil / nUnidades

                     else

                        ::oSender:oTemporalDivisionOriginal:nUntTil += ::oSender:oTemporalDivisionNuevoTicket:nUntTil /nUnidades

                     end if

                     ::oSender:oTemporalDivisionNuevoTicket:nUntTil -= ::oSender:oTemporalDivisionNuevoTicket:nUntTil /nUnidades

                  end if

                  ::oSender:oTemporalDivisionNuevoTicket:Skip()

               end while

            ::oSender:oTemporalDivisionNuevoTicket:OrdSetFocus( "nRecNum" )   

            ::oSender:oTemporalDivisionNuevoTicket:SetStatus()

         end if

      else

         if !::oSender:oTemporalDivisionOriginal:SeekinOrd( Str( ::oSender:oTemporalDivisionNuevoTicket:nNumLin ) + ::oSender:oTemporalDivisionNuevoTicket:cCbaTil, "cLinCba" )

            dbPass( ::oSender:oTemporalDivisionNuevoTicket:cAlias, ::oSender:oTemporalDivisionOriginal:cAlias, .t. )
            ::oSender:oTemporalDivisionOriginal:nUntTil := 1

         else

            ::oSender:oTemporalDivisionOriginal:nUntTil++

         end if

         
         //Si es un producto kit pasamos tambien los productos kit---------------
         

         if ::oSender:oTemporalDivisionNuevoTicket:lKitArt

            ::oSender:oTemporalDivisionNuevoTicket:GetStatus()

            ::oSender:oTemporalDivisionNuevoTicket:OrdSetFocus( "lRecNum" )

            ::oSender:oTemporalDivisionNuevoTicket:GoTop()

            while !::oSender:oTemporalDivisionNuevoTicket:Eof()

               if ::oSender:oTemporalDivisionNuevoTicket:nNumLin == nLinea .and. ::oSender:oTemporalDivisionNuevoTicket:cCbaTil != cCodArt

                  if !::oSender:oTemporalDivisionOriginal:SeekinOrd( Str( ::oSender:oTemporalDivisionNuevoTicket:nNumLin ) + ::oSender:oTemporalDivisionNuevoTicket:cCbaTil, "cLinCba" )

                     dbPass( ::oSender:oTemporalDivisionNuevoTicket:cAlias, ::oSender:oTemporalDivisionNuevoTicket:cAlias, .t. )
                     ::oSender:oTemporalDivisionOriginal:nUntTil := ::oSender:oTemporalDivisionNuevoTicket:nUntTil / nUnidades

                  else

                     ::oSender:oTemporalDivisionOriginal:nUntTil += ::oSender:oTemporalDivisionNuevoTicket:nUntTil /nUnidades

                  end if

                  ::oSender:oTemporalDivisionNuevoTicket:nUntTil -= ::oSender:oTemporalDivisionNuevoTicket:nUntTil /nUnidades

               end if

               ::oSender:oTemporalDivisionNuevoTicket:Skip()

            end while

            ::oSender:oTemporalDivisionNuevoTicket:GoTop()

            while ::oSender:oTemporalDivisionNuevoTicket:nNumLin == nLinea
               ::oSender:oTemporalDivisionNuevoTicket:Delete(.f.)
            end while

            ::oSender:oTemporalDivisionNuevoTicket:OrdSetFocus( "nRecNum" )

            ::oSender:oTemporalDivisionNuevoTicket:SetStatus()

         end if   

         ::oSender:oTemporalDivisionNuevoTicket:Delete(.f.)

      end if

   end if

   ::oSender:oTemporalDivisionNuevoTicket:GoTop()
   ::oBrwOriginal:Refresh()
   ::oBrwNuevoTicket:Refresh()

Return ( Self )

//---------------------------------------------------------------------------//