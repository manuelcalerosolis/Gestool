//---------------------------------------------------------------------------//
//  AUTOR.....: Manuel Expósito Suárez   Soft4U 2002-2010                    //
//  eMail.....: manuexposito@gmail.com                                       //
//  CLASE.....: TMSQuery                                                     //
//  FECHA MOD.: 15/11/2010                                                   //
//  VERSION...: 6.00                                                         //
//  PROPOSITO.: Gestión de peticiones generales en MySQL                     //
//---------------------------------------------------------------------------//

#include "eagle1.ch"

//---------------------------------------------------------------------------//

CLASS TMSQuery FROM TMSDataSet

    DATA hBookMark INIT 0       // Fila con la marca actual
    DATA nBookMark INIT 0       // RecNo de la fila marcada

    DATA nColFind INIT 1        // Columna por la que se hace la busqueda
    DATA uValFind               // Valor que se busca

    METHOD New CONSTRUCTOR
    METHOD UseResult( cStatement )
    METHOD Open( cStatement )
    METHOD QueryFromParam( cTable, aCol, cWhere, cGroupBy, ;
                           cHaving, uOrderBy, nLimit )
    METHOD Refresh()
    METHOD ResetResult()
    METHOD Free()

    METHOD FreeResult()
    MESSAGE Close() METHOD FreeResult()

    METHOD RecCount()
    MESSAGE RowCount() METHOD RecCount()
    MESSAGE LastRec() METHOD RecCount()

    METHOD FCount()
    MESSAGE FieldCount() METHOD FCount()

    METHOD FieldGet( nFld )
    MESSAGE Column( nFld ) METHOD FieldGet( nFld )
    METHOD FieldGetByName( cFName )
    METHOD FieldPut() VIRTUAL

    METHOD SetReadColPAD( nFld, lRead )

    METHOD SetColTinyAsLogical( nCol, lLogical )

    //-----------------------------------------------------
    // Obtiene informacion origina de tipo MySQL:

    METHOD ColAttribute
    METHOD ColName
    METHOD ColTable
    METHOD ColType
    METHOD ColLength

    METHOD ColDec
    METHOD ColFlags
    METHOD ColDefaultVal
    METHOD ColMaxLength

    METHOD ColRead

    METHOD ColIsNumeric
    METHOD ColIsPrimaryKey
    METHOD ColIsNotNull
    METHOD ColIsBlob
    METHOD ColIsAutoInc

    //-----------------------------------------------------
    // Obtiene informacion del tipo xBase:

    METHOD FieldPos( cColName )
    METHOD FieldName( nCol )
    METHOD FieldType( nCol )
    METHOD FieldLen( nCol )
    METHOD FieldDec( nCol )

    //-----------------------------------------------------
    // Movimiento del puntero de datos
    // Estilo xBase:

    METHOD GoTo
    METHOD GoTop
    METHOD GoBottom
    METHOD Skip
    METHOD Skipper

    METHOD RecNo
    METHOD EOF
    METHOD BOF

    //-----------------------------------------------------
    // Busqueda en el resultado de valores de una columna:

    METHOD Find
    METHOD FindNext

    METHOD FindLike
    METHOD FindLikeNext

    //-----------------------------------------------------
    // Movimiento del puntero de datos
    // Estilo SQL:

    METHOD Prior
    METHOD Next
    MESSAGE First METHOD GoTop
    MESSAGE Last METHOD GoBottom
    MESSAGE MoveBy METHOD Skip

    METHOD Fetch

    //-----------------------------------------------------
    // Gestion de Marcas:

    METHOD GetBookMark()          // Crea una marca
    METHOD GoToBookMark()         // Va al registro marcado
    METHOD FreeBookmark()         // Libera la marca

    //-----------------------------------------------------
    // Obtiene un array con la fila actual:

    METHOD GetRowAsString
    METHOD GetRow

    //-----------------------------------------------------
    // Gestion de campos MEMO y BLOB

    METHOD ReadFromFile( cFileName )
    METHOD WriteToFile( nCol, cFileName )

    METHOD SetReadMemo( nFld, lRead )
    METHOD SetReadMemoAll( lRead )

    METHOD ReadMemo( nFld )
    MESSAGE ReadBlob( nFld ) METHOD ReadMemo( nFld )

ENDCLASS

