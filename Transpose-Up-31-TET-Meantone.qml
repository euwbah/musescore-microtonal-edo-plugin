import QtQuick 2.1
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import MuseScore 3.0

MuseScore {
      version:  "2.0.0"
      description: "Raises selection (Shift-click) or individually selected notes (Ctrl-click) by 1 step of 31 EDO."
      menuPath: "Plugins.31-TET (Meantone).Raise Pitch By 1 Step"

      // WARNING! This doesn't validate the accidental code!
      property variant customKeySigRegex: /\.(.*)\.(.*)\.(.*)\.(.*)\.(.*)\.(.*)\.(.*)/g

      // <TUNING SYSTEM VARIANT CHECKPOINT>
      property variant centOffsets: {
        'a': {
          '-4': 38.70967742 * -4 + 200, // Adb
          '-3': 38.70967742 * -3,       // Abv
          '-2': 38.70967742 * -2 + 100, // Ab
          '-1': 38.70967742 * -1,       // Av
           0: 38.70967742 * 0,         // A
           1: 38.70967742 * 1,         // A^
           2: 38.70967742 * 2 - 100,   // A#
           3: 38.70967742 * 3,         // A#^
           4: 38.70967742 * 4 - 200    // A#+
        },
        'b': {
          '-4': 38.70967742 * 1 - 200 + 200,
          '-3': 38.70967742 * 2 - 200,
          '-2': 38.70967742 * 3 - 200 + 100,
          '-1': 38.70967742 * 4 - 200,
           0: 38.70967742 * 5 - 200,
           1: 38.70967742 * 6 - 200,
           2: 38.70967742 * 7 - 200 - 100,
           3: 38.70967742 * 8 - 200,
           4: 38.70967742 * 9 - 200 - 200
        },
        'c': {
          '-4': 38.70967742 * 4 - 300 + 200,
          '-3': 38.70967742 * 5 - 300,
          '-2': 38.70967742 * 6 - 300 + 100,
          '-1': 38.70967742 * 7 - 300,
           0: 38.70967742 * 8 - 300,
           1: 38.70967742 * 9 - 300,
           2: 38.70967742 * 10 - 300 - 100,
           3: 38.70967742 * 11 - 300,
           4: 38.70967742 * 12 - 300 - 200
        },
        'd': {
          '-4': 38.70967742 * 9 - 500 + 200,
          '-3': 38.70967742 * 10 - 500,
          '-2': 38.70967742 * 11 - 500 + 100,
          '-1': 38.70967742 * 12 - 500,
           0: 38.70967742 * 13 - 500,
           1: 38.70967742 * 14 - 500,
           2: 38.70967742 * 15 - 500 - 100,
           3: 38.70967742 * 16 - 500,
           4: 38.70967742 * 17 - 500 - 200
        },
        'e': {
          '-4': 38.70967742 * 14 - 700 + 200,
          '-3': 38.70967742 * 15 - 700,
          '-2': 38.70967742 * 16 - 700 + 100,
          '-1': 38.70967742 * 17 - 700,
           0: 38.70967742 * 18 - 700,
           1: 38.70967742 * 19 - 700,
           2: 38.70967742 * 20 - 700 - 100,
           3: 38.70967742 * 21 - 700,
           4: 38.70967742 * 22 - 700 - 200
        },
        'f': {
          '-4': 38.70967742 * 17 - 800 + 200,
          '-3': 38.70967742 * 18 - 800,
          '-2': 38.70967742 * 19 - 800 + 100,
          '-1': 38.70967742 * 20 - 800,
           0: 38.70967742 * 21 - 800,
           1: 38.70967742 * 22 - 800,
           2: 38.70967742 * 23 - 800 - 100,
           3: 38.70967742 * 24 - 800,
           4: 38.70967742 * 25 - 800 - 100
        },
        'g': {
          '-4': 38.70967742 * 22 - 1000 + 200,
          '-3': 38.70967742 * 23 - 1000,
          '-2': 38.70967742 * 24 - 1000 + 100,
          '-1': 38.70967742 * 25 - 1000,
           0: 38.70967742 * 26 - 1000,
           1: 38.70967742 * 27 - 1000,
           2: 38.70967742 * 28 - 1000 - 100,
           3: 38.70967742 * 29 - 1000,
           4: 38.70967742 * 30 - 1000 - 200
        }
      }

      // <TUNING SYSTEM VARIANT CHECKPOINT>
      function convertAccidentalToSteps(acc) {
        switch(acc.trim()) {
        case 'bb':
          return -4;
        case 'db':
          return -3;
        case 'b':
          return -2;
        case 'd':
          return -1;
        case '':
          return 0;
        case '+':
          return 1;
        case '#':
          return 2;
        case '#+':
          return 3;
        case 'x':
          return 4;
        default:
          return 0;
        }
      }

      function convertAccidentalTextToAccidentalType(accStr) {
        switch(accStr.trim()) {
        case 'bbv':
          return Accidental.FLAT2_ARROW_DOWN;
        case 'bb':
          return Accidental.FLAT2;
        case 'bb^':
          return Accidental.FLAT2_ARROW_UP;
        case 'db':
          return Accidental.MIRRORED_FLAT2;
        case 'bv':
          return Accidental.FLAT_ARROW_DOWN;
        case 'b':
          return Accidental.FLAT;
        case 'v':
          return Accidental.NATURAL_ARROW_DOWN;
        case 'b^':
          return Accidental.FLAT_ARROW_UP;
        case 'd':
          return Accidental.MIRRORED_FLAT;
        case '+':
          return Accidental.SHARP_SLASH;
        case '^':
          return Accidental.NATURAL_ARROW_UP;
        case '#v':
          return Accidental.SHARP_ARROW_DOWN;
        case '#':
          return Accidental.SHARP;
        case '#^':
          return Accidental.SHARP_ARROW_UP;
        case '#+':
          return Accidental.SHARP_SLASH4;
        case 'xv':
          return Accidental.SHARP2_ARROW_DOWN;
        case 'x':
          return Accidental.SHARP2;
        case 'x^':
          return Accidental.SHARP2_ARROW_UP;
        default:
          return Accidental.NATURAL;
        }
      }

      // <TUNING SYSTEM VARIANT CHECKPOINT>
      function convertAccidentalTypeToSteps(accType) {
        switch (accType) {
        case Accidental.FLAT2:
          return -4;
        case Accidental.MIRRORED_FLAT2:
          return -3;
        case Accidental.FLAT:
          return -2;
        case Accidental.MIRRORED_FLAT:
          return -1;
        case Accidental.NATURAL:
          return 0;
        case Accidental.SHARP_SLASH:
          return 1;
        case Accidental.SHARP:
          return 2;
        case Accidental.SHARP_SLASH4:
          return 3;
        case Accidental.SHARP2:
          return 4;
        default:
          return null;
        }
      }

      // NOTE: This function may differ between upwards and downwards variants of
      //       the plugin as some tuning systems (e.g. 31 ups and downs) will have
      //       enharmonic equivalents between two different types of accidentals
      //
      //       e.g.: C#v and C^.
      // <UP DOWN VARIANT CHECKPOINT>
      // <TUNING SYSTEM VARIANT CHECKPOINT>
      function convertStepsToAccidentalType(steps) {
        switch(steps) {
        case -4:
          return Accidental.FLAT2;
        case -3:
          return Accidental.MIRRORED_FLAT2;
        case -2:
          return Accidental.FLAT;
        case -1:
          return Accidental.MIRRORED_FLAT; // NOTE: in downwards variant, use NATURAL_ARROW_DOWN instead
        case 0:
          return Accidental.NATURAL;
        case 1:
          return Accidental.SHARP_SLASH; // NOTE: in downwards variant, use SHARP_ARROW_DOWN instead
        case 2:
          return Accidental.SHARP;
        case 3:
          return Accidental.SHARP_SLASH4;
        case 4:
          return Accidental.SHARP2;
        default:
          return null;
        }
      }

      function convertAccidentalTypeToName(accType) {
        switch(accType) {
        case Accidental.FLAT2_ARROW_DOWN:
          return 'bbv';
        case Accidental.FLAT2:
          return 'bb';
        case Accidental.FLAT2_ARROW_UP:
          return 'bb^';
        case Accidental.MIRRORED_FLAT2:
          return 'db';
        case Accidental.FLAT_ARROW_DOWN:
          return 'bv';
        case Accidental.FLAT:
          return 'b';
        case Accidental.MIRRORED_FLAT:
          return 'd';
        case Accidental.FLAT_ARROW_UP:
          return 'b^';
        case Accidental.NATURAL_ARROW_DOWN:
          return 'v';
        case Accidental.NATURAL:
          return 'nat';
        case Accidental.NATURAL_ARROW_UP:
          return '^';
        case Accidental.SHARP_ARROW_DOWN:
          return '#v';
        case Accidental.SHARP_SLASH:
          return '+';
        case Accidental.SHARP:
          return '#';
        case Accidental.SHARP_ARROW_UP:
          return '#^';
        case Accidental.SHARP_SLASH4:
          return '#+';
        case Accidental.SHARP2_ARROW_DOWN:
          return 'xv';
        case Accidental.SHARP2:
          return 'x';
        case Accidental.SHARP2_ARROW_UP:
          return 'x^';
        case Accidental.NONE:
          return 'none';
        default:
          return 'unrecognized';
        }
      }

      // Returns the accidental after it has been transposed up (or down if the plugin is for transposing down)
      // will return null if there are no more accidentals that are higher (or lower) than acc.
      // acc: a value from the Accidental enum
      // <UP DOWN VARIANT CHECKPOINT>
      // <TUNING SYSTEM VARIANT CHECKPOINT>
      function getNextAccidental(acc) {
        switch(acc) {
        case Accidental.FLAT2:
          return Accidental.MIRRORED_FLAT2;
        case Accidental.MIRRORED_FLAT2:
          return Accidental.FLAT;
        case Accidental.FLAT:
          return Accidental.MIRRORED_FLAT;
        case Accidental.MIRRORED_FLAT:
          return Accidental.NATURAL;
        case Accidental.NATURAL:
          return Accidental.SHARP_SLASH;
        case Accidental.SHARP_SLASH:
          return Accidental.SHARP;
        case Accidental.SHARP:
          return Accidental.SHARP_SLASH4;
        case Accidental.SHARP_SLASH4:
          return Accidental.SHARP2;
        case Accidental.SHARP2:
          return null;
        default:
          return null;
        }
      }

      // returns the note.line property after it has been enharmonically transposed
      // in the direction of the plugin.
      // NOTE: Set the coefficient to -1 for upwards plugins, and +1 for downwards plugins.
      // <UP DOWN VARIANT CHECKPOINT>
      function getNextLine(line) {
        return line - 1;
      }

      // returns the accidental equivalent of the next baseNote after the current baseNote
      // at maximum accidental offset is exceeded.
      //
      // example: if the note is Bx, and there is no more accidental sharper than x,
      //          call this function with the argument 'b', and it will return Accidental.SHARP_ARROW_UP
      //          representing the note that is higher than Bx is C#^.
      //
      // <UP DOWN VARIANT CHECKPOINT>
      // <TUNING SYSTEM VARIANT CHECKPOINT>
      function getOverLimitEnharmonicEquivalent(baseNote) {
        switch(baseNote) {
        case 'c':
        case 'd':
        case 'f':
        case 'g':
        case 'a':
          return Accidental.NATURAL;
        default:
          return Accidental.SHARP;
        }
      }

      // returns enharmonics above and below
      // {
      //   above: {baseNote: 'a' through 'g', offset: diesis offset}
      //   below: {baseNote: 'a' through 'g', offset: diesis offset}
      // }
      // <TUNING SYSTEM VARIANT CHECKPOINT>
      function getEnharmonics(baseNote, offset) {
        var above, below;

        switch (baseNote) {
        case 'a': case 'd': case 'g':
          above = offset - 5;
          below = offset + 5;
          break;
        case 'b': case 'e':
          above = offset - 3;
          below = offset + 5;
          break;
        case 'c': case 'f':
          above = offset - 5;
          below = offset + 3;
        }

        above = above < -5 ? null : {
          baseNote: getNextNote(baseNote),
          offset: above
        };
        below = below > 5 ? null : {
          baseNote: getPrevNote(baseNote),
          offset: below
        };
        return {
          above: above,
          below: below
        };
      }

      // gets the base note alphabet above the current notestr
      function getNextNote(noteStr) {
        switch(noteStr) {
        case 'a':
          return 'b';
        case 'b':
          return 'c';
        case 'c':
          return 'd';
        case 'd':
          return 'e';
        case 'e':
          return 'f';
        case 'f':
          return 'g';
        case 'g':
          return 'a';
        }
      }

      function getPrevNote(noteStr) {
        switch(noteStr) {
        case 'a':
          return 'g';
        case 'b':
          return 'a';
        case 'c':
          return 'b';
        case 'd':
          return 'c';
        case 'e':
          return 'd';
        case 'f':
          return 'e';
        case 'g':
          return 'f';
        }
      }

      // Takes in annotations[].text and returns either
      // a key signature object if str is a valid custom key sig code or null.
      //
      // Key signature object structure:
      // {
      //   c: {steps: <number of diesis offset>, type: Accidental enum value}
      //   d: ...
      //   e: ...
      //   etc...
      // }
      //
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
          var accSteps = convertAccidentalToSteps(res[i].trim());
          var accType = convertAccidentalTextToAccidentalType(res[i].trim());
          keySig[notes[i]] = {offset: accSteps, type: accType};
        }

        return keySig;
      }

      // Apply the given function to all notes in selection
      // or, if nothing is selected, in the entire score

      function applyToNotesInSelection(func, parms) {
        // sadly, there seems to be no way for the plugin to tell if the cursor
        // is in element-array selection mode which would have been helpful for
        // transposing individual note elements selected by alt+click.
        var cursor = curScore.newCursor();
        cursor.rewind(1);
        var startStaff;
        var endStaff;
        var endTick;
        var noPhraseSelection = false;
        if (!cursor.segment) { // no selection
          // no action if no selection.
          console.log('no phrase selection');
          noPhraseSelection = true;
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


        if (noPhraseSelection) {
          // No phrase selection

          // - No-op if curScore.selection.elements.length == 0.
          // - If selection doesn't contain a single element that has Element.type == Element.NOTE,
          //   default to cmd('pitch-up') or cmd('pitch-down') so MuseScore can handle moving other Elements.
          //   This allows users to use this plugin in place of the 'pitch-up' and 'pitch-down' shortcuts (up/down arrow keys)
          //   without losing any of the other functions that the up or down arrow keys originally provides.
          // - If selection contains individual notes, transpose them.

          if (curScore.selection.elements.length == 0) {
            console.log('no individual selection. quitting.');
            Qt.quit();
          } else {
            var selectedNotes = [];
            for (var i = 0; i < curScore.selection.elements.length; i++) {
              if (curScore.selection.elements[i].type == Element.NOTE) {
                selectedNotes.push(curScore.selection.elements[i]);
              }
            }

            // for debugging
            // for (var i = 0; i < selectedNotes.length; i ++) {
            //   selectedNotes[i].color = 'red';
            // }

            if (selectedNotes.length == 0) {
              console.log('no selected note elements, defaulting to pitch-up/pitch-down shortcuts');
              // <UP DOWN VARIANT CHECKPOINT>
              cmd('pitch-up');
              Qt.quit();
            }

            // These selected notes may be in any random order and may come from any staff
            // keep a registry of staff key signatures for ALL staves in order to reference
            // them according to which staff the current note element is in.

            // contains an array of staffKeySigHistory objects. Index in array corresponds to staffIdx number.
            var allKeySigs = [];

            parms.bars = [];
            parms.currKeySig = parms.naturalKeySig;

            // populate all key signatures and bars
            for (var staff = 0; staff < curScore.nstaves; staff++) {
              var staffKeySigHistory = [];

              for (var voice = 0; voice < 4; voice++) {
                cursor.rewind(1);
                cursor.staffIdx = staff;
                cursor.voice = voice;
                cursor.rewind(0);

                console.log("processing custom key signatures staff: " + staff + ", voice: " + voice);

                while (true) {
                  if (cursor.segment) {
                    for (var i = 0; i < cursor.segment.annotations.length; i++) {
                      var annotation = cursor.segment.annotations[i];
                      console.log("found annotation type: " + annotation.subtypeName());
                      var maybeKeySig = scanCustomKeySig(annotation.text);
                      if (maybeKeySig !== null) {
                        console.log("detected new custom keySig: " + annotation.text + ", staff: " + staff + ", voice: " + voice);
                        staffKeySigHistory.push({
                          tick: cursor.tick,
                          keySig: maybeKeySig
                        });
                      }
                    }

                    var measureCount = 0;

                    if (cursor.segment.tick == cursor.measure.firstSegment.tick && voice === 0 && staff === 0) {
                      if (!parms.bars)
                        parms.bars = [];

                      parms.bars.push(cursor.segment.tick);
                      measureCount ++;
                      console.log("New bar - " + measureCount + ", tick: " + cursor.segment.tick);
                    }
                  }

                  if (!cursor.next())
                    break;
                }
              }

              allKeySigs.push(staffKeySigHistory);
            } // end of key sig and bars population for all staves

            // Run transpose operation on all note elements.

            for (var i = 0; i < selectedNotes.length; i++) {
              var note = selectedNotes[i];
              var notes = note.parent.notes; // represents the notes in the chord of the selected note.
              var noteChordIndex = -1; // Index of note in notes array
              for (var j = 0; j < notes.length; j++) {
                if (notes[j].is(note)) {
                  noteChordIndex = j;
                  break;
                }
              }

              console.log('noteChordIndex: ' + noteChordIndex);

              // make sure cursor reflects current voice and staff index
              cursor.rewind(1);
              cursor.staffIdx = note.track / 4;
              cursor.voice = note.track % 4;
              cursor.rewind(0);

              console.log('indiv note: line: ' + note.line + ', accidental: ' + convertAccidentalTypeToName(0 + note.accidentalType) +
                        ', voice: ' + cursor.voice + ', staff: ' + cursor.staffIdx + ', tick: ' + note.parent.parent.tick);

              // set cur key sig
              var mostRecentKeySigTick = -1;
              for (var j = 0; j < staffKeySigHistory.length; j++) {
                var keySig = allKeySigs[cursor.staffIdx][j];
                if (keySig.tick <= note.parent.parent.tick && keySig.tick > mostRecentKeySigTick) {
                  parms.currKeySig = keySig.keySig;
                  mostRecentKeySigTick = keySig.tick;
                }
              }

              // there's no Array.slice in the plugin API
              parms.chordExcludingSelf = [];
              for (var j = 0; j < notes.length; j++) {
                if (j != noteChordIndex)
                  parms.chordExcludingSelf.push(notes[j]);
              }

              if (noteChordIndex >= 1 && note.line === notes[noteChordIndex - 1].line) {
                if (notes[noteChordIndex - 1].accidental && notes[noteChordIndex - 1].accidentalType != Accidental.NONE)
                  parms.accOnSameLineBefore = 0 + notes[noteChordIndex - 1].accidentalType;
              } else {
                parms.accOnSameLineBefore = undefined;
              }

              parms.noteOnSameOldLineAfter = undefined;
              if (notes[noteChordIndex + 1] && notes[noteChordIndex + 1].line === note.line)
                parms.noteOnSameOldLineAfter = notes[noteChordIndex + 1];

              parms.notesOnSameNewLine = [];
              for (var k = noteChordIndex + 1; k < notes.length; k ++) {
                if (notes[k] && notes[k].line === getNextLine(note.line)) {
                  parms.notesOnSameNewLine.push(notes[k]);
                }
              }

              // NOTE: note.parent.parent is equivalent to the Segment the current selected note belongs to.
              func(note, note.parent.parent, parms, cursor);
            }

            if (selectedNotes.length === 1) {
              // NOTE: There is no need to do this, playback of a single selected note is automatic.
              // If only one note was transposed, trigger playback of the transposed note.
              // This is accomplished by a hack dmitrio95 suggested here: https://musescore.org/en/node/305861
              // cmd("next-element");
              // cmd("prev-element");
            }

          }
        } else {
          for (var staff = startStaff; staff <= endStaff; staff++) {

            // reset barrings (actually, why tho?)
            parms.bars = [];

            // After every staff, reset the currKeySig back to the original keySig

            parms.currKeySig = parms.naturalKeySig;

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

              // Note: either ways, it is still necesssary to go to the start of the score before
              // applying to notes in selection as custom key signatures may precede the selection
              // that should still apply to the score.

              cursor.rewind(1);
              cursor.staffIdx = staff;
              cursor.voice = voice;
              cursor.rewind(0);

              console.log("processing custom key signatures staff: " + staff + ", voice: " + voice);

              // NOTE: Initial key signature state and barring state scan covers the entire score.
              //       This is required as it is now possible to selecting individual notes across
              //       different bars (Alt + click) instead of just a monolithic phrase selection.
              //       (Also required to fix tickOfNextBar showing -1 if at end of selection, but
              //        a following bar exists.)
              while (true) {

                if (cursor.segment) {
                  // Check for StaffText key signature changes, then update staffKeySigHistory
                  for (var i = 0; i < cursor.segment.annotations.length; i++) {
                    var annotation = cursor.segment.annotations[i];
                    console.log("found annotation type: " + annotation.subtypeName());
                    var maybeKeySig = scanCustomKeySig(annotation.text);
                    if (maybeKeySig !== null) {
                      console.log("detected new custom keySig: " + annotation.text + ", staff: " + staff + ", voice: " + voice);
                      staffKeySigHistory.push({
                        tick: cursor.tick,
                        keySig: maybeKeySig
                      });
                    }
                  }

                  var measureCount = 0;

                  if (cursor.segment.tick == cursor.measure.firstSegment.tick && voice === 0) {
                    // once new bar is reached, denote new bar in the parms.bars object
                    // so that getAccidental will reset. Only do this for the first voice in a staff
                    // since voices in a staff shares the same barrings.
                    if (!parms.bars)
                      parms.bars = [];

                    parms.bars.push(cursor.segment.tick);
                    measureCount ++;
                    console.log("New bar - " + measureCount + ", tick: " + cursor.segment.tick);
                  }
                }

                if (!cursor.next())
                  break;
              }
            }

            // NOTE: no more need for 2 passes as accidentals are now statelessly evaluated!
            for (var voice = 0; voice < 4; voice++) {

              cursor.rewind(1); // goes to start of selection, will reset voice to 0

              cursor.staffIdx = staff;
              cursor.voice = voice;

              console.log('processing:' + cursor.tick + ', voice: ' + cursor.voice + ', staffIdx: ' + cursor.staffIdx);

              // Loop elements of a voice
              while (cursor.segment && (cursor.tick < endTick)) {

                var mostRecentKeySigTick = -1;
                for (var i = 0; i < staffKeySigHistory.length; i++) {
                  var keySig = staffKeySigHistory[i];
                  if (keySig.tick <= cursor.tick && keySig.tick > mostRecentKeySigTick) {
                    parms.currKeySig = keySig.keySig;
                    mostRecentKeySigTick = keySig.tick;
                  }
                }

                if (cursor.element) {
                  if (cursor.element.type == Ms.CHORD) {
                    var graceChords = cursor.element.graceNotes;
                    for (var i = 0; i < graceChords.length; i++) {
                      // iterate through all grace chords
                      var notes = graceChords[i].notes;
                      parms.accOnSameLineBefore = undefined;
                      for (var j = 0; j < notes.length; j++) {

                        // Used in step 2. case vii. for determining which notes
                        // exist in the same line as the current note that is NOT the current
                        // note itself.

                        // there's no Array.slice in the plugin API
                        parms.chordExcludingSelf = [];
                        for (var k = 0; k < notes.length; k++) {
                          if (k != noteChordIndex)
                            parms.chordExcludingSelf.push(notes[k]);
                        }

                        // accOnSameLineBefore contains the most recent accidental before
                        // this current note that shares the same line and chord as this current note.
                        if (j >= 1 && notes[j].line === notes[j - 1].line) {
                          if (notes[j - 1].accidental && notes[j - 1].accidentalType != Accidental.NONE)
                            parms.accOnSameLineBefore = 0 + notes[j - 1].accidentalType;
                        } else {
                          parms.accOnSameLineBefore = undefined;
                        }

                        // noteOnSameOldLineAfter contains the note object on the same line in the
                        // same chord that is directly after this current note, if any.
                        // this value, if present, takes the place of the immediate next note on the same line
                        // at a following segment within this bar.
                        parms.noteOnSameOldLineAfter = undefined;
                        if (notes[j + 1] && notes[j + 1].line === notes[j].line)
                          parms.noteOnSameOldLineAfter = notes[j + 1];

                        // notesOnSameNewLine contains all the notes that would have the same line
                        // as the transposed note AFTER transposition in the hypothetical event that
                        // the transposed note is spelt ENHARMONICALLY.
                        parms.notesOnSameNewLine = [];
                        for (var k = j + 1; k < notes.length; k ++) {
                          if (notes[k] && notes[k].line === getNextLine(notes[j].line)) {
                            parms.notesOnSameNewLine.push(notes[k]);
                          }
                        }

                        func(notes[j], cursor.segment, parms, cursor);

                      }
                    }
                    var notes = cursor.element.notes;
                    parms.accOnSameLineBefore = undefined;
                    for (var i = 0; i < notes.length; i++) {
                      // documentation for all these is found above in the section dealing with grace notes.
                      var note = notes[i];

                      parms.chordExcludingSelf = [];
                      for (var j = 0; j < notes.length; j++) {
                        if (j != noteChordIndex)
                          parms.chordExcludingSelf.push(notes[j]);
                      }

                      if (i >= 1 && note.line === notes[i - 1].line) {
                        if (notes[i - 1].accidental && notes[i - 1].accidentalType != Accidental.NONE)
                          parms.accOnSameLineBefore = 0 + notes[i - 1].accidentalType;
                      } else {
                        parms.accOnSameLineBefore = undefined;
                      }

                      parms.noteOnSameOldLineAfter = undefined;
                      if (notes[i + 1] && notes[i + 1].line === note.line)
                        parms.noteOnSameOldLineAfter = notes[i + 1];

                      parms.notesOnSameNewLine = [];
                      for (var k = i + 1; k < notes.length; k ++) {
                        if (notes[k] && notes[k].line === getNextLine(note.line)) {
                          parms.notesOnSameNewLine.push(notes[k]);
                        }
                      }

                      func(note, cursor.segment, parms, cursor);
                    }
                  }
                }
                cursor.next();
              }
            }
          }
        }
      }

      // Set a cursor to a specific position.
      // NOTE: THIS ACTUALLY WORKS!!!
      // WARNING: Do not call this function with a tick value of which no segment in that voice & staff
      //          can correspond to, will result in an error and unpredictable behavior.
      function setCursorToPosition(cursor, tick, voice, staffIdx) {
        cursor.rewind(1);
        cursor.voice = voice;
        cursor.staffIdx = staffIdx;
        cursor.rewind(0);

        while (cursor.tick < tick) {
          // cursor.next();
          if (tick > cursor.measure.lastSegment.tick) {
            if(!cursor.nextMeasure()) {
              console.log('FATAL ERROR: setCursorToPosition next measure BREAK. tick: ' + cursor.tick + ', elem: ' + cursor.element);
              break;
            }
          } else if(!cursor.next()) {
            console.log('FATAL ERROR: setCursorToPosition next BREAK. tick: ' + cursor.tick + ', elem: ' + cursor.element);
            break;
          }
        }

        while (cursor.tick > tick) {
          // cursor.next();
          if(!cursor.prev()) {
            console.log('FATAL ERROR: setCursorToPosition prev BREAK. tick: ' + cursor.tick + ', elem: ' + cursor.element);
            break;
          }
        }

        // how can this even happen
        if (cursor.tick !== tick)
          console.log('FATAL ERROR: cursor position messed up (setCursorToPosition). tick: ');
      }

      // gets the most recent explicit accidental at the given line.
      // Yields explicit accidentals that are DURING or BEFORE the given cursor.tick value
      // at the time this function is invoked.
      //
      // if `before` flag is true, only returns accidentals BEFORE the cursor.tick value.
      //
      // returns an Accidental enum vale if an explicit accidental exists,
      // or the string 'botched' if botchedCheck is true and it is impossible to determine what the exact accidental is
      // or null, if there are no explicit accidentals, and it is determinable.
      function getMostRecentAccidentalInBar(cursor, noteTick, line, tickOfThisBar, tickOfNextBar, botchedCheck, before) {
        var thisCursorVoice = cursor.voice;
        var thisStaffIdx = cursor.staffIdx;
        var mostRecentExplicitAcc;
        var mostRecentExplicitAccTick = -1;
        var mostRecentPossiblyBotchedAccTick = -1;
        var mostRecentDoubleLineTick = -1;

        if (tickOfNextBar == -1)
          tickOfNextBar = cursor.score.lastSegment.tick;

        console.log('called getMostRecentAcc: tick: ' + noteTick + ', line: ' + line + ', thisBar: ' + tickOfThisBar +
                    ', nextBar: ' + tickOfNextBar + ', botchedCheck: ' + botchedCheck + ', before: ' + before);

        for (var voice = 0; voice < 4; voice ++) {
          cursor.rewind(1);
          cursor.voice = voice;
          cursor.staffIdx = thisStaffIdx;
          cursor.rewind(0);

          // move cursor to the segment at noteTick
          while (cursor.tick < tickOfNextBar && cursor.nextMeasure());
          while (cursor.tick > noteTick && cursor.prev());

          // if before is true, move cursor to the segment BEFORE noteTick.
          if (before) {
            while (cursor.tick >= noteTick && cursor.prev());
          }

          while (tickOfThisBar !== -1 && cursor.segment && cursor.tick >= tickOfThisBar) {
            if (cursor.element && cursor.element.type == Ms.CHORD) {
              // because this is backwards-traversing, it should look at notes first before grace chords.
              var notes = cursor.element.notes;
              var nNotesInSameLine = 0;
              var explicitAccidental = undefined;
              var explicitPossiblyBotchedAccidental = undefined;
              for (var i = 0; i < notes.length; i++) {
                if (notes[i].line === line) {
                  nNotesInSameLine ++;

                  // console.log('found same line: ' + notes[i].line + ', acc: ' + convertAccidentalTypeToName(0 + notes[i].accidentalType) +
                  //             ', tick: ' + notes[i].parent.parent.tick + ', tpc: ' + notes[i].tpc);

                  // Note: this behemoth is necessary due to this issue: https://musescore.org/en/node/305977
                  // "Note.accidental and Note.accidentalType not updated in new cursor instance after setting to regular accidental."
                  // Note that this is a hacky workaround, using the note's tpc to assume the presence of an explicit accidental
                  // when its accidental properties gets erased due to a pitch update.
                  // (If no pitch update was done performed on the note, any explicit accidental will still be registered as such)
                  //
                  // However, using this hack, there is no way to ascertain that the note indeed has an explicit accidental or not,
                  // but for solely the purposes of retrieving accidental state, this is a perfectly fine solution.
                  if(notes[i].accidental) {
                    explicitAccidental = notes[i].accidentalType;
                    console.log('found explicitAccidental: ' + explicitAccidental);
                  } else if (notes[i].tpc <= 5 && notes[i].tpc >= -1)
                    explicitPossiblyBotchedAccidental = Accidental.FLAT2;
                  else if (notes[i].tpc <= 12 && notes[i].tpc >= 6)
                    explicitPossiblyBotchedAccidental = Accidental.FLAT;
                  else if (notes[i].tpc <= 26 && notes[i].tpc >= 20)
                    explicitPossiblyBotchedAccidental = Accidental.SHARP;
                  else if (notes[i].tpc <= 33 && notes[i].tpc >= 27)
                    explicitPossiblyBotchedAccidental = Accidental.SHARP2;
                }
              }

              if (nNotesInSameLine === 1 && explicitAccidental && cursor.tick > mostRecentPossiblyBotchedAccTick) {
                mostRecentExplicitAcc = explicitAccidental;
                mostRecentExplicitAccTick = cursor.tick;
                mostRecentPossiblyBotchedAccTick = cursor.tick;
                break;
              } else if (nNotesInSameLine > 1 && cursor.tick > mostRecentDoubleLineTick) {
                mostRecentDoubleLineTick = cursor.tick;
                break;
              } else if (nNotesInSameLine === 1 && explicitPossiblyBotchedAccidental && cursor.tick > mostRecentPossiblyBotchedAccTick) {
                mostRecentExplicitAcc = explicitPossiblyBotchedAccidental;
                mostRecentPossiblyBotchedAccTick = cursor.tick;
              }

              var graceChords = cursor.element.graceNotes;
              for (var i = graceChords.length - 1; i >= 0; i--) {
                // iterate through all grace chords
                var notes = graceChords[i].notes;
                var nNotesInSameLine = 0;
                var explicitAccidental = undefined;
                for (var j = 0; j < notes.length; j++) {
                  if (notes[i].line === line) {
                    nNotesInSameLine ++;

                    if(notes[i].accidental)
                      explicitAccidental = notes[i].accidentalType;
                    else if (notes[i].tpc <= 5 && notes[i].tpc >= -1)
                     explicitPossiblyBotchedAccidental = Accidental.FLAT2;
                    else if (notes[i].tpc <= 12 && notes[i].tpc >= 6)
                     explicitPossiblyBotchedAccidental = Accidental.FLAT;
                    else if (notes[i].tpc <= 26 && notes[i].tpc >= 20)
                     explicitPossiblyBotchedAccidental = Accidental.SHARP;
                    else if (notes[i].tpc <= 33 && notes[i].tpc >= 27)
                     explicitPossiblyBotchedAccidental = Accidental.SHARP2;
                  }
                }

                if (nNotesInSameLine === 1 && explicitAccidental && cursor.tick > mostRecentPossiblyBotchedAccTick) {
                  mostRecentExplicitAcc = explicitAccidental;
                  mostRecentExplicitAccTick = cursor.tick;
                  mostRecentPossiblyBotchedAccTick = cursor.tick;
                  break;
                } else if (nNotesInSameLine > 1 && cursor.tick > mostRecentDoubleLineTick) {
                  mostRecentDoubleLineTick = cursor.tick;
                  break;
                } else if (nNotesInSameLine === 1 && explicitPossiblyBotchedAccidental && cursor.tick > mostRecentPossiblyBotchedAccTick) {
                  mostRecentExplicitAcc = explicitPossiblyBotchedAccidental;
                  mostRecentPossiblyBotchedAccTick = cursor.tick;
                }
              }
            }

            cursor.prev();
          }
        }

        setCursorToPosition(cursor, noteTick, thisCursorVoice, thisStaffIdx);

        if (botchedCheck && mostRecentDoubleLineTick !== -1 && mostRecentDoubleLineTick >= mostRecentExplicitAccTick) {
          return 'botched';
        } else if (mostRecentExplicitAcc && mostRecentExplicitAcc != Accidental.NONE) {
          return mostRecentExplicitAcc;
        } else {
          return null;
        }
      }

      // returns the accidental in effect at the given tick and noteLine, of the
      // cursor track index. All 4 voices in the track are accounted for.
      //
      // cursor: the cursor object. Doesn't matter where the cursor currently is.
      // tick: all accidentals found at this tick and prior to this tick up to the
      //       start of the bar will be accounted for.
      // noteLine: which note.line value the accidental should correspond to. (e.g. F5 in the treble clef is 0)
      // botchedCheck: whether or not to check for botched lines
      //
      //               Botched lines occur where the presence of 2 or more notes in the
      //               same chord sharing the same line makes the accidental at that
      //               line indeterminate as it is not possible to determine which one of the notes
      //               come last in the event that the prior note was transposed enharmonically to
      //               take the place of that line.
      //
      //               It is safe to leave this as false and not check for botched notes
      //               whilst getting initial pitchData on the note as before a note
      //               is transposed, the order of which the notes are indexed in the same line
      //               within the same chord is determinate. (left to right then bottom to top)
      //
      //               However, when using the accidental state of the current position
      //               to determine whether subsequent notes would have been affected
      //               by changes to the current note due to transposition,
      //               it is VERY IMPORTANT to check if the accidental could have been botched,
      //               in order to prevent making wild guesses that would cause unwanted side effects.
      //
      // before: (Optional) set to true if only accidentals BEFORE the tick should take effect.
      //         If the explicit accidental lies during the tick itself, it will not be accounted for.
      //
      // If no accidental, returns null.
      // If accidental is botched and botchedCheck is enabled, returns the string 'botched'.
      // If accidental is found, returns the following accidental object:
      // {
      //    offset: number of diesis offset,
      //    type: accidental type as Accidental enum value
      // }
      //
      // This function is completely STATELESS now!!! hooray!!
      //
      // NOTE: If an accidental was botched before but an explicit accidental
      //       is found MORE RECENT than the time of botching, the final result is NOT
      //       botched.
      function getAccidental(cursor, tick, noteLine, botchedCheck, parms, before) {

        var tickOfNextBar = -1; // if -1, the cursor at the last bar

        for (var i = 0; i < parms.bars.length; i++) {
          if (parms.bars[i] > tick) {
            tickOfNextBar = parms.bars[i];
            break;
          }
        }

        var tickOfThisBar = -1; // this should never be -1

        for (var i = 0; i < parms.bars.length; i++) {
          if (parms.bars[i] <= tick) {
            tickOfThisBar = parms.bars[i];
          }
        }

        if (before === undefined)
          before = false;

        var result = getMostRecentAccidentalInBar(cursor, tick, noteLine, tickOfThisBar, tickOfNextBar, botchedCheck, before)

        if (result === null || result === 'botched')
          return result;
        else {
          return {
            offset: convertAccidentalTypeToSteps(0 + result),
            type: result
          };
        }
      }

      // returns an object with info on note pitch:
      // {
      //    baseNote: a string from 'a' to 'g',
      //    line: the note.line property referring to height of the note on the staff
      //    tpc: the tonal pitch class of the note (as per note.tpc)
      //    tick: the tick position of the note
      //    explicitAccidental: Accidental enum of the explicit accidental attatched to this note (if any, otherwise undefined)
      //    implicitAccidental: Accidental enum of the implicit accidental of this note (non null)
      //                        (if explicitAccidental exists, implicitAccidental = explicitAccidental)
      //    diesisOffset: the number of edo steps offset from the base note this note is
      // }
      //
      function getNotePitchData(cursor, note, parms) {
        var noteData = {};

        noteData.line = note.line;
        noteData.tpc = note.tpc;
        noteData.tick = note.parent.parent.tick;

        // <TUNING SYSTEM VARIANT CHECKPOINT>
        switch(note.tpc) {
        case -1: //Fbb
          noteData.baseNote = 'f';
          noteData.diesisOffset = -5;
          noteData.implicitAccidental = Accidental.FLAT2;
          break;
        case 0: //Cbb
          noteData.baseNote = 'c';
          noteData.diesisOffset = -5;
          noteData.implicitAccidental = Accidental.FLAT2;
          break;
        case 1: //Gbb
          noteData.baseNote = 'g';
          noteData.diesisOffset = -5;
          noteData.implicitAccidental = Accidental.FLAT2;
          break;
        case 2: //Dbb
          noteData.baseNote = 'd';
          noteData.diesisOffset = -5;
          noteData.implicitAccidental = Accidental.FLAT2;
          break;
        case 3: //Abb
          noteData.baseNote = 'a';
          noteData.diesisOffset = -5;
          noteData.implicitAccidental = Accidental.FLAT2;
          break;
        case 4: //Ebb
          noteData.baseNote = 'e';
          noteData.diesisOffset = -5;
          noteData.implicitAccidental = Accidental.FLAT2;
          break;
        case 5: //Bbb
          noteData.baseNote = 'b';
          noteData.diesisOffset = -5;
          noteData.implicitAccidental = Accidental.FLAT2;
          break;

        case 6: //Fb
          noteData.baseNote = 'f';
          noteData.diesisOffset = -2;
          noteData.implicitAccidental = Accidental.FLAT;
          break;
        case 7: //Cb
          noteData.baseNote = 'c';
          noteData.diesisOffset = -2;
          noteData.implicitAccidental = Accidental.FLAT;
          break;
        case 8: //Gb
          noteData.baseNote = 'g';
          noteData.diesisOffset = -2;
          noteData.implicitAccidental = Accidental.FLAT;
          break;
        case 9: //Db
          noteData.baseNote = 'd';
          noteData.diesisOffset = -2;
          noteData.implicitAccidental = Accidental.FLAT;
          break;
        case 10: //Ab
          noteData.baseNote = 'a';
          noteData.diesisOffset = -2;
          noteData.implicitAccidental = Accidental.FLAT;
          break;
        case 11: //Eb
          noteData.baseNote = 'e';
          noteData.diesisOffset = -2;
          noteData.implicitAccidental = Accidental.FLAT;
          break;
        case 12: //Bb
          noteData.baseNote = 'b';
          noteData.diesisOffset = -2;
          noteData.implicitAccidental = Accidental.FLAT;
          break;

        case 20: //F#
          noteData.baseNote = 'f';
          noteData.diesisOffset = 2;
          noteData.implicitAccidental = Accidental.SHARP;
          break;
        case 21: //C#
          noteData.baseNote = 'c';
          noteData.diesisOffset = 2;
          noteData.implicitAccidental = Accidental.SHARP;
          break;
        case 22: //G#
          noteData.baseNote = 'g';
          noteData.diesisOffset = 2;
          noteData.implicitAccidental = Accidental.SHARP;
          break;
        case 23: //D#
          noteData.baseNote = 'd';
          noteData.diesisOffset = 2;
          noteData.implicitAccidental = Accidental.SHARP;
          break;
        case 24: //A#
          noteData.baseNote = 'a';
          noteData.diesisOffset = 2;
          noteData.implicitAccidental = Accidental.SHARP;
          break;
        case 25: //E#
          noteData.baseNote = 'e';
          noteData.diesisOffset = 2;
          noteData.implicitAccidental = Accidental.SHARP;
          break;
        case 26: //B#
          noteData.baseNote = 'b';
          noteData.diesisOffset = 2;
          noteData.implicitAccidental = Accidental.SHARP;
          break;

        case 27: //Fx
          noteData.baseNote = 'f';
          noteData.diesisOffset = 5;
          noteData.implicitAccidental = Accidental.SHARP2;
          break;
        case 28: //Cx
          noteData.baseNote = 'c';
          noteData.diesisOffset = 5;
          noteData.implicitAccidental = Accidental.SHARP2;
          break;
        case 29: //Gx
          noteData.baseNote = 'g';
          noteData.diesisOffset = 5;
          noteData.implicitAccidental = Accidental.SHARP2;
          break;
        case 30: //Dx
          noteData.baseNote = 'd';
          noteData.diesisOffset = 5;
          noteData.implicitAccidental = Accidental.SHARP2;
          break;
        case 31: //Ax
          noteData.baseNote = 'a';
          noteData.diesisOffset = 5;
          noteData.implicitAccidental = Accidental.SHARP2;
          break;
        case 32: //Ex
          noteData.baseNote = 'e';
          noteData.diesisOffset = 5;
          noteData.implicitAccidental = Accidental.SHARP2;
          break;
        case 33: //Bx
          noteData.baseNote = 'b';
          noteData.diesisOffset = 5;
          noteData.implicitAccidental = Accidental.SHARP2;
          break;
        }

        var irregularAccidentalOrNatural = noteData.baseNote === undefined;
        console.log('irr: ' + irregularAccidentalOrNatural);

        // in the event that tpc is considered natural by
        // MuseScore's playback, it would mean that it is
        // either a natural note, or a microtonal accidental.

        if (irregularAccidentalOrNatural) {
          switch(noteData.tpc) {
          case 13:
            noteData.baseNote = 'f';
            break;
          case 14:
            noteData.baseNote = 'c';
            break;
          case 15:
            noteData.baseNote = 'g';
            break;
          case 16:
            noteData.baseNote = 'd';
            break;
          case 17:
            noteData.baseNote = 'a';
            break;
          case 18:
            noteData.baseNote = 'e';
            break;
          case 19:
            noteData.baseNote = 'b';
            break;
          }
        }

        if (note.accidentalType != Accidental.NONE) {
          // when assigning note.accidentalType to variables,
          // ensure that the value read is in integer format to invoke the getter of the
          // integer enumeration instead of the stringified value of the accidental type.
          noteData.explicitAccidental = 0 + note.accidentalType;
          noteData.implicitAccidental = 0 + note.accidentalType;

          if (irregularAccidentalOrNatural) {
            noteData.diesisOffset = convertAccidentalTypeToSteps(0 + note.accidentalType);
          }
          // explicit acc exists, can return early.
          return noteData;
        }

        // Check for prev accidentals first, will be null if not present
        // note: botchedCheck can be false as if any prior note would have been
        //       enharmonically transposed to cause a botched line, the plugin would
        //       automatically affix an explicit accidental to the affected note,
        //       and the getAccidental check would run as the function would have
        //       returned in the above clause.
        var prevAcc = getAccidental(cursor, noteData.tick, note.line, false, parms);
        if (prevAcc !== null) {
          noteData.implicitAccidental = 0 + prevAcc.type;
          noteData.diesisOffset = prevAcc.offset;
        } else {
          // No accidentals - check key signature.
          var keySig = parms.currKeySig[noteData.baseNote];
          noteData.implicitAccidental = 0 + keySig.type;
          noteData.diesisOffset = keySig.offset;
        }

        return noteData;
      }

      function tuneNote(note, segment, parms, cursor) {

        // Step 0
        var pitchData = getNotePitchData(cursor, note, parms);

        console.log('pitchData: note: ' + pitchData.baseNote +
                  ', acc: ' + convertAccidentalTypeToName(pitchData.implicitAccidental) +
                  ', explicit: ' + (pitchData.explicitAccidental != undefined ? convertAccidentalTypeToName(pitchData.explicitAccidental) : 'none') +
                  ', line: ' + pitchData.line + ', offset: ' + pitchData.diesisOffset);

        // step 1a. determine naive pitch and accidental of new tranposed note
        // the mutable newAccidental, newOffset, newLine, and newBaseNote
        // variables represent the new note this current note would be tuned to.

        // this will be null if there are no more accidentals to use
        var newAccidental = getNextAccidental(pitchData.implicitAccidental);
        // if true, denotes that the note should be spelt with a different baseNote.
        var usingEnharmonic = false;
        if (newAccidental === null) {
          // the current note is at its absolute max pitch
          usingEnharmonic = true;
          newAccidental = getOverLimitEnharmonicEquivalent(pitchData.baseNote);
        }

        // diesis offset of the accidental of the next base note at this point in time.
        var newOffset = convertAccidentalTypeToSteps(newAccidental);

        // If an enharmonic spelling is required while transposing upwards,
        // the new line is the note above it.
        var newLine = usingEnharmonic ? getNextLine(pitchData.line) : pitchData.line;

        // <UP DOWN VARIANT CHECKPOINT> (use getPrevNote for downwards transposition)
        var newBaseNote = usingEnharmonic ? getNextNote(pitchData.baseNote) : pitchData.baseNote;

        var nextNoteEnharmonics = getEnharmonics(newBaseNote, newOffset);

        // Step 1b. if the new note fits perfectly into the key signature, use that key signature's accidental instead.

        // check if the current newBaseNote has an offset exactly that of the
        // key signature (this may seem unecessary, but different accidentals
        // may have the same step offset, e.g., #v = ^ = +1)
        // e.g. key signature has Cv, the new note is set to Cb^ instead,
        //      this will make Cb^ be spelt as Cv instead.
        if (parms.currKeySig[newBaseNote].offset == newOffset) {
          newAccidental = parms.currKeySig[newBaseNote].type;
          newOffset = parms.currKeySig[newBaseNote].offset; // this is redundant but OCD lol.
        }

        // check if the enharmonic that's above newBaseNote (if any) has offset exactly that
        // matches the key signature.
        // e.g. key signature has Db, the new note is set to C#^.
        //      this will make C#^ be spelt as Db instead.
        else if (nextNoteEnharmonics.above &&
                 parms.currKeySig[nextNoteEnharmonics.above.baseNote].offset == nextNoteEnharmonics.above.offset) {
          newBaseNote = nextNoteEnharmonics.above.baseNote;
          newLine -= 1;
          newAccidental = parms.currKeySig[nextNoteEnharmonics.above.baseNote].type;
          newOffset = parms.currKeySig[nextNoteEnharmonics.above.baseNote].offset;
        }

        // check if the enharmonic that's below newBaseNote (if any) has offset exactly that
        // matches the key signature.
        // e.g. key signature has B natural, the new note is set to Cbv.
        //      this will make Cbv be spelt as B instead.
        else if (nextNoteEnharmonics.below &&
                 parms.currKeySig[nextNoteEnharmonics.below.baseNote].offset == nextNoteEnharmonics.below.offset) {
          newBaseNote = nextNoteEnharmonics.below.baseNote;
          newLine += 1;
          newAccidental = parms.currKeySig[nextNoteEnharmonics.below.baseNote].type;
          newOffset = parms.currKeySig[nextNoteEnharmonics.below.baseNote].offset;
        }

        // Step 1c. If accidental offset of new note exceeds offset on the key signature
        //          of the enharmonic equivalent above/below (depending of the direction of the plugin)
        //          the new note, in the direction that the plugin is transposing,
        //          use the enharmonic equivalent spelling instead.
        //
        // e.g. key signature has Db, new note (going upwards) is C#+. The enharmonic equiv of C#+
        //      spelt with D is Dv, and Dv has an offset that exceeds Db (in the upwards direction),
        //      so the C#+ would be spelt as Dv instead.
        //

        // NOTE: the enharmonic to use, and the inequality to check of the downwards
        //       variant of this plugin will have to be inverted.
        // <UP DOWN VARIANT CHECKPOINT>

        if (nextNoteEnharmonics.above &&
            nextNoteEnharmonics.above.offset > parms.currKeySig[nextNoteEnharmonics.above.baseNote].offset) {
          newBaseNote = nextNoteEnharmonics.above.baseNote;
          newLine = getNextLine(newLine);
          newAccidental = convertStepsToAccidentalType(nextNoteEnharmonics.above.offset);
          newOffset = nextNoteEnharmonics.above.offset;
        }

        // Step 1d is a converse of clause 1c, it is implicitly implemented in the implementation
        // of the above clauses. YAY!

        // Step 1e. Check if new accidental corresponds exactly to the key signature accidental type and
        //          no prior explicit accidentals are in the bar. If so, the new note's accidental can be implicit.

        // before making the final explicit accidental NONE when it can be made implicit, store
        // the accidental it should represent. Used for Step 2. v. followingOldLine
        var newImplicitAccidental = newAccidental;

        var priorAccOnNewLine = getAccidental(cursor, pitchData.tick, newLine, true, parms, true);

        if (priorAccOnNewLine !== 'botched') {
          if (priorAccOnNewLine === null) {
            if (parms.currKeySig[newBaseNote].type == newAccidental) {
              newAccidental = Accidental.NONE;
            }
          }

          // Step 1f. Check the accidental state of accidentals prior to this note within the current bar.
          //          If the new transposed note's accidental type coincides with a prior accidental,
          //          its accidental can be made implicit...
          else if (newAccidental == priorAccOnNewLine.type) {
            // TODO: Is it really ok to do this even if the note now shares its line with other notes
            //       in the same chord?
            newAccidental = Accidental.NONE;
          }
        }

        // At the end of everything, evaluate usingEnharmonic to check whether the new note
        // would be on a different line than the original note.

        if (newLine != pitchData.line) {
          usingEnharmonic = true;
        }


        // Step 2. iterate through Elements till the end of the bar, or end of the score, whichever first.
        //         Find the immediate notes that shares the old note.line and the newLine properties.
        //
        //         If the note after transposition is spelt enharmonically, the definition of
        //         'immediate notes' includes the above, AND also all the notes within the same chord
        //         that shares the saem line as the note AFTER transposition.

        // if not undefined, noteOnSameOldLineAfter takes the place of followingOldLine.
        // (see above references to noteOnSameOldLineAfter / notesOnSameNewLine for documentation)
        var followingOldLine = parms.noteOnSameOldLineAfter;

        // Same as followingOldLine, but the following note does not share the same chord as
        // the current note.
        var followingOldLineNewSegment;

        // Contains the nearest note sharing the same line as the line of the note after tranposition.
        // This note element is NOT in the same chord segment as the current transposed note.
        // Will be undefined if note is not enharmonically spelt.
        var followingNewLine;
        // contains an array of notes within the same chord that would share the
        // same line as the note after transposition.
        // THIS ONLY APPLIES IF THE note WAS ENHARMONICALLY SPELT IN THE FIRST PLACE
        // IGNORE THIS IF usingEnharmonic is false!!
        var sameChordNewLine = parms.notesOnSameNewLine;

        var toRemoveAccidentals = [];

        var tickOfNextBar = -1; // if -1, the cursor at the last bar

        for (var i = 0; i < parms.bars.length; i++) {
          if (parms.bars[i] > cursor.tick) {
            tickOfNextBar = parms.bars[i];
            break;
          }
        }

        var tickOfThisBar = -1; // this should never be -1

        for (var i = 0; i < parms.bars.length; i++) {
          if (parms.bars[i] <= cursor.tick) {
            tickOfThisBar = parms.bars[i];
          }
        }


        // Loop through all elements until end of bar to find the next following notes
        // that share the same old and new line.
        var thisCursorVoice = cursor.voice;
        var thisStaffIdx = cursor.staffIdx;
        for (var voice = 0; voice < 4; voice ++) {
          // go to start of this bar
          cursor.rewind(1);
          cursor.voice = voice;
          cursor.staffIdx = thisStaffIdx;
          cursor.rewind(0);

          while (cursor.tick < tickOfThisBar && cursor.nextMeasure());

          while (cursor.segment && (tickOfNextBar === -1 || cursor.tick < tickOfNextBar)) {
            if (cursor.element && cursor.element.type == Ms.CHORD) {
              var graceChords = cursor.element.graceNotes;
              for (var i = 0; i < graceChords.length; i++) {
                // iterate through all grace chords
                var notes = graceChords[i].notes;
                for (var j = 0; j < notes.length; j++) {
                  var ntick = notes[j].parent.parent.tick;
                  if (notes[j].line == note.line && ntick > pitchData.tick) {
                    if (!followingOldLine || (followingOldLine && ntick < followingOldLine.parent.parent.tick))
                      followingOldLine = notes[j];
                    if (!followingOldLineNewSegment ||
                        (followingOldLineNewSegment && ntick < followingOldLineNewSegment.parent.parent.tick))
                      followingOldLineNewSegment = notes[j];
                  } else if (usingEnharmonic &&
                      (!followingNewLine ||
                        (followingNewLine && ntick < followingNewLine.parent.parent.tick)) &&
                      notes[j].line == newLine && ntick > pitchData.tick)
                    followingNewLine = notes[j];
                }
              }
              var notes = cursor.element.notes;
              for (var i = 0; i < notes.length; i++) {
                var ntick = notes[i].parent.parent.tick;
                if (notes[i].line == note.line && ntick > pitchData.tick) {
                  if (!followingOldLine || (followingOldLine && ntick < followingOldLine.parent.parent.tick))
                    followingOldLine = notes[i];
                  if (!followingOldLineNewSegment || (followingOldLineNewSegment && ntick < followingOldLineNewSegment.parent.parent.tick))
                    followingOldLineNewSegment = notes[i];
                } else if (usingEnharmonic &&
                    (!followingNewLine || (followingNewLine && ntick < followingNewLine.parent.parent.tick)) &&
                    notes[i].line == newLine && ntick > pitchData.tick)
                followingNewLine = notes[i];
              }
            }
            cursor.next();
          }
        }

        setCursorToPosition(cursor, pitchData.tick, thisCursorVoice, thisStaffIdx);

        // At this point followingOldLine and followingNewLine would be populated
        // with note objects that would have their pitch value affected if they had
        // implicit accidentals, or notes that can have their accidentals made implicit
        // due to the transposition of the current note.
        //
        // NOTE: followingNewLine will be empty if usingEnharmonic is false.
        //       and both followingNew and followingOld are nullable values.

        if (followingOldLine) {
          console.log('followingOldLine: ' + followingOldLine.line + ' @ ' + followingOldLine.parent.parent.tick +
                      ', acc: ' + convertAccidentalTypeToName(0 + followingOldLine.accidentalType));
          // Check if explicit accidental can be removed from followingOldLine
          // (this implicitly covers logical case i.)
          if (followingOldLine.accidentalType != Accidental.NONE) {
            // An explicit accidental already exists on the this following note.

            // Logical cases iv. AND (v. or vi.) have to be fulfilled in order to justify
            // making the explicit accidental implicit.

            // iv. accidentals must remain explicit if the chord that the followingOldLine
            //     Note is in has other notes that share the same line.

            var ns = followingOldLine.parent.notes;
            var nNotesInSameLine = 0;
            for (var i = 0; i < ns.length; i++) {
              if (ns[i].line === followingOldLine.line)
                nNotesInSameLine++;
            }

            var followingOldIsInNextSegment = parms.noteOnSameOldLineAfter === undefined;

            if (nNotesInSameLine === 1 ||
              (!followingOldIsInNextSegment && usingEnharmonic && nNotesInSameLine <= 2)) {
              // case iv. passes
              // note that if the current note is going to be enharmonically spelt,
              // then it is ok to have 2 notes currently in the same line in the same
              // chord as the current note, because this current note is going to be moved out of the way.

              // testing case v.: new accidental maybeKeySig render the accidental on the next note that is on the line obsolete.
              // right now we're only dealing with non enharmonic spelling - no need to consider the precence of
              // other notes sharing the same line as the new spelling as the notes are arranged in a predictable order.
              if (!usingEnharmonic && newImplicitAccidental == followingOldLine.accidentalType) {
                toRemoveAccidentals.push(followingOldLine);
              } else if (usingEnharmonic) {

                // testing case vi.: transposed note is enharmonic, moves out of the way, and
                // exposes a prior accidental which makes the explicit accidental on the next
                // note on the old line redundant.

                // priority 1: same chord, same line, the note just before the following note has an accidental.
                // NOTE: at first, this may seem to have a chance of being a botched value as the note before
                //       could have been an enharmonically transposing note that was transposed from a previous
                //       line up to this line that is now the 'same line', and the order of accidentals on that line
                //       is indeterminate.
                //       However, the fact that case iv. passes shows that after this note gets transposed,
                //       the accidental at this line will become determinate and would equate to whatever is left
                //       on that line.
                var priorAccidental = parms.accOnSameLineBefore;

                console.log(priorAccidental);

                // NOTE: if case iv. passes showing that there's only up to 2 notes in this line,
                // the nullability of accOnSameLineBefore and noteOnSameOldLineAfter is
                // MUTUALLY EXCLUSIVE.
                //
                // If accOnSameLineBefore exists, this note is the note that comes after it,
                // and thus followingOldLine is DEFINITELY in another segment, which ensures
                // accOnSameLineBefore's status of being the most recent accidental to followingOldLine.
                //
                // If noteOnSameOldLineAfter exists, this note is the note that comes before it,
                // and followingOldLine is EQUAL to noteOnSameOldLineAfter, which means that the accidentals
                // BEFORE this chord all apply to the accidentals ON this chord, thus priority 2
                // handles this situation.
                //
                // If neither exists, it means that the followingOldLine is on a line
                // on its own, and after the transposition operation is complete there will be
                // NO MORE notes in this chord on the old line, therefore the only accidentals that
                // may affect the followingOldLine are acccidentals PRIOR to this chord,
                // hence PRIORITY 2 ALSO HANDLES THIS SITUATION. DO NOT PANIC.

                // will be true if there are two notes on the same line in the same chord
                // makes it impossible to determine if a future accidental can be made implicit
                // (read the following comments for further documentation)
                // If true, both priority 2 and 3 will be void, and it will be a NO-OP for case vi.
                var botchedDoubleLine = false;

                // priority 2: use accidental state at time of previous chord
                if (priorAccidental === undefined) {

                  // NOTE: This issue has been fixed with the stateless accidental system.
                  //      XXX: BOTCHED LINE ACCIDENTAL PROBLEM:
                  //      if the previous chord contains notes that were previously transposed
                  //      enharmonically and ends up sharing a line with other notes in the same chord as a result of that,
                  //      the accidental state of the previous chord will be BOTCHED completely
                  //      at the line position where there are multiple notes.
                  //
                  //      Thus it is necessary to check first if any prior chord in this bar
                  //      has multiple notes sharing the same line within the chord as the line that
                  //      the followingOldLine note is on! If so, this operation has to be terminated
                  //      and the accidental cannot be made implicit without the plugin having to do guess work.
                  //
                  //      Even priority 3 (key signature) will have to be cancelled as it is uncertain
                  //      what exactly is the accidental at that point in time.
                  //
                  //      HOWEVER, if the backwards traversing cursor detects an explicit accidental
                  //      that belongs to a SINGLE note that doesn't share it's line with any others in the chord,
                  //      on the same line as followinOldLine, it is a sign that the accidental state at that position
                  //      onwards is NOT botched, and it SHOULD use that accidental it has found as the
                  //      priorAccidental value.
                  //
                  //      If there are no explicit accidentals but also no error-causing double-note-line chords,
                  //      then the algorithm can move on to priority 3: key signatures.

                  var recAcc = getAccidental(cursor, pitchData.tick, followingOldLine.line, true, parms, true);

                  if (recAcc === 'botched')
                    botchedDoubleLine = true;
                  else if (recAcc !== null)
                    priorAccidental = recAcc.type;

                } // end of priority 2 check

                // Priority 3. if no explicit accidentals in this bar, use key signature.
                if (!botchedDoubleLine && priorAccidental === undefined) {
                  var keySigAcc = parms.currKeySig[pitchData.baseNote].type;

                  priorAccidental = keySigAcc;
                }

                // Finallly if not botched double line, use the priorAccidental value to determine
                // whether or not to make the followingOldLine note's accidental implicit.

                if (!botchedDoubleLine) {
                  if (priorAccidental !== undefined && followingOldLine.accidentalType == priorAccidental) {
                    toRemoveAccidentals.push(followingOldLine);
                  }
                }
                // end of test for case vi.
                // NOTE: the code in this scope is still in the usingEnharmonic clause!

                // case vii. if note is enharmonic, and shares the line with 1 other note (already covered by case iv.)
                //           Once this note is transposed, the double note line status is removed, and the
                //           following note on the old line in a subsequent segment can have it's protection courtesy
                //           accidental reevaluated based on the accidental state BEFORE this current chord,
                //           and also based on the explicit accidental that remains on the old line on this chord,
                //           if it exists.

                if (followingOldLineNewSegment && followingOldLineNewSegment.accidental) {
                  var accInThisChordOnOldLine;
                  for (var i = 0; i < parms.chordExcludingSelf.length; i++) {
                    var x = parms.chordExcludingSelf[i];
                    if (x.line == followingOldLineNewSegment.line) {
                      if (x.accidental && x.accidentalType == followingOldLineNewSegment.accidentalType) {
                        accInThisChordOnOldLine = x.accidentalType;
                      }
                      // safe to break here as case iv. assserts that there will only be 1 note
                      // that should fulfill this condition within the chordExcludingSelf array.
                      break;
                    }
                  }
                  var botched = false;
                  if (accInThisChordOnOldLine === undefined) {
                    if (cursor.measure.firstSegment.tick != pitchData.tick) {
                      var recAcc = getAccidental(cursor, note.parent.parent.tick, followingOldLine.line, true, parms, true);
                      if (recAcc == 'botched')
                        botched = true;
                      else if (recAcc !== null)
                        accInThisChordOnOldLine = recAcc.type;
                      }
                  }

                  if (!botched && accInThisChordOnOldLine === undefined) {
                    // use key signature if no explicit or implicit accidental state.
                    accInThisChordOnOldLine = parms.currKeySig[pitchData.baseNote].type;
                  }

                  if (!botched && accInThisChordOnOldLine === followingOldLineNewSegment.accidentalType) {
                    // the transposed note un-botches a line which gives way to an accidental which matches
                    // that of the following note in a subsequent segment in the same line as the note prior
                    // to transposition, and thus the following note's accidental can be made implicit.
                    toRemoveAccidentals.push(followingOldLineNewSegment);
                  }
                }
              }
            }
          } // end of cases iv. - vii. (making accidental implicit) for old line.

          // check if accidental has to be made explicit from followingOldLine
          else {
            // in this clause, there are no explicit accidentals on followingOldLine.
            // note: logical case i. is already implicitly covered by the above if clause

            // logical case ii. if the new accidental matches the immediate note on the line
            // it's on, there's no need to make the followingOldLine explicit.
            // N/A

            // case iii. if current note is prior to transposition is implicit AND is
            // moving out of the way (usingEnharmonic), thus the following note does
            // not need any explicit accidental as a common explicit accidental prior
            // to the current and following note has affected both notes.
            var caseIII = usingEnharmonic && pitchData.explicitAccidental === undefined;

            console.log('case iii: ' + caseIII);

            if (!caseIII) {
              // the implicit accidental on the following line should be made explicit.
              // pitchData contains the implicit accidental of the current note that
              // would be transposed later, so that accidental should be made
              // explicit on the following note to prevent the following note
              // from changing pitch when the current note transposes.
              followingOldLine.accidentalType = pitchData.implicitAccidental;
            }
          }
        } // end of accidental checks for followingOldLine

        if (followingNewLine) {
          // the presence of followingNewLine also means usingEnharmonic is true by default.
          // this limits which cases would apply.
          if (sameChordNewLine.length == 0 &&
              followingNewLine.accidental && followingNewLine.accidentalType != Accidental.NONE) {
            // An explicit accidental already exists on the this following note.

            // Logical cases iv. AND (v. or vi.) have to be fulfilled in order to justify
            // making the explicit accidental implicit.

            // iv. accidentals must remain explicit if the chord that the followingNewLine
            //     Note is in has other notes that share the same line.

            // case iv. passes BY DEFAULT as check for sameChordNewLine.length == 0 is made.

            // testing case v.: new accidental may render the accidental on the following note obsolete.
            // When dealing with new line, it only applies when the new line the note gets transposed to
            // does not share its line with any other note in the current chord, as otherwise, it
            // will cause the accidental to be indeterminate.
            // This check has already been made in the above `sameChordNewLine.length == 0`
            if (newAccidental == followingNewLine.accidentalType) {
              toRemoveAccidentals.push(followingNewLine);
            }

            // NOTE: case vi. and vii. do not apply to the note on the new line.

          } // end of making explicit accidental implicit checks

          // check if implicit accidental has to be made explicit.
          else {
            // there are no explicit accidentals on the followingNewLine.
            // Add an explicit accidental unless case ii. is true.
            // NOTE: case iii. is not applicable as it only applies to the oldLine.

            // case ii. if the new accidental matches the immediate note on the line
            // it's on, there's no need to make the followingNewLine explicit.

            var newAccMatchFollowingLine = newAccidental == followingNewLine.accidentalType;

            // except if multiple notes share the new line in the chord of followingNewLine
            var ns = followingNewLine.parent.notes;
            var nSameLineFollowing = 0;
            for (var i = 0; i < ns.length; i++) {
              if (ns[i].line === followingNewLine.line)
                nSameLineFollowing ++;
            }

            // except if multiple notes would share the new line after this note
            // is transposed enharmonically.
            var multiNoteLinesInThisChordOnLineAfterTranspose = sameChordNewLine.length != 0;

            var caseII = newAccMatchFollowingLine && nSameLineFollowing == 1 && !multiNoteLinesInThisChordOnLineAfterTranspose;

            if (!caseII) {
              // the implicit accidental on the following line should be made explicit.

              // get current implicit accidental value of followingNewLine
              // do not worry about botched accidentals as the plugin will ensure that if
              // a prior transposition would have botched this line, the note on followingNewLine
              // would have had an explicit accidental instead of an implicit accidental, which is
              // the case of this clause.

              var accObj = getAccidental(cursor, followingNewLine.parent.parent.tick, followingNewLine.line, false, parms);

              var expAcc;
              if (accObj != null)
                expAcc = accObj.type;
              else
                expAcc = parms.currKeySig[newBaseNote].type;

              followingNewLine.accidentalType = expAcc;
            }
          } // end checking for implicit accidentals to be made explicit.

          // If this chord has existing notes on the line that the current note
          // would be transposed enharmonically to after operation, ensure that
          // all of those notes are given an explicit accidental if they don't
          // already have one.
          for (var i = 0; i < sameChordNewLine.length; i++) {
            var n = sameChordNewLine[i];
            if (!n.accidental || n.accidentalType == Accidental.NONE) {
              var accObj = getAccidental(cursor, n.parent.parent.tick, n.line, false, parms);

              var expAcc;
              if (accObj != null)
                expAcc = accObj.type;
              else
                expAcc = parms.currKeySig[newBaseNote].type;

              n.accidentalType = expAcc;
            }
          }
        } // End of accidental checks for followingNewLine


        // Step 3. Finally. Set the new note's pitch and tuning.

        // The order is very important!
        // 1. line
        // 2. accidentalType
        // 3. tuning

        note.line = newLine;

        // Important to clear the accidental first. If existing accidental type
        // is a non-standard accidental, and the new assigned accidental type is standard,
        // the new assigned accidental type would affect the tpc of the note, but
        // the existing non-standard accidental still displays instead of the new one.
        note.accidentalType = Accidental.NONE;
        note.accidentalType = newAccidental;

        console.log('new baseNote: ' + newBaseNote + ', line: ' + newLine +
                    ', explicit accidental: ' + convertAccidentalTypeToName(newAccidental) +
                    ', offset: ' + newOffset + ', enharmonic: ' + usingEnharmonic)

        note.tuning = centOffsets[newBaseNote][newOffset];


        // Step 4. Remove accidentals on all marked notes.

        for (var i = 0; i < toRemoveAccidentals.length; i++) {
          toRemoveAccidentals[i].accidentalType = Accidental.NONE;
        }

        return;
      }

      onRun: {
        console.log("hello 31tet");

        if (typeof curScore === 'undefined')
              Qt.quit();

        var parms = {};

        /*
          Naturalized default key signature
        */
        parms.naturalKeySig = {
          'c': {offset: 0, type: Accidental.NATURAL},
          'd': {offset: 0, type: Accidental.NATURAL},
          'e': {offset: 0, type: Accidental.NATURAL},
          'f': {offset: 0, type: Accidental.NATURAL},
          'g': {offset: 0, type: Accidental.NATURAL},
          'a': {offset: 0, type: Accidental.NATURAL},
          'b': {offset: 0, type: Accidental.NATURAL}
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
        parms.currKeySig = parms.naturalKeySig

        applyToNotesInSelection(tuneNote, parms);
        Qt.quit();
      }
}
