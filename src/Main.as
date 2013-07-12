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

package
{
	import com.pieceoftetris.display.Grid;
	import com.pieceoftetris.events.GameEvent;
	import com.pieceoftetris.main.Config;
	import com.pieceoftetris.main.Game;
	import com.pieceoftetris.ui.Bouton;
	import com.pieceoftetris.ui.Helper;
	import com.pieceoftetris.ui.Menu;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;

	/**
	* Classe utiliser pour gérer tout les autres classe
	*/
	[SWF(width="1024", height="768", frameRate="30", backgroundColor="0x000000")]
	public class Main extends Sprite {
		/**
		 * La boucle de jeu
		 */
		private var _game:Game = Game.instance;

		/**
		 * L'aide
		 */
		private var _helper:Helper = Helper.instance;

		/**
		 * Le soundChannel pour la musique principale
		 */
		private var _soundChannel:SoundChannel;

		/**
		 * la piste audio de la musique principale
		 */
		private var _bgTrack:Sound;

		/**
		 * Le menu principal
		 */
		private var _mainMenu:Menu;

		/**
		 * Le Sprite qui contient tous les éléments de jeu
		 */
		private var _gameContainer:Sprite;

		/**
		 * Permet de compter le nombre de frame de l'animation de départ
		 */
		private var _frameCount:int;

		/**
		 * Permet de compter les lettres qui sont tombées(Animition de départ)
		 */
		private var _lettersCount:int;

		/**
		 * Array contenant le nom de lettres dans l'ordre ou elles doivent apparaître
		 */
		private var _letters:Array;

		/**
		 * Les balises embed nécessaires à l'affichage des graphiques de base du jeu
		 */
		[Embed(source="../assets/Letters/P.png")]
		private var LettreP:Class;

		[Embed(source="../assets/Letters/IECE.png")]
		private var LettresIECE:Class;

		[Embed(source="../assets/Letters/O.png")]
		private var LettreO:Class;

		[Embed(source="../assets/Letters/F.png")]
		private var LettreF:Class;

		[Embed(source="../assets/Letters/T.png")]
		private var LettreT:Class;

		[Embed(source="../assets/Letters/ETRIS.png")]
		private var LettresETRIS:Class;

		[Embed(source="../assets/Background.jpg")]
		private var Background:Class;

		[Embed(source="../assets/BackgroundMusic.mp3")]
		private var BackgroundMusic:Class;

		/**
		 * Constructeur
		 */
		public function Main() {
			this.addChild(new Background() as Bitmap);

			// initialization des variables pour l'animation de départ
			_frameCount = 0;
			_lettersCount = 0;
			_letters = new Array(new LettreP(), new LettresIECE(), new LettreO(), new LettreF(), new LettreT(), new LettresETRIS());
			_letters[0].x = 355
			_letters[1].x = _letters[0].x + _letters[0].width - 13;
			_letters[2].x = _letters[1].x + _letters[1].width - 10;
			_letters[3].x = _letters[2].x + _letters[2].width - 8;
			_letters[4].x = _letters[3].x + _letters[3].width - 8;
			_letters[5].x = _letters[4].x + _letters[4].width - 8;

			// Création du helper
			_helper.initialize(stage);

			// Création des éléments pour le son
			_soundChannel = new SoundChannel();
			_bgTrack = new BackgroundMusic() as Sound;
			_soundChannel = _bgTrack.play(0, int.MAX_VALUE);

			// Création du conteneur de jeu
			_gameContainer = new Sprite();
			//Assigniation de ses valeurs
			_gameContainer.x = 403;
			_gameContainer.y = 165;
			stage.addChild(_gameContainer);

			// Création du menu principal
			var mainButtonsNames:Array = new Array("Nouvelle partie", "Difficulté", "Mode démentiel", "Afficher l'aide");
			var optionalBoxesNames:Array = new Array("", new Array("FACILE", "MOYEN", "DIFFICLE"), new Array("DÉSACTIVÉ", "ACTIVÉ"), "");
			_mainMenu = new Menu(mainButtonsNames, optionalBoxesNames);
			// Ajout de l'intéractivité au menu
			_mainMenu.addEventListener(MouseEvent.CLICK, handleMainMenuOptions, true);
			_mainMenu.y = stage.stageHeight/2 - _mainMenu.height/2
			_mainMenu.x = 52;
			stage.addChild(_mainMenu);

			// Démare l'animation de départ
			stage.addEventListener(Event.ENTER_FRAME, startAnimation);
		}

		/**
		 * Déclenché lorsque l'un des boutons du menu principal est cliqué
		 * gère l'action à faire en fonction du bouton cliqué
		 *
		 * @param $evt objet événementiel capté lors du MouseEvent.CLICK
		 */
		private function handleMainMenuOptions ($evt:MouseEvent):void {
			// enregistre le bouton cliqué
			var currentButton:Bouton = $evt.target as Bouton;

			switch (currentButton.title) {
				// si NOUVELLE PARTIE est cliqué
				case "Nouvelle partie":
					// retirer le menu des éléments d'affichage
					// et démare la parti avec les configurations préalablement choisies
					stage.removeChild(_mainMenu);
					var grid:Grid = new Grid();
					_gameContainer.addChild(grid);
					_game.startGame(stage, Config.difficulty, grid, Config.insaneMode);
					_game.addEventListener(GameEvent.RETURN_TO_MAIN_MENU, returnToMainMenu);

					// s'assure que le focus est sur le stage
					stage.stageFocusRect = false;
					stage.focus = _gameContainer;
					break;

				// si DIFFICULTÉ est cliqué
				case "Difficulté":
					// change l'affichage de la difficulté dans la zone de texte
					currentButton.optionalBoxIndex++;
					currentButton.optionalBox.text = currentButton.optionalBoxNames[currentButton.optionalBoxIndex];
					switch (currentButton.optionalBox.text) {
						// Change la difficulté dans les configurations
						case "FACILE":
							Config.difficulty = Game.DIFFICULTY_EASY;
							break;
						case "MOYEN":
							Config.difficulty = Game.DIFFICULTY_MEDIUM;
							break;
						case "DIFFICLE":
							Config.difficulty = Game.DIFFICULTY_HARD;
							break;
					}
					break;

				// si MODE DÉMENTIEL est cliqué
				case "Mode démentiel":
					//change l'affichage du mode démentiel dans la zone de texte
					currentButton.optionalBoxIndex++;
					currentButton.optionalBox.text = currentButton.optionalBoxNames[currentButton.optionalBoxIndex];
					switch (currentButton.optionalBox.text) {
						// Change le mode démentiel dans les configurations
						case "DÉSACTIVÉ":
							Config.insaneMode = false;
							break;
						case "ACTIVÉ":
							Config.insaneMode = true;
							break;
					}
					break;

				// si AFFICHER L'AIDE est cliqué
				case "Afficher l'aide":
					// affiche l'aide
					_helper.showHelper();
					break;
				// si le bounton n'est pas géré
				default:
					throw new Error("Le bouton cliqué doit être un élément du Menu principal!");
			}

		}

		/**
		 * Déclenché lorsque l'utilisateur demande à retourner au menu principal
		 * affiche le menu principal
		 *
		 * @param $evt objet événementiel capté lors du PotEvent.RETURN_TO_MAIN_MENU
		 */
		private function returnToMainMenu ($evt:GameEvent):void {
			stage.addChild(_mainMenu);
		}

		/**
		 * Déclenché lorsque à chaque frames (1/24 de seconde)
		 * gère l'animation des lettres
		 *
		 * @param $evt objet événementiel capté lors du Event.ENTER_FRAME
		 */
		private function startAnimation ($evt:Event):void {

			// si il s'agit d'une seconde exacte (0, 1, 2 ...)
			if (_frameCount%24 == 0 && _lettersCount < _letters.length) {
				// fait apparaître la lettre correspondante à la seconde
				var letter:Bitmap = _letters[_lettersCount];
				letter.y = -letter.height;
				stage.addChildAt(letter, _lettersCount + 2);
				_lettersCount++;
			}

			// Boule qui gère l'animation des lettres
			for ( var i:int = 0; i < _lettersCount; i++ ) {
				// si elle ne sont pas à leurs positions finales
				if (i == 0)
				{
					if (_letters[i].y <= 115) _letters[i].y += 5;
				}
				else if (i == _lettersCount - 1)
				{
					if (_letters[i].y <= 50) _letters[i].y += 5;
					else stage.removeEventListener(Event.ENTER_FRAME, startAnimation);
				}
				else
				{
					if (_letters[i].y <= 85) _letters[i].y += 5;
				}
			}

			// incrémente le compte des frames
			_frameCount++;
		}

	}

}
