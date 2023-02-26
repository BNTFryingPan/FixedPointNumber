package fixedpointnumber;

using haxe.Int64;

/**
   Abstract type that lets you write normal integers that get converted to and from fixed point automatically when needed.
**/
abstract FixedPointNumber64(Int64) {
   public static inline final SCALE = 65536; // 1 << 16
   public static final ONE:FixedPointNumber64 = 1;
   public static final HALF:FixedPointNumber64 = 0.5;
   public static final PI:FixedPointNumber64 = new FixedPointNumber64(205887);
   public static final PI_DIV_2:FixedPointNumber64 = new FixedPointNumber64(102943);
   public static final PI_DIV_4:FixedPointNumber64 = new FixedPointNumber64(51472);
   public static final E:FixedPointNumber64 = new FixedPointNumber64(178145);
   public static final TAU:FixedPointNumber64 = new FixedPointNumber64(411774);
   public static final EPSILON:FixedPointNumber64 = new FixedPointNumber64(1);

   inline public function new(value:Int64) {
      this = value;
   }

   /**
      allows typing `n(expr)` as shorthand for `new FixedPointNumber64(expr)`.
   **/
   static inline private function n(value:Int64):FixedPointNumber64 {
      return new FixedPointNumber64(value);
   }

   @:from static inline public function fromFloat(value:Float) {
      return n(Std.int(value * SCALE));
   }

   @:from static inline public function fromInt(value:Int) {
      return n(value * SCALE);
   }

   @:from static inline public function fromInt64(value:Int64) {
      return n(value * SCALE);
   }

   @:to inline public function toFloat():Float {
      return this.toInt() / SCALE;
   }

   @:to inline public function toInt():Int {
      return (this / SCALE).toInt();
   }

   public inline function toString():String {
      return 'FixedPointNumber64(raw=${this}, f=${toFloat()})';
   }

   public inline function asInt():Int64 {
      return this;
   }

   public inline function asInt32():Int {
      return this.toInt();
   }

   @:op(A * B) @:commutative inline function multiply(b:FixedPointNumber64):FixedPointNumber64 {
      return n((this * b.asInt()) >> 16);
   }

   @:op(A / B) @:commutative inline function divide(b:FixedPointNumber64):FixedPointNumber64 {
      return n((this << 16) / b.asInt());
   }

   @:op(A % B) static inline function mod(a:FixedPointNumber64, b:FixedPointNumber64):FixedPointNumber64 {
      return n(a.asInt() % b.asInt());
   }

   @:op(A + B) @:commutative inline function add(b:FixedPointNumber64):FixedPointNumber64 {
      return n(this + b.asInt());
   }

   @:op(A - B) @:commutative inline function sub(b:FixedPointNumber64):FixedPointNumber64 {
      return n(this - b.asInt());
   }

   @:op(A == B) @:commutative inline function equals(b:FixedPointNumber64):Bool {
      return this == b.asInt();
   }

   @:op(A != B) @:commutative inline function notEquals(b:FixedPointNumber64):Bool {
      return this != b.asInt();
   }

   @:op(A > B) static inline function greaterThan(a:FixedPointNumber64, b:FixedPointNumber64):Bool {
      return a.asInt() > b.asInt();
   }

   @:op(A >= B) static inline function greaterThanOrEqual(a:FixedPointNumber64, b:FixedPointNumber64):Bool {
      return a.asInt() >= b.asInt();
   }

   @:op(A < B) static inline function lessThan(a:FixedPointNumber64, b:FixedPointNumber64):Bool {
      return a.asInt() < b.asInt();
   }

   @:op(A <= B) static inline function lessThanOrEqual(a:FixedPointNumber64, b:FixedPointNumber64):Bool {
      return a.asInt() <= b.asInt();
   }

   @:op(A << B) function bitShiftLeft(b:Int):FixedPointNumber64 {
      return n(this << b);
   }

   @:op(A >> B) function bitShiftRight(b:Int):FixedPointNumber64 {
      return n(this >> b);
   }

   @:op(A >>> B) function bitShiftRightUnsigned(b:Int):FixedPointNumber64 {
      return n(this >>> b);
   }

   @:op(A & B) function bitwiseAnd(b:Int):FixedPointNumber64 {
      return n(this & b);
   }

   @:op(A | B) function bitwiseOr(b:Int):FixedPointNumber64 {
      return n(this | b);
   }

   @:op(A ^ B) function bitwiseXor(b:Int):FixedPointNumber64 {
      return n(this ^ b);
   }

   @:op(~A) function bitwiseNegate():FixedPointNumber64 {
      return n(~this);
   }

   @:op(-A) function negate():FixedPointNumber64 {
      return n(-this);
   }

   @:op(A++) function incrementPostfix():FixedPointNumber64 {
      var ret = this.copy();
      add(1);
      return n(ret);
   }

   @:op(++A) function incrementPrefix():FixedPointNumber64 {
      return add(1);
   }

   @:op(A--) function decrementPostfix():FixedPointNumber64 {
      var ret = this.copy();
      sub(1);
      return n(ret);
   }

   @:op(--A) function decrementPrefix():FixedPointNumber64 {
      return sub(1);
   }

   public static function sqrt(num:FixedPointNumber64):FixedPointNumber64 {
      if (num < 0)
         throw 'input should be non-negative';

      var x:Int64 = num.asInt();
      x = x << 16; // this is so cursed
      var c:Int64 = 0;
      var d:Int64 = (1 : Int64) << 62; // i hate this

      while (d > x) {
         d >>= 2;
      }

      while (d != 0) {
         if (x >= c + d) {
            x -= c + d;
            c = (c >> 1) + d;
         } else {
            c >>= 1;
         }
         d >>= 2;
      }
      return n(c);
   }

   public static function sin(n:FixedPointNumber64):FixedPointNumber64 {
      trace(n);
      var x:FixedPointNumber64 = n % FixedPointNumber64.TAU;
      trace(x);
      x = x / PI_DIV_2;
      trace(x);

      if (x < 0) {
         x += 4;
      }

      var sign:FixedPointNumber64 = 1;
      if (x > 2) {
         sign = -1;
         x -= 2;
      }
      trace(x);

      if (x > 1) {
         x = 2 - x;
      }
      trace(x);

      var x2 = x * x;
      trace(x * x);
      trace(x2);
      return (sign * x * (PI - x2 * (TAU - 5 - x2 * (PI - 3)))) >> 1;
      // return new FixedPointNumber64((sign_times_x * (pi_minus_x2 * (f_minus_x2 * three_less_than_pi))).asInt() >> 1);
   }
}
