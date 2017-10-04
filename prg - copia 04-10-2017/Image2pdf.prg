// File    : Image2PDF.prg
// Author  : Utility Warrior, (c) 2005-2007
// Project : Image to PDF (Image2PDF) Dynamic Link Library
// Purpose : This file provides Harbour interfaces for all DLL functions
//           Many thanks to Don Lowenstein for his invaluable help and advice
//
// Notes  : a) Ensure that Image2PDF.DLL is either in the same directory as the
// 		       calling application or on the system path
//
// Please refer to the accompanying documentation for full details.


// *************************************************************************
// Required and Miscellaneous
// *************************************************************************
GLOBAL I2PDFDLL // Preserve DLL handle across multiple calls so that the DLL is only loaded once


FUNCTION I2PDF_LoadDLL( )
  LOCAL RESULT := .T.
  I2PDFDLL := LOADLIBRARY( "IMAGE2PDF.DLL" )
  IF ABS( I2PDFDLL ) <= 32
    RESULT := .F.
  ENDIF
RETURN RESULT
// This must be called before any other function


FUNCTION I2PDF_FreeDLL( )
  LOCAL RESULT := .T.
  IF !EMPTY( I2PDFDLL )
    RESULT := FREELIBRARY( I2PDFDLL )
  ENDIF
RETURN RESULT
// When you've finished creating PDFs and want to reclaim a bit of memory you can call this function
//
// Note: Calling this means that if you want to generate another PDF you will need to call the
//       I2PDF_LoadDLL function again - this also means that all previous settings will have been lost.


FUNCTION I2PDF_GetDLLVersion( )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_GetDLLVersion", PASCAL_TYPE, LONG )
    RETVAL := CALLDLL( CFARPROC )
  ENDIF
RETURN RETVAL
// This allows the support of multiple versions of a DLL (if and when
// available) so that functions that might only be available in a later version
// can then only be called if the returned version currently being used is one
// that supports those functions.
//
// Return value:
// -1 - DLL not loaded
// >0 - integer value representing the DLL version, a value of 100 is sequivalent to version 1.00


FUNCTION I2PDF_Log( logFilename, logLevel )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_Log", PASCAL_TYPE, LONG, LPSTR, LONG )
    RETVAL := CALLDLL( CFARPROC, logFilename, logLevel )
  ENDIF
RETURN RETVAL
// Information and error messages are appended to the end of the file specified (with a timestamp).
//
// Set logLevel to one or more (by adding required log levels together) of:
// 1 to log image width, height, bit depth and DPI for each image that is converted.
// 2 font matching information.
// 4 filename wildcard matching information.
// 8 Bates number information.
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid logFilename


FUNCTION I2PDF_License( code )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_License", PASCAL_TYPE, VOID, LPSTR)
    CALLDLL( CFARPROC, code)
    RETVAL := 0
  ENDIF
RETURN RETVAL
// This is required to remove the "Evaluation Mode" message that is stamped
// over the top of every page in the output PDF document.
//
// To purchase a license code please visit the Utility Warrior web site which
// has the latest information and prices on the licenses that are available.
//
// Return value:
// -1 - DLL not loaded
//  0 - success


FUNCTION I2PDF_WildcardFilenameUse( flags )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_WildcardFilenameUse", PASCAL_TYPE, LONG, LONG)
    RETVAL := CALLDLL( CFARPROC, flags)
  ENDIF
RETURN RETVAL
// This can only be specified if the PDF filename is *.pdf AND only one wildcarded
// image name is used.
//
// Note: This must be set BEFORE I2PDF_AddImage is used
//
// flags can be:
// 0 - default of one pdf produced per image with no recursion
// 1 - Per Directory (forces creation of a single PDF file - with the name of that directory and saved in that directory - for the entire contents of a directory rather than one per image
// 2 - Directory Recursion (wildcarded image filename is looked for in all sub-directories below the directory which is referenced by the wildcarded image name)
// 3 - both Per Directory and Directory Recursion
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - images have already been added


FUNCTION I2PDF_AddImage( image )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_AddImage", PASCAL_TYPE, LONG, LPSTR )
    RETVAL := CALLDLL( CFARPROC, image )
  ENDIF
RETURN RETVAL
// Specifies the name and location of an image to embed within the output PDF document.
//
// The image can be one of the following types: JPG, TIF, PNG, GIF, BMP, WMF, EMF, PCX or TGA.
//
// Up to 1000 images can be included.
//
// Images are embedded in the output PDF document in the order that they are referenced.
//
// Image filenames can contain the wildcard characters * and ? that allow multiple images
// to be referenced in one go. These characters can only be in the filename and not in any
// part of the filepath before the filename.
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid parameter
//  2 - maximum number of images already added
//  3 - invalid image type


FUNCTION I2PDF_AddImageBookmark( image, bookmark )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_AddImageBookmark", PASCAL_TYPE, LONG, LPSTR, LPSTR )
    RETVAL := CALLDLL( CFARPROC, image, bookmark )
  ENDIF
RETURN RETVAL
// Specifies the name and location of an image to embed within the output PDF
// document. The image can be one of the following types: JPG, TIF, PNG, GIF, BMP, WMF, EMF, PCX or TGA.
//
// Up to 1000 images can be included.
//
// Images are embedded in the output PDF document in the order that they are
// referenced.
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid image parameter
//  2 - maximum number of images already added
//  3 - invalid image type
//  4 - invalid bookmark parameter


FUNCTION I2PDF_TreatImageNumericExtensionAs( imageExtension )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_TreatImageNumericExtensionAs", PASCAL_TYPE, LONG, LPSTR )
    RETVAL := CALLDLL( CFARPROC, imageExtension )
  ENDIF
RETURN RETVAL
// Some images may have a numeric sequenced number extension (eg image.001, image.002 etc) which would normally prevent
// the image from being identified as a valid one. To get around this problem use this
// function and pass it the image extension type that a numeric extension will be interpreted
// as (eg ".jpg", ".tif", ".png", ".gif", ".bmp", ".wmf", ".emf", ".pcx", ".tga")
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - extension not specified
//  2 - extension does not start with a .
//  3 - extension is not 4 characters long


FUNCTION I2PDF_TreatImageTmpExtensionAs( imageExtension )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_TreatImageTmpExtensionAs", PASCAL_TYPE, LONG, LPSTR )
    RETVAL := CALLDLL( CFARPROC, imageExtension )
  ENDIF
RETURN RETVAL
// Some images may have a TMP extension which would normally prevent
// the image from being identified as a valid one. To get around this problem use this
// function and pass it the image extension type that a TMP extension will be interpreted
// as (eg ".jpg", ".tif", ".png", ".gif", ".bmp", ".wmf", ".emf", ".pcx", ".tga")
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - extension not specified
//  2 - extension does not start with a .
//  3 - extension is not 4 characters long


