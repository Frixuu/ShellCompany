// SPDX-License-Identifier: MIT
package shellco;

import assets.Fonts;
import assets.Images;
import ceramic.App;
import ceramic.Quad;
import ceramic.Scene;
import ceramic.Visual;
import shellco.visual.BounceComponent;
import shellco.visual.SnapTransformComponent;

/**
    Scene that is assumed to live for the entirety of the game.
**/
final class PersistentScene extends Scene {

    public override function preload() {
        this.assets.add(Images.MINOGRAM);
        this.assets.add(Fonts.MINOGRAM);
        this.assets.add(Images.BUBBLE_16PX);
    }
    
    public override function create() {
    
        final fontImageAsset = this.assets.imageAsset(Images.MINOGRAM);
        fontImageAsset.texture.filter = NEAREST;
        
        final app = App.app;
        app.scenes.set("main", new MainScene());
        
        this.add({
            final parent = new Visual();
            parent.pos(Project.TARGET_WIDTH - 20, Project.TARGET_HEIGHT - 20);
            parent.anchor(1.0, 1.0);
            parent.add({
                final bubble = new Quad();
                bubble.anchor(1.0, 1.0);
                bubble.texture = {
                    final texture = this.assets.texture(Images.BUBBLE_16PX);
                    texture.filter = NEAREST;
                    texture;
                };
                bubble.component("bounce", new BounceComponent(4.0, 2.5));
                bubble.component("snap", new SnapTransformComponent());
                bubble;
            });
            parent;
        });
        final bubble = new Quad();
    }
}
