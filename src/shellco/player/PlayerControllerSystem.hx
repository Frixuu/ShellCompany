// SPDX-License-Identifier: MIT
package shellco.player;

import ceramic.App;
import ceramic.InputMap;
import ceramic.Logger;
import ceramic.SoundAsset;
import ceramic.System;
import ceramic.Timer;
import shellco.MathTools.moveTowards;
import shellco.narrative.NarrativeSystem;

/**
    This system controls the player character.
**/
final class PlayerControllerSystem extends System {

    private static inline final PLAYER_SPEED: Float = 95.0;
    private static inline final ACCELERATION: Float = 1600.0;
    private static inline final DECELERATION: Float = 600.0;
    
    private var enabled: Bool = true;
    
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
    
    public function new() {
        super();
        final narrative = NarrativeSystem.instance;
        narrative.onConvoAdvanced(this, line -> {
            this.enabled = line == null;
        });
        
        final assets = App.app.assets;
        assets.ensure("sound:audio/sfx/swim_1", null, null, a -> {
            assets.ensure("sound:audio/sfx/swim_2", null, null, b -> {
                Timer.interval(this, 1.0, () -> {
                    final player = this.activePlayer ?? return;
                    if (player.sprite.animation == "swim") {
                        final sound = (cast((Math.random() > 0.5) ? a : b): SoundAsset).sound;
                        final soundPlayer = sound.play(0.0, false, 0.1, 0.0,
                            (1.0 + (Math.random() * 0.25 - 0.125)));
                    }
                });
            });
        });
    }
    
    public override function earlyUpdate(delta: Float) {
    
        final player = this.activePlayer ?? return;
        player.gravityY = 0.0;
        
        final inputMap = this.inputMap;
        
        var x: Float = 0.0;
        if (this.enabled) {
            if (inputMap.pressed(MoveRight)) {
                x += 1.0;
            }
            if (inputMap.pressed(MoveLeft)) {
                x -= 1.0;
            }
        }
        
        var y: Float = 0.0;
        if (this.enabled) {
            if (inputMap.pressed(MoveDown)) {
                y += 1.0;
            }
            if (inputMap.pressed(MoveUp)) {
                y -= 1.0;
            }
        }
        
        final current = player.velocityX;
        if (Math.abs(x) < 0.01) {
            player.velocityX = moveTowards(current, 0.0, DECELERATION * delta);
        } else {
            player.velocityX = moveTowards(current, x * PLAYER_SPEED, ACCELERATION * delta);
        }
        
        final current = player.velocityY;
        if (Math.abs(y) < 0.01) {
            player.velocityY = moveTowards(current, this.enabled ? 4.0 : 0.0, DECELERATION * delta);
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
