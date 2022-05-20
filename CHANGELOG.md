## Changelog

### 2.3.2
- Fixed perfect (sharp-0) EDOs not working properly, 35 EDO infinite loop
- Fixed typo in getOverLimitEnharmonicEquivalent causing overlimit semitone nominals to be calculated
  using whole tone nominals/return NaN, which breaks semitone nominals of uncommon EDOs.
- Refactored console logging to improve performance

### 2.3.1
- Implemented extensible config object; added showallaccidentals feature to always show courtesy accidentals.

### 2.3.0
- Added support for transposing instruments via transposition annotation. Only regular fifth-based transpositions
  are supported (regular accidentals only).
- Clean up readme.

### 2.2.9
- Fixed pitch down invoking pitch-up command when rests/text/non-note elements are selected
- Fixed pitch up not correcting an exceeded enharmonic (bug fix #31)

### 2.2.8
- Fixed critical bug:
  - localized name used for staff/system text causing the plugin to not work
    when MuseScore is not set to use English.

### 2.2.7
- Fixed critical bugs:
  - two notes in same segment, voice, tick, and line, yields wrong accidentals when transposed.
    (getMostRecentAccidentalInBar did not handle 'before' processing correctly. 'before' was tick based
    but should've been based on voice and visual positioning).
- Wayyyy more robust setAccidental function which ensures set accidentals persist in
  code even after the note is edited and traversed.
  This actually allows for a lot of the parms state nonsense to be removed with some refactoring.
  Perhaps in a future version the code base can be a lot cleaner.

### 2.2.6
- Fixed critical bugs:
  - getMostRecentAcc gave the wrong accidental when there are notes on the same staff line
    in different voices, causes pitch up/down to get stuck on one note.
  - Tune N-EDO plugin: key signature/edo/frequency center annotation texts broken when multiple voices are present in the bar where the annotation texts are declared (Bug fix #25)

### 2.2.5
- Fixed critical bugs:
  - Some grace notes break the plugin due to a typo in getMostRecentAccidentalInBar.
    Some grace notes were indexed as notes[i] instead of notes[j] due to careless copy-pasting typo.
  - Pitch up with arrows not working

### 2.2.4
- Fixed critical bug:
  - if a note were to have an explicit natural accidental after pitching up/down,
    and the inherited accidental prior to the current note was a regular accidental,
    any following notes in the selection with the same pitch will be affected by the first regular accidental,
    and not the second one.
- Fixed typo in NoteType.APPOGIATURE => NoteType.APPOGGIATURA

### 2.2.3
- Fixed issue where an accidental in the next bar affects an accidental before when the accidental in the
  next bar is of a lower voice index than the current selected individual note(s).
  This issue only happens when noteheads are selected rather than entire group selections,
  and the noteheads are of voice 2, 3 or 4.

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
