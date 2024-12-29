// SPDX-License-Identifier: MIT
package;

import ceramic.App;
import ceramic.AssetOptions;
import ceramic.Color;
import ceramic.LdtkVisual;
import ceramic.Quad;
import ceramic.Text;
import ceramic.Tilemap;
import shellco.InteractableVisual;
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
        this.assets.addImage("levels/ship");
        this.assets.addTilemap("levels/game_jam");
        this.assets.addImage("white");
        this.assets.addShader("outline");
    }
    
    public override function create() {
        this.screenSpace = false;
        super.create();
    }
    
    public override function ready() {
        super.ready();
        final text = new Text();
        text.color = Color.WHITE;
        text.pointSize = 10;
        text.anchor(0, 0);
        text.font = {
            final font = this.assets.font("fonts/minogram");
            font;
        };
        text.content = "Hello World!";
        text.pos(20, 20);
        this.add(text);
        
        final tileset = this.assets.imageAsset("levels/sheet_full");
        tileset.texture.filter = NEAREST;
        
        this.assets.imageAsset("levels/logos").texture.filter = NEAREST;
        this.assets.imageAsset("levels/ship").texture.filter = NEAREST;
        
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
    
    public override function update(delta: Float) {
        // Here, you can add code that will be executed at every frame
    }
    
    public override function resize(width: Float, height: Float) {
        // Called everytime the scene size has changed
    }
    
    public override function destroy() {
        // Perform any cleanup before final destroy
        super.destroy();
    }
}
