module Main exposing (Location, LocationResponse, Model, Msg(..), init, locationRequest, main, sendLocationQuery, sendQueryRequest, subscriptions, update, view)

import Browser
import GraphQL.Client.Http as GraphQLClient
import GraphQL.Request.Builder exposing (..)
import GraphQL.Request.Builder.Arg as Arg
import GraphQL.Request.Builder.Variable as Var
import Html exposing (Html, div, text)
import Task exposing (Task)


{-| Responses to `locationRequest` are decoded into this type.
-}
type alias Location =
    { japanese : Maybe String
    }


locationRequest : Request Query Location
locationRequest =
    let
        filmID =
            Var.required "Japanese" .japanese Var.string
    in
    extract
        (field "location"
            [ ( "Japanese", Arg.variable filmID ) ]
            (object Location
                |> with (field "Japanese" [] (nullable string))
            )
        )
        |> queryDocument
        |> request
            { japanese = "名古屋市"
            }


type alias LocationResponse =
    Result GraphQLClient.Error Location


type alias Model =
    Maybe LocationResponse


type Msg
    = ReceiveQueryResponse LocationResponse


sendQueryRequest : Request Query a -> Task GraphQLClient.Error a
sendQueryRequest request =
    -- 第一引数にgraphQLサーバーのエンドポイントを指定
    GraphQLClient.sendQuery "http://localhost:4001" request


sendLocationQuery : Cmd Msg
sendLocationQuery =
    sendQueryRequest locationRequest
        |> Task.attempt ReceiveQueryResponse


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Nothing, sendLocationQuery )


view : Model -> Html Msg
view model =
    div []
        [ model |> Debug.toString |> text ]


update : Msg -> Model -> ( Model, Cmd Msg )
update (ReceiveQueryResponse response) model =
    ( Just response, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
