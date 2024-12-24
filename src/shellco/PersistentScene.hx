// SPDX-License-Identifier: MIT
package shellco;

import ceramic.App;
import ceramic.Camera;
import ceramic.Scene;

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
    }
    
    public override function create() {
        final fontImageAsset = this.assets.imageAsset("fonts/minogram");
        fontImageAsset.texture.filter = NEAREST;
        App.app.scenes.set("main", new MainScene());
    }
    
    public override function ready() {
        final app = App.app;
        this.mainCamera = {
            final camera = new Camera();
            camera.viewportWidth = Project.TARGET_WIDTH;
            camera.viewportHeight = Project.TARGET_HEIGHT;
            camera.trackSpeedX = 80;
            camera.trackCurve = 0.3;
            camera.followTarget = true;
            camera.update(9999.9);
            app.onPostUpdate(camera, camera.update);
            camera;
        };
    }
}
