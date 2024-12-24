// SPDX-License-Identifier: MIT
package;

import assets.Images;
import ceramic.App;
import ceramic.Color;
import ceramic.LdtkVisual;
import ceramic.Quad;
import ceramic.Text;
import ceramic.Tilemap;
import shellco.PersistentScene;
import shellco.SceneBase;
import shellco.player.Player;

using ceramic.TilemapPlugin;

/**
    Main scene of the project.
**/
class MainScene extends SceneBase {

    private var fish: Quad;
    
    public override function preload() {
        this.assets.addImage("levels/SunnyLand_by_Ansimuz-extended");
        this.assets.addTilemap("levels/platformer_sample");
        this.assets.addImage(Images.DANCING_GIRL_SNAP);
    }
    
    public override function create() {
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
        
        final tileset = this.assets.imageAsset("levels/SunnyLand_by_Ansimuz-extended");
        tileset.texture.filter = NEAREST;
        
        final arcade = App.app.arcade;
        arcade.autoUpdateWorldBounds = false;
        arcade.onUpdate(this, delta -> {
            // final world = arcade.world;
        });
        
        final persistentScene: PersistentScene = cast App.app.scenes.get("persistent");
        final camera = persistentScene.mainCamera;
        // camera.targetX = 400;
        // camera.targetY = 300;
        
        final ldtkData = this.assets.ldtk("levels/platformer_sample");
        final level = ldtkData.worlds[0].levels[0];
        level.ensureLoaded(() -> {
        
            final tilemap = new Tilemap();
            tilemap.depth = -1;
            tilemap.tilemapData = level.ceramicTilemap;
            this.add(tilemap);
            
            arcade.world.setBounds(0, 0, tilemap.width, tilemap.height);
            tilemap.initArcadePhysics();
            tilemap.collidableLayers = ["collisions"];
            
            App.app.onPostUpdate(tilemap, _ -> {
                // tilemap.clipTiles(Math.floor(camera.x - camera.viewportWidth * 0.5),
                //    Math.floor(camera.y - camera.viewportHeight * 0.5),
                //    Math.ceil(camera.viewportWidth) + tilemap.tilemapData.maxTileWidth,
                //    Math.ceil(camera.viewportHeight) + tilemap.tilemapData.maxTileHeight);
            });
            
            // tilemap.layer("collisions").visible = false;
            // tilemap.layer("bg_textures").visible = false;
            
            level.createVisualsForEntities(tilemap, null, ldtkEntity -> {
                final entityDef = ldtkEntity.def;
                return if (entityDef.identifier == "player") {
                    final player = new Player(this.assets);
                    player.pos(ldtkEntity.pxX, ldtkEntity.pxY);
                    player.size(ldtkEntity.width, ldtkEntity.height);
                    player;
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
