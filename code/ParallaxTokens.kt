// Design tokens for Parallax. Values are taken from the approved HTML mockups.
// TV: the mockup stage is 1280x720 CSS px; 1 "cqw" = 12.8 stage px. On Android TV 1080p (tvdpi) that is ~1280x720 dp,
// so tv dp = cqw * 12.8. VERIFY on the real device and adjust ONE constant (TV_DP_PER_CQW) if needed.
// Phone values are dp/sp at a 390x844 frame.
package com.parallax.design

import androidx.compose.animation.core.CubicBezierEasing
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

object Motion {
    /** Horizontal moves (left/right): springy. */
    val Spring = CubicBezierEasing(0.34f, 1.56f, 0.64f, 1.0f)
    /** Vertical moves (up/down) and page changes: smooth ease-out. NEVER overshoot. */
    val Smooth = CubicBezierEasing(0.25f, 0.8f, 0.25f, 1.0f)
    const val CardMoveMs = 450
    const val SectionMorphMs = 550
    const val FocusLiftMs = 450
    const val HueCrossfadeMs = 1300
    const val BootTvMs = 3500
    const val BootPhoneMs = 2500
    const val AmbientIdleTvMs = 12_000
    const val AmbientIdlePhoneMs = 9_000
}

object Colors {
    val Black = Color(0xFF000000)            // Parallax screens
    val Page = Color(0xFF07080E)             // UI chrome / pages
    val Text = Color(0xFFF6F7FC)
    val TextMuted = Color.White.copy(alpha = 0.62f)
    val Hairline = Color.White.copy(alpha = 0.15f)
    val FocusRing = Color.White.copy(alpha = 0.88f)
    // Logo panes: the ONLY coloured glass in the UI.
    val PaneViolet = Color(0xFF9687C8).copy(alpha = 0.30f)
    val PaneTeal = Color(0xFF6EAAA0).copy(alpha = 0.28f)
    val PaneAmber = Color(0xFFD2AA82).copy(alpha = 0.30f)
}

object Type {
    // Three sizes per screen. TV in sp = dp assuming 1:1 on the 1280x720dp stage.
    object Tv { val title = 33.sp; val hero = 46.sp; val body = 14.7.sp; val small = 11.5.sp }
    object Phone { val title = 24.sp; val body = 13.5.sp; val small = 11.5.sp }
    const val TitleWeight = 700
    const val WordmarkWeight = 400
    const val WordmarkTracking = 0.02f // em
}

object Radii {
    const val TV_DP_PER_CQW = 12.8f
    val TvCard = (1.2f * TV_DP_PER_CQW).dp        // ~15dp
    val TvBigCard = (1.4f * TV_DP_PER_CQW).dp     // ~18dp
    val TvButton = (1.1f * TV_DP_PER_CQW).dp
    val TvChip = (0.6f * TV_DP_PER_CQW).dp
    val PhoneCard = 18.dp
    val PhoneButton = 13.dp
    val PhoneChip = 10.dp
    val PhoneBarBottom = 22.dp                    // curved bottom corners on glass bars
}

/** Glass recipes. alpha pairs are (top-left, bottom-right) of a 160deg gradient. */
data class GlassSpec(
    val fromAlpha: Float, val midAlpha: Float, val toAlpha: Float,
    val borderAlpha: Float, val topHighlightAlpha: Float,
    val blurTvDp: Float, val blurPhoneDp: Float, val saturation: Float,
)
object Glass {
    val Clear  = GlassSpec(0.12f, 0.02f, 0.05f, 0.18f, 0.22f, 46f, 30f, 1.9f)
    val Bright = GlassSpec(0.24f, 0.10f, 0.10f, 0.30f, 0.40f, 46f, 30f, 1.9f)
    // Dark: tinted dark, not white. from rgba(30,32,44,.32) to rgba(8,9,14,.18), border .12
    val DarkFrom = Color(0xFF1E202C).copy(alpha = 0.32f)
    val DarkTo = Color(0xFF08090E).copy(alpha = 0.18f)
    // Bars that content scrolls behind (phone header, mini player, floating chips): black tint + blur 26dp + saturate 1.7
    val BarTint = Color(0xFF06070B).copy(alpha = 0.45f)
    const val BarBlurPhoneDp = 26f
    const val BarBlurTvDp = 38f
}

object Glow {
    // Card-shaped glow: blurred copy of the card's own dominant colour, extends ~1.1-1.5cqw beyond the card, fades to nothing.
    const val ExtendCqw = 1.5f
    const val BlurCqw = 2.4f
    const val Opacity = 0.75f
}
object AmbientHue {
    // Focused card's top/middle/bottom dominant colours, heavily blurred, masked to fade out at top and bottom.
    const val BlurTvCqw = 6f
    const val BlurPhoneDp = 60f
    const val Brightness = 0.5f
    // vertical mask stops (0 transparent .. 1 opaque): 0->0, .2->.55, .42->1, .62->1, .82->.5, 1->0
}
