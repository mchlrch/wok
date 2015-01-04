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

import ch.semantonic.wok.dsl.WokDslInjectorProvider
import ch.semantonic.wok.dsl.tests.WokDslTestExt
import ch.semantonic.wok.dsl.wokDsl.BasicBox
import ch.semantonic.wok.dsl.wokDsl.Box
import ch.semantonic.wok.dsl.wokDsl.DslRoot
import ch.semantonic.wok.dsl.wokDsl.IncludedBox
import com.google.common.base.Optional
import com.google.inject.Inject
import java.util.Arrays
import java.util.List
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.junit.Test
import org.junit.runner.RunWith

import static org.junit.Assert.assertEquals
import static org.junit.Assert.assertFalse
import static org.junit.Assert.assertTrue

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(WokDslInjectorProvider))
class BoxExtTest {
	
	@Inject extension ParseHelper<DslRoot>
	@Inject extension WokDslTestExt
	@Inject extension BoxExt

	@Test
	def void shouldGetItemsOfIncludedBox() {
		val model = '''
			a {
			  [m] as b  // includes basicBox 'm'
			  [r] as c  // includes non-cyclic IncludedBox 'r'
			  [x] as d  // includes cyclic IncludedBox 'x'
			}
			m {
			  t: "text"
			  n {}
			  refA: a
			  refX: x
			}
			[m] as r
			[a] as x  // cycle!
		'''.parse
		
		val a = model.element(0) as BasicBox
		val m = model.element(1) as BasicBox
		val r = model.element(2) as IncludedBox
		val x = model.element(3) as IncludedBox
		
		val b = a.cBoxItem(0).value as IncludedBox
		val c = a.cBoxItem(1).value as IncludedBox
		val d = a.cBoxItem(2).value as IncludedBox
		
		// do a cheap sanity check
		assertEquals("a", a.name)
		assertEquals("b", b.name)
		assertEquals("c", c.name)
		assertEquals("d", d.name)
		assertEquals("m", m.name)
		assertEquals("r", r.name)
		assertEquals("x", x.name)
		
		assertEquals(4, b.items.size)
		assertEquals(4, c.items.size)
		assertEquals(0, d.items.size)
		
		assertEquals(1, b.containedBoxes.size)
		assertEquals(1, c.containedBoxes.size)
		assertEquals(0, d.containedBoxes.size)
		
		assertEquals(2, b.referencedBoxes.size)
		assertEquals(2, c.referencedBoxes.size)
		assertEquals(0, d.referencedBoxes.size)
	}

	@Test
	def void shouldFindRealContainmentPaths() {
		val model = '''
			a {
			  b {}
			  c { d {}}
			}
			x {}
		'''.parse
		
		val a = model.element(0) as BasicBox
		val x = model.element(1) as BasicBox
		
		val b = a.cBoxItem(0).value
		val c = a.cBoxItem(1).value as BasicBox
		val d = c.cBoxItem(0).value		
		
		// do a cheap sanity check
		assertEquals("a", a.name)
		assertEquals("b", b.name)
		assertEquals("c", c.name)
		assertEquals("d", d.name)
		assertEquals("x", x.name)
		
		a.containmentPathFrom(a).assertEqualTo(a);
		b.containmentPathFrom(b).assertEqualTo(b);
		c.containmentPathFrom(c).assertEqualTo(c);
		d.containmentPathFrom(d).assertEqualTo(d);
		x.containmentPathFrom(x).assertEqualTo(x);		
				
		b.containmentPathFrom(a).assertEqualTo(a, b)
		c.containmentPathFrom(a).assertEqualTo(a, c)
		
		d.containmentPathFrom(c).assertEqualTo(c, d)
		d.containmentPathFrom(a).assertEqualTo(a, c, d)
		
		a.containmentPathFrom(b).assertAbsent;
		a.containmentPathFrom(c).assertAbsent;
		a.containmentPathFrom(d).assertAbsent;
		a.containmentPathFrom(x).assertAbsent;
		
		b.containmentPathFrom(c).assertAbsent;
		b.containmentPathFrom(x).assertAbsent;
		
		c.containmentPathFrom(b).assertAbsent;
		c.containmentPathFrom(d).assertAbsent;
		
		x.containmentPathFrom(a).assertAbsent;
		
		assertTrue(a.freeOfCycles)
		assertTrue(x.freeOfCycles)
	}
	