//---------------------------------------------------------------------------//
// Constructor de la clase

METHOD New( oDbCon, cStatement ) CLASS TMSQuery

    Super:New( oDbCon, cStatement )

    ::SetIName( "Query" )

return( Self )

//---------------------------------------------------------------------------//
// Abre el resultado de una consulta pero no los descarga

METHOD UseResult( cStatement ) CLASS TMSQuery

    ::ResetResult() // Por si habia uno activo con anterioridad

    BYNAME cStatement TYPE "C"

    if ( ::lOpened := E1UseResult( ::hMySQL, ::cStatement ) )
        ::FreeBookmark()
        ::GoTop()
    else
        ::oError:Show( .f. )
    endif

return( ::lOpened )

//---------------------------------------------------------------------------//
// Abre el resultado de una consulta y la descarga toda.

METHOD Open( cStatement ) CLASS TMSQuery

    BYNAME cStatement TYPE "C"

    if ( ::lOpened := E1Open( ::hMySQL, ::cStatement ) )
        ::FreeBookmark()
    else
        ::oError:Show( .f. )
    endif

return( ::lOpened )

//---------------------------------------------------------------------------//
// Vuelve a abrir una consulta desde el servidor actualizado con los cambios

METHOD Refresh() CLASS TMSQuery

    if !( ::lOpened := E1RefreshResult( ::hMySQL, ::cStatement ) )
        ::oError:Show( .f. )
    endif

return( ::lOpened )

//---------------------------------------------------------------------------//
// Abre una consulta a partir de los parametros pasados

METHOD QueryFromParam( cTable, aCol, cWhere, cGroupBy, ;
                       cHaving, uOrderBy, nLimit ) CLASS TMSQuery

    local n, i

    ::cStatement := 'SELECT '

    if ValType( aCol ) == "A" .and. !empty( aCol )
        i := len( aCol ) - 1
        FOR n := 1 TO i
            ::cStatement += aCol[ n ] + ', '    // Añade una ','
        NEXT
        ::cStatement += aCol[ i + 1 ]
    else
        ::cStatement += '*'
    endif

    ::cStatement += ' FROM ' + cTable

    ::cStatement += if( empty( cWhere ), '', ' WHERE ' + cWhere )
    ::cStatement += if( empty( cGroupBy ), '', ' GROUP BY ' + cGroupBy )
    ::cStatement += if( empty( cHaving ), '', ' HAVING ' + cHaving )

    if ValType( uOrderBy ) $ "CN"
        ::cStatement += ' ORDER BY '
        if ValType( uOrderBy )== "N"
            uOrderBy := StrNum( uOrderBy )
        endif
        ::cStatement += uOrderBy
    endif

    if !empty( nLimit ) .and. ValType( nLimit ) =="N"
        ::cStatement += ' LIMIT ' + StrNum( nLimit )
    endif

return( ::Open() )

//---------------------------------------------------------------------------//
// Libera la memoria de la ultima instruccion SQL ejecutada con Open

METHOD FreeResult() CLASS TMSQuery

    if ::lOpened
        ::FreeBookmark()
        E1FreeResult( ::hMySQL )
        ::lOpened := .f.
    endif

return( Self )

//---------------------------------------------------------------------------//
// Resetea el resultado

METHOD ResetResult() CLASS TMSQuery

    if ::lOpened
        ::FreeBookmark()
        E1ResetDS( ::hMySQL )
        ::lOpened := .f.
    endif

return( Self )

//---------------------------------------------------------------------------//
// Obtiene el numero de registros de la consulta

METHOD RecCount() CLASS TMSQuery
return( E1GetRecCount( ::hMySQL ) )

//---------------------------------------------------------------------------//
// Obtiene el numero de campos del registro

METHOD FCount() CLASS TMSQuery
return( E1GetFieldCount( ::hMySQL ) )

//---------------------------------------------------------------------------//
// Devuelve un array con todos los atributos originales de un campo

METHOD ColAttribute( n ) CLASS TMSQuery
return( E1ColAttributeAll( ::hMySQL, n ) )

//---------------------------------------------------------------------------//
// Devuelve el nombre del campo

METHOD ColName( n ) CLASS TMSQuery
return( E1ColName( ::hMySQL, n ) )

//---------------------------------------------------------------------------//
// Devuelve el nombre de la tabla del campo

