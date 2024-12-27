// SPDX-License-Identifier: MIT
package shellco.ui;

import ceramic.AlphaColor;
import ceramic.App;
import ceramic.Color;
import ceramic.Quad;

using ceramic.SpritePlugin;

/**
    This scene displays items currently held in the inventory.
**/
final class InventoryScene extends SceneBase {

    public override function preload() {
        super.preload();
        this.assets.addShader("shaders/single_color");
        this.assets.addImage("ui/long_hamburger");
    }
    
    public override function create() {
        super.create();
        this.screenSpace = true;
        this.depth = 50;
    }
    
    public override function ready() {
        final app = App.app;
        this.add({
            final panel = new Quad();
            panel.shader = {
                final asset = this.assets.shader("shaders/single_color");
                final shader = asset.clone();
                shader.setAlphaColor("color", new AlphaColor(Color.BLACK, 90));
                shader;
            };
            panel.blending = ALPHA;
            panel.anchor(0.0, 0.0);
            panel.pos(0.0, 0.0);
            panel.size(Project.TARGET_WIDTH, 36);
            panel.translateY = -36.0;
            app.onUpdate(panel, delta -> {
                var targetY = -36.0;
                if (app.screen.pointerY < 40.0) {
                    targetY = 0.0;
                }
                panel.translateY = MathTools.moveTowards(panel.translateY, targetY, 200.0 * delta);
            });
            panel;
        });
    }
}
