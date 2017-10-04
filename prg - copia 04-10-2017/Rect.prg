#include "FiveWin.ch"

//----------------------------------------------------------------------------//

CLASS TRect

   DATA  aRect

   METHOD   New( nTop, nLeft, nBottom, nRight ) CONSTRUCTOR

   ACCESS   nTop        INLINE ::aRect[ 1 ]
   ACCESS   nLeft       INLINE ::aRect[ 2 ]
   ACCESS   nBottom     INLINE ::aRect[ 3 ]
   ACCESS   nRight      INLINE ::aRect[ 4 ]
   ACCESS   nHeight     INLINE ::aRect[ 3 ] - ::aRect[ 1 ] + 1
   ACCESS   nWidth      INLINE ::aRect[ 4 ] - ::aRect[ 2 ] + 1
   ACCESS   cRect       INLINE L2Bin( ::aRect[ 2 ] ) + L2Bin( ::aRect[ 1 ] ) + ;
                               L2Bin( ::aRect[ 4 ] ) + L2Bin( ::aRect[ 3 ] )

   ASSIGN   nTop(x)     INLINE ( ::aRect[ 1 ] := x )
   ASSIGN   nLeft(x)    INLINE ( ::aRect[ 2 ] := x )
   ASSIGN   nBottom(x)  INLINE ( ::aRect[ 3 ] := x )
   ASSIGN   nRight(x)   INLINE ( ::aRect[ 4 ] := x )
   ASSIGN   nHeight(x)  INLINE ( ::aRect[ 3 ] := x + ::aRect[ 1 ] - 1, ::nHeight )
   ASSIGN   nWidth(x)   INLINE ( ::aRect[ 4 ] := x + ::aRect[ 2 ] - 1, ::nWidth )
   ASSIGN   cRect(c)    INLINE ::aRect := { ;
                               Bin2L( SubStr( c,  5, 4 ) ), ;
                               Bin2L( SubStr( c,  1, 4 ) ), ;
                               Bin2L( SubStr( c, 13, 4 ) ), ;
                               Bin2L( SubStr( c,  9, 4 ) )  }

   METHOD   MoveBy( nRows, nCols )
   METHOD   MoveTo( nNewTop, nNewLeft )


   OPERATOR "==" ARG o INLINE ( ::nTop == o:nTop .and. ::nLeft == o:nLeft .and. ;
                                ::nBottom == o:nBottom .and. ::nRight == o:nRight )

   METHOD ByIndex( n, x ) OPERATOR "[]"

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nBottom, nRight ) CLASS TRect

   if ValType( nTop ) == 'A'
      ::aRect     := AClone( nTop )
   else
      ::aRect     := { nTop, nLeft, nBottom, nRight }
   endif

return Self

//----------------------------------------------------------------------------//

METHOD MoveBy( nRows, nCols ) CLASS TRect

   DEFAULT nRows := 0, nCols := 0

   ::aRect[ 1 ]      += nRows
   ::aRect[ 3 ]      += nRows
   ::aRect[ 2 ]      += nCols
   ::aRect[ 4 ]      += nCols

return Self

//----------------------------------------------------------------------------//

METHOD MoveTo( nNewTop, nNewLeft ) CLASS TRect

   DEFAULT nNewTop := ::aRect[ 1 ], nNewLeft := ::aRect[ 2 ]

return ::MoveBy( nNewTop - ::aRect[ 1 ], nNewLeft - ::aRect[ 2 ] )

//----------------------------------------------------------------------------//

METHOD ByIndex( n, x ) CLASS TRect
return If( x == nil, ::aRect[ n ], ::aRect[ n ] := x )

//----------------------------------------------------------------------------//

