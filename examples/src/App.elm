module App exposing (..)

import Bootstrap.Button as Button
import Bootstrap.Grid as Grid
import Char
import Html exposing (..)
import Html.Attributes exposing (..)
import Keyboard
import Toasty
import Toasty.Defaults


---- MODEL ----


type alias Model =
    { toasties : Toasty.Stack Toasty.Defaults.Toast
    }


type Msg
    = KeyPressed Keyboard.KeyCode
    | BtnClicked String
    | ToastyMsg (Toasty.Msg Toasty.Defaults.Toast)


init : ( Model, Cmd Msg )
init =
    { toasties = Toasty.initialState } ! []


myConfig : Toasty.Config Msg
myConfig =
    Toasty.Defaults.config
        |> Toasty.delay 5000


addToast : Toasty.Defaults.Toast -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
addToast toast ( model, cmd ) =
    Toasty.addToast myConfig ToastyMsg toast ( model, cmd )



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        KeyPressed keycode ->
            case Char.fromCode keycode of
                'i' ->
                    (model ! [])
                        |> addToast (Toasty.Defaults.Info "Info" "This is information.")

                's' ->
                    (model ! [])
                        |> addToast (Toasty.Defaults.Success "Success" "Thing successfully updated.")

                'w' ->
                    (model ! [])
                        |> addToast (Toasty.Defaults.Warning "Warning!" "Please check this and that.")

                'e' ->
                    (model ! [])
                        |> addToast (Toasty.Defaults.Error "Error" "Sorry, something went wrong...")

                _ ->
                    model ! []

        BtnClicked "info" ->
            (model ! [])
                |> addToast (Toasty.Defaults.Info "Info" "This is information.")

        BtnClicked "success" ->
            (model ! [])
                |> addToast (Toasty.Defaults.Success "Success" "Thing successfully updated")

        BtnClicked "warning" ->
            (model ! [])
                |> addToast (Toasty.Defaults.Warning "Warning!" "Please check this and that.")

        BtnClicked "error" ->
            (model ! [])
                |> addToast (Toasty.Defaults.Error "Error" "Sorry, something went wrong...")

        BtnClicked _ ->
            model ! []

        ToastyMsg subMsg ->
            Toasty.update myConfig ToastyMsg subMsg model



---- VIEW ----


view : Model -> Html Msg
view model =
    Grid.containerFluid []
        [ h1 [] [ text "Toasty Bootstrap" ]
        , p []
            [ text "Click for adding a "
            , Button.button [ Button.info, Button.onClick (BtnClicked "info") ] [ text "info" ]
            , text ", "
            , Button.button [ Button.success, Button.onClick (BtnClicked "success") ] [ text "success" ]
            , text ", "
            , Button.button [ Button.warning, Button.onClick (BtnClicked "warning") ] [ text "warning" ]
            , text " or "
            , Button.button [ Button.danger, Button.onClick (BtnClicked "error") ] [ text "error" ]
            , text " toast."
            ]
        , p []
            [ text "Also you can press in your keyboard "
            , kbd [] [ text "[i]" ]
            , text " for info, "
            , kbd [] [ text "[s]" ]
            , text " for success, "
            , kbd [] [ text "[w]" ]
            , text " for warning or "
            , kbd [] [ text "[e]" ]
            , text " for error toasts."
            ]
        , p [ class "help small" ] [ text "Click on any toast to remove it." ]
        , p [] [ text "This demo uses ", code [] [ text "Toasty.Defaults" ], text " for styling." ]
        , p []
            [ a [ href "http://package.elm-lang.org/packages/andrewjackman/toasty-bootstrap/latest" ]
                [ text "Toasty Bootstrap at package.elm-lang.org" ]
            ]
        , Toasty.view myConfig Toasty.Defaults.view ToastyMsg model.toasties
        ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = \_ -> Keyboard.presses KeyPressed
        }
