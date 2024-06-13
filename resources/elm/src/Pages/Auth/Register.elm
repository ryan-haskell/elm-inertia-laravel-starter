module Pages.Auth.Register exposing
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
    }


decoder : Json.Decode.Decoder Props
decoder =
    Json.Decode.map Props
        (Json.Decode.field "errors" errorsDecoder)


type alias Errors =
    { name : Maybe String
    , email : Maybe String
    , password : Maybe String
    }


errorsDecoder : Json.Decode.Decoder Errors
errorsDecoder =
    Json.Decode.map3 Errors
        (Json.Decode.maybe (Json.Decode.field "name" Json.Decode.string))
        (Json.Decode.maybe (Json.Decode.field "email" Json.Decode.string))
        (Json.Decode.maybe (Json.Decode.field "password" Json.Decode.string))



-- MODEL


type alias Model =
    { name : String
    , email : String
    , password : String
    , passwordConfirmation : String
    }


init : Shared.Model -> Url -> Props -> ( Model, Effect Msg )
init shared url props =
    ( { name = ""
      , email = ""
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
    = NameChanged String
    | EmailChanged String
    | PasswordChanged String
    | PasswordConfirmationChanged String
    | FormSubmitted
    | ApiResponded (Result Http.Error Props)


update : Shared.Model -> Url -> Props -> Msg -> Model -> ( Model, Effect Msg )
update shared url props msg model =
    case msg of
        NameChanged value ->
            ( { model | name = value }, Effect.none )

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
                        [ ( "name", Json.Encode.string model.name )
                        , ( "email", Json.Encode.string model.email )
                        , ( "password", Json.Encode.string model.password )
                        , ( "password_confirmation", Json.Encode.string model.passwordConfirmation )
                        ]
            in
            ( model
            , Effect.post
                { url = "/register"
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
                        [ Components.Form.TextInput
                            { id = "name"
                            , label = "Name"
                            , value = model.name
                            , onInput = NameChanged
                            , required = True
                            , error = props.errors.name
                            }
                        , Components.Form.EmailInput
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
                                { label = "Register"
                                , onClick = FormSubmitted
                                }
                            , link =
                                Just
                                    { label = "Already registered?"
                                    , url = "/login"
                                    }
                            }
                    }
                ]
            ]
        ]
    }
