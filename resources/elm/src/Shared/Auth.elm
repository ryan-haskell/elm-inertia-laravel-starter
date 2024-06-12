module Shared.Auth exposing (Auth, decoder)

import Json.Decode


type alias Auth =
    { user : Maybe User
    }


decoder : Json.Decode.Decoder Auth
decoder =
    Json.Decode.map Auth
        (Json.Decode.field "user" (Json.Decode.maybe userDecoder))


type alias User =
    { id : Int
    , name : String
    , email : String
    }


userDecoder : Json.Decode.Decoder User
userDecoder =
    Json.Decode.map3 User
        (Json.Decode.field "id" Json.Decode.int)
        (Json.Decode.field "name" Json.Decode.string)
        (Json.Decode.field "email" Json.Decode.string)
