//---------------------------------------------------------------------------//
//  AUTOR.....: Manuel Expósito Suárez   Soft4U 2002-2010                    //
//  eMail.....: manuexposito@gmail.com                                       //
//  CLASE.....: TMSDbfCursor                                                 //
//  FECHA MOD.: 15/11/2010                                                   //
//  VERSION...: 6.00                                                         //
//  PROPOSITO.: Gestión de consultas locales en DBF                          //
//---------------------------------------------------------------------------//

#include "eagle1.ch"

//---------------------------------------------------------------------------//

CLASS TMSDbfCursor FROM TMSCursor

    DATA cDbfName INIT ""
    DATA lErase INIT .t.

    METHOD New( oDbCon, cStatement ) CONSTRUCTOR
    METHOD Free( lErase )

    METHOD FillCursor()

    METHOD GoTo( nRow )
    METHOD GoTop()
    METHOD GoBottom()
    METHOD Skip( nSkip )
    METHOD Skipper( nSkip )

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

METHOD New( oDbCon, cStatement ) CLASS TMSDbfCursor

    Super:New(  oDbCon, cStatement  )
    ::Cursor := 0   // WorkArea de la DBF

    ::SetIName( "DbfCursor" )

return( Self )

//---------------------------------------------------------------------------//
// Destructor de la clase

PROCEDURE Free( lErase ) CLASS TMSDbfCursor

    DbCloseArea( ::Cursor )

    ::Cursor := 0

    BYNAME lErase TYPE "L"

    if ::lErase .and. !DbDrop( ::cDbfName )
        ::oConnect:oError:Say( "No se eliminó el fichero " + ::cDbfName, .f. )
    endif

    Super:Free()

return

//---------------------------------------------------------------------------//
// Rellena el cursor con el contenido de la consulta

METHOD FillCursor() CLASS TMSDbfCursor

    local cName := "MyCur"
    local cDbfName, nArea
    local n := 0

    DbSelectArea( 0 )

    nArea := Select()
    cDbfName := cName + PadL( nArea, 3, "0" ) + ".dbf"

    while File( cDbfName )
        cDbfName := cName + PadL( ++n, 3, "0" ) + ".dbf"
    end

    DbCreate( cDbfName, ::aStruct )
    DbUseArea( .t.,, cDbfName,, .f., .f. )

    if File( cDbfName )
        ( nArea )->( E1DbfFillCursor( ::hMySQL ) )
        ::cDbfName := cDbfName
    else
        ::oError:Say( "No se ha creado DBF Cursor..." )
        ( nArea )->( DbCloseArea() )
        nArea := 0
    endif

return( nArea )

//---------------------------------------------------------------------------//

METHOD GoTo( nRow ) CLASS TMSDbfCursor

    ( ::Cursor )->( DbGoTo( nRow ) )

return( Self )

//---------------------------------------------------------------------------//

METHOD GoTop() CLASS TMSDbfCursor

    ( ::Cursor )->( DbGoTop() )

return( Self )

//---------------------------------------------------------------------------//

METHOD GoBottom() CLASS TMSDbfCursor

    ( ::Cursor )->( DbGoBottom() )

return( Self )

//---------------------------------------------------------------------------//

METHOD Skip( nSkip ) CLASS TMSDbfCursor

    ( ::Cursor )->( DbSkip( nSkip ) )

return( Self )

//---------------------------------------------------------------------------//

METHOD Skipper( nSkip ) CLASS TMSDbfCursor
return( E1DbSkipper( nSkip ) )

//---------------------------------------------------------------------------//

METHOD FieldGet( n ) CLASS TMSDbfCursor
return( ( ::Cursor )->( FieldGet( n ) ) )

//---------------------------------------------------------------------------//

METHOD RowCount() CLASS TMSDbfCursor
return( ( ::Cursor )->( RecCount() ) )

//---------------------------------------------------------------------------//

METHOD EOF() CLASS TMSDbfCursor
return( ( ::Cursor )->( EOF() ) )

//---------------------------------------------------------------------------//

METHOD BOF() CLASS TMSDbfCursor
return( ( ::Cursor )->( BOF() ) )

//---------------------------------------------------------------------------//

METHOD RecNo() CLASS TMSDbfCursor
return( ( ::Cursor )->( RecNo() ) )

//---------------------------------------------------------------------------//




