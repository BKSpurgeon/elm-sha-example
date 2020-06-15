module Main exposing (..)
import Browser
import Bytes exposing (Bytes)
import Bytes.Encode as Encode
import File exposing (File)
import File.Select as Select
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as D
import SHA1
import Task



-- MAIN


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { hover : Bool
    , shas : List String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model False [], Cmd.none )



-- UPDATE


type Msg
    = Pick
    | DragEnter
    | DragLeave
    | GotFiles File (List File)
    | GotShas (List String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Pick ->
            ( model
            , Select.files [ "*" ] GotFiles
            )

        DragEnter ->
            ( { model | hover = True }
            , Cmd.none
            )

        DragLeave ->
            ( { model | hover = False }
            , Cmd.none
            )

        GotFiles file files ->
            ( { model | hover = False }
            , (file :: files)
                |> List.map
                    (File.toBytes
                        >> Task.map (SHA1.fromBytes >> SHA1.toBase64)
                    )
                |> Task.sequence
                |> Task.perform GotShas
            )

{-
        GotFiles file files ->
            ( { model | hover = False }
            , (file :: files)
                |> List.map File.toBytes
                |> Task.sequence
                |> Task.map (List.map (SHA1.fromByteValues >> SHA1.toHex))
                |> Task.perform GotShas
            )

-}


        GotShas shas ->
            ( { model | shas = shas }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div
        [ style "border"
            (if model.hover then
                "6px dashed purple"

             else
                "6px dashed #ccc"
            )
        , style "border-radius" "20px"
        , style "width" "480px"
        , style "margin" "100px auto"
        , style "padding" "40px"
        , style "display" "flex"
        , style "flex-direction" "column"
        , style "justify-content" "center"
        , style "align-items" "center"
        , hijackOn "dragenter" (D.succeed DragEnter)
        , hijackOn "dragover" (D.succeed DragEnter)
        , hijackOn "dragleave" (D.succeed DragLeave)
        , hijackOn "drop" dropDecoder
        ]
        [ button [ onClick Pick ] [ text "Upload Files to calculate their SHAs" ]
        , div
            [ 
            ]
            (List.map viewPreview model.shas)
        ]


viewPreview : String -> Html msg
viewPreview url =
    div
        [ 
        ]
        [ br [] [], 
          p [] [text url]        
        ]


dropDecoder : D.Decoder Msg
dropDecoder =
    D.at [ "dataTransfer", "files" ] (D.oneOrMore GotFiles File.decoder)


hijackOn : String -> D.Decoder msg -> Attribute msg
hijackOn event decoder =
    preventDefaultOn event (D.map hijack decoder)


hijack : msg -> ( msg, Bool )
hijack msg =
    ( msg, True )
