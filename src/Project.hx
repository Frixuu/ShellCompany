// SPDX-License-Identifier: MIT
package;

import ceramic.App;
import ceramic.Color;
import ceramic.Entity;
import ceramic.Filter;
import ceramic.InitSettings;
import shellco.LoadingOverlayScene;
import shellco.PersistentScene;

/**
    The entry point of this Ceramic game.
**/
class Project extends Entity {

    /**
        The horizontal resolution, in pixels, at which the game is internally rendering at.
    **/
    public static inline final TARGET_WIDTH: Int = 320;
    
    /**
        The vertical resolution, in pixels, at which the game is internally rendering at.
    **/
    public static inline final TARGET_HEIGHT: Int = 180;
    
    public function new(settings: InitSettings) {
        super();
        
        settings.background = Color.BLACK;
        settings.targetWidth = TARGET_WIDTH;
        settings.targetHeight = TARGET_HEIGHT;
        settings.windowWidth = 1280;
        settings.windowHeight = 720;
        settings.antialiasing = 0;
        settings.scaling = FIT;
        settings.resizable = true;
        settings.defaultFont = "font:fonts/minogram";
        
        final app = App.app;
        app.onceDefaultAssetsLoad(this, assets -> {
            assets.addShader("shaders/pixel_art_filter");
        });
        
        app.onceReady(this, () -> {
        
            app.scenes.filter = {
                final filter = new Filter();
                filter.size(TARGET_WIDTH, TARGET_HEIGHT);
                filter.shader = {
                    final asset = app.assets.shader("shaders/pixel_art_filter");
                    final shader = asset.clone();
                    shader.setVec2("resolution", TARGET_WIDTH, TARGET_HEIGHT);
                    shader;
                };
                filter;
            };
            
            app.scenes.set("loading", new LoadingOverlayScene());
            app.scenes.set("persistent", {
                final scene = new PersistentScene();
                scene.assets.parent = app.assets;
                scene;
            });
        });
    }
}
