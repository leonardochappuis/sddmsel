//
// This file is part of SDDM Sugar Candy.
// A theme for the Simple Display Desktop Manager.
//
// Copyright (C) 2018–2020 Marian Arlt
//
// SDDM Sugar Candy is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the
// Free Software Foundation, either version 3 of the License, or any later version.
//
// You are required to preserve this and any additional legal notices, either
// contained in this file or in other files that you received along with
// SDDM Sugar Candy that refer to the author(s) in accordance with
// sections §4, §5 and specifically §7b of the GNU General Public License.
//
// SDDM Sugar Candy is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with SDDM Sugar Candy. If not, see <https://www.gnu.org/licenses/>
//

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtMultimedia

import "Components"

Pane {
    id: root

    height: config.ScreenHeight || Screen.height
    width: config.ScreenWidth || Screen.width

    LayoutMirroring.enabled: config.ForceRightToLeft == "true" ? true : Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    padding: config.ScreenPadding
    palette.button: "transparent"
    palette.highlight: config.AccentColor
    palette.text: "#FFFFFF"
    palette.buttonText: config.MainColor
    palette.window: config.BackgroundColor

    font.family: config.Font
    font.pointSize: config.FontSize !== "" ? config.FontSize : parseInt(height / 80)
    focus: true

    property bool leftleft: config.HaveFormBackground == "true" &&
                            config.PartialBlur == "false" &&
                            config.FormPosition == "left" &&
                            config.BackgroundImageHAlignment == "left"

    property bool leftcenter: config.HaveFormBackground == "true" &&
                              config.PartialBlur == "false" &&
                              config.FormPosition == "left" &&
                              config.BackgroundImageHAlignment == "center"

    property bool rightright: config.HaveFormBackground == "true" &&
                              config.PartialBlur == "false" &&
                              config.FormPosition == "right" &&
                              config.BackgroundImageHAlignment == "right"

    property bool rightcenter: config.HaveFormBackground == "true" &&
                               config.PartialBlur == "false" &&
                               config.FormPosition == "right" &&
                               config.BackgroundImageHAlignment == "center"

    Item {
        id: sizeHelper

        anchors.fill: parent
        height: parent.height
        width: parent.width

        Rectangle {
            id: tintLayer
            anchors.fill: parent
            width: parent.width
            height: parent.height
            color: "transparent"
            opacity: config.DimBackgroundImage
            z: 1
        }

        Rectangle {
            id: formBackground
            anchors.fill: form
            anchors.centerIn: form
            color: "transparent"
            visible: config.HaveFormBackground == "true" ? true : false
            opacity: config.PartialBlur == "true" ? 0.3 : 1
            z: 1
        }

        LoginForm {
            id: form

            height: virtualKeyboard.state == "visible" ? parent.height - virtualKeyboard.implicitHeight : parent.height
            width: parent.width / 2.5
            anchors.horizontalCenter: config.FormPosition == "center" ? parent.horizontalCenter : undefined
            anchors.left: config.FormPosition == "left" ? parent.left : undefined
            anchors.right: config.FormPosition == "right" ? parent.right : undefined
            virtualKeyboardActive: virtualKeyboard.state == "visible" ? true : false
            z: 1
        }

        Button {
            id: vkb
            onClicked: virtualKeyboard.switchState()
            visible: virtualKeyboard.status == Loader.Ready && config.ForceHideVirtualKeyboardButton == "false"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: implicitHeight
            anchors.horizontalCenter: form.horizontalCenter
            z: 1
            contentItem: Text {
                text: config.TranslateVirtualKeyboardButton || "Virtual Keyboard"
                color: parent.visualFocus ? palette.highlight : palette.text
                font.pointSize: root.font.pointSize * 0.8
            }
            background: Rectangle {
                id: vkbbg
                color: "transparent"
            }
        }

        Loader {
            id: virtualKeyboard
            source: "Components/VirtualKeyboard.qml"
            state: "hidden"
            property bool keyboardActive: item ? item.active : false
            onKeyboardActiveChanged: keyboardActive ? state = "visible" : state = "hidden"
            width: parent.width
            z: 1
            function switchState() { state = state == "hidden" ? "visible" : "hidden" }
            states: [
                State {
                    name: "visible"
                    PropertyChanges {
                        target: form
                        systemButtonVisibility: false
                        clockVisibility: false
                    }
                    PropertyChanges {
                        target: virtualKeyboard
                        y: root.height - virtualKeyboard.height
                        opacity: 1
                    }
                },
                State {
                    name: "hidden"
                    PropertyChanges {
                        target: virtualKeyboard
                        y: root.height - root.height/4
                        opacity: 0
                    }
                }
            ]
            transitions: [
                Transition {
                    from: "hidden"
                    to: "visible"
                    SequentialAnimation {
                        ScriptAction {
                            script: {
                                virtualKeyboard.item.activated = true;
                                Qt.inputMethod.show();
                            }
                        }
                        ParallelAnimation {
                            NumberAnimation {
                                target: virtualKeyboard
                                property: "y"
                                duration: 100
                                easing.type: Easing.OutQuad
                            }
                            OpacityAnimator {
                                target: virtualKeyboard
                                duration: 100
                                easing.type: Easing.OutQuad
                            }
                        }
                    }
                },
                Transition {
                    from: "visible"
                    to: "hidden"
                    SequentialAnimation {
                        ParallelAnimation {
                            NumberAnimation {
                                target: virtualKeyboard
                                property: "y"
                                duration: 100
                                easing.type: Easing.InQuad
                            }
                            OpacityAnimator {
                                target: virtualKeyboard
                                duration: 100
                                easing.type: Easing.InQuad
                            }
                        }
                        ScriptAction {
                            script: {
                                Qt.inputMethod.hide();
                            }
                        }
                    }
                }
            ]
        }

        MediaPlayer {
            id: videoPlayer
            source: Qt.resolvedUrl("Assets/Copland_OS.mp4")
            videoOutput: video
            // No audioOutput on purpose: the clip's own (quiet) audio track
            // stays muted so the louder bootSound below is the only audio.
            onPositionChanged: {
                // Freeze on the last frame instead of looping or flashing black.
                if (duration > 0 && position >= duration - 150)
                    pause()
            }
            onMediaStatusChanged: {
                if (mediaStatus == MediaPlayer.LoadedMedia)
                    play()
            }
        }

        VideoOutput {
            id: video
            anchors.fill: parent
            // "Contain" the clip by default so the whole frame is visible on
            // any resolution. Set ScaleImageCropped="true" to crop-to-fill.
            fillMode: config.ScaleImageCropped == "true" ? VideoOutput.PreserveAspectCrop : VideoOutput.PreserveAspectFit
        }

        MediaPlayer {
            id: bootSound
            source: Qt.resolvedUrl("Assets/Copland_OS.mp3")
            audioOutput: AudioOutput { id: bootAudio }
            onMediaStatusChanged: {
                if (mediaStatus == MediaPlayer.LoadedMedia)
                    play()
            }
        }

        ShaderEffect {
            id: crtEffect
            anchors.fill: parent
            property var source: ShaderEffectSource { sourceItem: video; hideSource: true }

            property real iTime: 0.0
            property real iHeight: root.height

            NumberAnimation on iTime {
                from: 0.0; to: 60.0; loops: Animation.Infinite; duration: 60000
            }

            // Qt 6 RHI shader, baked from shaders/crt.frag with the qsb tool.
            fragmentShader: Qt.resolvedUrl("shaders/crt.frag.qsb")
        }

        MouseArea {
            anchors.fill: video
            onClicked: parent.forceActiveFocus()
        }

    }
}
