// SPDX-License-Identifier: MIT
package shellco;

import ceramic.App;
import ceramic.Logger;
import ceramic.Scene;
import shellco.LoadingOverlayScene;

/**
    Scene used in the project.
**/
abstract class SceneBase extends Scene {

    /**
        A Logger instance.
    **/
    private final log: Logger = new Logger();
    
    public override function fadeIn(done: () -> Void) {
    
        final app = App.app;
        final loadingScene: LoadingOverlayScene = cast app.scenes.get("loading");
        
        if (loadingScene != null) {
            this.visible = false;
            this.autoUpdate = false;
            loadingScene.onceOkToTransition(this, () -> {
                this.visible = true;
                this.autoUpdate = true;
                done();
            });
        } else {
            done();
        }
    }
}
