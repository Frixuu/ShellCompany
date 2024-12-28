// SPDX-License-Identifier: MIT
package shellco;

import ceramic.App;
import ceramic.Assets;
import ceramic.Color;
import ceramic.Quad;
import shellco.inventory.Item;

class InteractableVisual extends Quad {

    public var enabled(default, null): Bool = true;
    
    public function new(assets: Assets) {
        super();
        
        this.anchor(0, 0);
        this.size(1, 1);
        this.pos(0, 0);
        this.depth = 10;
        App.app.group("droppable_on").add(this);
        this.initArcadePhysics();
        
        this.shader = {
            final shader = assets.shader("outline").clone();
            shader.setFloat("outlineThickness", 0.0);
            shader.setFloat("outlineThreshold", 0.5);
            shader.setColor("outlineColor", Color.YELLOW);
            shader.setVec2("resolution", Project.TARGET_WIDTH, Project.TARGET_HEIGHT);
            shader;
        };
        this.onPointerOver(this, _ -> {
            App.app.logger.info("OVER ME YOO");
            this.shader.setFloat("outlineThickness", 2.0);
        });
        this.onPointerOut(this, _ -> this.shader.setFloat("outlineThickness", 0.0));
    }
    
    public function tryInteractDirectly() {}
    
    public function tryUseItem(item: Item): Bool {
        App.app.logger.info("yummy");
        return true;
    }
}
