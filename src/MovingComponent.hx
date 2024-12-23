// SPDX-License-Identifier: MIT
package;

import ceramic.Component;
import ceramic.Entity;
import ceramic.Timer;
import ceramic.Visual;

/**
    Testing component for moving sprites.
**/
class MovingComponent extends Entity implements Component {

    @entity private var visual: Visual;
    
    public function new() {
        super();
    }
    
    public function bindAsComponent() {
        this.playOnce();
    }
    
    private function playOnce() {
        visual.tween(LINEAR, 2.0, 0.0, Project.TARGET_WIDTH, (value, time) -> {
            visual.x = value;
        }).onceComplete(this, () -> {
            Timer.delay(this, 0.0, this.playOnce);
        });
    }
}
