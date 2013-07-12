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

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 * Classe utilisée afin de créer des menus
	 */
	public class Menu extends Sprite {
		/**
		 * Constructeur
		 *
		 * @param $buttonsNames Array à 1 dimension contenant le nom des boutons
		 * @param $optionalBoxesNames Array à 2 dimensions contenant le nom des sous-options d'un bouton
		 */
		public function Menu ($buttonsNames:Array, $optionalBoxesNames:Array = null) {
			// Création du formatage du texte par défaut
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = "Arial";
			textFormat.bold = true
			textFormat.size = 18;
			textFormat.align = TextFormatAlign.RIGHT;
			textFormat.color = 0xFFFFFF;

			// Définiton des variables utilisées dans la boucle
			var button:Bouton, optionnalMultiplier:int = 0, optionalBox:TextField;
			// Boucle qui créé et positonne les boutons et ses sous-options (s'il y a lieu) dans le menu
			for (var i:int = 0; i < $buttonsNames.length; i++) {
				// Création et positionnement du bouton
				button = new Bouton($buttonsNames[i]);
				button.y = (10 + button.height) * i + (40 * optionnalMultiplier);
				this.addChild(button);

				// Création des sous-options d'un menu (s'il y a lieu)
				if ($optionalBoxesNames != null && $optionalBoxesNames[i] != "") {
					// Création d'un champs texte dans lequel les sous-options apparaîtront
					optionalBox = new TextField();
					optionalBox.defaultTextFormat = textFormat;
					optionalBox.text = $optionalBoxesNames[i][0];

					// Positionnement de ce champs texte en dessous du bouton
					optionalBox.y = (10 + button.height) * i + (40 * optionnalMultiplier) + button.height;
					optionalBox.selectable = false;
					optionalBox.mouseEnabled = false;
					optionalBox.width = button.width;
					this.addChild(optionalBox);

					// Stockage des noms des sous-options et du champs texte dans des propriétés
					button.optionalBoxNames = $optionalBoxesNames[i];
					button.optionalBox = optionalBox;

					// Permet de décaler le menu suivant
					optionnalMultiplier++;
				}

			}

		}

	}

}
