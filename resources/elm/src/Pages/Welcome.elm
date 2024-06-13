module Pages.Welcome exposing
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
import Json.Decode
import Shared
import Shared.Auth
import Url exposing (Url)



-- PROPS


type alias Props =
    { isSignedIn : Bool
    , laravelVersion : String
    , phpVersion : String
    , canLogin : Bool
    , canRegister : Bool
    }


decoder : Json.Decode.Decoder Props
decoder =
    Json.Decode.map5 Props
        (Json.Decode.oneOf
            [ Json.Decode.at [ "auth", "user" ] (Json.Decode.null False)
            , Json.Decode.succeed True
            ]
        )
        (Json.Decode.field "laravelVersion" Json.Decode.string)
        (Json.Decode.field "phpVersion" Json.Decode.string)
        (Json.Decode.field "canLogin" Json.Decode.bool)
        (Json.Decode.field "canRegister" Json.Decode.bool)



-- MODEL


type alias Model =
    {}


init : Shared.Model -> Url -> Props -> ( Model, Effect Msg )
init shared url props =
    ( {}
    , Effect.none
    )


onPropsChanged : Shared.Model -> Url -> Props -> Model -> ( Model, Effect Msg )
onPropsChanged shared url props model =
    ( model, Effect.none )



-- UPDATE


type Msg
    = NoOp


update : Shared.Model -> Url -> Props -> Msg -> Model -> ( Model, Effect Msg )
update shared url props msg model =
    case msg of
        NoOp ->
            ( model, Effect.none )


subscriptions : Shared.Model -> Url -> Props -> Model -> Sub Msg
subscriptions shared url props model =
    Sub.none



-- VIEW


