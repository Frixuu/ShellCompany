// SPDX-License-Identifier: MIT
package shellco;

import ceramic.AlphaColor;
import ceramic.App;
import ceramic.Assets;
import ceramic.Color;
import ceramic.Sprite;

using ceramic.SpritePlugin;

class EndLevel extends InteractableVisual {

    public var sprite: Sprite;
    public var entryEnabled: Bool = false;
    
    public static var instance: EndLevel;
    
    public function new(assets: Assets) {
        super(assets);
        EndLevel.instance = this;
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
            sprite.animation = "door_empty";
            sprite;
        });
    }
    
    public dynamic function onGo() {}
    
    public override function tryInteractDirectly() {
        if (this.entryEnabled) {
            this.onGo();
        }
    }
    
    public override function destroy() {
        super.destroy();
        this.sprite.destroy();
    }
}
