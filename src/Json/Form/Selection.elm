module Json.Form.Selection exposing (checkbox, switch)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onBlur, onCheck, onFocus, onInput)
import Json.Form.Definitions exposing (..)
import Json.Form.Helper as Helper
import Json.Form.UiSpec exposing (applyRule)
import Json.Schema.Definitions exposing (Schema, getCustomKeywordValue)
import Json.Value as JsonValue exposing (JsonValue(..))
import JsonFormUtil as Util exposing (getTitle, getUiSpec, jsonValueToString)


switch : Model -> Schema -> Bool -> Bool -> Path -> Html Msg
switch model schema isRequired isDisabled path =
    let
        id =
            model.config.name ++ "_" ++ (path |> String.join "_")

        isChecked =
            case model.value |> Maybe.andThen (JsonValue.getIn path >> Result.toMaybe) of
                Just (BoolValue x) ->
                    x

                _ ->
                    False

        ( hasError, helperText ) =
            Helper.view model schema path

        ( disabled, hidden ) =
            schema
                |> getUiSpec
                |> .rule
                |> applyRule model.value path

        actuallyDisabled =
            isDisabled || disabled
    in
    div
        [ classList
            [ ( "jf-element", True )
            , ( "jf-element--hidden", hidden )
            , ( "jf-element--invalid", hasError )
            ]
        ]
        [ label
            [ classList
                [ ( "jf-switch", True )
                , ( "jf-switch--on", isChecked )
                , ( "jf-switch--focused", model.focused |> Maybe.map ((==) path) |> Maybe.withDefault False )
                , ( "jf-switch--invalid", hasError )
                , ( "jf-switch--disabled", actuallyDisabled )
                , ( "jf-switch--hidden", hidden )
                ]
            ]
            [ input
                [ type_ "checkbox"
                , class "jf-switch__input"
                , checked isChecked
                , onFocus <| FocusInput (Just path)
                , onBlur <| FocusInput Nothing
                , onCheck <| (JsonValue.BoolValue >> EditValue path)
                , Html.Attributes.id id
                , Html.Attributes.name id
                , Html.Attributes.disabled actuallyDisabled
                ]
                []
            , span [ class "jf-switch__label" ] [ schema |> getTitle isRequired |> text ]
            , div [ class "jf-switch__track" ] []
            , div [ class "jf-switch__thumb" ] []
            , div [ class "jf-switch__helper-text" ] [ helperText ]
            ]
        ]


checkbox : Model -> Schema -> Bool -> Bool -> Path -> Html Msg
checkbox model schema isRequired isDisabled path =
    let
        id =
            model.config.name ++ "_" ++ (path |> String.join "_")

        isChecked =
            case model.value |> Maybe.andThen (JsonValue.getIn path >> Result.toMaybe) of
                Just (BoolValue x) ->
                    x

                _ ->
                    False

        ( hasError, helperText ) =
            Helper.view model schema path

        ( disabled, hidden ) =
            schema
                |> getUiSpec
                |> .rule
                |> applyRule model.value path

        actuallyDisabled =
            isDisabled || disabled
    in
    div
        [ classList
            [ ( "jf-element", True )
            , ( "jf-element--hidden", hidden )
            , ( "jf-element--invalid", hasError )
            ]
        ]
        [ label
            [ classList
                [ ( "jf-checkbox", True )
                , ( "jf-checkbox--on", isChecked )
                , ( "jf-checkbox--focused", model.focused |> Maybe.map ((==) path) |> Maybe.withDefault False )
                , ( "jf-checkbox--invalid", hasError )
                , ( "jf-checkbox--disabled", actuallyDisabled )
                , ( "jf-checkbox--hidden", hidden )
                ]
            ]
            [ input
                [ type_ "checkbox"
                , class "jf-checkbox__input"
                , checked isChecked
                , Html.Attributes.id id
                , Html.Attributes.name id
                , Html.Attributes.disabled actuallyDisabled
                , onFocus <| FocusInput (Just path)
                , onBlur <| FocusInput Nothing
                , onCheck <| (JsonValue.BoolValue >> EditValue path)
                ]
                []
            , span [ class "jf-checkbox__label" ] [ schema |> getTitle isRequired |> text ]
            , div [ class "jf-checkbox__box-outline" ]
                [ div [ class "jf-checkbox__tick-outline" ] []
                ]
            , div [ class "jf-checkbox__helper-text" ] [ helperText ]
            ]
        ]
