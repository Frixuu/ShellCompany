// SPDX-License-Identifier: MIT
package shellco.player;

import ceramic.App;
import ceramic.Assets;
import ceramic.Quad;
import ceramic.Sprite;
import shellco.visual.BounceComponent;

using ceramic.SpritePlugin;

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
        
        this.transparent = true;
        this.size(45, 15);
        this.anchorKeepPosition(0.5, 1.0);
        this.initArcadePhysics();
        this.body.collideWorldBounds = true;
        PlayerControllerSystem.instance.activePlayer = this;
        
        final app = App.app;
        this.add({
            final sprite = this.sprite = new Sprite();
            sprite.autoComputeSize = true;
            sprite.sheet = assets.sheet("player");
            sprite.frameOffset(1, 8);
            sprite.anchor(0.5, 1.0);
            sprite.pos(this.width / 2.0, this.height);
            sprite.quad.roundTranslation = 1;
            sprite.animation = "idle";
            
            final bounce = new BounceComponent(0.0, 0.1);
            sprite.component("bounce", bounce);
            app.onPreUpdate(sprite, _ -> {
                if (Math.abs(this.velocityX) + Math.abs(this.velocityY) > 20.0) {
                    sprite.animation = "swim";
                    bounce.amplitude = 1;
                    bounce.timeScale = 0.7;
                } else {
                    sprite.animation = "idle";
                    bounce.amplitude = 0.0;
                    bounce.timeScale = 0.1;
                }
            });
            
            sprite;
        });
        
        final persistentScene: PersistentScene = cast app.scenes.get("persistent");
        final camera = persistentScene.mainCamera;
        app.onPostUpdate(this, delta -> {
            camera.followTarget = true;
            camera.target(this.x, this.y - 30.0);
            camera.update(delta);
        });
    }
}