FUNCTION I2PDF_TreatImageExtensionAs( sourceExtension, targetExtension )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_TreatImageExtensionAs", PASCAL_TYPE, LONG, LPSTR, LPSTR )
    RETVAL := CALLDLL( CFARPROC, sourceExtension, targetExtension )
  ENDIF
RETURN RETVAL
// Some images may have a non-standard image extension which would normally prevent
// the image from being identified as a valid one. To get around this problem use this
// function to map one of these extensions as a known one
// (eg ".jpg", ".tif", ".png", ".gif", ".bmp", ".wmf", ".emf", ".pcx", ".tga")
//
// Return value:
// 0 - success
// 1 - source extension not specified
// 2 - source extension does not start with a .
// 3 - target extension not specified
// 4 - target extension does not start with a .
// 5 - target extension is not 4 characters long
// 6 - max image extension mappings already defined


FUNCTION I2PDF_MetaImageMaxMP( maxmp )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_MetaImageMaxMP", PASCAL_TYPE, LONG, DOUBLE )
    RETVAL := CALLDLL( CFARPROC, maxmp )
  ENDIF
RETURN RETVAL
// Specifies the meta image (EMF or WMF) maximum rendering size.
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid maxmp parameter


FUNCTION I2PDF_MetaImageScale( percentage )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_MetaImageScale", PASCAL_TYPE, LONG, DOUBLE )
    RETVAL := CALLDLL( CFARPROC, percentage )
  ENDIF
RETURN RETVAL
// Specifies the meta image (EMF or WMF) scaling factor.
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid percentage parameter


FUNCTION I2PDF_MetaImageScale_Int( percentage )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_MetaImageScale_Int", PASCAL_TYPE, LONG, LONG )
    RETVAL := CALLDLL( CFARPROC, percentage )
  ENDIF
RETURN RETVAL
// Specifies the meta image (EMF or WMF) scaling factor.
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid percentage parameter


FUNCTION I2PDF_MetaVerticalRenderScale( scale )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_MetaVerticalRenderScale", PASCAL_TYPE, LONG, DOUBLE )
    RETVAL := CALLDLL( CFARPROC, scale )
  ENDIF
RETURN RETVAL
// Specifies the meta image (EMF or WMF) vertical scaling factor during rendering.
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid scale parameter


FUNCTION I2PDF_MetaVerticalRenderScale_Int( scale )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_MetaVerticalRenderScale_Int", PASCAL_TYPE, LONG, LONG )
    RETVAL := CALLDLL( CFARPROC, scale )
  ENDIF
RETURN RETVAL
// Specifies the meta image (EMF or WMF) vertical scaling factor during rendering.
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid scale parameter


FUNCTION I2PDF_MetaMargins( )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_MetaMargins", PASCAL_TYPE, VOID )
    CALLDLL( CFARPROC )
    RETVAL := 0
  ENDIF
RETURN RETVAL
// Preserve the margins around the meta image (no matter how large they might be)
//
// Return value:
// -1 - DLL not loaded
//  0 - success


FUNCTION I2PDF_MetaToNativePDF( )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_MetaToNativePDF", PASCAL_TYPE, VOID )
    CALLDLL( CFARPROC )
    RETVAL := 0
  ENDIF
RETURN RETVAL
// Forces meta image files to be converted into a native PDF representation
//
// Return value:
// -1 - DLL not loaded
//  0 - success


FUNCTION I2PDF_CenterMetaImageOnPage( )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_CenterMetaImageOnPage", PASCAL_TYPE, VOID )
    CALLDLL( CFARPROC )
    RETVAL := 0
  ENDIF
RETURN RETVAL
// Force a native rendered page to have the contents centered on the page based on the content of the meta image that is actually rendered into the PDF
//
// Return value:
// -1 - DLL not loaded
//  0 - success


FUNCTION I2PDF_MetaBitmapForcedFontQuality( quality )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_MetaBitmapForcedFontQuality", PASCAL_TYPE, LONG, LONG )
    RETVAL := CALLDLL( CFARPROC, quality )
  ENDIF
RETURN RETVAL
// This API can only be used if the I2PDF_MetaToNativePDF API has NOT been used as it controls the font quality when rendering the meta image file into a bitmap.
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid quality


#define FORCED_FONT_QUALITY_DRAFT          1
#define FORCED_FONT_QUALITY_PROOF          2
#define FORCED_FONT_QUALITY_NONANTIALIASED 3
#define FORCED_FONT_QUALITY_ANIALIASED     4
#define FORCED_FONT_QUALITY_CLEARTYPE      5
FUNCTION I2PDF_MetaTextFitBoundingRect( )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_MetaTextFitBoundingRect", PASCAL_TYPE, VOID )
    CALLDLL( CFARPROC )
    RETVAL := 0
  ENDIF
RETURN RETVAL
// If text in a meta image file is larger than the defined bounding rectangle this command will progressively
// reduce the font size until it can fit the text within the defined bounding area.
//
// Return value:
// -1 - DLL not loaded
//  0 - success


FUNCTION I2PDF_UseEMFDeviceSize( )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_UseEMFDeviceSize", PASCAL_TYPE, VOID )
    CALLDLL( CFARPROC )
    RETVAL := 0
  ENDIF
RETURN RETVAL
// Determine the size of an EMF meta file by using the embedded reference device bounds.
//
// Return value:
// -1 - DLL not loaded
//  0 - success


#define VERTICAL_ALIGNMENT_TOP      1
#define VERTICAL_ALIGNMENT_MIDDLE	2
#define VERTICAL_ALIGNMENT_BOTTOM	3

#define HORIZONTAL_ALIGNMENT_LEFT	1
#define HORIZONTAL_ALIGNMENT_CENTER	2
#define HORIZONTAL_ALIGNMENT_RIGHT	3

FUNCTION I2PDF_ImageStamp( image, verticalPosition, horizontalPosition, margin )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_ImageStamp", PASCAL_TYPE, LONG, LPSTR, LONG, LONG, DOUBLE )
    RETVAL := CALLDLL( CFARPROC, image, verticalPosition, horizontalPosition, margin )
  ENDIF
RETURN RETVAL
// Specifies the name and location of an image that is "stamped" at the specified
// location on each page of the output PDF document. A margin between the image
// stamp and the edge of the page can be specified if required.
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid image parameter
//  2 - invalid vertical position
//  3 - invalid horizontal position
//  4 - invalid margin


FUNCTION I2PDF_ImageStamp_Int( image, verticalPosition, horizontalPosition, margin )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_ImageStamp_Int", PASCAL_TYPE, LONG, LPSTR, LONG, LONG, LONG )
    RETVAL := CALLDLL( CFARPROC, image, verticalPosition, horizontalPosition, margin )
  ENDIF
