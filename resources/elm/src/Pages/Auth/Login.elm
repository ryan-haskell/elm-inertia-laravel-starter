module Pages.Auth.Login exposing
    ( Props, decoder
    , Model, init, onPropsChanged
    , Msg, update, subscriptions
    , view
    )

{-|

@docs Props, decoder
@docs Model, init, onPropsChanged
@docs Msg, update, subscriptions
@docs view

-}

import Browser
import Components.Form
import Components.Icon
import Effect exposing (Effect)
import Html exposing (..)
import Html.Attributes as Attr
import Http
import Json.Decode
import Json.Encode
import Shared
import Url exposing (Url)



-- PROPS


type alias Props =
    { errors : Errors
    , canResetPassword : Bool
    }


decoder : Json.Decode.Decoder Props
decoder =
    Json.Decode.map2 Props
        (Json.Decode.field "errors" errorsDecoder)
        (Json.Decode.field "canResetPassword" Json.Decode.bool)


type alias Errors =
    { email : Maybe String
    , password : Maybe String
    }


errorsDecoder : Json.Decode.Decoder Errors
errorsDecoder =
    Json.Decode.map2 Errors
        (Json.Decode.maybe (Json.Decode.field "email" Json.Decode.string))
        (Json.Decode.maybe (Json.Decode.field "password" Json.Decode.string))



-- MODEL


type alias Model =
    { email : String
    , password : String
    , remember : Bool
    }


init : Shared.Model -> Url -> Props -> ( Model, Effect Msg )
init shared url props =
    ( { email = ""
      , password = ""
      , remember = False
      }
    , Effect.none
    )


onPropsChanged : Shared.Model -> Url -> Props -> Model -> ( Model, Effect Msg )
onPropsChanged shared url props model =
    ( model, Effect.none )



-- UPDATE


type Msg
    = EmailChanged String
    | PasswordChanged String
    | RememberMeChanged Bool
    | FormSubmitted
    | ApiResponded (Result Http.Error Props)


update : Shared.Model -> Url -> Props -> Msg -> Model -> ( Model, Effect Msg )
update shared url props msg model =
    case msg of
        EmailChanged value ->
            ( { model | email = value }, Effect.none )

        PasswordChanged value ->
            ( { model | password = value }, Effect.none )

        RememberMeChanged value ->
            ( { model | remember = value }, Effect.none )

        FormSubmitted ->
            let
                form : Json.Encode.Value
                form =
                    Json.Encode.object
                        [ ( "email", Json.Encode.string model.email )
                        , ( "password", Json.Encode.string model.password )
                        , ( "remember", Json.Encode.bool model.remember )
                        ]
            in
            ( model
            , Effect.post
                { url = "/login"
                , body = Http.jsonBody form
                , decoder = decoder
                , onResponse = ApiResponded
                }
            )

        ApiResponded (Ok _) ->
            ( model, Effect.none )

        ApiResponded (Err httpError) ->
            -- TODO: Handle HTTP errors
            ( model, Effect.none )


subscriptions : Shared.Model -> Url -> Props -> Model -> Sub Msg
subscriptions shared url props model =
    Sub.none



-- VIEW


view : Shared.Model -> Url -> Props -> Model -> Browser.Document Msg
view shared url props model =
    { title = "Log in - Laravel"
    , body =
        [ div [ Attr.class "min-h-screen flex flex-col sm:justify-center items-center pt-6 sm:pt-0 bg-gray-100" ]
            [ a [ Attr.href "/" ] [ Components.Icon.laravelGrayscale ]
            , Components.Form.view
                { intro = Nothing
                , fields =
                    [ Components.Form.EmailInput
                        { id = "email"
                        , label = "Email"
                        , value = model.email
                        , onInput = EmailChanged
                        , required = True
                        , error = props.errors.email
                        }
                    , Components.Form.PasswordInput
                        { id = "password"
                        , label = "Password"
                        , value = model.password
                        , onInput = PasswordChanged
                        , required = True
                        , error = props.errors.password
                        }
                    , Components.Form.Checkbox
                        { label = "Remember me"
                        , value = model.remember
                        , onInput = RememberMeChanged
                        }
                    ]
                , button =
                    { label = "Log in"
                    , onClick = FormSubmitted
                    }
                , link =
                    if props.canResetPassword then
                        Just
                            { label = "Forgot your password?"
                            , url = "/forgot-password"
                            }

                    else
                        Nothing
                }
            ]
        ]
    }
