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
package ch.semantonic.wok.dsl.validation

import ch.semantonic.wok.dsl.ext.BoxExt
import ch.semantonic.wok.dsl.wokDsl.Box
import ch.semantonic.wok.dsl.wokDsl.IncludedBox
import ch.semantonic.wok.dsl.wokDsl.WokDslPackage
import com.google.common.base.Optional
import java.util.List
import javax.inject.Inject
import org.eclipse.xtext.validation.Check

/**
 * Custom validation rules. 
 *
 * see http://www.eclipse.org/Xtext/documentation.html#validation
 */
class WokDslValidator extends AbstractWokDslValidator {

	@Inject extension BoxExt boxExt;
	
	public static val CYCLIC_CONTAINMENT = 'cyclicContainmentRelationship'


	@Check
	def noCyclesWhenIncludingBox(IncludedBox includedBox) {
		
		// '[x] as z' is-valid-if z.containmentPathFrom(x).isAbsent
		val Optional<List<Box>> containmentPath = includedBox.containmentPathFrom(includedBox.insert);
		
		if (containmentPath.present) {
			error('''Including '«includedBox.insert.name»' leads to containment cycle: '''
				+ '''«FOR pathSegment: containmentPath.get SEPARATOR '/'»«pathSegment.name»«ENDFOR»''',
				WokDslPackage.Literals.INCLUDED_BOX__INSERT,
				CYCLIC_CONTAINMENT
			)
		}
	}
	
}