RETURN RETVAL
// Specifies the name and location of an image that is "stamped" at the specified
// location on each page of the output PDF document. A margin between the image
// stamp and the edge of the page can be specified if required.
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid image parameter
//  2 - invalid vertical position
//  3 - invalid horizontal position
//  4 - invalid margin


FUNCTION I2PDF_MetaStampImageMaxMP( maxmp )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_MetaStampImageMaxMP", PASCAL_TYPE, LONG, DOUBLE )
    RETVAL := CALLDLL( CFARPROC, maxmp )
  ENDIF
RETURN RETVAL
// Specifies the meta image (EMF or WMF)  rendering size for an image stamp.
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid maxmp parameter


FUNCTION I2PDF_MetaStampImageMaxMP_Int( maxmp )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_MetaStampImageMaxMP_Int", PASCAL_TYPE, LONG, LONG )
    RETVAL := CALLDLL( CFARPROC, maxmp )
  ENDIF
RETURN RETVAL
// Specifies the meta image (EMF or WMF) maximum rendering size for an image stamp.
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid maxmp parameter


FUNCTION I2PDF_MetaStampImageScale( percentage )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_MetaStampImageScale", PASCAL_TYPE, LONG, DOUBLE )
    RETVAL := CALLDLL( CFARPROC, percentage )
  ENDIF
RETURN RETVAL
// Specifies the meta image (EMF or WMF) scaling factor for an image stamp
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid percentage parameter


FUNCTION I2PDF_MetaStampImageScale_Int( percentage )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_MetaStampImageScale_Int", PASCAL_TYPE, LONG, LONG )
    RETVAL := CALLDLL( CFARPROC, percentage )
  ENDIF
RETURN RETVAL
// Specifies the meta image (EMF or WMF) scaling factor for an image stamp
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid percentage parameter


FUNCTION I2PDF_MetaDefaultFont( fontname )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_MetaDefaultFont", PASCAL_TYPE, LONG, LPSTR )
    RETVAL := CALLDLL( CFARPROC, fontname )
  ENDIF
RETURN RETVAL
// If a font cannot be matched then this allows the specification of one of the standard PDF fonts to be used:
//
// Courier
// Courier-Bold
// Courier-BoldOblique
// Courier-Oblique
// Helvetica
// Helvetica-Bold
// Helvetica-BoldOblique
// Helvetica-Oblique
// Times-Roman
// Times-Bold
// Times-Italic
// Times-BoldItalic
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid font name


FUNCTION I2PDF_StampURL( url )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_StampURL", PASCAL_TYPE, LONG, LPSTR )
    RETVAL := CALLDLL( CFARPROC, url )
  ENDIF
RETURN RETVAL
// This is optional and specifies the URL that the image stamp will open in the default browser when it is clicked on.
//
// A maximum of 128 characters can be used.
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid parameter


FUNCTION I2PDF_MetaToNativeFontSubstitution( fontSubs )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_MetaToNativeFontSubstitution", PASCAL_TYPE, LONG, LPSTR )
    RETVAL := CALLDLL( CFARPROC, fontSubs )
  ENDIF
RETURN RETVAL
// If a font cannot be matched (perhaps because it is not a True Type font with a CMAP record)
// then this allows an alternative font and specific character substitutions to be made.
//
// Return value:
// 0 - success
// 1 - invalid substitution description
// 2 - maximum number of substitution strings already defined


#define SLIDESHOW_WIPE_RIGHT						= 1
#define SLIDESHOW_WIPE_UP							= 2
#define SLIDESHOW_WIPE_LEFT							= 3
#define SLIDESHOW_WIPE_DOWN							= 4
#define SLIDESHOW_BARN_DOORS_HORIZONTAL_OUT			= 5
#define SLIDESHOW_BARN_DOORS_HORIZONTAL_IN			= 6
#define SLIDESHOW_BARN_DOORS_VERTICAL_OUT			= 7
#define SLIDESHOW_BARN_DOORS_VERTICAL_IN			= 8
#define SLIDESHOW_BOX_OUT							= 9
#define SLIDESHOW_BOX_IN							= 10
#define SLIDESHOW_BLINDS_HORIZONTAL					= 11
#define SLIDESHOW_BLINDS_VERTICAL					= 12
#define SLIDESHOW_DISSOLVE							= 13
#define SLIDESHOW_GLITTER_RIGHT						= 14
#define SLIDESHOW_GLITTER_DOWN						= 15
#define SLIDESHOW_GLITTER_TOP_LEFT_TO_BOTTOM_RIGHT	= 16
#define SLIDESHOW_REPLACE							= 17

FUNCTION I2PDF_SlideShow( transition, transitionDuration, pageDisplayDuration )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SlideShow", PASCAL_TYPE, LONG, LONG, DOUBLE, DOUBLE )
    RETVAL := CALLDLL( CFARPROC, transition, transitionDuration, pageDisplayDuration )
  ENDIF
RETURN RETVAL
// Forces the PDF document to be displayed full screen with the chosen screen transition between each page.
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid transition
//  2 - invalid transition duration
//  3 - invalid page display duration


FUNCTION I2PDF_SlideShow_Int( transition, transitionDuration, pageDisplayDuration )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SlideShow_Int", PASCAL_TYPE, LONG, LONG, LONG, LONG )
    RETVAL := CALLDLL( CFARPROC, transition, transitionDuration, pageDisplayDuration )
  ENDIF
RETURN RETVAL
// Forces the PDF document to be displayed full screen with the chosen screen transition between each page.
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid transition
//  2 - invalid transition duration
//  3 - invalid page display duration


FUNCTION I2PDF_DeleteImagesOnConvert( )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_DeleteImagesOnConvert", PASCAL_TYPE, LONG )
    CALLDLL( CFARPROC )
    RETVAL := 0
  ENDIF
RETURN RETVAL
// When the PDF document has been successfully produced all of the images converted to PDF are deleted.
//
// Return value:
// -1 - DLL not loaded
//  0 - success


FUNCTION I2PDF_SetBorder( left, top, right, bottom )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SetBorder", PASCAL_TYPE, LONG, DOUBLE, DOUBLE, DOUBLE, DOUBLE )
    RETVAL := CALLDLL( CFARPROC, left, top, right, bottom )
  ENDIF
RETURN RETVAL
// Allows a border to be inserted between the image and the edge of the PDF page.
// The border color can be specified by using one of the three I2PDF_SetBorderColor_Real/Int/Web APIs below.
// This can be useful if you want to add an image stamp to each page but do not want it to obscure the image.
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid left value
//  2 - invalid top value
//  3 - invalid right value
//  4 - invalid bottom value


