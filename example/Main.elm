module Main (..) where

import Html exposing (..)
import CodeMirror exposing (..)
import StartApp.Simple exposing (start)
import Html.Events exposing (..)
import Html.Attributes exposing (..)


type alias Model =
  { code : String
  , lineNumbers : Bool
  , theme : String
  , mode : String
  }


type Action
  = CodeChange String
  | ChangeLineNumbers Bool
  | ChangeTheme String
  | ChangeMode String


init : Model
init =
  { code = "main = \"Hello World\""
  , lineNumbers = False
  , theme = "monokai"
  , mode = "elm"
  }


cmConfig : Model -> CmConfig
cmConfig model =
  { theme = model.theme
  , mode = model.mode
  , height = "auto"
  , lineNumbers = model.lineNumbers
  , lineWrapping = False
  }



-- cmInstance : Signal.Address String -> String -> Html
-- cmInstance add code =
--   codeMirror  (Signal.message add << CodeChange) code


containerStyle =
  style [ ( "flex", "1" ), ( "margin", "10px" ) ]


inputStyle =
  style [("width", "100%"), ("margin-bottom", "10px")]

container children =
  div [ containerStyle ] children



-- lazy way to test to see if it handles re-rendering well


codeMirrorView : Signal.Address Action -> Model -> Html
codeMirrorView add model =
  if (model.theme == "hide") then
    div [] [ text "hidden" ]
  else
    codeMirror (cmConfig model) (Signal.message add << CodeChange) model.code


header : Html
header =
  div
    []
    [ h2 [] [ text "elm-codemirror example" ]
    , p [] [ text "The 2 instances and the text area are bound to the same model. You can control theme and mode (only javascript and elm are loaded), and edit the code from a regular textarea too" ]
    ]


view : Signal.Address Action -> Model -> Html
view add model =
  div
    []
    [ header
    , div
        [ style [ ( "display", "flex" ) ] ]
        [ container
            [ h2 [] [ text "Instance 1" ], codeMirrorView add model ]
        , container [ h2 [] [ text "Instance 2" ], codeMirror (cmConfig model) (Signal.message add << CodeChange) model.code ]
        , container
            [ h2
                []
                [ text "Controls" ]
            , div
                []
                [ text "Theme:"
                , input
                    [ placeholder "Theme"
                    , inputStyle
                    , value model.theme
                    , on "input" targetValue (Signal.message add << ChangeTheme)
                    ]
                    []
                ]
            , div
                []
                [ text "Mode (elm or javascript are loaded)"
                , input
                    [ placeholder "Mode"
                    , value model.mode
                    , inputStyle
                    , on "input" targetValue (Signal.message add << ChangeMode)
                    ]
                    []
                ]
            , div
                []
                [ text "\"raw\" code"
                , textarea
                    [ placeholder "Code"
                    , value model.code
                    , inputStyle
                    , on "input" targetValue (Signal.message add << CodeChange)
                    ]
                    []
                ]
            ]
        ]
    ]


update : Action -> Model -> Model
update acc model =
  case acc of
    CodeChange code ->
      { model | code = code }

    ChangeLineNumbers val ->
      { model | lineNumbers = val }

    ChangeTheme theme ->
      { model | theme = theme }

    ChangeMode mode ->
      { model | mode = mode }


main =
  StartApp.Simple.start
    { model = init
    , update = update
    , view = view
    }
