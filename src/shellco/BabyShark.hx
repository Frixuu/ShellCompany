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
import shellco.inventory.Key;
import shellco.narrative.NarrativeSystem;

using ceramic.SpritePlugin;

class BabyShark extends InteractableVisual {

    private var interacted: Bool = false;
    
    public function new(assets: Assets) {
        super(assets);
        
        this.size(48, 24);
        this.texture = assets.texture("shark");
        this.texture.filter = LINEAR;
    }
    
    public override function tryInteractDirectly() {
        App.app.logger.info("int!");
    }
    
    public override function tryUseItem(item: Item): Bool {
        App.app.logger.info("use!");
        return false;
    }
}
