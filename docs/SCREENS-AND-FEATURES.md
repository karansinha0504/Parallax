# Screens and features (agreed)

Reference mockups are in `../mockups/`. Everything here was reviewed and approved by Karan unless marked "open".

## Boot intro
Pure black. Three softly tinted glass panes (violet, teal, amber) drift in from different depths and settle into the offset logo. The wordmark "parallax" (Heros regular) sharpens up beneath them. Short hold, then panes and name fade into the home screen as the cards rise in. About 3.5s on TV, about 2.5s on phone. Sound: warm marimba notes timed to the panes landing and the name appearing, like a soft "ta-dum". No swoosh. **On the phone the intro is just the logo, without the name.**

## TV app

**Home.** Top bar: wordmark, then Search, Recents, Private, Settings, clock. A library carousel opens first (focused library fills the height with artwork, name, count and last-watched card; others are slim vertical bars). Below it, rows: Continue watching, Up next, Favourites, Collections, Recently added, Recently played in Music, Moods (Gemini mixes), the yearly recap ("Your year at sea"). **One section open at a time**; the next row shows as a single bar at the bottom, the previous collapses to a bar at the top. Up/down morphs smoothly; left/right springs.

**Libraries.** Landscape art on the right half, fading to black left and down. Info and filter chips (All, Unwatched, In progress, Recently added) above; posters start about 40% down, 5 per row, whole rows only. Moving onto the **A to Z bar** hides art and info and fills the screen with as many rows as fit, with a large letter badge. TV shows use the same layout; opening a show shows season tabs and episode cards (4 per row) in the same layout.

**Movie page.** Landscape art right, title logo (fanart.tv clear logo, falling back to bold Heros text), one plain info line, 2-line synopsis, Resume (bright glass, with progress) plus a More card. The details row (Cast and crew expanded, Soundtrack, About this file) stays **open at the bottom**. More menu: Restart, Mark as watched, Add to favourites, Hide from Continue watching. Card toggles here are smooth, no bounce.

