# THE UI TO BUILD IS FIXED (added 17 Nov 2026, Karan's instruction)

`mockups/parallax-tv-v7.html` and `mockups/parallax-phone-v7.html` are the exact UI Karan approved. **Build the real apps to match them one to one**: same screens, layout, sizes, glass, focus treatment (TV glass slab, no focus on phone), motion, timings and behaviour. They are not loose inspiration.

- Open them in a browser and compare your build against them side by side, screen by screen (the verification loop in `docs/REFERENCE-AND-VERIFICATION.md` still applies).
- Where a written doc disagrees with these two files, the files win. Note the difference and ask Karan only if it looks like a mistake in the file.
- The phone file here is newer than the one in the original handoff zip (replaced 17 Nov 2026). Use this one.
- An earlier attempt redrew a mockup from the docs instead of copying these files. It was wrong; do not use it as a reference.
- Titles, posters and text inside the mockups are placeholders. Real content comes from the library scan and metadata providers.

# STOP. Read this block before doing anything else.

**Karan will not type a long prompt. Whatever his first message is (even just "hi", "start" or "go"), treat it as: begin the Orientation below.** Do not write code, create a project, install anything, or touch the onn box until Orientation is finished and Karan has replied "go".

## Orientation (do this first, in order)
1. Read this whole file, then every file in `docs/` completely (start with `docs/ADDENDUM-2026-11-16.md`, which is newest and overrides older docs, then `REFERENCE-AND-VERIFICATION.md`, then the rest).
2. Look at the pictures: open every image in `reference/screenshots-tv/` and `reference/screenshots-phone/`, the strips in `reference/motion/`, skim `reference/layout/measurements.json`, and read `code/ParallaxTokens.kt`. Look at `mockups/README.md`. Look at `music-toolkit/` and read its files (he already cleans his music with beets).
3. Write `UNDERSTANDING.md` in this folder, in plain language Karan can read in two minutes: what Parallax is (TV app, phone app, launcher), the design rules in your own words (including the TV glass-slab focus, calm motion, glass hierarchy, no focus on phone), the artwork slots, the no-artwork video rules, the music sync and metadata plan, what is already decided and what is ruled out, the open questions and the risks, and your proposed first build step and order of work.
4. Ask Karan only the questions you truly cannot answer from the files (at most five, with a recommended answer for each). Examples: sample file paths for one film and one episode, the onn box's Android version (Settings, About), his home upload speed, confirmation of anything the docs mark as open.
5. Say that you are ready and **wait for "go"**. Then follow "Suggested first session at home" below. Never skip the verification loop in `docs/REFERENCE-AND-VERIFICATION.md`.

If any doc contradicts another, say so in `UNDERSTANDING.md` and ask; do not silently pick one.

---

# Parallax — project brief for Claude Code

Read this file first, then `docs/REFERENCE-AND-VERIFICATION.md`, then the rest of `docs/`. **`docs/ADDENDUM-2026-11-16.md` is the newest and overrides older docs** (focus and glass hierarchy, artwork sizes, no-artwork videos, music sync and metadata). The pictures in `reference/` and the tokens in `code/` are the visual source of truth; the HTML in `mockups/` is optional extra.

## What we are building

**Parallax**, a personal, serverless media player for Android TV, plus a companion Android phone app and a custom TV launcher. One owner (Karan), one library, no cloud server.

1. **Parallax for TV**: plays films, shows and music straight from a USB drive on an onn Android TV box. There is no server process. Metadata is cached offline.
2. **Parallax for phone**: companion app with two tabs, Entertainment and Music. It streams from the box over the local network, remote-controls it, downloads titles for offline use, and also manages music on the phone.
3. **Parallax launcher**: a custom Android TV home screen (YouTube, Parallax, Netflix, Prime Video, All apps) that reads the other apps' "Continue watching" rows.

Later there may be a smart-home desk display and other apps in the same design system. So build the design system as a **separate shared module** from day one.

## About the owner and the environment (important)

- Karan is a ship's officer. He is **offline or on very limited internet for weeks**. Everything must work offline once set up. Online lookups (metadata, lyrics, backups) are **queued and run opportunistically**.
- His rule: **no fiddling in the middle of the ocean.** One-time setup at home, then it just works. Failures wait quietly, never show error screens, never block playback.
- **The onn box must never receive a system update** (it was geo-locked after a US purchase and re-activated through a router VPN). Never suggest updating Android on it. It stays only on his own travel router.
- USB debugging stops the box recognising the USB drive. **Use wireless debugging** to install builds.
- Target devices: onn Android TV box (modest hardware; heavy blur must be tunable per screen), Pixel 7 Pro phone.
- Karan will test on real hardware at home. He is non-technical about code but has an excellent eye for design. He notices half-pixel misalignments and inconsistent animation. **Treat visual details as requirements.**

