## Changelog

### 2.0.0 (in testing)
- Added stepwise note transposition feature for edostep to replace up/down arrow keys
  function.
- Refactored accidental state reading to be stateless.
- Fixed up/downs notation accidentals to follow best-fifths convention as per [NOTATION GUIDE FOR EDOS 5-72](http://tallkite.com/misc_files/notation%20guide%20for%20edos%205-72.pdf).
- Handle playback for notes exceeding offset bounds of +/-200 cents.

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
