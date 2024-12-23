// SPDX-License-Identifier: MIT
package shellco;

/**
    Utilities for making the code more concise.
**/
final class Extensions {

    /**
        Rounds a float towards 0.
        @param x The number to round.
        @param place (Optional) The decimal place.
        @return Rounded number.
    **/
    public static function round(x: Float, place: Int = 0): Float {
        for (i in 0...place)
            x *= 10.0;
        x = Std.int(x);
        for (i in 0...place)
            x /= 10.0;
        return x;
    }
}
