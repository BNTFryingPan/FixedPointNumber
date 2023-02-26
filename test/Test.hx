import haxe.PosInfos;
import FixedPointNumber;

class Test {
   static var tests = 0;
   static var fails = 0;

   public static function test(result:FixedPointNumber, expected:Int, ?pos:PosInfos) {
      tests++;
      if (result.asInt() == expected) {
         trace('${pos.lineNumber} passed ($result, $expected)');
      } else {
         trace('${pos.lineNumber} fail ($result, $expected)');
         fails++;
      }
   }

   public static function testI(result:Float, expected:Float, ?pos:PosInfos) {
      tests++;
      if (result == expected) {
         trace('${pos.lineNumber} passed ($result, $expected)');
      } else {
         trace('${pos.lineNumber} fail ($result, $expected)');
         fails++;
      }
   }

   public static function testComp(result:Bool, expected:Bool, ?pos:PosInfos) {
      tests++;
      if (result == expected) {
         trace('${pos.lineNumber} passed ($result, $expected)');
      } else {
         trace('${pos.lineNumber} fail ($result, $expected)');
         fails++;
      }
   }

   public static function main() {
      trace('conversion tests');
      test(FixedPointNumber.fromInt(5), 327680);
      test(FixedPointNumber.fromFloat(2.5), 163840);
      testI(FixedPointNumber.ONE.toInt(), 1);
      testI(FixedPointNumber.HALF.toFloat(), 0.5);
      trace('basic math tests');
      test((2.5 : FixedPointNumber) * 2, 327680);
      test((2.5 : FixedPointNumber) * (2 : FixedPointNumber), 327680);
      test(2 * (2.5 : FixedPointNumber), 327680);
      test((5 : FixedPointNumber) / 2, 163840);
      test((5 : FixedPointNumber) / (2 : FixedPointNumber), 163840);
      test((3 : FixedPointNumber) + 2, 327680);
      test((3 : FixedPointNumber) + (2 : FixedPointNumber), 327680);
      test((5 : FixedPointNumber) - 2, 196608);
      test((5 : FixedPointNumber) - (2 : FixedPointNumber), 196608);
      test((10 : FixedPointNumber) % 6, 262144);
      test((10 : FixedPointNumber) % (6 : FixedPointNumber), 262144);
      test(10 % (6 : FixedPointNumber), 262144);
      test((5 : FixedPointNumber) % 5, 0);
      test(5 % (5 : FixedPointNumber), 0);
      test((5 : FixedPointNumber) % (5 : FixedPointNumber), 0);
      trace('equality tests');
      var FixTwo:FixedPointNumber = 2;
      var FixOne:FixedPointNumber = 1;
      testComp(FixTwo == FixTwo, true);
      testComp(FixTwo == FixOne, false);
      testComp(FixTwo != FixOne, true);
      testComp(FixTwo != FixTwo, false);
      testComp(FixTwo == 2, true);
      testComp(FixTwo == 2.0, true);
      testComp(FixTwo == 1, false);
      testComp(FixTwo == 1.0, false);
      testComp(FixTwo != 1, true);
      testComp(FixTwo != 2, false);
      trace('comparison tests');

      testComp(FixTwo > FixOne, true);
      testComp(FixOne > FixTwo, false);
      testComp(FixTwo > FixTwo, false);
      testComp(FixTwo < FixOne, false);
      testComp(FixOne < FixTwo, true);
      testComp(FixTwo < FixTwo, false);
      testComp(FixTwo > 1, true);
      testComp(FixOne > 2, false);
      testComp(FixTwo > 2, false);
      testComp(2 > FixOne, true);
      testComp(2 > FixTwo, false);
      testComp(1 > FixTwo, false);
      testComp(1 < FixTwo, true);
      testComp(2 < FixTwo, false);
      testComp(1 < FixOne, false);

      trace('inc/decrement');
      test((0 : FixedPointNumber) ++, 0);
      test(++(0 : FixedPointNumber), 65536);
      test((0 : FixedPointNumber) --, 0);
      test(--(0 : FixedPointNumber), -65536);
      trace('bitwise');
      test(FixedPointNumber.ONE >> 1, 65536 >> 1);
      test(FixedPointNumber.ONE >> 2, 65536 >> 2);
      test(FixedPointNumber.EPSILON << 1, 1 << 1);
      test(FixedPointNumber.EPSILON << 2, 1 << 2);
      test(FixedPointNumber.EPSILON << 16, 1 << 16);

      trace('advanced math');
      // test(FixedPointNumber.sqrt((25 : FixedPointNumber)), 327680);
      // test(FixedPointNumber.sqrt(new FixedPointNumber(25)), 327680);
      // test(FixedPointNumber.sin((1.5 : FixedPointNumber)), 0);

      trace('passed ${tests - fails} of ${tests} tests (${Std.int(((tests - fails) / tests) * 100)}%)');
      trace(FixedPointNumber.PI);
   }
}
