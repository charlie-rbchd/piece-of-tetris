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
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	/**
	 * Classe utilisée pour la gestion de l'interval entre les utilisations des abilités
	 */
	public class Cooldown extends Sprite {
		/**
		 * Constatnte définissant le type d'animation associé au Cooldown
		 */
		public static const TYPE_FILL:String = "fill";
		
		/**
		 * Le Timer qui gère l'interval de l'animation/de l'utilisation des abilités
		 */
		private var _mainTimer:Timer;
		
		/**
		 * Le Loader servant à charger l'image de l'abilité
		 */
		private var _imgLoader:DisplayObject;
		
		/**
		 * Le type de Cooldown (Cooldown.TYPE_FILL)
		 */
		private var _type:String;
		
		/**
		 * La Shape qui est animée en fonction du temps restant
		 */
		private var _overlayShape:Shape;
		
		/**
		 * Le temps entre chaque utilisation de l'abilité
		 */
		private var _time:int;
		
		/**
		 * Le temps restant avant la fin du Timer
		 */
		private var _remainingTime:Number;
		
		/**
		 * Détermine si le Timer est actif dès sa création
		 */
		private var _active:Boolean;
		
		/**
		 * Le champs texte affichant le temps restant
		 */
		private var _cooldownText:TextField;
		
		/**
		 * Le formatage du texte pour le temps restant
		 */
		private var _textFormat:TextFormat;
		
		/**
		 * Constructeur
		 *
		 * @param $time le temps entre chaque abilité
		 * @param $imgPath le chemin vers l'image de l'abilité
		 * @param $type le type de Cooldown
		 * @param $active détermine si le Timer est actif dès sa création
		 */
		public function Cooldown($time:int, $displayObject:DisplayObject, $type:String=Cooldown.TYPE_FILL, $active:Boolean=false) {
			// Assignation des valeurs des paramètres à leur propriété respective
			_type = $type;
			_time = $time;
			_active = $active;
			
			// Création des objets nécessaires à l'affichage
			_textFormat = new TextFormat();
			_cooldownText = new TextField();
			_overlayShape = new Shape();
			
			// Création et placement d'écouteurs sur un Timer
			_remainingTime = 0;
			_mainTimer = new Timer(25, $time*1000/25);
			_mainTimer.addEventListener(TimerEvent.TIMER, updateTime);
			_mainTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerComplete);
			
			// Création du loader et initialise le chargement de l'image de l'abilité
			_imgLoader = $displayObject;
			this.addChild(_imgLoader);
			initializeGraphics();
		}
		
		/**
		 * @param $evt objet évenementiel Event, l'image de l'abilité a terminé de charger
		 */
		private function initializeGraphics ():void {
			switch (_type) {
				case TYPE_FILL:
					// Création et positionnement de l'animation en fonction des dimensions de l'image
					_overlayShape.graphics.beginFill(0xFFFFFF, 0.7);
					_overlayShape.graphics.drawRect(0, 0, _imgLoader.width, _imgLoader.height);
					_overlayShape.graphics.endFill();
					_overlayShape.rotation = 180;
					_overlayShape.x = _imgLoader.width;
					_overlayShape.y = _imgLoader.height;
					break;
				default:
					throw new Error("La propriété type doit être définie par une constante de la classe Cooldown.");
			}
			
			// Création du formatage par défaut du texte
			_textFormat.size = 36;
			_textFormat.color = 0xFFFFFF;
			_textFormat.bold = true;
			// Création et positionnement de l'affichage du temps restant
			_cooldownText.defaultTextFormat = _textFormat;
			_cooldownText.selectable = false;
			_cooldownText.x = _imgLoader.width/2 - 9;
			_cooldownText.y = _imgLoader.height + 7;
			
			// Démarre automatiquement le Timer
			if (_active)  this.start();
		}
		
		/**
		 * Supprime le temps restant et l'animation de la liste d'affichage,
		 * retour à leurs valeurs originelles
		 * @param $evt objet évenementiel TimerEvent, le Timer a terminé le compte du temps
		 */
		private function timerComplete ($evt:TimerEvent):void {
			this.reset();
		}
		
		/**
		 * Permet l'animation et l'affichage du temps lorsque le Timer est en marche
		 * @param $evt objet évenementiel TimerEvent
		 */
		private function updateTime ($evt:TimerEvent):void {
			_remainingTime = ($evt.target.repeatCount - $evt.target.currentCount) * $evt.target.delay/1000;
			
			// update TextField & the Cooldown Animation here
			_overlayShape.scaleY = ($evt.target.repeatCount - $evt.target.currentCount)/$evt.target.repeatCount;
			_cooldownText.text = String(Math.round(_remainingTime));
		}
		
		/**
		 * Débute l'animation et l'affichage du temps par le biais du Timer
		 */
		public function start ():void {
			_mainTimer.start();
			
			// ajoute l'animation et le temps restant à la liste d'affichage
			this.addChild(_cooldownText);
			this.addChild(_overlayShape);
		}
		
		/**
		 * Arrête l'animation et l'affichage du temps par le biais du Timer
		 */
		public function stop ():void {
			_mainTimer.stop();
		}
		
		/**
		 * Retourne l'animation et le temps restant à leur état d'origine
		 */
		public function reset ():void {
			_mainTimer.reset();
			
			// suprrime le temps restant de la liste d'affichage s'il est présent
			if (_cooldownText.parent !== null) {
				this.removeChild(_cooldownText);
			}
			_cooldownText.text = "";
			
			// suprrime l'animation de la liste d'affichage s'il est présent
			if (_overlayShape.parent !== null) {
				this.removeChild(_overlayShape);
			}
			_overlayShape.scaleY = 1;
		} 
		
		/**
		 * Détermine si une abilité peut être utilisée ou non
		 * @return Boolean true si oui; sinon false
		 */
		public function get onCooldown ():Boolean {
			return _mainTimer.running;
		}
		
	}
	
}
