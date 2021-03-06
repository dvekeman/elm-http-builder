import Browser
import Html exposing (Html, text, pre)
import Http
import HttpBuilder


-- MAIN


main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }



-- MODEL

type Status a = Loading | Loaded a | Failure

type alias Model = Status String


init : () -> (Model, Cmd Msg)
init _ =
  ( Loading
  , "https://elm-lang.org/assets/public-opinion.txt"
      |> HttpBuilder.get
      |> HttpBuilder.withExpect (Http.expectString GotText)
      |> HttpBuilder.send
  )



-- UPDATE


type Msg
  = GotText (Result Http.Error String)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GotText result ->
      case result of
        Ok fullText ->
          (Loaded fullText, Cmd.none)

        Err _ ->
          (Failure, Cmd.none)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  case model of
    Failure ->
      text "I was unable to load your book."

    Loading ->
      text "Loading..."

    Loaded fullText ->
      pre [] [ text fullText ]
