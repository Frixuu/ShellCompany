// SPDX-License-Identifier: MIT
package shellco.visual;

import ceramic.Component;
import ceramic.Entity;
import ceramic.Visual;
import shellco.visual.SnapTransformsSystem;

/**
    This component "snaps" entities to the grid.
**/
final class SnapTransformComponent extends Entity implements Component {

    /**
        The entity this component belongs to.
    **/
    @entity public var visual: Visual;
    
    private final system: SnapTransformsSystem;
    
    public function new() {
        super();
        this.system = SnapTransformsSystem.instance;
    }
    
    public function bindAsComponent() {
        this.system.knownComponents.set(this, true);
    }
    
    public override function destroy() {
        super.destroy();
        this.system.knownComponents.remove(this);
    }
}