METHOD ColTable( n ) CLASS TMSQuery
return( E1ColTable(  ::hMySQL, n ) )

//---------------------------------------------------------------------------//
// Devuelve el tipo MySQL del campo

METHOD ColType( n ) CLASS TMSQuery
return( E1ColType( ::hMySQL, n ) )

//---------------------------------------------------------------------------//
// Devuelve el ancho del campo

METHOD ColLength( n ) CLASS TMSQuery
return( E1ColLength( ::hMySQL, n ) )

//---------------------------------------------------------------------------//
// Devuelve los decimales del campo

METHOD ColDec( n ) CLASS TMSQuery
return( E1ColDec( ::hMySQL, n ) )

//---------------------------------------------------------------------------//
// Devuelve el flags del campo

METHOD ColFlags( n ) CLASS TMSQuery
return( E1ColFlags( ::hMySQL, n ) )

//---------------------------------------------------------------------------//
// Devuelve el valor por defecto del campo

METHOD ColDefaultVal( n ) CLASS TMSQuery
return( E1ColDefaultVal( ::hMySQL, n ) )

//---------------------------------------------------------------------------//
// Devuelve el maximo ancho del campo

METHOD ColMaxLength( n ) CLASS TMSQuery
return( E1ColMaxLength( ::hMySQL, n ) )

//---------------------------------------------------------------------------//
// Lee fila y avanza a la siguiente

METHOD Fetch() CLASS TMSQuery
return( E1Fetch( ::hMySQL ) )

//---------------------------------------------------------------------------//
// Mueve el puntero a la fila especificada

METHOD GoTo( nRec ) CLASS TMSQuery

    E1GoTo( ::hMySQL, nRec )

return( Self )

//---------------------------------------------------------------------------//
// Va a la primera fila

METHOD GoTop() CLASS TMSQuery

    E1GoTop( ::hMySQL )

return( Self )

//---------------------------------------------------------------------------//
// Va a la ultima fila

METHOD GoBottom() CLASS TMSQuery

    E1GoBottom( ::hMySQL )

return( Self )

//---------------------------------------------------------------------------//
// Salta n filas desde la actual

METHOD Skip( n ) CLASS TMSQuery

    E1Skip( ::hMySQL, n )

return( Self )

//---------------------------------------------------------------------------//
// Mueve el puntero uno a uno y lee. Devuelve el numero de filas saltadas.
// Se usa para los Browses y listados.

METHOD Skipper( n ) CLASS TMSQuery
return( E1Skipper( ::hMySQL, n ) )

//---------------------------------------------------------------------------//
// Numero de registro actual

METHOD RecNo() CLASS TMSQuery
return( E1GetRecNo( ::hMySQL ) )

//---------------------------------------------------------------------------//
// Comprueba si esta al final de la consulta

METHOD EOF() CLASS TMSQuery
return( E1GetEof( ::hMySQL ) )

//---------------------------------------------------------------------------//
// Comprueba si esta al principio de la consulta

METHOD BOF() CLASS TMSQuery
return( E1GetBof( ::hMySQL ) )

//---------------------------------------------------------------------------//
// Va a la fila anterior

METHOD Prior() CLASS TMSQuery
return( ::Skip( -1 ) )

//---------------------------------------------------------------------------//
// Va a la fila siguiente

METHOD Next() CLASS TMSQuery

    E1Fetch( ::hMySQL )

return( Self )

//---------------------------------------------------------------------------//
// Escribe el contenido de una columna en un fichero. Se usa principalmente
// para filas MEMO y BLOB como por ejemplo imagenes

METHOD WriteToFile( nCol, cFileName ) CLASS TMSQuery
return( E1WriteToFile( ::hMySQL, nCol, cFileName ) )

//---------------------------------------------------------------------------//
// Lee un fichero y lo carga en la memoria, se usara para hecer UPDATE o
// INSERT de columnas de tipo MEMO y BLOB

METHOD ReadFromFile( cFileName ) CLASS TMSQuery
return( E1ReadFromFile( ::hMySQL, cFileName ) )

//---------------------------------------------------------------------------//
// Comprueba si una columna es de tipo numerico en MySQL

METHOD ColIsNumeric( n ) CLASS TMSQuery
return( E1IsNumeric( ::hMySQL, n ) )

//---------------------------------------------------------------------------//
// Devuelve si una columna forma parte de una clave primaria

