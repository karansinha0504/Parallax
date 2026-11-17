# Mistakes made repeatedly during design (do not repeat)

These each cost review rounds. Check for them on every screen.

1. **Bounce on vertical moves.** Up/down must never overshoot. Only left/right springs. A "pop" animation played on focus caused bounce on some rows but not others; use one consistent smooth lift.
2. **Different focus treatment per row.** Every row focuses identically.
3. **Left edges off by a few px.** Focused cards that scale from the centre push their left edge past the bars. Scale from the left edge. Leftover padding on one row (collections) shifted it.
4. **Clipping.** A masked or overflow-hidden container slicing a lifted/focused card; half rows peeking at the bottom of grids; lyric lines growing past their box. Fix by fading out-of-view rows instead of clipping, and giving containers room for the focused state.
5. **Big elliptical glow.** Glow must be a soft copy of the card's own shape, close to it, fading to nothing. No visible hard edge.
6. **Hard lines on bars.** Glass bars that content scrolls behind need blur plus black tint and curved edges, never a sharp straight line.
7. **Abrupt section expansion.** Sections must morph continuously from bar to open row, following the finger on phone.
8. **Preset jumps on phone.** Scrolling, swiping, the mini player sheet and sliders must follow the finger 1:1.
9. **Cropped art.** Landscape art is shown at true 16:9 in the right half, never cropped to a thin strip. Use the correct art type for each slot (see ARTWORK-SELECTION.md).
10. **Square vs portrait.** Music tiles are square. Posters are 2:3. Never force one into the other.
11. **Flat, dead UI.** Add depth with blur and translucency; add life with the ambient hue and tinted controls; but keep it calm. Nothing flashy.
12. **Coloured UI.** UI stays glass and white on black; colour comes from artwork (and the tint from song art in the music player).
13. **Layers of leftover styles.** When restyling something, delete the old styles. Old collection layers kept drawing behind the new ones and made it look wrong.
14. **Text sizes.** Exactly three sizes per screen.
15. **Moving too fast to read.** Transitions are .45 to .55s. Hue crossfades are slow (about 1.3s) so quickly moving across cards gives a gentle drift, not a flicker.
