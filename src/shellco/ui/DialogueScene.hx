// SPDX-License-Identifier: MIT
package shellco.ui;

import ceramic.AlphaColor;
import ceramic.App;
import ceramic.Color;
import ceramic.InputMap;
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

/**
    This scene displays narrative elements, like conversations, etc.
**/
final class DialogueScene extends SceneBase {

    private var fullscreenHijackOverlay: Quad = null;
    private var background: Quad = null;
    private var textName: Text = null;
    private var textMessage: Text = null;
    private var portrait: Sprite = null;
    private var currentLine: Null<DialogueLine> = null;
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
            final bg = this.background = new Quad();
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
            final overlay = this.fullscreenHijackOverlay = new Quad();
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
        
        narrative.say("Ghost", "Hey, E.");
        narrative.say("E.", "Yes, agent Ghost?");
        narrative.say("Ghost", "Would you mind briefing me again?");
        narrative.say("Ghost",
            "I *totally* remember every detail you've said, but I want to be extra sure.");
        narrative.say("E.", "...");
        narrative.say("E.", "Right.");
        narrative.say("E.", "Your task is to infiltrate the Fish & Chips casino.");
        narrative.say("E.",
            "There were rumors about potential Animals activity. " +
            "We suspect they have a hideout nearby.");
        narrative.say("Ghost", "And I must know what's going on. See? I remember everything.");
        narrative.say("Ghost", "I'm a ghostfish, not a goldfish.");
        narrative.say("E.", "*ughhh*", () -> {
            Timer.delay(this, 10.0, () -> {
                narrative.say("E.", "It seems we're in luck. Baby Shark works the door today.",
                    true);
                narrative.say("Ghost", "...Like, a literal baby? A security guard?");
                narrative.say("E.", "No. He has bowel problems and wears a diaper at all times.");
                narrative.say("Ghost", "Ah. Should've guessed.");
            });
        });
        
        Timer.delay(this, 3.0, () -> narrative.advanceConvo());
    }
    
    public override function update(delta: Float) {
        super.update(delta);
        if (this.currentLine != null && this.inputMap.justPressed(Advance)) {
            NarrativeSystem.instance.advanceConvo();
        }
    }
}
