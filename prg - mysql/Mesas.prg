#include "fivewin.ch"

function main()
local oWnd
local oBar
local oMenu, bWhen, oIL

local oCarpeta0
local oGrp1
local oBtn1
local oBtn2
local oBtn3
local oBtn4
local oGrp2
local oBtn5
local oBtn6
local oBtn7
local oBtn8
local oBtn9
local oBtn10
local oBtn11
local oBtn12
local oBtn13
local oBtn14
local oBtn15
local oBtn16
local oGrp3
local oBtn17
local oBtn18
local oBtn19
local oBtn20
local oBtn21
local oBtn22
local oBtn23
local oBtn24
local oBtn25
local oBtn26
local oBtn27
local oBtn28
local oBtn29
local oGrp5
local oCarpeta1
local oGrp8
local oBtn30
local oGrp9
local oBtn31
local oBtn33
local oBtn34
local oGrp10
local oBtn35
local oGrp11
local oBtn36
local oBtn37
local oBtn38
local oBtn39
local oGrp12
local oBtn40
local oBtn41
local oBtn42
local oCarpeta2
local oGrp13
local oBtn43
local oBtn44
local oBtn45
local oBtn46
local oGrp14
local oBtn47
local oBtn48
local oBtn49
local oBtn50
local oBtn51
local oBtn52
local oBtn53
local oCarpeta3
local oGrp15
local oBtn54
local oBtn55
local oBtn56
local oBtn57
local oGrp16
local oBtn58
local oBtn59
local oBtn60
local oBtn61
local oGrp17
local oBtn62
local oBtn63
local oBtn64
local oGrp18
local oBtn65
local oCarpeta4
local oGrp19
local oBtn66
local oBtn67
local oBtn68
local oBtn69
local oGrp20
local oBtn70
local oBtn71
local oBtn72
local oBtn73
local oBtn74
local oBtn75
local oBtn76
local oBtn77
local oBtn78
local oBtn79
local oBtn80
local oBtn81
local oCarpeta5
local oGrp21
local oBtn82
local oBtn83
local oBtn84
local oBtn85
local oBtn86
local oBtn87
local oBtn88
local oGrp22
local oBtn89
local oBtn90
local oBtn91
local oBtn92
local oBtn93
local oBtn94
local oBtn95
local oCarpeta6
local oGrp23
local oBtn96
local oBtn97
local oBtn98
local oGrp24
local oBtn99
local oBtn100
local oBtn101
local oGrp25
local oBtn102
local oBtn103
local oBtn104
local oGrp26
local oBtn105
local oBtn106
local oBtn107
local oCarpeta7
local oGrp27
local oBtn108
local oBtn109
local oBtn110
local oGrp28
local oBtn111
local oBtn112
local oBtn113

local oFont

DEFINE FONT oFont NAME "Segoe UI" SIZE 0, -11


DEFINE WINDOW oWnd  TITLE "Office Bar sample"

