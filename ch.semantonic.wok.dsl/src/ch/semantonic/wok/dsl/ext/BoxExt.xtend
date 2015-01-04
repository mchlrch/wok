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
package ch.semantonic.wok.dsl.ext

import ch.semantonic.wok.dsl.wokDsl.BasicBox
import ch.semantonic.wok.dsl.wokDsl.Box
import ch.semantonic.wok.dsl.wokDsl.ContainedBoxItem
import ch.semantonic.wok.dsl.wokDsl.IncludedBox
import ch.semantonic.wok.dsl.wokDsl.ReferencedBoxItem
import com.google.inject.Inject
import org.eclipse.xtext.naming.IQualifiedNameProvider
import org.eclipse.xtext.naming.DefaultDeclarativeQualifiedNameProvider
import ch.semantonic.wok.dsl.wokDsl.Item
import java.util.List
import java.util.LinkedList
import com.google.common.base.Optional

class BoxExt {
	
	@Inject IQualifiedNameProvider qNameProvider = new DefaultDeclarativeQualifiedNameProvider;
	
	dispatch def Iterable<Box> containedBoxes(BasicBox box) {
		box.items.filter(ContainedBoxItem).map[value]
	}
	
	dispatch def Iterable<Box> containedBoxes(IncludedBox box) {
		box.items.filter(ContainedBoxItem).map[value]
	}
	
	dispatch def Iterable<Box> referencedBoxes(BasicBox box) {
		box.items.filter(ReferencedBoxItem).map[value]
	}
	
	dispatch def Iterable<Box> referencedBoxes(IncludedBox box) {
		box.items.filter(ReferencedBoxItem).map[value]
	}
	
	def Iterable<Item> items(IncludedBox box) {
		switch target: box.insert {
			BasicBox: target.items
			IncludedBox: if (target.freeOfCycles) target.items else newArrayList()
		} 
	}
	
	dispatch def Box value(ContainedBoxItem item) {
		item.value
	}
	
	dispatch def Box value(ReferencedBoxItem item) {
		item.value
	}
	
	def qName(Box box) {
		qNameProvider.getFullyQualifiedName(box)
	}
	
	
	dispatch def boolean freeOfCycles(IncludedBox box) {
		// true/OK if box is not in containment of box.insert
		! box.containmentPathFrom(box.insert).present
	}
	
	dispatch def boolean freeOfCycles(BasicBox box) {
		! box.containedBoxes().exists[childBox | box.containmentPathFrom(childBox).present];
	} 
	
	def Optional<List<Box>> containmentPathFrom(Box target, Box container) {
		target.containmentPathFrom(container, emptyList);
	}
	
	def private Optional<List<Box>> containmentPathFrom(Box target, Box container, List<Box> traversalPathIn) {
		val traversalPath = traversalPathIn.cloneAndAppend(container)
		
		switch container {
			case container == target: Optional.of(traversalPath)
			
			// terminate cycles built from IncludedBoxes
			case traversalPathIn.contains(container): Optional.of(traversalPath)			
			
			// drill down virtual containments
			IncludedBox: target.containmentPathFrom(container.insert, traversalPath)
			
			// drill down real containments
			BasicBox: {
				val firstPathFound = container.containedBoxes
					.map[childBox | target.containmentPathFrom(childBox, traversalPath)]
					.findFirst[path | path.present];
				return if (firstPathFound != null) firstPathFound else Optional.absent;						
			}
			
			default: Optional.absent 
		}
	}
	
	def private List<Box> cloneAndAppend(List<Box> path, Box newPathElement) {
		val result = new LinkedList<Box>(path);
		result.add(newPathElement);
		result;		
	}	

}