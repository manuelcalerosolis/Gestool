/*
�� Programa ��������������������������������������������������������������Ŀ
�   Aplication: Constructor file for class TLabels, TLItem                 �
�         File: PDLABEL.PRG                                                �
�       Author: Manuel Calero Solis                                        �
�       Telef.: (959) 40.23.83                                             �
�         Date: 16/05/95                                                   �
�         Time: 20:20:07                                                   �
�    Copyright: 1995 by Manuel Calero Solis                                �
����������������������������������������������������������������������������
*/
#include "FiveWin.Ch"
#include "Objects.ch"

#define LABELS  1
#define ITEMS   2

STATIC aLabels  := {}

//----------------------------------------------------------------------------//

FUNCTION LblBegin( nLblWidth ,;
						nLblHeight,;
						nHSeparator,;
						nVSeparator,;
						nLblOnLine,;
						aFont,;
						aPen,;
						cLblFile,;
						cResName,;
						toPrint,;
						toScreen,;
						toFile,;
						oDevice,;
						cName )

	AAdd( aLabels ,;
		  { TLabel():New( nLblWidth ,;
						nLblHeight,;
						nHSeparator,;
						nVSeparator,;
						nLblOnLine,;
						aFont,;
						aPen,;
						cLblFile,;
						cResName,;
						toPrint,;
						toScreen,;
						toFile,;
						oDevice,;
						cName ), {} } )

RETURN ATail( aLabels )[ LABELS ]

//----------------------------------------------------------------------------//

FUNCTION LblAddItem( nRow,;
						bData,;
						nSize,;
						aPicture,;
						uFont,;
						nPen,;
						cFmt,;
						lShadow,;
						lGrid )

	  LOCAL oItem

	  oItem := TLItem():New(nRow,;
						bData,;
						nSize,;
						aPicture,;
						uFont,;
						nPen,;
						cFmt,;
						lShadow,;
						lGrid,;
						Atail(aLabels)[ LABELS ] )

	  AAdd( ATail( aLabels )[ ITEMS ], oItem )

RETURN oItem

//----------------------------------------------------------------------------//

FUNCTION LblAddOItem(   nRow,;
                        bData,;
                        nSize,;
                        aPicture,;
                        oFont,;
                        nPen,;
                        cFmt,;
                        lShadow,;
                        lGrid,;
                        lEan13,;
                        lHorz,;
                        lBanner,;
                        nRgbColor )

	  LOCAL oItem

     oItem := TLOItem():New(nRow,;
						bData,;
						nSize,;
						aPicture,;
						oFont,;
						nPen,;
						cFmt,;
						lShadow,;
						lGrid,;
						lEan13,;
						lHorz,;
						lBanner,;
						nRgbColor,;
						Atail(aLabels)[ LABELS ] )

	  AAdd( ATail( aLabels )[ ITEMS ], oItem )

RETURN oItem

//----------------------------------------------------------------------------//

FUNCTION LblEnd()

	LOCAL oLabel   := ATail( aLabels )[ LABELS ]
	LOCAL aItems   := ATail( aLabels )[ ITEMS  ]

	AEval( aItems, { | oItem | oLabel:AddItem( oItem ) } )

	ASize( aLabels, Len( aLabels ) - 1 )

RETURN oLabel

//----------------------------------------------------------------------------//