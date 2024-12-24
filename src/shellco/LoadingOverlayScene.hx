// SPDX-License-Identifier: MIT
package shellco;

import ceramic.App;
import ceramic.Logger;
import ceramic.Particles;
import ceramic.Scene;
import ceramic.Tween;
import shellco.visual.BubbleParticleEmitter;

using Lambda;
using shellco.Extensions;

/**
    Adds special effects when loading other Scenes.
**/
final class LoadingOverlayScene extends Scene {

    private static inline final MIN_TIME_ON_SCREEN: Float = 0.6;
    
    private final logger: Logger = new Logger();
    private var particles: Particles<BubbleParticleEmitter> = null;
    private var soundTween: Null<Tween> = null;
    private var timer: Float = 0.0;
    private var isAnimating: Bool = false;
    
    public override function preload() {
        this.assets.addImage("ui/bubble_128px");
        this.assets.addSound("audio/sfx/bubbles_loop");
    }
    
    public override function create() {
    
        this.onTransitionStarted(this, () -> {
            this.logger.info("Loading animation started");
        });
        this.onTransitionEnded(this, () -> {
            this.logger.info('Loading animation finished after ${this.timer.round(3)}s');
        });
        
        this.depth = 1000;
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
        
        final sound = this.assets.sound("audio/sfx/bubbles_loop");
        final soundPlayer = sound.play(0.0, true, 0.0, null, null);
        soundPlayer.pause();
        
        static final volume: Float = 0.6;
        static final fadeTime: Float = 0.6;
        this.onTransitionStarted(this, () -> {
            soundPlayer.resume();
            this.soundTween?.destroy();
            this.soundTween = Tween.start(this, QUAD_EASE_IN, fadeTime, 0.0, volume,
                (value, _) -> {
                    soundPlayer.volume = value;
                });
        });
        this.onTransitionEnded(this, () -> {
            this.soundTween?.destroy();
            this.soundTween = Tween.start(this, QUAD_EASE_OUT, fadeTime, volume, 0.0,
                (value, _) -> {
                    soundPlayer.volume = value;
                });
            this.soundTween.onceComplete(this, () -> {
                soundPlayer.pause();
            });
        });
    }
    
    /**
        Event raised when an animation has started.
    **/
    @event public function transitionStarted();
    
    /**
        Event raised every frame when it is acceptable for a scene to fade in.
    **/
    @event public function okToTransition();
    
    /**
        Event raised when an animation has stopped.
    **/
    @event public function transitionEnded();
    
    public override function update(delta: Float) {
    
        final anyLoading = App.app.scenes.all.exists(scene -> {
            return scene.status == PRELOAD || scene.status == LOAD;
        });
        
        if (anyLoading || this.timer < MIN_TIME_ON_SCREEN || this.listensOkToTransition()) {
            if (!this.isAnimating) {
                this.isAnimating = true;
                this.particles.autoEmit = true;
                this.emitTransitionStarted();
                this.timer = delta;
            } else {
                this.timer += delta;
            }
        }
        
        if (!anyLoading && this.timer >= MIN_TIME_ON_SCREEN) {
            this.emitOkToTransition();
            if (this.isAnimating && !this.listensOkToTransition()) {
                this.isAnimating = false;
                this.particles.autoEmit = false;
                this.emitTransitionEnded();
            }
        }
    }
}