METHOD ColIsPrimaryKey( n ) CLASS TMSQuery
return( E1IsPrimaryKey( ::hMySQL, n ) )

//---------------------------------------------------------------------------//
// Devuelve si una columna no puede ser nula nunca

METHOD ColIsNotNull( n ) CLASS TMSQuery
return( E1IsNotNull( ::hMySQL, n ) )

//---------------------------------------------------------------------------//
// Devuelve si una columna es Blob

METHOD ColIsBlob( n ) CLASS TMSQuery
return( E1IsBlob( ::hMySQL, n ) )

//---------------------------------------------------------------------------//
// Devuelve si una columna es autoincremental

METHOD ColIsAutoInc( n ) CLASS TMSQuery
return( E1IsAutoInc( ::hMySQL, n ) )

//---------------------------------------------------------------------------//
// Marca la fila actual

METHOD GetBookMark() CLASS TMSQuery

    ::hBookMark := E1RowTell( ::hMySQL )
    ::nBookMark := ::RecNo()

return( self )

//---------------------------------------------------------------------------//
// Va a la fila marcada

METHOD GoToBookMark() CLASS TMSQuery

    if !( ::hBookMark == 0 )
        E1RowSeek( ::hBookMark )
        E1SetRecNo( ::nBookMark )
    else
        ::oError:Say( "No existe una marca desde el ultimo Open", .f. )
    endif

return( Self )

//---------------------------------------------------------------------------//
// Libera la marca

METHOD FreeBookmark() CLASS TMSQuery

    ::hBookMark := 0
    ::nBookMark := 0

return( Self )

//---------------------------------------------------------------------------//
// Devuelve el tipo xBase de la columna especificada

METHOD FieldType( nCol ) CLASS TMSQuery
return( E1ValType( ::hMySQL, nCol ) )

//---------------------------------------------------------------------------//
// Nombre del campo

METHOD FieldName( nCol ) CLASS TMSQuery
return( E1FieldName( ::hMySQL, nCol ) )

//---------------------------------------------------------------------------//
// Orden de la columna en el registro

METHOD FieldPos( cCol ) CLASS TMSQuery
return( E1FieldPos( ::hMySQL, cCol ) )

//---------------------------------------------------------------------------//
// Ancho del campo

METHOD FieldLen( nCol ) CLASS TMSQuery
return( E1FieldLen( ::hMySQL, nCol ) )

//---------------------------------------------------------------------------//
// Numero de decimales

METHOD FieldDec( nCol ) CLASS TMSQuery
return( E1FieldDec( ::hMySQL, nCol ) )

//---------------------------------------------------------------------------//
// Busca un valor al estilo de MySQL en un conjunto de resultados

METHOD Find( nCol, uVal, lTop ) CLASS TMSQuery

    local lOk := ( !empty( uVal ) .and. ;
                   ValType( nCol ) == "N" .and. ;
                   nCol > 0 .and. nCol <= ::FieldCount() )

    if lOk
        ::nColFind := nCol
        ::uValFind := uVal
        if ValType( lTop ) == "L" .and. lTop
            ::GoTop()
        endif
        if ValType( uVal ) == "C"
            if !( lOk := ( ::uValFind = ::ColRead( nCol ) ) )
                lOk := ::FindNext()
            endif
        else
            if !( lOk := ( ::uValFind = ::FieldGet( nCol ) ) )
                lOk := ::FindNext()
            endif
        endif
    else
        ::oError:Say( "Error en parametros...", .t. )
    endif

return( lOk )

//---------------------------------------------------------------------------//
// Busca el siguiente valor al estilo de MySQL en un conjunto de resultados

METHOD FindNext() CLASS TMSQuery

    local lRet := .f.

    if ValType( ::uValFind ) == "C"
        while ::Fetch()
            if ( ::uValFind = ::ColRead( ::nColFind ) )
                lRet := .t.
                EXIT
            endif
        end
    else
        while ::Fetch()
            if ( ::uValFind = ::FieldGet( ::nColFind ) )
                lRet := .t.
                EXIT
            endif
        end
    endif

return( lRet )

//---------------------------------------------------------------------------//
// Busca un valor al estilo de MySQL en un conjunto de resultados
// Si el valor buscado es de tipo "C" busca el contenido parcial

