// SPDX-License-Identifier: MIT
package shellco;

import assets.Images;
import ceramic.App;
import ceramic.Logger;
import ceramic.Particles;
import ceramic.Scene;
import shellco.visual.BubbleParticleEmitter;

using Lambda;

/**
    Adds special effects when loading other Scenes.
**/
final class LoadingOverlayScene extends Scene {

    private static inline final MIN_TIME_ON_SCREEN: Float = 0.6;
    
    private var particles: Particles<BubbleParticleEmitter> = null;
    private var timer: Float = 0.0;
    
    public override function preload() {
        this.assets.add(Images.BUBBLE_128PX);
    }
    
    public override function create() {
        this.add({
            final emitter = new BubbleParticleEmitter(this.assets);
            final particles = this.particles = new Particles(emitter);
            particles.pos(Project.TARGET_WIDTH * 0.5, Project.TARGET_HEIGHT + 16);
            particles.anchor(0.5, 0);
            particles.size(Project.TARGET_WIDTH * 1.1, 16);
            particles.emitterInterval = 1.0 / 400.0;
            particles.autoEmit = false;
            particles;
        });
    }
    
    /**
        Event raised every frame when it is acceptable for a scene to fade in.
    **/
    @event public function okToTransition();
    
    public override function update(delta: Float) {
    
        final anyLoading = App.app.scenes.all.exists(scene -> {
            return scene.status == PRELOAD || scene.status == LOAD;
        });
        
        if (anyLoading || this.timer < MIN_TIME_ON_SCREEN || this.listensOkToTransition()) {
            if (!this.particles.autoEmit) {
                this.particles.autoEmit = true;
                this.timer = delta;
            } else {
                this.timer += delta;
            }
        }
        
        if (!anyLoading && this.timer >= MIN_TIME_ON_SCREEN) {
            this.emitOkToTransition();
            if (!this.listensOkToTransition()) {
                this.particles.autoEmit = false;
            }
        }
    }
}