**Player.** Any button press while playing: an amber glass circle rises from the bottom pointing up, rotates to point right, then a thick white seek bar grows from a point just above the circle to both sides; then skip-back-10, skip-forward-10, subtitles (clear), audio (dark) and settings (clear) buttons pop in. Controls hide in reverse. Seeking: **double-press left/right = +/-10s; hold = fast-forward/rewind starting at 2x, each further press doubles: 2, 4, 8, 16, 32, 64, 128x.** Subtitle tools: size, background, timing offset, load .srt from the drive, find online when connected. Sleep timer (15, 30, 60 min, end of film) with a moon badge. Playback speed. "Are you still watching?" prompt. Subtitles move up when controls show and hide while seeking or when a menu is open. Dialogue boost is **not** wanted (he prefers director's audio).

**Search.** The most robust search possible: typo-tolerant, natural-language ("thriller 2025", "songs by the quays", "films with the sea"), searches titles, cast, soundtracks, episode names, collections, playlists and synopses, shows "Understood as" chips, top result plus other matches, scope chips (All, Films, Shows, Episodes, People, Music), voice search, on-screen keyboard (and typing from a keyboard). Recent searches and example searches when empty.

**Recents.** One card per film or show (latest episode), stacked in depth, front card shows the exact frame where you stopped, "Paused at 31:12", progress bar, Resume and Details. Left = back in time, right = forward, up = remove, down = details; time labels (Today, Yesterday...).

**Private.** Locked area holding several private video libraries, PIN pad on TV (fingerprint on phone). Private items never appear in home rows, search, Recents, launcher or screensaver. (Files are only hidden in-app; optional encryption was offered, Karan said he never shares the drive.)

**Music.** Music library screen styled like the phone's music page (sections Your library, Moods mixed by Gemini, Recently played, Mixes for you; big **square** cards). Now playing: album-art stack, colours from the art, morphing play button with progress ring, previous/next with nudge, secondary chips Shuffle, Repeat (off, all, one), Lyrics, Queue, More; lyrics view (synced lines, current bright); lively queue (now-playing row with equaliser, art-coloured glow, fading into the distance; OK plays, right removes); **ambient mode** after about 12s idle (controls drift away, art centred).

**Settings** (own themed screens): Library (rescan, Fix matches, metadata waiting), Sync (pairing with phone via QR code, what syncs), Playback, Subtitles, Screensaver (artwork pans and clock, set system-wide if possible), Backup (export and restore), About. Pairing shows a QR code and a 6-digit fallback.

**Loader.** Three-pane loader instead of spinners ("Scanning your library").

## Phone app

**Home (Entertainment).** Same accordion as TV, **finger-following**: a section is open with a big card row; swipe up/down drags it toward the next bar and morphs continuously; swipe left/right moves cards (spring). Header: wordmark, Search, Recents, Private, Settings. **Bottom dock**: small glass pill-less pair of icons (film, music note) with a springing highlight, beside the collapsed mini player. Ambient hue behind.

**Music tab.** Library and Shuffle cards, Moods (Gemini mixes), Albums, Mixes for you, Library page with **Tracks and Playlists only** (no albums or artists browsing): compact card rows, sort (A to Z, Recently added, Most played), Shuffle all, draggable fast-scroll handle with letter bubble. **Mini player opens by dragging up, following the finger**; Now playing has the art stack, slide-to-seek on the art, morphing play with ring, hold previous/next to scrub, chips (Shuffle, Repeat, Lyrics, Queue), share (copies the song from the box first if needed, then opens the share sheet), reorderable queue (drag handle, swipe left to remove), lyrics, ambient mode.

**Library, show, movie pages.** Same layouts as TV (hero art top, posters below, A to Z bar). Movie page actions: Resume, Download (to phone), Play on TV, More; sections Cast, Soundtrack, About this file.

**Video player.** Miniature of the TV player. **Slide sideways on the video to seek** (distance sets speed, MX Player style, with preview frame), double-tap sides = 10s, hold side = fast-forward up to 128x.

**Settings.** Sync status card ("Everything up to date", Sync now), pair another box (QR scan), music folder on the phone, auto-send new songs to the box, **new songs inbox**, YouTube Music gap check, downloads, playback, Private, backup.

## Launcher (locked layout: `parallax-launcher-v4.html`)
Same family as Parallax but lighter: blurred living wallpaper, status bar, **app icons in a top row** (YouTube, Parallax, Netflix, Prime Video, All apps). Scrolling across the icons shows only the focused app's sections below as **extra-big cards filling the open section, title overlaid on artwork**, one section open with a bar for the next. YouTube/Netflix/Prime sections come from the Android TV "Watch Next" and channel rows (READ_TV_LISTINGS); we can read but not delete other apps' rows. Offline: streaming cards grey out ("needs internet"), Parallax rows stay. Selecting Parallax plays a quick pane intro and enters the pure-black app. Icon style: undecided (default original colours on full tiles). Quick settings: picture, sound output, input, sleep timer, screensaver. Planned: make it the default home via ADB.

## Music and library workflows
- **Music is quantity over quality at sea**: keep every song even at 128 kbps, never nag about quality. Incoming WAV converts to 320 kbps MP3 (no FLAC; he listens over Bluetooth). Better copies replace worse ones quietly, keeping play counts and playlists.
- **Phone folder as a second library source**, merged with the box (a source mark on each song, duplicates matched once). New songs auto-sync to the box over the cabin network, filed like his beets setup.
- **Metadata inbox for new songs**: junk-stripping (e.g. "(PagalWorld.com)"), offline fingerprinting, queued online lookups (AcoustID, MusicBrainz, Discogs with his token, iTunes/Deezer art, LRCLIB lyrics, YouTube as fallback). Only near-certain matches are auto-applied; every change is undoable (original tags kept); unsure ones stay in a quiet "needs a look" list.
- **Lyrics**: synced LRC from LRCLIB; otherwise auto-align plain lyrics offline (Whisper-based) and mark as auto-synced.
- **YouTube Music "gap check"**: reads his YT Music library, lists songs missing from box and phone, creates a "Missing from Parallax" playlist as a checklist. He downloads the files elsewhere and drops them into Parallax; matches get ticked off automatically. (Uses an unofficial library; may break. Keep it optional.)
- **Moods**: Gemini sorts songs into moods (Calm, Night watch, Homesick, Rainy day, Workout, Focus, Happy) while online; mixes then work fully offline. Combine with on-device tempo/energy measurement.
- **Profile backup**: settings, watch progress, favourites, collections, playlists, play counts, match fixes and paired devices, no media. Phone keeps a copy automatically; Google Drive app-data folder as the second layer; restore via QR on a fresh install.
- His existing beets toolkit is in `../music-toolkit/` (run it at home before the music side).

## Other agreed features
Collections as their own row (auto-detected series), TMDB ratings, hide from Continue watching, "Fix match" and "Choose artwork" screens, download to phone, phone and TV watch-progress sync, home-screen widget and lock-screen controls on the phone, backup/export, yearly recap, artwork screensaver, sleep timer everywhere, repeat/shuffle/crossfade/gapless/equaliser/radio (similar songs from his own library).

## Explicitly not wanted
Dialogue boost; vibrant or shiny colours on UI; pill-shaped buttons; solid (non-glass) panels; spaced serif titles; light-sweep glass shine; quality warnings on music; trailers; profiles; low-value extras (watch-schedule suggestions, wake-up alarm, crew movie night, night warmth).
