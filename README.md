# 31 EDO Retuner plugin for Musescore 2

Musescore plugin to automatically retune notes in [31-EDO](https://en.wikipedia.org/wiki/31_equal_temperament)

## Usage

- To retune the entire score as is, run the plugin located in Plugins > 31-TET > Retune 31-TET

- Depending on the type of notation you prefer, you may use the QML scripts for 
  [ups-and-downs notation](https://github.com/euwbah/musescore-31-tet-plugin/blob/master/31-TET.qml) 
  or the [quartertone-accidental 1/4-comma meantone approximation notation](https://github.com/euwbah/musescore-31-tet-plugin/blob/master/31-TET-Meantone.qml) modes

- To only retune certain notes / parts, make a selection before running the plugin.

### Accidentals

#### Ups and Downs notation (diatonic enharmonic equivalent)

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
> which uses quarter-tone accidentals instead. Meantone notation support is still a WIP.
>
> The benefits of using this notation over meantone is that it allows for proper
> spelling of notes and chords in all transpositions as it still supports enharmonic diatonic-tone equivalents
> by means of the double flat and double sharp accidentals.

#### 1/4-comma meantone approximation (quarter-tone accidentals)

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

### Custom key signatures

As MuseScore doesn't completely support
[custom key signatures](https://musescore.org/en/handbook/key-signatures#custom-key-signatures),
any custom key signature can't be read by the plugin, at least for now.

Should you want to create a microtonal key signature and have it affect the
playback, you have to explicitly declare the custom key signature using some
accidental code:

> Note that explicit accidentals will still take precedence over the
> declared custom key signature, behaving exactly the same way a key signature
> would.

#### Accidental Code

| Diesis steps | accidental code (Ups-and-downs) | accidental code (1/4-comma meantone approximation) |
| ----: | :----: | :----: |
| -5   | `bb` | None |
| -4   | `db`  | `bb` |
| -3   | `bv`  | `db` |
| -2   | `b`  | `b` |
| -1   | `b^` or `v`| `d` |
| 0  | Leave blank  | Leave blank |
| 1   | `^` or `#v` | `+` |
| 2  | `#`  | `#` |
| 3   | `#^`  | `#+` |
| 4  | `#+`  | `x` |
| 5   |  `x` | None |

![Staff text custom key sig](images/2018/06/staff-text-custom-key-sig.png)

You can indicate custom key signatures in the score itself
by entering *super-special key signature code* inside
System Text or Staff Text.

- Use **System Text** (`Ctrl` + `Shift` + `T`) if you want the super-special key signature code to affect
  all staves from there onwards
- Use **Staff Text** (`Shift` + `T`) if you only want the code to affect the staff that it is on.
  This is especially useful when using custom **local** time signatures!
- Remember to make the custom key signature code invisible! (Press `V` to toggle visibility)

The syntax of this *super-special key signature code* is simple:

1. Start with a dot `.`
2. Put the required accidental for the note **C** using the [accidental code](#accidental-code)
3. Put another dot `.`
4. Put the required accidental for **D**
5. Repeat from **C** thru **B**

Note that There **must** be seven `.` in total,
natural accidentals are denoted by leaving the space blank,
and spaces/newlines can be placed before or after the dots to improve readability.

**For example:**
Ab-down major in ups-and-downs mode can be denoted like this: `.v.bv.bv.v.v.bv.bv`
representing the key signature of Cv, Dbv, Ebv, Fv, Gv, Abv, Bbv.

**IMPORTANT!** Following a custom key signature, should there be a modulation to any standard
key signature, it is still necessary to reset the custom key signature to the default, that is,
`.......`. Otherwise, the previous custom key signature would still be in effect, as it is being
overriden.


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

- Meantone mode
- Transpose Diesis up/down for both enharmonic up-and-downs mode and meantone mode
- Enharmonic equivalent switching for enharmonic up-and-downs mode (e.g. Cv = B# and C = B#^ = Dbb)
- Don't hard-code / bruteforce frequencies, just use a dictionary of exponential operations instead

## Changes:

### 1.3

- Removed unecessary GUI dialog --- planning to make a 31-TET suite that works off key macros to
  improve workflow.
- Added meantone mode

### 1.2

- Fixed non-naturalised explicit natural accidental in note affected by a custom key signature
- Added support for declaring custom key signature changes in SystemText/StaffText
- Added usage guide in this file
- Preparing for meantone quartertone-accidental mode support

### 1.1

- Fixed occassional bug where microtonal accidentals carry over the bar line when it shouldn't
- Attempted to fix UI bug in Windows, haven't tested it yet though :/
