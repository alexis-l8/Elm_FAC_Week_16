module Models exposing (..)


type alias Model =
    { entries : List Entry
    , field : String
    , uuid : Int
    }


type alias Entry =
    { description : String
    , completed : Bool
    , editing : Bool
    , id : Int
    }


model : Model
model =
    { entries = []
    , field = ""
    , uuid = 0
    }
