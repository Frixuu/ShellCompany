// SPDX-License-Identifier: MIT
package shellco.player;

import ceramic.InputMap;
import ceramic.Logger;
import ceramic.System;

/**
    This system controls the player character.
**/
final class PlayerControllerSystem extends System {

    /**
        Singleton instance of this system.
    **/
    @lazy public static var instance: PlayerControllerSystem = new PlayerControllerSystem();
    
    /**
        The singular player instance to control.
    **/
    public var activePlayer: Null<Player> = null;
    
    private final logger: Logger = new Logger();
    private final inputMap: InputMap<PlayerAction> = {
        final map = new InputMap<PlayerAction>();
        map.bindScanCode(Jump, SPACE);
        map.bindScanCode(MoveLeft, LEFT);
        map.bindScanCode(MoveLeft, KEY_A);
        map.bindScanCode(MoveRight, RIGHT);
        map.bindScanCode(MoveRight, KEY_D);
        map.bindConvertedToAxis(MoveLeft, MoveHorizontal, -1.0);
        map.bindConvertedToAxis(MoveRight, MoveHorizontal, 1.0);
        map;
    };
    
    public override function earlyUpdate(delta: Float) {
    
        final player = this.activePlayer ?? return;
        final inputMap = this.inputMap;
        
        if (inputMap.justPressed(Jump) && player.body.isOnFloor()) {
            player.velocityY = -180;
        }
        
        var x: Float = 0.0;
        if (inputMap.pressed(MoveRight)) {
            x += 1.0;
        }
        if (inputMap.pressed(MoveLeft)) {
            x -= 1.0;
        }
        
        player.velocityX = x * 120;
        if (x > 0) {
            player.scaleX = 1;
        } else if (x < 0) {
            player.scaleX = -1;
        }
    }
}
