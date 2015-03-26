//---------------------------------------------------------------------------//
//  AUTOR.....: Manuel Expósito Suárez   Soft4U 2002-2010                    //
//  eMail.....: manuexposito@gmail.com                                       //
//  CLASE.....: TMSTable                                                     //
//  FECHA MOD.: 15/11/2010                                                   //
//  VERSION...: 6.00                                                         //
//  PROPOSITO.: Gestión de Tablas en MySQL                                   //
//---------------------------------------------------------------------------//
/*
  Crear METHOD SetOrder( [nCol | cCol] ) para construir el metodo seek
*/

#include "eagle1.ch"

//---------------------------------------------------------------------------//

//===========================================================================//
// Funcion para crear una clase especializada para la tabla tratada

function TMyTable( cCls )
return( MyGenClass( cCls, TVMyTable() ) )

//---------------------------------------------------------------------------//
// Clase derivada de TMSTable especializada en crear DataFields

CLASS TVMyTable FROM TMSTable

    DATA lGenDataField INIT .t.     // Crea DataFields?

    METHOD Open()       // Sobrecribe Open para la creacion de DataFields

ENDCLASS

//---------------------------------------------------------------------------//
// Abre la tabla y trae el resultado y crea las DataFields

METHOD Open() CLASS TVMyTable

    local lRet := ::Super:Open()

    if lRet .and. ::lGenDataField
        MyGenDataField( Self )
        ::lGenDataField := .f.
    endif

return( lRet )

//===========================================================================//

//---------------------------------------------------------------------------//
// Clase para el mantenimiento de tablas de MySQL
//---------------------------------------------------------------------------//

CLASS TMSTable FROM TMSQuery

    DATA cName INIT ""              // Nombre de la tabla
    DATA cWhere INIT ""             // Condicion WHERE
    DATA cHaving INIT ""            // Subcondicion Having
    DATA cOrderBy INIT ""           // Ordenacion
    DATA lOpenTable INIT .f.        // Indica si la tabla esta abierta
    DATA aBuffer INIT {}            // Buffer de edicion tiene formato xBase

    DATA aKey INIT {}               // Lista de campos clave
    DATA nColAutoInc INIT 0         // Numero de columna autoincremental

    DATA nLimit INIT 0              // Limite en el numero de filas

    METHOD New( oDbCon, cName, cWhere, cHaving, cOrderBy, nLimit ) CONSTRUCTOR
    METHOD Open()

    METHOD CreateTable( aStruct, cType, lTemporary, lNotExists )

    METHOD Insert( lRefresh )
    METHOD Update( lRefresh, nLimit )
    METHOD Delete( lRefresh, nLimit )

    METHOD CreateIndex( cIndex, xCol, lUnique )
    METHOD DropIndex( cIndex )
    METHOD CreatePrimaryKey( xCol )
    METHOD AlterEngine( cNewType )
    METHOD Load()                   // Carga el buffer desde el resultado
    METHOD Blank()                  // Vacia el buffer poniendo cada campo a su tipo vacio
    METHOD GetBuffer( n )           // Obtiene el valor de un elemento del buffer
    METHOD SetBuffer( n, Val )      // Asigna el valor de un elemento del buffer
    MESSAGE FieldPut( n, Val ) METHOD SetBuffer( n, Val )

    METHOD GenSelect()
    METHOD GenWhere()

    METHOD SetWhere( cWhere, lRefresh )
    METHOD SetHaving( cHaving, lRefresh )
    METHOD SetOrderBy( cOrderBy, lDesc, lRefresh )
    METHOD SetLimit( nLimit, lRefresh )
    METHOD SetSelect( cWhere, cHaving, cOrderBy, nLimit, lRefresh )

    //----------------------------------
    // Para los que soporten bloqueo:

    METHOD Lock     VIRTUAL
    METHOD UnLock   VIRTUAL

//-----------------------------------------

    METHOD ShowCreate()
    METHOD ImportData()

ENDCLASS

//---------------------------------------------------------------------------//
// Constructor de la clase

