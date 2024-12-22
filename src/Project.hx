package;

import ceramic.Color;
import ceramic.Entity;
import ceramic.InitSettings;
import ceramic.Shortcuts.*;

/**
    The entry point of this Ceramic game.
**/
class Project extends Entity {

    public function new(settings: InitSettings) {
        super();
        
        settings.antialiasing = 2;
        settings.background = Color.BLACK;
        settings.targetWidth = 1280;
        settings.targetHeight = 720;
        settings.scaling = FIT;
        settings.resizable = true;
        
        app.onceReady(this, () -> {
            // Set MainScene as the current scene (see MainScene.hx)
            app.scenes.main = new MainScene();
        });
    }
}
