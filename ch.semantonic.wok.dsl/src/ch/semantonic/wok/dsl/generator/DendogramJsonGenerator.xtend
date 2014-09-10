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
package ch.semantonic.wok.dsl.generator

import ch.semantonic.wok.dsl.ext.BoxExt
import ch.semantonic.wok.dsl.ext.ModelAccessExt
import ch.semantonic.wok.dsl.wokDsl.Box
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator

class DendogramJsonGenerator implements IGenerator {

	extension BoxExt boxExt = new BoxExt
	extension ModelAccessExt modelAccessExt = new ModelAccessExt 

	override void doGenerate(Resource resource, IFileSystemAccess fsa) {
		val rootBoxes = resource.resourceSet.collectRootBoxes
		
		fsa.generateFile("hierarchy_data.json", rootBoxes.hierarchyData)
	}

	def hierarchyData(Iterable<Box> roots) '''
		
		{
			"name": "",
			"children": [
				«FOR root : roots SEPARATOR ','»
					«root.node2Json»
				«ENDFOR»
				]
		}
		
	'''

	def String node2Json(Box box) '''
		
		{
			"name": "«box.name»",
			"children": [
			     «FOR containedBox : box.containedBoxes SEPARATOR ','»
			     	«containedBox.node2Json»
			     «ENDFOR»
			]
		}
	'''

}