FUNCTION I2PDF_SetBorder_Int( left, top, right, bottom )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SetBorder_Int", PASCAL_TYPE, LONG, LONG, LONG, LONG, LONG )
    RETVAL := CALLDLL( CFARPROC, left, top, right, bottom )
  ENDIF
RETURN RETVAL
// Allows a border to be inserted between the image and the edge of the PDF page.
// The border color can be specified by using one of the three I2PDF_SetBorderColor_Real/Int/Web APIs below.
// This can be useful if you want to add an image stamp to each page but do not want it to obscure the image.
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid left value
//  2 - invalid top value
//  3 - invalid right value
//  4 - invalid bottom value


FUNCTION I2PDF_SetBorderColor_Real( red, green, blue )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SetBorderColor_Real", PASCAL_TYPE, LONG, DOUBLE, DOUBLE, DOUBLE )
    RETVAL := CALLDLL( CFARPROC, red, green, blue )
  ENDIF
RETURN RETVAL
// Set the border color to use when I2PDF_SetBorder has been used.
// Color is made up of a combination of three components: red, green and blue.
// The value of each color component controls how much of that color is displayed, with a value of
// 0.0 representing none up to a value of 100.0 representing the maximum value.
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid red value
//  2 - invalid green value
//  3 - invalid blue value


FUNCTION I2PDF_SetBorderColor_Int( red, green, blue )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SetBorderColor_Int", PASCAL_TYPE, LONG, LONG, LONG, LONG )
    RETVAL := CALLDLL( CFARPROC, red, green, blue )
  ENDIF
RETURN RETVAL
// Set the border color to use when I2PDF_SetBorder has been used.
// Color is made up of a combination of three components: red, green and blue.
// The value of each color component controls how much of that color is displayed, with a value of
// 0 representing none up to a value of 255 representing the maximum value.
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid red value
//  2 - invalid green value
//  3 - invalid blue value


FUNCTION I2PDF_SetBorderColor_Web( color )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SetBorderColor_Web", PASCAL_TYPE, LONG, LPSTR )
    RETVAL := CALLDLL( CFARPROC, color )
  ENDIF
RETURN RETVAL
// Set the border color to use when I2PDF_SetBorder has been used.
// Color is made up of a combination of three components: red, green and blue.
// Web colours are specified by using three pairs of hexadecimal digits.
// The value of each color component controls how much of that color is displayed, with a value of
// 00 representing none up to a value of FF representing the maximum value.
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid color value


FUNCTION I2PDF_SilentRunning( )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SilentRunning", PASCAL_TYPE, VOID )
    CALLDLL( CFARPROC )
    RETVAL := 0
  ENDIF
RETURN RETVAL
// Prevents information from being printed to the console window
//
// Return value:
// -1 - DLL not loaded
//  0 - success


FUNCTION I2PDF_PreventPDFOverwrite( )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_PreventPDFOverwrite", PASCAL_TYPE, VOID )
    CALLDLL( CFARPROC )
    RETVAL := 0
  ENDIF
RETURN RETVAL
// Prevents an existing PDF from being overwritten
//
// Return value:
// -1 - DLL not loaded
//  0 - success


FUNCTION I2PDF_SaveFailureBackupPDF( filename )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SaveFailureBackupPDF", PASCAL_TYPE, LONG, LPSTR )
    RETVAL := CALLDLL( CFARPROC, filename )
  ENDIF
RETURN RETVAL
// Will save the PDF to a backup filename if the required file cannot be written (perhaps because another application has the target PDF currently open).
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid filename


FUNCTION I2PDF_IncludeTIFFOCRText( )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_IncludeTIFFOCRText", PASCAL_TYPE, VOID )
    CALLDLL( CFARPROC )
    RETVAL := 0
  ENDIF
RETURN RETVAL
// Includes any OCR'd text stored within the TIFF file (eg produced by Microsoft Document Imaging) as invisible "searchable" text within the PDF.
//
// Return value:
// -1 - DLL not loaded
//  0 - success


FUNCTION I2PDF_SaveTIFFOCRText( text )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SaveTIFFOCRText", PASCAL_TYPE, VOID, LPSTR )
    CALLDLL( CFARPROC, text )
    RETVAL := 0
  ENDIF
RETURN RETVAL
// Outputs any OCR'd text stored within the TIFF file (eg produced by Microsoft Document Imaging) into a text file with the same name and in the same location as the produced PDF.
//
// Return value:
// -1 - DLL not loaded
//  0 - success


FUNCTION I2PDF_LoadImageFailureCopyTo( copyToDir )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_LoadImageFailureCopyTo", PASCAL_TYPE, LONG, LPSTR )
    RETVAL := CALLDLL( CFARPROC, copyToDir )
  ENDIF
RETURN RETVAL
// Allows images that fail to be copied to the specified directory (for a manual or monitoring process to deal with).
//
// Return value:
// 0 - success
// 1 - invalid copyToDir


FUNCTION I2PDF_LoadImageFailureSkip( )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_LoadImageFailureSkip", PASCAL_TYPE, VOID )
    CALLDLL( CFARPROC )
    RETVAL := 0
  ENDIF
RETURN RETVAL
// Allows images that fail to be skipped over so that all valid images are still converted and a PDF produced.
//
// Return value: none


FUNCTION I2PDF_LoadImageFailurePage_Real( width, height, backgroundRed, backgroundGreen, backgroundBlue, message )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_LoadImageFailurePage_Real", PASCAL_TYPE, LONG, LONG, LONG, DOUBLE, DOUBLE, DOUBLE, LPSTR )
    RETVAL := CALLDLL( CFARPROC, width, height, backgroundRed, backgroundGreen, backgroundBlue, message )
  ENDIF
RETURN RETVAL
// Allows images that fail to still have a page in the PDF but with the required message.
//
// Return value:
// 0 - success
// 1 - invalid width
// 2 - invalid height
// 3 - invalid backgroundRed
// 4 - invalid backgroundGreen
// 5 - invalid backgroundBlue
// 6 - invalid message


FUNCTION I2PDF_LoadImageFailurePage_Int( width, height, backgroundRed, backgroundGreen, backgroundBlue, message )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_LoadImageFailurePage_Int", PASCAL_TYPE, LONG, LONG, LONG, LONG, LONG, LONG, LPSTR )
    RETVAL := CALLDLL( CFARPROC, width, height, backgroundRed, backgroundGreen, backgroundBlue, message )
  ENDIF
RETURN RETVAL
// Allows images that fail to still have a page in the PDF but with the required message.
//
// Return value:
// 0 - success
// 1 - invalid width
// 2 - invalid height
// 3 - invalid backgroundRed
// 4 - invalid backgroundGreen
// 5 - invalid backgroundBlue
// 6 - invalid message


