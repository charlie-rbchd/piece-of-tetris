/*
 * Piece of Tetris
 * Copyright (C) 2010  Joel Robichaud & Maxime St-Louis-Fortier
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
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
