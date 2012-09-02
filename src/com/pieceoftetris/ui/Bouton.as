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
	
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * Classe utilisée pour représenter les éléments d'un menu
	 */
	public class Bouton extends SimpleButton {
		/**
		 * Le titre du bouton
		 */
		private var _title:String;
		
		/**
		 * La largeur du bouton
		 */
		private var _largeur:int;
		
		/**
		 * La hauteur du bouton
		 */
		private var _hauteur:int;
		
		/**
		 * Le formatage par défaut du titre du bouton
		 */
		private var _textFormat:TextFormat;
		
		/**
		 * Array contenant le nom des sous-options du bouton
		 */
		private var _optionalBoxNames:Array;
		
		/**
		 * Le champs texte contenant le nom de la sous-option active
		 */
		private var _optionalBox:TextField;
		
		/**
		 * L'index représentant la sous-option active
		 */
		private var _optionalBoxIndex:int;
		
		/**
		 * Constructeur
		 *
		 * @param $title le titre du bouton
		 * @param $optionalBox le champs texte contenant le nom de la sous-option active
		 * @param $optionalBoxNames Array contenant le nom des sous-options du bouton
		 * @param $width la largeur du bouton
		 * @param $height la hauteur du bouton
		 * @param upTextColor la couleur du texte lors de l'état up du bouton
		 * @param $overTextColor la couleur du texte lors de l'état over du bouton
		 * @param $downTextColor la couleur du texte lors de l'état down du bouton
		 * @param $bgColor la couleur du bouton lors de l'état up et over
		 * @param $downBgColor la couleur du bouton lors de l'état down
		 */
		public function Bouton ($title:String, $optionalBox:TextField=null, $optionalBoxNames:Array=null, $width:int=200, $height:int=30, $upTextColor:uint=0xffffff, $overTextColor:uint=0x444444, $downTextColor:uint=0xdddddd, $bgColor:uint=0x999999, $downBgColor:uint=0x333333) {
			// Assignation des valeurs des paramètres à leur propriété respective
			_title = $title;
			_largeur = $width;
			_hauteur = $height;
			_optionalBoxNames = $optionalBoxNames;
			_optionalBox = $optionalBox;
			_optionalBoxIndex = 0;
			
			// Création du formatage par défaut des titres des boutons
			_textFormat = new TextFormat();
			_textFormat.font = "Arial";
			_textFormat.bold = true
			_textFormat.size = 18;
			_textFormat.align = TextFormatAlign.CENTER;
			
			// Création du upState		
			var upState:Sprite = new Sprite();
			this.createState(upState, $upTextColor, $bgColor);
			this.upState = upState;
			
			// Création du overState
			var overState:Sprite = new Sprite();
			this.createState(overState, $overTextColor, $bgColor);
			this.overState = overState;
			
			// Création du downState
			var downState:Sprite = new Sprite();
			this.createState(downState, $downTextColor, $downBgColor);
			this.downState = downState;
			
			// Déterminer la zone active
			this.hitTestState = this.upState;
		}
		
		/**
		 * Créé un état du bouton à partir d'une couleur pour le texte et une autre pour le fond 
		 *
		 * @param $state le Sprite dans lequel l'état du bouton sera créé
		 * @param $textColor la couleur du texte
		 * @param $bgColor la couleur du bouton
		 */
		private function createState($state:Sprite, $textColor:uint, $bgColor:uint):void {
			// Création de la forme de l'état du bouton
			var backgroundRect:Shape = new Shape();
			backgroundRect.graphics.beginFill($bgColor);
			backgroundRect.graphics.drawRoundRect(0, 0, _largeur, _hauteur, 10, 10);
			backgroundRect.graphics.endFill();
			$state.addChild(backgroundRect);
			
			// Création du texte de l'état du bouton
			var title:TextField = new TextField();
			_textFormat.color = $textColor;
			title.defaultTextFormat = _textFormat;
			title.text = _title;
			title.selectable = false;
			
			// Positionnement du texte
			title.width = backgroundRect.width;
			title.height = 30;
			title.y = backgroundRect.height/2 - Number(_textFormat.size)/2-3;
			$state.addChild(title);
		}
		
		/**
		 * Permet de récupérer le titre du bouton
		 * @return String le titre du bouton
		 */
		public function get title():String {
			return _title;
		}
		
		/**
		 * Permet de récupérer le nom des sous-options du bouton
		 * @return Array le nom des sous-options
		 */
		public function get optionalBoxNames():Array {
			return _optionalBoxNames;
		}
		
		/**
		 * Permet de récupérer le champs texte permettant d'afficher les sous-options
		 * @return TextField le champs texte
		 */
		public function get optionalBox():TextField {
			return _optionalBox;
		}
		
		/**
		 * Permet de récupérer l'index de la sous-option actuelle
		 * @return int l'index de la sous-option
		 */
		public function get optionalBoxIndex():int {
			return _optionalBoxIndex;
		}
		
		/**
		 * Permet de changer le nom des sous-options et donc
		 * d'ajouter et de supprimer des sous-options
		 * @param $optionalBoxNames Array contenant le nom des sous-options
		 */
		public function set optionalBoxNames ($optionalBoxNames:Array):void {
			_optionalBoxNames = $optionalBoxNames;
		}
		
		/**
		 * Permet de changer le champs texte dans lequel les sous-options sont affichées
		 * @param $optionalBox le champs texte
		 */
		public function set optionalBox ($optionalBox:TextField):void {
			_optionalBox = $optionalBox;
		}
		
		/**
		 * Permet de changer l'index courant de la sous-option,
		 * retourne au premier lorsque la sous-option dépasse l'index de _optionalBoxNames
		 * @index l'index de la sous option
		 */
		public function set optionalBoxIndex ($index:int):void {
			if ($index > _optionalBoxNames.length - 1) {
				$index = 0;
			}
			
			_optionalBoxIndex = $index;
		}
		
	}
	
}