FUNCTION I2PDF_LoadImageFailurePage_Web( width, height, backgroundColor, message )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_LoadImageFailurePage_Web", PASCAL_TYPE, LONG, LONG, LONG, LPSTR, LPSTR )
    RETVAL := CALLDLL( CFARPROC, width, height, backgroundColor, message )
  ENDIF
RETURN RETVAL
// Allows images that fail to still have a page in the PDF but with the required message.
//
// Return value:
// 0 - success
// 1 - invalid width
// 2 - invalid height
// 3 - invalid backgroundColor
// 4 - invalid message


FUNCTION I2PDF_LoadImageFailurePageFont_Real( size, font, fillRed, fillGreen, fillBlue, style, otherRed, otherGreen, otherBlue )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_LoadImageFailurePageFont_Real", PASCAL_TYPE, LONG, LONG, LPSTR, DOUBLE, DOUBLE, DOUBLE, LONG, DOUBLE, DOUBLE, DOUBLE )
    RETVAL := CALLDLL( CFARPROC, size, font, fillRed, fillGreen, fillBlue, style, otherRed, otherGreen, otherBlue )
  ENDIF
RETURN RETVAL
// Controls the display of the failure message text specified in I2PDF_LoadImageFailurePage_Real/Int/Web.
//
// Return value:
// 0 - success
// 1 - invalid size
// 2 - invalid font
// 3 - invalid fillRed
// 4 - invalid fillGreen
// 5 - invalid fillBlue
// 6 - invalid style
// 7 - invalid otherRed
// 8 - invalid otherGreen
// 9 - invalid otherBlue


FUNCTION I2PDF_LoadImageFailurePageFont_Int( size, font, fillRed, fillGreen, fillBlue, style, otherRed, otherGreen, otherBlue )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_LoadImageFailurePageFont_Int", PASCAL_TYPE, LONG, LONG, LPSTR, LONG, LONG, LONG, LONG, LONG, LONG, LONG )
    RETVAL := CALLDLL( CFARPROC, size, font, fillRed, fillGreen, fillBlue, style, otherRed, otherGreen, otherBlue )
  ENDIF
RETURN RETVAL
// Controls the display of the failure message text specified in I2PDF_LoadImageFailurePage_Real/Int/Web.
//
// Return value:
// 0 - success
// 1 - invalid size
// 2 - invalid font
// 3 - invalid fillRed
// 4 - invalid fillGreen
// 5 - invalid fillBlue
// 6 - invalid style
// 7 - invalid otherRed
// 8 - invalid otherGreen
// 9 - invalid otherBlue


FUNCTION I2PDF_LoadImageFailurePageFont_Web( size, font, fillColor, style, otherColor )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_LoadImageFailurePageFont_Web", PASCAL_TYPE, LONG, LONG, LPSTR, LPSTR, LONG, LPSTR )
    RETVAL := CALLDLL( CFARPROC, size, font, fillColor, style, otherColor)
  ENDIF
RETURN RETVAL
// Controls the display of the failure message text specified in I2PDF_LoadImageFailurePage_Real/Int/Web.
//
// Return value:
// 0 - success
// 1 - invalid size
// 2 - invalid font
// 3 - invalid fillColor
// 4 - invalid style
// 5 - invalid otherColor


// *************************************************************************
// Bates (Page/Document) Numbering
// *************************************************************************

FUNCTION I2PDF_BatesFormat( format )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_BatesFormat", PASCAL_TYPE, LONG, LPSTR )
    RETVAL := CALLDLL( CFARPROC, format )
  ENDIF
RETURN RETVAL
// Specifies the text to display on each page of the output PDF. This is typically
// a combination of static text plus one or more special Bates markup formatting labels.
// See the manual for full details.
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid format


FUNCTION I2PDF_BatesLocation( verticalPosition, horizontalPosition, orientation, margin )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_BatesLocation", PASCAL_TYPE, LONG, LONG, LONG, LONG, DOUBLE )
    RETVAL := CALLDLL( CFARPROC, verticalPosition, horizontalPosition, orientation, margin )
  ENDIF
RETURN RETVAL
// This is optional and specifies the location that the Bates "number" is displayed on each page of the output PDF document.
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid verticalPosition
//  2 - invalid horizontalPosition
//  3 - invalid textOrientation
//  4 - invalid margin


FUNCTION I2PDF_BatesLocation_Int( verticalPosition, horizontalPosition, orientation, margin )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_BatesLocation_Int", PASCAL_TYPE, LONG, LONG, LONG, LONG, LONG )
    RETVAL := CALLDLL( CFARPROC, verticalPosition, horizontalPosition, orientation, margin )
  ENDIF
RETURN RETVAL
// This is optional and specifies the location that the Bates "number" is displayed on each page of the output PDF document.
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid verticalPosition
//  2 - invalid horizontalPosition
//  3 - invalid textOrientation
//  4 - invalid margin


#define TEXT_STYLE_NORMAL					1
#define TEXT_STYLE_STROKE					2

FUNCTION I2PDF_BatesFont_Real( iSize, FontID, fillRed, fillGreen, fillBlue, iStyle, otherRed, otherGreen, otherBlue )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_BatesFont_Real", PASCAL_TYPE, LONG, LONG, LPSTR, DOUBLE, DOUBLE, DOUBLE, LONG, DOUBLE, DOUBLE, DOUBLE )
    RETVAL := CALLDLL( CFARPROC, iSize, FontID, fillRed, fillGreen, fillBlue, iStyle, otherRed, otherGreen, otherBlue )
  ENDIF
RETURN RETVAL
// This is optional and controls the display of the Bates "number".
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid size
//  2 - invalid fontID
//  3 - invalid fillRed
//  4 - invalid fillGreen
//  5 - invalid fillBlue
//  6 - invalid style
//  7 - invalid otherRed
//  8 - invalid otherGreen
//  9 - invalid otherBlue


FUNCTION I2PDF_BatesFont_Int( iSize, FontID, fillRed, fillGreen, fillBlue, iStyle, otherRed, otherGreen, otherBlue )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_BatesFont_Int", PASCAL_TYPE, LONG, LONG, LPSTR, LONG, LONG, LONG, LONG, LONG, LONG, LONG )
    RETVAL := CALLDLL( CFARPROC, iSize, FontID, fillRed, fillGreen, fillBlue, iStyle, otherRed, otherGreen, otherBlue )
  ENDIF
RETURN RETVAL
// This is optional and controls the display of the Bates "number".
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid size
//  2 - invalid fontID
//  3 - invalid fillRed
//  4 - invalid fillGreen
//  5 - invalid fillBlue
//  6 - invalid style
//  7 - invalid otherRed
//  8 - invalid otherGreen
//  9 - invalid otherBlue


