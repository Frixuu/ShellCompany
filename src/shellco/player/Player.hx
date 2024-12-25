// SPDX-License-Identifier: MIT
package shellco.player;

import assets.Images;
import ceramic.App;
import ceramic.Assets;
import ceramic.Sprite;
import ceramic.SpriteSheet;

/**
    The player character.
**/
final class Player extends Sprite {

    public function new(assets: Assets) {
        super();
        
        PlayerControllerSystem.instance.activePlayer = this;
        
        this.visible = true;
        this.quad.roundTranslation = 1;
        this.autoComputeSize = false;
        this.anchorKeepPosition(0.5, 1.0);
        
        this.initArcadePhysics();
        this.body.collideWorldBounds = true;
        this.gravityY = 400;
        
        final sheet = this.sheet = new SpriteSheet();
        sheet.texture = assets.texture(Images.DANCING_GIRL_SNAP);
        sheet.texture.filter = NEAREST;
        sheet.grid(39, 53);
        sheet.addGridAnimation("dance", [0, 1, 2, 3, 4, 5, 6, 7], 0.12);
        this.animation = "dance";
        this.frameOffsetY = 2;
        
        this.size(39, 53);
        this.anchorKeepPosition(0.5, 1.0);
        
        final app = App.app;
        final persistentScene: PersistentScene = cast app.scenes.get("persistent");
        final camera = persistentScene.mainCamera;
        app.onPostUpdate(this, _ -> {
            camera.followTarget = true;
            camera.target(this.x, this.y);
        });
    }
}