//Inicio Definición

      oBar           := TDotNetBar():New( 0, 0, 1000, 120, oWnd, 1 )
      oBar:oFont     := oFont
      oBar:lPaintAll := .f.

      oBar:SetStyle( 1 )

      oWnd:oTop      := oBar

      oCarpeta0      := TCarpeta():New( oBar, "Write" )

         Grp1        := TDotNetGroup():New( oCarpeta0, 165, "ClipBoard", .f.,, "" )
            oBtn1    := TDotNetButton():New( 60, oGrp1, "g:\canal5\dotnetba\samples\prueba5\bmps\paste.bmp","New item", 1, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
            oBtn2    := TDotNetButton():New( 60, oGrp1, "bmpsmall\cut.bmp","Cut", 2, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
            oBtn3    := TDotNetButton():New( 60, oGrp1, "bmpsmall\copy.bmp","Copy", 2, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
            oBtn4    := TDotNetButton():New( 100, oGrp1, "bmpsmall\brush.bmp","Format Painter", 2, {|| .t.},  oMenu , bWhen, .f., .f., .f. )

         oGrp2       := TDotNetGroup():New( oCarpeta0, 270, "Font", .t.,, "" )
            oBtn5    := TDotNetButton():New( 120, oGrp2, "","Times New Roman", 1, {|| .t.},  oMenu , bWhen, .t., .t., .t. )
            oBtn6    := TDotNetButton():New( 40, oGrp2, "","12", 1, {|| .t.},  oMenu , bWhen, .t., .t., .t. )
            oBtn7    := TDotNetButton():New( 30, oGrp2, "bmpsmall\upper.bmp","", 1, {|| .t.},  oMenu , bWhen, .t., .t., .f. )
            oBtn8    := TDotNetButton():New( 30, oGrp2, "bmpsmall\lower.bmp","", 1, {|| .t.},  oMenu , bWhen, .t., .f., .t. )
            oBtn9    := TDotNetButton():New( 30, oGrp2, "bmpsmall\delete.bmp","", 1, {|| .t.},  oMenu , bWhen, .t., .t., .t. )
            oBtn10   := TDotNetButton():New( 30, oGrp2, "bmpsmall\bold.bmp","", 1, {|| .t.},  oMenu , bWhen, .t., .t., .f. )
            oBtn11   := TDotNetButton():New( 30, oGrp2, "bmpsmall\italic.bmp","", 1, {|| .t.},  oMenu , bWhen, .t., .f., .f. )
            oBtn12   := TDotNetButton():New( 40, oGrp2, "bmpsmall\under.bmp","", 1, {|| .t.},  oMenu , bWhen, .t., .f., .f. )
            oBtn13   := TDotNetButton():New( 30, oGrp2, "bmpsmall\abc.bmp","", 1, {|| .t.},  oMenu , bWhen, .t., .f., .f. )
            oBtn14   := TDotNetButton():New( 30, oGrp2, "bmpsmall\sub.bmp","", 1, {|| .t.},  oMenu , bWhen, .t., .f., .f. )
            oBtn15   := TDotNetButton():New( 30, oGrp2, "bmpsmall\super.bmp","", 1, {|| .t.},  oMenu , bWhen, .t., .f., .f. )
            oBtn16   := TDotNetButton():New( 30, oGrp2, "bmpsmall\aaa.bmp","", 1, {|| .t.},  oMenu , bWhen, .t., .f., .t. )

         oGrp3       := TDotNetGroup():New( oCarpeta0, 230, "Paragraph", .t.,, "" )
            oBtn17   := TDotNetButton():New( 30, oGrp3, "bmpsmall\list1.bmp","", 1, {|| .t.},  oMenu , bWhen, .t., .t., .f. )
            oBtn18   := TDotNetButton():New( 30, oGrp3, "bmpsmall\list2.bmp","", 1, {|| .t.},  oMenu , bWhen, .t., .f., .f. )
            oBtn19   := TDotNetButton():New( 30, oGrp3, "bmpsmall\list3.bmp","", 1, {|| .t.},  oMenu , bWhen, .t., .f., .t. )
            oBtn20   := TDotNetButton():New( 30, oGrp3, "bmpsmall\toleft.bmp","", 1, {|| .t.},  oMenu , bWhen, .t., .t., .f. )
            oBtn21   := TDotNetButton():New( 30, oGrp3, "bmpsmall\toright.bmp","", 1, {|| .t.},  oMenu , bWhen, .t., .f., .t. )
            oBtn22   := TDotNetButton():New( 40, oGrp3, "bmpsmall\delete.bmp","", 1, {|| .t.},  oMenu , bWhen, .t., .t., .t. )
            oBtn23   := TDotNetButton():New( 30, oGrp3, "bmpsmall\alleft.bmp","", 1, {|| .t.},  oMenu , bWhen, .t., .t., .f. )
            oBtn24   := TDotNetButton():New( 30, oGrp3, "bmpsmall\alcent.bmp","", 1, {|| .t.},  oMenu , bWhen, .t., .f., .f. )
            oBtn25   := TDotNetButton():New( 30, oGrp3, "bmpsmall\alright.bmp","", 1, {|| .t.},  oMenu , bWhen, .t., .f., .f. )
            oBtn26   := TDotNetButton():New( 30, oGrp3, "bmpsmall\alajust.bmp","", 1, {|| .t.},  oMenu , bWhen, .t., .f., .t. )
            oBtn27   := TDotNetButton():New( 30, oGrp3, "bmpsmall\altobo.bmp","", 1, {|| .t.},  oMenu , bWhen, .t., .t., .f. )
            oBtn28   := TDotNetButton():New( 30, oGrp3, "bmpsmall\fill.bmp","", 1, {|| .t.},  oMenu , bWhen, .t., .f., .f. )
            oBtn29   := TDotNetButton():New( 29, oGrp3, "bmpsmall\table.bmp","", 1, {|| .t.},  oMenu , bWhen, .t., .f., .t. )

   oCarpeta1         := TCarpeta():New( oBar, "Insert" )

            oGrp8 := TDotNetGroup():New( oCarpeta1, 60, "Shapes", .f.,, "" )
                oBtn30 := TDotNetButton():New( 55, oGrp8, "bmps32\formas.bmp","Formas", 1, {|| .t.},  oMenu , bWhen, .f., .f., .f. )


            oGrp9 := TDotNetGroup():New( oCarpeta1, 120, "Páginas", .f.,, "" )
                oBtn31 := TDotNetButton():New( 80, oGrp9, "bmpsmall\portada.bmp","Portada", 1, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn33 := TDotNetButton():New( 113, oGrp9, "bmpsmall\pagwhite.bmp","Pagina en blanco", 1, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn34 := TDotNetButton():New( 90, oGrp9, "bmpsmall\pagbreak.bmp","Page break", 1, {|| .t.},  oMenu , bWhen, .f., .f., .f. )


            oGrp10 := TDotNetGroup():New( oCarpeta1, 60, "Tabla", .f.,, "" )
                oBtn35 := TDotNetButton():New( 55, oGrp10, "bmps32\table.bmp","New item", 1, {|| .t.},  oMenu , bWhen, .f., .f., .f. )


            oGrp11 := TDotNetGroup():New( oCarpeta1, 250, "Ilustraciones", .f.,, "" )
                oBtn36 := TDotNetButton():New( 55, oGrp11, "bmps32\picture.bmp","Picture", 1, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn37 := TDotNetButton():New( 70, oGrp11, "bmps32\image.bmp","Imagenes Prediseñadas", 2, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn38 := TDotNetButton():New( 55, oGrp11, "bmps32\smart.bmp","IGX Graphic", 3, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn39 := TDotNetButton():New( 55, oGrp11, "bmps32\chart.bmp","Chart", 4, {|| .t.},  oMenu , bWhen, .f., .f., .f. )


            oGrp12 := TDotNetGroup():New( oCarpeta1, 210, "Links", .f.,, "" )
                oBtn40 := TDotNetButton():New( 60, oGrp12, "bmps32\link.bmp","Hiperlink", 1, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn41 := TDotNetButton():New( 60, oGrp12, "bmps32\bookmark.bmp","BookMark", 2, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn42 := TDotNetButton():New( 85, oGrp12, "bmps32\cross.bmp","Cross-reference", 3, {|| .t.},  oMenu , bWhen, .f., .f., .f. )



       oCarpeta2 := TCarpeta():New( oBar, "Page Layout" )
            oGrp13 := TDotNetGroup():New( oCarpeta2, 150, "Themes", .f.,, "" )
                oBtn43 := TDotNetButton():New( 60, oGrp13, "bmps32\themes.bmp","Themes", 1, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn44 := TDotNetButton():New( 70, oGrp13, "bmps32\colors.bmp","Colors", 2, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn45 := TDotNetButton():New( 70, oGrp13, "bmps32\fonts.bmp","Fonts", 2, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn46 := TDotNetButton():New( 70, oGrp13, "bmps32\efects.bmp","Efects", 2, {|| .t.},  oMenu , bWhen, .f., .f., .f. )


            oGrp14 := TDotNetGroup():New( oCarpeta2, 350, "Page Setup", .f.,, "" )
                oBtn47 := TDotNetButton():New( 55, oGrp14, "bmps32\margins.bmp","New item", 1, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn48 := TDotNetButton():New( 70, oGrp14, "bmps32\orient.bmp","Orientation", 2, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn49 := TDotNetButton():New( 55, oGrp14, "bmps32\size.bmp","Size", 3, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn50 := TDotNetButton():New( 55, oGrp14, "bmps32\columns.bmp","Columns", 4, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn51 := TDotNetButton():New( 80, oGrp14, "bmpsmall\breaks.bmp","Breaks", 5, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn52 := TDotNetButton():New( 105, oGrp14, "bmpsmall\linenum.bmp","Line Numbers", 5, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn53 := TDotNetButton():New( 85, oGrp14, "bmpsmall\hype.bmp","Hypenation", 5, {|| .t.},  oMenu , bWhen, .f., .f., .f. )



       oCarpeta3 := TCarpeta():New( oBar, "References" )
            oGrp15 := TDotNetGroup():New( oCarpeta3, 165, "ClipBoard", .f.,, "" )
                oBtn54 := TDotNetButton():New( 60, oGrp15, "g:\canal5\dotnetba\samples\prueba5\bmps\paste.bmp","New item", 1, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn55 := TDotNetButton():New( 60, oGrp15, "bmpsmall\cut.bmp","Cut", 2, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn56 := TDotNetButton():New( 60, oGrp15, "bmpsmall\copy.bmp","Copy", 2, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn57 := TDotNetButton():New( 100, oGrp15, "bmpsmall\brush.bmp","Format Painter", 2, {|| .t.},  oMenu , bWhen, .f., .f., .f. )


            oGrp16 := TDotNetGroup():New( oCarpeta3, 165, "ClipBoard", .f.,, "" )
                oBtn58 := TDotNetButton():New( 60, oGrp16, "g:\canal5\dotnetba\samples\prueba5\bmps\paste.bmp","New item", 1, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn59 := TDotNetButton():New( 60, oGrp16, "bmpsmall\cut.bmp","Cut", 2, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn60 := TDotNetButton():New( 60, oGrp16, "bmpsmall\copy.bmp","Copy", 2, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn61 := TDotNetButton():New( 100, oGrp16, "bmpsmall\brush.bmp","Format Painter", 2, {|| .t.},  oMenu , bWhen, .f., .f., .f. )


            oGrp17 := TDotNetGroup():New( oCarpeta3, 120, "Páginas", .f.,, "" )
                oBtn62 := TDotNetButton():New( 80, oGrp17, "bmpsmall\portada.bmp","Portada", 1, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn63 := TDotNetButton():New( 113, oGrp17, "bmpsmall\pagwhite.bmp","Pagina en blanco", 1, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn64 := TDotNetButton():New( 90, oGrp17, "bmpsmall\pagbreak.bmp","Page break", 1, {|| .t.},  oMenu , bWhen, .f., .f., .f. )


            oGrp18 := TDotNetGroup():New( oCarpeta3, 60, "Tabla", .f.,, "" )
                oBtn65 := TDotNetButton():New( 55, oGrp18, "bmps32\table.bmp","New item", 1, {|| .t.},  oMenu , bWhen, .f., .f., .f. )



       oCarpeta4 := TCarpeta():New( oBar, "Mailings" )
            oGrp19 := TDotNetGroup():New( oCarpeta4, 250, "Ilustraciones", .f.,, "" )
                oBtn66 := TDotNetButton():New( 55, oGrp19, "bmps32\picture.bmp","Picture", 1, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn67 := TDotNetButton():New( 70, oGrp19, "bmps32\image.bmp","Imagenes Prediseñadas", 2, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn68 := TDotNetButton():New( 55, oGrp19, "bmps32\smart.bmp","IGX Graphic", 3, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn69 := TDotNetButton():New( 55, oGrp19, "bmps32\chart.bmp","Chart", 4, {|| .t.},  oMenu , bWhen, .f., .f., .f. )


            oGrp20 := TDotNetGroup():New( oCarpeta4, 270, "Font", .t.,, "" )
                oBtn70 := TDotNetButton():New( 120, oGrp20, "","Times New Roman", 1, {|| .t.},  oMenu , bWhen, .t., .t., .t. )
                oBtn71 := TDotNetButton():New( 40, oGrp20, "","12", 1, {|| .t.},  oMenu , bWhen, .t., .t., .t. )
                oBtn72 := TDotNetButton():New( 30, oGrp20, "bmpsmall\upper.bmp","", 1, {|| .t.},  oMenu , bWhen, .t., .t., .f. )
                oBtn73 := TDotNetButton():New( 30, oGrp20, "bmpsmall\lower.bmp","", 1, {|| .t.},  oMenu , bWhen, .t., .f., .t. )
                oBtn74 := TDotNetButton():New( 30, oGrp20, "bmpsmall\delete.bmp","", 1, {|| .t.},  oMenu , bWhen, .t., .t., .t. )
                oBtn75 := TDotNetButton():New( 30, oGrp20, "bmpsmall\bold.bmp","", 1, {|| .t.},  oMenu , bWhen, .t., .t., .f. )
                oBtn76 := TDotNetButton():New( 30, oGrp20, "bmpsmall\italic.bmp","", 1, {|| .t.},  oMenu , bWhen, .t., .f., .f. )
                oBtn77 := TDotNetButton():New( 40, oGrp20, "bmpsmall\under.bmp","", 1, {|| .t.},  oMenu , bWhen, .t., .f., .f. )
                oBtn78 := TDotNetButton():New( 30, oGrp20, "bmpsmall\abc.bmp","", 1, {|| .t.},  oMenu , bWhen, .t., .f., .f. )
                oBtn79 := TDotNetButton():New( 30, oGrp20, "bmpsmall\sub.bmp","", 1, {|| .t.},  oMenu , bWhen, .t., .f., .f. )
                oBtn80 := TDotNetButton():New( 30, oGrp20, "bmpsmall\super.bmp","", 1, {|| .t.},  oMenu , bWhen, .t., .f., .f. )
                oBtn81 := TDotNetButton():New( 30, oGrp20, "bmpsmall\aaa.bmp","", 1, {|| .t.},  oMenu , bWhen, .t., .f., .t. )



       oCarpeta5 := TCarpeta():New( oBar, "Review" )
            oGrp21 := TDotNetGroup():New( oCarpeta5, 350, "Page Setup", .f.,, "" )
                oBtn82 := TDotNetButton():New( 55, oGrp21, "bmps32\margins.bmp","New item", 1, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn83 := TDotNetButton():New( 70, oGrp21, "bmps32\orient.bmp","Orientation", 2, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn84 := TDotNetButton():New( 55, oGrp21, "bmps32\size.bmp","Size", 3, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn85 := TDotNetButton():New( 55, oGrp21, "bmps32\columns.bmp","Columns", 4, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn86 := TDotNetButton():New( 80, oGrp21, "bmpsmall\breaks.bmp","Breaks", 5, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn87 := TDotNetButton():New( 105, oGrp21, "bmpsmall\linenum.bmp","Line Numbers", 5, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn88 := TDotNetButton():New( 85, oGrp21, "bmpsmall\hype.bmp","Hypenation", 5, {|| .t.},  oMenu , bWhen, .f., .f., .f. )


            oGrp22 := TDotNetGroup():New( oCarpeta5, 350, "Page Setup", .f.,, "" )
                oBtn89 := TDotNetButton():New( 55, oGrp22, "bmps32\margins.bmp","New item", 1, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn90 := TDotNetButton():New( 70, oGrp22, "bmps32\orient.bmp","Orientation", 2, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn91 := TDotNetButton():New( 55, oGrp22, "bmps32\size.bmp","Size", 3, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn92 := TDotNetButton():New( 55, oGrp22, "bmps32\columns.bmp","Columns", 4, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn93 := TDotNetButton():New( 80, oGrp22, "bmpsmall\breaks.bmp","Breaks", 5, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn94 := TDotNetButton():New( 105, oGrp22, "bmpsmall\linenum.bmp","Line Numbers", 5, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn95 := TDotNetButton():New( 85, oGrp22, "bmpsmall\hype.bmp","Hypenation", 5, {|| .t.},  oMenu , bWhen, .f., .f., .f. )



       oCarpeta6 := TCarpeta():New( oBar, "View" )
            oGrp23 := TDotNetGroup():New( oCarpeta6, 120, "Páginas", .f.,, "" )
                oBtn96 := TDotNetButton():New( 80, oGrp23, "bmpsmall\portada.bmp","Portada", 1, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn97 := TDotNetButton():New( 113, oGrp23, "bmpsmall\pagwhite.bmp","Pagina en blanco", 1, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn98 := TDotNetButton():New( 90, oGrp23, "bmpsmall\pagbreak.bmp","Page break", 1, {|| .t.},  oMenu , bWhen, .f., .f., .f. )


            oGrp24 := TDotNetGroup():New( oCarpeta6, 120, "Páginas", .f.,, "" )
                oBtn99 := TDotNetButton():New( 80, oGrp24, "bmpsmall\portada.bmp","Portada", 1, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn100 := TDotNetButton():New( 113, oGrp24, "bmpsmall\pagwhite.bmp","Pagina en blanco", 1, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn101 := TDotNetButton():New( 90, oGrp24, "bmpsmall\pagbreak.bmp","Page break", 1, {|| .t.},  oMenu , bWhen, .f., .f., .f. )


            oGrp25 := TDotNetGroup():New( oCarpeta6, 120, "Páginas", .f.,, "" )
                oBtn102 := TDotNetButton():New( 80, oGrp25, "bmpsmall\portada.bmp","Portada", 1, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn103 := TDotNetButton():New( 113, oGrp25, "bmpsmall\pagwhite.bmp","Pagina en blanco", 1, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn104 := TDotNetButton():New( 90, oGrp25, "bmpsmall\pagbreak.bmp","Page break", 1, {|| .t.},  oMenu , bWhen, .f., .f., .f. )


            oGrp26 := TDotNetGroup():New( oCarpeta6, 120, "Páginas", .f.,, "" )
                oBtn105 := TDotNetButton():New( 80, oGrp26, "bmpsmall\portada.bmp","Portada", 1, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn106 := TDotNetButton():New( 113, oGrp26, "bmpsmall\pagwhite.bmp","Pagina en blanco", 1, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn107 := TDotNetButton():New( 90, oGrp26, "bmpsmall\pagbreak.bmp","Page break", 1, {|| .t.},  oMenu , bWhen, .f., .f., .f. )



       oCarpeta7 := TCarpeta():New( oBar, "Developer" )
            oGrp27 := TDotNetGroup():New( oCarpeta7, 200, "Header & Footer", .f.,, "" )
                oBtn108 := TDotNetButton():New( 60, oGrp27, "bmps\header.bmp","Header", 1, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn109 := TDotNetButton():New( 60, oGrp27, "bmps\footer.bmp","Footer", 2, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn110 := TDotNetButton():New( 60, oGrp27, "bmps\pagnumb.bmp","Page number", 3, {|| .t.},  oMenu , bWhen, .f., .f., .f. )


            oGrp28 := TDotNetGroup():New( oCarpeta7, 210, "Links", .f.,, "" )
                oBtn111 := TDotNetButton():New( 60, oGrp28, "bmps\hiperlin.bmp","Hiperlink", 1, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn112 := TDotNetButton():New( 60, oGrp28, "bmps\bookmark.bmp","Bookmark", 2, {|| .t.},  oMenu , bWhen, .f., .f., .f. )
                oBtn113 := TDotNetButton():New( 85, oGrp28, "bmps\cross.bmp","Cross-reference", 3, {|| AddBtns( oGrp28 )},  oMenu , bWhen, .f., .f., .f. )



//Fin Definición

ACTIVATE WINDOW oWnd MAXIMIZED

return 0



function AddBtns( oGrp28 )

local oBtn111, oBtn112, oBtn113




                oBtn111 := TDotNetButton():New( 60, oGrp28, "bmps\hiperlin.bmp","Hiperlink", 4, {|| .t.},   , , .f., .f., .f. )
                oGrp28:nWidth += 60
                oBtn112 := TDotNetButton():New( 60, oGrp28, "bmps\bookmark.bmp","Bookmark", 5, {|| .t.},   , , .f., .f., .f. )
                oGrp28:nWidth += 60
                oBtn113 := TDotNetButton():New( 85, oGrp28, "bmps\cross.bmp","Cross-reference", 6, {|| .t.},   , , .f., .f., .f. )
                oGrp28:nWidth += 85
                oGrp28:aSize[1] := oGrp28:nWidth
                oBtn113:oGrupo:oCarpeta:CalcSizes()
                oBtn113:oGrupo:oCarpeta:oParent:Refresh()


return 0