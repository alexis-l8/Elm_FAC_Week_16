module Main exposing (..)

import Html exposing (program)
import Http exposing (..)
import Json.Decode as Decode
import Json.Encode as Encode
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
-- post String Http.Body Json.Decode.Decoder a
--
-- savePlayerRequest : Metadata -> Http.Request Metadata
-- savePlayerRequest todo =
--     Http.request
--         { body = playerEncoder todo |> Http.jsonBody
--         , expect = Http.expectJson playerDecoder
--         , headers = []
--         , method = "PATCH"
--         , timeout = Nothing
--         , url = "http://localhost:4000/tasks"
--         , withCredentials = False
--         }
--
--
--
-- --
--
--
-- savePlayerCmd : Player -> Cmd Msg
-- savePlayerCmd player =
--     savePlayerRequest player
--         |> Http.send Msgs.OnPlayerSave
--
--
-- playerEncoder : Todo -> Encode.Value
-- playerEncoder todo =
--     let
--         attributes =
--             [ ( "description", Encode.string todo.id )
--             , ( "completed", Encode.string todo.name )
--             , ( "editing", Encode.int todo.level )
--             , ( "id", Encode.int todo.level )
--             ]
--     in
--         Encode.object attributes


getTodos =
    let
        url =
            "http://localhost:4000/tasks"

        request =
            Http.get url <| Decode.list decodeMetadata
    in
        Http.send NewGif request


type alias Metadata =
    { description : String
    , completed : Bool
    , editing : Bool
    , id : Int
    }


decodeMetadata : Decode.Decoder Metadata
decodeMetadata =
    Decode.map4 Metadata
        (Decode.field "description" Decode.string)
        (Decode.field "completed" Decode.bool)
        (Decode.field "editing" Decode.bool)
        (Decode.field "id" Decode.int)



--
