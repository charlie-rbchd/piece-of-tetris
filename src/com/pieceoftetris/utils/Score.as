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

package com.pieceoftetris.utils {

	/**
	 * Classe statique utilisée pour stocker et récupérer le score lors d'une partie
	 */
	public class Score {
		/**
		 * Le score actuel
		 */
		private static var _score:uint;

		/**
		 * Permet de récuprérer le score actuel
		 * @return uint le score actuel
		 */
		public static function get score():uint {
			return _score;
		}

		/**
		 * Remplace le score actuel par un nouveau score
		 * @param $score le score remplacant l'ancien
		 */
		public static function set score($score:uint):void {
			_score = $score;
		}

		/**
		 * Ajoute une nouvelle valeur au score actuel
		 * @param $value le valeur ajoutée au score
		 */
		public static function addScore($value:uint):void {
			_score += $value;
		}

		public function Score () {

		}

	}

}
