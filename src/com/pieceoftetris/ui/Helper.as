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