import QtQuick 2.0
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import MuseScore 1.0

MuseScore {
      version:  "1.3"
      description: "Retune selection to 31-TET in Enharmonic Ups & Downs mode (Dbb is C), or whole score if nothing selected."
      menuPath: "Plugins.31-TET.Retune 31-TET (Enharmonic Ups & Downs)"

      // WARNING! This doesn't validate the accidental code!
      property variant customKeySigRegex: /\.(.*)\.(.*)\.(.*)\.(.*)\.(.*)\.(.*)\.(.*)/g

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
      function convertAccidentalToStepsOrNull(acc) {
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
          return null;
        }
      }

      // Takes in annotations[].text and returns either
      // a key signature object if str is a valid custom key sig code or null.
      //
      // Valid key sig code is denoted as such:
      //  .c.d.e.f.g.a.b
      // where identifiers c thru b denote a valid accidental code of which
      // will apply to the respective notes.
      //
      // For example, this is F-down major: .v.v.v.v.v.v.bv
      //
      // whitespace can be placed between dots and accidentals for readability.
      //
      // For the natural accidental, blank or whitespace will both work.
      //
      // Assign the key signature object to the parms.currKeySig field!
      function scanCustomKeySig(str) {
        str = str.trim();
        var keySig = {};
        var res = str.match(customKeySigRegex);
        // For code golfing
        var notes = [null, 'c', 'd', 'e', 'f', 'g', 'a', 'b'];

        if (res === null)
          return null;

        for (var i = 1; i <= 7; i++) {
          var acc = convertAccidentalToStepsOrNull(res[i].trim());
          if (acc !== null)
            keySig[notes[i]] = acc;
          else
            keySig[notes[i]] = 0;
        }

        return keySig;
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

            // After every track/voice, reset the currKeySig back to the original keySig

            parms.currKeySig = parms.keySig;
            console.log("currKeySig reset");

            // Loop elements of a voice
            while (cursor.segment && (fullScore || cursor.tick < endTick)) {
              // Reset accidentals if new measure.
              if (cursor.segment.tick == cursor.measure.firstSegment.tick) {
                parms.accidentals = {};
                measureCount ++;
                console.log("Reset accidentals - " + measureCount);
              }

              // Check for StaffText key signature changes.
              for (var i = 0, annotation = cursor.segment.annotations[i]; i < cursor.segment.annotations.length; i++) {
                var maybeKeySig = scanCustomKeySig(annotation.text);
                if (maybeKeySig !== null) {
                  parms.currKeySig = maybeKeySig;
                  console.log("detected new custom keySig: " + annotation.text);
                }
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
        if (parms.accidentals[note.line] !== undefined)
          stepsFromBaseNote = parms.accidentals[note.line];
        else // No prev accidentals. Use key signature instead.
          stepsFromBaseNote = parms.currKeySig[baseNote];

        console.log("Base Note: " + baseNote + ", diesis: " + stepsFromBaseNote);
        note.tuning = centOffsets[baseNote][stepsFromBaseNote];
        return;
      }

      onRun: {
        console.log("hello 31tet");

        if (typeof curScore === 'undefined')
              Qt.quit();

        var parms = {};

        /*
          key signature as denoted by the TextFields.

          THIS SHOULD BE READONLY!
        */
        parms.keySig = {
          'c': 0,
          'd': 0,
          'e': 0,
          'f': 0,
          'g': 0,
          'a': 0,
          'b': 0
        };

        /*
        Used for StaffText declared custom key signature.
        No worries about handling system text vs staff text as
        the annotation automatically applies appropriately.

        Will be reset to the original TextField denoted key signature
        at the start of each staff, although using both TextField
        and StaffText(22)/SystemText(21) methods of custom key sig
        entry is STRONGLY DISCOURAGED due to extreme unpredicatability.
        */
        parms.currKeySig = parms.keySig

        parms.accidentals = {};

        applyToNotesInSelection(tuneNote, parms);
        Qt.quit();
      }
}
