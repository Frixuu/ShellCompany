// SPDX-License-Identifier: MIT
package shellco;

import assets.Fonts;
import assets.Images;
import ceramic.App;
import ceramic.Scene;

/**
    Scene that is assumed to live for the entirety of the game.
**/
final class PersistentScene extends Scene {

    public override function preload() {
        this.assets.add(Images.MINOGRAM);
        this.assets.add(Fonts.MINOGRAM);
    }
    
    public override function create() {
    
        final fontImageAsset = this.assets.imageAsset(Images.MINOGRAM);
        fontImageAsset.texture.filter = NEAREST;
        
        final app = App.app;
        app.scenes.set("main", new MainScene());
    }
}
