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
    { description : String
    , completed : Bool
    , editing : Bool
    , id : Int
    }
