module Main exposing (main)

import Browser
import Example1Basic
import Example2Async
import Example3Multi
import Example4Custom
import Html exposing (..)
import Html.Attributes exposing (class, href)
import Select
import Shared


type alias Model =
    { example1 : Example1Basic.Model
    , example2 : Example2Async.Model
    , example3 : Example3Multi.Model
    , example4a : Example4Custom.Model
    , example4b : Example4Custom.Model
    , example4c : Example4Custom.Model
    }


initialModel : Model
initialModel =
    { example1 = Example1Basic.initialModel "1a"
    , example2 = Example2Async.initialModel "2"
    , example3 = Example3Multi.initialModel "3"
    , example4a = Example4Custom.initialModel "4a"
    , example4b = Example4Custom.initialModel "4b"
    , example4c = Example4Custom.initialModel "4c"
    }


initialCmds : Cmd Msg
initialCmds =
    Cmd.batch [ Cmd.map Example2AsyncMsg Example2Async.initialCmds ]


init : flags -> ( Model, Cmd Msg )
init _ =
    ( initialModel, initialCmds )


type Msg
    = NoOp
    | Example1BasicMsg Example1Basic.Msg
    | Example2AsyncMsg Example2Async.Msg
    | Example3MultiMsg Example3Multi.Msg
    | Example4CustomAMsg Example4Custom.Msg
    | Example4CustomBMsg Example4Custom.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Example1BasicMsg sub ->
            let
                ( subModel, subCmd ) =
                    Example1Basic.update sub model.example1
            in
            ( { model | example1 = subModel }, Cmd.map Example1BasicMsg subCmd )

        Example2AsyncMsg sub ->
            let
                ( subModel, subCmd ) =
                    Example2Async.update sub model.example2
            in
            ( { model | example2 = subModel }, Cmd.map Example2AsyncMsg subCmd )

        Example3MultiMsg sub ->
            let
                ( subModel, subCmd ) =
                    Example3Multi.update sub model.example3
            in
            ( { model | example3 = subModel }, Cmd.map Example3MultiMsg subCmd )

        Example4CustomAMsg sub ->
            let
                ( subModel, subCmd ) =
                    Example4Custom.update
                        selectConfig4a
                        sub
                        model.example4a
            in
            ( { model | example4a = subModel }, Cmd.map Example4CustomAMsg subCmd )

        Example4CustomBMsg sub ->
            let
                ( subModel, subCmd ) =
                    Example4Custom.update
                        selectConfig4b
                        sub
                        model.example4b
            in
            ( { model | example4b = subModel }, Cmd.map Example4CustomBMsg subCmd )

        NoOp ->
            ( model, Cmd.none )


projectUrl : String
projectUrl =
    "https://github.com/sporto/elm-select"


view : Model -> Html Msg
view model =
    div [ class "p-5 pb-20" ]
        [ h1 [] [ text "Elm Select" ]
        , a [ href projectUrl ] [ text projectUrl ]
        , Html.map Example1BasicMsg (Example1Basic.view model.example1)
        , Html.map Example2AsyncMsg (Example2Async.view model.example2)
        , Html.map Example3MultiMsg (Example3Multi.view model.example3)
        , Example4Custom.view
                selectConfig4a
                model.example4a
                "With empty search"
                |> Html.map Example4CustomAMsg
        , Example4Custom.view
                selectConfig4b
                model.example4b
                "With custom input"
                |> Html.map Example4CustomBMsg
        ]


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }


selectConfig4a : Select.Config Example4Custom.Msg Example4Custom.Movie
selectConfig4a =
    Select.newConfig
        { onSelect = Example4Custom.OnSelect
        , toLabel = .label
        , filter = Shared.filter 4 .label
        , toMsg = Example4Custom.SelectMsg
        }
        |> Select.withCutoff 12
        |> Select.withEmptySearch True
        |> Select.withNotFound "No matches"
        |> Select.withPrompt "Select a movie"

selectConfig4b =
    selectConfig4a
        |> Select.withCustomInput
            (\input ->
                { id = input
                , label = input
                }
            )
