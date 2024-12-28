// SPDX-License-Identifier: MIT
package shellco;

import ceramic.App;
import ceramic.Camera;
import ceramic.Scene;
import shellco.ui.DialogueScene;
import shellco.ui.InventoryScene;
import shellco.ui.SoftwareCursor;

using ceramic.SpritePlugin;

/**
    Scene that is assumed to live for the entirety of the game.
**/
final class PersistentScene extends Scene {

    /**
        The main camera.
    **/
    public var mainCamera(default, null): Null<Camera> = null;
    
    public override function preload() {
        this.assets.addImage("fonts/minogram");
        this.assets.addSprite("ui/cursor");
    }
    
    public override function create() {
    
        final fontImageAsset = this.assets.imageAsset("fonts/minogram");
        fontImageAsset.texture.filter = NEAREST;
        
        final app = App.app;
        app.scenes.set("main", {
            final scene = new MainScene();
            scene.assets.parent = this.assets;
            scene;
        });
        
        app.scenes.set("ui: dialogue", {
            final scene = new DialogueScene();
            scene.assets.parent = this.assets;
            scene;
        });
        
        app.scenes.set("ui: inventory", {
            final scene = new InventoryScene();
            scene.assets.parent = this.assets;
            scene;
        });
        
        final interactiveGroup = app.group("droppable_on");
        interactiveGroup.sortDirection = NONE;
    }
    
    public override function ready() {
        final app = App.app;
        this.depth = 100;
        this.add({
        
            final cursor = new SoftwareCursor(this.assets);
            final screen = app.screen;
            app.onPreUpdate(cursor, _ -> {
                cursor.x = screen.pointerX;
                cursor.y = screen.pointerY;
            });
            
            #if clay_web
            clay.Clay.app.runtime.window.style.cursor = "none";
            #elseif clay_sdl
            sdl.SDL.showCursor(0);
            #end
            
            cursor;
        });
        
        this.mainCamera = {
            final camera = new Camera();
            camera.viewportWidth = Project.TARGET_WIDTH;
            camera.viewportHeight = Project.TARGET_HEIGHT;
            camera.trackSpeedX = 30.0;
            camera.trackSpeedY = 30.0;
            camera.trackCurve = 0.3;
            camera;
        };
    }
}
