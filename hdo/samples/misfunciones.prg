//------------------------------------------------------------------------------
// Proyecto: Miscelania
// Fichero: misFunciones.prg
// Descripcion: Funciones utiles de apoyo para modo texto
// Autor: Manu Exposito 2015-17
// Fecha: 15/01/2017
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Convierte un valor en cadena y si es nulo le asigna un valor por defecto

function myValToStr( xVal, cDefault )

    local cRet, cType

    switch valtype( xVal )
    case 'U'
        cRet := if( valtype( cDefault ) == 'C', cDefault, "" )
        exit
    case 'N'
        cRet := hb_ntos( xVal )
        exit
    otherwise
        cRet := hb_valtostr( xVal )
    end switch

return cRet

//------------------------------------------------------------------------------
// Muestra un mensage por pantalla con un titulo

procedure msg( cMsg, cTitle )

    cMsg := myValToStr( cMsg )
    cTitle := myValToStr( cTitle, "Atencion" )

    alert( cTitle + ';' + replicate( "_", len( cTitle ) + 2 ) + ";;;" + cMsg )

return

//------------------------------------------------------------------------------
// Muestra un mensage por pantalla con un titulo

function msgSN( cMsg, cTitle )

    cMsg := myValToStr( cMsg )
    cTitle := myValToStr( cTitle, "Elija" )

return alert( cTitle + ';' + replicate( "_", len( cTitle ) + 2 ) + ";;;" + cMsg, { "Si", "No" } ) == 1

//------------------------------------------------------------------------------
// Muestra el contenido de "a" en un Alert() con titulo "t"
// "a" puede ser un array

procedure muestra( a, cTitle )

    local n, i, k, v
	local c := ""

    if valtype( a ) == 'A'
        i := len( a )
        if i > 0
            for n := 1 to i
                if valtype( a[ n ] ) == 'A'
                    muestra( a[ n ], cTitle )
                else
                    c += myValToStr( a[ n ] ) + ";"
                endif
            next
        endif
    elseif ValType( a ) == 'H'
		v := AClone( HB_HValues( a ) )
		k := AClone( HB_HKeys( a ) )
		i := Len( a )
		for n := 1 to i
			c += myValToStr( k[ n ] ) + " => " + myValToStr( v[ n ] ) + ";"
		next
	else
        c := a
    endif

    msg( c, cTitle )

return

//------------------------------------------------------------------------------
// Espera los segundos pasados o 100 por defecto

procedure espera( nSec, cTxt )

    if valtype( nSec ) != 'N'
        nSec := 100
    endif

    if ValType( cTxt ) != 'C'
        cTxt := "seguir automaticamente..."
    endif

    ?
    ? "<ENTER> o espere " + hb_ntos( nSec ) + " segundos para " + cTxt

    inkey( nSec )

return

//------------------------------------------------------------------------------
// Browse para el objeto Cursor local (hashCursor y memCursor)

procedure miBrwCursor( oCur, x, y, h, w )

    local i, oBrw

	if ValType( oCur ) == 'O'
		if ValType( x ) != 'N'
			x := 0
		endif
		if ValType( y ) != 'N'
			y := 0
		endif
		if ValType( h ) != 'N'
			h := maxrow()
		endif
		if ValType( w ) != 'N'
			w := maxcol()
		endif
		
		oBrw := tbrowsenew( x + 1, y + 1, h, w - 1 )
		hb_dispbox( x, y, h, w, hb_utf8tostrbox( "┌─┐│┘─└│ " ), "W+/B, N/BG" )

		oCur:GoTop()

		oBrw:colorSpec     := "W+/B, N/BG"
		oBrw:ColSep        := hb_utf8tostrbox( "│" )
		oBrw:HeadSep       := hb_utf8tostrbox( "┼─" )
		oBrw:FootSep       := hb_utf8tostrbox( "┴─" )
		oBrw:GoTopBlock    := {|| oCur:goTop() }
		oBrw:GoBottomBlock := {|| oCur:goBottom() }
		oBrw:SkipBlock     := {| nSkip | oCur:skipper( nSkip ) }

		for i := 1 to oCur:fieldCount()
			oBrw:AddColumn( tbcolumnnew( oCur:fieldname( i ), genCB( oCur, i ) ) )
		next

		oBrw:forceStable()

		while oBrw:applyKey( inkey( 0 ) ) != -1
			oBrw:forceStable()
		enddo
	else
		msg( "El primer parametro debe ser un objeto de tipo cursor", "Atencion en el Browse" )
	endif

return

//------------------------------------------------------------------------------
// Genera el codeblock para las columnas del Browuse

static function genCB( oCur, i ) ; return( {|| oCur:getValueByPos( i ) } )

//------------------------------------------------------------------------------
