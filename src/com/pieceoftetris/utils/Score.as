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
