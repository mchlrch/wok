/*******************************************************************************
 * Copyright (c) 2014, 2015 Michael Rauch
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Project: http://www.wok-lang.org
 *
 * Contributors:
 * Michael Rauch - initial API and implementation
 *******************************************************************************/
package ch.semantonic.wok.dsl.ui.outline

import ch.semantonic.wok.dsl.ext.BoxExt
import ch.semantonic.wok.dsl.wokDsl.AbstractElement
import ch.semantonic.wok.dsl.wokDsl.BasicBox
import ch.semantonic.wok.dsl.wokDsl.Box
import ch.semantonic.wok.dsl.wokDsl.ContainedBoxItem
import ch.semantonic.wok.dsl.wokDsl.DslRoot
import ch.semantonic.wok.dsl.wokDsl.IncludedBox
import ch.semantonic.wok.dsl.wokDsl.Item
import com.google.common.base.Strings
import javax.inject.Inject
import org.eclipse.swt.graphics.Image
import org.eclipse.xtext.ui.IImageHelper
import org.eclipse.xtext.ui.editor.outline.IOutlineNode
import org.eclipse.xtext.ui.editor.outline.impl.DefaultOutlineTreeProvider
import org.eclipse.xtext.ui.editor.outline.impl.DocumentRootNode

/**
 * Customization of the default outline structure.
 *
 * see http://www.eclipse.org/Xtext/documentation.html#outline
 */
class WokDslOutlineTreeProvider extends DefaultOutlineTreeProvider {
	
	@Inject extension BoxExt boxExt;
	
	@Inject
	private IImageHelper imageHelper;
     
	/**
	 * ignore root 
	 */
	def protected _createChildren(DocumentRootNode docRootNode, DslRoot it) {
	  for (AbstractElement element : elements) {
	  	createNode(docRootNode, element);
	  }
	}
	
	def protected Image _image(BasicBox it) {
		val imgName = if (items.empty) "empty_pack_obj.gif" else "package_obj.gif"  
		imageHelper.getImage(imgName);
	}
	
	def protected Image _image(IncludedBox it) {		
		val imgName = if (items.empty) "empty_included_box.png" else "included_box.png"
		imageHelper.getImage(imgName);	
	}
	
	def protected _createChildren(IOutlineNode parentNode, BasicBox it) {
		for (cBoxItem : items.filter(ContainedBoxItem)) {			
			val Box box = cBoxItem.value;			
			val isLeaf = (box instanceof IncludedBox) || box.containedBoxes.empty 				
			createEObjectNode(parentNode, box, imageDispatcher.invoke(box), box.name.prefixWithLabel(cBoxItem), isLeaf);
		}
	}
	
	def prefixWithLabel(String text, Item item) {
		if (Strings.isNullOrEmpty(item.label)) text else String.format("%s: %s", item.label, text)
	}
	
}
