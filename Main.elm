module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode


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
    | CheckTodo Int
    | NewGif (Result Http.Error (List Metadata))



-- | RemoveItem String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateTodo text ->
            { model | field = text }
                ! []

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
                ! []

        RemoveAll ->
            { model | entries = [] }
                ! []

        RemoveTodo id ->
            { model | entries = List.filter (\todo -> id /= todo.id) model.entries }
                ! []

        CheckTodo id ->
            { model
                | entries =
                    List.map
                        (\todo ->
                            if id == todo.id then
                                { todo
                                    | completed = not todo.completed
                                }
                            else
                                todo
                        )
                        model.entries
            }
                ! []

        NewGif (Ok newUrl) ->
            let
                log =
                    Debug.log "yeah" newUrl
            in
                ( model, Cmd.none )

        NewGif (Err err) ->
            let
                log =
                    Debug.log "error" err
            in
                ( model, Cmd.none )


todoItem : Entry -> Html Msg
todoItem todo =
    li [ classList [ ( "completed", todo.completed ) ], id (toString todo.id) ]
        [ text todo.description
        , input [ type_ "checkbox", checked todo.completed, onClick (CheckTodo todo.id) ] []
        , button [ onClick (RemoveTodo todo.id) ] [ text "x" ]
        ]



---


todoList : List Entry -> Html Msg
todoList todos =
    let
        child =
            List.map todoItem todos
    in
        ul [] child


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


view model =
    div []
        [ input [ type_ "text", onInput UpdateTodo, value model.field ] []
        , button [ onClick AddTodo ] [ text "Submit" ]
        , button [ onClick RemoveAll ] [ text "Remove All" ]
        , div [] [ text (toString getTodos) ]
        ]
