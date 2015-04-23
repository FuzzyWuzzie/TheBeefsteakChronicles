import luxe.Input;
import luxe.Parcel;
import luxe.States;

import phoenix.BitmapFont;

import motion.Actuate;

import effects.Effects;
import effects.VignetteEffect;
import effects.SepiaEffect;
import effects.CircleTransitionEffect;

import states.Rustling;

class Main extends luxe.Game {
	private static var fsm:States;
	public static var font:BitmapFont;

	var effects:Effects = new Effects();
	static var transitionEffect:CircleTransitionEffect = new CircleTransitionEffect();
	static var nextState:String = null;

	override function ready() {
		// load the parcel
		Luxe.loadJSON("assets/parcel.json", function(jsonParcel) {
			var parcel = new Parcel();
			parcel.from_json(jsonParcel.json);

			// show a loading bar
			// use a fancy custom loading bar (https://github.com/FuzzyWuzzie/CustomLuxePreloader)
			new DigitalCircleParcelProgress({
				parcel: parcel,
				oncomplete: assetsLoaded
			});
			
			// start loading!
			parcel.load();
		});
	} //ready

	function assetsLoaded(_) {
		Luxe.renderer.clear_color = new luxe.Color(0.5, 0.5, 0.5, 1);

		effects.onload();
		effects.addEffect(new SepiaEffect());
		effects.addEffect(new VignetteEffect());
		effects.addEffect(transitionEffect);

		fsm = new States();
		fsm.add(new Rustling());

		fsm.set('Rustling');
	} // assetsLoaded

	override function update(dt:Float) {
		effects.update(dt);

		if(nextState != null) {
			fsm.set(nextState);
			nextState = null;
			Actuate.tween(transitionEffect, 1, { transition: 1 }).ease(motion.easing.Sine.easeIn).onComplete(function() {
				Luxe.timescale = 1;
			});
		}
	} // update

	override function onprerender() {
		effects.onprerender();
	} // onprerender

	override function onpostrender() {
		effects.onpostrender();
	} // onpostrender

	public static function transitionToState(newState:String) {
		Luxe.timescale = 0.001;
		Actuate.tween(transitionEffect, 1, { transition: 0 }).ease(motion.easing.Sine.easeIn).onComplete(function() {
			nextState = newState;
		});
	}

} //Main
