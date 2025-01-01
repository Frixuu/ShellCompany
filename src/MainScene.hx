// SPDX-License-Identifier: MIT
package;

import ceramic.AlphaColor;
import ceramic.App;
import ceramic.LdtkVisual;
import ceramic.Tilemap;
import ceramic.Timer;
import shellco.BabyShark;
import shellco.DroppedItem;
import shellco.EndLevel;
import shellco.EndScene;
import shellco.Lock;
import shellco.MathTools;
import shellco.PersistentScene;
import shellco.SceneBase;
import shellco.inventory.Cocktail;
import shellco.inventory.Key;
import shellco.inventory.Laxatives;
import shellco.level.EntityFactory;
import shellco.narrative.NarrativeSystem;
import shellco.player.Player;

using ceramic.SpritePlugin;
using ceramic.TilemapPlugin;

/**
    Main scene of the project.
**/
class MainScene extends SceneBase {

    public override function preload() {
        this.assets.addSprite("player");
        this.assets.addSprite("item");
        this.assets.addImage("levels/sheet_full");
        this.assets.addImage("levels/logos");
        this.assets.addImage("levels/big");
        this.assets.addImage("shark");
        this.assets.addTilemap("levels/game_jam");
        this.assets.addImage("white");
        this.assets.addShader("outline");
        this.assets.addShader("shaders/single_color");
        this.assets.addSound("audio/sfx/swim_1");
        this.assets.addSound("audio/sfx/swim_2");
        this.assets.addSound("audio/music/aquaria", {stream: true});
    }
    
