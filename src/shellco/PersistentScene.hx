// SPDX-License-Identifier: MIT
package shellco;

import ceramic.App;
import ceramic.Scene;

/**
    Scene that is assumed to live for the entirety of the game.
**/
final class PersistentScene extends Scene {

    public override function preload() {
        this.assets.addImage("fonts/minogram");
    }
    
    public override function create() {
    
        final fontImageAsset = this.assets.imageAsset("fonts/minogram");
        fontImageAsset.texture.filter = NEAREST;
        
        final app = App.app;
        app.scenes.set("main", new MainScene());
    }
}
