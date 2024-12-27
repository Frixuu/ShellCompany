// SPDX-License-Identifier: MIT
package shellco.player;

import ceramic.InputMap;
import ceramic.Logger;
import ceramic.System;
import shellco.MathTools.moveTowards;

/**
    This system controls the player character.
**/
final class PlayerControllerSystem extends System {

    private static inline final PLAYER_SPEED: Float = 95.0;
    private static inline final ACCELERATION: Float = 1600.0;
    private static inline final DECELERATION: Float = 600.0;
    
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
        map.bindScanCode(MoveLeft, LEFT);
        map.bindScanCode(MoveLeft, KEY_A);
        map.bindScanCode(MoveRight, RIGHT);
        map.bindScanCode(MoveRight, KEY_D);
        map.bindScanCode(MoveUp, UP);
        map.bindScanCode(MoveUp, KEY_W);
        map.bindScanCode(MoveDown, DOWN);
        map.bindScanCode(MoveDown, KEY_S);
        map;
    };
    
    public override function earlyUpdate(delta: Float) {
    
        final player = this.activePlayer ?? return;
        player.gravityY = 0.0;
        
        final inputMap = this.inputMap;
        
        var x: Float = 0.0;
        if (inputMap.pressed(MoveRight)) {
            x += 1.0;
        }
        if (inputMap.pressed(MoveLeft)) {
            x -= 1.0;
        }
        
        var y: Float = 0.0;
        if (inputMap.pressed(MoveDown)) {
            y += 1.0;
        }
        if (inputMap.pressed(MoveUp)) {
            y -= 1.0;
        }
        
        final current = player.velocityX;
        if (Math.abs(x) < 0.01) {
            player.velocityX = moveTowards(current, 0.0, DECELERATION * delta);
        } else {
            player.velocityX = moveTowards(current, x * PLAYER_SPEED, ACCELERATION * delta);
        }
        
        final current = player.velocityY;
        if (Math.abs(y) < 0.01) {
            player.velocityY = moveTowards(current, 4.0, DECELERATION * delta);
        } else {
            player.velocityY = moveTowards(current, y * PLAYER_SPEED, ACCELERATION * delta);
        }
        
        if (x > 0) {
            player.scaleX = 1;
        } else if (x < 0) {
            player.scaleX = -1;
        }
    }
}
