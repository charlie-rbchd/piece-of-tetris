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
