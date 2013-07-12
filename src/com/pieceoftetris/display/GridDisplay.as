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
	import flash.display.Sprite;
	import flash.geom.Point;

	/**
	 * Classe utilisée pour générer l'apparence de la grille sur laquelle les blocs se déplacent
	 */
	public class GridDisplay extends Sprite {
		/**
		 * La largeur des carrés qui composent la grille
		 */
		protected var _largeur:int;

		/**
		 * La hauteur des carrées qui composent la grille
		 */
		protected var _hauteur:int;

		/**
		 * La couleur principale des carrés qui composent la grille
		 * Un carré sur deux portera la couleur primaire
		 */
		protected var _primaryColor:uint;

		/**
		 * La couleur secondaire des carrés qui composent la grille
		 * Un carré sur deux portera la couleur secondaire
		 */
		protected var _secondaryColor:uint;

		/**
		 * Le nombre de rangées de la grille
		 */
		protected var _rows:uint;

		/**
		 * Le nombre de colonne de la grille
		 */
		protected var _columns:uint;

		/**
		 * La transparence de la couleur de la grille
		 */
		protected var _alpha:Number;

		/**
		 * Les données bitmap qui contiennent les informations des carrés
		 * utilisant la couleur principale (_primaryColor:uint)
		 */
		protected var _gridSquareDataPrimary:BitmapData;

		/**
		 * Les données bitmap qui contiennent les informations des carrés
		 * utilisant la couleur secondaire (_secondaryColor:uint)
		 */
		protected var _gridSquareDataSecondairy:BitmapData;

		/**
		 * Array à deux dimensions contenant des points représentant les positions en x et en y
		 * du point registre de chacun des objets bitmaps placés dans le Array _bitmaps
		 *
		 * Permet de positionner les carrés sur la grille
		 */
		protected var _points:Array;

		/**
		 * Array à deux dimensions contenant les objets bitmaps des carrés qui composent la grille
		 */
		protected var _bitmaps:Array;

		/**
		 * Constructeur
		 *
		 * @param $largeur la largeur des carrés qui composent la grille
		 * @param $hauteur la hauteur des carrés qui composent la grille
		 * @param $primaryColor la couleur principale des carrés qui composent la grille
		 * @param $secondaryColor la couleur secondaire des carrés qui composent la grille
		 * @param $space l'espacement entre les carrés qui composent la grille
		 * @param $row le nombre de rangées de la grille
		 * @param $column le nombre de colonnes de la grille
		 * @param $alpha la transparence de la grille
		 */
		public function GridDisplay ($largeur:int, $hauteur:int, $primaryColor:uint, $secondaryColor:uint, $space:int, $row:uint, $column:uint, $alpha:Number) {
			// Assignation des valeurs des paramètres à leur propriété respective
			_largeur = $largeur;
			_hauteur = $hauteur;
			_primaryColor = $primaryColor;
			_secondaryColor = $secondaryColor;
			_rows = $row;
			_columns = $column;
			_alpha = $alpha;

			// Création des Arrays nécessaires au placement des carrés composant la grille
			_points = new Array();
			_bitmaps = new Array();


			// Création de la deuxième dimension des Arrays pour chaque colonne
			for (var i:int = 0; i < _columns; i++) {
				_points.push(new Array());
				_bitmaps.push(new Array());
			}

			// Création d'un conteneur dans lequel se retrouveront tous les carrés composant la grille
			var gridSquaresContainer:Sprite = new Sprite();
			this.addChild(gridSquaresContainer);

			// Création des données bitmap représentant les deux types de carrés pouvant se retrouver sur la grille
			_gridSquareDataPrimary = new BitmapData(_largeur, _hauteur, true, _primaryColor);
			_gridSquareDataSecondairy = new BitmapData(_largeur, _hauteur, true, _secondaryColor);

			// Initialisation des variables utilisées dans la boucle
			var gridSquare:Bitmap, modColumn:int, row:int;
			var nbCarre:int = _rows * _columns;
			// Boucle qui créé et place les carrés sur la grille (composition de la grille)
			for (i = 0; i < nbCarre; i++) {
				modColumn =  i % _columns;
				row = Math.floor(i/_columns);

				// Un carré sur deux doit être de la couleur principale; l'autre de la couleur secondaire
				if ((modColumn+row)%2 === 1) {
					gridSquare = new Bitmap(_gridSquareDataPrimary);
				} else {
					gridSquare = new Bitmap(_gridSquareDataSecondairy);
				}

				// Positionnement du carré sur la grille
				gridSquare.x = modColumn * (_largeur + $space);
				gridSquare.y = Math.floor(i/_columns) * (_hauteur + $space);
				// Ajout du carré et de la position aux Arrays _points et _bitmaps
				_points[modColumn].push(new Point(gridSquare.x, gridSquare.y));
				_bitmaps[modColumn].push(gridSquare);

				// Ajout du carré sur la liste d'affichage de la grille
				gridSquaresContainer.addChild(gridSquare);
			}

			this.alpha = _alpha;
		}

	}

}
