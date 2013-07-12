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

package com.pieceoftetris.ui {

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;

	/**
	 * Classe Singleton servant à afficher l'aide
	 */
	public class Helper extends Sprite {
		/**
		 * L'instance de la classe
		 */
		private static var _instance:Helper = new Helper();

		/**
		 * Référence au stage
		 */
		private static var _stage:Stage;

		/**
		 * La balise embed nécessaires à l'affichage de l'aide
		 */
		[Embed(source="../assets/HelpMenu.jpg")]
		private var HelpMenu:Class;

		/**
		 * Constructeur Singleton
		 */
		public function Helper() {
			if (_instance) {
				throw new Error("Helper can only be accessed from the static property Helper.instance");
			}
		}

		/**
		 * Création de l'apparence du Helper
		 * @param $stage une référence au stage
		 */
		public function initialize ($stage:Stage):void {
			this.stage = $stage;

			// Création et positionnement du loader de l'image d'aide
			this.addChild(new HelpMenu() as Bitmap);

			// Création et positionnement de bouton permettant de fermer l'image d'aide
			var closeButton:Bouton = new Bouton("Retour au menu");
			closeButton.x = 750;
			closeButton.y = 50;
			this.addChild(closeButton);
			closeButton.addEventListener(MouseEvent.CLICK, closeHelper);
		}

		/**
		 * Affiche l'aide
		 */
		public function showHelper ():void {
			stage.addChild(this);
		}

		/**
		 * Déclenché lorsque le bouton permettant de fermer l'aide est cliqué
		 * @param $evt objet événementiel capté lors du MouseEvent.CLICK
		 */
		private function closeHelper ($evt:MouseEvent):void {
			stage.removeChild(this);
		}

		/**
		 * Permet de récupérer le Singleton
		 * @return Helper l'instance de la classe
		 */
		public static function get instance ():Helper {
			return _instance;
		}

		/**
		 * Assigne une référence au stage
		 * @param $stage rérence au stage
		 */
		public function set stage ($stage:Stage):void {
			_stage = $stage;
		}

		/**
		 * Récupère la référence au stage
		 * @return Stage référence au stage
		 */
		public override function get stage ():Stage {
			return _stage;
		}

	}

}
