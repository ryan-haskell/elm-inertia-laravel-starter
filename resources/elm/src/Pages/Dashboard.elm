module Pages.Dashboard exposing
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
import Components.Icon
import Effect exposing (Effect)
import Html exposing (..)
import Html.Attributes as Attr
import Html.Events
import Http
import Json.Decode
import Layouts.Navbar
import Shared
import Shared.Auth exposing (Auth)
import Url exposing (Url)



-- PROPS


type alias Props =
    { auth : Auth
    }


decoder : Json.Decode.Decoder Props
decoder =
    Json.Decode.map Props
        (Json.Decode.field "auth" Shared.Auth.decoder)



-- MODEL


type alias Model =
    { layout : Layouts.Navbar.Model
    }


init : Shared.Model -> Url -> Props -> ( Model, Effect Msg )
init shared url props =
    ( { layout = Layouts.Navbar.init }
    , Effect.none
    )


onPropsChanged : Shared.Model -> Url -> Props -> Model -> ( Model, Effect Msg )
onPropsChanged shared url props model =
    ( model, Effect.none )



-- UPDATE


type Msg
    = Layout Layouts.Navbar.Msg


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


subscriptions : Shared.Model -> Url -> Props -> Model -> Sub Msg
subscriptions shared url props model =
    Sub.none



-- VIEW


view : Shared.Model -> Url -> Props -> Model -> Browser.Document Msg
view shared url props model =
    Layouts.Navbar.view
        { title = "Dashboard"
        , url = url
        , auth = props.auth
        , model = model.layout
        , toMsg = Layout
        , body = [ viewMainContent ]
        }


viewMainContent : Html msg
viewMainContent =
    main_ []
        [ div [ Attr.class "py-12" ]
            [ div [ Attr.class "max-w-7xl mx-auto sm:px-6 lg:px-8" ]
                [ div [ Attr.class "bg-white overflow-hidden shadow-sm sm:rounded-lg" ]
                    [ div [ Attr.class "p-6 text-gray-900" ]
                        [ text "You're logged in!" ]
                    ]
                ]
            ]
        ]
