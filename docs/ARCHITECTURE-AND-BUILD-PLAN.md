# Architecture and build plan

## Modules (suggested)
- `design-system`: glass, typography (Heros), motion specs, glow, ambient hue, pane loader, shared components. **Separate module** so future apps (smart-home desk display, other tools) reuse it.
- `core-library`: USB scanner, FileBot-name and NFO parser, TMDB and fanart.tv clients, offline cache, Room database, colour extraction.
- `core-player`: Media3/ExoPlayer wrapper (MKV, subtitles, audio tracks, chapter markers, intro/credits skip), position store.
- `core-music`: tag reading, lyrics (LRC), queue, gapless and crossfade, equaliser, fingerprinting and metadata pipeline.
- `core-sync`: embedded local server on the box (Ktor or NanoHTTPD), network discovery, QR pairing with a shared secret and encrypted channel, progress/playlist sync, song upload to the box, profile backup (phone first, then Google Drive app folder).
- `app-tv`, `app-phone`, `app-launcher`: UI on top of the modules.

## Platform notes
- Compose for TV on the onn box; d-pad focus management is critical. Verify the dp scale of the 1280x720 mockup stage against the real device.
- **Performance budget for blur**: heavy blur is the most demanding effect. Build blur strengths as per-screen tunables, test on the onn box, and reduce first on screens with many glass layers. Use flat tinted fills for small moving badges.
- **USB access**: scoped storage / USB mass storage on Android TV; files are on exFAT (not NTFS) if he ever moves to a Google TV Streamer.
- **Launcher**: read Watch Next and channel programs (READ_TV_LISTINGS). Make default via ADB. Optionally handle the Home button through an accessibility service (may break on updates; the box never updates).
- **Phone companion**: discovers the box on the local network; streams the file directly (no transcoding); remote-controls playback.
- **No system updates on the onn box. Wireless debugging only (USB debugging off).**

## Build order
1. Environment and skeleton; install to the box over wireless debugging.
2. Library engine (scan, parse, match, cache artwork and colours) and a plain player that plays a real file.
3. Design-system module.
4. TV app: boot, home with sections and morph, library and show pages, movie page, player, search, Recents, settings, loader, screensaver, then music (library, now playing, queue, lyrics), then Private.
5. Sharing server, phone pairing and sync.
6. Phone app: home, library and detail pages, player with slide-to-seek, music (library, mini player sheet, now playing), downloads, inbox, settings, widget and lock-screen controls.
7. Background machinery: metadata queue, auto-send songs, backup and restore, undo history.
8. Launcher.
9. Polish and offline and wiped-box testing.

## Distribution
Not on the Play Store. Build APKs and install over wireless debugging. Later maybe an in-app "update available" check.

## Quality bar (acceptance checks)
- No clipping on any screen, in any focus state. (A DOM-style checker was used on the mockups: for every focused element, confirm no ancestor clips it. Mirror this with a layout test on the real UI.)
- Left edges aligned across bars, labels, cards and info (assert equal x).
- Vertical moves never spring; horizontal moves do. Focus treatment identical across rows.
- Offline: everything except online lookups works with no network; queues drain when a connection appears.
- Undo for every automatic tag change; nothing blocks playback.
