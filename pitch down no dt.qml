import QtQuick 2.1
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3
import QtQuick.Dialogs 1.1
import MuseScore 3.0


MuseScore {

      MessageDialog {
        id: invalidTuningSystemError
        title: 'n-TET tuning plugin error:'
        text: 'Tuning system not supported, it requires an accidental that cannot be represented.\nOnly EDOs ranked up to sharp-8 are supported. See the README for more info.'
        onAccepted: {
          Qt.quit();
        }
      }

      version:  "2.1.2"
      description: "Lowers selection (Shift-click) or individually selected notes (Ctrl-click) by 1 step of n EDO." +
                   "This version prioritises up/down arrows over semisharp/flat accidentals whereever possible."
      menuPath: "Plugins.n-EDO.Lower Pitch By 1 Step (Arrows)"

      // WARNING! This doesn't validate the accidental code!
      property variant customKeySigRegex: /\.(.*)\.(.*)\.(.*)\.(.*)\.(.*)\.(.*)\.(.*)/g

      // MuseScore's annotations contain formatting code in angle brackets if the
      // annotation text formatting is not default. This function removes
      // all text within angle brackets including the brackets themselves
      function removeFormattingCode(str) {
        if (typeof(str) == 'string')
          return str.replace(/<[^>]*>/g, '');
        else
          return null;
      }

      // <TUNING SYSTEM VARIANT CHECKPOINT>
      function getCentOffset(noteName, stepOffset, edo, a4Freq) {
        var stepSize = 1200.0 / edo;
        var fifthStep = Math.round(edo * Math.log(3/2) / Math.log(2));
        var sharpValue = 7 * fifthStep - 4 * edo;

        var regularAccCentOffset = 0;
        for (var x = -2; x <= 2; x++) {
          if (stepOffset == x*sharpValue)
            regularAccCentOffset += 100*x;
        }

        var centOffset = -regularAccCentOffset;

        centOffset += 1200.0 * Math.log(a4Freq / 440.0) / Math.log(2);

        switch (noteName) {
          case 'f':
            return stepSize*(-4*fifthStep + stepOffset) + 2800 + centOffset;
          case 'c':
            return stepSize*(-3*fifthStep + stepOffset) + 2100 + centOffset;
          case 'g':
            return stepSize*(-2*fifthStep + stepOffset) + 1400 + centOffset;
          case 'd':
            return stepSize*(-fifthStep + stepOffset) + 700 + centOffset;
          case 'a':
            return stepSize*stepOffset + centOffset;
          case 'e':
            return stepSize*(fifthStep + stepOffset) - 700 + centOffset;
          case 'b':
            return stepSize*(2*fifthStep + stepOffset) - 1400 + centOffset;
        }
      }

      function convertAccidentalToSteps(acc, edo) {
        return convertAccidentalTypeToSteps(convertAccidentalTextToAccidentalType(acc), edo);
      }

      function convertAccidentalTextToAccidentalType(accStr) {
        switch(accStr.trim()) {
        case 'bbv3':
          return Accidental.DOUBLE_FLAT_THREE_ARROWS_DOWN;
        case 'bbv2':
          return Accidental.DOUBLE_FLAT_TWO_ARROWS_DOWN;
        case 'bbv':
        case 'bbv1':
          return Accidental.DOUBLE_FLAT_ONE_ARROW_DOWN;
        case 'bb':
          return Accidental.FLAT2;
        case 'bb^3':
          return Accidental.DOUBLE_FLAT_THREE_ARROWS_UP;
        case 'bb^2':
          return Accidental.DOUBLE_FLAT_TWO_ARROWS_UP;
        case 'bb^':
        case 'bb^1':
          return Accidental.DOUBLE_FLAT_ONE_ARROW_UP;
        case 'db':
        case 'bd':
          return Accidental.MIRRORED_FLAT2;
        case 'bv3':
          return Accidental.FLAT_THREE_ARROWS_DOWN;
        case 'bv2':
          return Accidental.FLAT_TWO_ARROWS_DOWN;
        case 'bv':
        case 'bv1':
          return Accidental.FLAT_ONE_ARROW_DOWN;
        case 'b':
          return Accidental.FLAT;
        case 'b^3':
          return Accidental.FLAT_THREE_ARROWS_UP;
        case 'b^2':
          return Accidental.FLAT_TWO_ARROWS_UP;
        case 'b^':
        case 'b^1':
          return Accidental.FLAT_ONE_ARROW_UP;
        case 'v3':
          return Accidental.NATURAL_THREE_ARROWS_DOWN;
        case 'v2':
          return Accidental.NATURAL_TWO_ARROWS_DOWN;
        case 'v':
        case 'v1':
          return Accidental.NATURAL_ONE_ARROW_DOWN;
        case 'd':
          return Accidental.MIRRORED_FLAT;
        case '+':
          return Accidental.SHARP_SLASH;
        case '^3':
          return Accidental.NATURAL_THREE_ARROWS_UP;
        case '^2':
          return Accidental.NATURAL_TWO_ARROWS_UP;
        case '^':
        case '^1':
          return Accidental.NATURAL_ONE_ARROW_UP;
        case '#v3':
          return Accidental.SHARP_THREE_ARROWS_DOWN;
        case '#v2':
          return Accidental.SHARP_TWO_ARROWS_DOWN;
        case '#v':
        case '#v1':
          return Accidental.SHARP_ONE_ARROW_DOWN;
        case '#':
          return Accidental.SHARP;
        case '#^3':
          return Accidental.SHARP_THREE_ARROWS_UP;
        case '#^2':
          return Accidental.SHARP_TWO_ARROWS_UP;
        case '#^':
        case '#^1':
          return Accidental.SHARP_ONE_ARROW_UP;
        case '#+':
        case '+#':
          return Accidental.SHARP_SLASH4;
        case 'xv3':
          return Accidental.DOUBLE_SHARP_THREE_ARROWS_DOWN;
        case 'xv2':
          return Accidental.DOUBLE_SHARP_TWO_ARROWS_DOWN;
        case 'xv':
        case 'xv1':
          return Accidental.DOUBLE_SHARP_ONE_ARROW_DOWN;
        case 'x':
          return Accidental.SHARP2;
        case 'x^3':
          return Accidental.DOUBLE_SHARP_THREE_ARROWS_UP;
        case 'x^2':
          return Accidental.DOUBLE_SHARP_TWO_ARROWS_UP;
        case 'x^':
        case 'x^1':
          return Accidental.DOUBLE_SHARP_ONE_ARROW_UP;
        default:
          return Accidental.NATURAL;
        }
      }

      // <TUNING SYSTEM VARIANT CHECKPOINT>
      function convertAccidentalTypeToSteps(accType, edo) {
        var accOffset = null;
        var fifthStep = Math.round(edo * Math.log(3/2) / Math.log(2));
        var sharpValue = 7 * fifthStep - 4 * edo;

        switch(accType) {
        case Accidental.SHARP_SLASH4:
          accOffset = 3*sharpValue/2;
          break;
        case Accidental.SHARP_SLASH:
          accOffset = sharpValue/2;
          break;
        case Accidental.MIRRORED_FLAT:
          accOffset = -sharpValue/2;
          break;
        case Accidental.MIRRORED_FLAT2:
          accOffset = -3*sharpValue/2;
          break;
        case Accidental.DOUBLE_SHARP_THREE_ARROWS_UP:
          accOffset = 2*sharpValue + 3;
          break;
        case Accidental.DOUBLE_SHARP_TWO_ARROWS_UP:
          accOffset = 2*sharpValue + 2;
          break;
        case Accidental.SHARP2_ARROW_UP:
        case Accidental.DOUBLE_SHARP_ONE_ARROW_UP:
          accOffset = 2*sharpValue + 1;
          break;
        case Accidental.SHARP2:
          accOffset = 2 * sharpValue;
          break;
        case Accidental.SHARP2_ARROW_DOWN:
        case Accidental.DOUBLE_SHARP_ONE_ARROW_DOWN:
          accOffset = 2*sharpValue - 1;
          break;
        case Accidental.DOUBLE_SHARP_TWO_ARROWS_DOWN:
          accOffset = 2*sharpValue - 2;
          break;
        case Accidental.DOUBLE_SHARP_THREE_ARROWS_DOWN:
          accOffset = 2*sharpValue - 3;
          break;
        case Accidental.SHARP_THREE_ARROWS_UP:
          accOffset = sharpValue + 3;
          break;
        case Accidental.SHARP_TWO_ARROWS_UP:
          accOffset = sharpValue + 2;
          break;
        case Accidental.SHARP_ARROW_UP:
        case Accidental.SHARP_ONE_ARROW_UP:
          accOffset = sharpValue + 1;
          break;
        case Accidental.SHARP:
          accOffset = sharpValue;
          break;
        case Accidental.SHARP_ARROW_DOWN:
        case Accidental.SHARP_ONE_ARROW_DOWN:
          accOffset = sharpValue - 1;
          break;
        case Accidental.SHARP_TWO_ARROWS_DOWN:
          accOffset = sharpValue - 2;
          break;
        case Accidental.SHARP_THREE_ARROWS_DOWN:
          accOffset = sharpValue - 3;
          break;
        case Accidental.NATURAL_THREE_ARROWS_UP:
          accOffset = 3;
          break;
        case Accidental.NATURAL_TWO_ARROWS_UP:
          accOffset = 2;
          break;
        case Accidental.NATURAL_ARROW_UP:
        case Accidental.NATURAL_ONE_ARROW_UP:
          accOffset = 1;
          break;
        case Accidental.NATURAL:
          accOffset = 0;
          break;
        case Accidental.NATURAL_ARROW_DOWN:
        case Accidental.NATURAL_ONE_ARROW_DOWN:
          accOffset = -1;
          break;
        case Accidental.NATURAL_TWO_ARROWS_DOWN:
          accOffset = -2;
          break;
        case Accidental.NATURAL_THREE_ARROWS_DOWN:
          accOffset = -3;
          break;
        case Accidental.FLAT_THREE_ARROWS_UP:
          accOffset = -sharpValue + 3;
          break;
        case Accidental.FLAT_TWO_ARROWS_UP:
          accOffset = -sharpValue + 2;
          break;
        case Accidental.FLAT_ARROW_UP:
        case Accidental.FLAT_ONE_ARROW_UP:
          accOffset = -sharpValue + 1;
          break;
        case Accidental.FLAT:
          accOffset = -sharpValue;
          break;
        case Accidental.FLAT_ARROW_DOWN:
        case Accidental.FLAT_ONE_ARROW_DOWN:
          accOffset = -sharpValue - 1;
          break;
        case Accidental.FLAT_TWO_ARROWS_DOWN:
          accOffset = -sharpValue - 2;
          break;
        case Accidental.FLAT_THREE_ARROWS_DOWN:
          accOffset = -sharpValue - 3;
          break;
        case Accidental.DOUBLE_FLAT_THREE_ARROWS_UP:
          accOffset = -2*sharpValue + 3;
          break;
        case Accidental.DOUBLE_FLAT_TWO_ARROWS_UP:
          accOffset = -2*sharpValue + 2;
          break;
        case Accidental.FLAT2_ARROW_UP:
        case Accidental.DOUBLE_FLAT_ONE_ARROW_UP:
          accOffset = -2*sharpValue + 1;
          break;
        case Accidental.FLAT2:
          accOffset = -2 * sharpValue;
          break;
        case Accidental.FLAT2_ARROW_DOWN:
        case Accidental.DOUBLE_FLAT_ONE_ARROW_DOWN:
          accOffset = -2*sharpValue - 1;
          break;
        case Accidental.DOUBLE_FLAT_TWO_ARROWS_DOWN:
          accOffset = -2*sharpValue - 2;
          break;
        case Accidental.DOUBLE_FLAT_THREE_ARROWS_DOWN:
          accOffset = -2*sharpValue - 3;
          break;
        }

        return accOffset;
      }

      // Construct an up/down arrow accidental based on the number of sharps and number of up arrows
      // of the accidental. Negative values represents flats/down arrows instead.
      //
      // If numSharps is 1.5, 0.5, -0.5, or -1.5, it represents a quarter tone accidental.
      //    the numArrows param will be ignored.
      //
      // Returns null if no such accidental exists, and logs a warning in the console.
      function constructAccidental(numSharps, numArrows) {
        console.log('called construct acc with sharps: ' + numSharps + ', arrows: ' + numArrows);
        if (numSharps == -1.5)
          return Accidental.MIRRORED_FLAT2;
        else if (numSharps == -0.5)
          return Accidental.MIRRORED_FLAT;
        else if (numSharps == 0.5)
          return Accidental.SHARP_SLASH;
        else if (numSharps == 1.5)
          return Accidental.SHARP_SLASH4;

        else if (numSharps == -2) {
          switch(numArrows) {
          case -3:
            return Accidental.DOUBLE_FLAT_THREE_ARROWS_DOWN;
          case -2:
            return Accidental.DOUBLE_FLAT_TWO_ARROWS_DOWN;
          case -1:
            return Accidental.DOUBLE_FLAT_ONE_ARROW_DOWN;
          case 0:
            return Accidental.FLAT2;
          case 1:
            return Accidental.DOUBLE_FLAT_ONE_ARROW_UP;
          case 2:
            return Accidental.DOUBLE_FLAT_TWO_ARROWS_UP;
          case 3:
            return Accidental.DOUBLE_FLAT_THREE_ARROWS_UP;
          }
        } else if (numSharps == -1) {
          switch(numArrows) {
          case -3:
            return Accidental.FLAT_THREE_ARROWS_DOWN;
          case -2:
            return Accidental.FLAT_TWO_ARROWS_DOWN;
          case -1:
            return Accidental.FLAT_ONE_ARROW_DOWN;
          case 0:
            return Accidental.FLAT;
          case 1:
            return Accidental.FLAT_ONE_ARROW_UP;
          case 2:
            return Accidental.FLAT_TWO_ARROWS_UP;
          case 3:
            return Accidental.FLAT_THREE_ARROWS_UP;
          }
        } else if (numSharps == 0) {
          switch(numArrows) {
          case -3:
            return Accidental.NATURAL_THREE_ARROWS_DOWN;
          case -2:
            return Accidental.NATURAL_TWO_ARROWS_DOWN;
          case -1:
            return Accidental.NATURAL_ONE_ARROW_DOWN;
          case 0:
            return Accidental.NATURAL;
          case 1:
            return Accidental.NATURAL_ONE_ARROW_UP;
          case 2:
            return Accidental.NATURAL_TWO_ARROWS_UP;
          case 3:
            return Accidental.NATURAL_THREE_ARROWS_UP;
          }
        } else if (numSharps == 1) {
          switch(numArrows) {
          case -3:
            return Accidental.SHARP_THREE_ARROWS_DOWN;
          case -2:
            return Accidental.SHARP_TWO_ARROWS_DOWN;
          case -1:
            return Accidental.SHARP_ONE_ARROW_DOWN;
          case 0:
            return Accidental.SHARP;
          case 1:
            return Accidental.SHARP_ONE_ARROW_UP;
          case 2:
            return Accidental.SHARP_TWO_ARROWS_UP;
          case 3:
            return Accidental.SHARP_THREE_ARROWS_UP;
          }
        } else if (numSharps == 2) {
          switch(numArrows) {
          case -3:
            return Accidental.DOUBLE_SHARP_THREE_ARROWS_DOWN;
          case -2:
            return Accidental.DOUBLE_SHARP_TWO_ARROWS_DOWN;
          case -1:
            return Accidental.DOUBLE_SHARP_ONE_ARROW_DOWN;
          case 0:
            return Accidental.SHARP2;
          case 1:
            return Accidental.DOUBLE_SHARP_ONE_ARROW_UP;
          case 2:
            return Accidental.DOUBLE_SHARP_TWO_ARROWS_UP;
          case 3:
            return Accidental.DOUBLE_SHARP_THREE_ARROWS_UP;
          }
        }

        console.log('WARNING: unexpected to have no such accidental exist: sharps: ' + numSharps + ', arrows: ' + numArrows);
        return null; // if no such accidental exists.
      }

      // deconstructs and accidental enum into {numSharps, numArrows}
      // does the opposite of constructAccidental
      function deconstructAccidental(acc) {
        // helper fn for creating objects
        function a(x, y) {
          return {
            numSharps: x,
            numArrows: y
          };
        }

        switch(acc) {
        case Accidental.SHARP_SLASH4:
          return a(1.5, 0);
        case Accidental.SHARP_SLASH:
          return a(0.5, 0);
        case Accidental.MIRRORED_FLAT:
          return a(-0.5, 0);
        case Accidental.MIRRORED_FLAT2:
          return a(-1.5, 0);

        case Accidental.DOUBLE_SHARP_THREE_ARROWS_UP:
          return a(2, 3);
        case Accidental.DOUBLE_SHARP_TWO_ARROWS_UP:
          return a(2, 2);
        case Accidental.SHARP2_ARROW_UP:
        case Accidental.DOUBLE_SHARP_ONE_ARROW_UP:
          return a(2, 1);
        case Accidental.SHARP2:
          return a(2, 0);
        case Accidental.SHARP2_ARROW_DOWN:
        case Accidental.DOUBLE_SHARP_ONE_ARROW_DOWN:
          return a(2, -1);
        case Accidental.DOUBLE_SHARP_TWO_ARROWS_DOWN:
          return a(2, -2);
        case Accidental.DOUBLE_SHARP_THREE_ARROWS_DOWN:
          return a(2, -3);

        case Accidental.SHARP_THREE_ARROWS_UP:
          return a(1, 3);
        case Accidental.SHARP_TWO_ARROWS_UP:
          return a(1, 2);
        case Accidental.SHARP_ARROW_UP:
        case Accidental.SHARP_ONE_ARROW_UP:
          return a(1, 1);
        case Accidental.SHARP:
          return a(1, 0);
        case Accidental.SHARP_ARROW_DOWN:
        case Accidental.SHARP_ONE_ARROW_DOWN:
          return a(1, -1);
        case Accidental.SHARP_TWO_ARROWS_DOWN:
          return a(1, -2);
        case Accidental.SHARP_THREE_ARROWS_DOWN:
          return a(1, -3);

        case Accidental.NATURAL_THREE_ARROWS_UP:
          return a(0, 3);
        case Accidental.NATURAL_TWO_ARROWS_UP:
          return a(0, 2);
        case Accidental.NATURAL_ARROW_UP:
        case Accidental.NATURAL_ONE_ARROW_UP:
          return a(0, 1);
        case Accidental.NATURAL:
          return a(0, 0);
        case Accidental.NATURAL_ARROW_DOWN:
        case Accidental.NATURAL_ONE_ARROW_DOWN:
          return a(0, -1);
        case Accidental.NATURAL_TWO_ARROWS_DOWN:
          return a(0, -2);
        case Accidental.NATURAL_THREE_ARROWS_DOWN:
          return a(0, -3);

        case Accidental.FLAT_THREE_ARROWS_UP:
          return a(-1, 3);
        case Accidental.FLAT_TWO_ARROWS_UP:
          return a(-1, 2);
        case Accidental.FLAT_ARROW_UP:
        case Accidental.FLAT_ONE_ARROW_UP:
          return a(-1, 1);
        case Accidental.FLAT:
          return a(-1, 0);
        case Accidental.FLAT_ARROW_DOWN:
        case Accidental.FLAT_ONE_ARROW_DOWN:
          return a(-1, -1);
        case Accidental.FLAT_TWO_ARROWS_DOWN:
          return a(-1, -2);
        case Accidental.FLAT_THREE_ARROWS_DOWN:
          return a(-1, -3);

        case Accidental.DOUBLE_FLAT_THREE_ARROWS_UP:
          return a(-2, 3);
        case Accidental.DOUBLE_FLAT_TWO_ARROWS_UP:
          return a(-2, 2);
        case Accidental.FLAT2_ARROW_UP:
        case Accidental.DOUBLE_FLAT_ONE_ARROW_UP:
          return a(-2, 1);
        case Accidental.FLAT2:
          return a(-2, 0);
        case Accidental.FLAT2_ARROW_DOWN:
        case Accidental.DOUBLE_FLAT_ONE_ARROW_DOWN:
          return a(-2, -1);
        case Accidental.DOUBLE_FLAT_TWO_ARROWS_DOWN:
          return a(-2, -2);
        case Accidental.DOUBLE_FLAT_THREE_ARROWS_DOWN:
          return a(-2, -3);
        }
      }

      // NOTE: This function may differ between upwards and downwards variants of
      //       the plugin as some tuning systems (e.g. 31 ups and downs) will have
      //       enharmonic equivalents between two different types of accidentals
      //
      //       e.g.: C#v and C^.
      //
      // Whenever possible, use the LEAST number of arrows
      // If steps splits sharpValue exactly into half, use a quarter-tone accidental.
      // If plugin moves upwards, prefer spelling using up arrows (default to the flatter enharmonic side, or sharper if super-flat)
      // If plugin moves downwards, prefer spelling using down arrows (default to the sharper enharmonic side, or flatter if super-flat)
      //
      // <TUNING SYSTEM VARIANT CHECKPOINT>
      function convertStepsToAccidentalType(steps, edo) {
        var fifthStep = Math.round(edo * Math.log(3/2) / Math.log(2));
        var sharpValue = 7 * fifthStep - 4 * edo;

        var numSharpsFlatter = Math.floor(steps / sharpValue);
        var numSharpsSharper = Math.ceil(steps / sharpValue);
        var arrowsOnFlatSide = steps - numSharpsFlatter * sharpValue;
        var arrowsOnSharpSide = steps - numSharpsSharper * sharpValue;

        var useFlatSide = Math.abs(arrowsOnFlatSide) < Math.abs(arrowsOnSharpSide);

        if (Math.abs(arrowsOnFlatSide) == Math.abs(arrowsOnSharpSide)) {
          // <UP DOWN VARIANT CHECKPOINT>
          useFlatSide = sharpValue <= 0; // invert equality if the plugin moves downwards
        }

        // check if the num of sharps the algorithm decides to use is illegal.
        // maximum of 2 sharps/flats allowed.
        if (numSharpsFlatter > 2 || numSharpsFlatter < -2)
          useFlatSide = false;
        if (numSharpsSharper > 2 || numSharpsSharper < -2)
          useFlatSide = true;

        // check if quartertone accidentals may be used.
        if (steps == -sharpValue * 3/2)
          return Accidental.MIRRORED_FLAT2;
        else if (steps == -sharpValue * 1/2)
          return Accidental.MIRRORED_FLAT;
        else if (steps == sharpValue * 1/2)
          return Accidental.SHARP_SLASH;
        else if (steps == sharpValue * 3/2)
          return Accidental.SHARP_SLASH4;

        var numSharps = useFlatSide ? numSharpsFlatter : numSharpsSharper;
        var numArrows = useFlatSide ? arrowsOnFlatSide : arrowsOnSharpSide;

        while (numSharps > 2) {
          if (numArrows + sharpValue > 3 || numArrows + sharpValue < -3) {
            invalidTuningSystemError.open();
            return null;
          } else {
            numSharps--;
            numArrows += sharpValue;
          }
        }
        while (numSharps < -2) {
          if (numArrows - sharpValue > 3 || numArrows - sharpValue < -3) {
            invalidTuningSystemError.open();
            return null;
          } else {
            numSharps++;
            numArrows -= sharpValue;
          }
        }

        return constructAccidental(numSharps, numArrows);
      }

      function convertAccidentalTypeToName(accType) {
        switch(accType) {
        case Accidental.DOUBLE_FLAT_THREE_ARROWS_DOWN:
          return 'bbv3';
        case Accidental.DOUBLE_FLAT_TWO_ARROWS_DOWN:
          return 'bbv2';
        case Accidental.FLAT2_ARROW_DOWN:
        case Accidental.DOUBLE_FLAT_ONE_ARROW_DOWN:
          return 'bbv';
        case Accidental.FLAT2:
          return 'bb';
        case Accidental.FLAT2_ARROW_UP:
        case Accidental.DOUBLE_FLAT_ONE_ARROW_UP:
          return 'bb^';
        case Accidental.DOUBLE_FLAT_TWO_ARROWS_UP:
          return 'bb^2';
        case Accidental.DOUBLE_FLAT_THREE_ARROWS_UP:
          return 'bb^3';
        case Accidental.MIRRORED_FLAT2:
          return 'db';
        case Accidental.FLAT_THREE_ARROWS_DOWN:
          return 'bv3';
        case Accidental.FLAT_TWO_ARROWS_DOWN:
          return 'bv2';
        case Accidental.FLAT_ARROW_DOWN:
        case Accidental.FLAT_ONE_ARROW_DOWN:
          return 'bv';
        case Accidental.FLAT:
          return 'b';
        case Accidental.MIRRORED_FLAT:
          return 'd';
        case Accidental.FLAT_ARROW_UP:
        case Accidental.FLAT_ONE_ARROW_UP:
          return 'b^';
        case Accidental.FLAT_TWO_ARROWS_UP:
          return 'b^2';
        case Accidental.FLAT_THREE_ARROWS_UP:
          return 'b^3';
        case Accidental.NATURAL_THREE_ARROWS_DOWN:
          return 'v3';
        case Accidental.NATURAL_TWO_ARROWS_DOWN:
          return 'v2';
        case Accidental.NATURAL_ARROW_DOWN:
        case Accidental.NATURAL_ONE_ARROW_DOWN:
          return 'v';
        case Accidental.NATURAL:
          return 'nat';
        case Accidental.NATURAL_THREE_ARROWS_UP:
          return '^3';
        case Accidental.NATURAL_TWO_ARROWS_UP:
          return '^2';
        case Accidental.NATURAL_ARROW_UP:
        case Accidental.NATURAL_ONE_ARROW_UP:
          return '^';
        case Accidental.SHARP_THREE_ARROWS_DOWN:
          return '#v3';
        case Accidental.SHARP_TWO_ARROWS_DOWN:
          return '#v2';
        case Accidental.SHARP_ARROW_DOWN:
        case Accidental.SHARP_ONE_ARROW_DOWN:
          return '#v';
        case Accidental.SHARP_SLASH:
          return '+';
        case Accidental.SHARP:
          return '#';
        case Accidental.SHARP_THREE_ARROWS_UP:
          return '#^3';
        case Accidental.SHARP_TWO_ARROWS_UP:
          return '#^2';
        case Accidental.SHARP_ARROW_UP:
        case Accidental.SHARP_ONE_ARROW_UP:
          return '#^';
        case Accidental.SHARP_SLASH4:
          return '#+';
        case Accidental.DOUBLE_SHARP_THREE_ARROWS_DOWN:
          return 'xv3';
        case Accidental.DOUBLE_SHARP_TWO_ARROWS_DOWN:
          return 'xv2';
        case Accidental.SHARP2_ARROW_DOWN:
        case Accidental.DOUBLE_SHARP_ONE_ARROW_DOWN:
          return 'xv';
        case Accidental.SHARP2:
          return 'x';
        case Accidental.DOUBLE_SHARP_THREE_ARROWS_UP:
          return 'x^3';
        case Accidental.DOUBLE_SHARP_TWO_ARROWS_UP:
          return 'x^2';
        case Accidental.SHARP2_ARROW_UP:
        case Accidental.DOUBLE_SHARP_ONE_ARROW_UP:
          return 'x^';
        case Accidental.NONE:
          return 'none';
        default:
          return 'unrecognized';
        }
      }

      // Returns the accidental after it has been transposed up (or down if the plugin is for transposing down)
      // will return null if there are no more accidentals that are higher (or lower) than acc.
      //
      // acc: a value from the Accidental enum
      // edo: the tuning system
      //
      // <TUNING SYSTEM VARIANT CHECKPOINT>
      function getNextAccidental(acc, edo) {
        /*
        1. keep the main accidental as much as possible, if it is natural, leave it as natural

        2. increase the number of up arrows by one

        3. if the next accidental (determined by + sharp value) matches the transposed note
          perfectly without any arrows, use that instead

        4. if the new transposed note matches exactly half or one and a half steps that a sharp/flat
           would transpose it by, use a quarter tone accidental.

        5. once 3 arrows are exceeded, a different accidental has to be used

        6. if 3 arrows are exceeded and no accidentals are found that allows the note to be spelt with
           less than or eq. to 3 arrows, there is no such note and the tuning system cannot be supported
           as there are more notes than the number of accidentals available in musescore
        */
        var fifthStep = Math.round(edo * Math.log(3/2) / Math.log(2));
        var sharpValue = 7 * fifthStep - 4 * edo;

        var acc = deconstructAccidental(acc);

        console.log('get next called: sharps: ' + acc.numSharps + ', arrows: ' + acc.numArrows);

        // handle quarter tone accidentals
        if (acc.numSharps % 1 !== 0) {
          if (acc.numSharps > 0) {
            acc.numSharps = Math.floor(Math.abs(acc.numSharps));
            acc.numArrows = Math.round(sharpValue / 2);
          } else {
            acc.numSharps = -Math.floor(Math.abs(acc.numSharps));
            acc.numArrows = -Math.round(sharpValue / 2);
          }
        }

        // <UP DOWN VARIANT CHECKPOINT>
        acc.numArrows --; // NOTE: set to -- for downwards plugin

        // Sharp-flat manipulation section.
        // disregard this section if perfect EDO (sharp-0), as sharps and flats do nothing to the scale.
        if (sharpValue != 0) {
          // check if the number of arrows coincide with a standard accidental
          // <UP DOWN VARIANT CHECKPOINT>: negate sharp value for downwards plugins
          if (sharpValue < 0 && acc.numArrows == sharpValue && acc.numSharps < 2)
            return constructAccidental(acc.numSharps + 1, 0);
          // in a flat-n edo, pythagorically flatenning the note raises the pitch.
          else if (sharpValue > 0 && acc.numArrows == -sharpValue && acc.numSharps > -2)
            return constructAccidental(acc.numSharps - 1, 0);

          // check if the number of arrows coincide with quarter tone accidentals
          else if (acc.numArrows == 1/2 * sharpValue && acc.numSharps < 2 && sharpValue >= 8)
            return constructAccidental(acc.numSharps + 0.5, 0);
          else if (acc.numArrows == -1/2 * sharpValue && acc.numSharps > -2 && sharpValue >= 8)
            return constructAccidental(acc.numSharps - 0.5, 0);
          else if (acc.numArrows == 3/2 * sharpValue && acc.numSharps < 1 && sharpValue >= 8)
            return constructAccidental(acc.numSharps + 1.5, 0);
          else if (acc.numArrows == -3/2 * sharpValue && acc.numSharps > -1 && sharpValue >= 8)
            return constructAccidental(acc.numSharps - 1.5, 0);

          // check if number of arrows exceeds sharpValue in the direction of transposition,
          // and thus can be better represented with a different base accidental.
          // <UP DOWN VARIANT CHECKPOINT>: negate sharpValue for downwards plugin
          else if (sharpValue > 0 && acc.numArrows < -3 * sharpValue && acc.numSharps > 0)
            return constructAccidental(acc.numSharps - 3, acc.numArrows + sharpValue * 3);
          else if (sharpValue > 0 && acc.numArrows < -2 * sharpValue && acc.numSharps > -1)
            return constructAccidental(acc.numSharps - 2, acc.numArrows + sharpValue * 2);
          else if (sharpValue > 0 && acc.numArrows < -sharpValue && acc.numSharps > -2)
            return constructAccidental(acc.numSharps - 1, acc.numArrows + sharpValue);
          // for flat-n edos, flats raise the pitch instead.
          else if (sharpValue < 0 && acc.numArrows < 3 * sharpValue && acc.numSharps < 0)
            return constructAccidental(acc.numSharps + 3, acc.numArrows - sharpValue * 3);
          else if (sharpValue < 0 && acc.numArrows < 2 * sharpValue && acc.numSharps < 1)
            return constructAccidental(acc.numSharps + 2, acc.numArrows - sharpValue * 2);
          else if (sharpValue < 0 && acc.numArrows < sharpValue && acc.numSharps < 2)
            return constructAccidental(acc.numSharps + 1, acc.numArrows - sharpValue);
        }

        // otherwise, make sure its a valid accidental
        if ((sharpValue > 0 && acc.numSharps == 2 && acc.numArrows > 3) ||
            (sharpValue < 0 && acc.numSharps == -2 && acc.numArrows > 3))
          return null;

        // make sure the number of arrows are valid. (from -3 to +3)
        // NOTE: will possibly return null from here if edo is perfect (sharp-0)
        if (sharpValue > 0) {
          if (acc.numArrows > 3 && acc.numArrows - sharpValue >= -3 && acc.numArrows - sharpValue <= 3 && acc.numSharps < 2)
            return constructAccidental(acc.numSharps + 1, acc.numArrows - sharpValue);
          else if (acc.numArrows < -3 && acc.numArrows + sharpValue >= -3 && acc.numArrows + sharpValue <= 3 && acc.numSharps > -2)
            return constructAccidental(acc.numSharps - 1, acc.numArrows + sharpValue);
        } else if (sharpValue < 0) {
          if (acc.numArrows > 3 && acc.numArrows + sharpValue >= -3 && acc.numArrows + sharpValue <= 3 && acc.numSharps > -2)
            return constructAccidental(acc.numSharps - 1, acc.numArrows + sharpValue);
          else if (acc.numArrows < -3 && acc.numArrows - sharpValue >= -3 && acc.numArrows - sharpValue <= 3 && acc.numSharps < 2)
            return constructAccidental(acc.numSharps + 1, acc.numArrows - sharpValue);
        }


        // console.log('constructing default: ' + acc.numSharps + ', ' + acc.numArrows);

        // if no such accidental exists, it will return null.
        var a = constructAccidental(acc.numSharps, acc.numArrows);
        // console.log('constructed: ' + convertAccidentalTypeToName(0 + a));
        return a;
      }

      // returns the note.line property after it has been enharmonically transposed
      // in the direction of the plugin.
      // NOTE: Set the coefficient to -1 for upwards plugins, and +1 for downwards plugins.
      // <UP DOWN VARIANT CHECKPOINT>
      function getNextLine(line) {
        return line + 1;
      }

      // returns the accidental equivalent of the next baseNote after the current baseNote
      // at maximum accidental offset is exceeded.
      //
      // The maximum accidental offset is x^3 (bb^3 for super-flat edos) for the upwards plugin
      // and bv3 (xv3 for super-flat) for the downwards plugin
      //
      // example: if the note is Bx^3, and there is no more accidental sharper than x^3,
      //          call this function with the arguments 'b' and 31 edo, and it will
      //          return Accidental.DOUBLE_SHARP_ONE_ARROW_UP representing the note
      //          that is one step higher than Bx^3 in 31 edo is Cx^.
      //          (distance between nominals B and C in 31 edo is 3 steps)
      //
      // <TUNING SYSTEM VARIANT CHECKPOINT>
      function getOverLimitEnharmonicEquivalent(baseNote, edo) {
        var fifthStep = Math.round(edo * Math.log(3/2) / Math.log(2));
        var sharpValue = 7 * fifthStep - 4 * edo;
        switch(baseNote) {
        // <UP DOWN VARIANT CHECKPOINT> change to D E G A B for downwards variant
        case 'd':
        case 'e':
        case 'g':
        case 'a':
        case 'b':
          // a whole tone up enharmonic nominal. Steps = 2 fifthStep - octave.
          var wholeToneSteps = 2 * fifthStep - edo;

          // <UP DOWN VARIANT CHECKPOINT> flip steps direction
          // limits are: x^3 or bb^3 (super-flat) if upwards, bbv3 or xv3 (super-flat) if downwards
          var overLimitSteps = (sharpValue >= 0) ? (-2 * sharpValue - 3 - 1) : (2 * sharpValue - 3 - 1);

          // <UP DOWN VARIANT CHECKPOINT> flip sign
          // Simulate going down an enharmonic diatonic whole tone, reducing the offset.
          var newSteps = overLimitSteps + wholeToneSteps;

          return convertStepsToAccidentalType(newSteps, edo);
        default:
          // a diatonic semitone up enharmonic nominal. Steps = -5 fifthStep + 3 octaves
          var semitoneSteps = -5 * fifthStep + 3 * edo;
          var overLimitSteps = (sharpValue >= 0) ? (2 * sharpValue + 3 + 1) : (-2 * sharpValue + 3 + 1);
          var newSteps = overLimitSteps - wholeToneSteps;
          return convertStepsToAccidentalType(newSteps, edo);
        }
      }

      // returns enharmonics above and below
      // {
      //   above: {baseNote: 'a' through 'g', offset: diesis offset}
      //   below: {baseNote: 'a' through 'g', offset: diesis offset}
      // }
      // <TUNING SYSTEM VARIANT CHECKPOINT>
      function getEnharmonics(baseNote, offset, edo) {
        var above, below;

        var fifthStep = Math.round(edo * Math.log(3/2) / Math.log(2));
        var sharpValue = 7 * fifthStep - 4 * edo;
        var wholeToneSteps = 2 * fifthStep - edo;
        var semitoneSteps = -5 * fifthStep + 3 * edo;

        switch (baseNote) {
        case 'a': case 'd': case 'g':
          above = offset - wholeToneSteps;
          below = offset + wholeToneSteps;
          break;
        case 'b': case 'e':
          above = offset - semitoneSteps;
          below = offset + wholeToneSteps;
          break;
        case 'c': case 'f':
          above = offset - wholeToneSteps;
          below = offset + semitoneSteps;
        }

        var lowerOffsetBound = -2 * Math.abs(sharpValue) - 3;
        var upperOffsetBound = 2 * Math.abs(sharpValue) + 3;

        above = above < lowerOffsetBound ? null : {
          baseNote: getNextNote(baseNote),
          offset: above
        };
        below = below > upperOffsetBound ? null : {
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
      function scanCustomKeySig(str, edo) {
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
          var accSteps = convertAccidentalToSteps(res[i].trim(), edo);
          var accType = convertAccidentalTextToAccidentalType(res[i].trim());
          keySig[notes[i]] = {offset: accSteps, type: accType};
        }

        return keySig;
      }

      // get the tick of a note object, whether it is a grace note or normal note.
      function getTick(note) {
        if (note.parent.parent.tick !== undefined)
          return note.parent.parent.tick;
        else
          return note.parent.parent.parent.tick;
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
              cmd('pitch-down');
              Qt.quit();
            }

            // These selected notes may be in any random order and may come from any staff
            // keep a registry of staff key signatures for ALL staves in order to reference
            // them according to which staff the current note element is in.

            // contains an array of staffKeySigHistory objects. Index in array corresponds to staffIdx number.
            // allEDOs and allA4Freqs have similar uses containing staffEDOHistory and staffA4FreqHistory objects
            // respectively.
            var allKeySigs = [];
            var allEDOs = [];
            var allA4Freqs = [];

            parms.bars = [];
            parms.currKeySig = parms.naturalKeySig;

            // populate all key signatures and bars
            for (var staff = 0; staff < curScore.nstaves; staff++) {
              var staffKeySigHistory = [];
              var staffEDOHistory = [];
              var staffA4FreqHistory = [];

              for (var voice = 0; voice < 4; voice++) {
                cursor.rewind(1);
                cursor.staffIdx = staff;
                cursor.voice = voice;
                cursor.rewind(0);

                console.log("processing custom key signatures staff: " + staff + ", voice: " + voice);

                while (true) {
                  if (cursor.segment) {
                    // scan edo & A4 tuning frequency first. key signature parsing is dependant on edo used.
                    for (var i = 0; i < cursor.segment.annotations.length; i++) {
                      var annotation = cursor.segment.annotations[i];
                      console.log("found annotation type: " + annotation.subtypeName());
                      if ((annotation.subtypeName() == 'Staff' && Math.floor(annotation.track / 4) == staff) ||
                          (annotation.subtypeName() == 'System')) {
                        var text = removeFormattingCode(annotation.text);
                        if (text.toLowerCase().trim().endsWith('edo')) {
                          var edo = parseInt(text.substring(0, text.length - 3));
                          if (edo !== NaN || edo !== undefined || edo !== null) {
                            console.log('found EDO annotation: ' + text)
                            staffEDOHistory.push({
                              tick: cursor.tick,
                              edo: edo
                            });
                          }
                        } else if (text.toLowerCase().trim().startsWith('a4:')) {
                          var txt = text.toLowerCase().trim();
                          if (txt.endsWith('hz'))
                            txt = txt.substring(0, txt.length - 2);
                          var a4Freq = parseFloat(txt.substring(3));
                          if (a4Freq !== NaN || a4Freq !== undefined || a4Freq !== null) {
                            console.log('found A4 frequency annotation: ' + text)
                            staffA4FreqHistory.push({
                              tick: cursor.tick,
                              a4Freq: a4Freq
                            });
                          }
                        }
                      }
                    }

                    // Check for StaffText key signature changes, then update staffKeySigHistory
                    for (var i = 0; i < cursor.segment.annotations.length; i++) {
                      var annotation = cursor.segment.annotations[i];
                      console.log("found annotation type: " + annotation.subtypeName());
                      if ((annotation.subtypeName() == 'Staff' && Math.floor(annotation.track / 4) == staff) ||
                          (annotation.subtypeName() == 'System')) {
                        var text = removeFormattingCode(annotation.text);
                        var mostRecentEDO = staffEDOHistory.length !== 0 ? staffEDOHistory[staffEDOHistory.length - 1].edo : null;
                        if (!mostRecentEDO)
                          mostRecentEDO = 12;
                        var maybeKeySig = scanCustomKeySig(text, mostRecentEDO);
                        if (maybeKeySig !== null) {
                          console.log("detected new custom keySig: " + text + ", staff: " + staff + ", voice: " + voice);
                          staffKeySigHistory.push({
                            tick: cursor.tick,
                            keySig: maybeKeySig
                          });
                        }
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
              allEDOs.push(staffEDOHistory);
              allA4Freqs.push(staffA4FreqHistory);
            } // end of key sig and bars population for all staves

            // Run transpose operation on all note elements.

            // contains list of notes that have already been transposed
            // this is to prevent repeat transposition in the event that
            // 2 notes tied to each other are individually selected.
            var affected = [];

            for (var i = 0; i < selectedNotes.length; i++) {
              var note = selectedNotes[i];

              parms.currKeySig = parms.naturalKeySig;
              parms.currEdo = 12;
              parms.currA4Freq = 440;

              // handle transposing the firstTiedNote in the event that a non-first tied note
              // is selected.
              note = note.firstTiedNote;

              var alreadyTrans = false;
              for (var j = 0; j < affected.length; j++) {
                if (affected[j].is(note)) {
                  alreadyTrans = true;
                  break;
                }
              }

              if (alreadyTrans)
                continue;

              affected.push(note);

              var notes = note.parent.notes; // represents the notes in the chord of the selected note.
              var noteChordIndex = -1; // Index of note in notes array
              for (var j = 0; j < notes.length; j++) {
                if (notes[j].is(note)) {
                  noteChordIndex = j;
                  break;
                }
              }

              console.log('noteChordIndex: ' + noteChordIndex);

              var segment;
              if (note.parent.parent.tick !== undefined)
                segment = note.parent.parent;
              else
                segment = note.parent.parent.parent;

              setCursorToPosition(cursor, segment.tick, note.track % 4, note.track / 4);

              console.log('indiv note: line: ' + note.line + ', accidental: ' + convertAccidentalTypeToName(0 + note.accidentalType) +
                        ', voice: ' + cursor.voice + ', staff: ' + cursor.staffIdx + ', tick: ' + segment.tick);

              // set cur key sig
              var mostRecentKeySigTick = -1;
              for (var j = 0; j < allKeySigs[cursor.staffIdx].length; j++) {
                var keySig = allKeySigs[cursor.staffIdx][j];
                if (keySig.tick <= segment.tick && keySig.tick > mostRecentKeySigTick) {
                  parms.currKeySig = keySig.keySig;
                  mostRecentKeySigTick = keySig.tick;
                }
              }

              var mostRecentEDOTick = -1;
              for (var j = 0; j < allEDOs[cursor.staffIdx].length; j++) {
                var edo = allEDOs[cursor.staffIdx][j];
                if (edo.tick <= segment.tick && edo.tick > mostRecentEDOTick) {
                  parms.currEdo = edo.edo;
                  mostRecentEDOTick = edo.tick;
                }
              }

              var mostRecentA4FreqTick = -1;
              for (var j = 0; j < allA4Freqs[cursor.staffIdx].length; j++) {
                var a4Freq = allA4Freqs[cursor.staffIdx][j];
                if (a4Freq.tick <= segment.tick && a4Freq.tick > mostRecentA4FreqTick) {
                  parms.currA4Freq = a4Freq.a4Freq;
                  mostRecentA4FreqTick = a4Freq.tick;
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
              func(note, segment, parms, cursor);
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
          // Standard implementation for phrase selection.
          for (var staff = startStaff; staff <= endStaff; staff++) {

            // reset barrings (actually, why tho?)
            parms.bars = [];

            // After every staff, reset the currKeySig back to the original keySig

            parms.currKeySig = parms.naturalKeySig;
            parms.currEdo = 12;
            parms.currA4Freq = 440;

            // Even if system text is used for key sig, the text
            // won't carry over for all voices (if the text was placed on voice 1, only
            // voice 1 will see the text)
            //
            // Therefore, all the diff custom key sig texts across all 4 voices
            // need to be aggregated into this array before the notes can be
            // tuned.
            var staffKeySigHistory = [];
            var staffEDOHistory = [];
            var staffA4FreqHistory = [];

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
                  // scan edo & A4 tuning frequency first. key signature parsing is dependant on edo used.
                  for (var i = 0; i < cursor.segment.annotations.length; i++) {
                    var annotation = cursor.segment.annotations[i];
                    console.log("found annotation type: " + annotation.subtypeName());
                    if ((annotation.subtypeName() == 'Staff' && Math.floor(annotation.track / 4) == staff) ||
                        (annotation.subtypeName() == 'System')) {
                      var text = removeFormattingCode(annotation.text);
                      if (text.toLowerCase().trim().endsWith('edo')) {
                        var edo = parseInt(text.substring(0, text.length - 3));
                        if (edo !== NaN || edo !== undefined || edo !== null) {
                          console.log('found EDO annotation: ' + text)
                          staffEDOHistory.push({
                            tick: cursor.tick,
                            edo: edo
                          });
                        }
                      } else if (text.toLowerCase().trim().startsWith('a4:')) {
                        var txt = text.toLowerCase().trim();
                        if (txt.endsWith('hz'))
                          txt = txt.substring(0, txt.length - 2);
                        var a4Freq = parseFloat(txt.substring(3));
                        if (a4Freq !== NaN || a4Freq !== undefined || a4Freq !== null) {
                          console.log('found A4 frequency annotation: ' + text)
                          staffA4FreqHistory.push({
                            tick: cursor.tick,
                            a4Freq: a4Freq
                          });
                        }
                      }
                    }
                  }

                  // Check for StaffText key signature changes, then update staffKeySigHistory
                  for (var i = 0; i < cursor.segment.annotations.length; i++) {
                    var annotation = cursor.segment.annotations[i];
                    console.log("found annotation type: " + annotation.subtypeName());
                    if ((annotation.subtypeName() == 'Staff' && Math.floor(annotation.track / 4) == staff) ||
                        (annotation.subtypeName() == 'System')) {
                      var text = removeFormattingCode(annotation.text);
                      var mostRecentEDO = staffEDOHistory.length !== 0 ? staffEDOHistory[staffEDOHistory.length - 1].edo : null;
                      if (!mostRecentEDO)
                        mostRecentEDO = 12;
                      var maybeKeySig = scanCustomKeySig(text, mostRecentEDO);
                      if (maybeKeySig !== null) {
                        console.log("detected new custom keySig: " + text + ", staff: " + staff + ", voice: " + voice);
                        staffKeySigHistory.push({
                          tick: cursor.tick,
                          keySig: maybeKeySig
                        });
                      }
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

                var mostRecentEDOTick = -1;
                for (var i = 0; i < staffEDOHistory.length; i++) {
                  var edo = staffEDOHistory[i];
                  if (edo.tick <= cursor.tick && edo.tick > mostRecentEDOTick) {
                    parms.currEdo = edo.edo;
                    mostRecentEDOTick = edo.tick;
                  }
                }

                var mostRecentA4FreqTick = -1;
                for (var i = 0; i < staffA4FreqHistory.length; i++) {
                  var a4Freq = staffA4FreqHistory[i];
                  if (a4Freq.tick <= cursor.tick && a4Freq.tick > mostRecentA4FreqTick) {
                    parms.currA4Freq = a4Freq.a4Freq;
                    mostRecentA4FreqTick = a4Freq.tick;
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

                        // skip notes that are tied to previous notes.
                        if (notes[j].tieBack)
                          continue;

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

                      // skip notes that are tied to previous notes.
                      if (note.tieBack)
                        continue;

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
      // if 'graceChord' is not undefined, contains the grace chord that the plugin is current processing.
      // If the plugin is processing a grace chord, only accidentals that are on/before the grace chord should
      // take effect, and not any sibling grace chords after the grace chord, nor the main chord itself.
      //
      // returns an Accidental enum vale if an explicit accidental exists,
      // or the string 'botched' if botchedCheck is true and it is impossible to determine what the exact accidental is
      // or null, if there are no explicit accidentals, and it is determinable.
      function getMostRecentAccidentalInBar(cursor, noteTick, line, tickOfThisBar, tickOfNextBar, botchedCheck, before, graceChord) {
        var originalCursorTick = cursor.tick;
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
          while (cursor.tick < tickOfThisBar && cursor.nextMeasure());
          while (cursor.tick < noteTick && cursor.next());

          // if before is true, move cursor to the segment BEFORE noteTick.
          if (before) {
            // but before that, ensure accidentals of grace notes attached to the current chord are picked up
            // as they constitute as 'before' the current chord.
            if (cursor.element && cursor.element.type == Ms.CHORD) {
              var graces = cursor.element.graceNotes;
              var beforeCurrent = graceChord === undefined;
              for (var i = graces.length - 1; i >= 0; i--) {
                if (!beforeCurrent) {
                  if (graces[i].is(graceChord))
                    beforeCurrent = true;
                  continue;
                }
                var nNotesInSameLine = 0;
                var explicitAccidental = undefined;
                var explicitPossiblyBotchedAccidental = undefined;
                var implicitExplicitNote = undefined; // the note that has `explicitPossiblyBotchedAccidental`
                for (var j = 0; j < graces[i].notes.length; j++) {
                  var note = graces[i].notes[j];
                  var isGraceBefore = note.noteType == NoteType.ACCIACCATURA || note.noteType == NoteType.APPOGGIATURE ||
                                      note.noteType == NoteType.GRACE4 || note.noteType == NoteType.GRACE16 ||
                                      note.noteType == NoteType.GRACE32;

                  if (isGraceBefore) {
                    if (note.line === line) {
                      nNotesInSameLine ++;
                      if(note.accidental) {
                        explicitAccidental = note.accidentalType;
                        console.log('found explicitAccidental (grace): ' + explicitAccidental);
                      }
                      else if (note.tpc <= 5 && note.tpc >= -1)
                        explicitPossiblyBotchedAccidental = Accidental.FLAT2;
                      else if (note.tpc <= 12 && note.tpc >= 6)
                        explicitPossiblyBotchedAccidental = Accidental.FLAT;
                      else if (note.tpc <= 26 && note.tpc >= 20)
                        explicitPossiblyBotchedAccidental = Accidental.SHARP;
                      else if (note.tpc <= 33 && note.tpc >= 27)
                        explicitPossiblyBotchedAccidental = Accidental.SHARP2;

                      if (note.tpc <= 12 || note.tpc >= 20)
                        implicitExplicitNote = note;
                    }
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
                } else if (nNotesInSameLine === 1 && explicitPossiblyBotchedAccidental &&
                          getTick(implicitExplicitNote.firstTiedNote) > mostRecentPossiblyBotchedAccTick) {
                  if (getTick(implicitExplicitNote.firstTiedNote) >= tickOfThisBar) {
                    mostRecentExplicitAcc = explicitPossiblyBotchedAccidental;
                    mostRecentPossiblyBotchedAccTick = getTick(implicitExplicitNote.firstTiedNote);
                  }
                }
              }
            }

            // then move cursor to segment before noteTick
            while (cursor.tick >= noteTick && cursor.prev());

          } // end of 'before' processing

          while (tickOfThisBar !== -1 && cursor.segment && cursor.tick >= tickOfThisBar) {
            if (cursor.element && cursor.element.type == Ms.CHORD) {
              // because this is backwards-traversing, it should look at the main chord first before grace chords.
              var notes = cursor.element.notes;
              var nNotesInSameLine = 0;
              var explicitAccidental = undefined;
              var explicitPossiblyBotchedAccidental = undefined;
              var implicitExplicitNote = undefined; // the note that has `explicitPossiblyBotchedAccidental`

              // processing main chord. skip this if graceChord is provided and the current tick is that
              // of the grace chord's parent chord's tick

              var searchGraces = false;
              if (graceChord !== undefined && graceChord.parent.parent.tick == cursor.tick)
                searchGraces = true;

              if (!searchGraces) {
                for (var i = 0; i < notes.length; i++) {
                  if (notes[i].line === line) {
                    nNotesInSameLine ++;

                    // console.log('found same line: ' + notes[i].line + ', acc: ' + convertAccidentalTypeToName(0 + notes[i].accidentalType) +
                    //             ', tick: ' + getTick(notes[i]) + ', tpc: ' + notes[i].tpc);

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
                    }
                    else if (notes[i].tpc <= 5 && notes[i].tpc >= -1)
                      explicitPossiblyBotchedAccidental = Accidental.FLAT2;
                    else if (notes[i].tpc <= 12 && notes[i].tpc >= 6)
                      explicitPossiblyBotchedAccidental = Accidental.FLAT;
                    else if (notes[i].tpc <= 26 && notes[i].tpc >= 20)
                      explicitPossiblyBotchedAccidental = Accidental.SHARP;
                    else if (notes[i].tpc <= 33 && notes[i].tpc >= 27)
                      explicitPossiblyBotchedAccidental = Accidental.SHARP2;

                    if (notes[i].tpc <= 12 || notes[i].tpc >= 20)
                      implicitExplicitNote = notes[i];
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
                } else if (nNotesInSameLine === 1 && explicitPossiblyBotchedAccidental &&
                           getTick(implicitExplicitNote.firstTiedNote) > mostRecentPossiblyBotchedAccTick) {
                  // NOTE: the 'explicit' implicit accidental must not have a tie that goes back to a previous bar.
                  //       otherwise, the accidental it represents is void and is of the previous bar, and not
                  //       the current.
                  if (getTick(implicitExplicitNote.firstTiedNote) >= tickOfThisBar) {
                    mostRecentExplicitAcc = explicitPossiblyBotchedAccidental;
                    mostRecentPossiblyBotchedAccTick = getTick(implicitExplicitNote.firstTiedNote);
                  }
                }
              }

              var graceChords = cursor.element.graceNotes;
              var beforeCurrent = !searchGraces;
              for (var i = graceChords.length - 1; i >= 0; i--) {
                if (!beforeCurrent) {
                  if (graceChords[i].is(graceChord))
                    beforeCurrent = true;
                  continue;
                }
                // iterate through all grace chords
                var notes = graceChords[i].notes;
                var nNotesInSameLine = 0;
                var explicitAccidental = undefined;
                var explicitPossiblyBotchedAccidental = undefined;
                var implicitExplicitNote = undefined;
                for (var j = 0; j < notes.length; j++) {
                  if (notes[j].line === line) {
                    nNotesInSameLine ++;

                    if(notes[j].accidental)
                      explicitAccidental = notes[j].accidentalType;
                    else if (notes[j].tpc <= 5 && notes[j].tpc >= -1)
                     explicitPossiblyBotchedAccidental = Accidental.FLAT2;
                    else if (notes[j].tpc <= 12 && notes[j].tpc >= 6)
                     explicitPossiblyBotchedAccidental = Accidental.FLAT;
                    else if (notes[j].tpc <= 26 && notes[j].tpc >= 20)
                     explicitPossiblyBotchedAccidental = Accidental.SHARP;
                    else if (notes[j].tpc <= 33 && notes[j].tpc >= 27)
                     explicitPossiblyBotchedAccidental = Accidental.SHARP2;

                    if (notes[j].tpc <= 12 || notes[j].tpc >= 20)
                      implicitExplicitNote = notes[j];
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
                } else if (nNotesInSameLine === 1 && explicitPossiblyBotchedAccidental &&
                          getTick(implicitExplicitNote.firstTiedNote) > mostRecentPossiblyBotchedAccTick) {
                  if (getTick(implicitExplicitNote.firstTiedNote) >= tickOfThisBar) {
                    mostRecentExplicitAcc = explicitPossiblyBotchedAccidental;
                    mostRecentPossiblyBotchedAccTick = getTick(implicitExplicitNote.firstTiedNote);
                  }
                }
              }
            }

            cursor.prev();
          }
        }

        console.log('orig cursor tick: ' + originalCursorTick);
        setCursorToPosition(cursor, originalCursorTick, thisCursorVoice, thisStaffIdx);

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
      //         If the explicit accidental is positioned at the tick itself, it will not be accounted for.
      //
      // graceChord: (Optional) if the plugin is currently processing a grace note, set this value to be the note's parent.
      //             This ensures that only accidentals on/before this grace chord are accounted for, and not those
      //             after, as all grace chords have the same tick value as its parent chord segment.
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
      function getAccidental(cursor, tick, noteLine, botchedCheck, parms, before, graceChord) {

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

        var result =
          getMostRecentAccidentalInBar(cursor, tick, noteLine, tickOfThisBar, tickOfNextBar, botchedCheck, before, graceChord);

        if (result === null || result === 'botched')
          return result;
        else {
          return {
            offset: convertAccidentalTypeToSteps(0 + result, parms.currEdo),
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
        var edo = parms.currEdo;
        var fifthStep = Math.round(edo * Math.log(3/2) / Math.log(2));
        var sharpValue = 7 * fifthStep - 4 * edo;

        noteData.line = note.line;
        noteData.tpc = note.tpc;
        noteData.tick = getTick(note);

        // <TUNING SYSTEM VARIANT CHECKPOINT>
        switch(note.tpc) {
        case -1: //Fbb
          noteData.baseNote = 'f';
          noteData.diesisOffset = -2 * sharpValue;
          noteData.implicitAccidental = Accidental.FLAT2;
          break;
        case 0: //Cbb
          noteData.baseNote = 'c';
          noteData.diesisOffset = -2 * sharpValue;
          noteData.implicitAccidental = Accidental.FLAT2;
          break;
        case 1: //Gbb
          noteData.baseNote = 'g';
          noteData.diesisOffset = -2 * sharpValue;
          noteData.implicitAccidental = Accidental.FLAT2;
          break;
        case 2: //Dbb
          noteData.baseNote = 'd';
          noteData.diesisOffset = -2 * sharpValue;
          noteData.implicitAccidental = Accidental.FLAT2;
          break;
        case 3: //Abb
          noteData.baseNote = 'a';
          noteData.diesisOffset = -2 * sharpValue;
          noteData.implicitAccidental = Accidental.FLAT2;
          break;
        case 4: //Ebb
          noteData.baseNote = 'e';
          noteData.diesisOffset = -2 * sharpValue;
          noteData.implicitAccidental = Accidental.FLAT2;
          break;
        case 5: //Bbb
          noteData.baseNote = 'b';
          noteData.diesisOffset = -2 * sharpValue;
          noteData.implicitAccidental = Accidental.FLAT2;
          break;

        case 6: //Fb
          noteData.baseNote = 'f';
          noteData.diesisOffset = -sharpValue;
          noteData.implicitAccidental = Accidental.FLAT;
          break;
        case 7: //Cb
          noteData.baseNote = 'c';
          noteData.diesisOffset = -sharpValue;
          noteData.implicitAccidental = Accidental.FLAT;
          break;
        case 8: //Gb
          noteData.baseNote = 'g';
          noteData.diesisOffset = -sharpValue;
          noteData.implicitAccidental = Accidental.FLAT;
          break;
        case 9: //Db
          noteData.baseNote = 'd';
          noteData.diesisOffset = -sharpValue;
          noteData.implicitAccidental = Accidental.FLAT;
          break;
        case 10: //Ab
          noteData.baseNote = 'a';
          noteData.diesisOffset = -sharpValue;
          noteData.implicitAccidental = Accidental.FLAT;
          break;
        case 11: //Eb
          noteData.baseNote = 'e';
          noteData.diesisOffset = -sharpValue;
          noteData.implicitAccidental = Accidental.FLAT;
          break;
        case 12: //Bb
          noteData.baseNote = 'b';
          noteData.diesisOffset = -sharpValue;
          noteData.implicitAccidental = Accidental.FLAT;
          break;

        case 20: //F#
          noteData.baseNote = 'f';
          noteData.diesisOffset = sharpValue;
          noteData.implicitAccidental = Accidental.SHARP;
          break;
        case 21: //C#
          noteData.baseNote = 'c';
          noteData.diesisOffset = sharpValue;
          noteData.implicitAccidental = Accidental.SHARP;
          break;
        case 22: //G#
          noteData.baseNote = 'g';
          noteData.diesisOffset = sharpValue;
          noteData.implicitAccidental = Accidental.SHARP;
          break;
        case 23: //D#
          noteData.baseNote = 'd';
          noteData.diesisOffset = sharpValue;
          noteData.implicitAccidental = Accidental.SHARP;
          break;
        case 24: //A#
          noteData.baseNote = 'a';
          noteData.diesisOffset = sharpValue;
          noteData.implicitAccidental = Accidental.SHARP;
          break;
        case 25: //E#
          noteData.baseNote = 'e';
          noteData.diesisOffset = sharpValue;
          noteData.implicitAccidental = Accidental.SHARP;
          break;
        case 26: //B#
          noteData.baseNote = 'b';
          noteData.diesisOffset = sharpValue;
          noteData.implicitAccidental = Accidental.SHARP;
          break;

        case 27: //Fx
          noteData.baseNote = 'f';
          noteData.diesisOffset = 2 * sharpValue;
          noteData.implicitAccidental = Accidental.SHARP2;
          break;
        case 28: //Cx
          noteData.baseNote = 'c';
          noteData.diesisOffset = 2 * sharpValue;
          noteData.implicitAccidental = Accidental.SHARP2;
          break;
        case 29: //Gx
          noteData.baseNote = 'g';
          noteData.diesisOffset = 2 * sharpValue;
          noteData.implicitAccidental = Accidental.SHARP2;
          break;
        case 30: //Dx
          noteData.baseNote = 'd';
          noteData.diesisOffset = 2 * sharpValue;
          noteData.implicitAccidental = Accidental.SHARP2;
          break;
        case 31: //Ax
          noteData.baseNote = 'a';
          noteData.diesisOffset = 2 * sharpValue;
          noteData.implicitAccidental = Accidental.SHARP2;
          break;
        case 32: //Ex
          noteData.baseNote = 'e';
          noteData.diesisOffset = 2 * sharpValue;
          noteData.implicitAccidental = Accidental.SHARP2;
          break;
        case 33: //Bx
          noteData.baseNote = 'b';
          noteData.diesisOffset = 2 * sharpValue;
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
            noteData.diesisOffset = convertAccidentalTypeToSteps(0 + note.accidentalType, edo);
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

        var graceChord = undefined;
        if (note.noteType == NoteType.ACCIACCATURA || note.noteType == NoteType.APPOGGIATURE ||
            note.noteType == NoteType.GRACE4 || note.noteType == NoteType.GRACE16 ||
            note.noteType == NoteType.GRACE32) {
          graceChord = note.parent;
        }

        var prevAcc = getAccidental(cursor, noteData.tick, note.line, false, parms, false, graceChord);
        if (prevAcc !== null) {
          // The 0 + is necessary here so the type coercion doesn't need to occur
          // in other places.
          noteData.implicitAccidental = 0 + prevAcc.type;
          noteData.diesisOffset = prevAcc.offset;
        } else {
          // No accidentals - check key signature.
          var keySig = parms.currKeySig[noteData.baseNote];
          // The 0 + is necessary here so the type coercion doesn't need to occur
          // in other places.
          noteData.implicitAccidental = 0 + keySig.type;
          noteData.diesisOffset = keySig.offset;
        }

        return noteData;
      }

      function tuneNote(note, segment, parms, cursor) {

        // See: https://musescore.org/en/node/305667
        // setting accidentalType property calls Score::changeAccidental(), which
        // uses the line number attribute to derive the tpc value,
        // then, the tpc is overwritten.

        // In order to change the pitch of an existing note, the correct order of operations would be
        // 1. set Line number
        // 2. set accidental
        // 3. set tuning

        // Definitions:
        // 'enharmonic' means that the current note is going to be spelt with a new letter
        //              after transposition

        // 'line': the note.line property. Represents vertical height of the note on the staff.
        //         As it increases, the pitch of the note goes DOWN diatonically.
        //         F5 on the treble clef (middle of top staff line) is represented by the number 0

        // 'double line note': two, or more, notes sharing the same line in the same chord.
        //                     this is a cause of many problems that this plugin has to deal with.


        // Process:
        //
        // 0. Identify exactly what this note WAS. Remember and save it.
        //     - alphabet
        //     - Line
        //     - accidental type (even if it is implicit)
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

        //    At this stage, the new transposed note is FINALIZED. However, DO NOT
        //    update the note properties just yet, as it would affect the perceived pitches of the following notes,
        //    should they coincide with the same 1 or 2 staff lines that the transposition of the note affects.
        //
        //    If the accidentals were to be updated before checking for the following notes,
        //    there would be no way to check what the original pitch values of the following notes were,
        //    in the event that they would have been affected by the addition of an accidental on the
        //    current note.

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
        //         share the same tick values, but notes are always fed to the
        //         plugin API in the same order they are displayed, which would mean
        //         using the index of which the note appears in the Chord.notes array
        //         to determine which note (in the same chord and line) comes first is
        //         perfectly ok.
        //
        //         Musescore orders the notes in the Chord.notes array from left to right, then bottom to top,
        //         in terms of how they are displayed, which ensures all the notes on the same line are
        //         adjacent elements in the note array, which this algorithm uses to its advantage.
        //
        //         Experiements are done to prove that musescore does not tamper with note index order within
        //         the Chord.notes array whilst pitches / lines are being edited. Even when the cursor
        //         is moved back and forth between segments, the indices of all the notes hold their correlation
        //         no matter the new pitch and displayed order of notes.
        //
        //         HOWEVER, there is no way of predicting whether a note tranposed up to a new line
        //         will appear before or after notes that already exist in that line.
        //         XXX: This causes a HUGE problem because there's no way to determine whether
        //         a note on the same line in a following chord segment will have its accidental
        //         affected or not. As such, if a note is enharmonically transposing, BOTH same-line notes
        //         that are within the same chord as the transposed note, AND that are within an
        //         adjacent chord segment in the same bar will have to be given EXPLICIT accidentals.
        //         This is as much for machine as it is for human readability.
        //
        //         The accidental state at line of which the new note enharmonically transposes to is
        //         BOTCHED at that particular tick segment and its value is unpredictable and useless.
        //         The plugin will make a best effort attempt to reinstate the newly transposed note's
        //         accidental as the most updated accidental state, but there is no telling whether or
        //         not the transposed note takes precedence and comes after all the other notes in the
        //         chord that shares the same line, thus the plugin will try to detect double-note lines
        //         and try its best to avoid making guesses.
        //
        //         So far, the botched the accidental state problem affects case vi. of step 2,
        //         and also the accidental state required in steps 1e. and 1f.
        //
        //         THIS ISSUE HAS BEEN SOLVED by introducing STATELESS accidental evaluation.
        //         This plugin now reads accidentals from the score directly in a best-effort attempt
        //         to prevent making dumb guesses.
        //
        //         In addition, a few key notes are populated and updated into parms for each
        //         note to be operated on:
        //
        //         the parms.noteOnSameOldLineAfter value contains the first
        //         note element object after the note to be transposed note that is of the same
        //         chord and line as the transposed note before transposing, respectively.
        //
        //         Similarly, notesOnSameNewLine contains ALL the notes that the new transposed note
        //         would share the same line with after transposition has taken place.
        //         This value is HYPOTHETICAL as it only applies if the transposed note is enharmonically spelt.
        //
        //         These notes, if present, take the place of the notes other following chord segments
        //         that share the same line as the note lines before or after transposing, as it would have come first.

        // 2. Determine when corrective explicit accidentals have to be added before altering the main note.
        //    Register which explicit accidentals can be made implicit AFTER the main note is transposed.
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
        //
        //      An immediate note represents:
        //        - If the note is not enharmonically tranposed, the first note within the
        //          same bar on the same line as the transposing note prior to tranposing,
        //          that is after the lastTiedNote of the transposing note.
        //        - If the note is enharmonically tranposed, the first note within the same
        //          bar on the same line as the tranposing note after enharmonically transposing,
        //          that is after the lastTiedNote of the transposing note. (rep by followingNewLine)
        //         AND
        //          the first note that does not have tieBack within the bar on the same line as the
        //          transposing note prior to transposing.
        //        - if the note is a grace note (before), other subsequent grace notes and notes in the main chord
        //          element itself are candidates for immediate notes.
        //
        //      An explicit accidental is ALWAYS added on the immediate notes within the same bar unless:
        //      i.    an explicit accidental already exists on them
        //              OR
        //      ii.   the tranposed note after transposition shares the same accidental as the immmediate note
        //            on the transposed note's new line.
        //            EXCEPT if the note is spelt enharmonically and after transposition it ends up sharing
        //                   its line with other notes in the same chord, then all immediate notes have to
        //                   be made explicit,
        //                   OR
        //                   if the immediate note shares the same line as another note in its chord.
        //              OR
        //      iii.  the note to be transposed was implicit (prior to tranposition) AND moving out
        //            of the way (changing to a new line).
        //
        //            By logical deduction, this means that a prior explicit accidental has been
        //            affecting both the transposed note and the immediate note following on the same
        //            line, thus it doesn't matter whether or not what the prior explicit accidental
        //            was, and it needn't be evaluated.
        //
        //      WARNING: If the note after transposition is enharmonically spelt, the defintion of
        //               immediate notes in cases i. - iii. includes:
        //                 - the array of notes in the same chord as the
        //                   transposed note that would share the same NEW line as the note post-transposition,
        //                 - the immediate following note in a subsequent chord segment in the same bar
        //                   sharing the same NEW line.
        //                 - the immediate following note in a subsequent chord segment in the same bar
        //                   sharing the same OLD line as the note prior to transposition.
        //
        //      An accidental can be made implicit on the immediate notes with when:
        //      iv. The immediate note DOES NOT share the same line as another note in its chord.
        //          All notes that share the same line MUST have explicit accidentals, for
        //          clarity for both human and machine.
        //        AND
        //         | v.   The newly transposed note has an explicit accidental that renders
        //         |      the explicitly following accidental on the post-transpose line redundant.
        //         |      AND, if the transposed note is enharmonically spelt, it does NOT share
        //         |      a line with other notes in its chord after it has been transposed.
        //         |      (this is the converse of the logic implied in the warning in cases i. - iii.)
        //         |           OR
        //         | vi.  The newly transposed note is enharmonically spelled and moves out of the way
        //         |      for an accidental prior to the transposed note to affect the following note, thus
        //         |      making an explicit accidental on the following note redundant.
        //         |      This case only applies to the following note on the old line before transposition has
        //         |      taken place, followingOldLine.
        //         |           OR
        //         | vii. The newly transposed note is enharmonically spelled and was sharing its line
        //                with another note prior to transposition.
        //                Once the newly transposed note is transposed, it removes ambiguity of the
        //                accidental on the old line, (and registerAccidental should be called to
        //                reinstate proper accidental state), and thus it can be determined
        //                if the following note on the old line can have its accidental made implicit
        //                or not by checking for the 'prior accidental' (see below for definition) as of the current tick,
        //                and the accidental of the singular note on the old line in the current chord.
        //
        //           NOTE: Cases vi and vii only apply to followingOldLine.
        //
        //      WARNING: in cases vi and vii, the definition of the 'prior accidental' is very specific.
        //
        //               It is sourced from the following sources, from highest to lowest precedence:
        //
        //               1. parms.accOnSameLineBefore
        //               2. most updated accidental state as of the tick of the previous note
        //               3. key signature
        //
        //               In a simple scenario, it would be defined as the accidental state
        //               at the tick time of the previous chord segment, or if no accidentals
        //               exist on that line in that bar, then it will source the accidental from
        //
        //               However, thanks to the possibility of having multiple notes
        //               that share the same line within the same chord, the most recent note
        //               that has an explicit accidental before the current transposed note
        //               may just be from the same chord as well, and hence would not be reflected
        //               in the accidental state, as it can only contain one accidental per line per tick,
        //               and would have been overriden.
        //
        //               As such, parms.accOnSameLineBefore is provided, holding the value of the accidental type
        //               of the most recent note that shares the same line within the same chord as the tuning note,
        //               if it exists, and would take precedence over the accidental state of the segment prior
        //               to the current segment of the transposed note.
        //
        //      NOTE: Cases v and vi could be turned off in another version of this plugin where all explicit
        //            accidentals will always be kept by default, which would be helpful for serialist music.
        //
        //    Whenever accidentals on immediate notes are created or destroyed on the following notes,
        //    registerAccidental and removeAccidental should be called to update accidental state.
        //
        //    accidentals will be created:
        //      - for the accidentals created after the new transposed note to prevent the new transposed note's
        //        new accidental from affecting the notes after it.
        //
        //    accidentals will be removed:
        //      - WARNING: NEVER! The accidentals to be made implicit will only have their accidentals removed after the main
        //                 note is changed!

        // 3. Set the curent note's line, accidental and tuning in that order.

        // 4. Remove accidentals on notes registered to have their accidentals removed.

        // DONE!


        // Step 0

        var graceChord = undefined;
        if (note.noteType == NoteType.ACCIACCATURA || note.noteType == NoteType.APPOGGIATURE ||
            note.noteType == NoteType.GRACE4 || note.noteType == NoteType.GRACE16 ||
            note.noteType == NoteType.GRACE32) {
          graceChord = note.parent;
        }

        var pitchData = getNotePitchData(cursor, note, parms);

        console.log('pitchData: note: ' + pitchData.baseNote +
                  ', acc: ' + convertAccidentalTypeToName(pitchData.implicitAccidental) +
                  ', explicit: ' + (pitchData.explicitAccidental != undefined ? convertAccidentalTypeToName(pitchData.explicitAccidental) : 'none') +
                  ', line: ' + pitchData.line + ', offset: ' + pitchData.diesisOffset);


        // step 1a. determine naive pitch and accidental of new tranposed note
        // the mutable newAccidental, newOffset, newLine, and newBaseNote
        // variables represent the new note this current note would be tuned to.

        // this will be null if there are no more accidentals to use
        var newAccidental = getNextAccidental(pitchData.implicitAccidental, parms.currEdo);
        console.log(newAccidental);
        // if true, denotes that the note should be spelt with a different baseNote.
        var usingEnharmonic = false;
        if (newAccidental === null) {
          // the current note is at its absolute max pitch
          usingEnharmonic = true;
          newAccidental = getOverLimitEnharmonicEquivalent(pitchData.baseNote, parms.currEdo);
        }

        // diesis offset of the accidental of the next base note at this point in time.
        var newOffset = convertAccidentalTypeToSteps(newAccidental, parms.currEdo);
        console.log('new offset: ' + newOffset);

        // If an enharmonic spelling is required while transposing upwards,
        // the new line is the note above it.
        var newLine = usingEnharmonic ? getNextLine(pitchData.line) : pitchData.line;

        // <UP DOWN VARIANT CHECKPOINT> (use getPrevNote for downwards transposition)
        var newBaseNote = usingEnharmonic ? getPrevNote(pitchData.baseNote) : pitchData.baseNote;

        var nextNoteEnharmonics = getEnharmonics(newBaseNote, newOffset, parms.currEdo);

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
          nextNoteEnharmonics = getEnharmonics(newBaseNote, newOffset, parms.currEdo);
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
          nextNoteEnharmonics = getEnharmonics(newBaseNote, newOffset, parms.currEdo);
        }

        // Step 1c. If accidental offset of new note exceeds or equals offset on the key signature
        //          of the enharmonic equivalent above/below (depending of the direction of the plugin)
        //          the new note, in the direction that the plugin is transposing,
        //          use the enharmonic equivalent spelling instead.
        //          (Note that the equals in the inequality is only there because in very small edos like 5 EDO,
        //          the above logical condition 1b does not hold true as an enharmonic non-accidental equivalent
        //          exists, but only more than 1 diatonic step away. (B-C, E-F are equal in pitch))
        //
        // e.g. key signature has Db, new note (going upwards) is C#+. The enharmonic equiv of C#+
        //      spelt with D is Dv, and Dv has an offset that exceeds Db (in the upwards direction),
        //      so the C#+ would be spelt as Dv instead.
        //

        // NOTE: the enharmonic to use, and the inequality to check of the downwards
        //       variant of this plugin will have to be inverted.
        // <UP DOWN VARIANT CHECKPOINT>
        // This is now a while statement as in 5 edo and other super small edos,
        // this thing can get REALLY screwed. (e.g. E and F are the same note in 5 edo,
        // so going up by single enharmonic won't do anything for reducing the accidental steps)
        while (nextNoteEnharmonics.below &&
               nextNoteEnharmonics.below.offset <= parms.currKeySig[nextNoteEnharmonics.below.baseNote].offset) {
          newBaseNote = nextNoteEnharmonics.below.baseNote;
          newLine = getNextLine(newLine);
          newAccidental = convertStepsToAccidentalType(nextNoteEnharmonics.below.offset, parms.currEdo);
          newOffset = nextNoteEnharmonics.below.offset;
          nextNoteEnharmonics = getEnharmonics(newBaseNote, newOffset, parms.currEdo);
        }

        // Step 1d is a converse of clause 1c, it is implicitly implemented in the implementation
        // of the above clauses. YAY!

        // Step 1e. Check if new accidental corresponds exactly to the key signature accidental type and
        //          no prior explicit accidentals are in the bar. If so, the new note's accidental can be implicit.

        // before making the final explicit accidental NONE when it can be made implicit, store
        // the accidental it should represent. Used for Step 2. v. followingOldLine
        var newImplicitAccidental = newAccidental;

        var priorAccOnNewLine = getAccidental(cursor, pitchData.tick, newLine, true, parms, true, graceChord);

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

        // If this note is a grace note, check other grace notes and the parent chord element itself
        // for following notes first

        if (graceChord !== undefined) {
          var chordObj = note.parent.parent; // main chord object
          var graces = chordObj.graceNotes; // array of chord objects
          var followingCurrent = false;
          // run through all grace notes in order of left to right.
          for (var i = 0; i < graces.length; i++) {
            if (!followingCurrent) {
              if (graces[i].is(graceChord)) {
                // we've reached the current grace note's chord.
                followingCurrent = true;
                // no need to check for same line in same chord, should have already been present in parms.
              }
              continue;
            }

            for (var j = 0; j < graces[i].notes.length; j ++) {
              var g = graces[i].notes[j];

              if (!g.tieBack) {
                if (g.line == note.line) {
                  if (!followingOldLine)
                    followingOldLine = g;
                  if (!followingOldLineNewSegment)
                    followingOldLineNewSegment = g;
                }
                else if (usingEnharmonic && !followingNewLine && g.line == newLine)
                  followingNewLine = g;
              }
            }
          }

          // check parent chord for any notes on same line.
          for (var i = 0; i < chordObj.notes.length; i ++) {
            var n = chordObj.notes[i];

            if (!n.tieBack) {
              if (n.line == note.line) {
                if (!followingOldLine)
                  followingOldLine = n;
                if (!followingOldLineNewSegment)
                  followingOldLineNewSegment = n;
              }
              else if (usingEnharmonic && !followingNewLine && n.line == newLine)
                followingNewLine = n;
            }
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
                  var ntick = getTick(notes[j]);
                  if (!notes[j].tieBack) {
                    if (notes[j].line == note.line && ntick > pitchData.tick) {
                      if (!followingOldLine || (followingOldLine && ntick < getTick(followingOldLine)))
                        followingOldLine = notes[j];
                      if (!followingOldLineNewSegment ||
                          (followingOldLineNewSegment && ntick < getTick(followingOldLineNewSegment)))
                        followingOldLineNewSegment = notes[j];
                    } else if (usingEnharmonic &&
                        (!followingNewLine ||
                          (followingNewLine && ntick < getTick(followingNewLine))) &&
                        notes[j].line == newLine && ntick > pitchData.tick)
                        followingNewLine = notes[j];
                  }
                }
              }
              var notes = cursor.element.notes;
              for (var i = 0; i < notes.length; i++) {
                var ntick = getTick(notes[i]);
                if (!notes[i].tieBack) {
                  // if current note is grace note, allow standard notes in all voices at the same tick position
                  // to be candidates, as the grace notes would come before them.
                  if (notes[i].line == note.line && (ntick > pitchData.tick || ((graceChord !== undefined) && ntick >= pitchData.tick))) {
                    if (!followingOldLine || (followingOldLine && ntick < getTick(followingOldLine)))
                      followingOldLine = notes[i];
                    if (!followingOldLineNewSegment || (followingOldLineNewSegment && ntick < getTick(followingOldLineNewSegment)))
                      followingOldLineNewSegment = notes[i];
                  } else if (usingEnharmonic &&
                      (!followingNewLine || (followingNewLine && ntick < getTick(followingNewLine))) &&
                      notes[i].line == newLine && (ntick > pitchData.tick || ((graceChord !== undefined) && ntick >= pitchData.tick)))
                      followingNewLine = notes[i];
                }
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
          console.log('followingOldLine: ' + followingOldLine.line + ' @ ' + getTick(followingOldLine) +
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

                  var recAcc = getAccidental(cursor, pitchData.tick, followingOldLine.line, true, parms, true, graceChord);

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
                    var recAcc = getAccidental(cursor, pitchData.tick, followingOldLine.line, true, parms, true, graceChord);
                    if (recAcc == 'botched')
                      botched = true;
                    else if (recAcc !== null)
                      accInThisChordOnOldLine = recAcc.type;
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
            //
            // This case will never be true.
            // When the following note has no accidental, any change to the current note's
            // accidental will affect the next note.

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
            // NOTE: The only situation in which this happens is if newAccidental has
            //       NO accidental. That is the only time it will match with the following
            //       accidentalType.

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

              var fnlType = followingNewLine.noteType;
              var fnlGC = undefined;
              if (fnlType == NoteType.ACCIACCATURA || fnlType == NoteType.APPOGGIATURE ||
                  fnlType == NoteType.GRACE4 || fnlType == NoteType.GRACE16 ||
                  fnlType == NoteType.GRACE32) {
                fnlGC = note.parent;
              }

              var accObj = getAccidental(cursor, getTick(followingNewLine), followingNewLine.line, false, parms, fnlGC);

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
              var accObj = getAccidental(cursor, pitchData.tick, n.line, false, parms, graceChord);

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

        note.tuning = getCentOffset(newBaseNote, newOffset, parms.currEdo, parms.currA4Freq);


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
