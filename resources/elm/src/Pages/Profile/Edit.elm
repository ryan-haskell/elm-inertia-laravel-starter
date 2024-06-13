module Pages.Profile.Edit exposing
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
import Components.Header
import Components.Icon
import Effect exposing (Effect)
import Html exposing (..)
import Html.Attributes as Attr
import Html.Events
import Http
import Json.Decode
import Json.Encode
import Layouts.Navbar
import Shared
import Shared.Auth exposing (Auth)
import Url exposing (Url)



-- PROPS


type alias Props =
    { auth : Auth
    , errors : Errors
    }


decoder : Json.Decode.Decoder Props
decoder =
    Json.Decode.map2 Props
        (Json.Decode.field "auth" Shared.Auth.decoder)
        (Json.Decode.field "errors" errorsDecoder)


type alias Errors =
    { name : Maybe String
    , email : Maybe String
    , currentPassword : Maybe String
    , password : Maybe String
    }


errorsDecoder : Json.Decode.Decoder Errors
errorsDecoder =
    Json.Decode.map4 Errors
        (Json.Decode.maybe (Json.Decode.field "name" Json.Decode.string))
        (Json.Decode.maybe (Json.Decode.field "email" Json.Decode.string))
        (Json.Decode.maybe (Json.Decode.field "current_password" Json.Decode.string))
        (Json.Decode.maybe (Json.Decode.field "password" Json.Decode.string))


hasAnyErrors : Errors -> Bool
hasAnyErrors errors =
    List.any (\toError -> toError errors /= Nothing)
        [ .name
        , .email
        , .currentPassword
        , .password
        ]



-- MODEL


type alias Model =
    { layout : Layouts.Navbar.Model
    , name : String
    , email : String
    , infoStatus : Maybe String
    , currentPassword : String
    , password : String
    , passwordConfirmation : String
    , passwordStatus : Maybe String
    , isDeleteConfirmationOpen : Bool
    }


init : Shared.Model -> Url -> Props -> ( Model, Effect Msg )
init shared url props =
    ( { layout = Layouts.Navbar.init
      , name = props.auth.user.name
      , email = props.auth.user.email
      , infoStatus = Nothing
      , currentPassword = ""
      , password = ""
      , passwordConfirmation = ""
      , passwordStatus = Nothing
      , isDeleteConfirmationOpen = False
      }
    , Effect.none
    )


onPropsChanged : Shared.Model -> Url -> Props -> Model -> ( Model, Effect Msg )
onPropsChanged shared url props model =
    ( model, Effect.none )



-- UPDATE


type Msg
    = Layout Layouts.Navbar.Msg
    | ChangedName String
    | ChangedEmail String
    | ClickedSaveProfileInfo
    | ProfileInfoSaved (Result Http.Error ())
    | HideSavedMessage
    | ChangedCurrentPassword String
    | ChangedPassword String
    | ChangedPasswordConfirmation String
    | ClickedChangePassword
    | NewPasswordSaved (Result Http.Error Props)
    | ClickedDeleteUser
    | DeleteUserResponded (Result Http.Error ())
    | ClickedDeleteModalBackground


