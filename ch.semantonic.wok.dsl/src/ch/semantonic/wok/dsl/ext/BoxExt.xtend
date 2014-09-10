/*******************************************************************************
 * Copyright (c) 2014 Michael Rauch
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
package ch.semantonic.wok.dsl.ext

import ch.semantonic.wok.dsl.wokDsl.BasicBox
import ch.semantonic.wok.dsl.wokDsl.Box
import ch.semantonic.wok.dsl.wokDsl.ContainedBoxItem
import ch.semantonic.wok.dsl.wokDsl.IncludedBox
import ch.semantonic.wok.dsl.wokDsl.ReferencedBoxItem
import com.google.inject.Inject
import org.eclipse.xtext.naming.IQualifiedNameProvider
import org.eclipse.xtext.naming.DefaultDeclarativeQualifiedNameProvider

class BoxExt {
	
	@Inject IQualifiedNameProvider qNameProvider = new DefaultDeclarativeQualifiedNameProvider;
	
	dispatch def Iterable<Box> containedBoxes(BasicBox box) {
		box.items.filter(ContainedBoxItem).map[item | item.value]
	}
	
	dispatch def Iterable<Box> containedBoxes(IncludedBox box) {
		newArrayList() 
		
		// TODO: leads to recursion, need to fix scoping first ..
		// box.insert.containedBoxes
	}
	
	dispatch def Iterable<Box> referencedBoxes(BasicBox box) {
		box.items.filter(ReferencedBoxItem).map[item | item.value]
	}
	
	dispatch def Iterable<Box> referencedBoxes(IncludedBox box) {
		newArrayList()
	}
	
	def qName(Box box) {
		qNameProvider.getFullyQualifiedName(box)
	}
}