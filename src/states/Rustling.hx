package states;

import luxe.Color;
import luxe.Scene;
import luxe.States;
import luxe.Input;
import luxe.Text;
import phoenix.Rectangle;
import phoenix.Texture;
import luxe.Sprite;
import luxe.components.sprite.SpriteAnimation;
import luxe.Vector;

class Rustling extends State {
	var stateScene:Scene;

	public function new() {
		super({ name: 'Rustling' });
		stateScene = new Scene('Rustling');
	}

	override function onenter<T>(_:T) {
		for(i in 0...10) {
			createCow(Luxe.utils.geometry.random_point_in_unit_circle().multiplyScalar(100));
		}

		Luxe.camera.center = new Vector();
	}

	override function onleave<T>(_:T) {
		stateScene.empty();
	}

	override function onmouseup(e:MouseEvent) {
		Main.transitionToState('Rustling');
	}

	function createCow(pos:Vector) {
		var cowTexture:Texture = Luxe.resources.find_texture("assets/sprites/cow.png");
		cowTexture.filter = FilterType.nearest;

		var cow:Sprite = new Sprite({
			name: 'cow',
			name_unique: true,
			pos: pos,
			size: new Vector(16, 16),
			texture: cowTexture,
			scene: stateScene,
			depth: pos.y
		});

		var anim:SpriteAnimation = cow.add(new SpriteAnimation({ name: 'SpriteAnimation' }));
		anim.add_from_json_object(Luxe.resources.find_json('assets/sprites/cow.json').json);
		anim.animation = 'idle';
		anim.play();
	}
}