# 31/22 EDO Retuner plugin for Musescore 3

Musescore plugin to retune and pitch up notes in [31 edo](https://en.wikipedia.org/wiki/31_equal_temperament)
and [22 edo](https://en.wikipedia.org/wiki/22_equal_temperament)



## Usage

- Download the QML files for the tuning/notation system of choice and put them in the plugins folder.

- [Install & Activate the plugins](https://musescore.org/en/handbook/plugins#windows)

- This plugin current supports the following notation/tuning systems:
  - [31 EDO (ups & downs)](#31-edo-ups-and-downs)
  - [31 EDO (quarter-tone accidentals)](#31-edo-quarter-tone-accidentals-for-14-comma-meantone-approximation)
  - [22 EDO (ups & downs, superpyth best fifth)](#31-edo-quarter-tone-accidentals-for-14-comma-meantone-approximation)

- The microtonal accidentals this plugin uses are Gould Arrow Quartertone accidentals for ups and downs arrow notation
  and Stein-Zimmermann quartertone accidentals for 31 EDO 1/4-comma meantone quartertone accidental notation.
  - The Gould Arrow accidentals are not to be confused with the similar looking Helmholtz-Ellis Just Intonation accidentals
    that have thinner and smaller arrows (![Helmholtz syntonic up](images/helmholtz.png)) than the
    Gould accidentals (![Up](images/u.png)). If you hover over the accidental in the palatte and it says 'syntonic comma' in the name,
    **that is the wrong accidental**.
  - Each up/down arrow represents an offset of 1 edostep (the smallest interval in the tuning system) from the
    default nominals (natural notes) and sharps/flats.
  - A sharp is tuned as stacking 7 best fifths up. (**C** G D A E B F# **C#**)
    - E.g.: a best fifth in 31 edo is 18 steps of 31 edo. 7 best fifths = 7 * 18 = 126 steps mod 31 = 2 steps disregarding octaves.\
      Hence in 31 edo, C# is 2 steps above C. C double-sharp is 4 steps above C.
    - A best fifth in 22 edo is 13 steps. (7 * 13) mod 22 = 3 steps.\
      In 22 edo, C# is 3 steps above C.
  - A flat displaces the note as many steps as a sharp in the opposite direction.
  - For more information on this notation system, you may read this handbook:\
    [NOTATION GUIDE FOR EDOS 5-72](http://tallkite.com/misc_files/notation%20guide%20for%20edos%205-72.pdf)

- For each tuning/notation system, there will be 3 different plugins that each performs:
  - Tuning selected phrase (shift-click) / whole score (if nothing selected)
  - Transposing up by 1 EDO step & tuning selected phrase (shift-click) / individually selected notes (alt-click noteheads).
  - Transposing down by 1 EDO step & tuning selected phrase / individually selected notes.

- **[Key signatures annotations](#key-signatures-support) must be denoted for ALL key signatures for the plugin to work properly**

- Plugins for different tuning systems can be installed and activated at the same time.
  - **The plugins only take effect when they are explicitly run via the menu bar
      or an assigned keyboard shortcut.**

- To make plugin usage more ergonomic, it is recommended to assign the following keyboard shortcuts to the plugins:
  - Tuning: alt + R
  - Transpose pitch up/down: up/down arrow keys
    - The plugin is intended to replace the function of up/down arrow key shortcuts in MuseScore (including
      repositioning other elements)
    - Before assigning the transposing plugins the up/down arrow keys shortcut, you will have to clear the following
      shortcuts in the Shortcuts preferences menu with the 'Clear' button. (Edit -> Preferences -> Shortcuts)
      - _Pitch up or move text or articulation up_
      - _Pitch down or move text or articulation down_
      - _Select string above (TAB only)_
      - _Select string below (TAB only)_

--------

## Supported Tuning Systems

### 31 EDO (Ups and Downs)

> Plugin files:\
> tuning: https://github.com/euwbah/musescore-n-tet-plugins/blob/master/31-TET.qml\
> transpose up: https://github.com/euwbah/musescore-n-tet-plugins/blob/master/Transpose-Up-31-TET.qml\
> transpose down: https://github.com/euwbah/musescore-n-tet-plugins/blob/master/Transpose-Down-31-TET.qml\
>
> A4 = 440hz\
> Nominals: C D E F G A B (C)\
> Scale steps: LLsLLLs\
> L: 5 steps\
> s: 3 steps\
> sharp-2

| Diesis steps | Accidental |
| ---: | :----- |
| -5  | ![Double flat down](images/bbd.png) |
| -4  | ![Double flat](images/bb.png)  |
| -3  | ![Flat down](images/bd.png) or ![Double flat up](images/bbu.png) |
| -2  | ![Flat](images/b.png)  |
| -1  | ![Down](images/d.png) or ![Flat up](images/bu.png) |
| 0   | ![Natural](images/n.png) |
| +1  | ![Up](images/u.png) or ![Sharp down](images/sd.png) |
| +2  | ![Sharp](images/s.png)  |
| +3  | ![Sharp up](images/su.png) or ![Double sharp down](images/xv.png) |
| +4  | ![Double sharp](images/x.png)  |
| +5  | ![Double sharp up](images/xu.png)  |

### 31 EDO (quarter-tone accidentals for 1/4-comma meantone approximation)

> Plugin files:
> tuning: https://github.com/euwbah/musescore-n-tet-plugins/blob/master/31-TET-Meantone.qml\
> transpose up: https://github.com/euwbah/musescore-n-tet-plugins/blob/master/Transpose-Up-31-TET-Meantone.qml\
> transpose down: https://github.com/euwbah/musescore-n-tet-plugins/blob/master/Transpose-Down-31-TET-Meantone.qml\
>
> A4 = 440hz\
> Nominals: C D E F G A B (C)\
> Scale steps: LLsLLLs\
> L: 5 steps\
> s: 3 steps\
> sharp-2

| Diesis steps | Accidental |
| ---: | :----- |
| -4  | ![Double flat](images/bb.png) |
| -3  | ![Sesqui flat](images/db.png)  |
| -2  | ![Flat](images/b.png)  |
| -1  | ![Down](images/d-quarter.png) |
| 0   | ![Natural](images/n.png) |
| +1  | ![Up](images/+.png) |
| +2  | ![Sharp](images/s.png)  |
| +3  | ![Sesqui sharp](images/ss.png)  |
| +4  | ![Double sharp](images/x.png)  |

### 22 EDO (Superpythagorean notation)

> Plugin files:
> tuning: https://github.com/euwbah/musescore-n-tet-plugins/blob/master/22-TET.qml\
> transpose up: https://github.com/euwbah/musescore-n-tet-plugins/blob/master/Transpose-Up-22-TET.qml\
> transpose down: https://github.com/euwbah/musescore-n-tet-plugins/blob/master/Transpose-Down-22-TET.qml\
>
> A4 = 440hz\
> Nominals: C D E F G A B (C)\
> Scale steps: LLsLLLs\
> L: 4 steps\
> s: 1 steps\
> sharp-3

**WARNING**: As MuseScore limits the maximum pitch shift on a note to 200 cents, most 4 step
accidentals, and all 5-6 step accidentals will not fit within a 200 cent offset
and therefore will sound several semitones out of pitch when the note is selected
and sounded in editing mode.\
However, when playing back a score (via the play button / spacebar), the note will sound in the correct pitch.

| Diesis steps | Accidental |
| ---: | :----- |
| -6  | ![Double flat](images/bb.png) |
| -5  | ![Double flat up](images/bbu.png) |
| -4  | ![Flat down](images/bd.png) |
| -3  | ![Flat](images/b.png)  |
| -2  | ![Flat up](images/bu.png)  |
| -1  | ![Down](images/d.png) |
| 0   | ![Natural](images/n.png) |
| +1  | ![Up](images/u.png) |
| +2  | ![Sharp down](images/sd.png)  |
| +3  | ![Sharp](images/s.png) |
| +4  | ![Sharp up](images/su.png) |
| +5  | ![Double sharp down](images/xd.png) |
| +6  | ![Double sharp](images/x.png) |

### Key signatures support

MuseScore doesn't recognize accidentals in
[custom key signatures](https://musescore.org/en/handbook/key-signatures#custom-key-signatures),
and MuseScore plugins are not yet able to detect the contents of a key signature element.

As such, if you want to create a microtonal key signature and have it affect the
playback, you have to explicitly declare the key signature using
system/staff text annotations containing accidental code.

Also, in order for the up/down step transposition feature to work properly,
**all** key signatures, even standard ones, must be accompanied with system/staff
text key signature annotations.

- Use **System Text** (`Ctrl` + `Shift` + `T`) if you want the key signature code to affect
  all staves from there onwards
- Use **Staff Text** (`Shift` + `T`) if you only want the code to affect the staff that it is on.
  This is especially useful when using **local** key signatures!
- Remember to make the custom key signature code invisible! (Press `V` to toggle visibility)

Key signature code syntax:

1. Start with a dot `.`
2. Put the textual representation of the accidental for the note **C** using the [accidental code](#accidental-code)
3. Put another dot `.`
4. Put the required accidental for **D**
5. Repeat from notes **C** thru **B**

Natural accidentals are denoted by leaving the space blank, or using any other character
that does not represent an accidental.

**Examples:**
Ab-down major in 31 edo's ups-and-downs is written like this: `.v.bv.bv.v.v.bv.bv`
representing the key signature of Cv, Dbv, Ebv, Fv, Gv, Abv, Bbv.

C major in 22 edo's ups-and-downs is written like this: `.0.0.v.0.0.v.v`
representing the key signature of C, D, Ev, F, G, Av, Bv. (The `0`s represent placeholders,
you can also choose to put nothing between the dots)

> Note that explicit accidentals will still take precedence over the
> declared custom key signature, behaving exactly the same way a key signature
> would.

#### Accidental Code

| Accidental | Textual representation |
| ----: | :---- |
| ![Double flat down](images/bbd.png) | `bbv` |
| ![Double flat](images/bb.png) | `bb` |
| ![Double flat up](images/bbu.png) | `bb^` |
| ![Sesqui flat](images/db.png) | `db`  |
| ![Flat down](images/bd.png) | `bv`  |
| ![Flat](images/b.png)   | `b`  |
| ![Flat up](images/bu.png)   | `b^` |
| ![Down](images/d.png)   | `v` |
| ![Down](images/d-quarter.png) | `d` |
| ![Natural](images/n.png) | Leave blank / any other character  |
| ![Up](images/+.png) | `+` |
| ![Up](images/u.png) | `^` |
| ![Sharp down](images/sd.png) | `#v` |
| ![Sharp](images/s.png) | `#`  |
| ![Sharp up](images/su.png) | `#^`  |
| ![Sesqui sharp](images/ss.png) | `#+` |
| ![Double sharp down](images/xd.png) | `xv` |
| ![Double sharp](images/x.png) | `x` |
| ![Double sharp up](images/xu.png) | `x^` |

![Staff text custom key sig](images/key-sig-example.png)

## Known issues:

- Cross staff notation doesn't work properly, the accidentals in the staff that the notes are transferred to
  do not affect the notes that originally belonged in that staff that the notes were transferred to.
  Please refrain from using cross-staff notation, or submit a PR for this fix.

- Accidentals of grace notes that comes after rather than before are handled as if they were before, and also
  not in the right order. This causes huge problems when transposing.
  Please refrain from using grace notes that attach after main notes, or submit a PR for this fix.

- The plugin tries its best to handle chords with pairs of mirrored notes that
  share the same line (e.g. an F and F# on the same staff line) but due to plugin API
  limitations and the way MuseScore natively handles them, its behavior is somewhat janky.
  When dealing with them, ALWAYS use explicit accidentals on the mirrored notes to
  ensure the Accidentals are all registered correctly. This way it is clear to read
  and also for the plugin to read and understand which accidentals belong to which
  notes.
  - The exact order the plugin reads and performs operations on its notes of each chord segment are as follows:
    1. grace notes (in similar fashion to step 2)
    2. For notes in the same chord, left to right, then bottom to top, as they appear in the score.

-------------

## Note to self / developers:

### IMPORTANT basic info on undocumented Plugin API mechanics!

CURSOR REWIND MECHANICS ARE WEIRD!
  - If rewinding to start of selection `cursor.rewind(1)`, set `cursor.staffIdx` and `cursor.voice` after
    `rewind(1)`.
  - If rewinding to start of score, IT IS STILL NECESSARY TO CALL `cursor.rewind(1)`, then set `staffIdx` and `voice`,
    THEN call `cursor.rewind(0)` AFTERWARDS.


It is an invalid operation to set cursor voice/staffIdx without rewinding.


IMPORTANT! DO NOT USE `===` or `!==` to compare equivalence of accidentalType to Accidental enum values.


When assigning `Note.accidentalType` to variables or passing it into a function as a parameter,
ensure that the value read is in integer format to invoke the getter of the
integer enumeration instead of the stringified value of the accidental type.

```js
noteData.explicitAccidental = note.accidentalType;
console.log(explicitAccidental); // NATURAL_ARROW_UP
noteData.explicitAccidental = 0 + note.accidentalType;
console.log(explicitAccidental); // 11 (enumerated value equivalent of NATURAL_ARROW_UP)

console.log(Accidental.NATURAL_ARROW_UP); // 11

console.log(note.accidentalType); // NATURAL_ARROW_UP
console.log(0 + note.accidentalType) // 11
```


It's important to clear the accidental first before assigning (in general).
  - If existing accidental type is a non-standard accidental, and the new assigned accidental type is standard,
    the new assigned accidental type would affect the tpc of the note, but
    the existing non-standard accidental still displays instead of the new one.

```js
note.line = 0;
note.tpc = 13; // F natural
note.accidentalType = Accidental.NATURAL_ARROW_UP; // set to non-standard accidental
note.accidentalType = Accidental.SHARP; // note will still appear with NATURAL_SHARP_UP, but it will sound as SHARP.
console.log(note.tpc); // 20 (F sharp)
console.log(note.accidentalType); // it is STILL NATURAL_ARROW_UP...

note.line = 0;
note.tpc = 13; // F natural
note.accidentalType = Accidental.NATURAL_ARROW_UP; // set to non-standard accidental
note.accidentalType = Accidental.NONE; // Clear accidental
note.accidentalType = Accidental.SHARP; // note will still appear with NATURAL_SHARP_UP, but it will sound as SHARP.
console.log(note.tpc); // 20 (F sharp)
console.log(note.accidentalType); // SHARP (correct)
```

`Note.accidental` and `Note.accidentalType` properties of transposed notes that contain new accidental values of standardized
accidentals are not present in a new cursor instance. The plugin uses tpc as a workaround, but it makes it impossible to
determine if a prior note's accidental was implicit or explicit.\
[See this forum post here.](https://musescore.org/en/node/305977)

### Plugin Information

- Transposition plugins are now using stateless accidentals, scanning accidentals on the fly.
  - Works should be done to make the tuning plugins use stateless accidentals too.
    Makes it way easier to think and removes a lot of possible state errors.

> The most completely documented / commented variant of the plugin is
> in the 31-TET ups and downs notation plugins for both tuning and transposing variants.
> The rest are variants of the 31 up-downs code with certain constants and values changed.

##### Important properties:

**IMPORTANT `Note.accidental` vs. `Note.accidentalType`**:
: `accidental` represents the accidental Element object itself,
: whereas, accidentalType is a value of the Accidental enumeration!!

`tpc`
: Tonal pitch class. Circle of fifths starting from Fbb with value of -1.
: Cbb = 0, Gbb = 1, Dbb = 2, etc...

`segment.annotations[idx].textStyleType`
: 22 if Staff Text,
: 21 if System Text

`segment.annotations[idx].text`
: Contains given text

`MuseScore.curScore.selection.elements`
: An array of elements containing individual elements the user has selected
: with ctrl + click. Especially useful for applying an action to certain notes in particular.


#### Musescore Enums

##### Accidentals (used in project)

```
Accidental.none                (no explicit accidental)
Accidental.SHARP2_ARROW_UP     x^
Accidental.SHARP2              x
Accidental.SHARP2_ARROW_DOWN   xv
Accidental.SHARP_SLASH4        #+
Accidental.SHARP_ARROW_UP      #^
Accidental.SHARP               #
Accidental.SHARP_ARROW_DOWN    #v
Accidental.SHARP_SLASH         +
Accidental.NATURAL_ARROW_UP    ^
Accidental.NATURAL             natural
Accidental.NATURAL_ARROW_DOWN  v
Accidental.MIRRORED_FLAT       d
Accidental.FLAT_ARROW_UP       b^
Accidental.FLAT                b
Accidental.FLAT_ARROW_DOWN     bv
Accidental.MIRRORED_FLAT2      db
Accidental.FLAT2_ARROW_UP      bb^
Accidental.FLAT2               bb
Accidental.FLAT2_ARROW_DOWN    bbv
```

#### Custom object types in up/down step transposition plugins

##### Key signature object:

```
{
  c: {steps: <number of diesis offset>, type: Accidental enum value}
  d: ...
  e: ...
  etc...
}
```

##### Accidental object:

```
{
  offset: number of diesis offset,
  type: accidental type as Accidental enum value
}
```

##### Enharmonics object:

```
{
 above: {baseNote: 'a' through 'g', offset: diesis offset}
 below: {baseNote: 'a' through 'g', offset: diesis offset}
}
```

##### Note pitch data:

```
{
  baseNote: a string from 'a' to 'g',
  line: the note.line property referring to height of the note on the staff
  tpc: the tonal pitch class of the note (as per note.tpc)
  tick: the tick position of the note
  explicitAccidental: Accidental enum of the explicit accidental attatched to this note (if any)
  implicitAccidental: Accidental enum of the implicit accidental of this note (non null)
                      (if explicitAccidental exists, implicitAccidental = explicitAccidental)
  diesisOffset: the number of edo steps offset from the base note this note is
}
```

## [Changelog](./CHANGELOG.md)

### TODO:

- Handle cross-staff notation (ctrl + shift + up/down in connected staves, e.g. grand staff) where note appears to be in another staff
  other than the cursor's staffIdx. Currently, accidentals in the cross-staff do not work on the notes that came from another staff.
  See Add Courtesy Accidentals plugin for how to do this
- Implement porcupine notation for 22-edo (D-E-F-G-A-B-C-D = sssLsss)
- Implement toggling between enharmonic equivalences
- Don't hard-code frequencies, just use a dictionary of exponential operations instead
