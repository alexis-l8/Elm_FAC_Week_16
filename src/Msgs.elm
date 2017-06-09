module Msgs exposing (..)

import Http


type Msg
    = UpdateTodo String
    | AddTodo
    | RemoveAll
    | RemoveTodo Int
    | CheckTodo Int
    | NewGif (Result Http.Error (List Metadata))


type alias Metadata =
    { id : String
    , task : String
    , steps : List Int
    , completed : Int
    }
