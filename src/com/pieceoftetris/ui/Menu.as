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