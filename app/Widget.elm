module Widget exposing(..)

import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Element.Input
import Element.Lazy

import Html.Attributes

grey =
  Element.rgb 0.8588 0.8549 0.8392  

lightGrey =
  Element.rgb 0.9686 0.9647 0.9568  

white = 
  Element.rgb 1 1 1

black = 
  Element.rgb 0.30 0.30 0.30

charcoal = 
  Element.rgb 0.4 0.4 0.4

mouseOverColor = 
  Element.rgb 0.0 0.6 0.9

mouseDownColor = 
  Element.rgb 0.7 0.1 0.1

blue =
  Element.rgb 0.15 0.15 1.0

darkRed = 
  Element.rgb 0.6 0.0 0.0

orange = 
  -- Element.rgb 0.9569 0.6078 0.2588
  Element.rgb 0.9373 0.4980 0.0549

screenshotHeaderStyle = 
  [ alignLeft,
    centerY,
    width (px 400),
    height (px 60),
    moveDown 60,
     Font.size 24]

buttonFontSize = Font.size 13

basicButtonsStyle = [buttonFontSize, pointer
    ,mouseDown [  buttonFontSize, Background.color mouseDownColor]
    ]

buttonStyle =
  [Background.color black, Font.color grey, Element.paddingXY 10 6 ] ++ basicButtonsStyle


noAutocapitalize = Element.htmlAttribute (Html.Attributes.attribute "autocapitalize" "none")
noAutocorrect =  Element.htmlAttribute (Html.Attributes.attribute "autocorrect" "off")
preWrap =  Element.htmlAttribute (Html.Attributes.attribute "white-space" "pre-wrap")