METHOD New( oDbCon, cName, cWhere, cHaving, cOrderBy, nLimit ) CLASS TMSTable

    ::Super:New( oDbCon )

    if ::lInit

        ::cName         := cName
        if ValType( cWhere ) == "C"
            ::cWhere    := cWhere
        endif
        if ValType( cHaving ) == "C"
            ::cHaving   := cHaving
        endif
        if ValType( cOrderBy ) == "N"
            cOrderBy    := LTrim( Str( cOrderBy ) )
        endif
        if ValType( cOrderBy ) == "C"
            ::cOrderBy  := cOrderBy
        endif
        if ValType( nLimit ) == "N"
            ::nLimit    := nLimit
        endif

        ::GenSelect()

    endif

    ::SetIName( "Table" )

return( Self )

//---------------------------------------------------------------------------//
// Abre la tabla y trae el resultado

METHOD Open() CLASS TMSTable

    local lRet 			:= ::Super:Open()

    // Solo se debe ejecutar una vez en caso de "re-open":
    
    if lRet .and. !::lOpenTable
        ::lOpenTable 	:= .t.
        ::aBuffer 		:= Array( ::FieldCount() )
        ::nColAutoInc 	:= E1FieldAutoInc( ::hMySQL )
        ::aKey 			:= E1ListKey( ::hMySQL )
    endif

return( lRet )

//---------------------------------------------------------------------------//
// Crea la tabla

METHOD CreateTable( aStruct, cType, lTemporary, lNotExists ) CLASS TMSTable

    local n, nLen, cStmt, lAutoInc
    local lRet := .f.

    if ::lInit
        if ValType( aStruct ) == "A"

            if ValType( lTemporary ) == "L" .and. lTemporary
                cStmt := 'CREATE TEMPORARY TABLE '
            else
                cStmt := 'CREATE TABLE '
            endif

            if ValType( lNotExists ) == "L" .and. lNotExists
                cStmt += 'IF NOT EXISTS '
            endif

            cStmt += ::cName + ' ( '

            nLen := len( aStruct )

            for n := 1 to nLen
                if len( aStruct[ n ] ) == E1_DBS_AUTOINC .and. ;
                   ValType( aStruct[ n, E1_DBS_AUTOINC ] ) == "L"
                    lAutoInc := aStruct[ n, E1_DBS_AUTOINC ]
                else
                    lAutoInc := .f.
                endif
                cStmt += aStruct[ n, DBS_NAME ] + ' ' + ;
                         _ColDefine( aStruct[ n, E1_DBS_TYPE ], ;
                         aStruct[ n, E1_DBS_LEN ], ;
                         aStruct[ n, E1_DBS_DEC ], lAutoInc ) + ', '
            next

            cStmt := ChgAtEnd( cStmt, ' )', 2 )

            if ValType( cType ) == "C"
                cType := upper( cType )
                // Creo que no hay mas tipos de tablas
                if  cType == "ARCHIVE" .or. ;
                    cType == "CSV" .or. ;
                    cType == "EXAMPLE" .or. ;
                    cType == "FEDERATED" .or. ;
                    cType == "HEAP" .or. ;
                    cType == "ISAM" .or. ;
                    cType == "INNODB" .or. ;
                    cType == "MEMORY" .or. ;
                    cType == "MERGE" .or. ;
                    cType == "MYISAM" .or. ;
                    cType == "NDBCLUSTER" .or. ;
                    cType == "BDB" .or. ;
                    cType == "GEMINI" .or. ;
                    cType == "MRG_MYISAM" .or. ;
                    cType == "BLACKHOLE"
                    cStmt += ' TYPE = ' + cType
                endif
            endif
            lRet := ::oCmd:ExecDirect( cStmt )
        else
            ::oError:Say( "La estructura debe ser un array...", .f. )
        endif
    endif

return( lRet )

//---------------------------------------------------------------------------//
//  Crea un indice en la tabla

METHOD CreateIndex( cIndex, xCol, lUnique ) CLASS TMSTable

    local nLen, i
    local cStmt := "CREATE "

    if ValType( lUnique ) == "L" .and. lUnique
        cStmt += "UNIQUE "
    endif

    cStmt += "INDEX " + cIndex + " ON " + ::cName + " ( "

    if ValType( xCol ) == "A"
        nLen := len( xCol )
        for i := 1 to nLen
            cStmt += xCol[ i ] + ", "
        next
        cStmt := ChgAtEnd( cStmt, ' )', 2 )
    else
        cStmt += xCol + " )"
    endif

