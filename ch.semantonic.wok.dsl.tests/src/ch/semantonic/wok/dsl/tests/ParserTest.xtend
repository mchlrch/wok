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
import ch.semantonic.wok.dsl.wokDsl.TextItem
import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(WokDslInjectorProvider))
class ParserTest {
	
	@Inject extension ParseHelper<DslRoot>
//	@Inject extension ValidationTestHelper

	@Test
	def void testParsing() {
		val model = '''
			Wikimania {
			  date : "8–10 August 2014"
			  location: "London"
			}
		'''.parse
		
		val box = model.getElements().get(0) as BasicBox
		Assert::assertEquals("Wikimania", box.getName())
		
		val item = box.getItems().get(0) as TextItem
		Assert::assertEquals("date", item.label);
		Assert::assertEquals("8–10 August 2014", item.value);
	}
	
//	@Test
//	def void testParsingAndLinking() {
//		'''
//			package example {
//			  entity MyEntity {
//			    property : String
//			    op foo(String s) : String {
//			    	this.property = s
//			    	return s.toUpperCase
//			    }
//			  }
//			}
//		'''.parse.assertNoErrors
//	}
//	
//	@Test
//	def void testParsingAndLinkingWithImports() {
//		'''
//			import java.util.List
//			package example {
//			  entity MyEntity {
//			    p : List<String>
//			  }
//			}
//		'''.parse.assertNoErrors
//	}
//	
//	@Test
//	def void testReturnTypeInference() {
//		val model = '''
//			package example {
//			  entity MyEntity {
//			    property : String
//			    op foo(String s) {
//			    	return property.toUpperCase + s
//			    }
//			  }
//			}
//		'''.parse
//		val pack = model.elements.head as PackageDeclaration
//		val entity = pack.elements.head as Entity
//		val op = entity.features.last as Operation
//		val method = op.jvmElements.head as JvmOperation
//		Assert::assertEquals("String", method.returnType.simpleName)
//	}

}