view : Shared.Model -> Url -> Props -> Model -> Browser.Document Msg
view shared url props model =
    { title = "Welcome - Laravel"
    , body =
        [ div
            [ Attr.class "bg-gray-50 text-black/50 dark:bg-black dark:text-white/50" ]
            [ viewLaravelLogo
            , div [ Attr.class "relative min-h-screen flex flex-col items-center justify-center selection:bg-[#FF2D20] selection:text-white" ]
                [ div [ Attr.class "relative w-full max-w-2xl px-6 lg:max-w-7xl" ]
                    [ header
                        [ Attr.class "grid grid-cols-2 items-center gap-2 py-10 lg:grid-cols-3" ]
                        [ div [ Attr.class "flex lg:justify-center lg:col-start-2" ]
                            [ Components.Icon.laravelRed
                            ]
                        , if props.isSignedIn then
                            nav
                                [ Attr.class "-mx-3 flex flex-1 justify-end" ]
                                [ viewLink { label = "Dashboard", url = "/dashboard" }
                                ]

                          else
                            nav
                                [ Attr.class "-mx-3 flex flex-1 justify-end" ]
                                [ if props.canLogin then
                                    viewLink { label = "Login", url = "/login" }

                                  else
                                    text ""
                                , if props.canRegister then
                                    viewLink { label = "Register", url = "/register" }

                                  else
                                    text ""
                                ]
                        ]
                    , main_
                        [ Attr.class "mt-6" ]
                        [ div
                            [ Attr.class "grid gap-6 lg:grid-cols-2 lg:gap-8" ]
                            [ a
                                [ Attr.href "https://laravel.com/docs"
                                , Attr.id "docs-card"
                                , Attr.class
                                    "flex flex-col items-start gap-6 overflow-hidden rounded-lg bg-white p-6 shadow-[0px_14px_34px_0px_rgba(0,0,0,0.08)] ring-1 ring-white/[0.05] transition duration-300 hover:text-black/70 hover:ring-black/20 focus:outline-none focus-visible:ring-[#FF2D20] md:row-span-3 lg:p-10 lg:pb-10 dark:bg-zinc-900 dark:ring-zinc-800 dark:hover:text-white/70 dark:hover:ring-zinc-700 dark:focus-visible:ring-[#FF2D20]"
                                ]
                                [ div
                                    [ Attr.id "screenshot-container"
                                    , Attr.class "relative flex w-full flex-1 items-stretch"
                                    ]
                                    [ img
                                        [ Attr.src
                                            "https://laravel.com/assets/img/welcome/docs-light.svg"
                                        , Attr.alt "Laravel documentation screenshot"
                                        , Attr.class
                                            "aspect-video h-full w-full flex-1 rounded-[10px] object-top object-cover drop-shadow-[0px_4px_34px_rgba(0,0,0,0.06)] dark:hidden"
                                        ]
                                        []
                                    , img
                                        [ Attr.src
                                            "https://laravel.com/assets/img/welcome/docs-dark.svg"
                                        , Attr.alt "Laravel documentation screenshot"
                                        , Attr.class
                                            "hidden aspect-video h-full w-full flex-1 rounded-[10px] object-top object-cover drop-shadow-[0px_4px_34px_rgba(0,0,0,0.25)] dark:block"
                                        ]
                                        []
                                    , div
                                        [ Attr.class
                                            "absolute -bottom-16 -left-16 h-40 w-[calc(100%+8rem)] bg-gradient-to-b from-transparent via-white to-white dark:via-zinc-900 dark:to-zinc-900"
                                        ]
                                        []
                                    ]
                                , div
                                    [ Attr.class
                                        "relative flex items-center gap-6 lg:items-end"
                                    ]
                                    [ div
                                        [ Attr.id "docs-card-content"
                                        , Attr.class "flex items-start gap-6 lg:flex-col"
                                        ]
                                        [ div
                                            [ Attr.class
                                                "flex size-12 shrink-0 items-center justify-center rounded-full bg-[#FF2D20]/10 sm:size-16"
                                            ]
                                            [ Components.Icon.documentation
                                            ]
                                        , div
                                            [ Attr.class "pt-3 sm:pt-5 lg:pt-0" ]
                                            [ h2
                                                [ Attr.class
                                                    "text-xl font-semibold text-black dark:text-white"
                                                ]
                                                [ text "Documentation" ]
                                            , p
                                                [ Attr.class "mt-4 text-sm/relaxed" ]
                                                [ text
                                                    "Laravel has wonderful documentation covering every aspect of the framework. Whether you are a newcomer or have prior experience with Laravel, we recommend reading our documentation from beginning to end."
                                                ]
                                            ]
                                        ]
                                    , Components.Icon.arrowRight
                                    ]
                                ]
                            , a
                                [ Attr.href "https://laracasts.com"
                                , Attr.class
                                    "flex items-start gap-4 rounded-lg bg-white p-6 shadow-[0px_14px_34px_0px_rgba(0,0,0,0.08)] ring-1 ring-white/[0.05] transition duration-300 hover:text-black/70 hover:ring-black/20 focus:outline-none focus-visible:ring-[#FF2D20] lg:pb-10 dark:bg-zinc-900 dark:ring-zinc-800 dark:hover:text-white/70 dark:hover:ring-zinc-700 dark:focus-visible:ring-[#FF2D20]"
                                ]
                                [ div
                                    [ Attr.class
                                        "flex size-12 shrink-0 items-center justify-center rounded-full bg-[#FF2D20]/10 sm:size-16"
                                    ]
                                    [ Components.Icon.laracasts
                                    ]
                                , div
                                    [ Attr.class "pt-3 sm:pt-5" ]
                                    [ h2
                                        [ Attr.class
                                            "text-xl font-semibold text-black dark:text-white"
                                        ]
                                        [ text "Laracasts" ]
                                    , p
                                        [ Attr.class "mt-4 text-sm/relaxed" ]
                                        [ text
                                            "Laracasts offers thousands of video tutorials on Laravel, PHP, and JavaScript development. Check them out, see for yourself, and massively level up your development skills in the process."
                                        ]
                                    ]
                                , Components.Icon.arrowRight
                                ]
                            , a
                                [ Attr.href "https://laravel-news.com"
                                , Attr.class "flex items-start gap-4 rounded-lg bg-white p-6 shadow-[0px_14px_34px_0px_rgba(0,0,0,0.08)] ring-1 ring-white/[0.05] transition duration-300 hover:text-black/70 hover:ring-black/20 focus:outline-none focus-visible:ring-[#FF2D20] lg:pb-10 dark:bg-zinc-900 dark:ring-zinc-800 dark:hover:text-white/70 dark:hover:ring-zinc-700 dark:focus-visible:ring-[#FF2D20]"
                                ]
                                [ div [ Attr.class "flex size-12 shrink-0 items-center justify-center rounded-full bg-[#FF2D20]/10 sm:size-16" ]
                                    [ Components.Icon.news
                                    ]
                                , div [ Attr.class "pt-3 sm:pt-5" ]
                                    [ h2 [ Attr.class "text-xl font-semibold text-black dark:text-white" ]
                                        [ text "Laravel News" ]
                                    , p [ Attr.class "mt-4 text-sm/relaxed" ]
                                        [ text "Laravel News is a community driven portal and newsletter aggregating all of the latest and most important news in the Laravel ecosystem, including new package releases and tutorials." ]
                                    ]
                                , Components.Icon.arrowRight
                                ]
                            , div [ Attr.class "flex items-start gap-4 rounded-lg bg-white p-6 shadow-[0px_14px_34px_0px_rgba(0,0,0,0.08)] ring-1 ring-white/[0.05] lg:pb-10 dark:bg-zinc-900 dark:ring-zinc-800" ]
                                [ div [ Attr.class "flex size-12 shrink-0 items-center justify-center rounded-full bg-[#FF2D20]/10 sm:size-16" ]
                                    [ Components.Icon.ecosystem
                                    ]
                                , div [ Attr.class "pt-3 sm:pt-5" ]
                                    [ h2 [ Attr.class "text-xl font-semibold text-black dark:text-white" ]
                                        [ text "Vibrant Ecosystem" ]
                                    , p [ Attr.class "mt-4 text-sm/relaxed" ]
                                        [ text "Laravel's robust library of first-party tools and libraries, such as "
                                        , a
                                            [ Attr.href "https://forge.laravel.com"
                                            , Attr.class "rounded-sm underline hover:text-black focus:outline-none focus-visible:ring-1 focus-visible:ring-[#FF2D20] dark:hover:text-white dark:focus-visible:ring-[#FF2D20]"
                                            ]
                                            [ text "Forge" ]
                                        , text ", "
                                        , a
                                            [ Attr.href "https://vapor.laravel.com"
                                            , Attr.class
                                                "rounded-sm underline hover:text-black focus:outline-none focus-visible:ring-1 focus-visible:ring-[#FF2D20] dark:hover:text-white"
                                            ]
                                            [ text "Vapor" ]
                                        , text ", "
                                        , a
                                            [ Attr.href "https://nova.laravel.com"
                                            , Attr.class
                                                "rounded-sm underline hover:text-black focus:outline-none focus-visible:ring-1 focus-visible:ring-[#FF2D20] dark:hover:text-white"
                                            ]
                                            [ text "Nova" ]
                                        , text ", "
                                        , a
                                            [ Attr.href "https://envoyer.io"
                                            , Attr.class
                                                "rounded-sm underline hover:text-black focus:outline-none focus-visible:ring-1 focus-visible:ring-[#FF2D20] dark:hover:text-white"
                                            ]
                                            [ text "Envoyer" ]
                                        , text ", and "
                                        , a
                                            [ Attr.href "https://herd.laravel.com"
                                            , Attr.class
                                                "rounded-sm underline hover:text-black focus:outline-none focus-visible:ring-1 focus-visible:ring-[#FF2D20] dark:hover:text-white"
                                            ]
                                            [ text "Herd" ]
                                        , text
                                            " help you take your projects to the next level. Pair them with powerful open source libraries like "
                                        , a
                                            [ Attr.href "https://laravel.com/docs/billing"
                                            , Attr.class
                                                "rounded-sm underline hover:text-black focus:outline-none focus-visible:ring-1 focus-visible:ring-[#FF2D20] dark:hover:text-white"
                                            ]
                                            [ text "Cashier" ]
                                        , text ", "
                                        , a
                                            [ Attr.href "https://laravel.com/docs/dusk"
                                            , Attr.class
                                                "rounded-sm underline hover:text-black focus:outline-none focus-visible:ring-1 focus-visible:ring-[#FF2D20] dark:hover:text-white"
                                            ]
                                            [ text "Dusk" ]
                                        , text ", "
                                        , a
                                            [ Attr.href
                                                "https://laravel.com/docs/broadcasting"
                                            , Attr.class
                                                "rounded-sm underline hover:text-black focus:outline-none focus-visible:ring-1 focus-visible:ring-[#FF2D20] dark:hover:text-white"
                                            ]
                                            [ text "Echo" ]
                                        , text ", "
                                        , a
                                            [ Attr.href "https://laravel.com/docs/horizon"
                                            , Attr.class
                                                "rounded-sm underline hover:text-black focus:outline-none focus-visible:ring-1 focus-visible:ring-[#FF2D20] dark:hover:text-white"
                                            ]
                                            [ text "Horizon" ]
                                        , text ", "
                                        , a
                                            [ Attr.href "https://laravel.com/docs/sanctum"
                                            , Attr.class
                                                "rounded-sm underline hover:text-black focus:outline-none focus-visible:ring-1 focus-visible:ring-[#FF2D20] dark:hover:text-white"
                                            ]
                                            [ text "Sanctum" ]
                                        , text ", "
                                        , a
                                            [ Attr.href "https://laravel.com/docs/telescope"
                                            , Attr.class
                                                "rounded-sm underline hover:text-black focus:outline-none focus-visible:ring-1 focus-visible:ring-[#FF2D20] dark:hover:text-white"
                                            ]
                                            [ text "Telescope" ]
                                        , text ", and more."
                                        ]
                                    ]
                                , Components.Icon.arrowRight
                                ]
                            ]
                        ]
                    , footer
                        [ Attr.class
                            "py-16 text-center text-sm text-black dark:text-white/70"
                        ]
                        [ "Laravel v${laravelVersion} (PHP v${phpVersion})"
                            |> String.replace "${laravelVersion}" props.laravelVersion
                            |> String.replace "${phpVersion}" props.phpVersion
                            |> text
                        ]
                    ]
                ]
            ]
        ]
    }


viewLaravelLogo : Html msg
viewLaravelLogo =
    img
        [ Attr.id "background"
        , Attr.class "absolute -left-20 top-0 max-w-[877px]"
        , Attr.src "https://laravel.com/assets/img/welcome/background.svg"
        ]
        []


viewLink : { label : String, url : String } -> Html msg
viewLink props =
    a
        [ Attr.class "rounded-md px-3 py-2 text-black ring-1 ring-transparent transition hover:text-black/70 focus:outline-none focus-visible:ring-[#FF2D20] dark:text-white dark:hover:text-white/80 dark:focus-visible:ring-white"
        , Attr.href props.url
        ]
        [ text props.label ]
