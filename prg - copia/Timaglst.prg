// Class TImageList (suport for CommCtrl ImageList controls)

#include "FiveWin.Ch"

//----------------------------------------------------------------------------//

CLASS TImageList

   DATA  hImageList
   DATA  aBitmaps

   METHOD New( nWidth, nHeight )  // Size of the images

   METHOD Add( oBmpImage, oBmpMask ) INLINE ;
      AAdd( ::aBitmaps, oBmpImage ), AAdd( ::aBitmaps, oBmpMask ),;
      ILAdd( ::hImageList, If( oBmpImage != nil, oBmpImage:hBitmap, 0 ),;
                           If( oBmpMask != nil, oBmpMask:hBitmap, 0 ) )

   METHOD AddIcon( oIcon )

   METHOD AddMasked( oBmpImage, nClrMask ) INLINE ;
      AAdd( ::aBitmaps, oBmpImage ),;
      ILAddMasked( ::hImageList, If( oBmpImage != nil, oBmpImage:hBitmap, 0 ),;
                   nClrMask )

   METHOD End()

   METHOD SetBkColor( nColor ) INLINE ILSetBkColor( ::hImageList, nColor )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nWidth, nHeight ) CLASS TImageList

   DEFAULT nWidth := 16, nHeight := 16

   ::hImageList = ILCreate( nWidth, nHeight )
   ::aBitmaps   = {}

return Self

//----------------------------------------------------------------------------//

METHOD AddIcon( oIcon ) CLASS TImageList

   local oIco

   if ValType( oIcon ) == "C"
      if File( "oIcon" )
         DEFINE ICON oIco FILENAME oIcon
      else
         DEFINE ICON oIco RESOURCE oIcon
      endif
   else
      oIco = oIcon
   endif

return ILAddIcon( ::hImageList, oIco:hIcon )

//----------------------------------------------------------------------------//

METHOD End() CLASS TImageList

   local n

   ILDestroy( ::hImageList )

   for n = 1 to Len( ::aBitmaps )
      ::aBitmaps[ n ]:End()
   next

   ::aBitmaps = {}

return nil

//----------------------------------------------------------------------------//