// SPDX-License-Identifier: MIT
package shellco.ui;

import ceramic.Assets;
import ceramic.Sprite;
import ceramic.Visual;

using ceramic.SpritePlugin;

/**
    A sprite that follows your mouse cursor.
**/
final class SoftwareCursor extends Sprite {

    /**
        A singleton instance.
    **/
    public static var instance: Null<SoftwareCursor> = null;
    
    public function new(assets: Assets) {
        super();
        if (SoftwareCursor.instance == null) {
            SoftwareCursor.instance = this;
        } else {
            throw "There is a cursor already";
        }
        
        this.sheet = assets.sheet("ui/cursor");
        this.animation = "crosshair (static)";
        this.anchorKeepPosition(0.5, 0.5);
        this.size(17, 17);
        this.depth = 200;
        this.quad.roundTranslation = 1;
    }
    
    private override function interceptPointerOver(
        hittingVisual: Visual,
        x: Float,
        y: Float
    ): Bool {
        return true;
    }
    
    private override function interceptPointerDown(
        hittingVisual: Visual,
        x: Float,
        y: Float,
        touchIndex: Int,
        buttonId: Int
    ): Bool {
        return true;
    }
    
    public override function destroy() {
        super.destroy();
        if (SoftwareCursor.instance == this) {
            SoftwareCursor.instance = null;
        }
    }
}
