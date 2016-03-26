module CodeMirror (CmConfig, codeMirror) where

{-| This library fills a bunch of important niches in Elm. A `Maybe` can help
you with optional arguments, error handling, and records with optional fields.

# Definition
@docs Maybe

# Common Helpers
@docs map, withDefault, oneOf

# Chaining Maybes
@docs andThen

-}

import Html exposing (Html)
import Native.CodeMirror


type alias Config =
  { value : String
  , cmConfig : CmConfig
  }


type alias CmConfig =
  { theme : String
  , mode : String
  , height : String
  , lineNumbers : Bool
  , lineWrapping : Bool
  }


codeMirror' : Config -> (String -> Signal.Message) -> Html
codeMirror' =
  Native.CodeMirror.codeMirror


codeMirror : CmConfig -> (String -> Signal.Message) -> String -> Html
codeMirror config msgCreator code =
  codeMirror' { cmConfig = config, value = code } msgCreator