FUNCTION I2PDF_BatesFont_Web( iSize, FontID, fillColor, iStyle, otherColor )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_BatesFont_Web", PASCAL_TYPE, LONG, LONG, LPSTR, LPSTR, LONG, LPSTR )
    RETVAL := CALLDLL( CFARPROC, iSize, FontID, fillColor, iStyle, otherColor )
  ENDIF
RETURN RETVAL
// This is optional and controls the display of the Bates "number".
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid size
//  2 - invalid fontID
//  3 - invalid fillColor
//  6 - invalid style
//  7 - invalid otherColor


FUNCTION I2PDF_BatesFile( filename )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_BatesFile", PASCAL_TYPE, LONG, LPSTR )
    RETVAL := CALLDLL( CFARPROC, filename )
  ENDIF
RETURN RETVAL
// This is optional but is useful if you want to have sequential numbering continue automatically between documents.
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid filename


FUNCTION I2PDF_BatesNumber( initialValue )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_BatesNumber", PASCAL_TYPE, LONG, LONG )
    RETVAL := CALLDLL( CFARPROC, initialValue )
  ENDIF
RETURN RETVAL
// This is optional and defines the initial Bates number used.
//
// Return value:
// -1 - DLL not loaded
//  0 - success


FUNCTION I2PDF_BatesIncrement( value )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_BatesIncrement", PASCAL_TYPE, LONG, LONG )
    RETVAL := CALLDLL( CFARPROC, value )
  ENDIF
RETURN RETVAL
// This is optional and defines the amount by which the Bates number is incremented with use.
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid value


#define BATES_BACKGROUND_FILLED_RECT		1
#define BATES_BACKGROUND_OUTLINE_RECT		2

FUNCTION I2PDF_BatesBackground_Real( shape, backgroundRed, backgroundGreen, backgroundBlue, borderRed, borderGreen, borderBlue )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_BatesBackground_Real", PASCAL_TYPE, LONG, LONG, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE )
    RETVAL := CALLDLL( CFARPROC, shape, backgroundRed, backgroundGreen, backgroundBlue, borderRed, borderGreen, borderBlue )
  ENDIF
RETURN RETVAL
// This is optional and if not specified no background is displayed behind the Bates "number".
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid shape
//  2 - invalid backgroundRed
//  3 - invalid backgroundGreen
//  4 - invalid backgroundBlue
//  5 - invalid borderRed
//  6 - invalid borderGreen
//  7 - invalid borderBlue


FUNCTION I2PDF_BatesBackground_Int( shape, backgroundRed, backgroundGreen, backgroundBlue, borderRed, borderGreen, borderBlue )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_BatesBackground_Int", PASCAL_TYPE, LONG, LONG, LONG, LONG, LONG, LONG, LONG, LONG )
    RETVAL := CALLDLL( CFARPROC, shape, backgroundRed, backgroundGreen, backgroundBlue, borderRed, borderGreen, borderBlue )
  ENDIF
RETURN RETVAL
// This is optional and if not specified no background is displayed behind the Bates "number".
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid shape
//  2 - invalid backgroundRed
//  3 - invalid backgroundGreen
//  4 - invalid backgroundBlue
//  5 - invalid borderRed
//  6 - invalid borderGreen
//  7 - invalid borderBlue


FUNCTION I2PDF_BatesBackground_Web( shape, backgroundColor, borderColor )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_BatesBackground_Web", PASCAL_TYPE, LONG, LONG, LPSTR, LPSTR )
    RETVAL := CALLDLL( CFARPROC, shape, backgroundColor, borderColor )
  ENDIF
RETURN RETVAL
// This is optional and if not specified no background is displayed behind the Bates "number".
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid shape
//  2 - invalid backgroundColor
//  3 - invalid borderColor


// *************************************************************************
// Image Transformations
// *************************************************************************

FUNCTION I2PDF_Rotate( angle )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_Rotate", PASCAL_TYPE, LONG, LONG )
    RETVAL := CALLDLL( CFARPROC, angle )
  ENDIF
RETURN RETVAL
// Rotate image clockwise by a fixed amount (90, 180 or 270 degrees)
//
// Return value:
// -1 - DLL not loaded
// 0 - success
// 1 - invalid angle


#define AUTOROTATE_PORTRAIT		= 1
#define AUTOROTATE_LANDSCAPE	= 2

FUNCTION I2PDF_AutoRotate( orientation, angle )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_AutoRotate", PASCAL_TYPE, LONG, LONG, LONG )
    RETVAL := CALLDLL( CFARPROC, orientation, angle )
  ENDIF
RETURN RETVAL
// Rotate image clockwise (if required) by a fixed amount (90 or 270 degrees)
// so that it is in portrait or landscape orientation
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid orientation
//  2 - invalid angle


#define FLIP_HORIZONTAL	    = 1
#define FLIP_VERTICAL		= 2

FUNCTION I2PDF_Flip( orientation )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_Flip", PASCAL_TYPE, LONG, LONG )
    RETVAL := CALLDLL( CFARPROC, orientation )
  ENDIF
RETURN RETVAL
// Flip image horizontally (mirroring) or vertically
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid orientation


FUNCTION I2PDF_Grayscale( )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_Grayscale", PASCAL_TYPE, LONG )
    CALLDLL( CFARPROC )
    RETVAL := 0
  ENDIF
RETURN RETVAL
// Ensure that an image is in grayscale - if it is in color it will be converted
//
// Return value:
// -1 - DLL not loaded
//  0 - success


FUNCTION I2PDF_Negative( )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_Negative", PASCAL_TYPE, LONG )
    CALLDLL( CFARPROC )
    RETVAL := 0
  ENDIF
RETURN RETVAL
// Invert (negative) image
//
// Return value:
// -1 - DLL not loaded
//  0 - success


FUNCTION I2PDF_JpegCompress( quality )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_JpegCompress", PASCAL_TYPE, LONG, LONG )
    RETVAL := CALLDLL( CFARPROC, quality )
  ENDIF
RETURN RETVAL
// Force re-compression of all JPEG images, quality can be between 1 (low)
// to 35 (high). A value of 0 will turn re-compression off.
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid angle


// *************************************************************************
// PDF Settings
// *************************************************************************

#define OUTLINE_FORMAT_FILENAME	= 1
#define OUTLINE_FORMAT_NAME		= 2

#define STYLE_NONE				= 0
#define STYLE_LOWERCASE			= 1
#define STYLE_UPPERCASE			= 2
#define STYLE_CAPITALISE		= 3

FUNCTION I2PDF_SetOutline( format, style )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SetOutline", PASCAL_TYPE, LONG, LONG, LONG )
    RETVAL := CALLDLL( CFARPROC, format, style )
  ENDIF
RETURN RETVAL
// This turns on the generation of a bookmark for each image that is in the
// output PDF document.
//
// format can be either "filename" (this is the name of the image file including
// the image extension but not including the full filepath) or "name" (same as
// filename but without the image extension).
//
// style can be: "lowercase", "uppercase", "capitalise" or "none".
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid format parameter
//  2 - invalid style parameter


