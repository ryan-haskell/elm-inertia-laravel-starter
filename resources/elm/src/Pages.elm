{- ✨ GENERATED by https://www.npmjs.com/package/elm-inertia ✨ -}


module Pages exposing (Model, Msg, init, onPropsChanged, subscriptions, update, view)

import Browser exposing (Document)
import Effect exposing (Effect)
import Html
import Inertia exposing (PageObject)
import Json.Decode exposing (Value)
import Pages.Auth.ForgotPassword
import Pages.Auth.Login
import Pages.Auth.Register
import Pages.Auth.ResetPassword
import Pages.Dashboard
import Pages.Error404
import Pages.Error500
import Pages.Profile.Edit
import Pages.Welcome
import Shared
import Url exposing (Url)


type Model
    = Model_Auth_ForgotPassword { props : Pages.Auth.ForgotPassword.Props, model : Pages.Auth.ForgotPassword.Model }
    | Model_Auth_Login { props : Pages.Auth.Login.Props, model : Pages.Auth.Login.Model }
    | Model_Auth_Register { props : Pages.Auth.Register.Props, model : Pages.Auth.Register.Model }
    | Model_Auth_ResetPassword { props : Pages.Auth.ResetPassword.Props, model : Pages.Auth.ResetPassword.Model }
    | Model_Dashboard { props : Pages.Dashboard.Props, model : Pages.Dashboard.Model }
    | Model_Profile_Edit { props : Pages.Profile.Edit.Props, model : Pages.Profile.Edit.Model }
    | Model_Welcome { props : Pages.Welcome.Props, model : Pages.Welcome.Model }
    | Model_Error404 { model : Pages.Error404.Model }
    | Model_Error500 { info : Pages.Error500.Info, model : Pages.Error500.Model }


type Msg
    = Msg_Auth_ForgotPassword Pages.Auth.ForgotPassword.Msg
    | Msg_Auth_Login Pages.Auth.Login.Msg
    | Msg_Auth_Register Pages.Auth.Register.Msg
    | Msg_Auth_ResetPassword Pages.Auth.ResetPassword.Msg
    | Msg_Dashboard Pages.Dashboard.Msg
    | Msg_Profile_Edit Pages.Profile.Edit.Msg
    | Msg_Welcome Pages.Welcome.Msg
    | Msg_Error404 Pages.Error404.Msg
    | Msg_Error500 Pages.Error500.Msg


init : Shared.Model -> Url -> PageObject Value -> ( Model, Effect Msg )
init shared url pageObject =
    case String.toLower pageObject.component of
        "auth/forgotpassword" ->
            initForPage shared url pageObject <|
                { decoder = Pages.Auth.ForgotPassword.decoder
                , init = Pages.Auth.ForgotPassword.init
                , toModel = Model_Auth_ForgotPassword
                , toMsg = Msg_Auth_ForgotPassword
                }

        "auth/login" ->
            initForPage shared url pageObject <|
                { decoder = Pages.Auth.Login.decoder
                , init = Pages.Auth.Login.init
                , toModel = Model_Auth_Login
                , toMsg = Msg_Auth_Login
                }

        "auth/register" ->
            initForPage shared url pageObject <|
                { decoder = Pages.Auth.Register.decoder
                , init = Pages.Auth.Register.init
                , toModel = Model_Auth_Register
                , toMsg = Msg_Auth_Register
                }

        "auth/resetpassword" ->
            initForPage shared url pageObject <|
                { decoder = Pages.Auth.ResetPassword.decoder
                , init = Pages.Auth.ResetPassword.init
                , toModel = Model_Auth_ResetPassword
                , toMsg = Msg_Auth_ResetPassword
                }

        "dashboard" ->
            initForPage shared url pageObject <|
                { decoder = Pages.Dashboard.decoder
                , init = Pages.Dashboard.init
                , toModel = Model_Dashboard
                , toMsg = Msg_Dashboard
                }

        "profile/edit" ->
            initForPage shared url pageObject <|
                { decoder = Pages.Profile.Edit.decoder
                , init = Pages.Profile.Edit.init
                , toModel = Model_Profile_Edit
                , toMsg = Msg_Profile_Edit
                }

        "welcome" ->
            initForPage shared url pageObject <|
                { decoder = Pages.Welcome.decoder
                , init = Pages.Welcome.init
                , toModel = Model_Welcome
                , toMsg = Msg_Welcome
                }

        _ ->
            let
                ( pageModel, pageEffect ) =
                    Pages.Error404.init shared url
            in
            ( Model_Error404 { model = pageModel }
            , Effect.map Msg_Error404 pageEffect
            )


update : Shared.Model -> Url -> PageObject Value -> Msg -> Model -> ( Model, Effect Msg )
update shared url pageObject msg model =
    case ( msg, model ) of
        ( Msg_Auth_ForgotPassword pageMsg, Model_Auth_ForgotPassword page ) ->
            let
                ( pageModel, pageEffect ) =
                    Pages.Auth.ForgotPassword.update shared url page.props pageMsg page.model
            in
            ( Model_Auth_ForgotPassword { page | model = pageModel }
            , Effect.map Msg_Auth_ForgotPassword pageEffect
            )

        ( Msg_Auth_Login pageMsg, Model_Auth_Login page ) ->
            let
                ( pageModel, pageEffect ) =
                    Pages.Auth.Login.update shared url page.props pageMsg page.model
            in
            ( Model_Auth_Login { page | model = pageModel }
            , Effect.map Msg_Auth_Login pageEffect
            )

        ( Msg_Auth_Register pageMsg, Model_Auth_Register page ) ->
            let
                ( pageModel, pageEffect ) =
                    Pages.Auth.Register.update shared url page.props pageMsg page.model
            in
            ( Model_Auth_Register { page | model = pageModel }
            , Effect.map Msg_Auth_Register pageEffect
            )

        ( Msg_Auth_ResetPassword pageMsg, Model_Auth_ResetPassword page ) ->
            let
                ( pageModel, pageEffect ) =
                    Pages.Auth.ResetPassword.update shared url page.props pageMsg page.model
            in
            ( Model_Auth_ResetPassword { page | model = pageModel }
            , Effect.map Msg_Auth_ResetPassword pageEffect
            )

        ( Msg_Dashboard pageMsg, Model_Dashboard page ) ->
            let
                ( pageModel, pageEffect ) =
                    Pages.Dashboard.update shared url page.props pageMsg page.model
            in
            ( Model_Dashboard { page | model = pageModel }
            , Effect.map Msg_Dashboard pageEffect
            )

        ( Msg_Profile_Edit pageMsg, Model_Profile_Edit page ) ->
            let
                ( pageModel, pageEffect ) =
                    Pages.Profile.Edit.update shared url page.props pageMsg page.model
            in
            ( Model_Profile_Edit { page | model = pageModel }
            , Effect.map Msg_Profile_Edit pageEffect
            )

        ( Msg_Welcome pageMsg, Model_Welcome page ) ->
            let
                ( pageModel, pageEffect ) =
                    Pages.Welcome.update shared url page.props pageMsg page.model
            in
            ( Model_Welcome { page | model = pageModel }
            , Effect.map Msg_Welcome pageEffect
            )

        ( Msg_Error404 pageMsg, Model_Error404 page ) ->
            let
                ( pageModel, pageEffect ) =
                    Pages.Error404.update shared url pageMsg page.model
            in
            ( Model_Error404 { page | model = pageModel }
            , Effect.map Msg_Error404 pageEffect
            )

        ( Msg_Error500 pageMsg, Model_Error500 page ) ->
            let
                ( pageModel, pageEffect ) =
                    Pages.Error500.update shared url page.info pageMsg page.model
            in
            ( Model_Error500 { page | model = pageModel }
            , Effect.map Msg_Error500 pageEffect
            )

        _ ->
            ( model, Effect.none )


subscriptions : Shared.Model -> Url -> PageObject Value -> Model -> Sub Msg
subscriptions shared url pageObject model =
    case model of
        Model_Auth_ForgotPassword page ->
            Pages.Auth.ForgotPassword.subscriptions shared url page.props page.model
                |> Sub.map Msg_Auth_ForgotPassword

        Model_Auth_Login page ->
            Pages.Auth.Login.subscriptions shared url page.props page.model
                |> Sub.map Msg_Auth_Login

        Model_Auth_Register page ->
            Pages.Auth.Register.subscriptions shared url page.props page.model
                |> Sub.map Msg_Auth_Register

        Model_Auth_ResetPassword page ->
            Pages.Auth.ResetPassword.subscriptions shared url page.props page.model
                |> Sub.map Msg_Auth_ResetPassword

        Model_Dashboard page ->
            Pages.Dashboard.subscriptions shared url page.props page.model
                |> Sub.map Msg_Dashboard

        Model_Profile_Edit page ->
            Pages.Profile.Edit.subscriptions shared url page.props page.model
                |> Sub.map Msg_Profile_Edit

        Model_Welcome page ->
            Pages.Welcome.subscriptions shared url page.props page.model
                |> Sub.map Msg_Welcome

        Model_Error404 page ->
            Pages.Error404.subscriptions shared url page.model
                |> Sub.map Msg_Error404

        Model_Error500 page ->
            Pages.Error500.subscriptions shared url page.info page.model
                |> Sub.map Msg_Error500


view : Shared.Model -> Url -> PageObject Value -> Model -> Document Msg
view shared url pageObject model =
    case model of
        Model_Auth_ForgotPassword page ->
            Pages.Auth.ForgotPassword.view shared url page.props page.model
                |> mapDocument Msg_Auth_ForgotPassword

        Model_Auth_Login page ->
            Pages.Auth.Login.view shared url page.props page.model
                |> mapDocument Msg_Auth_Login

        Model_Auth_Register page ->
            Pages.Auth.Register.view shared url page.props page.model
                |> mapDocument Msg_Auth_Register

        Model_Auth_ResetPassword page ->
            Pages.Auth.ResetPassword.view shared url page.props page.model
                |> mapDocument Msg_Auth_ResetPassword

        Model_Dashboard page ->
            Pages.Dashboard.view shared url page.props page.model
                |> mapDocument Msg_Dashboard

        Model_Profile_Edit page ->
            Pages.Profile.Edit.view shared url page.props page.model
                |> mapDocument Msg_Profile_Edit

        Model_Welcome page ->
            Pages.Welcome.view shared url page.props page.model
                |> mapDocument Msg_Welcome

        Model_Error404 page ->
            Pages.Error404.view shared url page.model
                |> mapDocument Msg_Error404

        Model_Error500 page ->
            Pages.Error500.view shared url page.info page.model
                |> mapDocument Msg_Error500


onPropsChanged :
    Shared.Model
    -> Url
    -> PageObject Value
    -> Model
    -> ( Model, Effect Msg )
onPropsChanged shared url pageObject model =
    case model of
        Model_Auth_ForgotPassword page ->
            onPropsChangedForPage shared url pageObject page <|
                { decoder = Pages.Auth.ForgotPassword.decoder
                , onPropsChanged = Pages.Auth.ForgotPassword.onPropsChanged
                , toModel = Model_Auth_ForgotPassword
                , toMsg = Msg_Auth_ForgotPassword
                }

        Model_Auth_Login page ->
            onPropsChangedForPage shared url pageObject page <|
                { decoder = Pages.Auth.Login.decoder
                , onPropsChanged = Pages.Auth.Login.onPropsChanged
                , toModel = Model_Auth_Login
                , toMsg = Msg_Auth_Login
                }

        Model_Auth_Register page ->
            onPropsChangedForPage shared url pageObject page <|
                { decoder = Pages.Auth.Register.decoder
                , onPropsChanged = Pages.Auth.Register.onPropsChanged
                , toModel = Model_Auth_Register
                , toMsg = Msg_Auth_Register
                }

        Model_Auth_ResetPassword page ->
            onPropsChangedForPage shared url pageObject page <|
                { decoder = Pages.Auth.ResetPassword.decoder
                , onPropsChanged = Pages.Auth.ResetPassword.onPropsChanged
                , toModel = Model_Auth_ResetPassword
                , toMsg = Msg_Auth_ResetPassword
                }

        Model_Dashboard page ->
            onPropsChangedForPage shared url pageObject page <|
                { decoder = Pages.Dashboard.decoder
                , onPropsChanged = Pages.Dashboard.onPropsChanged
                , toModel = Model_Dashboard
                , toMsg = Msg_Dashboard
                }

        Model_Profile_Edit page ->
            onPropsChangedForPage shared url pageObject page <|
                { decoder = Pages.Profile.Edit.decoder
                , onPropsChanged = Pages.Profile.Edit.onPropsChanged
                , toModel = Model_Profile_Edit
                , toMsg = Msg_Profile_Edit
                }

        Model_Welcome page ->
            onPropsChangedForPage shared url pageObject page <|
                { decoder = Pages.Welcome.decoder
                , onPropsChanged = Pages.Welcome.onPropsChanged
                , toModel = Model_Welcome
                , toMsg = Msg_Welcome
                }

        Model_Error404 page ->
            ( model, Effect.none )

        Model_Error500 page ->
            ( model, Effect.none )



-- HELPERS


mapDocument : (a -> b) -> Browser.Document a -> Browser.Document b
mapDocument fn doc =
    { title = doc.title
    , body = List.map (Html.map fn) doc.body
    }


onPropsChangedForPage :
    Shared.Model
    -> Url
    -> PageObject Value
    -> { props : props, model : model }
    ->
        { decoder : Json.Decode.Decoder props
        , onPropsChanged : Shared.Model -> Url -> props -> model -> ( model, Effect msg )
        , toModel : { props : props, model : model } -> Model
        , toMsg : msg -> Msg
        }
    -> ( Model, Effect Msg )
onPropsChangedForPage shared url pageObject page options =
    case Json.Decode.decodeValue options.decoder pageObject.props of
        Ok props ->
            let
                ( pageModel, pageEffect ) =
                    options.onPropsChanged shared url props page.model
            in
            ( options.toModel { props = props, model = pageModel }
            , Effect.map options.toMsg pageEffect
            )

        Err jsonDecodeError ->
            let
                info : Pages.Error500.Info
                info =
                    { pageObject = pageObject, error = jsonDecodeError }

                ( pageModel, pageEffect ) =
                    Pages.Error500.init shared url info
            in
            ( Model_Error500 { info = info, model = pageModel }
            , Effect.map Msg_Error500 pageEffect
            )


initForPage :
    Shared.Model
    -> Url
    -> PageObject Value
    ->
        { decoder : Json.Decode.Decoder props
        , init : Shared.Model -> Url -> props -> ( model, Effect msg )
        , toModel : { props : props, model : model } -> Model
        , toMsg : msg -> Msg
        }
    -> ( Model, Effect Msg )
initForPage shared url pageObject options =
    case Json.Decode.decodeValue options.decoder pageObject.props of
        Ok props ->
            let
                ( pageModel, pageEffect ) =
                    options.init shared url props
            in
            ( options.toModel { props = props, model = pageModel }
            , Effect.map options.toMsg pageEffect
            )

        Err jsonDecodeError ->
            let
                info : Pages.Error500.Info
                info =
                    { pageObject = pageObject, error = jsonDecodeError }

                ( pageModel, pageEffect ) =
                    Pages.Error500.init shared url info
            in
            ( Model_Error500 { info = info, model = pageModel }
            , Effect.map Msg_Error500 pageEffect
            )
