// SPDX-License-Identifier: MIT
package shellco;

import ceramic.AlphaColor;
import ceramic.App;
import ceramic.Assets;
import ceramic.Color;
import ceramic.Sprite;
import ceramic.Timer;
import ceramic.Tween;
import shellco.inventory.Cocktail;
import shellco.inventory.InventorySystem;
import shellco.inventory.Item;
import shellco.inventory.Laxatives;
import shellco.inventory.SpikedCocktail;
import shellco.narrative.NarrativeSystem;

using ceramic.SpritePlugin;

class BabyShark extends InteractableVisual {

    private var interacted: Bool = false;
    
    public function new(assets: Assets) {
        super(assets);
        
        this.size(48, 24);
        this.texture = assets.texture("shark");
        this.texture.filter = LINEAR;
        this.roundTranslation = 1;
    }
    
    public override function tryInteractDirectly() {
    
        Timer.delay(this, 0.0001, () -> {
            final narrative = NarrativeSystem.instance;
            narrative.say("Baby Shark", "Get lost.", true);
        });
    }
    
    public override function tryUseItem(item: Item): Bool {
    
        if (item is Cocktail) {
            Timer.delay(this, 0.0001, () -> {
                final narrative = NarrativeSystem.instance;
                narrative.say("Ghost", "I don't think he deserves it.", true);
            });
            return false;
        } else if (item is Laxatives) {
            Timer.delay(this, 0.0001, () -> {
                final narrative = NarrativeSystem.instance;
                narrative.say("Ghost", "I need to hide it in something first.", true);
            });
            return false;
        } else if (item is SpikedCocktail) {
            Timer.delay(this, 0.0001, () -> {
                final narrative = NarrativeSystem.instance;
                narrative.say("Baby Shark", "This for me?", true);
                narrative.say("Baby Shark", "Ha. Thanks, but you're not coming in anyw-");
                narrative.say("Baby Shark", "....", () -> {
                    this.scaleX = -1.0;
                    Tween.start(this, QUAD_EASE_IN, 3.0, this.x, (this.x + 1300), (v, t) -> {
                        this.x = v;
                    }).onceComplete(this, () -> {
                        this.destroy();
                        narrative.say("Ghost", "All clear.", true);
                        narrative.say("E.", "Go on then.", () -> {
                            EndLevel.instance.entryEnabled = true;
                        });
                    });
                });
            });
            return true;
        } else {
            return false;
        }
    }
}
