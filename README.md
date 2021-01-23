# n-EDO Retuner plugin for Musescore 3.4+

Musescore plugin to retune and pitch up/down notes in any EDO ranked from flat-2 to sharp-8.
(Supports all EDOs from 5-72 except 59, 66, and 71. Also supports larger edos up to 117 that
are rated with a [sharpness](#tuning-of-regular-pythagorean-accidentals) of up to sharp-8)

[Here is the full list of supported EDOs and their respective sharpness values.](#appendix-a-list-of-supported-edos-according-to-sharpness-classification)

![screenshot](images/microtonal-plugin-screenshot.png)

## Features
- Retuning note cent offsets to match any supported edo of choice
  - Special thanks to [Flora Canou](https://github.com/FloraCanou/musescore-n-tet-plugins) for providing the generalized method for
    evaluating cent offsets for any EDO.
- Support for key signatures via [Key signature annotations](#key-signatures)
- Transposing individual notes / selections by 1 EDO step, managing neutralization and correction of accidentals on following notes.
- Tuning system, key signatures, and reference pitches can be changed mid score, and staves
  may be set to different tunings, key signatures, and reference pitches at the same time.

## Instructions

**Make sure you are using MuseScore 3.4 or newer. The plugin will not work in previous versions**

[Download the project](https://github.com/euwbah/musescore-n-tet-plugins/archive/master.zip) and unzip into MuseScore's plugins directory.

[Install & Activate](https://musescore.org/en/handbook/plugins#windows) the following plugins:

- `tune n-edo.qml`:
  - Tunes selected phrase (selection made with shift-click) / whole score (if nothing selected)
- `pitch up.qml`/`pitch down.qml`:
  - Transposes up/down selected phrase (shift-click) / individually selected notes (alt-click noteheads).
- `pitch up no dt.qml`/`pitch down no dt.qml`:
  - Same as above, but prioritizes up/down arrows over semi/sesqui sharp/flat symbols wherever possible.

- Set up keyboard shortcuts for the plugins (or access them in the plugin drop-down menu):
  - For Tuning, we recommend using Alt+R (for "Retune")
  - For Pitch up/down, we recommend up/down arrow keys
    - This replaces the original function of up/down arrow key shortcuts in MuseScore (including repositioning other elements)
    - Before assigning the transposing plugins the up/down arrow keys shortcut, you will have to clear or change the following shortcuts in the Shortcuts preferences menu (Edit -> Preferences -> Shortcuts)
      - _Pitch up or move text or articulation up_ (consider replacing with Alt+PgUp)
      - _Pitch down or move text or articulation down_ (consider replacing with Alt+PgDn)
      - _Select string above (TAB only)_ (suggest replacing with Alt+Up, which matches moving to next note above in staff)
      - _Select string below (TAB only)_ (suggest replacing with Alt+Down, which matches moving to next note below in staff)
  - Ensure only one variant of each plugin has the keyboard shortcut assigned at a time.\
    If 'pitch up.qml' is assigned to the up arrow, then 'pitch up no dt.qml' cannot be assigned to the up arrow.\
    Both plugins may be enabled simultaneously, but they must have different keyboard shortcuts.

### Selecting the tuning system

The plugin makes use of staff text annotations (Ctrl-T) and system text annotations (Ctrl-Shift-T) to configure which tuning system is used.

Using staff text will apply the tuning system to only the staff that it is on, and using system text will
apply the tuning system to the all the staves. Staff/system text will only affect the current and subsequent bars
of music, but not the bars before, thus, it is possible to change the tuning system mid-piece, and have different
instruments in different tuning systems concurrently.

It is possible, but not recommended, to change the tuning system halfway through a bar,
as accidentals may carry over and be applied in unexpected ways.

There are 3 types of tuning system annotations that the plugin accepts, and each one has to be in its own separate staff/system text:
- **EDO selector** format: `x edo` (e.g. `31 edo`)
  - Where `x` is the number of equally-spaced notes in the octave.
  - Spaces and capitalization are optional. Non-integer edos are not currently supported.
  - When the EDO is changed, any prior key signature must be redeclared as the step offsets of the key signatures would differ
    and has to be updated.
- **Reference frequency selector** format: `x: y hz` (e.g. `a4: 440 hz`)
  - Where `x` is the pitch nominal such as `a4`, `y` is its frequency. Other notes will be tuned to that as reference.
  - Spaces and capitalization are optional. Decimals in frequency are supported.
- **Key signature** format: `.x.x.x.x.x.x.x` (e.g. `.b.b.b.b.b.b.bb` is F-flat major in 12/19/31/50 edo)
  - Where each `x` represents the [textual representation of the accidentals](#key-signatures) applied on the notes C, D, E, F, G, A, and B in that order.
  - If a particular note is natural, leave the space after the dot empty or use any placeholder like '0' or 'n', but keep the dot there.\
    In total, there should be 7 dots.
  - Key signature text must be denoted on **all** key signatures present in the score, whether custom, microtonal, or standard.\
    If there are no key signatures for the score, there is no need to enter key signature text, but you can still enter a blank
    key signature text for future reference (e.g.: `.......` is a blank key signature)
  - Likewise, all key signature annotation texts **must** have a corresponding key signature element placed in that measure, especially if
    there are standard accidentals (bb/b/#/x) in the key signature.

## Notation system

The plugin follows notation standards as per [NOTATION GUIDE FOR EDOS 5-72](http://tallkite.com/misc_files/notation%20guide%20for%20edos%205-72.pdf),
which is a generalized system for notating any EDO.

Here is a brief summary of the contents of the document:

### Tuning of nominals C D E F G A B

In this system, the nominals F C G D A E B are tuned according to a chain of **best fifths**,
which is the best representation of the perfect 3:2 just fifth that the EDO has to offer.\
The exact pitches of the notes are calculated based on the frequency of the reference note, which is defined by the
reference frequency selector, or A4: 440 Hz by default.

<details>
  <summary><em> How to calculate an EDO's best fifth? </em></summary>

  The number of steps a fifth is in x-edo = `round(x * log2(3/2))`

  `3/2` represents the frequency ratio of a fifth in just intonation.\
  `log2(3/2)` represents how many octaves are there in a fifth (approx 0.584962)\
  `x * log2(3/2)` represents how many steps of x-edo are there in a fifth\
  `round()` rounds it up/down to the nearest whole edostep.

</details>

The best fifth in 12 edo is 7 steps. Thus, the distance between F-C, C-G, G-D, etc.. is 7 steps of 12 edo.

The best fifth in 22 edo is 13 steps. Thus, the distance between C-G, etc.. is 13 steps of 22 edo.

### Tuning of regular pythagorean accidentals

![bb](images/bb.png) ![b](images/b.png) ![s](images/s.png) ![x](images/x.png)

The standard accidentals Double Flat (`bb`), Flat (`b`), Sharp (`#`), Double Sharp (`x`) are based on
the circle of fifths.

To give an example in 12-edo, going 7 fifths up from C4 yields C4-G4-D5-A5-E6-B6-F#7-C#8.\
A best fifth in 12-edo is 7 steps of 12 edo.\
Going up 7 fifths in 12-edo yields a total of 7*7 = 49 steps (which brings C4 to C#8)\
Going down 4 octaves to bring C#8 down to C#4 reduces the steps by 4 * 12 = 48 steps.\
Thus, a sharp symbol in 12-edo is defined as going up 49 steps, then down 48 steps, yielding a +1 step difference.

The number of edosteps a sharp symbol raises the pitch by is known as an EDO's **sharpness** value,
also known as the size of the **apotome**.\
Thus, the sharpness of 12-edo is 1, which classifies it as a **sharp-1** EDO.\
Consequently, a double sharp raises the pitch by 2 times of the sharpness value, thus 2 steps.\
A flat lowers the pitch by the sharpness value, thus lowering it by 1 step.\
A double flat lowers the pitch by 2 times of the sharpness value, thus lowering it by 2 steps.

To give another example in 23-edo:
A best fifth in 23-edo is 13 edosteps.\
Going up 7 fifths (From C4 to C#8) = going up 7 * 13 = 91 steps.\
Going down 4 octaves (From C#8 to C#4) = going down 4 * 23 = 92 steps.\
Thus, a sharp symbol in 23-edo is defined as going up 91 steps and down 92 steps, yielding a -1 step difference.\
A sharp symbol in 23-edo, surprisingly, __lowers__ the pitch by 1 step, instead of raising it.\
Consequently, the flat symbol raises the pitch by 1 step.\
The apotome size of 23-edo is -1, which classifies it as a **flat-1** EDO.

Note: in EDOs such as 7, 14 and 21, the sharp and flats do not raise nor lower the pitch, and thus
they are known as **perfect** EDOs, i.e. **Sharp-0**.

[Here is the full list of supported EDOs and their respective sharpness values.](#appendix-a-list-of-supported-edos-according-to-sharpness-classification)

The plugin only supports up to 2 flats and sharps. Triple flats and sharps and not supported as
MuseScore does not provide these accidentals.

### Tuning of up/down arrows

![sv3](images/sv3.png) ![u2](images/u2.png) ![bu1](images/bu1.png)

Arrows on the natural, sharp/flat, double sharp/flat accidentals offsets the pitch of the note by
the same number of steps of the EDO as there are arrows on the accidental.

An upwards arrow always raises the pitch by 1 step, regardless of whether the sharp symbol raises or lowers the pitch of the
note. Vice versa, a downwards arrow always lowers the pitch by 1 step.

Thus the interval between C and C^ is +1 step. And so is the interval between C# and C#^, Cbv and Cb, etc..

A maximum of 3 arrows are allowed on each accidental, as MuseScore currently does not provide accidentals
with more than 3 arrows. Due to these limitations, and with the help of quartertone accidentals, the plugin
can only handle EDOs with a sharpness rating of up to 8.

[Here is the full list of supported EDOs and their respective sharpness values.](#appendix-a-list-of-supported-edos-according-to-sharpness-classification)

The up/down arrow accidentals this plugin uses are Helmholtz-Ellis Just Intonation accidentals.\
Gould arrow quartertone symbols look very similar to the single up/down arrow Helmholtz-Ellis accidentals,
and may be used interchangeably, although the plugin defaults to Helmholtz-Ellis when transposing.
To differentiate the two, Gould arrow symbols appear slightly larger than the Helmholtz-Ellis ones.

### Tuning of quartertone (semisharp/semiflat) accidentals

![db](images/db.png) ![d](images/d.png) ![+](images/+.png) ![s+](images/s+.png)

Stein-Zimmermann quartertone accidentals represent an offset of half or one-and-a-half times of the standard sharpness
of the accidental. They only work when the EDO has an even-number sharpness rating which can be divided
by 2 evenly.

For example, in 31-edo, where the sharpness rating is sharp-2:
- ![db](images/db.png) lowers the pitch by 1.5 x 2 = -3 steps
- ![d](images/d.png) lowers the pitch by 0.5 x 2 = -1 step
- ![+](images/+.png) raises the pitch by 0.5 x 2 = +1 step
- ![s+](images/s+.png) raises the pitch by 1.5 x 2 = +3 steps


--------


## Key signatures

In order for the up/down step transposition feature to work properly,
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
5. Repeat from notes **C** thru **B**, in that order.

Natural accidentals are denoted by leaving the space blank, or using any other character
that does not represent an accidental.

**Examples:**
Ab-down major in 31 edo's ups-and-downs is written like this: `.v.bv.bv.v.v.bv.bv`\
representing the key signature of Cv, Dbv, Ebv, Fv, Gv, Abv, Bbv.

C major in 22 edo's ups-and-downs is written like this: `.0.0.v.0.0.v.v`\
representing the key signature of C, D, Ev, F, G, Av, Bv. (The `0`s represent placeholders,
you can also choose to put nothing between the dots)

> Note that explicit accidentals will still take precedence over the
> declared custom key signature, behaving exactly the same way a key signature
> would.

![Staff text custom key sig](images/key-sig-example.png)

### Accidental Code

| Accidental | Textual representation |
| ----: | :---- |
| ![Double flat down 3](images/bbv3.png)  | `bbv3` |
| ![Double flat down 2](images/bbv2.png)  | `bbv2` |
| ![Double flat down](images/bbv1.png)    | `bbv` or `bbv1` |
| ![Double flat](images/bb.png)           | `bb`   |
| ![Double flat up](images/bbu1.png)      | `bb^` or `bb^1` |
| ![Double flat up 2](images/bbu2.png)    | `bb^2` |
| ![Double flat up 3](images/bbu3.png)    | `bb^3` |
| ![Sesqui flat](images/db.png)           | `db` or `bd` |
| ![Flat down 3](images/bv3.png)          | `bv3`  |
| ![Flat down 2](images/bv2.png)          | `bv2`  |
| ![Flat down](images/bv1.png)            | `bv` or `bv1` |
| ![Flat](images/b.png)                   | `b`  |
| ![Flat up](images/bu1.png)              | `b^` or `b^1` |
| ![Flat up 2](images/bu2.png)            | `b^2` |
| ![Flat up 3](images/bu3.png)            | `b^3` |
| ![Down 3](images/v3.png)                | `v3` |
| ![Down 2](images/v2.png)                | `v2` |
| ![Down](images/v.png)                   | `v` or `v1` |
| ![Quarter flat](images/d.png)           | `d` |
| ![Natural](images/n.png)                | Leave blank / any other character  |
| ![Quarter sharp](images/+.png)          | `+` |
| ![Up](images/u1.png)                    | `^` or `^1` |
| ![Up2](images/u2.png)                   | `^2` |
| ![Up3](images/u3.png)                   | `^3` |
| ![Sharp down3](images/sv3.png)          | `#v3` |
| ![Sharp down2](images/sv2.png)          | `#v2` |
| ![Sharp down](images/sv1.png)           | `#v` or `#v1` |
| ![Sharp](images/s.png)                  | `#`  |
| ![Sharp up](images/su1.png)             | `#^` or `#^1` |
| ![Sharp up 2](images/su2.png)           | `#^2`  |
| ![Sharp up 3](images/su3.png)           | `#^3`  |
| ![Sesqui sharp](images/s+.png)          | `#+` or `+#` |
| ![Double sharp down](images/xv3.png)    | `xv3` |
| ![Double sharp down2](images/xv2.png)   | `xv2` |
| ![Double sharp down3](images/xv1.png)   | `xv` or `xv1` |
| ![Double sharp](images/x.png)           | `x` |
| ![Double sharp up](images/xu1.png)      | `x^` or `x^1` |
| ![Double sharp up 2](images/xu2.png)    | `x^2` |
| ![Double sharp up 3](images/xu3.png)    | `x^3` |


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

## Appendix A: List of supported EDOs according to sharpness classification.

| Sharpness (steps of an apotome) | EDOs |
| -------:  | :------- |
| flat-2 | 4, 11 |
| flat-1 | 2, 9, 16, 23 |
| perfect | 7, 14, 21, 28, 35 |
| sharp-1 | 5, 12, 19, 26, 33, 40, 47 |
| sharp-2 | 3, 10, 17, 24, 31, 38, 45, 52 |
| sharp-3 | 1, 8, 15, 22, 29, 36, 43, 50, 57, 64 |
| sharp-4 | 6, 13, 20, 27, 34, 41, 48, 55, 62, 69, 76 |
| sharp-5 | 18, 25, 32, 39, 46, 53, 60, 67, 74, 81, 88 |
| sharp-6 | 30, 37, 44, 51, 58, 65, 72, 79, 86, 93, 100 |
| sharp-7 | 42, 49, 56, 63, 70, 77, 84, 91, 98, 105 |
| sharp-8 | 54, 61, 68, 75, 82, 89, 96, 103, 110, 117 |

---------------

## Note to self / developers:

### IMPORTANT basic info on undocumented Plugin API mechanics!

CURSOR REWIND MECHANICS ARE WEIRD!
  - If rewinding to start of selection `cursor.rewind(1)`, set `cursor.staffIdx` and `cursor.voice` after
    `rewind(1)`.
  - If rewinding to start of score, IT IS STILL NECESSARY TO CALL `cursor.rewind(1)`, then set `staffIdx` and `voice`,
    THEN call `cursor.rewind(0)` AFTERWARDS. \
    Apparently, based on the (add courtesy accidentals)[https://github.com/heuchi/courtesyAccidentals/blob/master/addCourtesyAccidentals.qml#L160] plugin, `cursor.track` has to be set to 0 in order for `cursor.rewind(0)` to work.


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
Accidental.NONE                         (no explicit accidental)
Accidental.DOUBLE_SHARP_ONE_ARROW_UP          x^
Accidental.DOUBLE_SHARP_TWO_ARROWS_UP         x^2
Accidental.DOUBLE_SHARP_THREE_ARROWS_UP       x^3
Accidental.SHARP2                             x
Accidental.DOUBLE_SHARP_ONE_ARROW_DOWN        xv
Accidental.DOUBLE_SHARP_TWO_ARROWS_DOWN       xv2
Accidental.DOUBLE_SHARP_THREE_ARROWS_DOWN     xv3
Accidental.SHARP_SLASH4                       #+
Accidental.SHARP_ONE_ARROW_UP                 #^
Accidental.SHARP_TWO_ARROWS_UP                #^2
Accidental.SHARP_THREE_ARROWS_UP              #^3
Accidental.SHARP                              #
Accidental.SHARP_ONE_ARROW_DOWN               #v
Accidental.SHARP_TWO_ARROWS_DOWN              #v2
Accidental.SHARP_THREE_ARROWS_DOWN            #v3
Accidental.SHARP_SLASH                        +
Accidental.NATURAL_ONE_ARROW_UP               ^
Accidental.NATURAL_TWO_ARROWS_UP              ^2
Accidental.NATURAL_THREE_ARROWS_UP            ^3
Accidental.NATURAL                            natural
Accidental.NATURAL_ONE_ARROW_DOWN             v
Accidental.NATURAL_TWO_ARROWS_DOWN            v2
Accidental.NATURAL_THREE_ARROWS_DOWN          v3
Accidental.MIRRORED_FLAT                      d
Accidental.FLAT_ONE_ARROW_UP                  b^
Accidental.FLAT_TWO_ARROWS_UP                 b^2
Accidental.FLAT_THREE_ARROWS_UP               b^3
Accidental.FLAT                               b
Accidental.FLAT_ONE_ARROW_DOWN                bv
Accidental.FLAT_TWO_ARROWS_DOWN               bv2
Accidental.FLAT_THREE_ARROWS_DOWN             bv3
Accidental.MIRRORED_FLAT2                     db
Accidental.DOUBLE_FLAT_ONE_ARROW_UP           bb^
Accidental.DOUBLE_FLAT_TWO_ARROWS_UP          bb^2
Accidental.DOUBLE_FLAT_THREE_ARROWS_UP        bb^3
Accidental.FLAT2                              bb
Accidental.DOUBLE_FLAT_ONE_ARROW_DOWN         bbv
Accidental.DOUBLE_FLAT_TWO_ARROWS_DOWN        bbv2
Accidental.DOUBLE_FLAT_THREE_ARROWS_DOWN      bbv3
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
- Implement toggling between enharmonic equivalences
