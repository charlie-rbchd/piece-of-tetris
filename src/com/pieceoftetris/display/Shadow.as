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

package com.pieceoftetris.display {

	import flash.display.Bitmap;
	import flash.display.BitmapData;

	/**
	 * Classe utilisée pour faire apparaître l'ombre du bloc actif
	 */
	public class Shadow extends Bitmap {
		/**
		 * Constructeur
		 *
		 * @param $width la largeur de l'ombre
		 * @param $height la hauteur de l'ombre
		 */
		public function Shadow($width:int, $height:int) {
			var bitmapData:BitmapData = new BitmapData($width, $height, false, 0xaaaaaa);
			var nbPixel:int = $width * $height;
			var column:int, row:int, i:int;

			 // Création de l'apparence de l'ombre dans un bitmapData
			for(i = 0; i < nbPixel; i++){
				column = i % $width
				row = Math.floor(i/$width);

				// Le carré est rayé de façon diagonale
				if ((column >= 2 && column < ($width - 2)) && (row >= 2 && row < ($height - 2))) {
					if ((column+row) % 4 === 1 || (column + row) % 4 === 2) {
						bitmapData.setPixel(column, row, 0x222222);
					 } else {
						bitmapData.setPixel(column, row, 0x777777);
					}

				}

			}

			// Appel de la classe mère
			super(bitmapData);
		}

	}

}
