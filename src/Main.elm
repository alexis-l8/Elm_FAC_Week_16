module Main exposing (..)

import Html exposing (program)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (..)
import Json.Decode as Decode
import Msgs exposing (..)
import Models exposing (Model)
import Update exposing (update)
import View exposing (view)


main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = always Sub.none
        }


init : ( Model, Cmd Msg )
init =
    initialModel ! [ getTodos ]


initialModel : Model
initialModel =
    { entries = []
    , field = ""
    , uuid = 0
    }


beginProgram =
    [ Cmd.none ]



-- model
--
-- update
-- | RemoveItem String
---


getTodos =
    let
        url =
            "http://localhost:4000/tasks"

        request =
            Http.get url <| Decode.list decodeMetadata
    in
        Http.send NewGif request


type alias Metadata =
    { id : String
    , task : String
    , steps : List Int
    , completed : Int
    }


decodeMetadata : Decode.Decoder Metadata
decodeMetadata =
    Decode.map4 Metadata
        (Decode.field "id" Decode.string)
        (Decode.field "task" Decode.string)
        (Decode.field "steps" (Decode.list Decode.int))
        (Decode.field "completed" Decode.int)



--
