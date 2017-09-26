//---------------------------------------------------------------------------//
//  AUTOR.....: Manuel Expósito Suárez   Soft4U 2002-2010                    //
//  eMail.....: manuexposito@gmail.com                                       //
//  CLASE.....: TMSCursor                                                    //
//  FECHA MOD.: 15/11/2010                                                   //
//  VERSION...: 6.00                                                         //
//  PROPOSITO.: Gestión de cursores locales                                  //
//---------------------------------------------------------------------------//

#include "eagle1.ch"

//---------------------------------------------------------------------------//

CLASS TMSCursor FROM TMSDataSet

    DATA Cursor                 // Recipiente del resutado (Area DBF o array)
    DATA aStruct INIT {}        // Estructura de la consulta
    DATA lFreeResult INIT .f.   // Cierre resultado al cargarlo en cursor
    DATA lNeedReleaseResult INIT .f.    // Se necesita liberar resultado original

    METHOD Create( oDbCon, cStatement, lFree ) CONSTRUCTOR
    METHOD Open( cStatement, lFree )
    METHOD QueryFromParam( cTable, aCol, cWhere, cGroupBy, ;
                           cHaving, uOrderBy, xLimit, lFree )

    METHOD First()
    METHOD Last()
    METHOD MoveBy( nSkip )
    METHOD Prior()
    METHOD Next()

    METHOD Load()
    MESSAGE GetRow() METHOD Load()

    METHOD FreeResult() // Libera el resultado del cliente MySQL
    METHOD Free()       // Libera el objeto cursor local (Self)

    METHOD FieldName( nFld )
    METHOD FieldType( nFld )
    METHOD FieldLen( nFld )
    METHOD FieldDec( nFld )
    METHOD FieldPos( cFld )
    METHOD FieldGetByName( cFName )

    METHOD FieldCount()
    MESSAGE FCount() METHOD FieldCount()

    //-----------------------------------------
    // Se desarrolla en las clases hijas:

    METHOD RecCount() VIRTUAL
    METHOD LastRec() VIRTUAL
    METHOD FieldGet( nFld ) VIRTUAL
    METHOD FillCursor() VIRTUAL
    METHOD GoTo( n ) VIRTUAL
    METHOD GoTop() VIRTUAL
    METHOD GoBottom() VIRTUAL
    METHOD Skip( n ) VIRTUAL
    METHOD Skipper() VIRTUAL

    METHOD EOF() VIRTUAL
    METHOD BOF() VIRTUAL
    METHOD RecNo() VIRTUAL

ENDCLASS

//---------------------------------------------------------------------------//
// Crea y abre un cursor local

METHOD Create( oDbCon, cStatement, lFree ) CLASS TMSCursor

    ::New( oDbCon )

    ::Open( cStatement, lFree )

return( Self )

//---------------------------------------------------------------------------//
// Abre el cursor

METHOD Open( cStatement, lFree ) CLASS TMSCursor

    ::FreeResult()
    ::lOpened := .f.

    if ::lInit
        BYNAME cStatement TYPE "C"

        if empty( ::cStatement )
            ::oError:Say( "No hay ninguna sentencia para ejecutar...", .f. )
        else
            if ::lOpened := E1UseResult( ::hMySQL, ::cStatement )
                ::aStruct := E1DbStruct( ::hMySQL )
                ::Cursor := ::FillCursor()
                ::lNeedReleaseResult := .t.
                ::GoTop()
            else
                ::oError:Show( .f., "Error al abrir el resultado de la consulta" )
                lFree := .t.
            endif
        endif

        if ValType( lFree ) == "L"
            ::lFreeResult := lFree
        endif

        if ::lFreeResult
            ::FreeResult()
        endif
    endif

return( ::lOpened )

//---------------------------------------------------------------------------//
// Genera una sentecia SQL a partir de los parametros pasados

