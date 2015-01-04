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
package ch.semantonic.wok.dsl.tests

import ch.semantonic.wok.dsl.wokDsl.AbstractElement
import ch.semantonic.wok.dsl.wokDsl.BasicBox
import ch.semantonic.wok.dsl.wokDsl.ContainedBoxItem
import ch.semantonic.wok.dsl.wokDsl.DslRoot
import ch.semantonic.wok.dsl.wokDsl.ReferencedBoxItem
import ch.semantonic.wok.dsl.wokDsl.TextItem

/**
 * some extensions for simplyfing model access in testcases
 */
class WokDslTestExt {
	
	def AbstractElement element(DslRoot model, int index) {
		model.getElements().get(index)		
	}
	
	def ContainedBoxItem cBoxItem(BasicBox box, int index) {
		box.items.get(index) as ContainedBoxItem
	}
	
	def ReferencedBoxItem rBoxItem(BasicBox box, int index) {
		box.items.get(index) as ReferencedBoxItem
	}
	
	def TextItem textItem(BasicBox box, int index) {
		box.items.get(index) as TextItem
	}

}