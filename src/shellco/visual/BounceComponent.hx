// SPDX-License-Identifier: MIT
package shellco.visual;

import ceramic.Component;
import ceramic.Entity;
import ceramic.Timer;
import ceramic.Visual;

/**
    This component moves the entity up and down.
**/
class BounceComponent extends Entity implements Component {

    @entity private var visual: Visual;
    private final amplitude: Float;
    private final timeScale: Float;
    
    public function new(amplitude: Float, timeScale: Float) {
        super();
        this.amplitude = amplitude;
        this.timeScale = timeScale;
    }
    
    public function bindAsComponent() {
        this.playOnce();
    }
    
    private function playOnce() {
        visual.tween(LINEAR, this.timeScale, 0.0, 2 * Math.PI, (value, time) -> {
            visual.y = Math.sin(value) * amplitude;
        }).onceComplete(this, () -> {
            Timer.delay(this, 0.0, this.playOnce);
        });
    }
}
