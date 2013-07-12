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

package com.pieceoftetris.main {

	import com.pieceoftetris.display.Bloc;
	import com.pieceoftetris.display.Grid;
	import com.pieceoftetris.events.GameEvent;
	import com.pieceoftetris.events.SmoothKeyboardEvent;
	import com.pieceoftetris.ui.Bouton;
	import com.pieceoftetris.ui.Helper;
	import com.pieceoftetris.ui.Menu;
	import com.pieceoftetris.utils.Cooldown;
	import com.pieceoftetris.utils.KeyboardController;
	import com.pieceoftetris.utils.Score;

	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;

	public class Game extends EventDispatcher {

		/**
		 * Constante pur gérer la difficulté
		 */
		public static const DIFFICULTY_EASY:int = 3;
		public static const DIFFICULTY_MEDIUM:int = 2;
		public static const DIFFICULTY_HARD:int = 1;


		/**
		 * le stage
		 */
		private static var _stage:Stage;

		/**
		 * L'instance de la classe
		 */
		private static var _instance:Game = new Game();

		/**
		 * Crée le KeysController
		 */
		private var _key:KeyboardController = KeyboardController.instance;

		/**
		 * Crée le helper
		 */
		private var _helper:Helper = Helper.instance;

		/**
		 * La grid gérer par Game
		 */
		private var _grid:Grid;


		/**
		 * la difficulté
		 */
		private var _difficulty:int;

		/**
		 * le temps de raffraichissement
		 */
		private var _refreshRate:Number;

		/**
		 * l'intervalle d'apparition des blocs
		 */
		private var _spawnRate:Number;

		/**
		 * Le nombre de lignes completé
		 */
		private var _linesCompleted:int;


		/**
		 * Le timer gérant l'apparition des blocs
		 */
		private var _spawnTimer:Timer;

		/**
		 * le timer qui gère le temps de jeu
		 */
		private var _gameTimer:Timer;

		/**
		 * le timer qui gere le temps de raffraîchissement
		 */
		private var _refreshTimer:Timer;


		/**
		 * zone de texte pour le temps de jeu
		 */
		private var _gameTimerText:TextField;

		/**
		 * zone de texte pour le nombre de ligne complété
		 */
		private var _linesCompletedText:TextField;

		/**
		 * zone de texte pour le score
		 */
		private var _currentScoreText:TextField;

		/**
		 * zone de texte pour le message de gameOver
		 */
		private var _endMessageText:TextField;

		/**
		 * format de text pour les zone de texte
		 */
		private var _textFormat:TextFormat;


		/**
		 * Shape noir pour recouvrir le stage
		 */
		private var _blackOverlay:Shape;

		/**
		 * le menu secondaire
		 */
		private var _secondaryMenu:Menu;

		/**
		 * le temps de rafraichissement pour l'abilité Merge
		 */
		private var _mergeCooldown:Cooldown;

		/**
		 * le temps de rafraichissement pour l'abilité blend
		 */
		private var _blendCooldown:Cooldown;

		/**
		 * Les balises embed nécessaires à l'affichage des Cooldown des abilités
		 */
		[Embed(source="../assets/QSpecialAbility.jpg")]
		private var QSpecialAbility:Class;

		[Embed(source="../assets/WSpecialAbility.jpg")]
		private var WSpecialAbility:Class;

		/**
		 * Constructeur Singleton
		 */
		public function Game() {
			if (_instance) {
				throw new Error("Game can only be accessed from the static property Game.instance");
			}
		}

		/**
		 * Permet de récupérer le Singleton
		 *
		 * @return Helper l'instance de la classe
		 */
		public static function get instance ():Game {
			return _instance;
		}

		/**
		 * Assigne une référence au stage
		 *
		 * @param $stage rérence au stage
		 */
		public function set stage ($stage:Stage):void {
			_stage = $stage;
		}

		/**
		 * Récupère la référence au stage
		 *
		 * @return Stage référence au stage
		 */
		public function get stage ():Stage {
			return _stage;
		}

		/**
		 * Permet de récupérer la grille
		 *
		 * @param $stage Stage le stage
		 * @param $difficulty int la difficulté
		 * @param $grid Grid la grille géré par Game
		 * @param $insaneMode Boolean gère si le jeu est au mode démentielle
		 */
		public function startGame ($stage:Stage, $difficulty:int, $grid:Grid, $insaneMode:Boolean):void {
			// Assignation des valeurs des paramètres à leur propriété respective
			this.stage = $stage;
			_key.initialize(stage, true, 200, 50);
			_grid = $grid;
			_difficulty = $difficulty;
			_grid.insaneMode = $insaneMode;
			_refreshRate = 200;
			_spawnRate = 1000 * _difficulty;
			_linesCompleted = 0;
			Score.score = 0;

			// création du voile noir
			_blackOverlay = new Shape();
			_blackOverlay.graphics.beginFill(0x000000);
			_blackOverlay.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			_blackOverlay.graphics.endFill();
			_blackOverlay.alpha = 0.7;

			// création des différent timer
			_refreshTimer = new Timer(_refreshRate);
			_refreshTimer.addEventListener(TimerEvent.TIMER, refreshGameStatus);
			_refreshTimer.start();

			_spawnTimer = new Timer(_spawnRate);
			_spawnTimer.addEventListener(TimerEvent.TIMER, spawnBloc);
			_spawnTimer.start();

			_gameTimer = new Timer(1000);
			_gameTimer.addEventListener(TimerEvent.TIMER, updateTime);
			_gameTimer.start();

			//création des temps de raffraîchissement
			_mergeCooldown = new Cooldown(7, new WSpecialAbility() as Bitmap);
			_blendCooldown = new Cooldown(3, new QSpecialAbility() as Bitmap);
			_mergeCooldown.y = _blendCooldown.y = _grid.y + _grid.height - 197;
			_blendCooldown.x = _grid.x + _grid.width + 26;
			_mergeCooldown.x = _blendCooldown.x + 85;

			// création des élément pour le texte
			_textFormat = new TextFormat();
			_textFormat.align = TextFormatAlign.CENTER;
			_textFormat.size = 24;
			_textFormat.color = 0xFFFFFF;
			_gameTimerText = new TextField();
			_linesCompletedText = new TextField();
			_currentScoreText = new TextField();
			_endMessageText = new TextField();

			// assigniation de propriété des zone de texte
			_endMessageText.defaultTextFormat = _gameTimerText.defaultTextFormat = _linesCompletedText.defaultTextFormat = _currentScoreText.defaultTextFormat = _textFormat;
			_endMessageText.selectable = _gameTimerText.selectable = _linesCompletedText.selectable = _currentScoreText.selectable = false;
			_endMessageText.width = 500;
			_gameTimerText.x = _linesCompletedText.x = _currentScoreText.x = _grid.x + _grid.width + 60;
			_endMessageText.x = stage.stageWidth/2 - _endMessageText.width/2;
			_gameTimerText.y = _grid.y + 32;
			_linesCompletedText.y = _gameTimerText.y + 75;
			_currentScoreText.y = _linesCompletedText.y + 75;
			_endMessageText.y = stage.stageHeight/2 - 90;
			_gameTimerText.text = "0:00";
			_linesCompletedText.text = "0";
			_currentScoreText.text = "0";
			_endMessageText.text = "Partie terminée! \n Votre score final est : \n";
			_endMessageText.multiline = true;
			_endMessageText.wordWrap = true;

			// création des élément pour le menu secondaire
			var secondaryButtonsNames:Array = new Array("Reprendre la partie", "Quitter la partie", "Afficher l'aide");
			_secondaryMenu = new Menu(secondaryButtonsNames);
			_secondaryMenu.addEventListener(MouseEvent.CLICK, handleSecondaryMenuOptions, true);
			_secondaryMenu.y = stage.stageHeight/2 - _secondaryMenu.height/2
			_secondaryMenu.x = 52;

			// ajout des élément dans le conteneur
			var gameContainer:Sprite = _grid.parent as Sprite;
			gameContainer.addChild(_gameTimerText);
			gameContainer.addChild(_linesCompletedText);
			gameContainer.addChild(_currentScoreText);

			gameContainer.addChild(_mergeCooldown);
			gameContainer.addChild(_blendCooldown);

			// ajout des écouteur d'événement
			_grid.addEventListener(GameEvent.LINE_COMPLETED, handleLineCompletion);
			_grid.addEventListener(GameEvent.GAME_OVER, endGame);
			_key.addEventListener(SmoothKeyboardEvent.KEY_DOWN, handleKeys);
		}

		/**
		 * Pause le jeu
		 * met tout les timer à pause
		 */
		public function pauseGame():void {
			_grid.removeEventListener(GameEvent.LINE_COMPLETED, handleLineCompletion);
			_grid.removeEventListener(GameEvent.GAME_OVER, endGame);

			_gameTimer.removeEventListener(TimerEvent.TIMER, updateTime);
			_gameTimer.stop();

			_spawnTimer.removeEventListener(TimerEvent.TIMER, spawnBloc);
			_spawnTimer.stop();

			_refreshTimer.removeEventListener(TimerEvent.TIMER, refreshGameStatus);
			_refreshTimer.stop();

			_blendCooldown.stop();
			_mergeCooldown.stop();
		}

		/**
		 * Permet de remettre le jeu en marche après une pause
		 * redémarre tous les timer
		 */
		public function resumeGame():void {
			_grid.addEventListener(GameEvent.LINE_COMPLETED, handleLineCompletion);
			_grid.addEventListener(GameEvent.GAME_OVER, endGame);

			_gameTimer.addEventListener(TimerEvent.TIMER, updateTime);
			_gameTimer.start();

			_spawnTimer.addEventListener(TimerEvent.TIMER, spawnBloc);
			_spawnTimer.start();

			_refreshTimer.addEventListener(TimerEvent.TIMER, refreshGameStatus);
			_refreshTimer.start();

			_blendCooldown.start();
			_mergeCooldown.start();
		}

		/**
		 * Déclenché lorsqu'un bloc atteitn le haut de l'écran ou que l'utilisateur quitte le jeu
		 * Arrete le jeu et affiche le message de fin
		 *
		 * @param $evt objet événementiel capté lors du PotEvent.GAME_OVER
		 */
		public function endGame($evt:GameEvent=null):void {
			this.showBlackOverlay();

			// arrete tous les timer et remove leur écouteur d'événement
			_grid.removeEventListener(GameEvent.LINE_COMPLETED, handleLineCompletion);
			_grid.removeEventListener(GameEvent.GAME_OVER, endGame);
			_key.removeEventListener(SmoothKeyboardEvent.KEY_DOWN, handleKeys);

			_gameTimer.stop();
			_spawnTimer.stop();
			_refreshTimer.stop();

			_gameTimer.removeEventListener(TimerEvent.TIMER, updateTime);
			_spawnTimer.removeEventListener(TimerEvent.TIMER, spawnBloc);
			_refreshTimer.removeEventListener(TimerEvent.TIMER, refreshGameStatus);

			// affiche le message de fin
			_endMessageText.appendText(String(Score.score));

			// affiche le bouton de fin
			var endButton:Bouton = new Bouton("Quitter la partie");
			endButton.addEventListener(MouseEvent.CLICK, returnToMainMenu);
			endButton.x = stage.stageWidth/2 - endButton.width/2;
			endButton.y = _endMessageText.y + 70 + endButton.height;
			stage.addChild(_endMessageText);
			stage.addChild(endButton);
		}

		/**
		 * Déclenché lorsque l'utilisateur clique sur le bouton de fin
		 * Fonction pour gérér la mémoire
		 * Met tout les élément du jeu à null
		 *
		 * @param $evt objet événementiel capté lors du MouseEvent.MOUSE_CLICK
		 */
		private function returnToMainMenu ($evt:MouseEvent):void {
			this.hideBlackOverlay();

			_blendCooldown.reset();
			_mergeCooldown.reset();

			var gameContainer:Sprite = _grid.parent as Sprite;
			gameContainer.removeChild(_gameTimerText);
			gameContainer.removeChild(_linesCompletedText);
			gameContainer.removeChild(_currentScoreText);
			stage.removeChild(_endMessageText);

			gameContainer.removeChild(_mergeCooldown);
			gameContainer.removeChild(_blendCooldown);

			_grid.cleanGrid();

			_blackOverlay = null;
			_refreshTimer = null;
			_spawnTimer = null;
			_gameTimer = null;
			_grid = null;
			_gameTimerText = null;
			_linesCompletedText = null;
			_currentScoreText = null;
			_endMessageText = null;
			_mergeCooldown = null;
			_blendCooldown = null;

			var endButton:Bouton = $evt.target as Bouton;
			stage.removeChild(endButton);
			endButton.removeEventListener(MouseEvent.CLICK, returnToMainMenu);
			endButton = null;
			this.dispatchEvent(new GameEvent(GameEvent.RETURN_TO_MAIN_MENU));
			this.stage = null;
		}

		/**
		 * Déclenché à chaque fois que le timer fait une répétition
		 * Gère le jeu
		 *
		 * @param $evt objet événementiel capté lors du TimerEvent.Timer
		 */
		private function refreshGameStatus ($evt:TimerEvent):void {
			// bouge les bloc
			_grid.makeBlocsMove();
			// vérifie les ligne completer
			_grid.checkLines();

			// ajoute ou retire l'ombre en fonction du nombre de bloc qui bouge
			if(_grid.movingBlocs[0] != null){
				_grid.addShadow(_grid.movingBlocs[0]);
			}else{
				_grid.removeShadow();
			}

			// vérifie les gameOver
			// important que le gameOver soit en dernier pour éviter les erreurs
			_grid.checkGameOver();
		}

		/**
		 * Déclenché à chaque fois que le timer fait une répétition
		 * Gère le temps de jeu
		 *
		 * @param $evt objet événementiel capté lors du TimerEvent.Timer
		 */
		private function updateTime ($evt:TimerEvent):void {
			var elapsedMinutes:int = Math.floor($evt.target.currentCount/60);
			var elapsedSeconds:int = $evt.target.currentCount%60;

			_gameTimerText.text = elapsedMinutes + ((elapsedSeconds < 10) ? ":0" : ":") + elapsedSeconds;
			trace(elapsedMinutes + ((elapsedSeconds < 10) ? ":0" : ":") + elapsedSeconds);
		}

		/**
		 * Déclenché à chaque fois que le timer fait une répétition
		 * Gère l'apparition des blocs
		 *
		 * @param $evt objet événementiel capté lors du TimerEvent.Timer
		 */
		private function spawnBloc ($evt:TimerEvent):void {
			// génère une couleur au hasard
			var randColumn:int = Math.floor(Math.random()*_grid.nbColumns)+1;

			//crée le bloc
			var bloc:Bloc = new Bloc(randColumn, 1, Bloc.randomColor(), _grid);
			_grid.addMovingBloc(bloc);
			_grid.addChild(bloc);
		}

		/**
		 * Déclenché à chaque fois qu'une ligne est complété
		 * Gère la disparrition des lignes
		 *
		 * @param $evt objet événementiel capté lors du PotEvent:LINE_COMPLETED
		 */
		private function handleLineCompletion ($evt:GameEvent):void{
			// enlève la ligne
			_grid.removeLine($evt.line);
			_linesCompleted++;
			_linesCompletedText.text = String(_linesCompleted);

			// diminue le temps entre les blocs
			_spawnRate = Math.max(_refreshRate + 200, _spawnRate - 10);
			_spawnTimer.delay = _spawnRate;

			// ajoute les points
			Score.addScore(200 * 6/_difficulty);
			_currentScoreText.text = String(Score.score);
		}

		/**
		 * Déclenché à chaque fois que l'utilisateur appuie sur une touche du clavier
		 * Gère les touches
		 *
		 * @param $evt objet événementiel capté lors du SmoothKeyboardEvent.KEY_UP ou SmoothKeyboardEvent.KEY_DOWN
		 */
		private function handleKeys ($evt:SmoothKeyboardEvent):void {
			var column:int, row:int;

			if (_grid.movingBlocs.length !== 0 && _gameTimer.running)
			{
				switch ($evt.keyCode) {
					case 37: // LEFT
						//deplace le bloc vers la gauche
						if (_grid.movingBlocs[0].column == 1)
						{
							return;
						}
						else if (_grid.movingBlocs[0].row < _grid.getRowHeight(_grid.movingBlocs[0].column - 1))
						{
							_grid.movingBlocs[0].column--;
							_grid.addShadow(_grid.movingBlocs[0]);
						}
						break;

					case 39: // RIGHT
						//deplace le bloc vers la droite
						if (_grid.movingBlocs[0].column == _grid.nbColumns)
						{
							return;
						}
						else if (_grid.movingBlocs[0].row < _grid.getRowHeight(_grid.movingBlocs[0].column + 1))
						{
							_grid.movingBlocs[0].column++;
							_grid.addShadow(_grid.movingBlocs[0]);
						}
						break;

					case 40: // DOWN
						//deplace le bloc vers le bas
						if (_grid.movingBlocs[0].row < _grid.getRowHeight(_grid.movingBlocs[0].column))
						{
							_grid.movingBlocs[0].row++;
						}
						else
						{
							_grid.rowHeight[_grid.movingBlocs[0].column - 1]--;
							_grid.addPlacedBloc(_grid.movingBlocs[0]);
							_grid.removeMovingBloc(0);
						}
						break;

					case 32: // SPACE
						//depose le bloc
						if (!_key.isLocked(32))
						{
							_grid.movingBlocs[0].row = _grid.getRowHeight(_grid.movingBlocs[0].column);
							_grid.rowHeight[_grid.movingBlocs[0].column - 1]--;
							_grid.addPlacedBloc(_grid.movingBlocs[0]);
							_grid.removeMovingBloc(0);
							_key.lockKey(32);
						}
						break;

					case 81: // Q
						// appelle les fonction pour gère l'abilité q et dépose le bloc
						if (!_key.isLocked(81) && !_blendCooldown.onCooldown)
						{
							_grid.movingBlocs[0].row = _grid.getRowHeight(_grid.movingBlocs[0].column);
							_grid.rowHeight[_grid.movingBlocs[0].column - 1]--;

							column = _grid.movingBlocs[0].column;
							row = _grid.movingBlocs[0].row;

							_grid.addPlacedBloc(_grid.movingBlocs[0]);
							_grid.removeMovingBloc(0);

							Bloc.blendColorsFrom(_grid.placedBlocs[column - 1][row - 1]);
							_blendCooldown.start();
							_key.lockKey(81);
						}
						break;

					case 87: // W
						// appelle les fonction pour gère l'abilité w et dépose le blo
						if (!_key.isLocked(87) && !_mergeCooldown.onCooldown)
						{
							_grid.movingBlocs[0].row = _grid.getRowHeight(_grid.movingBlocs[0].column);
							_grid.rowHeight[_grid.movingBlocs[0].column - 1]--;

							column = _grid.movingBlocs[0].column;
							row = _grid.movingBlocs[0].row;

							_grid.addPlacedBloc(_grid.movingBlocs[0]);
							_grid.removeMovingBloc(0);

							Bloc.replaceColorsFrom(_grid.placedBlocs[column - 1][row - 1]);
							_mergeCooldown.start();
							_key.lockKey(87);
						}
						break;
				}

			}

			// gère les pause
			if ($evt.keyCode == 27 || $evt.keyCode == 80) {// ESC ou P
				if (_gameTimer.running) {
					this.pauseGame();
					this.showBlackOverlay();
					stage.addChild(_secondaryMenu);
				} else {
					this.resumeGame();
					this.hideBlackOverlay();
					stage.removeChild(_secondaryMenu);
				}
			}

		}

		/**
		 * Déclenché lorsque l'un des boutons du menu secondaire est cliqué
		 * gère l'action à faire en fonction du bouton cliqué
		 *
		 * @param $evt objet événementiel capté lors du MouseEvent.CLICK
		 */
		private function handleSecondaryMenuOptions ($evt:MouseEvent):void {
			var currentButton:Bouton = $evt.target as Bouton;
			switch (currentButton.title) {
				// si le bouton REPRENDRE LA PARTIE est cliqué
				case "Reprendre la partie":
					// repartir la partie
					this.resumeGame();
					this.hideBlackOverlay();
					stage.removeChild(_secondaryMenu);
					stage.focus = _grid.parent;
					break;

				// si le bouton QUITTER LA PARTIE est cliqué
				case "Quitter la partie":
					// quiter la parti
					stage.removeChild(_secondaryMenu);
					this.endGame();
					break;

				// si le bouton Afficher l'aide est cliqué
				case "Afficher l'aide":
					// affiche l'aide
					_helper.showHelper();
					break;
			}

		}

		/**
		 * Affiche le voile noir
		 */
		private function showBlackOverlay():void{
			stage.addChild(_blackOverlay);
		}

		/**
		 * cache le voile noir
		 */
		private function hideBlackOverlay():void{
			if(_blackOverlay.parent != null)
				stage.removeChild(_blackOverlay);
		}

	}

}
