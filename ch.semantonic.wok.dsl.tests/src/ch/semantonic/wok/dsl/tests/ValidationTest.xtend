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

import ch.semantonic.wok.dsl.WokDslInjectorProvider
import ch.semantonic.wok.dsl.wokDsl.DslRoot
import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith
import ch.semantonic.wok.dsl.wokDsl.WokDslPackage
import ch.semantonic.wok.dsl.validation.WokDslValidator

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(WokDslInjectorProvider))
class ValidationTest {
	
	@Inject extension ParseHelper<DslRoot>
	@Inject extension ValidationTestHelper

	@Test
	def void shouldFlagContainmentCyclesAsErrorss() {
		'''
			[m] as n
			m {
			  [n] as o
			}
		'''.parse.assertError(WokDslPackage.Literals.INCLUDED_BOX, WokDslValidator.CYCLIC_CONTAINMENT)
		
		'''
			a {
			  [x] as b
			}
			x {
			  [z] as y
			}
			[a] as z
		'''.parse.assertError(WokDslPackage.Literals.INCLUDED_BOX, WokDslValidator.CYCLIC_CONTAINMENT)
		
		'''
			[u] as v
			[v] as u
		'''.parse.assertError(WokDslPackage.Literals.INCLUDED_BOX, WokDslValidator.CYCLIC_CONTAINMENT)
	}

}