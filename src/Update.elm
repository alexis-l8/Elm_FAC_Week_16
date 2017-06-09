module Update exposing (..)

import Msgs exposing (Msg(..))
import Models exposing (..)


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


newEntry : String -> Int -> Entry
newEntry desc id =
    { description = desc
    , completed = False
    , editing = False
    , id = id
    }