return( ::oCmd:ExecDirect( cStmt ) )

//---------------------------------------------------------------------------//
// Destruye un indice existente de la tabla

METHOD DropIndex( cIndex ) CLASS TMSTable
return( ::oCmd:ExecDirect( "DROP INDEX " + cIndex + " ON " + ::cName ) )

//---------------------------------------------------------------------------//
// Crea una clave primaria en la tabla

METHOD CreatePrimaryKey( xCol ) CLASS TMSTable

    local nLen, i
    local cStmt := "ALTER TABLE " + ::cName + " ADD PRIMARY KEY ( "

    if ValType( xCol ) == "A"
        nLen := len( xCol )
        for i := 1 to nLen
            cStmt += xCol[ i ] + ", "
        next
        cStmt := ChgAtEnd( cStmt, ' )', 2 )
    else
        cStmt += xCol + " )"
    endif

return( ::oCmd:ExecDirect( cStmt ) )

//---------------------------------------------------------------------------//

METHOD ShowCreate() CLASS TMSTable

    local cRet
    local oQry := TMSQuery():New( ::oConnect )

    if oQry:Open( "SHOW CREATE TABLE "+ ::cName )
        cRet := oQry:FieldGet( 2 )
    else
        cRet := ""
    endif

    oQry:Free()

return( cRet )

//---------------------------------------------------------------------------//
// Genere la sentencia SELECT a partir de las datas

METHOD GenSelect( lRefresh ) CLASS TMSTable

    local lRet

    ::cStatement := 'SELECT * FROM ' + ::cName
    ::cStatement += if( empty( ::cWhere ), '', ' WHERE ' + ::cWhere )
    ::cStatement += if( empty( ::cHaving ), '', ' HAVING ' + ::cHaving )
    ::cStatement += if( empty( ::cOrderBy ), '', ' ORDER BY ' + ::cOrderBy )
    ::cStatement += if( empty( ::nLimit ), '', ' LIMIT ' + StrNum( ::nLimit ) )

    if ValType( lRefresh ) = "L" .and. lRefresh
        lRet := ::Refresh()
    else
        lRet := .t.
    endif

return( lRet )

//---------------------------------------------------------------------------//
// Cambia condicion WHERE de la tabla

METHOD SetWhere( cWhere, lRefresh ) CLASS TMSTable

    local lRet := ( ValType( cWhere ) == "C" )

    if lRet
        ::cWhere := cWhere
        lRet := ::GenSelect( lRefresh )
    endif

return( lRet )

//---------------------------------------------------------------------------//
// Cambia condicion Having de la tabla

METHOD SetHaving( cHaving, lRefresh ) CLASS TMSTable

    local lRet := ( ValType( cHaving ) == "C" )

    if lRet
        ::cHaving := cHaving
        lRet := ::GenSelect( lRefresh )
    endif

return( lRet )

//---------------------------------------------------------------------------//
// Cambia el orden activo de la tabla

METHOD SetOrderBy( cOrderBy, lDesc, lRefresh ) CLASS TMSTable

    local lRet
    local cType := ValType( cOrderBy )

    if cType == "N" .and. ( cOrderBy > 0 .and. cOrderBy <= ::FieldCount() )
        cOrderBy := StrNum( cOrderBy )
    else
        ::oError:Say( "No es un numero de columna valido", .t. )
    endif

    if ValType( cOrderBy ) == "C"
        if ValType( lDesc ) == "L" .and. lDesc
            cOrderBy += " DESC"
        endif
        ::cOrderBy := cOrderBy
        lRet := ::GenSelect( lRefresh )
    else
        lRet := .f.
    endif

return( lRet )

//---------------------------------------------------------------------------//
// Cambia el LIMIT de la tabla

METHOD SetLimit( nLimit, lRefresh ) CLASS TMSTable

    local lRet := ( ValType( nLimit ) == "N" )

    if lRet
        ::nLimit := nLimit
        lRet := ::GenSelect( lRefresh )
    endif

