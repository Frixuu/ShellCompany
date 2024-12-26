// SPDX-License-Identifier: MIT
package shellco.player;

import assets.Images;
import ceramic.App;
import ceramic.Assets;
import ceramic.Color;
import ceramic.Quad;
import ceramic.Sprite;
import ceramic.SpriteSheet;

/**
    The player character.
**/
final class Player extends Quad {

    /**
        The sprite visual representing this player character.
    **/
    public final sprite: Sprite;
    
    public function new(assets: Assets) {
        super();
        
        this.color = Color.YELLOW;
        
        this.size(15, 45);
        this.anchorKeepPosition(0.5, 1.0);
        this.initArcadePhysics();
        this.body.collideWorldBounds = true;
        this.gravityY = 400;
        PlayerControllerSystem.instance.activePlayer = this;
        
        this.add({
            final sprite = this.sprite = new Sprite();
            sprite.autoComputeSize = true;
            
            final sheet = sprite.sheet = new SpriteSheet();
            final atlas = assets.texture(Images.DANCING_GIRL_SNAP);
            atlas.filter = NEAREST;
            sheet.texture = atlas;
            sheet.grid(39, 53);
            sheet.addGridAnimation("dance", [0, 1, 2, 3, 4, 5, 6, 7], 0.12);
            
            sprite.frameOffset(-1, 0);
            sprite.anchor(0.5, 1.0);
            sprite.pos(this.width / 2.0, this.height);
            sprite.quad.roundTranslation = 1;
            sprite.animation = "dance";
            
            sprite;
        });
        
        final app = App.app;
        final persistentScene: PersistentScene = cast app.scenes.get("persistent");
        final camera = persistentScene.mainCamera;
        app.onPostUpdate(this, _ -> {
            camera.followTarget = true;
            camera.target(this.x, this.y);
        });
    }
}