update : Shared.Model -> Url -> Props -> Msg -> Model -> ( Model, Effect Msg )
update shared url props msg model =
    case msg of
        Layout layoutMsg ->
            Layouts.Navbar.update
                { msg = layoutMsg
                , model = model.layout
                , toModel = \layout -> { model | layout = layout }
                , toMsg = Layout
                }

        ChangedName value ->
            ( { model | name = value }, Effect.none )

        ChangedEmail value ->
            ( { model | email = value }, Effect.none )

        ClickedSaveProfileInfo ->
            let
                form : Json.Encode.Value
                form =
                    Json.Encode.object
                        [ ( "name", Json.Encode.string model.name )
                        , ( "email", Json.Encode.string model.email )
                        ]
            in
            ( model
            , Effect.patch
                { url = "/profile"
                , body = Http.jsonBody form
                , decoder = Json.Decode.succeed ()
                , onResponse = ProfileInfoSaved
                }
            )

        ProfileInfoSaved (Ok ()) ->
            ( { model | infoStatus = Just "Saved." }
            , Effect.sendMsgAfterDelay
                { delayInMs = 3000
                , msg = HideSavedMessage
                }
            )

        ProfileInfoSaved (Err httpError) ->
            -- TODO: Communicate HTTP error
            ( model, Effect.none )

        HideSavedMessage ->
            ( { model
                | infoStatus = Nothing
                , passwordStatus = Nothing
              }
            , Effect.none
            )

        ChangedCurrentPassword value ->
            ( { model | currentPassword = value }, Effect.none )

        ChangedPassword value ->
            ( { model | password = value }, Effect.none )

        ChangedPasswordConfirmation value ->
            ( { model | passwordConfirmation = value }, Effect.none )

        ClickedChangePassword ->
            let
                form : Json.Encode.Value
                form =
                    Json.Encode.object
                        [ ( "current_password", Json.Encode.string model.currentPassword )
                        , ( "password", Json.Encode.string model.password )
                        , ( "password_confirmation", Json.Encode.string model.passwordConfirmation )
                        ]
            in
            ( model
            , Effect.put
                { url = "/password"
                , body = Http.jsonBody form
                , decoder = decoder
                , onResponse = NewPasswordSaved
                }
            )

        NewPasswordSaved (Ok newProps) ->
            if hasAnyErrors newProps.errors then
                ( model
                , Effect.none
                )

            else
                ( { model
                    | passwordStatus = Just "Password updated."
                    , password = ""
                    , currentPassword = ""
                    , passwordConfirmation = ""
                  }
                , Effect.sendMsgAfterDelay
                    { delayInMs = 3000
                    , msg = HideSavedMessage
                    }
                )

        NewPasswordSaved (Err httpError) ->
            -- TODO: Communicate HTTP error
            ( model, Effect.none )

        ClickedDeleteUser ->
            ( { model | isDeleteConfirmationOpen = True }
            , Effect.none
            )

        ClickedDeleteModalBackground ->
            ( { model | isDeleteConfirmationOpen = False }
            , Effect.none
            )

        DeleteUserResponded (Ok ()) ->
            ( model, Effect.none )

        DeleteUserResponded (Err httpError) ->
            -- TODO: Communicate HTTP error
            ( model, Effect.none )


subscriptions : Shared.Model -> Url -> Props -> Model -> Sub Msg
subscriptions shared url props model =
    Sub.none



-- VIEW


view : Shared.Model -> Url -> Props -> Model -> Browser.Document Msg
view shared url props model =
    Layouts.Navbar.view
        { title = "Profile"
        , url = url
        , auth = props.auth
        , model = model.layout
        , toMsg = Layout
        , body =
            [ viewMainContent props model
            ]
        }


viewMainContent : Props -> Model -> Html Msg
viewMainContent props model =
    main_ []
        [ div [ Attr.class "py-12" ]
            [ div [ Attr.class "max-w-7xl mx-auto sm:px-6 lg:px-8 space-y-6" ]
                [ viewProfileInfoForm props model
                , div [ Attr.class "my-4" ] []
                , viewPasswordChangeForm props model
                , div [ Attr.class "my-4" ] []

                -- , viewDeleteForm model
                , if model.isDeleteConfirmationOpen then
                    viewDeleteConfirmationDialog

                  else
                    text ""
                ]
            ]
        ]


viewProfileInfoForm : Props -> Model -> Html Msg
viewProfileInfoForm props model =
    viewForm
        { title = "Profile Information"
        , subtitle = "Update your account's profile information and email address."
        , fields =
            [ Components.Form.TextInput
                { id = "name"
                , label = "Name"
                , value = model.name
                , onInput = ChangedName
                , required = False
                , error = props.errors.name
                }
            , Components.Form.EmailInput
                { id = "email"
                , label = "Email address"
                , value = model.email
                , onInput = ChangedEmail
                , required = False
                , error = props.errors.email
                }
            ]
        , button =
            { label = "Save"
            , onClick = ClickedSaveProfileInfo
            }
        , status = model.infoStatus
        }