return( lRet )

//---------------------------------------------------------------------------//
// Regenera el SELECT a partir de los parámetros

METHOD SetSelect( cWhere, cHaving, cOrderBy, nLimit, lRefresh ) CLASS TMSTable

    BYNAME cWhere TYPE "C"
    BYNAME cHaving TYPE "C"
    if ValType( cOrderBy ) == "N"
        cOrderBy := StrNum( cOrderBy )
    endif
    BYNAME cOrderBy TYPE "C"
    BYNAME nLimit TYPE "N"

return( ::GenSelect( lRefresh ) )

//---------------------------------------------------------------------------//
// Inserta registros, si lRefresh == .t. trae nuevamente los resultados de
// la consulta

METHOD Insert( lRefresh ) CLASS TMSTable

    local n, lRet
    local nLen := ::FieldCount()
    local aBuffer := ::ImportData()
    local cStmt := 'INSERT INTO ' + ::cName + ' VALUES ( '

    for n := 1 to nLen
        cStmt += if( !( aBuffer[ n ] == nil ) .and. ;
                            !E1IsAutoInc( ::hMySQL, n ), ;
                                if( !E1IsNumeric( ::hMySQL, n ), ;
                                    ( '"' + aBuffer[ n ] + '", ' ), ;
                                    ( aBuffer[ n ] + ', ' ) ), ;
                                'NULL, ' )
    next

    cStmt := ChgAtEnd( cStmt, ' )', 2 )

    lRet := ::oCmd:ExecDirect( cStmt )

    if lRet .and. ValType( lRefresh ) = "L" .and. lRefresh
        ::Refresh()
    endif

return( lRet )

//---------------------------------------------------------------------------//
// Borra registros, con limites de registros y con posibilidad de refrescar
// la consulta con el nuevo resiltado

METHOD Delete( lRefresh, nLimit ) CLASS TMSTable

    local lRet
    local cStmt := 'DELETE FROM ' + ::cName + ::GenWhere()

    cStmt += if( ValType( nLimit ) == 'N' .and. nLimit > 0, ;
                            ' LIMIT ' + StrNum( nLimit ), '' )

    lRet := ::oCmd:ExecDirect( cStmt )

    if lRet .and. ValType( lRefresh ) = "L" .and. lRefresh
        ::Refresh()
    endif

return( lRet )

//---------------------------------------------------------------------------//
// Modifica registros, con la posibilidad de refrescarse en el cliente y con
// posobilidad de poner un numero maximo de registros actualizados

METHOD Update( lRefresh, nLimit ) CLASS TMSTable

    local n, lRet
    local nLen := ::FieldCount()
    local aBuffer := ::ImportData()
    local cStmt := "UPDATE " + ::cName + " SET "

    for n := 1 to nLen
        cStmt += ::ColName( n ) + " = " + if( !( aBuffer[ n ] == nil ), ;
                        ( + "'" + aBuffer[ n ] + "', " ), ;
                        ( " NULL, " ) )
    next

    cStmt := ChgAtEnd( cStmt, "  ", 2 )

    cStmt += ::GenWhere()
    cStmt += if( ValType( nLimit ) == 'N' .and. nLimit > 0, ;
                            " LIMIT " + StrNum( nLimit ), "" )

    lRet := ::oCmd:ExecDirect( cStmt )

    if lRet .and. ValType( lRefresh ) = "L" .and. lRefresh
        ::Refresh()
    endif

return( lRet )

//---------------------------------------------------------------------------//
// Carga el buffer tipo MySQL

METHOD Load() CLASS TMSTable

    E1Load( ::hMySQL, ::aBuffer )

return( Self )

//---------------------------------------------------------------------------//
// Devuelve un array con los mismos datos que tenga aBuffer tipo xBase pero
// convertidos a MySQL

METHOD ImportData() CLASS TMSTable
return( E1ImportData( ::hMySQL, ::aBuffer ) )

//---------------------------------------------------------------------------//
// Establece valores xBase vacios en aBuffer

METHOD Blank() CLASS TMSTable

    E1SetBlank( ::hMySQL, ::aBuffer )

return( Self )

//---------------------------------------------------------------------------//
// Devuelelve el valor indicado del buffer

