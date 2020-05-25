import QtQuick 2.1
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import MuseScore 3.0

MuseScore {
      version:  "1.3.7"
      description: "Retune selection to 22-TET in Superpyth ups and downs mode, or whole score if nothing selected."
      menuPath: "Plugins.22-TET.Retune 22-TET (Superpyth Ups/Downs)"

      // WARNING! This doesn't validate the accidental code!
      property variant customKeySigRegex: /\.(.*)\.(.*)\.(.*)\.(.*)\.(.*)\.(.*)\.(.*)/g

      property variant centOffsets: {
        'a': {
          '-5': 54.5454545454 * -4 + 200, // Abb (enharmonical equivalent of Abv, but needs to be handled diff cuz tpc is G)
          '-4': 54.5454545454 * -4,       // Abv
          '-3': 54.5454545454 * -3 + 100, // Ab
          '-2': 54.5454545454 * -2,       // Ab^
          '-1': 54.5454545454 * -1,       // Av
           0: 54.5454545454 * 0,          // A
           1: 54.5454545454 * 1,          // A^
           2: 54.5454545454 * 2,          // A#v
           3: 54.5454545454 * 3 - 100,    // A#
           4: 54.5454545454 * 4,          // A#^ (Ax will be handled as C)
           5: 54.5454545454 * 4 - 200     // Ax (enh eq. of A#v, but tpc is B)
        },
        'b': {
          '-5': 54.5454545454 * 0 - 200 + 200,
          '-4': 54.5454545454 * 0 - 200,
          '-3': 54.5454545454 * 1 - 200 + 100,
          '-2': 54.5454545454 * 2 - 200,
          '-1': 54.5454545454 * 3 - 200,
           0: 54.5454545454 * 4 - 200,
           1: 54.5454545454 * 5 - 200,
           2: 54.5454545454 * 6 - 200,
           3: 54.5454545454 * 7 - 200 - 100,
           4: 54.5454545454 * 8 - 200,
           5: 54.5454545454 * 8 - 200 - 200
        },
        'c': {
          '-5': 54.5454545454 * 1 - 300 + 200,
          '-4': 54.5454545454 * 1 - 300,
          '-3': 54.5454545454 * 2 - 300 + 100,
          '-2': 54.5454545454 * 3 - 300,
          '-1': 54.5454545454 * 4 - 300,
           0: 54.5454545454 * 5 - 300,
           1: 54.5454545454 * 6 - 300,
           2: 54.5454545454 * 7 - 300,
           3: 54.5454545454 * 8 - 300 - 100,
           4: 54.5454545454 * 9 - 300,
           5: 54.5454545454 * 10 - 300 - 200
        },
        'd': {
          '-5': 54.5454545454 * 5 - 500 + 200,
          '-4': 54.5454545454 * 5 - 500,
          '-3': 54.5454545454 * 6 - 500 + 100,
          '-2': 54.5454545454 * 7 - 500,
          '-1': 54.5454545454 * 8 - 500,
           0: 54.5454545454 * 9 - 500,
           1: 54.5454545454 * 10 - 500,
           2: 54.5454545454 * 11 - 500,
           3: 54.5454545454 * 12 - 500 - 100,
           4: 54.5454545454 * 13 - 500,
           5: 54.5454545454 * 14 - 500 - 200
        },
        'e': {
          '-5': 54.5454545454 * 9 - 700 + 200,
          '-4': 54.5454545454 * 9 - 700,
          '-3': 54.5454545454 * 10 - 700 + 100,
          '-2': 54.5454545454 * 11 - 700,
          '-1': 54.5454545454 * 12 - 700,
           0: 54.5454545454 * 13 - 700,
           1: 54.5454545454 * 14 - 700,
           2: 54.5454545454 * 15 - 700,
           3: 54.5454545454 * 16 - 700 - 100,
           4: 54.5454545454 * 17 - 700,
           5: 54.5454545454 * 17 - 700 - 200
        },
        'f': {
          '-5': 54.5454545454 * 10 - 800 + 200,
          '-4': 54.5454545454 * 10 - 800,
          '-3': 54.5454545454 * 11 - 800 + 100,
          '-2': 54.5454545454 * 12 - 800,
          '-1': 54.5454545454 * 13 - 800,
           0: 54.5454545454 * 14 - 800,
           1: 54.5454545454 * 15 - 800,
           2: 54.5454545454 * 16 - 800,
           3: 54.5454545454 * 17 - 800 - 100,
           4: 54.5454545454 * 18 - 800,
           5: 54.5454545454 * 18 - 800 - 200
        },
        'g': {
          '-5': 54.5454545454 * 14 - 1000 + 200,
          '-4': 54.5454545454 * 14 - 1000,
          '-3': 54.5454545454 * 15 - 1000 + 100,
          '-2': 54.5454545454 * 16 - 1000,
          '-1': 54.5454545454 * 17 - 1000,
           0: 54.5454545454 * 18 - 1000,
           1: 54.5454545454 * 19 - 1000,
           2: 54.5454545454 * 20 - 1000,
           3: 54.5454545454 * 21 - 1000 - 100,
           4: 54.5454545454 * 22 - 1000,
           5: 54.5454545454 * 22 - 1000 - 200
        }
      }

      function convertAccidentalToStepsOrNull(acc) {
        switch(acc.trim()) {
        case 'bb':
        case 'bv':
          return -4;
        case 'b':
          return -3;
        case 'b^':
          return -2;
        case 'v':
          return -1;
        case '':
          return 0;
        case '^':
          return 1;
        case '#v':
          return 2;
        case '#':
          return 3;
        case '#^':
        case 'x':
          return 4;
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
        console.log(typeof(str));
        if (typeof(str) !== 'string')
          return null;
        str = str.trim();
        var keySig = {};
        var res = str.match(customKeySigRegex);
        // For code golfing
        var notes = [null, 'c', 'd', 'e', 'f', 'g', 'a', 'b'];

        if (res === null)
          return null;

        for (var i = 1; i <= 7; i++) {
          console.log(res[i]);
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
        console.log(startStaff + " - " + endStaff + " - " + endTick + ', fullscore: '+ fullScore);
        // -------------- Actual thing here -----------------------


        for (var staff = startStaff; staff <= endStaff; staff++) {

          // Reset accidentals at the start of every staff.
          parms.accidentals = {};

          // After every staff, reset the currKeySig back to the original keySig

          parms.currKeySig = parms.keySig;

          // Even if system text is used for key sig, the text
          // won't carry over for all voices (if the text was placed on voice 1, only
          // voice 1 will see the text)
          //
          // Therefore, all the diff custom key sig texts across all 4 voices
          // need to be aggregated into this array before the notes can be
          // tuned.
          var staffKeySigHistory = [];

          // initial run to populate custom key signatures
          for (var voice = 0; voice < 4; voice++) {
            cursor.rewind(1); // goes to start of selection, will reset voice to 0
            cursor.voice = voice;
            cursor.staffIdx = staff;
            cursor.rewind(0);

            var measureCount = 0;
            console.log("processing custom key signatures staff: " + cursor.staffIdx + ", voice: " + cursor.voice);

            while (true) {
              if (cursor.segment) {
                // Check for StaffText key signature changes, then update staffKeySigHistory
                for (var i = 0; i < cursor.segment.annotations.length; i++) {
                  var annotation = cursor.segment.annotations[i];
                  console.log("found annotation type: " + annotation.subtypeName() + ", text: " + annotation.text);
                  var maybeKeySig = scanCustomKeySig(annotation.text);
                  console.log('maybekeysig: ' + maybeKeySig);
                  if (maybeKeySig !== null) {
                    console.log("detected new custom keySig: " + annotation.text + ", staff: " + staff + ", voice: " + voice);
                    staffKeySigHistory.push({
                      tick: cursor.tick,
                      keySig: maybeKeySig
                    });
                  }
                }

                if (cursor.segment.tick == cursor.measure.firstSegment.tick && voice === 0) {
                  // once new bar is reached, denote new bar in the parms.accidentals.bars object
                  // so that getAccidental will reset. Only do this for the first voice in a staff
                  // since voices in a staff shares the same barrings.

                  console.log("New bar - " + measureCount);

                  if (!parms.accidentals.bars)
                    parms.accidentals.bars = [];

                  parms.accidentals.bars.push(cursor.segment.tick);
                  measureCount ++;
                }
              }

              if (!cursor.next())
                break;
            }
          }

          // 2 passes - one to ensure all accidentals are represented acorss
          // all 4 voices, then the second one to apply those accidentals.
          for (var rep = 0; rep < 2; rep++) {
            for (var voice = 0; voice < 4; voice++) {


              cursor.rewind(1);
              cursor.voice = voice; //voice has to be set after goTo
              cursor.staffIdx = staff;
              if (rep == 0 || fullScore)
                cursor.rewind(0);

              var measureCount = 0;

              console.log("processing staff: " + cursor.staffIdx + ", rep: " + rep + ", voice: " + cursor.voice, ', tick: ' + cursor.tick);
              console.log('init cursor.segment: ' + cursor.segment);
              // Loop elements of a voice
              while (cursor.segment && (fullScore || cursor.tick < endTick)) {
                // Note that the parms.accidentals object now stores accidentals
                // from all 4 voices in a staff since microtonal accidentals from one voice
                // should affect subsequent notes on the same line in other voices as well.


                for (var i = 0; i < staffKeySigHistory.length; i++) {
                  var keySig = staffKeySigHistory[i];
                  if (keySig.tick <= cursor.tick)
                    parms.currKeySig = keySig.keySig;
                }

                if (cursor.element) {
                  if (cursor.element.type == Ms.CHORD) {
                    var graceChords = cursor.element.graceNotes;
                    for (var i = 0; i < graceChords.length; i++) {
                      // iterate through all grace chords
                      var notes = graceChords[i].notes;
                      for (var j = 0; j < notes.length; j++)
                        func(notes[j], cursor.segment, parms, rep == 0);
                    }
                    var notes = cursor.element.notes;
                    for (var i = 0; i < notes.length; i++) {
                      var note = notes[i];
                      func(note, cursor.segment, parms, rep == 0);
                    }
                  }
                }
                cursor.next();
              }
            }
          }
        }
      }

      // This will register an accidental's offset value and tick position.
      // Unified accidental registry is necessary so that special accidentals across
      // different voices in the same staff will affect each other as it should.
      //
      // Only microtonal accidentals need to be registered. Musescore properly handles
      // normal accidentals with TPCs.
      //
      // Remember to reset the parms.accidentals array after every bar & staff!
      function registerAccidental(noteLine, tick, diesisOffset, parms) {
        if (!parms.accidentals[noteLine]) {
          parms.accidentals[noteLine] = [];
        }

        parms.accidentals[noteLine].push({
          tick: tick,
          offset: diesisOffset
        });
      }

      // Returns the diesis offset if a prior microtonal accidental exists
      // before or at the given tick value.
      // Null if there are no explicit microtonal accidentals
      // WARNING: DON'T USE !getAccidental() to check for Null because !0 IS TRUE!
      function getAccidental(noteLine, tick, parms) {
        // Tick of the most recent measure just before current tick
        var mostRecentBar = 0;

        for (var i = 0; i < parms.accidentals.bars.length; i++) {
          var barTick = parms.accidentals.bars[i];

          if (barTick > mostRecentBar && barTick <= tick) {
            mostRecentBar = barTick;
          }
        }

        var oldTick = -1;
        var offset = null;

        if (!parms.accidentals[noteLine])
          return null;

        for (var i = 0; i < parms.accidentals[noteLine].length; i++) {
          var acc = parms.accidentals[noteLine][i];

          // Accidentals only count if
          // 1. They are in the same bar as the current note
          // 2. They are before or at the current note's tick
          // 3. It is the most recent accidental that fulfills 1. and 2.
          if (acc.tick >= mostRecentBar && acc.tick <= tick && acc.tick >= oldTick) {
            console.log('note line: ' + noteLine + ', steps: ' + acc.offset + ', tick: ' + acc.tick);
            console.log('acc.tick: ' + acc.tick + ', mostRecentBar: ' + mostRecentBar + ', tick: ' + tick + ', oldTick: ' + oldTick);
            offset = acc.offset;
            oldTick = acc.tick;
          }
        }

        return offset;
      }

      function tuneNote(note, segment, parms, scanOnly) {
        var tpc = note.tpc;

        // If tpc is non-natural, there's no need to go through additional steps,
        // since accidentals and key sig are already taken into consideration
        // to produce a non-screw-up tpc.

        // However, if tpc is natural, it needs to be checked against acc and
        // the key signature to truly determine what note it is.

        /*
          ^        v            -> 1 step
          #v       b^           -> 2 steps
          #        b            -> 3 steps
          #^  x    db  bb       -> 4 steps
        */


        // NOTE: Double accidentals in 22edo are intentionally marked as +/-5 steps
        //       (even though they are 4) in the array to account for the
        //       distinct tpc & pitch of double Accidentals vs. the #^ Accidentals
        //       which are also +/-4 steps, but aren't recognizes as a different note.
        if (!scanOnly) {
          switch(tpc) {
          case -1: //Fbb
            note.tuning = centOffsets['f'][-5]
            return;
          case 0: //Cbb
            note.tuning = centOffsets['c'][-5]
            return;
          case 1: //Gbb
            note.tuning = centOffsets['g'][-5]
            return;
          case 2: //Dbb
            note.tuning = centOffsets['d'][-5]
            return;
          case 3: //Abb
            note.tuning = centOffsets['a'][-5]
            return;
          case 4: //Ebb
            note.tuning = centOffsets['e'][-5]
            return;
          case 5: //Bbb
            note.tuning = centOffsets['b'][-5]
            return;

          case 6: //Fb
            note.tuning = centOffsets['f'][-3]
            return;
          case 7: //Cb
            note.tuning = centOffsets['c'][-3]
            return;
          case 8: //Gb
            note.tuning = centOffsets['g'][-3]
            return;
          case 9: //Db
            note.tuning = centOffsets['d'][-3]
            return;
          case 10: //Ab
            note.tuning = centOffsets['a'][-3]
            return;
          case 11: //Eb
            note.tuning = centOffsets['e'][-3]
            return;
          case 12: //Bb
            note.tuning = centOffsets['b'][-3]
            return;

          case 20: //F#
            note.tuning = centOffsets['f'][3]
            return;
          case 21: //C#
            note.tuning = centOffsets['c'][3]
            return;
          case 22: //G#
            note.tuning = centOffsets['g'][3]
            return;
          case 23: //D#
            note.tuning = centOffsets['d'][3]
            return;
          case 24: //A#
            note.tuning = centOffsets['a'][3]
            return;
          case 25: //E#
            note.tuning = centOffsets['e'][3]
            return;
          case 26: //B#
            note.tuning = centOffsets['b'][3]
            return;

          case 27: //Fx
            note.tuning = centOffsets['f'][5]
            return;
          case 28: //Cx
            note.tuning = centOffsets['c'][5]
            return;
          case 29: //Gx
            note.tuning = centOffsets['g'][5]
            return;
          case 30: //Dx
            note.tuning = centOffsets['d'][5]
            return;
          case 31: //Ax
            note.tuning = centOffsets['a'][5]
            return;
          case 32: //Ex
            note.tuning = centOffsets['e'][5]
            return;
          case 33: //Bx
            note.tuning = centOffsets['b'][5]
            return;
          }
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

        var accOffset = null;

        if (note.accidental) {
          console.log('accidental found on Note: ' + baseNote + ', Line: ' + note.line +
                      ', Special Accidental: ' + note.accidentalType);
          if (scanOnly)
            console.log('Scanning only, undefined is ok.');

          if (note.accidentalType == Accidental.FLAT_ARROW_DOWN)
            accOffset = -4;
          else if (note.accidentalType == Accidental.FLAT_ARROW_UP)
            accOffset = -2;
          else if (note.accidentalType == Accidental.NATURAL_ARROW_DOWN)
            accOffset = -1;
          else if (note.accidentalType == Accidental.NATURAL)
            accOffset = 0;
          else if (note.accidentalType == Accidental.NATURAL_ARROW_UP)
            accOffset = 1;
          else if (note.accidentalType == Accidental.SHARP_ARROW_DOWN)
            accOffset = 2;
          else if (note.accidentalType == Accidental.SHARP_ARROW_UP)
            accOffset = 4;

          if (accOffset !== null)
            registerAccidental(note.line, segment.tick, accOffset, parms);
        }

        if (!scanOnly) {
          // Check for prev accidentals first, will be null if not present
          // If explicit accidental exists, use that instead.
          var stepsFromBaseNote = accOffset !== null ? accOffset : getAccidental(note.line, segment.tick, parms);


          if (stepsFromBaseNote === null) {
            // No accidentals - check key signature.
            stepsFromBaseNote = parms.currKeySig[baseNote];
          }

          console.log("Base Note: " + baseNote + ", steps: " + stepsFromBaseNote);
          note.tuning = centOffsets[baseNote][stepsFromBaseNote];
        }

        return;
      }

      onRun: {
        console.log("hello 22tet");

        if (typeof curScore === 'undefined')
              Qt.quit();

        var parms = {};

        /*
          key signature as denoted by the TextFields.

          NOTE: parms.keySig has been deprecated, it now serves as a placeholder
                for the natural key signature.

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
