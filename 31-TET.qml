import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import MuseScore 1.0

MuseScore {
      version:  "1.1-alpha"
      description: "Retune selection to 31-TET, or whole score if nothing selected."
      menuPath: "Plugins.Notes.Retune 31-TET"
      pluginType: "dialog"
      width: 600
      height: 480

      property variant centOffsets: {
        'a': {
          '-5': 38.70967742 * -5 + 200, // Abb
          '-4': 38.70967742 * -4,       // Adb
          '-3': 38.70967742 * -3,       // Abv
          '-2': 38.70967742 * -2 + 100, // Ab
          '-1': 38.70967742 * -1,       // Av
           0: 38.70967742 * 0,         // A
           1: 38.70967742 * 1,         // A^
           2: 38.70967742 * 2 - 100,   // A#
           3: 38.70967742 * 3,         // A#^
           4: 38.70967742 * 4,         // A#+
           5: 38.70967742 * 5 - 200    // Ax
        },
        'b': {
          '-5': 38.70967742 * 0 - 200 + 200,
          '-4': 38.70967742 * 1 - 200,
          '-3': 38.70967742 * 2 - 200,
          '-2': 38.70967742 * 3 - 200 + 100,
          '-1': 38.70967742 * 4 - 200,
           0: 38.70967742 * 5 - 200,
           1: 38.70967742 * 6 - 200,
           2: 38.70967742 * 7 - 200 - 100,
           3: 38.70967742 * 8 - 200,
           4: 38.70967742 * 9 - 200,
           5: 38.70967742 * 10 - 200 - 200
        },
        'c': {
          '-5': 38.70967742 * 3 - 300 + 200,
          '-4': 38.70967742 * 4 - 300,
          '-3': 38.70967742 * 5 - 300,
          '-2': 38.70967742 * 6 - 300 + 100,
          '-1': 38.70967742 * 7 - 300,
           0: 38.70967742 * 8 - 300,
           1: 38.70967742 * 9 - 300,
           2: 38.70967742 * 10 - 300 - 100,
           3: 38.70967742 * 11 - 300,
           4: 38.70967742 * 12 - 300,
           5: 38.70967742 * 13 - 300 - 200
        },
        'd': {
          '-5': 38.70967742 * 8 - 500 + 200,
          '-4': 38.70967742 * 9 - 500,
          '-3': 38.70967742 * 10 - 500,
          '-2': 38.70967742 * 11 - 500 + 100,
          '-1': 38.70967742 * 12 - 500,
           0: 38.70967742 * 13 - 500,
           1: 38.70967742 * 14 - 500,
           2: 38.70967742 * 15 - 500 - 100,
           3: 38.70967742 * 16 - 500,
           4: 38.70967742 * 17 - 500,
           5: 38.70967742 * 18 - 500 - 200
        },
        'e': {
          '-5': 38.70967742 * 13 - 700 + 200,
          '-4': 38.70967742 * 14 - 700,
          '-3': 38.70967742 * 15 - 700,
          '-2': 38.70967742 * 16 - 700 + 100,
          '-1': 38.70967742 * 17 - 700,
           0: 38.70967742 * 18 - 700,
           1: 38.70967742 * 19 - 700,
           2: 38.70967742 * 20 - 700 - 100,
           3: 38.70967742 * 21 - 700,
           4: 38.70967742 * 22 - 700,
           5: 38.70967742 * 23 - 700 - 200
        },
        'f': {
          '-5': 38.70967742 * 16 - 800 + 200,
          '-4': 38.70967742 * 17 - 800,
          '-3': 38.70967742 * 18 - 800,
          '-2': 38.70967742 * 19 - 800 + 100,
          '-1': 38.70967742 * 20 - 800,
           0: 38.70967742 * 21 - 800,
           1: 38.70967742 * 22 - 800,
           2: 38.70967742 * 23 - 800 - 100,
           3: 38.70967742 * 24 - 800,
           4: 38.70967742 * 25 - 800,
           5: 38.70967742 * 26 - 800 - 200
        },
        'g': {
          '-5': 38.70967742 * 21 - 1000 + 200,
          '-4': 38.70967742 * 22 - 1000,
          '-3': 38.70967742 * 23 - 1000,
          '-2': 38.70967742 * 24 - 1000 + 100,
          '-1': 38.70967742 * 25 - 1000,
           0: 38.70967742 * 26 - 1000,
           1: 38.70967742 * 27 - 1000,
           2: 38.70967742 * 28 - 1000 - 100,
           3: 38.70967742 * 29 - 1000,
           4: 38.70967742 * 30 - 1000,
           5: 38.70967742 * 31 - 1000 - 200
        }
      }

      Rectangle {
          color: "white"
          anchors.fill: parent

          Text {
            text: "C"
            x: 50
            y: 15
          }

          TextField {
            id: c
            x: 80
            y: 10
            width: 80
            height: 30
          }

          Text {
            text: "D"
            x: 50
            y: 55
          }

          TextField {
            id: d
            x: 80
            y: 50
            width: 80
            height: 30
          }

          Text {
            text: "E"
            x: 50
            y: 95
          }

          TextField {
            id: e
            x: 80
            y: 90
            width: 80
            height: 30
          }

          Text {
            text: "F"
            x: 50
            y: 135
          }

          TextField {
            id: f
            x: 80
            y: 130
            width: 80
            height: 30
          }

          Text {
            text: "G"
            x: 50
            y: 175
          }

          TextField {
            id: g
            x: 80
            y: 170
            width: 80
            height: 30
          }

          Text {
            text: "A"
            x: 50
            y: 215
          }

          TextField {
            id: a
            x: 80
            y: 210
            width: 80
            height: 30
          }

          Text {
            text: "B"
            x: 50
            y: 255
          }

          TextField {
            id: b
            x: 80
            y: 250
            width: 80
            height: 30
          }

          Text {
            text: "Empty = natural"
            x: 250
            y: 10
          }
          Text {
            text: "'^', '#v' / 'v', 'b^' = 1 step up / down"
            x: 250
            y: 30
          }
          Text {
            text: "'#' / 'b' = 2 steps up / down"
            x: 250
            y: 50
          }
          Text {
            text: "'#^' / 'bv' = 3 steps up / down"
            x: 250
            y: 70
          }
          Text {
            text: "'#+' / 'db' = 4 steps up / down"
            x: 250
            y: 90
          }
          Text {
            text: "'x' / 'bb' = 5 steps up / down (why tho lol)"
            x: 250
            y: 110
          }
          Text {
            text: "Note: If there is a selection,\nthis plugin will only retune selected notes."
            x: 250
            y: 150
          }
          Text {
            text: "It's not necessary to enter the key signature into\nthe dialog only if a standard key signature is used."
            x: 250
            y: 230
          }

          Button {
            x: 250
            y: 400
            width: 140
            height: 60
            text: "Retune!"
            onClicked: {
              var parms = {};

              parms.keySig = {
                'c': convertAccidentalToSteps(c.text),
                'd': convertAccidentalToSteps(d.text),
                'e': convertAccidentalToSteps(e.text),
                'f': convertAccidentalToSteps(f.text),
                'g': convertAccidentalToSteps(g.text),
                'a': convertAccidentalToSteps(a.text),
                'b': convertAccidentalToSteps(b.text),
              };

              parms.accidentals = {};

              applyToNotesInSelection(tuneNote, parms);
              Qt.quit();
            }
          }
      }

      function convertAccidentalToSteps(acc) {
        switch(acc.trim()) {
        case 'bb':
          return -5;
        case 'db':
          return -4;
        case 'bv':
          return -3;
        case 'b':
          return -2;
        case 'v':
        case 'b^':
          return -1;
        case '':
          return 0;
        case '^':
        case '#v':
          return 1;
        case '#':
          return 2;
        case '#^':
          return 3;
        case '#+':
          return 4;
        case 'x':
          return 5;
        default:
          return 0;
        }
      }

      // Apply the given function to all notes in selection
      // or, if nothing is selected, in the entire score

      function applyToNotesInSelection(func, parms) {
        var cursor = curScore.newCursor();
        cursor.rewind(1);
        var startStaff;
        var endStaff;
        var endTick;
        var fullScore = false;
        if (!cursor.segment) { // no selection
          fullScore = true;
          startStaff = 0; // start with 1st staff
          endStaff = curScore.nstaves - 1; // and end with last
        } else {
          startStaff = cursor.staffIdx;
          cursor.rewind(2);
          if (cursor.tick == 0) {
            // this happens when the selection includes
            // the last measure of the score.
            // rewind(2) goes behind the last segment (where
            // there's none) and sets tick=0
            endTick = curScore.lastSegment.tick + 1;
          } else {
            endTick = cursor.tick;
          }
          endStaff = cursor.staffIdx;
        }
        console.log(startStaff + " - " + endStaff + " - " + endTick)
        // -------------- Actual thing here -----------------------


        for (var staff = startStaff; staff <= endStaff; staff++) {
          for (var voice = 0; voice < 4; voice++) {
            cursor.rewind(1); // sets voice to 0
            cursor.voice = voice; //voice has to be set after goTo
            cursor.staffIdx = staff;

            if (fullScore)
              cursor.rewind(0) // if no selection, beginning of score

            var measureCount = 0;

            // Loop elements of a voice
            while (cursor.segment && (fullScore || cursor.tick < endTick)) {
              // Reset accidentals if new measure.
              if (cursor.segment.tick == cursor.measure.firstSegment.tick) {
                parms.accidentals = {};
                measureCount ++;
                console.log("Reset accidentals - " + measureCount);
              }

              if (cursor.element) {

                if (cursor.element.type == Element.CHORD) {
                  var graceChords = cursor.element.graceNotes;
                  for (var i = 0; i < graceChords.length; i++) {
                    // iterate through all grace chords
                    var notes = graceChords[i].notes;
                    for (var j = 0; j < notes.length; j++)
                      func(notes[j], parms);
                  }
                  var notes = cursor.element.notes;
                  for (var i = 0; i < notes.length; i++) {
                    var note = notes[i];
                    func(note, parms);
                  }
                }
              }
              cursor.next();
            }
          }
        }
      }

      function tuneNote(note, parms) {
        var tpc = note.tpc;
        var acc = note.accidental;

        // If tpc is non-natural, there's no need to go through additional steps,
        // since accidentals and key sig are already taken into consideration
        // to produce a non-screw-up tpc.

        // However, if tpc is natural, it needs to be checked against acc and
        // the key signature to truly determine what note it is.

        /*
          ^   #v   v   b^       -> 1 diesis
          #        b            -> 2 diesis
          #^       bv           -> 3 diesis
          #+       db           -> 4 diesis
          x        bb           -> 5 diesis

          31-TET | TPC        |  ACC
            C    |  14 (C)    |  NONE               = C
                 |  19 (B)    |  SHARP_ARROW_UP     = B#^
                 |  2  (Dbb)  |  FLAT2              = Dbb
          ------------------------------------------------
            C^   |  14 (C)    |  NATURAL_ARROW_UP   = C^
                 |  14 (C)    |  SHARP_ARROW_DOWN   = C#v
                 |  19 (B)    |  SHARP_SLASH4       = B#+
                 |  16 (D)    |  MIRRORED_FLAT2     = Ddb
          ------------------------------------------------
            C#   |  21 (C#)   |  SHARP              = C#
                 |  33 (Bx)   |  SHARP2             = Bx
                 |  16 (D)    |  FLAT_ARROW_DOWN    = Dbv
          ------------------------------------------------
            Db   |  9  (Db)   |  FLAT               = Db
                 |  14 (C)    |  SHARP_ARROW_UP     = C#^
          ------------------------------------------------
            Dv   |  16 (D)    |  NATURAL_ARROW_DOWN = Dv
                 |  16 (D)    |  FLAT_ARROW_UP      = Db^
                 |  14 (C)    |  SHARP_SLASH4       = C#+
          ------------------------------------------------
            D    |  16 (D)    |  NONE               = D
                 |  28 (Cx)   |  SHARP2             = Cx
                 |  4  (Ebb)  |  FLAT2              = Ebb
          ------------------------------------------------
            D^   |  16 (D)    |  NATURAL_ARROW_UP   = D^
                 |  16 (D)    |  SHARP_ARROW_DOWN   = D#v
                 |  18 (E)    |  MIRRORED_FLAT2     = Edb
          ------------------------------------------------
            D#   |  23 (D#)   |  SHARP              = D#
                 |  18 (E)    |  FLAT_ARROW_DOWN    = Ebv
          ------------------------------------------------
            Eb   |  11 (Eb)   |  FLAT               = Eb
                 |  16 (D)    |  SHARP_ARROW_UP     = D#^
                 |  -1 (Fbb)  |  FLAT2              = Fbb
          ------------------------------------------------
            Ev   |  18 (E)    |  NATURAL_ARROW_DOWN = Ev
                 |  18 (E)    |  FLAT_ARROW_UP      = Eb^
                 |  16 (D)    |  SHARP_SLASH4       = D#+
                 |  13 (F)    |  MIRRORED_FLAT2     = Fdb
          ------------------------------------------------
            E    |  18 (E)    |  NONE               = E
                 |  30 (Dx)   |  SHARP2             = Dx
                 |  13 (F)    |  FLAT_ARROW_DOWN    = Fbv
          ------------------------------------------------
            E^   |  18 (E)    |  NATURAL_ARROW_UP   = E^
                 |  18 (E)    |  SHARP_ARROW_DOWN   = E#v
                 |  6  (Fb)   |  FLAT               = Fb
          ------------------------------------------------
            Fv   |  13 (F)    |  NATURAL_ARROW_DOWN = Fv
                 |  13 (F)    |  FLAT_ARROW_UP      = Fb^
                 |  25 (E#)   |  SHARP              = E#
          ------------------------------------------------
            F    |  13 (F)    |  NONE               = F
                 |  18 (E)    |  SHARP_ARROW_UP     = E#^
                 |  1  (Gbb)  |  FLAT2              = Gbb
          ------------------------------------------------
            F^   |  13 (F)    |  NATURAL_ARROW_UP   = F^
                 |  13 (F)    |  SHARP_ARROW_DOWN   = F#v
                 |  18 (E)    |  SHARP_SLASH4       = E#+
                 |  15 (G)    |  MIRRORED_FLAT2     = Gdb
          ------------------------------------------------
            F#   |  20 (F#)   |  SHARP              = F#
                 |  32 (Ex)   |  SHARP2             = Ex
                 |  15 (G)    |  FLAT_ARROW_DOWN    = Gbv
          ------------------------------------------------
            Gb   |  8  (Gb)   |  FLAT               = Gb
                 |  13 (F)    |  SHARP_ARROW_UP     = F#^
          ------------------------------------------------
            Gv   |  15 (G)    |  NATURAL_ARROW_DOWN = Gv
                 |  15 (G)    |  FLAT_ARROW_UP      = Gb^
                 |  13 (F)    |  SHARP_SLASH4       = F#+
          ------------------------------------------------
            G    |  15 (G)    |  NONE               = G
                 |  27 (Fx)   |  SHARP2             = Fx
                 |  3  (Abb)  |  FLAT2              = Abb
          ------------------------------------------------
            G^   |  15 (G)    |  NATURAL_ARROW_UP   = G^
                 |  15 (G)    |  SHARP_ARROW_DOWN   = G#v
                 |  17 (A)    |  MIRRORED_FLAT2     = Adb
          ------------------------------------------------
            G#   |  22 (G#)   |  SHARP              = G#
                 |  17 (A)    |  FLAT_ARROW_DOWN    = Abv
          ------------------------------------------------
            Ab   |  10 (Ab)   |  FLAT               = Ab
                 |  15 (G)    |  SHARP_ARROW_UP     = G#^
          ------------------------------------------------
            Av   |  17 (A)    |  NATURAL_ARROW_DOWN = Av
                 |  17 (A)    |  FLAT_ARROW_UP      = Ab^
                 |  15 (G)    |  SHARP_SLASH4       = G#+
          ------------------------------------------------
            A    |  17 (A)    |  NONE               = A
                 |  29 (Gx)   |  SHARP2             = Gx
                 |  5  (Bbb)  |  FLAT2              = Bbb
          ------------------------------------------------
            A^   |  17 (A)    |  NATURAL_ARROW_UP   = A^
                 |  17 (A)    |  SHARP_ARROW_DOWN   = A#v
                 |  19 (B)    |  MIRRORED_FLAT2     = Bdb
          ------------------------------------------------
            A#   |  24 (A#)   |  SHARP              = A#
                 |  19 (B)    |  FLAT_ARROW_DOWN    = Bbv
          ------------------------------------------------
            Bb   |  12 (Bb)   |  FLAT               = Bb
                 |  17 (A)    |  SHARP_ARROW_UP     = A#^
                 |  0  (Cbb)  |  FLAT2              = Cbb
          ------------------------------------------------
            Bv   |  19 (B)    |  NATURAL_ARROW_DOWN = Bv
                 |  19 (B)    |  FLAT_ARROW_UP      = Bb^
                 |  17 (A)    |  SHARP_SLASH4       = A#+
                 |  14 (C)    |  MIRRORED_FLAT2     = Cdb
          ------------------------------------------------
            B    |  19 (B)    |  NONE               = B
                 |  31 (Ax)   |  SHARP2             = Ax
                 |  14 (C)    |  FLAT_ARROW_DOWN    = Cbv
          ------------------------------------------------
            B^   |  19 (B)    |  NATURAL_ARROW_UP   = B^
                 |  19 (B)    |  SHARP_ARROW_DOWN   = B#v
                 |  7  (Cb)   |  FLAT               = Cb
          ------------------------------------------------
            Cv   |  14 (C)    |  NATURAL_ARROW_DOWN = Cv
                 |  14 (C)    |  FLAT_ARROW_UP      = Cb^
                 |  26 (B#)   |  SHARP              = B#
        */

        switch(tpc) {
        case -1: //Fbb
          note.tuning = centOffsets['f'][-5];
          return;
        case 0: //Cbb
          note.tuning = centOffsets['c'][-5];
          return;
        case 1: //Gbb
          note.tuning = centOffsets['g'][-5];
          return;
        case 2: //Dbb
          note.tuning = centOffsets['d'][-5];
          return;
        case 3: //Abb
          note.tuning = centOffsets['a'][-5];
          return;
        case 4: //Ebb
          note.tuning = centOffsets['e'][-5];
          return;
        case 5: //Bbb
          note.tuning = centOffsets['b'][-5];
          return;

        case 6: //Fb
          note.tuning = centOffsets['f'][-2];
          return;
        case 7: //Cb
          note.tuning = centOffsets['c'][-2];
          return;
        case 8: //Gb
          note.tuning = centOffsets['g'][-2];
          return;
        case 9: //Db
          note.tuning = centOffsets['d'][-2];
          return;
        case 10: //Ab
          note.tuning = centOffsets['a'][-2];
          return;
        case 11: //Eb
          note.tuning = centOffsets['e'][-2];
          return;
        case 12: //Bb
          note.tuning = centOffsets['b'][-2];
          return;

        case 20: //F#
          note.tuning = centOffsets['f'][2];
          return;
        case 21: //C#
          note.tuning = centOffsets['c'][2];
          return;
        case 22: //G#
          note.tuning = centOffsets['g'][2];
          return;
        case 23: //D#
          note.tuning = centOffsets['d'][2];
          return;
        case 24: //A#
          note.tuning = centOffsets['a'][2];
          return;
        case 25: //E#
          note.tuning = centOffsets['e'][2];
          return;
        case 26: //B#
          note.tuning = centOffsets['b'][2];
          return;

        case 27: //Fx
          note.tuning = centOffsets['f'][5];
          return;
        case 28: //Cx
          note.tuning = centOffsets['c'][5];
          return;
        case 29: //Gx
          note.tuning = centOffsets['g'][5];
          return;
        case 30: //Dx
          note.tuning = centOffsets['d'][5];
          return;
        case 31: //Ax
          note.tuning = centOffsets['a'][5];
          return;
        case 32: //Ex
          note.tuning = centOffsets['e'][5];
          return;
        case 33: //Bx
          note.tuning = centOffsets['b'][5];
          return;
        }

        // in the event that tpc is considered natural by
        // MuseScore's playback, it would mean that it is
        // either a natural note, or a microtonal accidental.

        var baseNote;
        switch(tpc) {
        case 13:
          baseNote = 'f';
          break;
        case 14:
          baseNote = 'c';
          break;
        case 15:
          baseNote = 'g';
          break;
        case 16:
          baseNote = 'd';
          break;
        case 17:
          baseNote = 'a';
          break;
        case 18:
          baseNote = 'e';
          break;
        case 19:
          baseNote = 'b';
          break;
        }
        //NOTE: Only special accidentals need to be remembered.
        if (note.accidental) {
          console.log('Note: ' + baseNote + ', Line: ' + note.line + ', Special Accidental: ' + note.accidental);
          if (note.accidental.accType == Accidental.MIRRORED_FLAT2)
            parms.accidentals[note.line] = -4;
          else if (note.accidental.accType == Accidental.FLAT_ARROW_DOWN)
            parms.accidentals[note.line] = -3;
          else if (note.accidental.accType == Accidental.NATURAL_ARROW_DOWN ||
                   note.accidental.accType == Accidental.FLAT_ARROW_UP)
            parms.accidentals[note.line] = -1;
          else if (note.accidental.accType == Accidental.NATURAL)
            parms.accidentals[note.line] = 0;
          else if (note.accidental.accType == Accidental.NATURAL_ARROW_UP ||
                   note.accidental.accType == Accidental.SHARP_ARROW_DOWN)
            parms.accidentals[note.line] = 1;
          else if (note.accidental.accType == Accidental.SHARP_ARROW_UP)
            parms.accidentals[note.line] = 3;
          else if (note.accidental.accType == Accidental.SHARP_SLASH4)
            parms.accidentals[note.line] = 4;
        }
        // Check for prev accidentals first
        var stepsFromBaseNote;
        if (parms.accidentals[note.line])
        stepsFromBaseNote = parms.accidentals[note.line];
        else // No prev accidentals. Use key signature instead.
        stepsFromBaseNote = parms.keySig[baseNote];

        console.log("Base Note: " + baseNote + ", diesis: " + stepsFromBaseNote);
        note.tuning = centOffsets[baseNote][stepsFromBaseNote];
        return;
      }

      onRun: {
        console.log("hello 31tet");

        if (typeof curScore === 'undefined')
              Qt.quit();
      }
}