FUNCTION I2PDF_SetOutlineTitle( title )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SetOutlineTitle", PASCAL_TYPE, LONG, LPSTR )
    RETVAL := CALLDLL( CFARPROC, title )
  ENDIF
RETURN RETVAL
// If an outline is created this will set the title to be used instead of the default one.
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - title not specified
//  2 - title too long


#define PDF_PERMISSION_READ_ONLY      = 0
#define PDF_PERMISSION_EDIT		      = 1
#define PDF_PERMISSION_EDIT_EXTRA     = 2
#define PDF_PERMISSION_COPY           = 4
#define PDF_PERMISSION_PRINT          = 8

FUNCTION I2PDF_SetPermissions( iPermissions )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SetPermissions", PASCAL_TYPE, LONG, LONG )
    RETVAL := CALLDLL( CFARPROC, iPermissions )
  ENDIF
RETURN RETVAL
// Allows the setting of any combination of permissions in one go
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid permissions


FUNCTION I2PDF_SetPermissionEdit( )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SetPermissionEdit", PASCAL_TYPE, LONG )
    CALLDLL( CFARPROC )
    RETVAL := 0
  ENDIF
RETURN RETVAL
// Allows editing/changing of the PDF document but NOT adding or changing of text
// notes and AcroForm fields.
//
// Return value:
// -1 - DLL not loaded
//  0 - success


FUNCTION I2PDF_SetPermissionEditExtra( )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SetPermissionEditExtra", PASCAL_TYPE, LONG )
    CALLDLL( CFARPROC )
    RETVAL := 0
  ENDIF
RETURN RETVAL
// Allows the adding and changing of text notes and AcroForm fields within a PDF document.
//
// Return value:
// -1 - DLL not loaded
//  0 - success


FUNCTION I2PDF_SetPermissionCopy( )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SetPermissionCopy", PASCAL_TYPE, LONG )
    CALLDLL( CFARPROC )
    RETVAL := 0
  ENDIF
RETURN RETVAL
// Allows the copying of text and graphics from the PDF document.
//
// Return value:
// -1 - DLL not loaded
//  0 - success


FUNCTION I2PDF_SetPermissionPrint( )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SetPermissionPrint", PASCAL_TYPE, LONG )
    CALLDLL( CFARPROC )
    RETVAL := 0
  ENDIF
RETURN RETVAL
// Allows printing of the PDF document.
//
// Return value:
// -1 - DLL not loaded
//  0 - success


FUNCTION I2PDF_SetOwnerPassword( password )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SetOwnerPassword", PASCAL_TYPE, LONG, LPSTR )
    RETVAL := CALLDLL( CFARPROC, password )
  ENDIF
RETURN RETVAL
// The owner of a PDF document would enter this password in order to view it
// and make changes and perform actions that may be restricted to a normal user.
//
// A maximum of 32 characters can be used.
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid parameter


FUNCTION I2PDF_SetUserPassword( password )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SetUserPassword", PASCAL_TYPE, LONG, LPSTR )
    RETVAL := CALLDLL( CFARPROC, password )
  ENDIF
RETURN RETVAL
// In order that only the intended user can view the PDF document, they must type
// in this password, otherwise the user is not allowed to read the PDF document.
//
// A maximum of 32 characters can be used.
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid parameter


FUNCTION I2PDF_SetDPI( dpi )
  LOCAL CFARPROC, RETVAL := -1
    IF !EMPTY( I2PDFDLL )
      CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SetDPI", PASCAL_TYPE, LONG, LONG )
      RETVAL := CALLDLL( CFARPROC, dpi )
    ENDIF
RETURN RETVAL
// PDF documents use a default resolution setting of 72 DPI. Images created for
// screen display under Windows will probably have a resolution of 96 DPI. If you
// have created images for printing then you will probably need to use 300 or 600 DPI.
//
// If you do not adjust the default resolution setting then when displayed within a
// PDF document on screen a 96 DPI image will appear 25% larger than expected. This
// gets much worse for a 300 DPI image which will appear 416% larger than expected.
//
// dpi must be between 9 and 2880 inclusive, or 0 to force the use of the actual
// image dpi that is recorded in the image file
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid parameter - dpi specified is less than 9
//  2 - invalid parameter - dpi specified is greater than 2880


// *************************************************************************
// PDF Meta Information
// *************************************************************************

FUNCTION I2PDF_SetProducer( infotext )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SetProducer", PASCAL_TYPE, LONG, LPSTR )
    RETVAL := CALLDLL( CFARPROC, infotext )
  ENDIF
RETURN RETVAL
// The name of the application that converted the document from its native format to PDF.
//
// A maximum of 256 characters can be used.
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid parameter


FUNCTION I2PDF_SetCreator( infotext )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SetCreator", PASCAL_TYPE, LONG, LPSTR )
    RETVAL := CALLDLL( CFARPROC, infotext )
  ENDIF
RETURN RETVAL
// If the document was converted into a PDF document from another form, this is
// usually the name of the application that created the original document.
//
// A maximum of 256 characters can be used.
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid parameter


FUNCTION I2PDF_SetAuthor( infotext )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SetAuthor", PASCAL_TYPE, LONG, LPSTR )
    RETVAL := CALLDLL( CFARPROC, infotext )
  ENDIF
RETURN RETVAL
// The name of the person who created the PDF document.
//
// A maximum of 256 characters can be used.
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid parameter


FUNCTION I2PDF_SetTitle( infotext )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SetTitle", PASCAL_TYPE, LONG, LPSTR )
    RETVAL := CALLDLL( CFARPROC, infotext )
  ENDIF
RETURN RETVAL
// The PDF document's title.
//
// A maximum of 256 characters can be used.
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid parameter


FUNCTION I2PDF_SetSubject( infotext )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SetSubject", PASCAL_TYPE, LONG, LPSTR )
    RETVAL := CALLDLL( CFARPROC, infotext )
  ENDIF
RETURN RETVAL
// The PDF document's subject.
//
// A maximum of 256 characters can be used.
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid parameter


FUNCTION I2PDF_SetKeywords( infotext )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SetKeywords", PASCAL_TYPE, LONG, LPSTR )
    RETVAL := CALLDLL( CFARPROC, infotext )
  ENDIF
RETURN RETVAL
// A list of keywords associated with the PDF document.
//
// A maximum of 256 characters can be used.
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid parameter


FUNCTION I2PDF_SetCreationDate( )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SetCreationDate", PASCAL_TYPE, LONG )
    CALLDLL( CFARPROC )
    RETVAL := 0
  ENDIF
RETURN RETVAL
// The date that the PDF document was created.
//
// This is set using the current local time of the PC.
//
// Return value:
// -1 - DLL not loaded
//  0 - success


