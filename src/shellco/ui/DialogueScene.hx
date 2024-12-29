// SPDX-License-Identifier: MIT
package shellco.ui;

import ceramic.AlphaColor;
import ceramic.App;
import ceramic.Color;
import ceramic.InputMap;
import ceramic.Logger;
import ceramic.Quad;
import ceramic.ScanCode;
import ceramic.Sprite;
import ceramic.Text;
import ceramic.Timer;
import shellco.narrative.DialogueLine;
import shellco.narrative.NarrativeSystem;

using ceramic.SpritePlugin;

private enum abstract ConvoAction(Int) {
    public var Advance;
}

class Overlay extends Quad {}
class Background extends Quad {}

/**
    This scene displays narrative elements, like conversations, etc.
**/
final class DialogueScene extends SceneBase {

    private var fullscreenHijackOverlay: Null<Overlay> = null;
    private var background: Background = null;
    private var textName: Text = null;
    private var textMessage: Text = null;
    private var portrait: Sprite = null;
    private var currentLine: Null<DialogueLine> = null;
    private final logger: Logger = new Logger();
    private final inputMap: InputMap<ConvoAction> = {
        final map = new InputMap<ConvoAction>();
        map.bindScanCode(Advance, ScanCode.SPACE);
        map.bindMouseButton(Advance, 0);
        map;
    };
    
    public override function preload() {
        this.assets.addShader("shaders/single_color");
        this.assets.addSprite("portraits");
    }
    
    public override function create() {
        super.create();
        
        this.screenSpace = true;
        this.depth = 10000;
        
        this.add({
            final bg = this.background = new Background();
            bg.anchor(0, 0);
            bg.pos(0, 112);
            bg.size(Project.TARGET_WIDTH, 60);
            bg.blending = ALPHA;
            bg.shader = {
                final asset = this.assets.shader("shaders/single_color");
                final shader = asset.clone();
                shader.setAlphaColor("color", new AlphaColor(Color.BLACK, 170));
                shader;
            };
            bg;
        });
        
        this.add({
            final portrait = this.portrait = new Sprite();
            portrait.size(128, 128);
            portrait.anchor(0.0, 0.0);
            portrait.pos(0.0, Project.TARGET_HEIGHT - 128);
            portrait.sheet = this.assets.sheet("portraits");
            portrait;
        });
        
        this.add({
            final text = this.textName = new Text();
            text.pointSize = 20;
            text.anchor(0, 0);
            text.pos(100, 115);
            text;
        });
        
        this.add({
            final text = this.textMessage = new Text();
            text.pointSize = 10;
            text.anchor(0.0, 0.0);
            text.pos(100, 136);
            text.fitWidth = 210;
            text;
        });
        
        this.add({
            final overlay = this.fullscreenHijackOverlay = new Overlay();
            overlay.anchor(0.0, 0.0);
            overlay.pos(0.0, 0.0);
            overlay.size(Project.TARGET_WIDTH, Project.TARGET_HEIGHT);
            overlay.depth = 99999;
            overlay.transparent = true;
            overlay;
        });
        
        this.hide();
    }
    
    private function showLine(line: DialogueLine) {
        this.currentLine = line;
        
        this.background.visible = true;
        this.portrait.visible = true;
        this.portrait.animation = line.portrait;
        this.textName.visible = true;
        this.textName.content = line.characterName;
        this.textName.color = line.nameColor;
        this.textMessage.visible = true;
        this.textMessage.content = line.text;
        
        final overlay = this.fullscreenHijackOverlay;
        overlay.visible = true;
        overlay.onPointerOver(overlay, _ -> {}); // hack for preventing pointer event propagation
        
        this.logger.info('[DIA] Showing a new line: ${line.text.substr(0, 10)}...');
    }
    
    private function hide() {
        this.currentLine = null;
        
        this.background.visible = false;
        this.portrait.visible = false;
        this.textName.visible = false;
        this.textMessage.visible = false;
        
        final overlay = this.fullscreenHijackOverlay;
        overlay.visible = false;
        overlay.offPointerOver(); // hack; ditto
        
        this.logger.info("[DIA] Hiding!");
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
    
    public override function update(delta: Float) {
        super.update(delta);
        if (this.currentLine != null && this.inputMap.justPressed(Advance)) {
            Timer.delay(this, 0.0001, () -> NarrativeSystem.instance.advanceConvo());
        }
    }
}
