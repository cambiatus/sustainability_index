import Browser
import Element exposing(..)
import Html exposing(Html)


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

type Msg = 
  NoOp

type alias Model = { message: String }

initialModel : Model  
initialModel = 
  { message = "Hello!  This is Elm."}

type alias Flags =
    {}

init : Flags -> ( Model, Cmd Msg )
init flags =
    ( initialModel, Cmd.none)


subscriptions model =
    Sub.batch
        [  ]

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none ) 

view : Model -> Html msg
view model = 
  layout [] (mainRow model)

mainRow : Model -> Element msg
mainRow model =
    row [ width fill, centerY, centerX ]
        [
         el [ centerX ] (text model.message)
        ]