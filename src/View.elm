module View exposing (..)

import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Msgs exposing (..)
import Html exposing (..)
import Models exposing (..)


todoItem : Entry -> Html Msg
todoItem todo =
    li [ classList [ ( "completed", todo.completed ) ], id (toString todo.id) ]
        [ text todo.description
        , input [ type_ "checkbox", checked todo.completed, onClick (CheckTodo todo.id) ] []
        , button [ class "remove", onClick (RemoveTodo todo.id) ] [ text "x" ]
        ]


todoList : List Entry -> Html Msg
todoList todos =
    let
        child =
            List.map todoItem todos
    in
        ul [] child


view model =
    div [ class "steps" ]
        [ input [ type_ "text", onInput UpdateTodo, value model.field ] []
        , button [ onClick AddTodo ] [ text "Submit" ]
        , button [ onClick RemoveAll ] [ text "Remove All" ]
        , div [] [ todoList model.entries ]
        ]
