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

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.BevelFilter;
	import flash.geom.Point;

	/**
	* Classe utiliser pour représenter les éléments blocs
	*/
	public class Bloc extends Sprite {

		/**
		 * Objet pour gérer les couleur de secondaire des blocs
		 */
		public static const COLOR_CYAN:Object = { "base":0x2cd1ff, "highlight":0x44e1ff, "shadow":0x32befa };
		public static const COLOR_MAGENTA:Object = { "base":0xe84cc9, "highlight":0xf65ddc, "shadow":0xd24cad };
		public static const COLOR_YELLOW:Object = { "base":0xffd93b, "highlight":0xffea4c, "shadow":0xffc225 };

		/**
		 * Objet pour gérer les couleur de base des blocs
		 */
		public static const COLOR_RED:Object = { "base":0xff435c, "highlight":0xff7194, "shadow":0xfa325a };
		public static const COLOR_GREEN:Object = { "base":0x86ea33, "highlight":0xa7fa3b, "shadow":0x7cd424 };
		public static const COLOR_BLUE:Object = { "base":0x447cff, "highlight":0x549aff, "shadow":0x446e9 };

		/**
		 * String pour changer les status des blocs
		 */
		public static const STATUS_ACTIVE:String = "active";
		public static const STATUS_INACTIVE:String = "inactive";

		/**
		 * Couleur du bloc
		 */
		private var _color:Object;

		/**
		 * determine la colone du bloc
		 */
		private var _column:int;

		/**
		 * détermine la ligne du bloc
		 */
		private var _row:int;

		/**
		 * le bevel des bloc
		 */
		private var _bevel:BevelFilter;

		/**
		 * savoir si le bloc est à une couleur de base
		 */
		private var _blendable:Boolean;

		/**
		 * la grid sur laquelle le bloc se retrouve
		 */
		private var _grid:Grid;

		/**
		 * la largeur du bloc
		 */
		private var _largeur:int;

		/**
		 * la hauteur du bloc
		 */
		private var _hauteur:int;

		/**
		 * le status du bloc
		 */
		private var _status:String;

		/**
		 * le voile pour le status inactif
		 */
		private var _veil:Shape;

		/**
		 * Constructeur
		 *
		 * @param $column int la colone dans laquelle le bloc se trouve
		 * @param $row int la ligne à laquelle le bloc se trouve
		 * @param $color Object la couleur du bloc
		 * @param $grid Grid la sur laquelle le bloc se trouve
		 */
		public function Bloc($column:int, $row:int, $color:Object, $grid:Grid) {
			// Assignation des valeurs des paramètres à leur propriété respective
			_blendable = true;
			_column = $column;
			_row = $row;
			_grid = $grid;
			_status = Bloc.STATUS_INACTIVE;
			_largeur = _grid.largeur;
			_hauteur = _grid.hauteur;

			// création du voile
			_veil = new Shape();
			_veil.graphics.beginFill(0xFFFFFF);
			_veil.graphics.drawRect(0, 0, _largeur - 1, _hauteur - 1);
			_veil.graphics.endFill();
			_veil.alpha = 0.7;
			this.addChild(_veil);

			// positionnement du bloc à ses position d'origine
			var coords:Point = _grid.getCoordinatesAt(_column, _row);
			this.x = coords.x;
			this.y = coords.y;

			// application de la couleur
			this.color = $color;
		}

		/**
		 * Permet de récupérer la grille
		 *
		 * @return Grid la grille sur laquelle le bloc se trouve
		 */
		public function get grid():Grid{
			return _grid;
		}

		/**
		 * Change la couleur du bloc
		 *
		 * @param $color Object la nouvel couleur du bloc
		 */
		public function set color($color:Object):void {
			_color = $color;
			_bevel = new BevelFilter(1, 123, _color.highlight, 1, _color.shadow, 0.6, 1, 1, 255);

			// redessine le bloc
			this.graphics.clear();

			this.graphics.lineStyle(1, 0x000000);
			this.graphics.beginFill(_color.base);
			this.graphics.drawRect(0, 0, _largeur - 1, _hauteur - 1);
			this.graphics.endFill();

			this.graphics.lineStyle(2, _color.highlight);
			this.graphics.beginFill(_color.shadow);
			this.graphics.drawRect(_largeur/4, _hauteur/4, _largeur - _largeur*0.5, _hauteur - _hauteur*0.5);
			this.graphics.endFill();

			// réassigne le filtre
			this.filters = [_bevel];
		}

		/**
		 * Permet de récupérer la couleur
		 *
		 * @return Object la couleur du bloc
		 */
		public function get color():Object{
			return _color;
		}

		/**
		 * Permet de récupérer une couleur au hasard
		 *
		 * @return Object une des couleur de bloc possible
		 */
		public static function randomColor():Object {
			var color:Object;
			var rand:int = Math.floor(Math.random()*3)+1;

			switch(rand){
				case 1:
					color = Bloc.COLOR_RED;
					break;
				case 2:
					color = Bloc.COLOR_GREEN;
					break;
				case 3:
					color = Bloc.COLOR_BLUE;
			}

			return color;
		}

		/**
		 * Permet de changer le status du bloc actif/innactif
		 */
		public function toggleStatus ():void {
			if (_status == Bloc.STATUS_ACTIVE) {
				// change le style en conséquence
				_status = Bloc.STATUS_INACTIVE;
			} else if (_status == Bloc.STATUS_INACTIVE) {
				// change le style en conséquence
				_status = Bloc.STATUS_ACTIVE;
			}
		}

		/**
		 * Permet de récupérer le status du bloc
		 *
		 * @return String le status(actif/innactif)
		 */
		public function get status ():String {
			return _status;
		}

		/**
		 * Permet de changer le status du bloc
		 *
		 * @param String le status(actif/innactif)
		 */
		public function set status ($status:String):void {
			switch ($status) {
				case Bloc.STATUS_ACTIVE:
					// change le style en conséquence
					if(this.contains(_veil)){
						this.removeChild(_veil)
					}
					_status = $status;
					break;
				case Bloc.STATUS_INACTIVE:
					// change le style en conséquence
					this.addChild(_veil)
					_status = $status;
					break;
			}
		}

		/**
		 * Permet de récupérer la colone dans laquelle le bloc se trouve
		 *
		 * @return int la colone
		 */
		public function get column ():int {
			return _column;
		}

		/**
		 * Permet de changer la colone dans laquelle le bloc se trouve
		 *
		 * @param int la colone
		 */
		public function set column ($column:int):void {
			$column = Math.max(1, Math.min(_grid.nbColumns, $column));
			_column = $column;
			this.x = _grid.getCoordinatesAt(_column, _row).x;
		}

		/**
		 * Permet de récupérer la ligne dans laquelle le bloc se trouve
		 *
		 * @return int la ligne
		 */
		public function get row ():int {
			return _row;
		}

		/**
		 * Permet de changer la ligne dans laquelle le bloc se trouve
		 *
		 * @param int la ligne
		 */
		public function set row ($row:int):void {
			$row = Math.max(1, Math.min(_grid.nbRows, $row));
			_row = $row;
			this.y = _grid.getCoordinatesAt(_column, _row).y;
		}

		/**
		 * Permet de savoir si le bloc est d'une des couleur de base
		 *
		 * @return Boolean si le bloc est d'un couleur de base
		 */
		public function get isBlendable ():Boolean {
			return _blendable;
		}

		/**
		 * Permet de changer la valeur de isBlendable
		 *
		 * @param Boolean True si le bloc est d'une couleur de base
		 */
		public function set isBlendable ($value:Boolean):void {
			_blendable = $value;
		}

		/**
		 * Permet de changer la couleur des blocs autour du bloc en fonction de la couleur de ce-dernier
		 *
		 * @param Bloc le bloc duquelle la fusion se fait
		 */
		public static function blendColorsFrom ($bloc:Bloc):void {
			var grid:Grid = $bloc.grid;

			for (var i:int = Math.max(0, $bloc.column - 2); i < Math.min($bloc.column - 2 + 3, grid.nbColumns); i++) {

				for (var c:int = Math.max(0, $bloc.row - 2); c < Math.min($bloc.row - 2 + 3,  grid.nbRows); c++) {
					// si le bloc les bloc autour sont non-null, de couleur différente, et fusionnable (regarder un par un)
					if (grid.placedBlocs[i][c] != null
						&& grid.placedBlocs[i][c].isBlendable == true
						&& (i != $bloc.column-1 || c != $bloc.row - 1)
						&& grid.placedBlocs[i][c].color != $bloc.color)
					{
						// vérifie la couleur et change les couleur en fonction des couleurs présente
						switch (grid.placedBlocs[i][c].color) {
							case Bloc.COLOR_RED:
								switch ($bloc.color) {
									case Bloc.COLOR_GREEN: // rouge et vert = jaune
										grid.placedBlocs[i][c].color = Bloc.COLOR_YELLOW;
										break;
									case Bloc.COLOR_BLUE: // rouge et bleu = magenta
										grid.placedBlocs[i][c].color = Bloc.COLOR_MAGENTA;
										break;
								}
								break;
							case Bloc.COLOR_GREEN:
								switch ($bloc.color) {
									case Bloc.COLOR_RED: // vert et rouge = jaune
										grid.placedBlocs[i][c].color = Bloc.COLOR_YELLOW;
										break;
									case Bloc.COLOR_BLUE: // vert et bleu = cyan
										grid.placedBlocs[i][c].color = Bloc.COLOR_CYAN;
										break;
								}
								break;
							case Bloc.COLOR_BLUE:
								switch ($bloc.color) {
									case Bloc.COLOR_RED: // bleu et rouge = magenta
										grid.placedBlocs[i][c].color = Bloc.COLOR_MAGENTA;
										break;
									case Bloc.COLOR_GREEN: // bleu et vert = cyan
										grid.placedBlocs[i][c].color = Bloc.COLOR_CYAN;
										break;
								}
								break;
						}
						// rend le bloc non-fusionnable
						grid.placedBlocs[i][c].isBlendable = false;
					}

				}

			}

		}


		/**
		 * Permet de changer la couleur des blocs autour du bloc en fonction de la couleur de ce-dernier
		 *
		 * @param Bloc le bloc duquelle le changement se fait
		 */
		public static function replaceColorsFrom ($bloc:Bloc):void {
			var grid:Grid = $bloc.grid;

			for (var i:int = Math.max(0, $bloc.column - 2); i < Math.min($bloc.column - 2 + 3, grid.nbColumns); i++) {

				for (var c:int = Math.max(0, $bloc.row - 2); c < Math.min($bloc.row - 2 + 3,  grid.nbRows); c++) {

					// si le bloc est non-null
					if (grid.placedBlocs[i][c] != null
						&& (i != $bloc.column-1 || c != $bloc.row - 1)
						&& grid.placedBlocs[i][c].color != $bloc.color)
					{
						// change les couleurs
						grid.placedBlocs[i][c].color = $bloc.color;
						// rend les bloc fusionnable
						grid.placedBlocs[i][c].isBlendable = true;
					}

				}

			}

		}

	}

}
