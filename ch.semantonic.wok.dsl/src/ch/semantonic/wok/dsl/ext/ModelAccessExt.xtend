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

import ch.semantonic.wok.dsl.wokDsl.DslRoot
import org.eclipse.emf.ecore.resource.ResourceSet
import ch.semantonic.wok.dsl.wokDsl.Box

class ModelAccessExt {

	def Iterable<DslRoot> collectDslRoots(ResourceSet rs) {
		rs.resources.map(res | res.contents.filter(DslRoot)).flatten
	}
	
	def Iterable<Box> collectRootBoxes(ResourceSet rs) {
		rs.collectDslRoots.map(mod | mod.elements.filter(Box)).flatten
	}
	
	def Iterable<Box> collectAllBoxes(ResourceSet rs) {
		rs.resources.map(res | res.allContents.filter(Box).toIterable). flatten
	}

}