// *************************************************************************
// PDF Viewer Preferences
// *************************************************************************

FUNCTION I2PDF_SetViewerPreferenceCenterWindow( )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SetViewerPreferenceCenterWindow", PASCAL_TYPE, LONG )
    CALLDLL( CFARPROC )
    RETVAL := 0
  ENDIF
RETURN RETVAL
// The window displaying the PDF document should be displayed in the center of
// the computer's screen.
//
// Return value:
// -1 - DLL not loaded
//  0 - success


FUNCTION I2PDF_SetViewerPreferenceHideToolbar( )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SetViewerPreferenceHideToolbar", PASCAL_TYPE, LONG )
    CALLDLL( CFARPROC )
    RETVAL := 0
  ENDIF
RETURN RETVAL
// The PDF viewer's toolbar should be hidden when the PDF document is active.
//
// Return value:
// -1 - DLL not loaded
//  0 - success


FUNCTION I2PDF_SetViewerPreferenceHideMenubar( )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SetViewerPreferenceHideMenubar", PASCAL_TYPE, LONG )
    CALLDLL( CFARPROC )
    RETVAL := 0
  ENDIF
RETURN RETVAL
// The PDF viewer's menubar should be hidden when the PDF document is active.
//
// Return value:
// -1 - DLL not loaded
//  0 - success


FUNCTION I2PDF_SetViewerPreferenceHideWindowUI( )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SetViewerPreferenceHideWindowUI", PASCAL_TYPE, LONG )
    CALLDLL( CFARPROC )
    RETVAL := 0
  ENDIF
RETURN RETVAL
// The user interface elements within the PDF document's window should be hidden.
//
// Return value:
// -1 - DLL not loaded
//  0 - success


FUNCTION I2PDF_SetViewerPreferenceFitWindow( )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SetViewerPreferenceFitWindow", PASCAL_TYPE, LONG )
    CALLDLL( CFARPROC )
    RETVAL := 0
  ENDIF
RETURN RETVAL
// The PDF viewer should resize the window displaying the PDF document to fit the
// size of the first displayed page of the PDF document.
//
// Return value:
// -1 - DLL not loaded
//  0 - success


FUNCTION I2PDF_SetPageModeOutlines( )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SetPageModeOutlines", PASCAL_TYPE, LONG )
    CALLDLL( CFARPROC )
    RETVAL := 0
  ENDIF
RETURN RETVAL
// The PDF viewer should show the outline (ie bookmark) navigation item when the
// PDF document is open.
//
// Return value:
// -1 - DLL not loaded
//  0 - success


FUNCTION I2PDF_SetPageModeNone( )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SetPageModeNone", PASCAL_TYPE, LONG )
    CALLDLL( CFARPROC )
    RETVAL := 0
  ENDIF
RETURN RETVAL
// The PDF viewer should not show the outline (ie bookmark) or thumbnail navigation
// items when the PDF document is open.
//
// This is the default if no other page mode is specified.
//
// Return value:
// -1 - DLL not loaded
//  0 - success


FUNCTION I2PDF_SetPageModeUseThumbs( )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SetPageModeUseThumbs", PASCAL_TYPE, LONG )
    CALLDLL( CFARPROC )
    RETVAL := 0
  ENDIF
RETURN RETVAL
// The PDF viewer should show the thumbnail navigation item when the PDF document
// is open.
//
// Return value:
// -1 - DLL not loaded
//  0 - success


FUNCTION I2PDF_SetPageModeFullScreen( )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SetPageModeFullScreen", PASCAL_TYPE, LONG )
    CALLDLL( CFARPROC )
    RETVAL := 0
  ENDIF
RETURN RETVAL
// The PDF viewer should open the PDF document in full-screen mode without showing
// the menu bar, window controls or any other window.
//
// Return value:
// -1 - DLL not loaded
//  0 - success


FUNCTION I2PDF_SetPageLayoutSinglePage( )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SetPageLayoutSinglePage", PASCAL_TYPE, LONG )
    CALLDLL( CFARPROC )
    RETVAL := 0
  ENDIF
RETURN RETVAL
// Display the pages one page at a time.
//
// Return value:
// -1 - DLL not loaded
//  0 - success


FUNCTION I2PDF_SetPageLayoutOneColumn( )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SetPageLayoutOneColumn", PASCAL_TYPE, LONG )
    CALLDLL( CFARPROC )
    RETVAL := 0
  ENDIF
RETURN RETVAL
// Display the pages in one column.
//
// Return value:
// -1 - DLL not loaded
//  0 - success


FUNCTION I2PDF_SetPageLayoutTwoColumnLeft( )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SetPageLayoutTwoColumnLeft", PASCAL_TYPE, LONG )
    CALLDLL( CFARPROC )
    RETVAL := 0
  ENDIF
RETURN RETVAL
// Display the pages in two columns, with odd-numbered pages on the left.
//
// Return value:
// -1 - DLL not loaded
//  0 - success


FUNCTION I2PDF_SetPageLayoutTwoColumnRight( )
  LOCAL CFARPROC, RETVAL := -1
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_SetPageLayoutTwoColumnRight", PASCAL_TYPE, LONG )
    CALLDLL( CFARPROC )
    RETVAL := 0
  ENDIF
RETURN RETVAL
// Display the pages in two columns, with odd-numbered pages on the right.
//
// Return value:
// -1 - DLL not loaded
//  0 - success


#define OPTION_NONE			0
#define OPTION_OPEN_PDF		1
#define OPTION_RESET		2

FUNCTION I2PDF_MakePDF( outputpdf, options )
  LOCAL CFARPROC, RETVAL := -1
  LOCAL maxErrorTextSize := 300
  LOCAL errortext := SPACE( maxErrorTextSize )
  IF !EMPTY( I2PDFDLL )
    CFARPROC := GetProcAddress( I2PDFDLL, "I2PDF_MakePDF", PASCAL_TYPE, LONG, LPSTR, LONG, LPSTR, LONG )
    RETVAL := CALLDLL( CFARPROC, outputpdf, options, @errorText, maxErrorTextSize )
  ENDIF
RETURN RETVAL
// Generate the output PDF according to the settings already selected through
// the Application Programming Interface functions above.
//
// To have the output PDF open in the default PDF viewer set the OPTION_OPEN_PDF
// bit flag in the options parameter.
//
// To have all settings applied reset after PDF has been generated set the OPTION_RESET
// bit flag in the options parameter.
//
// Return value:
// -1 - DLL not loaded
//  0 - success
//  1 - invalid parameter
//  2 - output pdf could not be opened
//  3 - internal PDF generation error - error description returned in errorText
//  4 - PDF file already exists and could not be overwritten - it is possibly being held open by a PDF viewer application