module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


main =
    Html.beginnerProgram
        { view = view
        , update = update
        , model = model
        }



-- model


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



--


newEntry : String -> Int -> Entry
newEntry desc id =
    { description = desc
    , completed = False
    , editing = False
    , id = id
    }



-- update


type Msg
    = UpdateTodo String
    | AddTodo
    | RemoveAll
    | RemoveTodo Int



-- | RemoveItem String


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateTodo text ->
            { model | field = text }

        AddTodo ->
            { model
                | uuid = model.uuid + 1
                , field = ""
                , entries =
                    if String.isEmpty model.field then
                        model.entries
                    else
                        model.entries ++ [ newEntry model.field model.uuid ]
            }

        RemoveAll ->
            { model | entries = [] }

        RemoveTodo id ->
            { model | entries = List.filter (\todo -> id /= todo.id) model.entries }


todoItem : Entry -> Html Msg
todoItem todo =
    li [ id (toString todo.id) ] [ text todo.description, button [ onClick (RemoveTodo todo.id) ] [ text "x" ] ]



---


todoList : List Entry -> Html Msg
todoList todos =
    let
        child =
            List.map todoItem todos
    in
        ul [] child



--


view model =
    div []
        [ input [ type_ "text", onInput UpdateTodo, value model.field ] []
        , button [ onClick AddTodo ] [ text "Submit" ]
        , button [ onClick RemoveAll ] [ text "Remove All" ]
        , div [] [ todoList model.entries ]
        ]
