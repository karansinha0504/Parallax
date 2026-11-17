# How to see and verify the design (READ THIS BEFORE BUILDING ANY SCREEN)

> **Updated 16 Nov 2026.** The screenshots in `reference/screenshots-tv/` and `reference/screenshots-phone/` were all re-taken from the v7 mockups (glass-slab focus on TV, no focus system on phone, glass hierarchy). Their numbering is not the same as the older lists below; go by the file names, which say the screen and state. Screens not re-shot (launcher YouTube/offline/quick settings, search results, QR pairing, lock/PIN details, lyrics, queue, ambient player, Recents older cards) are unchanged apart from focus and glass; open `mockups/parallax-tv-v7.html` or `-phone-v7.html` to see them. `reference/layout/measurements.json` is still right for resting layout (the focused TV card additionally magnifies about 1.06 from its left edge). Where the notes below describe a white focus ring or a bouncy horizontal focus move, `docs/ADDENDUM-2026-11-16.md` overrides them. `reference/motion/tv-04-slab-glides-no-overshoot.jpg` replaces the old springy card-focus strip.

Text cannot carry how this app looks. Use these, in this order, for every screen:

1. **`reference/screenshots-tv/` and `reference/screenshots-phone/`** are pictures of every screen and state (TV at 1280x720, phone at 390x844 shown at 2x). **Open the matching image before writing UI code** (you can view image files). The file name says what state it is.
2. **`reference/motion/`** are frame-by-frame strips of the key animations (time in ms under each frame). Use them for timing, overshoot and layering. Notes below say what to look for.
3. **`reference/layout/measurements.json`** has the measured position (x, y, w, h), corner radius, font size and opacity of the key elements on the main screens, in stage px (TV 1280x720, phone 390x844). Match these within about 2dp. Use it to settle "how big", "how far from the edge".
4. **`code/ParallaxTokens.kt`** has the colours, type, radii, glass, glow, hue and motion curves as Kotlin. Use it; do not invent values.
5. **`mockups/*.html`**, the live prototypes, only if you can open a browser. Not required.

## Mandatory loop for every screen
1. Open the reference screenshot and the layout entry. Describe back, in a few lines, what you see (layout, spacing, glass, colour, motion).
2. Build it with the tokens.
3. Run it (emulator or device) and **take a screenshot**. Put it side by side with the reference. List every visible difference (positions, sizes, blur, colours, alignment, text sizes).
4. Fix, repeat until the differences are only content (real posters instead of placeholders).
5. Run the checks: **left edges aligned**, **nothing clipped in any focus state**, **vertical moves smooth / horizontal moves spring**, **same focus lift on every row**.
6. Do not call a screen done without steps 3 to 5. If you cannot screenshot, say so and ask Karan to check the screen against the reference.

If a detail is not covered by these files, do not invent it. Ask Karan, or pick the most restrained option (pure black, subtle glass, no extra effects).

## What to notice in the references
- **Home rows (`10`-`17`)**: one section open filling the screen height; ONE bar visible below (next row) and one above (previous). The info pane (title, details) sits on a soft glass pane under the open card, left-aligned with the card. The whole screen carries a faint colour wash from the focused card, fading to black at top and bottom.
- **Collections (`13`)**: each collection is a stack: front poster top-right of its slot, two darker, smaller panes stepping down-left behind. Focused stack spreads sideways. The focus ring is on the front poster only.
- **Library (`20`-`23`)**: landscape art in the right half fading to black toward the left and bottom. Info top-left. Posters begin about 40% down, **whole rows only**. In A to Z mode (`22`) art and info disappear and the screen fills with small posters; the letter badge is top-right.
- **Movie page (`28`)**: Details row is open at the bottom, the title logo top-left, art right.
- **Player (`31`)**: amber circle in the middle bottom with skip-10 buttons either side, seek bar above, subtitle/audio/more bottom-right.
- **Music (`70`-`73`)**: stacked art on the left (current song front, next two behind), whole screen tinted by the art; ambient mode centres the art and hides controls.
- **Phone (`01`-`07`)**: header glass is curved at the bottom; the Entertainment/Music dock sits bottom-left beside the mini player; section cards fill the screen.
- **`08`-`10` (phone)** are frozen mid-drag frames. The overlap of two sections is intended (cross-fade as the bar becomes the row).

## Motion strips: what to look for
- `tv-02` / `tv-03` section morph: smooth ease-out, **no overshoot or bounce**; the old row's contents shrink toward the bar while the next row grows out of its bar.
- `tv-04` slab glides to the next card: eight frames, 70 ms apart, smooth with no overshoot (replaces the old springy strip).
- `tv-05` collection stack: stack spreads, glow of the front poster's colour follows.
- `tv-06` / `phone-04`: current art slides away up-right and fades; the next art comes forward; the stack behind steps up. Background tint crossfades slowly.
- `tv-07` player controls: circle rises, triangle rotates to point right, seek bar extends from a point above the circle to both sides, then the buttons pop in.
- `tv-08` A to Z: art and info fade out as posters shrink.
- `phone-02`, `phone-03`: progress is the finger position; these are the states at 0 to 100% of a drag.
- `phone-05`: the triangle morphs into pause bars (not an icon swap).
- `tv-01` / `phone-01` boot: panes fly in from different depths and settle offset; the wordmark sharpens beneath (TV); fade to home.