viewPasswordChangeForm : Props -> Model -> Html Msg
viewPasswordChangeForm props model =
    viewForm
        { title = "Update Password"
        , subtitle = " Ensure your account is using a long, random password to stay secure."
        , fields =
            [ Components.Form.PasswordInput
                { id = "current_password"
                , label = "Current Password"
                , value = model.currentPassword
                , onInput = ChangedCurrentPassword
                , required = True
                , error = props.errors.currentPassword
                }
            , Components.Form.PasswordInput
                { id = "password"
                , label = "New Password"
                , value = model.password
                , onInput = ChangedPassword
                , required = True
                , error = props.errors.password
                }
            , Components.Form.PasswordInput
                { id = "password_confirmation"
                , label = "Confirm Password"
                , value = model.passwordConfirmation
                , onInput = ChangedPasswordConfirmation
                , required = True
                , error = Nothing
                }
            ]
        , button =
            { label = "Save"
            , onClick = ClickedChangePassword
            }
        , status = model.passwordStatus
        }


viewDeleteForm : Model -> Html Msg
viewDeleteForm model =
    div [ Attr.class "p-4 sm:p-8 bg-white shadow sm:rounded-lg" ]
        [ Components.Header.view
            { title = "Delete Account"
            , subtitle = " Once your account is deleted, all of its resources and data will be permanently deleted. Before deleting your account, please download any data or information that you wish to retain."
            }
        , button
            [ Attr.class "inline-flex items-center px-4 py-2 bg-red-600 border border-transparent rounded-md font-semibold text-xs text-white uppercase tracking-widest hover:bg-red-500 active:bg-red-700 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2 transition ease-in-out duration-150"
            , Html.Events.onClick ClickedDeleteUser
            ]
            [ text "Delete Account" ]
        ]


viewForm :
    { title : String
    , subtitle : String
    , fields : List (Components.Form.Field msg)
    , button : { label : String, onClick : msg }
    , status : Maybe String
    }
    -> Html msg
viewForm props =
    div [ Attr.class "p-4 sm:p-8 bg-white shadow sm:rounded-lg" ]
        [ Components.Header.view
            { title = props.title
            , subtitle = props.subtitle
            }
        , Components.Form.view
            { fields = props.fields
            , controls =
                Components.Form.ControlsLeft
                    { button = props.button
                    , message = props.status
                    }
            }
        ]


viewDeleteConfirmationDialog : Html Msg
viewDeleteConfirmationDialog =
    div
        [ Attr.class "fixed inset-0 overflow-y-auto px-4 py-6 sm:px-0 z-50"
        , Attr.id "scroll-region"
        ]
        [ div [ Attr.class "fixed inset-0 transform transition-all", Html.Events.onClick ClickedDeleteModalBackground ]
            [ div [ Attr.class "absolute inset-0 bg-gray-500 opacity-75" ] []
            ]
        , div [ Attr.class "mb-6 bg-white rounded-lg overflow-hidden shadow-xl transform transition-all sm:w-full sm:mx-auto sm:max-w-2xl" ]
            [ div
                [ Attr.class "p-6" ]
                [ h2 [ Attr.class "text-lg font-medium text-gray-900" ]
                    [ text "Are you sure you want to delete your account?" ]
                , p [ Attr.class "mt-1 text-sm text-gray-600" ]
                    [ text "Once your account is deleted, all of its resources and data will be permanently deleted. Please enter your password to confirm you would like to permanently delete your account."
                    ]
                , div [ Attr.class "mt-6" ]
                    [ label
                        [ Attr.class "block font-medium text-sm text-gray-700 sr-only"
                        , Attr.for "delete_password"
                        ]
                        [ span [] [ text "Password" ] ]
                    , input
                        [ Attr.class "border-gray-300 focus:border-indigo-500 focus:ring-indigo-500 rounded-md shadow-sm mt-1 block w-3/4"
                        , Attr.id "delete_password"
                        , Attr.type_ "password"
                        , Attr.placeholder "Password"
                        ]
                        []
                    ]
                , div
                    [ Attr.class "mt-6 flex justify-end" ]
                    [ button
                        [ Attr.type_ "button"
                        , Attr.class "inline-flex items-center px-4 py-2 bg-white border border-gray-300 rounded-md font-semibold text-xs text-gray-700 uppercase tracking-widest shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 disabled:opacity-25 transition ease-in-out duration-150"
                        ]
                        [ text "Cancel" ]
                    , button [ Attr.class "inline-flex items-center px-4 py-2 bg-red-600 border border-transparent rounded-md font-semibold text-xs text-white uppercase tracking-widest hover:bg-red-500 active:bg-red-700 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2 transition ease-in-out duration-150 ms-3" ]
                        [ text "Delete Account" ]
                    ]
                ]
            ]
        ]
