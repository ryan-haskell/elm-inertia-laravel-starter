module Layouts.Navbar exposing (Model, Msg, init, update, view)

import Browser
import Components.Icon
import Effect exposing (Effect)
import Html exposing (..)
import Html.Attributes as Attr
import Html.Events
import Http
import Json.Decode
import Shared.Auth exposing (Auth)
import Url exposing (Url)



-- INIT


type Model
    = Model
        { isDropdownOpen : Bool
        }


init : Model
init =
    Model { isDropdownOpen = False }



-- UPDATE


type Msg
    = ClosedUserDropdown
    | ToggledUserDropdown
    | ClickedLogout
    | LogoutResponded (Result Http.Error ())


update :
    { msg : Msg
    , model : Model
    , toModel : Model -> model
    , toMsg : Msg -> msg
    }
    -> ( model, Effect msg )
update ({ msg, toModel, toMsg } as props) =
    let
        (Model model) =
            props.model

        return =
            Tuple.mapBoth (Model >> toModel) (Effect.map toMsg)
    in
    case msg of
        ToggledUserDropdown ->
            return
                ( { model | isDropdownOpen = not model.isDropdownOpen }
                , Effect.none
                )

        ClosedUserDropdown ->
            return
                ( { model | isDropdownOpen = False }
                , Effect.none
                )

        ClickedLogout ->
            return
                ( model
                , Effect.post
                    { url = "/logout"
                    , decoder = Json.Decode.succeed ()
                    , body = Http.emptyBody
                    , onResponse = LogoutResponded
                    }
                )

        LogoutResponded (Ok ()) ->
            return ( model, Effect.none )

        LogoutResponded (Err httpError) ->
            -- TODO: Communicate problem to user
            return ( model, Effect.none )


view :
    { title : String
    , url : Url
    , auth : Auth
    , model : Model
    , toMsg : Msg -> msg
    , body : List (Html msg)
    }
    -> Browser.Document msg
view props =
    { title = props.title ++ " - Laravel"
    , body =
        [ div [ Attr.class "min-h-screen bg-gray-100" ]
            (viewNavbar props :: viewHeaderRow props :: props.body)
        ]
    }


viewHeaderRow : { props | title : String } -> Html msg
viewHeaderRow props =
    header [ Attr.class "bg-white shadow" ]
        [ div [ Attr.class "max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8" ]
            [ h2 [ Attr.class "font-semibold text-xl text-gray-800 leading-tight" ]
                [ text props.title ]
            ]
        ]


