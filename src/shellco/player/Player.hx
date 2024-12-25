// SPDX-License-Identifier: MIT
package shellco.player;

import assets.Images;
import ceramic.App;
import ceramic.Assets;
import ceramic.InputMap;
import ceramic.ScanCode;
import ceramic.Sprite;
import ceramic.SpriteSheet;

enum abstract PlayerInput(Int) {
    public var MoveRight;
    public var MoveLeft;
    public var Jump;
}

/**
    The player character.
**/
final class Player extends Sprite {

    private final inputMap: InputMap<PlayerInput> = new InputMap();
    
    public function new(assets: Assets) {
        super();
        
        this.visible = true;
        this.quad.roundTranslation = 1;
        
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
        this.size(24, 36);
        this.anchor(0.5, 1.0);
        
        final app = App.app;
        final persistentScene: PersistentScene = cast app.scenes.get("persistent");
        final camera = persistentScene.mainCamera;
        app.onPostUpdate(this, _ -> {
            camera.followTarget = true;
            camera.target(this.x, this.y);
        });
        
        this.inputMap.bindScanCode(MoveLeft, ScanCode.LEFT);
        this.inputMap.bindScanCode(MoveLeft, ScanCode.KEY_A);
        this.inputMap.bindScanCode(MoveRight, ScanCode.RIGHT);
        this.inputMap.bindScanCode(MoveRight, ScanCode.KEY_D);
        this.inputMap.bindScanCode(Jump, ScanCode.SPACE);
    }
    
    public override function update(delta: Float) {
        super.update(delta);
        
        if (this.inputMap.justPressed(Jump) && this.body.isOnFloor()) {
            this.velocityY = -180;
        }
        
        if (this.inputMap.pressed(MoveRight)) {
            this.velocityX = 120;
            this.scaleX = 1;
        } else if (this.inputMap.pressed(MoveLeft)) {
            this.velocityX = -120;
            this.scaleX = -1;
        } else {
            this.velocityX = 0;
        }
    }
}
