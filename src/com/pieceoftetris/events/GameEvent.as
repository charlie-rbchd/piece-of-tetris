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
