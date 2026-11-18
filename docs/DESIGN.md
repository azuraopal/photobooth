# Photobooth studio

The studio is a photo-editing surface: the print is the focal point, with capture
and import always available within thumb reach. Layout, frame and filter choices
sit in horizontal trays so a long catalogue cannot push capture off screen.

## Visual system

- Paper: `#FAF9FC`; readable ink: `#302436`; supporting text: `#6D6473`.
- Cutting mat: `#DCE7ED`; berry action/selection: `#9D294E`.
- Borders: `#E2DEE6`. Shadows belong to the physical print only.
- Native system type: 23px wordmark, 24px studio heading, 12–14px controls.
- Quiet photo-workbench grid and a slight print rotation are preview treatments;
  neither is baked into the exported image.

## Interaction and accessibility

- A bottom safe-area toolbar retains capture/import or save/share while scrolling.
- The initial classic-strip selection is visible at the beginning of the layout tray.
- Captions and timer live in a scrollable bottom sheet that accommodates the keyboard.
- Choice semantics expose a single label, selected state and activation action.
- No looping motion or automatic entry animation. The UI supports large text and
  narrow screens through scrolling and wrapping rather than disabling text scaling.
- Thumbnail image decoding is limited to 240px. Original photo bytes and the main
  export renderer retain full source data.
- Exports normalize rounding to 600px width and the selected layout's aspect ratio.

## Guidance consulted

- Project skill: `.agents/skills/photobooth-flutter/SKILL.md`.
- [Anthropic frontend-design](https://github.com/anthropics/skills/blob/main/skills/frontend-design/SKILL.md):
  visual decisions grounded in the product, restrained decoration, clear actions,
  and screenshot-based critique. Adapted to Flutter; no web framework installed.
- Orca's version-matched `orca-emulator` skill for iOS simulator operation.
