// SPDX-License-Identifier: MIT
package shellco;

import ceramic.App;
import ceramic.Quad;
import ceramic.SoundPlayer;
import elements.Button;
import shellco.ui.DialogueScene;
import shellco.ui.InventoryScene;

class MainMenuScene extends SceneBase {

    private var musicPlayer: SoundPlayer;
    
    public override function preload() {
        this.assets.addImage("title_screen");
        this.assets.addSound("audio/music/ova_loop_2", {stream: true});
    }
    
    public override function create() {
        super.create();
        this.screenSpace = true;
    }
    
    public override function ready() {
        super.ready();
        this.screenSpace = true;
        this.musicPlayer = this.assets.sound("audio/music/ova_loop_2").play(0, true, 0.6);
        this.add({
            final quad = new Quad();
            quad.anchor(0, 0);
            quad.pos(0, 0);
            quad.size(Project.TARGET_WIDTH, Project.TARGET_HEIGHT);
            quad.texture = this.assets.texture("title_screen");
            quad.texture.filter = NEAREST;
            quad;
        });
        this.add({
            final btn = new Button();
            btn.anchor(0, 0);
            btn.pos(160, 50);
            btn.size(110, 36);
            btn.content = "Play";
            btn.pointSize = 20;
            btn.onceClick(btn, () -> {
            
                final app = App.app;
                
                app.scenes.set("ui: dialogue", {
                    final scene = new DialogueScene();
                    scene.assets.parent = this.assets.parent;
                    scene;
                });
                
                app.scenes.set("ui: inventory", {
                    final scene = new InventoryScene();
                    scene.assets.parent = this.assets.parent;
                    scene;
                });
                
                app.scenes.set("main", {
                    final scene = new MainScene();
                    scene.assets.parent = this.assets.parent;
                    scene;
                });
            });
            btn;
        });
    }
    
    public override function destroy() {
        super.destroy();
        this.musicPlayer?.stop();
    }
}
