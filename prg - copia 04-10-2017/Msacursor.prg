//---------------------------------------------------------------------------//
//  AUTOR.....: Manuel Expósito Suárez   Soft4U 2002-2010                    //
//  eMail.....: manuexposito@gmail.com                                       //
//  CLASE.....: TMSACursor                                                   //
//  FECHA MOD.: 15/11/2010                                                   //
//  VERSION...: 6.00                                                         //
//  PROPOSITO.: Gestión de consultas locales en array                        //
//---------------------------------------------------------------------------//

#include "eagle1.ch"

//---------------------------------------------------------------------------//

CLASS TMSACursor FROM TMSCursor

    DATA nRecNo INIT 0
    DATA lEof INIT .f.
    DATA lBof INIT .f.

    METHOD New( oDbCon, cStatement ) CONSTRUCTOR
    METHOD Free()

    METHOD FillCursor()

    METHOD GoTo( n )
    METHOD GoTop()
    METHOD GoBottom()
    METHOD Skip( n )
    METHOD Skipper( n )

    METHOD FieldGet( n )

    METHOD RowCount()
    MESSAGE RecCount() METHOD RowCount()
    MESSAGE LastRec() METHOD RowCount()
    METHOD RecNo()

    METHOD EOF()
    METHOD BOF()

ENDCLASS

//---------------------------------------------------------------------------//
// Constructor de la clase

METHOD New( oDbCon, cStatement ) CLASS TMSACursor

    Super:New( oDbCon, cStatement )
    ::Cursor := {}

    ::SetIName( "ACursor" )

return( Self )

//---------------------------------------------------------------------------//
// Destructor de la clase

PROCEDURE Free() CLASS TMSACursor

    ::Cursor := nil

    Super:Free()

return

//---------------------------------------------------------------------------//
// Crea el contenido del cursor

METHOD FillCursor() CLASS TMSACursor
return( E1AFillResult( ::hMySQL ) )

//---------------------------------------------------------------------------//

METHOD GoTo( n ) CLASS TMSACursor

    ::lEof := ::lBof := .f.

    if ValType( n ) == "N" .and. n > 0
        ::nRecNo := if( n > ::RecCount(), ( ::lEof := .t., ::RecCount() ), n )
    endif

return( Self )

//---------------------------------------------------------------------------//

METHOD GoTop() CLASS TMSACursor

    ::nRecNo := 1

return( Self )

//---------------------------------------------------------------------------//

METHOD GoBottom() CLASS TMSACursor

    ::nRecNo := ::RowCount()

return( Self )

//---------------------------------------------------------------------------//

METHOD Skip( n ) CLASS TMSACursor

    local nRecNo := ::nRecNo + if( ValType( n ) == "N", n, 1 )

    if nRecNo > ::RowCount()
        ::nRecNo := ::RowCount()
        ::lEof := .t.
    elseif nRecNo < 1
        ::nRecNo := 1
        ::lBof := .t.
    else
        ::nRecNo := nRecNo
    endif

return( Self )

//---------------------------------------------------------------------------//

METHOD Skipper( n ) CLASS TMSACursor

    local nSkipped

    if ValType( n ) != "N"
        n := 1
    endif

    nSkipped := Min( Max( n, 1 - ::nRecNo ), ::RecCount() - ::nRecNo )

    ::nRecNo += nSkipped

return( nSkipped )

//---------------------------------------------------------------------------//

METHOD FieldGet( n ) CLASS TMSACursor
return( ::Cursor[ ::nRecNo, n ] )

//---------------------------------------------------------------------------//

METHOD RowCount() CLASS TMSACursor
return( len( ::Cursor ) )

//---------------------------------------------------------------------------//

METHOD EOF() CLASS TMSACursor
return( ::lEof )

//---------------------------------------------------------------------------//

METHOD BOF() CLASS TMSACursor
return( ::lBof )

//---------------------------------------------------------------------------//

METHOD RecNo() CLASS TMSACursor
return( ::nRecNo )

//---------------------------------------------------------------------------//




