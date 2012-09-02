/*
 * Authors: Joël Robichaud & Maxime St-Louis-Fortier
 * Copyright (c) 2010
 * Version: 1.0.0
 * 
 * Licence Agreement
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package com.pieceoftetris.utils {
	
	import com.pieceoftetris.events.SmoothKeyboardEvent;
	
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	
	public class KeyboardController extends EventDispatcher {
		/**
		 * L'instance de la classe
		 */
		private static var _instance:KeyboardController = new KeyboardController();
		
		/**
		 * Référence au stage
		 */
		private static var _stage:Stage;
		
		/**
		 * Objet contenant les touches enfoncées
		 */
		private static var _keysDown:Object;
		
		/**
		 * Objet contenant les touches verouillées,
		 * celles-ci ne peuvent déclencher de répétitions
		 */
		private static var _keysLocked:Object;
		
		/**
		 * Objet contenant les Timers nécessaires à la
		 * diffusion des SmoothKeyboardEvents
		 */
		private static var _keysTimers:Object;
		
		/**
		 * Détermine si SmoothKeyboardEvent est utilisé à la place de
		 * KeyboardEvent pour gérer la diffusion d'événements du clavier
		 */
		private var _smoothMovements:Boolean;
		
		/**
		 * Le delais avant qu'une touche enfoncée soit répétée
		 */
		private var _repetitionDelay:Number;
		
		/**
		 * L'interval entre les répétitions, donc les diffusions des SmoothKeyboardEvent
		 */
		private var _dispatchInterval:Number;
		
		/**
		 * Constructeur Singleton
		 */
		public function KeyboardController() {
			if (_instance) {
				throw new Error("KeysController can only be accessed from the static property KeysController.instance");
			}
		}
		
		/**
		 * Active la capture des touches
		 *
		 * @param $stage référence au stage
		 * @param $smoothMovements détermine si la classe SmoothKeyboardEvent remplace les KeyboardEvent
		 * @param $repetitionDelay le delais avant qu'une touche enfoncée soit répétée
		 * @param $dispatchInterval l'interval entre les répétitions, donc les diffusions des SmoothKeyboardEvent
		 */
		public function initialize ($stage:Stage, $smoothMovements:Boolean=false, $repetitionDelay:Number=0, $dispatchInterval:Number=20):void {
			this.stage = $stage;
			_keysDown = new Object();
			_keysLocked = new Object();
			_keysTimers = new Object();
			_smoothMovements = $smoothMovements;
			_repetitionDelay = $repetitionDelay;
			_dispatchInterval = $dispatchInterval;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased);
		}
		
		/**
		 * Désactive la capture des touches
		 */
		public function disable ():void {
			this.stage = null;
			_keysDown = new Object();
			_keysLocked = new Object();
			_keysTimers = new Object();
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyReleased);
		}
		
		/**
		 * Permet de vérifier si une touche est enfoncée ou non
		 * @return Boolean true si la touche est enfoncée; sinon false
		 */
		public function isDown ($keyCode:uint):Boolean {
			return Boolean($keyCode in _keysDown);
		}
		
		/**
		 * Permet de vérifier si une touche est verouillée ou non
		 * @return Boolean true si la touche est verouillée; sinon false
		 */
		public function isLocked ($keyCode:uint):Boolean {
			return Boolean($keyCode in _keysLocked);
		}
		
		/**
		 * Fonction déclenchée lorsqu'une touche est enfoncée
		 * @param $evt objet évenementiel KeyboardEvent
		 */
		private function keyPressed ($evt:KeyboardEvent):void {
			// Si les smoothMovements sont activés, un Timer doit être déclenché pour pourvoir gérer les répétition
			if (_smoothMovements && !Boolean(_keysDown[$evt.keyCode])) {
				this.dispatchEvent(new SmoothKeyboardEvent(SmoothKeyboardEvent.KEY_DOWN, $evt.keyCode));
				
				// Création du Timer qui, lorsque terminé, créera le Timer diffusant les répétitions
				var repetitionTimer:KeysTimer = new KeysTimer($evt.keyCode, _repetitionDelay, 1);
				repetitionTimer.addEventListener(TimerEvent.TIMER_COMPLETE, startRepetitions);
				
				// Le Timer est stocké dans un objet pour pouvoir le récupérer plus tard
				_keysTimers[$evt.keyCode] = repetitionTimer;
			}
			
			_keysDown[$evt.keyCode] = true;
		}
		
		/**
		 * Fonction déclenchée lorsque le temps avant la première répétition est écoulé
		 * @param $evt objet évenementiel TimerEvent
		 */
		private function startRepetitions ($evt:TimerEvent):void {
			$evt.target.removeEventListener(TimerEvent.TIMER_COMPLETE, startRepetitions);
			this.dispatchEvent(new SmoothKeyboardEvent(SmoothKeyboardEvent.KEY_DOWN, $evt.target.keyCode));
			
			// Création du Timer qui diffusera les répétitions
			var dispatchTimer:KeysTimer = new KeysTimer($evt.target.keyCode, _dispatchInterval);
			dispatchTimer.addEventListener(TimerEvent.TIMER, dispatchRepetitions);
			
			// Le Timer est stocké dans un objet pour pouvoir le récupérer plus tard
			_keysTimers[$evt.target.keyCode] = dispatchTimer;
		}
		
		/**
		 * Diffusion de la répétition d'une touche enfoncée
		 * @param $evt objet évenementiel TimerEvent
		 */
		private function dispatchRepetitions ($evt:TimerEvent):void {
			this.dispatchEvent(new SmoothKeyboardEvent(SmoothKeyboardEvent.KEY_DOWN, $evt.target.keyCode));
		}
		
		/**
		 * Fonction déclenchée lorsqu'une touche est relâchée
		 * @param $evt objet évenementiel KeyboardEvent
		 */
		private function keyReleased ($evt:KeyboardEvent):void {
			// La touche est supprimée des objets dans lesquels son indice numérique était stocké
			delete _keysDown[$evt.keyCode];
			unlockKey($evt.keyCode);
			
			// Si les smoothMovements sont activés, les écouteurs doivent être supprimés sur les Timers
			if (_smoothMovements) {
				try {
					_keysTimers[$evt.keyCode].removeEventListener(TimerEvent.TIMER, dispatchRepetitions);
				} catch ($error:Error) {
					// La touche a été relâchée avant que la répétition ait lieu
					_keysTimers[$evt.keyCode].removeEventListener(TimerEvent.TIMER_COMPLETE, startRepetitions);
				} finally {
					if (_keysTimers[$evt.keyCode] != undefined) {
						// Arrêt et suppression du Timer
						_keysTimers[$evt.keyCode].stop();
						delete _keysTimers[$evt.keyCode];
					}
					// Diffusion de l'événement SmoothKeyboardEvent lié au relâchement d'une touche
					this.dispatchEvent(new SmoothKeyboardEvent(SmoothKeyboardEvent.KEY_UP, $evt.keyCode));
				}
				
			}
			
		}
		
		/**
		 * Permet de verouiller une touche
		 * @param $keyCode l'indice numérique de la touche à verouiller
		 */
		public function lockKey ($keyCode:uint):void {
			_keysLocked[$keyCode] = true;
		}
		
		/**
		 * Permet de déverouiller une touche
		 * @param $keyCode l'indice numérique de la touche à déverouiller
		 */
		public function unlockKey ($keyCode:uint):void {
			delete _keysLocked[$keyCode];
		}
		
		/**
		 * Permet de récupérer le Singleton
		 * @return KeysController l'instance de la classe
		 */
		public static function get instance():KeyboardController {
			return _instance;
		}
		
		/**
		 * Assigne une référence au stage
		 * @param $stage rérence au stage
		 */
		public function set stage ($stage:Stage):void {
			_stage = $stage;
		}
		
		/**
		 * Récupère la référence au stage
		 * @return Stage référence au stage
		 */
		public function get stage ():Stage {
			return _stage;
		}
		
	}
	
}

import flash.utils.Timer;

/**
 * Classe Timer utilisé pour diffuser des événement de type SmoothKeyBoardEvent
 */
internal class KeysTimer extends Timer {
	/**
	 * L'indice numérique de la touche ayant déclenché le Timer
	 */
	private var _keyCode:uint;
	
	/**
	 * Constructeur
	 *
	 * @param $keyCode l'indice numérique de la touche ayant déclenché le Timer
	 * @param $delay le delais entre chaque répétition
	 * @param repeatCount le nombre de répétitions
	 * @param $active permet de partir le timer automatiquement
	 */
	public function KeysTimer($keyCode:uint, $delay:Number, $repeatCount:int=0, $active:Boolean=true) {
		// Assignation des valeurs des paramètres à leur propriété respective
		_keyCode = $keyCode;
		// Appel de classe mère
		super($delay, $repeatCount);
		// Le Timer part automatiquement
		if ($active) this.start();
	}
	
	/**
	 * Permet de récupérer la touche qui a déclenché le Timer
	 * @return uint l'indice numérique de la touche enfoncée
	 */
	public function get keyCode ():uint {
		return _keyCode;
	}
	
}
