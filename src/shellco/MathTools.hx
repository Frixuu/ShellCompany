// SPDX-License-Identifier: MIT
package shellco;

import ceramic.Utils;

final class MathTools {

    public static function moveTowards(from: Float, to: Float, maxDelta: Float): Float {
        final delta = to - from;
        return if (Math.abs(delta) <= maxDelta) {
            to;
        } else {
            from + (maxDelta * Utils.sign(delta));
        };
    }
    
    public static function clamp(value: Float, min: Float, max: Float): Float {
        return Math.max(min, Math.min(value, max));
    }
}
