// SPDX-License-Identifier: MIT
package;

import ceramic.AlphaColor;
import ceramic.App;
import ceramic.LdtkVisual;
import ceramic.Quad;
import ceramic.Tilemap;
import shellco.InteractableVisual;
import shellco.MathTools;
import shellco.PersistentScene;
import shellco.SceneBase;
import shellco.player.Player;

using ceramic.SpritePlugin;
using ceramic.TilemapPlugin;

/**
    Main scene of the project.
**/
class MainScene extends SceneBase {

    private var fish: Quad;
    
    public override function preload() {
        this.assets.addSprite("player");
        this.assets.addImage("levels/sheet_full");
        this.assets.addImage("levels/logos");
        this.assets.addImage("levels/big");
        this.assets.addTilemap("levels/game_jam");
        this.assets.addImage("white");
        this.assets.addShader("outline");
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
                tilemap.clipTiles(Math.floor(camera.x - camera.viewportWidth * 0.5),
                    Math.floor(camera.y - camera.viewportHeight * 0.5),
                    Math.ceil(camera.viewportWidth) + tilemap.tilemapData.maxTileWidth,
                    Math.ceil(camera.viewportHeight) + tilemap.tilemapData.maxTileHeight);
            });
            
            level.createVisualsForEntities(tilemap, null, ldtkEntity -> {
                final entityDef = ldtkEntity.def;
                return if (entityDef.identifier == "player") {
                    final player = new Player(this.assets);
                    player.pos(ldtkEntity.pxX, ldtkEntity.pxY);
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
                } else if (entityDef.identifier == "mob") {
                    final visual = new InteractableVisual(this.assets);
                    visual.anchor(0, 0);
                    visual.size(16, 16);
                    visual.pos(ldtkEntity.pxX, ldtkEntity.pxY);
                    visual;
                } else if (entityDef.isRenderable(Tile)) {
                    new LdtkVisual(ldtkEntity);
                } else {
                    null;
                };
            });
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
