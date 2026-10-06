pragma Singleton
import QtQuick
import Quickshell

QtObject {
    // ─────────────────────────────────────────────
    // BACKGROUNDS
    // ─────────────────────────────────────────────

    // Main desktop / deepest background
    readonly property color bg0: "#0D0D0F"

    // Main UI background
    readonly property color bg1: "#151517"

    // Raised surfaces / bars
    readonly property color bg2: "#1C1C1E"

    // Cards / widgets / hover surfaces
    readonly property color bg3: "#242426"

    // Highest raised surface / selected elements
    readonly property color bg4: "#2C2C2E"

    readonly property color bg5: "#343436"

    // ─────────────────────────────────────────────
    // FOREGROUND
    // ─────────────────────────────────────────────

    // Primary text
    readonly property color fg: "#F5F5F7"

    // Secondary text
    readonly property color fg1: "#D1D1D6"

    // Tertiary text
    readonly property color fg2: "#AEAEB2"

    // Muted / disabled text
    readonly property color fg3: "#8E8E93"

    // Very subtle text
    readonly property color fg4: "#636366"

    // ─────────────────────────────────────────────
    // GREYS
    // ─────────────────────────────────────────────

    readonly property color gray: "#8E8E93"
    readonly property color gray1: "#AEAEB2"
    readonly property color gray2: "#C7C7CC"
    readonly property color gray3: "#D1D1D6"
    readonly property color gray4: "#E5E5EA"

    // ─────────────────────────────────────────────
    // APPLE-STYLE SYSTEM COLORS
    // ─────────────────────────────────────────────

    readonly property color red: "#FF453A"
    readonly property color orange: "#FF9F0A"
    readonly property color yellow: "#FFD60A"
    readonly property color green: "#30D158"
    readonly property color mint: "#63E6E2"
    readonly property color teal: "#40CBE0"
    readonly property color cyan: "#64D2FF"
    readonly property color blue: "#0A84FF"
    readonly property color indigo: "#5E5CE6"
    readonly property color purple: "#BF5AF2"
    readonly property color pink: "#FF375F"

    // ─────────────────────────────────────────────
    // SOFTER ACCENT VERSIONS
    // ─────────────────────────────────────────────

    readonly property color redSoft: "#FF6961"
    readonly property color orangeSoft: "#FFB340"
    readonly property color yellowSoft: "#FFE14A"
    readonly property color greenSoft: "#63E681"
    readonly property color mintSoft: "#8CE9E5"
    readonly property color cyanSoft: "#8EDCFF"
    readonly property color blueSoft: "#64A9FF"
    readonly property color indigoSoft: "#8180EE"
    readonly property color purpleSoft: "#D18BFF"
    readonly property color pinkSoft: "#FF6B8A"

    // ─────────────────────────────────────────────
    // DARKER ACCENT VERSIONS
    // ─────────────────────────────────────────────

    readonly property color redDark: "#8E1F1A"
    readonly property color orangeDark: "#995C00"
    readonly property color yellowDark: "#806B00"
    readonly property color greenDark: "#176B2C"
    readonly property color cyanDark: "#176A82"
    readonly property color blueDark: "#064F99"
    readonly property color purpleDark: "#71358F"
    readonly property color pinkDark: "#8F1F3A"

    // ─────────────────────────────────────────────
    // SPECIAL UI COLORS
    // ─────────────────────────────────────────────

    // Borders / separators
    readonly property color border: "#868686"
    readonly property color borderLight: "#999999"
    readonly property color borderSubtle: "#595959"

    // Selection
    readonly property color selection: "#0A84FF"
    readonly property color selectionBg: "#0A84FF33"

    // Hover
    readonly property color hover: "#FFFFFF0D"
    readonly property color hoverStrong: "#FFFFFF16"

    // Pressed
    readonly property color pressed: "#FFFFFF1F"

    // Overlay
    readonly property color overlay: "#00000066"
}
