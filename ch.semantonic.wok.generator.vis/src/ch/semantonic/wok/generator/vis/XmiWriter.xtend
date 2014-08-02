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
package ch.semantonic.wok.generator.vis

import java.util.List
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.mwe.core.WorkflowContext
import org.eclipse.emf.mwe.core.issues.Issues
import org.eclipse.emf.mwe.core.lib.AbstractWorkflowComponent2
import org.eclipse.emf.mwe.core.monitor.ProgressMonitor

class XmiWriter extends AbstractWorkflowComponent2 {

	@Property var String inSlot;

	override protected invokeInternal(WorkflowContext ctx, ProgressMonitor monitor, Issues issues) {
		val List<Object> in = ctx.get(inSlot) as List<Object>;

		if (! in.empty) {
			val ResourceSet rs = (in.iterator.next as EObject).eResource.resourceSet;
			val Resource xmiResource = rs.createResource(URI.createURI("dump.xmi"));

			for (res : rs.resources) {

				// TODO: so far it seems that explicit resolving is not necessary ...
				//			EcoreUtil.resolveAll(res);
				val dslModel = res.contents.get(0);
				xmiResource.getContents().add(dslModel);
			}

			try {
				xmiResource.save(null);
			} catch (Exception ex) {
				throw new RuntimeException(ex);
			}

		}
	}
}
