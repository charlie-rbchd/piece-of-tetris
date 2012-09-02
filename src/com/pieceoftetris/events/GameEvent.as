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
	
	public class GameEvent extends Event {
		/**
		 * Constatnte définissant le type d'événement qui est déclenché lorsque la partie est terminée
		 */
		public static const GAME_OVER:String = "gameOver";
		
		/**
		 * Constatnte définissant le type d'événement qui est déclenché lorsqu'une ligne est complétée
		 */
		public static const LINE_COMPLETED:String = "lineCompleted";
		
		/**
		 * Constatnte définissant le type d'événement qui est déclenché lorsqu'un retour au menu principal est demandé
		 */
		public static const RETURN_TO_MAIN_MENU:String = "returnToMainMenu";
		
		/**
		 * La ligne de la grille à laquelle l'événement s'est produit (pour l'événement de type LINE_COMPLETED)
		 */
		private var _whichLine:uint;
		
		/**
		 * Constructeur
		 *
		 * @param $type le type de l'événement
		 * @param $line la ligne à laquelle l'événement s'est produit
		 * @param $bubbles définie si l'événement a une phase de remontée
		 * @param $cancelable définie si l'événement est cancelable
		 */
		public function GameEvent($type:String, $line:uint=0, $bubbles:Boolean=false, $cancelable:Boolean=false) {
			// Assignation des valeurs des paramètres à leur propriété respective
			_whichLine = $line;
			// Appel de la classe mère
			super($type, $bubbles, $cancelable);
		}
		
		/**
		 * @return uint la ligne à laquelle l'événement s'est produit
		 */
		public function get line ():uint {
			return _whichLine;
		}
		
		/**
		 * @return Event un copie de l'événement distribué
		 */
		public override function clone ():Event {
			return new GameEvent(type, _whichLine, bubbles, cancelable);
		}
		
		/**
		 * @return String une chaîne représentant l'événement distribué
		 */
		public override function toString ():String {
			return formatToString("PotEvent", "type", "bubbles", "cancelable", "eventPhase");
		}
		
	}
	
}
