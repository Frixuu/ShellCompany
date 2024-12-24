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
    
    /**
        If false, this scene will get translated according to the main game camera.
        This mode is used for levels.

        If true, this scene will not get translated.
        This mode is used for UI.
    **/
    private var screenSpace: Bool = true;
    
    public override function ready() {
        App.app.onPostUpdate(this, _ -> {
            final persistentScene: PersistentScene = cast App.app.scenes.get("persistent");
            final camera = persistentScene?.mainCamera ?? return;
            if (!this.screenSpace) {
                this.translate(Math.round(camera.contentTranslateX),
                    Math.round(camera.contentTranslateY));
            }
        });
    }
    
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