## Stack (agreed)

Kotlin, Jetpack Compose for TV and phone, Media3/ExoPlayer (with the FFmpeg extension for audio codecs). Metadata from TMDB, with title logos and landscape thumbs from fanart.tv, MusicBrainz and Discogs for music, AcoustID for audio fingerprints, LRCLIB for synced lyrics. Embedded Ktor or NanoHTTPD server inside the TV app for the phone companion. See `docs/ARCHITECTURE-AND-BUILD-PLAN.md`.

## Non-negotiable design rules

These are the soul of the app. Details are in `docs/DESIGN-SYSTEM.md`.

1. **Pure black background** on Parallax screens. The only colour is artwork, the ambient hue, and the tinted logo panes.
2. **Glass, not solid.** Three glass strengths (bright, dark, clear), deep blur, soft top-edge highlight. No pills; all buttons and sections are rounded-rectangle cards.
3. **Motion rule (older): horizontal moves spring, vertical moves smooth.** UPDATE: with the TV glass slab, nothing may overshoot or wobble; see the addendum. Focus changes use one consistent smooth lift everywhere, with no extra pop on some rows and not others.
4. **Three text sizes per screen** (title, body, small) in the Heros sans font.
5. **Sections morph continuously** between a collapsed bar and an open row as you move. They never switch abruptly.
6. **Everything aligns on one left edge.** Collapsed bars, row labels, focused cards and info text share the same left x. Check this numerically.
7. **Nothing may ever clip.** Rows outside a view fade out; the focused card (including its lift and glow) must always be fully visible.
8. **Glow is card-shaped** (a softened copy of the card's own colour, kept close), never a big ellipse, and fades to nothing with no visible edge.
9. **Ambient hue** (focused card's colours blurred across the screen, fading to black at top and bottom) is subtle, never distracting.
10. **Premium, "like a piece of art."** When in doubt, add depth (blur, translucency) and remove clutter.

## How to SEE the design (important)

Do not rely on the text docs alone. `reference/` contains screenshots of every screen and state, frame-by-frame strips of the key animations, and measured positions and sizes. `code/ParallaxTokens.kt` has the design values as Kotlin. **Read `docs/REFERENCE-AND-VERIFICATION.md` first.** It defines the mandatory loop: view the reference, build, screenshot your build, compare side by side, fix the differences, run the alignment and clipping checks, and only then call a screen done. Also read `docs/COMMON-MISTAKES.md`. Never invent visual details that are not in these files; ask Karan.

## How to use the mockups

`mockups/*.html` are self-contained browser prototypes, built iteratively with many layered CSS overrides. **Treat them as the visual and behavioural reference, not as code to port.** Where a mockup's CSS contradicts `docs/DESIGN-SYSTEM.md`, the doc wins, and if still unsure, ask Karan. Open them in a browser to see motion. Key files:

- `parallax-tv-v7.html`: the whole TV app (with the glass-slab focus; press G to compare with the old focus), including the launcher, library, show, movie, player, search, settings, Recents, Private, music player.
- `parallax-phone-v7.html`: the whole phone app (no focus system: scroll and tap).
- `parallax-launcher-v4.html`: the **locked** launcher layout. `parallax-launcher-v5.html` adds a switch comparing icon styles (undecided; default to original-colour icons on full tiles).
- `parallax-recents-v1.html`, `parallax-lyrics-seek-v1.html`, `parallax-touches-v2.html` (pane loader, fanning collections, glow), `parallax-wordmark-v3.html` (boot intro with the Heros wordmark).

All titles, posters and text in them are **placeholders**. The real app gets everything from the library scan and metadata providers.

## Suggested first session at home

1. Verify tools: Android Studio, a Compose TV project, wireless debugging to the onn box (USB debugging OFF).
2. Build the **foundation**: USB scanner and FileBot-name parser, TMDB matching and offline cache, a plain player that plays a real file. Ask Karan for 2 sample paths (one film, one episode). His library is already renamed by FileBot to TMDB/IMDb names, so most titles match on the first pass.
3. Then the design-system module (glass, type, motion, glow, hue, panes loader), then screens in the order in `docs/ARCHITECTURE-AND-BUILD-PLAN.md`.
4. Ask before anything destructive on the box or the USB drive.

## Open items to confirm with Karan

- Launcher app-tile style (themed white vs original colours vs icon on glass). Currently leaning to original colours on full tiles.
- Real hardware performance of heavy blur on the onn box (tune strengths per screen).
- Whether to also target Google TV Streamer later.
