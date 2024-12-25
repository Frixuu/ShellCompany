// SPDX-License-Identifier: MIT
package shellco.ui;

import assets.Sprites;
import ceramic.Assets;
import ceramic.Sprite;

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
        
        this.sheet = assets.sheet(Sprites.UI__CURSOR);
        this.animation = "crosshair (static)";
        this.anchorKeepPosition(0.5, 0.5);
        this.size(17, 17);
        this.depth = 200;
        this.quad.roundTranslation = 1;
    }
    
    public override function destroy() {
        super.destroy();
        if (SoftwareCursor.instance == this) {
            SoftwareCursor.instance = null;
        }
    }
}
