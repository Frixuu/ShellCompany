// SPDX-License-Identifier: MIT
package shellco;

import ceramic.AlphaColor;
import ceramic.App;
import ceramic.Assets;
import ceramic.Color;
import ceramic.Sprite;
import ceramic.Timer;
import shellco.inventory.InventorySystem;
import shellco.inventory.Item;

using ceramic.SpritePlugin;

class DroppedItem extends InteractableVisual {

    public var sprite: Sprite;
    public final item: Item;
    
    public function new(assets: Assets, item: Item) {
        super(assets);
        
        this.item = item;
        this.size(24, 24);
        
        this.shader = {
            final asset = assets.shader("shaders/single_color");
            final shader = asset.clone();
            shader.setAlphaColor("color", AlphaColor.TRANSPARENT);
            shader;
        };
        
        this.add({
            final sprite = this.sprite = new Sprite();
            sprite.autoComputeSize = true;
            sprite.sheet = assets.sheet("item");
            sprite.anchor(0.0, 0.0);
            sprite.pos(0.0, 0.0);
            sprite.quad.roundTranslation = 1;
            sprite.animation = item.spriteName();
            sprite;
        });
        
        this.sprite.shader = {
            final shader = assets.shader("outline").clone();
            shader.setFloat("outlineThickness", 1.5);
            shader.setFloat("outlineThreshold", 0.5); // Alpha value to be considered
            shader.setColor("outlineColor", Color.BLACK);
            shader.setVec2("resolution", 24, 24);
            shader;
        };
        
        this.onPointerOver(this, _ -> {
            App.app.logger.info("MOUSE OVER DROPPED ITEM " + this.item.spriteName());
            this.sprite.shader.setFloat("outlineThickness", 1.5);
        });
        
        this.onPointerOut(this, _ -> {
            App.app.logger.info("MOUSE NO LONGER OVER DROPPED ITEM " + this.item.spriteName());
            this.sprite.shader.setFloat("outlineThickness", 0.0);
        });
    }
    
    public dynamic function afterPickup() {}
    
    public override function tryInteractDirectly() {
        Timer.delay(this, 0.0001, () -> {
            this.afterPickup();
            this.destroy();
        });
        InventorySystem.instance.addItem(this.item);
        this.visible = false;
    }
    
    public override function destroy() {
        super.destroy();
        this.sprite.destroy();
    }
}
