// SPDX-License-Identifier: MIT
package shellco.visual;

import assets.Images;
import ceramic.Assets;
import ceramic.ParticleEmitter;
import ceramic.Quad;
import ceramic.Visual;

/**
    Emits bubbles going upwards.
**/
final class BubbleParticleEmitter extends ParticleEmitter {

    private final assets: Assets;
    
    public function new(assets: Assets) {
        super();
        this.assets = assets;
        
        this.keepScaleRatio = true;
        this.scaleStart(0.075, 0.075, 0.2, 0.2);
        this.scaleEnd(0.075, 0.075, 0.2, 0.2);
        
        this.launchMode = SQUARE;
        this.velocityStart(-5, -310, 5, -210);
        this.velocityEnd(-5, -310, 5, -210);
        this.angularVelocityStart(-50, 50);
        this.angularVelocityEnd(-50, 50);
        
        this.lifespan(2, 2);
    }
    
    private override function getParticleVisual(existingVisual: Null<Visual>): Visual {
        if (existingVisual != null) {
            existingVisual.active = true;
            return existingVisual;
        }
        
        final quad = new Quad();
        quad.anchor(0.5, 0.5);
        quad.texture = this.assets.texture(Images.BUBBLE_128PX);
        quad.component("snap", new SnapTransformComponent());
        return quad;
    }
}
