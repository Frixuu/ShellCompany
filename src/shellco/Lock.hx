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
import shellco.player.PlayerControllerSystem;

using ceramic.SpritePlugin;

class Lock extends InteractableVisual {

    public var sprite: Sprite;
    
    private var interacted: Bool = false;
    private var timesClickedWithKey: Int = 0;
    
    public function new(assets: Assets) {
        super(assets);
        
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
            sprite.animation = "lock";
            sprite;
        });
    }
    
    public override function tryInteractDirectly() {
        final inventory = InventorySystem.instance;
        if (Lambda.exists(inventory.items, i -> i is Key)) {
            this.timesClickedWithKey += 1;
            if (this.timesClickedWithKey < 4) {
                Timer.delay(this, 0.0001, () -> {
                    final narrative = NarrativeSystem.instance;
                    narrative.say("Ghost", "Wonder if the key I found will work?", true);
                });
            } else if (this.timesClickedWithKey == 4) {
                Timer.delay(this, 0.0001, () -> {
                    final narrative = NarrativeSystem.instance;
                    narrative.say("E.", "OKAY.", true);
                    narrative.say("E.", "STOP.");
                    narrative.say("E.", "I SEE HOW IT GOES.");
                    narrative.say("E.", "YOU WANT TO PURPOSEFULLY MAKE ME MAD.");
                    narrative.say("E.", "THE KEY IS THERE. ON THE TOP OF THE SCREEN.", () -> {
                        final key = Lambda.find(inventory.items, i -> i is Key);
                        inventory.removeItem(key);
                        inventory.addItem(key);
                    });
                    narrative.say("E.", "JUST GRAB IT AND DROP IT ON THE LOCK.");
                    narrative.say("E.", "I SWEAR TO NEPTUNE YOU'RE GETTING FIRED AFTER THIS.");
                });
            }
        } else if (!this.interacted) {
            this.interacted = true;
            Timer.delay(this, 0.0001, () -> {
                final narrative = NarrativeSystem.instance;
                narrative.say("Ghost", "Great. It's locked. Why have you sent me this way again?",
                    true);
                narrative.say("E.", "Focus. There must be a way out.");
            });
        }
    }
    
    public dynamic function afterUse() {}
    
    public override function tryUseItem(item: Item): Bool {
    
        final player = PlayerControllerSystem.instance.activePlayer ?? return false;
        final dx = Math.abs(this.body.centerX - player.body.centerX);
        final dy = Math.abs(this.body.centerY - player.body.centerY);
        if (Math.sqrt(dx * dx + dy * dy) > this.interactionRange) {
            return false;
        }
        
        if (item is Key) {
            Timer.delay(this, 0.0001, () -> {
                this.afterUse();
                this.destroy();
            });
            return true;
        }
        return false;
    }
    
    public override function destroy() {
        super.destroy();
        this.sprite.destroy();
    }
}
