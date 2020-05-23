import QtQuick 2.1
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import MuseScore 3.0

MuseScore {
      version:  "1.3.7"
      description: "Retune selection to 31-TET in Enharmonic Ups & Downs mode (Dbb is C), or whole score if nothing selected."
      menuPath: "Plugins.31-TET.Retune 31-TET (Enharmonic Ups and Downs)"

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

      function convertAccidentalTextToAccidentalType(accStr) {
        switch(accStr.trim()) {
        case 'bb':
          return Accidental.FLAT2;
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
        case 'x':
          return Accidental.SHARP2;
        default:
          return Accidental.NATURAL;
        }
      }

      function convertAccidentalTypeToSteps(accType) {
        switch (accType) {
        case Accidental.FLAT2 :
          return -5;
        case Accidental.MIRRORED_FLAT2 :
          return -4;
        case Accidental.FLAT_ARROW_DOWN :
          return -3;
        case Accidental.FLAT:
          return -2;
        case Accidental.NATURAL_ARROW_DOWN:
        case Accidental.FLAT_ARROW_UP :
          return -1;
        case Accidental.NATURAL:
          return 0;
        case Accidental.NATURAL_ARROW_UP:
        case Accidental.SHARP_ARROW_DOWN :
          return 1;
        case Accidental.SHARP:
          return 2;
        case Accidental.SHARP_ARROW_UP :
          return 3;
        case Accidental.SHARP_SLASH4 :
          return 4:
        case Accidental.SHARP2:
          return 5;
        }
      }

      // NOTE: This function may differ between upwards and downwards variants of
      //       the plugin as some tuning systems (e.g. 31 ups and downs) will have
      //       enharmonic equivalents between two different types of accidentals
      //
      //       e.g.: C#v and C^.
      function convertStepsToAccidentalType(steps) {
        switch(steps) {
        case -5:
          return Accidental.FLAT2;
        case -4:
          return Accidental.MIRRORED_FLAT2;
        case -3:
          return Accidental.FLAT_ARROW_DOWN;
        case -2:
          return Accidental.FLAT;
        case -1:
          return Accidental.FLAT_ARROW_UP; // NOTE: in downwards variant, use NATURAL_ARROW_DOWN instead
        case 0:
          return Accidental.NATURAL;
        case 1:
          return Accidental.NATURAL_ARROW_UP; // NOTE: in downwards variant, use SHARP_ARROW_DOWN instead
        case 2:
          return Accidental.SHARP;
        case 3:
          return Accidental.SHARP_ARROW_UP;
        case 4:
          return Accidental.SHARP_SLASH4;
        case 5:
          return Accidental.SHARP2;
        }
      }

      // Returns the accidental after it has been transposed up (or down if the plugin is for transposing down)
      // will return null if there are no more accidentals that are higher (or lower) than acc.
      // acc: a value from the Accidental enum
      function getNextAccidental(acc) {
        switch(acc) {
        case Accidental.FLAT2:
          return Accidental.MIRRORED_FLAT2;
        case Accidental.MIRRORED_FLAT2:
          return Accidental.FLAT_ARROW_DOWN;
        case Accidental.FLAT_ARROW_DOWN:
          return Accidental.FLAT;
        case Accidental.FLAT:
          return Accidental.FLAT_ARROW_UP;
        case Accidental.FLAT_ARROW_UP:
        case Accidental.NATURAL_ARROW_DOWN:
          return Accidental.NATURAL;
        case Accidental.NATURAL:
          return Accidental.NATURAL_ARROW_UP;
        case Accidental.NATURAL_ARROW_UP:
        case Accidental.SHARP_ARROW_DOWN:
          return Accidental.SHARP;
        case Accidental.SHARP:
          return Accidental.SHARP_ARROW_UP;
        case Accidental.SHARP_ARROW_UP:
          return Accidental.SHARP_SLASH4;
        case Accidental.SHARP_SLASH4:
          return Accidental.SHARP2;
        case Accidental.SHARP2:
          return null;
        default:
          return null;
        }
      }

      // returns the accidental equivalent of the next baseNote after the current baseNote
      // at maximum accidental offset is exceeded.
      //
      // example: if the note is Bx, and there is no more accidental sharper than x,
      //          call this function with the argument 'b', and it will return Accidental.SHARP_ARROW_UP
      //          representing the note that is higher than Bx is C#^.
      //
      function getOverLimitEnharmonicEquivalent(baseNote) {
        switch(baseNote) {
        case 'c':
        case 'd':
        case 'f':
        case 'g':
        case 'a':
          return Accidental.NATURAL_ARROW_UP;
        default:
          return Accidental.SHARP_ARROW_UP;
        }
      }

      // returns enharmonics above and below
      // {
      //   above: {baseNote: 'a' through 'g', offset: diesis offset}
      //   below: {baseNote: 'a' through 'g', offset: diesis offset}
      // }
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
          offset: offset - 5;
        };
        below = below > 5 ? null : {
          baseNote: getPrevNote(baseNote),
          offset: offset + 5
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
          keySig[notes[i]] = {steps: accSteps, type: accType};
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
        // points a
        var initialCursorElement = cursor.element;
        cursor.rewind(1);
        var startStaff;
        var endStaff;
        var endTick;
        if (!cursor.segment) { // no selection
          // no action if no selection.
          console.log('nothing selected');
          Qt.quit();
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

            // Note: either ways, it is still necesssary to go to the start of the score before
            // applying to notes in selection as custom key signatures may precede the selection
            // that should still apply to the score.

            cursor.rewind(0); // goes to start of score, will reset voice to 0
            cursor.voice = voice;
            cursor.staffIdx = staff;

            var measureCount = 0;
            console.log("processing custom key signatures staff: " + staff + ", voice: " + voice);

            while (cursor.segment && (cursor.tick < endTick)) {

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

              cursor.next();
            }
          }

          // 2 passes - one to ensure all accidentals are represented acorss
          // all 4 voices, then the second one to apply those accidentals.
          for (var rep = 0; rep < 2; rep++) {
            for (var voice = 0; voice < 4; voice++) {

              cursor.voice = voice; //voice has to be set after goTo
              cursor.staffIdx = staff;

              cursor.rewind(rep == 0 ? 0 : 1); // goes to start of selection, will reset voice to 0

              var measureCount = 0;

              console.log("processing staff: " + staff + ", voice: " + voice);

              // Loop elements of a voice
              while (cursor.segment && (cursor.tick < endTick)) {
                // Note that the parms.accidentals object now stores accidentals
                // from all 4 voices in a staff since microtonal accidentals from one voice
                // should affect subsequent notes on the same line in other voices as well.
                if (cursor.segment.tick == cursor.measure.firstSegment.tick && voice === 0 && rep === 0) {
                  // once new bar is reached, denote new bar in the parms.accidentals.bars object
                  // so that getAccidental will reset. Only do this for the first voice in a staff
                  // since voices in a staff shares the same barrings.
                  if (!parms.accidentals.bars)
                    parms.accidentals.bars = [];

                  parms.accidentals.bars.push(cursor.segment.tick);
                  measureCount ++;
                  console.log("New bar - " + measureCount);
                }

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
                      for (var j = 0; j < notes.length; j++) {
                        // noteOnSameLineAfter contains the note object on the same line in the
                        // same chord that is directly after this current note, if any.
                        // this value, if present, takes the place of the immediate next note on the same line
                        // at a following segment within this bar.
                        if (notes[j + 1] && notes[j + 1].line === notes[j].line)
                          parms.noteOnSameLineAfter = notes[j + 1];
                        func(notes[j], cursor.segment, parms, cursor, rep == 0);
                        parms.noteOnSameLineAfter = undefined;
                      }
                    }
                    var notes = cursor.element.notes;
                    for (var i = 0; i < notes.length; i++) {
                      var note = notes[i];
                      if (notes[i + 1] && notes[i + 1].line === note.line)
                        parms.noteOnSameLineAfter = notes[i + 1];
                      func(note, cursor.segment, parms, cursor, rep == 0);
                      parms.noteOnSameLineAfter = undefined;
                    }
                  }
                }
                cursor.next();
              }
            }
          }
        }
      }

      // This will register an explicit accidental's offset value and tick position.
      // Unified accidental registry is necessary so that special accidentals across
      // different voices in the same staff will affect each other as it should.
      //
      // Unlike, the tuning-only variants of this plugin, ALL accidentals have to be
      // registered as the accidental state has to be kept track of very closely.
      //
      // Remember to reset the parms.accidentals array after every bar & staff!
      function registerAccidental(notePitchData, parms) {
        var noteLine = notePitchData.line;
        var tick = notePitchData.tick;
        var diesisOffset = notePitchData.diesisOffset;
        var accType = notePitchData.explicitAccidental;

        // validity check:
        if (accType === undefined || accType === null) {
          console.log('invalid state! tried registering accidental null/undefined explicitAccidental property.');
          alert('invalid state! tried registering accidental null/undefined explicitAccidental property.');
          Qt.quit();
        }

        if (!parms.accidentals[noteLine]) {
          parms.accidentals[noteLine] = [];
        }

        // check if an existing accidental exists on that line at that specific tick.
        // if so, perform an update instead of creating a new entry.
        for (var i = 0; i < parms.accidentals[noteLine].length; i ++) {
          var accObj = parms.accidentals[noteLine][i];
          if (accObj.tick === tick) {
            accObj.offset = diesisOffset;
            return;
          }
        }

        parms.accidentals[noteLine].push({
          tick: tick,
          offset: diesisOffset,
          type: accType
        });
      }

      // removes a specific accidental at a specific noteLine and tick position.
      // note that it is entirely possible for the same line and tick position to have
      // 2 different accidentals (e.g. D and D# on the same line at the same time)
      // thus, it is important to remove the correct accidental.
      function removeAccidental(accidentalType, noteLine, tick, parms) {
        if (!parms.accidentals[noteLine])
          return;

        var indexMarkedForRemoval = -1;
        for (var i = 0; i < parms.accidentals[noteLine].length; i ++) {
          var accObj = parms.accidentals[noteLine][i];
          if (accObj.tick === tick && accObj.type == accidentalType) {
            indexMarkedForRemoval = i;
            break;
          }
        }

        if (indexMarkedForRemoval !== -1)
          parms.accidentals[noteLine].splice(indexMarkedForRemoval, 1);
        else
          console.log('warning: removeAccidental called but found no accidentals to remove');
      }

      // WARNING: DON'T USE !getAccidental () to check for Null because !0 IS TRUE!
      // NOTE: This returns an accidental object instead of just a single offset number
      //       unlike the tuning-only variants of this plugin.
      //
      // returns accidental object or null if no accidental after the start of the bar at tick & line position:
      // {
      //    offset: number of diesis offset,
      //    type: accidental type as Accidental enum value
      // }
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
        var accObj = null;

        if (!parms.accidentals[noteLine])
          return null;

        for (var i = 0; i < parms.accidentals[noteLine].length; i++) {
          var acc = parms.accidentals[noteLine][i];

          // Accidentals only count if
          // 1. They are in the same bar as the current note
          // 2. They are before or at the current note's tick
          // 3. It is the most recent accidental that fulfills 1. and 2.
          if (acc.tick >= mostRecentBar && acc.tick <= tick && acc.tick > oldTick) {
            console.log('note line: ' + noteLine + ', diesis: ' + acc.offset + ', tick: ' + acc.tick);
            console.log('acc.tick: ' + acc.tick + ', mostRecentBar: ' + mostRecentBar + ', tick: ' + tick + ', oldTick: ' + oldTick);
            accObj = acc;
            oldTick = acc.tick;
          }
        }

        return accObj;
      }

      // returns an object with info on note pitch:
      // {
      //    baseNote: a string from 'a' to 'g',
      //    line: the note.line property referring to height of the note on the staff
      //    tpc: the tonal pitch class of the note (as per note.tpc)
      //    tick: the tick position of the note
      //    explicitAccidental: Accidental enum of the explicit accidental attatched to this note (if any)
      //    implicitAccidental: Accidental enum of the implicit accidental of this note (non null)
      //                        (if explicitAccidental exists, implicitAccidental = explicitAccidental)
      //    diesisOffset: the number of edo steps offset from the base note this note is
      // }
      //
      function getNotePitchData(note, parms) {
        var tpc = note.tpc;
        var acc = note.accidentalType;
        var noteData = {};

        noteData.line = note.line;
        noteData.tpc = tpc;
        noteData.explicitAccidental = acc;
        noteData.tick = note.tick;

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

        var irregularAccidentalOrNatural = !noteData.baseNote;

        // in the event that tpc is considered natural by
        // MuseScore's playback, it would mean that it is
        // either a natural note, or a microtonal accidental.

        if (irregularAccidentalOrNatural) {
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

          noteData.baseNote = baseNote;
        }

        if (note.accidental) {
          noteData.explicitAccidental = note.accidental;
          noteData.implicitAccidental = explicitAccidental;

          if (irregularAccidentalOrNatural) {
            var accOffset = null;
            if (note.accidentalType == Accidental.MIRRORED_FLAT2)
              accOffset = -4;
            else if (note.accidentalType == Accidental.FLAT_ARROW_DOWN)
              accOffset = -3;
            else if (note.accidentalType == Accidental.NATURAL_ARROW_DOWN ||
                     note.accidentalType == Accidental.FLAT_ARROW_UP)
              accOffset = -1;
            else if (note.accidentalType == Accidental.NATURAL)
              accOffset = 0;
            else if (note.accidentalType == Accidental.NATURAL_ARROW_UP ||
                     note.accidentalType == Accidental.SHARP_ARROW_DOWN)
              accOffset = 1;
            else if (note.accidentalType == Accidental.SHARP_ARROW_UP)
              accOffset = 3;
            else if (note.accidentalType == Accidental.SHARP_SLASH4)
              accOffset = 4;

            noteData.diesisOffset = accOffset;
          }
        }

        // Check for prev accidentals first, will be null if not present
        var prevAcc = getAccidental(note.line, segment.tick, parms);
        if (prevAcc !== null) {
          noteData.implicitAccidental = prevAcc.type;
          noteData.diesisOffset = prevAcc.offset;
        } else {
          // No accidentals - check key signature.
          var keySig = parms.currKeySig[baseNote];
          noteData.implicitAccidental = keySig.type;
          noteData.diesisOffset = prevAcc.steps;
        }
      }

      function tuneNote(note, segment, parms, cursor, scanOnly) {

        // if in first-pass scanning mode, the only job is to populate the
        // accidental state.
        if (scanOnly) {
          var data = getNotePitchData(note, parms);
          if (data.explicitAccidental) {
            registerAccidental(data, parms)
          }
          return;
        }

        // See: https://musescore.org/en/node/305667
        // setting accidentalType property calls Score::changeAccidnetal(), which
        // uses the line number attribute to derive the tpc value,
        // then, the tpc is overwritten.

        // In order to change the pitch of an existing note, the correct order of operations would be
        // 1. set Line number
        // 2. set accidental
        // 3. set tuning

        // Process:
        //
        // 0. Identify exactly what this note WAS. Remember and save it.
        //     - alphabet
        //     - Line
        //     - accidental type (even if it is implicit)
        //
        //    To do this right, getAccidental() would be paired with registerAccidental() and
        //    removeAccidental() to keep the accidental state updated as the cursor iterates
        //    through the notes. Also, accidentals will be created and destroyed
        //    based
        //
        // 1. Evaluate what this note is going to be at after transposing
        //     - which line
        //     - which accidental
        //
        //    a. Next, determine how the new note would be spelt according to normal standards if there are
        //       no key signatures.
        //
        //       31 ups and downs:
        //          upwards: bb, db, bv, b, b^, natural, ^, #, #^, #+, x
        //          downwards: x, #+, #^, #, #v, natural, v, b, bv, db, bb
        //
        //       31 meantone:
        //          upwards / downwards: bb, db, b, d, natural, +, #, #+, x (same in both directions)
        //
        //       22 super:
        //          upwards / downwards: bv, b, b^, v, natural, ^, #v, #, #^ (same both directions)
        //

        //       the following clauses, c. and d. outlines when it is necessary to shift to a different
        //       enharmonic spelling of the interval.
        //
        //    b. First. identify if the new note fits exactly into an existing key signature.
        //       Key signatures would take precedence over all enharmonic equivalences.
        //         | Sadly, default non-custom key signatures are NOT detectable by this plugin,
        //         | so in order for this feature to work properly, ALL key signatures, custom or default
        //         | should come with a textual annotation describing the key signature to the plugin.
        //
        //       e.g. if the key signature has an Eb, and the note to be transposed up is D#.
        //            By right, transposing up should favour accidentals representing upward movements,
        //            thus the new note should be D#^.
        //            However, because the key signature contains an Eb, and Eb is the enharmonic equivalent of D#^,
        //            the new transposed note should be an Eb instead.
        //

        //    c. Next, if the new note would have had an enharmonic equivalent that EXCEEDS the pitch
        //       (in the direction that it is being tranposed) of the following line's key signature,
        //       PLEASE move it to the next line.
        //       No one would want to read a D that sounds higher than an E.
        //
        //       e.g. if the key signature has a Cb, and the note to be transposed up is B#,
        //            the new note would be B#^ (which is enharmonically C natural), which is
        //            higher in pitch than Cb. In fact, B# is already higher than Cb and this
        //            scenario would only happen if someone explicitly placed a sharp on the B.
        //            The B#^ would be spelt as a C instead.
        //

        //    d. And conversely to c., if the new note would have had an enharmonic equivalent that
        //       doesn't exceed the pitch of the following line's key signature,
        //       do NOT move to the next line unless absolutely neccessary, e.g. when there are no more
        //       enharmonics available on the current line.
        //
        //       e.g. if the key signature has a Cb and a Bdb, and the note to be tranposed down is
        //            C, the new note should be spelt as Cv, and not B#, as B# is not lower than
        //            the pitch of Bdb.
        //
        //            However, if the note to be transposed down is Cbb already (which is enharmonically Bb),
        //            then the new note has to be spelt Bbv as per clause b. as there are no
        //            notes below Cbb that are spelt with C.
        //

        //    e. If there is no accidental history within this bar for this particular note line,
        //       check if this note's ACCIDENTAL TYPE (not offset!) coincides with the key signature,
        //       and if it does, it is not necessary to create an explicit accidental for this note.
        //       (Set to Accidental.NONE)

        //    f. Finally check if amongst the accidental list if the accidental that this new
        //       note would've had would coincide with an accidental that already previously existed somewhere
        //       prior to this one in the same bar, and if so, it is not necessary to create an explicit
        //       accidental for this note. (Set to Accidental.NONE)

        // 2. Call registerAccidental and removeAccidental to update the accidental state according
        //    to the new transposed note.
        //
        //    registerAccidental will be called:
        //      - for the new transposed note's new accidental (when it is explicit).
        //
        //    removeAccidental will be called:
        //      - When the new tranposed note's new accidental is set to implicit (Accidental.NONE)
        //
        //      - If the new tranposed note is now spelt with an enharmonic, the accidental on the
        //        note.line value of the transposed note prior to transposing should be removed.
        //
        //        e.g. Dx is now tranposed to E^. so the accidental on the note.line of D should be removed
        //             as it is no longer there.
        //
        //    At this stage, the new transposed note is FINALIZED. However, DO NOT
        //    update the note properties just yet, as it would affect the perceived pitches of the following notes,
        //    should they coincide with the same 1 or 2 staff lines that the transposition of the note affects.

        // 3. Check for the first subsequent note in the same bar that shares the same note.line propeerty value
        //    with the note to-be-transposed
        //    AND if the note to-be-transposed would be shifted to a new line position
        //    (e.g. moving from A# to Bb, rather than A# to A#^), BOTH the
        //    note.line values of the transposed note before and after transposing
        //    has to be accounted for.
        //
        //    The first note that shares the same note.line (i.e. note alphabet & octave) on the staff
        //    as the transposed note (both before and after transposing) would have had their
        //    accidental history affected by the transposition of the current note.
        //
        //    Thus, it is required to append / remove accidentals on these 1 or 2 notes that would
        //    otherwise have changed its implicit accidental as a result of the transposition of this prior note.
        //
        //    XXX: Behavior of multiple notes on the same line & sharing the same stem (tick position) is
        //         VERY JANKY. The plugin should try to mitigate any unwanted behavior as much as possible.
        //
        //         The plugin should read successive notes on the same line in the order that they appear in
        //         the Chord.notes array. The first note in the array is the one to the left, the second and subsequent ones
        //         are the ones to the right.
        //         If there are successive notes on the same line sharing the same stem,
        //         they have to be treated as subsequent notes just as how two notes of the same line
        //         just as two notes on the same line across different tick time values.
        //
        //         The following scenarios represent notes in succession that may or may not
        //         share the same tick values, but notes are always in that order.
        //
        //         Musescore order the index of successive notes sharing the same tick from left to right
        //         in the order that their accidentals (and noteheads) appear.
        //
        //         Experiements are done to prove that musescore does not tamper with note index order within
        //         the Chord.notes array whilst pitches / lines are being edited.
        //
        //         the parms.noteOnSameLineAfter value contains the note element object of the
        //         note that is of the same chord and same line as the note, and immediately follows
        //         the note that is to be tuned.
        //
        //         This note, if present, takes the place of the note in another chord segment
        //         that has the same line as the OLD note line prior to transposing, as it would have come first.
        //
        //
        //    WARNING: The following scenarios represents solutions assuming the user would want
        //             ALL redundant explicit accidentals to be removed from following notes.
        //
        //             However, it is definitely possible that certain users would rather
        //             explicit accidentals to be kept intact and perhaps a different
        //             set of plugins altogether which favours this behavior needs to be
        //             created.
        //
        //             MuseScore is able to resolve this issue for standard accidentals
        //             as it is able to differentiate an explicit user-placed accidental
        //             from an accidental that appears explicit due to it's innate tpc value
        //             caused by means of stepwise transposition or other means.
        //
        //             However, the plugin API endpoint does not expose this feature,
        //             furthermore, as microtonal accidentals have no first-class support,
        //             it is impossible for the plugin to differentiate between when the
        //             micorotnal accidentals are added explicitly and when they are added
        //             by stepwise transposition without holding some form of extraneous
        //             score state of its own, which could possibly be an addition to the
        //             feature set of the plugin in the future.
        //
        //
        //    Scenario 1: D is tranposed up. Nothing needs to be done, no notes share the same line.
        //      C D E -> C D^ E
        //
        //    Scenario 2: D transposed up. Nothing needs to be done,
        //                an explicit accidental already exists on the following note.
        //      C D D# -> C D^ D#
        //
        //    Scenario 3: D tranposed up. The following accidental can be made implicit,
        //                as it is shared by newly transposed note.
        //      C D D^ -> C D^ D(implicit ^)
        //
        //    Scenario 4: D transposed up. Accidental has to be explicitly added to prevent side effects.
        //      C D D -> C D^ D natural
        //
        //    Scenario 5: D#^ transposed up (in 31 ups/downs). Two accidentals has to be explcitly added
        //                for both the D line and the E line.
        //      C D#^ D(implicit #+) E(implicit natural) -> C Ev D#+ Enatural
        //
        //    Scenario 6: D#^ transposed up. One accidental has to be explcitly added and one can be made implicit
        //      C D#^ D(implicit #^) Ev => C Ev D#^ E(implicit v)
        //
        //    Scenario 7: D#^ with implicit accidentals transposed up. Nothing has to be done although a D follows, as
        //                the transposed note moves out of the way for a prior D#^ to still take effect in the following D.
        //      D#^ D(implicit #^) D(implicit #^) => D#^ Ev D(implicit #^)
        //
        //    Scenario 8: D#^ transposed up to Ev. Two following accidentals can be made implicit.
        //                This scenario assumses the key signature has an Ev, and an explicit courtesy Ev is
        //                placed by the user on the last note.
        //      C D# Eb D#^ D# E^ => C D# Eb E(implicit key signature ^) D(implicit #) E(implicit ^)
        //
        //    This boils down to the following logic:
        //      An explicit accidental is ALWAYS added on the immediate notes within the same bar unless:
        //      i.    an explicit accidental already exists on them
        //      ii.   the tranposed note after transposition shares the same accidental as the immmediate note.
        //      iii.  the note to be transposed is implicit AND moving out of the way (changing to a new line)
        //            which shows that a prior explicit accidental must have been affecting both the transposed note
        //            and the following note.
        //
        //      An accidental can be made implicit on the immediate notes when:
        //      iv.   The newly transposed note has an accidental that renders
        //            the explicit following accidental redundant.
        //      v.    The newly transposed note is enharmonically spelled and moves out of the way
        //            for an accidental prior to the transposed note to affect the following note, thus
        //            making an explicit accidental on the following note redundant.
        //
        //      NOTE: logical cases ii. thru v. can all be covered by checking with the accidental state as
        //            of step 3, so the 4 cases should be able to be covered with a single if statement.
        //
        //    Whenever accidentals on immediate notes are created or destroyed on the following notes,
        //    registerAccidental and removeAccidental should be called to update accidental state.
        //
        //    registerAccidental will be called:
        //      - for the new transposed note's new accidental (when it is explicit).
        //
        //      - for the accidentals created after the new transposed note to prevent the new transposed note's
        //        new accidental from affecting the notes after it.
        //
        //
        //    removeAccidental will be called:
        //      - When the new tranposed note's new accidental is set to implicit (Accidental.NONE)
        //
        //      - If the new tranposed note is now spelt with an enharmonic, the accidental on the
        //        note.line value of the transposed note prior to transposing should be removed.
        //
        //        e.g. Dx is now tranposed to E^. so the accidental on the note.line of D should be removed
        //             as it is no longer there.
        //
        //      - If the new tranposed note causes up to two following notes after it to have it's explicit

        // 4. Update the transposed note's line, accidentalType, and pitch properties in that order
        //    to update the new transposed note. This should work without any unwanted side effects.

        // step 0
        var pitchData = getNotePitchData(note);

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
        var newOffset = convertAccidentalToSteps(newAccidental);

        // If an enharmonic spelling is required while transposing upwards,
        // the new line is the note above it.
        // NOTE: The constant -1 is used in the UPWARD transposition variants.
        //       for downward transposition, use +1.
        var newLine = usingEnharmonic ? pitchData.line - 1 : pitchData.line;
        var newBaseNote = usingEnharmonic ? getNextNote(pitchData.baseNote) : pitchData.baseNote;

        var nextNoteEnharmonics = getEnharmonics(newBaseNote, newOffset);

        // Step 1b. if the new note fits perfectly into the key signature, use that key signature's accidental instead.

        // check if the current newBaseNote has an offset exactly that of the
        // key signature (this may seem unecessary, but different accidentals
        // may have the same step offset, e.g., #v = ^ = +1)
        // e.g. key signature has Cv, the new note is set to Cb^ instead,
        //      this will make Cb^ be spelt as Cv instead.
        if (parms.keySig[newBaseNote].steps === newOffset) {
          newAccidental = parms.keySig[newBaseNote].type;
          newOffset = parms.keySig[newBaseNote].steps; // this is redundant but OCD lol.
        }

        // check if the enharmonic that's above newBaseNote (if any) has offset exactly that
        // matches the key signature.
        // e.g. key signature has Db, the new note is set to C#^.
        //      this will make C#^ be spelt as Db instead.
        else if (parms.keySig[nextNoteEnharmonics.above.baseNote].steps === nextNoteEnharmonics.above.offset) {
          newBaseNote = nextNoteEnharmonics.above.baseNote;
          newLine -= 1;
          newAccidental = parms.keySig[nextNoteEnharmonics.above.baseNote].type;
          newOffset = parms.keySig[nextNoteEnharmonics.above.baseNote].offset;
        }

        // check if the enharmonic that's below newBaseNote (if any) has offset exactly that
        // matches the key signature.
        // e.g. key signature has B natural, the new note is set to Cbv.
        //      this will make Cbv be spelt as B instead.
        else if (parms.keySig[nextNoteEnharmonics.below.baseNote].steps === nextNoteEnharmonics.below.offset) {
          newBaseNote = nextNoteEnharmonics.below.baseNote;
          newLine += 1;
          newAccidental = parms.keySig[nextNoteEnharmonics.below.baseNote].type;
          newOffset = parms.keySig[nextNoteEnharmonics.below.baseNote].offset;
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

        if (nextNoteEnharmonics.above.steps > parms.keySig[nextNoteEnharmonics.above.baseNote].steps) {
          newBaseNote = nextNoteEnharmonics.above.baseNote;
          newLine -= 1;
          newAccidental = convertStepsToAccidentalType(nextNoteEnharmonics.above.steps);
          newOffset = nextNoteEnharmonics.above.steps;
        }

        // Step 1d is a converse of clause 1c, it is implicitly implemented in the implementation
        // of the above clauses. YAY!

        // Step 1e. Check if new accidental corresponds exactly to the key signature accidental type and
        //          no prior explicit accidentals are in the bar. If so, the new note's accidental can be implicit.

        var priorAccOnNewLine = getAccidental(newLine, note.tick, parms);

        if (priorAccOnNewLine !== null) {
          if (parms.keySig[newBaseNote].type == newAccidental) {
            newAccidental = Accidental.NONE;
          }
        }

        // Step 1f. Check the accidental state of accidentals prior to this note within the current bar.
        //          If the new transposed note's accidental type coincides with a prior accidental,
        //          its accidental can be made implicit.
        else if (newAccidental == priorAccOnNewLine.type)
          newAccidental = Accidental.NONE;

        // At the end of everything, evaluate usingEnharmonic to check whether the new note
        // would be on a different line than the original note.

        if (newLine != pitchData.line) {
          usingEnharmonic = true;
        }

        // Step 2. Call registerAccidental and removeAccidental to update the accidental state according
        //         to the new transposed note.

        if (newAccidental != Accidental.NONE) {
          // Register explicit accidental added on the line of the new note.

          // new pitch data object has to be created
          var newPitchData = {
            baseNote: newBaseNote,
            line: newLine,
            tpc: null, // this one doesn't matter
            tick: note.tick,
            explicitAccidental: newAccidental,
            implicitAccidental: newAccidental,
            diesisOffset: newOffset
          };

          // note: this will auto-override any existing accidental at this tick and line position.
          //       so no additional remove code is necessary.
          registerAccidental(newPitchData, parms);
        } else if (note.accidentalType && note.accidentalType != Accidental.NONE){
          // the accidental is made implicit, remove the old accidental at that line position. (if any)
          removeAccidental(note.accidentalType, newLine, note.tick, parms);
        }

        if (usingEnharmonic) {
          // that means the note moved from one line to another, delete the accidental at the previous line,
          // if any.
          if (note.accidentalType && note.accidentalType != Accidental.NONE) {
            removeAccidental(note.accidentalType, note.line, note.tick, parms);
          }
        }


        // Step 3. iterate through Elements till the end of the bar, or end of the score, whichever first.
        //         Find the first immediate notex that shares the old note.line and the newLine properties

        // if not undefined, this takes the place of followingOldLine.
        // (see above references to noteOnSameLineAfter for documentation)
        var followingOldLine = parms.noteOnSameLineAfter;
        var followingNewLine;

        var tickOfNextBar = -1; // if -1, the cursor at the last bar

        for (var i = 0; i < parms.accidental.bars.length; i++) {
          if (parms.accidentals.bars[i] > cursor.tick) {
            tickOfNextBar = parms.accidental.bars[i];
            break;
          }
        }

        // Loop through all elements until end of bar to find the next following notes
        // that share the same old and new line.
        cursor.next();
        while (cursor.segment && (tickOfNextBar === -1 || cursor.tick < tickOfNextBar)) {
          if (cursor.element && cursor.element.type == Ms.CHORD) {
            var graceChords = cursor.element.graceNotes;
            for (var i = 0; i < graceChords.length; i++) {
              // iterate through all grace chords
              var notes = graceChords[i].notes;
              for (var j = 0; j < notes.length; j++) {
                if (!followingOldLine && notes[j].line == note.line)
                  followingOldLine = notes[j];
                else if (usingEnharmonic && !followingNewLine && notes[j].line == newLine)
                  followingNewLine = notes[j];
              }
            }
            var notes = cursor.element.notes;
            for (var i = 0; i < notes.length; i++) {
              if (!followingOldLine && notes[i].line == note.line)
                followingOldLine = notes[i];
              else if (usingEnharmonic && !followingNewLine && notes[i].line == newLine)
                followingNewLine = notes[i];
            }
          }
          cursor.next();
        }

        // Reset cursor position back to original note tick.

        // WARNING: Does this even work???
        while (cursor.tick !== note.tick)
          cursor.prev()

        // At this point followingOldLine and followingNewLine would be populated
        // with note objects that would have their pitch value affected if they had
        // implicit accidentals, or notes that can have their accidentals made implicit
        // due to the transposition of the current note.
        //
        // NOTE: followingNewLine will be empty if usingEnharmonic is false.
        //       and both followingNew and followingOld are nullable values.

        if (followingOldLine) {
          var followingOldAccidental = getAccidental(followingOldLine.line, followingOldLine.tick, parms);

        }

        //
        //
        //
        //
        //
        //
        //
        //
        // ------------------------------------------
        // TUNING SECTION
        //-------------------------------------------

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

          NOTE: parms.keySig has been deprecated, it now serves as a placeholder
                for the natural key signature.

          THIS SHOULD BE READONLY!
        */
        parms.keySig = {
          'c': {steps: 0, type: Accidental.NATURAL},
          'd': {steps: 0, type: Accidental.NATURAL},
          'e': {steps: 0, type: Accidental.NATURAL},
          'f': {steps: 0, type: Accidental.NATURAL},
          'g': {steps: 0, type: Accidental.NATURAL},
          'a': {steps: 0, type: Accidental.NATURAL},
          'b': {steps: 0, type: Accidental.NATURAL}
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