viewNavbar : { props | url : Url, auth : Auth, model : Model, toMsg : Msg -> msg } -> Html msg
viewNavbar props =
    let
        (Model model) =
            props.model
    in
    Html.map props.toMsg <|
        nav [ Attr.class "bg-white border-b border-gray-100" ]
            [ div [ Attr.class "max-w-7xl mx-auto px-4 sm:px-6 lg:px-8" ]
                [ div [ Attr.class "flex justify-between h-16" ]
                    [ div [ Attr.class "flex" ]
                        [ div [ Attr.class "shrink-0 flex items-center" ]
                            [ a [ Attr.href "/dashboard" ]
                                [ Components.Icon.laravelBlack
                                ]
                            ]
                        , div [ Attr.class "hidden space-x-8 sm:-my-px sm:ms-10 sm:flex" ]
                            [ a
                                [ Attr.class "inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium leading-5 text-gray-900 transition duration-150 ease-in-out"
                                , if props.url.path == "/dashboard" then
                                    Attr.class "border-indigo-400 focus:outline-none focus:border-indigo-700"

                                  else
                                    Attr.class "border-transparent hover:text-gray-700 hover:border-gray-300 focus:outline-none focus:text-gray-700 focus:border-gray-300"
                                , Attr.href "/dashboard"
                                ]
                                [ text "Dashboard" ]
                            ]
                        ]
                    , div [ Attr.class "hidden sm:flex sm:items-center sm:ms-6" ]
                        [ div [ Attr.class "ms-3 relative" ]
                            [ div [ Attr.class "relative" ]
                                [ div []
                                    [ span [ Attr.class "inline-flex rounded-md" ]
                                        [ button
                                            [ Attr.type_ "button"
                                            , Attr.class "inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md text-gray-500 bg-white hover:text-gray-700 focus:outline-none transition ease-in-out duration-150"
                                            , Html.Events.onClick ToggledUserDropdown
                                            ]
                                            [ text props.auth.user.name
                                            , Components.Icon.chevronDown
                                            ]
                                        ]
                                    ]
                                , div
                                    [ Attr.class "fixed inset-0 z-40"
                                    , if model.isDropdownOpen then
                                        Attr.classList []

                                      else
                                        Attr.style "display" "none"
                                    , Html.Events.onClick ClosedUserDropdown
                                    ]
                                    []
                                , div
                                    [ Attr.class "absolute z-50 mt-2 rounded-md shadow-lg w-48 ltr:origin-top-right rtl:origin-top-left end-0"
                                    , if model.isDropdownOpen then
                                        Attr.classList []

                                      else
                                        Attr.style "display" "none"
                                    ]
                                    [ div [ Attr.class "rounded-md ring-1 ring-black ring-opacity-5 py-1 bg-white" ]
                                        [ a
                                            [ Attr.class "block w-full px-4 py-2 text-start text-sm leading-5 text-gray-700 hover:bg-gray-100 focus:outline-none focus:bg-gray-100 transition duration-150 ease-in-out"
                                            , Attr.href "/profile"
                                            ]
                                            [ text "Profile" ]
                                        , button
                                            [ Attr.class "block w-full px-4 py-2 text-start text-sm leading-5 text-gray-700 hover:bg-gray-100 focus:outline-none focus:bg-gray-100 transition duration-150 ease-in-out"
                                            , Html.Events.onClick ClickedLogout
                                            ]
                                            [ text "Log Out" ]
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    , div [ Attr.class "-me-2 flex items-center sm:hidden" ]
                        [ button
                            [ Attr.type_ "button"
                            , Attr.class "inline-flex items-center justify-center p-2 rounded-md text-gray-400 hover:text-gray-500 hover:bg-gray-100 focus:outline-none focus:bg-gray-100 focus:text-gray-500 transition duration-150 ease-in-out"
                            , Html.Events.onClick ToggledUserDropdown
                            ]
                            [ if model.isDropdownOpen then
                                Components.Icon.close

                              else
                                Components.Icon.hamburgerMenu
                            ]
                        ]
                    ]
                ]
            , div
                [ Attr.class "sm:hidden"
                , Attr.classList
                    [ ( "block", model.isDropdownOpen )
                    , ( "hidden", not model.isDropdownOpen )
                    ]
                ]
                [ div [ Attr.class "pt-2 pb-3 space-y-1" ]
                    [ a
                        [ Attr.class "block w-full ps-3 pe-4 py-2 border-l-4 border-indigo-400 text-start text-base font-medium text-indigo-700 bg-indigo-50 focus:outline-none focus:text-indigo-800 focus:bg-indigo-100 focus:border-indigo-700 transition duration-150 ease-in-out"
                        , Attr.href "/dashboard"
                        ]
                        [ text "Dashboard" ]
                    ]
                , div [ Attr.class "pt-4 pb-1 border-t border-gray-200" ]
                    [ div [ Attr.class "px-4" ]
                        [ div [ Attr.class "font-medium text-base text-gray-800" ]
                            [ text props.auth.user.name ]
                        , div [ Attr.class "font-medium text-sm text-gray-500" ]
                            [ text props.auth.user.email ]
                        ]
                    , div [ Attr.class "mt-3 space-y-1" ]
                        [ a
                            [ Attr.class "block w-full ps-3 pe-4 py-2 border-l-4 border-transparent text-start text-base font-medium text-gray-600 hover:text-gray-800 hover:bg-gray-50 hover:border-gray-300 focus:outline-none focus:text-gray-800 focus:bg-gray-50 focus:border-gray-300 transition duration-150 ease-in-out"
                            , Attr.href "/profile"
                            ]
                            [ text "Profile" ]
                        , button [ Attr.class "block w-full ps-3 pe-4 py-2 border-l-4 border-transparent text-start text-base font-medium text-gray-600 hover:text-gray-800 hover:bg-gray-50 hover:border-gray-300 focus:outline-none focus:text-gray-800 focus:bg-gray-50 focus:border-gray-300 transition duration-150 ease-in-out" ]
                            [ text "Log Out" ]
                        ]
                    ]
                ]
            ]
