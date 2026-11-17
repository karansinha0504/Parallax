# Artwork selection system (to build)

Each place in the app asks for a specific type of art. Pick automatically; never stretch the wrong shape.

| Slot | Art needed |
|---|---|
| Library grids, collection stacks | Poster 2:3 |
| Page backdrops (movie, show, library hero, screensaver, ambient) | **Textless** backdrop 16:9 |
| Home-row and launcher big cards | Landscape 16:9 **with title** (fanart.tv thumb), else a title-less backdrop with the title overlaid |
| Movie and show pages | Transparent **clear logo** (light versions preferred; skip dark logos that vanish on black) |
| Episode cards | Episode still 16:9 |
| Music | Square album art (embedded in files first) |

**Sources.** TMDB: posters, backdrops, logos, stills (backdrops are tagged by language; `null` language = textless). fanart.tv: clear logos, landscape thumbs. IMDb: no free image API; use its ID only to link to TMDB. His FileBot-renamed library should match on title and year, and can use `{tmdb-ID}` in folder names when present. His Emby metadata folder already holds posters, backdrops, logos and NFO files per title; reading those first (local, offline) is acceptable before downloading.

**Choosing.** Correct shape first, then preferred language (English, else textless), then highest votes and resolution. Fallbacks: no logo -> bold Heros title text; no textless backdrop -> a backdrop with text cropped away from the title; no landscape -> poster centred with a blurred extension of its own colours.

**Focus point.** Detect faces and the main subject once and store a focus point so crops keep the people in frame.

**Precompute at scan time.** Dominant colours (top, middle, bottom) for the ambient hue and glow, and a single glow colour. Store images at the sizes the TV and phone need; keep offline forever.

**Manual override.** In Settings, "Fix match" and "Choose artwork" let Karan swipe through alternatives.
