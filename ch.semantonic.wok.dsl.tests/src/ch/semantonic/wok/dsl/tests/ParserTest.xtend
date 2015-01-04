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
package ch.semantonic.wok.dsl.tests

import ch.semantonic.wok.dsl.WokDslInjectorProvider
import ch.semantonic.wok.dsl.wokDsl.BasicBox
import ch.semantonic.wok.dsl.wokDsl.DslRoot
import ch.semantonic.wok.dsl.wokDsl.WokDslPackage
import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith

import static org.junit.Assert.assertEquals
import static org.junit.Assert.assertTrue

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(WokDslInjectorProvider))
class ParserTest {
	
	@Inject extension ParseHelper<DslRoot>
	@Inject extension WokDslTestExt
	@Inject extension ValidationTestHelper

	@Test
	def void testParsing() {
		val volcanoName = "Paricutin"
		val textValue = "Volcano in the Ring of Fire" 
		val dateLabel = "birthdate"
		val dateValue = "1943-02-20"
		val locationLabel = "location"
		val locationName = "Angahuan"
		
		val model = '''
			«volcanoName» {
			  "«textValue»"
			  «dateLabel»: "«dateValue»"
			  «locationLabel»: «locationName»
			}
			«locationName» {}
		'''.parse
		
		val volcanoBox = model.element(0) as BasicBox
		assertEquals(volcanoName, volcanoBox.getName())
		
		val locationBox = model.element(1) as BasicBox
		assertEquals(locationName, locationBox.getName())
		assertTrue(locationBox.items.empty)
		
		val dateItem = volcanoBox.textItem(1)
		assertEquals(dateLabel, dateItem.label);
		assertEquals(dateValue, dateItem.value);
		
		val locationItem = volcanoBox.rBoxItem(2)
		assertEquals(locationLabel, locationItem.label);
		assertEquals(locationBox, locationItem.value);
	}
	
	@Test
	def void shouldFailOnSelfReferencingIncludedBox() {
		'''
			foo {}
			[foo] as bar
			baz {
			  [foo] as theFoo
			  [bar] as theBar
			  [theBar] as theBarAgain 
			}
		'''.parse.assertNoErrors
		
		'''
			foo {}
			[foo] as _foo
			baz {
			  [_foo] as foo
			}
		'''.parse.assertNoErrors
		
		'''
			[foo] as foo
		'''.parse.assertError(WokDslPackage.Literals.INCLUDED_BOX, 'org.eclipse.xtext.diagnostics.Diagnostic.Linking')
		
		'''
			foo {}    // not referencable because shadowed by baz.foo 
			baz {
			  [foo] as foo
			}
		'''.parse.assertError(WokDslPackage.Literals.INCLUDED_BOX, 'org.eclipse.xtext.diagnostics.Diagnostic.Linking')
	}

}