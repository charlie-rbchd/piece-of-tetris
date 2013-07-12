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

	import com.pieceoftetris.events.GameEvent;

	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.utils.Timer;

	/**
	* Classe utiliser pour gérer toutes les méthodes et fonctions associées au gridDisplay
	*/
	public class Grid extends GridDisplay {
		/**
		 * Array cotnenant les blocs qui sont en déscente
		 */
		private var _movingBlocs:Array;

		/**
		 * Array cotnenant la hauteur de chaque colone
		 */
		private var _rowHeight:Array;

		/**
		 * Array cotnenant à deux dimension contenant les bloc placés
		 * les deux dimension servent à représenter la grille
		 * les place de la grille qui ne contiennent pas de bloc sont représenter par null dans le array
		 */
		private var _placedBlocs:Array;

		/**
		 * Array cotnenant les carré de la grille qui change de couleur
		 */
		private var _glitchedSquares:Array;

		/**
		 * L'ombre au bas de la grille
		 */
		private var _shadow:Shadow;

		/**
		 * Permet de gérer le mode démentielle
		 */
		private var _insaneMode:Boolean;

		/**
		 * Permet de gérer le temps entre les changement de couleur dans le mode démentielle
		 */
		private var _insaneTimer:Timer;

		/**
		 * Constructeur
		 *
		 * @param $largeur int définit la largeur des carrés de la grille
		 * @param $hauteur int définit la hauteur des carrés de la grille
		 * @param $primaryColor uint définit la couleur principale de la grille
		 * @param $secondaryColor uint définit la couleur secondaire de la grille
		 * @param $space int définit l'espace entre les carrés de la grille
		 * @param $row int définit le nombre de ligne de la grille
		 * @param $column int définit le nombre de colone de la grille
		 * @param $alpha number définit l'opacité de la grille
		 * @param $insaneMode boolean définit si la grille est en mode démentielle
		 */
		public function Grid ($largeur:int = 20, $hauteur:int = 20, $primaryColor:uint=0xff2f2f2f, $secondaryColor:uint=0xff2b2b2b, $space:int=2, $row:uint=20, $column:uint=10, $alpha:Number=1, $insaneMode:Boolean=false) {
			// initialization des élément de la grille
			_movingBlocs = new Array();
			_placedBlocs = new Array();
			_rowHeight = new Array();
			_glitchedSquares = new Array();
			_insaneTimer = new Timer(1000)

			// appele de la classe parent(GridDisplay) pour la création de l'affichage de la grille
			super($largeur, $hauteur, $primaryColor, $secondaryColor, $space, $row, $column, $alpha);

			// initialization des élément de la grille
			for (var i:int = 0; i < _columns; i++) {
				_placedBlocs.push(new Array());
				_rowHeight.push(_rows);
				_glitchedSquares.push(new Point());

				for (var c:int = 0; c < _rows; c++) {
					_placedBlocs[i].push(undefined);
				}

			}

			// assigne le insane mode à sa propriété
			this.insaneMode = $insaneMode;

			// création de l'ombre de la grille
			_shadow = new Shadow(_largeur, _hauteur)
		}

		/**
		 * Permet de récupérer le array rowHeight
		 *
		 * @return Array contenant les hauteur des colone
		 */
		public function get rowHeight ():Array {
			return _rowHeight;
		}

		/**
		 * Permet de récupérer la hauteur d'une colone en particulier
		 *
		 * @param $column int la colone pour laquelle on veut récupérer la hauteur
		 * @return int la hauteur de la colone demandé
		 */
		public function getRowHeight ($column:int):int {
			return _rowHeight[$column - 1];
		}

		/**
		 * Permet de récupérer la largeur des carrés de la grille
		 *
		 * @return int la largeur des carré de la grille
		 */
		public function get largeur():int {
			return _largeur;
		}

		/**
		 * Permet de récupérer la hauteur des carrés de la grille
		 *
		 * @return int la hauteur des carré de la grille
		 */
		public function get hauteur():int {
			return _hauteur;
		}

		/**
		 * Permet de récupérer la couleur principale des carrés de la grille
		 *
		 * @return uint la couleur principale des carré de la grille
		 */
		public function get primaryColor():uint{
			return _primaryColor;
		}

		/**
		 * Permet de récupérer la couleur secondaire des carrés de la grille
		 *
		 * @return uint la couleur psecondaire des carré de la grille
		 */
		public function get secondairyColor():uint{
			return _secondaryColor;
		}

		/**
		 * Permet de récupérer l'opacité de la grille
		 *
		 * @return number l'opacité de la grille
		 */
		public function get baseAlpha():Number {
			return _alpha;
		}

		/**
		 * Permet de récupérer la quantité de lignes de la grille
		 *
		 * @return int le nombre de lignes de la grille
		 */
		public function get nbRows ():int {
			return _rows;
		}

		/**
		 * Permet de récupérer la quantité de colones de la grille
		 *
		 * @return int le nombre de colones de la grille
		 */
		public function get nbColumns ():int {
			return _columns;
		}

		/**
		 * Permet de récupérer les coordonées d'un des carré de la grille
		 *
		 * @param $column int la colone pour laquelle on veut récupérer la coordonée
		 * @param $row int la ligne pour laquelle on veut récupérer la coordonée
		 * @return Point les coordonées du carré de la grille
		 */
		public function getCoordinatesAt($column:int, $row:int):Point {
			return _points[$column - 1][$row - 1];
		}

		/**
		 * Permet d'ajouté un bloc au array _placedBlocs
		 *
		 * @param $bloc Bloc le bloc qui doit être ajouté
		 */
		public function addPlacedBloc($bloc:Bloc):void {
			_placedBlocs[$bloc.column - 1][$bloc.row - 1] = $bloc;
		}

		/**
		 * Permet d'ajouté un bloc au array _movingBlocs
		 *
		 * @param $bloc Bloc le bloc qui doit être ajouté
		 */
		public function addMovingBloc($bloc:Bloc):void{
			_movingBlocs.push($bloc);
			_movingBlocs[0].status = Bloc.STATUS_ACTIVE;
			// réaffiche l'ombre au premier bloc
			addShadow(_movingBlocs[0]);
		}

		/**
		 * Permet de récupérer le array _placedBloc
		 *
		 * @return Array le array _placedBloc
		 */
		public function get placedBlocs():Array {
			return _placedBlocs;
		}

		/**
		 * Permet de récupérer le array _movingBlocs
		 *
		 * @return Array le array _movingBlocs
		 */
		public function get movingBlocs():Array {
			return _movingBlocs;
		}

		/**
		 * Fait tombé les bloc lorsqu'une ligne est completée
		 *
		 * @param $column int la colone dans laquelle on veut faire tombé les blocs
		 * @param $line int la ligne dans laquelle on veut faire tombé les blocs
		 */
		public function applyFalldownFrom ($column:int, $line:int):void {
			var i:int, c:int;
			// retire l'index à la position, dans le array _placedBloc, en fonction des paramètre spécifier
			_placedBlocs[$column - 1].splice($line-1, 1)
			// pousse un nouvel élément null au début du array
			_placedBlocs[$column - 1].unshift(null);

			// repositionne les blocs en fonction de leurs nouvel position dans le array _placedBloc
			for(c =0; c < nbRows; c++){
				if(_placedBlocs[$column - 1][c] != null){
					_placedBlocs[$column - 1][c].row = c+1;
				}
			}

		}

		/**
		 * Fait disparaître un bloc placé
		 *
		 * @param $column int la colone à laquelle on veut retiré le bloc
		 * @param $line int la ligne à laquelle on veut retiré le bloc
		 */
		public function removePlacedBloc ($column:int, $line:int):void {
			// retire le bloc et le met à null
			this.removeChild(_placedBlocs[$column - 1][$line - 1]);
			_placedBlocs[$column - 1][$line - 1] = null;

			// fait tombé les blocs
			applyFalldownFrom($column, $line);

		}

		/**
		 * Retire la ligne demandé
		 *
		 * @param $line int la ligne qui doit être retirer
		 */
		public function removeLine ($line:int):void {
			var i:int, c:int, nbColumns:int = _placedBlocs.length;

			for (i = 0; i < nbColumns; i++) {
				// retre le bloc de chaque colone à la ligne spécifier
				removePlacedBloc(i + 1, $line);
				// réajuste la hauteur des colone
				_rowHeight[i]++;
			}

		}

		/**
		 * Retire le bloc du array _movingBloc
		 *
		 * @param $index int l'index du bloc qui doit être retiré
		 */
		public function removeMovingBloc($index:int):void {
			// retire le bloc
			_movingBlocs.splice($index, 1);

			// s'il reste des bloc
			if (_movingBlocs.length >= 1) {
				// activer le premier
				_movingBlocs[0].status = Bloc.STATUS_ACTIVE;
				addShadow(_movingBlocs[0]);
			}
		}

		/**
		 * Permet de récupérer le array _points
		 *
		 * @return Array le array _points
		 */
		public function get points():Array {
			return _points;
		}

		/**
		 * Fait descendre les blocs dans le array _movingBlocs
		 */
		public function makeBlocsMove():void {
			for (var i:int = 0; i < _movingBlocs.length; i++) {

				// si le bloc n'est pas à la hauteur pour causer une colision
				if (_movingBlocs[i].row < _rowHeight[_movingBlocs[i].column - 1]) {
					// il descent
					_movingBlocs[i].row++;

				// sinon
				} else {
					// le bloc devient actif
					_movingBlocs[i].status = Bloc.STATUS_ACTIVE;
					// la hauteur des lignes est ajuster
					_rowHeight[_movingBlocs[i].column - 1]--;
					// le bloc est placé dans le array _placedBlocs et est retiré de _movingBloc
					addPlacedBloc(_movingBlocs[i]);
					removeMovingBloc(i);

					// s'il reste des bloc qui dans _movingBloc le premier devient actif
					if (_movingBlocs.length >= 1) {
						if(_movingBlocs[i] != null){
							_movingBlocs[i].status = Bloc.STATUS_ACTIVE;
						}
						addShadow(_movingBlocs[0]);
					}

					//pour ne pas sauter de bloc pusiqu'il se font retirer
					i--;
				}

			}

		}

		/**
		 * Change la couleur de la grid à la colone et à la row spécifié
		 *
		 * @param $column int la colone à laquelle changer la couleur
		 * @param $row int la row à laquelle changer la couleur
		 * @param $primaryColor uint la nouvelle couleur princial de la grille
		 * @param $secondaryColor uint la nouvelle couleur secondaire de la grille
		 * @param $alpha number la nouvelle opacité de la grille
		 */
		public function changeColor ($column:int, $row:int, $primaryColor:uint, $secondaryColor:uint, $alpha:Number=-1):void {
			var ctPrimary:ColorTransform, ctSecondairy:ColorTransform, modColumn:int, i:int, k:int;

			if ($alpha === -1)
				$alpha = _alpha; // Assigne la valeur de base de l'alpha

			// Vérification des intervals minimum/maximum
			$row = Math.max(0, Math.min(_rows, $row));
			$column = Math.max(0, Math.min(_columns, $column));

			ctPrimary = new ColorTransform();
			ctPrimary.color = $primaryColor;

			ctSecondairy = new ColorTransform();
			ctSecondairy.color = $secondaryColor;

			if ($row === 0) {
				if ($column === 0)
				{
					// change the color of the whole grid
					_alpha = $alpha;
					_primaryColor = $primaryColor;
					_secondaryColor = $secondaryColor;

					for (i = 0; i < _bitmaps.length; i++) {
						for (k = 0; k < _bitmaps[i].length; k++) {
							if (((k%_columns)+i)%2 === 1) {
								_bitmaps[i][k].transform.colorTransform = ctPrimary;
							} else {
								_bitmaps[i][k].transform.colorTransform = ctSecondairy;
							}

							_bitmaps[i][k].alpha = _alpha;
						}
					}

					return;
				}
				else
				{ // ($column !== 0)
					// change the color of the column
					for (i = 0; i < _bitmaps[$column - 1].length; i++) {

						if (($column+i)%2 == 1) {
							_bitmaps[$column - 1][i].transform.colorTransform = ctPrimary;
						} else {
							_bitmaps[$column - 1][i].transform.colorTransform = ctSecondairy;
						}

						_bitmaps[$column - 1][i].alpha = $alpha;
					}

					return;
				}
			} else { // ($row !== 0)
				if ($column === 0)
				{
					// change the color of the row
					for (i = 0; i < _bitmaps.length; i++) {

						modColumn =  i % _columns

						if ((modColumn+$row)%2 === 1 ){
							_bitmaps[i][$row - 1].transform.colorTransform = ctPrimary;
						} else {
							_bitmaps[i][$row - 1].transform.colorTransform = ctSecondairy;
						}

						_bitmaps[i][$row - 1].alpha = $alpha;
					}

					return;
				}
				else
				{ // ($column !== 0)
					// change the color of a single bloc

					if (($column+$row)%2 == 0) {
						_bitmaps[$column - 1][$row - 1].transform.colorTransform = ctPrimary;
					} else {
						_bitmaps[$column - 1][$row - 1].transform.colorTransform = ctSecondairy;
					}
					//_bitmaps[$column - 1][$row - 1].transform.colorTransform = ctPrimary;
					_bitmaps[$column - 1][$row - 1].alpha = $alpha;
				}

			}

		}

		/**
		 * Vérifie si une ligne est complété
		 */
		public function checkLines ():void{
			var red:Boolean, green:Boolean, blue:Boolean;

			// vérifie chaque ligne séparément
			for (var i:int = 0; i < _rows; i++) {
				red = green = blue = true;

				// passe au travers de chaque colone de la row
				for (var c:int = 0; c < _columns; c++) {
					// si un des bloc est différent le boolean correspondant est à null
					if (_placedBlocs[c][i] != null) {
						switch (_placedBlocs[c][i].color) {
							case Bloc.COLOR_RED :
								green = blue = false;
								break;
							case Bloc.COLOR_GREEN :
								red = blue = false;
								break;
							case Bloc.COLOR_BLUE :
								red = green = false;
								break;
							case Bloc.COLOR_CYAN :
								red = false;
								break;
							case Bloc.COLOR_MAGENTA :
								green = false;
								break;
							case Bloc.COLOR_YELLOW :
								blue = false;
								break;
						}
					// si le bloc est à null les booleans tombe à false
					} else {
						red = green = blue = false;
					}

				}

				// si une des boolean est a true, une ligne c'est complèter
				if (red === true || green === true || blue === true) {
					// dispatch l'événement LINE_COMPLETED
					this.dispatchEvent(new GameEvent(GameEvent.LINE_COMPLETED, i+1));
				}

			}

		}

		/**
		 * Vérifie si une des ligne à atteint le haut de l'écran
		 */
		public function checkGameOver():void{
			for (var i:int = 0; i< _rowHeight.length;i++) {
				if (_rowHeight[i] <= 0) {
					// dispatch l'évenement game over
					this.dispatchEvent(new GameEvent(GameEvent.GAME_OVER, 0));
				}
			}

		}

		/**
		 * ajoute l'ombre
		 *
		 * @param $bloc Bloc le bloc auquelle on doit ajouté l'ombre
		 */
		public function addShadow ($bloc:Bloc):void {
			var coord:Point = _points[$bloc.column - 1][_rowHeight[$bloc.column - 1] - 1];
			_shadow.x = coord.x;
			_shadow.y = coord.y;
			this.addChildAt(_shadow, 1)
		}

		/**
		 * retire l'ombre
		 */
		public function removeShadow ():void {
			//si l'ombre est afficher
			if(_shadow.parent != null){
				this.removeChild(_shadow);
			}
		}

		/**
		 * active/désactive le mode démentielle
		 *
		 * @param $insane Boolean boolean déterminant si le mode démentielle doit être activé ou désactivé
		 */
		public function set insaneMode($insane:Boolean):void{
			_insaneMode = $insane;
			// active le mode
			if (_insaneMode) {
				_insaneTimer.addEventListener(TimerEvent.TIMER, randomGridGlitches);
				_insaneTimer.start();
			// désactive
			} else {
				if (_insaneTimer.hasEventListener(TimerEvent.TIMER)) {
					changeColor(0, 0, _primaryColor, _secondaryColor);
					_insaneTimer.removeEventListener(TimerEvent.TIMER, randomGridGlitches);
					_insaneTimer.stop();
				}
			}
		}

		/**
		 * change les couleur de la grille au hasard
		 *
		 * @param $evt objet événementiel capté lors du TimerEvent.TIMER
		 */
		public function randomGridGlitches ($evt:TimerEvent):void {
			for(var i:int = 0; i < _glitchedSquares.length; i++){

				// réinitialize les couleur de la grid si des bloc avait été changé
				if(_glitchedSquares[i].x != 0 || _glitchedSquares[i].y != 0 ){
					changeColor(_glitchedSquares[i].x, _glitchedSquares[i].y, _primaryColor, _secondaryColor);
				}

				// chage la couleur de bloc au hasard
				_glitchedSquares[i].x = Math.floor(Math.random()*_columns)+1;
				_glitchedSquares[i].y = Math.floor(Math.random()*_rows)+1;

				changeColor(_glitchedSquares[i].x, _glitchedSquares[i].y, Bloc.randomColor()["base"], Bloc.randomColor()["shadow"]);
			}
		}

		/**
		 * Fonction pour gérér la mémoire
		 * Met tout les élément de la grid à null
		 */
		public function cleanGrid():void{
			this.insaneMode = false;

			for(var i:int = 0; i < _movingBlocs.length; i++){
				_movingBlocs[i] = null;
			}
			_movingBlocs = null;


			for(i = 0; i < _placedBlocs.length; i++){
				for(var c:int = 0; c < _placedBlocs[i].length;c++){
					_placedBlocs[i][c] = null;
				}
				_placedBlocs[i] = null;
			}
			_placedBlocs = null;


			for(i = 0; i < _glitchedSquares.length; i++){
				_glitchedSquares[i] = null;
			}
			_glitchedSquares = null;


			for(i = 0; i < _points.length; i++){
				for(c = 0; c < _points[i].length;c++){
					_points[i][c] = null;
					_bitmaps[i][c] = null;
				}
				_points[i] = null;
				_bitmaps[i] = null;
			}
			_points = null;
			_bitmaps = null;


			_gridSquareDataPrimary = null;
			_gridSquareDataSecondairy = null;

			_insaneTimer = null;


			_shadow = null;

			this.parent.removeChild(this);
		}

	}

}

