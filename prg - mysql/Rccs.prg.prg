#include "FiveWin.Ch"
#include "Objects.ch"
#include "FileIo.ch"

static aObjBmps

//---------------------------------------------------------------------------//

CLASS Css

   DATA  nHandle           PROTECTED
   DATA  cCssFileName
   DATA  aLabels

   METHOD New( cCssFileName )          CONSTRUCTOR
   METHOD CssWrite( cBuffer )          INLINE   fWrite( ::nHandle, cBuffer )
   METHOD OpenLabel( cLabel )
   METHOD CloseLabel( cLabel )
   METHOD DataLabel( cLabel, xData )
   METHOD ValLabel( cLabel )
   METHOD End()                        INLINE   fClose( ::nHandle )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( cCssFileName )

   DEFAULT cCssFileName := "Css.Css"

   ::aLabels         := {}

   if At( ".", cCssFileName ) == 0
      cCssFileName   := AllTrim( cCssFileName ) + ".Css"
   end if

   ::cCssFileName    := cCssFileName

   if file( ::cCssFileName )
      ferase( ::cCssFileName )
   end if

   ::nHandle         := fCreate( cCssFileName, FC_NORMAL )

   ::CssWrite( '/* Datos generados por TCss class V1.0 por manuel calero */' + CRLF )

return Self

//---------------------------------------------------------------------------//

METHOD OpenLabel( cLabel )

   ::CssWrite( ::ValLabel( cLabel ) + " {" + CRLF )

return Self

//---------------------------------------------------------------------------//

METHOD CloseLabel( cLabel )

   ::CssWrite( "}" + CRLF )

return Self

//---------------------------------------------------------------------------//

METHOD DataLabel( cProp, xValue )

   if !empty( cProp ) .and. !empty( xValue )
      ::CssWrite( RTrim( cProp ) + " : " + RTrim( cValToChar( xValue ) ) + ";" + CRLF )
   end if

return Self

//---------------------------------------------------------------------------//

METHOD ValLabel( cLabel )

   local nChr

   /*
   Quitamos todos los epacios
   */

   cLabel   := StrTran( AllTrim( cLabel  ), " ", "" )

   /*
   Ahora buscamos los caracteres no validos
   */

   for n := 1 to len( cLabel )
      nChr  := Asc( SubStr( cLabel, n, 1 ) )
      if !( nChr > 63 .and. nChr < 127 )
         cLabel   := StrTran( cLabel, SubStr( cLabel, n, 1 ), "_" )
      end if
   next

   /*
   Comprobar q no este repetida la etiqueta
   */

   while aScan( ::aLabels, cLabel ) != 0
      cLabel += "_"
   end while

   aAdd( ::aLabels, cLabel )

return ( cLabel )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

function ObjInspect( oObject, cTitle )

   local oWndObj, oIco, oBar, oBrw
   local aObjInfo
   local nItem := 1

   CursorWait()

   DEFAULT  aObjBmps := {  "Array"    ,;
                           "Block"    ,;
                           "Chain"    ,;
                           "Date"     ,;
                           "Logic"    ,;
                           "Number"   ,;
                           "Memo"     ,;
                           "Object"   ,;
                           "Undefined",;
                           "SmallBug" ,;
                           "NoInfo"   }

   if ValType( oObject ) == "O"
      aObjInfo = aOData( oObject )
      // Let's give the Data Names the 'hungarian notation' look
      AEval( aObjInfo, { | cData, n | aObjInfo[ n ] := cChr2Data( cData ) } )
   endif

   DEFAULT cTitle := If( ValType( oObject ) == "O",;
                         "Object Inspector",;
                         "Array Inspector" )

   DEFINE ICON oIco RESOURCE "Objects"

   DEFINE WINDOW oWndObj FROM 1, 1 TO 23, 33 ;
      TITLE If( ValType( oObject ) == "O", "Object Inspector: ",;
                "Array Inspector: " ) + cTitle ;
      MDICHILD OF oWnd() ;
      ICON oIco

   @ 0, 0 LISTBOX oBrw FIELDS "" ;
      HEADERS "  ", "Data", "Value" ;
      FIELDSIZES 16, 90, 300 ;
      OF oWndObj ;
      SIZE 400, 400 ;
      ON DBLCLICK DataInspect( oObject, nItem, aObjInfo, cTitle )

   oBrw:bLine = { || aGetData( oObject, nItem, aObjInfo, cTitle ) }

   // Browsing an Array using FiveWin a TWBrowse Object !

   oBrw:bGoTop    = { || nItem := 1 }
   oBrw:bGoBottom = { || nItem := Eval( oBrw:bLogicLen ) }

   oBrw:bSkip     = { | nWant, nOld | nOld := nItem, nItem += nWant,;
                        nItem := Max( 1, Min( nItem, Eval( oBrw:bLogicLen ) ) ),;
                        nItem - nOld }

   oBrw:bLogicLen = { || If( ValType( oObject ) == "O", Len( aObjInfo ),;
                             Len( oObject ) ) }
   oBrw:cAlias    = "Array"  // We need a non empty cAlias !

   oWndObj:SetControl( oBrw )

   ACTIVATE WINDOW oWndObj

return nil

//----------------------------------------------------------------------------//

static function cGetData( uData, cType )

   local cResult := ""

   do case
      case cType == "B"
           cResult = "{ || ... }"

      case cType == "A"
           cResult = "[ ... ]"

      case cType == "O"
           cResult = "Object"

      case cType == "U"
           cResult = "Undefined"

      otherwise
           cResult = cValToChar( uData )
   endcase

return cResult

//----------------------------------------------------------------------------//

static function DataInspect( oObject, nItem, aObjInfo, cTitle )

   local cType := ValType( oObject )
   local cData, uData

   do case
      case cType == "A"
           cData = "[ " + AllTrim( Str( nItem ) ) + " ]"
           if Len( oObject[ nItem ] ) > 0
              ObjInspect( oObject[ nItem ], cTitle + cData )
           else
              MsgInfo( "Array is empty!", "Attention" )
           endif

      case cType == "O"
           cData = aObjInfo[ nItem ]
           uData = OSend( oObject, cData )
           if ValType( uData ) $ "AO"
              ObjInspect( OSend( oObject, cData ), cTitle + ":" + cData )
           else
              MsgInfo( "I don't find an Object or an Array there!", "Attention" )
           endif
   endcase

return nil

//----------------------------------------------------------------------------//

static function aGetData( oObject, nItem, aObjInfo )

   local uData, cData, cType

   do case
      case ValType( oObject ) == "A"
           uData = oObject[ nItem ]
           cData = "[ " + AllTrim( Str( nItem ) ) + " ]"

      case ValType( oObject ) == "O"
           uData = OSend( oObject, aObjInfo[ nItem ] )
           cData = aObjInfo[ nItem ]
   endcase

   cType = ValType( uData )

return { aObjBmps[ At( cType, "ABCDLNMOU" ) ], cData, cGetData( uData, cType ) }

//----------------------------------------------------------------------------//

static function cGetHierarchy( oObject )

   local nClass   := oObject:ClassH
   local cClasses := "Class Hierarchy:" + CRLF
   local n := 1

   while n < nClass
      if oObject:ChildLevel( __ClassIns( n ) ) != 0
         cClasses += __ClassNam( n ) + CRLF
      endif
      n++
   end

   cClasses += oObject:ClassName()

return cClasses

//----------------------------------------------------------------------------//