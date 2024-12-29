// SPDX-License-Identifier: MIT
package shellco;

import ceramic.App;
import ceramic.Assets;
import ceramic.Color;
import ceramic.Quad;
import shellco.inventory.Item;
import shellco.player.PlayerControllerSystem;

class InteractableVisual extends Quad {

    public var enabled(default, null): Bool = true;
    
    public function new(assets: Assets) {
        super();
        
        this.anchor(0, 0);
        this.depth = 10;
        App.app.group("droppable_on").add(this);
        this.initArcadePhysics();
        
        this.onPointerDown(this, _ -> {
            final player = PlayerControllerSystem.instance.activePlayer ?? return;
            final dx = Math.abs(this.body.centerX - player.body.centerX);
            final dy = Math.abs(this.body.centerY - player.body.centerY);
            if (Math.sqrt(dx * dx + dy * dy) <= 43.0) {
                this.tryInteractDirectly();
            }
        });
    }
    
    public function tryInteractDirectly() {}
    
    public function tryUseItem(item: Item): Bool {
        return false;
    }
}