METHOD FindLike( nCol, uVal, lTop ) CLASS TMSQuery

    local lOk := ( !empty( uVal ) .and. ;
                   ValType( nCol ) == "N" .and. ;
                   nCol > 0 .and. nCol <= ::FieldCount() )

    if lOk
        ::nColFind := nCol
        ::uValFind := uVal
        if ValType( lTop ) == "L" .and. lTop
            ::GoTop()
        endif
        if ValType( ::uValFind ) == "C"
            lOk := if( ::uValFind $ ::ColRead( nCol ), .t., ::FindLikeNext() )
        else // Si el valor buscado no es caracter se usa el metodo FindNext
            lOk := if( ::uValFind = ::FieldGet( nCol ), .t., ::FindLikeNext() )
        endif
    else
        ::oError:Say( "Error en parametros...", .t. )
    endif

return( lOk )

//---------------------------------------------------------------------------//
// Busca el siguiente valor al estilo de MySQL en un conjunto de resultados
// Si el valor buscado es de tipo "C" busca el contenido parcial

METHOD FindLikeNext() CLASS TMSQuery

    local lRet := .f.

    if ValType( ::uValFind ) == "C"
        while ::Fetch()
            if ( ::uValFind $ ::ColRead( ::nColFind ) )
                lRet := .t.
                EXIT
            endif
        end
    else
        while ::Fetch()
            if ( ::uValFind = ::FieldGet( ::nColFind ) )
                lRet := .t.
                EXIT
            endif
        end
    endif

return( lRet )

//---------------------------------------------------------------------------//
// Obtiene un array con el contenido de la fila con todas las colunnas de
// tipo xBase

METHOD GetRow() CLASS TMSQuery
return( E1GetRow( ::hMySQL ) )

//---------------------------------------------------------------------------//
// Obtiene un array con el contenido de la fila con todas las colunnas de
// tipo texto al estilo MySQL

METHOD GetRowAsString() CLASS TMSQuery
return( E1GetRowAsString( ::hMySQL ) )

//---------------------------------------------------------------------------//
// Devuelve el valor de la columna en formato xBase

METHOD FieldGet( nFld ) CLASS TMSQuery
return( E1FieldGet( ::hMySQL, nFld ) )

//---------------------------------------------------------------------------//
// Obtiene el valor de la columna especificada al estilo MySQL

METHOD ColRead( nFld ) CLASS TMSQuery
return( E1ColRead( ::hMySQL, nFld ) )

//---------------------------------------------------------------------------//
// Activa o desactiva la lectura de MEMOS con el método FieldGet

METHOD SetReadMemo( nFld, lRead ) CLASS TMSQuery
return( E1SetReadMemo( ::hMySQL, nFld, lRead ) )

//---------------------------------------------------------------------------//
// Activa o desactiva la lectura de MEMOS con el método FieldGet

METHOD SetReadMemoAll( lRead ) CLASS TMSQuery
return( E1SetReadMemoAll( ::hMySQL, lRead ) )

//---------------------------------------------------------------------------//
// Lee un campo MEMO sin formatear

METHOD ReadMemo( nFld ) CLASS TMSQuery
return( E1ColRead( ::hMySQL, nFld ) )

//---------------------------------------------------------------------------//
// Activa la lectura de un campo caracter formateado a su tamaño

METHOD SetReadColPAD( nFld, lRead ) CLASS TMSQuery
return( E1SetColPad( ::hMySQL, nFld, lRead ) )

//---------------------------------------------------------------------------//
// Libera la memoria y el objeto

PROCEDURE Free() CLASS TMSQuery

    E1FreeResult( ::hMySQL )
    Super:Free()

return

//---------------------------------------------------------------------------//
// Obtiene el valor de una columna por el nombre

METHOD FieldGetByName( cFName ) CLASS TMSQuery
return( E1FieldGetByName( ::hMySQL, cFName ) )

//---------------------------------------------------------------------------//
// Pone o quita una columna Tiny como logica

METHOD SetColTinyAsLogical( nCol, lLogical ) CLASS TMSQuery
return( E1SetColTinyAsLogical( ::hMySQL, nCol, lLogical ) )

//---------------------------------------------------------------------------//

METHOD fieldGetDecimalByName( cFName ) CLASS TMSQuery
    local n     := ::FieldPos( cFName )
return( val( ::ColRead( n ) ) )


