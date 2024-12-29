// SPDX-License-Identifier: MIT
package shellco.ui;

import ceramic.AlphaColor;
import ceramic.App;
import ceramic.Assert;
import ceramic.Color;
import ceramic.Quad;
import ceramic.Timer;
import shellco.inventory.InventorySystem;
import shellco.inventory.Item;
import shellco.inventory.ItemVisual;

using Lambda;
using ceramic.SpritePlugin;

/**
    This scene displays items currently held in the inventory.
**/
final class InventoryScene extends SceneBase {

    private var panel: Quad;
    private var panelShown: Bool = false;
    private var itemVisuals: Array<ItemVisual> = [];
    private var timeSinceLastItemAdded: Float = 999.9;
    
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
        
        final inventory = InventorySystem.instance;
        inventory.onItemAdded(this, (item, n) -> {
            this.itemVisuals.push(new ItemVisual(item));
            Assert.assert(this.itemVisuals.length == n);
            this.recalculateItemVisuals();
            this.timeSinceLastItemAdded = 0.0;
        });
        inventory.onItemRemoved(this, (item, n) -> {
            final newVisuals = [];
            for (v in this.itemVisuals) {
                if (v.item == item) {
                    v.destroy();
                } else {
                    newVisuals.push(v);
                }
            }
            this.itemVisuals = newVisuals;
            Assert.assert(this.itemVisuals.length == n);
            this.recalculateItemVisuals();
        });
        
        Timer.delay(this, 5.3, () -> inventory.addItem(new Item()));
        Timer.delay(this, 5.4, () -> inventory.addItem(new Item()));
    }
    
    public override function update(delta: Float) {
        super.update(delta);
        this.timeSinceLastItemAdded += delta;
        
        final show = (this.panelShown && this.itemVisuals.length > 0)
            || (this.timeSinceLastItemAdded < 2.0);
        this.panel.y = MathTools.moveTowards(this.panel.y, (show ? 0.0 : -36.0), 200.0 * delta);
    }
    
    private function recalculateItemVisuals() {
        for (i in 0...this.itemVisuals.length) {
            final visual = this.itemVisuals[i];
            panel.add(visual);
            visual.anchor(0.0, 0.0);
            visual.depth = 1;
            visual.pos((32 * i) + 8, 8);
        }
    }
}