	@Test
	def void shouldFindVirtualContainmentPaths() {
		val model = '''
			a {
			  [x] as b
			  [r] as c
			}
			[x] as r
			x {}
		'''.parse
		
		val a = model.element(0) as BasicBox
		val r = model.element(1) as IncludedBox
		val x = model.element(2) as BasicBox
		
		val b = a.cBoxItem(0).value
		val c = a.cBoxItem(1).value
		
		// do a cheap sanity check
		assertEquals("a", a.name)
		assertEquals("b", b.name)
		assertEquals("c", c.name)
		assertEquals("r", r.name)
		assertEquals("x", x.name)
		
		x.containmentPathFrom(b).assertEqualTo(b, x);
		x.containmentPathFrom(a).assertEqualTo(a, b, x);
		
		r.containmentPathFrom(c).assertEqualTo(c, r);
		r.containmentPathFrom(a).assertEqualTo(a, c, r);
		
		x.containmentPathFrom(r).assertEqualTo(r, x);
		x.containmentPathFrom(c).assertEqualTo(c, r, x);
		
		b.containmentPathFrom(x).assertAbsent;
		a.containmentPathFrom(x).assertAbsent;
		
		c.containmentPathFrom(r).assertAbsent;
		a.containmentPathFrom(r).assertAbsent;
		
		r.containmentPathFrom(x).assertAbsent;
		c.containmentPathFrom(x).assertAbsent;
		
		assertTrue(a.freeOfCycles)
		assertTrue(r.freeOfCycles)
		assertTrue(x.freeOfCycles)
	}
	
	@Test
	def void shouldHandleCyclicContainmentPaths() {
		val model = '''
			[m] as n
			m {
			  [n] as o
			}
			
			a {
			  [x] as b
			}
			x {
			  [z] as y
			}
			[a] as z
			
			[u] as v
			[v] as u
		'''.parse
		
		val n = model.element(0) as IncludedBox
		val m = model.element(1) as BasicBox
		val a = model.element(2) as BasicBox
		val x = model.element(3) as BasicBox
		val z = model.element(4) as IncludedBox
		val v = model.element(5) as IncludedBox
		val u = model.element(6) as IncludedBox
		
		val o = m.cBoxItem(0).value
		val b = a.cBoxItem(0).value
		val y = x.cBoxItem(0).value
		
		// do a cheap sanity check
		assertEquals("n", n.name)
		assertEquals("m", m.name)
		assertEquals("o", o.name)
		assertEquals("a", a.name)
		assertEquals("b", b.name)
		assertEquals("x", x.name)
		assertEquals("y", y.name)
		assertEquals("z", z.name)
		assertEquals("v", v.name)
		assertEquals("u", u.name)
		
		m.containmentPathFrom(o).assertEqualTo(o, n, m);
				
		a.containmentPathFrom(b).assertEqualTo(b, x, y, z, a);
		
		v.containmentPathFrom(u).assertEqualTo(u, v);
		u.containmentPathFrom(v).assertEqualTo(v, u);
		
		assertFalse(n.freeOfCycles)
		assertFalse(m.freeOfCycles)
		assertFalse(o.freeOfCycles)
		
		assertFalse(a.freeOfCycles)
		assertFalse(b.freeOfCycles)
		assertFalse(x.freeOfCycles)
		assertFalse(y.freeOfCycles)
		assertFalse(z.freeOfCycles)
				
		assertFalse(v.freeOfCycles)
		assertFalse(u.freeOfCycles)
	}	
	
	def void assertAbsent(Optional<List<Box>> containmentPath) {
		assertFalse(containmentPath.present)
	}
	
	def void assertEqualTo(Optional<List<Box>> containmentPath, Box... pathElements) {
		assertTrue(containmentPath.present)		
		assertEquals(Arrays.asList(pathElements), containmentPath.get)
	}

}