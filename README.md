# 31/22 EDO Retuner plugin for Musescore 2 / 3

Musescore plugin to automatically retune notes in [31-EDO](https://en.wikipedia.org/wiki/31_equal_temperament)
and [22-edo](https://en.wikipedia.org/wiki/22_equal_temperament)

## Usage

Download the QML files and put them in the plugins folder.

To retune the entire score as is, run the plugin located in Plugins > 31-TET / 22-TET.

To only retune selected notes, make a selection before running the plugin.

--------

### Accidentals (31 edo)

#### Ups and Downs notation (diatonic enharmonic equivalent)

> Plugin file:
> https://github.com/euwbah/musescore-n-tet-plugins/blob/master/31-TET.qml

In ups and downs notation mode, these are the accidentals used by the
plugin. They can be found in the [advanced palette](https://musescore.org/en/handbook/palettes-and-workspaces#workspaces).

| Diesis steps | Accidental |
| ---: | :-----:|
| -5  | ![Double flat](images/bb.png) |
| -4  | ![Sesqui flat](images/db.png)  |
| -3  | ![Flat down](images/bd.png)  |
| -2  | ![Flat](images/b.png)  |
| -1  | ![Down](images/d.png) or ![Flat up](images/bu.png) |
| 0   | ![Natural](images/n.png) |
| +1  | ![Up](images/u.png) or ![Sharp down](images/sd.png) |
| +2  | ![Sharp](images/s.png)  |
| +3  | ![Sharp up](images/su.png) |
| +4  | ![Sesqui sharp](images/ss.png)  |
| +5  | ![Double sharp](images/x.png)  |

> Important: This notation differs from the more conventional meantone notation
> which uses quarter-tone accidentals instead.
>
> The benefits of using this notation over meantone is that it allows for proper
> spelling of notes and chords in all 31 keys as it still supports enharmonic diatonic-tone equivalents
> by means of the double flat and double sharp accidentals.

#### 1/4-comma meantone approximation (quarter-tone accidentals)

> Plugin file:
> https://github.com/euwbah/musescore-n-tet-plugins/blob/master/31-TET-Meantone.qml

When using the meantone version of the plugin, these are the accidentals used by the plugin.

| Diesis steps | Accidental |
| ---: | :-----:|
| -4  | ![Double flat](images/bb.png) |
| -3  | ![Sesqui flat](images/db.png)  |
| -2  | ![Flat](images/b.png)  |
| -1  | ![Down](images/d-quarter.png) |
| 0   | ![Natural](images/n.png) |
| +1  | ![Up](images/+.png) |
| +2  | ![Sharp](images/s.png)  |
| +3  | ![Sesqui sharp](images/ss.png)  |
| +4  | ![Double sharp](images/x.png)  |

### Accidentals (22 edo)

#### Superpyth Ups and Downs

> Plugin file:
> https://github.com/euwbah/musescore-n-tet-plugins/blob/master/22-TET.qml

Natural notes in this system are based off the chain of fifths F-C-G-D-A-E-B.
Each fifth is 13 steps of 22 edo (about 709 cents).
The distance between B-C and E-F is 1 step of 22 edo (about 54.5 cents)

| Diesis steps | Accidental |
| ---: | :-----:|
| -4  | ![Flat down](images/bd.png) (double flats are also -4 for simplicity's sake)  |
| -3  | ![Flat](images/b.png)  |
| -2  | ![Flat up](images/bu.png)  |
| -1  | ![Down](images/d.png) |
| 0   | ![Natural](images/n.png) |
| +1  | ![Up](images/u.png) |
| +2  | ![Sharp down](images/sd.png)  |
| +3  | ![Sharp](images/s.png) |
| +4  | ![Sharp up](images/su.png) (double sharps are also +4 for simplicity's sake) |

### Custom key signatures

As MuseScore doesn't completely support
[custom key signatures](https://musescore.org/en/handbook/key-signatures#custom-key-signatures),
any custom key signature can't be read by the plugin, at least for now.

Should you want to create a microtonal key signature and have it affect the
playback, you have to explicitly declare the custom key signature using
system/staff text containing accidental code:

> Note that explicit accidentals will still take precedence over the
> declared custom key signature, behaving exactly the same way a key signature
> would.

#### Accidental Code

| Accidental | Textual representation |
| ----: | :----: |
| ![Flat down](images/bb.png) | `bb` |
| ![Sesqui flat](images/db.png) | `db`  |
| ![Flat down](images/bd.png) | `bv`  |
| ![Flat](images/b.png)   | `b`  |
| ![Flat up](images/bu.png)   | `b^` |
| ![Down](images/d.png)   | `v` |
| ![Natural](images/n.png) | Leave blank / any other character  |
| ![Up](images/u.png) | `^` |
| ![Sharp down](images/sd.png) | `#v` |
| ![Sharp](images/s.png) | `#`  |
| ![Sharp up](images/su.png) | `#^`  |
| ![Sesqui sharp](images/ss.png) | `#+`  |
| ![Double sharp](images/x.png) | `x`  |

![Staff text custom key sig](images/2018/06/staff-text-custom-key-sig.png)

You can indicate custom key signatures by entering the key signature using
System Text or Staff Text.

- Use **System Text** (`Ctrl` + `Shift` + `T`) if you want the key signature code to affect
  all staves from there onwards
- Use **Staff Text** (`Shift` + `T`) if you only want the code to affect the staff that it is on.
  This is especially useful when using custom **local** key signatures!
- Remember to make the custom key signature code invisible! (Press `V` to toggle visibility)

Key signature code syntax:

1. Start with a dot `.`
2. Put the textual representation of the accidental for the note **C** using the [accidental code](#accidental-code)
3. Put another dot `.`
4. Put the required accidental for **D**
5. Repeat from **C** thru **B**

Note that There **must** be seven `.` in total,
natural accidentals are denoted by leaving the space blank, or using any other character
that does not represent an accidental.

Spaces/newlines can be placed before or after the dots to improve readability.

**For example:**
Ab-down major in ups-and-downs mode can be denoted like this: `.v.bv.bv.v.v.bv.bv`
representing the key signature of Cv, Dbv, Ebv, Fv, Gv, Abv, Bbv.

**IMPORTANT!** Following a custom key signature, should there be a modulation to any standard
key signature, it is still necessary to reset the custom key signature to the default, that is,
`.......`. Otherwise, the previous custom key signature would still be in effect, as it is being
overridden. Regular and custom key signatures are not compatible with each other.


### Note to self / developers:

##### Definitions:

`tpc`
: Tonal pitch class

`segment.annotations[idx].textStyleType`
: 22 if Staff Text,
: 21 if System Text

`segment.annotations[idx].text`
: Contains given text

## TODO:

- Handle cross-staff notation (ctrl + shift + up/down in connected staves, e.g. grand staff) where note appears to be in another staff
  other than the cursor's staffIdx. Currently, accidentals in the cross-staff do not work on the notes that came from another staff.
  See Add Courtesy Accidentals plugin for how to do this
- Implement porcupine notation for 22-edo (D-E-F-G-A-B-C-D = sssLsss)
- Implement +/- 1 step transposition
- Implement toggling between enharmonic equivalences
- Don't hard-code frequencies, just use a dictionary of exponential operations instead

## Changes:

### 1.3.5
- Added 22-edo superpyth version.
- Fixed custom key signatures not affecting other voices (even system text)
- Fixed accidentals on notes of higher voices not affecting lower voices
- Fixed custom key signatures with standard sharp/flat accidentals incorrectly
  accounting for +/- 100/200 cents accidental playback when MuseScore doesn't
  recognize them.

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
