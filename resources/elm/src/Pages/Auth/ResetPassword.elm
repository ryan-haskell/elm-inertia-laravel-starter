module Pages.Auth.ResetPassword exposing
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
    { token : String
    , email : Maybe String
    , errors : Errors
    }


decoder : Json.Decode.Decoder Props
decoder =
    Json.Decode.map3 Props
        (Json.Decode.field "token" Json.Decode.string)
        (Json.Decode.field "email" (Json.Decode.maybe Json.Decode.string))
        (Json.Decode.field "errors" errorsDecoder)


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
    , passwordConfirmation : String
    }


init : Shared.Model -> Url -> Props -> ( Model, Effect Msg )
init shared url props =
    ( { email = props.email |> Maybe.withDefault ""
      , password = ""
      , passwordConfirmation = ""
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
    | PasswordConfirmationChanged String
    | FormSubmitted
    | ApiResponded (Result Http.Error Props)


update : Shared.Model -> Url -> Props -> Msg -> Model -> ( Model, Effect Msg )
update shared url props msg model =
    case msg of
        EmailChanged value ->
            ( { model | email = value }, Effect.none )

        PasswordChanged value ->
            ( { model | password = value }, Effect.none )

        PasswordConfirmationChanged value ->
            ( { model | passwordConfirmation = value }, Effect.none )

        FormSubmitted ->
            let
                form : Json.Encode.Value
                form =
                    Json.Encode.object
                        [ ( "email", Json.Encode.string model.email )
                        , ( "password", Json.Encode.string model.password )
                        , ( "password_confirmation", Json.Encode.string model.passwordConfirmation )
                        , ( "token", Json.Encode.string props.token )
                        ]
            in
            ( model
            , Effect.post
                { url = "/reset-password"
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
    { title = "Register - Laravel"
    , body =
        [ div [ Attr.class "min-h-screen flex flex-col sm:justify-center items-center pt-6 sm:pt-0 bg-gray-100" ]
            [ a [ Attr.href "/" ] [ Components.Icon.laravelGrayscale ]
            , div [ Attr.class "w-full sm:max-w-md mt-6 px-6 py-4 bg-white shadow-md overflow-hidden sm:rounded-lg" ]
                [ Components.Form.view
                    { autofocusFirstField = True
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
                        , Components.Form.PasswordInput
                            { id = "passwordConfirmation"
                            , label = "Confirm Password"
                            , value = model.passwordConfirmation
                            , onInput = PasswordConfirmationChanged
                            , required = True
                            , error = Nothing
                            }
                        ]
                    , controls =
                        Components.Form.ControlsRight
                            { button =
                                { label = "Reset password"
                                , onClick = FormSubmitted
                                }
                            , link = Nothing
                            }
                    }
                ]
            ]
        ]
    }