    public override function create() {
        super.create();
        this.screenSpace = false;
        
        final tileset = this.assets.imageAsset("levels/sheet_full");
        tileset.texture.filter = NEAREST;
        
        this.assets.imageAsset("levels/logos").texture.filter = NEAREST;
        this.assets.imageAsset("levels/big").texture.filter = NEAREST;
        
        final arcade = App.app.arcade;
        arcade.autoUpdateWorldBounds = false;
        
        final persistentScene: PersistentScene = cast App.app.scenes.get("persistent");
        final camera = persistentScene.mainCamera;
        
        final ldtkData = this.assets.ldtk("levels/game_jam");
        final level = ldtkData.worlds[0].level("casino_outside");
        level.ensureLoaded(() -> {
        
            final tilemap = new Tilemap();
            tilemap.depth = -1;
            tilemap.tilemapData = level.ceramicTilemap;
            this.add(tilemap);
            
            arcade.world.setBounds(0, 0, tilemap.width, tilemap.height);
            tilemap.initArcadePhysics();
            tilemap.collidableLayers = ["foreground"];
            
            camera.contentX = level.worldX;
            camera.contentY = level.worldY;
            camera.contentWidth = level.pxWid;
            camera.contentHeight = level.pxHei;
            
            App.app.onPostUpdate(tilemap, _ -> {
                tilemap.clipTiles(Math.floor(camera.x - camera.viewportWidth * 0.55),
                    Math.floor(camera.y - camera.viewportHeight * 0.55),
                    Math.ceil(camera.viewportWidth) + tilemap.tilemapData.maxTileWidth,
                    Math.ceil(camera.viewportHeight) + tilemap.tilemapData.maxTileHeight);
            });
            
            final entityFactory = new EntityFactory();
            entityFactory.addRule({
                predicate: e -> e.def.identifier == "player",
                producer: _ -> {
                    final player = new Player(this.assets);
                    arcade.onUpdate(player, delta -> {
                        arcade.world.collide(player, tilemap);
                    });
                    App.app.onUpdate(player, _ -> {
                        final colorShallow: AlphaColor = 0xFF1D8B73;
                        final colorDeep: AlphaColor = 0xFF0B2234;
                        final color = AlphaColor.interpolate(colorShallow, colorDeep,
                            MathTools.clamp(((player.y - 200) * 0.003), 0.0, 1.0));
                        tilemap.tilemapData.backgroundColor = color;
                    });
                    player;
                },
            }).addRule({
                predicate: e -> e.def.identifier == "gate_key",
                producer: _ -> {
                    final key = new DroppedItem(this.assets, new Key());
                    key.afterPickup = () -> {
                        final narrative = NarrativeSystem.instance;
                        narrative.say("Ghost", "You know what they say.", true);
                        narrative.say("Ghost", "Communication is the *key* to success.");
                        narrative.say("E.", "I should ask for a raise.");
                    };
                    key;
                },
            }).addRule({
                predicate: e -> e.def.identifier == "xlax",
                producer: _ -> {
                    final laxatives = new DroppedItem(this.assets, new Laxatives());
                    laxatives.afterPickup = () -> {
                        final narrative = NarrativeSystem.instance;
                        narrative.say("Ghost",
                            "Hey E. You said this Baby had \"bowel problems?\"", true);
                        narrative.say("Ghost",
                            "I have a bunch of laxatives here. Almost not expired, too.");
                        narrative.say("Ghost",
                            "Do you think they'll help get me rid of that henchman?");
                        narrative.say("E.", "That's... the smartest thing you said today.");
                        narrative.say("E.", "But how are you going to convince him to eat them?");
                        narrative.say("Ghost", "I'm working on it.");
                    };
                    laxatives;
                },
            }).addRule({
                predicate: e -> e.def.identifier == "cocktail",
                producer: _ -> {
                    final cocktail = new DroppedItem(this.assets, new Cocktail());
                    cocktail.afterPickup = () -> {
                        final narrative = NarrativeSystem.instance;
                        narrative.say("Note", "Property of Amei and Capros.", true);
                        narrative.say("Note",
                            "Please leave this place as-is or feel the wrath of the Animals.");
                        narrative.say("Note", "Thank you xoxo");
                        narrative.say("Ghost", "E., do you drink on the job often?");
                        narrative.say("E.", "With you on call? I very strongly consider it.");
                    };
                    cocktail;
                },
            }).addRule({
                predicate: e -> e.def.identifier == "shark",
                producer: _ -> {
                    final shark = new BabyShark(this.assets);
                    shark.interactionRange = 100.0;
                    shark;
                },
            }).addRule({
                predicate: e -> e.def.identifier == "lock",
                producer: _ -> {
                    final visual = new Lock(this.assets);
                    visual.interactionRange = 70.0;
                    visual.afterUse = () -> {
                    
                        final foreground = tilemap.layer("foreground").layerData;
                        for (x in 16...18) {
                            for (y in 24...28) {
                                final index = foreground.indexFromColumnAndRow(x, y);
                                foreground.tiles.original[index] = 0;
                            }
                        }
                        
                        tilemap.computeContent();
                        
                        final narrative = NarrativeSystem.instance;
                        narrative.say("Ghost", "Aaaand, opeeen!", true);
                        narrative.say("Ghost", "Like shooting fish in a barrel.");
                        narrative.say("E.", "...");
                        narrative.say("Ghost", "I can literally hear you giving me the fish eye.",
                            () -> {
                                Timer.delay(this, 5.0, () -> {
                                    final narrative = NarrativeSystem.instance;
                                    narrative.say("E.",
                                        "It seems we're in luck. Baby Shark works the door today.",
                                        true);
                                    narrative.say("Ghost",
                                        "...Like, a literal baby? A security guard?");
                                    narrative.say("E.",
                                        "No. He has bowel problems and wears a diaper at all times.");
                                    narrative.say("Ghost", "Ah. Should've guessed.");
                                });
                            });
                    };
                    visual;
                },
            }).addRule({
                predicate: e -> e.def.identifier == "end",
                producer: _ -> {
                    final visual = new EndLevel(this.assets);
                    visual.entryEnabled = false;
                    visual.onGo = () -> {
                        App.app.scenes.set("main", new EndScene());
                    };
                    visual;
                },
            }).addRule({
                predicate: e -> e.def.isRenderable(Tile),
                producer: e -> new LdtkVisual(e),
            });
            
            level.createVisualsForEntities(tilemap, null, entityFactory.createVisualForLdtkEntity);
        });
        
        Timer.delay(this, 3.0, () -> {
            final narrative = NarrativeSystem.instance;
            narrative.say("Ghost", "Hey, E.", true);
            narrative.say("E.", "Yes, agent Ghost?");
            narrative.say("Ghost", "Would you mind briefing me again?");
            narrative.say("Ghost",
                "I *totally* remember every thing you've said, but I want to be extra sure.");
            narrative.say("E.", "...");
            narrative.say("E.", "Right.");
            narrative.say("E.", "Your task is to infiltrate the Fish & Chips casino.");
            narrative.say("E.",
                "There were rumors about potential Animals activity. " +
                "We suspect they have a hideout nearby.");
            narrative.say("Ghost",
                "And you pay me to find out what's going on. See? I remember everything.");
            narrative.say("Ghost", "I'm a ghostfish, not a goldfish.");
            narrative.say("E.", "*ughhh*");
        });
    }
    
    public override function ready() {
        super.ready();
        this.assets.sound("audio/music/aquaria").play(0, true, 0.3);
    }
    
    public override function update(delta: Float) {
        // Here, you can add code that will be executed at every frame
    }
    
    public override function destroy() {
        // Perform any cleanup before final destroy
        super.destroy();
    }
}
