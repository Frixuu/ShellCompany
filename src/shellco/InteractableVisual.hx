// SPDX-License-Identifier: MIT
package shellco;

import ceramic.App;
import ceramic.Assets;
import ceramic.Color;
import ceramic.Quad;
import shellco.inventory.Item;
import shellco.player.PlayerControllerSystem;
import shellco.ui.SoftwareCursor;

class InteractableVisual extends Quad {

    public var interactionRange: Float = 48.0;
    public var enabled(default, null): Bool = true;
    
    public function new(assets: Assets) {
        super();
        
        this.anchor(0, 0);
        this.depth = 10;
        App.app.group("droppable_on").add(this);
        this.initArcadePhysics();
        
        this.onPointerOver(this, _ -> SoftwareCursor.instance.animation = "crosshair (dynamic)");
        this.onPointerOut(this, _ -> SoftwareCursor.instance.animation = "crosshair (static)");
        this.onPointerDown(this, _ -> {
            final player = PlayerControllerSystem.instance.activePlayer ?? return;
            final dx = Math.abs(this.body.centerX - player.body.centerX);
            final dy = Math.abs(this.body.centerY - player.body.centerY);
            if (Math.sqrt(dx * dx + dy * dy) <= this.interactionRange) {
                this.tryInteractDirectly();
            }
        });
    }
    
    public function tryInteractDirectly() {}
    
    public function tryUseItem(item: Item): Bool {
        return false;
    }
}
