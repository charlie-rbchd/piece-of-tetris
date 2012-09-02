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

package com.pieceoftetris.events {
	
	import flash.events.Event;
	
	/**
	 * Classe événementielle servant à redistribuer un KeyboardEvent de façon plus contrôlée,
	 * principalement à l'aide de Timers et ce, afin de contrôler plus précisement les répétitions des KeyboardEvent
	 */
	public class SmoothKeyboardEvent extends Event {
		/**
		 * Constatnte définissant le type d'événement qui est déclenché lorsqu'une touche est enfoncée
		 */
		public static const KEY_DOWN:String = "keyDown";
		
		/**
		 * Constante définissant le type d'événement qui est déclenché lorsqu'une touche est relâchée
		 */
		public static const KEY_UP:String = "keyUp";
		
		/**
		 * L'indice numérique représentant la touche appuyée ou relâchée par l'utilisateur
		 */
		private var _keyCode:uint;
		
		/**
		 * Constructeur
		 *
		 * @param $type le type de l'événement
		 * @param $keyCode l'indice numérique représentant la touche appuyée ou relâchée par l'utilisateur
		 * @param $bubbles définie si l'événement a une phase de remontée
		 * @param $cancelable définie si l'événement est cancelable
		 */
		public function SmoothKeyboardEvent ($type:String, $keyCode:uint, $bubbles:Boolean=false, $cancelable:Boolean=false) {
			// Assignation des valeurs des paramètres à leur propriété respective
			_keyCode = $keyCode;
			// Appel de la classe mère
			super($type, $bubbles, $cancelable);
		}
		
		/**
		 * @return uint l'indice numérique représentant la touche appuyée ou relâchée par l'utilisateur
		 */
		public function get keyCode ():uint {
			return _keyCode;
		}
		
		/**
		 * @return Event un copie de l'événement distribué
		 */
		public override function clone():Event {
			return new SmoothKeyboardEvent(type, _keyCode, bubbles, cancelable);
		}
		
		/**
		 * @return String une chaîne représentant l'événement distribué
		 */
		public override function toString():String {
			return formatToString("SmoothKeyboardEvent", "type", "bubbles", "cancelable", "eventPhase");
		}
		
	}
	
}
