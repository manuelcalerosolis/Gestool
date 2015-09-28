#ifndef _GTF_CH
#define _GTF_CH

// #define ES_LEFT                 0
// #define ES_RIGHT                2
// #define ES_CENTER               1

/*----------------------------------------------------------------------------//
!short: DEFINEGTF  */

#xcommand DEFINE GTF FONT <nFont> ;
             [ NAME <cName> ] ;
             [ HEIGHT <nHeight> ] ;
             [ WIDTH <nWidth> ];
             [ <bold: BOLD> ] ;
             [ <italic: ITALIC> ] ;
             [ <underline: UNDERLINE> ] ;
             [ <strikeout: STRIKEOUT> ] ;
       => ;
             <nFont> := GTFFont( <cName>, <nHeight>, <nWidth>,;
                  [<.bold.>], [<.italic.>], [<.underline.>], [<.strikeout.>] )

#xcommand DEFINE GTF FORMAT <nFormat> ;
             [ ALIGN <nAlign> ] ;
             [ FONT <nFont> ] ;
             [ COLOR <nColor> ] ;
       => ;
            <nFormat> := GTFFormat( [<nAlign>], [<nFont>], [<nColor>] )

/*----------------------------------------------------------------------------//
!short: FILEGTF  */

#xcommand GTF <oGTF> [ FILE  <cFile> ] ;
       => ;
              <oGTF> := TFileGTF():New( <(cFile)> )

#xcommand GTF WRITE [ <uVal> ] [ OF <oGTF> ] ;
               [ FORMAT <nFormat> ] ;
               [ ALIGN <nAlign> ] ;
               [ FONT <nFont> ] ;
               [ COLOR <nColor> ] ;
               [ <return: RETURN> ] ;
       => ;
             <oGTF>:Write( <uVal>, <nFormat>, ;
                  [<nAlign>], [<nFont>], [<nColor>], <.return.> )

#xcommand GTF RETURN [ OF <oGTF> ] ;
       => ;
             <oGTF>:_Return()

#xcommand ENDGTF <oGTF> => <oGTF>:End()

//----------------------------------------------------------------------------//

#xcommand SET GTF FORMAT <nFormat> => SetGTFFormat( <nFormat> )

#xcommand SET GTF ALIGN <nAlign>   => SetGTFAlign( <nAlign> )
#xcommand SET GTF FONT <nFont>     => SetGTFFont( <nFont> )
#xcommand SET GTF COLOR <nColor>   => SetGTFColor( <nColor> )

#endif

//----------------------------------------------------------------------------//
// FileGTF by Ramón Avendaño
