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
package ch.semantonic.wok.dsl.scoping

import ch.semantonic.wok.dsl.wokDsl.IncludedBox
import javax.inject.Inject
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.naming.IQualifiedNameProvider
import org.eclipse.xtext.scoping.IScope
import org.eclipse.xtext.scoping.impl.AbstractDeclarativeScopeProvider
import org.eclipse.xtext.scoping.impl.FilteringScope

/**
 * This class contains custom scoping description.
 * 
 * see : http://www.eclipse.org/Xtext/documentation.html#scoping
 * on how and when to use it 
 *
 */
class WokDslScopeProvider extends AbstractDeclarativeScopeProvider {
	
	@Inject extension IQualifiedNameProvider qNameProvider
	
	/**
	 * Prevent IncludedBox from referencing itself by removing itself from scope.
	 * Note that elements in parent scope can still be 
	 * {@link org.eclipse.xtext.scoping.impl.AbstractScope.ParentIterable shadowed} by context
	 */
	def IScope scope_IncludedBox_insert(IncludedBox context, EReference ref) {
		
		// filter out itself
		val ctxQName = context.fullyQualifiedName
		val origScope = delegateGetScope(context, ref);
		
        return new FilteringScope(origScope, [iod|iod.qualifiedName != ctxQName]);
	}

}
