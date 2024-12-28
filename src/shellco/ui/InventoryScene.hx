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

    private var panel: Quad;
    private var panelShown: Bool = false;
    
    public override function preload() {
        this.assets.addShader("shaders/single_color");
    }
    
    public override function create() {
        super.create();
        this.screenSpace = true;
        this.depth = 50;
    }
    
    public override function ready() {
        final app = App.app;
        this.add({
            final panel = this.panel = new Quad();
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
            panel.onPointerOver(this, _ -> {
                this.panelShown = true;
            });
            panel.onPointerOut(this, _ -> {
                this.panelShown = false;
            });
            panel;
        });
        this.add({
            final trigger = new Quad();
            trigger.anchor(0.0, 0.0);
            trigger.pos(0.0, 0.0);
            trigger.size(Project.TARGET_WIDTH, 36);
            trigger.depth = 10;
            trigger.transparent = true;
            trigger.onPointerOver(this, _ -> {
                this.panelShown = true;
            });
            trigger.onPointerOut(this, _ -> {
                this.panelShown = false;
            });
            trigger;
        });
    }
    
    public override function update(delta: Float) {
        super.update(delta);
        this.panel.translateY = MathTools.moveTowards(this.panel.translateY,
            (this.panelShown ? 0.0 : -36.0), 200.0 * delta);
    }
}
