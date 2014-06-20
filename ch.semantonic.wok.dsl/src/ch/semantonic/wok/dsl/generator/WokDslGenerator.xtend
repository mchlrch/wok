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

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IGenerator
import org.eclipse.xtext.generator.IFileSystemAccess
import ch.semantonic.wok.dsl.wokDsl.Subject

/**
 * Generates code from your model files on save.
 * 
 * see http://www.eclipse.org/Xtext/documentation.html#TutorialCodeGeneration
 */
class WokDslGenerator implements IGenerator {
	
	override void doGenerate(Resource resource, IFileSystemAccess fsa) {
		val uri = resource.URI
		val fileName = uri.segmentsList.last + '_' + uri.hashCode + '_subjects.txt'
		fsa.generateFile(fileName, 
			resource.allContents
				.filter(typeof(Subject))
				.map[name]
				.join('\n'))
	}
}