METHOD GetBuffer( n ) CLASS TMSTable

   local uBuffer

   if Valtype( n ) == "C"
      n        := ::FieldPos( n )
   end if

   if ( n > 0 .and. n <= len( ::aBuffer ) )
      uBuffer  := ::aBuffer[ n ]
   end if

return( uBuffer )

//---------------------------------------------------------------------------//
// Establece el valor al elemento indicado del buffer

METHOD SetBuffer( n, Val ) CLASS TMSTable
return( ::aBuffer[ n ] := Val )

//---------------------------------------------------------------------------//
// Cambia el tipo de tabla

METHOD AlterEngine( cNewType ) CLASS TMSTable
return( ValType( cNewType ) == 'C' .and. ;
        ::oCmd:ExecDirect( "ALTER TABLE " + ::cName + " ENGINE = " + cNewType ) )

//---------------------------------------------------------------------------//
// Genera la sentecia WHERE del registro actual
//
// Metodo generador de la condicion WHERE para el UPDATE y DELETE
// Se comprueban los campos necesarios en el caso de haber un campo
// automatico o alguna clave y todos los campos si no los hay...
// es dificil que sean coincidentes...  ;-)

METHOD GenWhere() CLASS TMSTable

    local cWhere := ' WHERE '
    local nFld, n, i, cFldGet

    if ( n := ::nColAutoInc ) > 0
        cWhere += ::ColName( n ) + ' = ' + ::ColRead( n )
    elseif ( nFld := len( ::aKey ) ) > 0
        FOR i := 1 TO nFld
            n := ::aKey[ i ]
            cFldGet := ::ColRead( n )
            cWhere += if( ValType( cFldGet ) == 'C', if( ::ColIsNumeric( n ), ;
                          ( ::ColName( n ) + ' = '  + cFldGet +  ' AND ' ), ;
                          ( ::ColName( n ) + ' = "' + cFldGet + '" AND ' ) ), ;
                            ::ColName( n ) + ' IS NULL AND ' )
        NEXT
        cWhere := ChgAtEnd( cWhere, '', 4 )
    else
        nFld := ::FieldCount()
        FOR n := 1 TO nFld
            cFldGet := ::ColRead( n )
            cWhere += if( ValType( cFldGet ) == 'C', if( ::ColIsNumeric( n ), ;
                          ( ::ColName( n ) + ' = '  + cFldGet +  ' AND ' ), ;
                          ( ::ColName( n ) + ' = "' + cFldGet + '" AND ' ) ), ;
                            ::ColName( n ) + ' IS NULL AND ' )
        NEXT
        cWhere := ChgAtEnd( cWhere, '', 4 )
    endif

return( cWhere )

//---------------------------------------------------------------------------//
// Funciones hermanas a esta clase
//---------------------------------------------------------------------------//
// Devuelve cadena para la definicin de las tablas.

static function _ColDefine( cType, nLen, nDec, lAutoInc )

    local cRet

    SWITCH cType
        CASE 'C'
            cRet := "char( " + StrNum( nLen ) + " )"
            EXIT
        CASE 'N'
            if nDec > 0
                cRet := "decimal( " + StrNum( nLen ) + ", " + ;
                                      StrNum( nDec ) + " )"
            else
                DO CASE
                CASE nLen <= 4
                    cRet := "smallint( " + StrNum( nLen ) + " )"
                CASE nLen <= 6
                    cRet := "mediumint( " + StrNum( nLen ) + " )"
                CASE nLen <= 9
                    cRet := "int( " + StrNum( nLen ) + " )"
                OTHERWISE
                    cRet := "bigint( " + StrNum( nLen ) + " )"
                ENDCASE
            endif
            if lAutoInc
                cRet += " not null auto_increment unique"
            endif
            EXIT
        CASE 'D'
            cRet := "date"
            EXIT
        CASE 'L'
            cRet := "tinyint( 1 ) unsigned zerofill"
            EXIT
        CASE 'M'
            cRet := "text"
            EXIT
        DEFAULT
            cRet := "char( " + StrNum( nLen ) + " )"
    END

return( cRet )

//---------------------------------------------------------------------------//