METHOD QueryFromParam( cTable, aCol, cWhere, cGroupBy, ;
                       cHaving, uOrderBy, xLimit, lFree ) CLASS TMSCursor

    local cType, n, i
    local cStmt := 'SELECT '

    if ValType( aCol ) == "A" .and. !empty( aCol )
        i := len( aCol ) - 1
        FOR n := 1 TO i
            cStmt += aCol[ n ] + ', '
        NEXT
        cStmt += aCol[ i + 1 ]
    else
        cStmt += '*'
    endif

    cStmt += ' FROM ' + cTable

    cStmt += if( ValType( cWhere ) == "C", '', ' WHERE ' + cWhere )
    cStmt += if( ValType( cGroupBy ) == "C", '', ' GROUP BY ' + cGroupBy )
    cStmt += if( ValType( cHaving ) == "C", '', ' HAVING ' + cHaving )

    cType := ValType( xLimit )
    if cType == "N"
        cStmt += ' LIMIT ' + StrNum( xLimit )
    elseif cType == "C"
        cStmt += ' LIMIT ' + xLimit
    endif

    cType := ValType( uOrderBy )
    if cType $ "CN"
        cStmt += ' ORDER BY '
        if cType == "N"
            uOrderBy := StrNum( uOrderBy )
        endif
        cStmt += uOrderBy
    endif

return( ::Open( cStmt, lFree ) )

//---------------------------------------------------------------------------//
// Devuelve un array con los valores de la fila actual

METHOD Load() CLASS TMSCursor

    local nLen := ::FieldCount()
    local aBuffer := Array( nLen )
    local n

    FOR n := 1 TO nLen
        aBuffer[ n ] := ::FieldGet( n )
    NEXT

return( aBuffer )

//---------------------------------------------------------------------------//
// Va a la primera fila

METHOD First() CLASS TMSCursor
return( ::GoTop() )

//---------------------------------------------------------------------------//
// Va al ultima fila

METHOD Last() CLASS TMSCursor
return( ::GoBottom() )

//---------------------------------------------------------------------------//
// Mueve el puntero n filas

METHOD MoveBy( n ) CLASS TMSCursor
return( ::Skip( n ) )

//---------------------------------------------------------------------------//
// mueve el puntero a la fila anterior

METHOD Prior() CLASS TMSCursor
return( ::Skip( -1 ) )

//---------------------------------------------------------------------------//
// Mueve el puntero a la siguiente fila

METHOD Next() CLASS TMSCursor
return( ::Skip( 1 ) )

//---------------------------------------------------------------------------//
// Libera el resultado de MySQL

PROCEDURE FreeResult() CLASS TMSCursor

    if ::lNeedReleaseResult
        E1FreeResult( ::hMySQL )
        ::lNeedReleaseResult := .f.
    endif

return

//---------------------------------------------------------------------------//
// Devuelve el nombre de la columna especificada

METHOD FieldName( nFld ) CLASS TMSCursor
return( ::aStruct[ nFld, DBS_NAME ] )

//---------------------------------------------------------------------------//
// Devuelve el tipo de la columna especificada

METHOD FieldType( nFld ) CLASS TMSCursor
return( ::aStruct[ nFld, DBS_TYPE ] )

//---------------------------------------------------------------------------//
// Devuelve el ancho de la columna especificada

METHOD FieldLen( nFld ) CLASS TMSCursor
return( ::aStruct[ nFld, DBS_LEN ] )

//---------------------------------------------------------------------------//
// Devuelve los decimales  de la columna especificada

METHOD FieldDec( nFld ) CLASS TMSCursor
return( ::aStruct[ nFld, DBS_DEC ] )

//---------------------------------------------------------------------------//
// Devuelve la posiscion de la columna especificada

METHOD FieldPos( cFld ) CLASS TMSCursor

    local n, nPos, nLen

    if ValType( cFld ) == "C"

        nLen := ::FCount()
        cFld := upper( cFld )

        for n := 1 to nLen
            if cFld == ::aStruct[ n, DBS_NAME ]
                nPos := n
            endif
        next
    else
        nPos := 0
    endif

return( nPos )

//---------------------------------------------------------------------------//
// Devuelve el numero de columnas del cursor

METHOD FieldCount() CLASS TMSCursor
return( len( ::aStruct ) )

//---------------------------------------------------------------------------//
// Destruye el objeto

PROCEDURE Free() CLASS TMSCursor

    if ::lNeedReleaseResult
        ::FreeResult()
    endif

    Super:Free()

return

//---------------------------------------------------------------------------//
// Obtiene el valor de una columna por el nombre

METHOD FieldGetByName( cFName ) CLASS TMSCursor
return( ::FieldGet( ::FieldPos( cFName ) ) )

//---------------------------------------------------------------------------//

