// Test paths taken from:
//   * https://github.com/chromium/chromium/blob/master/third_party/blink/renderer/core/svg/svg_path_parser_test.cc

import 'dart:ui';
import 'package:test/test.dart';

import 'package:path_drawing/src/parse_path.dart';

void main() {
  void assertValidPath(String input) {
    // these shouldn't throw or assert
    expect(parseSvgPathData(input), isNot(null));
  }

  void assertInvalidPath(String input) {
    expect(() => parseSvgPathData(input), throwsStateError);
  }

  test('Valid Paths', () {
    assertValidPath("M1,2");
    assertValidPath("m1,2");
    assertValidPath("M100,200 m3,4");
    assertValidPath("M100,200 L3,4");
    assertValidPath("M100,200 l3,4");
    assertValidPath("M100,200 H3");
    assertValidPath("M100,200 h3");
    assertValidPath("M100,200 V3");
    assertValidPath("M100,200 v3");
    assertValidPath("M100,200 Z");
    assertValidPath("M100,200 z");
    assertValidPath("M100,200 C3,4,5,6,7,8");
    assertValidPath("M100,200 c3,4,5,6,7,8");
    assertValidPath("M100,200 S3,4,5,6");
    assertValidPath("M100,200 s3,4,5,6");
    assertValidPath("M100,200 Q3,4,5,6");
    assertValidPath("M100,200 q3,4,5,6");
    assertValidPath("M100,200 T3,4");
    assertValidPath("M100,200 t3,4");
    assertValidPath("M100,200 A3,4,5,0,0,6,7");
    assertValidPath("M100,200 A3,4,5,1,0,6,7");
    assertValidPath("M100,200 A3,4,5,0,1,6,7");
    assertValidPath("M100,200 A3,4,5,1,1,6,7");
    assertValidPath("M100,200 a3,4,5,0,0,6,7");
    assertValidPath("M100,200 a3,4,5,0,1,6,7");
    assertValidPath("M100,200 a3,4,5,1,0,6,7");
    assertValidPath("M100,200 a3,4,5,1,1,6,7");
    assertValidPath("M100,200 a3,4,5,006,7");
    assertValidPath("M100,200 a3,4,5,016,7");
    assertValidPath("M100,200 a3,4,5,106,7");
    assertValidPath("M100,200 a3,4,5,116,7");
    assertValidPath(
        '''M19.0281,19.40466 20.7195,19.40466 20.7195,15.71439 24.11486,15.71439 24.11486,14.36762 20.7195,14.36762 
20.7195,11.68641 24.74134,11.68641 24.74134,10.34618 19.0281,10.34618 	z''');

    assertValidPath(
        "M100,200 a0,4,5,0,0,10,0 a4,0,5,0,0,0,10 a0,0,5,0,0,-10,0 z");

    assertValidPath("M1,2,3,4");
    assertValidPath("m100,200,3,4");

    assertValidPath("M 100-200");
    assertValidPath("M 0.6.5");

    assertValidPath(" M1,2");
    assertValidPath("  M1,2");
    assertValidPath("\tM1,2");
    assertValidPath("\nM1,2");
    assertValidPath("\rM1,2");
    assertValidPath("M1,2 ");
    assertValidPath("M1,2\t");
    assertValidPath("M1,2\n");
    assertValidPath("M1,2\r");
    assertValidPath("");
    assertValidPath(" ");
    assertValidPath("M.1 .2 L.3 .4 .5 .6");
    assertValidPath("M1,1h2,3");
    assertValidPath("M1,1H2,3");
    assertValidPath("M1,1v2,3");
    assertValidPath("M1,1V2,3");
    assertValidPath("M1,1c2,3 4,5 6,7 8,9 10,11 12,13");
    assertValidPath("M1,1C2,3 4,5 6,7 8,9 10,11 12,13");
    assertValidPath("M1,1s2,3 4,5 6,7 8,9");
    assertValidPath("M1,1S2,3 4,5 6,7 8,9");
    assertValidPath("M1,1q2,3 4,5 6,7 8,9");
    assertValidPath("M1,1Q2,3 4,5 6,7 8,9");
    assertValidPath("M1,1t2,3 4,5");
    assertValidPath("M1,1T2,3 4,5");
    assertValidPath("M1,1a2,3,4,0,0,5,6 7,8,9,0,0,10,11");
    assertValidPath("M1,1A2,3,4,0,0,5,6 7,8,9,0,0,10,11");
  });

  test('Malformed Paths', () {
    assertInvalidPath("M100,200 a3,4,5,2,1,6,7");
    assertInvalidPath("M100,200 a3,4,5,1,2,6,7");

    assertInvalidPath("\vM1,2");
    assertInvalidPath("xM1,2");
    assertInvalidPath("M1,2\v");
    assertInvalidPath("M1,2x");
    assertInvalidPath("M1,2 L40,0#90");

    assertInvalidPath("x");
    assertInvalidPath("L1,2");

    assertInvalidPath("M");
    assertInvalidPath("M\0");

    assertInvalidPath("M1,1Z0");
    assertInvalidPath("M1,1z0");

    assertInvalidPath("M1,1c2,3 4,5 6,7 8");
    assertInvalidPath("M1,1C2,3 4,5 6,7 8");
    assertInvalidPath("M1,1s2,3 4,5 6");
    assertInvalidPath("M1,1S2,3 4,5 6");
    assertInvalidPath("M1,1q2,3 4,5 6");
    assertInvalidPath("M1,1Q2,3 4,5 6");
    assertInvalidPath("M1,1t2,3 4");
    assertInvalidPath("M1,1T2,3 4");
    assertInvalidPath("M1,1a2,3,4,0,0,5,6 7");
    assertInvalidPath("M1,1A2,3,4,0,0,5,6 7");
  });

  test('Missing commands/numbers/flags', () {
    // Missing initial moveto.
    assertInvalidPath(" 10 10");
    assertInvalidPath("L 10 10");
    // Invalid command letter.
    assertInvalidPath("M 10 10 #");
    assertInvalidPath("M 10 10 E 100 100");
    // Invalid number.
    assertInvalidPath("M 10 10 L100 ");
    assertInvalidPath("M 10 10 L100 #");
    assertInvalidPath("M 10 10 L100#100");
    assertInvalidPath("M0,0 A#,10 0 0,0 20,20");
    assertInvalidPath("M0,0 A10,# 0 0,0 20,20");
    assertInvalidPath("M0,0 A10,10 # 0,0 20,20");
    assertInvalidPath("M0,0 A10,10 0 0,0 #,20");
    assertInvalidPath("M0,0 A10,10 0 0,0 20,#");
    // Invalid arc-flag.
    assertInvalidPath("M0,0 A10,10 0 #,0 20,20");
    assertInvalidPath("M0,0 A10,10 0 0,# 20,20");
    assertInvalidPath("M0,0 A10,10 0 0,2 20,20");
  });

  test('Check character constants', () {
    expect(AsciiConstants.slashT, '\t'.codeUnitAt(0));
    expect(AsciiConstants.slashN, '\n'.codeUnitAt(0));
    expect(AsciiConstants.slashF, '\f'.codeUnitAt(0));
    expect(AsciiConstants.slashR, '\r'.codeUnitAt(0));
    expect(AsciiConstants.space, ' '.codeUnitAt(0));
    expect(AsciiConstants.period, '.'.codeUnitAt(0));
    expect(AsciiConstants.plus, '+'.codeUnitAt(0));
    expect(AsciiConstants.comma, ','.codeUnitAt(0));
    expect(AsciiConstants.minus, '-'.codeUnitAt(0));
    expect(AsciiConstants.number0, '0'.codeUnitAt(0));
    expect(AsciiConstants.number1, '1'.codeUnitAt(0));
    expect(AsciiConstants.number2, '2'.codeUnitAt(0));
    expect(AsciiConstants.number3, '3'.codeUnitAt(0));
    expect(AsciiConstants.number4, '4'.codeUnitAt(0));
    expect(AsciiConstants.number5, '5'.codeUnitAt(0));
    expect(AsciiConstants.number6, '6'.codeUnitAt(0));
    expect(AsciiConstants.number7, '7'.codeUnitAt(0));
    expect(AsciiConstants.number8, '8'.codeUnitAt(0));
    expect(AsciiConstants.number9, '9'.codeUnitAt(0));
    expect(AsciiConstants.upperA, 'A'.codeUnitAt(0));
    expect(AsciiConstants.upperC, 'C'.codeUnitAt(0));
    expect(AsciiConstants.upperE, 'E'.codeUnitAt(0));
    expect(AsciiConstants.upperH, 'H'.codeUnitAt(0));
    expect(AsciiConstants.upperL, 'L'.codeUnitAt(0));
    expect(AsciiConstants.upperM, 'M'.codeUnitAt(0));
    expect(AsciiConstants.upperQ, 'Q'.codeUnitAt(0));
    expect(AsciiConstants.upperS, 'S'.codeUnitAt(0));
    expect(AsciiConstants.upperT, 'T'.codeUnitAt(0));
    expect(AsciiConstants.upperV, 'V'.codeUnitAt(0));
    expect(AsciiConstants.upperZ, 'Z'.codeUnitAt(0));
    expect(AsciiConstants.lowerA, 'a'.codeUnitAt(0));
    expect(AsciiConstants.lowerC, 'c'.codeUnitAt(0));
    expect(AsciiConstants.lowerE, 'e'.codeUnitAt(0));
    expect(AsciiConstants.lowerH, 'h'.codeUnitAt(0));
    expect(AsciiConstants.lowerL, 'l'.codeUnitAt(0));
    expect(AsciiConstants.lowerM, 'm'.codeUnitAt(0));
    expect(AsciiConstants.lowerQ, 'q'.codeUnitAt(0));
    expect(AsciiConstants.lowerS, 's'.codeUnitAt(0));
    expect(AsciiConstants.lowerT, 't'.codeUnitAt(0));
    expect(AsciiConstants.lowerV, 'v'.codeUnitAt(0));
    expect(AsciiConstants.lowerX, 'x'.codeUnitAt(0));
    expect(AsciiConstants.lowerZ, 'z'.codeUnitAt(0));
    expect(AsciiConstants.tilde, '~'.codeUnitAt(0));
  });
}
