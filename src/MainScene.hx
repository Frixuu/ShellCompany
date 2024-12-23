// SPDX-License-Identifier: MIT
package;

import assets.*;
import ceramic.Quad;
import ceramic.Scene;
import ceramic.Shortcuts.*;
import shellco.visual.SnapTransformComponent;

/**
    Main scene of the project.
**/
class MainScene extends Scene {

    private var fish: Quad;
    
    public override function preload() {
        // Add any asset you want to load here
        assets.add(Images.FISH_DEBUG);
    }
    
    public override function create() {
        // Called when scene has finished preloading
        
        fish = new Quad();
        fish.texture = {
            final texture = assets.texture(Images.FISH_DEBUG);
            texture.filter = NEAREST;
            texture;
        };
        fish.anchor(0.5, 0.5);
        fish.pos(width * 0.5, height * 0.5);
        fish.scale(0.0001);
        fish.alpha = 0;
        
        fish.component("moving", new MovingComponent());
        fish.component("snap", new SnapTransformComponent());
        this.add(fish);
        
        fish.tween(ELASTIC_EASE_IN_OUT, 0.75, 0.0001, 1.0, function(value, time) {
            fish.alpha = value;
            fish.scale(value);
        });
        
        // Print some log
        log.success("Hello from ceramic :)");
    }
    
    public override function update(delta: Float) {
        // Here, you can add code that will be executed at every frame
    }
    
    public override function resize(width: Float, height: Float) {
        // Called everytime the scene size has changed
    }
    
    public override function destroy() {
        // Perform any cleanup before final destroy
        super.destroy();
    }
}
