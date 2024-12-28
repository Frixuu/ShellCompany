// SPDX-License-Identifier: MIT
package shellco.ui;

import ceramic.App;
import ceramic.Quad;
import shellco.narrative.DialogueLine;
import shellco.narrative.NarrativeSystem;

/**
    This scene displays narrative elements, like conversations, etc.
**/
final class DialogueScene extends SceneBase {

    private var fullscreenHijackOverlay: Quad;
    
    public override function preload() {
        this.assets.addShader("shaders/single_color");
    }
    
    public override function create() {
        super.create();
        
        this.screenSpace = true;
        this.depth = 10000;
        
        this.add({
            final overlay = this.fullscreenHijackOverlay = new Quad();
            
            overlay.anchor(0.0, 0.0);
            overlay.pos(0.0, 0.0);
            overlay.size(Project.TARGET_WIDTH, Project.TARGET_HEIGHT);
            overlay.depth = 99999;
            overlay.transparent = true;
            overlay;
        });
        
        this.showLine(null);
        // this.hide();
    }
    
    private function showLine(line: DialogueLine) {
        final overlay = this.fullscreenHijackOverlay;
        overlay.visible = true;
        overlay.onPointerOver(overlay, _ -> {});
    }
    
    private function hide() {
        final overlay = this.fullscreenHijackOverlay;
        overlay.visible = false;
        overlay.offPointerOver();
    }
    
    public override function ready() {
        final app = App.app;
        final narrative = NarrativeSystem.instance;
        narrative.onConvoAdvanced(this, line -> {
            if (line != null) {
                this.showLine(line);
            } else {
                this.hide();
            }
        });
    }
}
