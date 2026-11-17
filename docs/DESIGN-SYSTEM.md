# Design system

Values come from the HTML mockups. The TV stage is 1280x720 CSS px and `cqw` = 1% of the stage width, so 1cqw = 12.8 units on TV. On an Android TV at 1080p with tvdpi density the stage maps to roughly 1280x720 dp, so **1cqw is about 12.8dp** (verify on the real device). The phone frame is about 390x844.

## Colour

| Role | Value |
|---|---|
| Background (Parallax) | `#000000` |
| Background (UI chrome / pages) | `#07080e` |
| Text | `#f6f7fc` (TV), `#f4f5fb` (phone) |
| Muted text | `rgba(255,255,255,.62)` |
| Hairline borders | `rgba(255,255,255,.12 to .18)` |
| Focus ring | `rgba(255,255,255,.85 to .9)`, about 2dp |

**Logo pane tints** (the only coloured glass in the UI): violet `rgba(150,135,200,.28 to .4)`, teal `rgba(110,170,160,.26 to .38)`, amber `rgba(210,170,130,.28 to .4)`.

Colour comes from artwork. Never tint UI elements with brand colours. The one exception is the music player, where the play button, active toggles and progress fill take a tint extracted from the current song's art.

## Typography

Font **Heros** (TeX Gyre Heros, a Helvetica-style sans, GUST licence; embedded as WOFF in the mockups, so extract or fetch it). Fall back to Helvetica Neue, then Arial.

Exactly **three sizes per screen**:

| Token | TV | Phone |
|---|---|---|
| Title `T` | 2.6cqw (33dp), bold 700, line-height 1.05, letter-spacing -.01em. Hero titles 3.6cqw (46dp) | 24sp bold, line-height 1.1 (hero 30 to 34) |
| Body `B` | 1.15cqw (14.7dp), line-height 1.5 | 13.5sp, line-height 1.5 |
| Small `S` | .9cqw (11.5dp), line-height 1.4 | 11.5sp, line-height 1.4 |

The **wordmark** "parallax" is lowercase Heros regular (weight 400), letter-spacing .02em. Title logos from fanart.tv replace text titles on movie and show pages.

## Glass

Three strengths. The default is the "rich" recipe (an in-mockup toggle compares it with a subtler one).

- **Clear `gl`**: gradient 160deg from `rgba(255,255,255,.12)` through `.02` at 60% to `.05`; 1dp border `rgba(255,255,255,.18)`; backdrop blur about 3.6cqw (46dp TV, 30px phone), saturate 1.9, brightness 1.05; inner top highlight `rgba(255,255,255,.22)`; soft drop shadow `0 .8cqw 2.4cqw rgba(0,0,0,.28)`.
- **Bright `glb`** (main action such as Play or Resume): gradient `.24` to `.10`, border `.30`, top highlight `.40`.
- **Dark `gld`** (badges, secondary and sound buttons): gradient `rgba(30,32,44,.32)` to `rgba(8,9,14,.18)`, border `.12`.

Rules: understated, minimal reflection, **no light-sweep animation**. On small elements that move (badges on cards) skip backdrop blur and use a flat `rgba(0,0,0,.55)` for performance.

**Glass bars that content scrolls behind** (phone header, collapsed mini player, floating filter chips and season tabs, TV collapsed section bars, A to Z strip) are dark frosted glass: black tint `rgba(6,7,11,.38 to .55)`, strong blur (26px phone, 3cqw TV), saturate 1.7, **curved bottom corners (about 22px phone)**, a 1px bottom rim `rgba(255,255,255,.13)` with a brighter centred highlight fading to the sides, a faint inner bottom glow, and a soft shadow beneath. Headers that sit on artwork (movie page, mood page, Private) start clear and turn frosted only after scrolling.

## Shapes

Rounded rectangles only. TV radii: cards 1.2 to 1.6cqw (15 to 20dp), big launcher and library cards 1.4cqw, buttons about 1.1cqw, small chips .6cqw. Phone radii: cards 16 to 22px, buttons 12 to 14px, chips 10px. **No pill shapes.** Only the play button (circle) and avatars are round.

## Motion

```
spring (horizontal):           cubic-bezier(.34, 1.56, .64, 1)
smooth (vertical, ease-out):   cubic-bezier(.25, .8, .25, 1)
```
- **Left/right = spring. Up/down = smooth.** Movie-page card expansion, and anything that is "a page changing", is smooth only.
- Durations: card and section moves .45 to .55s; focus lift .45s; colour and hue crossfades 1.2 to 1.4s; boot about 3.5s on TV and about 2.5s on phone.
- **Focus (SUPERSEDED by docs/ADDENDUM-2026-11-16.md; TV uses a glass slab, phone has no focus):**  lift up about .5 to .7cqw, a 2dp white ring, and a card-shaped glow. In grids the lifted card grows from its **left edge**, so left edges stay aligned.
- **Section morph**: every section has an "openness" value from 0 (bar) to 1 (open row). Bar content fades out and grows toward the row while row content fades in from about .9 scale, starting at the bar's thumbnail position. On phone the value is driven by the finger while dragging; on TV it animates on every up/down move. Reverse is symmetric.
- Phone scrolling and card swiping **follow the finger** (drag progress mapped 1:1, then settle with the release velocity). No preset jumps.
- Avoid jitter: animate transform and opacity only, keep moving layers composited, no backdrop blur on small moving badges.

## Glow and ambient hue

- **Card glow**: a blurred copy of the card's own dominant colour, in the same rounded-rect shape, extending about 1.1 to 1.5cqw beyond the card, opacity about .55 to .75, blur about 2.2 to 2.4cqw, **fading to nothing with no visible edge**. Never a big ellipse.
- **Ambient hue**: the focused card's colours (top, middle and bottom dominant colours) blurred hugely (6cqw on TV, 60px on phone), brightness about .4 to .6, masked to fade to transparent at the top and bottom. Used on TV home and music library, and phone Entertainment and Music. Crossfade slowly and keep it calm.
- **Dominant colours** are computed once per title at scan time (weighted by saturation and brightness) and stored.

## Layout rules

- One shared left edge per screen. Check it numerically: bars, labels, focused cards, info text.
- Home rows: the open card height fills the open section minus the bars. One bar is visible at the bottom (next row) and one at the top (previous section).
- Library grids: whole rows only (no half-visible rows); outer rows fade instead of clipping. 5 posters per row on TV. A to Z mode shows about 11 per row and 3 rows, with art and info hidden.
- Music tiles are **square** (album art), movie and show posters are 2:3, home-row cards are 16:9 landscape.
- Library and show page: the landscape art fills the **right half** at true 16:9 (no cropping), fading to black toward the left and bottom. Info sits over the left; posters start about 40% down.

## Components (see the mockups)

Pane loader (three offset glass panes drifting in and out of alignment, replaces every spinner); collection stack (front poster top-right, two receding panes down-left, spreading sideways when focused); album-art stack (current song in front, next two stepped back, like the logo); morphing play/pause button with a progress ring; section bar with a thumbnail peek; frosted title band on big cards; fast-scroll handle with a letter bubble; A to Z bar; phone dock (bottom-left, Entertainment and Music icons with a springing highlight, beside the mini player).
