## Changelog

### 2.2.2
- Fixed incorrect tuning of up/down arrows where regular sharps/flats are applicable. 

### 2.2.1
- Bug fix (#17)

### 2.2.0
- Added support for custom tuning centers.

### 2.1.2
- Added 'no dt' version, which prioritizes up/down arrows over semi/sesqui sharps and flats wherever possible.

### 2.1.1
- Fixed formatted StaffText/SystemText causing tuning system parsing to fail
- Fixed certain accidentals fail to reflect in tuning plugin
  - Caused by unexpected coercion of accidentalType to string.

### 2.1.0
- Implement generic n-EDO plugin for flat-2 to sharp-8 EDOs. (Most EDOs from 5 to 72 are covered, except 59, 66, and 71)

### 2.0.3
- Fixed local vs. global key signatures not working.

### 2.0.2
- Fixed transposing breaking down on grace notes
  - `note.parent.parent.tick` vs. `note.parent.parent.parent.tick` for grace notes abstracted by `getTick()`
  - Fixed grace notes not regarding sibling grace notes and parent chord notes as possible candidates
    for followingOldLine and followingNewLine.
  - Fixed accidentals on prior grace notes on the current chord segment not accounted for.
- Fixed cursor relocation on getAccidental causing havoc. getAccidental will now return cursor to original position.
- Relocate cursor to individually selected notes when transposing

### 2.0.1
- Fixed reading accidentals for transposition doesn't work when accidentals are in
  the last bar.

### 2.0.0
- Added stepwise note transposition feature for edostep to replace up/down arrow keys
  function.
- Refactored accidental state reading to be stateless. (for transposition plugins)
- Fixed up/downs notation accidentals to follow best-fifths convention as per [NOTATION GUIDE FOR EDOS 5-72](http://tallkite.com/misc_files/notation%20guide%20for%20edos%205-72.pdf).
- ~~Handle playback for notes exceeding offset bounds of +/-200 cents.~~ (Unnecessary,
  [pitch offset may exceed 200/300 cents even if not reflected in UI](https://www.reddit.com/r/microtonal/comments/gssrnk/made_this_31_22_edo_microtonal_plugin_for/fs7frcg?utm_source=share&utm_medium=web2x))
- Support for ties in transposition

### 1.3.7
- Fixed custom key signatures before selection not being applied to selection.
- Fixed accidentals in same bar before selection not being accounted for
- Fixed partial selection not working
- Improved handling of two notes with the same line at the same time.
- Fixed custom key signatures in partial selections not working.
- Fixed cursor rewind calls to use the Only Right Way That Works :tm: for whatever reason.

### 1.3.6
- Fixed fermatas and other non-text annotations breaking the plugin

### 1.3.5
- Added 22-edo superpyth version.
- Fixed custom key signatures not affecting other voices (even system text)
- Fixed accidentals on notes of higher voices not affecting lower voices

### 1.3.4
- Fixed meantone double accidentals not accounting for accidental's default double
  sharp/flat effect (https://musescore.org/en/node/285449)

### 1.3.3
- Fixed custom key signatures not working if multiple annotations exist on same segment
  (caused by JavaScript insanity)
- Fixed explicit natural accidentals not affecting custom key signatures

### 1.3.2

- Now supports MuseScore version 3!

### 1.3

- Removed unecessary GUI dialog --- planning to make a 31-TET suite of micro-plugin features which
  users can take advantage of custom-assigned plugin key bindings to improve workflow.
  (E.g. Alt + W to transpose up 1 diesis, Alt + S to transpose down 1 diesis, Alt + E to rotate enharmonical equivalents)
- Added meantone mode
- Fixed microtonal accidentals from notes in same staff not affecting subsequent notes of other voices in same staff in measure.

### 1.2

- Fixed non-naturalised explicit natural accidental in note affected by a custom key signature
- Added support for declaring custom key signature changes in SystemText/StaffText
- Added usage guide in this file
- Preparing for meantone quartertone-accidental mode support

### 1.1

- Fixed occassional bug where microtonal accidentals carry over the bar line when it shouldn't
- Attempted to fix UI bug in Windows, haven't tested it yet though :/
